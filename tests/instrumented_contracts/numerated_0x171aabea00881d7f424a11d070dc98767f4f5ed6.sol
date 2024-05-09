1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.5.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
39  * the optional functions; to access them see {ERC20Detailed}.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 // File: @openzeppelin/contracts/math/SafeMath.sol
113 
114 pragma solidity ^0.5.0;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      * - Subtraction cannot overflow.
167      *
168      * _Available since v2.4.0._
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         // Solidity only automatically asserts when dividing by 0
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      *
263      * _Available since v2.4.0._
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
272 
273 pragma solidity ^0.5.0;
274 
275 
276 
277 
278 /**
279  * @dev Implementation of the {IERC20} interface.
280  *
281  * This implementation is agnostic to the way tokens are created. This means
282  * that a supply mechanism has to be added in a derived contract using {_mint}.
283  * For a generic mechanism see {ERC20Mintable}.
284  *
285  * TIP: For a detailed writeup see our guide
286  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
287  * to implement supply mechanisms].
288  *
289  * We have followed general OpenZeppelin guidelines: functions revert instead
290  * of returning `false` on failure. This behavior is nonetheless conventional
291  * and does not conflict with the expectations of ERC20 applications.
292  *
293  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
294  * This allows applications to reconstruct the allowance for all accounts just
295  * by listening to said events. Other implementations of the EIP may not emit
296  * these events, as it isn't required by the specification.
297  *
298  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
299  * functions have been added to mitigate the well-known issues around setting
300  * allowances. See {IERC20-approve}.
301  */
302 contract ERC20 is Context, IERC20 {
303     using SafeMath for uint256;
304 
305     mapping (address => uint256) private _balances;
306 
307     mapping (address => mapping (address => uint256)) private _allowances;
308 
309     uint256 private _totalSupply;
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(address account) public view returns (uint256) {
322         return _balances[account];
323     }
324 
325     /**
326      * @dev See {IERC20-transfer}.
327      *
328      * Requirements:
329      *
330      * - `recipient` cannot be the zero address.
331      * - the caller must have a balance of at least `amount`.
332      */
333     function transfer(address recipient, uint256 amount) public returns (bool) {
334         _transfer(_msgSender(), recipient, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-allowance}.
340      */
341     function allowance(address owner, address spender) public view returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See {IERC20-approve}.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(address spender, uint256 amount) public returns (bool) {
353         _approve(_msgSender(), spender, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-transferFrom}.
359      *
360      * Emits an {Approval} event indicating the updated allowance. This is not
361      * required by the EIP. See the note at the beginning of {ERC20};
362      *
363      * Requirements:
364      * - `sender` and `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      * - the caller must have allowance for `sender`'s tokens of at least
367      * `amount`.
368      */
369     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
370         _transfer(sender, recipient, amount);
371         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
407         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
408         return true;
409     }
410 
411     /**
412      * @dev Moves tokens `amount` from `sender` to `recipient`.
413      *
414      * This is internal function is equivalent to {transfer}, and can be used to
415      * e.g. implement automatic token fees, slashing mechanisms, etc.
416      *
417      * Emits a {Transfer} event.
418      *
419      * Requirements:
420      *
421      * - `sender` cannot be the zero address.
422      * - `recipient` cannot be the zero address.
423      * - `sender` must have a balance of at least `amount`.
424      */
425     function _transfer(address sender, address recipient, uint256 amount) internal {
426         require(sender != address(0), "ERC20: transfer from the zero address");
427         require(recipient != address(0), "ERC20: transfer to the zero address");
428 
429         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
430         _balances[recipient] = _balances[recipient].add(amount);
431         emit Transfer(sender, recipient, amount);
432     }
433 
434     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
435      * the total supply.
436      *
437      * Emits a {Transfer} event with `from` set to the zero address.
438      *
439      * Requirements
440      *
441      * - `to` cannot be the zero address.
442      */
443     function _mint(address account, uint256 amount) internal {
444         require(account != address(0), "ERC20: mint to the zero address");
445 
446         _totalSupply = _totalSupply.add(amount);
447         _balances[account] = _balances[account].add(amount);
448         emit Transfer(address(0), account, amount);
449     }
450 
451     /**
452      * @dev Destroys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a {Transfer} event with `to` set to the zero address.
456      *
457      * Requirements
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 amount) internal {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
466         _totalSupply = _totalSupply.sub(amount);
467         emit Transfer(account, address(0), amount);
468     }
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
472      *
473      * This is internal function is equivalent to `approve`, and can be used to
474      * e.g. set automatic allowances for certain subsystems, etc.
475      *
476      * Emits an {Approval} event.
477      *
478      * Requirements:
479      *
480      * - `owner` cannot be the zero address.
481      * - `spender` cannot be the zero address.
482      */
483     function _approve(address owner, address spender, uint256 amount) internal {
484         require(owner != address(0), "ERC20: approve from the zero address");
485         require(spender != address(0), "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = amount;
488         emit Approval(owner, spender, amount);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
493      * from the caller's allowance.
494      *
495      * See {_burn} and {_approve}.
496      */
497     function _burnFrom(address account, uint256 amount) internal {
498         _burn(account, amount);
499         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
500     }
501 }
502 
503 // File: @openzeppelin/contracts/utils/Address.sol
504 
505 pragma solidity ^0.5.5;
506 
507 /**
508  * @dev Collection of functions related to the address type
509  */
510 library Address {
511     /**
512      * @dev Returns true if `account` is a contract.
513      *
514      * [IMPORTANT]
515      * ====
516      * It is unsafe to assume that an address for which this function returns
517      * false is an externally-owned account (EOA) and not a contract.
518      *
519      * Among others, `isContract` will return false for the following
520      * types of addresses:
521      *
522      *  - an externally-owned account
523      *  - a contract in construction
524      *  - an address where a contract will be created
525      *  - an address where a contract lived, but was destroyed
526      * ====
527      */
528     function isContract(address account) internal view returns (bool) {
529         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
530         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
531         // for accounts without code, i.e. `keccak256('')`
532         bytes32 codehash;
533         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
534         // solhint-disable-next-line no-inline-assembly
535         assembly { codehash := extcodehash(account) }
536         return (codehash != accountHash && codehash != 0x0);
537     }
538 
539     /**
540      * @dev Converts an `address` into `address payable`. Note that this is
541      * simply a type cast: the actual underlying value is not changed.
542      *
543      * _Available since v2.4.0._
544      */
545     function toPayable(address account) internal pure returns (address payable) {
546         return address(uint160(account));
547     }
548 
549     /**
550      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
551      * `recipient`, forwarding all available gas and reverting on errors.
552      *
553      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
554      * of certain opcodes, possibly making contracts go over the 2300 gas limit
555      * imposed by `transfer`, making them unable to receive funds via
556      * `transfer`. {sendValue} removes this limitation.
557      *
558      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
559      *
560      * IMPORTANT: because control is transferred to `recipient`, care must be
561      * taken to not create reentrancy vulnerabilities. Consider using
562      * {ReentrancyGuard} or the
563      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
564      *
565      * _Available since v2.4.0._
566      */
567     function sendValue(address payable recipient, uint256 amount) internal {
568         require(address(this).balance >= amount, "Address: insufficient balance");
569 
570         // solhint-disable-next-line avoid-call-value
571         (bool success, ) = recipient.call.value(amount)("");
572         require(success, "Address: unable to send value, recipient may have reverted");
573     }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
577 
578 pragma solidity ^0.5.0;
579 
580 
581 
582 
583 /**
584  * @title SafeERC20
585  * @dev Wrappers around ERC20 operations that throw on failure (when the token
586  * contract returns false). Tokens that return no value (and instead revert or
587  * throw on failure) are also supported, non-reverting calls are assumed to be
588  * successful.
589  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
590  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
591  */
592 library SafeERC20 {
593     using SafeMath for uint256;
594     using Address for address;
595 
596     function safeTransfer(IERC20 token, address to, uint256 value) internal {
597         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
598     }
599 
600     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
601         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
602     }
603 
604     function safeApprove(IERC20 token, address spender, uint256 value) internal {
605         // safeApprove should only be called when setting an initial allowance,
606         // or when resetting it to zero. To increase and decrease it, use
607         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
608         // solhint-disable-next-line max-line-length
609         require((value == 0) || (token.allowance(address(this), spender) == 0),
610             "SafeERC20: approve from non-zero to non-zero allowance"
611         );
612         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
613     }
614 
615     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
616         uint256 newAllowance = token.allowance(address(this), spender).add(value);
617         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
618     }
619 
620     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
621         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
622         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
623     }
624 
625     /**
626      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
627      * on the return value: the return value is optional (but if data is returned, it must not be false).
628      * @param token The token targeted by the call.
629      * @param data The call data (encoded using abi.encode or one of its variants).
630      */
631     function callOptionalReturn(IERC20 token, bytes memory data) private {
632         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
633         // we're implementing it ourselves.
634 
635         // A Solidity high level call has three parts:
636         //  1. The target address is checked to verify it contains contract code
637         //  2. The call itself is made, and success asserted
638         //  3. The return value is decoded, which in turn checks the size of the returned data.
639         // solhint-disable-next-line max-line-length
640         require(address(token).isContract(), "SafeERC20: call to non-contract");
641 
642         // solhint-disable-next-line avoid-low-level-calls
643         (bool success, bytes memory returndata) = address(token).call(data);
644         require(success, "SafeERC20: low-level call failed");
645 
646         if (returndata.length > 0) { // Return data is optional
647             // solhint-disable-next-line max-line-length
648             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
649         }
650     }
651 }
652 
653 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
654 
655 pragma solidity ^0.5.0;
656 
657 
658 /**
659  * @dev Optional functions from the ERC20 standard.
660  */
661 contract ERC20Detailed is IERC20 {
662     string private _name;
663     string private _symbol;
664     uint8 private _decimals;
665 
666     /**
667      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
668      * these values are immutable: they can only be set once during
669      * construction.
670      */
671     constructor (string memory name, string memory symbol, uint8 decimals) public {
672         _name = name;
673         _symbol = symbol;
674         _decimals = decimals;
675     }
676 
677     /**
678      * @dev Returns the name of the token.
679      */
680     function name() public view returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev Returns the symbol of the token, usually a shorter version of the
686      * name.
687      */
688     function symbol() public view returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev Returns the number of decimals used to get its user representation.
694      * For example, if `decimals` equals `2`, a balance of `505` tokens should
695      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
696      *
697      * Tokens usually opt for a value of 18, imitating the relationship between
698      * Ether and Wei.
699      *
700      * NOTE: This information is only used for _display_ purposes: it in
701      * no way affects any of the arithmetic of the contract, including
702      * {IERC20-balanceOf} and {IERC20-transfer}.
703      */
704     function decimals() public view returns (uint8) {
705         return _decimals;
706     }
707 }
708 
709 // File: @openzeppelin/contracts/access/Roles.sol
710 
711 pragma solidity ^0.5.0;
712 
713 /**
714  * @title Roles
715  * @dev Library for managing addresses assigned to a Role.
716  */
717 library Roles {
718     struct Role {
719         mapping (address => bool) bearer;
720     }
721 
722     /**
723      * @dev Give an account access to this role.
724      */
725     function add(Role storage role, address account) internal {
726         require(!has(role, account), "Roles: account already has role");
727         role.bearer[account] = true;
728     }
729 
730     /**
731      * @dev Remove an account's access to this role.
732      */
733     function remove(Role storage role, address account) internal {
734         require(has(role, account), "Roles: account does not have role");
735         role.bearer[account] = false;
736     }
737 
738     /**
739      * @dev Check if an account has this role.
740      * @return bool
741      */
742     function has(Role storage role, address account) internal view returns (bool) {
743         require(account != address(0), "Roles: account is the zero address");
744         return role.bearer[account];
745     }
746 }
747 
748 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
749 
750 pragma solidity ^0.5.0;
751 
752 
753 
754 contract PauserRole is Context {
755     using Roles for Roles.Role;
756 
757     event PauserAdded(address indexed account);
758     event PauserRemoved(address indexed account);
759 
760     Roles.Role private _pausers;
761 
762     constructor () internal {
763         _addPauser(_msgSender());
764     }
765 
766     modifier onlyPauser() {
767         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
768         _;
769     }
770 
771     function isPauser(address account) public view returns (bool) {
772         return _pausers.has(account);
773     }
774 
775     function addPauser(address account) public onlyPauser {
776         _addPauser(account);
777     }
778 
779     function renouncePauser() public {
780         _removePauser(_msgSender());
781     }
782 
783     function _addPauser(address account) internal {
784         _pausers.add(account);
785         emit PauserAdded(account);
786     }
787 
788     function _removePauser(address account) internal {
789         _pausers.remove(account);
790         emit PauserRemoved(account);
791     }
792 }
793 
794 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
795 
796 pragma solidity ^0.5.0;
797 
798 /**
799  * @dev Contract module that helps prevent reentrant calls to a function.
800  *
801  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
802  * available, which can be applied to functions to make sure there are no nested
803  * (reentrant) calls to them.
804  *
805  * Note that because there is a single `nonReentrant` guard, functions marked as
806  * `nonReentrant` may not call one another. This can be worked around by making
807  * those functions `private`, and then adding `external` `nonReentrant` entry
808  * points to them.
809  *
810  * TIP: If you would like to learn more about reentrancy and alternative ways
811  * to protect against it, check out our blog post
812  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
813  *
814  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
815  * metering changes introduced in the Istanbul hardfork.
816  */
817 contract ReentrancyGuard {
818     bool private _notEntered;
819 
820     constructor () internal {
821         // Storing an initial non-zero value makes deployment a bit more
822         // expensive, but in exchange the refund on every call to nonReentrant
823         // will be lower in amount. Since refunds are capped to a percetange of
824         // the total transaction's gas, it is best to keep them low in cases
825         // like this one, to increase the likelihood of the full refund coming
826         // into effect.
827         _notEntered = true;
828     }
829 
830     /**
831      * @dev Prevents a contract from calling itself, directly or indirectly.
832      * Calling a `nonReentrant` function from another `nonReentrant`
833      * function is not supported. It is possible to prevent this from happening
834      * by making the `nonReentrant` function external, and make it call a
835      * `private` function that does the actual work.
836      */
837     modifier nonReentrant() {
838         // On the first call to nonReentrant, _notEntered will be true
839         require(_notEntered, "ReentrancyGuard: reentrant call");
840 
841         // Any calls to nonReentrant after this point will fail
842         _notEntered = false;
843 
844         _;
845 
846         // By storing the original value once again, a refund is triggered (see
847         // https://eips.ethereum.org/EIPS/eip-2200)
848         _notEntered = true;
849     }
850 }
851 
852 // File: @openzeppelin/contracts/ownership/Ownable.sol
853 
854 pragma solidity ^0.5.0;
855 
856 /**
857  * @dev Contract module which provides a basic access control mechanism, where
858  * there is an account (an owner) that can be granted exclusive access to
859  * specific functions.
860  *
861  * This module is used through inheritance. It will make available the modifier
862  * `onlyOwner`, which can be applied to your functions to restrict their use to
863  * the owner.
864  */
865 contract Ownable is Context {
866     address private _owner;
867 
868     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
869 
870     /**
871      * @dev Initializes the contract setting the deployer as the initial owner.
872      */
873     constructor () internal {
874         address msgSender = _msgSender();
875         _owner = msgSender;
876         emit OwnershipTransferred(address(0), msgSender);
877     }
878 
879     /**
880      * @dev Returns the address of the current owner.
881      */
882     function owner() public view returns (address) {
883         return _owner;
884     }
885 
886     /**
887      * @dev Throws if called by any account other than the owner.
888      */
889     modifier onlyOwner() {
890         require(isOwner(), "Ownable: caller is not the owner");
891         _;
892     }
893 
894     /**
895      * @dev Returns true if the caller is the current owner.
896      */
897     function isOwner() public view returns (bool) {
898         return _msgSender() == _owner;
899     }
900 
901     /**
902      * @dev Leaves the contract without owner. It will not be possible to call
903      * `onlyOwner` functions anymore. Can only be called by the current owner.
904      *
905      * NOTE: Renouncing ownership will leave the contract without an owner,
906      * thereby removing any functionality that is only available to the owner.
907      */
908     function renounceOwnership() public onlyOwner {
909         emit OwnershipTransferred(_owner, address(0));
910         _owner = address(0);
911     }
912 
913     /**
914      * @dev Transfers ownership of the contract to a new account (`newOwner`).
915      * Can only be called by the current owner.
916      */
917     function transferOwnership(address newOwner) public onlyOwner {
918         _transferOwnership(newOwner);
919     }
920 
921     /**
922      * @dev Transfers ownership of the contract to a new account (`newOwner`).
923      */
924     function _transferOwnership(address newOwner) internal {
925         require(newOwner != address(0), "Ownable: new owner is the zero address");
926         emit OwnershipTransferred(_owner, newOwner);
927         _owner = newOwner;
928     }
929 }
930 
931 
932 pragma solidity ^0.5.17;
933 
934 
935 // Interface
936 
937 interface ITendies {
938     function grillPool() external;
939     function claimRewards() external;
940 }
941 
942 /**
943  * @title TendiesFarm
944  * @author Weeb_Mcgee on twitter / YieldFarming.info
945  */
946 contract TendiesFarm is ERC20, ERC20Detailed, Ownable, ReentrancyGuard {
947     using SafeMath for uint256;
948     using SafeERC20 for ERC20;
949     
950     ERC20 public TEND;
951     ITendies private ITEND;
952     
953     uint256 constant private _burnFeeRate = 5;
954     uint256 constant private _burnFeeBase = 10000;
955     
956     event Mint(address indexed user, uint256 mintAmount, uint256 timestamp);
957     event Burn(address indexed user, uint256 burnAmount, uint256 timestamp);
958 
959     /**
960      * @dev Set contract deployer as owner
961      */
962     constructor() public ERC20Detailed("TendiesFarm", "weebTEND", 18) {
963          TEND = ERC20(0x1453Dbb8A29551ADe11D89825CA812e05317EAEB);
964          ITEND = ITendies(0x1453Dbb8A29551ADe11D89825CA812e05317EAEB);
965     }
966     
967     // Mint weebTEND with TEND
968     function mint(uint256 amount) public {
969         require(amount <= TEND.balanceOf(msg.sender), ">TEND.balanceOf");
970         uint256 totalStakedTendiesBefore = getTotalStakedTendies();
971         
972         // Stake tendies
973         TEND.safeTransferFrom(msg.sender, address(this), amount);
974     
975         uint256 totalStakedTendiesAfter = getTotalStakedTendies();
976         
977         if (totalSupply() == 0) {
978             return super._mint(msg.sender, amount);
979         }
980 
981         uint256 mintAmount = (totalStakedTendiesAfter.sub(totalStakedTendiesBefore))
982             .mul(totalSupply())
983             .div(totalStakedTendiesBefore);
984         
985         emit Mint(msg.sender, mintAmount, block.timestamp);
986         return super._mint(msg.sender, mintAmount);
987     }
988     
989     // Burn weebTEND to get collected TEND
990     function burn(uint256 amount) public nonReentrant {
991         require(amount <= balanceOf(msg.sender), ">weebTEND.balanceOf");
992         
993         // Burn weebTEND
994         uint256 proRataTend = getTotalStakedTendies().mul(amount).div(totalSupply());
995         super._burn(msg.sender, amount);
996         emit Burn(msg.sender, amount, block.timestamp);
997 
998         // Calculate burn fee and transfer underlying TEND
999         uint256 _fee = proRataTend.mul(_burnFeeRate).div(_burnFeeBase);
1000         TEND.safeTransfer(msg.sender, proRataTend.sub(_fee));
1001         TEND.safeTransfer(owner(), _fee);
1002     }
1003     
1004     function getPricePerFullShare() public view returns (uint256 price) {
1005         price = getTotalStakedTendies().mul(1e18).div(totalSupply());
1006     }
1007     
1008     function getTotalStakedTendies() public view returns (uint256 total) {
1009         total = TEND.balanceOf(address(this));
1010     }
1011     
1012     // TEND functions
1013     
1014     function grillPool() external {
1015         ITEND.grillPool();
1016     }
1017     
1018     function claimRewards() external {
1019         ITEND.claimRewards();
1020     }
1021 }