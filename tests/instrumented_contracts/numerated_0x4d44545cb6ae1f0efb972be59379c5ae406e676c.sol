1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 pragma solidity ^0.6.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14     
15     function decimals() external view returns (uint8);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 // File: @openzeppelin/contracts/math/SafeMath.sol
83 
84 pragma solidity ^0.6.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 pragma solidity ^0.6.2;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
385 
386 pragma solidity ^0.6.0;
387 
388 /**
389  * @title SafeERC20
390  * @dev Wrappers around ERC20 operations that throw on failure (when the token
391  * contract returns false). Tokens that return no value (and instead revert or
392  * throw on failure) are also supported, non-reverting calls are assumed to be
393  * successful.
394  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
395  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
396  */
397 library SafeERC20 {
398     using SafeMath for uint256;
399     using Address for address;
400 
401     function safeTransfer(IERC20 token, address to, uint256 value) internal {
402         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
403     }
404 
405     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
407     }
408 
409     /**
410      * @dev Deprecated. This function has issues similar to the ones found in
411      * {IERC20-approve}, and its usage is discouraged.
412      *
413      * Whenever possible, use {safeIncreaseAllowance} and
414      * {safeDecreaseAllowance} instead.
415      */
416     function safeApprove(IERC20 token, address spender, uint256 value) internal {
417         // safeApprove should only be called when setting an initial allowance,
418         // or when resetting it to zero. To increase and decrease it, use
419         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
420         // solhint-disable-next-line max-line-length
421         require((value == 0) || (token.allowance(address(this), spender) == 0),
422             "SafeERC20: approve from non-zero to non-zero allowance"
423         );
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
425     }
426 
427     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
428         uint256 newAllowance = token.allowance(address(this), spender).add(value);
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
430     }
431 
432     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     /**
438      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
439      * on the return value: the return value is optional (but if data is returned, it must not be false).
440      * @param token The token targeted by the call.
441      * @param data The call data (encoded using abi.encode or one of its variants).
442      */
443     function _callOptionalReturn(IERC20 token, bytes memory data) private {
444         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
445         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
446         // the target address contains contract code and also asserts for success in the low-level call.
447 
448         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
449         if (returndata.length > 0) { // Return data is optional
450             // solhint-disable-next-line max-line-length
451             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
452         }
453     }
454 }
455 
456 // File: @openzeppelin/contracts/GSN/Context.sol
457 
458 pragma solidity ^0.6.0;
459 
460 /*
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with GSN meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address payable) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes memory) {
476         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
477         return msg.data;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/access/Ownable.sol
482 
483 pragma solidity ^0.6.0;
484 
485 /**
486  * @dev Contract module which provides a basic access control mechanism, where
487  * there is an account (an owner) that can be granted exclusive access to
488  * specific functions.
489  *
490  * By default, the owner account will be the one that deploys the contract. This
491  * can later be changed with {transferOwnership}.
492  *
493  * This module is used through inheritance. It will make available the modifier
494  * `onlyOwner`, which can be applied to your functions to restrict their use to
495  * the owner.
496  */
497 contract Ownable is Context {
498     address private _owner;
499 
500     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
501 
502     /**
503      * Initializes the contract setting the deployer as the initial owner.
504      */
505     constructor () internal {
506         address msgSender = _msgSender();
507         _owner = msgSender;
508         emit OwnershipTransferred(address(0), msgSender);
509     }
510 
511     /**
512      * Returns the address of the current owner.
513      */
514     function governance() public view returns (address) {
515         return _owner;
516     }
517 
518     /**
519      * Throws if called by any account other than the owner.
520      */
521     modifier onlyGovernance() {
522         require(_owner == _msgSender(), "Ownable: caller is not the owner");
523         _;
524     }
525 
526     /**
527      * Transfers ownership of the contract to a new account (`newOwner`).
528      * Can only be called by the current owner.
529      */
530     function transferGovernance(address newOwner) internal virtual onlyGovernance {
531         require(newOwner != address(0), "Ownable: new owner is the zero address");
532         emit OwnershipTransferred(_owner, newOwner);
533         _owner = newOwner;
534     }
535 }
536 
537 contract ReentrancyGuard {
538     // Booleans are more expensive than uint256 or any type that takes up a full
539     // word because each write operation emits an extra SLOAD to first read the
540     // slot's contents, replace the bits taken up by the boolean, and then write
541     // back. This is the compiler's defense against contract upgrades and
542     // pointer aliasing, and it cannot be disabled.
543 
544     // The values being non-zero value makes deployment a bit more expensive,
545     // but in exchange the refund on every call to nonReentrant will be lower in
546     // amount. Since refunds are capped to a percentage of the total
547     // transaction's gas, it is best to keep them low in cases like this one, to
548     // increase the likelihood of the full refund coming into effect.
549     uint256 private constant _NOT_ENTERED = 1;
550     uint256 private constant _ENTERED = 2;
551 
552     uint256 private _status;
553 
554     constructor () internal {
555         _status = _NOT_ENTERED;
556     }
557 
558     /**
559      * @dev Prevents a contract from calling itself, directly or indirectly.
560      * Calling a `nonReentrant` function from another `nonReentrant`
561      * function is not supported. It is possible to prevent this from happening
562      * by making the `nonReentrant` function external, and make it call a
563      * `private` function that does the actual work.
564      */
565     modifier nonReentrant() {
566         // On the first call to nonReentrant, _notEntered will be true
567         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
568 
569         // Any calls to nonReentrant after this point will fail
570         _status = _ENTERED;
571 
572         _;
573 
574         // By storing the original value once again, a refund is triggered (see
575         // https://eips.ethereum.org/EIPS/eip-2200)
576         _status = _NOT_ENTERED;
577     }
578 }
579 
580 // File: contracts/StabinolStaker.sol
581 
582 pragma solidity =0.6.6;
583 
584 // The Staker locks up LP tokens and STBZ tokens, users need to lockup for a time specified in the claimer before redeeming cashback
585 // After each cashback claim, there is a timelock to remove LP set to 24 hours
586 // This contract is designed to consider transfer fees for when STBZ starts to charge it. It takes the fee from the user upon unstake
587 
588 interface Claimer {
589     function getMinSTBZStake() external view returns (uint256);
590     function getLastClaimTime(address) external view returns (uint256);
591     function stakerUpdateBalance(address,uint256) external;
592 }
593 
594 interface STBZToken {
595     function burnRate() external view returns (uint256);
596 }
597 
598 contract StabinolStaker is Ownable, ReentrancyGuard {
599     using SafeMath for uint256;
600     using SafeERC20 for IERC20;
601     
602     // variables
603     address public stbzAddress; // The address for the STBZ tokens
604     address public stolAddress; // The address for STOL
605     address public lpAddress; // The address for the lp
606     address public claimerAddress = address(0); // This can be updated by governance
607     uint256 public minLPStakeTime = 24 hours; // This is the minimum time the user must wait to unstake LP after a previous claim
608     uint256 public totalSTBZ;
609     uint256 public totalLP;
610     
611     uint256 constant DIVISION_FACTOR = 100000;
612     
613     mapping(address => UserInfo) private allUsersInfo;
614     
615     // Structs
616     struct UserInfo {
617         uint256 stbzAmount; // How many stbz the user has in contract
618         uint256 lpAmount; // How many LP tokens the user has in contract
619         uint256 lastDeposit; // Time at last deposit action (either staking LP or stbz)
620         uint256 lastWithdraw; // Time at last withdraw action (either staking LP or stbz)
621     }
622 
623     // Events
624     event StakedSTBZ(address indexed user, uint256 amount);
625     event StakedLP(address indexed user, uint256 amount);
626     event WithdrawnSTBZ(address indexed user, uint256 amount);
627     event WithdrawnLP(address indexed user, uint256 amount);
628     
629     constructor(
630         address _stbz,
631         address _stol,
632         address _lp
633     ) public {
634         stbzAddress = _stbz;
635         stolAddress = _stol;
636         lpAddress = _lp;
637     }
638     
639     // functions
640     function getSTOLInLP(address _user) external view returns (uint256){
641         if(IERC20(lpAddress).totalSupply() == 0) { return 0; }
642         uint256 stolInLP = IERC20(stolAddress).balanceOf(lpAddress);
643         return stolInLP.mul(allUsersInfo[_user].lpAmount).div(IERC20(lpAddress).totalSupply());
644     }
645 
646     function getLPBalance(address _user) external view returns (uint256){
647         return allUsersInfo[_user].lpAmount;
648     }
649     
650     function getSTBZBalance(address _user) external view returns (uint256){
651         return allUsersInfo[_user].stbzAmount;
652     }
653     
654     function getDepositTime(address _user) external view returns (uint256){
655         return allUsersInfo[_user].lastDeposit;
656     }
657     
658     function getWithdrawTime(address _user) external view returns (uint256){
659         return allUsersInfo[_user].lastWithdraw;
660     }
661 
662     // User can force update her/his balance if it increases, extends claim window though
663     function updateMyBalance() external nonReentrant
664     {
665         uint256 gasAllocated = gasleft().mul(tx.gasprice); // Factor in the gas allocated for this transaction, it affects the eth balance
666         require(claimerAddress != address(0), "Claimer not set yet");
667         allUsersInfo[_msgSender()].lastDeposit = now; // Reset the claim time
668         Claimer(claimerAddress).stakerUpdateBalance(_msgSender(), gasAllocated); // Update the eth balance of the user in claim contract
669     }
670 
671     // Stake functions
672     function stakeSTBZ() external nonReentrant
673     {
674         uint256 gasAllocated = gasleft().mul(tx.gasprice); // Factor in the gas allocated for this transaction, it affects the eth balance
675         require(claimerAddress != address(0), "Claimer not set yet");
676         uint256 min = Claimer(claimerAddress).getMinSTBZStake(); // This will return the minimum amount of STBZ needed to stake
677         require(min > allUsersInfo[_msgSender()].stbzAmount, "Already staked enough STBZ in contract");
678         uint256 amount = min.sub(allUsersInfo[_msgSender()].stbzAmount); // This is the amount needed to top off account
679         allUsersInfo[_msgSender()].lastDeposit = now;
680         Claimer(claimerAddress).stakerUpdateBalance(_msgSender(), gasAllocated); // Update the eth balance of the user in claim contract
681         
682         IERC20 _token = IERC20(stbzAddress); // Trusted token
683         uint256 _before = _token.balanceOf(address(this));
684         _token.safeTransferFrom(_msgSender(), address(this), amount); // Transfer token to this address
685         amount = _token.balanceOf(address(this)).sub(_before); // Some tokens lose amount (transfer fee) upon transfer can happen
686         
687         totalSTBZ = totalSTBZ.add(amount);
688         allUsersInfo[_msgSender()].stbzAmount = allUsersInfo[_msgSender()].stbzAmount.add(amount);
689         require(allUsersInfo[_msgSender()].stbzAmount >= min, "Not enough tokens staked");
690         emit StakedSTBZ(_msgSender(), amount);
691     }
692     
693     function stakeSTOLLP(uint256 amount) external nonReentrant
694     {
695         uint256 gasAllocated = gasleft().mul(tx.gasprice); // Factor in the gas allocated for this transaction, it affects the eth balance
696         require(claimerAddress != address(0), "Claimer not set yet");
697         allUsersInfo[_msgSender()].lastDeposit = now;
698         Claimer(claimerAddress).stakerUpdateBalance(_msgSender(), gasAllocated); // Update the eth balance of the user in claim contract
699         
700         IERC20 _token = IERC20(lpAddress); // Trusted token
701         uint256 _before = _token.balanceOf(address(this));
702         _token.safeTransferFrom(_msgSender(), address(this), amount); // Transfer token to this address
703         amount = _token.balanceOf(address(this)).sub(_before);
704         
705         totalLP = totalLP.add(amount);
706         allUsersInfo[_msgSender()].lpAmount = allUsersInfo[_msgSender()].lpAmount.add(amount);
707         emit StakedLP(_msgSender(), amount);
708     }
709     
710     // Unstake functions
711     // This will unstake the entire STBZ amount staked, user can unstake STBZ at any time
712     // It takes into account the STBZ burn fee that is taken from the sender by implementing a withdraw fee
713     function unstakeSTBZ() external nonReentrant
714     {
715         require(allUsersInfo[_msgSender()].stbzAmount > 0, "There is no STBZ balance for this user");
716         uint256 feeRate = STBZToken(stbzAddress).burnRate();
717         if(feeRate > 0){
718             feeRate = (feeRate * DIVISION_FACTOR) / (DIVISION_FACTOR + feeRate); // Unique formula to calcuate fee upon sending
719         }
720         uint256 feeAmount = allUsersInfo[_msgSender()].stbzAmount.mul(feeRate).div(DIVISION_FACTOR);
721         uint256 sendAmount = allUsersInfo[_msgSender()].stbzAmount.sub(feeAmount);
722         totalSTBZ = totalSTBZ.sub(allUsersInfo[_msgSender()].stbzAmount);
723         allUsersInfo[_msgSender()].stbzAmount = 0;
724         allUsersInfo[_msgSender()].lastWithdraw = now;
725         IERC20(stbzAddress).safeTransfer(_msgSender(), sendAmount);
726         emit WithdrawnSTBZ(_msgSender(), sendAmount.add(feeAmount));
727     }
728     
729     // User can unstake only after timelock time
730     function unstakeLP(uint256 amount) external nonReentrant
731     {
732         require(allUsersInfo[_msgSender()].lpAmount > 0, "There is no LP balance for this user");
733         require(claimerAddress != address(0), "Claimer not set yet");
734         uint256 lastClaim = Claimer(claimerAddress).getLastClaimTime(_msgSender());
735         require(now >= lastClaim + minLPStakeTime, "Last claim too recent to unstake LP");
736         totalLP = totalLP.sub(amount);
737         allUsersInfo[_msgSender()].lpAmount = allUsersInfo[_msgSender()].lpAmount.sub(amount);
738         allUsersInfo[_msgSender()].lastWithdraw = now;
739         IERC20(lpAddress).safeTransfer(_msgSender(), amount);
740         emit WithdrawnLP(_msgSender(), amount);
741     }
742     
743     // Governance only functions
744     
745     // Timelock variables
746     // Timelock doesn't activate until claimer address set
747     
748     uint256 private _timelockStart; // The start of the timelock to change governance variables
749     uint256 private _timelockType; // The function that needs to be changed
750     uint256 constant TIMELOCK_DURATION = 86400; // Timelock is 24 hours
751     
752     // Reusable timelock variables
753     address private _timelock_address;
754     uint256 private _timelock_data;
755     
756     modifier timelockConditionsMet(uint256 _type) {
757         require(_timelockType == _type, "Timelock not acquired for this function");
758         _timelockType = 0; // Reset the type once the timelock is used
759         if(claimerAddress != address(0)){
760             // Timelock is only required after tokens burned into contract
761             require(now >= _timelockStart + TIMELOCK_DURATION + minLPStakeTime, "Timelock time not met");
762         }
763         _;
764     }
765     
766     // Change the owner of the token contract
767     // --------------------
768     function startGovernanceChange(address _address) external onlyGovernance {
769         _timelockStart = now;
770         _timelockType = 1;
771         _timelock_address = _address;       
772     }
773     
774     function finishGovernanceChange() external onlyGovernance timelockConditionsMet(1) {
775         transferGovernance(_timelock_address);
776     }
777     // --------------------
778     
779     // Change the claimer contract
780     // --------------------
781     function startClaimerChange(address _address) external onlyGovernance {
782         _timelockStart = now;
783         _timelockType = 2;
784         _timelock_address = _address;       
785     }
786     
787     function finishClaimerChange() external onlyGovernance timelockConditionsMet(2) {
788         claimerAddress = _timelock_address;
789     }
790     // --------------------
791     
792     // Change the LP lockup time since last claim time
793     // --------------------
794     function startChangeLPTimeLock(uint256 _time) external onlyGovernance {
795         _timelockStart = now;
796         _timelockType = 3;
797         _timelock_data = _time;
798     }
799     
800     function finishChangeLPTimeLock() external onlyGovernance timelockConditionsMet(3) {
801         minLPStakeTime = _timelock_data;
802     }
803     // --------------------
804    
805 }