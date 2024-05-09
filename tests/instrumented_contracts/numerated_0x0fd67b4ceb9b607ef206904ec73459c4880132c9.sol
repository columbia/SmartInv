1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 // Sources flattened with hardhat v2.6.4 https://hardhat.org
5 
6 // File @openzeppelin/contracts/utils/Context.sol@v3.4.0
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
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.0
31 
32 
33 
34 
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
110 
111 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
112 
113 
114 
115 
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         uint256 c = a + b;
138         if (c < a) return (false, 0);
139         return (true, c);
140     }
141 
142     /**
143      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
144      *
145      * _Available since v3.4._
146      */
147     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
148         if (b > a) return (false, 0);
149         return (true, a - b);
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
154      *
155      * _Available since v3.4._
156      */
157     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) return (true, 0);
162         uint256 c = a * b;
163         if (c / a != b) return (false, 0);
164         return (true, c);
165     }
166 
167     /**
168      * @dev Returns the division of two unsigned integers, with a division by zero flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         if (b == 0) return (false, 0);
174         return (true, a / b);
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
179      *
180      * _Available since v3.4._
181      */
182     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
183         if (b == 0) return (false, 0);
184         return (true, a % b);
185     }
186 
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      *
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         uint256 c = a + b;
199         require(c >= a, "SafeMath: addition overflow");
200         return c;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      *
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         require(b <= a, "SafeMath: subtraction overflow");
215         return a - b;
216     }
217 
218     /**
219      * @dev Returns the multiplication of two unsigned integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `*` operator.
223      *
224      * Requirements:
225      *
226      * - Multiplication cannot overflow.
227      */
228     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
229         if (a == 0) return 0;
230         uint256 c = a * b;
231         require(c / a == b, "SafeMath: multiplication overflow");
232         return c;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers, reverting on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         require(b > 0, "SafeMath: division by zero");
249         return a / b;
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * reverting when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         require(b > 0, "SafeMath: modulo by zero");
266         return a % b;
267     }
268 
269     /**
270      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
271      * overflow (when the result is negative).
272      *
273      * CAUTION: This function is deprecated because it requires allocating memory for the error
274      * message unnecessarily. For custom revert reasons use {trySub}.
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b <= a, errorMessage);
284         return a - b;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
289      * division by zero. The result is rounded towards zero.
290      *
291      * CAUTION: This function is deprecated because it requires allocating memory for the error
292      * message unnecessarily. For custom revert reasons use {tryDiv}.
293      *
294      * Counterpart to Solidity's `/` operator. Note: this function uses a
295      * `revert` opcode (which leaves remaining gas untouched) while Solidity
296      * uses an invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
303         require(b > 0, errorMessage);
304         return a / b;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * reverting with custom message when dividing by zero.
310      *
311      * CAUTION: This function is deprecated because it requires allocating memory for the error
312      * message unnecessarily. For custom revert reasons use {tryMod}.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      *
320      * - The divisor cannot be zero.
321      */
322     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
323         require(b > 0, errorMessage);
324         return a % b;
325     }
326 }
327 
328 
329 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.0
330 
331 
332 
333 
334 
335 
336 
337 /**
338  * @dev Implementation of the {IERC20} interface.
339  *
340  * This implementation is agnostic to the way tokens are created. This means
341  * that a supply mechanism has to be added in a derived contract using {_mint}.
342  * For a generic mechanism see {ERC20PresetMinterPauser}.
343  *
344  * TIP: For a detailed writeup see our guide
345  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
346  * to implement supply mechanisms].
347  *
348  * We have followed general OpenZeppelin guidelines: functions revert instead
349  * of returning `false` on failure. This behavior is nonetheless conventional
350  * and does not conflict with the expectations of ERC20 applications.
351  *
352  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
353  * This allows applications to reconstruct the allowance for all accounts just
354  * by listening to said events. Other implementations of the EIP may not emit
355  * these events, as it isn't required by the specification.
356  *
357  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
358  * functions have been added to mitigate the well-known issues around setting
359  * allowances. See {IERC20-approve}.
360  */
361 contract ERC20 is Context, IERC20 {
362     using SafeMath for uint256;
363 
364     mapping (address => uint256) private _balances;
365 
366     mapping (address => mapping (address => uint256)) private _allowances;
367 
368     uint256 private _totalSupply;
369 
370     string private _name;
371     string private _symbol;
372     uint8 private _decimals;
373 
374     /**
375      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
376      * a default value of 18.
377      *
378      * To select a different value for {decimals}, use {_setupDecimals}.
379      *
380      * All three of these values are immutable: they can only be set once during
381      * construction.
382      */
383     constructor (string memory name_, string memory symbol_) public {
384         _name = name_;
385         _symbol = symbol_;
386         _decimals = 18;
387     }
388 
389     /**
390      * @dev Returns the name of the token.
391      */
392     function name() public view virtual returns (string memory) {
393         return _name;
394     }
395 
396     /**
397      * @dev Returns the symbol of the token, usually a shorter version of the
398      * name.
399      */
400     function symbol() public view virtual returns (string memory) {
401         return _symbol;
402     }
403 
404     /**
405      * @dev Returns the number of decimals used to get its user representation.
406      * For example, if `decimals` equals `2`, a balance of `505` tokens should
407      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
408      *
409      * Tokens usually opt for a value of 18, imitating the relationship between
410      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
411      * called.
412      *
413      * NOTE: This information is only used for _display_ purposes: it in
414      * no way affects any of the arithmetic of the contract, including
415      * {IERC20-balanceOf} and {IERC20-transfer}.
416      */
417     function decimals() public view virtual returns (uint8) {
418         return _decimals;
419     }
420 
421     /**
422      * @dev See {IERC20-totalSupply}.
423      */
424     function totalSupply() public view virtual override returns (uint256) {
425         return _totalSupply;
426     }
427 
428     /**
429      * @dev See {IERC20-balanceOf}.
430      */
431     function balanceOf(address account) public view virtual override returns (uint256) {
432         return _balances[account];
433     }
434 
435     /**
436      * @dev See {IERC20-transfer}.
437      *
438      * Requirements:
439      *
440      * - `recipient` cannot be the zero address.
441      * - the caller must have a balance of at least `amount`.
442      */
443     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
444         _transfer(_msgSender(), recipient, amount);
445         return true;
446     }
447 
448     /**
449      * @dev See {IERC20-allowance}.
450      */
451     function allowance(address owner, address spender) public view virtual override returns (uint256) {
452         return _allowances[owner][spender];
453     }
454 
455     /**
456      * @dev See {IERC20-approve}.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      */
462     function approve(address spender, uint256 amount) public virtual override returns (bool) {
463         _approve(_msgSender(), spender, amount);
464         return true;
465     }
466 
467     /**
468      * @dev See {IERC20-transferFrom}.
469      *
470      * Emits an {Approval} event indicating the updated allowance. This is not
471      * required by the EIP. See the note at the beginning of {ERC20}.
472      *
473      * Requirements:
474      *
475      * - `sender` and `recipient` cannot be the zero address.
476      * - `sender` must have a balance of at least `amount`.
477      * - the caller must have allowance for ``sender``'s tokens of at least
478      * `amount`.
479      */
480     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
481         _transfer(sender, recipient, amount);
482         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
483         return true;
484     }
485 
486     /**
487      * @dev Atomically increases the allowance granted to `spender` by the caller.
488      *
489      * This is an alternative to {approve} that can be used as a mitigation for
490      * problems described in {IERC20-approve}.
491      *
492      * Emits an {Approval} event indicating the updated allowance.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      */
498     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
499         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
500         return true;
501     }
502 
503     /**
504      * @dev Atomically decreases the allowance granted to `spender` by the caller.
505      *
506      * This is an alternative to {approve} that can be used as a mitigation for
507      * problems described in {IERC20-approve}.
508      *
509      * Emits an {Approval} event indicating the updated allowance.
510      *
511      * Requirements:
512      *
513      * - `spender` cannot be the zero address.
514      * - `spender` must have allowance for the caller of at least
515      * `subtractedValue`.
516      */
517     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
518         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
519         return true;
520     }
521 
522     /**
523      * @dev Moves tokens `amount` from `sender` to `recipient`.
524      *
525      * This is internal function is equivalent to {transfer}, and can be used to
526      * e.g. implement automatic token fees, slashing mechanisms, etc.
527      *
528      * Emits a {Transfer} event.
529      *
530      * Requirements:
531      *
532      * - `sender` cannot be the zero address.
533      * - `recipient` cannot be the zero address.
534      * - `sender` must have a balance of at least `amount`.
535      */
536     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
537         require(sender != address(0), "ERC20: transfer from the zero address");
538         require(recipient != address(0), "ERC20: transfer to the zero address");
539 
540         _beforeTokenTransfer(sender, recipient, amount);
541 
542         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
543         _balances[recipient] = _balances[recipient].add(amount);
544         emit Transfer(sender, recipient, amount);
545     }
546 
547     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
548      * the total supply.
549      *
550      * Emits a {Transfer} event with `from` set to the zero address.
551      *
552      * Requirements:
553      *
554      * - `to` cannot be the zero address.
555      */
556     function _mint(address account, uint256 amount) internal virtual {
557         require(account != address(0), "ERC20: mint to the zero address");
558 
559         _beforeTokenTransfer(address(0), account, amount);
560 
561         _totalSupply = _totalSupply.add(amount);
562         _balances[account] = _balances[account].add(amount);
563         emit Transfer(address(0), account, amount);
564     }
565 
566     /**
567      * @dev Destroys `amount` tokens from `account`, reducing the
568      * total supply.
569      *
570      * Emits a {Transfer} event with `to` set to the zero address.
571      *
572      * Requirements:
573      *
574      * - `account` cannot be the zero address.
575      * - `account` must have at least `amount` tokens.
576      */
577     function _burn(address account, uint256 amount) internal virtual {
578         require(account != address(0), "ERC20: burn from the zero address");
579 
580         _beforeTokenTransfer(account, address(0), amount);
581 
582         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
583         _totalSupply = _totalSupply.sub(amount);
584         emit Transfer(account, address(0), amount);
585     }
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
589      *
590      * This internal function is equivalent to `approve`, and can be used to
591      * e.g. set automatic allowances for certain subsystems, etc.
592      *
593      * Emits an {Approval} event.
594      *
595      * Requirements:
596      *
597      * - `owner` cannot be the zero address.
598      * - `spender` cannot be the zero address.
599      */
600     function _approve(address owner, address spender, uint256 amount) internal virtual {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607 
608     /**
609      * @dev Sets {decimals} to a value other than the default one of 18.
610      *
611      * WARNING: This function should only be called from the constructor. Most
612      * applications that interact with token contracts will not expect
613      * {decimals} to ever change, and may work incorrectly if it does.
614      */
615     function _setupDecimals(uint8 decimals_) internal virtual {
616         _decimals = decimals_;
617     }
618 
619     /**
620      * @dev Hook that is called before any transfer of tokens. This includes
621      * minting and burning.
622      *
623      * Calling conditions:
624      *
625      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
626      * will be to transferred to `to`.
627      * - when `from` is zero, `amount` tokens will be minted for `to`.
628      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
629      * - `from` and `to` are never both zero.
630      *
631      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
632      */
633     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
634 }
635 
636 
637 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
638 
639 
640 
641 
642 
643 /**
644  * @dev Contract module which provides a basic access control mechanism, where
645  * there is an account (an owner) that can be granted exclusive access to
646  * specific functions.
647  *
648  * By default, the owner account will be the one that deploys the contract. This
649  * can later be changed with {transferOwnership}.
650  *
651  * This module is used through inheritance. It will make available the modifier
652  * `onlyOwner`, which can be applied to your functions to restrict their use to
653  * the owner.
654  */
655 abstract contract Ownable is Context {
656     address private _owner;
657 
658     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
659 
660     /**
661      * @dev Initializes the contract setting the deployer as the initial owner.
662      */
663     constructor () internal {
664         address msgSender = _msgSender();
665         _owner = msgSender;
666         emit OwnershipTransferred(address(0), msgSender);
667     }
668 
669     /**
670      * @dev Returns the address of the current owner.
671      */
672     function owner() public view virtual returns (address) {
673         return _owner;
674     }
675 
676     /**
677      * @dev Throws if called by any account other than the owner.
678      */
679     modifier onlyOwner() {
680         require(owner() == _msgSender(), "Ownable: caller is not the owner");
681         _;
682     }
683 
684     /**
685      * @dev Leaves the contract without owner. It will not be possible to call
686      * `onlyOwner` functions anymore. Can only be called by the current owner.
687      *
688      * NOTE: Renouncing ownership will leave the contract without an owner,
689      * thereby removing any functionality that is only available to the owner.
690      */
691     function renounceOwnership() public virtual onlyOwner {
692         emit OwnershipTransferred(_owner, address(0));
693         _owner = address(0);
694     }
695 
696     /**
697      * @dev Transfers ownership of the contract to a new account (`newOwner`).
698      * Can only be called by the current owner.
699      */
700     function transferOwnership(address newOwner) public virtual onlyOwner {
701         require(newOwner != address(0), "Ownable: new owner is the zero address");
702         emit OwnershipTransferred(_owner, newOwner);
703         _owner = newOwner;
704     }
705 }
706 
707 
708 // File contracts/ShoeToken.sol
709 
710 
711 contract ShoeToken is ERC20("ShoeFy", "SHOE"), Ownable {
712     constructor(address beneficiary) public {
713         require(
714             beneficiary != address(0),
715             "beneficiary cannot be the 0 address"
716         );
717         uint256 supply = 100000000 ether;
718         _mint(beneficiary, supply);
719     }
720 }