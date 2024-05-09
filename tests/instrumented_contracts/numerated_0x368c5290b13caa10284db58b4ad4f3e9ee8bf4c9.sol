1 // Sources flattened with hardhat v2.2.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
4 
5 
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
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
30 
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
32 
33 
34 
35 pragma solidity >=0.6.0 <0.8.0;
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
111 
112 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
113 
114 
115 
116 pragma solidity >=0.6.0 <0.8.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         uint256 c = a + b;
139         if (c < a) return (false, 0);
140         return (true, c);
141     }
142 
143     /**
144      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
145      *
146      * _Available since v3.4._
147      */
148     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         if (b > a) return (false, 0);
150         return (true, a - b);
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) return (true, 0);
163         uint256 c = a * b;
164         if (c / a != b) return (false, 0);
165         return (true, c);
166     }
167 
168     /**
169      * @dev Returns the division of two unsigned integers, with a division by zero flag.
170      *
171      * _Available since v3.4._
172      */
173     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
174         if (b == 0) return (false, 0);
175         return (true, a / b);
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         if (b == 0) return (false, 0);
185         return (true, a % b);
186     }
187 
188     /**
189      * @dev Returns the addition of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `+` operator.
193      *
194      * Requirements:
195      *
196      * - Addition cannot overflow.
197      */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         require(c >= a, "SafeMath: addition overflow");
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         require(b <= a, "SafeMath: subtraction overflow");
216         return a - b;
217     }
218 
219     /**
220      * @dev Returns the multiplication of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `*` operator.
224      *
225      * Requirements:
226      *
227      * - Multiplication cannot overflow.
228      */
229     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
230         if (a == 0) return 0;
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233         return c;
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers, reverting on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         require(b > 0, "SafeMath: division by zero");
250         return a / b;
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * reverting when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b > 0, "SafeMath: modulo by zero");
267         return a % b;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
272      * overflow (when the result is negative).
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {trySub}.
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      *
281      * - Subtraction cannot overflow.
282      */
283     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b <= a, errorMessage);
285         return a - b;
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
290      * division by zero. The result is rounded towards zero.
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {tryDiv}.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b > 0, errorMessage);
305         return a / b;
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * reverting with custom message when dividing by zero.
311      *
312      * CAUTION: This function is deprecated because it requires allocating memory for the error
313      * message unnecessarily. For custom revert reasons use {tryMod}.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b > 0, errorMessage);
325         return a % b;
326     }
327 }
328 
329 
330 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
331 
332 
333 
334 pragma solidity >=0.6.0 <0.8.0;
335 
336 
337 
338 /**
339  * @dev Implementation of the {IERC20} interface.
340  *
341  * This implementation is agnostic to the way tokens are created. This means
342  * that a supply mechanism has to be added in a derived contract using {_mint}.
343  * For a generic mechanism see {ERC20PresetMinterPauser}.
344  *
345  * TIP: For a detailed writeup see our guide
346  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
347  * to implement supply mechanisms].
348  *
349  * We have followed general OpenZeppelin guidelines: functions revert instead
350  * of returning `false` on failure. This behavior is nonetheless conventional
351  * and does not conflict with the expectations of ERC20 applications.
352  *
353  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
354  * This allows applications to reconstruct the allowance for all accounts just
355  * by listening to said events. Other implementations of the EIP may not emit
356  * these events, as it isn't required by the specification.
357  *
358  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
359  * functions have been added to mitigate the well-known issues around setting
360  * allowances. See {IERC20-approve}.
361  */
362 contract ERC20 is Context, IERC20 {
363     using SafeMath for uint256;
364 
365     mapping (address => uint256) private _balances;
366 
367     mapping (address => mapping (address => uint256)) private _allowances;
368 
369     uint256 private _totalSupply;
370 
371     string private _name;
372     string private _symbol;
373     uint8 private _decimals;
374 
375     /**
376      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
377      * a default value of 18.
378      *
379      * To select a different value for {decimals}, use {_setupDecimals}.
380      *
381      * All three of these values are immutable: they can only be set once during
382      * construction.
383      */
384     constructor (string memory name_, string memory symbol_) public {
385         _name = name_;
386         _symbol = symbol_;
387         _decimals = 18;
388     }
389 
390     /**
391      * @dev Returns the name of the token.
392      */
393     function name() public view virtual returns (string memory) {
394         return _name;
395     }
396 
397     /**
398      * @dev Returns the symbol of the token, usually a shorter version of the
399      * name.
400      */
401     function symbol() public view virtual returns (string memory) {
402         return _symbol;
403     }
404 
405     /**
406      * @dev Returns the number of decimals used to get its user representation.
407      * For example, if `decimals` equals `2`, a balance of `505` tokens should
408      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
409      *
410      * Tokens usually opt for a value of 18, imitating the relationship between
411      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
412      * called.
413      *
414      * NOTE: This information is only used for _display_ purposes: it in
415      * no way affects any of the arithmetic of the contract, including
416      * {IERC20-balanceOf} and {IERC20-transfer}.
417      */
418     function decimals() public view virtual returns (uint8) {
419         return _decimals;
420     }
421 
422     /**
423      * @dev See {IERC20-totalSupply}.
424      */
425     function totalSupply() public view virtual override returns (uint256) {
426         return _totalSupply;
427     }
428 
429     /**
430      * @dev See {IERC20-balanceOf}.
431      */
432     function balanceOf(address account) public view virtual override returns (uint256) {
433         return _balances[account];
434     }
435 
436     /**
437      * @dev See {IERC20-transfer}.
438      *
439      * Requirements:
440      *
441      * - `recipient` cannot be the zero address.
442      * - the caller must have a balance of at least `amount`.
443      */
444     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
445         _transfer(_msgSender(), recipient, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-allowance}.
451      */
452     function allowance(address owner, address spender) public view virtual override returns (uint256) {
453         return _allowances[owner][spender];
454     }
455 
456     /**
457      * @dev See {IERC20-approve}.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      */
463     function approve(address spender, uint256 amount) public virtual override returns (bool) {
464         _approve(_msgSender(), spender, amount);
465         return true;
466     }
467 
468     /**
469      * @dev See {IERC20-transferFrom}.
470      *
471      * Emits an {Approval} event indicating the updated allowance. This is not
472      * required by the EIP. See the note at the beginning of {ERC20}.
473      *
474      * Requirements:
475      *
476      * - `sender` and `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      * - the caller must have allowance for ``sender``'s tokens of at least
479      * `amount`.
480      */
481     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
482         _transfer(sender, recipient, amount);
483         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically increases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      */
499     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
501         return true;
502     }
503 
504     /**
505      * @dev Atomically decreases the allowance granted to `spender` by the caller.
506      *
507      * This is an alternative to {approve} that can be used as a mitigation for
508      * problems described in {IERC20-approve}.
509      *
510      * Emits an {Approval} event indicating the updated allowance.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      * - `spender` must have allowance for the caller of at least
516      * `subtractedValue`.
517      */
518     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
519         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
520         return true;
521     }
522 
523     /**
524      * @dev Moves tokens `amount` from `sender` to `recipient`.
525      *
526      * This is internal function is equivalent to {transfer}, and can be used to
527      * e.g. implement automatic token fees, slashing mechanisms, etc.
528      *
529      * Emits a {Transfer} event.
530      *
531      * Requirements:
532      *
533      * - `sender` cannot be the zero address.
534      * - `recipient` cannot be the zero address.
535      * - `sender` must have a balance of at least `amount`.
536      */
537     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
538         require(sender != address(0), "ERC20: transfer from the zero address");
539         require(recipient != address(0), "ERC20: transfer to the zero address");
540 
541         _beforeTokenTransfer(sender, recipient, amount);
542 
543         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
544         _balances[recipient] = _balances[recipient].add(amount);
545         emit Transfer(sender, recipient, amount);
546     }
547 
548     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
549      * the total supply.
550      *
551      * Emits a {Transfer} event with `from` set to the zero address.
552      *
553      * Requirements:
554      *
555      * - `to` cannot be the zero address.
556      */
557     function _mint(address account, uint256 amount) internal virtual {
558         require(account != address(0), "ERC20: mint to the zero address");
559 
560         _beforeTokenTransfer(address(0), account, amount);
561 
562         _totalSupply = _totalSupply.add(amount);
563         _balances[account] = _balances[account].add(amount);
564         emit Transfer(address(0), account, amount);
565     }
566 
567     /**
568      * @dev Destroys `amount` tokens from `account`, reducing the
569      * total supply.
570      *
571      * Emits a {Transfer} event with `to` set to the zero address.
572      *
573      * Requirements:
574      *
575      * - `account` cannot be the zero address.
576      * - `account` must have at least `amount` tokens.
577      */
578     function _burn(address account, uint256 amount) internal virtual {
579         require(account != address(0), "ERC20: burn from the zero address");
580 
581         _beforeTokenTransfer(account, address(0), amount);
582 
583         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
584         _totalSupply = _totalSupply.sub(amount);
585         emit Transfer(account, address(0), amount);
586     }
587 
588     /**
589      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
590      *
591      * This internal function is equivalent to `approve`, and can be used to
592      * e.g. set automatic allowances for certain subsystems, etc.
593      *
594      * Emits an {Approval} event.
595      *
596      * Requirements:
597      *
598      * - `owner` cannot be the zero address.
599      * - `spender` cannot be the zero address.
600      */
601     function _approve(address owner, address spender, uint256 amount) internal virtual {
602         require(owner != address(0), "ERC20: approve from the zero address");
603         require(spender != address(0), "ERC20: approve to the zero address");
604 
605         _allowances[owner][spender] = amount;
606         emit Approval(owner, spender, amount);
607     }
608 
609     /**
610      * @dev Sets {decimals} to a value other than the default one of 18.
611      *
612      * WARNING: This function should only be called from the constructor. Most
613      * applications that interact with token contracts will not expect
614      * {decimals} to ever change, and may work incorrectly if it does.
615      */
616     function _setupDecimals(uint8 decimals_) internal virtual {
617         _decimals = decimals_;
618     }
619 
620     /**
621      * @dev Hook that is called before any transfer of tokens. This includes
622      * minting and burning.
623      *
624      * Calling conditions:
625      *
626      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
627      * will be to transferred to `to`.
628      * - when `from` is zero, `amount` tokens will be minted for `to`.
629      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
630      * - `from` and `to` are never both zero.
631      *
632      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
633      */
634     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
635 }
636 
637 
638 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
639 
640 
641 
642 pragma solidity >=0.6.0 <0.8.0;
643 
644 /**
645  * @dev Contract module which provides a basic access control mechanism, where
646  * there is an account (an owner) that can be granted exclusive access to
647  * specific functions.
648  *
649  * By default, the owner account will be the one that deploys the contract. This
650  * can later be changed with {transferOwnership}.
651  *
652  * This module is used through inheritance. It will make available the modifier
653  * `onlyOwner`, which can be applied to your functions to restrict their use to
654  * the owner.
655  */
656 abstract contract Ownable is Context {
657     address private _owner;
658 
659     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
660 
661     /**
662      * @dev Initializes the contract setting the deployer as the initial owner.
663      */
664     constructor () internal {
665         address msgSender = _msgSender();
666         _owner = msgSender;
667         emit OwnershipTransferred(address(0), msgSender);
668     }
669 
670     /**
671      * @dev Returns the address of the current owner.
672      */
673     function owner() public view virtual returns (address) {
674         return _owner;
675     }
676 
677     /**
678      * @dev Throws if called by any account other than the owner.
679      */
680     modifier onlyOwner() {
681         require(owner() == _msgSender(), "Ownable: caller is not the owner");
682         _;
683     }
684 
685     /**
686      * @dev Leaves the contract without owner. It will not be possible to call
687      * `onlyOwner` functions anymore. Can only be called by the current owner.
688      *
689      * NOTE: Renouncing ownership will leave the contract without an owner,
690      * thereby removing any functionality that is only available to the owner.
691      */
692     function renounceOwnership() public virtual onlyOwner {
693         emit OwnershipTransferred(_owner, address(0));
694         _owner = address(0);
695     }
696 
697     /**
698      * @dev Transfers ownership of the contract to a new account (`newOwner`).
699      * Can only be called by the current owner.
700      */
701     function transferOwnership(address newOwner) public virtual onlyOwner {
702         require(newOwner != address(0), "Ownable: new owner is the zero address");
703         emit OwnershipTransferred(_owner, newOwner);
704         _owner = newOwner;
705     }
706 }
707 
708 
709 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
710 
711 
712 
713 pragma solidity >=0.6.0 <0.8.0;
714 
715 /**
716  * @dev Library for managing
717  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
718  * types.
719  *
720  * Sets have the following properties:
721  *
722  * - Elements are added, removed, and checked for existence in constant time
723  * (O(1)).
724  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
725  *
726  * ```
727  * contract Example {
728  *     // Add the library methods
729  *     using EnumerableSet for EnumerableSet.AddressSet;
730  *
731  *     // Declare a set state variable
732  *     EnumerableSet.AddressSet private mySet;
733  * }
734  * ```
735  *
736  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
737  * and `uint256` (`UintSet`) are supported.
738  */
739 library EnumerableSet {
740     // To implement this library for multiple types with as little code
741     // repetition as possible, we write it in terms of a generic Set type with
742     // bytes32 values.
743     // The Set implementation uses private functions, and user-facing
744     // implementations (such as AddressSet) are just wrappers around the
745     // underlying Set.
746     // This means that we can only create new EnumerableSets for types that fit
747     // in bytes32.
748 
749     struct Set {
750         // Storage of set values
751         bytes32[] _values;
752 
753         // Position of the value in the `values` array, plus 1 because index 0
754         // means a value is not in the set.
755         mapping (bytes32 => uint256) _indexes;
756     }
757 
758     /**
759      * @dev Add a value to a set. O(1).
760      *
761      * Returns true if the value was added to the set, that is if it was not
762      * already present.
763      */
764     function _add(Set storage set, bytes32 value) private returns (bool) {
765         if (!_contains(set, value)) {
766             set._values.push(value);
767             // The value is stored at length-1, but we add 1 to all indexes
768             // and use 0 as a sentinel value
769             set._indexes[value] = set._values.length;
770             return true;
771         } else {
772             return false;
773         }
774     }
775 
776     /**
777      * @dev Removes a value from a set. O(1).
778      *
779      * Returns true if the value was removed from the set, that is if it was
780      * present.
781      */
782     function _remove(Set storage set, bytes32 value) private returns (bool) {
783         // We read and store the value's index to prevent multiple reads from the same storage slot
784         uint256 valueIndex = set._indexes[value];
785 
786         if (valueIndex != 0) { // Equivalent to contains(set, value)
787             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
788             // the array, and then remove the last element (sometimes called as 'swap and pop').
789             // This modifies the order of the array, as noted in {at}.
790 
791             uint256 toDeleteIndex = valueIndex - 1;
792             uint256 lastIndex = set._values.length - 1;
793 
794             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
795             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
796 
797             bytes32 lastvalue = set._values[lastIndex];
798 
799             // Move the last value to the index where the value to delete is
800             set._values[toDeleteIndex] = lastvalue;
801             // Update the index for the moved value
802             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
803 
804             // Delete the slot where the moved value was stored
805             set._values.pop();
806 
807             // Delete the index for the deleted slot
808             delete set._indexes[value];
809 
810             return true;
811         } else {
812             return false;
813         }
814     }
815 
816     /**
817      * @dev Returns true if the value is in the set. O(1).
818      */
819     function _contains(Set storage set, bytes32 value) private view returns (bool) {
820         return set._indexes[value] != 0;
821     }
822 
823     /**
824      * @dev Returns the number of values on the set. O(1).
825      */
826     function _length(Set storage set) private view returns (uint256) {
827         return set._values.length;
828     }
829 
830    /**
831     * @dev Returns the value stored at position `index` in the set. O(1).
832     *
833     * Note that there are no guarantees on the ordering of values inside the
834     * array, and it may change when more values are added or removed.
835     *
836     * Requirements:
837     *
838     * - `index` must be strictly less than {length}.
839     */
840     function _at(Set storage set, uint256 index) private view returns (bytes32) {
841         require(set._values.length > index, "EnumerableSet: index out of bounds");
842         return set._values[index];
843     }
844 
845     // Bytes32Set
846 
847     struct Bytes32Set {
848         Set _inner;
849     }
850 
851     /**
852      * @dev Add a value to a set. O(1).
853      *
854      * Returns true if the value was added to the set, that is if it was not
855      * already present.
856      */
857     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
858         return _add(set._inner, value);
859     }
860 
861     /**
862      * @dev Removes a value from a set. O(1).
863      *
864      * Returns true if the value was removed from the set, that is if it was
865      * present.
866      */
867     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
868         return _remove(set._inner, value);
869     }
870 
871     /**
872      * @dev Returns true if the value is in the set. O(1).
873      */
874     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
875         return _contains(set._inner, value);
876     }
877 
878     /**
879      * @dev Returns the number of values in the set. O(1).
880      */
881     function length(Bytes32Set storage set) internal view returns (uint256) {
882         return _length(set._inner);
883     }
884 
885    /**
886     * @dev Returns the value stored at position `index` in the set. O(1).
887     *
888     * Note that there are no guarantees on the ordering of values inside the
889     * array, and it may change when more values are added or removed.
890     *
891     * Requirements:
892     *
893     * - `index` must be strictly less than {length}.
894     */
895     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
896         return _at(set._inner, index);
897     }
898 
899     // AddressSet
900 
901     struct AddressSet {
902         Set _inner;
903     }
904 
905     /**
906      * @dev Add a value to a set. O(1).
907      *
908      * Returns true if the value was added to the set, that is if it was not
909      * already present.
910      */
911     function add(AddressSet storage set, address value) internal returns (bool) {
912         return _add(set._inner, bytes32(uint256(uint160(value))));
913     }
914 
915     /**
916      * @dev Removes a value from a set. O(1).
917      *
918      * Returns true if the value was removed from the set, that is if it was
919      * present.
920      */
921     function remove(AddressSet storage set, address value) internal returns (bool) {
922         return _remove(set._inner, bytes32(uint256(uint160(value))));
923     }
924 
925     /**
926      * @dev Returns true if the value is in the set. O(1).
927      */
928     function contains(AddressSet storage set, address value) internal view returns (bool) {
929         return _contains(set._inner, bytes32(uint256(uint160(value))));
930     }
931 
932     /**
933      * @dev Returns the number of values in the set. O(1).
934      */
935     function length(AddressSet storage set) internal view returns (uint256) {
936         return _length(set._inner);
937     }
938 
939    /**
940     * @dev Returns the value stored at position `index` in the set. O(1).
941     *
942     * Note that there are no guarantees on the ordering of values inside the
943     * array, and it may change when more values are added or removed.
944     *
945     * Requirements:
946     *
947     * - `index` must be strictly less than {length}.
948     */
949     function at(AddressSet storage set, uint256 index) internal view returns (address) {
950         return address(uint160(uint256(_at(set._inner, index))));
951     }
952 
953 
954     // UintSet
955 
956     struct UintSet {
957         Set _inner;
958     }
959 
960     /**
961      * @dev Add a value to a set. O(1).
962      *
963      * Returns true if the value was added to the set, that is if it was not
964      * already present.
965      */
966     function add(UintSet storage set, uint256 value) internal returns (bool) {
967         return _add(set._inner, bytes32(value));
968     }
969 
970     /**
971      * @dev Removes a value from a set. O(1).
972      *
973      * Returns true if the value was removed from the set, that is if it was
974      * present.
975      */
976     function remove(UintSet storage set, uint256 value) internal returns (bool) {
977         return _remove(set._inner, bytes32(value));
978     }
979 
980     /**
981      * @dev Returns true if the value is in the set. O(1).
982      */
983     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
984         return _contains(set._inner, bytes32(value));
985     }
986 
987     /**
988      * @dev Returns the number of values on the set. O(1).
989      */
990     function length(UintSet storage set) internal view returns (uint256) {
991         return _length(set._inner);
992     }
993 
994    /**
995     * @dev Returns the value stored at position `index` in the set. O(1).
996     *
997     * Note that there are no guarantees on the ordering of values inside the
998     * array, and it may change when more values are added or removed.
999     *
1000     * Requirements:
1001     *
1002     * - `index` must be strictly less than {length}.
1003     */
1004     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1005         return uint256(_at(set._inner, index));
1006     }
1007 }
1008 
1009 
1010 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
1011 
1012 
1013 
1014 pragma solidity >=0.6.2 <0.8.0;
1015 
1016 /**
1017  * @dev Collection of functions related to the address type
1018  */
1019 library Address {
1020     /**
1021      * @dev Returns true if `account` is a contract.
1022      *
1023      * [IMPORTANT]
1024      * ====
1025      * It is unsafe to assume that an address for which this function returns
1026      * false is an externally-owned account (EOA) and not a contract.
1027      *
1028      * Among others, `isContract` will return false for the following
1029      * types of addresses:
1030      *
1031      *  - an externally-owned account
1032      *  - a contract in construction
1033      *  - an address where a contract will be created
1034      *  - an address where a contract lived, but was destroyed
1035      * ====
1036      */
1037     function isContract(address account) internal view returns (bool) {
1038         // This method relies on extcodesize, which returns 0 for contracts in
1039         // construction, since the code is only stored at the end of the
1040         // constructor execution.
1041 
1042         uint256 size;
1043         // solhint-disable-next-line no-inline-assembly
1044         assembly { size := extcodesize(account) }
1045         return size > 0;
1046     }
1047 
1048     /**
1049      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1050      * `recipient`, forwarding all available gas and reverting on errors.
1051      *
1052      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1053      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1054      * imposed by `transfer`, making them unable to receive funds via
1055      * `transfer`. {sendValue} removes this limitation.
1056      *
1057      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1058      *
1059      * IMPORTANT: because control is transferred to `recipient`, care must be
1060      * taken to not create reentrancy vulnerabilities. Consider using
1061      * {ReentrancyGuard} or the
1062      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1063      */
1064     function sendValue(address payable recipient, uint256 amount) internal {
1065         require(address(this).balance >= amount, "Address: insufficient balance");
1066 
1067         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1068         (bool success, ) = recipient.call{ value: amount }("");
1069         require(success, "Address: unable to send value, recipient may have reverted");
1070     }
1071 
1072     /**
1073      * @dev Performs a Solidity function call using a low level `call`. A
1074      * plain`call` is an unsafe replacement for a function call: use this
1075      * function instead.
1076      *
1077      * If `target` reverts with a revert reason, it is bubbled up by this
1078      * function (like regular Solidity function calls).
1079      *
1080      * Returns the raw returned data. To convert to the expected return value,
1081      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1082      *
1083      * Requirements:
1084      *
1085      * - `target` must be a contract.
1086      * - calling `target` with `data` must not revert.
1087      *
1088      * _Available since v3.1._
1089      */
1090     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1091       return functionCall(target, data, "Address: low-level call failed");
1092     }
1093 
1094     /**
1095      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1096      * `errorMessage` as a fallback revert reason when `target` reverts.
1097      *
1098      * _Available since v3.1._
1099      */
1100     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1101         return functionCallWithValue(target, data, 0, errorMessage);
1102     }
1103 
1104     /**
1105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1106      * but also transferring `value` wei to `target`.
1107      *
1108      * Requirements:
1109      *
1110      * - the calling contract must have an ETH balance of at least `value`.
1111      * - the called Solidity function must be `payable`.
1112      *
1113      * _Available since v3.1._
1114      */
1115     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1117     }
1118 
1119     /**
1120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1121      * with `errorMessage` as a fallback revert reason when `target` reverts.
1122      *
1123      * _Available since v3.1._
1124      */
1125     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1126         require(address(this).balance >= value, "Address: insufficient balance for call");
1127         require(isContract(target), "Address: call to non-contract");
1128 
1129         // solhint-disable-next-line avoid-low-level-calls
1130         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1131         return _verifyCallResult(success, returndata, errorMessage);
1132     }
1133 
1134     /**
1135      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1136      * but performing a static call.
1137      *
1138      * _Available since v3.3._
1139      */
1140     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1141         return functionStaticCall(target, data, "Address: low-level static call failed");
1142     }
1143 
1144     /**
1145      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1146      * but performing a static call.
1147      *
1148      * _Available since v3.3._
1149      */
1150     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1151         require(isContract(target), "Address: static call to non-contract");
1152 
1153         // solhint-disable-next-line avoid-low-level-calls
1154         (bool success, bytes memory returndata) = target.staticcall(data);
1155         return _verifyCallResult(success, returndata, errorMessage);
1156     }
1157 
1158     /**
1159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1160      * but performing a delegate call.
1161      *
1162      * _Available since v3.4._
1163      */
1164     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1165         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1166     }
1167 
1168     /**
1169      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1170      * but performing a delegate call.
1171      *
1172      * _Available since v3.4._
1173      */
1174     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1175         require(isContract(target), "Address: delegate call to non-contract");
1176 
1177         // solhint-disable-next-line avoid-low-level-calls
1178         (bool success, bytes memory returndata) = target.delegatecall(data);
1179         return _verifyCallResult(success, returndata, errorMessage);
1180     }
1181 
1182     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1183         if (success) {
1184             return returndata;
1185         } else {
1186             // Look for revert reason and bubble it up if present
1187             if (returndata.length > 0) {
1188                 // The easiest way to bubble the revert reason is using memory via assembly
1189 
1190                 // solhint-disable-next-line no-inline-assembly
1191                 assembly {
1192                     let returndata_size := mload(returndata)
1193                     revert(add(32, returndata), returndata_size)
1194                 }
1195             } else {
1196                 revert(errorMessage);
1197             }
1198         }
1199     }
1200 }
1201 
1202 
1203 // File @openzeppelin/contracts/access/AccessControl.sol@v3.4.1
1204 
1205 
1206 
1207 pragma solidity >=0.6.0 <0.8.0;
1208 
1209 
1210 
1211 /**
1212  * @dev Contract module that allows children to implement role-based access
1213  * control mechanisms.
1214  *
1215  * Roles are referred to by their `bytes32` identifier. These should be exposed
1216  * in the external API and be unique. The best way to achieve this is by
1217  * using `public constant` hash digests:
1218  *
1219  * ```
1220  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1221  * ```
1222  *
1223  * Roles can be used to represent a set of permissions. To restrict access to a
1224  * function call, use {hasRole}:
1225  *
1226  * ```
1227  * function foo() public {
1228  *     require(hasRole(MY_ROLE, msg.sender));
1229  *     ...
1230  * }
1231  * ```
1232  *
1233  * Roles can be granted and revoked dynamically via the {grantRole} and
1234  * {revokeRole} functions. Each role has an associated admin role, and only
1235  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1236  *
1237  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1238  * that only accounts with this role will be able to grant or revoke other
1239  * roles. More complex role relationships can be created by using
1240  * {_setRoleAdmin}.
1241  *
1242  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1243  * grant and revoke this role. Extra precautions should be taken to secure
1244  * accounts that have been granted it.
1245  */
1246 abstract contract AccessControl is Context {
1247     using EnumerableSet for EnumerableSet.AddressSet;
1248     using Address for address;
1249 
1250     struct RoleData {
1251         EnumerableSet.AddressSet members;
1252         bytes32 adminRole;
1253     }
1254 
1255     mapping (bytes32 => RoleData) private _roles;
1256 
1257     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1258 
1259     /**
1260      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1261      *
1262      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1263      * {RoleAdminChanged} not being emitted signaling this.
1264      *
1265      * _Available since v3.1._
1266      */
1267     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1268 
1269     /**
1270      * @dev Emitted when `account` is granted `role`.
1271      *
1272      * `sender` is the account that originated the contract call, an admin role
1273      * bearer except when using {_setupRole}.
1274      */
1275     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1276 
1277     /**
1278      * @dev Emitted when `account` is revoked `role`.
1279      *
1280      * `sender` is the account that originated the contract call:
1281      *   - if using `revokeRole`, it is the admin role bearer
1282      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1283      */
1284     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1285 
1286     /**
1287      * @dev Returns `true` if `account` has been granted `role`.
1288      */
1289     function hasRole(bytes32 role, address account) public view returns (bool) {
1290         return _roles[role].members.contains(account);
1291     }
1292 
1293     /**
1294      * @dev Returns the number of accounts that have `role`. Can be used
1295      * together with {getRoleMember} to enumerate all bearers of a role.
1296      */
1297     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1298         return _roles[role].members.length();
1299     }
1300 
1301     /**
1302      * @dev Returns one of the accounts that have `role`. `index` must be a
1303      * value between 0 and {getRoleMemberCount}, non-inclusive.
1304      *
1305      * Role bearers are not sorted in any particular way, and their ordering may
1306      * change at any point.
1307      *
1308      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1309      * you perform all queries on the same block. See the following
1310      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1311      * for more information.
1312      */
1313     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1314         return _roles[role].members.at(index);
1315     }
1316 
1317     /**
1318      * @dev Returns the admin role that controls `role`. See {grantRole} and
1319      * {revokeRole}.
1320      *
1321      * To change a role's admin, use {_setRoleAdmin}.
1322      */
1323     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1324         return _roles[role].adminRole;
1325     }
1326 
1327     /**
1328      * @dev Grants `role` to `account`.
1329      *
1330      * If `account` had not been already granted `role`, emits a {RoleGranted}
1331      * event.
1332      *
1333      * Requirements:
1334      *
1335      * - the caller must have ``role``'s admin role.
1336      */
1337     function grantRole(bytes32 role, address account) public virtual {
1338         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1339 
1340         _grantRole(role, account);
1341     }
1342 
1343     /**
1344      * @dev Revokes `role` from `account`.
1345      *
1346      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1347      *
1348      * Requirements:
1349      *
1350      * - the caller must have ``role``'s admin role.
1351      */
1352     function revokeRole(bytes32 role, address account) public virtual {
1353         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1354 
1355         _revokeRole(role, account);
1356     }
1357 
1358     /**
1359      * @dev Revokes `role` from the calling account.
1360      *
1361      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1362      * purpose is to provide a mechanism for accounts to lose their privileges
1363      * if they are compromised (such as when a trusted device is misplaced).
1364      *
1365      * If the calling account had been granted `role`, emits a {RoleRevoked}
1366      * event.
1367      *
1368      * Requirements:
1369      *
1370      * - the caller must be `account`.
1371      */
1372     function renounceRole(bytes32 role, address account) public virtual {
1373         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1374 
1375         _revokeRole(role, account);
1376     }
1377 
1378     /**
1379      * @dev Grants `role` to `account`.
1380      *
1381      * If `account` had not been already granted `role`, emits a {RoleGranted}
1382      * event. Note that unlike {grantRole}, this function doesn't perform any
1383      * checks on the calling account.
1384      *
1385      * [WARNING]
1386      * ====
1387      * This function should only be called from the constructor when setting
1388      * up the initial roles for the system.
1389      *
1390      * Using this function in any other way is effectively circumventing the admin
1391      * system imposed by {AccessControl}.
1392      * ====
1393      */
1394     function _setupRole(bytes32 role, address account) internal virtual {
1395         _grantRole(role, account);
1396     }
1397 
1398     /**
1399      * @dev Sets `adminRole` as ``role``'s admin role.
1400      *
1401      * Emits a {RoleAdminChanged} event.
1402      */
1403     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1404         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1405         _roles[role].adminRole = adminRole;
1406     }
1407 
1408     function _grantRole(bytes32 role, address account) private {
1409         if (_roles[role].members.add(account)) {
1410             emit RoleGranted(role, account, _msgSender());
1411         }
1412     }
1413 
1414     function _revokeRole(bytes32 role, address account) private {
1415         if (_roles[role].members.remove(account)) {
1416             emit RoleRevoked(role, account, _msgSender());
1417         }
1418     }
1419 }
1420 
1421 
1422 // File contracts/interfaces/IDetailedERC20.sol
1423 
1424 // SPDX-License-Identifier: GPL-3.0
1425 pragma solidity ^0.7.0;
1426 
1427 interface IDetailedERC20 is IERC20 {
1428   function name() external returns (string memory);
1429   function symbol() external returns (string memory);
1430   function decimals() external returns (uint8);
1431 }
1432 
1433 
1434 // File contracts/KKO.sol
1435 
1436 pragma solidity ^0.7.0;
1437 
1438 
1439 
1440 
1441 
1442 /// @title Kineko Token
1443 ///
1444 contract KKO is AccessControl, ERC20("Kineko", "KKO") {
1445 
1446   /// @dev The identifier of the role which maintains other roles.
1447   bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
1448 
1449   /// @dev The identifier of the role which allows accounts to mint tokens.
1450   bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1451 
1452   constructor() {
1453     _setupRole(ADMIN_ROLE, msg.sender);
1454     _setupRole(MINTER_ROLE, msg.sender);
1455     _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE);
1456     _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
1457   }
1458 
1459   /// @dev A modifier which checks that the caller has the minter role.
1460   modifier onlyMinter() {
1461     require(hasRole(MINTER_ROLE, msg.sender), "KinekoToken: only minter");
1462     _;
1463   }
1464 
1465   /// @dev Mints tokens to a recipient.
1466   ///
1467   /// This function reverts if the caller does not have the minter role.
1468   ///
1469   /// @param _recipient the account to mint tokens to.
1470   /// @param _amount    the amount of tokens to mint.
1471   function mint(address _recipient, uint256 _amount) external onlyMinter {
1472     _mint(_recipient, _amount);
1473   }
1474 }