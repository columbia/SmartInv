1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-15
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     /**
12      * @dev Returns the largest of two numbers.
13      */
14     function max(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a >= b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     function min(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the average of two numbers. The result is rounded towards
27      * zero.
28      */
29     function average(uint256 a, uint256 b) internal pure returns (uint256) {
30         // (a + b) / 2 can overflow, so we distribute
31         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
32     }
33 }
34 
35 /**
36  * @dev Wrappers over Solidity's arithmetic operations with added overflow
37  * checks.
38  *
39  * Arithmetic operations in Solidity wrap on overflow. This can easily result
40  * in bugs, because programmers usually assume that an overflow raises an
41  * error, which is the standard behavior in high level programming languages.
42  * `SafeMath` restores this intuition by reverting the transaction when an
43  * operation overflows.
44  *
45  * Using this library instead of the unchecked operations eliminates an entire
46  * class of bugs, so it's recommended to use it always.
47  */
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `+` operator.
54      *
55      * Requirements:
56      *
57      * - Addition cannot overflow.
58      */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      *
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
87      *
88      * - Subtraction cannot overflow.
89      */
90     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the multiplication of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `*` operator.
102      *
103      * Requirements:
104      *
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
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
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
182      *
183      * - The divisor cannot be zero.
184      */
185     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b != 0, errorMessage);
187         return a % b;
188     }
189 }
190 
191 /*
192  * @dev Provides information about the current execution context, including the
193  * sender of the transaction and its data. While these are generally available
194  * via msg.sender and msg.data, they should not be accessed in such a direct
195  * manner, since when dealing with GSN meta-transactions the account sending and
196  * paying for execution may not be the actual sender (as far as an application
197  * is concerned).
198  *
199  * This contract is only required for intermediate, library-like contracts.
200  */
201 contract Context {
202     // Empty internal constructor, to prevent people from mistakenly deploying
203     // an instance of this contract, which should be used via inheritance.
204     constructor () internal { }
205     // solhint-disable-previous-line no-empty-blocks
206     
207     function _msgSender() internal view returns (address payable) {
208         return msg.sender;
209     }
210 
211     function _msgData() internal view returns (bytes memory) {
212         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
213         return msg.data;
214     }
215 }
216 
217 /**
218  * @dev Contract module which provides a basic access control mechanism, where
219  * there is an account (an owner) that can be granted exclusive access to
220  * specific functions.
221  *
222  * By default, the owner account will be the one that deploys the contract. This
223  * can later be changed with {transferOwnership}.
224  *
225  * This module is used through inheritance. It will make available the modifier
226  * `onlyOwner`, which can be applied to your functions to restrict their use to
227  * the owner.
228  */
229 contract Ownable is Context {
230     address private _owner;
231 
232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234     /**
235      * @dev Initializes the contract setting the deployer as the initial owner.
236      */
237     constructor () internal {
238         address msgSender = _msgSender();
239         _owner = msgSender;
240         emit OwnershipTransferred(address(0), msgSender);
241     }
242 
243     /**
244      * @dev Returns the address of the current owner.
245      */
246     function owner() public view returns (address) {
247         return _owner;
248     }
249 
250     /**
251      * @dev Throws if called by any account other than the owner.
252      */
253     modifier onlyOwner() {
254         require(_owner == _msgSender(), "Ownable: caller is not the owner");
255         _;
256     }
257 
258     /**
259      * @dev Leaves the contract without owner. It will not be possible to call
260      * `onlyOwner` functions anymore. Can only be called by the current owner.
261      *
262      * NOTE: Renouncing ownership will leave the contract without an owner,
263      * thereby removing any functionality that is only available to the owner.
264      */
265     function renounceOwnership() public onlyOwner {
266         emit OwnershipTransferred(_owner, address(0));
267         _owner = address(0);
268     }
269 
270     /**
271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
272      * Can only be called by the current owner.
273      */
274     function transferOwnership(address newOwner) public onlyOwner {
275         require(newOwner != address(0), "Ownable: new owner is the zero address");
276         emit OwnershipTransferred(_owner, newOwner);
277         _owner = newOwner;
278     }
279 }
280 
281 /**
282  * @dev Interface of the ERC20 standard as defined in the EIP.
283  */
284 interface IERC20 {
285     /**
286      * @dev Returns the amount of tokens in existence.
287      */
288     function totalSupply() external view returns (uint256);
289 
290     /**
291      * @dev Returns the amount of tokens owned by `account`.
292      */
293     function balanceOf(address account) external view returns (uint256);
294 
295     /**
296      * @dev Moves `amount` tokens from the caller's account to `recipient`.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transfer(address recipient, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Returns the remaining number of tokens that `spender` will be
306      * allowed to spend on behalf of `owner` through {transferFrom}. This is
307      * zero by default.
308      *
309      * This value changes when {approve} or {transferFrom} are called.
310      */
311     function allowance(address owner, address spender) external view returns (uint256);
312 
313     /**
314      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
315      *
316      * Returns a boolean value indicating whether the operation succeeded.
317      *
318      * IMPORTANT: Beware that changing an allowance with this method brings the risk
319      * that someone may use both the old and the new allowance by unfortunate
320      * transaction ordering. One possible solution to mitigate this race
321      * condition is to first reduce the spender's allowance to 0 and set the
322      * desired value afterwards:
323      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
324      *
325      * Emits an {Approval} event.
326      */
327     function approve(address spender, uint256 amount) external returns (bool);
328 
329     /**
330      * @dev Moves `amount` tokens from `sender` to `recipient` using the
331      * allowance mechanism. `amount` is then deducted from the caller's
332      * allowance.
333      *
334      * Returns a boolean value indicating whether the operation succeeded.
335      *
336      * Emits a {Transfer} event.
337      */
338     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
339 
340     /**
341      * @dev Emitted when `value` tokens are moved from one account (`from`) to
342      * another (`to`).
343      *
344      * Note that `value` may be zero.
345      */
346     event Transfer(address indexed from, address indexed to, uint256 value);
347 
348     /**
349      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
350      * a call to {approve}. `value` is the new allowance.
351      */
352     event Approval(address indexed owner, address indexed spender, uint256 value);
353 }
354 
355 /**
356  * @dev Collection of functions related to the address type
357  */
358 library Address {
359     /**
360      * @dev Returns true if `account` is a contract.
361      *
362      * [IMPORTANT]
363      * ====
364      * It is unsafe to assume that an address for which this function returns
365      * false is an externally-owned account (EOA) and not a contract.
366      *
367      * Among others, `isContract` will return false for the following
368      * types of addresses:
369      *
370      *  - an externally-owned account
371      *  - a contract in construction
372      *  - an address where a contract will be created
373      *  - an address where a contract lived, but was destroyed
374      * ====
375      */
376     function isContract(address account) internal view returns (bool) {
377         // This method relies in extcodesize, which returns 0 for contracts in
378         // construction, since the code is only stored at the end of the
379         // constructor execution.
380 
381         uint256 size;
382         // solhint-disable-next-line no-inline-assembly
383         assembly { size := extcodesize(account) }
384         return size > 0;
385     }
386 
387     /**
388      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
389      * `recipient`, forwarding all available gas and reverting on errors.
390      *
391      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
392      * of certain opcodes, possibly making contracts go over the 2300 gas limit
393      * imposed by `transfer`, making them unable to receive funds via
394      * `transfer`. {sendValue} removes this limitation.
395      *
396      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
397      *
398      * IMPORTANT: because control is transferred to `recipient`, care must be
399      * taken to not create reentrancy vulnerabilities. Consider using
400      * {ReentrancyGuard} or the
401      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
402      */
403     function sendValue(address payable recipient, uint256 amount) internal {
404         require(address(this).balance >= amount, "Address: insufficient balance");
405 
406         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
407         (bool success, ) = recipient.call.value(amount)("");
408         require(success, "Address: unable to send value, recipient may have reverted");
409     }
410 }
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure (when the token
415  * contract returns false). Tokens that return no value (and instead revert or
416  * throw on failure) are also supported, non-reverting calls are assumed to be
417  * successful.
418  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
419  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
420  */
421 library SafeERC20 {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     function safeTransfer(IERC20 token, address to, uint256 value) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
427     }
428 
429     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
430         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
431     }
432 
433     /**
434      * @dev Deprecated. This function has issues similar to the ones found in
435      * {IERC20-approve}, and its usage is discouraged.
436      *
437      * Whenever possible, use {safeIncreaseAllowance} and
438      * {safeDecreaseAllowance} instead.
439      */
440     function safeApprove(IERC20 token, address spender, uint256 value) internal {
441         // safeApprove should only be called when setting an initial allowance,
442         // or when resetting it to zero. To increase and decrease it, use
443         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
444         // solhint-disable-next-line max-line-length
445         require((value == 0) || (token.allowance(address(this), spender) == 0),
446             "SafeERC20: approve from non-zero to non-zero allowance"
447         );
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
449     }
450 
451     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
452         uint256 newAllowance = token.allowance(address(this), spender).add(value);
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
454     }
455 
456     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
459     }
460 
461     /**
462      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
463      * on the return value: the return value is optional (but if data is returned, it must not be false).
464      * @param token The token targeted by the call.
465      * @param data The call data (encoded using abi.encode or one of its variants).
466      */
467     function _callOptionalReturn(IERC20 token, bytes memory data) private {
468         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
469         // we're implementing it ourselves.
470 
471         // A Solidity high level call has three parts:
472         //  1. The target address is checked to verify it contains contract code
473         //  2. The call itself is made, and success asserted
474         //  3. The return value is decoded, which in turn checks the size of the returned data.
475         // solhint-disable-next-line max-line-length
476         require(address(token).isContract(), "SafeERC20: call to non-contract");
477 
478         // solhint-disable-next-line avoid-low-level-calls
479         (bool success, bytes memory returndata) = address(token).call(data);
480         require(success, "SafeERC20: low-level call failed");
481 
482         if (returndata.length > 0) { // Return data is optional
483             // solhint-disable-next-line max-line-length
484             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
485         }
486     }
487 }
488 
489 contract IRewardDistributionRecipient is Ownable {
490     address public rewardDistribution;
491 
492     function notifyRewardAmount(uint256 reward) external;
493 
494     modifier onlyRewardDistribution() {
495         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
496         _;
497     }
498 
499     function setRewardDistribution(address _rewardDistribution)
500         external
501         onlyOwner
502     {
503         rewardDistribution = _rewardDistribution;
504     }
505 }
506 
507 contract LPTokenWrapper {
508     using SafeMath for uint256;
509     using SafeERC20 for IERC20;
510 
511     // Balancer LP token for DOS/USDC 40/60 pair                                   
512     IERC20 public bpt = IERC20(0x7d014A7464C91F20da99a3E6f77bc5506dDF3C5E);
513 
514     uint256 private _totalSupply;
515     mapping(address => uint256) private _balances;
516 
517     function totalSupply() public view returns (uint256) {
518         return _totalSupply;
519     }
520 
521     function balanceOf(address account) public view returns (uint256) {
522         return _balances[account];
523     }
524 
525     function stake(uint256 amount) public {
526         _totalSupply = _totalSupply.add(amount);
527         _balances[msg.sender] = _balances[msg.sender].add(amount);
528         bpt.safeTransferFrom(msg.sender, address(this), amount);
529     }
530 
531     function withdraw(uint256 amount) public {
532         _totalSupply = _totalSupply.sub(amount);
533         _balances[msg.sender] = _balances[msg.sender].sub(amount);
534         bpt.safeTransfer(msg.sender, amount);
535     }
536 }
537 
538 contract Unipool is LPTokenWrapper, IRewardDistributionRecipient {
539     IERC20 public dos = IERC20(0x0A913beaD80F321E7Ac35285Ee10d9d922659cB7);
540     IERC20 public bal = IERC20(0xba100000625a3754423978a60c9317c58a424e3D);
541     uint256 public constant DURATION = 7 days;
542 
543     uint256 public periodFinish = 0;
544     uint256 public rewardRate = 0;
545     uint256 public lastUpdateTime;
546     uint256 public rewardPerTokenStored;
547     mapping(address => uint256) public userRewardPerTokenPaid;
548     mapping(address => uint256) public rewards;
549 
550     event RewardAdded(uint256 reward);
551     event Staked(address indexed user, uint256 amount);
552     event Withdrawn(address indexed user, uint256 amount);
553     event RewardPaid(address indexed user, uint256 reward);
554 
555     modifier updateReward(address account) {
556         rewardPerTokenStored = rewardPerToken();
557         lastUpdateTime = lastTimeRewardApplicable();
558         if (account != address(0)) {
559             rewards[account] = earned(account);
560             userRewardPerTokenPaid[account] = rewardPerTokenStored;
561         }
562         _;
563     }
564 
565     function lastTimeRewardApplicable() public view returns (uint256) {
566         return Math.min(block.timestamp, periodFinish);
567     }
568 
569     function rewardPerToken() public view returns (uint256) {
570         if (totalSupply() == 0) {
571             return rewardPerTokenStored;
572         }
573         return
574             rewardPerTokenStored.add(
575                 lastTimeRewardApplicable()
576                     .sub(lastUpdateTime)
577                     .mul(rewardRate)
578                     .mul(1e18)
579                     .div(totalSupply())
580             );
581     }
582 
583     function earned(address account) public view returns (uint256) {
584         return
585             balanceOf(account)
586                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
587                 .div(1e18)
588                 .add(rewards[account]);
589     }
590 
591     // stake visibility is public as overriding LPTokenWrapper's stake() function
592     function stake(uint256 amount) public updateReward(msg.sender) {
593         require(amount > 0, "Cannot stake 0");
594         super.stake(amount);
595         emit Staked(msg.sender, amount);
596     }
597 
598     function withdraw(uint256 amount) public updateReward(msg.sender) {
599         require(amount > 0, "Cannot withdraw 0");
600         super.withdraw(amount);
601         emit Withdrawn(msg.sender, amount);
602     }
603 
604     function exit() external {
605         withdraw(balanceOf(msg.sender));
606         getReward();
607     }
608 
609     function getReward() public updateReward(msg.sender) {
610         uint256 reward = earned(msg.sender);
611         if (reward > 0) {
612             rewards[msg.sender] = 0;
613             dos.safeTransfer(msg.sender, reward);
614             emit RewardPaid(msg.sender, reward);
615         }
616     }
617 
618     function notifyRewardAmount(uint256 reward)
619         external
620         onlyRewardDistribution
621         updateReward(address(0))
622     {
623         if (block.timestamp >= periodFinish) {
624             rewardRate = reward.div(DURATION);
625         } else {
626             uint256 remaining = periodFinish.sub(block.timestamp);
627             uint256 leftover = remaining.mul(rewardRate);
628             rewardRate = reward.add(leftover).div(DURATION);
629         }
630         lastUpdateTime = block.timestamp;
631         periodFinish = block.timestamp.add(DURATION);
632         emit RewardAdded(reward);
633     }
634 
635     // Claim BAL rewards sent to the contract (if any) to the reserve address / contract,
636     // for either BAL distribution to LPs, or sell BAL and buy back dos, depending on LP voting.
637     function claimBalReward(address reserve) external onlyRewardDistribution {
638         bal.safeTransfer(reserve, bal.balanceOf(address(this)));
639     }
640 }