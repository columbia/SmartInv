1 pragma solidity ^0.5.8;
2 
3 /*
4  * list of wallets planned to store tokens
5  * 
6  * | wallet address                             | token amount           | name                |
7  * |:------------------------------------------:|-----------------------:|:--------------------|
8  * | 0x2589F41013b0bb8B662c61431644445615120291 |  31,500,000 EYEX (15%) | Funding             |
9  * | 0x73F48eF1eAEC2d983562195dcF6F79d740A5bFCe |  10,500,000 EYEX ( 5%) | Technology          |
10  * | 0x3414c85135b9178B003D70Ab2542B2ca76ab7d95 |   8,400,000 EYEX ( 4%) | Marketing/Operating |
11  * | 0x2158A26FACd232D2F784D044254294Ee32910Ef1 |   2,100,000 EYEX ( 1%) | Legal               |
12  * | 0x79015331b090e63Aee7F1198817a43E35236e3d2 |  10,500,000 EYEX ( 5%) | Sale                |
13  * | 0xc64f6D3B382D4b03786a23E75788C2A6D1C45Ec8 |  21,000,000 EYEX (10%) | M&A                 |
14  * | 0x0a9D698Fc555E4E51BAC631e4CeB26712328364D | 126,000,000 EYEX (60%) | Mining              |
15  */
16 
17 /**
18  * @dev Wrappers over Solidity's arithmetic operations with added overflow
19  * checks.
20  *
21  * Arithmetic operations in Solidity wrap on overflow. This can easily result
22  * in bugs, because programmers usually assume that an overflow raises an
23  * error, which is the standard behavior in high level programming languages.
24  * `SafeMath` restores this intuition by reverting the transaction when an
25  * operation overflows.
26  *
27  * Using this library instead of the unchecked operations eliminates an entire
28  * class of bugs, so it's recommended to use it always.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, reverting on
33      * overflow.
34      *
35      * Counterpart to Solidity's `+` operator.
36      *
37      * Requirements:
38      * - Addition cannot overflow.
39      */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b <= a, "SafeMath: subtraction overflow");
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the multiplication of two unsigned integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `*` operator.
68      *
69      * Requirements:
70      * - Multiplication cannot overflow.
71      */
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
74         // benefit is lost if 'b' is also tested.
75         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the integer division of two unsigned integers. Reverts on
88      * division by zero. The result is rounded towards zero.
89      *
90      * Counterpart to Solidity's `/` operator. Note: this function uses a
91      * `revert` opcode (which leaves remaining gas untouched) while Solidity
92      * uses an invalid opcode to revert (consuming all remaining gas).
93      *
94      * Requirements:
95      * - The divisor cannot be zero.
96      */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         // Solidity only automatically asserts when dividing by 0
99         require(b > 0, "SafeMath: division by zero");
100         uint256 c = a / b;
101         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
108      * Reverts when dividing by zero.
109      *
110      * Counterpart to Solidity's `%` operator. This function uses a `revert`
111      * opcode (which leaves remaining gas untouched) while Solidity uses an
112      * invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      * - The divisor cannot be zero.
116      */
117     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b != 0, "SafeMath: modulo by zero");
119         return a % b;
120     }
121 }
122 
123 /**
124  * @title Roles
125  * @dev Library for managing addresses assigned to a Role.
126  */
127 library Roles {
128     struct Role {
129         mapping (address => bool) bearer;
130     }
131 
132     /**
133      * @dev Give an account access to this role.
134      */
135     function add(Role storage role, address account) internal {
136         require(!has(role, account), "Roles: account already has role");
137         role.bearer[account] = true;
138     }
139 
140     /**
141      * @dev Remove an account's access to this role.
142      */
143     function remove(Role storage role, address account) internal {
144         require(has(role, account), "Roles: account does not have role");
145         role.bearer[account] = false;
146     }
147 
148     /**
149      * @dev Check if an account has this role.
150      * @return bool
151      */
152     function has(Role storage role, address account) internal view returns (bool) {
153         require(account != address(0), "Roles: account is the zero address");
154         return role.bearer[account];
155     }
156 }
157 
158 /**
159  * @dev Contract module which provides a basic access control mechanism, where
160  * there is an account (an owner) that can be granted exclusive access to
161  * specific functions.
162  *
163  * This module is used through inheritance. It will make available the modifier
164  * `onlyOwner`, which can be aplied to your functions to restrict their use to
165  * the owner.
166  */
167 contract Ownable {
168     address private _owner;
169 
170     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
171 
172     /**
173      * @dev Initializes the contract setting the deployer as the initial owner.
174      */
175     constructor () internal {
176         _owner = msg.sender;
177         emit OwnershipTransferred(address(0), _owner);
178     }
179 
180     /**
181      * @dev Returns the address of the current owner.
182      */
183     function owner() public view returns (address) {
184         return _owner;
185     }
186 
187     /**
188      * @dev Throws if called by any account other than the owner.
189      */
190     modifier onlyOwner() {
191         require(isOwner(), "Ownable: caller is not the owner");
192         _;
193     }
194 
195     /**
196      * @dev Returns true if the caller is the current owner.
197      */
198     function isOwner() public view returns (bool) {
199         return msg.sender == _owner;
200     }
201 
202     /**
203      * @dev Leaves the contract without owner. It will not be possible to call
204      * `onlyOwner` functions anymore. Can only be called by the current owner.
205      *
206      * > Note: Renouncing ownership will leave the contract without an owner,
207      * thereby removing any functionality that is only available to the owner.
208      */
209     function renounceOwnership() public onlyOwner {
210         emit OwnershipTransferred(_owner, address(0));
211         _owner = address(0);
212     }
213 
214     /**
215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
216      * Can only be called by the current owner.
217      */
218     function transferOwnership(address newOwner) public onlyOwner {
219         _transferOwnership(newOwner);
220     }
221 
222     /**
223      * @dev Transfers ownership of the contract to a new account (`newOwner`).
224      */
225     function _transferOwnership(address newOwner) internal {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         emit OwnershipTransferred(_owner, newOwner);
228         _owner = newOwner;
229     }
230 }
231 
232 contract PauserRole {
233     using Roles for Roles.Role;
234 
235     event PauserAdded(address indexed account);
236     event PauserRemoved(address indexed account);
237 
238     Roles.Role private _pausers;
239 
240     constructor () internal {
241         _addPauser(msg.sender);
242     }
243 
244     modifier onlyPauser() {
245         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
246         _;
247     }
248 
249     function isPauser(address account) public view returns (bool) {
250         return _pausers.has(account);
251     }
252 
253     function addPauser(address account) public onlyPauser {
254         _addPauser(account);
255     }
256 
257     function renouncePauser() public {
258         _removePauser(msg.sender);
259     }
260 
261     function _addPauser(address account) internal {
262         _pausers.add(account);
263         emit PauserAdded(account);
264     }
265 
266     function _removePauser(address account) internal {
267         _pausers.remove(account);
268         emit PauserRemoved(account);
269     }
270 }
271 
272 /**
273  * @dev Contract module which allows children to implement an emergency stop
274  * mechanism that can be triggered by an authorized account.
275  *
276  * This module is used through inheritance. It will make available the
277  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
278  * the functions of your contract. Note that they will not be pausable by
279  * simply including this module, only once the modifiers are put in place.
280  */
281 contract Pausable is PauserRole {
282     /**
283      * @dev Emitted when the pause is triggered by a pauser (`account`).
284      */
285     event Paused(address account);
286 
287     /**
288      * @dev Emitted when the pause is lifted by a pauser (`account`).
289      */
290     event Unpaused(address account);
291 
292     bool private _paused;
293 
294     /**
295      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
296      * to the deployer.
297      */
298     constructor () internal {
299         _paused = false;
300     }
301 
302     /**
303      * @dev Returns true if the contract is paused, and false otherwise.
304      */
305     function paused() public view returns (bool) {
306         return _paused;
307     }
308 
309     /**
310      * @dev Modifier to make a function callable only when the contract is not paused.
311      */
312     modifier whenNotPaused() {
313         require(!_paused, "Pausable: paused");
314         _;
315     }
316 
317     /**
318      * @dev Modifier to make a function callable only when the contract is paused.
319      */
320     modifier whenPaused() {
321         require(_paused, "Pausable: not paused");
322         _;
323     }
324 
325     /**
326      * @dev Called by a pauser to pause, triggers stopped state.
327      */
328     function pause() public onlyPauser whenNotPaused {
329         _paused = true;
330         emit Paused(msg.sender);
331     }
332 
333     /**
334      * @dev Called by a pauser to unpause, returns to normal state.
335      */
336     function unpause() public onlyPauser whenPaused {
337         _paused = false;
338         emit Unpaused(msg.sender);
339     }
340 }
341 
342 /**
343  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
344  * the optional functions; to access them see `ERC20Detailed`.
345  */
346 interface IERC20 {
347     /**
348      * @dev Returns the amount of tokens in existence.
349      */
350     function totalSupply() external view returns (uint256);
351 
352     /**
353      * @dev Returns the amount of tokens owned by `account`.
354      */
355     function balanceOf(address account) external view returns (uint256);
356 
357     /**
358      * @dev Moves `amount` tokens from the caller's account to `recipient`.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * Emits a `Transfer` event.
363      */
364     function transfer(address recipient, uint256 amount) external returns (bool);
365 
366     /**
367      * @dev Returns the remaining number of tokens that `spender` will be
368      * allowed to spend on behalf of `owner` through `transferFrom`. This is
369      * zero by default.
370      *
371      * This value changes when `approve` or `transferFrom` are called.
372      */
373     function allowance(address owner, address spender) external view returns (uint256);
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * > Beware that changing an allowance with this method brings the risk
381      * that someone may use both the old and the new allowance by unfortunate
382      * transaction ordering. One possible solution to mitigate this race
383      * condition is to first reduce the spender's allowance to 0 and set the
384      * desired value afterwards:
385      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
386      *
387      * Emits an `Approval` event.
388      */
389     function approve(address spender, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Moves `amount` tokens from `sender` to `recipient` using the
393      * allowance mechanism. `amount` is then deducted from the caller's
394      * allowance.
395      *
396      * Returns a boolean value indicating whether the operation succeeded.
397      *
398      * Emits a `Transfer` event.
399      */
400     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Emitted when `value` tokens are moved from one account (`from`) to
404      * another (`to`).
405      *
406      * Note that `value` may be zero.
407      */
408     event Transfer(address indexed from, address indexed to, uint256 value);
409 
410     /**
411      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
412      * a call to `approve`. `value` is the new allowance.
413      */
414     event Approval(address indexed owner, address indexed spender, uint256 value);
415 }
416 
417 /**
418  * @dev Optional functions from the ERC20 standard.
419  */
420 contract ERC20Detailed is IERC20 {
421     string private _name;
422     string private _symbol;
423     uint8 private _decimals;
424 
425     /**
426      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
427      * these values are immutable: they can only be set once during
428      * construction.
429      */
430     constructor (string memory name, string memory symbol, uint8 decimals) public {
431         _name = name;
432         _symbol = symbol;
433         _decimals = decimals;
434     }
435 
436     /**
437      * @dev Returns the name of the token.
438      */
439     function name() public view returns (string memory) {
440         return _name;
441     }
442 
443     /**
444      * @dev Returns the symbol of the token, usually a shorter version of the
445      * name.
446      */
447     function symbol() public view returns (string memory) {
448         return _symbol;
449     }
450 
451     /**
452      * @dev Returns the number of decimals used to get its user representation.
453      * For example, if `decimals` equals `2`, a balance of `505` tokens should
454      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
455      *
456      * Tokens usually opt for a value of 18, imitating the relationship between
457      * Ether and Wei.
458      *
459      * > Note that this information is only used for _display_ purposes: it in
460      * no way affects any of the arithmetic of the contract, including
461      * `IERC20.balanceOf` and `IERC20.transfer`.
462      */
463     function decimals() public view returns (uint8) {
464         return _decimals;
465     }
466 }
467 
468 /**
469  * @dev Implementation of the `IERC20` interface.
470  *
471  * This implementation is agnostic to the way tokens are created. This means
472  * that a supply mechanism has to be added in a derived contract using `_mint`.
473  * For a generic mechanism see `ERC20Mintable`.
474  *
475  * *For a detailed writeup see our guide [How to implement supply
476  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
477  *
478  * We have followed general OpenZeppelin guidelines: functions revert instead
479  * of returning `false` on failure. This behavior is nonetheless conventional
480  * and does not conflict with the expectations of ERC20 applications.
481  *
482  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
483  * This allows applications to reconstruct the allowance for all accounts just
484  * by listening to said events. Other implementations of the EIP may not emit
485  * these events, as it isn't required by the specification.
486  *
487  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
488  * functions have been added to mitigate the well-known issues around setting
489  * allowances. See `IERC20.approve`.
490  */
491 contract ERC20 is IERC20 {
492     using SafeMath for uint256;
493 
494     mapping (address => uint256) private _balances;
495 
496     mapping (address => mapping (address => uint256)) private _allowances;
497 
498     uint256 private _totalSupply;
499 
500     /**
501      * @dev See `IERC20.totalSupply`.
502      */
503     function totalSupply() public view returns (uint256) {
504         return _totalSupply;
505     }
506 
507     /**
508      * @dev See `IERC20.balanceOf`.
509      */
510     function balanceOf(address account) public view returns (uint256) {
511         return _balances[account];
512     }
513 
514     /**
515      * @dev See `IERC20.transfer`.
516      *
517      * Requirements:
518      *
519      * - `recipient` cannot be the zero address.
520      * - the caller must have a balance of at least `amount`.
521      */
522     function transfer(address recipient, uint256 amount) public returns (bool) {
523         _transfer(msg.sender, recipient, amount);
524         return true;
525     }
526 
527     /**
528      * @dev See `IERC20.allowance`.
529      */
530     function allowance(address owner, address spender) public view returns (uint256) {
531         return _allowances[owner][spender];
532     }
533 
534     /**
535      * @dev See `IERC20.approve`.
536      *
537      * Requirements:
538      *
539      * - `spender` cannot be the zero address.
540      */
541     function approve(address spender, uint256 value) public returns (bool) {
542         _approve(msg.sender, spender, value);
543         return true;
544     }
545 
546     /**
547      * @dev See `IERC20.transferFrom`.
548      *
549      * Emits an `Approval` event indicating the updated allowance. This is not
550      * required by the EIP. See the note at the beginning of `ERC20`;
551      *
552      * Requirements:
553      * - `sender` and `recipient` cannot be the zero address.
554      * - `sender` must have a balance of at least `value`.
555      * - the caller must have allowance for `sender`'s tokens of at least
556      * `amount`.
557      */
558     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
559         _transfer(sender, recipient, amount);
560         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
561         return true;
562     }
563 
564     /**
565      * @dev Atomically increases the allowance granted to `spender` by the caller.
566      *
567      * This is an alternative to `approve` that can be used as a mitigation for
568      * problems described in `IERC20.approve`.
569      *
570      * Emits an `Approval` event indicating the updated allowance.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      */
576     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
577         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
578         return true;
579     }
580 
581     /**
582      * @dev Atomically decreases the allowance granted to `spender` by the caller.
583      *
584      * This is an alternative to `approve` that can be used as a mitigation for
585      * problems described in `IERC20.approve`.
586      *
587      * Emits an `Approval` event indicating the updated allowance.
588      *
589      * Requirements:
590      *
591      * - `spender` cannot be the zero address.
592      * - `spender` must have allowance for the caller of at least
593      * `subtractedValue`.
594      */
595     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
596         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
597         return true;
598     }
599 
600     /**
601      * @dev Moves tokens `amount` from `sender` to `recipient`.
602      *
603      * This is internal function is equivalent to `transfer`, and can be used to
604      * e.g. implement automatic token fees, slashing mechanisms, etc.
605      *
606      * Emits a `Transfer` event.
607      *
608      * Requirements:
609      *
610      * - `sender` cannot be the zero address.
611      * - `recipient` cannot be the zero address.
612      * - `sender` must have a balance of at least `amount`.
613      */
614     function _transfer(address sender, address recipient, uint256 amount) internal {
615         require(sender != address(0), "ERC20: transfer from the zero address");
616         require(recipient != address(0), "ERC20: transfer to the zero address");
617 
618         _balances[sender] = _balances[sender].sub(amount);
619         _balances[recipient] = _balances[recipient].add(amount);
620         emit Transfer(sender, recipient, amount);
621     }
622 
623     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
624      * the total supply.
625      *
626      * Emits a `Transfer` event with `from` set to the zero address.
627      *
628      * Requirements
629      *
630      * - `to` cannot be the zero address.
631      */
632     function _mint(address account, uint256 amount) internal {
633         require(account != address(0), "ERC20: mint to the zero address");
634 
635         _totalSupply = _totalSupply.add(amount);
636         _balances[account] = _balances[account].add(amount);
637         emit Transfer(address(0), account, amount);
638     }
639 
640      /**
641      * @dev Destoys `amount` tokens from `account`, reducing the
642      * total supply.
643      *
644      * Emits a `Transfer` event with `to` set to the zero address.
645      *
646      * Requirements
647      *
648      * - `account` cannot be the zero address.
649      * - `account` must have at least `amount` tokens.
650      */
651     function _burn(address account, uint256 value) internal {
652         require(account != address(0), "ERC20: burn from the zero address");
653 
654         _totalSupply = _totalSupply.sub(value);
655         _balances[account] = _balances[account].sub(value);
656         emit Transfer(account, address(0), value);
657     }
658 
659     /**
660      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
661      *
662      * This is internal function is equivalent to `approve`, and can be used to
663      * e.g. set automatic allowances for certain subsystems, etc.
664      *
665      * Emits an `Approval` event.
666      *
667      * Requirements:
668      *
669      * - `owner` cannot be the zero address.
670      * - `spender` cannot be the zero address.
671      */
672     function _approve(address owner, address spender, uint256 value) internal {
673         require(owner != address(0), "ERC20: approve from the zero address");
674         require(spender != address(0), "ERC20: approve to the zero address");
675 
676         _allowances[owner][spender] = value;
677         emit Approval(owner, spender, value);
678     }
679 
680     /**
681      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
682      * from the caller's allowance.
683      *
684      * See `_burn` and `_approve`.
685      */
686     function _burnFrom(address account, uint256 amount) internal {
687         _burn(account, amount);
688         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
689     }
690 }
691 
692 /**
693  * @title Pausable token
694  * @dev ERC20 modified with pausable transfers.
695  */
696 contract ERC20Pausable is ERC20, Pausable {
697     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
698         return super.transfer(to, value);
699     }
700 
701     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
702         return super.transferFrom(from, to, value);
703     }
704 
705     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
706         return super.approve(spender, value);
707     }
708 
709     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
710         return super.increaseAllowance(spender, addedValue);
711     }
712 
713     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
714         return super.decreaseAllowance(spender, subtractedValue);
715     }
716 }
717 
718 // Codes above are copied from library `OpenZeppelin` for validating contract source
719 
720 contract EYEXContract is Ownable, ERC20Detailed, ERC20Pausable {
721     using SafeMath for uint256;
722 
723     constructor() ERC20Detailed("EYEX", "EYEX",  18) public
724     {
725         uint256 total_supply = 210000000 ether;
726         _mint(msg.sender, total_supply);
727         assert (totalSupply() == 210000000 ether);
728     }
729 }