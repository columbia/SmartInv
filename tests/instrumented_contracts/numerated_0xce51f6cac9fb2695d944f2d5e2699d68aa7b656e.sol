1 pragma solidity ^0.4.15;
2 
3 contract helper {
4     
5     function eccVerify(bytes32 hash, uint8 curve, bytes32 r, bytes32 s) 
6         constant 
7         returns(address publicKey) {
8         publicKey = ecrecover(hash, curve, r, s);
9     }
10     
11     function calcBindedBlindHash3(string key, address receiver) 
12         constant returns(bytes32 lock) {
13         lock = sha3(sha3(key),receiver);
14     }
15     
16     function calcBindedBlindHash256(string key, address receiver) 
17         constant returns(bytes32 lock) {
18         lock = sha256(sha256(key),receiver);
19     }
20     
21     function calcDoubleBindedBlindHash3(string key, address caller, address receiver) 
22         constant returns(bytes32 lock) {
23         lock = sha3(sha3(sha3(key),caller),receiver);
24     }
25     
26     function calcDoubleBindedBlindHash256(string key, address caller, address receiver) 
27         constant returns(bytes32 lock) {
28         lock = sha256(sha256(sha256(key),caller),receiver);
29     }
30     
31     function hash_sha256(string key, uint rounds) 
32         constant returns(bytes32 sha256_hash) {
33         if (rounds == 0) rounds = 1;
34         sha256_hash = sha256(key);  
35         for (uint i = 0; i < rounds-1; i++) {
36             sha256_hash = sha256(sha256_hash);  
37         }
38     }
39     
40     function hash_sha3(string key, uint rounds)
41         constant returns(bytes32 sha3_hash) {
42         if (rounds == 0) rounds = 1;
43         sha3_hash = sha3(key);  
44         for (uint i = 0; i < rounds-1; i++) {
45             sha3_hash = sha3(sha3_hash);  
46         }
47     }
48     
49     function hash_ripemd160(string key, uint rounds)
50         constant returns(bytes32 r160_hash) {
51         if (rounds == 0) rounds = 1;
52         r160_hash = sha3(key);  
53         for (uint i = 0; i < rounds-1; i++) {
54             r160_hash = ripemd160(r160_hash);  
55         }
56     }
57 }
58 contract owned {
59     address public owner;
60     
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65     
66     function owned() { owner = msg.sender; }
67 }
68 
69 contract logger {
70     
71     event Unlock(address caller, string key, bytes32 proof);
72     event Deposit(address from, uint value);
73     event LogEvent(
74         uint num_event,
75         address from, 
76         bytes4 sig, 
77         bytes msgdata, 
78         uint time,
79         uint gasprice
80         );
81 }
82 
83 contract Locksmith is owned, logger, helper {
84     uint public nonce;
85     uint public m_proofs;
86     bool public didProve;
87     bytes32 public lock;
88     string public protocol = "set by strong10, verify by strong7";
89     
90     struct proof {
91         address prover;
92         address receiver;
93         string key;
94         bytes32 lock;
95     }
96     
97     mapping(uint => proof) public proofs;
98     
99     /* Constructor */
100     function Locksmith() {
101         owner = msg.sender;
102     }
103     
104     function setLock(bytes32 _lock, string _protocol) onlyOwner {
105         require(_lock != 0x0 && lock != _lock);
106         lock = _lock;
107         didProve = false;
108         if (bytes(_protocol).length > 0) protocol = _protocol;
109         logEvent();
110     }
111     
112     function unlock(string key, address receiver, bytes32 newLock, string _protocol) {
113         bytes32 k = sha3(sha3(key),msg.sender);
114         if (uint(receiver) > 0) k = sha3(k,receiver);
115         if (k == lock) {
116             if (uint(receiver) > 0) owner = receiver;
117             else owner = msg.sender;
118             
119             Unlock(msg.sender, key, lock);
120             
121             proofs[m_proofs].prover = msg.sender;
122             proofs[m_proofs].receiver = (uint(receiver) == 0 ? msg.sender:receiver);
123             proofs[m_proofs].key = key;
124             proofs[m_proofs].lock = lock;
125             m_proofs++;
126             lock = newLock;
127             didProve = (uint(newLock) == 0);
128             if (bytes(_protocol).length > 0) 
129                 protocol = _protocol;
130             if (this.balance > 0)
131                 require(owner.send(this.balance));
132         }
133         logEvent();
134     }
135     
136     function sendTo(address _to, uint value) onlyOwner {
137         require(didProve);
138         require(this.balance >= value && value > 0);
139         require(_to.send(value));
140         logEvent();
141     }
142     
143     function logEvent() internal {
144         LogEvent(nonce++, msg.sender, msg.sig, msg.data, now, tx.gasprice);
145     }
146  
147     function kill() onlyOwner { 
148         require(didProve);
149         selfdestruct(owner); 
150     }
151     
152     function() payable {
153         require(msg.value > 0);
154         Deposit(msg.sender, msg.value);
155     }
156     
157 }