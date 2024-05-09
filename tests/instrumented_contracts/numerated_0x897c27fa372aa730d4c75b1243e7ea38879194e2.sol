1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/utils/ReentrancyGuard.sol
2 
3 
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor () internal {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and make it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/utils/Address.sol
67 
68 
69 
70 pragma solidity ^0.6.2;
71 
72 /**
73  * @dev Collection of functions related to the address type
74  */
75 library Address {
76     /**
77      * @dev Returns true if `account` is a contract.
78      *
79      * [IMPORTANT]
80      * ====
81      * It is unsafe to assume that an address for which this function returns
82      * false is an externally-owned account (EOA) and not a contract.
83      *
84      * Among others, `isContract` will return false for the following
85      * types of addresses:
86      *
87      *  - an externally-owned account
88      *  - a contract in construction
89      *  - an address where a contract will be created
90      *  - an address where a contract lived, but was destroyed
91      * ====
92      */
93     function isContract(address account) internal view returns (bool) {
94         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
95         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
96         // for accounts without code, i.e. `keccak256('')`
97         bytes32 codehash;
98         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
99         // solhint-disable-next-line no-inline-assembly
100         assembly { codehash := extcodehash(account) }
101         return (codehash != accountHash && codehash != 0x0);
102     }
103 
104     /**
105      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
106      * `recipient`, forwarding all available gas and reverting on errors.
107      *
108      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
109      * of certain opcodes, possibly making contracts go over the 2300 gas limit
110      * imposed by `transfer`, making them unable to receive funds via
111      * `transfer`. {sendValue} removes this limitation.
112      *
113      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
114      *
115      * IMPORTANT: because control is transferred to `recipient`, care must be
116      * taken to not create reentrancy vulnerabilities. Consider using
117      * {ReentrancyGuard} or the
118      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
119      */
120     function sendValue(address payable recipient, uint256 amount) internal {
121         require(address(this).balance >= amount, "Address: insufficient balance");
122 
123         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
124         (bool success, ) = recipient.call{ value: amount }("");
125         require(success, "Address: unable to send value, recipient may have reverted");
126     }
127 
128     /**
129      * @dev Performs a Solidity function call using a low level `call`. A
130      * plain`call` is an unsafe replacement for a function call: use this
131      * function instead.
132      *
133      * If `target` reverts with a revert reason, it is bubbled up by this
134      * function (like regular Solidity function calls).
135      *
136      * Returns the raw returned data. To convert to the expected return value,
137      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
138      *
139      * Requirements:
140      *
141      * - `target` must be a contract.
142      * - calling `target` with `data` must not revert.
143      *
144      * _Available since v3.1._
145      */
146     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
147       return functionCall(target, data, "Address: low-level call failed");
148     }
149 
150     /**
151      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
152      * `errorMessage` as a fallback revert reason when `target` reverts.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
157         return _functionCallWithValue(target, data, 0, errorMessage);
158     }
159 
160     /**
161      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
162      * but also transferring `value` wei to `target`.
163      *
164      * Requirements:
165      *
166      * - the calling contract must have an ETH balance of at least `value`.
167      * - the called Solidity function must be `payable`.
168      *
169      * _Available since v3.1._
170      */
171     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
177      * with `errorMessage` as a fallback revert reason when `target` reverts.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
182         require(address(this).balance >= value, "Address: insufficient balance for call");
183         return _functionCallWithValue(target, data, value, errorMessage);
184     }
185 
186     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
187         require(isContract(target), "Address: call to non-contract");
188 
189         // solhint-disable-next-line avoid-low-level-calls
190         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
191         if (success) {
192             return returndata;
193         } else {
194             // Look for revert reason and bubble it up if present
195             if (returndata.length > 0) {
196                 // The easiest way to bubble the revert reason is using memory via assembly
197 
198                 // solhint-disable-next-line no-inline-assembly
199                 assembly {
200                     let returndata_size := mload(returndata)
201                     revert(add(32, returndata), returndata_size)
202                 }
203             } else {
204                 revert(errorMessage);
205             }
206         }
207     }
208 }
209 
210 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/IERC20.sol
211 
212 
213 
214 pragma solidity ^0.6.0;
215 
216 /**
217  * @dev Interface of the ERC20 standard as defined in the EIP.
218  */
219 interface IERC20 {
220     /**
221      * @dev Returns the amount of tokens in existence.
222      */
223     function totalSupply() external view returns (uint256);
224 
225     /**
226      * @dev Returns the amount of tokens owned by `account`.
227      */
228     function balanceOf(address account) external view returns (uint256);
229 
230     /**
231      * @dev Moves `amount` tokens from the caller's account to `recipient`.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transfer(address recipient, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Returns the remaining number of tokens that `spender` will be
241      * allowed to spend on behalf of `owner` through {transferFrom}. This is
242      * zero by default.
243      *
244      * This value changes when {approve} or {transferFrom} are called.
245      */
246     function allowance(address owner, address spender) external view returns (uint256);
247 
248     /**
249      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * IMPORTANT: Beware that changing an allowance with this method brings the risk
254      * that someone may use both the old and the new allowance by unfortunate
255      * transaction ordering. One possible solution to mitigate this race
256      * condition is to first reduce the spender's allowance to 0 and set the
257      * desired value afterwards:
258      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259      *
260      * Emits an {Approval} event.
261      */
262     function approve(address spender, uint256 amount) external returns (bool);
263 
264     /**
265      * @dev Moves `amount` tokens from `sender` to `recipient` using the
266      * allowance mechanism. `amount` is then deducted from the caller's
267      * allowance.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Emitted when `value` tokens are moved from one account (`from`) to
277      * another (`to`).
278      *
279      * Note that `value` may be zero.
280      */
281     event Transfer(address indexed from, address indexed to, uint256 value);
282 
283     /**
284      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
285      * a call to {approve}. `value` is the new allowance.
286      */
287     event Approval(address indexed owner, address indexed spender, uint256 value);
288 }
289 
290 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/math/SafeMath.sol
291 
292 
293 
294 pragma solidity ^0.6.0;
295 
296 /**
297  * @dev Wrappers over Solidity's arithmetic operations with added overflow
298  * checks.
299  *
300  * Arithmetic operations in Solidity wrap on overflow. This can easily result
301  * in bugs, because programmers usually assume that an overflow raises an
302  * error, which is the standard behavior in high level programming languages.
303  * `SafeMath` restores this intuition by reverting the transaction when an
304  * operation overflows.
305  *
306  * Using this library instead of the unchecked operations eliminates an entire
307  * class of bugs, so it's recommended to use it always.
308  */
309 library SafeMath {
310     /**
311      * @dev Returns the addition of two unsigned integers, reverting on
312      * overflow.
313      *
314      * Counterpart to Solidity's `+` operator.
315      *
316      * Requirements:
317      *
318      * - Addition cannot overflow.
319      */
320     function add(uint256 a, uint256 b) internal pure returns (uint256) {
321         uint256 c = a + b;
322         require(c >= a, "SafeMath: addition overflow");
323 
324         return c;
325     }
326 
327     /**
328      * @dev Returns the subtraction of two unsigned integers, reverting on
329      * overflow (when the result is negative).
330      *
331      * Counterpart to Solidity's `-` operator.
332      *
333      * Requirements:
334      *
335      * - Subtraction cannot overflow.
336      */
337     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
338         return sub(a, b, "SafeMath: subtraction overflow");
339     }
340 
341     /**
342      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
343      * overflow (when the result is negative).
344      *
345      * Counterpart to Solidity's `-` operator.
346      *
347      * Requirements:
348      *
349      * - Subtraction cannot overflow.
350      */
351     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         require(b <= a, errorMessage);
353         uint256 c = a - b;
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the multiplication of two unsigned integers, reverting on
360      * overflow.
361      *
362      * Counterpart to Solidity's `*` operator.
363      *
364      * Requirements:
365      *
366      * - Multiplication cannot overflow.
367      */
368     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
369         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
370         // benefit is lost if 'b' is also tested.
371         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
372         if (a == 0) {
373             return 0;
374         }
375 
376         uint256 c = a * b;
377         require(c / a == b, "SafeMath: multiplication overflow");
378 
379         return c;
380     }
381 
382     /**
383      * @dev Returns the integer division of two unsigned integers. Reverts on
384      * division by zero. The result is rounded towards zero.
385      *
386      * Counterpart to Solidity's `/` operator. Note: this function uses a
387      * `revert` opcode (which leaves remaining gas untouched) while Solidity
388      * uses an invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function div(uint256 a, uint256 b) internal pure returns (uint256) {
395         return div(a, b, "SafeMath: division by zero");
396     }
397 
398     /**
399      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
400      * division by zero. The result is rounded towards zero.
401      *
402      * Counterpart to Solidity's `/` operator. Note: this function uses a
403      * `revert` opcode (which leaves remaining gas untouched) while Solidity
404      * uses an invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
411         require(b > 0, errorMessage);
412         uint256 c = a / b;
413         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
414 
415         return c;
416     }
417 
418     /**
419      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
420      * Reverts when dividing by zero.
421      *
422      * Counterpart to Solidity's `%` operator. This function uses a `revert`
423      * opcode (which leaves remaining gas untouched) while Solidity uses an
424      * invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      *
428      * - The divisor cannot be zero.
429      */
430     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
431         return mod(a, b, "SafeMath: modulo by zero");
432     }
433 
434     /**
435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
436      * Reverts with custom message when dividing by zero.
437      *
438      * Counterpart to Solidity's `%` operator. This function uses a `revert`
439      * opcode (which leaves remaining gas untouched) while Solidity uses an
440      * invalid opcode to revert (consuming all remaining gas).
441      *
442      * Requirements:
443      *
444      * - The divisor cannot be zero.
445      */
446     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
447         require(b != 0, errorMessage);
448         return a % b;
449     }
450 }
451 
452 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/SafeERC20.sol
453 
454 
455 
456 pragma solidity ^0.6.0;
457 
458 
459 
460 
461 /**
462  * @title SafeERC20
463  * @dev Wrappers around ERC20 operations that throw on failure (when the token
464  * contract returns false). Tokens that return no value (and instead revert or
465  * throw on failure) are also supported, non-reverting calls are assumed to be
466  * successful.
467  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
468  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
469  */
470 library SafeERC20 {
471     using SafeMath for uint256;
472     using Address for address;
473 
474     function safeTransfer(IERC20 token, address to, uint256 value) internal {
475         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
476     }
477 
478     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
479         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
480     }
481 
482     /**
483      * @dev Deprecated. This function has issues similar to the ones found in
484      * {IERC20-approve}, and its usage is discouraged.
485      *
486      * Whenever possible, use {safeIncreaseAllowance} and
487      * {safeDecreaseAllowance} instead.
488      */
489     function safeApprove(IERC20 token, address spender, uint256 value) internal {
490         // safeApprove should only be called when setting an initial allowance,
491         // or when resetting it to zero. To increase and decrease it, use
492         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
493         // solhint-disable-next-line max-line-length
494         require((value == 0) || (token.allowance(address(this), spender) == 0),
495             "SafeERC20: approve from non-zero to non-zero allowance"
496         );
497         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
498     }
499 
500     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
501         uint256 newAllowance = token.allowance(address(this), spender).add(value);
502         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
503     }
504 
505     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
506         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
507         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
508     }
509 
510     /**
511      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
512      * on the return value: the return value is optional (but if data is returned, it must not be false).
513      * @param token The token targeted by the call.
514      * @param data The call data (encoded using abi.encode or one of its variants).
515      */
516     function _callOptionalReturn(IERC20 token, bytes memory data) private {
517         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
518         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
519         // the target address contains contract code and also asserts for success in the low-level call.
520 
521         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
522         if (returndata.length > 0) { // Return data is optional
523             // solhint-disable-next-line max-line-length
524             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
525         }
526     }
527 }
528 
529 // File: hub2eth.sol
530 
531 
532 
533 pragma solidity ^0.6.6;
534 
535 
536 
537 
538 
539 
540 pragma experimental ABIEncoderV2;
541 
542 // This is being used purely to avoid stack too deep errors
543 struct LogicCallArgs {
544 	// Transfers out to the logic contract
545 	uint256[] transferAmounts;
546 	address[] transferTokenContracts;
547 	// The fees (transferred to msg.sender)
548 	uint256[] feeAmounts;
549 	address[] feeTokenContracts;
550 	// The arbitrary logic call
551 	address logicContractAddress;
552 	bytes payload;
553 	// Invalidation metadata
554 	uint256 timeOut;
555 	bytes32 invalidationId;
556 	uint256 invalidationNonce;
557 }
558 
559 interface IWETH {
560     function deposit() external payable;
561     function withdraw(uint) external;
562 }
563 
564 contract Hub2Eth is ReentrancyGuard {
565 	using SafeMath for uint256;
566 	using SafeMath for uint;
567 	using SafeERC20 for IERC20;
568 
569 	// These are updated often
570 	bytes32 public state_lastValsetCheckpoint;
571 	mapping(address => uint256) public state_lastBatchNonces;
572 	mapping(bytes32 => uint256) public state_invalidationMapping;
573 	uint256 public state_lastValsetNonce = 0;
574 	// event nonce zero is reserved by the Cosmos module as a special
575 	// value indicating that no events have yet been submitted
576 	uint256 public state_lastEventNonce = 1;
577 
578 	// These are set once at initialization
579 	bytes32 public state_gravityId;
580 	uint256 public state_powerThreshold;
581 
582 	address public wethAddress;
583 
584 	address public guardian;
585 
586 	// TransactionBatchExecutedEvent and TransferToChain both include the field _eventNonce.
587 	// This is incremented every time one of these events is emitted. It is checked by the
588 	// Cosmos module to ensure that all events are received in order, and that none are lost.
589 	//
590 	// ValsetUpdatedEvent does not include the field _eventNonce because it is never submitted to the Cosmos
591 	// module. It is purely for the use of relayers to allow them to successfully submit batches.
592 	event TransactionBatchExecutedEvent(
593 		uint256 indexed _batchNonce,
594 		address indexed _token,
595 		uint256 _eventNonce
596 	);
597 	event TransferToChainEvent(
598 		address indexed _tokenContract,
599 		address indexed _sender,
600 		bytes32 indexed _destinationChain,
601 		bytes32 _destination,
602 		uint256 _amount,
603 		uint256 _fee,
604 		uint256 _eventNonce
605 	);
606 	event ValsetUpdatedEvent(
607 		uint256 indexed _newValsetNonce,
608 		uint256 _eventNonce,
609 		address[] _validators,
610 		uint256[] _powers
611 	);
612 	event LogicCallEvent(
613 		bytes32 _invalidationId,
614 		uint256 _invalidationNonce,
615 		uint256 _eventNonce,
616 		bytes _returnData
617 	);
618 
619 	receive() external payable {
620         assert(msg.sender == wethAddress); // only accept ETH via fallback from the WETH contract
621     }
622 
623 	function lastBatchNonce(address _erc20Address) public view returns (uint256) {
624 		return state_lastBatchNonces[_erc20Address];
625 	}
626 
627 	function lastLogicCallNonce(bytes32 _invalidation_id) public view returns (uint256) {
628 		return state_invalidationMapping[_invalidation_id];
629 	}
630 
631 	// Utility function to verify geth style signatures
632 	function verifySig(
633 		address _signer,
634 		bytes32 _theHash,
635 		uint8 _v,
636 		bytes32 _r,
637 		bytes32 _s
638 	) private pure returns (bool) {
639 		bytes32 messageDigest =
640 			keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _theHash));
641 		return _signer == ecrecover(messageDigest, _v, _r, _s);
642 	}
643 
644 	// Make a new checkpoint from the supplied validator set
645 	// A checkpoint is a hash of all relevant information about the valset. This is stored by the contract,
646 	// instead of storing the information directly. This saves on storage and gas.
647 	// The format of the checkpoint is:
648 	// h(gravityId, "checkpoint", valsetNonce, validators[], powers[])
649 	// Where h is the keccak256 hash function.
650 	// The validator powers must be decreasing or equal. This is important for checking the signatures on the
651 	// next valset, since it allows the caller to stop verifying signatures once a quorum of signatures have been verified.
652 	function makeCheckpoint(
653 		address[] memory _validators,
654 		uint256[] memory _powers,
655 		uint256 _valsetNonce,
656 		bytes32 _gravityId
657 	) private pure returns (bytes32) {
658 		// bytes32 encoding of the string "checkpoint"
659 		bytes32 methodName = 0x636865636b706f696e7400000000000000000000000000000000000000000000;
660 
661 		bytes32 checkpoint =
662 			keccak256(abi.encode(_gravityId, methodName, _valsetNonce, _validators, _powers));
663 
664 		return checkpoint;
665 	}
666 
667 	function checkValidatorSignatures(
668 		// The current validator set and their powers
669 		address[] memory _currentValidators,
670 		uint256[] memory _currentPowers,
671 		// The current validator's signatures
672 		uint8[] memory _v,
673 		bytes32[] memory _r,
674 		bytes32[] memory _s,
675 		// This is what we are checking they have signed
676 		bytes32 _theHash,
677 		uint256 _powerThreshold
678 	) private pure {
679 		uint256 cumulativePower = 0;
680 
681 		for (uint256 i = 0; i < _currentValidators.length; i++) {
682 			// If v is set to 0, this signifies that it was not possible to get a signature from this validator and we skip evaluation
683 			// (In a valid signature, it is either 27 or 28)
684 			if (_v[i] != 0) {
685 				// Check that the current validator has signed off on the hash
686 				require(
687 					verifySig(_currentValidators[i], _theHash, _v[i], _r[i], _s[i]),
688 					"Validator signature does not match."
689 				);
690 
691 				// Sum up cumulative power
692 				cumulativePower = cumulativePower + _currentPowers[i];
693 
694 				// Break early to avoid wasting gas
695 				if (cumulativePower > _powerThreshold) {
696 					break;
697 				}
698 			}
699 		}
700 
701 		// Check that there was enough power
702 		require(
703 			cumulativePower > _powerThreshold,
704 			"Submitted validator set signatures do not have enough power."
705 		);
706 		// Success
707 	}
708 
709 	// This updates the valset by checking that the validators in the current valset have signed off on the
710 	// new valset. The signatures supplied are the signatures of the current valset over the checkpoint hash
711 	// generated from the new valset.
712 	// Anyone can call this function, but they must supply valid signatures of state_powerThreshold of the current valset over
713 	// the new valset.
714 	function updateValset(
715 		// The new version of the validator set
716 		address[] memory _newValidators,
717 		uint256[] memory _newPowers,
718 		uint256 _newValsetNonce,
719 		// The current validators that approve the change
720 		address[] memory _currentValidators,
721 		uint256[] memory _currentPowers,
722 		uint256 _currentValsetNonce,
723 		// These are arrays of the parts of the current validator's signatures
724 		uint8[] memory _v,
725 		bytes32[] memory _r,
726 		bytes32[] memory _s
727 	) public nonReentrant {
728 		// CHECKS
729 
730 		// Check that the valset nonce is greater than the old one
731 		require(
732 			_newValsetNonce > _currentValsetNonce,
733 			"New valset nonce must be greater than the current nonce"
734 		);
735 
736 		// Check that new validators and powers set is well-formed
737 		require(_newValidators.length == _newPowers.length, "Malformed new validator set");
738 
739 		// Check that current validators, powers, and signatures (v,r,s) set is well-formed
740 		require(
741 			_currentValidators.length == _currentPowers.length &&
742 				_currentValidators.length == _v.length &&
743 				_currentValidators.length == _r.length &&
744 				_currentValidators.length == _s.length,
745 			"Malformed current validator set"
746 		);
747 
748 		// Check that the supplied current validator set matches the saved checkpoint
749 		require(
750 			makeCheckpoint(
751 				_currentValidators,
752 				_currentPowers,
753 				_currentValsetNonce,
754 				state_gravityId
755 			) == state_lastValsetCheckpoint,
756 			"Supplied current validators and powers do not match checkpoint."
757 		);
758 
759 		// Check that enough current validators have signed off on the new validator set
760 		bytes32 newCheckpoint =
761 			makeCheckpoint(_newValidators, _newPowers, _newValsetNonce, state_gravityId);
762 
763 		checkValidatorSignatures(
764 			_currentValidators,
765 			_currentPowers,
766 			_v,
767 			_r,
768 			_s,
769 			newCheckpoint,
770 			state_powerThreshold
771 		);
772 
773 		// ACTIONS
774 
775 		// Stored to be used next time to validate that the valset
776 		// supplied by the caller is correct.
777 		state_lastValsetCheckpoint = newCheckpoint;
778 
779 		// Store new nonce
780 		state_lastValsetNonce = _newValsetNonce;
781 
782 		// LOGS
783 		state_lastEventNonce = state_lastEventNonce.add(1);
784 		emit ValsetUpdatedEvent(_newValsetNonce, state_lastEventNonce, _newValidators, _newPowers);
785 	}
786 
787 	// submitBatch processes a batch of Cosmos -> Ethereum transactions by sending the tokens in the transactions
788 	// to the destination addresses. It is approved by the current Cosmos validator set.
789 	// Anyone can call this function, but they must supply valid signatures of state_powerThreshold of the current valset over
790 	// the batch.
791 	function submitBatch(
792 		// The validators that approve the batch
793 		address[] memory _currentValidators,
794 		uint256[] memory _currentPowers,
795 		uint256 _currentValsetNonce,
796 		// These are arrays of the parts of the validators signatures
797 		uint8[] memory _v,
798 		bytes32[] memory _r,
799 		bytes32[] memory _s,
800 		// The batch of transactions
801 		uint256[] memory _amounts,
802 		address payable[] memory _destinations,
803 		uint256[] memory _fees,
804 		uint256 _batchNonce,
805 		address _tokenContract,
806 		// a block height beyond which this batch is not valid
807 		// used to provide a fee-free timeout
808 		uint256 _batchTimeout
809 	) public nonReentrant {
810 		// CHECKS scoped to reduce stack depth
811 		{
812 			// Check that the batch nonce is higher than the last nonce for this token
813 			require(
814 				state_lastBatchNonces[_tokenContract] < _batchNonce,
815 				"New batch nonce must be greater than the current nonce"
816 			);
817 
818 			// Check that the block height is less than the timeout height
819 			require(
820 				block.number < _batchTimeout,
821 				"Batch timeout must be greater than the current block height"
822 			);
823 
824 			// Check that current validators, powers, and signatures (v,r,s) set is well-formed
825 			require(
826 				_currentValidators.length == _currentPowers.length &&
827 					_currentValidators.length == _v.length &&
828 					_currentValidators.length == _r.length &&
829 					_currentValidators.length == _s.length,
830 				"Malformed current validator set"
831 			);
832 
833 			// Check that the supplied current validator set matches the saved checkpoint
834 			require(
835 				makeCheckpoint(
836 					_currentValidators,
837 					_currentPowers,
838 					_currentValsetNonce,
839 					state_gravityId
840 				) == state_lastValsetCheckpoint,
841 				"Supplied current validators and powers do not match checkpoint."
842 			);
843 
844 			// Check that the transaction batch is well-formed
845 			require(
846 				_amounts.length == _destinations.length && _amounts.length == _fees.length,
847 				"Malformed batch of transactions"
848 			);
849 
850 			// Check that enough current validators have signed off on the transaction batch and valset
851 			checkValidatorSignatures(
852 				_currentValidators,
853 				_currentPowers,
854 				_v,
855 				_r,
856 				_s,
857 				// Get hash of the transaction batch and checkpoint
858 				keccak256(
859 					abi.encode(
860 						state_gravityId,
861 						// bytes32 encoding of "transactionBatch"
862 						0x7472616e73616374696f6e426174636800000000000000000000000000000000,
863 						_amounts,
864 						_destinations,
865 						_fees,
866 						_batchNonce,
867 						_tokenContract,
868 						_batchTimeout
869 					)
870 				),
871 				state_powerThreshold
872 			);
873 
874 			// ACTIONS
875 
876 			// Store batch nonce
877 			state_lastBatchNonces[_tokenContract] = _batchNonce;
878 
879 			// Send transaction amounts to destinations
880 			if (_tokenContract == wethAddress) {
881 				for (uint256 i = 0; i < _amounts.length; i++) {
882 					IWETH(wethAddress).withdraw(_amounts[i]);
883 					TransferHelper.safeTransferETH(_destinations[i], _amounts[i]);
884 				}
885 			} else {
886 				for (uint256 i = 0; i < _amounts.length; i++) {
887 					IERC20(_tokenContract).safeTransfer(_destinations[i], _amounts[i]);
888 				}
889 			}
890 		}
891 
892 		// LOGS scoped to reduce stack depth
893 		{
894 			state_lastEventNonce = state_lastEventNonce.add(1);
895 			emit TransactionBatchExecutedEvent(_batchNonce, _tokenContract, state_lastEventNonce);
896 		}
897 	}
898 
899 	// This makes calls to contracts that execute arbitrary logic
900 	// First, it gives the logic contract some tokens
901 	// Then, it gives msg.senders tokens for fees
902 	// Then, it calls an arbitrary function on the logic contract
903 	// invalidationId and invalidationNonce are used for replay prevention.
904 	// They can be used to implement a per-token nonce by setting the token
905 	// address as the invalidationId and incrementing the nonce each call.
906 	// They can be used for nonce-free replay prevention by using a different invalidationId
907 	// for each call.
908 	function submitLogicCall(
909 		// The validators that approve the call
910 		address[] memory _currentValidators,
911 		uint256[] memory _currentPowers,
912 		uint256 _currentValsetNonce,
913 		// These are arrays of the parts of the validators signatures
914 		uint8[] memory _v,
915 		bytes32[] memory _r,
916 		bytes32[] memory _s,
917 		LogicCallArgs memory _args
918 	) public nonReentrant {
919 		// CHECKS scoped to reduce stack depth
920 		{
921 			// Check that the call has not timed out
922 			require(block.number < _args.timeOut, "Timed out");
923 
924 			// Check that the invalidation nonce is higher than the last nonce for this invalidation Id
925 			require(
926 				state_invalidationMapping[_args.invalidationId] < _args.invalidationNonce,
927 				"New invalidation nonce must be greater than the current nonce"
928 			);
929 
930 			// Check that current validators, powers, and signatures (v,r,s) set is well-formed
931 			require(
932 				_currentValidators.length == _currentPowers.length &&
933 					_currentValidators.length == _v.length &&
934 					_currentValidators.length == _r.length &&
935 					_currentValidators.length == _s.length,
936 				"Malformed current validator set"
937 			);
938 
939 			// Check that the supplied current validator set matches the saved checkpoint
940 			require(
941 				makeCheckpoint(
942 					_currentValidators,
943 					_currentPowers,
944 					_currentValsetNonce,
945 					state_gravityId
946 				) == state_lastValsetCheckpoint,
947 				"Supplied current validators and powers do not match checkpoint."
948 			);
949 
950 			// Check that the token transfer list is well-formed
951 			require(
952 				_args.transferAmounts.length == _args.transferTokenContracts.length,
953 				"Malformed list of token transfers"
954 			);
955 
956 			// Check that the fee list is well-formed
957 			require(
958 				_args.feeAmounts.length == _args.feeTokenContracts.length,
959 				"Malformed list of fees"
960 			);
961 		}
962 
963 		bytes32 argsHash =
964 			keccak256(
965 				abi.encode(
966 					state_gravityId,
967 					// bytes32 encoding of "logicCall"
968 					0x6c6f67696343616c6c0000000000000000000000000000000000000000000000,
969 					_args.transferAmounts,
970 					_args.transferTokenContracts,
971 					_args.feeAmounts,
972 					_args.feeTokenContracts,
973 					_args.logicContractAddress,
974 					_args.payload,
975 					_args.timeOut,
976 					_args.invalidationId,
977 					_args.invalidationNonce
978 				)
979 			);
980 
981 		{
982 			// Check that enough current validators have signed off on the transaction batch and valset
983 			checkValidatorSignatures(
984 				_currentValidators,
985 				_currentPowers,
986 				_v,
987 				_r,
988 				_s,
989 				// Get hash of the transaction batch and checkpoint
990 				argsHash,
991 				state_powerThreshold
992 			);
993 		}
994 
995 		// ACTIONS
996 
997 		// Update invaldiation nonce
998 		state_invalidationMapping[_args.invalidationId] = _args.invalidationNonce;
999 
1000 		// Send tokens to the logic contract
1001 		for (uint256 i = 0; i < _args.transferAmounts.length; i++) {
1002 			IERC20(_args.transferTokenContracts[i]).safeTransfer(
1003 				_args.logicContractAddress,
1004 				_args.transferAmounts[i]
1005 			);
1006 		}
1007 
1008 		// Make call to logic contract
1009 		bytes memory returnData = Address.functionCall(_args.logicContractAddress, _args.payload);
1010 
1011 		// Send fees to msg.sender
1012 		for (uint256 i = 0; i < _args.feeAmounts.length; i++) {
1013 			IERC20(_args.feeTokenContracts[i]).safeTransfer(msg.sender, _args.feeAmounts[i]);
1014 		}
1015 
1016 		// LOGS scoped to reduce stack depth
1017 		{
1018 			state_lastEventNonce = state_lastEventNonce.add(1);
1019 			emit LogicCallEvent(
1020 				_args.invalidationId,
1021 				_args.invalidationNonce,
1022 				state_lastEventNonce,
1023 				returnData
1024 			);
1025 		}
1026 	}
1027 
1028 	function transferToChain(
1029 		address _tokenContract,
1030 		bytes32 _destinationChain,
1031 		bytes32 _destination,
1032 		uint256 _amount,
1033 		uint256 _fee
1034 	) public nonReentrant {
1035 		IERC20(_tokenContract).safeTransferFrom(msg.sender, address(this), _amount);
1036 		state_lastEventNonce = state_lastEventNonce.add(1);
1037 		emit TransferToChainEvent(
1038 			_tokenContract,
1039 			msg.sender,
1040 			_destinationChain,
1041 			_destination,
1042 			_amount,
1043 			_fee,
1044 			state_lastEventNonce
1045 		);
1046 	}
1047 
1048 	function transferETHToChain(
1049 		bytes32 _destinationChain,
1050 		bytes32 _destination,
1051 		uint256 _fee
1052 	) public nonReentrant payable {
1053 		IWETH(wethAddress).deposit{value: msg.value}();
1054 		state_lastEventNonce = state_lastEventNonce.add(1);
1055 		emit TransferToChainEvent(
1056 			wethAddress,
1057 			msg.sender,
1058 			_destinationChain,
1059 			_destination,
1060 			msg.value,
1061 			_fee,
1062 			state_lastEventNonce
1063 		);
1064 	}
1065 
1066 	function changeGuardian(address _guardian) public {
1067 		require(msg.sender == guardian, "permission denied");
1068 
1069 		guardian = _guardian;
1070 	}
1071 
1072 	function panicHalt(address[] memory _tokenContracts, address _safeAddress) public {
1073 		require(msg.sender == guardian, "permission denied");
1074 
1075 		for (uint256 i = 0; i < _tokenContracts.length; i++) {
1076 			IERC20 token = IERC20(_tokenContracts[i]);
1077 			token.safeTransfer(_safeAddress, token.balanceOf(address(this)));
1078 		}
1079 	}
1080 
1081 	constructor(
1082 		// A unique identifier for this gravity instance to use in signatures
1083 		bytes32 _gravityId,
1084 		// How much voting power is needed to approve operations
1085 		uint256 _powerThreshold,
1086 		// The validator set
1087 		address[] memory _validators,
1088 		uint256[] memory _powers,
1089 		address[] memory _validators2,
1090 		uint256[] memory _powers2,
1091 		address _wethAddress,
1092 		address _guardian
1093 	) public {
1094 		// CHECKS
1095 
1096 		// Check that validators, powers, and signatures (v,r,s) set is well-formed
1097 		require(_validators.length == _powers.length, "Malformed current validator set");
1098 
1099 		// Check cumulative power to ensure the contract has sufficient power to actually
1100 		// pass a vote
1101 		uint256 cumulativePower = 0;
1102 		for (uint256 i = 0; i < _powers.length; i++) {
1103 			cumulativePower = cumulativePower + _powers[i];
1104 			if (cumulativePower > _powerThreshold) {
1105 				break;
1106 			}
1107 		}
1108 		require(
1109 			cumulativePower > _powerThreshold,
1110 			"Submitted validator set signatures do not have enough power."
1111 		);
1112 
1113 		bytes32 newCheckpoint = makeCheckpoint(_validators2, _powers2, 3, _gravityId);
1114 
1115 		// ACTIONS
1116 
1117 		state_gravityId = _gravityId;
1118 		state_powerThreshold = _powerThreshold;
1119 		state_lastValsetCheckpoint = newCheckpoint;
1120 
1121 		wethAddress = _wethAddress;
1122 		guardian = _guardian;
1123 
1124 		// LOGS
1125 
1126 		emit ValsetUpdatedEvent(state_lastValsetNonce, state_lastEventNonce, _validators, _powers);
1127 		emit ValsetUpdatedEvent(3, 2, _validators2, _powers2);
1128 		state_lastValsetNonce = 3;
1129 		state_lastEventNonce = 2;
1130 	}
1131 }
1132 
1133 library TransferHelper {
1134     function safeApprove(address token, address to, uint value) internal {
1135         // bytes4(keccak256(bytes('approve(address,uint256)')));
1136         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1137         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
1138     }
1139 
1140     function safeTransfer(address token, address to, uint value) internal {
1141         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1142         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
1143         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
1144     }
1145 
1146     function safeTransferFrom(address token, address from, address to, uint value) internal {
1147         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1148         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1149         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
1150     }
1151 
1152     function safeTransferETH(address to, uint value) internal {
1153         (bool success,) = to.call{value:value}(new bytes(0));
1154         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1155     }
1156 }