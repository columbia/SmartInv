1 /*
2  *
3  ██████╗  ██████╗ ██╗     ██████╗     ██╗  ██╗ ██████╗ ███████╗     ██████╗ ███╗   ██╗███████╗
4 ██╔════╝ ██╔═══██╗██║     ██╔══██╗    ██║  ██║██╔═══██╗██╔════╝    ██╔═══██╗████╗  ██║██╔════╝
5 ██║  ███╗██║   ██║██║     ██║  ██║    ███████║██║   ██║█████╗      ██║   ██║██╔██╗ ██║█████╗  
6 ██║   ██║██║   ██║██║     ██║  ██║    ██╔══██║██║   ██║██╔══╝      ██║   ██║██║╚██╗██║██╔══╝  
7 ╚██████╔╝╚██████╔╝███████╗██████╔╝    ██║  ██║╚██████╔╝███████╗    ╚██████╔╝██║ ╚████║███████╗
8  ╚═════╝  ╚═════╝ ╚══════╝╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝  ╚═══╝╚══════╝                                                                                              
9 
10                Tribute to Satoshi Nakamoto in 2008 and Vitalik Buterin in 2011.
11                                 - Decentralized believer, PROX.
12  *
13  */
14  
15 pragma solidity ^0.6.0;
16 
17 
18 // SPDX-License-Identifier: MIT
19 /**
20  * @dev Standard math utilities missing in the Solidity language.
21  */
22 library Math {
23     /**
24      * @dev Returns the largest of two numbers.
25      */
26     function max(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a >= b ? a : b;
28     }
29 
30     /**
31      * @dev Returns the smallest of two numbers.
32      */
33     function min(uint256 a, uint256 b) internal pure returns (uint256) {
34         return a < b ? a : b;
35     }
36 
37     /**
38      * @dev Returns the average of two numbers. The result is rounded towards
39      * zero.
40      */
41     function average(uint256 a, uint256 b) internal pure returns (uint256) {
42         // (a + b) / 2 can overflow, so we distribute
43         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
44     }
45 }
46 
47 
48 /**
49  * @dev Interface of the ERC20 standard as defined in the EIP.
50  */
51 interface IERC20 {
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `recipient`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Returns the remaining number of tokens that `spender` will be
73      * allowed to spend on behalf of `owner` through {transferFrom}. This is
74      * zero by default.
75      *
76      * This value changes when {approve} or {transferFrom} are called.
77      */
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     /**
81      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * IMPORTANT: Beware that changing an allowance with this method brings the risk
86      * that someone may use both the old and the new allowance by unfortunate
87      * transaction ordering. One possible solution to mitigate this race
88      * condition is to first reduce the spender's allowance to 0 and set the
89      * desired value afterwards:
90      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Moves `amount` tokens from `sender` to `recipient` using the
98      * allowance mechanism. `amount` is then deducted from the caller's
99      * allowance.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 /**
124  * @dev Wrappers over Solidity's arithmetic operations with added overflow
125  * checks.
126  *
127  * Arithmetic operations in Solidity wrap on overflow. This can easily result
128  * in bugs, because programmers usually assume that an overflow raises an
129  * error, which is the standard behavior in high level programming languages.
130  * `SafeMath` restores this intuition by reverting the transaction when an
131  * operation overflows.
132  *
133  * Using this library instead of the unchecked operations eliminates an entire
134  * class of bugs, so it's recommended to use it always.
135  */
136 library SafeMath {
137     /**
138      * @dev Returns the addition of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `+` operator.
142      *
143      * Requirements:
144      *
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         uint256 c = a - b;
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      *
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197         // benefit is lost if 'b' is also tested.
198         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
199         if (a == 0) {
200             return 0;
201         }
202 
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return div(a, b, "SafeMath: division by zero");
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b > 0, errorMessage);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         return mod(a, b, "SafeMath: modulo by zero");
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts with custom message when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b != 0, errorMessage);
275         return a % b;
276     }
277 }
278 
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // This method relies in extcodesize, which returns 0 for contracts in
303         // construction, since the code is only stored at the end of the
304         // constructor execution.
305 
306         uint256 size;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { size := extcodesize(account) }
309         return size > 0;
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call{ value: amount }("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain`call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355       return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
365         return _functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         return _functionCallWithValue(target, data, value, errorMessage);
392     }
393 
394     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
395         require(isContract(target), "Address: call to non-contract");
396 
397         // solhint-disable-next-line avoid-low-level-calls
398         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 // solhint-disable-next-line no-inline-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 
419 /**
420  * @title SafeERC20
421  * @dev Wrappers around ERC20 operations that throw on failure (when the token
422  * contract returns false). Tokens that return no value (and instead revert or
423  * throw on failure) are also supported, non-reverting calls are assumed to be
424  * successful.
425  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
426  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
427  */
428 library SafeERC20 {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     function safeTransfer(IERC20 token, address to, uint256 value) internal {
433         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
434     }
435 
436     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
437         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
438     }
439 
440     /**
441      * @dev Deprecated. This function has issues similar to the ones found in
442      * {IERC20-approve}, and its usage is discouraged.
443      *
444      * Whenever possible, use {safeIncreaseAllowance} and
445      * {safeDecreaseAllowance} instead.
446      */
447     function safeApprove(IERC20 token, address spender, uint256 value) internal {
448         // safeApprove should only be called when setting an initial allowance,
449         // or when resetting it to zero. To increase and decrease it, use
450         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
451         // solhint-disable-next-line max-line-length
452         require((value == 0) || (token.allowance(address(this), spender) == 0),
453             "SafeERC20: approve from non-zero to non-zero allowance"
454         );
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
456     }
457 
458     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
459         uint256 newAllowance = token.allowance(address(this), spender).add(value);
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
461     }
462 
463     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
464         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
465         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     /**
469      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
470      * on the return value: the return value is optional (but if data is returned, it must not be false).
471      * @param token The token targeted by the call.
472      * @param data The call data (encoded using abi.encode or one of its variants).
473      */
474     function _callOptionalReturn(IERC20 token, bytes memory data) private {
475         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
476         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
477         // the target address contains contract code and also asserts for success in the low-level call.
478 
479         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
480         if (returndata.length > 0) { // Return data is optional
481             // solhint-disable-next-line max-line-length
482             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
483         }
484     }
485 }
486 
487 
488 /*
489  * @dev Provides information about the current execution context, including the
490  * sender of the transaction and its data. While these are generally available
491  * via msg.sender and msg.data, they should not be accessed in such a direct
492  * manner, since when dealing with GSN meta-transactions the account sending and
493  * paying for execution may not be the actual sender (as far as an application
494  * is concerned).
495  *
496  * This contract is only required for intermediate, library-like contracts.
497  */
498 abstract contract Context {
499     function _msgSender() internal view virtual returns (address payable) {
500         return msg.sender;
501     }
502 
503     function _msgData() internal view virtual returns (bytes memory) {
504         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
505         return msg.data;
506     }
507 }
508 
509 
510 /**
511  * @dev Contract module which provides a basic access control mechanism, where
512  * there is an account (an owner) that can be granted exclusive access to
513  * specific functions.
514  *
515  * By default, the owner account will be the one that deploys the contract. This
516  * can later be changed with {transferOwnership}.
517  *
518  * This module is used through inheritance. It will make available the modifier
519  * `onlyOwner`, which can be applied to your functions to restrict their use to
520  * the owner.
521  */
522 contract Ownable is Context {
523     address private _owner;
524 
525     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
526 
527     /**
528      * @dev Initializes the contract setting the deployer as the initial owner.
529      */
530     constructor () internal {
531         address msgSender = _msgSender();
532         _owner = msgSender;
533         emit OwnershipTransferred(address(0), msgSender);
534     }
535 
536     /**
537      * @dev Returns the address of the current owner.
538      */
539     function owner() public view returns (address) {
540         return _owner;
541     }
542 
543     /**
544      * @dev Throws if called by any account other than the owner.
545      */
546     modifier onlyOwner() {
547         require(_owner == _msgSender(), "Ownable: caller is not the owner");
548         _;
549     }
550 
551     /**
552      * @dev Leaves the contract without owner. It will not be possible to call
553      * `onlyOwner` functions anymore. Can only be called by the current owner.
554      *
555      * NOTE: Renouncing ownership will leave the contract without an owner,
556      * thereby removing any functionality that is only available to the owner.
557      */
558     function renounceOwnership() public virtual onlyOwner {
559         emit OwnershipTransferred(_owner, address(0));
560         _owner = address(0);
561     }
562 
563     /**
564      * @dev Transfers ownership of the contract to a new account (`newOwner`).
565      * Can only be called by the current owner.
566      */
567     function transferOwnership(address newOwner) public virtual onlyOwner {
568         require(newOwner != address(0), "Ownable: new owner is the zero address");
569         emit OwnershipTransferred(_owner, newOwner);
570         _owner = newOwner;
571     }
572 }
573 
574 
575 contract LPTokenWrapperV2 {
576     using SafeMath for uint256;
577     using SafeERC20 for IERC20;
578 
579     IERC20 public lp = IERC20(0xA56Ed2632E443Db5f93e73C89df399a081408Cc4);
580 
581     uint256 private _totalSupply;
582     mapping(address => uint256) private _balances;
583 
584     constructor(address _lp) public {
585         lp = IERC20(_lp);
586     }
587 
588     function totalSupply() public view returns (uint256) {
589         return _totalSupply;
590     }
591 
592     function balanceOf(address account) public view returns (uint256) {
593         return _balances[account];
594     }
595 
596     function _stake(uint256 amount) internal {
597         _totalSupply = _totalSupply.add(amount);
598         _balances[msg.sender] = _balances[msg.sender].add(amount);
599         lp.safeTransferFrom(msg.sender, address(this), amount);
600     }
601 
602     function _withdraw(uint256 amount) internal {
603         _totalSupply = _totalSupply.sub(amount);
604         _balances[msg.sender] = _balances[msg.sender].sub(amount);
605         lp.safeTransfer(msg.sender, amount);
606     }
607 
608     function _stakeFromReward(address account, uint256 amount) internal {
609         require(account != address(0), "invalid address");
610         require(lp.balanceOf(address(this)) >= _totalSupply.add(amount), "out of balance");
611         _totalSupply = _totalSupply.add(amount);
612         _balances[account] = _balances[account].add(amount);
613     }
614 }
615 
616 
617 contract StakingPoolV2 is LPTokenWrapperV2, Ownable {
618     using Address for address;
619     using SafeMath for uint256;
620     using SafeERC20 for IERC20;
621 
622     struct UserInfo {
623         uint256 poolId;
624         uint256 stakingTime;
625         uint256 lastRewardPerToken;
626         uint256 pendingReward;
627         uint256 lastRewardPerToken4Pool;
628         uint256 pendingReward4Pool;
629     }
630 
631     struct PoolInfo {
632         address owner;
633         address beneficiary;
634         uint256 announceTime;
635         uint256 amount; // How many tokens staked in the pool
636         uint256 profit;
637     }
638 
639     enum PoolAnnounceStatusCode {OK, WRONG_PID, POOL_HAS_OWNER, NEED_MORE_DEPOSIT, USER_IN_ANOTHER_POOL}
640 
641     IERC20 public rewardToken = IERC20(0xA56Ed2632E443Db5f93e73C89df399a081408Cc4);
642 
643     uint256 public constant SECONDS_PER_DAY = 1 days;
644     uint256 public constant REWARD_DURATION = 7 * SECONDS_PER_DAY;
645 
646     // pool related constant
647     uint256 public constant MAX_POOL_NUMBER = 108;
648     uint256 public constant MIN_POOL_ANNOUNCE_AMOUNT = 50 * 1e18;
649     uint256 public constant MIN_POOL_DEPOSIT_AMOUNT = 100 * 1e18;
650     uint256 public constant MIN_POOL_ANNOUNCE_DURATION = 3 * SECONDS_PER_DAY;
651 
652     PoolInfo[] private poolInfo;
653     mapping(address => UserInfo) public userInfo;
654     mapping(address => uint256) public poolRewards;
655     
656     // settle state
657     mapping(address => uint256) public pendingAmount;
658     mapping(address => uint256) public settlementDate;
659     
660     // settle period
661     uint256 public minWithdrawDuration = 3 * SECONDS_PER_DAY;
662 
663     uint256 public periodFinish;
664     uint256 public lastRewardUpdateTime = 0;
665     uint256 public rewardPerTokenStored = 0;
666     uint256 public rewardPerTokenStored4Pool = 0;
667 
668     uint256 public userRewardRatePerDay = 40;
669     uint256 public poolRewardRatePerDay = 40;
670     uint256 public constant REWARD_RATE_BASE = 10000;
671 
672     bool public breaker = false;
673     mapping(address => bool) public whiteList;
674 
675     /* ========== EVENTS ========== */
676     event Deposited(address indexed user, uint256 amount, uint256 pid);
677     event Withdrawn(address indexed user, uint256 amount, uint256 pid);
678     event Settled(address indexed user, uint256 amount);
679 
680     event Reinvested(address indexed user, uint256 amount, uint256 pid);
681     event RewardPaidToOwner(address indexed owner, uint256 reward, uint256 pid);
682 
683     event Announced(address indexed owner, uint256 pid);
684     event Renounced(address indexed owner, uint256 pid);
685     event BeneficiaryTransferred(address indexed previousBeneficiary, address indexed newBeneficiary, uint256 pid);
686 
687     event RewardsDurationUpdated(uint256 newDuration);
688     event Recovered(address indexed token, uint256 amount);
689     event EmergencyWithdraw(address indexed user, uint256 amount);
690 
691     constructor(address token) public LPTokenWrapperV2(token) {
692         rewardToken = IERC20(token);
693     }
694 
695     function createPool(uint256 count) external onlyOwner {
696         require(poolInfo.length.add(count) <= MAX_POOL_NUMBER, "too much pools");
697         for (uint256 i = 0; i < count; i++) {
698             poolInfo.push(
699                 PoolInfo({owner: address(0), beneficiary: address(0), announceTime: 0, amount: 0, profit: 0})
700             );
701         }
702     }
703 
704     function notifyRewardAmount() external onlyOwner updateReward(address(0)) {
705         require(currentTime() > periodFinish, "not finish");
706         lastRewardUpdateTime = currentTime();
707         periodFinish = currentTime().add(REWARD_DURATION);
708         emit RewardsDurationUpdated(periodFinish);
709     }
710 
711     modifier updateReward(address account) {
712         rewardPerTokenStored = calcUserRewardPerToken();
713         rewardPerTokenStored4Pool = calcPoolRewardPerToken();
714         lastRewardUpdateTime = lastTimeRewardApplicable();
715         if (account != address(0)) {
716             UserInfo storage user = userInfo[account];
717 
718             user.pendingReward = _earned(account);
719             user.lastRewardPerToken = rewardPerTokenStored;
720 
721             user.pendingReward4Pool = _earned4Pool(account);
722             user.lastRewardPerToken4Pool = rewardPerTokenStored4Pool;
723         }
724         _;
725     }
726 
727     function calcUserRewardPerToken() public view returns (uint256) {
728         return rewardPerTokenStored.add(lastTimeRewardApplicable().sub(lastRewardUpdateTime).mul(userRewardRatePerDay));
729     }
730 
731     function calcPoolRewardPerToken() public view returns (uint256) {
732         return
733             rewardPerTokenStored4Pool.add(
734                 lastTimeRewardApplicable().sub(lastRewardUpdateTime).mul(poolRewardRatePerDay)
735             );
736     }
737 
738     function lastTimeRewardApplicable() public view returns (uint256) {
739         return Math.min(block.timestamp, periodFinish);
740     }
741 
742     function reinvest(uint256 pid) public updateReward(msg.sender) {
743         require(pid < poolInfo.length, "Invalid pool id");
744 
745         UserInfo storage user = userInfo[msg.sender];
746 
747         if (balanceOf(msg.sender) > 0) {
748             require(user.poolId == pid, "Wrong pid");
749         }
750 
751         uint256 userEarned = _earned(msg.sender);
752         user.pendingReward = 0;
753 
754         uint256 poolEarned = _earned4Pool(msg.sender);
755         user.pendingReward4Pool = 0;
756 
757         PoolInfo storage pool = poolInfo[pid];
758         if (poolEarned > 0 && pool.owner != address(0) && pool.amount >= MIN_POOL_DEPOSIT_AMOUNT) {
759             poolRewards[pool.beneficiary] = poolRewards[pool.beneficiary].add(poolEarned);
760             pool.profit = pool.profit.add(poolEarned);
761 
762             emit RewardPaidToOwner(pool.beneficiary, poolEarned, pid);
763         }
764 
765         uint256 rewardFromPool = poolRewards[msg.sender];
766         if (rewardFromPool > 0) {
767             poolRewards[msg.sender] = 0;
768             userEarned = userEarned.add(rewardFromPool);
769         }
770 
771         if (userEarned == 0) {
772             return;
773         }
774 
775         super._stakeFromReward(msg.sender, userEarned);
776 
777         user.stakingTime = currentTime();
778         user.poolId = pid;
779 
780         pool.amount = pool.amount.add(userEarned);
781 
782         emit Reinvested(msg.sender, userEarned, pid);
783     }
784 
785     function deposit(uint256 pid, uint256 amount) external updateReward(msg.sender) {
786         require(amount > 0, "Cannot deposit 0");
787         require(pid < poolInfo.length, "Invalid pool id");
788 
789         UserInfo storage user = userInfo[msg.sender];
790 
791         if (balanceOf(msg.sender) > 0) {
792             require(pid == user.poolId, "Can deposit in only one pool");
793         }
794 
795         super._stake(amount);
796 
797         user.stakingTime = currentTime();
798         user.poolId = pid;
799 
800         PoolInfo storage pool = poolInfo[pid];
801         pool.amount = pool.amount.add(amount);
802 
803         emit Deposited(msg.sender, amount, pid);
804     }
805 
806     function withdraw(uint256 amount) public updateReward(msg.sender) {
807         require(amount > 0, "Cannot withdraw 0");
808         require(balanceOf(msg.sender) >= amount, "Not enough");
809 
810         UserInfo memory user = userInfo[msg.sender];
811 
812         PoolInfo storage pool = poolInfo[user.poolId];
813         if (pool.owner == msg.sender) {
814             require(balanceOf(msg.sender) >= amount.add(MIN_POOL_ANNOUNCE_AMOUNT), "Cannot withdraw");
815         }
816 
817         pool.amount = pool.amount.sub(staked(msg.sender));
818 
819         pendingAmount[msg.sender] = amount;
820         settlementDate[msg.sender] = currentTime();
821 
822         pool.amount = pool.amount.add(staked(msg.sender));
823 
824         emit Withdrawn(msg.sender, amount, user.poolId);
825     }
826 
827     function settle() external {
828         require(currentTime() >= settlementDate[msg.sender].add(minWithdrawDuration), "too early");
829         uint256 amount = pendingAmount[msg.sender];
830         if (amount > 0) {
831             pendingAmount[msg.sender] = 0;
832             
833             super._withdraw(amount);
834 
835             emit Settled(msg.sender, amount);
836         }
837     }
838 
839     function exit() external {
840         UserInfo memory user = userInfo[msg.sender];
841         reinvest(user.poolId);
842         withdraw(balanceOf(msg.sender));
843     }
844 
845     function settleableDate(address account) external view returns (uint256) {
846         return settlementDate[account].add(minWithdrawDuration);
847     }
848 
849     function earned(address account) external view returns (uint256) {
850         uint256 userEarned = _earned(account);
851         return userEarned;
852     }
853 
854     function staked(address account) public view returns (uint256) {
855         return balanceOf(account).sub(pendingAmount[account]);
856     }
857 
858     function announce(uint256 pid) external {
859         require(!address(msg.sender).isContract() || whiteList[msg.sender], "Not welcome");
860 
861         require(staked(msg.sender) >= MIN_POOL_ANNOUNCE_AMOUNT, "deposit more to announce");
862 
863         PoolAnnounceStatusCode status = checkAnnounceable(pid, msg.sender);
864         require(status == PoolAnnounceStatusCode.OK, "Check Status Code");
865 
866         PoolInfo storage pool = poolInfo[pid];
867         pool.owner = msg.sender;
868         pool.beneficiary = msg.sender;
869         pool.announceTime = currentTime();
870         pool.profit = 0;
871 
872         emit Announced(msg.sender, pid);
873     }
874 
875     function renounce(uint256 pid) external {
876         PoolInfo storage pool = poolInfo[pid];
877         require(pool.owner == msg.sender, "Must be owner");
878         require(pool.announceTime + MIN_POOL_ANNOUNCE_DURATION < currentTime(), "Cannot renounce now");
879 
880         pool.owner = address(0);
881         pool.beneficiary = address(0);
882         pool.announceTime = 0;
883 
884         emit Renounced(msg.sender, pid);
885     }
886 
887     function setBeneficiary(uint256 _pid, address _beneficiary) external {
888         require(_beneficiary != address(0), "!_beneficiary");
889         PoolInfo storage pool = poolInfo[_pid];
890         require(pool.owner == msg.sender, "Must be owner");
891         address preBeneficiary = pool.beneficiary;
892         pool.beneficiary = _beneficiary;
893         emit BeneficiaryTransferred(preBeneficiary, pool.beneficiary, _pid);
894     }
895 
896     function setBreaker(bool _breaker) external onlyOwner {
897         breaker = _breaker;
898     }
899 
900     function setWhiteList(address addr, bool status) external onlyOwner {
901         require(addr != address(0), "!addr");
902         whiteList[addr] = status;
903     }
904 
905     function setRewardRatePerDay(uint256 userRewardRate, uint256 poolRewardRate) external onlyOwner {
906         require(currentTime() > periodFinish, "not finish");
907         require(userRewardRate <= REWARD_RATE_BASE, "!wrong user rate");
908         require(poolRewardRate <= REWARD_RATE_BASE, "!wrong pool rate");
909         userRewardRatePerDay = userRewardRate;
910         poolRewardRatePerDay = poolRewardRate;
911     }
912 
913     function setMinWithdrawDuration(uint256 duration) external onlyOwner {
914         require(duration >= SECONDS_PER_DAY, "!at least one day");
915         minWithdrawDuration = duration;
916     }
917 
918     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
919     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
920         require(
921             tokenAddress != address(lp) && tokenAddress != address(rewardToken),
922             "Cannot withdraw the staking or rewards tokens"
923         );
924         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
925         emit Recovered(tokenAddress, tokenAmount);
926     }
927 
928     // withdraw extra reward tokens after staking period
929     function withdrawAll() external onlyOwner {
930         require(currentTime() > periodFinish, "period not finished");
931         uint256 bal = rewardToken.balanceOf(address(this));
932         uint256 amount = bal.sub(totalSupply());
933         IERC20(rewardToken).safeTransfer(owner(), amount);
934     }
935 
936     // Withdraw without caring about rewards. EMERGENCY ONLY.
937     function emergencyWithdraw() external {
938         require(breaker, "!breaker");
939 
940         UserInfo storage user = userInfo[msg.sender];
941         user.pendingReward = 0;
942         user.pendingReward4Pool = 0;
943         poolRewards[msg.sender] = 0;
944         pendingAmount[msg.sender] = 0;
945 
946         uint256 amount = balanceOf(msg.sender);
947         super._withdraw(amount);
948         emit EmergencyWithdraw(msg.sender, amount);
949     }
950 
951     function maxWithdrawAmount(address account) public view returns (uint256) {
952         uint256 maxAmount = balanceOf(account);
953         UserInfo memory user = userInfo[account];
954         PoolInfo memory pool = poolInfo[user.poolId];
955         if (pool.owner == account) {
956             return maxAmount.sub(MIN_POOL_ANNOUNCE_AMOUNT);
957         }
958         return maxAmount;
959     }
960 
961     function queryPoolInfo(uint256 pid, address account)
962         public
963         view
964         returns (
965             bool hasOwner,
966             bool isOwner,
967             uint256 announceableStatus,
968             uint256 totalAmount,
969             uint256 announceTime,
970             uint256 poolProfit,
971             address beneficiary
972         )
973     {
974         PoolInfo memory pool = poolInfo[pid];
975         if (pool.owner != address(0)) {
976             hasOwner = true;
977             if (pool.owner == address(account)) {
978                 isOwner = true;
979             }
980         }
981         announceableStatus = uint256(checkAnnounceable(pid, account));
982         totalAmount = pool.amount;
983         if (hasOwner) {
984             announceTime = pool.announceTime;
985             poolProfit = pool.profit;
986         }
987         if (isOwner) {
988             beneficiary = pool.beneficiary;
989         }
990     }
991 
992     function poolCount() public view returns (uint256) {
993         return uint256(poolInfo.length);
994     }
995 
996     function _earned(address account) internal view returns (uint256) {
997         UserInfo memory user = userInfo[account];
998         return
999             staked(account)
1000                 .mul(calcUserRewardPerToken().sub(user.lastRewardPerToken))
1001                 .div(REWARD_RATE_BASE)
1002                 .div(SECONDS_PER_DAY)
1003                 .add(user.pendingReward);
1004     }
1005 
1006     function _earned4Pool(address account) internal view returns (uint256) {
1007         UserInfo memory user = userInfo[account];
1008         return
1009             staked(account)
1010                 .mul(calcPoolRewardPerToken().sub(user.lastRewardPerToken4Pool))
1011                 .div(REWARD_RATE_BASE)
1012                 .div(SECONDS_PER_DAY)
1013                 .add(user.pendingReward4Pool);
1014     }
1015 
1016     function checkAnnounceable(uint256 pid, address account) internal view returns (PoolAnnounceStatusCode) {
1017         // check pid
1018         if (pid >= poolInfo.length) {
1019             return PoolAnnounceStatusCode.WRONG_PID;
1020         }
1021         // check owner
1022         PoolInfo memory pool = poolInfo[pid];
1023         if (pool.owner != address(0)) {
1024             return PoolAnnounceStatusCode.POOL_HAS_OWNER;
1025         }
1026         // check user
1027         UserInfo memory user = userInfo[account];
1028         if (balanceOf(account) > 0 && pid != user.poolId) {
1029             return PoolAnnounceStatusCode.USER_IN_ANOTHER_POOL;
1030         }
1031         // check the minimum deposit requirement
1032         if (staked(account) < MIN_POOL_ANNOUNCE_AMOUNT) {
1033             return PoolAnnounceStatusCode.NEED_MORE_DEPOSIT;
1034         }
1035         return PoolAnnounceStatusCode.OK;
1036     }
1037 
1038     function currentTime() internal view returns (uint256) {
1039         return block.timestamp;
1040     }
1041 }