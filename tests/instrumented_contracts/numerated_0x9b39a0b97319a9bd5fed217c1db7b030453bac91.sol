1 pragma solidity 0.5.10;
2 
3 
4 /**
5  * Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  */
8 library SafeMath {
9     /**
10      * Returns the addition of two unsigned integers, reverting on
11      * overflow.
12      *
13      * Counterpart to Solidity's `+` operator.
14      *
15      * Requirements:
16      * - Addition cannot overflow.
17      */
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     /**
26      * Returns the subtraction of two unsigned integers, reverting on
27      * overflow (when the result is negative).
28      *
29      * Counterpart to Solidity's `-` operator.
30      *
31      * Requirements:
32      * - Subtraction cannot overflow.
33      */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b <= a, "SafeMath: subtraction overflow");
36         uint256 c = a - b;
37 
38         return c;
39     }
40 
41     /**
42      * Returns the multiplication of two unsigned integers, reverting on
43      * overflow.
44      *
45      * Counterpart to Solidity's `*` operator.
46      *
47      * Requirements:
48      * - Multiplication cannot overflow.
49      */
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52         // benefit is lost if 'b' is also tested.
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59 
60         return c;
61     }
62 
63     /**
64      * Returns the integer division of two unsigned integers. Reverts on
65      * division by zero. The result is rounded towards zero.
66      *
67      * Counterpart to Solidity's `/` operator. Note: this function uses a
68      * `revert` opcode (which leaves remaining gas untouched) while Solidity
69      * uses an invalid opcode to revert (consuming all remaining gas).
70      *
71      * Requirements:
72      * - The divisor cannot be zero.
73      */
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Solidity only automatically asserts when dividing by 0
76         require(b > 0, "SafeMath: division by zero");
77         uint256 c = a / b;
78         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79 
80         return c;
81     }
82 
83     /**
84      * Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
85      * Reverts when dividing by zero.
86      *
87      * Counterpart to Solidity's `%` operator. This function uses a `revert`
88      * opcode (which leaves remaining gas untouched) while Solidity uses an
89      * invalid opcode to revert (consuming all remaining gas).
90      *
91      * Requirements:
92      * - The divisor cannot be zero.
93      */
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0, "SafeMath: modulo by zero");
96         return a % b;
97     }
98 }
99 
100 /**
101  * @title Roles
102  * Library for managing addresses assigned to a Role.
103  */
104 library Roles {
105     struct Role {
106         mapping (address => bool) bearer;
107     }
108 
109     /**
110      * Give an account access to this role.
111      */
112     function add(Role storage role, address account) internal {
113         require(!has(role, account), "Roles: account already has role");
114         role.bearer[account] = true;
115     }
116 
117     /**
118      * Remove an account's access to this role.
119      */
120     function remove(Role storage role, address account) internal {
121         require(has(role, account), "Roles: account does not have role");
122         role.bearer[account] = false;
123     }
124 
125     /**
126      * Check if an account has this role.
127      * @return bool
128      */
129     function has(Role storage role, address account) internal view returns (bool) {
130         require(account != address(0), "Roles: account is the zero address");
131         return role.bearer[account];
132     }
133 }
134 
135 contract Ownable {
136     address public owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140 
141     /**
142      * The Ownable constructor sets the original `owner` of the contract to the sender
143      * account.
144      */
145     constructor() public {
146         owner = msg.sender;
147     }
148 
149     /**
150      *Throws if called by any account other than the owner.
151      */
152     modifier onlyOwner() {
153         require(msg.sender == owner, "Ownable: the caller must be owner");
154         _;
155     }
156 
157     /**
158      * Allows the current owner to transfer control of the contract to a newOwner.
159      * @param _newOwner The address to transfer ownership to.
160      */
161     function transferOwnership(address _newOwner) public onlyOwner {
162         _transferOwnership(_newOwner);
163     }
164 
165     /**
166      * Transfers control of the contract to a newOwner.
167      * @param _newOwner The address to transfer ownership to.
168      */
169     function _transferOwnership(address _newOwner) internal {
170         require(_newOwner != address(0), "Ownable: new owner is the zero address");
171         emit OwnershipTransferred(owner, _newOwner);
172         owner = _newOwner;
173     }
174 }
175 
176 /**
177  * Interface of the ERC20 standard as defined in the EIP. Does not include
178  * the optional functions; to access them see `ERC20Detailed`.
179  */
180 interface IERC20 {
181     /**
182      * Returns the amount of tokens in existence.
183      */
184     function totalSupply() external view returns (uint256);
185 
186     /**
187      * Returns the amount of tokens owned by `account`.
188      */
189     function balanceOf(address account) external view returns (uint256);
190 
191     /**
192      * Moves `amount` tokens from the caller's account to `recipient`.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * Emits a `Transfer` event.
197      */
198     function transfer(address recipient, uint256 amount) external returns (bool);
199 
200     /**
201      * Returns the remaining number of tokens that `spender` will be
202      * allowed to spend on behalf of `owner` through `transferFrom`. This is
203      * zero by default.
204      *
205      * This value changes when `approve` or `transferFrom` are called.
206      */
207     function allowance(address owner, address spender) external view returns (uint256);
208 
209     /**
210      * Sets `amount` as the allowance of `spender` over the caller's tokens.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * > Beware that changing an allowance with this method brings the risk
215      * that someone may use both the old and the new allowance by unfortunate
216      * transaction ordering. One possible solution to mitigate this race
217      * condition is to first reduce the spender's allowance to 0 and set the
218      * desired value afterwards:
219      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220      *
221      * Emits an `Approval` event.
222      */
223     function approve(address spender, uint256 amount) external returns (bool);
224 
225     /**
226      * Moves `amount` tokens from `sender` to `recipient` using the
227      * allowance mechanism. `amount` is then deducted from the caller's
228      * allowance.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * Emits a `Transfer` event.
233      */
234     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
235 
236     /**
237      * Emitted when `value` tokens are moved from one account (`from`) to
238      * another (`to`).
239      *
240      * Note that `value` may be zero.
241      */
242     event Transfer(address indexed from, address indexed to, uint256 value);
243 
244     /**
245      *  Emitted when the allowance of a `spender` for an `owner` is set by
246      * a call to `approve`. `value` is the new allowance.
247      */
248     event Approval(address indexed owner, address indexed spender, uint256 value);
249 }
250 
251 /**
252  *  Implementation of the `IERC20` interface.
253  *
254  */
255 contract ERC20 is IERC20 {
256     using SafeMath for uint256;
257 
258     mapping (address => uint256) internal _balances;
259 
260     mapping (address => mapping (address => uint256)) internal _allowances;
261 
262     uint256 internal _totalSupply;
263 
264     /**
265      * See `IERC20.totalSupply`.
266      */
267     function totalSupply() public view returns (uint256) {
268         return _totalSupply;
269     }
270 
271     /**
272      *  See `IERC20.balanceOf`.
273      */
274     function balanceOf(address account) public view returns (uint256) {
275         return _balances[account];
276     }
277 
278     /**
279      *  See `IERC20.transfer`.
280      *
281      * Requirements:
282      *
283      * - `recipient` cannot be the zero address.
284      * - the caller must have a balance of at least `amount`.
285      */
286     function transfer(address recipient, uint256 amount) public returns (bool) {
287         _transfer(msg.sender, recipient, amount);
288         return true;
289     }
290 
291     /**
292      *  See `IERC20.allowance`.
293      */
294     function allowance(address owner, address spender) public view returns (uint256) {
295         return _allowances[owner][spender];
296     }
297 
298     /**
299      *  See `IERC20.approve`.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function approve(address spender, uint256 value) public returns (bool) {
306         _approve(msg.sender, spender, value);
307         return true;
308     }
309 
310     /**
311      * See `IERC20.transferFrom`.
312      *
313      * Emits an `Approval` event indicating the updated allowance. This is not
314      * required by the EIP. See the note at the beginning of `ERC20`;
315      *
316      * Requirements:
317      * - `sender` and `recipient` cannot be the zero address.
318      * - `sender` must have a balance of at least `value`.
319      * - the caller must have allowance for `sender`'s tokens of at least
320      * `amount`.
321      */
322     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
323         _transfer(sender, recipient, amount);
324         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
325         return true;
326     }
327 
328     /**
329      * Atomically increases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to `approve` that can be used as a mitigation for
332      * problems described in `IERC20.approve`.
333      *
334      * Emits an `Approval` event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
341         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
342         return true;
343     }
344 
345     /**
346      *  Atomically decreases the allowance granted to `spender` by the caller.
347      *
348      * This is an alternative to `approve` that can be used as a mitigation for
349      * problems described in `IERC20.approve`.
350      *
351      * Emits an `Approval` event indicating the updated allowance.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      * - `spender` must have allowance for the caller of at least
357      * `subtractedValue`.
358      */
359     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
360         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
361         return true;
362     }
363 
364     /**
365      *  Moves tokens `amount` from `sender` to `recipient`.
366      *
367      * This is internal function is equivalent to `transfer`, and can be used to
368      * e.g. implement automatic token fees, slashing mechanisms, etc.
369      *
370      * Emits a `Transfer` event.
371      *
372      * Requirements:
373      *
374      * - `sender` cannot be the zero address.
375      * - `recipient` cannot be the zero address.
376      * - `sender` must have a balance of at least `amount`.
377      */
378     function _transfer(address sender, address recipient, uint256 amount) internal {
379         require(sender != address(0), "ERC20: transfer from the zero address");
380         require(recipient != address(0), "ERC20: transfer to the zero address");
381 
382         _balances[sender] = _balances[sender].sub(amount);
383         _balances[recipient] = _balances[recipient].add(amount);
384         emit Transfer(sender, recipient, amount);
385     }
386 
387     /** Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      */
390     function _mint(address account, uint256 amount) internal {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _totalSupply = _totalSupply.add(amount);
394         _balances[account] = _balances[account].add(amount);
395         emit Transfer(address(0), account, amount);
396     }
397 
398     /**
399      *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
400      */
401     function _approve(address owner, address spender, uint256 value) internal {
402         require(owner != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[owner][spender] = value;
406         emit Approval(owner, spender, value);
407     }
408 
409 }
410 /**
411  *  Optional functions from the ERC20 standard.
412  */
413 contract ERC20Detailed is IERC20 {
414     string private _name;
415     string private _symbol;
416     uint8 private _decimals;
417 
418     /**
419      *  Set the values for `name`, `symbol`, and `decimals`. All three of
420      * these values are immutable: they can only be set once during
421      * construction.
422      */
423     constructor (string memory name, string memory symbol, uint8 decimals) public {
424         _name = name;
425         _symbol = symbol;
426         _decimals = decimals;
427     }
428 
429     /**
430      *  Return the name of the token.
431      */
432     function name() public view returns (string memory) {
433         return _name;
434     }
435 
436     /**
437      *  Return the symbol of the token, usually a shorter version of the
438      * name.
439      */
440     function symbol() public view returns (string memory) {
441         return _symbol;
442     }
443 
444     /**
445      *  Return the number of decimals used to get its user representation.
446      * For example, if `decimals` equals `2`, a balance of `505` tokens should
447      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
448      */
449     function decimals() public view returns (uint8) {
450         return _decimals;
451     }
452 }
453 
454 /**
455  *  Contract module which allows children to implement an emergency stop
456  * mechanism that can be triggered by an authorized account.
457  */
458 contract Pausable is Ownable {
459     /**
460      *  Emitted when the pause is triggered by a pauser (`account`).
461      */
462     event Paused(address account);
463 
464     /**
465      *  Emitted when the pause is lifted by a pauser (`account`).
466      */
467     event Unpaused(address account);
468 
469     bool private _paused;
470 
471     /**
472      *  Initialize the contract in unpaused state. Assigns the Pauser role
473      * to the deployer.
474      */
475     constructor () internal {
476         _paused = false;
477     }
478 
479     /**
480      *  Return true if the contract is paused, and false otherwise.
481      */
482     function paused() public view returns (bool) {
483         return _paused;
484     }
485 
486     /**
487      *  Modifier to make a function callable only when the contract is not paused.
488      */
489     modifier whenNotPaused() {
490         require(!_paused, "Pausable: paused");
491         _;
492     }
493 
494     /**
495      *  Modifier to make a function callable only when the contract is paused.
496      */
497     modifier whenPaused() {
498         require(_paused, "Pausable: not paused");
499         _;
500     }
501 
502     /**
503      *  Called by a pauser to pause, triggers stopped state.
504      */
505     function pause() public onlyOwner whenNotPaused {
506         _paused = true;
507         emit Paused(msg.sender);
508     }
509 
510     /**
511      *  Called by a pauser to unpause, returns to normal state.
512      */
513     function unpause() public onlyOwner whenPaused {
514         _paused = false;
515         emit Unpaused(msg.sender);
516     }
517 }
518 
519 /**
520  * @title Pausable token
521  *  ERC20 modified with pausable transfers.
522  */
523 contract ERC20Pausable is ERC20, Pausable {
524     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
525         return super.transfer(to, value);
526     }
527 
528     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
529         return super.transferFrom(from, to, value);
530     }
531 
532     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
533         return super.approve(spender, value);
534     }
535 
536     function increaseApproval(address spender, uint addedValue) public whenNotPaused returns (bool) {
537         return super.increaseApproval(spender, addedValue);
538     }
539 
540     function decreaseApproval(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
541         return super.decreaseApproval(spender, subtractedValue);
542     }
543 }
544 
545 contract MinterRole is Ownable {
546     using Roles for Roles.Role;
547 
548     event MinterAdded(address indexed account);
549     event MinterRemoved(address indexed account);
550 
551     Roles.Role private _minters;
552 
553     modifier onlyMinter() {
554         require(isMinter(msg.sender) || msg.sender == owner, "MinterRole: caller does not have the Minter role");
555         _;
556     }
557     function isMinter(address account) public view returns (bool) {
558         return _minters.has(account);
559     }
560 
561     function addMinter(address account) public onlyOwner {
562         _addMinter(account);
563     }
564 
565     function removeMinter(address account) public onlyOwner {
566         _removeMinter(account);
567     }
568 
569     function _addMinter(address account) internal {
570         _minters.add(account);
571         emit MinterAdded(account);
572     }
573 
574     function _removeMinter(address account) internal {
575         _minters.remove(account);
576         emit MinterRemoved(account);
577     }
578 }
579 
580 /**
581  *  Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
582  * which have permission to mint (create) new tokens as they see fit.
583  *
584  * At construction, the deployer of the contract is the only minter.
585  */
586 contract ERC20Mintable is ERC20, MinterRole {
587     /**
588      *  See `ERC20._mint`.
589      *
590      * Requirements:
591      * - the caller must have the `MinterRole`.
592      */
593     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
594         _mint(account, amount);
595         return true;
596     }
597 }
598 
599 /**
600  *  Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
601  */
602 contract ERC20Capped is ERC20Mintable {
603     uint256 internal _cap;
604     bool public isFinishMint;
605 
606     /**
607      * Returns the cap on the token's total supply.
608      */
609     function cap() public view returns (uint256) {
610         return _cap;
611     }
612 
613     /**
614      *  See `ERC20Mintable.mint`.
615      *
616      * Requirements:
617      *
618      * - `value` must not cause the total supply to go over the cap.
619      */
620     function _mint(address account, uint256 value) internal {
621         require(!isFinishMint, "ERC20Capped: minting has been finished");
622         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
623         if(totalSupply().add(value) == _cap) {
624             isFinishMint = true;
625         }
626         super._mint(account, value);
627     }
628 
629     function finishMint() public onlyOwner {
630         require(!isFinishMint, "ERC20Capped: minting has been finished");
631         isFinishMint = true;
632     }
633 }
634 
635 /**
636  * @title ERC20Burnable
637  * Implement the function of ERC20 token burning.
638  */
639 contract ERC20Burnable is ERC20, Ownable {
640 
641     event Burn(address indexed owner, uint256 amount);
642 
643     /**
644      * @dev Burn a specific amount of tokens.
645      * @param _value The amount of token to be burned.
646      */
647     function burn(uint256 _value) public onlyOwner {
648         require(_value <= _balances[msg.sender], "ERC20Burnable: not enough token balance");
649         // no need to require value <= totalSupply, since that would imply the
650         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
651 
652         _balances[msg.sender] = _balances[msg.sender].sub(_value);
653         _totalSupply = _totalSupply.sub(_value);
654         emit Burn(msg.sender, _value);
655         emit Transfer(msg.sender, address(0), _value);
656     }
657 }
658 
659 /**
660  *  Implementation of the TigerCash.
661  */ 
662 contract TigerCash is ERC20Detailed, ERC20Pausable, ERC20Capped, ERC20Burnable {
663 
664     // The total amount of locks at the specified address.
665     mapping (address => uint256) public totalLockAmount;
666     // The amount of released addresses of the specified address.
667     mapping (address => uint256) public releasedAmount;
668 
669     mapping (address => uint256) public lockedAmount;
670 
671     mapping (address => allocation[]) public allocations;
672 
673     struct allocation {
674         uint256 releaseTime;
675         uint256 releaseAmount;
676     }
677 
678     event LockToken(address indexed beneficiary, uint256[] releaseAmounts, uint256[] releaseTimes);
679     event ReleaseToken(address indexed user, uint256 releaseAmount, uint256 releaseTime);
680 
681     /**
682      *  Initialize token basic information.
683      */
684     constructor(string memory token_name, string memory token_symbol, uint8 token_decimals, uint256 token_cap) public
685         ERC20Detailed(token_name, token_symbol, token_decimals) {
686         _cap = token_cap * 10 ** uint256(token_decimals);
687         
688     }
689 
690     /**
691      *  Send the token to the beneficiary and lock it, and the timestamp and quantity of locks can be set by owner.
692      * @param _beneficiary A specified address.
693      * @param _releaseTimes Array,the timesamp of release token.
694      * @param _releaseAmounts Array,the amount of release token.
695      */
696     function lockToken(address _beneficiary, uint256[] memory _releaseTimes, uint256[] memory _releaseAmounts) public onlyOwner returns(bool) {
697         require(_beneficiary != address(0), "Token: the target address cannot be a zero address");
698         require(_releaseTimes.length == _releaseAmounts.length, "Token: the array length must be equal");
699         uint256 _lockedAmount;
700         for (uint256 i = 0; i < _releaseTimes.length; i++) {
701             _lockedAmount = _lockedAmount.add(_releaseAmounts[i]);
702             require(_releaseAmounts[i] > 0, "Token: the amount must be greater than 0");
703             require(_releaseTimes[i] >= now, "Token: the time must be greater than current time");
704             //Save the locktoken information
705             allocations[_beneficiary].push(allocation(_releaseTimes[i], _releaseAmounts[i]));
706         }
707         lockedAmount[_beneficiary] = lockedAmount[_beneficiary].add(_lockedAmount);
708         totalLockAmount[_beneficiary] = totalLockAmount[_beneficiary].add(_lockedAmount);
709         _balances[owner] = _balances[owner].sub(_lockedAmount); //Remove this part of the locked token from the owner.
710         _balances[_beneficiary] = _balances[_beneficiary].add(_lockedAmount);
711         emit Transfer(owner, _beneficiary, _lockedAmount);
712         emit LockToken(_beneficiary, _releaseAmounts, _releaseTimes);
713         return true;
714     }
715 
716     /**
717      * Rewrite the transfer function to automatically unlock the locked token.
718      */
719     function transfer(address to, uint256 value) public returns (bool) {
720         if(releasableAmount(msg.sender) > 0) {
721             _releaseToken(msg.sender);
722         }
723 
724         require(_balances[msg.sender].sub(lockedAmount[msg.sender]) >= value, "Token: not enough token balance");
725         super.transfer(to, value);
726         return true;
727     }
728 
729     /**
730      *  Rewrite the transferFrom function to automatically unlock the locked token.
731      */
732     function transferFrom(address from, address to, uint256 value) public returns (bool) {
733         if(releasableAmount(from) > 0) {
734             _releaseToken(from);
735         }
736         require(_balances[from].sub(lockedAmount[from]) >= value, "Token: not enough token balance");
737         super.transferFrom(from, to, value);
738         return true;
739     }
740 
741     /**
742      *  Get the amount of current timestamps that can be released.
743      * @param addr A specified address.
744      */
745     function releasableAmount(address addr) public view returns(uint256) {
746         uint256 num = 0;
747         for (uint256 i = 0; i < allocations[addr].length; i++) {
748             if (now >= allocations[addr][i].releaseTime) {
749                 num = num.add(allocations[addr][i].releaseAmount);
750             }
751         }
752         return num.sub(releasedAmount[addr]);
753     }
754 
755     /**
756      * Internal function, implement the basic functions of releasing tokens.
757      */
758     function _releaseToken(address _owner) internal returns(bool) {
759         
760         //Get the amount of release and update the lock-plans data.
761         uint256 amount = releasableAmount(_owner);
762         require(amount > 0, "Token: no releasable tokens");
763         lockedAmount[_owner] = lockedAmount[_owner].sub(amount);
764         releasedAmount[_owner] = releasedAmount[_owner].add(amount);
765         // If the token on this address has been completely released, the address lock record and the total amount of locks and the released amount are cleared.
766         if (releasedAmount[_owner] == totalLockAmount[_owner]) {
767             delete allocations[_owner]; // Clear the address history data.
768             totalLockAmount[_owner] = 0;
769             releasedAmount[_owner] = 0;
770             lockedAmount[_owner] = 0;
771         }
772         emit ReleaseToken(_owner, amount, now);
773         return true;
774     }
775 
776 }