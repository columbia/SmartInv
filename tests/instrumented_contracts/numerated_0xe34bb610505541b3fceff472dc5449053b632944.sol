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
501 // File: @openzeppelin/contracts/access/Roles.sol
502 
503 pragma solidity ^0.5.0;
504 
505 /**
506  * @title Roles
507  * @dev Library for managing addresses assigned to a Role.
508  */
509 library Roles {
510     struct Role {
511         mapping (address => bool) bearer;
512     }
513 
514     /**
515      * @dev Give an account access to this role.
516      */
517     function add(Role storage role, address account) internal {
518         require(!has(role, account), "Roles: account already has role");
519         role.bearer[account] = true;
520     }
521 
522     /**
523      * @dev Remove an account's access to this role.
524      */
525     function remove(Role storage role, address account) internal {
526         require(has(role, account), "Roles: account does not have role");
527         role.bearer[account] = false;
528     }
529 
530     /**
531      * @dev Check if an account has this role.
532      * @return bool
533      */
534     function has(Role storage role, address account) internal view returns (bool) {
535         require(account != address(0), "Roles: account is the zero address");
536         return role.bearer[account];
537     }
538 }
539 
540 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
541 
542 pragma solidity ^0.5.0;
543 
544 
545 
546 contract MinterRole is Context {
547     using Roles for Roles.Role;
548 
549     event MinterAdded(address indexed account);
550     event MinterRemoved(address indexed account);
551 
552     Roles.Role private _minters;
553 
554     constructor () internal {
555         _addMinter(_msgSender());
556     }
557 
558     modifier onlyMinter() {
559         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
560         _;
561     }
562 
563     function isMinter(address account) public view returns (bool) {
564         return _minters.has(account);
565     }
566 
567     function addMinter(address account) public onlyMinter {
568         _addMinter(account);
569     }
570 
571     function renounceMinter() public {
572         _removeMinter(_msgSender());
573     }
574 
575     function _addMinter(address account) internal {
576         _minters.add(account);
577         emit MinterAdded(account);
578     }
579 
580     function _removeMinter(address account) internal {
581         _minters.remove(account);
582         emit MinterRemoved(account);
583     }
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 
592 /**
593  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
594  * which have permission to mint (create) new tokens as they see fit.
595  *
596  * At construction, the deployer of the contract is the only minter.
597  */
598 contract ERC20Mintable is ERC20, MinterRole {
599     /**
600      * @dev See {ERC20-_mint}.
601      *
602      * Requirements:
603      *
604      * - the caller must have the {MinterRole}.
605      */
606     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
607         _mint(account, amount);
608         return true;
609     }
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
613 
614 pragma solidity ^0.5.0;
615 
616 
617 /**
618  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
619  */
620 contract ERC20Capped is ERC20Mintable {
621     uint256 private _cap;
622 
623     /**
624      * @dev Sets the value of the `cap`. This value is immutable, it can only be
625      * set once during construction.
626      */
627     constructor (uint256 cap) public {
628         require(cap > 0, "ERC20Capped: cap is 0");
629         _cap = cap;
630     }
631 
632     /**
633      * @dev Returns the cap on the token's total supply.
634      */
635     function cap() public view returns (uint256) {
636         return _cap;
637     }
638 
639     /**
640      * @dev See {ERC20Mintable-mint}.
641      *
642      * Requirements:
643      *
644      * - `value` must not cause the total supply to go over the cap.
645      */
646     function _mint(address account, uint256 value) internal {
647         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
648         super._mint(account, value);
649     }
650 }
651 
652 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
653 
654 pragma solidity ^0.5.0;
655 
656 
657 /**
658  * @dev Optional functions from the ERC20 standard.
659  */
660 contract ERC20Detailed is IERC20 {
661     string private _name;
662     string private _symbol;
663     uint8 private _decimals;
664 
665     /**
666      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
667      * these values are immutable: they can only be set once during
668      * construction.
669      */
670     constructor (string memory name, string memory symbol, uint8 decimals) public {
671         _name = name;
672         _symbol = symbol;
673         _decimals = decimals;
674     }
675 
676     /**
677      * @dev Returns the name of the token.
678      */
679     function name() public view returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev Returns the symbol of the token, usually a shorter version of the
685      * name.
686      */
687     function symbol() public view returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev Returns the number of decimals used to get its user representation.
693      * For example, if `decimals` equals `2`, a balance of `505` tokens should
694      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
695      *
696      * Tokens usually opt for a value of 18, imitating the relationship between
697      * Ether and Wei.
698      *
699      * NOTE: This information is only used for _display_ purposes: it in
700      * no way affects any of the arithmetic of the contract, including
701      * {IERC20-balanceOf} and {IERC20-transfer}.
702      */
703     function decimals() public view returns (uint8) {
704         return _decimals;
705     }
706 }
707 
708 // File: @openzeppelin/contracts/GSN/IRelayRecipient.sol
709 
710 pragma solidity ^0.5.0;
711 
712 /**
713  * @dev Base interface for a contract that will be called via the GSN from {IRelayHub}.
714  *
715  * TIP: You don't need to write an implementation yourself! Inherit from {GSNRecipient} instead.
716  */
717 interface IRelayRecipient {
718     /**
719      * @dev Returns the address of the {IRelayHub} instance this recipient interacts with.
720      */
721     function getHubAddr() external view returns (address);
722 
723     /**
724      * @dev Called by {IRelayHub} to validate if this recipient accepts being charged for a relayed call. Note that the
725      * recipient will be charged regardless of the execution result of the relayed call (i.e. if it reverts or not).
726      *
727      * The relay request was originated by `from` and will be served by `relay`. `encodedFunction` is the relayed call
728      * calldata, so its first four bytes are the function selector. The relayed call will be forwarded `gasLimit` gas,
729      * and the transaction executed with a gas price of at least `gasPrice`. `relay`'s fee is `transactionFee`, and the
730      * recipient will be charged at most `maxPossibleCharge` (in wei). `nonce` is the sender's (`from`) nonce for
731      * replay attack protection in {IRelayHub}, and `approvalData` is a optional parameter that can be used to hold a signature
732      * over all or some of the previous values.
733      *
734      * Returns a tuple, where the first value is used to indicate approval (0) or rejection (custom non-zero error code,
735      * values 1 to 10 are reserved) and the second one is data to be passed to the other {IRelayRecipient} functions.
736      *
737      * {acceptRelayedCall} is called with 50k gas: if it runs out during execution, the request will be considered
738      * rejected. A regular revert will also trigger a rejection.
739      */
740     function acceptRelayedCall(
741         address relay,
742         address from,
743         bytes calldata encodedFunction,
744         uint256 transactionFee,
745         uint256 gasPrice,
746         uint256 gasLimit,
747         uint256 nonce,
748         bytes calldata approvalData,
749         uint256 maxPossibleCharge
750     )
751         external
752         view
753         returns (uint256, bytes memory);
754 
755     /**
756      * @dev Called by {IRelayHub} on approved relay call requests, before the relayed call is executed. This allows to e.g.
757      * pre-charge the sender of the transaction.
758      *
759      * `context` is the second value returned in the tuple by {acceptRelayedCall}.
760      *
761      * Returns a value to be passed to {postRelayedCall}.
762      *
763      * {preRelayedCall} is called with 100k gas: if it runs out during exection or otherwise reverts, the relayed call
764      * will not be executed, but the recipient will still be charged for the transaction's cost.
765      */
766     function preRelayedCall(bytes calldata context) external returns (bytes32);
767 
768     /**
769      * @dev Called by {IRelayHub} on approved relay call requests, after the relayed call is executed. This allows to e.g.
770      * charge the user for the relayed call costs, return any overcharges from {preRelayedCall}, or perform
771      * contract-specific bookkeeping.
772      *
773      * `context` is the second value returned in the tuple by {acceptRelayedCall}. `success` is the execution status of
774      * the relayed call. `actualCharge` is an estimate of how much the recipient will be charged for the transaction,
775      * not including any gas used by {postRelayedCall} itself. `preRetVal` is {preRelayedCall}'s return value.
776      *
777      *
778      * {postRelayedCall} is called with 100k gas: if it runs out during execution or otherwise reverts, the relayed call
779      * and the call to {preRelayedCall} will be reverted retroactively, but the recipient will still be charged for the
780      * transaction's cost.
781      */
782     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external;
783 }
784 
785 // File: @openzeppelin/contracts/GSN/IRelayHub.sol
786 
787 pragma solidity ^0.5.0;
788 
789 /**
790  * @dev Interface for `RelayHub`, the core contract of the GSN. Users should not need to interact with this contract
791  * directly.
792  *
793  * See the https://github.com/OpenZeppelin/openzeppelin-gsn-helpers[OpenZeppelin GSN helpers] for more information on
794  * how to deploy an instance of `RelayHub` on your local test network.
795  */
796 interface IRelayHub {
797     // Relay management
798 
799     /**
800      * @dev Adds stake to a relay and sets its `unstakeDelay`. If the relay does not exist, it is created, and the caller
801      * of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
802      * cannot be its own owner.
803      *
804      * All Ether in this function call will be added to the relay's stake.
805      * Its unstake delay will be assigned to `unstakeDelay`, but the new value must be greater or equal to the current one.
806      *
807      * Emits a {Staked} event.
808      */
809     function stake(address relayaddr, uint256 unstakeDelay) external payable;
810 
811     /**
812      * @dev Emitted when a relay's stake or unstakeDelay are increased
813      */
814     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
815 
816     /**
817      * @dev Registers the caller as a relay.
818      * The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
819      *
820      * This function can be called multiple times, emitting new {RelayAdded} events. Note that the received
821      * `transactionFee` is not enforced by {relayCall}.
822      *
823      * Emits a {RelayAdded} event.
824      */
825     function registerRelay(uint256 transactionFee, string calldata url) external;
826 
827     /**
828      * @dev Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out
829      * {RelayRemoved} events) lets a client discover the list of available relays.
830      */
831     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
832 
833     /**
834      * @dev Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed.
835      *
836      * Can only be called by the owner of the relay. After the relay's `unstakeDelay` has elapsed, {unstake} will be
837      * callable.
838      *
839      * Emits a {RelayRemoved} event.
840      */
841     function removeRelayByOwner(address relay) external;
842 
843     /**
844      * @dev Emitted when a relay is removed (deregistered). `unstakeTime` is the time when unstake will be callable.
845      */
846     event RelayRemoved(address indexed relay, uint256 unstakeTime);
847 
848     /** Deletes the relay from the system, and gives back its stake to the owner.
849      *
850      * Can only be called by the relay owner, after `unstakeDelay` has elapsed since {removeRelayByOwner} was called.
851      *
852      * Emits an {Unstaked} event.
853      */
854     function unstake(address relay) external;
855 
856     /**
857      * @dev Emitted when a relay is unstaked for, including the returned stake.
858      */
859     event Unstaked(address indexed relay, uint256 stake);
860 
861     // States a relay can be in
862     enum RelayState {
863         Unknown, // The relay is unknown to the system: it has never been staked for
864         Staked, // The relay has been staked for, but it is not yet active
865         Registered, // The relay has registered itself, and is active (can relay calls)
866         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
867     }
868 
869     /**
870      * @dev Returns a relay's status. Note that relays can be deleted when unstaked or penalized, causing this function
871      * to return an empty entry.
872      */
873     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
874 
875     // Balance management
876 
877     /**
878      * @dev Deposits Ether for a contract, so that it can receive (and pay for) relayed transactions.
879      *
880      * Unused balance can only be withdrawn by the contract itself, by calling {withdraw}.
881      *
882      * Emits a {Deposited} event.
883      */
884     function depositFor(address target) external payable;
885 
886     /**
887      * @dev Emitted when {depositFor} is called, including the amount and account that was funded.
888      */
889     event Deposited(address indexed recipient, address indexed from, uint256 amount);
890 
891     /**
892      * @dev Returns an account's deposits. These can be either a contracts's funds, or a relay owner's revenue.
893      */
894     function balanceOf(address target) external view returns (uint256);
895 
896     /**
897      * Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
898      * contracts can use it to reduce their funding.
899      *
900      * Emits a {Withdrawn} event.
901      */
902     function withdraw(uint256 amount, address payable dest) external;
903 
904     /**
905      * @dev Emitted when an account withdraws funds from `RelayHub`.
906      */
907     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
908 
909     // Relaying
910 
911     /**
912      * @dev Checks if the `RelayHub` will accept a relayed operation.
913      * Multiple things must be true for this to happen:
914      *  - all arguments must be signed for by the sender (`from`)
915      *  - the sender's nonce must be the current one
916      *  - the recipient must accept this transaction (via {acceptRelayedCall})
917      *
918      * Returns a `PreconditionCheck` value (`OK` when the transaction can be relayed), or a recipient-specific error
919      * code if it returns one in {acceptRelayedCall}.
920      */
921     function canRelay(
922         address relay,
923         address from,
924         address to,
925         bytes calldata encodedFunction,
926         uint256 transactionFee,
927         uint256 gasPrice,
928         uint256 gasLimit,
929         uint256 nonce,
930         bytes calldata signature,
931         bytes calldata approvalData
932     ) external view returns (uint256 status, bytes memory recipientContext);
933 
934     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
935     enum PreconditionCheck {
936         OK,                         // All checks passed, the call can be relayed
937         WrongSignature,             // The transaction to relay is not signed by requested sender
938         WrongNonce,                 // The provided nonce has already been used by the sender
939         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
940         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
941     }
942 
943     /**
944      * @dev Relays a transaction.
945      *
946      * For this to succeed, multiple conditions must be met:
947      *  - {canRelay} must `return PreconditionCheck.OK`
948      *  - the sender must be a registered relay
949      *  - the transaction's gas price must be larger or equal to the one that was requested by the sender
950      *  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
951      * recipient) use all gas available to them
952      *  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
953      * spent)
954      *
955      * If all conditions are met, the call will be relayed and the recipient charged. {preRelayedCall}, the encoded
956      * function and {postRelayedCall} will be called in that order.
957      *
958      * Parameters:
959      *  - `from`: the client originating the request
960      *  - `to`: the target {IRelayRecipient} contract
961      *  - `encodedFunction`: the function call to relay, including data
962      *  - `transactionFee`: fee (%) the relay takes over actual gas cost
963      *  - `gasPrice`: gas price the client is willing to pay
964      *  - `gasLimit`: gas to forward when calling the encoded function
965      *  - `nonce`: client's nonce
966      *  - `signature`: client's signature over all previous params, plus the relay and RelayHub addresses
967      *  - `approvalData`: dapp-specific data forwared to {acceptRelayedCall}. This value is *not* verified by the
968      * `RelayHub`, but it still can be used for e.g. a signature.
969      *
970      * Emits a {TransactionRelayed} event.
971      */
972     function relayCall(
973         address from,
974         address to,
975         bytes calldata encodedFunction,
976         uint256 transactionFee,
977         uint256 gasPrice,
978         uint256 gasLimit,
979         uint256 nonce,
980         bytes calldata signature,
981         bytes calldata approvalData
982     ) external;
983 
984     /**
985      * @dev Emitted when an attempt to relay a call failed.
986      *
987      * This can happen due to incorrect {relayCall} arguments, or the recipient not accepting the relayed call. The
988      * actual relayed call was not executed, and the recipient not charged.
989      *
990      * The `reason` parameter contains an error code: values 1-10 correspond to `PreconditionCheck` entries, and values
991      * over 10 are custom recipient error codes returned from {acceptRelayedCall}.
992      */
993     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
994 
995     /**
996      * @dev Emitted when a transaction is relayed. 
997      * Useful when monitoring a relay's operation and relayed calls to a contract
998      *
999      * Note that the actual encoded function might be reverted: this is indicated in the `status` parameter.
1000      *
1001      * `charge` is the Ether value deducted from the recipient's balance, paid to the relay's owner.
1002      */
1003     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
1004 
1005     // Reason error codes for the TransactionRelayed event
1006     enum RelayCallStatus {
1007         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
1008         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
1009         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
1010         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
1011         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
1012     }
1013 
1014     /**
1015      * @dev Returns how much gas should be forwarded to a call to {relayCall}, in order to relay a transaction that will
1016      * spend up to `relayedCallStipend` gas.
1017      */
1018     function requiredGas(uint256 relayedCallStipend) external view returns (uint256);
1019 
1020     /**
1021      * @dev Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
1022      */
1023     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) external view returns (uint256);
1024 
1025      // Relay penalization. 
1026      // Any account can penalize relays, removing them from the system immediately, and rewarding the
1027     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
1028     // still loses half of its stake.
1029 
1030     /**
1031      * @dev Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
1032      * different data (gas price, gas limit, etc. may be different).
1033      *
1034      * The (unsigned) transaction data and signature for both transactions must be provided.
1035      */
1036     function penalizeRepeatedNonce(bytes calldata unsignedTx1, bytes calldata signature1, bytes calldata unsignedTx2, bytes calldata signature2) external;
1037 
1038     /**
1039      * @dev Penalize a relay that sent a transaction that didn't target `RelayHub`'s {registerRelay} or {relayCall}.
1040      */
1041     function penalizeIllegalTransaction(bytes calldata unsignedTx, bytes calldata signature) external;
1042 
1043     /**
1044      * @dev Emitted when a relay is penalized.
1045      */
1046     event Penalized(address indexed relay, address sender, uint256 amount);
1047 
1048     /**
1049      * @dev Returns an account's nonce in `RelayHub`.
1050      */
1051     function getNonce(address from) external view returns (uint256);
1052 }
1053 
1054 // File: @openzeppelin/contracts/GSN/GSNRecipient.sol
1055 
1056 pragma solidity ^0.5.0;
1057 
1058 
1059 
1060 
1061 /**
1062  * @dev Base GSN recipient contract: includes the {IRelayRecipient} interface
1063  * and enables GSN support on all contracts in the inheritance tree.
1064  *
1065  * TIP: This contract is abstract. The functions {IRelayRecipient-acceptRelayedCall},
1066  *  {_preRelayedCall}, and {_postRelayedCall} are not implemented and must be
1067  * provided by derived contracts. See the
1068  * xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategies] for more
1069  * information on how to use the pre-built {GSNRecipientSignature} and
1070  * {GSNRecipientERC20Fee}, or how to write your own.
1071  */
1072 contract GSNRecipient is IRelayRecipient, Context {
1073     // Default RelayHub address, deployed on mainnet and all testnets at the same address
1074     address private _relayHub = 0xD216153c06E857cD7f72665E0aF1d7D82172F494;
1075 
1076     uint256 constant private RELAYED_CALL_ACCEPTED = 0;
1077     uint256 constant private RELAYED_CALL_REJECTED = 11;
1078 
1079     // How much gas is forwarded to postRelayedCall
1080     uint256 constant internal POST_RELAYED_CALL_MAX_GAS = 100000;
1081 
1082     /**
1083      * @dev Emitted when a contract changes its {IRelayHub} contract to a new one.
1084      */
1085     event RelayHubChanged(address indexed oldRelayHub, address indexed newRelayHub);
1086 
1087     /**
1088      * @dev Returns the address of the {IRelayHub} contract for this recipient.
1089      */
1090     function getHubAddr() public view returns (address) {
1091         return _relayHub;
1092     }
1093 
1094     /**
1095      * @dev Switches to a new {IRelayHub} instance. This method is added for future-proofing: there's no reason to not
1096      * use the default instance.
1097      *
1098      * IMPORTANT: After upgrading, the {GSNRecipient} will no longer be able to receive relayed calls from the old
1099      * {IRelayHub} instance. Additionally, all funds should be previously withdrawn via {_withdrawDeposits}.
1100      */
1101     function _upgradeRelayHub(address newRelayHub) internal {
1102         address currentRelayHub = _relayHub;
1103         require(newRelayHub != address(0), "GSNRecipient: new RelayHub is the zero address");
1104         require(newRelayHub != currentRelayHub, "GSNRecipient: new RelayHub is the current one");
1105 
1106         emit RelayHubChanged(currentRelayHub, newRelayHub);
1107 
1108         _relayHub = newRelayHub;
1109     }
1110 
1111     /**
1112      * @dev Returns the version string of the {IRelayHub} for which this recipient implementation was built. If
1113      * {_upgradeRelayHub} is used, the new {IRelayHub} instance should be compatible with this version.
1114      */
1115     // This function is view for future-proofing, it may require reading from
1116     // storage in the future.
1117     function relayHubVersion() public view returns (string memory) {
1118         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1119         return "1.0.0";
1120     }
1121 
1122     /**
1123      * @dev Withdraws the recipient's deposits in `RelayHub`.
1124      *
1125      * Derived contracts should expose this in an external interface with proper access control.
1126      */
1127     function _withdrawDeposits(uint256 amount, address payable payee) internal {
1128         IRelayHub(_relayHub).withdraw(amount, payee);
1129     }
1130 
1131     // Overrides for Context's functions: when called from RelayHub, sender and
1132     // data require some pre-processing: the actual sender is stored at the end
1133     // of the call data, which in turns means it needs to be removed from it
1134     // when handling said data.
1135 
1136     /**
1137      * @dev Replacement for msg.sender. Returns the actual sender of a transaction: msg.sender for regular transactions,
1138      * and the end-user for GSN relayed calls (where msg.sender is actually `RelayHub`).
1139      *
1140      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.sender`, and use {_msgSender} instead.
1141      */
1142     function _msgSender() internal view returns (address payable) {
1143         if (msg.sender != _relayHub) {
1144             return msg.sender;
1145         } else {
1146             return _getRelayedCallSender();
1147         }
1148     }
1149 
1150     /**
1151      * @dev Replacement for msg.data. Returns the actual calldata of a transaction: msg.data for regular transactions,
1152      * and a reduced version for GSN relayed calls (where msg.data contains additional information).
1153      *
1154      * IMPORTANT: Contracts derived from {GSNRecipient} should never use `msg.data`, and use {_msgData} instead.
1155      */
1156     function _msgData() internal view returns (bytes memory) {
1157         if (msg.sender != _relayHub) {
1158             return msg.data;
1159         } else {
1160             return _getRelayedCallData();
1161         }
1162     }
1163 
1164     // Base implementations for pre and post relayedCall: only RelayHub can invoke them, and data is forwarded to the
1165     // internal hook.
1166 
1167     /**
1168      * @dev See `IRelayRecipient.preRelayedCall`.
1169      *
1170      * This function should not be overriden directly, use `_preRelayedCall` instead.
1171      *
1172      * * Requirements:
1173      *
1174      * - the caller must be the `RelayHub` contract.
1175      */
1176     function preRelayedCall(bytes calldata context) external returns (bytes32) {
1177         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1178         return _preRelayedCall(context);
1179     }
1180 
1181     /**
1182      * @dev See `IRelayRecipient.preRelayedCall`.
1183      *
1184      * Called by `GSNRecipient.preRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1185      * must implement this function with any relayed-call preprocessing they may wish to do.
1186      *
1187      */
1188     function _preRelayedCall(bytes memory context) internal returns (bytes32);
1189 
1190     /**
1191      * @dev See `IRelayRecipient.postRelayedCall`.
1192      *
1193      * This function should not be overriden directly, use `_postRelayedCall` instead.
1194      *
1195      * * Requirements:
1196      *
1197      * - the caller must be the `RelayHub` contract.
1198      */
1199     function postRelayedCall(bytes calldata context, bool success, uint256 actualCharge, bytes32 preRetVal) external {
1200         require(msg.sender == getHubAddr(), "GSNRecipient: caller is not RelayHub");
1201         _postRelayedCall(context, success, actualCharge, preRetVal);
1202     }
1203 
1204     /**
1205      * @dev See `IRelayRecipient.postRelayedCall`.
1206      *
1207      * Called by `GSNRecipient.postRelayedCall`, which asserts the caller is the `RelayHub` contract. Derived contracts
1208      * must implement this function with any relayed-call postprocessing they may wish to do.
1209      *
1210      */
1211     function _postRelayedCall(bytes memory context, bool success, uint256 actualCharge, bytes32 preRetVal) internal;
1212 
1213     /**
1214      * @dev Return this in acceptRelayedCall to proceed with the execution of a relayed call. Note that this contract
1215      * will be charged a fee by RelayHub
1216      */
1217     function _approveRelayedCall() internal pure returns (uint256, bytes memory) {
1218         return _approveRelayedCall("");
1219     }
1220 
1221     /**
1222      * @dev See `GSNRecipient._approveRelayedCall`.
1223      *
1224      * This overload forwards `context` to _preRelayedCall and _postRelayedCall.
1225      */
1226     function _approveRelayedCall(bytes memory context) internal pure returns (uint256, bytes memory) {
1227         return (RELAYED_CALL_ACCEPTED, context);
1228     }
1229 
1230     /**
1231      * @dev Return this in acceptRelayedCall to impede execution of a relayed call. No fees will be charged.
1232      */
1233     function _rejectRelayedCall(uint256 errorCode) internal pure returns (uint256, bytes memory) {
1234         return (RELAYED_CALL_REJECTED + errorCode, "");
1235     }
1236 
1237     /*
1238      * @dev Calculates how much RelayHub will charge a recipient for using `gas` at a `gasPrice`, given a relayer's
1239      * `serviceFee`.
1240      */
1241     function _computeCharge(uint256 gas, uint256 gasPrice, uint256 serviceFee) internal pure returns (uint256) {
1242         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1243         // charged for 1.4 times the spent amount.
1244         return (gas * gasPrice * (100 + serviceFee)) / 100;
1245     }
1246 
1247     function _getRelayedCallSender() private pure returns (address payable result) {
1248         // We need to read 20 bytes (an address) located at array index msg.data.length - 20. In memory, the array
1249         // is prefixed with a 32-byte length value, so we first add 32 to get the memory read index. However, doing
1250         // so would leave the address in the upper 20 bytes of the 32-byte word, which is inconvenient and would
1251         // require bit shifting. We therefore subtract 12 from the read index so the address lands on the lower 20
1252         // bytes. This can always be done due to the 32-byte prefix.
1253 
1254         // The final memory read index is msg.data.length - 20 + 32 - 12 = msg.data.length. Using inline assembly is the
1255         // easiest/most-efficient way to perform this operation.
1256 
1257         // These fields are not accessible from assembly
1258         bytes memory array = msg.data;
1259         uint256 index = msg.data.length;
1260 
1261         // solhint-disable-next-line no-inline-assembly
1262         assembly {
1263             // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1264             result := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1265         }
1266         return result;
1267     }
1268 
1269     function _getRelayedCallData() private pure returns (bytes memory) {
1270         // RelayHub appends the sender address at the end of the calldata, so in order to retrieve the actual msg.data,
1271         // we must strip the last 20 bytes (length of an address type) from it.
1272 
1273         uint256 actualDataLength = msg.data.length - 20;
1274         bytes memory actualData = new bytes(actualDataLength);
1275 
1276         for (uint256 i = 0; i < actualDataLength; ++i) {
1277             actualData[i] = msg.data[i];
1278         }
1279 
1280         return actualData;
1281     }
1282 }
1283 
1284 // File: @openzeppelin/contracts/ownership/Ownable.sol
1285 
1286 pragma solidity ^0.5.0;
1287 
1288 /**
1289  * @dev Contract module which provides a basic access control mechanism, where
1290  * there is an account (an owner) that can be granted exclusive access to
1291  * specific functions.
1292  *
1293  * This module is used through inheritance. It will make available the modifier
1294  * `onlyOwner`, which can be applied to your functions to restrict their use to
1295  * the owner.
1296  */
1297 contract Ownable is Context {
1298     address private _owner;
1299 
1300     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1301 
1302     /**
1303      * @dev Initializes the contract setting the deployer as the initial owner.
1304      */
1305     constructor () internal {
1306         address msgSender = _msgSender();
1307         _owner = msgSender;
1308         emit OwnershipTransferred(address(0), msgSender);
1309     }
1310 
1311     /**
1312      * @dev Returns the address of the current owner.
1313      */
1314     function owner() public view returns (address) {
1315         return _owner;
1316     }
1317 
1318     /**
1319      * @dev Throws if called by any account other than the owner.
1320      */
1321     modifier onlyOwner() {
1322         require(isOwner(), "Ownable: caller is not the owner");
1323         _;
1324     }
1325 
1326     /**
1327      * @dev Returns true if the caller is the current owner.
1328      */
1329     function isOwner() public view returns (bool) {
1330         return _msgSender() == _owner;
1331     }
1332 
1333     /**
1334      * @dev Leaves the contract without owner. It will not be possible to call
1335      * `onlyOwner` functions anymore. Can only be called by the current owner.
1336      *
1337      * NOTE: Renouncing ownership will leave the contract without an owner,
1338      * thereby removing any functionality that is only available to the owner.
1339      */
1340     function renounceOwnership() public onlyOwner {
1341         emit OwnershipTransferred(_owner, address(0));
1342         _owner = address(0);
1343     }
1344 
1345     /**
1346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1347      * Can only be called by the current owner.
1348      */
1349     function transferOwnership(address newOwner) public onlyOwner {
1350         _transferOwnership(newOwner);
1351     }
1352 
1353     /**
1354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1355      */
1356     function _transferOwnership(address newOwner) internal {
1357         require(newOwner != address(0), "Ownable: new owner is the zero address");
1358         emit OwnershipTransferred(_owner, newOwner);
1359         _owner = newOwner;
1360     }
1361 }
1362 
1363 // File: contracts/purchase/ICrateOpenEmitter.sol
1364 
1365 pragma solidity = 0.5.16;
1366 
1367 
1368 interface ICrateOpenEmitter {
1369     function openCrate(address from, uint256 lotId, uint256 amount) external;
1370 }
1371 
1372 // File: contracts/purchase/F1DeltaCrate.sol
1373 
1374 pragma solidity = 0.5.16;
1375 
1376 
1377 
1378 
1379 
1380 
1381 // crate token. 0 decimals - crates can't be fractional
1382 contract F1DeltaCrate is ERC20Capped, ERC20Detailed, GSNRecipient, Ownable {
1383     enum ErrorCodes {
1384         RESTRICTED_METHOD,
1385         INSUFFICIENT_BALANCE
1386     }
1387 
1388     struct AcceptRelayedCallVars {
1389         bytes4 methodId;
1390         bytes ef;
1391     }
1392 
1393     string _uri;
1394     address _crateOpener;
1395     uint256 _lotId;
1396     uint256 public _cratesIssued;
1397 
1398     constructor(
1399         uint256 lotId, 
1400         uint256 cap,
1401         string memory name, 
1402         string memory symbol,
1403         string memory uri,
1404         address crateOpener
1405     ) ERC20Capped(cap) ERC20Detailed(name, symbol, 0) public {
1406         require(crateOpener != address(0));
1407 
1408         _uri = uri;
1409         _crateOpener = crateOpener;
1410         _lotId = lotId;
1411     }
1412 
1413     function burn(uint256 amount) public {
1414         _burn(_msgSender(), amount);
1415         ICrateOpenEmitter(_crateOpener).openCrate(_msgSender(), _lotId, amount);
1416     }
1417 
1418     function burnFrom(address account, uint256 amount) public {
1419         _burnFrom(account, amount);
1420         ICrateOpenEmitter(_crateOpener).openCrate(account, _lotId, amount);
1421     }
1422 
1423     function _mint(address account, uint256 amount) internal {
1424         _cratesIssued = _cratesIssued + amount; // not enough money in the world to cover 2 ^ 256 - 1 increments
1425         require(_cratesIssued <= cap(), "cratesIssued exceeded cap");
1426         super._mint(account, amount);
1427     }
1428 
1429     function tokenURI() public view returns (string memory) {
1430         return _uri;
1431     }
1432 
1433     function setURI(string memory uri) public onlyOwner {
1434         _uri = uri;
1435     }
1436 
1437     /////////////////////////////////////////// GSNRecipient implementation ///////////////////////////////////
1438     /**
1439      * @dev Ensures that only users with enough gas payment token balance can have transactions relayed through the GSN.
1440      */
1441     function acceptRelayedCall(
1442         address /*relay*/,
1443         address from,
1444         bytes calldata encodedFunction,
1445         uint256 /*transactionFee*/,
1446         uint256 /*gasPrice*/,
1447         uint256 /*gasLimit*/,
1448         uint256 /*nonce*/,
1449         bytes calldata /*approvalData*/,
1450         uint256 /*maxPossibleCharge*/
1451     )
1452         external
1453         view
1454         returns (uint256, bytes memory mem)
1455     {
1456         // restrict to burn function only
1457         // load methodId stored in first 4 bytes https://solidity.readthedocs.io/en/v0.5.16/abi-spec.html#function-selector-and-argument-encoding
1458         // load amount stored in the next 32 bytes https://solidity.readthedocs.io/en/v0.5.16/abi-spec.html#function-selector-and-argument-encoding
1459         // 32 bytes offset is required to skip array length
1460         bytes4 methodId;
1461         uint256 amountParam;
1462         mem = encodedFunction;
1463         assembly {
1464             let dest := add(mem, 32)
1465             methodId := mload(dest)
1466             dest := add(dest, 4)
1467             amountParam := mload(dest)
1468         }
1469 
1470         // bytes4(keccak256("burn(uint256)")) == 0x42966c68
1471         if (methodId != 0x42966c68) {
1472             return _rejectRelayedCall(uint256(ErrorCodes.RESTRICTED_METHOD));
1473         }
1474 
1475         // Check that user has enough crates to burn
1476         if (balanceOf(from) < amountParam) {
1477             return _rejectRelayedCall(uint256(ErrorCodes.INSUFFICIENT_BALANCE));
1478         }
1479 
1480         return _approveRelayedCall();
1481     }
1482 
1483     function _preRelayedCall(bytes memory) internal returns (bytes32) {
1484         // solhint-disable-previous-line no-empty-blocks
1485     }
1486 
1487     function _postRelayedCall(bytes memory, bool, uint256, bytes32) internal {
1488         // solhint-disable-previous-line no-empty-blocks
1489     }
1490 
1491     /**
1492      * @dev Withdraws the recipient's deposits in `RelayHub`.
1493      */
1494     function withdrawDeposits(uint256 amount, address payable payee) external onlyOwner {
1495         _withdrawDeposits(amount, payee);
1496     }
1497 }