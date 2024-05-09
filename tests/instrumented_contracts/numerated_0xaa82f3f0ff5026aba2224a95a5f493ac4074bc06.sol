1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4 
5 	// Contract's owner.
6 	address owner;
7 
8 	modifier onlyOwner() {
9 		require (msg.sender == owner);
10 		_;
11 	}
12 
13 	// Constructor.
14 	function Ownable() public {
15 		owner = msg.sender;
16 	}
17 
18 	// Returns current contract's owner.
19 	function getOwner() public constant returns(address) {
20 		return owner;
21 	}
22 
23 	// Transfers contract's ownership.
24 	function transferOwnership(address newOwner) onlyOwner public {
25 		require(newOwner != address(0));
26 		owner = newOwner;
27 	}
28 }
29 
30 contract ICKBase {
31 
32 	function ownerOf(uint256) public pure returns (address);
33 }
34 
35 contract IKittyKendoStorage {
36 
37 	function createProposal(uint proposal, address proposalOwner) public;
38 	function createVoter(address account) public;
39 
40 	function updateProposalOwner(uint proposal, address voter) public;
41 
42 	function voterExists(address voter) public constant returns (bool);
43 	function proposalExists(uint proposal) public constant returns (bool);
44 
45 	function proposalOwner(uint proposal) public constant returns (address);
46 	function proposalCreateTime(uint proposal) public constant returns (uint);
47 
48 	function voterVotingTime(address voter) public constant returns (uint);
49 
50 	function addProposalVote(uint proposal, address voter) public;
51 	function addVoterVote(address voter) public;
52 
53 	function updateVoterTimes(address voter, uint time) public;
54 
55 	function getProposalTTL() public constant returns (uint);
56 	function setProposalTTL(uint time) public;
57 
58 	function getVotesPerProposal() public constant returns (uint);
59 	function setVotesPerProposal(uint votes) public;
60 
61 	function getTotalProposalsCount() public constant returns(uint);
62 	function getTotalVotersCount() public constant returns(uint);
63 
64 	function getProposalVotersCount(uint proposal) public constant returns(uint);
65 	function getProposalVotesCount(uint proposal) public constant returns(uint);
66 	function getProposalVoterVotesCount(uint proposal, address voter) public constant returns(uint);
67 
68 	function getVoterProposalsCount(address voter) public constant returns(uint);
69 	function getVoterVotesCount(address voter) public constant returns(uint);
70 	function getVoterProposal(address voter, uint index) public constant returns(uint);
71 }
72 
73 contract KittyKendoCore is Ownable {
74 
75 	IKittyKendoStorage kks;
76 	address kksAddress;
77 
78 	// Event is emitted when new votes have been recorded.
79 	event VotesRecorded (
80 		address indexed from,
81 		uint[] votes
82 	);
83 
84 	// Event is emitted when new proposal has been added.
85 	event ProposalAdded (
86 		address indexed from,
87 		uint indexed proposal
88 	);
89 
90 	// Registering fee.
91 	uint fee;
92 
93 	// Constructor.
94 	function KittyKendoCore() public {
95 		fee = 0;
96 		kksAddress = address(0);
97 	}
98 	
99 	// Returns storage's address.
100 	function storageAddress() onlyOwner public constant returns(address) {
101 		return kksAddress;
102 	}
103 
104 	// Sets storage's address.
105 	function setStorageAddress(address addr) onlyOwner public {
106 		kksAddress = addr;
107 		kks = IKittyKendoStorage(kksAddress);
108 	}
109 
110 	// Returns default register fee.
111 	function getFee() public constant returns(uint) {
112 		return fee;
113 	}
114 
115 	// Sets default register fee.
116 	function setFee(uint val) onlyOwner public {
117 		fee = val;
118 	}
119 
120 	// Contract balance withdrawal.
121 	function withdraw(uint amount) onlyOwner public {
122 		require(amount <= address(this).balance);
123 		owner.transfer(amount);
124 	}
125 	
126 	// Returns contract's balance.
127 	function getBalance() onlyOwner public constant returns(uint) {
128 	    return address(this).balance;
129 	}
130 
131 	// Registering proposal in replacement for provided votes.
132 	function registerProposal(uint proposal, uint[] votes) public payable {
133 
134 		// Value must be at least equal to default fee.
135 		require(msg.value >= fee);
136 
137 		recordVotes(votes);
138 
139 		if (proposal > 0) {
140 			addProposal(proposal);
141 		}
142 	}
143 
144 	// Recording proposals votes.
145 	function recordVotes(uint[] votes) private {
146 
147         require(kksAddress != address(0));
148 
149 		// Checking if voter already exists, otherwise adding it.
150 		if (!kks.voterExists(msg.sender)) {
151 			kks.createVoter(msg.sender);
152 		}
153 
154 		// Recording all passed votes from voter.
155 		for (uint i = 0; i < votes.length; i++) {
156 			// Checking if proposal exists.
157 			if (kks.proposalExists(votes[i])) {
158 				// Proposal owner can't vote for own proposal.
159 				require(kks.proposalOwner(votes[i]) != msg.sender);
160 
161 				// Checking if proposal isn't expired yet.
162 				if (kks.proposalCreateTime(votes[i]) + kks.getProposalTTL() <= now) {
163 					continue;
164 				}
165 
166 				// Voter can vote for each proposal only once.
167 				require(kks.getProposalVoterVotesCount(votes[i], msg.sender) == uint(0));
168 
169 				// Adding proposal's voter and updating total votes count per proposal.
170 				kks.addProposalVote(votes[i], msg.sender);
171 			}
172 
173 			// Recording vote per voter.
174 			kks.addVoterVote(msg.sender);
175 		}
176 
177 		// Updating voter's last voting time and updating create time for voter's proposals.
178 		kks.updateVoterTimes(msg.sender, now);
179 
180 		// Emitting event.
181 		VotesRecorded(msg.sender, votes);
182 	}
183 
184 	// Adding new voter's proposal.
185 	function addProposal(uint proposal) private {
186 
187         require(kksAddress != address(0));
188 
189 		// Only existing voters can add own proposals.
190 		require(kks.voterExists(msg.sender));
191 
192 		// Checking if voter has enough votes count to add own proposal.
193 		require(kks.getVoterVotesCount(msg.sender) / kks.getVotesPerProposal() > kks.getVoterProposalsCount(msg.sender));
194 
195 		// Prevent voter from adding own proposal's too often.
196 		//require(now - kks.voterVotingTime(msg.sender) > 1 minutes);
197 
198 		// Checking if proposal(i.e. Crypto Kitty Token) belongs to sender.
199 		require(getCKOwner(proposal) == msg.sender);
200 
201 		// Checking if proposal already exists.
202 		if (!kks.proposalExists(proposal)) {
203 			// Adding new proposal.
204 			kks.createProposal(proposal, msg.sender);
205 		} else {
206 			// Updating proposal's owner.
207 			kks.updateProposalOwner(proposal, msg.sender);
208 		}
209 
210 		// Emitting event.
211 		ProposalAdded(msg.sender, proposal);
212 	}
213 
214 	// Returns the CryptoKitty's owner address.
215 	function getCKOwner(uint proposal) private pure returns(address) {
216 		ICKBase ckBase = ICKBase(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);
217 		return ckBase.ownerOf(uint256(proposal));
218 	}
219 
220 }