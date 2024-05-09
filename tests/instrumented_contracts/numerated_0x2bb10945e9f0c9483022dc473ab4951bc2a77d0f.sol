1 pragma solidity ^0.4.17;
2 
3 //
4 // Swarm Voting MVP
5 // Single use contract to manage liquidity vote shortly after Swarm TS
6 // Author: Max Kaye
7 //
8 //
9 // Architecture:
10 // * Ballot authority declares public key with which to encrypt ballots
11 // * Users submit encrypted ballots as blobs
12 // * These ballots are tracked by the ETH address of the sender
13 // * Following the conclusion of the ballot, the secret key is provided
14 //   by the ballot authority, and all users may transparently and
15 //   independently validate the results
16 //
17 // Notes:
18 // * Since ballots are encrypted the only validation we can do is length
19 //
20 
21 
22 contract SwarmVotingMVP {
23     //// ** Storage Variables
24 
25     // Std owner pattern
26     address public owner;
27 
28     // test mode - operations like changing start/end times
29     bool public testMode = false;
30 
31     // Maps to store ballots, along with corresponding log of voters.
32     // Should only be modified through `addBallotAndVoter` internal function
33     mapping(uint256 => bytes32) public encryptedBallots;
34     mapping(uint256 => bytes32) public associatedPubkeys;
35     mapping(uint256 => address) public associatedAddresses;
36     uint256 public nVotesCast = 0;
37 
38     // Use a map for voters to look up their ballot
39     mapping(address => uint256) public voterToBallotID;
40 
41     // Public key with which to encrypt ballots - curve25519
42     bytes32 public ballotEncryptionPubkey;
43 
44     // Private key to be set after ballot conclusion - curve25519
45     bytes32 public ballotEncryptionSeckey;
46     bool seckeyRevealed = false;
47 
48     // Timestamps for start and end of ballot (UTC)
49     uint256 public startTime;
50     uint256 public endTime;
51 
52     // Banned addresses - necessary to ban Swarm Fund from voting in their own ballot
53     mapping(address => bool) public bannedAddresses;
54     // TODO: Is this the right address?
55     address public swarmFundAddress = 0x8Bf7b2D536D286B9c5Ad9d99F608e9E214DE63f0;
56 
57 
58     //// ** Events
59     event CreatedBallot(address creator, uint256 start, uint256 end, bytes32 encPubkey);
60     event FailedVote(address voter, string reason);
61     event SuccessfulVote(address voter, bytes32 ballot, bytes32 pubkey);
62     event SeckeyRevealed(bytes32 secretKey);
63     event TestingEnabled();
64     event Error(string error);
65 
66 
67     //// ** Modifiers
68 
69     modifier notBanned {
70         if (!bannedAddresses[msg.sender]) {  // ensure banned addresses cannot vote
71             _;
72         } else {
73             Error("Banned address");
74         }
75     }
76 
77     modifier onlyOwner {
78         if (msg.sender == owner) {  // fail if msg.sender is not the owner
79             _;
80         } else {
81             Error("Not owner");
82         }
83     }
84 
85     modifier ballotOpen {
86         if (block.timestamp > startTime && block.timestamp < endTime) {
87             _;
88         } else {
89             Error("Ballot not open");
90         }
91     }
92 
93     modifier onlyTesting {
94         if (testMode) {
95             _;
96         } else {
97             Error("Testing disabled");
98         }
99     }
100 
101     //// ** Functions
102 
103     // Constructor function - init core params on deploy
104     function SwarmVotingMVP(uint256 _startTime, uint256 _endTime, bytes32 _encPK, bool enableTesting) public {
105         owner = msg.sender;
106 
107         startTime = _startTime;
108         endTime = _endTime;
109         ballotEncryptionPubkey = _encPK;
110 
111         bannedAddresses[swarmFundAddress] = true;
112 
113         if (enableTesting) {
114             testMode = true;
115             TestingEnabled();
116         }
117     }
118 
119     // Ballot submission
120     function submitBallot(bytes32 encryptedBallot, bytes32 senderPubkey) notBanned ballotOpen public {
121         addBallotAndVoter(encryptedBallot, senderPubkey);
122     }
123 
124     // Internal function to ensure atomicity of voter log
125     function addBallotAndVoter(bytes32 encryptedBallot, bytes32 senderPubkey) internal {
126         uint256 ballotNumber = nVotesCast;
127         encryptedBallots[ballotNumber] = encryptedBallot;
128         associatedPubkeys[ballotNumber] = senderPubkey;
129         associatedAddresses[ballotNumber] = msg.sender;
130         voterToBallotID[msg.sender] = ballotNumber;
131         nVotesCast += 1;
132         SuccessfulVote(msg.sender, encryptedBallot, senderPubkey);
133     }
134 
135     // Allow the owner to reveal the secret key after ballot conclusion
136     function revealSeckey(bytes32 _secKey) onlyOwner public {
137         require(block.timestamp > endTime);
138 
139         ballotEncryptionSeckey = _secKey;
140         seckeyRevealed = true;  // this flag allows the contract to be locked
141         SeckeyRevealed(_secKey);
142     }
143 
144     // Helpers
145     function getEncPubkey() public constant returns (bytes32) {
146         return ballotEncryptionPubkey;
147     }
148 
149     function getEncSeckey() public constant returns (bytes32) {
150         return ballotEncryptionSeckey;
151     }
152 
153     function getBallotOptions() public pure returns (uint8[2][4]) {
154         // NOTE: storing a 4x2 array in storage nearly doubled the gas cost
155         // of deployment - compromise is to create a constant function
156         return [
157             [8, 42],
158             [42, 8],
159             [16, 42],
160             [4, 84]
161         ];
162     }
163     
164     // ballot params - allows the frontend to do some checking
165     function getBallotOptNumber() public pure returns (uint256) {
166         return 4;
167     }
168 
169     // Test functions
170     function setEndTime(uint256 newEndTime) onlyTesting onlyOwner public {
171         endTime = newEndTime;
172     }
173 
174     function banAddress(address _addr) onlyTesting onlyOwner public {
175         bannedAddresses[_addr] = true;
176     }
177 }