1 // SPDX-License-Identifier: MIT
2 // File: contracts\interfaces\MathUtil.sol
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library MathUtil {
9     /**
10      * @dev Returns the smallest of two numbers.
11      */
12     function min(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a < b ? a : b;
14     }
15 }
16 
17 // File: contracts\interfaces\IStakingProxy.sol
18 
19 pragma solidity 0.6.12;
20 
21 interface IStakingProxy {
22     function getBalance() external view returns(uint256);
23 
24     function withdraw(uint256 _amount) external;
25 
26     function stake() external;
27 
28     function distribute() external;
29 }
30 
31 // File: contracts\interfaces\IRewardStaking.sol
32 
33 pragma solidity 0.6.12;
34 
35 interface IRewardStaking {
36     function stakeFor(address, uint256) external;
37     function stake( uint256) external;
38     function withdraw(uint256 amount, bool claim) external;
39     function withdrawAndUnwrap(uint256 amount, bool claim) external;
40     function earned(address account) external view returns (uint256);
41     function getReward() external;
42     function getReward(address _account, bool _claimExtras) external;
43     function extraRewardsLength() external view returns (uint256);
44     function extraRewards(uint256 _pid) external view returns (address);
45     function rewardToken() external view returns (address);
46     function balanceOf(address _account) external view returns (uint256);
47 }
48 
49 // File: contracts\interfaces\BoringMath.sol
50 
51 pragma solidity 0.6.12;
52 
53 /// @notice A library for performing overflow-/underflow-safe math,
54 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
55 library BoringMath {
56     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
57         require((c = a + b) >= b, "BoringMath: Add Overflow");
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
61         require((c = a - b) <= a, "BoringMath: Underflow");
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
65         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b > 0, "BoringMath: division by zero");
70         return a / b;
71     }
72 
73     function to128(uint256 a) internal pure returns (uint128 c) {
74         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
75         c = uint128(a);
76     }
77 
78     function to64(uint256 a) internal pure returns (uint64 c) {
79         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
80         c = uint64(a);
81     }
82 
83     function to32(uint256 a) internal pure returns (uint32 c) {
84         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
85         c = uint32(a);
86     }
87 
88     function to40(uint256 a) internal pure returns (uint40 c) {
89         require(a <= uint40(-1), "BoringMath: uint40 Overflow");
90         c = uint40(a);
91     }
92 
93     function to112(uint256 a) internal pure returns (uint112 c) {
94         require(a <= uint112(-1), "BoringMath: uint112 Overflow");
95         c = uint112(a);
96     }
97 
98     function to224(uint256 a) internal pure returns (uint224 c) {
99         require(a <= uint224(-1), "BoringMath: uint224 Overflow");
100         c = uint224(a);
101     }
102 
103     function to208(uint256 a) internal pure returns (uint208 c) {
104         require(a <= uint208(-1), "BoringMath: uint208 Overflow");
105         c = uint208(a);
106     }
107 
108     function to216(uint256 a) internal pure returns (uint216 c) {
109         require(a <= uint216(-1), "BoringMath: uint216 Overflow");
110         c = uint216(a);
111     }
112 }
113 
114 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
115 library BoringMath128 {
116     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
117         require((c = a + b) >= b, "BoringMath: Add Overflow");
118     }
119 
120     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
121         require((c = a - b) <= a, "BoringMath: Underflow");
122     }
123 }
124 
125 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
126 library BoringMath64 {
127     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
128         require((c = a + b) >= b, "BoringMath: Add Overflow");
129     }
130 
131     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
132         require((c = a - b) <= a, "BoringMath: Underflow");
133     }
134 }
135 
136 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
137 library BoringMath32 {
138     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
139         require((c = a + b) >= b, "BoringMath: Add Overflow");
140     }
141 
142     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
143         require((c = a - b) <= a, "BoringMath: Underflow");
144     }
145 
146     function mul(uint32 a, uint32 b) internal pure returns (uint32 c) {
147         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
148     }
149 
150     function div(uint32 a, uint32 b) internal pure returns (uint32) {
151         require(b > 0, "BoringMath: division by zero");
152         return a / b;
153     }
154 }
155 
156 
157 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint112.
158 library BoringMath112 {
159     function add(uint112 a, uint112 b) internal pure returns (uint112 c) {
160         require((c = a + b) >= b, "BoringMath: Add Overflow");
161     }
162 
163     function sub(uint112 a, uint112 b) internal pure returns (uint112 c) {
164         require((c = a - b) <= a, "BoringMath: Underflow");
165     }
166 
167     function mul(uint112 a, uint112 b) internal pure returns (uint112 c) {
168         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
169     }
170     
171     function div(uint112 a, uint112 b) internal pure returns (uint112) {
172         require(b > 0, "BoringMath: division by zero");
173         return a / b;
174     }
175 }
176 
177 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint224.
178 library BoringMath224 {
179     function add(uint224 a, uint224 b) internal pure returns (uint224 c) {
180         require((c = a + b) >= b, "BoringMath: Add Overflow");
181     }
182 
183     function sub(uint224 a, uint224 b) internal pure returns (uint224 c) {
184         require((c = a - b) <= a, "BoringMath: Underflow");
185     }
186 
187     function mul(uint224 a, uint224 b) internal pure returns (uint224 c) {
188         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
189     }
190     
191     function div(uint224 a, uint224 b) internal pure returns (uint224) {
192         require(b > 0, "BoringMath: division by zero");
193         return a / b;
194     }
195 }
196 
197 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
198 
199 pragma solidity >=0.6.0 <0.8.0;
200 
201 /**
202  * @dev Interface of the ERC20 standard as defined in the EIP.
203  */
204 interface IERC20 {
205     /**
206      * @dev Returns the amount of tokens in existence.
207      */
208     function totalSupply() external view returns (uint256);
209 
210     /**
211      * @dev Returns the amount of tokens owned by `account`.
212      */
213     function balanceOf(address account) external view returns (uint256);
214 
215     /**
216      * @dev Moves `amount` tokens from the caller's account to `recipient`.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transfer(address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Returns the remaining number of tokens that `spender` will be
226      * allowed to spend on behalf of `owner` through {transferFrom}. This is
227      * zero by default.
228      *
229      * This value changes when {approve} or {transferFrom} are called.
230      */
231     function allowance(address owner, address spender) external view returns (uint256);
232 
233     /**
234      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * IMPORTANT: Beware that changing an allowance with this method brings the risk
239      * that someone may use both the old and the new allowance by unfortunate
240      * transaction ordering. One possible solution to mitigate this race
241      * condition is to first reduce the spender's allowance to 0 and set the
242      * desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address spender, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Moves `amount` tokens from `sender` to `recipient` using the
251      * allowance mechanism. `amount` is then deducted from the caller's
252      * allowance.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Emitted when `value` tokens are moved from one account (`from`) to
262      * another (`to`).
263      *
264      * Note that `value` may be zero.
265      */
266     event Transfer(address indexed from, address indexed to, uint256 value);
267 
268     /**
269      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
270      * a call to {approve}. `value` is the new allowance.
271      */
272     event Approval(address indexed owner, address indexed spender, uint256 value);
273 }
274 
275 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
276 pragma solidity >=0.6.0 <0.8.0;
277 
278 /**
279  * @dev Wrappers over Solidity's arithmetic operations with added overflow
280  * checks.
281  *
282  * Arithmetic operations in Solidity wrap on overflow. This can easily result
283  * in bugs, because programmers usually assume that an overflow raises an
284  * error, which is the standard behavior in high level programming languages.
285  * `SafeMath` restores this intuition by reverting the transaction when an
286  * operation overflows.
287  *
288  * Using this library instead of the unchecked operations eliminates an entire
289  * class of bugs, so it's recommended to use it always.
290  */
291 library SafeMath {
292     /**
293      * @dev Returns the addition of two unsigned integers, with an overflow flag.
294      *
295      * _Available since v3.4._
296      */
297     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
298         uint256 c = a + b;
299         if (c < a) return (false, 0);
300         return (true, c);
301     }
302 
303     /**
304      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
305      *
306      * _Available since v3.4._
307      */
308     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
309         if (b > a) return (false, 0);
310         return (true, a - b);
311     }
312 
313     /**
314      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
315      *
316      * _Available since v3.4._
317      */
318     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
319         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
320         // benefit is lost if 'b' is also tested.
321         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
322         if (a == 0) return (true, 0);
323         uint256 c = a * b;
324         if (c / a != b) return (false, 0);
325         return (true, c);
326     }
327 
328     /**
329      * @dev Returns the division of two unsigned integers, with a division by zero flag.
330      *
331      * _Available since v3.4._
332      */
333     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
334         if (b == 0) return (false, 0);
335         return (true, a / b);
336     }
337 
338     /**
339      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
340      *
341      * _Available since v3.4._
342      */
343     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
344         if (b == 0) return (false, 0);
345         return (true, a % b);
346     }
347 
348     /**
349      * @dev Returns the addition of two unsigned integers, reverting on
350      * overflow.
351      *
352      * Counterpart to Solidity's `+` operator.
353      *
354      * Requirements:
355      *
356      * - Addition cannot overflow.
357      */
358     function add(uint256 a, uint256 b) internal pure returns (uint256) {
359         uint256 c = a + b;
360         require(c >= a, "SafeMath: addition overflow");
361         return c;
362     }
363 
364     /**
365      * @dev Returns the subtraction of two unsigned integers, reverting on
366      * overflow (when the result is negative).
367      *
368      * Counterpart to Solidity's `-` operator.
369      *
370      * Requirements:
371      *
372      * - Subtraction cannot overflow.
373      */
374     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
375         require(b <= a, "SafeMath: subtraction overflow");
376         return a - b;
377     }
378 
379     /**
380      * @dev Returns the multiplication of two unsigned integers, reverting on
381      * overflow.
382      *
383      * Counterpart to Solidity's `*` operator.
384      *
385      * Requirements:
386      *
387      * - Multiplication cannot overflow.
388      */
389     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
390         if (a == 0) return 0;
391         uint256 c = a * b;
392         require(c / a == b, "SafeMath: multiplication overflow");
393         return c;
394     }
395 
396     /**
397      * @dev Returns the integer division of two unsigned integers, reverting on
398      * division by zero. The result is rounded towards zero.
399      *
400      * Counterpart to Solidity's `/` operator. Note: this function uses a
401      * `revert` opcode (which leaves remaining gas untouched) while Solidity
402      * uses an invalid opcode to revert (consuming all remaining gas).
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function div(uint256 a, uint256 b) internal pure returns (uint256) {
409         require(b > 0, "SafeMath: division by zero");
410         return a / b;
411     }
412 
413     /**
414      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
415      * reverting when dividing by zero.
416      *
417      * Counterpart to Solidity's `%` operator. This function uses a `revert`
418      * opcode (which leaves remaining gas untouched) while Solidity uses an
419      * invalid opcode to revert (consuming all remaining gas).
420      *
421      * Requirements:
422      *
423      * - The divisor cannot be zero.
424      */
425     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
426         require(b > 0, "SafeMath: modulo by zero");
427         return a % b;
428     }
429 
430     /**
431      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
432      * overflow (when the result is negative).
433      *
434      * CAUTION: This function is deprecated because it requires allocating memory for the error
435      * message unnecessarily. For custom revert reasons use {trySub}.
436      *
437      * Counterpart to Solidity's `-` operator.
438      *
439      * Requirements:
440      *
441      * - Subtraction cannot overflow.
442      */
443     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
444         require(b <= a, errorMessage);
445         return a - b;
446     }
447 
448     /**
449      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
450      * division by zero. The result is rounded towards zero.
451      *
452      * CAUTION: This function is deprecated because it requires allocating memory for the error
453      * message unnecessarily. For custom revert reasons use {tryDiv}.
454      *
455      * Counterpart to Solidity's `/` operator. Note: this function uses a
456      * `revert` opcode (which leaves remaining gas untouched) while Solidity
457      * uses an invalid opcode to revert (consuming all remaining gas).
458      *
459      * Requirements:
460      *
461      * - The divisor cannot be zero.
462      */
463     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
464         require(b > 0, errorMessage);
465         return a / b;
466     }
467 
468     /**
469      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
470      * reverting with custom message when dividing by zero.
471      *
472      * CAUTION: This function is deprecated because it requires allocating memory for the error
473      * message unnecessarily. For custom revert reasons use {tryMod}.
474      *
475      * Counterpart to Solidity's `%` operator. This function uses a `revert`
476      * opcode (which leaves remaining gas untouched) while Solidity uses an
477      * invalid opcode to revert (consuming all remaining gas).
478      *
479      * Requirements:
480      *
481      * - The divisor cannot be zero.
482      */
483     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
484         require(b > 0, errorMessage);
485         return a % b;
486     }
487 }
488 
489 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
490 
491 pragma solidity >=0.6.2 <0.8.0;
492 
493 /**
494  * @dev Collection of functions related to the address type
495  */
496 library Address {
497     /**
498      * @dev Returns true if `account` is a contract.
499      *
500      * [IMPORTANT]
501      * ====
502      * It is unsafe to assume that an address for which this function returns
503      * false is an externally-owned account (EOA) and not a contract.
504      *
505      * Among others, `isContract` will return false for the following
506      * types of addresses:
507      *
508      *  - an externally-owned account
509      *  - a contract in construction
510      *  - an address where a contract will be created
511      *  - an address where a contract lived, but was destroyed
512      * ====
513      */
514     function isContract(address account) internal view returns (bool) {
515         // This method relies on extcodesize, which returns 0 for contracts in
516         // construction, since the code is only stored at the end of the
517         // constructor execution.
518 
519         uint256 size;
520         // solhint-disable-next-line no-inline-assembly
521         assembly { size := extcodesize(account) }
522         return size > 0;
523     }
524 
525     /**
526      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
527      * `recipient`, forwarding all available gas and reverting on errors.
528      *
529      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
530      * of certain opcodes, possibly making contracts go over the 2300 gas limit
531      * imposed by `transfer`, making them unable to receive funds via
532      * `transfer`. {sendValue} removes this limitation.
533      *
534      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
535      *
536      * IMPORTANT: because control is transferred to `recipient`, care must be
537      * taken to not create reentrancy vulnerabilities. Consider using
538      * {ReentrancyGuard} or the
539      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
540      */
541     function sendValue(address payable recipient, uint256 amount) internal {
542         require(address(this).balance >= amount, "Address: insufficient balance");
543 
544         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
545         (bool success, ) = recipient.call{ value: amount }("");
546         require(success, "Address: unable to send value, recipient may have reverted");
547     }
548 
549     /**
550      * @dev Performs a Solidity function call using a low level `call`. A
551      * plain`call` is an unsafe replacement for a function call: use this
552      * function instead.
553      *
554      * If `target` reverts with a revert reason, it is bubbled up by this
555      * function (like regular Solidity function calls).
556      *
557      * Returns the raw returned data. To convert to the expected return value,
558      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
559      *
560      * Requirements:
561      *
562      * - `target` must be a contract.
563      * - calling `target` with `data` must not revert.
564      *
565      * _Available since v3.1._
566      */
567     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
568       return functionCall(target, data, "Address: low-level call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
573      * `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, 0, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but also transferring `value` wei to `target`.
584      *
585      * Requirements:
586      *
587      * - the calling contract must have an ETH balance of at least `value`.
588      * - the called Solidity function must be `payable`.
589      *
590      * _Available since v3.1._
591      */
592     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
593         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
598      * with `errorMessage` as a fallback revert reason when `target` reverts.
599      *
600      * _Available since v3.1._
601      */
602     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
603         require(address(this).balance >= value, "Address: insufficient balance for call");
604         require(isContract(target), "Address: call to non-contract");
605 
606         // solhint-disable-next-line avoid-low-level-calls
607         (bool success, bytes memory returndata) = target.call{ value: value }(data);
608         return _verifyCallResult(success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
613      * but performing a static call.
614      *
615      * _Available since v3.3._
616      */
617     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
618         return functionStaticCall(target, data, "Address: low-level static call failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
623      * but performing a static call.
624      *
625      * _Available since v3.3._
626      */
627     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
628         require(isContract(target), "Address: static call to non-contract");
629 
630         // solhint-disable-next-line avoid-low-level-calls
631         (bool success, bytes memory returndata) = target.staticcall(data);
632         return _verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but performing a delegate call.
638      *
639      * _Available since v3.4._
640      */
641     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
642         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
643     }
644 
645     /**
646      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
647      * but performing a delegate call.
648      *
649      * _Available since v3.4._
650      */
651     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
652         require(isContract(target), "Address: delegate call to non-contract");
653 
654         // solhint-disable-next-line avoid-low-level-calls
655         (bool success, bytes memory returndata) = target.delegatecall(data);
656         return _verifyCallResult(success, returndata, errorMessage);
657     }
658 
659     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
660         if (success) {
661             return returndata;
662         } else {
663             // Look for revert reason and bubble it up if present
664             if (returndata.length > 0) {
665                 // The easiest way to bubble the revert reason is using memory via assembly
666 
667                 // solhint-disable-next-line no-inline-assembly
668                 assembly {
669                     let returndata_size := mload(returndata)
670                     revert(add(32, returndata), returndata_size)
671                 }
672             } else {
673                 revert(errorMessage);
674             }
675         }
676     }
677 }
678 
679 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
680 
681 pragma solidity >=0.6.0 <0.8.0;
682 
683 
684 /**
685  * @title SafeERC20
686  * @dev Wrappers around ERC20 operations that throw on failure (when the token
687  * contract returns false). Tokens that return no value (and instead revert or
688  * throw on failure) are also supported, non-reverting calls are assumed to be
689  * successful.
690  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
691  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
692  */
693 library SafeERC20 {
694     using SafeMath for uint256;
695     using Address for address;
696 
697     function safeTransfer(IERC20 token, address to, uint256 value) internal {
698         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
699     }
700 
701     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
702         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
703     }
704 
705     /**
706      * @dev Deprecated. This function has issues similar to the ones found in
707      * {IERC20-approve}, and its usage is discouraged.
708      *
709      * Whenever possible, use {safeIncreaseAllowance} and
710      * {safeDecreaseAllowance} instead.
711      */
712     function safeApprove(IERC20 token, address spender, uint256 value) internal {
713         // safeApprove should only be called when setting an initial allowance,
714         // or when resetting it to zero. To increase and decrease it, use
715         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
716         // solhint-disable-next-line max-line-length
717         require((value == 0) || (token.allowance(address(this), spender) == 0),
718             "SafeERC20: approve from non-zero to non-zero allowance"
719         );
720         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
721     }
722 
723     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
724         uint256 newAllowance = token.allowance(address(this), spender).add(value);
725         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
726     }
727 
728     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
729         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
730         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
731     }
732 
733     /**
734      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
735      * on the return value: the return value is optional (but if data is returned, it must not be false).
736      * @param token The token targeted by the call.
737      * @param data The call data (encoded using abi.encode or one of its variants).
738      */
739     function _callOptionalReturn(IERC20 token, bytes memory data) private {
740         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
741         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
742         // the target address contains contract code and also asserts for success in the low-level call.
743 
744         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
745         if (returndata.length > 0) { // Return data is optional
746             // solhint-disable-next-line max-line-length
747             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
748         }
749     }
750 }
751 
752 // File: @openzeppelin\contracts\math\Math.sol
753 
754 pragma solidity >=0.6.0 <0.8.0;
755 
756 /**
757  * @dev Standard math utilities missing in the Solidity language.
758  */
759 library Math {
760     /**
761      * @dev Returns the largest of two numbers.
762      */
763     function max(uint256 a, uint256 b) internal pure returns (uint256) {
764         return a >= b ? a : b;
765     }
766 
767     /**
768      * @dev Returns the smallest of two numbers.
769      */
770     function min(uint256 a, uint256 b) internal pure returns (uint256) {
771         return a < b ? a : b;
772     }
773 
774     /**
775      * @dev Returns the average of two numbers. The result is rounded towards
776      * zero.
777      */
778     function average(uint256 a, uint256 b) internal pure returns (uint256) {
779         // (a + b) / 2 can overflow, so we distribute
780         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
781     }
782 }
783 
784 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
785 
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
878 pragma solidity >=0.6.0 <0.8.0;
879 
880 /**
881  * @dev Contract module that helps prevent reentrant calls to a function.
882  *
883  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
884  * available, which can be applied to functions to make sure there are no nested
885  * (reentrant) calls to them.
886  *
887  * Note that because there is a single `nonReentrant` guard, functions marked as
888  * `nonReentrant` may not call one another. This can be worked around by making
889  * those functions `private`, and then adding `external` `nonReentrant` entry
890  * points to them.
891  *
892  * TIP: If you would like to learn more about reentrancy and alternative ways
893  * to protect against it, check out our blog post
894  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
895  */
896 abstract contract ReentrancyGuard {
897     // Booleans are more expensive than uint256 or any type that takes up a full
898     // word because each write operation emits an extra SLOAD to first read the
899     // slot's contents, replace the bits taken up by the boolean, and then write
900     // back. This is the compiler's defense against contract upgrades and
901     // pointer aliasing, and it cannot be disabled.
902 
903     // The values being non-zero value makes deployment a bit more expensive,
904     // but in exchange the refund on every call to nonReentrant will be lower in
905     // amount. Since refunds are capped to a percentage of the total
906     // transaction's gas, it is best to keep them low in cases like this one, to
907     // increase the likelihood of the full refund coming into effect.
908     uint256 private constant _NOT_ENTERED = 1;
909     uint256 private constant _ENTERED = 2;
910 
911     uint256 private _status;
912 
913     constructor () internal {
914         _status = _NOT_ENTERED;
915     }
916 
917     /**
918      * @dev Prevents a contract from calling itself, directly or indirectly.
919      * Calling a `nonReentrant` function from another `nonReentrant`
920      * function is not supported. It is possible to prevent this from happening
921      * by making the `nonReentrant` function external, and make it call a
922      * `private` function that does the actual work.
923      */
924     modifier nonReentrant() {
925         // On the first call to nonReentrant, _notEntered will be true
926         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
927 
928         // Any calls to nonReentrant after this point will fail
929         _status = _ENTERED;
930 
931         _;
932 
933         // By storing the original value once again, a refund is triggered (see
934         // https://eips.ethereum.org/EIPS/eip-2200)
935         _status = _NOT_ENTERED;
936     }
937 }
938 
939 // File: contracts\CvxLocker.sol
940 
941 pragma solidity 0.6.12;
942 pragma experimental ABIEncoderV2;
943 
944 // CVX Locking contract for https://www.convexfinance.com/
945 // CVX locked in this contract will be entitled to voting rights for the Convex Finance platform
946 // Based on EPS Staking contract for http://ellipsis.finance/
947 // Based on SNX MultiRewards by iamdefinitelyahuman - https://github.com/iamdefinitelyahuman/multi-rewards
948 contract CvxLocker is ReentrancyGuard, Ownable {
949 
950     using BoringMath for uint256;
951     using BoringMath224 for uint224;
952     using BoringMath112 for uint112;
953     using BoringMath32 for uint32;
954     using SafeERC20
955     for IERC20;
956 
957     /* ========== STATE VARIABLES ========== */
958 
959     struct Reward {
960         bool useBoost;
961         uint40 periodFinish;
962         uint208 rewardRate;
963         uint40 lastUpdateTime;
964         uint208 rewardPerTokenStored;
965     }
966     struct Balances {
967         uint112 locked;
968         uint112 boosted;
969         uint32 nextUnlockIndex;
970     }
971     struct LockedBalance {
972         uint112 amount;
973         uint112 boosted;
974         uint32 unlockTime;
975     }
976     struct EarnedData {
977         address token;
978         uint256 amount;
979     }
980     struct Epoch {
981         uint224 supply; //epoch boosted supply
982         uint32 date; //epoch start date
983     }
984 
985     //token constants
986     IERC20 public constant stakingToken = IERC20(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B); //cvx
987     address public constant cvxCrv = address(0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7);
988 
989     //rewards
990     address[] public rewardTokens;
991     mapping(address => Reward) public rewardData;
992 
993     // Duration that rewards are streamed over
994     uint256 public constant rewardsDuration = 86400 * 7;
995 
996     // Duration of lock/earned penalty period
997     uint256 public constant lockDuration = rewardsDuration * 17;
998 
999     // reward token -> distributor -> is approved to add rewards
1000     mapping(address => mapping(address => bool)) public rewardDistributors;
1001 
1002     // user -> reward token -> amount
1003     mapping(address => mapping(address => uint256)) public userRewardPerTokenPaid;
1004     mapping(address => mapping(address => uint256)) public rewards;
1005 
1006     //supplies and epochs
1007     uint256 public lockedSupply;
1008     uint256 public boostedSupply;
1009     Epoch[] public epochs;
1010 
1011     //mappings for balance data
1012     mapping(address => Balances) public balances;
1013     mapping(address => LockedBalance[]) public userLocks;
1014 
1015     //boost
1016     address public boostPayment = address(0x1389388d01708118b497f59521f6943Be2541bb7);
1017     uint256 public maximumBoostPayment = 0;
1018     uint256 public boostRate = 10000;
1019     uint256 public nextMaximumBoostPayment = 0;
1020     uint256 public nextBoostRate = 10000;
1021     uint256 public constant denominator = 10000;
1022 
1023     //staking
1024     uint256 public minimumStake = 10000;
1025     uint256 public maximumStake = 10000;
1026     address public stakingProxy;
1027     address public constant cvxcrvStaking = address(0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e);
1028     uint256 public constant stakeOffsetOnLock = 500; //allow broader range for staking when depositing
1029 
1030     //management
1031     uint256 public kickRewardPerEpoch = 100;
1032     uint256 public kickRewardEpochDelay = 4;
1033 
1034     //shutdown
1035     bool public isShutdown = false;
1036 
1037     //erc20-like interface
1038     string private _name;
1039     string private _symbol;
1040     uint8 private immutable _decimals;
1041 
1042     /* ========== CONSTRUCTOR ========== */
1043 
1044     constructor() public Ownable() {
1045         _name = "Vote Locked Convex Token";
1046         _symbol = "vlCVX";
1047         _decimals = 18;
1048 
1049         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1050         epochs.push(Epoch({
1051             supply: 0,
1052             date: uint32(currentEpoch)
1053         }));
1054     }
1055 
1056     function decimals() public view returns (uint8) {
1057         return _decimals;
1058     }
1059     function name() public view returns (string memory) {
1060         return _name;
1061     }
1062     function symbol() public view returns (string memory) {
1063         return _symbol;
1064     }
1065 
1066     /* ========== ADMIN CONFIGURATION ========== */
1067 
1068     // Add a new reward token to be distributed to stakers
1069     function addReward(
1070         address _rewardsToken,
1071         address _distributor,
1072         bool _useBoost
1073     ) public onlyOwner {
1074         require(rewardData[_rewardsToken].lastUpdateTime == 0);
1075         require(_rewardsToken != address(stakingToken));
1076         rewardTokens.push(_rewardsToken);
1077         rewardData[_rewardsToken].lastUpdateTime = uint40(block.timestamp);
1078         rewardData[_rewardsToken].periodFinish = uint40(block.timestamp);
1079         rewardData[_rewardsToken].useBoost = _useBoost;
1080         rewardDistributors[_rewardsToken][_distributor] = true;
1081     }
1082 
1083     // Modify approval for an address to call notifyRewardAmount
1084     function approveRewardDistributor(
1085         address _rewardsToken,
1086         address _distributor,
1087         bool _approved
1088     ) external onlyOwner {
1089         require(rewardData[_rewardsToken].lastUpdateTime > 0);
1090         rewardDistributors[_rewardsToken][_distributor] = _approved;
1091     }
1092 
1093     //Set the staking contract for the underlying cvx. only allow change if nothing is currently staked
1094     function setStakingContract(address _staking) external onlyOwner {
1095         require(stakingProxy == address(0) || (minimumStake == 0 && maximumStake == 0), "!assign");
1096 
1097         stakingProxy = _staking;
1098     }
1099 
1100     //set staking limits. will stake the mean of the two once either ratio is crossed
1101     function setStakeLimits(uint256 _minimum, uint256 _maximum) external onlyOwner {
1102         require(_minimum <= denominator, "min range");
1103         require(_maximum <= denominator, "max range");
1104         minimumStake = _minimum;
1105         maximumStake = _maximum;
1106         updateStakeRatio(0);
1107     }
1108 
1109     //set boost parameters
1110     function setBoost(uint256 _max, uint256 _rate, address _receivingAddress) external onlyOwner {
1111         require(maximumBoostPayment < 1500, "over max payment"); //max 15%
1112         require(boostRate < 30000, "over max rate"); //max 3x
1113         require(_receivingAddress != address(0), "invalid address"); //must point somewhere valid
1114         nextMaximumBoostPayment = _max;
1115         nextBoostRate = _rate;
1116         boostPayment = _receivingAddress;
1117     }
1118 
1119     //set kick incentive
1120     function setKickIncentive(uint256 _rate, uint256 _delay) external onlyOwner {
1121         require(_rate <= 500, "over max rate"); //max 5% per epoch
1122         require(_delay >= 2, "min delay"); //minimum 2 epochs of grace
1123         kickRewardPerEpoch = _rate;
1124         kickRewardEpochDelay = _delay;
1125     }
1126 
1127     //shutdown the contract. unstake all tokens. release all locks
1128     function shutdown() external onlyOwner {
1129         if (stakingProxy != address(0)) {
1130             uint256 stakeBalance = IStakingProxy(stakingProxy).getBalance();
1131             IStakingProxy(stakingProxy).withdraw(stakeBalance);
1132         }
1133         isShutdown = true;
1134     }
1135 
1136     //set approvals for staking cvx and cvxcrv
1137     function setApprovals() external {
1138         IERC20(cvxCrv).safeApprove(cvxcrvStaking, 0);
1139         IERC20(cvxCrv).safeApprove(cvxcrvStaking, uint256(-1));
1140 
1141         IERC20(stakingToken).safeApprove(stakingProxy, 0);
1142         IERC20(stakingToken).safeApprove(stakingProxy, uint256(-1));
1143     }
1144 
1145     /* ========== VIEWS ========== */
1146 
1147     function _rewardPerToken(address _rewardsToken) internal view returns(uint256) {
1148         if (boostedSupply == 0) {
1149             return rewardData[_rewardsToken].rewardPerTokenStored;
1150         }
1151         return
1152         uint256(rewardData[_rewardsToken].rewardPerTokenStored).add(
1153             _lastTimeRewardApplicable(rewardData[_rewardsToken].periodFinish).sub(
1154                 rewardData[_rewardsToken].lastUpdateTime).mul(
1155                 rewardData[_rewardsToken].rewardRate).mul(1e18).div(rewardData[_rewardsToken].useBoost ? boostedSupply : lockedSupply)
1156         );
1157     }
1158 
1159     function _earned(
1160         address _user,
1161         address _rewardsToken,
1162         uint256 _balance
1163     ) internal view returns(uint256) {
1164         return _balance.mul(
1165             _rewardPerToken(_rewardsToken).sub(userRewardPerTokenPaid[_user][_rewardsToken])
1166         ).div(1e18).add(rewards[_user][_rewardsToken]);
1167     }
1168 
1169     function _lastTimeRewardApplicable(uint256 _finishTime) internal view returns(uint256){
1170         return Math.min(block.timestamp, _finishTime);
1171     }
1172 
1173     function lastTimeRewardApplicable(address _rewardsToken) public view returns(uint256) {
1174         return _lastTimeRewardApplicable(rewardData[_rewardsToken].periodFinish);
1175     }
1176 
1177     function rewardPerToken(address _rewardsToken) external view returns(uint256) {
1178         return _rewardPerToken(_rewardsToken);
1179     }
1180 
1181     function getRewardForDuration(address _rewardsToken) external view returns(uint256) {
1182         return uint256(rewardData[_rewardsToken].rewardRate).mul(rewardsDuration);
1183     }
1184 
1185     // Address and claimable amount of all reward tokens for the given account
1186     function claimableRewards(address _account) external view returns(EarnedData[] memory userRewards) {
1187         userRewards = new EarnedData[](rewardTokens.length);
1188         Balances storage userBalance = balances[_account];
1189         uint256 boostedBal = userBalance.boosted;
1190         for (uint256 i = 0; i < userRewards.length; i++) {
1191             address token = rewardTokens[i];
1192             userRewards[i].token = token;
1193             userRewards[i].amount = _earned(_account, token, rewardData[token].useBoost ? boostedBal : userBalance.locked);
1194         }
1195         return userRewards;
1196     }
1197 
1198     // Total BOOSTED balance of an account, including unlocked but not withdrawn tokens
1199     function rewardWeightOf(address _user) view external returns(uint256 amount) {
1200         return balances[_user].boosted;
1201     }
1202 
1203     // total token balance of an account, including unlocked but not withdrawn tokens
1204     function lockedBalanceOf(address _user) view external returns(uint256 amount) {
1205         return balances[_user].locked;
1206     }
1207 
1208     //BOOSTED balance of an account which only includes properly locked tokens as of the most recent eligible epoch
1209     function balanceOf(address _user) view external returns(uint256 amount) {
1210         LockedBalance[] storage locks = userLocks[_user];
1211         Balances storage userBalance = balances[_user];
1212         uint256 nextUnlockIndex = userBalance.nextUnlockIndex;
1213 
1214         //start with current boosted amount
1215         amount = balances[_user].boosted;
1216 
1217         uint256 locksLength = locks.length;
1218         //remove old records only (will be better gas-wise than adding up)
1219         for (uint i = nextUnlockIndex; i < locksLength; i++) {
1220             if (locks[i].unlockTime <= block.timestamp) {
1221                 amount = amount.sub(locks[i].boosted);
1222             } else {
1223                 //stop now as no futher checks are needed
1224                 break;
1225             }
1226         }
1227 
1228         //also remove amount in the current epoch
1229         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1230         if (locksLength > 0 && uint256(locks[locksLength - 1].unlockTime).sub(lockDuration) == currentEpoch) {
1231             amount = amount.sub(locks[locksLength - 1].boosted);
1232         }
1233 
1234         return amount;
1235     }
1236 
1237     //BOOSTED balance of an account which only includes properly locked tokens at the given epoch
1238     function balanceAtEpochOf(uint256 _epoch, address _user) view external returns(uint256 amount) {
1239         LockedBalance[] storage locks = userLocks[_user];
1240 
1241         //get timestamp of given epoch index
1242         uint256 epochTime = epochs[_epoch].date;
1243         //get timestamp of first non-inclusive epoch
1244         uint256 cutoffEpoch = epochTime.sub(lockDuration);
1245 
1246         //current epoch is not counted
1247         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1248 
1249         //need to add up since the range could be in the middle somewhere
1250         //traverse inversely to make more current queries more gas efficient
1251         for (uint i = locks.length - 1; i + 1 != 0; i--) {
1252             uint256 lockEpoch = uint256(locks[i].unlockTime).sub(lockDuration);
1253             //lock epoch must be less or equal to the epoch we're basing from.
1254             //also not include the current epoch
1255             if (lockEpoch <= epochTime && lockEpoch < currentEpoch) {
1256                 if (lockEpoch > cutoffEpoch) {
1257                     amount = amount.add(locks[i].boosted);
1258                 } else {
1259                     //stop now as no futher checks matter
1260                     break;
1261                 }
1262             }
1263         }
1264 
1265         return amount;
1266     }
1267 
1268     //supply of all properly locked BOOSTED balances at most recent eligible epoch
1269     function totalSupply() view external returns(uint256 supply) {
1270 
1271         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1272         uint256 cutoffEpoch = currentEpoch.sub(lockDuration);
1273         uint256 epochindex = epochs.length;
1274 
1275         //do not include current epoch's supply
1276         if ( uint256(epochs[epochindex - 1].date) == currentEpoch) {
1277             epochindex--;
1278         }
1279 
1280         //traverse inversely to make more current queries more gas efficient
1281         for (uint i = epochindex - 1; i + 1 != 0; i--) {
1282             Epoch storage e = epochs[i];
1283             if (uint256(e.date) <= cutoffEpoch) {
1284                 break;
1285             }
1286             supply = supply.add(e.supply);
1287         }
1288 
1289         return supply;
1290     }
1291 
1292     //supply of all properly locked BOOSTED balances at the given epoch
1293     function totalSupplyAtEpoch(uint256 _epoch) view external returns(uint256 supply) {
1294 
1295         uint256 epochStart = uint256(epochs[_epoch].date).div(rewardsDuration).mul(rewardsDuration);
1296         uint256 cutoffEpoch = epochStart.sub(lockDuration);
1297         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1298 
1299         //do not include current epoch's supply
1300         if (uint256(epochs[_epoch].date) == currentEpoch) {
1301             _epoch--;
1302         }
1303 
1304         //traverse inversely to make more current queries more gas efficient
1305         for (uint i = _epoch; i + 1 != 0; i--) {
1306             Epoch storage e = epochs[i];
1307             if (uint256(e.date) <= cutoffEpoch) {
1308                 break;
1309             }
1310             supply = supply.add(epochs[i].supply);
1311         }
1312 
1313         return supply;
1314     }
1315 
1316     //find an epoch index based on timestamp
1317     function findEpochId(uint256 _time) view external returns(uint256 epoch) {
1318         uint256 max = epochs.length - 1;
1319         uint256 min = 0;
1320 
1321         //convert to start point
1322         _time = _time.div(rewardsDuration).mul(rewardsDuration);
1323 
1324         for (uint256 i = 0; i < 128; i++) {
1325             if (min >= max) break;
1326 
1327             uint256 mid = (min + max + 1) / 2;
1328             uint256 midEpochBlock = epochs[mid].date;
1329             if(midEpochBlock == _time){
1330                 //found
1331                 return mid;
1332             }else if (midEpochBlock < _time) {
1333                 min = mid;
1334             } else{
1335                 max = mid - 1;
1336             }
1337         }
1338         return min;
1339     }
1340 
1341 
1342     // Information on a user's locked balances
1343     function lockedBalances(
1344         address _user
1345     ) view external returns(
1346         uint256 total,
1347         uint256 unlockable,
1348         uint256 locked,
1349         LockedBalance[] memory lockData
1350     ) {
1351         LockedBalance[] storage locks = userLocks[_user];
1352         Balances storage userBalance = balances[_user];
1353         uint256 nextUnlockIndex = userBalance.nextUnlockIndex;
1354         uint256 idx;
1355         for (uint i = nextUnlockIndex; i < locks.length; i++) {
1356             if (locks[i].unlockTime > block.timestamp) {
1357                 if (idx == 0) {
1358                     lockData = new LockedBalance[](locks.length - i);
1359                 }
1360                 lockData[idx] = locks[i];
1361                 idx++;
1362                 locked = locked.add(locks[i].amount);
1363             } else {
1364                 unlockable = unlockable.add(locks[i].amount);
1365             }
1366         }
1367         return (userBalance.locked, unlockable, locked, lockData);
1368     }
1369 
1370     //number of epochs
1371     function epochCount() external view returns(uint256) {
1372         return epochs.length;
1373     }
1374 
1375     /* ========== MUTATIVE FUNCTIONS ========== */
1376 
1377     function checkpointEpoch() external {
1378         _checkpointEpoch();
1379     }
1380 
1381     //insert a new epoch if needed. fill in any gaps
1382     function _checkpointEpoch() internal {
1383         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1384         uint256 epochindex = epochs.length;
1385 
1386         //first epoch add in constructor, no need to check 0 length
1387 
1388         //check to add
1389         if (epochs[epochindex - 1].date < currentEpoch) {
1390             //fill any epoch gaps
1391             while(epochs[epochs.length-1].date != currentEpoch){
1392                 uint256 nextEpochDate = uint256(epochs[epochs.length-1].date).add(rewardsDuration);
1393                 epochs.push(Epoch({
1394                     supply: 0,
1395                     date: uint32(nextEpochDate)
1396                 }));
1397             }
1398 
1399             //update boost parameters on a new epoch
1400             if(boostRate != nextBoostRate){
1401                 boostRate = nextBoostRate;
1402             }
1403             if(maximumBoostPayment != nextMaximumBoostPayment){
1404                 maximumBoostPayment = nextMaximumBoostPayment;
1405             }
1406         }
1407     }
1408 
1409     // Locked tokens cannot be withdrawn for lockDuration and are eligible to receive stakingReward rewards
1410     function lock(address _account, uint256 _amount, uint256 _spendRatio) external nonReentrant updateReward(_account) {
1411 
1412         //pull tokens
1413         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
1414 
1415         //lock
1416         _lock(_account, _amount, _spendRatio);
1417     }
1418 
1419     //lock tokens
1420     function _lock(address _account, uint256 _amount, uint256 _spendRatio) internal {
1421         require(_amount > 0, "Cannot stake 0");
1422         require(_spendRatio <= maximumBoostPayment, "over max spend");
1423         require(!isShutdown, "shutdown");
1424 
1425         Balances storage bal = balances[_account];
1426 
1427         //must try check pointing epoch first
1428         _checkpointEpoch();
1429 
1430         //calc lock and boosted amount
1431         uint256 spendAmount = _amount.mul(_spendRatio).div(denominator);
1432         uint256 boostRatio = boostRate.mul(_spendRatio).div(maximumBoostPayment==0?1:maximumBoostPayment);
1433         uint112 lockAmount = _amount.sub(spendAmount).to112();
1434         uint112 boostedAmount = _amount.add(_amount.mul(boostRatio).div(denominator)).to112();
1435 
1436         //add user balances
1437         bal.locked = bal.locked.add(lockAmount);
1438         bal.boosted = bal.boosted.add(boostedAmount);
1439 
1440         //add to total supplies
1441         lockedSupply = lockedSupply.add(lockAmount);
1442         boostedSupply = boostedSupply.add(boostedAmount);
1443 
1444         //add user lock records or add to current
1445         uint256 currentEpoch = block.timestamp.div(rewardsDuration).mul(rewardsDuration);
1446         uint256 unlockTime = currentEpoch.add(lockDuration);
1447         uint256 idx = userLocks[_account].length;
1448         if (idx == 0 || userLocks[_account][idx - 1].unlockTime < unlockTime) {
1449             userLocks[_account].push(LockedBalance({
1450                 amount: lockAmount,
1451                 boosted: boostedAmount,
1452                 unlockTime: uint32(unlockTime)
1453             }));
1454         } else {
1455             LockedBalance storage userL = userLocks[_account][idx - 1];
1456             userL.amount = userL.amount.add(lockAmount);
1457             userL.boosted = userL.boosted.add(boostedAmount);
1458         }
1459 
1460         
1461         //update epoch supply, epoch checkpointed above so safe to add to latest
1462         Epoch storage e = epochs[epochs.length - 1];
1463         e.supply = e.supply.add(uint224(boostedAmount));
1464 
1465         //send boost payment
1466         if (spendAmount > 0) {
1467             stakingToken.safeTransfer(boostPayment, spendAmount);
1468         }
1469 
1470         //update staking, allow a bit of leeway for smaller deposits to reduce gas
1471         updateStakeRatio(stakeOffsetOnLock);
1472 
1473         emit Staked(_account, _amount, lockAmount, boostedAmount);
1474     }
1475 
1476     // Withdraw all currently locked tokens where the unlock time has passed
1477     function _processExpiredLocks(address _account, bool _relock, uint256 _spendRatio, address _withdrawTo, address _rewardAddress, uint256 _checkDelay) internal updateReward(_account) {
1478         LockedBalance[] storage locks = userLocks[_account];
1479         Balances storage userBalance = balances[_account];
1480         uint112 locked;
1481         uint112 boostedAmount;
1482         uint256 length = locks.length;
1483         uint256 reward = 0;
1484         
1485         if (isShutdown || locks[length - 1].unlockTime <= block.timestamp.sub(_checkDelay)) {
1486             //if time is beyond last lock, can just bundle everything together
1487             locked = userBalance.locked;
1488             boostedAmount = userBalance.boosted;
1489 
1490             //dont delete, just set next index
1491             userBalance.nextUnlockIndex = length.to32();
1492 
1493             //check for kick reward
1494             //this wont have the exact reward rate that you would get if looped through
1495             //but this section is supposed to be for quick and easy low gas processing of all locks
1496             //we'll assume that if the reward was good enough someone would have processed at an earlier epoch
1497             if (_checkDelay > 0) {
1498                 uint256 currentEpoch = block.timestamp.sub(_checkDelay).div(rewardsDuration).mul(rewardsDuration);
1499                 uint256 epochsover = currentEpoch.sub(uint256(locks[length - 1].unlockTime)).div(rewardsDuration);
1500                 uint256 rRate = MathUtil.min(kickRewardPerEpoch.mul(epochsover+1), denominator);
1501                 reward = uint256(locks[length - 1].amount).mul(rRate).div(denominator);
1502             }
1503         } else {
1504 
1505             //use a processed index(nextUnlockIndex) to not loop as much
1506             //deleting does not change array length
1507             uint32 nextUnlockIndex = userBalance.nextUnlockIndex;
1508             for (uint i = nextUnlockIndex; i < length; i++) {
1509                 //unlock time must be less or equal to time
1510                 if (locks[i].unlockTime > block.timestamp.sub(_checkDelay)) break;
1511 
1512                 //add to cumulative amounts
1513                 locked = locked.add(locks[i].amount);
1514                 boostedAmount = boostedAmount.add(locks[i].boosted);
1515 
1516                 //check for kick reward
1517                 //each epoch over due increases reward
1518                 if (_checkDelay > 0) {
1519                     uint256 currentEpoch = block.timestamp.sub(_checkDelay).div(rewardsDuration).mul(rewardsDuration);
1520                     uint256 epochsover = currentEpoch.sub(uint256(locks[i].unlockTime)).div(rewardsDuration);
1521                     uint256 rRate = MathUtil.min(kickRewardPerEpoch.mul(epochsover+1), denominator);
1522                     reward = reward.add( uint256(locks[i].amount).mul(rRate).div(denominator));
1523                 }
1524                 //set next unlock index
1525                 nextUnlockIndex++;
1526             }
1527             //update next unlock index
1528             userBalance.nextUnlockIndex = nextUnlockIndex;
1529         }
1530         require(locked > 0, "no exp locks");
1531 
1532         //update user balances and total supplies
1533         userBalance.locked = userBalance.locked.sub(locked);
1534         userBalance.boosted = userBalance.boosted.sub(boostedAmount);
1535         lockedSupply = lockedSupply.sub(locked);
1536         boostedSupply = boostedSupply.sub(boostedAmount);
1537 
1538         emit Withdrawn(_account, locked, _relock);
1539 
1540         //send process incentive
1541         if (reward > 0) {
1542             //if theres a reward(kicked), it will always be a withdraw only
1543             //preallocate enough cvx from stake contract to pay for both reward and withdraw
1544             allocateCVXForTransfer(uint256(locked));
1545 
1546             //reduce return amount by the kick reward
1547             locked = locked.sub(reward.to112());
1548             
1549             //transfer reward
1550             transferCVX(_rewardAddress, reward, false);
1551 
1552             emit KickReward(_rewardAddress, _account, reward);
1553         }else if(_spendRatio > 0){
1554             //preallocate enough cvx to transfer the boost cost
1555             allocateCVXForTransfer( uint256(locked).mul(_spendRatio).div(denominator) );
1556         }
1557 
1558         //relock or return to user
1559         if (_relock) {
1560             _lock(_withdrawTo, locked, _spendRatio);
1561         } else {
1562             transferCVX(_withdrawTo, locked, true);
1563         }
1564     }
1565 
1566     // Withdraw/relock all currently locked tokens where the unlock time has passed
1567     function processExpiredLocks(bool _relock, uint256 _spendRatio, address _withdrawTo) external nonReentrant {
1568         _processExpiredLocks(msg.sender, _relock, _spendRatio, _withdrawTo, msg.sender, 0);
1569     }
1570 
1571     // Withdraw/relock all currently locked tokens where the unlock time has passed
1572     function processExpiredLocks(bool _relock) external nonReentrant {
1573         _processExpiredLocks(msg.sender, _relock, 0, msg.sender, msg.sender, 0);
1574     }
1575 
1576     function kickExpiredLocks(address _account) external nonReentrant {
1577         //allow kick after grace period of 'kickRewardEpochDelay'
1578         _processExpiredLocks(_account, false, 0, _account, msg.sender, rewardsDuration.mul(kickRewardEpochDelay));
1579     }
1580 
1581     //pull required amount of cvx from staking for an upcoming transfer
1582     function allocateCVXForTransfer(uint256 _amount) internal{
1583         uint256 balance = stakingToken.balanceOf(address(this));
1584         if (_amount > balance) {
1585             IStakingProxy(stakingProxy).withdraw(_amount.sub(balance));
1586         }
1587     }
1588 
1589     //transfer helper: pull enough from staking, transfer, updating staking ratio
1590     function transferCVX(address _account, uint256 _amount, bool _updateStake) internal {
1591         //allocate enough cvx from staking for the transfer
1592         allocateCVXForTransfer(_amount);
1593         //transfer
1594         stakingToken.safeTransfer(_account, _amount);
1595 
1596         //update staking
1597         if(_updateStake){
1598             updateStakeRatio(0);
1599         }
1600     }
1601 
1602     //calculate how much cvx should be staked. update if needed
1603     function updateStakeRatio(uint256 _offset) internal {
1604         if (isShutdown) return;
1605 
1606         //get balances
1607         uint256 local = stakingToken.balanceOf(address(this));
1608         uint256 staked = IStakingProxy(stakingProxy).getBalance();
1609         uint256 total = local.add(staked);
1610         
1611         if(total == 0) return;
1612 
1613         //current staked ratio
1614         uint256 ratio = staked.mul(denominator).div(total);
1615         //mean will be where we reset to if unbalanced
1616         uint256 mean = maximumStake.add(minimumStake).div(2);
1617         uint256 max = maximumStake.add(_offset);
1618         uint256 min = Math.min(minimumStake, minimumStake - _offset);
1619         if (ratio > max) {
1620             //remove
1621             uint256 remove = staked.sub(total.mul(mean).div(denominator));
1622             IStakingProxy(stakingProxy).withdraw(remove);
1623         } else if (ratio < min) {
1624             //add
1625             uint256 increase = total.mul(mean).div(denominator).sub(staked);
1626             stakingToken.safeTransfer(stakingProxy, increase);
1627             IStakingProxy(stakingProxy).stake();
1628         }
1629     }
1630 
1631     // Claim all pending rewards
1632     function getReward(address _account, bool _stake) public nonReentrant updateReward(_account) {
1633         for (uint i; i < rewardTokens.length; i++) {
1634             address _rewardsToken = rewardTokens[i];
1635             uint256 reward = rewards[_account][_rewardsToken];
1636             if (reward > 0) {
1637                 rewards[_account][_rewardsToken] = 0;
1638                 if (_rewardsToken == cvxCrv && _stake) {
1639                     IRewardStaking(cvxcrvStaking).stakeFor(_account, reward);
1640                 } else {
1641                     IERC20(_rewardsToken).safeTransfer(_account, reward);
1642                 }
1643                 emit RewardPaid(_account, _rewardsToken, reward);
1644             }
1645         }
1646     }
1647 
1648     // claim all pending rewards
1649     function getReward(address _account) external{
1650         getReward(_account,false);
1651     }
1652 
1653 
1654     /* ========== RESTRICTED FUNCTIONS ========== */
1655 
1656     function _notifyReward(address _rewardsToken, uint256 _reward) internal {
1657         Reward storage rdata = rewardData[_rewardsToken];
1658 
1659         if (block.timestamp >= rdata.periodFinish) {
1660             rdata.rewardRate = _reward.div(rewardsDuration).to208();
1661         } else {
1662             uint256 remaining = uint256(rdata.periodFinish).sub(block.timestamp);
1663             uint256 leftover = remaining.mul(rdata.rewardRate);
1664             rdata.rewardRate = _reward.add(leftover).div(rewardsDuration).to208();
1665         }
1666 
1667         rdata.lastUpdateTime = block.timestamp.to40();
1668         rdata.periodFinish = block.timestamp.add(rewardsDuration).to40();
1669     }
1670 
1671     function notifyRewardAmount(address _rewardsToken, uint256 _reward) external updateReward(address(0)) {
1672         require(rewardDistributors[_rewardsToken][msg.sender]);
1673         require(_reward > 0, "No reward");
1674 
1675         _notifyReward(_rewardsToken, _reward);
1676 
1677         // handle the transfer of reward tokens via `transferFrom` to reduce the number
1678         // of transactions required and ensure correctness of the _reward amount
1679         IERC20(_rewardsToken).safeTransferFrom(msg.sender, address(this), _reward);
1680         
1681         emit RewardAdded(_rewardsToken, _reward);
1682 
1683         if(_rewardsToken == cvxCrv){
1684             //update staking ratio if main reward
1685             updateStakeRatio(0);
1686         }
1687     }
1688 
1689     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
1690     function recoverERC20(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
1691         require(_tokenAddress != address(stakingToken), "Cannot withdraw staking token");
1692         require(rewardData[_tokenAddress].lastUpdateTime == 0, "Cannot withdraw reward token");
1693         IERC20(_tokenAddress).safeTransfer(owner(), _tokenAmount);
1694         emit Recovered(_tokenAddress, _tokenAmount);
1695     }
1696 
1697     /* ========== MODIFIERS ========== */
1698 
1699     modifier updateReward(address _account) {
1700         {//stack too deep
1701             Balances storage userBalance = balances[_account];
1702             uint256 boostedBal = userBalance.boosted;
1703             for (uint i = 0; i < rewardTokens.length; i++) {
1704                 address token = rewardTokens[i];
1705                 rewardData[token].rewardPerTokenStored = _rewardPerToken(token).to208();
1706                 rewardData[token].lastUpdateTime = _lastTimeRewardApplicable(rewardData[token].periodFinish).to40();
1707                 if (_account != address(0)) {
1708                     //check if reward is boostable or not. use boosted or locked balance accordingly
1709                     rewards[_account][token] = _earned(_account, token, rewardData[token].useBoost ? boostedBal : userBalance.locked );
1710                     userRewardPerTokenPaid[_account][token] = rewardData[token].rewardPerTokenStored;
1711                 }
1712             }
1713         }
1714         _;
1715     }
1716 
1717     /* ========== EVENTS ========== */
1718     event RewardAdded(address indexed _token, uint256 _reward);
1719     event Staked(address indexed _user, uint256 _paidAmount, uint256 _lockedAmount, uint256 _boostedAmount);
1720     event Withdrawn(address indexed _user, uint256 _amount, bool _relocked);
1721     event KickReward(address indexed _user, address indexed _kicked, uint256 _reward);
1722     event RewardPaid(address indexed _user, address indexed _rewardsToken, uint256 _reward);
1723     event Recovered(address _token, uint256 _amount);
1724 }