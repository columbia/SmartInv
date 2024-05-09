1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.8;
4 
5 
6 // 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      *
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      *
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b != 0, errorMessage);
234         return a % b;
235     }
236 }
237 
238 // 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
262         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
263         // for accounts without code, i.e. `keccak256('')`
264         bytes32 codehash;
265         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
266         // solhint-disable-next-line no-inline-assembly
267         assembly { codehash := extcodehash(account) }
268         return (codehash != accountHash && codehash != 0x0);
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291         (bool success, ) = recipient.call{ value: amount }("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain`call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314       return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
324         return _functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
349         require(address(this).balance >= value, "Address: insufficient balance for call");
350         return _functionCallWithValue(target, data, value, errorMessage);
351     }
352 
353     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 // solhint-disable-next-line no-inline-assembly
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 // 
378 /**
379  * @title SafeERC20
380  * @dev Wrappers around ERC20 operations that throw on failure (when the token
381  * contract returns false). Tokens that return no value (and instead revert or
382  * throw on failure) are also supported, non-reverting calls are assumed to be
383  * successful.
384  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
385  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
386  */
387 library SafeERC20 {
388     using SafeMath for uint256;
389     using Address for address;
390 
391     function safeTransfer(IERC20 token, address to, uint256 value) internal {
392         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
393     }
394 
395     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
396         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
397     }
398 
399     /**
400      * @dev Deprecated. This function has issues similar to the ones found in
401      * {IERC20-approve}, and its usage is discouraged.
402      *
403      * Whenever possible, use {safeIncreaseAllowance} and
404      * {safeDecreaseAllowance} instead.
405      */
406     function safeApprove(IERC20 token, address spender, uint256 value) internal {
407         // safeApprove should only be called when setting an initial allowance,
408         // or when resetting it to zero. To increase and decrease it, use
409         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
410         // solhint-disable-next-line max-line-length
411         require((value == 0) || (token.allowance(address(this), spender) == 0),
412             "SafeERC20: approve from non-zero to non-zero allowance"
413         );
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
415     }
416 
417     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).add(value);
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
423         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
425     }
426 
427     /**
428      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
429      * on the return value: the return value is optional (but if data is returned, it must not be false).
430      * @param token The token targeted by the call.
431      * @param data The call data (encoded using abi.encode or one of its variants).
432      */
433     function _callOptionalReturn(IERC20 token, bytes memory data) private {
434         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
435         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
436         // the target address contains contract code and also asserts for success in the low-level call.
437 
438         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
439         if (returndata.length > 0) { // Return data is optional
440             // solhint-disable-next-line max-line-length
441             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
442         }
443     }
444 }
445 
446 // 
447 /**
448  * @title Initializable
449  *
450  * @dev Helper contract to support initializer functions. To use it, replace
451  * the constructor with a function that has the `initializer` modifier.
452  * WARNING: Unlike constructors, initializer functions must be manually
453  * invoked. This applies both to deploying an Initializable contract, as well
454  * as extending an Initializable contract via inheritance.
455  * WARNING: When used with inheritance, manual care must be taken to not invoke
456  * a parent initializer twice, or ensure that all initializers are idempotent,
457  * because this is not dealt with automatically as with constructors.
458  *
459  * Credit: https://github.com/OpenZeppelin/openzeppelin-upgrades/blob/master/packages/core/contracts/Initializable.sol
460  */
461 contract Initializable {
462 
463   /**
464    * @dev Indicates that the contract has been initialized.
465    */
466   bool private initialized;
467 
468   /**
469    * @dev Indicates that the contract is in the process of being initialized.
470    */
471   bool private initializing;
472 
473   /**
474    * @dev Modifier to use in the initializer function of a contract.
475    */
476   modifier initializer() {
477     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
478 
479     bool isTopLevelCall = !initializing;
480     if (isTopLevelCall) {
481       initializing = true;
482       initialized = true;
483     }
484 
485     _;
486 
487     if (isTopLevelCall) {
488       initializing = false;
489     }
490   }
491 
492   /// @dev Returns true if and only if the function is running in the constructor
493   function isConstructor() private view returns (bool) {
494     // extcodesize checks the size of the code stored in an address, and
495     // address returns the current address. Since the code is still not
496     // deployed when running a constructor, any checks on its code size will
497     // yield zero, making it an effective way to detect if a contract is
498     // under construction or not.
499     address self = address(this);
500     uint256 cs;
501     assembly { cs := extcodesize(self) }
502     return cs == 0;
503   }
504 
505   // Reserved storage space to allow for layout changes in the future.
506   uint256[50] private ______gap;
507 }
508 
509 // 
510 /**
511  * @notice An account contracted created for each user address.
512  * @dev Anyone can directy deposit assets to the Account contract.
513  * @dev Only operators can withdraw asstes or perform operation from the Account contract.
514  */
515 contract Account is Initializable {
516     using SafeMath for uint256;
517     using SafeERC20 for IERC20;
518 
519     /**
520      * @dev Asset is withdrawn from the Account.
521      */
522     event Withdrawn(address indexed tokenAddress, address indexed targetAddress, uint256 amount);
523 
524     /**
525      * @dev Spender is allowed to spend an asset.
526      */
527     event Approved(address indexed tokenAddress, address indexed targetAddress, uint256 amount);
528 
529     /**
530      * @dev A transaction is invoked on the Account.
531      */
532     event Invoked(address indexed targetAddress, uint256 value, bytes data);
533 
534     address public owner;
535     mapping(address => bool) public admins;
536     mapping(address => bool) public operators;
537 
538     /**
539      * @dev Initializes the owner, admin and operator roles.
540      * @param _owner Address of the contract owner
541      * @param _initialAdmins The list of addresses that are granted the admin role.
542      */
543     function initialize(address _owner, address[] memory _initialAdmins) public initializer {
544         owner = _owner;
545         // Grant the admin role to the initial admins
546         for (uint256 i = 0; i < _initialAdmins.length; i++) {
547             admins[_initialAdmins[i]] = true;
548         }
549     }
550 
551     /**
552      * @dev Throws if called by any account that does not have operator role.
553      */
554     modifier onlyOperator() {
555         require(isOperator(msg.sender), "not operator");
556         _;
557     }
558 
559     /**
560      * @dev Transfers the ownership of the account to another address.
561      * The new owner can be an zero address which means renouncing the ownership.
562      * @param _owner New owner address
563      */
564     function transferOwnership(address _owner) public {
565         require(msg.sender == owner, "not owner");
566         owner = _owner;
567     }
568 
569     /**
570      * @dev Grants admin role to a new address.
571      * @param _account New admin address.
572      */
573     function grantAdmin(address _account) public {
574         require(msg.sender == owner, "not owner");
575         require(!admins[_account], "already admin");
576 
577         admins[_account] = true;
578     }
579 
580     /**
581      * @dev Revokes the admin role from an address. Only owner can revoke admin.
582      * @param _account The admin address to revoke.
583      */
584     function revokeAdmin(address _account) public {
585         require(msg.sender == owner, "not owner");
586         require(admins[_account], "not admin");
587 
588         admins[_account] = false;
589     }
590 
591     /**
592      * @dev Grants operator role to a new address. Only owner or admin can grant operator roles.
593      * @param _account The new operator address.
594      */
595     function grantOperator(address _account) public {
596         require(msg.sender == owner || admins[msg.sender], "not admin");
597         require(!operators[_account], "already operator");
598 
599         operators[_account] = true;
600     }
601 
602     /**
603      * @dev Revoke operator role from an address. Only owner or admin can revoke operator roles.
604      * @param _account The operator address to revoke.
605      */
606     function revokeOperator(address _account) public {
607         require(msg.sender == owner || admins[msg.sender], "not admin");
608         require(operators[_account], "not operator");
609 
610         operators[_account] = false;
611     }
612 
613     /**
614      * @dev Allows Account contract to receive ETH.
615      */
616     receive() payable external {}
617 
618     /**
619      * @dev Checks whether a user is an operator of the contract.
620      * Since admin role can grant operator role and owner can grant admin role, we treat both
621      * admins and owner as operators!
622      * @param userAddress Address to check whether it's an operator.
623      */
624     function isOperator(address userAddress) public view returns (bool) {
625         return userAddress == owner || admins[userAddress] || operators[userAddress];
626     }
627 
628     /**
629      * @dev Withdraws ETH from the Account contract. Only operators can withdraw ETH.
630      * @param targetAddress Address to send the ETH to.
631      * @param amount Amount of ETH to withdraw.
632      */
633     function withdraw(address payable targetAddress, uint256 amount) public onlyOperator {
634         targetAddress.transfer(amount);
635         // Use address(-1) to represent ETH.
636         emit Withdrawn(address(-1), targetAddress, amount);
637     }
638 
639     /**
640      * @dev Withdraws ERC20 token from the Account contract. Only operators can withdraw ERC20 tokens.
641      * @param tokenAddress Address of the ERC20 to withdraw.
642      * @param targetAddress Address to send the ERC20 to.
643      * @param amount Amount of ERC20 token to withdraw.
644      */
645     function withdrawToken(address tokenAddress, address targetAddress, uint256 amount) public onlyOperator {
646         IERC20(tokenAddress).safeTransfer(targetAddress, amount);
647         emit Withdrawn(tokenAddress, targetAddress, amount);
648     }
649 
650     /**
651      * @dev Withdraws ERC20 token from the Account contract. If the Account contract does not have sufficient balance,
652      * try to withdraw from the owner's address as well. This is useful if users wants to keep assets in their own wallet
653      * by setting adequate allowance to the Account contract.
654      * @param tokenAddress Address of the ERC20 to withdraw.
655      * @param targetAddress Address to send the ERC20 to.
656      * @param amount Amount of ERC20 token to withdraw.
657      */
658     function withdrawTokenFallThrough(address tokenAddress, address targetAddress, uint256 amount) public onlyOperator {
659         uint256 tokenBalance = IERC20(tokenAddress).balanceOf(address(this));
660         // If we have enough token balance, send the token directly.
661         if (tokenBalance >= amount) {
662             IERC20(tokenAddress).safeTransfer(targetAddress, amount);
663             emit Withdrawn(tokenAddress, targetAddress, amount);
664         } else {
665             IERC20(tokenAddress).safeTransferFrom(owner, targetAddress, amount.sub(tokenBalance));
666             IERC20(tokenAddress).safeTransfer(targetAddress, tokenBalance);
667             emit Withdrawn(tokenAddress, targetAddress, amount);
668         }
669     }
670 
671     /**
672      * @dev Allows the spender address to spend up to the amount of token.
673      * @param tokenAddress Address of the ERC20 that can spend.
674      * @param targetAddress Address which can spend the ERC20.
675      * @param amount Amount of ERC20 that can be spent by the target address.
676      */
677     function approveToken(address tokenAddress, address targetAddress, uint256 amount) public onlyOperator {
678         IERC20(tokenAddress).safeApprove(targetAddress, 0);
679         IERC20(tokenAddress).safeApprove(targetAddress, amount);
680         emit Approved(tokenAddress, targetAddress, amount);
681     }
682 
683     /**
684      * @notice Performs a generic transaction on the Account contract.
685      * @param target The address for the target contract.
686      * @param value The value of the transaction.
687      * @param data The data of the transaction.
688      */
689     function invoke(address target, uint256 value, bytes memory data) public onlyOperator returns (bytes memory result) {
690         bool success;
691         (success, result) = target.call{value: value}(data);
692         if (!success) {
693             // solhint-disable-next-line no-inline-assembly
694             assembly {
695                 returndatacopy(0, 0, returndatasize())
696                 revert(0, returndatasize())
697             }
698         }
699         emit Invoked(target, value, data);
700     }
701 }
702 
703 // 
704 /**
705  * @title Proxy
706  * @dev Implements delegation of calls to other contracts, with proper
707  * forwarding of return values and bubbling of failures.
708  * It defines a fallback function that delegates all calls to the address
709  * returned by the abstract _implementation() internal function.
710  *
711  * Credit: https://github.com/OpenZeppelin/openzeppelin-sdk/blob/master/packages/lib/contracts/upgradeability/Proxy.sol
712  */
713 abstract contract Proxy {
714 
715   /**
716    * @dev Receive function.
717    * Implemented entirely in `_fallback`.
718    */
719   receive () payable external {
720     _fallback();
721   }
722 
723   /**
724    * @dev Fallback function.
725    * Implemented entirely in `_fallback`.
726    */
727   fallback () payable external {
728     _fallback();
729   }
730 
731   /**
732    * @return The Address of the implementation.
733    */
734   function _implementation() internal virtual view returns (address);
735 
736   /**
737    * @dev Delegates execution to an implementation contract.
738    * This is a low level function that doesn't return to its internal call site.
739    * It will return to the external caller whatever the implementation returns.
740    * @param implementation Address to delegate.
741    */
742   function _delegate(address implementation) internal {
743     assembly {
744       // Copy msg.data. We take full control of memory in this inline assembly
745       // block because it will not return to Solidity code. We overwrite the
746       // Solidity scratch pad at memory position 0.
747       calldatacopy(0, 0, calldatasize())
748 
749       // Call the implementation.
750       // out and outsize are 0 because we don't know the size yet.
751       let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
752 
753       // Copy the returned data.
754       returndatacopy(0, 0, returndatasize())
755 
756       switch result
757       // delegatecall returns 0 on error.
758       case 0 { revert(0, returndatasize()) }
759       default { return(0, returndatasize()) }
760     }
761   }
762 
763   /**
764    * @dev Function that is run as the first thing in the fallback function.
765    * Can be redefined in derived contracts to add functionality.
766    * Redefinitions must call super._willFallback().
767    */
768   function _willFallback() internal virtual {
769   }
770 
771   /**
772    * @dev fallback implementation.
773    * Extracted to enable manual triggering.
774    */
775   function _fallback() internal {
776     _willFallback();
777     _delegate(_implementation());
778   }
779 }
780 
781 // 
782 /**
783  * @title BaseUpgradeabilityProxy
784  * @dev This contract implements a proxy that allows to change the
785  * implementation address to which it will delegate.
786  * Such a change is called an implementation upgrade.
787  *
788  * Credit: https://github.com/OpenZeppelin/openzeppelin-sdk/blob/master/packages/lib/contracts/upgradeability/BaseUpgradeabilityProxy.sol
789  */
790 contract BaseUpgradeabilityProxy is Proxy {
791     /**
792    * @dev Emitted when the implementation is upgraded.
793    * @param implementation Address of the new implementation.
794    */
795     event Upgraded(address indexed implementation);
796 
797     /**
798    * @dev Storage slot with the address of the current implementation.
799    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
800    * validated in the constructor.
801    */
802     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
803 
804     /**
805    * @dev Returns the current implementation.
806    * @return impl Address of the current implementation
807    */
808     function _implementation() internal override view returns (address impl) {
809         bytes32 slot = IMPLEMENTATION_SLOT;
810         assembly {
811             impl := sload(slot)
812         }
813     }
814 
815     /**
816    * @dev Sets the implementation address of the proxy.
817    * @param newImplementation Address of the new implementation.
818    */
819     function _setImplementation(address newImplementation) internal {
820         require(
821             Address.isContract(newImplementation),
822             "Implementation not set"
823         );
824 
825         bytes32 slot = IMPLEMENTATION_SLOT;
826 
827         assembly {
828             sstore(slot, newImplementation)
829         }
830         emit Upgraded(newImplementation);
831     }
832 }
833 
834 // 
835 /**
836  * @title AdminUpgradeabilityProxy
837  * @dev This contract combines an upgradeability proxy with an authorization
838  * mechanism for administrative tasks.
839  * All external functions in this contract must be guarded by the
840  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
841  * feature proposal that would enable this to be done automatically.
842  * Credit: https://github.com/OpenZeppelin/openzeppelin-sdk/blob/master/packages/lib/contracts/upgradeability/BaseAdminUpgradeabilityProxy.sol
843  */
844 contract AdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
845   /**
846    * @dev Emitted when the administration has been transferred.
847    * @param previousAdmin Address of the previous admin.
848    * @param newAdmin Address of the new admin.
849    */
850   event AdminChanged(address previousAdmin, address newAdmin);
851 
852   /**
853    * @dev Storage slot with the admin of the contract.
854    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
855    * validated in the constructor.
856    */
857 
858   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
859 
860   /**
861    * Contract constructor.
862    * @param _logic address of the initial implementation.
863    * @param _admin Address of the proxy administrator.
864    * It should include the signature and the parameters of the function to be called, as described in
865    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
866    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
867    */
868   constructor(address _logic, address _admin) public payable {
869     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
870     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
871     _setImplementation(_logic);
872     _setAdmin(_admin);
873   }
874 
875   /**
876    * @dev Modifier to check whether the `msg.sender` is the admin.
877    * If it is, it will run the function. Otherwise, it will delegate the call
878    * to the implementation.
879    */
880   modifier ifAdmin() {
881     if (msg.sender == _admin()) {
882       _;
883     } else {
884       _fallback();
885     }
886   }
887 
888   /**
889    * @return The address of the proxy admin.
890    */
891   function admin() external ifAdmin returns (address) {
892     return _admin();
893   }
894 
895   /**
896    * @return The address of the implementation.
897    */
898   function implementation() external ifAdmin returns (address) {
899     return _implementation();
900   }
901 
902   /**
903    * @dev Changes the admin of the proxy.
904    * Only the current admin can call this function.
905    * @param newAdmin Address to transfer proxy administration to.
906    */
907   function changeAdmin(address newAdmin) external ifAdmin {
908     emit AdminChanged(_admin(), newAdmin);
909     _setAdmin(newAdmin);
910   }
911 
912   /**
913    * @dev Upgrade the backing implementation of the proxy.
914    * Only the admin can call this function.
915    * @param newImplementation Address of the new implementation.
916    */
917   function changeImplementation(address newImplementation) external ifAdmin {
918     _setImplementation(newImplementation);
919   }
920 
921   /**
922    * @return adm The admin slot.
923    */
924   function _admin() internal view returns (address adm) {
925     bytes32 slot = ADMIN_SLOT;
926     assembly {
927       adm := sload(slot)
928     }
929   }
930 
931   /**
932    * @dev Sets the address of the proxy admin.
933    * @param newAdmin Address of the new proxy admin.
934    */
935   function _setAdmin(address newAdmin) internal {
936     bytes32 slot = ADMIN_SLOT;
937 
938     assembly {
939       sstore(slot, newAdmin)
940     }
941   }
942 }
943 
944 // 
945 /**
946  * @notice Factory of Account contracts.
947  */
948 contract AccountFactory {
949 
950     /**
951      * @dev A new Account contract is created.
952      */
953     event AccountCreated(address indexed userAddress, address indexed accountAddress);
954 
955     address public governance;
956     address public accountBase;
957     mapping(address => address) public accounts;
958 
959     /**
960      * @dev Constructor for Account Factory.
961      * @param _accountBase Base account implementation.
962      */
963     constructor(address _accountBase) public {
964         require(_accountBase != address(0x0), "account base not set");
965         governance = msg.sender;
966         accountBase = _accountBase;
967     }
968 
969     /**
970      * @dev Updates the base account implementation. Base account must be set.
971      */
972     function setAccountBase(address _accountBase) public {
973         require(msg.sender == governance, "not governance");
974         require(_accountBase != address(0x0), "account base not set");
975 
976         accountBase = _accountBase;
977     }
978 
979     /**
980      * @dev Updates the govenance address. Governance can be empty address which means
981      * renouncing the governance.
982      */
983     function setGovernance(address _governance) public {
984         require(msg.sender == governance, "not governance");
985         governance = _governance;
986     }
987 
988     /**
989      * @dev Creates a new Account contract for the caller.
990      * Users can create multiple accounts by invoking this method multiple times. However,
991      * only the latest one is actively tracked and used by the platform.
992      * @param _initialAdmins The list of addresses that are granted the admin role.
993      */
994     function createAccount(address[] memory _initialAdmins) public returns (Account) {
995         AdminUpgradeabilityProxy proxy = new AdminUpgradeabilityProxy(accountBase, msg.sender);
996         Account account = Account(address(proxy));
997         account.initialize(msg.sender, _initialAdmins);
998         accounts[msg.sender] = address(account);
999 
1000         emit AccountCreated(msg.sender, address(account));
1001 
1002         return account;
1003     }
1004 }
1005 
1006 // 
1007 /**
1008  * @notice Interface for ERC20 token which supports minting new tokens.
1009  */
1010 interface IERC20Mintable is IERC20 {
1011     
1012     function mint(address _user, uint256 _amount) external;
1013 
1014 }
1015 
1016 // 
1017 /**
1018  * @notice Interface for controller.
1019  */
1020 interface IController {
1021     
1022     function rewardToken() external returns (address);
1023 }
1024 
1025 // 
1026 /**
1027  * @dev Standard math utilities missing in the Solidity language.
1028  */
1029 library Math {
1030     /**
1031      * @dev Returns the largest of two numbers.
1032      */
1033     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1034         return a >= b ? a : b;
1035     }
1036 
1037     /**
1038      * @dev Returns the smallest of two numbers.
1039      */
1040     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1041         return a < b ? a : b;
1042     }
1043 
1044     /**
1045      * @dev Returns the average of two numbers. The result is rounded towards
1046      * zero.
1047      */
1048     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1049         // (a + b) / 2 can overflow, so we distribute
1050         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1051     }
1052 }
1053 
1054 // 
1055 /*
1056  * @dev Provides information about the current execution context, including the
1057  * sender of the transaction and its data. While these are generally available
1058  * via msg.sender and msg.data, they should not be accessed in such a direct
1059  * manner, since when dealing with GSN meta-transactions the account sending and
1060  * paying for execution may not be the actual sender (as far as an application
1061  * is concerned).
1062  *
1063  * This contract is only required for intermediate, library-like contracts.
1064  */
1065 abstract contract Context {
1066     function _msgSender() internal view virtual returns (address payable) {
1067         return msg.sender;
1068     }
1069 
1070     function _msgData() internal view virtual returns (bytes memory) {
1071         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1072         return msg.data;
1073     }
1074 }
1075 
1076 // 
1077 /**
1078  * @dev Implementation of the {IERC20} interface.
1079  *
1080  * This implementation is agnostic to the way tokens are created. This means
1081  * that a supply mechanism has to be added in a derived contract using {_mint}.
1082  * For a generic mechanism see {ERC20PresetMinterPauser}.
1083  *
1084  * TIP: For a detailed writeup see our guide
1085  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1086  * to implement supply mechanisms].
1087  *
1088  * We have followed general OpenZeppelin guidelines: functions revert instead
1089  * of returning `false` on failure. This behavior is nonetheless conventional
1090  * and does not conflict with the expectations of ERC20 applications.
1091  *
1092  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1093  * This allows applications to reconstruct the allowance for all accounts just
1094  * by listening to said events. Other implementations of the EIP may not emit
1095  * these events, as it isn't required by the specification.
1096  *
1097  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1098  * functions have been added to mitigate the well-known issues around setting
1099  * allowances. See {IERC20-approve}.
1100  */
1101 contract ERC20 is Context, IERC20 {
1102     using SafeMath for uint256;
1103     using Address for address;
1104 
1105     mapping (address => uint256) private _balances;
1106 
1107     mapping (address => mapping (address => uint256)) private _allowances;
1108 
1109     uint256 private _totalSupply;
1110 
1111     string private _name;
1112     string private _symbol;
1113     uint8 private _decimals;
1114 
1115     /**
1116      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1117      * a default value of 18.
1118      *
1119      * To select a different value for {decimals}, use {_setupDecimals}.
1120      *
1121      * All three of these values are immutable: they can only be set once during
1122      * construction.
1123      */
1124     constructor (string memory name, string memory symbol) public {
1125         _name = name;
1126         _symbol = symbol;
1127         _decimals = 18;
1128     }
1129 
1130     /**
1131      * @dev Returns the name of the token.
1132      */
1133     function name() public view returns (string memory) {
1134         return _name;
1135     }
1136 
1137     /**
1138      * @dev Returns the symbol of the token, usually a shorter version of the
1139      * name.
1140      */
1141     function symbol() public view returns (string memory) {
1142         return _symbol;
1143     }
1144 
1145     /**
1146      * @dev Returns the number of decimals used to get its user representation.
1147      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1148      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1149      *
1150      * Tokens usually opt for a value of 18, imitating the relationship between
1151      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1152      * called.
1153      *
1154      * NOTE: This information is only used for _display_ purposes: it in
1155      * no way affects any of the arithmetic of the contract, including
1156      * {IERC20-balanceOf} and {IERC20-transfer}.
1157      */
1158     function decimals() public view returns (uint8) {
1159         return _decimals;
1160     }
1161 
1162     /**
1163      * @dev See {IERC20-totalSupply}.
1164      */
1165     function totalSupply() public view override returns (uint256) {
1166         return _totalSupply;
1167     }
1168 
1169     /**
1170      * @dev See {IERC20-balanceOf}.
1171      */
1172     function balanceOf(address account) public view override returns (uint256) {
1173         return _balances[account];
1174     }
1175 
1176     /**
1177      * @dev See {IERC20-transfer}.
1178      *
1179      * Requirements:
1180      *
1181      * - `recipient` cannot be the zero address.
1182      * - the caller must have a balance of at least `amount`.
1183      */
1184     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1185         _transfer(_msgSender(), recipient, amount);
1186         return true;
1187     }
1188 
1189     /**
1190      * @dev See {IERC20-allowance}.
1191      */
1192     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1193         return _allowances[owner][spender];
1194     }
1195 
1196     /**
1197      * @dev See {IERC20-approve}.
1198      *
1199      * Requirements:
1200      *
1201      * - `spender` cannot be the zero address.
1202      */
1203     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1204         _approve(_msgSender(), spender, amount);
1205         return true;
1206     }
1207 
1208     /**
1209      * @dev See {IERC20-transferFrom}.
1210      *
1211      * Emits an {Approval} event indicating the updated allowance. This is not
1212      * required by the EIP. See the note at the beginning of {ERC20};
1213      *
1214      * Requirements:
1215      * - `sender` and `recipient` cannot be the zero address.
1216      * - `sender` must have a balance of at least `amount`.
1217      * - the caller must have allowance for ``sender``'s tokens of at least
1218      * `amount`.
1219      */
1220     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1221         _transfer(sender, recipient, amount);
1222         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1223         return true;
1224     }
1225 
1226     /**
1227      * @dev Atomically increases the allowance granted to `spender` by the caller.
1228      *
1229      * This is an alternative to {approve} that can be used as a mitigation for
1230      * problems described in {IERC20-approve}.
1231      *
1232      * Emits an {Approval} event indicating the updated allowance.
1233      *
1234      * Requirements:
1235      *
1236      * - `spender` cannot be the zero address.
1237      */
1238     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1239         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1240         return true;
1241     }
1242 
1243     /**
1244      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1245      *
1246      * This is an alternative to {approve} that can be used as a mitigation for
1247      * problems described in {IERC20-approve}.
1248      *
1249      * Emits an {Approval} event indicating the updated allowance.
1250      *
1251      * Requirements:
1252      *
1253      * - `spender` cannot be the zero address.
1254      * - `spender` must have allowance for the caller of at least
1255      * `subtractedValue`.
1256      */
1257     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1258         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1259         return true;
1260     }
1261 
1262     /**
1263      * @dev Moves tokens `amount` from `sender` to `recipient`.
1264      *
1265      * This is internal function is equivalent to {transfer}, and can be used to
1266      * e.g. implement automatic token fees, slashing mechanisms, etc.
1267      *
1268      * Emits a {Transfer} event.
1269      *
1270      * Requirements:
1271      *
1272      * - `sender` cannot be the zero address.
1273      * - `recipient` cannot be the zero address.
1274      * - `sender` must have a balance of at least `amount`.
1275      */
1276     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1277         require(sender != address(0), "ERC20: transfer from the zero address");
1278         require(recipient != address(0), "ERC20: transfer to the zero address");
1279 
1280         _beforeTokenTransfer(sender, recipient, amount);
1281 
1282         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1283         _balances[recipient] = _balances[recipient].add(amount);
1284         emit Transfer(sender, recipient, amount);
1285     }
1286 
1287     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1288      * the total supply.
1289      *
1290      * Emits a {Transfer} event with `from` set to the zero address.
1291      *
1292      * Requirements
1293      *
1294      * - `to` cannot be the zero address.
1295      */
1296     function _mint(address account, uint256 amount) internal virtual {
1297         require(account != address(0), "ERC20: mint to the zero address");
1298 
1299         _beforeTokenTransfer(address(0), account, amount);
1300 
1301         _totalSupply = _totalSupply.add(amount);
1302         _balances[account] = _balances[account].add(amount);
1303         emit Transfer(address(0), account, amount);
1304     }
1305 
1306     /**
1307      * @dev Destroys `amount` tokens from `account`, reducing the
1308      * total supply.
1309      *
1310      * Emits a {Transfer} event with `to` set to the zero address.
1311      *
1312      * Requirements
1313      *
1314      * - `account` cannot be the zero address.
1315      * - `account` must have at least `amount` tokens.
1316      */
1317     function _burn(address account, uint256 amount) internal virtual {
1318         require(account != address(0), "ERC20: burn from the zero address");
1319 
1320         _beforeTokenTransfer(account, address(0), amount);
1321 
1322         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1323         _totalSupply = _totalSupply.sub(amount);
1324         emit Transfer(account, address(0), amount);
1325     }
1326 
1327     /**
1328      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1329      *
1330      * This is internal function is equivalent to `approve`, and can be used to
1331      * e.g. set automatic allowances for certain subsystems, etc.
1332      *
1333      * Emits an {Approval} event.
1334      *
1335      * Requirements:
1336      *
1337      * - `owner` cannot be the zero address.
1338      * - `spender` cannot be the zero address.
1339      */
1340     function _approve(address owner, address spender, uint256 amount) internal virtual {
1341         require(owner != address(0), "ERC20: approve from the zero address");
1342         require(spender != address(0), "ERC20: approve to the zero address");
1343 
1344         _allowances[owner][spender] = amount;
1345         emit Approval(owner, spender, amount);
1346     }
1347 
1348     /**
1349      * @dev Sets {decimals} to a value other than the default one of 18.
1350      *
1351      * WARNING: This function should only be called from the constructor. Most
1352      * applications that interact with token contracts will not expect
1353      * {decimals} to ever change, and may work incorrectly if it does.
1354      */
1355     function _setupDecimals(uint8 decimals_) internal {
1356         _decimals = decimals_;
1357     }
1358 
1359     /**
1360      * @dev Hook that is called before any transfer of tokens. This includes
1361      * minting and burning.
1362      *
1363      * Calling conditions:
1364      *
1365      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1366      * will be to transferred to `to`.
1367      * - when `from` is zero, `amount` tokens will be minted for `to`.
1368      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1369      * - `from` and `to` are never both zero.
1370      *
1371      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1372      */
1373     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1374 }
1375 
1376 // 
1377 /**
1378  * @notice Interface for Strategies.
1379  */
1380 interface IStrategy {
1381 
1382     /**
1383      * @dev Returns the token address that the strategy expects.
1384      */
1385     function want() external view returns (address);
1386 
1387     /**
1388      * @dev Returns the total amount of tokens deposited in this strategy.
1389      */
1390     function balanceOf() external view returns (uint256);
1391 
1392     /**
1393      * @dev Deposits the token to start earning.
1394      */
1395     function deposit() external;
1396 
1397     /**
1398      * @dev Withdraws partial funds from the strategy.
1399      */
1400     function withdraw(uint256 _amount) external;
1401 
1402     /**
1403      * @dev Withdraws all funds from the strategy.
1404      */
1405     function withdrawAll() external returns (uint256);
1406     
1407     /**
1408      * @dev Claims yield and convert it back to want token.
1409      */
1410     function harvest() external;
1411 }
1412 
1413 // 
1414 /**
1415  * @notice YEarn's style vault which earns yield for a specific token.
1416  */
1417 contract Vault is ERC20 {
1418     using SafeERC20 for IERC20;
1419     using Address for address;
1420     using SafeMath for uint256;
1421 
1422     IERC20 public token;
1423     address public governance;
1424     address public strategist;
1425     address public strategy;
1426 
1427     event Deposited(address indexed user, address indexed token, uint256 amount, uint256 shareAmount);
1428     event Withdrawn(address indexed user, address indexed token, uint256 amount, uint256 shareAmount);
1429 
1430     constructor(string memory _name, string memory _symbol, address _token) public ERC20(_name, _symbol) {
1431         token = IERC20(_token);
1432         governance = msg.sender;
1433         strategist = msg.sender;
1434     }
1435 
1436     /**
1437      * @dev Returns the total balance in both vault and strategy.
1438      */
1439     function balance() public view returns (uint256) {
1440         return strategy == address(0x0) ? token.balanceOf(address(this)) :
1441             token.balanceOf(address(this)).add(IStrategy(strategy).balanceOf());
1442     }
1443 
1444     /**
1445      * @dev Updates the govenance address.
1446      */
1447     function setGovernance(address _governance) public {
1448         require(msg.sender == governance, "not governance");
1449         governance = _governance;
1450     }
1451 
1452     /**
1453      * @dev Upadtes the strategist address.
1454      */
1455     function setStrategist(address _strategist) public {
1456         require(msg.sender == governance, "not governance");
1457         strategist = _strategist;
1458     }
1459 
1460     /**
1461      * @dev Updates the active strategy of the vault.
1462      */
1463     function setStrategy(address _strategy) public {
1464         require(msg.sender == governance, "not governance");
1465         // This also ensures that _strategy must be a valid strategy contract.
1466         require(address(token) == IStrategy(_strategy).want(), "different token");
1467 
1468         // If the vault has an existing strategy, withdraw all funds from it.
1469         if (strategy != address(0x0)) {
1470             IStrategy(strategy).withdrawAll();
1471         }
1472 
1473         strategy = _strategy;
1474         // Starts earning once a new strategy is set.
1475         earn();
1476     }
1477 
1478     /**
1479      * @dev Starts earning and deposits all current balance into strategy.
1480      * Anyone can call this function to start earning.
1481      */
1482     function earn() public {
1483         if (strategy != address(0x0)) {
1484             uint256 _bal = token.balanceOf(address(this));
1485             token.safeTransfer(strategy, _bal);
1486             IStrategy(strategy).deposit();
1487         }
1488     }
1489 
1490     /**
1491      * @dev Harvest yield from the strategy if set. Only strategist or governance can
1492      * harvest from the strategy.
1493      */
1494     function harvest() public {
1495         require(msg.sender == strategist || msg.sender == governance, "not authorized");
1496         require(strategy != address(0x0), "no strategy");
1497         IStrategy(strategy).harvest();
1498     }
1499 
1500     /**
1501      * @dev Deposits all balance to the vault.
1502      */
1503     function depositAll() public virtual {
1504         deposit(token.balanceOf(msg.sender));
1505     }
1506 
1507     /**
1508      * @dev Deposit some balance to the vault.
1509      */
1510     function deposit(uint256 _amount) public virtual {
1511         require(_amount > 0, "zero amount");
1512         uint256 _pool = balance();
1513         uint256 _before = token.balanceOf(address(this));
1514         token.safeTransferFrom(msg.sender, address(this), _amount);
1515         uint256 _after = token.balanceOf(address(this));
1516         _amount = _after.sub(_before); // Additional check for deflationary tokens
1517         uint256 shares = 0;
1518         if (totalSupply() == 0) {
1519             shares = _amount;
1520         } else {
1521             shares = (_amount.mul(totalSupply())).div(_pool);
1522         }
1523         _mint(msg.sender, shares);
1524 
1525         emit Deposited(msg.sender, address(token), _amount, shares);
1526     }
1527 
1528     /**
1529      * @dev Withdraws all balance out of the vault.
1530      */
1531     function withdrawAll() public virtual {
1532         withdraw(balanceOf(msg.sender));
1533     }
1534 
1535     /**
1536      * @dev Withdraws some balance out of the vault.
1537      */
1538     function withdraw(uint256 _shares) public virtual {
1539         require(_shares > 0, "zero amount");
1540         uint256 r = (balance().mul(_shares)).div(totalSupply());
1541         _burn(msg.sender, _shares);
1542 
1543         // Check balance
1544         uint256 b = token.balanceOf(address(this));
1545         if (b < r) {
1546             uint256 _withdraw = r.sub(b);
1547             // Ideally this should not happen. Put here for extra safety.
1548             require(strategy != address(0x0), "no strategy");
1549             IStrategy(strategy).withdraw(_withdraw);
1550             uint256 _after = token.balanceOf(address(this));
1551             uint256 _diff = _after.sub(b);
1552             if (_diff < _withdraw) {
1553                 r = b.add(_diff);
1554             }
1555         }
1556 
1557         token.safeTransfer(msg.sender, r);
1558         emit Withdrawn(msg.sender, address(token), r, _shares);
1559     }
1560 
1561     /**
1562      * @dev Used to salvage any token deposited into the vault by mistake.
1563      * @param _tokenAddress Token address to salvage.
1564      * @param _amount Amount of token to salvage.
1565      */
1566     function salvage(address _tokenAddress, uint256 _amount) public {
1567         require(msg.sender == strategist || msg.sender == governance, "not authorized");
1568         require(_tokenAddress != address(token), "cannot salvage");
1569         require(_amount > 0, "zero amount");
1570         IERC20(_tokenAddress).safeTransfer(governance, _amount);
1571     }
1572 
1573     /**
1574      * @dev Returns the number of vault token per share is worth.
1575      */
1576     function getPricePerFullShare() public view returns (uint256) {
1577         if (totalSupply() == 0) return 0;
1578         return balance().mul(1e18).div(totalSupply());
1579     }
1580 }
1581 
1582 // 
1583 /**
1584  * @notice A vault with rewards.
1585  */
1586 contract RewardedVault is Vault {
1587     using SafeERC20 for IERC20;
1588     using Address for address;
1589     using SafeMath for uint256;
1590 
1591     address public controller;
1592     uint256 public constant DURATION = 7 days;      // Rewards are vested for a fixed duration of 7 days.
1593     uint256 public periodFinish = 0;
1594     uint256 public rewardRate = 0;
1595     uint256 public lastUpdateTime;
1596     uint256 public rewardPerTokenStored;
1597     mapping(address => uint256) public userRewardPerTokenPaid;
1598     mapping(address => uint256) public rewards;
1599     mapping(address => uint256) public claims;
1600 
1601     event RewardAdded(address indexed rewardToken, uint256 rewardAmount);
1602     event RewardPaid(address indexed rewardToken, address indexed user, uint256 rewardAmount);
1603 
1604     constructor(string memory _name, string memory _symbol, address _controller, address _vaultToken) public Vault(_name, _symbol, _vaultToken) {
1605         require(_controller != address(0x0), "controller not set");
1606 
1607         controller = _controller;
1608     }
1609 
1610     /**
1611      * @dev Updates the controller address. Controller is responsible for reward distribution.
1612      */
1613     function setController(address _controller) public {
1614         require(msg.sender == governance, "not governance");
1615         require(_controller != address(0x0), "controller not set");
1616 
1617         controller = _controller;
1618     }
1619 
1620     modifier updateReward(address _account) {
1621         rewardPerTokenStored = rewardPerToken();
1622         lastUpdateTime = lastTimeRewardApplicable();
1623         if (_account != address(0)) {
1624             rewards[_account] = earned(_account);
1625             userRewardPerTokenPaid[_account] = rewardPerTokenStored;
1626         }
1627         _;
1628     }
1629 
1630     function lastTimeRewardApplicable() public view returns (uint256) {
1631         return Math.min(block.timestamp, periodFinish);
1632     }
1633 
1634     function rewardPerToken() public view returns (uint256) {
1635         if (totalSupply() == 0) {
1636             return rewardPerTokenStored;
1637         }
1638         return
1639             rewardPerTokenStored.add(
1640                 lastTimeRewardApplicable()
1641                     .sub(lastUpdateTime)
1642                     .mul(rewardRate)
1643                     .mul(1e18)
1644                     .div(totalSupply())
1645             );
1646     }
1647 
1648     function earned(address _account) public view returns (uint256) {
1649         return
1650             balanceOf(_account)
1651                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[_account]))
1652                 .div(1e18)
1653                 .add(rewards[_account]);
1654     }
1655 
1656     function deposit(uint256 _amount) public virtual override updateReward(msg.sender) {
1657         super.deposit(_amount);
1658     }
1659 
1660     function depositAll() public virtual override updateReward(msg.sender) {
1661         super.depositAll();
1662     }
1663 
1664     function withdraw(uint256 _shares) public virtual override updateReward(msg.sender) {
1665         super.withdraw(_shares);
1666     }
1667 
1668     function withdrawAll() public virtual override updateReward(msg.sender) {
1669         super.withdrawAll();
1670     }
1671 
1672     /**
1673      * @dev Withdraws all balance and all rewards from the vault.
1674      */
1675     function exit() external {
1676         withdrawAll();
1677         claimReward();
1678     }
1679 
1680     /**
1681      * @dev Claims all rewards from the vault.
1682      */
1683     function claimReward() public updateReward(msg.sender) returns (uint256) {
1684         uint256 reward = earned(msg.sender);
1685         if (reward > 0) {
1686             claims[msg.sender] = claims[msg.sender].add(reward);
1687             rewards[msg.sender] = 0;
1688             address rewardToken = IController(controller).rewardToken();
1689             IERC20(rewardToken).safeTransfer(msg.sender, reward);
1690             emit RewardPaid(rewardToken, msg.sender, reward);
1691         }
1692 
1693         return reward;
1694     }
1695 
1696     /**
1697      * @dev Notifies the vault that new reward is added. All rewards will be distributed linearly in 7 days.
1698      * @param _reward Amount of reward token to add.
1699      */
1700     function notifyRewardAmount(uint256 _reward) public updateReward(address(0)) {
1701         require(msg.sender == controller, "not controller");
1702 
1703         if (block.timestamp >= periodFinish) {
1704             rewardRate = _reward.div(DURATION);
1705         } else {
1706             uint256 remaining = periodFinish.sub(block.timestamp);
1707             uint256 leftover = remaining.mul(rewardRate);
1708             rewardRate = _reward.add(leftover).div(DURATION);
1709         }
1710         lastUpdateTime = block.timestamp;
1711         periodFinish = block.timestamp.add(DURATION);
1712 
1713         emit RewardAdded(IController(controller).rewardToken(), _reward);
1714     }
1715 }
1716 
1717 // 
1718 /**
1719  * @notice Controller for vaults.
1720  */
1721 contract Controller is IController {
1722     using SafeMath for uint256;
1723 
1724     address public override rewardToken;
1725     address public governance;
1726     address public reserve;
1727     uint256 public numVaults;
1728     mapping(uint256 => address) public vaults;
1729 
1730     constructor(address _rewardToken) public {
1731         require(_rewardToken != address(0x0), "reward token not set");
1732         
1733         governance = msg.sender;
1734         reserve = msg.sender;
1735         rewardToken = _rewardToken;
1736     }
1737 
1738     /**
1739      * @dev Updates the govenance address.
1740      */
1741     function setGovernance(address _governance) public {
1742         require(msg.sender == governance, "not governance");
1743         governance = _governance;
1744     }
1745 
1746     /**
1747      * @dev Updates the rewards token.
1748      */
1749     function setRewardToken(address _rewardToken) public {
1750         require(msg.sender == governance, "not governance");
1751         require(_rewardToken != address(0x0), "reward token not set");
1752 
1753         rewardToken = _rewardToken;
1754     }
1755 
1756     /**
1757      * @dev Updates the reserve address.
1758      */
1759     function setReserve(address _reserve) public {
1760         require(msg.sender == governance, "not governance");
1761         require(_reserve != address(0x0), "reserve not set");
1762 
1763         reserve = _reserve;
1764     }
1765 
1766     /**
1767      * @dev Add a new vault to the controller.
1768      */
1769     function addVault(address _vault) public {
1770         require(msg.sender == governance, "not governance");
1771         require(_vault != address(0x0), "vault not set");
1772 
1773         vaults[numVaults++] = _vault;
1774     }
1775 
1776     /**
1777      * @dev Add new rewards to a rewarded vault.
1778      * @param _vaultId ID of the vault to have reward.
1779      * @param _rewardAmount Amount of the reward token to add.
1780      */
1781     function addRewards(uint256 _vaultId, uint256 _rewardAmount) public {
1782         require(msg.sender == governance, "not governance");
1783         require(vaults[_vaultId] != address(0x0), "vault not exist");
1784         require(_rewardAmount > 0, "zero amount");
1785 
1786         address vault = vaults[_vaultId];
1787         IERC20Mintable(rewardToken).mint(vault, _rewardAmount);
1788         // Mint 40% of tokens to governance.
1789         IERC20Mintable(rewardToken).mint(reserve, _rewardAmount.mul(2).div(5));
1790         RewardedVault(vault).notifyRewardAmount(_rewardAmount);
1791     }
1792 
1793     /**
1794      * @dev Helpher function to earn in the vault. Anyone can call this method as
1795      * earn() in vault is public!
1796      * @param _vaultId ID of the vault to earn.
1797      */
1798     function earn(uint256 _vaultId) public {
1799         require(vaults[_vaultId] != address(0x0), "vault not exist");
1800         RewardedVault(vaults[_vaultId]).earn();
1801     }
1802 
1803     /**
1804      * @dev Helper function to earn in all vaults. Anyone can call this method as
1805      * earn() in vault is public!
1806      */
1807     function earnAll() public {
1808         for (uint256 i = 0; i < numVaults; i++) {
1809             RewardedVault(vaults[i]).earn();
1810         }
1811     }
1812 }
1813 
1814 // 
1815 /**
1816  * @dev Application to help stake and get rewards.
1817  */
1818 contract StakingApplication {
1819     using SafeMath for uint256;
1820 
1821     event Staked(address indexed staker, uint256 indexed vaultId, address indexed token, uint256 amount);
1822     event Unstaked(address indexed staker, uint256 indexed vaultId, address indexed token, uint256 amount);
1823     event Claimed(address indexed staker, uint256 indexed vaultId, address indexed token, uint256 amount);
1824 
1825     address public governance;
1826     address public accountFactory;
1827     Controller public controller;
1828 
1829     constructor(address _accountFactory, address _controller) public {
1830         require(_accountFactory != address(0x0), "account factory not set");
1831         require(_controller != address(0x0), "controller not set");
1832         
1833         governance = msg.sender;
1834         accountFactory = _accountFactory;
1835         controller = Controller(_controller);
1836     }
1837 
1838     /**
1839      * @dev Updates the govenance address.
1840      */
1841     function setGovernance(address _governance) public {
1842         require(msg.sender == governance, "not governance");
1843         governance = _governance;
1844     }
1845 
1846     /**
1847      * @dev Updates the account factory.
1848      */
1849     function setAccountFactory(address _accountFactory) public {
1850         require(msg.sender == governance, "not governance");
1851         require(_accountFactory != address(0x0), "account factory not set");
1852 
1853         accountFactory = _accountFactory;
1854     }
1855 
1856     /**
1857      * @dev Updates the controller address.
1858      */
1859     function setController(address _controller) public {
1860         require(msg.sender == governance, "not governance");
1861         require(_controller != address(0x0), "controller not set");
1862 
1863         controller = Controller(_controller);
1864     }
1865 
1866     /**
1867      * @dev Retrieve the active account of the user.
1868      */
1869     function _getAccount() internal view returns (Account) {
1870         address _account = AccountFactory(accountFactory).accounts(msg.sender);
1871         require(_account != address(0x0), "no account");
1872         Account account = Account(payable(_account));
1873         require(account.isOperator(address(this)), "not operator");
1874 
1875         return account;
1876     }
1877 
1878     /**
1879      * @dev Stake token into rewarded vault.
1880      * @param _vaultId ID of the vault to stake.
1881      * @param _amount Amount of token to stake.
1882      */
1883     function stake(uint256 _vaultId, uint256 _amount) public {
1884         address _vault = controller.vaults(_vaultId);
1885         require(_vault != address(0x0), "no vault");
1886         require(_amount > 0, "zero amount");
1887 
1888         Account account = _getAccount();
1889         RewardedVault vault = RewardedVault(_vault);
1890         IERC20 token = vault.token();
1891         account.approveToken(address(token), address(vault), _amount);
1892 
1893         bytes memory methodData = abi.encodeWithSignature("deposit(uint256)", _amount);
1894         account.invoke(address(vault), 0, methodData);
1895 
1896         emit Staked(msg.sender, _vaultId, address(token), _amount);
1897     }
1898 
1899     /**
1900      * @dev Unstake token out of RewardedVault.
1901      * @param _vaultId ID of the vault to unstake.
1902      * @param _amount Amount of token to unstake.
1903      */
1904     function unstake(uint256 _vaultId, uint256 _amount) public {
1905         address _vault = controller.vaults(_vaultId);
1906         require(_vault != address(0x0), "no vault");
1907         require(_amount > 0, "zero amount");
1908 
1909         Account account = _getAccount();
1910         RewardedVault vault = RewardedVault(_vault);
1911         IERC20 token = vault.token();
1912 
1913         // Important: Need to convert token amount to vault share!
1914         uint256 totalBalance = vault.balance();
1915         uint256 totalSupply = vault.totalSupply();
1916         uint256 shares = _amount.mul(totalSupply).div(totalBalance);
1917         bytes memory methodData = abi.encodeWithSignature("withdraw(uint256)", shares);
1918         account.invoke(address(vault), 0, methodData);
1919 
1920         emit Unstaked(msg.sender, _vaultId, address(token), _amount);
1921     }
1922 
1923     /**
1924      * @dev Unstake all token out of RewardedVault.
1925      * @param _vaultId ID of the vault to unstake.
1926      */
1927     function unstakeAll(uint256 _vaultId) public {
1928         address _vault = controller.vaults(_vaultId);
1929         require(_vault != address(0x0), "no vault");
1930 
1931         Account account = _getAccount();
1932         RewardedVault vault = RewardedVault(_vault);
1933         IERC20 token = vault.token();
1934 
1935         uint256 totalBalance = vault.balance();
1936         uint256 totalSupply = vault.totalSupply();
1937         uint256 shares = vault.balanceOf(address(account));
1938         uint256 amount = shares.mul(totalBalance).div(totalSupply);
1939         bytes memory methodData = abi.encodeWithSignature("withdraw(uint256)", shares);
1940         account.invoke(address(vault), 0, methodData);
1941 
1942         emit Unstaked(msg.sender, _vaultId, address(token), amount);
1943     }
1944 
1945     /**
1946      * @dev Claims rewards from RewardedVault.
1947      * @param _vaultId ID of the vault to unstake.
1948      */
1949     function claimRewards(uint256 _vaultId) public {
1950         address _vault = controller.vaults(_vaultId);
1951         require(_vault != address(0x0), "no vault");
1952 
1953         Account account = _getAccount();
1954         RewardedVault vault = RewardedVault(_vault);
1955         IERC20 rewardToken = IERC20(controller.rewardToken());
1956         bytes memory methodData = abi.encodeWithSignature("claimReward()");
1957         bytes memory methodResult = account.invoke(address(vault), 0, methodData);
1958         uint256 claimAmount = abi.decode(methodResult, (uint256));
1959 
1960         emit Claimed(msg.sender, _vaultId, address(rewardToken), claimAmount);
1961     }
1962 
1963     /**
1964      * @dev Retrieves the amount of token staked in RewardedVault.
1965      * @param _vaultId ID of the vault to unstake.
1966      */
1967     function getStakeBalance(uint256 _vaultId) public view returns (uint256) {
1968         address _vault = controller.vaults(_vaultId);
1969         require(_vault != address(0x0), "no vault");
1970         address account = AccountFactory(accountFactory).accounts(msg.sender);
1971         require(account != address(0x0), "no account");
1972 
1973         RewardedVault vault = RewardedVault(_vault);
1974         uint256 totalBalance = vault.balance();
1975         uint256 totalSupply = vault.totalSupply();
1976         uint256 share = vault.balanceOf(account);
1977 
1978         return totalBalance.mul(share).div(totalSupply);
1979     }
1980 
1981     /**
1982      * @dev Returns the total balance of the vault.
1983      */
1984     function getVaultBalance(uint256 _vaultId) public view returns (uint256) {
1985         address _vault = controller.vaults(_vaultId);
1986         require(_vault != address(0x0), "no vault");
1987 
1988         RewardedVault vault = RewardedVault(_vault);
1989         return vault.balance();
1990     }
1991 
1992     /**
1993      * @dev Return the amount of unclaim rewards.
1994      * @param _vaultId ID of the vault to unstake.
1995      */
1996     function getUnclaimedReward(uint256 _vaultId) public view returns (uint256) {
1997         address _vault = controller.vaults(_vaultId);
1998         require(_vault != address(0x0), "no vault");
1999         address account = AccountFactory(accountFactory).accounts(msg.sender);
2000         require(account != address(0x0), "no account");
2001 
2002         return RewardedVault(_vault).earned(account);
2003     }
2004 
2005     /**
2006      * @dev Return the amount of claim rewards.
2007      * @param _vaultId ID of the vault to unstake.
2008      */
2009     function getClaimedReward(uint256 _vaultId) public view returns (uint256) {
2010         address _vault = controller.vaults(_vaultId);
2011         require(_vault != address(0x0), "no vault");
2012         address account = AccountFactory(accountFactory).accounts(msg.sender);
2013         require(account != address(0x0), "no account");
2014         
2015         return RewardedVault(_vault).claims(account);
2016     }
2017 }