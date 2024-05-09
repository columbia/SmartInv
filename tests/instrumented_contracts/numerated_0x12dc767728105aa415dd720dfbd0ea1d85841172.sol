1 pragma solidity ^0.5.8;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
80 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
81 
82 /**
83  * @dev Optional functions from the ERC20 standard.
84  */
85 contract ERC20Detailed is IERC20 {
86     string private _name;
87     string private _symbol;
88     uint8 private _decimals;
89 
90     /**
91      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
92      * these values are immutable: they can only be set once during
93      * construction.
94      */
95     constructor (string memory name, string memory symbol, uint8 decimals) public {
96         _name = name;
97         _symbol = symbol;
98         _decimals = decimals;
99     }
100 
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() public view returns (string memory) {
105         return _name;
106     }
107 
108     /**
109      * @dev Returns the symbol of the token, usually a shorter version of the
110      * name.
111      */
112     function symbol() public view returns (string memory) {
113         return _symbol;
114     }
115 
116     /**
117      * @dev Returns the number of decimals used to get its user representation.
118      * For example, if `decimals` equals `2`, a balance of `505` tokens should
119      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
120      *
121      * Tokens usually opt for a value of 18, imitating the relationship between
122      * Ether and Wei.
123      *
124      * > Note that this information is only used for _display_ purposes: it in
125      * no way affects any of the arithmetic of the contract, including
126      * `IERC20.balanceOf` and `IERC20.transfer`.
127      */
128     function decimals() public view returns (uint8) {
129         return _decimals;
130     }
131 }
132 
133 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations with added overflow
137  * checks.
138  *
139  * Arithmetic operations in Solidity wrap on overflow. This can easily result
140  * in bugs, because programmers usually assume that an overflow raises an
141  * error, which is the standard behavior in high level programming languages.
142  * `SafeMath` restores this intuition by reverting the transaction when an
143  * operation overflows.
144  *
145  * Using this library instead of the unchecked operations eliminates an entire
146  * class of bugs, so it's recommended to use it always.
147  */
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      * - Addition cannot overflow.
157      */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         uint256 c = a + b;
160         require(c >= a, "SafeMath: addition overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175         require(b <= a, "SafeMath: subtraction overflow");
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         // Solidity only automatically asserts when dividing by 0
217         require(b > 0, "SafeMath: division by zero");
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b != 0, "SafeMath: modulo by zero");
237         return a % b;
238     }
239 }
240 
241 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
242 
243 /**
244  * @dev Implementation of the `IERC20` interface.
245  *
246  * This implementation is agnostic to the way tokens are created. This means
247  * that a supply mechanism has to be added in a derived contract using `_mint`.
248  * For a generic mechanism see `ERC20Mintable`.
249  *
250  * *For a detailed writeup see our guide [How to implement supply
251  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
252  *
253  * We have followed general OpenZeppelin guidelines: functions revert instead
254  * of returning `false` on failure. This behavior is nonetheless conventional
255  * and does not conflict with the expectations of ERC20 applications.
256  *
257  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
258  * This allows applications to reconstruct the allowance for all accounts just
259  * by listening to said events. Other implementations of the EIP may not emit
260  * these events, as it isn't required by the specification.
261  *
262  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
263  * functions have been added to mitigate the well-known issues around setting
264  * allowances. See `IERC20.approve`.
265  */
266 contract ERC20 is IERC20 {
267     using SafeMath for uint256;
268 
269     mapping (address => uint256) private _balances;
270 
271     mapping (address => mapping (address => uint256)) private _allowances;
272 
273     uint256 private _totalSupply;
274 
275     /**
276      * @dev See `IERC20.totalSupply`.
277      */
278     function totalSupply() public view returns (uint256) {
279         return _totalSupply;
280     }
281 
282     /**
283      * @dev See `IERC20.balanceOf`.
284      */
285     function balanceOf(address account) public view returns (uint256) {
286         return _balances[account];
287     }
288 
289     /**
290      * @dev See `IERC20.transfer`.
291      *
292      * Requirements:
293      *
294      * - `recipient` cannot be the zero address.
295      * - the caller must have a balance of at least `amount`.
296      */
297     function transfer(address recipient, uint256 amount) public returns (bool) {
298         _transfer(msg.sender, recipient, amount);
299         return true;
300     }
301 
302     /**
303      * @dev See `IERC20.allowance`.
304      */
305     function allowance(address owner, address spender) public view returns (uint256) {
306         return _allowances[owner][spender];
307     }
308 
309     /**
310      * @dev See `IERC20.approve`.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function approve(address spender, uint256 value) public returns (bool) {
317         _approve(msg.sender, spender, value);
318         return true;
319     }
320 
321     /**
322      * @dev See `IERC20.transferFrom`.
323      *
324      * Emits an `Approval` event indicating the updated allowance. This is not
325      * required by the EIP. See the note at the beginning of `ERC20`;
326      *
327      * Requirements:
328      * - `sender` and `recipient` cannot be the zero address.
329      * - `sender` must have a balance of at least `value`.
330      * - the caller must have allowance for `sender`'s tokens of at least
331      * `amount`.
332      */
333     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
334         _transfer(sender, recipient, amount);
335         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
336         return true;
337     }
338 
339     /**
340      * @dev Atomically increases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to `approve` that can be used as a mitigation for
343      * problems described in `IERC20.approve`.
344      *
345      * Emits an `Approval` event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
352         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
353         return true;
354     }
355 
356     /**
357      * @dev Atomically decreases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to `approve` that can be used as a mitigation for
360      * problems described in `IERC20.approve`.
361      *
362      * Emits an `Approval` event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      * - `spender` must have allowance for the caller of at least
368      * `subtractedValue`.
369      */
370     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
371         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
372         return true;
373     }
374 
375     /**
376      * @dev Moves tokens `amount` from `sender` to `recipient`.
377      *
378      * This is internal function is equivalent to `transfer`, and can be used to
379      * e.g. implement automatic token fees, slashing mechanisms, etc.
380      *
381      * Emits a `Transfer` event.
382      *
383      * Requirements:
384      *
385      * - `sender` cannot be the zero address.
386      * - `recipient` cannot be the zero address.
387      * - `sender` must have a balance of at least `amount`.
388      */
389     function _transfer(address sender, address recipient, uint256 amount) internal {
390         require(sender != address(0), "ERC20: transfer from the zero address");
391         require(recipient != address(0), "ERC20: transfer to the zero address");
392 
393         _balances[sender] = _balances[sender].sub(amount);
394         _balances[recipient] = _balances[recipient].add(amount);
395         emit Transfer(sender, recipient, amount);
396     }
397 
398     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
399      * the total supply.
400      *
401      * Emits a `Transfer` event with `from` set to the zero address.
402      *
403      * Requirements
404      *
405      * - `to` cannot be the zero address.
406      */
407     function _mint(address account, uint256 amount) internal {
408         require(account != address(0), "ERC20: mint to the zero address");
409 
410         _totalSupply = _totalSupply.add(amount);
411         _balances[account] = _balances[account].add(amount);
412         emit Transfer(address(0), account, amount);
413     }
414 
415      /**
416      * @dev Destoys `amount` tokens from `account`, reducing the
417      * total supply.
418      *
419      * Emits a `Transfer` event with `to` set to the zero address.
420      *
421      * Requirements
422      *
423      * - `account` cannot be the zero address.
424      * - `account` must have at least `amount` tokens.
425      */
426     function _burn(address account, uint256 value) internal {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _totalSupply = _totalSupply.sub(value);
430         _balances[account] = _balances[account].sub(value);
431         emit Transfer(account, address(0), value);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
436      *
437      * This is internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an `Approval` event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(address owner, address spender, uint256 value) internal {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = value;
452         emit Approval(owner, spender, value);
453     }
454 
455     /**
456      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
457      * from the caller's allowance.
458      *
459      * See `_burn` and `_approve`.
460      */
461     function _burnFrom(address account, uint256 amount) internal {
462         _burn(account, amount);
463         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
464     }
465 }
466 
467 // File: openzeppelin-solidity/contracts/access/Roles.sol
468 
469 /**
470  * @title Roles
471  * @dev Library for managing addresses assigned to a Role.
472  */
473 library Roles {
474     struct Role {
475         mapping (address => bool) bearer;
476     }
477 
478     /**
479      * @dev Give an account access to this role.
480      */
481     function add(Role storage role, address account) internal {
482         require(!has(role, account), "Roles: account already has role");
483         role.bearer[account] = true;
484     }
485 
486     /**
487      * @dev Remove an account's access to this role.
488      */
489     function remove(Role storage role, address account) internal {
490         require(has(role, account), "Roles: account does not have role");
491         role.bearer[account] = false;
492     }
493 
494     /**
495      * @dev Check if an account has this role.
496      * @return bool
497      */
498     function has(Role storage role, address account) internal view returns (bool) {
499         require(account != address(0), "Roles: account is the zero address");
500         return role.bearer[account];
501     }
502 }
503 
504 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
505 
506 contract MinterRole {
507     using Roles for Roles.Role;
508 
509     event MinterAdded(address indexed account);
510     event MinterRemoved(address indexed account);
511 
512     Roles.Role private _minters;
513 
514     constructor () internal {
515         _addMinter(msg.sender);
516     }
517 
518     modifier onlyMinter() {
519         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
520         _;
521     }
522 
523     function isMinter(address account) public view returns (bool) {
524         return _minters.has(account);
525     }
526 
527     function addMinter(address account) public onlyMinter {
528         _addMinter(account);
529     }
530 
531     function renounceMinter() public {
532         _removeMinter(msg.sender);
533     }
534 
535     function _addMinter(address account) internal {
536         _minters.add(account);
537         emit MinterAdded(account);
538     }
539 
540     function _removeMinter(address account) internal {
541         _minters.remove(account);
542         emit MinterRemoved(account);
543     }
544 }
545 
546 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
547 
548 /**
549  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
550  * which have permission to mint (create) new tokens as they see fit.
551  *
552  * At construction, the deployer of the contract is the only minter.
553  */
554 contract ERC20Mintable is ERC20, MinterRole {
555     /**
556      * @dev See `ERC20._mint`.
557      *
558      * Requirements:
559      *
560      * - the caller must have the `MinterRole`.
561      */
562     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
563         _mint(account, amount);
564         return true;
565     }
566 }
567 
568 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
569 
570 /**
571  * @dev Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
572  */
573 contract ERC20Capped is ERC20Mintable {
574     uint256 private _cap;
575 
576     /**
577      * @dev Sets the value of the `cap`. This value is immutable, it can only be
578      * set once during construction.
579      */
580     constructor (uint256 cap) public {
581         require(cap > 0, "ERC20Capped: cap is 0");
582         _cap = cap;
583     }
584 
585     /**
586      * @dev Returns the cap on the token's total supply.
587      */
588     function cap() public view returns (uint256) {
589         return _cap;
590     }
591 
592     /**
593      * @dev See `ERC20Mintable.mint`.
594      *
595      * Requirements:
596      *
597      * - `value` must not cause the total supply to go over the cap.
598      */
599     function _mint(address account, uint256 value) internal {
600         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
601         super._mint(account, value);
602     }
603 }
604 
605 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
606 
607 /**
608  * @dev Extension of `ERC20` that allows token holders to destroy both their own
609  * tokens and those that they have an allowance for, in a way that can be
610  * recognized off-chain (via event analysis).
611  */
612 contract ERC20Burnable is ERC20 {
613     /**
614      * @dev Destoys `amount` tokens from the caller.
615      *
616      * See `ERC20._burn`.
617      */
618     function burn(uint256 amount) public {
619         _burn(msg.sender, amount);
620     }
621 
622     /**
623      * @dev See `ERC20._burnFrom`.
624      */
625     function burnFrom(address account, uint256 amount) public {
626         _burnFrom(account, amount);
627     }
628 }
629 
630 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
631 
632 /**
633  * @dev Contract module which provides a basic access control mechanism, where
634  * there is an account (an owner) that can be granted exclusive access to
635  * specific functions.
636  *
637  * This module is used through inheritance. It will make available the modifier
638  * `onlyOwner`, which can be aplied to your functions to restrict their use to
639  * the owner.
640  */
641 contract Ownable {
642     address private _owner;
643 
644     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
645 
646     /**
647      * @dev Initializes the contract setting the deployer as the initial owner.
648      */
649     constructor () internal {
650         _owner = msg.sender;
651         emit OwnershipTransferred(address(0), _owner);
652     }
653 
654     /**
655      * @dev Returns the address of the current owner.
656      */
657     function owner() public view returns (address) {
658         return _owner;
659     }
660 
661     /**
662      * @dev Throws if called by any account other than the owner.
663      */
664     modifier onlyOwner() {
665         require(isOwner(), "Ownable: caller is not the owner");
666         _;
667     }
668 
669     /**
670      * @dev Returns true if the caller is the current owner.
671      */
672     function isOwner() public view returns (bool) {
673         return msg.sender == _owner;
674     }
675 
676     /**
677      * @dev Leaves the contract without owner. It will not be possible to call
678      * `onlyOwner` functions anymore. Can only be called by the current owner.
679      *
680      * > Note: Renouncing ownership will leave the contract without an owner,
681      * thereby removing any functionality that is only available to the owner.
682      */
683     function renounceOwnership() public onlyOwner {
684         emit OwnershipTransferred(_owner, address(0));
685         _owner = address(0);
686     }
687 
688     /**
689      * @dev Transfers ownership of the contract to a new account (`newOwner`).
690      * Can only be called by the current owner.
691      */
692     function transferOwnership(address newOwner) public onlyOwner {
693         _transferOwnership(newOwner);
694     }
695 
696     /**
697      * @dev Transfers ownership of the contract to a new account (`newOwner`).
698      */
699     function _transferOwnership(address newOwner) internal {
700         require(newOwner != address(0), "Ownable: new owner is the zero address");
701         emit OwnershipTransferred(_owner, newOwner);
702         _owner = newOwner;
703     }
704 }
705 
706 // File: eth-token-recover/contracts/TokenRecover.sol
707 
708 /**
709  * @title TokenRecover
710  * @author Vittorio Minacori (https://github.com/vittominacori)
711  * @dev Allow to recover any ERC20 sent into the contract for error
712  */
713 contract TokenRecover is Ownable {
714 
715     /**
716      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
717      * @param tokenAddress The token contract address
718      * @param tokenAmount Number of tokens to be sent
719      */
720     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
721         IERC20(tokenAddress).transfer(owner(), tokenAmount);
722     }
723 }
724 
725 // File: ico-maker/contracts/access/roles/OperatorRole.sol
726 
727 contract OperatorRole {
728     using Roles for Roles.Role;
729 
730     event OperatorAdded(address indexed account);
731     event OperatorRemoved(address indexed account);
732 
733     Roles.Role private _operators;
734 
735     constructor() internal {
736         _addOperator(msg.sender);
737     }
738 
739     modifier onlyOperator() {
740         require(isOperator(msg.sender));
741         _;
742     }
743 
744     function isOperator(address account) public view returns (bool) {
745         return _operators.has(account);
746     }
747 
748     function addOperator(address account) public onlyOperator {
749         _addOperator(account);
750     }
751 
752     function renounceOperator() public {
753         _removeOperator(msg.sender);
754     }
755 
756     function _addOperator(address account) internal {
757         _operators.add(account);
758         emit OperatorAdded(account);
759     }
760 
761     function _removeOperator(address account) internal {
762         _operators.remove(account);
763         emit OperatorRemoved(account);
764     }
765 }
766 
767 // File: ico-maker/contracts/token/ERC20/BaseERC20Token.sol
768 
769 /**
770  * @title BaseERC20Token
771  * @author Vittorio Minacori (https://github.com/vittominacori)
772  * @dev Implementation of the BaseERC20Token
773  */
774 contract BaseERC20Token is ERC20Detailed, ERC20Capped, ERC20Burnable, OperatorRole, TokenRecover {
775 
776     event MintFinished();
777     event TransferEnabled();
778 
779     // indicates if minting is finished
780     bool private _mintingFinished = false;
781 
782     // indicates if transfer is enabled
783     bool private _transferEnabled = false;
784 
785     /**
786      * @dev Tokens can be minted only before minting finished.
787      */
788     modifier canMint() {
789         require(!_mintingFinished);
790         _;
791     }
792 
793     /**
794      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
795      */
796     modifier canTransfer(address from) {
797         require(_transferEnabled || isOperator(from));
798         _;
799     }
800 
801     /**
802      * @param name Name of the token
803      * @param symbol A symbol to be used as ticker
804      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
805      * @param cap Maximum number of tokens mintable
806      * @param initialSupply Initial token supply
807      */
808     constructor(
809         string memory name,
810         string memory symbol,
811         uint8 decimals,
812         uint256 cap,
813         uint256 initialSupply
814     )
815         public
816         ERC20Detailed(name, symbol, decimals)
817         ERC20Capped(cap)
818     {
819         if (initialSupply > 0) {
820             _mint(owner(), initialSupply);
821         }
822     }
823 
824     /**
825      * @return if minting is finished or not.
826      */
827     function mintingFinished() public view returns (bool) {
828         return _mintingFinished;
829     }
830 
831     /**
832      * @return if transfer is enabled or not.
833      */
834     function transferEnabled() public view returns (bool) {
835         return _transferEnabled;
836     }
837 
838     /**
839      * @dev Function to mint tokens
840      * @param to The address that will receive the minted tokens.
841      * @param value The amount of tokens to mint.
842      * @return A boolean that indicates if the operation was successful.
843      */
844     function mint(address to, uint256 value) public canMint returns (bool) {
845         return super.mint(to, value);
846     }
847 
848     /**
849      * @dev Transfer token to a specified address
850      * @param to The address to transfer to.
851      * @param value The amount to be transferred.
852      * @return A boolean that indicates if the operation was successful.
853      */
854     function transfer(address to, uint256 value) public canTransfer(msg.sender) returns (bool) {
855         return super.transfer(to, value);
856     }
857 
858     /**
859      * @dev Transfer tokens from one address to another.
860      * @param from address The address which you want to send tokens from
861      * @param to address The address which you want to transfer to
862      * @param value uint256 the amount of tokens to be transferred
863      * @return A boolean that indicates if the operation was successful.
864      */
865     function transferFrom(address from, address to, uint256 value) public canTransfer(from) returns (bool) {
866         return super.transferFrom(from, to, value);
867     }
868 
869     /**
870      * @dev Function to stop minting new tokens and enable transfer.
871      */
872     function finishMinting() public onlyOwner canMint {
873         _mintingFinished = true;
874 
875         emit MintFinished();
876     }
877 
878     /**
879    * @dev Function to enable transfers.
880    */
881     function enableTransfer() public onlyOwner {
882         _transferEnabled = true;
883 
884         emit TransferEnabled();
885     }
886 
887     /**
888      * @dev remove the `operator` role from address
889      * @param account Address you want to remove role
890      */
891     function removeOperator(address account) public onlyOwner {
892         _removeOperator(account);
893     }
894 
895     /**
896      * @dev remove the `minter` role from address
897      * @param account Address you want to remove role
898      */
899     function removeMinter(address account) public onlyOwner {
900         _removeMinter(account);
901     }
902 }
903 
904 // File: contracts/ERC20Token.sol
905 
906 /**
907  * @title ERC20Token
908  * @author Vittorio Minacori (https://github.com/vittominacori)
909  * @dev Implementation of a BaseERC20Token
910  */
911 contract ERC20Token is BaseERC20Token {
912 
913     string public builtOn = "https://vittominacori.github.io/erc20-generator";
914 
915     constructor(
916         string memory name,
917         string memory symbol,
918         uint8 decimals,
919         uint256 cap,
920         uint256 initialSupply
921     )
922         public
923         BaseERC20Token(name, symbol, decimals, cap, initialSupply)
924     {} // solhint-disable-line no-empty-blocks
925 }