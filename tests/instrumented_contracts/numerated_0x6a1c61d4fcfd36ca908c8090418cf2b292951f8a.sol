1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity ^0.6.0;
6 
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/GSN/Context.sol
465 
466 
467 
468 pragma solidity ^0.6.0;
469 
470 /*
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with GSN meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address payable) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes memory) {
486         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
487         return msg.data;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/access/Ownable.sol
492 
493 
494 
495 pragma solidity ^0.6.0;
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515      * @dev Initializes the contract setting the deployer as the initial owner.
516      */
517     constructor () internal {
518         address msgSender = _msgSender();
519         _owner = msgSender;
520         emit OwnershipTransferred(address(0), msgSender);
521     }
522 
523     /**
524      * @dev Returns the address of the current owner.
525      */
526     function owner() public view returns (address) {
527         return _owner;
528     }
529 
530     /**
531      * @dev Throws if called by any account other than the owner.
532      */
533     modifier onlyOwner() {
534         require(_owner == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537 
538     /**
539      * @dev Leaves the contract without owner. It will not be possible to call
540      * `onlyOwner` functions anymore. Can only be called by the current owner.
541      *
542      * NOTE: Renouncing ownership will leave the contract without an owner,
543      * thereby removing any functionality that is only available to the owner.
544      */
545     function renounceOwnership() public virtual onlyOwner {
546         emit OwnershipTransferred(_owner, address(0));
547         _owner = address(0);
548     }
549 
550     /**
551      * @dev Transfers ownership of the contract to a new account (`newOwner`).
552      * Can only be called by the current owner.
553      */
554     function transferOwnership(address newOwner) public virtual onlyOwner {
555         require(newOwner != address(0), "Ownable: new owner is the zero address");
556         emit OwnershipTransferred(_owner, newOwner);
557         _owner = newOwner;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
562 
563 
564 
565 pragma solidity ^0.6.0;
566 
567 
568 
569 
570 
571 /**
572  * @dev Implementation of the {IERC20} interface.
573  *
574  * This implementation is agnostic to the way tokens are created. This means
575  * that a supply mechanism has to be added in a derived contract using {_mint}.
576  * For a generic mechanism see {ERC20PresetMinterPauser}.
577  *
578  * TIP: For a detailed writeup see our guide
579  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
580  * to implement supply mechanisms].
581  *
582  * We have followed general OpenZeppelin guidelines: functions revert instead
583  * of returning `false` on failure. This behavior is nonetheless conventional
584  * and does not conflict with the expectations of ERC20 applications.
585  *
586  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
587  * This allows applications to reconstruct the allowance for all accounts just
588  * by listening to said events. Other implementations of the EIP may not emit
589  * these events, as it isn't required by the specification.
590  *
591  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
592  * functions have been added to mitigate the well-known issues around setting
593  * allowances. See {IERC20-approve}.
594  */
595 contract ERC20 is Context, IERC20 {
596     using SafeMath for uint256;
597     using Address for address;
598 
599     mapping (address => uint256) private _balances;
600 
601     mapping (address => mapping (address => uint256)) private _allowances;
602 
603     uint256 private _totalSupply;
604 
605     string private _name;
606     string private _symbol;
607     uint8 private _decimals;
608 
609     /**
610      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
611      * a default value of 18.
612      *
613      * To select a different value for {decimals}, use {_setupDecimals}.
614      *
615      * All three of these values are immutable: they can only be set once during
616      * construction.
617      */
618     constructor (string memory name, string memory symbol) public {
619         _name = name;
620         _symbol = symbol;
621         _decimals = 18;
622     }
623 
624     /**
625      * @dev Returns the name of the token.
626      */
627     function name() public view returns (string memory) {
628         return _name;
629     }
630 
631     /**
632      * @dev Returns the symbol of the token, usually a shorter version of the
633      * name.
634      */
635     function symbol() public view returns (string memory) {
636         return _symbol;
637     }
638 
639     /**
640      * @dev Returns the number of decimals used to get its user representation.
641      * For example, if `decimals` equals `2`, a balance of `505` tokens should
642      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
643      *
644      * Tokens usually opt for a value of 18, imitating the relationship between
645      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
646      * called.
647      *
648      * NOTE: This information is only used for _display_ purposes: it in
649      * no way affects any of the arithmetic of the contract, including
650      * {IERC20-balanceOf} and {IERC20-transfer}.
651      */
652     function decimals() public view returns (uint8) {
653         return _decimals;
654     }
655 
656     /**
657      * @dev See {IERC20-totalSupply}.
658      */
659     function totalSupply() public view override returns (uint256) {
660         return _totalSupply;
661     }
662 
663     /**
664      * @dev See {IERC20-balanceOf}.
665      */
666     function balanceOf(address account) public view override returns (uint256) {
667         return _balances[account];
668     }
669 
670     /**
671      * @dev See {IERC20-transfer}.
672      *
673      * Requirements:
674      *
675      * - `recipient` cannot be the zero address.
676      * - the caller must have a balance of at least `amount`.
677      */
678     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
679         _transfer(_msgSender(), recipient, amount);
680         return true;
681     }
682 
683     /**
684      * @dev See {IERC20-allowance}.
685      */
686     function allowance(address owner, address spender) public view virtual override returns (uint256) {
687         return _allowances[owner][spender];
688     }
689 
690     /**
691      * @dev See {IERC20-approve}.
692      *
693      * Requirements:
694      *
695      * - `spender` cannot be the zero address.
696      */
697     function approve(address spender, uint256 amount) public virtual override returns (bool) {
698         _approve(_msgSender(), spender, amount);
699         return true;
700     }
701 
702     /**
703      * @dev See {IERC20-transferFrom}.
704      *
705      * Emits an {Approval} event indicating the updated allowance. This is not
706      * required by the EIP. See the note at the beginning of {ERC20};
707      *
708      * Requirements:
709      * - `sender` and `recipient` cannot be the zero address.
710      * - `sender` must have a balance of at least `amount`.
711      * - the caller must have allowance for ``sender``'s tokens of at least
712      * `amount`.
713      */
714     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
715         _transfer(sender, recipient, amount);
716         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
717         return true;
718     }
719 
720     /**
721      * @dev Atomically increases the allowance granted to `spender` by the caller.
722      *
723      * This is an alternative to {approve} that can be used as a mitigation for
724      * problems described in {IERC20-approve}.
725      *
726      * Emits an {Approval} event indicating the updated allowance.
727      *
728      * Requirements:
729      *
730      * - `spender` cannot be the zero address.
731      */
732     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
733         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
734         return true;
735     }
736 
737     /**
738      * @dev Atomically decreases the allowance granted to `spender` by the caller.
739      *
740      * This is an alternative to {approve} that can be used as a mitigation for
741      * problems described in {IERC20-approve}.
742      *
743      * Emits an {Approval} event indicating the updated allowance.
744      *
745      * Requirements:
746      *
747      * - `spender` cannot be the zero address.
748      * - `spender` must have allowance for the caller of at least
749      * `subtractedValue`.
750      */
751     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
752         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
753         return true;
754     }
755 
756     /**
757      * @dev Moves tokens `amount` from `sender` to `recipient`.
758      *
759      * This is internal function is equivalent to {transfer}, and can be used to
760      * e.g. implement automatic token fees, slashing mechanisms, etc.
761      *
762      * Emits a {Transfer} event.
763      *
764      * Requirements:
765      *
766      * - `sender` cannot be the zero address.
767      * - `recipient` cannot be the zero address.
768      * - `sender` must have a balance of at least `amount`.
769      */
770     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
771         require(sender != address(0), "ERC20: transfer from the zero address");
772         require(recipient != address(0), "ERC20: transfer to the zero address");
773 
774         _beforeTokenTransfer(sender, recipient, amount);
775 
776         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
777         _balances[recipient] = _balances[recipient].add(amount);
778         emit Transfer(sender, recipient, amount);
779     }
780 
781     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
782      * the total supply.
783      *
784      * Emits a {Transfer} event with `from` set to the zero address.
785      *
786      * Requirements
787      *
788      * - `to` cannot be the zero address.
789      */
790     function _mint(address account, uint256 amount) internal virtual {
791         require(account != address(0), "ERC20: mint to the zero address");
792 
793         _beforeTokenTransfer(address(0), account, amount);
794 
795         _totalSupply = _totalSupply.add(amount);
796         _balances[account] = _balances[account].add(amount);
797         emit Transfer(address(0), account, amount);
798     }
799 
800     /**
801      * @dev Destroys `amount` tokens from `account`, reducing the
802      * total supply.
803      *
804      * Emits a {Transfer} event with `to` set to the zero address.
805      *
806      * Requirements
807      *
808      * - `account` cannot be the zero address.
809      * - `account` must have at least `amount` tokens.
810      */
811     function _burn(address account, uint256 amount) internal virtual {
812         require(account != address(0), "ERC20: burn from the zero address");
813 
814         _beforeTokenTransfer(account, address(0), amount);
815 
816         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
817         _totalSupply = _totalSupply.sub(amount);
818         emit Transfer(account, address(0), amount);
819     }
820 
821     /**
822      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
823      *
824      * This is internal function is equivalent to `approve`, and can be used to
825      * e.g. set automatic allowances for certain subsystems, etc.
826      *
827      * Emits an {Approval} event.
828      *
829      * Requirements:
830      *
831      * - `owner` cannot be the zero address.
832      * - `spender` cannot be the zero address.
833      */
834     function _approve(address owner, address spender, uint256 amount) internal virtual {
835         require(owner != address(0), "ERC20: approve from the zero address");
836         require(spender != address(0), "ERC20: approve to the zero address");
837 
838         _allowances[owner][spender] = amount;
839         emit Approval(owner, spender, amount);
840     }
841 
842     /**
843      * @dev Sets {decimals} to a value other than the default one of 18.
844      *
845      * WARNING: This function should only be called from the constructor. Most
846      * applications that interact with token contracts will not expect
847      * {decimals} to ever change, and may work incorrectly if it does.
848      */
849     function _setupDecimals(uint8 decimals_) internal {
850         _decimals = decimals_;
851     }
852 
853     /**
854      * @dev Hook that is called before any transfer of tokens. This includes
855      * minting and burning.
856      *
857      * Calling conditions:
858      *
859      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
860      * will be to transferred to `to`.
861      * - when `from` is zero, `amount` tokens will be minted for `to`.
862      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
863      * - `from` and `to` are never both zero.
864      *
865      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
866      */
867     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
868 }
869 
870 // File: contracts/BobaToken.sol
871 
872 pragma solidity 0.6.12;
873 
874 
875 
876 
877 // BobaToken with Governance.
878 contract BobaToken is ERC20("BobaToken", "BOBA"), Ownable {
879     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterBarista).
880     function mint(address _to, uint256 _amount) public onlyOwner {
881         _mint(_to, _amount);
882         _moveDelegates(address(0), _delegates[_to], _amount);
883     }
884 
885     // Copied and modified from YAM code:
886     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
887     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
888     // Which is copied and modified from COMPOUND:
889     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
890 
891     /// @notice A record of each accounts delegate
892     mapping (address => address) internal _delegates;
893 
894     /// @notice A checkpoint for marking number of votes from a given block
895     struct Checkpoint {
896         uint32 fromBlock;
897         uint256 votes;
898     }
899 
900     /// @notice A record of votes checkpoints for each account, by index
901     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
902 
903     /// @notice The number of checkpoints for each account
904     mapping (address => uint32) public numCheckpoints;
905 
906     /// @notice The EIP-712 typehash for the contract's domain
907     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
908 
909     /// @notice The EIP-712 typehash for the delegation struct used by the contract
910     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
911 
912     /// @notice A record of states for signing / validating signatures
913     mapping (address => uint) public nonces;
914 
915       /// @notice An event thats emitted when an account changes its delegate
916     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
917 
918     /// @notice An event thats emitted when a delegate account's vote balance changes
919     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
920 
921     /**
922      * @notice Delegate votes from `msg.sender` to `delegatee`
923      * @param delegator The address to get delegatee for
924      */
925     function delegates(address delegator)
926         external
927         view
928         returns (address)
929     {
930         return _delegates[delegator];
931     }
932 
933    /**
934     * @notice Delegate votes from `msg.sender` to `delegatee`
935     * @param delegatee The address to delegate votes to
936     */
937     function delegate(address delegatee) external {
938         return _delegate(msg.sender, delegatee);
939     }
940 
941     /**
942      * @notice Delegates votes from signatory to `delegatee`
943      * @param delegatee The address to delegate votes to
944      * @param nonce The contract state required to match the signature
945      * @param expiry The time at which to expire the signature
946      * @param v The recovery byte of the signature
947      * @param r Half of the ECDSA signature pair
948      * @param s Half of the ECDSA signature pair
949      */
950     function delegateBySig(
951         address delegatee,
952         uint nonce,
953         uint expiry,
954         uint8 v,
955         bytes32 r,
956         bytes32 s
957     )
958         external
959     {
960         bytes32 domainSeparator = keccak256(
961             abi.encode(
962                 DOMAIN_TYPEHASH,
963                 keccak256(bytes(name())),
964                 getChainId(),
965                 address(this)
966             )
967         );
968 
969         bytes32 structHash = keccak256(
970             abi.encode(
971                 DELEGATION_TYPEHASH,
972                 delegatee,
973                 nonce,
974                 expiry
975             )
976         );
977 
978         bytes32 digest = keccak256(
979             abi.encodePacked(
980                 "\x19\x01",
981                 domainSeparator,
982                 structHash
983             )
984         );
985 
986         address signatory = ecrecover(digest, v, r, s);
987         require(signatory != address(0), "BOBA::delegateBySig: invalid signature");
988         require(nonce == nonces[signatory]++, "BOBA::delegateBySig: invalid nonce");
989         require(now <= expiry, "BOBA::delegateBySig: signature expired");
990         return _delegate(signatory, delegatee);
991     }
992 
993     /**
994      * @notice Gets the current votes balance for `account`
995      * @param account The address to get votes balance
996      * @return The number of current votes for `account`
997      */
998     function getCurrentVotes(address account)
999         external
1000         view
1001         returns (uint256)
1002     {
1003         uint32 nCheckpoints = numCheckpoints[account];
1004         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1005     }
1006 
1007     /**
1008      * @notice Determine the prior number of votes for an account as of a block number
1009      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1010      * @param account The address of the account to check
1011      * @param blockNumber The block number to get the vote balance at
1012      * @return The number of votes the account had as of the given block
1013      */
1014     function getPriorVotes(address account, uint blockNumber)
1015         external
1016         view
1017         returns (uint256)
1018     {
1019         require(blockNumber < block.number, "BOBA::getPriorVotes: not yet determined");
1020 
1021         uint32 nCheckpoints = numCheckpoints[account];
1022         if (nCheckpoints == 0) {
1023             return 0;
1024         }
1025 
1026         // First check most recent balance
1027         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1028             return checkpoints[account][nCheckpoints - 1].votes;
1029         }
1030 
1031         // Next check implicit zero balance
1032         if (checkpoints[account][0].fromBlock > blockNumber) {
1033             return 0;
1034         }
1035 
1036         uint32 lower = 0;
1037         uint32 upper = nCheckpoints - 1;
1038         while (upper > lower) {
1039             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1040             Checkpoint memory cp = checkpoints[account][center];
1041             if (cp.fromBlock == blockNumber) {
1042                 return cp.votes;
1043             } else if (cp.fromBlock < blockNumber) {
1044                 lower = center;
1045             } else {
1046                 upper = center - 1;
1047             }
1048         }
1049         return checkpoints[account][lower].votes;
1050     }
1051 
1052     function _delegate(address delegator, address delegatee)
1053         internal
1054     {
1055         address currentDelegate = _delegates[delegator];
1056         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BOBAs (not scaled);
1057         _delegates[delegator] = delegatee;
1058 
1059         emit DelegateChanged(delegator, currentDelegate, delegatee);
1060 
1061         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1062     }
1063 
1064     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1065         if (srcRep != dstRep && amount > 0) {
1066             if (srcRep != address(0)) {
1067                 // decrease old representative
1068                 uint32 srcRepNum = numCheckpoints[srcRep];
1069                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1070                 uint256 srcRepNew = srcRepOld.sub(amount);
1071                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1072             }
1073 
1074             if (dstRep != address(0)) {
1075                 // increase new representative
1076                 uint32 dstRepNum = numCheckpoints[dstRep];
1077                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1078                 uint256 dstRepNew = dstRepOld.add(amount);
1079                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1080             }
1081         }
1082     }
1083 
1084     function _writeCheckpoint(
1085         address delegatee,
1086         uint32 nCheckpoints,
1087         uint256 oldVotes,
1088         uint256 newVotes
1089     )
1090         internal
1091     {
1092         uint32 blockNumber = safe32(block.number, "BOBA::_writeCheckpoint: block number exceeds 32 bits");
1093 
1094         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1095             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1096         } else {
1097             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1098             numCheckpoints[delegatee] = nCheckpoints + 1;
1099         }
1100 
1101         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1102     }
1103 
1104     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1105         require(n < 2**32, errorMessage);
1106         return uint32(n);
1107     }
1108 
1109     function getChainId() internal pure returns (uint) {
1110         uint256 chainId;
1111         assembly { chainId := chainid() }
1112         return chainId;
1113     }
1114 }
1115 
1116 // File: contracts/MasterBarista.sol
1117 
1118 pragma solidity 0.6.12;
1119 
1120 
1121 
1122 
1123 
1124 
1125 
1126 
1127 interface IMigratorChef {
1128     // Perform LP token migration from legacy UniswapV2 to BobaSwap.
1129     // Take the current LP token address and return the new LP token address.
1130     // Migrator should have full access to the caller's LP token.
1131     // Return the new LP token address.
1132     //
1133     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1134     // BobaSwap must mint EXACTLY the same amount of BobaSwap LP tokens or
1135     // else something bad will happen. Traditional UniswapV2 does not
1136     // do that so be careful!
1137     function migrate(IERC20 token) external returns (IERC20);
1138 }
1139 
1140 // MasterBarista is the master of Boba. He can make Boba and he is a fair guy.
1141 //
1142 // Note that it's ownable and the owner wields tremendous power. The ownership
1143 // will be transferred to a governance smart contract once BOBA is sufficiently
1144 // distributed and the community can show to govern itself.
1145 //
1146 // Have fun reading it. Hopefully it's bug-free. God bless.
1147 contract MasterBarista is Ownable {
1148     using SafeMath for uint256;
1149     using SafeERC20 for IERC20;
1150 
1151     // Info of each user.
1152     struct UserInfo {
1153         uint256 amount;     // How many LP tokens the user has provided.
1154         uint256 rewardDebt; // Reward debt. See explanation below.
1155         //
1156         // We do some fancy math here. Basically, any point in time, the amount of BOBAs
1157         // entitled to a user but is pending to be distributed is:
1158         //
1159         //   pending reward = (user.amount * pool.accBobaPerShare) - user.rewardDebt
1160         //
1161         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1162         //   1. The pool's `accBobaPerShare` (and `lastRewardBlock`) gets updated.
1163         //   2. User receives the pending reward sent to his/her address.
1164         //   3. User's `amount` gets updated.
1165         //   4. User's `rewardDebt` gets updated.
1166     }
1167 
1168     // Info of each pool.
1169     struct PoolInfo {
1170         IERC20 lpToken;           // Address of LP token contract.
1171         uint256 allocPoint;       // How many allocation points assigned to this pool. BOBAs to distribute per block.
1172         uint256 lastRewardBlock;  // Last block number that BOBAs distribution occurs.
1173         uint256 accBobaPerShare; // Accumulated BOBAs per share, times 1e12. See below.
1174     }
1175 
1176     // The BOBA TOKEN!
1177     BobaToken public boba;
1178     // Dev address.
1179     address public devaddr;
1180     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1181     IMigratorChef public migrator;
1182 
1183     // Info of each pool.
1184     PoolInfo[] public poolInfo;
1185     // Info of each user that stakes LP tokens.
1186     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1187     // Total allocation points. Must be the sum of all allocation points in all pools.
1188     uint256 public totalAllocPoint = 0;
1189     // The block number when BOBA mining starts.
1190     uint256 public startBlock;
1191 
1192     uint256 public constant INITIAL_BOBA_PER_BLOCK = 5e18; // 5 per block
1193     uint256 public constant HALVING_PERIOD = 100_000; // 100000 block (around 2 weeks)
1194     address public devAdmin;
1195 
1196     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1197     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1198     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1199 
1200     constructor(
1201         BobaToken _boba,
1202         uint256 _startBlock,
1203         address _devAdmin,
1204         address _devaddr
1205     ) public {
1206         boba = _boba;
1207         startBlock = _startBlock;
1208         devAdmin = _devAdmin;
1209         devaddr = _devaddr;
1210     }
1211 
1212     modifier onlyDevAdmin {
1213         require(msg.sender == devAdmin, "Only dev admin please");
1214         _;
1215     }
1216 
1217     function poolLength() external view returns (uint256) {
1218         return poolInfo.length;
1219     }
1220 
1221     // Add a new lp to the pool. Can only be called by the owner.
1222     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1223     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyDevAdmin {
1224         if (_withUpdate) {
1225             massUpdatePools();
1226         }
1227         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1228         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1229         poolInfo.push(PoolInfo({
1230             lpToken: _lpToken,
1231             allocPoint: _allocPoint,
1232             lastRewardBlock: lastRewardBlock,
1233             accBobaPerShare: 0
1234         }));
1235     }
1236 
1237     // Update the given pool's BOBA allocation point. Can only be called by the owner.
1238     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyDevAdmin {
1239         if (_withUpdate) {
1240             massUpdatePools();
1241         }
1242         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1243         poolInfo[_pid].allocPoint = _allocPoint;
1244     }
1245 
1246     // Set the migrator contract. Can only be called by the owner.
1247     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1248         migrator = _migrator;
1249     }
1250 
1251     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1252     function migrate(uint256 _pid) public {
1253         require(address(migrator) != address(0), "migrate: no migrator");
1254         PoolInfo storage pool = poolInfo[_pid];
1255         IERC20 lpToken = pool.lpToken;
1256         uint256 bal = lpToken.balanceOf(address(this));
1257         lpToken.safeApprove(address(migrator), bal);
1258         IERC20 newLpToken = migrator.migrate(lpToken);
1259         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1260         pool.lpToken = newLpToken;
1261     }
1262 
1263     // Return total reward of Boba over the given _from to _to block.
1264     // Suppose the difference can only be at maximum 1 epoch (2 weeks)
1265     function getRewardDuringPeriod(uint256 _from, uint256 _to) public view returns (uint256) {
1266         uint256 epoch_from = _from.sub(startBlock).div(HALVING_PERIOD);
1267         uint256 epoch_to = _to.sub(startBlock).div(HALVING_PERIOD);
1268 
1269         if (epoch_from == epoch_to) {
1270             return _to.sub(_from).mul(getRewardPerBlock(_from));
1271         } else {
1272             uint256 boundary = HALVING_PERIOD.mul(epoch_to).add(startBlock);
1273             uint256 first = boundary.sub(_from).mul(getRewardPerBlock(_from));
1274             uint256 second = _to.sub(boundary).mul(getRewardPerBlock(_to));
1275             return first.add(second);
1276         }
1277     }
1278 
1279     // Return Boba reward of a given block height
1280     function getRewardPerBlock(uint256 blockIndex) private view returns (uint256) {
1281         uint256 epoch = blockIndex.sub(startBlock).div(HALVING_PERIOD);
1282         if (epoch == 0) {
1283             return INITIAL_BOBA_PER_BLOCK;
1284         } else if (epoch == 1) {
1285             return INITIAL_BOBA_PER_BLOCK / 2;
1286         } else if (epoch == 2) {
1287             return INITIAL_BOBA_PER_BLOCK / 4;
1288         } else if (epoch == 3) {
1289             return INITIAL_BOBA_PER_BLOCK / 8;
1290         } else if (epoch == 4) {
1291             return INITIAL_BOBA_PER_BLOCK / 16;
1292         } else if (epoch == 5) {
1293             return INITIAL_BOBA_PER_BLOCK / 32;
1294         } else if (epoch == 6) {
1295             return INITIAL_BOBA_PER_BLOCK / 64;
1296         } else if (epoch == 7) {
1297             return INITIAL_BOBA_PER_BLOCK / 128;
1298         } else if (epoch == 8) {
1299             return INITIAL_BOBA_PER_BLOCK / 256;
1300         } else if (epoch == 9) {
1301             return INITIAL_BOBA_PER_BLOCK / 512;
1302         } else if (epoch == 10) {
1303             return INITIAL_BOBA_PER_BLOCK / 1024;
1304         } else if (epoch == 11) {
1305             return INITIAL_BOBA_PER_BLOCK / 2048;
1306         } else {
1307             return 0;
1308         }
1309     }
1310 
1311     // View function to see pending BOBAs on frontend.
1312     function pendingBoba(uint256 _pid, address _user) external view returns (uint256) {
1313         PoolInfo storage pool = poolInfo[_pid];
1314         UserInfo storage user = userInfo[_pid][_user];
1315         uint256 accBobaPerShare = pool.accBobaPerShare;
1316         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1317         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1318             uint256 totalBobaReward = getRewardDuringPeriod(pool.lastRewardBlock, block.number);
1319             uint256 bobaReward = totalBobaReward.mul(pool.allocPoint).div(totalAllocPoint);
1320             accBobaPerShare = accBobaPerShare.add(bobaReward.mul(1e12).div(lpSupply));
1321         }
1322         return user.amount.mul(accBobaPerShare).div(1e12).sub(user.rewardDebt);
1323     }
1324 
1325     // Update reward variables for all pools. Be careful of gas spending!
1326     function massUpdatePools() public {
1327         uint256 length = poolInfo.length;
1328         for (uint256 pid = 0; pid < length; ++pid) {
1329             updatePool(pid);
1330         }
1331     }
1332 
1333     // Update reward variables of the given pool to be up-to-date.
1334     function updatePool(uint256 _pid) public {
1335         PoolInfo storage pool = poolInfo[_pid];
1336         if (block.number <= pool.lastRewardBlock) {
1337             return;
1338         }
1339         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1340         if (lpSupply == 0) {
1341             pool.lastRewardBlock = block.number;
1342             return;
1343         }
1344         uint256 totalBobaReward = getRewardDuringPeriod(pool.lastRewardBlock, block.number);
1345         uint256 bobaReward = totalBobaReward.mul(pool.allocPoint).div(totalAllocPoint);
1346         boba.mint(devaddr, bobaReward.div(20));
1347         boba.mint(address(this), bobaReward);
1348         pool.accBobaPerShare = pool.accBobaPerShare.add(bobaReward.mul(1e12).div(lpSupply));
1349         pool.lastRewardBlock = block.number;
1350     }
1351 
1352     // Deposit LP tokens to MasterBarista for BOBA allocation.
1353     function deposit(uint256 _pid, uint256 _amount) public {
1354         require(msg.sender == tx.origin, "no contract please");
1355         PoolInfo storage pool = poolInfo[_pid];
1356         UserInfo storage user = userInfo[_pid][msg.sender];
1357         updatePool(_pid);
1358         if (user.amount > 0) {
1359             uint256 pending = user.amount.mul(pool.accBobaPerShare).div(1e12).sub(user.rewardDebt);
1360             safeBobaTransfer(msg.sender, pending);
1361         }
1362         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1363         user.amount = user.amount.add(_amount);
1364         user.rewardDebt = user.amount.mul(pool.accBobaPerShare).div(1e12);
1365         emit Deposit(msg.sender, _pid, _amount);
1366     }
1367 
1368     // Withdraw LP tokens from MasterBarista.
1369     function withdraw(uint256 _pid, uint256 _amount) public {
1370         PoolInfo storage pool = poolInfo[_pid];
1371         UserInfo storage user = userInfo[_pid][msg.sender];
1372         require(user.amount >= _amount, "withdraw: not good");
1373         updatePool(_pid);
1374         uint256 pending = user.amount.mul(pool.accBobaPerShare).div(1e12).sub(user.rewardDebt);
1375         safeBobaTransfer(msg.sender, pending);
1376         user.amount = user.amount.sub(_amount);
1377         user.rewardDebt = user.amount.mul(pool.accBobaPerShare).div(1e12);
1378         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1379         emit Withdraw(msg.sender, _pid, _amount);
1380     }
1381 
1382     // Withdraw without caring about rewards. EMERGENCY ONLY.
1383     function emergencyWithdraw(uint256 _pid) public {
1384         PoolInfo storage pool = poolInfo[_pid];
1385         UserInfo storage user = userInfo[_pid][msg.sender];
1386         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1387         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1388         user.amount = 0;
1389         user.rewardDebt = 0;
1390     }
1391 
1392     // Safe boba transfer function, just in case if rounding error causes pool to not have enough BOBAs.
1393     function safeBobaTransfer(address _to, uint256 _amount) internal {
1394         uint256 bobaBal = boba.balanceOf(address(this));
1395         if (_amount > bobaBal) {
1396             boba.transfer(_to, bobaBal);
1397         } else {
1398             boba.transfer(_to, _amount);
1399         }
1400     }
1401 
1402     // Update dev address by the previous dev.
1403     function dev(address _devaddr) public {
1404         require(msg.sender == devaddr, "dev: wut?");
1405         devaddr = _devaddr;
1406     }
1407 
1408     // Update dev admin address by the prevoius dev admin
1409     function changeDevAdmin(address _devAdmin) public onlyDevAdmin {
1410         devAdmin = _devAdmin;
1411     }
1412 
1413 }