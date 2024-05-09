1 // File: contracts/openzeppelin-solidity/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/openzeppelin-solidity/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: contracts/openzeppelin-solidity/token/ERC20/ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 
196 /**
197  * @dev Implementation of the `IERC20` interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using `_mint`.
201  * For a generic mechanism see `ERC20Mintable`.
202  *
203  * *For a detailed writeup see our guide [How to implement supply
204  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
205  *
206  * We have followed general OpenZeppelin guidelines: functions revert instead
207  * of returning `false` on failure. This behavior is nonetheless conventional
208  * and does not conflict with the expectations of ERC20 applications.
209  *
210  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See `IERC20.approve`.
218  */
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     /**
229      * @dev See `IERC20.totalSupply`.
230      */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See `IERC20.balanceOf`.
237      */
238     function balanceOf(address account) public view returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See `IERC20.transfer`.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public returns (bool) {
251         _transfer(msg.sender, recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See `IERC20.allowance`.
257      */
258     function allowance(address owner, address spender) public view returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See `IERC20.approve`.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 value) public returns (bool) {
270         _approve(msg.sender, spender, value);
271         return true;
272     }
273 
274     /**
275      * @dev See `IERC20.transferFrom`.
276      *
277      * Emits an `Approval` event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of `ERC20`;
279      *
280      * Requirements:
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `value`.
283      * - the caller must have allowance for `sender`'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to `approve` that can be used as a mitigation for
296      * problems described in `IERC20.approve`.
297      *
298      * Emits an `Approval` event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to `approve` that can be used as a mitigation for
313      * problems described in `IERC20.approve`.
314      *
315      * Emits an `Approval` event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Moves tokens `amount` from `sender` to `recipient`.
330      *
331      * This is internal function is equivalent to `transfer`, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a `Transfer` event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(address sender, address recipient, uint256 amount) internal {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _balances[sender] = _balances[sender].sub(amount);
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a `Transfer` event with `from` set to the zero address.
355      *
356      * Requirements
357      *
358      * - `to` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _totalSupply = _totalSupply.add(amount);
364         _balances[account] = _balances[account].add(amount);
365         emit Transfer(address(0), account, amount);
366     }
367 
368      /**
369      * @dev Destoys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a `Transfer` event with `to` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
389      *
390      * This is internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an `Approval` event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 value) internal {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = value;
405         emit Approval(owner, spender, value);
406     }
407 
408     /**
409      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
410      * from the caller's allowance.
411      *
412      * See `_burn` and `_approve`.
413      */
414     function _burnFrom(address account, uint256 amount) internal {
415         _burn(account, amount);
416         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
417     }
418 }
419 
420 // File: contracts/openzeppelin-solidity/access/Roles.sol
421 
422 pragma solidity ^0.5.0;
423 
424 /**
425  * @title Roles
426  * @dev Library for managing addresses assigned to a Role.
427  */
428 library Roles {
429     struct Role {
430         mapping (address => bool) bearer;
431     }
432 
433     /**
434      * @dev Give an account access to this role.
435      */
436     function add(Role storage role, address account) internal {
437         require(!has(role, account), "Roles: account already has role");
438         role.bearer[account] = true;
439     }
440 
441     /**
442      * @dev Remove an account's access to this role.
443      */
444     function remove(Role storage role, address account) internal {
445         require(has(role, account), "Roles: account does not have role");
446         role.bearer[account] = false;
447     }
448 
449     /**
450      * @dev Check if an account has this role.
451      * @return bool
452      */
453     function has(Role storage role, address account) internal view returns (bool) {
454         require(account != address(0), "Roles: account is the zero address");
455         return role.bearer[account];
456     }
457 }
458 
459 // File: contracts/openzeppelin-solidity/access/roles/MinterRole.sol
460 
461 pragma solidity ^0.5.0;
462 
463 
464 contract MinterRole {
465     using Roles for Roles.Role;
466 
467     event MinterAdded(address indexed account);
468     event MinterRemoved(address indexed account);
469 
470     Roles.Role private _minters;
471 
472     constructor () internal {
473         _addMinter(msg.sender);
474     }
475 
476     modifier onlyMinter() {
477         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
478         _;
479     }
480 
481     function isMinter(address account) public view returns (bool) {
482         return _minters.has(account);
483     }
484 
485     function addMinter(address account) public onlyMinter {
486         _addMinter(account);
487     }
488 
489     function renounceMinter() public {
490         _removeMinter(msg.sender);
491     }
492 
493     function _addMinter(address account) internal {
494         _minters.add(account);
495         emit MinterAdded(account);
496     }
497 
498     function _removeMinter(address account) internal {
499         _minters.remove(account);
500         emit MinterRemoved(account);
501     }
502 }
503 
504 // File: contracts/openzeppelin-solidity/token/ERC20/ERC20Mintable.sol
505 
506 pragma solidity ^0.5.0;
507 
508 
509 
510 /**
511  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
512  * which have permission to mint (create) new tokens as they see fit.
513  *
514  * At construction, the deployer of the contract is the only minter.
515  */
516 contract ERC20Mintable is ERC20, MinterRole {
517     /**
518      * @dev See `ERC20._mint`.
519      *
520      * Requirements:
521      *
522      * - the caller must have the `MinterRole`.
523      */
524     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
525         _mint(account, amount);
526         return true;
527     }
528 }
529 
530 // File: contracts/openzeppelin-solidity/token/ERC20/ERC20Detailed.sol
531 
532 pragma solidity ^0.5.0;
533 
534 
535 /**
536  * @dev Optional functions from the ERC20 standard.
537  */
538 contract ERC20Detailed is IERC20 {
539     string private _name;
540     string private _symbol;
541     uint8 private _decimals;
542 
543     /**
544      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
545      * these values are immutable: they can only be set once during
546      * construction.
547      */
548     constructor (string memory name, string memory symbol, uint8 decimals) public {
549         _name = name;
550         _symbol = symbol;
551         _decimals = decimals;
552     }
553 
554     /**
555      * @dev Returns the name of the token.
556      */
557     function name() public view returns (string memory) {
558         return _name;
559     }
560 
561     /**
562      * @dev Returns the symbol of the token, usually a shorter version of the
563      * name.
564      */
565     function symbol() public view returns (string memory) {
566         return _symbol;
567     }
568 
569     /**
570      * @dev Returns the number of decimals used to get its user representation.
571      * For example, if `decimals` equals `2`, a balance of `505` tokens should
572      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
573      *
574      * Tokens usually opt for a value of 18, imitating the relationship between
575      * Ether and Wei.
576      *
577      * > Note that this information is only used for _display_ purposes: it in
578      * no way affects any of the arithmetic of the contract, including
579      * `IERC20.balanceOf` and `IERC20.transfer`.
580      */
581     function decimals() public view returns (uint8) {
582         return _decimals;
583     }
584 }
585 
586 // File: contracts/openzeppelin-solidity/ownership/Secondary.sol
587 
588 pragma solidity ^0.5.0;
589 
590 /**
591  * @dev A Secondary contract can only be used by its primary account (the one that created it).
592  */
593 contract Secondary {
594     address private _primary;
595 
596     /**
597      * @dev Emitted when the primary contract changes.
598      */
599     event PrimaryTransferred(
600         address recipient
601     );
602 
603     /**
604      * @dev Sets the primary account to the one that is creating the Secondary contract.
605      */
606     constructor () internal {
607         _primary = msg.sender;
608         emit PrimaryTransferred(_primary);
609     }
610 
611     /**
612      * @dev Reverts if called from any account other than the primary.
613      */
614     modifier onlyPrimary() {
615         require(msg.sender == _primary, "Secondary: caller is not the primary account");
616         _;
617     }
618 
619     /**
620      * @return the address of the primary.
621      */
622     function primary() public view returns (address) {
623         return _primary;
624     }
625 
626     /**
627      * @dev Transfers contract to a new primary.
628      * @param recipient The address of new primary.
629      */
630     function transferPrimary(address recipient) public onlyPrimary {
631         require(recipient != address(0), "Secondary: new primary is the zero address");
632         _primary = recipient;
633         emit PrimaryTransferred(_primary);
634     }
635 }
636 
637 // File: contracts/minime/Controlled.sol
638 
639 pragma solidity ^0.5.0;
640 
641 contract Controlled {
642     /// @notice The address of the controller is the only address that can call
643     ///  a function with this modifier
644     modifier onlyController { require(msg.sender == controller, "Controlled: caller is not the controller"); _; }
645 
646     address payable public controller;
647 
648     constructor () public { controller = msg.sender;}
649 
650     /// @notice Changes the controller of the contract
651     /// @param _newController The new controller of the contract
652     function changeController(address payable _newController) public onlyController {
653         controller = _newController;
654     }
655 }
656 
657 // File: contracts/minime/TokenController.sol
658 
659 pragma solidity ^0.5.0;
660 
661 /// @dev The token controller contract must implement these functions
662 contract TokenController {
663     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
664     /// @param _owner The address that sent the ether to create tokens
665     /// @return True if the ether is accepted, false if it throws
666     function proxyPayment(address _owner) public payable returns(bool);
667 
668     /// @notice Notifies the controller about a token transfer allowing the
669     ///  controller to react if desired
670     /// @param _from The origin of the transfer
671     /// @param _to The destination of the transfer
672     /// @param _amount The amount of the transfer
673     /// @return False if the controller does not authorize the transfer
674     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
675 
676     /// @notice Notifies the controller about an approval allowing the
677     ///  controller to react if desired
678     /// @param _owner The address that calls `approve()`
679     /// @param _spender The spender in the `approve()` call
680     /// @param _amount The amount in the `approve()` call
681     /// @return False if the controller does not authorize the approval
682     function onApprove(address _owner, address _spender, uint _amount) public
683         returns(bool);
684 }
685 
686 // File: contracts/minime/MiniMeToken.sol
687 
688 pragma solidity ^0.5.0;
689 
690 /*
691     Copyright 2016, Jordi Baylina
692 
693     This program is free software: you can redistribute it and/or modify
694     it under the terms of the GNU General Public License as published by
695     the Free Software Foundation, either version 3 of the License, or
696     (at your option) any later version.
697 
698     This program is distributed in the hope that it will be useful,
699     but WITHOUT ANY WARRANTY; without even the implied warranty of
700     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
701     GNU General Public License for more details.
702 
703     You should have received a copy of the GNU General Public License
704     along with this program.  If not, see <http://www.gnu.org/licenses/>.
705  */
706 
707 /// @title MiniMeToken Contract
708 /// @author Jordi Baylina
709 /// @dev This token contract's goal is to make it easy for anyone to clone this
710 ///  token using the token distribution at a given block, this will allow DAO's
711 ///  and DApps to upgrade their features in a decentralized manner without
712 ///  affecting the original token
713 /// @dev It is ERC20 compliant, but still needs to under go further testing.
714 
715 
716 
717 contract ApproveAndCallFallBack {
718     function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
719 }
720 
721 /// @dev The actual token contract, the default controller is the msg.sender
722 ///  that deploys the contract, so usually this token will be deployed by a
723 ///  token controller contract, which Giveth will call a "Campaign"
724 contract MiniMeToken is Controlled {
725 
726     string public name;                //The Token's name: e.g. DigixDAO Tokens
727     uint8 public decimals;             //Number of decimals of the smallest unit
728     string public symbol;              //An identifier: e.g. REP
729     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
730 
731 
732     /// @dev `Checkpoint` is the structure that attaches a block number to a
733     ///  given value, the block number attached is the one that last changed the
734     ///  value
735     struct  Checkpoint {
736 
737         // `fromBlock` is the block number that the value was generated from
738         uint128 fromBlock;
739 
740         // `value` is the amount of tokens at a specific block number
741         uint128 value;
742     }
743 
744     // `parentToken` is the Token address that was cloned to produce this token;
745     //  it will be 0x0 for a token that was not cloned
746     MiniMeToken public parentToken;
747 
748     // `parentSnapShotBlock` is the block number from the Parent Token that was
749     //  used to determine the initial distribution of the Clone Token
750     uint public parentSnapShotBlock;
751 
752     // `creationBlock` is the block number that the Clone Token was created
753     uint public creationBlock;
754 
755     // `balances` is the map that tracks the balance of each address, in this
756     //  contract when the balance changes the block number that the change
757     //  occurred is also included in the map
758     mapping (address => Checkpoint[]) balances;
759 
760     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
761     mapping (address => mapping (address => uint256)) allowed;
762 
763     // Tracks the history of the `totalSupply` of the token
764     Checkpoint[] totalSupplyHistory;
765 
766     // Flag that determines if the token is transferable or not.
767     bool public transfersEnabled;
768 
769     // The factory used to create new clone tokens
770     MiniMeTokenFactory public tokenFactory;
771 
772 ////////////////
773 // Constructor
774 ////////////////
775 
776     /// @notice Constructor to create a MiniMeToken
777     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
778     ///  will create the Clone token contracts, the token factory needs to be
779     ///  deployed first
780     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
781     ///  new token
782     /// @param _parentSnapShotBlock Block of the parent token that will
783     ///  determine the initial distribution of the clone token, set to 0 if it
784     ///  is a new token
785     /// @param _tokenName Name of the new token
786     /// @param _decimalUnits Number of decimals of the new token
787     /// @param _tokenSymbol Token Symbol for the new token
788     /// @param _transfersEnabled If true, tokens will be able to be transferred
789     constructor (
790         address _tokenFactory,
791         address payable _parentToken,
792         uint _parentSnapShotBlock,
793         string memory _tokenName,
794         uint8 _decimalUnits,
795         string memory  _tokenSymbol,
796         bool _transfersEnabled
797     ) public {
798         tokenFactory = MiniMeTokenFactory(_tokenFactory);
799         name = _tokenName;                                 // Set the name
800         decimals = _decimalUnits;                          // Set the decimals
801         symbol = _tokenSymbol;                             // Set the symbol
802         parentToken = MiniMeToken(_parentToken);
803         parentSnapShotBlock = _parentSnapShotBlock;
804         transfersEnabled = _transfersEnabled;
805         creationBlock = block.number;
806     }
807 
808 
809 ///////////////////
810 // ERC20 Methods
811 ///////////////////
812 
813     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
814     /// @param _to The address of the recipient
815     /// @param _amount The amount of tokens to be transferred
816     /// @return Whether the transfer was successful or not
817     function transfer(address _to, uint256 _amount) public returns (bool success) {
818         require(transfersEnabled, "MiniMeToken: transfer is not enable");
819         doTransfer(msg.sender, _to, _amount);
820         return true;
821     }
822 
823     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
824     ///  is approved by `_from`
825     /// @param _from The address holding the tokens being transferred
826     /// @param _to The address of the recipient
827     /// @param _amount The amount of tokens to be transferred
828     /// @return True if the transfer was successful
829     function transferFrom(address _from, address _to, uint256 _amount
830     ) public returns (bool success) {
831 
832         // The controller of this contract can move tokens around at will,
833         //  this is important to recognize! Confirm that you trust the
834         //  controller of this contract, which in most situations should be
835         //  another open source smart contract or 0x0
836         if (msg.sender != controller) {
837             require(transfersEnabled, "MiniMeToken: transfer is not enable");
838 
839             // The standard ERC 20 transferFrom functionality
840             require(allowed[_from][msg.sender] >= _amount);
841             allowed[_from][msg.sender] -= _amount;
842         }
843         doTransfer(_from, _to, _amount);
844         return true;
845     }
846 
847     /// @dev This is the actual transfer function in the token contract, it can
848     ///  only be called by other functions in this contract.
849     /// @param _from The address holding the tokens being transferred
850     /// @param _to The address of the recipient
851     /// @param _amount The amount of tokens to be transferred
852     /// @return True if the transfer was successful
853     function doTransfer(address _from, address _to, uint _amount
854     ) internal {
855 
856            if (_amount == 0) {
857                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
858                return;
859            }
860 
861            require(parentSnapShotBlock < block.number);
862 
863            // Do not allow transfer to 0x0 or the token contract itself
864            require((_to != address(0)) && (_to != address(this)));
865 
866            // If the amount being transfered is more than the balance of the
867            //  account the transfer throws
868            uint previousBalanceFrom = balanceOfAt(_from, block.number);
869 
870            require(previousBalanceFrom >= _amount);
871 
872            // Alerts the token controller of the transfer
873            if (isContract(controller)) {
874                require(TokenController(controller).onTransfer(_from, _to, _amount));
875            }
876 
877            // First update the balance array with the new value for the address
878            //  sending the tokens
879            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
880 
881            // Then update the balance array with the new value for the address
882            //  receiving the tokens
883            uint previousBalanceTo = balanceOfAt(_to, block.number);
884            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
885            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
886 
887            // An event to make the transfer easy to find on the blockchain
888            emit Transfer(_from, _to, _amount);
889 
890     }
891 
892     /// @param _owner The address that's balance is being requested
893     /// @return The balance of `_owner` at the current block
894     function balanceOf(address _owner) public view returns (uint256 balance) {
895         return balanceOfAt(_owner, block.number);
896     }
897 
898     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
899     ///  its behalf. This is a modified version of the ERC20 approve function
900     ///  to be a little bit safer
901     /// @param _spender The address of the account able to transfer the tokens
902     /// @param _amount The amount of tokens to be approved for transfer
903     /// @return True if the approval was successful
904     function approve(address _spender, uint256 _amount) public returns (bool success) {
905         require(transfersEnabled, "MiniMeToken: transfer is not enable");
906 
907         // To change the approve amount you first have to reduce the addresses`
908         //  allowance to zero by calling `approve(_spender,0)` if it is not
909         //  already 0 to mitigate the race condition described here:
910         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
911         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
912 
913         // Alerts the token controller of the approve function call
914         if (isContract(controller)) {
915             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
916         }
917 
918         allowed[msg.sender][_spender] = _amount;
919         emit Approval(msg.sender, _spender, _amount);
920         return true;
921     }
922 
923     /// @dev This function makes it easy to read the `allowed[]` map
924     /// @param _owner The address of the account that owns the token
925     /// @param _spender The address of the account able to transfer the tokens
926     /// @return Amount of remaining tokens of _owner that _spender is allowed
927     ///  to spend
928     function allowance(address _owner, address _spender
929     ) public view returns (uint256 remaining) {
930         return allowed[_owner][_spender];
931     }
932 
933     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
934     ///  its behalf, and then a function is triggered in the contract that is
935     ///  being approved, `_spender`. This allows users to use their tokens to
936     ///  interact with contracts in one function call instead of two
937     /// @param _spender The address of the contract able to transfer the tokens
938     /// @param _amount The amount of tokens to be approved for transfer
939     /// @return True if the function call was successful
940     function approveAndCall(address _spender, uint256 _amount, bytes memory _extraData
941     ) public returns (bool success) {
942         require(approve(_spender, _amount));
943 
944         ApproveAndCallFallBack(_spender).receiveApproval(
945             msg.sender,
946             _amount,
947             address(this),
948             _extraData
949         );
950 
951         return true;
952     }
953 
954     /// @dev This function makes it easy to get the total number of tokens
955     /// @return The total number of tokens
956     function totalSupply() public view returns (uint) {
957         return totalSupplyAt(block.number);
958     }
959 
960 
961 ////////////////
962 // Query balance and totalSupply in History
963 ////////////////
964 
965     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
966     /// @param _owner The address from which the balance will be retrieved
967     /// @param _blockNumber The block number when the balance is queried
968     /// @return The balance at `_blockNumber`
969     function balanceOfAt(address _owner, uint _blockNumber) public view
970         returns (uint) {
971 
972         // These next few lines are used when the balance of the token is
973         //  requested before a check point was ever created for this token, it
974         //  requires that the `parentToken.balanceOfAt` be queried at the
975         //  genesis block for that token as this contains initial balance of
976         //  this token
977         if ((balances[_owner].length == 0)
978             || (balances[_owner][0].fromBlock > _blockNumber)) {
979             if (address(parentToken) != address(0)) {
980                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
981             } else {
982                 // Has no parent
983                 return 0;
984             }
985 
986         // This will return the expected balance during normal situations
987         } else {
988             return getValueAt(balances[_owner], _blockNumber);
989         }
990     }
991 
992     /// @notice Total amount of tokens at a specific `_blockNumber`.
993     /// @param _blockNumber The block number when the totalSupply is queried
994     /// @return The total amount of tokens at `_blockNumber`
995     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
996 
997         // These next few lines are used when the totalSupply of the token is
998         //  requested before a check point was ever created for this token, it
999         //  requires that the `parentToken.totalSupplyAt` be queried at the
1000         //  genesis block for this token as that contains totalSupply of this
1001         //  token at this block number.
1002         if ((totalSupplyHistory.length == 0)
1003             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
1004             if (address(parentToken) != address(0)) {
1005                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
1006             } else {
1007                 return 0;
1008             }
1009 
1010         // This will return the expected totalSupply during normal situations
1011         } else {
1012             return getValueAt(totalSupplyHistory, _blockNumber);
1013         }
1014     }
1015 
1016 ////////////////
1017 // Clone Token Method
1018 ////////////////
1019 
1020     /// @notice Creates a new clone token with the initial distribution being
1021     ///  this token at `_snapshotBlock`
1022     /// @param _cloneTokenName Name of the clone token
1023     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
1024     /// @param _cloneTokenSymbol Symbol of the clone token
1025     /// @param _snapshotBlock Block when the distribution of the parent token is
1026     ///  copied to set the initial distribution of the new clone token;
1027     ///  if the block is zero than the actual block, the current block is used
1028     /// @param _transfersEnabled True if transfers are allowed in the clone
1029     /// @return The address of the new MiniMeToken Contract
1030     function createCloneToken(
1031         string memory _cloneTokenName,
1032         uint8 _cloneDecimalUnits,
1033         string memory _cloneTokenSymbol,
1034         uint _snapshotBlock,
1035         bool _transfersEnabled
1036         ) public returns(address) {
1037         if (_snapshotBlock == 0) _snapshotBlock = block.number;
1038         MiniMeToken cloneToken = tokenFactory.createCloneToken(
1039             address(this),
1040             _snapshotBlock,
1041             _cloneTokenName,
1042             _cloneDecimalUnits,
1043             _cloneTokenSymbol,
1044             _transfersEnabled
1045             );
1046 
1047         cloneToken.changeController(msg.sender);
1048 
1049         // An event to make the token easy to find on the blockchain
1050         emit NewCloneToken(address(cloneToken), _snapshotBlock);
1051         return address(cloneToken);
1052     }
1053 
1054 ////////////////
1055 // Generate and destroy tokens
1056 ////////////////
1057 
1058     /// @notice Generates `_amount` tokens that are assigned to `_owner`
1059     /// @param _owner The address that will be assigned the new tokens
1060     /// @param _amount The quantity of tokens generated
1061     /// @return True if the tokens are generated correctly
1062     function generateTokens(address _owner, uint _amount
1063     ) public onlyController returns (bool) {
1064         uint curTotalSupply = totalSupply();
1065         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
1066         uint previousBalanceTo = balanceOf(_owner);
1067         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
1068         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
1069         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
1070         emit Transfer(address(0), _owner, _amount);
1071         return true;
1072     }
1073 
1074 
1075     /// @notice Burns `_amount` tokens from `_owner`
1076     /// @param _owner The address that will lose the tokens
1077     /// @param _amount The quantity of tokens to burn
1078     /// @return True if the tokens are burned correctly
1079     function destroyTokens(address _owner, uint _amount
1080     ) onlyController public returns (bool) {
1081         uint curTotalSupply = totalSupply();
1082         require(curTotalSupply >= _amount);
1083         uint previousBalanceFrom = balanceOf(_owner);
1084         require(previousBalanceFrom >= _amount);
1085         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
1086         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
1087         emit Transfer(_owner, address(0), _amount);
1088         return true;
1089     }
1090 
1091 ////////////////
1092 // Enable tokens transfers
1093 ////////////////
1094 
1095 
1096     /// @notice Enables token holders to transfer their tokens freely if true
1097     /// @param _transfersEnabled True if transfers are allowed in the clone
1098     function enableTransfers(bool _transfersEnabled) public onlyController {
1099         transfersEnabled = _transfersEnabled;
1100     }
1101 
1102 ////////////////
1103 // Internal helper functions to query and set a value in a snapshot array
1104 ////////////////
1105 
1106     /// @dev `getValueAt` retrieves the number of tokens at a given block number
1107     /// @param checkpoints The history of values being queried
1108     /// @param _block The block number to retrieve the value at
1109     /// @return The number of tokens being queried
1110     function getValueAt(Checkpoint[] storage checkpoints, uint _block
1111     ) view internal returns (uint) {
1112         if (checkpoints.length == 0) return 0;
1113 
1114         // Shortcut for the actual value
1115         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
1116             return checkpoints[checkpoints.length-1].value;
1117         if (_block < checkpoints[0].fromBlock) return 0;
1118 
1119         // Binary search of the value in the array
1120         uint min = 0;
1121         uint max = checkpoints.length-1;
1122         while (max > min) {
1123             uint mid = (max + min + 1)/ 2;
1124             if (checkpoints[mid].fromBlock<=_block) {
1125                 min = mid;
1126             } else {
1127                 max = mid-1;
1128             }
1129         }
1130         return checkpoints[min].value;
1131     }
1132 
1133     /// @dev `updateValueAtNow` used to update the `balances` map and the
1134     ///  `totalSupplyHistory`
1135     /// @param checkpoints The history of data being updated
1136     /// @param _value The new number of tokens
1137     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
1138     ) internal  {
1139         if ((checkpoints.length == 0)
1140         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
1141                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
1142                newCheckPoint.fromBlock =  uint128(block.number);
1143                newCheckPoint.value = uint128(_value);
1144            } else {
1145                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
1146                oldCheckPoint.value = uint128(_value);
1147            }
1148     }
1149 
1150     /// @dev Internal function to determine if an address is a contract
1151     /// @param _addr The address being queried
1152     /// @return True if `_addr` is a contract
1153     function isContract(address _addr) view internal returns(bool) {
1154         uint size;
1155         if (_addr == address(0)) return false;
1156         assembly {
1157             size := extcodesize(_addr)
1158         }
1159         return size>0;
1160     }
1161 
1162     /// @dev Helper function to return a min betwen the two uints
1163     function min(uint a, uint b) pure internal returns (uint) {
1164         return a < b ? a : b;
1165     }
1166 
1167     /// @notice The fallback function: If the contract's controller has not been
1168     ///  set to 0, then the `proxyPayment` method is called which relays the
1169     ///  ether and creates tokens as described in the token controller contract
1170     function () external payable {
1171         require(isContract(controller));
1172         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
1173     }
1174 
1175 //////////
1176 // Safety Methods
1177 //////////
1178 
1179     /// @notice This method can be used by the controller to extract mistakenly
1180     ///  sent tokens to this contract.
1181     /// @param _token The address of the token contract that you want to recover
1182     ///  set to 0 in case you want to extract ether.
1183     function claimTokens(address payable _token) public onlyController {
1184         if (_token == address(0)) {
1185             controller.transfer(address(this).balance);
1186             return;
1187         }
1188 
1189         MiniMeToken token = MiniMeToken(_token);
1190         uint balance = token.balanceOf(address(this));
1191         token.transfer(controller, balance);
1192         emit ClaimedTokens(_token, controller, balance);
1193     }
1194 
1195 ////////////////
1196 // Events
1197 ////////////////
1198     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1199     event Transfer(address indexed _from, address indexed _to, uint256 _amount);	
1200     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
1201     event Approval(	
1202         address indexed _owner,	
1203         address indexed _spender,	
1204         uint256 _amount	
1205         );
1206 }
1207 
1208 
1209 ////////////////
1210 // MiniMeTokenFactory
1211 ////////////////
1212 
1213 /// @dev This contract is used to generate clone contracts from a contract.
1214 ///  In solidity this is the way to create a contract from a contract of the
1215 ///  same class
1216 contract MiniMeTokenFactory {
1217 
1218     /// @notice Update the DApp by creating a new token with new functionalities
1219     ///  the msg.sender becomes the controller of this clone token
1220     /// @param _parentToken Address of the token being cloned
1221     /// @param _snapshotBlock Block of the parent token that will
1222     ///  determine the initial distribution of the clone token
1223     /// @param _tokenName Name of the new token
1224     /// @param _decimalUnits Number of decimals of the new token
1225     /// @param _tokenSymbol Token Symbol for the new token
1226     /// @param _transfersEnabled If true, tokens will be able to be transferred
1227     /// @return The address of the new token contract
1228     function createCloneToken(
1229         address payable _parentToken,
1230         uint _snapshotBlock,
1231         string memory _tokenName,
1232         uint8 _decimalUnits,
1233         string memory _tokenSymbol,
1234         bool _transfersEnabled
1235     ) public returns (MiniMeToken) {
1236         MiniMeToken newToken = new MiniMeToken(
1237             address(this),
1238             _parentToken,
1239             _snapshotBlock,
1240             _tokenName,
1241             _decimalUnits,
1242             _tokenSymbol,
1243             _transfersEnabled
1244             );
1245 
1246         newToken.changeController(msg.sender);
1247         return newToken;
1248     }
1249 }
1250 
1251 // File: contracts/VestingToken.sol
1252 
1253 pragma solidity ^0.5.0;
1254 
1255 
1256 
1257 contract VestingToken is MiniMeToken {
1258     using SafeMath for uint256;
1259 
1260     bool private _initiated;
1261 
1262     // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
1263     uint256 private _cliff;
1264     uint256 private _start;
1265     uint256 private _duration;
1266 
1267     mapping (address => uint256) private _released;
1268 
1269     constructor (
1270         address tokenFactory,
1271         address payable parentToken,
1272         uint parentSnapShotBlock,
1273         string memory tokenName,
1274         uint8 decimalUnits,
1275         string memory tokenSymbol,
1276         bool transfersEnabled
1277     )
1278         public
1279         MiniMeToken(tokenFactory, parentToken, parentSnapShotBlock, tokenName, decimalUnits, tokenSymbol, transfersEnabled)
1280     {
1281         // solhint-disable-previous-line no-empty-blocks
1282     }
1283 
1284     modifier beforeInitiated() {
1285         require(!_initiated, "VestingToken: cannot execute after initiation");
1286         _;
1287     }
1288 
1289     modifier afterInitiated() {
1290         require(_initiated, "VestingToken: cannot execute before initiation");
1291         _;
1292     }
1293 
1294     /**
1295      * @dev Returns true if the token can be released, and false otherwise.
1296      */
1297     function initiated() public view returns (bool) {
1298         return _initiated;
1299     }
1300 
1301     /**
1302      * @return the cliff time of the token vesting.
1303      */
1304     function cliff() public view returns (uint256) {
1305         return _cliff;
1306     }
1307 
1308     /**
1309      * @return the start time of the token vesting.
1310      */
1311     function start() public view returns (uint256) {
1312         return _start;
1313     }
1314 
1315     /**
1316      * @return the duration of the token vesting.
1317      */
1318     function duration() public view returns (uint256) {
1319         return _duration;
1320     }
1321 
1322     /**
1323      * @param beneficiary the beneficiary of the tokens.
1324      * @return the amount of the token released.
1325      */
1326     function released(address beneficiary) public view returns (uint256) {
1327         return _released[beneficiary];
1328     }
1329 
1330     /**
1331      * @notice Makes vested tokens releasable.
1332      * @param start the time (as Unix time) at which point vesting starts
1333      * @param cliffDuration duration in seconds of the cliff in which tokens will begin to vest
1334      * @param duration duration in seconds of the period in which the tokens will vest
1335      */
1336     function initiate(uint256 start, uint256 cliffDuration, uint256 duration) public beforeInitiated onlyController {
1337         _initiated = true;
1338 
1339         enableTransfers(false);
1340 
1341         // solhint-disable-next-line max-line-length
1342         require(cliffDuration <= duration, "VestingToken: cliff is longer than duration");
1343         require(duration > 0, "VestingToken: duration is 0");
1344         // solhint-disable-next-line max-line-length
1345         require(start.add(duration) > block.timestamp, "VestingToken: final time is before current time");
1346 
1347         _duration = duration;
1348         _cliff = start.add(cliffDuration);
1349         _start = start;
1350     }
1351 
1352     /**
1353      * @dev This is the actual transfer function in the token contract.
1354      * @param from The address holding the tokens being transferred
1355      * @param to The address of the recipient
1356      * @param amount The amount of tokens to be transferred
1357      */
1358     function doTransfer(address from, address to, uint amount) internal beforeInitiated {
1359         super.doTransfer(from, to, amount);
1360     }
1361 
1362     /**
1363      * @notice Destroys releasable tokens.
1364      * @param beneficiary the beneficiary of the tokens.
1365      */
1366     function destroyReleasableTokens(address beneficiary) public afterInitiated onlyController returns (uint256 unreleased) {
1367         unreleased = releasableAmount(beneficiary);
1368 
1369         require(unreleased > 0, "VestingToken: no tokens are due");
1370 
1371         _released[beneficiary] = _released[beneficiary].add(unreleased);
1372 
1373         require(destroyTokens(beneficiary, unreleased), "VestingToken: failed to destroy tokens");
1374     }
1375 
1376     /**
1377      * @dev Calculates the amount that has already vested but hasn't been released yet.
1378      * @param beneficiary the beneficiary of the tokens.
1379      */
1380     function releasableAmount(address beneficiary) public view returns (uint256) {
1381         return _vestedAmount(beneficiary).sub(_released[beneficiary]);
1382     }
1383 
1384     /**
1385      * @dev Calculates the amount that has already vested.
1386      * @param beneficiary the beneficiary of the tokens.
1387      */
1388     function _vestedAmount(address beneficiary) private view returns (uint256) {
1389         if (!_initiated) {
1390             return 0;
1391         }
1392 
1393         uint256 currentVestedAmount = balanceOf(beneficiary);
1394         uint256 totalVestedAmount = currentVestedAmount.add(_released[beneficiary]);
1395 
1396         if (block.timestamp < _cliff) {
1397             return 0;
1398         } else if (block.timestamp >= _start.add(_duration)) {
1399             return totalVestedAmount;
1400         } else {
1401             return totalVestedAmount.mul(block.timestamp.sub(_start)).div(_duration);
1402         }
1403     }
1404 }
1405 
1406 // File: contracts/TONVault.sol
1407 
1408 pragma solidity ^0.5.0;
1409 
1410 
1411 
1412 
1413 contract TONVault is Secondary {
1414     using SafeMath for uint256;
1415 
1416     ERC20Mintable public ton;
1417 
1418     constructor (ERC20Mintable tonToken) public {
1419         ton = tonToken;
1420     }
1421 
1422     function setApprovalAmount(address approval, uint256 amount) public onlyPrimary {
1423         ton.approve(approval, amount);
1424     }
1425     
1426     function withdraw(uint256 amount, address recipient) public onlyPrimary {
1427         ton.transfer(recipient, amount);
1428     }
1429 }
1430 
1431 // File: contracts/Burner.sol
1432 
1433 pragma solidity ^0.5.0;
1434 
1435 contract Burner {
1436     constructor () public {
1437     }
1438 }
1439 
1440 // File: contracts/SafeMath64.sol
1441 
1442 pragma solidity ^0.5.0;
1443 
1444 // This file was created to support uint64
1445 
1446 /**
1447  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1448  * checks.
1449  *
1450  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1451  * in bugs, because programmers usually assume that an overflow raises an
1452  * error, which is the standard behavior in high level programming languages.
1453  * `SafeMath` restores this intuition by reverting the transaction when an
1454  * operation overflows.
1455  *
1456  * Using this library instead of the unchecked operations eliminates an entire
1457  * class of bugs, so it's recommended to use it always.
1458  */
1459 library SafeMath64 {
1460     /**
1461      * @dev Returns the addition of two unsigned integers, reverting on
1462      * overflow.
1463      *
1464      * Counterpart to Solidity's `+` operator.
1465      *
1466      * Requirements:
1467      * - Addition cannot overflow.
1468      */
1469     function add(uint64 a, uint64 b) internal pure returns (uint64) {
1470         uint64 c = a + b;
1471         require(c >= a, "SafeMath: addition overflow");
1472 
1473         return c;
1474     }
1475 
1476     /**
1477      * @dev Returns the subtraction of two unsigned integers, reverting on
1478      * overflow (when the result is negative).
1479      *
1480      * Counterpart to Solidity's `-` operator.
1481      *
1482      * Requirements:
1483      * - Subtraction cannot overflow.
1484      */
1485     function sub(uint64 a, uint64 b) internal pure returns (uint64) {
1486         require(b <= a, "SafeMath: subtraction overflow");
1487         uint64 c = a - b;
1488 
1489         return c;
1490     }
1491 
1492     /**
1493      * @dev Returns the multiplication of two unsigned integers, reverting on
1494      * overflow.
1495      *
1496      * Counterpart to Solidity's `*` operator.
1497      *
1498      * Requirements:
1499      * - Multiplication cannot overflow.
1500      */
1501     function mul(uint64 a, uint64 b) internal pure returns (uint64) {
1502         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1503         // benefit is lost if 'b' is also tested.
1504         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1505         if (a == 0) {
1506             return 0;
1507         }
1508 
1509         uint64 c = a * b;
1510         require(c / a == b, "SafeMath: multiplication overflow");
1511 
1512         return c;
1513     }
1514 
1515     /**
1516      * @dev Returns the integer division of two unsigned integers. Reverts on
1517      * division by zero. The result is rounded towards zero.
1518      *
1519      * Counterpart to Solidity's `/` operator. Note: this function uses a
1520      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1521      * uses an invalid opcode to revert (consuming all remaining gas).
1522      *
1523      * Requirements:
1524      * - The divisor cannot be zero.
1525      */
1526     function div(uint64 a, uint64 b) internal pure returns (uint64) {
1527         // Solidity only automatically asserts when dividing by 0
1528         require(b > 0, "SafeMath: division by zero");
1529         uint64 c = a / b;
1530         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1531 
1532         return c;
1533     }
1534 
1535     /**
1536      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1537      * Reverts when dividing by zero.
1538      *
1539      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1540      * opcode (which leaves remaining gas untouched) while Solidity uses an
1541      * invalid opcode to revert (consuming all remaining gas).
1542      *
1543      * Requirements:
1544      * - The divisor cannot be zero.
1545      */
1546     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
1547         require(b != 0, "SafeMath: modulo by zero");
1548         return a % b;
1549     }
1550 }
1551 
1552 // File: contracts/VestingSwapper.sol
1553 
1554 pragma solidity ^0.5.0;
1555 
1556 
1557 
1558 
1559 
1560 
1561 
1562 
1563 
1564 
1565 contract VestingSwapper is Secondary {
1566     using SafeMath for uint256;
1567     using SafeMath64 for uint64;
1568 
1569     uint64 public constant UNIT_IN_SECONDS = 60 * 60 * 24 * 30;
1570     address public constant ZERO_ADDRESS = address(0);
1571 
1572     struct BeneficiaryInfo {
1573         uint256 totalAmount; // total deposit amount
1574         uint256 releasedAmount; // released amount
1575     }
1576 
1577     struct VestingInfo {
1578         bool isInitiated;
1579         uint64 ratio;
1580         uint64 start; // start timestamp
1581         uint64 cliff; // cilff timestamp
1582         uint64 firstClaimTimestamp; // the timestamp of the first claim
1583         uint64 durationUnit; // duration unit
1584         uint64 durationInSeconds; // duration in seconds
1585         uint256 firstClaimAmount; // the first claim amount of the VestingToken
1586         uint256 initialTotalSupply; // totalSupply of the VestingToken when initiated
1587     }
1588 
1589     // (VestingToken => (beneficiary => info))
1590     mapping(address => mapping(address => BeneficiaryInfo)) public beneficiaryInfo;
1591 
1592     // VestingToken => info
1593     mapping(address => VestingInfo) public vestingInfo;
1594 
1595     ERC20Mintable public _token;
1596     IERC20 public mton;
1597     TONVault public vault;
1598     address public constant burner = 0x0000000000000000000000000000000000000001; // not deployed yet
1599     uint64 public startTimestamp;
1600     mapping(address => bool) public usingBurnerContracts;
1601 
1602     event Swapped(address account, uint256 unreleased, uint256 transferred);
1603     event Withdrew(address recipient, uint256 amount);
1604     event Deposit(address vestingToken, address from, uint256 amount);
1605     event UpdateRatio(address vestingToken, uint256 tokenRatio);
1606     event SetVault(address vaultAddress);
1607 
1608     modifier beforeInitiated(address vestingToken) {
1609         require(!vestingInfo[vestingToken].isInitiated, "VestingSwapper: cannot execute after initiation");
1610         _;
1611     }
1612 
1613     modifier onlyBeforeStart() {
1614         require(block.timestamp < startTimestamp || startTimestamp == 0, "VestingSwapper: cannot execute after start");
1615         _;
1616     }
1617 
1618     // @param token ton token
1619     constructor (ERC20Mintable token, address mtonAddress) public {
1620         _token = token;
1621         mton = IERC20(mtonAddress);
1622         addUsingBurnerContract(mtonAddress);
1623     }
1624 
1625     // @param vestingToken the address of vesting token
1626     function swap(address payable vestingToken) external returns (bool) {
1627         uint64 ratio = vestingInfo[vestingToken].ratio;
1628         require(ratio != 0, "VestingSwapper: not valid sale token address");
1629 
1630         uint256 unreleased = releasableAmount(vestingToken, msg.sender);
1631         if (unreleased == 0) {
1632             return true;
1633         }
1634         uint256 ton_amount = unreleased.mul(ratio);
1635         require(ton_amount != 0, "VestingSwapper: zero amount to swap"); //
1636         bool success = false;
1637         if (usingBurnerContracts[vestingToken]) {
1638             success = IERC20(vestingToken).transfer(burner, unreleased);
1639         } else {
1640             require(VestingToken(vestingToken).balanceOf(address(this)) >= unreleased, "swap: test error 1");
1641             success = VestingToken(vestingToken).destroyTokens(address(this), unreleased);
1642         }
1643         require(success, "VestingSwapper: failed to destoy token");
1644         success = _token.transferFrom(address(vault), address(this), ton_amount);
1645         require(success, "VestingSwapper: failed to transfer TON from the vault contract");
1646         success = _token.transfer(msg.sender, ton_amount);
1647         require(success, "VestingSwapper: failed to transfer TON to beneficiary");
1648         increaseReleasedAmount(vestingToken, msg.sender, unreleased);
1649         
1650         emit Swapped(msg.sender, unreleased, ton_amount);
1651         return true;
1652     }
1653 
1654     function changeController(VestingToken vestingToken, address payable newController) external onlyPrimary {
1655         vestingToken.changeController(newController);
1656     }
1657 
1658     function setVault(TONVault vaultAddress) external onlyPrimary {
1659         vault = vaultAddress;
1660         emit SetVault(address(vaultAddress));
1661     }
1662 
1663     function setStart(uint64 _startTimestamp) external onlyPrimary {
1664         require(startTimestamp == 0, "VestingSwapper: the starttime is already set");
1665         startTimestamp = _startTimestamp;
1666     }
1667 
1668     // TokenController
1669 
1670     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
1671     /// @param _owner The address that sent the ether to create tokens
1672     /// @return True if the ether is accepted, false if it throws
1673     function proxyPayment(address _owner) public payable returns(bool) {
1674         return true;
1675     }
1676 
1677     /// @notice Notifies the controller about a token transfer allowing the
1678     ///  controller to react if desired
1679     /// @param _from The origin of the transfer
1680     /// @param _to The destination of the transfer
1681     /// @param _amount The amount of the transfer
1682     /// @return False if the controller does not authorize the transfer
1683     function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
1684         return true;
1685     }
1686 
1687     /// @notice Notifies the controller about an approval allowing the
1688     ///  controller to react if desired
1689     /// @param _owner The address that calls `approve()`
1690     /// @param _spender The spender in the `approve()` call
1691     /// @param _amount The amount in the `approve()` call
1692     /// @return False if the controller does not authorize the approval
1693     function onApprove(address _owner, address _spender, uint _amount) public returns(bool) {
1694         return true;
1695     }
1696 
1697     function addUsingBurnerContract(address token) public onlyPrimary {
1698         usingBurnerContracts[token] = true;
1699     }
1700 
1701     function delUsingBurnerContract(address token) public onlyPrimary {
1702         usingBurnerContracts[token] = false;
1703     }
1704 
1705 
1706     function isUsingBurnerContract(address token) public view returns(bool) {
1707         return usingBurnerContracts[token] == true;
1708     }
1709 
1710     //
1711     // init
1712     //
1713 
1714     function receiveApproval(address from, uint256 _amount, address payable _token, bytes memory _data) public {
1715         require(ratio(_token) != 0, "VestingSwapper: not valid sale token address");
1716         VestingToken token = VestingToken(_token);
1717         require(_amount <= token.balanceOf(from), "VestingSwapper: VestingToken amount exceeded");
1718 
1719         bool success = token.transferFrom(from, address(this), _amount);
1720         require(success, "VestingSwapper: transferFrom error");
1721 
1722         add(token, from, _amount);
1723     }
1724 
1725     function add(VestingToken vestingToken, address beneficiary, uint256 amount) internal {
1726         BeneficiaryInfo storage info = beneficiaryInfo[address(vestingToken)][beneficiary];
1727         info.totalAmount = info.totalAmount.add(amount);
1728         emit Deposit(address(vestingToken), beneficiary, amount);
1729     }
1730 
1731     //
1732     // init vesting info
1733     //
1734 
1735     // @notice initiate VestingToken
1736     // @param vestingToken the address of vesting token
1737     // @param start start timestamp
1738     // @param cliffDurationInSeconds cliff duration from start date in seconds
1739     // @param firstClaimDurationInSeconds the first claim duration from start date in seconds
1740     // @param firstClaimAmount the first claim amount of the VestingToken
1741     // @param durationUnit duration unit 
1742     function initiate(address vestingToken, uint64 start, uint64 cliffDurationInSeconds, uint64 firstClaimDurationInSeconds, uint256 firstClaimAmount, uint64 durationUnit) public onlyPrimary beforeInitiated(vestingToken) {
1743         require(cliffDurationInSeconds <= durationUnit.mul(UNIT_IN_SECONDS), "VestingSwapper: cliff is longer than duration");
1744         require(durationUnit != 0, "VestingSwapper: duration is 0");
1745         require(start.add(durationUnit.mul(UNIT_IN_SECONDS)) > block.timestamp, "VestingSwapper: final time is before current time");
1746         require(firstClaimAmount <= IERC20(vestingToken).totalSupply());
1747 
1748         VestingInfo memory info = VestingInfo({
1749             isInitiated: true,
1750             ratio: ratio(vestingToken),
1751             start: start,
1752             cliff: start.add(cliffDurationInSeconds),
1753             firstClaimTimestamp: start.add(firstClaimDurationInSeconds),
1754             firstClaimAmount: firstClaimAmount,
1755             durationUnit: durationUnit,
1756             durationInSeconds: durationUnit.mul(UNIT_IN_SECONDS),
1757             initialTotalSupply: IERC20(vestingToken).totalSupply()
1758         });
1759         vestingInfo[vestingToken] = info;
1760     }
1761 
1762     function updateRatio(address vestingToken, uint64 tokenRatio) external onlyPrimary onlyBeforeStart {
1763         VestingInfo storage info = vestingInfo[vestingToken];
1764         info.ratio = tokenRatio;
1765         emit UpdateRatio(vestingToken, tokenRatio);
1766     }
1767 
1768     // @notice get swapping ratio of VestingToken
1769     // @param vestingToken the address of vesting token
1770     // @param beneficiary the address of beneficiary
1771     // @return the swapping ratio of the token
1772     function ratio(address vestingToken) public view returns (uint64) {
1773         VestingInfo storage info = vestingInfo[vestingToken];
1774         return info.ratio;
1775     }
1776 
1777     //
1778     // get vesting info
1779     //
1780 
1781     function initiated(address vestingToken) public view returns (bool) {
1782         VestingInfo storage info = vestingInfo[vestingToken];
1783         return info.isInitiated;
1784     }
1785 
1786     // @notice get vesting start date
1787     // @param vestingToken the address of vesting token
1788     // @return timestamp of the start date
1789     function start(address vestingToken) public view returns (uint64) {
1790         VestingInfo storage info = vestingInfo[vestingToken];
1791         return info.start;
1792     }
1793 
1794     // @notice get vesting cliff date
1795     // @param vestingToken the address of vesting token
1796     // @return timestamp of the cliff date
1797     function cliff(address vestingToken) public view returns (uint64) {
1798         VestingInfo storage info = vestingInfo[vestingToken];
1799         return info.cliff;
1800     }
1801 
1802     function firstClaim(address vestingToken) public view returns (uint64) {
1803         VestingInfo storage info = vestingInfo[vestingToken];
1804         return info.firstClaimTimestamp;
1805     }
1806 
1807     // @notice get the number of duration unit
1808     // @param vestingToken the address of vesting token
1809     // @return the number of duration unit
1810     function duration(address vestingToken) public view returns (uint64) {
1811         VestingInfo storage info = vestingInfo[vestingToken];
1812         return info.durationUnit;
1813     }
1814 
1815     //
1816     // beneficiary info
1817     //
1818 
1819     // @notice get total deposit amount of VestingToken
1820     // @param vestingToken the address of vesting token
1821     // @param beneficiary the address of beneficiary
1822     // @return the amount of the token deposited
1823     function totalAmount(address vestingToken, address beneficiary) public view returns (uint256) {
1824         return beneficiaryInfo[vestingToken][beneficiary].totalAmount;
1825     }
1826 
1827     // @notice get released(swapped) amount of VestingToken
1828     // @param vestingToken the address of vesting token
1829     // @param beneficiary the address of beneficiary
1830     // @return the amount of the token released
1831     function released(address vestingToken, address beneficiary) public view returns (uint256) {
1832         return beneficiaryInfo[vestingToken][beneficiary].releasedAmount;
1833     }
1834 
1835     // @notice get releasable amount of VestingToken
1836     // @param vestingToken the address of vesting token
1837     // @param beneficiary the address of beneficiary
1838     // @return the releasable amount of the token
1839     function releasableAmount(address vestingToken, address beneficiary) public view returns (uint256) {
1840         uint256 releasedAmount = released(vestingToken, beneficiary);
1841         return _releasableAmountLimit(vestingToken, beneficiary).sub(releasedAmount);
1842     }
1843 
1844     function increaseReleasedAmount(address vestingToken, address beneficiary, uint256 amount) internal {
1845         BeneficiaryInfo storage info = beneficiaryInfo[vestingToken][beneficiary];
1846         info.releasedAmount = info.releasedAmount.add(amount);
1847     }
1848 
1849     function _releasableAmountLimit(address vestingToken, address beneficiary) internal view returns (uint256) {
1850         VestingInfo storage vestingInfo = vestingInfo[vestingToken];
1851 
1852         if (!vestingInfo.isInitiated) {
1853             return 0;
1854         }
1855 
1856         if (block.timestamp < vestingInfo.cliff) {
1857             return 0;
1858         } else if (block.timestamp < vestingInfo.firstClaimTimestamp) {
1859             return firstClaimAmount(vestingToken, beneficiary);
1860         } else if (block.timestamp >= vestingInfo.firstClaimTimestamp.add(vestingInfo.durationInSeconds)) {
1861             return totalAmount(vestingToken, beneficiary);
1862         } else {
1863             uint256 userFirstClaimAmount = firstClaimAmount(vestingToken, beneficiary);
1864             uint256 currenUnit = block.timestamp.sub(vestingInfo.firstClaimTimestamp).div(UNIT_IN_SECONDS).add(1);
1865             uint256 total = totalAmount(vestingToken, beneficiary);
1866             uint256 limit = total.sub(userFirstClaimAmount).mul(currenUnit).div(vestingInfo.durationUnit).add(userFirstClaimAmount);
1867             require(limit <= totalAmount(vestingToken, beneficiary));
1868             return limit;
1869         }
1870     }
1871     
1872     function firstClaimAmount(address vestingToken, address beneficiary) internal view returns (uint256) {
1873         VestingInfo storage vestingInfo = vestingInfo[vestingToken];
1874 
1875         uint256 userTotalAmount = totalAmount(vestingToken, beneficiary);
1876         uint256 tokenTotalAmount = vestingInfo.initialTotalSupply;
1877         return vestingInfo.firstClaimAmount.mul(userTotalAmount).div(tokenTotalAmount);
1878     }
1879 }