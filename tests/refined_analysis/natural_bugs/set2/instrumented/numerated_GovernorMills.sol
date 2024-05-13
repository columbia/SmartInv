1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 interface InvInterface {
5     function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
6     function totalSupply() external view returns (uint256);
7 }
8 
9 interface XinvInterface {
10     function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
11     function totalSupply() external view returns (uint256);
12     function exchangeRateCurrent() external returns (uint);
13 }
14 
15 interface TimelockInterface {
16     function delay() external view returns (uint);
17     function GRACE_PERIOD() external view returns (uint);
18     function setDelay(uint256 delay_) external;
19     function acceptAdmin() external;
20     function setPendingAdmin(address pendingAdmin_) external;
21     function queuedTransactions(bytes32 hash) external view returns (bool);
22     function queueTransaction(address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta) external returns (bytes32);
23     function cancelTransaction(address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta) external;
24     function executeTransaction(address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta) external returns (bytes memory);
25 }
26 
27 contract GovernorMills {
28     /// @notice The name of this contract
29     string public constant name = "Inverse Governor Mills";
30 
31     /// @notice The maximum number of actions that can be included in a proposal
32     function proposalMaxOperations() public pure returns (uint) { return 20; } // 20 actions
33 
34     /// @notice The delay before voting on a proposal may take place, once proposed
35     function votingDelay() public pure returns (uint) { return 1; } // 1 block
36 
37     /// @notice The duration of voting on a proposal, in blocks
38     function votingPeriod() public pure returns (uint) { return 17280; } // ~3 days in blocks (assuming 15s blocks)
39 
40     /// @notice The address of the Protocol Timelock
41     TimelockInterface public timelock;
42 
43     /// @notice The address of the governance token A
44     InvInterface public inv;
45 
46     /// @notice The address of the governance token B
47     XinvInterface public xinv;
48 
49     /// @notice The total number of proposals
50     uint256 public proposalCount;
51 
52     /// @notice The guardian
53     address public guardian;
54 
55     /// @notice proposal threshold
56     uint256 public proposalThreshold = 1000 ether; // 1k INV
57 
58     /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
59     uint256 public quorumVotes = 4000 ether; // 4k INV
60 
61     struct Proposal {
62         /// @notice Unique id for looking up a proposal
63         uint id;
64 
65         /// @notice Creator of the proposal
66         address proposer;
67 
68         /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
69         uint eta;
70 
71         /// @notice the ordered list of target addresses for calls to be made
72         address[] targets;
73 
74         /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
75         uint[] values;
76 
77         /// @notice The ordered list of function signatures to be called
78         string[] signatures;
79 
80         /// @notice The ordered list of calldata to be passed to each call
81         bytes[] calldatas;
82 
83         /// @notice The block at which voting begins: holders must delegate their votes prior to this block
84         uint startBlock;
85 
86         /// @notice The block at which voting ends: votes must be cast prior to this block
87         uint endBlock;
88 
89         /// @notice Current number of votes in favor of this proposal
90         uint forVotes;
91 
92         /// @notice Current number of votes in opposition to this proposal
93         uint againstVotes;
94 
95         /// @notice Flag marking whether the proposal has been canceled
96         bool canceled;
97 
98         /// @notice Flag marking whether the proposal has been executed
99         bool executed;
100 
101         /// @notice Receipts of ballots for the entire set of voters
102         mapping (address => Receipt) receipts;
103     }
104 
105     /// @notice Ballot receipt record for a voter
106     struct Receipt {
107         /// @notice Whether or not a vote has been cast
108         bool hasVoted;
109 
110         /// @notice Whether or not the voter supports the proposal
111         bool support;
112 
113         /// @notice The number of votes the voter had, which were cast
114         uint96 votes;
115     }
116 
117     /// @notice Possible states that a proposal may be in
118     enum ProposalState {
119         Pending,
120         Active,
121         Canceled,
122         Defeated,
123         Succeeded,
124         Queued,
125         Expired,
126         Executed
127     }
128 
129     /// @notice The official record of all proposals ever proposed
130     mapping (uint => Proposal) public proposals;
131 
132     /// @notice The latest proposal for each proposer
133     mapping (address => uint) public latestProposalIds;
134 
135     /// @notice Addresses that can propose without voting power
136     mapping (address => bool) public proposerWhitelist;
137 
138     /// @notice proposal id => xinv.exchangeRateCurrent
139     mapping (uint => uint) public xinvExchangeRates;
140 
141     /// @notice The EIP-712 typehash for the contract's domain
142     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
143 
144     /// @notice The EIP-712 typehash for the ballot struct used by the contract
145     bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");
146 
147     /// @notice An event emitted when a new proposal is created
148     event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);
149 
150     /// @notice An event emitted when a vote has been cast on a proposal
151     event VoteCast(address voter, uint proposalId, bool support, uint votes);
152 
153     /// @notice An event emitted when a proposal has been canceled
154     event ProposalCanceled(uint id);
155 
156     /// @notice An event emitted when a proposal has been queued in the Timelock
157     event ProposalQueued(uint id, uint eta);
158 
159     /// @notice An event emitted when a proposal has been executed in the Timelock
160     event ProposalExecuted(uint id);
161 
162     /// @notice An event emitted when a new guardian has been set
163     event NewGuardian(address guardian);
164 
165     /// @notice An event emitted when proposal threshold is updated
166     event ProposalThresholdUpdated(uint256 oldThreshold, uint256 newThreshold);
167 
168     /// @notice An event emitted when proposal quorum is updated
169     event QuorumUpdated(uint256 oldQuorum, uint256 newQuorum);
170 
171     /// @notice An event emitted when an address is added or removed from the proposer whitelist
172     event ProposerWhitelistUpdated(address proposer, bool value);
173 
174     constructor(TimelockInterface timelock_, InvInterface inv_, XinvInterface xinv_) public {
175         timelock = timelock_;
176         inv = inv_;
177         xinv = xinv_;
178         guardian = msg.sender;
179     }
180 
181     function _getPriorVotes(address _proposer, uint256 _blockNumber, uint256 _exchangeRate) internal view returns (uint96) {
182         uint96 invPriorVotes = inv.getPriorVotes(_proposer, _blockNumber);
183         uint96 xinvPriorVotes = uint96(
184             (
185                 uint256(
186                     xinv.getPriorVotes(_proposer, _blockNumber)
187                 ) * _exchangeRate
188             ) / 1 ether
189         );
190         
191         return add96(invPriorVotes, xinvPriorVotes);
192     }
193 
194     function setGuardian(address _newGuardian) public {
195         require(msg.sender == guardian, "GovernorMills::setGuardian: only guardian");
196         guardian = _newGuardian;
197         
198         emit NewGuardian(guardian);
199     }
200 
201     /**
202      * @notice Add new pending admin to queue
203      * @param newPendingAdmin The new admin
204      * @param eta ETA
205      */
206     function __queueSetTimelockPendingAdmin(address newPendingAdmin, uint256 eta) public {
207         require(msg.sender == guardian, "GovernorMills::__queueSetTimelockPendingAdmin: only guardian");
208         timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
209     }
210 
211     function __executeSetTimelockPendingAdmin(address newPendingAdmin, uint256 eta) public {
212         require(msg.sender == guardian, "GovernorMills::__executeSetTimelockPendingAdmin: only guardian");
213         timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
214     }
215 
216     function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {
217         require(_getPriorVotes(msg.sender, sub256(block.number, 1), xinv.exchangeRateCurrent()) > proposalThreshold || proposerWhitelist[msg.sender], "GovernorMills::propose: proposer votes below proposal threshold");
218         require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "GovernorMills::propose: proposal function information arity mismatch");
219         require(targets.length != 0, "GovernorMills::propose: must provide actions");
220         require(targets.length <= proposalMaxOperations(), "GovernorMills::propose: too many actions");
221 
222         uint latestProposalId = latestProposalIds[msg.sender];
223         if (latestProposalId != 0) {
224           ProposalState proposersLatestProposalState = state(latestProposalId);
225           require(proposersLatestProposalState != ProposalState.Active, "GovernorMills::propose: one live proposal per proposer, found an already active proposal");
226           require(proposersLatestProposalState != ProposalState.Pending, "GovernorMills::propose: one live proposal per proposer, found an already pending proposal");
227         }
228 
229         uint startBlock = add256(block.number, votingDelay());
230         uint endBlock = add256(startBlock, votingPeriod());
231 
232         proposalCount++;
233         Proposal memory newProposal = Proposal({
234             id: proposalCount,
235             proposer: msg.sender,
236             eta: 0,
237             targets: targets,
238             values: values,
239             signatures: signatures,
240             calldatas: calldatas,
241             startBlock: startBlock,
242             endBlock: endBlock,
243             forVotes: 0,
244             againstVotes: 0,
245             canceled: false,
246             executed: false
247         });
248 
249         proposals[newProposal.id] = newProposal;
250         xinvExchangeRates[newProposal.id] = xinv.exchangeRateCurrent();
251         latestProposalIds[newProposal.proposer] = newProposal.id;
252 
253         emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);
254         return newProposal.id;
255     }
256 
257     function queue(uint proposalId) public {
258         require(state(proposalId) == ProposalState.Succeeded, "GovernorMills::queue: proposal can only be queued if it is succeeded");
259         Proposal storage proposal = proposals[proposalId];
260         uint eta = add256(block.timestamp, timelock.delay());
261         for (uint i = 0; i < proposal.targets.length; i++) {
262             _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
263         }
264         proposal.eta = eta;
265         emit ProposalQueued(proposalId, eta);
266     }
267 
268     function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {
269         require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "GovernorMills::_queueOrRevert: proposal action already queued at eta");
270         timelock.queueTransaction(target, value, signature, data, eta);
271     }
272 
273     function execute(uint proposalId) public {
274         require(state(proposalId) == ProposalState.Queued, "GovernorMills::execute: proposal can only be executed if it is queued");
275         Proposal storage proposal = proposals[proposalId];
276         proposal.executed = true;
277         for (uint i = 0; i < proposal.targets.length; i++) {
278             timelock.executeTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
279         }
280         emit ProposalExecuted(proposalId);
281     }
282 
283     function cancel(uint proposalId) public {
284         ProposalState state = state(proposalId);
285         require(state != ProposalState.Executed, "GovernorMills::cancel: cannot cancel executed proposal");
286 
287         Proposal storage proposal = proposals[proposalId];
288         require(msg.sender == guardian || (_getPriorVotes(proposal.proposer, sub256(block.number, 1), xinvExchangeRates[proposal.id]) < proposalThreshold && !proposerWhitelist[proposal.proposer]), "GovernorMills::cancel: proposer above threshold");
289 
290         proposal.canceled = true;
291         for (uint i = 0; i < proposal.targets.length; i++) {
292             timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
293         }
294 
295         emit ProposalCanceled(proposalId);
296     }
297 
298     /**
299      * @notice Update the threshold value required to create a new proposal.
300      * @param newThreshold The new threshold to set.
301      */
302     function updateProposalThreshold(uint256 newThreshold) public {
303         require(msg.sender == guardian || msg.sender == address(timelock), "GovernorMills::updateProposalThreshold: sender must be gov guardian or timelock");
304         require(newThreshold <= inv.totalSupply(), "GovernorMills::updateProposalThreshold: threshold too large");
305         require(newThreshold != proposalThreshold, "GovernorMills::updateProposalThreshold: no change in value");
306 
307         uint256 oldThreshold = proposalThreshold;
308         proposalThreshold = newThreshold;
309 
310         emit ProposalThresholdUpdated(oldThreshold, newThreshold);
311     }
312 
313     /**
314      * @notice Update the quorum value required to pass a proposal.
315      * @param newQuorum The new quorum to set.
316      */
317     function updateProposalQuorum(uint256 newQuorum) public {
318         require(msg.sender == guardian || msg.sender == address(timelock), "GovernorMills::newQuorum: sender must be gov guardian or timelock");
319         require(newQuorum <= inv.totalSupply(), "GovernorMills::newQuorum: threshold too large");
320         require(newQuorum != quorumVotes, "GovernorMills::newQuorum: no change in value");
321 
322         uint256 oldQuorum = quorumVotes;
323         quorumVotes = newQuorum;
324 
325         emit QuorumUpdated(oldQuorum, newQuorum);
326     }
327 
328     function acceptAdmin() public {
329         require(msg.sender == guardian, "GovernorMills::acceptAdmin: sender must be gov guardian");
330         timelock.acceptAdmin();
331     }
332 
333     /**
334      * @notice Add or remove an address to the proposerWhitelist
335      * @param proposer address to be updated on the whitelist
336      * @param value true to add, false to remove
337      */
338     function updateProposerWhitelist(address proposer, bool value) public {
339         require(msg.sender == address(timelock), "GovernorMills::updateProposerWhitelist: sender must be timelock");
340 
341         proposerWhitelist[proposer] = value;
342 
343         emit ProposerWhitelistUpdated(proposer, value);
344     }
345 
346     function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {
347         Proposal storage p = proposals[proposalId];
348         return (p.targets, p.values, p.signatures, p.calldatas);
349     }
350 
351     function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {
352         return proposals[proposalId].receipts[voter];
353     }
354 
355     function state(uint proposalId) public view returns (ProposalState) {
356         require(proposalCount >= proposalId && proposalId > 0, "GovernorMills::state: invalid proposal id");
357         Proposal storage proposal = proposals[proposalId];
358         if (proposal.canceled) {
359             return ProposalState.Canceled;
360         } else if (block.number <= proposal.startBlock) {
361             return ProposalState.Pending;
362         } else if (block.number <= proposal.endBlock) {
363             return ProposalState.Active;
364         } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes) {
365             return ProposalState.Defeated;
366         } else if (proposal.eta == 0) {
367             return ProposalState.Succeeded;
368         } else if (proposal.executed) {
369             return ProposalState.Executed;
370         } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {
371             return ProposalState.Expired;
372         } else {
373             return ProposalState.Queued;
374         }
375     }
376 
377     function castVote(uint proposalId, bool support) public {
378         return _castVote(msg.sender, proposalId, support);
379     }
380 
381     function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {
382         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
383         bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
384         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
385         address signatory = ecrecover(digest, v, r, s);
386         require(signatory != address(0), "GovernorMills::castVoteBySig: invalid signature");
387         return _castVote(signatory, proposalId, support);
388     }
389 
390     function _castVote(address voter, uint proposalId, bool support) internal {
391         require(state(proposalId) == ProposalState.Active, "GovernorMills::_castVote: voting is closed");
392         Proposal storage proposal = proposals[proposalId];
393         Receipt storage receipt = proposal.receipts[voter];
394         require(receipt.hasVoted == false, "GovernorMills::_castVote: voter already voted");
395         uint96 votes = _getPriorVotes(voter, proposal.startBlock, xinvExchangeRates[proposal.id]);
396 
397         if (support) {
398             proposal.forVotes = add256(proposal.forVotes, votes);
399         } else {
400             proposal.againstVotes = add256(proposal.againstVotes, votes);
401         }
402 
403         receipt.hasVoted = true;
404         receipt.support = support;
405         receipt.votes = votes;
406 
407         emit VoteCast(voter, proposalId, support, votes);
408     }
409 
410     function add96(uint96 a, uint96 b) internal pure returns(uint96) {
411         uint96 c = a + b;
412         require(c >= a, "addition overflow");
413         return c;
414     }
415 
416     function add256(uint256 a, uint256 b) internal pure returns (uint) {
417         uint c = a + b;
418         require(c >= a, "addition overflow");
419         return c;
420     }
421 
422     function sub256(uint256 a, uint256 b) internal pure returns (uint) {
423         require(b <= a, "subtraction underflow");
424         return a - b;
425     }
426 
427     function getChainId() internal pure returns (uint) {
428         uint chainId;
429         assembly { chainId := chainid() }
430         return chainId;
431     }
432 
433 }