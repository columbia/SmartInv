1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-07
3 */
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: @openzeppelin/contracts/math/SafeMath.sol
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 pragma solidity ^0.6.2;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
386 
387 pragma solidity ^0.6.0;
388 
389 
390 
391 
392 /**
393  * @title SafeERC20
394  * @dev Wrappers around ERC20 operations that throw on failure (when the token
395  * contract returns false). Tokens that return no value (and instead revert or
396  * throw on failure) are also supported, non-reverting calls are assumed to be
397  * successful.
398  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
399  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
400  */
401 library SafeERC20 {
402     using SafeMath for uint256;
403     using Address for address;
404 
405     function safeTransfer(IERC20 token, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
407     }
408 
409     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(IERC20 token, address spender, uint256 value) internal {
421         // safeApprove should only be called when setting an initial allowance,
422         // or when resetting it to zero. To increase and decrease it, use
423         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
424         // solhint-disable-next-line max-line-length
425         require((value == 0) || (token.allowance(address(this), spender) == 0),
426             "SafeERC20: approve from non-zero to non-zero allowance"
427         );
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
429     }
430 
431     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).add(value);
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
437         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
438         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
439     }
440 
441     /**
442      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
443      * on the return value: the return value is optional (but if data is returned, it must not be false).
444      * @param token The token targeted by the call.
445      * @param data The call data (encoded using abi.encode or one of its variants).
446      */
447     function _callOptionalReturn(IERC20 token, bytes memory data) private {
448         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
449         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
450         // the target address contains contract code and also asserts for success in the low-level call.
451 
452         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
453         if (returndata.length > 0) { // Return data is optional
454             // solhint-disable-next-line max-line-length
455             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
456         }
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
461 
462 
463 pragma solidity ^0.6.0;
464 
465 /**
466  * @dev Contract module that helps prevent reentrant calls to a function.
467  *
468  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
469  * available, which can be applied to functions to make sure there are no nested
470  * (reentrant) calls to them.
471  *
472  * Note that because there is a single `nonReentrant` guard, functions marked as
473  * `nonReentrant` may not call one another. This can be worked around by making
474  * those functions `private`, and then adding `external` `nonReentrant` entry
475  * points to them.
476  *
477  * TIP: If you would like to learn more about reentrancy and alternative ways
478  * to protect against it, check out our blog post
479  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
480  */
481 contract ReentrancyGuard {
482     // Booleans are more expensive than uint256 or any type that takes up a full
483     // word because each write operation emits an extra SLOAD to first read the
484     // slot's contents, replace the bits taken up by the boolean, and then write
485     // back. This is the compiler's defense against contract upgrades and
486     // pointer aliasing, and it cannot be disabled.
487 
488     // The values being non-zero value makes deployment a bit more expensive,
489     // but in exchange the refund on every call to nonReentrant will be lower in
490     // amount. Since refunds are capped to a percentage of the total
491     // transaction's gas, it is best to keep them low in cases like this one, to
492     // increase the likelihood of the full refund coming into effect.
493     uint256 private constant _NOT_ENTERED = 1;
494     uint256 private constant _ENTERED = 2;
495 
496     uint256 private _status;
497 
498     constructor () internal {
499         _status = _NOT_ENTERED;
500     }
501 
502     /**
503      * @dev Prevents a contract from calling itself, directly or indirectly.
504      * Calling a `nonReentrant` function from another `nonReentrant`
505      * function is not supported. It is possible to prevent this from happening
506      * by making the `nonReentrant` function external, and make it call a
507      * `private` function that does the actual work.
508      */
509     modifier nonReentrant() {
510         // On the first call to nonReentrant, _notEntered will be true
511         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
512 
513         // Any calls to nonReentrant after this point will fail
514         _status = _ENTERED;
515 
516         _;
517 
518         // By storing the original value once again, a refund is triggered (see
519         // https://eips.ethereum.org/EIPS/eip-2200)
520         _status = _NOT_ENTERED;
521     }
522 }
523 
524 // File: contracts/interfaces/IPooledStaking.sol
525 
526 /*
527     Copyright (C) 2020 NexusMutual.io
528 
529     This program is free software: you can redistribute it and/or modify
530     it under the terms of the GNU General Public License as published by
531     the Free Software Foundation, either version 3 of the License, or
532     (at your option) any later version.
533 
534     This program is distributed in the hope that it will be useful,
535     but WITHOUT ANY WARRANTY; without even the implied warranty of
536     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
537     GNU General Public License for more details.
538 
539     You should have received a copy of the GNU General Public License
540     along with this program.  If not, see http://www.gnu.org/licenses/
541 */
542 
543 pragma solidity ^0.6.10;
544 
545 interface IPooledStaking {
546   function stakerContractStake(address staker, address contractAddress) external view returns (uint);
547   function stakerContractPendingUnstakeTotal(address staker, address contractAddress) external view returns (uint);
548 }
549 
550 // File: contracts/interfaces/INXMMaster.sol
551 
552 /*
553     Copyright (C) 2020 NexusMutual.io
554 
555     This program is free software: you can redistribute it and/or modify
556     it under the terms of the GNU General Public License as published by
557     the Free Software Foundation, either version 3 of the License, or
558     (at your option) any later version.
559 
560     This program is distributed in the hope that it will be useful,
561     but WITHOUT ANY WARRANTY; without even the implied warranty of
562     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
563     GNU General Public License for more details.
564 
565     You should have received a copy of the GNU General Public License
566     along with this program.  If not, see http://www.gnu.org/licenses/
567 */
568 
569 pragma solidity ^0.6.10;
570 
571 interface INXMMaster {
572   function getLatestAddress(bytes2 _contractName) external view returns (address payable contractAddress);
573 }
574 
575 // File: contracts/CommunityStakingIncentives.sol
576 
577 /*
578     Copyright (C) 2020 NexusMutual.io
579 
580     This program is free software: you can redistribute it and/or modify
581     it under the terms of the GNU General Public License as published by
582     the Free Software Foundation, either version 3 of the License, or
583     (at your option) any later version.
584 
585     This program is distributed in the hope that it will be useful,
586     but WITHOUT ANY WARRANTY; without even the implied warranty of
587     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
588     GNU General Public License for more details.
589 
590     You should have received a copy of the GNU General Public License
591     along with this program.  If not, see http://www.gnu.org/licenses/
592 */
593 
594 pragma solidity ^0.6.10;
595 
596 
597 
598 
599 
600 
601 
602 contract CommunityStakingIncentives is ReentrancyGuard {
603   using SafeERC20 for IERC20;
604   using SafeMath for uint;
605 
606   INXMMaster public master;
607   uint public roundDuration;
608   uint public roundsStartTime;
609   uint public constant rewardRateScale = 1e18;
610 
611   /**
612   * @dev Add rewards as a sponsor for a particular contract.
613   * @param _roundDuration Duration of a reward round in seconds.
614   * @param _roundsStartTime Timestamp in seconds at which rounds start. Needs to be in the future.
615   * @param masterAddress NexusMutual Master contract address.
616   */
617   constructor(uint _roundDuration, uint _roundsStartTime, address masterAddress) public {
618 
619     require(_roundDuration > 0, "_roundDuration needs to be greater than 0");
620     require(_roundsStartTime >= now, "_roundsStartTime needs to be in the future");
621     roundDuration = _roundDuration;
622     roundsStartTime = _roundsStartTime;
623     master = INXMMaster(masterAddress);
624   }
625 
626   struct RewardPool {
627     uint amount;
628     // rate nextRate and nextRateStartRound  may not be up to date. use _getRates to get the up to date values.
629     uint rate;
630     uint nextRate;
631     uint nextRateStartRound;
632     mapping(address => uint) lastRoundClaimed;
633   }
634 
635   // stakedContractAddress => sponsorAddress => tokenAddress => RewardPool
636   mapping (address => mapping (address => mapping (address => RewardPool))) rewardPools;
637 
638   event Deposited (
639     address indexed stakedContract,
640     address indexed sponsor,
641     address tokenAddress,
642     uint amount
643   );
644 
645   event Withdrawn (
646     address stakedContract,
647     address sponsor,
648     address tokenAddress,
649     uint amount
650   );
651 
652   event Claimed (
653     address stakedContract,
654     address sponsor,
655     address tokenAddress,
656     uint amount,
657     address receiver,
658     uint roundNumber
659   );
660 
661   /**
662   * @dev set the reward ratio as a sponsor for a particular contract and ERC20 token.
663   * @param stakedContract Contract the staker has a stake on.
664   * @param tokenAddress Address of the ERC20 token of the reward funds.
665   * @param rate Rate between the NXM stake and the reward amount. (Scaled by 1e18)
666   */
667   function setRewardRate(address stakedContract, address tokenAddress, uint rate) public {
668 
669     RewardPool storage pool = rewardPools[stakedContract][msg.sender][tokenAddress];
670 
671     uint currentRound = getCurrentRound();
672     uint currentRate;
673     (currentRate, , ) = _getRates(pool, currentRound);
674     if (currentRate == 0) {
675       // set the rate for the current round
676       pool.rate = rate;
677       pool.nextRate = 0;
678       pool.nextRateStartRound = 0;
679     } else {
680       // set the rate for the next round
681       if (pool.rate != currentRate) {
682         pool.rate = pool.nextRate;
683       }
684       pool.nextRate = rate;
685       pool.nextRateStartRound = currentRound + 1;
686     }
687   }
688 
689   /**
690   * @dev Add rewards as a sponsor for a particular contract.
691   * @param stakedContract Contract the staker has a stake on.
692   * @param tokenAddress Address of the ERC20 token of the reward funds.
693   * @param amount Amount of rewards to be deposited.
694   */
695   function depositRewards(address stakedContract, address tokenAddress, uint amount) public {
696 
697     IERC20 erc20 = IERC20(tokenAddress);
698     erc20.safeTransferFrom(msg.sender, address(this), amount);
699     RewardPool storage pool = rewardPools[stakedContract][msg.sender][tokenAddress];
700     pool.amount = pool.amount.add(amount);
701     emit Deposited(stakedContract, msg.sender, tokenAddress, amount);
702   }
703 
704   /**
705   * @dev Add rewards as a sponsor for a particular contract.
706   * @param stakedContract Contract the staker has a stake on.
707   * @param tokenAddress Address of the ERC20 token of the reward funds.
708   * @param amount Amount of rewards to be deposited.
709   * @param rate Rate between the NXM stake and the reward amount. (Scaled by 1e18)
710   */
711   function depositRewardsAndSetRate(address stakedContract, address tokenAddress, uint amount, uint rate) external {
712     depositRewards(stakedContract, tokenAddress, amount);
713     setRewardRate(stakedContract, tokenAddress, rate);
714   }
715 
716   /**
717   * @dev Calls claimReward for each separate (stakedContract, sponsor, token) tuple specified.
718   * @param stakedContracts Contracts the staker has a stake on.
719   * @param sponsors Sponsors to claim rewards from.
720   * @param tokenAddresses Addresses of the ERC20 token of the reward funds.
721   * @return tokensRewarded Tokens rewarded by each sponsor.
722   */
723   function claimRewards(
724     address[] calldata stakedContracts,
725     address[] calldata sponsors,
726     address[] calldata tokenAddresses
727   ) external nonReentrant returns (uint[] memory tokensRewarded) {
728 
729     require(stakedContracts.length == sponsors.length, "stakedContracts.length != sponsors.length");
730     require(stakedContracts.length == tokenAddresses.length, "stakedContracts.length != tokenAddresses.length");
731 
732     tokensRewarded = new uint[](stakedContracts.length);
733     for (uint i = 0; i < stakedContracts.length; i++) {
734       tokensRewarded[i] = claimReward(stakedContracts[i], sponsors[i], tokenAddresses[i]);
735     }
736   }
737 
738   /**
739   * @dev Claims reward as a NexusMutual staker.
740   * @param stakedContract contract the staker has a stake on.
741   * @param sponsor Sponsor providing the reward funds.
742   * @param tokenAddress address of the ERC20 token of the reward funds.
743   * @return rewardAmount amount rewarded
744   */
745   function claimReward(
746     address stakedContract,
747     address sponsor,
748     address tokenAddress
749   ) internal returns (uint rewardAmount) {
750 
751     uint currentRound = getCurrentRound();
752     RewardPool storage pool = rewardPools[stakedContract][sponsor][tokenAddress];
753     uint lastRoundClaimed = pool.lastRoundClaimed[msg.sender];
754     require(currentRound > lastRoundClaimed, "Already claimed this reward for this round");
755 
756     if (pool.nextRateStartRound != 0 && pool.nextRateStartRound <= currentRound) {
757       pool.rate = pool.nextRate;
758       pool.nextRateStartRound = 0;
759       pool.nextRate = 0;
760     }
761 
762     IPooledStaking pooledStaking = IPooledStaking(master.getLatestAddress("PS"));
763     uint stake = pooledStaking.stakerContractStake(msg.sender, stakedContract);
764     uint pendingUnstake = pooledStaking.stakerContractPendingUnstakeTotal(msg.sender, stakedContract);
765     uint netStake = stake >= pendingUnstake ? stake.sub(pendingUnstake) : 0;
766     rewardAmount = netStake.mul(pool.rate).div(rewardRateScale);
767     uint rewardsAvailable = pool.amount;
768     if (rewardAmount > rewardsAvailable) {
769       rewardAmount = rewardsAvailable;
770     }
771     require(rewardAmount > 0, "rewardAmount needs to be greater than 0");
772 
773     pool.lastRoundClaimed[msg.sender] = currentRound;
774     pool.amount = rewardsAvailable.sub(rewardAmount);
775 
776     IERC20 erc20 = IERC20(tokenAddress);
777     erc20.safeTransfer(msg.sender, rewardAmount);
778     emit Claimed(stakedContract, sponsor, tokenAddress, rewardAmount, msg.sender, currentRound);
779   }
780 
781   /**
782   * @dev Withdraw reward funds as a Sponsor for a particular staked contract.
783   * @param stakedContract Contract the staker has a stake on.
784   * @param tokenAddress Address of the ERC20 token of the reward funds.
785   * @param amount Amount of reward funds to be withdrawn.
786   */
787   function withdrawRewards(address stakedContract, address tokenAddress, uint amount) external nonReentrant {
788     IERC20 erc20 = IERC20(tokenAddress);
789     RewardPool storage pool = rewardPools[stakedContract][msg.sender][tokenAddress];
790     require(pool.amount >= amount, "Not enough tokens to withdraw");
791     require(pool.rate == 0, "Reward rate is not 0");
792 
793     pool.amount = pool.amount.sub(amount);
794     erc20.safeTransfer(msg.sender, amount);
795     emit Withdrawn(stakedContract, msg.sender, tokenAddress, amount);
796   }
797 
798   /**
799   @dev Fetch the amount of available rewards for a staker for the current round from a particular reward pool.
800   * @param staker whose rewards are counted.
801   * @param stakedContract contract the staker has a stake on.
802   * @param sponsor Sponsor providing the reward funds.
803   * @param tokenAddress address of the ERC20 token of the reward funds.
804   * @return rewardAmount amount of reward tokens available for this particular staker.
805   */
806   function getAvailableStakerReward(
807     address staker,
808     address stakedContract,
809     address sponsor,
810     address tokenAddress
811   ) public view returns (uint rewardAmount) {
812 
813     uint currentRound = getCurrentRound();
814     RewardPool storage pool = rewardPools[stakedContract][sponsor][tokenAddress];
815     uint lastRoundClaimed = pool.lastRoundClaimed[staker];
816     if (lastRoundClaimed >= currentRound) {
817       return 0;
818     }
819     uint rate;
820     (rate, , ) = _getRates(pool, currentRound);
821     IPooledStaking pooledStaking = IPooledStaking(master.getLatestAddress("PS"));
822     uint stake = pooledStaking.stakerContractStake(staker, stakedContract);
823     uint pendingUnstake = pooledStaking.stakerContractPendingUnstakeTotal(staker, stakedContract);
824     uint netStake = stake >= pendingUnstake ? stake.sub(pendingUnstake) : 0;
825     rewardAmount = netStake.mul(rate).div(rewardRateScale);
826     uint rewardsAvailable = pool.amount;
827     if (rewardAmount > rewardsAvailable) {
828       rewardAmount = rewardsAvailable;
829     }
830   }
831 
832   /**
833   * @dev Calls claimReward for each separate (stakedContract, sponsor, token) tuple specified.
834   * @param stakedContracts Contracts the staker has a stake on.
835   * @param sponsors Sponsors to claim rewards from.
836   * @param tokenAddresses Addresses of the ERC20 token of the reward funds.
837   * @return tokensRewarded Tokens rewarded by each sponsor.
838   */
839   function getAvailableStakerRewards(
840     address staker,
841     address[] calldata stakedContracts,
842     address[] calldata sponsors,
843     address[] calldata tokenAddresses
844   ) external view returns (uint[] memory tokensRewarded) {
845     require(stakedContracts.length == sponsors.length, "stakedContracts.length != sponsors.length");
846     require(stakedContracts.length == tokenAddresses.length, "stakedContracts.length != tokenAddresses.length");
847 
848     tokensRewarded = new uint[](stakedContracts.length);
849     for (uint i = 0; i < stakedContracts.length; i++) {
850       tokensRewarded[i] = getAvailableStakerReward(staker, stakedContracts[i], sponsors[i], tokenAddresses[i]);
851     }
852   }
853 
854   /**
855   @dev Fetch RewardPool information
856   * @param stakedContract contract a staker has a stake on.
857   * @param sponsor Sponsor providing the reward funds.
858   * @param tokenAddress address of the ERC20 token of the reward funds.
859   * @return amount total available token amount of the RewardPool
860   * @return rate rate to NXM of the RewardPool.
861   * @return nextRateStartRound round number for which the next rate applies. if 0, no nextRate is set.
862   * @return nextRate rate for the next round of the RewardPool. if nextRateStartRound is 0 this value is not relevant.
863   */
864   function getRewardPool(
865       address stakedContract,
866     address sponsor,
867     address tokenAddress
868   ) public view returns (uint amount, uint rate, uint nextRateStartRound, uint nextRate) {
869     RewardPool storage pool = rewardPools[stakedContract][sponsor][tokenAddress];
870     (rate, nextRateStartRound, nextRate) = _getRates(pool, getCurrentRound());
871     amount = pool.amount;
872   }
873 
874 
875   /**
876   @dev Fetch information for multiple RewardPools
877   * @param stakedContracts contract a staker has a stake on.
878   * @param sponsors Sponsor providing the reward funds.
879   * @param tokenAddresses address of the ERC20 token of the reward funds.
880   * @return amount total available token amount of the RewardPool
881   * @return rate rate to NXM of the RewardPool.
882   * @return nextRateStartRound round number for which the next rate applies. if 0, no nextRate is set.
883   * @return nextRate rate for the next round of the RewardPool. if nextRateStartRound is 0 this value is not relevant.
884   */
885   function getRewardPools(
886     address[] calldata stakedContracts,
887     address[] calldata sponsors,
888     address[] calldata tokenAddresses
889   ) external view returns (
890     uint[] memory amount,
891     uint[] memory rate,
892     uint[] memory nextRateStartRound,
893     uint[] memory nextRate
894   ) {
895     require(stakedContracts.length == sponsors.length, "stakedContracts.length != sponsors.length");
896     require(stakedContracts.length == tokenAddresses.length, "stakedContracts.length != tokenAddresses.length");
897 
898     amount = new uint[](stakedContracts.length);
899     rate = new uint[](stakedContracts.length);
900     nextRateStartRound = new uint[](stakedContracts.length);
901     nextRate = new uint[](stakedContracts.length);
902 
903     for (uint i = 0; i < stakedContracts.length; i++) {
904       RewardPool storage pool = rewardPools[stakedContracts[i]][sponsors[i]][tokenAddresses[i]];
905       (rate[i], nextRateStartRound[i], nextRate[i]) = _getRates(pool, getCurrentRound());
906       amount[i] = pool.amount;
907     }
908   }
909 
910   /**
911   * @dev Fetch the current round number.
912   */
913   function getCurrentRound() public view returns (uint) {
914     require(roundsStartTime <= now, "Rounds haven't started yet");
915     return (now - roundsStartTime) / roundDuration + 1;
916   }
917 
918   /**
919   * @dev Fetch the last round in which a staker fetched his reward from a particular RewardPool.
920   * @param stakedContract contract a staker has a stake on.
921   * @param sponsor Sponsor providing the reward funds.
922   * @param tokenAddress address of the ERC20 token of the reward funds.
923   */
924   function getLastRoundClaimed(
925     address stakedContract,
926     address sponsor,
927     address tokenAddress,
928     address staker
929   ) external view returns (uint) {
930     return rewardPools[stakedContract][sponsor][tokenAddress].lastRoundClaimed[staker];
931   }
932 
933   function _getRates(RewardPool storage pool, uint currentRound) internal view returns (uint rate, uint nextRateStartRound, uint nextRate) {
934     bool needsUpdate = pool.nextRateStartRound != 0 && pool.nextRateStartRound <= currentRound;
935     if (needsUpdate) {
936       return (pool.nextRate, 0, 0);
937     }
938     return (pool.rate, pool.nextRateStartRound, pool.nextRate);
939   }
940 }