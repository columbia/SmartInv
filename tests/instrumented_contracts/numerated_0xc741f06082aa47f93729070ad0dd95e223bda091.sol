1 
2 
3 contract Context {
4     // Empty internal constructor, to prevent people from mistakenly deploying
5     // an instance of this contract, which should be used via inheritance.
6     constructor () internal { }
7     // solhint-disable-previous-line no-empty-blocks
8 
9     function _msgSender() internal view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      * - Subtraction cannot overflow.
128      *
129      * _Available since v2.4.0._
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
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
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      *
187      * _Available since v2.4.0._
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         // Solidity only automatically asserts when dividing by 0
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 contract ERC20 is Context, IERC20 {
233     using SafeMath for uint256;
234 
235     mapping (address => uint256) private _balances;
236 
237     mapping (address => mapping (address => uint256)) private _allowances;
238 
239     uint256 private _totalSupply;
240 
241     /**
242      * @dev See {IERC20-totalSupply}.
243      */
244     function totalSupply() public view returns (uint256) {
245         return _totalSupply;
246     }
247 
248     /**
249      * @dev See {IERC20-balanceOf}.
250      */
251     function balanceOf(address account) public view returns (uint256) {
252         return _balances[account];
253     }
254 
255     /**
256      * @dev See {IERC20-transfer}.
257      *
258      * Requirements:
259      *
260      * - `recipient` cannot be the zero address.
261      * - the caller must have a balance of at least `amount`.
262      */
263     function transfer(address recipient, uint256 amount) public returns (bool) {
264         _transfer(_msgSender(), recipient, amount);
265         return true;
266     }
267 
268     /**
269      * @dev See {IERC20-allowance}.
270      */
271     function allowance(address owner, address spender) public view returns (uint256) {
272         return _allowances[owner][spender];
273     }
274 
275     /**
276      * @dev See {IERC20-approve}.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public returns (bool) {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20};
292      *
293      * Requirements:
294      * - `sender` and `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      * - the caller must have allowance for `sender`'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
300         _transfer(sender, recipient, amount);
301         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
302         return true;
303     }
304 
305     /**
306      * @dev Atomically increases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
318         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
319         return true;
320     }
321 
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
337         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
338         return true;
339     }
340 
341     /**
342      * @dev Moves tokens `amount` from `sender` to `recipient`.
343      *
344      * This is internal function is equivalent to {transfer}, and can be used to
345      * e.g. implement automatic token fees, slashing mechanisms, etc.
346      *
347      * Emits a {Transfer} event.
348      *
349      * Requirements:
350      *
351      * - `sender` cannot be the zero address.
352      * - `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      */
355     function _transfer(address sender, address recipient, uint256 amount) internal {
356         require(sender != address(0), "ERC20: transfer from the zero address");
357         require(recipient != address(0), "ERC20: transfer to the zero address");
358 
359         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
360         _balances[recipient] = _balances[recipient].add(amount);
361         emit Transfer(sender, recipient, amount);
362     }
363 
364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
365      * the total supply.
366      *
367      * Emits a {Transfer} event with `from` set to the zero address.
368      *
369      * Requirements
370      *
371      * - `to` cannot be the zero address.
372      */
373     function _mint(address account, uint256 amount) internal {
374         require(account != address(0), "ERC20: mint to the zero address");
375 
376         _totalSupply = _totalSupply.add(amount);
377         _balances[account] = _balances[account].add(amount);
378         emit Transfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
396         _totalSupply = _totalSupply.sub(amount);
397         emit Transfer(account, address(0), amount);
398     }
399 
400     /**
401      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
402      *
403      * This is internal function is equivalent to `approve`, and can be used to
404      * e.g. set automatic allowances for certain subsystems, etc.
405      *
406      * Emits an {Approval} event.
407      *
408      * Requirements:
409      *
410      * - `owner` cannot be the zero address.
411      * - `spender` cannot be the zero address.
412      */
413     function _approve(address owner, address spender, uint256 amount) internal {
414         require(owner != address(0), "ERC20: approve from the zero address");
415         require(spender != address(0), "ERC20: approve to the zero address");
416 
417         _allowances[owner][spender] = amount;
418         emit Approval(owner, spender, amount);
419     }
420 
421     /**
422      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
423      * from the caller's allowance.
424      *
425      * See {_burn} and {_approve}.
426      */
427     function _burnFrom(address account, uint256 amount) internal {
428         _burn(account, amount);
429         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
430     }
431 }
432 
433 contract ERC20Burnable is Context, ERC20 {
434     /**
435      * @dev Destroys `amount` tokens from the caller.
436      *
437      * See {ERC20-_burn}.
438      */
439     function burn(uint256 amount) public {
440         _burn(_msgSender(), amount);
441     }
442 
443     /**
444      * @dev See {ERC20-_burnFrom}.
445      */
446     function burnFrom(address account, uint256 amount) public {
447         _burnFrom(account, amount);
448     }
449 }
450 
451 library Roles {
452     struct Role {
453         mapping (address => bool) bearer;
454     }
455 
456     /**
457      * @dev Give an account access to this role.
458      */
459     function add(Role storage role, address account) internal {
460         require(!has(role, account), "Roles: account already has role");
461         role.bearer[account] = true;
462     }
463 
464     /**
465      * @dev Remove an account's access to this role.
466      */
467     function remove(Role storage role, address account) internal {
468         require(has(role, account), "Roles: account does not have role");
469         role.bearer[account] = false;
470     }
471 
472     /**
473      * @dev Check if an account has this role.
474      * @return bool
475      */
476     function has(Role storage role, address account) internal view returns (bool) {
477         require(account != address(0), "Roles: account is the zero address");
478         return role.bearer[account];
479     }
480 }
481 
482 contract MinterRole is Context {
483     using Roles for Roles.Role;
484 
485     event MinterAdded(address indexed account);
486     event MinterRemoved(address indexed account);
487 
488     Roles.Role private _minters;
489 
490     constructor () internal {
491         _addMinter(_msgSender());
492     }
493 
494     modifier onlyMinter() {
495         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
496         _;
497     }
498 
499     function isMinter(address account) public view returns (bool) {
500         return _minters.has(account);
501     }
502 
503     function addMinter(address account) public onlyMinter {
504         _addMinter(account);
505     }
506 
507     function renounceMinter() public {
508         _removeMinter(_msgSender());
509     }
510 
511     function _addMinter(address account) internal {
512         _minters.add(account);
513         emit MinterAdded(account);
514     }
515 
516     function _removeMinter(address account) internal {
517         _minters.remove(account);
518         emit MinterRemoved(account);
519     }
520 }
521 
522 contract ERC20Mintable is ERC20, MinterRole {
523     /**
524      * @dev See {ERC20-_mint}.
525      *
526      * Requirements:
527      *
528      * - the caller must have the {MinterRole}.
529      */
530     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
531         _mint(account, amount);
532         return true;
533     }
534 }
535 
536 contract PauserRole is Context {
537     using Roles for Roles.Role;
538 
539     event PauserAdded(address indexed account);
540     event PauserRemoved(address indexed account);
541 
542     Roles.Role private _pausers;
543 
544     constructor () internal {
545         _addPauser(_msgSender());
546     }
547 
548     modifier onlyPauser() {
549         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
550         _;
551     }
552 
553     function isPauser(address account) public view returns (bool) {
554         return _pausers.has(account);
555     }
556 
557     function addPauser(address account) public onlyPauser {
558         _addPauser(account);
559     }
560 
561     function renouncePauser() public {
562         _removePauser(_msgSender());
563     }
564 
565     function _addPauser(address account) internal {
566         _pausers.add(account);
567         emit PauserAdded(account);
568     }
569 
570     function _removePauser(address account) internal {
571         _pausers.remove(account);
572         emit PauserRemoved(account);
573     }
574 }
575 
576 contract Pausable is Context, PauserRole {
577     /**
578      * @dev Emitted when the pause is triggered by a pauser (`account`).
579      */
580     event Paused(address account);
581 
582     /**
583      * @dev Emitted when the pause is lifted by a pauser (`account`).
584      */
585     event Unpaused(address account);
586 
587     bool private _paused;
588 
589     /**
590      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
591      * to the deployer.
592      */
593     constructor () internal {
594         _paused = false;
595     }
596 
597     /**
598      * @dev Returns true if the contract is paused, and false otherwise.
599      */
600     function paused() public view returns (bool) {
601         return _paused;
602     }
603 
604     /**
605      * @dev Modifier to make a function callable only when the contract is not paused.
606      */
607     modifier whenNotPaused() {
608         require(!_paused, "Pausable: paused");
609         _;
610     }
611 
612     /**
613      * @dev Modifier to make a function callable only when the contract is paused.
614      */
615     modifier whenPaused() {
616         require(_paused, "Pausable: not paused");
617         _;
618     }
619 
620     /**
621      * @dev Called by a pauser to pause, triggers stopped state.
622      */
623     function pause() public onlyPauser whenNotPaused {
624         _paused = true;
625         emit Paused(_msgSender());
626     }
627 
628     /**
629      * @dev Called by a pauser to unpause, returns to normal state.
630      */
631     function unpause() public onlyPauser whenPaused {
632         _paused = false;
633         emit Unpaused(_msgSender());
634     }
635 }
636 
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
650     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
651         return super.increaseAllowance(spender, addedValue);
652     }
653 
654     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
655         return super.decreaseAllowance(spender, subtractedValue);
656     }
657 }
658 
659 contract ERC20Capped is ERC20Mintable {
660     uint256 private _cap;
661 
662     /**
663      * @dev Sets the value of the `cap`. This value is immutable, it can only be
664      * set once during construction.
665      */
666     constructor (uint256 cap) public {
667         require(cap > 0, "ERC20Capped: cap is 0");
668         _cap = cap;
669     }
670 
671     /**
672      * @dev Returns the cap on the token's total supply.
673      */
674     function cap() public view returns (uint256) {
675         return _cap;
676     }
677 
678     /**
679      * @dev See {ERC20Mintable-mint}.
680      *
681      * Requirements:
682      *
683      * - `value` must not cause the total supply to go over the cap.
684      */
685     function _mint(address account, uint256 value) internal {
686         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
687         super._mint(account, value);
688     }
689 }
690 
691 contract ERC20Detailed is IERC20 {
692     string private _name;
693     string private _symbol;
694     uint8 private _decimals;
695 
696     /**
697      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
698      * these values are immutable: they can only be set once during
699      * construction.
700      */
701     constructor (string memory name, string memory symbol, uint8 decimals) public {
702         _name = name;
703         _symbol = symbol;
704         _decimals = decimals;
705     }
706 
707     /**
708      * @dev Returns the name of the token.
709      */
710     function name() public view returns (string memory) {
711         return _name;
712     }
713 
714     /**
715      * @dev Returns the symbol of the token, usually a shorter version of the
716      * name.
717      */
718     function symbol() public view returns (string memory) {
719         return _symbol;
720     }
721 
722     /**
723      * @dev Returns the number of decimals used to get its user representation.
724      * For example, if `decimals` equals `2`, a balance of `505` tokens should
725      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
726      *
727      * Tokens usually opt for a value of 18, imitating the relationship between
728      * Ether and Wei.
729      *
730      * NOTE: This information is only used for _display_ purposes: it in
731      * no way affects any of the arithmetic of the contract, including
732      * {IERC20-balanceOf} and {IERC20-transfer}.
733      */
734     function decimals() public view returns (uint8) {
735         return _decimals;
736     }
737 }
738 
739 contract Ownable is Context {
740     address private _owner;
741 
742     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
743 
744     /**
745      * @dev Initializes the contract setting the deployer as the initial owner.
746      */
747     constructor () internal {
748         address msgSender = _msgSender();
749         _owner = msgSender;
750         emit OwnershipTransferred(address(0), msgSender);
751     }
752 
753     /**
754      * @dev Returns the address of the current owner.
755      */
756     function owner() public view returns (address) {
757         return _owner;
758     }
759 
760     /**
761      * @dev Throws if called by any account other than the owner.
762      */
763     modifier onlyOwner() {
764         require(isOwner(), "Ownable: caller is not the owner");
765         _;
766     }
767 
768     /**
769      * @dev Returns true if the caller is the current owner.
770      */
771     function isOwner() public view returns (bool) {
772         return _msgSender() == _owner;
773     }
774 
775     /**
776      * @dev Leaves the contract without owner. It will not be possible to call
777      * `onlyOwner` functions anymore. Can only be called by the current owner.
778      *
779      * NOTE: Renouncing ownership will leave the contract without an owner,
780      * thereby removing any functionality that is only available to the owner.
781      */
782     function renounceOwnership() public onlyOwner {
783         emit OwnershipTransferred(_owner, address(0));
784         _owner = address(0);
785     }
786 
787     /**
788      * @dev Transfers ownership of the contract to a new account (`newOwner`).
789      * Can only be called by the current owner.
790      */
791     function transferOwnership(address newOwner) public onlyOwner {
792         _transferOwnership(newOwner);
793     }
794 
795     /**
796      * @dev Transfers ownership of the contract to a new account (`newOwner`).
797      */
798     function _transferOwnership(address newOwner) internal {
799         require(newOwner != address(0), "Ownable: new owner is the zero address");
800         emit OwnershipTransferred(_owner, newOwner);
801         _owner = newOwner;
802     }
803 }
804 
805 contract LeduToken is ERC20, ERC20Detailed, ERC20Pausable, ERC20Burnable, ERC20Mintable, ERC20Capped, Ownable {	
806 	constructor(string memory name, string memory symbol, uint8 decimals, uint256 to_mint, address owner)
807 		ERC20Detailed(name, symbol, decimals)
808 		ERC20Capped(to_mint)
809 		public
810 		{
811 			// We are minting a total of to_mint tokens, and we are capping it at that value
812 			_mint(owner, to_mint);
813 			// New owner has pausing rights
814 			_addPauser(owner);
815 			// Old owner is renouncing minting rights
816 			renounceMinter();
817 			// Old owner is renouncing pausing rights
818 			renouncePauser();
819 			// Transferring ownership to the new owner
820 			_transferOwnership(owner);
821 		}
822 }