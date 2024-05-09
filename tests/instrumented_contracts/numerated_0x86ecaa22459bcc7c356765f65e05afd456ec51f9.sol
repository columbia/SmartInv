1 /** New PazCoin Contract
2 * 최대 발행량 : 50억개
3 * Maximum token issuance: 5 billion
4 **/
5 pragma solidity 0.5.0;
6 
7 library Roles {
8     struct Role {
9         mapping (address => bool) bearer;
10     }
11 
12     /**
13      * @dev Give an account access to this role.
14      */
15     function add(Role storage role, address account) internal {
16         require(!has(role, account), "Roles: account already has role");
17         role.bearer[account] = true;
18     }
19 
20     /**
21      * @dev Remove an account's access to this role.
22      */
23     function remove(Role storage role, address account) internal {
24         require(has(role, account), "Roles: account does not have role");
25         role.bearer[account] = false;
26     }
27 
28     /**
29      * @dev Check if an account has this role.
30      * @return bool
31      */
32     function has(Role storage role, address account) internal view returns (bool) {
33         require(account != address(0), "Roles: account is the zero address");
34         return role.bearer[account];
35     }
36 }
37 
38 library SafeMath {
39     /**
40      * @dev Returns the addition of two unsigned integers, reverting on
41      * overflow.
42      *
43      * Counterpart to Solidity's `+` operator.
44      *
45      * Requirements:
46      * - Addition cannot overflow.
47      */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         return sub(a, b, "SafeMath: subtraction overflow");
66     }
67 
68     /**
69      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
70      * overflow (when the result is negative).
71      *
72      * Counterpart to Solidity's `-` operator.
73      *
74      * Requirements:
75      * - Subtraction cannot overflow.
76      *
77      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
78      * @dev Get it via `npm install @openzeppelin/contracts@next`.
79      */
80     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the multiplication of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `*` operator.
92      *
93      * Requirements:
94      * - Multiplication cannot overflow.
95      */
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         return div(a, b, "SafeMath: division by zero");
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135 
136      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
137      * @dev Get it via `npm install @openzeppelin/contracts@next`.
138      */
139     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         // Solidity only automatically asserts when dividing by 0
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return mod(a, b, "SafeMath: modulo by zero");
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts with custom message when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      *
174      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
175      * @dev Get it via `npm install @openzeppelin/contracts@next`.
176      */
177     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b != 0, errorMessage);
179         return a % b;
180     }
181 }
182 
183 contract Context {
184     // Empty internal constructor, to prevent people from mistakenly deploying
185     // an instance of this contract, which should be used via inheritance.
186     constructor () internal { }
187     // solhint-disable-previous-line no-empty-blocks
188 
189     function _msgSender() internal view returns (address payable) {
190         return msg.sender;
191     }
192 
193     function _msgData() internal view returns (bytes memory) {
194         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
195         return msg.data;
196     }
197 }
198 
199 interface IERC20 {
200     /**
201      * @dev Returns the amount of tokens in existence.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through {transferFrom}. This is
222      * zero by default.
223      *
224      * This value changes when {approve} or {transferFrom} are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270 contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor () internal {
279         address msgSender = _msgSender();
280         _owner = msgSender;
281         emit OwnershipTransferred(address(0), msgSender);
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(isOwner(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Returns true if the caller is the current owner.
301      */
302     function isOwner() public view returns (bool) {
303         return _msgSender() == _owner;
304     }
305 
306     /**
307      * @dev Leaves the contract without owner. It will not be possible to call
308      * `onlyOwner` functions anymore. Can only be called by the current owner.
309      *
310      * NOTE: Renouncing ownership will leave the contract without an owner,
311      * thereby removing any functionality that is only available to the owner.
312      */
313     function renounceOwnership() public onlyOwner {
314         emit OwnershipTransferred(_owner, address(0));
315         _owner = address(0);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322 
323     
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      */
327     function _transferOwnership(address newOwner) internal {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         emit OwnershipTransferred(_owner, newOwner);
330         _owner = newOwner;
331     }
332 }
333 
334 contract MinterRole is Context {
335     using Roles for Roles.Role;
336 
337     event MinterAdded(address indexed account);
338     event MinterRemoved(address indexed account);
339 
340     Roles.Role private _minters;
341 
342     constructor () internal {
343         _addMinter(_msgSender());
344     }
345 
346     modifier onlyMinter() {
347         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
348         _;
349     }
350 
351     function isMinter(address account) public view returns (bool) {
352         return _minters.has(account);
353     }
354 
355     function addMinter(address account) public onlyMinter {
356         _addMinter(account);
357     }
358 
359     function renounceMinter() public {
360         _removeMinter(_msgSender());
361     }
362 
363     function _addMinter(address account) internal {
364         _minters.add(account);
365         emit MinterAdded(account);
366     }
367 
368     function _removeMinter(address account) internal {
369         _minters.remove(account);
370         emit MinterRemoved(account);
371     }
372 }
373 
374 contract PauserRole is Context {
375     using Roles for Roles.Role;
376 
377     event PauserAdded(address indexed account);
378     event PauserRemoved(address indexed account);
379 
380     Roles.Role private _pausers;
381 
382     constructor () internal {
383         _addPauser(_msgSender());
384     }
385 
386     modifier onlyPauser() {
387         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
388         _;
389     }
390 
391     function isPauser(address account) public view returns (bool) {
392         return _pausers.has(account);
393     }
394 
395     function addPauser(address account) public onlyPauser {
396         _addPauser(account);
397     }
398 
399     function renouncePauser() public {
400         _removePauser(_msgSender());
401     }
402 
403     function _addPauser(address account) internal {
404         _pausers.add(account);
405         emit PauserAdded(account);
406     }
407 
408     function _removePauser(address account) internal {
409         _pausers.remove(account);
410         emit PauserRemoved(account);
411     }
412 }
413 
414 contract ERC20 is Context, IERC20, Ownable {
415     using SafeMath for uint256;
416 
417     mapping (address => uint256) private _balances;
418 
419     mapping (address => mapping (address => uint256)) private _allowances;
420 
421     uint256 private _totalSupply;
422 
423     /**
424      * @dev See {IERC20-totalSupply}.
425      */
426     function totalSupply() public view returns (uint256) {
427         return _totalSupply;
428     }
429 
430     /**
431      * @dev See {IERC20-balanceOf}.
432      */
433     function balanceOf(address account) public view returns (uint256) {
434         return _balances[account];
435     }
436 
437     /**
438      * @dev See {IERC20-transfer}.
439      *
440      * Requirements:
441      *
442      * - `recipient` cannot be the zero address.
443      * - the caller must have a balance of at least `amount`.
444      */
445     function transfer(address recipient, uint256 amount) public returns (bool) {
446         _transfer(_msgSender(), recipient, amount);
447         return true;
448     }
449 
450     /**
451      * @dev See {IERC20-allowance}.
452      */
453     function allowance(address owner, address spender) public view returns (uint256) {
454         return _allowances[owner][spender];
455     }
456 
457     /**
458      * @dev See {IERC20-approve}.
459      *
460      * Requirements:
461      *
462      * - `spender` cannot be the zero address.
463      */
464     function approve(address spender, uint256 amount) public returns (bool) {
465         _approve(_msgSender(), spender, amount);
466         return true;
467     }
468 
469     /**
470      * @dev See {IERC20-transferFrom}.
471      *
472      * Emits an {Approval} event indicating the updated allowance. This is not
473      * required by the EIP. See the note at the beginning of {ERC20};
474      *
475      * Requirements:
476      * - `sender` and `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      * - the caller must have allowance for `sender`'s tokens of at least
479      * `amount`.
480      */
481     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
482         _transfer(sender, recipient, amount);
483         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically increases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      */
499     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
501         return true;
502     }
503 
504     /**
505      * @dev Atomically decreases the allowance granted to `spender` by the caller.
506      *
507      * This is an alternative to {approve} that can be used as a mitigation for
508      * problems described in {IERC20-approve}.
509      *
510      * Emits an {Approval} event indicating the updated allowance.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      * - `spender` must have allowance for the caller of at least
516      * `subtractedValue`.
517      */
518     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
519         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
520         return true;
521     }
522 
523     /**
524      * @dev Moves tokens `amount` from `sender` to `recipient`.
525      *
526      * This is internal function is equivalent to {transfer}, and can be used to
527      * e.g. implement automatic token fees, slashing mechanisms, etc.
528      *
529      * Emits a {Transfer} event.
530      *
531      * Requirements:
532      *
533      * - `sender` cannot be the zero address.
534      * - `recipient` cannot be the zero address.
535      * - `sender` must have a balance of at least `amount`.
536      */
537     function _transfer(address sender, address recipient, uint256 amount) internal {
538         require(sender != address(0), "ERC20: transfer from the zero address");
539         require(recipient != address(0), "ERC20: transfer to the zero address");
540 
541         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
542         _balances[recipient] = _balances[recipient].add(amount);
543         emit Transfer(sender, recipient, amount);
544     }
545 
546     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
547      * the total supply.
548      *
549      * Emits a {Transfer} event with `from` set to the zero address.
550      *
551      * Requirements
552      *
553      * - `to` cannot be the zero address.
554      */
555     function _mint(address account, uint256 amount) internal {
556         require(account != address(0), "ERC20: mint to the zero address");
557 
558         _totalSupply = _totalSupply.add(amount);
559         _balances[account] = _balances[account].add(amount);
560         emit Transfer(address(0), account, amount);
561     }
562 
563     /**
564      * @dev Destroys `amount` tokens from `account`, reducing the
565      * total supply.
566      *
567      * Emits a {Transfer} event with `to` set to the zero address.
568      *
569      * Requirements
570      *
571      * - `account` cannot be the zero address.
572      * - `account` must have at least `amount` tokens.
573      */
574     function _burn(address account, uint256 amount) internal {
575         require(account != address(0), "ERC20: burn from the zero address");
576 
577         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
578         _totalSupply = _totalSupply.sub(amount);
579         emit Transfer(account, address(0), amount);
580     }
581 
582     /**
583      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
584      *
585      * This is internal function is equivalent to `approve`, and can be used to
586      * e.g. set automatic allowances for certain subsystems, etc.
587      *
588      * Emits an {Approval} event.
589      *
590      * Requirements:
591      *
592      * - `owner` cannot be the zero address.
593      * - `spender` cannot be the zero address.
594      */
595     function _approve(address owner, address spender, uint256 amount) internal {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     /**
604      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
605      * from the caller's allowance.
606      *
607      * See {_burn} and {_approve}.
608      */
609     function _burnFrom(address account, uint256 amount) internal {
610         _burn(account, amount);
611         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
612     }
613 }
614 
615 contract ERC20Detailed is IERC20 {
616     string private _name;
617     string private _symbol;
618     uint8 private _decimals;
619 
620     /**
621      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
622      * these values are immutable: they can only be set once during
623      * construction.
624      */
625     constructor (string memory name, string memory symbol, uint8 decimals) public {
626         _name = name;
627         _symbol = symbol;
628         _decimals = decimals;
629     }
630 
631     /**
632      * @dev Returns the name of the token.
633      */
634     function name() public view returns (string memory) {
635         return _name;
636     }
637 
638     /**
639      * @dev Returns the symbol of the token, usually a shorter version of the
640      * name.
641      */
642     function symbol() public view returns (string memory) {
643         return _symbol;
644     }
645 
646     /**
647      * @dev Returns the number of decimals used to get its user representation.
648      * For example, if `decimals` equals `2`, a balance of `505` tokens should
649      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
650      *
651      * Tokens usually opt for a value of 18, imitating the relationship between
652      * Ether and Wei.
653      *
654      * NOTE: This information is only used for _display_ purposes: it in
655      * no way affects any of the arithmetic of the contract, including
656      * {IERC20-balanceOf} and {IERC20-transfer}.
657      */
658     function decimals() public view returns (uint8) {
659         return _decimals;
660     }
661 }
662 
663 contract ERC20Burnable is Context, ERC20 {
664     /**
665      * @dev Destroys `amount` tokens from the caller.
666      *
667      * See {ERC20-_burn}.
668      */
669     function burn(uint256 amount) public {
670         _burn(_msgSender(), amount);
671     }
672 
673     /**
674      * @dev See {ERC20-_burnFrom}.
675      */
676     function burnFrom(address account, uint256 amount) public {
677         _burnFrom(account, amount);
678     }
679 }
680 
681 contract Pausable is Context, PauserRole {
682     /**
683      * @dev Emitted when the pause is triggered by a pauser (`account`).
684      */
685     event Paused(address account);
686 
687     /**
688      * @dev Emitted when the pause is lifted by a pauser (`account`).
689      */
690     event Unpaused(address account);
691 
692     bool private _paused;
693 
694     /**
695      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
696      * to the deployer.
697      */
698     constructor () internal {
699         _paused = false;
700     }
701 
702     /**
703      * @dev Returns true if the contract is paused, and false otherwise.
704      */
705     function paused() public view returns (bool) {
706         return _paused;
707     }
708 
709     /**
710      * @dev Modifier to make a function callable only when the contract is not paused.
711      */
712     modifier whenNotPaused() {
713         require(!_paused, "Pausable: paused");
714         _;
715     }
716 
717     /**
718      * @dev Modifier to make a function callable only when the contract is paused.
719      */
720     modifier whenPaused() {
721         require(_paused, "Pausable: not paused");
722         _;
723     }
724 
725     /**
726      * @dev Called by a pauser to pause, triggers stopped state.
727      */
728     function pause() public onlyPauser whenNotPaused {
729         _paused = true;
730         emit Paused(_msgSender());
731     }
732 
733     /**
734      * @dev Called by a pauser to unpause, returns to normal state.
735      */
736     function unpause() public onlyPauser whenPaused {
737         _paused = false;
738         emit Unpaused(_msgSender());
739     }
740 }
741 
742 contract ERC20Frozen is ERC20 {
743     mapping (address => bool) private frozenAccounts;
744     event FrozenFunds(address target, bool frozen);
745 
746     function freezeAccount(address target) public onlyOwner {
747         frozenAccounts[target] = true;
748         emit FrozenFunds(target, true);
749     }   
750 
751     function unFreezeAccount(address target) public onlyOwner {
752         frozenAccounts[target] = false;
753         emit FrozenFunds(target, false);
754     }   
755 
756     function frozen(address _target) view public returns (bool){
757         return frozenAccounts[_target];
758     }   
759 
760     modifier canTransfer(address _sender) {
761         require(!frozenAccounts[_sender]);
762         _;  
763     }   
764 
765     function transfer(address _to, uint256 _value) public canTransfer(msg.sender) returns (bool success) {
766         return super.transfer(_to, _value);
767     }   
768 
769     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from) returns (bool success) {
770         return super.transferFrom(_from, _to, _value);
771     }   
772 }
773 
774 
775 
776 contract ERC20Pausable is ERC20, Pausable {
777     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
778         return super.transfer(to, value);
779     }
780 
781     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
782         return super.transferFrom(from, to, value);
783     }
784 
785     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
786         return super.approve(spender, value);
787     }
788 
789     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
790         return super.increaseAllowance(spender, addedValue);
791     }
792 
793     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
794         return super.decreaseAllowance(spender, subtractedValue);
795     }
796 }
797 
798 contract ERC20Mintable is ERC20, MinterRole {
799     /**
800      * @dev See {ERC20-_mint}.
801      *
802      * Requirements:
803      *
804      * - the caller must have the {MinterRole}.
805      */
806     uint256 private _maxSupply = 5000000000000000000000000001;
807     uint256 private _totalSupply;
808     function maxSupply() public view returns (uint256) {
809     return _maxSupply;
810     }
811      
812     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
813     require(_maxSupply > totalSupply().add(amount));    
814         _mint(account, amount);
815         return true;
816     }
817 }
818 
819 /**
820  * @title ERC20 Standard Token
821  */
822 contract ERC20Token is Context, Ownable, ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable, ERC20Frozen, ERC20Pausable  {
823     
824     /**
825      * @dev Constructor that gives _msgSender() all of existing tokens.
826      */
827     constructor (string memory name, string memory symbol, uint8 decimals) 
828         public 
829         ERC20Detailed(name, symbol, decimals) {
830         _mint(_msgSender(), 0);
831     }
832 }