import sys
import subprocess
import json
import time

# delay should be ~5 sec if count is < 10
#.. when count is larger (~100-2000) stream-time
#.. is long enough to create a delay - this may
#.. vary depending on channel bandwidth; so run
#.. tests, to see if the run returns a 429 error.
#.. That is when the Twitter server rejects the
#.. GET request because there were too many from
#.. this requestor.

delay = 2
count = 2000
cmd = "./massmine/massmine"
arg1 = "--task=twitter-user"
arg2 = "--user="
arg3 = "--count="+str(count)


with open(sys.argv[1]) as targetlist:
    targets = targetlist.readlines()

targets = [i.strip() for i in targets]
for target in targets:
    pldj = {}
    payload = ""
    userprof = ""
    uprofj = {}
    mmout = ""
    mmtrm = ""
    mmarr = []
    time.sleep(delay)
    print(delay)
    print(target)
    print(count)
    mmout = subprocess.run([cmd, arg1, arg2+target, arg3], stdout=subprocess.PIPE)
    mmtrm = mmout.stdout.decode('utf-8')
    mmarr = mmtrm.split("\n")
    if (len(mmarr[0])>1):
        uprofj = json.loads(mmarr[0])
        with open(target+'_profile.txt', 'w') as f:
            userprof=str(uprofj['user'])
            f.write(userprof)
        f.close()
        with open(target+'_payload.txt','w') as f:       
            for i in range(len(mmarr)):
                #sometimes; json is empty, and that makes json.loads sad..
                if (len(mmarr[i])>1):
                    pldj = json.loads(mmarr[i])
                    payload = str("\n"+pldj['text']+"\n")
        #with open(target+'_payload.txt', 'w') as f:        
                f.write(payload)  
        f.close()
   
