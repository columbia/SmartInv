1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-01-23
7 */
8 
9 // File: github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
10 
11 pragma solidity ^0.5.0;
12 
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a); // dev: overflow
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a); // dev: underflow
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b); // dev: overflow
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0); // dev: divide by zero
28         c = a / b;
29     }
30 }
31 /*
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with GSN meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 contract Context {
42     // Empty internal constructor, to prevent people from mistakenly deploying
43     // an instance of this contract, which should be used via inheritance.
44     constructor () internal { }
45     // solhint-disable-previous-line no-empty-blocks
46 
47     function _msgSender() internal view returns (address payable) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view returns (bytes memory) {
52         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
53         return msg.data;
54     }
55 }
56 
57 // File: github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/IRelayHub.sol
58 
59 pragma solidity ^0.5.0;
60 
61 /**
62  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
63  * directly.
64  *
65  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
66  * how to deploy an instance of `RelayHub` on your local test network.
67  */
68 interface IRelayHub {
69     // Relay management
70 
71     /**
72      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
73      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
74      * cannot be its own owner.
75      *
76      * All Ether in this function call will be added to the relay's stake.
77      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
78      *
79      * Emits a {Staked} event.
80      */
81     function stake(address relayaddr, uint256 unstakeDelay) external payable;
82 
83     /**
84      * @dev Emitted when a relay's stake or unstakeDelay are increased
85      */
86     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
87 
88     /**
89      * @dev Registers the caller as a relay.
90      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
91      *
92      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
93      * `transactionFee` is not enforced by {relayCall}.
94      *
95      * Emits a {RelayAdded} event.
96      */
97     function registerRelay(uint256 transactionFee, string calldata url) external;
98 
99     /**
100      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
101      * {RelayRemoved} events) lets a client discover the list of available relays.
102      */
103     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
104 
105     /**
106      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
107      *
108      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
109      * callable.
110      *
111      * Emits a {RelayRemoved} event.
112      */
113     function removeRelayByOwner(address relay) external;
114 
115     /**
116      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
117      */
118     event RelayRemoved(address indexed relay, uint256 unstakeTime);
119 
120     /** Deletes the relay from the system, and gives back its stake to the owner.
121      *
122      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
123      *
124      * Emits an {Unstaked} event.
125      */
126     function unstake(address relay) external;
127 
128     /**
129      * @dev Emitted when a relay is unstaked for, including the returned stake.
130      */
131     event Unstaked(address indexed relay, uint256 stake);
132 
133     // States a relay can be in
134     enum RelayState {
135         Unknown, // The relay is unknown to the system: it has never been staked for
136         Staked, // The relay has been staked for, but it is not yet active
137         Registered, // The relay has registered itself, and is active (can relay calls)
138         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
139     }
140 
141     /**
142      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
143      * to return an empty entry.
144      */
145     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
146 
147     // Balance management
148 
149     /**
150      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
151      *
152      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
153      *
154      * Emits a {Deposited} event.
155      */
156     function depositFor(address target) external payable;
157 
158     /**
159      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
160      */
161     event Deposited(address indexed recipient, address indexed from, uint256 amount);
162 
163     /**
164      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
165      */
166     function balanceOf(address target) external view returns (uint256);
167 
168     /**
169      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
170      * contracts can use it to reduce their funding.
171      *
172      * Emits a {Withdrawn} event.
173      */
174     function withdraw(uint256 amount, address payable dest) external;
175 
176     /**
177      * @dev Emitted when an account withdraws funds from `RelayHub`.
178      */
179     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
180 
181     // Relaying
182 
183     /**
184      * @dev Checks if the `RelayHub` will accept a relayed operation.
185      * Multiple things must be true for this to happen:
186      *  - all arguments must be signed for by the sender (`from`)
187      *  - the sender's nonce must be the current one
188      *  - the recipient must accept this transaction (via {acceptRelayedCall})
189      *
190      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
191      * code if it returns one in {acceptRelayedCall}.
192      */
193     function canRelay(
194         address relay,
195         address from,
196         address to,
197         bytes calldata encodedFunction,
198         uint256 transactionFee,
199         uint256 gasPrice,
200         uint256 gasLimit,
201         uint256 nonce,
202         bytes calldata signature,
203         bytes calldata approvalData
204     ) external view returns (uint256 status, bytes memory recipientContext);
205 
206     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
207     enum PreconditionCheck {
208         OK,                         // All checks passed, the call can be relayed
209         WrongSignature,             // The transaction to relay is not signed by requested sender
210         WrongNonce,                 // The provided nonce has already been used by the sender
211         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
212         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
213     }
214 
215     /**
216      * @dev Relays a transaction.
217      *
218      * For this to succeed, multiple conditions must be met:
219      *  - {canRelay} must `return PreconditionCheck.OK`
220      *  - the sender must be a registered relay
221      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
222      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
223      * recipient) use all gas available to them
224      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
225      * spent)
226      *
227      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
228      * function and {postRelayedCall} will be called in that order.
229      *
230      * Parameters:
231      *  - `from`: the client originating the request
232      *  - `to`: the target {IRelayRecipient} contract
233      *  - `encodedFunction`: the function call to relay, including data
234      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
235      *  - `gasPrice`: gas price the client is willing to pay
236      *  - `gasLimit`: gas to forward when calling the encoded function
237      *  - `nonce`: client's nonce
238      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
239      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
240      * `RelayHub`, but it still can be used for e.g. a signature.
241      *
242      * Emits a {TransactionRelayed} event.
243      */
244     function relayCall(
245         address from,
246         address to,
247         bytes calldata encodedFunction,
248         uint256 transactionFee,
249         uint256 gasPrice,
250         uint256 gasLimit,
251         uint256 nonce,
252         bytes calldata signature,
253         bytes calldata approvalData
254     ) external;
255 
256     /**
257      * @dev Emitted when an attempt to relay a call failed.
258      *
259      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
260      * actual relayed call was not executed, and the recipient not charged.
261      *
262      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
263      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
264      */
265     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
266 
267     /**
268      * @dev Emitted when a transaction is relayed. 
269      * Useful when monitoring a relay's operation and relayed calls to a contract
270      *
271      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
272      *
273      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
274      */
275     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
276 
277     // Reason error codes for the TransactionRelayed event
278     enum RelayCallStatus {
279         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
280         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
281         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
282         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
283         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
284     }
285 
286     /**
287      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
288      * spend up to `relayedCallStipend` gas.
289      */
290     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
291 
292     /**
293      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
294      */
295     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
296 
297      // Relay penalization. 
298      // Any account can penalize relays, removing them from the system immediately, and rewarding the
299     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
300     // still loses half of its stake.
301 
302     /**
303      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
304      * different data (gas price, gas limit, etc. may be different).
305      *
306      * The (unsigned) transaction data and signature for both transactions must be provided.
307      */
308     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
309 
310     /**
311      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
312      */
313     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
314 
315     /**
316      * @dev Emitted when a relay is penalized.
317      */
318     event Penalized(address indexed relay, address sender, uint256 amount);
319 
320     /**
321      * @dev Returns an account's nonce in `RelayHub`.
322      */
323     function getNonce(address from) external view returns (uint256);
324 }
325 
326 
327 // File: github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/IRelayRecipient.sol
328 
329 pragma solidity ^0.5.0;
330 
331 /**
332  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
333  *
334  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
335  */
336 interface IRelayRecipient {
337     /**
338      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
339      */
340     function getHubAddr() external view returns (address);
341 
342     /**
343      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
344      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
345      *
346      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
347      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
348      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
349      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
350      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
351      * over all or some of the previous values.
352      *
353      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
354      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
355      *
356      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
357      * rejected. A regular revert will also trigger a rejection.
358      */
359     function acceptRelayedCall(
360         address relay,
361         address from,
362         bytes calldata encodedFunction,
363         uint256 transactionFee,
364         uint256 gasPrice,
365         uint256 gasLimit,
366         uint256 nonce,
367         bytes calldata approvalData,
368         uint256 maxPossibleCharge
369     )
370         external
371         view
372         returns (uint256, bytes memory);
373 
374     /**
375      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
376      * pre-charge the sender of the transaction.
377      *
378      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
379      *
380      * Returns a value to be passed to {postRelayedCall}.
381      *
382      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
383      * will not be executed, but the recipient will still be charged for the transaction's cost.
384      */
385     function preRelayedCall(bytes calldata context) external returns (bytes32);
386 
387     /**
388      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
389      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
390      * contract-specific bookkeeping.
391      *
392      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
393      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
394      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
395      *
396      *
397      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
398      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
399      * transaction's cost.
400      */
401     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
402 }
403 
404 // File: github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/GSNRecipient.sol
405 
406 pragma solidity ^0.5.0;
407 
408 
409 
410 
411 /**
412  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
413  * and enables GSN support on all contracts in the inheritance tree.
414  *
415  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
416  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
417  * provided by derived contracts. See the
418  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
419  * information on how to use the pre-built {GSNRecipientSignature} and
420  * {GSNRecipientERC20Fee}, or how to write your own.
421  */
422 contract GSNRecipient is IRelayRecipient, Context {
423     // Default RelayHub address, deployed on mainnet and all testnets at the same address
424     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
425 
426     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
427     uint256 constant private RELAYED_CALL_REJECTED = 11;
428 
429     // How much gas is forwarded to postRelayedCall
430     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
431 
432     /**
433      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
434      */
435     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
436 
437     /**
438      * @dev Returns the address of the {IRelayHub} contract for this recipient.
439      */
440     function getHubAddr() public view returns (address) {
441         return _relayHub;
442     }
443 
444     /**
445      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
446      * use the default instance.
447      *
448      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
449      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
450      */
451     function _upgradeRelayHub(address newRelayHub) internal {
452         address currentRelayHub = _relayHub;
453         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
454         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
455 
456         emit RelayHubChanged(currentRelayHub, newRelayHub);
457 
458         _relayHub = newRelayHub;
459     }
460 
461     /**
462      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
463      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
464      */
465     // This function is view for future-proofing, it may require reading from
466     // storage in the future.
467     function relayHubVersion() public view returns (string memory) {
468         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
469         return "1.0.0";
470     }
471 
472     /**
473      * @dev Withdraws the recipient's deposits in `RelayHub`.
474      *
475      * Derived contracts should expose this in an external interface with proper access control.
476      */
477     function _withdrawDeposits(uint256 amount, address payable payee) internal {
478         IRelayHub(_relayHub).withdraw(amount, payee);
479     }
480 
481     // Overrides for Context's functions: when called from RelayHub, sender and
482     // data require some pre-processing: the actual sender is stored at the end
483     // of the call data, which in turns means it needs to be removed from it
484     // when handling said data.
485 
486     /**
487      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
488      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
489      *
490      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
491      */
492     function _msgSender() internal view returns (address payable) {
493         if (msg.sender != _relayHub) {
494             return msg.sender;
495         } else {
496             return _getRelayedCallSender();
497         }
498     }
499 
500     /**
501      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
502      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
503      *
504      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
505      */
506     function _msgData() internal view returns (bytes memory) {
507         if (msg.sender != _relayHub) {
508             return msg.data;
509         } else {
510             return _getRelayedCallData();
511         }
512     }
513 
514     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
515     // internal hook.
516 
517     /**
518      * @dev See `IRelayRecipient.preRelayedCall`.
519      *
520      * This function should not be overriden directly, use `_preRelayedCall` instead.
521      *
522      * * Requirements:
523      *
524      * - the caller must be the `RelayHub` contract.
525      */
526     function preRelayedCall(bytes calldata context) external returns (bytes32) {
527         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
528         return _preRelayedCall(context);
529     }
530 
531     /**
532      * @dev See `IRelayRecipient.preRelayedCall`.
533      *
534      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
535      * must implement this function with any relayed-call preprocessing they may wish to do.
536      *
537      */
538     function _preRelayedCall(bytes memory context) internal returns (bytes32);
539 
540     /**
541      * @dev See `IRelayRecipient.postRelayedCall`.
542      *
543      * This function should not be overriden directly, use `_postRelayedCall` instead.
544      *
545      * * Requirements:
546      *
547      * - the caller must be the `RelayHub` contract.
548      */
549     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
550         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
551         _postRelayedCall(context, success, actualCharge, preRetVal);
552     }
553 
554     /**
555      * @dev See `IRelayRecipient.postRelayedCall`.
556      *
557      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
558      * must implement this function with any relayed-call postprocessing they may wish to do.
559      *
560      */
561     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
562 
563     /**
564      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
565      * will be charged a fee by RelayHub
566      */
567     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
568         return _approveRelayedCall("");
569     }
570 
571     /**
572      * @dev See `GSNRecipient._approveRelayedCall`.
573      *
574      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
575      */
576     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
577         return (RELAYED_CALL_ACCEPTED, context);
578     }
579 
580     /**
581      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
582      */
583     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
584         return (RELAYED_CALL_REJECTED + errorCode, "");
585     }
586 
587     /*
588      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
589      * `serviceFee`.
590      */
591     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
592         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
593         // charged for 1.4 times the spent amount.
594         return (gas * gasPrice * (100 + serviceFee)) / 100;
595     }
596 
597     function _getRelayedCallSender() private pure returns (address payable result) {
598         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
599         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
600         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
601         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
602         // bytes. This can always be done due to the 32-byte prefix.
603 
604         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
605         // easiest/most-efficient way to perform this operation.
606 
607         // These fields are not accessible from assembly
608         bytes memory array = msg.data;
609         uint256 index = msg.data.length;
610 
611         // solhint-disable-next-line no-inline-assembly
612         assembly {
613             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
614             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
615         }
616         return result;
617     }
618 
619     function _getRelayedCallData() private pure returns (bytes memory) {
620         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
621         // we must strip the last 20 bytes (length of an address type) from it.
622 
623         uint256 actualDataLength = msg.data.length - 20;
624         bytes memory actualData = new bytes(actualDataLength);
625 
626         for (uint256 i = 0; i < actualDataLength; ++i) {
627             actualData[i] = msg.data[i];
628         }
629 
630         return actualData;
631     }
632 }
633 
634 // File: browser/dex-adapter-simple.sol
635 
636 library Math {
637     /**
638      * @dev Returns the largest of two numbers.
639      */
640     function max(uint256 a, uint256 b) internal pure returns (uint256) {
641         return a >= b ? a : b;
642     }
643 
644     /**
645      * @dev Returns the smallest of two numbers.
646      */
647     function min(uint256 a, uint256 b) internal pure returns (uint256) {
648         return a < b ? a : b;
649     }
650 
651     /**
652      * @dev Returns the average of two numbers. The result is rounded towards
653      * zero.
654      */
655     function average(uint256 a, uint256 b) internal pure returns (uint256) {
656         // (a + b) / 2 can overflow, so we distribute
657         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
658     }
659 }
660 
661 interface IERC20 {
662     function transfer(address recipient, uint256 amount) external returns (bool);
663     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
664     function approve(address _spender, uint256 _value) external returns (bool);
665     function balanceOf(address _owner) external view returns (uint256 balance);
666 }
667 
668 interface IGateway {
669     function mint(bytes32 _pHash, uint256 _amount, bytes32 _nHash, bytes calldata _sig) external returns (uint256);
670     function burn(bytes calldata _to, uint256 _amount) external returns (uint256);
671 }
672 
673 interface IGatewayRegistry {
674     function getGatewayBySymbol(string calldata _tokenSymbol) external view returns (IGateway);
675     function getGatewayByToken(address  _tokenAddress) external view returns (IGateway);
676     function getTokenBySymbol(string calldata _tokenSymbol) external view returns (IERC20);
677 }
678 
679 interface IUniswapExchange {
680     function tokenToEthTransferOutput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
681     function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
682     function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
683     function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
684     function tokenAddress() external view returns (address);
685 }
686 
687 interface ICurveExchange {
688     function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
689 
690     function get_dy(int128, int128 j, uint256 dx) external view returns (uint256);
691 
692     function calc_token_amount(uint256[2] calldata amounts, bool deposit) external returns (uint256 amount);
693 
694     function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount) external;
695 
696     function remove_liquidity(
697         uint256 _amount,
698         uint256[2] calldata min_amounts
699     ) external;
700 
701     function remove_liquidity_imbalance(uint256[2] calldata amounts, uint256 max_burn_amount) external;
702 
703     function remove_liquidity_one_coin(uint256 _token_amounts, int128 i, uint256 min_amount) external;
704 }
705 
706 contract CurveExchangeAdapter is GSNRecipient {
707     using SafeMath for uint256;
708     
709     IERC20 RENBTC;
710     IERC20 WBTC;
711     IERC20 curveToken;
712 
713     ICurveExchange public exchange;  
714     IGatewayRegistry public registry;
715 
716     event SwapReceived(uint256 mintedAmount, uint256 wbtcAmount);
717     event DepositMintedCurve(uint256 mintedAmount, uint256 curveAmount);
718     event ReceiveRen(uint256 renAmount);
719     event Burn(uint256 burnAmount);
720 
721     constructor(ICurveExchange _exchange, IGatewayRegistry _registry, IERC20 _wbtc) public {
722         exchange = _exchange;
723         registry = _registry;
724         RENBTC = registry.getTokenBySymbol("BTC");
725         WBTC = _wbtc;
726         address curveTokenAddress = 0x49849C98ae39Fff122806C06791Fa73784FB3675;
727         curveToken = IERC20(curveTokenAddress);
728         
729         // Approve exchange.
730         require(RENBTC.approve(address(exchange), uint256(-1)));
731         require(WBTC.approve(address(exchange), uint256(-1)));
732     }
733     
734     // GSN Support
735     function acceptRelayedCall(
736         address,
737         address,
738         bytes calldata,
739         uint256,
740         uint256,
741         uint256,
742         uint256,
743         bytes calldata,
744         uint256
745     ) external view returns (uint256, bytes memory) {
746         return _approveRelayedCall();
747     }
748     
749     function _preRelayedCall(bytes memory context) internal returns (bytes32) {
750     }
751     
752     function _postRelayedCall(bytes memory context, bool, uint256 actualCharge, bytes32) internal {
753     }
754     
755     function mintThenSwap(
756         uint256 _minExchangeRate,
757         uint256 _newMinExchangeRate,
758         uint256 _slippage,
759         address payable _wbtcDestination,
760         uint256 _amount,
761         bytes32 _nHash,
762         bytes calldata _sig
763     ) external {
764         // Mint renBTC tokens
765         bytes32 pHash = keccak256(abi.encode(_minExchangeRate, _slippage, _wbtcDestination, _msgSender()));
766         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
767         
768         // Get price
769         uint256 dy = exchange.get_dy(0, 1, mintedAmount);
770         uint256 rate = dy.mul(1e8).div(mintedAmount);
771         _slippage = uint256(1e4).sub(_slippage);
772         uint256 min_dy = mintedAmount.mul(rate).mul(_slippage).div(1e8).div(1e4);
773         
774         // Price is OK
775         if (rate >= _newMinExchangeRate) {
776             uint256 startWbtcBalance = WBTC.balanceOf(address(this));
777             exchange.exchange(0, 1, mintedAmount, min_dy);
778 
779             uint256 endWbtcBalance = WBTC.balanceOf(address(this));
780             uint256 wbtcBought = endWbtcBalance.sub(startWbtcBalance);
781         
782             //Send proceeds to the User
783             require(WBTC.transfer(_wbtcDestination, wbtcBought));
784             emit SwapReceived(mintedAmount, wbtcBought);
785         } else {
786             //Send renBTC to the User instead
787             require(RENBTC.transfer(_wbtcDestination, mintedAmount));
788             emit ReceiveRen(mintedAmount);
789         }
790     }
791 
792     function mintThenDeposit(
793         address payable _wbtcDestination, 
794         uint256 _amount, 
795         uint256[2] calldata _amounts, 
796         uint256 _min_mint_amount, 
797         uint256 _new_min_mint_amount, 
798         bytes32 _nHash, 
799         bytes calldata _sig
800     ) external {
801         // Mint renBTC tokens
802         bytes32 pHash = keccak256(abi.encode(_wbtcDestination, _amounts, _min_mint_amount, _msgSender()));
803         //use actual _amount the user sent
804         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
805 
806         //set renBTC to actual minted amount in case the user sent less BTC to Ren
807         uint256[2] memory receivedAmounts = _amounts;
808         receivedAmounts[0] = mintedAmount;
809         uint256 calc_token_amount = exchange.calc_token_amount(_amounts, true);
810         if(calc_token_amount >= _new_min_mint_amount) {
811             require(WBTC.transferFrom(msg.sender, address(this), receivedAmounts[1]));
812             uint256 curveBalanceBefore = curveToken.balanceOf(address(this));
813             exchange.add_liquidity(receivedAmounts, 0);
814             uint256 curveBalanceAfter = curveToken.balanceOf(address(this));
815             uint256 curveAmount = curveBalanceAfter.sub(curveBalanceBefore);
816             require(curveAmount >= _new_min_mint_amount);
817             require(curveToken.transfer(msg.sender, curveAmount));
818             emit DepositMintedCurve(mintedAmount, curveAmount);
819         }
820         else {
821             require(RENBTC.transfer(_wbtcDestination, mintedAmount));
822             emit ReceiveRen(mintedAmount);
823         }
824     }
825 
826     function mintNoSwap(
827         uint256 _minExchangeRate,
828         uint256 _newMinExchangeRate,
829         uint256 _slippage,
830         address payable _wbtcDestination,
831         uint256 _amount,
832         bytes32 _nHash,
833         bytes calldata _sig
834     ) external {
835         bytes32 pHash = keccak256(abi.encode(_minExchangeRate, _slippage, _wbtcDestination, _msgSender()));
836         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
837         
838         require(RENBTC.transfer(_wbtcDestination, mintedAmount));
839         emit ReceiveRen(mintedAmount);
840     }
841 
842     function mintNoDeposit(
843         address payable _wbtcDestination, 
844         uint256 _amount, 
845         uint256[2] calldata _amounts, 
846         uint256 _min_mint_amount, 
847         uint256 _new_min_mint_amount, 
848         bytes32 _nHash, 
849         bytes calldata _sig
850     ) external {
851          // Mint renBTC tokens
852         bytes32 pHash = keccak256(abi.encode(_wbtcDestination, _amounts, _min_mint_amount, _msgSender()));
853         //use actual _amount the user sent
854         uint256 mintedAmount = registry.getGatewayBySymbol("BTC").mint(pHash, _amount, _nHash, _sig);
855 
856         require(RENBTC.transfer(_wbtcDestination, mintedAmount));
857         emit ReceiveRen(mintedAmount);
858     }
859 
860     function removeLiquidityThenBurn(bytes calldata _btcDestination, uint256 amount, uint256[2] calldata min_amounts) external {
861         uint256 startRenbtcBalance = RENBTC.balanceOf(address(this));
862         uint256 startWbtcBalance = WBTC.balanceOf(address(this));
863         require(curveToken.transferFrom(msg.sender, address(this), amount));
864         exchange.remove_liquidity(amount, min_amounts);
865         uint256 endRenbtcBalance = RENBTC.balanceOf(address(this));
866         uint256 endWbtcBalance = WBTC.balanceOf(address(this));
867         uint256 wbtcWithdrawn = endWbtcBalance.sub(startWbtcBalance);
868         require(WBTC.transfer(msg.sender, wbtcWithdrawn));
869         uint256 renbtcWithdrawn = endRenbtcBalance.sub(startRenbtcBalance);
870 
871         // Burn and send proceeds to the User
872         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcWithdrawn);
873         emit Burn(burnAmount);
874     }
875 
876     function removeLiquidityImbalanceThenBurn(bytes calldata _btcDestination, uint256[2] calldata amounts, uint256 max_burn_amount) external {
877         uint256 startRenbtcBalance = RENBTC.balanceOf(address(this));
878         uint256 startWbtcBalance = WBTC.balanceOf(address(this));
879         uint256 _tokens = curveToken.balanceOf(msg.sender);
880         if(_tokens > max_burn_amount) { 
881             _tokens = max_burn_amount;
882         }
883         require(curveToken.transferFrom(msg.sender, address(this), _tokens));
884         exchange.remove_liquidity_imbalance(amounts, max_burn_amount.mul(101).div(100));
885         _tokens = curveToken.balanceOf(address(this));
886         require(curveToken.transfer(msg.sender, _tokens));
887         uint256 endRenbtcBalance = RENBTC.balanceOf(address(this));
888         uint256 endWbtcBalance = WBTC.balanceOf(address(this));
889         uint256 renbtcWithdrawn = endRenbtcBalance.sub(startRenbtcBalance);
890         uint256 wbtcWithdrawn = endWbtcBalance.sub(startWbtcBalance);
891         require(WBTC.transfer(msg.sender, wbtcWithdrawn));
892 
893         // Burn and send proceeds to the User
894         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcWithdrawn);
895         emit Burn(burnAmount);
896     }
897 
898     //always removing in renBTC, else use normal method
899     function removeLiquidityOneCoinThenBurn(bytes calldata _btcDestination, uint256 _token_amounts, uint256 min_amount) external {
900         uint256 startRenbtcBalance = RENBTC.balanceOf(address(this));
901         require(curveToken.transferFrom(msg.sender, address(this), _token_amounts));
902         exchange.remove_liquidity_one_coin(_token_amounts, 0, min_amount);
903         uint256 endRenbtcBalance = RENBTC.balanceOf(address(this));
904         uint256 renbtcWithdrawn = endRenbtcBalance.sub(startRenbtcBalance);
905 
906         // Burn and send proceeds to the User
907         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcWithdrawn);
908         emit Burn(burnAmount);
909     }
910     
911     function swapThenBurn(bytes calldata _btcDestination, uint256 _amount, uint256 _minRenbtcAmount) external {
912         require(WBTC.transferFrom(msg.sender, address(this), _amount));
913         uint256 startRenbtcBalance = RENBTC.balanceOf(address(this));
914         exchange.exchange(1, 0, _amount, _minRenbtcAmount);
915         uint256 endRenbtcBalance = RENBTC.balanceOf(address(this));
916         uint256 renbtcBought = endRenbtcBalance.sub(startRenbtcBalance);
917         
918         // Burn and send proceeds to the User
919         uint256 burnAmount = registry.getGatewayBySymbol("BTC").burn(_btcDestination, renbtcBought);
920         emit Burn(burnAmount);
921     }
922 }