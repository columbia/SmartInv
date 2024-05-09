1 // File: @openzeppelin/upgrades/contracts/Initializable.sol
2 
3 pragma solidity >=0.4.24 <0.6.0;
4 
5 
6 /**
7  * @title Initializable
8  *
9  * @dev Helper contract to support initializer functions. To use it, replace
10  * the constructor with a function that has the `initializer` modifier.
11  * WARNING: Unlike constructors, initializer functions must be manually
12  * invoked. This applies both to deploying an Initializable contract, as well
13  * as extending an Initializable contract via inheritance.
14  * WARNING: When used with inheritance, manual care must be taken to not invoke
15  * a parent initializer twice, or ensure that all initializers are idempotent,
16  * because this is not dealt with automatically as with constructors.
17  */
18 contract Initializable {
19 
20   /**
21    * @dev Indicates that the contract has been initialized.
22    */
23   bool private initialized;
24 
25   /**
26    * @dev Indicates that the contract is in the process of being initialized.
27    */
28   bool private initializing;
29 
30   /**
31    * @dev Modifier to use in the initializer function of a contract.
32    */
33   modifier initializer() {
34     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
35 
36     bool isTopLevelCall = !initializing;
37     if (isTopLevelCall) {
38       initializing = true;
39       initialized = true;
40     }
41 
42     _;
43 
44     if (isTopLevelCall) {
45       initializing = false;
46     }
47   }
48 
49   /// @dev Returns true if and only if the function is running in the constructor
50   function isConstructor() private view returns (bool) {
51     // extcodesize checks the size of the code stored in an address, and
52     // address returns the current address. Since the code is still not
53     // deployed when running a constructor, any checks on its code size will
54     // yield zero, making it an effective way to detect if a contract is
55     // under construction or not.
56     uint256 cs;
57     assembly { cs := extcodesize(address) }
58     return cs == 0;
59   }
60 
61   // Reserved storage space to allow for layout changes in the future.
62   uint256[50] private ______gap;
63 }
64 
65 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/IRelayRecipient.sol
66 
67 pragma solidity ^0.5.0;
68 
69 /*
70  * @dev Interface for a contract that will be called via the GSN from RelayHub.
71  */
72 contract IRelayRecipient {
73     /**
74      * @dev Returns the address of the RelayHub instance this recipient interacts with.
75      */
76     function getHubAddr() public view returns (address);
77 
78     function acceptRelayedCall(
79         address relay,
80         address from,
81         bytes calldata encodedFunction,
82         uint256 transactionFee,
83         uint256 gasPrice,
84         uint256 gasLimit,
85         uint256 nonce,
86         bytes calldata approvalData,
87         uint256 maxPossibleCharge
88     )
89         external
90         view
91         returns (uint256, bytes memory);
92 
93     function preRelayedCall(bytes calldata context) external returns (bytes32);
94 
95     function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) external;
96 }
97 
98 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/bouncers/GSNBouncerBase.sol
99 
100 pragma solidity ^0.5.0;
101 
102 
103 /*
104  * @dev Base contract used to implement GSNBouncers.
105  *
106  * > This contract does not perform all required tasks to implement a GSN
107  * recipient contract: end users should use `GSNRecipient` instead.
108  */
109 contract GSNBouncerBase is IRelayRecipient {
110     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
111     uint256 constant private RELAYED_CALL_REJECTED = 11;
112 
113     // How much gas is forwarded to postRelayedCall
114     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
115 
116     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
117     // internal hook.
118 
119     /**
120      * @dev See `IRelayRecipient.preRelayedCall`.
121      *
122      * This function should not be overriden directly, use `_preRelayedCall` instead.
123      *
124      * * Requirements:
125      *
126      * - the caller must be the `RelayHub` contract.
127      */
128     function preRelayedCall(bytes calldata context) external returns (bytes32) {
129         require(msg.sender == getHubAddr(), "GSNBouncerBase: caller is not RelayHub");
130         return _preRelayedCall(context);
131     }
132 
133     /**
134      * @dev See `IRelayRecipient.postRelayedCall`.
135      *
136      * This function should not be overriden directly, use `_postRelayedCall` instead.
137      *
138      * * Requirements:
139      *
140      * - the caller must be the `RelayHub` contract.
141      */
142     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
143         require(msg.sender == getHubAddr(), "GSNBouncerBase: caller is not RelayHub");
144         _postRelayedCall(context, success, actualCharge, preRetVal);
145     }
146 
147     /**
148      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
149      * will be charged a fee by RelayHub
150      */
151     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
152         return _approveRelayedCall("");
153     }
154 
155     /**
156      * @dev See `GSNBouncerBase._approveRelayedCall`.
157      *
158      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
159      */
160     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
161         return (RELAYED_CALL_ACCEPTED, context);
162     }
163 
164     /**
165      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
166      */
167     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
168         return (RELAYED_CALL_REJECTED + errorCode, "");
169     }
170 
171     // Empty hooks for pre and post relayed call: users only have to define these if they actually use them.
172 
173     function _preRelayedCall(bytes memory) internal returns (bytes32) {
174         // solhint-disable-previous-line no-empty-blocks
175     }
176 
177     function _postRelayedCall(bytes memory, bool, uint256, bytes32) internal {
178         // solhint-disable-previous-line no-empty-blocks
179     }
180 
181     /*
182      * @dev Calculates how much RelaHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
183      * `serviceFee`.
184      */
185     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
186         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
187         // charged for 1.4 times the spent amount.
188         return (gas * gasPrice * (100 + serviceFee)) / 100;
189     }
190 }
191 
192 // File: @openzeppelin/contracts-ethereum-package/contracts/cryptography/ECDSA.sol
193 
194 pragma solidity ^0.5.2;
195 
196 /**
197  * @title Elliptic curve signature operations
198  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
199  * TODO Remove this library once solidity supports passing a signature to ecrecover.
200  * See https://github.com/ethereum/solidity/issues/864
201  */
202 
203 library ECDSA {
204     /**
205      * @dev Recover signer address from a message by using their signature
206      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
207      * @param signature bytes signature, the signature is generated using web3.eth.sign()
208      */
209     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
210         // Check the signature length
211         if (signature.length != 65) {
212             return (address(0));
213         }
214 
215         // Divide the signature in r, s and v variables
216         bytes32 r;
217         bytes32 s;
218         uint8 v;
219 
220         // ecrecover takes the signature parameters, and the only way to get them
221         // currently is to use assembly.
222         // solhint-disable-next-line no-inline-assembly
223         assembly {
224             r := mload(add(signature, 0x20))
225             s := mload(add(signature, 0x40))
226             v := byte(0, mload(add(signature, 0x60)))
227         }
228 
229         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
230         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
231         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
232         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
233         //
234         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
235         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
236         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
237         // these malleable signatures as well.
238         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
239             return address(0);
240         }
241 
242         if (v != 27 && v != 28) {
243             return address(0);
244         }
245 
246         // If the signature is valid (and not malleable), return the signer address
247         return ecrecover(hash, v, r, s);
248     }
249 
250     /**
251      * toEthSignedMessageHash
252      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
253      * and hash the result
254      */
255     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
256         // 32 is the length in bytes of hash,
257         // enforced by the type signature above
258         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
259     }
260 }
261 
262 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/bouncers/GSNBouncerSignature.sol
263 
264 pragma solidity ^0.5.0;
265 
266 
267 
268 
269 contract GSNBouncerSignature is Initializable, GSNBouncerBase {
270     using ECDSA for bytes32;
271 
272     // We use a random storage slot to allow proxy contracts to enable GSN support in an upgrade without changing their
273     // storage layout. This value is calculated as: keccak256('gsn.bouncer.signature.trustedSigner'), minus 1.
274     bytes32 constant private TRUSTED_SIGNER_STORAGE_SLOT = 0xe7b237a4017a399d277819456dce32c2356236bbc518a6d84a9a8d1cfdf1e9c5;
275 
276     enum GSNBouncerSignatureErrorCodes {
277         INVALID_SIGNER
278     }
279 
280     function initialize(address trustedSigner) public initializer {
281         _setTrustedSigner(trustedSigner);
282     }
283 
284     function acceptRelayedCall(
285         address relay,
286         address from,
287         bytes calldata encodedFunction,
288         uint256 transactionFee,
289         uint256 gasPrice,
290         uint256 gasLimit,
291         uint256 nonce,
292         bytes calldata approvalData,
293         uint256
294     )
295         external
296         view
297         returns (uint256, bytes memory)
298     {
299         bytes memory blob = abi.encodePacked(
300             relay,
301             from,
302             encodedFunction,
303             transactionFee,
304             gasPrice,
305             gasLimit,
306             nonce, // Prevents replays on RelayHub
307             getHubAddr(), // Prevents replays in multiple RelayHubs
308             address(this) // Prevents replays in multiple recipients
309         );
310         if (keccak256(blob).toEthSignedMessageHash().recover(approvalData) == _getTrustedSigner()) {
311             return _approveRelayedCall();
312         } else {
313             return _rejectRelayedCall(uint256(GSNBouncerSignatureErrorCodes.INVALID_SIGNER));
314         }
315     }
316 
317     function _getTrustedSigner() private view returns (address trustedSigner) {
318       bytes32 slot = TRUSTED_SIGNER_STORAGE_SLOT;
319       // solhint-disable-next-line no-inline-assembly
320       assembly {
321         trustedSigner := sload(slot)
322       }
323     }
324 
325     function _setTrustedSigner(address trustedSigner) private {
326       bytes32 slot = TRUSTED_SIGNER_STORAGE_SLOT;
327       // solhint-disable-next-line no-inline-assembly
328       assembly {
329         sstore(slot, trustedSigner)
330       }
331     }
332 }
333 
334 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
335 
336 pragma solidity ^0.5.0;
337 
338 /*
339  * @dev Provides information about the current execution context, including the
340  * sender of the transaction and its data. While these are generally available
341  * via msg.sender and msg.data, they not should not be accessed in such a direct
342  * manner, since when dealing with GSN meta-transactions the account sending and
343  * paying for execution may not be the actual sender (as far as an application
344  * is concerned).
345  *
346  * This contract is only required for intermediate, library-like contracts.
347  */
348 contract Context {
349     // Empty internal constructor, to prevent people from mistakenly deploying
350     // an instance of this contract, with should be used via inheritance.
351     constructor () internal { }
352     // solhint-disable-previous-line no-empty-blocks
353 
354     function _msgSender() internal view returns (address) {
355         return msg.sender;
356     }
357 
358     function _msgData() internal view returns (bytes memory) {
359         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
360         return msg.data;
361     }
362 }
363 
364 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/GSNContext.sol
365 
366 pragma solidity ^0.5.0;
367 
368 
369 
370 /*
371  * @dev Enables GSN support on `Context` contracts by recognizing calls from
372  * RelayHub and extracting the actual sender and call data from the received
373  * calldata.
374  *
375  * > This contract does not perform all required tasks to implement a GSN
376  * recipient contract: end users should use `GSNRecipient` instead.
377  */
378 contract GSNContext is Initializable, Context {
379     // We use a random storage slot to allow proxy contracts to enable GSN support in an upgrade without changing their
380     // storage layout. This value is calculated as: keccak256('gsn.relayhub.address'), minus 1.
381     bytes32 private constant RELAY_HUB_ADDRESS_STORAGE_SLOT = 0x06b7792c761dcc05af1761f0315ce8b01ac39c16cc934eb0b2f7a8e71414f262;
382 
383     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
384 
385     function initialize() public initializer {
386         _upgradeRelayHub(0xD216153c06E857cD7f72665E0aF1d7D82172F494);
387     }
388 
389     function _getRelayHub() internal view returns (address relayHub) {
390         bytes32 slot = RELAY_HUB_ADDRESS_STORAGE_SLOT;
391         // solhint-disable-next-line no-inline-assembly
392         assembly {
393             relayHub := sload(slot)
394         }
395     }
396 
397     function _upgradeRelayHub(address newRelayHub) internal {
398         address currentRelayHub = _getRelayHub();
399         require(newRelayHub != address(0), "GSNContext: new RelayHub is the zero address");
400         require(newRelayHub != currentRelayHub, "GSNContext: new RelayHub is the current one");
401 
402         emit RelayHubChanged(currentRelayHub, newRelayHub);
403 
404         bytes32 slot = RELAY_HUB_ADDRESS_STORAGE_SLOT;
405         // solhint-disable-next-line no-inline-assembly
406         assembly {
407             sstore(slot, newRelayHub)
408         }
409     }
410 
411     // Overrides for Context's functions: when called from RelayHub, sender and
412     // data require some pre-processing: the actual sender is stored at the end
413     // of the call data, which in turns means it needs to be removed from it
414     // when handling said data.
415 
416     function _msgSender() internal view returns (address) {
417         if (msg.sender != _getRelayHub()) {
418             return msg.sender;
419         } else {
420             return _getRelayedCallSender();
421         }
422     }
423 
424     function _msgData() internal view returns (bytes memory) {
425         if (msg.sender != _getRelayHub()) {
426             return msg.data;
427         } else {
428             return _getRelayedCallData();
429         }
430     }
431 
432     function _getRelayedCallSender() private pure returns (address result) {
433         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
434         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
435         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
436         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
437         // bytes. This can always be done due to the 32-byte prefix.
438 
439         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
440         // easiest/most-efficient way to perform this operation.
441 
442         // These fields are not accessible from assembly
443         bytes memory array = msg.data;
444         uint256 index = msg.data.length;
445 
446         // solhint-disable-next-line no-inline-assembly
447         assembly {
448             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
449             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
450         }
451         return result;
452     }
453 
454     function _getRelayedCallData() private pure returns (bytes memory) {
455         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
456         // we must strip the last 20 bytes (length of an address type) from it.
457 
458         uint256 actualDataLength = msg.data.length - 20;
459         bytes memory actualData = new bytes(actualDataLength);
460 
461         for (uint256 i = 0; i < actualDataLength; ++i) {
462             actualData[i] = msg.data[i];
463         }
464 
465         return actualData;
466     }
467 }
468 
469 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/IRelayHub.sol
470 
471 pragma solidity ^0.5.0;
472 
473 contract IRelayHub {
474     // Relay management
475 
476     // Add stake to a relay and sets its unstakeDelay.
477     // If the relay does not exist, it is created, and the caller
478     // of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
479     // cannot be its own owner.
480     // All Ether in this function call will be added to the relay's stake.
481     // Its unstake delay will be assigned to unstakeDelay, but the new value must be greater or equal to the current one.
482     // Emits a Staked event.
483     function stake(address relayaddr, uint256 unstakeDelay) external payable;
484 
485     // Emited when a relay's stake or unstakeDelay are increased
486     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
487 
488     // Registers the caller as a relay.
489     // The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
490     // Emits a RelayAdded event.
491     // This function can be called multiple times, emitting new RelayAdded events. Note that the received transactionFee
492     // is not enforced by relayCall.
493     function registerRelay(uint256 transactionFee, string memory url) public;
494 
495     // Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out RelayRemoved
496     // events) lets a client discover the list of available relays.
497     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
498 
499     // Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed. Can only be called by
500     // the owner of the relay. After the relay's unstakeDelay has elapsed, unstake will be callable.
501     // Emits a RelayRemoved event.
502     function removeRelayByOwner(address relay) public;
503 
504     // Emitted when a relay is removed (deregistered). unstakeTime is the time when unstake will be callable.
505     event RelayRemoved(address indexed relay, uint256 unstakeTime);
506 
507     // Deletes the relay from the system, and gives back its stake to the owner. Can only be called by the relay owner,
508     // after unstakeDelay has elapsed since removeRelayByOwner was called.
509     // Emits an Unstaked event.
510     function unstake(address relay) public;
511 
512     // Emitted when a relay is unstaked for, including the returned stake.
513     event Unstaked(address indexed relay, uint256 stake);
514 
515     // States a relay can be in
516     enum RelayState {
517         Unknown, // The relay is unknown to the system: it has never been staked for
518         Staked, // The relay has been staked for, but it is not yet active
519         Registered, // The relay has registered itself, and is active (can relay calls)
520         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
521     }
522 
523     // Returns a relay's status. Note that relays can be deleted when unstaked or penalized.
524     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
525 
526     // Balance management
527 
528     // Deposits ether for a contract, so that it can receive (and pay for) relayed transactions. Unused balance can only
529     // be withdrawn by the contract itself, by callingn withdraw.
530     // Emits a Deposited event.
531     function depositFor(address target) public payable;
532 
533     // Emitted when depositFor is called, including the amount and account that was funded.
534     event Deposited(address indexed recipient, address indexed from, uint256 amount);
535 
536     // Returns an account's deposits. These can be either a contnract's funds, or a relay owner's revenue.
537     function balanceOf(address target) external view returns (uint256);
538 
539     // Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
540     // contracts can also use it to reduce their funding.
541     // Emits a Withdrawn event.
542     function withdraw(uint256 amount, address payable dest) public;
543 
544     // Emitted when an account withdraws funds from RelayHub.
545     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
546 
547     // Relaying
548 
549     // Check if the RelayHub will accept a relayed operation. Multiple things must be true for this to happen:
550     //  - all arguments must be signed for by the sender (from)
551     //  - the sender's nonce must be the current one
552     //  - the recipient must accept this transaction (via acceptRelayedCall)
553     // Returns a PreconditionCheck value (OK when the transaction can be relayed), or a recipient-specific error code if
554     // it returns one in acceptRelayedCall.
555     function canRelay(
556         address relay,
557         address from,
558         address to,
559         bytes memory encodedFunction,
560         uint256 transactionFee,
561         uint256 gasPrice,
562         uint256 gasLimit,
563         uint256 nonce,
564         bytes memory signature,
565         bytes memory approvalData
566     ) public view returns (uint256 status, bytes memory recipientContext);
567 
568     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
569     enum PreconditionCheck {
570         OK,                         // All checks passed, the call can be relayed
571         WrongSignature,             // The transaction to relay is not signed by requested sender
572         WrongNonce,                 // The provided nonce has already been used by the sender
573         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
574         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
575     }
576 
577     // Relays a transaction. For this to suceed, multiple conditions must be met:
578     //  - canRelay must return PreconditionCheck.OK
579     //  - the sender must be a registered relay
580     //  - the transaction's gas price must be larger or equal to the one that was requested by the sender
581     //  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
582     // recipient) use all gas available to them
583     //  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
584     // spent)
585     //
586     // If all conditions are met, the call will be relayed and the recipient charged. preRelayedCall, the encoded
587     // function and postRelayedCall will be called in order.
588     //
589     // Arguments:
590     //  - from: the client originating the request
591     //  - recipient: the target IRelayRecipient contract
592     //  - encodedFunction: the function call to relay, including data
593     //  - transactionFee: fee (%) the relay takes over actual gas cost
594     //  - gasPrice: gas price the client is willing to pay
595     //  - gasLimit: gas to forward when calling the encoded function
596     //  - nonce: client's nonce
597     //  - signature: client's signature over all previous params, plus the relay and RelayHub addresses
598     //  - approvalData: dapp-specific data forwared to acceptRelayedCall. This value is *not* verified by the Hub, but
599     //    it still can be used for e.g. a signature.
600     //
601     // Emits a TransactionRelayed event.
602     function relayCall(
603         address from,
604         address to,
605         bytes memory encodedFunction,
606         uint256 transactionFee,
607         uint256 gasPrice,
608         uint256 gasLimit,
609         uint256 nonce,
610         bytes memory signature,
611         bytes memory approvalData
612     ) public;
613 
614     // Emitted when an attempt to relay a call failed. This can happen due to incorrect relayCall arguments, or the
615     // recipient not accepting the relayed call. The actual relayed call was not executed, and the recipient not charged.
616     // The reason field contains an error code: values 1-10 correspond to PreconditionCheck entries, and values over 10
617     // are custom recipient error codes returned from acceptRelayedCall.
618     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
619 
620     // Emitted when a transaction is relayed. Note that the actual encoded function might be reverted: this will be
621     // indicated in the status field.
622     // Useful when monitoring a relay's operation and relayed calls to a contract.
623     // Charge is the ether value deducted from the recipient's balance, paid to the relay's owner.
624     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
625 
626     // Reason error codes for the TransactionRelayed event
627     enum RelayCallStatus {
628         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
629         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
630         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
631         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
632         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
633     }
634 
635     // Returns how much gas should be forwarded to a call to relayCall, in order to relay a transaction that will spend
636     // up to relayedCallStipend gas.
637     function requiredGas(uint256 relayedCallStipend) public view returns (uint256);
638 
639     // Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
640     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256);
641 
642     // Relay penalization. Any account can penalize relays, removing them from the system immediately, and rewarding the
643     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
644     // still loses half of its stake.
645 
646     // Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
647     // different data (gas price, gas limit, etc. may be different). The (unsigned) transaction data and signature for
648     // both transactions must be provided.
649     function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public;
650 
651     // Penalize a relay that sent a transaction that didn't target RelayHub's registerRelay or relayCall.
652     function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public;
653 
654     event Penalized(address indexed relay, address sender, uint256 amount);
655 
656     function getNonce(address from) external view returns (uint256);
657 }
658 
659 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/GSNRecipient.sol
660 
661 pragma solidity ^0.5.0;
662 
663 
664 
665 
666 
667 
668 /*
669  * @dev Base GSN recipient contract, adding the recipient interface and enabling
670  * GSN support. Not all interface methods are implemented, derived contracts
671  * must do so themselves.
672  */
673 contract GSNRecipient is Initializable, IRelayRecipient, GSNContext, GSNBouncerBase {
674     function initialize() public initializer {
675         GSNContext.initialize();
676     }
677 
678     function getHubAddr() public view returns (address) {
679         return _getRelayHub();
680     }
681 
682     // This function is view for future-proofing, it may require reading from
683     // storage in the future.
684     function relayHubVersion() public view returns (string memory) {
685         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
686         return "1.0.0";
687     }
688 
689     function _withdrawDeposits(uint256 amount, address payable payee) internal {
690         IRelayHub(_getRelayHub()).withdraw(amount, payee);
691     }
692 }
693 
694 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
695 
696 pragma solidity ^0.5.2;
697 
698 /**
699  * @title ERC20 interface
700  * @dev see https://eips.ethereum.org/EIPS/eip-20
701  */
702 interface IERC20 {
703     function transfer(address to, uint256 value) external returns (bool);
704 
705     function approve(address spender, uint256 value) external returns (bool);
706 
707     function transferFrom(address from, address to, uint256 value) external returns (bool);
708 
709     function totalSupply() external view returns (uint256);
710 
711     function balanceOf(address who) external view returns (uint256);
712 
713     function allowance(address owner, address spender) external view returns (uint256);
714 
715     event Transfer(address indexed from, address indexed to, uint256 value);
716 
717     event Approval(address indexed owner, address indexed spender, uint256 value);
718 }
719 
720 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol
721 
722 pragma solidity ^0.5.2;
723 
724 
725 /**
726  * @title Helps contracts guard against reentrancy attacks.
727  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
728  * @dev If you mark a function `nonReentrant`, you should also
729  * mark it `external`.
730  */
731 contract ReentrancyGuard is Initializable {
732     /// @dev counter to allow mutex lock with only one SSTORE operation
733     uint256 private _guardCounter;
734 
735     function initialize() public initializer {
736         // The counter starts at one to prevent changing it from zero to a non-zero
737         // value, which is a more expensive operation.
738         _guardCounter = 1;
739     }
740 
741     /**
742      * @dev Prevents a contract from calling itself, directly or indirectly.
743      * Calling a `nonReentrant` function from another `nonReentrant`
744      * function is not supported. It is possible to prevent this from happening
745      * by making the `nonReentrant` function external, and make it call a
746      * `private` function that does the actual work.
747      */
748     modifier nonReentrant() {
749         _guardCounter += 1;
750         uint256 localCounter = _guardCounter;
751         _;
752         require(localCounter == _guardCounter);
753     }
754 
755     uint256[50] private ______gap;
756 }
757 
758 // File: @sablier/shared-contracts/compound/CarefulMath.sol
759 
760 pragma solidity ^0.5.8;
761 
762 /**
763   * @title Careful Math
764   * @author Compound
765   * @notice Derived from OpenZeppelin's SafeMath library
766   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
767   */
768 contract CarefulMath {
769 
770     /**
771      * @dev Possible error codes that we can return
772      */
773     enum MathError {
774         NO_ERROR,
775         DIVISION_BY_ZERO,
776         INTEGER_OVERFLOW,
777         INTEGER_UNDERFLOW
778     }
779 
780     /**
781     * @dev Multiplies two numbers, returns an error on overflow.
782     */
783     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
784         if (a == 0) {
785             return (MathError.NO_ERROR, 0);
786         }
787 
788         uint c = a * b;
789 
790         if (c / a != b) {
791             return (MathError.INTEGER_OVERFLOW, 0);
792         } else {
793             return (MathError.NO_ERROR, c);
794         }
795     }
796 
797     /**
798     * @dev Integer division of two numbers, truncating the quotient.
799     */
800     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
801         if (b == 0) {
802             return (MathError.DIVISION_BY_ZERO, 0);
803         }
804 
805         return (MathError.NO_ERROR, a / b);
806     }
807 
808     /**
809     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
810     */
811     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
812         if (b <= a) {
813             return (MathError.NO_ERROR, a - b);
814         } else {
815             return (MathError.INTEGER_UNDERFLOW, 0);
816         }
817     }
818 
819     /**
820     * @dev Adds two numbers, returns an error on overflow.
821     */
822     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
823         uint c = a + b;
824 
825         if (c >= a) {
826             return (MathError.NO_ERROR, c);
827         } else {
828             return (MathError.INTEGER_OVERFLOW, 0);
829         }
830     }
831 
832     /**
833     * @dev add a and b and then subtract c
834     */
835     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
836         (MathError err0, uint sum) = addUInt(a, b);
837 
838         if (err0 != MathError.NO_ERROR) {
839             return (err0, 0);
840         }
841 
842         return subUInt(sum, c);
843     }
844 }
845 
846 // File: @sablier/shared-contracts/compound/Exponential.sol
847 
848 pragma solidity ^0.5.8;
849 
850 
851 /**
852  * @title Exponential module for storing fixed-decision decimals
853  * @author Compound
854  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
855  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
856  *         `Exp({mantissa: 5100000000000000000})`.
857  */
858 contract Exponential is CarefulMath {
859     uint constant expScale = 1e18;
860     uint constant halfExpScale = expScale/2;
861     uint constant mantissaOne = expScale;
862 
863     struct Exp {
864         uint mantissa;
865     }
866 
867     /**
868      * @dev Creates an exponential from numerator and denominator values.
869      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
870      *            or if `denom` is zero.
871      */
872     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
873         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
874         if (err0 != MathError.NO_ERROR) {
875             return (err0, Exp({mantissa: 0}));
876         }
877 
878         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
879         if (err1 != MathError.NO_ERROR) {
880             return (err1, Exp({mantissa: 0}));
881         }
882 
883         return (MathError.NO_ERROR, Exp({mantissa: rational}));
884     }
885 
886     /**
887      * @dev Adds two exponentials, returning a new exponential.
888      */
889     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
890         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
891 
892         return (error, Exp({mantissa: result}));
893     }
894 
895     /**
896      * @dev Subtracts two exponentials, returning a new exponential.
897      */
898     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
899         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
900 
901         return (error, Exp({mantissa: result}));
902     }
903 
904     /**
905      * @dev Multiply an Exp by a scalar, returning a new Exp.
906      */
907     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
908         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
909         if (err0 != MathError.NO_ERROR) {
910             return (err0, Exp({mantissa: 0}));
911         }
912 
913         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
914     }
915 
916     /**
917      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
918      */
919     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
920         (MathError err, Exp memory product) = mulScalar(a, scalar);
921         if (err != MathError.NO_ERROR) {
922             return (err, 0);
923         }
924 
925         return (MathError.NO_ERROR, truncate(product));
926     }
927 
928     /**
929      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
930      */
931     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
932         (MathError err, Exp memory product) = mulScalar(a, scalar);
933         if (err != MathError.NO_ERROR) {
934             return (err, 0);
935         }
936 
937         return addUInt(truncate(product), addend);
938     }
939 
940     /**
941      * @dev Divide an Exp by a scalar, returning a new Exp.
942      */
943     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
944         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
945         if (err0 != MathError.NO_ERROR) {
946             return (err0, Exp({mantissa: 0}));
947         }
948 
949         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
950     }
951 
952     /**
953      * @dev Divide a scalar by an Exp, returning a new Exp.
954      */
955     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
956         /*
957           We are doing this as:
958           getExp(mulUInt(expScale, scalar), divisor.mantissa)
959 
960           How it works:
961           Exp = a / b;
962           Scalar = s;
963           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
964         */
965         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
966         if (err0 != MathError.NO_ERROR) {
967             return (err0, Exp({mantissa: 0}));
968         }
969         return getExp(numerator, divisor.mantissa);
970     }
971 
972     /**
973      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
974      */
975     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
976         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
977         if (err != MathError.NO_ERROR) {
978             return (err, 0);
979         }
980 
981         return (MathError.NO_ERROR, truncate(fraction));
982     }
983 
984     /**
985      * @dev Multiplies two exponentials, returning a new exponential.
986      */
987     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
988 
989         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
990         if (err0 != MathError.NO_ERROR) {
991             return (err0, Exp({mantissa: 0}));
992         }
993 
994         // We add half the scale before dividing so that we get rounding instead of truncation.
995         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
996         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
997         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
998         if (err1 != MathError.NO_ERROR) {
999             return (err1, Exp({mantissa: 0}));
1000         }
1001 
1002         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
1003         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
1004         assert(err2 == MathError.NO_ERROR);
1005 
1006         return (MathError.NO_ERROR, Exp({mantissa: product}));
1007     }
1008 
1009     /**
1010      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
1011      */
1012     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
1013         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
1014     }
1015 
1016     /**
1017      * @dev Multiplies three exponentials, returning a new exponential.
1018      */
1019     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
1020         (MathError err, Exp memory ab) = mulExp(a, b);
1021         if (err != MathError.NO_ERROR) {
1022             return (err, ab);
1023         }
1024         return mulExp(ab, c);
1025     }
1026 
1027     /**
1028      * @dev Divides two exponentials, returning a new exponential.
1029      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
1030      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
1031      */
1032     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
1033         return getExp(a.mantissa, b.mantissa);
1034     }
1035 
1036     /**
1037      * @dev Truncates the given exp to a whole number value.
1038      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
1039      */
1040     function truncate(Exp memory exp) pure internal returns (uint) {
1041         // Note: We are not using careful math here as we're performing a division that cannot fail
1042         return exp.mantissa / expScale;
1043     }
1044 
1045     /**
1046      * @dev Checks if first Exp is less than second Exp.
1047      */
1048     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1049         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
1050     }
1051 
1052     /**
1053      * @dev Checks if left Exp <= right Exp.
1054      */
1055     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1056         return left.mantissa <= right.mantissa;
1057     }
1058 
1059     /**
1060      * @dev Checks if left Exp > right Exp.
1061      */
1062     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1063         return left.mantissa > right.mantissa;
1064     }
1065 
1066     /**
1067      * @dev returns true if Exp is exactly zero
1068      */
1069     function isZeroExp(Exp memory value) pure internal returns (bool) {
1070         return value.mantissa == 0;
1071     }
1072 }
1073 
1074 // File: @sablier/shared-contracts/interfaces/ICERC20.sol
1075 
1076 pragma solidity 0.5.11;
1077 
1078 /**
1079  * @title CERC20 interface
1080  * @author Sablier
1081  * @dev See https://compound.finance/developers
1082  */
1083 interface ICERC20 {
1084     function balanceOf(address who) external view returns (uint256);
1085 
1086     function isCToken() external view returns (bool);
1087 
1088     function approve(address spender, uint256 value) external returns (bool);
1089 
1090     function balanceOfUnderlying(address account) external returns (uint256);
1091 
1092     function exchangeRateCurrent() external returns (uint256);
1093 
1094     function mint(uint256 mintAmount) external returns (uint256);
1095 
1096     function redeem(uint256 redeemTokens) external returns (uint256);
1097 
1098     function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
1099 
1100     function transfer(address recipient, uint256 amount) external returns (bool);
1101 
1102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1103 }
1104 
1105 // File: @sablier/shared-contracts/lifecycle/OwnableWithoutRenounce.sol
1106 
1107 pragma solidity 0.5.11;
1108 
1109 
1110 
1111 /**
1112  * @title OwnableWithoutRenounce
1113  * @author Sablier
1114  * @dev Fork of OpenZeppelin's Ownable contract, which provides basic authorization control, but with
1115  *  the `renounceOwnership` function removed to avoid fat-finger errors.
1116  *  We inherit from `Context` to keep this contract compatible with the Gas Station Network.
1117  * See https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/ownership/Ownable.sol
1118  * See https://forum.openzeppelin.com/t/contract-request-ownable-without-renounceownership/1400
1119  * See https://docs.openzeppelin.com/contracts/2.x/gsn#_msg_sender_and_msg_data
1120  */
1121 contract OwnableWithoutRenounce is Initializable, Context {
1122     address private _owner;
1123 
1124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1125 
1126     /**
1127      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1128      * account.
1129      */
1130     function initialize(address sender) public initializer {
1131         _owner = sender;
1132         emit OwnershipTransferred(address(0), _owner);
1133     }
1134 
1135     /**
1136      * @return the address of the owner.
1137      */
1138     function owner() public view returns (address) {
1139         return _owner;
1140     }
1141 
1142     /**
1143      * @dev Throws if called by any account other than the owner.
1144      */
1145     modifier onlyOwner() {
1146         require(isOwner());
1147         _;
1148     }
1149 
1150     /**
1151      * @return true if `msg.sender` is the owner of the contract.
1152      */
1153     function isOwner() public view returns (bool) {
1154         return _msgSender() == _owner;
1155     }
1156 
1157     /**
1158      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1159      * @param newOwner The address to transfer ownership to.
1160      */
1161     function transferOwnership(address newOwner) public onlyOwner {
1162         _transferOwnership(newOwner);
1163     }
1164 
1165     /**
1166      * @dev Transfers control of the contract to a newOwner.
1167      * @param newOwner The address to transfer ownership to.
1168      */
1169     function _transferOwnership(address newOwner) internal {
1170         require(newOwner != address(0));
1171         emit OwnershipTransferred(_owner, newOwner);
1172         _owner = newOwner;
1173     }
1174 
1175     uint256[50] private ______gap;
1176 }
1177 
1178 // File: @openzeppelin/contracts-ethereum-package/contracts/access/Roles.sol
1179 
1180 pragma solidity ^0.5.2;
1181 
1182 /**
1183  * @title Roles
1184  * @dev Library for managing addresses assigned to a Role.
1185  */
1186 library Roles {
1187     struct Role {
1188         mapping (address => bool) bearer;
1189     }
1190 
1191     /**
1192      * @dev give an account access to this role
1193      */
1194     function add(Role storage role, address account) internal {
1195         require(account != address(0));
1196         require(!has(role, account));
1197 
1198         role.bearer[account] = true;
1199     }
1200 
1201     /**
1202      * @dev remove an account's access to this role
1203      */
1204     function remove(Role storage role, address account) internal {
1205         require(account != address(0));
1206         require(has(role, account));
1207 
1208         role.bearer[account] = false;
1209     }
1210 
1211     /**
1212      * @dev check if an account has this role
1213      * @return bool
1214      */
1215     function has(Role storage role, address account) internal view returns (bool) {
1216         require(account != address(0));
1217         return role.bearer[account];
1218     }
1219 }
1220 
1221 // File: @sablier/shared-contracts/lifecycle/PauserRoleWithoutRenounce.sol
1222 
1223 pragma solidity ^0.5.0;
1224 
1225 
1226 
1227 
1228 /**
1229  * @title PauserRoleWithoutRenounce
1230  * @author Sablier
1231  * @notice Fork of OpenZeppelin's PauserRole, but with the `renouncePauser` function removed to avoid fat-finger errors.
1232  *  We inherit from `Context` to keep this contract compatible with the Gas Station Network.
1233  * See https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/access/roles/PauserRole.sol
1234  */
1235 
1236 contract PauserRoleWithoutRenounce is Initializable, Context {
1237     using Roles for Roles.Role;
1238 
1239     event PauserAdded(address indexed account);
1240     event PauserRemoved(address indexed account);
1241 
1242     Roles.Role private _pausers;
1243 
1244     function initialize(address sender) public initializer {
1245         if (!isPauser(sender)) {
1246             _addPauser(sender);
1247         }
1248     }
1249 
1250     modifier onlyPauser() {
1251         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
1252         _;
1253     }
1254 
1255     function isPauser(address account) public view returns (bool) {
1256         return _pausers.has(account);
1257     }
1258 
1259     function addPauser(address account) public onlyPauser {
1260         _addPauser(account);
1261     }
1262 
1263     function _addPauser(address account) internal {
1264         _pausers.add(account);
1265         emit PauserAdded(account);
1266     }
1267 
1268     function _removePauser(address account) internal {
1269         _pausers.remove(account);
1270         emit PauserRemoved(account);
1271     }
1272 
1273     uint256[50] private ______gap;
1274 }
1275 
1276 // File: @sablier/shared-contracts/lifecycle/PausableWithoutRenounce.sol
1277 
1278 pragma solidity 0.5.11;
1279 
1280 
1281 
1282 
1283 /**
1284  * @title PausableWithoutRenounce
1285  * @author Sablier
1286  * @notice Fork of OpenZeppelin's Pausable, a contract module which allows children to implement an
1287  *  emergency stop mechanism that can be triggered by an authorized account, but with the `renouncePauser`
1288  *  function removed to avoid fat-finger errors.
1289  *  We inherit from `Context` to keep this contract compatible with the Gas Station Network.
1290  * See https://github.com/OpenZeppelin/openzeppelin-contracts-ethereum-package/blob/master/contracts/lifecycle/Pausable.sol
1291  * See https://docs.openzeppelin.com/contracts/2.x/gsn#_msg_sender_and_msg_data
1292  */
1293 contract PausableWithoutRenounce is Initializable, Context, PauserRoleWithoutRenounce {
1294     /**
1295      * @dev Emitted when the pause is triggered by a pauser (`account`).
1296      */
1297     event Paused(address account);
1298 
1299     /**
1300      * @dev Emitted when the pause is lifted by a pauser (`account`).
1301      */
1302     event Unpaused(address account);
1303 
1304     bool private _paused;
1305 
1306     /**
1307      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
1308      * to the deployer.
1309      */
1310     function initialize(address sender) public initializer {
1311         PauserRoleWithoutRenounce.initialize(sender);
1312         _paused = false;
1313     }
1314 
1315     /**
1316      * @dev Returns true if the contract is paused, and false otherwise.
1317      */
1318     function paused() public view returns (bool) {
1319         return _paused;
1320     }
1321 
1322     /**
1323      * @dev Modifier to make a function callable only when the contract is not paused.
1324      */
1325     modifier whenNotPaused() {
1326         require(!_paused, "Pausable: paused");
1327         _;
1328     }
1329 
1330     /**
1331      * @dev Modifier to make a function callable only when the contract is paused.
1332      */
1333     modifier whenPaused() {
1334         require(_paused, "Pausable: not paused");
1335         _;
1336     }
1337 
1338     /**
1339      * @dev Called by a pauser to pause, triggers stopped state.
1340      */
1341     function pause() public onlyPauser whenNotPaused {
1342         _paused = true;
1343         emit Paused(_msgSender());
1344     }
1345 
1346     /**
1347      * @dev Called by a pauser to unpause, returns to normal state.
1348      */
1349     function unpause() public onlyPauser whenPaused {
1350         _paused = false;
1351         emit Unpaused(_msgSender());
1352     }
1353 }
1354 
1355 // File: @sablier/protocol/contracts/interfaces/ICTokenManager.sol
1356 
1357 pragma solidity 0.5.11;
1358 
1359 /**
1360  * @title CTokenManager Interface
1361  * @author Sablier
1362  */
1363 interface ICTokenManager {
1364     /**
1365      * @notice Emits when the owner discards a cToken.
1366      */
1367     event DiscardCToken(address indexed tokenAddress);
1368 
1369     /**
1370      * @notice Emits when the owner whitelists a cToken.
1371      */
1372     event WhitelistCToken(address indexed tokenAddress);
1373 
1374     function whitelistCToken(address tokenAddress) external;
1375 
1376     function discardCToken(address tokenAddress) external;
1377 
1378     function isCToken(address tokenAddress) external view returns (bool);
1379 }
1380 
1381 // File: @sablier/protocol/contracts/interfaces/IERC1620.sol
1382 
1383 pragma solidity 0.5.11;
1384 
1385 /**
1386  * @title ERC-1620 Money Streaming Standard
1387  * @author Paul Razvan Berg - <paul@sablier.app>
1388  * @dev See https://eips.ethereum.org/EIPS/eip-1620
1389  */
1390 interface IERC1620 {
1391     /**
1392      * @notice Emits when a stream is successfully created.
1393      */
1394     event CreateStream(
1395         uint256 indexed streamId,
1396         address indexed sender,
1397         address indexed recipient,
1398         uint256 deposit,
1399         address tokenAddress,
1400         uint256 startTime,
1401         uint256 stopTime
1402     );
1403 
1404     /**
1405      * @notice Emits when the recipient of a stream withdraws a portion or all their pro rata share of the stream.
1406      */
1407     event WithdrawFromStream(uint256 indexed streamId, address indexed recipient, uint256 amount);
1408 
1409     /**
1410      * @notice Emits when a stream is successfully cancelled and tokens are transferred back on a pro rata basis.
1411      */
1412     event CancelStream(
1413         uint256 indexed streamId,
1414         address indexed sender,
1415         address indexed recipient,
1416         uint256 senderBalance,
1417         uint256 recipientBalance
1418     );
1419 
1420     function balanceOf(uint256 streamId, address who) external view returns (uint256 balance);
1421 
1422     function getStream(uint256 streamId)
1423         external
1424         view
1425         returns (
1426             address sender,
1427             address recipient,
1428             uint256 deposit,
1429             address token,
1430             uint256 startTime,
1431             uint256 stopTime,
1432             uint256 balance,
1433             uint256 rate
1434         );
1435 
1436     function createStream(address recipient, uint256 deposit, address tokenAddress, uint256 startTime, uint256 stopTime)
1437         external
1438         returns (uint256 streamId);
1439 
1440     function withdrawFromStream(uint256 streamId, uint256 funds) external returns (bool);
1441 
1442     function cancelStream(uint256 streamId) external returns (bool);
1443 }
1444 
1445 // File: @sablier/protocol/contracts/Types.sol
1446 
1447 pragma solidity 0.5.11;
1448 
1449 
1450 /**
1451  * @title Sablier Types
1452  * @author Sablier
1453  */
1454 library Types {
1455     struct Stream {
1456         uint256 deposit;
1457         uint256 ratePerSecond;
1458         uint256 remainingBalance;
1459         uint256 startTime;
1460         uint256 stopTime;
1461         address recipient;
1462         address sender;
1463         address tokenAddress;
1464         bool isEntity;
1465     }
1466 
1467     struct CompoundingStreamVars {
1468         Exponential.Exp exchangeRateInitial;
1469         Exponential.Exp senderShare;
1470         Exponential.Exp recipientShare;
1471         bool isEntity;
1472     }
1473 }
1474 
1475 // File: @sablier/protocol/contracts/Sablier.sol
1476 
1477 pragma solidity 0.5.11;
1478 
1479 
1480 
1481 
1482 
1483 
1484 
1485 
1486 
1487 
1488 /**
1489  * @title Sablier's Money Streaming
1490  * @author Sablier
1491  */
1492 contract Sablier is IERC1620, OwnableWithoutRenounce, PausableWithoutRenounce, Exponential, ReentrancyGuard {
1493     /*** Storage Properties ***/
1494 
1495     /**
1496      * @notice In Exp terms, 1e18 is 1, or 100%
1497      */
1498     uint256 constant hundredPercent = 1e18;
1499 
1500     /**
1501      * @notice In Exp terms, 1e16 is 0.01, or 1%
1502      */
1503     uint256 constant onePercent = 1e16;
1504 
1505     /**
1506      * @notice Stores information about the initial state of the underlying of the cToken.
1507      */
1508     mapping(uint256 => Types.CompoundingStreamVars) private compoundingStreamsVars;
1509 
1510     /**
1511      * @notice An instance of CTokenManager, responsible for whitelisting and discarding cTokens.
1512      */
1513     ICTokenManager public cTokenManager;
1514 
1515     /**
1516      * @notice The amount of interest has been accrued per token address.
1517      */
1518     mapping(address => uint256) private earnings;
1519 
1520     /**
1521      * @notice The percentage fee charged by the contract on the accrued interest.
1522      */
1523     Exp public fee;
1524 
1525     /**
1526      * @notice Counter for new stream ids.
1527      */
1528     uint256 public nextStreamId;
1529 
1530     /**
1531      * @notice The stream objects identifiable by their unsigned integer ids.
1532      */
1533     mapping(uint256 => Types.Stream) private streams;
1534 
1535     /*** Events ***/
1536 
1537     /**
1538      * @notice Emits when a compounding stream is successfully created.
1539      */
1540     event CreateCompoundingStream(
1541         uint256 indexed streamId,
1542         uint256 exchangeRate,
1543         uint256 senderSharePercentage,
1544         uint256 recipientSharePercentage
1545     );
1546 
1547     /**
1548      * @notice Emits when the owner discards a cToken.
1549      */
1550     event PayInterest(
1551         uint256 indexed streamId,
1552         uint256 senderInterest,
1553         uint256 recipientInterest,
1554         uint256 sablierInterest
1555     );
1556 
1557     /**
1558      * @notice Emits when the owner takes the earnings.
1559      */
1560     event TakeEarnings(address indexed tokenAddress, uint256 indexed amount);
1561 
1562     /**
1563      * @notice Emits when the owner updates the percentage fee.
1564      */
1565     event UpdateFee(uint256 indexed fee);
1566 
1567     /*** Modifiers ***/
1568 
1569     /**
1570      * @dev Throws if the caller is not the sender of the recipient of the stream.
1571      */
1572     modifier onlySenderOrRecipient(uint256 streamId) {
1573         require(
1574             msg.sender == streams[streamId].sender || msg.sender == streams[streamId].recipient,
1575             "caller is not the sender or the recipient of the stream"
1576         );
1577         _;
1578     }
1579 
1580     /**
1581      * @dev Throws if the id does not point to a valid stream.
1582      */
1583     modifier streamExists(uint256 streamId) {
1584         require(streams[streamId].isEntity, "stream does not exist");
1585         _;
1586     }
1587 
1588     /**
1589      * @dev Throws if the id does not point to a valid compounding stream.
1590      */
1591     modifier compoundingStreamExists(uint256 streamId) {
1592         require(compoundingStreamsVars[streamId].isEntity, "compounding stream does not exist");
1593         _;
1594     }
1595 
1596     /*** Contract Logic Starts Here */
1597 
1598     constructor(address cTokenManagerAddress) public {
1599         require(cTokenManagerAddress != address(0x00), "cTokenManager contract is the zero address");
1600         OwnableWithoutRenounce.initialize(msg.sender);
1601         PausableWithoutRenounce.initialize(msg.sender);
1602         cTokenManager = ICTokenManager(cTokenManagerAddress);
1603         nextStreamId = 1;
1604     }
1605 
1606     /*** Owner Functions ***/
1607 
1608     struct UpdateFeeLocalVars {
1609         MathError mathErr;
1610         uint256 feeMantissa;
1611     }
1612 
1613     /**
1614      * @notice Updates the Sablier fee.
1615      * @dev Throws if the caller is not the owner of the contract.
1616      *  Throws if `feePercentage` is not lower or equal to 100.
1617      * @param feePercentage The new fee as a percentage.
1618      */
1619     function updateFee(uint256 feePercentage) external onlyOwner {
1620         require(feePercentage <= 100, "fee percentage higher than 100%");
1621         UpdateFeeLocalVars memory vars;
1622 
1623         /* `feePercentage` will be stored as a mantissa, so we scale it up by one percent in Exp terms. */
1624         (vars.mathErr, vars.feeMantissa) = mulUInt(feePercentage, onePercent);
1625         /*
1626          * `mulUInt` can only return MathError.INTEGER_OVERFLOW but we control `onePercent`
1627          * and we know `feePercentage` is maximum 100.
1628          */
1629         assert(vars.mathErr == MathError.NO_ERROR);
1630 
1631         fee = Exp({ mantissa: vars.feeMantissa });
1632         emit UpdateFee(feePercentage);
1633     }
1634 
1635     struct TakeEarningsLocalVars {
1636         MathError mathErr;
1637     }
1638 
1639     /**
1640      * @notice Withdraws the earnings for the given token address.
1641      * @dev Throws if `amount` exceeds the available balance.
1642      * @param tokenAddress The address of the token to withdraw earnings for.
1643      * @param amount The amount of tokens to withdraw.
1644      */
1645     function takeEarnings(address tokenAddress, uint256 amount) external onlyOwner nonReentrant {
1646         require(cTokenManager.isCToken(tokenAddress), "cToken is not whitelisted");
1647         require(amount > 0, "amount is zero");
1648         require(earnings[tokenAddress] >= amount, "amount exceeds the available balance");
1649 
1650         TakeEarningsLocalVars memory vars;
1651         (vars.mathErr, earnings[tokenAddress]) = subUInt(earnings[tokenAddress], amount);
1652         /*
1653          * `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know `earnings[tokenAddress]`
1654          * is at least as big as `amount`.
1655          */
1656         assert(vars.mathErr == MathError.NO_ERROR);
1657 
1658         emit TakeEarnings(tokenAddress, amount);
1659         require(IERC20(tokenAddress).transfer(msg.sender, amount), "token transfer failure");
1660     }
1661 
1662     /*** View Functions ***/
1663 
1664     /**
1665      * @notice Returns the compounding stream with all its properties.
1666      * @dev Throws if the id does not point to a valid stream.
1667      * @param streamId The id of the stream to query.
1668      * @return The stream object.
1669      */
1670     function getStream(uint256 streamId)
1671         external
1672         view
1673         streamExists(streamId)
1674         returns (
1675             address sender,
1676             address recipient,
1677             uint256 deposit,
1678             address tokenAddress,
1679             uint256 startTime,
1680             uint256 stopTime,
1681             uint256 remainingBalance,
1682             uint256 ratePerSecond
1683         )
1684     {
1685         sender = streams[streamId].sender;
1686         recipient = streams[streamId].recipient;
1687         deposit = streams[streamId].deposit;
1688         tokenAddress = streams[streamId].tokenAddress;
1689         startTime = streams[streamId].startTime;
1690         stopTime = streams[streamId].stopTime;
1691         remainingBalance = streams[streamId].remainingBalance;
1692         ratePerSecond = streams[streamId].ratePerSecond;
1693     }
1694 
1695     /**
1696      * @notice Returns either the delta in seconds between `block.timestamp` and `startTime` or
1697      *  between `stopTime` and `startTime, whichever is smaller. If `block.timestamp` is before
1698      *  `startTime`, it returns 0.
1699      * @dev Throws if the id does not point to a valid stream.
1700      * @param streamId The id of the stream for whom to query the delta.
1701      * @return The time delta in seconds.
1702      */
1703     function deltaOf(uint256 streamId) public view streamExists(streamId) returns (uint256 delta) {
1704         Types.Stream memory stream = streams[streamId];
1705         if (block.timestamp <= stream.startTime) return 0;
1706         if (block.timestamp < stream.stopTime) return block.timestamp - stream.startTime;
1707         return stream.stopTime - stream.startTime;
1708     }
1709 
1710     struct BalanceOfLocalVars {
1711         MathError mathErr;
1712         uint256 recipientBalance;
1713         uint256 withdrawalAmount;
1714         uint256 senderBalance;
1715     }
1716 
1717     /**
1718      * @notice Returns the available funds for the given stream id and address.
1719      * @dev Throws if the id does not point to a valid stream.
1720      * @param streamId The id of the stream for whom to query the balance.
1721      * @param who The address for whom to query the balance.
1722      * @return The total funds allocated to `who` as uint256.
1723      */
1724     function balanceOf(uint256 streamId, address who) public view streamExists(streamId) returns (uint256 balance) {
1725         Types.Stream memory stream = streams[streamId];
1726         BalanceOfLocalVars memory vars;
1727 
1728         uint256 delta = deltaOf(streamId);
1729         (vars.mathErr, vars.recipientBalance) = mulUInt(delta, stream.ratePerSecond);
1730         require(vars.mathErr == MathError.NO_ERROR, "recipient balance calculation error");
1731 
1732         /*
1733          * If the stream `balance` does not equal `deposit`, it means there have been withdrawals.
1734          * We have to subtract the total amount withdrawn from the amount of money that has been
1735          * streamed until now.
1736          */
1737         if (stream.deposit > stream.remainingBalance) {
1738             (vars.mathErr, vars.withdrawalAmount) = subUInt(stream.deposit, stream.remainingBalance);
1739             assert(vars.mathErr == MathError.NO_ERROR);
1740             (vars.mathErr, vars.recipientBalance) = subUInt(vars.recipientBalance, vars.withdrawalAmount);
1741             /* `withdrawalAmount` cannot and should not be bigger than `recipientBalance`. */
1742             assert(vars.mathErr == MathError.NO_ERROR);
1743         }
1744 
1745         if (who == stream.recipient) return vars.recipientBalance;
1746         if (who == stream.sender) {
1747             (vars.mathErr, vars.senderBalance) = subUInt(stream.remainingBalance, vars.recipientBalance);
1748             /* `recipientBalance` cannot and should not be bigger than `remainingBalance`. */
1749             assert(vars.mathErr == MathError.NO_ERROR);
1750             return vars.senderBalance;
1751         }
1752         return 0;
1753     }
1754 
1755     /**
1756      * @notice Checks if the given id points to a compounding stream.
1757      * @param streamId The id of the compounding stream to check.
1758      * @return bool true=it is compounding stream, otherwise false.
1759      */
1760     function isCompoundingStream(uint256 streamId) public view returns (bool) {
1761         return compoundingStreamsVars[streamId].isEntity;
1762     }
1763 
1764     /**
1765      * @notice Returns the compounding stream object with all its properties.
1766      * @dev Throws if the id does not point to a valid compounding stream.
1767      * @param streamId The id of the compounding stream to query.
1768      * @return The compounding stream object.
1769      */
1770     function getCompoundingStream(uint256 streamId)
1771         external
1772         view
1773         streamExists(streamId)
1774         compoundingStreamExists(streamId)
1775         returns (
1776             address sender,
1777             address recipient,
1778             uint256 deposit,
1779             address tokenAddress,
1780             uint256 startTime,
1781             uint256 stopTime,
1782             uint256 remainingBalance,
1783             uint256 ratePerSecond,
1784             uint256 exchangeRateInitial,
1785             uint256 senderSharePercentage,
1786             uint256 recipientSharePercentage
1787         )
1788     {
1789         sender = streams[streamId].sender;
1790         recipient = streams[streamId].recipient;
1791         deposit = streams[streamId].deposit;
1792         tokenAddress = streams[streamId].tokenAddress;
1793         startTime = streams[streamId].startTime;
1794         stopTime = streams[streamId].stopTime;
1795         remainingBalance = streams[streamId].remainingBalance;
1796         ratePerSecond = streams[streamId].ratePerSecond;
1797         exchangeRateInitial = compoundingStreamsVars[streamId].exchangeRateInitial.mantissa;
1798         senderSharePercentage = compoundingStreamsVars[streamId].senderShare.mantissa;
1799         recipientSharePercentage = compoundingStreamsVars[streamId].recipientShare.mantissa;
1800     }
1801 
1802     struct InterestOfLocalVars {
1803         MathError mathErr;
1804         Exp exchangeRateDelta;
1805         Exp underlyingInterest;
1806         Exp netUnderlyingInterest;
1807         Exp senderUnderlyingInterest;
1808         Exp recipientUnderlyingInterest;
1809         Exp sablierUnderlyingInterest;
1810         Exp senderInterest;
1811         Exp recipientInterest;
1812         Exp sablierInterest;
1813     }
1814 
1815     /**
1816      * @notice Computes the interest accrued by keeping the amount of tokens in the contract. Returns (0, 0, 0) if
1817      *  the stream is not a compounding stream.
1818      * @dev Throws if there is a math error. We do not assert the calculations which involve the current
1819      *  exchange rate, because we can't know what value we'll get back from the cToken contract.
1820      * @return The interest accrued by the sender, the recipient and sablier, respectively, as uint256s.
1821      */
1822     function interestOf(uint256 streamId, uint256 amount)
1823         public
1824         streamExists(streamId)
1825         returns (uint256 senderInterest, uint256 recipientInterest, uint256 sablierInterest)
1826     {
1827         if (!compoundingStreamsVars[streamId].isEntity) {
1828             return (0, 0, 0);
1829         }
1830         Types.Stream memory stream = streams[streamId];
1831         Types.CompoundingStreamVars memory compoundingStreamVars = compoundingStreamsVars[streamId];
1832         InterestOfLocalVars memory vars;
1833 
1834         /*
1835          * The exchange rate delta is a key variable, since it leads us to how much interest has been earned
1836          * since the compounding stream was created.
1837          */
1838         Exp memory exchangeRateCurrent = Exp({ mantissa: ICERC20(stream.tokenAddress).exchangeRateCurrent() });
1839         if (exchangeRateCurrent.mantissa <= compoundingStreamVars.exchangeRateInitial.mantissa) {
1840             return (0, 0, 0);
1841         }
1842         (vars.mathErr, vars.exchangeRateDelta) = subExp(exchangeRateCurrent, compoundingStreamVars.exchangeRateInitial);
1843         assert(vars.mathErr == MathError.NO_ERROR);
1844 
1845         /* Calculate how much interest has been earned by holding `amount` in the smart contract. */
1846         (vars.mathErr, vars.underlyingInterest) = mulScalar(vars.exchangeRateDelta, amount);
1847         require(vars.mathErr == MathError.NO_ERROR, "interest calculation error");
1848 
1849         /* Calculate our share from that interest. */
1850         if (fee.mantissa == hundredPercent) {
1851             (vars.mathErr, vars.sablierInterest) = divExp(vars.underlyingInterest, exchangeRateCurrent);
1852             require(vars.mathErr == MathError.NO_ERROR, "sablier interest conversion error");
1853             return (0, 0, truncate(vars.sablierInterest));
1854         } else if (fee.mantissa == 0) {
1855             vars.sablierUnderlyingInterest = Exp({ mantissa: 0 });
1856             vars.netUnderlyingInterest = vars.underlyingInterest;
1857         } else {
1858             (vars.mathErr, vars.sablierUnderlyingInterest) = mulExp(vars.underlyingInterest, fee);
1859             require(vars.mathErr == MathError.NO_ERROR, "sablier interest calculation error");
1860 
1861             /* Calculate how much interest is left for the sender and the recipient. */
1862             (vars.mathErr, vars.netUnderlyingInterest) = subExp(
1863                 vars.underlyingInterest,
1864                 vars.sablierUnderlyingInterest
1865             );
1866             /*
1867              * `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know that `sablierUnderlyingInterest`
1868              * is less or equal than `underlyingInterest`, because we control the value of `fee`.
1869              */
1870             assert(vars.mathErr == MathError.NO_ERROR);
1871         }
1872 
1873         /* Calculate the sender's share of the interest. */
1874         (vars.mathErr, vars.senderUnderlyingInterest) = mulExp(
1875             vars.netUnderlyingInterest,
1876             compoundingStreamVars.senderShare
1877         );
1878         require(vars.mathErr == MathError.NO_ERROR, "sender interest calculation error");
1879 
1880         /* Calculate the recipient's share of the interest. */
1881         (vars.mathErr, vars.recipientUnderlyingInterest) = subExp(
1882             vars.netUnderlyingInterest,
1883             vars.senderUnderlyingInterest
1884         );
1885         /*
1886          * `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know that `senderUnderlyingInterest`
1887          * is less or equal than `netUnderlyingInterest`, because `senderShare` is bounded between 1e16 and 1e18.
1888          */
1889         assert(vars.mathErr == MathError.NO_ERROR);
1890 
1891         /* Convert the interest to the equivalent cToken denomination. */
1892         (vars.mathErr, vars.senderInterest) = divExp(vars.senderUnderlyingInterest, exchangeRateCurrent);
1893         require(vars.mathErr == MathError.NO_ERROR, "sender interest conversion error");
1894 
1895         (vars.mathErr, vars.recipientInterest) = divExp(vars.recipientUnderlyingInterest, exchangeRateCurrent);
1896         require(vars.mathErr == MathError.NO_ERROR, "recipient interest conversion error");
1897 
1898         (vars.mathErr, vars.sablierInterest) = divExp(vars.sablierUnderlyingInterest, exchangeRateCurrent);
1899         require(vars.mathErr == MathError.NO_ERROR, "sablier interest conversion error");
1900 
1901         /* Truncating the results means losing everything on the last 1e18 positions of the mantissa */
1902         return (truncate(vars.senderInterest), truncate(vars.recipientInterest), truncate(vars.sablierInterest));
1903     }
1904 
1905     /**
1906      * @notice Returns the amount of interest that has been accrued for the given token address.
1907      * @param tokenAddress The address of the token to get the earnings for.
1908      * @return The amount of interest as uint256.
1909      */
1910     function getEarnings(address tokenAddress) external view returns (uint256) {
1911         require(cTokenManager.isCToken(tokenAddress), "token is not cToken");
1912         return earnings[tokenAddress];
1913     }
1914 
1915     /*** Public Effects & Interactions Functions ***/
1916 
1917     struct CreateStreamLocalVars {
1918         MathError mathErr;
1919         uint256 duration;
1920         uint256 ratePerSecond;
1921     }
1922 
1923     /**
1924      * @notice Creates a new stream funded by `msg.sender` and paid towards `recipient`.
1925      * @dev Throws if paused.
1926      *  Throws if the recipient is the zero address, the contract itself or the caller.
1927      *  Throws if the deposit is 0.
1928      *  Throws if the start time is before `block.timestamp`.
1929      *  Throws if the stop time is before the start time.
1930      *  Throws if the duration calculation has a math error.
1931      *  Throws if the deposit is smaller than the duration.
1932      *  Throws if the deposit is not a multiple of the duration.
1933      *  Throws if the rate calculation has a math error.
1934      *  Throws if the next stream id calculation has a math error.
1935      *  Throws if the contract is not allowed to transfer enough tokens.
1936      *  Throws if there is a token transfer failure.
1937      * @param recipient The address towards which the money is streamed.
1938      * @param deposit The amount of money to be streamed.
1939      * @param tokenAddress The ERC20 token to use as streaming currency.
1940      * @param startTime The unix timestamp for when the stream starts.
1941      * @param stopTime The unix timestamp for when the stream stops.
1942      * @return The uint256 id of the newly created stream.
1943      */
1944     function createStream(address recipient, uint256 deposit, address tokenAddress, uint256 startTime, uint256 stopTime)
1945         public
1946         whenNotPaused
1947         returns (uint256)
1948     {
1949         require(recipient != address(0x00), "stream to the zero address");
1950         require(recipient != address(this), "stream to the contract itself");
1951         require(recipient != msg.sender, "stream to the caller");
1952         require(deposit > 0, "deposit is zero");
1953         require(startTime >= block.timestamp, "start time before block.timestamp");
1954         require(stopTime > startTime, "stop time before the start time");
1955 
1956         CreateStreamLocalVars memory vars;
1957         (vars.mathErr, vars.duration) = subUInt(stopTime, startTime);
1958         /* `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know `stopTime` is higher than `startTime`. */
1959         assert(vars.mathErr == MathError.NO_ERROR);
1960 
1961         /* Without this, the rate per second would be zero. */
1962         require(deposit >= vars.duration, "deposit smaller than time delta");
1963 
1964         /* This condition avoids dealing with remainders */
1965         require(deposit % vars.duration == 0, "deposit not multiple of time delta");
1966 
1967         (vars.mathErr, vars.ratePerSecond) = divUInt(deposit, vars.duration);
1968         /* `divUInt` can only return MathError.DIVISION_BY_ZERO but we know `duration` is not zero. */
1969         assert(vars.mathErr == MathError.NO_ERROR);
1970 
1971         /* Create and store the stream object. */
1972         uint256 streamId = nextStreamId;
1973         streams[streamId] = Types.Stream({
1974             remainingBalance: deposit,
1975             deposit: deposit,
1976             isEntity: true,
1977             ratePerSecond: vars.ratePerSecond,
1978             recipient: recipient,
1979             sender: msg.sender,
1980             startTime: startTime,
1981             stopTime: stopTime,
1982             tokenAddress: tokenAddress
1983         });
1984 
1985         /* Increment the next stream id. */
1986         (vars.mathErr, nextStreamId) = addUInt(nextStreamId, uint256(1));
1987         require(vars.mathErr == MathError.NO_ERROR, "next stream id calculation error");
1988 
1989         require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), deposit), "token transfer failure");
1990         emit CreateStream(streamId, msg.sender, recipient, deposit, tokenAddress, startTime, stopTime);
1991         return streamId;
1992     }
1993 
1994     struct CreateCompoundingStreamLocalVars {
1995         MathError mathErr;
1996         uint256 shareSum;
1997         uint256 underlyingBalance;
1998         uint256 senderShareMantissa;
1999         uint256 recipientShareMantissa;
2000     }
2001 
2002     /**
2003      * @notice Creates a new compounding stream funded by `msg.sender` and paid towards `recipient`.
2004      * @dev Inherits all security checks from `createStream`.
2005      *  Throws if the cToken is not whitelisted.
2006      *  Throws if the sender share percentage and the recipient share percentage do not sum up to 100.
2007      *  Throws if the the sender share mantissa calculation has a math error.
2008      *  Throws if the the recipient share mantissa calculation has a math error.
2009      * @param recipient The address towards which the money is streamed.
2010      * @param deposit The amount of money to be streamed.
2011      * @param tokenAddress The ERC20 token to use as streaming currency.
2012      * @param startTime The unix timestamp for when the stream starts.
2013      * @param stopTime The unix timestamp for when the stream stops.
2014      * @param senderSharePercentage The sender's share of the interest, as a percentage.
2015      * @param recipientSharePercentage The recipient's share of the interest, as a percentage.
2016      * @return The uint256 id of the newly created compounding stream.
2017      */
2018     function createCompoundingStream(
2019         address recipient,
2020         uint256 deposit,
2021         address tokenAddress,
2022         uint256 startTime,
2023         uint256 stopTime,
2024         uint256 senderSharePercentage,
2025         uint256 recipientSharePercentage
2026     ) external whenNotPaused returns (uint256) {
2027         require(cTokenManager.isCToken(tokenAddress), "cToken is not whitelisted");
2028         CreateCompoundingStreamLocalVars memory vars;
2029 
2030         /* Ensure that the interest shares sum up to 100%. */
2031         (vars.mathErr, vars.shareSum) = addUInt(senderSharePercentage, recipientSharePercentage);
2032         require(vars.mathErr == MathError.NO_ERROR, "share sum calculation error");
2033         require(vars.shareSum == 100, "shares do not sum up to 100");
2034 
2035         uint256 streamId = createStream(recipient, deposit, tokenAddress, startTime, stopTime);
2036 
2037         /*
2038          * `senderSharePercentage` and `recipientSharePercentage` will be stored as mantissas, so we scale them up
2039          * by one percent in Exp terms.
2040          */
2041         (vars.mathErr, vars.senderShareMantissa) = mulUInt(senderSharePercentage, onePercent);
2042         /*
2043          * `mulUInt` can only return MathError.INTEGER_OVERFLOW but we control `onePercent` and
2044          * we know `senderSharePercentage` is maximum 100.
2045          */
2046         assert(vars.mathErr == MathError.NO_ERROR);
2047 
2048         (vars.mathErr, vars.recipientShareMantissa) = mulUInt(recipientSharePercentage, onePercent);
2049         /*
2050          * `mulUInt` can only return MathError.INTEGER_OVERFLOW but we control `onePercent` and
2051          * we know `recipientSharePercentage` is maximum 100.
2052          */
2053         assert(vars.mathErr == MathError.NO_ERROR);
2054 
2055         /* Create and store the compounding stream vars. */
2056         uint256 exchangeRateCurrent = ICERC20(tokenAddress).exchangeRateCurrent();
2057         compoundingStreamsVars[streamId] = Types.CompoundingStreamVars({
2058             exchangeRateInitial: Exp({ mantissa: exchangeRateCurrent }),
2059             isEntity: true,
2060             recipientShare: Exp({ mantissa: vars.recipientShareMantissa }),
2061             senderShare: Exp({ mantissa: vars.senderShareMantissa })
2062         });
2063 
2064         emit CreateCompoundingStream(streamId, exchangeRateCurrent, senderSharePercentage, recipientSharePercentage);
2065         return streamId;
2066     }
2067 
2068     /**
2069      * @notice Withdraws from the contract to the recipient's account.
2070      * @dev Throws if the id does not point to a valid stream.
2071      *  Throws if the caller is not the sender or the recipient of the stream.
2072      *  Throws if the amount exceeds the available balance.
2073      *  Throws if there is a token transfer failure.
2074      * @param streamId The id of the stream to withdraw tokens from.
2075      * @param amount The amount of tokens to withdraw.
2076      * @return bool true=success, otherwise false.
2077      */
2078     function withdrawFromStream(uint256 streamId, uint256 amount)
2079         external
2080         whenNotPaused
2081         nonReentrant
2082         streamExists(streamId)
2083         onlySenderOrRecipient(streamId)
2084         returns (bool)
2085     {
2086         require(amount > 0, "amount is zero");
2087         Types.Stream memory stream = streams[streamId];
2088         uint256 balance = balanceOf(streamId, stream.recipient);
2089         require(balance >= amount, "amount exceeds the available balance");
2090 
2091         if (!compoundingStreamsVars[streamId].isEntity) {
2092             withdrawFromStreamInternal(streamId, amount);
2093         } else {
2094             withdrawFromCompoundingStreamInternal(streamId, amount);
2095         }
2096         return true;
2097     }
2098 
2099     /**
2100      * @notice Cancels the stream and transfers the tokens back on a pro rata basis.
2101      * @dev Throws if the id does not point to a valid stream.
2102      *  Throws if the caller is not the sender or the recipient of the stream.
2103      *  Throws if there is a token transfer failure.
2104      * @param streamId The id of the stream to cancel.
2105      * @return bool true=success, otherwise false.
2106      */
2107     function cancelStream(uint256 streamId)
2108         external
2109         nonReentrant
2110         streamExists(streamId)
2111         onlySenderOrRecipient(streamId)
2112         returns (bool)
2113     {
2114         if (!compoundingStreamsVars[streamId].isEntity) {
2115             cancelStreamInternal(streamId);
2116         } else {
2117             cancelCompoundingStreamInternal(streamId);
2118         }
2119         return true;
2120     }
2121 
2122     /*** Internal Effects & Interactions Functions ***/
2123 
2124     struct WithdrawFromStreamInternalLocalVars {
2125         MathError mathErr;
2126     }
2127 
2128     /**
2129      * @notice Makes the withdrawal to the recipient of the stream.
2130      * @dev If the stream balance has been depleted to 0, the stream object is deleted
2131      *  to save gas and optimise contract storage.
2132      *  Throws if the stream balance calculation has a math error.
2133      *  Throws if there is a token transfer failure.
2134      */
2135     function withdrawFromStreamInternal(uint256 streamId, uint256 amount) internal {
2136         Types.Stream memory stream = streams[streamId];
2137         WithdrawFromStreamInternalLocalVars memory vars;
2138         (vars.mathErr, streams[streamId].remainingBalance) = subUInt(stream.remainingBalance, amount);
2139         /**
2140          * `subUInt` can only return MathError.INTEGER_UNDERFLOW but we know that `remainingBalance` is at least
2141          * as big as `amount`. See the `require` check in `withdrawFromInternal`.
2142          */
2143         assert(vars.mathErr == MathError.NO_ERROR);
2144 
2145         if (streams[streamId].remainingBalance == 0) delete streams[streamId];
2146 
2147         require(IERC20(stream.tokenAddress).transfer(stream.recipient, amount), "token transfer failure");
2148         emit WithdrawFromStream(streamId, stream.recipient, amount);
2149     }
2150 
2151     struct WithdrawFromCompoundingStreamInternalLocalVars {
2152         MathError mathErr;
2153         uint256 amountWithoutSenderInterest;
2154         uint256 netWithdrawalAmount;
2155     }
2156 
2157     /**
2158      * @notice Withdraws to the recipient's account and pays the accrued interest to all parties.
2159      * @dev If the stream balance has been depleted to 0, the stream object to save gas and optimise
2160      *  contract storage.
2161      *  Throws if there is a math error.
2162      *  Throws if there is a token transfer failure.
2163      */
2164     function withdrawFromCompoundingStreamInternal(uint256 streamId, uint256 amount) internal {
2165         Types.Stream memory stream = streams[streamId];
2166         WithdrawFromCompoundingStreamInternalLocalVars memory vars;
2167 
2168         /* Calculate the interest earned by each party for keeping `stream.balance` in the smart contract. */
2169         (uint256 senderInterest, uint256 recipientInterest, uint256 sablierInterest) = interestOf(streamId, amount);
2170 
2171         /*
2172          * Calculate the net withdrawal amount by subtracting `senderInterest` and `sablierInterest`.
2173          * Because the decimal points are lost when we truncate Exponentials, the recipient will implicitly earn
2174          * `recipientInterest` plus a tiny-weeny amount of interest, max 2e-8 in cToken denomination.
2175          */
2176         (vars.mathErr, vars.amountWithoutSenderInterest) = subUInt(amount, senderInterest);
2177         require(vars.mathErr == MathError.NO_ERROR, "amount without sender interest calculation error");
2178         (vars.mathErr, vars.netWithdrawalAmount) = subUInt(vars.amountWithoutSenderInterest, sablierInterest);
2179         require(vars.mathErr == MathError.NO_ERROR, "net withdrawal amount calculation error");
2180 
2181         /* Subtract `amount` from the remaining balance of the stream. */
2182         (vars.mathErr, streams[streamId].remainingBalance) = subUInt(stream.remainingBalance, amount);
2183         require(vars.mathErr == MathError.NO_ERROR, "balance subtraction calculation error");
2184 
2185         /* Delete the objects from storage if the remaining balance has been depleted to 0. */
2186         if (streams[streamId].remainingBalance == 0) {
2187             delete streams[streamId];
2188             delete compoundingStreamsVars[streamId];
2189         }
2190 
2191         /* Add the sablier interest to the earnings for this cToken. */
2192         (vars.mathErr, earnings[stream.tokenAddress]) = addUInt(earnings[stream.tokenAddress], sablierInterest);
2193         require(vars.mathErr == MathError.NO_ERROR, "earnings addition calculation error");
2194 
2195         /* Transfer the tokens to the sender and the recipient. */
2196         ICERC20 cToken = ICERC20(stream.tokenAddress);
2197         if (senderInterest > 0)
2198             require(cToken.transfer(stream.sender, senderInterest), "sender token transfer failure");
2199         require(cToken.transfer(stream.recipient, vars.netWithdrawalAmount), "recipient token transfer failure");
2200 
2201         emit WithdrawFromStream(streamId, stream.recipient, vars.netWithdrawalAmount);
2202         emit PayInterest(streamId, senderInterest, recipientInterest, sablierInterest);
2203     }
2204 
2205     /**
2206      * @notice Cancels the stream and transfers the tokens back on a pro rata basis.
2207      * @dev The stream and compounding stream vars objects get deleted to save gas
2208      *  and optimise contract storage.
2209      *  Throws if there is a token transfer failure.
2210      */
2211     function cancelStreamInternal(uint256 streamId) internal {
2212         Types.Stream memory stream = streams[streamId];
2213         uint256 senderBalance = balanceOf(streamId, stream.sender);
2214         uint256 recipientBalance = balanceOf(streamId, stream.recipient);
2215 
2216         delete streams[streamId];
2217 
2218         IERC20 token = IERC20(stream.tokenAddress);
2219         if (recipientBalance > 0)
2220             require(token.transfer(stream.recipient, recipientBalance), "recipient token transfer failure");
2221         if (senderBalance > 0) require(token.transfer(stream.sender, senderBalance), "sender token transfer failure");
2222 
2223         emit CancelStream(streamId, stream.sender, stream.recipient, senderBalance, recipientBalance);
2224     }
2225 
2226     struct CancelCompoundingStreamInternal {
2227         MathError mathErr;
2228         uint256 netSenderBalance;
2229         uint256 recipientBalanceWithoutSenderInterest;
2230         uint256 netRecipientBalance;
2231     }
2232 
2233     /**
2234      * @notice Cancels the stream, transfers the tokens back on a pro rata basis and pays the accrued
2235      * interest to all parties.
2236      * @dev Importantly, the money that has not been streamed yet is not considered chargeable.
2237      *  All the interest generated by that underlying will be returned to the sender.
2238      *  Throws if there is a math error.
2239      *  Throws if there is a token transfer failure.
2240      */
2241     function cancelCompoundingStreamInternal(uint256 streamId) internal {
2242         Types.Stream memory stream = streams[streamId];
2243         CancelCompoundingStreamInternal memory vars;
2244 
2245         /*
2246          * The sender gets back all the money that has not been streamed so far. By that, we mean both
2247          * the underlying amount and the interest generated by it.
2248          */
2249         uint256 senderBalance = balanceOf(streamId, stream.sender);
2250         uint256 recipientBalance = balanceOf(streamId, stream.recipient);
2251 
2252         /* Calculate the interest earned by each party for keeping `recipientBalance` in the smart contract. */
2253         (uint256 senderInterest, uint256 recipientInterest, uint256 sablierInterest) = interestOf(
2254             streamId,
2255             recipientBalance
2256         );
2257 
2258         /*
2259          * We add `senderInterest` to `senderBalance` to compute the net balance for the sender.
2260          * After this, the rest of the function is similar to `withdrawFromCompoundingStreamInternal`, except
2261          * we add the sender's share of the interest generated by `recipientBalance` to `senderBalance`.
2262          */
2263         (vars.mathErr, vars.netSenderBalance) = addUInt(senderBalance, senderInterest);
2264         require(vars.mathErr == MathError.NO_ERROR, "net sender balance calculation error");
2265 
2266         /*
2267          * Calculate the net withdrawal amount by subtracting `senderInterest` and `sablierInterest`.
2268          * Because the decimal points are lost when we truncate Exponentials, the recipient will implicitly earn
2269          * `recipientInterest` plus a tiny-weeny amount of interest, max 2e-8 in cToken denomination.
2270          */
2271         (vars.mathErr, vars.recipientBalanceWithoutSenderInterest) = subUInt(recipientBalance, senderInterest);
2272         require(vars.mathErr == MathError.NO_ERROR, "recipient balance without sender interest calculation error");
2273         (vars.mathErr, vars.netRecipientBalance) = subUInt(vars.recipientBalanceWithoutSenderInterest, sablierInterest);
2274         require(vars.mathErr == MathError.NO_ERROR, "net recipient balance calculation error");
2275 
2276         /* Add the sablier interest to the earnings attributed to this cToken. */
2277         (vars.mathErr, earnings[stream.tokenAddress]) = addUInt(earnings[stream.tokenAddress], sablierInterest);
2278         require(vars.mathErr == MathError.NO_ERROR, "earnings addition calculation error");
2279 
2280         /* Delete the objects from storage. */
2281         delete streams[streamId];
2282         delete compoundingStreamsVars[streamId];
2283 
2284         /* Transfer the tokens to the sender and the recipient. */
2285         IERC20 token = IERC20(stream.tokenAddress);
2286         if (vars.netSenderBalance > 0)
2287             require(token.transfer(stream.sender, vars.netSenderBalance), "sender token transfer failure");
2288         if (vars.netRecipientBalance > 0)
2289             require(token.transfer(stream.recipient, vars.netRecipientBalance), "recipient token transfer failure");
2290 
2291         emit CancelStream(streamId, stream.sender, stream.recipient, vars.netSenderBalance, vars.netRecipientBalance);
2292         emit PayInterest(streamId, senderInterest, recipientInterest, sablierInterest);
2293     }
2294 }
2295 
2296 // File: contracts/Payroll.sol
2297 
2298 pragma solidity 0.5.11;
2299 
2300 
2301 
2302 
2303 
2304 
2305 
2306 
2307 
2308 
2309 /**
2310  * @title Payroll Proxy
2311  * @author Sablier
2312  */
2313 contract Payroll is Initializable, OwnableWithoutRenounce, Exponential, GSNRecipient, GSNBouncerSignature {
2314     /*** Storage Properties ***/
2315 
2316     /**
2317      * @notice Container for salary information
2318      * @member company The address of the company which funded this salary
2319      * @member isEntity bool true=object exists, otherwise false
2320      * @member streamId The id of the stream in the Sablier contract
2321      */
2322     struct Salary {
2323         address company;
2324         bool isEntity;
2325         uint256 streamId;
2326     }
2327 
2328     /**
2329      * @notice Counter for new salary ids.
2330      */
2331     uint256 public nextSalaryId;
2332 
2333     /**
2334      * @notice Whitelist of accounts able to call the withdrawal function for a given stream so
2335      *  employees don't have to pay gas.
2336      */
2337     mapping(address => mapping(uint256 => bool)) public relayers;
2338 
2339     /**
2340      * @notice An instance of Sablier, the contract responsible for creating, withdrawing from and cancelling streams.
2341      */
2342     Sablier public sablier;
2343 
2344     /**
2345      * @notice The salary objects identifiable by their unsigned integer ids.
2346      */
2347     mapping(uint256 => Salary) private salaries;
2348 
2349     /*** Events ***/
2350 
2351     /**
2352      * @notice Emits when a salary is successfully created.
2353      */
2354     event CreateSalary(uint256 indexed salaryId, uint256 indexed streamId, address indexed company);
2355 
2356     /**
2357      * @notice Emits when the employee withdraws a portion or all their pro rata share of the stream.
2358      */
2359     event WithdrawFromSalary(uint256 indexed salaryId, uint256 indexed streamId, address indexed company);
2360 
2361     /**
2362      * @notice Emits when a salary is successfully cancelled and both parties get their pro rata
2363      *  share of the available funds.
2364      */
2365     event CancelSalary(uint256 indexed salaryId, uint256 indexed streamId, address indexed company);
2366 
2367     /**
2368      * @dev Throws if the caller is not the company or the employee.
2369      */
2370     modifier onlyCompanyOrEmployee(uint256 salaryId) {
2371         Salary memory salary = salaries[salaryId];
2372         (, address employee, , , , , , ) = sablier.getStream(salary.streamId);
2373         require(
2374             _msgSender() == salary.company || _msgSender() == employee,
2375             "caller is not the company or the employee"
2376         );
2377         _;
2378     }
2379 
2380     /**
2381      * @dev Throws if the caller is not the employee or an approved relayer.
2382      */
2383     modifier onlyEmployeeOrRelayer(uint256 salaryId) {
2384         Salary memory salary = salaries[salaryId];
2385         (, address employee, , , , , , ) = sablier.getStream(salary.streamId);
2386         require(
2387             _msgSender() == employee || relayers[_msgSender()][salaryId],
2388             "caller is not the employee or a relayer"
2389         );
2390         _;
2391     }
2392 
2393     /**
2394      * @dev Throws if the id does not point to a valid salary.
2395      */
2396     modifier salaryExists(uint256 salaryId) {
2397         require(salaries[salaryId].isEntity, "salary does not exist");
2398         _;
2399     }
2400 
2401     /*** Contract Logic Starts Here ***/
2402 
2403     /**
2404      * @notice Only called once after the contract is deployed. We ask for the owner and the signer address
2405      *  to be specified as parameters to avoid handling `msg.sender` directly.
2406      * @dev The `initializer` modifier ensures that the function can only be called once.
2407      * @param ownerAddress The address of the contract owner.
2408      * @param signerAddress The address of the account able to authorise relayed transactions.
2409      * @param sablierAddress The address of the Sablier contract.
2410      */
2411     function initialize(address ownerAddress, address signerAddress, address sablierAddress) public initializer {
2412         require(ownerAddress != address(0x00), "owner is the zero address");
2413         require(signerAddress != address(0x00), "signer is the zero address");
2414         require(sablierAddress != address(0x00), "sablier contract is the zero address");
2415         OwnableWithoutRenounce.initialize(ownerAddress);
2416         GSNRecipient.initialize();
2417         GSNBouncerSignature.initialize(signerAddress);
2418         sablier = Sablier(sablierAddress);
2419         nextSalaryId = 1;
2420     }
2421 
2422     /*** Admin ***/
2423 
2424     /**
2425      * @notice Whitelists a relayer to process withdrawals so the employee doesn't have to pay gas.
2426      * @dev Throws if the caller is not the owner of the contract.
2427      *  Throws if the id does not point to a valid salary.
2428      *  Throws if the relayer is whitelisted.
2429      * @param relayer The address of the relayer account.
2430      * @param salaryId The id of the salary to whitelist the relayer for.
2431      */
2432     function whitelistRelayer(address relayer, uint256 salaryId) external onlyOwner salaryExists(salaryId) {
2433         require(!relayers[relayer][salaryId], "relayer is whitelisted");
2434         relayers[relayer][salaryId] = true;
2435     }
2436 
2437     /**
2438      * @notice Discard a previously whitelisted relayer to prevent them from processing withdrawals.
2439      * @dev Throws if the caller is not the owner of the contract.
2440      *  Throws if the relayer is not whitelisted.
2441      * @param relayer The address of the relayer account.
2442      * @param salaryId The id of the salary to discard the relayer for.
2443      */
2444     function discardRelayer(address relayer, uint256 salaryId) external onlyOwner {
2445         require(relayers[relayer][salaryId], "relayer is not whitelisted");
2446         relayers[relayer][salaryId] = false;
2447     }
2448 
2449     /*** View Functions ***/
2450 
2451     /**
2452      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
2453      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
2454      *
2455      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
2456      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
2457      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
2458      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
2459      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold
2460      * a signature over all or some of the previous values.
2461      *
2462      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
2463      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
2464      *
2465      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
2466      * rejected. A regular revert will also trigger a rejection.
2467      */
2468     function acceptRelayedCall(
2469         address relay,
2470         address from,
2471         bytes calldata encodedFunction,
2472         uint256 transactionFee,
2473         uint256 gasPrice,
2474         uint256 gasLimit,
2475         uint256 nonce,
2476         bytes calldata approvalData,
2477         uint256
2478     ) external view returns (uint256, bytes memory) {
2479         /**
2480          * `nonce` prevents replays on RelayHub
2481          * `getHubAddr` prevents replays in multiple RelayHubs
2482          * `address(this)` prevents replays in multiple recipients
2483          */
2484         bytes memory blob = abi.encodePacked(
2485             relay,
2486             from,
2487             encodedFunction,
2488             transactionFee,
2489             gasPrice,
2490             gasLimit,
2491             nonce,
2492             getHubAddr(),
2493             address(this)
2494         );
2495         if (keccak256(blob).toEthSignedMessageHash().recover(approvalData) == owner()) {
2496             return _approveRelayedCall();
2497         } else {
2498             return _rejectRelayedCall(uint256(GSNBouncerSignatureErrorCodes.INVALID_SIGNER));
2499         }
2500     }
2501 
2502     /**
2503      * @notice Returns the salary object with all its properties.
2504      * @dev Throws if the id does not point to a valid salary.
2505      * @param salaryId The id of the salary to query.
2506      * @return The salary object.
2507      */
2508     function getSalary(uint256 salaryId)
2509         public
2510         view
2511         salaryExists(salaryId)
2512         returns (
2513             address company,
2514             address employee,
2515             uint256 salary,
2516             address tokenAddress,
2517             uint256 startTime,
2518             uint256 stopTime,
2519             uint256 remainingBalance,
2520             uint256 rate
2521         )
2522     {
2523         company = salaries[salaryId].company;
2524         (, employee, salary, tokenAddress, startTime, stopTime, remainingBalance, rate) = sablier.getStream(
2525             salaries[salaryId].streamId
2526         );
2527     }
2528 
2529     /*** Public Effects & Interactions Functions ***/
2530 
2531     struct CreateSalaryLocalVars {
2532         MathError mathErr;
2533     }
2534 
2535     /**
2536      * @notice Creates a new salary funded by `msg.sender` and paid towards `employee`.
2537      * @dev Throws if there is a math error.
2538      *  Throws if there is a token transfer failure.
2539      * @param employee The address of the employee who receives the salary.
2540      * @param salary The amount of tokens to be streamed.
2541      * @param tokenAddress The ERC20 token to use as streaming currency.
2542      * @param startTime The unix timestamp for when the stream starts.
2543      * @param stopTime The unix timestamp for when the stream stops.
2544      * @return The uint256 id of the newly created salary.
2545      */
2546     function createSalary(address employee, uint256 salary, address tokenAddress, uint256 startTime, uint256 stopTime)
2547         external
2548         returns (uint256 salaryId)
2549     {
2550         /* Transfer the tokens to this contract. */
2551         require(IERC20(tokenAddress).transferFrom(_msgSender(), address(this), salary), "token transfer failure");
2552 
2553         /* Approve the Sablier contract to spend from our tokens. */
2554         require(IERC20(tokenAddress).approve(address(sablier), salary), "token approval failure");
2555 
2556         /* Create the stream. */
2557         uint256 streamId = sablier.createStream(employee, salary, tokenAddress, startTime, stopTime);
2558         salaryId = nextSalaryId;
2559         salaries[nextSalaryId] = Salary({ company: _msgSender(), isEntity: true, streamId: streamId });
2560 
2561         /* Increment the next salary id. */
2562         CreateSalaryLocalVars memory vars;
2563         (vars.mathErr, nextSalaryId) = addUInt(nextSalaryId, uint256(1));
2564         require(vars.mathErr == MathError.NO_ERROR, "next stream id calculation error");
2565 
2566         emit CreateSalary(salaryId, streamId, _msgSender());
2567     }
2568 
2569     /**
2570      * @notice Creates a new compounding salary funded by `msg.sender` and paid towards `employee`.
2571      * @dev There's a bit of redundancy between `createSalary` and this function, but one has to
2572      *  call `sablier.createStream` and the other `sablier.createCompoundingStream`, so it's not
2573      *  worth it to run DRY code.
2574      *  Throws if there is a math error.
2575      *  Throws if there is a token transfer failure.
2576      * @param employee The address of the employee who receives the salary.
2577      * @param salary The amount of tokens to be streamed.
2578      * @param tokenAddress The ERC20 token to use as streaming currency.
2579      * @param startTime The unix timestamp for when the stream starts.
2580      * @param stopTime The unix timestamp for when the stream stops.
2581      * @param senderSharePercentage The sender's share of the interest, as a percentage.
2582      * @param recipientSharePercentage The sender's share of the interest, as a percentage.
2583      * @return The uint256 id of the newly created compounding salary.
2584      */
2585     function createCompoundingSalary(
2586         address employee,
2587         uint256 salary,
2588         address tokenAddress,
2589         uint256 startTime,
2590         uint256 stopTime,
2591         uint256 senderSharePercentage,
2592         uint256 recipientSharePercentage
2593     ) external returns (uint256 salaryId) {
2594         /* Transfer the tokens to this contract. */
2595         require(IERC20(tokenAddress).transferFrom(_msgSender(), address(this), salary), "token transfer failure");
2596 
2597         /* Approve the Sablier contract to spend from our tokens. */
2598         require(IERC20(tokenAddress).approve(address(sablier), salary), "token approval failure");
2599 
2600         /* Create the stream. */
2601         uint256 streamId = sablier.createCompoundingStream(
2602             employee,
2603             salary,
2604             tokenAddress,
2605             startTime,
2606             stopTime,
2607             senderSharePercentage,
2608             recipientSharePercentage
2609         );
2610         salaryId = nextSalaryId;
2611         salaries[nextSalaryId] = Salary({ company: _msgSender(), isEntity: true, streamId: streamId });
2612 
2613         /* Increment the next salary id. */
2614         CreateSalaryLocalVars memory vars;
2615         (vars.mathErr, nextSalaryId) = addUInt(nextSalaryId, uint256(1));
2616         require(vars.mathErr == MathError.NO_ERROR, "next stream id calculation error");
2617 
2618         /* We don't emit a different event for compounding salaries because we emit CreateCompoundingStream. */
2619         emit CreateSalary(salaryId, streamId, _msgSender());
2620     }
2621 
2622     struct CancelSalaryLocalVars {
2623         MathError mathErr;
2624         uint256 netCompanyBalance;
2625     }
2626 
2627     /**
2628      * @notice Withdraws from the contract to the employee's account.
2629      * @dev Throws if the id does not point to a valid salary.
2630      *  Throws if the caller is not the employee or a relayer.
2631      *  Throws if there is a token transfer failure.
2632      * @param salaryId The id of the salary to withdraw from.
2633      * @param amount The amount of tokens to withdraw.
2634      * @return bool true=success, false otherwise.
2635      */
2636     function withdrawFromSalary(uint256 salaryId, uint256 amount)
2637         external
2638         salaryExists(salaryId)
2639         onlyEmployeeOrRelayer(salaryId)
2640         returns (bool success)
2641     {
2642         Salary memory salary = salaries[salaryId];
2643         success = sablier.withdrawFromStream(salary.streamId, amount);
2644         emit WithdrawFromSalary(salaryId, salary.streamId, salary.company);
2645     }
2646 
2647     /**
2648      * @notice Cancels the salary and transfers the tokens back on a pro rata basis.
2649      * @dev Throws if the id does not point to a valid salary.
2650      *  Throws if the caller is not the company or the employee.
2651      *  Throws if there is a token transfer failure.
2652      * @param salaryId The id of the salary to cancel.
2653      * @return bool true=success, false otherwise.
2654      */
2655     function cancelSalary(uint256 salaryId)
2656         external
2657         salaryExists(salaryId)
2658         onlyCompanyOrEmployee(salaryId)
2659         returns (bool success)
2660     {
2661         Salary memory salary = salaries[salaryId];
2662 
2663         /* We avoid storing extraneous data twice, so we read the token address from Sablier. */
2664         (, address employee, , address tokenAddress, , , , ) = sablier.getStream(salary.streamId);
2665         uint256 companyBalance = sablier.balanceOf(salary.streamId, address(this));
2666 
2667         /**
2668          * The company gets all the money that has not been streamed yet, plus all the interest earned by what's left.
2669          * Not all streams are compounding and `companyBalance` coincides with `netCompanyBalance` then.
2670          */
2671         CancelSalaryLocalVars memory vars;
2672         if (!sablier.isCompoundingStream(salary.streamId)) {
2673             vars.netCompanyBalance = companyBalance;
2674         } else {
2675             uint256 employeeBalance = sablier.balanceOf(salary.streamId, employee);
2676             (uint256 companyInterest, , ) = sablier.interestOf(salary.streamId, employeeBalance);
2677             (vars.mathErr, vars.netCompanyBalance) = addUInt(companyBalance, companyInterest);
2678             require(vars.mathErr == MathError.NO_ERROR, "net company balance calculation error");
2679         }
2680 
2681         /* Delete the salary object to save gas. */
2682         delete salaries[salaryId];
2683         success = sablier.cancelStream(salary.streamId);
2684 
2685         /* Transfer the tokens to the company. */
2686         if (vars.netCompanyBalance > 0)
2687             require(
2688                 IERC20(tokenAddress).transfer(salary.company, vars.netCompanyBalance),
2689                 "company token transfer failure"
2690             );
2691 
2692         emit CancelSalary(salaryId, salary.streamId, salary.company);
2693     }
2694 }