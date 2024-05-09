1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-04
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-10-04
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-10-01
11 */
12 
13 pragma solidity 0.6.3;
14 
15 
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 
243 
244 
245 contract Ownable is Context {
246     address private _owner;
247 
248     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
249 
250     /**
251      * @dev Initializes the contract setting the deployer as the initial owner.
252      */
253     constructor () internal {
254         address msgSender = _msgSender();
255         _owner = msgSender;
256         emit OwnershipTransferred(address(0), msgSender);
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(_owner == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         emit OwnershipTransferred(_owner, address(0));
283         _owner = address(0);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Can only be called by the current owner.
289      */
290     function transferOwnership(address newOwner) public virtual onlyOwner {
291         require(newOwner != address(0), "Ownable: new owner is the zero address");
292         emit OwnershipTransferred(_owner, newOwner);
293         _owner = newOwner;
294     }
295 }
296 
297 
298 
299 
300 
301 
302 
303 
304 
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize, which returns 0 for contracts in
325         // construction, since the code is only stored at the end of the
326         // constructor execution.
327 
328         uint256 size;
329         // solhint-disable-next-line no-inline-assembly
330         assembly { size := extcodesize(account) }
331         return size > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
354         (bool success, ) = recipient.call{ value: amount }("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain`call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377       return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         require(isContract(target), "Address: call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.call{ value: value }(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but performing a static call.
423      *
424      * _Available since v3.3._
425      */
426     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
427         return functionStaticCall(target, data, "Address: low-level static call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
432      * but performing a static call.
433      *
434      * _Available since v3.3._
435      */
436     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
437         require(isContract(target), "Address: static call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.staticcall(data);
441         return _verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a delegate call.
447      *
448      * _Available since v3.3._
449      */
450     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
451         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a delegate call.
457      *
458      * _Available since v3.3._
459      */
460     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
461         require(isContract(target), "Address: delegate call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.delegatecall(data);
465         return _verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
469         if (success) {
470             return returndata;
471         } else {
472             // Look for revert reason and bubble it up if present
473             if (returndata.length > 0) {
474                 // The easiest way to bubble the revert reason is using memory via assembly
475 
476                 // solhint-disable-next-line no-inline-assembly
477                 assembly {
478                     let returndata_size := mload(returndata)
479                     revert(add(32, returndata), returndata_size)
480                 }
481             } else {
482                 revert(errorMessage);
483             }
484         }
485     }
486 }
487 
488 
489 /**
490  * @title SafeERC20
491  * @dev Wrappers around ERC20 operations that throw on failure (when the token
492  * contract returns false). Tokens that return no value (and instead revert or
493  * throw on failure) are also supported, non-reverting calls are assumed to be
494  * successful.
495  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
496  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
497  */
498 library SafeERC20 {
499     using SafeMath for uint256;
500     using Address for address;
501 
502     function safeTransfer(IERC20 token, address to, uint256 value) internal {
503         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
504     }
505 
506     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
507         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
508     }
509 
510     /**
511      * @dev Deprecated. This function has issues similar to the ones found in
512      * {IERC20-approve}, and its usage is discouraged.
513      *
514      * Whenever possible, use {safeIncreaseAllowance} and
515      * {safeDecreaseAllowance} instead.
516      */
517     function safeApprove(IERC20 token, address spender, uint256 value) internal {
518         // safeApprove should only be called when setting an initial allowance,
519         // or when resetting it to zero. To increase and decrease it, use
520         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
521         // solhint-disable-next-line max-line-length
522         require((value == 0) || (token.allowance(address(this), spender) == 0),
523             "SafeERC20: approve from non-zero to non-zero allowance"
524         );
525         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
526     }
527 
528     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
529         uint256 newAllowance = token.allowance(address(this), spender).add(value);
530         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
531     }
532 
533     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     /**
539      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
540      * on the return value: the return value is optional (but if data is returned, it must not be false).
541      * @param token The token targeted by the call.
542      * @param data The call data (encoded using abi.encode or one of its variants).
543      */
544     function _callOptionalReturn(IERC20 token, bytes memory data) private {
545         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
546         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
547         // the target address contains contract code and also asserts for success in the low-level call.
548 
549         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
550         if (returndata.length > 0) { // Return data is optional
551             // solhint-disable-next-line max-line-length
552             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
553         }
554     }
555 }
556 
557 
558 
559 
560 // MasterChef is the master of Lef. He can make Lef and he is a fair guy.
561 //
562 // Note that it's ownable and the owner wields tremendous power. The ownership
563 // will be transferred to a governance smart contract once Lef is sufficiently
564 // distributed and the community can show to govern itself.
565 //
566 // Have fun reading it. Hopefully it's bug-free. God bless.
567 contract MasterChef is Ownable {
568     using SafeMath for uint256;
569     using SafeERC20 for IERC20;
570 
571     // Info of each user.
572     struct UserInfo {
573 		uint256 pid;
574         uint256 amount;     // How many LP tokens the user has provided.
575 		uint256 reward;
576         uint256 rewardPaid; 
577 		uint256 updateTime;
578 		uint256 userRewardPerTokenPaid;
579     }
580 	// Info of each user that stakes LP tokens.
581     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
582 	
583 	
584 	
585     // Info of each pool.
586     struct PoolInfo {
587         IERC20 lpToken;           // Address of LP token contract.
588         uint256 allocPoint;       // How many allocation points assigned to this pool. Lefs to distribute per block.
589         uint256 lastRewardTime;  // Last block number that Lefs distribution occurs.
590         uint256 accLefPerShare; // Accumulated Lefs per share, times 1e18. See below.
591 		uint256 totalPool;
592     }
593     // Info of each pool.
594     PoolInfo[] public poolInfo;
595 	
596 
597 	struct VipPoolInfo {
598         uint256 allocPoint;       // How many allocation points assigned to this pool. Lefs to distribute per block.
599         uint256 lastTime;  // Last block number that Lefs distribution occurs.
600         uint256 rewardPerTokenStored; // Accumulated Lefs per share, times 1e18. See below.
601 		uint256 vipNumber;
602     }
603 
604 	mapping(uint256 => VipPoolInfo) public vipPoolInfo;
605     
606 	struct User {
607         uint id; 
608         address referrer; 
609 
610 		uint256[] referAmount;
611 
612 		uint256 referReward;
613 
614         uint256 totalReward;
615 	
616 		uint256 referRewardPerTokenPaid;
617 
618         uint256 vip;
619     }	
620 	mapping(address => User) public users;
621 	
622 
623 	uint public lastUserId = 2;
624 	mapping(uint256 => address) public regisUser;
625 
626 	uint256[] DURATIONS =[3 days, 10 days, 22 days]; 
627 	
628 	
629 	
630 
631 	bool initialized = false;
632 
633     //uint256 public initreward = 1250*1e18;
634 
635     uint256 public starttime = 1599829200;//秒
636 
637     uint256 public periodFinish = 0;
638 
639     uint256 public rewardRate = 0;
640 
641     uint256 public totalMinted = 0;
642 
643 	uint256 public drawPending_threshold = 2000 * 10e18;
644 
645 
646 
647 	
648 
649 	mapping(uint => uint256) public vipLevel;	
650 	uint32 vipLevalLength = 0;
651 
652 
653 	//The Lef TOKEN!
654 	//  IERC20 public lef = IERC20(0x54CF703014A82B4FF7E9a95DD45e453e1Ba13eb1);
655     IERC20 public lef ;
656 
657 
658 
659 	address public defaultReferAddr = address(0xCfCe2a772ae87c5Fae474b2dE0324ee19C2c145f);
660 	
661 
662     // Total allocation poitns. Must be the sum of all allocation points in all pools.总权重
663     uint256 public totalAllocPoint = 0;
664     // Bonus muliplier for early lef makers.早期挖矿的额外奖励
665     uint256 public constant BONUS_MULTIPLIER = 3;
666 
667 
668 
669 
670     event RewardPaid(address indexed user, uint256 reward);
671     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
672     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
673     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
674 
675  
676     function initContract (IERC20 _lef,uint256 _rewardRate,uint256 _starttime,uint256 _periodFinish,address _defaultReferAddr) public onlyOwner{	
677 		require(initialized == false,"has initialized");
678         lef = _lef;
679 		rewardRate = _rewardRate;
680 		starttime = _starttime;
681 		periodFinish = _periodFinish;
682 		defaultReferAddr =  _defaultReferAddr;
683 	
684 		User memory user = User({
685             id: 1,
686             referrer: address(0),
687             referAmount:new uint256[](2),
688 			referReward:0,
689 			totalReward:0,
690 			referRewardPerTokenPaid:0,
691 			vip:0
692         });		
693 		users[defaultReferAddr] = user;	
694 		
695 		regisUser[1] = 	defaultReferAddr;
696 		initialized = true;	
697     }
698 
699 
700 	
701 	function setVipLevel(uint level,uint256 amount) public onlyOwner {
702 
703 		if(vipLevalLength < 3){
704 		
705 			vipLevalLength++;
706 		
707     	//	uint256 vip1 = 0;
708 	    //   uint256 vip2 = 0;
709 		//	uint256 vip3 = 0;
710 		//  
711 		//	for(uint i = 1;i < vipLevalLength;i++){
712 		//		address regAddr = regisUser[i];
713 		//		uint256 vip = getVipLeval(regAddr);
714 		//		if(vip == 1){
715 		//		    vip1 ++;
716 		//		}else if(vip == 2){
717 		//		    vip2 ++;
718 		//		}else if(vip == 3){
719 		//		    vip3 ++;
720 		//		}
721 		//		
722 		//	}
723 		//	vipPoolInfo[1].vipNumber = vip1;
724 		//	vipPoolInfo[2].vipNumber = vip2;
725 		//	vipPoolInfo[3].vipNumber = vip3;
726 		//	for(uint i = 1;i < vipLevalLength;i++){
727 		//		updateVipPool(regisUser[i]);
728 		//	}
729 		}
730 		vipLevel[level] = amount;
731 		
732 	}
733 
734     function poolLength() external view returns (uint256) {
735         return poolInfo.length;
736     }
737 	
738 
739     function isUserExists(address user) public view returns (bool) {
740 		return (users[user].id != 0);
741     }
742 	
743 
744 	
745 	function registrationExt(address referrerAddress) external {
746         registration(msg.sender, referrerAddress);
747     }
748 
749     function registration(address userAddress, address referrerAddress) private {
750        //require(msg.value == 0.05 ether, "registration cost 0.05");
751         require(!isUserExists(userAddress), "user exists");
752         require(isUserExists(referrerAddress), "referrer not exists");
753         
754         uint32 size;
755         assembly {
756             size := extcodesize(userAddress)
757         }
758 		require(size == 0, "cannot be a contract");
759 
760         
761  
762         User memory user = User({
763             id: lastUserId,
764             referrer: referrerAddress,
765 			referAmount:new uint256[](2),
766 			totalReward:0,
767 			referReward:0,
768 			referRewardPerTokenPaid:0,
769 			vip:0
770         });
771 		
772 		regisUser[lastUserId] = userAddress;
773         
774         users[userAddress] = user;
775 		
776         lastUserId++;
777         
778         emit  Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
779     }
780 	
781 	function setDrawReferThreshold(uint256 _threshold) public onlyOwner{
782 		drawPending_threshold = _threshold;
783 	}
784 
785 	function drawReferPending() public{
786 		require(isUserExists(msg.sender), "user exists");
787 		
788 
789 		require(getAllDeposit(msg.sender) > drawPending_threshold,"must mt 2000 * 1e18");
790 
791 
792 		uint256 pengdingReward = 0;
793 
794 		uint256 vip = getVipLevel(msg.sender);
795 
796 		if(vip >0){		
797 			VipPoolInfo storage vipPool = vipPoolInfo[vip];
798 			User storage user = users[msg.sender];
799 			uint256 rewardPerTokenStored = vipPool.rewardPerTokenStored;
800 			uint256 lpSupply = vipPool.vipNumber;
801 			if (block.timestamp > vipPool.lastTime && lpSupply != 0) {
802 				uint256 multiplier = getMultiplier(vipPool.lastTime, block.timestamp);
803 				uint256 lefReward = multiplier.mul(rewardRate).mul(vipPool.allocPoint).div(totalAllocPoint);				
804 				rewardPerTokenStored = rewardPerTokenStored.add(lefReward.div(lpSupply));
805 			}				
806 			 pengdingReward = rewardPerTokenStored.sub(user.referRewardPerTokenPaid).add(users[msg.sender].referReward);
807 			 safeLefTransfer(msg.sender, pengdingReward);
808 			 users[msg.sender].referReward = 0;
809 			 users[msg.sender].totalReward += pengdingReward;
810 			 user.referRewardPerTokenPaid = rewardPerTokenStored;
811 		}
812 	}
813 
814 
815 	//
816 	function getReferReward(address _referrer) public view returns(uint256){
817 	//	require(isUserExists(_referrer), "user exists");
818 		uint256 pengdingReward = 0;
819 		if(!isUserExists(_referrer)){
820 		  return pengdingReward;
821 		}
822 		uint256 vip = getVipLevel(_referrer);
823 		pengdingReward = users[_referrer].referReward;
824 		if(vip >0){		
825 
826 			VipPoolInfo storage vipPool = vipPoolInfo[vip];
827 			User storage user = users[_referrer];
828 			uint256 rewardPerTokenStored = vipPool.rewardPerTokenStored;
829 			uint256 lpSupply = vipPool.vipNumber;
830 			if (block.timestamp > vipPool.lastTime && lpSupply != 0) {
831 				uint256 multiplier = getMultiplier(vipPool.lastTime, block.timestamp);
832 				uint256 lefReward = multiplier.mul(rewardRate).mul(vipPool.allocPoint).div(totalAllocPoint);				
833 				rewardPerTokenStored = rewardPerTokenStored.add(lefReward.div(lpSupply));
834 			}				
835 			return rewardPerTokenStored.sub(user.referRewardPerTokenPaid).add(pengdingReward);
836 		}
837 		return pengdingReward;
838 	}
839 	
840 
841     // Add a new lp to the pool. Can only be called by the owner.
842     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
843     function addLp(uint256 _allocPoint, IERC20 _lpToken) public onlyOwner {   
844         uint256 lastRewardTime = block.timestamp > starttime ? block.timestamp : starttime;
845         //totalAllocPoint = totalAllocPoint.add(_allocPoint);
846         poolInfo.push(PoolInfo({
847             lpToken: _lpToken,
848             allocPoint: _allocPoint,
849             lastRewardTime: lastRewardTime,
850             accLefPerShare: 0,
851 			totalPool:0
852         }));		
853     }
854 	
855 	
856 	function addVipPoolPoint(uint256 _vipIndex,uint256 _allocPoint) public onlyOwner {
857         uint256 lastTime = block.timestamp > starttime ? block.timestamp : starttime;
858 		vipPoolInfo[_vipIndex].allocPoint = _allocPoint;
859 		if(vipPoolInfo[_vipIndex].lastTime == 0){
860 			vipPoolInfo[_vipIndex].lastTime = lastTime;
861 		}
862        // vipPoolInfo[_vipIndex] =VipPoolInfo({
863       //      allocPoint: _allocPoint,
864         //    lastTime:lastTime,
865          //   rewardPerTokenStored:0,
866          //   vipNumber:0
867       //  }); 
868     }
869 
870     // Update the given pool's Lef allocation point. Can only be called by the owner.
871     function set(uint256 _pid, uint256 _allocPoint) public onlyOwner {
872 
873         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
874         poolInfo[_pid].allocPoint = _allocPoint;
875     }
876 	
877 	function setTotalAllocPoint(uint256 _totalAllocPoint) public onlyOwner{
878 		totalAllocPoint = _totalAllocPoint;
879 	}
880 	
881 	function setRewardRate(uint256 _rewardRate) public onlyOwner {
882 		rewardRate = _rewardRate;	
883 	} 
884 
885 	
886   
887 
888     // Return reward multiplier over the given _from to _to block.
889     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
890         if (_to <= periodFinish) {
891             return _to.sub(_from).mul(BONUS_MULTIPLIER);
892         } else if (_from >= periodFinish) {
893             return _to.sub(_from);
894         } else {
895             return periodFinish.sub(_from).mul(BONUS_MULTIPLIER).add(
896                 _to.sub(periodFinish)
897             );
898         }
899     }
900 
901 
902     function pendingLef(uint256 _pid, address _user) public view returns (uint256) {
903         PoolInfo storage pool = poolInfo[_pid];
904         UserInfo storage user = userInfo[_pid][_user];
905         uint256 accLefPerShare = pool.accLefPerShare;
906         uint256 lpSupply = pool.totalPool;
907         if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
908             uint256 multiplier =  getMultiplier(pool.lastRewardTime, block.timestamp);
909             uint256 lefReward = multiplier.mul(rewardRate).mul(pool.allocPoint).div(totalAllocPoint);
910             accLefPerShare = pool.accLefPerShare.add(lefReward.mul(1e18).div(lpSupply));
911         }
912         return user.amount.mul((accLefPerShare).sub(user.userRewardPerTokenPaid)).div(1e18).add(user.reward);
913     }
914 	
915 
916 	function pendingAllLef(address _user) public view returns (uint256) {
917 		uint256  result = 0;
918 		for(uint256 i = 0;i< poolInfo.length;i++ ){
919 			result = result.add(pendingLef(i,_user));
920 		}
921         return result;
922     }
923 	
924 
925 	function allLefAmount(address _user) public view returns (uint256) {
926 		uint256 result = 0;
927 		for(uint256 i = 0;i< poolInfo.length;i++ ){
928 			UserInfo storage user = userInfo[i][_user];
929 			result = result.add(pendingLef(i,_user).add(user.rewardPaid));
930 		}
931         return result;
932     }
933 	
934 
935 	function getAllDeposit(address _user) public view returns (uint256) {
936 		uint256 result = 0;
937 		for(uint256 i = 0;i< poolInfo.length;i++ ){
938 			UserInfo storage user = userInfo[i][_user];		
939 			result = result.add(user.amount);
940 		}
941         return result;
942     }
943 
944 
945 	function updateVipPool(address _user) internal {
946 		address _referrer = users[_user].referrer;
947 		for(uint i = 1;i < 3;i++){
948 			if(isUserExists(_referrer) && _referrer != address(0)){
949 				uint256 vip = getVipLevel(_referrer);
950 				uint256 _vip = users[_referrer].vip;
951 				uint256 skip_num ;
952 				if(vip > _vip){
953 					skip_num =  vip.sub(_vip);
954 				}else if(vip < _vip){
955 					skip_num =  _vip.sub(vip);
956 				}
957 				
958 				if(skip_num != 0){ 
959 					bool gloryBonus = false; 
960 					if(i == 2 && users[_user].vip >= 2 && vip >= 2){
961 						gloryBonus == true;
962 					}
963 					if(_vip != 0){
964 						VipPoolInfo storage _vpInfo =  vipPoolInfo[_vip];
965 						if(vipPoolInfo[_vip].vipNumber != 0){
966 							uint256 _multiplier = getMultiplier(_vpInfo.lastTime, block.timestamp);
967 							uint256 _lefReward;
968 							if(gloryBonus){
969 								_lefReward = _multiplier.mul(rewardRate).mul((_vpInfo.allocPoint).add(totalAllocPoint.mul(3).div(100))).div(totalAllocPoint);
970 							}else{
971 								_lefReward = _multiplier.mul(rewardRate).mul(_vpInfo.allocPoint).div(totalAllocPoint);
972 							}
973 							
974 							totalMinted = totalMinted.add(_lefReward);
975 							//lef.mint(address(this), _lefReward);
976 							_vpInfo.rewardPerTokenStored = _vpInfo.rewardPerTokenStored.add(_lefReward.div(_vpInfo.vipNumber));
977 							users[_referrer].referReward = ((_vpInfo.rewardPerTokenStored).sub(users[_referrer].referRewardPerTokenPaid)).add(users[_referrer].referReward);
978 							
979 							_vpInfo.vipNumber -= 1;	
980 							users[_referrer].referRewardPerTokenPaid = _vpInfo.rewardPerTokenStored;
981 							_vpInfo.lastTime = block.timestamp;							
982 						}			
983 					}
984 					if(vip != 0){
985 					
986 						VipPoolInfo storage vpInfo =  vipPoolInfo[vip];
987 						if(vpInfo.vipNumber != 0){
988 							
989 					
990 						
991 							uint256 multiplier = getMultiplier(vpInfo.lastTime, block.timestamp);
992 												
993 							uint256 lefReward;
994 							if(gloryBonus){
995 								lefReward = multiplier.mul(rewardRate).mul((vpInfo.allocPoint).add(totalAllocPoint.mul(3).div(100))).div(totalAllocPoint);
996 							}else{
997 								lefReward = multiplier.mul(rewardRate).mul(vpInfo.allocPoint).div(totalAllocPoint);
998 							}
999 						
1000 						
1001 							totalMinted = totalMinted.add(lefReward);
1002 						//lef.mint(address(this), lefReward);
1003 							vpInfo.rewardPerTokenStored = vpInfo.rewardPerTokenStored.add(lefReward.div(vpInfo.vipNumber));
1004 						
1005 						}
1006 						
1007 						//if(vpInfo.rewardPerTokenStored != 0){
1008 						//	users[_referrer].referReward = ((vpInfo.rewardPerTokenStored).sub(users[_referrer].referRewardPerTokenPaid)).add(users[_referrer].referReward);
1009 						//}
1010 						vpInfo.vipNumber += 1;
1011 
1012 						users[_referrer].referRewardPerTokenPaid = vpInfo.rewardPerTokenStored;
1013 						vpInfo.lastTime = block.timestamp;	
1014 					}	
1015 									
1016 				}	
1017 				users[_referrer].vip= vip;	
1018 				_referrer = users[_referrer].referrer;
1019 			}
1020 
1021 			
1022 		}		
1023 	}
1024 
1025 	
1026 	function getVipLevel(address _user) public view returns(uint256){
1027 		uint256 vip = 0;
1028 		if(isUserExists(_user)){
1029 			uint256 directReferAmount = users[_user].referAmount[0];
1030 		//	uint256 indirectReferAmount = users[_user].referAmount[1];
1031 			for(uint256 i = 1;i<=3;i++){
1032 				if(directReferAmount < vipLevel[i]){
1033 					return vip;
1034 				} else {
1035 					vip = i;
1036 				}				
1037 			}
1038 		}
1039 		return vip;
1040 	}
1041 
1042 	function getReferAmount(address _user,uint256 _index) public view returns(uint256){
1043 		if(isUserExists(_user)){
1044 			return	users[_user].referAmount[_index];
1045 		}
1046 		return 0;
1047 	}
1048 	
1049     // Update reward variables of the given pool to be up-to-date.
1050     function updatePool(uint256 _pid,address _user) internal {
1051         PoolInfo storage pool = poolInfo[_pid];
1052         if (block.timestamp <= pool.lastRewardTime) {
1053             return;
1054         }
1055         uint256 lpSupply = pool.totalPool;
1056         if (lpSupply == 0) {
1057             pool.lastRewardTime = block.timestamp;
1058             return;
1059         }
1060 		UserInfo storage user = userInfo[_pid][_user];
1061 		
1062         uint256 multiplier = getMultiplier(pool.lastRewardTime, block.timestamp);
1063         uint256 lefReward = multiplier.mul(rewardRate).mul(pool.allocPoint).div(totalAllocPoint);
1064         totalMinted = totalMinted.add(lefReward);
1065 
1066 
1067 		//lef.mint(address(this), lefReward);
1068         pool.accLefPerShare = pool.accLefPerShare.add(lefReward.mul(1e18).div(lpSupply));
1069 		
1070 		user.reward = user.amount.mul((pool.accLefPerShare).sub(user.userRewardPerTokenPaid)).div(1e18).add(user.reward);
1071 		
1072 		
1073 		user.userRewardPerTokenPaid = pool.accLefPerShare;
1074         pool.lastRewardTime = block.timestamp;
1075     }
1076 
1077 
1078     // Deposit LP tokens to MasterChef for lef allocation.
1079     function deposit(uint256 _pid, uint256 _amount) public checkStart checkhalve{
1080 
1081 		require(isUserExists(msg.sender), "user don't exists");		
1082         PoolInfo storage pool = poolInfo[_pid];
1083         UserInfo storage user = userInfo[_pid][msg.sender];
1084         updatePool(_pid,msg.sender);	
1085 		
1086         if(_amount > 0) {
1087            pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1088             user.amount = user.amount.add(_amount);
1089 			user.updateTime = block.timestamp;
1090 			user.pid = _pid;
1091 			pool.totalPool = pool.totalPool.add(_amount);   		
1092 	
1093 			address _referrer = users[msg.sender].referrer;
1094 			for(uint256 i = 0;i<2;i++){				
1095 				if(_referrer!= address(0) && isUserExists(_referrer)){
1096 					users[_referrer].referAmount[i] += _amount;					
1097 					_referrer = users[_referrer].referrer;
1098 				}
1099 			}				
1100         }
1101 		//
1102 		updateVipPool(msg.sender);
1103         emit Deposit(msg.sender, _pid, _amount);
1104     }
1105 	
1106 
1107     function getReward(uint256 _pid) public  {
1108 
1109 		PoolInfo storage pool = poolInfo[_pid];
1110         UserInfo storage user = userInfo[_pid][msg.sender];
1111         uint256 accLefPerShare = pool.accLefPerShare;
1112         uint256 lpSupply = pool.totalPool;
1113         if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
1114             uint256 multiplier =  getMultiplier(pool.lastRewardTime, block.timestamp);
1115             uint256 lefReward = multiplier.mul(rewardRate).mul(pool.allocPoint).div(totalAllocPoint);
1116             accLefPerShare = pool.accLefPerShare.add(lefReward.mul(10e18).div(lpSupply));
1117         }
1118         uint256 reward = user.amount.mul((accLefPerShare).sub(user.userRewardPerTokenPaid)).div(1e18).add(user.reward);
1119 	
1120         if (reward > 0) {
1121 			safeLefTransfer(msg.sender, reward);
1122 			user.rewardPaid = user.rewardPaid.add(reward);
1123 			user.reward = 0;
1124             emit RewardPaid(msg.sender, reward);
1125         }		
1126 		user.userRewardPerTokenPaid = accLefPerShare;
1127     }
1128 	
1129 
1130 
1131     // Withdraw LP tokens from MasterChef.
1132     function withdraw(uint256 _pid, uint256 _amount) public checkhalve{
1133 		
1134 		
1135 		UserInfo storage user = userInfo[_pid][msg.sender];
1136 		if(_pid != 0 && _pid < 3){
1137 			require(block.timestamp > DURATIONS[_pid].add(user.updateTime),"");	
1138 		}
1139 		
1140         PoolInfo storage pool = poolInfo[_pid];
1141         
1142         require(user.amount >= _amount, "withdraw: not good");
1143         updatePool(_pid,msg.sender);
1144                
1145 
1146 		safeLefTransfer(msg.sender, user.reward);
1147 		user.reward = 0;
1148 		user.rewardPaid = user.rewardPaid.add(user.reward);
1149 		emit RewardPaid(msg.sender, user.rewardPaid);
1150         if(_amount > 0) {
1151             user.amount = user.amount.sub(_amount);
1152 
1153             pool.lpToken.safeTransfer(address(msg.sender), _amount);
1154 			
1155 			
1156 			pool.totalPool -= _amount;   
1157 			
1158 	
1159 			address _referrer = users[msg.sender].referrer;
1160 			for(uint256 i = 0;i<2;i++){
1161 				if(_referrer!= address(0) && isUserExists(_referrer)){
1162 					users[_referrer].referAmount[i] -= _amount;					
1163 					_referrer = users[_referrer].referrer;
1164 				}
1165 			}	
1166         }
1167 		updateVipPool(msg.sender);
1168         emit Withdraw(msg.sender, _pid, _amount);
1169     }
1170 
1171     // Withdraw without caring about rewards. EMERGENCY ONLY.
1172    // function emergencyWithdraw(uint256 _pid) public {
1173    //     PoolInfo storage pool = poolInfo[_pid];
1174     //    UserInfo storage user = userInfo[_pid][msg.sender];
1175    //     pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1176    //     emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1177   //      user.amount = 0;
1178    // }
1179 
1180     // Safe lef transfer function, just in case if rounding error causes pool to not have enough lefs.
1181     function safeLefTransfer(address _to, uint256 _amount) internal {
1182         uint256 lefBal = lef.balanceOf(address(this));
1183         if (_amount > lefBal) {
1184             lef.transfer(_to, lefBal);
1185         } else {
1186             lef.transfer(_to, _amount);
1187         }
1188     }   
1189 	modifier checkhalve(){
1190         if (totalMinted >= 500000 *1e18) {
1191 			
1192 	//		initreward = initreward.mul(50).div(100);
1193            rewardRate = rewardRate.mul(90).div(100);
1194 		   totalMinted = 0;
1195     //        periodFinish = periodFinish.add(DURATION);
1196            
1197         }
1198        _;
1199    }
1200 	
1201 	modifier checkStart(){
1202        require(block.timestamp  > starttime,"not start");
1203        _;
1204     }
1205 
1206     // Update dev address by the previous dev.
1207 
1208 }