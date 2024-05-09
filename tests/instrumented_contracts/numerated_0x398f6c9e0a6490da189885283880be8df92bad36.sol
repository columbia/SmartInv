1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.2;
4 
5 
6 // 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // 
82 /*
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with GSN meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address payable) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes memory) {
98         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
99         return msg.data;
100     }
101 }
102 
103 // 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
120 
121     /**
122      * @dev Initializes the contract setting the deployer as the initial owner.
123      */
124     constructor () internal {
125         address msgSender = _msgSender();
126         _owner = msgSender;
127         emit OwnershipTransferred(address(0), msgSender);
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(_owner == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         emit OwnershipTransferred(_owner, address(0));
154         _owner = address(0);
155     }
156 
157     /**
158      * @dev Transfers ownership of the contract to a new account (`newOwner`).
159      * Can only be called by the current owner.
160      */
161     function transferOwnership(address newOwner) public virtual onlyOwner {
162         require(newOwner != address(0), "Ownable: new owner is the zero address");
163         emit OwnershipTransferred(_owner, newOwner);
164         _owner = newOwner;
165     }
166 }
167 
168 // 
169 /**
170  * @dev Wrappers over Solidity's arithmetic operations with added overflow
171  * checks.
172  *
173  * Arithmetic operations in Solidity wrap on overflow. This can easily result
174  * in bugs, because programmers usually assume that an overflow raises an
175  * error, which is the standard behavior in high level programming languages.
176  * `SafeMath` restores this intuition by reverting the transaction when an
177  * operation overflows.
178  *
179  * Using this library instead of the unchecked operations eliminates an entire
180  * class of bugs, so it's recommended to use it always.
181  */
182 library SafeMath {
183     /**
184      * @dev Returns the addition of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `+` operator.
188      *
189      * Requirements:
190      *
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         return sub(a, b, "SafeMath: subtraction overflow");
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      *
222      * - Subtraction cannot overflow.
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      *
239      * - Multiplication cannot overflow.
240      */
241     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
242         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
243         // benefit is lost if 'b' is also tested.
244         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
245         if (a == 0) {
246             return 0;
247         }
248 
249         uint256 c = a * b;
250         require(c / a == b, "SafeMath: multiplication overflow");
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers. Reverts on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function div(uint256 a, uint256 b) internal pure returns (uint256) {
268         return div(a, b, "SafeMath: division by zero");
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         return mod(a, b, "SafeMath: modulo by zero");
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts with custom message when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // 
326 /**
327  * @dev Collection of functions related to the address type
328  */
329 library Address {
330     /**
331      * @dev Returns true if `account` is a contract.
332      *
333      * [IMPORTANT]
334      * ====
335      * It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      *
338      * Among others, `isContract` will return false for the following
339      * types of addresses:
340      *
341      *  - an externally-owned account
342      *  - a contract in construction
343      *  - an address where a contract will be created
344      *  - an address where a contract lived, but was destroyed
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // This method relies in extcodesize, which returns 0 for contracts in
349         // construction, since the code is only stored at the end of the
350         // constructor execution.
351 
352         uint256 size;
353         // solhint-disable-next-line no-inline-assembly
354         assembly { size := extcodesize(account) }
355         return size > 0;
356     }
357 
358     /**
359      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
360      * `recipient`, forwarding all available gas and reverting on errors.
361      *
362      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
363      * of certain opcodes, possibly making contracts go over the 2300 gas limit
364      * imposed by `transfer`, making them unable to receive funds via
365      * `transfer`. {sendValue} removes this limitation.
366      *
367      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
368      *
369      * IMPORTANT: because control is transferred to `recipient`, care must be
370      * taken to not create reentrancy vulnerabilities. Consider using
371      * {ReentrancyGuard} or the
372      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
373      */
374     function sendValue(address payable recipient, uint256 amount) internal {
375         require(address(this).balance >= amount, "Address: insufficient balance");
376 
377         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
378         (bool success, ) = recipient.call{ value: amount }("");
379         require(success, "Address: unable to send value, recipient may have reverted");
380     }
381 
382     /**
383      * @dev Performs a Solidity function call using a low level `call`. A
384      * plain`call` is an unsafe replacement for a function call: use this
385      * function instead.
386      *
387      * If `target` reverts with a revert reason, it is bubbled up by this
388      * function (like regular Solidity function calls).
389      *
390      * Returns the raw returned data. To convert to the expected return value,
391      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
392      *
393      * Requirements:
394      *
395      * - `target` must be a contract.
396      * - calling `target` with `data` must not revert.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
401       return functionCall(target, data, "Address: low-level call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
406      * `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
411         return _functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
431      * with `errorMessage` as a fallback revert reason when `target` reverts.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         return _functionCallWithValue(target, data, value, errorMessage);
438     }
439 
440     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
441         require(isContract(target), "Address: call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 // solhint-disable-next-line no-inline-assembly
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 // 
465 /**
466  * @dev Contract module that helps prevent reentrant calls to a function.
467  *
468  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
469  * available, which can be applied to functions to make sure there are no nested
470  * (reentrant) calls to them.
471  *
472  * Note that because there is a single `nonReentrant` guard, functions marked as
473  * `nonReentrant` may not call one another. This can be worked around by making
474  * those functions `private`, and then adding `external` `nonReentrant` entry
475  * points to them.
476  *
477  * TIP: If you would like to learn more about reentrancy and alternative ways
478  * to protect against it, check out our blog post
479  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
480  */
481 contract ReentrancyGuard {
482     // Booleans are more expensive than uint256 or any type that takes up a full
483     // word because each write operation emits an extra SLOAD to first read the
484     // slot's contents, replace the bits taken up by the boolean, and then write
485     // back. This is the compiler's defense against contract upgrades and
486     // pointer aliasing, and it cannot be disabled.
487 
488     // The values being non-zero value makes deployment a bit more expensive,
489     // but in exchange the refund on every call to nonReentrant will be lower in
490     // amount. Since refunds are capped to a percentage of the total
491     // transaction's gas, it is best to keep them low in cases like this one, to
492     // increase the likelihood of the full refund coming into effect.
493     uint256 private constant _NOT_ENTERED = 1;
494     uint256 private constant _ENTERED = 2;
495 
496     uint256 private _status;
497 
498     constructor () internal {
499         _status = _NOT_ENTERED;
500     }
501 
502     /**
503      * @dev Prevents a contract from calling itself, directly or indirectly.
504      * Calling a `nonReentrant` function from another `nonReentrant`
505      * function is not supported. It is possible to prevent this from happening
506      * by making the `nonReentrant` function external, and make it call a
507      * `private` function that does the actual work.
508      */
509     modifier nonReentrant() {
510         // On the first call to nonReentrant, _notEntered will be true
511         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
512 
513         // Any calls to nonReentrant after this point will fail
514         _status = _ENTERED;
515 
516         _;
517 
518         // By storing the original value once again, a refund is triggered (see
519         // https://eips.ethereum.org/EIPS/eip-2200)
520         _status = _NOT_ENTERED;
521     }
522 }
523 
524 // 
525 /**
526  * @title SafeERC20
527  * @dev Wrappers around ERC20 operations that throw on failure (when the token
528  * contract returns false). Tokens that return no value (and instead revert or
529  * throw on failure) are also supported, non-reverting calls are assumed to be
530  * successful.
531  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
532  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
533  */
534 library SafeERC20 {
535     using SafeMath for uint256;
536     using Address for address;
537 
538     function safeTransfer(IERC20 token, address to, uint256 value) internal {
539         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
540     }
541 
542     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
543         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
544     }
545 
546     /**
547      * @dev Deprecated. This function has issues similar to the ones found in
548      * {IERC20-approve}, and its usage is discouraged.
549      *
550      * Whenever possible, use {safeIncreaseAllowance} and
551      * {safeDecreaseAllowance} instead.
552      */
553     function safeApprove(IERC20 token, address spender, uint256 value) internal {
554         // safeApprove should only be called when setting an initial allowance,
555         // or when resetting it to zero. To increase and decrease it, use
556         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
557         // solhint-disable-next-line max-line-length
558         require((value == 0) || (token.allowance(address(this), spender) == 0),
559             "SafeERC20: approve from non-zero to non-zero allowance"
560         );
561         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
562     }
563 
564     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
565         uint256 newAllowance = token.allowance(address(this), spender).add(value);
566         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
567     }
568 
569     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
570         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
571         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
572     }
573 
574     /**
575      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
576      * on the return value: the return value is optional (but if data is returned, it must not be false).
577      * @param token The token targeted by the call.
578      * @param data The call data (encoded using abi.encode or one of its variants).
579      */
580     function _callOptionalReturn(IERC20 token, bytes memory data) private {
581         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
582         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
583         // the target address contains contract code and also asserts for success in the low-level call.
584 
585         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
586         if (returndata.length > 0) { // Return data is optional
587             // solhint-disable-next-line max-line-length
588             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
589         }
590     }
591 }
592 
593 // 
594 /**
595  * @dev Implementation of the {IERC20} interface.
596  *
597  * This implementation is agnostic to the way tokens are created. This means
598  * that a supply mechanism has to be added in a derived contract using {_mint}.
599  * For a generic mechanism see {ERC20PresetMinterPauser}.
600  *
601  * TIP: For a detailed writeup see our guide
602  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
603  * to implement supply mechanisms].
604  *
605  * We have followed general OpenZeppelin guidelines: functions revert instead
606  * of returning `false` on failure. This behavior is nonetheless conventional
607  * and does not conflict with the expectations of ERC20 applications.
608  *
609  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
610  * This allows applications to reconstruct the allowance for all accounts just
611  * by listening to said events. Other implementations of the EIP may not emit
612  * these events, as it isn't required by the specification.
613  *
614  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
615  * functions have been added to mitigate the well-known issues around setting
616  * allowances. See {IERC20-approve}.
617  */
618 contract ERC20 is Context, IERC20 {
619     using SafeMath for uint256;
620     using Address for address;
621 
622     mapping (address => uint256) private _balances;
623 
624     mapping (address => mapping (address => uint256)) private _allowances;
625 
626     uint256 private _totalSupply;
627 
628     string private _name;
629     string private _symbol;
630     uint8 private _decimals;
631 
632     /**
633      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
634      * a default value of 18.
635      *
636      * To select a different value for {decimals}, use {_setupDecimals}.
637      *
638      * All three of these values are immutable: they can only be set once during
639      * construction.
640      */
641     constructor (string memory name, string memory symbol) public {
642         _name = name;
643         _symbol = symbol;
644         _decimals = 18;
645     }
646 
647     /**
648      * @dev Returns the name of the token.
649      */
650     function name() public view returns (string memory) {
651         return _name;
652     }
653 
654     /**
655      * @dev Returns the symbol of the token, usually a shorter version of the
656      * name.
657      */
658     function symbol() public view returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev Returns the number of decimals used to get its user representation.
664      * For example, if `decimals` equals `2`, a balance of `505` tokens should
665      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
666      *
667      * Tokens usually opt for a value of 18, imitating the relationship between
668      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
669      * called.
670      *
671      * NOTE: This information is only used for _display_ purposes: it in
672      * no way affects any of the arithmetic of the contract, including
673      * {IERC20-balanceOf} and {IERC20-transfer}.
674      */
675     function decimals() public view returns (uint8) {
676         return _decimals;
677     }
678 
679     /**
680      * @dev See {IERC20-totalSupply}.
681      */
682     function totalSupply() public view override returns (uint256) {
683         return _totalSupply;
684     }
685 
686     /**
687      * @dev See {IERC20-balanceOf}.
688      */
689     function balanceOf(address account) public view override returns (uint256) {
690         return _balances[account];
691     }
692 
693     /**
694      * @dev See {IERC20-transfer}.
695      *
696      * Requirements:
697      *
698      * - `recipient` cannot be the zero address.
699      * - the caller must have a balance of at least `amount`.
700      */
701     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
702         _transfer(_msgSender(), recipient, amount);
703         return true;
704     }
705 
706     /**
707      * @dev See {IERC20-allowance}.
708      */
709     function allowance(address owner, address spender) public view virtual override returns (uint256) {
710         return _allowances[owner][spender];
711     }
712 
713     /**
714      * @dev See {IERC20-approve}.
715      *
716      * Requirements:
717      *
718      * - `spender` cannot be the zero address.
719      */
720     function approve(address spender, uint256 amount) public virtual override returns (bool) {
721         _approve(_msgSender(), spender, amount);
722         return true;
723     }
724 
725     /**
726      * @dev See {IERC20-transferFrom}.
727      *
728      * Emits an {Approval} event indicating the updated allowance. This is not
729      * required by the EIP. See the note at the beginning of {ERC20};
730      *
731      * Requirements:
732      * - `sender` and `recipient` cannot be the zero address.
733      * - `sender` must have a balance of at least `amount`.
734      * - the caller must have allowance for ``sender``'s tokens of at least
735      * `amount`.
736      */
737     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
738         _transfer(sender, recipient, amount);
739         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
740         return true;
741     }
742 
743     /**
744      * @dev Atomically increases the allowance granted to `spender` by the caller.
745      *
746      * This is an alternative to {approve} that can be used as a mitigation for
747      * problems described in {IERC20-approve}.
748      *
749      * Emits an {Approval} event indicating the updated allowance.
750      *
751      * Requirements:
752      *
753      * - `spender` cannot be the zero address.
754      */
755     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
756         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
757         return true;
758     }
759 
760     /**
761      * @dev Atomically decreases the allowance granted to `spender` by the caller.
762      *
763      * This is an alternative to {approve} that can be used as a mitigation for
764      * problems described in {IERC20-approve}.
765      *
766      * Emits an {Approval} event indicating the updated allowance.
767      *
768      * Requirements:
769      *
770      * - `spender` cannot be the zero address.
771      * - `spender` must have allowance for the caller of at least
772      * `subtractedValue`.
773      */
774     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
775         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
776         return true;
777     }
778 
779     /**
780      * @dev Moves tokens `amount` from `sender` to `recipient`.
781      *
782      * This is internal function is equivalent to {transfer}, and can be used to
783      * e.g. implement automatic token fees, slashing mechanisms, etc.
784      *
785      * Emits a {Transfer} event.
786      *
787      * Requirements:
788      *
789      * - `sender` cannot be the zero address.
790      * - `recipient` cannot be the zero address.
791      * - `sender` must have a balance of at least `amount`.
792      */
793     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
794         require(sender != address(0), "ERC20: transfer from the zero address");
795         require(recipient != address(0), "ERC20: transfer to the zero address");
796 
797         _beforeTokenTransfer(sender, recipient, amount);
798 
799         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
800         _balances[recipient] = _balances[recipient].add(amount);
801         emit Transfer(sender, recipient, amount);
802     }
803 
804     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
805      * the total supply.
806      *
807      * Emits a {Transfer} event with `from` set to the zero address.
808      *
809      * Requirements
810      *
811      * - `to` cannot be the zero address.
812      */
813     function _mint(address account, uint256 amount) internal virtual {
814         require(account != address(0), "ERC20: mint to the zero address");
815 
816         _beforeTokenTransfer(address(0), account, amount);
817 
818         _totalSupply = _totalSupply.add(amount);
819         _balances[account] = _balances[account].add(amount);
820         emit Transfer(address(0), account, amount);
821     }
822 
823     /**
824      * @dev Destroys `amount` tokens from `account`, reducing the
825      * total supply.
826      *
827      * Emits a {Transfer} event with `to` set to the zero address.
828      *
829      * Requirements
830      *
831      * - `account` cannot be the zero address.
832      * - `account` must have at least `amount` tokens.
833      */
834     function _burn(address account, uint256 amount) internal virtual {
835         require(account != address(0), "ERC20: burn from the zero address");
836 
837         _beforeTokenTransfer(account, address(0), amount);
838 
839         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
840         _totalSupply = _totalSupply.sub(amount);
841         emit Transfer(account, address(0), amount);
842     }
843 
844     /**
845      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
846      *
847      * This internal function is equivalent to `approve`, and can be used to
848      * e.g. set automatic allowances for certain subsystems, etc.
849      *
850      * Emits an {Approval} event.
851      *
852      * Requirements:
853      *
854      * - `owner` cannot be the zero address.
855      * - `spender` cannot be the zero address.
856      */
857     function _approve(address owner, address spender, uint256 amount) internal virtual {
858         require(owner != address(0), "ERC20: approve from the zero address");
859         require(spender != address(0), "ERC20: approve to the zero address");
860 
861         _allowances[owner][spender] = amount;
862         emit Approval(owner, spender, amount);
863     }
864 
865     /**
866      * @dev Sets {decimals} to a value other than the default one of 18.
867      *
868      * WARNING: This function should only be called from the constructor. Most
869      * applications that interact with token contracts will not expect
870      * {decimals} to ever change, and may work incorrectly if it does.
871      */
872     function _setupDecimals(uint8 decimals_) internal {
873         _decimals = decimals_;
874     }
875 
876     /**
877      * @dev Hook that is called before any transfer of tokens. This includes
878      * minting and burning.
879      *
880      * Calling conditions:
881      *
882      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
883      * will be to transferred to `to`.
884      * - when `from` is zero, `amount` tokens will be minted for `to`.
885      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
886      * - `from` and `to` are never both zero.
887      *
888      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
889      */
890     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
891 }
892 
893 // 
894 contract YieldDelegatingVaultEvent2 {
895     /// @notice Emitted when set new treasury
896     event NewTreasury(address oldTreasury, address newTreasury);
897     
898     /// @notice Emitted when set new delegate percent
899     event NewDelegatePercent(uint256 oldDelegatePercent, uint256 newDelegatePercent);
900     
901     /// @notice Emitted when a minter is added by admin
902     event NewRewardPerToken(uint256 oldRewardPerToken, uint256 newRewardPerToken);
903 }
904 
905 // 
906 /**
907  * @dev Library for managing
908  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
909  * types.
910  *
911  * Sets have the following properties:
912  *
913  * - Elements are added, removed, and checked for existence in constant time
914  * (O(1)).
915  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
916  *
917  * ```
918  * contract Example {
919  *     // Add the library methods
920  *     using EnumerableSet for EnumerableSet.AddressSet;
921  *
922  *     // Declare a set state variable
923  *     EnumerableSet.AddressSet private mySet;
924  * }
925  * ```
926  *
927  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
928  * (`UintSet`) are supported.
929  */
930 library EnumerableSet {
931     // To implement this library for multiple types with as little code
932     // repetition as possible, we write it in terms of a generic Set type with
933     // bytes32 values.
934     // The Set implementation uses private functions, and user-facing
935     // implementations (such as AddressSet) are just wrappers around the
936     // underlying Set.
937     // This means that we can only create new EnumerableSets for types that fit
938     // in bytes32.
939 
940     struct Set {
941         // Storage of set values
942         bytes32[] _values;
943 
944         // Position of the value in the `values` array, plus 1 because index 0
945         // means a value is not in the set.
946         mapping (bytes32 => uint256) _indexes;
947     }
948 
949     /**
950      * @dev Add a value to a set. O(1).
951      *
952      * Returns true if the value was added to the set, that is if it was not
953      * already present.
954      */
955     function _add(Set storage set, bytes32 value) private returns (bool) {
956         if (!_contains(set, value)) {
957             set._values.push(value);
958             // The value is stored at length-1, but we add 1 to all indexes
959             // and use 0 as a sentinel value
960             set._indexes[value] = set._values.length;
961             return true;
962         } else {
963             return false;
964         }
965     }
966 
967     /**
968      * @dev Removes a value from a set. O(1).
969      *
970      * Returns true if the value was removed from the set, that is if it was
971      * present.
972      */
973     function _remove(Set storage set, bytes32 value) private returns (bool) {
974         // We read and store the value's index to prevent multiple reads from the same storage slot
975         uint256 valueIndex = set._indexes[value];
976 
977         if (valueIndex != 0) { // Equivalent to contains(set, value)
978             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
979             // the array, and then remove the last element (sometimes called as 'swap and pop').
980             // This modifies the order of the array, as noted in {at}.
981 
982             uint256 toDeleteIndex = valueIndex - 1;
983             uint256 lastIndex = set._values.length - 1;
984 
985             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
986             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
987 
988             bytes32 lastvalue = set._values[lastIndex];
989 
990             // Move the last value to the index where the value to delete is
991             set._values[toDeleteIndex] = lastvalue;
992             // Update the index for the moved value
993             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
994 
995             // Delete the slot where the moved value was stored
996             set._values.pop();
997 
998             // Delete the index for the deleted slot
999             delete set._indexes[value];
1000 
1001             return true;
1002         } else {
1003             return false;
1004         }
1005     }
1006 
1007     /**
1008      * @dev Returns true if the value is in the set. O(1).
1009      */
1010     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1011         return set._indexes[value] != 0;
1012     }
1013 
1014     /**
1015      * @dev Returns the number of values on the set. O(1).
1016      */
1017     function _length(Set storage set) private view returns (uint256) {
1018         return set._values.length;
1019     }
1020 
1021    /**
1022     * @dev Returns the value stored at position `index` in the set. O(1).
1023     *
1024     * Note that there are no guarantees on the ordering of values inside the
1025     * array, and it may change when more values are added or removed.
1026     *
1027     * Requirements:
1028     *
1029     * - `index` must be strictly less than {length}.
1030     */
1031     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1032         require(set._values.length > index, "EnumerableSet: index out of bounds");
1033         return set._values[index];
1034     }
1035 
1036     // AddressSet
1037 
1038     struct AddressSet {
1039         Set _inner;
1040     }
1041 
1042     /**
1043      * @dev Add a value to a set. O(1).
1044      *
1045      * Returns true if the value was added to the set, that is if it was not
1046      * already present.
1047      */
1048     function add(AddressSet storage set, address value) internal returns (bool) {
1049         return _add(set._inner, bytes32(uint256(value)));
1050     }
1051 
1052     /**
1053      * @dev Removes a value from a set. O(1).
1054      *
1055      * Returns true if the value was removed from the set, that is if it was
1056      * present.
1057      */
1058     function remove(AddressSet storage set, address value) internal returns (bool) {
1059         return _remove(set._inner, bytes32(uint256(value)));
1060     }
1061 
1062     /**
1063      * @dev Returns true if the value is in the set. O(1).
1064      */
1065     function contains(AddressSet storage set, address value) internal view returns (bool) {
1066         return _contains(set._inner, bytes32(uint256(value)));
1067     }
1068 
1069     /**
1070      * @dev Returns the number of values in the set. O(1).
1071      */
1072     function length(AddressSet storage set) internal view returns (uint256) {
1073         return _length(set._inner);
1074     }
1075 
1076    /**
1077     * @dev Returns the value stored at position `index` in the set. O(1).
1078     *
1079     * Note that there are no guarantees on the ordering of values inside the
1080     * array, and it may change when more values are added or removed.
1081     *
1082     * Requirements:
1083     *
1084     * - `index` must be strictly less than {length}.
1085     */
1086     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1087         return address(uint256(_at(set._inner, index)));
1088     }
1089 
1090 
1091     // UintSet
1092 
1093     struct UintSet {
1094         Set _inner;
1095     }
1096 
1097     /**
1098      * @dev Add a value to a set. O(1).
1099      *
1100      * Returns true if the value was added to the set, that is if it was not
1101      * already present.
1102      */
1103     function add(UintSet storage set, uint256 value) internal returns (bool) {
1104         return _add(set._inner, bytes32(value));
1105     }
1106 
1107     /**
1108      * @dev Removes a value from a set. O(1).
1109      *
1110      * Returns true if the value was removed from the set, that is if it was
1111      * present.
1112      */
1113     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1114         return _remove(set._inner, bytes32(value));
1115     }
1116 
1117     /**
1118      * @dev Returns true if the value is in the set. O(1).
1119      */
1120     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1121         return _contains(set._inner, bytes32(value));
1122     }
1123 
1124     /**
1125      * @dev Returns the number of values on the set. O(1).
1126      */
1127     function length(UintSet storage set) internal view returns (uint256) {
1128         return _length(set._inner);
1129     }
1130 
1131    /**
1132     * @dev Returns the value stored at position `index` in the set. O(1).
1133     *
1134     * Note that there are no guarantees on the ordering of values inside the
1135     * array, and it may change when more values are added or removed.
1136     *
1137     * Requirements:
1138     *
1139     * - `index` must be strictly less than {length}.
1140     */
1141     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1142         return uint256(_at(set._inner, index));
1143     }
1144 }
1145 
1146 // 
1147 /**
1148  * @dev Contract module that allows children to implement role-based access
1149  * control mechanisms.
1150  *
1151  * Roles are referred to by their `bytes32` identifier. These should be exposed
1152  * in the external API and be unique. The best way to achieve this is by
1153  * using `public constant` hash digests:
1154  *
1155  * ```
1156  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1157  * ```
1158  *
1159  * Roles can be used to represent a set of permissions. To restrict access to a
1160  * function call, use {hasRole}:
1161  *
1162  * ```
1163  * function foo() public {
1164  *     require(hasRole(MY_ROLE, msg.sender));
1165  *     ...
1166  * }
1167  * ```
1168  *
1169  * Roles can be granted and revoked dynamically via the {grantRole} and
1170  * {revokeRole} functions. Each role has an associated admin role, and only
1171  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1172  *
1173  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1174  * that only accounts with this role will be able to grant or revoke other
1175  * roles. More complex role relationships can be created by using
1176  * {_setRoleAdmin}.
1177  *
1178  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1179  * grant and revoke this role. Extra precautions should be taken to secure
1180  * accounts that have been granted it.
1181  */
1182 abstract contract AccessControl is Context {
1183     using EnumerableSet for EnumerableSet.AddressSet;
1184     using Address for address;
1185 
1186     struct RoleData {
1187         EnumerableSet.AddressSet members;
1188         bytes32 adminRole;
1189     }
1190 
1191     mapping (bytes32 => RoleData) private _roles;
1192 
1193     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1194 
1195     /**
1196      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1197      *
1198      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1199      * {RoleAdminChanged} not being emitted signaling this.
1200      *
1201      * _Available since v3.1._
1202      */
1203     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1204 
1205     /**
1206      * @dev Emitted when `account` is granted `role`.
1207      *
1208      * `sender` is the account that originated the contract call, an admin role
1209      * bearer except when using {_setupRole}.
1210      */
1211     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1212 
1213     /**
1214      * @dev Emitted when `account` is revoked `role`.
1215      *
1216      * `sender` is the account that originated the contract call:
1217      *   - if using `revokeRole`, it is the admin role bearer
1218      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1219      */
1220     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1221 
1222     /**
1223      * @dev Returns `true` if `account` has been granted `role`.
1224      */
1225     function hasRole(bytes32 role, address account) public view returns (bool) {
1226         return _roles[role].members.contains(account);
1227     }
1228 
1229     /**
1230      * @dev Returns the number of accounts that have `role`. Can be used
1231      * together with {getRoleMember} to enumerate all bearers of a role.
1232      */
1233     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1234         return _roles[role].members.length();
1235     }
1236 
1237     /**
1238      * @dev Returns one of the accounts that have `role`. `index` must be a
1239      * value between 0 and {getRoleMemberCount}, non-inclusive.
1240      *
1241      * Role bearers are not sorted in any particular way, and their ordering may
1242      * change at any point.
1243      *
1244      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1245      * you perform all queries on the same block. See the following
1246      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1247      * for more information.
1248      */
1249     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1250         return _roles[role].members.at(index);
1251     }
1252 
1253     /**
1254      * @dev Returns the admin role that controls `role`. See {grantRole} and
1255      * {revokeRole}.
1256      *
1257      * To change a role's admin, use {_setRoleAdmin}.
1258      */
1259     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1260         return _roles[role].adminRole;
1261     }
1262 
1263     /**
1264      * @dev Grants `role` to `account`.
1265      *
1266      * If `account` had not been already granted `role`, emits a {RoleGranted}
1267      * event.
1268      *
1269      * Requirements:
1270      *
1271      * - the caller must have ``role``'s admin role.
1272      */
1273     function grantRole(bytes32 role, address account) public virtual {
1274         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1275 
1276         _grantRole(role, account);
1277     }
1278 
1279     /**
1280      * @dev Revokes `role` from `account`.
1281      *
1282      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1283      *
1284      * Requirements:
1285      *
1286      * - the caller must have ``role``'s admin role.
1287      */
1288     function revokeRole(bytes32 role, address account) public virtual {
1289         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1290 
1291         _revokeRole(role, account);
1292     }
1293 
1294     /**
1295      * @dev Revokes `role` from the calling account.
1296      *
1297      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1298      * purpose is to provide a mechanism for accounts to lose their privileges
1299      * if they are compromised (such as when a trusted device is misplaced).
1300      *
1301      * If the calling account had been granted `role`, emits a {RoleRevoked}
1302      * event.
1303      *
1304      * Requirements:
1305      *
1306      * - the caller must be `account`.
1307      */
1308     function renounceRole(bytes32 role, address account) public virtual {
1309         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1310 
1311         _revokeRole(role, account);
1312     }
1313 
1314     /**
1315      * @dev Grants `role` to `account`.
1316      *
1317      * If `account` had not been already granted `role`, emits a {RoleGranted}
1318      * event. Note that unlike {grantRole}, this function doesn't perform any
1319      * checks on the calling account.
1320      *
1321      * [WARNING]
1322      * ====
1323      * This function should only be called from the constructor when setting
1324      * up the initial roles for the system.
1325      *
1326      * Using this function in any other way is effectively circumventing the admin
1327      * system imposed by {AccessControl}.
1328      * ====
1329      */
1330     function _setupRole(bytes32 role, address account) internal virtual {
1331         _grantRole(role, account);
1332     }
1333 
1334     /**
1335      * @dev Sets `adminRole` as ``role``'s admin role.
1336      *
1337      * Emits a {RoleAdminChanged} event.
1338      */
1339     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1340         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1341         _roles[role].adminRole = adminRole;
1342     }
1343 
1344     function _grantRole(bytes32 role, address account) private {
1345         if (_roles[role].members.add(account)) {
1346             emit RoleGranted(role, account, _msgSender());
1347         }
1348     }
1349 
1350     function _revokeRole(bytes32 role, address account) private {
1351         if (_roles[role].members.remove(account)) {
1352             emit RoleRevoked(role, account, _msgSender());
1353         }
1354     }
1355 }
1356 
1357 // 
1358 contract YDVRewardsDistributor is AccessControl, Ownable {
1359     using SafeERC20 for IERC20;
1360     using Address for address;
1361 
1362     IERC20 public rewardToken;
1363     address[] public ydvs;
1364     bytes32 public constant YDV_REWARDS = keccak256("YDV_REWARDS");
1365     
1366     constructor(address _rally) public {
1367         rewardToken = IERC20(_rally);
1368         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1369     }
1370 
1371     function transferReward(uint256 _amount) external {
1372         require (hasRole(YDV_REWARDS, msg.sender), "only ydv rewards");
1373         rewardToken.safeTransfer(msg.sender, _amount);
1374     }
1375 
1376     function addYDV(address _ydv) external onlyOwner {
1377         grantRole(YDV_REWARDS, _ydv);
1378         ydvs.push(_ydv);
1379     }
1380 
1381     function ydvsLength() external view returns (uint256) {
1382         return ydvs.length;
1383     }
1384 }
1385 
1386 // 
1387 interface Vault {
1388     function balanceOf(address) external view returns (uint256);
1389     function token() external view returns (address);
1390     function claimInsurance() external;
1391     function getPricePerFullShare() external view returns (uint256);
1392     function deposit(uint) external;
1393     function withdraw(uint) external;
1394 }
1395 
1396 // 
1397 contract YDVErrorReporter {
1398     enum Error {
1399         NO_ERROR,
1400         UNAUTHORIZED,
1401         BAD_INPUT,
1402         REJECTION
1403     }
1404 
1405     enum FailureInfo {
1406         SET_INDIVIDUAL_SOFT_CAP_CHECK,
1407         SET_GLOBAL_SOFT_CAP_CHECK
1408     }
1409 
1410     /**
1411       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
1412       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
1413       **/
1414     event Failure(uint error, uint info, uint detail);
1415 
1416     /**
1417       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
1418       */
1419     function fail(Error err, FailureInfo info) internal returns (uint) {
1420         emit Failure(uint(err), uint(info), 0);
1421 
1422         return uint(err);
1423     }
1424 
1425     /**
1426       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
1427       */
1428     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
1429         emit Failure(uint(err), uint(info), opaqueError);
1430 
1431         return uint(err);
1432     }
1433 }
1434 
1435 // 
1436 contract RallyToken is ERC20 {
1437 
1438     //15 billion fixed token supply with default 18 decimals
1439     uint256 public constant TOKEN_SUPPLY = 15 * 10**9 * 10**18;
1440 
1441     constructor (
1442         address _escrow
1443     ) public ERC20(
1444 	"Rally",
1445 	"RLY"
1446     ) {
1447         _mint(_escrow, TOKEN_SUPPLY);	
1448     }
1449 }
1450 
1451 // 
1452 contract NoMintLiquidityRewardPools is Ownable {
1453     using SafeMath for uint256;
1454     using SafeERC20 for IERC20;
1455 
1456     // Info of each user.
1457     struct UserInfo {
1458         uint256 amount;     // How many LP tokens the user has provided.
1459         uint256 rewardDebt; // Reward debt. See explanation below.
1460         //
1461         // We do some fancy math here. Basically, any point in time, the amount of RLY
1462         // entitled to a user but is pending to be distributed is:
1463         //
1464         //   pending reward = (user.amount * pool.accRallyPerShare) - user.rewardDebt
1465         //
1466         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1467         //   1. The pool's `accRallyPerShare` (and `lastRewardBlock`) gets updated.
1468         //   2. User receives the pending reward sent to his/her address.
1469         //   3. User's `amount` gets updated.
1470         //   4. User's `rewardDebt` gets updated.
1471     }
1472 
1473     // Info of each pool.
1474     struct PoolInfo {
1475         IERC20 lpToken;           // Address of LP token contract.
1476         uint256 allocPoint;       // How many allocation points assigned to this pool. RLYs to distribute per block.
1477         uint256 lastRewardBlock;  // Last block number that RLYs distribution occurs.
1478         uint256 accRallyPerShare; // Accumulated RLYs per share, times 1e12. See below.
1479     }
1480 
1481     // The RALLY TOKEN!
1482     RallyToken public rally;
1483     // RLY tokens created per block.
1484     uint256 public rallyPerBlock;
1485 
1486     // Info of each pool.
1487     PoolInfo[] public poolInfo;
1488     // Info of each user that stakes LP tokens.
1489     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1490     // Total allocation points. Must be the sum of all allocation points in all pools.
1491     uint256 public totalAllocPoint = 0;
1492     // The block number when RLY mining starts.
1493     uint256 public startBlock;
1494 
1495     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1496     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1497     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1498 
1499     constructor(
1500         RallyToken _rally,
1501         uint256 _rallyPerBlock,
1502         uint256 _startBlock
1503     ) public {
1504         rally = _rally;
1505         rallyPerBlock = _rallyPerBlock;
1506         startBlock = _startBlock;
1507     }
1508 
1509     function poolLength() external view returns (uint256) {
1510         return poolInfo.length;
1511     }
1512 
1513     // Add a new lp to the pool. Can only be called by the owner.
1514     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1515     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1516         if (_withUpdate) {
1517             massUpdatePools();
1518         }
1519         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1520         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1521         poolInfo.push(PoolInfo({
1522             lpToken: _lpToken,
1523             allocPoint: _allocPoint,
1524             lastRewardBlock: lastRewardBlock,
1525             accRallyPerShare: 0
1526         }));
1527     }
1528 
1529     // Update the given pool's RLY allocation point. Can only be called by the owner.
1530     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1531         if (_withUpdate) {
1532             massUpdatePools();
1533         }
1534         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1535         poolInfo[_pid].allocPoint = _allocPoint;
1536     }
1537 
1538     // update the rate at which RLY is allocated to rewards, can only be called by the owner
1539     function setRallyPerBlock(uint256 _rallyPerBlock) public onlyOwner {
1540         massUpdatePools();
1541         rallyPerBlock = _rallyPerBlock;
1542     }
1543 
1544     // View function to see pending RLYs on frontend.
1545     function pendingRally(uint256 _pid, address _user) external view returns (uint256) {
1546         PoolInfo storage pool = poolInfo[_pid];
1547         UserInfo storage user = userInfo[_pid][_user];
1548         uint256 accRallyPerShare = pool.accRallyPerShare;
1549         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1550         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1551             uint256 multiplier = block.number.sub(pool.lastRewardBlock);
1552             uint256 rallyReward = multiplier.mul(rallyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1553             accRallyPerShare = accRallyPerShare.add(rallyReward.mul(1e12).div(lpSupply));
1554         }
1555         return user.amount.mul(accRallyPerShare).div(1e12).sub(user.rewardDebt);
1556     }
1557 
1558     // Update reward variables for all pools. Be careful of gas spending!
1559     function massUpdatePools() public {
1560         uint256 length = poolInfo.length;
1561         for (uint256 pid = 0; pid < length; ++pid) {
1562             updatePool(pid);
1563         }
1564     }
1565 
1566     // Update reward variables of the given pool to be up-to-date.
1567     // No new RLY are minted, distribution is dependent on sufficient RLY tokens being sent to this contract
1568     function updatePool(uint256 _pid) public {
1569         PoolInfo storage pool = poolInfo[_pid];
1570         if (block.number <= pool.lastRewardBlock) {
1571             return;
1572         }
1573         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1574         if (lpSupply == 0) {
1575             pool.lastRewardBlock = block.number;
1576             return;
1577         }
1578         uint256 multiplier = block.number.sub(pool.lastRewardBlock);
1579         uint256 rallyReward = multiplier.mul(rallyPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1580         pool.accRallyPerShare = pool.accRallyPerShare.add(rallyReward.mul(1e12).div(lpSupply));
1581         pool.lastRewardBlock = block.number;
1582     }
1583 
1584     // Deposit LP tokens to pool for RLY allocation.
1585     function deposit(uint256 _pid, uint256 _amount) public {
1586         PoolInfo storage pool = poolInfo[_pid];
1587         UserInfo storage user = userInfo[_pid][msg.sender];
1588         updatePool(_pid);
1589         if (user.amount > 0) {
1590             uint256 pending = user.amount.mul(pool.accRallyPerShare).div(1e12).sub(user.rewardDebt);
1591             if(pending > 0) {
1592                 safeRallyTransfer(msg.sender, pending);
1593             }
1594         }
1595         if(_amount > 0) {
1596             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1597             user.amount = user.amount.add(_amount);
1598         }
1599         user.rewardDebt = user.amount.mul(pool.accRallyPerShare).div(1e12);
1600         emit Deposit(msg.sender, _pid, _amount);
1601     }
1602 
1603     // Withdraw LP tokens from pool.
1604     function withdraw(uint256 _pid, uint256 _amount) public {
1605         PoolInfo storage pool = poolInfo[_pid];
1606         UserInfo storage user = userInfo[_pid][msg.sender];
1607         require(user.amount >= _amount, "withdraw: not good");
1608         updatePool(_pid);
1609         uint256 pending = user.amount.mul(pool.accRallyPerShare).div(1e12).sub(user.rewardDebt);
1610         if(pending > 0) {
1611             safeRallyTransfer(msg.sender, pending);
1612         }
1613         if(_amount > 0) {
1614             user.amount = user.amount.sub(_amount);
1615             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1616         }
1617         user.rewardDebt = user.amount.mul(pool.accRallyPerShare).div(1e12);
1618         emit Withdraw(msg.sender, _pid, _amount);
1619     }
1620 
1621     // Withdraw without caring about rewards. EMERGENCY ONLY.
1622     function emergencyWithdraw(uint256 _pid) public {
1623         PoolInfo storage pool = poolInfo[_pid];
1624         UserInfo storage user = userInfo[_pid][msg.sender];
1625         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1626         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1627         user.amount = 0;
1628         user.rewardDebt = 0;
1629     }
1630 
1631     // Safe RLY transfer function, just in case pool does not have enough RLY; either rounding error or we're not supplying more rewards
1632     function safeRallyTransfer(address _to, uint256 _amount) internal {
1633         uint256 rallyBal = rally.balanceOf(address(this));
1634         if (_amount > rallyBal) {
1635             rally.transfer(_to, rallyBal);
1636         } else {
1637             rally.transfer(_to, _amount);
1638         }
1639     }
1640 }
1641 
1642 // 
1643 contract YieldDelegatingVaultStorage2 {
1644     address public vault;
1645     YDVRewardsDistributor rewards;
1646     IERC20 public rally;
1647     address public treasury;
1648     IERC20 public token;
1649     uint256 public delegatePercent;
1650     
1651     mapping(address => uint256) public rewardDebt;
1652     uint256 public totalDeposits;
1653 
1654     uint256 public rewardPerToken;
1655     uint256 public accRallyPerShare;
1656 
1657     bool public lrEnabled;
1658     uint256 public pid;
1659     NoMintLiquidityRewardPools lrPools;
1660 }
1661 
1662 // 
1663 contract YieldDelegatingVault2 is ERC20, YieldDelegatingVaultStorage2, YieldDelegatingVaultEvent2, Ownable, ReentrancyGuard {
1664     using SafeERC20 for IERC20;
1665     using Address for address;
1666     using SafeMath for uint256;
1667 
1668     constructor (
1669         address _vault,
1670         address _rewards,
1671         address _treasury,
1672         uint256 _delegatePercent,
1673         uint256 _rewardPerToken
1674     ) public ERC20(
1675         string(abi.encodePacked("rally delegating ", ERC20(Vault(_vault).token()).name())),
1676         string(abi.encodePacked("rd", ERC20(Vault(_vault).token()).symbol()))
1677     ) {
1678         _setupDecimals(ERC20(Vault(_vault).token()).decimals());
1679         token = IERC20(Vault(_vault).token()); //token being deposited in the referenced vault
1680         vault = _vault; //address of the vault we're proxying
1681         rewards = YDVRewardsDistributor(_rewards);
1682         rally = rewards.rewardToken();
1683 	treasury = _treasury;
1684         delegatePercent = _delegatePercent;
1685         rewardPerToken = _rewardPerToken;
1686 	totalDeposits = 0;
1687         accRallyPerShare = 0;
1688         lrEnabled = false;
1689     }
1690 
1691     function setTreasury(address newTreasury) public onlyOwner {
1692         require(newTreasury != address(0), "treasure should be valid address");
1693 
1694         address oldTreasury = treasury;
1695         treasury = newTreasury;
1696 
1697         emit NewTreasury(oldTreasury, newTreasury);
1698     }
1699 
1700     function setNewRewardPerToken(uint256 newRewardPerToken) public onlyOwner {
1701         uint256 oldRewardPerToken = rewardPerToken;
1702         rewardPerToken = newRewardPerToken;
1703 
1704         emit NewRewardPerToken(oldRewardPerToken, newRewardPerToken);
1705     }
1706 
1707     function earned(address account) public view returns (uint256) {
1708         return balanceForRewardsCalc(account).mul(accRallyPerShare).div(1e12).sub(rewardDebt[account]);
1709     }
1710 
1711     function balance() public view returns (uint256) {
1712         return (IERC20(vault)).balanceOf(address(this)); //how many shares do we have in the vault we are delegating to
1713     }
1714 
1715     //for the purpose of rewards calculations, a user's balance is the total of what's in their wallet
1716     //and what they have deposited in the rewards pool (if it's active).
1717     //transfer restriction ensures accuracy of this sum
1718     function balanceForRewardsCalc(address account) internal view returns (uint256) {
1719         if (lrEnabled) {
1720           (uint256 amount, ) = lrPools.userInfo(pid, account);
1721           return balanceOf(account).add(amount); 
1722         }
1723         return balanceOf(account);
1724     }
1725 
1726     function depositAll() external {
1727         deposit(token.balanceOf(msg.sender));
1728     }
1729 
1730     function deposit(uint256 _amount) public nonReentrant {
1731         uint256 pending = earned(msg.sender);
1732         if (pending > 0) {
1733             safeRallyTransfer(msg.sender, pending);
1734         }
1735         uint256 _pool = balance();
1736 
1737         uint256 _before = token.balanceOf(address(this));
1738         token.safeTransferFrom(msg.sender, address(this), _amount);
1739         uint256 _after = token.balanceOf(address(this));
1740         _amount = _after.sub(_before);
1741 
1742         totalDeposits = totalDeposits.add(_amount);
1743 
1744         token.approve(vault, _amount);
1745         Vault(vault).deposit(_amount);
1746         uint256 _after_pool = balance();
1747 		
1748         uint256 _new_shares = _after_pool.sub(_pool); //new vault tokens representing my added vault shares
1749 
1750         //translate vault shares into delegating vault shares
1751         uint256 shares = 0;
1752         if (totalSupply() == 0) {
1753             shares = _new_shares;
1754         } else {
1755             shares = (_new_shares.mul(totalSupply())).div(_pool);
1756         }
1757         _mint(msg.sender, shares);
1758         rewardDebt[msg.sender] = balanceForRewardsCalc(msg.sender).mul(accRallyPerShare).div(1e12);
1759     }
1760 
1761     function deposityToken(uint256 _yamount) public nonReentrant {
1762         uint256 pending = earned(msg.sender);
1763         if (pending > 0) {
1764             safeRallyTransfer(msg.sender, pending);
1765         }
1766 
1767         uint256 _before = IERC20(vault).balanceOf(address(this));
1768         IERC20(vault).safeTransferFrom(msg.sender, address(this), _yamount);
1769         uint256 _after = IERC20(vault).balanceOf(address(this));
1770         _yamount = _after.sub(_before);
1771 
1772         uint _underlyingAmount = _yamount.mul(Vault(vault).getPricePerFullShare()).div(1e18);
1773         totalDeposits = totalDeposits.add(_underlyingAmount);
1774 		
1775         //translate vault shares into delegating vault shares
1776         uint256 shares = 0;
1777         if (totalSupply() == 0) {
1778             shares = _yamount;
1779         } else {
1780             shares = (_yamount.mul(totalSupply())).div(_before);
1781         }
1782         _mint(msg.sender, shares);
1783         rewardDebt[msg.sender] = balanceForRewardsCalc(msg.sender).mul(accRallyPerShare).div(1e12);
1784     }
1785 
1786     function withdrawAll() external {
1787         withdraw(balanceOf(msg.sender));
1788     }
1789 
1790     function withdraw(uint256 _shares) public nonReentrant {
1791         uint256 pending = earned(msg.sender);
1792         if (pending > 0) {
1793             safeRallyTransfer(msg.sender, pending);
1794         }
1795 
1796         uint256 r = (balance().mul(_shares)).div(totalSupply());
1797         _burn(msg.sender, _shares);
1798         safeReduceTotalDeposits(r.mul(Vault(vault).getPricePerFullShare()).div(1e18));
1799 
1800         rewardDebt[msg.sender] = balanceForRewardsCalc(msg.sender).mul(accRallyPerShare).div(1e12);
1801         
1802         uint256 _before = token.balanceOf(address(this));
1803         Vault(vault).withdraw(r);
1804         uint256 _after = token.balanceOf(address(this));
1805 
1806         uint256 toTransfer = _after.sub(_before);
1807         token.safeTransfer(msg.sender, toTransfer);
1808     }
1809 
1810     //in case of rounding errors converting between vault tokens and underlying value
1811     function safeReduceTotalDeposits(uint256 _amount) internal {
1812         if (_amount > totalDeposits) {
1813           totalDeposits = 0;
1814         } else {
1815           totalDeposits = totalDeposits.sub(_amount);
1816         }
1817     }
1818 
1819     function withdrawyToken(uint256 _shares) public nonReentrant {
1820         uint256 pending = earned(msg.sender);
1821         if (pending > 0) {
1822             safeRallyTransfer(msg.sender, pending);
1823         }
1824         uint256 r = (balance().mul(_shares)).div(totalSupply());
1825         _burn(msg.sender, _shares);
1826         rewardDebt[msg.sender] = balanceForRewardsCalc(msg.sender).mul(accRallyPerShare).div(1e12);
1827         uint256 _amount = r.mul(Vault(vault).getPricePerFullShare()).div(1e18);
1828 
1829         safeReduceTotalDeposits(_amount);
1830 
1831         IERC20(vault).safeTransfer(msg.sender, r);
1832     }
1833 
1834     // Safe RLY transfer function, just in case pool does not have enough RLY due to rounding error
1835     function safeRallyTransfer(address _to, uint256 _amount) internal {
1836         uint256 rallyBal = rally.balanceOf(address(this));
1837         if (_amount > rallyBal) {
1838             rally.transfer(_to, rallyBal);
1839         } else {
1840             rally.transfer(_to, _amount);
1841         }
1842     }
1843 
1844     //how much are our shares of the underlying vault worth relative to the deposit value? returns value denominated in vault tokens
1845     function availableYield() public view returns (uint256) {
1846         uint256 totalValue = balance().mul(Vault(vault).getPricePerFullShare()).div(1e18);
1847         if (totalValue > totalDeposits) {
1848             uint256 earnings = totalValue.sub(totalDeposits);
1849             return earnings.mul(1e18).div(Vault(vault).getPricePerFullShare());
1850         }
1851         return 0;
1852     }
1853 
1854     //transfer accumulated yield to treasury, update totalDeposits to ensure availableYield following
1855     //harvest is 0, and increase accumulated rally rewards
1856     //harvest fails if we're unable to fund rewards
1857     function harvest() public onlyOwner {
1858         uint256 _availableYield = availableYield();
1859         if (_availableYield > 0) {
1860             uint256 rallyReward = _availableYield.mul(delegatePercent).div(10000).mul(rewardPerToken).div(1e18);
1861             rewards.transferReward(rallyReward);
1862             IERC20(vault).safeTransfer(treasury, _availableYield.mul(delegatePercent).div(10000));
1863             accRallyPerShare = accRallyPerShare.add(rallyReward.mul(1e12).div(totalSupply()));
1864             totalDeposits = balance().mul(Vault(vault).getPricePerFullShare()).div(1e18);
1865         }
1866     }
1867 
1868     //one way ticket and only callable once
1869     function enableLiquidityRewards(address _lrPools, uint256 _pid) public onlyOwner {
1870       (IERC20 lpToken,,,) =  NoMintLiquidityRewardPools(_lrPools).poolInfo(_pid);
1871       require(address(lpToken) == address(this), "invalid liquidity rewards setup");
1872       require(lrEnabled == false, "liquidity rewards already enabled");
1873       lrEnabled = true;
1874       lrPools = NoMintLiquidityRewardPools(_lrPools);
1875       pid = _pid;
1876     }
1877 
1878     //override underlying _transfer implementation; YDV shares can only be transferred to/from the liquidity rewards pool
1879     function _transfer(address sender, address recipient, uint256 amount) internal override {
1880       require(lrEnabled, "transfer rejected");
1881       require(sender == address(lrPools) || recipient == address(lrPools), "transfer rejected");
1882       super._transfer(sender, recipient, amount);
1883     }
1884 }