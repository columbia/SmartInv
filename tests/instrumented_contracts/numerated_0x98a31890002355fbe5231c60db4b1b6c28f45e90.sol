1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract SplitterEthToEtc {
6 
7     address intermediate;
8     address owner;
9 
10     // there is a limit accepted by exchange
11     uint256 public upLimit = 100 ether;
12     // and exchange costs, ignore small transactions
13     uint256 public lowLimit = 0.1 ether;
14 
15     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
16 
17     function SplitterEthToEtc() {
18         owner = msg.sender;
19     }
20 
21     function() {
22         //stop too small transactions
23         if (msg.value < lowLimit)
24             throw;
25 
26         if (amIOnTheFork.forked()) {
27             // process with exchange on the FORK chain
28             if (msg.value <= upLimit) {
29                 // can exchange, send to intermediate
30                 if (!intermediate.send(msg.value))
31                     throw;
32             } else {
33                 // too much, send only acceptable value, return rest
34                 if (!intermediate.send(upLimit))
35                     throw;
36                 if (!msg.sender.send(msg.value - upLimit))
37                     throw;
38             }
39         } else {
40             // always return value from CLASSIC chain
41             if (!msg.sender.send(msg.value))
42                 throw;
43         }
44     }
45 
46     function setIntermediate(address _intermediate) {
47         if (msg.sender != owner) throw;
48         intermediate = _intermediate;
49     }
50     function setUpLimit(uint _limit) {
51         if (msg.sender != owner) throw;
52         upLimit = _limit;
53     }
54     function setLowLimit(uint _limit) {
55         if (msg.sender != owner) throw;
56         lowLimit = _limit;
57     }
58 
59 }