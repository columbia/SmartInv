1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract ReplaySafeSend {
6     // Fork oracle to use
7     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
8 
9     function safeSend(address etcAddress) returns(bool) {
10         if (!amIOnTheFork.forked() && etcAddress.send(msg.value)) {
11             return true;
12         }
13         throw; // don't accept value transfer, otherwise it would be trapped.
14     }
15 
16     // Reject value transfers.
17     function() {
18         throw;
19     }
20 }