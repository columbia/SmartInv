1 contract AmIOnTheFork {
2     function forked() constant returns(bool);
3 }
4 
5 contract SplitterEtcToEth {
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
26     function SplitterEtcToEth() {
27         owner = msg.sender;
28     }
29 
30     function() {
31         //stop too small transactions
32         if (msg.value < lowLimit) throw;
33 
34         // always return value from FORK chain
35         if (amIOnTheFork.forked()) {
36             if (!msg.sender.send(msg.value)) throw;
37 
38         // process with exchange on the CLASSIC chain
39         } else {
40             // check that received less or equal to conversion up limit
41             if (msg.value <= upLimit) {
42                 if (!intermediate.send(msg.value)) throw;
43                 uint64 id = seq++;
44                 received[id] = Received(msg.sender, msg.value);
45                 OnReceive(id);
46             } else {
47                 // send only acceptable value, return rest
48                 if (!intermediate.send(upLimit)) throw;
49                 if (!msg.sender.send(msg.value - upLimit)) throw;
50                 uint64 idp = seq++;
51                 received[idp] = Received(msg.sender, upLimit);
52                 OnReceive(idp);
53             }
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