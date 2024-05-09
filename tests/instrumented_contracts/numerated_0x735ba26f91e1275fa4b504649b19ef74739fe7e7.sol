1 contract SHA3_512 {
2    function hash(uint64[8]) pure public returns(uint32[16]) {}
3 }
4 
5 contract TeikhosBounty {
6 
7     SHA3_512 public sha3_512 = SHA3_512(0xbD6361cC42fD113ED9A9fdbEDF7eea27b325a222); // Mainnet: 0xbD6361cC42fD113ED9A9fdbEDF7eea27b325a222, 
8                                                                                      // Rinkeby: 0x2513CF99E051De22cEB6cf5f2EaF0dc4065c8F1f
9 
10     struct Commit {
11         uint timestamp;
12         bytes signature;
13     }    
14 
15     mapping(address => Commit) public commitment;
16 
17     struct Solution {
18         uint timestamp;
19         bytes publicKey; // The key that solves the bounty, empty until the correct key has been submitted with authenticate()
20         bytes32 msgHash;
21     }    
22 
23     Solution public isSolved;
24     
25     struct Winner {
26         uint timestamp;
27         address winner;
28     }
29 
30     Winner public winner;
31 
32     enum State { Commit, Reveal, Payout }
33     
34     modifier inState(State _state)
35     {
36         if(_state == State.Commit) { require(isSolved.timestamp == 0); }
37         if(_state == State.Reveal) { require(isSolved.timestamp != 0 && now < isSolved.timestamp + 7 days); }
38         if(_state == State.Payout) { require(isSolved.timestamp != 0 && now > isSolved.timestamp + 7 days); }
39         _;
40     }
41 
42     // Proof-of-public-key in format 2xbytes32, to support xor operator and ecrecover r, s v format
43 
44     struct PoPk {
45       bytes32 half1;
46       bytes32 half2;
47     }
48 
49     PoPk public proof_of_public_key;
50     
51     function TeikhosBounty() public { // Constructor funciton, runs when contract is deployed
52         proof_of_public_key.half1 = hex"ad683919450048215e7c10c3dc3ffca5939ec8f48c057cfe385c7c6f8b754aa7";
53         proof_of_public_key.half2 = hex"4ce337445bdc24ee86d6c2460073e5b307ae54cdef4b196c660d5ee03f878e81";
54     }
55 
56     function commit(bytes _signature) public inState(State.Commit) {
57         require(commitment[msg.sender].timestamp == 0);
58         commitment[msg.sender].signature = _signature;
59         commitment[msg.sender].timestamp = now;
60     }
61 
62     function reveal() public inState(State.Reveal) returns (bool success) {
63         bytes memory signature = commitment[msg.sender].signature;
64         require(signature.length != 0);
65 
66         bytes32 r;
67         bytes32 s;
68         uint8 v;
69 
70         assembly {
71         r := mload(add(signature,0x20))
72         s := mload(add(signature,0x40))
73         v := byte(0, mload(add(signature, 96)))
74         }
75 
76         if (v < 27) v += 27;
77 
78         if(ecrecover(isSolved.msgHash, v, r, s) == msg.sender) {
79 
80             success = true; // The correct solution was submitted
81 
82             if(winner.timestamp == 0 || commitment[msg.sender].timestamp < winner.timestamp) {
83                 winner.winner = msg.sender;
84                 winner.timestamp = commitment[msg.sender].timestamp;
85             }
86         }
87         delete commitment[msg.sender];
88 
89         return success;
90     }
91 
92     function reward() public inState(State.Payout) {
93         selfdestruct(winner.winner);
94     }
95 
96     function authenticate(bytes _publicKey) public inState(State.Commit) {
97                 
98         bytes memory keyHash = getHash(_publicKey);
99          
100         // Split hash of public key in 2xbytes32, to support xor operator and ecrecover r, s v format
101 
102         bytes32 hash1;
103         bytes32 hash2;
104 
105         assembly {
106         hash1 := mload(add(keyHash,0x20))
107         hash2 := mload(add(keyHash,0x40))
108         }
109 
110         // Use xor (reverse cipher) to get signature in r, s v format
111         bytes32 r = proof_of_public_key.half1 ^ hash1;
112         bytes32 s = proof_of_public_key.half2 ^ hash2;
113 
114         // Get msgHash for use with ecrecover
115         bytes32 msgHash = keccak256("\x19Ethereum Signed Message:\n64", _publicKey);
116 
117         // Get address from public key
118         address signer = address(keccak256(_publicKey));
119 
120         // The value v is not known, try both 27 and 28
121         if(ecrecover(msgHash, 27, r, s) == signer || ecrecover(msgHash, 28, r, s) == signer ) {
122             isSolved.timestamp = now;
123             isSolved.publicKey = _publicKey; 
124             isSolved.msgHash = msgHash;
125 
126             require(reveal() == true); // The correct solution has to have been commited, 
127                                        // prevents funds from getting locked in the contract
128         }
129     }
130 
131    // A separate method getHash() for converting bytes to uint64[8], which is done since the EVM cannot pass bytes between contracts
132    // The SHA3_512 logic is in a separate contract to make it easier to read, that contract could be audited on its own, and so on
133 
134    function getHash(bytes _message) view internal returns (bytes messageHash) {
135 
136         // Use SHA3_512 library to get a sha3_512 hash of public key
137 
138         uint64[8] memory input;
139 
140         // The evm is big endian, have to reverse the bytes
141 
142         bytes memory reversed = new bytes(64);
143 
144         for(uint i = 0; i < 64; i++) {
145             reversed[i] = _message[63 - i];
146         }
147 
148         for(i = 0; i < 8; i++) {
149             bytes8 oneEigth;
150             // Load 8 byte from reversed public key at position 32 + i * 8
151             assembly {
152                 oneEigth := mload(add(reversed, add(32, mul(i, 8)))) 
153             }
154             input[7 - i] = uint64(oneEigth);
155         }
156 
157         uint32[16] memory output = sha3_512.hash(input);
158         
159         bytes memory toBytes = new bytes(64);
160         
161         for(i = 0; i < 16; i++) {
162             bytes4 oneSixteenth = bytes4(output[15 - i]);
163             // Store 4 byte in keyHash at position 32 + i * 4
164             assembly { mstore(add(toBytes, add(32, mul(i, 4))), oneSixteenth) }
165         }
166 
167         messageHash = new bytes(64);
168 
169         for(i = 0; i < 64; i++) {
170             messageHash[i] = toBytes[63 - i];
171         }   
172    }
173    
174    // Make it possible to send ETH to the contract with "payable" on the fallback function
175    
176     function() public payable {}
177 
178 }