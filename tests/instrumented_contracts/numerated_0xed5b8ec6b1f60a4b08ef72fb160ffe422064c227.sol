1 // Trendering.com, Trendering.org
2 // Yield Token for Staking and Governance
3 
4 // File: @openzeppelin/contracts/GSN/Context.sol
5 
6 pragma solidity ^0.6.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 contract Context {
19     // Empty internal constructor, to prevent people from mistakenly deploying
20     // an instance of this contract, which should be used via inheritance.
21     constructor () internal { }
22 
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
34 
35 pragma solidity ^0.6.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 // File: @openzeppelin/contracts/math/SafeMath.sol
112 
113 pragma solidity ^0.6.0;
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         // Solidity only automatically asserts when dividing by 0
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
244         return mod(a, b, "SafeMath: modulo by zero");
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts with custom message when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 pragma solidity ^0.6.2;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly { codehash := extcodehash(account) }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
320         (bool success, ) = recipient.call{ value: amount }("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
326 
327 pragma solidity ^0.6.0;
328 
329 
330 
331 
332 
333 /**
334  * @dev Implementation of the {IERC20} interface.
335  *
336  * This implementation is agnostic to the way tokens are created. This means
337  * that a supply mechanism has to be added in a derived contract using {_mint}.
338  * For a generic mechanism see {ERC20MinterPauser}.
339  *
340  * TIP: For a detailed writeup see our guide
341  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
342  * to implement supply mechanisms].
343  *
344  * We have followed general OpenZeppelin guidelines: functions revert instead
345  * of returning `false` on failure. This behavior is nonetheless conventional
346  * and does not conflict with the expectations of ERC20 applications.
347  *
348  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
349  * This allows applications to reconstruct the allowance for all accounts just
350  * by listening to said events. Other implementations of the EIP may not emit
351  * these events, as it isn't required by the specification.
352  *
353  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
354  * functions have been added to mitigate the well-known issues around setting
355  * allowances. See {IERC20-approve}.
356  */
357 contract ERC20 is Context, IERC20 {
358     using SafeMath for uint256;
359     using Address for address;
360 
361     mapping (address => uint256) private _balances;
362 
363     mapping (address => mapping (address => uint256)) private _allowances;
364 
365     uint256 private _totalSupply;
366 
367     string private _name;
368     string private _symbol;
369     uint8 private _decimals;
370 
371     /**
372      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
373      * a default value of 18.
374      *
375      * To select a different value for {decimals}, use {_setupDecimals}.
376      *
377      * All three of these values are immutable: they can only be set once during
378      * construction.
379      */
380     constructor (string memory name, string memory symbol) public {
381         _name = name;
382         _symbol = symbol;
383         _decimals = 18;
384     }
385 
386     /**
387      * @dev Returns the name of the token.
388      */
389     function name() public view returns (string memory) {
390         return _name;
391     }
392 
393     /**
394      * @dev Returns the symbol of the token, usually a shorter version of the
395      * name.
396      */
397     function symbol() public view returns (string memory) {
398         return _symbol;
399     }
400 
401     /**
402      * @dev Returns the number of decimals used to get its user representation.
403      * For example, if `decimals` equals `2`, a balance of `505` tokens should
404      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
405      *
406      * Tokens usually opt for a value of 18, imitating the relationship between
407      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
408      * called.
409      *
410      * NOTE: This information is only used for _display_ purposes: it in
411      * no way affects any of the arithmetic of the contract, including
412      * {IERC20-balanceOf} and {IERC20-transfer}.
413      */
414     function decimals() public view returns (uint8) {
415         return _decimals;
416     }
417 
418     /**
419      * @dev See {IERC20-totalSupply}.
420      */
421     function totalSupply() public view override returns (uint256) {
422         return _totalSupply;
423     }
424 
425     /**
426      * @dev See {IERC20-balanceOf}.
427      */
428     function balanceOf(address account) public view override returns (uint256) {
429         return _balances[account];
430     }
431 
432     /**
433      * @dev See {IERC20-transfer}.
434      *
435      * Requirements:
436      *
437      * - `recipient` cannot be the zero address.
438      * - the caller must have a balance of at least `amount`.
439      */
440     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
441         _transfer(_msgSender(), recipient, amount);
442         return true;
443     }
444 
445     /**
446      * @dev See {IERC20-allowance}.
447      */
448     function allowance(address owner, address spender) public view virtual override returns (uint256) {
449         return _allowances[owner][spender];
450     }
451 
452     /**
453      * @dev See {IERC20-approve}.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      */
459     function approve(address spender, uint256 amount) public virtual override returns (bool) {
460         _approve(_msgSender(), spender, amount);
461         return true;
462     }
463 
464     /**
465      * @dev See {IERC20-transferFrom}.
466      *
467      * Emits an {Approval} event indicating the updated allowance. This is not
468      * required by the EIP. See the note at the beginning of {ERC20};
469      *
470      * Requirements:
471      * - `sender` and `recipient` cannot be the zero address.
472      * - `sender` must have a balance of at least `amount`.
473      * - the caller must have allowance for ``sender``'s tokens of at least
474      * `amount`.
475      */
476     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
477         _transfer(sender, recipient, amount);
478         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
479         return true;
480     }
481 
482     /**
483      * @dev Atomically increases the allowance granted to `spender` by the caller.
484      *
485      * This is an alternative to {approve} that can be used as a mitigation for
486      * problems described in {IERC20-approve}.
487      *
488      * Emits an {Approval} event indicating the updated allowance.
489      *
490      * Requirements:
491      *
492      * - `spender` cannot be the zero address.
493      */
494     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
496         return true;
497     }
498 
499     /**
500      * @dev Atomically decreases the allowance granted to `spender` by the caller.
501      *
502      * This is an alternative to {approve} that can be used as a mitigation for
503      * problems described in {IERC20-approve}.
504      *
505      * Emits an {Approval} event indicating the updated allowance.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      * - `spender` must have allowance for the caller of at least
511      * `subtractedValue`.
512      */
513     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
514         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
515         return true;
516     }
517 
518     /**
519      * @dev Moves tokens `amount` from `sender` to `recipient`.
520      *
521      * This is internal function is equivalent to {transfer}, and can be used to
522      * e.g. implement automatic token fees, slashing mechanisms, etc.
523      *
524      * Emits a {Transfer} event.
525      *
526      * Requirements:
527      *
528      * - `sender` cannot be the zero address.
529      * - `recipient` cannot be the zero address.
530      * - `sender` must have a balance of at least `amount`.
531      */
532     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
533         require(sender != address(0), "ERC20: transfer from the zero address");
534         require(recipient != address(0), "ERC20: transfer to the zero address");
535 
536         _beforeTokenTransfer(sender, recipient, amount);
537 
538         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
539         _balances[recipient] = _balances[recipient].add(amount);
540         emit Transfer(sender, recipient, amount);
541     }
542 
543     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
544      * the total supply.
545      *
546      * Emits a {Transfer} event with `from` set to the zero address.
547      *
548      * Requirements
549      *
550      * - `to` cannot be the zero address.
551      */
552     function _mint(address account, uint256 amount) internal virtual {
553         require(account != address(0), "ERC20: mint to the zero address");
554 
555         _beforeTokenTransfer(address(0), account, amount);
556 
557         _totalSupply = _totalSupply.add(amount);
558         _balances[account] = _balances[account].add(amount);
559         emit Transfer(address(0), account, amount);
560     }
561 
562     /**
563      * @dev Destroys `amount` tokens from `account`, reducing the
564      * total supply.
565      *
566      * Emits a {Transfer} event with `to` set to the zero address.
567      *
568      * Requirements
569      *
570      * - `account` cannot be the zero address.
571      * - `account` must have at least `amount` tokens.
572      */
573     function _burn(address account, uint256 amount) internal virtual {
574         require(account != address(0), "ERC20: burn from the zero address");
575 
576         _beforeTokenTransfer(account, address(0), amount);
577 
578         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
579         _totalSupply = _totalSupply.sub(amount);
580         emit Transfer(account, address(0), amount);
581     }
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
585      *
586      * This is internal function is equivalent to `approve`, and can be used to
587      * e.g. set automatic allowances for certain subsystems, etc.
588      *
589      * Emits an {Approval} event.
590      *
591      * Requirements:
592      *
593      * - `owner` cannot be the zero address.
594      * - `spender` cannot be the zero address.
595      */
596     function _approve(address owner, address spender, uint256 amount) internal virtual {
597         require(owner != address(0), "ERC20: approve from the zero address");
598         require(spender != address(0), "ERC20: approve to the zero address");
599 
600         _allowances[owner][spender] = amount;
601         emit Approval(owner, spender, amount);
602     }
603 
604     /**
605      * @dev Sets {decimals} to a value other than the default one of 18.
606      *
607      * WARNING: This function should only be called from the constructor. Most
608      * applications that interact with token contracts will not expect
609      * {decimals} to ever change, and may work incorrectly if it does.
610      */
611     function _setupDecimals(uint8 decimals_) internal {
612         _decimals = decimals_;
613     }
614 
615     /**
616      * @dev Hook that is called before any transfer of tokens. This includes
617      * minting and burning.
618      *
619      * Calling conditions:
620      *
621      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
622      * will be to transferred to `to`.
623      * - when `from` is zero, `amount` tokens will be minted for `to`.
624      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
625      * - `from` and `to` are never both zero.
626      *
627      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
628      */
629     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
633 
634 pragma solidity ^0.6.0;
635 
636 
637 /**
638  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
639  */
640 abstract contract ERC20Capped is ERC20 {
641     uint256 private _cap;
642 
643     /**
644      * @dev Sets the value of the `cap`. This value is immutable, it can only be
645      * set once during construction.
646      */
647     constructor (uint256 cap) public {
648         require(cap > 0, "ERC20Capped: cap is 0");
649         _cap = cap;
650     }
651 
652     /**
653      * @dev Returns the cap on the token's total supply.
654      */
655     function cap() public view returns (uint256) {
656         return _cap;
657     }
658 
659     /**
660      * @dev See {ERC20-_beforeTokenTransfer}.
661      *
662      * Requirements:
663      *
664      * - minted tokens must not cause the total supply to go over the cap.
665      */
666     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
667         super._beforeTokenTransfer(from, to, amount);
668 
669         if (from == address(0)) { // When minting tokens
670             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
671         }
672     }
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
676 
677 pragma solidity ^0.6.0;
678 
679 
680 
681 /**
682  * @dev Extension of {ERC20} that allows token holders to destroy both their own
683  * tokens and those that they have an allowance for, in a way that can be
684  * recognized off-chain (via event analysis).
685  */
686 abstract contract ERC20Burnable is Context, ERC20 {
687     /**
688      * @dev Destroys `amount` tokens from the caller.
689      *
690      * See {ERC20-_burn}.
691      */
692     function burn(uint256 amount) public virtual {
693         _burn(_msgSender(), amount);
694     }
695 
696     /**
697      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
698      * allowance.
699      *
700      * See {ERC20-_burn} and {ERC20-allowance}.
701      *
702      * Requirements:
703      *
704      * - the caller must have allowance for ``accounts``'s tokens of at least
705      * `amount`.
706      */
707     function burnFrom(address account, uint256 amount) public virtual {
708         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
709 
710         _approve(account, _msgSender(), decreasedAllowance);
711         _burn(account, amount);
712     }
713 }
714 
715 // File: @openzeppelin/contracts/introspection/IERC165.sol
716 
717 pragma solidity ^0.6.0;
718 
719 /**
720  * @dev Interface of the ERC165 standard, as defined in the
721  * https://eips.ethereum.org/EIPS/eip-165[EIP].
722  *
723  * Implementers can declare support of contract interfaces, which can then be
724  * queried by others ({ERC165Checker}).
725  *
726  * For an implementation, see {ERC165}.
727  */
728 interface IERC165 {
729     /**
730      * @dev Returns true if this contract implements the interface defined by
731      * `interfaceId`. See the corresponding
732      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
733      * to learn more about how these ids are created.
734      *
735      * This function call must use less than 30 000 gas.
736      */
737     function supportsInterface(bytes4 interfaceId) external view returns (bool);
738 }
739 
740 
741 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
742 
743 pragma solidity ^0.6.2;
744 
745 /**
746  * @dev Library used to query support of an interface declared via {IERC165}.
747  *
748  * Note that these functions return the actual result of the query: they do not
749  * `revert` if an interface is not supported. It is up to the caller to decide
750  * what to do in these cases.
751  */
752 library ERC165Checker {
753     // As per the EIP-165 spec, no interface should ever match 0xffffffff
754     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
755 
756     /*
757      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
758      */
759     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
760 
761     /**
762      * @dev Returns true if `account` supports the {IERC165} interface,
763      */
764     function supportsERC165(address account) internal view returns (bool) {
765         // Any contract that implements ERC165 must explicitly indicate support of
766         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
767         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
768             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
769     }
770 
771     /**
772      * @dev Returns true if `account` supports the interface defined by
773      * `interfaceId`. Support for {IERC165} itself is queried automatically.
774      *
775      * See {IERC165-supportsInterface}.
776      */
777     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
778         // query support of both ERC165 as per the spec and support of _interfaceId
779         return supportsERC165(account) &&
780             _supportsERC165Interface(account, interfaceId);
781     }
782 
783     /**
784      * @dev Returns true if `account` supports all the interfaces defined in
785      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
786      *
787      * Batch-querying can lead to gas savings by skipping repeated checks for
788      * {IERC165} support.
789      *
790      * See {IERC165-supportsInterface}.
791      */
792     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
793         // query support of ERC165 itself
794         if (!supportsERC165(account)) {
795             return false;
796         }
797 
798         // query support of each interface in _interfaceIds
799         for (uint256 i = 0; i < interfaceIds.length; i++) {
800             if (!_supportsERC165Interface(account, interfaceIds[i])) {
801                 return false;
802             }
803         }
804 
805         // all interfaces supported
806         return true;
807     }
808 
809     /**
810      * @notice Query if a contract implements an interface, does not check ERC165 support
811      * @param account The address of the contract to query for support of an interface
812      * @param interfaceId The interface identifier, as specified in ERC-165
813      * @return true if the contract at account indicates support of the interface with
814      * identifier interfaceId, false otherwise
815      * @dev Assumes that account contains a contract that supports ERC165, otherwise
816      * the behavior of this method is undefined. This precondition can be checked
817      * with {supportsERC165}.
818      * Interface identification is specified in ERC-165.
819      */
820     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
821         // success determines whether the staticcall succeeded and result determines
822         // whether the contract at account indicates support of _interfaceId
823         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
824 
825         return (success && result);
826     }
827 
828     /**
829      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
830      * @param account The address of the contract to query for support of an interface
831      * @param interfaceId The interface identifier, as specified in ERC-165
832      * @return success true if the STATICCALL succeeded, false otherwise
833      * @return result true if the STATICCALL succeeded and the contract at account
834      * indicates support of the interface with identifier interfaceId, false otherwise
835      */
836     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
837         private
838         view
839         returns (bool, bool)
840     {
841         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
842         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
843         if (result.length < 32) return (false, false);
844         return (success, abi.decode(result, (bool)));
845     }
846 }
847 
848 // File: @openzeppelin/contracts/introspection/ERC165.sol
849 
850 pragma solidity ^0.6.0;
851 
852 
853 /**
854  * @dev Implementation of the {IERC165} interface.
855  *
856  * Contracts may inherit from this and call {_registerInterface} to declare
857  * their support of an interface.
858  */
859 contract ERC165 is IERC165 {
860     /*
861      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
862      */
863     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
864 
865     /**
866      * @dev Mapping of interface ids to whether or not it's supported.
867      */
868     mapping(bytes4 => bool) private _supportedInterfaces;
869 
870     constructor () internal {
871         // Derived contracts need only register support for their own interfaces,
872         // we register support for ERC165 itself here
873         _registerInterface(_INTERFACE_ID_ERC165);
874     }
875 
876     /**
877      * @dev See {IERC165-supportsInterface}.
878      *
879      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
880      */
881     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
882         return _supportedInterfaces[interfaceId];
883     }
884 
885     /**
886      * @dev Registers the contract as an implementer of the interface defined by
887      * `interfaceId`. Support of the actual ERC165 interface is automatic and
888      * registering its interface id is not required.
889      *
890      * See {IERC165-supportsInterface}.
891      *
892      * Requirements:
893      *
894      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
895      */
896     function _registerInterface(bytes4 interfaceId) internal virtual {
897         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
898         _supportedInterfaces[interfaceId] = true;
899     }
900 }
901 
902 // File: @openzeppelin/contracts/access/Ownable.sol
903 
904 pragma solidity ^0.6.0;
905 
906 /**
907  * @dev Contract module which provides a basic access control mechanism, where
908  * there is an account (an owner) that can be granted exclusive access to
909  * specific functions.
910  *
911  * By default, the owner account will be the one that deploys the contract. This
912  * can later be changed with {transferOwnership}.
913  *
914  * This module is used through inheritance. It will make available the modifier
915  * `onlyOwner`, which can be applied to your functions to restrict their use to
916  * the owner.
917  */
918 contract Ownable is Context {
919     address private _owner;
920 
921     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
922 
923     /**
924      * @dev Initializes the contract setting the deployer as the initial owner.
925      */
926     constructor () internal {
927         address msgSender = _msgSender();
928         _owner = msgSender;
929         emit OwnershipTransferred(address(0), msgSender);
930     }
931 
932     /**
933      * @dev Returns the address of the current owner.
934      */
935     function owner() public view returns (address) {
936         return _owner;
937     }
938 
939     /**
940      * @dev Throws if called by any account other than the owner.
941      */
942     modifier onlyOwner() {
943         require(_owner == _msgSender(), "Ownable: caller is not the owner");
944         _;
945     }
946 
947     /**
948      * @dev Leaves the contract without owner. It will not be possible to call
949      * `onlyOwner` functions anymore. Can only be called by the current owner.
950      *
951      * NOTE: Renouncing ownership will leave the contract without an owner,
952      * thereby removing any functionality that is only available to the owner.
953      */
954     function renounceOwnership() public virtual onlyOwner {
955         emit OwnershipTransferred(_owner, address(0));
956         _owner = address(0);
957     }
958 
959     /**
960      * @dev Transfers ownership of the contract to a new account (`newOwner`).
961      * Can only be called by the current owner.
962      */
963     function transferOwnership(address newOwner) public virtual onlyOwner {
964         require(newOwner != address(0), "Ownable: new owner is the zero address");
965         emit OwnershipTransferred(_owner, newOwner);
966         _owner = newOwner;
967     }
968 }
969 
970 // File: eth-token-recover/contracts/TokenRecover.sol
971 
972 pragma solidity ^0.6.0;
973 
974 
975 
976 /**
977  * @title TokenRecover
978  * @author Vittorio Minacori (https://github.com/vittominacori)
979  * @dev Allow to recover any ERC20 sent into the contract for error
980  */
981 contract TokenRecover is Ownable {
982 
983     /**
984      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
985      * @param tokenAddress The token contract address
986      * @param tokenAmount Number of tokens to be sent
987      */
988     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
989         IERC20(tokenAddress).transfer(owner(), tokenAmount);
990     }
991 }
992 
993 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
994 
995 pragma solidity ^0.6.0;
996 
997 /**
998  * @dev Library for managing
999  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1000  * types.
1001  *
1002  * Sets have the following properties:
1003  *
1004  * - Elements are added, removed, and checked for existence in constant time
1005  * (O(1)).
1006  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1007  *
1008  * ```
1009  * contract Example {
1010  *     // Add the library methods
1011  *     using EnumerableSet for EnumerableSet.AddressSet;
1012  *
1013  *     // Declare a set state variable
1014  *     EnumerableSet.AddressSet private mySet;
1015  * }
1016  * ```
1017  *
1018  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1019  * (`UintSet`) are supported.
1020  */
1021 library EnumerableSet {
1022     // To implement this library for multiple types with as little code
1023     // repetition as possible, we write it in terms of a generic Set type with
1024     // bytes32 values.
1025     // The Set implementation uses private functions, and user-facing
1026     // implementations (such as AddressSet) are just wrappers around the
1027     // underlying Set.
1028     // This means that we can only create new EnumerableSets for types that fit
1029     // in bytes32.
1030 
1031     struct Set {
1032         // Storage of set values
1033         bytes32[] _values;
1034 
1035         // Position of the value in the `values` array, plus 1 because index 0
1036         // means a value is not in the set.
1037         mapping (bytes32 => uint256) _indexes;
1038     }
1039 
1040     /**
1041      * @dev Add a value to a set. O(1).
1042      *
1043      * Returns true if the value was added to the set, that is if it was not
1044      * already present.
1045      */
1046     function _add(Set storage set, bytes32 value) private returns (bool) {
1047         if (!_contains(set, value)) {
1048             set._values.push(value);
1049             // The value is stored at length-1, but we add 1 to all indexes
1050             // and use 0 as a sentinel value
1051             set._indexes[value] = set._values.length;
1052             return true;
1053         } else {
1054             return false;
1055         }
1056     }
1057 
1058     /**
1059      * @dev Removes a value from a set. O(1).
1060      *
1061      * Returns true if the value was removed from the set, that is if it was
1062      * present.
1063      */
1064     function _remove(Set storage set, bytes32 value) private returns (bool) {
1065         // We read and store the value's index to prevent multiple reads from the same storage slot
1066         uint256 valueIndex = set._indexes[value];
1067 
1068         if (valueIndex != 0) { // Equivalent to contains(set, value)
1069             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1070             // the array, and then remove the last element (sometimes called as 'swap and pop').
1071             // This modifies the order of the array, as noted in {at}.
1072 
1073             uint256 toDeleteIndex = valueIndex - 1;
1074             uint256 lastIndex = set._values.length - 1;
1075 
1076             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1077             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1078 
1079             bytes32 lastvalue = set._values[lastIndex];
1080 
1081             // Move the last value to the index where the value to delete is
1082             set._values[toDeleteIndex] = lastvalue;
1083             // Update the index for the moved value
1084             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1085 
1086             // Delete the slot where the moved value was stored
1087             set._values.pop();
1088 
1089             // Delete the index for the deleted slot
1090             delete set._indexes[value];
1091 
1092             return true;
1093         } else {
1094             return false;
1095         }
1096     }
1097 
1098     /**
1099      * @dev Returns true if the value is in the set. O(1).
1100      */
1101     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1102         return set._indexes[value] != 0;
1103     }
1104 
1105     /**
1106      * @dev Returns the number of values on the set. O(1).
1107      */
1108     function _length(Set storage set) private view returns (uint256) {
1109         return set._values.length;
1110     }
1111 
1112    /**
1113     * @dev Returns the value stored at position `index` in the set. O(1).
1114     *
1115     * Note that there are no guarantees on the ordering of values inside the
1116     * array, and it may change when more values are added or removed.
1117     *
1118     * Requirements:
1119     *
1120     * - `index` must be strictly less than {length}.
1121     */
1122     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1123         require(set._values.length > index, "EnumerableSet: index out of bounds");
1124         return set._values[index];
1125     }
1126 
1127     // AddressSet
1128 
1129     struct AddressSet {
1130         Set _inner;
1131     }
1132 
1133     /**
1134      * @dev Add a value to a set. O(1).
1135      *
1136      * Returns true if the value was added to the set, that is if it was not
1137      * already present.
1138      */
1139     function add(AddressSet storage set, address value) internal returns (bool) {
1140         return _add(set._inner, bytes32(uint256(value)));
1141     }
1142 
1143     /**
1144      * @dev Removes a value from a set. O(1).
1145      *
1146      * Returns true if the value was removed from the set, that is if it was
1147      * present.
1148      */
1149     function remove(AddressSet storage set, address value) internal returns (bool) {
1150         return _remove(set._inner, bytes32(uint256(value)));
1151     }
1152 
1153     /**
1154      * @dev Returns true if the value is in the set. O(1).
1155      */
1156     function contains(AddressSet storage set, address value) internal view returns (bool) {
1157         return _contains(set._inner, bytes32(uint256(value)));
1158     }
1159 
1160     /**
1161      * @dev Returns the number of values in the set. O(1).
1162      */
1163     function length(AddressSet storage set) internal view returns (uint256) {
1164         return _length(set._inner);
1165     }
1166 
1167    /**
1168     * @dev Returns the value stored at position `index` in the set. O(1).
1169     *
1170     * Note that there are no guarantees on the ordering of values inside the
1171     * array, and it may change when more values are added or removed.
1172     *
1173     * Requirements:
1174     *
1175     * - `index` must be strictly less than {length}.
1176     */
1177     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1178         return address(uint256(_at(set._inner, index)));
1179     }
1180 
1181 
1182     // UintSet
1183 
1184     struct UintSet {
1185         Set _inner;
1186     }
1187 
1188     /**
1189      * @dev Add a value to a set. O(1).
1190      *
1191      * Returns true if the value was added to the set, that is if it was not
1192      * already present.
1193      */
1194     function add(UintSet storage set, uint256 value) internal returns (bool) {
1195         return _add(set._inner, bytes32(value));
1196     }
1197 
1198     /**
1199      * @dev Removes a value from a set. O(1).
1200      *
1201      * Returns true if the value was removed from the set, that is if it was
1202      * present.
1203      */
1204     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1205         return _remove(set._inner, bytes32(value));
1206     }
1207 
1208     /**
1209      * @dev Returns true if the value is in the set. O(1).
1210      */
1211     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1212         return _contains(set._inner, bytes32(value));
1213     }
1214 
1215     /**
1216      * @dev Returns the number of values on the set. O(1).
1217      */
1218     function length(UintSet storage set) internal view returns (uint256) {
1219         return _length(set._inner);
1220     }
1221 
1222    /**
1223     * @dev Returns the value stored at position `index` in the set. O(1).
1224     *
1225     * Note that there are no guarantees on the ordering of values inside the
1226     * array, and it may change when more values are added or removed.
1227     *
1228     * Requirements:
1229     *
1230     * - `index` must be strictly less than {length}.
1231     */
1232     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1233         return uint256(_at(set._inner, index));
1234     }
1235 }
1236 
1237 // File: @openzeppelin/contracts/access/AccessControl.sol
1238 
1239 pragma solidity ^0.6.0;
1240 
1241 
1242 
1243 
1244 /**
1245  * @dev Contract module that allows children to implement role-based access
1246  * control mechanisms.
1247  *
1248  * Roles are referred to by their `bytes32` identifier. These should be exposed
1249  * in the external API and be unique. The best way to achieve this is by
1250  * using `public constant` hash digests:
1251  *
1252  * ```
1253  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1254  * ```
1255  *
1256  * Roles can be used to represent a set of permissions. To restrict access to a
1257  * function call, use {hasRole}:
1258  *
1259  * ```
1260  * function foo() public {
1261  *     require(hasRole(MY_ROLE, _msgSender()));
1262  *     ...
1263  * }
1264  * ```
1265  *
1266  * Roles can be granted and revoked dynamically via the {grantRole} and
1267  * {revokeRole} functions. Each role has an associated admin role, and only
1268  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1269  *
1270  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1271  * that only accounts with this role will be able to grant or revoke other
1272  * roles. More complex role relationships can be created by using
1273  * {_setRoleAdmin}.
1274  */
1275 abstract contract AccessControl is Context {
1276     using EnumerableSet for EnumerableSet.AddressSet;
1277     using Address for address;
1278 
1279     struct RoleData {
1280         EnumerableSet.AddressSet members;
1281         bytes32 adminRole;
1282     }
1283 
1284     mapping (bytes32 => RoleData) private _roles;
1285 
1286     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1287 
1288     /**
1289      * @dev Emitted when `account` is granted `role`.
1290      *
1291      * `sender` is the account that originated the contract call, an admin role
1292      * bearer except when using {_setupRole}.
1293      */
1294     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1295 
1296     /**
1297      * @dev Emitted when `account` is revoked `role`.
1298      *
1299      * `sender` is the account that originated the contract call:
1300      *   - if using `revokeRole`, it is the admin role bearer
1301      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1302      */
1303     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1304 
1305     /**
1306      * @dev Returns `true` if `account` has been granted `role`.
1307      */
1308     function hasRole(bytes32 role, address account) public view returns (bool) {
1309         return _roles[role].members.contains(account);
1310     }
1311 
1312     /**
1313      * @dev Returns the number of accounts that have `role`. Can be used
1314      * together with {getRoleMember} to enumerate all bearers of a role.
1315      */
1316     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1317         return _roles[role].members.length();
1318     }
1319 
1320     /**
1321      * @dev Returns one of the accounts that have `role`. `index` must be a
1322      * value between 0 and {getRoleMemberCount}, non-inclusive.
1323      *
1324      * Role bearers are not sorted in any particular way, and their ordering may
1325      * change at any point.
1326      *
1327      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1328      * you perform all queries on the same block. See the following
1329      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1330      * for more information.
1331      */
1332     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1333         return _roles[role].members.at(index);
1334     }
1335 
1336     /**
1337      * @dev Returns the admin role that controls `role`. See {grantRole} and
1338      * {revokeRole}.
1339      *
1340      * To change a role's admin, use {_setRoleAdmin}.
1341      */
1342     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1343         return _roles[role].adminRole;
1344     }
1345 
1346     /**
1347      * @dev Grants `role` to `account`.
1348      *
1349      * If `account` had not been already granted `role`, emits a {RoleGranted}
1350      * event.
1351      *
1352      * Requirements:
1353      *
1354      * - the caller must have ``role``'s admin role.
1355      */
1356     function grantRole(bytes32 role, address account) public virtual {
1357         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1358 
1359         _grantRole(role, account);
1360     }
1361 
1362     /**
1363      * @dev Revokes `role` from `account`.
1364      *
1365      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1366      *
1367      * Requirements:
1368      *
1369      * - the caller must have ``role``'s admin role.
1370      */
1371     function revokeRole(bytes32 role, address account) public virtual {
1372         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1373 
1374         _revokeRole(role, account);
1375     }
1376 
1377     /**
1378      * @dev Revokes `role` from the calling account.
1379      *
1380      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1381      * purpose is to provide a mechanism for accounts to lose their privileges
1382      * if they are compromised (such as when a trusted device is misplaced).
1383      *
1384      * If the calling account had been granted `role`, emits a {RoleRevoked}
1385      * event.
1386      *
1387      * Requirements:
1388      *
1389      * - the caller must be `account`.
1390      */
1391     function renounceRole(bytes32 role, address account) public virtual {
1392         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1393 
1394         _revokeRole(role, account);
1395     }
1396 
1397     /**
1398      * @dev Grants `role` to `account`.
1399      *
1400      * If `account` had not been already granted `role`, emits a {RoleGranted}
1401      * event. Note that unlike {grantRole}, this function doesn't perform any
1402      * checks on the calling account.
1403      *
1404      * [WARNING]
1405      * ====
1406      * This function should only be called from the constructor when setting
1407      * up the initial roles for the system.
1408      *
1409      * Using this function in any other way is effectively circumventing the admin
1410      * system imposed by {AccessControl}.
1411      * ====
1412      */
1413     function _setupRole(bytes32 role, address account) internal virtual {
1414         _grantRole(role, account);
1415     }
1416 
1417     /**
1418      * @dev Sets `adminRole` as ``role``'s admin role.
1419      */
1420     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1421         _roles[role].adminRole = adminRole;
1422     }
1423 
1424     function _grantRole(bytes32 role, address account) private {
1425         if (_roles[role].members.add(account)) {
1426             emit RoleGranted(role, account, _msgSender());
1427         }
1428     }
1429 
1430     function _revokeRole(bytes32 role, address account) private {
1431         if (_roles[role].members.remove(account)) {
1432             emit RoleRevoked(role, account, _msgSender());
1433         }
1434     }
1435 }
1436 
1437 // File: contracts/access/Roles.sol
1438 
1439 pragma solidity ^0.6.0;
1440 
1441 
1442 contract Roles is AccessControl {
1443 
1444     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1445     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1446 
1447     constructor () public {
1448         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1449         _setupRole(MINTER_ROLE, _msgSender());
1450         _setupRole(OPERATOR_ROLE, _msgSender());
1451     }
1452 
1453     modifier onlyMinter() {
1454         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1455         _;
1456     }
1457 
1458     modifier onlyOperator() {
1459         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1460         _;
1461     }
1462 }
1463 
1464 // File: contracts/TrenderingYield.sol
1465 
1466 pragma solidity ^0.6.0;
1467 
1468 
1469 
1470 
1471 
1472 
1473 /**
1474  * @title TrenderingYield
1475  * @author C based on source by https://github.com/vittominacori
1476  * @dev Implementation of the TrenderingYield
1477  */
1478 contract TrenderingYield is ERC20Capped, ERC20Burnable, Roles, TokenRecover {
1479 
1480     // indicates if minting is finished
1481     bool private _mintingFinished = false;
1482 
1483     // indicates if transfer is enabled
1484     bool private _transferEnabled = false;
1485 
1486     string public constant BUILT_ON = "context-machine: trendering.org";
1487 
1488     /**
1489      * @dev Emitted during finish minting
1490      */
1491     event MintFinished();
1492 
1493     /**
1494      * @dev Emitted during transfer enabling
1495      */
1496     event TransferEnabled();
1497 
1498     /**
1499      * @dev Tokens can be minted only before minting finished.
1500      */
1501     modifier canMint() {
1502         require(!_mintingFinished, "TrenderingYield: minting is finished");
1503         _;
1504     }
1505 
1506     /**
1507      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1508      */
1509     modifier canTransfer(address from) {
1510         require(
1511             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1512             "TrenderingYield: transfer is not enabled or from does not have the OPERATOR role"
1513         );
1514         _;
1515     }
1516 
1517     /**
1518      * @param name Name of the token
1519      * @param symbol A symbol to be used as ticker
1520      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1521      * @param cap Maximum number of tokens mintable
1522      * @param initialSupply Initial token supply
1523      * @param transferEnabled If transfer is enabled on token creation
1524      * @param mintingFinished If minting is finished after token creation
1525      */
1526     constructor(
1527         string memory name,
1528         string memory symbol,
1529         uint8 decimals,
1530         uint256 cap,
1531         uint256 initialSupply,
1532         bool transferEnabled,
1533         bool mintingFinished
1534     )
1535         public
1536         ERC20Capped(cap)
1537         ERC20(name, symbol)
1538     {
1539         require(
1540             mintingFinished == false || cap == initialSupply,
1541             "TrenderingYield: if finish minting, cap must be equal to initialSupply"
1542         );
1543 
1544         _setupDecimals(decimals);
1545 
1546         if (initialSupply > 0) {
1547             _mint(owner(), initialSupply);
1548         }
1549 
1550         if (mintingFinished) {
1551             finishMinting();
1552         }
1553 
1554         if (transferEnabled) {
1555             enableTransfer();
1556         }
1557     }
1558 
1559     /**
1560      * @return if minting is finished or not.
1561      */
1562     function mintingFinished() public view returns (bool) {
1563         return _mintingFinished;
1564     }
1565 
1566     /**
1567      * @return if transfer is enabled or not.
1568      */
1569     function transferEnabled() public view returns (bool) {
1570         return _transferEnabled;
1571     }
1572 
1573     /**
1574      * @dev Function to mint tokens.
1575      * @param to The address that will receive the minted tokens
1576      * @param value The amount of tokens to mint
1577      */
1578     function mint(address to, uint256 value) public canMint onlyMinter {
1579         _mint(to, value);
1580     }
1581 
1582     /**
1583      * @dev Transfer tokens to a specified address.
1584      * @param to The address to transfer to
1585      * @param value The amount to be transferred
1586      * @return A boolean that indicates if the operation was successful.
1587      */
1588     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
1589         return super.transfer(to, value);
1590     }
1591 
1592     /**
1593      * @dev Transfer tokens from one address to another.
1594      * @param from The address which you want to send tokens from
1595      * @param to The address which you want to transfer to
1596      * @param value the amount of tokens to be transferred
1597      * @return A boolean that indicates if the operation was successful.
1598      */
1599     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
1600         return super.transferFrom(from, to, value);
1601     }
1602 
1603     /**
1604      * @dev Function to stop minting new tokens.
1605      */
1606     function finishMinting() public canMint onlyOwner {
1607         _mintingFinished = true;
1608 
1609         emit MintFinished();
1610     }
1611 
1612     /**
1613      * @dev Function to enable transfers.
1614      */
1615     function enableTransfer() public onlyOwner {
1616         _transferEnabled = true;
1617 
1618         emit TransferEnabled();
1619     }
1620 
1621     /**
1622      * @dev See {ERC20-_beforeTokenTransfer}.
1623      */
1624     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1625         super._beforeTokenTransfer(from, to, amount);
1626     }
1627 }