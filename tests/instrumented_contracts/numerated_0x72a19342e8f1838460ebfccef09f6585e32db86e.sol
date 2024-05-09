1 // File: contracts\interfaces\MathUtil.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.6.12;
5 
6 /**
7  * @dev Standard math utilities missing in the Solidity language.
8  */
9 library MathUtil {
10     /**
11      * @dev Returns the smallest of two numbers.
12      */
13     function min(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a < b ? a : b;
15     }
16 }
17 
18 // File: contracts\interfaces\IStakingProxy.sol
19 
20 pragma solidity 0.6.12;
21 
22 interface IStakingProxy {
23     function getBalance() external view returns(uint256);
24 
25     function withdraw(uint256 _amount) external;
26 
27     function stake() external;
28 
29     function distribute() external;
30 }
31 
32 // File: contracts\interfaces\IRewardStaking.sol
33 
34 pragma solidity 0.6.12;
35 
36 interface IRewardStaking {
37     function stakeFor(address, uint256) external;
38     function stake( uint256) external;
39     function withdraw(uint256 amount, bool claim) external;
40     function withdrawAndUnwrap(uint256 amount, bool claim) external;
41     function earned(address account) external view returns (uint256);
42     function getReward() external;
43     function getReward(address _account, bool _claimExtras) external;
44     function extraRewardsLength() external view returns (uint256);
45     function extraRewards(uint256 _pid) external view returns (address);
46     function rewardToken() external view returns (address);
47     function balanceOf(address _account) external view returns (uint256);
48 }
49 
50 // File: contracts\interfaces\BoringMath.sol
51 
52 pragma solidity 0.6.12;
53 
54 /// @notice A library for performing overflow-/underflow-safe math,
55 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
56 library BoringMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
58         require((c = a + b) >= b, "BoringMath: Add Overflow");
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
62         require((c = a - b) <= a, "BoringMath: Underflow");
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
66         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b > 0, "BoringMath: division by zero");
71         return a / b;
72     }
73 
74     function to128(uint256 a) internal pure returns (uint128 c) {
75         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
76         c = uint128(a);
77     }
78 
79     function to64(uint256 a) internal pure returns (uint64 c) {
80         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
81         c = uint64(a);
82     }
83 
84     function to32(uint256 a) internal pure returns (uint32 c) {
85         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
86         c = uint32(a);
87     }
88 
89     function to40(uint256 a) internal pure returns (uint40 c) {
90         require(a <= uint40(-1), "BoringMath: uint40 Overflow");
91         c = uint40(a);
92     }
93 
94     function to112(uint256 a) internal pure returns (uint112 c) {
95         require(a <= uint112(-1), "BoringMath: uint112 Overflow");
96         c = uint112(a);
97     }
98 
99     function to224(uint256 a) internal pure returns (uint224 c) {
100         require(a <= uint224(-1), "BoringMath: uint224 Overflow");
101         c = uint224(a);
102     }
103 
104     function to208(uint256 a) internal pure returns (uint208 c) {
105         require(a <= uint208(-1), "BoringMath: uint208 Overflow");
106         c = uint208(a);
107     }
108 
109     function to216(uint256 a) internal pure returns (uint216 c) {
110         require(a <= uint216(-1), "BoringMath: uint216 Overflow");
111         c = uint216(a);
112     }
113 }
114 
115 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
116 library BoringMath128 {
117     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
118         require((c = a + b) >= b, "BoringMath: Add Overflow");
119     }
120 
121     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
122         require((c = a - b) <= a, "BoringMath: Underflow");
123     }
124 }
125 
126 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
127 library BoringMath64 {
128     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
129         require((c = a + b) >= b, "BoringMath: Add Overflow");
130     }
131 
132     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
133         require((c = a - b) <= a, "BoringMath: Underflow");
134     }
135 }
136 
137 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
138 library BoringMath32 {
139     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
140         require((c = a + b) >= b, "BoringMath: Add Overflow");
141     }
142 
143     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
144         require((c = a - b) <= a, "BoringMath: Underflow");
145     }
146 
147     function mul(uint32 a, uint32 b) internal pure returns (uint32 c) {
148         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
149     }
150 
151     function div(uint32 a, uint32 b) internal pure returns (uint32) {
152         require(b > 0, "BoringMath: division by zero");
153         return a / b;
154     }
155 }
156 
157 
158 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint112.
159 library BoringMath112 {
160     function add(uint112 a, uint112 b) internal pure returns (uint112 c) {
161         require((c = a + b) >= b, "BoringMath: Add Overflow");
162     }
163 
164     function sub(uint112 a, uint112 b) internal pure returns (uint112 c) {
165         require((c = a - b) <= a, "BoringMath: Underflow");
166     }
167 
168     function mul(uint112 a, uint112 b) internal pure returns (uint112 c) {
169         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
170     }
171     
172     function div(uint112 a, uint112 b) internal pure returns (uint112) {
173         require(b > 0, "BoringMath: division by zero");
174         return a / b;
175     }
176 }
177 
178 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint224.
179 library BoringMath224 {
180     function add(uint224 a, uint224 b) internal pure returns (uint224 c) {
181         require((c = a + b) >= b, "BoringMath: Add Overflow");
182     }
183 
184     function sub(uint224 a, uint224 b) internal pure returns (uint224 c) {
185         require((c = a - b) <= a, "BoringMath: Underflow");
186     }
187 
188     function mul(uint224 a, uint224 b) internal pure returns (uint224 c) {
189         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
190     }
191     
192     function div(uint224 a, uint224 b) internal pure returns (uint224) {
193         require(b > 0, "BoringMath: division by zero");
194         return a / b;
195     }
196 }
197 
198 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
199 
200 pragma solidity >=0.6.0 <0.8.0;
201 
202 /**
203  * @dev Interface of the ERC20 standard as defined in the EIP.
204  */
205 interface IERC20 {
206     /**
207      * @dev Returns the amount of tokens in existence.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns the amount of tokens owned by `account`.
213      */
214     function balanceOf(address account) external view returns (uint256);
215 
216     /**
217      * @dev Moves `amount` tokens from the caller's account to `recipient`.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transfer(address recipient, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Returns the remaining number of tokens that `spender` will be
227      * allowed to spend on behalf of `owner` through {transferFrom}. This is
228      * zero by default.
229      *
230      * This value changes when {approve} or {transferFrom} are called.
231      */
232     function allowance(address owner, address spender) external view returns (uint256);
233 
234     /**
235      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * IMPORTANT: Beware that changing an allowance with this method brings the risk
240      * that someone may use both the old and the new allowance by unfortunate
241      * transaction ordering. One possible solution to mitigate this race
242      * condition is to first reduce the spender's allowance to 0 and set the
243      * desired value afterwards:
244      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245      *
246      * Emits an {Approval} event.
247      */
248     function approve(address spender, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Moves `amount` tokens from `sender` to `recipient` using the
252      * allowance mechanism. `amount` is then deducted from the caller's
253      * allowance.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Emitted when `value` tokens are moved from one account (`from`) to
263      * another (`to`).
264      *
265      * Note that `value` may be zero.
266      */
267     event Transfer(address indexed from, address indexed to, uint256 value);
268 
269     /**
270      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
271      * a call to {approve}. `value` is the new allowance.
272      */
273     event Approval(address indexed owner, address indexed spender, uint256 value);
274 }
275 
276 // File: @openzeppelin\contracts\math\SafeMath.sol
277 
278 pragma solidity >=0.6.0 <0.8.0;
279 
280 /**
281  * @dev Wrappers over Solidity's arithmetic operations with added overflow
282  * checks.
283  *
284  * Arithmetic operations in Solidity wrap on overflow. This can easily result
285  * in bugs, because programmers usually assume that an overflow raises an
286  * error, which is the standard behavior in high level programming languages.
287  * `SafeMath` restores this intuition by reverting the transaction when an
288  * operation overflows.
289  *
290  * Using this library instead of the unchecked operations eliminates an entire
291  * class of bugs, so it's recommended to use it always.
292  */
293 library SafeMath {
294     /**
295      * @dev Returns the addition of two unsigned integers, with an overflow flag.
296      *
297      * _Available since v3.4._
298      */
299     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         uint256 c = a + b;
301         if (c < a) return (false, 0);
302         return (true, c);
303     }
304 
305     /**
306      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
307      *
308      * _Available since v3.4._
309      */
310     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
311         if (b > a) return (false, 0);
312         return (true, a - b);
313     }
314 
315     /**
316      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
317      *
318      * _Available since v3.4._
319      */
320     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
321         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
322         // benefit is lost if 'b' is also tested.
323         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
324         if (a == 0) return (true, 0);
325         uint256 c = a * b;
326         if (c / a != b) return (false, 0);
327         return (true, c);
328     }
329 
330     /**
331      * @dev Returns the division of two unsigned integers, with a division by zero flag.
332      *
333      * _Available since v3.4._
334      */
335     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
336         if (b == 0) return (false, 0);
337         return (true, a / b);
338     }
339 
340     /**
341      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
342      *
343      * _Available since v3.4._
344      */
345     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
346         if (b == 0) return (false, 0);
347         return (true, a % b);
348     }
349 
350     /**
351      * @dev Returns the addition of two unsigned integers, reverting on
352      * overflow.
353      *
354      * Counterpart to Solidity's `+` operator.
355      *
356      * Requirements:
357      *
358      * - Addition cannot overflow.
359      */
360     function add(uint256 a, uint256 b) internal pure returns (uint256) {
361         uint256 c = a + b;
362         require(c >= a, "SafeMath: addition overflow");
363         return c;
364     }
365 
366     /**
367      * @dev Returns the subtraction of two unsigned integers, reverting on
368      * overflow (when the result is negative).
369      *
370      * Counterpart to Solidity's `-` operator.
371      *
372      * Requirements:
373      *
374      * - Subtraction cannot overflow.
375      */
376     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
377         require(b <= a, "SafeMath: subtraction overflow");
378         return a - b;
379     }
380 
381     /**
382      * @dev Returns the multiplication of two unsigned integers, reverting on
383      * overflow.
384      *
385      * Counterpart to Solidity's `*` operator.
386      *
387      * Requirements:
388      *
389      * - Multiplication cannot overflow.
390      */
391     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
392         if (a == 0) return 0;
393         uint256 c = a * b;
394         require(c / a == b, "SafeMath: multiplication overflow");
395         return c;
396     }
397 
398     /**
399      * @dev Returns the integer division of two unsigned integers, reverting on
400      * division by zero. The result is rounded towards zero.
401      *
402      * Counterpart to Solidity's `/` operator. Note: this function uses a
403      * `revert` opcode (which leaves remaining gas untouched) while Solidity
404      * uses an invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function div(uint256 a, uint256 b) internal pure returns (uint256) {
411         require(b > 0, "SafeMath: division by zero");
412         return a / b;
413     }
414 
415     /**
416      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
417      * reverting when dividing by zero.
418      *
419      * Counterpart to Solidity's `%` operator. This function uses a `revert`
420      * opcode (which leaves remaining gas untouched) while Solidity uses an
421      * invalid opcode to revert (consuming all remaining gas).
422      *
423      * Requirements:
424      *
425      * - The divisor cannot be zero.
426      */
427     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
428         require(b > 0, "SafeMath: modulo by zero");
429         return a % b;
430     }
431 
432     /**
433      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
434      * overflow (when the result is negative).
435      *
436      * CAUTION: This function is deprecated because it requires allocating memory for the error
437      * message unnecessarily. For custom revert reasons use {trySub}.
438      *
439      * Counterpart to Solidity's `-` operator.
440      *
441      * Requirements:
442      *
443      * - Subtraction cannot overflow.
444      */
445     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
446         require(b <= a, errorMessage);
447         return a - b;
448     }
449 
450     /**
451      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
452      * division by zero. The result is rounded towards zero.
453      *
454      * CAUTION: This function is deprecated because it requires allocating memory for the error
455      * message unnecessarily. For custom revert reasons use {tryDiv}.
456      *
457      * Counterpart to Solidity's `/` operator. Note: this function uses a
458      * `revert` opcode (which leaves remaining gas untouched) while Solidity
459      * uses an invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      *
463      * - The divisor cannot be zero.
464      */
465     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
466         require(b > 0, errorMessage);
467         return a / b;
468     }
469 
470     /**
471      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
472      * reverting with custom message when dividing by zero.
473      *
474      * CAUTION: This function is deprecated because it requires allocating memory for the error
475      * message unnecessarily. For custom revert reasons use {tryMod}.
476      *
477      * Counterpart to Solidity's `%` operator. This function uses a `revert`
478      * opcode (which leaves remaining gas untouched) while Solidity uses an
479      * invalid opcode to revert (consuming all remaining gas).
480      *
481      * Requirements:
482      *
483      * - The divisor cannot be zero.
484      */
485     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         require(b > 0, errorMessage);
487         return a % b;
488     }
489 }
490 
491 // File: @openzeppelin\contracts\utils\Address.sol
492 pragma solidity >=0.6.2 <0.8.0;
493 
494 /**
495  * @dev Collection of functions related to the address type
496  */
497 library Address {
498     /**
499      * @dev Returns true if `account` is a contract.
500      *
501      * [IMPORTANT]
502      * ====
503      * It is unsafe to assume that an address for which this function returns
504      * false is an externally-owned account (EOA) and not a contract.
505      *
506      * Among others, `isContract` will return false for the following
507      * types of addresses:
508      *
509      *  - an externally-owned account
510      *  - a contract in construction
511      *  - an address where a contract will be created
512      *  - an address where a contract lived, but was destroyed
513      * ====
514      */
515     function isContract(address account) internal view returns (bool) {
516         // This method relies on extcodesize, which returns 0 for contracts in
517         // construction, since the code is only stored at the end of the
518         // constructor execution.
519 
520         uint256 size;
521         // solhint-disable-next-line no-inline-assembly
522         assembly { size := extcodesize(account) }
523         return size > 0;
524     }
525 
526     /**
527      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
528      * `recipient`, forwarding all available gas and reverting on errors.
529      *
530      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
531      * of certain opcodes, possibly making contracts go over the 2300 gas limit
532      * imposed by `transfer`, making them unable to receive funds via
533      * `transfer`. {sendValue} removes this limitation.
534      *
535      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
536      *
537      * IMPORTANT: because control is transferred to `recipient`, care must be
538      * taken to not create reentrancy vulnerabilities. Consider using
539      * {ReentrancyGuard} or the
540      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
541      */
542     function sendValue(address payable recipient, uint256 amount) internal {
543         require(address(this).balance >= amount, "Address: insufficient balance");
544 
545         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
546         (bool success, ) = recipient.call{ value: amount }("");
547         require(success, "Address: unable to send value, recipient may have reverted");
548     }
549 
550     /**
551      * @dev Performs a Solidity function call using a low level `call`. A
552      * plain`call` is an unsafe replacement for a function call: use this
553      * function instead.
554      *
555      * If `target` reverts with a revert reason, it is bubbled up by this
556      * function (like regular Solidity function calls).
557      *
558      * Returns the raw returned data. To convert to the expected return value,
559      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
560      *
561      * Requirements:
562      *
563      * - `target` must be a contract.
564      * - calling `target` with `data` must not revert.
565      *
566      * _Available since v3.1._
567      */
568     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
569       return functionCall(target, data, "Address: low-level call failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
574      * `errorMessage` as a fallback revert reason when `target` reverts.
575      *
576      * _Available since v3.1._
577      */
578     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
579         return functionCallWithValue(target, data, 0, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but also transferring `value` wei to `target`.
585      *
586      * Requirements:
587      *
588      * - the calling contract must have an ETH balance of at least `value`.
589      * - the called Solidity function must be `payable`.
590      *
591      * _Available since v3.1._
592      */
593     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
594         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
599      * with `errorMessage` as a fallback revert reason when `target` reverts.
600      *
601      * _Available since v3.1._
602      */
603     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
604         require(address(this).balance >= value, "Address: insufficient balance for call");
605         require(isContract(target), "Address: call to non-contract");
606 
607         // solhint-disable-next-line avoid-low-level-calls
608         (bool success, bytes memory returndata) = target.call{ value: value }(data);
609         return _verifyCallResult(success, returndata, errorMessage);
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
614      * but performing a static call.
615      *
616      * _Available since v3.3._
617      */
618     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
619         return functionStaticCall(target, data, "Address: low-level static call failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
624      * but performing a static call.
625      *
626      * _Available since v3.3._
627      */
628     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
629         require(isContract(target), "Address: static call to non-contract");
630 
631         // solhint-disable-next-line avoid-low-level-calls
632         (bool success, bytes memory returndata) = target.staticcall(data);
633         return _verifyCallResult(success, returndata, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but performing a delegate call.
639      *
640      * _Available since v3.4._
641      */
642     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
643         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
648      * but performing a delegate call.
649      *
650      * _Available since v3.4._
651      */
652     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
653         require(isContract(target), "Address: delegate call to non-contract");
654 
655         // solhint-disable-next-line avoid-low-level-calls
656         (bool success, bytes memory returndata) = target.delegatecall(data);
657         return _verifyCallResult(success, returndata, errorMessage);
658     }
659 
660     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
661         if (success) {
662             return returndata;
663         } else {
664             // Look for revert reason and bubble it up if present
665             if (returndata.length > 0) {
666                 // The easiest way to bubble the revert reason is using memory via assembly
667 
668                 // solhint-disable-next-line no-inline-assembly
669                 assembly {
670                     let returndata_size := mload(returndata)
671                     revert(add(32, returndata), returndata_size)
672                 }
673             } else {
674                 revert(errorMessage);
675             }
676         }
677     }
678 }
679 
680 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
681 pragma solidity >=0.6.0 <0.8.0;
682 
683 
684 
685 /**
686  * @title SafeERC20
687  * @dev Wrappers around ERC20 operations that throw on failure (when the token
688  * contract returns false). Tokens that return no value (and instead revert or
689  * throw on failure) are also supported, non-reverting calls are assumed to be
690  * successful.
691  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
692  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
693  */
694 library SafeERC20 {
695     using SafeMath for uint256;
696     using Address for address;
697 
698     function safeTransfer(IERC20 token, address to, uint256 value) internal {
699         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
700     }
701 
702     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
703         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
704     }
705 
706     /**
707      * @dev Deprecated. This function has issues similar to the ones found in
708      * {IERC20-approve}, and its usage is discouraged.
709      *
710      * Whenever possible, use {safeIncreaseAllowance} and
711      * {safeDecreaseAllowance} instead.
712      */
713     function safeApprove(IERC20 token, address spender, uint256 value) internal {
714         // safeApprove should only be called when setting an initial allowance,
715         // or when resetting it to zero. To increase and decrease it, use
716         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
717         // solhint-disable-next-line max-line-length
718         require((value == 0) || (token.allowance(address(this), spender) == 0),
719             "SafeERC20: approve from non-zero to non-zero allowance"
720         );
721         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
722     }
723 
724     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
725         uint256 newAllowance = token.allowance(address(this), spender).add(value);
726         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
727     }
728 
729     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
730         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
731         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
732     }
733 
734     /**
735      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
736      * on the return value: the return value is optional (but if data is returned, it must not be false).
737      * @param token The token targeted by the call.
738      * @param data The call data (encoded using abi.encode or one of its variants).
739      */
740     function _callOptionalReturn(IERC20 token, bytes memory data) private {
741         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
742         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
743         // the target address contains contract code and also asserts for success in the low-level call.
744 
745         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
746         if (returndata.length > 0) { // Return data is optional
747             // solhint-disable-next-line max-line-length
748             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
749         }
750     }
751 }
752 
753 // File: @openzeppelin\contracts\math\Math.sol
754 
755 pragma solidity >=0.6.0 <0.8.0;
756 
757 /**
758  * @dev Standard math utilities missing in the Solidity language.
759  */
760 library Math {
761     /**
762      * @dev Returns the largest of two numbers.
763      */
764     function max(uint256 a, uint256 b) internal pure returns (uint256) {
765         return a >= b ? a : b;
766     }
767 
768     /**
769      * @dev Returns the smallest of two numbers.
770      */
771     function min(uint256 a, uint256 b) internal pure returns (uint256) {
772         return a < b ? a : b;
773     }
774 
775     /**
776      * @dev Returns the average of two numbers. The result is rounded towards
777      * zero.
778      */
779     function average(uint256 a, uint256 b) internal pure returns (uint256) {
780         // (a + b) / 2 can overflow, so we distribute
781         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
782     }
783 }
784 
785 // File: @openzeppelin\contracts\utils\Context.sol
786 pragma solidity >=0.6.0 <0.8.0;
787 
788 /*
789  * @dev Provides information about the current execution context, including the
790  * sender of the transaction and its data. While these are generally available
791  * via msg.sender and msg.data, they should not be accessed in such a direct
792  * manner, since when dealing with GSN meta-transactions the account sending and
793  * paying for execution may not be the actual sender (as far as an application
794  * is concerned).
795  *
796  * This contract is only required for intermediate, library-like contracts.
797  */
798 abstract contract Context {
799     function _msgSender() internal view virtual returns (address payable) {
800         return msg.sender;
801     }
802 
803     function _msgData() internal view virtual returns (bytes memory) {
804         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
805         return msg.data;
806     }
807 }
808 
809 // File: @openzeppelin\contracts\access\Ownable.sol
810 
811 pragma solidity >=0.6.0 <0.8.0;
812 
813 /**
814  * @dev Contract module which provides a basic access control mechanism, where
815  * there is an account (an owner) that can be granted exclusive access to
816  * specific functions.
817  *
818  * By default, the owner account will be the one that deploys the contract. This
819  * can later be changed with {transferOwnership}.
820  *
821  * This module is used through inheritance. It will make available the modifier
822  * `onlyOwner`, which can be applied to your functions to restrict their use to
823  * the owner.
824  */
825 abstract contract Ownable is Context {
826     address private _owner;
827 
828     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
829 
830     /**
831      * @dev Initializes the contract setting the deployer as the initial owner.
832      */
833     constructor () internal {
834         address msgSender = _msgSender();
835         _owner = msgSender;
836         emit OwnershipTransferred(address(0), msgSender);
837     }
838 
839     /**
840      * @dev Returns the address of the current owner.
841      */
842     function owner() public view virtual returns (address) {
843         return _owner;
844     }
845 
846     /**
847      * @dev Throws if called by any account other than the owner.
848      */
849     modifier onlyOwner() {
850         require(owner() == _msgSender(), "Ownable: caller is not the owner");
851         _;
852     }
853 
854     /**
855      * @dev Leaves the contract without owner. It will not be possible to call
856      * `onlyOwner` functions anymore. Can only be called by the current owner.
857      *
858      * NOTE: Renouncing ownership will leave the contract without an owner,
859      * thereby removing any functionality that is only available to the owner.
860      */
861     function renounceOwnership() public virtual onlyOwner {
862         emit OwnershipTransferred(_owner, address(0));
863         _owner = address(0);
864     }
865 
866     /**
867      * @dev Transfers ownership of the contract to a new account (`newOwner`).
868      * Can only be called by the current owner.
869      */
870     function transferOwnership(address newOwner) public virtual onlyOwner {
871         require(newOwner != address(0), "Ownable: new owner is the zero address");
872         emit OwnershipTransferred(_owner, newOwner);
873         _owner = newOwner;
874     }
875 }
876 
877 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
878 
879 pragma solidity >=0.6.0 <0.8.0;
880 
881 /**
882  * @dev Contract module that helps prevent reentrant calls to a function.
883  *
884  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
885  * available, which can be applied to functions to make sure there are no nested
886  * (reentrant) calls to them.
887  *
888  * Note that because there is a single `nonReentrant` guard, functions marked as
889  * `nonReentrant` may not call one another. This can be worked around by making
890  * those functions `private`, and then adding `external` `nonReentrant` entry
891  * points to them.
892  *
893  * TIP: If you would like to learn more about reentrancy and alternative ways
894  * to protect against it, check out our blog post
895  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
896  */
897 abstract contract ReentrancyGuard {
898     // Booleans are more expensive than uint256 or any type that takes up a full
899     // word because each write operation emits an extra SLOAD to first read the
900     // slot's contents, replace the bits taken up by the boolean, and then write
901     // back. This is the compiler's defense against contract upgrades and
902     // pointer aliasing, and it cannot be disabled.
903 
904     // The values being non-zero value makes deployment a bit more expensive,
905     // but in exchange the refund on every call to nonReentrant will be lower in
906     // amount. Since refunds are capped to a percentage of the total
907     // transaction's gas, it is best to keep them low in cases like this one, to
908     // increase the likelihood of the full refund coming into effect.
909     uint256 private constant _NOT_ENTERED = 1;
910     uint256 private constant _ENTERED = 2;
911 
912     uint256 private _status;
913 
914     constructor () internal {
915         _status = _NOT_ENTERED;
916     }
917 
918     /**
919      * @dev Prevents a contract from calling itself, directly or indirectly.
920      * Calling a `nonReentrant` function from another `nonReentrant`
921      * function is not supported. It is possible to prevent this from happening
922      * by making the `nonReentrant` function external, and make it call a
923      * `private` function that does the actual work.
924      */
925     modifier nonReentrant() {
926         // On the first call to nonReentrant, _notEntered will be true
927         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
928 
929         // Any calls to nonReentrant after this point will fail
930         _status = _ENTERED;
931 
932         _;
933 
934         // By storing the original value once again, a refund is triggered (see
935         // https://eips.ethereum.org/EIPS/eip-2200)
936         _status = _NOT_ENTERED;
937     }
938 }
939 
940 // File: contracts\CvxLockerV2.sol
941 
942 pragma solidity 0.6.12;
943 pragma experimental ABIEncoderV2;
944 /*
945 CVX Locking contract for https://www.convexfinance.com/
946 CVX locked in this contract will be entitled to voting rights for the Convex Finance platform
947 Based on EPS Staking contract for http://ellipsis.finance/
948 Based on SNX MultiRewards by iamdefinitelyahuman - https://github.com/iamdefinitelyahuman/multi-rewards
949 
950 V2:
951 - change locking mechanism to lock to a future epoch instead of current
952 - pending lock getter
953 - relocking allocates weight to the current epoch instead of future,
954     thus allows keeping voting weight in the same epoch a lock expires by relocking before a vote begins
955 - balanceAtEpoch and supplyAtEpoch return proper values for future epochs
956 - do not allow relocking directly to a new address
957 */
958 contract CvxLockerV2 is ReentrancyGuard, Ownable {
959 
960     using BoringMath for uint256;
961     using BoringMath224 for uint224;
962     using BoringMath112 for uint112;
963     using BoringMath32 for uint32;
964     using SafeERC20
965     for IERC20;
966 
967     /* ========== STATE VARIABLES ========== */
968 
969     struct Reward {
970         bool useBoost;
971         uint40 periodFinish;
972         uint208 rewardRate;
973         uint40 lastUpdateTime;
974         uint208 rewardPerTokenStored;
975     }
976     struct Balances {
977         uint112 locked;
978         uint112 boosted;
979         uint32 nextUnlockIndex;
980     }
981     struct LockedBalance {
982         uint112 amount;
983         uint112 boosted;
984         uint32 unlockTime;
985     }
986     struct EarnedData {
987         address token;
988         uint256 amount;
989     }
990     struct Epoch {
991         uint224 supply; //epoch boosted supply
992         uint32 date; //epoch start date
993     }
994 
995     //token constants
996     IERC20 public constant stakingToken = IERC20(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B); //cvx
997     address public constant cvxCrv = address(0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7);
998 
999     //rewards
1000     address[] public rewardTokens;
1001     mapping(address => Reward) public rewardData;
1002 
1003     // Duration that rewards are streamed over
1004     uint256 public constant rewardsDuration = 86400 * 7;
1005 
1006     // Duration of lock/earned penalty period
1007     uint256 public constant lockDuration = rewardsDuration * 16;
1008 
1009     // reward token -> distributor -> is approved to add rewards
1010     mapping(address => mapping(address => bool)) public rewardDistributors;
1011 
1012     // user -> reward token -> amount
1013     mapping(address => mapping(address => uint256)) public userRewardPerTokenPaid;
1014     mapping(address => mapping(address => uint256)) public rewards;
1015 
1016     //supplies and epochs
1017     uint256 public lockedSupply;
1018     uint256 public boostedSupply;
1019     Epoch[] public epochs;
1020 
1021     //mappings for balance data
1022     mapping(address => Balances) public balances;
1023     mapping(address => LockedBalance[]) public userLocks;
1024 
1025     //boost
1026     address public boostPayment = address(0x1389388d01708118b497f59521f6943Be2541bb7);
1027     uint256 public maximumBoostPayment = 0;
1028     uint256 public boostRate = 10000;
1029     uint256 public nextMaximumBoostPayment = 0;
1030     uint256 public nextBoostRate = 10000;
1031     uint256 public constant denominator = 10000;
1032 
1033     //staking
1034     uint256 public minimumStake = 10000;
1035     uint256 public maximumStake = 10000;
1036     address public stakingProxy;
1037     address public constant cvxcrvStaking = address(0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e);
1038     uint256 public constant stakeOffsetOnLock = 500; //allow broader range for staking when depositing
1039 
1040     //management
1041     uint256 public kickRewardPerEpoch = 100;
1042     uint256 public kickRewardEpochDelay = 4;
1043 
1044     //shutdown
1045     bool public isShutdown = false;
1046 
1047     //erc20-like interface
1048     string private _name;
1049     string private _symbol;
1050     uint8 private immutable _decimals;
1051 
1052     /* ========== CONSTRUCTOR ========== */
1053 
1054     constructor() public Ownable() {
1055         _name = "Vote Locked Convex Token";
1056         _symbol = "vlCVX";
1057         _decimals = 18;
1058 
1059         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1060         epochs.push(Epoch({
1061             supply: 0,
1062             date: uint32(currentEpoch)
1063         }));
1064     }
1065 
1066     function decimals() public view returns (uint8) {
1067         return _decimals;
1068     }
1069     function name() public view returns (string memory) {
1070         return _name;
1071     }
1072     function symbol() public view returns (string memory) {
1073         return _symbol;
1074     }
1075     function version() public view returns(uint256){
1076         return 2;
1077     }
1078 
1079     /* ========== ADMIN CONFIGURATION ========== */
1080 
1081     // Add a new reward token to be distributed to stakers
1082     function addReward(
1083         address _rewardsToken,
1084         address _distributor,
1085         bool _useBoost
1086     ) public onlyOwner {
1087         require(rewardData[_rewardsToken].lastUpdateTime == 0);
1088         require(_rewardsToken != address(stakingToken));
1089         rewardTokens.push(_rewardsToken);
1090         rewardData[_rewardsToken].lastUpdateTime = uint40(block.timestamp);
1091         rewardData[_rewardsToken].periodFinish = uint40(block.timestamp);
1092         rewardData[_rewardsToken].useBoost = _useBoost;
1093         rewardDistributors[_rewardsToken][_distributor] = true;
1094     }
1095 
1096     // Modify approval for an address to call notifyRewardAmount
1097     function approveRewardDistributor(
1098         address _rewardsToken,
1099         address _distributor,
1100         bool _approved
1101     ) external onlyOwner {
1102         require(rewardData[_rewardsToken].lastUpdateTime > 0);
1103         rewardDistributors[_rewardsToken][_distributor] = _approved;
1104     }
1105 
1106     //Set the staking contract for the underlying cvx
1107     function setStakingContract(address _staking) external onlyOwner {
1108         require(stakingProxy == address(0), "!assign");
1109 
1110         stakingProxy = _staking;
1111     }
1112 
1113     //set staking limits. will stake the mean of the two once either ratio is crossed
1114     function setStakeLimits(uint256 _minimum, uint256 _maximum) external onlyOwner {
1115         require(_minimum <= denominator, "min range");
1116         require(_maximum <= denominator, "max range");
1117         require(_minimum <= _maximum, "min range");
1118         minimumStake = _minimum;
1119         maximumStake = _maximum;
1120         updateStakeRatio(0);
1121     }
1122 
1123     //set boost parameters
1124     function setBoost(uint256 _max, uint256 _rate, address _receivingAddress) external onlyOwner {
1125         require(_max < 1500, "over max payment"); //max 15%
1126         require(_rate < 30000, "over max rate"); //max 3x
1127         require(_receivingAddress != address(0), "invalid address"); //must point somewhere valid
1128         nextMaximumBoostPayment = _max;
1129         nextBoostRate = _rate;
1130         boostPayment = _receivingAddress;
1131     }
1132 
1133     //set kick incentive
1134     function setKickIncentive(uint256 _rate, uint256 _delay) external onlyOwner {
1135         require(_rate <= 500, "over max rate"); //max 5% per epoch
1136         require(_delay >= 2, "min delay"); //minimum 2 epochs of grace
1137         kickRewardPerEpoch = _rate;
1138         kickRewardEpochDelay = _delay;
1139     }
1140 
1141     //shutdown the contract. unstake all tokens. release all locks
1142     function shutdown() external onlyOwner {
1143         if (stakingProxy != address(0)) {
1144             uint256 stakeBalance = IStakingProxy(stakingProxy).getBalance();
1145             IStakingProxy(stakingProxy).withdraw(stakeBalance);
1146         }
1147         isShutdown = true;
1148     }
1149 
1150     //set approvals for staking cvx and cvxcrv
1151     function setApprovals() external {
1152         IERC20(cvxCrv).safeApprove(cvxcrvStaking, 0);
1153         IERC20(cvxCrv).safeApprove(cvxcrvStaking, uint256(-1));
1154 
1155         IERC20(stakingToken).safeApprove(stakingProxy, 0);
1156         IERC20(stakingToken).safeApprove(stakingProxy, uint256(-1));
1157     }
1158 
1159     /* ========== VIEWS ========== */
1160 
1161     function _rewardPerToken(address _rewardsToken) internal view returns(uint256) {
1162         if (boostedSupply == 0) {
1163             return rewardData[_rewardsToken].rewardPerTokenStored;
1164         }
1165         return
1166         uint256(rewardData[_rewardsToken].rewardPerTokenStored).add(
1167             _lastTimeRewardApplicable(rewardData[_rewardsToken].periodFinish).sub(
1168                 rewardData[_rewardsToken].lastUpdateTime).mul(
1169                 rewardData[_rewardsToken].rewardRate).mul(1e18).div(rewardData[_rewardsToken].useBoost ? boostedSupply : lockedSupply)
1170         );
1171     }
1172 
1173     function _earned(
1174         address _user,
1175         address _rewardsToken,
1176         uint256 _balance
1177     ) internal view returns(uint256) {
1178         return _balance.mul(
1179             _rewardPerToken(_rewardsToken).sub(userRewardPerTokenPaid[_user][_rewardsToken])
1180         ).div(1e18).add(rewards[_user][_rewardsToken]);
1181     }
1182 
1183     function _lastTimeRewardApplicable(uint256 _finishTime) internal view returns(uint256){
1184         return Math.min(block.timestamp, _finishTime);
1185     }
1186 
1187     function lastTimeRewardApplicable(address _rewardsToken) public view returns(uint256) {
1188         return _lastTimeRewardApplicable(rewardData[_rewardsToken].periodFinish);
1189     }
1190 
1191     function rewardPerToken(address _rewardsToken) external view returns(uint256) {
1192         return _rewardPerToken(_rewardsToken);
1193     }
1194 
1195     function getRewardForDuration(address _rewardsToken) external view returns(uint256) {
1196         return uint256(rewardData[_rewardsToken].rewardRate).mul(rewardsDuration);
1197     }
1198 
1199     // Address and claimable amount of all reward tokens for the given account
1200     function claimableRewards(address _account) external view returns(EarnedData[] memory userRewards) {
1201         userRewards = new EarnedData[](rewardTokens.length);
1202         Balances storage userBalance = balances[_account];
1203         uint256 boostedBal = userBalance.boosted;
1204         for (uint256 i = 0; i < userRewards.length; i++) {
1205             address token = rewardTokens[i];
1206             userRewards[i].token = token;
1207             userRewards[i].amount = _earned(_account, token, rewardData[token].useBoost ? boostedBal : userBalance.locked);
1208         }
1209         return userRewards;
1210     }
1211 
1212     // Total BOOSTED balance of an account, including unlocked but not withdrawn tokens
1213     function rewardWeightOf(address _user) view external returns(uint256 amount) {
1214         return balances[_user].boosted;
1215     }
1216 
1217     // total token balance of an account, including unlocked but not withdrawn tokens
1218     function lockedBalanceOf(address _user) view external returns(uint256 amount) {
1219         return balances[_user].locked;
1220     }
1221 
1222     //BOOSTED balance of an account which only includes properly locked tokens as of the most recent eligible epoch
1223     function balanceOf(address _user) view external returns(uint256 amount) {
1224         LockedBalance[] storage locks = userLocks[_user];
1225         Balances storage userBalance = balances[_user];
1226         uint256 nextUnlockIndex = userBalance.nextUnlockIndex;
1227 
1228         //start with current boosted amount
1229         amount = balances[_user].boosted;
1230 
1231         uint256 locksLength = locks.length;
1232         //remove old records only (will be better gas-wise than adding up)
1233         for (uint i = nextUnlockIndex; i < locksLength; i++) {
1234             if (locks[i].unlockTime <= block.timestamp) {
1235                 amount = amount.sub(locks[i].boosted);
1236             } else {
1237                 //stop now as no futher checks are needed
1238                 break;
1239             }
1240         }
1241 
1242         //also remove amount locked in the next epoch
1243         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1244         if (locksLength > 0 && uint256(locks[locksLength - 1].unlockTime).sub(lockDuration) > currentEpoch) {
1245             amount = amount.sub(locks[locksLength - 1].boosted);
1246         }
1247 
1248         return amount;
1249     }
1250 
1251     //BOOSTED balance of an account which only includes properly locked tokens at the given epoch
1252     function balanceAtEpochOf(uint256 _epoch, address _user) view external returns(uint256 amount) {
1253         LockedBalance[] storage locks = userLocks[_user];
1254 
1255         //get timestamp of given epoch index
1256         uint256 epochTime = epochs[_epoch].date;
1257         //get timestamp of first non-inclusive epoch
1258         uint256 cutoffEpoch = epochTime.sub(lockDuration);
1259 
1260         //need to add up since the range could be in the middle somewhere
1261         //traverse inversely to make more current queries more gas efficient
1262         for (uint i = locks.length - 1; i + 1 != 0; i--) {
1263             uint256 lockEpoch = uint256(locks[i].unlockTime).sub(lockDuration);
1264             //lock epoch must be less or equal to the epoch we're basing from.
1265             if (lockEpoch <= epochTime) {
1266                 if (lockEpoch > cutoffEpoch) {
1267                     amount = amount.add(locks[i].boosted);
1268                 } else {
1269                     //stop now as no futher checks matter
1270                     break;
1271                 }
1272             }
1273         }
1274 
1275         return amount;
1276     }
1277 
1278     //return currently locked but not active balance
1279     function pendingLockOf(address _user) view external returns(uint256 amount) {
1280         LockedBalance[] storage locks = userLocks[_user];
1281 
1282         uint256 locksLength = locks.length;
1283 
1284         //return amount if latest lock is in the future
1285         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1286         if (locksLength > 0 && uint256(locks[locksLength - 1].unlockTime).sub(lockDuration) > currentEpoch) {
1287             return locks[locksLength - 1].boosted;
1288         }
1289 
1290         return 0;
1291     }
1292 
1293     function pendingLockAtEpochOf(uint256 _epoch, address _user) view external returns(uint256 amount) {
1294         LockedBalance[] storage locks = userLocks[_user];
1295 
1296         //get next epoch from the given epoch index
1297         uint256 nextEpoch = uint256(epochs[_epoch].date).add(rewardsDuration);
1298 
1299         //traverse inversely to make more current queries more gas efficient
1300         for (uint i = locks.length - 1; i + 1 != 0; i--) {
1301             uint256 lockEpoch = uint256(locks[i].unlockTime).sub(lockDuration);
1302             
1303             //return the next epoch balance
1304             if (lockEpoch == nextEpoch) {
1305                 return locks[i].boosted;
1306             }else if(lockEpoch < nextEpoch){
1307                 //no need to check anymore
1308                 break;
1309             }
1310         }
1311 
1312         return 0;
1313     }
1314 
1315     //supply of all properly locked BOOSTED balances at most recent eligible epoch
1316     function totalSupply() view external returns(uint256 supply) {
1317 
1318         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1319         uint256 cutoffEpoch = currentEpoch.sub(lockDuration);
1320         uint256 epochindex = epochs.length;
1321 
1322         //do not include next epoch's supply
1323         if ( uint256(epochs[epochindex - 1].date) > currentEpoch ) {
1324             epochindex--;
1325         }
1326 
1327         //traverse inversely to make more current queries more gas efficient
1328         for (uint i = epochindex - 1; i + 1 != 0; i--) {
1329             Epoch storage e = epochs[i];
1330             if (uint256(e.date) <= cutoffEpoch) {
1331                 break;
1332             }
1333             supply = supply.add(e.supply);
1334         }
1335 
1336         return supply;
1337     }
1338 
1339     //supply of all properly locked BOOSTED balances at the given epoch
1340     function totalSupplyAtEpoch(uint256 _epoch) view external returns(uint256 supply) {
1341 
1342         uint256 epochStart = uint256(epochs[_epoch].date).div(rewardsDuration).mul(rewardsDuration);
1343         uint256 cutoffEpoch = epochStart.sub(lockDuration);
1344 
1345         //traverse inversely to make more current queries more gas efficient
1346         for (uint i = _epoch; i + 1 != 0; i--) {
1347             Epoch storage e = epochs[i];
1348             if (uint256(e.date) <= cutoffEpoch) {
1349                 break;
1350             }
1351             supply = supply.add(epochs[i].supply);
1352         }
1353 
1354         return supply;
1355     }
1356 
1357     //find an epoch index based on timestamp
1358     function findEpochId(uint256 _time) view external returns(uint256 epoch) {
1359         uint256 max = epochs.length - 1;
1360         uint256 min = 0;
1361 
1362         //convert to start point
1363         _time = _time.div(rewardsDuration).mul(rewardsDuration);
1364 
1365         for (uint256 i = 0; i < 128; i++) {
1366             if (min >= max) break;
1367 
1368             uint256 mid = (min + max + 1) / 2;
1369             uint256 midEpochBlock = epochs[mid].date;
1370             if(midEpochBlock == _time){
1371                 //found
1372                 return mid;
1373             }else if (midEpochBlock < _time) {
1374                 min = mid;
1375             } else{
1376                 max = mid - 1;
1377             }
1378         }
1379         return min;
1380     }
1381 
1382 
1383     // Information on a user's locked balances
1384     function lockedBalances(
1385         address _user
1386     ) view external returns(
1387         uint256 total,
1388         uint256 unlockable,
1389         uint256 locked,
1390         LockedBalance[] memory lockData
1391     ) {
1392         LockedBalance[] storage locks = userLocks[_user];
1393         Balances storage userBalance = balances[_user];
1394         uint256 nextUnlockIndex = userBalance.nextUnlockIndex;
1395         uint256 idx;
1396         for (uint i = nextUnlockIndex; i < locks.length; i++) {
1397             if (locks[i].unlockTime > block.timestamp) {
1398                 if (idx == 0) {
1399                     lockData = new LockedBalance[](locks.length - i);
1400                 }
1401                 lockData[idx] = locks[i];
1402                 idx++;
1403                 locked = locked.add(locks[i].amount);
1404             } else {
1405                 unlockable = unlockable.add(locks[i].amount);
1406             }
1407         }
1408         return (userBalance.locked, unlockable, locked, lockData);
1409     }
1410 
1411     //number of epochs
1412     function epochCount() external view returns(uint256) {
1413         return epochs.length;
1414     }
1415 
1416     /* ========== MUTATIVE FUNCTIONS ========== */
1417 
1418     function checkpointEpoch() external {
1419         _checkpointEpoch();
1420     }
1421 
1422     //insert a new epoch if needed. fill in any gaps
1423     function _checkpointEpoch() internal {
1424         //create new epoch in the future where new non-active locks will lock to
1425         uint256 nextEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration).add(rewardsDuration);
1426         uint256 epochindex = epochs.length;
1427 
1428         //first epoch add in constructor, no need to check 0 length
1429 
1430         //check to add
1431         if (epochs[epochindex - 1].date < nextEpoch) {
1432             //fill any epoch gaps
1433             while(epochs[epochs.length-1].date != nextEpoch){
1434                 uint256 nextEpochDate = uint256(epochs[epochs.length-1].date).add(rewardsDuration);
1435                 epochs.push(Epoch({
1436                     supply: 0,
1437                     date: uint32(nextEpochDate)
1438                 }));
1439             }
1440 
1441             //update boost parameters on a new epoch
1442             if(boostRate != nextBoostRate){
1443                 boostRate = nextBoostRate;
1444             }
1445             if(maximumBoostPayment != nextMaximumBoostPayment){
1446                 maximumBoostPayment = nextMaximumBoostPayment;
1447             }
1448         }
1449     }
1450 
1451     // Locked tokens cannot be withdrawn for lockDuration and are eligible to receive stakingReward rewards
1452     function lock(address _account, uint256 _amount, uint256 _spendRatio) external nonReentrant updateReward(_account) {
1453 
1454         //pull tokens
1455         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
1456 
1457         //lock
1458         _lock(_account, _amount, _spendRatio, false);
1459     }
1460 
1461     //lock tokens
1462     function _lock(address _account, uint256 _amount, uint256 _spendRatio, bool _isRelock) internal {
1463         require(_amount > 0, "Cannot stake 0");
1464         require(_spendRatio <= maximumBoostPayment, "over max spend");
1465         require(!isShutdown, "shutdown");
1466 
1467         Balances storage bal = balances[_account];
1468 
1469         //must try check pointing epoch first
1470         _checkpointEpoch();
1471 
1472         //calc lock and boosted amount
1473         uint256 spendAmount = _amount.mul(_spendRatio).div(denominator);
1474         uint256 boostRatio = boostRate.mul(_spendRatio).div(maximumBoostPayment==0?1:maximumBoostPayment);
1475         uint112 lockAmount = _amount.sub(spendAmount).to112();
1476         uint112 boostedAmount = _amount.add(_amount.mul(boostRatio).div(denominator)).to112();
1477 
1478         //add user balances
1479         bal.locked = bal.locked.add(lockAmount);
1480         bal.boosted = bal.boosted.add(boostedAmount);
1481 
1482         //add to total supplies
1483         lockedSupply = lockedSupply.add(lockAmount);
1484         boostedSupply = boostedSupply.add(boostedAmount);
1485 
1486         //add user lock records or add to current
1487         uint256 lockEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1488         //if a fresh lock, add on an extra duration period
1489         if(!_isRelock){
1490             lockEpoch = lockEpoch.add(rewardsDuration);
1491         }
1492         uint256 unlockTime = lockEpoch.add(lockDuration);
1493         uint256 idx = userLocks[_account].length;
1494 
1495         //if the latest user lock is smaller than this lock, always just add new entry to the end of the list
1496         if (idx == 0 || userLocks[_account][idx - 1].unlockTime < unlockTime) {
1497             userLocks[_account].push(LockedBalance({
1498                 amount: lockAmount,
1499                 boosted: boostedAmount,
1500                 unlockTime: uint32(unlockTime)
1501             }));
1502         } else {
1503             //else add to a current lock
1504 
1505             //if latest lock is further in the future, lower index
1506             //this can only happen if relocking an expired lock after creating a new lock
1507             if(userLocks[_account][idx - 1].unlockTime > unlockTime){
1508                 idx--;
1509             }
1510 
1511             //if idx points to the epoch when same unlock time, update
1512             //(this is always true with a normal lock but maybe not with relock)
1513             if(userLocks[_account][idx - 1].unlockTime == unlockTime){
1514                 LockedBalance storage userL = userLocks[_account][idx - 1];
1515                 userL.amount = userL.amount.add(lockAmount);
1516                 userL.boosted = userL.boosted.add(boostedAmount);
1517             }else{
1518                 //can only enter here if a relock is made after a lock and there's no lock entry
1519                 //for the current epoch.
1520                 //ex a list of locks such as "[...][older][current*][next]" but without a "current" lock
1521                 //length - 1 is the next epoch
1522                 //length - 2 is a past epoch
1523                 //thus need to insert an entry for current epoch at the 2nd to last entry
1524                 //we will copy and insert the tail entry(next) and then overwrite length-2 entry
1525 
1526                 //reset idx
1527                 idx = userLocks[_account].length;
1528 
1529                 //get current last item
1530                 LockedBalance storage userL = userLocks[_account][idx - 1];
1531 
1532                 //add a copy to end of list
1533                 userLocks[_account].push(LockedBalance({
1534                     amount: userL.amount,
1535                     boosted: userL.boosted,
1536                     unlockTime: userL.unlockTime
1537                 }));
1538 
1539                 //insert current epoch lock entry by overwriting the entry at length-2
1540                 userL.amount = lockAmount;
1541                 userL.boosted = boostedAmount;
1542                 userL.unlockTime = uint32(unlockTime);
1543             }
1544         }
1545 
1546         
1547         //update epoch supply, epoch checkpointed above so safe to add to latest
1548         uint256 eIndex = epochs.length - 1;
1549         //if relock, epoch should be current and not next, thus need to decrease index to length-2
1550         if(_isRelock){
1551             eIndex--;
1552         }
1553         Epoch storage e = epochs[eIndex];
1554         e.supply = e.supply.add(uint224(boostedAmount));
1555 
1556         //send boost payment
1557         if (spendAmount > 0) {
1558             stakingToken.safeTransfer(boostPayment, spendAmount);
1559         }
1560 
1561         //update staking, allow a bit of leeway for smaller deposits to reduce gas
1562         updateStakeRatio(stakeOffsetOnLock);
1563 
1564         emit Staked(_account, lockEpoch, _amount, lockAmount, boostedAmount);
1565     }
1566 
1567     // Withdraw all currently locked tokens where the unlock time has passed
1568     function _processExpiredLocks(address _account, bool _relock, uint256 _spendRatio, address _withdrawTo, address _rewardAddress, uint256 _checkDelay) internal updateReward(_account) {
1569         LockedBalance[] storage locks = userLocks[_account];
1570         Balances storage userBalance = balances[_account];
1571         uint112 locked;
1572         uint112 boostedAmount;
1573         uint256 length = locks.length;
1574         uint256 reward = 0;
1575         
1576         if (isShutdown || locks[length - 1].unlockTime <= block.timestamp.sub(_checkDelay)) {
1577             //if time is beyond last lock, can just bundle everything together
1578             locked = userBalance.locked;
1579             boostedAmount = userBalance.boosted;
1580 
1581             //dont delete, just set next index
1582             userBalance.nextUnlockIndex = length.to32();
1583 
1584             //check for kick reward
1585             //this wont have the exact reward rate that you would get if looped through
1586             //but this section is supposed to be for quick and easy low gas processing of all locks
1587             //we'll assume that if the reward was good enough someone would have processed at an earlier epoch
1588             if (_checkDelay > 0) {
1589                 uint256 currentEpoch = block.timestamp.sub(_checkDelay).div(rewardsDuration).mul(rewardsDuration);
1590                 uint256 epochsover = currentEpoch.sub(uint256(locks[length - 1].unlockTime)).div(rewardsDuration);
1591                 uint256 rRate = MathUtil.min(kickRewardPerEpoch.mul(epochsover+1), denominator);
1592                 reward = uint256(locks[length - 1].amount).mul(rRate).div(denominator);
1593             }
1594         } else {
1595 
1596             //use a processed index(nextUnlockIndex) to not loop as much
1597             //deleting does not change array length
1598             uint32 nextUnlockIndex = userBalance.nextUnlockIndex;
1599             for (uint i = nextUnlockIndex; i < length; i++) {
1600                 //unlock time must be less or equal to time
1601                 if (locks[i].unlockTime > block.timestamp.sub(_checkDelay)) break;
1602 
1603                 //add to cumulative amounts
1604                 locked = locked.add(locks[i].amount);
1605                 boostedAmount = boostedAmount.add(locks[i].boosted);
1606 
1607                 //check for kick reward
1608                 //each epoch over due increases reward
1609                 if (_checkDelay > 0) {
1610                     uint256 currentEpoch = block.timestamp.sub(_checkDelay).div(rewardsDuration).mul(rewardsDuration);
1611                     uint256 epochsover = currentEpoch.sub(uint256(locks[i].unlockTime)).div(rewardsDuration);
1612                     uint256 rRate = MathUtil.min(kickRewardPerEpoch.mul(epochsover+1), denominator);
1613                     reward = reward.add( uint256(locks[i].amount).mul(rRate).div(denominator));
1614                 }
1615                 //set next unlock index
1616                 nextUnlockIndex++;
1617             }
1618             //update next unlock index
1619             userBalance.nextUnlockIndex = nextUnlockIndex;
1620         }
1621         require(locked > 0, "no exp locks");
1622 
1623         //update user balances and total supplies
1624         userBalance.locked = userBalance.locked.sub(locked);
1625         userBalance.boosted = userBalance.boosted.sub(boostedAmount);
1626         lockedSupply = lockedSupply.sub(locked);
1627         boostedSupply = boostedSupply.sub(boostedAmount);
1628 
1629         emit Withdrawn(_account, locked, _relock);
1630 
1631         //send process incentive
1632         if (reward > 0) {
1633             //if theres a reward(kicked), it will always be a withdraw only
1634             //preallocate enough cvx from stake contract to pay for both reward and withdraw
1635             allocateCVXForTransfer(uint256(locked));
1636 
1637             //reduce return amount by the kick reward
1638             locked = locked.sub(reward.to112());
1639             
1640             //transfer reward
1641             transferCVX(_rewardAddress, reward, false);
1642 
1643             emit KickReward(_rewardAddress, _account, reward);
1644         }else if(_spendRatio > 0){
1645             //preallocate enough cvx to transfer the boost cost
1646             allocateCVXForTransfer( uint256(locked).mul(_spendRatio).div(denominator) );
1647         }
1648 
1649         //relock or return to user
1650         if (_relock) {
1651             _lock(_withdrawTo, locked, _spendRatio, true);
1652         } else {
1653             transferCVX(_withdrawTo, locked, true);
1654         }
1655     }
1656 
1657     // withdraw expired locks to a different address
1658     function withdrawExpiredLocksTo(address _withdrawTo) external nonReentrant {
1659         _processExpiredLocks(msg.sender, false, 0, _withdrawTo, msg.sender, 0);
1660     }
1661 
1662     // Withdraw/relock all currently locked tokens where the unlock time has passed
1663     function processExpiredLocks(bool _relock) external nonReentrant {
1664         _processExpiredLocks(msg.sender, _relock, 0, msg.sender, msg.sender, 0);
1665     }
1666 
1667     function kickExpiredLocks(address _account) external nonReentrant {
1668         //allow kick after grace period of 'kickRewardEpochDelay'
1669         _processExpiredLocks(_account, false, 0, _account, msg.sender, rewardsDuration.mul(kickRewardEpochDelay));
1670     }
1671 
1672     //pull required amount of cvx from staking for an upcoming transfer
1673     function allocateCVXForTransfer(uint256 _amount) internal{
1674         uint256 balance = stakingToken.balanceOf(address(this));
1675         if (_amount > balance) {
1676             IStakingProxy(stakingProxy).withdraw(_amount.sub(balance));
1677         }
1678     }
1679 
1680     //transfer helper: pull enough from staking, transfer, updating staking ratio
1681     function transferCVX(address _account, uint256 _amount, bool _updateStake) internal {
1682         //allocate enough cvx from staking for the transfer
1683         allocateCVXForTransfer(_amount);
1684         //transfer
1685         stakingToken.safeTransfer(_account, _amount);
1686 
1687         //update staking
1688         if(_updateStake){
1689             updateStakeRatio(0);
1690         }
1691     }
1692 
1693     //calculate how much cvx should be staked. update if needed
1694     function updateStakeRatio(uint256 _offset) internal {
1695         if (isShutdown) return;
1696 
1697         //get balances
1698         uint256 local = stakingToken.balanceOf(address(this));
1699         uint256 staked = IStakingProxy(stakingProxy).getBalance();
1700         uint256 total = local.add(staked);
1701         
1702         if(total == 0) return;
1703 
1704         //current staked ratio
1705         uint256 ratio = staked.mul(denominator).div(total);
1706         //mean will be where we reset to if unbalanced
1707         uint256 mean = maximumStake.add(minimumStake).div(2);
1708         uint256 max = maximumStake.add(_offset);
1709         uint256 min = Math.min(minimumStake, minimumStake - _offset);
1710         if (ratio > max) {
1711             //remove
1712             uint256 remove = staked.sub(total.mul(mean).div(denominator));
1713             IStakingProxy(stakingProxy).withdraw(remove);
1714         } else if (ratio < min) {
1715             //add
1716             uint256 increase = total.mul(mean).div(denominator).sub(staked);
1717             stakingToken.safeTransfer(stakingProxy, increase);
1718             IStakingProxy(stakingProxy).stake();
1719         }
1720     }
1721 
1722     // Claim all pending rewards
1723     function getReward(address _account, bool _stake) public nonReentrant updateReward(_account) {
1724         for (uint i; i < rewardTokens.length; i++) {
1725             address _rewardsToken = rewardTokens[i];
1726             uint256 reward = rewards[_account][_rewardsToken];
1727             if (reward > 0) {
1728                 rewards[_account][_rewardsToken] = 0;
1729                 if (_rewardsToken == cvxCrv && _stake) {
1730                     IRewardStaking(cvxcrvStaking).stakeFor(_account, reward);
1731                 } else {
1732                     IERC20(_rewardsToken).safeTransfer(_account, reward);
1733                 }
1734                 emit RewardPaid(_account, _rewardsToken, reward);
1735             }
1736         }
1737     }
1738 
1739     // claim all pending rewards
1740     function getReward(address _account) external{
1741         getReward(_account,false);
1742     }
1743 
1744 
1745     /* ========== RESTRICTED FUNCTIONS ========== */
1746 
1747     function _notifyReward(address _rewardsToken, uint256 _reward) internal {
1748         Reward storage rdata = rewardData[_rewardsToken];
1749 
1750         if (block.timestamp >= rdata.periodFinish) {
1751             rdata.rewardRate = _reward.div(rewardsDuration).to208();
1752         } else {
1753             uint256 remaining = uint256(rdata.periodFinish).sub(block.timestamp);
1754             uint256 leftover = remaining.mul(rdata.rewardRate);
1755             rdata.rewardRate = _reward.add(leftover).div(rewardsDuration).to208();
1756         }
1757 
1758         rdata.lastUpdateTime = block.timestamp.to40();
1759         rdata.periodFinish = block.timestamp.add(rewardsDuration).to40();
1760     }
1761 
1762     function notifyRewardAmount(address _rewardsToken, uint256 _reward) external updateReward(address(0)) {
1763         require(rewardDistributors[_rewardsToken][msg.sender]);
1764         require(_reward > 0, "No reward");
1765 
1766         _notifyReward(_rewardsToken, _reward);
1767 
1768         // handle the transfer of reward tokens via `transferFrom` to reduce the number
1769         // of transactions required and ensure correctness of the _reward amount
1770         IERC20(_rewardsToken).safeTransferFrom(msg.sender, address(this), _reward);
1771         
1772         emit RewardAdded(_rewardsToken, _reward);
1773 
1774         if(_rewardsToken == cvxCrv){
1775             //update staking ratio if main reward
1776             updateStakeRatio(0);
1777         }
1778     }
1779 
1780     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
1781     function recoverERC20(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
1782         require(_tokenAddress != address(stakingToken), "Cannot withdraw staking token");
1783         require(rewardData[_tokenAddress].lastUpdateTime == 0, "Cannot withdraw reward token");
1784         IERC20(_tokenAddress).safeTransfer(owner(), _tokenAmount);
1785         emit Recovered(_tokenAddress, _tokenAmount);
1786     }
1787 
1788     /* ========== MODIFIERS ========== */
1789 
1790     modifier updateReward(address _account) {
1791         {//stack too deep
1792             Balances storage userBalance = balances[_account];
1793             uint256 boostedBal = userBalance.boosted;
1794             for (uint i = 0; i < rewardTokens.length; i++) {
1795                 address token = rewardTokens[i];
1796                 rewardData[token].rewardPerTokenStored = _rewardPerToken(token).to208();
1797                 rewardData[token].lastUpdateTime = _lastTimeRewardApplicable(rewardData[token].periodFinish).to40();
1798                 if (_account != address(0)) {
1799                     //check if reward is boostable or not. use boosted or locked balance accordingly
1800                     rewards[_account][token] = _earned(_account, token, rewardData[token].useBoost ? boostedBal : userBalance.locked );
1801                     userRewardPerTokenPaid[_account][token] = rewardData[token].rewardPerTokenStored;
1802                 }
1803             }
1804         }
1805         _;
1806     }
1807 
1808     /* ========== EVENTS ========== */
1809     event RewardAdded(address indexed _token, uint256 _reward);
1810     event Staked(address indexed _user, uint256 indexed _epoch, uint256 _paidAmount, uint256 _lockedAmount, uint256 _boostedAmount);
1811     event Withdrawn(address indexed _user, uint256 _amount, bool _relocked);
1812     event KickReward(address indexed _user, address indexed _kicked, uint256 _reward);
1813     event RewardPaid(address indexed _user, address indexed _rewardsToken, uint256 _reward);
1814     event Recovered(address _token, uint256 _amount);
1815 }