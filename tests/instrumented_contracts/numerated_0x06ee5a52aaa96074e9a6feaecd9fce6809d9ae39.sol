1 pragma solidity >=0.4.22 <0.6.0;
2 
3 
4 contract Context {
5     // Empty internal constructor, to prevent people from mistakenly deploying
6     // an instance of this contract, which should be used via inheritance.
7     constructor () internal { }
8     // solhint-disable-previous-line no-empty-blocks
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 
21 contract Ownable {
22     address private _owner;
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24     constructor () internal {
25         _owner = msg.sender;
26         emit OwnershipTransferred(address(0), _owner);
27     }
28     function owner() public view returns (address) {
29         return _owner;
30     }
31     
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36     
37     function isOwner() public view returns (bool) {
38         return msg.sender == _owner;
39     }
40     
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipTransferred(_owner, address(0));
43         _owner = address(0);
44     }
45     
46     function transferOwnership(address newOwner) public onlyOwner {
47         _transferOwnership(newOwner);
48     }
49    
50     function _transferOwnership(address newOwner) internal {
51         require(newOwner != address(0));
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55 }
56 
57 
58 /**
59  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
60  * the optional functions; to access them see {ERC20Detailed}.
61  */
62 interface IERC20 {
63     /**
64      * @dev Returns the amount of tokens in existence.
65      */
66     function totalSupply() external view returns (uint256);
67 
68     /**
69      * @dev Returns the amount of tokens owned by `account`.
70      */
71     function balanceOf(address account) external view returns (uint256);
72 
73     /**
74      * @dev Moves `amount` tokens from the caller's account to `recipient`.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transfer(address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Returns the remaining number of tokens that `spender` will be
84      * allowed to spend on behalf of `owner` through {transferFrom}. This is
85      * zero by default.
86      *
87      * This value changes when {approve} or {transferFrom} are called.
88      */
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     /**
92      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * IMPORTANT: Beware that changing an allowance with this method brings the risk
97      * that someone may use both the old and the new allowance by unfortunate
98      * transaction ordering. One possible solution to mitigate this race
99      * condition is to first reduce the spender's allowance to 0 and set the
100      * desired value afterwards:
101      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Moves `amount` tokens from `sender` to `recipient` using the
109      * allowance mechanism. `amount` is then deducted from the caller's
110      * allowance.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Emitted when `value` tokens are moved from one account (`from`) to
120      * another (`to`).
121      *
122      * Note that `value` may be zero.
123      */
124     event Transfer(address indexed from, address indexed to, uint256 value);
125 
126     /**
127      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
128      * a call to {approve}. `value` is the new allowance.
129      */
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 
134 /**
135  * @dev Wrappers over Solidity's arithmetic operations with added overflow
136  * checks.
137  *
138  * Arithmetic operations in Solidity wrap on overflow. This can easily result
139  * in bugs, because programmers usually assume that an overflow raises an
140  * error, which is the standard behavior in high level programming languages.
141  * `SafeMath` restores this intuition by reverting the transaction when an
142  * operation overflows.
143  *
144  * Using this library instead of the unchecked operations eliminates an entire
145  * class of bugs, so it's recommended to use it always.
146  */
147 library SafeMath {
148     /**
149      * @dev Returns the addition of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `+` operator.
153      *
154      * Requirements:
155      * - Addition cannot overflow.
156      */
157     function add(uint256 a, uint256 b) internal pure returns (uint256) {
158         uint256 c = a + b;
159         require(c >= a, "SafeMath: addition overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         return sub(a, b, "SafeMath: subtraction overflow");
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
179      * overflow (when the result is negative).
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      * - Subtraction cannot overflow.
185      *
186      * _Available since v2.4.0._
187      */
188     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b <= a, errorMessage);
190         uint256 c = a - b;
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the multiplication of two unsigned integers, reverting on
197      * overflow.
198      *
199      * Counterpart to Solidity's `*` operator.
200      *
201      * Requirements:
202      * - Multiplication cannot overflow.
203      */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
206         // benefit is lost if 'b' is also tested.
207         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
208         if (a == 0) {
209             return 0;
210         }
211 
212         uint256 c = a * b;
213         require(c / a == b, "SafeMath: multiplication overflow");
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b) internal pure returns (uint256) {
230         return div(a, b, "SafeMath: division by zero");
231     }
232 
233     /**
234      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
235      * division by zero. The result is rounded towards zero.
236      *
237      * Counterpart to Solidity's `/` operator. Note: this function uses a
238      * `revert` opcode (which leaves remaining gas untouched) while Solidity
239      * uses an invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      * - The divisor cannot be zero.
243      *
244      * _Available since v2.4.0._
245      */
246     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         // Solidity only automatically asserts when dividing by 0
248         require(b > 0, errorMessage);
249         uint256 c = a / b;
250         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
267         return mod(a, b, "SafeMath: modulo by zero");
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * Reverts with custom message when dividing by zero.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      * - The divisor cannot be zero.
280      *
281      * _Available since v2.4.0._
282      */
283     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b != 0, errorMessage);
285         return a % b;
286     }
287 }
288 
289 
290 /**
291  * @dev Implementation of the {IERC20} interface.
292  *
293  * This implementation is agnostic to the way tokens are created. This means
294  * that a supply mechanism has to be added in a derived contract using {_mint}.
295  * For a generic mechanism see {ERC20Mintable}.
296  *
297  * TIP: For a detailed writeup see our guide
298  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
299  * to implement supply mechanisms].
300  *
301  * We have followed general OpenZeppelin guidelines: functions revert instead
302  * of returning `false` on failure. This behavior is nonetheless conventional
303  * and does not conflict with the expectations of ERC20 applications.
304  *
305  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
306  * This allows applications to reconstruct the allowance for all accounts just
307  * by listening to said events. Other implementations of the EIP may not emit
308  * these events, as it isn't required by the specification.
309  *
310  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
311  * functions have been added to mitigate the well-known issues around setting
312  * allowances. See {IERC20-approve}.
313  */
314 
315 contract ERC20 is Context, IERC20, Ownable{
316     using SafeMath for uint256;
317 
318     mapping (address => uint256) private _balances;
319 
320     mapping (address => mapping (address => uint256)) private _allowances;
321 
322     uint256 private _totalSupply;
323 
324     /**
325      * @dev See {IERC20-totalSupply}.
326      */
327     function totalSupply() public view returns (uint256) {
328         return _totalSupply;
329     }
330 
331     /**
332      * @dev See {IERC20-balanceOf}.
333      */
334     function balanceOf(address account) public view returns (uint256) {
335         return _balances[account];
336     }
337 
338     /**
339      * @dev See {IERC20-transfer}.
340      *
341      * Requirements:
342      *
343      * - `recipient` cannot be the zero address.
344      * - the caller must have a balance of at least `amount`.
345      */
346     function transfer(address recipient, uint256 amount) public returns (bool) {
347         _transfer(_msgSender(), recipient, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-allowance}.
353      */
354     function allowance(address owner, address spender) public view returns (uint256) {
355         return _allowances[owner][spender];
356     }
357 
358     /**
359      * @dev See {IERC20-approve}.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      */
365     function approve(address spender, uint256 amount) public returns (bool) {
366         _approve(_msgSender(), spender, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-transferFrom}.
372      *
373      * Emits an {Approval} event indicating the updated allowance. This is not
374      * required by the EIP. See the note at the beginning of {ERC20};
375      *
376      * Requirements:
377      * - `sender` and `recipient` cannot be the zero address.
378      * - `sender` must have a balance of at least `amount`.
379      * - the caller must have allowance for `sender`'s tokens of at least
380      * `amount`.
381      */
382     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
383         _transfer(sender, recipient, amount);
384         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
385         return true;
386     }
387 
388     /**
389      * @dev Atomically increases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
401         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
402         return true;
403     }
404 
405     /**
406      * @dev Atomically decreases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      * - `spender` must have allowance for the caller of at least
417      * `subtractedValue`.
418      */
419     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
420         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
421         return true;
422     }
423 
424     /**
425      * @dev Moves tokens `amount` from `sender` to `recipient`.
426      *
427      * This is internal function is equivalent to {transfer}, and can be used to
428      * e.g. implement automatic token fees, slashing mechanisms, etc.
429      *
430      * Emits a {Transfer} event.
431      *
432      * Requirements:
433      *
434      * - `sender` cannot be the zero address.
435      * - `recipient` cannot be the zero address.
436      * - `sender` must have a balance of at least `amount`.
437      */
438     function _transfer(address sender, address recipient, uint256 amount) internal {
439         require(sender != address(0), "ERC20: transfer from the zero address");
440         require(recipient != address(0), "ERC20: transfer to the zero address");
441 
442         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
443         _balances[recipient] = _balances[recipient].add(amount);
444         emit Transfer(sender, recipient, amount);
445     }
446 
447     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
448      * the total supply.
449      *
450      * Emits a {Transfer} event with `from` set to the zero address.
451      *
452      * Requirements
453      *
454      * - `to` cannot be the zero address.
455      */
456     function _mint(address account, uint256 amount) internal {
457         require(account != address(0), "ERC20: mint to the zero address");
458 
459         _totalSupply = _totalSupply.add(amount);
460         _balances[account] = _balances[account].add(amount);
461         emit Transfer(address(0), account, amount);
462     }
463 
464     /**
465      * @dev Destroys `amount` tokens from `account`, reducing the
466      * total supply.
467      *
468      * Emits a {Transfer} event with `to` set to the zero address.
469      *
470      * Requirements
471      *
472      * - `account` cannot be the zero address.
473      * - `account` must have at least `amount` tokens.
474      */
475     function _burn(address account, uint256 amount) internal {
476         require(account != address(0), "ERC20: burn from the zero address");
477 
478         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
479         _totalSupply = _totalSupply.sub(amount);
480         emit Transfer(account, address(0), amount);
481     }
482 
483     /**
484      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
485      *
486      * This is internal function is equivalent to `approve`, and can be used to
487      * e.g. set automatic allowances for certain subsystems, etc.
488      *
489      * Emits an {Approval} event.
490      *
491      * Requirements:
492      *
493      * - `owner` cannot be the zero address.
494      * - `spender` cannot be the zero address.
495      */
496     function _approve(address owner, address spender, uint256 amount) internal {
497         require(owner != address(0), "ERC20: approve from the zero address");
498         require(spender != address(0), "ERC20: approve to the zero address");
499 
500         _allowances[owner][spender] = amount;
501         emit Approval(owner, spender, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
506      * from the caller's allowance.
507      *
508      * See {_burn} and {_approve}.
509      */
510     function _burnFrom(address account, uint256 amount) internal {
511         _burn(account, amount);
512         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
513     }
514 }
515 
516 /**
517  * @dev Optional functions from the ERC20 standard.
518  */
519 
520 contract ERC20Detailed is IERC20 {
521     string private _name;
522     string private _symbol;
523     uint8 private _decimals;
524 
525     /**
526      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
527      * these values are immutable: they can only be set once during
528      * construction.
529      */
530     constructor (string memory name, string memory symbol, uint8 decimals) public {
531         _name = name;
532         _symbol = symbol;
533         _decimals = decimals;
534     }
535 
536     /**
537      * @dev Returns the name of the token.
538      */
539     function name() public view returns (string memory) {
540         return _name;
541     }
542 
543     /**
544      * @dev Returns the symbol of the token, usually a shorter version of the
545      * name.
546      */
547     function symbol() public view returns (string memory) {
548         return _symbol;
549     }
550 
551     /**
552      * @dev Returns the number of decimals used to get its user representation.
553      * For example, if `decimals` equals `2`, a balance of `505` tokens should
554      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
555      *
556      * Tokens usually opt for a value of 18, imitating the relationship between
557      * Ether and Wei.
558      *
559      * NOTE: This information is only used for _display_ purposes: it in
560      * no way affects any of the arithmetic of the contract, including
561      * {IERC20-balanceOf} and {IERC20-transfer}.
562      */
563     function decimals() public view returns (uint8) {
564         return _decimals;
565     }
566 }
567 
568 /**
569  * @title Roles
570  * @dev Library for managing addresses assigned to a Role.
571  */
572 library Roles {
573     struct Role {
574         mapping (address => bool) bearer;
575     }
576 
577     /**
578      * @dev Give an account access to this role.
579      */
580     function add(Role storage role, address account) internal {
581         require(!has(role, account), "Roles: account already has role");
582         role.bearer[account] = true;
583     }
584 
585     /**
586      * @dev Remove an account's access to this role.
587      */
588     function remove(Role storage role, address account) internal {
589         require(has(role, account), "Roles: account does not have role");
590         role.bearer[account] = false;
591     }
592 
593     /**
594      * @dev Check if an account has this role.
595      * @return bool
596      */
597     function has(Role storage role, address account) internal view returns (bool) {
598         require(account != address(0), "Roles: account is the zero address");
599         return role.bearer[account];
600     }
601 }
602 
603 contract PauserRole is Context {
604     using Roles for Roles.Role;
605 
606     event PauserAdded(address indexed account);
607     event PauserRemoved(address indexed account);
608 
609     Roles.Role private _pausers;
610 
611     constructor () internal {
612         _addPauser(_msgSender());
613     }
614 
615     modifier onlyPauser() {
616         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
617         _;
618     }
619 
620     function isPauser(address account) public view returns (bool) {
621         return _pausers.has(account);
622     }
623 
624     function addPauser(address account) public onlyPauser {
625         _addPauser(account);
626     }
627 
628     function renouncePauser() public {
629         _removePauser(_msgSender());
630     }
631 
632     function _addPauser(address account) internal {
633         _pausers.add(account);
634         emit PauserAdded(account);
635     }
636 
637     function _removePauser(address account) internal {
638         _pausers.remove(account);
639         emit PauserRemoved(account);
640     }
641 }
642 
643 /**
644  * @dev Contract module which allows children to implement an emergency stop
645  * mechanism that can be triggered by an authorized account.
646  *
647  * This module is used through inheritance. It will make available the
648  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
649  * the functions of your contract. Note that they will not be pausable by
650  * simply including this module, only once the modifiers are put in place.
651  */
652 contract Pausable is Context, PauserRole {
653     /**
654      * @dev Emitted when the pause is triggered by a pauser (`account`).
655      */
656     event Paused(address account);
657 
658     /**
659      * @dev Emitted when the pause is lifted by a pauser (`account`).
660      */
661     event Unpaused(address account);
662 
663     bool private _paused;
664 
665     /**
666      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
667      * to the deployer.
668      */
669     constructor () internal {
670         _paused = false;
671     }
672 
673     /**
674      * @dev Returns true if the contract is paused, and false otherwise.
675      */
676     function paused() public view returns (bool) {
677         return _paused;
678     }
679 
680     /**
681      * @dev Modifier to make a function callable only when the contract is not paused.
682      */
683     modifier whenNotPaused() {
684         require(!_paused, "Pausable: paused");
685         _;
686     }
687 
688     /**
689      * @dev Modifier to make a function callable only when the contract is paused.
690      */
691     modifier whenPaused() {
692         require(_paused, "Pausable: not paused");
693         _;
694     }
695 
696     /**
697      * @dev Called by a pauser to pause, triggers stopped state.
698      */
699     function pause() public onlyPauser whenNotPaused {
700         _paused = true;
701         emit Paused(_msgSender());
702     }
703 
704     /**
705      * @dev Called by a pauser to unpause, returns to normal state.
706      */
707     function unpause() public onlyPauser whenPaused {
708         _paused = false;
709         emit Unpaused(_msgSender());
710     }
711 }
712 
713 /**
714  * @title Pausable token
715  * @dev ERC20 with pausable transfers and allowances.
716  *
717  * Useful if you want to stop trades until the end of a crowdsale, or have
718  * an emergency switch for freezing all token transfers in the event of a large
719  * bug.
720  */
721 contract ERC20Pausable is ERC20, Pausable {
722     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
723         return super.transfer(to, value);
724     }
725 
726     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
727         return super.transferFrom(from, to, value);
728     }
729 
730     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
731         return super.approve(spender, value);
732     }
733 
734     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
735         return super.increaseAllowance(spender, addedValue);
736     }
737 
738     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
739         return super.decreaseAllowance(spender, subtractedValue);
740     }
741 }
742 
743 /**
744  * @title SimpleToken
745  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
746  * Note they can later distribute these tokens as they wish using `transfer` and other
747  * `ERC20` functions.
748  */
749 
750 contract GossipToken is Context, ERC20, ERC20Detailed, ERC20Pausable {
751     
752     constructor () public ERC20Detailed("Gossip Token", "GOSS", 18) {
753         _mint(_msgSender(), 100000000 * (10 ** uint256(decimals())));
754     }
755 }