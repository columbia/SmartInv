1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a `Transfer` event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through `transferFrom`. This is
26      * zero by default.
27      *
28      * This value changes when `approve` or `transferFrom` are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * > Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an `Approval` event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a `Transfer` event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to `approve`. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 library SafeMath {
74     /**
75      * @dev Returns the addition of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `+` operator.
79      *
80      * Requirements:
81      * - Addition cannot overflow.
82      */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "SafeMath: addition overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the subtraction of two unsigned integers, reverting on
92      * overflow (when the result is negative).
93      *
94      * Counterpart to Solidity's `-` operator.
95      *
96      * Requirements:
97      * - Subtraction cannot overflow.
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a, "SafeMath: subtraction overflow");
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117         // benefit is lost if 'b' is also tested.
118         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Solidity only automatically asserts when dividing by 0
142         require(b > 0, "SafeMath: division by zero");
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
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         require(b != 0, "SafeMath: modulo by zero");
162         return a % b;
163     }
164 }
165 contract ERC20 is IERC20 {
166     using SafeMath for uint256;
167 
168     // mapping (address => uint256) private _balances;
169     mapping (address => uint256) internal _balances;
170 
171     mapping (address => mapping (address => uint256)) private _allowances;
172 
173     uint256 private _totalSupply;
174 
175     /**
176      * @dev See `IERC20.totalSupply`.
177      */
178     function totalSupply() public view returns (uint256) {
179         return _totalSupply;
180     }
181 
182     /**
183      * @dev See `IERC20.balanceOf`.
184      */
185     function balanceOf(address account) public view returns (uint256) {
186         return _balances[account];
187     }
188 
189     /**
190      * @dev See `IERC20.transfer`.
191      *
192      * Requirements:
193      *
194      * - `recipient` cannot be the zero address.
195      * - the caller must have a balance of at least `amount`.
196      */
197     function transfer(address recipient, uint256 amount) public returns (bool) {
198         _transfer(msg.sender, recipient, amount);
199         return true;
200     }
201 
202     /**
203      * @dev See `IERC20.allowance`.
204      */
205     function allowance(address owner, address spender) public view returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     /**
210      * @dev See `IERC20.approve`.
211      *
212      * Requirements:
213      *
214      * - `spender` cannot be the zero address.
215      */
216     function approve(address spender, uint256 value) public returns (bool) {
217         _approve(msg.sender, spender, value);
218         return true;
219     }
220 
221     /**
222      * @dev See `IERC20.transferFrom`.
223      *
224      * Emits an `Approval` event indicating the updated allowance. This is not
225      * required by the EIP. See the note at the beginning of `ERC20`;
226      *
227      * Requirements:
228      * - `sender` and `recipient` cannot be the zero address.
229      * - `sender` must have a balance of at least `value`.
230      * - the caller must have allowance for `sender`'s tokens of at least
231      * `amount`.
232      */
233     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
234         _transfer(sender, recipient, amount);
235         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
236         return true;
237     }
238 
239     /**
240      * @dev Atomically increases the allowance granted to `spender` by the caller.
241      *
242      * This is an alternative to `approve` that can be used as a mitigation for
243      * problems described in `IERC20.approve`.
244      *
245      * Emits an `Approval` event indicating the updated allowance.
246      *
247      * Requirements:
248      *
249      * - `spender` cannot be the zero address.
250      */
251     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
252         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
253         return true;
254     }
255 
256     /**
257      * @dev Atomically decreases the allowance granted to `spender` by the caller.
258      *
259      * This is an alternative to `approve` that can be used as a mitigation for
260      * problems described in `IERC20.approve`.
261      *
262      * Emits an `Approval` event indicating the updated allowance.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      * - `spender` must have allowance for the caller of at least
268      * `subtractedValue`.
269      */
270     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
271         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
272         return true;
273     }
274 
275     /**
276      * @dev Moves tokens `amount` from `sender` to `recipient`.
277      *
278      * This is internal function is equivalent to `transfer`, and can be used to
279      * e.g. implement automatic token fees, slashing mechanisms, etc.
280      *
281      * Emits a `Transfer` event.
282      *
283      * Requirements:
284      *
285      * - `sender` cannot be the zero address.
286      * - `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      */
289     function _transfer(address sender, address recipient, uint256 amount) internal {
290         require(sender != address(0), "ERC20: transfer from the zero address");
291         require(recipient != address(0), "ERC20: transfer to the zero address");
292 
293         _balances[sender] = _balances[sender].sub(amount);
294         _balances[recipient] = _balances[recipient].add(amount);
295         emit Transfer(sender, recipient, amount);
296     }
297 
298     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
299      * the total supply.
300      *
301      * Emits a `Transfer` event with `from` set to the zero address.
302      *
303      * Requirements
304      *
305      * - `to` cannot be the zero address.
306      */
307     function _mint(address account, uint256 amount) internal {
308         require(account != address(0), "ERC20: mint to the zero address");
309 
310         _totalSupply = _totalSupply.add(amount);
311         _balances[account] = _balances[account].add(amount);
312         emit Transfer(address(0), account, amount);
313     }
314 
315      /**
316      * @dev Destoys `amount` tokens from `account`, reducing the
317      * total supply.
318      *
319      * Emits a `Transfer` event with `to` set to the zero address.
320      *
321      * Requirements
322      *
323      * - `account` cannot be the zero address.
324      * - `account` must have at least `amount` tokens.
325      */
326     function _burn(address account, uint256 value) internal {
327         require(account != address(0), "ERC20: burn from the zero address");
328 
329         _totalSupply = _totalSupply.sub(value);
330         _balances[account] = _balances[account].sub(value);
331         emit Transfer(account, address(0), value);
332     }
333 
334     /**
335      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
336      *
337      * This is internal function is equivalent to `approve`, and can be used to
338      * e.g. set automatic allowances for certain subsystems, etc.
339      *
340      * Emits an `Approval` event.
341      *
342      * Requirements:
343      *
344      * - `owner` cannot be the zero address.
345      * - `spender` cannot be the zero address.
346      */
347     function _approve(address owner, address spender, uint256 value) internal {
348         require(owner != address(0), "ERC20: approve from the zero address");
349         require(spender != address(0), "ERC20: approve to the zero address");
350 
351         _allowances[owner][spender] = value;
352         emit Approval(owner, spender, value);
353     }
354 
355     /**
356      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
357      * from the caller's allowance.
358      *
359      * See `_burn` and `_approve`.
360      */
361     function _burnFrom(address account, uint256 amount) internal {
362         _burn(account, amount);
363         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
364     }
365 }
366 library Roles {
367     struct Role {
368         mapping (address => bool) bearer;
369     }
370 
371     /**
372      * @dev Give an account access to this role.
373      */
374     function add(Role storage role, address account) internal {
375         require(!has(role, account), "Roles: account already has role");
376         role.bearer[account] = true;
377     }
378 
379     /**
380      * @dev Remove an account's access to this role.
381      */
382     function remove(Role storage role, address account) internal {
383         require(has(role, account), "Roles: account does not have role");
384         role.bearer[account] = false;
385     }
386 
387     /**
388      * @dev Check if an account has this role.
389      * @return bool
390      */
391     function has(Role storage role, address account) internal view returns (bool) {
392         require(account != address(0), "Roles: account is the zero address");
393         return role.bearer[account];
394     }
395 }
396 contract MinterRole {
397     using Roles for Roles.Role;
398 
399     event MinterAdded(address indexed account);
400     event MinterRemoved(address indexed account);
401 
402     Roles.Role private _minters;
403 
404     constructor () internal {
405         _addMinter(msg.sender);
406     }
407 
408     modifier onlyMinter() {
409         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
410         _;
411     }
412 
413     function isMinter(address account) public view returns (bool) {
414         return _minters.has(account);
415     }
416 
417     function addMinter(address account) public onlyMinter {
418         _addMinter(account);
419     }
420 
421     function renounceMinter() public {
422         _removeMinter(msg.sender);
423     }
424 
425     function _addMinter(address account) internal {
426         _minters.add(account);
427         emit MinterAdded(account);
428     }
429 
430     function _removeMinter(address account) internal {
431         _minters.remove(account);
432         emit MinterRemoved(account);
433     }
434 }
435 contract ERC20Mintable is ERC20, MinterRole {
436     /**
437      * @dev See `ERC20._mint`.
438      *
439      * Requirements:
440      *
441      * - the caller must have the `MinterRole`.
442      */
443     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
444         _mint(account, amount);
445         return true;
446     }
447 }
448 contract PauserRole {
449     using Roles for Roles.Role;
450 
451     event PauserAdded(address indexed account);
452     event PauserRemoved(address indexed account);
453 
454     Roles.Role private _pausers;
455 
456     constructor () internal {
457         _addPauser(msg.sender);
458     }
459 
460     modifier onlyPauser() {
461         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
462         _;
463     }
464 
465     function isPauser(address account) public view returns (bool) {
466         return _pausers.has(account);
467     }
468 
469     function addPauser(address account) public onlyPauser {
470         _addPauser(account);
471     }
472 
473     function renouncePauser() public {
474         _removePauser(msg.sender);
475     }
476 
477     function _addPauser(address account) internal {
478         _pausers.add(account);
479         emit PauserAdded(account);
480     }
481 
482     function _removePauser(address account) internal {
483         _pausers.remove(account);
484         emit PauserRemoved(account);
485     }
486 }
487 contract Pausable is PauserRole {
488     /**
489      * @dev Emitted when the pause is triggered by a pauser (`account`).
490      */
491     event Paused(address account);
492 
493     /**
494      * @dev Emitted when the pause is lifted by a pauser (`account`).
495      */
496     event Unpaused(address account);
497 
498     bool private _paused;
499 
500     /**
501      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
502      * to the deployer.
503      */
504     constructor () internal {
505         _paused = false;
506     }
507 
508     /**
509      * @dev Returns true if the contract is paused, and false otherwise.
510      */
511     function paused() public view returns (bool) {
512         return _paused;
513     }
514 
515     /**
516      * @dev Modifier to make a function callable only when the contract is not paused.
517      */
518     modifier whenNotPaused() {
519         require(!_paused, "Pausable: paused");
520         _;
521     }
522 
523     /**
524      * @dev Modifier to make a function callable only when the contract is paused.
525      */
526     modifier whenPaused() {
527         require(_paused, "Pausable: not paused");
528         _;
529     }
530 
531     /**
532      * @dev Called by a pauser to pause, triggers stopped state.
533      */
534     function pause() public onlyPauser whenNotPaused {
535         _paused = true;
536         emit Paused(msg.sender);
537     }
538 
539     /**
540      * @dev Called by a pauser to unpause, returns to normal state.
541      */
542     function unpause() public onlyPauser whenPaused {
543         _paused = false;
544         emit Unpaused(msg.sender);
545     }
546 }
547 contract ERC20Pausable is ERC20, Pausable {
548     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
549         return super.transfer(to, value);
550     }
551 
552     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
553         return super.transferFrom(from, to, value);
554     }
555 
556     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
557         return super.approve(spender, value);
558     }
559 
560     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
561         return super.increaseAllowance(spender, addedValue);
562     }
563 
564     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
565         return super.decreaseAllowance(spender, subtractedValue);
566     }
567 }
568 contract ERC20Burnable is ERC20 {
569     /**
570      * @dev Destoys `amount` tokens from the caller.
571      *
572      * See `ERC20._burn`.
573      */
574     function burn(uint256 amount) public {
575         _burn(msg.sender, amount);
576     }
577 
578     /**
579      * @dev See `ERC20._burnFrom`.
580      */
581     function burnFrom(address account, uint256 amount) public {
582         _burnFrom(account, amount);
583     }
584 }
585 contract Ownable {
586     address private _owner;
587 
588     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
589 
590     /**
591      * @dev Initializes the contract setting the deployer as the initial owner.
592      */
593     constructor () internal {
594         _owner = msg.sender;
595         emit OwnershipTransferred(address(0), _owner);
596     }
597 
598     /**
599      * @dev Returns the address of the current owner.
600      */
601     function owner() public view returns (address) {
602         return _owner;
603     }
604 
605     /**
606      * @dev Throws if called by any account other than the owner.
607      */
608     modifier onlyOwner() {
609         require(isOwner(), "Ownable: caller is not the owner");
610         _;
611     }
612 
613     /**
614      * @dev Returns true if the caller is the current owner.
615      */
616     function isOwner() public view returns (bool) {
617         return msg.sender == _owner;
618     }
619 
620     /**
621      * @dev Leaves the contract without owner. It will not be possible to call
622      * `onlyOwner` functions anymore. Can only be called by the current owner.
623      *
624      * > Note: Renouncing ownership will leave the contract without an owner,
625      * thereby removing any functionality that is only available to the owner.
626      */
627     function renounceOwnership() public onlyOwner {
628         emit OwnershipTransferred(_owner, address(0));
629         _owner = address(0);
630     }
631 
632     /**
633      * @dev Transfers ownership of the contract to a new account (`newOwner`).
634      * Can only be called by the current owner.
635      */
636     function transferOwnership(address newOwner) public onlyOwner {
637         _transferOwnership(newOwner);
638     }
639 
640     /**
641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
642      */
643     function _transferOwnership(address newOwner) internal {
644         require(newOwner != address(0), "Ownable: new owner is the zero address");
645         emit OwnershipTransferred(_owner, newOwner);
646         _owner = newOwner;
647     }
648 }
649 /**
650  * @title ERC1132 interface
651  * @dev see https://github.com/ethereum/EIPs/issues/1132
652  */
653 
654 contract ERC1132 {
655     /**
656      * @dev Reasons why a user's tokens have been locked
657      */
658     mapping(address => bytes32[]) public lockReason;
659 
660     /**
661      * @dev locked token structure
662      */
663     struct lockToken {
664         uint256 amount;
665         uint256 validity;
666         bool claimed;
667     }
668 
669     /**
670      * @dev Holds number & validity of tokens locked for a given reason for
671      *      a specified address
672      */
673     mapping(address => mapping(bytes32 => lockToken)) public locked;
674 
675     /**
676      * @dev Records data of all the tokens Locked
677      */
678     event Locked(
679         address indexed _of,
680         bytes32 indexed _reason,
681         uint256 _amount,
682         uint256 _validity
683     );
684 
685     /**
686      * @dev Records data of all the tokens unlocked
687      */
688     event Unlocked(
689         address indexed _of,
690         bytes32 indexed _reason,
691         uint256 _amount
692     );
693 
694     /**
695      * @dev Locks a specified amount of tokens against an address,
696      *      for a specified reason and time
697      * @param _reason The reason to lock tokens
698      * @param _amount Number of tokens to be locked
699      * @param _time Lock time in seconds
700      */
701     // function lock(bytes32 _reason, uint256 _amount, uint256 _time) public returns (bool);
702     function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public returns (bool);
703 
704     /**
705      * @dev Returns tokens locked for a specified address for a
706      *      specified reason
707      *
708      * @param _of The address whose tokens are locked
709      * @param _reason The reason to query the lock tokens for
710      */
711     function tokensLocked(address _of, bytes32 _reason) public view returns (uint256 amount);
712 
713     /**
714      * @dev Returns tokens locked for a specified address for a
715      *      specified reason at a specific time
716      *
717      * @param _of The address whose tokens are locked
718      * @param _reason The reason to query the lock tokens for
719      * @param _time The timestamp to query the lock tokens for
720      */
721     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time) public view returns (uint256 amount);
722 
723     /**
724      * @dev Returns total tokens held by an address (locked + transferable)
725      * @param _of The address to query the total balance of
726      */
727     function totalBalanceOf(address _of) public view returns (uint256 amount);
728 
729     /**
730      * @dev Extends lock for a specified reason and time
731      * @param _reason The reason to lock tokens
732      * @param _time Lock extension time in seconds
733      */
734     function extendLock(bytes32 _reason, uint256 _time) public returns (bool);
735 
736     /**
737      * @dev Increase number of tokens locked for a specified reason
738      * @param _reason The reason to lock tokens
739      * @param _amount Number of tokens to be increased
740      */
741     function increaseLockAmount(bytes32 _reason, uint256 _amount) public returns (bool);
742 
743     /**
744      * @dev Returns unlockable tokens for a specified address for a specified reason
745      * @param _of The address to query the the unlockable token count of
746      * @param _reason The reason to query the unlockable tokens for
747      */
748     function tokensUnlockable(address _of, bytes32 _reason) public view returns (uint256 amount);
749 
750     /**
751      * @dev Unlocks the unlockable tokens of a specified address
752      * @param _of Address of user, claiming back unlockable tokens
753      */
754     function unlock(address _of) public returns (uint256 unlockableTokens);
755 
756     /**
757      * @dev Gets the unlockable tokens of a specified address
758      * @param _of The address to query the the unlockable token count of
759      */
760     function getUnlockableTokens(address _of) public view returns (uint256 unlockableTokens);
761 
762 }
763 
764 contract ERC20Detailed is IERC20 {
765     string private _name;
766     string private _symbol;
767     uint8 private _decimals;
768 
769     /**
770      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
771      * these values are immutable: they can only be set once during
772      * construction.
773      */
774     constructor (string memory name, string memory symbol, uint8 decimals) public {
775         _name = name;
776         _symbol = symbol;
777         _decimals = decimals;
778     }
779 
780     /**
781      * @dev Returns the name of the token.
782      */
783     function name() public view returns (string memory) {
784         return _name;
785     }
786 
787     /**
788      * @dev Returns the symbol of the token, usually a shorter version of the
789      * name.
790      */
791     function symbol() public view returns (string memory) {
792         return _symbol;
793     }
794 
795     /**
796      * @dev Returns the number of decimals used to get its user representation.
797      * For example, if `decimals` equals `2`, a balance of `505` tokens should
798      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
799      *
800      * Tokens usually opt for a value of 18, imitating the relationship between
801      * Ether and Wei.
802      *
803      * > Note that this information is only used for _display_ purposes: it in
804      * no way affects any of the arithmetic of the contract, including
805      * `IERC20.balanceOf` and `IERC20.transfer`.
806      */
807     function decimals() public view returns (uint8) {
808         return _decimals;
809     }
810 }
811 
812 //Coin contract
813 contract HugCoin is ERC20Detailed, ERC20, ERC20Mintable, ERC20Pausable, ERC20Burnable, Ownable,ERC1132 {
814 	/**
815 	* @dev Error messages for require statements
816 	*/
817 	string internal constant ALREADY_LOCKED = 'Tokens already locked';
818 	string internal constant NOT_LOCKED = 'No tokens locked';
819 	string internal constant AMOUNT_ZERO = 'Amount can not be 0';
820 	string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
821 
822   constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) ERC20Detailed(name, symbol, decimals) public {
823     _mint(owner(), totalSupply * 10 ** uint(decimals));
824   }
825 
826 	/**
827 		* @dev Locks a specified amount of tokens against an address,
828 		*      for a specified reason and time
829 		* @param _reason The reason to lock tokens
830 		* @param _amount Number of tokens to be locked
831 		* @param _time Lock time in seconds
832 		* @param _of address to be locked // 추가
833 		*/
834 	function lock(bytes32 _reason, uint256 _amount, uint256 _time, address _of) public onlyOwner returns (bool) {
835 		uint256 validUntil = now.add(_time); //solhint-disable-line
836 
837 		// If tokens are already locked, then functions extendLock or
838 		// increaseLockAmount should be used to make any changes
839 		require(_amount <= _balances[_of], NOT_ENOUGH_TOKENS); // 추가
840 		require(tokensLocked(_of, _reason) == 0, ALREADY_LOCKED);
841 		require(_amount != 0, AMOUNT_ZERO);
842 
843 		if (locked[_of][_reason].amount == 0){
844 			lockReason[_of].push(_reason);
845 		}
846 
847 		// transfer(address(this), _amount); // 수정
848 		_balances[address(this)] = _balances[address(this)].add(_amount);
849 		_balances[_of] = _balances[_of].sub(_amount);
850 
851 		locked[_of][_reason] = lockToken(_amount, validUntil, false);
852 
853 			// 수정
854 		emit Transfer(_of, address(this), _amount);
855 		emit Locked(_of, _reason, _amount, validUntil);
856 		return true;
857 	}
858 
859 	/**
860 		* @dev Transfers and Locks a specified amount of tokens,
861 		*      for a specified reason and time
862 		* @param _to adress to which tokens are to be transfered
863 		* @param _reason The reason to lock tokens
864 		* @param _amount Number of tokens to be transfered and locked
865 		* @param _time Lock time in seconds
866 		*/
867 	function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time) public onlyOwner returns (bool) {
868 		uint256 validUntil = now.add(_time ); //solhint-disable-line
869 
870 		require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
871 		require(_amount != 0, AMOUNT_ZERO);
872 
873 		if (locked[_to][_reason].amount == 0){
874 			lockReason[_to].push(_reason);
875 		}
876 
877 		transfer(address(this), _amount);
878 
879 		locked[_to][_reason] = lockToken(_amount, validUntil, false);
880 
881 		emit Locked(_to, _reason, _amount, validUntil);
882 		return true;
883 	}
884 
885 	/**
886 		* @dev Returns tokens locked for a specified address for a
887 		*      specified reason
888 		*
889 		* @param _of The address whose tokens are locked
890 		* @param _reason The reason to query the lock tokens for
891 		*/
892 	function tokensLocked(address _of, bytes32 _reason) public onlyOwner view returns (uint256 amount) {
893 		if (!locked[_of][_reason].claimed){
894 			amount = locked[_of][_reason].amount;
895 		}
896 	}
897 
898 	/**
899 		* @dev Returns tokens locked for a specified address for a
900 		*      specified reason at a specific time
901 		*
902 		* @param _of The address whose tokens are locked
903 		* @param _reason The reason to query the lock tokens for
904 		* @param _time The timestamp to query the lock tokens for
905 		*/
906 	function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time) public onlyOwner view returns (uint256 amount) {
907 		if (locked[_of][_reason].validity > _time){
908 			amount = locked[_of][_reason].amount;
909 		}
910 	}
911 
912 	/**
913 		* @dev Returns total tokens held by an address (locked + transferable)
914 		* @param _of The address to query the total balance of
915 		*/
916 	function totalBalanceOf(address _of) public onlyOwner view returns (uint256 amount) {
917 		amount = balanceOf(_of);
918 		for (uint256 i = 0; i < lockReason[_of].length; i++) {
919 			amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
920 		}
921 	}
922 
923 	/**
924 		* @dev Extends lock for a specified reason and time
925 		* @param _reason The reason to lock tokens
926 		* @param _time Lock extension time in seconds
927 		*/
928 	function extendLock(bytes32 _reason, uint256 _time) public onlyOwner returns (bool) {
929 		require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
930 		locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
931 		emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
932 		return true;
933 	}
934 
935 
936 	/**
937 		* @dev Increase number of tokens locked for a specified reason
938 		* @param _reason The reason to lock tokens
939 		* @param _amount Number of tokens to be increased
940 		*/
941 	function increaseLockAmount(bytes32 _reason, uint256 _amount) public onlyOwner returns (bool) {
942 		require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
943 		transfer(address(this), _amount);
944 
945 		locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
946 
947 		emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
948 		return true;
949 	}
950 
951 	/**
952 		* @dev Returns unlockable tokens for a specified address for a specified reason
953 		* @param _of The address to query the the unlockable token count of
954 		* @param _reason The reason to query the unlockable tokens for
955 		*/
956 	function tokensUnlockable(address _of, bytes32 _reason) public onlyOwner view returns (uint256 amount) {
957 		//주석처리함
958 		// if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
959 		amount = locked[_of][_reason].amount;
960 	}
961 
962 	/**
963 		* @dev Unlocks the unlockable tokens of a specified address
964 		* @param _of Address of user, claiming back unlockable tokens
965 		*/
966 	function unlock(address _of) public onlyOwner returns (uint256 unlockableTokens) {
967 		uint256 lockedTokens;
968 		for (uint256 i = 0; i < lockReason[_of].length; i++) {
969 			lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
970 			if (lockedTokens > 0) {
971 				unlockableTokens = unlockableTokens.add(lockedTokens);
972 				locked[_of][lockReason[_of][i]].claimed = true;
973 				emit Unlocked(_of, lockReason[_of][i], lockedTokens);
974 			}
975 		}
976 
977 		if (unlockableTokens > 0) {
978 			this.transfer(_of, unlockableTokens);
979 		}
980 	}
981 
982 	/**
983 		* @dev Gets the unlockable tokens of a specified address
984 		* @param _of The address to query the the unlockable token count of
985 		*/
986 	function getUnlockableTokens(address _of) public onlyOwner view returns (uint256 unlockableTokens){
987 		for (uint256 i = 0; i < lockReason[_of].length; i++) {
988 			unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
989 		}
990 	}
991 }