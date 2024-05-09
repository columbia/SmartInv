1 /* contracts/CovalentQueryToken.sol */
2 pragma solidity 0.6.2;
3 
4 /* imported: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol */
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /* imported: openzeppelin-solidity/contracts/utils/Context.sol */
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity >=0.6.0 <0.8.0;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 
36 /* imported: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol */
37 // SPDX-License-Identifier: MIT
38 
39 pragma solidity >=0.6.0 <0.8.0;
40 
41 /**
42  * @dev Interface of the ERC20 standard as defined in the EIP.
43  */
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 /* imported: openzeppelin-solidity/contracts/math/SafeMath.sol */
116 // SPDX-License-Identifier: MIT
117 
118 pragma solidity >=0.6.0 <0.8.0;
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134     /**
135      * @dev Returns the addition of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         uint256 c = a + b;
141         if (c < a) return (false, 0);
142         return (true, c);
143     }
144 
145     /**
146      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         if (b > a) return (false, 0);
152         return (true, a - b);
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) return (true, 0);
165         uint256 c = a * b;
166         if (c / a != b) return (false, 0);
167         return (true, c);
168     }
169 
170     /**
171      * @dev Returns the division of two unsigned integers, with a division by zero flag.
172      *
173      * _Available since v3.4._
174      */
175     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         if (b == 0) return (false, 0);
177         return (true, a / b);
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
182      *
183      * _Available since v3.4._
184      */
185     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
186         if (b == 0) return (false, 0);
187         return (true, a % b);
188     }
189 
190     /**
191      * @dev Returns the addition of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `+` operator.
195      *
196      * Requirements:
197      *
198      * - Addition cannot overflow.
199      */
200     function add(uint256 a, uint256 b) internal pure returns (uint256) {
201         uint256 c = a + b;
202         require(c >= a, "SafeMath: addition overflow");
203         return c;
204     }
205 
206     /**
207      * @dev Returns the subtraction of two unsigned integers, reverting on
208      * overflow (when the result is negative).
209      *
210      * Counterpart to Solidity's `-` operator.
211      *
212      * Requirements:
213      *
214      * - Subtraction cannot overflow.
215      */
216     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217         require(b <= a, "SafeMath: subtraction overflow");
218         return a - b;
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `*` operator.
226      *
227      * Requirements:
228      *
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         if (a == 0) return 0;
233         uint256 c = a * b;
234         require(c / a == b, "SafeMath: multiplication overflow");
235         return c;
236     }
237 
238     /**
239      * @dev Returns the integer division of two unsigned integers, reverting on
240      * division by zero. The result is rounded towards zero.
241      *
242      * Counterpart to Solidity's `/` operator. Note: this function uses a
243      * `revert` opcode (which leaves remaining gas untouched) while Solidity
244      * uses an invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         require(b > 0, "SafeMath: division by zero");
252         return a / b;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * reverting when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         require(b > 0, "SafeMath: modulo by zero");
269         return a % b;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
274      * overflow (when the result is negative).
275      *
276      * CAUTION: This function is deprecated because it requires allocating memory for the error
277      * message unnecessarily. For custom revert reasons use {trySub}.
278      *
279      * Counterpart to Solidity's `-` operator.
280      *
281      * Requirements:
282      *
283      * - Subtraction cannot overflow.
284      */
285     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b <= a, errorMessage);
287         return a - b;
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
292      * division by zero. The result is rounded towards zero.
293      *
294      * CAUTION: This function is deprecated because it requires allocating memory for the error
295      * message unnecessarily. For custom revert reasons use {tryDiv}.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         require(b > 0, errorMessage);
307         return a / b;
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * reverting with custom message when dividing by zero.
313      *
314      * CAUTION: This function is deprecated because it requires allocating memory for the error
315      * message unnecessarily. For custom revert reasons use {tryMod}.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
326         require(b > 0, errorMessage);
327         return a % b;
328     }
329 }
330 
331 /**
332  * @dev Implementation of the {IERC20} interface.
333  *
334  * This implementation is agnostic to the way tokens are created. This means
335  * that a supply mechanism has to be added in a derived contract using {_mint}.
336  * For a generic mechanism see {ERC20PresetMinterPauser}.
337  *
338  * TIP: For a detailed writeup see our guide
339  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
340  * to implement supply mechanisms].
341  *
342  * We have followed general OpenZeppelin guidelines: functions revert instead
343  * of returning `false` on failure. This behavior is nonetheless conventional
344  * and does not conflict with the expectations of ERC20 applications.
345  *
346  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
347  * This allows applications to reconstruct the allowance for all accounts just
348  * by listening to said events. Other implementations of the EIP may not emit
349  * these events, as it isn't required by the specification.
350  *
351  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
352  * functions have been added to mitigate the well-known issues around setting
353  * allowances. See {IERC20-approve}.
354  */
355 contract ERC20 is Context, IERC20 {
356     using SafeMath for uint256;
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
377     constructor (string memory name_, string memory symbol_) public {
378         _name = name_;
379         _symbol = symbol_;
380         _decimals = 18;
381     }
382 
383     /**
384      * @dev Returns the name of the token.
385      */
386     function name() public view virtual returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @dev Returns the symbol of the token, usually a shorter version of the
392      * name.
393      */
394     function symbol() public view virtual returns (string memory) {
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
411     function decimals() public view virtual returns (uint8) {
412         return _decimals;
413     }
414 
415     /**
416      * @dev See {IERC20-totalSupply}.
417      */
418     function totalSupply() public view virtual override returns (uint256) {
419         return _totalSupply;
420     }
421 
422     /**
423      * @dev See {IERC20-balanceOf}.
424      */
425     function balanceOf(address account) public view virtual override returns (uint256) {
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
465      * required by the EIP. See the note at the beginning of {ERC20}.
466      *
467      * Requirements:
468      *
469      * - `sender` and `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      * - the caller must have allowance for ``sender``'s tokens of at least
472      * `amount`.
473      */
474     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
475         _transfer(sender, recipient, amount);
476         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
477         return true;
478     }
479 
480     /**
481      * @dev Atomically increases the allowance granted to `spender` by the caller.
482      *
483      * This is an alternative to {approve} that can be used as a mitigation for
484      * problems described in {IERC20-approve}.
485      *
486      * Emits an {Approval} event indicating the updated allowance.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      */
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
494         return true;
495     }
496 
497     /**
498      * @dev Atomically decreases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      * - `spender` must have allowance for the caller of at least
509      * `subtractedValue`.
510      */
511     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
513         return true;
514     }
515 
516     /**
517      * @dev Moves tokens `amount` from `sender` to `recipient`.
518      *
519      * This is internal function is equivalent to {transfer}, and can be used to
520      * e.g. implement automatic token fees, slashing mechanisms, etc.
521      *
522      * Emits a {Transfer} event.
523      *
524      * Requirements:
525      *
526      * - `sender` cannot be the zero address.
527      * - `recipient` cannot be the zero address.
528      * - `sender` must have a balance of at least `amount`.
529      */
530     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
531         require(sender != address(0), "ERC20: transfer from the zero address");
532         require(recipient != address(0), "ERC20: transfer to the zero address");
533 
534         _beforeTokenTransfer(sender, recipient, amount);
535 
536         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
537         _balances[recipient] = _balances[recipient].add(amount);
538         emit Transfer(sender, recipient, amount);
539     }
540 
541     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
542      * the total supply.
543      *
544      * Emits a {Transfer} event with `from` set to the zero address.
545      *
546      * Requirements:
547      *
548      * - `to` cannot be the zero address.
549      */
550     function _mint(address account, uint256 amount) internal virtual {
551         require(account != address(0), "ERC20: mint to the zero address");
552 
553         _beforeTokenTransfer(address(0), account, amount);
554 
555         _totalSupply = _totalSupply.add(amount);
556         _balances[account] = _balances[account].add(amount);
557         emit Transfer(address(0), account, amount);
558     }
559 
560     /**
561      * @dev Destroys `amount` tokens from `account`, reducing the
562      * total supply.
563      *
564      * Emits a {Transfer} event with `to` set to the zero address.
565      *
566      * Requirements:
567      *
568      * - `account` cannot be the zero address.
569      * - `account` must have at least `amount` tokens.
570      */
571     function _burn(address account, uint256 amount) internal virtual {
572         require(account != address(0), "ERC20: burn from the zero address");
573 
574         _beforeTokenTransfer(account, address(0), amount);
575 
576         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
577         _totalSupply = _totalSupply.sub(amount);
578         emit Transfer(account, address(0), amount);
579     }
580 
581     /**
582      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
583      *
584      * This internal function is equivalent to `approve`, and can be used to
585      * e.g. set automatic allowances for certain subsystems, etc.
586      *
587      * Emits an {Approval} event.
588      *
589      * Requirements:
590      *
591      * - `owner` cannot be the zero address.
592      * - `spender` cannot be the zero address.
593      */
594     function _approve(address owner, address spender, uint256 amount) internal virtual {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     /**
603      * @dev Sets {decimals} to a value other than the default one of 18.
604      *
605      * WARNING: This function should only be called from the constructor. Most
606      * applications that interact with token contracts will not expect
607      * {decimals} to ever change, and may work incorrectly if it does.
608      */
609     function _setupDecimals(uint8 decimals_) internal virtual {
610         _decimals = decimals_;
611     }
612 
613     /**
614      * @dev Hook that is called before any transfer of tokens. This includes
615      * minting and burning.
616      *
617      * Calling conditions:
618      *
619      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
620      * will be to transferred to `to`.
621      * - when `from` is zero, `amount` tokens will be minted for `to`.
622      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
623      * - `from` and `to` are never both zero.
624      *
625      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
626      */
627     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
628 }
629 
630 
631 /* imported: openzeppelin-solidity/contracts/access/Ownable.sol */
632 // SPDX-License-Identifier: MIT
633 
634 pragma solidity >=0.6.0 <0.8.0;
635 
636 /**
637  * @dev Contract module which provides a basic access control mechanism, where
638  * there is an account (an owner) that can be granted exclusive access to
639  * specific functions.
640  *
641  * By default, the owner account will be the one that deploys the contract. This
642  * can later be changed with {transferOwnership}.
643  *
644  * This module is used through inheritance. It will make available the modifier
645  * `onlyOwner`, which can be applied to your functions to restrict their use to
646  * the owner.
647  */
648 abstract contract Ownable is Context {
649     address private _owner;
650 
651     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
652 
653     /**
654      * @dev Initializes the contract setting the deployer as the initial owner.
655      */
656     constructor () internal {
657         address msgSender = _msgSender();
658         _owner = msgSender;
659         emit OwnershipTransferred(address(0), msgSender);
660     }
661 
662     /**
663      * @dev Returns the address of the current owner.
664      */
665     function owner() public view virtual returns (address) {
666         return _owner;
667     }
668 
669     /**
670      * @dev Throws if called by any account other than the owner.
671      */
672     modifier onlyOwner() {
673         require(owner() == _msgSender(), "Ownable: caller is not the owner");
674         _;
675     }
676 
677     /**
678      * @dev Leaves the contract without owner. It will not be possible to call
679      * `onlyOwner` functions anymore. Can only be called by the current owner.
680      *
681      * NOTE: Renouncing ownership will leave the contract without an owner,
682      * thereby removing any functionality that is only available to the owner.
683      */
684     function renounceOwnership() public virtual onlyOwner {
685         emit OwnershipTransferred(_owner, address(0));
686         _owner = address(0);
687     }
688 
689     /**
690      * @dev Transfers ownership of the contract to a new account (`newOwner`).
691      * Can only be called by the current owner.
692      */
693     function transferOwnership(address newOwner) public virtual onlyOwner {
694         require(newOwner != address(0), "Ownable: new owner is the zero address");
695         emit OwnershipTransferred(_owner, newOwner);
696         _owner = newOwner;
697     }
698 }
699 
700 
701 /* imported: contracts/ERC20Permit/ERC20Permit.sol */
702 pragma solidity 0.6.2;
703 
704 /* imported: openzeppelin-solidity/contracts/utils/Counters.sol */
705 // SPDX-License-Identifier: MIT
706 
707 pragma solidity >=0.6.0 <0.8.0;
708 
709 /**
710  * @title Counters
711  * @author Matt Condon (@shrugs)
712  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
713  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
714  *
715  * Include with `using Counters for Counters.Counter;`
716  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
717  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
718  * directly accessed.
719  */
720 library Counters {
721     using SafeMath for uint256;
722 
723     struct Counter {
724         // This variable should never be directly accessed by users of the library: interactions must be restricted to
725         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
726         // this feature: see https://github.com/ethereum/solidity/issues/4637
727         uint256 _value; // default: 0
728     }
729 
730     function current(Counter storage counter) internal view returns (uint256) {
731         return counter._value;
732     }
733 
734     function increment(Counter storage counter) internal {
735         // The {SafeMath} overflow check can be skipped here, see the comment at the top
736         counter._value += 1;
737     }
738 
739     function decrement(Counter storage counter) internal {
740         counter._value = counter._value.sub(1);
741     }
742 }
743 
744 /* imported: contracts/ERC20Permit/IERC2612Permit.sol */
745 pragma solidity 0.6.2;
746 
747 /**
748  * @dev Interface of the ERC2612 standard as defined in the EIP.
749  * https://github.com/nventuro/openzeppelin-contracts/blob/erc20-permit/contracts/token/ERC20/IERC2612Permit.sol
750  * Commit 48c41dfc625edeac829a803a4cc0d02de3638705
751  * Adds the {permit} method, which can be used to change one's
752  * {IERC20-allowance} without having to send a transaction, by signing a
753  * message. This allows users to spend tokens without having to hold Ether.
754  *
755  * See https://eips.ethereum.org/EIPS/eip-2612.
756  */
757 interface IERC2612Permit {
758     /**
759      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
760      * given `owner`'s signed approval.
761      *
762      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
763      * ordering also apply here.
764      *
765      * Emits an {Approval} event.
766      *
767      * Requirements:
768      *
769      * - `owner` cannot be the zero address.
770      * - `spender` cannot be the zero address.
771      * - `deadline` must be a timestamp in the future.
772      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
773      * over the EIP712-formatted function arguments.
774      * - the signature must use ``owner``'s current nonce (see {nonces}).
775      *
776      * For more information on the signature format, see the
777      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
778      * section].
779      */
780     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
781 
782     /**
783      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
784      * included whenever a signature is generated for {permit}.
785      *
786      * Every successful call to {permit} increases ``owner``'s nonce by one. This
787      * prevents a signature from being used multiple times.
788      */
789     function nonces(address owner) external view returns (uint256);
790 }
791 
792 
793 /**
794  * @dev Extension of {ERC20} that allows token holders to use their tokens
795  * without sending any transactions by setting {IERC20-allowance} with a
796  * signature using the {permit} method, and then spend them via
797  * {IERC20-transferFrom}.
798  */
799 abstract contract ERC20Permit is ERC20, IERC2612Permit {
800     using Counters for Counters.Counter;
801 
802     mapping (address => Counters.Counter) private _nonces;
803 
804     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
805     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
806 
807     bytes32 public DOMAIN_SEPARATOR;
808 
809     constructor() internal {
810         uint256 chainID;
811         assembly {
812             chainID := chainid()
813         }
814 
815         DOMAIN_SEPARATOR = keccak256(
816             abi.encode(
817                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
818                 keccak256(bytes(name())),
819                 keccak256(bytes("1")), // Version
820                 chainID,
821                 address(this)
822             )
823         );
824     }
825 
826     /**
827      * @dev See {IERC2612Permit-permit}.
828      * v,r,s params are ecdsa signature output for more information please see ethereum ecdsa specs.
829      * Apendix-f of https://ethereum.github.io/yellowpaper/paper.pdf.
830      * @param owner token owner
831      * @param spender user address which is allowed to spend tokens
832      * @param amount number of token to be spent
833      * @param deadline validity for spending the tokens
834      * @param v recovery identifier of ecdsa signature
835      * @param r r value/ x-value of ecdsa signature
836      * @param s s value of ecdsa signature
837      */
838     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
839         require(block.timestamp <= deadline, "CovalentPermit: expired deadline");
840 
841         bytes32 hashStruct = keccak256(
842             abi.encode(
843                 PERMIT_TYPEHASH,
844                 owner,
845                 spender,
846                 amount,
847                 _nonces[owner].current(),
848                 deadline
849             )
850         );
851 
852         bytes32 _hash = keccak256(
853             abi.encodePacked(
854                 uint16(0x1901),
855                 DOMAIN_SEPARATOR,
856                 hashStruct
857             )
858         );
859 
860         address signer = ecrecover(_hash, v, r, s);
861         require(signer != address(0) && signer == owner, "CovalentPermit: Invalid signature");
862 
863         _nonces[owner].increment();
864         _approve(owner, spender, amount);
865     }
866 
867     /**
868      * @dev See {IERC2612Permit-nonces}.
869      * @param owner token owner
870      * @return current nonce of the owner address
871      */
872     function nonces(address owner) public view override returns (uint256) {
873         return _nonces[owner].current();
874     }
875 }
876 
877 
878 /**
879  * @title CovalentQueryToken
880  * @dev Covalent ERC20 Token
881  */
882 contract CovalentQueryToken is ERC20Permit,  Ownable {
883     constructor (string memory name, string memory symbol, uint256 totalSupply)
884     public
885     ERC20 (name, symbol) {
886         _mint(msg.sender, totalSupply);
887     }
888 
889     /**
890      * @notice Function to rescue funds
891      * Owner is assumed to be a governance/multi-sig, Which will be used to rescue accidently sent user tokens
892      * In case of no use this funtion can be disabled by destroying ownership via `renounceOwnership` function
893      * @param token Address of token to be rescued
894      * @param destination User address
895      * @param amount Amount of tokens
896      */
897     function rescueTokens(address token, address destination, uint256 amount) external onlyOwner {
898         require(token != destination, "Invalid address");
899         require(ERC20(token).transfer(destination, amount), "Retrieve failed");
900     }
901 }