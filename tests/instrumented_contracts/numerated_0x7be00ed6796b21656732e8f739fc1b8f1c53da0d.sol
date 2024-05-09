1 // File: @openzeppelin/contracts/GSN/Context.sol
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
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
108 // File: @openzeppelin/contracts/math/SafeMath.sol
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
261 // File: @openzeppelin/contracts/utils/Address.sol
262 
263 pragma solidity ^0.6.2;
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
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 }
321 
322 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
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
470      * - the caller must have allowance for ``sender``'s tokens of at least
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
604      * WARNING: This function should only be called from the constructor. Most
605      * applications that interact with token contracts will not expect
606      * {decimals} to ever change, and may work incorrectly if it does.
607      */
608     function _setupDecimals(uint8 decimals_) internal {
609         _decimals = decimals_;
610     }
611 
612     /**
613      * @dev Hook that is called before any transfer of tokens. This includes
614      * minting and burning.
615      *
616      * Calling conditions:
617      *
618      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
619      * will be to transferred to `to`.
620      * - when `from` is zero, `amount` tokens will be minted for `to`.
621      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
622      * - `from` and `to` are never both zero.
623      *
624      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
625      */
626     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
627 }
628 
629 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
630 
631 pragma solidity ^0.6.0;
632 
633 
634 /**
635  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
636  */
637 abstract contract ERC20Capped is ERC20 {
638     uint256 private _cap;
639 
640     /**
641      * @dev Sets the value of the `cap`. This value is immutable, it can only be
642      * set once during construction.
643      */
644     constructor (uint256 cap) public {
645         require(cap > 0, "ERC20Capped: cap is 0");
646         _cap = cap;
647     }
648 
649     /**
650      * @dev Returns the cap on the token's total supply.
651      */
652     function cap() public view returns (uint256) {
653         return _cap;
654     }
655 
656     /**
657      * @dev See {ERC20-_beforeTokenTransfer}.
658      *
659      * Requirements:
660      *
661      * - minted tokens must not cause the total supply to go over the cap.
662      */
663     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
664         super._beforeTokenTransfer(from, to, amount);
665 
666         if (from == address(0)) { // When minting tokens
667             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
668         }
669     }
670 }
671 
672 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
673 
674 pragma solidity ^0.6.0;
675 
676 
677 
678 /**
679  * @dev Extension of {ERC20} that allows token holders to destroy both their own
680  * tokens and those that they have an allowance for, in a way that can be
681  * recognized off-chain (via event analysis).
682  */
683 abstract contract ERC20Burnable is Context, ERC20 {
684     /**
685      * @dev Destroys `amount` tokens from the caller.
686      *
687      * See {ERC20-_burn}.
688      */
689     function burn(uint256 amount) public virtual {
690         _burn(_msgSender(), amount);
691     }
692 
693     /**
694      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
695      * allowance.
696      *
697      * See {ERC20-_burn} and {ERC20-allowance}.
698      *
699      * Requirements:
700      *
701      * - the caller must have allowance for ``accounts``'s tokens of at least
702      * `amount`.
703      */
704     function burnFrom(address account, uint256 amount) public virtual {
705         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
706 
707         _approve(account, _msgSender(), decreasedAllowance);
708         _burn(account, amount);
709     }
710 }
711 
712 // File: @openzeppelin/contracts/introspection/IERC165.sol
713 
714 pragma solidity ^0.6.0;
715 
716 /**
717  * @dev Interface of the ERC165 standard, as defined in the
718  * https://eips.ethereum.org/EIPS/eip-165[EIP].
719  *
720  * Implementers can declare support of contract interfaces, which can then be
721  * queried by others ({ERC165Checker}).
722  *
723  * For an implementation, see {ERC165}.
724  */
725 interface IERC165 {
726     /**
727      * @dev Returns true if this contract implements the interface defined by
728      * `interfaceId`. See the corresponding
729      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
730      * to learn more about how these ids are created.
731      *
732      * This function call must use less than 30 000 gas.
733      */
734     function supportsInterface(bytes4 interfaceId) external view returns (bool);
735 }
736 
737 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
738 
739 pragma solidity ^0.6.0;
740 
741 
742 
743 /**
744  * @title IERC1363 Interface
745  * @dev Interface for a Payable Token contract as defined in
746  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
747  */
748 interface IERC1363 is IERC20, IERC165 {
749     /*
750      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
751      * 0x4bbee2df ===
752      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
753      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
754      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
755      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
756      */
757 
758     /*
759      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
760      * 0xfb9ec8ce ===
761      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
762      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
763      */
764 
765     /**
766      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
767      * @param to address The address which you want to transfer to
768      * @param value uint256 The amount of tokens to be transferred
769      * @return true unless throwing
770      */
771     function transferAndCall(address to, uint256 value) external returns (bool);
772 
773     /**
774      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
775      * @param to address The address which you want to transfer to
776      * @param value uint256 The amount of tokens to be transferred
777      * @param data bytes Additional data with no specified format, sent in call to `to`
778      * @return true unless throwing
779      */
780     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
781 
782     /**
783      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
784      * @param from address The address which you want to send tokens from
785      * @param to address The address which you want to transfer to
786      * @param value uint256 The amount of tokens to be transferred
787      * @return true unless throwing
788      */
789     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
790 
791     /**
792      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
793      * @param from address The address which you want to send tokens from
794      * @param to address The address which you want to transfer to
795      * @param value uint256 The amount of tokens to be transferred
796      * @param data bytes Additional data with no specified format, sent in call to `to`
797      * @return true unless throwing
798      */
799     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
800 
801     /**
802      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
803      * and then call `onApprovalReceived` on spender.
804      * Beware that changing an allowance with this method brings the risk that someone may use both the old
805      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
806      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
807      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
808      * @param spender address The address which will spend the funds
809      * @param value uint256 The amount of tokens to be spent
810      */
811     function approveAndCall(address spender, uint256 value) external returns (bool);
812 
813     /**
814      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
815      * and then call `onApprovalReceived` on spender.
816      * Beware that changing an allowance with this method brings the risk that someone may use both the old
817      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
818      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
819      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
820      * @param spender address The address which will spend the funds
821      * @param value uint256 The amount of tokens to be spent
822      * @param data bytes Additional data with no specified format, sent in call to `spender`
823      */
824     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
825 }
826 
827 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
828 
829 pragma solidity ^0.6.0;
830 
831 /**
832  * @title IERC1363Receiver Interface
833  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
834  *  from ERC1363 token contracts as defined in
835  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
836  */
837 interface IERC1363Receiver {
838     /*
839      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
840      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
841      */
842 
843     /**
844      * @notice Handle the receipt of ERC1363 tokens
845      * @dev Any ERC1363 smart contract calls this function on the recipient
846      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
847      * transfer. Return of other than the magic value MUST result in the
848      * transaction being reverted.
849      * Note: the token contract address is always the message sender.
850      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
851      * @param from address The address which are token transferred from
852      * @param value uint256 The amount of tokens transferred
853      * @param data bytes Additional data with no specified format
854      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
855      *  unless throwing
856      */
857     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
858 }
859 
860 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
861 
862 pragma solidity ^0.6.0;
863 
864 /**
865  * @title IERC1363Spender Interface
866  * @dev Interface for any contract that wants to support approveAndCall
867  *  from ERC1363 token contracts as defined in
868  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
869  */
870 interface IERC1363Spender {
871     /*
872      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
873      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
874      */
875 
876     /**
877      * @notice Handle the approval of ERC1363 tokens
878      * @dev Any ERC1363 smart contract calls this function on the recipient
879      * after an `approve`. This function MAY throw to revert and reject the
880      * approval. Return of other than the magic value MUST result in the
881      * transaction being reverted.
882      * Note: the token contract address is always the message sender.
883      * @param owner address The address which called `approveAndCall` function
884      * @param value uint256 The amount of tokens to be spent
885      * @param data bytes Additional data with no specified format
886      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
887      *  unless throwing
888      */
889     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
890 }
891 
892 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
893 
894 pragma solidity ^0.6.2;
895 
896 /**
897  * @dev Library used to query support of an interface declared via {IERC165}.
898  *
899  * Note that these functions return the actual result of the query: they do not
900  * `revert` if an interface is not supported. It is up to the caller to decide
901  * what to do in these cases.
902  */
903 library ERC165Checker {
904     // As per the EIP-165 spec, no interface should ever match 0xffffffff
905     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
906 
907     /*
908      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
909      */
910     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
911 
912     /**
913      * @dev Returns true if `account` supports the {IERC165} interface,
914      */
915     function supportsERC165(address account) internal view returns (bool) {
916         // Any contract that implements ERC165 must explicitly indicate support of
917         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
918         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
919             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
920     }
921 
922     /**
923      * @dev Returns true if `account` supports the interface defined by
924      * `interfaceId`. Support for {IERC165} itself is queried automatically.
925      *
926      * See {IERC165-supportsInterface}.
927      */
928     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
929         // query support of both ERC165 as per the spec and support of _interfaceId
930         return supportsERC165(account) &&
931             _supportsERC165Interface(account, interfaceId);
932     }
933 
934     /**
935      * @dev Returns true if `account` supports all the interfaces defined in
936      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
937      *
938      * Batch-querying can lead to gas savings by skipping repeated checks for
939      * {IERC165} support.
940      *
941      * See {IERC165-supportsInterface}.
942      */
943     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
944         // query support of ERC165 itself
945         if (!supportsERC165(account)) {
946             return false;
947         }
948 
949         // query support of each interface in _interfaceIds
950         for (uint256 i = 0; i < interfaceIds.length; i++) {
951             if (!_supportsERC165Interface(account, interfaceIds[i])) {
952                 return false;
953             }
954         }
955 
956         // all interfaces supported
957         return true;
958     }
959 
960     /**
961      * @notice Query if a contract implements an interface, does not check ERC165 support
962      * @param account The address of the contract to query for support of an interface
963      * @param interfaceId The interface identifier, as specified in ERC-165
964      * @return true if the contract at account indicates support of the interface with
965      * identifier interfaceId, false otherwise
966      * @dev Assumes that account contains a contract that supports ERC165, otherwise
967      * the behavior of this method is undefined. This precondition can be checked
968      * with {supportsERC165}.
969      * Interface identification is specified in ERC-165.
970      */
971     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
972         // success determines whether the staticcall succeeded and result determines
973         // whether the contract at account indicates support of _interfaceId
974         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
975 
976         return (success && result);
977     }
978 
979     /**
980      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
981      * @param account The address of the contract to query for support of an interface
982      * @param interfaceId The interface identifier, as specified in ERC-165
983      * @return success true if the STATICCALL succeeded, false otherwise
984      * @return result true if the STATICCALL succeeded and the contract at account
985      * indicates support of the interface with identifier interfaceId, false otherwise
986      */
987     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
988         private
989         view
990         returns (bool, bool)
991     {
992         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
993         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
994         if (result.length < 32) return (false, false);
995         return (success, abi.decode(result, (bool)));
996     }
997 }
998 
999 // File: @openzeppelin/contracts/introspection/ERC165.sol
1000 
1001 pragma solidity ^0.6.0;
1002 
1003 
1004 /**
1005  * @dev Implementation of the {IERC165} interface.
1006  *
1007  * Contracts may inherit from this and call {_registerInterface} to declare
1008  * their support of an interface.
1009  */
1010 contract ERC165 is IERC165 {
1011     /*
1012      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1013      */
1014     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1015 
1016     /**
1017      * @dev Mapping of interface ids to whether or not it's supported.
1018      */
1019     mapping(bytes4 => bool) private _supportedInterfaces;
1020 
1021     constructor () internal {
1022         // Derived contracts need only register support for their own interfaces,
1023         // we register support for ERC165 itself here
1024         _registerInterface(_INTERFACE_ID_ERC165);
1025     }
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      *
1030      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1031      */
1032     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1033         return _supportedInterfaces[interfaceId];
1034     }
1035 
1036     /**
1037      * @dev Registers the contract as an implementer of the interface defined by
1038      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1039      * registering its interface id is not required.
1040      *
1041      * See {IERC165-supportsInterface}.
1042      *
1043      * Requirements:
1044      *
1045      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1046      */
1047     function _registerInterface(bytes4 interfaceId) internal virtual {
1048         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1049         _supportedInterfaces[interfaceId] = true;
1050     }
1051 }
1052 
1053 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1054 
1055 pragma solidity ^0.6.0;
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 /**
1065  * @title ERC1363
1066  * @dev Implementation of an ERC1363 interface
1067  */
1068 contract ERC1363 is ERC20, IERC1363, ERC165 {
1069     using Address for address;
1070 
1071     /*
1072      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1073      * 0x4bbee2df ===
1074      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1075      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1076      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1077      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1078      */
1079     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1080 
1081     /*
1082      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1083      * 0xfb9ec8ce ===
1084      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1085      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1086      */
1087     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1088 
1089     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1090     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1091     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1092 
1093     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1094     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1095     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1096 
1097     /**
1098      * @param name Name of the token
1099      * @param symbol A symbol to be used as ticker
1100      */
1101     constructor (
1102         string memory name,
1103         string memory symbol
1104     ) public payable ERC20(name, symbol) {
1105         // register the supported interfaces to conform to ERC1363 via ERC165
1106         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1107         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1108     }
1109 
1110     /**
1111      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1112      * @param to The address to transfer to.
1113      * @param value The amount to be transferred.
1114      * @return A boolean that indicates if the operation was successful.
1115      */
1116     function transferAndCall(address to, uint256 value) public override returns (bool) {
1117         return transferAndCall(to, value, "");
1118     }
1119 
1120     /**
1121      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1122      * @param to The address to transfer to
1123      * @param value The amount to be transferred
1124      * @param data Additional data with no specified format
1125      * @return A boolean that indicates if the operation was successful.
1126      */
1127     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1128         transfer(to, value);
1129         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1130         return true;
1131     }
1132 
1133     /**
1134      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1135      * @param from The address which you want to send tokens from
1136      * @param to The address which you want to transfer to
1137      * @param value The amount of tokens to be transferred
1138      * @return A boolean that indicates if the operation was successful.
1139      */
1140     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1141         return transferFromAndCall(from, to, value, "");
1142     }
1143 
1144     /**
1145      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1146      * @param from The address which you want to send tokens from
1147      * @param to The address which you want to transfer to
1148      * @param value The amount of tokens to be transferred
1149      * @param data Additional data with no specified format
1150      * @return A boolean that indicates if the operation was successful.
1151      */
1152     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1153         transferFrom(from, to, value);
1154         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1155         return true;
1156     }
1157 
1158     /**
1159      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1160      * @param spender The address allowed to transfer to
1161      * @param value The amount allowed to be transferred
1162      * @return A boolean that indicates if the operation was successful.
1163      */
1164     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1165         return approveAndCall(spender, value, "");
1166     }
1167 
1168     /**
1169      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1170      * @param spender The address allowed to transfer to.
1171      * @param value The amount allowed to be transferred.
1172      * @param data Additional data with no specified format.
1173      * @return A boolean that indicates if the operation was successful.
1174      */
1175     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1176         approve(spender, value);
1177         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1178         return true;
1179     }
1180 
1181     /**
1182      * @dev Internal function to invoke `onTransferReceived` on a target address
1183      *  The call is not executed if the target address is not a contract
1184      * @param from address Representing the previous owner of the given token value
1185      * @param to address Target address that will receive the tokens
1186      * @param value uint256 The amount mount of tokens to be transferred
1187      * @param data bytes Optional data to send along with the call
1188      * @return whether the call correctly returned the expected magic value
1189      */
1190     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
1191         if (!to.isContract()) {
1192             return false;
1193         }
1194         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1195             _msgSender(), from, value, data
1196         );
1197         return (retval == _ERC1363_RECEIVED);
1198     }
1199 
1200     /**
1201      * @dev Internal function to invoke `onApprovalReceived` on a target address
1202      *  The call is not executed if the target address is not a contract
1203      * @param spender address The address which will spend the funds
1204      * @param value uint256 The amount of tokens to be spent
1205      * @param data bytes Optional data to send along with the call
1206      * @return whether the call correctly returned the expected magic value
1207      */
1208     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1209         if (!spender.isContract()) {
1210             return false;
1211         }
1212         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1213             _msgSender(), value, data
1214         );
1215         return (retval == _ERC1363_APPROVED);
1216     }
1217 }
1218 
1219 // File: @openzeppelin/contracts/access/Ownable.sol
1220 
1221 pragma solidity ^0.6.0;
1222 
1223 /**
1224  * @dev Contract module which provides a basic access control mechanism, where
1225  * there is an account (an owner) that can be granted exclusive access to
1226  * specific functions.
1227  *
1228  * By default, the owner account will be the one that deploys the contract. This
1229  * can later be changed with {transferOwnership}.
1230  *
1231  * This module is used through inheritance. It will make available the modifier
1232  * `onlyOwner`, which can be applied to your functions to restrict their use to
1233  * the owner.
1234  */
1235 contract Ownable is Context {
1236     address private _owner;
1237 
1238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1239 
1240     /**
1241      * @dev Initializes the contract setting the deployer as the initial owner.
1242      */
1243     constructor () internal {
1244         address msgSender = _msgSender();
1245         _owner = msgSender;
1246         emit OwnershipTransferred(address(0), msgSender);
1247     }
1248 
1249     /**
1250      * @dev Returns the address of the current owner.
1251      */
1252     function owner() public view returns (address) {
1253         return _owner;
1254     }
1255 
1256     /**
1257      * @dev Throws if called by any account other than the owner.
1258      */
1259     modifier onlyOwner() {
1260         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1261         _;
1262     }
1263 
1264     /**
1265      * @dev Leaves the contract without owner. It will not be possible to call
1266      * `onlyOwner` functions anymore. Can only be called by the current owner.
1267      *
1268      * NOTE: Renouncing ownership will leave the contract without an owner,
1269      * thereby removing any functionality that is only available to the owner.
1270      */
1271     function renounceOwnership() public virtual onlyOwner {
1272         emit OwnershipTransferred(_owner, address(0));
1273         _owner = address(0);
1274     }
1275 
1276     /**
1277      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1278      * Can only be called by the current owner.
1279      */
1280     function transferOwnership(address newOwner) public virtual onlyOwner {
1281         require(newOwner != address(0), "Ownable: new owner is the zero address");
1282         emit OwnershipTransferred(_owner, newOwner);
1283         _owner = newOwner;
1284     }
1285 }
1286 
1287 // File: eth-token-recover/contracts/TokenRecover.sol
1288 
1289 pragma solidity ^0.6.0;
1290 
1291 
1292 
1293 /**
1294  * @title TokenRecover
1295  * @dev Allow to recover any ERC20 sent into the contract for error
1296  */
1297 contract TokenRecover is Ownable {
1298 
1299     /**
1300      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1301      * @param tokenAddress The token contract address
1302      * @param tokenAmount Number of tokens to be sent
1303      */
1304     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1305         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1306     }
1307 }
1308 
1309 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1310 
1311 pragma solidity ^0.6.0;
1312 
1313 /**
1314  * @dev Library for managing
1315  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1316  * types.
1317  *
1318  * Sets have the following properties:
1319  *
1320  * - Elements are added, removed, and checked for existence in constant time
1321  * (O(1)).
1322  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1323  *
1324  * ```
1325  * contract Example {
1326  *     // Add the library methods
1327  *     using EnumerableSet for EnumerableSet.AddressSet;
1328  *
1329  *     // Declare a set state variable
1330  *     EnumerableSet.AddressSet private mySet;
1331  * }
1332  * ```
1333  *
1334  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1335  * (`UintSet`) are supported.
1336  */
1337 library EnumerableSet {
1338     // To implement this library for multiple types with as little code
1339     // repetition as possible, we write it in terms of a generic Set type with
1340     // bytes32 values.
1341     // The Set implementation uses private functions, and user-facing
1342     // implementations (such as AddressSet) are just wrappers around the
1343     // underlying Set.
1344     // This means that we can only create new EnumerableSets for types that fit
1345     // in bytes32.
1346 
1347     struct Set {
1348         // Storage of set values
1349         bytes32[] _values;
1350 
1351         // Position of the value in the `values` array, plus 1 because index 0
1352         // means a value is not in the set.
1353         mapping (bytes32 => uint256) _indexes;
1354     }
1355 
1356     /**
1357      * @dev Add a value to a set. O(1).
1358      *
1359      * Returns true if the value was added to the set, that is if it was not
1360      * already present.
1361      */
1362     function _add(Set storage set, bytes32 value) private returns (bool) {
1363         if (!_contains(set, value)) {
1364             set._values.push(value);
1365             // The value is stored at length-1, but we add 1 to all indexes
1366             // and use 0 as a sentinel value
1367             set._indexes[value] = set._values.length;
1368             return true;
1369         } else {
1370             return false;
1371         }
1372     }
1373 
1374     /**
1375      * @dev Removes a value from a set. O(1).
1376      *
1377      * Returns true if the value was removed from the set, that is if it was
1378      * present.
1379      */
1380     function _remove(Set storage set, bytes32 value) private returns (bool) {
1381         // We read and store the value's index to prevent multiple reads from the same storage slot
1382         uint256 valueIndex = set._indexes[value];
1383 
1384         if (valueIndex != 0) { // Equivalent to contains(set, value)
1385             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1386             // the array, and then remove the last element (sometimes called as 'swap and pop').
1387             // This modifies the order of the array, as noted in {at}.
1388 
1389             uint256 toDeleteIndex = valueIndex - 1;
1390             uint256 lastIndex = set._values.length - 1;
1391 
1392             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1393             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1394 
1395             bytes32 lastvalue = set._values[lastIndex];
1396 
1397             // Move the last value to the index where the value to delete is
1398             set._values[toDeleteIndex] = lastvalue;
1399             // Update the index for the moved value
1400             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1401 
1402             // Delete the slot where the moved value was stored
1403             set._values.pop();
1404 
1405             // Delete the index for the deleted slot
1406             delete set._indexes[value];
1407 
1408             return true;
1409         } else {
1410             return false;
1411         }
1412     }
1413 
1414     /**
1415      * @dev Returns true if the value is in the set. O(1).
1416      */
1417     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1418         return set._indexes[value] != 0;
1419     }
1420 
1421     /**
1422      * @dev Returns the number of values on the set. O(1).
1423      */
1424     function _length(Set storage set) private view returns (uint256) {
1425         return set._values.length;
1426     }
1427 
1428    /**
1429     * @dev Returns the value stored at position `index` in the set. O(1).
1430     *
1431     * Note that there are no guarantees on the ordering of values inside the
1432     * array, and it may change when more values are added or removed.
1433     *
1434     * Requirements:
1435     *
1436     * - `index` must be strictly less than {length}.
1437     */
1438     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1439         require(set._values.length > index, "EnumerableSet: index out of bounds");
1440         return set._values[index];
1441     }
1442 
1443     // AddressSet
1444 
1445     struct AddressSet {
1446         Set _inner;
1447     }
1448 
1449     /**
1450      * @dev Add a value to a set. O(1).
1451      *
1452      * Returns true if the value was added to the set, that is if it was not
1453      * already present.
1454      */
1455     function add(AddressSet storage set, address value) internal returns (bool) {
1456         return _add(set._inner, bytes32(uint256(value)));
1457     }
1458 
1459     /**
1460      * @dev Removes a value from a set. O(1).
1461      *
1462      * Returns true if the value was removed from the set, that is if it was
1463      * present.
1464      */
1465     function remove(AddressSet storage set, address value) internal returns (bool) {
1466         return _remove(set._inner, bytes32(uint256(value)));
1467     }
1468 
1469     /**
1470      * @dev Returns true if the value is in the set. O(1).
1471      */
1472     function contains(AddressSet storage set, address value) internal view returns (bool) {
1473         return _contains(set._inner, bytes32(uint256(value)));
1474     }
1475 
1476     /**
1477      * @dev Returns the number of values in the set. O(1).
1478      */
1479     function length(AddressSet storage set) internal view returns (uint256) {
1480         return _length(set._inner);
1481     }
1482 
1483    /**
1484     * @dev Returns the value stored at position `index` in the set. O(1).
1485     *
1486     * Note that there are no guarantees on the ordering of values inside the
1487     * array, and it may change when more values are added or removed.
1488     *
1489     * Requirements:
1490     *
1491     * - `index` must be strictly less than {length}.
1492     */
1493     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1494         return address(uint256(_at(set._inner, index)));
1495     }
1496 
1497 
1498     // UintSet
1499 
1500     struct UintSet {
1501         Set _inner;
1502     }
1503 
1504     /**
1505      * @dev Add a value to a set. O(1).
1506      *
1507      * Returns true if the value was added to the set, that is if it was not
1508      * already present.
1509      */
1510     function add(UintSet storage set, uint256 value) internal returns (bool) {
1511         return _add(set._inner, bytes32(value));
1512     }
1513 
1514     /**
1515      * @dev Removes a value from a set. O(1).
1516      *
1517      * Returns true if the value was removed from the set, that is if it was
1518      * present.
1519      */
1520     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1521         return _remove(set._inner, bytes32(value));
1522     }
1523 
1524     /**
1525      * @dev Returns true if the value is in the set. O(1).
1526      */
1527     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1528         return _contains(set._inner, bytes32(value));
1529     }
1530 
1531     /**
1532      * @dev Returns the number of values on the set. O(1).
1533      */
1534     function length(UintSet storage set) internal view returns (uint256) {
1535         return _length(set._inner);
1536     }
1537 
1538    /**
1539     * @dev Returns the value stored at position `index` in the set. O(1).
1540     *
1541     * Note that there are no guarantees on the ordering of values inside the
1542     * array, and it may change when more values are added or removed.
1543     *
1544     * Requirements:
1545     *
1546     * - `index` must be strictly less than {length}.
1547     */
1548     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1549         return uint256(_at(set._inner, index));
1550     }
1551 }
1552 
1553 // File: @openzeppelin/contracts/access/AccessControl.sol
1554 
1555 pragma solidity ^0.6.0;
1556 
1557 
1558 
1559 
1560 /**
1561  * @dev Contract module that allows children to implement role-based access
1562  * control mechanisms.
1563  *
1564  * Roles are referred to by their `bytes32` identifier. These should be exposed
1565  * in the external API and be unique. The best way to achieve this is by
1566  * using `public constant` hash digests:
1567  *
1568  * ```
1569  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1570  * ```
1571  *
1572  * Roles can be used to represent a set of permissions. To restrict access to a
1573  * function call, use {hasRole}:
1574  *
1575  * ```
1576  * function foo() public {
1577  *     require(hasRole(MY_ROLE, _msgSender()));
1578  *     ...
1579  * }
1580  * ```
1581  *
1582  * Roles can be granted and revoked dynamically via the {grantRole} and
1583  * {revokeRole} functions. Each role has an associated admin role, and only
1584  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1585  *
1586  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1587  * that only accounts with this role will be able to grant or revoke other
1588  * roles. More complex role relationships can be created by using
1589  * {_setRoleAdmin}.
1590  */
1591 abstract contract AccessControl is Context {
1592     using EnumerableSet for EnumerableSet.AddressSet;
1593     using Address for address;
1594 
1595     struct RoleData {
1596         EnumerableSet.AddressSet members;
1597         bytes32 adminRole;
1598     }
1599 
1600     mapping (bytes32 => RoleData) private _roles;
1601 
1602     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1603 
1604     /**
1605      * @dev Emitted when `account` is granted `role`.
1606      *
1607      * `sender` is the account that originated the contract call, an admin role
1608      * bearer except when using {_setupRole}.
1609      */
1610     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1611 
1612     /**
1613      * @dev Emitted when `account` is revoked `role`.
1614      *
1615      * `sender` is the account that originated the contract call:
1616      *   - if using `revokeRole`, it is the admin role bearer
1617      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1618      */
1619     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1620 
1621     /**
1622      * @dev Returns `true` if `account` has been granted `role`.
1623      */
1624     function hasRole(bytes32 role, address account) public view returns (bool) {
1625         return _roles[role].members.contains(account);
1626     }
1627 
1628     /**
1629      * @dev Returns the number of accounts that have `role`. Can be used
1630      * together with {getRoleMember} to enumerate all bearers of a role.
1631      */
1632     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1633         return _roles[role].members.length();
1634     }
1635 
1636     /**
1637      * @dev Returns one of the accounts that have `role`. `index` must be a
1638      * value between 0 and {getRoleMemberCount}, non-inclusive.
1639      *
1640      * Role bearers are not sorted in any particular way, and their ordering may
1641      * change at any point.
1642      *
1643      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1644      * you perform all queries on the same block. See the following
1645      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1646      * for more information.
1647      */
1648     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1649         return _roles[role].members.at(index);
1650     }
1651 
1652     /**
1653      * @dev Returns the admin role that controls `role`. See {grantRole} and
1654      * {revokeRole}.
1655      *
1656      * To change a role's admin, use {_setRoleAdmin}.
1657      */
1658     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1659         return _roles[role].adminRole;
1660     }
1661 
1662     /**
1663      * @dev Grants `role` to `account`.
1664      *
1665      * If `account` had not been already granted `role`, emits a {RoleGranted}
1666      * event.
1667      *
1668      * Requirements:
1669      *
1670      * - the caller must have ``role``'s admin role.
1671      */
1672     function grantRole(bytes32 role, address account) public virtual {
1673         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1674 
1675         _grantRole(role, account);
1676     }
1677 
1678     /**
1679      * @dev Revokes `role` from `account`.
1680      *
1681      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1682      *
1683      * Requirements:
1684      *
1685      * - the caller must have ``role``'s admin role.
1686      */
1687     function revokeRole(bytes32 role, address account) public virtual {
1688         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1689 
1690         _revokeRole(role, account);
1691     }
1692 
1693     /**
1694      * @dev Revokes `role` from the calling account.
1695      *
1696      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1697      * purpose is to provide a mechanism for accounts to lose their privileges
1698      * if they are compromised (such as when a trusted device is misplaced).
1699      *
1700      * If the calling account had been granted `role`, emits a {RoleRevoked}
1701      * event.
1702      *
1703      * Requirements:
1704      *
1705      * - the caller must be `account`.
1706      */
1707     function renounceRole(bytes32 role, address account) public virtual {
1708         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1709 
1710         _revokeRole(role, account);
1711     }
1712 
1713     /**
1714      * @dev Grants `role` to `account`.
1715      *
1716      * If `account` had not been already granted `role`, emits a {RoleGranted}
1717      * event. Note that unlike {grantRole}, this function doesn't perform any
1718      * checks on the calling account.
1719      *
1720      * [WARNING]
1721      * ====
1722      * This function should only be called from the constructor when setting
1723      * up the initial roles for the system.
1724      *
1725      * Using this function in any other way is effectively circumventing the admin
1726      * system imposed by {AccessControl}.
1727      * ====
1728      */
1729     function _setupRole(bytes32 role, address account) internal virtual {
1730         _grantRole(role, account);
1731     }
1732 
1733     /**
1734      * @dev Sets `adminRole` as ``role``'s admin role.
1735      */
1736     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1737         _roles[role].adminRole = adminRole;
1738     }
1739 
1740     function _grantRole(bytes32 role, address account) private {
1741         if (_roles[role].members.add(account)) {
1742             emit RoleGranted(role, account, _msgSender());
1743         }
1744     }
1745 
1746     function _revokeRole(bytes32 role, address account) private {
1747         if (_roles[role].members.remove(account)) {
1748             emit RoleRevoked(role, account, _msgSender());
1749         }
1750     }
1751 }
1752 
1753 // File: contracts/access/Roles.sol
1754 
1755 pragma solidity ^0.6.0;
1756 
1757 
1758 contract Roles is AccessControl {
1759 
1760     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1761     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1762 
1763     constructor () public {
1764         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1765         _setupRole(MINTER_ROLE, _msgSender());
1766         _setupRole(OPERATOR_ROLE, _msgSender());
1767     }
1768 
1769     modifier onlyMinter() {
1770         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1771         _;
1772     }
1773 
1774     modifier onlyOperator() {
1775         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1776         _;
1777     }
1778 }
1779 
1780 // File: contracts/ACXToken.sol
1781 
1782 pragma solidity ^0.6.0;
1783 
1784 
1785 
1786 
1787 // TOKEN NAME: AC eXchange Token
1788 // SYMBOL: ACXT 
1789 
1790 /**
1791  * @title ACXToken
1792  * @dev Implementation of the ACXToken
1793  */
1794 contract ACXToken is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {
1795 
1796     // indicates if minting is finished
1797     bool private _mintingFinished = false;
1798 
1799     // indicates if transfer is enabled
1800     bool private _transferEnabled = false;
1801 
1802     /**
1803      * @dev Emitted during finish minting
1804      */
1805     event MintFinished();
1806 
1807     /**
1808      * @dev Emitted during transfer enabling
1809      */
1810     event TransferEnabled();
1811 
1812     /**
1813      * @dev Tokens can be minted only before minting finished.
1814      */
1815     modifier canMint() {
1816         require(!_mintingFinished, "ACXToken: minting is finished");
1817         _;
1818     }
1819 
1820     /**
1821      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1822      */
1823     modifier canTransfer(address from) {
1824         require(
1825             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1826             "ACXToken: transfer is not enabled or from does not have the OPERATOR role"
1827         );
1828         _;
1829     }
1830 
1831     /**
1832      * @param name Name of the token
1833      * @param symbol A symbol to be used as ticker
1834      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1835      * @param cap Maximum number of tokens mintable
1836      * @param initialSupply Initial token supply
1837      * @param transferEnabled If transfer is enabled on token creation
1838      * @param mintingFinished If minting is finished after token creation
1839      */
1840     constructor(
1841         string memory name,
1842         string memory symbol,
1843         uint8 decimals,
1844         uint256 cap,
1845         uint256 initialSupply,
1846         bool transferEnabled,
1847         bool mintingFinished
1848     )
1849         public
1850         ERC20Capped(cap)
1851         ERC1363(name, symbol)
1852     {
1853         require(
1854             mintingFinished == false || cap == initialSupply,
1855             "ACXToken: if finish minting, cap must be equal to initialSupply"
1856         );
1857 
1858         _setupDecimals(decimals);
1859 
1860         if (initialSupply > 0) {
1861             _mint(owner(), initialSupply);
1862         }
1863 
1864         if (mintingFinished) {
1865             finishMinting();
1866         }
1867 
1868         if (transferEnabled) {
1869             enableTransfer();
1870         }
1871     }
1872 
1873     /**
1874      * @return if minting is finished or not.
1875      */
1876     function mintingFinished() public view returns (bool) {
1877         return _mintingFinished;
1878     }
1879 
1880     /**
1881      * @return if transfer is enabled or not.
1882      */
1883     function transferEnabled() public view returns (bool) {
1884         return _transferEnabled;
1885     }
1886 
1887     /**
1888      * @dev Function to mint tokens.
1889      * @param to The address that will receive the minted tokens
1890      * @param value The amount of tokens to mint
1891      */
1892     function mint(address to, uint256 value) public canMint onlyMinter {
1893         _mint(to, value);
1894     }
1895 
1896     /**
1897      * @dev Transfer tokens to a specified address.
1898      * @param to The address to transfer to
1899      * @param value The amount to be transferred
1900      * @return A boolean that indicates if the operation was successful.
1901      */
1902     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
1903         return super.transfer(to, value);
1904     }
1905 
1906     /**
1907      * @dev Transfer tokens from one address to another.
1908      * @param from The address which you want to send tokens from
1909      * @param to The address which you want to transfer to
1910      * @param value the amount of tokens to be transferred
1911      * @return A boolean that indicates if the operation was successful.
1912      */
1913     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
1914         return super.transferFrom(from, to, value);
1915     }
1916 
1917     /**
1918      * @dev Function to stop minting new tokens.
1919      */
1920     function finishMinting() public canMint onlyOwner {
1921         _mintingFinished = true;
1922 
1923         emit MintFinished();
1924     }
1925 
1926     /**
1927      * @dev Function to enable transfers.
1928      */
1929     function enableTransfer() public onlyOwner {
1930         _transferEnabled = true;
1931 
1932         emit TransferEnabled();
1933     }
1934 
1935     /**
1936      * @dev See {ERC20-_beforeTokenTransfer}.
1937      */
1938     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1939         super._beforeTokenTransfer(from, to, amount);
1940     }
1941 }