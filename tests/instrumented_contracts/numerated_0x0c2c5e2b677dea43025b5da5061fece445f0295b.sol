1 // File: node_modules\openzeppelin-solidity\contracts\GSN\Context.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19 
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
109 
110 pragma solidity ^0.6.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 // File: node_modules\openzeppelin-solidity\contracts\utils\Address.sol
262 
263 pragma solidity ^0.6.0;
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != accountHash && codehash != 0x0);
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call.value(amount)("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 }
321 
322 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
323 
324 pragma solidity ^0.6.0;
325 
326 
327 
328 
329 
330 /**
331  * @dev Implementation of the {IERC20} interface.
332  *
333  * This implementation is agnostic to the way tokens are created. This means
334  * that a supply mechanism has to be added in a derived contract using {_mint}.
335  * For a generic mechanism see {ERC20MinterPauser}.
336  *
337  * TIP: For a detailed writeup see our guide
338  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
339  * to implement supply mechanisms].
340  *
341  * We have followed general OpenZeppelin guidelines: functions revert instead
342  * of returning `false` on failure. This behavior is nonetheless conventional
343  * and does not conflict with the expectations of ERC20 applications.
344  *
345  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
346  * This allows applications to reconstruct the allowance for all accounts just
347  * by listening to said events. Other implementations of the EIP may not emit
348  * these events, as it isn't required by the specification.
349  *
350  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
351  * functions have been added to mitigate the well-known issues around setting
352  * allowances. See {IERC20-approve}.
353  */
354 contract ERC20 is Context, IERC20 {
355     using SafeMath for uint256;
356     using Address for address;
357 
358     mapping (address => uint256) private _balances;
359 
360     mapping (address => mapping (address => uint256)) private _allowances;
361 
362     uint256 private _totalSupply;
363 
364     string private _name;
365     string private _symbol;
366     uint8 private _decimals;
367 
368     /**
369      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
370      * a default value of 18.
371      *
372      * To select a different value for {decimals}, use {_setupDecimals}.
373      *
374      * All three of these values are immutable: they can only be set once during
375      * construction.
376      */
377     constructor (string memory name, string memory symbol) public {
378         _name = name;
379         _symbol = symbol;
380         _decimals = 18;
381     }
382 
383     /**
384      * @dev Returns the name of the token.
385      */
386     function name() public view returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @dev Returns the symbol of the token, usually a shorter version of the
392      * name.
393      */
394     function symbol() public view returns (string memory) {
395         return _symbol;
396     }
397 
398     /**
399      * @dev Returns the number of decimals used to get its user representation.
400      * For example, if `decimals` equals `2`, a balance of `505` tokens should
401      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
402      *
403      * Tokens usually opt for a value of 18, imitating the relationship between
404      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
405      * called.
406      *
407      * NOTE: This information is only used for _display_ purposes: it in
408      * no way affects any of the arithmetic of the contract, including
409      * {IERC20-balanceOf} and {IERC20-transfer}.
410      */
411     function decimals() public view returns (uint8) {
412         return _decimals;
413     }
414 
415     /**
416      * @dev See {IERC20-totalSupply}.
417      */
418     function totalSupply() public view override returns (uint256) {
419         return _totalSupply;
420     }
421 
422     /**
423      * @dev See {IERC20-balanceOf}.
424      */
425     function balanceOf(address account) public view override returns (uint256) {
426         return _balances[account];
427     }
428 
429     /**
430      * @dev See {IERC20-transfer}.
431      *
432      * Requirements:
433      *
434      * - `recipient` cannot be the zero address.
435      * - the caller must have a balance of at least `amount`.
436      */
437     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
438         _transfer(_msgSender(), recipient, amount);
439         return true;
440     }
441 
442     /**
443      * @dev See {IERC20-allowance}.
444      */
445     function allowance(address owner, address spender) public view virtual override returns (uint256) {
446         return _allowances[owner][spender];
447     }
448 
449     /**
450      * @dev See {IERC20-approve}.
451      *
452      * Requirements:
453      *
454      * - `spender` cannot be the zero address.
455      */
456     function approve(address spender, uint256 amount) public virtual override returns (bool) {
457         _approve(_msgSender(), spender, amount);
458         return true;
459     }
460 
461     /**
462      * @dev See {IERC20-transferFrom}.
463      *
464      * Emits an {Approval} event indicating the updated allowance. This is not
465      * required by the EIP. See the note at the beginning of {ERC20};
466      *
467      * Requirements:
468      * - `sender` and `recipient` cannot be the zero address.
469      * - `sender` must have a balance of at least `amount`.
470      * - the caller must have allowance for `sender`'s tokens of at least
471      * `amount`.
472      */
473     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
474         _transfer(sender, recipient, amount);
475         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
476         return true;
477     }
478 
479     /**
480      * @dev Atomically increases the allowance granted to `spender` by the caller.
481      *
482      * This is an alternative to {approve} that can be used as a mitigation for
483      * problems described in {IERC20-approve}.
484      *
485      * Emits an {Approval} event indicating the updated allowance.
486      *
487      * Requirements:
488      *
489      * - `spender` cannot be the zero address.
490      */
491     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
493         return true;
494     }
495 
496     /**
497      * @dev Atomically decreases the allowance granted to `spender` by the caller.
498      *
499      * This is an alternative to {approve} that can be used as a mitigation for
500      * problems described in {IERC20-approve}.
501      *
502      * Emits an {Approval} event indicating the updated allowance.
503      *
504      * Requirements:
505      *
506      * - `spender` cannot be the zero address.
507      * - `spender` must have allowance for the caller of at least
508      * `subtractedValue`.
509      */
510     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
512         return true;
513     }
514 
515     /**
516      * @dev Moves tokens `amount` from `sender` to `recipient`.
517      *
518      * This is internal function is equivalent to {transfer}, and can be used to
519      * e.g. implement automatic token fees, slashing mechanisms, etc.
520      *
521      * Emits a {Transfer} event.
522      *
523      * Requirements:
524      *
525      * - `sender` cannot be the zero address.
526      * - `recipient` cannot be the zero address.
527      * - `sender` must have a balance of at least `amount`.
528      */
529     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
530         require(sender != address(0), "ERC20: transfer from the zero address");
531         require(recipient != address(0), "ERC20: transfer to the zero address");
532 
533         _beforeTokenTransfer(sender, recipient, amount);
534 
535         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
536         _balances[recipient] = _balances[recipient].add(amount);
537         emit Transfer(sender, recipient, amount);
538     }
539 
540     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
541      * the total supply.
542      *
543      * Emits a {Transfer} event with `from` set to the zero address.
544      *
545      * Requirements
546      *
547      * - `to` cannot be the zero address.
548      */
549     function _mint(address account, uint256 amount) internal virtual {
550         require(account != address(0), "ERC20: mint to the zero address");
551 
552         _beforeTokenTransfer(address(0), account, amount);
553 
554         _totalSupply = _totalSupply.add(amount);
555         _balances[account] = _balances[account].add(amount);
556         emit Transfer(address(0), account, amount);
557     }
558 
559     /**
560      * @dev Destroys `amount` tokens from `account`, reducing the
561      * total supply.
562      *
563      * Emits a {Transfer} event with `to` set to the zero address.
564      *
565      * Requirements
566      *
567      * - `account` cannot be the zero address.
568      * - `account` must have at least `amount` tokens.
569      */
570     function _burn(address account, uint256 amount) internal virtual {
571         require(account != address(0), "ERC20: burn from the zero address");
572 
573         _beforeTokenTransfer(account, address(0), amount);
574 
575         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
576         _totalSupply = _totalSupply.sub(amount);
577         emit Transfer(account, address(0), amount);
578     }
579 
580     /**
581      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
582      *
583      * This is internal function is equivalent to `approve`, and can be used to
584      * e.g. set automatic allowances for certain subsystems, etc.
585      *
586      * Emits an {Approval} event.
587      *
588      * Requirements:
589      *
590      * - `owner` cannot be the zero address.
591      * - `spender` cannot be the zero address.
592      */
593     function _approve(address owner, address spender, uint256 amount) internal virtual {
594         require(owner != address(0), "ERC20: approve from the zero address");
595         require(spender != address(0), "ERC20: approve to the zero address");
596 
597         _allowances[owner][spender] = amount;
598         emit Approval(owner, spender, amount);
599     }
600 
601     /**
602      * @dev Sets {decimals} to a value other than the default one of 18.
603      *
604      * Requirements:
605      *
606      * - this function can only be called from a constructor.
607      */
608     function _setupDecimals(uint8 decimals_) internal {
609         require(!address(this).isContract(), "ERC20: decimals cannot be changed after construction");
610         _decimals = decimals_;
611     }
612 
613     /**
614      * @dev Hook that is called before any transfer of tokens. This includes
615      * minting and burning.
616      *
617      * Calling conditions:
618      *
619      * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
620      * will be to transferred to `to`.
621      * - when `from` is zero, `amount` tokens will be minted for `to`.
622      * - when `to` is zero, `amount` of `from`'s tokens will be burned.
623      * - `from` and `to` are never both zero.
624      *
625      * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
626      */
627     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
628 }
629 
630 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Burnable.sol
631 
632 pragma solidity ^0.6.0;
633 
634 
635 
636 /**
637  * @dev Extension of {ERC20} that allows token holders to destroy both their own
638  * tokens and those that they have an allowance for, in a way that can be
639  * recognized off-chain (via event analysis).
640  */
641 abstract contract ERC20Burnable is Context, ERC20 {
642     /**
643      * @dev Destroys `amount` tokens from the caller.
644      *
645      * See {ERC20-_burn}.
646      */
647     function burn(uint256 amount) public virtual {
648         _burn(_msgSender(), amount);
649     }
650 
651     /**
652      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
653      * allowance.
654      *
655      * See {ERC20-_burn} and {ERC20-allowance}.
656      *
657      * Requirements:
658      *
659      * - the caller must have allowance for `accounts`'s tokens of at least
660      * `amount`.
661      */
662     function burnFrom(address account, uint256 amount) public virtual {
663         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
664 
665         _approve(account, _msgSender(), decreasedAllowance);
666         _burn(account, amount);
667     }
668 }
669 
670 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
671 
672 pragma solidity ^0.6.0;
673 
674 
675 
676 
677 /**
678  * @title SafeERC20
679  * @dev Wrappers around ERC20 operations that throw on failure (when the token
680  * contract returns false). Tokens that return no value (and instead revert or
681  * throw on failure) are also supported, non-reverting calls are assumed to be
682  * successful.
683  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
684  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
685  */
686 library SafeERC20 {
687     using SafeMath for uint256;
688     using Address for address;
689 
690     function safeTransfer(IERC20 token, address to, uint256 value) internal {
691         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
692     }
693 
694     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
695         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
696     }
697 
698     function safeApprove(IERC20 token, address spender, uint256 value) internal {
699         // safeApprove should only be called when setting an initial allowance,
700         // or when resetting it to zero. To increase and decrease it, use
701         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
702         // solhint-disable-next-line max-line-length
703         require((value == 0) || (token.allowance(address(this), spender) == 0),
704             "SafeERC20: approve from non-zero to non-zero allowance"
705         );
706         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
707     }
708 
709     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
710         uint256 newAllowance = token.allowance(address(this), spender).add(value);
711         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
712     }
713 
714     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
715         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
716         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
717     }
718 
719     /**
720      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
721      * on the return value: the return value is optional (but if data is returned, it must not be false).
722      * @param token The token targeted by the call.
723      * @param data The call data (encoded using abi.encode or one of its variants).
724      */
725     function _callOptionalReturn(IERC20 token, bytes memory data) private {
726         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
727         // we're implementing it ourselves.
728 
729         // A Solidity high level call has three parts:
730         //  1. The target address is checked to verify it contains contract code
731         //  2. The call itself is made, and success asserted
732         //  3. The return value is decoded, which in turn checks the size of the returned data.
733         // solhint-disable-next-line max-line-length
734         require(address(token).isContract(), "SafeERC20: call to non-contract");
735 
736         // solhint-disable-next-line avoid-low-level-calls
737         (bool success, bytes memory returndata) = address(token).call(data);
738         require(success, "SafeERC20: low-level call failed");
739 
740         if (returndata.length > 0) { // Return data is optional
741             // solhint-disable-next-line max-line-length
742             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
743         }
744     }
745 }
746 
747 // File: node_modules\openzeppelin-solidity\contracts\access\Ownable.sol
748 
749 pragma solidity ^0.6.0;
750 
751 /**
752  * @dev Contract module which provides a basic access control mechanism, where
753  * there is an account (an owner) that can be granted exclusive access to
754  * specific functions.
755  *
756  * By default, the owner account will be the one that deploys the contract. This
757  * can later be changed with {transferOwnership}.
758  *
759  * This module is used through inheritance. It will make available the modifier
760  * `onlyOwner`, which can be applied to your functions to restrict their use to
761  * the owner.
762  */
763 contract Ownable is Context {
764     address private _owner;
765 
766     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
767 
768     /**
769      * @dev Initializes the contract setting the deployer as the initial owner.
770      */
771     constructor () internal {
772         address msgSender = _msgSender();
773         _owner = msgSender;
774         emit OwnershipTransferred(address(0), msgSender);
775     }
776 
777     /**
778      * @dev Returns the address of the current owner.
779      */
780     function owner() public view returns (address) {
781         return _owner;
782     }
783 
784     /**
785      * @dev Throws if called by any account other than the owner.
786      */
787     modifier onlyOwner() {
788         require(_owner == _msgSender(), "Ownable: caller is not the owner");
789         _;
790     }
791 
792     /**
793      * @dev Leaves the contract without owner. It will not be possible to call
794      * `onlyOwner` functions anymore. Can only be called by the current owner.
795      *
796      * NOTE: Renouncing ownership will leave the contract without an owner,
797      * thereby removing any functionality that is only available to the owner.
798      */
799     function renounceOwnership() public virtual onlyOwner {
800         emit OwnershipTransferred(_owner, address(0));
801         _owner = address(0);
802     }
803 
804     /**
805      * @dev Transfers ownership of the contract to a new account (`newOwner`).
806      * Can only be called by the current owner.
807      */
808     function transferOwnership(address newOwner) public virtual onlyOwner {
809         require(newOwner != address(0), "Ownable: new owner is the zero address");
810         emit OwnershipTransferred(_owner, newOwner);
811         _owner = newOwner;
812     }
813 }
814 
815 // File: openzeppelin-solidity\contracts\drafts\TokenVesting.sol
816 
817 pragma solidity ^0.6.0;
818 
819 
820 
821 
822 /**
823  * @title TokenVesting
824  * @dev A token holder contract that can release its token balance gradually like a
825  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
826  * owner.
827  */
828 contract TokenVesting is Ownable {
829     // The vesting schedule is time-based (i.e. using block timestamps as opposed to e.g. block numbers), and is
830     // therefore sensitive to timestamp manipulation (which is something miners can do, to a certain degree). Therefore,
831     // it is recommended to avoid using short time durations (less than a minute). Typical vesting schemes, with a
832     // cliff period of a year and a duration of four years, are safe to use.
833     // solhint-disable not-rely-on-time
834 
835     using SafeMath for uint256;
836     using SafeERC20 for IERC20;
837 
838     event TokensReleased(address token, uint256 amount);
839     event TokenVestingRevoked(address token);
840 
841     // beneficiary of tokens after they are released
842     address private _beneficiary;
843 
844     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
845     uint256 private _cliff;
846     uint256 private _start;
847     uint256 private _duration;
848 
849     bool private _revocable;
850 
851     mapping (address => uint256) private _released;
852     mapping (address => bool) private _revoked;
853 
854     /**
855      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
856      * beneficiary, gradually in a linear fashion until start + duration. By then all
857      * of the balance will have vested.
858      * @param beneficiary address of the beneficiary to whom vested tokens are transferred
859      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
860      * @param start the time (as Unix time) at which point vesting starts
861      * @param duration duration in seconds of the period in which the tokens will vest
862      * @param revocable whether the vesting is revocable or not
863      */
864     constructor (address beneficiary, uint256 start, uint256 cliffDuration, uint256 duration, bool revocable) public {
865         require(beneficiary != address(0), "TokenVesting: beneficiary is the zero address");
866         // solhint-disable-next-line max-line-length
867         require(cliffDuration <= duration, "TokenVesting: cliff is longer than duration");
868         require(duration > 0, "TokenVesting: duration is 0");
869         // solhint-disable-next-line max-line-length
870         require(start.add(duration) > block.timestamp, "TokenVesting: final time is before current time");
871 
872         _beneficiary = beneficiary;
873         _revocable = revocable;
874         _duration = duration;
875         _cliff = start.add(cliffDuration);
876         _start = start;
877     }
878 
879     /**
880      * @return the beneficiary of the tokens.
881      */
882     function beneficiary() public view returns (address) {
883         return _beneficiary;
884     }
885 
886     /**
887      * @return the cliff time of the token vesting.
888      */
889     function cliff() public view returns (uint256) {
890         return _cliff;
891     }
892 
893     /**
894      * @return the start time of the token vesting.
895      */
896     function start() public view returns (uint256) {
897         return _start;
898     }
899 
900     /**
901      * @return the duration of the token vesting.
902      */
903     function duration() public view returns (uint256) {
904         return _duration;
905     }
906 
907     /**
908      * @return true if the vesting is revocable.
909      */
910     function revocable() public view returns (bool) {
911         return _revocable;
912     }
913 
914     /**
915      * @return the amount of the token released.
916      */
917     function released(address token) public view returns (uint256) {
918         return _released[token];
919     }
920 
921     /**
922      * @return true if the token is revoked.
923      */
924     function revoked(address token) public view returns (bool) {
925         return _revoked[token];
926     }
927 
928     /**
929      * @notice Transfers vested tokens to beneficiary.
930      * @param token ERC20 token which is being vested
931      */
932     function release(IERC20 token) public {
933         uint256 unreleased = _releasableAmount(token);
934 
935         require(unreleased > 0, "TokenVesting: no tokens are due");
936 
937         _released[address(token)] = _released[address(token)].add(unreleased);
938 
939         token.safeTransfer(_beneficiary, unreleased);
940 
941         emit TokensReleased(address(token), unreleased);
942     }
943 
944     /**
945      * @notice Allows the owner to revoke the vesting. Tokens already vested
946      * remain in the contract, the rest are returned to the owner.
947      * @param token ERC20 token which is being vested
948      */
949     function revoke(IERC20 token) public onlyOwner {
950         require(_revocable, "TokenVesting: cannot revoke");
951         require(!_revoked[address(token)], "TokenVesting: token already revoked");
952 
953         uint256 balance = token.balanceOf(address(this));
954 
955         uint256 unreleased = _releasableAmount(token);
956         uint256 refund = balance.sub(unreleased);
957 
958         _revoked[address(token)] = true;
959 
960         token.safeTransfer(owner(), refund);
961 
962         emit TokenVestingRevoked(address(token));
963     }
964 
965     /**
966      * @dev Calculates the amount that has already vested but hasn't been released yet.
967      * @param token ERC20 token which is being vested
968      */
969     function _releasableAmount(IERC20 token) private view returns (uint256) {
970         return _vestedAmount(token).sub(_released[address(token)]);
971     }
972 
973     /**
974      * @dev Calculates the amount that has already vested.
975      * @param token ERC20 token which is being vested
976      */
977     function _vestedAmount(IERC20 token) private view returns (uint256) {
978         uint256 currentBalance = token.balanceOf(address(this));
979         uint256 totalBalance = currentBalance.add(_released[address(token)]);
980 
981         if (block.timestamp < _cliff) {
982             return 0;
983         } else if (block.timestamp >= _start.add(_duration) || _revoked[address(token)]) {
984             return totalBalance;
985         } else {
986             return totalBalance.mul(block.timestamp.sub(_start)).div(_duration);
987         }
988     }
989 }
990 
991 // File: contracts\COVIDToken.sol
992 
993 pragma solidity >=0.4.22 <0.7.0;
994 
995 
996 
997 
998 contract COVIDToken is ERC20, 
999   ERC20Burnable,
1000   TokenVesting {
1001     constructor () 
1002       ERC20('CoronaCoin', 'COVID')
1003       TokenVesting(msg.sender, block.timestamp, 0, 31556952, false)
1004       public {
1005           // world population, locked into the contract
1006           _mint(
1007               address(this), 
1008               7604953650 * (10 ** uint256(decimals()))
1009           );
1010           
1011           // for reparations (airdrop)
1012           _mint(
1013               0xe5d0510184A2B769fF7522eBdED2798AF2FE1075, 
1014               755206522 * (10 ** uint256(decimals()))
1015           );
1016   }
1017 }