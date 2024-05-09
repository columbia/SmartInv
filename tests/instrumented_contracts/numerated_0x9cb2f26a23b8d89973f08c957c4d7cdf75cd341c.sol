1 pragma solidity 0.5.8;
2 
3 /*
4 *  DigitalRand.sol
5 *  DZAR token smart contract
6 *  2019-11-22
7 *  https://digitalrand.co.za
8 **/
9 library SafeMath {
10     /**
11      * @dev Returns the addition of two unsigned integers, reverting on
12      * overflow.
13      *
14      * Counterpart to Solidity's `+` operator.
15      *
16      * Requirements:
17      * - Addition cannot overflow.
18      */
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25 
26     /**
27      * @dev Returns the subtraction of two unsigned integers, reverting on
28      * overflow (when the result is negative).
29      *
30      * Counterpart to Solidity's `-` operator.
31      *
32      * Requirements:
33      * - Subtraction cannot overflow.
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b <= a, "SafeMath: subtraction overflow");
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `*` operator.
47      *
48      * Requirements:
49      * - Multiplication cannot overflow.
50      */
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55         if (a == 0) {
56             return 0;
57         }
58 
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the integer division of two unsigned integers. Reverts on
67      * division by zero. The result is rounded towards zero.
68      *
69      * Counterpart to Solidity's `/` operator. Note: this function uses a
70      * `revert` opcode (which leaves remaining gas untouched) while Solidity
71      * uses an invalid opcode to revert (consuming all remaining gas).
72      *
73      * Requirements:
74      * - The divisor cannot be zero.
75      */
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Solidity only automatically asserts when dividing by 0
78         require(b > 0, "SafeMath: division by zero");
79         uint256 c = a / b;
80         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
87      * Reverts when dividing by zero.
88      *
89      * Counterpart to Solidity's `%` operator. This function uses a `revert`
90      * opcode (which leaves remaining gas untouched) while Solidity uses an
91      * invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      * - The divisor cannot be zero.
95      */
96     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97         require(b != 0, "SafeMath: modulo by zero");
98         return a % b;
99     }
100 }
101 
102 /**
103  * @title Roles
104  * @dev Library for managing addresses assigned to a Role.
105  */
106 library Roles {
107     struct Role {
108         mapping (address => bool) bearer;
109     }
110 
111     /**
112      * @dev Give an account access to this role.
113      */
114     function add(Role storage role, address account) internal {
115         require(!has(role, account), "Roles: account already has role");
116         role.bearer[account] = true;
117     }
118 
119     /**
120      * @dev Remove an account's access to this role.
121      */
122     function remove(Role storage role, address account) internal {
123         require(has(role, account), "Roles: account does not have role");
124         role.bearer[account] = false;
125     }
126 
127     /**
128      * @dev Check if an account has this role.
129      * @return bool
130      */
131     function has(Role storage role, address account) internal view returns (bool) {
132         require(account != address(0), "Roles: account is the zero address");
133         return role.bearer[account];
134     }
135 }
136 
137 contract PauserRole {
138     using Roles for Roles.Role;
139 
140     event PauserAdded(address indexed account);
141     event PauserRemoved(address indexed account);
142 
143     Roles.Role private _pausers;
144 
145     constructor () internal {
146         _addPauser(msg.sender);
147     }
148 
149     modifier onlyPauser() {
150         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
151         _;
152     }
153 
154     function isPauser(address account) public view returns (bool) {
155         return _pausers.has(account);
156     }
157 
158     function addPauser(address account) public onlyPauser {
159         _addPauser(account);
160     }
161 
162     function renouncePauser() public {
163         _removePauser(msg.sender);
164     }
165 
166     function _addPauser(address account) internal {
167         _pausers.add(account);
168         emit PauserAdded(account);
169     }
170 
171     function _removePauser(address account) internal {
172         _pausers.remove(account);
173         emit PauserRemoved(account);
174     }
175 }
176 
177 /**
178  * @dev Contract module which allows children to implement an emergency stop
179  * mechanism that can be triggered by an authorized account.
180  *
181  * This module is used through inheritance. It will make available the
182  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
183  * the functions of your contract. Note that they will not be pausable by
184  * simply including this module, only once the modifiers are put in place.
185  */
186 contract Pausable is PauserRole {
187     /**
188      * @dev Emitted when the pause is triggered by a pauser (`account`).
189      */
190     event Paused(address account);
191 
192     /**
193      * @dev Emitted when the pause is lifted by a pauser (`account`).
194      */
195     event Unpaused(address account);
196 
197     bool private _paused;
198 
199     /**
200      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
201      * to the deployer.
202      */
203     constructor () internal {
204         _paused = false;
205     }
206 
207     /**
208      * @dev Returns true if the contract is paused, and false otherwise.
209      */
210     function paused() public view returns (bool) {
211         return _paused;
212     }
213 
214     /**
215      * @dev Modifier to make a function callable only when the contract is not paused.
216      */
217     modifier whenNotPaused() {
218         require(!_paused, "Pausable: paused");
219         _;
220     }
221 
222     /**
223      * @dev Modifier to make a function callable only when the contract is paused.
224      */
225     modifier whenPaused() {
226         require(_paused, "Pausable: not paused");
227         _;
228     }
229 
230     /**
231      * @dev Called by a pauser to pause, triggers stopped state.
232      */
233     function pause() public onlyPauser whenNotPaused {
234         _paused = true;
235         emit Paused(msg.sender);
236     }
237 
238     /**
239      * @dev Called by a pauser to unpause, returns to normal state.
240      */
241     function unpause() public onlyPauser whenPaused {
242         _paused = false;
243         emit Unpaused(msg.sender);
244     }
245 }
246 
247 /**
248  * @dev Contract module which provides a basic access control mechanism, where
249  * there is an account (an owner) that can be granted exclusive access to
250  * specific functions.
251  *
252  * This module is used through inheritance. It will make available the modifier
253  * `onlyOwner`, which can be aplied to your functions to restrict their use to
254  * the owner.
255  */
256 contract Ownable {
257     address private _owner;
258 
259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
260 
261     /**
262      * @dev Initializes the contract setting the deployer as the initial owner.
263      */
264     constructor () internal {
265         _owner = msg.sender;
266         emit OwnershipTransferred(address(0), _owner);
267     }
268 
269     /**
270      * @dev Returns the address of the current owner.
271      */
272     function owner() public view returns (address) {
273         return _owner;
274     }
275 
276     /**
277      * @dev Throws if called by any account other than the owner.
278      */
279     modifier onlyOwner() {
280         require(isOwner(), "Ownable: caller is not the owner");
281         _;
282     }
283 
284     /**
285      * @dev Returns true if the caller is the current owner.
286      */
287     function isOwner() public view returns (bool) {
288         return msg.sender == _owner;
289     }
290 
291     /**
292      * @dev Leaves the contract without owner. It will not be possible to call
293      * `onlyOwner` functions anymore. Can only be called by the current owner.
294      *
295      * > Note: Renouncing ownership will leave the contract without an owner,
296      * thereby removing any functionality that is only available to the owner.
297      */
298     function renounceOwnership() public onlyOwner {
299         emit OwnershipTransferred(_owner, address(0));
300         _owner = address(0);
301     }
302 
303     /**
304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
305      * Can only be called by the current owner.
306      */
307     function transferOwnership(address newOwner) public onlyOwner {
308         _transferOwnership(newOwner);
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      */
314     function _transferOwnership(address newOwner) internal {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         emit OwnershipTransferred(_owner, newOwner);
317         _owner = newOwner;
318     }
319 }
320 
321 /**
322  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
323  * the optional functions; to access them see `ERC20Detailed`.
324  */
325 interface IERC20 {
326     /**
327      * @dev Returns the amount of tokens in existence.
328      */
329     function totalSupply() external view returns (uint256);
330 
331     /**
332      * @dev Returns the amount of tokens owned by `account`.
333      */
334     function balanceOf(address account) external view returns (uint256);
335 
336     /**
337      * @dev Moves `amount` tokens from the caller's account to `recipient`.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * Emits a `Transfer` event.
342      */
343     function transfer(address recipient, uint256 amount) external returns (bool);
344 
345     /**
346      * @dev Returns the remaining number of tokens that `spender` will be
347      * allowed to spend on behalf of `owner` through `transferFrom`. This is
348      * zero by default.
349      *
350      * This value changes when `approve` or `transferFrom` are called.
351      */
352     function allowance(address owner, address spender) external view returns (uint256);
353 
354     /**
355      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * > Beware that changing an allowance with this method brings the risk
360      * that someone may use both the old and the new allowance by unfortunate
361      * transaction ordering. One possible solution to mitigate this race
362      * condition is to first reduce the spender's allowance to 0 and set the
363      * desired value afterwards:
364      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
365      *
366      * Emits an `Approval` event.
367      */
368     function approve(address spender, uint256 amount) external returns (bool);
369 
370     /**
371      * @dev Moves `amount` tokens from `sender` to `recipient` using the
372      * allowance mechanism. `amount` is then deducted from the caller's
373      * allowance.
374      *
375      * Returns a boolean value indicating whether the operation succeeded.
376      *
377      * Emits a `Transfer` event.
378      */
379     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
380 
381     /**
382      * @dev Emitted when `value` tokens are moved from one account (`from`) to
383      * another (`to`).
384      *
385      * Note that `value` may be zero.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 value);
388 
389     /**
390      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
391      * a call to `approve`. `value` is the new allowance.
392      */
393     event Approval(address indexed owner, address indexed spender, uint256 value);
394 }
395 
396 /**
397  * @dev Implementation of the `IERC20` interface.
398  *
399  * This implementation is agnostic to the way tokens are created. This means
400  * that a supply mechanism has to be added in a derived contract using `_mint`.
401  * For a generic mechanism see `ERC20Mintable`.
402  *
403  * *For a detailed writeup see our guide [How to implement supply
404  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
405  *
406  * We have followed general OpenZeppelin guidelines: functions revert instead
407  * of returning `false` on failure. This behavior is nonetheless conventional
408  * and does not conflict with the expectations of ERC20 applications.
409  *
410  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
411  * This allows applications to reconstruct the allowance for all accounts just
412  * by listening to said events. Other implementations of the EIP may not emit
413  * these events, as it isn't required by the specification.
414  *
415  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
416  * functions have been added to mitigate the well-known issues around setting
417  * allowances. See `IERC20.approve`.
418  */
419 contract ERC20 is IERC20 {
420     using SafeMath for uint256;
421 
422     mapping (address => uint256) private _balances;
423 
424     mapping (address => mapping (address => uint256)) private _allowances;
425 
426     uint256 private _totalSupply;
427 
428     /**
429      * @dev See `IERC20.totalSupply`.
430      */
431     function totalSupply() public view returns (uint256) {
432         return _totalSupply;
433     }
434 
435     /**
436      * @dev See `IERC20.balanceOf`.
437      */
438     function balanceOf(address account) public view returns (uint256) {
439         return _balances[account];
440     }
441 
442     /**
443      * @dev See `IERC20.transfer`.
444      *
445      * Requirements:
446      *
447      * - `recipient` cannot be the zero address.
448      * - the caller must have a balance of at least `amount`.
449      */
450     function transfer(address recipient, uint256 amount) public returns (bool) {
451         _transfer(msg.sender, recipient, amount);
452         return true;
453     }
454 
455     /**
456      * @dev See `IERC20.allowance`.
457      */
458     function allowance(address owner, address spender) public view returns (uint256) {
459         return _allowances[owner][spender];
460     }
461 
462     /**
463      * @dev See `IERC20.approve`.
464      *
465      * Requirements:
466      *
467      * - `spender` cannot be the zero address.
468      */
469     function approve(address spender, uint256 value) public returns (bool) {
470         _approve(msg.sender, spender, value);
471         return true;
472     }
473 
474     /**
475      * @dev See `IERC20.transferFrom`.
476      *
477      * Emits an `Approval` event indicating the updated allowance. This is not
478      * required by the EIP. See the note at the beginning of `ERC20`;
479      *
480      * Requirements:
481      * - `sender` and `recipient` cannot be the zero address.
482      * - `sender` must have a balance of at least `value`.
483      * - the caller must have allowance for `sender`'s tokens of at least
484      * `amount`.
485      */
486     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
487         _transfer(sender, recipient, amount);
488         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
489         return true;
490     }
491 
492     /**
493      * @dev Atomically increases the allowance granted to `spender` by the caller.
494      *
495      * This is an alternative to `approve` that can be used as a mitigation for
496      * problems described in `IERC20.approve`.
497      *
498      * Emits an `Approval` event indicating the updated allowance.
499      *
500      * Requirements:
501      *
502      * - `spender` cannot be the zero address.
503      */
504     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
505         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
506         return true;
507     }
508 
509     /**
510      * @dev Atomically decreases the allowance granted to `spender` by the caller.
511      *
512      * This is an alternative to `approve` that can be used as a mitigation for
513      * problems described in `IERC20.approve`.
514      *
515      * Emits an `Approval` event indicating the updated allowance.
516      *
517      * Requirements:
518      *
519      * - `spender` cannot be the zero address.
520      * - `spender` must have allowance for the caller of at least
521      * `subtractedValue`.
522      */
523     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
524         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
525         return true;
526     }
527 
528     /**
529      * @dev Moves tokens `amount` from `sender` to `recipient`.
530      *
531      * This is internal function is equivalent to `transfer`, and can be used to
532      * e.g. implement automatic token fees, slashing mechanisms, etc.
533      *
534      * Emits a `Transfer` event.
535      *
536      * Requirements:
537      *
538      * - `sender` cannot be the zero address.
539      * - `recipient` cannot be the zero address.
540      * - `sender` must have a balance of at least `amount`.
541      */
542     function _transfer(address sender, address recipient, uint256 amount) internal {
543         require(sender != address(0), "ERC20: transfer from the zero address");
544         require(recipient != address(0), "ERC20: transfer to the zero address");
545 
546         _balances[sender] = _balances[sender].sub(amount);
547         _balances[recipient] = _balances[recipient].add(amount);
548         emit Transfer(sender, recipient, amount);
549     }
550 
551     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
552      * the total supply.
553      *
554      * Emits a `Transfer` event with `from` set to the zero address.
555      *
556      * Requirements
557      *
558      * - `to` cannot be the zero address.
559      */
560     function _mint(address account, uint256 amount) internal {
561         require(account != address(0), "ERC20: mint to the zero address");
562 
563         _totalSupply = _totalSupply.add(amount);
564         _balances[account] = _balances[account].add(amount);
565         emit Transfer(address(0), account, amount);
566     }
567 
568     /**
569     * @dev Destoys `amount` tokens from `account`, reducing the
570     * total supply.
571     *
572     * Emits a `Transfer` event with `to` set to the zero address.
573     *
574     * Requirements
575     *
576     * - `account` cannot be the zero address.
577     * - `account` must have at least `amount` tokens.
578     */
579     function _burn(address account, uint256 value) internal {
580         require(account != address(0), "ERC20: burn from the zero address");
581 
582         _totalSupply = _totalSupply.sub(value);
583         _balances[account] = _balances[account].sub(value);
584         emit Transfer(account, address(0), value);
585     }
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
589      *
590      * This is internal function is equivalent to `approve`, and can be used to
591      * e.g. set automatic allowances for certain subsystems, etc.
592      *
593      * Emits an `Approval` event.
594      *
595      * Requirements:
596      *
597      * - `owner` cannot be the zero address.
598      * - `spender` cannot be the zero address.
599      */
600     function _approve(address owner, address spender, uint256 value) internal {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = value;
605         emit Approval(owner, spender, value);
606     }
607 
608     /**
609      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
610      * from the caller's allowance.
611      *
612      * See `_burn` and `_approve`.
613      */
614     function _burnFrom(address account, uint256 amount) internal {
615         _burn(account, amount);
616         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
617     }
618 }
619 
620 contract BlackListableToken is Ownable, ERC20 {
621 
622     /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
623     function getBlackListStatus(address _maker) external view returns (bool) {
624         return isBlackListed[_maker];
625     }
626 
627     mapping (address => bool) public isBlackListed;
628 
629     function addBlackList(address _evilUser) public onlyOwner {
630         require(!isBlackListed[_evilUser], "_evilUser is already in black list");
631 
632         isBlackListed[_evilUser] = true;
633         emit AddedBlackList(_evilUser);
634     }
635 
636     function removeBlackList(address _clearedUser) public onlyOwner {
637         require(isBlackListed[_clearedUser], "_clearedUser isn't in black list");
638 
639         isBlackListed[_clearedUser] = false;
640         emit RemovedBlackList(_clearedUser);
641     }
642 
643     function destroyBlackFunds(address _blackListedUser) public onlyOwner {
644         require(_blackListedUser != address(0x0), "_blackListedUser is the zero address");
645         require(isBlackListed[_blackListedUser], "_blackListedUser isn't in black list");
646 
647         uint256 dirtyFunds = balanceOf(_blackListedUser);
648         super._burn(_blackListedUser, dirtyFunds);
649         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
650     }
651 
652     event DestroyedBlackFunds(address indexed _blackListedUser, uint256 _balance);
653 
654     event AddedBlackList(address indexed _user);
655 
656     event RemovedBlackList(address indexed _user);
657 
658 }
659 
660 contract UpgradedStandardToken is ERC20 {
661     // those methods are called by the legacy contract
662     // and they must ensure msg.sender to be the contract address
663     function transferByLegacy(address from, address to, uint256 value) public returns (bool);
664     function transferFromByLegacy(address sender, address from, address to, uint256 value) public returns (bool);
665     function approveByLegacy(address owner, address spender, uint256 value) public returns (bool);
666     function increaseAllowanceByLegacy(address owner, address spender, uint256 addedValue) public returns (bool);
667     function decreaseAllowanceByLegacy(address owner, address spender, uint256 subtractedValue) public returns (bool);
668 }
669 
670 contract DZARToken is ERC20, Pausable, BlackListableToken {
671 
672     string public name;
673     string public symbol;
674     uint8 public decimals;
675     address public upgradedAddress;
676     bool public deprecated;
677 
678     //  The contract can be initialized with a number of tokens
679     //  All the tokens are deposited to the owner address
680     //
681     // @param _balance Initial supply of the contract
682     // @param _name Token Name
683     // @param _symbol Token symbol
684     // @param _decimals Token decimals
685     constructor(uint256 _initialSupply, string memory _name, string memory _symbol, uint8 _decimals) public {
686         name = _name;
687         symbol = _symbol;
688         decimals = _decimals;
689         deprecated = false;
690         super._mint(msg.sender, _initialSupply);
691     }
692 
693     // Forward ERC20 methods to upgraded contract if this one is deprecated
694     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
695         require(!isBlackListed[msg.sender], "can't transfer token from address in black list");
696         require(!isBlackListed[_to], "can't transfer token to address in black list");
697         if (deprecated) {
698             success = UpgradedStandardToken(upgradedAddress).transferByLegacy(msg.sender, _to, _value);
699             require(success, "failed to call upgraded contract");
700             return true;
701         } else {
702             return super.transfer(_to, _value);
703         }
704     }
705 
706     // Forward ERC20 methods to upgraded contract if this one is deprecated
707     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
708         require(!isBlackListed[_from], "can't transfer token from address in black list");
709         require(!isBlackListed[_to], "can't transfer token to address in black list");
710         if (deprecated) {
711             success = UpgradedStandardToken(upgradedAddress).transferFromByLegacy(msg.sender, _from, _to, _value);
712             require(success, "failed to call upgraded contract");
713             return true;
714         } else {
715             return super.transferFrom(_from, _to, _value);
716         }
717     }
718 
719     // Forward ERC20 methods to upgraded contract if this one is deprecated
720     function balanceOf(address who) public view returns (uint256) {
721         if (deprecated) {
722             return UpgradedStandardToken(upgradedAddress).balanceOf(who);
723         } else {
724             return super.balanceOf(who);
725         }
726     }
727 
728     // Forward ERC20 methods to upgraded contract if this one is deprecated
729     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
730         if (deprecated) {
731             success = UpgradedStandardToken(upgradedAddress).approveByLegacy(msg.sender, _spender, _value);
732             require(success, "failed to call upgraded contract");
733             return true;
734         } else {
735             return super.approve(_spender, _value);
736         }
737     }
738 
739     // Forward ERC20 methods to upgraded contract if this one is deprecated
740     function increaseAllowance(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
741         if (deprecated) {
742             success = UpgradedStandardToken(upgradedAddress).increaseAllowanceByLegacy(msg.sender, _spender, _addedValue);
743             require(success, "failed to call upgraded contract");
744             return true;
745         } else {
746             return super.increaseAllowance(_spender, _addedValue);
747         }
748     }
749 
750     // Forward ERC20 methods to upgraded contract if this one is deprecated
751     function decreaseAllowance(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
752         if (deprecated) {
753             success = UpgradedStandardToken(upgradedAddress).decreaseAllowanceByLegacy(msg.sender, _spender, _subtractedValue);
754             require(success, "failed to call upgraded contract");
755             return true;
756         } else {
757             return super.decreaseAllowance(_spender, _subtractedValue);
758         }
759     }
760 
761     // Forward ERC20 methods to upgraded contract if this one is deprecated
762     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
763         if (deprecated) {
764             return UpgradedStandardToken(upgradedAddress).allowance(_owner, _spender);
765         } else {
766             return super.allowance(_owner, _spender);
767         }
768     }
769 
770     // deprecate current contract in favour of a new one
771     function deprecate(address _upgradedAddress) public onlyOwner {
772         require(_upgradedAddress != address(0x0), "_upgradedAddress is a zero address");
773         require(!deprecated, "this contract has been deprecated");
774 
775         deprecated = true;
776         upgradedAddress = _upgradedAddress;
777         emit Deprecate(_upgradedAddress);
778     }
779 
780     function totalSupply() public view returns (uint256) {
781         if (deprecated) {
782             return UpgradedStandardToken(upgradedAddress).totalSupply();
783         } else {
784             return super.totalSupply();
785         }
786     }
787 
788     // Issue a new amount of tokens
789     // these tokens are deposited into the owner address
790     //
791     // @param _amount Number of tokens to be issued
792     function issue(uint256 amount) public onlyOwner whenNotPaused {
793         require(!deprecated, "this contract has been deprecated");
794 
795         super._mint(msg.sender, amount);
796         emit Issue(amount);
797     }
798 
799     // Redeem tokens.
800     // These tokens are withdrawn from the owner address
801     // if the balance must be enough to cover the redeem
802     // or the call will fail.
803     // @param _amount Number of tokens to be issued
804     function redeem(uint256 amount) public onlyOwner whenNotPaused {
805         require(!deprecated, "this contract has been deprecated");
806 
807         super._burn(msg.sender, amount);
808         emit Redeem(amount);
809     }
810 
811     // Called when new token are issued
812     event Issue(uint256 amount);
813 
814     // Called when tokens are redeemed
815     event Redeem(uint256 amount);
816 
817     // Called when contract is deprecated
818     event Deprecate(address indexed newAddress);
819 }