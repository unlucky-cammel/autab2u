# autab2u
# AllUrTweetsRBelong2Us

*Current Version: 0.0.1 (2017-10-05)*

## Installation and Usage
(some of these are just preferential, adjust as necessary)
(different platforms may require use of "sudo", different libs, etc)
(building scheme is only necc. if you're building massmine, you can
install massmine binary instead if that works for you).
1. Begin with Docker (Kitematic is nice if you're not a Docker expert).
2. pull image: continuumio/anaconda3.
3. exec into running instance. default shell is sh, I switch to bash by typing `bash`.
4. change to home directory: `cd~`, (you are root).
5. begin with a working subdirectory: `mkdir tools`, `cd tools`.
6. Install some basic packages for build support:
`apt-get update`
`apt-get install build-essential autoconf checkinstall vim`
7. make a subdir for Chicken Scheme: `mkdir chk`, `cd chk`.
8. download and extract source tarball:
`wget https://code.call-cc.org/releases/4.12.0/chicken-4.12.0.tar.gz`
`tar -xvf chicken-4.12.0.tar.gz`
(release number may be different)
9. Build Chicken:
`make PLATFORM=linux PREFIX=/usr`
`make PLATFORM=linux PREFIX=/usr install`
`ln -s /usr/bin/csi /usr/local/bin/csi`
10. See massmine build instructions at massmine.org for ref; 
11. install ssl support (for auth tokens):
`apt-get install libssl-dev`
12. Install chicken-scheme egg modules to support massmine build:
(I couldn't get this to work unless I built Chicken from source)
`chicken-install clucker args openssl medea srfi-19 pathname-expand html-parser test`
13. Return to "tools" directory: `cd ~/tools`.
14. Make a massmine directory: `mkdir mm`. `cd mm`.
15. Clone massmine repository:
`git clone https://github.com/n3mo/massmine.git`
`cd massmine`
16. Test massmine:
(I never got the Wikipedia test to complete successfully)
`./massmine.scm --test ./tests/run.scm`
17. Build massmine:
`csc massmine.scm`
18. Run massmine to enter twitter authentication API tokens:
(this needs to be done manually, see massmine docs, you'll need
a twitter account with API tokens)
`./massmine --task=twitter-auth`
Tokens are now stored... where? not sure. 
19. Change to massmine "working directory": `cd ~/tools/mm`
20. ~/tools/mm is where we need mmdriver.py and the user id list. User ID List is a single-column list like this:
`trbrwstr`
`truthout`
`trystypants`
`turkopticon`
`twh`
`twincitiesdsa`
`twincitiesiww`
`tylerthecreator`
`ucsdComm`
`ucsdLibrary`
`uhshanti`
`unitehere100`
`us4vincentfort`
`valerieponzio`
`vchimhutu`
`veggie64_leslie`
`verrit`
`vickitickitavi`
`vidcopi`
`viktorbk`
`villagevoice`
`violinphoenix`
`voxdotcom`
21. mmdriver.py takes the user id list as an argument, and drives massmine to dump each user account like this:
`python mmdriver.py useridlist.txt`
22. For each user, mmdriver.py will dump two files; a <userid>_profile.txt, and a <userid>_payload.txt.
The _profile.txt is a json-formatted string of the twitter user-profile. 
The _payload.txt is the text-content of the tweets, concatenated as raw text with linefeeds. 
23. At the top of the mmdriver.py file are some constant declarations:
23. "delay" is used to insert a delay between each user iteration, to prevent getting kicked out by the server.
24. The error for when we're hitting the server to fast, is usually a 429 HTTP code. 5-10 seconds usually fixes it.
25. "count" is how many tweets PER USER we will dump. When count is below about 10-20 or so, "delay" is necessary.
26. When count is increased, the dump usually takes long enough that the delay is not necessary.
27. Other Caveats: there's no real error-handling here. Pretty bare-bones.
28. Invalid account names can return some error codes, we usually skip over those, report them to terminal.
29. Invalid output sometimes comes down; I test for length()>1 (character). If it's not, it's empty, and bad.
30. So we skip "bad" outputs, otherwise the json decoder crashes the whole thing and interrupts the batch. (annoying). 
31. Some tweets are found to have a "truncated":true flag set, and in this case, they're shortened. Twitter doesn't explain why. 

## About
AllUrTweets is a research tool designed to gather text for lexical or stylometric analysis; by other software.
This output filters the massmine output a great deal so much of the contextual data, like time and geotagging
is eliminated, so this would not be useful for other types of analysis; though it would be a fairly simple
matter to modify the mmdriver.py code based on the example, to target various fields, and create additional 
outputs. 
The other huge limitation is there isn't much linkage across entities, (just user id, via filename). 
To take advantage of that, it would probably be better to use the driver to attach to a database appropriate
for the type of research. 

## Stretch Goals
Maybe instead of using massmine, build our own lightweight targeted scraper, might be much faster to request smaller
pieces of data? (I don't actually know if the Twitter api works that way - it should). Pipeline the data straight to
a database, and analytic engine (once we figure out what kind of analysis actually works to 
reliably identify automated accounts).

A python-based scraper would also eliminate the manual API key entry step of setup, because we can just have those
in a config file that's read by the program. 

Also; figure out how to minimally configure the entire stack in a container that can be pulled from dockerhub, and
deployed in a kubernetes cluster when high-demand scaling of resources is needed. 







