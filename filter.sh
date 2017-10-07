#/bin/bash

# spent some time re-learning sed. Having to do this in stages,
# makes a lot of intermediate files that need to be cleaned up
# at the end; it's not the most efficient way to run large lists.
# This method probably captures a lot of false positives, there
# is probably a defined "field" for userid/handle in the .csv
# but some of the structure in the source file I had as:
# DSAstylodata was malformed; missing double-quotes, etc.
# so I was able to remove RT's but I probably am capturing
# mentions. I think I'm omitting email domains. 

#I tried capturing url's in a separate file but I was getting
#something wrong.

#separate fields to their own lines
sed 's/,/\n/g' $1 > nocomms.txt

#extract URLs
#needs work
#sed 's/^.*\(http.*\)["|,]./\1/g' nocomms.txt > nobuturls.txt

# get rid of double quotes too
sed 's/"/\n/g' nocomms.txt > nodqs.txt


# blow away RT's
sed 's/^"*RT @[a-zA-Z0-9_]\{1,15\}: //g' nodqs.txt > norts.txt

#extract handles
sed 's/@/\n@/g' norts.txt > noprehand.txt
sed 's/^[^@].*$//g' noprehand.txt > noother.txt
sed 's/^$//g' noother.txt > noempty.txt
sed 's/^\(@[a-zA-Z0-9_]\{1,15\}\).*$/\1/g' noempty.txt > nobuthand.txt
sed 's/^@ .*$//g' nobuthand.txt > nobadhand.txt
cat nobadhand.txt | grep '@' > presort.txt
cat presort.txt | sort -n > postsort.txt
awk '!a[$0]++' postsort.txt > handlist.txt
sed 's/@//g' handlist.txt > useridlist.txt


#cleanup
rm nocomms.txt nodqs.txt norts.txt noprehand.txt noother.txt noempty.txt nobuthand.txt nobadhand.txt presort.txt postsort.txt handlist.txt


