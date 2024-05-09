1 contract SHA3_512 {
2    function hash(uint64[8]) pure public returns(uint32[16]) {}
3 }
4 
5 contract TeikhosBounty {
6 
7     address public bipedaljoe = 0x4c5D24A7Ca972aeA90Cc040DA6770A13Fc7D4d9A; // In case no one submits the correct solution, the bounty is sent to me
8 
9     SHA3_512 public sha3_512 = SHA3_512(0xbD6361cC42fD113ED9A9fdbEDF7eea27b325a222); // Mainnet: 0xbD6361cC42fD113ED9A9fdbEDF7eea27b325a222, 
10                                                                                      // Rinkeby: 0x2513CF99E051De22cEB6cf5f2EaF0dc4065c8F1f
11 
12     struct Commit {
13         uint timestamp;
14         bytes signature;
15     }    
16 
17     mapping(address => Commit) public commitment;
18 
19     struct Solution {
20         uint timestamp;
21         bytes publicKey; // The key that solves the bounty, empty until the correct key has been submitted with authenticate()
22         bytes32 msgHash;
23     }    
24 
25     Solution public isSolved;
26     
27     struct Winner {
28         uint timestamp;
29         address winner;
30     }
31 
32     Winner public winner;
33 
34     enum State { Commit, Reveal, Payout }
35     
36     modifier inState(State _state)
37     {
38         if(_state == State.Commit) { require(isSolved.timestamp == 0); }
39         if(_state == State.Reveal) { require(isSolved.timestamp != 0 && now < isSolved.timestamp + 7 days); }
40         if(_state == State.Payout) { require(isSolved.timestamp != 0 && now > isSolved.timestamp + 7 days); }
41         _;
42     }
43 
44     // Proof-of-public-key in format 2xbytes32, to support xor operator and ecrecover r, s v format
45     bytes32 public proof_of_public_key1 = hex"7b5f8ddd34df50d24e492bbee1a888122c1579e898eaeb6e0673156a1b97c24b";
46     bytes32 public proof_of_public_key2 = hex"26d64a34756bd684766dce3e6a8e8695a14a2b16d001559f4ae3a0849ac127fe";
47 
48     function commit(bytes _signature) public inState(State.Commit) {
49         require(commitment[msg.sender].timestamp == 0);
50         commitment[msg.sender].signature = _signature;
51         commitment[msg.sender].timestamp = now;
52     }
53 
54     function reveal() public inState(State.Reveal) {
55         bytes memory signature = commitment[msg.sender].signature;
56         require(signature.length != 0);
57 
58         bytes32 r;
59         bytes32 s;
60         uint8 v;
61 
62         assembly {
63         r := mload(add(signature,0x20))
64         s := mload(add(signature,0x40))
65         v := byte(0, mload(add(signature, 96)))
66         }
67 
68         if (v < 27) v += 27;
69 
70         if(ecrecover(isSolved.msgHash, v, r, s) == msg.sender) {
71             if(winner.timestamp == 0 || commitment[msg.sender].timestamp < winner.timestamp) {
72                 winner.winner = msg.sender;
73                 winner.timestamp = commitment[msg.sender].timestamp;
74             }
75         }
76         delete commitment[msg.sender];
77     }
78 
79     function reward() public inState(State.Payout) {
80         if(winner.winner != 0) selfdestruct(winner.winner);
81         else selfdestruct(bipedaljoe);
82     }
83 
84     function authenticate(bytes _publicKey) public inState(State.Commit) {
85         
86         // Remind people to commit before submitting the solution
87         require(commitment[msg.sender].timestamp != 0);
88         
89         bytes memory keyHash = getHash(_publicKey);
90          
91         // Split hash of public key in 2xbytes32, to support xor operator and ecrecover r, s v format
92 
93         bytes32 hash1;
94         bytes32 hash2;
95 
96         assembly {
97         hash1 := mload(add(keyHash,0x20))
98         hash2 := mload(add(keyHash,0x40))
99         }
100 
101         // Use xor (reverse cipher) to get signature in r, s v format
102         bytes32 r = proof_of_public_key1 ^ hash1;
103         bytes32 s = proof_of_public_key2 ^ hash2;
104 
105         // Get msgHash for use with ecrecover
106         bytes32 msgHash = keccak256("\x19Ethereum Signed Message:\n64", _publicKey);
107 
108         // Get address from public key
109         address signer = address(keccak256(_publicKey));
110 
111         // The value v is not known, try both 27 and 28
112         if(ecrecover(msgHash, 27, r, s) == signer || ecrecover(msgHash, 28, r, s) == signer ) {
113             isSolved.timestamp = now;
114             isSolved.publicKey = _publicKey; 
115             isSolved.msgHash = msgHash;
116         }
117     }
118 
119    // A separate method getHash() for converting bytes to uint64[8], which is done since the EVM cannot pass bytes between contracts
120    // The SHA3_512 logic is in a separate contract to make it easier to read, that contract could be audited on its own, and so on
121 
122    function getHash(bytes _message) view internal returns (bytes messageHash) {
123 
124         // Use SHA3_512 library to get a sha3_512 hash of public key
125 
126         uint64[8] memory input;
127 
128         // The evm is big endian, have to reverse the bytes
129 
130         bytes memory reversed = new bytes(64);
131 
132         for(uint i = 0; i < 64; i++) {
133             reversed[i] = _message[63 - i];
134         }
135 
136         for(i = 0; i < 8; i++) {
137             bytes8 oneEigth;
138             // Load 8 byte from reversed public key at position 32 + i * 8
139             assembly {
140                 oneEigth := mload(add(reversed, add(32, mul(i, 8)))) 
141             }
142             input[7 - i] = uint64(oneEigth);
143         }
144 
145         uint32[16] memory output = sha3_512.hash(input);
146         
147         bytes memory toBytes = new bytes(64);
148         
149         for(i = 0; i < 16; i++) {
150             bytes4 oneSixteenth = bytes4(output[15 - i]);
151             // Store 4 byte in keyHash at position 32 + i * 4
152             assembly { mstore(add(toBytes, add(32, mul(i, 4))), oneSixteenth) }
153         }
154 
155         messageHash = new bytes(64);
156 
157         for(i = 0; i < 64; i++) {
158             messageHash[i] = toBytes[63 - i];
159         }   
160    }
161    
162    // Make it possible to send ETH to the contract with "payable" on the fallback function
163    
164     function() public payable {}
165 
166 }