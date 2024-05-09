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
47     bool allowSeckeyBeforeEndTime = false;
48 
49     // Timestamps for start and end of ballot (UTC)
50     uint256 public startTime;
51     uint256 public endTime;
52 
53     // Banned addresses - necessary to ban Swarm Fund from voting in their own ballot
54     mapping(address => bool) public bannedAddresses;
55     address public swarmFundAddress = 0x8Bf7b2D536D286B9c5Ad9d99F608e9E214DE63f0;
56 
57     bytes32[5] public optionHashes;
58 
59     //// ** Events
60     event CreatedBallot(address creator, uint256 start, uint256 end, bytes32 encPubkey, string o1, string o2, string o3, string o4, string o5);
61     event SuccessfulVote(address voter, bytes32 ballot, bytes32 pubkey);
62     event SeckeyRevealed(bytes32 secretKey);
63     event AllowEarlySeckey(bool allowEarlySeckey);
64     event TestingEnabled();
65     event Error(string error);
66 
67 
68     //// ** Modifiers
69 
70     modifier notBanned {
71         if (!bannedAddresses[msg.sender]) {  // ensure banned addresses cannot vote
72             _;
73         } else {
74             Error("Banned address");
75         }
76     }
77 
78     modifier onlyOwner {
79         if (msg.sender == owner) {  // fail if msg.sender is not the owner
80             _;
81         } else {
82             Error("Not owner");
83         }
84     }
85 
86     modifier ballotOpen {
87         if (block.timestamp >= startTime && block.timestamp < endTime) {
88             _;
89         } else {
90             Error("Ballot not open");
91         }
92     }
93 
94     modifier onlyTesting {
95         if (testMode) {
96             _;
97         } else {
98             Error("Testing disabled");
99         }
100     }
101 
102     //// ** Functions
103 
104     // Constructor function - init core params on deploy
105     function SwarmVotingMVP(uint256 _startTime, uint256 _endTime, bytes32 _encPK, bool enableTesting, bool _allowSeckeyBeforeEndTime, string opt1, string opt2, string opt3, string opt4, string opt5) public {
106         owner = msg.sender;
107 
108         startTime = _startTime;
109         endTime = _endTime;
110         ballotEncryptionPubkey = _encPK;
111 
112         bannedAddresses[swarmFundAddress] = true;
113 
114         optionHashes = [keccak256(opt1), keccak256(opt2), keccak256(opt3), keccak256(opt4), keccak256(opt5)];
115 
116         allowSeckeyBeforeEndTime = _allowSeckeyBeforeEndTime;
117         AllowEarlySeckey(_allowSeckeyBeforeEndTime);
118 
119         if (enableTesting) {
120             testMode = true;
121             TestingEnabled();
122         }
123 
124         CreatedBallot(msg.sender, _startTime, _endTime, _encPK, opt1, opt2, opt3, opt4, opt5);
125     }
126 
127     // Ballot submission
128     function submitBallot(bytes32 encryptedBallot, bytes32 senderPubkey) notBanned ballotOpen public {
129         addBallotAndVoter(encryptedBallot, senderPubkey);
130     }
131 
132     // Internal function to ensure atomicity of voter log
133     function addBallotAndVoter(bytes32 encryptedBallot, bytes32 senderPubkey) internal {
134         uint256 ballotNumber = nVotesCast;
135         encryptedBallots[ballotNumber] = encryptedBallot;
136         associatedPubkeys[ballotNumber] = senderPubkey;
137         associatedAddresses[ballotNumber] = msg.sender;
138         voterToBallotID[msg.sender] = ballotNumber;
139         nVotesCast += 1;
140         SuccessfulVote(msg.sender, encryptedBallot, senderPubkey);
141     }
142 
143     // Allow the owner to reveal the secret key after ballot conclusion
144     function revealSeckey(bytes32 _secKey) onlyOwner public {
145         if (allowSeckeyBeforeEndTime == false) {
146             require(block.timestamp > endTime);
147         }
148 
149         ballotEncryptionSeckey = _secKey;
150         seckeyRevealed = true;  // this flag allows the contract to be locked
151         SeckeyRevealed(_secKey);
152     }
153 
154     // Helpers
155     function getEncPubkey() public constant returns (bytes32) {
156         return ballotEncryptionPubkey;
157     }
158 
159     function getEncSeckey() public constant returns (bytes32) {
160         return ballotEncryptionSeckey;
161     }
162 
163     function getBallotOptions() public constant returns (bytes32[5]) {
164         return optionHashes;
165     }
166 
167     // ballot params - allows the frontend to do some checking
168     function getBallotOptNumber() public pure returns (uint256) {
169         return 5;
170     }
171 
172     // Test functions
173     function setEndTime(uint256 newEndTime) onlyTesting onlyOwner public {
174         endTime = newEndTime;
175     }
176 
177     function banAddress(address _addr) onlyTesting onlyOwner public {
178         bannedAddresses[_addr] = true;
179     }
180 }