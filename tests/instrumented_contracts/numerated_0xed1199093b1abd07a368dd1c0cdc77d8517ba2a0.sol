1 // BUILT FOR FREE ON https://vittominacori.github.io/erc20-generator
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
739 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
740 
741 pragma solidity ^0.6.0;
742 
743 
744 
745 /**
746  * @title IERC1363 Interface
747  * @author Vittorio Minacori (https://github.com/vittominacori)
748  * @dev Interface for a Payable Token contract as defined in
749  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
750  */
751 interface IERC1363 is IERC20, IERC165 {
752     /*
753      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
754      * 0x4bbee2df ===
755      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
756      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
757      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
758      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
759      */
760 
761     /*
762      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
763      * 0xfb9ec8ce ===
764      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
765      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
766      */
767 
768     /**
769      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
770      * @param to address The address which you want to transfer to
771      * @param value uint256 The amount of tokens to be transferred
772      * @return true unless throwing
773      */
774     function transferAndCall(address to, uint256 value) external returns (bool);
775 
776     /**
777      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
778      * @param to address The address which you want to transfer to
779      * @param value uint256 The amount of tokens to be transferred
780      * @param data bytes Additional data with no specified format, sent in call to `to`
781      * @return true unless throwing
782      */
783     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
784 
785     /**
786      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
787      * @param from address The address which you want to send tokens from
788      * @param to address The address which you want to transfer to
789      * @param value uint256 The amount of tokens to be transferred
790      * @return true unless throwing
791      */
792     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
793 
794     /**
795      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
796      * @param from address The address which you want to send tokens from
797      * @param to address The address which you want to transfer to
798      * @param value uint256 The amount of tokens to be transferred
799      * @param data bytes Additional data with no specified format, sent in call to `to`
800      * @return true unless throwing
801      */
802     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
803 
804     /**
805      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
806      * and then call `onApprovalReceived` on spender.
807      * Beware that changing an allowance with this method brings the risk that someone may use both the old
808      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
809      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
810      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
811      * @param spender address The address which will spend the funds
812      * @param value uint256 The amount of tokens to be spent
813      */
814     function approveAndCall(address spender, uint256 value) external returns (bool);
815 
816     /**
817      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
818      * and then call `onApprovalReceived` on spender.
819      * Beware that changing an allowance with this method brings the risk that someone may use both the old
820      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
821      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
822      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
823      * @param spender address The address which will spend the funds
824      * @param value uint256 The amount of tokens to be spent
825      * @param data bytes Additional data with no specified format, sent in call to `spender`
826      */
827     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
828 }
829 
830 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
831 
832 pragma solidity ^0.6.0;
833 
834 /**
835  * @title IERC1363Receiver Interface
836  * @author Vittorio Minacori (https://github.com/vittominacori)
837  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
838  *  from ERC1363 token contracts as defined in
839  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
840  */
841 interface IERC1363Receiver {
842     /*
843      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
844      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
845      */
846 
847     /**
848      * @notice Handle the receipt of ERC1363 tokens
849      * @dev Any ERC1363 smart contract calls this function on the recipient
850      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
851      * transfer. Return of other than the magic value MUST result in the
852      * transaction being reverted.
853      * Note: the token contract address is always the message sender.
854      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
855      * @param from address The address which are token transferred from
856      * @param value uint256 The amount of tokens transferred
857      * @param data bytes Additional data with no specified format
858      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
859      *  unless throwing
860      */
861     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
862 }
863 
864 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
865 
866 pragma solidity ^0.6.0;
867 
868 /**
869  * @title IERC1363Spender Interface
870  * @author Vittorio Minacori (https://github.com/vittominacori)
871  * @dev Interface for any contract that wants to support approveAndCall
872  *  from ERC1363 token contracts as defined in
873  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
874  */
875 interface IERC1363Spender {
876     /*
877      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
878      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
879      */
880 
881     /**
882      * @notice Handle the approval of ERC1363 tokens
883      * @dev Any ERC1363 smart contract calls this function on the recipient
884      * after an `approve`. This function MAY throw to revert and reject the
885      * approval. Return of other than the magic value MUST result in the
886      * transaction being reverted.
887      * Note: the token contract address is always the message sender.
888      * @param owner address The address which called `approveAndCall` function
889      * @param value uint256 The amount of tokens to be spent
890      * @param data bytes Additional data with no specified format
891      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
892      *  unless throwing
893      */
894     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
895 }
896 
897 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
898 
899 pragma solidity ^0.6.2;
900 
901 /**
902  * @dev Library used to query support of an interface declared via {IERC165}.
903  *
904  * Note that these functions return the actual result of the query: they do not
905  * `revert` if an interface is not supported. It is up to the caller to decide
906  * what to do in these cases.
907  */
908 library ERC165Checker {
909     // As per the EIP-165 spec, no interface should ever match 0xffffffff
910     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
911 
912     /*
913      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
914      */
915     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
916 
917     /**
918      * @dev Returns true if `account` supports the {IERC165} interface,
919      */
920     function supportsERC165(address account) internal view returns (bool) {
921         // Any contract that implements ERC165 must explicitly indicate support of
922         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
923         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
924             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
925     }
926 
927     /**
928      * @dev Returns true if `account` supports the interface defined by
929      * `interfaceId`. Support for {IERC165} itself is queried automatically.
930      *
931      * See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
934         // query support of both ERC165 as per the spec and support of _interfaceId
935         return supportsERC165(account) &&
936             _supportsERC165Interface(account, interfaceId);
937     }
938 
939     /**
940      * @dev Returns true if `account` supports all the interfaces defined in
941      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
942      *
943      * Batch-querying can lead to gas savings by skipping repeated checks for
944      * {IERC165} support.
945      *
946      * See {IERC165-supportsInterface}.
947      */
948     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
949         // query support of ERC165 itself
950         if (!supportsERC165(account)) {
951             return false;
952         }
953 
954         // query support of each interface in _interfaceIds
955         for (uint256 i = 0; i < interfaceIds.length; i++) {
956             if (!_supportsERC165Interface(account, interfaceIds[i])) {
957                 return false;
958             }
959         }
960 
961         // all interfaces supported
962         return true;
963     }
964 
965     /**
966      * @notice Query if a contract implements an interface, does not check ERC165 support
967      * @param account The address of the contract to query for support of an interface
968      * @param interfaceId The interface identifier, as specified in ERC-165
969      * @return true if the contract at account indicates support of the interface with
970      * identifier interfaceId, false otherwise
971      * @dev Assumes that account contains a contract that supports ERC165, otherwise
972      * the behavior of this method is undefined. This precondition can be checked
973      * with {supportsERC165}.
974      * Interface identification is specified in ERC-165.
975      */
976     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
977         // success determines whether the staticcall succeeded and result determines
978         // whether the contract at account indicates support of _interfaceId
979         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
980 
981         return (success && result);
982     }
983 
984     /**
985      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
986      * @param account The address of the contract to query for support of an interface
987      * @param interfaceId The interface identifier, as specified in ERC-165
988      * @return success true if the STATICCALL succeeded, false otherwise
989      * @return result true if the STATICCALL succeeded and the contract at account
990      * indicates support of the interface with identifier interfaceId, false otherwise
991      */
992     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
993         private
994         view
995         returns (bool, bool)
996     {
997         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
998         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
999         if (result.length < 32) return (false, false);
1000         return (success, abi.decode(result, (bool)));
1001     }
1002 }
1003 
1004 // File: @openzeppelin/contracts/introspection/ERC165.sol
1005 
1006 pragma solidity ^0.6.0;
1007 
1008 
1009 /**
1010  * @dev Implementation of the {IERC165} interface.
1011  *
1012  * Contracts may inherit from this and call {_registerInterface} to declare
1013  * their support of an interface.
1014  */
1015 contract ERC165 is IERC165 {
1016     /*
1017      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1018      */
1019     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1020 
1021     /**
1022      * @dev Mapping of interface ids to whether or not it's supported.
1023      */
1024     mapping(bytes4 => bool) private _supportedInterfaces;
1025 
1026     constructor () internal {
1027         // Derived contracts need only register support for their own interfaces,
1028         // we register support for ERC165 itself here
1029         _registerInterface(_INTERFACE_ID_ERC165);
1030     }
1031 
1032     /**
1033      * @dev See {IERC165-supportsInterface}.
1034      *
1035      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1036      */
1037     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1038         return _supportedInterfaces[interfaceId];
1039     }
1040 
1041     /**
1042      * @dev Registers the contract as an implementer of the interface defined by
1043      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1044      * registering its interface id is not required.
1045      *
1046      * See {IERC165-supportsInterface}.
1047      *
1048      * Requirements:
1049      *
1050      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1051      */
1052     function _registerInterface(bytes4 interfaceId) internal virtual {
1053         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1054         _supportedInterfaces[interfaceId] = true;
1055     }
1056 }
1057 
1058 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1059 
1060 pragma solidity ^0.6.0;
1061 
1062 
1063 
1064 
1065 
1066 
1067 
1068 
1069 /**
1070  * @title ERC1363
1071  * @author Vittorio Minacori (https://github.com/vittominacori)
1072  * @dev Implementation of an ERC1363 interface
1073  */
1074 contract ERC1363 is ERC20, IERC1363, ERC165 {
1075     using Address for address;
1076 
1077     /*
1078      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1079      * 0x4bbee2df ===
1080      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1081      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1082      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1083      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1084      */
1085     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1086 
1087     /*
1088      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1089      * 0xfb9ec8ce ===
1090      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1091      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1092      */
1093     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1094 
1095     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1096     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1097     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1098 
1099     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1100     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1101     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1102 
1103     /**
1104      * @param name Name of the token
1105      * @param symbol A symbol to be used as ticker
1106      */
1107     constructor (
1108         string memory name,
1109         string memory symbol
1110     ) public payable ERC20(name, symbol) {
1111         // register the supported interfaces to conform to ERC1363 via ERC165
1112         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1113         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1114     }
1115 
1116     /**
1117      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1118      * @param to The address to transfer to.
1119      * @param value The amount to be transferred.
1120      * @return A boolean that indicates if the operation was successful.
1121      */
1122     function transferAndCall(address to, uint256 value) public override returns (bool) {
1123         return transferAndCall(to, value, "");
1124     }
1125 
1126     /**
1127      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1128      * @param to The address to transfer to
1129      * @param value The amount to be transferred
1130      * @param data Additional data with no specified format
1131      * @return A boolean that indicates if the operation was successful.
1132      */
1133     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1134         transfer(to, value);
1135         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1136         return true;
1137     }
1138 
1139     /**
1140      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1141      * @param from The address which you want to send tokens from
1142      * @param to The address which you want to transfer to
1143      * @param value The amount of tokens to be transferred
1144      * @return A boolean that indicates if the operation was successful.
1145      */
1146     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1147         return transferFromAndCall(from, to, value, "");
1148     }
1149 
1150     /**
1151      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1152      * @param from The address which you want to send tokens from
1153      * @param to The address which you want to transfer to
1154      * @param value The amount of tokens to be transferred
1155      * @param data Additional data with no specified format
1156      * @return A boolean that indicates if the operation was successful.
1157      */
1158     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1159         transferFrom(from, to, value);
1160         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1161         return true;
1162     }
1163 
1164     /**
1165      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1166      * @param spender The address allowed to transfer to
1167      * @param value The amount allowed to be transferred
1168      * @return A boolean that indicates if the operation was successful.
1169      */
1170     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1171         return approveAndCall(spender, value, "");
1172     }
1173 
1174     /**
1175      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1176      * @param spender The address allowed to transfer to.
1177      * @param value The amount allowed to be transferred.
1178      * @param data Additional data with no specified format.
1179      * @return A boolean that indicates if the operation was successful.
1180      */
1181     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1182         approve(spender, value);
1183         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1184         return true;
1185     }
1186 
1187     /**
1188      * @dev Internal function to invoke `onTransferReceived` on a target address
1189      *  The call is not executed if the target address is not a contract
1190      * @param from address Representing the previous owner of the given token value
1191      * @param to address Target address that will receive the tokens
1192      * @param value uint256 The amount mount of tokens to be transferred
1193      * @param data bytes Optional data to send along with the call
1194      * @return whether the call correctly returned the expected magic value
1195      */
1196     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
1197         if (!to.isContract()) {
1198             return false;
1199         }
1200         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1201             _msgSender(), from, value, data
1202         );
1203         return (retval == _ERC1363_RECEIVED);
1204     }
1205 
1206     /**
1207      * @dev Internal function to invoke `onApprovalReceived` on a target address
1208      *  The call is not executed if the target address is not a contract
1209      * @param spender address The address which will spend the funds
1210      * @param value uint256 The amount of tokens to be spent
1211      * @param data bytes Optional data to send along with the call
1212      * @return whether the call correctly returned the expected magic value
1213      */
1214     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1215         if (!spender.isContract()) {
1216             return false;
1217         }
1218         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1219             _msgSender(), value, data
1220         );
1221         return (retval == _ERC1363_APPROVED);
1222     }
1223 }
1224 
1225 // File: @openzeppelin/contracts/access/Ownable.sol
1226 
1227 pragma solidity ^0.6.0;
1228 
1229 /**
1230  * @dev Contract module which provides a basic access control mechanism, where
1231  * there is an account (an owner) that can be granted exclusive access to
1232  * specific functions.
1233  *
1234  * By default, the owner account will be the one that deploys the contract. This
1235  * can later be changed with {transferOwnership}.
1236  *
1237  * This module is used through inheritance. It will make available the modifier
1238  * `onlyOwner`, which can be applied to your functions to restrict their use to
1239  * the owner.
1240  */
1241 contract Ownable is Context {
1242     address private _owner;
1243 
1244     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1245 
1246     /**
1247      * @dev Initializes the contract setting the deployer as the initial owner.
1248      */
1249     constructor () internal {
1250         address msgSender = _msgSender();
1251         _owner = msgSender;
1252         emit OwnershipTransferred(address(0), msgSender);
1253     }
1254 
1255     /**
1256      * @dev Returns the address of the current owner.
1257      */
1258     function owner() public view returns (address) {
1259         return _owner;
1260     }
1261 
1262     /**
1263      * @dev Throws if called by any account other than the owner.
1264      */
1265     modifier onlyOwner() {
1266         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1267         _;
1268     }
1269 
1270     /**
1271      * @dev Leaves the contract without owner. It will not be possible to call
1272      * `onlyOwner` functions anymore. Can only be called by the current owner.
1273      *
1274      * NOTE: Renouncing ownership will leave the contract without an owner,
1275      * thereby removing any functionality that is only available to the owner.
1276      */
1277     function renounceOwnership() public virtual onlyOwner {
1278         emit OwnershipTransferred(_owner, address(0));
1279         _owner = address(0);
1280     }
1281 
1282     /**
1283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1284      * Can only be called by the current owner.
1285      */
1286     function transferOwnership(address newOwner) public virtual onlyOwner {
1287         require(newOwner != address(0), "Ownable: new owner is the zero address");
1288         emit OwnershipTransferred(_owner, newOwner);
1289         _owner = newOwner;
1290     }
1291 }
1292 
1293 // File: eth-token-recover/contracts/TokenRecover.sol
1294 
1295 pragma solidity ^0.6.0;
1296 
1297 
1298 
1299 /**
1300  * @title TokenRecover
1301  * @author Vittorio Minacori (https://github.com/vittominacori)
1302  * @dev Allow to recover any ERC20 sent into the contract for error
1303  */
1304 contract TokenRecover is Ownable {
1305 
1306     /**
1307      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1308      * @param tokenAddress The token contract address
1309      * @param tokenAmount Number of tokens to be sent
1310      */
1311     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1312         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1313     }
1314 }
1315 
1316 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1317 
1318 pragma solidity ^0.6.0;
1319 
1320 /**
1321  * @dev Library for managing
1322  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1323  * types.
1324  *
1325  * Sets have the following properties:
1326  *
1327  * - Elements are added, removed, and checked for existence in constant time
1328  * (O(1)).
1329  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1330  *
1331  * ```
1332  * contract Example {
1333  *     // Add the library methods
1334  *     using EnumerableSet for EnumerableSet.AddressSet;
1335  *
1336  *     // Declare a set state variable
1337  *     EnumerableSet.AddressSet private mySet;
1338  * }
1339  * ```
1340  *
1341  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1342  * (`UintSet`) are supported.
1343  */
1344 library EnumerableSet {
1345     // To implement this library for multiple types with as little code
1346     // repetition as possible, we write it in terms of a generic Set type with
1347     // bytes32 values.
1348     // The Set implementation uses private functions, and user-facing
1349     // implementations (such as AddressSet) are just wrappers around the
1350     // underlying Set.
1351     // This means that we can only create new EnumerableSets for types that fit
1352     // in bytes32.
1353 
1354     struct Set {
1355         // Storage of set values
1356         bytes32[] _values;
1357 
1358         // Position of the value in the `values` array, plus 1 because index 0
1359         // means a value is not in the set.
1360         mapping (bytes32 => uint256) _indexes;
1361     }
1362 
1363     /**
1364      * @dev Add a value to a set. O(1).
1365      *
1366      * Returns true if the value was added to the set, that is if it was not
1367      * already present.
1368      */
1369     function _add(Set storage set, bytes32 value) private returns (bool) {
1370         if (!_contains(set, value)) {
1371             set._values.push(value);
1372             // The value is stored at length-1, but we add 1 to all indexes
1373             // and use 0 as a sentinel value
1374             set._indexes[value] = set._values.length;
1375             return true;
1376         } else {
1377             return false;
1378         }
1379     }
1380 
1381     /**
1382      * @dev Removes a value from a set. O(1).
1383      *
1384      * Returns true if the value was removed from the set, that is if it was
1385      * present.
1386      */
1387     function _remove(Set storage set, bytes32 value) private returns (bool) {
1388         // We read and store the value's index to prevent multiple reads from the same storage slot
1389         uint256 valueIndex = set._indexes[value];
1390 
1391         if (valueIndex != 0) { // Equivalent to contains(set, value)
1392             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1393             // the array, and then remove the last element (sometimes called as 'swap and pop').
1394             // This modifies the order of the array, as noted in {at}.
1395 
1396             uint256 toDeleteIndex = valueIndex - 1;
1397             uint256 lastIndex = set._values.length - 1;
1398 
1399             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1400             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1401 
1402             bytes32 lastvalue = set._values[lastIndex];
1403 
1404             // Move the last value to the index where the value to delete is
1405             set._values[toDeleteIndex] = lastvalue;
1406             // Update the index for the moved value
1407             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1408 
1409             // Delete the slot where the moved value was stored
1410             set._values.pop();
1411 
1412             // Delete the index for the deleted slot
1413             delete set._indexes[value];
1414 
1415             return true;
1416         } else {
1417             return false;
1418         }
1419     }
1420 
1421     /**
1422      * @dev Returns true if the value is in the set. O(1).
1423      */
1424     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1425         return set._indexes[value] != 0;
1426     }
1427 
1428     /**
1429      * @dev Returns the number of values on the set. O(1).
1430      */
1431     function _length(Set storage set) private view returns (uint256) {
1432         return set._values.length;
1433     }
1434 
1435    /**
1436     * @dev Returns the value stored at position `index` in the set. O(1).
1437     *
1438     * Note that there are no guarantees on the ordering of values inside the
1439     * array, and it may change when more values are added or removed.
1440     *
1441     * Requirements:
1442     *
1443     * - `index` must be strictly less than {length}.
1444     */
1445     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1446         require(set._values.length > index, "EnumerableSet: index out of bounds");
1447         return set._values[index];
1448     }
1449 
1450     // AddressSet
1451 
1452     struct AddressSet {
1453         Set _inner;
1454     }
1455 
1456     /**
1457      * @dev Add a value to a set. O(1).
1458      *
1459      * Returns true if the value was added to the set, that is if it was not
1460      * already present.
1461      */
1462     function add(AddressSet storage set, address value) internal returns (bool) {
1463         return _add(set._inner, bytes32(uint256(value)));
1464     }
1465 
1466     /**
1467      * @dev Removes a value from a set. O(1).
1468      *
1469      * Returns true if the value was removed from the set, that is if it was
1470      * present.
1471      */
1472     function remove(AddressSet storage set, address value) internal returns (bool) {
1473         return _remove(set._inner, bytes32(uint256(value)));
1474     }
1475 
1476     /**
1477      * @dev Returns true if the value is in the set. O(1).
1478      */
1479     function contains(AddressSet storage set, address value) internal view returns (bool) {
1480         return _contains(set._inner, bytes32(uint256(value)));
1481     }
1482 
1483     /**
1484      * @dev Returns the number of values in the set. O(1).
1485      */
1486     function length(AddressSet storage set) internal view returns (uint256) {
1487         return _length(set._inner);
1488     }
1489 
1490    /**
1491     * @dev Returns the value stored at position `index` in the set. O(1).
1492     *
1493     * Note that there are no guarantees on the ordering of values inside the
1494     * array, and it may change when more values are added or removed.
1495     *
1496     * Requirements:
1497     *
1498     * - `index` must be strictly less than {length}.
1499     */
1500     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1501         return address(uint256(_at(set._inner, index)));
1502     }
1503 
1504 
1505     // UintSet
1506 
1507     struct UintSet {
1508         Set _inner;
1509     }
1510 
1511     /**
1512      * @dev Add a value to a set. O(1).
1513      *
1514      * Returns true if the value was added to the set, that is if it was not
1515      * already present.
1516      */
1517     function add(UintSet storage set, uint256 value) internal returns (bool) {
1518         return _add(set._inner, bytes32(value));
1519     }
1520 
1521     /**
1522      * @dev Removes a value from a set. O(1).
1523      *
1524      * Returns true if the value was removed from the set, that is if it was
1525      * present.
1526      */
1527     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1528         return _remove(set._inner, bytes32(value));
1529     }
1530 
1531     /**
1532      * @dev Returns true if the value is in the set. O(1).
1533      */
1534     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1535         return _contains(set._inner, bytes32(value));
1536     }
1537 
1538     /**
1539      * @dev Returns the number of values on the set. O(1).
1540      */
1541     function length(UintSet storage set) internal view returns (uint256) {
1542         return _length(set._inner);
1543     }
1544 
1545    /**
1546     * @dev Returns the value stored at position `index` in the set. O(1).
1547     *
1548     * Note that there are no guarantees on the ordering of values inside the
1549     * array, and it may change when more values are added or removed.
1550     *
1551     * Requirements:
1552     *
1553     * - `index` must be strictly less than {length}.
1554     */
1555     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1556         return uint256(_at(set._inner, index));
1557     }
1558 }
1559 
1560 // File: @openzeppelin/contracts/access/AccessControl.sol
1561 
1562 pragma solidity ^0.6.0;
1563 
1564 
1565 
1566 
1567 /**
1568  * @dev Contract module that allows children to implement role-based access
1569  * control mechanisms.
1570  *
1571  * Roles are referred to by their `bytes32` identifier. These should be exposed
1572  * in the external API and be unique. The best way to achieve this is by
1573  * using `public constant` hash digests:
1574  *
1575  * ```
1576  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1577  * ```
1578  *
1579  * Roles can be used to represent a set of permissions. To restrict access to a
1580  * function call, use {hasRole}:
1581  *
1582  * ```
1583  * function foo() public {
1584  *     require(hasRole(MY_ROLE, _msgSender()));
1585  *     ...
1586  * }
1587  * ```
1588  *
1589  * Roles can be granted and revoked dynamically via the {grantRole} and
1590  * {revokeRole} functions. Each role has an associated admin role, and only
1591  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1592  *
1593  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1594  * that only accounts with this role will be able to grant or revoke other
1595  * roles. More complex role relationships can be created by using
1596  * {_setRoleAdmin}.
1597  */
1598 abstract contract AccessControl is Context {
1599     using EnumerableSet for EnumerableSet.AddressSet;
1600     using Address for address;
1601 
1602     struct RoleData {
1603         EnumerableSet.AddressSet members;
1604         bytes32 adminRole;
1605     }
1606 
1607     mapping (bytes32 => RoleData) private _roles;
1608 
1609     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1610 
1611     /**
1612      * @dev Emitted when `account` is granted `role`.
1613      *
1614      * `sender` is the account that originated the contract call, an admin role
1615      * bearer except when using {_setupRole}.
1616      */
1617     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1618 
1619     /**
1620      * @dev Emitted when `account` is revoked `role`.
1621      *
1622      * `sender` is the account that originated the contract call:
1623      *   - if using `revokeRole`, it is the admin role bearer
1624      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1625      */
1626     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1627 
1628     /**
1629      * @dev Returns `true` if `account` has been granted `role`.
1630      */
1631     function hasRole(bytes32 role, address account) public view returns (bool) {
1632         return _roles[role].members.contains(account);
1633     }
1634 
1635     /**
1636      * @dev Returns the number of accounts that have `role`. Can be used
1637      * together with {getRoleMember} to enumerate all bearers of a role.
1638      */
1639     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1640         return _roles[role].members.length();
1641     }
1642 
1643     /**
1644      * @dev Returns one of the accounts that have `role`. `index` must be a
1645      * value between 0 and {getRoleMemberCount}, non-inclusive.
1646      *
1647      * Role bearers are not sorted in any particular way, and their ordering may
1648      * change at any point.
1649      *
1650      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1651      * you perform all queries on the same block. See the following
1652      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1653      * for more information.
1654      */
1655     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1656         return _roles[role].members.at(index);
1657     }
1658 
1659     /**
1660      * @dev Returns the admin role that controls `role`. See {grantRole} and
1661      * {revokeRole}.
1662      *
1663      * To change a role's admin, use {_setRoleAdmin}.
1664      */
1665     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1666         return _roles[role].adminRole;
1667     }
1668 
1669     /**
1670      * @dev Grants `role` to `account`.
1671      *
1672      * If `account` had not been already granted `role`, emits a {RoleGranted}
1673      * event.
1674      *
1675      * Requirements:
1676      *
1677      * - the caller must have ``role``'s admin role.
1678      */
1679     function grantRole(bytes32 role, address account) public virtual {
1680         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1681 
1682         _grantRole(role, account);
1683     }
1684 
1685     /**
1686      * @dev Revokes `role` from `account`.
1687      *
1688      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1689      *
1690      * Requirements:
1691      *
1692      * - the caller must have ``role``'s admin role.
1693      */
1694     function revokeRole(bytes32 role, address account) public virtual {
1695         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1696 
1697         _revokeRole(role, account);
1698     }
1699 
1700     /**
1701      * @dev Revokes `role` from the calling account.
1702      *
1703      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1704      * purpose is to provide a mechanism for accounts to lose their privileges
1705      * if they are compromised (such as when a trusted device is misplaced).
1706      *
1707      * If the calling account had been granted `role`, emits a {RoleRevoked}
1708      * event.
1709      *
1710      * Requirements:
1711      *
1712      * - the caller must be `account`.
1713      */
1714     function renounceRole(bytes32 role, address account) public virtual {
1715         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1716 
1717         _revokeRole(role, account);
1718     }
1719 
1720     /**
1721      * @dev Grants `role` to `account`.
1722      *
1723      * If `account` had not been already granted `role`, emits a {RoleGranted}
1724      * event. Note that unlike {grantRole}, this function doesn't perform any
1725      * checks on the calling account.
1726      *
1727      * [WARNING]
1728      * ====
1729      * This function should only be called from the constructor when setting
1730      * up the initial roles for the system.
1731      *
1732      * Using this function in any other way is effectively circumventing the admin
1733      * system imposed by {AccessControl}.
1734      * ====
1735      */
1736     function _setupRole(bytes32 role, address account) internal virtual {
1737         _grantRole(role, account);
1738     }
1739 
1740     /**
1741      * @dev Sets `adminRole` as ``role``'s admin role.
1742      */
1743     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1744         _roles[role].adminRole = adminRole;
1745     }
1746 
1747     function _grantRole(bytes32 role, address account) private {
1748         if (_roles[role].members.add(account)) {
1749             emit RoleGranted(role, account, _msgSender());
1750         }
1751     }
1752 
1753     function _revokeRole(bytes32 role, address account) private {
1754         if (_roles[role].members.remove(account)) {
1755             emit RoleRevoked(role, account, _msgSender());
1756         }
1757     }
1758 }
1759 
1760 // File: contracts/access/Roles.sol
1761 
1762 pragma solidity ^0.6.0;
1763 
1764 
1765 contract Roles is AccessControl {
1766 
1767     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1768     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1769 
1770     constructor () public {
1771         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1772         _setupRole(MINTER_ROLE, _msgSender());
1773         _setupRole(OPERATOR_ROLE, _msgSender());
1774     }
1775 
1776     modifier onlyMinter() {
1777         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1778         _;
1779     }
1780 
1781     modifier onlyOperator() {
1782         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1783         _;
1784     }
1785 }
1786 
1787 // File: contracts/BaseToken.sol
1788 
1789 pragma solidity ^0.6.0;
1790 
1791 
1792 
1793 
1794 
1795 
1796 /**
1797  * @title BaseToken
1798  * @author Vittorio Minacori (https://github.com/vittominacori)
1799  * @dev Implementation of the BaseToken
1800  */
1801 contract BaseToken is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {
1802 
1803     // indicates if minting is finished
1804     bool private _mintingFinished = false;
1805 
1806     // indicates if transfer is enabled
1807     bool private _transferEnabled = false;
1808 
1809     string public constant BUILT_ON = "https://vittominacori.github.io/erc20-generator";
1810 
1811     /**
1812      * @dev Emitted during finish minting
1813      */
1814     event MintFinished();
1815 
1816     /**
1817      * @dev Emitted during transfer enabling
1818      */
1819     event TransferEnabled();
1820 
1821     /**
1822      * @dev Tokens can be minted only before minting finished.
1823      */
1824     modifier canMint() {
1825         require(!_mintingFinished, "BaseToken: minting is finished");
1826         _;
1827     }
1828 
1829     /**
1830      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1831      */
1832     modifier canTransfer(address from) {
1833         require(
1834             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1835             "BaseToken: transfer is not enabled or from does not have the OPERATOR role"
1836         );
1837         _;
1838     }
1839 
1840     /**
1841      * @param name Name of the token
1842      * @param symbol A symbol to be used as ticker
1843      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1844      * @param cap Maximum number of tokens mintable
1845      * @param initialSupply Initial token supply
1846      * @param transferEnabled If transfer is enabled on token creation
1847      * @param mintingFinished If minting is finished after token creation
1848      */
1849     constructor(
1850         string memory name,
1851         string memory symbol,
1852         uint8 decimals,
1853         uint256 cap,
1854         uint256 initialSupply,
1855         bool transferEnabled,
1856         bool mintingFinished
1857     )
1858         public
1859         ERC20Capped(cap)
1860         ERC1363(name, symbol)
1861     {
1862         require(
1863             mintingFinished == false || cap == initialSupply,
1864             "BaseToken: if finish minting, cap must be equal to initialSupply"
1865         );
1866 
1867         _setupDecimals(decimals);
1868 
1869         if (initialSupply > 0) {
1870             _mint(owner(), initialSupply);
1871         }
1872 
1873         if (mintingFinished) {
1874             finishMinting();
1875         }
1876 
1877         if (transferEnabled) {
1878             enableTransfer();
1879         }
1880     }
1881 
1882     /**
1883      * @return if minting is finished or not.
1884      */
1885     function mintingFinished() public view returns (bool) {
1886         return _mintingFinished;
1887     }
1888 
1889     /**
1890      * @return if transfer is enabled or not.
1891      */
1892     function transferEnabled() public view returns (bool) {
1893         return _transferEnabled;
1894     }
1895 
1896     /**
1897      * @dev Function to mint tokens.
1898      * @param to The address that will receive the minted tokens
1899      * @param value The amount of tokens to mint
1900      */
1901     function mint(address to, uint256 value) public canMint onlyMinter {
1902         _mint(to, value);
1903     }
1904 
1905     /**
1906      * @dev Transfer tokens to a specified address.
1907      * @param to The address to transfer to
1908      * @param value The amount to be transferred
1909      * @return A boolean that indicates if the operation was successful.
1910      */
1911     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
1912         return super.transfer(to, value);
1913     }
1914 
1915     /**
1916      * @dev Transfer tokens from one address to another.
1917      * @param from The address which you want to send tokens from
1918      * @param to The address which you want to transfer to
1919      * @param value the amount of tokens to be transferred
1920      * @return A boolean that indicates if the operation was successful.
1921      */
1922     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
1923         return super.transferFrom(from, to, value);
1924     }
1925 
1926     /**
1927      * @dev Function to stop minting new tokens.
1928      */
1929     function finishMinting() public canMint onlyOwner {
1930         _mintingFinished = true;
1931 
1932         emit MintFinished();
1933     }
1934 
1935     /**
1936      * @dev Function to enable transfers.
1937      */
1938     function enableTransfer() public onlyOwner {
1939         _transferEnabled = true;
1940 
1941         emit TransferEnabled();
1942     }
1943 
1944     /**
1945      * @dev See {ERC20-_beforeTokenTransfer}.
1946      */
1947     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1948         super._beforeTokenTransfer(from, to, amount);
1949     }
1950 }