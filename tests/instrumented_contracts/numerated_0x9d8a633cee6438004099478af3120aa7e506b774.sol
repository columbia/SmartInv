1 // SPDX-License-Identifier: BSD-3-Clause
2 
3 pragma solidity 0.6.11;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 /**
162  * @dev Collection of functions related to the address type
163  */
164 library Address {
165     /**
166      * @dev Returns true if `account` is a contract.
167      *
168      * [IMPORTANT]
169      * ====
170      * It is unsafe to assume that an address for which this function returns
171      * false is an externally-owned account (EOA) and not a contract.
172      *
173      * Among others, `isContract` will return false for the following
174      * types of addresses:
175      *
176      *  - an externally-owned account
177      *  - a contract in construction
178      *  - an address where a contract will be created
179      *  - an address where a contract lived, but was destroyed
180      * ====
181      */
182     function isContract(address account) internal view returns (bool) {
183         // This method relies in extcodesize, which returns 0 for contracts in
184         // construction, since the code is only stored at the end of the
185         // constructor execution.
186 
187         uint256 size;
188         // solhint-disable-next-line no-inline-assembly
189         assembly { size := extcodesize(account) }
190         return size > 0;
191     }
192 
193     /**
194      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
195      * `recipient`, forwarding all available gas and reverting on errors.
196      *
197      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
198      * of certain opcodes, possibly making contracts go over the 2300 gas limit
199      * imposed by `transfer`, making them unable to receive funds via
200      * `transfer`. {sendValue} removes this limitation.
201      *
202      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
203      *
204      * IMPORTANT: because control is transferred to `recipient`, care must be
205      * taken to not create reentrancy vulnerabilities. Consider using
206      * {ReentrancyGuard} or the
207      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
208      */
209     function sendValue(address payable recipient, uint256 amount) internal {
210         require(address(this).balance >= amount, "Address: insufficient balance");
211 
212         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
213         (bool success, ) = recipient.call{ value: amount }("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 
217     /**
218      * @dev Performs a Solidity function call using a low level `call`. A
219      * plain`call` is an unsafe replacement for a function call: use this
220      * function instead.
221      *
222      * If `target` reverts with a revert reason, it is bubbled up by this
223      * function (like regular Solidity function calls).
224      *
225      * Returns the raw returned data. To convert to the expected return value,
226      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
227      *
228      * Requirements:
229      *
230      * - `target` must be a contract.
231      * - calling `target` with `data` must not revert.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
236       return functionCall(target, data, "Address: low-level call failed");
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
241      * `errorMessage` as a fallback revert reason when `target` reverts.
242      *
243      * _Available since v3.1._
244      */
245     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
246         return _functionCallWithValue(target, data, 0, errorMessage);
247     }
248 
249     /**
250      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
251      * but also transferring `value` wei to `target`.
252      *
253      * Requirements:
254      *
255      * - the calling contract must have an ETH balance of at least `value`.
256      * - the called Solidity function must be `payable`.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
261         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
266      * with `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
271         require(address(this).balance >= value, "Address: insufficient balance for call");
272         return _functionCallWithValue(target, data, value, errorMessage);
273     }
274 
275     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
276         require(isContract(target), "Address: call to non-contract");
277 
278         // solhint-disable-next-line avoid-low-level-calls
279         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
280         if (success) {
281             return returndata;
282         } else {
283             // Look for revert reason and bubble it up if present
284             if (returndata.length > 0) {
285                 // The easiest way to bubble the revert reason is using memory via assembly
286 
287                 // solhint-disable-next-line no-inline-assembly
288                 assembly {
289                     let returndata_size := mload(returndata)
290                     revert(add(32, returndata), returndata_size)
291                 }
292             } else {
293                 revert(errorMessage);
294             }
295         }
296     }
297 }
298 
299 /**
300  * @title SafeERC20
301  * @dev Wrappers around ERC20 operations that throw on failure (when the token
302  * contract returns false). Tokens that return no value (and instead revert or
303  * throw on failure) are also supported, non-reverting calls are assumed to be
304  * successful.
305  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
306  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
307  */
308 library SafeERC20 {
309     using SafeMath for uint256;
310     using Address for address;
311 
312     function safeTransfer(IERC20 token, address to, uint256 value) internal {
313         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
314     }
315 
316     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
317         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
318     }
319 
320     /**
321      * @dev Deprecated. This function has issues similar to the ones found in
322      * {IERC20-approve}, and its usage is discouraged.
323      *
324      * Whenever possible, use {safeIncreaseAllowance} and
325      * {safeDecreaseAllowance} instead.
326      */
327     function safeApprove(IERC20 token, address spender, uint256 value) internal {
328         // safeApprove should only be called when setting an initial allowance,
329         // or when resetting it to zero. To increase and decrease it, use
330         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
331         // solhint-disable-next-line max-line-length
332         require((value == 0) || (token.allowance(address(this), spender) == 0),
333             "SafeERC20: approve from non-zero to non-zero allowance"
334         );
335         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
336     }
337 
338     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
339         uint256 newAllowance = token.allowance(address(this), spender).add(value);
340         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
341     }
342 
343     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
344         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
345         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
346     }
347 
348     /**
349      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
350      * on the return value: the return value is optional (but if data is returned, it must not be false).
351      * @param token The token targeted by the call.
352      * @param data The call data (encoded using abi.encode or one of its variants).
353      */
354     function _callOptionalReturn(IERC20 token, bytes memory data) private {
355         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
356         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
357         // the target address contains contract code and also asserts for success in the low-level call.
358 
359         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
360         if (returndata.length > 0) { // Return data is optional
361             // solhint-disable-next-line max-line-length
362             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
363         }
364     }
365 }
366 
367 /**
368  * @dev Interface of the ERC20 standard as defined in the EIP.
369  */
370 interface IERC20 {
371     /**
372      * @dev Returns the amount of tokens in existence.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     /**
377      * @dev Returns the amount of tokens owned by `account`.
378      */
379     function balanceOf(address account) external view returns (uint256);
380 
381     /**
382      * @dev Moves `amount` tokens from the caller's account to `recipient`.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transfer(address recipient, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Returns the remaining number of tokens that `spender` will be
392      * allowed to spend on behalf of `owner` through {transferFrom}. This is
393      * zero by default.
394      *
395      * This value changes when {approve} or {transferFrom} are called.
396      */
397     function allowance(address owner, address spender) external view returns (uint256);
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * IMPORTANT: Beware that changing an allowance with this method brings the risk
405      * that someone may use both the old and the new allowance by unfortunate
406      * transaction ordering. One possible solution to mitigate this race
407      * condition is to first reduce the spender's allowance to 0 and set the
408      * desired value afterwards:
409      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
410      *
411      * Emits an {Approval} event.
412      */
413     function approve(address spender, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Moves `amount` tokens from `sender` to `recipient` using the
417      * allowance mechanism. `amount` is then deducted from the caller's
418      * allowance.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
425 
426     /**
427      * @dev Emitted when `value` tokens are moved from one account (`from`) to
428      * another (`to`).
429      *
430      * Note that `value` may be zero.
431      */
432     event Transfer(address indexed from, address indexed to, uint256 value);
433 
434     /**
435      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
436      * a call to {approve}. `value` is the new allowance.
437      */
438     event Approval(address indexed owner, address indexed spender, uint256 value);
439 }
440 
441 /**
442  * @dev Contract module that helps prevent reentrant calls to a function.
443  *
444  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
445  * available, which can be applied to functions to make sure there are no nested
446  * (reentrant) calls to them.
447  *
448  * Note that because there is a single `nonReentrant` guard, functions marked as
449  * `nonReentrant` may not call one another. This can be worked around by making
450  * those functions `private`, and then adding `external` `nonReentrant` entry
451  * points to them.
452  *
453  * TIP: If you would like to learn more about reentrancy and alternative ways
454  * to protect against it, check out our blog post
455  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
456  */
457 contract ReentrancyGuard {
458     // Booleans are more expensive than uint256 or any type that takes up a full
459     // word because each write operation emits an extra SLOAD to first read the
460     // slot's contents, replace the bits taken up by the boolean, and then write
461     // back. This is the compiler's defense against contract upgrades and
462     // pointer aliasing, and it cannot be disabled.
463 
464     // The values being non-zero value makes deployment a bit more expensive,
465     // but in exchange the refund on every call to nonReentrant will be lower in
466     // amount. Since refunds are capped to a percentage of the total
467     // transaction's gas, it is best to keep them low in cases like this one, to
468     // increase the likelihood of the full refund coming into effect.
469     uint256 private constant _NOT_ENTERED = 1;
470     uint256 private constant _ENTERED = 2;
471 
472     uint256 private _status;
473 
474     constructor () internal {
475         _status = _NOT_ENTERED;
476     }
477 
478     /**
479      * @dev Prevents a contract from calling itself, directly or indirectly.
480      * Calling a `nonReentrant` function from another `nonReentrant`
481      * function is not supported. It is possible to prevent this from happening
482      * by making the `nonReentrant` function external, and make it call a
483      * `private` function that does the actual work.
484      */
485     modifier nonReentrant() {
486         // On the first call to nonReentrant, _notEntered will be true
487         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
488 
489         // Any calls to nonReentrant after this point will fail
490         _status = _ENTERED;
491 
492         _;
493 
494         // By storing the original value once again, a refund is triggered (see
495         // https://eips.ethereum.org/EIPS/eip-2200)
496         _status = _NOT_ENTERED;
497     }
498 }
499 
500 /**
501  * @dev Contract module which provides a basic access control mechanism, where
502  * there is an account (an owner) that can be granted exclusive access to
503  * specific functions.
504  *
505  * By default, the owner account will be the one that deploys the contract. This
506  * can later be changed with {transferOwnership}.
507  *
508  * This module is used through inheritance. It will make available the modifier
509  * `onlyOwner`, which can be applied to your functions to restrict their use to
510  * the owner.
511  */
512 contract Ownable {
513     address private _owner;
514 
515     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
516 
517     /**
518      * @dev Initializes the contract setting the deployer as the initial owner.
519      */
520     constructor () internal {
521         address msgSender = msg.sender;
522         _owner = msgSender;
523         emit OwnershipTransferred(address(0), msgSender);
524     }
525 
526     /**
527      * @dev Returns the address of the current owner.
528      */
529     function owner() public view returns (address) {
530         return _owner;
531     }
532 
533     /**
534      * @dev Throws if called by any account other than the owner.
535      */
536     modifier onlyOwner() {
537         require(_owner == msg.sender, "Ownable: caller is not the owner");
538         _;
539     }
540 
541     /**
542      * @dev Leaves the contract without owner. It will not be possible to call
543      * `onlyOwner` functions anymore. Can only be called by the current owner.
544      *
545      * NOTE: Renouncing ownership will leave the contract without an owner,
546      * thereby removing any functionality that is only available to the owner.
547      */
548     function renounceOwnership() public virtual onlyOwner {
549         emit OwnershipTransferred(_owner, address(0));
550         _owner = address(0);
551     }
552 
553     /**
554      * @dev Transfers ownership of the contract to a new account (`newOwner`).
555      * Can only be called by the current owner.
556      */
557     function transferOwnership(address newOwner) public virtual onlyOwner {
558         require(newOwner != address(0), "Ownable: new owner is the zero address");
559         emit OwnershipTransferred(_owner, newOwner);
560         _owner = newOwner;
561     }
562 }
563 
564 
565 contract Bridge is Ownable, ReentrancyGuard {
566     using SafeMath for uint;
567     using SafeERC20 for IERC20;
568     using Address for address;
569     
570     modifier noContractsAllowed() {
571         require(!(address(msg.sender).isContract()) && tx.origin == msg.sender, "No Contracts Allowed!");
572         _;
573     }
574     
575     // ----------------------- Smart Contract Variables -----------------------
576     // Must be updated before live deployment.
577     
578     uint public dailyTokenWithdrawLimitPerAccount = 25_000e18;
579     uint public constant CHAIN_ID = 1;
580     uint public constant ONE_DAY = 24 hours;
581     
582     address public constant TRUSTED_TOKEN_ADDRESS = 0xBD100d061E120b2c67A24453CF6368E63f1Be056;
583     address public verifyAddress = 0x072bc8750a0852C0eac038be3E7f2e7c7dAb1E94;
584     
585     // ----------------------- End Smart Contract Variables -----------------------
586     
587     event Deposit(address indexed account, uint amount, uint blocknumber, uint timestamp, uint id);
588     event Withdraw(address indexed account, uint amount, uint id);
589     
590     mapping (address => uint) public lastUpdatedTokenWithdrawTimestamp;
591     mapping (address => uint) public lastUpdatedTokenWithdrawAmount;
592 
593     
594     // deposit index OF OTHER CHAIN => withdrawal in current chain
595     mapping (uint => bool) public claimedWithdrawalsByOtherChainDepositId;
596     
597     // deposit index for current chain
598     uint public lastDepositIndex;
599     
600     function setVerifyAddress(address newVerifyAddress) external noContractsAllowed onlyOwner {
601         verifyAddress = newVerifyAddress;
602     }
603     function setDailyLimit(uint newDailyTokenWithdrawLimitPerAccount) external noContractsAllowed onlyOwner {
604         dailyTokenWithdrawLimitPerAccount = newDailyTokenWithdrawLimitPerAccount;
605     }
606     
607     function deposit(uint amount) external noContractsAllowed nonReentrant {
608         require(amount <= dailyTokenWithdrawLimitPerAccount, "amount exceeds limit");
609         
610         lastDepositIndex = lastDepositIndex.add(1);
611         IERC20(TRUSTED_TOKEN_ADDRESS).safeTransferFrom(msg.sender, address(this), amount);
612         
613         emit Deposit(msg.sender, amount, block.number, block.timestamp, lastDepositIndex);
614     }
615     function withdraw(uint amount, uint chainId, uint id, bytes calldata signature) external noContractsAllowed nonReentrant {
616         require(chainId == CHAIN_ID, "invalid chainId!");
617         require(!claimedWithdrawalsByOtherChainDepositId[id], "already withdrawn!");
618         require(verify(msg.sender, amount, chainId, id, signature), "invalid signature!");
619         require(canWithdraw(msg.sender, amount), "cannot withdraw, limit reached for current duration!");
620         
621         claimedWithdrawalsByOtherChainDepositId[id] = true;
622         IERC20(TRUSTED_TOKEN_ADDRESS).safeTransfer(msg.sender, amount);
623         
624         emit Withdraw(msg.sender, amount, id);
625     }
626     
627     function canWithdraw(address account, uint amount) private returns (bool) {
628         if (block.timestamp.sub(lastUpdatedTokenWithdrawTimestamp[account]) >= ONE_DAY) {
629             lastUpdatedTokenWithdrawAmount[account] = 0;
630             lastUpdatedTokenWithdrawTimestamp[account] = block.timestamp;
631         }
632         lastUpdatedTokenWithdrawAmount[account] = lastUpdatedTokenWithdrawAmount[account].add(amount);
633         return lastUpdatedTokenWithdrawAmount[account] <= dailyTokenWithdrawLimitPerAccount;
634     }
635     
636     // the Bridge is a centralized service, allow admin to transfer any ERC20 token if required in case of emergencies
637     function transferAnyERC20Token(address tokenAddress, address recipient, uint amount) external noContractsAllowed onlyOwner {
638         IERC20(tokenAddress).safeTransfer(recipient, amount);
639     }
640     
641     /// signature methods.
642 	function verify(
643 		address account, 
644 		uint amount,
645 		uint chainId,
646 		uint id,
647 		bytes calldata signature
648 	) 
649 		internal view returns(bool) 
650 	{
651 		bytes32 message = prefixed(keccak256(abi.encode(account, amount, chainId, id, address(this))));
652         return (recoverSigner(message, signature) == verifyAddress);
653 	}
654     
655     function recoverSigner(bytes32 message, bytes memory sig)
656         internal
657         pure
658         returns (address)
659     {
660         (uint8 v, bytes32 r, bytes32 s) = abi.decode(sig, (uint8, bytes32, bytes32));
661 
662         return ecrecover(message, v, r, s);
663     }
664 
665     /// builds a prefixed hash to mimic the behavior of eth_sign.
666     function prefixed(bytes32 hash) internal pure returns (bytes32) {
667         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
668     }
669 }