1 // Trendering.com
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.6.0;
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
21 
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 
34 pragma solidity ^0.6.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.6.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, "SafeMath: division by zero");
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         // Solidity only automatically asserts when dividing by 0
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/Address.sol
264 
265 pragma solidity ^0.6.2;
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
290         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
291         // for accounts without code, i.e. `keccak256('')`
292         bytes32 codehash;
293         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
294         // solhint-disable-next-line no-inline-assembly
295         assembly { codehash := extcodehash(account) }
296         return (codehash != accountHash && codehash != 0x0);
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
319         (bool success, ) = recipient.call{ value: amount }("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
325 
326 pragma solidity ^0.6.0;
327 
328 
329 
330 
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20MinterPauser}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20 {
357     using SafeMath for uint256;
358     using Address for address;
359 
360     mapping (address => uint256) private _balances;
361 
362     mapping (address => mapping (address => uint256)) private _allowances;
363 
364     uint256 private _totalSupply;
365 
366     string private _name;
367     string private _symbol;
368     uint8 private _decimals;
369 
370     /**
371      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
372      * a default value of 18.
373      *
374      * To select a different value for {decimals}, use {_setupDecimals}.
375      *
376      * All three of these values are immutable: they can only be set once during
377      * construction.
378      */
379     constructor (string memory name, string memory symbol) public {
380         _name = name;
381         _symbol = symbol;
382         _decimals = 18;
383     }
384 
385     /**
386      * @dev Returns the name of the token.
387      */
388     function name() public view returns (string memory) {
389         return _name;
390     }
391 
392     /**
393      * @dev Returns the symbol of the token, usually a shorter version of the
394      * name.
395      */
396     function symbol() public view returns (string memory) {
397         return _symbol;
398     }
399 
400     /**
401      * @dev Returns the number of decimals used to get its user representation.
402      * For example, if `decimals` equals `2`, a balance of `505` tokens should
403      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
404      *
405      * Tokens usually opt for a value of 18, imitating the relationship between
406      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
407      * called.
408      *
409      * NOTE: This information is only used for _display_ purposes: it in
410      * no way affects any of the arithmetic of the contract, including
411      * {IERC20-balanceOf} and {IERC20-transfer}.
412      */
413     function decimals() public view returns (uint8) {
414         return _decimals;
415     }
416 
417     /**
418      * @dev See {IERC20-totalSupply}.
419      */
420     function totalSupply() public view override returns (uint256) {
421         return _totalSupply;
422     }
423 
424     /**
425      * @dev See {IERC20-balanceOf}.
426      */
427     function balanceOf(address account) public view override returns (uint256) {
428         return _balances[account];
429     }
430 
431     /**
432      * @dev See {IERC20-transfer}.
433      *
434      * Requirements:
435      *
436      * - `recipient` cannot be the zero address.
437      * - the caller must have a balance of at least `amount`.
438      */
439     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
440         _transfer(_msgSender(), recipient, amount);
441         return true;
442     }
443 
444     /**
445      * @dev See {IERC20-allowance}.
446      */
447     function allowance(address owner, address spender) public view virtual override returns (uint256) {
448         return _allowances[owner][spender];
449     }
450 
451     /**
452      * @dev See {IERC20-approve}.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      */
458     function approve(address spender, uint256 amount) public virtual override returns (bool) {
459         _approve(_msgSender(), spender, amount);
460         return true;
461     }
462 
463     /**
464      * @dev See {IERC20-transferFrom}.
465      *
466      * Emits an {Approval} event indicating the updated allowance. This is not
467      * required by the EIP. See the note at the beginning of {ERC20};
468      *
469      * Requirements:
470      * - `sender` and `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      * - the caller must have allowance for ``sender``'s tokens of at least
473      * `amount`.
474      */
475     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
476         _transfer(sender, recipient, amount);
477         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
478         return true;
479     }
480 
481     /**
482      * @dev Atomically increases the allowance granted to `spender` by the caller.
483      *
484      * This is an alternative to {approve} that can be used as a mitigation for
485      * problems described in {IERC20-approve}.
486      *
487      * Emits an {Approval} event indicating the updated allowance.
488      *
489      * Requirements:
490      *
491      * - `spender` cannot be the zero address.
492      */
493     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
494         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
495         return true;
496     }
497 
498     /**
499      * @dev Atomically decreases the allowance granted to `spender` by the caller.
500      *
501      * This is an alternative to {approve} that can be used as a mitigation for
502      * problems described in {IERC20-approve}.
503      *
504      * Emits an {Approval} event indicating the updated allowance.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      * - `spender` must have allowance for the caller of at least
510      * `subtractedValue`.
511      */
512     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
514         return true;
515     }
516 
517     /**
518      * @dev Moves tokens `amount` from `sender` to `recipient`.
519      *
520      * This is internal function is equivalent to {transfer}, and can be used to
521      * e.g. implement automatic token fees, slashing mechanisms, etc.
522      *
523      * Emits a {Transfer} event.
524      *
525      * Requirements:
526      *
527      * - `sender` cannot be the zero address.
528      * - `recipient` cannot be the zero address.
529      * - `sender` must have a balance of at least `amount`.
530      */
531     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
532         require(sender != address(0), "ERC20: transfer from the zero address");
533         require(recipient != address(0), "ERC20: transfer to the zero address");
534 
535         _beforeTokenTransfer(sender, recipient, amount);
536 
537         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
538         _balances[recipient] = _balances[recipient].add(amount);
539         emit Transfer(sender, recipient, amount);
540     }
541 
542     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
543      * the total supply.
544      *
545      * Emits a {Transfer} event with `from` set to the zero address.
546      *
547      * Requirements
548      *
549      * - `to` cannot be the zero address.
550      */
551     function _mint(address account, uint256 amount) internal virtual {
552         require(account != address(0), "ERC20: mint to the zero address");
553 
554         _beforeTokenTransfer(address(0), account, amount);
555 
556         _totalSupply = _totalSupply.add(amount);
557         _balances[account] = _balances[account].add(amount);
558         emit Transfer(address(0), account, amount);
559     }
560 
561     /**
562      * @dev Destroys `amount` tokens from `account`, reducing the
563      * total supply.
564      *
565      * Emits a {Transfer} event with `to` set to the zero address.
566      *
567      * Requirements
568      *
569      * - `account` cannot be the zero address.
570      * - `account` must have at least `amount` tokens.
571      */
572     function _burn(address account, uint256 amount) internal virtual {
573         require(account != address(0), "ERC20: burn from the zero address");
574 
575         _beforeTokenTransfer(account, address(0), amount);
576 
577         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
578         _totalSupply = _totalSupply.sub(amount);
579         emit Transfer(account, address(0), amount);
580     }
581 
582     /**
583      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
584      *
585      * This is internal function is equivalent to `approve`, and can be used to
586      * e.g. set automatic allowances for certain subsystems, etc.
587      *
588      * Emits an {Approval} event.
589      *
590      * Requirements:
591      *
592      * - `owner` cannot be the zero address.
593      * - `spender` cannot be the zero address.
594      */
595     function _approve(address owner, address spender, uint256 amount) internal virtual {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     /**
604      * @dev Sets {decimals} to a value other than the default one of 18.
605      *
606      * WARNING: This function should only be called from the constructor. Most
607      * applications that interact with token contracts will not expect
608      * {decimals} to ever change, and may work incorrectly if it does.
609      */
610     function _setupDecimals(uint8 decimals_) internal {
611         _decimals = decimals_;
612     }
613 
614     /**
615      * @dev Hook that is called before any transfer of tokens. This includes
616      * minting and burning.
617      *
618      * Calling conditions:
619      *
620      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
621      * will be to transferred to `to`.
622      * - when `from` is zero, `amount` tokens will be minted for `to`.
623      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
624      * - `from` and `to` are never both zero.
625      *
626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
627      */
628     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
629 }
630 
631 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
632 
633 pragma solidity ^0.6.0;
634 
635 
636 /**
637  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
638  */
639 abstract contract ERC20Capped is ERC20 {
640     uint256 private _cap;
641 
642     /**
643      * @dev Sets the value of the `cap`. This value is immutable, it can only be
644      * set once during construction.
645      */
646     constructor (uint256 cap) public {
647         require(cap > 0, "ERC20Capped: cap is 0");
648         _cap = cap;
649     }
650 
651     /**
652      * @dev Returns the cap on the token's total supply.
653      */
654     function cap() public view returns (uint256) {
655         return _cap;
656     }
657 
658     /**
659      * @dev See {ERC20-_beforeTokenTransfer}.
660      *
661      * Requirements:
662      *
663      * - minted tokens must not cause the total supply to go over the cap.
664      */
665     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
666         super._beforeTokenTransfer(from, to, amount);
667 
668         if (from == address(0)) { // When minting tokens
669             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
670         }
671     }
672 }
673 
674 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
675 
676 pragma solidity ^0.6.0;
677 
678 
679 
680 /**
681  * @dev Extension of {ERC20} that allows token holders to destroy both their own
682  * tokens and those that they have an allowance for, in a way that can be
683  * recognized off-chain (via event analysis).
684  */
685 abstract contract ERC20Burnable is Context, ERC20 {
686     /**
687      * @dev Destroys `amount` tokens from the caller.
688      *
689      * See {ERC20-_burn}.
690      */
691     function burn(uint256 amount) public virtual {
692         _burn(_msgSender(), amount);
693     }
694 
695     /**
696      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
697      * allowance.
698      *
699      * See {ERC20-_burn} and {ERC20-allowance}.
700      *
701      * Requirements:
702      *
703      * - the caller must have allowance for ``accounts``'s tokens of at least
704      * `amount`.
705      */
706     function burnFrom(address account, uint256 amount) public virtual {
707         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
708 
709         _approve(account, _msgSender(), decreasedAllowance);
710         _burn(account, amount);
711     }
712 }
713 
714 // File: @openzeppelin/contracts/introspection/IERC165.sol
715 
716 pragma solidity ^0.6.0;
717 
718 /**
719  * @dev Interface of the ERC165 standard, as defined in the
720  * https://eips.ethereum.org/EIPS/eip-165[EIP].
721  *
722  * Implementers can declare support of contract interfaces, which can then be
723  * queried by others ({ERC165Checker}).
724  *
725  * For an implementation, see {ERC165}.
726  */
727 interface IERC165 {
728     /**
729      * @dev Returns true if this contract implements the interface defined by
730      * `interfaceId`. See the corresponding
731      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
732      * to learn more about how these ids are created.
733      *
734      * This function call must use less than 30 000 gas.
735      */
736     function supportsInterface(bytes4 interfaceId) external view returns (bool);
737 }
738 
739 
740 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
741 
742 pragma solidity ^0.6.2;
743 
744 /**
745  * @dev Library used to query support of an interface declared via {IERC165}.
746  *
747  * Note that these functions return the actual result of the query: they do not
748  * `revert` if an interface is not supported. It is up to the caller to decide
749  * what to do in these cases.
750  */
751 library ERC165Checker {
752     // As per the EIP-165 spec, no interface should ever match 0xffffffff
753     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
754 
755     /*
756      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
757      */
758     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
759 
760     /**
761      * @dev Returns true if `account` supports the {IERC165} interface,
762      */
763     function supportsERC165(address account) internal view returns (bool) {
764         // Any contract that implements ERC165 must explicitly indicate support of
765         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
766         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
767             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
768     }
769 
770     /**
771      * @dev Returns true if `account` supports the interface defined by
772      * `interfaceId`. Support for {IERC165} itself is queried automatically.
773      *
774      * See {IERC165-supportsInterface}.
775      */
776     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
777         // query support of both ERC165 as per the spec and support of _interfaceId
778         return supportsERC165(account) &&
779             _supportsERC165Interface(account, interfaceId);
780     }
781 
782     /**
783      * @dev Returns true if `account` supports all the interfaces defined in
784      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
785      *
786      * Batch-querying can lead to gas savings by skipping repeated checks for
787      * {IERC165} support.
788      *
789      * See {IERC165-supportsInterface}.
790      */
791     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
792         // query support of ERC165 itself
793         if (!supportsERC165(account)) {
794             return false;
795         }
796 
797         // query support of each interface in _interfaceIds
798         for (uint256 i = 0; i < interfaceIds.length; i++) {
799             if (!_supportsERC165Interface(account, interfaceIds[i])) {
800                 return false;
801             }
802         }
803 
804         // all interfaces supported
805         return true;
806     }
807 
808     /**
809      * @notice Query if a contract implements an interface, does not check ERC165 support
810      * @param account The address of the contract to query for support of an interface
811      * @param interfaceId The interface identifier, as specified in ERC-165
812      * @return true if the contract at account indicates support of the interface with
813      * identifier interfaceId, false otherwise
814      * @dev Assumes that account contains a contract that supports ERC165, otherwise
815      * the behavior of this method is undefined. This precondition can be checked
816      * with {supportsERC165}.
817      * Interface identification is specified in ERC-165.
818      */
819     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
820         // success determines whether the staticcall succeeded and result determines
821         // whether the contract at account indicates support of _interfaceId
822         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
823 
824         return (success && result);
825     }
826 
827     /**
828      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
829      * @param account The address of the contract to query for support of an interface
830      * @param interfaceId The interface identifier, as specified in ERC-165
831      * @return success true if the STATICCALL succeeded, false otherwise
832      * @return result true if the STATICCALL succeeded and the contract at account
833      * indicates support of the interface with identifier interfaceId, false otherwise
834      */
835     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
836         private
837         view
838         returns (bool, bool)
839     {
840         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
841         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
842         if (result.length < 32) return (false, false);
843         return (success, abi.decode(result, (bool)));
844     }
845 }
846 
847 // File: @openzeppelin/contracts/introspection/ERC165.sol
848 
849 pragma solidity ^0.6.0;
850 
851 
852 /**
853  * @dev Implementation of the {IERC165} interface.
854  *
855  * Contracts may inherit from this and call {_registerInterface} to declare
856  * their support of an interface.
857  */
858 contract ERC165 is IERC165 {
859     /*
860      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
861      */
862     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
863 
864     /**
865      * @dev Mapping of interface ids to whether or not it's supported.
866      */
867     mapping(bytes4 => bool) private _supportedInterfaces;
868 
869     constructor () internal {
870         // Derived contracts need only register support for their own interfaces,
871         // we register support for ERC165 itself here
872         _registerInterface(_INTERFACE_ID_ERC165);
873     }
874 
875     /**
876      * @dev See {IERC165-supportsInterface}.
877      *
878      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
879      */
880     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
881         return _supportedInterfaces[interfaceId];
882     }
883 
884     /**
885      * @dev Registers the contract as an implementer of the interface defined by
886      * `interfaceId`. Support of the actual ERC165 interface is automatic and
887      * registering its interface id is not required.
888      *
889      * See {IERC165-supportsInterface}.
890      *
891      * Requirements:
892      *
893      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
894      */
895     function _registerInterface(bytes4 interfaceId) internal virtual {
896         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
897         _supportedInterfaces[interfaceId] = true;
898     }
899 }
900 
901 // File: @openzeppelin/contracts/access/Ownable.sol
902 
903 pragma solidity ^0.6.0;
904 
905 /**
906  * @dev Contract module which provides a basic access control mechanism, where
907  * there is an account (an owner) that can be granted exclusive access to
908  * specific functions.
909  *
910  * By default, the owner account will be the one that deploys the contract. This
911  * can later be changed with {transferOwnership}.
912  *
913  * This module is used through inheritance. It will make available the modifier
914  * `onlyOwner`, which can be applied to your functions to restrict their use to
915  * the owner.
916  */
917 contract Ownable is Context {
918     address private _owner;
919 
920     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
921 
922     /**
923      * @dev Initializes the contract setting the deployer as the initial owner.
924      */
925     constructor () internal {
926         address msgSender = _msgSender();
927         _owner = msgSender;
928         emit OwnershipTransferred(address(0), msgSender);
929     }
930 
931     /**
932      * @dev Returns the address of the current owner.
933      */
934     function owner() public view returns (address) {
935         return _owner;
936     }
937 
938     /**
939      * @dev Throws if called by any account other than the owner.
940      */
941     modifier onlyOwner() {
942         require(_owner == _msgSender(), "Ownable: caller is not the owner");
943         _;
944     }
945 
946     /**
947      * @dev Leaves the contract without owner. It will not be possible to call
948      * `onlyOwner` functions anymore. Can only be called by the current owner.
949      *
950      * NOTE: Renouncing ownership will leave the contract without an owner,
951      * thereby removing any functionality that is only available to the owner.
952      */
953     function renounceOwnership() public virtual onlyOwner {
954         emit OwnershipTransferred(_owner, address(0));
955         _owner = address(0);
956     }
957 
958     /**
959      * @dev Transfers ownership of the contract to a new account (`newOwner`).
960      * Can only be called by the current owner.
961      */
962     function transferOwnership(address newOwner) public virtual onlyOwner {
963         require(newOwner != address(0), "Ownable: new owner is the zero address");
964         emit OwnershipTransferred(_owner, newOwner);
965         _owner = newOwner;
966     }
967 }
968 
969 // File: eth-token-recover/contracts/TokenRecover.sol
970 
971 pragma solidity ^0.6.0;
972 
973 
974 
975 /**
976  * @title TokenRecover
977  * @author Vittorio Minacori (https://github.com/vittominacori)
978  * @dev Allow to recover any ERC20 sent into the contract for error
979  */
980 contract TokenRecover is Ownable {
981 
982     /**
983      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
984      * @param tokenAddress The token contract address
985      * @param tokenAmount Number of tokens to be sent
986      */
987     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
988         IERC20(tokenAddress).transfer(owner(), tokenAmount);
989     }
990 }
991 
992 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
993 
994 pragma solidity ^0.6.0;
995 
996 /**
997  * @dev Library for managing
998  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
999  * types.
1000  *
1001  * Sets have the following properties:
1002  *
1003  * - Elements are added, removed, and checked for existence in constant time
1004  * (O(1)).
1005  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1006  *
1007  * ```
1008  * contract Example {
1009  *     // Add the library methods
1010  *     using EnumerableSet for EnumerableSet.AddressSet;
1011  *
1012  *     // Declare a set state variable
1013  *     EnumerableSet.AddressSet private mySet;
1014  * }
1015  * ```
1016  *
1017  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1018  * (`UintSet`) are supported.
1019  */
1020 library EnumerableSet {
1021     // To implement this library for multiple types with as little code
1022     // repetition as possible, we write it in terms of a generic Set type with
1023     // bytes32 values.
1024     // The Set implementation uses private functions, and user-facing
1025     // implementations (such as AddressSet) are just wrappers around the
1026     // underlying Set.
1027     // This means that we can only create new EnumerableSets for types that fit
1028     // in bytes32.
1029 
1030     struct Set {
1031         // Storage of set values
1032         bytes32[] _values;
1033 
1034         // Position of the value in the `values` array, plus 1 because index 0
1035         // means a value is not in the set.
1036         mapping (bytes32 => uint256) _indexes;
1037     }
1038 
1039     /**
1040      * @dev Add a value to a set. O(1).
1041      *
1042      * Returns true if the value was added to the set, that is if it was not
1043      * already present.
1044      */
1045     function _add(Set storage set, bytes32 value) private returns (bool) {
1046         if (!_contains(set, value)) {
1047             set._values.push(value);
1048             // The value is stored at length-1, but we add 1 to all indexes
1049             // and use 0 as a sentinel value
1050             set._indexes[value] = set._values.length;
1051             return true;
1052         } else {
1053             return false;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Removes a value from a set. O(1).
1059      *
1060      * Returns true if the value was removed from the set, that is if it was
1061      * present.
1062      */
1063     function _remove(Set storage set, bytes32 value) private returns (bool) {
1064         // We read and store the value's index to prevent multiple reads from the same storage slot
1065         uint256 valueIndex = set._indexes[value];
1066 
1067         if (valueIndex != 0) { // Equivalent to contains(set, value)
1068             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1069             // the array, and then remove the last element (sometimes called as 'swap and pop').
1070             // This modifies the order of the array, as noted in {at}.
1071 
1072             uint256 toDeleteIndex = valueIndex - 1;
1073             uint256 lastIndex = set._values.length - 1;
1074 
1075             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1076             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1077 
1078             bytes32 lastvalue = set._values[lastIndex];
1079 
1080             // Move the last value to the index where the value to delete is
1081             set._values[toDeleteIndex] = lastvalue;
1082             // Update the index for the moved value
1083             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1084 
1085             // Delete the slot where the moved value was stored
1086             set._values.pop();
1087 
1088             // Delete the index for the deleted slot
1089             delete set._indexes[value];
1090 
1091             return true;
1092         } else {
1093             return false;
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns true if the value is in the set. O(1).
1099      */
1100     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1101         return set._indexes[value] != 0;
1102     }
1103 
1104     /**
1105      * @dev Returns the number of values on the set. O(1).
1106      */
1107     function _length(Set storage set) private view returns (uint256) {
1108         return set._values.length;
1109     }
1110 
1111    /**
1112     * @dev Returns the value stored at position `index` in the set. O(1).
1113     *
1114     * Note that there are no guarantees on the ordering of values inside the
1115     * array, and it may change when more values are added or removed.
1116     *
1117     * Requirements:
1118     *
1119     * - `index` must be strictly less than {length}.
1120     */
1121     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1122         require(set._values.length > index, "EnumerableSet: index out of bounds");
1123         return set._values[index];
1124     }
1125 
1126     // AddressSet
1127 
1128     struct AddressSet {
1129         Set _inner;
1130     }
1131 
1132     /**
1133      * @dev Add a value to a set. O(1).
1134      *
1135      * Returns true if the value was added to the set, that is if it was not
1136      * already present.
1137      */
1138     function add(AddressSet storage set, address value) internal returns (bool) {
1139         return _add(set._inner, bytes32(uint256(value)));
1140     }
1141 
1142     /**
1143      * @dev Removes a value from a set. O(1).
1144      *
1145      * Returns true if the value was removed from the set, that is if it was
1146      * present.
1147      */
1148     function remove(AddressSet storage set, address value) internal returns (bool) {
1149         return _remove(set._inner, bytes32(uint256(value)));
1150     }
1151 
1152     /**
1153      * @dev Returns true if the value is in the set. O(1).
1154      */
1155     function contains(AddressSet storage set, address value) internal view returns (bool) {
1156         return _contains(set._inner, bytes32(uint256(value)));
1157     }
1158 
1159     /**
1160      * @dev Returns the number of values in the set. O(1).
1161      */
1162     function length(AddressSet storage set) internal view returns (uint256) {
1163         return _length(set._inner);
1164     }
1165 
1166    /**
1167     * @dev Returns the value stored at position `index` in the set. O(1).
1168     *
1169     * Note that there are no guarantees on the ordering of values inside the
1170     * array, and it may change when more values are added or removed.
1171     *
1172     * Requirements:
1173     *
1174     * - `index` must be strictly less than {length}.
1175     */
1176     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1177         return address(uint256(_at(set._inner, index)));
1178     }
1179 
1180 
1181     // UintSet
1182 
1183     struct UintSet {
1184         Set _inner;
1185     }
1186 
1187     /**
1188      * @dev Add a value to a set. O(1).
1189      *
1190      * Returns true if the value was added to the set, that is if it was not
1191      * already present.
1192      */
1193     function add(UintSet storage set, uint256 value) internal returns (bool) {
1194         return _add(set._inner, bytes32(value));
1195     }
1196 
1197     /**
1198      * @dev Removes a value from a set. O(1).
1199      *
1200      * Returns true if the value was removed from the set, that is if it was
1201      * present.
1202      */
1203     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1204         return _remove(set._inner, bytes32(value));
1205     }
1206 
1207     /**
1208      * @dev Returns true if the value is in the set. O(1).
1209      */
1210     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1211         return _contains(set._inner, bytes32(value));
1212     }
1213 
1214     /**
1215      * @dev Returns the number of values on the set. O(1).
1216      */
1217     function length(UintSet storage set) internal view returns (uint256) {
1218         return _length(set._inner);
1219     }
1220 
1221    /**
1222     * @dev Returns the value stored at position `index` in the set. O(1).
1223     *
1224     * Note that there are no guarantees on the ordering of values inside the
1225     * array, and it may change when more values are added or removed.
1226     *
1227     * Requirements:
1228     *
1229     * - `index` must be strictly less than {length}.
1230     */
1231     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1232         return uint256(_at(set._inner, index));
1233     }
1234 }
1235 
1236 // File: @openzeppelin/contracts/access/AccessControl.sol
1237 
1238 pragma solidity ^0.6.0;
1239 
1240 
1241 
1242 
1243 /**
1244  * @dev Contract module that allows children to implement role-based access
1245  * control mechanisms.
1246  *
1247  * Roles are referred to by their `bytes32` identifier. These should be exposed
1248  * in the external API and be unique. The best way to achieve this is by
1249  * using `public constant` hash digests:
1250  *
1251  * ```
1252  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1253  * ```
1254  *
1255  * Roles can be used to represent a set of permissions. To restrict access to a
1256  * function call, use {hasRole}:
1257  *
1258  * ```
1259  * function foo() public {
1260  *     require(hasRole(MY_ROLE, _msgSender()));
1261  *     ...
1262  * }
1263  * ```
1264  *
1265  * Roles can be granted and revoked dynamically via the {grantRole} and
1266  * {revokeRole} functions. Each role has an associated admin role, and only
1267  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1268  *
1269  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1270  * that only accounts with this role will be able to grant or revoke other
1271  * roles. More complex role relationships can be created by using
1272  * {_setRoleAdmin}.
1273  */
1274 abstract contract AccessControl is Context {
1275     using EnumerableSet for EnumerableSet.AddressSet;
1276     using Address for address;
1277 
1278     struct RoleData {
1279         EnumerableSet.AddressSet members;
1280         bytes32 adminRole;
1281     }
1282 
1283     mapping (bytes32 => RoleData) private _roles;
1284 
1285     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1286 
1287     /**
1288      * @dev Emitted when `account` is granted `role`.
1289      *
1290      * `sender` is the account that originated the contract call, an admin role
1291      * bearer except when using {_setupRole}.
1292      */
1293     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1294 
1295     /**
1296      * @dev Emitted when `account` is revoked `role`.
1297      *
1298      * `sender` is the account that originated the contract call:
1299      *   - if using `revokeRole`, it is the admin role bearer
1300      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1301      */
1302     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1303 
1304     /**
1305      * @dev Returns `true` if `account` has been granted `role`.
1306      */
1307     function hasRole(bytes32 role, address account) public view returns (bool) {
1308         return _roles[role].members.contains(account);
1309     }
1310 
1311     /**
1312      * @dev Returns the number of accounts that have `role`. Can be used
1313      * together with {getRoleMember} to enumerate all bearers of a role.
1314      */
1315     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1316         return _roles[role].members.length();
1317     }
1318 
1319     /**
1320      * @dev Returns one of the accounts that have `role`. `index` must be a
1321      * value between 0 and {getRoleMemberCount}, non-inclusive.
1322      *
1323      * Role bearers are not sorted in any particular way, and their ordering may
1324      * change at any point.
1325      *
1326      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1327      * you perform all queries on the same block. See the following
1328      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1329      * for more information.
1330      */
1331     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1332         return _roles[role].members.at(index);
1333     }
1334 
1335     /**
1336      * @dev Returns the admin role that controls `role`. See {grantRole} and
1337      * {revokeRole}.
1338      *
1339      * To change a role's admin, use {_setRoleAdmin}.
1340      */
1341     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1342         return _roles[role].adminRole;
1343     }
1344 
1345     /**
1346      * @dev Grants `role` to `account`.
1347      *
1348      * If `account` had not been already granted `role`, emits a {RoleGranted}
1349      * event.
1350      *
1351      * Requirements:
1352      *
1353      * - the caller must have ``role``'s admin role.
1354      */
1355     function grantRole(bytes32 role, address account) public virtual {
1356         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1357 
1358         _grantRole(role, account);
1359     }
1360 
1361     /**
1362      * @dev Revokes `role` from `account`.
1363      *
1364      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1365      *
1366      * Requirements:
1367      *
1368      * - the caller must have ``role``'s admin role.
1369      */
1370     function revokeRole(bytes32 role, address account) public virtual {
1371         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1372 
1373         _revokeRole(role, account);
1374     }
1375 
1376     /**
1377      * @dev Revokes `role` from the calling account.
1378      *
1379      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1380      * purpose is to provide a mechanism for accounts to lose their privileges
1381      * if they are compromised (such as when a trusted device is misplaced).
1382      *
1383      * If the calling account had been granted `role`, emits a {RoleRevoked}
1384      * event.
1385      *
1386      * Requirements:
1387      *
1388      * - the caller must be `account`.
1389      */
1390     function renounceRole(bytes32 role, address account) public virtual {
1391         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1392 
1393         _revokeRole(role, account);
1394     }
1395 
1396     /**
1397      * @dev Grants `role` to `account`.
1398      *
1399      * If `account` had not been already granted `role`, emits a {RoleGranted}
1400      * event. Note that unlike {grantRole}, this function doesn't perform any
1401      * checks on the calling account.
1402      *
1403      * [WARNING]
1404      * ====
1405      * This function should only be called from the constructor when setting
1406      * up the initial roles for the system.
1407      *
1408      * Using this function in any other way is effectively circumventing the admin
1409      * system imposed by {AccessControl}.
1410      * ====
1411      */
1412     function _setupRole(bytes32 role, address account) internal virtual {
1413         _grantRole(role, account);
1414     }
1415 
1416     /**
1417      * @dev Sets `adminRole` as ``role``'s admin role.
1418      */
1419     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1420         _roles[role].adminRole = adminRole;
1421     }
1422 
1423     function _grantRole(bytes32 role, address account) private {
1424         if (_roles[role].members.add(account)) {
1425             emit RoleGranted(role, account, _msgSender());
1426         }
1427     }
1428 
1429     function _revokeRole(bytes32 role, address account) private {
1430         if (_roles[role].members.remove(account)) {
1431             emit RoleRevoked(role, account, _msgSender());
1432         }
1433     }
1434 }
1435 
1436 // File: contracts/access/Roles.sol
1437 
1438 pragma solidity ^0.6.0;
1439 
1440 
1441 contract Roles is AccessControl {
1442 
1443     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1444     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1445 
1446     constructor () public {
1447         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1448         _setupRole(MINTER_ROLE, _msgSender());
1449         _setupRole(OPERATOR_ROLE, _msgSender());
1450     }
1451 
1452     modifier onlyMinter() {
1453         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1454         _;
1455     }
1456 
1457     modifier onlyOperator() {
1458         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1459         _;
1460     }
1461 }
1462 
1463 // File: contracts/TrenderingToken.sol
1464 
1465 pragma solidity ^0.6.0;
1466 
1467 
1468 
1469 
1470 
1471 
1472 /**
1473  * @title TrenderingToken
1474  * @author C based on source by https://github.com/vittominacori
1475  * @dev Implementation of the TrenderingToken
1476  */
1477 contract TrenderingToken is ERC20Capped, ERC20Burnable, Roles, TokenRecover {
1478 
1479     // indicates if minting is finished
1480     bool private _mintingFinished = false;
1481 
1482     // indicates if transfer is enabled
1483     bool private _transferEnabled = false;
1484 
1485     string public constant BUILT_ON = "context-machine: trendering.com";
1486 
1487     /**
1488      * @dev Emitted during finish minting
1489      */
1490     event MintFinished();
1491 
1492     /**
1493      * @dev Emitted during transfer enabling
1494      */
1495     event TransferEnabled();
1496 
1497     /**
1498      * @dev Tokens can be minted only before minting finished.
1499      */
1500     modifier canMint() {
1501         require(!_mintingFinished, "TrenderingToken: minting is finished");
1502         _;
1503     }
1504 
1505     /**
1506      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1507      */
1508     modifier canTransfer(address from) {
1509         require(
1510             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1511             "TrenderingToken: transfer is not enabled or from does not have the OPERATOR role"
1512         );
1513         _;
1514     }
1515 
1516     /**
1517      * @param name Name of the token
1518      * @param symbol A symbol to be used as ticker
1519      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1520      * @param cap Maximum number of tokens mintable
1521      * @param initialSupply Initial token supply
1522      * @param transferEnabled If transfer is enabled on token creation
1523      * @param mintingFinished If minting is finished after token creation
1524      */
1525     constructor(
1526         string memory name,
1527         string memory symbol,
1528         uint8 decimals,
1529         uint256 cap,
1530         uint256 initialSupply,
1531         bool transferEnabled,
1532         bool mintingFinished
1533     )
1534         public
1535         ERC20Capped(cap)
1536         ERC20(name, symbol)
1537     {
1538         require(
1539             mintingFinished == false || cap == initialSupply,
1540             "TrenderingToken: if finish minting, cap must be equal to initialSupply"
1541         );
1542 
1543         _setupDecimals(decimals);
1544 
1545         if (initialSupply > 0) {
1546             _mint(owner(), initialSupply);
1547         }
1548 
1549         if (mintingFinished) {
1550             finishMinting();
1551         }
1552 
1553         if (transferEnabled) {
1554             enableTransfer();
1555         }
1556     }
1557 
1558     /**
1559      * @return if minting is finished or not.
1560      */
1561     function mintingFinished() public view returns (bool) {
1562         return _mintingFinished;
1563     }
1564 
1565     /**
1566      * @return if transfer is enabled or not.
1567      */
1568     function transferEnabled() public view returns (bool) {
1569         return _transferEnabled;
1570     }
1571 
1572     /**
1573      * @dev Function to mint tokens.
1574      * @param to The address that will receive the minted tokens
1575      * @param value The amount of tokens to mint
1576      */
1577     function mint(address to, uint256 value) public canMint onlyMinter {
1578         _mint(to, value);
1579     }
1580 
1581     /**
1582      * @dev Transfer tokens to a specified address.
1583      * @param to The address to transfer to
1584      * @param value The amount to be transferred
1585      * @return A boolean that indicates if the operation was successful.
1586      */
1587     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
1588         return super.transfer(to, value);
1589     }
1590 
1591     /**
1592      * @dev Transfer tokens from one address to another.
1593      * @param from The address which you want to send tokens from
1594      * @param to The address which you want to transfer to
1595      * @param value the amount of tokens to be transferred
1596      * @return A boolean that indicates if the operation was successful.
1597      */
1598     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
1599         return super.transferFrom(from, to, value);
1600     }
1601 
1602     /**
1603      * @dev Function to stop minting new tokens.
1604      */
1605     function finishMinting() public canMint onlyOwner {
1606         _mintingFinished = true;
1607 
1608         emit MintFinished();
1609     }
1610 
1611     /**
1612      * @dev Function to enable transfers.
1613      */
1614     function enableTransfer() public onlyOwner {
1615         _transferEnabled = true;
1616 
1617         emit TransferEnabled();
1618     }
1619 
1620     /**
1621      * @dev See {ERC20-_beforeTokenTransfer}.
1622      */
1623     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1624         super._beforeTokenTransfer(from, to, amount);
1625     }
1626 }