1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity ^0.8.4;
4 
5 // Forked from Compound
6 // See https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/GovernorAlpha.sol
7 contract GovernorAlpha {
8     /// @notice The name of this contract
9     // solhint-disable-next-line const-name-snakecase
10     string public constant name = "Fei Governor Alpha";
11 
12     /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
13     function quorumVotes() public pure returns (uint256) {
14         return 25000000e18;
15     } // 25,000,000 = 2.5% of Tribe
16 
17     /// @notice The number of votes required in order for a voter to become a proposer
18     function proposalThreshold() public pure returns (uint256) {
19         return 2500000e18;
20     } // 2,500,000 = .25% of Tribe
21 
22     /// @notice The maximum number of actions that can be included in a proposal
23     function proposalMaxOperations() public pure returns (uint256) {
24         return 10;
25     } // 10 actions
26 
27     /// @notice The delay before voting on a proposal may take place, once proposed
28     function votingDelay() public pure returns (uint256) {
29         return 3333;
30     } // ~0.5 days in blocks (assuming 13s blocks)
31 
32     /// @notice The duration of voting on a proposal, in blocks
33     function votingPeriod() public pure returns (uint256) {
34         return 10000;
35     } // ~1.5 days in blocks (assuming 13s blocks)
36 
37     /// @notice The address of the Fei Protocol Timelock
38     TimelockInterface public timelock;
39 
40     /// @notice The address of the Fei governance token
41     TribeInterface public tribe;
42 
43     /// @notice The address of the Governor Guardian
44     address public guardian;
45 
46     /// @notice The total number of proposals
47     uint256 public proposalCount;
48 
49     struct Proposal {
50         /// @notice Unique id for looking up a proposal
51         uint256 id;
52         /// @notice Creator of the proposal
53         address proposer;
54         /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
55         uint256 eta;
56         /// @notice the ordered list of target addresses for calls to be made
57         address[] targets;
58         /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
59         uint256[] values;
60         /// @notice The ordered list of function signatures to be called
61         string[] signatures;
62         /// @notice The ordered list of calldata to be passed to each call
63         bytes[] calldatas;
64         /// @notice The block at which voting begins: holders must delegate their votes prior to this block
65         uint256 startBlock;
66         /// @notice The block at which voting ends: votes must be cast prior to this block
67         uint256 endBlock;
68         /// @notice Current number of votes in favor of this proposal
69         uint256 forVotes;
70         /// @notice Current number of votes in opposition to this proposal
71         uint256 againstVotes;
72         /// @notice Flag marking whether the proposal has been canceled
73         bool canceled;
74         /// @notice Flag marking whether the proposal has been executed
75         bool executed;
76         /// @notice Receipts of ballots for the entire set of voters
77         mapping(address => Receipt) receipts;
78     }
79 
80     /// @notice Ballot receipt record for a voter
81     struct Receipt {
82         /// @notice Whether or not a vote has been cast
83         bool hasVoted;
84         /// @notice Whether or not the voter supports the proposal
85         bool support;
86         /// @notice The number of votes the voter had, which were cast
87         uint96 votes;
88     }
89 
90     /// @notice Possible states that a proposal may be in
91     enum ProposalState {
92         Pending,
93         Active,
94         Canceled,
95         Defeated,
96         Succeeded,
97         Queued,
98         Expired,
99         Executed
100     }
101 
102     /// @notice The official record of all proposals ever proposed
103     mapping(uint256 => Proposal) public proposals;
104 
105     /// @notice The latest proposal for each proposer
106     mapping(address => uint256) public latestProposalIds;
107 
108     /// @notice The EIP-712 typehash for the contract's domain
109     bytes32 public constant DOMAIN_TYPEHASH =
110         keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
111 
112     /// @notice The EIP-712 typehash for the ballot struct used by the contract
113     bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");
114 
115     /// @notice An event emitted when a new proposal is created
116     event ProposalCreated(
117         uint256 id,
118         address proposer,
119         address[] targets,
120         uint256[] values,
121         string[] signatures,
122         bytes[] calldatas,
123         uint256 startBlock,
124         uint256 endBlock,
125         string description
126     );
127 
128     /// @notice An event emitted when a vote has been cast on a proposal
129     event VoteCast(address voter, uint256 proposalId, bool support, uint256 votes);
130 
131     /// @notice An event emitted when a proposal has been canceled
132     event ProposalCanceled(uint256 id);
133 
134     /// @notice An event emitted when a proposal has been queued in the Timelock
135     event ProposalQueued(uint256 id, uint256 eta);
136 
137     /// @notice An event emitted when a proposal has been executed in the Timelock
138     event ProposalExecuted(uint256 id);
139 
140     constructor(
141         address timelock_,
142         address tribe_,
143         address guardian_
144     ) {
145         timelock = TimelockInterface(timelock_);
146         tribe = TribeInterface(tribe_);
147         guardian = guardian_;
148     }
149 
150     function propose(
151         address[] memory targets,
152         uint256[] memory values,
153         string[] memory signatures,
154         bytes[] memory calldatas,
155         string memory description
156     ) public returns (uint256) {
157         require(
158             tribe.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold(),
159             "GovernorAlpha: proposer votes below proposal threshold"
160         );
161         require(
162             targets.length == values.length &&
163                 targets.length == signatures.length &&
164                 targets.length == calldatas.length,
165             "GovernorAlpha: proposal function information arity mismatch"
166         );
167         require(targets.length != 0, "GovernorAlpha: must provide actions");
168         require(targets.length <= proposalMaxOperations(), "GovernorAlpha: too many actions");
169 
170         uint256 latestProposalId = latestProposalIds[msg.sender];
171         if (latestProposalId != 0) {
172             ProposalState proposersLatestProposalState = state(latestProposalId);
173             require(
174                 proposersLatestProposalState != ProposalState.Active,
175                 "GovernorAlpha: one live proposal per proposer, found an already active proposal"
176             );
177             require(
178                 proposersLatestProposalState != ProposalState.Pending,
179                 "GovernorAlpha: one live proposal per proposer, found an already pending proposal"
180             );
181         }
182 
183         uint256 startBlock = add256(block.number, votingDelay());
184         uint256 endBlock = add256(startBlock, votingPeriod());
185 
186         proposalCount++;
187 
188         Proposal storage newProposal = proposals[proposalCount];
189 
190         newProposal.id = proposalCount;
191         newProposal.proposer = msg.sender;
192         newProposal.targets = targets;
193         newProposal.values = values;
194         newProposal.signatures = signatures;
195         newProposal.calldatas = calldatas;
196         newProposal.startBlock = startBlock;
197         newProposal.endBlock = endBlock;
198 
199         latestProposalIds[newProposal.proposer] = newProposal.id;
200 
201         emit ProposalCreated(
202             newProposal.id,
203             msg.sender,
204             targets,
205             values,
206             signatures,
207             calldatas,
208             startBlock,
209             endBlock,
210             description
211         );
212         return newProposal.id;
213     }
214 
215     function queue(uint256 proposalId) public {
216         require(
217             state(proposalId) == ProposalState.Succeeded,
218             "GovernorAlpha: proposal can only be queued if it is succeeded"
219         );
220         Proposal storage proposal = proposals[proposalId];
221         uint256 eta = add256(block.timestamp, timelock.delay());
222         for (uint256 i = 0; i < proposal.targets.length; i++) {
223             _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
224         }
225         proposal.eta = eta;
226         emit ProposalQueued(proposalId, eta);
227     }
228 
229     function _queueOrRevert(
230         address target,
231         uint256 value,
232         string memory signature,
233         bytes memory data,
234         uint256 eta
235     ) internal {
236         require(
237             !timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))),
238             "GovernorAlpha: proposal action already queued at eta"
239         );
240         timelock.queueTransaction(target, value, signature, data, eta);
241     }
242 
243     function execute(uint256 proposalId) public payable {
244         require(
245             state(proposalId) == ProposalState.Queued,
246             "GovernorAlpha: proposal can only be executed if it is queued"
247         );
248         Proposal storage proposal = proposals[proposalId];
249         proposal.executed = true;
250         for (uint256 i = 0; i < proposal.targets.length; i++) {
251             timelock.executeTransaction{value: proposal.values[i]}(
252                 proposal.targets[i],
253                 proposal.values[i],
254                 proposal.signatures[i],
255                 proposal.calldatas[i],
256                 proposal.eta
257             );
258         }
259         emit ProposalExecuted(proposalId);
260     }
261 
262     function cancel(uint256 proposalId) public {
263         ProposalState state = state(proposalId);
264         require(
265             state == ProposalState.Active || state == ProposalState.Pending,
266             "GovernorAlpha: can only cancel Active or Pending Proposal"
267         );
268 
269         Proposal storage proposal = proposals[proposalId];
270         require(
271             msg.sender == guardian ||
272                 tribe.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold(),
273             "GovernorAlpha: proposer above threshold"
274         );
275 
276         proposal.canceled = true;
277         for (uint256 i = 0; i < proposal.targets.length; i++) {
278             timelock.cancelTransaction(
279                 proposal.targets[i],
280                 proposal.values[i],
281                 proposal.signatures[i],
282                 proposal.calldatas[i],
283                 proposal.eta
284             );
285         }
286 
287         emit ProposalCanceled(proposalId);
288     }
289 
290     function getActions(uint256 proposalId)
291         public
292         view
293         returns (
294             address[] memory targets,
295             uint256[] memory values,
296             string[] memory signatures,
297             bytes[] memory calldatas
298         )
299     {
300         Proposal storage p = proposals[proposalId];
301         return (p.targets, p.values, p.signatures, p.calldatas);
302     }
303 
304     function getReceipt(uint256 proposalId, address voter) public view returns (Receipt memory) {
305         return proposals[proposalId].receipts[voter];
306     }
307 
308     function state(uint256 proposalId) public view returns (ProposalState) {
309         require(proposalCount >= proposalId && proposalId > 0, "GovernorAlpha: invalid proposal id");
310         Proposal storage proposal = proposals[proposalId];
311         if (proposal.canceled) {
312             return ProposalState.Canceled;
313         } else if (block.number <= proposal.startBlock) {
314             return ProposalState.Pending;
315         } else if (block.number <= proposal.endBlock) {
316             return ProposalState.Active;
317         } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {
318             return ProposalState.Defeated;
319         } else if (proposal.eta == 0) {
320             return ProposalState.Succeeded;
321         } else if (proposal.executed) {
322             return ProposalState.Executed;
323         } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {
324             return ProposalState.Expired;
325         } else {
326             return ProposalState.Queued;
327         }
328     }
329 
330     function castVote(uint256 proposalId, bool support) public {
331         return _castVote(msg.sender, proposalId, support);
332     }
333 
334     function castVoteBySig(
335         uint256 proposalId,
336         bool support,
337         uint8 v,
338         bytes32 r,
339         bytes32 s
340     ) public {
341         bytes32 domainSeparator = keccak256(
342             abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this))
343         );
344         bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
345         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
346         address signatory = ecrecover(digest, v, r, s);
347         require(signatory != address(0), "GovernorAlpha: invalid signature");
348         return _castVote(signatory, proposalId, support);
349     }
350 
351     function _castVote(
352         address voter,
353         uint256 proposalId,
354         bool support
355     ) internal {
356         require(state(proposalId) == ProposalState.Active, "GovernorAlpha: voting is closed");
357         Proposal storage proposal = proposals[proposalId];
358         Receipt storage receipt = proposal.receipts[voter];
359         require(receipt.hasVoted == false, "GovernorAlpha: voter already voted");
360         uint96 votes = tribe.getPriorVotes(voter, proposal.startBlock);
361 
362         if (support) {
363             proposal.forVotes = add256(proposal.forVotes, votes);
364         } else {
365             proposal.againstVotes = add256(proposal.againstVotes, votes);
366         }
367 
368         receipt.hasVoted = true;
369         receipt.support = support;
370         receipt.votes = votes;
371 
372         emit VoteCast(voter, proposalId, support, votes);
373     }
374 
375     function __acceptAdmin() public {
376         timelock.acceptAdmin();
377     }
378 
379     function __abdicate() public {
380         require(msg.sender == guardian, "GovernorAlpha: sender must be gov guardian");
381         guardian = address(0);
382     }
383 
384     function __transferGuardian(address newGuardian) public {
385         require(msg.sender == guardian, "GovernorAlpha: sender must be gov guardian");
386         guardian = newGuardian;
387     }
388 
389     function __queueSetTimelockPendingAdmin(address newPendingAdmin, uint256 eta) public {
390         require(msg.sender == guardian, "GovernorAlpha: sender must be gov guardian");
391         timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
392     }
393 
394     function __executeSetTimelockPendingAdmin(address newPendingAdmin, uint256 eta) public {
395         require(msg.sender == guardian, "GovernorAlpha: sender must be gov guardian");
396         timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
397     }
398 
399     function add256(uint256 a, uint256 b) internal pure returns (uint256) {
400         uint256 c = a + b;
401         require(c >= a, "addition overflow");
402         return c;
403     }
404 
405     function sub256(uint256 a, uint256 b) internal pure returns (uint256) {
406         require(b <= a, "subtraction underflow");
407         return a - b;
408     }
409 
410     function getChainId() internal view returns (uint256) {
411         uint256 chainId;
412         // solhint-disable-next-line no-inline-assembly
413         assembly {
414             chainId := chainid()
415         }
416         return chainId;
417     }
418 }
419 
420 interface TimelockInterface {
421     function delay() external view returns (uint256);
422 
423     // solhint-disable-next-line func-name-mixedcase
424     function GRACE_PERIOD() external view returns (uint256);
425 
426     function acceptAdmin() external;
427 
428     function queuedTransactions(bytes32 hash) external view returns (bool);
429 
430     function queueTransaction(
431         address target,
432         uint256 value,
433         string calldata signature,
434         bytes calldata data,
435         uint256 eta
436     ) external returns (bytes32);
437 
438     function cancelTransaction(
439         address target,
440         uint256 value,
441         string calldata signature,
442         bytes calldata data,
443         uint256 eta
444     ) external;
445 
446     function executeTransaction(
447         address target,
448         uint256 value,
449         string calldata signature,
450         bytes calldata data,
451         uint256 eta
452     ) external payable returns (bytes memory);
453 }
454 
455 interface TribeInterface {
456     function getPriorVotes(address account, uint256 blockNumber) external view returns (uint96);
457 }
