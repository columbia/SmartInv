1 /*
2 https://powerpool.finance/
3 
4           wrrrw r wrr
5          ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0
6         rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0
7         rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0
8         r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0
9          prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0
10           wrr ww0rrrr
11 
12 */
13 
14 pragma solidity ^0.5.16;
15 
16 interface CvpInterface {
17   /// @notice EIP-20 token name for this token
18   function name() external view returns (string memory);
19 
20   /// @notice EIP-20 token symbol for this token
21   function symbol() external view returns (string memory);
22 
23   /// @notice EIP-20 token decimals for this token
24   function decimals() external view returns (uint8);
25 
26   /// @notice Total number of tokens in circulation
27   function totalSupply() external view returns (uint);
28 
29   /// @notice A record of each accounts delegate
30   function delegates(address _addr) external view returns (address);
31 
32   /// @notice The number of checkpoints for each account
33   function numCheckpoints(address _addr) external view returns (uint32);
34 
35   /// @notice The EIP-712 typehash for the contract's domain
36   function DOMAIN_TYPEHASH() external view returns (bytes32);
37 
38   /// @notice The EIP-712 typehash for the delegation struct used by the contract
39   function DELEGATION_TYPEHASH() external view returns (bytes32);
40 
41   /// @notice A record of states for signing / validating signatures
42   function nonces(address _addr) external view returns (uint);
43 
44   /// @notice An event thats emitted when an account changes its delegate
45   event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
46 
47   /// @notice An event thats emitted when a delegate account's vote balance changes
48   event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
49 
50   /// @notice The standard EIP-20 transfer event
51   event Transfer(address indexed from, address indexed to, uint256 amount);
52 
53   /// @notice The standard EIP-20 approval event
54   event Approval(address indexed owner, address indexed spender, uint256 amount);
55 
56   /**
57    * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
58    * @param account The address of the account holding the funds
59    * @param spender The address of the account spending the funds
60    * @return The number of tokens approved
61    */
62   function allowance(address account, address spender) external view returns (uint);
63 
64   /**
65    * @notice Approve `spender` to transfer up to `amount` from `src`
66    * @dev This will overwrite the approval amount for `spender`
67    *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
68    * @param spender The address of the account which may transfer tokens
69    * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
70    * @return Whether or not the approval succeeded
71    */
72   function approve(address spender, uint rawAmount) external returns (bool);
73 
74   /**
75    * @notice Get the number of tokens held by the `account`
76    * @param account The address of the account to get the balance of
77    * @return The number of tokens held
78    */
79   function balanceOf(address account) external view returns (uint);
80 
81   /**
82    * @notice Transfer `amount` tokens from `msg.sender` to `dst`
83    * @param dst The address of the destination account
84    * @param rawAmount The number of tokens to transfer
85    * @return Whether or not the transfer succeeded
86    */
87   function transfer(address dst, uint rawAmount) external returns (bool);
88 
89   /**
90    * @notice Transfer `amount` tokens from `src` to `dst`
91    * @param src The address of the source account
92    * @param dst The address of the destination account
93    * @param rawAmount The number of tokens to transfer
94    * @return Whether or not the transfer succeeded
95    */
96   function transferFrom(address src, address dst, uint rawAmount) external returns (bool);
97 
98   /**
99    * @notice Delegate votes from `msg.sender` to `delegatee`
100    * @param delegatee The address to delegate votes to
101    */
102   function delegate(address delegatee) external;
103 
104   /**
105    * @notice Delegates votes from signatory to `delegatee`
106    * @param delegatee The address to delegate votes to
107    * @param nonce The contract state required to match the signature
108    * @param expiry The time at which to expire the signature
109    * @param v The recovery byte of the signature
110    * @param r Half of the ECDSA signature pair
111    * @param s Half of the ECDSA signature pair
112    */
113   function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
114 
115   /**
116    * @notice Gets the current votes balance for `account`
117    * @param account The address to get votes balance
118    * @return The number of current votes for `account`
119    */
120   function getCurrentVotes(address account) external view returns (uint96);
121 
122   /**
123    * @notice Determine the prior number of votes for an account as of a block number
124    * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
125    * @param account The address of the account to check
126    * @param blockNumber The block number to get the vote balance at
127    * @return The number of votes the account had as of the given block
128    */
129   function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
130 }
131 
132 pragma solidity ^0.5.16;
133 pragma experimental ABIEncoderV2;
134 
135 
136 contract GovernorAlphaInterface {
137   /// @notice The name of this contract
138   function name() external view returns (string memory);
139 
140   /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
141   function quorumVotes() external pure returns (uint);
142 
143   /// @notice The number of votes required in order for a voter to become a proposer
144   function proposalThreshold() external pure returns (uint);
145 
146   /// @notice The maximum number of actions that can be included in a proposal
147   function proposalMaxOperations() external pure returns (uint);
148 
149   /// @notice The delay before voting on a proposal may take place, once proposed
150   function votingDelay() external pure returns (uint);
151 
152   /// @notice The duration of voting on a proposal, in blocks
153   function votingPeriod() external pure returns (uint);
154 
155   /// @notice The address of the PowerPool Protocol Timelock
156   function timelock() external view returns (TimelockInterface);
157 
158   /// @notice The address of the Governor Guardian
159   function guardian() external view returns (address);
160 
161   /// @notice The total number of proposals
162   function proposalCount() external view returns (uint);
163 
164   /// @notice The official record of all proposals ever proposed
165   function proposals(uint _id) external view returns (
166     uint id,
167     address proposer,
168     uint eta,
169     uint startBlock,
170     uint endBlock,
171     uint forVotes,
172     uint againstVotes,
173     bool canceled,
174     bool executed
175   );
176 
177   enum ProposalState {
178     Pending,
179     Active,
180     Canceled,
181     Defeated,
182     Succeeded,
183     Queued,
184     Expired,
185     Executed
186   }
187 
188   /// @notice Ballot receipt record for a voter
189   struct Receipt {
190     /// @notice Whether or not a vote has been cast
191     bool hasVoted;
192 
193     /// @notice Whether or not the voter supports the proposal
194     bool support;
195 
196     /// @notice The number of votes the voter had, which were cast
197     uint256 votes;
198   }
199 
200   /// @notice The latest proposal for each proposer
201   function latestProposalIds(address _addr) external view returns (uint);
202 
203   /// @notice The EIP-712 typehash for the contract's domain
204   function DOMAIN_TYPEHASH() external view returns (bytes32);
205 
206   /// @notice The EIP-712 typehash for the ballot struct used by the contract
207   function BALLOT_TYPEHASH() external view returns (bytes32);
208 
209   /// @notice An event emitted when a new proposal is created
210   event ProposalCreated(uint indexed id, address indexed proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);
211 
212   /// @notice An event emitted when a vote has been cast on a proposal
213   event VoteCast(address indexed voter, uint indexed proposalId, bool indexed support, uint votes);
214 
215   /// @notice An event emitted when a proposal has been canceled
216   event ProposalCanceled(uint indexed id);
217 
218   /// @notice An event emitted when a proposal has been queued in the Timelock
219   event ProposalQueued(uint indexed id, uint eta);
220 
221   /// @notice An event emitted when a proposal has been executed in the Timelock
222   event ProposalExecuted(uint indexed id);
223 
224   function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint);
225 
226   function queue(uint proposalId) public;
227 
228   function execute(uint proposalId) public payable;
229 
230   function cancel(uint proposalId) public;
231 
232   function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas);
233 
234   function getReceipt(uint proposalId, address voter) public view returns (Receipt memory);
235 
236   function getVoteSources() external view returns (address[] memory);
237 
238   function state(uint proposalId) public view returns (ProposalState);
239 
240   function castVote(uint proposalId, bool support) public;
241 
242   function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public;
243 
244   function __acceptAdmin() public;
245 
246   function __abdicate() public ;
247 
248   function __queueSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public;
249 
250   function __executeSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public;
251 }
252 
253 interface TimelockInterface {
254   function delay() external view returns (uint);
255   function GRACE_PERIOD() external view returns (uint);
256   function acceptAdmin() external;
257   function queuedTransactions(bytes32 hash) external view returns (bool);
258   function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);
259   function cancelTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external;
260   function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);
261 }
262 
263 pragma solidity ^0.5.16;
264 
265 
266 contract PPGovernorL1 is GovernorAlphaInterface {
267   /// @notice The name of this contract
268   string public constant name = "PowerPool Governor L1";
269 
270   /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
271   function quorumVotes() public pure returns (uint) { return 400000e18; } // 400,000 = 0.4% of Cvp
272 
273   /// @notice The number of votes required in order for a voter to become a proposer
274   function proposalThreshold() public pure returns (uint) { return 10000e18; } // 10,000 = 0.01% of Cvp
275 
276   /// @notice The maximum number of actions that can be included in a proposal
277   function proposalMaxOperations() public pure returns (uint) { return 10; } // 10 actions
278 
279   /// @notice The delay before voting on a proposal may take place, once proposed
280   function votingDelay() public pure returns (uint) { return 1; } // 1 block
281 
282   /// @notice The duration of voting on a proposal, in blocks
283   function votingPeriod() public pure returns (uint) { return 17280; } // ~3 days in blocks (assuming 15s blocks)
284 
285   /// @notice The address of the PowerPool Protocol Timelock
286   TimelockInterface public timelock;
287 
288   /// @notice The addresses of the PowerPool-compatible vote sources
289   address[] public voteSources;
290 
291   /// @notice The address of the Governor Guardian
292   address public guardian;
293 
294   /// @notice The total number of proposals
295   uint public proposalCount;
296 
297   struct Proposal {
298     /// @notice Unique id for looking up a proposal
299     uint id;
300 
301     /// @notice Creator of the proposal
302     address proposer;
303 
304     /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
305     uint eta;
306 
307     /// @notice the ordered list of target addresses for calls to be made
308     address[] targets;
309 
310     /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
311     uint[] values;
312 
313     /// @notice The ordered list of function signatures to be called
314     string[] signatures;
315 
316     /// @notice The ordered list of calldata to be passed to each call
317     bytes[] calldatas;
318 
319     /// @notice The block at which voting begins: holders must delegate their votes prior to this block
320     uint startBlock;
321 
322     /// @notice The block at which voting ends: votes must be cast prior to this block
323     uint endBlock;
324 
325     /// @notice Current number of votes in favor of this proposal
326     uint forVotes;
327 
328     /// @notice Current number of votes in opposition to this proposal
329     uint againstVotes;
330 
331     /// @notice Flag marking whether the proposal has been canceled
332     bool canceled;
333 
334     /// @notice Flag marking whether the proposal has been executed
335     bool executed;
336 
337     /// @notice Receipts of ballots for the entire set of voters
338     mapping (address => Receipt) receipts;
339   }
340 
341   /// @notice The official record of all proposals ever proposed
342   mapping (uint => Proposal) public proposals;
343 
344   /// @notice The latest proposal for each proposer
345   mapping (address => uint) public latestProposalIds;
346 
347   /// @notice The EIP-712 typehash for the contract's domain
348   bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
349 
350   /// @notice The EIP-712 typehash for the ballot struct used by the contract
351   bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");
352 
353   constructor(address timelock_, address[] memory voteSources_, address guardian_) public {
354     require(voteSources_.length > 0, "GovernorAlpha::constructor: voteSources can't be empty");
355 
356     timelock = TimelockInterface(timelock_);
357     voteSources = voteSources_;
358     guardian = guardian_;
359   }
360 
361   function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {
362     require(getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold(), "GovernorAlpha::propose: proposer votes below proposal threshold");
363     require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "GovernorAlpha::propose: proposal function information arity mismatch");
364     require(targets.length != 0, "GovernorAlpha::propose: must provide actions");
365     require(targets.length <= proposalMaxOperations(), "GovernorAlpha::propose: too many actions");
366 
367     uint latestProposalId = latestProposalIds[msg.sender];
368     if (latestProposalId != 0) {
369       ProposalState proposersLatestProposalState = state(latestProposalId);
370       require(proposersLatestProposalState != ProposalState.Active, "GovernorAlpha::propose: one live proposal per proposer, found an already active proposal");
371       require(proposersLatestProposalState != ProposalState.Pending, "GovernorAlpha::propose: one live proposal per proposer, found an already pending proposal");
372     }
373 
374     uint startBlock = add256(block.number, votingDelay());
375     uint endBlock = add256(startBlock, votingPeriod());
376 
377     proposalCount++;
378     Proposal memory newProposal = Proposal({
379     id: proposalCount,
380     proposer: msg.sender,
381     eta: 0,
382     targets: targets,
383     values: values,
384     signatures: signatures,
385     calldatas: calldatas,
386     startBlock: startBlock,
387     endBlock: endBlock,
388     forVotes: 0,
389     againstVotes: 0,
390     canceled: false,
391     executed: false
392     });
393 
394     proposals[newProposal.id] = newProposal;
395     latestProposalIds[newProposal.proposer] = newProposal.id;
396 
397     emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);
398     return newProposal.id;
399   }
400 
401   function queue(uint proposalId) public {
402     require(state(proposalId) == ProposalState.Succeeded, "GovernorAlpha::queue: proposal can only be queued if it is succeeded");
403     Proposal storage proposal = proposals[proposalId];
404     uint eta = add256(block.timestamp, timelock.delay());
405     for (uint i = 0; i < proposal.targets.length; i++) {
406       _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
407     }
408     proposal.eta = eta;
409     emit ProposalQueued(proposalId, eta);
410   }
411 
412   function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {
413     require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "GovernorAlpha::_queueOrRevert: proposal action already queued at eta");
414     timelock.queueTransaction(target, value, signature, data, eta);
415   }
416 
417   function execute(uint proposalId) public payable {
418     require(state(proposalId) == ProposalState.Queued, "GovernorAlpha::execute: proposal can only be executed if it is queued");
419     Proposal storage proposal = proposals[proposalId];
420     proposal.executed = true;
421     for (uint i = 0; i < proposal.targets.length; i++) {
422       timelock.executeTransaction.value(proposal.values[i])(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
423     }
424     emit ProposalExecuted(proposalId);
425   }
426 
427   function cancel(uint proposalId) public {
428     ProposalState state = state(proposalId);
429     require(state != ProposalState.Executed, "GovernorAlpha::cancel: cannot cancel executed proposal");
430 
431     Proposal storage proposal = proposals[proposalId];
432     require(msg.sender == guardian || getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold(), "GovernorAlpha::cancel: proposer above threshold");
433 
434     proposal.canceled = true;
435     for (uint i = 0; i < proposal.targets.length; i++) {
436       timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
437     }
438 
439     emit ProposalCanceled(proposalId);
440   }
441 
442   function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {
443     Proposal storage p = proposals[proposalId];
444     return (p.targets, p.values, p.signatures, p.calldatas);
445   }
446 
447   function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {
448     return proposals[proposalId].receipts[voter];
449   }
450 
451   function state(uint proposalId) public view returns (ProposalState) {
452     require(proposalCount >= proposalId && proposalId > 0, "GovernorAlpha::state: invalid proposal id");
453     Proposal storage proposal = proposals[proposalId];
454     if (proposal.canceled) {
455       return ProposalState.Canceled;
456     } else if (block.number <= proposal.startBlock) {
457       return ProposalState.Pending;
458     } else if (block.number <= proposal.endBlock) {
459       return ProposalState.Active;
460     } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes()) {
461       return ProposalState.Defeated;
462     } else if (proposal.eta == 0) {
463       return ProposalState.Succeeded;
464     } else if (proposal.executed) {
465       return ProposalState.Executed;
466     } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {
467       return ProposalState.Expired;
468     } else {
469       return ProposalState.Queued;
470     }
471   }
472 
473   function getPriorVotes(address account, uint256 blockNumber) public view returns (uint256) {
474     uint256 total = 0;
475     uint256 len = voteSources.length;
476 
477     for (uint256 i = 0; i < len; i++) {
478       total = add256(total, CvpInterface(voteSources[i]).getPriorVotes(account, blockNumber));
479     }
480 
481     return total;
482   }
483 
484   function getVoteSources() external view returns (address[] memory) {
485     return voteSources;
486   }
487 
488   function castVote(uint proposalId, bool support) public {
489     return _castVote(msg.sender, proposalId, support);
490   }
491 
492   function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {
493     bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
494     bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
495     bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
496     address signatory = ecrecover(digest, v, r, s);
497     require(signatory != address(0), "GovernorAlpha::castVoteBySig: invalid signature");
498     return _castVote(signatory, proposalId, support);
499   }
500 
501   function _castVote(address voter, uint proposalId, bool support) internal {
502     require(state(proposalId) == ProposalState.Active, "GovernorAlpha::_castVote: voting is closed");
503     Proposal storage proposal = proposals[proposalId];
504     Receipt storage receipt = proposal.receipts[voter];
505     require(receipt.hasVoted == false, "GovernorAlpha::_castVote: voter already voted");
506     uint256 votes = getPriorVotes(voter, proposal.startBlock);
507 
508     if (support) {
509       proposal.forVotes = add256(proposal.forVotes, votes);
510     } else {
511       proposal.againstVotes = add256(proposal.againstVotes, votes);
512     }
513 
514     receipt.hasVoted = true;
515     receipt.support = support;
516     receipt.votes = votes;
517 
518     emit VoteCast(voter, proposalId, support, votes);
519   }
520 
521   function __acceptAdmin() public {
522     require(msg.sender == guardian, "GovernorAlpha::__acceptAdmin: sender must be gov guardian");
523     timelock.acceptAdmin();
524   }
525 
526   function __abdicate() public {
527     require(msg.sender == guardian, "GovernorAlpha::__abdicate: sender must be gov guardian");
528     guardian = address(0);
529   }
530 
531   function __queueSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {
532     require(msg.sender == guardian, "GovernorAlpha::__queueSetTimelockPendingAdmin: sender must be gov guardian");
533     timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
534   }
535 
536   function __executeSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {
537     require(msg.sender == guardian, "GovernorAlpha::__executeSetTimelockPendingAdmin: sender must be gov guardian");
538     timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
539   }
540 
541   function add256(uint256 a, uint256 b) internal pure returns (uint) {
542     uint c = a + b;
543     require(c >= a, "addition overflow");
544     return c;
545   }
546 
547   function sub256(uint256 a, uint256 b) internal pure returns (uint) {
548     require(b <= a, "subtraction underflow");
549     return a - b;
550   }
551 
552   function getChainId() internal pure returns (uint) {
553     uint chainId;
554     assembly { chainId := chainid() }
555     return chainId;
556   }
557 }