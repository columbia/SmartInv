1 pragma solidity 0.5.2;
2 
3 /***************
4 **            **
5 ** INTERFACES **
6 **            **
7 ***************/
8 
9 /**
10  * @dev Interface of OpenZeppelin's ERC20; For definitions / documentation, see below.
11  */
12 interface IERC20 {
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function balanceOf(address account) external view returns (uint256);
17     function totalSupply() external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20 
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24 }
25 
26 /****************************
27 **                         **
28 ** OPEN ZEPPELIN CONTRACTS **
29 **                         **
30 ****************************/
31 
32 /**
33  * @dev Implementation of the {IERC20} interface.
34  *
35  * This implementation is agnostic to the way tokens are created. This means
36  * that a supply mechanism has to be added in a derived contract using {_mint}.
37  * For a generic mechanism see {ERC20Mintable}.
38  *
39  * TIP: For a detailed writeup see our guide
40  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
41  * to implement supply mechanisms].
42  *
43  * We have followed general OpenZeppelin guidelines: functions revert instead
44  * of returning `false` on failure. This behavior is nonetheless conventional
45  * and does not conflict with the expectations of ERC20 applications.
46  *
47  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
48  * This allows applications to reconstruct the allowance for all accounts just
49  * by listening to said events. Other implementations of the EIP may not emit
50  * these events, as it isn't required by the specification.
51  *
52  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
53  * functions have been added to mitigate the well-known issues around setting
54  * allowances. See {IERC20-approve}.
55  */
56 contract ERC20 is IERC20 {
57     using SafeMath for uint256;
58 
59     mapping (address => uint256) private _balances;
60 
61     mapping (address => mapping (address => uint256)) private _allowances;
62 
63     uint256 private _totalSupply;
64 
65     /**
66      * @dev See {IERC20-totalSupply}.
67      */
68     function totalSupply() public view returns (uint256) {
69         return _totalSupply;
70     }
71 
72     /**
73      * @dev See {IERC20-balanceOf}.
74      */
75     function balanceOf(address account) public view returns (uint256) {
76         return _balances[account];
77     }
78 
79     /**
80      * @dev See {IERC20-transfer}.
81      *
82      * Requirements:
83      *
84      * - `recipient` cannot be the zero address.
85      * - the caller must have a balance of at least `amount`.
86      */
87     function transfer(address recipient, uint256 amount) public returns (bool) {
88         _transfer(msg.sender, recipient, amount);
89         return true;
90     }
91 
92     /**
93      * @dev See {IERC20-allowance}.
94      */
95     function allowance(address owner, address spender) public view returns (uint256) {
96         return _allowances[owner][spender];
97     }
98 
99     /**
100      * @dev See {IERC20-approve}.
101      *
102      * Requirements:
103      *
104      * - `spender` cannot be the zero address.
105      */
106     function approve(address spender, uint256 value) public returns (bool) {
107         _approve(msg.sender, spender, value);
108         return true;
109     }
110 
111     /**
112      * @dev See {IERC20-transferFrom}.
113      *
114      * Emits an {Approval} event indicating the updated allowance. This is not
115      * required by the EIP. See the note at the beginning of {ERC20};
116      *
117      * Requirements:
118      * - `sender` and `recipient` cannot be the zero address.
119      * - `sender` must have a balance of at least `value`.
120      * - the caller must have allowance for `sender`'s tokens of at least
121      * `amount`.
122      */
123     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
124         _transfer(sender, recipient, amount);
125         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
126         return true;
127     }
128 
129     /**
130      * @dev Atomically increases the allowance granted to `spender` by the caller.
131      *
132      * This is an alternative to {approve} that can be used as a mitigation for
133      * problems described in {IERC20-approve}.
134      *
135      * Emits an {Approval} event indicating the updated allowance.
136      *
137      * Requirements:
138      *
139      * - `spender` cannot be the zero address.
140      */
141     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
142         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
143         return true;
144     }
145 
146     /**
147      * @dev Atomically decreases the allowance granted to `spender` by the caller.
148      *
149      * This is an alternative to {approve} that can be used as a mitigation for
150      * problems described in {IERC20-approve}.
151      *
152      * Emits an {Approval} event indicating the updated allowance.
153      *
154      * Requirements:
155      *
156      * - `spender` cannot be the zero address.
157      * - `spender` must have allowance for the caller of at least
158      * `subtractedValue`.
159      */
160     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
161         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
162         return true;
163     }
164 
165     /**
166      * @dev Moves tokens `amount` from `sender` to `recipient`.
167      *
168      * This is internal function is equivalent to {transfer}, and can be used to
169      * e.g. implement automatic token fees, slashing mechanisms, etc.
170      *
171      * Emits a {Transfer} event.
172      *
173      * Requirements:
174      *
175      * - `sender` cannot be the zero address.
176      * - `recipient` cannot be the zero address.
177      * - `sender` must have a balance of at least `amount`.
178      */
179     function _transfer(address sender, address recipient, uint256 amount) internal {
180         require(sender != address(0), "ERC20: transfer from the zero address");
181         require(recipient != address(0), "ERC20: transfer to the zero address");
182 
183         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
184         _balances[recipient] = _balances[recipient].add(amount);
185         emit Transfer(sender, recipient, amount);
186     }
187 
188     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
189      * the total supply.
190      *
191      * Emits a {Transfer} event with `from` set to the zero address.
192      *
193      * Requirements
194      *
195      * - `to` cannot be the zero address.
196      */
197     function _mint(address account, uint256 amount) internal {
198         require(account != address(0), "ERC20: mint to the zero address");
199 
200         _totalSupply = _totalSupply.add(amount);
201         _balances[account] = _balances[account].add(amount);
202         emit Transfer(address(0), account, amount);
203     }
204 
205      /**
206      * @dev Destroys `amount` tokens from `account`, reducing the
207      * total supply.
208      *
209      * Emits a {Transfer} event with `to` set to the zero address.
210      *
211      * Requirements
212      *
213      * - `account` cannot be the zero address.
214      * - `account` must have at least `amount` tokens.
215      */
216     function _burn(address account, uint256 value) internal {
217         require(account != address(0), "ERC20: burn from the zero address");
218 
219         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
220         _totalSupply = _totalSupply.sub(value);
221         emit Transfer(account, address(0), value);
222     }
223 
224     /**
225      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
226      *
227      * This is internal function is equivalent to `approve`, and can be used to
228      * e.g. set automatic allowances for certain subsystems, etc.
229      *
230      * Emits an {Approval} event.
231      *
232      * Requirements:
233      *
234      * - `owner` cannot be the zero address.
235      * - `spender` cannot be the zero address.
236      */
237     function _approve(address owner, address spender, uint256 value) internal {
238         require(owner != address(0), "ERC20: approve from the zero address");
239         require(spender != address(0), "ERC20: approve to the zero address");
240 
241         _allowances[owner][spender] = value;
242         emit Approval(owner, spender, value);
243     }
244 
245     /**
246      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
247      * from the caller's allowance.
248      *
249      * See {_burn} and {_approve}.
250      */
251     function _burnFrom(address account, uint256 amount) internal {
252         _burn(account, amount);
253         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
254     }
255 }
256 
257 /**
258  * @dev Extension of {ERC20} that allows token holders to destroy both their own
259  * tokens and those that they have an allowance for, in a way that can be
260  * recognized off-chain (via event analysis).
261  */
262 contract ERC20Burnable is ERC20 {
263     /**
264      * @dev Destroys `amount` tokens from the caller.
265      *
266      * See {ERC20-_burn}.
267      */
268     function burn(uint256 amount) public {
269         _burn(msg.sender, amount);
270     }
271 
272     /**
273      * @dev See {ERC20-_burnFrom}.
274      */
275     function burnFrom(address account, uint256 amount) public {
276         _burnFrom(account, amount);
277     }
278 }
279 
280 /**
281  * @dev Optional functions from the ERC20 standard.
282  */
283 contract ERC20Detailed is IERC20 {
284     string private _name;
285     string private _symbol;
286     uint8 private _decimals;
287 
288     /**
289      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
290      * these values are immutable: they can only be set once during
291      * construction.
292      */
293     constructor (string memory name, string memory symbol, uint8 decimals) public {
294         _name = name;
295         _symbol = symbol;
296         _decimals = decimals;
297     }
298 
299     /**
300      * @dev Returns the name of the token.
301      */
302     function name() public view returns (string memory) {
303         return _name;
304     }
305 
306     /**
307      * @dev Returns the symbol of the token, usually a shorter version of the
308      * name.
309      */
310     function symbol() public view returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @dev Returns the number of decimals used to get its user representation.
316      * For example, if `decimals` equals `2`, a balance of `505` tokens should
317      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
318      *
319      * Tokens usually opt for a value of 18, imitating the relationship between
320      * Ether and Wei.
321      *
322      * NOTE: This information is only used for _display_ purposes: it in
323      * no way affects any of the arithmetic of the contract, including
324      * {IERC20-balanceOf} and {IERC20-transfer}.
325      */
326     function decimals() public view returns (uint8) {
327         return _decimals;
328     }
329 }
330 
331 /**
332  * @dev Wrappers over Solidity's arithmetic operations with added overflow
333  * checks.
334  *
335  * Arithmetic operations in Solidity wrap on overflow. This can easily result
336  * in bugs, because programmers usually assume that an overflow raises an
337  * error, which is the standard behavior in high level programming languages.
338  * `SafeMath` restores this intuition by reverting the transaction when an
339  * operation overflows.
340  *
341  * Using this library instead of the unchecked operations eliminates an entire
342  * class of bugs, so it's recommended to use it always.
343  */
344 library SafeMath {
345     /**
346      * @dev Returns the addition of two unsigned integers, reverting on
347      * overflow.
348      *
349      * Counterpart to Solidity's `+` operator.
350      *
351      * Requirements:
352      * - Addition cannot overflow.
353      */
354     function add(uint256 a, uint256 b) internal pure returns (uint256) {
355         uint256 c = a + b;
356         require(c >= a, "SafeMath: addition overflow");
357 
358         return c;
359     }
360 
361     /**
362      * @dev Returns the subtraction of two unsigned integers, reverting on
363      * overflow (when the result is negative).
364      *
365      * Counterpart to Solidity's `-` operator.
366      *
367      * Requirements:
368      * - Subtraction cannot overflow.
369      */
370     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
371         return sub(a, b, "SafeMath: subtraction overflow");
372     }
373 
374     /**
375      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
376      * overflow (when the result is negative).
377      *
378      * Counterpart to Solidity's `-` operator.
379      *
380      * Requirements:
381      * - Subtraction cannot overflow.
382      */
383     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
384         require(b <= a, errorMessage);
385         uint256 c = a - b;
386 
387         return c;
388     }
389 
390     /**
391      * @dev Returns the multiplication of two unsigned integers, reverting on
392      * overflow.
393      *
394      * Counterpart to Solidity's `*` operator.
395      *
396      * Requirements:
397      * - Multiplication cannot overflow.
398      */
399     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
400         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
401         // benefit is lost if 'b' is also tested.
402         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
403         if (a == 0) {
404             return 0;
405         }
406 
407         uint256 c = a * b;
408         require(c / a == b, "SafeMath: multiplication overflow");
409 
410         return c;
411     }
412 
413     /**
414      * @dev Returns the integer division of two unsigned integers. Reverts on
415      * division by zero. The result is rounded towards zero.
416      *
417      * Counterpart to Solidity's `/` operator. Note: this function uses a
418      * `revert` opcode (which leaves remaining gas untouched) while Solidity
419      * uses an invalid opcode to revert (consuming all remaining gas).
420      *
421      * Requirements:
422      * - The divisor cannot be zero.
423      */
424     function div(uint256 a, uint256 b) internal pure returns (uint256) {
425         return div(a, b, "SafeMath: division by zero");
426     }
427 
428     /**
429      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
430      * division by zero. The result is rounded towards zero.
431      *
432      * Counterpart to Solidity's `/` operator. Note: this function uses a
433      * `revert` opcode (which leaves remaining gas untouched) while Solidity
434      * uses an invalid opcode to revert (consuming all remaining gas).
435      *
436      * Requirements:
437      * - The divisor cannot be zero.
438      */
439     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
440         // Solidity only automatically asserts when dividing by 0
441         require(b > 0, errorMessage);
442         uint256 c = a / b;
443         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
444 
445         return c;
446     }
447 
448     /**
449      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
450      * Reverts when dividing by zero.
451      *
452      * Counterpart to Solidity's `%` operator. This function uses a `revert`
453      * opcode (which leaves remaining gas untouched) while Solidity uses an
454      * invalid opcode to revert (consuming all remaining gas).
455      *
456      * Requirements:
457      * - The divisor cannot be zero.
458      */
459     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
460         return mod(a, b, "SafeMath: modulo by zero");
461     }
462 
463     /**
464      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
465      * Reverts with custom message when dividing by zero.
466      *
467      * Counterpart to Solidity's `%` operator. This function uses a `revert`
468      * opcode (which leaves remaining gas untouched) while Solidity uses an
469      * invalid opcode to revert (consuming all remaining gas).
470      *
471      * Requirements:
472      * - The divisor cannot be zero.
473      */
474     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
475         require(b != 0, errorMessage);
476         return a % b;
477     }
478 }
479 
480 /*******************
481 **                **
482 ** KONG CONTRACTS **
483 **                **
484 *******************/
485 
486 /**
487  * @title  Kong ERC20 Token Contract.
488  *
489  * @dev    Extends OpenZeppelin contracts `ERC20`, `ERC20Detailed`, and `ERC20Burnable`.
490  *
491  *         Main additions:
492  *
493  *         - `beginLockDrop()`: Function to deploy instances of `LockDrop` contracts. This function
494  *         can be called periodically. The amount of new tokens minted is proportional to the
495  *         existing supply of tokens.
496  *
497  *         - `mint()`: Function to mint new Kong token. Can only be called by addresses that have
498  *         been added to `_minters` through `addMinter()` which is only accessible to `owner`.
499  *         `mint()` is subject to restrictions concerning the mintable amount (see below).
500  */
501 contract KongERC20 is ERC20, ERC20Burnable, ERC20Detailed {
502     // Constants.
503     uint256 constant ONE_YEAR = 365 * 24 * 60 * 60;
504     uint256 constant ONE_MONTH = 30 * 24 * 60 * 60;
505     uint256 constant MINTING_REWARD = 2 ** 8 * 10 ** 18;
506 
507     // Account with right to add to `minters`.
508     address public _owner;
509 
510     // Total amount minted through `minters`; does not include Genesis Kong.
511     uint256 public _totalMinted;
512 
513     // Timestamp of contract deployment; used to calculate number of years since launch.
514     uint256 public _launchTimestamp;
515 
516     // Address and timestamp of last `LockDrop` deployment.
517     address public _lastLockDropAddress;
518     uint256 public _lastLockDropTimestamp;
519 
520     // Addresses allowed to mint new Kong.
521     mapping (address => bool) public _minters;
522 
523     // Emits when new `LockDrop` is deployed.
524     event LockDropCreation(
525         address deployedBy,
526         uint256 deployedTimestamp,
527         uint256 deployedSize,
528         address deployedAddress
529     );
530 
531     // Emits when a new address is added to `minters`.
532     event MinterAddition(
533         address minter
534     );
535 
536     /**
537      * @dev The constructor sets the following variables:
538      *
539      *      - `_name`,
540      *      - `_symbol`,
541      *      - `_decimals`,
542      *      - `_owner`, and
543      *      - `_launchTimeStamp`.
544      *
545      *      It also mints Genesis tokens.
546      */
547     constructor() public ERC20Detailed('KONG', 'KONG', 18) {
548 
549         // Set _owner.
550         _owner = 0xAB35D3476251C6b614dC2eb36380D7AF1232D822;
551 
552         // Store launch time.
553         _launchTimestamp = block.timestamp;
554 
555         // Mint Genesis Kong.
556         _mint(0xAB35D3476251C6b614dC2eb36380D7AF1232D822, 3 * 2 ** 20 * 10 ** 18);
557         _mint(0x9699b500fD907636f10965d005813F0CE0986176, 2 ** 20 * 10 ** 18);
558         _mint(0xdBa9A507aa0838370399FDE048752E91B5a27F06, 2 ** 20 * 10 ** 18);
559         _mint(0xb2E0F4dee26CcCf1f3A267Ad185f212Dd3e7a6b1, 2 ** 20 * 10 ** 18);
560         _mint(0xdB6e9FaAcE283e230939769A2DFa80BdcD7E1E43, 2 ** 20 * 10 ** 18);
561 
562     }
563 
564     /**
565      * @dev Function to add a minter.
566      */
567     function addMinter(address minter) public {
568 
569       require(msg.sender == _owner, 'Can only be called by owner.');
570 
571       _minters[minter] = true;
572       emit MinterAddition(minter);
573 
574     }
575 
576     /**
577      * @dev Function to deploy a new `LockDrop` contract. The function can be called every 30 days,
578      *      i.e., whenever 30 days have passed since the function was last called successfully.
579      *      Mints approximately (1.01^(1/12) - 1) percent of the current total supply
580      *      and transfers the new tokens to the deployed contract. Mints `MINTING_REWARD` tokens
581      *      to whoever calls it successfully.
582      */
583     function beginLockDrop() public {
584 
585         // Verify that time to last `LockDrop` deployment exceeds 30 days.
586         require(_lastLockDropTimestamp + ONE_MONTH <= block.timestamp, '30 day cooling period.');
587 
588         // Update timestamp of last `LockDrop` deployment.
589         _lastLockDropTimestamp = block.timestamp;
590 
591         // Calculate size of lockdrop as 0.0008295381 (≈ 1.01 ^ (1/12) - 1) times the total supply.
592         uint256 lockDropSize = totalSupply().mul(8295381).div(10 ** 10);
593 
594         // Deploy a new `LockDrop` contract.
595         LockDrop lockDrop = new LockDrop(address(this));
596 
597         // Update address of last lock drop.
598         _lastLockDropAddress = address(lockDrop);
599 
600         // Mint `lockDropSize` to deployed `LockDrop` contract.
601         _mint(_lastLockDropAddress, lockDropSize);
602 
603         // Mint `MINTING_REWARD` to msg.sender.
604         _mint(msg.sender, MINTING_REWARD);
605 
606         // Emit event.
607         emit LockDropCreation(
608             msg.sender,
609             block.timestamp,
610             lockDropSize,
611             address(lockDrop)
612         );
613 
614     }
615 
616     /**
617      * @dev Helper function to calculate the maximal amount `minters` are capable of minting.
618      */
619     function getMintingLimit() public view returns(uint256) {
620 
621         // Calculate number of years since launch.
622         uint256 y = (block.timestamp - _launchTimestamp) / uint(ONE_YEAR);
623 
624         // Determine maximally mintable amount.
625         uint256 mintingLimit = 2 ** 25 * 10 ** 18;
626         if (y > 0) {mintingLimit += 2 ** 24 * 10 ** 18;}
627         if (y > 1) {mintingLimit += 2 ** 23 * 10 ** 18;}
628         if (y > 2) {mintingLimit += 2 ** 22 * 10 ** 18;}
629 
630         // Return.
631         return mintingLimit;
632 
633     }
634 
635     /**
636      * @dev Mints new tokens conditional on not exceeding minting limits. Can only be called by
637      *      valid `minters`.
638      */
639     function mint(uint256 mintedAmount, address recipient) public {
640 
641         require(_minters[msg.sender] == true, 'Can only be called by registered minter.');
642 
643         // Enforce global cap.
644         require(_totalMinted.add(mintedAmount) <= getMintingLimit(), 'Exceeds global cap.');
645 
646         // Increase minted amount.
647         _totalMinted += mintedAmount;
648 
649         // Mint.
650         _mint(recipient, mintedAmount);
651 
652     }
653 
654 }
655 
656 /**
657  * @title   Lock Drop Contract
658  *
659  * @dev     This contract implements a Kong Lock Drop.
660  *
661  *          Notes (check online sources for further details):
662  *
663  *          - `stakeETH()` can be called to participate in the lock drop by staking ETH. Individual
664  *          stakes are immediately sent to separate instances of `LockETH` contracts that only the
665  *          staker has access to.
666  *
667  *          - `claimKong()` can be called to claim Kong once the staking period is over.
668  *
669  *          - The contract is open for contributions for 30 days after its deployment.
670  */
671 contract LockDrop {
672     using SafeMath for uint256;
673 
674     // Timestamp for the end of staking.
675     uint256 public _stakingEnd;
676 
677     // Sum of all contribution weights.
678     uint256 public _weightsSum;
679 
680     // Address of the KONG ERC20 contract.
681     address public _kongERC20Address;
682 
683     // Mapping from contributors to contribution weights.
684     mapping(address => uint256) public _weights;
685 
686     // Mapping from contributors to locking period ends.
687     mapping(address => uint256) public _lockingEnds;
688 
689     // Events for staking and claiming.
690     event Staked(
691         address indexed contributor,
692         address lockETHAddress,
693         uint256 ethStaked,
694         uint256 endDate
695     );
696     event Claimed(
697         address indexed claimant,
698         uint256 ethStaked,
699         uint256 kongClaim
700     );
701 
702     constructor (address kongERC20Address) public {
703 
704         // Set the address of the ERC20 token.
705         _kongERC20Address = kongERC20Address;
706 
707         // Set the end of the staking period to 30 days after deployment.
708         _stakingEnd = block.timestamp + 30 days;
709 
710     }
711 
712     /**
713      * @dev Function to stake ETH in this lock drop.
714      *
715      *      When called with positive `msg.value` and valid `stakingPeriod`, deploys instance of
716      *      `LockETH` contract and transfers `msg.value` to it. Each `LockETH` contract is only
717      *      accessible to the address that called `stakeETH()` to deploy the respective instance.
718      *
719      *      For valid stakes, calculates the variable `weight` as the product of total lockup time
720      *      and `msg.value`. Stores `weight` in `_weights[msg.sender]` and adds it to `_weightsSum`.
721      *
722      *      Expects `block.timestamp` to be smaller than `_stakingEnd`. Does not allow for topping
723      *      up of existing stakes. Restricts staking period to be between 90 and 365.
724      *
725      *      Emits `Staked` event.
726      */
727     function stakeETH(uint256 stakingPeriod) public payable {
728 
729         // Require positive msg.value.
730         require(msg.value > 0, 'Msg value = 0.');
731 
732         // No topping up.
733         require(_weights[msg.sender] == 0, 'No topping up.');
734 
735         // No contributions after _stakingEnd.
736         require(block.timestamp <= _stakingEnd, 'Closed for contributions.');
737 
738         // Ensure the staking period is valid.
739         require(stakingPeriod >= 30 && stakingPeriod <= 365, 'Staking period outside of allowed range.');
740 
741         // Calculate contribution weight as product of msg.value and total time the ETH is locked.
742         uint256 totalTime = _stakingEnd + stakingPeriod * 1 days - block.timestamp;
743         uint256 weight = totalTime.mul(msg.value);
744 
745         // Adjust contribution weights.
746         _weightsSum = _weightsSum.add(weight);
747         _weights[msg.sender] = weight;
748 
749         // Set end date for lock.
750         _lockingEnds[msg.sender] = _stakingEnd + stakingPeriod * 1 days;
751 
752         // Deploy new lock contract.
753         LockETH lockETH = (new LockETH).value(msg.value)(_lockingEnds[msg.sender], msg.sender);
754 
755         // Abort if the new contract's balance is lower than expected.
756         require(address(lockETH).balance >= msg.value);
757 
758         // Emit event.
759         emit Staked(msg.sender, address(lockETH), msg.value, _lockingEnds[msg.sender]);
760 
761     }
762 
763     /**
764      * @dev Function to claim Kong.
765      *
766      *      Determines the ratio of the contribution by `msg.sender` to all contributions. Sends
767      *      the product of this ratio and the contract's Kong balance to `msg.sender`. Sets the
768      *      contribution of `msg.sender` to zero afterwards and subtracts it from the sum of all
769      *      contributions.
770      *
771      *      Expects `block.timestamp` to be larger than `_lockingEnds[msg.sender]`. Throws if
772      *      `_weights[msg.sender]` is zero. Emits `Claimed` event.
773      *
774      *      NOTE: Overflow protection in calculation of `kongClaim` prevents anyone staking massive
775      *      amounts from ever claiming. Fine as long as product of weight and the contract's Kong
776      *      balance is at most (2^256)-1.
777      */
778     function claimKong() external {
779 
780         // Verify that this `msg.sender` has contributed.
781         require(_weights[msg.sender] > 0, 'Zero contribution.');
782 
783         // Verify that this `msg.sender` can claim.
784         require(block.timestamp > _lockingEnds[msg.sender], 'Cannot claim yet.');
785 
786         // Calculate amount to return.
787         uint256 weight = _weights[msg.sender];
788         uint256 kongClaim = IERC20(_kongERC20Address).balanceOf(address(this)).mul(weight).div(_weightsSum);
789 
790         // Adjust stake and sum of stakes.
791         _weights[msg.sender] = 0;
792         _weightsSum = _weightsSum.sub(weight);
793 
794         // Send kong to `msg.sender`.
795         IERC20(_kongERC20Address).transfer(msg.sender, kongClaim);
796 
797         // Emit event.
798         emit Claimed(msg.sender, weight, kongClaim);
799 
800     }
801 
802 }
803 
804 /**
805  * @title   LockETH contract.
806  *
807  * @dev     Escrows ETH until `_endOfLockUp`. Calling `unlockETH()` after `_endOfLockUp` sends ETH
808  *          to `_contractOwner`.
809  */
810 contract LockETH {
811 
812     uint256 public _endOfLockUp;
813     address payable public _contractOwner;
814 
815     constructor (uint256 endOfLockUp, address payable contractOwner) public payable {
816 
817         _endOfLockUp = endOfLockUp;
818         _contractOwner = contractOwner;
819 
820     }
821 
822     /**
823      * @dev Send ETH owned by this contract to `_contractOwner`. Can be called by anyone but
824      *      requires `block.timestamp` > `endOfLockUp`.
825      */
826     function unlockETH() external {
827 
828         // Verify end of lock-up period.
829         require(block.timestamp > _endOfLockUp, 'Cannot claim yet.');
830 
831         // Send ETH balance to `_contractOwner`.
832         _contractOwner.transfer(address(this).balance);
833 
834     }
835 
836 }