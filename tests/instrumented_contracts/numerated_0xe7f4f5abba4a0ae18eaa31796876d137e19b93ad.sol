1 contract ChainSensitive {
2     // store the data for long-term usability
3     uint256 public afterForkBlockNumber;
4     uint256 public afterForkRescueContractBalance;
5 
6     // pre-fork: return 0
7     // puritanical: return 1
8     // dao-rescue (hard forked): return 2
9     function whichChainIsThis() internal returns (uint8) {
10         if (block.number >= 1920000) {
11             if (afterForkBlockNumber == 0) { // default
12                 afterForkBlockNumber = block.number;
13                 afterForkRescueContractBalance = address(0xbf4ed7b27f1d666546e30d74d50d173d20bca754).balance;
14             }
15             if (afterForkRescueContractBalance < 1000000 ether) {
16                 return 1; // puritanical chain
17             } else {
18                 return 2; // hard-forked dao-rescue chain
19             }
20         } else {
21             return 0; // pre-fork
22         }
23     }
24 
25     function() {
26         secureSend(msg.sender);
27         whichChainIsThis();  // store data if not stored yet
28     }
29 
30     function secureSend(address to) internal {
31         if (!to.send(msg.value))
32             throw;
33     }
34 
35     function isThisPreforkVersion() returns (bool) {
36         secureSend(msg.sender);
37         return whichChainIsThis() == 0;
38     }
39     
40     function isThisPuritanicalVersion() returns (bool) {
41         secureSend(msg.sender);
42         return whichChainIsThis() == 1;
43     }
44 
45     function isThisHardforkedVersion() returns (bool) {
46         secureSend(msg.sender);
47         return whichChainIsThis() == 2;
48     }
49 
50     function transferIfPuritanical(address to) {
51         if (whichChainIsThis() == 1) {
52             secureSend(to);
53         } else {
54             secureSend(msg.sender);
55         }
56     }
57 
58     function transferIfHardForked(address to) {
59         if (whichChainIsThis() == 2) {
60             secureSend(to);
61         } else {
62             secureSend(msg.sender);
63         }
64     }
65 }