1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.7.6;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 library SafeMath {
34     /**
35      * @dev Returns the addition of two unsigned integers, reverting on
36      * overflow.
37      *
38      * Counterpart to Solidity's `+` operator.
39      *
40      * Requirements:
41      *
42      * - Addition cannot overflow.
43      */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      *
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `*` operator.
87      *
88      * Requirements:
89      *
90      * - Multiplication cannot overflow.
91      */
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
94         // benefit is lost if 'b' is also tested.
95         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
96         if (a == 0) {
97             return 0;
98         }
99 
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b > 0, errorMessage);
136         uint256 c = a / b;
137         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return mod(a, b, "SafeMath: modulo by zero");
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts with custom message when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b != 0, errorMessage);
172         return a % b;
173     }
174     
175     function ceil(uint a, uint m) internal pure returns (uint r) {
176         return (a + m - 1) / m * m;
177     }
178 }
179 
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address payable) {
182         return msg.sender;
183     }
184 
185     function _msgData() internal view virtual returns (bytes memory) {
186         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
187         return msg.data;
188     }
189 }
190 
191 abstract contract Ownable is Context {
192     address private _owner;
193 
194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196     /**
197      * @dev Initializes the contract setting the deployer as the initial owner.
198      */
199     constructor () {
200         _owner = 0x4c9BC793716e8dC05d1F48D8cA8f84318Ec3043C;
201         emit OwnershipTransferred(address(0), _owner);
202     }
203 
204     /**
205      * @dev Returns the address of the current owner.
206      */
207     function owner() public view returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         require(_owner == _msgSender(), "Ownable: caller is not the owner");
216         _;
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
227         emit OwnershipTransferred(_owner, address(0));
228         _owner = address(0);
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Can only be called by the current owner.
234      */
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(newOwner != address(0), "Ownable: new owner is the zero address");
237         emit OwnershipTransferred(_owner, newOwner);
238         _owner = newOwner;
239     }
240 }
241 
242 
243 interface IERC20 {
244     /**
245      * @dev Returns the amount of tokens in existence.
246      */
247     function totalSupply() external view returns (uint256);
248 
249     /**
250      * @dev Returns the amount of tokens owned by `account`.
251      */
252     function balanceOf(address account) external view returns (uint256);
253 
254     /**
255      * @dev Moves `amount` tokens from the caller's account to `recipient`.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * Emits a {Transfer} event.
260      */
261     function transfer(address recipient, uint256 amount) external returns (bool);
262 
263     /**
264      * @dev Returns the remaining number of tokens that `spender` will be
265      * allowed to spend on behalf of `owner` through {transferFrom}. This is
266      * zero by default.
267      *
268      * This value changes when {approve} or {transferFrom} are called.
269      */
270     function allowance(address owner, address spender) external view returns (uint256);
271 
272     /**
273      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * IMPORTANT: Beware that changing an allowance with this method brings the risk
278      * that someone may use both the old and the new allowance by unfortunate
279      * transaction ordering. One possible solution to mitigate this race
280      * condition is to first reduce the spender's allowance to 0 and set the
281      * desired value afterwards:
282      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
283      *
284      * Emits an {Approval} event.
285      */
286     function approve(address spender, uint256 amount) external returns (bool);
287 
288     /**
289      * @dev Moves `amount` tokens from `sender` to `recipient` using the
290      * allowance mechanism. `amount` is then deducted from the caller's
291      * allowance.
292      *
293      * Returns a boolean value indicating whether the operation succeeded.
294      *
295      * Emits a {Transfer} event.
296      */
297     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Emitted when `value` tokens are moved from one account (`from`) to
301      * another (`to`).
302      *
303      * Note that `value` may be zero.
304      */
305     event Transfer(address indexed from, address indexed to, uint256 value);
306 
307     /**
308      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
309      * a call to {approve}. `value` is the new allowance.
310      */
311     event Approval(address indexed owner, address indexed spender, uint256 value);
312 }
313 
314 library SafeERC20 {
315     using SafeMath for uint256;
316     using Address for address;
317 
318     function safeTransfer(IERC20 token, address to, uint256 value) internal {
319         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
320     }
321 
322     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
323         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
324     }
325 
326     /**
327      * @dev Deprecated. This function has issues similar to the ones found in
328      * {IERC20-approve}, and its usage is discouraged.
329      *
330      * Whenever possible, use {safeIncreaseAllowance} and
331      * {safeDecreaseAllowance} instead.
332      */
333     function safeApprove(IERC20 token, address spender, uint256 value) internal {
334         // safeApprove should only be called when setting an initial allowance,
335         // or when resetting it to zero. To increase and decrease it, use
336         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
337         // solhint-disable-next-line max-line-length
338         require((value == 0) || (token.allowance(address(this), spender) == 0),
339             "SafeERC20: approve from non-zero to non-zero allowance"
340         );
341         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
342     }
343 
344     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
345         uint256 newAllowance = token.allowance(address(this), spender).add(value);
346         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
347     }
348 
349     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
350         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
351         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
352     }
353 
354     /**
355      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
356      * on the return value: the return value is optional (but if data is returned, it must not be false).
357      * @param token The token targeted by the call.
358      * @param data The call data (encoded using abi.encode or one of its variants).
359      */
360     function _callOptionalReturn(IERC20 token, bytes memory data) private {
361         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
362         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
363         // the target address contains contract code and also asserts for success in the low-level call.
364 
365         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
366         if (returndata.length > 0) { // Return data is optional
367             // solhint-disable-next-line max-line-length
368             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
369         }
370     }
371 }
372 library Address {
373     /**
374      * @dev Returns true if `account` is a contract.
375      *
376      * [IMPORTANT]
377      * ====
378      * It is unsafe to assume that an address for which this function returns
379      * false is an externally-owned account (EOA) and not a contract.
380      *
381      * Among others, `isContract` will return false for the following
382      * types of addresses:
383      *
384      *  - an externally-owned account
385      *  - a contract in construction
386      *  - an address where a contract will be created
387      *  - an address where a contract lived, but was destroyed
388      * ====
389      */
390     function isContract(address account) internal view returns (bool) {
391         // This method relies on extcodesize, which returns 0 for contracts in
392         // construction, since the code is only stored at the end of the
393         // constructor execution.
394 
395         uint256 size;
396         // solhint-disable-next-line no-inline-assembly
397         assembly { size := extcodesize(account) }
398         return size > 0;
399     }
400 
401     /**
402      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
403      * `recipient`, forwarding all available gas and reverting on errors.
404      *
405      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
406      * of certain opcodes, possibly making contracts go over the 2300 gas limit
407      * imposed by `transfer`, making them unable to receive funds via
408      * `transfer`. {sendValue} removes this limitation.
409      *
410      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
411      *
412      * IMPORTANT: because control is transferred to `recipient`, care must be
413      * taken to not create reentrancy vulnerabilities. Consider using
414      * {ReentrancyGuard} or the
415      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
416      */
417     function sendValue(address payable recipient, uint256 amount) internal {
418         require(address(this).balance >= amount, "Address: insufficient balance");
419 
420         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
421         (bool success, ) = recipient.call{ value: amount }("");
422         require(success, "Address: unable to send value, recipient may have reverted");
423     }
424 
425     /**
426      * @dev Performs a Solidity function call using a low level `call`. A
427      * plain`call` is an unsafe replacement for a function call: use this
428      * function instead.
429      *
430      * If `target` reverts with a revert reason, it is bubbled up by this
431      * function (like regular Solidity function calls).
432      *
433      * Returns the raw returned data. To convert to the expected return value,
434      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
435      *
436      * Requirements:
437      *
438      * - `target` must be a contract.
439      * - calling `target` with `data` must not revert.
440      *
441      * _Available since v3.1._
442      */
443     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
444       return functionCall(target, data, "Address: low-level call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
449      * `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
454         return functionCallWithValue(target, data, 0, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but also transferring `value` wei to `target`.
460      *
461      * Requirements:
462      *
463      * - the calling contract must have an ETH balance of at least `value`.
464      * - the called Solidity function must be `payable`.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
469         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
474      * with `errorMessage` as a fallback revert reason when `target` reverts.
475      *
476      * _Available since v3.1._
477      */
478     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
479         require(address(this).balance >= value, "Address: insufficient balance for call");
480         require(isContract(target), "Address: call to non-contract");
481 
482         // solhint-disable-next-line avoid-low-level-calls
483         (bool success, bytes memory returndata) = target.call{ value: value }(data);
484         return _verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but performing a static call.
490      *
491      * _Available since v3.3._
492      */
493     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
494         return functionStaticCall(target, data, "Address: low-level static call failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
499      * but performing a static call.
500      *
501      * _Available since v3.3._
502      */
503     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
504         require(isContract(target), "Address: static call to non-contract");
505 
506         // solhint-disable-next-line avoid-low-level-calls
507         (bool success, bytes memory returndata) = target.staticcall(data);
508         return _verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but performing a delegate call.
514      *
515      * _Available since v3.3._
516      */
517     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
518         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a delegate call.
524      *
525      * _Available since v3.3._
526      */
527     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
528         require(isContract(target), "Address: delegate call to non-contract");
529 
530         // solhint-disable-next-line avoid-low-level-calls
531         (bool success, bytes memory returndata) = target.delegatecall(data);
532         return _verifyCallResult(success, returndata, errorMessage);
533     }
534 
535     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
536         if (success) {
537             return returndata;
538         } else {
539             // Look for revert reason and bubble it up if present
540             if (returndata.length > 0) {
541                 // The easiest way to bubble the revert reason is using memory via assembly
542 
543                 // solhint-disable-next-line no-inline-assembly
544                 assembly {
545                     let returndata_size := mload(returndata)
546                     revert(add(32, returndata), returndata_size)
547                 }
548             } else {
549                 revert(errorMessage);
550             }
551         }
552     }
553 }
554 abstract contract ReentrancyGuard {
555     // Booleans are more expensive than uint256 or any type that takes up a full
556     // word because each write operation emits an extra SLOAD to first read the
557     // slot's contents, replace the bits taken up by the boolean, and then write
558     // back. This is the compiler's defense against contract upgrades and
559     // pointer aliasing, and it cannot be disabled.
560 
561     // The values being non-zero value makes deployment a bit more expensive,
562     // but in exchange the refund on every call to nonReentrant will be lower in
563     // amount. Since refunds are capped to a percentage of the total
564     // transaction's gas, it is best to keep them low in cases like this one, to
565     // increase the likelihood of the full refund coming into effect.
566     uint256 private constant _NOT_ENTERED = 1;
567     uint256 private constant _ENTERED = 2;
568 
569     uint256 private _status;
570 
571     constructor () {
572         _status = _NOT_ENTERED;
573     }
574 
575     /**
576      * @dev Prevents a contract from calling itself, directly or indirectly.
577      * Calling a `nonReentrant` function from another `nonReentrant`
578      * function is not supported. It is possible to prevent this from happening
579      * by making the `nonReentrant` function external, and make it call a
580      * `private` function that does the actual work.
581      */
582     modifier nonReentrant() {
583         // On the first call to nonReentrant, _notEntered will be true
584         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
585 
586         // Any calls to nonReentrant after this point will fail
587         _status = _ENTERED;
588 
589         _;
590 
591         // By storing the original value once again, a refund is triggered (see
592         // https://eips.ethereum.org/EIPS/eip-2200)
593         _status = _NOT_ENTERED;
594     }
595 }
596 
597 abstract contract IRewardDistributionRecipient is Ownable {
598     address rewardDistribution;
599 
600     modifier onlyRewardDistribution() {
601         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
602         _;
603     }
604 
605     function setRewardDistributionAdmin(address _rewardDistribution)
606         internal
607     {
608         require(rewardDistribution == address(0), "Reward distribution Admin already set");
609         rewardDistribution = _rewardDistribution;
610     }
611     
612     function updateRewardDistributionAdmin(address _rewardDistribution) public onlyOwner {
613         require(rewardDistribution == address(0), "Reward distribution Admin already set");
614         rewardDistribution = _rewardDistribution;
615     }
616     
617 }
618 
619 contract GoldFarmFaaS is IRewardDistributionRecipient, ReentrancyGuard {
620     using SafeERC20 for IERC20;
621     using SafeMath for uint256;
622     using Address for address;
623     
624     IERC20 public rewardToken;// BDOG ERC20
625     IERC20 public rewardToken1;// GOLD ERC20
626     IERC20 public lpToken; // FEG ERC20
627     
628     address public devAddy = 0xdaC47d05e1aAa9Bd4DA120248E8e0d7480365CFB;//collects pool use fee
629     uint256 public devtxfee = 1; //Fee for pool use, sent to GOLD farming pool
630     uint256 public txfee = 2; //Amount of frictionless rewards of the LP token 
631     
632      uint256 public duration = 365 days;
633     uint256 public duration1 = 30 days;
634 
635     uint256 public periodFinish = 0;
636     uint256 public rewardRate = 0;
637     uint256 public lastUpdateTime;
638     uint256 public rewardPerTokenStored;
639     mapping(address => uint256) public userRewardPerTokenPaid;
640     mapping(address => uint256) public rewards;
641     
642     uint256 public periodFinish1 = 0;
643     uint256 public rewardRate1 = 0;
644     uint256 public lastUpdateTime1;
645     uint256 public rewardPerTokenStored1;
646     mapping(address => uint256) public userRewardPerTokenPaid1;
647     mapping(address => uint256) public rewards1;
648 
649     
650     uint256 private _totalSupply;
651     mapping(address => uint256) private _balances;
652     
653     mapping(address => uint256) public lpTokenReward;
654 
655     event RewardAdded(uint256 reward);
656     event Farmed(address indexed user, uint256 amount);
657     event Withdrawn(address indexed user, uint256 amount);
658     event RewardPaid(address indexed user, uint256 reward);
659     
660     address[] public farmers;
661 
662     constructor(address _lpToken, address _rewardToken, address _rewardToken1) {
663         rewardToken = IERC20(_rewardToken);
664         rewardToken1 = IERC20(_rewardToken1);
665         lpToken = IERC20(_lpToken);
666         setRewardDistributionAdmin(msg.sender);
667 
668     }
669 
670     modifier updateReward(address account) {
671         rewardPerTokenStored = rewardPerToken();
672         lastUpdateTime = lastTimeRewardApplicable();
673         if (account != address(0)) {
674             rewards[account] = earned(account);
675             userRewardPerTokenPaid[account] = rewardPerTokenStored;
676         }
677         _;
678     }
679     
680     modifier updateReward1(address account) {
681         rewardPerTokenStored1 = rewardPerToken1();
682         lastUpdateTime1 = lastTimeRewardApplicable1();
683         if (account != address(0)) {
684             rewards1[account] = earned1(account);
685             userRewardPerTokenPaid1[account] = rewardPerTokenStored1;
686         }
687         _;
688     }
689 
690 
691     modifier noContract(address account) {
692         require(Address.isContract(account) == false, "Contracts are not allowed to interact with the farm");
693         _;
694     }
695     
696     function setdevAddy(address _addy) public onlyOwner {
697         require(_addy != address(0), " Setting 0 as Addy "); 
698         devAddy = _addy;
699     }
700 
701     function totalSupply() public view returns (uint256) {
702         return _totalSupply;
703     }
704 
705     function balanceOf(address account) public view returns (uint256) {
706         return _balances[account];
707     }
708     
709     function recoverLostTokensAfterFarmExpired(IERC20 _token, uint256 amount) external onlyOwner {
710         // Recover lost tokens can only be used after farming duration expires
711         require(duration < block.timestamp, "Cannot use if farm is live");
712         _token.safeTransfer(owner(), amount);
713     }
714     
715     receive() external payable {
716         // Prevent ETH from being sent to the farming contract
717         revert();
718     }
719 
720     function lastTimeRewardApplicable() public view returns (uint256) {
721         return Math.min(block.timestamp, periodFinish);
722     }
723     
724     function lastTimeRewardApplicable1() public view returns (uint256) {
725         return Math.min(block.timestamp, periodFinish1);
726     }
727     
728     function rewardPerToken() public view returns (uint256) {
729         if (totalSupply() == 0) {
730             return rewardPerTokenStored;
731         }
732 
733         return
734             rewardPerTokenStored.add(
735                 lastTimeRewardApplicable()
736                     .sub(lastUpdateTime)
737                     .mul(rewardRate)
738                     .mul(1e9)
739                     .div(totalSupply())
740             );
741     }
742     
743     function rewardPerToken1() public view returns (uint256) {
744         if (totalSupply() == 0) {
745             return rewardPerTokenStored1;
746         }
747 
748         return
749             rewardPerTokenStored1.add(
750                 lastTimeRewardApplicable1()
751                     .sub(lastUpdateTime1)
752                     .mul(rewardRate1)
753                     .mul(1e9)
754                     .div(totalSupply())
755             );
756     }
757 
758 
759 
760     function earned(address account) public view returns (uint256) {
761         return
762             balanceOf(account)
763                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
764                 .div(1e18)
765                 .add(rewards[account]);
766     }
767     
768     function earned1(address account) public view returns (uint256) {
769         return
770             balanceOf(account)
771                 .mul(rewardPerToken1().sub(userRewardPerTokenPaid1[account]))
772                 .div(1e9)
773                 .add(rewards1[account]);
774     }
775     
776     function isStakeholder(address _address)
777        public
778        view
779        returns(bool)
780    {
781        for (uint256 s = 0; s < farmers.length; s += 1){
782            if (_address == farmers[s]) return (true);
783        }
784        return (false);
785    }
786    
787    function addStakeholder(address _stakeholder)
788        public
789    {
790        (bool _isStakeholder) = isStakeholder(_stakeholder);
791        if(!_isStakeholder) {
792            farmers.push(_stakeholder);
793        }
794    }
795 
796     function farm(uint256 amount) external updateReward(msg.sender) noContract(msg.sender) nonReentrant {
797         require(amount > 0, "Cannot farm nothing");
798 
799         lpToken.safeTransferFrom(msg.sender, address(this), amount);
800         
801         uint256 devtax = amount.mul(devtxfee).div(100);
802         uint256 _txfee = amount.mul(txfee).div(100);
803         
804         lpToken.safeTransfer(address(devAddy), devtax);
805         
806         uint256 finalAmount = amount.sub(_txfee).sub(devtax);
807         
808         _totalSupply = _totalSupply.add(finalAmount);
809         _balances[msg.sender] = _balances[msg.sender].add(finalAmount);
810         
811         addStakeholder(msg.sender);
812         
813         emit Farmed(msg.sender,finalAmount);
814     }
815 
816     function withdraw(uint256 amount) public updateReward(msg.sender) noContract(msg.sender) nonReentrant {
817         require(amount > 0, "Cannot withdraw nothing");
818         
819         _totalSupply = _totalSupply.sub(amount);
820         _balances[msg.sender] = _balances[msg.sender].sub(amount);
821         lpToken.safeTransfer(msg.sender, amount);
822         
823         emit Withdrawn(msg.sender, amount);
824         
825     }
826 
827     function exit() external {
828         withdraw(balanceOf(msg.sender));
829         getReward();
830         getReward1();
831         }
832 
833     function getReward() public updateReward(msg.sender) noContract(msg.sender) {
834         uint256 reward = earned(msg.sender);
835         if (reward > 0) {
836             rewards[msg.sender] = 0;
837             rewardToken.safeTransfer(msg.sender, reward);
838             emit RewardPaid(msg.sender, reward);
839         }
840     }
841     
842     function getReward1() public updateReward1(msg.sender) noContract(msg.sender) {
843         uint256 reward = earned1(msg.sender);
844         if (reward > 0) {
845             rewards1[msg.sender] = 0;
846             rewardToken1.safeTransfer(msg.sender, reward);
847             emit RewardPaid(msg.sender, reward);
848         }
849     }
850     
851     function setFarmRewards(uint256 reward, uint256 _duration)
852         public
853         onlyRewardDistribution
854         nonReentrant
855         updateReward(address(0))
856     {
857         require(_duration > 0, "Duration must not be 0");
858         if(rewardRate.mul(duration) <= rewardToken.balanceOf(address(this))){
859             duration = _duration.mul(1 days);
860             if (block.timestamp >= periodFinish) {
861                 rewardRate = reward.div(duration);
862             } else {
863                 uint256 remaining = periodFinish.sub(block.timestamp);
864                 uint256 leftover = remaining.mul(rewardRate);
865                 rewardRate = reward.add(leftover).div(duration);
866             }
867             lastUpdateTime = block.timestamp;
868             periodFinish = block.timestamp.add(duration);
869             require(rewardRate.mul(duration) <= rewardToken.balanceOf(address(this)), "Insufficient reward");
870             emit RewardAdded(reward);
871         }
872     }
873     
874     function setFarmRewards1(uint256 reward, uint256 _duration2)
875         public
876         onlyRewardDistribution
877         nonReentrant
878         updateReward1(address(0))
879     {
880         require(_duration2 > 0, "Duration must not be 0");
881         if(rewardRate1.mul(duration1) <= rewardToken1.balanceOf(address(this))){
882             duration1 = _duration2.mul(1 days);
883             if (block.timestamp >= periodFinish1) {
884                 rewardRate1 = reward.div(duration1);
885             } else {
886                 uint256 remaining = periodFinish1.sub(block.timestamp);
887                 uint256 leftover = remaining.mul(rewardRate1);
888                 rewardRate1 = reward.add(leftover).div(duration1);
889             }
890             lastUpdateTime1 = block.timestamp;
891             periodFinish1 = block.timestamp.add(duration1);
892             require(rewardRate1.mul(duration1) <= rewardToken1.balanceOf(address(this)), "Insufficient reward");
893             emit RewardAdded(reward);
894         }
895     }
896     
897     
898     function DisributeLPTxFunds1() public { // distribute any TX rewards tokens sent to pool for tokens with TX rewards
899         
900         
901         uint256 aclaimed = getAllUnclaimed();
902         uint256 balanceOfContract = lpToken.balanceOf(address(this));
903         uint256 transferToAmount = balanceOfContract.sub(_totalSupply.add(aclaimed));
904         
905         if(transferToAmount > 0 ){
906             for (uint256 s = 0; s < farmers.length; s++){
907                  address abc = farmers[s];
908                  uint256 userShare  = onePercent(transferToAmount).mul(balanceOf(abc)).div(_totalSupply).mul(100); 
909                    
910                    lpTokenReward[abc] = lpTokenReward[abc].add(userShare);
911                    
912                    emit RewardAdded(userShare);
913            }
914         }
915     }
916     
917     function ClaimAllRewards() public {
918         ClaimLPReward();
919         getReward();
920         getReward1();
921         DisributeLPTxFunds1();
922     }
923     
924     function getAllUnclaimed() public view returns (uint256){
925         uint256 rewardss = 0;
926         for (uint256 s = 0; s < farmers.length; s += 1){
927             address abcd = farmers[s];
928             rewardss = rewardss.add(lpTokenReward[abcd]);
929        }
930        
931        return rewardss;
932     }
933     
934     function onePercent(uint256 _tokens) private pure returns (uint256){
935         uint256 roundValue = _tokens.ceil(100);
936         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
937         return onePercentofTokens;
938     }
939     
940     function ClaimLPReward() public {
941         address _addy = msg.sender;
942         
943         if(lpTokenReward[_addy] > 0 ){
944             
945             lpToken.safeTransfer(msg.sender, lpTokenReward[_addy]);
946             lpTokenReward[_addy] = 0;
947         }
948     }
949 }