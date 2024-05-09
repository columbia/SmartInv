1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract SplitterEthToEtc {
6 
7     event OnReceive(uint64);
8 
9     struct Received {
10         address from;
11         uint256 value;
12     }
13 
14     address intermediate;
15     address owner;
16     mapping (uint64 => Received) public received;
17     uint64 public seq = 1;
18 
19     // there is a limit accepted by exchange
20     uint256 public upLimit = 50 ether;
21     // and exchange costs, ignore small transactions
22     uint256 public lowLimit = 0.1 ether;
23 
24     AmIOnTheFork amIOnTheFork = AmIOnTheFork(0x2bd2326c993dfaef84f696526064ff22eba5b362);
25 
26     function SplitterEthToEtc() {
27         owner = msg.sender;
28     }
29 
30     function() {
31         //stop too small transactions
32         if (msg.value < lowLimit) throw;
33 
34         // process with exchange on the FORK chain
35         if (amIOnTheFork.forked()) {
36             // check that received less or equal to conversion up limit
37             if (msg.value <= upLimit) {
38                 if (!intermediate.send(msg.value)) throw;
39                 uint64 id = seq++;
40                 received[id] = Received(msg.sender, msg.value);
41                 OnReceive(id);
42             } else {
43                 // send only acceptable value, return rest
44                 if (!intermediate.send(upLimit)) throw;
45                 if (!msg.sender.send(msg.value - upLimit)) throw;
46                 uint64 idp = seq++;
47                 received[id] = Received(msg.sender, upLimit);
48                 OnReceive(id);
49             }
50 
51         // always return value from CLASSIC chain
52         } else {
53             if (!msg.sender.send(msg.value)) throw;
54         }
55     }
56 
57     function processed(uint64 _id) {
58         if (msg.sender != owner) throw;
59         delete received[_id];
60     }
61 
62     function setIntermediate(address _intermediate) {
63         if (msg.sender != owner) throw;
64         intermediate = _intermediate;
65     }
66     function setUpLimit(uint _limit) {
67         if (msg.sender != owner) throw;
68         upLimit = _limit;
69     }
70     function setLowLimit(uint _limit) {
71         if (msg.sender != owner) throw;
72         lowLimit = _limit;
73     }
74 
75 }