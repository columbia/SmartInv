1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract ReplaySafeSplit {
6     // Fork oracle to use
7     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
8 
9     event e(address a);
10 	
11     // Splits the funds into 2 addresses
12     function split(address targetFork, address targetNoFork) returns(bool) {
13         if (amIOnTheFork.forked() && targetFork.send(msg.value)) {
14 			e(targetFork);
15             return true;
16         } else if (!amIOnTheFork.forked() && targetNoFork.send(msg.value)) {
17 			e(targetNoFork);		
18             return true;
19         }
20         throw; // don't accept value transfer, otherwise it would be trapped.
21     }
22 
23     // Reject value transfers.
24     function() {
25         throw;
26     }
27 }