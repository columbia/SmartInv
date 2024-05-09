1 contract RequiringFunds {
2     modifier NeedEth () {
3         if (msg.value <= 0 ) throw;
4         _
5     }
6 }
7 
8 contract AmIOnTheFork {
9     function forked() constant returns(bool);
10 }
11 
12 contract ReplaySafeSplit is RequiringFunds {
13     //address private constant oracleAddress = 0x8128B12cABc6043d94BD3C4d9B9455077Eb18807;    // testnet
14     address private constant oracleAddress = 0x2bd2326c993dfaef84f696526064ff22eba5b362;   // mainnet
15     
16     // Fork oracle to use
17     AmIOnTheFork amIOnTheFork = AmIOnTheFork(oracleAddress);
18 
19     // Splits the funds into 2 addresses
20     function split(address targetFork, address targetNoFork) NeedEth returns(bool) {
21         // The 2 checks are to ensure that users provide BOTH addresses
22         // and prevent funds to be sent to 0x0 on one fork or the other.
23         if (targetFork == 0) throw;
24         if (targetNoFork == 0) throw;
25 
26         if (amIOnTheFork.forked()                   // if we are on the fork 
27             && targetFork.send(msg.value)) {        // send the ETH to the targetFork address
28             return true;
29         } else if (!amIOnTheFork.forked()           // if we are NOT on the fork 
30             && targetNoFork.send(msg.value)) {      // send the ETH to the targetNoFork address 
31             return true;
32         }
33 
34         throw;                                      // don't accept value transfer, otherwise it would be trapped.
35     }
36 
37     // Reject value transfers.
38     function() {
39         throw;
40     }
41 }