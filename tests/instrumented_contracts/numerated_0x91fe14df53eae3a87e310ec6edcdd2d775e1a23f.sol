1 // SPDX-License-Identifier: MIT
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
283     function add(AttoDecimal memory a, uint256 b) internal pure returns (AttoDecimal memory) {
284         return  AttoDecimal({mantissa: a.mantissa.add(b.mul(ONE_MANTISSA))});
285     }
286 
287     function add(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
288         return AttoDecimal({mantissa: a.mantissa.add(b.mantissa)});
289     }
290 
291     function sub(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
292         return AttoDecimal({mantissa: a.mantissa.sub(b.mantissa)});
293     }
294 
295     function mul(AttoDecimal memory a, uint256 b) internal pure returns (AttoDecimal memory) {
296         return AttoDecimal({mantissa: a.mantissa.mul(b)});
297     }
298 
299     function div(uint256 a, uint256 b) internal pure returns (AttoDecimal memory) {
300         return AttoDecimal({mantissa: a.mul(ONE_MANTISSA).div(b)});
301     }
302 
303     function div(AttoDecimal memory a, uint256 b) internal pure returns (AttoDecimal memory) {
304         return AttoDecimal({mantissa: a.mantissa.div(b)});
305     }
306 
307     function div(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (AttoDecimal memory) {
308         return AttoDecimal({mantissa: a.mantissa.mul(ONE_MANTISSA).div(b.mantissa)});
309     }
310 
311     function idiv(uint256 a, AttoDecimal memory b) internal pure returns (uint256) {
312         return a.mul(ONE_MANTISSA).div(b.mantissa);
313     }
314 
315     function idivCeil(uint256 a, AttoDecimal memory b) internal pure returns (uint256) {
316         uint256 dividend = a.mul(ONE_MANTISSA);
317         bool addOne = dividend.mod(b.mantissa) > 0;
318         return dividend.div(b.mantissa).add(addOne ? 1 : 0);
319     }
320 
321     function ceil(AttoDecimal memory a) internal pure returns (uint256) {
322         uint256 integer = floor(a);
323         uint256 modulo = a.mantissa.mod(ONE_MANTISSA);
324         return integer.add(modulo >= ONE_MANTISSA.div(2) ? 1 : 0);
325     }
326 
327     function floor(AttoDecimal memory a) internal pure returns (uint256) {
328         return a.mantissa.div(ONE_MANTISSA);
329     }
330 
331     function lte(AttoDecimal memory a, AttoDecimal memory b) internal pure returns (bool) {
332         return a.mantissa <= b.mantissa;
333     }
334 
335     function toTuple(AttoDecimal memory a)
336         internal
337         pure
338         returns (
339             uint256 mantissa,
340             uint256 base,
341             uint256 exponentiation
342         )
343     {
344         return (a.mantissa, BASE, EXPONENTIATION);
345     }
346 }
347 
348 // 
349 abstract contract TwoStageOwnable {
350     address public nominatedOwner;
351     address public owner;
352 
353     event OwnerChanged(address newOwner);
354     event OwnerNominated(address nominatedOwner);
355 
356     constructor(address _owner) internal {
357         require(_owner != address(0), "Owner address cannot be 0");
358         owner = _owner;
359         emit OwnerChanged(_owner);
360     }
361 
362     function acceptOwnership() external {
363         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
364         owner = nominatedOwner;
365         nominatedOwner = address(0);
366         emit OwnerChanged(owner);
367     }
368 
369     function nominateNewOwner(address _owner) external onlyOwner {
370         nominatedOwner = _owner;
371         emit OwnerNominated(_owner);
372     }
373 
374     modifier onlyOwner {
375         require(msg.sender == owner, "Only the contract owner may perform this action");
376         _;
377     }
378 }
379 
380 // 
381 /**
382  * @dev Collection of functions related to the address type
383  */
384 library Address {
385     /**
386      * @dev Returns true if `account` is a contract.
387      *
388      * [IMPORTANT]
389      * ====
390      * It is unsafe to assume that an address for which this function returns
391      * false is an externally-owned account (EOA) and not a contract.
392      *
393      * Among others, `isContract` will return false for the following
394      * types of addresses:
395      *
396      *  - an externally-owned account
397      *  - a contract in construction
398      *  - an address where a contract will be created
399      *  - an address where a contract lived, but was destroyed
400      * ====
401      */
402     function isContract(address account) internal view returns (bool) {
403         // This method relies in extcodesize, which returns 0 for contracts in
404         // construction, since the code is only stored at the end of the
405         // constructor execution.
406 
407         uint256 size;
408         // solhint-disable-next-line no-inline-assembly
409         assembly { size := extcodesize(account) }
410         return size > 0;
411     }
412 
413     /**
414      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
415      * `recipient`, forwarding all available gas and reverting on errors.
416      *
417      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
418      * of certain opcodes, possibly making contracts go over the 2300 gas limit
419      * imposed by `transfer`, making them unable to receive funds via
420      * `transfer`. {sendValue} removes this limitation.
421      *
422      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
423      *
424      * IMPORTANT: because control is transferred to `recipient`, care must be
425      * taken to not create reentrancy vulnerabilities. Consider using
426      * {ReentrancyGuard} or the
427      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
428      */
429     function sendValue(address payable recipient, uint256 amount) internal {
430         require(address(this).balance >= amount, "Address: insufficient balance");
431 
432         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
433         (bool success, ) = recipient.call{ value: amount }("");
434         require(success, "Address: unable to send value, recipient may have reverted");
435     }
436 
437     /**
438      * @dev Performs a Solidity function call using a low level `call`. A
439      * plain`call` is an unsafe replacement for a function call: use this
440      * function instead.
441      *
442      * If `target` reverts with a revert reason, it is bubbled up by this
443      * function (like regular Solidity function calls).
444      *
445      * Returns the raw returned data. To convert to the expected return value,
446      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
447      *
448      * Requirements:
449      *
450      * - `target` must be a contract.
451      * - calling `target` with `data` must not revert.
452      *
453      * _Available since v3.1._
454      */
455     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
456       return functionCall(target, data, "Address: low-level call failed");
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
461      * `errorMessage` as a fallback revert reason when `target` reverts.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
466         return _functionCallWithValue(target, data, 0, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but also transferring `value` wei to `target`.
472      *
473      * Requirements:
474      *
475      * - the calling contract must have an ETH balance of at least `value`.
476      * - the called Solidity function must be `payable`.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
481         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
486      * with `errorMessage` as a fallback revert reason when `target` reverts.
487      *
488      * _Available since v3.1._
489      */
490     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
491         require(address(this).balance >= value, "Address: insufficient balance for call");
492         return _functionCallWithValue(target, data, value, errorMessage);
493     }
494 
495     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
496         require(isContract(target), "Address: call to non-contract");
497 
498         // solhint-disable-next-line avoid-low-level-calls
499         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
500         if (success) {
501             return returndata;
502         } else {
503             // Look for revert reason and bubble it up if present
504             if (returndata.length > 0) {
505                 // The easiest way to bubble the revert reason is using memory via assembly
506 
507                 // solhint-disable-next-line no-inline-assembly
508                 assembly {
509                     let returndata_size := mload(returndata)
510                     revert(add(32, returndata), returndata_size)
511                 }
512             } else {
513                 revert(errorMessage);
514             }
515         }
516     }
517 }
518 
519 // 
520 /**
521  * @title SafeERC20
522  * @dev Wrappers around ERC20 operations that throw on failure (when the token
523  * contract returns false). Tokens that return no value (and instead revert or
524  * throw on failure) are also supported, non-reverting calls are assumed to be
525  * successful.
526  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
527  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
528  */
529 library SafeERC20 {
530     using SafeMath for uint256;
531     using Address for address;
532 
533     function safeTransfer(IERC20 token, address to, uint256 value) internal {
534         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
535     }
536 
537     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
538         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
539     }
540 
541     /**
542      * @dev Deprecated. This function has issues similar to the ones found in
543      * {IERC20-approve}, and its usage is discouraged.
544      *
545      * Whenever possible, use {safeIncreaseAllowance} and
546      * {safeDecreaseAllowance} instead.
547      */
548     function safeApprove(IERC20 token, address spender, uint256 value) internal {
549         // safeApprove should only be called when setting an initial allowance,
550         // or when resetting it to zero. To increase and decrease it, use
551         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
552         // solhint-disable-next-line max-line-length
553         require((value == 0) || (token.allowance(address(this), spender) == 0),
554             "SafeERC20: approve from non-zero to non-zero allowance"
555         );
556         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
557     }
558 
559     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
560         uint256 newAllowance = token.allowance(address(this), spender).add(value);
561         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
562     }
563 
564     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
565         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
566         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
567     }
568 
569     /**
570      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
571      * on the return value: the return value is optional (but if data is returned, it must not be false).
572      * @param token The token targeted by the call.
573      * @param data The call data (encoded using abi.encode or one of its variants).
574      */
575     function _callOptionalReturn(IERC20 token, bytes memory data) private {
576         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
577         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
578         // the target address contains contract code and also asserts for success in the low-level call.
579 
580         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
581         if (returndata.length > 0) { // Return data is optional
582             // solhint-disable-next-line max-line-length
583             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
584         }
585     }
586 }
587 
588 // 
589 abstract contract UniStakingTokensStorage {
590     using SafeMath for uint256;
591     using SafeERC20 for IERC20;
592 
593     uint256 private _rewardPool;
594     uint256 private _rewardSupply;
595     uint256 private _totalSupply;
596     IERC20 private _rewardsToken;
597     IERC20 private _stakingToken;
598     mapping(address => uint256) private _balances;
599     mapping(address => uint256) private _claimed;
600     mapping(address => uint256) private _rewards;
601 
602     function rewardPool() public view returns (uint256) {
603         return _rewardPool;
604     }
605 
606     function rewardSupply() public view returns (uint256) {
607         return _rewardSupply;
608     }
609 
610     function totalSupply() public view returns (uint256) {
611         return _totalSupply;
612     }
613 
614     function rewardsToken() public view returns (IERC20) {
615         return _rewardsToken;
616     }
617 
618     function stakingToken() public view returns (IERC20) {
619         return _stakingToken;
620     }
621 
622     function balanceOf(address account) public view returns (uint256) {
623         return _balances[account];
624     }
625 
626     function claimedOf(address account) public view returns (uint256) {
627         return _claimed[account];
628     }
629 
630     function rewardOf(address account) public view returns (uint256) {
631         return _rewards[account];
632     }
633 
634     constructor(IERC20 rewardsToken_, IERC20 stakingToken_) public {
635         _rewardsToken = rewardsToken_;
636         _stakingToken = stakingToken_;
637     }
638 
639     function _onMint(address account, uint256 amount) internal virtual {}
640     function _onBurn(address account, uint256 amount) internal virtual {}
641 
642     function _stake(address account, uint256 amount) internal {
643         _stakingToken.safeTransferFrom(account, address(this), amount);
644         _balances[account] = _balances[account].add(amount);
645         _totalSupply = _totalSupply.add(amount);
646         _onMint(account, amount);
647     }
648 
649     function _unstake(address account, uint256 amount) internal {
650         _stakingToken.safeTransfer(account, amount);
651         _balances[account] = _balances[account].sub(amount);
652         _totalSupply = _totalSupply.sub(amount);
653         _onBurn(account, amount);
654     }
655 
656     function _increaseRewardPool(address owner, uint256 amount) internal {
657         _rewardsToken.safeTransferFrom(owner, address(this), amount);
658         _rewardSupply = _rewardSupply.add(amount);
659         _rewardPool = _rewardPool.add(amount);
660     }
661 
662     function _reduceRewardPool(address owner, uint256 amount) internal {
663         _rewardsToken.safeTransfer(owner, amount);
664         _rewardSupply = _rewardSupply.sub(amount);
665         _rewardPool = _rewardPool.sub(amount);
666     }
667 
668     function _addReward(address account, uint256 amount) internal {
669         _rewards[account] = _rewards[account].add(amount);
670         _rewardPool = _rewardPool.sub(amount);
671     }
672 
673     function _withdraw(address account, uint256 amount) internal {
674         _rewardsToken.safeTransfer(account, amount);
675         _claimed[account] = _claimed[account].sub(amount);
676     }
677 
678     function _claim(address account, uint256 amount) internal {
679         _rewards[account] = _rewards[account].sub(amount);
680         _rewardSupply = _rewardSupply.sub(amount);
681         _claimed[account] = _claimed[account].add(amount);
682     }
683 
684     function _transferBalance(
685         address from,
686         address to,
687         uint256 amount
688     ) internal {
689         _balances[from] = _balances[from].sub(amount);
690         _balances[to] = _balances[to].add(amount);
691     }
692 }
693 
694 // 
695 contract UniStaking is TwoStageOwnable, UniStakingTokensStorage {
696     using SafeMath for uint256;
697     using AttoDecimalLib for AttoDecimal;
698 
699     struct PaidRate {
700         AttoDecimal rate;
701         bool active;
702     }
703 
704     function getBlockNumber() internal virtual view returns (uint256) {
705         return block.number;
706     }
707 
708     function getTimestamp() internal virtual view returns (uint256) {
709         return block.timestamp;
710     }
711 
712     uint256 public constant SECONDS_PER_BLOCK = 15;
713     uint256 public constant BLOCKS_PER_DAY = 1 days / SECONDS_PER_BLOCK;
714     uint256 public constant MAX_DISTRIBUTION_DURATION = 90 * BLOCKS_PER_DAY;
715 
716     mapping(address => uint256) public rewardUnlockingTime;
717 
718     uint256 private _lastUpdateBlockNumber;
719     uint256 private _perBlockReward;
720     uint256 private _blockNumberOfDistributionEnding;
721     uint256 private _initialStrategyStartBlockNumber;
722     AttoDecimal private _initialStrategyRewardPerToken;
723     AttoDecimal private _rewardPerToken;
724     mapping(address => PaidRate) private _paidRates;
725 
726     function getRewardUnlockingTime() public virtual pure returns (uint256) {
727         return 8 days;
728     }
729 
730     function lastUpdateBlockNumber() public view returns (uint256) {
731         return _lastUpdateBlockNumber;
732     }
733 
734     function perBlockReward() public view returns (uint256) {
735         return _perBlockReward;
736     }
737 
738     function blockNumberOfDistributionEnding() public view returns (uint256) {
739         return _blockNumberOfDistributionEnding;
740     }
741 
742     function initialStrategyStartBlockNumber() public view returns (uint256) {
743         return _initialStrategyStartBlockNumber;
744     }
745 
746     function getRewardPerToken() internal view returns (AttoDecimal memory) {
747         uint256 lastRewardBlockNumber = Math.min(getBlockNumber(), _blockNumberOfDistributionEnding.add(1));
748         if (lastRewardBlockNumber <= _lastUpdateBlockNumber) return _rewardPerToken;
749         return _getRewardPerToken(lastRewardBlockNumber);
750     }
751 
752     function _getRewardPerToken(uint256 forBlockNumber) internal view returns (AttoDecimal memory) {
753         if (_initialStrategyStartBlockNumber >= forBlockNumber) return AttoDecimal(0);
754         uint256 totalSupply_ = totalSupply();
755         if (totalSupply_ == 0) return AttoDecimalLib.convert(0);
756         uint256 totalReward = forBlockNumber
757             .sub(Math.max(_lastUpdateBlockNumber, _initialStrategyStartBlockNumber))
758             .mul(_perBlockReward);
759         AttoDecimal memory newRewardPerToken = AttoDecimalLib.div(totalReward, totalSupply_);
760         return _rewardPerToken.add(newRewardPerToken);
761     }
762 
763     function rewardPerToken()
764         external
765         view
766         returns (
767             uint256 mantissa,
768             uint256 base,
769             uint256 exponentiation
770         )
771     {
772         return (getRewardPerToken().mantissa, AttoDecimalLib.BASE, AttoDecimalLib.EXPONENTIATION);
773     }
774 
775     function paidRateOf(address account)
776         external
777         view
778         returns (
779             uint256 mantissa,
780             uint256 base,
781             uint256 exponentiation
782         )
783     {
784         return (_paidRates[account].rate.mantissa, AttoDecimalLib.BASE, AttoDecimalLib.EXPONENTIATION);
785     }
786 
787     function earnedOf(address account) public view returns (uint256) {
788         uint256 currentBlockNumber = getBlockNumber();
789         PaidRate memory userRate = _paidRates[account];
790         if (currentBlockNumber <= _initialStrategyStartBlockNumber || !userRate.active) return 0;
791         AttoDecimal memory rewardPerToken_ = getRewardPerToken();
792         AttoDecimal memory initRewardPerToken = _initialStrategyRewardPerToken.mantissa > 0
793             ? _initialStrategyRewardPerToken
794             : _getRewardPerToken(_initialStrategyStartBlockNumber.add(1));
795         AttoDecimal memory rate = userRate.rate.lte((initRewardPerToken)) ? initRewardPerToken : userRate.rate;
796         uint256 balance = balanceOf(account);
797         if (balance == 0) return 0;
798         if (rewardPerToken_.lte(rate)) return 0;
799         AttoDecimal memory ratesDiff = rewardPerToken_.sub(rate);
800         return ratesDiff.mul(balance).floor();
801     }
802 
803     event RewardStrategyChanged(uint256 perBlockReward, uint256 duration);
804     event InitialRewardStrategySetted(uint256 startBlockNumber, uint256 perBlockReward, uint256 duration);
805     event Staked(address indexed account, uint256 amount);
806     event Unstaked(address indexed account, uint256 amount);
807     event Claimed(address indexed account, uint256 amount, uint256 rewardUnlockingTime);
808     event Withdrawed(address indexed account, uint256 amount);
809 
810     constructor(
811         IERC20 rewardsToken_,
812         IERC20 stakingToken_,
813         address owner_
814     ) public TwoStageOwnable(owner_) UniStakingTokensStorage(rewardsToken_, stakingToken_) {
815     }
816 
817     function stake(uint256 amount) public onlyPositiveAmount(amount) {
818         address sender = msg.sender;
819         _lockRewards(sender);
820         _stake(sender, amount);
821         emit Staked(sender, amount);
822     }
823 
824     function unstake(uint256 amount) public onlyPositiveAmount(amount) {
825         address sender = msg.sender;
826         require(amount <= balanceOf(sender), "Unstaking amount exceeds staked balance");
827         _lockRewards(sender);
828         _unstake(sender, amount);
829         emit Unstaked(sender, amount);
830     }
831 
832     function claim(uint256 amount) public onlyPositiveAmount(amount) {
833         address sender = msg.sender;
834         _lockRewards(sender);
835         require(amount <= rewardOf(sender), "Claiming amount exceeds received rewards");
836         uint256 rewardUnlockingTime_ = getTimestamp().add(getRewardUnlockingTime());
837         rewardUnlockingTime[sender] = rewardUnlockingTime_;
838         _claim(sender, amount);
839         emit Claimed(sender, amount, rewardUnlockingTime_);
840     }
841 
842     function withdraw(uint256 amount) public onlyPositiveAmount(amount) {
843         address sender = msg.sender;
844         require(getTimestamp() >= rewardUnlockingTime[sender], "Reward not unlocked yet");
845         require(amount <= claimedOf(sender), "Withdrawing amount exceeds claimed balance");
846         _withdraw(sender, amount);
847         emit Withdrawed(sender, amount);
848     }
849 
850     function setInitialRewardStrategy(
851         uint256 startBlockNumber,
852         uint256 perBlockReward_,
853         uint256 duration
854     ) public onlyOwner returns (bool succeed) {
855         uint256 currentBlockNumber = getBlockNumber();
856         require(_initialStrategyStartBlockNumber == 0, "Initial reward strategy already setted");
857         require(currentBlockNumber < startBlockNumber, "Initial reward strategy start block number less than current");
858         _initialStrategyStartBlockNumber = startBlockNumber;
859         _setRewardStrategy(currentBlockNumber, startBlockNumber, perBlockReward_, duration);
860         emit InitialRewardStrategySetted(startBlockNumber, perBlockReward_, duration);
861         return true;
862     }
863 
864     function setRewardStrategy(uint256 perBlockReward_, uint256 duration) public onlyOwner returns (bool succeed) {
865         uint256 currentBlockNumber = getBlockNumber();
866         require(_initialStrategyStartBlockNumber > 0, "Set initial reward strategy first");
867         require(currentBlockNumber >= _initialStrategyStartBlockNumber, "Wait for initial reward strategy start");
868         _setRewardStrategy(currentBlockNumber, currentBlockNumber, perBlockReward_, duration);
869         emit RewardStrategyChanged(perBlockReward_, duration);
870         return true;
871     }
872 
873     function lockRewards() public {
874         _lockRewards(msg.sender);
875     }
876 
877     function _moveStake(
878         address from,
879         address to,
880         uint256 amount
881     ) internal {
882         _lockRewards(from);
883         _lockRewards(to);
884         _transferBalance(from, to, amount);
885     }
886 
887     function _lockRatesForBlock(uint256 blockNumber) private {
888         _rewardPerToken = _getRewardPerToken(blockNumber);
889         _lastUpdateBlockNumber = blockNumber;
890     }
891 
892     function _lockRates(uint256 blockNumber) private {
893         uint256 totalSupply_ = totalSupply();
894         if (_initialStrategyStartBlockNumber <= blockNumber && _initialStrategyRewardPerToken.mantissa == 0 && totalSupply_ > 0)
895             _initialStrategyRewardPerToken = AttoDecimalLib.div(_perBlockReward, totalSupply_);
896         if (_perBlockReward > 0 && blockNumber >= _blockNumberOfDistributionEnding) {
897             _lockRatesForBlock(_blockNumberOfDistributionEnding);
898             _perBlockReward = 0;
899         }
900         _lockRatesForBlock(blockNumber);
901     }
902 
903     function _lockRewards(address account) private {
904         uint256 currentBlockNumber = getBlockNumber();
905         _lockRates(currentBlockNumber);
906         uint256 earned = earnedOf(account);
907         if (earned > 0) _addReward(account, earned);
908         _paidRates[account].rate = _rewardPerToken;
909         _paidRates[account].active = true;
910     }
911 
912     function _setRewardStrategy(
913         uint256 currentBlockNumber,
914         uint256 startBlockNumber,
915         uint256 perBlockReward_,
916         uint256 duration
917     ) private {
918         require(duration > 0, "Duration is zero");
919         require(duration <= MAX_DISTRIBUTION_DURATION, "Distribution duration too long");
920         _lockRates(currentBlockNumber);
921         uint256 nextDistributionRequiredPool = perBlockReward_.mul(duration);
922         uint256 notDistributedReward = _blockNumberOfDistributionEnding <= currentBlockNumber
923             ? 0
924             : _blockNumberOfDistributionEnding.sub(currentBlockNumber).mul(_perBlockReward);
925         if (nextDistributionRequiredPool > notDistributedReward) {
926             _increaseRewardPool(owner, nextDistributionRequiredPool.sub(notDistributedReward));
927         } else if (nextDistributionRequiredPool < notDistributedReward) {
928             _reduceRewardPool(owner, notDistributedReward.sub(nextDistributionRequiredPool));
929         }
930         _perBlockReward = perBlockReward_;
931         _blockNumberOfDistributionEnding = startBlockNumber.add(duration);
932     }
933 
934     modifier onlyPositiveAmount(uint256 amount) {
935         require(amount > 0, "Amount is not positive");
936         _;
937     }
938 }
939 
940 // 
941 contract UniStakingSyntheticToken is UniStaking {
942     uint256 public decimals;
943     string public name;
944     string public symbol;
945     mapping(address => mapping(address => uint256)) internal _allowances;
946 
947     function allowance(address owner, address spender) external view returns (uint256) {
948         return _allowances[owner][spender];
949     }
950 
951     event Approval(address indexed owner, address indexed spender, uint256 value);
952     event Transfer(address indexed from, address indexed to, uint256 value);
953 
954     constructor(
955         string memory name_,
956         string memory symbol_,
957         uint256 decimals_,
958         IERC20 rewardsToken_,
959         IERC20 stakingToken_,
960         address owner_
961     ) public UniStaking(rewardsToken_, stakingToken_, owner_) {
962         name = name_;
963         symbol = symbol_;
964         decimals = decimals_;
965     }
966 
967     function _onMint(address account, uint256 amount) internal override {
968         emit Transfer(address(0), account, amount);
969     }
970 
971     function _onBurn(address account, uint256 amount) internal override {
972         emit Transfer(account, address(0), amount);
973     }
974 
975     function transfer(address recipient, uint256 amount) external onlyPositiveAmount(amount) returns (bool) {
976         require(balanceOf(msg.sender) >= amount, "Transfer amount exceeds balance");
977         _transfer(msg.sender, recipient, amount);
978         return true;
979     }
980 
981     function approve(address spender, uint256 amount) external returns (bool) {
982         _allowances[msg.sender][spender] = amount;
983         emit Approval(msg.sender, spender, amount);
984         return true;
985     }
986 
987     function transferFrom(
988         address sender,
989         address recipient,
990         uint256 amount
991     ) external onlyPositiveAmount(amount) returns (bool) {
992         require(_allowances[sender][msg.sender] >= amount, "Transfer amount exceeds allowance");
993         require(balanceOf(sender) >= amount, "Transfer amount exceeds balance");
994         _transfer(sender, recipient, amount);
995         _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount);
996         return true;
997     }
998 
999     function _transfer(
1000         address sender,
1001         address recipient,
1002         uint256 amount
1003     ) internal {
1004         _moveStake(sender, recipient, amount);
1005         emit Transfer(sender, recipient, amount);
1006     }
1007 }