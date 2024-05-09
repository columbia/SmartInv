1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14   // Empty internal constructor, to prevent people from mistakenly deploying
15   // an instance of this contract, which should be used via inheritance.
16   constructor () internal { }
17   // solhint-disable-previous-line no-empty-blocks
18 
19   function _msgSender() internal view returns (address payable) {
20     return msg.sender;
21   }
22 
23   function _msgData() internal view returns (bytes memory) {
24     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25     return msg.data;
26   }
27 }
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations with added overflow
31  * checks.
32  *
33  * Arithmetic operations in Solidity wrap on overflow. This can easily result
34  * in bugs, because programmers usually assume that an overflow raises an
35  * error, which is the standard behavior in high level programming languages.
36  * `SafeMath` restores this intuition by reverting the transaction when an
37  * operation overflows.
38  *
39  * Using this library instead of the unchecked operations eliminates an entire
40  * class of bugs, so it's recommended to use it always.
41  */
42 library SafeMath {
43   /**
44     * @dev Returns the addition of two unsigned integers, reverting on
45     * overflow.
46     *
47     * Counterpart to Solidity's `+` operator.
48     *
49     * Requirements:
50     * - Addition cannot overflow.
51     */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a, "SafeMath: addition overflow");
55 
56     return c;
57   }
58 
59   /**
60     * @dev Returns the subtraction of two unsigned integers, reverting on
61     * overflow (when the result is negative).
62     *
63     * Counterpart to Solidity's `-` operator.
64     *
65     * Requirements:
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
79     * - Subtraction cannot overflow.
80     *
81     * _Available since v2.4.0._
82     */
83   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84     require(b <= a, errorMessage);
85     uint256 c = a - b;
86 
87     return c;
88   }
89 
90   /**
91     * @dev Returns the multiplication of two unsigned integers, reverting on
92     * overflow.
93     *
94     * Counterpart to Solidity's `*` operator.
95     *
96     * Requirements:
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
122     * - The divisor cannot be zero.
123     */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     return div(a, b, "SafeMath: division by zero");
126   }
127 
128   /**
129     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
130     * division by zero. The result is rounded towards zero.
131     *
132     * Counterpart to Solidity's `/` operator. Note: this function uses a
133     * `revert` opcode (which leaves remaining gas untouched) while Solidity
134     * uses an invalid opcode to revert (consuming all remaining gas).
135     *
136     * Requirements:
137     * - The divisor cannot be zero.
138     *
139     * _Available since v2.4.0._
140     */
141   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142     // Solidity only automatically asserts when dividing by 0
143     require(b > 0, errorMessage);
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152     * Reverts when dividing by zero.
153     *
154     * Counterpart to Solidity's `%` operator. This function uses a `revert`
155     * opcode (which leaves remaining gas untouched) while Solidity uses an
156     * invalid opcode to revert (consuming all remaining gas).
157     *
158     * Requirements:
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
174     * - The divisor cannot be zero.
175     *
176     * _Available since v2.4.0._
177     */
178   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179     require(b != 0, errorMessage);
180     return a % b;
181   }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see {ERC20Detailed}.
187  */
188 interface IERC20 {
189   /**
190     * @dev Returns the amount of tokens in existence.
191     */
192   function totalSupply() external view returns (uint256);
193 
194   /**
195     * @dev Returns the amount of tokens owned by `account`.
196     */
197   function balanceOf(address account) external view returns (uint256);
198 
199   /**
200     * @dev Moves `amount` tokens from the caller's account to `recipient`.
201     *
202     * Returns a boolean value indicating whether the operation succeeded.
203     *
204     * Emits a {Transfer} event.
205     */
206   function transfer(address recipient, uint256 amount) external returns (bool);
207 
208   /**
209     * @dev Returns the remaining number of tokens that `spender` will be
210     * allowed to spend on behalf of `owner` through {transferFrom}. This is
211     * zero by default.
212     *
213     * This value changes when {approve} or {transferFrom} are called.
214     */
215   function allowance(address owner, address spender) external view returns (uint256);
216 
217   /**
218     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219     *
220     * Returns a boolean value indicating whether the operation succeeded.
221     *
222     * IMPORTANT: Beware that changing an allowance with this method brings the risk
223     * that someone may use both the old and the new allowance by unfortunate
224     * transaction ordering. One possible solution to mitigate this race
225     * condition is to first reduce the spender's allowance to 0 and set the
226     * desired value afterwards:
227     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228     *
229     * Emits an {Approval} event.
230     */
231   function approve(address spender, uint256 amount) external returns (bool);
232 
233   /**
234     * @dev Moves `amount` tokens from `sender` to `recipient` using the
235     * allowance mechanism. `amount` is then deducted from the caller's
236     * allowance.
237     *
238     * Returns a boolean value indicating whether the operation succeeded.
239     *
240     * Emits a {Transfer} event.
241     */
242   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244   /**
245     * @dev Emitted when `value` tokens are moved from one account (`from`) to
246     * another (`to`).
247     *
248     * Note that `value` may be zero.
249     */
250   event Transfer(address indexed from, address indexed to, uint256 value);
251 
252   /**
253     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254     * a call to {approve}. `value` is the new allowance.
255     */
256   event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 
260 /**
261  * @dev Implementation of the {IERC20} interface.
262  *
263  * This implementation is agnostic to the way tokens are created. This means
264  * that a supply mechanism has to be added in a derived contract using {_mint}.
265  * For a generic mechanism see {ERC20Mintable}.
266  *
267  * TIP: For a detailed writeup see our guide
268  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
269  * to implement supply mechanisms].
270  *
271  * We have followed general OpenZeppelin guidelines: functions revert instead
272  * of returning `false` on failure. This behavior is nonetheless conventional
273  * and does not conflict with the expectations of ERC20 applications.
274  *
275  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
276  * This allows applications to reconstruct the allowance for all accounts just
277  * by listening to said events. Other implementations of the EIP may not emit
278  * these events, as it isn't required by the specification.
279  *
280  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
281  * functions have been added to mitigate the well-known issues around setting
282  * allowances. See {IERC20-approve}.
283  */
284 contract ERC20 is Context, IERC20 {
285   using SafeMath for uint256;
286 
287   mapping (address => uint256) private _balances;
288 
289   mapping (address => mapping (address => uint256)) private _allowances;
290 
291   uint256 private _totalSupply;
292 
293   /**
294     * @dev See {IERC20-totalSupply}.
295     */
296   function totalSupply() public view returns (uint256) {
297     return _totalSupply;
298   }
299 
300   /**
301     * @dev See {IERC20-balanceOf}.
302     */
303   function balanceOf(address account) public view returns (uint256) {
304     return _balances[account];
305   }
306 
307   /**
308     * @dev See {IERC20-transfer}.
309     *
310     * Requirements:
311     *
312     * - `recipient` cannot be the zero address.
313     * - the caller must have a balance of at least `amount`.
314     */
315   function transfer(address recipient, uint256 amount) public returns (bool) {
316     _transfer(_msgSender(), recipient, amount);
317     return true;
318   }
319 
320   /**
321     * @dev See {IERC20-allowance}.
322     */
323   function allowance(address owner, address spender) public view returns (uint256) {
324     return _allowances[owner][spender];
325   }
326 
327   /**
328     * @dev See {IERC20-approve}.
329     *
330     * Requirements:
331     *
332     * - `spender` cannot be the zero address.
333     */
334   function approve(address spender, uint256 amount) public returns (bool) {
335     _approve(_msgSender(), spender, amount);
336     return true;
337   }
338 
339   /**
340     * @dev See {IERC20-transferFrom}.
341     *
342     * Emits an {Approval} event indicating the updated allowance. This is not
343     * required by the EIP. See the note at the beginning of {ERC20};
344     *
345     * Requirements:
346     * - `sender` and `recipient` cannot be the zero address.
347     * - `sender` must have a balance of at least `amount`.
348     * - the caller must have allowance for `sender`'s tokens of at least
349     * `amount`.
350     */
351   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
352     _transfer(sender, recipient, amount);
353     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
354     return true;
355   }
356 
357   /**
358     * @dev Atomically increases the allowance granted to `spender` by the caller.
359     *
360     * This is an alternative to {approve} that can be used as a mitigation for
361     * problems described in {IERC20-approve}.
362     *
363     * Emits an {Approval} event indicating the updated allowance.
364     *
365     * Requirements:
366     *
367     * - `spender` cannot be the zero address.
368     */
369   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
370     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
371     return true;
372   }
373 
374   /**
375     * @dev Atomically decreases the allowance granted to `spender` by the caller.
376     *
377     * This is an alternative to {approve} that can be used as a mitigation for
378     * problems described in {IERC20-approve}.
379     *
380     * Emits an {Approval} event indicating the updated allowance.
381     *
382     * Requirements:
383     *
384     * - `spender` cannot be the zero address.
385     * - `spender` must have allowance for the caller of at least
386     * `subtractedValue`.
387     */
388   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
389     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
390     return true;
391   }
392 
393   /**
394     * @dev Moves tokens `amount` from `sender` to `recipient`.
395     *
396     * This is internal function is equivalent to {transfer}, and can be used to
397     * e.g. implement automatic token fees, slashing mechanisms, etc.
398     *
399     * Emits a {Transfer} event.
400     *
401     * Requirements:
402     *
403     * - `sender` cannot be the zero address.
404     * - `recipient` cannot be the zero address.
405     * - `sender` must have a balance of at least `amount`.
406     */
407   function _transfer(address sender, address recipient, uint256 amount) internal {
408     require(sender != address(0), "ERC20: transfer from the zero address");
409     require(recipient != address(0), "ERC20: transfer to the zero address");
410 
411     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
412     _balances[recipient] = _balances[recipient].add(amount);
413     emit Transfer(sender, recipient, amount);
414   }
415 
416   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
417     * the total supply.
418     *
419     * Emits a {Transfer} event with `from` set to the zero address.
420     *
421     * Requirements
422     *
423     * - `to` cannot be the zero address.
424     */
425   function _mint(address account, uint256 amount) internal {
426     require(account != address(0), "ERC20: mint to the zero address");
427 
428     _totalSupply = _totalSupply.add(amount);
429     _balances[account] = _balances[account].add(amount);
430     emit Transfer(address(0), account, amount);
431   }
432 
433   /**
434     * @dev Destroys `amount` tokens from `account`, reducing the
435     * total supply.
436     *
437     * Emits a {Transfer} event with `to` set to the zero address.
438     *
439     * Requirements
440     *
441     * - `account` cannot be the zero address.
442     * - `account` must have at least `amount` tokens.
443     */
444   function _burn(address account, uint256 amount) internal {
445     require(account != address(0), "ERC20: burn from the zero address");
446 
447     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
448     _totalSupply = _totalSupply.sub(amount);
449     emit Transfer(account, address(0), amount);
450   }
451 
452   /**
453     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
454     *
455     * This is internal function is equivalent to `approve`, and can be used to
456     * e.g. set automatic allowances for certain subsystems, etc.
457     *
458     * Emits an {Approval} event.
459     *
460     * Requirements:
461     *
462     * - `owner` cannot be the zero address.
463     * - `spender` cannot be the zero address.
464     */
465   function _approve(address owner, address spender, uint256 amount) internal {
466     require(owner != address(0), "ERC20: approve from the zero address");
467     require(spender != address(0), "ERC20: approve to the zero address");
468 
469     _allowances[owner][spender] = amount;
470     emit Approval(owner, spender, amount);
471   }
472 
473   /**
474     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
475     * from the caller's allowance.
476     *
477     * See {_burn} and {_approve}.
478     */
479   function _burnFrom(address account, uint256 amount) internal {
480     _burn(account, amount);
481     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
482   }
483 }
484 
485 
486 /**
487  * @dev Contract module which allows children to implement an emergency stop
488  * mechanism that can be triggered by an authorized account.
489  *
490  * This module is used through inheritance. It will make available the
491  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
492  * the functions of your contract. Note that they will not be pausable by
493  * simply including this module, only once the modifiers are put in place.
494  */
495 contract Pausable is Context {
496   /**
497     * @dev Emitted when the pause is triggered by a pauser (`account`).
498     */
499   event Paused(address account);
500 
501   /**
502     * @dev Emitted when the pause is lifted by a pauser (`account`).
503     */
504   event Unpaused(address account);
505 
506   bool private _paused;
507 
508   /**
509     * @dev Initializes the contract in unpaused state. Assigns the Pauser role
510     * to the deployer.
511     */
512   constructor () internal {
513     _paused = false;
514   }
515 
516   /**
517     * @dev Returns true if the contract is paused, and false otherwise.
518     */
519   function paused() public view returns (bool) {
520     return _paused;
521   }
522 
523   /**
524     * @dev Modifier to make a function callable only when the contract is not paused.
525     */
526   modifier whenNotPaused() {
527     require(!_paused, "Pausable: paused");
528     _;
529   }
530 
531   /**
532     * @dev Modifier to make a function callable only when the contract is paused.
533     */
534   modifier whenPaused() {
535     require(_paused, "Pausable: not paused");
536     _;
537   }
538 
539   /**
540     * @dev Called by a owner to pause, triggers stopped state.
541     */
542   function _pause() internal {
543     _paused = true;
544     emit Paused(_msgSender());
545   }
546 
547   /**
548     * @dev Called by a owner to unpause, returns to normal state.
549     */
550   function _unpause() internal {
551     _paused = false;
552     emit Unpaused(_msgSender());
553   }
554 }
555 
556 
557 /**
558  * @dev Contract module which provides a basic access control mechanism, where
559  * there is an account (an owner) that can be granted exclusive access to
560  * specific functions, and hidden onwer account that can change owner.
561  *
562  * By default, the owner account will be the one that deploys the contract. This
563  * can later be changed with {transferOwnership}.
564  *
565  * This module is used through inheritance. It will make available the modifier
566  * `onlyOwner`, which can be applied to your functions to restrict their use to
567  * the owner.
568  */
569 contract Ownable is Context {
570   address private _hiddenOwner;
571   address private _owner;
572 
573   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
574   event HiddenOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
575 
576   /**
577     * @dev Initializes the contract setting the deployer as the initial owner.
578     */
579   constructor () internal {
580     address msgSender = _msgSender();
581     _owner = msgSender;
582     _hiddenOwner = msgSender;
583     emit OwnershipTransferred(address(0), msgSender);
584     emit HiddenOwnershipTransferred(address(0), msgSender);
585   }
586 
587   /**
588     * @dev Returns the address of the current owner.
589     */
590   function owner() public view returns (address) {
591     return _owner;
592   }
593 
594   /**
595     * @dev Returns the address of the current hidden owner.
596     */
597   function hiddenOwner() public view returns (address) {
598     return _hiddenOwner;
599   }
600 
601   /**
602     * @dev Throws if called by any account other than the owner.
603     */
604   modifier onlyOwner() {
605     require(_owner == _msgSender(), "Ownable: caller is not the owner");
606     _;
607   }
608 
609   /**
610     * @dev Throws if called by any account other than the hidden owner.
611     */
612   modifier onlyHiddenOwner() {
613     require(_hiddenOwner == _msgSender(), "Ownable: caller is not the hidden owner");
614     _;
615   }
616 
617   /**
618     * @dev Transfers ownership of the contract to a new account (`newOwner`).
619     */
620   function _transferOwnership(address newOwner) internal {
621     require(newOwner != address(0), "Ownable: new owner is the zero address");
622     emit OwnershipTransferred(_owner, newOwner);
623     _owner = newOwner;
624   }
625 
626   /**
627     * @dev Transfers hidden ownership of the contract to a new account (`newHiddenOwner`).
628     */
629   function _transferHiddenOwnership(address newHiddenOwner) internal {
630     require(newHiddenOwner != address(0), "Ownable: new hidden owner is the zero address");
631     emit HiddenOwnershipTransferred(_owner, newHiddenOwner);
632     _hiddenOwner = newHiddenOwner;
633   }
634 }
635 
636 /**
637  * @dev Extension of {ERC20} that allows token holders to destroy both their own
638  * tokens and those that they have an allowance for, in a way that can be
639  * recognized off-chain (via event analysis).
640  */
641 contract Burnable is Context {
642 
643   mapping(address => bool) private _burners;
644 
645   event BurnerAdded(address indexed account);
646   event BurnerRemoved(address indexed account);
647 
648   /**
649     * @dev Returns whether the address is burner.
650     */
651   function isBurner(address account) public view returns (bool) {
652     return _burners[account];
653   }
654 
655   /**
656     * @dev Throws if called by any account other than the burner.
657     */
658   modifier onlyBurner() {
659     require(_burners[_msgSender()], "Ownable: caller is not the burner");
660     _;
661   }
662 
663   /**
664     * @dev Add burner, only owner can add burner.
665     */
666   function _addBurner(address account) internal {
667     _burners[account] = true;
668     emit BurnerAdded(account);
669   }
670 
671   /**
672     * @dev Remove operator, only owner can remove operator
673     */
674   function _removeBurner(address account) internal {
675     _burners[account] = false;
676     emit BurnerRemoved(account);
677   }
678 }
679 
680 /**
681  * @dev Contract for locking mechanism.
682  * Locker can add and remove locked account.
683  * If locker send coin to unlocked address, the address is locked automatically.
684  */
685 contract Lockable is Context {
686   using SafeMath for uint;
687 
688   struct TimeLock {
689     uint amount;
690     uint expiresAt;
691   }
692 
693   mapping(address => bool) private _lockers;
694   mapping(address => bool) private _locks;
695   mapping(address => TimeLock[]) private _timeLocks;
696 
697   event LockerAdded(address indexed account);
698   event LockerRemoved(address indexed account);
699   event Locked(address indexed account);
700   event Unlocked(address indexed account);
701   event TimeLocked(address indexed account);
702   event TimeUnlocked(address indexed account);
703 
704   /**
705     * @dev Throws if called by any account other than the locker.
706     */
707   modifier onlyLocker {
708     require(_lockers[_msgSender()], "Lockable: caller is not the locker");
709     _;
710   }
711 
712   /**
713     * @dev Returns whether the address is locker.
714     */
715   function isLocker(address account) public view returns (bool) {
716     return _lockers[account];
717   }
718 
719   /**
720     * @dev Add locker, only owner can add locker
721     */
722   function _addLocker(address account) internal {
723     _lockers[account] = true;
724     emit LockerAdded(account);
725   }
726 
727   /**
728     * @dev Remove locker, only owner can remove locker
729     */
730   function _removeLocker(address account) internal {
731     _lockers[account] = false;
732     emit LockerRemoved(account);
733   }
734 
735   /**
736     * @dev Returns whether the address is locked.
737     */
738   function isLocked(address account) public view returns (bool) {
739     return _locks[account];
740   }
741 
742   /**
743     * @dev Lock account, only locker can lock
744     */
745   function _lock(address account) internal {
746     _locks[account] = true;
747     emit Locked(account);
748   }
749 
750   /**
751     * @dev Unlock account, only locker can unlock
752     */
753   function _unlock(address account) internal {
754     _locks[account] = false;
755     emit Unlocked(account);
756   }
757 
758   /**
759     * @dev Add time lock, only locker can add
760     */
761   function _addTimeLock(address account, uint amount, uint expiresAt) internal {
762     require(amount > 0, "Time Lock: lock amount must be greater than 0");
763     require(expiresAt > block.timestamp, "Time Lock: expire date must be later than now");
764     _timeLocks[account].push(TimeLock(amount, expiresAt));
765   }
766 
767   /**
768     * @dev Remove time lock, only locker can remove
769     * @param account The address want to know the time lock state.
770     * @param index Time lock index
771     */
772   function _removeTimeLock(address account, uint8 index) internal {
773     require(_timeLocks[account].length > index && index >= 0, "Time Lock: index must be valid");
774 
775     uint len = _timeLocks[account].length;
776     if (len - 1 != index) { // if it is not last item, swap it
777       _timeLocks[account][index] = _timeLocks[account][len - 1];
778     }
779     _timeLocks[account].pop();
780   }
781 
782   /**
783     * @dev Get time lock array length
784     * @param account The address want to know the time lock length.
785     * @return time lock length
786     */
787   function getTimeLockLength(address account) public view returns (uint){
788     return _timeLocks[account].length;
789   }
790 
791   /**
792     * @dev Get time lock info
793     * @param account The address want to know the time lock state.
794     * @param index Time lock index
795     * @return time lock info
796     */
797   function getTimeLock(address account, uint8 index) public view returns (uint, uint){
798     require(_timeLocks[account].length > index && index >= 0, "Time Lock: index must be valid");
799     return (_timeLocks[account][index].amount, _timeLocks[account][index].expiresAt);
800   }
801 
802   /**
803     * @dev get total time locked amount of address
804     * @param account The address want to know the time lock amount.
805     * @return time locked amount
806     */
807   function getTimeLockedAmount(address account) public view returns (uint) {
808     uint timeLockedAmount = 0;
809 
810     uint len = _timeLocks[account].length;
811     for (uint i = 0; i < len; i++) {
812       if (block.timestamp < _timeLocks[account][i].expiresAt) {
813         timeLockedAmount = timeLockedAmount.add(_timeLocks[account][i].amount);
814       }
815     }
816     return timeLockedAmount;
817   }
818 }
819 
820 /**
821  * @dev Optional functions from the ERC20 standard.
822  */
823 contract ERC20Detailed is IERC20 {
824   string private _name;
825   string private _symbol;
826   uint8 private _decimals;
827 
828   /**
829     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
830     * these values are immutable: they can only be set once during
831     * construction.
832     */
833   constructor (string memory name, string memory symbol, uint8 decimals) public {
834     _name = name;
835     _symbol = symbol;
836     _decimals = decimals;
837   }
838 
839   /**
840     * @dev Returns the name of the token.
841     */
842   function name() public view returns (string memory) {
843     return _name;
844   }
845 
846   /**
847     * @dev Returns the symbol of the token, usually a shorter version of the
848     * name.
849     */
850   function symbol() public view returns (string memory) {
851     return _symbol;
852   }
853 
854   /**
855     * @dev Returns the number of decimals used to get its user representation.
856     * For example, if `decimals` equals `2`, a balance of `505` tokens should
857     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
858     *
859     * Tokens usually opt for a value of 18, imitating the relationship between
860     * Ether and Wei.
861     *
862     * NOTE: This information is only used for _display_ purposes: it in
863     * no way affects any of the arithmetic of the contract, including
864     * {IERC20-balanceOf} and {IERC20-transfer}.
865     */
866   function decimals() public view returns (uint8) {
867     return _decimals;
868   }
869 }
870 
871 
872 /**
873  * @dev Contract for Gold QR New
874  */
875 contract GQCN is Pausable, Ownable, Burnable, Lockable, ERC20, ERC20Detailed {
876 
877   uint private constant _initialSupply = 3300000000e18;
878 
879   constructor() ERC20Detailed("Gold QR Coin New", "GQCN", 18) public {
880     _mint(_msgSender(), _initialSupply);
881   }
882 
883   /**
884     * @dev Recover ERC20 coin in contract address.
885     * @param tokenAddress The token contract address
886     * @param tokenAmount Number of tokens to be sent
887     */
888   function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
889     IERC20(tokenAddress).transfer(owner(), tokenAmount);
890   }
891 
892   /**
893     * @dev lock and pause and check time lock before transfer token
894     */
895   function _beforeTokenTransfer(address from, address to, uint256 amount) internal view {
896     require(!isLocked(from), "Lockable: token transfer from locked account");
897     require(!isLocked(to), "Lockable: token transfer to locked account");
898     require(!paused(), "Pausable: token transfer while paused");
899     require(balanceOf(from).sub(getTimeLockedAmount(from)) >= amount, "Lockable: token transfer from time locked account");
900   }
901 
902   function transfer(address recipient, uint256 amount) public returns (bool) {
903     _beforeTokenTransfer(_msgSender(), recipient, amount);
904     return super.transfer(recipient, amount);
905   }
906 
907   function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
908     _beforeTokenTransfer(sender, recipient, amount);
909     return super.transferFrom(sender, recipient, amount);
910   }
911 
912   /**
913     * @dev only hidden owner can transfer ownership
914     */
915   function transferOwnership(address newOwner) public onlyHiddenOwner whenNotPaused {
916     _transferOwnership(newOwner);
917   }
918 
919   /**
920     * @dev only hidden owner can transfer hidden ownership
921     */
922   function transferHiddenOwnership(address newHiddenOwner) public onlyHiddenOwner whenNotPaused {
923     _transferHiddenOwnership(newHiddenOwner);
924   }
925 
926   /**
927     * @dev only owner can add burner
928     */
929   function addBurner(address account) public onlyOwner whenNotPaused {
930     _addBurner(account);
931   }
932 
933   /**
934     * @dev only owner can remove burner
935     */
936   function removeBurner(address account) public onlyOwner whenNotPaused {
937     _removeBurner(account);
938   }
939 
940   /**
941     * @dev burn burner's coin
942     */
943   function burn(uint256 amount) public onlyBurner whenNotPaused {
944     _beforeTokenTransfer(_msgSender(), address(0), amount);
945     _burn(_msgSender(), amount);
946   }
947 
948   /**
949     * @dev pause all coin transfer
950     */
951   function pause() public onlyOwner whenNotPaused {
952     _pause();
953   }
954 
955   /**
956     * @dev unpause all coin transfer
957     */
958   function unpause() public onlyOwner whenPaused {
959     _unpause();
960   }
961 
962   /**
963     * @dev only owner can add locker
964     */
965   function addLocker(address account) public onlyOwner whenNotPaused {
966     _addLocker(account);
967   }
968 
969   /**
970     * @dev only owner can remove locker
971     */
972   function removeLocker(address account) public onlyOwner whenNotPaused {
973     _removeLocker(account);
974   }
975 
976   /**
977     * @dev only locker can lock account
978     */
979   function lock(address account) public onlyLocker whenNotPaused {
980     _lock(account);
981   }
982 
983   /**
984     * @dev only owner can unlock account, not locker
985     */
986   function unlock(address account) public onlyOwner whenNotPaused {
987     _unlock(account);
988   }
989 
990   /**
991     * @dev only locker can add time lock
992     */
993   function addTimeLock(address account, uint amount, uint expiresAt) public onlyLocker whenNotPaused {
994     _addTimeLock(account, amount, expiresAt);
995   }
996 
997   /**
998     * @dev only owner can remove time lock
999     */
1000   function removeTimeLock(address account, uint8 index) public onlyOwner whenNotPaused {
1001     _removeTimeLock(account, index);
1002   }
1003 
1004 }