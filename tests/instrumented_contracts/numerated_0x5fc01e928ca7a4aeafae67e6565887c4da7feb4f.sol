1 pragma solidity ^0.4.18;
2 
3 contract helper {
4     
5     function derive_sha256(string key, uint rounds) 
6         public pure returns(bytes32 hash){
7         if (rounds == 0) rounds = 1;
8         hash = sha256(key);  
9         for (uint i = 0; i < rounds-1; i++) {
10             hash = sha256(hash);  
11         }
12     }
13     
14     function blind_sha256(string key, address caller) 
15         public pure returns(bytes32 challenge){
16         challenge = sha256(sha256(key),caller);
17     }
18     
19     function double_blind_sha256(string key, address caller, address receiver) 
20         public pure returns(bytes32 challenge){
21         challenge = sha256(sha256(sha256(key),caller),receiver);
22     }
23     
24 }
25 contract owned {
26     address public owner;
27     
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32     
33     /* Constructor */
34     function owned() public {
35         owner = msg.sender;
36     }
37     
38 }
39 
40 contract QuantumLocksmith is owned, helper {
41     uint public m_pending;
42 
43     struct lock {
44         bool alive;
45         bool proven;
46         uint balance;
47         string protocol;
48         string key;
49         address owner;
50     }
51     
52     mapping(bytes32 => lock) public locks;
53 
54     // challenge the original owner validity
55     function QuantumLocksmith(bytes32 ownerChallenge) public payable {
56         require(uint(ownerChallenge) > 0);
57         locks[ownerChallenge].alive = true;
58         locks[ownerChallenge].balance = msg.value;
59         m_pending++;
60     }
61     
62     function lockDeposit(bytes32 challenge, string _protocol) public payable {
63         require(uint(challenge) > 0);
64         require(msg.value > 0);
65         require(!locks[challenge].alive);
66         locks[challenge].alive = true;
67         locks[challenge].balance = msg.value;
68         locks[challenge].owner = msg.sender;
69         m_pending++;
70         if (bytes(_protocol).length > 0) locks[challenge].protocol = _protocol;
71     }
72     
73     function unlockDeposit(
74         string key, 
75         address receiver
76     ) public {
77         require(bytes(key).length > 0);
78         // generate the challenge
79         bytes32 k = sha256(sha256(key),msg.sender);
80         address to = msg.sender;
81         if (uint(receiver) > 0) {
82             to = receiver;
83             k = sha256(k,receiver);
84         }
85         if (locks[k].alive && !locks[k].proven) 
86         {
87             locks[k].proven = true;
88             locks[k].key = key;
89             m_pending--;
90             uint sendValue = locks[k].balance;
91             if (sendValue > 0) {
92                 locks[k].balance = 0;
93                 require(to.send(sendValue));
94             }
95         }
96     }
97     
98     function depositToLock(bytes32 challenge) public payable {
99         require(challenge != 0x0);
100         require(msg.value > 0);
101         require(locks[challenge].alive && !locks[challenge].proven);
102         locks[challenge].balance += msg.value;
103     }
104     
105     // do not allow this
106     function() public payable { 
107         require(msg.value == 0);
108     }
109     
110     function kill(string key) public {
111         if (msg.sender == owner) {
112             bytes32 k = sha256(sha256(key),msg.sender);
113             if (locks[k].alive && !locks[k].proven) 
114                 selfdestruct(owner); 
115         }
116     }
117 }