1 // File: contracts\openzeppelin-solidity\contracts\GSN\Context.sol
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
21     function _msgSender() internal view returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see `ERC20Detailed`.
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
55      * Emits a `Transfer` event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through `transferFrom`. This is
62      * zero by default.
63      *
64      * This value changes when `approve` or `transferFrom` are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * > Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an `Approval` event.
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
91      * Emits a `Transfer` event.
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
105      * a call to `approve`. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: contracts\openzeppelin-solidity\contracts\math\SafeMath.sol
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
154         require(b <= a, "SafeMath: subtraction overflow");
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Solidity only automatically asserts when dividing by 0
196         require(b > 0, "SafeMath: division by zero");
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         require(b != 0, "SafeMath: modulo by zero");
216         return a % b;
217     }
218 }
219 
220 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
221 
222 pragma solidity ^0.5.0;
223 
224 
225 
226 /**
227  * @dev Implementation of the `IERC20` interface.
228  *
229  * This implementation is agnostic to the way tokens are created. This means
230  * that a supply mechanism has to be added in a derived contract using `_mint`.
231  * For a generic mechanism see `ERC20Mintable`.
232  *
233  * *For a detailed writeup see our guide [How to implement supply
234  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
235  *
236  * We have followed general OpenZeppelin guidelines: functions revert instead
237  * of returning `false` on failure. This behavior is nonetheless conventional
238  * and does not conflict with the expectations of ERC20 applications.
239  *
240  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
241  * This allows applications to reconstruct the allowance for all accounts just
242  * by listening to said events. Other implementations of the EIP may not emit
243  * these events, as it isn't required by the specification.
244  *
245  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
246  * functions have been added to mitigate the well-known issues around setting
247  * allowances. See `IERC20.approve`.
248  */
249 contract ERC20 is IERC20 {
250     using SafeMath for uint256;
251 
252     mapping (address => uint256) private _balances;
253 
254     mapping (address => mapping (address => uint256)) private _allowances;
255 
256     uint256 private _totalSupply;
257 
258     /**
259      * @dev See `IERC20.totalSupply`.
260      */
261     function totalSupply() public view returns (uint256) {
262         return _totalSupply;
263     }
264 
265     /**
266      * @dev See `IERC20.balanceOf`.
267      */
268     function balanceOf(address account) public view returns (uint256) {
269         return _balances[account];
270     }
271 
272     /**
273      * @dev See `IERC20.transfer`.
274      *
275      * Requirements:
276      *
277      * - `recipient` cannot be the zero address.
278      * - the caller must have a balance of at least `amount`.
279      */
280     function transfer(address recipient, uint256 amount) public returns (bool) {
281         _transfer(msg.sender, recipient, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See `IERC20.allowance`.
287      */
288     function allowance(address owner, address spender) public view returns (uint256) {
289         return _allowances[owner][spender];
290     }
291 
292     /**
293      * @dev See `IERC20.approve`.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function approve(address spender, uint256 value) public returns (bool) {
300         _approve(msg.sender, spender, value);
301         return true;
302     }
303 
304     /**
305      * @dev See `IERC20.transferFrom`.
306      *
307      * Emits an `Approval` event indicating the updated allowance. This is not
308      * required by the EIP. See the note at the beginning of `ERC20`;
309      *
310      * Requirements:
311      * - `sender` and `recipient` cannot be the zero address.
312      * - `sender` must have a balance of at least `value`.
313      * - the caller must have allowance for `sender`'s tokens of at least
314      * `amount`.
315      */
316     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
317         _transfer(sender, recipient, amount);
318         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
319         return true;
320     }
321 
322     /**
323      * @dev Atomically increases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to `approve` that can be used as a mitigation for
326      * problems described in `IERC20.approve`.
327      *
328      * Emits an `Approval` event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
335         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
336         return true;
337     }
338 
339     /**
340      * @dev Atomically decreases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to `approve` that can be used as a mitigation for
343      * problems described in `IERC20.approve`.
344      *
345      * Emits an `Approval` event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      * - `spender` must have allowance for the caller of at least
351      * `subtractedValue`.
352      */
353     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
354         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
355         return true;
356     }
357 
358     /**
359      * @dev Moves tokens `amount` from `sender` to `recipient`.
360      *
361      * This is internal function is equivalent to `transfer`, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a `Transfer` event.
365      *
366      * Requirements:
367      *
368      * - `sender` cannot be the zero address.
369      * - `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      */
372     function _transfer(address sender, address recipient, uint256 amount) internal {
373         require(sender != address(0), "ERC20: transfer from the zero address");
374         require(recipient != address(0), "ERC20: transfer to the zero address");
375 
376         _balances[sender] = _balances[sender].sub(amount);
377         _balances[recipient] = _balances[recipient].add(amount);
378         emit Transfer(sender, recipient, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a `Transfer` event with `from` set to the zero address.
385      *
386      * Requirements
387      *
388      * - `to` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _totalSupply = _totalSupply.add(amount);
394         _balances[account] = _balances[account].add(amount);
395         emit Transfer(address(0), account, amount);
396     }
397 
398      /**
399      * @dev Destoys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a `Transfer` event with `to` set to the zero address.
403      *
404      * Requirements
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 value) internal {
410         require(account != address(0), "ERC20: burn from the zero address");
411 
412         _totalSupply = _totalSupply.sub(value);
413         _balances[account] = _balances[account].sub(value);
414         emit Transfer(account, address(0), value);
415     }
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
419      *
420      * This is internal function is equivalent to `approve`, and can be used to
421      * e.g. set automatic allowances for certain subsystems, etc.
422      *
423      * Emits an `Approval` event.
424      *
425      * Requirements:
426      *
427      * - `owner` cannot be the zero address.
428      * - `spender` cannot be the zero address.
429      */
430     function _approve(address owner, address spender, uint256 value) internal {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = value;
435         emit Approval(owner, spender, value);
436     }
437 
438     /**
439      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
440      * from the caller's allowance.
441      *
442      * See `_burn` and `_approve`.
443      */
444     function _burnFrom(address account, uint256 amount) internal {
445         _burn(account, amount);
446         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
447     }
448 }
449 
450 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
451 
452 pragma solidity ^0.5.0;
453 
454 
455 /**
456  * @dev Optional functions from the ERC20 standard.
457  */
458 contract ERC20Detailed is IERC20 {
459     string private _name;
460     string private _symbol;
461     uint8 private _decimals;
462 
463     /**
464      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
465      * these values are immutable: they can only be set once during
466      * construction.
467      */
468     constructor (string memory name, string memory symbol, uint8 decimals) public {
469         _name = name;
470         _symbol = symbol;
471         _decimals = decimals;
472     }
473 
474     /**
475      * @dev Returns the name of the token.
476      */
477     function name() public view returns (string memory) {
478         return _name;
479     }
480 
481     /**
482      * @dev Returns the symbol of the token, usually a shorter version of the
483      * name.
484      */
485     function symbol() public view returns (string memory) {
486         return _symbol;
487     }
488 
489     /**
490      * @dev Returns the number of decimals used to get its user representation.
491      * For example, if `decimals` equals `2`, a balance of `505` tokens should
492      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
493      *
494      * Tokens usually opt for a value of 18, imitating the relationship between
495      * Ether and Wei.
496      *
497      * > Note that this information is only used for _display_ purposes: it in
498      * no way affects any of the arithmetic of the contract, including
499      * `IERC20.balanceOf` and `IERC20.transfer`.
500      */
501     function decimals() public view returns (uint8) {
502         return _decimals;
503     }
504 }
505 
506 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\ERC20Burnable.sol
507 
508 pragma solidity ^0.5.0;
509 
510 
511 /**
512  * @dev Extension of `ERC20` that allows token holders to destroy both their own
513  * tokens and those that they have an allowance for, in a way that can be
514  * recognized off-chain (via event analysis).
515  */
516 contract ERC20Burnable is ERC20 {
517     /**
518      * @dev Destoys `amount` tokens from the caller.
519      *
520      * See `ERC20._burn`.
521      */
522     function burn(uint256 amount) public {
523         _burn(msg.sender, amount);
524     }
525 
526     /**
527      * @dev See `ERC20._burnFrom`.
528      */
529     function burnFrom(address account, uint256 amount) public {
530         _burnFrom(account, amount);
531     }
532 }
533 
534 // File: contracts\openzeppelin-solidity\contracts\access\Roles.sol
535 
536 pragma solidity ^0.5.0;
537 
538 /**
539  * @title Roles
540  * @dev Library for managing addresses assigned to a Role.
541  */
542 library Roles {
543     struct Role {
544         mapping (address => bool) bearer;
545     }
546 
547     /**
548      * @dev Give an account access to this role.
549      */
550     function add(Role storage role, address account) internal {
551         require(!has(role, account), "Roles: account already has role");
552         role.bearer[account] = true;
553     }
554 
555     /**
556      * @dev Remove an account's access to this role.
557      */
558     function remove(Role storage role, address account) internal {
559         require(has(role, account), "Roles: account does not have role");
560         role.bearer[account] = false;
561     }
562 
563     /**
564      * @dev Check if an account has this role.
565      * @return bool
566      */
567     function has(Role storage role, address account) internal view returns (bool) {
568         require(account != address(0), "Roles: account is the zero address");
569         return role.bearer[account];
570     }
571 }
572 
573 // File: contracts\openzeppelin-solidity\contracts\access\roles\MinterRole.sol
574 
575 pragma solidity ^0.5.0;
576 
577 
578 contract MinterRole {
579     using Roles for Roles.Role;
580 
581     event MinterAdded(address indexed account);
582     event MinterRemoved(address indexed account);
583 
584     Roles.Role private _minters;
585 
586     constructor () internal {
587         _addMinter(msg.sender);
588     }
589 
590     modifier onlyMinter() {
591         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
592         _;
593     }
594 
595     function isMinter(address account) public view returns (bool) {
596         return _minters.has(account);
597     }
598 
599     function addMinter(address account) public onlyMinter {
600         _addMinter(account);
601     }
602 
603     function renounceMinter() public {
604         _removeMinter(msg.sender);
605     }
606 
607     function _addMinter(address account) internal {
608         _minters.add(account);
609         emit MinterAdded(account);
610     }
611 
612     function _removeMinter(address account) internal {
613         _minters.remove(account);
614         emit MinterRemoved(account);
615     }
616 }
617 
618 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\ERC20Mintable.sol
619 
620 pragma solidity ^0.5.0;
621 
622 
623 
624 /**
625  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
626  * which have permission to mint (create) new tokens as they see fit.
627  *
628  * At construction, the deployer of the contract is the only minter.
629  */
630 contract ERC20Mintable is ERC20, MinterRole {
631     /**
632      * @dev See `ERC20._mint`.
633      *
634      * Requirements:
635      *
636      * - the caller must have the `MinterRole`.
637      */
638     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
639         _mint(account, amount);
640         return true;
641     }
642 }
643 
644 // File: contracts\openzeppelin-solidity\contracts\access\roles\PauserRole.sol
645 
646 pragma solidity ^0.5.0;
647 
648 
649 contract PauserRole {
650     using Roles for Roles.Role;
651 
652     event PauserAdded(address indexed account);
653     event PauserRemoved(address indexed account);
654 
655     Roles.Role private _pausers;
656 
657     constructor () internal {
658         _addPauser(msg.sender);
659     }
660 
661     modifier onlyPauser() {
662         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
663         _;
664     }
665 
666     function isPauser(address account) public view returns (bool) {
667         return _pausers.has(account);
668     }
669 
670     function addPauser(address account) public onlyPauser {
671         _addPauser(account);
672     }
673 
674     function renouncePauser() public {
675         _removePauser(msg.sender);
676     }
677 
678     function _addPauser(address account) internal {
679         _pausers.add(account);
680         emit PauserAdded(account);
681     }
682 
683     function _removePauser(address account) internal {
684         _pausers.remove(account);
685         emit PauserRemoved(account);
686     }
687 }
688 
689 // File: contracts\openzeppelin-solidity\contracts\lifecycle\Pausable.sol
690 
691 pragma solidity ^0.5.0;
692 
693 
694 /**
695  * @dev Contract module which allows children to implement an emergency stop
696  * mechanism that can be triggered by an authorized account.
697  *
698  * This module is used through inheritance. It will make available the
699  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
700  * the functions of your contract. Note that they will not be pausable by
701  * simply including this module, only once the modifiers are put in place.
702  */
703 contract Pausable is PauserRole {
704     /**
705      * @dev Emitted when the pause is triggered by a pauser (`account`).
706      */
707     event Paused(address account);
708 
709     /**
710      * @dev Emitted when the pause is lifted by a pauser (`account`).
711      */
712     event Unpaused(address account);
713 
714     bool private _paused;
715 
716     /**
717      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
718      * to the deployer.
719      */
720     constructor () internal {
721         _paused = false;
722     }
723 
724     /**
725      * @dev Returns true if the contract is paused, and false otherwise.
726      */
727     function paused() public view returns (bool) {
728         return _paused;
729     }
730 
731     /**
732      * @dev Modifier to make a function callable only when the contract is not paused.
733      */
734     modifier whenNotPaused() {
735         require(!_paused, "Pausable: paused");
736         _;
737     }
738 
739     /**
740      * @dev Modifier to make a function callable only when the contract is paused.
741      */
742     modifier whenPaused() {
743         require(_paused, "Pausable: not paused");
744         _;
745     }
746 
747     /**
748      * @dev Called by a pauser to pause, triggers stopped state.
749      */
750     function pause() public onlyPauser whenNotPaused {
751         _paused = true;
752         emit Paused(msg.sender);
753     }
754 
755     /**
756      * @dev Called by a pauser to unpause, returns to normal state.
757      */
758     function unpause() public onlyPauser whenPaused {
759         _paused = false;
760         emit Unpaused(msg.sender);
761     }
762 }
763 
764 // File: contracts\openzeppelin-solidity\contracts\token\ERC20\ERC20Pausable.sol
765 
766 pragma solidity ^0.5.0;
767 
768 
769 
770 /**
771  * @title Pausable token
772  * @dev ERC20 modified with pausable transfers.
773  */
774 contract ERC20Pausable is ERC20, Pausable {
775     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
776         return super.transfer(to, value);
777     }
778 
779     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
780         return super.transferFrom(from, to, value);
781     }
782 
783     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
784         return super.approve(spender, value);
785     }
786 
787     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
788         return super.increaseAllowance(spender, addedValue);
789     }
790 
791     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
792         return super.decreaseAllowance(spender, subtractedValue);
793     }
794 }
795 
796 // File: contracts\art.sol
797 
798 pragma solidity ^0.5.0;
799 
800 
801 
802 
803 
804 
805 
806 
807 /**
808  * @title ARTCHOICE
809  */
810 contract ARTCHOICE is Context, ERC20, ERC20Detailed,ERC20Burnable, ERC20Mintable,ERC20Pausable {
811 
812     /**
813      * @dev Constructor that gives _msgSender() all of existing tokens.
814      */
815     constructor () public ERC20Detailed("ARTCHOICE", "ATCG", 18) {
816         _mint(_msgSender(), 100000000 * (10 ** uint256(decimals())));
817     }
818 }