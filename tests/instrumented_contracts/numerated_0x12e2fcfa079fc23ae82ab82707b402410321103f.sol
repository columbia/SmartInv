1 pragma solidity ^0.5.0;
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
34 
35     /**
36      * @dev Returns the average of two numbers. The result is rounded towards
37      * zero.
38      */
39     function average(uint256 a, uint256 b) internal pure returns (uint256) {
40         // (a + b) / 2 can overflow, so we distribute
41         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
42     }
43 }
44 
45 /**
46  * @dev Wrappers over Solidity's arithmetic operations with added overflow
47  * checks.
48  *
49  * Arithmetic operations in Solidity wrap on overflow. This can easily result
50  * in bugs, because programmers usually assume that an overflow raises an
51  * error, which is the standard behavior in high level programming languages.
52  * `SafeMath` restores this intuition by reverting the transaction when an
53  * operation overflows.
54  *
55  * Using this library instead of the unchecked operations eliminates an entire
56  * class of bugs, so it's recommended to use it always.
57  */
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `+` operator.
64      *
65      * Requirements:
66      * - Addition cannot overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
90      * overflow (when the result is negative).
91      *
92      * Counterpart to Solidity's `-` operator.
93      *
94      * Requirements:
95      * - Subtraction cannot overflow.
96      *
97      * _Available since v2.4.0._
98      */
99     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117         // benefit is lost if 'b' is also tested.
118         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return div(a, b, "SafeMath: division by zero");
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      * - The divisor cannot be zero.
154      *
155      * _Available since v2.4.0._
156      */
157     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         // Solidity only automatically asserts when dividing by 0
159         require(b != 0, errorMessage);
160         uint256 c = a / b;
161         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return mod(a, b, "SafeMath: modulo by zero");
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts with custom message when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      *
192      * _Available since v2.4.0._
193      */
194     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b != 0, errorMessage);
196         return a % b;
197     }
198 }
199 
200 /**
201  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
202  * the optional functions; to access them see {ERC20Detailed}.
203  */
204 interface IERC20 {
205     /**
206      * @dev Returns the amount of tokens in existence.
207      */
208     function totalSupply() external view returns (uint256);
209 
210     /**
211      * @dev Returns the amount of tokens owned by `account`.
212      */
213     function balanceOf(address account) external view returns (uint256);
214 
215     /**
216      * @dev Moves `amount` tokens from the caller's account to `recipient`.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transfer(address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Returns the remaining number of tokens that `spender` will be
226      * allowed to spend on behalf of `owner` through {transferFrom}. This is
227      * zero by default.
228      *
229      * This value changes when {approve} or {transferFrom} are called.
230      */
231     function allowance(address owner, address spender) external view returns (uint256);
232 
233     /**
234      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * IMPORTANT: Beware that changing an allowance with this method brings the risk
239      * that someone may use both the old and the new allowance by unfortunate
240      * transaction ordering. One possible solution to mitigate this race
241      * condition is to first reduce the spender's allowance to 0 and set the
242      * desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address spender, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Moves `amount` tokens from `sender` to `recipient` using the
251      * allowance mechanism. `amount` is then deducted from the caller's
252      * allowance.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Emitted when `value` tokens are moved from one account (`from`) to
262      * another (`to`).
263      *
264      * Note that `value` may be zero.
265      */
266     event Transfer(address indexed from, address indexed to, uint256 value);
267 
268     /**
269      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
270      * a call to {approve}. `value` is the new allowance.
271      */
272     event Approval(address indexed owner, address indexed spender, uint256 value);
273 }
274 
275 interface ICrvDeposit{
276     function deposit(uint256) external;
277     function withdraw(uint256) external;
278     function balanceOf(address) external view returns (uint256);
279     function claimable_tokens(address) external view returns (uint256);
280 }
281 
282 interface ICrvMinter{
283     function mint(address) external;
284 }
285 
286 /**
287  * @dev Collection of functions related to the address type
288  */
289 library Address {
290     /**
291      * @dev Returns true if `account` is a contract.
292      *
293      * [IMPORTANT]
294      * ====
295      * It is unsafe to assume that an address for which this function returns
296      * false is an externally-owned account (EOA) and not a contract.
297      *
298      * Among others, `isContract` will return false for the following 
299      * types of addresses:
300      *
301      *  - an externally-owned account
302      *  - a contract in construction
303      *  - an address where a contract will be created
304      *  - an address where a contract lived, but was destroyed
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
309         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
310         // for accounts without code, i.e. `keccak256('')`
311         bytes32 codehash;
312         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
313         // solhint-disable-next-line no-inline-assembly
314         assembly { codehash := extcodehash(account) }
315         return (codehash != accountHash && codehash != 0x0);
316     }
317 
318     /**
319      * @dev Converts an `address` into `address payable`. Note that this is
320      * simply a type cast: the actual underlying value is not changed.
321      *
322      * _Available since v2.4.0._
323      */
324     function toPayable(address account) internal pure returns (address payable) {
325         return address(uint160(account));
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      *
344      * _Available since v2.4.0._
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         // solhint-disable-next-line avoid-call-value
350         (bool success, ) = recipient.call.value(amount)("");
351         require(success, "Address: unable to send value, recipient may have reverted");
352     }
353 }
354 
355 /**
356  * @title SafeERC20
357  * @dev Wrappers around ERC20 operations that throw on failure (when the token
358  * contract returns false). Tokens that return no value (and instead revert or
359  * throw on failure) are also supported, non-reverting calls are assumed to be
360  * successful.
361  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
362  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
363  */
364 library SafeERC20 {
365     using SafeMath for uint256;
366     using Address for address;
367 
368     function safeTransfer(IERC20 token, address to, uint256 value) internal {
369         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
370     }
371 
372     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
373         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
374     }
375 
376     function safeApprove(IERC20 token, address spender, uint256 value) internal {
377         // safeApprove should only be called when setting an initial allowance,
378         // or when resetting it to zero. To increase and decrease it, use
379         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
380         // solhint-disable-next-line max-line-length
381         require((value == 0) || (token.allowance(address(this), spender) == 0),
382             "SafeERC20: approve from non-zero to non-zero allowance"
383         );
384         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
385     }
386 
387     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
388         uint256 newAllowance = token.allowance(address(this), spender).add(value);
389         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
390     }
391 
392     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
393         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
394         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
395     }
396 
397     /**
398      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
399      * on the return value: the return value is optional (but if data is returned, it must not be false).
400      * @param token The token targeted by the call.
401      * @param data The call data (encoded using abi.encode or one of its variants).
402      */
403     function callOptionalReturn(IERC20 token, bytes memory data) private {
404         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
405         // we're implementing it ourselves.
406 
407         // A Solidity high level call has three parts:
408         //  1. The target address is checked to verify it contains contract code
409         //  2. The call itself is made, and success asserted
410         //  3. The return value is decoded, which in turn checks the size of the returned data.
411         // solhint-disable-next-line max-line-length
412         require(address(token).isContract(), "SafeERC20: call to non-contract");
413 
414         // solhint-disable-next-line avoid-low-level-calls
415         (bool success, bytes memory returndata) = address(token).call(data);
416         require(success, "SafeERC20: low-level call failed");
417 
418         if (returndata.length > 0) { // Return data is optional
419             // solhint-disable-next-line max-line-length
420             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
421         }
422     }
423 }
424 
425 contract LPTokenWrapper {
426     using SafeMath for uint256;
427     using SafeERC20 for IERC20;
428 
429     IERC20 public constant LPT = IERC20(0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8); // yCrv
430     IERC20 constant public CRV = IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52);
431     address constant public crv_deposit = address(0xFA712EE4788C042e2B7BB55E6cb8ec569C4530c1);
432     address constant public crv_minter = address(0xd061D61a4d941c39E5453435B6345Dc261C2fcE0);
433     address public crv_manager = address(0x6465F1250c9fe162602Db83791Fc3Fb202D70a7B);    
434 
435     uint256 public _totalSupply;
436     mapping(address => uint256) public _balances;
437 
438     uint256 public _pool;
439     uint256 public _profitPerShare; // x 1e18, monotonically increasing.
440     mapping(address => uint256) public _unrealized; // x 1e18
441     mapping(address => uint256) public _realized; // last paid _profitPerShare
442     bool public exodus;
443     event LPTPaid(address indexed user, uint256 profit);
444 
445     function totalSupply() public view returns (uint256) {
446         return _totalSupply;
447     }
448 
449     function balanceOf(address account) public view returns (uint256) {
450         return _balances[account];
451     }
452 
453     function unrealizedProfit(address account) public view returns (uint256) {
454         return _unrealized[account].add(_balances[account].mul(_profitPerShare.sub(_realized[account])).div(1e18));
455     }    
456 
457     function make_profit(uint256 amount) internal {
458         _profitPerShare = _profitPerShare.add(amount.mul(1e18).div(totalSupply()));        
459     }
460 
461     modifier update(address account) {
462         // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
463         // really i know you think you do but you don't
464         // https://etherscan.io/address/0xb3775fb83f7d12a36e0475abdd1fca35c091efbe#code
465         if (account != address(0)) {
466             _unrealized[account] = unrealizedProfit(account);
467             _realized[account] = _profitPerShare;
468         }
469         _;
470     }    
471 
472     function stake(uint256 amount) update(msg.sender) public {
473         _totalSupply = _totalSupply.add(amount);
474         _balances[msg.sender] = _balances[msg.sender].add(amount);
475         LPT.safeTransferFrom(msg.sender, address(this), amount);
476     }
477 
478     function withdraw(uint256 amount) update(msg.sender) public {
479         _totalSupply = _totalSupply.sub(amount);
480         _balances[msg.sender] = _balances[msg.sender].sub(amount);
481         uint256 tax = amount.div(20); if (exodus == true) tax = 0;
482         amount = amount.sub(tax);
483         if (amount > LPT.balanceOf(address(this))) ICrvDeposit(crv_deposit).withdraw(amount - LPT.balanceOf(address(this)));
484         LPT.safeTransfer(msg.sender, amount);
485         make_profit(tax);
486     }
487 
488     function claim() update(msg.sender) public {
489         uint256 profit = _unrealized[msg.sender];
490         if (profit != 0) {
491             _unrealized[msg.sender] = 0;
492             LPT.safeTransfer(msg.sender, profit);
493             emit LPTPaid(msg.sender, profit);
494         }
495     }
496 }
497 
498 contract y3dPool is LPTokenWrapper {
499     uint256 public DURATION = 30 days;
500     uint256 public periodFinish;
501     uint256 public rewardRate;
502     uint256 public lastUpdateTime;
503     uint256 public rewardPerTokenStored;
504 
505     mapping(address => uint256) public userRewardPerTokenPaid;
506     mapping(address => uint256) public rewards;
507 
508     event RewardAdded(uint256 reward);
509     event Staked(address indexed user, uint256 amount);
510     event Withdrawn(address indexed user, uint256 amount);
511     event RewardPaid(address indexed user, uint256 reward);
512 
513     IERC20 constant public Y3D = IERC20(0xc7fD9aE2cf8542D71186877e21107E1F3A0b55ef);
514 
515     constructor() public {
516         _balances[msg.sender] = 1; // avoid divided by 0
517         _totalSupply = 1;
518         LPT.approve(crv_deposit, uint(-1));
519     }
520 
521     modifier updateReward(address account) {
522         rewardPerTokenStored = rewardPerToken();
523         lastUpdateTime = lastTimeRewardApplicable();
524         if (account != address(0)) {
525             rewards[account] = earned(account);
526             userRewardPerTokenPaid[account] = rewardPerTokenStored;
527         }
528         _;
529     }
530 
531     function lastTimeRewardApplicable() public view returns (uint256) {
532         return Math.min(block.timestamp, periodFinish);
533     }
534 
535     function rewardPerToken() public view returns (uint256) {
536         return
537             rewardPerTokenStored.add(
538                 lastTimeRewardApplicable()
539                     .sub(lastUpdateTime)
540                     .mul(rewardRate)
541                     .mul(1e18)
542                     .div(totalSupply())
543             );
544     }
545 
546     function earned(address account) public view returns (uint256) {
547         return
548             balanceOf(account)
549                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
550                 .div(1e18)
551                 .add(rewards[account])
552             ;
553     }
554 
555     // stake visibility is public as overriding LPTokenWrapper's stake() function
556     function stake(uint256 amount) public updateReward(msg.sender) {
557         require(amount != 0, "Cannot stake 0");
558         super.stake(amount);
559         emit Staked(msg.sender, amount);
560     }
561 
562     function withdraw(uint256 amount) public updateReward(msg.sender) {
563         require(amount != 0, "Cannot withdraw 0");
564         super.withdraw(amount);
565         emit Withdrawn(msg.sender, amount);
566     }
567 
568     function exit() external {
569         withdraw(balanceOf(msg.sender));
570         getReward();
571         claim();
572     }
573 
574     function getReward() public updateReward(msg.sender) {
575         uint256 reward = earned(msg.sender);
576         if (reward != 0) {
577             rewards[msg.sender] = 0;
578             Y3D.safeTransfer(msg.sender, reward);
579             emit RewardPaid(msg.sender, reward);
580         }
581     }
582 
583     // Todo(minakokojima): manager should be a contract, automatic buy in and burn Y3D.
584     function change_crv_manager(address new_manager) public {
585         require(msg.sender == crv_manager, 'only current manager');
586         crv_manager = new_manager;
587     }
588 
589     function invest() public {
590         ICrvDeposit(crv_deposit).deposit(LPT.balanceOf(address(this)));
591     }
592 
593     function harvest() public {
594         ICrvMinter(crv_minter).mint(crv_deposit);
595         CRV.transfer(crv_manager, CRV.balanceOf(address(this)));
596     }
597 
598     function theExodus() public {
599         require(msg.sender == crv_manager, 'only current manager');
600         exodus = !exodus;
601     }
602 
603     /**
604      * @dev This function must be triggered by the contribution token approve-and-call fallback.
605      *      It will update reward rate and time.
606      * @param _amount Amount of reward tokens added to the pool
607      */
608     function receiveApproval(uint256 _amount) external updateReward(address(0)) {
609         require(_amount != 0, "Cannot approve 0");
610 
611         if (block.timestamp >= periodFinish) {
612             rewardRate = _amount.div(DURATION);
613         } else {
614             uint256 remaining = periodFinish.sub(block.timestamp);
615             uint256 leftover = remaining.mul(rewardRate);
616             rewardRate = _amount.add(leftover).div(DURATION);
617         }
618         lastUpdateTime = block.timestamp;
619         periodFinish = block.timestamp.add(DURATION);
620 
621         Y3D.safeTransferFrom(msg.sender, address(this), _amount);
622         emit RewardAdded(_amount);
623     }
624 }