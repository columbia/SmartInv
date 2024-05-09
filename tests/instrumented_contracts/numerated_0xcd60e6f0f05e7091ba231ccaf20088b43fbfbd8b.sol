1 pragma solidity ^0.6.0;
2 
3 /*
4  ___    ___ ________  ________     
5  |\  \  /  /|\_____  \|\   ___ \    
6  \ \  \/  / \|____|\ /\ \  \_|\ \   
7   \ \    / /      \|\  \ \  \ \\ \  
8    \/  /  /      __\_\  \ \  \_\\ \ 
9  __/  / /       |\_______\ \_______\
10 |\___/ /        \|_______|\|_______|
11 \|___|/                             
12                                     */
13 
14 // Unipool Contract Fork from Aragon
15 // https://etherscan.io/address/0xEA4D68CF86BcE59Bf2bFA039B97794ce2c43dEBC#code
16 
17 /**
18  * @dev Standard math utilities missing in the Solidity language.
19  */
20 library Math {
21     /**
22      * @dev Returns the largest of two numbers.
23      */
24     function max(uint256 a, uint256 b) internal pure returns (uint256) {
25         return a >= b ? a : b;
26     }
27 
28     /**
29      * @dev Returns the smallest of two numbers.
30      */
31     function min(uint256 a, uint256 b) internal pure returns (uint256) {
32         return a < b ? a : b;
33     }
34 }
35 
36 /**
37  * @dev Wrappers over Solidity's arithmetic operations with added overflow
38  * checks.
39  *
40  * Arithmetic operations in Solidity wrap on overflow. This can easily result
41  * in bugs, because programmers usually assume that an overflow raises an
42  * error, which is the standard behavior in high level programming languages.
43  * `SafeMath` restores this intuition by reverting the transaction when an
44  * operation overflows.
45  *
46  * Using this library instead of the unchecked operations eliminates an entire
47  * class of bugs, so it's recommended to use it always.
48  */
49 library SafeMath {
50     /**
51      * @dev Returns the addition of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `+` operator.
55      *
56      * Requirements:
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
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     /**
80      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
81      * overflow (when the result is negative).
82      *
83      * Counterpart to Solidity's `-` operator.
84      *
85      * Requirements:
86      * - Subtraction cannot overflow.
87      *
88      * _Available since v2.4.0._
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
104      * - Multiplication cannot overflow.
105      */
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
108         // benefit is lost if 'b' is also tested.
109         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers. Reverts on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator. Note: this function uses a
125      * `revert` opcode (which leaves remaining gas untouched) while Solidity
126      * uses an invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         return div(a, b, "SafeMath: division by zero");
133     }
134 
135     /**
136      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
137      * division by zero. The result is rounded towards zero.
138      *
139      * Counterpart to Solidity's `/` operator. Note: this function uses a
140      * `revert` opcode (which leaves remaining gas untouched) while Solidity
141      * uses an invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      *
146      * _Available since v2.4.0._
147      */
148     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         // Solidity only automatically asserts when dividing by 0
150         require(b != 0, errorMessage);
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
166      * - The divisor cannot be zero.
167      */
168     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
169         return mod(a, b, "SafeMath: modulo by zero");
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts with custom message when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      *
183      * _Available since v2.4.0._
184      */
185     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b != 0, errorMessage);
187         return a % b;
188     }
189 }
190 
191 /**
192  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
193  * the optional functions; to access them see {ERC20Detailed}.
194  */
195 interface IERC20 {
196     /**
197      * @dev Returns the amount of tokens in existence.
198      */
199     function totalSupply() external view returns (uint256);
200 
201     /**
202      * @dev Returns the amount of tokens owned by `account`.
203      */
204     function balanceOf(address account) external view returns (uint256);
205 
206     /**
207      * @dev Moves `amount` tokens from the caller's account to `recipient`.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transfer(address recipient, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Returns the remaining number of tokens that `spender` will be
217      * allowed to spend on behalf of `owner` through {transferFrom}. This is
218      * zero by default.
219      *
220      * This value changes when {approve} or {transferFrom} are called.
221      */
222     function allowance(address owner, address spender) external view returns (uint256);
223 
224     /**
225      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * IMPORTANT: Beware that changing an allowance with this method brings the risk
230      * that someone may use both the old and the new allowance by unfortunate
231      * transaction ordering. One possible solution to mitigate this race
232      * condition is to first reduce the spender's allowance to 0 and set the
233      * desired value afterwards:
234      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235      *
236      * Emits an {Approval} event.
237      */
238     function approve(address spender, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Moves `amount` tokens from `sender` to `recipient` using the
242      * allowance mechanism. `amount` is then deducted from the caller's
243      * allowance.
244      *
245      * Returns a boolean value indicating whether the operation succeeded.
246      *
247      * Emits a {Transfer} event.
248      */
249     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Emitted when `value` tokens are moved from one account (`from`) to
253      * another (`to`).
254      *
255      * Note that `value` may be zero.
256      */
257     event Transfer(address indexed from, address indexed to, uint256 value);
258 
259     /**
260      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
261      * a call to {approve}. `value` is the new allowance.
262      */
263     event Approval(address indexed owner, address indexed spender, uint256 value);
264 }
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following 
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
289         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
290         // for accounts without code, i.e. `keccak256('')`
291         bytes32 codehash;
292         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { codehash := extcodehash(account) }
295         return (codehash != accountHash && codehash != 0x0);
296     }
297 
298     /**
299      * @dev Converts an `address` into `address payable`. Note that this is
300      * simply a type cast: the actual underlying value is not changed.
301      *
302      * _Available since v2.4.0._
303      */
304     function toPayable(address account) internal pure returns (address payable) {
305         return address(uint160(account));
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      *
324      * _Available since v2.4.0._
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         // solhint-disable-next-line avoid-call-value
330         (bool success, ) = recipient.call.value(amount)("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 }
334 
335 /**
336  * @title SafeERC20
337  * @dev Wrappers around ERC20 operations that throw on failure (when the token
338  * contract returns false). Tokens that return no value (and instead revert or
339  * throw on failure) are also supported, non-reverting calls are assumed to be
340  * successful.
341  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
342  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
343  */
344 library SafeERC20 {
345     using SafeMath for uint256;
346     using Address for address;
347 
348     function safeTransfer(IERC20 token, address to, uint256 value) internal {
349         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
350     }
351 
352     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
353         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
354     }
355 
356     function safeApprove(IERC20 token, address spender, uint256 value) internal {
357         // safeApprove should only be called when setting an initial allowance,
358         // or when resetting it to zero. To increase and decrease it, use
359         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
360         // solhint-disable-next-line max-line-length
361         require((value == 0) || (token.allowance(address(this), spender) == 0),
362             "SafeERC20: approve from non-zero to non-zero allowance"
363         );
364         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
365     }
366 
367     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
368         uint256 newAllowance = token.allowance(address(this), spender).add(value);
369         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
370     }
371 
372     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
373         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
374         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
375     }
376 
377     /**
378      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
379      * on the return value: the return value is optional (but if data is returned, it must not be false).
380      * @param token The token targeted by the call.
381      * @param data The call data (encoded using abi.encode or one of its variants).
382      */
383     function callOptionalReturn(IERC20 token, bytes memory data) private {
384         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
385         // we're implementing it ourselves.
386 
387         // A Solidity high level call has three parts:
388         //  1. The target address is checked to verify it contains contract code
389         //  2. The call itself is made, and success asserted
390         //  3. The return value is decoded, which in turn checks the size of the returned data.
391         // solhint-disable-next-line max-line-length
392         require(address(token).isContract(), "SafeERC20: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = address(token).call(data);
396         require(success, "SafeERC20: low-level call failed");
397 
398         if (returndata.length > 0) { // Return data is optional
399             // solhint-disable-next-line max-line-length
400             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
401         }
402     }
403 }
404 
405 contract LPTokenWrapper {
406     using SafeMath for uint256;
407     using SafeERC20 for IERC20;
408 
409     IERC20 public constant LPT = IERC20(0xCd4079b9713CdD1e629492B9c07Ebd0dbD9F5202); // Uniswap y3d-yyCrv LP Token
410 
411     uint256 public _totalSupply;
412     mapping(address => uint256) public _balances;
413 
414     uint256 public _profitPerShare; // x 1e18, monotonically increasing.
415     mapping(address => uint256) public _unrealized; // x 1e18
416     mapping(address => uint256) public _realized; // last paid _profitPerShare
417     event LPTPaid(address indexed user, uint256 profit);
418 
419     function totalSupply() public view returns (uint256) {
420         return _totalSupply;
421     }
422 
423     function balanceOf(address account) public view returns (uint256) {
424         return _balances[account];
425     }
426 
427     function unrealizedProfit(address account) public view returns (uint256) {
428         return _unrealized[account].add(_balances[account].mul(_profitPerShare.sub(_realized[account])).div(1e18));
429     }    
430 
431     function make_profit(uint256 amount) internal {
432         _profitPerShare = _profitPerShare.add(amount.mul(1e18).div(totalSupply()));        
433     }
434 
435     modifier update(address account) {
436         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
437         // really i know you think you do but you don't
438         // https://etherscan.io/address/0xb3775fb83f7d12a36e0475abdd1fca35c091efbe#code
439         if (account != address(0)) {
440             _unrealized[account] = unrealizedProfit(account);
441             _realized[account] = _profitPerShare;
442         }
443         _;
444     }    
445 
446     function stake(uint256 amount) update(msg.sender) public virtual {
447         _totalSupply = _totalSupply.add(amount);
448         _balances[msg.sender] = _balances[msg.sender].add(amount);
449         LPT.safeTransferFrom(msg.sender, address(this), amount);
450     }
451 
452     function withdraw(uint256 amount) update(msg.sender) public virtual {
453         _totalSupply = _totalSupply.sub(amount);
454         _balances[msg.sender] = _balances[msg.sender].sub(amount);
455         uint256 tax = amount.div(20);
456         amount = amount.sub(tax);
457         LPT.safeTransfer(msg.sender, amount);
458         make_profit(tax);
459     }
460 
461     function claim() update(msg.sender) public {
462         uint256 profit = _unrealized[msg.sender];
463         if (profit != 0) {
464             _unrealized[msg.sender] = 0;
465             LPT.safeTransfer(msg.sender, profit);
466             emit LPTPaid(msg.sender, profit);
467         }
468     }
469 }
470 
471 contract y3dUniPool is LPTokenWrapper {
472     uint256 public DURATION = 30 days;
473     uint256 public periodFinish;
474     uint256 public rewardRate;
475     uint256 public lastUpdateTime;
476     uint256 public rewardPerTokenStored;
477 
478     mapping(address => uint256) public userRewardPerTokenPaid;
479     mapping(address => uint256) public rewards;
480 
481     event RewardAdded(uint256 reward);
482     event Staked(address indexed user, uint256 amount);
483     event Withdrawn(address indexed user, uint256 amount);
484     event RewardPaid(address indexed user, uint256 reward);
485 
486     IERC20 constant public Y3D = IERC20(0xc7fD9aE2cf8542D71186877e21107E1F3A0b55ef);
487 
488     constructor() public {
489         _balances[msg.sender] = 1; // avoid divided by 0
490         _totalSupply = 1;
491     }
492 
493     modifier updateReward(address account) {
494         rewardPerTokenStored = rewardPerToken();
495         lastUpdateTime = lastTimeRewardApplicable();
496         if (account != address(0)) {
497             rewards[account] = earned(account);
498             userRewardPerTokenPaid[account] = rewardPerTokenStored;
499         }
500         _;
501     }
502 
503     function lastTimeRewardApplicable() public view returns (uint256) {
504         return Math.min(block.timestamp, periodFinish);
505     }
506 
507     function rewardPerToken() public view returns (uint256) {
508         return
509             rewardPerTokenStored.add(
510                 lastTimeRewardApplicable()
511                     .sub(lastUpdateTime)
512                     .mul(rewardRate)
513                     .mul(1e18)
514                     .div(totalSupply())
515             );
516     }
517 
518     function earned(address account) public view returns (uint256) {
519         return
520             balanceOf(account)
521                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
522                 .div(1e18)
523                 .add(rewards[account])
524             ;
525     }
526 
527     // stake visibility is public as overriding LPTokenWrapper's stake() function
528     function stake(uint256 amount) public override updateReward(msg.sender) {
529         require(amount != 0, "Cannot stake 0");
530         super.stake(amount);
531         emit Staked(msg.sender, amount);
532     }
533 
534     function withdraw(uint256 amount) public override updateReward(msg.sender) {
535         require(amount != 0, "Cannot withdraw 0");
536         super.withdraw(amount);
537         emit Withdrawn(msg.sender, amount);
538     }
539 
540     function exit() external {
541         withdraw(balanceOf(msg.sender));
542         getReward();
543         claim();
544     }
545 
546     function getReward() public updateReward(msg.sender) {
547         uint256 reward = earned(msg.sender);
548         if (reward != 0) {
549             rewards[msg.sender] = 0;
550             Y3D.safeTransfer(msg.sender, reward);
551             emit RewardPaid(msg.sender, reward);
552         }
553     }
554 
555     /**
556      * @dev This function must be triggered by the contribution token approve-and-call fallback.
557      *      It will update reward rate and time.
558      * @param _amount Amount of reward tokens added to the pool
559      */
560     function receiveApproval(uint256 _amount) external updateReward(address(0)) {
561         require(_amount != 0, "Cannot approve 0");
562 
563         if (block.timestamp >= periodFinish) {
564             rewardRate = _amount.div(DURATION);
565         } else {
566             uint256 remaining = periodFinish.sub(block.timestamp);
567             uint256 leftover = remaining.mul(rewardRate);
568             rewardRate = _amount.add(leftover).div(DURATION);
569         }
570         lastUpdateTime = block.timestamp;
571         periodFinish = block.timestamp.add(DURATION);
572 
573         Y3D.safeTransferFrom(msg.sender, address(this), _amount);
574         emit RewardAdded(_amount);
575     }
576 }