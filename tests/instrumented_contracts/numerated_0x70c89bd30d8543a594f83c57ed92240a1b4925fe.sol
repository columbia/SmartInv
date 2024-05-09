1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-04
3 */
4 
5 // SPDX-License-Identifier: BSD-3-Clause
6 
7 pragma solidity 0.6.11;
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      *
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 /**
166  * @dev Collection of functions related to the address type
167  */
168 library Address {
169     /**
170      * @dev Returns true if `account` is a contract.
171      *
172      * [IMPORTANT]
173      * ====
174      * It is unsafe to assume that an address for which this function returns
175      * false is an externally-owned account (EOA) and not a contract.
176      *
177      * Among others, `isContract` will return false for the following
178      * types of addresses:
179      *
180      *  - an externally-owned account
181      *  - a contract in construction
182      *  - an address where a contract will be created
183      *  - an address where a contract lived, but was destroyed
184      * ====
185      */
186     function isContract(address account) internal view returns (bool) {
187         // This method relies in extcodesize, which returns 0 for contracts in
188         // construction, since the code is only stored at the end of the
189         // constructor execution.
190 
191         uint256 size;
192         // solhint-disable-next-line no-inline-assembly
193         assembly { size := extcodesize(account) }
194         return size > 0;
195     }
196 
197     /**
198      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
199      * `recipient`, forwarding all available gas and reverting on errors.
200      *
201      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
202      * of certain opcodes, possibly making contracts go over the 2300 gas limit
203      * imposed by `transfer`, making them unable to receive funds via
204      * `transfer`. {sendValue} removes this limitation.
205      *
206      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
207      *
208      * IMPORTANT: because control is transferred to `recipient`, care must be
209      * taken to not create reentrancy vulnerabilities. Consider using
210      * {ReentrancyGuard} or the
211      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
212      */
213     function sendValue(address payable recipient, uint256 amount) internal {
214         require(address(this).balance >= amount, "Address: insufficient balance");
215 
216         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
217         (bool success, ) = recipient.call{ value: amount }("");
218         require(success, "Address: unable to send value, recipient may have reverted");
219     }
220 
221     /**
222      * @dev Performs a Solidity function call using a low level `call`. A
223      * plain`call` is an unsafe replacement for a function call: use this
224      * function instead.
225      *
226      * If `target` reverts with a revert reason, it is bubbled up by this
227      * function (like regular Solidity function calls).
228      *
229      * Returns the raw returned data. To convert to the expected return value,
230      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
231      *
232      * Requirements:
233      *
234      * - `target` must be a contract.
235      * - calling `target` with `data` must not revert.
236      *
237      * _Available since v3.1._
238      */
239     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
240       return functionCall(target, data, "Address: low-level call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
245      * `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
250         return _functionCallWithValue(target, data, 0, errorMessage);
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
255      * but also transferring `value` wei to `target`.
256      *
257      * Requirements:
258      *
259      * - the calling contract must have an ETH balance of at least `value`.
260      * - the called Solidity function must be `payable`.
261      *
262      * _Available since v3.1._
263      */
264     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
265         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
266     }
267 
268     /**
269      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
270      * with `errorMessage` as a fallback revert reason when `target` reverts.
271      *
272      * _Available since v3.1._
273      */
274     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
275         require(address(this).balance >= value, "Address: insufficient balance for call");
276         return _functionCallWithValue(target, data, value, errorMessage);
277     }
278 
279     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
280         require(isContract(target), "Address: call to non-contract");
281 
282         // solhint-disable-next-line avoid-low-level-calls
283         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
284         if (success) {
285             return returndata;
286         } else {
287             // Look for revert reason and bubble it up if present
288             if (returndata.length > 0) {
289                 // The easiest way to bubble the revert reason is using memory via assembly
290 
291                 // solhint-disable-next-line no-inline-assembly
292                 assembly {
293                     let returndata_size := mload(returndata)
294                     revert(add(32, returndata), returndata_size)
295                 }
296             } else {
297                 revert(errorMessage);
298             }
299         }
300     }
301 }
302 
303 /**
304  * @title SafeERC20
305  * @dev Wrappers around ERC20 operations that throw on failure (when the token
306  * contract returns false). Tokens that return no value (and instead revert or
307  * throw on failure) are also supported, non-reverting calls are assumed to be
308  * successful.
309  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
310  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
311  */
312 library SafeERC20 {
313     using SafeMath for uint256;
314     using Address for address;
315 
316     function safeTransfer(IERC20 token, address to, uint256 value) internal {
317         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
318     }
319 
320     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
321         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
322     }
323 
324     /**
325      * @dev Deprecated. This function has issues similar to the ones found in
326      * {IERC20-approve}, and its usage is discouraged.
327      *
328      * Whenever possible, use {safeIncreaseAllowance} and
329      * {safeDecreaseAllowance} instead.
330      */
331     function safeApprove(IERC20 token, address spender, uint256 value) internal {
332         // safeApprove should only be called when setting an initial allowance,
333         // or when resetting it to zero. To increase and decrease it, use
334         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
335         // solhint-disable-next-line max-line-length
336         require((value == 0) || (token.allowance(address(this), spender) == 0),
337             "SafeERC20: approve from non-zero to non-zero allowance"
338         );
339         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
340     }
341 
342     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
343         uint256 newAllowance = token.allowance(address(this), spender).add(value);
344         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
345     }
346 
347     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
348         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
349         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
350     }
351 
352     /**
353      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
354      * on the return value: the return value is optional (but if data is returned, it must not be false).
355      * @param token The token targeted by the call.
356      * @param data The call data (encoded using abi.encode or one of its variants).
357      */
358     function _callOptionalReturn(IERC20 token, bytes memory data) private {
359         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
360         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
361         // the target address contains contract code and also asserts for success in the low-level call.
362 
363         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
364         if (returndata.length > 0) { // Return data is optional
365             // solhint-disable-next-line max-line-length
366             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
367         }
368     }
369 }
370 
371 /**
372  * @dev Interface of the ERC20 standard as defined in the EIP.
373  */
374 interface IERC20 {
375     /**
376      * @dev Returns the amount of tokens in existence.
377      */
378     function totalSupply() external view returns (uint256);
379 
380     /**
381      * @dev Returns the amount of tokens owned by `account`.
382      */
383     function balanceOf(address account) external view returns (uint256);
384 
385     /**
386      * @dev Moves `amount` tokens from the caller's account to `recipient`.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transfer(address recipient, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Returns the remaining number of tokens that `spender` will be
396      * allowed to spend on behalf of `owner` through {transferFrom}. This is
397      * zero by default.
398      *
399      * This value changes when {approve} or {transferFrom} are called.
400      */
401     function allowance(address owner, address spender) external view returns (uint256);
402 
403     /**
404      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
405      *
406      * Returns a boolean value indicating whether the operation succeeded.
407      *
408      * IMPORTANT: Beware that changing an allowance with this method brings the risk
409      * that someone may use both the old and the new allowance by unfortunate
410      * transaction ordering. One possible solution to mitigate this race
411      * condition is to first reduce the spender's allowance to 0 and set the
412      * desired value afterwards:
413      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
414      *
415      * Emits an {Approval} event.
416      */
417     function approve(address spender, uint256 amount) external returns (bool);
418 
419     /**
420      * @dev Moves `amount` tokens from `sender` to `recipient` using the
421      * allowance mechanism. `amount` is then deducted from the caller's
422      * allowance.
423      *
424      * Returns a boolean value indicating whether the operation succeeded.
425      *
426      * Emits a {Transfer} event.
427      */
428     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
429 
430     /**
431      * @dev Emitted when `value` tokens are moved from one account (`from`) to
432      * another (`to`).
433      *
434      * Note that `value` may be zero.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 value);
437 
438     /**
439      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
440      * a call to {approve}. `value` is the new allowance.
441      */
442     event Approval(address indexed owner, address indexed spender, uint256 value);
443 }
444 
445 /**
446  * @dev Contract module that helps prevent reentrant calls to a function.
447  *
448  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
449  * available, which can be applied to functions to make sure there are no nested
450  * (reentrant) calls to them.
451  *
452  * Note that because there is a single `nonReentrant` guard, functions marked as
453  * `nonReentrant` may not call one another. This can be worked around by making
454  * those functions `private`, and then adding `external` `nonReentrant` entry
455  * points to them.
456  *
457  * TIP: If you would like to learn more about reentrancy and alternative ways
458  * to protect against it, check out our blog post
459  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
460  */
461 contract ReentrancyGuard {
462     // Booleans are more expensive than uint256 or any type that takes up a full
463     // word because each write operation emits an extra SLOAD to first read the
464     // slot's contents, replace the bits taken up by the boolean, and then write
465     // back. This is the compiler's defense against contract upgrades and
466     // pointer aliasing, and it cannot be disabled.
467 
468     // The values being non-zero value makes deployment a bit more expensive,
469     // but in exchange the refund on every call to nonReentrant will be lower in
470     // amount. Since refunds are capped to a percentage of the total
471     // transaction's gas, it is best to keep them low in cases like this one, to
472     // increase the likelihood of the full refund coming into effect.
473     uint256 private constant _NOT_ENTERED = 1;
474     uint256 private constant _ENTERED = 2;
475 
476     uint256 private _status;
477 
478     constructor () internal {
479         _status = _NOT_ENTERED;
480     }
481 
482     /**
483      * @dev Prevents a contract from calling itself, directly or indirectly.
484      * Calling a `nonReentrant` function from another `nonReentrant`
485      * function is not supported. It is possible to prevent this from happening
486      * by making the `nonReentrant` function external, and make it call a
487      * `private` function that does the actual work.
488      */
489     modifier nonReentrant() {
490         // On the first call to nonReentrant, _notEntered will be true
491         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
492 
493         // Any calls to nonReentrant after this point will fail
494         _status = _ENTERED;
495 
496         _;
497 
498         // By storing the original value once again, a refund is triggered (see
499         // https://eips.ethereum.org/EIPS/eip-2200)
500         _status = _NOT_ENTERED;
501     }
502 }
503 
504 /**
505  * @dev Contract module which provides a basic access control mechanism, where
506  * there is an account (an owner) that can be granted exclusive access to
507  * specific functions.
508  *
509  * By default, the owner account will be the one that deploys the contract. This
510  * can later be changed with {transferOwnership}.
511  *
512  * This module is used through inheritance. It will make available the modifier
513  * `onlyOwner`, which can be applied to your functions to restrict their use to
514  * the owner.
515  */
516 contract Ownable {
517     address private _owner;
518 
519     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
520 
521     /**
522      * @dev Initializes the contract setting the deployer as the initial owner.
523      */
524     constructor () internal {
525         address msgSender = msg.sender;
526         _owner = msgSender;
527         emit OwnershipTransferred(address(0), msgSender);
528     }
529 
530     /**
531      * @dev Returns the address of the current owner.
532      */
533     function owner() public view returns (address) {
534         return _owner;
535     }
536 
537     /**
538      * @dev Throws if called by any account other than the owner.
539      */
540     modifier onlyOwner() {
541         require(_owner == msg.sender, "Ownable: caller is not the owner");
542         _;
543     }
544 
545     /**
546      * @dev Leaves the contract without owner. It will not be possible to call
547      * `onlyOwner` functions anymore. Can only be called by the current owner.
548      *
549      * NOTE: Renouncing ownership will leave the contract without an owner,
550      * thereby removing any functionality that is only available to the owner.
551      */
552     function renounceOwnership() public virtual onlyOwner {
553         emit OwnershipTransferred(_owner, address(0));
554         _owner = address(0);
555     }
556 
557     /**
558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
559      * Can only be called by the current owner.
560      */
561     function transferOwnership(address newOwner) public virtual onlyOwner {
562         require(newOwner != address(0), "Ownable: new owner is the zero address");
563         emit OwnershipTransferred(_owner, newOwner);
564         _owner = newOwner;
565     }
566 }
567 
568 
569 contract Bridge is Ownable, ReentrancyGuard {
570     using SafeMath for uint;
571     using SafeERC20 for IERC20;
572     using Address for address;
573     
574     modifier noContractsAllowed() {
575         require(!(address(msg.sender).isContract()) && tx.origin == msg.sender, "No Contracts Allowed!");
576         _;
577     }
578     
579     // ----------------------- Smart Contract Variables -----------------------
580     // Must be updated before live deployment.
581     
582     uint public dailyTokenWithdrawLimitPerAccount = 25_000e18;
583     uint public constant CHAIN_ID = 1;
584     uint public constant ONE_DAY = 24 hours;
585     
586     address public constant TRUSTED_TOKEN_ADDRESS = 0xBD100d061E120b2c67A24453CF6368E63f1Be056;
587     address public verifyAddress = 0x072bc8750a0852C0eac038be3E7f2e7c7dAb1E94;
588     
589     // ----------------------- End Smart Contract Variables -----------------------
590     
591     event Deposit(address indexed account, uint amount, uint blocknumber, uint timestamp, uint id);
592     event Withdraw(address indexed account, uint amount, uint id);
593     
594     mapping (address => uint) public lastUpdatedTokenWithdrawTimestamp;
595     mapping (address => uint) public lastUpdatedTokenWithdrawAmount;
596 
597     
598     // deposit index OF OTHER CHAIN => withdrawal in current chain
599     mapping (uint => bool) public claimedWithdrawalsByOtherChainDepositId;
600     
601     // deposit index for current chain
602     uint public lastDepositIndex;
603     
604     function setVerifyAddress(address newVerifyAddress) external noContractsAllowed onlyOwner {
605         verifyAddress = newVerifyAddress;
606     }
607     function setDailyLimit(uint newDailyTokenWithdrawLimitPerAccount) external noContractsAllowed onlyOwner {
608         dailyTokenWithdrawLimitPerAccount = newDailyTokenWithdrawLimitPerAccount;
609     }
610     
611     function deposit(uint amount) external noContractsAllowed nonReentrant {
612         require(amount <= dailyTokenWithdrawLimitPerAccount, "amount exceeds limit");
613         
614         lastDepositIndex = lastDepositIndex.add(1);
615         IERC20(TRUSTED_TOKEN_ADDRESS).safeTransferFrom(msg.sender, address(this), amount);
616         
617         emit Deposit(msg.sender, amount, block.number, block.timestamp, lastDepositIndex);
618     }
619     function withdraw(uint amount, uint chainId, uint id, bytes calldata signature) external noContractsAllowed nonReentrant {
620         require(chainId == CHAIN_ID, "invalid chainId!");
621         require(!claimedWithdrawalsByOtherChainDepositId[id], "already withdrawn!");
622         require(verify(msg.sender, amount, chainId, id, signature), "invalid signature!");
623         require(canWithdraw(msg.sender, amount), "cannot withdraw, limit reached for current duration!");
624         
625         claimedWithdrawalsByOtherChainDepositId[id] = true;
626         IERC20(TRUSTED_TOKEN_ADDRESS).safeTransfer(msg.sender, amount);
627         
628         emit Withdraw(msg.sender, amount, id);
629     }
630     
631     function canWithdraw(address account, uint amount) private returns (bool) {
632         if (block.timestamp.sub(lastUpdatedTokenWithdrawTimestamp[account]) >= ONE_DAY) {
633             lastUpdatedTokenWithdrawAmount[account] = 0;
634             lastUpdatedTokenWithdrawTimestamp[account] = block.timestamp;
635         }
636         lastUpdatedTokenWithdrawAmount[account] = lastUpdatedTokenWithdrawAmount[account].add(amount);
637         return lastUpdatedTokenWithdrawAmount[account] <= dailyTokenWithdrawLimitPerAccount;
638     }
639     
640     // the Bridge is a centralized service, allow admin to transfer any ERC20 token if required in case of emergencies
641     function transferAnyERC20Token(address tokenAddress, address recipient, uint amount) external noContractsAllowed onlyOwner {
642         IERC20(tokenAddress).safeTransfer(recipient, amount);
643     }
644     
645     /// signature methods.
646 	function verify(
647 		address account, 
648 		uint amount,
649 		uint chainId,
650 		uint id,
651 		bytes calldata signature
652 	) 
653 		internal view returns(bool) 
654 	{
655 		bytes32 message = prefixed(keccak256(abi.encode(account, amount, chainId, id, address(this))));
656         return (recoverSigner(message, signature) == verifyAddress);
657 	}
658     
659     function recoverSigner(bytes32 message, bytes memory sig)
660         internal
661         pure
662         returns (address)
663     {
664         (uint8 v, bytes32 r, bytes32 s) = abi.decode(sig, (uint8, bytes32, bytes32));
665 
666         return ecrecover(message, v, r, s);
667     }
668 
669     /// builds a prefixed hash to mimic the behavior of eth_sign.
670     function prefixed(bytes32 hash) internal pure returns (bytes32) {
671         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
672     }
673 }