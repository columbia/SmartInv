1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     /**
12      * @dev Returns the largest of two numbers.
13      */
14     function max(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a >= b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     function min(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the average of two numbers. The result is rounded towards
27      * zero.
28      */
29     function average(uint256 a, uint256 b) internal pure returns (uint256) {
30         // (a + b) / 2 can overflow, so we distribute
31         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
32     }
33 }
34 
35 // File: @openzeppelin/contracts/math/SafeMath.sol
36 
37 
38 pragma solidity >=0.6.0 <0.8.0;
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations with added overflow
42  * checks.
43  *
44  * Arithmetic operations in Solidity wrap on overflow. This can easily result
45  * in bugs, because programmers usually assume that an overflow raises an
46  * error, which is the standard behavior in high level programming languages.
47  * `SafeMath` restores this intuition by reverting the transaction when an
48  * operation overflows.
49  *
50  * Using this library instead of the unchecked operations eliminates an entire
51  * class of bugs, so it's recommended to use it always.
52  */
53 library SafeMath {
54     /**
55      * @dev Returns the addition of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `+` operator.
59      *
60      * Requirements:
61      *
62      * - Addition cannot overflow.
63      */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a, "SafeMath: addition overflow");
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      *
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         return sub(a, b, "SafeMath: subtraction overflow");
83     }
84 
85     /**
86      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
87      * overflow (when the result is negative).
88      *
89      * Counterpart to Solidity's `-` operator.
90      *
91      * Requirements:
92      *
93      * - Subtraction cannot overflow.
94      */
95     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b <= a, errorMessage);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the multiplication of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `*` operator.
107      *
108      * Requirements:
109      *
110      * - Multiplication cannot overflow.
111      */
112     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114         // benefit is lost if 'b' is also tested.
115         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
116         if (a == 0) {
117             return 0;
118         }
119 
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers. Reverts on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator. Note: this function uses a
131      * `revert` opcode (which leaves remaining gas untouched) while Solidity
132      * uses an invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b > 0, errorMessage);
156         uint256 c = a / b;
157         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return mod(a, b, "SafeMath: modulo by zero");
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts with custom message when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b != 0, errorMessage);
192         return a % b;
193     }
194 }
195 
196 // File: @openzeppelin/contracts/GSN/Context.sol
197 
198 
199 pragma solidity >=0.6.0 <0.8.0;
200 
201 /*
202  * @dev Provides information about the current execution context, including the
203  * sender of the transaction and its data. While these are generally available
204  * via msg.sender and msg.data, they should not be accessed in such a direct
205  * manner, since when dealing with GSN meta-transactions the account sending and
206  * paying for execution may not be the actual sender (as far as an application
207  * is concerned).
208  *
209  * This contract is only required for intermediate, library-like contracts.
210  */
211 abstract contract Context {
212     function _msgSender() internal view virtual returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view virtual returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // File: @openzeppelin/contracts/access/Ownable.sol
223 
224 
225 pragma solidity >=0.6.0 <0.8.0;
226 
227 /**
228  * @dev Contract module which provides a basic access control mechanism, where
229  * there is an account (an owner) that can be granted exclusive access to
230  * specific functions.
231  *
232  * By default, the owner account will be the one that deploys the contract. This
233  * can later be changed with {transferOwnership}.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 abstract contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor () internal {
248         address msgSender = _msgSender();
249         _owner = msgSender;
250         emit OwnershipTransferred(address(0), msgSender);
251     }
252 
253     /**
254      * @dev Returns the address of the current owner.
255      */
256     function owner() public view returns (address) {
257         return _owner;
258     }
259 
260     /**
261      * @dev Throws if called by any account other than the owner.
262      */
263     modifier onlyOwner() {
264         require(_owner == _msgSender(), "Ownable: caller is not the owner");
265         _;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public virtual onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         emit OwnershipTransferred(_owner, newOwner);
287         _owner = newOwner;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
292 
293 
294 pragma solidity >=0.6.0 <0.8.0;
295 
296 /**
297  * @dev Interface of the ERC20 standard as defined in the EIP.
298  */
299 interface IERC20 {
300     /**
301      * @dev Returns the amount of tokens in existence.
302      */
303     function totalSupply() external view returns (uint256);
304 
305     /**
306      * @dev Returns the amount of tokens owned by `account`.
307      */
308     function balanceOf(address account) external view returns (uint256);
309 
310     /**
311      * @dev Moves `amount` tokens from the caller's account to `recipient`.
312      *
313      * Returns a boolean value indicating whether the operation succeeded.
314      *
315      * Emits a {Transfer} event.
316      */
317     function transfer(address recipient, uint256 amount) external returns (bool);
318 
319     /**
320      * @dev Returns the remaining number of tokens that `spender` will be
321      * allowed to spend on behalf of `owner` through {transferFrom}. This is
322      * zero by default.
323      *
324      * This value changes when {approve} or {transferFrom} are called.
325      */
326     function allowance(address owner, address spender) external view returns (uint256);
327 
328     /**
329      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
330      *
331      * Returns a boolean value indicating whether the operation succeeded.
332      *
333      * IMPORTANT: Beware that changing an allowance with this method brings the risk
334      * that someone may use both the old and the new allowance by unfortunate
335      * transaction ordering. One possible solution to mitigate this race
336      * condition is to first reduce the spender's allowance to 0 and set the
337      * desired value afterwards:
338      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
339      *
340      * Emits an {Approval} event.
341      */
342     function approve(address spender, uint256 amount) external returns (bool);
343 
344     /**
345      * @dev Moves `amount` tokens from `sender` to `recipient` using the
346      * allowance mechanism. `amount` is then deducted from the caller's
347      * allowance.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Emitted when `value` tokens are moved from one account (`from`) to
357      * another (`to`).
358      *
359      * Note that `value` may be zero.
360      */
361     event Transfer(address indexed from, address indexed to, uint256 value);
362 
363     /**
364      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
365      * a call to {approve}. `value` is the new allowance.
366      */
367     event Approval(address indexed owner, address indexed spender, uint256 value);
368 }
369 
370 // File: @openzeppelin/contracts/utils/Address.sol
371 
372 
373 pragma solidity >=0.6.2 <0.8.0;
374 
375 /**
376  * @dev Collection of functions related to the address type
377  */
378 library Address {
379     /**
380      * @dev Returns true if `account` is a contract.
381      *
382      * [IMPORTANT]
383      * ====
384      * It is unsafe to assume that an address for which this function returns
385      * false is an externally-owned account (EOA) and not a contract.
386      *
387      * Among others, `isContract` will return false for the following
388      * types of addresses:
389      *
390      *  - an externally-owned account
391      *  - a contract in construction
392      *  - an address where a contract will be created
393      *  - an address where a contract lived, but was destroyed
394      * ====
395      */
396     function isContract(address account) internal view returns (bool) {
397         // This method relies on extcodesize, which returns 0 for contracts in
398         // construction, since the code is only stored at the end of the
399         // constructor execution.
400 
401         uint256 size;
402         // solhint-disable-next-line no-inline-assembly
403         assembly { size := extcodesize(account) }
404         return size > 0;
405     }
406 
407     /**
408      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
409      * `recipient`, forwarding all available gas and reverting on errors.
410      *
411      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
412      * of certain opcodes, possibly making contracts go over the 2300 gas limit
413      * imposed by `transfer`, making them unable to receive funds via
414      * `transfer`. {sendValue} removes this limitation.
415      *
416      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
417      *
418      * IMPORTANT: because control is transferred to `recipient`, care must be
419      * taken to not create reentrancy vulnerabilities. Consider using
420      * {ReentrancyGuard} or the
421      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
422      */
423     function sendValue(address payable recipient, uint256 amount) internal {
424         require(address(this).balance >= amount, "Address: insufficient balance");
425 
426         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
427         (bool success, ) = recipient.call{ value: amount }("");
428         require(success, "Address: unable to send value, recipient may have reverted");
429     }
430 
431     /**
432      * @dev Performs a Solidity function call using a low level `call`. A
433      * plain`call` is an unsafe replacement for a function call: use this
434      * function instead.
435      *
436      * If `target` reverts with a revert reason, it is bubbled up by this
437      * function (like regular Solidity function calls).
438      *
439      * Returns the raw returned data. To convert to the expected return value,
440      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
441      *
442      * Requirements:
443      *
444      * - `target` must be a contract.
445      * - calling `target` with `data` must not revert.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
450       return functionCall(target, data, "Address: low-level call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
455      * `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
460         return functionCallWithValue(target, data, 0, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but also transferring `value` wei to `target`.
466      *
467      * Requirements:
468      *
469      * - the calling contract must have an ETH balance of at least `value`.
470      * - the called Solidity function must be `payable`.
471      *
472      * _Available since v3.1._
473      */
474     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
475         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
480      * with `errorMessage` as a fallback revert reason when `target` reverts.
481      *
482      * _Available since v3.1._
483      */
484     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
485         require(address(this).balance >= value, "Address: insufficient balance for call");
486         require(isContract(target), "Address: call to non-contract");
487 
488         // solhint-disable-next-line avoid-low-level-calls
489         (bool success, bytes memory returndata) = target.call{ value: value }(data);
490         return _verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
500         return functionStaticCall(target, data, "Address: low-level static call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
510         require(isContract(target), "Address: static call to non-contract");
511 
512         // solhint-disable-next-line avoid-low-level-calls
513         (bool success, bytes memory returndata) = target.staticcall(data);
514         return _verifyCallResult(success, returndata, errorMessage);
515     }
516 
517     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
518         if (success) {
519             return returndata;
520         } else {
521             // Look for revert reason and bubble it up if present
522             if (returndata.length > 0) {
523                 // The easiest way to bubble the revert reason is using memory via assembly
524 
525                 // solhint-disable-next-line no-inline-assembly
526                 assembly {
527                     let returndata_size := mload(returndata)
528                     revert(add(32, returndata), returndata_size)
529                 }
530             } else {
531                 revert(errorMessage);
532             }
533         }
534     }
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
538 
539 
540 pragma solidity >=0.6.0 <0.8.0;
541 
542 
543 
544 
545 /**
546  * @title SafeERC20
547  * @dev Wrappers around ERC20 operations that throw on failure (when the token
548  * contract returns false). Tokens that return no value (and instead revert or
549  * throw on failure) are also supported, non-reverting calls are assumed to be
550  * successful.
551  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
552  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
553  */
554 library SafeERC20 {
555     using SafeMath for uint256;
556     using Address for address;
557 
558     function safeTransfer(IERC20 token, address to, uint256 value) internal {
559         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
560     }
561 
562     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
563         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
564     }
565 
566     /**
567      * @dev Deprecated. This function has issues similar to the ones found in
568      * {IERC20-approve}, and its usage is discouraged.
569      *
570      * Whenever possible, use {safeIncreaseAllowance} and
571      * {safeDecreaseAllowance} instead.
572      */
573     function safeApprove(IERC20 token, address spender, uint256 value) internal {
574         // safeApprove should only be called when setting an initial allowance,
575         // or when resetting it to zero. To increase and decrease it, use
576         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
577         // solhint-disable-next-line max-line-length
578         require((value == 0) || (token.allowance(address(this), spender) == 0),
579             "SafeERC20: approve from non-zero to non-zero allowance"
580         );
581         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
582     }
583 
584     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
585         uint256 newAllowance = token.allowance(address(this), spender).add(value);
586         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
587     }
588 
589     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
590         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
591         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
592     }
593 
594     /**
595      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
596      * on the return value: the return value is optional (but if data is returned, it must not be false).
597      * @param token The token targeted by the call.
598      * @param data The call data (encoded using abi.encode or one of its variants).
599      */
600     function _callOptionalReturn(IERC20 token, bytes memory data) private {
601         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
602         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
603         // the target address contains contract code and also asserts for success in the low-level call.
604 
605         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
606         if (returndata.length > 0) { // Return data is optional
607             // solhint-disable-next-line max-line-length
608             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
609         }
610     }
611 }
612 
613 // File: contracts/staking/IRewardDistributionRecipient.sol
614 
615 
616 pragma solidity 0.6.8;
617 
618 
619 
620 abstract contract IRewardDistributionRecipient is Ownable {
621     address public rewardDistribution;
622 
623     function notifyRewardAmount(uint256 reward) external virtual;
624 
625     modifier onlyRewardDistribution() {
626         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
627         _;
628     }
629 
630     function setRewardDistribution(address _rewardDistribution) external onlyOwner {
631         rewardDistribution = _rewardDistribution;
632     }
633 }
634 
635 // File: contracts/staking/LP_GMEE_ETH_Unipool.sol
636 
637 
638 pragma solidity 0.6.8;
639 
640 
641 
642 
643 
644 
645 contract LPTokenWrapper {
646     using SafeMath for uint256;
647     using SafeERC20 for IERC20;
648 
649     IERC20 public immutable uni;
650 
651     uint256 private _totalSupply;
652     mapping(address => uint256) private _balances;
653 
654     constructor(IERC20 uni_) public {
655         uni = uni_;
656     }
657 
658     function totalSupply() public view returns (uint256) {
659         return _totalSupply;
660     }
661 
662     function balanceOf(address account) public view returns (uint256) {
663         return _balances[account];
664     }
665 
666     function stake(uint256 amount) public virtual {
667         _totalSupply = _totalSupply.add(amount);
668         _balances[msg.sender] = _balances[msg.sender].add(amount);
669         uni.safeTransferFrom(msg.sender, address(this), amount);
670     }
671 
672     function withdraw(uint256 amount) public virtual {
673         _totalSupply = _totalSupply.sub(amount);
674         _balances[msg.sender] = _balances[msg.sender].sub(amount);
675         uni.safeTransfer(msg.sender, amount);
676     }
677 }
678 
679 // solhint-disable-next-line contract-name-camelcase
680 contract LP_GMEE_ETH_Unipool is LPTokenWrapper, IRewardDistributionRecipient {
681     // solhint-disable-next-line var-name-mixedcase
682     uint256 public immutable DURATION;
683     IERC20 public immutable rewardToken;
684 
685     uint256 public periodFinish = 0;
686     uint256 public rewardRate = 0;
687     uint256 public lastUpdateTime;
688     uint256 public rewardPerTokenStored;
689     mapping(address => uint256) public userRewardPerTokenPaid;
690     mapping(address => uint256) public rewards;
691 
692     event RewardAdded(uint256 reward);
693     event Staked(address indexed user, uint256 amount);
694     event Withdrawn(address indexed user, uint256 amount);
695     event RewardPaid(address indexed user, uint256 reward);
696 
697     constructor(
698         IERC20 uni_,
699         IERC20 rewardToken_,
700         uint256 duration
701     ) public LPTokenWrapper(uni_) {
702         rewardToken = rewardToken_;
703         DURATION = duration;
704     }
705 
706     modifier updateReward(address account) {
707         rewardPerTokenStored = rewardPerToken();
708         lastUpdateTime = lastTimeRewardApplicable();
709         if (account != address(0)) {
710             rewards[account] = earned(account);
711             userRewardPerTokenPaid[account] = rewardPerTokenStored;
712         }
713         _;
714     }
715 
716     function lastTimeRewardApplicable() public view returns (uint256) {
717         return Math.min(block.timestamp, periodFinish);
718     }
719 
720     function rewardPerToken() public view returns (uint256) {
721         if (totalSupply() == 0) {
722             return rewardPerTokenStored;
723         }
724         return rewardPerTokenStored.add(lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply()));
725     }
726 
727     function earned(address account) public view returns (uint256) {
728         return balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
729     }
730 
731     // stake visibility is public as overriding LPTokenWrapper's stake() function
732     function stake(uint256 amount) public override updateReward(msg.sender) {
733         require(amount > 0, "Cannot stake 0");
734         super.stake(amount);
735         emit Staked(msg.sender, amount);
736     }
737 
738     function withdraw(uint256 amount) public override updateReward(msg.sender) {
739         require(amount > 0, "Cannot withdraw 0");
740         super.withdraw(amount);
741         emit Withdrawn(msg.sender, amount);
742     }
743 
744     function exit() external {
745         getReward();
746         withdraw(balanceOf(msg.sender));
747     }
748 
749     function getReward() public updateReward(msg.sender) {
750         uint256 reward = earned(msg.sender);
751         if (reward > 0) {
752             rewards[msg.sender] = 0;
753             rewardToken.safeTransfer(msg.sender, reward);
754             emit RewardPaid(msg.sender, reward);
755         }
756     }
757 
758     function notifyRewardAmount(uint256 reward) external override onlyRewardDistribution updateReward(address(0)) {
759         if (block.timestamp >= periodFinish) {
760             rewardRate = reward.div(DURATION);
761         } else {
762             uint256 remaining = periodFinish.sub(block.timestamp);
763             uint256 leftover = remaining.mul(rewardRate);
764             rewardRate = reward.add(leftover).div(DURATION);
765         }
766         lastUpdateTime = block.timestamp;
767         periodFinish = block.timestamp.add(DURATION);
768         emit RewardAdded(reward);
769     }
770 }