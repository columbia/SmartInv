1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 // Even fish can make waves.
5 contract GovernorAlpha {
6     /// @notice The name of this contract
7     string public constant name = "Uniswap Governor Alpha";
8 
9     /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
10     function quorumVotes() public pure returns (uint) { return 40_000_000e18; } // 4% of Uni
11 
12     /// @notice The number of votes required in order for a voter to become a proposer
13     function proposalThreshold() public pure returns (uint) { return 2_500_000e18; } // 0.25% of Uni
14 
15     /// @notice The maximum number of actions that can be included in a proposal
16     function proposalMaxOperations() public pure returns (uint) { return 10; } // 10 actions
17 
18     /// @notice The delay before voting on a proposal may take place, once proposed
19     function votingDelay() public pure returns (uint) { return 1; } // 1 block
20 
21     /// @notice The duration of voting on a proposal, in blocks
22     function votingPeriod() public pure returns (uint) { return 40_320; } // ~7 days in blocks (assuming 15s blocks)
23 
24     /// @notice The address of the Uniswap Protocol Timelock
25     TimelockInterface public constant timelock = TimelockInterface(0x1a9C8182C09F50C8318d769245beA52c32BE35BC);
26 
27     /// @notice The address of the Uniswap governance token
28     UniInterface public constant uni = UniInterface(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
29 
30     /// @notice The total number of proposals
31     uint public proposalCount;
32 
33     struct Proposal {
34         /// @notice Unique id for looking up a proposal
35         uint id;
36 
37         /// @notice Creator of the proposal
38         address proposer;
39 
40         /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
41         uint eta;
42 
43         /// @notice the ordered list of target addresses for calls to be made
44         address[] targets;
45 
46         /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
47         uint[] values;
48 
49         /// @notice The ordered list of function signatures to be called
50         string[] signatures;
51 
52         /// @notice The ordered list of calldata to be passed to each call
53         bytes[] calldatas;
54 
55         /// @notice The block at which voting begins: holders must delegate their votes prior to this block
56         uint startBlock;
57 
58         /// @notice The block at which voting ends: votes must be cast prior to this block
59         uint endBlock;
60 
61         /// @notice Current number of votes in favor of this proposal
62         uint forVotes;
63 
64         /// @notice Current number of votes in opposition to this proposal
65         uint againstVotes;
66 
67         /// @notice Flag marking whether the proposal has been canceled
68         bool canceled;
69 
70         /// @notice Flag marking whether the proposal has been executed
71         bool executed;
72 
73         /// @notice Receipts of ballots for the entire set of voters
74         mapping (address => Receipt) receipts;
75     }
76 
77     /// @notice Ballot receipt record for a voter
78     struct Receipt {
79         /// @notice Whether or not a vote has been cast
80         bool hasVoted;
81 
82         /// @notice Whether or not the voter supports the proposal
83         bool support;
84 
85         /// @notice The number of votes the voter had, which were cast
86         uint96 votes;
87     }
88 
89     /// @notice Possible states that a proposal may be in
90     enum ProposalState {
91         Pending,
92         Active,
93         Canceled,
94         Defeated,
95         Succeeded,
96         Queued,
97         Expired,
98         Executed
99     }
100 
101     /// @notice The official record of all proposals ever proposed
102     mapping (uint => Proposal) public proposals;
103 
104     /// @notice The latest proposal for each proposer
105     mapping (address => uint) public latestProposalIds;
106 
107     /// @notice The EIP-712 typehash for the contract's domain
108     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
109 
110     /// @notice The EIP-712 typehash for the ballot struct used by the contract
111     bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");
112 
113     /// @notice An event emitted when a new proposal is created
114     event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);
115 
116     /// @notice An event emitted when a vote has been cast on a proposal
117     event VoteCast(address voter, uint proposalId, bool support, uint votes);
118 
119     /// @notice An event emitted when a proposal has been canceled
120     event ProposalCanceled(uint id);
121 
122     /// @notice An event emitted when a proposal has been queued in the Timelock
123     event ProposalQueued(uint id, uint eta);
124 
125     /// @notice An event emitted when a proposal has been executed in the Timelock
126     event ProposalExecuted(uint id);
127 
128     function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {
129         require(uni.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold(), "GovernorAlpha::propose: proposer votes below proposal threshold");
130         require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "GovernorAlpha::propose: proposal function information arity mismatch");
131         require(targets.length != 0, "GovernorAlpha::propose: must provide actions");
132         require(targets.length <= proposalMaxOperations(), "GovernorAlpha::propose: too many actions");
133 
134         uint latestProposalId = latestProposalIds[msg.sender];
135         if (latestProposalId != 0) {
136           ProposalState proposersLatestProposalState = state(latestProposalId);
137           require(proposersLatestProposalState != ProposalState.Active, "GovernorAlpha::propose: one live proposal per proposer, found an already active proposal");
138           require(proposersLatestProposalState != ProposalState.Pending, "GovernorAlpha::propose: one live proposal per proposer, found an already pending proposal");
139         }
140 
141         uint startBlock = add256(block.number, votingDelay());
142         uint endBlock = add256(startBlock, votingPeriod());
143 
144         proposalCount++;
145         Proposal memory newProposal = Proposal({
146             id: proposalCount,
147             proposer: msg.sender,
148             eta: 0,
149             targets: targets,
150             values: values,
151             signatures: signatures,
152             calldatas: calldatas,
153             startBlock: startBlock,
154             endBlock: endBlock,
155             forVotes: 0,
156             againstVotes: 0,
157             canceled: false,
158             executed: false
159         });
160 
161         proposals[newProposal.id] = newProposal;
162         latestProposalIds[newProposal.proposer] = newProposal.id;
163 
164         emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);
165         return newProposal.id;
166     }
167 
168     function queue(uint proposalId) public {
169         require(state(proposalId) == ProposalState.Succeeded, "GovernorAlpha::queue: proposal can only be queued if it is succeeded");
170         Proposal storage proposal = proposals[proposalId];
171         uint eta = add256(block.timestamp, timelock.delay());
172         for (uint i = 0; i < proposal.targets.length; i++) {
173             _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
174         }
175         proposal.eta = eta;
176         emit ProposalQueued(proposalId, eta);
177     }
178 
179     function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {
180         require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "GovernorAlpha::_queueOrRevert: proposal action already queued at eta");
181         timelock.queueTransaction(target, value, signature, data, eta);
182     }
183 
184     function execute(uint proposalId) public payable {
185         require(state(proposalId) == ProposalState.Queued, "GovernorAlpha::execute: proposal can only be executed if it is queued");
186         Proposal storage proposal = proposals[proposalId];
187         proposal.executed = true;
188         for (uint i = 0; i < proposal.targets.length; i++) {
189             timelock.executeTransaction.value(proposal.values[i])(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
190         }
191         emit ProposalExecuted(proposalId);
192     }
193 
194     function cancel(uint proposalId) public {
195         ProposalState state = state(proposalId);
196         require(state != ProposalState.Executed, "GovernorAlpha::cancel: cannot cancel executed proposal");
197 
198         Proposal storage proposal = proposals[proposalId];
199         require(uni.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold(), "GovernorAlpha::cancel: proposer above threshold");
200 
201         proposal.canceled = true;
202         for (uint i = 0; i < proposal.targets.length; i++) {
203             timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
204         }
205 
206         emit ProposalCanceled(proposalId);
207     }
208 
209     function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {
210         Proposal storage p = proposals[proposalId];
211         return (p.targets, p.values, p.signatures, p.calldatas);
212     }
213 
214     function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {
215         return proposals[proposalId].receipts[voter];
216     }
217 
218     function state(uint proposalId) public view returns (ProposalState) {
219         require(proposalCount >= proposalId && proposalId > 0, "GovernorAlpha::state: invalid proposal id");
220         Proposal storage proposal = proposals[proposalId];
221         if (proposal.canceled) {
222             return ProposalState.Canceled;
223         } else if (block.number <= proposal.startBlock) {
224             return ProposalState.Pending;
225         } else if (block.number <= proposal.endBlock) {
226             return ProposalState.Active;
227         } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {
228             return ProposalState.Defeated;
229         } else if (proposal.eta == 0) {
230             return ProposalState.Succeeded;
231         } else if (proposal.executed) {
232             return ProposalState.Executed;
233         } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {
234             return ProposalState.Expired;
235         } else {
236             return ProposalState.Queued;
237         }
238     }
239 
240     function castVote(uint proposalId, bool support) public {
241         return _castVote(msg.sender, proposalId, support);
242     }
243 
244     function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {
245         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
246         bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
247         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
248         address signatory = ecrecover(digest, v, r, s);
249         require(signatory != address(0), "GovernorAlpha::castVoteBySig: invalid signature");
250         return _castVote(signatory, proposalId, support);
251     }
252 
253     function __acceptAdmin() public {
254         timelock.acceptAdmin();
255     }
256 
257     function _castVote(address voter, uint proposalId, bool support) internal {
258         require(state(proposalId) == ProposalState.Active, "GovernorAlpha::_castVote: voting is closed");
259         Proposal storage proposal = proposals[proposalId];
260         Receipt storage receipt = proposal.receipts[voter];
261         require(receipt.hasVoted == false, "GovernorAlpha::_castVote: voter already voted");
262         uint96 votes = uni.getPriorVotes(voter, proposal.startBlock);
263 
264         if (support) {
265             proposal.forVotes = add256(proposal.forVotes, votes);
266         } else {
267             proposal.againstVotes = add256(proposal.againstVotes, votes);
268         }
269 
270         receipt.hasVoted = true;
271         receipt.support = support;
272         receipt.votes = votes;
273 
274         emit VoteCast(voter, proposalId, support, votes);
275     }
276 
277     function add256(uint256 a, uint256 b) internal pure returns (uint) {
278         uint c = a + b;
279         require(c >= a, "addition overflow");
280         return c;
281     }
282 
283     function sub256(uint256 a, uint256 b) internal pure returns (uint) {
284         require(b <= a, "subtraction underflow");
285         return a - b;
286     }
287 
288     function getChainId() internal pure returns (uint) {
289         uint chainId;
290         assembly { chainId := chainid() }
291         return chainId;
292     }
293 }
294 
295 interface TimelockInterface {
296     function delay() external view returns (uint);
297     function GRACE_PERIOD() external view returns (uint);
298     function acceptAdmin() external;
299     function queuedTransactions(bytes32 hash) external view returns (bool);
300     function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);
301     function cancelTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external;
302     function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);
303 }
304 
305 interface UniInterface {
306     function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
307 }