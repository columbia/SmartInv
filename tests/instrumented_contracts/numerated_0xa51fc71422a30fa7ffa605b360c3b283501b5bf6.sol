1 pragma solidity ^0.5.4;
2 interface IERC20 {
3     /**
4      * @dev Returns the amount of tokens in existence.
5      */
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a `Transfer` event.
19      */
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     /**
23      * @dev Returns the remaining number of tokens that `spender` will be
24      * allowed to spend on behalf of `owner` through `transferFrom`. This is
25      * zero by default.
26      *
27      * This value changes when `approve` or `transferFrom` are called.
28      */
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     /**
32      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * > Beware that changing an allowance with this method brings the risk
37      * that someone may use both the old and the new allowance by unfortunate
38      * transaction ordering. One possible solution to mitigate this race
39      * condition is to first reduce the spender's allowance to 0 and set the
40      * desired value afterwards:
41      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
42      *
43      * Emits an `Approval` event.
44      */
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Moves `amount` tokens from `sender` to `recipient` using the
49      * allowance mechanism. `amount` is then deducted from the caller's
50      * allowance.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a `Transfer` event.
55      */
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when `owner` unlocks tokens for a wallet
68      */
69     event Unlock(address indexed target, uint256 amount);
70 
71     /**
72      * @dev Emitted when a wallet receives locked tokens.
73      */
74     event Lock(address indexed target, uint256 amount);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to `approve`. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 
82     /**
83      * @dev Emitted when the `owner` initiates a force transfer
84      *
85      * Note that `value` may be zero.
86      * Note that `details` may be zero.
87      */
88     event ForceTransfer(address indexed from, address indexed to, uint256 value, bytes32 details);
89 }
90 
91 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b <= a, "SafeMath: subtraction overflow");
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Solidity only automatically asserts when dividing by 0
174         require(b > 0, "SafeMath: division by zero");
175         uint256 c = a / b;
176         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      */
192     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193         require(b != 0, "SafeMath: modulo by zero");
194         return a % b;
195     }
196 }
197 
198 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
199 /**
200  * @dev Implementation of the `IERC20` interface.
201  *
202  * This implementation is agnostic to the way tokens are created. This means
203  * that a supply mechanism has to be added in a derived contract using `_mint`.
204  * For a generic mechanism see `ERC20Mintable`.
205  *
206  * *For a detailed writeup see our guide [How to implement supply
207  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
208  *
209  * We have followed general OpenZeppelin guidelines: functions revert instead
210  * of returning `false` on failure. This behavior is nonetheless conventional
211  * and does not conflict with the expectations of ERC20 applications.
212  *
213  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
214  * This allows applications to reconstruct the allowance for all accounts just
215  * by listening to said events. Other implementations of the EIP may not emit
216  * these events, as it isn't required by the specification.
217  *
218  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
219  * functions have been added to mitigate the well-known issues around setting
220  * allowances. See `IERC20.approve`.
221  */
222 contract ERC20 is IERC20 {
223     using SafeMath for uint256;
224     
225     mapping (address => uint256) private _balances;
226 
227     mapping (address => uint256) private _locked;
228 
229     event StakeAdded(address indexed account);
230 
231     event StakeTokens(address indexed account, uint256 amount);
232     
233     event UnstakeTokens(address indexed account, uint256 amount);
234 
235     mapping (address => bool) private _stakeable;
236 
237     mapping (address => uint256) private _staked;
238 
239     mapping (address => uint256) private _stakeTimestamp;
240     
241     bool public stakeOpen = false;
242     
243     uint256 public stakeDuration = 0; 
244 
245     mapping (address => mapping (address => uint256)) private _allowances;
246 
247     uint256 private _totalSupply;
248 
249     /**
250      * @dev Forced transfer from one account to another. Will contain details about AML procedure.
251      */
252     function _forceTransfer(address sender, address recipient, uint256 amount, bytes32 details) internal {
253         _balances[sender] = _balances[sender].sub(amount);
254         _balances[recipient] = _balances[recipient].add(amount);
255         emit Transfer(sender, recipient, amount);
256         emit ForceTransfer(sender, recipient, amount, details);
257     }
258 
259     /**
260      * @dev See `IERC20.totalSupply`.
261      */
262     function totalSupply() public view returns (uint256) {
263         return _totalSupply;
264     }
265 
266     /**
267      * @dev See `IERC20.balanceOf`.
268      */
269     function balanceOf(address account) public view returns (uint256) {
270         return _balances[account].add(_locked[account]).add(_staked[account]);
271     }
272     
273     function internalBalance(address account) public view returns (uint256) {
274         return _balances[account];
275     }
276     
277     function internalLocked(address account) public view returns (uint256) {
278         return _locked[account];
279     }
280     
281     function internalStaked(address account) public view returns (uint256) {
282         return _staked[account];
283     }
284     
285     function canStake(address account) public view returns (bool) {
286         return (stakeOpen && _stakeable[account]);
287     }
288     
289     function getStakeAmount(address account) public view returns (uint256) {
290         return _staked[account];
291     }
292     
293     function getStakeTime(address account) public view returns (uint256) {
294         return _stakeTimestamp[account];
295     }
296 
297     /**
298      * @dev See `IERC20.transfer`.
299      *
300      * Requirements:
301      *
302      * - `recipient` cannot be the zero address.
303      * - the caller must have a balance of at least `amount`.
304      */
305     function transfer(address recipient, uint256 amount) public returns (bool) {
306         _transfer(msg.sender, recipient, amount);
307         return true;
308     }
309 
310     function stakeTokens() public {
311         require(stakeOpen, "Staking is not open");
312         require(_stakeable[msg.sender], "You are not invited to staking");
313         uint256 stake = 0;
314         if (_balances[msg.sender] > 0) {
315             stake = stake.add(_balances[msg.sender]);
316             _balances[msg.sender] = 0;
317         }
318         if (_locked[msg.sender] > 0) {
319             stake = stake.add(_locked[msg.sender]);
320             _locked[msg.sender] = 0;
321         }
322         require(stake>500 ether, "Minimum staking 500 AWX");
323 
324         _staked[msg.sender] = stake;
325         _stakeTimestamp[msg.sender] = block.timestamp;
326         _stakeable[msg.sender] = false;
327         emit StakeTokens(msg.sender,stake);
328     }
329     
330     function unstakeTokens() public {
331         require(_staked[msg.sender] > 0,"You don't have any staked tokens");
332         require((_stakeTimestamp[msg.sender] + stakeDuration) < block.timestamp,"Staking not finished");
333         uint256 staked = _staked[msg.sender];
334         _locked[msg.sender] = _locked[msg.sender].add(staked);
335         _staked[msg.sender] = 0;
336         
337         emit UnstakeTokens(msg.sender,staked);
338     }
339 
340     /**
341      * @dev See `IERC20.allowance`.
342      */
343     function allowance(address owner, address spender) public view returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See `IERC20.approve`.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 value) public returns (bool) {
355         _approve(msg.sender, spender, value);
356         return true;
357     }
358 
359     /**
360      * @dev See `IERC20.transferFrom`.
361      *
362      * Emits an `Approval` event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of `ERC20`;
364      *
365      * Requirements:
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `value`.
368      * - the caller must have allowance for `sender`'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
372         _transfer(sender, recipient, amount);
373         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
374         return true;
375     }
376 
377     /**
378      * @dev Atomically increases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to `approve` that can be used as a mitigation for
381      * problems described in `IERC20.approve`.
382      *
383      * Emits an `Approval` event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      */
389     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
390         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
391         return true;
392     }
393 
394     /**
395      * @dev Atomically decreases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to `approve` that can be used as a mitigation for
398      * problems described in `IERC20.approve`.
399      *
400      * Emits an `Approval` event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      * - `spender` must have allowance for the caller of at least
406      * `subtractedValue`.
407      */
408     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
409         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
410         return true;
411     }
412 
413     /**
414      * @dev Moves tokens `amount` from `sender` to `recipient`.
415      *
416      * This is internal function is equivalent to `transfer`, and can be used to
417      * e.g. implement automatic token fees, slashing mechanisms, etc.
418      *
419      * Emits a `Transfer` event.
420      *
421      * Requirements:
422      *
423      * - `sender` cannot be the zero address.
424      * - `recipient` cannot be the zero address.
425      * - `sender` must have a balance of at least `amount`.
426      */
427     function _transfer(address sender, address recipient, uint256 amount) internal {
428         _balances[sender] = _balances[sender].sub(amount);
429         _balances[recipient] = _balances[recipient].add(amount);
430         emit Transfer(sender, recipient, amount);
431     }
432     /**
433      * @dev Transfer tokens from balance to locked balance of another wallet.
434      */
435     function _transferToLocked(address sender, address recipient, uint256 amount) internal {
436         _balances[sender] = _balances[sender].sub(amount);
437         _locked[recipient] = _locked[recipient].add(amount);
438         emit Transfer(sender, recipient, amount);
439         emit Lock(recipient, amount);
440     }
441 
442     /**
443      * @dev Owner can unlock wallet balance
444      */
445     function _unlockBalance(address target, uint256 amount) internal {
446         _balances[target] = _balances[target].add(amount);
447         _locked[target] = _locked[target].sub(amount);
448         emit Unlock(target, amount);
449     }
450     
451     function _addToStake(address account) internal {
452         _stakeable[account] = true;
453         emit StakeAdded(account);
454     }
455 
456     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
457      * the total supply.
458      *
459      * Emits a `Transfer` event with `from` set to the zero address.
460      *
461      * Requirements
462      *
463      * - `to` cannot be the zero address.
464      */
465     function _mint(address account, uint256 amount) internal {
466         require(account != address(0), "ERC20: mint to the zero address");
467 
468         _totalSupply = _totalSupply.add(amount);
469         _balances[account] = _balances[account].add(amount);
470         emit Transfer(address(0), account, amount);
471     }
472 
473     /**
474      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
475      *
476      * This is internal function is equivalent to `approve`, and can be used to
477      * e.g. set automatic allowances for certain subsystems, etc.
478      *
479      * Emits an `Approval` event.
480      *
481      * Requirements:
482      *
483      * - `owner` cannot be the zero address.
484      * - `spender` cannot be the zero address.
485      */
486     function _approve(address owner, address spender, uint256 value) internal {
487         require(owner != address(0), "ERC20: approve from the zero address");
488         require(spender != address(0), "ERC20: approve to the zero address");
489 
490         _allowances[owner][spender] = value;
491         emit Approval(owner, spender, value);
492     }
493 }
494 
495 // File: openzeppelin-solidity/contracts/access/Roles.sol
496 /**
497  * @title Roles
498  * @dev Library for managing addresses assigned to a Role.
499  */
500 library Roles {
501     struct Role {
502         mapping (address => bool) bearer;
503     }
504 
505     /**
506      * @dev Give an account access to this role.
507      */
508     function add(Role storage role, address account) internal {
509         require(!has(role, account), "Roles: account already has role");
510         role.bearer[account] = true;
511     }
512 
513     /**
514      * @dev Remove an account's access to this role.
515      */
516     function remove(Role storage role, address account) internal {
517         require(has(role, account), "Roles: account does not have role");
518         role.bearer[account] = false;
519     }
520 
521     /**
522      * @dev Check if an account has this role.
523      * @return bool
524      */
525     function has(Role storage role, address account) internal view returns (bool) {
526         require(account != address(0), "Roles: account is the zero address");
527         return role.bearer[account];
528     }
529 }
530 
531 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
532 contract PauserRole {
533     using Roles for Roles.Role;
534     
535     event PauserAdded(address indexed account);
536     Roles.Role private _pausers;
537 
538     constructor () internal {
539         _addPauser(msg.sender);
540     }
541 
542     modifier onlyPauser() {
543         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
544         _;
545     }
546 
547     function isPauser(address account) public view returns (bool) {
548         return _pausers.has(account);
549     }
550 
551     function addPauser(address account) public onlyPauser {
552         _addPauser(account);
553     }
554     
555     function _addPauser(address account) internal {
556         _pausers.add(account);
557         emit PauserAdded(account);
558     }
559 }
560 
561 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
562 /**
563  * @dev Contract module which allows children to implement an emergency stop
564  * mechanism that can be triggered by an authorized account.
565  *
566  * This module is used through inheritance. It will make available the
567  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
568  * the functions of your contract. Note that they will not be pausable by
569  * simply including this module, only once the modifiers are put in place.
570  */
571 contract Pausable is PauserRole {
572     /**
573      * @dev Emitted when the pause is triggered by a pauser (`account`).
574      */
575     event Paused(address account);
576 
577     /**
578      * @dev Emitted when the pause is lifted by a pauser (`account`).
579      */
580     event Unpaused(address account);
581 
582     bool private _paused;
583 
584     /**
585      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
586      * to the deployer.
587      */
588     constructor () internal {
589         _paused = false;
590     }
591 
592     /**
593      * @dev Returns true if the contract is paused, and false otherwise.
594      */
595     function paused() public view returns (bool) {
596         return _paused;
597     }
598 
599     /**
600      * @dev Modifier to make a function callable only when the contract is not paused.
601      */
602     modifier whenNotPaused() {
603         require(!_paused, "Pausable: paused");
604         _;
605     }
606 
607     /**
608      * @dev Modifier to make a function callable only when the contract is paused.
609      */
610     modifier whenPaused() {
611         require(_paused, "Pausable: not paused");
612         _;
613     }
614 
615     /**
616      * @dev Called by a pauser to pause, triggers stopped state.
617      */
618     function pause() public onlyPauser whenNotPaused {
619         _paused = true;
620         emit Paused(msg.sender);
621     }
622 
623     /**
624      * @dev Called by a pauser to unpause, returns to normal state.
625      */
626     function unpause() public onlyPauser whenPaused {
627         _paused = false;
628         emit Unpaused(msg.sender);
629     }
630 }
631 
632 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
633 /**
634  * @title Pausable token
635  * @dev ERC20 modified with pausable transfers.
636  */
637 contract ERC20Pausable is ERC20, Pausable {
638     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
639         return super.transfer(to, value);
640     }
641 
642     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
643         return super.transferFrom(from, to, value);
644     }
645 
646     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
647         return super.approve(spender, value);
648     }
649 
650     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
651         return super.increaseAllowance(spender, addedValue);
652     }
653 
654     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
655         return super.decreaseAllowance(spender, subtractedValue);
656     }
657 }
658 
659 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
660 /**
661  * @dev Contract module which provides a basic access control mechanism, where
662  * there is an account (an owner) that can be granted exclusive access to
663  * specific functions.
664  *
665  * This module is used through inheritance. It will make available the modifier
666  * `onlyOwner`, which can be aplied to your functions to restrict their use to
667  * the owner.
668  */
669 contract Ownable {
670     address private _owner;
671 
672     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
673 
674     /**
675      * @dev Initializes the contract setting the deployer as the initial owner.
676      */
677     constructor () internal {
678         _owner = msg.sender;
679         emit OwnershipTransferred(address(0), _owner);
680     }
681 
682     /**
683      * @dev Returns the address of the current owner.
684      */
685     function owner() public view returns (address) {
686         return _owner;
687     }
688 
689     /**
690      * @dev Throws if called by any account other than the owner.
691      */
692     modifier onlyOwner() {
693         require(isOwner(), "Ownable: caller is not the owner");
694         _;
695     }
696 
697     /**
698      * @dev Returns true if the caller is the current owner.
699      */
700     function isOwner() public view returns (bool) {
701         return msg.sender == _owner;
702     }
703 
704     /**
705      * @dev Leaves the contract without owner. It will not be possible to call
706      * `onlyOwner` functions anymore. Can only be called by the current owner.
707      *
708      * > Note: Renouncing ownership will leave the contract without an owner,
709      * thereby removing any functionality that is only available to the owner.
710      */
711     function renounceOwnership() public onlyOwner {
712         emit OwnershipTransferred(_owner, address(0));
713         _owner = address(0);
714     }
715 
716     /**
717      * @dev Transfers ownership of the contract to a new account (`newOwner`).
718      * Can only be called by the current owner.
719      */
720     function transferOwnership(address newOwner) public onlyOwner {
721         _transferOwnership(newOwner);
722     }
723 
724     /**
725      * @dev Transfers ownership of the contract to a new account (`newOwner`).
726      */
727     function _transferOwnership(address newOwner) internal {
728         require(newOwner != address(0), "Ownable: new owner is the zero address");
729         emit OwnershipTransferred(_owner, newOwner);
730         _owner = newOwner;
731     }
732 }
733 
734 // File: contracts/token/AWX.sol
735 /**
736  * @title AWX
737  * @notice ERC20 token implementation.
738  */
739 contract AWX is ERC20Pausable, Ownable {
740 
741     /**
742      * @dev The entire cap will be minted at deployment to owner.
743      */
744     uint256 public constant cap = 30000000 ether;
745 
746     /**
747      * @notice ERC20 convention.
748      */
749     uint8 public constant decimals = 18;
750 
751     /**
752      * @notice ERC20 convention.
753      */
754 
755     string public name = "AurusDeFi";
756 
757     /**
758      * @notice ERC20 convention.
759      */
760     string public symbol = "AWX";
761 
762     /**
763      * @dev Mints the entire cap to the owner.
764      */
765     constructor() public {
766         super._mint(owner(), cap);
767     }
768 
769     /**
770      * @dev Change the name and symbol of the token
771      */
772     function setTokenDetails(string memory _name, string memory _symbol, bool _stakeOpen, uint256 _stakeDuration) public onlyOwner {
773         name = _name;
774         symbol = _symbol;
775         stakeOpen = _stakeOpen;
776         stakeDuration = _stakeDuration;
777     }
778 
779     /**
780      * @dev An @param account that is whitelisted will be able to transfer the coin.
781      */
782     function addToStake(address account) public onlyOwner {
783         super._addToStake(account);
784     }
785 
786     /**
787      * @dev Transfer from balance to balance
788      */
789     function _transfer(address sender, address recipient, uint256 amount) internal {
790         super._transfer(sender, recipient, amount);
791     }
792 
793     /**
794      * @dev Transfer from balance to balance
795      */
796     function unlockBalance(address target, uint256 amount) external onlyOwner {
797         super._unlockBalance(target, amount);
798     }
799 
800     /**
801      * @dev Force a transfer between 2 accounts. AML logs on https://aurus.io/aml
802      */
803     function forceTransfer(address sender, address recipient, uint256 amount, bytes32 details) external onlyOwner {
804         _forceTransfer(sender,recipient,amount,details);
805     }
806 
807 
808     /**
809      * @dev Force a transfer between 2 accounts. AML logs on https://aurus.io/aml
810      */
811     function transferToLocked(address recipient, uint256 amount) public whenNotPaused {
812         _transferToLocked(msg.sender,recipient,amount);
813     }
814 }