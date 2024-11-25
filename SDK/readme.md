# Kinetic Data SDK Courses
## Overview 
This directory contains resources to be used with the Kinetic Data SDK Courses from Kinverge 2024. Each of the course directories contains examples and supporting documentation for the course.

Setup is required to use the example scripts provided.

## Introduction to the Kinetic SDK

Examples from the presentation are included for reference.

## SDK Interactive Hands-On Deep Dive

Each of the exercises from the presentation has a script example in the Exercises dirctory. There is a beginning and end state for each script example (excercise_XX_{begin OR end}.rb) The state of the script examples

The scripts leverage the Kinetic Ruby SDK as a gem. Docs can be found here https://rubygems.org/gems/kinetic_sdk

## Usage
This directory contains a directory for each of the courses.
- Introduction to the Kinetic Ruby SDK
- SDK Interactive Hands-On Deep Dive

## Requirements
- Ruby
- kinetic_sdk

## Optional
- Git (used for downloading this repository to your local machine.)
    - https://github.com/git-guides/install-git

## Setup for using the Kinetic Ruby SDK
- Download this repository to your local machine. 
    - Download and extract zip file. (https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github)
    - **OR**
    - Clone the respositiory into a local directory. 
      - (https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
- Ruby is required on the machine running the scripts (https://www.ruby-lang.org/en/documentation/installation/)
    - Follow instructions related to your OS type
    - Verify installation by running ```ruby -v``` from the command line.
- Kinetic SDK (https://rubygems.org/gems/kinetic_sdk)
    - Run ```gem install kinetic_sdk``` from the command line

### Setup for the SDK Interactive Hands-On Deep Dive Course
The "SDK Interactive Hands-On Deep Dive" has some setup required on a Kinetic Platform development server. We will create a new Kapp to help isolate the exercises from your other kapps and help particpants follow along in hands on exercises. 

Make the following changes in a development environment.
1. Create the kapp "SDK Course" for purpose of this course
2. Add Form Attribute Definition 
- Add "Owning Team"
3. Import the following forms from "..\kinverge-2024\sdk_interactive_hand_on_deep_dive\sdk_course_kapp\import_forms":
- general-facilities-request
- general-finance-request
- general-hr-request
- general-it-request
- general-legal-request
- general-marketing-request    