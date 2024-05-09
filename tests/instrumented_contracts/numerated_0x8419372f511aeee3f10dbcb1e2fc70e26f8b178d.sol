1 // Minimum required version of Solidity (Ethereum programming language)
2 pragma solidity ^0.4.0;
3 
4 // Soldity contract for proof of perception
5 contract Percept {
6 
7     mapping(bytes32 => Proof) public proofs;    // Proof storage mappings (key => value data)
8 
9     struct Proof {              // Proof data type
10         // Pre-release data
11         address creator;        // Address of the proof maker
12         bytes32 hash;           // 1-way hash of the proof text
13         uint timestamp;         // Unix timestamp of the proof's creation
14         uint blockNum;          // Latest block number during proof creation
15         bytes32 proofMapping;   // Mapping hash of sender address, timestamp, block number, and proof hash
16 
17         // Post-release data
18         string release;         // Proof string of perception
19         bool released;          // Whether this proof has been released or not
20         uint releaseTime;       // Unix timestamp of the proof's release
21         uint releaseBlockNum;   // Latest block number during proof release
22     }
23 
24     // Function to submit a new unreleased proof
25     // Param: hash (32 bytes) - Hash of the proof text
26     function submitProof(bytes32 hash) public returns (bytes32) {
27         uint timestamp = now;   // Current unix timestamp
28         uint blockNum = block.number;   // Current block number this transaction is in
29 
30         bytes32 proofMapping = keccak256(abi.encodePacked(msg.sender, timestamp, blockNum, hash));    // Mapping hash of proof data
31 
32         // Construct the proof in memory, unreleased
33         Proof memory proof = Proof(msg.sender, hash, timestamp, blockNum, proofMapping, "", false, 0, 0);
34 
35         // Store the proof in the contract mapping storage
36         proofs[proofMapping] = proof;
37         
38         return proofMapping; // Return the generated proof mapping
39     }
40 
41     // Release the contents of a submitted proof
42     // Param: proofMapping (32 bytes) - The key to lookup the proof
43     // Param: release (string) - The text that was originally hashed
44     function releaseProof(bytes32 proofMapping, string release) public {
45         // Load the unreleased proof from storage
46         Proof storage proof = proofs[proofMapping];
47 
48         require(msg.sender == proof.creator);       // Ensure the releaser was the creator
49         require(proof.hash == keccak256(abi.encodePacked(release)));  // Ensure the release string's hash is the same as the proof
50         require(!proof.released);                   // Ensure the proof isn't released yet
51 
52         proof.release = release;                // Release the proof text
53         proof.released = true;                  // Set proof released flag to true
54         proof.releaseTime = now;                // Set the release unix timestamp to now
55         proof.releaseBlockNum = block.number;   // Set the release block number to the current block number
56     }
57 
58     // Function to determine whether a proof is valid for a certain verification string
59     // Should not be called on blockchain, only on local cache
60     // Param: proofMapping (32 bytes) - The key to lookup the proof
61     // Param: verify (string) - The text that was supposedly originally hashed
62     function isValidProof(bytes32 proofMapping, string verify) public view returns (bool) {
63         Proof memory proof = proofs[proofMapping]; // Load the proof into memory
64 
65         require(proof.creator != 0); // Ensure the proof exists
66 
67         return proof.hash == keccak256(abi.encodePacked(verify)); // Return whether the proof hash matches the verification's hash
68     }
69 
70     // Functon to retrieve a proof that has not been completed yet
71     // Should not be called on blockchain, only on local hash
72     // Param: proofMapping (32 bytes) - The key to lookup the proof
73     function retrieveIncompleteProof(bytes32 proofMapping) public view returns (
74         address creator,
75         bytes32 hash,
76         uint timestamp,
77         uint blockNum
78     ) {
79         Proof memory proof = proofs[proofMapping];  // Load the proof into memory
80         require(proof.creator != 0);                // Ensure the proof exists
81         require(!proof.released);                   // Ensure the proof has not been released
82 
83         // Return the collective proof data individually
84         return (
85             proof.creator,
86             proof.hash,
87             proof.timestamp,
88             proof.blockNum
89         );
90     }
91 
92     // Functon to retrieve a proof that has been completed
93     // Should not be called on blockchain, only on local hash
94     // Param: proofMapping (32 bytes) - The key to lookup the proof
95     function retrieveCompletedProof(bytes32 proofMapping) public view returns (
96         address creator,
97         string release,
98         bytes32 hash,
99         uint timestamp,
100         uint releaseTime,
101         uint blockNum,
102         uint releaseBlockNum
103     ) {
104         Proof memory proof = proofs[proofMapping];  // Load the proof into memory
105         require(proof.creator != 0);                // Ensure the proof exists
106         require(proof.released);                    // Ensure the proof has been released
107 
108         // Return the collective proof data individually
109         return (
110             proof.creator,
111             proof.release,
112             proof.hash,
113             proof.timestamp,
114             proof.releaseTime,
115             proof.blockNum,
116             proof.releaseBlockNum
117         );
118     }
119 
120 }