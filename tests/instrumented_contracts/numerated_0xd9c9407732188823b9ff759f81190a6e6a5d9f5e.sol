1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-03
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-12-25
7 */
8 
9 pragma solidity ^0.6.12;
10 
11 
12 abstract contract ReentrancyGuard {
13     // Booleans are more expensive than uint256 or any type that takes up a full
14     // word because each write operation emits an extra SLOAD to first read the
15     // slot's contents, replace the bits taken up by the boolean, and then write
16     // back. This is the compiler's defense against contract upgrades and
17     // pointer aliasing, and it cannot be disabled.
18 
19     // The values being non-zero value makes deployment a bit more expensive,
20     // but in exchange the refund on every call to nonReentrant will be lower in
21     // amount. Since refunds are capped to a percentage of the total
22     // transaction's gas, it is best to keep them low in cases like this one, to
23     // increase the likelihood of the full refund coming into effect.
24     uint256 private constant _NOT_ENTERED = 1;
25     uint256 private constant _ENTERED = 2;
26 
27     uint256 private _status;
28 
29     constructor () internal {
30         _status = _NOT_ENTERED;
31     }
32 
33     /**
34      * @dev Prevents a contract from calling itself, directly or indirectly.
35      * Calling a `nonReentrant` function from another `nonReentrant`
36      * function is not supported. It is possible to prevent this from happening
37      * by making the `nonReentrant` function external, and make it call a
38      * `private` function that does the actual work.
39      */
40     modifier nonReentrant() {
41         // On the first call to nonReentrant, _notEntered will be true
42         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
43 
44         // Any calls to nonReentrant after this point will fail
45         _status = _ENTERED;
46 
47         _;
48 
49         // By storing the original value once again, a refund is triggered (see
50         // https://eips.ethereum.org/EIPS/eip-2200)
51         _status = _NOT_ENTERED;
52     }
53 }
54 
55 library Math {
56     /**
57      * @dev Returns the largest of two numbers.
58      */
59     function max(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a >= b ? a : b;
61     }
62 
63     /**
64      * @dev Returns the smallest of two numbers.
65      */
66     function min(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a < b ? a : b;
68     }
69 
70     /**
71      * @dev Returns the average of two numbers. The result is rounded towards
72      * zero.
73      */
74     function average(uint256 a, uint256 b) internal pure returns (uint256) {
75         // (a + b) / 2 can overflow, so we distribute
76         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
77     }
78 }
79 
80 interface IOracle {
81     function update() external;
82 
83     function consult(address token, uint256 amountIn)
84         external
85         view
86         returns (uint256 amountOut);
87     // function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestamp);
88 }
89 
90 interface IUCashAsset {
91     function mint(address recipient, uint256 amount) external returns (bool);
92 
93     function burn(uint256 amount) external;
94 
95     function burnFrom(address from, uint256 amount) external;
96 
97     function isOperator() external returns (bool);
98 
99     function operator() external view returns (address);
100 }
101 
102 interface IUniswapV2Pair {
103     event Approval(
104         address indexed owner,
105         address indexed spender,
106         uint256 value
107     );
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     function name() external pure returns (string memory);
111 
112     function symbol() external pure returns (string memory);
113 
114     function decimals() external pure returns (uint8);
115 
116     function totalSupply() external view returns (uint256);
117 
118     function balanceOf(address owner) external view returns (uint256);
119 
120     function allowance(address owner, address spender)
121         external
122         view
123         returns (uint256);
124 
125     function approve(address spender, uint256 value) external returns (bool);
126 
127     function transfer(address to, uint256 value) external returns (bool);
128 
129     function transferFrom(
130         address from,
131         address to,
132         uint256 value
133     ) external returns (bool);
134 
135     function DOMAIN_SEPARATOR() external view returns (bytes32);
136 
137     function PERMIT_TYPEHASH() external pure returns (bytes32);
138 
139     function nonces(address owner) external view returns (uint256);
140 
141     function permit(
142         address owner,
143         address spender,
144         uint256 value,
145         uint256 deadline,
146         uint8 v,
147         bytes32 r,
148         bytes32 s
149     ) external;
150 
151     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
152     event Burn(
153         address indexed sender,
154         uint256 amount0,
155         uint256 amount1,
156         address indexed to
157     );
158     event Swap(
159         address indexed sender,
160         uint256 amount0In,
161         uint256 amount1In,
162         uint256 amount0Out,
163         uint256 amount1Out,
164         address indexed to
165     );
166     event Sync(uint112 reserve0, uint112 reserve1);
167 
168     function MINIMUM_LIQUIDITY() external pure returns (uint256);
169 
170     function factory() external view returns (address);
171 
172     function token0() external view returns (address);
173 
174     function token1() external view returns (address);
175 
176     function getReserves()
177         external
178         view
179         returns (
180             uint112 reserve0,
181             uint112 reserve1,
182             uint32 blockTimestampLast
183         );
184 
185     function price0CumulativeLast() external view returns (uint256);
186 
187     function price1CumulativeLast() external view returns (uint256);
188 
189     function kLast() external view returns (uint256);
190 
191     function mint(address to) external returns (uint256 liquidity);
192 
193     function burn(address to)
194         external
195         returns (uint256 amount0, uint256 amount1);
196 
197     function swap(
198         uint256 amount0Out,
199         uint256 amount1Out,
200         address to,
201         bytes calldata data
202     ) external;
203 
204     function skim(address to) external;
205 
206     function sync() external;
207 
208     function initialize(address, address) external;
209 }
210 
211 interface IBoardroom {
212     function allocateSeigniorage(uint256 amount) external;
213 }
214 
215 library Babylonian {
216     function sqrt(uint256 y) internal pure returns (uint256 z) {
217         if (y > 3) {
218             z = y;
219             uint256 x = y / 2 + 1;
220             while (x < z) {
221                 z = x;
222                 x = (y / x + x) / 2;
223             }
224         } else if (y != 0) {
225             z = 1;
226         }
227         // else z = 0
228     }
229 }
230 
231 library FixedPoint {
232     // range: [0, 2**112 - 1]
233     // resolution: 1 / 2**112
234     struct uq112x112 {
235         uint224 _x;
236     }
237 
238     // range: [0, 2**144 - 1]
239     // resolution: 1 / 2**112
240     struct uq144x112 {
241         uint256 _x;
242     }
243 
244     uint8 private constant RESOLUTION = 112;
245     uint256 private constant Q112 = uint256(1) << RESOLUTION;
246     uint256 private constant Q224 = Q112 << RESOLUTION;
247 
248     // encode a uint112 as a UQ112x112
249     function encode(uint112 x) internal pure returns (uq112x112 memory) {
250         return uq112x112(uint224(x) << RESOLUTION);
251     }
252 
253     // encodes a uint144 as a UQ144x112
254     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
255         return uq144x112(uint256(x) << RESOLUTION);
256     }
257 
258     // divide a UQ112x112 by a uint112, returning a UQ112x112
259     function div(uq112x112 memory self, uint112 x)
260         internal
261         pure
262         returns (uq112x112 memory)
263     {
264         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
265         return uq112x112(self._x / uint224(x));
266     }
267 
268     // multiply a UQ112x112 by a uint, returning a UQ144x112
269     // reverts on overflow
270     function mul(uq112x112 memory self, uint256 y)
271         internal
272         pure
273         returns (uq144x112 memory)
274     {
275         uint256 z;
276         require(
277             y == 0 || (z = uint256(self._x) * y) / y == uint256(self._x),
278             'FixedPoint: MULTIPLICATION_OVERFLOW'
279         );
280         return uq144x112(z);
281     }
282 
283     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
284     // equivalent to encode(numerator).div(denominator)
285     function fraction(uint112 numerator, uint112 denominator)
286         internal
287         pure
288         returns (uq112x112 memory)
289     {
290         require(denominator > 0, 'FixedPoint: DIV_BY_ZERO');
291         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
292     }
293 
294     // decode a UQ112x112 into a uint112 by truncating after the radix point
295     function decode(uq112x112 memory self) internal pure returns (uint112) {
296         return uint112(self._x >> RESOLUTION);
297     }
298 
299     // decode a UQ144x112 into a uint144 by truncating after the radix point
300     function decode144(uq144x112 memory self) internal pure returns (uint144) {
301         return uint144(self._x >> RESOLUTION);
302     }
303 
304     // take the reciprocal of a UQ112x112
305     function reciprocal(uq112x112 memory self)
306         internal
307         pure
308         returns (uq112x112 memory)
309     {
310         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
311         return uq112x112(uint224(Q224 / self._x));
312     }
313 
314     // square root of a UQ112x112
315     function sqrt(uq112x112 memory self)
316         internal
317         pure
318         returns (uq112x112 memory)
319     {
320         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
321     }
322 }
323 
324 library Address {
325     /**
326      * @dev Returns true if `account` is a contract.
327      *
328      * [IMPORTANT]
329      * ====
330      * It is unsafe to assume that an address for which this function returns
331      * false is an externally-owned account (EOA) and not a contract.
332      *
333      * Among others, `isContract` will return false for the following
334      * types of addresses:
335      *
336      *  - an externally-owned account
337      *  - a contract in construction
338      *  - an address where a contract will be created
339      *  - an address where a contract lived, but was destroyed
340      * ====
341      */
342     function isContract(address account) internal view returns (bool) {
343         // This method relies on extcodesize, which returns 0 for contracts in
344         // construction, since the code is only stored at the end of the
345         // constructor execution.
346 
347         uint256 size;
348         // solhint-disable-next-line no-inline-assembly
349         assembly { size := extcodesize(account) }
350         return size > 0;
351     }
352 
353     /**
354      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
355      * `recipient`, forwarding all available gas and reverting on errors.
356      *
357      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
358      * of certain opcodes, possibly making contracts go over the 2300 gas limit
359      * imposed by `transfer`, making them unable to receive funds via
360      * `transfer`. {sendValue} removes this limitation.
361      *
362      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
363      *
364      * IMPORTANT: because control is transferred to `recipient`, care must be
365      * taken to not create reentrancy vulnerabilities. Consider using
366      * {ReentrancyGuard} or the
367      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
368      */
369     function sendValue(address payable recipient, uint256 amount) internal {
370         require(address(this).balance >= amount, "Address: insufficient balance");
371 
372         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
373         (bool success, ) = recipient.call{ value: amount }("");
374         require(success, "Address: unable to send value, recipient may have reverted");
375     }
376 
377     /**
378      * @dev Performs a Solidity function call using a low level `call`. A
379      * plain`call` is an unsafe replacement for a function call: use this
380      * function instead.
381      *
382      * If `target` reverts with a revert reason, it is bubbled up by this
383      * function (like regular Solidity function calls).
384      *
385      * Returns the raw returned data. To convert to the expected return value,
386      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
387      *
388      * Requirements:
389      *
390      * - `target` must be a contract.
391      * - calling `target` with `data` must not revert.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
396       return functionCall(target, data, "Address: low-level call failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
401      * `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, 0, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but also transferring `value` wei to `target`.
412      *
413      * Requirements:
414      *
415      * - the calling contract must have an ETH balance of at least `value`.
416      * - the called Solidity function must be `payable`.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
431         require(address(this).balance >= value, "Address: insufficient balance for call");
432         require(isContract(target), "Address: call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.call{ value: value }(data);
436         return _verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
446         return functionStaticCall(target, data, "Address: low-level static call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
456         require(isContract(target), "Address: static call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.staticcall(data);
460         return _verifyCallResult(success, returndata, errorMessage);
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.3._
468      */
469     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.3._
478      */
479     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
480         require(isContract(target), "Address: delegate call to non-contract");
481 
482         // solhint-disable-next-line avoid-low-level-calls
483         (bool success, bytes memory returndata) = target.delegatecall(data);
484         return _verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             // Look for revert reason and bubble it up if present
492             if (returndata.length > 0) {
493                 // The easiest way to bubble the revert reason is using memory via assembly
494 
495                 // solhint-disable-next-line no-inline-assembly
496                 assembly {
497                     let returndata_size := mload(returndata)
498                     revert(add(32, returndata), returndata_size)
499                 }
500             } else {
501                 revert(errorMessage);
502             }
503         }
504     }
505 }
506 
507 library SafeMath {
508     /**
509      * @dev Returns the addition of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `+` operator.
513      *
514      * Requirements:
515      *
516      * - Addition cannot overflow.
517      */
518     function add(uint256 a, uint256 b) internal pure returns (uint256) {
519         uint256 c = a + b;
520         require(c >= a, "SafeMath: addition overflow");
521 
522         return c;
523     }
524 
525     /**
526      * @dev Returns the subtraction of two unsigned integers, reverting on
527      * overflow (when the result is negative).
528      *
529      * Counterpart to Solidity's `-` operator.
530      *
531      * Requirements:
532      *
533      * - Subtraction cannot overflow.
534      */
535     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
536         return sub(a, b, "SafeMath: subtraction overflow");
537     }
538 
539     /**
540      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
541      * overflow (when the result is negative).
542      *
543      * Counterpart to Solidity's `-` operator.
544      *
545      * Requirements:
546      *
547      * - Subtraction cannot overflow.
548      */
549     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
550         require(b <= a, errorMessage);
551         uint256 c = a - b;
552 
553         return c;
554     }
555 
556     /**
557      * @dev Returns the multiplication of two unsigned integers, reverting on
558      * overflow.
559      *
560      * Counterpart to Solidity's `*` operator.
561      *
562      * Requirements:
563      *
564      * - Multiplication cannot overflow.
565      */
566     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
567         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
568         // benefit is lost if 'b' is also tested.
569         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
570         if (a == 0) {
571             return 0;
572         }
573 
574         uint256 c = a * b;
575         require(c / a == b, "SafeMath: multiplication overflow");
576 
577         return c;
578     }
579 
580     /**
581      * @dev Returns the integer division of two unsigned integers. Reverts on
582      * division by zero. The result is rounded towards zero.
583      *
584      * Counterpart to Solidity's `/` operator. Note: this function uses a
585      * `revert` opcode (which leaves remaining gas untouched) while Solidity
586      * uses an invalid opcode to revert (consuming all remaining gas).
587      *
588      * Requirements:
589      *
590      * - The divisor cannot be zero.
591      */
592     function div(uint256 a, uint256 b) internal pure returns (uint256) {
593         return div(a, b, "SafeMath: division by zero");
594     }
595 
596     /**
597      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
598      * division by zero. The result is rounded towards zero.
599      *
600      * Counterpart to Solidity's `/` operator. Note: this function uses a
601      * `revert` opcode (which leaves remaining gas untouched) while Solidity
602      * uses an invalid opcode to revert (consuming all remaining gas).
603      *
604      * Requirements:
605      *
606      * - The divisor cannot be zero.
607      */
608     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
609         require(b > 0, errorMessage);
610         uint256 c = a / b;
611         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
612 
613         return c;
614     }
615 
616     /**
617      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
618      * Reverts when dividing by zero.
619      *
620      * Counterpart to Solidity's `%` operator. This function uses a `revert`
621      * opcode (which leaves remaining gas untouched) while Solidity uses an
622      * invalid opcode to revert (consuming all remaining gas).
623      *
624      * Requirements:
625      *
626      * - The divisor cannot be zero.
627      */
628     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
629         return mod(a, b, "SafeMath: modulo by zero");
630     }
631 
632     /**
633      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
634      * Reverts with custom message when dividing by zero.
635      *
636      * Counterpart to Solidity's `%` operator. This function uses a `revert`
637      * opcode (which leaves remaining gas untouched) while Solidity uses an
638      * invalid opcode to revert (consuming all remaining gas).
639      *
640      * Requirements:
641      *
642      * - The divisor cannot be zero.
643      */
644     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
645         require(b != 0, errorMessage);
646         return a % b;
647     }
648 }
649 library EnumerableSet {
650     // To implement this library for multiple types with as little code
651     // repetition as possible, we write it in terms of a generic Set type with
652     // bytes32 values.
653     // The Set implementation uses private functions, and user-facing
654     // implementations (such as AddressSet) are just wrappers around the
655     // underlying Set.
656     // This means that we can only create new EnumerableSets for types that fit
657     // in bytes32.
658 
659     struct Set {
660         // Storage of set values
661         bytes32[] _values;
662 
663         // Position of the value in the `values` array, plus 1 because index 0
664         // means a value is not in the set.
665         mapping (bytes32 => uint256) _indexes;
666     }
667 
668     /**
669      * @dev Add a value to a set. O(1).
670      *
671      * Returns true if the value was added to the set, that is if it was not
672      * already present.
673      */
674     function _add(Set storage set, bytes32 value) private returns (bool) {
675         if (!_contains(set, value)) {
676             set._values.push(value);
677             // The value is stored at length-1, but we add 1 to all indexes
678             // and use 0 as a sentinel value
679             set._indexes[value] = set._values.length;
680             return true;
681         } else {
682             return false;
683         }
684     }
685 
686     /**
687      * @dev Removes a value from a set. O(1).
688      *
689      * Returns true if the value was removed from the set, that is if it was
690      * present.
691      */
692     function _remove(Set storage set, bytes32 value) private returns (bool) {
693         // We read and store the value's index to prevent multiple reads from the same storage slot
694         uint256 valueIndex = set._indexes[value];
695 
696         if (valueIndex != 0) { // Equivalent to contains(set, value)
697             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
698             // the array, and then remove the last element (sometimes called as 'swap and pop').
699             // This modifies the order of the array, as noted in {at}.
700 
701             uint256 toDeleteIndex = valueIndex - 1;
702             uint256 lastIndex = set._values.length - 1;
703 
704             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
705             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
706 
707             bytes32 lastvalue = set._values[lastIndex];
708 
709             // Move the last value to the index where the value to delete is
710             set._values[toDeleteIndex] = lastvalue;
711             // Update the index for the moved value
712             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
713 
714             // Delete the slot where the moved value was stored
715             set._values.pop();
716 
717             // Delete the index for the deleted slot
718             delete set._indexes[value];
719 
720             return true;
721         } else {
722             return false;
723         }
724     }
725 
726     /**
727      * @dev Returns true if the value is in the set. O(1).
728      */
729     function _contains(Set storage set, bytes32 value) private view returns (bool) {
730         return set._indexes[value] != 0;
731     }
732 
733     /**
734      * @dev Returns the number of values on the set. O(1).
735      */
736     function _length(Set storage set) private view returns (uint256) {
737         return set._values.length;
738     }
739 
740    /**
741     * @dev Returns the value stored at position `index` in the set. O(1).
742     *
743     * Note that there are no guarantees on the ordering of values inside the
744     * array, and it may change when more values are added or removed.
745     *
746     * Requirements:
747     *
748     * - `index` must be strictly less than {length}.
749     */
750     function _at(Set storage set, uint256 index) private view returns (bytes32) {
751         require(set._values.length > index, "EnumerableSet: index out of bounds");
752         return set._values[index];
753     }
754 
755     // Bytes32Set
756 
757     struct Bytes32Set {
758         Set _inner;
759     }
760 
761     /**
762      * @dev Add a value to a set. O(1).
763      *
764      * Returns true if the value was added to the set, that is if it was not
765      * already present.
766      */
767     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
768         return _add(set._inner, value);
769     }
770 
771     /**
772      * @dev Removes a value from a set. O(1).
773      *
774      * Returns true if the value was removed from the set, that is if it was
775      * present.
776      */
777     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
778         return _remove(set._inner, value);
779     }
780 
781     /**
782      * @dev Returns true if the value is in the set. O(1).
783      */
784     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
785         return _contains(set._inner, value);
786     }
787 
788     /**
789      * @dev Returns the number of values in the set. O(1).
790      */
791     function length(Bytes32Set storage set) internal view returns (uint256) {
792         return _length(set._inner);
793     }
794 
795    /**
796     * @dev Returns the value stored at position `index` in the set. O(1).
797     *
798     * Note that there are no guarantees on the ordering of values inside the
799     * array, and it may change when more values are added or removed.
800     *
801     * Requirements:
802     *
803     * - `index` must be strictly less than {length}.
804     */
805     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
806         return _at(set._inner, index);
807     }
808 
809     // AddressSet
810 
811     struct AddressSet {
812         Set _inner;
813     }
814 
815     /**
816      * @dev Add a value to a set. O(1).
817      *
818      * Returns true if the value was added to the set, that is if it was not
819      * already present.
820      */
821     function add(AddressSet storage set, address value) internal returns (bool) {
822         return _add(set._inner, bytes32(uint256(value)));
823     }
824 
825     /**
826      * @dev Removes a value from a set. O(1).
827      *
828      * Returns true if the value was removed from the set, that is if it was
829      * present.
830      */
831     function remove(AddressSet storage set, address value) internal returns (bool) {
832         return _remove(set._inner, bytes32(uint256(value)));
833     }
834 
835     /**
836      * @dev Returns true if the value is in the set. O(1).
837      */
838     function contains(AddressSet storage set, address value) internal view returns (bool) {
839         return _contains(set._inner, bytes32(uint256(value)));
840     }
841 
842     /**
843      * @dev Returns the number of values in the set. O(1).
844      */
845     function length(AddressSet storage set) internal view returns (uint256) {
846         return _length(set._inner);
847     }
848 
849    /**
850     * @dev Returns the value stored at position `index` in the set. O(1).
851     *
852     * Note that there are no guarantees on the ordering of values inside the
853     * array, and it may change when more values are added or removed.
854     *
855     * Requirements:
856     *
857     * - `index` must be strictly less than {length}.
858     */
859     function at(AddressSet storage set, uint256 index) internal view returns (address) {
860         return address(uint256(_at(set._inner, index)));
861     }
862 
863 
864     // UintSet
865 
866     struct UintSet {
867         Set _inner;
868     }
869 
870     /**
871      * @dev Add a value to a set. O(1).
872      *
873      * Returns true if the value was added to the set, that is if it was not
874      * already present.
875      */
876     function add(UintSet storage set, uint256 value) internal returns (bool) {
877         return _add(set._inner, bytes32(value));
878     }
879 
880     /**
881      * @dev Removes a value from a set. O(1).
882      *
883      * Returns true if the value was removed from the set, that is if it was
884      * present.
885      */
886     function remove(UintSet storage set, uint256 value) internal returns (bool) {
887         return _remove(set._inner, bytes32(value));
888     }
889 
890     /**
891      * @dev Returns true if the value is in the set. O(1).
892      */
893     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
894         return _contains(set._inner, bytes32(value));
895     }
896 
897     /**
898      * @dev Returns the number of values on the set. O(1).
899      */
900     function length(UintSet storage set) internal view returns (uint256) {
901         return _length(set._inner);
902     }
903 
904    /**
905     * @dev Returns the value stored at position `index` in the set. O(1).
906     *
907     * Note that there are no guarantees on the ordering of values inside the
908     * array, and it may change when more values are added or removed.
909     *
910     * Requirements:
911     *
912     * - `index` must be strictly less than {length}.
913     */
914     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
915         return uint256(_at(set._inner, index));
916     }
917 }
918 
919 
920 abstract contract Context {
921     function _msgSender() internal view virtual returns (address payable) {
922         return msg.sender;
923     }
924 
925     function _msgData() internal view virtual returns (bytes memory) {
926         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
927         return msg.data;
928     }
929 }
930 
931 abstract contract Ownable is Context {
932     address private _owner;
933 
934     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
935 
936     /**
937      * @dev Initializes the contract setting the deployer as the initial owner.
938      */
939     constructor () internal {
940         address msgSender = _msgSender();
941         _owner = msgSender;
942         emit OwnershipTransferred(address(0), msgSender);
943     }
944 
945     /**
946      * @dev Returns the address of the current owner.
947      */
948     function owner() public view returns (address) {
949         return _owner;
950     }
951 
952     /**
953      * @dev Throws if called by any account other than the owner.
954      */
955     modifier onlyOwner() {
956         require(_owner == _msgSender(), "Ownable: caller is not the owner");
957         _;
958     }
959 
960     /**
961      * @dev Leaves the contract without owner. It will not be possible to call
962      * `onlyOwner` functions anymore. Can only be called by the current owner.
963      *
964      * NOTE: Renouncing ownership will leave the contract without an owner,
965      * thereby removing any functionality that is only available to the owner.
966      */
967     function renounceOwnership() public virtual onlyOwner {
968         emit OwnershipTransferred(_owner, address(0));
969         _owner = address(0);
970     }
971 
972     /**
973      * @dev Transfers ownership of the contract to a new account (`newOwner`).
974      * Can only be called by the current owner.
975      */
976     function transferOwnership(address newOwner) public virtual onlyOwner {
977         require(newOwner != address(0), "Ownable: new owner is the zero address");
978         emit OwnershipTransferred(_owner, newOwner);
979         _owner = newOwner;
980     }
981 }
982 
983 contract Operator is Context, Ownable {
984     address private _operator;
985 
986     event OperatorTransferred(
987         address indexed previousOperator,
988         address indexed newOperator
989     );
990 
991     constructor() internal {
992         _operator = _msgSender();
993         emit OperatorTransferred(address(0), _operator);
994     }
995 
996     function operator() public view returns (address) {
997         return _operator;
998     }
999 
1000     modifier onlyOperator() {
1001         require(
1002             _operator == msg.sender,
1003             'operator: caller is not the operator'
1004         );
1005         _;
1006     }
1007 
1008     function isOperator() public view returns (bool) {
1009         return _msgSender() == _operator;
1010     }
1011 
1012     function transferOperator(address newOperator_) public onlyOwner {
1013         _transferOperator(newOperator_);
1014     }
1015 
1016     function _transferOperator(address newOperator_) internal {
1017         require(
1018             newOperator_ != address(0),
1019             'operator: zero address given for new operator'
1020         );
1021         emit OperatorTransferred(address(0), newOperator_);
1022         _operator = newOperator_;
1023     }
1024 }
1025 
1026 interface IERC20 {
1027     /**
1028      * @dev Returns the amount of tokens in existence.
1029      */
1030     function totalSupply() external view returns (uint256);
1031 
1032     /**
1033      * @dev Returns the amount of tokens owned by `account`.
1034      */
1035     function balanceOf(address account) external view returns (uint256);
1036 
1037     /**
1038      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1039      *
1040      * Returns a boolean value indicating whether the operation succeeded.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function transfer(address recipient, uint256 amount) external returns (bool);
1045 
1046     /**
1047      * @dev Returns the remaining number of tokens that `spender` will be
1048      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1049      * zero by default.
1050      *
1051      * This value changes when {approve} or {transferFrom} are called.
1052      */
1053     function allowance(address owner, address spender) external view returns (uint256);
1054 
1055     /**
1056      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1057      *
1058      * Returns a boolean value indicating whether the operation succeeded.
1059      *
1060      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1061      * that someone may use both the old and the new allowance by unfortunate
1062      * transaction ordering. One possible solution to mitigate this race
1063      * condition is to first reduce the spender's allowance to 0 and set the
1064      * desired value afterwards:
1065      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1066      *
1067      * Emits an {Approval} event.
1068      */
1069     function approve(address spender, uint256 amount) external returns (bool);
1070 
1071     /**
1072      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1073      * allowance mechanism. `amount` is then deducted from the caller's
1074      * allowance.
1075      *
1076      * Returns a boolean value indicating whether the operation succeeded.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1081 
1082     /**
1083      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1084      * another (`to`).
1085      *
1086      * Note that `value` may be zero.
1087      */
1088     event Transfer(address indexed from, address indexed to, uint256 value);
1089 
1090     /**
1091      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1092      * a call to {approve}. `value` is the new allowance.
1093      */
1094     event Approval(address indexed owner, address indexed spender, uint256 value);
1095 }
1096 
1097 library Safe112 {
1098     function add(uint112 a, uint112 b) internal pure returns (uint256) {
1099         uint256 c = a + b;
1100         require(c >= a, 'Safe112: addition overflow');
1101 
1102         return c;
1103     }
1104 
1105     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
1106         return sub(a, b, 'Safe112: subtraction overflow');
1107     }
1108 
1109     function sub(
1110         uint112 a,
1111         uint112 b,
1112         string memory errorMessage
1113     ) internal pure returns (uint112) {
1114         require(b <= a, errorMessage);
1115         uint112 c = a - b;
1116 
1117         return c;
1118     }
1119 
1120     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
1121         if (a == 0) {
1122             return 0;
1123         }
1124 
1125         uint256 c = a * b;
1126         require(c / a == b, 'Safe112: multiplication overflow');
1127 
1128         return c;
1129     }
1130 
1131     function div(uint112 a, uint112 b) internal pure returns (uint256) {
1132         return div(a, b, 'Safe112: division by zero');
1133     }
1134 
1135     function div(
1136         uint112 a,
1137         uint112 b,
1138         string memory errorMessage
1139     ) internal pure returns (uint112) {
1140         // Solidity only automatically asserts when dividing by 0
1141         require(b > 0, errorMessage);
1142         uint112 c = a / b;
1143 
1144         return c;
1145     }
1146 
1147     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
1148         return mod(a, b, 'Safe112: modulo by zero');
1149     }
1150 
1151     function mod(
1152         uint112 a,
1153         uint112 b,
1154         string memory errorMessage
1155     ) internal pure returns (uint112) {
1156         require(b != 0, errorMessage);
1157         return a % b;
1158     }
1159 }
1160 
1161 library SafeERC20 {
1162     using SafeMath for uint256;
1163     using Address for address;
1164 
1165     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1166         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1167     }
1168 
1169     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1170         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1171     }
1172 
1173     /**
1174      * @dev Deprecated. This function has issues similar to the ones found in
1175      * {IERC20-approve}, and its usage is discouraged.
1176      *
1177      * Whenever possible, use {safeIncreaseAllowance} and
1178      * {safeDecreaseAllowance} instead.
1179      */
1180     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1181         // safeApprove should only be called when setting an initial allowance,
1182         // or when resetting it to zero. To increase and decrease it, use
1183         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1184         // solhint-disable-next-line max-line-length
1185         require((value == 0) || (token.allowance(address(this), spender) == 0),
1186             "SafeERC20: approve from non-zero to non-zero allowance"
1187         );
1188         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1189     }
1190 
1191     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1192         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1193         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1194     }
1195 
1196     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1197         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1198         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1199     }
1200 
1201     /**
1202      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1203      * on the return value: the return value is optional (but if data is returned, it must not be false).
1204      * @param token The token targeted by the call.
1205      * @param data The call data (encoded using abi.encode or one of its variants).
1206      */
1207     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1208         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1209         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1210         // the target address contains contract code and also asserts for success in the low-level call.
1211 
1212         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1213         if (returndata.length > 0) { // Return data is optional
1214             // solhint-disable-next-line max-line-length
1215             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1216         }
1217     }
1218 }
1219 
1220 contract ContractGuard {
1221     mapping(uint256 => mapping(address => bool)) private _status;
1222 
1223     function checkSameOriginReentranted() internal view returns (bool) {
1224         return _status[block.number][tx.origin];
1225     }
1226 
1227     function checkSameSenderReentranted() internal view returns (bool) {
1228         return _status[block.number][msg.sender];
1229     }
1230 
1231     modifier onlyOneBlock() {
1232         require(
1233             !checkSameOriginReentranted(),
1234             'ContractGuard: one block, one function'
1235         );
1236         require(
1237             !checkSameSenderReentranted(),
1238             'ContractGuard: one block, one function'
1239         );
1240 
1241         _;
1242 
1243         _status[block.number][tx.origin] = true;
1244         _status[block.number][msg.sender] = true;
1245     }
1246 }
1247 
1248 contract Epoch is Operator {
1249     using SafeMath for uint256;
1250 
1251     uint256 private period;
1252     uint256 private startTime;
1253     uint256 private epoch;
1254 
1255     /* ========== CONSTRUCTOR ========== */
1256 
1257     constructor(
1258         uint256 _period,
1259         uint256 _startTime,
1260         uint256 _startEpoch
1261     ) public {
1262         period = _period;
1263         startTime = _startTime;
1264         epoch = _startEpoch;
1265     }
1266 
1267     /* ========== Modifier ========== */
1268 
1269     modifier checkStartTime {
1270         require(now >= startTime, 'Epoch: not started yet');
1271 
1272         _;
1273     }
1274 
1275     modifier checkEpoch {
1276         require(now >= nextEpochPoint(), 'Epoch: not allowed');
1277 
1278         _;
1279 
1280         epoch = epoch.add(1);
1281     }
1282 
1283     /* ========== VIEW FUNCTIONS ========== */
1284 
1285     function getCurrentEpoch() public view returns (uint256) {
1286         return epoch;
1287     }
1288 
1289     function getPeriod() public view returns (uint256) {
1290         return period;
1291     }
1292 
1293     function getStartTime() public view returns (uint256) {
1294         return startTime;
1295     }
1296 
1297     function nextEpochPoint() public view returns (uint256) {
1298         return startTime.add(epoch.mul(period));
1299     }
1300 
1301     /* ========== GOVERNANCE ========== */
1302 
1303     function setPeriod(uint256 _period) external onlyOperator {
1304         period = _period;
1305     }
1306 }
1307 
1308 abstract contract AccessControl is Context {
1309     using EnumerableSet for EnumerableSet.AddressSet;
1310     using Address for address;
1311 
1312     struct RoleData {
1313         EnumerableSet.AddressSet members;
1314         bytes32 adminRole;
1315     }
1316 
1317     mapping (bytes32 => RoleData) private _roles;
1318 
1319     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1320 
1321     /**
1322      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1323      *
1324      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1325      * {RoleAdminChanged} not being emitted signaling this.
1326      *
1327      * _Available since v3.1._
1328      */
1329     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1330 
1331     /**
1332      * @dev Emitted when `account` is granted `role`.
1333      *
1334      * `sender` is the account that originated the contract call, an admin role
1335      * bearer except when using {_setupRole}.
1336      */
1337     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1338 
1339     /**
1340      * @dev Emitted when `account` is revoked `role`.
1341      *
1342      * `sender` is the account that originated the contract call:
1343      *   - if using `revokeRole`, it is the admin role bearer
1344      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1345      */
1346     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1347 
1348     /**
1349      * @dev Returns `true` if `account` has been granted `role`.
1350      */
1351     function hasRole(bytes32 role, address account) public view returns (bool) {
1352         return _roles[role].members.contains(account);
1353     }
1354 
1355     /**
1356      * @dev Returns the number of accounts that have `role`. Can be used
1357      * together with {getRoleMember} to enumerate all bearers of a role.
1358      */
1359     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1360         return _roles[role].members.length();
1361     }
1362 
1363     /**
1364      * @dev Returns one of the accounts that have `role`. `index` must be a
1365      * value between 0 and {getRoleMemberCount}, non-inclusive.
1366      *
1367      * Role bearers are not sorted in any particular way, and their ordering may
1368      * change at any point.
1369      *
1370      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1371      * you perform all queries on the same block. See the following
1372      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1373      * for more information.
1374      */
1375     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1376         return _roles[role].members.at(index);
1377     }
1378 
1379     /**
1380      * @dev Returns the admin role that controls `role`. See {grantRole} and
1381      * {revokeRole}.
1382      *
1383      * To change a role's admin, use {_setRoleAdmin}.
1384      */
1385     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1386         return _roles[role].adminRole;
1387     }
1388 
1389     /**
1390      * @dev Grants `role` to `account`.
1391      *
1392      * If `account` had not been already granted `role`, emits a {RoleGranted}
1393      * event.
1394      *
1395      * Requirements:
1396      *
1397      * - the caller must have ``role``'s admin role.
1398      */
1399     function grantRole(bytes32 role, address account) public virtual {
1400         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1401 
1402         _grantRole(role, account);
1403     }
1404 
1405     /**
1406      * @dev Revokes `role` from `account`.
1407      *
1408      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1409      *
1410      * Requirements:
1411      *
1412      * - the caller must have ``role``'s admin role.
1413      */
1414     function revokeRole(bytes32 role, address account) public virtual {
1415         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1416 
1417         _revokeRole(role, account);
1418     }
1419 
1420     /**
1421      * @dev Revokes `role` from the calling account.
1422      *
1423      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1424      * purpose is to provide a mechanism for accounts to lose their privileges
1425      * if they are compromised (such as when a trusted device is misplaced).
1426      *
1427      * If the calling account had been granted `role`, emits a {RoleRevoked}
1428      * event.
1429      *
1430      * Requirements:
1431      *
1432      * - the caller must be `account`.
1433      */
1434     function renounceRole(bytes32 role, address account) public virtual {
1435         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1436 
1437         _revokeRole(role, account);
1438     }
1439 
1440     /**
1441      * @dev Grants `role` to `account`.
1442      *
1443      * If `account` had not been already granted `role`, emits a {RoleGranted}
1444      * event. Note that unlike {grantRole}, this function doesn't perform any
1445      * checks on the calling account.
1446      *
1447      * [WARNING]
1448      * ====
1449      * This function should only be called from the constructor when setting
1450      * up the initial roles for the system.
1451      *
1452      * Using this function in any other way is effectively circumventing the admin
1453      * system imposed by {AccessControl}.
1454      * ====
1455      */
1456     function _setupRole(bytes32 role, address account) internal virtual {
1457         _grantRole(role, account);
1458     }
1459 
1460     /**
1461      * @dev Sets `adminRole` as ``role``'s admin role.
1462      *
1463      * Emits a {RoleAdminChanged} event.
1464      */
1465     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1466         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1467         _roles[role].adminRole = adminRole;
1468     }
1469 
1470     function _grantRole(bytes32 role, address account) private {
1471         if (_roles[role].members.add(account)) {
1472             emit RoleGranted(role, account, _msgSender());
1473         }
1474     }
1475 
1476     function _revokeRole(bytes32 role, address account) private {
1477         if (_roles[role].members.remove(account)) {
1478             emit RoleRevoked(role, account, _msgSender());
1479         }
1480     }
1481 }
1482 
1483 contract ShareWrapper {
1484     using SafeMath for uint256;
1485     using SafeERC20 for IERC20;
1486 
1487     IERC20 public share;
1488 
1489     uint256 private _totalSupply;
1490     mapping(address => uint256) private _balances;
1491 
1492     function totalSupply() public view returns (uint256) {
1493         return _totalSupply;
1494     }
1495 
1496     function balanceOf(address account) public view returns (uint256) {
1497         return _balances[account];
1498     }
1499 
1500     function stake(uint256 amount) public virtual {
1501         _totalSupply = _totalSupply.add(amount);
1502         _balances[msg.sender] = _balances[msg.sender].add(amount);
1503         share.safeTransferFrom(msg.sender, address(this), amount);
1504     }
1505 
1506     function withdraw(uint256 amount) public virtual {
1507         uint256 directorShare = _balances[msg.sender];
1508         require(
1509             directorShare >= amount,
1510             'Boardroom: withdraw request greater than staked amount'
1511         );
1512         _totalSupply = _totalSupply.sub(amount);
1513         _balances[msg.sender] = directorShare.sub(amount);
1514         share.safeTransfer(msg.sender, amount);
1515     }
1516 }
1517 
1518 
1519 contract Boardroom is ShareWrapper, ContractGuard, Operator {
1520     using SafeERC20 for IERC20;
1521     using Address for address;
1522     using SafeMath for uint256;
1523     using Safe112 for uint112;
1524 
1525     /* ========== DATA STRUCTURES ========== */
1526 
1527     struct Boardseat {
1528         uint256 lastSnapshotIndex;
1529         uint256 rewardEarned;
1530     }
1531 
1532     struct BoardSnapshot {
1533         uint256 time;
1534         uint256 rewardReceived;
1535         uint256 rewardPerShare;
1536     }
1537 
1538     /* ========== STATE VARIABLES ========== */
1539 
1540     IERC20 private cash;
1541 
1542     mapping(address => Boardseat) private directors;
1543     BoardSnapshot[] private boardHistory;
1544 
1545     /* ========== CONSTRUCTOR ========== */
1546 
1547     constructor(IERC20 _cash, IERC20 _share) public {
1548         cash = _cash;
1549         share = _share;
1550 
1551         BoardSnapshot memory genesisSnapshot = BoardSnapshot({
1552             time: block.number,
1553             rewardReceived: 0,
1554             rewardPerShare: 0
1555         });
1556         boardHistory.push(genesisSnapshot);
1557     }
1558 
1559     /* ========== Modifiers =============== */
1560     modifier directorExists {
1561         require(
1562             balanceOf(msg.sender) > 0,
1563             'Boardroom: The director does not exist'
1564         );
1565         _;
1566     }
1567 
1568     modifier updateReward(address director) {
1569         if (director != address(0)) {
1570             Boardseat memory seat = directors[director];
1571             seat.rewardEarned = earned(director);
1572             seat.lastSnapshotIndex = latestSnapshotIndex();
1573             directors[director] = seat;
1574         }
1575         _;
1576     }
1577 
1578     /* ========== VIEW FUNCTIONS ========== */
1579 
1580     // =========== Snapshot getters
1581 
1582     function latestSnapshotIndex() public view returns (uint256) {
1583         return boardHistory.length.sub(1);
1584     }
1585 
1586     function getLatestSnapshot() internal view returns (BoardSnapshot memory) {
1587         return boardHistory[latestSnapshotIndex()];
1588     }
1589 
1590     function getLastSnapshotIndexOf(address director)
1591         public
1592         view
1593         returns (uint256)
1594     {
1595         return directors[director].lastSnapshotIndex;
1596     }
1597 
1598     function getLastSnapshotOf(address director)
1599         internal
1600         view
1601         returns (BoardSnapshot memory)
1602     {
1603         return boardHistory[getLastSnapshotIndexOf(director)];
1604     }
1605 
1606     // =========== Director getters
1607 
1608     function rewardPerShare() public view returns (uint256) {
1609         return getLatestSnapshot().rewardPerShare;
1610     }
1611 
1612     function earned(address director) public view returns (uint256) {
1613         uint256 latestRPS = getLatestSnapshot().rewardPerShare;
1614         uint256 storedRPS = getLastSnapshotOf(director).rewardPerShare;
1615 
1616         return
1617             balanceOf(director).mul(latestRPS.sub(storedRPS)).div(1e18).add(
1618                 directors[director].rewardEarned
1619             );
1620     }
1621 
1622     /* ========== MUTATIVE FUNCTIONS ========== */
1623 
1624     function stake(uint256 amount)
1625         public
1626         override
1627         onlyOneBlock
1628         updateReward(msg.sender)
1629     {
1630         require(amount > 0, 'Boardroom: Cannot stake 0');
1631         super.stake(amount);
1632         emit Staked(msg.sender, amount);
1633     }
1634 
1635     function withdraw(uint256 amount)
1636         public
1637         override
1638         onlyOneBlock
1639         directorExists
1640         updateReward(msg.sender)
1641     {
1642         require(amount > 0, 'Boardroom: Cannot withdraw 0');
1643         super.withdraw(amount);
1644         emit Withdrawn(msg.sender, amount);
1645     }
1646 
1647     function exit() external {
1648         withdraw(balanceOf(msg.sender));
1649         claimReward();
1650     }
1651 
1652     function claimReward() public updateReward(msg.sender) {
1653         uint256 reward = directors[msg.sender].rewardEarned;
1654         if (reward > 0) {
1655             directors[msg.sender].rewardEarned = 0;
1656             cash.safeTransfer(msg.sender, reward);
1657             emit RewardPaid(msg.sender, reward);
1658         }
1659     }
1660 
1661     function allocateSeigniorage(uint256 amount)
1662         external
1663         onlyOneBlock
1664         onlyOperator
1665     {
1666         require(amount > 0, 'Boardroom: Cannot allocate 0');
1667         require(
1668             totalSupply() > 0,
1669             'Boardroom: Cannot allocate when totalSupply is 0'
1670         );
1671 
1672         // Create & add new snapshot
1673         uint256 prevRPS = getLatestSnapshot().rewardPerShare;
1674         uint256 nextRPS = prevRPS.add(amount.mul(1e18).div(totalSupply()));
1675 
1676         BoardSnapshot memory newSnapshot = BoardSnapshot({
1677             time: block.number,
1678             rewardReceived: amount,
1679             rewardPerShare: nextRPS
1680         });
1681         boardHistory.push(newSnapshot);
1682 
1683         cash.safeTransferFrom(msg.sender, address(this), amount);
1684         emit RewardAdded(msg.sender, amount);
1685     }
1686 
1687     /* ========== EVENTS ========== */
1688 
1689     event Staked(address indexed user, uint256 amount);
1690     event Withdrawn(address indexed user, uint256 amount);
1691     event RewardPaid(address indexed user, uint256 reward);
1692     event RewardAdded(address indexed user, uint256 reward);
1693 }
1694 
1695 library UniswapV2OracleLibrary {
1696     using FixedPoint for *;
1697 
1698     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
1699     function currentBlockTimestamp() internal view returns (uint32) {
1700         return uint32(block.timestamp % 2**32);
1701     }
1702 
1703     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
1704     function currentCumulativePrices(address pair)
1705         internal
1706         view
1707         returns (
1708             uint256 price0Cumulative,
1709             uint256 price1Cumulative,
1710             uint32 blockTimestamp
1711         )
1712     {
1713         blockTimestamp = currentBlockTimestamp();
1714         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
1715         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
1716 
1717         // if time has elapsed since the last update on the pair, mock the accumulated price values
1718         (
1719             uint112 reserve0,
1720             uint112 reserve1,
1721             uint32 blockTimestampLast
1722         ) = IUniswapV2Pair(pair).getReserves();
1723         if (blockTimestampLast != blockTimestamp) {
1724             // subtraction overflow is desired
1725             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
1726             // addition overflow is desired
1727             // counterfactual
1728             price0Cumulative +=
1729                 uint256(FixedPoint.fraction(reserve1, reserve0)._x) *
1730                 timeElapsed;
1731             // counterfactual
1732             price1Cumulative +=
1733                 uint256(FixedPoint.fraction(reserve0, reserve1)._x) *
1734                 timeElapsed;
1735         }
1736     }
1737 }
1738 
1739 library UniswapV2Library {
1740     using SafeMath for uint256;
1741 
1742     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1743     function sortTokens(address tokenA, address tokenB)
1744         internal
1745         pure
1746         returns (address token0, address token1)
1747     {
1748         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1749         (token0, token1) = tokenA < tokenB
1750             ? (tokenA, tokenB)
1751             : (tokenB, tokenA);
1752         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1753     }
1754 
1755     // calculates the CREATE2 address for a pair without making any external calls
1756     function pairFor(
1757         address factory,
1758         address tokenA,
1759         address tokenB
1760     ) internal pure returns (address pair) {
1761         (address token0, address token1) = sortTokens(tokenA, tokenB);
1762         pair = address(
1763             uint256(
1764                 keccak256(
1765                     abi.encodePacked(
1766                         hex'ff',
1767                         factory,
1768                         keccak256(abi.encodePacked(token0, token1)),
1769                         hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1770                     )
1771                 )
1772             )
1773         );
1774     }
1775 
1776     // fetches and sorts the reserves for a pair
1777     function getReserves(
1778         address factory,
1779         address tokenA,
1780         address tokenB
1781     ) internal view returns (uint256 reserveA, uint256 reserveB) {
1782         (address token0, ) = sortTokens(tokenA, tokenB);
1783         (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(
1784             pairFor(factory, tokenA, tokenB)
1785         )
1786             .getReserves();
1787         (reserveA, reserveB) = tokenA == token0
1788             ? (reserve0, reserve1)
1789             : (reserve1, reserve0);
1790     }
1791 
1792     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
1793     function quote(
1794         uint256 amountA,
1795         uint256 reserveA,
1796         uint256 reserveB
1797     ) internal pure returns (uint256 amountB) {
1798         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
1799         require(
1800             reserveA > 0 && reserveB > 0,
1801             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
1802         );
1803         amountB = amountA.mul(reserveB) / reserveA;
1804     }
1805 
1806     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1807     function getAmountOut(
1808         uint256 amountIn,
1809         uint256 reserveIn,
1810         uint256 reserveOut
1811     ) internal pure returns (uint256 amountOut) {
1812         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1813         require(
1814             reserveIn > 0 && reserveOut > 0,
1815             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
1816         );
1817         uint256 amountInWithFee = amountIn.mul(997);
1818         uint256 numerator = amountInWithFee.mul(reserveOut);
1819         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
1820         amountOut = numerator / denominator;
1821     }
1822 
1823     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
1824     function getAmountIn(
1825         uint256 amountOut,
1826         uint256 reserveIn,
1827         uint256 reserveOut
1828     ) internal pure returns (uint256 amountIn) {
1829         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
1830         require(
1831             reserveIn > 0 && reserveOut > 0,
1832             'UniswapV2Library: INSUFFICIENT_LIQUIDITY'
1833         );
1834         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
1835         uint256 denominator = reserveOut.sub(amountOut).mul(997);
1836         amountIn = (numerator / denominator).add(1);
1837     }
1838 
1839     // performs chained getAmountOut calculations on any number of pairs
1840     function getAmountsOut(
1841         address factory,
1842         uint256 amountIn,
1843         address[] memory path
1844     ) internal view returns (uint256[] memory amounts) {
1845         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1846         amounts = new uint256[](path.length);
1847         amounts[0] = amountIn;
1848         for (uint256 i; i < path.length - 1; i++) {
1849             (uint256 reserveIn, uint256 reserveOut) = getReserves(
1850                 factory,
1851                 path[i],
1852                 path[i + 1]
1853             );
1854             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1855         }
1856     }
1857 
1858     // performs chained getAmountIn calculations on any number of pairs
1859     function getAmountsIn(
1860         address factory,
1861         uint256 amountOut,
1862         address[] memory path
1863     ) internal view returns (uint256[] memory amounts) {
1864         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1865         amounts = new uint256[](path.length);
1866         amounts[amounts.length - 1] = amountOut;
1867         for (uint256 i = path.length - 1; i > 0; i--) {
1868             (uint256 reserveIn, uint256 reserveOut) = getReserves(
1869                 factory,
1870                 path[i - 1],
1871                 path[i]
1872             );
1873             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1874         }
1875     }
1876 }
1877 
1878 contract Oracle is Epoch {
1879     using FixedPoint for *;
1880     using SafeMath for uint256;
1881 
1882     /* ========== STATE VARIABLES ========== */
1883 
1884     // uniswap
1885     address public token0;
1886     address public token1;
1887     IUniswapV2Pair public pair;
1888 
1889     // oracle
1890     uint32 public blockTimestampLast;
1891     uint256 public price0CumulativeLast;
1892     uint256 public price1CumulativeLast;
1893     FixedPoint.uq112x112 public price0Average;
1894     FixedPoint.uq112x112 public price1Average;
1895 
1896     /* ========== CONSTRUCTOR ========== */
1897 
1898     constructor(
1899         address _factory,
1900         address _tokenA,
1901         address _tokenB,
1902         uint256 _period,
1903         uint256 _startTime
1904     ) public Epoch(_period, _startTime, 0) {
1905         IUniswapV2Pair _pair = IUniswapV2Pair(
1906             UniswapV2Library.pairFor(_factory, _tokenA, _tokenB)
1907         );
1908         pair = _pair;
1909         token0 = _pair.token0();
1910         token1 = _pair.token1();
1911         price0CumulativeLast = _pair.price0CumulativeLast(); // fetch the current accumulated price value (1 / 0)
1912         price1CumulativeLast = _pair.price1CumulativeLast(); // fetch the current accumulated price value (0 / 1)
1913         uint112 reserve0;
1914         uint112 reserve1;
1915         (reserve0, reserve1, blockTimestampLast) = _pair.getReserves();
1916         require(reserve0 != 0 && reserve1 != 0, 'Oracle: NO_RESERVES'); // ensure that there's liquidity in the pair
1917     }
1918 
1919     /* ========== MUTABLE FUNCTIONS ========== */
1920 
1921     /** @dev Updates 1-day EMA price from Uniswap.  */
1922     function update() external checkEpoch {
1923         (
1924             uint256 price0Cumulative,
1925             uint256 price1Cumulative,
1926             uint32 blockTimestamp
1927         ) = UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
1928         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
1929 
1930         if (timeElapsed == 0) {
1931             // prevent divided by zero
1932             return;
1933         }
1934 
1935         // overflow is desired, casting never truncates
1936         // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
1937         price0Average = FixedPoint.uq112x112(
1938             uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)
1939         );
1940         price1Average = FixedPoint.uq112x112(
1941             uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)
1942         );
1943 
1944         price0CumulativeLast = price0Cumulative;
1945         price1CumulativeLast = price1Cumulative;
1946         blockTimestampLast = blockTimestamp;
1947 
1948         emit Updated(price0Cumulative, price1Cumulative);
1949     }
1950 
1951     // note this will always return 0 before update has been called successfully for the first time.
1952     function consult(address token, uint256 amountIn)
1953         external
1954         view
1955         returns (uint144 amountOut)
1956     {
1957         if (token == token0) {
1958             amountOut = price0Average.mul(amountIn).decode144();
1959         } else {
1960             require(token == token1, 'Oracle: INVALID_TOKEN');
1961             amountOut = price1Average.mul(amountIn).decode144();
1962         }
1963     }
1964 
1965     function pairFor(
1966         address factory,
1967         address tokenA,
1968         address tokenB
1969     ) external pure returns (address lpt) {
1970         return UniswapV2Library.pairFor(factory, tokenA, tokenB);
1971     }
1972 
1973     event Updated(uint256 price0CumulativeLast, uint256 price1CumulativeLast);
1974 }
1975 
1976 contract Treasury is ContractGuard, Epoch, AccessControl {
1977     using FixedPoint for *;
1978     using SafeERC20 for IERC20;
1979     using Address for address;
1980     using SafeMath for uint256;
1981     using Safe112 for uint112;
1982 
1983     // ========== FLAGS
1984     bool public migrated = false;
1985 
1986     // ========== CORE
1987     address public cash;
1988     address public share;
1989     address public boardroom;
1990     address public seigniorageOracle;
1991     address public melterOracle;
1992     address public ubcusdtPool;
1993 
1994     // ========== PARAMS
1995     uint256 public cashPriceOne;
1996     uint256 public cashPriceCeiling;
1997     uint256 public cashPriceFloor;
1998     bytes32 public constant EXTENSION = keccak256("EXTENSION");
1999 
2000     // Contractionary Policy Earned
2001     mapping(address => uint256) public CPEarned;
2002     uint256 public currentEpochBurnedCeiling;
2003     uint256 public currentEpochTotalBurned;
2004     uint256 public totalPendingRewards;
2005     mapping(address=>mapping(uint256 => uint256)) currentEpochUserBurned;
2006 
2007     constructor(
2008         address _cash,
2009         address _share,
2010         address _seigniorageOracle,
2011         address _boardroom,
2012         uint256 _startTime,
2013         address _UBCUSDTPool,
2014         address _melterOracle
2015     ) public Epoch(1 days, _startTime, 0) {
2016         cash = _cash;
2017         share = _share;
2018         seigniorageOracle = _seigniorageOracle;
2019         boardroom = _boardroom;
2020         ubcusdtPool = _UBCUSDTPool;
2021         melterOracle = _melterOracle;
2022         cashPriceOne = 10**6;
2023         cashPriceCeiling = uint256(105).mul(cashPriceOne).div(10**2);
2024         cashPriceFloor = uint256(95).mul(cashPriceOne).div(10**2);
2025         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2026     }
2027 
2028     modifier checkMigration {
2029         require(!migrated, "Treasury: migrated");
2030 
2031         _;
2032     }
2033 
2034     modifier checkOperator {
2035         require(
2036             IUCashAsset(cash).operator() == address(this) &&
2037                 IUCashAsset(share).operator() == address(this) &&
2038                 Operator(boardroom).operator() == address(this),
2039             "Treasury: need more permission"
2040         );
2041         _;
2042     }
2043 
2044     function ExtensionMint(uint256 amount) public {
2045         require(hasRole(EXTENSION, msg.sender), "Only EXTENSION");
2046         IUCashAsset(cash).mint(msg.sender, amount);
2047     }
2048 
2049     function ExtensionBurn(uint256 amount) public {
2050         require(hasRole(EXTENSION, msg.sender), "Only EXTENSION");
2051         IUCashAsset(cash).burnFrom(msg.sender, amount);
2052     }
2053 
2054     function setParams(
2055         uint256 ceiling,
2056         uint256 one,
2057         uint256 floor
2058     ) public onlyOperator {
2059         cashPriceCeiling = ceiling;
2060         cashPriceOne = one;
2061         cashPriceFloor = floor;
2062     }
2063 
2064     function getSeigniorageOraclePrice() public view returns (uint256) {
2065         return _getCashPrice(seigniorageOracle);
2066     }
2067 
2068     function getMelterOraclePrice() public view returns (uint256) {
2069         return _getCashPrice(melterOracle);
2070     }
2071 
2072     function _getCashPrice(address oracle) internal view returns (uint256) {
2073         try IOracle(oracle).consult(cash, 1e18) returns (uint256 price) {
2074             return price;
2075         } catch {
2076             revert("Treasury: failed to consult cash price from the oracle");
2077         }
2078     }
2079 
2080     function _updateCashPrice() internal {
2081         try IOracle(seigniorageOracle).update() {} catch {}
2082     }
2083 
2084 
2085 
2086     function updateMelterPrice() public onlyOperator {
2087         try IOracle(melterOracle).update() {
2088             uint256 melterPrice = getMelterOraclePrice();
2089             if (melterPrice <= cashPriceFloor) {
2090                 uint256 poolUBCAmount = getTotalPooledUBC();
2091                 uint256 percentage = cashPriceOne.sub(melterPrice);
2092                 currentEpochBurnedCeiling = poolUBCAmount.mul(percentage).div(1e6);
2093                 currentEpochTotalBurned = 0;
2094             } else {
2095                 currentEpochBurnedCeiling = 0;
2096                 currentEpochTotalBurned = 0;
2097             }
2098         } catch {}
2099     }
2100 
2101 
2102     function migrate(address target) public onlyOperator checkOperator {
2103         require(!migrated, "Treasury: migrated");
2104 
2105         // cash
2106         Operator(cash).transferOperator(target);
2107         Operator(cash).transferOwnership(target);
2108 
2109         Operator(boardroom).transferOperator(target);
2110         Operator(boardroom).transferOwnership(target);
2111 
2112         // share
2113         Operator(share).transferOperator(target);
2114         Operator(share).transferOwnership(target);
2115 
2116         migrated = true;
2117         emit Migration(target);
2118     }
2119 
2120 
2121 
2122     function melter(uint256 amount) public onlyOneBlock checkMigration {
2123         require(amount > 0, "can not stake zero");
2124         uint256 melterPrice = getMelterOraclePrice();
2125         require(melterPrice <= cashPriceFloor, "melter not open");
2126         uint256 userStakeAmount = Boardroom(boardroom).balanceOf(msg.sender);
2127         require( userStakeAmount > 0,"user have not board seat");
2128         uint256 sharePerBurned = getSharePerBurned();
2129         uint256 userMaxBurned = sharePerBurned.mul(userStakeAmount);
2130         uint256 currentEpoch = getMelterEpoch();
2131         require(currentEpochUserBurned[msg.sender][currentEpoch].add(amount)<=userMaxBurned,"user have not enough UCS right to burn more UBC");
2132         require(currentEpochTotalBurned.add(amount) <= currentEpochBurnedCeiling,"melter alreay burned too much");
2133         IUCashAsset(cash).burnFrom(msg.sender, amount);
2134         currentEpochTotalBurned = currentEpochTotalBurned.add(amount);
2135         currentEpochUserBurned[msg.sender][currentEpoch] = currentEpochUserBurned[msg.sender][currentEpoch].add(amount);
2136         uint256 rewards = cashPriceOne.mul(1e18).div(melterPrice).mul(amount).div(1e18);
2137         CPEarned[msg.sender] = CPEarned[msg.sender].add(rewards);
2138         totalPendingRewards = totalPendingRewards.add(rewards);
2139     }
2140 
2141     function redeem() public onlyOneBlock {
2142         uint256 melterPrice =  getMelterOraclePrice();
2143         require(melterPrice >= cashPriceCeiling, "price lower than 1.05");
2144         require(CPEarned[msg.sender] > 0, "earned zero");
2145         IUCashAsset(cash).mint(msg.sender, CPEarned[msg.sender]);
2146         totalPendingRewards = totalPendingRewards.sub(CPEarned[msg.sender]);
2147         CPEarned[msg.sender] = 0;
2148     }
2149 
2150 
2151     function getSharePerBurned() public view returns(uint256){
2152         uint256 totalCash = IERC20(cash).totalSupply();
2153         uint256 boardroomStaked = IERC20(share).balanceOf(boardroom);
2154         uint256 SharePerBurned = totalCash.mul(1e18).div(boardroomStaked).div(1e18);
2155         return SharePerBurned;
2156     }
2157 
2158     function getMelterEpoch() public view returns(uint256){
2159         return Oracle(melterOracle).getCurrentEpoch();
2160     }
2161 
2162     function getTotalPooledUBC() public view returns (uint256) {
2163         (uint112 poolUBCAmount, , ) = IUniswapV2Pair(ubcusdtPool).getReserves();
2164         return uint256(poolUBCAmount);
2165     }
2166 
2167     function allocateSeigniorage()
2168         external
2169         checkMigration
2170         onlyOneBlock
2171         checkStartTime
2172         checkEpoch
2173         checkOperator
2174     {
2175         _updateCashPrice();
2176         uint256 cashPrice = _getCashPrice(seigniorageOracle);
2177         if (cashPrice < cashPriceCeiling) {
2178             return;
2179         }
2180         uint256 poolUBCAmount = getTotalPooledUBC();
2181         uint256 percentage = cashPrice.sub(cashPriceOne);
2182         uint256 seigniorage = poolUBCAmount.mul(percentage).div(1e6);
2183         IUCashAsset(cash).mint(address(this), seigniorage);
2184         IERC20(cash).safeApprove(boardroom, seigniorage);
2185         IBoardroom(boardroom).allocateSeigniorage(seigniorage);
2186         emit BoardroomFunded(now, seigniorage);
2187     }
2188 
2189     event Migration(address indexed target);
2190     event BoardroomFunded(uint256 timestamp, uint256 seigniorage);
2191 }