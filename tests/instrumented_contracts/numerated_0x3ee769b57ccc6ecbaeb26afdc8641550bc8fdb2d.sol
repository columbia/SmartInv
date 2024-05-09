1 /***
2  *    ██████╗ ███████╗ ██████╗  ██████╗ 
3  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
4  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
5  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
6  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
7  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
8  *    
9  * https://dego.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 dego
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */// File: @openzeppelin/contracts/math/SafeMath.sol
33 
34 pragma solidity ^0.5.0;
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
191 // File: @openzeppelin/contracts/utils/Address.sol
192 
193 pragma solidity ^0.5.5;
194 
195 /**
196  * @dev Collection of functions related to the address type
197  */
198 library Address {
199     /**
200      * @dev Returns true if `account` is a contract.
201      *
202      * [IMPORTANT]
203      * ====
204      * It is unsafe to assume that an address for which this function returns
205      * false is an externally-owned account (EOA) and not a contract.
206      *
207      * Among others, `isContract` will return false for the following 
208      * types of addresses:
209      *
210      *  - an externally-owned account
211      *  - a contract in construction
212      *  - an address where a contract will be created
213      *  - an address where a contract lived, but was destroyed
214      * ====
215      */
216     function isContract(address account) internal view returns (bool) {
217         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
218         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
219         // for accounts without code, i.e. `keccak256('')`
220         bytes32 codehash;
221         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
222         // solhint-disable-next-line no-inline-assembly
223         assembly { codehash := extcodehash(account) }
224         return (codehash != accountHash && codehash != 0x0);
225     }
226 
227     /**
228      * @dev Converts an `address` into `address payable`. Note that this is
229      * simply a type cast: the actual underlying value is not changed.
230      *
231      * _Available since v2.4.0._
232      */
233     function toPayable(address account) internal pure returns (address payable) {
234         return address(uint160(account));
235     }
236 
237     /**
238      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
239      * `recipient`, forwarding all available gas and reverting on errors.
240      *
241      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
242      * of certain opcodes, possibly making contracts go over the 2300 gas limit
243      * imposed by `transfer`, making them unable to receive funds via
244      * `transfer`. {sendValue} removes this limitation.
245      *
246      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
247      *
248      * IMPORTANT: because control is transferred to `recipient`, care must be
249      * taken to not create reentrancy vulnerabilities. Consider using
250      * {ReentrancyGuard} or the
251      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
252      *
253      * _Available since v2.4.0._
254      */
255     function sendValue(address payable recipient, uint256 amount) internal {
256         require(address(this).balance >= amount, "Address: insufficient balance");
257 
258         // solhint-disable-next-line avoid-call-value
259         (bool success, ) = recipient.call.value(amount)("");
260         require(success, "Address: unable to send value, recipient may have reverted");
261     }
262 }
263 
264 // File: contracts/interface/IERC20.sol
265 
266 pragma solidity ^0.5.0;
267 
268 /**
269  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
270  * the optional functions; to access them see {ERC20Detailed}.
271  */
272 interface IERC20 {
273     /**
274      * @dev Returns the amount of tokens in existence.
275      */
276     function totalSupply() external view returns (uint256);
277 
278     /**
279      * @dev Returns the amount of tokens owned by `account`.
280      */
281     function balanceOf(address account) external view returns (uint256);
282 
283     /**
284      * @dev Moves `amount` tokens from the caller's account to `recipient`.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * Emits a {Transfer} event.
289      */
290     function transfer(address recipient, uint256 amount) external returns (bool);
291     function mint(address account, uint amount) external;
292     /**
293      * @dev Returns the remaining number of tokens that `spender` will be
294      * allowed to spend on behalf of `owner` through {transferFrom}. This is
295      * zero by default.
296      *
297      * This value changes when {approve} or {transferFrom} are called.
298      */
299     function allowance(address owner, address spender) external view returns (uint256);
300 
301     /**
302      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * IMPORTANT: Beware that changing an allowance with this method brings the risk
307      * that someone may use both the old and the new allowance by unfortunate
308      * transaction ordering. One possible solution to mitigate this race
309      * condition is to first reduce the spender's allowance to 0 and set the
310      * desired value afterwards:
311      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312      *
313      * Emits an {Approval} event.
314      */
315     function approve(address spender, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Moves `amount` tokens from `sender` to `recipient` using the
319      * allowance mechanism. `amount` is then deducted from the caller's
320      * allowance.
321      *
322      * Returns a boolean value indicating whether the operation succeeded.
323      *
324      * Emits a {Transfer} event.
325      */
326     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
327 
328     /**
329      * @dev Emitted when `value` tokens are moved from one account (`from`) to
330      * another (`to`).
331      *
332      * Note that `value` may be zero.
333      */
334     event Transfer(address indexed from, address indexed to, uint256 value);
335 
336     /**
337      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
338      * a call to {approve}. `value` is the new allowance.
339      */
340     event Approval(address indexed owner, address indexed spender, uint256 value);
341 }
342 
343 // File: contracts/library/SafeERC20.sol
344 
345 pragma solidity ^0.5.0;
346 
347 
348 
349 
350 
351 /**
352  * @title SafeERC20
353  * @dev Wrappers around ERC20 operations that throw on failure (when the token
354  * contract returns false). Tokens that return no value (and instead revert or
355  * throw on failure) are also supported, non-reverting calls are assumed to be
356  * successful.
357  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
358  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
359  */
360 library SafeERC20 {
361     using SafeMath for uint256;
362     using Address for address;
363 
364     function safeTransfer(IERC20 token, address to, uint256 value) internal {
365         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
366     }
367 
368     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
369         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
370     }
371 
372     function safeApprove(IERC20 token, address spender, uint256 value) internal {
373         // safeApprove should only be called when setting an initial allowance,
374         // or when resetting it to zero. To increase and decrease it, use
375         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
376         // solhint-disable-next-line max-line-length
377         require((value == 0) || (token.allowance(address(this), spender) == 0),
378             "SafeERC20: approve from non-zero to non-zero allowance"
379         );
380         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
381     }
382 
383     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
384         uint256 newAllowance = token.allowance(address(this), spender).add(value);
385         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
386     }
387 
388     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
389         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
390         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
391     }
392 
393     /**
394      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
395      * on the return value: the return value is optional (but if data is returned, it must not be false).
396      * @param token The token targeted by the call.
397      * @param data The call data (encoded using abi.encode or one of its variants).
398      */
399     function callOptionalReturn(IERC20 token, bytes memory data) private {
400         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
401         // we're implementing it ourselves.
402 
403         // A Solidity high level call has three parts:
404         //  1. The target address is checked to verify it contains contract code
405         //  2. The call itself is made, and success asserted
406         //  3. The return value is decoded, which in turn checks the size of the returned data.
407         // solhint-disable-next-line max-line-length
408         require(address(token).isContract(), "SafeERC20: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = address(token).call(data);
412         require(success, "SafeERC20: low-level call failed");
413 
414         if (returndata.length > 0) { // Return data is optional
415             // solhint-disable-next-line max-line-length
416             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
417         }
418     }
419 }
420 
421 // File: contracts/library/Governance.sol
422 
423 pragma solidity ^0.5.0;
424 
425 contract Governance {
426 
427     address public _governance;
428 
429     constructor() public {
430         _governance = tx.origin;
431     }
432 
433     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
434 
435     modifier onlyGovernance {
436         require(msg.sender == _governance, "not governance");
437         _;
438     }
439 
440     function setGovernance(address governance)  public  onlyGovernance
441     {
442         require(governance != address(0), "new governance the zero address");
443         emit GovernanceTransferred(_governance, governance);
444         _governance = governance;
445     }
446 
447 
448 }
449 
450 // File: contracts/airdrop/DegoTokenAirDrop.sol
451 
452 pragma solidity ^0.5.5;
453 
454 
455 
456 
457 
458 
459 
460 /// @title DegoToken Contract
461 
462 contract DegoTokenAirDrop is Governance{
463 
464     using SafeMath for uint256;
465     using SafeERC20 for IERC20;
466 
467     //events
468     event Mint(address indexed to, uint256 value);
469 
470     //token base data
471     uint256 internal _allGotBalances;
472     mapping(address => uint256) public _gotBalances;
473 
474     //airdrop info
475     uint256 public _startTime =  now;
476     /// Constant token specific fields
477     uint256 public _rewardRate1 = 2000;
478     uint256 public _rewardRate2 = 8000;
479     uint256 public _rewardDurationTime = 100 days;
480     uint256 public _baseRate = 10000;
481     
482     mapping (address => uint256) public _whitelist;
483     mapping (address => uint256) public _lastRewardTimes;
484 
485     IERC20 public _dego = IERC20(0x0);
486 
487     /**
488      * CONSTRUCTOR
489      *
490      * @dev Initialize the Contract
491     * @param dego The address to send dego.
492      */
493     constructor (address dego) public {
494          _dego = IERC20(dego);
495          _startTime = now;
496     }
497 
498 
499     /**
500     * @dev have Got the balance of the specified address.
501     * @param account The address to query the the gotbalance of.
502     * @return An uint256 representing the amount owned by the passed address.
503     */
504     function gotBalanceOf(address account) external  view 
505     returns (uint256) 
506     {
507         return _gotBalances[account];
508     }
509 
510 
511     /**
512     * @dev return the token total supply
513     */
514     function allGotBalances() external view 
515     returns (uint256) 
516     {
517         return _allGotBalances;
518     }
519 
520     
521     /**
522     * @dev for mint function
523     * @param account The address to get the reward.
524     * @param amount The amount of the reward.
525     */
526     function _mint(address account, uint256 amount) internal 
527     {
528         require(account != address(0), "ERC20: mint to the zero address");
529         require(_whitelist[account] > 0, "must in whitelist");
530         
531         _allGotBalances = _allGotBalances.add(amount);      
532         _gotBalances[account] = _gotBalances[account].add(amount);
533 
534         _dego.mint(account, amount);
535         emit Mint(account, amount);
536     }
537     
538     /**
539     * @dev set the dego contract address
540     * @param dego Set the dego
541     */
542    function setDego(address dego)
543         external
544         onlyGovernance
545    {
546         require(dego != address(0), "dego is zero address");
547         _dego = IERC20(dego);
548     }
549 
550 
551     /**
552     * @dev set the whitelist
553     * @param account Set the account to whitelist
554     * @param amount the amount of reward.
555     */
556     function setWhitelist(address account, uint256 amount)
557         public
558         onlyGovernance
559    {
560        require(account != address(0), "account is zero address");
561        if(amount > 0){
562            require(_whitelist[account] == 0, "account already exists");
563        }
564        _whitelist[account] = amount;
565     }
566     
567 
568 
569     function addWhitelist(address[] calldata account,  uint256[] calldata value)
570         external
571         onlyGovernance
572     {
573         require(account.length == value.length, "wrong argument");
574         for (uint256 i = 0; i < account.length; i++) {
575             setWhitelist(account[i], value[i]);
576         }
577     }
578     
579     /**
580     * @dev get reward
581     */
582    function getReward() public
583    {
584         uint256 reward = earned(msg.sender);
585         require(reward > 0, "must > 0");
586         require(reward.add(_gotBalances[msg.sender]) <= _whitelist[msg.sender], "You've got too many awards!!!");
587         _mint(msg.sender, reward);
588         _lastRewardTimes[msg.sender] = block.timestamp;
589     }
590 
591 
592     /**
593     * @dev  Calculate and reuturn Unclaimed rewards 
594     */
595    function earned(address account) public view returns (uint256) 
596    {
597         require(_whitelist[account] > 0, "must in whitelist");
598 
599         uint256 reward = 0;
600         uint256 accountTotal = _whitelist[account];
601         uint256 rewardPerSecond = accountTotal.mul(_rewardRate2).div(_baseRate).div(_rewardDurationTime);
602         uint256 lastRewardTime = _lastRewardTimes[account];
603 
604         // fist time get 20%
605         if( lastRewardTime == 0 ){
606             uint256 reward1 = accountTotal.mul(_rewardRate1).div(_baseRate);
607             uint256 durationTime = block.timestamp.sub(_startTime);
608             uint256 reward2 = durationTime.mul(rewardPerSecond);
609             reward = reward1 + reward2;
610             return reward;
611         }
612         
613         uint256 durationTime = block.timestamp.sub(lastRewardTime);
614         reward = durationTime.mul(rewardPerSecond);
615         return reward;
616    }
617 }