1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract ReplaySafeSplit {
6     // Fork oracle to use
7     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
8 
9     // Splits the funds into 2 addresses
10     function split(address targetFork, address targetNoFork) returns(bool) {
11         if (amIOnTheFork.forked() && targetFork.send(msg.value)) {
12             return true;
13         } else if (!amIOnTheFork.forked() && targetNoFork.send(msg.value)) {
14             return true;
15         }
16         throw; // don't accept value transfer, otherwise it would be trapped.
17     }
18 
19     // Reject value transfers.
20     function() {
21         throw;
22     }
23 }