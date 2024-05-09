1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
27 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
28 
29 
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
109 
110 
111 
112 pragma solidity >=0.6.0 <0.8.0;
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
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {tryDiv}.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting with custom message when dividing by zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryMod}.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 
326 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
327 
328 
329 
330 pragma solidity >=0.6.0 <0.8.0;
331 
332 
333 
334 /**
335  * @dev Implementation of the {IERC20} interface.
336  *
337  * This implementation is agnostic to the way tokens are created. This means
338  * that a supply mechanism has to be added in a derived contract using {_mint}.
339  * For a generic mechanism see {ERC20PresetMinterPauser}.
340  *
341  * TIP: For a detailed writeup see our guide
342  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
343  * to implement supply mechanisms].
344  *
345  * We have followed general OpenZeppelin guidelines: functions revert instead
346  * of returning `false` on failure. This behavior is nonetheless conventional
347  * and does not conflict with the expectations of ERC20 applications.
348  *
349  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
350  * This allows applications to reconstruct the allowance for all accounts just
351  * by listening to said events. Other implementations of the EIP may not emit
352  * these events, as it isn't required by the specification.
353  *
354  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
355  * functions have been added to mitigate the well-known issues around setting
356  * allowances. See {IERC20-approve}.
357  */
358 contract ERC20 is Context, IERC20 {
359     using SafeMath for uint256;
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
380     constructor (string memory name_, string memory symbol_) public {
381         _name = name_;
382         _symbol = symbol_;
383         _decimals = 18;
384     }
385 
386     /**
387      * @dev Returns the name of the token.
388      */
389     function name() public view virtual returns (string memory) {
390         return _name;
391     }
392 
393     /**
394      * @dev Returns the symbol of the token, usually a shorter version of the
395      * name.
396      */
397     function symbol() public view virtual returns (string memory) {
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
414     function decimals() public view virtual returns (uint8) {
415         return _decimals;
416     }
417 
418     /**
419      * @dev See {IERC20-totalSupply}.
420      */
421     function totalSupply() public view virtual override returns (uint256) {
422         return _totalSupply;
423     }
424 
425     /**
426      * @dev See {IERC20-balanceOf}.
427      */
428     function balanceOf(address account) public view virtual override returns (uint256) {
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
468      * required by the EIP. See the note at the beginning of {ERC20}.
469      *
470      * Requirements:
471      *
472      * - `sender` and `recipient` cannot be the zero address.
473      * - `sender` must have a balance of at least `amount`.
474      * - the caller must have allowance for ``sender``'s tokens of at least
475      * `amount`.
476      */
477     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
478         _transfer(sender, recipient, amount);
479         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
480         return true;
481     }
482 
483     /**
484      * @dev Atomically increases the allowance granted to `spender` by the caller.
485      *
486      * This is an alternative to {approve} that can be used as a mitigation for
487      * problems described in {IERC20-approve}.
488      *
489      * Emits an {Approval} event indicating the updated allowance.
490      *
491      * Requirements:
492      *
493      * - `spender` cannot be the zero address.
494      */
495     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
496         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
497         return true;
498     }
499 
500     /**
501      * @dev Atomically decreases the allowance granted to `spender` by the caller.
502      *
503      * This is an alternative to {approve} that can be used as a mitigation for
504      * problems described in {IERC20-approve}.
505      *
506      * Emits an {Approval} event indicating the updated allowance.
507      *
508      * Requirements:
509      *
510      * - `spender` cannot be the zero address.
511      * - `spender` must have allowance for the caller of at least
512      * `subtractedValue`.
513      */
514     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
515         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
516         return true;
517     }
518 
519     /**
520      * @dev Moves tokens `amount` from `sender` to `recipient`.
521      *
522      * This is internal function is equivalent to {transfer}, and can be used to
523      * e.g. implement automatic token fees, slashing mechanisms, etc.
524      *
525      * Emits a {Transfer} event.
526      *
527      * Requirements:
528      *
529      * - `sender` cannot be the zero address.
530      * - `recipient` cannot be the zero address.
531      * - `sender` must have a balance of at least `amount`.
532      */
533     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
534         require(sender != address(0), "ERC20: transfer from the zero address");
535         require(recipient != address(0), "ERC20: transfer to the zero address");
536 
537         _beforeTokenTransfer(sender, recipient, amount);
538 
539         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
540         _balances[recipient] = _balances[recipient].add(amount);
541         emit Transfer(sender, recipient, amount);
542     }
543 
544     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
545      * the total supply.
546      *
547      * Emits a {Transfer} event with `from` set to the zero address.
548      *
549      * Requirements:
550      *
551      * - `to` cannot be the zero address.
552      */
553     function _mint(address account, uint256 amount) internal virtual {
554         require(account != address(0), "ERC20: mint to the zero address");
555 
556         _beforeTokenTransfer(address(0), account, amount);
557 
558         _totalSupply = _totalSupply.add(amount);
559         _balances[account] = _balances[account].add(amount);
560         emit Transfer(address(0), account, amount);
561     }
562 
563     /**
564      * @dev Destroys `amount` tokens from `account`, reducing the
565      * total supply.
566      *
567      * Emits a {Transfer} event with `to` set to the zero address.
568      *
569      * Requirements:
570      *
571      * - `account` cannot be the zero address.
572      * - `account` must have at least `amount` tokens.
573      */
574     function _burn(address account, uint256 amount) internal virtual {
575         require(account != address(0), "ERC20: burn from the zero address");
576 
577         _beforeTokenTransfer(account, address(0), amount);
578 
579         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
580         _totalSupply = _totalSupply.sub(amount);
581         emit Transfer(account, address(0), amount);
582     }
583 
584     /**
585      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
586      *
587      * This internal function is equivalent to `approve`, and can be used to
588      * e.g. set automatic allowances for certain subsystems, etc.
589      *
590      * Emits an {Approval} event.
591      *
592      * Requirements:
593      *
594      * - `owner` cannot be the zero address.
595      * - `spender` cannot be the zero address.
596      */
597     function _approve(address owner, address spender, uint256 amount) internal virtual {
598         require(owner != address(0), "ERC20: approve from the zero address");
599         require(spender != address(0), "ERC20: approve to the zero address");
600 
601         _allowances[owner][spender] = amount;
602         emit Approval(owner, spender, amount);
603     }
604 
605     /**
606      * @dev Sets {decimals} to a value other than the default one of 18.
607      *
608      * WARNING: This function should only be called from the constructor. Most
609      * applications that interact with token contracts will not expect
610      * {decimals} to ever change, and may work incorrectly if it does.
611      */
612     function _setupDecimals(uint8 decimals_) internal virtual {
613         _decimals = decimals_;
614     }
615 
616     /**
617      * @dev Hook that is called before any transfer of tokens. This includes
618      * minting and burning.
619      *
620      * Calling conditions:
621      *
622      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
623      * will be to transferred to `to`.
624      * - when `from` is zero, `amount` tokens will be minted for `to`.
625      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
626      * - `from` and `to` are never both zero.
627      *
628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
629      */
630     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
631 }
632 
633 
634 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
635 
636 
637 
638 pragma solidity >=0.6.0 <0.8.0;
639 
640 /**
641  * @dev Contract module which provides a basic access control mechanism, where
642  * there is an account (an owner) that can be granted exclusive access to
643  * specific functions.
644  *
645  * By default, the owner account will be the one that deploys the contract. This
646  * can later be changed with {transferOwnership}.
647  *
648  * This module is used through inheritance. It will make available the modifier
649  * `onlyOwner`, which can be applied to your functions to restrict their use to
650  * the owner.
651  */
652 abstract contract Ownable is Context {
653     address private _owner;
654 
655     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
656 
657     /**
658      * @dev Initializes the contract setting the deployer as the initial owner.
659      */
660     constructor () internal {
661         address msgSender = _msgSender();
662         _owner = msgSender;
663         emit OwnershipTransferred(address(0), msgSender);
664     }
665 
666     /**
667      * @dev Returns the address of the current owner.
668      */
669     function owner() public view virtual returns (address) {
670         return _owner;
671     }
672 
673     /**
674      * @dev Throws if called by any account other than the owner.
675      */
676     modifier onlyOwner() {
677         require(owner() == _msgSender(), "Ownable: caller is not the owner");
678         _;
679     }
680 
681     /**
682      * @dev Leaves the contract without owner. It will not be possible to call
683      * `onlyOwner` functions anymore. Can only be called by the current owner.
684      *
685      * NOTE: Renouncing ownership will leave the contract without an owner,
686      * thereby removing any functionality that is only available to the owner.
687      */
688     function renounceOwnership() public virtual onlyOwner {
689         emit OwnershipTransferred(_owner, address(0));
690         _owner = address(0);
691     }
692 
693     /**
694      * @dev Transfers ownership of the contract to a new account (`newOwner`).
695      * Can only be called by the current owner.
696      */
697     function transferOwnership(address newOwner) public virtual onlyOwner {
698         require(newOwner != address(0), "Ownable: new owner is the zero address");
699         emit OwnershipTransferred(_owner, newOwner);
700         _owner = newOwner;
701     }
702 }
703 
704 
705 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
706 
707 
708 
709 pragma solidity >=0.6.0 <0.8.0;
710 
711 /**
712  * @dev Library for managing
713  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
714  * types.
715  *
716  * Sets have the following properties:
717  *
718  * - Elements are added, removed, and checked for existence in constant time
719  * (O(1)).
720  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
721  *
722  * ```
723  * contract Example {
724  *     // Add the library methods
725  *     using EnumerableSet for EnumerableSet.AddressSet;
726  *
727  *     // Declare a set state variable
728  *     EnumerableSet.AddressSet private mySet;
729  * }
730  * ```
731  *
732  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
733  * and `uint256` (`UintSet`) are supported.
734  */
735 library EnumerableSet {
736     // To implement this library for multiple types with as little code
737     // repetition as possible, we write it in terms of a generic Set type with
738     // bytes32 values.
739     // The Set implementation uses private functions, and user-facing
740     // implementations (such as AddressSet) are just wrappers around the
741     // underlying Set.
742     // This means that we can only create new EnumerableSets for types that fit
743     // in bytes32.
744 
745     struct Set {
746         // Storage of set values
747         bytes32[] _values;
748 
749         // Position of the value in the `values` array, plus 1 because index 0
750         // means a value is not in the set.
751         mapping (bytes32 => uint256) _indexes;
752     }
753 
754     /**
755      * @dev Add a value to a set. O(1).
756      *
757      * Returns true if the value was added to the set, that is if it was not
758      * already present.
759      */
760     function _add(Set storage set, bytes32 value) private returns (bool) {
761         if (!_contains(set, value)) {
762             set._values.push(value);
763             // The value is stored at length-1, but we add 1 to all indexes
764             // and use 0 as a sentinel value
765             set._indexes[value] = set._values.length;
766             return true;
767         } else {
768             return false;
769         }
770     }
771 
772     /**
773      * @dev Removes a value from a set. O(1).
774      *
775      * Returns true if the value was removed from the set, that is if it was
776      * present.
777      */
778     function _remove(Set storage set, bytes32 value) private returns (bool) {
779         // We read and store the value's index to prevent multiple reads from the same storage slot
780         uint256 valueIndex = set._indexes[value];
781 
782         if (valueIndex != 0) { // Equivalent to contains(set, value)
783             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
784             // the array, and then remove the last element (sometimes called as 'swap and pop').
785             // This modifies the order of the array, as noted in {at}.
786 
787             uint256 toDeleteIndex = valueIndex - 1;
788             uint256 lastIndex = set._values.length - 1;
789 
790             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
791             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
792 
793             bytes32 lastvalue = set._values[lastIndex];
794 
795             // Move the last value to the index where the value to delete is
796             set._values[toDeleteIndex] = lastvalue;
797             // Update the index for the moved value
798             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
799 
800             // Delete the slot where the moved value was stored
801             set._values.pop();
802 
803             // Delete the index for the deleted slot
804             delete set._indexes[value];
805 
806             return true;
807         } else {
808             return false;
809         }
810     }
811 
812     /**
813      * @dev Returns true if the value is in the set. O(1).
814      */
815     function _contains(Set storage set, bytes32 value) private view returns (bool) {
816         return set._indexes[value] != 0;
817     }
818 
819     /**
820      * @dev Returns the number of values on the set. O(1).
821      */
822     function _length(Set storage set) private view returns (uint256) {
823         return set._values.length;
824     }
825 
826    /**
827     * @dev Returns the value stored at position `index` in the set. O(1).
828     *
829     * Note that there are no guarantees on the ordering of values inside the
830     * array, and it may change when more values are added or removed.
831     *
832     * Requirements:
833     *
834     * - `index` must be strictly less than {length}.
835     */
836     function _at(Set storage set, uint256 index) private view returns (bytes32) {
837         require(set._values.length > index, "EnumerableSet: index out of bounds");
838         return set._values[index];
839     }
840 
841     // Bytes32Set
842 
843     struct Bytes32Set {
844         Set _inner;
845     }
846 
847     /**
848      * @dev Add a value to a set. O(1).
849      *
850      * Returns true if the value was added to the set, that is if it was not
851      * already present.
852      */
853     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
854         return _add(set._inner, value);
855     }
856 
857     /**
858      * @dev Removes a value from a set. O(1).
859      *
860      * Returns true if the value was removed from the set, that is if it was
861      * present.
862      */
863     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
864         return _remove(set._inner, value);
865     }
866 
867     /**
868      * @dev Returns true if the value is in the set. O(1).
869      */
870     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
871         return _contains(set._inner, value);
872     }
873 
874     /**
875      * @dev Returns the number of values in the set. O(1).
876      */
877     function length(Bytes32Set storage set) internal view returns (uint256) {
878         return _length(set._inner);
879     }
880 
881    /**
882     * @dev Returns the value stored at position `index` in the set. O(1).
883     *
884     * Note that there are no guarantees on the ordering of values inside the
885     * array, and it may change when more values are added or removed.
886     *
887     * Requirements:
888     *
889     * - `index` must be strictly less than {length}.
890     */
891     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
892         return _at(set._inner, index);
893     }
894 
895     // AddressSet
896 
897     struct AddressSet {
898         Set _inner;
899     }
900 
901     /**
902      * @dev Add a value to a set. O(1).
903      *
904      * Returns true if the value was added to the set, that is if it was not
905      * already present.
906      */
907     function add(AddressSet storage set, address value) internal returns (bool) {
908         return _add(set._inner, bytes32(uint256(uint160(value))));
909     }
910 
911     /**
912      * @dev Removes a value from a set. O(1).
913      *
914      * Returns true if the value was removed from the set, that is if it was
915      * present.
916      */
917     function remove(AddressSet storage set, address value) internal returns (bool) {
918         return _remove(set._inner, bytes32(uint256(uint160(value))));
919     }
920 
921     /**
922      * @dev Returns true if the value is in the set. O(1).
923      */
924     function contains(AddressSet storage set, address value) internal view returns (bool) {
925         return _contains(set._inner, bytes32(uint256(uint160(value))));
926     }
927 
928     /**
929      * @dev Returns the number of values in the set. O(1).
930      */
931     function length(AddressSet storage set) internal view returns (uint256) {
932         return _length(set._inner);
933     }
934 
935    /**
936     * @dev Returns the value stored at position `index` in the set. O(1).
937     *
938     * Note that there are no guarantees on the ordering of values inside the
939     * array, and it may change when more values are added or removed.
940     *
941     * Requirements:
942     *
943     * - `index` must be strictly less than {length}.
944     */
945     function at(AddressSet storage set, uint256 index) internal view returns (address) {
946         return address(uint160(uint256(_at(set._inner, index))));
947     }
948 
949 
950     // UintSet
951 
952     struct UintSet {
953         Set _inner;
954     }
955 
956     /**
957      * @dev Add a value to a set. O(1).
958      *
959      * Returns true if the value was added to the set, that is if it was not
960      * already present.
961      */
962     function add(UintSet storage set, uint256 value) internal returns (bool) {
963         return _add(set._inner, bytes32(value));
964     }
965 
966     /**
967      * @dev Removes a value from a set. O(1).
968      *
969      * Returns true if the value was removed from the set, that is if it was
970      * present.
971      */
972     function remove(UintSet storage set, uint256 value) internal returns (bool) {
973         return _remove(set._inner, bytes32(value));
974     }
975 
976     /**
977      * @dev Returns true if the value is in the set. O(1).
978      */
979     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
980         return _contains(set._inner, bytes32(value));
981     }
982 
983     /**
984      * @dev Returns the number of values on the set. O(1).
985      */
986     function length(UintSet storage set) internal view returns (uint256) {
987         return _length(set._inner);
988     }
989 
990    /**
991     * @dev Returns the value stored at position `index` in the set. O(1).
992     *
993     * Note that there are no guarantees on the ordering of values inside the
994     * array, and it may change when more values are added or removed.
995     *
996     * Requirements:
997     *
998     * - `index` must be strictly less than {length}.
999     */
1000     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1001         return uint256(_at(set._inner, index));
1002     }
1003 }
1004 
1005 
1006 // File contracts/CCToken.sol
1007 
1008 
1009 pragma solidity ^0.6.0;
1010 
1011 
1012 
1013 abstract contract DelegateERC20 is ERC20 {
1014     // A record of each accounts delegate
1015     mapping (address => address) internal _delegates;
1016 
1017     /// @notice A checkpoint for marking number of votes from a given block
1018     struct Checkpoint {
1019         uint32 fromBlock;
1020         uint256 votes;
1021     }
1022 
1023     /// @notice A record of votes checkpoints for each account, by index
1024     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1025 
1026     /// @notice The number of checkpoints for each account
1027     mapping (address => uint32) public numCheckpoints;
1028 
1029     /// @notice The EIP-712 typehash for the contract's domain
1030     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1031 
1032     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1033     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1034 
1035     /// @notice A record of states for signing / validating signatures
1036     mapping (address => uint) public nonces;
1037 
1038 
1039     // support delegates mint
1040     function _mint(address account, uint256 amount) internal override virtual {
1041         super._mint(account, amount);
1042 
1043         // add delegates to the minter
1044         _moveDelegates(address(0), _delegates[account], amount);
1045     }
1046 
1047 
1048     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
1049         super._transfer(sender, recipient, amount);
1050         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1051     }
1052 
1053 
1054     /**
1055     * @notice Delegate votes from `msg.sender` to `delegatee`
1056     * @param delegatee The address to delegate votes to
1057     */
1058     function delegate(address delegatee) external {
1059         return _delegate(msg.sender, delegatee);
1060     }
1061 
1062     /**
1063      * @notice Delegates votes from signatory to `delegatee`
1064      * @param delegatee The address to delegate votes to
1065      * @param nonce The contract state required to match the signature
1066      * @param expiry The time at which to expire the signature
1067      * @param v The recovery byte of the signature
1068      * @param r Half of the ECDSA signature pair
1069      * @param s Half of the ECDSA signature pair
1070      */
1071     function delegateBySig(
1072         address delegatee,
1073         uint nonce,
1074         uint expiry,
1075         uint8 v,
1076         bytes32 r,
1077         bytes32 s
1078     )
1079     external
1080     {
1081         bytes32 domainSeparator = keccak256(
1082             abi.encode(
1083                 DOMAIN_TYPEHASH,
1084                 keccak256(bytes(name())),
1085                 getChainId(),
1086                 address(this)
1087             )
1088         );
1089 
1090         bytes32 structHash = keccak256(
1091             abi.encode(
1092                 DELEGATION_TYPEHASH,
1093                 delegatee,
1094                 nonce,
1095                 expiry
1096             )
1097         );
1098 
1099         bytes32 digest = keccak256(
1100             abi.encodePacked(
1101                 "\x19\x01",
1102                 domainSeparator,
1103                 structHash
1104             )
1105         );
1106 
1107         address signatory = ecrecover(digest, v, r, s);
1108         require(signatory != address(0), "CCToken::delegateBySig: invalid signature");
1109         require(nonce == nonces[signatory]++, "CCToken::delegateBySig: invalid nonce");
1110         require(now <= expiry, "CCToken::delegateBySig: signature expired");
1111         return _delegate(signatory, delegatee);
1112     }
1113 
1114     /**
1115      * @notice Gets the current votes balance for `account`
1116      * @param account The address to get votes balance
1117      * @return The number of current votes for `account`
1118      */
1119     function getCurrentVotes(address account)
1120     external
1121     view
1122     returns (uint256)
1123     {
1124         uint32 nCheckpoints = numCheckpoints[account];
1125         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1126     }
1127 
1128     /**
1129      * @notice Determine the prior number of votes for an account as of a block number
1130      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1131      * @param account The address of the account to check
1132      * @param blockNumber The block number to get the vote balance at
1133      * @return The number of votes the account had as of the given block
1134      */
1135     function getPriorVotes(address account, uint blockNumber)
1136     external
1137     view
1138     returns (uint256)
1139     {
1140         require(blockNumber < block.number, "CCToken::getPriorVotes: not yet determined");
1141 
1142         uint32 nCheckpoints = numCheckpoints[account];
1143         if (nCheckpoints == 0) {
1144             return 0;
1145         }
1146 
1147         // First check most recent balance
1148         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1149             return checkpoints[account][nCheckpoints - 1].votes;
1150         }
1151 
1152         // Next check implicit zero balance
1153         if (checkpoints[account][0].fromBlock > blockNumber) {
1154             return 0;
1155         }
1156 
1157         uint32 lower = 0;
1158         uint32 upper = nCheckpoints - 1;
1159         while (upper > lower) {
1160             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1161             Checkpoint memory cp = checkpoints[account][center];
1162             if (cp.fromBlock == blockNumber) {
1163                 return cp.votes;
1164             } else if (cp.fromBlock < blockNumber) {
1165                 lower = center;
1166             } else {
1167                 upper = center - 1;
1168             }
1169         }
1170         return checkpoints[account][lower].votes;
1171     }
1172 
1173     function _delegate(address delegator, address delegatee)
1174     internal
1175     {
1176         address currentDelegate = _delegates[delegator];
1177         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying balances (not scaled);
1178         _delegates[delegator] = delegatee;
1179 
1180         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1181 
1182         emit DelegateChanged(delegator, currentDelegate, delegatee);
1183     }
1184 
1185     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1186         if (srcRep != dstRep && amount > 0) {
1187             if (srcRep != address(0)) {
1188                 // decrease old representative
1189                 uint32 srcRepNum = numCheckpoints[srcRep];
1190                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1191                 uint256 srcRepNew = srcRepOld.sub(amount);
1192                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1193             }
1194 
1195             if (dstRep != address(0)) {
1196                 // increase new representative
1197                 uint32 dstRepNum = numCheckpoints[dstRep];
1198                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1199                 uint256 dstRepNew = dstRepOld.add(amount);
1200                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1201             }
1202         }
1203     }
1204 
1205     function _writeCheckpoint(
1206         address delegatee,
1207         uint32 nCheckpoints,
1208         uint256 oldVotes,
1209         uint256 newVotes
1210     )
1211     internal
1212     {
1213         uint32 blockNumber = safe32(block.number, "CCToken::_writeCheckpoint: block number exceeds 32 bits");
1214 
1215         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1216             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1217         } else {
1218             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1219             numCheckpoints[delegatee] = nCheckpoints + 1;
1220         }
1221 
1222         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1223     }
1224 
1225     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1226         require(n < 2**32, errorMessage);
1227         return uint32(n);
1228     }
1229 
1230     function getChainId() internal pure returns (uint) {
1231         uint256 chainId;
1232         assembly { chainId := chainid() }
1233 
1234         return chainId;
1235     }
1236 
1237     /// @notice An event thats emitted when an account changes its delegate
1238     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1239 
1240     /// @notice An event thats emitted when a delegate account's vote balance changes
1241     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1242 
1243 }
1244 
1245 contract CCToken is DelegateERC20, Ownable {
1246     uint256 private constant preMineSupply = 40000000 * 1e18;
1247     uint256 private constant maxSupply = 100000000 * 1e18;
1248 
1249     using EnumerableSet for EnumerableSet.AddressSet;
1250     EnumerableSet.AddressSet private _minters;
1251 
1252     constructor() public ERC20("CC Token", "CC") {
1253         _mint(msg.sender, preMineSupply);
1254     }
1255 
1256     function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
1257         if (_amount.add(totalSupply()) > maxSupply) {
1258             return false;
1259         }
1260         _mint(_to, _amount);
1261         return true;
1262     }
1263 
1264     function addMinter(address _addMinter) public onlyOwner returns (bool) {
1265         require(_addMinter != address(0), "CCToken: _addMinter is the zero address");
1266         return EnumerableSet.add(_minters, _addMinter);
1267     }
1268 
1269     function delMinter(address _delMinter) public onlyOwner returns (bool) {
1270         require(_delMinter != address(0), "CCToken: _delMinter is the zero address");
1271         return EnumerableSet.remove(_minters, _delMinter);
1272     }
1273 
1274     function getMinterLength() public view returns (uint256) {
1275         return EnumerableSet.length(_minters);
1276     }
1277 
1278     function isMinter(address account) public view returns (bool) {
1279         return EnumerableSet.contains(_minters, account);
1280     }
1281 
1282     function getMinter(uint256 _index) public view onlyOwner returns (address){
1283         require(_index <= getMinterLength() - 1, "CCToken: index out of bounds");
1284         return EnumerableSet.at(_minters, _index);
1285     }
1286 
1287     modifier onlyMinter() {
1288         require(isMinter(msg.sender), "CCToken: caller is not the minter");
1289         _;
1290     }
1291 
1292 }