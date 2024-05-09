1 pragma solidity ^0.4.18;
2 
3 /** 
4  * BlackBox - Secure Ether Storage
5  * Proof Of Concept - Lock ether with a proof set derived off-chain.  The proof
6  * encodes a blinded receiver to accept funds once the correct caller executes 
7  * the unlockAmount() function with the correct seed.
8 */ 
9 
10 contract Secure {
11     enum Algorithm { sha, keccak }
12 
13     // function for off-chain proof derivation.  Use the return values as input for the 
14     // lockAmount() function.  Execute unlockAmount() with the correct caller 
15     // and seed to transfer funds to an encoded recipient.
16     function generateProof(
17         string seed,
18         address caller, 
19         address receiver,
20         Algorithm algorithm
21     ) pure public returns(bytes32 hash, bytes32 operator, bytes32 check, address check_receiver, bool valid) {
22         (hash, operator, check) = _escrow(seed, caller, receiver, algorithm);
23         check_receiver = address(hash_data(hash_seed(seed, algorithm), algorithm)^operator);
24         valid = (receiver == check_receiver);
25         if (check_receiver == 0) check_receiver = caller;
26     }
27 
28     function _escrow(
29         string seed, 
30         address caller, 
31         address receiver,
32         Algorithm algorithm
33     ) pure internal returns(bytes32 index, bytes32 operator, bytes32 check) {
34         require(caller != receiver && caller != 0);
35         bytes32 x = hash_seed(seed, algorithm);
36         if (algorithm == Algorithm.sha) {
37             index = sha256(x, caller);
38             operator = sha256(x)^bytes32(receiver);
39             check = x^sha256(receiver);
40         } else {
41             index = keccak256(x, caller);
42             operator = keccak256(x)^bytes32(receiver);
43             check = x^keccak256(receiver);
44         }
45     }
46     
47     // internal function for hashing the seed
48     function hash_seed(
49         string seed, 
50         Algorithm algorithm
51     ) pure internal returns(bytes32) {
52         if (algorithm == Algorithm.sha) {
53             return sha256(seed);
54         } else {
55             return keccak256(seed);
56         }
57     }
58     
59    // internal function for hashing bytes
60     function hash_data(
61         bytes32 key, 
62         Algorithm algorithm
63     ) pure internal returns(bytes32) {
64         if (algorithm == Algorithm.sha) {
65             return sha256(key);
66         } else {
67             return keccak256(key);
68         }
69     }
70     
71     // internal function for hashing an address
72     function blind(
73         address addr,
74         Algorithm algorithm
75     ) pure internal returns(bytes32) {
76         if (algorithm == Algorithm.sha) {
77             return sha256(addr);
78         } else {
79             return keccak256(addr);
80         }
81     }
82     
83 }
84 
85 
86 contract BlackBox is Secure {
87     address public owner;
88 
89     // stored proof info
90     struct Proof {
91         uint256 balance;
92         bytes32 operator;
93         bytes32 check;
94     }
95     
96     mapping(bytes32 => Proof) public proofs;
97     mapping(bytes32 => bool) public used;
98     mapping(address => uint256) private donations;
99 
100     // events for audit purposes
101     event Unlocked(string _key, bytes32 _hash, address _receiver);
102     event Locked(bytes32 _hash, bytes32 _operator, bytes32 _check);
103     event Donation(address _from, uint256 value);
104     
105     function BlackBox() public {
106         owner = msg.sender;
107     }
108 
109     /// @dev lockAmount - Lock ether with a proof
110     /// @param hash Hash Key used to index the proof
111     /// @param operator A derived operator to encode the intended recipient
112     /// @param check A derived operator to check the operation
113     function lockAmount(
114         bytes32 hash,
115         bytes32 operator,
116         bytes32 check
117     ) public payable {
118         // protect invalid entries on value transfer
119         if (msg.value > 0) {
120             require(hash != 0 && operator != 0 && check != 0);
121         }
122         // check existence
123         require(!used[hash]);
124         // lock the ether
125         proofs[hash].balance = msg.value;
126         proofs[hash].operator = operator;
127         proofs[hash].check = check;
128         // track unique keys
129         used[hash] = true;
130         Locked(hash, operator, check);
131     }
132 
133     /// @dev unlockAmount - Verify a proof to transfer the locked funds
134     /// @param seed Secret used to derive the proof set
135     /// @param algorithm Hash algorithm type
136     function unlockAmount(
137         string seed,
138         Algorithm algorithm
139     ) public payable {
140         require(msg.value == 0);
141         bytes32 hash = 0x0;
142         bytes32 operator = 0x0;
143         bytes32 check = 0x0;
144         // calculate the proof
145         (hash, operator, check) = _escrow(seed, msg.sender, 0, algorithm);
146         // check existence
147         require(used[hash]);
148         // calculate the receiver and transfer
149         address receiver = address(proofs[hash].operator^operator);
150         // verify integrity of operation
151         require(proofs[hash].check^hash_seed(seed, algorithm) == blind(receiver, algorithm));
152         // check for valid transfer
153         if (receiver == address(this) || receiver == 0) receiver = msg.sender;
154         // get locked balance to avoid recursive attacks
155         uint bal = proofs[hash].balance;
156         // owner collecting donations
157         if (donations[msg.sender] > 0) {
158             bal += donations[msg.sender];
159             delete donations[msg.sender];
160         }
161         // delete the entry to free up memory
162         delete proofs[hash];
163         // check the balance to send to the receiver
164         if (bal <= this.balance && bal > 0) {
165             // transfer to receiver 
166             // this could fail if receiver is another contract, so fallback
167             if(!receiver.send(bal)){
168                 require(msg.sender.send(bal));
169             }
170         }
171         Unlocked(seed, hash, receiver);
172     }
173     
174     // deposits get stored for the owner
175     function() public payable {
176         require(msg.value > 0);
177         donations[owner] += msg.value;
178         Donation(msg.sender, msg.value);
179     }
180     
181 }