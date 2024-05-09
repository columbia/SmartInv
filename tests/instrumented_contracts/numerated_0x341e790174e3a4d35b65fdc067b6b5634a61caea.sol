1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 /**
6  * 
7  */
8 contract ReplaySafeSplit {
9     // Fork oracle to use
10     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
11 
12     // Splits the funds into 2 addresses
13     function split(address targetFork, address targetNoFork) returns(bool) {
14         if (amIOnTheFork.forked() && targetFork.send(msg.value)) {
15             return true;
16         } else if (!amIOnTheFork.forked() && targetNoFork.send(msg.value)) {
17             return true;
18         }
19         return false;
20     }
21 
22     // Reject value transfers.
23     function() {
24         throw;
25     }
26 }