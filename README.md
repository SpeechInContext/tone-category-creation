# tone-category-creation
Create tone categories in Praat based off of sampling of distributions in R

sampling.R samples from higher and lower frequency (Hz) distributions
either from a normal distribution or a skewed distribution.
Each trial contains 20 samples, and 20 trials are made using the default
settings.
This script outputs lists of the frequencies over the given trial to a text
file in the "samples" directory.

tone_creation.praat reads the text files in the "samples" directory and
concatenates pre-existing wav files (named after the frequency of their
tone) with silence inbetween.

The end result is sound files for any number of trials that shift their
frequency over the course of the trial, according to the distributions
they are sampled from.
