1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-09
3 */
4 
5 /*
6    ____            __   __        __   _
7   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
8  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
9 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
10      /___/
11 
12 * Synthetix: YFIRewards.sol
13 *
14 * Docs: https://docs.synthetix.io/
15 *
16 *
17 * MIT License
18 * ===========
19 *
20 * Copyright (c) 2020 Synthetix
21 *
22 * Permission is hereby granted, free of charge, to any person obtaining a copy
23 * of this software and associated documentation files (the "Software"), to deal
24 * in the Software without restriction, including without limitation the rights
25 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
26 * copies of the Software, and to permit persons to whom the Software is
27 * furnished to do so, subject to the following conditions:
28 *
29 * The above copyright notice and this permission notice shall be included in all
30 * copies or substantial portions of the Software.
31 *
32 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
33 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
34 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
35 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
36 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
37 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
38 */
39 
40 // File: @openzeppelin/contracts/math/Math.sol
41 
42 pragma solidity ^0.5.0;
43 
44 /**
45  * @dev Standard math utilities missing in the Solidity language.
46  */
47 library Math {
48     /**
49      * @dev Returns the largest of two numbers.
50      */
51     function max(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a >= b ? a : b;
53     }
54 
55     /**
56      * @dev Returns the smallest of two numbers.
57      */
58     function min(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a < b ? a : b;
60     }
61 
62     /**
63      * @dev Returns the average of two numbers. The result is rounded towards
64      * zero.
65      */
66     function average(uint256 a, uint256 b) internal pure returns (uint256) {
67         // (a + b) / 2 can overflow, so we distribute
68         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/math/SafeMath.sol
73 
74 pragma solidity ^0.5.0;
75 
76 /**
77  * @dev Wrappers over Solidity's arithmetic operations with added overflow
78  * checks.
79  *
80  * Arithmetic operations in Solidity wrap on overflow. This can easily result
81  * in bugs, because programmers usually assume that an overflow raises an
82  * error, which is the standard behavior in high level programming languages.
83  * `SafeMath` restores this intuition by reverting the transaction when an
84  * operation overflows.
85  *
86  * Using this library instead of the unchecked operations eliminates an entire
87  * class of bugs, so it's recommended to use it always.
88  */
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      *
128      * _Available since v2.4.0._
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      * - The divisor cannot be zero.
185      *
186      * _Available since v2.4.0._
187      */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         // Solidity only automatically asserts when dividing by 0
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      *
223      * _Available since v2.4.0._
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b != 0, errorMessage);
227         return a % b;
228     }
229 }
230 
231 // File: @openzeppelin/contracts/GSN/Context.sol
232 
233 pragma solidity ^0.5.0;
234 
235 /*
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with GSN meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 contract Context {
246     // Empty internal constructor, to prevent people from mistakenly deploying
247     // an instance of this contract, which should be used via inheritance.
248     constructor () internal { }
249     // solhint-disable-previous-line no-empty-blocks
250 
251     function _msgSender() internal view returns (address payable) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view returns (bytes memory) {
256         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
257         return msg.data;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/ownership/Ownable.sol
262 
263 pragma solidity ^0.5.0;
264 
265 /**
266  * @dev Contract module which provides a basic access control mechanism, where
267  * there is an account (an owner) that can be granted exclusive access to
268  * specific functions.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor () internal {
283         _owner = _msgSender();
284         emit OwnershipTransferred(address(0), _owner);
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(isOwner(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Returns true if the caller is the current owner.
304      */
305     function isOwner() public view returns (bool) {
306         return _msgSender() == _owner;
307     }
308 
309     /**
310      * @dev Leaves the contract without owner. It will not be possible to call
311      * `onlyOwner` functions anymore. Can only be called by the current owner.
312      *
313      * NOTE: Renouncing ownership will leave the contract without an owner,
314      * thereby removing any functionality that is only available to the owner.
315      */
316     function renounceOwnership() public onlyOwner {
317         emit OwnershipTransferred(_owner, address(0));
318         _owner = address(0);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public onlyOwner {
326         _transferOwnership(newOwner);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      */
332     function _transferOwnership(address newOwner) internal {
333         require(newOwner != address(0), "Ownable: new owner is the zero address");
334         emit OwnershipTransferred(_owner, newOwner);
335         _owner = newOwner;
336     }
337 }
338 
339 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
340 
341 pragma solidity ^0.5.0;
342 
343 /**
344  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
345  * the optional functions; to access them see {ERC20Detailed}.
346  */
347 interface IERC20 {
348     /**
349      * @dev Returns the amount of tokens in existence.
350      */
351     function totalSupply() external view returns (uint256);
352 
353     /**
354      * @dev Returns the amount of tokens owned by `account`.
355      */
356     function balanceOf(address account) external view returns (uint256);
357 
358     /**
359      * @dev Moves `amount` tokens from the caller's account to `recipient`.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * Emits a {Transfer} event.
364      */
365     function transfer(address recipient, uint256 amount) external returns (bool);
366     function mint(address account, uint amount) external;
367 
368     /**
369      * @dev Returns the remaining number of tokens that `spender` will be
370      * allowed to spend on behalf of `owner` through {transferFrom}. This is
371      * zero by default.
372      *
373      * This value changes when {approve} or {transferFrom} are called.
374      */
375     function allowance(address owner, address spender) external view returns (uint256);
376 
377     /**
378      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * IMPORTANT: Beware that changing an allowance with this method brings the risk
383      * that someone may use both the old and the new allowance by unfortunate
384      * transaction ordering. One possible solution to mitigate this race
385      * condition is to first reduce the spender's allowance to 0 and set the
386      * desired value afterwards:
387      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
388      *
389      * Emits an {Approval} event.
390      */
391     function approve(address spender, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Moves `amount` tokens from `sender` to `recipient` using the
395      * allowance mechanism. `amount` is then deducted from the caller's
396      * allowance.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Emitted when `value` tokens are moved from one account (`from`) to
406      * another (`to`).
407      *
408      * Note that `value` may be zero.
409      */
410     event Transfer(address indexed from, address indexed to, uint256 value);
411 
412     /**
413      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
414      * a call to {approve}. `value` is the new allowance.
415      */
416     event Approval(address indexed owner, address indexed spender, uint256 value);
417 }
418 
419 // File: @openzeppelin/contracts/utils/Address.sol
420 
421 pragma solidity ^0.5.5;
422 
423 /**
424  * @dev Collection of functions related to the address type
425  */
426 library Address {
427     /**
428      * @dev Returns true if `account` is a contract.
429      *
430      * This test is non-exhaustive, and there may be false-negatives: during the
431      * execution of a contract's constructor, its address will be reported as
432      * not containing a contract.
433      *
434      * IMPORTANT: It is unsafe to assume that an address for which this
435      * function returns false is an externally-owned account (EOA) and not a
436      * contract.
437      */
438     function isContract(address account) internal view returns (bool) {
439         // This method relies in extcodesize, which returns 0 for contracts in
440         // construction, since the code is only stored at the end of the
441         // constructor execution.
442 
443         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
444         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
445         // for accounts without code, i.e. `keccak256('')`
446         bytes32 codehash;
447         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
448         // solhint-disable-next-line no-inline-assembly
449         assembly { codehash := extcodehash(account) }
450         return (codehash != 0x0 && codehash != accountHash);
451     }
452 
453     /**
454      * @dev Converts an `address` into `address payable`. Note that this is
455      * simply a type cast: the actual underlying value is not changed.
456      *
457      * _Available since v2.4.0._
458      */
459     function toPayable(address account) internal pure returns (address payable) {
460         return address(uint160(account));
461     }
462 
463     /**
464      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
465      * `recipient`, forwarding all available gas and reverting on errors.
466      *
467      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
468      * of certain opcodes, possibly making contracts go over the 2300 gas limit
469      * imposed by `transfer`, making them unable to receive funds via
470      * `transfer`. {sendValue} removes this limitation.
471      *
472      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
473      *
474      * IMPORTANT: because control is transferred to `recipient`, care must be
475      * taken to not create reentrancy vulnerabilities. Consider using
476      * {ReentrancyGuard} or the
477      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
478      *
479      * _Available since v2.4.0._
480      */
481     function sendValue(address payable recipient, uint256 amount) internal {
482         require(address(this).balance >= amount, "Address: insufficient balance");
483 
484         // solhint-disable-next-line avoid-call-value
485         (bool success, ) = recipient.call.value(amount)("");
486         require(success, "Address: unable to send value, recipient may have reverted");
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
491 
492 pragma solidity ^0.5.0;
493 
494 
495 
496 
497 /**
498  * @title SafeERC20
499  * @dev Wrappers around ERC20 operations that throw on failure (when the token
500  * contract returns false). Tokens that return no value (and instead revert or
501  * throw on failure) are also supported, non-reverting calls are assumed to be
502  * successful.
503  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
504  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
505  */
506 library SafeERC20 {
507     using SafeMath for uint256;
508     using Address for address;
509 
510     function safeTransfer(IERC20 token, address to, uint256 value) internal {
511         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
512     }
513 
514     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
515         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
516     }
517 
518     function safeApprove(IERC20 token, address spender, uint256 value) internal {
519         // safeApprove should only be called when setting an initial allowance,
520         // or when resetting it to zero. To increase and decrease it, use
521         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
522         // solhint-disable-next-line max-line-length
523         require((value == 0) || (token.allowance(address(this), spender) == 0),
524             "SafeERC20: approve from non-zero to non-zero allowance"
525         );
526         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
527     }
528 
529     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).add(value);
531         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
532     }
533 
534     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
535         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
536         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
537     }
538 
539     /**
540      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
541      * on the return value: the return value is optional (but if data is returned, it must not be false).
542      * @param token The token targeted by the call.
543      * @param data The call data (encoded using abi.encode or one of its variants).
544      */
545     function callOptionalReturn(IERC20 token, bytes memory data) private {
546         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
547         // we're implementing it ourselves.
548 
549         // A Solidity high level call has three parts:
550         //  1. The target address is checked to verify it contains contract code
551         //  2. The call itself is made, and success asserted
552         //  3. The return value is decoded, which in turn checks the size of the returned data.
553         // solhint-disable-next-line max-line-length
554         require(address(token).isContract(), "SafeERC20: call to non-contract");
555 
556         // solhint-disable-next-line avoid-low-level-calls
557         (bool success, bytes memory returndata) = address(token).call(data);
558         require(success, "SafeERC20: low-level call failed");
559 
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 
568 // File: contracts/IRewardDistributionRecipient.sol
569 
570 pragma solidity ^0.5.0;
571 
572 
573 
574 contract IRewardDistributionRecipient is Ownable {
575     address rewardDistribution;
576 
577     function notifyRewardAmount(uint256 reward) external;
578 
579     modifier onlyRewardDistribution() {
580         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
581         _;
582     }
583 
584     function setRewardDistribution(address _rewardDistribution)
585         external
586         onlyOwner
587     {
588         rewardDistribution = _rewardDistribution;
589     }
590 }
591 
592 
593 pragma solidity ^0.5.0;
594 
595 interface yNFT {
596     function tokens(uint256) external view returns (uint expirationTimestamp,
597         bytes4 coverCurrency,
598         uint coverAmount,
599         uint coverPrice,
600         uint coverPriceNXM,
601         uint expireTime,
602         uint generationTime,
603         uint coverId,
604         bool claimInProgress,
605         uint claimId);
606         
607     function transferFrom(address from, address to, uint256 tokenId) external;
608 }
609 
610 contract LPTokenWrapper {
611     using SafeMath for uint256;
612 
613     address constant public yinsure = address(0x181Aea6936B407514ebFC0754A37704eB8d98F91); //yinsure
614     struct Token {
615         uint expirationTimestamp;
616         bytes4 coverCurrency;
617         uint coverAmount;
618         uint adjCoverAmount;
619         uint coverPrice;
620         uint coverPriceNXM;
621         uint expireTime;
622         uint generationTime;
623         uint coverId;
624         bool claimInProgress;
625         uint claimId;
626         uint tokenId;
627         bool withdrawn;
628     }
629     uint256 private _totalStaked;
630     uint256 private _totalCover;
631     uint256 private _adjustedTotalCover;
632 
633     mapping(address => uint256) private _myCover;
634     mapping(address => Token[]) private _owned;
635 
636     function totalStaked() public view returns (uint256) {
637         return _totalStaked;
638     }
639 
640     function totalSupply() public view returns (uint256) {
641         return _adjustedTotalCover;
642     }
643 
644     function totalCover() public view returns (uint256) {
645         return _totalCover;
646     }
647 
648     function balanceOf(address account) public view returns (uint256) {
649         return _myCover[account];
650     }
651 
652     function numStaked(address account) public view returns (uint256) {
653         uint256 staked = 0;
654         for (uint i = 0; i < _owned[account].length; i++) {
655             if (!_owned[account][i].withdrawn) {
656                 staked++;
657             }
658         }
659         return staked;
660     }
661 
662     function calculateCoverValue(uint256 coverAmount, uint256 generationTime, uint256 expirationTimestamp) public view returns (uint256) {
663         // generationTime is in milliseconds, expirationTimestamp is in seconds
664         uint256 x = block.timestamp.mul(1000).sub(generationTime);
665         uint256 y = expirationTimestamp.mul(1000).sub(generationTime);
666         uint256 multiplier = 100000;
667         uint256 per = x.mul(multiplier).div(y);
668         return multiplier.sub(per).mul(coverAmount).div(multiplier);
669     }
670     
671     function idsStaked(address account) public view returns (uint256[] memory) {
672         uint256[] memory staked = new uint256[](numStaked(account));
673         uint tempIdx = 0;
674         for(uint i = 0; i < _owned[account].length; i++) {
675             if(!_owned[account][i].withdrawn) {
676                 staked[tempIdx] = _owned[account][i].tokenId;
677                 tempIdx ++;
678             }
679         }
680         return staked;
681     }
682 
683     function getToken(uint256 tokenId) public view returns(uint expirationTimestamp, 
684         bytes4 coverCurrency,
685         uint coverAmount,
686         uint coverPrice,
687         uint coverPriceNXM,
688         uint expireTime,
689         uint generationTime,
690         uint coverId,
691         bool claimInProgress,
692         uint claimId) {
693         return yNFT(yinsure).tokens(tokenId);
694     }
695 
696     function stake(uint256 tokenId) public {
697         (uint expirationTimestamp, 
698         bytes4 coverCurrency,
699         uint coverAmount,
700         uint coverPrice,
701         uint coverPriceNXM,
702         uint expireTime,
703         uint generationTime,
704         uint coverId,
705         bool claimInProgress,
706         uint claimId) = getToken(tokenId);
707 
708         require(coverCurrency == bytes4(0x44414900), "yNFT cover currency must be DAI");
709         require(expirationTimestamp - 24 hours> block.timestamp, "cover has expired or is 24 hours away from expiring!");
710         uint256 adjCoverAmount = calculateCoverValue(coverAmount, generationTime, expirationTimestamp);
711 
712         _owned[msg.sender].push(Token(expirationTimestamp,
713          coverCurrency,
714          coverAmount,
715          adjCoverAmount,
716          coverPrice,
717          coverPriceNXM,
718          expireTime,
719          generationTime,
720          coverId,
721          claimInProgress,
722          claimId,
723          tokenId,
724          false));
725         _totalStaked = _totalStaked.add(1);
726         _adjustedTotalCover = _adjustedTotalCover.add(adjCoverAmount);
727         _totalCover = _totalCover.add(coverAmount);
728         _myCover[msg.sender] = _myCover[msg.sender].add(adjCoverAmount);
729         yNFT(yinsure).transferFrom(msg.sender, address(this), tokenId);
730     }
731 
732     function withdraw(uint256 tokenId) public {
733         for (uint i = 0; i < _owned[msg.sender].length; i++) {
734             if (_owned[msg.sender][i].tokenId == tokenId && !_owned[msg.sender][i].withdrawn) {
735                 _totalStaked = _totalStaked.sub(1);
736                 _totalCover = _totalCover.sub(_owned[msg.sender][i].coverAmount);
737                 _adjustedTotalCover = _adjustedTotalCover.sub(_owned[msg.sender][i].adjCoverAmount);
738                 _myCover[msg.sender] = _myCover[msg.sender].sub(_owned[msg.sender][i].adjCoverAmount);
739                 _owned[msg.sender][i].withdrawn = true;
740                 yNFT(yinsure).transferFrom(address(this), msg.sender, tokenId);
741 
742             }
743         }
744     }
745 
746     function withdrawAll() public {
747         for (uint i = 0; i < _owned[msg.sender].length; i++) {
748             if (!_owned[msg.sender][i].withdrawn) {
749                 _totalStaked = _totalStaked.sub(1);
750                 _totalCover = _totalCover.sub(_owned[msg.sender][i].coverAmount);
751                 _adjustedTotalCover = _adjustedTotalCover.sub(_owned[msg.sender][i].adjCoverAmount);
752                 _myCover[msg.sender] = _myCover[msg.sender].sub(_owned[msg.sender][i].adjCoverAmount);
753                 _owned[msg.sender][i].withdrawn = true;
754                 yNFT(yinsure).transferFrom(address(this), msg.sender, _owned[msg.sender][i].tokenId);
755             }
756         }
757     }
758 }
759 
760 contract yNFTDAIPool is LPTokenWrapper, IRewardDistributionRecipient {
761     using SafeERC20 for IERC20;
762     IERC20 public safe = IERC20(0x1Aa61c196E76805fcBe394eA00e4fFCEd24FC469);
763     uint256 public constant DURATION = 7 days;
764 
765     uint256 public initreward = 10000*1e18;
766     uint256 public starttime = 1599944400; // 1599944400 => Saturday, September 12, 2020 4:00:00 PM GMT-05:00 DST
767     uint256 public periodFinish = 0;
768     uint256 public rewardRate = 0;
769     uint256 public lastUpdateTime;
770     uint256 public rewardPerTokenStored;
771     mapping(address => uint256) public userRewardPerTokenPaid;
772     mapping(address => uint256) public rewards;
773 
774     event RewardAdded(uint256 reward);
775     event Staked(address indexed user, uint256 tokenId);
776     event Withdrawn(address indexed user, uint256 tokenId);
777     event WithdrawnAll(address indexed user);
778     event RewardPaid(address indexed user, uint256 reward);
779 
780     modifier updateReward(address account) {
781         rewardPerTokenStored = rewardPerToken();
782         lastUpdateTime = lastTimeRewardApplicable();
783         if (account != address(0)) {
784             rewards[account] = earned(account);
785             userRewardPerTokenPaid[account] = rewardPerTokenStored;
786         }
787         _;
788     }
789 
790     function lastTimeRewardApplicable() public view returns (uint256) {
791         return Math.min(block.timestamp, periodFinish);
792     }
793 
794     function rewardPerToken() public view returns (uint256) {
795         if (totalSupply() == 0) {
796             return rewardPerTokenStored;
797         }
798         return
799             rewardPerTokenStored.add(
800                 lastTimeRewardApplicable()
801                     .sub(lastUpdateTime)
802                     .mul(rewardRate)
803                     .mul(1e18)
804                     .div(totalSupply())
805             );
806     }
807 
808     function earned(address account) public view returns (uint256) {
809         return
810             balanceOf(account)
811                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
812                 .div(1e18)
813                 .add(rewards[account]);
814     }
815 
816     // stake visibility is public as overriding LPTokenWrapper's stake() function
817     function stake(uint256 tokenId) public updateReward(msg.sender) checkhalve checkStart{ 
818         require(tokenId >= 0, "token id must be >= 0");
819         super.stake(tokenId);
820         emit Staked(msg.sender, tokenId);
821     }
822 
823     function stakeMultiple(uint256[] memory tokenIds) public updateReward(msg.sender) checkhalve checkStart{ 
824         for (uint i = 0; i < tokenIds.length; i++) {
825             require(tokenIds[i] >= 0, "token id must be >= 0");
826             super.stake(tokenIds[i]);
827             emit Staked(msg.sender, tokenIds[i]);
828         }
829     }
830 
831     function withdraw(uint256 tokenId) public updateReward(msg.sender) checkhalve checkStart{
832         require(tokenId >= 0, "token id must be >= 0");
833         require(numStaked(msg.sender) > 0, "no ynfts staked");
834         super.withdraw(tokenId);
835         emit Withdrawn(msg.sender, tokenId);
836     }
837 
838     function withdrawMultiple(uint256[] memory tokenIds) public updateReward(msg.sender) checkhalve checkStart{
839         for (uint i = 0; i < tokenIds.length; i++) {
840             require(tokenIds[i] >= 0, "token id must be >= 0");
841             super.withdraw(tokenIds[i]);
842             emit Withdrawn(msg.sender, tokenIds[i]);
843         }
844     }
845 
846     function withdrawAll() public updateReward(msg.sender) checkhalve checkStart {
847         require(numStaked(msg.sender) > 0, "no ynfts staked");
848         super.withdrawAll();
849         emit WithdrawnAll(msg.sender);
850     }
851 
852     function exit() external {
853         withdrawAll();
854         getReward();
855     }
856 
857     function getReward() public updateReward(msg.sender) checkhalve checkStart {
858         uint256 reward = earned(msg.sender);
859         if (reward > 0) {
860             rewards[msg.sender] = 0;
861             safe.safeTransfer(msg.sender, reward);
862             emit RewardPaid(msg.sender, reward);
863         }
864     }
865 
866     modifier checkhalve(){
867         if (block.timestamp >= periodFinish) {
868             initreward = initreward.mul(50).div(100); 
869             safe.mint(address(this),initreward);
870 
871             rewardRate = initreward.div(DURATION);
872             periodFinish = block.timestamp.add(DURATION);
873             emit RewardAdded(initreward);
874         }
875         _;
876     }
877     modifier checkStart(){
878         require(block.timestamp > starttime,"not start");
879         _;
880     }
881 
882     function notifyRewardAmount(uint256 reward)
883         external
884         onlyRewardDistribution
885         updateReward(address(0))
886     {
887         if (block.timestamp >= periodFinish) {
888             rewardRate = reward.div(DURATION);
889         } else {
890             uint256 remaining = periodFinish.sub(block.timestamp);
891             uint256 leftover = remaining.mul(rewardRate);
892             rewardRate = reward.add(leftover).div(DURATION);
893         }
894         safe.mint(address(this),reward);
895         lastUpdateTime = block.timestamp;
896         periodFinish = block.timestamp.add(DURATION);
897         emit RewardAdded(reward);
898     }
899 }