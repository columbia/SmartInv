1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
80 
81 pragma solidity >=0.6.0 <0.8.0;
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
240 
241 pragma solidity >=0.6.2 <0.8.0;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { size := extcodesize(account) }
272         return size > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318       return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: value }(data);
358         return _verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
368         return functionStaticCall(target, data, "Address: low-level static call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return _verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 // solhint-disable-next-line no-inline-assembly
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
406 
407 pragma solidity >=0.6.0 <0.8.0;
408 
409 
410 
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure (when the token
415  * contract returns false). Tokens that return no value (and instead revert or
416  * throw on failure) are also supported, non-reverting calls are assumed to be
417  * successful.
418  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
419  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
420  */
421 library SafeERC20 {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     function safeTransfer(IERC20 token, address to, uint256 value) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
427     }
428 
429     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
430         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
431     }
432 
433     /**
434      * @dev Deprecated. This function has issues similar to the ones found in
435      * {IERC20-approve}, and its usage is discouraged.
436      *
437      * Whenever possible, use {safeIncreaseAllowance} and
438      * {safeDecreaseAllowance} instead.
439      */
440     function safeApprove(IERC20 token, address spender, uint256 value) internal {
441         // safeApprove should only be called when setting an initial allowance,
442         // or when resetting it to zero. To increase and decrease it, use
443         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
444         // solhint-disable-next-line max-line-length
445         require((value == 0) || (token.allowance(address(this), spender) == 0),
446             "SafeERC20: approve from non-zero to non-zero allowance"
447         );
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
449     }
450 
451     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
452         uint256 newAllowance = token.allowance(address(this), spender).add(value);
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
454     }
455 
456     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
459     }
460 
461     /**
462      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
463      * on the return value: the return value is optional (but if data is returned, it must not be false).
464      * @param token The token targeted by the call.
465      * @param data The call data (encoded using abi.encode or one of its variants).
466      */
467     function _callOptionalReturn(IERC20 token, bytes memory data) private {
468         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
469         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
470         // the target address contains contract code and also asserts for success in the low-level call.
471 
472         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
473         if (returndata.length > 0) { // Return data is optional
474             // solhint-disable-next-line max-line-length
475             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
476         }
477     }
478 }
479 
480 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
481 
482 pragma solidity >=0.6.0 <0.8.0;
483 
484 /**
485  * @dev Contract module that helps prevent reentrant calls to a function.
486  *
487  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
488  * available, which can be applied to functions to make sure there are no nested
489  * (reentrant) calls to them.
490  *
491  * Note that because there is a single `nonReentrant` guard, functions marked as
492  * `nonReentrant` may not call one another. This can be worked around by making
493  * those functions `private`, and then adding `external` `nonReentrant` entry
494  * points to them.
495  *
496  * TIP: If you would like to learn more about reentrancy and alternative ways
497  * to protect against it, check out our blog post
498  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
499  */
500 abstract contract ReentrancyGuard {
501     // Booleans are more expensive than uint256 or any type that takes up a full
502     // word because each write operation emits an extra SLOAD to first read the
503     // slot's contents, replace the bits taken up by the boolean, and then write
504     // back. This is the compiler's defense against contract upgrades and
505     // pointer aliasing, and it cannot be disabled.
506 
507     // The values being non-zero value makes deployment a bit more expensive,
508     // but in exchange the refund on every call to nonReentrant will be lower in
509     // amount. Since refunds are capped to a percentage of the total
510     // transaction's gas, it is best to keep them low in cases like this one, to
511     // increase the likelihood of the full refund coming into effect.
512     uint256 private constant _NOT_ENTERED = 1;
513     uint256 private constant _ENTERED = 2;
514 
515     uint256 private _status;
516 
517     constructor () internal {
518         _status = _NOT_ENTERED;
519     }
520 
521     /**
522      * @dev Prevents a contract from calling itself, directly or indirectly.
523      * Calling a `nonReentrant` function from another `nonReentrant`
524      * function is not supported. It is possible to prevent this from happening
525      * by making the `nonReentrant` function external, and make it call a
526      * `private` function that does the actual work.
527      */
528     modifier nonReentrant() {
529         // On the first call to nonReentrant, _notEntered will be true
530         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
531 
532         // Any calls to nonReentrant after this point will fail
533         _status = _ENTERED;
534 
535         _;
536 
537         // By storing the original value once again, a refund is triggered (see
538         // https://eips.ethereum.org/EIPS/eip-2200)
539         _status = _NOT_ENTERED;
540     }
541 }
542 
543 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
544 
545 pragma solidity >=0.6.0 <0.8.0;
546 
547 /*
548  * @dev Provides information about the current execution context, including the
549  * sender of the transaction and its data. While these are generally available
550  * via msg.sender and msg.data, they should not be accessed in such a direct
551  * manner, since when dealing with GSN meta-transactions the account sending and
552  * paying for execution may not be the actual sender (as far as an application
553  * is concerned).
554  *
555  * This contract is only required for intermediate, library-like contracts.
556  */
557 abstract contract Context {
558     function _msgSender() internal view virtual returns (address payable) {
559         return msg.sender;
560     }
561 
562     function _msgData() internal view virtual returns (bytes memory) {
563         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
564         return msg.data;
565     }
566 }
567 
568 // File: @openzeppelin\contracts\access\Ownable.sol
569 
570 pragma solidity >=0.6.0 <0.8.0;
571 
572 /**
573  * @dev Contract module which provides a basic access control mechanism, where
574  * there is an account (an owner) that can be granted exclusive access to
575  * specific functions.
576  *
577  * By default, the owner account will be the one that deploys the contract. This
578  * can later be changed with {transferOwnership}.
579  *
580  * This module is used through inheritance. It will make available the modifier
581  * `onlyOwner`, which can be applied to your functions to restrict their use to
582  * the owner.
583  */
584 abstract contract Ownable is Context {
585     address private _owner;
586 
587     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
588 
589     /**
590      * @dev Initializes the contract setting the deployer as the initial owner.
591      */
592     constructor () internal {
593         address msgSender = _msgSender();
594         _owner = msgSender;
595         emit OwnershipTransferred(address(0), msgSender);
596     }
597 
598     /**
599      * @dev Returns the address of the current owner.
600      */
601     function owner() public view returns (address) {
602         return _owner;
603     }
604 
605     /**
606      * @dev Throws if called by any account other than the owner.
607      */
608     modifier onlyOwner() {
609         require(_owner == _msgSender(), "Ownable: caller is not the owner");
610         _;
611     }
612 
613     /**
614      * @dev Leaves the contract without owner. It will not be possible to call
615      * `onlyOwner` functions anymore. Can only be called by the current owner.
616      *
617      * NOTE: Renouncing ownership will leave the contract without an owner,
618      * thereby removing any functionality that is only available to the owner.
619      */
620     function renounceOwnership() public virtual onlyOwner {
621         emit OwnershipTransferred(_owner, address(0));
622         _owner = address(0);
623     }
624 
625     /**
626      * @dev Transfers ownership of the contract to a new account (`newOwner`).
627      * Can only be called by the current owner.
628      */
629     function transferOwnership(address newOwner) public virtual onlyOwner {
630         require(newOwner != address(0), "Ownable: new owner is the zero address");
631         emit OwnershipTransferred(_owner, newOwner);
632         _owner = newOwner;
633     }
634 }
635 
636 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
637 
638 pragma solidity >=0.6.0 <0.8.0;
639 
640 
641 
642 
643 /**
644  * @dev Implementation of the {IERC20} interface.
645  *
646  * This implementation is agnostic to the way tokens are created. This means
647  * that a supply mechanism has to be added in a derived contract using {_mint}.
648  * For a generic mechanism see {ERC20PresetMinterPauser}.
649  *
650  * TIP: For a detailed writeup see our guide
651  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
652  * to implement supply mechanisms].
653  *
654  * We have followed general OpenZeppelin guidelines: functions revert instead
655  * of returning `false` on failure. This behavior is nonetheless conventional
656  * and does not conflict with the expectations of ERC20 applications.
657  *
658  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
659  * This allows applications to reconstruct the allowance for all accounts just
660  * by listening to said events. Other implementations of the EIP may not emit
661  * these events, as it isn't required by the specification.
662  *
663  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
664  * functions have been added to mitigate the well-known issues around setting
665  * allowances. See {IERC20-approve}.
666  */
667 contract ERC20 is Context, IERC20 {
668     using SafeMath for uint256;
669 
670     mapping (address => uint256) private _balances;
671 
672     mapping (address => mapping (address => uint256)) private _allowances;
673 
674     uint256 private _totalSupply;
675 
676     string private _name;
677     string private _symbol;
678     uint8 private _decimals;
679 
680     /**
681      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
682      * a default value of 18.
683      *
684      * To select a different value for {decimals}, use {_setupDecimals}.
685      *
686      * All three of these values are immutable: they can only be set once during
687      * construction.
688      */
689     constructor (string memory name_, string memory symbol_) public {
690         _name = name_;
691         _symbol = symbol_;
692         _decimals = 18;
693     }
694 
695     /**
696      * @dev Returns the name of the token.
697      */
698     function name() public view returns (string memory) {
699         return _name;
700     }
701 
702     /**
703      * @dev Returns the symbol of the token, usually a shorter version of the
704      * name.
705      */
706     function symbol() public view returns (string memory) {
707         return _symbol;
708     }
709 
710     /**
711      * @dev Returns the number of decimals used to get its user representation.
712      * For example, if `decimals` equals `2`, a balance of `505` tokens should
713      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
714      *
715      * Tokens usually opt for a value of 18, imitating the relationship between
716      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
717      * called.
718      *
719      * NOTE: This information is only used for _display_ purposes: it in
720      * no way affects any of the arithmetic of the contract, including
721      * {IERC20-balanceOf} and {IERC20-transfer}.
722      */
723     function decimals() public view returns (uint8) {
724         return _decimals;
725     }
726 
727     /**
728      * @dev See {IERC20-totalSupply}.
729      */
730     function totalSupply() public view override returns (uint256) {
731         return _totalSupply;
732     }
733 
734     /**
735      * @dev See {IERC20-balanceOf}.
736      */
737     function balanceOf(address account) public view override returns (uint256) {
738         return _balances[account];
739     }
740 
741     /**
742      * @dev See {IERC20-transfer}.
743      *
744      * Requirements:
745      *
746      * - `recipient` cannot be the zero address.
747      * - the caller must have a balance of at least `amount`.
748      */
749     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
750         _transfer(_msgSender(), recipient, amount);
751         return true;
752     }
753 
754     /**
755      * @dev See {IERC20-allowance}.
756      */
757     function allowance(address owner, address spender) public view virtual override returns (uint256) {
758         return _allowances[owner][spender];
759     }
760 
761     /**
762      * @dev See {IERC20-approve}.
763      *
764      * Requirements:
765      *
766      * - `spender` cannot be the zero address.
767      */
768     function approve(address spender, uint256 amount) public virtual override returns (bool) {
769         _approve(_msgSender(), spender, amount);
770         return true;
771     }
772 
773     /**
774      * @dev See {IERC20-transferFrom}.
775      *
776      * Emits an {Approval} event indicating the updated allowance. This is not
777      * required by the EIP. See the note at the beginning of {ERC20}.
778      *
779      * Requirements:
780      *
781      * - `sender` and `recipient` cannot be the zero address.
782      * - `sender` must have a balance of at least `amount`.
783      * - the caller must have allowance for ``sender``'s tokens of at least
784      * `amount`.
785      */
786     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
787         _transfer(sender, recipient, amount);
788         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
789         return true;
790     }
791 
792     /**
793      * @dev Atomically increases the allowance granted to `spender` by the caller.
794      *
795      * This is an alternative to {approve} that can be used as a mitigation for
796      * problems described in {IERC20-approve}.
797      *
798      * Emits an {Approval} event indicating the updated allowance.
799      *
800      * Requirements:
801      *
802      * - `spender` cannot be the zero address.
803      */
804     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
805         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
806         return true;
807     }
808 
809     /**
810      * @dev Atomically decreases the allowance granted to `spender` by the caller.
811      *
812      * This is an alternative to {approve} that can be used as a mitigation for
813      * problems described in {IERC20-approve}.
814      *
815      * Emits an {Approval} event indicating the updated allowance.
816      *
817      * Requirements:
818      *
819      * - `spender` cannot be the zero address.
820      * - `spender` must have allowance for the caller of at least
821      * `subtractedValue`.
822      */
823     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
824         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
825         return true;
826     }
827 
828     /**
829      * @dev Moves tokens `amount` from `sender` to `recipient`.
830      *
831      * This is internal function is equivalent to {transfer}, and can be used to
832      * e.g. implement automatic token fees, slashing mechanisms, etc.
833      *
834      * Emits a {Transfer} event.
835      *
836      * Requirements:
837      *
838      * - `sender` cannot be the zero address.
839      * - `recipient` cannot be the zero address.
840      * - `sender` must have a balance of at least `amount`.
841      */
842     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
843         require(sender != address(0), "ERC20: transfer from the zero address");
844         require(recipient != address(0), "ERC20: transfer to the zero address");
845 
846         _beforeTokenTransfer(sender, recipient, amount);
847 
848         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
849         _balances[recipient] = _balances[recipient].add(amount);
850         emit Transfer(sender, recipient, amount);
851     }
852 
853     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
854      * the total supply.
855      *
856      * Emits a {Transfer} event with `from` set to the zero address.
857      *
858      * Requirements:
859      *
860      * - `to` cannot be the zero address.
861      */
862     function _mint(address account, uint256 amount) internal virtual {
863         require(account != address(0), "ERC20: mint to the zero address");
864 
865         _beforeTokenTransfer(address(0), account, amount);
866 
867         _totalSupply = _totalSupply.add(amount);
868         _balances[account] = _balances[account].add(amount);
869         emit Transfer(address(0), account, amount);
870     }
871 
872     /**
873      * @dev Destroys `amount` tokens from `account`, reducing the
874      * total supply.
875      *
876      * Emits a {Transfer} event with `to` set to the zero address.
877      *
878      * Requirements:
879      *
880      * - `account` cannot be the zero address.
881      * - `account` must have at least `amount` tokens.
882      */
883     function _burn(address account, uint256 amount) internal virtual {
884         require(account != address(0), "ERC20: burn from the zero address");
885 
886         _beforeTokenTransfer(account, address(0), amount);
887 
888         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
889         _totalSupply = _totalSupply.sub(amount);
890         emit Transfer(account, address(0), amount);
891     }
892 
893     /**
894      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
895      *
896      * This internal function is equivalent to `approve`, and can be used to
897      * e.g. set automatic allowances for certain subsystems, etc.
898      *
899      * Emits an {Approval} event.
900      *
901      * Requirements:
902      *
903      * - `owner` cannot be the zero address.
904      * - `spender` cannot be the zero address.
905      */
906     function _approve(address owner, address spender, uint256 amount) internal virtual {
907         require(owner != address(0), "ERC20: approve from the zero address");
908         require(spender != address(0), "ERC20: approve to the zero address");
909 
910         _allowances[owner][spender] = amount;
911         emit Approval(owner, spender, amount);
912     }
913 
914     /**
915      * @dev Sets {decimals} to a value other than the default one of 18.
916      *
917      * WARNING: This function should only be called from the constructor. Most
918      * applications that interact with token contracts will not expect
919      * {decimals} to ever change, and may work incorrectly if it does.
920      */
921     function _setupDecimals(uint8 decimals_) internal {
922         _decimals = decimals_;
923     }
924 
925     /**
926      * @dev Hook that is called before any transfer of tokens. This includes
927      * minting and burning.
928      *
929      * Calling conditions:
930      *
931      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
932      * will be to transferred to `to`.
933      * - when `from` is zero, `amount` tokens will be minted for `to`.
934      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
935      * - `from` and `to` are never both zero.
936      *
937      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
938      */
939     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
940 }
941 
942 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
943 
944 pragma solidity >=0.6.0 <0.8.0;
945 
946 
947 
948 /**
949  * @dev Extension of {ERC20} that allows token holders to destroy both their own
950  * tokens and those that they have an allowance for, in a way that can be
951  * recognized off-chain (via event analysis).
952  */
953 abstract contract ERC20Burnable is Context, ERC20 {
954     using SafeMath for uint256;
955 
956     /**
957      * @dev Destroys `amount` tokens from the caller.
958      *
959      * See {ERC20-_burn}.
960      */
961     function burn(uint256 amount) public virtual {
962         _burn(_msgSender(), amount);
963     }
964 
965     /**
966      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
967      * allowance.
968      *
969      * See {ERC20-_burn} and {ERC20-allowance}.
970      *
971      * Requirements:
972      *
973      * - the caller must have allowance for ``accounts``'s tokens of at least
974      * `amount`.
975      */
976     function burnFrom(address account, uint256 amount) public virtual {
977         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
978 
979         _approve(account, _msgSender(), decreasedAllowance);
980         _burn(account, amount);
981     }
982 }
983 
984 // File: contracts\SHEESHA.sol
985 
986 pragma solidity 0.7.6;
987 
988 
989 
990 
991 contract SHEESHA is ERC20Burnable, Ownable {
992     using SafeMath for uint256;
993 
994     //100,000 tokens
995     uint256 public constant initialSupply = 100000e18;
996     address public devAddress;
997     address public teamAddress;
998     address public marketingAddress;
999     address public reserveAddress;
1000     bool public vaultTransferDone;
1001     bool public vaultLPTransferDone;
1002 
1003     // 15% team (4% monthly unlock over 25 months)
1004     // 10% dev
1005     // 10% marketing
1006     // 15% liquidity provision
1007     // 10% SHEESHA staking rewards
1008     // 20% LP rewards
1009     // 20% Reserve
1010 
1011     constructor(address _devAddress, address _marketingAddress, address _teamAddress, address _reserveAddress) ERC20("Sheesha Finance", "SHEESHA") {
1012         devAddress = _devAddress;
1013         marketingAddress = _marketingAddress;
1014         teamAddress = _teamAddress;
1015         reserveAddress = _reserveAddress;
1016         _mint(address(this), initialSupply);
1017         _transfer(address(this), devAddress, initialSupply.mul(10).div(100));
1018         _transfer(address(this), teamAddress, initialSupply.mul(15).div(100));
1019         _transfer(address(this), marketingAddress, initialSupply.mul(10).div(100));
1020         _transfer(address(this), reserveAddress, initialSupply.mul(20).div(100));
1021     }
1022 
1023     //one time only
1024     function transferVaultRewards(address _vaultAddress) public onlyOwner {
1025         require(!vaultTransferDone, "Already transferred");
1026         _transfer(address(this), _vaultAddress, initialSupply.mul(10).div(100));
1027         vaultTransferDone = true;
1028     }
1029 
1030     //one time only
1031     function transferVaultLPRewards(address _vaultLPAddress) public onlyOwner {
1032         require(!vaultLPTransferDone, "Already transferred");
1033         _transfer(address(this), _vaultLPAddress, initialSupply.mul(20).div(100));
1034         vaultLPTransferDone = true;
1035     }
1036 }
1037 
1038 // File: contracts\SHEESHAVaultLP.sol
1039 
1040 pragma solidity 0.7.6;
1041 
1042 
1043 
1044 
1045 
1046 
1047 
1048 contract SHEESHAVaultLP is Ownable, ReentrancyGuard {
1049     using SafeMath for uint256;
1050     using SafeERC20 for IERC20;
1051     // Info of each user.
1052     struct UserInfo {
1053         uint256 amount; // How many LP tokens the user has provided.
1054         uint256 rewardDebt; // Reward debt. See explanation below.
1055         uint256 checkpoint; //time user staked
1056         bool status; //true-> user existing | false-> not
1057         //
1058         // We do some fancy math here. Basically, any point in time, the amount of SHEESHAs
1059         // entitled to a user but is pending to be distributed is:
1060         //
1061         //   pending reward = (user.amount * pool.accSheeshaPerShare) - user.rewardDebt
1062         //
1063         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1064         //   1. The pool's `accSheeshaPerShare` (and `lastRewardBlock`) gets updated.
1065         //   2. User receives the pending reward sent to his/her address.
1066         //   3. User's `amount` gets updated.
1067         //   4. User's `rewardDebt` gets updated.
1068     }
1069 
1070     // Info of each pool.
1071     struct PoolInfo {
1072         IERC20 lpToken; // Address of token/LP token contract.
1073         uint256 allocPoint; // How many allocation points assigned to this pool. SHEESHAs to distribute per block.
1074         uint256 lastRewardBlock; // Last block number that SHEESHAs distribution occurs.
1075         uint256 accSheeshaPerShare; // Accumulated SHEESHAs per share, times 1e12. See below.
1076     }
1077 
1078     // The SHEESHA TOKEN!
1079     SHEESHA public sheesha;
1080     
1081     // Info of each pool.
1082     PoolInfo[] public poolInfo;
1083     // Info of each user that stakes  tokens.
1084     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1085     // Total allocation points. Must be the sum of all allocation points in all pools.
1086     uint256 public totalAllocPoint;
1087 
1088     // The block number when SHEESHA mining starts.
1089     uint256 public startBlock;
1090 
1091     // SHEESHA tokens percenatge created per block based on rewards pool- 0.01%
1092     uint256 public constant sheeshaPerBlock = 1;
1093     //handle case till 0.01(2 decimal places)
1094     uint256 public constant percentageDivider = 10000;
1095     //20,000 sheesha 20% of supply
1096     uint256 public lpRewards = 20000e18;
1097     address public feeWallet = 0x5483d944038189B4232d1E35367420989E2C3762;
1098 
1099     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1100     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1101     event EmergencyWithdraw(
1102         address indexed user,
1103         uint256 indexed pid,
1104         uint256 amount
1105     );
1106 
1107     constructor(
1108         SHEESHA _sheesha
1109     ) {
1110         sheesha = _sheesha;
1111         startBlock = block.number;
1112         IERC20(sheesha).safeApprove(msg.sender, uint256(-1));
1113     }
1114 
1115     function poolLength() external view returns (uint256) {
1116         return poolInfo.length;
1117     }
1118 
1119     // Add a new lp to the pool. Can only be called by the owner.
1120     // DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1121     function add(
1122         uint256 _allocPoint,
1123         IERC20 _lpToken,
1124         bool _withUpdate
1125     ) public onlyOwner {
1126         if (_withUpdate) {
1127             massUpdatePools();
1128         }
1129         uint256 lastRewardBlock = block.number;
1130         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1131         poolInfo.push(
1132             PoolInfo({
1133                 lpToken: _lpToken,
1134                 allocPoint: _allocPoint,
1135                 lastRewardBlock: lastRewardBlock,
1136                 accSheeshaPerShare: 0
1137             })
1138         );
1139     }
1140 
1141     // Update the given pool's SHEESHA allocation point. Can only be called by the owner.
1142     function set(
1143         uint256 _pid,
1144         uint256 _allocPoint,
1145         bool _withUpdate
1146     ) public onlyOwner {
1147         if (_withUpdate) {
1148             massUpdatePools();
1149         }
1150         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1151         poolInfo[_pid].allocPoint = _allocPoint;
1152     }
1153 
1154     // Update reward vairables for all pools. Be careful of gas spending!
1155     function massUpdatePools() public {
1156         uint256 length = poolInfo.length;
1157 
1158         for (uint256 pid = 0; pid < length; ++pid) {
1159             updatePool(pid);
1160         }
1161     }
1162 
1163     // Update reward variables of the given pool to be up-to-date.
1164     function updatePool(uint256 _pid) public {
1165         PoolInfo storage pool = poolInfo[_pid];
1166         if (block.number <= pool.lastRewardBlock) {
1167             return;
1168         }
1169         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1170         if (lpSupply == 0) {
1171             pool.lastRewardBlock = block.number;
1172             return;
1173         }
1174 
1175         uint256 sheeshaReward = (lpRewards.mul(sheeshaPerBlock).div(percentageDivider)).mul(pool.allocPoint).div(totalAllocPoint);
1176         lpRewards = lpRewards.sub(sheeshaReward);
1177         pool.accSheeshaPerShare = pool.accSheeshaPerShare.add(sheeshaReward.mul(1e12).div(lpSupply));
1178     }
1179 
1180     // Deposit LP tokens to MasterChef for SHEESHA allocation.
1181     function deposit(uint256 _pid, uint256 _amount) public {
1182         _deposit(msg.sender, _pid, _amount);
1183     }
1184 
1185     // stake from LGE directly
1186     // Test coverage
1187     // [x] Does user get the deposited amounts?
1188     // [x] Does user that its deposited for update correcty?
1189     // [x] Does the depositor get their tokens decreased
1190     function depositFor(address _depositFor, uint256 _pid, uint256 _amount) public {
1191         _deposit(_depositFor, _pid, _amount);
1192     }
1193 
1194     function _deposit(address _depositFor, uint256 _pid, uint256 _amount) internal nonReentrant {
1195         PoolInfo storage pool = poolInfo[_pid];
1196         UserInfo storage user = userInfo[_pid][_depositFor];
1197 
1198         updatePool(_pid);
1199 
1200         if(!isActive(_pid, _depositFor)) {
1201             user.status = true;
1202             user.checkpoint = block.timestamp;
1203         }
1204 
1205         if (user.amount > 0) {
1206             uint256 pending = user.amount.mul(pool.accSheeshaPerShare).div(1e12).sub(user.rewardDebt);
1207             safeSheeshaTransfer(_depositFor, pending);
1208         }
1209 
1210         if(_amount > 0) {
1211             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1212             user.amount = user.amount.add(_amount); // This is depositedFor address
1213         }
1214 
1215         user.rewardDebt = user.amount.mul(pool.accSheeshaPerShare).div(1e12); /// This is deposited for address
1216         emit Deposit(_depositFor, _pid, _amount);
1217     }
1218 
1219     // Withdraw LP tokens or claim rewrads if amount is 0
1220     function withdraw(uint256 _pid, uint256 _amount) public {
1221         PoolInfo storage pool = poolInfo[_pid];
1222         UserInfo storage user = userInfo[_pid][msg.sender];
1223         require(user.amount >= _amount, "withdraw: not good");
1224         updatePool(_pid);
1225         uint256 pending = user.amount.mul(pool.accSheeshaPerShare).div(1e12).sub(user.rewardDebt);
1226         safeSheeshaTransfer(msg.sender, pending);
1227         if(_amount > 0) {
1228             uint256 feePercent = 4;
1229             //2 years
1230             if(user.checkpoint.add(730 days) <= block.timestamp) {
1231                 //4-> unstake fee interval
1232                 feePercent = uint256(100).sub(getElapsedMonthsCount(user.checkpoint).mul(4));
1233             }
1234             uint256 fees = _amount.mul(feePercent).div(100);
1235             user.amount = user.amount.sub(_amount);
1236             pool.lpToken.safeTransfer(feeWallet, fees);
1237             pool.lpToken.safeTransfer(address(msg.sender), _amount.sub(fees));
1238         }
1239         user.rewardDebt = user.amount.mul(pool.accSheeshaPerShare).div(1e12);
1240         emit Withdraw(msg.sender, _pid, _amount);
1241     }
1242 
1243     // Withdraw without caring about rewards. EMERGENCY ONLY
1244     function emergencyWithdraw(uint256 _pid) public {
1245         PoolInfo storage pool = poolInfo[_pid];
1246         UserInfo storage user = userInfo[_pid][msg.sender];
1247         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1248         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1249         user.amount = 0;
1250         user.rewardDebt = 0;
1251     }
1252 
1253     //user must approve this contract to add rewards
1254     function addRewards(uint256 _amount) public onlyOwner {
1255         require(_amount > 0, "Invalid amount");
1256         IERC20(sheesha).safeTransferFrom(address(msg.sender), address(this), _amount);
1257         lpRewards = lpRewards.add(_amount);
1258     }
1259 
1260     // Safe sheesha transfer function, just in case if rounding error causes pool to not have enough SHEESHAs
1261     function safeSheeshaTransfer(address _to, uint256 _amount) internal {
1262         uint256 sheeshaBal = sheesha.balanceOf(address(this));
1263         if (_amount > sheeshaBal) {
1264             sheesha.transfer(_to, sheeshaBal);
1265         } else {
1266             sheesha.transfer(_to, _amount);
1267         }
1268     }
1269 
1270     // View function to see pending SHEESHAs on frontend.
1271     function pendingSheesha(uint256 _pid, address _user) external view returns (uint256) {
1272         PoolInfo storage pool = poolInfo[_pid];
1273         UserInfo storage user = userInfo[_pid][_user];
1274         uint256 accSheeshaPerShare = pool.accSheeshaPerShare;
1275         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1276         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1277             uint256 sheeshaReward = (lpRewards.mul(sheeshaPerBlock).div(percentageDivider)).mul(pool.allocPoint).div(totalAllocPoint);
1278             accSheeshaPerShare = accSheeshaPerShare.add(sheeshaReward.mul(1e12).div(lpSupply));
1279         }
1280         return user.amount.mul(accSheeshaPerShare).div(1e12).sub(user.rewardDebt);
1281     }
1282 
1283     function isActive(uint256 _pid, address _user) public view returns(bool) {
1284         return userInfo[_pid][_user].status;
1285     }
1286 
1287     function getElapsedMonthsCount(uint256 checkpoint) public view returns(uint256) {
1288         return ((block.timestamp.sub(checkpoint)).div(30 days)).add(1);
1289     }
1290 
1291     function changeFeeWallet(address _feeWallet) external onlyOwner {
1292         feeWallet = _feeWallet;
1293     }
1294 
1295 }