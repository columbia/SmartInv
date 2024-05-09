1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/GSN/Context.sol
465 
466 
467 
468 pragma solidity ^0.6.0;
469 
470 /*
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with GSN meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address payable) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes memory) {
486         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
487         return msg.data;
488     }
489 }
490 
491 // File: contracts/Ownable.sol
492 
493 pragma solidity ^0.6.10;
494 
495 
496 contract Ownable is Context {
497 
498     address payable public owner;
499 
500     event TransferredOwnership(address _previous, address _next, uint256 _time);
501     event AddedPlatformAddress(address _platformAddress, uint256 _time);
502     event RemovedPlatformAddress(address _platformAddress, uint256 _time);
503 
504     modifier onlyOwner() {
505         require(_msgSender() == owner, "Owner only");
506         _;
507     }
508 
509     modifier onlyPlatform() {
510         require(platformAddress[_msgSender()] == true, "Only Platform");
511         _;
512     }
513 
514     mapping(address => bool) platformAddress;
515 
516     constructor() public {
517         owner = _msgSender();
518     }
519 
520     // Function to transfer ownership
521     function transferOwnership(address payable _owner) public onlyOwner() {
522         address previousOwner = owner;
523         owner = _owner;
524         emit TransferredOwnership(previousOwner, owner, now);
525     }
526 
527     // Function to add platform address
528     function addPlatformAddress(address _platformAddress) public onlyOwner() {
529         require(platformAddress[_platformAddress] == false, "already platform address");
530         platformAddress[_platformAddress] = true;
531 
532         emit AddedPlatformAddress(_platformAddress, now);
533     }
534 
535     // Function to remove platform address
536     function removePlatformAddress(address _platformAddress) public onlyOwner() {
537         require(platformAddress[_platformAddress] == true, "not platform address");
538         platformAddress[_platformAddress] = false;
539 
540         emit RemovedPlatformAddress(_platformAddress, now);
541     }
542 }
543 
544 // File: contracts/LPStakingV2.sol
545 
546 
547 
548 pragma solidity ^0.6.10;
549 
550 
551 
552 
553 
554 interface ILPStakingNFT {
555     function nftTokenId(address _stakeholder) external view returns(uint id);
556     function revertNftTokenId(address _stakeholder, uint _tokenId) external;
557     function ownerOf(uint256 tokenId) external view returns (address owner);
558     function balanceOf(address owner) external view returns (uint256 balance);
559     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
560 }
561 
562 contract LPStakingV2 is Ownable {
563     using SafeMath for uint256;
564     using SafeERC20 for IERC20;
565 
566     struct NFT {
567         address _addressOfMinter;
568         uint _LPDeposited;
569         bool _inCirculation;
570         uint _rewardDebt;
571     }
572 
573     event StakeCompleted(address _staker, uint _amount, uint _tokenId, uint _totalStaked, uint _time);
574     event PoolUpdated(uint _blocksRewarded, uint _amountRewarded, uint _time);
575     event RewardsClaimed(address _staker, uint _rewardsClaimed, uint _tokenId, uint _time);
576     event MintedToken(address _staker, uint256 _tokenId, uint256 _time);
577     event EmergencyWithdrawOn(address _caller, bool _emergencyWithdraw, uint _time);
578     event WithdrawCompleted(address _staker, uint _amount, uint _tokenId, uint _time);
579 
580     IERC20 public LPToken;
581     IERC20 public NFYToken;
582     ILPStakingNFT public StakingNFT;
583     address public rewardPool;
584     address public staking;
585     uint public dailyReward;
586     uint public accNfyPerShare;
587     uint public lastRewardBlock;
588     uint public totalStaked;
589 
590     bool public emergencyWithdraw = false;
591 
592     mapping(uint => NFT) public NFTDetails;
593 
594     // Constructor will set the address of NFY/ETH LP token and address of NFY/ETH LP token staking NFT
595     constructor(address _LPToken, address _NFYToken, address _StakingNFT, address _staking, address _rewardPool, uint _dailyReward) Ownable() public {
596         LPToken = IERC20(_LPToken);
597         NFYToken = IERC20(_NFYToken);
598         StakingNFT = ILPStakingNFT(_StakingNFT);
599         staking = _staking;
600         rewardPool = _rewardPool;
601 
602         // 9:30 EST December 27th
603         lastRewardBlock = 11536400;
604 
605         setDailyReward(_dailyReward);
606         accNfyPerShare;
607     }
608 
609     // 6500 blocks in average day --- decimals * NFY balance of rewardPool / blocks / 10000 * dailyReward (in hundredths of %) = rewardPerBlock
610     function getRewardPerBlock() public view returns(uint) {
611         return NFYToken.balanceOf(rewardPool).mul(dailyReward).div(6500).div(10000);
612     }
613 
614     // % of reward pool to be distributed each day --- in hundredths of % 30 == 0.3%
615     function setDailyReward(uint _dailyReward) public onlyOwner {
616         dailyReward = _dailyReward;
617     }
618 
619     // Function that will get balance of a NFY/ETH LP balance of a certain stake
620     function getNFTBalance(uint _tokenId) public view returns(uint _amountStaked) {
621         return NFTDetails[_tokenId]._LPDeposited;
622     }
623 
624     // Function that will check if a NFY/ETH LP stake NFT is in circulation
625     function checkIfNFTInCirculation(uint _tokenId) public view returns(bool _inCirculation) {
626         return NFTDetails[_tokenId]._inCirculation;
627     }
628 
629     // Function that returns NFT's pending rewards
630     function pendingRewards(uint _NFT) public view returns(uint) {
631         NFT storage nft = NFTDetails[_NFT];
632 
633         uint256 _accNfyPerShare = accNfyPerShare;
634 
635         if (block.number > lastRewardBlock && totalStaked != 0) {
636             uint256 blocksToReward = block.number.sub(lastRewardBlock);
637             uint256 nfyReward = blocksToReward.mul(getRewardPerBlock());
638             _accNfyPerShare = _accNfyPerShare.add(nfyReward.mul(1e18).div(totalStaked));
639         }
640 
641         return nft._LPDeposited.mul(_accNfyPerShare).div(1e18).sub(nft._rewardDebt);
642     }
643 
644     // Get total rewards for all of user's NFY/ETH LP nfts
645     function getTotalRewards(address _address) public view returns(uint) {
646         uint totalRewards;
647 
648         for(uint i = 0; i < StakingNFT.balanceOf(_address); i++) {
649             uint _rewardPerNFT = pendingRewards(StakingNFT.tokenOfOwnerByIndex(_address, i));
650             totalRewards = totalRewards.add(_rewardPerNFT);
651         }
652 
653         return totalRewards;
654     }
655 
656     // Get total stake for all user's NFY/ETH LP nfts
657     function getTotalBalance(address _address) public view returns(uint) {
658         uint totalBalance;
659 
660         for(uint i = 0; i < StakingNFT.balanceOf(_address); i++) {
661             uint _balancePerNFT = getNFTBalance(StakingNFT.tokenOfOwnerByIndex(_address, i));
662             totalBalance = totalBalance.add(_balancePerNFT);
663         }
664 
665         return totalBalance;
666     }
667 
668     // Function that updates NFY/ETH LP pool
669     function updatePool() public {
670         if (block.number <= lastRewardBlock) {
671             return;
672         }
673 
674         if (totalStaked == 0) {
675             lastRewardBlock = block.number;
676             return;
677         }
678 
679         uint256 blocksToReward = block.number.sub(lastRewardBlock);
680 
681         uint256 nfyReward = blocksToReward.mul(getRewardPerBlock());
682 
683         //Approve nfyReward here
684         NFYToken.transferFrom(rewardPool, address(this), nfyReward);
685 
686         accNfyPerShare = accNfyPerShare.add(nfyReward.mul(1e18).div(totalStaked));
687         lastRewardBlock = block.number;
688 
689         emit PoolUpdated(blocksToReward, nfyReward, now);
690     }
691 
692     // Function that lets user stake NFY/ETH LP
693     function stakeLP(uint _amount) public {
694         require(emergencyWithdraw == false, "emergency withdraw is on, cannot stake");
695         require(_amount > 0, "Can not stake 0 LP tokens");
696         require(LPToken.balanceOf(_msgSender()) >= _amount, "Do not have enough LP tokens to stake");
697 
698         updatePool();
699 
700         if(StakingNFT.nftTokenId(_msgSender()) == 0){
701              addStakeholder(_msgSender());
702         }
703 
704         NFT storage nft = NFTDetails[StakingNFT.nftTokenId(_msgSender())];
705 
706         if(nft._LPDeposited > 0) {
707             uint _pendingRewards = nft._LPDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
708 
709             if(_pendingRewards > 0) {
710                 NFYToken.transfer(_msgSender(), _pendingRewards);
711                 emit RewardsClaimed(_msgSender(), _pendingRewards, StakingNFT.nftTokenId(_msgSender()), now);
712             }
713         }
714 
715         LPToken.transferFrom(_msgSender(), address(this), _amount);
716         nft._LPDeposited = nft._LPDeposited.add(_amount);
717         totalStaked = totalStaked.add(_amount);
718 
719         nft._rewardDebt = nft._LPDeposited.mul(accNfyPerShare).div(1e18);
720 
721         emit StakeCompleted(_msgSender(), _amount, StakingNFT.nftTokenId(_msgSender()), nft._LPDeposited, now);
722     }
723 
724     function addStakeholder(address _stakeholder) private {
725         (bool success, bytes memory data) = staking.call(abi.encodeWithSignature("mint(address)", _stakeholder));
726         require(success == true, "Mint call failed");
727         NFTDetails[StakingNFT.nftTokenId(_msgSender())]._addressOfMinter = _stakeholder;
728         NFTDetails[StakingNFT.nftTokenId(_msgSender())]._inCirculation = true;
729     }
730 
731     function addStakeholderExternal(address _stakeholder) external onlyPlatform() {
732         (bool success, bytes memory data) = staking.call(abi.encodeWithSignature("mint(address)", _stakeholder));
733         require(success == true, "Mint call failed");
734         NFTDetails[StakingNFT.nftTokenId(_stakeholder)]._addressOfMinter = _stakeholder;
735         NFTDetails[StakingNFT.nftTokenId(_stakeholder)]._inCirculation = true;
736     }
737 
738     // Function that will allow user to claim rewards
739     function claimRewards(uint _tokenId) public {
740         require(StakingNFT.ownerOf(_tokenId) == _msgSender(), "User is not owner of token");
741         require(NFTDetails[_tokenId]._inCirculation == true, "Stake has already been withdrawn");
742 
743         updatePool();
744 
745         NFT storage nft = NFTDetails[_tokenId];
746 
747         uint _pendingRewards = nft._LPDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
748         require(_pendingRewards > 0, "No rewards to claim!");
749 
750         NFYToken.transfer(_msgSender(), _pendingRewards);
751 
752         nft._rewardDebt = nft._LPDeposited.mul(accNfyPerShare).div(1e18);
753 
754         emit RewardsClaimed(_msgSender(), _pendingRewards, _tokenId, now);
755     }
756 
757     // Function that lets user claim all rewards from all their nfts
758     function claimAllRewards() public {
759         require(StakingNFT.balanceOf(_msgSender()) > 0, "User has no stake");
760         for(uint i = 0; i < StakingNFT.balanceOf(_msgSender()); i++) {
761             uint _currentNFT = StakingNFT.tokenOfOwnerByIndex(_msgSender(), i);
762             claimRewards(_currentNFT);
763         }
764     }
765 
766     // Function that lets user unstake NFY in system. 5% fee that gets redistributed back to reward pool
767     function unstakeLP(uint _tokenId) public {
768         require(emergencyWithdraw == true, "Can not withdraw");
769         // Require that user is owner of token id
770         require(StakingNFT.ownerOf(_tokenId) == _msgSender(), "User is not owner of token");
771         require(NFTDetails[_tokenId]._inCirculation == true, "Stake has already been withdrawn");
772 
773         updatePool();
774 
775         NFT storage nft = NFTDetails[_tokenId];
776 
777         uint _pendingRewards = nft._LPDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
778 
779         uint amountStaked = getNFTBalance(_tokenId);
780         uint beingWithdrawn = nft._LPDeposited;
781 
782         nft._LPDeposited = 0;
783         nft._inCirculation = false;
784 
785         totalStaked = totalStaked.sub(beingWithdrawn);
786         StakingNFT.revertNftTokenId(_msgSender(), _tokenId);
787 
788         (bool success, bytes memory data) = staking.call(abi.encodeWithSignature("burn(uint256)", _tokenId));
789         require(success == true, "burn call failed");
790 
791         LPToken.transfer(_msgSender(), amountStaked);
792         NFYToken.transfer(_msgSender(), _pendingRewards);
793 
794         emit WithdrawCompleted(_msgSender(), amountStaked, _tokenId, now);
795         emit RewardsClaimed(_msgSender(), _pendingRewards, _tokenId, now);
796     }
797 
798     // Function that will unstake every user's NFY/ETH LP stake NFT for user
799     function unstakeAll() public {
800         require(StakingNFT.balanceOf(_msgSender()) > 0, "User has no stake");        
801 
802         while(StakingNFT.balanceOf(_msgSender()) > 0) {
803             uint _currentNFT = StakingNFT.tokenOfOwnerByIndex(_msgSender(), 0);
804             unstakeLP(_currentNFT);
805         }
806     }
807 
808     // Will increment value of staking NFT when trade occurs
809     function incrementNFTValue (uint _tokenId, uint _amount) external onlyPlatform() {
810         require(checkIfNFTInCirculation(_tokenId) == true, "Token not in circulation");
811         updatePool();
812 
813         NFT storage nft = NFTDetails[_tokenId];
814 
815         if(nft._LPDeposited > 0) {
816             uint _pendingRewards = nft._LPDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
817 
818             if(_pendingRewards > 0) {
819                 NFYToken.transfer(StakingNFT.ownerOf(_tokenId), _pendingRewards);
820                 emit RewardsClaimed(StakingNFT.ownerOf(_tokenId), _pendingRewards, _tokenId, now);
821             }
822         }
823 
824         NFTDetails[_tokenId]._LPDeposited =  NFTDetails[_tokenId]._LPDeposited.add(_amount);
825 
826         nft._rewardDebt = nft._LPDeposited.mul(accNfyPerShare).div(1e18);
827 
828     }
829 
830     // Will decrement value of staking NFT when trade occurs
831     function decrementNFTValue (uint _tokenId, uint _amount) external onlyPlatform() {
832         require(checkIfNFTInCirculation(_tokenId) == true, "Token not in circulation");
833         require(getNFTBalance(_tokenId) >= _amount, "Not enough stake in NFT");
834 
835         updatePool();
836 
837         NFT storage nft = NFTDetails[_tokenId];
838 
839         if(nft._LPDeposited > 0) {
840             uint _pendingRewards = nft._LPDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
841 
842             if(_pendingRewards > 0) {
843                 NFYToken.transfer(StakingNFT.ownerOf(_tokenId), _pendingRewards);
844                 emit RewardsClaimed(StakingNFT.ownerOf(_tokenId), _pendingRewards, _tokenId, now);
845             }
846         }
847 
848         NFTDetails[_tokenId]._LPDeposited =  NFTDetails[_tokenId]._LPDeposited.sub(_amount);
849 
850         nft._rewardDebt = nft._LPDeposited.mul(accNfyPerShare).div(1e18);
851     }
852 
853     // Function that will turn on emergency withdraws
854     function turnEmergencyWithdrawOn() public onlyOwner() {
855         require(emergencyWithdraw == false, "emergency withdrawing already allowed");
856         emergencyWithdraw = true;
857         emit EmergencyWithdrawOn(_msgSender(), emergencyWithdraw, now);
858     }
859 
860 }