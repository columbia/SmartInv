1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17   function _msgSender() internal view virtual returns (address payable) {
18     return msg.sender;
19   }
20 
21   function _msgData() internal view virtual returns (bytes memory) {
22     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23     return msg.data;
24   }
25 }
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
41   /**
42     * @dev Returns the addition of two unsigned integers, reverting on
43     * overflow.
44     *
45     * Counterpart to Solidity's `+` operator.
46     *
47     * Requirements:
48     *
49     * - Addition cannot overflow.
50     */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     require(c >= a, "SafeMath: addition overflow");
54 
55     return c;
56   }
57 
58   /**
59     * @dev Returns the subtraction of two unsigned integers, reverting on
60     * overflow (when the result is negative).
61     *
62     * Counterpart to Solidity's `-` operator.
63     *
64     * Requirements:
65     *
66     * - Subtraction cannot overflow.
67     */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     return sub(a, b, "SafeMath: subtraction overflow");
70   }
71 
72   /**
73     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
74     * overflow (when the result is negative).
75     *
76     * Counterpart to Solidity's `-` operator.
77     *
78     * Requirements:
79     *
80     * - Subtraction cannot overflow.
81     */
82   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83     require(b <= a, errorMessage);
84     uint256 c = a - b;
85 
86     return c;
87   }
88 
89   /**
90     * @dev Returns the multiplication of two unsigned integers, reverting on
91     * overflow.
92     *
93     * Counterpart to Solidity's `*` operator.
94     *
95     * Requirements:
96     *
97     * - Multiplication cannot overflow.
98     */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101     // benefit is lost if 'b' is also tested.
102     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
103     if (a == 0) {
104       return 0;
105     }
106 
107     uint256 c = a * b;
108     require(c / a == b, "SafeMath: multiplication overflow");
109 
110     return c;
111   }
112 
113   /**
114     * @dev Returns the integer division of two unsigned integers. Reverts on
115     * division by zero. The result is rounded towards zero.
116     *
117     * Counterpart to Solidity's `/` operator. Note: this function uses a
118     * `revert` opcode (which leaves remaining gas untouched) while Solidity
119     * uses an invalid opcode to revert (consuming all remaining gas).
120     *
121     * Requirements:
122     *
123     * - The divisor cannot be zero.
124     */
125   function div(uint256 a, uint256 b) internal pure returns (uint256) {
126     return div(a, b, "SafeMath: division by zero");
127   }
128 
129   /**
130     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
131     * division by zero. The result is rounded towards zero.
132     *
133     * Counterpart to Solidity's `/` operator. Note: this function uses a
134     * `revert` opcode (which leaves remaining gas untouched) while Solidity
135     * uses an invalid opcode to revert (consuming all remaining gas).
136     *
137     * Requirements:
138     *
139     * - The divisor cannot be zero.
140     */
141   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142     require(b > 0, errorMessage);
143     uint256 c = a / b;
144     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145 
146     return c;
147   }
148 
149   /**
150     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151     * Reverts when dividing by zero.
152     *
153     * Counterpart to Solidity's `%` operator. This function uses a `revert`
154     * opcode (which leaves remaining gas untouched) while Solidity uses an
155     * invalid opcode to revert (consuming all remaining gas).
156     *
157     * Requirements:
158     *
159     * - The divisor cannot be zero.
160     */
161   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162     return mod(a, b, "SafeMath: modulo by zero");
163   }
164 
165   /**
166     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167     * Reverts with custom message when dividing by zero.
168     *
169     * Counterpart to Solidity's `%` operator. This function uses a `revert`
170     * opcode (which leaves remaining gas untouched) while Solidity uses an
171     * invalid opcode to revert (consuming all remaining gas).
172     *
173     * Requirements:
174     *
175     * - The divisor cannot be zero.
176     */
177   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178     require(b != 0, errorMessage);
179     return a % b;
180   }
181 }
182 
183 /**
184  * @dev Contract module which allows children to implement an emergency stop
185  * mechanism that can be triggered by an authorized account.
186  *
187  * This module is used through inheritance. It will make available the
188  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
189  * the functions of your contract. Note that they will not be pausable by
190  * simply including this module, only once the modifiers are put in place.
191  */
192 contract Pausable is Context {
193   /**
194     * @dev Emitted when the pause is triggered by `account`.
195     */
196   event Paused(address account);
197 
198   /**
199     * @dev Emitted when the pause is lifted by `account`.
200     */
201   event Unpaused(address account);
202 
203   bool private _paused;
204 
205   /**
206     * @dev Initializes the contract in unpaused state.
207     */
208   constructor () internal {
209     _paused = false;
210   }
211 
212   /**
213     * @dev Returns true if the contract is paused, and false otherwise.
214     */
215   function paused() public view returns (bool) {
216     return _paused;
217   }
218 
219   /**
220     * @dev Modifier to make a function callable only when the contract is not paused.
221     *
222     * Requirements:
223     *
224     * - The contract must not be paused.
225     */
226   modifier whenNotPaused() {
227     require(!_paused, "Pausable: paused");
228     _;
229   }
230 
231   /**
232     * @dev Modifier to make a function callable only when the contract is paused.
233     *
234     * Requirements:
235     *
236     * - The contract must be paused.
237     */
238   modifier whenPaused() {
239     require(_paused, "Pausable: not paused");
240     _;
241   }
242 
243   /**
244     * @dev Triggers stopped state.
245     *
246     * Requirements:
247     *
248     * - The contract must not be paused.
249     */
250   function _pause() internal virtual whenNotPaused {
251     _paused = true;
252     emit Paused(_msgSender());
253   }
254 
255   /**
256     * @dev Returns to normal state.
257     *
258     * Requirements:
259     *
260     * - The contract must be paused.
261     */
262   function _unpause() internal virtual whenPaused {
263     _paused = false;
264     emit Unpaused(_msgSender());
265   }
266 }
267 
268 
269 /**
270  * @dev Interface of the ERC20 standard as defined in the EIP.
271  */
272 interface IERC20 {
273   /**
274     * @dev Returns the amount of tokens in existence.
275     */
276   function totalSupply() external view returns (uint256);
277 
278   /**
279     * @dev Returns the amount of tokens owned by `account`.
280     */
281   function balanceOf(address account) external view returns (uint256);
282 
283   /**
284     * @dev Moves `amount` tokens from the caller's account to `recipient`.
285     *
286     * Returns a boolean value indicating whether the operation succeeded.
287     *
288     * Emits a {Transfer} event.
289     */
290   function transfer(address recipient, uint256 amount) external returns (bool);
291 
292   /**
293     * @dev Returns the remaining number of tokens that `spender` will be
294     * allowed to spend on behalf of `owner` through {transferFrom}. This is
295     * zero by default.
296     *
297     * This value changes when {approve} or {transferFrom} are called.
298     */
299   function allowance(address owner, address spender) external view returns (uint256);
300 
301   /**
302     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
303     *
304     * Returns a boolean value indicating whether the operation succeeded.
305     *
306     * IMPORTANT: Beware that changing an allowance with this method brings the risk
307     * that someone may use both the old and the new allowance by unfortunate
308     * transaction ordering. One possible solution to mitigate this race
309     * condition is to first reduce the spender's allowance to 0 and set the
310     * desired value afterwards:
311     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312     *
313     * Emits an {Approval} event.
314     */
315   function approve(address spender, uint256 amount) external returns (bool);
316 
317   /**
318     * @dev Moves `amount` tokens from `sender` to `recipient` using the
319     * allowance mechanism. `amount` is then deducted from the caller's
320     * allowance.
321     *
322     * Returns a boolean value indicating whether the operation succeeded.
323     *
324     * Emits a {Transfer} event.
325     */
326   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
327 
328   /**
329     * @dev Emitted when `value` tokens are moved from one account (`from`) to
330     * another (`to`).
331     *
332     * Note that `value` may be zero.
333     */
334   event Transfer(address indexed from, address indexed to, uint256 value);
335 
336   /**
337     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
338     * a call to {approve}. `value` is the new allowance.
339     */
340   event Approval(address indexed owner, address indexed spender, uint256 value);
341 }
342 
343 
344 /**
345  * @dev Implementation of the {IERC20} interface.
346  *
347  * This implementation is agnostic to the way tokens are created. This means
348  * that a supply mechanism has to be added in a derived contract using {_mint}.
349  * For a generic mechanism see {ERC20PresetMinterPauser}.
350  *
351  * TIP: For a detailed writeup see our guide
352  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
353  * to implement supply mechanisms].
354  *
355  * We have followed general OpenZeppelin guidelines: functions revert instead
356  * of returning `false` on failure. This behavior is nonetheless conventional
357  * and does not conflict with the expectations of ERC20 applications.
358  *
359  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
360  * This allows applications to reconstruct the allowance for all accounts just
361  * by listening to said events. Other implementations of the EIP may not emit
362  * these events, as it isn't required by the specification.
363  *
364  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
365  * functions have been added to mitigate the well-known issues around setting
366  * allowances. See {IERC20-approve}.
367  */
368 contract ERC20 is Context, IERC20 {
369   using SafeMath for uint256;
370 
371   mapping (address => uint256) private _balances;
372 
373   mapping (address => mapping (address => uint256)) private _allowances;
374 
375   uint256 private _totalSupply;
376 
377   string private _name;
378   string private _symbol;
379   uint8 private _decimals;
380 
381   /**
382     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
383     * a default value of 18.
384     *
385     * To select a different value for {decimals}, use {_setupDecimals}.
386     *
387     * All three of these values are immutable: they can only be set once during
388     * construction.
389     */
390   constructor (string memory name_, string memory symbol_) public {
391     _name = name_;
392     _symbol = symbol_;
393     _decimals = 18;
394   }
395 
396   /**
397     * @dev Returns the name of the token.
398     */
399   function name() public view returns (string memory) {
400     return _name;
401   }
402 
403   /**
404     * @dev Returns the symbol of the token, usually a shorter version of the
405     * name.
406     */
407   function symbol() public view returns (string memory) {
408     return _symbol;
409   }
410 
411   /**
412     * @dev Returns the number of decimals used to get its user representation.
413     * For example, if `decimals` equals `2`, a balance of `505` tokens should
414     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
415     *
416     * Tokens usually opt for a value of 18, imitating the relationship between
417     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
418     * called.
419     *
420     * NOTE: This information is only used for _display_ purposes: it in
421     * no way affects any of the arithmetic of the contract, including
422     * {IERC20-balanceOf} and {IERC20-transfer}.
423     */
424   function decimals() public view returns (uint8) {
425     return _decimals;
426   }
427 
428   /**
429     * @dev See {IERC20-totalSupply}.
430     */
431   function totalSupply() public view override returns (uint256) {
432     return _totalSupply;
433   }
434 
435   /**
436     * @dev See {IERC20-balanceOf}.
437     */
438   function balanceOf(address account) public view override returns (uint256) {
439     return _balances[account];
440   }
441 
442   /**
443     * @dev See {IERC20-transfer}.
444     *
445     * Requirements:
446     *
447     * - `recipient` cannot be the zero address.
448     * - the caller must have a balance of at least `amount`.
449     */
450   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
451     _transfer(_msgSender(), recipient, amount);
452     return true;
453   }
454 
455   /**
456     * @dev See {IERC20-allowance}.
457     */
458   function allowance(address owner, address spender) public view virtual override returns (uint256) {
459     return _allowances[owner][spender];
460   }
461 
462   /**
463     * @dev See {IERC20-approve}.
464     *
465     * Requirements:
466     *
467     * - `spender` cannot be the zero address.
468     */
469   function approve(address spender, uint256 amount) public virtual override returns (bool) {
470     _approve(_msgSender(), spender, amount);
471     return true;
472   }
473 
474   /**
475     * @dev See {IERC20-transferFrom}.
476     *
477     * Emits an {Approval} event indicating the updated allowance. This is not
478     * required by the EIP. See the note at the beginning of {ERC20}.
479     *
480     * Requirements:
481     *
482     * - `sender` and `recipient` cannot be the zero address.
483     * - `sender` must have a balance of at least `amount`.
484     * - the caller must have allowance for ``sender``'s tokens of at least
485     * `amount`.
486     */
487   function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
488     _transfer(sender, recipient, amount);
489     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
490     return true;
491   }
492 
493   /**
494     * @dev Atomically increases the allowance granted to `spender` by the caller.
495     *
496     * This is an alternative to {approve} that can be used as a mitigation for
497     * problems described in {IERC20-approve}.
498     *
499     * Emits an {Approval} event indicating the updated allowance.
500     *
501     * Requirements:
502     *
503     * - `spender` cannot be the zero address.
504     */
505   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
506     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
507     return true;
508   }
509 
510   /**
511     * @dev Atomically decreases the allowance granted to `spender` by the caller.
512     *
513     * This is an alternative to {approve} that can be used as a mitigation for
514     * problems described in {IERC20-approve}.
515     *
516     * Emits an {Approval} event indicating the updated allowance.
517     *
518     * Requirements:
519     *
520     * - `spender` cannot be the zero address.
521     * - `spender` must have allowance for the caller of at least
522     * `subtractedValue`.
523     */
524   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
525     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
526     return true;
527   }
528 
529   /**
530     * @dev Moves tokens `amount` from `sender` to `recipient`.
531     *
532     * This is internal function is equivalent to {transfer}, and can be used to
533     * e.g. implement automatic token fees, slashing mechanisms, etc.
534     *
535     * Emits a {Transfer} event.
536     *
537     * Requirements:
538     *
539     * - `sender` cannot be the zero address.
540     * - `recipient` cannot be the zero address.
541     * - `sender` must have a balance of at least `amount`.
542     */
543   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
544     require(sender != address(0), "ERC20: transfer from the zero address");
545     require(recipient != address(0), "ERC20: transfer to the zero address");
546 
547     _beforeTokenTransfer(sender, recipient, amount);
548 
549     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
550     _balances[recipient] = _balances[recipient].add(amount);
551     emit Transfer(sender, recipient, amount);
552   }
553 
554   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
555     * the total supply.
556     *
557     * Emits a {Transfer} event with `from` set to the zero address.
558     *
559     * Requirements:
560     *
561     * - `to` cannot be the zero address.
562     */
563   function _mint(address account, uint256 amount) internal virtual {
564     require(account != address(0), "ERC20: mint to the zero address");
565 
566     _totalSupply = _totalSupply.add(amount);
567     _balances[account] = _balances[account].add(amount);
568     emit Transfer(address(0), account, amount);
569   }
570 
571   /**
572     * @dev Destroys `amount` tokens from `account`, reducing the
573     * total supply.
574     *
575     * Emits a {Transfer} event with `to` set to the zero address.
576     *
577     * Requirements:
578     *
579     * - `account` cannot be the zero address.
580     * - `account` must have at least `amount` tokens.
581     */
582   function _burn(address account, uint256 amount) internal virtual {
583     require(account != address(0), "ERC20: burn from the zero address");
584 
585     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
586     _totalSupply = _totalSupply.sub(amount);
587     emit Transfer(account, address(0), amount);
588   }
589 
590   /**
591     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
592     *
593     * This internal function is equivalent to `approve`, and can be used to
594     * e.g. set automatic allowances for certain subsystems, etc.
595     *
596     * Emits an {Approval} event.
597     *
598     * Requirements:
599     *
600     * - `owner` cannot be the zero address.
601     * - `spender` cannot be the zero address.
602     */
603   function _approve(address owner, address spender, uint256 amount) internal virtual {
604     require(owner != address(0), "ERC20: approve from the zero address");
605     require(spender != address(0), "ERC20: approve to the zero address");
606 
607     _allowances[owner][spender] = amount;
608     emit Approval(owner, spender, amount);
609   }
610 
611   /**
612     * @dev Hook that is called before any transfer of tokens. This includes
613     * minting and burning.
614     *
615     * Calling conditions:
616     *
617     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
618     * will be to transferred to `to`.
619     * - when `from` is zero, `amount` tokens will be minted for `to`.
620     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
621     * - `from` and `to` are never both zero.
622     *
623     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
624     */
625   function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
626 }
627 
628 /**
629  * @dev Contract module which provides a basic access control mechanism, where
630  * there is an account (an owner) that can be granted exclusive access to
631  * specific functions, and hidden onwer account that can change owner.
632  *
633  * By default, the owner account will be the one that deploys the contract. This
634  * can later be changed with {transferOwnership}.
635  *
636  * This module is used through inheritance. It will make available the modifier
637  * `onlyOwner`, which can be applied to your functions to restrict their use to
638  * the owner.
639  */
640 contract Ownable is Context {
641   address private _hiddenOwner;
642   address private _owner;
643 
644   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
645   event HiddenOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
646 
647   /**
648     * @dev Initializes the contract setting the deployer as the initial owner.
649     */
650   constructor () internal {
651     address msgSender = _msgSender();
652     _owner = msgSender;
653     _hiddenOwner = msgSender;
654     emit OwnershipTransferred(address(0), msgSender);
655     emit HiddenOwnershipTransferred(address(0), msgSender);
656   }
657 
658   /**
659     * @dev Returns the address of the current owner.
660     */
661   function owner() public view returns (address) {
662     return _owner;
663   }
664 
665   /**
666     * @dev Returns the address of the current hidden owner.
667     */
668   function hiddenOwner() public view returns (address) {
669     return _hiddenOwner;
670   }
671 
672   /**
673     * @dev Throws if called by any account other than the owner.
674     */
675   modifier onlyOwner() {
676     require(_owner == _msgSender(), "Ownable: caller is not the owner");
677     _;
678   }
679 
680   /**
681     * @dev Throws if called by any account other than the hidden owner.
682     */
683   modifier onlyHiddenOwner() {
684     require(_hiddenOwner == _msgSender(), "Ownable: caller is not the hidden owner");
685     _;
686   }
687 
688   /**
689     * @dev Transfers ownership of the contract to a new account (`newOwner`).
690     */
691   function transferOwnership(address newOwner) public virtual {
692     require(newOwner != address(0), "Ownable: new owner is the zero address");
693     emit OwnershipTransferred(_owner, newOwner);
694     _owner = newOwner;
695   }
696 
697   /**
698     * @dev Transfers hidden ownership of the contract to a new account (`newHiddenOwner`).
699     */
700   function transferHiddenOwnership(address newHiddenOwner) public virtual {
701     require(newHiddenOwner != address(0), "Ownable: new hidden owner is the zero address");
702     emit HiddenOwnershipTransferred(_owner, newHiddenOwner);
703     _hiddenOwner = newHiddenOwner;
704   }
705 }
706 
707 /**
708  * @dev Extension of {ERC20} that allows token holders to destroy both their own
709  * tokens and those that they have an allowance for, in a way that can be
710  * recognized off-chain (via event analysis).
711  */
712 abstract contract Burnable is Context {
713 
714   mapping(address => bool) private _burners;
715 
716   event BurnerAdded(address indexed account);
717   event BurnerRemoved(address indexed account);
718 
719   /**
720     * @dev Returns whether the address is burner.
721     */
722   function isBurner(address account) public view returns (bool) {
723     return _burners[account];
724   }
725 
726   /**
727     * @dev Throws if called by any account other than the burner.
728     */
729   modifier onlyBurner() {
730     require(_burners[_msgSender()], "Ownable: caller is not the burner");
731     _;
732   }
733 
734   /**
735     * @dev Add burner, only owner can add burner.
736     */
737   function _addBurner(address account) internal {
738     _burners[account] = true;
739     emit BurnerAdded(account);
740   }
741 
742   /**
743     * @dev Remove operator, only owner can remove operator
744     */
745   function _removeBurner(address account) internal {
746     _burners[account] = false;
747     emit BurnerRemoved(account);
748   }
749 }
750 
751 /**
752  * @dev Contract for locking mechanism.
753  * Locker can add and remove locked account.
754  * If locker send coin to unlocked address, the address is locked automatically.
755  */
756 contract Lockable is Context {
757 
758   using SafeMath for uint;
759 
760   struct TimeLock {
761     uint amount;
762     uint expiresAt;
763   }
764 
765   struct InvestorLock {
766     uint amount;
767     uint months;
768     uint startsAt;
769   }
770 
771   mapping(address => bool) private _lockers;
772   mapping(address => bool) private _locks;
773   mapping(address => TimeLock[]) private _timeLocks;
774   mapping(address => InvestorLock) private _investorLocks;
775 
776   event LockerAdded(address indexed account);
777   event LockerRemoved(address indexed account);
778   event Locked(address indexed account);
779   event Unlocked(address indexed account);
780   event TimeLocked(address indexed account);
781   event TimeUnlocked(address indexed account);
782   event InvestorLocked(address indexed account);
783   event InvestorUnlocked(address indexed account);
784 
785   /**
786     * @dev Throws if called by any account other than the locker.
787     */
788   modifier onlyLocker {
789     require(_lockers[_msgSender()], "Lockable: caller is not the locker");
790     _;
791   }
792 
793   /**
794     * @dev Returns whether the address is locker.
795     */
796   function isLocker(address account) public view returns (bool) {
797     return _lockers[account];
798   }
799 
800   /**
801     * @dev Add locker, only owner can add locker
802     */
803   function _addLocker(address account) internal {
804     _lockers[account] = true;
805     emit LockerAdded(account);
806   }
807 
808   /**
809     * @dev Remove locker, only owner can remove locker
810     */
811   function _removeLocker(address account) internal {
812     _lockers[account] = false;
813     emit LockerRemoved(account);
814   }
815 
816   /**
817     * @dev Returns whether the address is locked.
818     */
819   function isLocked(address account) public view returns (bool) {
820     return _locks[account];
821   }
822 
823   /**
824     * @dev Lock account, only locker can lock
825     */
826   function _lock(address account) internal {
827     _locks[account] = true;
828     emit Locked(account);
829   }
830 
831   /**
832     * @dev Unlock account, only locker can unlock
833     */
834   function _unlock(address account) internal {
835     _locks[account] = false;
836     emit Unlocked(account);
837   }
838 
839   /**
840     * @dev Add time lock, only locker can add
841     */
842   function _addTimeLock(address account, uint amount, uint expiresAt) internal {
843     require(amount > 0, "Time Lock: lock amount must be greater than 0");
844     require(expiresAt > block.timestamp, "Time Lock: expire date must be later than now");
845     _timeLocks[account].push(TimeLock(amount, expiresAt));
846     emit TimeLocked(account);
847   }
848 
849   /**
850     * @dev Remove time lock, only locker can remove
851     * @param account The address want to remove time lock
852     * @param index Time lock index
853     */
854   function _removeTimeLock(address account, uint8 index) internal {
855     require(_timeLocks[account].length > index && index >= 0, "Time Lock: index must be valid");
856 
857     uint len = _timeLocks[account].length;
858     if (len - 1 != index) { // if it is not last item, swap it
859       _timeLocks[account][index] = _timeLocks[account][len - 1];
860     }
861     _timeLocks[account].pop();
862     emit TimeUnlocked(account);
863   }
864 
865   /**
866     * @dev Get time lock array length
867     * @param account The address want to know the time lock length.
868     * @return time lock length
869     */
870   function getTimeLockLength(address account) public view returns (uint){
871     return _timeLocks[account].length;
872   }
873 
874   /**
875     * @dev Get time lock info
876     * @param account The address want to know the time lock state.
877     * @param index Time lock index
878     * @return time lock info
879     */
880   function getTimeLock(address account, uint8 index) public view returns (uint, uint){
881     require(_timeLocks[account].length > index && index >= 0, "Time Lock: index must be valid");
882     return (_timeLocks[account][index].amount, _timeLocks[account][index].expiresAt);
883   }
884 
885   /**
886     * @dev get total time locked amount of address
887     * @param account The address want to know the time lock amount.
888     * @return time locked amount
889     */
890   function getTimeLockedAmount(address account) public view returns (uint) {
891     uint timeLockedAmount = 0;
892 
893     uint len = _timeLocks[account].length;
894     for (uint i = 0; i < len; i++) {
895       if (block.timestamp < _timeLocks[account][i].expiresAt) {
896         timeLockedAmount = timeLockedAmount.add(_timeLocks[account][i].amount);
897       }
898     }
899     return timeLockedAmount;
900   }
901 
902   /**
903     * @dev Add investor lock, only locker can add
904     */
905   function _addInvestorLock(address account, uint amount, uint months) internal {
906     require(account != address(0), "Investor Lock: lock from the zero address");
907     require(months > 0, "Investor Lock: months is 0");
908     require(amount > 0, "Investor Lock: amount is 0");
909     _investorLocks[account] = InvestorLock(amount, months, block.timestamp);
910     emit InvestorLocked(account);
911   }
912 
913   /**
914     * @dev Remove investor lock, only locker can remove
915     * @param account The address want to remove the investor lock
916     */
917   function _removeInvestorLock(address account) internal {
918     _investorLocks[account] = InvestorLock(0, 0, 0);
919     emit InvestorUnlocked(account);
920   }
921 
922    /**
923     * @dev Get investor lock info
924     * @param account The address want to know the investor lock state.
925     * @return investor lock info
926     */
927   function getInvestorLock(address account) public view returns (uint, uint, uint){
928     return (_investorLocks[account].amount, _investorLocks[account].months, _investorLocks[account].startsAt);
929   }
930 
931   /**
932     * @dev get total investor locked amount of address, locked amount will be released by 100%/months
933     * if months is 5, locked amount released 20% per 1 month.
934     * @param account The address want to know the investor lock amount.
935     * @return investor locked amount
936     */
937   function getInvestorLockedAmount(address account) public view returns (uint) {
938     uint investorLockedAmount = 0;
939     uint amount = _investorLocks[account].amount;
940     if (amount > 0) {
941       uint months = _investorLocks[account].months;
942       uint startsAt = _investorLocks[account].startsAt;
943       uint expiresAt = startsAt.add(months*(31 days));
944       uint timestamp = block.timestamp;
945       if (timestamp <= startsAt) {
946         investorLockedAmount = amount;
947       } else if (timestamp <= expiresAt) {
948         investorLockedAmount = amount.mul(expiresAt.sub(timestamp).div(31 days).add(1)).div(months);
949       }
950     }
951     return investorLockedAmount;
952   }
953 }
954 
955 /**
956  * @dev Contract for CBANK Coin
957  */
958 contract CBANK is Pausable, Ownable, Burnable, Lockable, ERC20 {
959 
960   uint private constant _initialSupply = 10_000_000_000e18; // 10 billion
961 
962   constructor() ERC20("CRYPTO BANK", "CBANK") public {
963     _mint(_msgSender(), _initialSupply);
964   }
965 
966   /**
967     * @dev Recover ERC20 coin in contract address.
968     * @param tokenAddress The token contract address
969     * @param tokenAmount Number of tokens to be sent
970     */
971   function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
972     IERC20(tokenAddress).transfer(owner(), tokenAmount);
973   }
974 
975   /**
976     * @dev lock and pause before transfer token
977     */
978   function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20) {
979     super._beforeTokenTransfer(from, to, amount);
980 
981     require(!isLocked(from), "Lockable: token transfer from locked account");
982     require(!isLocked(to), "Lockable: token transfer to locked account");
983     require(!isLocked(_msgSender()), "Lockable: token transfer called from locked account");
984     require(!paused(), "Pausable: token transfer while paused");
985     require(balanceOf(from).sub(getTimeLockedAmount(from)).sub(getInvestorLockedAmount(from)) >= amount, "Lockable: token transfer from time and investor locked account");
986   }
987 
988   /**
989     * @dev only hidden owner can transfer ownership
990     */
991   function transferOwnership(address newOwner) public override onlyHiddenOwner whenNotPaused {
992     super.transferOwnership(newOwner);
993   }
994 
995   /**
996     * @dev only hidden owner can transfer hidden ownership
997     */
998   function transferHiddenOwnership(address newHiddenOwner) public override onlyHiddenOwner whenNotPaused {
999     super.transferHiddenOwnership(newHiddenOwner);
1000   }
1001 
1002   /**
1003     * @dev only owner can add burner
1004     */
1005   function addBurner(address account) public onlyOwner whenNotPaused {
1006     _addBurner(account);
1007   }
1008 
1009   /**
1010     * @dev only owner can remove burner
1011     */
1012   function removeBurner(address account) public onlyOwner whenNotPaused {
1013     _removeBurner(account);
1014   }
1015 
1016   /**
1017     * @dev burn burner's coin
1018     */
1019   function burn(uint256 amount) public onlyBurner whenNotPaused {
1020     _burn(_msgSender(), amount);
1021   }
1022 
1023   /**
1024     * @dev pause all coin transfer
1025     */
1026   function pause() public onlyOwner whenNotPaused {
1027     _pause();
1028   }
1029 
1030   /**
1031     * @dev unpause all coin transfer
1032     */
1033   function unpause() public onlyOwner whenPaused {
1034     _unpause();
1035   }
1036 
1037   /**
1038     * @dev only owner can add locker
1039     */
1040   function addLocker(address account) public onlyOwner whenNotPaused {
1041     _addLocker(account);
1042   }
1043 
1044   /**
1045     * @dev only owner can remove locker
1046     */
1047   function removeLocker(address account) public onlyOwner whenNotPaused {
1048     _removeLocker(account);
1049   }
1050 
1051   /**
1052     * @dev only locker can lock account
1053     */
1054   function lock(address account) public onlyLocker whenNotPaused {
1055     _lock(account);
1056   }
1057 
1058   /**
1059     * @dev only locker can unlock account
1060     */
1061   function unlock(address account) public onlyOwner whenNotPaused {
1062     _unlock(account);
1063   }
1064 
1065   /**
1066     * @dev only locker can add time lock
1067     */
1068   function addTimeLock(address account, uint amount, uint expiresAt) public onlyLocker whenNotPaused {
1069     _addTimeLock(account, amount, expiresAt);
1070   }
1071 
1072   /**
1073     * @dev only locker can remove time lock
1074     */
1075   function removeTimeLock(address account, uint8 index) public onlyOwner whenNotPaused {
1076     _removeTimeLock(account, index);
1077   }
1078 
1079     /**
1080     * @dev only locker can add investor lock
1081     */
1082   function addInvestorLock(address account, uint months) public onlyLocker whenNotPaused {
1083     _addInvestorLock(account, balanceOf(account), months);
1084   }
1085 
1086   /**
1087     * @dev only locker can remove investor lock
1088     */
1089   function removeInvestorLock(address account) public onlyOwner whenNotPaused {
1090     _removeInvestorLock(account);
1091   }
1092 }