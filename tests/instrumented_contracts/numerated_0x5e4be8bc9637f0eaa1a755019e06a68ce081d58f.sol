1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-15
3 */
4 
5 pragma solidity ^0.5.16;
6 pragma experimental ABIEncoderV2;
7 
8 contract GovernorAlpha {
9     /// @notice The name of this contract
10     string public constant name = "Uniswap Governor Alpha";
11 
12     /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
13     function quorumVotes() public pure returns (uint) { return 40_000_000e18; } // 4% of Uni
14 
15     /// @notice The number of votes required in order for a voter to become a proposer
16     function proposalThreshold() public pure returns (uint) { return 10_000_000e18; } // 1% of Uni
17 
18     /// @notice The maximum number of actions that can be included in a proposal
19     function proposalMaxOperations() public pure returns (uint) { return 10; } // 10 actions
20 
21     /// @notice The delay before voting on a proposal may take place, once proposed
22     function votingDelay() public pure returns (uint) { return 1; } // 1 block
23 
24     /// @notice The duration of voting on a proposal, in blocks
25     function votingPeriod() public pure returns (uint) { return 40_320; } // ~7 days in blocks (assuming 15s blocks)
26 
27     /// @notice The address of the Uniswap Protocol Timelock
28     TimelockInterface public timelock;
29 
30     /// @notice The address of the Uniswap governance token
31     UniInterface public uni;
32 
33     /// @notice The total number of proposals
34     uint public proposalCount;
35 
36     struct Proposal {
37         /// @notice Unique id for looking up a proposal
38         uint id;
39 
40         /// @notice Creator of the proposal
41         address proposer;
42 
43         /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
44         uint eta;
45 
46         /// @notice the ordered list of target addresses for calls to be made
47         address[] targets;
48 
49         /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
50         uint[] values;
51 
52         /// @notice The ordered list of function signatures to be called
53         string[] signatures;
54 
55         /// @notice The ordered list of calldata to be passed to each call
56         bytes[] calldatas;
57 
58         /// @notice The block at which voting begins: holders must delegate their votes prior to this block
59         uint startBlock;
60 
61         /// @notice The block at which voting ends: votes must be cast prior to this block
62         uint endBlock;
63 
64         /// @notice Current number of votes in favor of this proposal
65         uint forVotes;
66 
67         /// @notice Current number of votes in opposition to this proposal
68         uint againstVotes;
69 
70         /// @notice Flag marking whether the proposal has been canceled
71         bool canceled;
72 
73         /// @notice Flag marking whether the proposal has been executed
74         bool executed;
75 
76         /// @notice Receipts of ballots for the entire set of voters
77         mapping (address => Receipt) receipts;
78     }
79 
80     /// @notice Ballot receipt record for a voter
81     struct Receipt {
82         /// @notice Whether or not a vote has been cast
83         bool hasVoted;
84 
85         /// @notice Whether or not the voter supports the proposal
86         bool support;
87 
88         /// @notice The number of votes the voter had, which were cast
89         uint96 votes;
90     }
91 
92     /// @notice Possible states that a proposal may be in
93     enum ProposalState {
94         Pending,
95         Active,
96         Canceled,
97         Defeated,
98         Succeeded,
99         Queued,
100         Expired,
101         Executed
102     }
103 
104     /// @notice The official record of all proposals ever proposed
105     mapping (uint => Proposal) public proposals;
106 
107     /// @notice The latest proposal for each proposer
108     mapping (address => uint) public latestProposalIds;
109 
110     /// @notice The EIP-712 typehash for the contract's domain
111     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
112 
113     /// @notice The EIP-712 typehash for the ballot struct used by the contract
114     bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");
115 
116     /// @notice An event emitted when a new proposal is created
117     event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);
118 
119     /// @notice An event emitted when a vote has been cast on a proposal
120     event VoteCast(address voter, uint proposalId, bool support, uint votes);
121 
122     /// @notice An event emitted when a proposal has been canceled
123     event ProposalCanceled(uint id);
124 
125     /// @notice An event emitted when a proposal has been queued in the Timelock
126     event ProposalQueued(uint id, uint eta);
127 
128     /// @notice An event emitted when a proposal has been executed in the Timelock
129     event ProposalExecuted(uint id);
130 
131     constructor(address timelock_, address uni_) public {
132         timelock = TimelockInterface(timelock_);
133         uni = UniInterface(uni_);
134     }
135 
136     function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {
137         require(uni.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold(), "GovernorAlpha::propose: proposer votes below proposal threshold");
138         require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "GovernorAlpha::propose: proposal function information arity mismatch");
139         require(targets.length != 0, "GovernorAlpha::propose: must provide actions");
140         require(targets.length <= proposalMaxOperations(), "GovernorAlpha::propose: too many actions");
141 
142         uint latestProposalId = latestProposalIds[msg.sender];
143         if (latestProposalId != 0) {
144           ProposalState proposersLatestProposalState = state(latestProposalId);
145           require(proposersLatestProposalState != ProposalState.Active, "GovernorAlpha::propose: one live proposal per proposer, found an already active proposal");
146           require(proposersLatestProposalState != ProposalState.Pending, "GovernorAlpha::propose: one live proposal per proposer, found an already pending proposal");
147         }
148 
149         uint startBlock = add256(block.number, votingDelay());
150         uint endBlock = add256(startBlock, votingPeriod());
151 
152         proposalCount++;
153         Proposal memory newProposal = Proposal({
154             id: proposalCount,
155             proposer: msg.sender,
156             eta: 0,
157             targets: targets,
158             values: values,
159             signatures: signatures,
160             calldatas: calldatas,
161             startBlock: startBlock,
162             endBlock: endBlock,
163             forVotes: 0,
164             againstVotes: 0,
165             canceled: false,
166             executed: false
167         });
168 
169         proposals[newProposal.id] = newProposal;
170         latestProposalIds[newProposal.proposer] = newProposal.id;
171 
172         emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);
173         return newProposal.id;
174     }
175 
176     function queue(uint proposalId) public {
177         require(state(proposalId) == ProposalState.Succeeded, "GovernorAlpha::queue: proposal can only be queued if it is succeeded");
178         Proposal storage proposal = proposals[proposalId];
179         uint eta = add256(block.timestamp, timelock.delay());
180         for (uint i = 0; i < proposal.targets.length; i++) {
181             _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
182         }
183         proposal.eta = eta;
184         emit ProposalQueued(proposalId, eta);
185     }
186 
187     function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {
188         require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "GovernorAlpha::_queueOrRevert: proposal action already queued at eta");
189         timelock.queueTransaction(target, value, signature, data, eta);
190     }
191 
192     function execute(uint proposalId) public payable {
193         require(state(proposalId) == ProposalState.Queued, "GovernorAlpha::execute: proposal can only be executed if it is queued");
194         Proposal storage proposal = proposals[proposalId];
195         proposal.executed = true;
196         for (uint i = 0; i < proposal.targets.length; i++) {
197             timelock.executeTransaction.value(proposal.values[i])(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
198         }
199         emit ProposalExecuted(proposalId);
200     }
201 
202     function cancel(uint proposalId) public {
203         ProposalState state = state(proposalId);
204         require(state != ProposalState.Executed, "GovernorAlpha::cancel: cannot cancel executed proposal");
205 
206         Proposal storage proposal = proposals[proposalId];
207         require(uni.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold(), "GovernorAlpha::cancel: proposer above threshold");
208 
209         proposal.canceled = true;
210         for (uint i = 0; i < proposal.targets.length; i++) {
211             timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
212         }
213 
214         emit ProposalCanceled(proposalId);
215     }
216 
217     function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {
218         Proposal storage p = proposals[proposalId];
219         return (p.targets, p.values, p.signatures, p.calldatas);
220     }
221 
222     function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {
223         return proposals[proposalId].receipts[voter];
224     }
225 
226     function state(uint proposalId) public view returns (ProposalState) {
227         require(proposalCount >= proposalId && proposalId > 0, "GovernorAlpha::state: invalid proposal id");
228         Proposal storage proposal = proposals[proposalId];
229         if (proposal.canceled) {
230             return ProposalState.Canceled;
231         } else if (block.number <= proposal.startBlock) {
232             return ProposalState.Pending;
233         } else if (block.number <= proposal.endBlock) {
234             return ProposalState.Active;
235         } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {
236             return ProposalState.Defeated;
237         } else if (proposal.eta == 0) {
238             return ProposalState.Succeeded;
239         } else if (proposal.executed) {
240             return ProposalState.Executed;
241         } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {
242             return ProposalState.Expired;
243         } else {
244             return ProposalState.Queued;
245         }
246     }
247 
248     function castVote(uint proposalId, bool support) public {
249         return _castVote(msg.sender, proposalId, support);
250     }
251 
252     function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {
253         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
254         bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
255         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
256         address signatory = ecrecover(digest, v, r, s);
257         require(signatory != address(0), "GovernorAlpha::castVoteBySig: invalid signature");
258         return _castVote(signatory, proposalId, support);
259     }
260 
261     function _castVote(address voter, uint proposalId, bool support) internal {
262         require(state(proposalId) == ProposalState.Active, "GovernorAlpha::_castVote: voting is closed");
263         Proposal storage proposal = proposals[proposalId];
264         Receipt storage receipt = proposal.receipts[voter];
265         require(receipt.hasVoted == false, "GovernorAlpha::_castVote: voter already voted");
266         uint96 votes = uni.getPriorVotes(voter, proposal.startBlock);
267 
268         if (support) {
269             proposal.forVotes = add256(proposal.forVotes, votes);
270         } else {
271             proposal.againstVotes = add256(proposal.againstVotes, votes);
272         }
273 
274         receipt.hasVoted = true;
275         receipt.support = support;
276         receipt.votes = votes;
277 
278         emit VoteCast(voter, proposalId, support, votes);
279     }
280 
281     function add256(uint256 a, uint256 b) internal pure returns (uint) {
282         uint c = a + b;
283         require(c >= a, "addition overflow");
284         return c;
285     }
286 
287     function sub256(uint256 a, uint256 b) internal pure returns (uint) {
288         require(b <= a, "subtraction underflow");
289         return a - b;
290     }
291 
292     function getChainId() internal pure returns (uint) {
293         uint chainId;
294         assembly { chainId := chainid() }
295         return chainId;
296     }
297 }
298 
299 interface TimelockInterface {
300     function delay() external view returns (uint);
301     function GRACE_PERIOD() external view returns (uint);
302     function acceptAdmin() external;
303     function queuedTransactions(bytes32 hash) external view returns (bool);
304     function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);
305     function cancelTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external;
306     function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);
307 }
308 
309 interface UniInterface {
310     function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
311 }