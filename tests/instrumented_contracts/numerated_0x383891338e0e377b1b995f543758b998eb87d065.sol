1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.9;
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
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 /**
28  * @dev Wrappers over Solidity's arithmetic operations with added overflow
29  * checks.
30  *
31  * Arithmetic operations in Solidity wrap on overflow. This can easily result
32  * in bugs, because programmers usually assume that an overflow raises an
33  * error, which is the standard behavior in high level programming languages.
34  * `SafeMath` restores this intuition by reverting the transaction when an
35  * operation overflows.
36  *
37  * Using this library instead of the unchecked operations eliminates an entire
38  * class of bugs, so it's recommended to use it always.
39  */
40 library SafeMath {
41     /**
42      * @dev Returns the addition of two unsigned integers, reverting on
43      * overflow.
44      *
45      * Counterpart to Solidity's `+` operator.
46      *
47      * Requirements:
48      *
49      * - Addition cannot overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      *
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      *
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b <= a, errorMessage);
84         uint256 c = a - b;
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the multiplication of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `*` operator.
94      *
95      * Requirements:
96      *
97      * - Multiplication cannot overflow.
98      */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101         // benefit is lost if 'b' is also tested.
102         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b > 0, errorMessage);
143         uint256 c = a / b;
144         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * Reverts when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return mod(a, b, "SafeMath: modulo by zero");
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts with custom message when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b != 0, errorMessage);
179         return a % b;
180     }
181 }
182 
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP.
186  */
187 interface IERC20 {
188     /**
189      * @dev Returns the amount of tokens in existence.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns the amount of tokens owned by `account`.
195      */
196     function balanceOf(address account) external view returns (uint256);
197 
198     /**
199      * @dev Moves `amount` tokens from the caller's account to `recipient`.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transfer(address recipient, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Returns the remaining number of tokens that `spender` will be
209      * allowed to spend on behalf of `owner` through {transferFrom}. This is
210      * zero by default.
211      *
212      * This value changes when {approve} or {transferFrom} are called.
213      */
214     function allowance(address owner, address spender) external view returns (uint256);
215 
216     /**
217      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * IMPORTANT: Beware that changing an allowance with this method brings the risk
222      * that someone may use both the old and the new allowance by unfortunate
223      * transaction ordering. One possible solution to mitigate this race
224      * condition is to first reduce the spender's allowance to 0 and set the
225      * desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address spender, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Moves `amount` tokens from `sender` to `recipient` using the
234      * allowance mechanism. `amount` is then deducted from the caller's
235      * allowance.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20MinterPauser}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * We have followed general OpenZeppelin guidelines: functions revert instead
271  * of returning `false` on failure. This behavior is nonetheless conventional
272  * and does not conflict with the expectations of ERC20 applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20 {
284     using SafeMath for uint256;
285     using Address for address;
286 
287     mapping (address => uint256) private _balances;
288 
289     mapping (address => mapping (address => uint256)) private _allowances;
290 
291     uint256 private _totalSupply;
292 
293     string private _name;
294     string private _symbol;
295     uint8 private _decimals;
296 
297     /**
298      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
299      * a default value of 18.
300      *
301      * To select a different value for {decimals}, use {_setupDecimals}.
302      *
303      * All three of these values are immutable: they can only be set once during
304      * construction.
305      */
306     constructor (string memory name, string memory symbol) public {
307         _name = name;
308         _symbol = symbol;
309         _decimals = 18;
310     }
311 
312     /**
313      * @dev Returns the name of the token.
314      */
315     function name() public view returns (string memory) {
316         return _name;
317     }
318 
319     /**
320      * @dev Returns the symbol of the token, usually a shorter version of the
321      * name.
322      */
323     function symbol() public view returns (string memory) {
324         return _symbol;
325     }
326 
327     /**
328      * @dev Returns the number of decimals used to get its user representation.
329      * For example, if `decimals` equals `2`, a balance of `505` tokens should
330      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
331      *
332      * Tokens usually opt for a value of 18, imitating the relationship between
333      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
334      * called.
335      *
336      * NOTE: This information is only used for _display_ purposes: it in
337      * no way affects any of the arithmetic of the contract, including
338      * {IERC20-balanceOf} and {IERC20-transfer}.
339      */
340     function decimals() public view returns (uint8) {
341         return _decimals;
342     }
343 
344     /**
345      * @dev See {IERC20-totalSupply}.
346      */
347     function totalSupply() public view override returns (uint256) {
348         return _totalSupply;
349     }
350 
351     /**
352      * @dev See {IERC20-balanceOf}.
353      */
354     function balanceOf(address account) public view override returns (uint256) {
355         return _balances[account];
356     }
357 
358     /**
359      * @dev See {IERC20-transfer}.
360      *
361      * Requirements:
362      *
363      * - `recipient` cannot be the zero address.
364      * - the caller must have a balance of at least `amount`.
365      */
366     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
367         _transfer(_msgSender(), recipient, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-allowance}.
373      */
374     function allowance(address owner, address spender) public view virtual override returns (uint256) {
375         return _allowances[owner][spender];
376     }
377 
378     /**
379      * @dev See {IERC20-approve}.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function approve(address spender, uint256 amount) public virtual override returns (bool) {
386         _approve(_msgSender(), spender, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-transferFrom}.
392      *
393      * Emits an {Approval} event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of {ERC20};
395      *
396      * Requirements:
397      * - `sender` and `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      * - the caller must have allowance for ``sender``'s tokens of at least
400      * `amount`.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
403         _transfer(sender, recipient, amount);
404         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
405         return true;
406     }
407 
408     /**
409      * @dev Atomically increases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      */
420     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
421         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
422         return true;
423     }
424 
425     /**
426      * @dev Atomically decreases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      * - `spender` must have allowance for the caller of at least
437      * `subtractedValue`.
438      */
439     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
441         return true;
442     }
443 
444     /**
445      * @dev Moves tokens `amount` from `sender` to `recipient`.
446      *
447      * This is internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `sender` cannot be the zero address.
455      * - `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      */
458     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(sender, recipient, amount);
463 
464         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
465         _balances[recipient] = _balances[recipient].add(amount);
466         emit Transfer(sender, recipient, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements
475      *
476      * - `to` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply = _totalSupply.add(amount);
484         _balances[account] = _balances[account].add(amount);
485         emit Transfer(address(0), account, amount);
486     }
487 
488     /**
489      * @dev Destroys `amount` tokens from `account`, reducing the
490      * total supply.
491      *
492      * Emits a {Transfer} event with `to` set to the zero address.
493      *
494      * Requirements
495      *
496      * - `account` cannot be the zero address.
497      * - `account` must have at least `amount` tokens.
498      */
499     function _burn(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: burn from the zero address");
501 
502         _beforeTokenTransfer(account, address(0), amount);
503 
504         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
505         _totalSupply = _totalSupply.sub(amount);
506         emit Transfer(account, address(0), amount);
507     }
508 
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
511      *
512      * This is internal function is equivalent to `approve`, and can be used to
513      * e.g. set automatic allowances for certain subsystems, etc.
514      *
515      * Emits an {Approval} event.
516      *
517      * Requirements:
518      *
519      * - `owner` cannot be the zero address.
520      * - `spender` cannot be the zero address.
521      */
522     function _approve(address owner, address spender, uint256 amount) internal virtual {
523         require(owner != address(0), "ERC20: approve from the zero address");
524         require(spender != address(0), "ERC20: approve to the zero address");
525 
526         _allowances[owner][spender] = amount;
527         emit Approval(owner, spender, amount);
528     }
529 
530     /**
531      * @dev Sets {decimals} to a value other than the default one of 18.
532      *
533      * WARNING: This function should only be called from the constructor. Most
534      * applications that interact with token contracts will not expect
535      * {decimals} to ever change, and may work incorrectly if it does.
536      */
537     function _setupDecimals(uint8 decimals_) internal {
538         _decimals = decimals_;
539     }
540 
541     /**
542      * @dev Hook that is called before any transfer of tokens. This includes
543      * minting and burning.
544      *
545      * Calling conditions:
546      *
547      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
548      * will be to transferred to `to`.
549      * - when `from` is zero, `amount` tokens will be minted for `to`.
550      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
551      * - `from` and `to` are never both zero.
552      *
553      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
554      */
555     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
556 }
557 
558 
559 
560 /**
561  * @dev Contract module which allows children to implement an emergency stop
562  * mechanism that can be triggered by an authorized account.
563  *
564  * This module is used through inheritance. It will make available the
565  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
566  * the functions of your contract. Note that they will not be pausable by
567  * simply including this module, only once the modifiers are put in place.
568  */
569 contract Pausable is Context {
570     /**
571      * @dev Emitted when the pause is triggered by `account`.
572      */
573     event Paused(address account);
574 
575     /**
576      * @dev Emitted when the pause is lifted by `account`.
577      */
578     event Unpaused(address account);
579 
580     bool private _paused;
581 
582     /**
583      * @dev Initializes the contract in unpaused state.
584      */
585     constructor () internal {
586         _paused = false;
587     }
588 
589     /**
590      * @dev Returns true if the contract is paused, and false otherwise.
591      */
592     function paused() public view returns (bool) {
593         return _paused;
594     }
595 
596     /**
597      * @dev Modifier to make a function callable only when the contract is not paused.
598      *
599      * Requirements:
600      *
601      * - The contract must not be paused.
602      */
603     modifier whenNotPaused() {
604         require(!_paused, "Pausable: paused");
605         _;
606     }
607 
608     /**
609      * @dev Modifier to make a function callable only when the contract is paused.
610      *
611      * Requirements:
612      *
613      * - The contract must be paused.
614      */
615     modifier whenPaused() {
616         require(_paused, "Pausable: not paused");
617         _;
618     }
619 
620     /**
621      * @dev Triggers stopped state.
622      *
623      * Requirements:
624      *
625      * - The contract must not be paused.
626      */
627     function _pause() internal virtual whenNotPaused {
628         _paused = true;
629         emit Paused(_msgSender());
630     }
631 
632     /**
633      * @dev Returns to normal state.
634      *
635      * Requirements:
636      *
637      * - The contract must be paused.
638      */
639     function _unpause() internal virtual whenPaused {
640         _paused = false;
641         emit Unpaused(_msgSender());
642     }
643 }
644 
645 
646 /**
647  * @dev ERC20 token with pausable token transfers, minting and burning.
648  *
649  * Useful for scenarios such as preventing trades until the end of an evaluation
650  * period, or having an emergency switch for freezing all token transfers in the
651  * event of a large bug.
652  */
653 abstract contract ERC20Pausable is ERC20, Pausable {
654     /**
655      * @dev See {ERC20-_beforeTokenTransfer}.
656      *
657      * Requirements:
658      *
659      * - the contract must not be paused.
660      */
661     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
662         super._beforeTokenTransfer(from, to, amount);
663 
664         require(!paused(), "ERC20Pausable: token transfer while paused");
665     }
666 }
667 
668 
669 
670 
671 
672 /**
673  * @dev Collection of functions related to the address type
674  */
675 library Address {
676     /**
677      * @dev Returns true if `account` is a contract.
678      *
679      * [IMPORTANT]
680      * ====
681      * It is unsafe to assume that an address for which this function returns
682      * false is an externally-owned account (EOA) and not a contract.
683      *
684      * Among others, `isContract` will return false for the following
685      * types of addresses:
686      *
687      *  - an externally-owned account
688      *  - a contract in construction
689      *  - an address where a contract will be created
690      *  - an address where a contract lived, but was destroyed
691      * ====
692      */
693     function isContract(address account) internal view returns (bool) {
694         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
695         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
696         // for accounts without code, i.e. `keccak256('')`
697         bytes32 codehash;
698         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
699         // solhint-disable-next-line no-inline-assembly
700         assembly { codehash := extcodehash(account) }
701         return (codehash != accountHash && codehash != 0x0);
702     }
703 
704     /**
705      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
706      * `recipient`, forwarding all available gas and reverting on errors.
707      *
708      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
709      * of certain opcodes, possibly making contracts go over the 2300 gas limit
710      * imposed by `transfer`, making them unable to receive funds via
711      * `transfer`. {sendValue} removes this limitation.
712      *
713      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
714      *
715      * IMPORTANT: because control is transferred to `recipient`, care must be
716      * taken to not create reentrancy vulnerabilities. Consider using
717      * {ReentrancyGuard} or the
718      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
719      */
720     function sendValue(address payable recipient, uint256 amount) internal {
721         require(address(this).balance >= amount, "Address: insufficient balance");
722 
723         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
724         (bool success, ) = recipient.call{ value: amount }("");
725         require(success, "Address: unable to send value, recipient may have reverted");
726     }
727 }
728 
729 
730 /**
731  * @dev Library for managing
732  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
733  * types.
734  *
735  * Sets have the following properties:
736  *
737  * - Elements are added, removed, and checked for existence in constant time
738  * (O(1)).
739  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
740  *
741  * ```
742  * contract Example {
743  *     // Add the library methods
744  *     using EnumerableSet for EnumerableSet.AddressSet;
745  *
746  *     // Declare a set state variable
747  *     EnumerableSet.AddressSet private mySet;
748  * }
749  * ```
750  *
751  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
752  * (`UintSet`) are supported.
753  */
754 library EnumerableSet {
755     // To implement this library for multiple types with as little code
756     // repetition as possible, we write it in terms of a generic Set type with
757     // bytes32 values.
758     // The Set implementation uses private functions, and user-facing
759     // implementations (such as AddressSet) are just wrappers around the
760     // underlying Set.
761     // This means that we can only create new EnumerableSets for types that fit
762     // in bytes32.
763 
764     struct Set {
765         // Storage of set values
766         bytes32[] _values;
767 
768         // Position of the value in the `values` array, plus 1 because index 0
769         // means a value is not in the set.
770         mapping (bytes32 => uint256) _indexes;
771     }
772 
773     /**
774      * @dev Add a value to a set. O(1).
775      *
776      * Returns true if the value was added to the set, that is if it was not
777      * already present.
778      */
779     function _add(Set storage set, bytes32 value) private returns (bool) {
780         if (!_contains(set, value)) {
781             set._values.push(value);
782             // The value is stored at length-1, but we add 1 to all indexes
783             // and use 0 as a sentinel value
784             set._indexes[value] = set._values.length;
785             return true;
786         } else {
787             return false;
788         }
789     }
790 
791     /**
792      * @dev Removes a value from a set. O(1).
793      *
794      * Returns true if the value was removed from the set, that is if it was
795      * present.
796      */
797     function _remove(Set storage set, bytes32 value) private returns (bool) {
798         // We read and store the value's index to prevent multiple reads from the same storage slot
799         uint256 valueIndex = set._indexes[value];
800 
801         if (valueIndex != 0) { // Equivalent to contains(set, value)
802             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
803             // the array, and then remove the last element (sometimes called as 'swap and pop').
804             // This modifies the order of the array, as noted in {at}.
805 
806             uint256 toDeleteIndex = valueIndex - 1;
807             uint256 lastIndex = set._values.length - 1;
808 
809             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
810             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
811 
812             bytes32 lastvalue = set._values[lastIndex];
813 
814             // Move the last value to the index where the value to delete is
815             set._values[toDeleteIndex] = lastvalue;
816             // Update the index for the moved value
817             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
818 
819             // Delete the slot where the moved value was stored
820             set._values.pop();
821 
822             // Delete the index for the deleted slot
823             delete set._indexes[value];
824 
825             return true;
826         } else {
827             return false;
828         }
829     }
830 
831     /**
832      * @dev Returns true if the value is in the set. O(1).
833      */
834     function _contains(Set storage set, bytes32 value) private view returns (bool) {
835         return set._indexes[value] != 0;
836     }
837 
838     /**
839      * @dev Returns the number of values on the set. O(1).
840      */
841     function _length(Set storage set) private view returns (uint256) {
842         return set._values.length;
843     }
844 
845     /**
846      * @dev Returns the value stored at position `index` in the set. O(1).
847      *
848      * Note that there are no guarantees on the ordering of values inside the
849      * array, and it may change when more values are added or removed.
850      *
851      * Requirements:
852      *
853      * - `index` must be strictly less than {length}.
854      */
855     function _at(Set storage set, uint256 index) private view returns (bytes32) {
856         require(set._values.length > index, "EnumerableSet: index out of bounds");
857         return set._values[index];
858     }
859 
860     // AddressSet
861 
862     struct AddressSet {
863         Set _inner;
864     }
865 
866     /**
867      * @dev Add a value to a set. O(1).
868      *
869      * Returns true if the value was added to the set, that is if it was not
870      * already present.
871      */
872     function add(AddressSet storage set, address value) internal returns (bool) {
873         return _add(set._inner, bytes32(uint256(value)));
874     }
875 
876     /**
877      * @dev Removes a value from a set. O(1).
878      *
879      * Returns true if the value was removed from the set, that is if it was
880      * present.
881      */
882     function remove(AddressSet storage set, address value) internal returns (bool) {
883         return _remove(set._inner, bytes32(uint256(value)));
884     }
885 
886     /**
887      * @dev Returns true if the value is in the set. O(1).
888      */
889     function contains(AddressSet storage set, address value) internal view returns (bool) {
890         return _contains(set._inner, bytes32(uint256(value)));
891     }
892 
893     /**
894      * @dev Returns the number of values in the set. O(1).
895      */
896     function length(AddressSet storage set) internal view returns (uint256) {
897         return _length(set._inner);
898     }
899 
900     /**
901      * @dev Returns the value stored at position `index` in the set. O(1).
902      *
903      * Note that there are no guarantees on the ordering of values inside the
904      * array, and it may change when more values are added or removed.
905      *
906      * Requirements:
907      *
908      * - `index` must be strictly less than {length}.
909      */
910     function at(AddressSet storage set, uint256 index) internal view returns (address) {
911         return address(uint256(_at(set._inner, index)));
912     }
913 
914 
915     // UintSet
916 
917     struct UintSet {
918         Set _inner;
919     }
920 
921     /**
922      * @dev Add a value to a set. O(1).
923      *
924      * Returns true if the value was added to the set, that is if it was not
925      * already present.
926      */
927     function add(UintSet storage set, uint256 value) internal returns (bool) {
928         return _add(set._inner, bytes32(value));
929     }
930 
931     /**
932      * @dev Removes a value from a set. O(1).
933      *
934      * Returns true if the value was removed from the set, that is if it was
935      * present.
936      */
937     function remove(UintSet storage set, uint256 value) internal returns (bool) {
938         return _remove(set._inner, bytes32(value));
939     }
940 
941     /**
942      * @dev Returns true if the value is in the set. O(1).
943      */
944     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
945         return _contains(set._inner, bytes32(value));
946     }
947 
948     /**
949      * @dev Returns the number of values on the set. O(1).
950      */
951     function length(UintSet storage set) internal view returns (uint256) {
952         return _length(set._inner);
953     }
954 
955     /**
956      * @dev Returns the value stored at position `index` in the set. O(1).
957      *
958      * Note that there are no guarantees on the ordering of values inside the
959      * array, and it may change when more values are added or removed.
960      *
961      * Requirements:
962      *
963      * - `index` must be strictly less than {length}.
964      */
965     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
966         return uint256(_at(set._inner, index));
967     }
968 }
969 
970 
971 /**
972  * @dev Contract module that allows children to implement role-based access
973  * control mechanisms.
974  *
975  * Roles are referred to by their `bytes32` identifier. These should be exposed
976  * in the external API and be unique. The best way to achieve this is by
977  * using `public constant` hash digests:
978  *
979  * ```
980  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
981  * ```
982  *
983  * Roles can be used to represent a set of permissions. To restrict access to a
984  * function call, use {hasRole}:
985  *
986  * ```
987  * function foo() public {
988  *     require(hasRole(MY_ROLE, msg.sender));
989  *     ...
990  * }
991  * ```
992  *
993  * Roles can be granted and revoked dynamically via the {grantRole} and
994  * {revokeRole} functions. Each role has an associated admin role, and only
995  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
996  *
997  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
998  * that only accounts with this role will be able to grant or revoke other
999  * roles. More complex role relationships can be created by using
1000  * {_setRoleAdmin}.
1001  *
1002  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1003  * grant and revoke this role. Extra precautions should be taken to secure
1004  * accounts that have been granted it.
1005  */
1006 abstract contract AccessControl is Context {
1007     using EnumerableSet for EnumerableSet.AddressSet;
1008     using Address for address;
1009 
1010     struct RoleData {
1011         EnumerableSet.AddressSet members;
1012         bytes32 adminRole;
1013     }
1014 
1015     mapping (bytes32 => RoleData) private _roles;
1016 
1017     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1018 
1019     /**
1020      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1021      *
1022      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1023      * {RoleAdminChanged} not being emitted signaling this.
1024      */
1025     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1026 
1027     /**
1028      * @dev Emitted when `account` is granted `role`.
1029      *
1030      * `sender` is the account that originated the contract call, an admin role
1031      * bearer except when using {_setupRole}.
1032      */
1033     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1034 
1035     /**
1036      * @dev Emitted when `account` is revoked `role`.
1037      *
1038      * `sender` is the account that originated the contract call:
1039      *   - if using `revokeRole`, it is the admin role bearer
1040      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1041      */
1042     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1043 
1044     /**
1045      * @dev Returns `true` if `account` has been granted `role`.
1046      */
1047     function hasRole(bytes32 role, address account) public view returns (bool) {
1048         return _roles[role].members.contains(account);
1049     }
1050 
1051     /**
1052      * @dev Returns the number of accounts that have `role`. Can be used
1053      * together with {getRoleMember} to enumerate all bearers of a role.
1054      */
1055     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1056         return _roles[role].members.length();
1057     }
1058 
1059     /**
1060      * @dev Returns one of the accounts that have `role`. `index` must be a
1061      * value between 0 and {getRoleMemberCount}, non-inclusive.
1062      *
1063      * Role bearers are not sorted in any particular way, and their ordering may
1064      * change at any point.
1065      *
1066      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1067      * you perform all queries on the same block. See the following
1068      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1069      * for more information.
1070      */
1071     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1072         return _roles[role].members.at(index);
1073     }
1074 
1075     /**
1076      * @dev Returns the admin role that controls `role`. See {grantRole} and
1077      * {revokeRole}.
1078      *
1079      * To change a role's admin, use {_setRoleAdmin}.
1080      */
1081     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1082         return _roles[role].adminRole;
1083     }
1084 
1085     /**
1086      * @dev Grants `role` to `account`.
1087      *
1088      * If `account` had not been already granted `role`, emits a {RoleGranted}
1089      * event.
1090      *
1091      * Requirements:
1092      *
1093      * - the caller must have ``role``'s admin role.
1094      */
1095     function grantRole(bytes32 role, address account) public virtual {
1096         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1097 
1098         _grantRole(role, account);
1099     }
1100 
1101     /**
1102      * @dev Revokes `role` from `account`.
1103      *
1104      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1105      *
1106      * Requirements:
1107      *
1108      * - the caller must have ``role``'s admin role.
1109      */
1110     function revokeRole(bytes32 role, address account) public virtual {
1111         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1112 
1113         _revokeRole(role, account);
1114     }
1115 
1116     /**
1117      * @dev Revokes `role` from the calling account.
1118      *
1119      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1120      * purpose is to provide a mechanism for accounts to lose their privileges
1121      * if they are compromised (such as when a trusted device is misplaced).
1122      *
1123      * If the calling account had been granted `role`, emits a {RoleRevoked}
1124      * event.
1125      *
1126      * Requirements:
1127      *
1128      * - the caller must be `account`.
1129      */
1130     function renounceRole(bytes32 role, address account) public virtual {
1131         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1132 
1133         _revokeRole(role, account);
1134     }
1135 
1136     /**
1137      * @dev Grants `role` to `account`.
1138      *
1139      * If `account` had not been already granted `role`, emits a {RoleGranted}
1140      * event. Note that unlike {grantRole}, this function doesn't perform any
1141      * checks on the calling account.
1142      *
1143      * [WARNING]
1144      * ====
1145      * This function should only be called from the constructor when setting
1146      * up the initial roles for the system.
1147      *
1148      * Using this function in any other way is effectively circumventing the admin
1149      * system imposed by {AccessControl}.
1150      * ====
1151      */
1152     function _setupRole(bytes32 role, address account) internal virtual {
1153         _grantRole(role, account);
1154     }
1155 
1156     /**
1157      * @dev Sets `adminRole` as ``role``'s admin role.
1158      *
1159      * Emits a {RoleAdminChanged} event.
1160      */
1161     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1162         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1163         _roles[role].adminRole = adminRole;
1164     }
1165 
1166     function _grantRole(bytes32 role, address account) private {
1167         if (_roles[role].members.add(account)) {
1168             emit RoleGranted(role, account, _msgSender());
1169         }
1170     }
1171 
1172     function _revokeRole(bytes32 role, address account) private {
1173         if (_roles[role].members.remove(account)) {
1174             emit RoleRevoked(role, account, _msgSender());
1175         }
1176     }
1177 }
1178 
1179 
1180 /**
1181  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1182  * tokens and those that they have an allowance for, in a way that can be
1183  * recognized off-chain (via event analysis).
1184  */
1185 abstract contract ERC20Burnable is Context, ERC20 {
1186     /**
1187      * @dev Destroys `amount` tokens from the caller.
1188      *
1189      * See {ERC20-_burn}.
1190      */
1191     function burn(uint256 amount) public virtual {
1192         _burn(_msgSender(), amount);
1193     }
1194 
1195     /**
1196      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1197      * allowance.
1198      *
1199      * See {ERC20-_burn} and {ERC20-allowance}.
1200      *
1201      * Requirements:
1202      *
1203      * - the caller must have allowance for ``accounts``'s tokens of at least
1204      * `amount`.
1205      */
1206     function burnFrom(address account, uint256 amount) public virtual {
1207         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1208 
1209         _approve(account, _msgSender(), decreasedAllowance);
1210         _burn(account, amount);
1211     }
1212 }
1213 
1214 /**
1215  * @dev {ERC20} token, including:
1216  *
1217  *  - ability for holders to burn (destroy) their tokens
1218  *  - a minter role that allows for token minting (creation)
1219  *  - a pauser role that allows to stop all token transfers
1220  *
1221  * This contract uses {AccessControl} to lock permissioned functions using the
1222  * different roles - head to its documentation for details.
1223  *
1224  * The account that deploys the contract will be granted the minter and pauser
1225  * roles, as well as the default admin role, which will let it grant both minter
1226  * and pauser roles to other accounts
1227  */
1228 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1229     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1230     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1231 
1232     /**
1233      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1234      * account that deploys the contract.
1235      *
1236      * See {ERC20-constructor}.
1237      */
1238     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1239         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1240 
1241         _setupRole(MINTER_ROLE, _msgSender());
1242         _setupRole(PAUSER_ROLE, _msgSender());
1243     }
1244 
1245     /**
1246      * @dev Creates `amount` new tokens for `to`.
1247      *
1248      * See {ERC20-_mint}.
1249      *
1250      * Requirements:
1251      *
1252      * - the caller must have the `MINTER_ROLE`.
1253      */
1254     function mint(address to, uint256 amount) public virtual {
1255         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1256         _mint(to, amount);
1257     }
1258 
1259     /**
1260      * @dev Pauses all token transfers.
1261      *
1262      * See {ERC20Pausable} and {Pausable-_pause}.
1263      *
1264      * Requirements:
1265      *
1266      * - the caller must have the `PAUSER_ROLE`.
1267      */
1268     function pause() public virtual {
1269         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1270         _pause();
1271     }
1272 
1273     /**
1274      * @dev Unpauses all token transfers.
1275      *
1276      * See {ERC20Pausable} and {Pausable-_unpause}.
1277      *
1278      * Requirements:
1279      *
1280      * - the caller must have the `PAUSER_ROLE`.
1281      */
1282     function unpause() public virtual {
1283         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1284         _unpause();
1285     }
1286 
1287     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1288         super._beforeTokenTransfer(from, to, amount);
1289     }
1290 }