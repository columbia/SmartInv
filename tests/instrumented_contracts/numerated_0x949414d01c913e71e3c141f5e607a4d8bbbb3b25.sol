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
31 // File: @openzeppelin/contracts/math/SafeMath.sol
32 
33 pragma solidity ^0.5.0;
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
56      * - Addition cannot overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      * - Subtraction cannot overflow.
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         return sub(a, b, "SafeMath: subtraction overflow");
76     }
77 
78     /**
79      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
80      * overflow (when the result is negative).
81      *
82      * Counterpart to Solidity's `-` operator.
83      *
84      * Requirements:
85      * - Subtraction cannot overflow.
86      *
87      * _Available since v2.4.0._
88      */
89     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the multiplication of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `*` operator.
101      *
102      * Requirements:
103      * - Multiplication cannot overflow.
104      */
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107         // benefit is lost if 'b' is also tested.
108         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
109         if (a == 0) {
110             return 0;
111         }
112 
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the integer division of two unsigned integers. Reverts on
121      * division by zero. The result is rounded towards zero.
122      *
123      * Counterpart to Solidity's `/` operator. Note: this function uses a
124      * `revert` opcode (which leaves remaining gas untouched) while Solidity
125      * uses an invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator. Note: this function uses a
139      * `revert` opcode (which leaves remaining gas untouched) while Solidity
140      * uses an invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      *
145      * _Available since v2.4.0._
146      */
147     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         // Solidity only automatically asserts when dividing by 0
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return mod(a, b, "SafeMath: modulo by zero");
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts with custom message when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      *
182      * _Available since v2.4.0._
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/GSN/Context.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /*
195  * @dev Provides information about the current execution context, including the
196  * sender of the transaction and its data. While these are generally available
197  * via msg.sender and msg.data, they should not be accessed in such a direct
198  * manner, since when dealing with GSN meta-transactions the account sending and
199  * paying for execution may not be the actual sender (as far as an application
200  * is concerned).
201  *
202  * This contract is only required for intermediate, library-like contracts.
203  */
204 contract Context {
205     // Empty internal constructor, to prevent people from mistakenly deploying
206     // an instance of this contract, which should be used via inheritance.
207     constructor () internal { }
208     // solhint-disable-previous-line no-empty-blocks
209 
210     function _msgSender() internal view returns (address payable) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view returns (bytes memory) {
215         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
216         return msg.data;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/ownership/Ownable.sol
221 
222 pragma solidity ^0.5.0;
223 
224 /**
225  * @dev Contract module which provides a basic access control mechanism, where
226  * there is an account (an owner) that can be granted exclusive access to
227  * specific functions.
228  *
229  * This module is used through inheritance. It will make available the modifier
230  * `onlyOwner`, which can be applied to your functions to restrict their use to
231  * the owner.
232  */
233 contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor () internal {
242         _owner = _msgSender();
243         emit OwnershipTransferred(address(0), _owner);
244     }
245 
246     /**
247      * @dev Returns the address of the current owner.
248      */
249     function owner() public view returns (address) {
250         return _owner;
251     }
252 
253     /**
254      * @dev Throws if called by any account other than the owner.
255      */
256     modifier onlyOwner() {
257         require(isOwner(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     /**
262      * @dev Returns true if the caller is the current owner.
263      */
264     function isOwner() public view returns (bool) {
265         return _msgSender() == _owner;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public onlyOwner {
285         _transferOwnership(newOwner);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      */
291     function _transferOwnership(address newOwner) internal {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         emit OwnershipTransferred(_owner, newOwner);
294         _owner = newOwner;
295     }
296 }
297 
298 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
299 
300 pragma solidity ^0.5.0;
301 
302 /**
303  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
304  * the optional functions; to access them see {ERC20Detailed}.
305  */
306 interface IERC20 {
307     /**
308      * @dev Returns the amount of tokens in existence.
309      */
310     function totalSupply() external view returns (uint256);
311 
312     /**
313      * @dev Returns the amount of tokens owned by `account`.
314      */
315     function balanceOf(address account) external view returns (uint256);
316 
317     /**
318      * @dev Moves `amount` tokens from the caller's account to `recipient`.
319      *
320      * Returns a boolean value indicating whether the operation succeeded.
321      *
322      * Emits a {Transfer} event.
323      */
324     function transfer(address recipient, uint256 amount) external returns (bool);
325     function mint(address account, uint amount) external;
326 
327     /**
328      * @dev Returns the remaining number of tokens that `spender` will be
329      * allowed to spend on behalf of `owner` through {transferFrom}. This is
330      * zero by default.
331      *
332      * This value changes when {approve} or {transferFrom} are called.
333      */
334     function allowance(address owner, address spender) external view returns (uint256);
335 
336     /**
337      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * IMPORTANT: Beware that changing an allowance with this method brings the risk
342      * that someone may use both the old and the new allowance by unfortunate
343      * transaction ordering. One possible solution to mitigate this race
344      * condition is to first reduce the spender's allowance to 0 and set the
345      * desired value afterwards:
346      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
347      *
348      * Emits an {Approval} event.
349      */
350     function approve(address spender, uint256 amount) external returns (bool);
351 
352     /**
353      * @dev Moves `amount` tokens from `sender` to `recipient` using the
354      * allowance mechanism. `amount` is then deducted from the caller's
355      * allowance.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Emitted when `value` tokens are moved from one account (`from`) to
365      * another (`to`).
366      *
367      * Note that `value` may be zero.
368      */
369     event Transfer(address indexed from, address indexed to, uint256 value);
370 
371     /**
372      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
373      * a call to {approve}. `value` is the new allowance.
374      */
375     event Approval(address indexed owner, address indexed spender, uint256 value);
376 }
377 
378 // File: @openzeppelin/contracts/utils/Address.sol
379 
380 pragma solidity ^0.5.5;
381 
382 /**
383  * @dev Collection of functions related to the address type
384  */
385 library Address {
386     /**
387      * @dev Returns true if `account` is a contract.
388      *
389      * This test is non-exhaustive, and there may be false-negatives: during the
390      * execution of a contract's constructor, its address will be reported as
391      * not containing a contract.
392      *
393      * IMPORTANT: It is unsafe to assume that an address for which this
394      * function returns false is an externally-owned account (EOA) and not a
395      * contract.
396      */
397     function isContract(address account) internal view returns (bool) {
398         // This method relies in extcodesize, which returns 0 for contracts in
399         // construction, since the code is only stored at the end of the
400         // constructor execution.
401 
402         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
403         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
404         // for accounts without code, i.e. `keccak256('')`
405         bytes32 codehash;
406         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
407         // solhint-disable-next-line no-inline-assembly
408         assembly { codehash := extcodehash(account) }
409         return (codehash != 0x0 && codehash != accountHash);
410     }
411 
412     /**
413      * @dev Converts an `address` into `address payable`. Note that this is
414      * simply a type cast: the actual underlying value is not changed.
415      *
416      * _Available since v2.4.0._
417      */
418     function toPayable(address account) internal pure returns (address payable) {
419         return address(uint160(account));
420     }
421 
422     /**
423      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
424      * `recipient`, forwarding all available gas and reverting on errors.
425      *
426      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
427      * of certain opcodes, possibly making contracts go over the 2300 gas limit
428      * imposed by `transfer`, making them unable to receive funds via
429      * `transfer`. {sendValue} removes this limitation.
430      *
431      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
432      *
433      * IMPORTANT: because control is transferred to `recipient`, care must be
434      * taken to not create reentrancy vulnerabilities. Consider using
435      * {ReentrancyGuard} or the
436      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
437      *
438      * _Available since v2.4.0._
439      */
440     function sendValue(address payable recipient, uint256 amount) internal {
441         require(address(this).balance >= amount, "Address: insufficient balance");
442 
443         // solhint-disable-next-line avoid-call-value
444         (bool success, ) = recipient.call.value(amount)("");
445         require(success, "Address: unable to send value, recipient may have reverted");
446     }
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
450 
451 pragma solidity ^0.5.0;
452 
453 
454 
455 
456 /**
457  * @title SafeERC20
458  * @dev Wrappers around ERC20 operations that throw on failure (when the token
459  * contract returns false). Tokens that return no value (and instead revert or
460  * throw on failure) are also supported, non-reverting calls are assumed to be
461  * successful.
462  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
463  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
464  */
465 library SafeERC20 {
466     using SafeMath for uint256;
467     using Address for address;
468 
469     function safeTransfer(IERC20 token, address to, uint256 value) internal {
470         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
471     }
472 
473     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
474         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
475     }
476 
477     function safeApprove(IERC20 token, address spender, uint256 value) internal {
478         // safeApprove should only be called when setting an initial allowance,
479         // or when resetting it to zero. To increase and decrease it, use
480         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
481         // solhint-disable-next-line max-line-length
482         require((value == 0) || (token.allowance(address(this), spender) == 0),
483             "SafeERC20: approve from non-zero to non-zero allowance"
484         );
485         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
486     }
487 
488     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
489         uint256 newAllowance = token.allowance(address(this), spender).add(value);
490         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
491     }
492 
493     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
494         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
495         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
496     }
497 
498     /**
499      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
500      * on the return value: the return value is optional (but if data is returned, it must not be false).
501      * @param token The token targeted by the call.
502      * @param data The call data (encoded using abi.encode or one of its variants).
503      */
504     function callOptionalReturn(IERC20 token, bytes memory data) private {
505         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
506         // we're implementing it ourselves.
507 
508         // A Solidity high level call has three parts:
509         //  1. The target address is checked to verify it contains contract code
510         //  2. The call itself is made, and success asserted
511         //  3. The return value is decoded, which in turn checks the size of the returned data.
512         // solhint-disable-next-line max-line-length
513         require(address(token).isContract(), "SafeERC20: call to non-contract");
514 
515         // solhint-disable-next-line avoid-low-level-calls
516         (bool success, bytes memory returndata) = address(token).call(data);
517         require(success, "SafeERC20: low-level call failed");
518 
519         if (returndata.length > 0) { // Return data is optional
520             // solhint-disable-next-line max-line-length
521             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
522         }
523     }
524 }
525 
526 // File: contracts/IRewardDistributionRecipient.sol
527 
528 pragma solidity ^0.5.0;
529 
530 
531 
532 contract IRewardDistributionRecipient is Ownable {
533     address rewardDistribution;
534 
535     function notifyRewardAmount(uint256 reward) external;
536 
537     modifier onlyRewardDistribution() {
538         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
539         _;
540     }
541 
542     function setRewardDistribution(address _rewardDistribution)
543         external
544         onlyOwner
545     {
546         rewardDistribution = _rewardDistribution;
547     }
548 }
549 
550 // File: contracts/CurveRewards.sol
551 
552 pragma solidity ^0.5.0;
553 
554 
555 
556 
557 
558 
559 contract LPTokenWrapper {
560     using SafeMath for uint256;
561     using SafeERC20 for IERC20;
562 
563     IERC20 public bpt = IERC20(0xCBa435408f3B3A7ad231e0083d7eE2e9ec03764f);
564 
565     uint256 private _totalSupply;
566     mapping(address => uint256) private _balances;
567 
568     function totalSupply() public view returns (uint256) {
569         return _totalSupply;
570     }
571 
572     function balanceOf(address account) public view returns (uint256) {
573         return _balances[account];
574     }
575 
576     function stake(uint256 amount) public {
577         _totalSupply = _totalSupply.add(amount);
578         _balances[msg.sender] = _balances[msg.sender].add(amount);
579         bpt.safeTransferFrom(msg.sender, address(this), amount);
580     }
581 
582     function withdraw(uint256 amount) public {
583         _totalSupply = _totalSupply.sub(amount);
584         _balances[msg.sender] = _balances[msg.sender].sub(amount);
585         bpt.safeTransfer(msg.sender, amount);
586     }
587 }
588 
589 contract dBalancerPool is LPTokenWrapper, IRewardDistributionRecipient {
590 
591     IERC20 public syfi = IERC20(0xdc38a4846d811572452cB4CE747dc9F5F509820f);
592     IERC20 public inv = IERC20(0xfe26bb3644153BCDE31237E76eE337d39291420E);
593     uint256 public constant DURATION = 7 days;
594 
595     uint256 public initreward = 10000*1e18;
596     uint256 public starttime = 1599408000; //utc+8 2020 09-07 00:00:00
597 
598     uint256 public periodFinish = 0;
599     uint256 public rewardRate = 0;
600     uint256 public lastUpdateTime;
601     uint256 public rewardPerTokenStored;
602     mapping(address => uint256) public userRewardPerTokenPaid;
603     mapping(address => uint256) public rewards;
604 
605     /**invitation**/
606     uint256 public oneFactor = 60;
607     uint256 public twoFactor = 30;
608     uint256 public threeFactor = 10;
609     uint256 public invLevel = 3;
610     mapping(address => uint256) public claimRewards;
611     mapping(address => uint256) public claimINVRewards;
612 
613     mapping(address => bytes32) public invCodes;
614     mapping(bytes32 => address) public invRefs;
615     mapping(address => address[]) public invAddrs;
616     mapping(address => address) public isUseCode;
617 
618     bool public isOpenWithdraw = false;
619 
620     event RewardINVPaid(address indexed user, uint256 reward);
621 
622     function openWithdraw() public onlyOwner {
623         isOpenWithdraw = true;
624     }
625 
626     function closeWithdraw() public onlyOwner {
627         isOpenWithdraw = false;
628     }
629 
630     function levelEmergencyChange(uint256 l) public onlyOwner {
631         invLevel = l;
632     }
633 
634     function setInvCode(bytes32 code,bytes32 superCode) public {
635         require(invCodes[msg.sender] == 0);
636         require(invRefs[code] == address(0));
637         require(isOwner() || invRefs[superCode] != address(0));
638         invCodes[msg.sender] = code;
639         invRefs[code] = msg.sender;
640         isUseCode[msg.sender] = invRefs[superCode];
641     }
642 
643     function getInvAddrs(address addr) public view returns(address[] memory){
644         address[] memory list = invAddrs[addr];
645         return list;
646     }
647 
648     function getInvCount(address addr) public view returns(uint256) {
649         return  invAddrs[addr].length;
650     }
651 
652     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart {
653         require(amount > 0, "Cannot stake 0");    
654         /**invitation**/
655         require(isUseCode[msg.sender] != address(0),"Must have a invite code");
656         address superPerson = isUseCode[msg.sender];
657         invAddrs[superPerson].push(msg.sender);
658         /****/
659         super.stake(amount);
660         emit Staked(msg.sender, amount);
661     }
662 
663     function earnedInv(address account) public view returns(uint256) {
664         address[] memory list_1 = invAddrs[account];
665         uint256 total = 0;
666         uint256 curEarn = earned(account).add(claimRewards[account]);
667         for(uint32 i = 0; i<list_1.length; i++){
668             total = total.add(calcInv(list_1[i],oneFactor,curEarn));
669             if(invLevel == 1 || invAddrs[list_1[i]].length == 0){
670                 continue;
671             }
672             address[] memory list_2 = invAddrs[list_1[i]];
673             for(uint32 j = 0; j<list_2.length; j++) {
674                 total = total.add(calcInv(list_2[j],twoFactor,curEarn));
675                 if(invLevel == 2 || invAddrs[list_2[j]].length == 0){
676                     continue;
677                 }
678                 address[] memory list_3 = invAddrs[list_2[j]];
679                 for(uint32 k = 0; k<list_3.length; k++){
680                     total = total.add(calcInv(list_3[k],threeFactor,curEarn));
681                 }
682             } 
683         }
684         return total.sub(claimINVRewards[account]);
685     }
686 
687     function calcInv(address addr,uint256 factor,uint256 cur) internal view returns(uint256) {
688         uint256 total = Math.min(earned(addr).add(claimRewards[addr]), cur);
689         return total.mul(factor).div(100);
690     }
691 
692     function getInvRewards() public {
693         require(isOpenWithdraw == true,"Not open inv claim");
694         uint256 reward = earnedInv(msg.sender);
695         if (reward > 0) {
696             claimINVRewards[msg.sender] = claimINVRewards[msg.sender].add(reward);
697             inv.safeTransfer(msg.sender, reward);
698             emit RewardINVPaid(msg.sender, reward);
699         }
700     }
701 
702     function exit() external {
703         withdraw(balanceOf(msg.sender));
704         getReward();
705         if(isOpenWithdraw == true){
706             getInvRewards();
707         }
708     }
709     /****/
710 
711 
712     event RewardAdded(uint256 reward);
713     event Staked(address indexed user, uint256 amount);
714     event Withdrawn(address indexed user, uint256 amount);
715     event RewardPaid(address indexed user, uint256 reward);
716 
717     modifier updateReward(address account) {
718         rewardPerTokenStored = rewardPerToken();
719         lastUpdateTime = lastTimeRewardApplicable();
720         if (account != address(0)) {
721             rewards[account] = earned(account);
722             userRewardPerTokenPaid[account] = rewardPerTokenStored;
723         }
724         _;
725     }
726 
727     function lastTimeRewardApplicable() public view returns (uint256) {
728         return Math.min(block.timestamp, periodFinish);
729     }
730 
731     function rewardPerToken() public view returns (uint256) {
732         if (totalSupply() == 0) {
733             return rewardPerTokenStored;
734         }
735         return
736             rewardPerTokenStored.add(
737                 lastTimeRewardApplicable()
738                     .sub(lastUpdateTime)
739                     .mul(rewardRate)
740                     .mul(1e18)
741                     .div(totalSupply())
742             );
743     }
744 
745     function earned(address account) public view returns (uint256) {
746         return
747             balanceOf(account)
748                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
749                 .div(1e18)
750                 .add(rewards[account]);
751     }
752 
753     function withdraw(uint256 amount) public updateReward(msg.sender) checkhalve checkStart {
754         require(amount > 0, "Cannot withdraw 0");
755         super.withdraw(amount);
756         emit Withdrawn(msg.sender, amount);
757     }
758 
759     function getReward() public updateReward(msg.sender) checkhalve checkStart {
760         uint256 reward = earned(msg.sender);
761         if (reward > 0) {
762             rewards[msg.sender] = 0;
763             claimRewards[msg.sender] = claimRewards[msg.sender].add(reward);
764             syfi.safeTransfer(msg.sender, reward);
765             emit RewardPaid(msg.sender, reward);
766         }
767     }
768 
769     modifier checkhalve(){
770         if (block.timestamp >= periodFinish && periodFinish != 0) {
771             initreward = initreward.mul(50).div(100); 
772             syfi.mint(address(this),initreward);
773 
774             rewardRate = initreward.div(DURATION);
775             periodFinish = block.timestamp.add(DURATION);
776             emit RewardAdded(initreward);
777         }
778         _;
779     }
780 
781     modifier checkStart(){
782         require(block.timestamp > starttime,"not start");
783         _;
784     }
785 
786 
787     function notifyRewardAmount(uint256 reward)
788         external
789         onlyRewardDistribution
790         updateReward(address(0))
791     {
792         if (block.timestamp >= periodFinish) {
793             rewardRate = reward.div(DURATION);
794         } else {
795             uint256 remaining = periodFinish.sub(block.timestamp);
796             uint256 leftover = remaining.mul(rewardRate);
797             rewardRate = reward.add(leftover).div(DURATION);
798         }
799         syfi.mint(address(this),reward);
800         lastUpdateTime = block.timestamp;
801         if(block.timestamp < starttime){
802             periodFinish = starttime.add(DURATION);
803         }else {
804             periodFinish = block.timestamp.add(DURATION);
805         }
806         emit RewardAdded(reward);
807     }
808 }