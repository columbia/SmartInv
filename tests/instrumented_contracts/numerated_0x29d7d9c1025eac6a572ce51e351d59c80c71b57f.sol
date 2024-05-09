1 // File: contracts/interfaces/IGoddessFragments.sol
2 
3 //SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.5.12;
6 
7 interface IGoddessFragments {
8     function summon(uint256 goddessID) external;
9 
10     function fusion(uint256 goddessID) external;
11 
12     function collectFragments(address user, uint256 amount) external;
13 }
14 
15 // File: @openzeppelin/contracts/math/Math.sol
16 
17 pragma solidity ^0.5.0;
18 
19 /**
20  * @dev Standard math utilities missing in the Solidity language.
21  */
22 library Math {
23     /**
24      * @dev Returns the largest of two numbers.
25      */
26     function max(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a >= b ? a : b;
28     }
29 
30     /**
31      * @dev Returns the smallest of two numbers.
32      */
33     function min(uint256 a, uint256 b) internal pure returns (uint256) {
34         return a < b ? a : b;
35     }
36 
37     /**
38      * @dev Returns the average of two numbers. The result is rounded towards
39      * zero.
40      */
41     function average(uint256 a, uint256 b) internal pure returns (uint256) {
42         // (a + b) / 2 can overflow, so we distribute
43         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
44     }
45 }
46 
47 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
48 
49 pragma solidity ^0.5.0;
50 
51 /**
52  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
53  * the optional functions; to access them see {ERC20Detailed}.
54  */
55 interface IERC20 {
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `sender` to `recipient` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
113      * another (`to`).
114      *
115      * Note that `value` may be zero.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
121      * a call to {approve}. `value` is the new allowance.
122      */
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 // File: @openzeppelin/contracts/GSN/Context.sol
127 
128 pragma solidity ^0.5.0;
129 
130 /*
131  * @dev Provides information about the current execution context, including the
132  * sender of the transaction and its data. While these are generally available
133  * via msg.sender and msg.data, they should not be accessed in such a direct
134  * manner, since when dealing with GSN meta-transactions the account sending and
135  * paying for execution may not be the actual sender (as far as an application
136  * is concerned).
137  *
138  * This contract is only required for intermediate, library-like contracts.
139  */
140 contract Context {
141     // Empty internal constructor, to prevent people from mistakenly deploying
142     // an instance of this contract, which should be used via inheritance.
143     constructor () internal { }
144     // solhint-disable-previous-line no-empty-blocks
145 
146     function _msgSender() internal view returns (address payable) {
147         return msg.sender;
148     }
149 
150     function _msgData() internal view returns (bytes memory) {
151         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
152         return msg.data;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/math/SafeMath.sol
157 
158 pragma solidity ^0.5.0;
159 
160 /**
161  * @dev Wrappers over Solidity's arithmetic operations with added overflow
162  * checks.
163  *
164  * Arithmetic operations in Solidity wrap on overflow. This can easily result
165  * in bugs, because programmers usually assume that an overflow raises an
166  * error, which is the standard behavior in high level programming languages.
167  * `SafeMath` restores this intuition by reverting the transaction when an
168  * operation overflows.
169  *
170  * Using this library instead of the unchecked operations eliminates an entire
171  * class of bugs, so it's recommended to use it always.
172  */
173 library SafeMath {
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      * - Addition cannot overflow.
182      */
183     function add(uint256 a, uint256 b) internal pure returns (uint256) {
184         uint256 c = a + b;
185         require(c >= a, "SafeMath: addition overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      * - Subtraction cannot overflow.
198      */
199     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200         return sub(a, b, "SafeMath: subtraction overflow");
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      * - Subtraction cannot overflow.
211      *
212      * _Available since v2.4.0._
213      */
214     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b <= a, errorMessage);
216         uint256 c = a - b;
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `*` operator.
226      *
227      * Requirements:
228      * - Multiplication cannot overflow.
229      */
230     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
231         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
232         // benefit is lost if 'b' is also tested.
233         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
234         if (a == 0) {
235             return 0;
236         }
237 
238         uint256 c = a * b;
239         require(c / a == b, "SafeMath: multiplication overflow");
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers. Reverts on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `/` operator. Note: this function uses a
249      * `revert` opcode (which leaves remaining gas untouched) while Solidity
250      * uses an invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      */
255     function div(uint256 a, uint256 b) internal pure returns (uint256) {
256         return div(a, b, "SafeMath: division by zero");
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      * - The divisor cannot be zero.
269      *
270      * _Available since v2.4.0._
271      */
272     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         // Solidity only automatically asserts when dividing by 0
274         require(b > 0, errorMessage);
275         uint256 c = a / b;
276         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
277 
278         return c;
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * Reverts when dividing by zero.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      * - The divisor cannot be zero.
291      */
292     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
293         return mod(a, b, "SafeMath: modulo by zero");
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
298      * Reverts with custom message when dividing by zero.
299      *
300      * Counterpart to Solidity's `%` operator. This function uses a `revert`
301      * opcode (which leaves remaining gas untouched) while Solidity uses an
302      * invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      * - The divisor cannot be zero.
306      *
307      * _Available since v2.4.0._
308      */
309     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         require(b != 0, errorMessage);
311         return a % b;
312     }
313 }
314 
315 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
316 
317 pragma solidity ^0.5.0;
318 
319 
320 
321 
322 /**
323  * @dev Implementation of the {IERC20} interface.
324  *
325  * This implementation is agnostic to the way tokens are created. This means
326  * that a supply mechanism has to be added in a derived contract using {_mint}.
327  * For a generic mechanism see {ERC20Mintable}.
328  *
329  * TIP: For a detailed writeup see our guide
330  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
331  * to implement supply mechanisms].
332  *
333  * We have followed general OpenZeppelin guidelines: functions revert instead
334  * of returning `false` on failure. This behavior is nonetheless conventional
335  * and does not conflict with the expectations of ERC20 applications.
336  *
337  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
338  * This allows applications to reconstruct the allowance for all accounts just
339  * by listening to said events. Other implementations of the EIP may not emit
340  * these events, as it isn't required by the specification.
341  *
342  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
343  * functions have been added to mitigate the well-known issues around setting
344  * allowances. See {IERC20-approve}.
345  */
346 contract ERC20 is Context, IERC20 {
347     using SafeMath for uint256;
348 
349     mapping (address => uint256) private _balances;
350 
351     mapping (address => mapping (address => uint256)) private _allowances;
352 
353     uint256 private _totalSupply;
354 
355     /**
356      * @dev See {IERC20-totalSupply}.
357      */
358     function totalSupply() public view returns (uint256) {
359         return _totalSupply;
360     }
361 
362     /**
363      * @dev See {IERC20-balanceOf}.
364      */
365     function balanceOf(address account) public view returns (uint256) {
366         return _balances[account];
367     }
368 
369     /**
370      * @dev See {IERC20-transfer}.
371      *
372      * Requirements:
373      *
374      * - `recipient` cannot be the zero address.
375      * - the caller must have a balance of at least `amount`.
376      */
377     function transfer(address recipient, uint256 amount) public returns (bool) {
378         _transfer(_msgSender(), recipient, amount);
379         return true;
380     }
381 
382     /**
383      * @dev See {IERC20-allowance}.
384      */
385     function allowance(address owner, address spender) public view returns (uint256) {
386         return _allowances[owner][spender];
387     }
388 
389     /**
390      * @dev See {IERC20-approve}.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function approve(address spender, uint256 amount) public returns (bool) {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-transferFrom}.
403      *
404      * Emits an {Approval} event indicating the updated allowance. This is not
405      * required by the EIP. See the note at the beginning of {ERC20};
406      *
407      * Requirements:
408      * - `sender` and `recipient` cannot be the zero address.
409      * - `sender` must have a balance of at least `amount`.
410      * - the caller must have allowance for `sender`'s tokens of at least
411      * `amount`.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
414         _transfer(sender, recipient, amount);
415         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
416         return true;
417     }
418 
419     /**
420      * @dev Atomically increases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
433         return true;
434     }
435 
436     /**
437      * @dev Atomically decreases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      * - `spender` must have allowance for the caller of at least
448      * `subtractedValue`.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
451         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
452         return true;
453     }
454 
455     /**
456      * @dev Moves tokens `amount` from `sender` to `recipient`.
457      *
458      * This is internal function is equivalent to {transfer}, and can be used to
459      * e.g. implement automatic token fees, slashing mechanisms, etc.
460      *
461      * Emits a {Transfer} event.
462      *
463      * Requirements:
464      *
465      * - `sender` cannot be the zero address.
466      * - `recipient` cannot be the zero address.
467      * - `sender` must have a balance of at least `amount`.
468      */
469     function _transfer(address sender, address recipient, uint256 amount) internal {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
474         _balances[recipient] = _balances[recipient].add(amount);
475         emit Transfer(sender, recipient, amount);
476     }
477 
478     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
479      * the total supply.
480      *
481      * Emits a {Transfer} event with `from` set to the zero address.
482      *
483      * Requirements
484      *
485      * - `to` cannot be the zero address.
486      */
487     function _mint(address account, uint256 amount) internal {
488         require(account != address(0), "ERC20: mint to the zero address");
489 
490         _totalSupply = _totalSupply.add(amount);
491         _balances[account] = _balances[account].add(amount);
492         emit Transfer(address(0), account, amount);
493     }
494 
495     /**
496      * @dev Destroys `amount` tokens from `account`, reducing the
497      * total supply.
498      *
499      * Emits a {Transfer} event with `to` set to the zero address.
500      *
501      * Requirements
502      *
503      * - `account` cannot be the zero address.
504      * - `account` must have at least `amount` tokens.
505      */
506     function _burn(address account, uint256 amount) internal {
507         require(account != address(0), "ERC20: burn from the zero address");
508 
509         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
510         _totalSupply = _totalSupply.sub(amount);
511         emit Transfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
516      *
517      * This is internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(address owner, address spender, uint256 amount) internal {
528         require(owner != address(0), "ERC20: approve from the zero address");
529         require(spender != address(0), "ERC20: approve to the zero address");
530 
531         _allowances[owner][spender] = amount;
532         emit Approval(owner, spender, amount);
533     }
534 
535     /**
536      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
537      * from the caller's allowance.
538      *
539      * See {_burn} and {_approve}.
540      */
541     function _burnFrom(address account, uint256 amount) internal {
542         _burn(account, amount);
543         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
544     }
545 }
546 
547 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
548 
549 pragma solidity ^0.5.0;
550 
551 
552 
553 /**
554  * @dev Extension of {ERC20} that allows token holders to destroy both their own
555  * tokens and those that they have an allowance for, in a way that can be
556  * recognized off-chain (via event analysis).
557  */
558 contract ERC20Burnable is Context, ERC20 {
559     /**
560      * @dev Destroys `amount` tokens from the caller.
561      *
562      * See {ERC20-_burn}.
563      */
564     function burn(uint256 amount) public {
565         _burn(_msgSender(), amount);
566     }
567 
568     /**
569      * @dev See {ERC20-_burnFrom}.
570      */
571     function burnFrom(address account, uint256 amount) public {
572         _burnFrom(account, amount);
573     }
574 }
575 
576 // File: contracts/interfaces/IReferral.sol
577 
578 //SPDX-License-Identifier: MIT
579 
580 pragma solidity ^0.5.12;
581 
582 interface IReferral {
583     function setReferrer(address farmer, address referrer) external;
584 
585     function getReferrer(address farmer) external view returns (address);
586 }
587 
588 // File: contracts/interfaces/IGovernance.sol
589 
590 pragma solidity ^0.5.12;
591 
592 interface IGovernance {
593     function getStableToken() external view returns (address);
594 }
595 
596 // File: contracts/interfaces/IUniswapRouter.sol
597 
598 //SPDX-License-Identifier: MIT
599 
600 pragma solidity ^0.5.12;
601 
602 interface IUniswapRouter {
603     function swapExactTokensForTokens(
604         uint256 amountIn,
605         uint256 amountOutMin,
606         address[] calldata path,
607         address to,
608         uint256 deadline
609     ) external returns (uint256[] memory amounts);
610 
611     function swapTokensForExactTokens(
612         uint256 amountOut,
613         uint256 amountInMax,
614         address[] calldata path,
615         address to,
616         uint256 deadline
617     ) external returns (uint256[] memory amounts);
618 
619     function WETH() external pure returns (address);
620 
621     function getAmountsIn(uint256 amountOut, address[] calldata path)
622         external
623         view
624         returns (uint256[] memory amounts);
625 }
626 
627 // File: contracts/utils/PermissionGroups.sol
628 
629 //SPDX-License-Identifier: MIT
630 
631 pragma solidity ^0.5.12;
632 
633 contract PermissionGroups {
634     address public admin;
635     address public pendingAdmin;
636     mapping(address => bool) internal operators;
637     address[] internal operatorsGroup;
638     uint256 internal constant MAX_GROUP_SIZE = 50;
639 
640     constructor(address _admin) public {
641         require(_admin != address(0), "Admin 0");
642         admin = _admin;
643     }
644 
645     modifier onlyAdmin() {
646         require(msg.sender == admin, "Only admin");
647         _;
648     }
649 
650     modifier onlyOperator() {
651         require(operators[msg.sender], "Only operator");
652         _;
653     }
654 
655     function getOperators() external view returns (address[] memory) {
656         return operatorsGroup;
657     }
658 
659     event TransferAdminPending(address pendingAdmin);
660 
661     /**
662      * @dev Allows the current admin to set the pendingAdmin address.
663      * @param newAdmin The address to transfer ownership to.
664      */
665     function transferAdmin(address newAdmin) public onlyAdmin {
666         require(newAdmin != address(0), "New admin 0");
667         emit TransferAdminPending(newAdmin);
668         pendingAdmin = newAdmin;
669     }
670 
671     /**
672      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
673      * @param newAdmin The address to transfer ownership to.
674      */
675     function transferAdminQuickly(address newAdmin) public onlyAdmin {
676         require(newAdmin != address(0), "Admin 0");
677         emit TransferAdminPending(newAdmin);
678         emit AdminClaimed(newAdmin, admin);
679         admin = newAdmin;
680     }
681 
682     event AdminClaimed(address newAdmin, address previousAdmin);
683 
684     /**
685      * @dev Allows the pendingAdmin address to finalize the change admin process.
686      */
687     function claimAdmin() public {
688         require(pendingAdmin == msg.sender, "not pending");
689         emit AdminClaimed(pendingAdmin, admin);
690         admin = pendingAdmin;
691         pendingAdmin = address(0);
692     }
693 
694     event OperatorAdded(address newOperator, bool isAdd);
695 
696     function addOperator(address newOperator) public onlyAdmin {
697         require(!operators[newOperator], "Operator exists"); // prevent duplicates.
698         require(operatorsGroup.length < MAX_GROUP_SIZE, "Max operators");
699 
700         emit OperatorAdded(newOperator, true);
701         operators[newOperator] = true;
702         operatorsGroup.push(newOperator);
703     }
704 
705     function removeOperator(address operator) public onlyAdmin {
706         require(operators[operator], "Not operator");
707         operators[operator] = false;
708 
709         for (uint256 i = 0; i < operatorsGroup.length; ++i) {
710             if (operatorsGroup[i] == operator) {
711                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
712                 operatorsGroup.pop();
713                 emit OperatorAdded(operator, false);
714                 break;
715             }
716         }
717     }
718 }
719 
720 // File: contracts/utils/Withdrawable.sol
721 
722 //SPDX-License-Identifier: MIT
723 
724 pragma solidity ^0.5.12;
725 
726 
727 
728 contract Withdrawable is PermissionGroups {
729     bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
730 
731     mapping(address => bool) internal blacklist;
732 
733     event TokenWithdraw(address token, uint256 amount, address sendTo);
734 
735     event EtherWithdraw(uint256 amount, address sendTo);
736 
737     constructor(address _admin) public PermissionGroups(_admin) {}
738 
739     /**
740      * @dev Withdraw all IERC20 compatible tokens
741      * @param token IERC20 The address of the token contract
742      */
743     function withdrawToken(
744         address token,
745         uint256 amount,
746         address sendTo
747     ) external onlyAdmin {
748         require(!blacklist[address(token)], "forbid to withdraw that token");
749         _safeTransfer(token, sendTo, amount);
750         emit TokenWithdraw(token, amount, sendTo);
751     }
752 
753     /**
754      * @dev Withdraw Ethers
755      */
756     function withdrawEther(uint256 amount, address payable sendTo) external onlyAdmin {
757         (bool success, ) = sendTo.call.value(amount)("");
758         require(success);
759         emit EtherWithdraw(amount, sendTo);
760     }
761 
762     function setBlackList(address token) internal {
763         blacklist[token] = true;
764     }
765 
766     function _safeTransfer(
767         address token,
768         address to,
769         uint256 value
770     ) private {
771         (bool success, bytes memory data) = token.call(
772             abi.encodeWithSelector(SELECTOR, to, value)
773         );
774         require(success && (data.length == 0 || abi.decode(data, (bool))), "TRANSFER_FAILED");
775     }
776 }
777 
778 // File: @openzeppelin/contracts/utils/Address.sol
779 
780 pragma solidity ^0.5.5;
781 
782 /**
783  * @dev Collection of functions related to the address type
784  */
785 library Address {
786     /**
787      * @dev Returns true if `account` is a contract.
788      *
789      * [IMPORTANT]
790      * ====
791      * It is unsafe to assume that an address for which this function returns
792      * false is an externally-owned account (EOA) and not a contract.
793      *
794      * Among others, `isContract` will return false for the following 
795      * types of addresses:
796      *
797      *  - an externally-owned account
798      *  - a contract in construction
799      *  - an address where a contract will be created
800      *  - an address where a contract lived, but was destroyed
801      * ====
802      */
803     function isContract(address account) internal view returns (bool) {
804         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
805         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
806         // for accounts without code, i.e. `keccak256('')`
807         bytes32 codehash;
808         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
809         // solhint-disable-next-line no-inline-assembly
810         assembly { codehash := extcodehash(account) }
811         return (codehash != accountHash && codehash != 0x0);
812     }
813 
814     /**
815      * @dev Converts an `address` into `address payable`. Note that this is
816      * simply a type cast: the actual underlying value is not changed.
817      *
818      * _Available since v2.4.0._
819      */
820     function toPayable(address account) internal pure returns (address payable) {
821         return address(uint160(account));
822     }
823 
824     /**
825      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
826      * `recipient`, forwarding all available gas and reverting on errors.
827      *
828      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
829      * of certain opcodes, possibly making contracts go over the 2300 gas limit
830      * imposed by `transfer`, making them unable to receive funds via
831      * `transfer`. {sendValue} removes this limitation.
832      *
833      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
834      *
835      * IMPORTANT: because control is transferred to `recipient`, care must be
836      * taken to not create reentrancy vulnerabilities. Consider using
837      * {ReentrancyGuard} or the
838      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
839      *
840      * _Available since v2.4.0._
841      */
842     function sendValue(address payable recipient, uint256 amount) internal {
843         require(address(this).balance >= amount, "Address: insufficient balance");
844 
845         // solhint-disable-next-line avoid-call-value
846         (bool success, ) = recipient.call.value(amount)("");
847         require(success, "Address: unable to send value, recipient may have reverted");
848     }
849 }
850 
851 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
852 
853 pragma solidity ^0.5.0;
854 
855 
856 
857 
858 /**
859  * @title SafeERC20
860  * @dev Wrappers around ERC20 operations that throw on failure (when the token
861  * contract returns false). Tokens that return no value (and instead revert or
862  * throw on failure) are also supported, non-reverting calls are assumed to be
863  * successful.
864  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
865  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
866  */
867 library SafeERC20 {
868     using SafeMath for uint256;
869     using Address for address;
870 
871     function safeTransfer(IERC20 token, address to, uint256 value) internal {
872         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
873     }
874 
875     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
876         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
877     }
878 
879     function safeApprove(IERC20 token, address spender, uint256 value) internal {
880         // safeApprove should only be called when setting an initial allowance,
881         // or when resetting it to zero. To increase and decrease it, use
882         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
883         // solhint-disable-next-line max-line-length
884         require((value == 0) || (token.allowance(address(this), spender) == 0),
885             "SafeERC20: approve from non-zero to non-zero allowance"
886         );
887         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
888     }
889 
890     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
891         uint256 newAllowance = token.allowance(address(this), spender).add(value);
892         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
893     }
894 
895     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
896         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
897         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
898     }
899 
900     /**
901      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
902      * on the return value: the return value is optional (but if data is returned, it must not be false).
903      * @param token The token targeted by the call.
904      * @param data The call data (encoded using abi.encode or one of its variants).
905      */
906     function callOptionalReturn(IERC20 token, bytes memory data) private {
907         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
908         // we're implementing it ourselves.
909 
910         // A Solidity high level call has three parts:
911         //  1. The target address is checked to verify it contains contract code
912         //  2. The call itself is made, and success asserted
913         //  3. The return value is decoded, which in turn checks the size of the returned data.
914         // solhint-disable-next-line max-line-length
915         require(address(token).isContract(), "SafeERC20: call to non-contract");
916 
917         // solhint-disable-next-line avoid-low-level-calls
918         (bool success, bytes memory returndata) = address(token).call(data);
919         require(success, "SafeERC20: low-level call failed");
920 
921         if (returndata.length > 0) { // Return data is optional
922             // solhint-disable-next-line max-line-length
923             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
924         }
925     }
926 }
927 
928 // File: contracts/utils/LPTokenWrapper.sol
929 
930 //SPDX-License-Identifier: MIT
931 
932 pragma solidity ^0.5.12;
933 
934 
935 
936 
937 contract LPTokenWrapper {
938     using SafeMath for uint256;
939     using SafeERC20 for IERC20;
940 
941     IERC20 public stakeToken;
942 
943     uint256 private _totalSupply;
944     mapping(address => uint256) private _balances;
945 
946     constructor(IERC20 _stakeToken) public {
947         stakeToken = _stakeToken;
948     }
949 
950     function totalSupply() public view returns (uint256) {
951         return _totalSupply;
952     }
953 
954     function balanceOf(address account) public view returns (uint256) {
955         return _balances[account];
956     }
957 
958     function stake(uint256 amount) internal {
959         _totalSupply = _totalSupply.add(amount);
960         _balances[msg.sender] = _balances[msg.sender].add(amount);
961         // safeTransferFrom shifted to last line of overridden method
962     }
963 
964     function withdraw(uint256 amount) public {
965         _totalSupply = _totalSupply.sub(amount);
966         _balances[msg.sender] = _balances[msg.sender].sub(amount);
967         // safeTransfer shifted to last line of overridden method
968     }
969 }
970 
971 // File: contracts/SeedPool.sol
972 
973 //SPDX-License-Identifier: MIT
974 
975 pragma solidity ^0.5.12;
976 
977 
978 
979 
980 
981 
982 
983 contract SeedPool is LPTokenWrapper, Withdrawable {
984     IERC20 public goddessToken;
985     uint256 public tokenCapAmount;
986     uint256 public starttime;
987     uint256 public duration;
988     uint256 public periodFinish = 0;
989     uint256 public rewardRate = 0;
990     uint256 public lastUpdateTime;
991     uint256 public rewardPerTokenStored;
992     mapping(address => uint256) public userRewardPerTokenPaid;
993     mapping(address => uint256) public rewards;
994     IReferral public referral;
995 
996     // variables to keep track of totalSupply and balances (after accounting for multiplier)
997     uint256 internal totalStakingBalance;
998     mapping(address => uint256) internal stakeBalance;
999     uint256 internal constant PRECISION = 1e18;
1000     uint256 public constant REFERRAL_COMMISSION_PERCENT = 1;
1001     uint256 private constant ONE_WEEK = 604800;
1002 
1003     event RewardAdded(uint256 reward);
1004     event RewardPaid(address indexed user, uint256 reward);
1005 
1006     modifier checkStart() {
1007         require(block.timestamp >= starttime, "not start");
1008         _;
1009     }
1010 
1011     modifier updateReward(address account) {
1012         rewardPerTokenStored = rewardPerToken();
1013         lastUpdateTime = lastTimeRewardApplicable();
1014         if (account != address(0)) {
1015             rewards[account] = earned(account);
1016             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1017         }
1018         _;
1019     }
1020 
1021     constructor(
1022         uint256 _tokenCapAmount,
1023         IERC20 _stakeToken,
1024         IERC20 _goddessToken,
1025         uint256 _starttime,
1026         uint256 _duration
1027     ) public LPTokenWrapper(_stakeToken) Withdrawable(msg.sender) {
1028         tokenCapAmount = _tokenCapAmount;
1029         goddessToken = _goddessToken;
1030         starttime = _starttime;
1031         duration = _duration;
1032         Withdrawable.setBlackList(address(_goddessToken));
1033         Withdrawable.setBlackList(address(_stakeToken));
1034     }
1035 
1036     function lastTimeRewardApplicable() public view returns (uint256) {
1037         return Math.min(block.timestamp, periodFinish);
1038     }
1039 
1040     function rewardPerToken() public view returns (uint256) {
1041         if (totalStakingBalance == 0) {
1042             return rewardPerTokenStored;
1043         }
1044         return
1045             rewardPerTokenStored.add(
1046                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(
1047                     totalStakingBalance
1048                 )
1049             );
1050     }
1051 
1052     function earned(address account) public view returns (uint256) {
1053         return totalEarned(account).mul(100 - REFERRAL_COMMISSION_PERCENT).div(100);
1054     }
1055 
1056     function totalEarned(address account) internal view returns (uint256) {
1057         return
1058             stakeBalance[account]
1059                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1060                 .div(1e18)
1061                 .add(rewards[account]);
1062     }
1063 
1064     // stake visibility is public as overriding LPTokenWrapper's stake() function
1065     function stake(uint256 amount, address referrer) public updateReward(msg.sender) checkStart {
1066         checkCap(amount, msg.sender);
1067         _stake(amount, referrer);
1068     }
1069 
1070     function _stake(uint256 amount, address referrer) internal {
1071         require(amount > 0, "Cannot stake 0");
1072         super.stake(amount);
1073 
1074         // update goddess balance and supply
1075         updateStakeBalanceAndSupply(msg.sender);
1076 
1077         // transfer token last, to follow CEI pattern
1078         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
1079         // update referrer
1080         if (address(referral) != address(0) && referrer != address(0)) {
1081             referral.setReferrer(msg.sender, referrer);
1082         }
1083     }
1084 
1085     function checkCap(uint256 amount, address user) private view {
1086         // check user cap
1087         require(
1088             balanceOf(user).add(amount) <= tokenCapAmount ||
1089                 block.timestamp >= starttime.add(ONE_WEEK),
1090             "token cap exceeded"
1091         );
1092     }
1093 
1094     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
1095         require(amount > 0, "Cannot withdraw 0");
1096         super.withdraw(amount);
1097 
1098         // update goddess balance and supply
1099         updateStakeBalanceAndSupply(msg.sender);
1100 
1101         stakeToken.safeTransfer(msg.sender, amount);
1102         getReward();
1103     }
1104 
1105     function exit() external {
1106         withdraw(balanceOf(msg.sender));
1107         getReward();
1108     }
1109 
1110     function getReward() public updateReward(msg.sender) checkStart {
1111         uint256 reward = totalEarned(msg.sender);
1112         if (reward > 0) {
1113             rewards[msg.sender] = 0;
1114             uint256 actualRewards = reward.mul(100 - REFERRAL_COMMISSION_PERCENT).div(100); // 99%
1115             uint256 commission = reward.sub(actualRewards); // 1%
1116             goddessToken.safeTransfer(msg.sender, reward);
1117             emit RewardPaid(msg.sender, reward);
1118             address referrer = address(0);
1119             if (address(referral) != address(0)) {
1120                 referrer = referral.getReferrer(msg.sender);
1121             }
1122             if (referrer != address(0)) {
1123                 // send commission to referrer
1124                 goddessToken.safeTransfer(referrer, commission);
1125             } else {
1126                 // or burn
1127                 ERC20Burnable burnableGoddessToken = ERC20Burnable(address(goddessToken));
1128                 burnableGoddessToken.burn(commission);
1129             }
1130         }
1131     }
1132 
1133     function notifyRewardAmount(uint256 reward) external onlyAdmin updateReward(address(0)) {
1134         rewardRate = reward.div(duration);
1135         lastUpdateTime = starttime;
1136         periodFinish = starttime.add(duration);
1137         emit RewardAdded(reward);
1138     }
1139 
1140     function updateStakeBalanceAndSupply(address user) private {
1141         // subtract existing balance from goddessSupply
1142         totalStakingBalance = totalStakingBalance.sub(stakeBalance[user]);
1143         // calculate and update new goddess balance (user's balance has been updated by parent method)
1144         uint256 newStakeBalance = balanceOf(user);
1145         stakeBalance[user] = newStakeBalance;
1146         // update totalStakingBalance
1147         totalStakingBalance = totalStakingBalance.add(newStakeBalance);
1148     }
1149 
1150     function setReferral(IReferral _referral) external onlyAdmin {
1151         referral = _referral;
1152     }
1153 }
1154 
1155 // File: contracts/RewardsPool.sol
1156 
1157 //SPDX-License-Identifier: MIT
1158 
1159 pragma solidity ^0.5.12;
1160 
1161 
1162 
1163 
1164 
1165 
1166 
1167 
1168 
1169 
1170 contract RewardsPool is SeedPool {
1171     address public governance;
1172     IUniswapRouter public uniswapRouter;
1173     address public stablecoin;
1174 
1175     // blessing variables
1176     // variables to keep track of totalSupply and balances (after accounting for multiplier)
1177     uint256 public lastBlessingTime; // timestamp of lastBlessingTime
1178     mapping(address => uint256) public numBlessing; // each blessing = 5% increase in stake amt
1179     mapping(address => uint256) public nextBlessingTime; // timestamp for which user is eligible to purchase another blessing
1180     uint256 public globalBlessPrice = 10**18;
1181     uint256 public blessThreshold = 10;
1182     uint256 public blessScaleFactor = 20;
1183     uint256 public scaleFactor = 320;
1184 
1185     constructor(
1186         uint256 _tokenCapAmount,
1187         IERC20 _stakeToken,
1188         IERC20 _goddessToken,
1189         IUniswapRouter _uniswapRouter,
1190         uint256 _starttime,
1191         uint256 _duration
1192     ) public SeedPool(_tokenCapAmount, _stakeToken, _goddessToken, _starttime, _duration) {
1193         uniswapRouter = _uniswapRouter;
1194         goddessToken.safeApprove(address(_uniswapRouter), 2**256 - 1);
1195     }
1196 
1197     function setScaleFactorsAndThreshold(
1198         uint256 _blessThreshold,
1199         uint256 _blessScaleFactor,
1200         uint256 _scaleFactor
1201     ) external onlyAdmin {
1202         blessThreshold = _blessThreshold;
1203         blessScaleFactor = _blessScaleFactor;
1204         scaleFactor = _scaleFactor;
1205     }
1206 
1207     function bless(uint256 _maxGdsUse) external updateReward(msg.sender) checkStart {
1208         require(block.timestamp > nextBlessingTime[msg.sender], "early bless request");
1209         require(numBlessing[msg.sender] < blessThreshold, "bless reach limit");
1210         // save current blessing price, since transfer is done last
1211         // since getBlessingPrice() returns new bless balance, avoid re-calculation
1212         (uint256 blessPrice, uint256 newBlessingBalance) = getBlessingPrice(msg.sender);
1213         require(_maxGdsUse > blessPrice, "price over maxGDS");
1214         // user's balance and blessingSupply will be changed in this function
1215         applyBlessing(msg.sender, newBlessingBalance);
1216 
1217         goddessToken.safeTransferFrom(msg.sender, address(this), blessPrice);
1218 
1219         ERC20Burnable burnableGoddessToken = ERC20Burnable(address(goddessToken));
1220 
1221         // burn 50%
1222         uint256 burnAmount = blessPrice.div(2);
1223         burnableGoddessToken.burn(burnAmount);
1224         blessPrice = blessPrice.sub(burnAmount);
1225 
1226         // swap to stablecoin
1227         address[] memory routeDetails = new address[](3);
1228         routeDetails[0] = address(goddessToken);
1229         routeDetails[1] = uniswapRouter.WETH();
1230         routeDetails[2] = address(stablecoin);
1231         uniswapRouter.swapExactTokensForTokens(
1232             blessPrice,
1233             0,
1234             routeDetails,
1235             governance,
1236             block.timestamp + 100
1237         );
1238     }
1239 
1240     function setGovernance(address _governance) external onlyAdmin {
1241         governance = _governance;
1242         stablecoin = IGovernance(governance).getStableToken();
1243     }
1244 
1245     function setUniswapRouter(IUniswapRouter _uniswapRouter) external onlyAdmin {
1246         uniswapRouter = _uniswapRouter;
1247         goddessToken.safeApprove(address(_uniswapRouter), 2**256 - 1);
1248     }
1249 
1250     // stake visibility is public as overriding LPTokenWrapper's stake() function
1251     function stake(uint256 amount, address referrer) public updateReward(msg.sender) checkStart {
1252         _stake(amount, referrer);
1253     }
1254 
1255     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
1256         require(amount > 0, "Cannot withdraw 0");
1257         LPTokenWrapper.withdraw(amount);
1258 
1259         numBlessing[msg.sender] = 0;
1260         // update goddess balance and supply
1261         updateStakeBalanceAndSupply(msg.sender, 0);
1262 
1263         stakeToken.safeTransfer(msg.sender, amount);
1264         getReward();
1265     }
1266 
1267     function getBlessingPrice(address user)
1268         public
1269         view
1270         returns (uint256 blessingPrice, uint256 newBlessingBalance)
1271     {
1272         if (totalStakingBalance == 0) return (0, 0);
1273 
1274         // 5% increase for each previously user-purchased blessing
1275         uint256 blessedTime = numBlessing[user];
1276         blessingPrice = globalBlessPrice.mul(blessedTime.mul(5).add(100)).div(100);
1277 
1278         // increment blessedTime by 1
1279         blessedTime = blessedTime.add(1);
1280 
1281         // if no. of blessings exceed threshold, increase blessing price by blessScaleFactor;
1282         if (blessedTime >= blessThreshold) {
1283             return (0, balanceOf(user));
1284         }
1285 
1286         // adjust price based on expected increase in total stake supply
1287         // blessedTime has been incremented by 1 already
1288         newBlessingBalance = balanceOf(user).mul(blessedTime.mul(5).add(100)).div(100);
1289         uint256 blessBalanceIncrease = newBlessingBalance.sub(stakeBalance[user]);
1290         blessingPrice = blessingPrice.mul(blessBalanceIncrease).mul(scaleFactor).div(
1291             totalStakingBalance
1292         );
1293     }
1294 
1295     function applyBlessing(address user, uint256 newBlessingBalance) internal {
1296         // increase no. of blessings bought
1297         numBlessing[user] = numBlessing[user].add(1);
1298 
1299         updateStakeBalanceAndSupply(user, newBlessingBalance);
1300 
1301         // increase next purchase eligibility by an hour
1302         nextBlessingTime[user] = block.timestamp.add(3600);
1303 
1304         // increase global blessing price by 1%
1305         globalBlessPrice = globalBlessPrice.mul(101).div(100);
1306 
1307         lastBlessingTime = block.timestamp;
1308     }
1309 
1310     function updateGoddessBalanceAndSupply(address user) internal {
1311         // subtract existing balance from goddessSupply
1312         totalStakingBalance = totalStakingBalance.sub(stakeBalance[user]);
1313         // calculate and update new goddess balance (user's balance has been updated by parent method)
1314         // each blessing adds 5% to stake amount
1315         uint256 newGoddessBalance = balanceOf(user).mul(numBlessing[user].mul(5).add(100)).div(
1316             100
1317         );
1318         stakeBalance[user] = newGoddessBalance;
1319         // update totalStakingBalance
1320         totalStakingBalance = totalStakingBalance.add(newGoddessBalance);
1321     }
1322 
1323     function updateStakeBalanceAndSupply(address user, uint256 newBlessingBalance) private {
1324         totalStakingBalance = totalStakingBalance.sub(stakeBalance[user]);
1325 
1326         if (newBlessingBalance == 0) {
1327             newBlessingBalance = balanceOf(user);
1328         }
1329 
1330         stakeBalance[user] = newBlessingBalance;
1331 
1332         totalStakingBalance = totalStakingBalance.add(newBlessingBalance);
1333     }
1334 }
1335 
1336 // File: contracts/FragmentsPool.sol
1337 
1338 //SPDX-License-Identifier: MIT
1339 
1340 pragma solidity ^0.5.12;
1341 
1342 
1343 
1344 contract FragmentsPool is RewardsPool {
1345     IGoddessFragments public goddessFragments;
1346     uint256 public fragmentsPerWeek; // per max cap
1347     uint256 public fragmentsPerTokenStored;
1348     mapping(address => uint256) public fragments;
1349     mapping(address => uint256) public userFragmentsPerTokenPaid;
1350     uint256 public fragmentsLastUpdateTime;
1351 
1352     constructor(
1353         uint256 _tokenCapAmount,
1354         IERC20 _stakeToken,
1355         IERC20 _goddessToken,
1356         IUniswapRouter _uniswapRouter,
1357         uint256 _starttime,
1358         uint256 _duration,
1359         IGoddessFragments _goddessFragments
1360     )
1361         public
1362         RewardsPool(
1363             _tokenCapAmount,
1364             _stakeToken,
1365             _goddessToken,
1366             _uniswapRouter,
1367             _starttime,
1368             _duration
1369         )
1370     {
1371         goddessFragments = _goddessFragments;
1372     }
1373 
1374     modifier updateFragments(address account) {
1375         fragmentsPerTokenStored = fragmentsPerToken();
1376         fragmentsLastUpdateTime = block.timestamp;
1377         if (account != address(0)) {
1378             fragments[account] = fragmentsEarned(account);
1379             userFragmentsPerTokenPaid[account] = fragmentsPerTokenStored;
1380         }
1381         _;
1382     }
1383 
1384     function fragmentsPerToken() public view returns (uint256) {
1385         if (totalStakingBalance == 0) {
1386             return fragmentsPerTokenStored;
1387         }
1388         return
1389             fragmentsPerTokenStored.add(
1390                 block
1391                     .timestamp
1392                     .sub(lastUpdateTime)
1393                     .mul(fragmentsPerWeek)
1394                     .mul(1e18)
1395                     .div(604800)
1396                     .div(totalStakingBalance)
1397             );
1398     }
1399 
1400     function fragmentsEarned(address account) public view returns (uint256) {
1401         return
1402             stakeBalance[account]
1403                 .mul(fragmentsPerToken().sub(userFragmentsPerTokenPaid[account]))
1404                 .div(1e18)
1405                 .add(fragments[account]);
1406     }
1407 
1408     function stake(uint256 amount, address referrer) public updateFragments(msg.sender) {
1409         super.stake(amount, referrer);
1410     }
1411 
1412     function withdraw(uint256 amount) public updateFragments(msg.sender) {
1413         super.withdraw(amount);
1414     }
1415 
1416     function getReward() public updateFragments(msg.sender) {
1417         super.getReward();
1418         uint256 reward = fragmentsEarned(msg.sender);
1419         if (reward > 0) {
1420             goddessFragments.collectFragments(msg.sender, reward);
1421             fragments[msg.sender] = 0;
1422         }
1423     }
1424 
1425     function setFragmentsPerWeek(uint256 _fragmentsPerWeek)
1426         public
1427         updateFragments(address(0))
1428         onlyAdmin
1429     {
1430         fragmentsPerWeek = _fragmentsPerWeek;
1431     }
1432 
1433     function setGoddessFragments(address _goddessFragments) public onlyAdmin {
1434         goddessFragments = IGoddessFragments(_goddessFragments);
1435     }
1436 }