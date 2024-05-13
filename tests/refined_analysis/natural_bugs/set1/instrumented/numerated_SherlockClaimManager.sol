1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 // This contract contains the logic for handling claims
10 // The idea is that the first level of handling a claim is the Sherlock Protocol Claims Committee (SPCC)(a multisig)
11 // If a protocol agent doesn't like that result, they can escalate the claim to UMA's Optimistic Oracle (OO), who will be the final decision
12 // We also build in a multisig (controlled by UMA) to give the final approve to pay out after the OO approves a claim
13 
14 import './Manager.sol';
15 import '../interfaces/managers/ISherlockClaimManager.sol';
16 import '../interfaces/managers/ISherlockProtocolManager.sol';
17 import '../interfaces/UMAprotocol/SkinnyOptimisticOracleInterface.sol';
18 
19 import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
20 
21 /// @dev expects 6 decimals input tokens
22 contract SherlockClaimManager is ISherlockClaimManager, ReentrancyGuard, Manager {
23   using SafeERC20 for IERC20;
24 
25   /// @dev at time of writing, the escalation cost will be 22.2k
26   /// assuming BOND = 9600 and UMA's final fee = 1500
27   /// UMA's final fee can be changed in the future, which may result in lower or higher required staked amounts for escalating a claim.
28   /// The actual amount is 2 * (BOND + UMA's final fee), because:
29   /// 1. The first half is charged when calling UMA.requestAndProposePriceFor()
30   /// 2. The second half is charged when calling UMA.disputePriceFor()
31   /// UMA's fee can be found here: https://github.com/UMAprotocol/protocol/blob/master/packages/core/contracts/oracle/implementation/Store.sol#L131)
32   uint256 internal constant BOND = 9_600 * 10**6;
33 
34   // The amount of time the protocol agent has to escalate a claim
35   uint256 public constant ESCALATE_TIME = 4 weeks;
36 
37   // The UMA Halt Operator (UMAHO) is the multisig (controlled by UMA) who gives final approval to pay out a claim
38   // After the OO has voted to pay out
39   // This variable represents the amount of time during which UMAHO can block a claim that was approved by the OO
40   // After this time period, the claim (which was approved by the OO) is inferred to be approved by UMAHO as well
41   uint256 public constant UMAHO_TIME = 24 hours;
42 
43   // The amount of time the Sherlock Protocol Claims Committee (SPCC) gets to decide on a claim
44   // If no action is taken by SPCC during this time, then the protocol agent can escalate the decision to the UMA OO
45   uint256 public constant SPCC_TIME = 7 days;
46 
47   // A pre-defined amount of time for the proposed price ($0) to be disputed within the OO
48   // Note This value is not important as we immediately dispute the proposed price
49   // 7200 represents 2 hours
50   uint256 internal constant LIVENESS = 7200;
51 
52   // This is how UMA will know that Sherlock is requesting a decision from the OO
53   // This is "SHERLOCK_CLAIM" in hex value
54   bytes32 public constant override UMA_IDENTIFIER =
55     bytes32(0x534845524c4f434b5f434c41494d000000000000000000000000000000000000);
56 
57   uint256 public constant MAX_CALLBACKS = 4;
58 
59   // The Optimistic Oracle contract that we interact with
60   SkinnyOptimisticOracleInterface public constant UMA =
61     SkinnyOptimisticOracleInterface(0xeE3Afe347D5C74317041E2618C49534dAf887c24);
62 
63   // USDC
64   IERC20 public constant TOKEN = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
65 
66   // The address of the multisig controlled by UMA that can emergency halt a claim that was approved by the OO
67   address public override umaHaltOperator;
68   // The address of the multisig controlled by Sherlock advisors who make the first judgment on a claim
69   address public immutable override sherlockProtocolClaimsCommittee;
70 
71   // Takes a protocol's internal ID as a key and whether or not the protocol has a claim active as the value
72   // Note Each protocol can only have one claim active at a time (this prevents spam)
73   mapping(bytes32 => bool) public protocolClaimActive;
74 
75   // A protocol's public claim ID is simply incremented by 1 from the last claim ID made by any protocol (1, 2, 3, etc.)
76   // A protocol's internal ID is the keccak256() of a protocol's ancillary data field
77   // A protocol's ancillary data field will contain info like the hash of the protocol's coverage agreement (each will be unique)
78   // The public ID (1, 2, 3, etc.) is easy to track while the internal ID is used for interacting with UMA
79   mapping(uint256 => bytes32) internal publicToInternalID;
80 
81   // Opposite of the last field, allows us to move between a protocol's public ID and internal ID
82   mapping(bytes32 => uint256) internal internalToPublicID;
83 
84   // Protocol's internal ID is the key, active claim is the value
85   // Claim object is initialized in startClaim() below
86   // See ISherlockClaimManager.sol for Claim struct
87   mapping(bytes32 => Claim) internal claims_;
88 
89   // The last claim ID we used for a claim (ID is incremented by 1 each time)
90   uint256 internal lastClaimID;
91 
92   // A request object used in the UMA OO
93   SkinnyOptimisticOracleInterface.Request private umaRequest;
94 
95   // An array of contracts that implement the callback provided in this contract
96   ISherlockClaimManagerCallbackReceiver[] public claimCallbacks;
97 
98   // Used for callbacks on UMA functions
99   // This modifier is used for a function being called by the OO contract, requires this contract as caller
100   // Requires the OO contract to pass in the Sherlock identifier
101   modifier onlyUMA(bytes32 identifier) {
102     if (identifier != UMA_IDENTIFIER) revert InvalidArgument();
103     if (msg.sender != address(UMA)) revert InvalidSender();
104     _;
105   }
106 
107   // Only the Sherlock Claims Committee multisig can call a function with this modifier
108   modifier onlySPCC() {
109     if (msg.sender != sherlockProtocolClaimsCommittee) revert InvalidSender();
110     _;
111   }
112 
113   // Only the UMA Halt Operator multisig can call a function with this modifier
114   modifier onlyUMAHO() {
115     if (msg.sender != umaHaltOperator) revert InvalidSender();
116     _;
117   }
118 
119   // We pass in the contract addresses (both will be multisigs) in the constructor
120   constructor(address _umaho, address _spcc) {
121     if (_umaho == address(0)) revert ZeroArgument();
122     if (_spcc == address(0)) revert ZeroArgument();
123 
124     umaHaltOperator = _umaho;
125     sherlockProtocolClaimsCommittee = _spcc;
126   }
127 
128   // Checks to see if a claim can be escalated to the UMA OO
129   // Claim must be either
130   // 1) Denied by SPCC and within 4 weeks after denial
131   // 2) Pending by SPCC but beyond the designated time window for SPCC to respond
132   function _isEscalateState(State _oldState, uint256 updated) internal view returns (bool) {
133     if (_oldState == State.SpccDenied && block.timestamp <= updated + ESCALATE_TIME) return true;
134 
135     uint256 spccDeadline = updated + SPCC_TIME;
136     if (
137       _oldState == State.SpccPending &&
138       spccDeadline < block.timestamp &&
139       block.timestamp <= spccDeadline + ESCALATE_TIME
140     ) {
141       return true;
142     }
143     return false;
144   }
145 
146   // Checks to see if a claim can be paid out
147   // Will be paid out if:
148   // 1) SPCC approved it
149   // 2) UMA OO approved it and there is no UMAHO anymore
150   // 3) UMA OO approved it and the designated window for the UMAHO to block it has passed
151   function _isPayoutState(State _oldState, uint256 updated) internal view returns (bool) {
152     if (_oldState == State.SpccApproved) return true;
153 
154     // If there is no UMA Halt Operator, then it can be paid out on UmaApproved state
155     if (umaHaltOperator == address(0)) {
156       if (_oldState == State.UmaApproved) return true;
157     } else {
158       // If there IS a nonzero UMAHO address, must wait for UMAHO halt period to pass
159       if (_oldState == State.UmaApproved && updated + UMAHO_TIME < block.timestamp) return true;
160     }
161     return false;
162   }
163 
164   function _isCleanupState(State _oldState) internal pure returns (bool) {
165     if (_oldState == State.SpccDenied) return true;
166     if (_oldState == State.SpccPending) return true;
167     return false;
168   }
169 
170   // Deletes the data associated with a claim (after claim has reached its final state)
171   // _claimIdentifier is the internal claim ID
172   function _cleanUpClaim(bytes32 _claimIdentifier) internal {
173     // Protocol no longer has an active claim associated with it
174     delete protocolClaimActive[claims_[_claimIdentifier].protocol];
175     // Claim object is deleted
176     delete claims_[_claimIdentifier];
177 
178     uint256 publicID = internalToPublicID[_claimIdentifier];
179     // Deletes the public and internal ID key mappings
180     delete publicToInternalID[publicID];
181     delete internalToPublicID[_claimIdentifier];
182   }
183 
184   // Each claim has a state that represents what part of the claims process it is in
185   // _claimIdentifier is the internal claim ID
186   // _state represents the state to which a protocol's state field will be changed
187   // See ISherlockClaimManager.sol for the State enum
188   function _setState(bytes32 _claimIdentifier, State _state) internal returns (State _oldState) {
189     // retrieves the Claim object
190     Claim storage claim = claims_[_claimIdentifier];
191     // retrieves the current state (which we preemptively set to the old state)
192     _oldState = claim.state;
193 
194     emit ClaimStatusChanged(internalToPublicID[_claimIdentifier], _oldState, _state);
195 
196     // If the new state is NonExistent, then we clean up this claim (delete the claim effectively)
197     // Else we update the state to the new state and record the last updated timestamp
198     if (_state == State.NonExistent) {
199       _cleanUpClaim(_claimIdentifier);
200     } else {
201       claims_[_claimIdentifier].state = _state;
202       claims_[_claimIdentifier].updated = block.timestamp;
203     }
204   }
205 
206   // Allows us to remove the UMA Halt Operator multisig address if we decide we no longer need UMAHO's services
207   /// @notice gov is able to renounce the role
208   function renounceUmaHaltOperator() external override onlyOwner {
209     if (umaHaltOperator == address(0)) revert InvalidConditions();
210 
211     delete umaHaltOperator;
212     emit UMAHORenounced();
213   }
214 
215   // Returns the Claim struct for a given claim ID (function takes public ID but converts to internal ID)
216   function claim(uint256 _claimID) external view override returns (Claim memory claim_) {
217     bytes32 id_ = publicToInternalID[_claimID];
218     if (id_ == bytes32(0)) revert InvalidArgument();
219 
220     claim_ = claims_[id_];
221     if (claim_.state == State.NonExistent) revert InvalidArgument();
222   }
223 
224   // This function allows a new contract to be added that will implement PreCorePayoutCallback()
225   // The intention of this callback is to allow other contracts to trigger payouts, etc. when Sherlock triggers one
226   // This would be helpful for a reinsurer who should pay out when Sherlock pays out
227   // Data is passed to the "reinsurer" so it can know if it should pay out and how much
228   /// @dev only add trusted and gas verified callbacks.
229   function addCallback(ISherlockClaimManagerCallbackReceiver _callback)
230     external
231     onlyOwner
232     nonReentrant
233   {
234     if (address(_callback) == address(0)) revert ZeroArgument();
235     // Checks to see if the max amount of callback contracts has been reached
236     if (claimCallbacks.length == MAX_CALLBACKS) revert InvalidState();
237     // Checks to see if this callback contract already exists
238     for (uint256 i; i < claimCallbacks.length; i++) {
239       if (claimCallbacks[i] == _callback) revert InvalidArgument();
240     }
241 
242     claimCallbacks.push(_callback);
243     emit CallbackAdded(_callback);
244   }
245 
246   // This removes a contract from the claimCallbacks array
247   function removeCallback(ISherlockClaimManagerCallbackReceiver _callback, uint256 _index)
248     external
249     onlyOwner
250     nonReentrant
251   {
252     if (address(_callback) == address(0)) revert ZeroArgument();
253     // If the index and the callback contract don't line up, revert
254     if (claimCallbacks[_index] != _callback) revert InvalidArgument();
255 
256     // Move last index to index of _callback
257     // Creates a copy of the last index value and pastes it over the _index value
258     claimCallbacks[_index] = claimCallbacks[claimCallbacks.length - 1];
259     // Remove last index (because it is now a duplicate)
260     claimCallbacks.pop();
261     emit CallbackRemoved(_callback);
262   }
263 
264   /// @notice Cleanup claim if escalation is not pursued
265   /// @param _protocol protocol ID
266   /// @param _claimID public claim ID
267   /// @dev Retrieves current protocol agent for cleanup
268   /// @dev State is either SpccPending or SpccDenied
269   function cleanUp(bytes32 _protocol, uint256 _claimID) external whenNotPaused {
270     if (_protocol == bytes32(0)) revert ZeroArgument();
271     if (_claimID == uint256(0)) revert ZeroArgument();
272 
273     // Gets the instance of the protocol manager contract
274     ISherlockProtocolManager protocolManager = sherlockCore.sherlockProtocolManager();
275     // Gets the protocol agent associated with the protocol ID passed in
276     address agent = protocolManager.protocolAgent(_protocol);
277     // Caller of this function must be the protocol agent address associated with the protocol ID passed in
278     if (msg.sender != agent) revert InvalidSender();
279 
280     bytes32 claimIdentifier = publicToInternalID[_claimID];
281     // If there is no active claim
282     if (claimIdentifier == bytes32(0)) revert InvalidArgument();
283 
284     Claim storage claim = claims_[claimIdentifier];
285     // verify if claim belongs to protocol agent
286     if (claim.protocol != _protocol) revert InvalidArgument();
287 
288     State _oldState = _setState(claimIdentifier, State.Cleaned);
289     if (_isCleanupState(_oldState) == false) revert InvalidState();
290     if (_setState(claimIdentifier, State.NonExistent) != State.Cleaned) revert InvalidState();
291   }
292 
293   /// @notice Initiate a claim for a specific protocol as the protocol agent
294   /// @param _protocol protocol ID (different from the internal or public claim ID fields)
295   /// @param _amount amount of USDC which is being claimed by the protocol
296   /// @param _receiver address to receive the amount of USDC being claimed
297   /// @param _timestamp timestamp at which the exploit first occurred
298   /// @param ancillaryData other data associated with the claim, such as the coverage agreement
299   /// @dev The protocol agent that starts a claim will be the protocol agent during the claims lifecycle
300   /// @dev Even if the protocol agent role is tranferred during the lifecycle
301   /// @dev This is done because a protocols coverage can end after an exploit, either wilfully or forcefully.
302   /// @dev The protocol agent is still active for 7 days after coverage ends, so a claim can still be submitted.
303   /// @dev Approved claims after the 7 day period will still be paid, where the amount will be sent to the recevier.
304   function startClaim(
305     bytes32 _protocol,
306     uint256 _amount,
307     address _receiver,
308     uint32 _timestamp,
309     bytes memory ancillaryData
310   ) external override nonReentrant whenNotPaused {
311     if (_protocol == bytes32(0)) revert ZeroArgument();
312     if (_amount == uint256(0)) revert ZeroArgument();
313     if (_receiver == address(0)) revert ZeroArgument();
314     if (_timestamp == uint32(0)) revert ZeroArgument();
315     if (_timestamp >= block.timestamp) revert InvalidArgument();
316     if (ancillaryData.length == 0) revert ZeroArgument();
317     if (address(sherlockCore) == address(0)) revert InvalidConditions();
318     // Protocol must not already have another claim active
319     if (protocolClaimActive[_protocol]) revert ClaimActive();
320 
321     // Creates the internal ID for this claim
322     bytes32 claimIdentifier = keccak256(ancillaryData);
323     // State for this newly created claim must be equal to the default state (NonExistent)
324     if (claims_[claimIdentifier].state != State.NonExistent) revert InvalidArgument();
325 
326     // Gets the instance of the protocol manager contract
327     ISherlockProtocolManager protocolManager = sherlockCore.sherlockProtocolManager();
328     // Gets the protocol agent associated with the protocol ID passed in
329     address agent = protocolManager.protocolAgent(_protocol);
330     // Caller of this function must be the protocol agent address associated with the protocol ID passed in
331     if (msg.sender != agent) revert InvalidSender();
332 
333     // Gets the current and previous coverage amount for this protocol
334     (uint256 current, uint256 previous) = protocolManager.coverageAmounts(_protocol);
335     // The max amount a protocol can claim is the higher of the current and previous coverage amounts
336     uint256 maxClaim = current > previous ? current : previous;
337     // True if a protocol is claiming based on its previous coverage amount (only used in event emission)
338     // Current coverage takes precedence over the previous one, which means the only case this is true
339     // is when claimed amount is greater than current coverage.
340     bool prevCoverage = _amount > current;
341     // Requires the amount claimed is less than or equal to the higher of the current and previous coverage amounts
342     if (_amount > maxClaim) revert InvalidArgument();
343 
344     // Increments the last claim ID by 1 to get the public claim ID
345     // Note initial claimID will be 1
346     uint256 claimID = ++lastClaimID;
347     // Protocol now has an active claim
348     protocolClaimActive[_protocol] = true;
349     // Sets the mappings for public and internal claim IDs
350     publicToInternalID[claimID] = claimIdentifier;
351     internalToPublicID[claimIdentifier] = claimID;
352 
353     // Initializes a Claim object and adds it to claims_ mapping
354     // Created and updated fields are set to current time
355     // State is updated to SpccPending (waiting on SPCC decision now)
356     claims_[claimIdentifier] = Claim(
357       block.timestamp,
358       block.timestamp,
359       msg.sender,
360       _protocol,
361       _amount,
362       _receiver,
363       _timestamp,
364       State.SpccPending,
365       ancillaryData
366     );
367 
368     emit ClaimCreated(claimID, _protocol, _amount, _receiver, prevCoverage);
369     emit ClaimStatusChanged(claimID, State.NonExistent, State.SpccPending);
370   }
371 
372   // Only SPCC can call this
373   // SPCC approves the claim and it can now be paid out
374   // Requires that the last state of the claim was SpccPending
375   function spccApprove(uint256 _claimID) external override whenNotPaused onlySPCC nonReentrant {
376     bytes32 claimIdentifier = publicToInternalID[_claimID];
377     if (claimIdentifier == bytes32(0)) revert InvalidArgument();
378 
379     if (_setState(claimIdentifier, State.SpccApproved) != State.SpccPending) revert InvalidState();
380   }
381 
382   // Only SPCC can call this
383   // SPCC denies the claim and now the protocol agent can escalate to UMA OO if they desire
384   function spccRefuse(uint256 _claimID) external override whenNotPaused onlySPCC nonReentrant {
385     bytes32 claimIdentifier = publicToInternalID[_claimID];
386     if (claimIdentifier == bytes32(0)) revert InvalidArgument();
387 
388     if (_setState(claimIdentifier, State.SpccDenied) != State.SpccPending) revert InvalidState();
389   }
390 
391   // If SPCC denied (or didn't respond to) the claim, a protocol agent can now escalate it to UMA's OO
392   /// @notice Callable by protocol agent
393   /// @param _claimID Public claim ID
394   /// @param _amount Bond amount sent by protocol agent
395   /// @dev Use hardcoded USDC address
396   /// @dev Use hardcoded bond amount
397   /// @dev Use hardcoded liveness 7200 (2 hours)
398   /// @dev Requires the caller to be the account that initially started the claim
399   // Amount sent needs to be at least equal to the BOND amount required
400   function escalate(uint256 _claimID, uint256 _amount)
401     external
402     override
403     nonReentrant
404     whenNotPaused
405   {
406     if (_amount < BOND) revert InvalidArgument();
407 
408     // Gets the internal ID of the claim
409     bytes32 claimIdentifier = publicToInternalID[_claimID];
410     if (claimIdentifier == bytes32(0)) revert InvalidArgument();
411 
412     // Retrieves the claim struct
413     Claim storage claim = claims_[claimIdentifier];
414     // Requires the caller to be the account that initially started the claim
415     if (msg.sender != claim.initiator) revert InvalidSender();
416 
417     // Timestamp when claim was last updated
418     uint256 updated = claim.updated;
419     // Sets the state to UmaPriceProposed
420     State _oldState = _setState(claimIdentifier, State.UmaPriceProposed);
421 
422     // Can this claim be updated (based on its current state)? If no, revert
423     if (_isEscalateState(_oldState, updated) == false) revert InvalidState();
424 
425     // Transfers the bond amount from the protocol agent to this address
426     TOKEN.safeTransferFrom(msg.sender, address(this), _amount);
427     // Approves the OO contract to spend the bond amount
428     TOKEN.safeApprove(address(UMA), _amount);
429 
430     // Sherlock protocol proposes a claim amount of $0 to the UMA OO to begin with
431     // This line https://github.com/UMAprotocol/protocol/blob/master/packages/core/contracts/oracle/implementation/SkinnyOptimisticOracle.sol#L585
432     // Will result in disputeSuccess=true if the DVM resolved price != 0
433     // Note: The resolved price needs to exactly match the claim amount
434     // Otherwise the `umaApproved` in our settled callback will be false
435     UMA.requestAndProposePriceFor(
436       UMA_IDENTIFIER, // Sherlock ID so UMA knows the request came from Sherlock
437       claim.timestamp, // Timestamp to identify the request
438       claim.ancillaryData, // Ancillary data such as the coverage agreement
439       TOKEN, // USDC
440       0, // Reward is 0, Sherlock handles rewards on its own
441       BOND, // Cost of making a request to the UMA OO (as decided by Sherlock)
442       LIVENESS, // Proposal liveness
443       address(sherlockCore), // If escalated claim fails, bond amount gets sent to sherlockCore
444       0 // price
445     );
446 
447     // If the state is not equal to ReadyToProposeUmaDispute, revert
448     // Then set the new state to UmaDisputeProposed
449     // Note State gets set to ReadyToProposeUmaDispute in the callback function from requestAndProposePriceFor()
450     if (_setState(claimIdentifier, State.UmaDisputeProposed) != State.ReadyToProposeUmaDispute) {
451       revert InvalidState();
452     }
453 
454     // The protocol agent is now disputing Sherlock's proposed claim amount of $0
455     UMA.disputePriceFor(
456       UMA_IDENTIFIER, // Sherlock ID so UMA knows the request came from Sherlock
457       claim.timestamp, // Timestamp to identify the request
458       claim.ancillaryData, // Ancillary data such as the coverage agreement
459       umaRequest, // Refers to the original request made by Sherlock in requestAndProposePriceFor()
460       msg.sender, // Protocol agent, known as the disputer (the one who is disputing Sherlock's $0 proposed claim amount)
461       address(this) // This contract's address is the requester (Sherlock made the original request and proposed $0 claim amount)
462     );
463 
464     // State gets updated to UmaPending in the disputePriceFor() callback (priceDisputed())
465     if (claim.state != State.UmaPending) revert InvalidState();
466 
467     // Deletes the original request made by Sherlock
468     delete umaRequest;
469     // Approves the OO to spend $0
470     // This is just out of caution, don't want UMA to be approved for any amount of tokens they shouldn't be
471     TOKEN.safeApprove(address(UMA), 0);
472     // Checks for remaining balance in the contract
473     uint256 remaining = TOKEN.balanceOf(address(this));
474     // Sends remaining balance to the protocol agent
475     // A protocol agent should be able to send the exact amount to avoid the extra gas from this function
476     if (remaining != 0) TOKEN.safeTransfer(msg.sender, remaining);
477   }
478 
479   // Checks to make sure a payout is valid, then calls the core Sherlock payout function
480   /// @notice Execute claim, storage will be removed after
481   /// @param _claimID Public ID of the claim
482   /// @dev Needs to be SpccApproved or UmaApproved && >UMAHO_TIME
483   /// @dev Funds will be pulled from core
484   // We are ok with spending the extra time to wait for the UMAHO time to expire before paying out
485   // We could have UMAHO multisig send a tx to confirm the payout (payout would happen sooner),
486   // But doesn't seem worth it to save half a day or so
487   function payoutClaim(uint256 _claimID) external override nonReentrant whenNotPaused {
488     bytes32 claimIdentifier = publicToInternalID[_claimID];
489     if (claimIdentifier == bytes32(0)) revert InvalidArgument();
490 
491     Claim storage claim = claims_[claimIdentifier];
492     // Only the claim initiator can call this, and payout gets sent to receiver address
493     if (msg.sender != claim.initiator) revert InvalidSender();
494 
495     bytes32 protocol = claim.protocol;
496     // Address to receive the payout
497     // Note We could make the receiver a param in this function, but we want it to be known asap
498     // Can find and correct problems if the receiver is specified when the claim is initiated
499     address receiver = claim.receiver;
500     // Amount (in USDC) to be paid out
501     uint256 amount = claim.amount;
502     // Time when claim was last updated
503     uint256 updated = claim.updated;
504 
505     // Sets new state to NonExistent as the claim is over once it is paid out
506     State _oldState = _setState(claimIdentifier, State.NonExistent);
507     // Checks to make sure this claim can be paid out
508     if (_isPayoutState(_oldState, updated) == false) revert InvalidState();
509 
510     // Calls the PreCorePayoutCallback function on any contracts in claimCallbacks
511     for (uint256 i; i < claimCallbacks.length; i++) {
512       claimCallbacks[i].PreCorePayoutCallback(protocol, _claimID, amount);
513     }
514 
515     emit ClaimPayout(_claimID, receiver, amount);
516 
517     // We could potentially transfer more than `amount` in case balance > amount
518     // We are leaving this as is for simplicity's sake
519     // We don't expect to have tokens in this contract unless a reinsurer is providing them for a payout
520     // In which case they should provide the exact amount, and balance == amount is true
521     uint256 balance = TOKEN.balanceOf(address(this));
522     if (balance != 0) TOKEN.safeTransfer(receiver, balance);
523     if (balance < amount) sherlockCore.payoutClaim(receiver, amount - balance);
524   }
525 
526   /// @notice UMAHO is able to execute a halt if the state is UmaApproved and state was updated less than UMAHO_TIME ago
527   // Once the UMAHO_TIME is up, UMAHO can still halt the claim, but only if the claim hasn't been paid out yet
528   function executeHalt(uint256 _claimID) external override whenNotPaused onlyUMAHO nonReentrant {
529     bytes32 claimIdentifier = publicToInternalID[_claimID];
530     if (claimIdentifier == bytes32(0)) revert InvalidArgument();
531 
532     // Sets state of claim to nonexistent, reverts if the old state was anything but UmaApproved
533     if (_setState(claimIdentifier, State.Halted) != State.UmaApproved) revert InvalidState();
534     if (_setState(claimIdentifier, State.NonExistent) != State.Halted) revert InvalidState();
535 
536     emit ClaimHalted(_claimID);
537   }
538 
539   //
540   // UMA callbacks
541   //
542 
543   // Once requestAndProposePriceFor() is executed in UMA's contracts, this function gets called
544   // We change the claim's state from UmaPriceProposed to ReadyToProposeUmaDispute
545   // Then, the next callback in the process, disputePriceFor(), gets called by the UMA's contract.
546   // @note Does not have reentrancy protection because it is called by the OO contract which is non-reentrant.
547   function priceProposed(
548     bytes32 identifier,
549     uint32 timestamp,
550     bytes memory ancillaryData,
551     SkinnyOptimisticOracleInterface.Request memory request
552   ) external override whenNotPaused onlyUMA(identifier) {
553     bytes32 claimIdentifier = keccak256(ancillaryData);
554 
555     Claim storage claim = claims_[claimIdentifier];
556     if (claim.updated != block.timestamp) revert InvalidConditions();
557 
558     // Sets state to ReadyToProposeUmaDispute
559     if (_setState(claimIdentifier, State.ReadyToProposeUmaDispute) != State.UmaPriceProposed) {
560       revert InvalidState();
561     }
562     // Sets global umaRequest variable to the request coming from this price proposal
563     umaRequest = request;
564   }
565 
566   // Once disputePriceFor() is executed in UMA's contracts, this function gets called
567   // We change the claim's state from UmaDisputeProposed to UmaPending
568   // Then, the next callback in the process, priceSettled(), gets called by the UMA's contract.
569   // @note Does not have reentrancy protection because it is called by the OO contract which is non-reentrant.
570   function priceDisputed(
571     bytes32 identifier,
572     uint32 timestamp,
573     bytes memory ancillaryData,
574     SkinnyOptimisticOracleInterface.Request memory request
575   ) external override whenNotPaused onlyUMA(identifier) {
576     bytes32 claimIdentifier = keccak256(ancillaryData);
577 
578     Claim storage claim = claims_[claimIdentifier];
579     if (claim.updated != block.timestamp) revert InvalidConditions();
580 
581     // Sets state to UmaPending
582     if (_setState(claimIdentifier, State.UmaPending) != State.UmaDisputeProposed) {
583       revert InvalidState();
584     }
585   }
586 
587   // Once priceSettled() is executed in UMA's contracts, this function gets called
588   // UMA OO gives back a resolved price (either 0 or claim.amount) and
589   // Claim's state is changed to either UmaApproved or UmaDenied
590   // If UmaDenied, the claim is dead and state is immediately changed to NonExistent and cleaned up
591   /// @dev still want to capture settled price in a paused state. Otherwise claim is stuck.
592   function priceSettled(
593     bytes32 identifier,
594     uint32 timestamp,
595     bytes memory ancillaryData,
596     SkinnyOptimisticOracleInterface.Request memory request
597   ) external override onlyUMA(identifier) nonReentrant {
598     bytes32 claimIdentifier = keccak256(ancillaryData);
599 
600     Claim storage claim = claims_[claimIdentifier];
601 
602     // Retrives the resolved price for this claim (either 0 if Sherlock wins, or the amount of the claim as proposed by the protocol agent)
603     uint256 resolvedPrice = uint256(request.resolvedPrice);
604     // UMA approved the claim if the resolved price is equal to the claim amount set by the protocol agent
605     bool umaApproved = resolvedPrice == claim.amount;
606 
607     // If UMA approves the claim, set state to UmaApproved
608     // If UMA denies, set state to UmaDenied, then to NonExistent (deletes the claim data)
609     if (umaApproved) {
610       if (_setState(claimIdentifier, State.UmaApproved) != State.UmaPending) revert InvalidState();
611     } else {
612       if (_setState(claimIdentifier, State.UmaDenied) != State.UmaPending) revert InvalidState();
613       if (_setState(claimIdentifier, State.NonExistent) != State.UmaDenied) revert InvalidState();
614     }
615   }
616 }
