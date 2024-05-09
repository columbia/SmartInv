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
502 
503     modifier onlyOwner() {
504         require(_msgSender() == owner, "Owner only");
505         _;
506     }
507 
508     modifier onlyPlatform() {
509         require(platformAddress[_msgSender()] == true, "Only Platform");
510         _;
511     }
512 
513     mapping(address => bool) platformAddress;
514 
515     constructor() public {
516         owner = _msgSender();
517     }
518 
519     function transferOwnership(address payable _owner) public onlyOwner() {
520         address previousOwner = owner;
521         owner = _owner;
522         emit TransferredOwnership(previousOwner, owner, now);
523     }
524 
525     function addPlatformAddress(address _platformAddress) public onlyOwner() {
526         platformAddress[_platformAddress] = true;
527 
528         emit AddedPlatformAddress(_platformAddress, now);
529     }
530 }
531 
532 // File: contracts/NFYStaking.sol
533 
534 
535 
536 pragma solidity ^0.6.10;
537 
538 
539 
540 
541 
542 interface INFYStakingNFT {
543     function nftTokenId(address _stakeholder) external view returns(uint256 id);
544     function revertNftTokenId(address _stakeholder, uint256 _tokenId) external;
545     function ownerOf(uint256 tokenId) external view returns (address owner);
546     function balanceOf(address owner) external view returns (uint256 balance);
547     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
548 }
549 
550 contract NFYStaking is Ownable {
551     using SafeMath for uint256;
552     using SafeERC20 for IERC20;
553     struct NFT {
554         address _addressOfMinter;
555         uint256 _NFYDeposited;
556         bool _inCirculation;
557         uint256 _rewardDebt;
558     }
559 
560     event StakeCompleted(address _staker, uint256 _amount, uint256 _tokenId, uint256 _totalStaked, uint256 _time);
561     event WithdrawCompleted(address _staker, uint256 _amount, uint256 _tokenId, uint256 _time);
562     event PoolUpdated(uint256 _blocksRewarded, uint256 _amountRewarded, uint256 _time);
563     event RewardsClaimed(address _staker, uint256 _rewardsClaimed, uint256 _tokenId, uint256 _time);
564     event RewardsCompounded(address _staker, uint256 _rewardsCompounded, uint256 _tokenId, uint256 _totalStaked, uint256 _time);
565     event MintedToken(address _staker, uint256 _tokenId, uint256 _time);
566 
567     event TotalUnstaked(uint256 _total);
568 
569     IERC20 public NFYToken;
570     INFYStakingNFT public StakingNFT;
571     address public rewardPool;
572     address public staking;
573     uint256 public dailyReward;
574     uint256 public accNfyPerShare;
575     uint256 public lastRewardBlock;
576     uint256 public totalStaked;
577 
578     mapping(uint256 => NFT) public NFTDetails;
579 
580     // Constructor will set the address of NFY token and address of NFY staking NFT
581     constructor(address _NFYToken, address _StakingNFT, address _staking, address _rewardPool, uint256 _dailyReward) Ownable() public {
582         NFYToken = IERC20(_NFYToken);
583         StakingNFT = INFYStakingNFT(_StakingNFT);
584         staking = _staking;
585         rewardPool = _rewardPool;
586 
587         // 10:30 EST October 29th
588         lastRewardBlock = 11152600;
589         setDailyReward(_dailyReward);
590         accNfyPerShare = 0;
591     }
592 
593     // 6500 blocks in average day --- decimals * NFY balance of rewardPool / blocks / 10000 * dailyReward (in hundredths of %) = rewardPerBlock
594     function getRewardPerBlock() public view returns(uint256) {
595         return NFYToken.balanceOf(rewardPool).div(6500).div(10000).mul(dailyReward);
596     }
597 
598     // % of reward pool to be distributed each day --- in hundredths of % 30 == 0.3%
599     function setDailyReward(uint256 _dailyReward) public onlyOwner {
600         dailyReward = _dailyReward;
601     }
602 
603     // Function that will get balance of a NFY balance of a certain stake
604     function getNFTBalance(uint256 _tokenId) public view returns(uint256 _amountStaked) {
605         return NFTDetails[_tokenId]._NFYDeposited;
606     }
607 
608     // Function that will check if a NFY stake NFT is in circulation
609     function checkIfNFTInCirculation(uint256 _tokenId) public view returns(bool _inCirculation) {
610         return NFTDetails[_tokenId]._inCirculation;
611     }
612 
613     // Function that returns NFT's pending rewards
614     function pendingRewards(uint256 _NFT) public view returns(uint256) {
615         NFT storage nft = NFTDetails[_NFT];
616 
617         uint256 _accNfyPerShare = accNfyPerShare;
618 
619         if (block.number > lastRewardBlock && totalStaked != 0) {
620             uint256 blocksToReward = block.number.sub(lastRewardBlock);
621             uint256 nfyReward = blocksToReward.mul(getRewardPerBlock());
622             _accNfyPerShare = _accNfyPerShare.add(nfyReward.mul(1e18).div(totalStaked));
623         }
624 
625         return nft._NFYDeposited.mul(_accNfyPerShare).div(1e18).sub(nft._rewardDebt);
626     }
627 
628     // Get total rewards for all of user's NFY nfts
629     function getTotalRewards(address _address) public view returns(uint256) {
630         uint256 totalRewards;
631 
632         for(uint256 i = 0; i < StakingNFT.balanceOf(_address); i++) {
633             uint256 _rewardPerNFT = pendingRewards(StakingNFT.tokenOfOwnerByIndex(_address, i));
634             totalRewards = totalRewards.add(_rewardPerNFT);
635         }
636 
637         return totalRewards;
638     }
639 
640     // Get total stake for all user's NFY nfts
641     function getTotalBalance(address _address) public view returns(uint256) {
642         uint256 totalBalance;
643 
644         for(uint256 i = 0; i < StakingNFT.balanceOf(_address); i++) {
645             uint256 _balancePerNFT = getNFTBalance(StakingNFT.tokenOfOwnerByIndex(_address, i));
646             totalBalance = totalBalance.add(_balancePerNFT);
647         }
648 
649         return totalBalance;
650     }
651 
652     // Function that updates NFY pool
653     function updatePool() public {
654         if (block.number <= lastRewardBlock) {
655             return;
656         }
657 
658         if (totalStaked == 0) {
659             lastRewardBlock = block.number;
660             return;
661         }
662 
663         uint256 blocksToReward = block.number.sub(lastRewardBlock);
664 
665         uint256 nfyReward = blocksToReward.mul(getRewardPerBlock());
666 
667         //Approve nfyReward here
668         NFYToken.transferFrom(rewardPool, address(this), nfyReward);
669 
670         accNfyPerShare = accNfyPerShare.add(nfyReward.mul(1e18).div(totalStaked));
671         lastRewardBlock = block.number;
672 
673         emit PoolUpdated(blocksToReward, nfyReward, now);
674     }
675 
676     // Function that lets user stake NFY
677     function stakeNFY(uint256 _amount) public {
678         require(_amount > 0, "Can not stake 0 NFY");
679         require(NFYToken.balanceOf(_msgSender()) >= _amount, "Do not have enough NFY to stake");
680 
681         updatePool();
682 
683         if(StakingNFT.nftTokenId(_msgSender()) == 0){
684              addStakeholder(_msgSender());
685         }
686 
687         NFT storage nft = NFTDetails[StakingNFT.nftTokenId(_msgSender())];
688 
689         if(nft._NFYDeposited > 0) {
690             uint256 _pendingRewards = nft._NFYDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
691 
692             if(_pendingRewards > 0) {
693                 NFYToken.transfer(_msgSender(), _pendingRewards);
694                 emit RewardsClaimed(_msgSender(), _pendingRewards, StakingNFT.nftTokenId(_msgSender()), now);
695             }
696         }
697 
698         NFYToken.transferFrom(_msgSender(), address(this), _amount);
699         nft._NFYDeposited = nft._NFYDeposited.add(_amount);
700         totalStaked = totalStaked.add(_amount);
701 
702         nft._rewardDebt = nft._NFYDeposited.mul(accNfyPerShare).div(1e18);
703 
704         emit StakeCompleted(_msgSender(), _amount, StakingNFT.nftTokenId(_msgSender()), nft._NFYDeposited, now);
705 
706     }
707 
708     function addStakeholder(address _stakeholder) private {
709         (bool success, bytes memory data) = staking.call(abi.encodeWithSignature("mint(address)", _stakeholder));
710         require(success == true, "Mint call failed");
711         NFTDetails[StakingNFT.nftTokenId(_msgSender())]._addressOfMinter = _stakeholder;
712         NFTDetails[StakingNFT.nftTokenId(_msgSender())]._inCirculation = true;
713     }
714 
715     function addStakeholderExternal(address _stakeholder) external onlyPlatform() {
716         (bool success, bytes memory data) = staking.call(abi.encodeWithSignature("mint(address)", _stakeholder));
717         require(success == true, "Mint call failed");
718         NFTDetails[StakingNFT.nftTokenId(_msgSender())]._addressOfMinter = _stakeholder;
719         NFTDetails[StakingNFT.nftTokenId(_msgSender())]._inCirculation = true;
720     }
721 
722     // Function that will allow user to claim rewards
723     function claimRewards(uint256 _tokenId) public {
724         require(StakingNFT.ownerOf(_tokenId) == _msgSender(), "User is not owner of token");
725         require(NFTDetails[_tokenId]._inCirculation == true, "Stake has already been withdrawn");
726 
727         updatePool();
728 
729         NFT storage nft = NFTDetails[_tokenId];
730 
731         uint256 _pendingRewards = nft._NFYDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
732         require(_pendingRewards > 0, "No rewards to claim!");
733 
734         NFYToken.transfer(_msgSender(), _pendingRewards);
735 
736         nft._rewardDebt = nft._NFYDeposited.mul(accNfyPerShare).div(1e18);
737 
738         emit RewardsClaimed(_msgSender(), _pendingRewards, _tokenId, now);
739     }
740 
741     // Function that will add NFY rewards to NFY staking NFT
742     function compoundRewards(uint256 _tokenId) public {
743         require(StakingNFT.ownerOf(_tokenId) == _msgSender(), "User is not owner of token");
744         require(NFTDetails[_tokenId]._inCirculation == true, "Stake has already been withdrawn");
745 
746         updatePool();
747 
748         NFT storage nft = NFTDetails[_tokenId];
749 
750         uint256 _pendingRewards = nft._NFYDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
751         require(_pendingRewards > 0, "No rewards to compound!");
752 
753         nft._NFYDeposited = nft._NFYDeposited.add(_pendingRewards);
754         totalStaked = totalStaked.add(_pendingRewards);
755 
756         nft._rewardDebt = nft._NFYDeposited.mul(accNfyPerShare).div(1e18);
757 
758         emit RewardsCompounded(_msgSender(), _pendingRewards, _tokenId, nft._NFYDeposited, now);
759     }
760 
761     // Function that lets user claim all rewards from all their nfts
762     function claimAllRewards() public {
763         require(StakingNFT.balanceOf(_msgSender()) > 0, "User has no stake");
764         for(uint256 i = 0; i < StakingNFT.balanceOf(_msgSender()); i++) {
765             uint256 _currentNFT = StakingNFT.tokenOfOwnerByIndex(_msgSender(), i);
766             claimRewards(_currentNFT);
767         }
768     }
769 
770     // Function that lets user compound all rewards from all their nfts
771     function compoundAllRewards() public {
772         require(StakingNFT.balanceOf(_msgSender()) > 0, "User has no stake");
773         for(uint256 i = 0; i < StakingNFT.balanceOf(_msgSender()); i++) {
774             uint256 _currentNFT = StakingNFT.tokenOfOwnerByIndex(_msgSender(), i);
775             compoundRewards(_currentNFT);
776         }
777     }
778 
779     // Function that lets user unstake NFY in system. 5% fee that gets redistributed back to reward pool
780     function unstakeNFY(uint256 _tokenId) public {
781         // Require that user is owner of token id
782         require(StakingNFT.ownerOf(_tokenId) == _msgSender(), "User is not owner of token");
783         require(NFTDetails[_tokenId]._inCirculation == true, "Stake has already been withdrawn");
784 
785         updatePool();
786 
787         NFT storage nft = NFTDetails[_tokenId];
788 
789         uint256 _pendingRewards = nft._NFYDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
790 
791         uint256 amountStaked = getNFTBalance(_tokenId);
792         uint256 stakeAfterFees = amountStaked.div(100).mul(95);
793         uint256 userReceives = amountStaked.div(100).mul(95).add(_pendingRewards);
794 
795         uint256 fee = amountStaked.div(100).mul(5);
796 
797         uint256 beingWithdrawn = nft._NFYDeposited;
798         nft._NFYDeposited = 0;
799         nft._inCirculation = false;
800         totalStaked = totalStaked.sub(beingWithdrawn);
801         StakingNFT.revertNftTokenId(_msgSender(), _tokenId);
802 
803         (bool success, bytes memory data) = staking.call(abi.encodeWithSignature("burn(uint256)", _tokenId));
804         require(success == true, "mint call failed");
805 
806         NFYToken.transfer(_msgSender(), userReceives);
807         NFYToken.transfer(rewardPool, fee);
808 
809         emit WithdrawCompleted(_msgSender(), stakeAfterFees, _tokenId, now);
810         emit RewardsClaimed(_msgSender(), _pendingRewards, _tokenId, now);
811     }
812 
813     // Function that will unstake every user's NFY stake NFT for user
814     function unstakeAll() public {
815         require(StakingNFT.balanceOf(_msgSender()) > 0, "User has no stake");
816 
817         while(StakingNFT.balanceOf(_msgSender()) > 0) {
818             uint256 _currentNFT = StakingNFT.tokenOfOwnerByIndex(_msgSender(), 0);
819             unstakeNFY(_currentNFT);
820         }
821 
822     }
823 
824     // Will increment value of staking NFT when trade occurs
825     function incrementNFTValue (uint256 _tokenId, uint256 _amount) external onlyPlatform() {
826         require(checkIfNFTInCirculation(_tokenId) == true, "Token not in circulation");
827         updatePool();
828 
829         NFT storage nft = NFTDetails[_tokenId];
830 
831         if(nft._NFYDeposited > 0) {
832             uint256 _pendingRewards = nft._NFYDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
833 
834             if(_pendingRewards > 0) {
835                 NFYToken.transfer(StakingNFT.ownerOf(_tokenId), _pendingRewards);
836                 emit RewardsClaimed(StakingNFT.ownerOf(_tokenId), _pendingRewards, _tokenId, now);
837             }
838         }
839 
840         NFTDetails[_tokenId]._NFYDeposited =  NFTDetails[_tokenId]._NFYDeposited.add(_amount);
841 
842         nft._rewardDebt = nft._NFYDeposited.mul(accNfyPerShare).div(1e18);
843     }
844 
845     // Will decrement value of staking NFT when trade occurs
846     function decrementNFTValue (uint256 _tokenId, uint256 _amount) external onlyPlatform() {
847         require(checkIfNFTInCirculation(_tokenId) == true, "Token not in circulation");
848         require(getNFTBalance(_tokenId) >= _amount, "Not enough stake in NFT");
849 
850         updatePool();
851 
852         NFT storage nft = NFTDetails[_tokenId];
853 
854         if(nft._NFYDeposited > 0) {
855             uint256 _pendingRewards = nft._NFYDeposited.mul(accNfyPerShare).div(1e18).sub(nft._rewardDebt);
856 
857             if(_pendingRewards > 0) {
858                 NFYToken.transfer(StakingNFT.ownerOf(_tokenId), _pendingRewards);
859                 emit RewardsClaimed(StakingNFT.ownerOf(_tokenId), _pendingRewards, _tokenId, now);
860             }
861         }
862 
863         NFTDetails[_tokenId]._NFYDeposited =  NFTDetails[_tokenId]._NFYDeposited.sub(_amount);
864 
865         nft._rewardDebt = nft._NFYDeposited.mul(accNfyPerShare).div(1e18);
866     }
867 
868 }