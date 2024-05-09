1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.6.12;
4 
5 
6 // 
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
35 // 
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
57      *
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      *
75      * - Subtraction cannot overflow.
76      */
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     /**
82      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
83      * overflow (when the result is negative).
84      *
85      * Counterpart to Solidity's `-` operator.
86      *
87      * Requirements:
88      *
89      * - Subtraction cannot overflow.
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      *
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b, "SafeMath: multiplication overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts on
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
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
140      * division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
171         return mod(a, b, "SafeMath: modulo by zero");
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
176      * Reverts with custom message when dividing by zero.
177      *
178      * Counterpart to Solidity's `%` operator. This function uses a `revert`
179      * opcode (which leaves remaining gas untouched) while Solidity uses an
180      * invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP.
195  */
196 interface IERC20 {
197     /**
198      * @dev Returns the amount of tokens in existence.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     /**
203      * @dev Returns the amount of tokens owned by `account`.
204      */
205     function balanceOf(address account) external view returns (uint256);
206 
207     /**
208      * @dev Moves `amount` tokens from the caller's account to `recipient`.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transfer(address recipient, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Returns the remaining number of tokens that `spender` will be
218      * allowed to spend on behalf of `owner` through {transferFrom}. This is
219      * zero by default.
220      *
221      * This value changes when {approve} or {transferFrom} are called.
222      */
223     function allowance(address owner, address spender) external view returns (uint256);
224 
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * IMPORTANT: Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      * condition is to first reduce the spender's allowance to 0 and set the
234      * desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address spender, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Moves `amount` tokens from `sender` to `recipient` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to {approve}. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 // 
268 struct AttoDecimal {
269     uint256 mantissa;
270 }
271 
272 library AttoDecimalLib {
273     using SafeMath for uint256;
274 
275     uint256 internal constant BASE = 10;
276     uint256 internal constant EXPONENTIATION = 18;
277     uint256 internal constant ONE_MANTISSA = BASE**EXPONENTIATION;
278 
279     function convert(uint256 integer) internal pure returns (AttoDecimal memory) {
280         return AttoDecimal({mantissa: integer.mul(ONE_MANTISSA)});
281     }
282 
283     function add(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
284         return AttoDecimal({mantissa: a.mantissa.add(b.mantissa)});
285     }
286 
287     function sub(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
288         return AttoDecimal({mantissa: a.mantissa.sub(b.mantissa)});
289     }
290 
291     function mul(AttoDecimal memory a, uint256 b) internal pure returns (AttoDecimal memory) {
292         return AttoDecimal({mantissa: a.mantissa.mul(b)});
293     }
294 
295     function div(uint256 a, uint256 b) internal pure returns (AttoDecimal memory) {
296         return AttoDecimal({mantissa: a.mul(ONE_MANTISSA).div(b)});
297     }
298 
299     function div(AttoDecimal memory a, uint256 b) internal pure returns (AttoDecimal memory) {
300         return AttoDecimal({mantissa: a.mantissa.div(b)});
301     }
302 
303     function div(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
304         return AttoDecimal({mantissa: a.mantissa.mul(ONE_MANTISSA).div(b.mantissa)});
305     }
306 
307     function floor(AttoDecimal memory a) internal pure returns (uint256) {
308         return a.mantissa.div(ONE_MANTISSA);
309     }
310 
311     function lte(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (bool) {
312         return a.mantissa <= b.mantissa;
313     }
314 }
315 
316 // 
317 abstract contract Owned {
318     address public nominatedOwner;
319     address public owner;
320 
321     event OwnerChanged(address oldOwner, address newOwner);
322     event OwnerNominated(address newOwner);
323 
324     constructor(address _owner) internal {
325         require(_owner != address(0), "Owner address cannot be 0");
326         owner = _owner;
327         emit OwnerChanged(address(0), _owner);
328     }
329 
330     function acceptOwnership() external {
331         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
332         owner = nominatedOwner;
333         nominatedOwner = address(0);
334         emit OwnerChanged(owner, nominatedOwner);
335     }
336 
337     function nominateNewOwner(address _owner) external onlyOwner {
338         nominatedOwner = _owner;
339         emit OwnerNominated(_owner);
340     }
341 
342     modifier onlyOwner {
343         require(msg.sender == owner, "Only the contract owner may perform this action");
344         _;
345     }
346 }
347 
348 // 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies in extcodesize, which returns 0 for contracts in
372         // construction, since the code is only stored at the end of the
373         // constructor execution.
374 
375         uint256 size;
376         // solhint-disable-next-line no-inline-assembly
377         assembly { size := extcodesize(account) }
378         return size > 0;
379     }
380 
381     /**
382      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
383      * `recipient`, forwarding all available gas and reverting on errors.
384      *
385      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
386      * of certain opcodes, possibly making contracts go over the 2300 gas limit
387      * imposed by `transfer`, making them unable to receive funds via
388      * `transfer`. {sendValue} removes this limitation.
389      *
390      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
391      *
392      * IMPORTANT: because control is transferred to `recipient`, care must be
393      * taken to not create reentrancy vulnerabilities. Consider using
394      * {ReentrancyGuard} or the
395      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
396      */
397     function sendValue(address payable recipient, uint256 amount) internal {
398         require(address(this).balance >= amount, "Address: insufficient balance");
399 
400         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
401         (bool success, ) = recipient.call{ value: amount }("");
402         require(success, "Address: unable to send value, recipient may have reverted");
403     }
404 
405     /**
406      * @dev Performs a Solidity function call using a low level `call`. A
407      * plain`call` is an unsafe replacement for a function call: use this
408      * function instead.
409      *
410      * If `target` reverts with a revert reason, it is bubbled up by this
411      * function (like regular Solidity function calls).
412      *
413      * Returns the raw returned data. To convert to the expected return value,
414      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
415      *
416      * Requirements:
417      *
418      * - `target` must be a contract.
419      * - calling `target` with `data` must not revert.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
424       return functionCall(target, data, "Address: low-level call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
429      * `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
434         return _functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
454      * with `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
459         require(address(this).balance >= value, "Address: insufficient balance for call");
460         return _functionCallWithValue(target, data, value, errorMessage);
461     }
462 
463     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
464         require(isContract(target), "Address: call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474 
475                 // solhint-disable-next-line no-inline-assembly
476                 assembly {
477                     let returndata_size := mload(returndata)
478                     revert(add(32, returndata), returndata_size)
479                 }
480             } else {
481                 revert(errorMessage);
482             }
483         }
484     }
485 }
486 
487 // 
488 /**
489  * @title SafeERC20
490  * @dev Wrappers around ERC20 operations that throw on failure (when the token
491  * contract returns false). Tokens that return no value (and instead revert or
492  * throw on failure) are also supported, non-reverting calls are assumed to be
493  * successful.
494  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
495  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
496  */
497 library SafeERC20 {
498     using SafeMath for uint256;
499     using Address for address;
500 
501     function safeTransfer(IERC20 token, address to, uint256 value) internal {
502         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
503     }
504 
505     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
506         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
507     }
508 
509     /**
510      * @dev Deprecated. This function has issues similar to the ones found in
511      * {IERC20-approve}, and its usage is discouraged.
512      *
513      * Whenever possible, use {safeIncreaseAllowance} and
514      * {safeDecreaseAllowance} instead.
515      */
516     function safeApprove(IERC20 token, address spender, uint256 value) internal {
517         // safeApprove should only be called when setting an initial allowance,
518         // or when resetting it to zero. To increase and decrease it, use
519         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
520         // solhint-disable-next-line max-line-length
521         require((value == 0) || (token.allowance(address(this), spender) == 0),
522             "SafeERC20: approve from non-zero to non-zero allowance"
523         );
524         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
525     }
526 
527     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).add(value);
529         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
530     }
531 
532     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
533         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
534         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
535     }
536 
537     /**
538      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
539      * on the return value: the return value is optional (but if data is returned, it must not be false).
540      * @param token The token targeted by the call.
541      * @param data The call data (encoded using abi.encode or one of its variants).
542      */
543     function _callOptionalReturn(IERC20 token, bytes memory data) private {
544         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
545         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
546         // the target address contains contract code and also asserts for success in the low-level call.
547 
548         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
549         if (returndata.length > 0) { // Return data is optional
550             // solhint-disable-next-line max-line-length
551             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
552         }
553     }
554 }
555 
556 // 
557 contract TokensStorage {
558     using SafeMath for uint256;
559     using SafeERC20 for IERC20;
560 
561     uint256 private _rewardPool;
562     uint256 private _rewardSupply;
563     uint256 private _totalSupply;
564     IERC20 private _rewardsToken;
565     IERC20 private _stakingToken;
566     mapping(address => uint256) private _balances;
567     mapping(address => uint256) private _claimed;
568     mapping(address => uint256) private _rewards;
569 
570     function rewardPool() public view returns (uint256) {
571         return _rewardPool;
572     }
573 
574     function rewardSupply() public view returns (uint256) {
575         return _rewardSupply;
576     }
577 
578     function totalSupply() public view returns (uint256) {
579         return _totalSupply;
580     }
581 
582     function rewardsToken() public view returns (IERC20) {
583         return _rewardsToken;
584     }
585 
586     function stakingToken() public view returns (IERC20) {
587         return _stakingToken;
588     }
589 
590     function balanceOf(address account) public view returns (uint256) {
591         return _balances[account];
592     }
593 
594     function claimedOf(address account) public view returns (uint256) {
595         return _claimed[account];
596     }
597 
598     function rewardOf(address account) public view returns (uint256) {
599         return _rewards[account];
600     }
601 
602     constructor(IERC20 rewardsToken_, IERC20 stakingToken_) public {
603         _rewardsToken = rewardsToken_;
604         _stakingToken = stakingToken_;
605     }
606 
607     function _onMint(address account, uint256 amount) internal virtual {}
608     function _onBurn(address account, uint256 amount) internal virtual {}
609 
610     function _stake(address account, uint256 amount) internal {
611         _stakingToken.safeTransferFrom(account, address(this), amount);
612         _balances[account] = _balances[account].add(amount);
613         _totalSupply = _totalSupply.add(amount);
614         _onMint(account, amount);
615     }
616 
617     function _unstake(address account, uint256 amount) internal {
618         _stakingToken.safeTransfer(account, amount);
619         _balances[account] = _balances[account].sub(amount);
620         _totalSupply = _totalSupply.sub(amount);
621         _onBurn(account, amount);
622     }
623 
624     function _increaseRewardPool(address owner, uint256 amount) internal {
625         _rewardsToken.safeTransferFrom(owner, address(this), amount);
626         _rewardSupply = _rewardSupply.add(amount);
627         _rewardPool = _rewardPool.add(amount);
628     }
629 
630     function _reduceRewardPool(address owner, uint256 amount) internal {
631         _rewardsToken.safeTransfer(owner, amount);
632         _rewardSupply = _rewardSupply.sub(amount);
633         _rewardPool = _rewardPool.sub(amount);
634     }
635 
636     function _addReward(address account, uint256 amount) internal {
637         _rewards[account] = _rewards[account].add(amount);
638         _rewardPool = _rewardPool.sub(amount);
639     }
640 
641     function _withdraw(address account, uint256 amount) internal {
642         _rewardsToken.safeTransfer(account, amount);
643         _claimed[account] = _claimed[account].sub(amount);
644     }
645 
646     function _claim(address account, uint256 amount) internal {
647         _rewards[account] = _rewards[account].sub(amount);
648         _rewardSupply = _rewardSupply.sub(amount);
649         _claimed[account] = _claimed[account].add(amount);
650     }
651 
652     function _transferBalance(
653         address from,
654         address to,
655         uint256 amount
656     ) internal {
657         _balances[from] = _balances[from].sub(amount);
658         _balances[to] = _balances[to].add(amount);
659     }
660 }
661 
662 // 
663 contract UniV2Staking is Owned, TokensStorage {
664     using SafeMath for uint256;
665     using AttoDecimalLib for AttoDecimal;
666 
667     function getBlockNumber() internal virtual view returns (uint256) {
668         return block.number;
669     }
670 
671     function getTimestamp() internal virtual view returns (uint256) {
672         return block.timestamp;
673     }
674 
675     uint256 public constant REWARD_UNLOCKING_TIME = 8 days;
676     uint256 public constant SECONDS_PER_BLOCK = 15;
677     uint256 public constant BLOCKS_PER_DAY = 1 days / SECONDS_PER_BLOCK;
678     uint256 public constant MAX_DISTRIBUTION_DURATION = 90 days * BLOCKS_PER_DAY;
679 
680     mapping(address => uint256) public rewardUnlockingTime;
681 
682     uint256 private _lastUpdateBlockNumber;
683     uint256 private _perBlockReward;
684     uint256 private _blockNumberOfDistributionEnding;
685     AttoDecimal private _rewardPerToken;
686     mapping(address => AttoDecimal) private _paidRates;
687 
688     function lastUpdateBlockNumber() public view returns (uint256) {
689         return _lastUpdateBlockNumber;
690     }
691 
692     function perBlockReward() public view returns (uint256) {
693         return _perBlockReward;
694     }
695 
696     function blockNumberOfDistributionEnding() public view returns (uint256) {
697         return _blockNumberOfDistributionEnding;
698     }
699 
700     function getRewardPerToken() internal view returns (AttoDecimal memory) {
701         uint256 lastRewardBlockNumber = Math.min(getBlockNumber(), _blockNumberOfDistributionEnding);
702         if (lastRewardBlockNumber <= _lastUpdateBlockNumber) return _rewardPerToken;
703         return _getRewardPerToken(lastRewardBlockNumber);
704     }
705 
706     function _getRewardPerToken(uint256 forBlockNumber) internal view returns (AttoDecimal memory) {
707         uint256 totalSupply_ = totalSupply();
708         if (totalSupply_ == 0) return AttoDecimalLib.convert(0);
709         uint256 totalReward = forBlockNumber.sub(_lastUpdateBlockNumber).mul(_perBlockReward);
710         AttoDecimal memory newRewardPerToken = AttoDecimalLib.div(totalReward, totalSupply_);
711         return _rewardPerToken.add(newRewardPerToken);
712     }
713 
714     function rewardPerToken()
715         external
716         view
717         returns (
718             uint256 mantissa,
719             uint256 base,
720             uint256 exponentiation
721         )
722     {
723         return (getRewardPerToken().mantissa, AttoDecimalLib.BASE, AttoDecimalLib.EXPONENTIATION);
724     }
725 
726     function paidRateOf(address account)
727         external
728         view
729         returns (
730             uint256 mantissa,
731             uint256 base,
732             uint256 exponentiation
733         )
734     {
735         return (_paidRates[account].mantissa, AttoDecimalLib.BASE, AttoDecimalLib.EXPONENTIATION);
736     }
737 
738     function earnedOf(address account) public view returns (uint256) {
739         AttoDecimal memory rewardPerToken_ = getRewardPerToken();
740         if (rewardPerToken_.lte(_paidRates[account])) return 0;
741         uint256 balance = balanceOf(account);
742         if (balance == 0) return 0;
743         AttoDecimal memory ratesDiff = rewardPerToken_.sub(_paidRates[account]);
744         return ratesDiff.mul(balance).floor();
745     }
746 
747     event RewardStrategyChanged(uint256 perBlockReward, uint256 duration);
748 
749     constructor(
750         IERC20 rewardsToken_,
751         IERC20 stakingToken_,
752         address owner_
753     ) public Owned(owner_) TokensStorage(rewardsToken_, stakingToken_) {}
754 
755     function stake(uint256 amount) public onlyPositiveAmount(amount) {
756         _lockRewards(msg.sender);
757         _stake(msg.sender, amount);
758     }
759 
760     function unstake(uint256 amount) public onlyPositiveAmount(amount) {
761         require(amount <= balanceOf(msg.sender), "Unstaking amount exceeds staked balance");
762         _lockRewards(msg.sender);
763         _unstake(msg.sender, amount);
764     }
765 
766     function claim(uint256 amount) public onlyPositiveAmount(amount) {
767         _lockRewards(msg.sender);
768         require(amount <= rewardOf(msg.sender), "Claiming amount exceeds received rewards");
769         rewardUnlockingTime[msg.sender] = getTimestamp().add(REWARD_UNLOCKING_TIME);
770         _claim(msg.sender, amount);
771     }
772 
773     function withdraw(uint256 amount) public onlyPositiveAmount(amount) {
774         require(getTimestamp() >= rewardUnlockingTime[msg.sender], "Reward not unlocked yet");
775         require(amount <= claimedOf(msg.sender), "Withdrawing amount exceeds claimed balance");
776         _withdraw(msg.sender, amount);
777     }
778 
779     function setRewardStrategy(uint256 perBlockReward_, uint256 duration) public onlyOwner returns (bool succeed) {
780         require(duration > 0, "Duration is zero");
781         require(duration <= MAX_DISTRIBUTION_DURATION, "Distribution duration too long");
782         _lockRates();
783         uint256 currentBlockNumber = getBlockNumber();
784         uint256 nextDistributionRequiredPool = perBlockReward_.mul(duration);
785         uint256 notDistributedReward = _blockNumberOfDistributionEnding <= currentBlockNumber
786             ? 0
787             : _blockNumberOfDistributionEnding.sub(currentBlockNumber).mul(_perBlockReward);
788         if (nextDistributionRequiredPool > notDistributedReward) {
789             _increaseRewardPool(owner, nextDistributionRequiredPool.sub(notDistributedReward));
790         } else if (nextDistributionRequiredPool < notDistributedReward) {
791             _reduceRewardPool(owner, notDistributedReward.sub(nextDistributionRequiredPool));
792         }
793         _perBlockReward = perBlockReward_;
794         _blockNumberOfDistributionEnding = currentBlockNumber.add(duration);
795         emit RewardStrategyChanged(perBlockReward_, duration);
796         return true;
797     }
798 
799     function lockRewards() public {
800         _lockRewards(msg.sender);
801     }
802 
803     function _moveStake(
804         address from,
805         address to,
806         uint256 amount
807     ) internal {
808         _lockRewards(from);
809         _lockRewards(to);
810         _transferBalance(from, to, amount);
811     }
812 
813     function _lockRates(uint256 blockNumber) private {
814         _rewardPerToken = _getRewardPerToken(blockNumber);
815         _lastUpdateBlockNumber = blockNumber;
816     }
817 
818     function _lockRates() private {
819         uint256 currentBlockNumber = getBlockNumber();
820         if (_perBlockReward > 0 && currentBlockNumber >= _blockNumberOfDistributionEnding) {
821             _lockRates(_blockNumberOfDistributionEnding);
822             _perBlockReward = 0;
823         }
824         _lockRates(currentBlockNumber);
825     }
826 
827     function _lockRewards(address account) private {
828         _lockRates();
829         uint256 earned = earnedOf(account);
830         if (earned > 0) _addReward(account, earned);
831         _paidRates[account] = _rewardPerToken;
832     }
833 
834     modifier onlyPositiveAmount(uint256 amount) {
835         require(amount > 0, "Amount is not positive");
836         _;
837     }
838 }
839 
840 // 
841 contract UniV2SyntheticToken is UniV2Staking {
842     uint256 public decimals;
843     string public name;
844     string public symbol;
845     mapping(address => mapping(address => uint256)) internal _allowances;
846 
847     function allowance(address owner, address spender) external view returns (uint256) {
848         return _allowances[owner][spender];
849     }
850 
851     event Approval(address indexed owner, address indexed spender, uint256 value);
852     event Transfer(address indexed from, address indexed to, uint256 value);
853 
854     constructor(
855         string memory name_,
856         string memory symbol_,
857         uint256 decimals_,
858         IERC20 rewardsToken_,
859         IERC20 stakingToken_,
860         address owner_
861     ) public UniV2Staking(rewardsToken_, stakingToken_, owner_) {
862         name = name_;
863         symbol = symbol_;
864         decimals = decimals_;
865     }
866 
867     function _onMint(address account, uint256 amount) internal override {
868         emit Transfer(address(0), account, amount);
869     }
870 
871     function _onBurn(address account, uint256 amount) internal override {
872         emit Transfer(account, address(0), amount);
873     }
874 
875     function transfer(address recipient, uint256 amount) external onlyPositiveAmount(amount) returns (bool) {
876         require(balanceOf(recipient) >= amount, "Transfer amount exceeds balance");
877         _transfer(msg.sender, recipient, amount);
878         return true;
879     }
880 
881     function approve(address spender, uint256 amount) external returns (bool) {
882         _allowances[msg.sender][spender] = amount;
883         emit Approval(msg.sender, spender, amount);
884         return true;
885     }
886 
887     function transferFrom(
888         address sender,
889         address recipient,
890         uint256 amount
891     ) external onlyPositiveAmount(amount) returns (bool) {
892         require(_allowances[sender][recipient] >= amount, "Transfer amount exceeds allowance");
893         _transfer(sender, recipient, amount);
894         _allowances[sender][recipient] = _allowances[sender][recipient].sub(amount);
895         return true;
896     }
897 
898     function _transfer(
899         address sender,
900         address recipient,
901         uint256 amount
902     ) internal {
903         _moveStake(sender, recipient, amount);
904         emit Transfer(sender, recipient, amount);
905     }
906 }