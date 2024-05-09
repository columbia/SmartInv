1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Standard math utilities missing in the Solidity language.
5  */
6 library Math {
7     /**
8      * @dev Returns the largest of two numbers.
9      */
10     function max(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a >= b ? a : b;
12     }
13 
14     /**
15      * @dev Returns the smallest of two numbers.
16      */
17     function min(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a < b ? a : b;
19     }
20 
21     /**
22      * @dev Returns the average of two numbers. The result is rounded towards
23      * zero.
24      */
25     function average(uint256 a, uint256 b) internal pure returns (uint256) {
26         // (a + b) / 2 can overflow, so we distribute
27         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
28     }
29 }
30 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      *
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      *
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      *
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return mod(a, b, "SafeMath: modulo by zero");
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts with custom message when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 /*
188  * @dev Provides information about the current execution context, including the
189  * sender of the transaction and its data. While these are generally available
190  * via msg.sender and msg.data, they should not be accessed in such a direct
191  * manner, since when dealing with GSN meta-transactions the account sending and
192  * paying for execution may not be the actual sender (as far as an application
193  * is concerned).
194  *
195  * This contract is only required for intermediate, library-like contracts.
196  */
197 contract Context {
198     // Empty internal constructor, to prevent people from mistakenly deploying
199     // an instance of this contract, which should be used via inheritance.
200     constructor () internal { }
201     // solhint-disable-previous-line no-empty-blocks
202     
203     function _msgSender() internal view returns (address payable) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view returns (bytes memory) {
208         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
209         return msg.data;
210     }
211 }
212 
213 /**
214  * @dev Contract module which provides a basic access control mechanism, where
215  * there is an account (an owner) that can be granted exclusive access to
216  * specific functions.
217  *
218  * By default, the owner account will be the one that deploys the contract. This
219  * can later be changed with {transferOwnership}.
220  *
221  * This module is used through inheritance. It will make available the modifier
222  * `onlyOwner`, which can be applied to your functions to restrict their use to
223  * the owner.
224  */
225 contract Ownable is Context {
226     address private _owner;
227 
228     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
229 
230     /**
231      * @dev Initializes the contract setting the deployer as the initial owner.
232      */
233     constructor () internal {
234         address msgSender = _msgSender();
235         _owner = msgSender;
236         emit OwnershipTransferred(address(0), msgSender);
237     }
238 
239     /**
240      * @dev Returns the address of the current owner.
241      */
242     function owner() public view returns (address) {
243         return _owner;
244     }
245 
246     /**
247      * @dev Throws if called by any account other than the owner.
248      */
249     modifier onlyOwner() {
250         require(_owner == _msgSender(), "Ownable: caller is not the owner");
251         _;
252     }
253 
254     /**
255      * @dev Leaves the contract without owner. It will not be possible to call
256      * `onlyOwner` functions anymore. Can only be called by the current owner.
257      *
258      * NOTE: Renouncing ownership will leave the contract without an owner,
259      * thereby removing any functionality that is only available to the owner.
260      */
261     function renounceOwnership() public onlyOwner {
262         emit OwnershipTransferred(_owner, address(0));
263         _owner = address(0);
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Can only be called by the current owner.
269      */
270     function transferOwnership(address newOwner) public onlyOwner {
271         require(newOwner != address(0), "Ownable: new owner is the zero address");
272         emit OwnershipTransferred(_owner, newOwner);
273         _owner = newOwner;
274     }
275 }
276 
277 /**
278  * @dev Interface of the ERC20 standard as defined in the EIP.
279  */
280 interface IERC20 {
281     /**
282      * @dev Returns the amount of tokens in existence.
283      */
284     function totalSupply() external view returns (uint256);
285 
286     /**
287      * @dev Returns the amount of tokens owned by `account`.
288      */
289     function balanceOf(address account) external view returns (uint256);
290 
291     /**
292      * @dev Moves `amount` tokens from the caller's account to `recipient`.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transfer(address recipient, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Returns the remaining number of tokens that `spender` will be
302      * allowed to spend on behalf of `owner` through {transferFrom}. This is
303      * zero by default.
304      *
305      * This value changes when {approve} or {transferFrom} are called.
306      */
307     function allowance(address owner, address spender) external view returns (uint256);
308 
309     /**
310      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
311      *
312      * Returns a boolean value indicating whether the operation succeeded.
313      *
314      * IMPORTANT: Beware that changing an allowance with this method brings the risk
315      * that someone may use both the old and the new allowance by unfortunate
316      * transaction ordering. One possible solution to mitigate this race
317      * condition is to first reduce the spender's allowance to 0 and set the
318      * desired value afterwards:
319      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320      *
321      * Emits an {Approval} event.
322      */
323     function approve(address spender, uint256 amount) external returns (bool);
324 
325     /**
326      * @dev Moves `amount` tokens from `sender` to `recipient` using the
327      * allowance mechanism. `amount` is then deducted from the caller's
328      * allowance.
329      *
330      * Returns a boolean value indicating whether the operation succeeded.
331      *
332      * Emits a {Transfer} event.
333      */
334     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
335 
336     /**
337      * @dev Emitted when `value` tokens are moved from one account (`from`) to
338      * another (`to`).
339      *
340      * Note that `value` may be zero.
341      */
342     event Transfer(address indexed from, address indexed to, uint256 value);
343 
344     /**
345      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
346      * a call to {approve}. `value` is the new allowance.
347      */
348     event Approval(address indexed owner, address indexed spender, uint256 value);
349 }
350 
351 /**
352  * @dev Collection of functions related to the address type
353  */
354 library Address {
355     /**
356      * @dev Returns true if `account` is a contract.
357      *
358      * [IMPORTANT]
359      * ====
360      * It is unsafe to assume that an address for which this function returns
361      * false is an externally-owned account (EOA) and not a contract.
362      *
363      * Among others, `isContract` will return false for the following
364      * types of addresses:
365      *
366      *  - an externally-owned account
367      *  - a contract in construction
368      *  - an address where a contract will be created
369      *  - an address where a contract lived, but was destroyed
370      * ====
371      */
372     function isContract(address account) internal view returns (bool) {
373         // This method relies in extcodesize, which returns 0 for contracts in
374         // construction, since the code is only stored at the end of the
375         // constructor execution.
376 
377         uint256 size;
378         // solhint-disable-next-line no-inline-assembly
379         assembly { size := extcodesize(account) }
380         return size > 0;
381     }
382 
383     /**
384      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
385      * `recipient`, forwarding all available gas and reverting on errors.
386      *
387      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
388      * of certain opcodes, possibly making contracts go over the 2300 gas limit
389      * imposed by `transfer`, making them unable to receive funds via
390      * `transfer`. {sendValue} removes this limitation.
391      *
392      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
393      *
394      * IMPORTANT: because control is transferred to `recipient`, care must be
395      * taken to not create reentrancy vulnerabilities. Consider using
396      * {ReentrancyGuard} or the
397      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
398      */
399     function sendValue(address payable recipient, uint256 amount) internal {
400         require(address(this).balance >= amount, "Address: insufficient balance");
401 
402         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
403         (bool success, ) = recipient.call.value(amount)("");
404         require(success, "Address: unable to send value, recipient may have reverted");
405     }
406 }
407 
408 /**
409  * @title SafeERC20
410  * @dev Wrappers around ERC20 operations that throw on failure (when the token
411  * contract returns false). Tokens that return no value (and instead revert or
412  * throw on failure) are also supported, non-reverting calls are assumed to be
413  * successful.
414  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
415  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
416  */
417 library SafeERC20 {
418     using SafeMath for uint256;
419     using Address for address;
420 
421     function safeTransfer(IERC20 token, address to, uint256 value) internal {
422         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
423     }
424 
425     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
427     }
428 
429     /**
430      * @dev Deprecated. This function has issues similar to the ones found in
431      * {IERC20-approve}, and its usage is discouraged.
432      *
433      * Whenever possible, use {safeIncreaseAllowance} and
434      * {safeDecreaseAllowance} instead.
435      */
436     function safeApprove(IERC20 token, address spender, uint256 value) internal {
437         // safeApprove should only be called when setting an initial allowance,
438         // or when resetting it to zero. To increase and decrease it, use
439         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
440         // solhint-disable-next-line max-line-length
441         require((value == 0) || (token.allowance(address(this), spender) == 0),
442             "SafeERC20: approve from non-zero to non-zero allowance"
443         );
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
445     }
446 
447     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).add(value);
449         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450     }
451 
452     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
453         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
454         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
455     }
456 
457     /**
458      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
459      * on the return value: the return value is optional (but if data is returned, it must not be false).
460      * @param token The token targeted by the call.
461      * @param data The call data (encoded using abi.encode or one of its variants).
462      */
463     function _callOptionalReturn(IERC20 token, bytes memory data) private {
464         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
465         // we're implementing it ourselves.
466 
467         // A Solidity high level call has three parts:
468         //  1. The target address is checked to verify it contains contract code
469         //  2. The call itself is made, and success asserted
470         //  3. The return value is decoded, which in turn checks the size of the returned data.
471         // solhint-disable-next-line max-line-length
472         require(address(token).isContract(), "SafeERC20: call to non-contract");
473 
474         // solhint-disable-next-line avoid-low-level-calls
475         (bool success, bytes memory returndata) = address(token).call(data);
476         require(success, "SafeERC20: low-level call failed");
477 
478         if (returndata.length > 0) { // Return data is optional
479             // solhint-disable-next-line max-line-length
480             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
481         }
482     }
483 }
484 
485 contract IRewardDistributionRecipient is Ownable {
486     address public rewardDistribution;
487 
488     function notifyRewardAmount(uint256 reward) external;
489 
490     modifier onlyRewardDistribution() {
491         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
492         _;
493     }
494 
495     function setRewardDistribution(address _rewardDistribution)
496         external
497         onlyOwner
498     {
499         rewardDistribution = _rewardDistribution;
500     }
501 }
502 
503 contract LPTokenWrapper {
504     using SafeMath for uint256;
505     using SafeERC20 for IERC20;
506 
507     // Uniswap V2 LP token for DOS/ETH pair
508     IERC20 public uni = IERC20(0xdAdf443c086F9D3C556ebC57c398a852f6a02898);
509 
510     uint256 private _totalSupply;
511     mapping(address => uint256) private _balances;
512 
513     function totalSupply() public view returns (uint256) {
514         return _totalSupply;
515     }
516 
517     function balanceOf(address account) public view returns (uint256) {
518         return _balances[account];
519     }
520 
521     function stake(uint256 amount) public {
522         _totalSupply = _totalSupply.add(amount);
523         _balances[msg.sender] = _balances[msg.sender].add(amount);
524         uni.safeTransferFrom(msg.sender, address(this), amount);
525     }
526 
527     function withdraw(uint256 amount) public {
528         _totalSupply = _totalSupply.sub(amount);
529         _balances[msg.sender] = _balances[msg.sender].sub(amount);
530         uni.safeTransfer(msg.sender, amount);
531     }
532 }
533 
534 contract Unipool is LPTokenWrapper, IRewardDistributionRecipient {
535     IERC20 public dos = IERC20(0x0A913beaD80F321E7Ac35285Ee10d9d922659cB7);
536     uint256 public constant DURATION = 7 days;
537 
538     uint256 public periodFinish = 0;
539     uint256 public rewardRate = 0;
540     uint256 public lastUpdateTime;
541     uint256 public rewardPerTokenStored;
542     mapping(address => uint256) public userRewardPerTokenPaid;
543     mapping(address => uint256) public rewards;
544 
545     event RewardAdded(uint256 reward);
546     event Staked(address indexed user, uint256 amount);
547     event Withdrawn(address indexed user, uint256 amount);
548     event RewardPaid(address indexed user, uint256 reward);
549 
550     modifier updateReward(address account) {
551         rewardPerTokenStored = rewardPerToken();
552         lastUpdateTime = lastTimeRewardApplicable();
553         if (account != address(0)) {
554             rewards[account] = earned(account);
555             userRewardPerTokenPaid[account] = rewardPerTokenStored;
556         }
557         _;
558     }
559 
560     function lastTimeRewardApplicable() public view returns (uint256) {
561         return Math.min(block.timestamp, periodFinish);
562     }
563 
564     function rewardPerToken() public view returns (uint256) {
565         if (totalSupply() == 0) {
566             return rewardPerTokenStored;
567         }
568         return
569             rewardPerTokenStored.add(
570                 lastTimeRewardApplicable()
571                     .sub(lastUpdateTime)
572                     .mul(rewardRate)
573                     .mul(1e18)
574                     .div(totalSupply())
575             );
576     }
577 
578     function earned(address account) public view returns (uint256) {
579         return
580             balanceOf(account)
581                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
582                 .div(1e18)
583                 .add(rewards[account]);
584     }
585 
586     // stake visibility is public as overriding LPTokenWrapper's stake() function
587     function stake(uint256 amount) public updateReward(msg.sender) {
588         require(amount > 0, "Cannot stake 0");
589         super.stake(amount);
590         emit Staked(msg.sender, amount);
591     }
592 
593     function withdraw(uint256 amount) public updateReward(msg.sender) {
594         require(amount > 0, "Cannot withdraw 0");
595         super.withdraw(amount);
596         emit Withdrawn(msg.sender, amount);
597     }
598 
599     function exit() external {
600         withdraw(balanceOf(msg.sender));
601         getReward();
602     }
603 
604     function getReward() public updateReward(msg.sender) {
605         uint256 reward = earned(msg.sender);
606         if (reward > 0) {
607             rewards[msg.sender] = 0;
608             dos.safeTransfer(msg.sender, reward);
609             emit RewardPaid(msg.sender, reward);
610         }
611     }
612 
613     function notifyRewardAmount(uint256 reward)
614         external
615         onlyRewardDistribution
616         updateReward(address(0))
617     {
618         if (block.timestamp >= periodFinish) {
619             rewardRate = reward.div(DURATION);
620         } else {
621             uint256 remaining = periodFinish.sub(block.timestamp);
622             uint256 leftover = remaining.mul(rewardRate);
623             rewardRate = reward.add(leftover).div(DURATION);
624         }
625         lastUpdateTime = block.timestamp;
626         periodFinish = block.timestamp.add(DURATION);
627         emit RewardAdded(reward);
628     }
629 }