1 /***
2  *    ██████╗ ███████╗ ██████╗  ██████╗ 
3  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
4  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
5  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
6  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
7  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
8  *    
9  * https://dego.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 dego
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 // File: @openzeppelin/contracts/GSN/Context.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /*
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with GSN meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 contract Context {
48     // Empty internal constructor, to prevent people from mistakenly deploying
49     // an instance of this contract, which should be used via inheritance.
50     constructor () internal { }
51     // solhint-disable-previous-line no-empty-blocks
52 
53     function _msgSender() internal view returns (address payable) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view returns (bytes memory) {
58         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
59         return msg.data;
60     }
61 }
62 
63 // File: @openzeppelin/contracts/access/Roles.sol
64 
65 pragma solidity ^0.5.0;
66 
67 /**
68  * @title Roles
69  * @dev Library for managing addresses assigned to a Role.
70  */
71 library Roles {
72     struct Role {
73         mapping (address => bool) bearer;
74     }
75 
76     /**
77      * @dev Give an account access to this role.
78      */
79     function add(Role storage role, address account) internal {
80         require(!has(role, account), "Roles: account already has role");
81         role.bearer[account] = true;
82     }
83 
84     /**
85      * @dev Remove an account's access to this role.
86      */
87     function remove(Role storage role, address account) internal {
88         require(has(role, account), "Roles: account does not have role");
89         role.bearer[account] = false;
90     }
91 
92     /**
93      * @dev Check if an account has this role.
94      * @return bool
95      */
96     function has(Role storage role, address account) internal view returns (bool) {
97         require(account != address(0), "Roles: account is the zero address");
98         return role.bearer[account];
99     }
100 }
101 
102 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
103 
104 pragma solidity ^0.5.0;
105 
106 
107 
108 contract PauserRole is Context {
109     using Roles for Roles.Role;
110 
111     event PauserAdded(address indexed account);
112     event PauserRemoved(address indexed account);
113 
114     Roles.Role private _pausers;
115 
116     constructor () internal {
117         _addPauser(_msgSender());
118     }
119 
120     modifier onlyPauser() {
121         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
122         _;
123     }
124 
125     function isPauser(address account) public view returns (bool) {
126         return _pausers.has(account);
127     }
128 
129     function addPauser(address account) public onlyPauser {
130         _addPauser(account);
131     }
132 
133     function renouncePauser() public {
134         _removePauser(_msgSender());
135     }
136 
137     function _addPauser(address account) internal {
138         _pausers.add(account);
139         emit PauserAdded(account);
140     }
141 
142     function _removePauser(address account) internal {
143         _pausers.remove(account);
144         emit PauserRemoved(account);
145     }
146 }
147 
148 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
149 
150 pragma solidity ^0.5.0;
151 
152 
153 
154 /**
155  * @dev Contract module which allows children to implement an emergency stop
156  * mechanism that can be triggered by an authorized account.
157  *
158  * This module is used through inheritance. It will make available the
159  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
160  * the functions of your contract. Note that they will not be pausable by
161  * simply including this module, only once the modifiers are put in place.
162  */
163 contract Pausable is Context, PauserRole {
164     /**
165      * @dev Emitted when the pause is triggered by a pauser (`account`).
166      */
167     event Paused(address account);
168 
169     /**
170      * @dev Emitted when the pause is lifted by a pauser (`account`).
171      */
172     event Unpaused(address account);
173 
174     bool private _paused;
175 
176     /**
177      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
178      * to the deployer.
179      */
180     constructor () internal {
181         _paused = false;
182     }
183 
184     /**
185      * @dev Returns true if the contract is paused, and false otherwise.
186      */
187     function paused() public view returns (bool) {
188         return _paused;
189     }
190 
191     /**
192      * @dev Modifier to make a function callable only when the contract is not paused.
193      */
194     modifier whenNotPaused() {
195         require(!_paused, "Pausable: paused");
196         _;
197     }
198 
199     /**
200      * @dev Modifier to make a function callable only when the contract is paused.
201      */
202     modifier whenPaused() {
203         require(_paused, "Pausable: not paused");
204         _;
205     }
206 
207     /**
208      * @dev Called by a pauser to pause, triggers stopped state.
209      */
210     function pause() public onlyPauser whenNotPaused {
211         _paused = true;
212         emit Paused(_msgSender());
213     }
214 
215     /**
216      * @dev Called by a pauser to unpause, returns to normal state.
217      */
218     function unpause() public onlyPauser whenPaused {
219         _paused = false;
220         emit Unpaused(_msgSender());
221     }
222 }
223 
224 // File: @openzeppelin/contracts/ownership/Ownable.sol
225 
226 pragma solidity ^0.5.0;
227 
228 /**
229  * @dev Contract module which provides a basic access control mechanism, where
230  * there is an account (an owner) that can be granted exclusive access to
231  * specific functions.
232  *
233  * This module is used through inheritance. It will make available the modifier
234  * `onlyOwner`, which can be applied to your functions to restrict their use to
235  * the owner.
236  */
237 contract Ownable is Context {
238     address private _owner;
239 
240     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
241 
242     /**
243      * @dev Initializes the contract setting the deployer as the initial owner.
244      */
245     constructor () internal {
246         address msgSender = _msgSender();
247         _owner = msgSender;
248         emit OwnershipTransferred(address(0), msgSender);
249     }
250 
251     /**
252      * @dev Returns the address of the current owner.
253      */
254     function owner() public view returns (address) {
255         return _owner;
256     }
257 
258     /**
259      * @dev Throws if called by any account other than the owner.
260      */
261     modifier onlyOwner() {
262         require(isOwner(), "Ownable: caller is not the owner");
263         _;
264     }
265 
266     /**
267      * @dev Returns true if the caller is the current owner.
268      */
269     function isOwner() public view returns (bool) {
270         return _msgSender() == _owner;
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() public onlyOwner {
281         emit OwnershipTransferred(_owner, address(0));
282         _owner = address(0);
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public onlyOwner {
290         _transferOwnership(newOwner);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      */
296     function _transferOwnership(address newOwner) internal {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         emit OwnershipTransferred(_owner, newOwner);
299         _owner = newOwner;
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/Address.sol
304 
305 pragma solidity ^0.5.5;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following 
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      */
328     function isContract(address account) internal view returns (bool) {
329         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
330         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
331         // for accounts without code, i.e. `keccak256('')`
332         bytes32 codehash;
333         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
334         // solhint-disable-next-line no-inline-assembly
335         assembly { codehash := extcodehash(account) }
336         return (codehash != accountHash && codehash != 0x0);
337     }
338 
339     /**
340      * @dev Converts an `address` into `address payable`. Note that this is
341      * simply a type cast: the actual underlying value is not changed.
342      *
343      * _Available since v2.4.0._
344      */
345     function toPayable(address account) internal pure returns (address payable) {
346         return address(uint160(account));
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      *
365      * _Available since v2.4.0._
366      */
367     function sendValue(address payable recipient, uint256 amount) internal {
368         require(address(this).balance >= amount, "Address: insufficient balance");
369 
370         // solhint-disable-next-line avoid-call-value
371         (bool success, ) = recipient.call.value(amount)("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 }
375 
376 // File: @openzeppelin/contracts/math/SafeMath.sol
377 
378 pragma solidity ^0.5.0;
379 
380 /**
381  * @dev Wrappers over Solidity's arithmetic operations with added overflow
382  * checks.
383  *
384  * Arithmetic operations in Solidity wrap on overflow. This can easily result
385  * in bugs, because programmers usually assume that an overflow raises an
386  * error, which is the standard behavior in high level programming languages.
387  * `SafeMath` restores this intuition by reverting the transaction when an
388  * operation overflows.
389  *
390  * Using this library instead of the unchecked operations eliminates an entire
391  * class of bugs, so it's recommended to use it always.
392  */
393 library SafeMath {
394     /**
395      * @dev Returns the addition of two unsigned integers, reverting on
396      * overflow.
397      *
398      * Counterpart to Solidity's `+` operator.
399      *
400      * Requirements:
401      * - Addition cannot overflow.
402      */
403     function add(uint256 a, uint256 b) internal pure returns (uint256) {
404         uint256 c = a + b;
405         require(c >= a, "SafeMath: addition overflow");
406 
407         return c;
408     }
409 
410     /**
411      * @dev Returns the subtraction of two unsigned integers, reverting on
412      * overflow (when the result is negative).
413      *
414      * Counterpart to Solidity's `-` operator.
415      *
416      * Requirements:
417      * - Subtraction cannot overflow.
418      */
419     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
420         return sub(a, b, "SafeMath: subtraction overflow");
421     }
422 
423     /**
424      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
425      * overflow (when the result is negative).
426      *
427      * Counterpart to Solidity's `-` operator.
428      *
429      * Requirements:
430      * - Subtraction cannot overflow.
431      *
432      * _Available since v2.4.0._
433      */
434     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
435         require(b <= a, errorMessage);
436         uint256 c = a - b;
437 
438         return c;
439     }
440 
441     /**
442      * @dev Returns the multiplication of two unsigned integers, reverting on
443      * overflow.
444      *
445      * Counterpart to Solidity's `*` operator.
446      *
447      * Requirements:
448      * - Multiplication cannot overflow.
449      */
450     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
451         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
452         // benefit is lost if 'b' is also tested.
453         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
454         if (a == 0) {
455             return 0;
456         }
457 
458         uint256 c = a * b;
459         require(c / a == b, "SafeMath: multiplication overflow");
460 
461         return c;
462     }
463 
464     /**
465      * @dev Returns the integer division of two unsigned integers. Reverts on
466      * division by zero. The result is rounded towards zero.
467      *
468      * Counterpart to Solidity's `/` operator. Note: this function uses a
469      * `revert` opcode (which leaves remaining gas untouched) while Solidity
470      * uses an invalid opcode to revert (consuming all remaining gas).
471      *
472      * Requirements:
473      * - The divisor cannot be zero.
474      */
475     function div(uint256 a, uint256 b) internal pure returns (uint256) {
476         return div(a, b, "SafeMath: division by zero");
477     }
478 
479     /**
480      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
481      * division by zero. The result is rounded towards zero.
482      *
483      * Counterpart to Solidity's `/` operator. Note: this function uses a
484      * `revert` opcode (which leaves remaining gas untouched) while Solidity
485      * uses an invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      * - The divisor cannot be zero.
489      *
490      * _Available since v2.4.0._
491      */
492     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
493         // Solidity only automatically asserts when dividing by 0
494         require(b > 0, errorMessage);
495         uint256 c = a / b;
496         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
497 
498         return c;
499     }
500 
501     /**
502      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
503      * Reverts when dividing by zero.
504      *
505      * Counterpart to Solidity's `%` operator. This function uses a `revert`
506      * opcode (which leaves remaining gas untouched) while Solidity uses an
507      * invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      * - The divisor cannot be zero.
511      */
512     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
513         return mod(a, b, "SafeMath: modulo by zero");
514     }
515 
516     /**
517      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
518      * Reverts with custom message when dividing by zero.
519      *
520      * Counterpart to Solidity's `%` operator. This function uses a `revert`
521      * opcode (which leaves remaining gas untouched) while Solidity uses an
522      * invalid opcode to revert (consuming all remaining gas).
523      *
524      * Requirements:
525      * - The divisor cannot be zero.
526      *
527      * _Available since v2.4.0._
528      */
529     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
530         require(b != 0, errorMessage);
531         return a % b;
532     }
533 }
534 
535 // File: contracts/interface/IERC20.sol
536 
537 pragma solidity ^0.5.5;
538 
539 /**
540  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
541  * the optional functions; to access them see {ERC20Detailed}.
542  */
543 interface IERC20 {
544     /**
545      * @dev Returns the amount of tokens in existence.
546      */
547     function totalSupply() external view returns (uint256);
548 
549     /**
550      * @dev Returns the amount of tokens owned by `account`.
551      */
552     function balanceOf(address account) external view returns (uint256);
553 
554     /**
555      * @dev Moves `amount` tokens from the caller's account to `recipient`.
556      *
557      * Returns a boolean value indicating whether the operation succeeded.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transfer(address recipient, uint256 amount) external returns (bool);
562 
563     // add mint interface by dego
564     function mint(address account, uint amount) external;
565     /**
566      * @dev Returns the remaining number of tokens that `spender` will be
567      * allowed to spend on behalf of `owner` through {transferFrom}. This is
568      * zero by default.
569      *
570      * This value changes when {approve} or {transferFrom} are called.
571      */
572     function allowance(address owner, address spender) external view returns (uint256);
573 
574     /**
575      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
576      *
577      * Returns a boolean value indicating whether the operation succeeded.
578      *
579      * IMPORTANT: Beware that changing an allowance with this method brings the risk
580      * that someone may use both the old and the new allowance by unfortunate
581      * transaction ordering. One possible solution to mitigate this race
582      * condition is to first reduce the spender's allowance to 0 and set the
583      * desired value afterwards:
584      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
585      *
586      * Emits an {Approval} event.
587      */
588     function approve(address spender, uint256 amount) external returns (bool);
589 
590     /**
591      * @dev Moves `amount` tokens from `sender` to `recipient` using the
592      * allowance mechanism. `amount` is then deducted from the caller's
593      * allowance.
594      *
595      * Returns a boolean value indicating whether the operation succeeded.
596      *
597      * Emits a {Transfer} event.
598      */
599     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
600 
601     /**
602      * @dev Emitted when `value` tokens are moved from one account (`from`) to
603      * another (`to`).
604      *
605      * Note that `value` may be zero.
606      */
607     event Transfer(address indexed from, address indexed to, uint256 value);
608 
609     /**
610      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
611      * a call to {approve}. `value` is the new allowance.
612      */
613     event Approval(address indexed owner, address indexed spender, uint256 value);
614 }
615 
616 // File: contracts/library/SafeERC20.sol
617 
618 pragma solidity ^0.5.5;
619 
620 
621 
622 
623 
624 /**
625  * @title SafeERC20
626  * @dev Wrappers around ERC20 operations that throw on failure (when the token
627  * contract returns false). Tokens that return no value (and instead revert or
628  * throw on failure) are also supported, non-reverting calls are assumed to be
629  * successful.
630  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
631  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
632  */
633 library SafeERC20 {
634     using SafeMath for uint256;
635     using Address for address;
636 
637     function safeTransfer(IERC20 token, address to, uint256 value) internal {
638         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
639     }
640 
641     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
642         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
643     }
644 
645     function safeApprove(IERC20 token, address spender, uint256 value) internal {
646         // safeApprove should only be called when setting an initial allowance,
647         // or when resetting it to zero. To increase and decrease it, use
648         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
649         // solhint-disable-next-line max-line-length
650         require((value == 0) || (token.allowance(address(this), spender) == 0),
651             "SafeERC20: approve from non-zero to non-zero allowance"
652         );
653         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
654     }
655 
656     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
657         uint256 newAllowance = token.allowance(address(this), spender).add(value);
658         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
659     }
660 
661     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
662         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
663         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
664     }
665 
666     /**
667      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
668      * on the return value: the return value is optional (but if data is returned, it must not be false).
669      * @param token The token targeted by the call.
670      * @param data The call data (encoded using abi.encode or one of its variants).
671      */
672     function callOptionalReturn(IERC20 token, bytes memory data) private {
673         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
674         // we're implementing it ourselves.
675 
676         // A Solidity high level call has three parts:
677         //  1. The target address is checked to verify it contains contract code
678         //  2. The call itself is made, and success asserted
679         //  3. The return value is decoded, which in turn checks the size of the returned data.
680         // solhint-disable-next-line max-line-length
681         require(address(token).isContract(), "SafeERC20: call to non-contract");
682 
683         // solhint-disable-next-line avoid-low-level-calls
684         (bool success, bytes memory returndata) = address(token).call(data);
685         require(success, "SafeERC20: low-level call failed");
686 
687         if (returndata.length > 0) { // Return data is optional
688             // solhint-disable-next-line max-line-length
689             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
690         }
691     }
692 }
693 
694 // File: contracts/token/DegoOpenSale.sol
695 
696 pragma solidity ^0.5.5;
697 
698 
699 
700 
701 
702 
703 
704 /// @title DegoOpenSale Contract
705 
706 contract DegoOpenSale is Pausable,Ownable {
707     using SafeMath for uint256;
708     using Address for address;
709 
710     struct condition {
711         uint256 price;          //_dego per eth
712         uint256 limitFund;      //a quota
713         uint256 startTime;      //the stage start time
714         uint256 maxSoldAmount;  //the stage max sold amount
715     }
716 
717     //
718     uint8 public constant _whiteListStage1 = 1;
719     uint8 public constant _whiteListStage5 = 5;
720     //
721     /// All deposited ETH will be instantly forwarded to this address.
722     address payable public _teamWallet = 0x20FE4B1eD95911487499e53355BB8f14a881D735;
723     
724     /// IERC20 compilant _dego token contact instance
725     IERC20 public _dego = IERC20(0x88EF27e69108B2633F8E1C184CC37940A075cC02);
726 
727     /// tags show address can join in open sale
728     mapping (uint8 =>  mapping (address => bool)) public _fullWhiteList;
729 
730     //the stage condition map
731     mapping (uint8 => condition) public _stageCondition;
732 
733     //the user get fund per stage
734     mapping (uint8 =>  mapping (address => uint256) ) public _stageFund;
735 
736 
737     //the stage had sold amount
738     mapping (uint8 => uint256) public _stageSoldAmount;
739     
740     /*
741      * EVENTS
742      */
743     event eveNewSale(address indexed destAddress, uint256 ethCost, uint256 gotTokens);
744     event eveClaim(address indexed destAddress, uint256 gotTokens);
745     event eveTeamWallet(address wallet);
746 
747 
748 
749     /// @dev valid the address
750     modifier validAddress( address addr ) {
751         require(addr != address(0x0));
752         require(addr != address(this));
753         _;
754     }
755 
756     constructor()
757         public
758     {
759         pause();
760 
761         setCondition(1,3500 ,10*1e18, now,          525000*1e18);
762         setCondition(2,2500 ,5 *1e18, now + 7 days, 375000*1e18);
763         setCondition(3,2000 ,5 *1e18, now + 7 days, 600000*1e18);
764         setCondition(4,1500 ,5 *1e18, now + 7 days, 450000*1e18);
765         setCondition(5,1500 ,2 *1e18, now + 14 days, 150000*1e18);
766         
767     }
768 
769 
770     /**
771     * @dev for set team wallet
772     */
773     function setTeamWallet(address payable wallet) public 
774         onlyOwner 
775     {
776         require(wallet != address(0x0));
777 
778         _teamWallet = wallet;
779 
780         emit eveTeamWallet(wallet);
781     }
782 
783     /// @dev set the sale condition for every stage;
784     function setCondition(
785     uint8 stage,
786     uint256 price,
787     uint256 limitFund,
788     uint256 startTime,
789     uint256 maxSoldAmount )
790         internal
791         onlyOwner
792     {
793 
794         _stageCondition[stage].price = price;
795         _stageCondition[stage].limitFund =limitFund;
796         _stageCondition[stage].startTime= startTime;
797         _stageCondition[stage].maxSoldAmount=maxSoldAmount;
798     }
799 
800 
801 
802     /// @dev set the sale start time for every stage;
803     function setStartTime(uint8 stage,uint256 startTime )
804         public
805         onlyOwner
806     {
807         _stageCondition[stage].startTime = startTime;
808     }
809 
810     /// @dev batch set quota for user admin
811     /// if openTag <=0, removed 
812     function setWhiteList(uint8 stage, address[] calldata users, bool openTag)
813         external
814         onlyOwner
815     {
816         for (uint256 i = 0; i < users.length; i++) {
817             _fullWhiteList[stage][users[i]] = openTag;
818         }
819     }
820 
821     /// @dev batch set quota for early user quota
822     /// if openTag <=0, removed 
823     function addWhiteList(uint8 stage, address user, bool openTag)
824         external
825         onlyOwner
826     {
827         _fullWhiteList[stage][user] = openTag;
828     }
829 
830     /**
831      * @dev If anybody sends Ether directly to this  contract, consider he is getting DeGo token
832      */
833     function () external payable {
834         buyDeGo(msg.sender);
835     }
836 
837     //
838     function getStage( ) view public returns(uint8) {
839 
840         for(uint8 i=1; i<6; i++){
841             uint256 startTime = _stageCondition[i].startTime;
842             if(now >= startTime && _stageSoldAmount[i] < _stageCondition[i].maxSoldAmount ){
843                 return i;
844             }
845         }
846 
847         return 0;
848     }
849 
850     //
851     function conditionCheck( address addr ) view internal  returns(uint8) {
852     
853         uint8 stage = getStage();
854         require(stage!=0,"stage not begin");
855         
856         uint256 fund = _stageFund[stage][addr];
857         require(fund < _stageCondition[stage].limitFund,"stage fund is full ");
858 
859         return stage;
860     }
861 
862     /// @dev Exchange msg.value ether to Dego for account recepient
863     /// @param receipient Dego tokens receiver
864     function buyDeGo(address receipient) 
865         internal 
866         whenNotPaused  
867         validAddress(receipient)
868         returns (bool) 
869     {
870         // Do not allow contracts to game the system
871 
872         require(tx.gasprice <= 1000000000000 wei);
873 
874         uint8 stage = conditionCheck(receipient);
875         if(stage==_whiteListStage1 || stage==_whiteListStage5 ){  
876             require(_fullWhiteList[stage][receipient],"your are not in the whitelist ");
877         }
878 
879         doBuy(receipient, stage);
880 
881         return true;
882     }
883 
884 
885     /// @dev Buy DeGo token normally
886     function doBuy(address receipient, uint8 stage) internal {
887         // protect partner quota in stage one
888         uint256 value = msg.value;
889         uint256 fund = _stageFund[stage][receipient];
890         fund = fund.add(value);
891         if (fund > _stageCondition[stage].limitFund ) {
892             uint256 refund = fund.sub(_stageCondition[stage].limitFund);
893             value = value.sub(refund);
894             msg.sender.transfer(refund);
895         }
896         
897         uint256 soldAmount = _stageSoldAmount[stage];
898         uint256 tokenAvailable = _stageCondition[stage].maxSoldAmount.sub(soldAmount);
899         require(tokenAvailable > 0);
900 
901         uint256 costValue = 0;
902         uint256 getTokens = 0;
903 
904         // all conditions has checked in the caller functions
905         uint256 price = _stageCondition[stage].price;
906         getTokens = price * value;
907         if (tokenAvailable >= getTokens) {
908             costValue = value;
909         } else {
910             costValue = tokenAvailable.div(price);
911             getTokens = tokenAvailable;
912         }
913 
914         if (costValue > 0) {
915         
916             _stageSoldAmount[stage] = _stageSoldAmount[stage].add(getTokens);
917             _stageFund[stage][receipient]=_stageFund[stage][receipient].add(costValue);
918 
919             _dego.mint(msg.sender, getTokens);   
920 
921             emit eveNewSale(receipient, costValue, getTokens);             
922         }
923 
924         // not enough token sale, just return eth
925         uint256 toReturn = value.sub(costValue);
926         if (toReturn > 0) {
927             msg.sender.transfer(toReturn);
928         }
929 
930     }
931 
932     // get sale eth 
933     function seizeEth() external  {
934         uint256 _currentBalance =  address(this).balance;
935         _teamWallet.transfer(_currentBalance);
936     }
937     
938 
939 }
