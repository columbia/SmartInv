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
161 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
162 
163 pragma solidity >=0.6.2 <0.8.0;
164 
165 /**
166  * @dev Collection of functions related to the address type
167  */
168 library Address {
169     /**
170      * @dev Returns true if `account` is a contract.
171      *
172      * [IMPORTANT]
173      * ====
174      * It is unsafe to assume that an address for which this function returns
175      * false is an externally-owned account (EOA) and not a contract.
176      *
177      * Among others, `isContract` will return false for the following
178      * types of addresses:
179      *
180      *  - an externally-owned account
181      *  - a contract in construction
182      *  - an address where a contract will be created
183      *  - an address where a contract lived, but was destroyed
184      * ====
185      */
186     function isContract(address account) internal view returns (bool) {
187         // This method relies on extcodesize, which returns 0 for contracts in
188         // construction, since the code is only stored at the end of the
189         // constructor execution.
190 
191         uint256 size;
192         // solhint-disable-next-line no-inline-assembly
193         assembly { size := extcodesize(account) }
194         return size > 0;
195     }
196 
197     /**
198      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
199      * `recipient`, forwarding all available gas and reverting on errors.
200      *
201      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
202      * of certain opcodes, possibly making contracts go over the 2300 gas limit
203      * imposed by `transfer`, making them unable to receive funds via
204      * `transfer`. {sendValue} removes this limitation.
205      *
206      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
207      *
208      * IMPORTANT: because control is transferred to `recipient`, care must be
209      * taken to not create reentrancy vulnerabilities. Consider using
210      * {ReentrancyGuard} or the
211      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
212      */
213     function sendValue(address payable recipient, uint256 amount) internal {
214         require(address(this).balance >= amount, "Address: insufficient balance");
215 
216         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
217         (bool success, ) = recipient.call{ value: amount }("");
218         require(success, "Address: unable to send value, recipient may have reverted");
219     }
220 
221     /**
222      * @dev Performs a Solidity function call using a low level `call`. A
223      * plain`call` is an unsafe replacement for a function call: use this
224      * function instead.
225      *
226      * If `target` reverts with a revert reason, it is bubbled up by this
227      * function (like regular Solidity function calls).
228      *
229      * Returns the raw returned data. To convert to the expected return value,
230      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
231      *
232      * Requirements:
233      *
234      * - `target` must be a contract.
235      * - calling `target` with `data` must not revert.
236      *
237      * _Available since v3.1._
238      */
239     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
240       return functionCall(target, data, "Address: low-level call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
245      * `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
250         return functionCallWithValue(target, data, 0, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but also transferring `value` wei to `target`.
256      *
257      * Requirements:
258      *
259      * - the calling contract must have an ETH balance of at least `value`.
260      * - the called Solidity function must be `payable`.
261      *
262      * _Available since v3.1._
263      */
264     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
270      * with `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
275         require(address(this).balance >= value, "Address: insufficient balance for call");
276         require(isContract(target), "Address: call to non-contract");
277 
278         // solhint-disable-next-line avoid-low-level-calls
279         (bool success, bytes memory returndata) = target.call{ value: value }(data);
280         return _verifyCallResult(success, returndata, errorMessage);
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
285      * but performing a static call.
286      *
287      * _Available since v3.3._
288      */
289     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
290         return functionStaticCall(target, data, "Address: low-level static call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
295      * but performing a static call.
296      *
297      * _Available since v3.3._
298      */
299     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
300         require(isContract(target), "Address: static call to non-contract");
301 
302         // solhint-disable-next-line avoid-low-level-calls
303         (bool success, bytes memory returndata) = target.staticcall(data);
304         return _verifyCallResult(success, returndata, errorMessage);
305     }
306 
307     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
308         if (success) {
309             return returndata;
310         } else {
311             // Look for revert reason and bubble it up if present
312             if (returndata.length > 0) {
313                 // The easiest way to bubble the revert reason is using memory via assembly
314 
315                 // solhint-disable-next-line no-inline-assembly
316                 assembly {
317                     let returndata_size := mload(returndata)
318                     revert(add(32, returndata), returndata_size)
319                 }
320             } else {
321                 revert(errorMessage);
322             }
323         }
324     }
325 }
326 
327 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
328 
329 pragma solidity >=0.6.0 <0.8.0;
330 
331 
332 
333 
334 /**
335  * @title SafeERC20
336  * @dev Wrappers around ERC20 operations that throw on failure (when the token
337  * contract returns false). Tokens that return no value (and instead revert or
338  * throw on failure) are also supported, non-reverting calls are assumed to be
339  * successful.
340  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
341  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
342  */
343 library SafeERC20 {
344     using SafeMath for uint256;
345     using Address for address;
346 
347     function safeTransfer(IERC20 token, address to, uint256 value) internal {
348         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
349     }
350 
351     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
352         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
353     }
354 
355     /**
356      * @dev Deprecated. This function has issues similar to the ones found in
357      * {IERC20-approve}, and its usage is discouraged.
358      *
359      * Whenever possible, use {safeIncreaseAllowance} and
360      * {safeDecreaseAllowance} instead.
361      */
362     function safeApprove(IERC20 token, address spender, uint256 value) internal {
363         // safeApprove should only be called when setting an initial allowance,
364         // or when resetting it to zero. To increase and decrease it, use
365         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
366         // solhint-disable-next-line max-line-length
367         require((value == 0) || (token.allowance(address(this), spender) == 0),
368             "SafeERC20: approve from non-zero to non-zero allowance"
369         );
370         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
371     }
372 
373     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
374         uint256 newAllowance = token.allowance(address(this), spender).add(value);
375         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
376     }
377 
378     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
379         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
380         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
381     }
382 
383     /**
384      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
385      * on the return value: the return value is optional (but if data is returned, it must not be false).
386      * @param token The token targeted by the call.
387      * @param data The call data (encoded using abi.encode or one of its variants).
388      */
389     function _callOptionalReturn(IERC20 token, bytes memory data) private {
390         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
391         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
392         // the target address contains contract code and also asserts for success in the low-level call.
393 
394         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
395         if (returndata.length > 0) { // Return data is optional
396             // solhint-disable-next-line max-line-length
397             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
398         }
399     }
400 }
401 
402 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
403 
404 pragma solidity >=0.6.0 <0.8.0;
405 
406 /**
407  * @dev Interface of the ERC20 standard as defined in the EIP.
408  */
409 interface IERC20 {
410     /**
411      * @dev Returns the amount of tokens in existence.
412      */
413     function totalSupply() external view returns (uint256);
414 
415     /**
416      * @dev Returns the amount of tokens owned by `account`.
417      */
418     function balanceOf(address account) external view returns (uint256);
419 
420     /**
421      * @dev Moves `amount` tokens from the caller's account to `recipient`.
422      *
423      * Returns a boolean value indicating whether the operation succeeded.
424      *
425      * Emits a {Transfer} event.
426      */
427     function transfer(address recipient, uint256 amount) external returns (bool);
428 
429     /**
430      * @dev Returns the remaining number of tokens that `spender` will be
431      * allowed to spend on behalf of `owner` through {transferFrom}. This is
432      * zero by default.
433      *
434      * This value changes when {approve} or {transferFrom} are called.
435      */
436     function allowance(address owner, address spender) external view returns (uint256);
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
440      *
441      * Returns a boolean value indicating whether the operation succeeded.
442      *
443      * IMPORTANT: Beware that changing an allowance with this method brings the risk
444      * that someone may use both the old and the new allowance by unfortunate
445      * transaction ordering. One possible solution to mitigate this race
446      * condition is to first reduce the spender's allowance to 0 and set the
447      * desired value afterwards:
448      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
449      *
450      * Emits an {Approval} event.
451      */
452     function approve(address spender, uint256 amount) external returns (bool);
453 
454     /**
455      * @dev Moves `amount` tokens from `sender` to `recipient` using the
456      * allowance mechanism. `amount` is then deducted from the caller's
457      * allowance.
458      *
459      * Returns a boolean value indicating whether the operation succeeded.
460      *
461      * Emits a {Transfer} event.
462      */
463     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
464 
465     /**
466      * @dev Emitted when `value` tokens are moved from one account (`from`) to
467      * another (`to`).
468      *
469      * Note that `value` may be zero.
470      */
471     event Transfer(address indexed from, address indexed to, uint256 value);
472 
473     /**
474      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
475      * a call to {approve}. `value` is the new allowance.
476      */
477     event Approval(address indexed owner, address indexed spender, uint256 value);
478 }
479 
480 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
481 
482 pragma solidity >=0.6.0 <0.8.0;
483 
484 /*
485  * @dev Provides information about the current execution context, including the
486  * sender of the transaction and its data. While these are generally available
487  * via msg.sender and msg.data, they should not be accessed in such a direct
488  * manner, since when dealing with GSN meta-transactions the account sending and
489  * paying for execution may not be the actual sender (as far as an application
490  * is concerned).
491  *
492  * This contract is only required for intermediate, library-like contracts.
493  */
494 abstract contract Context {
495     function _msgSender() internal view virtual returns (address payable) {
496         return msg.sender;
497     }
498 
499     function _msgData() internal view virtual returns (bytes memory) {
500         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
501         return msg.data;
502     }
503 }
504 
505 // File: @openzeppelin\contracts\access\Ownable.sol
506 
507 pragma solidity >=0.6.0 <0.8.0;
508 
509 /**
510  * @dev Contract module which provides a basic access control mechanism, where
511  * there is an account (an owner) that can be granted exclusive access to
512  * specific functions.
513  *
514  * By default, the owner account will be the one that deploys the contract. This
515  * can later be changed with {transferOwnership}.
516  *
517  * This module is used through inheritance. It will make available the modifier
518  * `onlyOwner`, which can be applied to your functions to restrict their use to
519  * the owner.
520  */
521 abstract contract Ownable is Context {
522     address private _owner;
523 
524     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
525 
526     /**
527      * @dev Initializes the contract setting the deployer as the initial owner.
528      */
529     constructor () internal {
530         address msgSender = _msgSender();
531         _owner = msgSender;
532         emit OwnershipTransferred(address(0), msgSender);
533     }
534 
535     /**
536      * @dev Returns the address of the current owner.
537      */
538     function owner() public view returns (address) {
539         return _owner;
540     }
541 
542     /**
543      * @dev Throws if called by any account other than the owner.
544      */
545     modifier onlyOwner() {
546         require(_owner == _msgSender(), "Ownable: caller is not the owner");
547         _;
548     }
549 
550     /**
551      * @dev Leaves the contract without owner. It will not be possible to call
552      * `onlyOwner` functions anymore. Can only be called by the current owner.
553      *
554      * NOTE: Renouncing ownership will leave the contract without an owner,
555      * thereby removing any functionality that is only available to the owner.
556      */
557     function renounceOwnership() public virtual onlyOwner {
558         emit OwnershipTransferred(_owner, address(0));
559         _owner = address(0);
560     }
561 
562     /**
563      * @dev Transfers ownership of the contract to a new account (`newOwner`).
564      * Can only be called by the current owner.
565      */
566     function transferOwnership(address newOwner) public virtual onlyOwner {
567         require(newOwner != address(0), "Ownable: new owner is the zero address");
568         emit OwnershipTransferred(_owner, newOwner);
569         _owner = newOwner;
570     }
571 }
572 
573 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
574 
575 pragma solidity >=0.6.0 <0.8.0;
576 
577 /**
578  * @dev Contract module that helps prevent reentrant calls to a function.
579  *
580  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
581  * available, which can be applied to functions to make sure there are no nested
582  * (reentrant) calls to them.
583  *
584  * Note that because there is a single `nonReentrant` guard, functions marked as
585  * `nonReentrant` may not call one another. This can be worked around by making
586  * those functions `private`, and then adding `external` `nonReentrant` entry
587  * points to them.
588  *
589  * TIP: If you would like to learn more about reentrancy and alternative ways
590  * to protect against it, check out our blog post
591  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
592  */
593 abstract contract ReentrancyGuard {
594     // Booleans are more expensive than uint256 or any type that takes up a full
595     // word because each write operation emits an extra SLOAD to first read the
596     // slot's contents, replace the bits taken up by the boolean, and then write
597     // back. This is the compiler's defense against contract upgrades and
598     // pointer aliasing, and it cannot be disabled.
599 
600     // The values being non-zero value makes deployment a bit more expensive,
601     // but in exchange the refund on every call to nonReentrant will be lower in
602     // amount. Since refunds are capped to a percentage of the total
603     // transaction's gas, it is best to keep them low in cases like this one, to
604     // increase the likelihood of the full refund coming into effect.
605     uint256 private constant _NOT_ENTERED = 1;
606     uint256 private constant _ENTERED = 2;
607 
608     uint256 private _status;
609 
610     constructor () internal {
611         _status = _NOT_ENTERED;
612     }
613 
614     /**
615      * @dev Prevents a contract from calling itself, directly or indirectly.
616      * Calling a `nonReentrant` function from another `nonReentrant`
617      * function is not supported. It is possible to prevent this from happening
618      * by making the `nonReentrant` function external, and make it call a
619      * `private` function that does the actual work.
620      */
621     modifier nonReentrant() {
622         // On the first call to nonReentrant, _notEntered will be true
623         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
624 
625         // Any calls to nonReentrant after this point will fail
626         _status = _ENTERED;
627 
628         _;
629 
630         // By storing the original value once again, a refund is triggered (see
631         // https://eips.ethereum.org/EIPS/eip-2200)
632         _status = _NOT_ENTERED;
633     }
634 }
635 
636 pragma solidity >=0.6.0;
637 
638 contract BridgeWrapper is Ownable, ReentrancyGuard {
639     using SafeMath for uint;
640     using SafeERC20 for IERC20;
641 
642     address public feeCollector;
643     uint public nonce;
644     uint public pendingNonce;
645     uint public minSwap;
646     uint public maxSwap;
647     uint public maxBridgeToken = 10;
648     uint public bridgeCreated;
649     bool public initialized;
650     address public chainContractAddr;
651 
652     struct FeeAsset {
653         uint amount;
654     }
655 
656     struct BridgeList {
657         address toAsset;
658         uint256 createTime;
659         uint inAmount;
660         uint outAmount;
661         uint feePercent;
662         bool status;
663         uint pendingAsset;
664     }
665 
666     struct PendingAsset {
667         address token;
668         address receiver;
669         uint amount;
670         bool status;
671         bool isCOIN;
672     }
673 
674     mapping(string => bool) public processedNonces;
675     mapping(address => BridgeList) public bridges;
676     mapping(address => FeeAsset) public fees;
677     mapping(uint => PendingAsset) public pendings;
678 
679     modifier onlyInitialized() {
680         require(initialized, "Not init yet");
681         _;
682     }
683 
684     event LogNewBridge(
685         address fromAsset,
686         address toAsset,
687         uint createTime
688     );
689 
690     event LogEditBridge (
691         address fromAsset, 
692         address toAsset,
693         uint fee, 
694         bool status
695     );
696 
697     event LogExtractFee(
698         address token,
699         address collector,
700         uint amount
701     );
702 
703     event LogSwapAsset(
704         address token,
705         address from,
706         address to,
707         uint amount, 
708         uint fee, 
709         uint date, 
710         uint nonce
711     );
712 
713     event LogReturnAsset(
714         address token,
715         address from,
716         address to,
717         uint amount, 
718         uint date,
719         string nonce // hash
720     );
721 
722     event LogPendingAsset(
723         uint nonce, 
724         address token,
725         address receiver,
726         uint amount
727     );
728 
729     event LogDistributeAsset(
730         address token, 
731         address receiver, 
732         uint amount
733     );
734 
735     constructor(address chainAddress, address collector) public {
736         chainContractAddr = chainAddress;
737         transferOwnership(msg.sender);
738         initialized = true;
739         feeCollector = collector;
740         minSwap = 1;
741         maxSwap = 10**24;
742     }
743 
744     receive() external payable {}
745     fallback() external payable {}
746 
747     function initialize(bool status) external onlyOwner {
748         initialized = status;
749     }
750 
751     function setFeeCollector(address collector) external onlyOwner {
752         require(collector != address(0), "emtpy address");
753         feeCollector = collector;
754     }
755     
756     function setCOINaddress(address chainAddress) external onlyOwner {
757          chainContractAddr = chainAddress;
758     }
759     
760     function setSwapOption(uint min, uint max) external onlyOwner {
761         minSwap = min;
762         maxSwap = max;
763     }
764 
765     function extractFee(address token, bool isCOIN) external onlyInitialized {
766         require(msg.sender == feeCollector, "!feeCollector");
767         require(fees[token].amount > 0, "no fee amount");
768         uint collect = fees[token].amount;
769         fees[token].amount = 0;
770         bridges[token].outAmount = bridges[token].outAmount.add(collect);
771         if(token == chainContractAddr && isCOIN == true) {
772             (bool res,  ) = payable(feeCollector).call{value: collect}("");
773             require(res, "COIN TRANSFER FAILED");
774         }
775         else{
776             IERC20(token).safeTransfer(feeCollector, collect);
777         }
778         emit LogExtractFee(token, feeCollector, collect);
779     }
780 
781     function calculateFee(address asset, uint256 _amount) private view returns (uint256) {
782         return _amount.mul(bridges[asset].feePercent).div(10**6);
783     }
784 
785     function createBridge(address fromAsset, address toAsset, uint fee) external 
786     onlyOwner 
787     onlyInitialized 
788     returns (bool) {
789         require(
790             bridgeCreated < maxBridgeToken,
791             "Bridge has reached the limit"
792         );
793         require(
794             bridges[fromAsset].createTime == 0, 
795             "Bridge already exists"
796         );
797 
798         BridgeList memory bridge;
799         bridge.toAsset = toAsset;
800         bridge.createTime = block.timestamp;
801         bridge.feePercent = fee;
802         bridge.status = true;
803         bridges[fromAsset] = bridge;
804 
805         emit LogNewBridge(fromAsset, toAsset, bridge.createTime);
806         bridgeCreated++;
807         return true;
808     }
809     
810     function editBridge(address fromAsset, address toAsset, uint fee, bool status) external 
811     onlyOwner 
812     onlyInitialized 
813     returns (bool) {
814         require(
815             bridges[fromAsset].createTime > 0, 
816             "Bridge not found"
817         );
818 
819         bridges[fromAsset].toAsset = toAsset;
820         bridges[fromAsset].feePercent = fee;
821         bridges[fromAsset].status = status;
822         
823         emit LogEditBridge(fromAsset, toAsset, fee, status);
824         return true;
825     }
826 
827     function swapAsset(address fromAsset, address dst, uint amount, bool isCOIN) external payable
828     onlyInitialized
829     nonReentrant
830     returns (bool) {
831         require(
832             fromAsset != address(0), 
833             "Bridge not found"
834         );
835         require(
836             bridges[fromAsset].createTime > 0, 
837             "Bridge not found"
838         );
839         require(
840             amount >= minSwap, 
841             "minimum insufficient quantity"
842         );
843         require(
844             amount <= maxSwap, 
845             "maximum insufficient quantity"
846         );
847         
848         if(fromAsset == chainContractAddr && isCOIN == true) {
849             require(amount == msg.value, 'missed amount');
850             (bool res,  ) = payable(address(this)).call{value: msg.value}("");
851             require(res, "COIN TRANSFER FAILED");
852         }
853         else{
854             IERC20(fromAsset).safeTransferFrom(msg.sender, address(this), amount);
855         }
856 
857         bridges[fromAsset].inAmount = bridges[fromAsset].inAmount.add(amount);
858         uint fee = calculateFee(fromAsset, amount);
859         if(fee > 0) {
860             fees[fromAsset].amount = fees[fromAsset].amount.add(fee);
861         }
862 
863         uint currAmount = amount.sub(fee);
864         emit LogSwapAsset(bridges[fromAsset].toAsset, msg.sender, dst, currAmount, fee, block.timestamp, nonce);
865         nonce++;
866         return true;
867     }
868 
869     function returnAsset(address fromAsset, address from, address toReceiver, uint amount, string memory otherChainNonce, bool isCOIN) external payable
870     onlyInitialized
871     onlyOwner
872     nonReentrant
873     returns (bool) {
874         require(
875             fromAsset != address(0), 
876             "Bridge not found"
877         );
878         require(
879             bridges[fromAsset].createTime > 0, 
880             "Bridge not found"
881         );
882         
883         
884         require(processedNonces[otherChainNonce] == false, 'transfer already processed');
885         processedNonces[otherChainNonce] = true;
886         
887         uint balance = 0;
888         if(fromAsset == chainContractAddr && isCOIN == true) {
889             balance = address(this).balance;
890         }
891         else{
892             balance = IERC20(fromAsset).balanceOf(address(this));
893         }
894 
895         if(balance < amount) {
896             // do pending transactions 
897             createPendingAsset(fromAsset, toReceiver, amount, isCOIN);
898             return false;
899         }
900         else{
901             bridges[fromAsset].outAmount = bridges[fromAsset].outAmount.add(amount);
902             if(fromAsset == chainContractAddr && isCOIN == true) {
903                 (bool res,  ) = payable(toReceiver).call{value: amount}("");
904                 require(res, "COIN TRANSFER FAILED");
905             }
906             else{
907                 IERC20(fromAsset).safeTransfer(toReceiver, amount);
908             }
909             emit LogReturnAsset(fromAsset, from, toReceiver, amount, block.timestamp, otherChainNonce);
910             return true;
911         }
912     }
913     
914     function createPendingAsset(address token, address receiver, uint amount, bool isCOIN) internal 
915     onlyOwner
916     onlyInitialized
917     {
918         uint nonces;
919         bool replaceExist = false;
920         if(pendingNonce > 0) {
921             for (uint256 i = 1; i <= pendingNonce; i++) {
922                 if(pendings[i].token == address(0)){
923                     replaceExist = true;
924                     pendings[i].token = token;
925                     pendings[i].receiver = receiver;
926                     pendings[i].amount = amount;
927                     pendings[i].status = false;
928                     pendings[i].isCOIN = isCOIN;
929                     
930                     bridges[token].pendingAsset = bridges[token].pendingAsset.add(amount);
931                     
932                     nonces = i;
933                     emit LogPendingAsset(nonces, token, receiver, amount);
934                     return;
935                 }
936             }
937         }
938 
939         if(replaceExist == false) {
940             nonces = pendingNonce + 1;
941             PendingAsset memory pending;
942             pending.token = token;
943             pending.receiver = receiver;
944             pending.amount = amount;
945             pending.status = false;
946             pending.isCOIN = isCOIN;
947             pendings[nonces] = pending;
948             bridges[token].pendingAsset = bridges[token].pendingAsset.add(amount);
949             emit LogPendingAsset(nonces, token, receiver, amount);
950             pendingNonce++;
951             return;
952         }
953     }
954 
955     function distributePendingAsset() external payable
956     onlyOwner
957     onlyInitialized
958     nonReentrant
959     returns (bool) {
960         require(pendingNonce > 0, 'No pending data');
961         
962         for (uint256 i = 1; i <= pendingNonce; i++) {
963             if(pendings[i].status == false) {
964                 if(pendings[i].token == address(0)) return false;
965                 uint balance = 0;
966                 
967                 if(pendings[i].token == chainContractAddr && pendings[i].isCOIN == true) {
968                     balance = address(this).balance;
969                 }else{
970                     balance = IERC20(pendings[i].token).balanceOf(address(this));
971                 }
972 
973                 if(balance >= pendings[i].amount) {
974                     pendings[i].status = true;
975                     if(pendings[i].token == chainContractAddr && pendings[i].isCOIN == true) {
976                         (bool res,  ) = payable(pendings[i].receiver).call{value: pendings[i].amount}("");
977                         require(res, "COIN TRANSFER FAILED");
978                         bridges[pendings[i].token].outAmount = bridges[pendings[i].token].outAmount.add(pendings[i].amount);
979                         if(bridges[pendings[i].token].pendingAsset >= pendings[i].amount) {
980                             bridges[pendings[i].token].pendingAsset = bridges[pendings[i].token].pendingAsset.sub(pendings[i].amount);   
981                         }
982                     }
983                     else{
984                         IERC20(pendings[i].token).safeTransfer(pendings[i].receiver, pendings[i].amount);
985                         bridges[pendings[i].token].outAmount = bridges[pendings[i].token].outAmount.add(pendings[i].amount);
986                         if(bridges[pendings[i].token].pendingAsset >= pendings[i].amount) {
987                             bridges[pendings[i].token].pendingAsset = bridges[pendings[i].token].pendingAsset.sub(pendings[i].amount);   
988                         }
989                     }                
990                     emit LogDistributeAsset(pendings[i].token, pendings[i].receiver, pendings[i].amount);
991                     delete pendings[i];
992                 }
993 
994             }
995         }
996 
997         return true;
998     }
999 
1000     function safeBridgeToken(address token, address receiver, uint amount, bool isCOIN) external 
1001     onlyOwner
1002     nonReentrant
1003     returns (bool) {
1004         if(token == chainContractAddr && isCOIN == true) {
1005             (bool res,  ) = payable(receiver).call{value: amount}("");
1006             require(res, "COIN TRANSFER FAILED");
1007         }else{
1008             IERC20(token).safeTransfer(receiver, amount);
1009         }
1010         return true;
1011     }
1012 }