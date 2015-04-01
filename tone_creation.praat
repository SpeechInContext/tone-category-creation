main_dir$ = ""
num_trials = 20
trial_type$ = "higher"
dist_type$ = "normal"
samples_dir$ = main_dir$ + "samples/'dist_type$'/'trial_type$'/"

hz_dir$ = main_dir$ + "Audio/"


for it from 1 to num_trials
    in_name$ = samples_dir$+"'it'" + ".txt"
    Read Strings from raw text file... 'in_name$'

    string_name$ = "hzs"

    Rename... 'string_name$'

    num_strings = Get number of strings

    for is from 1 to num_strings
        select Strings 'string_name$'
        hz$ = Get string... 'is'
        filename$ = hz_dir$ + hz$ + ".wav"
        Read from file... 'filename$'
        if is != num_strings
                    Create Sound from formula... silence 1 0.0 0.55 44100 0
            endif
    endfor

    select all
    minus Strings hzs
    Concatenate
    out_name$ = main_dir$ + "output/'dist_type$'_'trial_type$'_'it'"+".wav"
    Save as WAV file... 'out_name$'
    select all
    Remove
endfor
