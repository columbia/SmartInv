1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
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
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
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
61      * Emits a {Transfer} event.
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
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/utils/PermissionGroups.sol
81 
82 //SPDX-License-Identifier: MIT
83 
84 pragma solidity ^0.5.12;
85 
86 contract PermissionGroups {
87     address public admin;
88     address public pendingAdmin;
89     mapping(address => bool) internal operators;
90     address[] internal operatorsGroup;
91     uint256 internal constant MAX_GROUP_SIZE = 50;
92 
93     constructor(address _admin) public {
94         require(_admin != address(0), "Admin 0");
95         admin = _admin;
96     }
97 
98     modifier onlyAdmin() {
99         require(msg.sender == admin, "Only admin");
100         _;
101     }
102 
103     modifier onlyOperator() {
104         require(operators[msg.sender], "Only operator");
105         _;
106     }
107 
108     function getOperators() external view returns (address[] memory) {
109         return operatorsGroup;
110     }
111 
112     event TransferAdminPending(address pendingAdmin);
113 
114     /**
115      * @dev Allows the current admin to set the pendingAdmin address.
116      * @param newAdmin The address to transfer ownership to.
117      */
118     function transferAdmin(address newAdmin) public onlyAdmin {
119         require(newAdmin != address(0), "New admin 0");
120         emit TransferAdminPending(newAdmin);
121         pendingAdmin = newAdmin;
122     }
123 
124     /**
125      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
126      * @param newAdmin The address to transfer ownership to.
127      */
128     function transferAdminQuickly(address newAdmin) public onlyAdmin {
129         require(newAdmin != address(0), "Admin 0");
130         emit TransferAdminPending(newAdmin);
131         emit AdminClaimed(newAdmin, admin);
132         admin = newAdmin;
133     }
134 
135     event AdminClaimed(address newAdmin, address previousAdmin);
136 
137     /**
138      * @dev Allows the pendingAdmin address to finalize the change admin process.
139      */
140     function claimAdmin() public {
141         require(pendingAdmin == msg.sender, "not pending");
142         emit AdminClaimed(pendingAdmin, admin);
143         admin = pendingAdmin;
144         pendingAdmin = address(0);
145     }
146 
147     event OperatorAdded(address newOperator, bool isAdd);
148 
149     function addOperator(address newOperator) public onlyAdmin {
150         require(!operators[newOperator], "Operator exists"); // prevent duplicates.
151         require(operatorsGroup.length < MAX_GROUP_SIZE, "Max operators");
152 
153         emit OperatorAdded(newOperator, true);
154         operators[newOperator] = true;
155         operatorsGroup.push(newOperator);
156     }
157 
158     function removeOperator(address operator) public onlyAdmin {
159         require(operators[operator], "Not operator");
160         operators[operator] = false;
161 
162         for (uint256 i = 0; i < operatorsGroup.length; ++i) {
163             if (operatorsGroup[i] == operator) {
164                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
165                 operatorsGroup.pop();
166                 emit OperatorAdded(operator, false);
167                 break;
168             }
169         }
170     }
171 }
172 
173 // File: contracts/utils/Withdrawable.sol
174 
175 //SPDX-License-Identifier: MIT
176 
177 pragma solidity ^0.5.12;
178 
179 
180 
181 contract Withdrawable is PermissionGroups {
182     bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
183 
184     mapping(address => bool) internal blacklist;
185 
186     event TokenWithdraw(address token, uint256 amount, address sendTo);
187 
188     event EtherWithdraw(uint256 amount, address sendTo);
189 
190     constructor(address _admin) public PermissionGroups(_admin) {}
191 
192     /**
193      * @dev Withdraw all IERC20 compatible tokens
194      * @param token IERC20 The address of the token contract
195      */
196     function withdrawToken(
197         address token,
198         uint256 amount,
199         address sendTo
200     ) external onlyAdmin {
201         require(!blacklist[address(token)], "forbid to withdraw that token");
202         _safeTransfer(token, sendTo, amount);
203         emit TokenWithdraw(token, amount, sendTo);
204     }
205 
206     /**
207      * @dev Withdraw Ethers
208      */
209     function withdrawEther(uint256 amount, address payable sendTo) external onlyAdmin {
210         (bool success, ) = sendTo.call.value(amount)("");
211         require(success);
212         emit EtherWithdraw(amount, sendTo);
213     }
214 
215     function setBlackList(address token) internal {
216         blacklist[token] = true;
217     }
218 
219     function _safeTransfer(
220         address token,
221         address to,
222         uint256 value
223     ) private {
224         (bool success, bytes memory data) = token.call(
225             abi.encodeWithSelector(SELECTOR, to, value)
226         );
227         require(success && (data.length == 0 || abi.decode(data, (bool))), "TRANSFER_FAILED");
228     }
229 }
230 
231 // File: contracts/interfaces/IUniswapRouter.sol
232 
233 //SPDX-License-Identifier: MIT
234 
235 pragma solidity ^0.5.12;
236 
237 interface IUniswapRouter {
238     function swapExactTokensForTokens(
239         uint256 amountIn,
240         uint256 amountOutMin,
241         address[] calldata path,
242         address to,
243         uint256 deadline
244     ) external returns (uint256[] memory amounts);
245 
246     function swapTokensForExactTokens(
247         uint256 amountOut,
248         uint256 amountInMax,
249         address[] calldata path,
250         address to,
251         uint256 deadline
252     ) external returns (uint256[] memory amounts);
253 
254     function WETH() external pure returns (address);
255 
256     function getAmountsIn(uint256 amountOut, address[] calldata path)
257         external
258         view
259         returns (uint256[] memory amounts);
260 }
261 
262 // File: contracts/interfaces/IGoddess.sol
263 
264 pragma solidity ^0.5.12;
265 
266 interface IGoddess {
267     function create(uint256 _maxSupply) external returns (uint256);
268 
269     function mint(
270         address _to,
271         uint256 _id,
272         uint256 _quantity,
273         bytes calldata _data
274     ) external;
275 
276     function burn(
277         address _from,
278         uint256 _id,
279         uint256 _amount
280     ) external;
281 
282     function totalSupply(uint256 _id) external view returns (uint256);
283 
284     function maxSupply(uint256 _id) external view returns (uint256);
285 
286     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
287 }
288 
289 // File: @openzeppelin/contracts/math/SafeMath.sol
290 
291 pragma solidity ^0.5.0;
292 
293 /**
294  * @dev Wrappers over Solidity's arithmetic operations with added overflow
295  * checks.
296  *
297  * Arithmetic operations in Solidity wrap on overflow. This can easily result
298  * in bugs, because programmers usually assume that an overflow raises an
299  * error, which is the standard behavior in high level programming languages.
300  * `SafeMath` restores this intuition by reverting the transaction when an
301  * operation overflows.
302  *
303  * Using this library instead of the unchecked operations eliminates an entire
304  * class of bugs, so it's recommended to use it always.
305  */
306 library SafeMath {
307     /**
308      * @dev Returns the addition of two unsigned integers, reverting on
309      * overflow.
310      *
311      * Counterpart to Solidity's `+` operator.
312      *
313      * Requirements:
314      * - Addition cannot overflow.
315      */
316     function add(uint256 a, uint256 b) internal pure returns (uint256) {
317         uint256 c = a + b;
318         require(c >= a, "SafeMath: addition overflow");
319 
320         return c;
321     }
322 
323     /**
324      * @dev Returns the subtraction of two unsigned integers, reverting on
325      * overflow (when the result is negative).
326      *
327      * Counterpart to Solidity's `-` operator.
328      *
329      * Requirements:
330      * - Subtraction cannot overflow.
331      */
332     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333         return sub(a, b, "SafeMath: subtraction overflow");
334     }
335 
336     /**
337      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
338      * overflow (when the result is negative).
339      *
340      * Counterpart to Solidity's `-` operator.
341      *
342      * Requirements:
343      * - Subtraction cannot overflow.
344      *
345      * _Available since v2.4.0._
346      */
347     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
348         require(b <= a, errorMessage);
349         uint256 c = a - b;
350 
351         return c;
352     }
353 
354     /**
355      * @dev Returns the multiplication of two unsigned integers, reverting on
356      * overflow.
357      *
358      * Counterpart to Solidity's `*` operator.
359      *
360      * Requirements:
361      * - Multiplication cannot overflow.
362      */
363     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
364         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
365         // benefit is lost if 'b' is also tested.
366         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
367         if (a == 0) {
368             return 0;
369         }
370 
371         uint256 c = a * b;
372         require(c / a == b, "SafeMath: multiplication overflow");
373 
374         return c;
375     }
376 
377     /**
378      * @dev Returns the integer division of two unsigned integers. Reverts on
379      * division by zero. The result is rounded towards zero.
380      *
381      * Counterpart to Solidity's `/` operator. Note: this function uses a
382      * `revert` opcode (which leaves remaining gas untouched) while Solidity
383      * uses an invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      * - The divisor cannot be zero.
387      */
388     function div(uint256 a, uint256 b) internal pure returns (uint256) {
389         return div(a, b, "SafeMath: division by zero");
390     }
391 
392     /**
393      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
394      * division by zero. The result is rounded towards zero.
395      *
396      * Counterpart to Solidity's `/` operator. Note: this function uses a
397      * `revert` opcode (which leaves remaining gas untouched) while Solidity
398      * uses an invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      * - The divisor cannot be zero.
402      *
403      * _Available since v2.4.0._
404      */
405     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
406         // Solidity only automatically asserts when dividing by 0
407         require(b > 0, errorMessage);
408         uint256 c = a / b;
409         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
410 
411         return c;
412     }
413 
414     /**
415      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
416      * Reverts when dividing by zero.
417      *
418      * Counterpart to Solidity's `%` operator. This function uses a `revert`
419      * opcode (which leaves remaining gas untouched) while Solidity uses an
420      * invalid opcode to revert (consuming all remaining gas).
421      *
422      * Requirements:
423      * - The divisor cannot be zero.
424      */
425     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
426         return mod(a, b, "SafeMath: modulo by zero");
427     }
428 
429     /**
430      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
431      * Reverts with custom message when dividing by zero.
432      *
433      * Counterpart to Solidity's `%` operator. This function uses a `revert`
434      * opcode (which leaves remaining gas untouched) while Solidity uses an
435      * invalid opcode to revert (consuming all remaining gas).
436      *
437      * Requirements:
438      * - The divisor cannot be zero.
439      *
440      * _Available since v2.4.0._
441      */
442     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
443         require(b != 0, errorMessage);
444         return a % b;
445     }
446 }
447 
448 // File: @openzeppelin/contracts/utils/Address.sol
449 
450 pragma solidity ^0.5.5;
451 
452 /**
453  * @dev Collection of functions related to the address type
454  */
455 library Address {
456     /**
457      * @dev Returns true if `account` is a contract.
458      *
459      * [IMPORTANT]
460      * ====
461      * It is unsafe to assume that an address for which this function returns
462      * false is an externally-owned account (EOA) and not a contract.
463      *
464      * Among others, `isContract` will return false for the following 
465      * types of addresses:
466      *
467      *  - an externally-owned account
468      *  - a contract in construction
469      *  - an address where a contract will be created
470      *  - an address where a contract lived, but was destroyed
471      * ====
472      */
473     function isContract(address account) internal view returns (bool) {
474         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
475         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
476         // for accounts without code, i.e. `keccak256('')`
477         bytes32 codehash;
478         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
479         // solhint-disable-next-line no-inline-assembly
480         assembly { codehash := extcodehash(account) }
481         return (codehash != accountHash && codehash != 0x0);
482     }
483 
484     /**
485      * @dev Converts an `address` into `address payable`. Note that this is
486      * simply a type cast: the actual underlying value is not changed.
487      *
488      * _Available since v2.4.0._
489      */
490     function toPayable(address account) internal pure returns (address payable) {
491         return address(uint160(account));
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      *
510      * _Available since v2.4.0._
511      */
512     function sendValue(address payable recipient, uint256 amount) internal {
513         require(address(this).balance >= amount, "Address: insufficient balance");
514 
515         // solhint-disable-next-line avoid-call-value
516         (bool success, ) = recipient.call.value(amount)("");
517         require(success, "Address: unable to send value, recipient may have reverted");
518     }
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
522 
523 pragma solidity ^0.5.0;
524 
525 
526 
527 
528 /**
529  * @title SafeERC20
530  * @dev Wrappers around ERC20 operations that throw on failure (when the token
531  * contract returns false). Tokens that return no value (and instead revert or
532  * throw on failure) are also supported, non-reverting calls are assumed to be
533  * successful.
534  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
535  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
536  */
537 library SafeERC20 {
538     using SafeMath for uint256;
539     using Address for address;
540 
541     function safeTransfer(IERC20 token, address to, uint256 value) internal {
542         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
543     }
544 
545     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
546         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
547     }
548 
549     function safeApprove(IERC20 token, address spender, uint256 value) internal {
550         // safeApprove should only be called when setting an initial allowance,
551         // or when resetting it to zero. To increase and decrease it, use
552         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
553         // solhint-disable-next-line max-line-length
554         require((value == 0) || (token.allowance(address(this), spender) == 0),
555             "SafeERC20: approve from non-zero to non-zero allowance"
556         );
557         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
558     }
559 
560     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
561         uint256 newAllowance = token.allowance(address(this), spender).add(value);
562         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
563     }
564 
565     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
566         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
567         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
568     }
569 
570     /**
571      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
572      * on the return value: the return value is optional (but if data is returned, it must not be false).
573      * @param token The token targeted by the call.
574      * @param data The call data (encoded using abi.encode or one of its variants).
575      */
576     function callOptionalReturn(IERC20 token, bytes memory data) private {
577         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
578         // we're implementing it ourselves.
579 
580         // A Solidity high level call has three parts:
581         //  1. The target address is checked to verify it contains contract code
582         //  2. The call itself is made, and success asserted
583         //  3. The return value is decoded, which in turn checks the size of the returned data.
584         // solhint-disable-next-line max-line-length
585         require(address(token).isContract(), "SafeERC20: call to non-contract");
586 
587         // solhint-disable-next-line avoid-low-level-calls
588         (bool success, bytes memory returndata) = address(token).call(data);
589         require(success, "SafeERC20: low-level call failed");
590 
591         if (returndata.length > 0) { // Return data is optional
592             // solhint-disable-next-line max-line-length
593             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
594         }
595     }
596 }
597 
598 // File: @openzeppelin/contracts/GSN/Context.sol
599 
600 pragma solidity ^0.5.0;
601 
602 /*
603  * @dev Provides information about the current execution context, including the
604  * sender of the transaction and its data. While these are generally available
605  * via msg.sender and msg.data, they should not be accessed in such a direct
606  * manner, since when dealing with GSN meta-transactions the account sending and
607  * paying for execution may not be the actual sender (as far as an application
608  * is concerned).
609  *
610  * This contract is only required for intermediate, library-like contracts.
611  */
612 contract Context {
613     // Empty internal constructor, to prevent people from mistakenly deploying
614     // an instance of this contract, which should be used via inheritance.
615     constructor () internal { }
616     // solhint-disable-previous-line no-empty-blocks
617 
618     function _msgSender() internal view returns (address payable) {
619         return msg.sender;
620     }
621 
622     function _msgData() internal view returns (bytes memory) {
623         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
624         return msg.data;
625     }
626 }
627 
628 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
629 
630 pragma solidity ^0.5.0;
631 
632 
633 
634 
635 /**
636  * @dev Implementation of the {IERC20} interface.
637  *
638  * This implementation is agnostic to the way tokens are created. This means
639  * that a supply mechanism has to be added in a derived contract using {_mint}.
640  * For a generic mechanism see {ERC20Mintable}.
641  *
642  * TIP: For a detailed writeup see our guide
643  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
644  * to implement supply mechanisms].
645  *
646  * We have followed general OpenZeppelin guidelines: functions revert instead
647  * of returning `false` on failure. This behavior is nonetheless conventional
648  * and does not conflict with the expectations of ERC20 applications.
649  *
650  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
651  * This allows applications to reconstruct the allowance for all accounts just
652  * by listening to said events. Other implementations of the EIP may not emit
653  * these events, as it isn't required by the specification.
654  *
655  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
656  * functions have been added to mitigate the well-known issues around setting
657  * allowances. See {IERC20-approve}.
658  */
659 contract ERC20 is Context, IERC20 {
660     using SafeMath for uint256;
661 
662     mapping (address => uint256) private _balances;
663 
664     mapping (address => mapping (address => uint256)) private _allowances;
665 
666     uint256 private _totalSupply;
667 
668     /**
669      * @dev See {IERC20-totalSupply}.
670      */
671     function totalSupply() public view returns (uint256) {
672         return _totalSupply;
673     }
674 
675     /**
676      * @dev See {IERC20-balanceOf}.
677      */
678     function balanceOf(address account) public view returns (uint256) {
679         return _balances[account];
680     }
681 
682     /**
683      * @dev See {IERC20-transfer}.
684      *
685      * Requirements:
686      *
687      * - `recipient` cannot be the zero address.
688      * - the caller must have a balance of at least `amount`.
689      */
690     function transfer(address recipient, uint256 amount) public returns (bool) {
691         _transfer(_msgSender(), recipient, amount);
692         return true;
693     }
694 
695     /**
696      * @dev See {IERC20-allowance}.
697      */
698     function allowance(address owner, address spender) public view returns (uint256) {
699         return _allowances[owner][spender];
700     }
701 
702     /**
703      * @dev See {IERC20-approve}.
704      *
705      * Requirements:
706      *
707      * - `spender` cannot be the zero address.
708      */
709     function approve(address spender, uint256 amount) public returns (bool) {
710         _approve(_msgSender(), spender, amount);
711         return true;
712     }
713 
714     /**
715      * @dev See {IERC20-transferFrom}.
716      *
717      * Emits an {Approval} event indicating the updated allowance. This is not
718      * required by the EIP. See the note at the beginning of {ERC20};
719      *
720      * Requirements:
721      * - `sender` and `recipient` cannot be the zero address.
722      * - `sender` must have a balance of at least `amount`.
723      * - the caller must have allowance for `sender`'s tokens of at least
724      * `amount`.
725      */
726     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
727         _transfer(sender, recipient, amount);
728         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
729         return true;
730     }
731 
732     /**
733      * @dev Atomically increases the allowance granted to `spender` by the caller.
734      *
735      * This is an alternative to {approve} that can be used as a mitigation for
736      * problems described in {IERC20-approve}.
737      *
738      * Emits an {Approval} event indicating the updated allowance.
739      *
740      * Requirements:
741      *
742      * - `spender` cannot be the zero address.
743      */
744     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
745         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
746         return true;
747     }
748 
749     /**
750      * @dev Atomically decreases the allowance granted to `spender` by the caller.
751      *
752      * This is an alternative to {approve} that can be used as a mitigation for
753      * problems described in {IERC20-approve}.
754      *
755      * Emits an {Approval} event indicating the updated allowance.
756      *
757      * Requirements:
758      *
759      * - `spender` cannot be the zero address.
760      * - `spender` must have allowance for the caller of at least
761      * `subtractedValue`.
762      */
763     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
764         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
765         return true;
766     }
767 
768     /**
769      * @dev Moves tokens `amount` from `sender` to `recipient`.
770      *
771      * This is internal function is equivalent to {transfer}, and can be used to
772      * e.g. implement automatic token fees, slashing mechanisms, etc.
773      *
774      * Emits a {Transfer} event.
775      *
776      * Requirements:
777      *
778      * - `sender` cannot be the zero address.
779      * - `recipient` cannot be the zero address.
780      * - `sender` must have a balance of at least `amount`.
781      */
782     function _transfer(address sender, address recipient, uint256 amount) internal {
783         require(sender != address(0), "ERC20: transfer from the zero address");
784         require(recipient != address(0), "ERC20: transfer to the zero address");
785 
786         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
787         _balances[recipient] = _balances[recipient].add(amount);
788         emit Transfer(sender, recipient, amount);
789     }
790 
791     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
792      * the total supply.
793      *
794      * Emits a {Transfer} event with `from` set to the zero address.
795      *
796      * Requirements
797      *
798      * - `to` cannot be the zero address.
799      */
800     function _mint(address account, uint256 amount) internal {
801         require(account != address(0), "ERC20: mint to the zero address");
802 
803         _totalSupply = _totalSupply.add(amount);
804         _balances[account] = _balances[account].add(amount);
805         emit Transfer(address(0), account, amount);
806     }
807 
808     /**
809      * @dev Destroys `amount` tokens from `account`, reducing the
810      * total supply.
811      *
812      * Emits a {Transfer} event with `to` set to the zero address.
813      *
814      * Requirements
815      *
816      * - `account` cannot be the zero address.
817      * - `account` must have at least `amount` tokens.
818      */
819     function _burn(address account, uint256 amount) internal {
820         require(account != address(0), "ERC20: burn from the zero address");
821 
822         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
823         _totalSupply = _totalSupply.sub(amount);
824         emit Transfer(account, address(0), amount);
825     }
826 
827     /**
828      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
829      *
830      * This is internal function is equivalent to `approve`, and can be used to
831      * e.g. set automatic allowances for certain subsystems, etc.
832      *
833      * Emits an {Approval} event.
834      *
835      * Requirements:
836      *
837      * - `owner` cannot be the zero address.
838      * - `spender` cannot be the zero address.
839      */
840     function _approve(address owner, address spender, uint256 amount) internal {
841         require(owner != address(0), "ERC20: approve from the zero address");
842         require(spender != address(0), "ERC20: approve to the zero address");
843 
844         _allowances[owner][spender] = amount;
845         emit Approval(owner, spender, amount);
846     }
847 
848     /**
849      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
850      * from the caller's allowance.
851      *
852      * See {_burn} and {_approve}.
853      */
854     function _burnFrom(address account, uint256 amount) internal {
855         _burn(account, amount);
856         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
857     }
858 }
859 
860 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
861 
862 pragma solidity ^0.5.0;
863 
864 
865 
866 /**
867  * @dev Extension of {ERC20} that allows token holders to destroy both their own
868  * tokens and those that they have an allowance for, in a way that can be
869  * recognized off-chain (via event analysis).
870  */
871 contract ERC20Burnable is Context, ERC20 {
872     /**
873      * @dev Destroys `amount` tokens from the caller.
874      *
875      * See {ERC20-_burn}.
876      */
877     function burn(uint256 amount) public {
878         _burn(_msgSender(), amount);
879     }
880 
881     /**
882      * @dev See {ERC20-_burnFrom}.
883      */
884     function burnFrom(address account, uint256 amount) public {
885         _burnFrom(account, amount);
886     }
887 }
888 
889 // File: contracts/GoddessFragments.sol
890 
891 //SPDX-License-Identifier: MIT
892 
893 pragma solidity ^0.5.12;
894 
895 
896 
897 
898 
899 
900 
901 
902 
903 contract GoddessFragments is Withdrawable {
904     using Address for address;
905     using SafeERC20 for IERC20;
906     using SafeMath for uint256;
907 
908     mapping(address => uint256) private fragments;
909     mapping(uint256 => uint256) public summonRequire;
910     mapping(uint256 => uint256) public fusionRequire;
911     mapping(uint256 => uint256) public nextLevel;
912     mapping(uint256 => address) public authors;
913 
914     uint256 public totalFragments;
915     uint256 public fusionFee;
916     uint256 public burnInBps;
917     uint256 public treasuryInBps;
918     IGoddess public goddess;
919     IERC20 public goddessToken;
920 
921     IUniswapRouter public uniswapRouter;
922     IERC20 public stablecoin;
923     address public treasury;
924 
925     constructor(
926         address _admin,
927         IERC20 _goddessToken,
928         address _goddess,
929         IUniswapRouter _uniswapRouter,
930         address _treasury
931     ) public Withdrawable(_admin) {
932         goddessToken = _goddessToken;
933         goddess = IGoddess(_goddess);
934         uniswapRouter = _uniswapRouter;
935         goddessToken.safeApprove(address(_uniswapRouter), 2**256 - 1);
936         treasury = _treasury;
937     }
938 
939     event GoddessAdded(uint256 goddessID, uint256 fragments);
940     event Staked(address indexed user, uint256 amount);
941     event FusionFee(
942         IERC20 stablecoin,
943         uint256 fusionFee,
944         uint256 burnInBps,
945         uint256 treasuryInBps
946     );
947 
948     function collectFragments(address user, uint256 amount) external onlyOperator {
949         totalFragments = totalFragments.add(amount);
950         fragments[user] = fragments[user].add(amount);
951     }
952 
953     function balanceOf(address user) external view returns (uint256) {
954         return fragments[user];
955     }
956 
957     function addGoddess(
958         uint256 maxQuantity,
959         uint256 numFragments,
960         address author
961     ) public onlyOperator {
962         uint256 goddessID = goddess.create(maxQuantity);
963         summonRequire[goddessID] = numFragments;
964         authors[goddessID] = author;
965         emit GoddessAdded(goddessID, numFragments);
966     }
967 
968     function addNextLevelGoddess(uint256 goddessID, uint256 fusionAmount)
969         public
970         onlyOperator
971         returns (uint256)
972     {
973         uint256 maxSupply = goddess.maxSupply(goddessID);
974         uint256 nextLevelMaxSupply = maxSupply.div(fusionAmount);
975         uint256 nextLevelID = goddess.create(nextLevelMaxSupply);
976         nextLevel[goddessID] = nextLevelID;
977         fusionRequire[goddessID] = fusionAmount;
978         authors[nextLevelID] = authors[goddessID];
979     }
980 
981     function summon(uint256 goddessID) public {
982         require(summonRequire[goddessID] != 0, "Goddess not found");
983         require(
984             fragments[msg.sender] >= summonRequire[goddessID],
985             "Not enough fragments to summon for goddess"
986         );
987         require(
988             goddess.totalSupply(goddessID) < goddess.maxSupply(goddessID),
989             "Max goddess summon"
990         );
991         fragments[msg.sender] = fragments[msg.sender].sub(summonRequire[goddessID]);
992         totalFragments.sub(summonRequire[goddessID]);
993         goddess.mint(msg.sender, goddessID, 1, "");
994     }
995 
996     function fusionFeeInGds() public view returns (uint256) {
997         address[] memory routeDetails = new address[](3);
998         routeDetails[0] = address(goddessToken);
999         routeDetails[1] = uniswapRouter.WETH();
1000         routeDetails[2] = address(stablecoin);
1001         uint256[] memory amounts = uniswapRouter.getAmountsIn(fusionFee, routeDetails);
1002         return amounts[0].mul(burnInBps.add(10000)).div(10000);
1003     }
1004 
1005     function fuse(uint256 goddessID) public {
1006         uint256 nextLevelID = nextLevel[goddessID];
1007         uint256 fusionAmount = fusionRequire[goddessID];
1008         require(nextLevelID != 0, "there is no higher level of this goddess");
1009         require(
1010             goddess.balanceOf(msg.sender, goddessID) >= fusionAmount,
1011             "not enough goddess for fusion"
1012         );
1013         require(address(stablecoin) != address(0), "stable coin not set");
1014 
1015         address[] memory routeDetails = new address[](3);
1016         routeDetails[0] = address(goddessToken);
1017         routeDetails[1] = uniswapRouter.WETH();
1018         routeDetails[2] = address(stablecoin);
1019         uint256[] memory amounts = uniswapRouter.getAmountsIn(fusionFee, routeDetails);
1020         uint256 burnAmount = amounts[0].mul(burnInBps).div(10000);
1021         goddessToken.safeTransferFrom(msg.sender, address(this), burnAmount.add(amounts[0]));
1022 
1023         // swap to stablecoin, transferred to author
1024         address author = authors[goddessID];
1025         uniswapRouter.swapTokensForExactTokens(
1026             fusionFee,
1027             amounts[0],
1028             routeDetails,
1029             address(this),
1030             block.timestamp + 100
1031         );
1032         if (treasury != address(0)) {
1033             uint256 treasuryAmount = fusionFee.mul(treasuryInBps).div(10000);
1034             stablecoin.safeTransfer(treasury, treasuryAmount);
1035             stablecoin.safeTransfer(author, fusionFee.sub(treasuryAmount));
1036         } else {
1037             stablecoin.safeTransfer(author, fusionFee);
1038         }
1039 
1040         ERC20Burnable burnableGoddessToken = ERC20Burnable(address(goddessToken));
1041         burnableGoddessToken.burn(burnAmount);
1042 
1043         goddess.burn(msg.sender, goddessID, fusionAmount);
1044         goddess.mint(msg.sender, nextLevelID, 1, "");
1045     }
1046 
1047     function setUniswapRouter(IUniswapRouter _uniswapRouter) external onlyAdmin {
1048         uniswapRouter = _uniswapRouter;
1049         goddessToken.safeApprove(address(_uniswapRouter), 2**256 - 1);
1050     }
1051 
1052     function setFusionFee(
1053         IERC20 _stablecoin,
1054         uint256 _fusionFee,
1055         uint256 _burnInBps,
1056         uint256 _treasuryInBps
1057     ) external onlyAdmin {
1058         stablecoin = _stablecoin;
1059         burnInBps = _burnInBps;
1060         fusionFee = _fusionFee;
1061         treasuryInBps = _treasuryInBps;
1062         emit FusionFee(stablecoin, fusionFee, burnInBps, treasuryInBps);
1063     }
1064 
1065     function setTreasury(address _treasury) external onlyAdmin {
1066         treasury = _treasury;
1067     }
1068 }