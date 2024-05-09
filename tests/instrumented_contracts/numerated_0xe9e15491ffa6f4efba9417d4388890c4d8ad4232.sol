1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 // File: @openzeppelin/contracts/math/SafeMath.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/GSN/Context.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /*
197  * @dev Provides information about the current execution context, including the
198  * sender of the transaction and its data. While these are generally available
199  * via msg.sender and msg.data, they should not be accessed in such a direct
200  * manner, since when dealing with GSN meta-transactions the account sending and
201  * paying for execution may not be the actual sender (as far as an application
202  * is concerned).
203  *
204  * This contract is only required for intermediate, library-like contracts.
205  */
206 contract Context {
207     // Empty internal constructor, to prevent people from mistakenly deploying
208     // an instance of this contract, which should be used via inheritance.
209     constructor () internal { }
210     // solhint-disable-previous-line no-empty-blocks
211 
212     function _msgSender() internal view returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // File: @openzeppelin/contracts/ownership/Ownable.sol
223 
224 pragma solidity ^0.5.0;
225 
226 /**
227  * @dev Contract module which provides a basic access control mechanism, where
228  * there is an account (an owner) that can be granted exclusive access to
229  * specific functions.
230  *
231  * This module is used through inheritance. It will make available the modifier
232  * `onlyOwner`, which can be applied to your functions to restrict their use to
233  * the owner.
234  */
235 contract Ownable is Context {
236     address private _owner;
237 
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor () internal {
244         address msgSender = _msgSender();
245         _owner = msgSender;
246         emit OwnershipTransferred(address(0), msgSender);
247     }
248 
249     /**
250      * @dev Returns the address of the current owner.
251      */
252     function owner() public view returns (address) {
253         return _owner;
254     }
255 
256     /**
257      * @dev Throws if called by any account other than the owner.
258      */
259     modifier onlyOwner() {
260         require(isOwner(), "Ownable: caller is not the owner");
261         _;
262     }
263 
264     /**
265      * @dev Returns true if the caller is the current owner.
266      */
267     function isOwner() public view returns (bool) {
268         return _msgSender() == _owner;
269     }
270 
271     /**
272      * @dev Leaves the contract without owner. It will not be possible to call
273      * `onlyOwner` functions anymore. Can only be called by the current owner.
274      *
275      * NOTE: Renouncing ownership will leave the contract without an owner,
276      * thereby removing any functionality that is only available to the owner.
277      */
278     function renounceOwnership() public onlyOwner {
279         emit OwnershipTransferred(_owner, address(0));
280         _owner = address(0);
281     }
282 
283     /**
284      * @dev Transfers ownership of the contract to a new account (`newOwner`).
285      * Can only be called by the current owner.
286      */
287     function transferOwnership(address newOwner) public onlyOwner {
288         _transferOwnership(newOwner);
289     }
290 
291     /**
292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
293      */
294     function _transferOwnership(address newOwner) internal {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         emit OwnershipTransferred(_owner, newOwner);
297         _owner = newOwner;
298     }
299 }
300 
301 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
302 
303 pragma solidity ^0.5.0;
304 
305 /**
306  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
307  * the optional functions; to access them see {ERC20Detailed}.
308  */
309 interface IERC20 {
310     /**
311      * @dev Returns the amount of tokens in existence.
312      */
313     function totalSupply() external view returns (uint256);
314 
315     /**
316      * @dev Returns the amount of tokens owned by `account`.
317      */
318     function balanceOf(address account) external view returns (uint256);
319 
320     /**
321      * @dev Moves `amount` tokens from the caller's account to `recipient`.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transfer(address recipient, uint256 amount) external returns (bool);
328 
329     function mint(address account, uint amount) external;
330 
331     function burn(uint amount) external;
332 
333     /**
334      * @dev Returns the remaining number of tokens that `spender` will be
335      * allowed to spend on behalf of `owner` through {transferFrom}. This is
336      * zero by default.
337      *
338      * This value changes when {approve} or {transferFrom} are called.
339      */
340     function allowance(address owner, address spender) external view returns (uint256);
341 
342     /**
343      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * IMPORTANT: Beware that changing an allowance with this method brings the risk
348      * that someone may use both the old and the new allowance by unfortunate
349      * transaction ordering. One possible solution to mitigate this race
350      * condition is to first reduce the spender's allowance to 0 and set the
351      * desired value afterwards:
352      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address spender, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Moves `amount` tokens from `sender` to `recipient` using the
360      * allowance mechanism. `amount` is then deducted from the caller's
361      * allowance.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(address indexed owner, address indexed spender, uint256 value);
382 }
383 
384 // File: @openzeppelin/contracts/utils/Address.sol
385 
386 pragma solidity ^0.5.5;
387 
388 /**
389  * @dev Collection of functions related to the address type
390  */
391 library Address {
392     /**
393      * @dev Returns true if `account` is a contract.
394      *
395      * [IMPORTANT]
396      * ====
397      * It is unsafe to assume that an address for which this function returns
398      * false is an externally-owned account (EOA) and not a contract.
399      *
400      * Among others, `isContract` will return false for the following 
401      * types of addresses:
402      *
403      *  - an externally-owned account
404      *  - a contract in construction
405      *  - an address where a contract will be created
406      *  - an address where a contract lived, but was destroyed
407      * ====
408      */
409     function isContract(address account) internal view returns (bool) {
410         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
411         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
412         // for accounts without code, i.e. `keccak256('')`
413         bytes32 codehash;
414         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
415         // solhint-disable-next-line no-inline-assembly
416         assembly { codehash := extcodehash(account) }
417         return (codehash != accountHash && codehash != 0x0);
418     }
419 
420     /**
421      * @dev Converts an `address` into `address payable`. Note that this is
422      * simply a type cast: the actual underlying value is not changed.
423      *
424      * _Available since v2.4.0._
425      */
426     function toPayable(address account) internal pure returns (address payable) {
427         return address(uint160(account));
428     }
429 
430     /**
431      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
432      * `recipient`, forwarding all available gas and reverting on errors.
433      *
434      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
435      * of certain opcodes, possibly making contracts go over the 2300 gas limit
436      * imposed by `transfer`, making them unable to receive funds via
437      * `transfer`. {sendValue} removes this limitation.
438      *
439      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
440      *
441      * IMPORTANT: because control is transferred to `recipient`, care must be
442      * taken to not create reentrancy vulnerabilities. Consider using
443      * {ReentrancyGuard} or the
444      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
445      *
446      * _Available since v2.4.0._
447      */
448     function sendValue(address payable recipient, uint256 amount) internal {
449         require(address(this).balance >= amount, "Address: insufficient balance");
450 
451         // solhint-disable-next-line avoid-call-value
452         (bool success, ) = recipient.call.value(amount)("");
453         require(success, "Address: unable to send value, recipient may have reverted");
454     }
455 }
456 
457 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
458 
459 pragma solidity ^0.5.0;
460 
461 /**
462  * @title SafeERC20
463  * @dev Wrappers around ERC20 operations that throw on failure (when the token
464  * contract returns false). Tokens that return no value (and instead revert or
465  * throw on failure) are also supported, non-reverting calls are assumed to be
466  * successful.
467  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
468  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
469  */
470 library SafeERC20 {
471     using SafeMath for uint256;
472     using Address for address;
473 
474     function safeTransfer(IERC20 token, address to, uint256 value) internal {
475         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
476     }
477 
478     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
479         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
480     }
481 
482     function safeApprove(IERC20 token, address spender, uint256 value) internal {
483         // safeApprove should only be called when setting an initial allowance,
484         // or when resetting it to zero. To increase and decrease it, use
485         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
486         // solhint-disable-next-line max-line-length
487         require((value == 0) || (token.allowance(address(this), spender) == 0),
488             "SafeERC20: approve from non-zero to non-zero allowance"
489         );
490         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
491     }
492 
493     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
494         uint256 newAllowance = token.allowance(address(this), spender).add(value);
495         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
496     }
497 
498     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
499         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
500         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
501     }
502 
503     /**
504      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
505      * on the return value: the return value is optional (but if data is returned, it must not be false).
506      * @param token The token targeted by the call.
507      * @param data The call data (encoded using abi.encode or one of its variants).
508      */
509     function callOptionalReturn(IERC20 token, bytes memory data) private {
510         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
511         // we're implementing it ourselves.
512 
513         // A Solidity high level call has three parts:
514         //  1. The target address is checked to verify it contains contract code
515         //  2. The call itself is made, and success asserted
516         //  3. The return value is decoded, which in turn checks the size of the returned data.
517         // solhint-disable-next-line max-line-length
518         require(address(token).isContract(), "SafeERC20: call to non-contract");
519 
520         // solhint-disable-next-line avoid-low-level-calls
521         (bool success, bytes memory returndata) = address(token).call(data);
522         require(success, "SafeERC20: low-level call failed");
523 
524         if (returndata.length > 0) {// Return data is optional
525             // solhint-disable-next-line max-line-length
526             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
527         }
528     }
529 }
530 
531 // File: contracts/IRewardDistributionRecipient.sol
532 
533 pragma solidity ^0.5.0;
534 
535 contract IRewardDistributionRecipient is Ownable {
536     address rewardDistribution;
537     address public rewardVote;
538     address public rewardReferral;
539 
540     function notifyRewardAmount(uint256 reward) external;
541 
542     modifier onlyRewardDistribution() {
543         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
544         _;
545     }
546 
547     function setRewardDistribution(address _rewardDistribution) external onlyOwner {
548         rewardDistribution = _rewardDistribution;
549     }
550 
551     function setRewardVote(address _rewardVote) external onlyOwner {
552         rewardVote = _rewardVote;
553     }
554 
555     function setRewardReferral(address _rewardReferral) external onlyOwner {
556         rewardReferral = _rewardReferral;
557     }
558 }
559 
560 // File: contracts/CurveRewards.sol
561 
562 pragma solidity ^0.5.0;
563 
564 contract LPTokenWrapper {
565     using SafeMath for uint256;
566     using SafeERC20 for IERC20;
567     using Address for address;
568 
569     mapping(address => uint256) private _totalSupply; // token_address -> total_supply
570     mapping(address => mapping(address => uint256)) private _balances; // token_address -> map(account -> balance)
571 
572     function totalSupply(address tokenAddress) public view returns (uint256) {
573         return _totalSupply[tokenAddress];
574     }
575 
576     function balanceOf(address tokenAddress, address account) public view returns (uint256) {
577         return _balances[tokenAddress][account];
578     }
579 
580     function tokenStake(address tokenAddress, uint256 amount) internal {
581         address sender = msg.sender;
582         require(!address(sender).isContract(), "Andre, we are farming in peace, go harvest somewhere else sir.");
583         require(tx.origin == sender, "Andre, stahp.");
584         _totalSupply[tokenAddress] = _totalSupply[tokenAddress].add(amount);
585         _balances[tokenAddress][sender] = _balances[tokenAddress][sender].add(amount);
586         IERC20(tokenAddress).safeTransferFrom(sender, address(this), amount);
587     }
588 
589     function tokenWithdraw(address tokenAddress, uint256 amount) internal {
590         _totalSupply[tokenAddress] = _totalSupply[tokenAddress].sub(amount);
591         _balances[tokenAddress][msg.sender] = _balances[tokenAddress][msg.sender].sub(amount);
592         IERC20(tokenAddress).safeTransfer(msg.sender, amount);
593     }
594 }
595 
596 interface IYFVIReferral {
597     function setReferrer(address farmer, address referrer) external;
598     function getReferrer(address farmer) external view returns (address);
599 }
600 
601 interface IYFVIVote {
602     function averageVotingValue(address poolAddress, uint256 votingItem) external view returns (uint16);
603 }
604 
605 contract YFVIRewardsStableCoin is LPTokenWrapper, IRewardDistributionRecipient {
606     IERC20 public token;
607 
608     uint256 public constant DURATION = 7 days;
609     uint8 public constant NUMBER_EPOCHS = 10;
610     uint256 public constant REFERRAL_COMMISSION_PERCENT = 5;
611     uint256 public constant EPOCH_REWARD = 63000 ether;
612     uint256 public constant TOTAL_REWARD = EPOCH_REWARD * NUMBER_EPOCHS;
613     uint256 public initreward = EPOCH_REWARD;
614     uint256 public currentEpochReward = initreward;
615     uint256 public totalAccumulatedReward = 0;
616     uint8 public currentEpoch = 0;
617     uint256 public starttime = 0;
618     uint256 public periodFinish = 0;
619     uint256 public rewardRate = 0;
620     uint256 public lastUpdateTime;
621     uint256 public rewardPerTokenStored;
622     mapping(address => uint256) public userRewardPerTokenPaid;
623     mapping(address => uint256) public rewards;
624     mapping(address => uint256) public accumulatedStakingPower; // will accumulate every time staker does getReward()
625 
626     address public USDT_TOKEN_ADDRESS;
627     address public USDC_TOKEN_ADDRESS;
628     address public TUSD_TOKEN_ADDRESS;
629     address public DAI_TOKEN_ADDRESS;
630     address payable private _wallet;
631 
632     address[4] public SUPPORTED_STAKING_COIN_ADDRESSES;
633     uint256[4] public SUPPORTED_STAKING_COIN_WEI_MULTIPLE = [1000000000000, 1000000000000, 1, 1];
634 
635     mapping(address => uint256) public supportedStakingCoinWeiMultiple; // token_address -> wei_multiple (because USDT and USDC have decimals = 6 only. Need to multiply by 1e12)
636     mapping(address => address) public affiliate; // account_address -> referrer_address
637     mapping(address => uint256) public referredCount; // referrer_address -> num_of_referred
638 
639     event RewardAdded(uint256 reward);
640     event Burned(uint256 reward);
641     event Staked(address indexed user, address indexed tokenAddress, uint256 amount);
642     event Withdrawn(address indexed user, address indexed tokenAddress, uint256 amount);
643     event RewardPaid(address indexed user, uint256 reward);
644     event CommissionPaid(address indexed user, uint256 reward);
645 
646     constructor (address payable wallet, address usdtAddr, address usdcAddr, address tusdAddr, address daiAddr, address tokenAddr, uint256 genesis) public {
647         _wallet = wallet;
648         USDT_TOKEN_ADDRESS = usdtAddr;
649         USDC_TOKEN_ADDRESS = usdcAddr;
650         TUSD_TOKEN_ADDRESS = tusdAddr;
651         DAI_TOKEN_ADDRESS = daiAddr;
652         token = IERC20(tokenAddr);
653         starttime = genesis;
654         SUPPORTED_STAKING_COIN_ADDRESSES = [USDT_TOKEN_ADDRESS, USDC_TOKEN_ADDRESS, TUSD_TOKEN_ADDRESS, DAI_TOKEN_ADDRESS];
655         for (uint8 i = 0; i < 4; i++) {
656             supportedStakingCoinWeiMultiple[SUPPORTED_STAKING_COIN_ADDRESSES[i]] = SUPPORTED_STAKING_COIN_WEI_MULTIPLE[i];
657         }
658     }
659 
660     modifier updateReward(address account) {
661         rewardPerTokenStored = rewardPerToken();
662         lastUpdateTime = lastTimeRewardApplicable();
663         if (account != address(0)) {
664             rewards[account] = earned(account);
665             userRewardPerTokenPaid[account] = rewardPerTokenStored;
666         }
667         _;
668     }
669 
670     function lastTimeRewardApplicable() public view returns (uint256) {
671         return Math.min(block.timestamp, periodFinish);
672     }
673 
674     function weiTotalSupply() public view returns (uint256) {
675         uint256 __weiTotalSupply = 0;
676         for (uint8 i = 0; i < 4; i++) {
677             __weiTotalSupply = __weiTotalSupply.add(super.totalSupply(SUPPORTED_STAKING_COIN_ADDRESSES[i]).mul(SUPPORTED_STAKING_COIN_WEI_MULTIPLE[i]));
678         }
679         return __weiTotalSupply;
680     }
681 
682     function rewardPerToken() public view returns (uint256) {
683         if (weiTotalSupply() == 0) {
684             return rewardPerTokenStored;
685         }
686         return
687         rewardPerTokenStored.add(
688             lastTimeRewardApplicable()
689             .sub(lastUpdateTime)
690             .mul(rewardRate)
691             .mul(1e18)
692             .div(weiTotalSupply())
693         );
694     }
695 
696     function weiBalanceOf(address account) public view returns (uint256) {
697         uint256 __weiBalance = 0;
698         for (uint8 i = 0; i < 4; i++) {
699             uint256 __balance = super.balanceOf(SUPPORTED_STAKING_COIN_ADDRESSES[i], account);
700             if (__balance > 0) {
701                 __weiBalance = __weiBalance.add(__balance.mul(SUPPORTED_STAKING_COIN_WEI_MULTIPLE[i]));
702             }
703         }
704         return __weiBalance;
705     }
706 
707     function earned(address account) public view returns (uint256) {
708         return
709         weiBalanceOf(account)
710         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
711         .div(1e18)
712         .add(rewards[account]);
713     }
714 
715     function stakingPower(address account) public view returns (uint256) {
716         return accumulatedStakingPower[account].add(earned(account));
717     }
718 
719     function wallet() public view returns (address payable) {
720         return _wallet;
721     }
722 
723     function stake(address tokenAddress, uint256 amount, address referrer) public updateReward(msg.sender) checkNextEpoch checkStart {
724         require(amount > 0, "Cannot stake 0");
725         require(supportedStakingCoinWeiMultiple[tokenAddress] > 0, "Not supported coin");
726         require(referrer != msg.sender, "You cannot refer yourself.");
727         super.tokenStake(tokenAddress, amount);
728         emit Staked(msg.sender, tokenAddress, amount);
729         if (rewardReferral != address(0) && referrer != address(0)) {
730             IYFVIReferral(rewardReferral).setReferrer(msg.sender, referrer);
731         }
732     }
733 
734     function withdraw(address tokenAddress, uint256 amount) public updateReward(msg.sender) checkNextEpoch checkStart {
735         require(amount > 0, "Cannot withdraw 0");
736         require(supportedStakingCoinWeiMultiple[tokenAddress] > 0, "Not supported coin");
737         super.tokenWithdraw(tokenAddress, amount);
738         emit Withdrawn(msg.sender, tokenAddress, amount);
739     }
740 
741     function exit() external {
742         for (uint8 i = 0; i < 4; i++) {
743             uint256 __balance = balanceOf(SUPPORTED_STAKING_COIN_ADDRESSES[i], msg.sender);
744             if (__balance > 0) {
745                 withdraw(SUPPORTED_STAKING_COIN_ADDRESSES[i], __balance);
746             }
747         }
748         getReward();
749     }
750 
751     function getReward() public updateReward(msg.sender) checkNextEpoch checkStart {
752         uint256 reward = earned(msg.sender);
753         if (reward > 1) {
754             accumulatedStakingPower[msg.sender] = accumulatedStakingPower[msg.sender].add(rewards[msg.sender]);
755             rewards[msg.sender] = 0;
756 
757             uint256 actualPaid = reward.mul(100 - REFERRAL_COMMISSION_PERCENT).div(100); // 95%
758             uint256 commission = reward - actualPaid; // 5%
759 
760             token.safeTransfer(msg.sender, actualPaid);
761             emit RewardPaid(msg.sender, actualPaid);
762 
763             address referrer = address(0);
764             if (rewardReferral != address(0)) {
765                 referrer = IYFVIReferral(rewardReferral).getReferrer(msg.sender);
766             }
767             if (referrer != address(0)) { // send commission to referrer
768                 token.safeTransfer(referrer, commission);
769                 emit RewardPaid(msg.sender, commission);
770             } else {// or sent to vault
771                 token.safeTransfer(_wallet, commission);
772                 emit RewardPaid(_wallet, commission);
773             }
774         }
775     }
776 
777     function nextRewardMultiplier() public view returns (uint16) {
778         if (rewardVote != address(0)) {
779             uint16 votingValue = IYFVIVote(rewardVote).averageVotingValue(address(this), periodFinish);
780             if (votingValue > 0) return votingValue;
781         }
782         return 100;
783     }
784 
785     modifier checkNextEpoch() {
786         if (block.timestamp >= periodFinish) {
787             initreward = EPOCH_REWARD; // (by consensus)
788 
789             uint16 rewardMultiplier = nextRewardMultiplier(); // 50% -> 200% (by vote)
790             currentEpochReward = initreward.mul(rewardMultiplier).div(100); // x0.50 -> x2.00 (by vote)
791 
792             if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
793                 currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
794             }
795 
796             if (currentEpochReward > 0) {
797                 token.mint(address(this), currentEpochReward);
798                 totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);
799                 currentEpoch++;
800             }
801 
802             rewardRate = currentEpochReward.div(DURATION);
803             periodFinish = block.timestamp.add(DURATION);
804             emit RewardAdded(currentEpochReward);
805         }
806         _;
807     }
808 
809     modifier checkStart() {
810         require(block.timestamp > starttime, "not start");
811         _;
812     }
813 
814     function notifyRewardAmount(uint256 reward) external onlyRewardDistribution updateReward(address(0)) {
815         if (block.timestamp >= periodFinish) {
816             rewardRate = reward.div(DURATION);
817         } else {
818             uint256 remaining = periodFinish.sub(block.timestamp);
819             uint256 leftover = remaining.mul(rewardRate);
820             rewardRate = reward.add(leftover).div(DURATION);
821         }
822         token.mint(address(this), reward);
823         totalAccumulatedReward = totalAccumulatedReward.add(reward);
824         currentEpoch++;
825         lastUpdateTime = block.timestamp;
826         periodFinish = block.timestamp.add(DURATION);
827         emit RewardAdded(reward);
828     }
829 }