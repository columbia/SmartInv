1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
112 
113 /**
114  * @dev Contract module which provides a basic access control mechanism, where
115  * there is an account (an owner) that can be granted exclusive access to
116  * specific functions.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be aplied to your functions to restrict their use to
120  * the owner.
121  */
122 contract Ownable {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor () internal {
131         _owner = msg.sender;
132         emit OwnershipTransferred(address(0), _owner);
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(isOwner(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151      * @dev Returns true if the caller is the current owner.
152      */
153     function isOwner() public view returns (bool) {
154         return msg.sender == _owner;
155     }
156 
157     /**
158      * @dev Leaves the contract without owner. It will not be possible to call
159      * `onlyOwner` functions anymore. Can only be called by the current owner.
160      *
161      * > Note: Renouncing ownership will leave the contract without an owner,
162      * thereby removing any functionality that is only available to the owner.
163      */
164     function renounceOwnership() public onlyOwner {
165         emit OwnershipTransferred(_owner, address(0));
166         _owner = address(0);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public onlyOwner {
174         _transferOwnership(newOwner);
175     }
176 
177     /**
178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
179      */
180     function _transferOwnership(address newOwner) internal {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         emit OwnershipTransferred(_owner, newOwner);
183         _owner = newOwner;
184     }
185 }
186 
187 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
188 
189 /**
190  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
191  * the optional functions; to access them see `ERC20Detailed`.
192  */
193 interface IERC20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a `Transfer` event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through `transferFrom`. This is
216      * zero by default.
217      *
218      * This value changes when `approve` or `transferFrom` are called.
219      */
220     function allowance(address owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * > Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an `Approval` event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a `Transfer` event.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to `approve`. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
265 
266 /**
267  * @dev Implementation of the `IERC20` interface.
268  *
269  * This implementation is agnostic to the way tokens are created. This means
270  * that a supply mechanism has to be added in a derived contract using `_mint`.
271  * For a generic mechanism see `ERC20Mintable`.
272  *
273  * *For a detailed writeup see our guide [How to implement supply
274  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
275  *
276  * We have followed general OpenZeppelin guidelines: functions revert instead
277  * of returning `false` on failure. This behavior is nonetheless conventional
278  * and does not conflict with the expectations of ERC20 applications.
279  *
280  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
281  * This allows applications to reconstruct the allowance for all accounts just
282  * by listening to said events. Other implementations of the EIP may not emit
283  * these events, as it isn't required by the specification.
284  *
285  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
286  * functions have been added to mitigate the well-known issues around setting
287  * allowances. See `IERC20.approve`.
288  */
289 contract ERC20 is IERC20 {
290     using SafeMath for uint256;
291 
292     mapping (address => uint256) private _balances;
293 
294     mapping (address => mapping (address => uint256)) private _allowances;
295 
296     uint256 private _totalSupply;
297 
298     /**
299      * @dev See `IERC20.totalSupply`.
300      */
301     function totalSupply() public view returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See `IERC20.balanceOf`.
307      */
308     function balanceOf(address account) public view returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See `IERC20.transfer`.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public returns (bool) {
321         _transfer(msg.sender, recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See `IERC20.allowance`.
327      */
328     function allowance(address owner, address spender) public view returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See `IERC20.approve`.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 value) public returns (bool) {
340         _approve(msg.sender, spender, value);
341         return true;
342     }
343 
344     /**
345      * @dev See `IERC20.transferFrom`.
346      *
347      * Emits an `Approval` event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of `ERC20`;
349      *
350      * Requirements:
351      * - `sender` and `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `value`.
353      * - the caller must have allowance for `sender`'s tokens of at least
354      * `amount`.
355      */
356     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
357         _transfer(sender, recipient, amount);
358         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
359         return true;
360     }
361 
362     /**
363      * @dev Atomically increases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to `approve` that can be used as a mitigation for
366      * problems described in `IERC20.approve`.
367      *
368      * Emits an `Approval` event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
375         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
376         return true;
377     }
378 
379     /**
380      * @dev Atomically decreases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to `approve` that can be used as a mitigation for
383      * problems described in `IERC20.approve`.
384      *
385      * Emits an `Approval` event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `spender` must have allowance for the caller of at least
391      * `subtractedValue`.
392      */
393     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
394         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
395         return true;
396     }
397 
398     /**
399      * @dev Moves tokens `amount` from `sender` to `recipient`.
400      *
401      * This is internal function is equivalent to `transfer`, and can be used to
402      * e.g. implement automatic token fees, slashing mechanisms, etc.
403      *
404      * Emits a `Transfer` event.
405      *
406      * Requirements:
407      *
408      * - `sender` cannot be the zero address.
409      * - `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      */
412     function _transfer(address sender, address recipient, uint256 amount) internal {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _balances[sender] = _balances[sender].sub(amount);
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419     }
420 
421     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
422      * the total supply.
423      *
424      * Emits a `Transfer` event with `from` set to the zero address.
425      *
426      * Requirements
427      *
428      * - `to` cannot be the zero address.
429      */
430     function _mint(address account, uint256 amount) internal {
431         require(account != address(0), "ERC20: mint to the zero address");
432 
433         _totalSupply = _totalSupply.add(amount);
434         _balances[account] = _balances[account].add(amount);
435         emit Transfer(address(0), account, amount);
436     }
437 
438      /**
439      * @dev Destoys `amount` tokens from `account`, reducing the
440      * total supply.
441      *
442      * Emits a `Transfer` event with `to` set to the zero address.
443      *
444      * Requirements
445      *
446      * - `account` cannot be the zero address.
447      * - `account` must have at least `amount` tokens.
448      */
449     function _burn(address account, uint256 value) internal {
450         require(account != address(0), "ERC20: burn from the zero address");
451 
452         _totalSupply = _totalSupply.sub(value);
453         _balances[account] = _balances[account].sub(value);
454         emit Transfer(account, address(0), value);
455     }
456 
457     /**
458      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
459      *
460      * This is internal function is equivalent to `approve`, and can be used to
461      * e.g. set automatic allowances for certain subsystems, etc.
462      *
463      * Emits an `Approval` event.
464      *
465      * Requirements:
466      *
467      * - `owner` cannot be the zero address.
468      * - `spender` cannot be the zero address.
469      */
470     function _approve(address owner, address spender, uint256 value) internal {
471         require(owner != address(0), "ERC20: approve from the zero address");
472         require(spender != address(0), "ERC20: approve to the zero address");
473 
474         _allowances[owner][spender] = value;
475         emit Approval(owner, spender, value);
476     }
477 
478     /**
479      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
480      * from the caller's allowance.
481      *
482      * See `_burn` and `_approve`.
483      */
484     function _burnFrom(address account, uint256 amount) internal {
485         _burn(account, amount);
486         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
487     }
488 }
489 
490 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
491 
492 /**
493  * @dev Optional functions from the ERC20 standard.
494  */
495 contract ERC20Detailed is IERC20 {
496     string private _name;
497     string private _symbol;
498     uint8 private _decimals;
499 
500     /**
501      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
502      * these values are immutable: they can only be set once during
503      * construction.
504      */
505     constructor (string memory name, string memory symbol, uint8 decimals) public {
506         _name = name;
507         _symbol = symbol;
508         _decimals = decimals;
509     }
510 
511     /**
512      * @dev Returns the name of the token.
513      */
514     function name() public view returns (string memory) {
515         return _name;
516     }
517 
518     /**
519      * @dev Returns the symbol of the token, usually a shorter version of the
520      * name.
521      */
522     function symbol() public view returns (string memory) {
523         return _symbol;
524     }
525 
526     /**
527      * @dev Returns the number of decimals used to get its user representation.
528      * For example, if `decimals` equals `2`, a balance of `505` tokens should
529      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
530      *
531      * Tokens usually opt for a value of 18, imitating the relationship between
532      * Ether and Wei.
533      *
534      * > Note that this information is only used for _display_ purposes: it in
535      * no way affects any of the arithmetic of the contract, including
536      * `IERC20.balanceOf` and `IERC20.transfer`.
537      */
538     function decimals() public view returns (uint8) {
539         return _decimals;
540     }
541 }
542 
543 // File: contracts/LockedToken.sol
544 
545 contract HatchToken is ERC20Detailed, ERC20, Ownable {
546     using SafeMath for uint256;
547 
548     address private _treasury; // address at which treasury (locked) funds are held
549     uint256 private _monthlyUnlocked; // amount which is unlocked each _calcPeriod (30 days)
550     uint256 private _unlocked; // amount which was unlocked as of _calcTime
551     uint256 private _calcTime; // last time that _unlocked was updated with monthly unlocked amounts
552     uint256 private _treasuryTransfered; // total amount transferred out by treasury
553     uint256 private _calcPeriod = 30 days; // period for which _monthlyUnlocked is released
554 
555     event MonthlyUnlockedChanged(uint256 _oldMonthlyUnlocked, uint256 _newMonthlyUnlocked);
556     event TreasuryChanged(address _oldTreasury, address _newTreasury);
557     event EmergencyUnlock(uint256 _amount);
558 
559     /**
560      * @notice constructor
561      * @param name of token
562      * @param symbol of token
563      * @param decimals of token
564      * @param supply of token
565      * @param treasury of token
566      * @param initialUnlocked of token
567      * @param monthlyUnlocked of token
568      */
569     constructor (string memory name, string memory symbol, uint8 decimals, uint256 supply, address treasury, uint256 initialUnlocked, uint256 monthlyUnlocked) public
570         ERC20Detailed(name, symbol, decimals)
571     {
572         _mint(treasury, supply);
573         require(initialUnlocked <= totalSupply(), "initialUnlocked too large");
574         require(monthlyUnlocked <= totalSupply(), "monthlyUnlocked too large");
575         _treasury = treasury;
576         _monthlyUnlocked = monthlyUnlocked;
577         _unlocked = initialUnlocked;
578         _calcTime = now;
579     }
580 
581     /**
582      * @notice returns the treasury account
583      * @return address treasury account
584      */
585     function treasury() external view returns (address) {
586         return _treasury;
587     }
588 
589     /**
590      * @notice returns the treasury balance
591      * @return uint256 treasury balance
592      */
593     function treasuryBalance() external view returns (uint256) {
594         return balanceOf(_treasury);
595     }
596 
597     /**
598      * @notice returns the amount unlocked each month
599      * @return uint256 monthly unlocked amount
600      */
601     function monthlyUnlocked() external view returns (uint256) {
602         return _monthlyUnlocked;
603     }
604 
605     /**
606      * @notice returns the total amount transferred out by the treasury
607      * @return uint256 amount transferred out by the treasury
608      */
609     function treasuryTransfered() external view returns (uint256) {
610         return _treasuryTransfered;
611     }
612 
613     /**
614      * @notice allows the owner to unlock any amount of tokens
615      * @param amount amount of tokens to unlock
616      */
617     function emergencyUnlock(uint256 amount) external onlyOwner {
618         require(amount <= totalSupply(), "amount too large");
619         _unlocked = _unlocked.add(amount);
620         emit EmergencyUnlock(amount);
621     }
622 
623     /**
624      * @notice returns the amount which is currently unlocked of the treasury balance
625      * @return uint256 unlocked amount
626      */
627     function treasuryUnlocked() external view returns (uint256) {
628         (uint256 unlocked, ) = _calcUnlocked();
629         if (unlocked < totalSupply()) {
630             return unlocked;
631         } else {
632             return totalSupply();
633         }
634     }
635 
636     function _calcUnlocked() internal view returns (uint256, uint256) {
637         uint256 epochs = now.sub(_calcTime).div(_calcPeriod);
638         return (_unlocked.add(epochs.mul(_monthlyUnlocked)), _calcTime.add(epochs.mul(_calcPeriod)));
639     }
640 
641     function _update() internal {
642         (uint256 newUnlocked, uint256 newCalcTime) = _calcUnlocked();
643         _calcTime = newCalcTime;
644         _unlocked = newUnlocked;
645     }
646 
647     /**
648      * @notice allows the treasury address to be modified in case of compromise
649      * @param newTreasury new treasury address
650      */
651     function changeTreasury(address newTreasury) external onlyOwner {
652         _transfer(_treasury, newTreasury, balanceOf(_treasury));
653         emit TreasuryChanged(_treasury, newTreasury);
654         _treasury = newTreasury;
655     }
656 
657     /**
658      * @notice allows the monthly unlocked amount to be modified
659      * @param newMonthlyUnlocked new monthly unlocked amount
660      */
661     function changeMonthlyUnlocked(uint256 newMonthlyUnlocked) external onlyOwner {
662         require(newMonthlyUnlocked <= totalSupply(), "monthlyUnlocked too large");
663         _update();
664         emit MonthlyUnlockedChanged(_monthlyUnlocked, newMonthlyUnlocked);
665         _monthlyUnlocked = newMonthlyUnlocked;
666     }
667 
668     /**
669      * @dev See `IERC20.transfer`.
670      */
671     function transfer(address recipient, uint256 amount) public returns (bool) {
672         if (msg.sender == _treasury) {
673             _update();
674             // Not strictly needed as below .sub will revert if not true, but provides a better error message
675             require(amount <= _unlocked, "Insufficient unlocked balance");
676             _treasuryTransfered = _treasuryTransfered.add(amount);
677             _unlocked = _unlocked.sub(amount);
678         }
679         bool result = super.transfer(recipient, amount);
680         if (recipient == _treasury) {
681             _unlocked = _unlocked.add(amount);
682         }
683         return result;
684     }
685 
686     /**
687      * @dev See `IERC20.transferFrom`.
688      */
689     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
690         if (sender == _treasury) {
691             _update();
692             // Not strictly needed as below .sub will revert if not true, but provides a better error message
693             require(amount <= _unlocked, "Insufficient unlocked balance");
694             _treasuryTransfered = _treasuryTransfered.add(amount);
695             _unlocked = _unlocked.sub(amount);
696         }
697         bool result = super.transferFrom(sender, recipient, amount);
698         if (recipient == _treasury) {
699             _unlocked = _unlocked.add(amount);
700         }
701         return result;
702     }
703 
704 }