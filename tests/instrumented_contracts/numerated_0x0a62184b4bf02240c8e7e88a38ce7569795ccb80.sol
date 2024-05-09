1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Standard math utilities missing in the Solidity language.
6  */
7 library Math {
8     /**
9      * @dev Returns the largest of two numbers.
10      */
11     function max(uint256 a, uint256 b) internal pure returns (uint256) {
12         return a >= b ? a : b;
13     }
14 
15     /**
16      * @dev Returns the smallest of two numbers.
17      */
18     function min(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a < b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the average of two numbers. The result is rounded towards
24      * zero.
25      */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 }
31 
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
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
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      *
84      * _Available since v2.4.0._
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
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b, "SafeMath: multiplication overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      */
127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
128         return div(a, b, "SafeMath: division by zero");
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      *
142      * _Available since v2.4.0._
143      */
144     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         // Solidity only automatically asserts when dividing by 0
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
162      * - The divisor cannot be zero.
163      */
164     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
165         return mod(a, b, "SafeMath: modulo by zero");
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts with custom message when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      *
179      * _Available since v2.4.0._
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
218  * This module is used through inheritance. It will make available the modifier
219  * `onlyOwner`, which can be applied to your functions to restrict their use to
220  * the owner.
221  */
222 contract Ownable is Context {
223     address private _owner;
224 
225     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227     /**
228      * @dev Initializes the contract setting the deployer as the initial owner.
229      */
230     constructor () internal {
231         _owner = _msgSender();
232         emit OwnershipTransferred(address(0), _owner);
233     }
234 
235     /**
236      * @dev Returns the address of the current owner.
237      */
238     function owner() public view returns (address) {
239         return _owner;
240     }
241 
242     /**
243      * @dev Throws if called by any account other than the owner.
244      */
245     modifier onlyOwner() {
246         require(isOwner(), "Ownable: caller is not the owner");
247         _;
248     }
249 
250     /**
251      * @dev Returns true if the caller is the current owner.
252      */
253     function isOwner() public view returns (bool) {
254         return _msgSender() == _owner;
255     }
256 
257     /**
258      * @dev Leaves the contract without owner. It will not be possible to call
259      * `onlyOwner` functions anymore. Can only be called by the current owner.
260      *
261      * NOTE: Renouncing ownership will leave the contract without an owner,
262      * thereby removing any functionality that is only available to the owner.
263      */
264     function renounceOwnership() public onlyOwner {
265         emit OwnershipTransferred(_owner, address(0));
266         _owner = address(0);
267     }
268 
269     /**
270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
271      * Can only be called by the current owner.
272      */
273     function transferOwnership(address newOwner) public onlyOwner {
274         _transferOwnership(newOwner);
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      */
280     function _transferOwnership(address newOwner) internal {
281         require(newOwner != address(0), "Ownable: new owner is the zero address");
282         emit OwnershipTransferred(_owner, newOwner);
283         _owner = newOwner;
284     }
285 }
286 
287 /**
288  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
289  * the optional functions; to access them see {ERC20Detailed}.
290  */
291 interface IERC20 {
292     /**
293      * @dev Returns the amount of tokens in existence.
294      */
295     function totalSupply() external view returns (uint256);
296 
297     /**
298      * @dev Returns the amount of tokens owned by `account`.
299      */
300     function balanceOf(address account) external view returns (uint256);
301 
302     /**
303      * @dev Moves `amount` tokens from the caller's account to `recipient`.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transfer(address recipient, uint256 amount) external returns (bool);
310 
311     /**
312      * @dev Returns the remaining number of tokens that `spender` will be
313      * allowed to spend on behalf of `owner` through {transferFrom}. This is
314      * zero by default.
315      *
316      * This value changes when {approve} or {transferFrom} are called.
317      */
318     function allowance(address owner, address spender) external view returns (uint256);
319 
320     /**
321      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * IMPORTANT: Beware that changing an allowance with this method brings the risk
326      * that someone may use both the old and the new allowance by unfortunate
327      * transaction ordering. One possible solution to mitigate this race
328      * condition is to first reduce the spender's allowance to 0 and set the
329      * desired value afterwards:
330      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331      *
332      * Emits an {Approval} event.
333      */
334     function approve(address spender, uint256 amount) external returns (bool);
335 
336     /**
337      * @dev Moves `amount` tokens from `sender` to `recipient` using the
338      * allowance mechanism. `amount` is then deducted from the caller's
339      * allowance.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * Emits a {Transfer} event.
344      */
345     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
346 
347     /**
348      * @dev Emitted when `value` tokens are moved from one account (`from`) to
349      * another (`to`).
350      *
351      * Note that `value` may be zero.
352      */
353     event Transfer(address indexed from, address indexed to, uint256 value);
354 
355     /**
356      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
357      * a call to {approve}. `value` is the new allowance.
358      */
359     event Approval(address indexed owner, address indexed spender, uint256 value);
360 }
361 
362 /**
363  * @dev Collection of functions related to the address type
364  */
365 library Address {
366     /**
367      * @dev Returns true if `account` is a contract.
368      *
369      * This test is non-exhaustive, and there may be false-negatives: during the
370      * execution of a contract's constructor, its address will be reported as
371      * not containing a contract.
372      *
373      * IMPORTANT: It is unsafe to assume that an address for which this
374      * function returns false is an externally-owned account (EOA) and not a
375      * contract.
376      */
377     function isContract(address account) internal view returns (bool) {
378         // This method relies in extcodesize, which returns 0 for contracts in
379         // construction, since the code is only stored at the end of the
380         // constructor execution.
381 
382         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
383         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
384         // for accounts without code, i.e. `keccak256('')`
385         bytes32 codehash;
386         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
387         // solhint-disable-next-line no-inline-assembly
388         assembly { codehash := extcodehash(account) }
389         return (codehash != 0x0 && codehash != accountHash);
390     }
391 
392     /**
393      * @dev Converts an `address` into `address payable`. Note that this is
394      * simply a type cast: the actual underlying value is not changed.
395      *
396      * _Available since v2.4.0._
397      */
398     function toPayable(address account) internal pure returns (address payable) {
399         return address(uint160(account));
400     }
401 
402     /**
403      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
404      * `recipient`, forwarding all available gas and reverting on errors.
405      *
406      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
407      * of certain opcodes, possibly making contracts go over the 2300 gas limit
408      * imposed by `transfer`, making them unable to receive funds via
409      * `transfer`. {sendValue} removes this limitation.
410      *
411      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
412      *
413      * IMPORTANT: because control is transferred to `recipient`, care must be
414      * taken to not create reentrancy vulnerabilities. Consider using
415      * {ReentrancyGuard} or the
416      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
417      *
418      * _Available since v2.4.0._
419      */
420     function sendValue(address payable recipient, uint256 amount) internal {
421         require(address(this).balance >= amount, "Address: insufficient balance");
422 
423         // solhint-disable-next-line avoid-call-value
424         (bool success, ) = recipient.call.value(amount)("");
425         require(success, "Address: unable to send value, recipient may have reverted");
426     }
427 }
428 
429 /**
430  * @title SafeERC20
431  * @dev Wrappers around ERC20 operations that throw on failure (when the token
432  * contract returns false). Tokens that return no value (and instead revert or
433  * throw on failure) are also supported, non-reverting calls are assumed to be
434  * successful.
435  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
436  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
437  */
438 library SafeERC20 {
439     using SafeMath for uint256;
440     using Address for address;
441 
442     function safeTransfer(IERC20 token, address to, uint256 value) internal {
443         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
444     }
445 
446     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
447         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
448     }
449 
450     function safeApprove(IERC20 token, address spender, uint256 value) internal {
451         // safeApprove should only be called when setting an initial allowance,
452         // or when resetting it to zero. To increase and decrease it, use
453         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
454         // solhint-disable-next-line max-line-length
455         require((value == 0) || (token.allowance(address(this), spender) == 0),
456             "SafeERC20: approve from non-zero to non-zero allowance"
457         );
458         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
459     }
460 
461     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
462         uint256 newAllowance = token.allowance(address(this), spender).add(value);
463         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
464     }
465 
466     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
467         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
468         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     /**
472      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
473      * on the return value: the return value is optional (but if data is returned, it must not be false).
474      * @param token The token targeted by the call.
475      * @param data The call data (encoded using abi.encode or one of its variants).
476      */
477     function callOptionalReturn(IERC20 token, bytes memory data) private {
478         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
479         // we're implementing it ourselves.
480 
481         // A Solidity high level call has three parts:
482         //  1. The target address is checked to verify it contains contract code
483         //  2. The call itself is made, and success asserted
484         //  3. The return value is decoded, which in turn checks the size of the returned data.
485         // solhint-disable-next-line max-line-length
486         require(address(token).isContract(), "SafeERC20: call to non-contract");
487 
488         // solhint-disable-next-line avoid-low-level-calls
489         (bool success, bytes memory returndata) = address(token).call(data);
490         require(success, "SafeERC20: low-level call failed");
491 
492         if (returndata.length > 0) { // Return data is optional
493             // solhint-disable-next-line max-line-length
494             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
495         }
496     }
497 }
498 
499 contract IRewardDistributionRecipient is Ownable {
500     address public rewardDistribution;
501 
502     function notifyRewardAmount(uint256 reward) external;
503 
504     modifier onlyRewardDistribution() {
505         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
506         _;
507     }
508 
509     function setRewardDistribution(address _rewardDistribution)
510         external
511         onlyOwner
512     {
513         rewardDistribution = _rewardDistribution;
514     }
515 }
516 
517 contract LPTokenWrapper {
518     using SafeMath for uint256;
519     using SafeERC20 for IERC20;
520 
521     IERC20 public uni = IERC20(0x02CDe6Be34a59fF01AA532d56956A3c339C26322);
522 
523     uint256 private _totalSupply;
524     mapping(address => uint256) private _balances;
525 
526     function totalSupply() public view returns (uint256) {
527         return _totalSupply;
528     }
529 
530     function balanceOf(address account) public view returns (uint256) {
531         return _balances[account];
532     }
533 
534     function stake(uint256 amount) public {
535         _totalSupply = _totalSupply.add(amount);
536         _balances[msg.sender] = _balances[msg.sender].add(amount);
537         uni.safeTransferFrom(msg.sender, address(this), amount);
538     }
539 
540     function withdraw(uint256 amount) public {
541         _totalSupply = _totalSupply.sub(amount);
542         _balances[msg.sender] = _balances[msg.sender].sub(amount);
543         uni.safeTransfer(msg.sender, amount);
544     }
545 }
546 
547 contract Unipool is LPTokenWrapper, IRewardDistributionRecipient {
548     IERC20 public lgo = IERC20(0x0a50C93c762fDD6E56D86215C24AaAD43aB629aa);
549     uint256 public constant DURATION = 31 days;
550 
551     uint256 public periodFinish = 0;
552     uint256 public rewardRate = 0;
553     uint256 public lastUpdateTime;
554     uint256 public rewardPerTokenStored;
555     mapping(address => uint256) public userRewardPerTokenPaid;
556     mapping(address => uint256) public rewards;
557 
558     event RewardAdded(uint256 reward);
559     event Staked(address indexed user, uint256 amount);
560     event Withdrawn(address indexed user, uint256 amount);
561     event RewardPaid(address indexed user, uint256 reward);
562 
563     modifier updateReward(address account) {
564         rewardPerTokenStored = rewardPerToken();
565         lastUpdateTime = lastTimeRewardApplicable();
566         if (account != address(0)) {
567             rewards[account] = earned(account);
568             userRewardPerTokenPaid[account] = rewardPerTokenStored;
569         }
570         _;
571     }
572 
573     function lastTimeRewardApplicable() public view returns (uint256) {
574         return Math.min(block.timestamp, periodFinish);
575     }
576 
577     function rewardPerToken() public view returns (uint256) {
578         if (totalSupply() == 0) {
579             return rewardPerTokenStored;
580         }
581         return
582             rewardPerTokenStored.add(
583                 lastTimeRewardApplicable()
584                     .sub(lastUpdateTime)
585                     .mul(rewardRate)
586                     .mul(1e8)
587                     .div(totalSupply())
588             );
589     }
590 
591     function earned(address account) public view returns (uint256) {
592         return
593             balanceOf(account)
594                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
595                 .div(1e8)
596                 .add(rewards[account]);
597     }
598 
599     // stake visibility is public as overriding LPTokenWrapper's stake() function
600     function stake(uint256 amount) public updateReward(msg.sender) {
601         require(amount > 0, "Cannot stake 0");
602         super.stake(amount);
603         emit Staked(msg.sender, amount);
604     }
605 
606     function withdraw(uint256 amount) public updateReward(msg.sender) {
607         require(amount > 0, "Cannot withdraw 0");
608         super.withdraw(amount);
609         emit Withdrawn(msg.sender, amount);
610     }
611 
612     function exit() external {
613         withdraw(balanceOf(msg.sender));
614         getReward();
615     }
616 
617     function getReward() public updateReward(msg.sender) {
618         uint256 reward = earned(msg.sender);
619         if (reward > 0) {
620             rewards[msg.sender] = 0;
621             lgo.safeTransfer(msg.sender, reward);
622             emit RewardPaid(msg.sender, reward);
623         }
624     }
625 
626     function notifyRewardAmount(uint256 reward)
627         external
628         onlyRewardDistribution
629         updateReward(address(0))
630     {
631         if (block.timestamp >= periodFinish) {
632             rewardRate = reward.div(DURATION);
633         } else {
634             uint256 remaining = periodFinish.sub(block.timestamp);
635             uint256 leftover = remaining.mul(rewardRate);
636             rewardRate = reward.add(leftover).div(DURATION);
637         }
638         lastUpdateTime = block.timestamp;
639         periodFinish = block.timestamp.add(DURATION);
640         emit RewardAdded(reward);
641     }
642 }