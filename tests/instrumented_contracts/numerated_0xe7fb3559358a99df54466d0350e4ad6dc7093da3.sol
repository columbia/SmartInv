1 pragma solidity >=0.4.21 <0.6.0;
2 
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 contract ERC20Detailed is IERC20 {
76     string private _name;
77     string private _symbol;
78     uint8 private _decimals;
79 
80     /**
81      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
82      * these values are immutable: they can only be set once during
83      * construction.
84      */
85     constructor (string memory name, string memory symbol, uint8 decimals) public {
86         _name = name;
87         _symbol = symbol;
88         _decimals = decimals;
89     }
90 
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() public view returns (string memory) {
95         return _name;
96     }
97 
98     /**
99      * @dev Returns the symbol of the token, usually a shorter version of the
100      * name.
101      */
102     function symbol() public view returns (string memory) {
103         return _symbol;
104     }
105 
106     /**
107      * @dev Returns the number of decimals used to get its user representation.
108      * For example, if `decimals` equals `2`, a balance of `505` tokens should
109      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
110      *
111      * Tokens usually opt for a value of 18, imitating the relationship between
112      * Ether and Wei.
113      *
114      * NOTE: This information is only used for _display_ purposes: it in
115      * no way affects any of the arithmetic of the contract, including
116      * {IERC20-balanceOf} and {IERC20-transfer}.
117      */
118     function decimals() public view returns (uint8) {
119         return _decimals;
120     }
121 }
122 
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      * - Subtraction cannot overflow.
161      *
162      * _Available since v2.4.0._
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      *
220      * _Available since v2.4.0._
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         // Solidity only automatically asserts when dividing by 0
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      * - The divisor cannot be zero.
256      *
257      * _Available since v2.4.0._
258      */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b != 0, errorMessage);
261         return a % b;
262     }
263 }
264 
265 contract Context {
266     // Empty internal constructor, to prevent people from mistakenly deploying
267     // an instance of this contract, which should be used via inheritance.
268     constructor () internal { }
269     // solhint-disable-previous-line no-empty-blocks
270 
271     function _msgSender() internal view returns (address payable) {
272         return msg.sender;
273     }
274 
275     function _msgData() internal view returns (bytes memory) {
276         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
277         return msg.data;
278     }
279 }
280 
281 contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286     /**
287      * @dev Initializes the contract setting the deployer as the initial owner.
288      */
289     constructor () internal {
290         address msgSender = _msgSender();
291         _owner = msgSender;
292         emit OwnershipTransferred(address(0), msgSender);
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(isOwner(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Returns true if the caller is the current owner.
312      */
313     function isOwner() public view returns (bool) {
314         return _msgSender() == _owner;
315     }
316 
317     /**
318      * @dev Leaves the contract without owner. It will not be possible to call
319      * `onlyOwner` functions anymore. Can only be called by the current owner.
320      *
321      * NOTE: Renouncing ownership will leave the contract without an owner,
322      * thereby removing any functionality that is only available to the owner.
323      */
324     function renounceOwnership() public onlyOwner {
325         emit OwnershipTransferred(_owner, address(0));
326         _owner = address(0);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Can only be called by the current owner.
332      */
333     function transferOwnership(address newOwner) public onlyOwner {
334         _transferOwnership(newOwner);
335     }
336 
337     /**
338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
339      */
340     function _transferOwnership(address newOwner) internal {
341         require(newOwner != address(0), "Ownable: new owner is the zero address");
342         emit OwnershipTransferred(_owner, newOwner);
343         _owner = newOwner;
344     }
345 }
346 
347 contract ERC20 is Context, IERC20 {
348     using SafeMath for uint256;
349 
350     mapping (address => uint256) private _balances;
351 
352     mapping (address => mapping (address => uint256)) private _allowances;
353 
354     uint256 private _totalSupply;
355 
356     /**
357      * @dev See {IERC20-totalSupply}.
358      */
359     function totalSupply() public view returns (uint256) {
360         return _totalSupply;
361     }
362 
363     /**
364      * @dev See {IERC20-balanceOf}.
365      */
366     function balanceOf(address account) public view returns (uint256) {
367         return _balances[account];
368     }
369 
370     /**
371      * @dev See {IERC20-transfer}.
372      *
373      * Requirements:
374      *
375      * - `recipient` cannot be the zero address.
376      * - the caller must have a balance of at least `amount`.
377      */
378     function transfer(address recipient, uint256 amount) public returns (bool) {
379         _transfer(_msgSender(), recipient, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-allowance}.
385      */
386     function allowance(address owner, address spender) public view returns (uint256) {
387         return _allowances[owner][spender];
388     }
389 
390     /**
391      * @dev See {IERC20-approve}.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function approve(address spender, uint256 amount) public returns (bool) {
398         _approve(_msgSender(), spender, amount);
399         return true;
400     }
401 
402     /**
403      * @dev See {IERC20-transferFrom}.
404      *
405      * Emits an {Approval} event indicating the updated allowance. This is not
406      * required by the EIP. See the note at the beginning of {ERC20};
407      *
408      * Requirements:
409      * - `sender` and `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      * - the caller must have allowance for `sender`'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
415         _transfer(sender, recipient, amount);
416         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
417         return true;
418     }
419 
420     /**
421      * @dev Atomically increases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      */
432     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
433         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
434         return true;
435     }
436 
437     /**
438      * @dev Atomically decreases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      * - `spender` must have allowance for the caller of at least
449      * `subtractedValue`.
450      */
451     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
452         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
453         return true;
454     }
455 
456     /**
457      * @dev Moves tokens `amount` from `sender` to `recipient`.
458      *
459      * This is internal function is equivalent to {transfer}, and can be used to
460      * e.g. implement automatic token fees, slashing mechanisms, etc.
461      *
462      * Emits a {Transfer} event.
463      *
464      * Requirements:
465      *
466      * - `sender` cannot be the zero address.
467      * - `recipient` cannot be the zero address.
468      * - `sender` must have a balance of at least `amount`.
469      */
470     function _transfer(address sender, address recipient, uint256 amount) internal {
471         require(sender != address(0), "ERC20: transfer from the zero address");
472         require(recipient != address(0), "ERC20: transfer to the zero address");
473 
474         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
475         _balances[recipient] = _balances[recipient].add(amount);
476         emit Transfer(sender, recipient, amount);
477     }
478 
479     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
480      * the total supply.
481      *
482      * Emits a {Transfer} event with `from` set to the zero address.
483      *
484      * Requirements
485      *
486      * - `to` cannot be the zero address.
487      */
488     function _mint(address account, uint256 amount) internal {
489         require(account != address(0), "ERC20: mint to the zero address");
490 
491         _totalSupply = _totalSupply.add(amount);
492         _balances[account] = _balances[account].add(amount);
493         emit Transfer(address(0), account, amount);
494     }
495 
496     /**
497      * @dev Destroys `amount` tokens from `account`, reducing the
498      * total supply.
499      *
500      * Emits a {Transfer} event with `to` set to the zero address.
501      *
502      * Requirements
503      *
504      * - `account` cannot be the zero address.
505      * - `account` must have at least `amount` tokens.
506      */
507     function _burn(address account, uint256 amount) internal {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
511         _totalSupply = _totalSupply.sub(amount);
512         emit Transfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
517      *
518      * This is internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(address owner, address spender, uint256 amount) internal {
529         require(owner != address(0), "ERC20: approve from the zero address");
530         require(spender != address(0), "ERC20: approve to the zero address");
531 
532         _allowances[owner][spender] = amount;
533         emit Approval(owner, spender, amount);
534     }
535 
536     /**
537      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
538      * from the caller's allowance.
539      *
540      * See {_burn} and {_approve}.
541      */
542     function _burnFrom(address account, uint256 amount) internal {
543         _burn(account, amount);
544         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
545     }
546 }
547 
548 library Roles {
549     struct Role {
550         mapping (address => bool) bearer;
551     }
552 
553     /**
554      * @dev Give an account access to this role.
555      */
556     function add(Role storage role, address account) internal {
557         require(!has(role, account), "Roles: account already has role");
558         role.bearer[account] = true;
559     }
560 
561     /**
562      * @dev Remove an account's access to this role.
563      */
564     function remove(Role storage role, address account) internal {
565         require(has(role, account), "Roles: account does not have role");
566         role.bearer[account] = false;
567     }
568 
569     /**
570      * @dev Check if an account has this role.
571      * @return bool
572      */
573     function has(Role storage role, address account) internal view returns (bool) {
574         require(account != address(0), "Roles: account is the zero address");
575         return role.bearer[account];
576     }
577 }
578 
579 contract PauserRole is Context {
580     using Roles for Roles.Role;
581 
582     event PauserAdded(address indexed account);
583     event PauserRemoved(address indexed account);
584 
585     Roles.Role private _pausers;
586 
587     constructor () internal {
588         _addPauser(_msgSender());
589     }
590 
591     modifier onlyPauser() {
592         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
593         _;
594     }
595 
596     function isPauser(address account) public view returns (bool) {
597         return _pausers.has(account);
598     }
599 
600     function addPauser(address account) public onlyPauser {
601         _addPauser(account);
602     }
603 
604     function renouncePauser() public {
605         _removePauser(_msgSender());
606     }
607 
608     function _addPauser(address account) internal {
609         _pausers.add(account);
610         emit PauserAdded(account);
611     }
612 
613     function _removePauser(address account) internal {
614         _pausers.remove(account);
615         emit PauserRemoved(account);
616     }
617 }
618 
619 contract Pausable is Context, PauserRole {
620     /**
621      * @dev Emitted when the pause is triggered by a pauser (`account`).
622      */
623     event Paused(address account);
624 
625     /**
626      * @dev Emitted when the pause is lifted by a pauser (`account`).
627      */
628     event Unpaused(address account);
629 
630     bool private _paused;
631 
632     /**
633      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
634      * to the deployer.
635      */
636     constructor () internal {
637         _paused = false;
638     }
639 
640     /**
641      * @dev Returns true if the contract is paused, and false otherwise.
642      */
643     function paused() public view returns (bool) {
644         return _paused;
645     }
646 
647     /**
648      * @dev Modifier to make a function callable only when the contract is not paused.
649      */
650     modifier whenNotPaused() {
651         require(!_paused, "Pausable: paused");
652         _;
653     }
654 
655     /**
656      * @dev Modifier to make a function callable only when the contract is paused.
657      */
658     modifier whenPaused() {
659         require(_paused, "Pausable: not paused");
660         _;
661     }
662 
663     /**
664      * @dev Called by a pauser to pause, triggers stopped state.
665      */
666     function pause() public onlyPauser whenNotPaused {
667         _paused = true;
668         emit Paused(_msgSender());
669     }
670 
671     /**
672      * @dev Called by a pauser to unpause, returns to normal state.
673      */
674     function unpause() public onlyPauser whenPaused {
675         _paused = false;
676         emit Unpaused(_msgSender());
677     }
678 }
679 
680 contract ERC20Pausable is ERC20, Pausable {
681     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
682         return super.transfer(to, value);
683     }
684 
685     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
686         return super.transferFrom(from, to, value);
687     }
688 
689     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
690         return super.approve(spender, value);
691     }
692 
693     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
694         return super.increaseAllowance(spender, addedValue);
695     }
696 
697     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
698         return super.decreaseAllowance(spender, subtractedValue);
699     }
700 }
701 
702 contract MinterRole is Context {
703     using Roles for Roles.Role;
704 
705     event MinterAdded(address indexed account);
706     event MinterRemoved(address indexed account);
707 
708     Roles.Role private _minters;
709 
710     constructor () internal {
711         _addMinter(_msgSender());
712     }
713 
714     modifier onlyMinter() {
715         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
716         _;
717     }
718 
719     function isMinter(address account) public view returns (bool) {
720         return _minters.has(account);
721     }
722 
723     function addMinter(address account) public onlyMinter {
724         _addMinter(account);
725     }
726 
727     function renounceMinter() public {
728         _removeMinter(_msgSender());
729     }
730 
731     function _addMinter(address account) internal {
732         _minters.add(account);
733         emit MinterAdded(account);
734     }
735 
736     function _removeMinter(address account) internal {
737         _minters.remove(account);
738         emit MinterRemoved(account);
739     }
740 }
741 
742 contract ERC20Mintable is ERC20, MinterRole {
743     /**
744      * @dev See {ERC20-_mint}.
745      *
746      * Requirements:
747      *
748      * - the caller must have the {MinterRole}.
749      */
750     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
751         _mint(account, amount);
752         return true;
753     }
754 }
755 
756 contract ERC20Burnable is Context, ERC20 {
757     /**
758      * @dev Destroys `amount` tokens from the caller.
759      *
760      * See {ERC20-_burn}.
761      */
762     function burn(uint256 amount) public {
763         _burn(_msgSender(), amount);
764     }
765 
766     /**
767      * @dev See {ERC20-_burnFrom}.
768      */
769     function burnFrom(address account, uint256 amount) public {
770         _burnFrom(account, amount);
771     }
772 }
773 
774 contract BlacklistAdminRole is Context {
775     using Roles for Roles.Role;
776 
777     event BlacklistAdminAdded(address indexed account);
778     event BlacklistAdminRemoved(address indexed account);
779 
780     Roles.Role private _BlacklistAdmins;
781 
782     constructor () internal {
783         _addBlacklistAdmin(_msgSender());
784     }
785 
786     modifier onlyBlacklistAdmin() {
787         require(isBlacklistAdmin(_msgSender()), "BlacklistAdminRole: caller does not have the BlacklistAdmin role");
788         _;
789     }
790 
791     function isBlacklistAdmin(address account) public view returns (bool) {
792         return _BlacklistAdmins.has(account);
793     }
794 
795     function addBlacklistAdmin(address account) public onlyBlacklistAdmin {
796         _addBlacklistAdmin(account);
797     }
798 
799     function renounceBlacklistAdmin() public {
800         _removeBlacklistAdmin(_msgSender());
801     }
802 
803     function _addBlacklistAdmin(address account) internal {
804         _BlacklistAdmins.add(account);
805         emit BlacklistAdminAdded(account);
806     }
807 
808     function _removeBlacklistAdmin(address account) internal {
809         _BlacklistAdmins.remove(account);
810         emit BlacklistAdminRemoved(account);
811     }
812 }
813 
814 contract BlacklistedRole is Context, BlacklistAdminRole {
815     using Roles for Roles.Role;
816 
817     event BlacklistedAdded(address indexed account);
818     event BlacklistedRemoved(address indexed account);
819 
820     Roles.Role private _Blacklisteds;
821 
822     modifier whenNotBlacklisted() {
823         require(isBlacklisted(_msgSender()) == false, "BlacklistedRole: caller does not have the Blacklisted role");
824         _;
825     }
826 
827     function isBlacklisted(address account) public view returns (bool) {
828         return _Blacklisteds.has(account);
829     }
830 
831     function addBlacklisted(address account) public onlyBlacklistAdmin {
832         _addBlacklisted(account);
833     }
834 
835     function removeBlacklisted(address account) public onlyBlacklistAdmin {
836         _removeBlacklisted(account);
837     }
838 
839     function _addBlacklisted(address account) internal {
840         _Blacklisteds.add(account);
841         emit BlacklistedAdded(account);
842     }
843 
844     function _removeBlacklisted(address account) internal {
845         _Blacklisteds.remove(account);
846         emit BlacklistedRemoved(account);
847     }
848 }
849 
850 contract DelegatableAdminRole is Context {
851     using Roles for Roles.Role;
852 
853     event DelegatableAdminAdded(address indexed account);
854     event DelegatableAdminRemoved(address indexed account);
855 
856     Roles.Role private _DelegatableAdmins;
857 
858     constructor () internal {
859         _addDelegatableAdmin(_msgSender());
860     }
861 
862     modifier onlyDelegatableAdmin() {
863         require(isDelegatableAdmin(_msgSender()), "DelegatableAdminRole: caller does not have the DelegatableAdmin role");
864         _;
865     }
866 
867     function isDelegatableAdmin(address account) public view returns (bool) {
868         return _DelegatableAdmins.has(account);
869     }
870 
871     function addDelegatableAdmin(address account) public onlyDelegatableAdmin {
872         _addDelegatableAdmin(account);
873     }
874 
875     function renounceDelegatableAdmin() public {
876         _removeDelegatableAdmin(_msgSender());
877     }
878 
879     function _addDelegatableAdmin(address account) internal {
880         _DelegatableAdmins.add(account);
881         emit DelegatableAdminAdded(account);
882     }
883 
884     function _removeDelegatableAdmin(address account) internal {
885         _DelegatableAdmins.remove(account);
886         emit DelegatableAdminRemoved(account);
887     }
888 }
889 
890 contract DelegatableRole is Context, DelegatableAdminRole {
891     using Roles for Roles.Role;
892 
893     event DelegatableAdded(address indexed account);
894     event DelegatableRemoved(address indexed account);
895 
896     Roles.Role private _Delegatables;
897 
898     modifier whenDelegatable() {
899         require(isDelegatable(_msgSender()), "DelegatableRole: caller does not have the Delegatable role");
900         _;
901     }
902 
903     function isDelegatable(address account) public view returns (bool) {
904         return _Delegatables.has(account);
905     }
906 
907     function addDelegatable(address account) public onlyDelegatableAdmin {
908         _addDelegatable(account);
909     }
910 
911     function removeDelegatable(address account) public onlyDelegatableAdmin {
912         _removeDelegatable(account);
913     }
914 
915     function _addDelegatable(address account) internal {
916         _Delegatables.add(account);
917         emit DelegatableAdded(account);
918     }
919 
920     function _removeDelegatable(address account) internal {
921         _Delegatables.remove(account);
922         emit DelegatableRemoved(account);
923     }
924 }
925 
926 contract ERC1132 {
927     /**
928      * @dev Reasons why a user's tokens have been locked
929      */
930     mapping(address => bytes32[]) public lockReason;
931 
932     /**
933      * @dev locked token structure
934      */
935     struct lockToken {
936         uint256 amount;
937         uint256 validity;
938         bool claimed;
939     }
940 
941     /**
942      * @dev Holds number & validity of tokens locked for a given reason for
943      *      a specified address
944      */
945     mapping(address => mapping(bytes32 => lockToken)) public locked;
946 
947     /**
948      * @dev Records data of all the tokens Locked
949      */
950     event Locked(
951         address indexed _of,
952         bytes32 indexed _reason,
953         uint256 _amount,
954         uint256 _validity
955     );
956 
957     /**
958      * @dev Records data of all the tokens unlocked
959      */
960     event Unlocked(
961         address indexed _of,
962         bytes32 indexed _reason,
963         uint256 _amount
964     );
965     
966     /**
967      * @dev Locks a specified amount of tokens against an address,
968      *      for a specified reason and time
969      * @param _reason The reason to lock tokens
970      * @param _amount Number of tokens to be locked
971      * @param _time Lock time in seconds
972      */
973     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
974         public returns (bool);
975   
976     /**
977      * @dev Returns tokens locked for a specified address for a
978      *      specified reason
979      *
980      * @param _of The address whose tokens are locked
981      * @param _reason The reason to query the lock tokens for
982      */
983     function tokensLocked(address _of, bytes32 _reason)
984         public view returns (uint256 amount);
985     
986     /**
987      * @dev Returns tokens locked for a specified address for a
988      *      specified reason at a specific time
989      *
990      * @param _of The address whose tokens are locked
991      * @param _reason The reason to query the lock tokens for
992      * @param _time The timestamp to query the lock tokens for
993      */
994     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
995         public view returns (uint256 amount);
996     
997     /**
998      * @dev Returns total tokens held by an address (locked + transferable)
999      * @param _of The address to query the total balance of
1000      */
1001     function totalBalanceOf(address _of)
1002         public view returns (uint256 amount);
1003     
1004     /**
1005      * @dev Extends lock for a specified reason and time
1006      * @param _reason The reason to lock tokens
1007      * @param _time Lock extension time in seconds
1008      */
1009     function extendLock(bytes32 _reason, uint256 _time)
1010         public returns (bool);
1011     
1012     /**
1013      * @dev Increase number of tokens locked for a specified reason
1014      * @param _reason The reason to lock tokens
1015      * @param _amount Number of tokens to be increased
1016      */
1017     function increaseLockAmount(bytes32 _reason, uint256 _amount)
1018         public returns (bool);
1019 
1020     /**
1021      * @dev Returns unlockable tokens for a specified address for a specified reason
1022      * @param _of The address to query the the unlockable token count of
1023      * @param _reason The reason to query the unlockable tokens for
1024      */
1025     function tokensUnlockable(address _of, bytes32 _reason)
1026         public view returns (uint256 amount);
1027  
1028     /**
1029      * @dev Unlocks the unlockable tokens of a specified address
1030      * @param _of Address of user, claiming back unlockable tokens
1031      */
1032     function unlock(address _of)
1033         public returns (uint256 unlockableTokens);
1034 
1035     /**
1036      * @dev Gets the unlockable tokens of a specified address
1037      * @param _of The address to query the the unlockable token count of
1038      */
1039     function getUnlockableTokens(address _of)
1040         public view returns (uint256 unlockableTokens);
1041 
1042 }
1043 
1044 contract LockableToken is ERC1132, ERC20 {
1045 
1046    /**
1047     * @dev Error messages for require statements
1048     */
1049     string internal constant ALREADY_LOCKED = 'Tokens already locked';
1050     string internal constant NOT_LOCKED = 'No tokens locked';
1051     string internal constant AMOUNT_ZERO = 'Amount can not be 0';
1052 
1053     /**
1054      * @dev Locks a specified amount of tokens against an address,
1055      *      for a specified reason and time
1056      * @param _reason The reason to lock tokens
1057      * @param _amount Number of tokens to be locked
1058      * @param _time Lock time in seconds
1059      */
1060     function lock(bytes32 _reason, uint256 _amount, uint256 _time)
1061         public
1062         returns (bool)
1063     {
1064         uint256 validUntil = now.add(_time); //solhint-disable-line
1065 
1066         // If tokens are already locked, then functions extendLock or
1067         // increaseLockAmount should be used to make any changes
1068         require(tokensLocked(msg.sender, _reason) == 0, ALREADY_LOCKED);
1069         require(_amount != 0, AMOUNT_ZERO);
1070 
1071         if (locked[msg.sender][_reason].amount == 0)
1072             lockReason[msg.sender].push(_reason);
1073 
1074         transfer(address(this), _amount);
1075 
1076         locked[msg.sender][_reason] = lockToken(_amount, validUntil, false);
1077 
1078         emit Locked(msg.sender, _reason, _amount, validUntil);
1079         return true;
1080     }
1081     
1082     /**
1083      * @dev Transfers and Locks a specified amount of tokens,
1084      *      for a specified reason and time
1085      * @param _to adress to which tokens are to be transfered
1086      * @param _reason The reason to lock tokens
1087      * @param _amount Number of tokens to be transfered and locked
1088      * @param _time Lock time in seconds
1089      */
1090     function transferWithLock(address _to, bytes32 _reason, uint256 _amount, uint256 _time)
1091         public
1092         returns (bool)
1093     {
1094         uint256 validUntil = now.add(_time); //solhint-disable-line
1095 
1096         require(tokensLocked(_to, _reason) == 0, ALREADY_LOCKED);
1097         require(_amount != 0, AMOUNT_ZERO);
1098 
1099         if (locked[_to][_reason].amount == 0)
1100             lockReason[_to].push(_reason);
1101 
1102         transfer(address(this), _amount);
1103 
1104         locked[_to][_reason] = lockToken(_amount, validUntil, false);
1105         
1106         emit Locked(_to, _reason, _amount, validUntil);
1107         return true;
1108     }
1109 
1110     /**
1111      * @dev Returns tokens locked for a specified address for a
1112      *      specified reason
1113      *
1114      * @param _of The address whose tokens are locked
1115      * @param _reason The reason to query the lock tokens for
1116      */
1117     function tokensLocked(address _of, bytes32 _reason)
1118         public
1119         view
1120         returns (uint256 amount)
1121     {
1122         if (!locked[_of][_reason].claimed)
1123             amount = locked[_of][_reason].amount;
1124     }
1125     
1126     /**
1127      * @dev Returns tokens locked for a specified address for a
1128      *      specified reason at a specific time
1129      *
1130      * @param _of The address whose tokens are locked
1131      * @param _reason The reason to query the lock tokens for
1132      * @param _time The timestamp to query the lock tokens for
1133      */
1134     function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)
1135         public
1136         view
1137         returns (uint256 amount)
1138     {
1139         if (locked[_of][_reason].validity > _time)
1140             amount = locked[_of][_reason].amount;
1141     }
1142 
1143     /**
1144      * @dev Returns total tokens held by an address (locked + transferable)
1145      * @param _of The address to query the total balance of
1146      */
1147     function totalBalanceOf(address _of)
1148         public
1149         view
1150         returns (uint256 amount)
1151     {
1152         amount = balanceOf(_of);
1153 
1154         for (uint256 i = 0; i < lockReason[_of].length; i++) {
1155             amount = amount.add(tokensLocked(_of, lockReason[_of][i]));
1156         }   
1157     }    
1158     
1159     /**
1160      * @dev Extends lock for a specified reason and time
1161      * @param _reason The reason to lock tokens
1162      * @param _time Lock extension time in seconds
1163      */
1164     function extendLock(bytes32 _reason, uint256 _time)
1165         public
1166         returns (bool)
1167     {
1168         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
1169 
1170         locked[msg.sender][_reason].validity = locked[msg.sender][_reason].validity.add(_time);
1171 
1172         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
1173         return true;
1174     }
1175     
1176     /**
1177      * @dev Increase number of tokens locked for a specified reason
1178      * @param _reason The reason to lock tokens
1179      * @param _amount Number of tokens to be increased
1180      */
1181     function increaseLockAmount(bytes32 _reason, uint256 _amount)
1182         public
1183         returns (bool)
1184     {
1185         require(tokensLocked(msg.sender, _reason) > 0, NOT_LOCKED);
1186         transfer(address(this), _amount);
1187 
1188         locked[msg.sender][_reason].amount = locked[msg.sender][_reason].amount.add(_amount);
1189 
1190         emit Locked(msg.sender, _reason, locked[msg.sender][_reason].amount, locked[msg.sender][_reason].validity);
1191         return true;
1192     }
1193 
1194     /**
1195      * @dev Returns unlockable tokens for a specified address for a specified reason
1196      * @param _of The address to query the the unlockable token count of
1197      * @param _reason The reason to query the unlockable tokens for
1198      */
1199     function tokensUnlockable(address _of, bytes32 _reason)
1200         public
1201         view
1202         returns (uint256 amount)
1203     {
1204         if (locked[_of][_reason].validity <= now && !locked[_of][_reason].claimed) //solhint-disable-line
1205             amount = locked[_of][_reason].amount;
1206     }
1207 
1208     /**
1209      * @dev Unlocks the unlockable tokens of a specified address
1210      * @param _of Address of user, claiming back unlockable tokens
1211      */
1212     function unlock(address _of)
1213         public
1214         returns (uint256 unlockableTokens)
1215     {
1216         uint256 lockedTokens;
1217 
1218         for (uint256 i = 0; i < lockReason[_of].length; i++) {
1219             lockedTokens = tokensUnlockable(_of, lockReason[_of][i]);
1220             if (lockedTokens > 0) {
1221                 unlockableTokens = unlockableTokens.add(lockedTokens);
1222                 locked[_of][lockReason[_of][i]].claimed = true;
1223                 emit Unlocked(_of, lockReason[_of][i], lockedTokens);
1224             }
1225         }  
1226 
1227         if (unlockableTokens > 0)
1228             this.transfer(_of, unlockableTokens);
1229     }
1230 
1231     /**
1232      * @dev Gets the unlockable tokens of a specified address
1233      * @param _of The address to query the the unlockable token count of
1234      */
1235     function getUnlockableTokens(address _of)
1236         public
1237         view
1238         returns (uint256 unlockableTokens)
1239     {
1240         for (uint256 i = 0; i < lockReason[_of].length; i++) {
1241             unlockableTokens = unlockableTokens.add(tokensUnlockable(_of, lockReason[_of][i]));
1242         }  
1243     }
1244 }
1245 
1246 contract AID is LockableToken,ERC20Detailed,Ownable,ERC20Mintable,ERC20Burnable,ERC20Pausable,BlacklistedRole{
1247 
1248     using SafeMath for uint256;
1249 
1250     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply)
1251     ERC20Detailed(name, symbol, decimals)
1252     public {
1253         _mint(owner(), totalSupply * 10**uint(decimals));
1254     }
1255 
1256     function transfer(address to, uint256 value) public whenNotPaused whenNotBlacklisted returns (bool) {
1257         return super.transfer(to, value);
1258     }
1259 
1260     function transferFrom(address from, address to, uint256 value) public whenNotPaused whenNotBlacklisted returns (bool) {
1261         return super.transferFrom(from, to, value);
1262     }
1263 
1264     function approve(address spender, uint256 value) public whenNotPaused whenNotBlacklisted returns (bool) {
1265         return super.approve(spender, value);
1266     }
1267 
1268     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused whenNotBlacklisted returns (bool) {
1269         return super.increaseAllowance(spender, addedValue);
1270     }
1271 
1272     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused whenNotBlacklisted returns (bool) {
1273         return super.decreaseAllowance(spender, subtractedValue);
1274     }
1275 }