1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 contract GovernorAlpha {
5     /// @notice The name of this contract
6     string public constant name = "Compound Governor Alpha";
7 
8     /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
9     function quorumVotes() public pure returns (uint) { return 400000e18; } // 400,000 = 4% of Comp
10 
11     /// @notice The number of votes required in order for a voter to become a proposer
12     function proposalThreshold() public pure returns (uint) { return 100000e18; } // 100,000 = 1% of Comp
13 
14     /// @notice The maximum number of actions that can be included in a proposal
15     function proposalMaxOperations() public pure returns (uint) { return 10; } // 10 actions
16 
17     /// @notice The delay before voting on a proposal may take place, once proposed
18     function votingDelay() public pure returns (uint) { return 1; } // 1 block
19 
20     /// @notice The duration of voting on a proposal, in blocks
21     function votingPeriod() public pure returns (uint) { return 17280; } // ~3 days in blocks (assuming 15s blocks)
22 
23     /// @notice The address of the Compound Protocol Timelock
24     TimelockInterface public timelock;
25 
26     /// @notice The address of the Compound governance token
27     CompInterface public comp;
28 
29     /// @notice The address of the Governor Guardian
30     address public guardian;
31 
32     /// @notice The total number of proposals
33     uint public proposalCount;
34 
35     struct Proposal {
36         /// @notice Unique id for looking up a proposal
37         uint id;
38 
39         /// @notice Creator of the proposal
40         address proposer;
41 
42         /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
43         uint eta;
44 
45         /// @notice the ordered list of target addresses for calls to be made
46         address[] targets;
47 
48         /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
49         uint[] values;
50 
51         /// @notice The ordered list of function signatures to be called
52         string[] signatures;
53 
54         /// @notice The ordered list of calldata to be passed to each call
55         bytes[] calldatas;
56 
57         /// @notice The block at which voting begins: holders must delegate their votes prior to this block
58         uint startBlock;
59 
60         /// @notice The block at which voting ends: votes must be cast prior to this block
61         uint endBlock;
62 
63         /// @notice Current number of votes in favor of this proposal
64         uint forVotes;
65 
66         /// @notice Current number of votes in opposition to this proposal
67         uint againstVotes;
68 
69         /// @notice Flag marking whether the proposal has been canceled
70         bool canceled;
71 
72         /// @notice Flag marking whether the proposal has been executed
73         bool executed;
74 
75         /// @notice Receipts of ballots for the entire set of voters
76         mapping (address => Receipt) receipts;
77     }
78 
79     /// @notice Ballot receipt record for a voter
80     struct Receipt {
81         /// @notice Whether or not a vote has been cast
82         bool hasVoted;
83 
84         /// @notice Whether or not the voter supports the proposal
85         bool support;
86 
87         /// @notice The number of votes the voter had, which were cast
88         uint96 votes;
89     }
90 
91     /// @notice Possible states that a proposal may be in
92     enum ProposalState {
93         Pending,
94         Active,
95         Canceled,
96         Defeated,
97         Succeeded,
98         Queued,
99         Expired,
100         Executed
101     }
102 
103     /// @notice The official record of all proposals ever proposed
104     mapping (uint => Proposal) public proposals;
105 
106     /// @notice The latest proposal for each proposer
107     mapping (address => uint) public latestProposalIds;
108 
109     /// @notice The EIP-712 typehash for the contract's domain
110     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
111 
112     /// @notice The EIP-712 typehash for the ballot struct used by the contract
113     bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");
114 
115     /// @notice An event emitted when a new proposal is created
116     event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);
117 
118     /// @notice An event emitted when a vote has been cast on a proposal
119     event VoteCast(address voter, uint proposalId, bool support, uint votes);
120 
121     /// @notice An event emitted when a proposal has been canceled
122     event ProposalCanceled(uint id);
123 
124     /// @notice An event emitted when a proposal has been queued in the Timelock
125     event ProposalQueued(uint id, uint eta);
126 
127     /// @notice An event emitted when a proposal has been executed in the Timelock
128     event ProposalExecuted(uint id);
129 
130     constructor(address timelock_, address comp_, address guardian_) public {
131         timelock = TimelockInterface(timelock_);
132         comp = CompInterface(comp_);
133         guardian = guardian_;
134     }
135 
136     function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {
137         require(comp.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold(), "GovernorAlpha::propose: proposer votes below proposal threshold");
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
207         require(msg.sender == guardian || comp.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold(), "GovernorAlpha::cancel: proposer above threshold");
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
266         uint96 votes = comp.getPriorVotes(voter, proposal.startBlock);
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
281     function __acceptAdmin() public {
282         require(msg.sender == guardian, "GovernorAlpha::__acceptAdmin: sender must be gov guardian");
283         timelock.acceptAdmin();
284     }
285 
286     function __abdicate() public {
287         require(msg.sender == guardian, "GovernorAlpha::__abdicate: sender must be gov guardian");
288         guardian = address(0);
289     }
290 
291     function __queueSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {
292         require(msg.sender == guardian, "GovernorAlpha::__queueSetTimelockPendingAdmin: sender must be gov guardian");
293         timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
294     }
295 
296     function __executeSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {
297         require(msg.sender == guardian, "GovernorAlpha::__executeSetTimelockPendingAdmin: sender must be gov guardian");
298         timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
299     }
300 
301     function add256(uint256 a, uint256 b) internal pure returns (uint) {
302         uint c = a + b;
303         require(c >= a, "addition overflow");
304         return c;
305     }
306 
307     function sub256(uint256 a, uint256 b) internal pure returns (uint) {
308         require(b <= a, "subtraction underflow");
309         return a - b;
310     }
311 
312     function getChainId() internal pure returns (uint) {
313         uint chainId;
314         assembly { chainId := chainid() }
315         return chainId;
316     }
317 }
318 
319 interface TimelockInterface {
320     function delay() external view returns (uint);
321     function GRACE_PERIOD() external view returns (uint);
322     function acceptAdmin() external;
323     function queuedTransactions(bytes32 hash) external view returns (bool);
324     function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);
325     function cancelTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external;
326     function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);
327 }
328 
329 interface CompInterface {
330     function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
331 }
