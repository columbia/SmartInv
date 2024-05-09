1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract LedgerSplitSingle {
6     // Fork oracle to use
7     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
8 
9     // Splits the funds on a single chain
10     function split(bool forked, address target) returns(bool) {
11         if (amIOnTheFork.forked() && forked && target.send(msg.value)) {
12             return true;
13         } 
14         else
15         if (!amIOnTheFork.forked() && !forked && target.send(msg.value)) {
16             return true;
17         } 
18         throw; // don't accept value transfer, otherwise it would be trapped.
19     }
20 
21     // Reject value transfers.
22     function() {
23         throw;
24     }
25 }