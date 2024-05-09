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
187 /**
188  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
189  * the optional functions; to access them see {ERC20Detailed}.
190  */
191 interface IERC20 {
192     /**
193      * @dev Returns the amount of tokens in existence.
194      */
195     function totalSupply() external view returns (uint256);
196 
197     /**
198      * @dev Returns the amount of tokens owned by `account`.
199      */
200     function balanceOf(address account) external view returns (uint256);
201 
202     /**
203      * @dev Moves `amount` tokens from the caller's account to `recipient`.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transfer(address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Returns the remaining number of tokens that `spender` will be
213      * allowed to spend on behalf of `owner` through {transferFrom}. This is
214      * zero by default.
215      *
216      * This value changes when {approve} or {transferFrom} are called.
217      */
218     function allowance(address owner, address spender) external view returns (uint256);
219 
220     /**
221      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * IMPORTANT: Beware that changing an allowance with this method brings the risk
226      * that someone may use both the old and the new allowance by unfortunate
227      * transaction ordering. One possible solution to mitigate this race
228      * condition is to first reduce the spender's allowance to 0 and set the
229      * desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address spender, uint256 amount) external returns (bool);
235 
236     /**
237      * @dev Moves `amount` tokens from `sender` to `recipient` using the
238      * allowance mechanism. `amount` is then deducted from the caller's
239      * allowance.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Emitted when `value` tokens are moved from one account (`from`) to
249      * another (`to`).
250      *
251      * Note that `value` may be zero.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 value);
254 
255     /**
256      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
257      * a call to {approve}. `value` is the new allowance.
258      */
259     event Approval(address indexed owner, address indexed spender, uint256 value);
260 }
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following 
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Converts an `address` into `address payable`. Note that this is
296      * simply a type cast: the actual underlying value is not changed.
297      *
298      * _Available since v2.4.0._
299      */
300     function toPayable(address account) internal pure returns (address payable) {
301         return address(uint160(account));
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      *
320      * _Available since v2.4.0._
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-call-value
326         (bool success, ) = recipient.call.value(amount)("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 }
330 
331 /**
332  * @title SafeERC20
333  * @dev Wrappers around ERC20 operations that throw on failure (when the token
334  * contract returns false). Tokens that return no value (and instead revert or
335  * throw on failure) are also supported, non-reverting calls are assumed to be
336  * successful.
337  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
338  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
339  */
340 library SafeERC20 {
341     using SafeMath for uint256;
342     using Address for address;
343 
344     function safeTransfer(IERC20 token, address to, uint256 value) internal {
345         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
346     }
347 
348     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
349         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
350     }
351 
352     function safeApprove(IERC20 token, address spender, uint256 value) internal {
353         // safeApprove should only be called when setting an initial allowance,
354         // or when resetting it to zero. To increase and decrease it, use
355         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
356         // solhint-disable-next-line max-line-length
357         require((value == 0) || (token.allowance(address(this), spender) == 0),
358             "SafeERC20: approve from non-zero to non-zero allowance"
359         );
360         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
361     }
362 
363     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
364         uint256 newAllowance = token.allowance(address(this), spender).add(value);
365         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
366     }
367 
368     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
369         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
370         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
371     }
372 
373     /**
374      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
375      * on the return value: the return value is optional (but if data is returned, it must not be false).
376      * @param token The token targeted by the call.
377      * @param data The call data (encoded using abi.encode or one of its variants).
378      */
379     function callOptionalReturn(IERC20 token, bytes memory data) private {
380         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
381         // we're implementing it ourselves.
382 
383         // A Solidity high level call has three parts:
384         //  1. The target address is checked to verify it contains contract code
385         //  2. The call itself is made, and success asserted
386         //  3. The return value is decoded, which in turn checks the size of the returned data.
387         // solhint-disable-next-line max-line-length
388         require(address(token).isContract(), "SafeERC20: call to non-contract");
389 
390         // solhint-disable-next-line avoid-low-level-calls
391         (bool success, bytes memory returndata) = address(token).call(data);
392         require(success, "SafeERC20: low-level call failed");
393 
394         if (returndata.length > 0) { // Return data is optional
395             // solhint-disable-next-line max-line-length
396             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
397         }
398     }
399 }
400 
401 interface ApproveAndCallFallBack {
402     /**
403     * @dev This allows users to use their tokens to interact with contracts in one function call instead of two
404     * @param _from Address of the account transferring the tokens
405     * @param _amount The amount of tokens approved for in the transfer
406     * @param _token Address of the token contract calling this function
407     * @param _data Optional data that can be used to add signalling information in more complex staking applications
408     */
409     function receiveApproval(address _from, uint256 _amount, address _token, bytes calldata _data) external;
410 }
411 
412 contract LPTokenWrapper {
413     using SafeMath for uint256;
414     using SafeERC20 for IERC20;
415 
416     // Uniswap v2 ANT/ETH pair token
417     IERC20 public UNI = IERC20(0xfa19de406e8F5b9100E4dD5CaD8a503a6d686Efe);
418 
419     uint256 private _totalSupply;
420     mapping(address => uint256) private _balances;
421 
422     function totalSupply() public view returns (uint256) {
423         return _totalSupply;
424     }
425 
426     function balanceOf(address account) public view returns (uint256) {
427         return _balances[account];
428     }
429 
430     function stake(uint256 amount) public {
431         _totalSupply = _totalSupply.add(amount);
432         _balances[msg.sender] = _balances[msg.sender].add(amount);
433         UNI.safeTransferFrom(msg.sender, address(this), amount);
434     }
435 
436     function withdraw(uint256 amount) public {
437         _totalSupply = _totalSupply.sub(amount);
438         _balances[msg.sender] = _balances[msg.sender].sub(amount);
439         UNI.safeTransfer(msg.sender, amount);
440     }
441 }
442 
443 contract Unipool is LPTokenWrapper, ApproveAndCallFallBack {
444     uint256 public constant DURATION = 30 days;
445     // Aragon Network Token
446     IERC20 public ANT = IERC20(0x960b236A07cf122663c4303350609A66A7B288C0);
447 
448     uint256 public periodFinish;
449     uint256 public rewardRate;
450     uint256 public lastUpdateTime;
451     uint256 public rewardPerTokenStored;
452     mapping(address => uint256) public userRewardPerTokenPaid;
453     mapping(address => uint256) public rewards;
454 
455     event RewardAdded(uint256 reward);
456     event Staked(address indexed user, uint256 amount);
457     event Withdrawn(address indexed user, uint256 amount);
458     event RewardPaid(address indexed user, uint256 reward);
459 
460     modifier updateReward(address account) {
461         rewardPerTokenStored = rewardPerToken();
462         lastUpdateTime = lastTimeRewardApplicable();
463         if (account != address(0)) {
464             rewards[account] = earned(account);
465             userRewardPerTokenPaid[account] = rewardPerTokenStored;
466         }
467         _;
468     }
469 
470     function lastTimeRewardApplicable() public view returns (uint256) {
471         return Math.min(block.timestamp, periodFinish);
472     }
473 
474     function rewardPerToken() public view returns (uint256) {
475         if (totalSupply() == 0) {
476             return rewardPerTokenStored;
477         }
478         return
479             rewardPerTokenStored.add(
480                 lastTimeRewardApplicable()
481                     .sub(lastUpdateTime)
482                     .mul(rewardRate)
483                     .mul(1e18)
484                     .div(totalSupply())
485             );
486     }
487 
488     function earned(address account) public view returns (uint256) {
489         return
490             balanceOf(account)
491                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
492                 .div(1e18)
493                 .add(rewards[account])
494             ;
495     }
496 
497     // stake visibility is public as overriding LPTokenWrapper's stake() function
498     function stake(uint256 amount) public updateReward(msg.sender) {
499         require(amount > 0, "Cannot stake 0");
500         super.stake(amount);
501         emit Staked(msg.sender, amount);
502     }
503 
504     function withdraw(uint256 amount) public updateReward(msg.sender) {
505         require(amount > 0, "Cannot withdraw 0");
506         super.withdraw(amount);
507         emit Withdrawn(msg.sender, amount);
508     }
509 
510     function exit() external {
511         withdraw(balanceOf(msg.sender));
512         getReward();
513     }
514 
515     function getReward() public updateReward(msg.sender) {
516         uint256 reward = earned(msg.sender);
517         if (reward > 0) {
518             rewards[msg.sender] = 0;
519             ANT.safeTransfer(msg.sender, reward);
520             emit RewardPaid(msg.sender, reward);
521         }
522     }
523 
524     /**
525      * @dev This function must be triggered by the contribution token approve-and-call fallback.
526      *      It will update reward rate and time.
527      * @param _from Address of the original caller approving the tokens
528      * @param _amount Amount of reward tokens added to the pool
529      * @param _token Address of the token triggering the approve-and-call fallback
530      */
531     function receiveApproval(address _from, uint256 _amount, address _token, bytes calldata) external updateReward(address(0)) {
532         require(_amount > 0, "Cannot approve 0");
533         require(
534             _token == msg.sender && _token == address(ANT),
535             "Wrong token"
536         );
537 
538         if (block.timestamp >= periodFinish) {
539             rewardRate = _amount.div(DURATION);
540         } else {
541             uint256 remaining = periodFinish.sub(block.timestamp);
542             uint256 leftover = remaining.mul(rewardRate);
543             rewardRate = _amount.add(leftover).div(DURATION);
544         }
545         lastUpdateTime = block.timestamp;
546         periodFinish = block.timestamp.add(DURATION);
547 
548         ANT.safeTransferFrom(_from, address(this), _amount);
549 
550         emit RewardAdded(_amount);
551     }
552 }