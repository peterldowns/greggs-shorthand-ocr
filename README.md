# Gregg1916-A-Corpus-and-a-Novel-Approach-for-Optical-Gregg-Shorthand-Recognition 

This repository collects our code and corpus for Gregg shorthand recognition.  

Gregg shorthand is one of the shorthand languages that allows fast recording of information. Check this page for the details:  
https://en.wikipedia.org/wiki/Gregg_shorthand

The corpus in .\data is produced from a shorthand dictionary. Each word in the dictionary gets one image.  

The method admits some novelty by assembling methodologies from NLP and CV. The ingredients include:  
* A CNN-based feature extractor;  
* A character level RNN language model; 
* Image augmentation including scaling, shifting and rotation; 
* Information retrieval with Levenshtein distance;  
* The use of bleu score for information retrieval;  
* A 'bidirectionally weighted bleu' which takes into account two candidates.

The architecture goes as follows:  
* Feature extractor: a CNN extracts features from images;
* Decoder: initialized by the extracted features, two RNNs decodes from the forward and the backward direction respectively to yield a forward hypothesis and a backward hypothesis;
* Word retrieval: combining both hypotheses to retrieve the most promising word from the full vocabulary.  

A more fine-grained technical report will be added soon.

# Install

https://developer.apple.com/metal/tensorflow-plugin/

goes way faster if you do this inside the conda env on macos

otherwise just create a venv like usual
```
# python version 3.11.2
python3 -m venv ./venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt # locked to specific versions that have worked
```

then

```
python main.py
```
### Diary

Day 1: 2023-06-11 Thursday

Feels pretty cool to find code that does what I want. The only problem is, it's a few years out of date, there are no installation instructions or even  a `requirements.txt`, let alone one with pinned versions of things. That's going to make reproducing the results a pain in the butt. But, ok. Let's go.

Tried to set up a poetry environment. Poetry cannot solve for installing tensorflow, numpy, and keras at the same time. Seems... like I'm probably doing something wrong. But I can pip install these libraries at the same time, and then run main.py and get it complaining about missing config paths and folders and stuff, so I'm going to move forward without poetry. Oh well.

Set up the nix and direnv stuff to make it as easy as possible to actually get a virtualenv, and linters, and vscode settings. Looks like this author was using the .idea folder for some configs, and their commit history makes me think they're not really a software engineer, no information there.

The data folder... hmmm.... looks like a winzip archive. `unzip ./data/data.zip` seems to correctly deflate everything. But then the code complains because the `data/` folder has the archive data in it still. So move the archive to a different folder path, unzip command creates a pristine `data` dir, everything is good.

Looks like the author would selectively comment/uncomment sections of `main.py` to get it to do different things, instead of writing dedicated scripts or functions to make it easy to actually run. There is no committed model weights to load, but some calls to `dill` for dumping and loading. I'm going to have to piece this together.

I figured out how to install tensorflow on macOS that's gpu accelerated. Sick.

Current plan:
- get a version of the model trained and the weights dumped, even if the accuracy is garbage. First step is definitely getting the pipeline running.
- then, once i can (a) train, (b) dump weights, I'll (c) figure out how to load weights and evaluate the results
- then, switch task and get to structure. make nice functions and interfaces for doing (a) (b) (c), maybe even some CLI parsing to make it reaaaaaaaally simple. No more editing main.py in order to do this.
- then, now that we have end-to-end a/b/c, work on doing a longer training run and improving accuracy. may need to debug things with actual machine learning concepts -- up until this point it's purely software engineering.

>  3801/11585 [========>.....................] - ETA: 16:34 - loss: 2.7254 - accuracy: 0.1883

Ok, cool, we have some training happening, and it looks like the model weights are getting checkpointed. That's (a) accomplished. Going to stop here for the day.
