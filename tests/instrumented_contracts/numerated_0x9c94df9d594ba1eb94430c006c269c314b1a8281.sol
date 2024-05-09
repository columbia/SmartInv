1 /*
2  * Origin Protocol
3  * https://originprotocol.com
4  *
5  * Released under the MIT license
6  * https://github.com/OriginProtocol/origin-dollar
7  *
8  * Copyright 2020 Origin Protocol, Inc
9  *
10  * Permission is hereby granted, free of charge, to any person obtaining a copy
11  * of this software and associated documentation files (the "Software"), to deal
12  * in the Software without restriction, including without limitation the rights
13  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14  * copies of the Software, and to permit persons to whom the Software is
15  * furnished to do so, subject to the following conditions:
16  *
17  * The above copyright notice and this permission notice shall be included in
18  * all copies or substantial portions of the Software.
19  *
20  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
23  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
24  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
26  * SOFTWARE.
27  */
28 // File: @openzeppelin/upgrades/contracts/Initializable.sol
29 
30 pragma solidity >=0.4.24 <0.7.0;
31 
32 
33 /**
34  * @title Initializable
35  *
36  * @dev Helper contract to support initializer functions. To use it, replace
37  * the constructor with a function that has the `initializer` modifier.
38  * WARNING: Unlike constructors, initializer functions must be manually
39  * invoked. This applies both to deploying an Initializable contract, as well
40  * as extending an Initializable contract via inheritance.
41  * WARNING: When used with inheritance, manual care must be taken to not invoke
42  * a parent initializer twice, or ensure that all initializers are idempotent,
43  * because this is not dealt with automatically as with constructors.
44  */
45 contract Initializable {
46 
47   /**
48    * @dev Indicates that the contract has been initialized.
49    */
50   bool private initialized;
51 
52   /**
53    * @dev Indicates that the contract is in the process of being initialized.
54    */
55   bool private initializing;
56 
57   /**
58    * @dev Modifier to use in the initializer function of a contract.
59    */
60   modifier initializer() {
61     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
62 
63     bool isTopLevelCall = !initializing;
64     if (isTopLevelCall) {
65       initializing = true;
66       initialized = true;
67     }
68 
69     _;
70 
71     if (isTopLevelCall) {
72       initializing = false;
73     }
74   }
75 
76   /// @dev Returns true if and only if the function is running in the constructor
77   function isConstructor() private view returns (bool) {
78     // extcodesize checks the size of the code stored in an address, and
79     // address returns the current address. Since the code is still not
80     // deployed when running a constructor, any checks on its code size will
81     // yield zero, making it an effective way to detect if a contract is
82     // under construction or not.
83     address self = address(this);
84     uint256 cs;
85     assembly { cs := extcodesize(self) }
86     return cs == 0;
87   }
88 
89   // Reserved storage space to allow for layout changes in the future.
90   uint256[50] private ______gap;
91 }
92 
93 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
94 
95 pragma solidity ^0.5.0;
96 
97 /**
98  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
99  * the optional functions; to access them see {ERC20Detailed}.
100  */
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 // File: @openzeppelin/contracts/math/SafeMath.sol
173 
174 pragma solidity ^0.5.0;
175 
176 /**
177  * @dev Wrappers over Solidity's arithmetic operations with added overflow
178  * checks.
179  *
180  * Arithmetic operations in Solidity wrap on overflow. This can easily result
181  * in bugs, because programmers usually assume that an overflow raises an
182  * error, which is the standard behavior in high level programming languages.
183  * `SafeMath` restores this intuition by reverting the transaction when an
184  * operation overflows.
185  *
186  * Using this library instead of the unchecked operations eliminates an entire
187  * class of bugs, so it's recommended to use it always.
188  */
189 library SafeMath {
190     /**
191      * @dev Returns the addition of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `+` operator.
195      *
196      * Requirements:
197      * - Addition cannot overflow.
198      */
199     function add(uint256 a, uint256 b) internal pure returns (uint256) {
200         uint256 c = a + b;
201         require(c >= a, "SafeMath: addition overflow");
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the subtraction of two unsigned integers, reverting on
208      * overflow (when the result is negative).
209      *
210      * Counterpart to Solidity's `-` operator.
211      *
212      * Requirements:
213      * - Subtraction cannot overflow.
214      */
215     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216         return sub(a, b, "SafeMath: subtraction overflow");
217     }
218 
219     /**
220      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
221      * overflow (when the result is negative).
222      *
223      * Counterpart to Solidity's `-` operator.
224      *
225      * Requirements:
226      * - Subtraction cannot overflow.
227      *
228      * _Available since v2.4.0._
229      */
230     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b <= a, errorMessage);
232         uint256 c = a - b;
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the multiplication of two unsigned integers, reverting on
239      * overflow.
240      *
241      * Counterpart to Solidity's `*` operator.
242      *
243      * Requirements:
244      * - Multiplication cannot overflow.
245      */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
248         // benefit is lost if 'b' is also tested.
249         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
250         if (a == 0) {
251             return 0;
252         }
253 
254         uint256 c = a * b;
255         require(c / a == b, "SafeMath: multiplication overflow");
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers. Reverts on
262      * division by zero. The result is rounded towards zero.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return div(a, b, "SafeMath: division by zero");
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      * - The divisor cannot be zero.
285      *
286      * _Available since v2.4.0._
287      */
288     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         // Solidity only automatically asserts when dividing by 0
290         require(b > 0, errorMessage);
291         uint256 c = a / b;
292         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
293 
294         return c;
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * Reverts when dividing by zero.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      * - The divisor cannot be zero.
307      */
308     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
309         return mod(a, b, "SafeMath: modulo by zero");
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * Reverts with custom message when dividing by zero.
315      *
316      * Counterpart to Solidity's `%` operator. This function uses a `revert`
317      * opcode (which leaves remaining gas untouched) while Solidity uses an
318      * invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      * - The divisor cannot be zero.
322      *
323      * _Available since v2.4.0._
324      */
325     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
326         require(b != 0, errorMessage);
327         return a % b;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/utils/Address.sol
332 
333 pragma solidity ^0.5.5;
334 
335 /**
336  * @dev Collection of functions related to the address type
337  */
338 library Address {
339     /**
340      * @dev Returns true if `account` is a contract.
341      *
342      * [IMPORTANT]
343      * ====
344      * It is unsafe to assume that an address for which this function returns
345      * false is an externally-owned account (EOA) and not a contract.
346      *
347      * Among others, `isContract` will return false for the following 
348      * types of addresses:
349      *
350      *  - an externally-owned account
351      *  - a contract in construction
352      *  - an address where a contract will be created
353      *  - an address where a contract lived, but was destroyed
354      * ====
355      */
356     function isContract(address account) internal view returns (bool) {
357         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
358         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
359         // for accounts without code, i.e. `keccak256('')`
360         bytes32 codehash;
361         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
362         // solhint-disable-next-line no-inline-assembly
363         assembly { codehash := extcodehash(account) }
364         return (codehash != accountHash && codehash != 0x0);
365     }
366 
367     /**
368      * @dev Converts an `address` into `address payable`. Note that this is
369      * simply a type cast: the actual underlying value is not changed.
370      *
371      * _Available since v2.4.0._
372      */
373     function toPayable(address account) internal pure returns (address payable) {
374         return address(uint160(account));
375     }
376 
377     /**
378      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
379      * `recipient`, forwarding all available gas and reverting on errors.
380      *
381      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
382      * of certain opcodes, possibly making contracts go over the 2300 gas limit
383      * imposed by `transfer`, making them unable to receive funds via
384      * `transfer`. {sendValue} removes this limitation.
385      *
386      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
387      *
388      * IMPORTANT: because control is transferred to `recipient`, care must be
389      * taken to not create reentrancy vulnerabilities. Consider using
390      * {ReentrancyGuard} or the
391      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
392      *
393      * _Available since v2.4.0._
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(address(this).balance >= amount, "Address: insufficient balance");
397 
398         // solhint-disable-next-line avoid-call-value
399         (bool success, ) = recipient.call.value(amount)("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 }
403 
404 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
405 
406 pragma solidity ^0.5.0;
407 
408 
409 
410 /**
411  * @title SafeERC20
412  * @dev Wrappers around ERC20 operations that throw on failure (when the token
413  * contract returns false). Tokens that return no value (and instead revert or
414  * throw on failure) are also supported, non-reverting calls are assumed to be
415  * successful.
416  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
417  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
418  */
419 library SafeERC20 {
420     using SafeMath for uint256;
421     using Address for address;
422 
423     function safeTransfer(IERC20 token, address to, uint256 value) internal {
424         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
425     }
426 
427     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
428         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
429     }
430 
431     function safeApprove(IERC20 token, address spender, uint256 value) internal {
432         // safeApprove should only be called when setting an initial allowance,
433         // or when resetting it to zero. To increase and decrease it, use
434         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
435         // solhint-disable-next-line max-line-length
436         require((value == 0) || (token.allowance(address(this), spender) == 0),
437             "SafeERC20: approve from non-zero to non-zero allowance"
438         );
439         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
440     }
441 
442     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).add(value);
444         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
449         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450     }
451 
452     /**
453      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
454      * on the return value: the return value is optional (but if data is returned, it must not be false).
455      * @param token The token targeted by the call.
456      * @param data The call data (encoded using abi.encode or one of its variants).
457      */
458     function callOptionalReturn(IERC20 token, bytes memory data) private {
459         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
460         // we're implementing it ourselves.
461 
462         // A Solidity high level call has three parts:
463         //  1. The target address is checked to verify it contains contract code
464         //  2. The call itself is made, and success asserted
465         //  3. The return value is decoded, which in turn checks the size of the returned data.
466         // solhint-disable-next-line max-line-length
467         require(address(token).isContract(), "SafeERC20: call to non-contract");
468 
469         // solhint-disable-next-line avoid-low-level-calls
470         (bool success, bytes memory returndata) = address(token).call(data);
471         require(success, "SafeERC20: low-level call failed");
472 
473         if (returndata.length > 0) { // Return data is optional
474             // solhint-disable-next-line max-line-length
475             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
476         }
477     }
478 }
479 
480 // File: contracts/governance/Governable.sol
481 
482 pragma solidity 0.5.11;
483 
484 /**
485  * @title OUSD Governable Contract
486  * @dev Copy of the openzeppelin Ownable.sol contract with nomenclature change
487  *      from owner to governor and renounce methods removed. Does not use
488  *      Context.sol like Ownable.sol does for simplification.
489  * @author Origin Protocol Inc
490  */
491 contract Governable {
492     // Storage position of the owner and pendingOwner of the contract
493     // keccak256("OUSD.governor");
494     bytes32
495         private constant governorPosition = 0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;
496 
497     // keccak256("OUSD.pending.governor");
498     bytes32
499         private constant pendingGovernorPosition = 0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;
500 
501     // keccak256("OUSD.reentry.status");
502     bytes32
503         private constant reentryStatusPosition = 0x53bf423e48ed90e97d02ab0ebab13b2a235a6bfbe9c321847d5c175333ac4535;
504 
505     // See OpenZeppelin ReentrancyGuard implementation
506     uint256 constant _NOT_ENTERED = 1;
507     uint256 constant _ENTERED = 2;
508 
509     event PendingGovernorshipTransfer(
510         address indexed previousGovernor,
511         address indexed newGovernor
512     );
513 
514     event GovernorshipTransferred(
515         address indexed previousGovernor,
516         address indexed newGovernor
517     );
518 
519     /**
520      * @dev Initializes the contract setting the deployer as the initial Governor.
521      */
522     constructor() internal {
523         _setGovernor(msg.sender);
524         emit GovernorshipTransferred(address(0), _governor());
525     }
526 
527     /**
528      * @dev Returns the address of the current Governor.
529      */
530     function governor() public view returns (address) {
531         return _governor();
532     }
533 
534     /**
535      * @dev Returns the address of the current Governor.
536      */
537     function _governor() internal view returns (address governorOut) {
538         bytes32 position = governorPosition;
539         assembly {
540             governorOut := sload(position)
541         }
542     }
543 
544     /**
545      * @dev Returns the address of the pending Governor.
546      */
547     function _pendingGovernor()
548         internal
549         view
550         returns (address pendingGovernor)
551     {
552         bytes32 position = pendingGovernorPosition;
553         assembly {
554             pendingGovernor := sload(position)
555         }
556     }
557 
558     /**
559      * @dev Throws if called by any account other than the Governor.
560      */
561     modifier onlyGovernor() {
562         require(isGovernor(), "Caller is not the Governor");
563         _;
564     }
565 
566     /**
567      * @dev Returns true if the caller is the current Governor.
568      */
569     function isGovernor() public view returns (bool) {
570         return msg.sender == _governor();
571     }
572 
573     function _setGovernor(address newGovernor) internal {
574         bytes32 position = governorPosition;
575         assembly {
576             sstore(position, newGovernor)
577         }
578     }
579 
580     /**
581      * @dev Prevents a contract from calling itself, directly or indirectly.
582      * Calling a `nonReentrant` function from another `nonReentrant`
583      * function is not supported. It is possible to prevent this from happening
584      * by making the `nonReentrant` function external, and make it call a
585      * `private` function that does the actual work.
586      */
587     modifier nonReentrant() {
588         bytes32 position = reentryStatusPosition;
589         uint256 _reentry_status;
590         assembly {
591             _reentry_status := sload(position)
592         }
593 
594         // On the first call to nonReentrant, _notEntered will be true
595         require(_reentry_status != _ENTERED, "Reentrant call");
596 
597         // Any calls to nonReentrant after this point will fail
598         assembly {
599             sstore(position, _ENTERED)
600         }
601 
602         _;
603 
604         // By storing the original value once again, a refund is triggered (see
605         // https://eips.ethereum.org/EIPS/eip-2200)
606         assembly {
607             sstore(position, _NOT_ENTERED)
608         }
609     }
610 
611     function _setPendingGovernor(address newGovernor) internal {
612         bytes32 position = pendingGovernorPosition;
613         assembly {
614             sstore(position, newGovernor)
615         }
616     }
617 
618     /**
619      * @dev Transfers Governance of the contract to a new account (`newGovernor`).
620      * Can only be called by the current Governor. Must be claimed for this to complete
621      * @param _newGovernor Address of the new Governor
622      */
623     function transferGovernance(address _newGovernor) external onlyGovernor {
624         _setPendingGovernor(_newGovernor);
625         emit PendingGovernorshipTransfer(_governor(), _newGovernor);
626     }
627 
628     /**
629      * @dev Claim Governance of the contract to a new account (`newGovernor`).
630      * Can only be called by the new Governor.
631      */
632     function claimGovernance() external {
633         require(
634             msg.sender == _pendingGovernor(),
635             "Only the pending Governor can complete the claim"
636         );
637         _changeGovernor(msg.sender);
638     }
639 
640     /**
641      * @dev Change Governance of the contract to a new account (`newGovernor`).
642      * @param _newGovernor Address of the new Governor
643      */
644     function _changeGovernor(address _newGovernor) internal {
645         require(_newGovernor != address(0), "New Governor is address(0)");
646         emit GovernorshipTransferred(_governor(), _newGovernor);
647         _setGovernor(_newGovernor);
648     }
649 }
650 
651 // File: contracts/compensation/CompensationClaims.sol
652 
653 pragma solidity 0.5.11;
654 
655 
656 
657 
658 
659 /**
660  * @title Compensation Claims
661  * @author Origin Protocol Inc
662  * @dev Airdrop for ERC20 tokens.
663  *
664  *   Provides a coin airdrop with a verification period in which everyone
665  *   can check that all claims are correct before any actual funds are moved
666  *   to the contract.
667  *
668  *      - Users can claim funds during the claim period.
669  *
670  *      - The adjuster can set the amount of each user's claim,
671  *         but only when unlocked, and not during the claim period.
672  *
673  *      - The governor can unlock and lock the adjuster, outside the claim period.
674  *      - The governor can start the claim period, if it's not started.
675  *      - The governor can collect any remaining funds after the claim period is over.
676  *
677  *  Intended use sequence:
678  *
679  *   1. Governor unlocks the adjuster
680  *   2. Adjuster uploads claims
681  *   3. Governor locks the adjuster
682  *   4. Everyone verifies that the claim amounts and totals are correct
683  *   5. Payout funds are moved to the contract
684  *   6. The claim period starts
685  *   7. Users claim funds
686  *   8. The claim period ends
687  *   9. Governor can collect any remaing funds
688  *
689  */
690 contract CompensationClaims is Governable {
691     address public adjuster;
692     address public token;
693     uint256 public end;
694     uint256 public totalClaims;
695     mapping(address => uint256) claims;
696     bool public isAdjusterLocked;
697 
698     using SafeMath for uint256;
699 
700     event Claim(address indexed recipient, uint256 amount);
701     event ClaimSet(address indexed recipient, uint256 amount);
702     event Start(uint256 end);
703     event Lock();
704     event Unlock();
705     event Collect(address indexed coin, uint256 amount);
706 
707     constructor(address _token, address _adjuster) public onlyGovernor {
708         token = _token;
709         adjuster = _adjuster;
710         isAdjusterLocked = true;
711     }
712 
713     function balanceOf(address _account) external view returns (uint256) {
714         return claims[_account];
715     }
716 
717     function decimals() external view returns (uint8) {
718         return IERC20Decimals(token).decimals();
719     }
720 
721     /* -- User -- */
722 
723     function claim(address _recipient) external onlyInClaimPeriod nonReentrant {
724         uint256 amount = claims[_recipient];
725         require(amount > 0, "Amount must be greater than 0");
726         claims[_recipient] = 0;
727         totalClaims = totalClaims.sub(amount);
728         SafeERC20.safeTransfer(IERC20(token), _recipient, amount);
729         emit Claim(_recipient, amount);
730     }
731 
732     /* -- Adjustor -- */
733 
734     function setClaims(
735         address[] calldata _addresses,
736         uint256[] calldata _amounts
737     ) external notInClaimPeriod onlyUnlockedAdjuster {
738         require(
739             _addresses.length == _amounts.length,
740             "Addresses and amounts must match"
741         );
742         uint256 len = _addresses.length;
743         for (uint256 i = 0; i < len; i++) {
744             address recipient = _addresses[i];
745             uint256 newAmount = _amounts[i];
746             uint256 oldAmount = claims[recipient];
747             claims[recipient] = newAmount;
748             totalClaims = totalClaims.add(newAmount).sub(oldAmount);
749             emit ClaimSet(recipient, newAmount);
750         }
751     }
752 
753     /* -- Governor -- */
754 
755     function lockAdjuster() external onlyGovernor notInClaimPeriod {
756         _lockAdjuster();
757     }
758 
759     function _lockAdjuster() internal {
760         isAdjusterLocked = true;
761         emit Lock();
762     }
763 
764     function unlockAdjuster() external onlyGovernor notInClaimPeriod {
765         isAdjusterLocked = false;
766         emit Unlock();
767     }
768 
769     function start(uint256 _seconds)
770         external
771         onlyGovernor
772         notInClaimPeriod
773         nonReentrant
774     {
775         require(totalClaims > 0, "No claims");
776         uint256 funding = IERC20(token).balanceOf(address(this));
777         require(funding >= totalClaims, "Insufficient funds for all claims");
778         _lockAdjuster();
779         end = block.timestamp.add(_seconds);
780         require(end.sub(block.timestamp) < 31622400, "Duration too long"); // 31622400 = 366*24*60*60
781         emit Start(end);
782     }
783 
784     function collect(address _coin)
785         external
786         onlyGovernor
787         notInClaimPeriod
788         nonReentrant
789     {
790         uint256 amount = IERC20(_coin).balanceOf(address(this));
791         SafeERC20.safeTransfer(IERC20(_coin), address(governor()), amount);
792         emit Collect(_coin, amount);
793     }
794 
795     /* -- modifiers -- */
796 
797     modifier onlyInClaimPeriod() {
798         require(block.timestamp <= end, "Should be in claim period");
799         _;
800     }
801 
802     modifier notInClaimPeriod() {
803         require(block.timestamp > end, "Should not be in claim period");
804         _;
805     }
806 
807     modifier onlyUnlockedAdjuster() {
808         require(isAdjusterLocked == false, "Adjuster must be unlocked");
809         require(msg.sender == adjuster, "Must be adjuster");
810         _;
811     }
812 }
813 
814 interface IERC20Decimals {
815     function decimals() external view returns (uint8);
816 }