1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 
507 /**
508  * @dev Extension of {ERC20} that allows token holders to destroy both their own
509  * tokens and those that they have an allowance for, in a way that can be
510  * recognized off-chain (via event analysis).
511  */
512 contract ERC20Burnable is Context, ERC20 {
513     /**
514      * @dev Destroys `amount` tokens from the caller.
515      *
516      * See {ERC20-_burn}.
517      */
518     function burn(uint256 amount) public {
519         _burn(_msgSender(), amount);
520     }
521 
522     /**
523      * @dev See {ERC20-_burnFrom}.
524      */
525     function burnFrom(address account, uint256 amount) public {
526         _burnFrom(account, amount);
527     }
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
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
577      * NOTE: This information is only used for _display_ purposes: it in
578      * no way affects any of the arithmetic of the contract, including
579      * {IERC20-balanceOf} and {IERC20-transfer}.
580      */
581     function decimals() public view returns (uint8) {
582         return _decimals;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/access/Roles.sol
587 
588 pragma solidity ^0.5.0;
589 
590 /**
591  * @title Roles
592  * @dev Library for managing addresses assigned to a Role.
593  */
594 library Roles {
595     struct Role {
596         mapping (address => bool) bearer;
597     }
598 
599     /**
600      * @dev Give an account access to this role.
601      */
602     function add(Role storage role, address account) internal {
603         require(!has(role, account), "Roles: account already has role");
604         role.bearer[account] = true;
605     }
606 
607     /**
608      * @dev Remove an account's access to this role.
609      */
610     function remove(Role storage role, address account) internal {
611         require(has(role, account), "Roles: account does not have role");
612         role.bearer[account] = false;
613     }
614 
615     /**
616      * @dev Check if an account has this role.
617      * @return bool
618      */
619     function has(Role storage role, address account) internal view returns (bool) {
620         require(account != address(0), "Roles: account is the zero address");
621         return role.bearer[account];
622     }
623 }
624 
625 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
626 
627 pragma solidity ^0.5.0;
628 
629 
630 
631 contract MinterRole is Context {
632     using Roles for Roles.Role;
633 
634     event MinterAdded(address indexed account);
635     event MinterRemoved(address indexed account);
636 
637     Roles.Role private _minters;
638 
639     constructor () internal {
640         _addMinter(_msgSender());
641     }
642 
643     modifier onlyMinter() {
644         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
645         _;
646     }
647 
648     function isMinter(address account) public view returns (bool) {
649         return _minters.has(account);
650     }
651 
652     function addMinter(address account) public onlyMinter {
653         _addMinter(account);
654     }
655 
656     function renounceMinter() public {
657         _removeMinter(_msgSender());
658     }
659 
660     function _addMinter(address account) internal {
661         _minters.add(account);
662         emit MinterAdded(account);
663     }
664 
665     function _removeMinter(address account) internal {
666         _minters.remove(account);
667         emit MinterRemoved(account);
668     }
669 }
670 
671 // File: @openzeppelin/contracts/ownership/Ownable.sol
672 
673 pragma solidity ^0.5.0;
674 
675 /**
676  * @dev Contract module which provides a basic access control mechanism, where
677  * there is an account (an owner) that can be granted exclusive access to
678  * specific functions.
679  *
680  * This module is used through inheritance. It will make available the modifier
681  * `onlyOwner`, which can be applied to your functions to restrict their use to
682  * the owner.
683  */
684 contract Ownable is Context {
685     address private _owner;
686 
687     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
688 
689     /**
690      * @dev Initializes the contract setting the deployer as the initial owner.
691      */
692     constructor () internal {
693         address msgSender = _msgSender();
694         _owner = msgSender;
695         emit OwnershipTransferred(address(0), msgSender);
696     }
697 
698     /**
699      * @dev Returns the address of the current owner.
700      */
701     function owner() public view returns (address) {
702         return _owner;
703     }
704 
705     /**
706      * @dev Throws if called by any account other than the owner.
707      */
708     modifier onlyOwner() {
709         require(isOwner(), "Ownable: caller is not the owner");
710         _;
711     }
712 
713     /**
714      * @dev Returns true if the caller is the current owner.
715      */
716     function isOwner() public view returns (bool) {
717         return _msgSender() == _owner;
718     }
719 
720     /**
721      * @dev Leaves the contract without owner. It will not be possible to call
722      * `onlyOwner` functions anymore. Can only be called by the current owner.
723      *
724      * NOTE: Renouncing ownership will leave the contract without an owner,
725      * thereby removing any functionality that is only available to the owner.
726      */
727     function renounceOwnership() public onlyOwner {
728         emit OwnershipTransferred(_owner, address(0));
729         _owner = address(0);
730     }
731 
732     /**
733      * @dev Transfers ownership of the contract to a new account (`newOwner`).
734      * Can only be called by the current owner.
735      */
736     function transferOwnership(address newOwner) public onlyOwner {
737         _transferOwnership(newOwner);
738     }
739 
740     /**
741      * @dev Transfers ownership of the contract to a new account (`newOwner`).
742      */
743     function _transferOwnership(address newOwner) internal {
744         require(newOwner != address(0), "Ownable: new owner is the zero address");
745         emit OwnershipTransferred(_owner, newOwner);
746         _owner = newOwner;
747     }
748 }
749 
750 // File: contracts/external/Require.sol
751 
752 /*
753     Copyright 2019 dYdX Trading Inc.
754 
755     Licensed under the Apache License, Version 2.0 (the "License");
756     you may not use this file except in compliance with the License.
757     You may obtain a copy of the License at
758 
759     http://www.apache.org/licenses/LICENSE-2.0
760 
761     Unless required by applicable law or agreed to in writing, software
762     distributed under the License is distributed on an "AS IS" BASIS,
763     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
764     See the License for the specific language governing permissions and
765     limitations under the License.
766 */
767 
768 pragma solidity ^0.5.7;
769 
770 /**
771  * @title Require
772  * @author dYdX
773  *
774  * Stringifies parameters to pretty-print revert messages. Costs more gas than regular require()
775  */
776 library Require {
777 
778     // ============ Constants ============
779 
780     uint256 constant ASCII_ZERO = 48; // '0'
781     uint256 constant ASCII_RELATIVE_ZERO = 87; // 'a' - 10
782     uint256 constant ASCII_LOWER_EX = 120; // 'x'
783     bytes2 constant COLON = 0x3a20; // ': '
784     bytes2 constant COMMA = 0x2c20; // ', '
785     bytes2 constant LPAREN = 0x203c; // ' <'
786     byte constant RPAREN = 0x3e; // '>'
787     uint256 constant FOUR_BIT_MASK = 0xf;
788 
789     // ============ Library Functions ============
790 
791     function that(
792         bool must,
793         bytes32 file,
794         bytes32 reason
795     )
796     internal
797     pure
798     {
799         if (!must) {
800             revert(
801                 string(
802                     abi.encodePacked(
803                         stringifyTruncated(file),
804                         COLON,
805                         stringifyTruncated(reason)
806                     )
807                 )
808             );
809         }
810     }
811 
812     function that(
813         bool must,
814         bytes32 file,
815         bytes32 reason,
816         uint256 payloadA
817     )
818     internal
819     pure
820     {
821         if (!must) {
822             revert(
823                 string(
824                     abi.encodePacked(
825                         stringifyTruncated(file),
826                         COLON,
827                         stringifyTruncated(reason),
828                         LPAREN,
829                         stringify(payloadA),
830                         RPAREN
831                     )
832                 )
833             );
834         }
835     }
836 
837     function that(
838         bool must,
839         bytes32 file,
840         bytes32 reason,
841         uint256 payloadA,
842         uint256 payloadB
843     )
844     internal
845     pure
846     {
847         if (!must) {
848             revert(
849                 string(
850                     abi.encodePacked(
851                         stringifyTruncated(file),
852                         COLON,
853                         stringifyTruncated(reason),
854                         LPAREN,
855                         stringify(payloadA),
856                         COMMA,
857                         stringify(payloadB),
858                         RPAREN
859                     )
860                 )
861             );
862         }
863     }
864 
865     function that(
866         bool must,
867         bytes32 file,
868         bytes32 reason,
869         address payloadA
870     )
871     internal
872     pure
873     {
874         if (!must) {
875             revert(
876                 string(
877                     abi.encodePacked(
878                         stringifyTruncated(file),
879                         COLON,
880                         stringifyTruncated(reason),
881                         LPAREN,
882                         stringify(payloadA),
883                         RPAREN
884                     )
885                 )
886             );
887         }
888     }
889 
890     function that(
891         bool must,
892         bytes32 file,
893         bytes32 reason,
894         address payloadA,
895         uint256 payloadB
896     )
897     internal
898     pure
899     {
900         if (!must) {
901             revert(
902                 string(
903                     abi.encodePacked(
904                         stringifyTruncated(file),
905                         COLON,
906                         stringifyTruncated(reason),
907                         LPAREN,
908                         stringify(payloadA),
909                         COMMA,
910                         stringify(payloadB),
911                         RPAREN
912                     )
913                 )
914             );
915         }
916     }
917 
918     function that(
919         bool must,
920         bytes32 file,
921         bytes32 reason,
922         address payloadA,
923         uint256 payloadB,
924         uint256 payloadC
925     )
926     internal
927     pure
928     {
929         if (!must) {
930             revert(
931                 string(
932                     abi.encodePacked(
933                         stringifyTruncated(file),
934                         COLON,
935                         stringifyTruncated(reason),
936                         LPAREN,
937                         stringify(payloadA),
938                         COMMA,
939                         stringify(payloadB),
940                         COMMA,
941                         stringify(payloadC),
942                         RPAREN
943                     )
944                 )
945             );
946         }
947     }
948 
949     function that(
950         bool must,
951         bytes32 file,
952         bytes32 reason,
953         bytes32 payloadA
954     )
955     internal
956     pure
957     {
958         if (!must) {
959             revert(
960                 string(
961                     abi.encodePacked(
962                         stringifyTruncated(file),
963                         COLON,
964                         stringifyTruncated(reason),
965                         LPAREN,
966                         stringify(payloadA),
967                         RPAREN
968                     )
969                 )
970             );
971         }
972     }
973 
974     function that(
975         bool must,
976         bytes32 file,
977         bytes32 reason,
978         bytes32 payloadA,
979         uint256 payloadB,
980         uint256 payloadC
981     )
982     internal
983     pure
984     {
985         if (!must) {
986             revert(
987                 string(
988                     abi.encodePacked(
989                         stringifyTruncated(file),
990                         COLON,
991                         stringifyTruncated(reason),
992                         LPAREN,
993                         stringify(payloadA),
994                         COMMA,
995                         stringify(payloadB),
996                         COMMA,
997                         stringify(payloadC),
998                         RPAREN
999                     )
1000                 )
1001             );
1002         }
1003     }
1004 
1005     // ============ Private Functions ============
1006 
1007     function stringifyTruncated(
1008         bytes32 input
1009     )
1010     private
1011     pure
1012     returns (bytes memory)
1013     {
1014         // put the input bytes into the result
1015         bytes memory result = abi.encodePacked(input);
1016 
1017         // determine the length of the input by finding the location of the last non-zero byte
1018         for (uint256 i = 32; i > 0; ) {
1019             // reverse-for-loops with unsigned integer
1020             /* solium-disable-next-line security/no-modify-for-iter-var */
1021             i--;
1022 
1023             // find the last non-zero byte in order to determine the length
1024             if (result[i] != 0) {
1025                 uint256 length = i + 1;
1026 
1027                 /* solium-disable-next-line security/no-inline-assembly */
1028                 assembly {
1029                     mstore(result, length) // r.length = length;
1030                 }
1031 
1032                 return result;
1033             }
1034         }
1035 
1036         // all bytes are zero
1037         return new bytes(0);
1038     }
1039 
1040     function stringify(
1041         uint256 input
1042     )
1043     private
1044     pure
1045     returns (bytes memory)
1046     {
1047         if (input == 0) {
1048             return "0";
1049         }
1050 
1051         // get the final string length
1052         uint256 j = input;
1053         uint256 length;
1054         while (j != 0) {
1055             length++;
1056             j /= 10;
1057         }
1058 
1059         // allocate the string
1060         bytes memory bstr = new bytes(length);
1061 
1062         // populate the string starting with the least-significant character
1063         j = input;
1064         for (uint256 i = length; i > 0; ) {
1065             // reverse-for-loops with unsigned integer
1066             /* solium-disable-next-line security/no-modify-for-iter-var */
1067             i--;
1068 
1069             // take last decimal digit
1070             bstr[i] = byte(uint8(ASCII_ZERO + (j % 10)));
1071 
1072             // remove the last decimal digit
1073             j /= 10;
1074         }
1075 
1076         return bstr;
1077     }
1078 
1079     function stringify(
1080         address input
1081     )
1082     private
1083     pure
1084     returns (bytes memory)
1085     {
1086         uint256 z = uint256(input);
1087 
1088         // addresses are "0x" followed by 20 bytes of data which take up 2 characters each
1089         bytes memory result = new bytes(42);
1090 
1091         // populate the result with "0x"
1092         result[0] = byte(uint8(ASCII_ZERO));
1093         result[1] = byte(uint8(ASCII_LOWER_EX));
1094 
1095         // for each byte (starting from the lowest byte), populate the result with two characters
1096         for (uint256 i = 0; i < 20; i++) {
1097             // each byte takes two characters
1098             uint256 shift = i * 2;
1099 
1100             // populate the least-significant character
1101             result[41 - shift] = char(z & FOUR_BIT_MASK);
1102             z = z >> 4;
1103 
1104             // populate the most-significant character
1105             result[40 - shift] = char(z & FOUR_BIT_MASK);
1106             z = z >> 4;
1107         }
1108 
1109         return result;
1110     }
1111 
1112     function stringify(
1113         bytes32 input
1114     )
1115     private
1116     pure
1117     returns (bytes memory)
1118     {
1119         uint256 z = uint256(input);
1120 
1121         // bytes32 are "0x" followed by 32 bytes of data which take up 2 characters each
1122         bytes memory result = new bytes(66);
1123 
1124         // populate the result with "0x"
1125         result[0] = byte(uint8(ASCII_ZERO));
1126         result[1] = byte(uint8(ASCII_LOWER_EX));
1127 
1128         // for each byte (starting from the lowest byte), populate the result with two characters
1129         for (uint256 i = 0; i < 32; i++) {
1130             // each byte takes two characters
1131             uint256 shift = i * 2;
1132 
1133             // populate the least-significant character
1134             result[65 - shift] = char(z & FOUR_BIT_MASK);
1135             z = z >> 4;
1136 
1137             // populate the most-significant character
1138             result[64 - shift] = char(z & FOUR_BIT_MASK);
1139             z = z >> 4;
1140         }
1141 
1142         return result;
1143     }
1144 
1145     function char(
1146         uint256 input
1147     )
1148     private
1149     pure
1150     returns (byte)
1151     {
1152         // return ASCII digit (0-9)
1153         if (input < 10) {
1154             return byte(uint8(input + ASCII_ZERO));
1155         }
1156 
1157         // return ASCII letter (a-f)
1158         return byte(uint8(input + ASCII_RELATIVE_ZERO));
1159     }
1160 }
1161 
1162 // File: contracts/external/LibEIP712.sol
1163 
1164 /*
1165     Copyright 2019 ZeroEx Intl.
1166 
1167     Licensed under the Apache License, Version 2.0 (the "License");
1168     you may not use this file except in compliance with the License.
1169     You may obtain a copy of the License at
1170 
1171     http://www.apache.org/licenses/LICENSE-2.0
1172 
1173     Unless required by applicable law or agreed to in writing, software
1174     distributed under the License is distributed on an "AS IS" BASIS,
1175     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1176     See the License for the specific language governing permissions and
1177     limitations under the License.
1178 */
1179 
1180 pragma solidity ^0.5.9;
1181 
1182 
1183 library LibEIP712 {
1184 
1185     // Hash of the EIP712 Domain Separator Schema
1186     // keccak256(abi.encodePacked(
1187     //     "EIP712Domain(",
1188     //     "string name,",
1189     //     "string version,",
1190     //     "uint256 chainId,",
1191     //     "address verifyingContract",
1192     //     ")"
1193     // ))
1194     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
1195 
1196     /// @dev Calculates a EIP712 domain separator.
1197     /// @param name The EIP712 domain name.
1198     /// @param version The EIP712 domain version.
1199     /// @param verifyingContract The EIP712 verifying contract.
1200     /// @return EIP712 domain separator.
1201     function hashEIP712Domain(
1202         string memory name,
1203         string memory version,
1204         uint256 chainId,
1205         address verifyingContract
1206     )
1207     internal
1208     pure
1209     returns (bytes32 result)
1210     {
1211         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
1212 
1213         // Assembly for more efficient computing:
1214         // keccak256(abi.encodePacked(
1215         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1216         //     keccak256(bytes(name)),
1217         //     keccak256(bytes(version)),
1218         //     chainId,
1219         //     uint256(verifyingContract)
1220         // ))
1221 
1222         assembly {
1223         // Calculate hashes of dynamic data
1224             let nameHash := keccak256(add(name, 32), mload(name))
1225             let versionHash := keccak256(add(version, 32), mload(version))
1226 
1227         // Load free memory pointer
1228             let memPtr := mload(64)
1229 
1230         // Store params in memory
1231             mstore(memPtr, schemaHash)
1232             mstore(add(memPtr, 32), nameHash)
1233             mstore(add(memPtr, 64), versionHash)
1234             mstore(add(memPtr, 96), chainId)
1235             mstore(add(memPtr, 128), verifyingContract)
1236 
1237         // Compute hash
1238             result := keccak256(memPtr, 160)
1239         }
1240         return result;
1241     }
1242 
1243     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
1244     /// @param eip712DomainHash Hash of the domain domain separator data, computed
1245     ///                         with getDomainHash().
1246     /// @param hashStruct The EIP712 hash struct.
1247     /// @return EIP712 hash applied to the given EIP712 Domain.
1248     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
1249     internal
1250     pure
1251     returns (bytes32 result)
1252     {
1253         // Assembly for more efficient computing:
1254         // keccak256(abi.encodePacked(
1255         //     EIP191_HEADER,
1256         //     EIP712_DOMAIN_HASH,
1257         //     hashStruct
1258         // ));
1259 
1260         assembly {
1261         // Load free memory pointer
1262             let memPtr := mload(64)
1263 
1264             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1265             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1266             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1267 
1268         // Compute hash
1269             result := keccak256(memPtr, 66)
1270         }
1271         return result;
1272     }
1273 }
1274 
1275 // File: contracts/external/Decimal.sol
1276 
1277 /*
1278     Copyright 2019 dYdX Trading Inc.
1279     Copyright 2020 Exedum <exedum@protonmail.com>
1280 
1281     Licensed under the Apache License, Version 2.0 (the "License");
1282     you may not use this file except in compliance with the License.
1283     You may obtain a copy of the License at
1284 
1285     http://www.apache.org/licenses/LICENSE-2.0
1286 
1287     Unless required by applicable law or agreed to in writing, software
1288     distributed under the License is distributed on an "AS IS" BASIS,
1289     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1290     See the License for the specific language governing permissions and
1291     limitations under the License.
1292 */
1293 
1294 pragma solidity ^0.5.7;
1295 pragma experimental ABIEncoderV2;
1296 
1297 
1298 /**
1299  * @title Decimal
1300  * @author dYdX
1301  *
1302  * Library that defines a fixed-point number with 18 decimal places.
1303  */
1304 library Decimal {
1305     using SafeMath for uint256;
1306 
1307     // ============ Constants ============
1308 
1309     uint256 constant BASE = 10**18;
1310 
1311     // ============ Structs ============
1312 
1313 
1314     struct D256 {
1315         uint256 value;
1316     }
1317 
1318     // ============ Static Functions ============
1319 
1320     function zero()
1321     internal
1322     pure
1323     returns (D256 memory)
1324     {
1325         return D256({ value: 0 });
1326     }
1327 
1328     function one()
1329     internal
1330     pure
1331     returns (D256 memory)
1332     {
1333         return D256({ value: BASE });
1334     }
1335 
1336     function from(
1337         uint256 a
1338     )
1339     internal
1340     pure
1341     returns (D256 memory)
1342     {
1343         return D256({ value: a.mul(BASE) });
1344     }
1345 
1346     function ratio(
1347         uint256 a,
1348         uint256 b
1349     )
1350     internal
1351     pure
1352     returns (D256 memory)
1353     {
1354         return D256({ value: getPartial(a, BASE, b) });
1355     }
1356 
1357     // ============ Self Functions ============
1358 
1359     function add(
1360         D256 memory self,
1361         uint256 b
1362     )
1363     internal
1364     pure
1365     returns (D256 memory)
1366     {
1367         return D256({ value: self.value.add(b.mul(BASE)) });
1368     }
1369 
1370     function sub(
1371         D256 memory self,
1372         uint256 b
1373     )
1374     internal
1375     pure
1376     returns (D256 memory)
1377     {
1378         return D256({ value: self.value.sub(b.mul(BASE)) });
1379     }
1380 
1381     function sub(
1382         D256 memory self,
1383         uint256 b,
1384         string memory reason
1385     )
1386     internal
1387     pure
1388     returns (D256 memory)
1389     {
1390         return D256({ value: self.value.sub(b.mul(BASE), reason) });
1391     }
1392 
1393     function mul(
1394         D256 memory self,
1395         uint256 b
1396     )
1397     internal
1398     pure
1399     returns (D256 memory)
1400     {
1401         return D256({ value: self.value.mul(b) });
1402     }
1403 
1404     function div(
1405         D256 memory self,
1406         uint256 b
1407     )
1408     internal
1409     pure
1410     returns (D256 memory)
1411     {
1412         return D256({ value: self.value.div(b) });
1413     }
1414 
1415     function pow(
1416         D256 memory self,
1417         uint256 b
1418     )
1419     internal
1420     pure
1421     returns (D256 memory)
1422     {
1423         if (b == 0) {
1424             return from(1);
1425         }
1426 
1427         D256 memory temp = D256({ value: self.value });
1428         for (uint256 i = 1; i < b; i++) {
1429             temp = mul(temp, self);
1430         }
1431 
1432         return temp;
1433     }
1434 
1435     function add(
1436         D256 memory self,
1437         D256 memory b
1438     )
1439     internal
1440     pure
1441     returns (D256 memory)
1442     {
1443         return D256({ value: self.value.add(b.value) });
1444     }
1445 
1446     function sub(
1447         D256 memory self,
1448         D256 memory b
1449     )
1450     internal
1451     pure
1452     returns (D256 memory)
1453     {
1454         return D256({ value: self.value.sub(b.value) });
1455     }
1456 
1457     function sub(
1458         D256 memory self,
1459         D256 memory b,
1460         string memory reason
1461     )
1462     internal
1463     pure
1464     returns (D256 memory)
1465     {
1466         return D256({ value: self.value.sub(b.value, reason) });
1467     }
1468 
1469     function mul(
1470         D256 memory self,
1471         D256 memory b
1472     )
1473     internal
1474     pure
1475     returns (D256 memory)
1476     {
1477         return D256({ value: getPartial(self.value, b.value, BASE) });
1478     }
1479 
1480     function div(
1481         D256 memory self,
1482         D256 memory b
1483     )
1484     internal
1485     pure
1486     returns (D256 memory)
1487     {
1488         return D256({ value: getPartial(self.value, BASE, b.value) });
1489     }
1490 
1491     function equals(D256 memory self, D256 memory b) internal pure returns (bool) {
1492         return self.value == b.value;
1493     }
1494 
1495     function greaterThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1496         return compareTo(self, b) == 2;
1497     }
1498 
1499     function lessThan(D256 memory self, D256 memory b) internal pure returns (bool) {
1500         return compareTo(self, b) == 0;
1501     }
1502 
1503     function greaterThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1504         return compareTo(self, b) > 0;
1505     }
1506 
1507     function lessThanOrEqualTo(D256 memory self, D256 memory b) internal pure returns (bool) {
1508         return compareTo(self, b) < 2;
1509     }
1510 
1511     function isZero(D256 memory self) internal pure returns (bool) {
1512         return self.value == 0;
1513     }
1514 
1515     function asUint256(D256 memory self) internal pure returns (uint256) {
1516         return self.value.div(BASE);
1517     }
1518 
1519     // ============ Core Methods ============
1520 
1521     function getPartial(
1522         uint256 target,
1523         uint256 numerator,
1524         uint256 denominator
1525     )
1526     private
1527     pure
1528     returns (uint256)
1529     {
1530         return target.mul(numerator).div(denominator);
1531     }
1532 
1533     function compareTo(
1534         D256 memory a,
1535         D256 memory b
1536     )
1537     private
1538     pure
1539     returns (uint256)
1540     {
1541         if (a.value == b.value) {
1542             return 1;
1543         }
1544         return a.value > b.value ? 2 : 0;
1545     }
1546 }
1547 
1548 // File: contracts/Constants.sol
1549 
1550 pragma solidity ^0.5.17;
1551 
1552 
1553 
1554 library Constants {
1555     /* Chain */
1556     uint256 private constant CHAIN_ID = 1; // Mainnet
1557     // uint256 private constant CHAIN_ID = 42; // Kovan
1558 
1559 
1560     /* Bootstrapping */
1561     uint256 private constant BOOTSTRAPPING_PERIOD = 90;
1562     uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // 1.10 USDC
1563     uint256 private constant BOOTSTRAPPING_SPEEDUP_FACTOR = 3; // 30 days @ 8 hours
1564 
1565     /* Oracle */
1566     address private constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48); // Mainnet
1567     // address private constant USDC = address(0x680B96bD01Ac9e50D1c80Df8Ba832f992e9E8707); // Kovan
1568     uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 USDC
1569 
1570     /* Bonding */
1571     uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 EXED -> 100M EXEDS
1572 
1573     /* Epoch */
1574     struct EpochStrategy {
1575         uint256 offset;
1576         uint256 start;
1577         uint256 period;
1578     }
1579 
1580     uint256 private constant PREVIOUS_EPOCH_OFFSET = 91;
1581     uint256 private constant PREVIOUS_EPOCH_START = 1600905600;
1582     uint256 private constant PREVIOUS_EPOCH_PERIOD = 86400;
1583 
1584     uint256 private constant CURRENT_EPOCH_OFFSET = 0;
1585     uint256 private constant CURRENT_EPOCH_START = 1611563266;
1586     // uint256 private constant CURRENT_EPOCH_PERIOD = 600; // Kovan 10 minutes
1587     uint256 private constant CURRENT_EPOCH_PERIOD = 86400; //Mainnet 24 hours
1588 
1589     /* Governance */
1590     uint256 private constant GOVERNANCE_PERIOD = 9; // 9 epochs
1591     uint256 private constant GOVERNANCE_EXPIRATION = 2; // 2 + 1 epochs
1592     uint256 private constant GOVERNANCE_QUORUM = 20e16; // 20%
1593     uint256 private constant GOVERNANCE_PROPOSAL_THRESHOLD = 5e15; // 0.5%
1594     uint256 private constant GOVERNANCE_SUPER_MAJORITY = 40e16; // 40%
1595     uint256 private constant GOVERNANCE_EMERGENCY_DELAY = 6; // 6 epochs
1596 
1597     /* DAO */
1598     uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 EXED
1599     uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 15; // 15 epochs fluid // Mainnet
1600     // uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 5; // 5 epochs fluid // Kovan
1601 
1602     /* Pool */
1603     uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 5; // 5 epochs fluid
1604 
1605     /* Market */
1606     uint256 private constant COUPON_EXPIRATION = 90;
1607     uint256 private constant DEBT_RATIO_CAP = 20e16; // 20%
1608 
1609     /* Regulator */
1610     uint256 private constant SUPPLY_CHANGE_LIMIT = 3e16; // 3%
1611     uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%
1612     uint256 private constant ORACLE_POOL_RATIO = 20; // 20%
1613 
1614     /**
1615      * Getters
1616      */
1617 
1618     function getUsdcAddress() internal pure returns (address) {
1619         return USDC;
1620     }
1621 
1622     function getOracleReserveMinimum() internal pure returns (uint256) {
1623         return ORACLE_RESERVE_MINIMUM;
1624     }
1625 
1626     function getPreviousEpochStrategy() internal pure returns (EpochStrategy memory) {
1627         return EpochStrategy({
1628             offset: PREVIOUS_EPOCH_OFFSET,
1629             start: PREVIOUS_EPOCH_START,
1630             period: PREVIOUS_EPOCH_PERIOD
1631         });
1632     }
1633 
1634     function getCurrentEpochStrategy() internal pure returns (EpochStrategy memory) {
1635         return EpochStrategy({
1636             offset: CURRENT_EPOCH_OFFSET,
1637             start: CURRENT_EPOCH_START,
1638             period: CURRENT_EPOCH_PERIOD
1639         });
1640     }
1641 
1642     function getInitialStakeMultiple() internal pure returns (uint256) {
1643         return INITIAL_STAKE_MULTIPLE;
1644     }
1645 
1646     function getBootstrappingPeriod() internal pure returns (uint256) {
1647         return BOOTSTRAPPING_PERIOD;
1648     }
1649 
1650     function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
1651         return Decimal.D256({value: BOOTSTRAPPING_PRICE});
1652     }
1653 
1654     function getBootstrappingSpeedupFactor() internal pure returns (uint256) {
1655         return BOOTSTRAPPING_SPEEDUP_FACTOR;
1656     }
1657 
1658     function getGovernancePeriod() internal pure returns (uint256) {
1659         return GOVERNANCE_PERIOD;
1660     }
1661 
1662     function getGovernanceExpiration() internal pure returns (uint256) {
1663         return GOVERNANCE_EXPIRATION;
1664     }
1665 
1666     function getGovernanceQuorum() internal pure returns (Decimal.D256 memory) {
1667         return Decimal.D256({value: GOVERNANCE_QUORUM});
1668     }
1669 
1670     function getGovernanceProposalThreshold() internal pure returns (Decimal.D256 memory) {
1671         return Decimal.D256({value: GOVERNANCE_PROPOSAL_THRESHOLD});
1672     }
1673 
1674     function getGovernanceSuperMajority() internal pure returns (Decimal.D256 memory) {
1675         return Decimal.D256({value: GOVERNANCE_SUPER_MAJORITY});
1676     }
1677 
1678     function getGovernanceEmergencyDelay() internal pure returns (uint256) {
1679         return GOVERNANCE_EMERGENCY_DELAY;
1680     }
1681 
1682     function getAdvanceIncentive() internal pure returns (uint256) {
1683         return ADVANCE_INCENTIVE;
1684     }
1685 
1686     function getDAOExitLockupEpochs() internal pure returns (uint256) {
1687         return DAO_EXIT_LOCKUP_EPOCHS;
1688     }
1689 
1690     function getPoolExitLockupEpochs() internal pure returns (uint256) {
1691         return POOL_EXIT_LOCKUP_EPOCHS;
1692     }
1693 
1694     function getCouponExpiration() internal pure returns (uint256) {
1695         return COUPON_EXPIRATION;
1696     }
1697 
1698     function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
1699         return Decimal.D256({value: DEBT_RATIO_CAP});
1700     }
1701 
1702     function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1703         return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
1704     }
1705 
1706     function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
1707         return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
1708     }
1709 
1710     function getOraclePoolRatio() internal pure returns (uint256) {
1711         return ORACLE_POOL_RATIO;
1712     }
1713 
1714     function getChainId() internal pure returns (uint256) {
1715         return CHAIN_ID;
1716     }
1717 }
1718 
1719 // File: contracts/token/Permittable.sol
1720 
1721 /*
1722     Copyright 2020 Exedum <exedum@protonmail.com>
1723 
1724     Licensed under the Apache License, Version 2.0 (the "License");
1725     you may not use this file except in compliance with the License.
1726     You may obtain a copy of the License at
1727 
1728     http://www.apache.org/licenses/LICENSE-2.0
1729 
1730     Unless required by applicable law or agreed to in writing, software
1731     distributed under the License is distributed on an "AS IS" BASIS,
1732     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1733     See the License for the specific language governing permissions and
1734     limitations under the License.
1735 */
1736 
1737 pragma solidity ^0.5.17;
1738 
1739 
1740 
1741 
1742 
1743 
1744 contract Permittable is ERC20Detailed, ERC20 {
1745     bytes32 constant FILE = "Permittable";
1746 
1747     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1748     bytes32 public constant EIP712_PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1749     string private constant EIP712_VERSION = "1";
1750 
1751     bytes32 public EIP712_DOMAIN_SEPARATOR;
1752 
1753     mapping(address => uint256) nonces;
1754 
1755     constructor() public {
1756         EIP712_DOMAIN_SEPARATOR = LibEIP712.hashEIP712Domain(name(), EIP712_VERSION, Constants.getChainId(), address(this));
1757     }
1758 
1759     function permit(
1760         address owner,
1761         address spender,
1762         uint256 value,
1763         uint256 deadline,
1764         uint8 v,
1765         bytes32 r,
1766         bytes32 s
1767     ) external {
1768         bytes32 digest = LibEIP712.hashEIP712Message(
1769             EIP712_DOMAIN_SEPARATOR,
1770             keccak256(abi.encode(
1771                 EIP712_PERMIT_TYPEHASH,
1772                 owner,
1773                 spender,
1774                 value,
1775                 nonces[owner]++,
1776                 deadline
1777             ))
1778         );
1779 
1780         address recovered = ecrecover(digest, v, r, s);
1781         Require.that(
1782             recovered == owner,
1783             FILE,
1784             "Invalid signature"
1785         );
1786 
1787         Require.that(
1788             recovered != address(0),
1789             FILE,
1790             "Zero address"
1791         );
1792 
1793         Require.that(
1794             now <= deadline,
1795             FILE,
1796             "Expired"
1797         );
1798 
1799         _approve(owner, spender, value);
1800     }
1801 }
1802 
1803 // File: contracts/token/IExedum.sol
1804 
1805 /*
1806     Copyright 2020 Exedum <exedum@protonmail.com>
1807 
1808     Licensed under the Apache License, Version 2.0 (the "License");
1809     you may not use this file except in compliance with the License.
1810     You may obtain a copy of the License at
1811 
1812     http://www.apache.org/licenses/LICENSE-2.0
1813 
1814     Unless required by applicable law or agreed to in writing, software
1815     distributed under the License is distributed on an "AS IS" BASIS,
1816     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1817     See the License for the specific language governing permissions and
1818     limitations under the License.
1819 */
1820 
1821 pragma solidity ^0.5.17;
1822 
1823 
1824 
1825 contract IExedum is IERC20 {
1826     function burn(uint256 amount) public;
1827     function burnFrom(address account, uint256 amount) public;
1828     function mint(address account, uint256 amount) public returns (bool);
1829 }
1830 
1831 // File: contracts/token/Exedum.sol
1832 
1833 pragma solidity ^0.5.17;
1834 
1835 
1836 
1837 
1838 
1839 
1840 
1841 
1842 contract Exedum is IExedum, MinterRole, ERC20Detailed, Permittable, ERC20Burnable, Ownable  {
1843 
1844     address _pool;
1845     uint256 public _fee;
1846     mapping(address => bool) _feeWhiteList;
1847 
1848 
1849     constructor()
1850     ERC20Detailed("Exedum", "EXED", 18)
1851     Permittable()
1852     public
1853     {
1854         _fee = 100; // 1%
1855         transferOwnership(address(0x812dF5d8fB274bc02f7f1231BF4C7540a0780475));
1856     }
1857 
1858     function setPool(address pool) onlyOwner() external {
1859         require(_pool == address(0), "Pool already setted");
1860         _pool = pool;
1861     }
1862 
1863     function addToWhitelist(address wallet) onlyOwner() external {
1864         _feeWhiteList[wallet] = true;
1865     }
1866 
1867     function removeFromWhitelist(address wallet) onlyOwner() external {
1868         _feeWhiteList[wallet] = false;
1869     }
1870 
1871     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1872         _mint(account, amount);
1873         return true;
1874     }
1875 
1876     function _transfer(address sender, address recipient, uint256 amount) internal {
1877         if (_pool == address(0) || _feeWhiteList[recipient] || _feeWhiteList[sender]) {
1878             super._transfer(sender, recipient, amount);
1879         } else {
1880             uint256 feeamount = amount.mul(_fee).div(10000);
1881             uint256 remamount = amount.sub(feeamount);
1882             super._transfer(sender, recipient, remamount);
1883             super._transfer(sender, _pool, feeamount);
1884         }
1885     }
1886 
1887     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1888         _transfer(sender, recipient, amount);
1889         if (allowance(sender, _msgSender()) != uint256(-1)) {
1890             _approve(
1891                 sender,
1892                 _msgSender(),
1893                 allowance(sender, _msgSender()).sub(amount, "Exedum: transfer amount exceeds allowance"));
1894         }
1895         return true;
1896     }
1897 }