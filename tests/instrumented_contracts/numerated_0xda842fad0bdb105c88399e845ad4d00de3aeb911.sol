1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
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
79 
80 pragma solidity ^0.6.0;
81 
82 // import "./IERC20.sol";
83 // import "../../math/SafeMath.sol";
84 // import "../../utils/Address.sol";
85 
86 
87 
88 pragma solidity ^0.6.2;
89 
90 /**
91  * @dev Collection of functions related to the address type
92  */
93 library Address {
94     /**
95      * @dev Returns true if `account` is a contract.
96      *
97      * [IMPORTANT]
98      * ====
99      * It is unsafe to assume that an address for which this function returns
100      * false is an externally-owned account (EOA) and not a contract.
101      *
102      * Among others, `isContract` will return false for the following
103      * types of addresses:
104      *
105      *  - an externally-owned account
106      *  - a contract in construction
107      *  - an address where a contract will be created
108      *  - an address where a contract lived, but was destroyed
109      * ====
110      */
111     function isContract(address account) internal view returns (bool) {
112         // This method relies in extcodesize, which returns 0 for contracts in
113         // construction, since the code is only stored at the end of the
114         // constructor execution.
115 
116         uint256 size;
117         // solhint-disable-next-line no-inline-assembly
118         assembly { size := extcodesize(account) }
119         return size > 0;
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
142         (bool success, ) = recipient.call{ value: amount }("");
143         require(success, "Address: unable to send value, recipient may have reverted");
144     }
145 
146     /**
147      * @dev Performs a Solidity function call using a low level `call`. A
148      * plain`call` is an unsafe replacement for a function call: use this
149      * function instead.
150      *
151      * If `target` reverts with a revert reason, it is bubbled up by this
152      * function (like regular Solidity function calls).
153      *
154      * Returns the raw returned data. To convert to the expected return value,
155      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
156      *
157      * Requirements:
158      *
159      * - `target` must be a contract.
160      * - calling `target` with `data` must not revert.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
165       return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
175         return _functionCallWithValue(target, data, 0, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but also transferring `value` wei to `target`.
181      *
182      * Requirements:
183      *
184      * - the calling contract must have an ETH balance of at least `value`.
185      * - the called Solidity function must be `payable`.
186      *
187      * _Available since v3.1._
188      */
189     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
190         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
191     }
192 
193     /**
194      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
195      * with `errorMessage` as a fallback revert reason when `target` reverts.
196      *
197      * _Available since v3.1._
198      */
199     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
200         require(address(this).balance >= value, "Address: insufficient balance for call");
201         return _functionCallWithValue(target, data, value, errorMessage);
202     }
203 
204     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
205         require(isContract(target), "Address: call to non-contract");
206 
207         // solhint-disable-next-line avoid-low-level-calls
208         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
209         if (success) {
210             return returndata;
211         } else {
212             // Look for revert reason and bubble it up if present
213             if (returndata.length > 0) {
214                 // The easiest way to bubble the revert reason is using memory via assembly
215 
216                 // solhint-disable-next-line no-inline-assembly
217                 assembly {
218                     let returndata_size := mload(returndata)
219                     revert(add(32, returndata), returndata_size)
220                 }
221             } else {
222                 revert(errorMessage);
223             }
224         }
225     }
226 }
227 
228 
229 /**
230  * @title SafeERC20
231  * @dev Wrappers around ERC20 operations that throw on failure (when the token
232  * contract returns false). Tokens that return no value (and instead revert or
233  * throw on failure) are also supported, non-reverting calls are assumed to be
234  * successful.
235  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
236  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
237  */
238 library SafeERC20 {
239     using SafeMath for uint256;
240     using Address for address;
241 
242     function safeTransfer(IERC20 token, address to, uint256 value) internal {
243         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
244     }
245 
246     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
247         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
248     }
249 
250     /**
251      * @dev Deprecated. This function has issues similar to the ones found in
252      * {IERC20-approve}, and its usage is discouraged.
253      *
254      * Whenever possible, use {safeIncreaseAllowance} and
255      * {safeDecreaseAllowance} instead.
256      */
257     function safeApprove(IERC20 token, address spender, uint256 value) internal {
258         // safeApprove should only be called when setting an initial allowance,
259         // or when resetting it to zero. To increase and decrease it, use
260         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
261         // solhint-disable-next-line max-line-length
262         require((value == 0) || (token.allowance(address(this), spender) == 0),
263             "SafeERC20: approve from non-zero to non-zero allowance"
264         );
265         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
266     }
267 
268     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
269         uint256 newAllowance = token.allowance(address(this), spender).add(value);
270         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
271     }
272 
273     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
274         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
275         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
276     }
277 
278     /**
279      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
280      * on the return value: the return value is optional (but if data is returned, it must not be false).
281      * @param token The token targeted by the call.
282      * @param data The call data (encoded using abi.encode or one of its variants).
283      */
284     function _callOptionalReturn(IERC20 token, bytes memory data) private {
285         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
286         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
287         // the target address contains contract code and also asserts for success in the low-level call.
288 
289         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
290         if (returndata.length > 0) { // Return data is optional
291             // solhint-disable-next-line max-line-length
292             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
293         }
294     }
295 }
296 
297 
298 pragma solidity ^0.6.0;
299 
300 /**
301  * @dev Wrappers over Solidity's arithmetic operations with added overflow
302  * checks.
303  *
304  * Arithmetic operations in Solidity wrap on overflow. This can easily result
305  * in bugs, because programmers usually assume that an overflow raises an
306  * error, which is the standard behavior in high level programming languages.
307  * `SafeMath` restores this intuition by reverting the transaction when an
308  * operation overflows.
309  *
310  * Using this library instead of the unchecked operations eliminates an entire
311  * class of bugs, so it's recommended to use it always.
312  */
313 library SafeMath {
314     /**
315      * @dev Returns the addition of two unsigned integers, reverting on
316      * overflow.
317      *
318      * Counterpart to Solidity's `+` operator.
319      *
320      * Requirements:
321      *
322      * - Addition cannot overflow.
323      */
324     function add(uint256 a, uint256 b) internal pure returns (uint256) {
325         uint256 c = a + b;
326         require(c >= a, "SafeMath: addition overflow");
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the subtraction of two unsigned integers, reverting on
333      * overflow (when the result is negative).
334      *
335      * Counterpart to Solidity's `-` operator.
336      *
337      * Requirements:
338      *
339      * - Subtraction cannot overflow.
340      */
341     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
342         return sub(a, b, "SafeMath: subtraction overflow");
343     }
344 
345     /**
346      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
347      * overflow (when the result is negative).
348      *
349      * Counterpart to Solidity's `-` operator.
350      *
351      * Requirements:
352      *
353      * - Subtraction cannot overflow.
354      */
355     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
356         require(b <= a, errorMessage);
357         uint256 c = a - b;
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the multiplication of two unsigned integers, reverting on
364      * overflow.
365      *
366      * Counterpart to Solidity's `*` operator.
367      *
368      * Requirements:
369      *
370      * - Multiplication cannot overflow.
371      */
372     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
373         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
374         // benefit is lost if 'b' is also tested.
375         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
376         if (a == 0) {
377             return 0;
378         }
379 
380         uint256 c = a * b;
381         require(c / a == b, "SafeMath: multiplication overflow");
382 
383         return c;
384     }
385 
386     /**
387      * @dev Returns the integer division of two unsigned integers. Reverts on
388      * division by zero. The result is rounded towards zero.
389      *
390      * Counterpart to Solidity's `/` operator. Note: this function uses a
391      * `revert` opcode (which leaves remaining gas untouched) while Solidity
392      * uses an invalid opcode to revert (consuming all remaining gas).
393      *
394      * Requirements:
395      *
396      * - The divisor cannot be zero.
397      */
398     function div(uint256 a, uint256 b) internal pure returns (uint256) {
399         return div(a, b, "SafeMath: division by zero");
400     }
401 
402     /**
403      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
404      * division by zero. The result is rounded towards zero.
405      *
406      * Counterpart to Solidity's `/` operator. Note: this function uses a
407      * `revert` opcode (which leaves remaining gas untouched) while Solidity
408      * uses an invalid opcode to revert (consuming all remaining gas).
409      *
410      * Requirements:
411      *
412      * - The divisor cannot be zero.
413      */
414     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
415         require(b > 0, errorMessage);
416         uint256 c = a / b;
417         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
418 
419         return c;
420     }
421 
422     /**
423      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
424      * Reverts when dividing by zero.
425      *
426      * Counterpart to Solidity's `%` operator. This function uses a `revert`
427      * opcode (which leaves remaining gas untouched) while Solidity uses an
428      * invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
435         return mod(a, b, "SafeMath: modulo by zero");
436     }
437 
438     /**
439      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
440      * Reverts with custom message when dividing by zero.
441      *
442      * Counterpart to Solidity's `%` operator. This function uses a `revert`
443      * opcode (which leaves remaining gas untouched) while Solidity uses an
444      * invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
451         require(b != 0, errorMessage);
452         return a % b;
453     }
454 }
455 
456 
457 pragma solidity ^0.6.0;
458 
459 /*
460  * @dev Provides information about the current execution context, including the
461  * sender of the transaction and its data. While these are generally available
462  * via msg.sender and msg.data, they should not be accessed in such a direct
463  * manner, since when dealing with GSN meta-transactions the account sending and
464  * paying for execution may not be the actual sender (as far as an application
465  * is concerned).
466  *
467  * This contract is only required for intermediate, library-like contracts.
468  */
469 abstract contract Context {
470     function _msgSender() internal view virtual returns (address payable) {
471         return msg.sender;
472     }
473 
474     function _msgData() internal view virtual returns (bytes memory) {
475         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
476         return msg.data;
477     }
478 }
479 
480 
481 
482 pragma solidity ^0.6.0;
483 
484 //import "../GSN/Context.sol";
485 /**
486  * @dev Contract module which provides a basic access control mechanism, where
487  * there is an account (an owner) that can be granted exclusive access to
488  * specific functions.
489  *
490  * By default, the owner account will be the one that deploys the contract. This
491  * can later be changed with {transferOwnership}.
492  *
493  * This module is used through inheritance. It will make available the modifier
494  * `onlyOwner`, which can be applied to your functions to restrict their use to
495  * the owner.
496  */
497 contract Ownable is Context {
498     address private _owner;
499 
500     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
501 
502     /**
503      * @dev Initializes the contract setting the deployer as the initial owner.
504      */
505     constructor () internal {
506         address msgSender = _msgSender();
507         _owner = msgSender;
508         emit OwnershipTransferred(address(0), msgSender);
509     }
510 
511     /**
512      * @dev Returns the address of the current owner.
513      */
514     function owner() public view returns (address) {
515         return _owner;
516     }
517 
518     /**
519      * @dev Throws if called by any account other than the owner.
520      */
521     modifier onlyOwner() {
522         require(_owner == _msgSender(), "Ownable: caller is not the owner");
523         _;
524     }
525 
526     /**
527      * @dev Leaves the contract without owner. It will not be possible to call
528      * `onlyOwner` functions anymore. Can only be called by the current owner.
529      *
530      * NOTE: Renouncing ownership will leave the contract without an owner,
531      * thereby removing any functionality that is only available to the owner.
532      */
533     function renounceOwnership() public virtual onlyOwner {
534         emit OwnershipTransferred(_owner, address(0));
535         _owner = address(0);
536     }
537 
538     /**
539      * @dev Transfers ownership of the contract to a new account (`newOwner`).
540      * Can only be called by the current owner.
541      */
542     function transferOwnership(address newOwner) public virtual onlyOwner {
543         require(newOwner != address(0), "Ownable: new owner is the zero address");
544         emit OwnershipTransferred(_owner, newOwner);
545         _owner = newOwner;
546     }
547 }
548 
549 
550 pragma solidity ^0.6.0;
551 
552 //import "../../GSN/Context.sol";
553 //import "./IERC20.sol";
554 //import "../../math/SafeMath.sol";
555 //import "../../utils/Address.sol";
556 
557 /**
558  * @dev Implementation of the {IERC20} interface.
559  *
560  * This implementation is agnostic to the way tokens are created. This means
561  * that a supply mechanism has to be added in a derived contract using {_mint}.
562  * For a generic mechanism see {ERC20PresetMinterPauser}.
563  *
564  * TIP: For a detailed writeup see our guide
565  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
566  * to implement supply mechanisms].
567  *
568  * We have followed general OpenZeppelin guidelines: functions revert instead
569  * of returning `false` on failure. This behavior is nonetheless conventional
570  * and does not conflict with the expectations of ERC20 applications.
571  *
572  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
573  * This allows applications to reconstruct the allowance for all accounts just
574  * by listening to said events. Other implementations of the EIP may not emit
575  * these events, as it isn't required by the specification.
576  *
577  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
578  * functions have been added to mitigate the well-known issues around setting
579  * allowances. See {IERC20-approve}.
580  */
581 contract ERC20 is Context, IERC20 {
582     using SafeMath for uint256;
583     using Address for address;
584 
585     mapping (address => uint256) private _balances;
586 
587     mapping (address => mapping (address => uint256)) private _allowances;
588 
589     uint256 private _totalSupply;
590 
591     string private _name;
592     string private _symbol;
593     uint8 private _decimals;
594 
595     /**
596      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
597      * a default value of 18.
598      *
599      * To select a different value for {decimals}, use {_setupDecimals}.
600      *
601      * All three of these values are immutable: they can only be set once during
602      * construction.
603      */
604     constructor (string memory name, string memory symbol) public {
605         _name = name;
606         _symbol = symbol;
607         _decimals = 18;
608     }
609 
610     /**
611      * @dev Returns the name of the token.
612      */
613     function name() public view returns (string memory) {
614         return _name;
615     }
616 
617     /**
618      * @dev Returns the symbol of the token, usually a shorter version of the
619      * name.
620      */
621     function symbol() public view returns (string memory) {
622         return _symbol;
623     }
624 
625     /**
626      * @dev Returns the number of decimals used to get its user representation.
627      * For example, if `decimals` equals `2`, a balance of `505` tokens should
628      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
629      *
630      * Tokens usually opt for a value of 18, imitating the relationship between
631      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
632      * called.
633      *
634      * NOTE: This information is only used for _display_ purposes: it in
635      * no way affects any of the arithmetic of the contract, including
636      * {IERC20-balanceOf} and {IERC20-transfer}.
637      */
638     function decimals() public view returns (uint8) {
639         return _decimals;
640     }
641 
642     /**
643      * @dev See {IERC20-totalSupply}.
644      */
645     function totalSupply() public view override returns (uint256) {
646         return _totalSupply;
647     }
648 
649     /**
650      * @dev See {IERC20-balanceOf}.
651      */
652     function balanceOf(address account) public view override returns (uint256) {
653         return _balances[account];
654     }
655 
656     /**
657      * @dev See {IERC20-transfer}.
658      *
659      * Requirements:
660      *
661      * - `recipient` cannot be the zero address.
662      * - the caller must have a balance of at least `amount`.
663      */
664     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
665         _transfer(_msgSender(), recipient, amount);
666         return true;
667     }
668 
669     /**
670      * @dev See {IERC20-allowance}.
671      */
672     function allowance(address owner, address spender) public view virtual override returns (uint256) {
673         return _allowances[owner][spender];
674     }
675 
676     /**
677      * @dev See {IERC20-approve}.
678      *
679      * Requirements:
680      *
681      * - `spender` cannot be the zero address.
682      */
683     function approve(address spender, uint256 amount) public virtual override returns (bool) {
684         _approve(_msgSender(), spender, amount);
685         return true;
686     }
687 
688     /**
689      * @dev See {IERC20-transferFrom}.
690      *
691      * Emits an {Approval} event indicating the updated allowance. This is not
692      * required by the EIP. See the note at the beginning of {ERC20};
693      *
694      * Requirements:
695      * - `sender` and `recipient` cannot be the zero address.
696      * - `sender` must have a balance of at least `amount`.
697      * - the caller must have allowance for ``sender``'s tokens of at least
698      * `amount`.
699      */
700     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
701         _transfer(sender, recipient, amount);
702         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
703         return true;
704     }
705 
706     /**
707      * @dev Atomically increases the allowance granted to `spender` by the caller.
708      *
709      * This is an alternative to {approve} that can be used as a mitigation for
710      * problems described in {IERC20-approve}.
711      *
712      * Emits an {Approval} event indicating the updated allowance.
713      *
714      * Requirements:
715      *
716      * - `spender` cannot be the zero address.
717      */
718     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
719         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
720         return true;
721     }
722 
723     /**
724      * @dev Atomically decreases the allowance granted to `spender` by the caller.
725      *
726      * This is an alternative to {approve} that can be used as a mitigation for
727      * problems described in {IERC20-approve}.
728      *
729      * Emits an {Approval} event indicating the updated allowance.
730      *
731      * Requirements:
732      *
733      * - `spender` cannot be the zero address.
734      * - `spender` must have allowance for the caller of at least
735      * `subtractedValue`.
736      */
737     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
738         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
739         return true;
740     }
741 
742     /**
743      * @dev Moves tokens `amount` from `sender` to `recipient`.
744      *
745      * This is internal function is equivalent to {transfer}, and can be used to
746      * e.g. implement automatic token fees, slashing mechanisms, etc.
747      *
748      * Emits a {Transfer} event.
749      *
750      * Requirements:
751      *
752      * - `sender` cannot be the zero address.
753      * - `recipient` cannot be the zero address.
754      * - `sender` must have a balance of at least `amount`.
755      */
756     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
757         require(sender != address(0), "ERC20: transfer from the zero address");
758         require(recipient != address(0), "ERC20: transfer to the zero address");
759 
760         _beforeTokenTransfer(sender, recipient, amount);
761 
762         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
763         _balances[recipient] = _balances[recipient].add(amount);
764         emit Transfer(sender, recipient, amount);
765     }
766 
767     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
768      * the total supply.
769      *
770      * Emits a {Transfer} event with `from` set to the zero address.
771      *
772      * Requirements
773      *
774      * - `to` cannot be the zero address.
775      */
776     function _mint(address account, uint256 amount) internal virtual {
777         require(account != address(0), "ERC20: mint to the zero address");
778 
779         _beforeTokenTransfer(address(0), account, amount);
780 
781         _totalSupply = _totalSupply.add(amount);
782         _balances[account] = _balances[account].add(amount);
783         emit Transfer(address(0), account, amount);
784     }
785 
786     /**
787      * @dev Destroys `amount` tokens from `account`, reducing the
788      * total supply.
789      *
790      * Emits a {Transfer} event with `to` set to the zero address.
791      *
792      * Requirements
793      *
794      * - `account` cannot be the zero address.
795      * - `account` must have at least `amount` tokens.
796      */
797     function _burn(address account, uint256 amount) internal virtual {
798         require(account != address(0), "ERC20: burn from the zero address");
799 
800         _beforeTokenTransfer(account, address(0), amount);
801 
802         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
803         _totalSupply = _totalSupply.sub(amount);
804         emit Transfer(account, address(0), amount);
805     }
806 
807     /**
808      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
809      *
810      * This internal function is equivalent to `approve`, and can be used to
811      * e.g. set automatic allowances for certain subsystems, etc.
812      *
813      * Emits an {Approval} event.
814      *
815      * Requirements:
816      *
817      * - `owner` cannot be the zero address.
818      * - `spender` cannot be the zero address.
819      */
820     function _approve(address owner, address spender, uint256 amount) internal virtual {
821         require(owner != address(0), "ERC20: approve from the zero address");
822         require(spender != address(0), "ERC20: approve to the zero address");
823 
824         _allowances[owner][spender] = amount;
825         emit Approval(owner, spender, amount);
826     }
827 
828     /**
829      * @dev Sets {decimals} to a value other than the default one of 18.
830      *
831      * WARNING: This function should only be called from the constructor. Most
832      * applications that interact with token contracts will not expect
833      * {decimals} to ever change, and may work incorrectly if it does.
834      */
835     function _setupDecimals(uint8 decimals_) internal {
836         _decimals = decimals_;
837     }
838 
839     /**
840      * @dev Hook that is called before any transfer of tokens. This includes
841      * minting and burning.
842      *
843      * Calling conditions:
844      *
845      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
846      * will be to transferred to `to`.
847      * - when `from` is zero, `amount` tokens will be minted for `to`.
848      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
849      * - `from` and `to` are never both zero.
850      *
851      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
852      */
853     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
854 }
855 
856 
857 pragma solidity 0.6.12;
858 
859 
860 //import "./openzeppelin/contracts/token/ERC20/ERC20.sol";
861 //import "./openzeppelin/contracts/access/Ownable.sol";
862 
863 
864 // TntToken with Governance.
865 contract TenetToken is ERC20("Tenet", "TEN"), Ownable {
866     // @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
867     function mint(address _to, uint256 _amount) public onlyOwner {
868         _mint(_to, _amount);
869         _moveDelegates(address(0), _delegates[_to], _amount);
870     }
871     function burn(address _account, uint256 _amount) public onlyOwner {
872         _burn(_account, _amount);
873     }
874     // Copied and modified from YAM code:
875     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
876     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
877     // Which is copied and modified from COMPOUND:
878     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
879 
880     // @notice A record of each accounts delegate
881     mapping (address => address) internal _delegates;
882 
883     // @notice A checkpoint for marking number of votes from a given block
884     struct Checkpoint {
885         uint32 fromBlock;
886         uint256 votes;
887     }
888 
889     // @notice A record of votes checkpoints for each account, by index
890     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
891 
892     // @notice The number of checkpoints for each account
893     mapping (address => uint32) public numCheckpoints;
894 
895     // @notice The EIP-712 typehash for the contract's domain
896     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
897 
898     // @notice The EIP-712 typehash for the delegation struct used by the contract
899     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
900 
901     // @notice A record of states for signing / validating signatures
902     mapping (address => uint) public nonces;
903 
904     // @notice An event thats emitted when an account changes its delegate
905     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
906 
907     // @notice An event thats emitted when a delegate account's vote balance changes
908     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
909 
910     /**
911      * @notice Delegate votes from `msg.sender` to `delegatee`
912      * @param delegator The address to get delegatee for
913      */
914     function delegates(address delegator)
915         external
916         view
917         returns (address)
918     {
919         return _delegates[delegator];
920     }
921 
922    /**
923     * @notice Delegate votes from `msg.sender` to `delegatee`
924     * @param delegatee The address to delegate votes to
925     */
926     function delegate(address delegatee) external {
927         return _delegate(msg.sender, delegatee);
928     }
929 
930     /**
931      * @notice Delegates votes from signatory to `delegatee`
932      * @param delegatee The address to delegate votes to
933      * @param nonce The contract state required to match the signature
934      * @param expiry The time at which to expire the signature
935      * @param v The recovery byte of the signature
936      * @param r Half of the ECDSA signature pair
937      * @param s Half of the ECDSA signature pair
938      */
939     function delegateBySig(
940         address delegatee,
941         uint nonce,
942         uint expiry,
943         uint8 v,
944         bytes32 r,
945         bytes32 s
946     )
947         external
948     {
949         bytes32 domainSeparator = keccak256(
950             abi.encode(
951                 DOMAIN_TYPEHASH,
952                 keccak256(bytes(name())),
953                 getChainId(),
954                 address(this)
955             )
956         );
957 
958         bytes32 structHash = keccak256(
959             abi.encode(
960                 DELEGATION_TYPEHASH,
961                 delegatee,
962                 nonce,
963                 expiry
964             )
965         );
966 
967         bytes32 digest = keccak256(
968             abi.encodePacked(
969                 "\x19\x01",
970                 domainSeparator,
971                 structHash
972             )
973         );
974 
975         address signatory = ecrecover(digest, v, r, s);
976         require(signatory != address(0), "delegateBySig: invalid signature");
977         require(nonce == nonces[signatory]++, "delegateBySig: invalid nonce");
978         require(now <= expiry, "delegateBySig: signature expired");
979         return _delegate(signatory, delegatee);
980     }
981 
982     /**
983      * @notice Gets the current votes balance for `account`
984      * @param account The address to get votes balance
985      * @return The number of current votes for `account`
986      */
987     function getCurrentVotes(address account)
988         external
989         view
990         returns (uint256)
991     {
992         uint32 nCheckpoints = numCheckpoints[account];
993         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
994     }
995 
996     /**
997      * @notice Determine the prior number of votes for an account as of a block number
998      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
999      * @param account The address of the account to check
1000      * @param blockNumber The block number to get the vote balance at
1001      * @return The number of votes the account had as of the given block
1002      */
1003     function getPriorVotes(address account, uint blockNumber)
1004         external
1005         view
1006         returns (uint256)
1007     {
1008         require(blockNumber < block.number, "getPriorVotes: not yet determined");
1009 
1010         uint32 nCheckpoints = numCheckpoints[account];
1011         if (nCheckpoints == 0) {
1012             return 0;
1013         }
1014 
1015         // First check most recent balance
1016         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1017             return checkpoints[account][nCheckpoints - 1].votes;
1018         }
1019 
1020         // Next check implicit zero balance
1021         if (checkpoints[account][0].fromBlock > blockNumber) {
1022             return 0;
1023         }
1024 
1025         uint32 lower = 0;
1026         uint32 upper = nCheckpoints - 1;
1027         while (upper > lower) {
1028             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1029             Checkpoint memory cp = checkpoints[account][center];
1030             if (cp.fromBlock == blockNumber) {
1031                 return cp.votes;
1032             } else if (cp.fromBlock < blockNumber) {
1033                 lower = center;
1034             } else {
1035                 upper = center - 1;
1036             }
1037         }
1038         return checkpoints[account][lower].votes;
1039     }
1040 
1041     function _delegate(address delegator, address delegatee)
1042         internal
1043     {
1044         address currentDelegate = _delegates[delegator];
1045         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying TNTs (not scaled);
1046         _delegates[delegator] = delegatee;
1047 
1048         emit DelegateChanged(delegator, currentDelegate, delegatee);
1049 
1050         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1051     }
1052 
1053     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1054         if (srcRep != dstRep && amount > 0) {
1055             if (srcRep != address(0)) {
1056                 // decrease old representative
1057                 uint32 srcRepNum = numCheckpoints[srcRep];
1058                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1059                 uint256 srcRepNew = srcRepOld.sub(amount);
1060                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1061             }
1062 
1063             if (dstRep != address(0)) {
1064                 // increase new representative
1065                 uint32 dstRepNum = numCheckpoints[dstRep];
1066                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1067                 uint256 dstRepNew = dstRepOld.add(amount);
1068                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1069             }
1070         }
1071     }
1072 
1073     function _writeCheckpoint(
1074         address delegatee,
1075         uint32 nCheckpoints,
1076         uint256 oldVotes,
1077         uint256 newVotes
1078     )
1079         internal
1080     {
1081         uint32 blockNumber = safe32(block.number, "_writeCheckpoint: block number exceeds 32 bits");
1082 
1083         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1084             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1085         } else {
1086             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1087             numCheckpoints[delegatee] = nCheckpoints + 1;
1088         }
1089 
1090         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1091     }
1092 
1093     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1094         require(n < 2**32, errorMessage);
1095         return uint32(n);
1096     }
1097 
1098     function getChainId() internal pure returns (uint) {
1099         uint256 chainId;
1100         assembly { chainId := chainid() }
1101         return chainId;
1102     }
1103 }
1104 
1105 
1106 pragma solidity ^0.6.0;
1107 
1108 /**
1109  * @dev Library for managing
1110  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1111  * types.
1112  *
1113  * Sets have the following properties:
1114  *
1115  * - Elements are added, removed, and checked for existence in constant time
1116  * (O(1)).
1117  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1118  *
1119  * ```
1120  * contract Example {
1121  *     // Add the library methods
1122  *     using EnumerableSet for EnumerableSet.AddressSet;
1123  *
1124  *     // Declare a set state variable
1125  *     EnumerableSet.AddressSet private mySet;
1126  * }
1127  * ```
1128  *
1129  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1130  * (`UintSet`) are supported.
1131  */
1132 library EnumerableSet {
1133     // To implement this library for multiple types with as little code
1134     // repetition as possible, we write it in terms of a generic Set type with
1135     // bytes32 values.
1136     // The Set implementation uses private functions, and user-facing
1137     // implementations (such as AddressSet) are just wrappers around the
1138     // underlying Set.
1139     // This means that we can only create new EnumerableSets for types that fit
1140     // in bytes32.
1141 
1142     struct Set {
1143         // Storage of set values
1144         bytes32[] _values;
1145 
1146         // Position of the value in the `values` array, plus 1 because index 0
1147         // means a value is not in the set.
1148         mapping (bytes32 => uint256) _indexes;
1149     }
1150 
1151     /**
1152      * @dev Add a value to a set. O(1).
1153      *
1154      * Returns true if the value was added to the set, that is if it was not
1155      * already present.
1156      */
1157     function _add(Set storage set, bytes32 value) private returns (bool) {
1158         if (!_contains(set, value)) {
1159             set._values.push(value);
1160             // The value is stored at length-1, but we add 1 to all indexes
1161             // and use 0 as a sentinel value
1162             set._indexes[value] = set._values.length;
1163             return true;
1164         } else {
1165             return false;
1166         }
1167     }
1168 
1169     /**
1170      * @dev Removes a value from a set. O(1).
1171      *
1172      * Returns true if the value was removed from the set, that is if it was
1173      * present.
1174      */
1175     function _remove(Set storage set, bytes32 value) private returns (bool) {
1176         // We read and store the value's index to prevent multiple reads from the same storage slot
1177         uint256 valueIndex = set._indexes[value];
1178 
1179         if (valueIndex != 0) { // Equivalent to contains(set, value)
1180             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1181             // the array, and then remove the last element (sometimes called as 'swap and pop').
1182             // This modifies the order of the array, as noted in {at}.
1183 
1184             uint256 toDeleteIndex = valueIndex - 1;
1185             uint256 lastIndex = set._values.length - 1;
1186 
1187             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1188             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1189 
1190             bytes32 lastvalue = set._values[lastIndex];
1191 
1192             // Move the last value to the index where the value to delete is
1193             set._values[toDeleteIndex] = lastvalue;
1194             // Update the index for the moved value
1195             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1196 
1197             // Delete the slot where the moved value was stored
1198             set._values.pop();
1199 
1200             // Delete the index for the deleted slot
1201             delete set._indexes[value];
1202 
1203             return true;
1204         } else {
1205             return false;
1206         }
1207     }
1208 
1209     /**
1210      * @dev Returns true if the value is in the set. O(1).
1211      */
1212     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1213         return set._indexes[value] != 0;
1214     }
1215 
1216     /**
1217      * @dev Returns the number of values on the set. O(1).
1218      */
1219     function _length(Set storage set) private view returns (uint256) {
1220         return set._values.length;
1221     }
1222 
1223    /**
1224     * @dev Returns the value stored at position `index` in the set. O(1).
1225     *
1226     * Note that there are no guarantees on the ordering of values inside the
1227     * array, and it may change when more values are added or removed.
1228     *
1229     * Requirements:
1230     *
1231     * - `index` must be strictly less than {length}.
1232     */
1233     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1234         require(set._values.length > index, "EnumerableSet: index out of bounds");
1235         return set._values[index];
1236     }
1237 
1238     // AddressSet
1239 
1240     struct AddressSet {
1241         Set _inner;
1242     }
1243 
1244     /**
1245      * @dev Add a value to a set. O(1).
1246      *
1247      * Returns true if the value was added to the set, that is if it was not
1248      * already present.
1249      */
1250     function add(AddressSet storage set, address value) internal returns (bool) {
1251         return _add(set._inner, bytes32(uint256(value)));
1252     }
1253 
1254     /**
1255      * @dev Removes a value from a set. O(1).
1256      *
1257      * Returns true if the value was removed from the set, that is if it was
1258      * present.
1259      */
1260     function remove(AddressSet storage set, address value) internal returns (bool) {
1261         return _remove(set._inner, bytes32(uint256(value)));
1262     }
1263 
1264     /**
1265      * @dev Returns true if the value is in the set. O(1).
1266      */
1267     function contains(AddressSet storage set, address value) internal view returns (bool) {
1268         return _contains(set._inner, bytes32(uint256(value)));
1269     }
1270 
1271     /**
1272      * @dev Returns the number of values in the set. O(1).
1273      */
1274     function length(AddressSet storage set) internal view returns (uint256) {
1275         return _length(set._inner);
1276     }
1277 
1278    /**
1279     * @dev Returns the value stored at position `index` in the set. O(1).
1280     *
1281     * Note that there are no guarantees on the ordering of values inside the
1282     * array, and it may change when more values are added or removed.
1283     *
1284     * Requirements:
1285     *
1286     * - `index` must be strictly less than {length}.
1287     */
1288     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1289         return address(uint256(_at(set._inner, index)));
1290     }
1291 
1292 
1293     // UintSet
1294 
1295     struct UintSet {
1296         Set _inner;
1297     }
1298 
1299     /**
1300      * @dev Add a value to a set. O(1).
1301      *
1302      * Returns true if the value was added to the set, that is if it was not
1303      * already present.
1304      */
1305     function add(UintSet storage set, uint256 value) internal returns (bool) {
1306         return _add(set._inner, bytes32(value));
1307     }
1308 
1309     /**
1310      * @dev Removes a value from a set. O(1).
1311      *
1312      * Returns true if the value was removed from the set, that is if it was
1313      * present.
1314      */
1315     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1316         return _remove(set._inner, bytes32(value));
1317     }
1318 
1319     /**
1320      * @dev Returns true if the value is in the set. O(1).
1321      */
1322     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1323         return _contains(set._inner, bytes32(value));
1324     }
1325 
1326     /**
1327      * @dev Returns the number of values on the set. O(1).
1328      */
1329     function length(UintSet storage set) internal view returns (uint256) {
1330         return _length(set._inner);
1331     }
1332 
1333    /**
1334     * @dev Returns the value stored at position `index` in the set. O(1).
1335     *
1336     * Note that there are no guarantees on the ordering of values inside the
1337     * array, and it may change when more values are added or removed.
1338     *
1339     * Requirements:
1340     *
1341     * - `index` must be strictly less than {length}.
1342     */
1343     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1344         return uint256(_at(set._inner, index));
1345     }
1346 }
1347 
1348 
1349 
1350 
1351 pragma solidity 0.6.12;
1352 
1353 
1354 //import "./openzeppelin/contracts/token/ERC20/IERC20.sol";
1355 //import "./openzeppelin/contracts/token/ERC20/SafeERC20.sol";
1356 //import "./openzeppelin/contracts/utils/EnumerableSet.sol";
1357 //import "./openzeppelin/contracts/math/SafeMath.sol";
1358 //import "./openzeppelin/contracts/access/Ownable.sol";
1359 contract TenetMine is Ownable {
1360     using SafeMath for uint256;
1361     struct MinePeriodInfo {
1362         uint256 tenPerBlockPeriod;
1363         uint256 totalTenPeriod;
1364     }
1365     uint256 public bonusEndBlock;
1366     uint256 public bonus_multiplier;
1367     uint256 public bonusTenPerBlock;
1368     uint256 public startBlock;
1369     uint256 public endBlock;
1370     uint256 public subBlockNumerPeriod;
1371     uint256 public totalSupply;
1372     MinePeriodInfo[] public allMinePeriodInfo;
1373 
1374     constructor(
1375         uint256 _startBlock,   
1376         uint256 _bonusEndBlockOffset,
1377         uint256 _bonus_multiplier,
1378         uint256 _bonusTenPerBlock,
1379         uint256 _subBlockNumerPeriod,
1380         uint256[] memory _tenPerBlockPeriod
1381     ) public {
1382         startBlock = _startBlock>0 ? _startBlock : block.number + 1;
1383         bonusEndBlock = startBlock.add(_bonusEndBlockOffset);
1384         bonus_multiplier = _bonus_multiplier;
1385         bonusTenPerBlock = _bonusTenPerBlock;
1386         subBlockNumerPeriod = _subBlockNumerPeriod;
1387         totalSupply = bonusEndBlock.sub(startBlock).mul(bonusTenPerBlock).mul(bonus_multiplier);
1388         for (uint256 i = 0; i < _tenPerBlockPeriod.length; i++) {
1389             allMinePeriodInfo.push(MinePeriodInfo({
1390                 tenPerBlockPeriod: _tenPerBlockPeriod[i],
1391                 totalTenPeriod: totalSupply
1392             }));
1393             totalSupply = totalSupply.add(subBlockNumerPeriod.mul(_tenPerBlockPeriod[i]));
1394         }
1395         endBlock = bonusEndBlock.add(subBlockNumerPeriod.mul(_tenPerBlockPeriod.length));        
1396     }
1397     function set_startBlock(uint256 _startBlock) public onlyOwner {
1398 		require(block.number < _startBlock, "set_startBlock: startBlock invalid");
1399         uint256 bonusEndBlockOffset = bonusEndBlock.sub(startBlock);
1400         startBlock = _startBlock>0 ? _startBlock : block.number + 1;
1401         bonusEndBlock = startBlock.add(bonusEndBlockOffset);
1402         endBlock = bonusEndBlock.add(subBlockNumerPeriod.mul(allMinePeriodInfo.length));
1403 	}
1404     function getMinePeriodCount() public view returns (uint256) {
1405         return allMinePeriodInfo.length;
1406     }
1407     function calcMineTenReward(uint256 _from,uint256 _to) public view returns (uint256) {
1408         if(_from < startBlock){
1409             _from = startBlock;
1410         }
1411         if(_from >= endBlock){
1412             return 0;
1413         }
1414         if(_from >= _to){
1415             return 0;
1416         }
1417         uint256 mineFrom = calcTotalMine(_from);
1418         uint256 mineTo= calcTotalMine(_to);
1419         return mineTo.sub(mineFrom);
1420     }
1421     function calcTotalMine(uint256 _to) public view returns (uint256 totalMine) {
1422         if(_to <= startBlock){
1423             totalMine = 0;
1424         }else if(_to <= bonusEndBlock){
1425             totalMine = _to.sub(startBlock).mul(bonusTenPerBlock).mul(bonus_multiplier);
1426         }else if(_to < endBlock){
1427             uint256 periodIndex = _to.sub(bonusEndBlock).div(subBlockNumerPeriod);
1428             uint256 periodBlock = _to.sub(bonusEndBlock).mod(subBlockNumerPeriod);
1429             MinePeriodInfo memory minePeriodInfo = allMinePeriodInfo[periodIndex];
1430             uint256 curMine = periodBlock.mul(minePeriodInfo.tenPerBlockPeriod);
1431             totalMine = curMine.add(minePeriodInfo.totalTenPeriod);
1432         }else{
1433             totalMine = totalSupply;
1434         }
1435     }    
1436     // Return reward multiplier over the given _from to _to block.
1437     function getMultiplier(uint256 _from, uint256 _to,uint256 _end,uint256 _tokenBonusEndBlock,uint256 _tokenBonusMultipler) public pure returns (uint256) {
1438         if(_to > _end){
1439             _to = _end;
1440         }
1441         if(_from>_end){
1442             return 0;
1443         }else if (_to <= _tokenBonusEndBlock) {
1444             return _to.sub(_from).mul(_tokenBonusMultipler);
1445         } else if (_from >= _tokenBonusEndBlock) {
1446             return _to.sub(_from);
1447         } else {
1448             return _tokenBonusEndBlock.sub(_from).mul(_tokenBonusMultipler).add(_to.sub(_tokenBonusEndBlock));
1449         }
1450     }    
1451 }
1452 
1453 pragma solidity 0.6.12;
1454 
1455 
1456 //import "./openzeppelin/contracts/token/ERC20/IERC20.sol";
1457 //import "./openzeppelin/contracts/token/ERC20/SafeERC20.sol";
1458 //import "./openzeppelin/contracts/utils/EnumerableSet.sol";
1459 //import "./openzeppelin/contracts/math/SafeMath.sol";
1460 //import "./openzeppelin/contracts/access/Ownable.sol";
1461 //import "./TenetToken.sol";
1462 //import "./TenetMine.sol";
1463 // Tenet is the master of TEN. He can make TEN and he is a fair guy.
1464 contract Tenet is Ownable {
1465     using SafeMath for uint256;
1466     using SafeERC20 for IERC20;
1467 
1468     // Info of each user.
1469     struct UserInfo {
1470         uint256 amount;             
1471         uint256 rewardTokenDebt;    
1472         uint256 rewardTenDebt;      
1473         uint256 lastBlockNumber;    
1474         uint256 freezeBlocks;      
1475         uint256 freezeTen;         
1476     }
1477     // Info of each pool.
1478     struct PoolSettingInfo{
1479         address lpToken;            
1480         address tokenAddr;          
1481         address projectAddr;        
1482         uint256 tokenAmount;       
1483         uint256 startBlock;        
1484         uint256 endBlock;          
1485         uint256 tokenPerBlock;      
1486         uint256 tokenBonusEndBlock; 
1487         uint256 tokenBonusMultipler;
1488     }
1489     struct PoolInfo {
1490         uint256 lastRewardBlock;  
1491         uint256 lpTokenTotalAmount;
1492         uint256 accTokenPerShare; 
1493         uint256 accTenPerShare; 
1494         uint256 userCount;
1495         uint256 amount;     
1496         uint256 rewardTenDebt; 
1497         uint256 mineTokenAmount;
1498     }
1499 
1500     struct TenPoolInfo {
1501         uint256 lastRewardBlock;
1502         uint256 accTenPerShare; 
1503         uint256 allocPoint;
1504         uint256 lpTokenTotalAmount;
1505     }
1506 
1507     TenetToken public ten;
1508     TenetMine public tenMineCalc;
1509     IERC20 public lpTokenTen;
1510     address public devaddr;
1511     uint256 public devaddrAmount;
1512     uint256 public modifyAllocPointPeriod;
1513     uint256 public lastModifyAllocPointBlock;
1514     uint256 public totalAllocPoint;
1515     uint256 public devWithdrawStartBlock;
1516     uint256 public addpoolfee;
1517     uint256 public bonusAllocPointBlock;
1518     uint256 public minProjectUserCount;
1519 
1520     uint256 public emergencyWithdraw;
1521     uint256 public constant MINLPTOKEN_AMOUNT = 10;
1522     uint256 public constant PERSHARERATE = 1000000000000;
1523     PoolInfo[] public poolInfo;
1524     PoolSettingInfo[] public poolSettingInfo;
1525     TenPoolInfo public tenProjectPool;
1526     TenPoolInfo public tenUserPool;
1527     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1528     mapping (address => UserInfo) public userInfoUserPool;
1529     mapping (address => bool) public tenMintRightAddr;
1530 
1531     address public bonusAddr;
1532     uint256 public bonusPoolFeeRate;
1533 
1534     event AddPool(address indexed user, uint256 indexed pid, uint256 tokenAmount,uint256 lpTenAmount);
1535     event Deposit(address indexed user, uint256 indexed pid, uint256 amount,uint256 penddingToken,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);
1536     event DepositFrom(address indexed user, uint256 indexed pid, uint256 amount,address from,uint256 penddingToken,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);
1537     event MineLPToken(address indexed user, uint256 indexed pid, uint256 penddingToken,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);    
1538     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount,uint256 penddingToken,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);
1539 
1540     event DepositLPTen(address indexed user, uint256 indexed pid, uint256 amount,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);
1541     event WithdrawLPTen(address indexed user, uint256 indexed pid, uint256 amount,uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);    
1542     event MineLPTen(address indexed user, uint256 penddingTen,uint256 freezeTen,uint256 freezeBlocks);    
1543     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1544     event DevWithdraw(address indexed user, uint256 amount);
1545 
1546     constructor(
1547         TenetToken _ten,
1548         TenetMine _tenMineCalc,
1549         IERC20 _lpTen,        
1550         address _devaddr,
1551         uint256 _allocPointProject,
1552         uint256 _allocPointUser,
1553         uint256 _devWithdrawStartBlock,
1554         uint256 _modifyAllocPointPeriod,
1555         uint256 _bonusAllocPointBlock,
1556         uint256 _minProjectUserCount
1557     ) public {
1558         ten = _ten;
1559         tenMineCalc = _tenMineCalc;
1560         devaddr = _devaddr;
1561         lpTokenTen = _lpTen;
1562         tenProjectPool.allocPoint = _allocPointProject;
1563         tenUserPool.allocPoint = _allocPointUser;
1564         totalAllocPoint = _allocPointProject.add(_allocPointUser);
1565         devaddrAmount = 0;
1566         devWithdrawStartBlock = _devWithdrawStartBlock;
1567         addpoolfee = 0;
1568         emergencyWithdraw = 0;
1569         modifyAllocPointPeriod = _modifyAllocPointPeriod;
1570         lastModifyAllocPointBlock = tenMineCalc.startBlock();
1571         bonusAllocPointBlock = _bonusAllocPointBlock;
1572         minProjectUserCount = _minProjectUserCount;
1573         bonusAddr = msg.sender;
1574         bonusPoolFeeRate = 0;
1575     }
1576     modifier onlyMinter() {
1577         require(tenMintRightAddr[msg.sender] == true, "onlyMinter: caller is no right to mint");
1578         _;
1579     }
1580     modifier onlyNotEmergencyWithdraw() {
1581         require(emergencyWithdraw == 0, "onlyNotEmergencyWithdraw: emergencyWithdraw now");
1582         _;
1583     }    
1584     function poolLength() external view returns (uint256) {
1585         return poolInfo.length;
1586     }
1587     function set_basicInfo(TenetToken _ten,IERC20 _lpTokenTen,TenetMine _tenMineCalc,uint256 _devWithdrawStartBlock,uint256 _bonusAllocPointBlock,uint256 _minProjectUserCount) public onlyOwner {
1588         ten = _ten;
1589         lpTokenTen = _lpTokenTen;
1590         tenMineCalc = _tenMineCalc;
1591         devWithdrawStartBlock = _devWithdrawStartBlock;
1592         bonusAllocPointBlock = _bonusAllocPointBlock;
1593         minProjectUserCount = _minProjectUserCount;
1594     }
1595     function set_bonusInfo(address _bonusAddr,uint256 _addpoolfee,uint256 _bonusPoolFeeRate) public onlyOwner {
1596         bonusAddr = _bonusAddr;
1597         addpoolfee = _addpoolfee;
1598         bonusPoolFeeRate = _bonusPoolFeeRate;
1599     }
1600     function set_tenMintRightAddr(address _addr,bool isHaveRight) public onlyOwner {
1601         tenMintRightAddr[_addr] = isHaveRight;
1602     }
1603     function tenMint(address _toAddr,uint256 _amount) public onlyMinter {
1604         if(_amount > 0){
1605             ten.mint(_toAddr,_amount);
1606             devaddrAmount = devaddrAmount.add(_amount.div(10));
1607         }
1608     }    
1609  /*   function set_tenetToken(TenetToken _ten) public onlyOwner {
1610         ten = _ten;
1611     }*/
1612     function set_tenNewOwner(address _tenNewOwner) public onlyOwner {
1613         ten.transferOwnership(_tenNewOwner);
1614     }    
1615 /*    function set_tenetLPToken(IERC20 _lpTokenTen) public onlyOwner {
1616         lpTokenTen = _lpTokenTen;
1617     }
1618     function set_tenetMine(TenetMine _tenMineCalc) public onlyOwner {
1619         tenMineCalc = _tenMineCalc;
1620     }*/
1621     function set_emergencyWithdraw(uint256 _emergencyWithdraw) public onlyOwner {
1622         emergencyWithdraw = _emergencyWithdraw;
1623     }
1624 /*    function set_addPoolFee(uint256 _addpoolfee) public onlyOwner {
1625         addpoolfee = _addpoolfee;
1626     }
1627     function set_devWithdrawStartBlock(uint256 _devWithdrawStartBlock) public onlyOwner {
1628         devWithdrawStartBlock = _devWithdrawStartBlock;
1629     }   */
1630     function set_allocPoint(uint256 _allocPointProject,uint256 _allocPointUser,uint256 _modifyAllocPointPeriod) public onlyOwner {
1631         _minePoolTen(tenProjectPool);
1632         _minePoolTen(tenUserPool);
1633         tenProjectPool.allocPoint = _allocPointProject;
1634         tenUserPool.allocPoint = _allocPointUser;
1635         modifyAllocPointPeriod = _modifyAllocPointPeriod;
1636         totalAllocPoint = _allocPointProject.add(_allocPointUser);
1637         require(totalAllocPoint > 0, "set_allocPoint: Alloc Point invalid");
1638     }
1639 /*    function set_bonusAllocPointBlock(uint256 _bonusAllocPointBlock) public onlyOwner {
1640         bonusAllocPointBlock = _bonusAllocPointBlock;
1641     }  
1642     function set_minProjectUserCount(uint256 _minProjectUserCount) public onlyOwner {
1643         minProjectUserCount = _minProjectUserCount;
1644     } */
1645     function add(address _lpToken,
1646             address _tokenAddr,
1647             uint256 _tokenAmount,
1648             uint256 _startBlock,
1649             uint256 _endBlockOffset,
1650             uint256 _tokenPerBlock,
1651             uint256 _tokenBonusEndBlockOffset,
1652             uint256 _tokenBonusMultipler,
1653             uint256 _lpTenAmount) public onlyNotEmergencyWithdraw {
1654         if(_startBlock == 0){
1655             _startBlock = block.number;
1656         }
1657         require(block.number <= _startBlock, "add: startBlock invalid");
1658         require(_endBlockOffset >= _tokenBonusEndBlockOffset, "add: bonusEndBlockOffset invalid");
1659         require(tenMineCalc.getMultiplier(_startBlock,_startBlock.add(_endBlockOffset),_startBlock.add(_endBlockOffset),_startBlock.add(_tokenBonusEndBlockOffset),_tokenBonusMultipler).mul(_tokenPerBlock) <= _tokenAmount, "add: token amount invalid");
1660         require(_tokenAmount > 0, "add: tokenAmount invalid");
1661         IERC20(_tokenAddr).safeTransferFrom(msg.sender,address(this), _tokenAmount);
1662         if(addpoolfee > 0){
1663             IERC20(address(ten)).safeTransferFrom(msg.sender,address(this), addpoolfee);
1664             if(bonusPoolFeeRate > 0){
1665                 IERC20(address(ten)).safeTransfer(bonusAddr, addpoolfee.mul(bonusPoolFeeRate).div(10000));
1666                 if(bonusPoolFeeRate < 10000){
1667                     ten.burn(address(this),addpoolfee.sub(addpoolfee.mul(bonusPoolFeeRate).div(10000)));
1668                 }
1669             }else{
1670                 ten.burn(address(this),addpoolfee);
1671             }
1672         }
1673         uint256 pid = poolInfo.length;
1674         poolSettingInfo.push(PoolSettingInfo({
1675                 lpToken: _lpToken,
1676                 tokenAddr: _tokenAddr,
1677                 projectAddr: msg.sender,
1678                 tokenAmount:_tokenAmount,
1679                 startBlock: _startBlock,
1680                 endBlock: _startBlock.add(_endBlockOffset),
1681                 tokenPerBlock: _tokenPerBlock,
1682                 tokenBonusEndBlock: _startBlock.add(_tokenBonusEndBlockOffset),
1683                 tokenBonusMultipler: _tokenBonusMultipler
1684             }));
1685         poolInfo.push(PoolInfo({
1686             lastRewardBlock: block.number > _startBlock ? block.number : _startBlock,
1687             accTokenPerShare: 0,
1688             accTenPerShare: 0,
1689             lpTokenTotalAmount: 0,
1690             userCount: 0,
1691             amount: 0,
1692             rewardTenDebt: 0,
1693             mineTokenAmount: 0
1694         }));
1695         if(_lpTenAmount>=MINLPTOKEN_AMOUNT){
1696             depositTenByProject(pid,_lpTenAmount);
1697         }
1698         emit AddPool(msg.sender, pid, _tokenAmount,_lpTenAmount);
1699     }
1700     function updateAllocPoint() public {
1701         if(lastModifyAllocPointBlock.add(modifyAllocPointPeriod) <= block.number){
1702             uint256 totalLPTokenAmount = tenProjectPool.lpTokenTotalAmount.mul(bonusAllocPointBlock.add(1e4)).div(1e4).add(tenUserPool.lpTokenTotalAmount);
1703             if(totalLPTokenAmount > 0)
1704             {
1705                 tenProjectPool.allocPoint = tenProjectPool.allocPoint.add(tenProjectPool.lpTokenTotalAmount.mul(1e4).mul(bonusAllocPointBlock.add(1e4)).div(1e4).div(totalLPTokenAmount)).div(2);
1706                 tenUserPool.allocPoint = tenUserPool.allocPoint.add(tenUserPool.lpTokenTotalAmount.mul(1e4).div(totalLPTokenAmount)).div(2);
1707                 totalAllocPoint = tenProjectPool.allocPoint.add(tenUserPool.allocPoint);
1708                 lastModifyAllocPointBlock = block.number;
1709                 require(totalAllocPoint > 0, "updateAllocPoint: Alloc Point invalid");
1710             }
1711         }     
1712     }
1713     // Update reward variables of the given pool to be up-to-date.
1714     function _minePoolTen(TenPoolInfo storage tenPool) internal {
1715         if (block.number <= tenPool.lastRewardBlock) {
1716             return;
1717         }
1718         if (tenPool.lpTokenTotalAmount < MINLPTOKEN_AMOUNT) {
1719             tenPool.lastRewardBlock = block.number;
1720             return;
1721         }
1722         if(emergencyWithdraw > 0){
1723             tenPool.lastRewardBlock = block.number;
1724             return;                
1725         }
1726         uint256 tenReward = tenMineCalc.calcMineTenReward(tenPool.lastRewardBlock, block.number);
1727         if(tenReward > 0){
1728             tenReward = tenReward.mul(tenPool.allocPoint).div(totalAllocPoint);
1729             devaddrAmount = devaddrAmount.add(tenReward.div(10));
1730             ten.mint(address(this), tenReward);
1731             tenPool.accTenPerShare = tenPool.accTenPerShare.add(tenReward.mul(PERSHARERATE).div(tenPool.lpTokenTotalAmount));
1732         }
1733         tenPool.lastRewardBlock = block.number;
1734         updateAllocPoint();
1735     }
1736     function _withdrawProjectTenPool(PoolInfo storage pool) internal returns (uint256 pending){
1737         if (pool.amount >= MINLPTOKEN_AMOUNT) {
1738             pending = pool.amount.mul(tenProjectPool.accTenPerShare).div(PERSHARERATE).sub(pool.rewardTenDebt);
1739             if(pending > 0){
1740                 if(pool.userCount == 0){
1741                     ten.burn(address(this),pending);
1742                     pending = 0;
1743                 }
1744                 else{
1745                     if(pool.userCount<minProjectUserCount){
1746                         uint256 newPending = pending.mul(bonusAllocPointBlock.mul(pool.userCount).div(minProjectUserCount).add(1e4)).div(bonusAllocPointBlock.add(1e4));
1747                         if(pending.sub(newPending) > 0){
1748                             ten.burn(address(this),pending.sub(newPending));
1749                         }
1750                         pending = newPending;
1751                     }                    
1752                     pool.accTenPerShare = pool.accTenPerShare.add(pending.mul(PERSHARERATE).div(pool.lpTokenTotalAmount));
1753                 }
1754             }
1755         }
1756     }
1757     function _updateProjectTenPoolAmount(PoolInfo storage pool,uint256 _amount,uint256 amountType) internal{
1758         if(amountType == 1){
1759             lpTokenTen.safeTransferFrom(msg.sender, address(this), _amount);
1760             tenProjectPool.lpTokenTotalAmount = tenProjectPool.lpTokenTotalAmount.add(_amount);
1761             pool.amount = pool.amount.add(_amount);
1762         }else if(amountType == 2){
1763             pool.amount = pool.amount.sub(_amount);
1764             lpTokenTen.safeTransfer(address(msg.sender), _amount);
1765             tenProjectPool.lpTokenTotalAmount = tenProjectPool.lpTokenTotalAmount.sub(_amount);
1766         }
1767         pool.rewardTenDebt = pool.amount.mul(tenProjectPool.accTenPerShare).div(PERSHARERATE);
1768     }
1769     function depositTenByProject(uint256 _pid,uint256 _amount) public onlyNotEmergencyWithdraw {
1770         require(_amount > 0, "depositTenByProject: lpamount not good");
1771         PoolInfo storage pool = poolInfo[_pid];
1772         PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
1773         require(poolSetting.projectAddr == msg.sender, "depositTenByProject: not good");
1774         _minePoolTen(tenProjectPool);
1775         _withdrawProjectTenPool(pool);
1776         _updateProjectTenPoolAmount(pool,_amount,1);
1777         emit DepositLPTen(msg.sender, 1, _amount,0,0,0);
1778     }
1779 
1780     function withdrawTenByProject(uint256 _pid,uint256 _amount) public {
1781         PoolInfo storage pool = poolInfo[_pid];
1782         PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
1783         require(poolSetting.projectAddr == msg.sender, "withdrawTenByProject: not good");
1784         require(pool.amount >= _amount, "withdrawTenByProject: not good");
1785         if(emergencyWithdraw == 0){
1786             _minePoolTen(tenProjectPool);
1787             _withdrawProjectTenPool(pool);
1788         }else{
1789             if(pool.lastRewardBlock < poolSetting.endBlock){
1790                 if(poolSetting.tokenAmount.sub(pool.mineTokenAmount) > 0){
1791                     IERC20(poolSetting.tokenAddr).safeTransfer(poolSetting.projectAddr,poolSetting.tokenAmount.sub(pool.mineTokenAmount));
1792                 }
1793             }
1794         }
1795         if(_amount > 0){
1796             _updateProjectTenPoolAmount(pool,_amount,2);
1797         }
1798         emit WithdrawLPTen(msg.sender, 1, _amount,0,0,0);
1799     }
1800 
1801     function _updatePoolUserInfo(uint256 accTenPerShare,UserInfo storage user,uint256 _freezeBlocks,uint256 _freezeTen,uint256 _amount,uint256 _amountType) internal {
1802         if(_amountType == 1){
1803             user.amount = user.amount.add(_amount);
1804         }else if(_amountType == 2){
1805             user.amount = user.amount.sub(_amount);      
1806         }
1807         user.rewardTenDebt = user.amount.mul(accTenPerShare).div(PERSHARERATE);
1808         user.lastBlockNumber = block.number;
1809         user.freezeBlocks = _freezeBlocks;
1810         user.freezeTen = _freezeTen;
1811     }
1812     function _calcFreezeTen(UserInfo storage user,uint256 accTenPerShare) internal view returns (uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen){
1813         pendingTen = user.amount.mul(accTenPerShare).div(PERSHARERATE).sub(user.rewardTenDebt);
1814         uint256 blockNow = 0;
1815         if(pendingTen>0){
1816             if(user.lastBlockNumber<tenMineCalc.startBlock()){
1817                 blockNow = block.number.sub(tenMineCalc.startBlock());
1818             }else{
1819                 blockNow = block.number.sub(user.lastBlockNumber);
1820             }
1821         }else{
1822             if(user.freezeTen > 0){
1823                 blockNow = block.number.sub(user.lastBlockNumber);
1824             }
1825         }
1826         uint256 periodBlockNumer = tenMineCalc.subBlockNumerPeriod();
1827         freezeBlocks = blockNow.add(user.freezeBlocks);
1828         if(freezeBlocks <= periodBlockNumer){
1829             freezeTen = pendingTen.add(user.freezeTen);
1830             pendingTen = 0;
1831         }else{
1832             if(pendingTen == 0){
1833                 freezeBlocks = 0;
1834                 freezeTen = 0;
1835                 pendingTen = user.freezeTen;
1836             }else{
1837                 freezeTen = pendingTen.add(user.freezeTen).mul(periodBlockNumer).div(freezeBlocks);
1838                 pendingTen = pendingTen.add(user.freezeTen).sub(freezeTen);
1839                 freezeBlocks = periodBlockNumer;
1840             }            
1841         }        
1842     }
1843     function _withdrawUserTenPool(address userAddr,UserInfo storage user) internal returns (uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen){
1844         (pendingTen,freezeBlocks,freezeTen) = _calcFreezeTen(user,tenUserPool.accTenPerShare);
1845         safeTenTransfer(userAddr, pendingTen);
1846     }   
1847     function depositTenByUser(uint256 _amount) public onlyNotEmergencyWithdraw {
1848         require(_amount > 0, "depositTenByUser: lpamount not good");
1849         UserInfo storage user = userInfoUserPool[msg.sender];
1850         _minePoolTen(tenUserPool);
1851         (uint256 pending,uint256 freezeBlocks,uint256 freezeTen) = _withdrawUserTenPool(msg.sender,user);
1852         lpTokenTen.safeTransferFrom(address(msg.sender), address(this), _amount);
1853         _updatePoolUserInfo(tenUserPool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,1);
1854         tenUserPool.lpTokenTotalAmount = tenUserPool.lpTokenTotalAmount.add(_amount);        
1855         emit DepositLPTen(msg.sender, 2, _amount,pending,freezeTen,freezeBlocks);
1856     }
1857 
1858     function withdrawTenByUser(uint256 _amount) public {
1859         require(_amount > 0, "withdrawTenByUser: lpamount not good");
1860         UserInfo storage user = userInfoUserPool[msg.sender];
1861         require(user.amount >= _amount, "withdrawTenByUser: not good");
1862         if(emergencyWithdraw == 0){
1863             _minePoolTen(tenUserPool);
1864             (uint256 pending,uint256 freezeBlocks,uint256 freezeTen) = _withdrawUserTenPool(msg.sender,user);
1865             _updatePoolUserInfo(tenUserPool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,2);
1866             emit WithdrawLPTen(msg.sender, 2, _amount,pending,freezeTen,freezeBlocks);
1867         }else{
1868             _updatePoolUserInfo(tenUserPool.accTenPerShare,user,user.freezeBlocks,user.freezeTen,_amount,2);
1869             emit WithdrawLPTen(msg.sender, 2, _amount,0,user.freezeTen,user.freezeBlocks);
1870         }
1871         tenUserPool.lpTokenTotalAmount = tenUserPool.lpTokenTotalAmount.sub(_amount);          
1872         lpTokenTen.safeTransfer(address(msg.sender), _amount);
1873     }
1874     function mineLPTen() public onlyNotEmergencyWithdraw {
1875         _minePoolTen(tenUserPool);
1876         UserInfo storage user = userInfoUserPool[msg.sender];
1877         (uint256 pending,uint256 freezeBlocks,uint256 freezeTen) = _withdrawUserTenPool(msg.sender,user);
1878         _updatePoolUserInfo(tenUserPool.accTenPerShare,user,freezeBlocks,freezeTen,0,0);
1879         emit MineLPTen(msg.sender,pending,freezeTen,freezeBlocks);
1880     }
1881     function depositTenByUserFrom(address _from,uint256 _amount) public onlyNotEmergencyWithdraw {
1882         require(_amount > 0, "depositTenByUserFrom: lpamount not good");
1883         UserInfo storage user = userInfoUserPool[_from];
1884         _minePoolTen(tenUserPool);
1885         (uint256 pending,uint256 freezeBlocks,uint256 freezeTen) = _withdrawUserTenPool(_from,user);
1886         lpTokenTen.safeTransferFrom(address(msg.sender), address(this), _amount);
1887         _updatePoolUserInfo(tenUserPool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,1);
1888         tenUserPool.lpTokenTotalAmount = tenUserPool.lpTokenTotalAmount.add(_amount);        
1889         emit DepositLPTen(_from, 2, _amount,pending,freezeTen,freezeBlocks);
1890     } 
1891     function _minePoolToken(PoolInfo storage pool,PoolSettingInfo storage poolSetting) internal {
1892         if (block.number <= pool.lastRewardBlock) {
1893             return;
1894         }
1895         if (pool.lpTokenTotalAmount >= MINLPTOKEN_AMOUNT) {
1896             uint256 multiplier = tenMineCalc.getMultiplier(pool.lastRewardBlock, block.number,poolSetting.endBlock,poolSetting.tokenBonusEndBlock,poolSetting.tokenBonusMultipler);
1897             if(multiplier > 0){
1898                 uint256 tokenReward = multiplier.mul(poolSetting.tokenPerBlock);
1899                 pool.mineTokenAmount = pool.mineTokenAmount.add(tokenReward);
1900                 pool.accTokenPerShare = pool.accTokenPerShare.add(tokenReward.mul(PERSHARERATE).div(pool.lpTokenTotalAmount));
1901             }
1902         }
1903         if(pool.lastRewardBlock < poolSetting.endBlock){
1904             if(block.number >= poolSetting.endBlock){
1905                 if(poolSetting.tokenAmount.sub(pool.mineTokenAmount) > 0){
1906                     IERC20(poolSetting.tokenAddr).safeTransfer(poolSetting.projectAddr,poolSetting.tokenAmount.sub(pool.mineTokenAmount));
1907                 }
1908             }
1909         }
1910         pool.lastRewardBlock = block.number;
1911         _minePoolTen(tenProjectPool);
1912         _withdrawProjectTenPool(pool);
1913         _updateProjectTenPoolAmount(pool,0,0);
1914     }
1915     function _withdrawTokenPool(address userAddr,PoolInfo storage pool,UserInfo storage user,PoolSettingInfo storage poolSetting) 
1916             internal returns (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen){
1917         if (user.amount >= MINLPTOKEN_AMOUNT) {
1918             pendingToken = user.amount.mul(pool.accTokenPerShare).div(PERSHARERATE).sub(user.rewardTokenDebt);
1919             if(pendingToken > 0){
1920                 IERC20(poolSetting.tokenAddr).safeTransfer(userAddr, pendingToken);
1921             }
1922             (pendingTen,freezeBlocks,freezeTen) = _calcFreezeTen(user,pool.accTenPerShare);
1923             safeTenTransfer(userAddr, pendingTen);
1924         }
1925     }
1926     function _updateTokenPoolUser(uint256 accTokenPerShare,uint256 accTenPerShare,UserInfo storage user,uint256 _freezeBlocks,uint256 _freezeTen,uint256 _amount,uint256 _amountType) 
1927             internal {
1928         _updatePoolUserInfo(accTenPerShare,user,_freezeBlocks,_freezeTen,_amount,_amountType);
1929         user.rewardTokenDebt = user.amount.mul(accTokenPerShare).div(PERSHARERATE);
1930     }
1931     function depositLPToken(uint256 _pid, uint256 _amount) public onlyNotEmergencyWithdraw {
1932         require(_amount > 0, "depositLPToken: lpamount not good");
1933         PoolInfo storage pool = poolInfo[_pid];
1934         PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
1935         UserInfo storage user = userInfo[_pid][msg.sender];
1936         _minePoolToken(pool,poolSetting);
1937         (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen) = _withdrawTokenPool(msg.sender,pool,user,poolSetting);
1938         if (user.amount < MINLPTOKEN_AMOUNT) {
1939             pool.userCount = pool.userCount.add(1);
1940         }
1941         IERC20(poolSetting.lpToken).safeTransferFrom(address(msg.sender), address(this), _amount);
1942         pool.lpTokenTotalAmount = pool.lpTokenTotalAmount.add(_amount);
1943         _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,1);
1944         emit Deposit(msg.sender, _pid, _amount,pendingToken,pendingTen,freezeTen,freezeBlocks);
1945     }
1946 
1947     function withdrawLPToken(uint256 _pid, uint256 _amount) public {
1948         require(_amount > 0, "withdrawLPToken: lpamount not good");
1949         PoolInfo storage pool = poolInfo[_pid];
1950         UserInfo storage user = userInfo[_pid][msg.sender];
1951         PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
1952         require(user.amount >= _amount, "withdrawLPToken: not good");
1953         if(emergencyWithdraw == 0){
1954             _minePoolToken(pool,poolSetting);
1955             (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen) = _withdrawTokenPool(msg.sender,pool,user,poolSetting);
1956             _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,2);
1957             emit Withdraw(msg.sender, _pid, _amount,pendingToken,pendingTen,freezeTen,freezeBlocks);
1958         }else{
1959             _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,user.freezeBlocks,user.freezeTen,_amount,2);
1960             emit Withdraw(msg.sender, _pid, _amount,0,0,user.freezeTen,user.freezeBlocks);
1961         }
1962         IERC20(poolSetting.lpToken).safeTransfer(address(msg.sender), _amount);
1963         pool.lpTokenTotalAmount = pool.lpTokenTotalAmount.sub(_amount);
1964         if(user.amount < MINLPTOKEN_AMOUNT){
1965             pool.userCount = pool.userCount.sub(1);
1966         }
1967     }
1968 
1969     function mineLPToken(uint256 _pid) public onlyNotEmergencyWithdraw {
1970         PoolInfo storage pool = poolInfo[_pid];
1971         UserInfo storage user = userInfo[_pid][msg.sender];
1972         PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
1973         _minePoolToken(pool,poolSetting);
1974         (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen) = _withdrawTokenPool(msg.sender,pool,user,poolSetting);
1975         _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,freezeBlocks,freezeTen,0,0);
1976         emit MineLPToken(msg.sender, _pid, pendingToken,pendingTen,freezeTen,freezeBlocks);
1977     }
1978 
1979     function depositLPTokenFrom(address _from,uint256 _pid, uint256 _amount) public onlyNotEmergencyWithdraw {
1980         require(_amount > 0, "depositLPTokenFrom: lpamount not good");
1981         PoolInfo storage pool = poolInfo[_pid];
1982         UserInfo storage user = userInfo[_pid][_from];
1983         PoolSettingInfo storage poolSetting = poolSettingInfo[_pid];
1984         _minePoolToken(pool,poolSetting);
1985         (uint256 pendingToken,uint256 pendingTen,uint256 freezeBlocks,uint256 freezeTen) = _withdrawTokenPool(_from,pool,user,poolSetting);
1986         if (user.amount < MINLPTOKEN_AMOUNT) {
1987             pool.userCount = pool.userCount.add(1);
1988         }
1989         IERC20(poolSetting.lpToken).safeTransferFrom(msg.sender, address(this), _amount);
1990         pool.lpTokenTotalAmount = pool.lpTokenTotalAmount.add(_amount);
1991         _updateTokenPoolUser(pool.accTokenPerShare,pool.accTenPerShare,user,freezeBlocks,freezeTen,_amount,1);
1992         emit DepositFrom(_from, _pid, _amount,msg.sender,pendingToken,pendingTen,freezeTen,freezeBlocks);
1993     }
1994  
1995     function dev(address _devaddr) public {
1996         require(msg.sender == devaddr, "dev: wut?");
1997         devaddr = _devaddr;
1998     }
1999 
2000     function devWithdraw(uint256 _amount) public {
2001         require(block.number >= devWithdrawStartBlock, "devWithdraw: start Block invalid");
2002         require(msg.sender == devaddr, "devWithdraw: devaddr invalid");
2003         require(devaddrAmount >= _amount, "devWithdraw: amount invalid");        
2004         ten.mint(devaddr,_amount);
2005         devaddrAmount = devaddrAmount.sub(_amount);
2006         emit DevWithdraw(msg.sender, _amount);
2007     }    
2008 
2009     function safeTenTransfer(address _to, uint256 _amount) internal {
2010         if(_amount > 0){
2011             uint256 bal = ten.balanceOf(address(this));
2012             if (_amount > bal) {
2013                 if(bal > 0){
2014                     IERC20(address(ten)).safeTransfer(_to, bal);
2015                 }
2016             } else {
2017                 IERC20(address(ten)).safeTransfer(_to, _amount);
2018             }
2019         }
2020     }        
2021 }