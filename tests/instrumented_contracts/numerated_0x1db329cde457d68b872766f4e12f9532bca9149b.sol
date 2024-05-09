1 // File: @chainlink/contracts/src/v0.7/vendor/SafeMathChainlink.sol
2 
3 
4 pragma solidity ^0.7.0;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMathChainlink {
20   /**
21    * @dev Returns the addition of two unsigned integers, reverting on
22    * overflow.
23    *
24    * Counterpart to Solidity's `+` operator.
25    *
26    * Requirements:
27    * - Addition cannot overflow.
28    */
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     require(c >= a, "SafeMath: addition overflow");
32 
33     return c;
34   }
35 
36   /**
37    * @dev Returns the subtraction of two unsigned integers, reverting on
38    * overflow (when the result is negative).
39    *
40    * Counterpart to Solidity's `-` operator.
41    *
42    * Requirements:
43    * - Subtraction cannot overflow.
44    */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     require(b <= a, "SafeMath: subtraction overflow");
47     uint256 c = a - b;
48 
49     return c;
50   }
51 
52   /**
53    * @dev Returns the multiplication of two unsigned integers, reverting on
54    * overflow.
55    *
56    * Counterpart to Solidity's `*` operator.
57    *
58    * Requirements:
59    * - Multiplication cannot overflow.
60    */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63     // benefit is lost if 'b' is also tested.
64     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
65     if (a == 0) {
66       return 0;
67     }
68 
69     uint256 c = a * b;
70     require(c / a == b, "SafeMath: multiplication overflow");
71 
72     return c;
73   }
74 
75   /**
76    * @dev Returns the integer division of two unsigned integers. Reverts on
77    * division by zero. The result is rounded towards zero.
78    *
79    * Counterpart to Solidity's `/` operator. Note: this function uses a
80    * `revert` opcode (which leaves remaining gas untouched) while Solidity
81    * uses an invalid opcode to revert (consuming all remaining gas).
82    *
83    * Requirements:
84    * - The divisor cannot be zero.
85    */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // Solidity only automatically asserts when dividing by 0
88     require(b > 0, "SafeMath: division by zero");
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91 
92     return c;
93   }
94 
95   /**
96    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
97    * Reverts when dividing by zero.
98    *
99    * Counterpart to Solidity's `%` operator. This function uses a `revert`
100    * opcode (which leaves remaining gas untouched) while Solidity uses an
101    * invalid opcode to revert (consuming all remaining gas).
102    *
103    * Requirements:
104    * - The divisor cannot be zero.
105    */
106   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
107     require(b != 0, "SafeMath: modulo by zero");
108     return a % b;
109   }
110 }
111 
112 // File: @chainlink/contracts/src/v0.7/vendor/Address.sol
113 
114 
115 // From https://github.com/OpenZeppelin/openzeppelin-contracts v3.4.0(fa64a1ced0b70ab89073d5d0b6e01b0778f7e7d6)
116 
117 pragma solidity >=0.6.2 <0.8.0;
118 
119 /**
120  * @dev Collection of functions related to the address type
121  */
122 library Address {
123   /**
124    * @dev Returns true if `account` is a contract.
125    *
126    * [IMPORTANT]
127    * ====
128    * It is unsafe to assume that an address for which this function returns
129    * false is an externally-owned account (EOA) and not a contract.
130    *
131    * Among others, `isContract` will return false for the following
132    * types of addresses:
133    *
134    *  - an externally-owned account
135    *  - a contract in construction
136    *  - an address where a contract will be created
137    *  - an address where a contract lived, but was destroyed
138    * ====
139    */
140   function isContract(address account) internal view returns (bool) {
141     // This method relies on extcodesize, which returns 0 for contracts in
142     // construction, since the code is only stored at the end of the
143     // constructor execution.
144 
145     uint256 size;
146     // solhint-disable-next-line no-inline-assembly
147     assembly {
148       size := extcodesize(account)
149     }
150     return size > 0;
151   }
152 
153   /**
154    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
155    * `recipient`, forwarding all available gas and reverting on errors.
156    *
157    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
158    * of certain opcodes, possibly making contracts go over the 2300 gas limit
159    * imposed by `transfer`, making them unable to receive funds via
160    * `transfer`. {sendValue} removes this limitation.
161    *
162    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
163    *
164    * IMPORTANT: because control is transferred to `recipient`, care must be
165    * taken to not create reentrancy vulnerabilities. Consider using
166    * {ReentrancyGuard} or the
167    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
168    */
169   function sendValue(address payable recipient, uint256 amount) internal {
170     require(address(this).balance >= amount, "Address: insufficient balance");
171 
172     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
173     (bool success, ) = recipient.call{value: amount}("");
174     require(success, "Address: unable to send value, recipient may have reverted");
175   }
176 
177   /**
178    * @dev Performs a Solidity function call using a low level `call`. A
179    * plain`call` is an unsafe replacement for a function call: use this
180    * function instead.
181    *
182    * If `target` reverts with a revert reason, it is bubbled up by this
183    * function (like regular Solidity function calls).
184    *
185    * Returns the raw returned data. To convert to the expected return value,
186    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
187    *
188    * Requirements:
189    *
190    * - `target` must be a contract.
191    * - calling `target` with `data` must not revert.
192    *
193    * _Available since v3.1._
194    */
195   function functionCall(address target, bytes memory data) internal returns (bytes memory) {
196     return functionCall(target, data, "Address: low-level call failed");
197   }
198 
199   /**
200    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
201    * `errorMessage` as a fallback revert reason when `target` reverts.
202    *
203    * _Available since v3.1._
204    */
205   function functionCall(
206     address target,
207     bytes memory data,
208     string memory errorMessage
209   ) internal returns (bytes memory) {
210     return functionCallWithValue(target, data, 0, errorMessage);
211   }
212 
213   /**
214    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215    * but also transferring `value` wei to `target`.
216    *
217    * Requirements:
218    *
219    * - the calling contract must have an ETH balance of at least `value`.
220    * - the called Solidity function must be `payable`.
221    *
222    * _Available since v3.1._
223    */
224   function functionCallWithValue(
225     address target,
226     bytes memory data,
227     uint256 value
228   ) internal returns (bytes memory) {
229     return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
230   }
231 
232   /**
233    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
234    * with `errorMessage` as a fallback revert reason when `target` reverts.
235    *
236    * _Available since v3.1._
237    */
238   function functionCallWithValue(
239     address target,
240     bytes memory data,
241     uint256 value,
242     string memory errorMessage
243   ) internal returns (bytes memory) {
244     require(address(this).balance >= value, "Address: insufficient balance for call");
245     require(isContract(target), "Address: call to non-contract");
246 
247     // solhint-disable-next-line avoid-low-level-calls
248     (bool success, bytes memory returndata) = target.call{value: value}(data);
249     return _verifyCallResult(success, returndata, errorMessage);
250   }
251 
252   /**
253    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254    * but performing a static call.
255    *
256    * _Available since v3.3._
257    */
258   function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
259     return functionStaticCall(target, data, "Address: low-level static call failed");
260   }
261 
262   /**
263    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
264    * but performing a static call.
265    *
266    * _Available since v3.3._
267    */
268   function functionStaticCall(
269     address target,
270     bytes memory data,
271     string memory errorMessage
272   ) internal view returns (bytes memory) {
273     require(isContract(target), "Address: static call to non-contract");
274 
275     // solhint-disable-next-line avoid-low-level-calls
276     (bool success, bytes memory returndata) = target.staticcall(data);
277     return _verifyCallResult(success, returndata, errorMessage);
278   }
279 
280   /**
281    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282    * but performing a delegate call.
283    *
284    * _Available since v3.4._
285    */
286   function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
287     return functionDelegateCall(target, data, "Address: low-level delegate call failed");
288   }
289 
290   /**
291    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292    * but performing a delegate call.
293    *
294    * _Available since v3.4._
295    */
296   function functionDelegateCall(
297     address target,
298     bytes memory data,
299     string memory errorMessage
300   ) internal returns (bytes memory) {
301     require(isContract(target), "Address: delegate call to non-contract");
302 
303     // solhint-disable-next-line avoid-low-level-calls
304     (bool success, bytes memory returndata) = target.delegatecall(data);
305     return _verifyCallResult(success, returndata, errorMessage);
306   }
307 
308   function _verifyCallResult(
309     bool success,
310     bytes memory returndata,
311     string memory errorMessage
312   ) private pure returns (bytes memory) {
313     if (success) {
314       return returndata;
315     } else {
316       // Look for revert reason and bubble it up if present
317       if (returndata.length > 0) {
318         // The easiest way to bubble the revert reason is using memory via assembly
319 
320         // solhint-disable-next-line no-inline-assembly
321         assembly {
322           let returndata_size := mload(returndata)
323           revert(add(32, returndata), returndata_size)
324         }
325       } else {
326         revert(errorMessage);
327       }
328     }
329   }
330 }
331 
332 // File: @chainlink/contracts/src/v0.7/interfaces/WithdrawalInterface.sol
333 
334 
335 pragma solidity ^0.7.0;
336 
337 interface WithdrawalInterface {
338   /**
339    * @notice transfer LINK held by the contract belonging to msg.sender to
340    * another address
341    * @param recipient is the address to send the LINK to
342    * @param amount is the amount of LINK to send
343    */
344   function withdraw(address recipient, uint256 amount) external;
345 
346   /**
347    * @notice query the available amount of LINK to withdraw by msg.sender
348    */
349   function withdrawable() external view returns (uint256);
350 }
351 
352 // File: @chainlink/contracts/src/v0.7/interfaces/OracleInterface.sol
353 
354 
355 pragma solidity ^0.7.0;
356 
357 interface OracleInterface {
358   function fulfillOracleRequest(
359     bytes32 requestId,
360     uint256 payment,
361     address callbackAddress,
362     bytes4 callbackFunctionId,
363     uint256 expiration,
364     bytes32 data
365   ) external returns (bool);
366 
367   function withdraw(address recipient, uint256 amount) external;
368 
369   function withdrawable() external view returns (uint256);
370 }
371 
372 // File: @chainlink/contracts/src/v0.7/interfaces/ChainlinkRequestInterface.sol
373 
374 
375 pragma solidity ^0.7.0;
376 
377 interface ChainlinkRequestInterface {
378   function oracleRequest(
379     address sender,
380     uint256 requestPrice,
381     bytes32 serviceAgreementID,
382     address callbackAddress,
383     bytes4 callbackFunctionId,
384     uint256 nonce,
385     uint256 dataVersion,
386     bytes calldata data
387   ) external;
388 
389   function cancelOracleRequest(
390     bytes32 requestId,
391     uint256 payment,
392     bytes4 callbackFunctionId,
393     uint256 expiration
394   ) external;
395 }
396 
397 // File: @chainlink/contracts/src/v0.7/interfaces/OperatorInterface.sol
398 
399 
400 pragma solidity ^0.7.0;
401 
402 
403 
404 interface OperatorInterface is ChainlinkRequestInterface, OracleInterface {
405   function operatorRequest(
406     address sender,
407     uint256 payment,
408     bytes32 specId,
409     bytes4 callbackFunctionId,
410     uint256 nonce,
411     uint256 dataVersion,
412     bytes calldata data
413   ) external;
414 
415   function fulfillOracleRequest2(
416     bytes32 requestId,
417     uint256 payment,
418     address callbackAddress,
419     bytes4 callbackFunctionId,
420     uint256 expiration,
421     bytes calldata data
422   ) external returns (bool);
423 
424   function ownerTransferAndCall(
425     address to,
426     uint256 value,
427     bytes calldata data
428   ) external returns (bool success);
429 }
430 
431 // File: @chainlink/contracts/src/v0.7/interfaces/LinkTokenInterface.sol
432 
433 
434 pragma solidity ^0.7.0;
435 
436 interface LinkTokenInterface {
437   function allowance(address owner, address spender) external view returns (uint256 remaining);
438 
439   function approve(address spender, uint256 value) external returns (bool success);
440 
441   function balanceOf(address owner) external view returns (uint256 balance);
442 
443   function decimals() external view returns (uint8 decimalPlaces);
444 
445   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
446 
447   function increaseApproval(address spender, uint256 subtractedValue) external;
448 
449   function name() external view returns (string memory tokenName);
450 
451   function symbol() external view returns (string memory tokenSymbol);
452 
453   function totalSupply() external view returns (uint256 totalTokensIssued);
454 
455   function transfer(address to, uint256 value) external returns (bool success);
456 
457   function transferAndCall(
458     address to,
459     uint256 value,
460     bytes calldata data
461   ) external returns (bool success);
462 
463   function transferFrom(
464     address from,
465     address to,
466     uint256 value
467   ) external returns (bool success);
468 }
469 
470 // File: @chainlink/contracts/src/v0.7/interfaces/OwnableInterface.sol
471 
472 
473 pragma solidity ^0.7.0;
474 
475 interface OwnableInterface {
476   function owner() external returns (address);
477 
478   function transferOwnership(address recipient) external;
479 
480   function acceptOwnership() external;
481 }
482 
483 // File: @chainlink/contracts/src/v0.7/ConfirmedOwnerWithProposal.sol
484 
485 
486 pragma solidity ^0.7.0;
487 
488 
489 /**
490  * @title The ConfirmedOwner contract
491  * @notice A contract with helpers for basic contract ownership.
492  */
493 contract ConfirmedOwnerWithProposal is OwnableInterface {
494   address private s_owner;
495   address private s_pendingOwner;
496 
497   event OwnershipTransferRequested(address indexed from, address indexed to);
498   event OwnershipTransferred(address indexed from, address indexed to);
499 
500   constructor(address newOwner, address pendingOwner) {
501     require(newOwner != address(0), "Cannot set owner to zero");
502 
503     s_owner = newOwner;
504     if (pendingOwner != address(0)) {
505       _transferOwnership(pendingOwner);
506     }
507   }
508 
509   /**
510    * @notice Allows an owner to begin transferring ownership to a new address,
511    * pending.
512    */
513   function transferOwnership(address to) public override onlyOwner {
514     _transferOwnership(to);
515   }
516 
517   /**
518    * @notice Allows an ownership transfer to be completed by the recipient.
519    */
520   function acceptOwnership() external override {
521     require(msg.sender == s_pendingOwner, "Must be proposed owner");
522 
523     address oldOwner = s_owner;
524     s_owner = msg.sender;
525     s_pendingOwner = address(0);
526 
527     emit OwnershipTransferred(oldOwner, msg.sender);
528   }
529 
530   /**
531    * @notice Get the current owner
532    */
533   function owner() public view override returns (address) {
534     return s_owner;
535   }
536 
537   /**
538    * @notice validate, transfer ownership, and emit relevant events
539    */
540   function _transferOwnership(address to) private {
541     require(to != msg.sender, "Cannot transfer to self");
542 
543     s_pendingOwner = to;
544 
545     emit OwnershipTransferRequested(s_owner, to);
546   }
547 
548   /**
549    * @notice validate access
550    */
551   function _validateOwnership() internal view {
552     require(msg.sender == s_owner, "Only callable by owner");
553   }
554 
555   /**
556    * @notice Reverts if called by anyone other than the contract owner.
557    */
558   modifier onlyOwner() {
559     _validateOwnership();
560     _;
561   }
562 }
563 
564 // File: @chainlink/contracts/src/v0.7/ConfirmedOwner.sol
565 
566 
567 pragma solidity ^0.7.0;
568 
569 
570 /**
571  * @title The ConfirmedOwner contract
572  * @notice A contract with helpers for basic contract ownership.
573  */
574 contract ConfirmedOwner is ConfirmedOwnerWithProposal {
575   constructor(address newOwner) ConfirmedOwnerWithProposal(newOwner, address(0)) {}
576 }
577 
578 // File: @chainlink/contracts/src/v0.7/LinkTokenReceiver.sol
579 
580 
581 pragma solidity ^0.7.0;
582 
583 abstract contract LinkTokenReceiver {
584   /**
585    * @notice Called when LINK is sent to the contract via `transferAndCall`
586    * @dev The data payload's first 2 words will be overwritten by the `sender` and `amount`
587    * values to ensure correctness. Calls oracleRequest.
588    * @param sender Address of the sender
589    * @param amount Amount of LINK sent (specified in wei)
590    * @param data Payload of the transaction
591    */
592   function onTokenTransfer(
593     address sender,
594     uint256 amount,
595     bytes memory data
596   ) public validateFromLINK permittedFunctionsForLINK(data) {
597     assembly {
598       // solhint-disable-next-line avoid-low-level-calls
599       mstore(add(data, 36), sender) // ensure correct sender is passed
600       // solhint-disable-next-line avoid-low-level-calls
601       mstore(add(data, 68), amount) // ensure correct amount is passed
602     }
603     // solhint-disable-next-line avoid-low-level-calls
604     (bool success, ) = address(this).delegatecall(data); // calls oracleRequest
605     require(success, "Unable to create request");
606   }
607 
608   function getChainlinkToken() public view virtual returns (address);
609 
610   /**
611    * @notice Validate the function called on token transfer
612    */
613   function _validateTokenTransferAction(bytes4 funcSelector, bytes memory data) internal virtual;
614 
615   /**
616    * @dev Reverts if not sent from the LINK token
617    */
618   modifier validateFromLINK() {
619     require(msg.sender == getChainlinkToken(), "Must use LINK token");
620     _;
621   }
622 
623   /**
624    * @dev Reverts if the given data does not begin with the `oracleRequest` function selector
625    * @param data The data payload of the request
626    */
627   modifier permittedFunctionsForLINK(bytes memory data) {
628     bytes4 funcSelector;
629     assembly {
630       // solhint-disable-next-line avoid-low-level-calls
631       funcSelector := mload(add(data, 32))
632     }
633     _validateTokenTransferAction(funcSelector, data);
634     _;
635   }
636 }
637 
638 // File: @chainlink/contracts/src/v0.7/interfaces/AuthorizedReceiverInterface.sol
639 
640 
641 pragma solidity ^0.7.0;
642 
643 interface AuthorizedReceiverInterface {
644   function isAuthorizedSender(address sender) external view returns (bool);
645 
646   function getAuthorizedSenders() external returns (address[] memory);
647 
648   function setAuthorizedSenders(address[] calldata senders) external;
649 }
650 
651 // File: @chainlink/contracts/src/v0.7/AuthorizedReceiver.sol
652 
653 
654 pragma solidity ^0.7.0;
655 
656 
657 abstract contract AuthorizedReceiver is AuthorizedReceiverInterface {
658   mapping(address => bool) private s_authorizedSenders;
659   address[] private s_authorizedSenderList;
660 
661   event AuthorizedSendersChanged(address[] senders, address changedBy);
662 
663   /**
664    * @notice Sets the fulfillment permission for a given node. Use `true` to allow, `false` to disallow.
665    * @param senders The addresses of the authorized Chainlink node
666    */
667   function setAuthorizedSenders(address[] calldata senders) external override validateAuthorizedSenderSetter {
668     require(senders.length > 0, "Must have at least 1 authorized sender");
669     // Set previous authorized senders to false
670     uint256 authorizedSendersLength = s_authorizedSenderList.length;
671     for (uint256 i = 0; i < authorizedSendersLength; i++) {
672       s_authorizedSenders[s_authorizedSenderList[i]] = false;
673     }
674     // Set new to true
675     for (uint256 i = 0; i < senders.length; i++) {
676       s_authorizedSenders[senders[i]] = true;
677     }
678     // Replace list
679     s_authorizedSenderList = senders;
680     emit AuthorizedSendersChanged(senders, msg.sender);
681   }
682 
683   /**
684    * @notice Retrieve a list of authorized senders
685    * @return array of addresses
686    */
687   function getAuthorizedSenders() external view override returns (address[] memory) {
688     return s_authorizedSenderList;
689   }
690 
691   /**
692    * @notice Use this to check if a node is authorized for fulfilling requests
693    * @param sender The address of the Chainlink node
694    * @return The authorization status of the node
695    */
696   function isAuthorizedSender(address sender) public view override returns (bool) {
697     return s_authorizedSenders[sender];
698   }
699 
700   /**
701    * @notice customizable guard of who can update the authorized sender list
702    * @return bool whether sender can update authorized sender list
703    */
704   function _canSetAuthorizedSenders() internal virtual returns (bool);
705 
706   /**
707    * @notice validates the sender is an authorized sender
708    */
709   function _validateIsAuthorizedSender() internal view {
710     require(isAuthorizedSender(msg.sender), "Not authorized sender");
711   }
712 
713   /**
714    * @notice prevents non-authorized addresses from calling this method
715    */
716   modifier validateAuthorizedSender() {
717     _validateIsAuthorizedSender();
718     _;
719   }
720 
721   /**
722    * @notice prevents non-authorized addresses from calling this method
723    */
724   modifier validateAuthorizedSenderSetter() {
725     require(_canSetAuthorizedSenders(), "Cannot set authorized senders");
726     _;
727   }
728 }
729 
730 // File: @chainlink/contracts/src/v0.7/Operator.sol
731 
732 
733 pragma solidity ^0.7.0;
734 
735 
736 
737 
738 
739 
740 
741 
742 
743 
744 /**
745  * @title The Chainlink Operator contract
746  * @notice Node operators can deploy this contract to fulfill requests sent to them
747  */
748 contract Operator is AuthorizedReceiver, ConfirmedOwner, LinkTokenReceiver, OperatorInterface, WithdrawalInterface {
749   using Address for address;
750   using SafeMathChainlink for uint256;
751 
752   struct Commitment {
753     bytes31 paramsHash;
754     uint8 dataVersion;
755   }
756 
757   uint256 public constant getExpiryTime = 5 minutes;
758   uint256 private constant MAXIMUM_DATA_VERSION = 256;
759   uint256 private constant MINIMUM_CONSUMER_GAS_LIMIT = 400000;
760   uint256 private constant SELECTOR_LENGTH = 4;
761   uint256 private constant EXPECTED_REQUEST_WORDS = 2;
762   uint256 private constant MINIMUM_REQUEST_LENGTH = SELECTOR_LENGTH + (32 * EXPECTED_REQUEST_WORDS);
763   // We initialize fields to 1 instead of 0 so that the first invocation
764   // does not cost more gas.
765   uint256 private constant ONE_FOR_CONSISTENT_GAS_COST = 1;
766   // oracleRequest is intended for version 1, enabling single word responses
767   bytes4 private constant ORACLE_REQUEST_SELECTOR = this.oracleRequest.selector;
768   // operatorRequest is intended for version 2, enabling multi-word responses
769   bytes4 private constant OPERATOR_REQUEST_SELECTOR = this.operatorRequest.selector;
770 
771   LinkTokenInterface internal immutable linkToken;
772   mapping(bytes32 => Commitment) private s_commitments;
773   mapping(address => bool) private s_owned;
774   // Tokens sent for requests that have not been fulfilled yet
775   uint256 private s_tokensInEscrow = ONE_FOR_CONSISTENT_GAS_COST;
776 
777   event OracleRequest(
778     bytes32 indexed specId,
779     address requester,
780     bytes32 requestId,
781     uint256 payment,
782     address callbackAddr,
783     bytes4 callbackFunctionId,
784     uint256 cancelExpiration,
785     uint256 dataVersion,
786     bytes data
787   );
788 
789   event CancelOracleRequest(bytes32 indexed requestId);
790 
791   event OracleResponse(bytes32 indexed requestId);
792 
793   event OwnableContractAccepted(address indexed acceptedContract);
794 
795   event TargetsUpdatedAuthorizedSenders(address[] targets, address[] senders, address changedBy);
796 
797   /**
798    * @notice Deploy with the address of the LINK token
799    * @dev Sets the LinkToken address for the imported LinkTokenInterface
800    * @param link The address of the LINK token
801    * @param owner The address of the owner
802    */
803   constructor(address link, address owner) ConfirmedOwner(owner) {
804     linkToken = LinkTokenInterface(link); // external but already deployed and unalterable
805   }
806 
807   /**
808    * @notice The type and version of this contract
809    * @return Type and version string
810    */
811   function typeAndVersion() external pure virtual returns (string memory) {
812     return "Operator 1.0.0";
813   }
814 
815   /**
816    * @notice Creates the Chainlink request. This is a backwards compatible API
817    * with the Oracle.sol contract, but the behavior changes because
818    * callbackAddress is assumed to be the same as the request sender.
819    * @param callbackAddress The consumer of the request
820    * @param payment The amount of payment given (specified in wei)
821    * @param specId The Job Specification ID
822    * @param callbackAddress The address the oracle data will be sent to
823    * @param callbackFunctionId The callback function ID for the response
824    * @param nonce The nonce sent by the requester
825    * @param dataVersion The specified data version
826    * @param data The extra request parameters
827    */
828   function oracleRequest(
829     address sender,
830     uint256 payment,
831     bytes32 specId,
832     address callbackAddress,
833     bytes4 callbackFunctionId,
834     uint256 nonce,
835     uint256 dataVersion,
836     bytes calldata data
837   ) external override validateFromLINK {
838     (bytes32 requestId, uint256 expiration) = _verifyAndProcessOracleRequest(
839       sender,
840       payment,
841       callbackAddress,
842       callbackFunctionId,
843       nonce,
844       dataVersion
845     );
846     emit OracleRequest(specId, sender, requestId, payment, sender, callbackFunctionId, expiration, dataVersion, data);
847   }
848 
849   /**
850    * @notice Creates the Chainlink request
851    * @dev Stores the hash of the params as the on-chain commitment for the request.
852    * Emits OracleRequest event for the Chainlink node to detect.
853    * @param sender The sender of the request
854    * @param payment The amount of payment given (specified in wei)
855    * @param specId The Job Specification ID
856    * @param callbackFunctionId The callback function ID for the response
857    * @param nonce The nonce sent by the requester
858    * @param dataVersion The specified data version
859    * @param data The extra request parameters
860    */
861   function operatorRequest(
862     address sender,
863     uint256 payment,
864     bytes32 specId,
865     bytes4 callbackFunctionId,
866     uint256 nonce,
867     uint256 dataVersion,
868     bytes calldata data
869   ) external override validateFromLINK {
870     (bytes32 requestId, uint256 expiration) = _verifyAndProcessOracleRequest(
871       sender,
872       payment,
873       sender,
874       callbackFunctionId,
875       nonce,
876       dataVersion
877     );
878     emit OracleRequest(specId, sender, requestId, payment, sender, callbackFunctionId, expiration, dataVersion, data);
879   }
880 
881   /**
882    * @notice Called by the Chainlink node to fulfill requests
883    * @dev Given params must hash back to the commitment stored from `oracleRequest`.
884    * Will call the callback address' callback function without bubbling up error
885    * checking in a `require` so that the node can get paid.
886    * @param requestId The fulfillment request ID that must match the requester's
887    * @param payment The payment amount that will be released for the oracle (specified in wei)
888    * @param callbackAddress The callback address to call for fulfillment
889    * @param callbackFunctionId The callback function ID to use for fulfillment
890    * @param expiration The expiration that the node should respond by before the requester can cancel
891    * @param data The data to return to the consuming contract
892    * @return Status if the external call was successful
893    */
894   function fulfillOracleRequest(
895     bytes32 requestId,
896     uint256 payment,
897     address callbackAddress,
898     bytes4 callbackFunctionId,
899     uint256 expiration,
900     bytes32 data
901   )
902     external
903     override
904     validateAuthorizedSender
905     validateRequestId(requestId)
906     validateCallbackAddress(callbackAddress)
907     returns (bool)
908   {
909     _verifyOracleRequestAndProcessPayment(requestId, payment, callbackAddress, callbackFunctionId, expiration, 1);
910     emit OracleResponse(requestId);
911     require(gasleft() >= MINIMUM_CONSUMER_GAS_LIMIT, "Must provide consumer enough gas");
912     // All updates to the oracle's fulfillment should come before calling the
913     // callback(addr+functionId) as it is untrusted.
914     // See: https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern
915     (bool success, ) = callbackAddress.call(abi.encodeWithSelector(callbackFunctionId, requestId, data)); // solhint-disable-line avoid-low-level-calls
916     return success;
917   }
918 
919   /**
920    * @notice Called by the Chainlink node to fulfill requests with multi-word support
921    * @dev Given params must hash back to the commitment stored from `oracleRequest`.
922    * Will call the callback address' callback function without bubbling up error
923    * checking in a `require` so that the node can get paid.
924    * @param requestId The fulfillment request ID that must match the requester's
925    * @param payment The payment amount that will be released for the oracle (specified in wei)
926    * @param callbackAddress The callback address to call for fulfillment
927    * @param callbackFunctionId The callback function ID to use for fulfillment
928    * @param expiration The expiration that the node should respond by before the requester can cancel
929    * @param data The data to return to the consuming contract
930    * @return Status if the external call was successful
931    */
932   function fulfillOracleRequest2(
933     bytes32 requestId,
934     uint256 payment,
935     address callbackAddress,
936     bytes4 callbackFunctionId,
937     uint256 expiration,
938     bytes calldata data
939   )
940     external
941     override
942     validateAuthorizedSender
943     validateRequestId(requestId)
944     validateCallbackAddress(callbackAddress)
945     validateMultiWordResponseId(requestId, data)
946     returns (bool)
947   {
948     _verifyOracleRequestAndProcessPayment(requestId, payment, callbackAddress, callbackFunctionId, expiration, 2);
949     emit OracleResponse(requestId);
950     require(gasleft() >= MINIMUM_CONSUMER_GAS_LIMIT, "Must provide consumer enough gas");
951     // All updates to the oracle's fulfillment should come before calling the
952     // callback(addr+functionId) as it is untrusted.
953     // See: https://solidity.readthedocs.io/en/develop/security-considerations.html#use-the-checks-effects-interactions-pattern
954     (bool success, ) = callbackAddress.call(abi.encodePacked(callbackFunctionId, data)); // solhint-disable-line avoid-low-level-calls
955     return success;
956   }
957 
958   /**
959    * @notice Transfer the ownership of ownable contracts. This is primarily
960    * intended for Authorized Forwarders but could possibly be extended to work
961    * with future contracts.
962    * @param ownable list of addresses to transfer
963    * @param newOwner address to transfer ownership to
964    */
965   function transferOwnableContracts(address[] calldata ownable, address newOwner) external onlyOwner {
966     for (uint256 i = 0; i < ownable.length; i++) {
967       s_owned[ownable[i]] = false;
968       OwnableInterface(ownable[i]).transferOwnership(newOwner);
969     }
970   }
971 
972   /**
973    * @notice Accept the ownership of an ownable contract. This is primarily
974    * intended for Authorized Forwarders but could possibly be extended to work
975    * with future contracts.
976    * @dev Must be the pending owner on the contract
977    * @param ownable list of addresses of Ownable contracts to accept
978    */
979   function acceptOwnableContracts(address[] calldata ownable) public validateAuthorizedSenderSetter {
980     for (uint256 i = 0; i < ownable.length; i++) {
981       s_owned[ownable[i]] = true;
982       emit OwnableContractAccepted(ownable[i]);
983       OwnableInterface(ownable[i]).acceptOwnership();
984     }
985   }
986 
987   /**
988    * @notice Sets the fulfillment permission for
989    * @param targets The addresses to set permissions on
990    * @param senders The addresses that are allowed to send updates
991    */
992   function setAuthorizedSendersOn(address[] calldata targets, address[] calldata senders)
993     public
994     validateAuthorizedSenderSetter
995   {
996     TargetsUpdatedAuthorizedSenders(targets, senders, msg.sender);
997 
998     for (uint256 i = 0; i < targets.length; i++) {
999       AuthorizedReceiverInterface(targets[i]).setAuthorizedSenders(senders);
1000     }
1001   }
1002 
1003   /**
1004    * @notice Accepts ownership of ownable contracts and then immediately sets
1005    * the authorized sender list on each of the newly owned contracts. This is
1006    * primarily intended for Authorized Forwarders but could possibly be
1007    * extended to work with future contracts.
1008    * @param targets The addresses to set permissions on
1009    * @param senders The addresses that are allowed to send updates
1010    */
1011   function acceptAuthorizedReceivers(address[] calldata targets, address[] calldata senders)
1012     external
1013     validateAuthorizedSenderSetter
1014   {
1015     acceptOwnableContracts(targets);
1016     setAuthorizedSendersOn(targets, senders);
1017   }
1018 
1019   /**
1020    * @notice Allows the node operator to withdraw earned LINK to a given address
1021    * @dev The owner of the contract can be another wallet and does not have to be a Chainlink node
1022    * @param recipient The address to send the LINK token to
1023    * @param amount The amount to send (specified in wei)
1024    */
1025   function withdraw(address recipient, uint256 amount)
1026     external
1027     override(OracleInterface, WithdrawalInterface)
1028     onlyOwner
1029     validateAvailableFunds(amount)
1030   {
1031     assert(linkToken.transfer(recipient, amount));
1032   }
1033 
1034   /**
1035    * @notice Displays the amount of LINK that is available for the node operator to withdraw
1036    * @dev We use `ONE_FOR_CONSISTENT_GAS_COST` in place of 0 in storage
1037    * @return The amount of withdrawable LINK on the contract
1038    */
1039   function withdrawable() external view override(OracleInterface, WithdrawalInterface) returns (uint256) {
1040     return _fundsAvailable();
1041   }
1042 
1043   /**
1044    * @notice Forward a call to another contract
1045    * @dev Only callable by the owner
1046    * @param to address
1047    * @param data to forward
1048    */
1049   function ownerForward(address to, bytes calldata data) external onlyOwner validateNotToLINK(to) {
1050     require(to.isContract(), "Must forward to a contract");
1051     (bool status, ) = to.call(data);
1052     require(status, "Forwarded call failed");
1053   }
1054 
1055   /**
1056    * @notice Interact with other LinkTokenReceiver contracts by calling transferAndCall
1057    * @param to The address to transfer to.
1058    * @param value The amount to be transferred.
1059    * @param data The extra data to be passed to the receiving contract.
1060    * @return success bool
1061    */
1062   function ownerTransferAndCall(
1063     address to,
1064     uint256 value,
1065     bytes calldata data
1066   ) external override onlyOwner validateAvailableFunds(value) returns (bool success) {
1067     return linkToken.transferAndCall(to, value, data);
1068   }
1069 
1070   /**
1071    * @notice Distribute funds to multiple addresses using ETH send
1072    * to this payable function.
1073    * @dev Array length must be equal, ETH sent must equal the sum of amounts.
1074    * A malicious receiver could cause the distribution to revert, in which case
1075    * it is expected that the address is removed from the list.
1076    * @param receivers list of addresses
1077    * @param amounts list of amounts
1078    */
1079   function distributeFunds(address payable[] calldata receivers, uint256[] calldata amounts) external payable {
1080     require(receivers.length > 0 && receivers.length == amounts.length, "Invalid array length(s)");
1081     uint256 valueRemaining = msg.value;
1082     for (uint256 i = 0; i < receivers.length; i++) {
1083       uint256 sendAmount = amounts[i];
1084       valueRemaining = valueRemaining.sub(sendAmount);
1085       receivers[i].transfer(sendAmount);
1086     }
1087     require(valueRemaining == 0, "Too much ETH sent");
1088   }
1089 
1090   /**
1091    * @notice Allows recipient to cancel requests sent to this oracle contract.
1092    * Will transfer the LINK sent for the request back to the recipient address.
1093    * @dev Given params must hash to a commitment stored on the contract in order
1094    * for the request to be valid. Emits CancelOracleRequest event.
1095    * @param requestId The request ID
1096    * @param payment The amount of payment given (specified in wei)
1097    * @param callbackFunc The requester's specified callback function selector
1098    * @param expiration The time of the expiration for the request
1099    */
1100   function cancelOracleRequest(
1101     bytes32 requestId,
1102     uint256 payment,
1103     bytes4 callbackFunc,
1104     uint256 expiration
1105   ) external override {
1106     bytes31 paramsHash = _buildParamsHash(payment, msg.sender, callbackFunc, expiration);
1107     require(s_commitments[requestId].paramsHash == paramsHash, "Params do not match request ID");
1108     // solhint-disable-next-line not-rely-on-time
1109     require(expiration <= block.timestamp, "Request is not expired");
1110 
1111     delete s_commitments[requestId];
1112     emit CancelOracleRequest(requestId);
1113 
1114     linkToken.transfer(msg.sender, payment);
1115   }
1116 
1117   /**
1118    * @notice Allows requester to cancel requests sent to this oracle contract.
1119    * Will transfer the LINK sent for the request back to the recipient address.
1120    * @dev Given params must hash to a commitment stored on the contract in order
1121    * for the request to be valid. Emits CancelOracleRequest event.
1122    * @param nonce The nonce used to generate the request ID
1123    * @param payment The amount of payment given (specified in wei)
1124    * @param callbackFunc The requester's specified callback function selector
1125    * @param expiration The time of the expiration for the request
1126    */
1127   function cancelOracleRequestByRequester(
1128     uint256 nonce,
1129     uint256 payment,
1130     bytes4 callbackFunc,
1131     uint256 expiration
1132   ) external {
1133     bytes32 requestId = keccak256(abi.encodePacked(msg.sender, nonce));
1134     bytes31 paramsHash = _buildParamsHash(payment, msg.sender, callbackFunc, expiration);
1135     require(s_commitments[requestId].paramsHash == paramsHash, "Params do not match request ID");
1136     // solhint-disable-next-line not-rely-on-time
1137     require(expiration <= block.timestamp, "Request is not expired");
1138 
1139     delete s_commitments[requestId];
1140     emit CancelOracleRequest(requestId);
1141 
1142     linkToken.transfer(msg.sender, payment);
1143   }
1144 
1145   /**
1146    * @notice Returns the address of the LINK token
1147    * @dev This is the public implementation for chainlinkTokenAddress, which is
1148    * an internal method of the ChainlinkClient contract
1149    */
1150   function getChainlinkToken() public view override returns (address) {
1151     return address(linkToken);
1152   }
1153 
1154   /**
1155    * @notice Require that the token transfer action is valid
1156    * @dev OPERATOR_REQUEST_SELECTOR = multiword, ORACLE_REQUEST_SELECTOR = singleword
1157    */
1158   function _validateTokenTransferAction(bytes4 funcSelector, bytes memory data) internal pure override {
1159     require(data.length >= MINIMUM_REQUEST_LENGTH, "Invalid request length");
1160     require(
1161       funcSelector == OPERATOR_REQUEST_SELECTOR || funcSelector == ORACLE_REQUEST_SELECTOR,
1162       "Must use whitelisted functions"
1163     );
1164   }
1165 
1166   /**
1167    * @notice Verify the Oracle Request and record necessary information
1168    * @param sender The sender of the request
1169    * @param payment The amount of payment given (specified in wei)
1170    * @param callbackAddress The callback address for the response
1171    * @param callbackFunctionId The callback function ID for the response
1172    * @param nonce The nonce sent by the requester
1173    */
1174   function _verifyAndProcessOracleRequest(
1175     address sender,
1176     uint256 payment,
1177     address callbackAddress,
1178     bytes4 callbackFunctionId,
1179     uint256 nonce,
1180     uint256 dataVersion
1181   ) private validateNotToLINK(callbackAddress) returns (bytes32 requestId, uint256 expiration) {
1182     requestId = keccak256(abi.encodePacked(sender, nonce));
1183     require(s_commitments[requestId].paramsHash == 0, "Must use a unique ID");
1184     // solhint-disable-next-line not-rely-on-time
1185     expiration = block.timestamp.add(getExpiryTime);
1186     bytes31 paramsHash = _buildParamsHash(payment, callbackAddress, callbackFunctionId, expiration);
1187     s_commitments[requestId] = Commitment(paramsHash, _safeCastToUint8(dataVersion));
1188     s_tokensInEscrow = s_tokensInEscrow.add(payment);
1189     return (requestId, expiration);
1190   }
1191 
1192   /**
1193    * @notice Verify the Oracle request and unlock escrowed payment
1194    * @param requestId The fulfillment request ID that must match the requester's
1195    * @param payment The payment amount that will be released for the oracle (specified in wei)
1196    * @param callbackAddress The callback address to call for fulfillment
1197    * @param callbackFunctionId The callback function ID to use for fulfillment
1198    * @param expiration The expiration that the node should respond by before the requester can cancel
1199    */
1200   function _verifyOracleRequestAndProcessPayment(
1201     bytes32 requestId,
1202     uint256 payment,
1203     address callbackAddress,
1204     bytes4 callbackFunctionId,
1205     uint256 expiration,
1206     uint256 dataVersion
1207   ) internal {
1208     bytes31 paramsHash = _buildParamsHash(payment, callbackAddress, callbackFunctionId, expiration);
1209     require(s_commitments[requestId].paramsHash == paramsHash, "Params do not match request ID");
1210     require(s_commitments[requestId].dataVersion <= _safeCastToUint8(dataVersion), "Data versions must match");
1211     s_tokensInEscrow = s_tokensInEscrow.sub(payment);
1212     delete s_commitments[requestId];
1213   }
1214 
1215   /**
1216    * @notice Build the bytes31 hash from the payment, callback and expiration.
1217    * @param payment The payment amount that will be released for the oracle (specified in wei)
1218    * @param callbackAddress The callback address to call for fulfillment
1219    * @param callbackFunctionId The callback function ID to use for fulfillment
1220    * @param expiration The expiration that the node should respond by before the requester can cancel
1221    * @return hash bytes31
1222    */
1223   function _buildParamsHash(
1224     uint256 payment,
1225     address callbackAddress,
1226     bytes4 callbackFunctionId,
1227     uint256 expiration
1228   ) internal pure returns (bytes31) {
1229     return bytes31(keccak256(abi.encodePacked(payment, callbackAddress, callbackFunctionId, expiration)));
1230   }
1231 
1232   /**
1233    * @notice Safely cast uint256 to uint8
1234    * @param number uint256
1235    * @return uint8 number
1236    */
1237   function _safeCastToUint8(uint256 number) internal pure returns (uint8) {
1238     require(number < MAXIMUM_DATA_VERSION, "number too big to cast");
1239     return uint8(number);
1240   }
1241 
1242   /**
1243    * @notice Returns the LINK available in this contract, not locked in escrow
1244    * @return uint256 LINK tokens available
1245    */
1246   function _fundsAvailable() private view returns (uint256) {
1247     uint256 inEscrow = s_tokensInEscrow.sub(ONE_FOR_CONSISTENT_GAS_COST);
1248     return linkToken.balanceOf(address(this)).sub(inEscrow);
1249   }
1250 
1251   /**
1252    * @notice concrete implementation of AuthorizedReceiver
1253    * @return bool of whether sender is authorized
1254    */
1255   function _canSetAuthorizedSenders() internal view override returns (bool) {
1256     return isAuthorizedSender(msg.sender) || owner() == msg.sender;
1257   }
1258 
1259   // MODIFIERS
1260 
1261   /**
1262    * @dev Reverts if the first 32 bytes of the bytes array is not equal to requestId
1263    * @param requestId bytes32
1264    * @param data bytes
1265    */
1266   modifier validateMultiWordResponseId(bytes32 requestId, bytes calldata data) {
1267     require(data.length >= 32, "Response must be > 32 bytes");
1268     bytes32 firstDataWord;
1269     assembly {
1270       firstDataWord := calldataload(data.offset)
1271     }
1272     require(requestId == firstDataWord, "First word must be requestId");
1273     _;
1274   }
1275 
1276   /**
1277    * @dev Reverts if amount requested is greater than withdrawable balance
1278    * @param amount The given amount to compare to `s_withdrawableTokens`
1279    */
1280   modifier validateAvailableFunds(uint256 amount) {
1281     require(_fundsAvailable() >= amount, "Amount requested is greater than withdrawable balance");
1282     _;
1283   }
1284 
1285   /**
1286    * @dev Reverts if request ID does not exist
1287    * @param requestId The given request ID to check in stored `commitments`
1288    */
1289   modifier validateRequestId(bytes32 requestId) {
1290     require(s_commitments[requestId].paramsHash != 0, "Must have a valid requestId");
1291     _;
1292   }
1293 
1294   /**
1295    * @dev Reverts if the callback address is the LINK token
1296    * @param to The callback address
1297    */
1298   modifier validateNotToLINK(address to) {
1299     require(to != address(linkToken), "Cannot call to LINK");
1300     _;
1301   }
1302 
1303   /**
1304    * @dev Reverts if the target address is owned by the operator
1305    */
1306   modifier validateCallbackAddress(address callbackAddress) {
1307     require(!s_owned[callbackAddress], "Cannot call owned contract");
1308     _;
1309   }
1310 }
1311 
1312 // File: docs.chain.link/samples/ChainlinkNodes/Operator.sol
1313 
1314 
1315 pragma solidity ^0.7.6;