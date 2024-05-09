1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 pragma solidity 0.7.6;
162 
163 /**
164  * a contract must implement this interface in order to support relayed transaction.
165  * It is better to inherit the BaseRelayRecipient as its implementation.
166  */
167 abstract contract IRelayRecipient {
168 
169     /**
170      * return if the forwarder is trusted to forward relayed transactions to us.
171      * the forwarder is required to verify the sender's signature, and verify
172      * the call is not a replay.
173      */
174     function isTrustedForwarder(address forwarder) public virtual view returns(bool);
175 
176     /**
177      * return the sender of this call.
178      * if the call came through our trusted forwarder, then the real sender is appended as the last 20 bytes
179      * of the msg.data.
180      * otherwise, return `msg.sender`
181      * should be used in the contract anywhere instead of msg.sender
182      */
183     function _msgSender() internal virtual view returns (address payable);
184 
185     function versionRecipient() external virtual view returns (string memory);
186 }
187 
188 pragma solidity 0.7.6;
189 
190 /**
191  * A base contract to be inherited by any contract that want to receive relayed transactions
192  * A subclass must use "_msgSender()" instead of "msg.sender"
193  */
194 abstract contract BaseRelayRecipient is IRelayRecipient {
195 
196     /*
197      * Forwarder singleton we accept calls from
198      */
199     address public trustedForwarder;
200 
201     /*
202      * require a function to be called through GSN only
203      */
204     modifier trustedForwarderOnly() {
205         require(msg.sender == address(trustedForwarder), "Function can only be called through the trusted Forwarder");
206         _;
207     }
208 
209     function isTrustedForwarder(address forwarder) public override view returns(bool) {
210         return forwarder == trustedForwarder;
211     }
212 
213     /**
214      * return the sender of this call.
215      * if the call came through our trusted forwarder, return the original sender.
216      * otherwise, return `msg.sender`.
217      * should be used in the contract anywhere instead of msg.sender
218      */
219     function _msgSender() internal override virtual view returns (address payable ret) {
220         if (msg.data.length >= 24 && isTrustedForwarder(msg.sender)) {
221             // At this point we know that the sender is a trusted forwarder,
222             // so we trust that the last bytes of msg.data are the verified sender address.
223             // extract sender address from the end of msg.data
224             assembly {
225                 ret := shr(96,calldataload(sub(calldatasize(),20)))
226             }
227         } else {
228             return msg.sender;
229         }
230     }
231 }
232 
233 
234 pragma solidity >=0.6.0 <0.8.0;
235 
236 /**
237  * @dev Interface of the ERC20 standard as defined in the EIP.
238  */
239 interface IERC20 {
240     /**
241      * @dev Returns the amount of tokens in existence.
242      */
243     function totalSupply() external view returns (uint256);
244 
245     /**
246      * @dev Returns the amount of tokens owned by `account`.
247      */
248     function balanceOf(address account) external view returns (uint256);
249 
250     /**
251      * @dev Moves `amount` tokens from the caller's account to `recipient`.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transfer(address recipient, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Returns the remaining number of tokens that `spender` will be
261      * allowed to spend on behalf of `owner` through {transferFrom}. This is
262      * zero by default.
263      *
264      * This value changes when {approve} or {transferFrom} are called.
265      */
266     function allowance(address owner, address spender) external view returns (uint256);
267 
268     /**
269      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * IMPORTANT: Beware that changing an allowance with this method brings the risk
274      * that someone may use both the old and the new allowance by unfortunate
275      * transaction ordering. One possible solution to mitigate this race
276      * condition is to first reduce the spender's allowance to 0 and set the
277      * desired value afterwards:
278      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
279      *
280      * Emits an {Approval} event.
281      */
282     function approve(address spender, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Moves `amount` tokens from `sender` to `recipient` using the
286      * allowance mechanism. `amount` is then deducted from the caller's
287      * allowance.
288      *
289      * Returns a boolean value indicating whether the operation succeeded.
290      *
291      * Emits a {Transfer} event.
292      */
293     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
294 
295     /**
296      * @dev Emitted when `value` tokens are moved from one account (`from`) to
297      * another (`to`).
298      *
299      * Note that `value` may be zero.
300      */
301     event Transfer(address indexed from, address indexed to, uint256 value);
302 
303     /**
304      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
305      * a call to {approve}. `value` is the new allowance.
306      */
307     event Approval(address indexed owner, address indexed spender, uint256 value);
308 }
309 
310 
311 pragma solidity >=0.6.2 <0.8.0;
312 
313 /**
314  * @dev Collection of functions related to the address type
315  */
316 library Address {
317     /**
318      * @dev Returns true if `account` is a contract.
319      *
320      * [IMPORTANT]
321      * ====
322      * It is unsafe to assume that an address for which this function returns
323      * false is an externally-owned account (EOA) and not a contract.
324      *
325      * Among others, `isContract` will return false for the following
326      * types of addresses:
327      *
328      *  - an externally-owned account
329      *  - a contract in construction
330      *  - an address where a contract will be created
331      *  - an address where a contract lived, but was destroyed
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // This method relies on extcodesize, which returns 0 for contracts in
336         // construction, since the code is only stored at the end of the
337         // constructor execution.
338 
339         uint256 size;
340         // solhint-disable-next-line no-inline-assembly
341         assembly { size := extcodesize(account) }
342         return size > 0;
343     }
344 
345     /**
346      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
347      * `recipient`, forwarding all available gas and reverting on errors.
348      *
349      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
350      * of certain opcodes, possibly making contracts go over the 2300 gas limit
351      * imposed by `transfer`, making them unable to receive funds via
352      * `transfer`. {sendValue} removes this limitation.
353      *
354      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
355      *
356      * IMPORTANT: because control is transferred to `recipient`, care must be
357      * taken to not create reentrancy vulnerabilities. Consider using
358      * {ReentrancyGuard} or the
359      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
360      */
361     function sendValue(address payable recipient, uint256 amount) internal {
362         require(address(this).balance >= amount, "Address: insufficient balance");
363 
364         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
365         (bool success, ) = recipient.call{ value: amount }("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 
369     /**
370      * @dev Performs a Solidity function call using a low level `call`. A
371      * plain`call` is an unsafe replacement for a function call: use this
372      * function instead.
373      *
374      * If `target` reverts with a revert reason, it is bubbled up by this
375      * function (like regular Solidity function calls).
376      *
377      * Returns the raw returned data. To convert to the expected return value,
378      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
379      *
380      * Requirements:
381      *
382      * - `target` must be a contract.
383      * - calling `target` with `data` must not revert.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
388       return functionCall(target, data, "Address: low-level call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
393      * `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, 0, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but also transferring `value` wei to `target`.
404      *
405      * Requirements:
406      *
407      * - the calling contract must have an ETH balance of at least `value`.
408      * - the called Solidity function must be `payable`.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
418      * with `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
423         require(address(this).balance >= value, "Address: insufficient balance for call");
424         require(isContract(target), "Address: call to non-contract");
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = target.call{ value: value }(data);
428         return _verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
438         return functionStaticCall(target, data, "Address: low-level static call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
448         require(isContract(target), "Address: static call to non-contract");
449 
450         // solhint-disable-next-line avoid-low-level-calls
451         (bool success, bytes memory returndata) = target.staticcall(data);
452         return _verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
456         if (success) {
457             return returndata;
458         } else {
459             // Look for revert reason and bubble it up if present
460             if (returndata.length > 0) {
461                 // The easiest way to bubble the revert reason is using memory via assembly
462 
463                 // solhint-disable-next-line no-inline-assembly
464                 assembly {
465                     let returndata_size := mload(returndata)
466                     revert(add(32, returndata), returndata_size)
467                 }
468             } else {
469                 revert(errorMessage);
470             }
471         }
472     }
473 }
474 
475 pragma solidity >=0.6.0 <0.8.0;
476 
477 
478 
479 /**
480  * @title SafeERC20
481  * @dev Wrappers around ERC20 operations that throw on failure (when the token
482  * contract returns false). Tokens that return no value (and instead revert or
483  * throw on failure) are also supported, non-reverting calls are assumed to be
484  * successful.
485  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
486  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
487  */
488 library SafeERC20 {
489     using SafeMath for uint256;
490     using Address for address;
491 
492     function safeTransfer(IERC20 token, address to, uint256 value) internal {
493         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
494     }
495 
496     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
497         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
498     }
499 
500     /**
501      * @dev Deprecated. This function has issues similar to the ones found in
502      * {IERC20-approve}, and its usage is discouraged.
503      *
504      * Whenever possible, use {safeIncreaseAllowance} and
505      * {safeDecreaseAllowance} instead.
506      */
507     function safeApprove(IERC20 token, address spender, uint256 value) internal {
508         // safeApprove should only be called when setting an initial allowance,
509         // or when resetting it to zero. To increase and decrease it, use
510         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
511         // solhint-disable-next-line max-line-length
512         require((value == 0) || (token.allowance(address(this), spender) == 0),
513             "SafeERC20: approve from non-zero to non-zero allowance"
514         );
515         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
516     }
517 
518     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
519         uint256 newAllowance = token.allowance(address(this), spender).add(value);
520         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
521     }
522 
523     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
524         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
525         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
526     }
527 
528     /**
529      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
530      * on the return value: the return value is optional (but if data is returned, it must not be false).
531      * @param token The token targeted by the call.
532      * @param data The call data (encoded using abi.encode or one of its variants).
533      */
534     function _callOptionalReturn(IERC20 token, bytes memory data) private {
535         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
536         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
537         // the target address contains contract code and also asserts for success in the low-level call.
538 
539         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
540         if (returndata.length > 0) { // Return data is optional
541             // solhint-disable-next-line max-line-length
542             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
543         }
544     }
545 }
546 
547 
548 pragma solidity 0.7.6;
549 
550 /**
551  * @dev Contract module that helps prevent reentrant calls to a function.
552  *
553  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
554  * available, which can be applied to functions to make sure there are no nested
555  * (reentrant) calls to them.
556  *
557  * Note that because there is a single `nonReentrant` guard, functions marked as
558  * `nonReentrant` may not call one another. This can be worked around by making
559  * those functions `private`, and then adding `external` `nonReentrant` entry
560  * points to them.
561  *
562  * TIP: If you would like to learn more about reentrancy and alternative ways
563  * to protect against it, check out our blog post
564  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
565  */
566 contract ReentrancyGuard {
567     // Booleans are more expensive than uint256 or any type that takes up a full
568     // word because each write operation emits an extra SLOAD to first read the
569     // slot's contents, replace the bits taken up by the boolean, and then write
570     // back. This is the compiler's defense against contract upgrades and
571     // pointer aliasing, and it cannot be disabled.
572 
573     // The values being non-zero value makes deployment a bit more expensive,
574     // but in exchange the refund on every call to nonReentrant will be lower in
575     // amount. Since refunds are capped to a percentage of the total
576     // transaction's gas, it is best to keep them low in cases like this one, to
577     // increase the likelihood of the full refund coming into effect.
578     uint256 private constant _NOT_ENTERED = 1;
579     uint256 private constant _ENTERED = 2;
580 
581     uint256 private _status;
582 
583     constructor() {
584         _status = _NOT_ENTERED;
585     }
586 
587     /**
588      * @dev Prevents a contract from calling itself, directly or indirectly.
589      * Calling a `nonReentrant` function from another `nonReentrant`
590      * function is not supported. It is possible to prevent this from happening
591      * by making the `nonReentrant` function external, and make it call a
592      * `private` function that does the actual work.
593      */
594     modifier nonReentrant() {
595         // On the first call to nonReentrant, _notEntered will be true
596         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
597 
598         // Any calls to nonReentrant after this point will fail
599         _status = _ENTERED;
600 
601         _;
602 
603         // By storing the original value once again, a refund is triggered (see
604         // https://eips.ethereum.org/EIPS/eip-2200)
605         _status = _NOT_ENTERED;
606     }
607 }
608 
609 pragma solidity 0.7.6;
610 
611 // import "../GSN/Context.sol";
612 
613 /**
614  * @dev Contract module which allows children to implement an emergency stop
615  * mechanism that can be triggered by an authorized account.
616  *
617  * This module is used through inheritance. It will make available the
618  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
619  * the functions of your contract. Note that they will not be pausable by
620  * simply including this module, only once the modifiers are put in place.
621  */
622 abstract contract Pausable {
623     /**
624      * @dev Emitted when the pause is triggered by `account`.
625      */
626     event Paused(address account);
627 
628     /**
629      * @dev Emitted when the pause is lifted by `account`.
630      */
631     event Unpaused(address account);
632 
633     event PauserChanged(
634         address indexed previousPauser,
635         address indexed newPauser
636     );
637 
638     bool private _paused;
639     address private _pauser;
640 
641     /**
642      * @dev The pausable constructor sets the original `pauser` of the contract to the sender
643      * account & Initializes the contract in unpaused state..
644      */
645     constructor(address pauser) {
646         require(pauser != address(0), "Pauser Address cannot be 0");
647         _pauser = pauser;
648         _paused = false;
649     }
650 
651     /**
652      * @dev Throws if called by any account other than the pauser.
653      */
654     modifier onlyPauser() {
655         require(
656             isPauser(),
657             "Only pauser is allowed to perform this operation"
658         );
659         _;
660     }
661 
662     /**
663      * @dev Modifier to make a function callable only when the contract is not paused.
664      *
665      * Requirements:
666      *
667      * - The contract must not be paused.
668      */
669     modifier whenNotPaused() {
670         require(!_paused, "Pausable: paused");
671         _;
672     }
673 
674     /**
675      * @dev Modifier to make a function callable only when the contract is paused.
676      *
677      * Requirements:
678      *
679      * - The contract must be paused.
680      */
681     modifier whenPaused() {
682         require(_paused, "Pausable: not paused");
683         _;
684     }
685 
686     /**
687      * @return the address of the owner.
688      */
689     function getPauser() public view returns (address) {
690         return _pauser;
691     }
692 
693     /**
694      * @return true if `msg.sender` is the owner of the contract.
695      */
696     function isPauser() public view returns (bool) {
697         return msg.sender == _pauser;
698     }
699 
700     /**
701      * @dev Returns true if the contract is paused, and false otherwise.
702      */
703     function isPaused() public view returns (bool) {
704         return _paused;
705     }
706 
707     /**
708      * @dev Allows the current pauser to transfer control of the contract to a newPauser.
709      * @param newPauser The address to transfer pauserShip to.
710      */
711     function changePauser(address newPauser) public onlyPauser {
712         _changePauser(newPauser);
713     }
714 
715     /**
716      * @dev Transfers control of the contract to a newPauser.
717      * @param newPauser The address to transfer ownership to.
718      */
719     function _changePauser(address newPauser) internal {
720         require(newPauser != address(0));
721         emit PauserChanged(_pauser, newPauser);
722         _pauser = newPauser;
723     }
724 
725     function renouncePauser() external virtual onlyPauser {
726         emit PauserChanged(_pauser, address(0));
727         _pauser = address(0);
728     }
729     
730     /**
731      * @dev Triggers stopped state.
732      *
733      * Requirements:
734      *
735      * - The contract must not be paused.
736      */
737     function pause() public onlyPauser whenNotPaused {
738         _paused = true;
739         emit Paused(_pauser);
740     }
741 
742     /**
743      * @dev Returns to normal state.
744      *
745      * Requirements:
746      *
747      * - The contract must be paused.
748      */
749     function unpause() public onlyPauser whenPaused {
750         _paused = false;
751         emit Unpaused(_pauser);
752     }
753 }
754 
755 
756 pragma solidity 0.7.6;
757 
758 /**
759  * @title Ownable
760  * @dev The Ownable contract has an owner address, and provides basic authorization control
761  * functions, this simplifies the implementation of "user permissions".
762  */
763 abstract contract Ownable {
764     address private _owner;
765 
766     event OwnershipTransferred(
767         address indexed previousOwner,
768         address indexed newOwner
769     );
770 
771     /**
772      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
773      * account.
774      */
775     constructor(address owner) {
776         require(owner != address(0), "Owner Address cannot be 0");
777         _owner = owner;
778     }
779 
780     /**
781      * @dev Throws if called by any account other than the owner.
782      */
783     modifier onlyOwner() {
784         require(
785             isOwner(),
786             "Only contract owner is allowed to perform this operation"
787         );
788         _;
789     }
790 
791     /**
792      * @return the address of the owner.
793      */
794     function getOwner() public view returns (address) {
795         return _owner;
796     }
797 
798     /**
799      * @return true if `msg.sender` is the owner of the contract.
800      */
801     function isOwner() public view returns (bool) {
802         return msg.sender == _owner;
803     }
804 
805     /**
806      * @dev Allows the current owner to relinquish control of the contract.
807      * @notice Renouncing to ownership will leave the contract without an owner.
808      * It will not be possible to call the functions with the `onlyOwner`
809      * modifier anymore.
810      */
811     function renounceOwnership() external virtual onlyOwner {
812         emit OwnershipTransferred(_owner, address(0));
813         _owner = address(0);
814     }
815 
816     /**
817      * @dev Allows the current owner to transfer control of the contract to a newOwner.
818      * @param newOwner The address to transfer ownership to.
819      */
820     function transferOwnership(address newOwner) public onlyOwner {
821         _transferOwnership(newOwner);
822     }
823 
824     /**
825      * @dev Transfers control of the contract to a newOwner.
826      * @param newOwner The address to transfer ownership to.
827      */
828     function _transferOwnership(address newOwner) internal {
829         require(newOwner != address(0));
830         emit OwnershipTransferred(_owner, newOwner);
831         _owner = newOwner;
832     }
833 }
834 
835 
836 pragma solidity 0.7.6;
837 
838 contract ExecutorManager is Ownable {
839     address[] internal executors;
840     mapping(address => bool) internal executorStatus;
841 
842     event ExecutorAdded(address executor, address owner);
843     event ExecutorRemoved(address executor, address owner);
844 
845     // MODIFIERS
846     modifier onlyExecutor() {
847         require(
848             executorStatus[msg.sender],
849             "You are not allowed to perform this operation"
850         );
851         _;
852     }
853 
854     constructor(address owner) Ownable(owner) {
855         require( owner != address(0), "owner cannot be zero");
856     }
857 
858     function renounceOwnership() external override onlyOwner {
859         revert ("can't renounceOwnership here"); // not possible within this smart contract
860     }
861     
862     function getExecutorStatus(address executor)
863         public
864         view
865         returns (bool status)
866     {
867         status = executorStatus[executor];
868     }
869 
870     function getAllExecutors() public view returns (address[] memory) {
871         return executors;
872     }
873 
874     //Register new Executors
875     function addExecutors(address[] calldata executorArray) external onlyOwner {
876         for (uint256 i = 0; i < executorArray.length; i++) {
877             addExecutor(executorArray[i]);
878         }
879     }
880 
881     // Register single executor
882     function addExecutor(address executorAddress) public onlyOwner {
883         require(executorAddress != address(0), "executor address can not be 0");
884         executors.push(executorAddress);
885         executorStatus[executorAddress] = true;
886         emit ExecutorAdded(executorAddress, msg.sender);
887     }
888 
889     //Remove registered Executors
890     function removeExecutors(address[] calldata executorArray) external onlyOwner {
891         for (uint256 i = 0; i < executorArray.length; i++) {
892             removeExecutor(executorArray[i]);
893         }
894     }
895 
896     // Remove Register single executor
897     function removeExecutor(address executorAddress) public onlyOwner {
898         require(executorAddress != address(0), "executor address can not be 0");
899         executorStatus[executorAddress] = false;
900         emit ExecutorRemoved(executorAddress, msg.sender);
901     }
902 }
903 
904 pragma solidity 0.7.6;
905 
906 interface IERC20Detailed is IERC20 {
907   function name() external view returns(string memory);
908   function decimals() external view returns(uint256);
909 }
910 
911 interface IERC20Nonces is IERC20Detailed {
912   function nonces(address holder) external view returns(uint);
913 }
914 
915 interface IERC20Permit is IERC20Nonces {
916   function permit(address holder, address spender, uint256 nonce, uint256 expiry,
917                   bool allowed, uint8 v, bytes32 r, bytes32 s) external;
918 
919   function permit(address holder, address spender, uint256 value, uint256 expiry,
920                   uint8 v, bytes32 r, bytes32 s) external;
921 }
922 
923 
924 pragma solidity 0.7.6;
925 pragma abicoder v2;
926 
927 
928 
929 
930 
931 
932 
933 
934 contract LiquidityPoolManager is ReentrancyGuard, Ownable, BaseRelayRecipient, Pausable {
935     using SafeMath for uint256;
936 
937     address private constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
938     uint256 public baseGas;
939     
940     ExecutorManager private executorManager;
941     uint256 public adminFee;
942 
943     struct TokenInfo {
944         uint256 transferOverhead;
945         bool supportedToken;
946         uint256 minCap;
947         uint256 maxCap;
948         uint256 liquidity;
949         mapping(address => uint256) liquidityProvider;
950     }
951 
952      struct PermitRequest {
953         uint256 nonce;
954         uint256 expiry;
955         bool allowed; 
956         uint8 v;
957         bytes32 r; 
958         bytes32 s; 
959     }
960 
961     mapping ( address => TokenInfo ) public tokensInfo;
962     mapping ( bytes32 => bool ) public processedHash;
963 
964     event AssetSent(address indexed asset, uint256 indexed amount, uint256 indexed transferredAmount, address target, bytes depositHash);
965     event Received(address indexed from, uint256 indexed amount);
966     event Deposit(address indexed from, address indexed tokenAddress, address indexed receiver, uint256 toChainId, uint256 amount);
967     event LiquidityAdded(address indexed from, address indexed tokenAddress, address indexed receiver, uint256 amount);
968     event LiquidityRemoved(address indexed tokenAddress, uint256 indexed amount, address indexed sender);
969     event fundsWithdraw(address indexed tokenAddress, address indexed owner,  uint256 indexed amount);
970     event AdminFeeChanged(uint256 indexed newAdminFee);
971     event TrustedForwarderChanged(address indexed forwarderAddress);
972 
973     // MODIFIERS
974     modifier onlyExecutor() {
975         require(executorManager.getExecutorStatus(_msgSender()),
976             "You are not allowed to perform this operation"
977         );
978         _;
979     }
980 
981     modifier tokenChecks(address tokenAddress){
982         require(tokenAddress != address(0), "Token address cannot be 0");
983         require(tokensInfo[tokenAddress].supportedToken, "Token not supported");
984 
985         _;
986     }
987 
988     constructor(address _executorManagerAddress, address owner, address pauser, address _trustedForwarder, uint256 _adminFee) Ownable(owner) Pausable(pauser) {
989         require(_executorManagerAddress != address(0), "ExecutorManager Contract Address cannot be 0");
990         require(_trustedForwarder != address(0), "TrustedForwarder Contract Address cannot be 0");
991         require(_adminFee != 0, "AdminFee cannot be 0");
992         executorManager = ExecutorManager(_executorManagerAddress);
993         trustedForwarder = _trustedForwarder;
994         adminFee = _adminFee;
995         baseGas = 21000;
996     }
997 
998     function renounceOwnership() external override onlyOwner {
999         revert ("can't renounceOwnership here"); // not possible within this smart contract
1000     }
1001 
1002     function renouncePauser() external override onlyPauser {
1003         revert ("can't renouncePauser here"); // not possible within this smart contract
1004     }
1005 
1006     function getAdminFee() public view returns (uint256 ) {
1007         return adminFee;
1008     }
1009 
1010     function changeAdminFee(uint256 newAdminFee) external onlyOwner whenNotPaused {
1011         require(newAdminFee != 0, "Admin Fee cannot be 0");
1012         adminFee = newAdminFee;
1013         emit AdminFeeChanged(newAdminFee);
1014     }
1015 
1016     function versionRecipient() external override virtual view returns (string memory){
1017         return "1";
1018     }
1019 
1020     function setBaseGas(uint128 gas) external onlyOwner{
1021         baseGas = gas;
1022     }
1023 
1024     function getExecutorManager() public view returns (address){
1025         return address(executorManager);
1026     }
1027 
1028     function setExecutorManager(address _executorManagerAddress) external onlyOwner {
1029         require(_executorManagerAddress != address(0), "Executor Manager Address cannot be 0");
1030         executorManager = ExecutorManager(_executorManagerAddress);
1031     }
1032 
1033     function setTrustedForwarder( address forwarderAddress ) external onlyOwner {
1034         require(forwarderAddress != address(0), "Forwarder Address cannot be 0");
1035         trustedForwarder = forwarderAddress;
1036         emit TrustedForwarderChanged(forwarderAddress);
1037     }
1038 
1039     function setTokenTransferOverhead( address tokenAddress, uint256 gasOverhead ) external tokenChecks(tokenAddress) onlyOwner {
1040         tokensInfo[tokenAddress].transferOverhead = gasOverhead;
1041     }
1042 
1043     function addSupportedToken( address tokenAddress, uint256 minCapLimit, uint256 maxCapLimit ) external onlyOwner {
1044         require(tokenAddress != address(0), "Token address cannot be 0");  
1045         require(maxCapLimit > minCapLimit, "maxCapLimit cannot be smaller than minCapLimit");        
1046         tokensInfo[tokenAddress].supportedToken = true;
1047         tokensInfo[tokenAddress].minCap = minCapLimit;
1048         tokensInfo[tokenAddress].maxCap = maxCapLimit;
1049     }
1050 
1051     function removeSupportedToken( address tokenAddress ) external tokenChecks(tokenAddress) onlyOwner {
1052         tokensInfo[tokenAddress].supportedToken = false;
1053     }
1054 
1055     function updateTokenCap( address tokenAddress, uint256 minCapLimit, uint256 maxCapLimit ) external tokenChecks(tokenAddress) onlyOwner {
1056         require(maxCapLimit > minCapLimit, "maxCapLimit cannot be smaller than minCapLimit");                
1057         tokensInfo[tokenAddress].minCap = minCapLimit;        
1058         tokensInfo[tokenAddress].maxCap = maxCapLimit;
1059     }
1060 
1061     function addNativeLiquidity() external payable whenNotPaused {
1062         require(msg.value != 0, "Amount cannot be 0");
1063         address payable sender = _msgSender();
1064         tokensInfo[NATIVE].liquidityProvider[sender] = tokensInfo[NATIVE].liquidityProvider[sender].add(msg.value);
1065         tokensInfo[NATIVE].liquidity = tokensInfo[NATIVE].liquidity.add(msg.value);
1066 
1067         emit LiquidityAdded(sender, NATIVE, address(this), msg.value);
1068     }
1069 
1070     function removeNativeLiquidity(uint256 amount) external whenNotPaused nonReentrant {
1071         require(amount != 0 , "Amount cannot be 0");
1072         address payable sender = _msgSender();
1073         require(tokensInfo[NATIVE].liquidityProvider[sender] >= amount, "Not enough balance");
1074         tokensInfo[NATIVE].liquidityProvider[sender] = tokensInfo[NATIVE].liquidityProvider[sender].sub(amount);
1075         tokensInfo[NATIVE].liquidity = tokensInfo[NATIVE].liquidity.sub(amount);
1076         
1077         (bool success, ) = sender.call{ value: amount }("");
1078         require(success, "Native Transfer Failed");
1079 
1080         emit LiquidityRemoved( NATIVE, amount, sender);
1081     }
1082 
1083     function addTokenLiquidity( address tokenAddress, uint256 amount ) external tokenChecks(tokenAddress) whenNotPaused {
1084         require(amount != 0, "Amount cannot be 0");
1085         address payable sender = _msgSender();
1086         tokensInfo[tokenAddress].liquidityProvider[sender] = tokensInfo[tokenAddress].liquidityProvider[sender].add(amount);
1087         tokensInfo[tokenAddress].liquidity = tokensInfo[tokenAddress].liquidity.add(amount);
1088         
1089         SafeERC20.safeTransferFrom(IERC20(tokenAddress), sender, address(this), amount);
1090         emit LiquidityAdded(sender, tokenAddress, address(this), amount);
1091     }
1092 
1093     function removeTokenLiquidity( address tokenAddress, uint256 amount ) external tokenChecks(tokenAddress) whenNotPaused {
1094         require(amount != 0, "Amount cannot be 0");
1095         address payable sender = _msgSender();
1096         require(tokensInfo[tokenAddress].liquidityProvider[sender] >= amount, "Not enough balance");
1097 
1098         tokensInfo[tokenAddress].liquidityProvider[sender] = tokensInfo[tokenAddress].liquidityProvider[sender].sub(amount);
1099         tokensInfo[tokenAddress].liquidity = tokensInfo[tokenAddress].liquidity.sub(amount);
1100 
1101         SafeERC20.safeTransfer(IERC20(tokenAddress), sender, amount);
1102         emit LiquidityRemoved( tokenAddress, amount, sender);
1103 
1104     }
1105 
1106     function getLiquidity(address liquidityProviderAddress, address tokenAddress) public view returns (uint256 ) {
1107         return tokensInfo[tokenAddress].liquidityProvider[liquidityProviderAddress];
1108     }
1109 
1110     function depositErc20( address tokenAddress, address receiver, uint256 amount, uint256 toChainId ) public tokenChecks(tokenAddress) whenNotPaused {
1111         require(tokensInfo[tokenAddress].minCap <= amount && tokensInfo[tokenAddress].maxCap >= amount, "Deposit amount should be within allowed Cap limits");
1112         require(receiver != address(0), "Receiver address cannot be 0");
1113         require(amount != 0, "Amount cannot be 0");
1114 
1115         address payable sender = _msgSender();
1116 
1117         SafeERC20.safeTransferFrom(IERC20(tokenAddress), sender, address(this),amount);
1118         emit Deposit(sender, tokenAddress, receiver, toChainId, amount);
1119     }
1120 
1121     /** 
1122      * DAI permit and Deposit.
1123      */
1124     function permitAndDepositErc20(
1125         address tokenAddress,
1126         address receiver,
1127         uint256 amount,
1128         uint256 toChainId,
1129         PermitRequest calldata permitOptions
1130         )
1131         external {
1132             IERC20Permit(tokenAddress).permit(_msgSender(), address(this), permitOptions.nonce, permitOptions.expiry, permitOptions.allowed, permitOptions.v, permitOptions.r, permitOptions.s);
1133             depositErc20(tokenAddress, receiver, amount, toChainId);
1134     }
1135 
1136     /** 
1137      * EIP2612 and Deposit.
1138      */
1139     function permitEIP2612AndDepositErc20(
1140         address tokenAddress,
1141         address receiver,
1142         uint256 amount,
1143         uint256 toChainId,
1144         PermitRequest calldata permitOptions
1145         )
1146         external {
1147             IERC20Permit(tokenAddress).permit(_msgSender(), address(this), amount, permitOptions.expiry, permitOptions.v, permitOptions.r, permitOptions.s);
1148             depositErc20(tokenAddress, receiver, amount, toChainId);            
1149     }
1150 
1151     function depositNative( address receiver, uint256 toChainId ) external whenNotPaused payable {
1152         require(tokensInfo[NATIVE].minCap <= msg.value && tokensInfo[NATIVE].maxCap >= msg.value, "Deposit amount should be within allowed Cap limit");
1153         require(receiver != address(0), "Receiver address cannot be 0");
1154         require(msg.value != 0, "Amount cannot be 0");
1155 
1156         emit Deposit(_msgSender(), NATIVE, receiver, toChainId, msg.value);
1157     }
1158 
1159     function sendFundsToUser( address tokenAddress, uint256 amount, address payable receiver, bytes memory depositHash, uint256 tokenGasPrice ) external nonReentrant onlyExecutor tokenChecks(tokenAddress) whenNotPaused {
1160         uint256 initialGas = gasleft();
1161         require(tokensInfo[tokenAddress].minCap <= amount && tokensInfo[tokenAddress].maxCap >= amount, "Withdraw amount should be within allowed Cap limits");
1162         require(receiver != address(0), "Bad receiver address");
1163         
1164         (bytes32 hashSendTransaction, bool status) = checkHashStatus(tokenAddress, amount, receiver, depositHash);
1165 
1166         require(!status, "Already Processed");
1167         processedHash[hashSendTransaction] = true;
1168 
1169         uint256 calculateAdminFee = amount.mul(adminFee).div(10000);
1170 
1171         uint256 totalGasUsed = (initialGas.sub(gasleft())).add(tokensInfo[tokenAddress].transferOverhead).add(baseGas);
1172 
1173         uint256 gasFeeInToken = totalGasUsed.mul(tokenGasPrice);
1174         uint256 amountToTransfer = amount.sub(calculateAdminFee.add(gasFeeInToken));
1175 
1176         if (tokenAddress == NATIVE) {
1177             require(address(this).balance >= amountToTransfer, "Not Enough Balance");
1178             (bool success, ) = receiver.call{ value: amountToTransfer }("");
1179             require(success, "Native Transfer Failed");
1180         } else {
1181             require(IERC20(tokenAddress).balanceOf(address(this)) >= amountToTransfer, "Not Enough Balance");
1182             SafeERC20.safeTransfer(IERC20(tokenAddress), receiver, amountToTransfer);
1183         }
1184 
1185         emit AssetSent(tokenAddress, amount, amountToTransfer, receiver, depositHash);
1186     }
1187 
1188     function checkHashStatus(address tokenAddress, uint256 amount, address payable receiver, bytes memory depositHash) public view returns(bytes32 hashSendTransaction, bool status){
1189         hashSendTransaction = keccak256(
1190             abi.encode(
1191                 tokenAddress,
1192                 amount,
1193                 receiver,
1194                 keccak256(depositHash)
1195             )
1196         );
1197 
1198         status = processedHash[hashSendTransaction];
1199     }
1200 
1201     function withdrawErc20(address tokenAddress) external onlyOwner whenNotPaused {
1202         uint256 profitEarned = (IERC20(tokenAddress).balanceOf(address(this))).sub(tokensInfo[tokenAddress].liquidity);
1203         require(profitEarned != 0, "Profit earned is 0");
1204         address payable sender = _msgSender();
1205 
1206         SafeERC20.safeTransfer(IERC20(tokenAddress), sender, profitEarned);
1207 
1208         emit fundsWithdraw(tokenAddress, sender,  profitEarned);
1209     }
1210 
1211     function withdrawNative() external onlyOwner whenNotPaused {
1212         uint256 profitEarned = (address(this).balance).sub(tokensInfo[NATIVE].liquidity);
1213         require(profitEarned != 0, "Profit earned is 0");
1214         address payable sender = _msgSender();
1215         (bool success, ) = sender.call{ value: profitEarned }("");
1216         require(success, "Native Transfer Failed");
1217         
1218         emit fundsWithdraw(address(this), sender, profitEarned);
1219     }
1220 }