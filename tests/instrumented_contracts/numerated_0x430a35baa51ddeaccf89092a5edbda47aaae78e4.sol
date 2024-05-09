1 // Dependency file: @openzeppelin/contracts/utils/SafeCast.sol
2 
3 
4 
5 // pragma solidity ^0.6.0;
6 
7 
8 /**
9  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
10  * checks.
11  *
12  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
13  * easily result in undesired exploitation or bugs, since developers usually
14  * assume that overflows raise errors. `SafeCast` restores this intuition by
15  * reverting the transaction when such an operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  *
20  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
21  * all math on `uint256` and `int256` and then downcasting.
22  */
23 library SafeCast {
24 
25     /**
26      * @dev Returns the downcasted uint128 from uint256, reverting on
27      * overflow (when the input is greater than largest uint128).
28      *
29      * Counterpart to Solidity's `uint128` operator.
30      *
31      * Requirements:
32      *
33      * - input must fit into 128 bits
34      */
35     function toUint128(uint256 value) internal pure returns (uint128) {
36         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
37         return uint128(value);
38     }
39 
40     /**
41      * @dev Returns the downcasted uint64 from uint256, reverting on
42      * overflow (when the input is greater than largest uint64).
43      *
44      * Counterpart to Solidity's `uint64` operator.
45      *
46      * Requirements:
47      *
48      * - input must fit into 64 bits
49      */
50     function toUint64(uint256 value) internal pure returns (uint64) {
51         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
52         return uint64(value);
53     }
54 
55     /**
56      * @dev Returns the downcasted uint32 from uint256, reverting on
57      * overflow (when the input is greater than largest uint32).
58      *
59      * Counterpart to Solidity's `uint32` operator.
60      *
61      * Requirements:
62      *
63      * - input must fit into 32 bits
64      */
65     function toUint32(uint256 value) internal pure returns (uint32) {
66         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
67         return uint32(value);
68     }
69 
70     /**
71      * @dev Returns the downcasted uint16 from uint256, reverting on
72      * overflow (when the input is greater than largest uint16).
73      *
74      * Counterpart to Solidity's `uint16` operator.
75      *
76      * Requirements:
77      *
78      * - input must fit into 16 bits
79      */
80     function toUint16(uint256 value) internal pure returns (uint16) {
81         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
82         return uint16(value);
83     }
84 
85     /**
86      * @dev Returns the downcasted uint8 from uint256, reverting on
87      * overflow (when the input is greater than largest uint8).
88      *
89      * Counterpart to Solidity's `uint8` operator.
90      *
91      * Requirements:
92      *
93      * - input must fit into 8 bits.
94      */
95     function toUint8(uint256 value) internal pure returns (uint8) {
96         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
97         return uint8(value);
98     }
99 
100     /**
101      * @dev Converts a signed int256 into an unsigned uint256.
102      *
103      * Requirements:
104      *
105      * - input must be greater than or equal to 0.
106      */
107     function toUint256(int256 value) internal pure returns (uint256) {
108         require(value >= 0, "SafeCast: value must be positive");
109         return uint256(value);
110     }
111 
112     /**
113      * @dev Returns the downcasted int128 from int256, reverting on
114      * overflow (when the input is less than smallest int128 or
115      * greater than largest int128).
116      *
117      * Counterpart to Solidity's `int128` operator.
118      *
119      * Requirements:
120      *
121      * - input must fit into 128 bits
122      *
123      * _Available since v3.1._
124      */
125     function toInt128(int256 value) internal pure returns (int128) {
126         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
127         return int128(value);
128     }
129 
130     /**
131      * @dev Returns the downcasted int64 from int256, reverting on
132      * overflow (when the input is less than smallest int64 or
133      * greater than largest int64).
134      *
135      * Counterpart to Solidity's `int64` operator.
136      *
137      * Requirements:
138      *
139      * - input must fit into 64 bits
140      *
141      * _Available since v3.1._
142      */
143     function toInt64(int256 value) internal pure returns (int64) {
144         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
145         return int64(value);
146     }
147 
148     /**
149      * @dev Returns the downcasted int32 from int256, reverting on
150      * overflow (when the input is less than smallest int32 or
151      * greater than largest int32).
152      *
153      * Counterpart to Solidity's `int32` operator.
154      *
155      * Requirements:
156      *
157      * - input must fit into 32 bits
158      *
159      * _Available since v3.1._
160      */
161     function toInt32(int256 value) internal pure returns (int32) {
162         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
163         return int32(value);
164     }
165 
166     /**
167      * @dev Returns the downcasted int16 from int256, reverting on
168      * overflow (when the input is less than smallest int16 or
169      * greater than largest int16).
170      *
171      * Counterpart to Solidity's `int16` operator.
172      *
173      * Requirements:
174      *
175      * - input must fit into 16 bits
176      *
177      * _Available since v3.1._
178      */
179     function toInt16(int256 value) internal pure returns (int16) {
180         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
181         return int16(value);
182     }
183 
184     /**
185      * @dev Returns the downcasted int8 from int256, reverting on
186      * overflow (when the input is less than smallest int8 or
187      * greater than largest int8).
188      *
189      * Counterpart to Solidity's `int8` operator.
190      *
191      * Requirements:
192      *
193      * - input must fit into 8 bits.
194      *
195      * _Available since v3.1._
196      */
197     function toInt8(int256 value) internal pure returns (int8) {
198         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
199         return int8(value);
200     }
201 
202     /**
203      * @dev Converts an unsigned uint256 into a signed int256.
204      *
205      * Requirements:
206      *
207      * - input must be less than or equal to maxInt256.
208      */
209     function toInt256(uint256 value) internal pure returns (int256) {
210         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
211         return int256(value);
212     }
213 }
214 
215 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
216 
217 
218 
219 // pragma solidity ^0.6.0;
220 
221 /**
222  * @dev Interface of the ERC20 standard as defined in the EIP.
223  */
224 interface IERC20 {
225     /**
226      * @dev Returns the amount of tokens in existence.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     /**
231      * @dev Returns the amount of tokens owned by `account`.
232      */
233     function balanceOf(address account) external view returns (uint256);
234 
235     /**
236      * @dev Moves `amount` tokens from the caller's account to `recipient`.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transfer(address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Returns the remaining number of tokens that `spender` will be
246      * allowed to spend on behalf of `owner` through {transferFrom}. This is
247      * zero by default.
248      *
249      * This value changes when {approve} or {transferFrom} are called.
250      */
251     function allowance(address owner, address spender) external view returns (uint256);
252 
253     /**
254      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * // importANT: Beware that changing an allowance with this method brings the risk
259      * that someone may use both the old and the new allowance by unfortunate
260      * transaction ordering. One possible solution to mitigate this race
261      * condition is to first reduce the spender's allowance to 0 and set the
262      * desired value afterwards:
263      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264      *
265      * Emits an {Approval} event.
266      */
267     function approve(address spender, uint256 amount) external returns (bool);
268 
269     /**
270      * @dev Moves `amount` tokens from `sender` to `recipient` using the
271      * allowance mechanism. `amount` is then deducted from the caller's
272      * allowance.
273      *
274      * Returns a boolean value indicating whether the operation succeeded.
275      *
276      * Emits a {Transfer} event.
277      */
278     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
279 
280     /**
281      * @dev Emitted when `value` tokens are moved from one account (`from`) to
282      * another (`to`).
283      *
284      * Note that `value` may be zero.
285      */
286     event Transfer(address indexed from, address indexed to, uint256 value);
287 
288     /**
289      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
290      * a call to {approve}. `value` is the new allowance.
291      */
292     event Approval(address indexed owner, address indexed spender, uint256 value);
293 }
294 
295 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
296 
297 
298 
299 // pragma solidity ^0.6.0;
300 
301 /*
302  * @dev Provides information about the current execution context, including the
303  * sender of the transaction and its data. While these are generally available
304  * via msg.sender and msg.data, they should not be accessed in such a direct
305  * manner, since when dealing with GSN meta-transactions the account sending and
306  * paying for execution may not be the actual sender (as far as an application
307  * is concerned).
308  *
309  * This contract is only required for intermediate, library-like contracts.
310  */
311 abstract contract Context {
312     function _msgSender() internal view virtual returns (address payable) {
313         return msg.sender;
314     }
315 
316     function _msgData() internal view virtual returns (bytes memory) {
317         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
318         return msg.data;
319     }
320 }
321 
322 // Dependency file: contracts/lib/AddressArrayUtils.sol
323 
324 /*
325     Copyright 2020 Set Labs Inc.
326 
327     Licensed under the Apache License, Version 2.0 (the "License");
328     you may not use this file except in compliance with the License.
329     You may obtain a copy of the License at
330 
331     http://www.apache.org/licenses/LICENSE-2.0
332 
333     Unless required by applicable law or agreed to in writing, software
334     distributed under the License is distributed on an "AS IS" BASIS,
335     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
336     See the License for the specific language governing permissions and
337     limitations under the License.
338 
339 
340 */
341 
342 // pragma solidity 0.6.10;
343 
344 /**
345  * @title AddressArrayUtils
346  * @author Set Protocol
347  *
348  * Utility functions to handle Address Arrays
349  */
350 library AddressArrayUtils {
351 
352     /**
353      * Finds the index of the first occurrence of the given element.
354      * @param A The input array to search
355      * @param a The value to find
356      * @return Returns (index and isIn) for the first occurrence starting from index 0
357      */
358     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
359         uint256 length = A.length;
360         for (uint256 i = 0; i < length; i++) {
361             if (A[i] == a) {
362                 return (i, true);
363             }
364         }
365         return (uint256(-1), false);
366     }
367 
368     /**
369     * Returns true if the value is present in the list. Uses indexOf internally.
370     * @param A The input array to search
371     * @param a The value to find
372     * @return Returns isIn for the first occurrence starting from index 0
373     */
374     function contains(address[] memory A, address a) internal pure returns (bool) {
375         (, bool isIn) = indexOf(A, a);
376         return isIn;
377     }
378 
379     /**
380     * Returns true if there are 2 elements that are the same in an array
381     * @param A The input array to search
382     * @return Returns boolean for the first occurrence of a duplicate
383     */
384     function hasDuplicate(address[] memory A) internal pure returns(bool) {
385         require(A.length > 0, "A is empty");
386 
387         for (uint256 i = 0; i < A.length - 1; i++) {
388             address current = A[i];
389             for (uint256 j = i + 1; j < A.length; j++) {
390                 if (current == A[j]) {
391                     return true;
392                 }
393             }
394         }
395         return false;
396     }
397 
398     /**
399      * @param A The input array to search
400      * @param a The address to remove     
401      * @return Returns the array with the object removed.
402      */
403     function remove(address[] memory A, address a)
404         internal
405         pure
406         returns (address[] memory)
407     {
408         (uint256 index, bool isIn) = indexOf(A, a);
409         if (!isIn) {
410             revert("Address not in array.");
411         } else {
412             (address[] memory _A,) = pop(A, index);
413             return _A;
414         }
415     }
416 
417     /**
418     * Removes specified index from array
419     * @param A The input array to search
420     * @param index The index to remove
421     * @return Returns the new array and the removed entry
422     */
423     function pop(address[] memory A, uint256 index)
424         internal
425         pure
426         returns (address[] memory, address)
427     {
428         uint256 length = A.length;
429         require(index < A.length, "Index must be < A length");
430         address[] memory newAddresses = new address[](length - 1);
431         for (uint256 i = 0; i < index; i++) {
432             newAddresses[i] = A[i];
433         }
434         for (uint256 j = index + 1; j < length; j++) {
435             newAddresses[j - 1] = A[j];
436         }
437         return (newAddresses, A[index]);
438     }
439 }
440 // Dependency file: contracts/lib/PreciseUnitMath.sol
441 
442 /*
443     Copyright 2020 Set Labs Inc.
444 
445     Licensed under the Apache License, Version 2.0 (the "License");
446     you may not use this file except in compliance with the License.
447     You may obtain a copy of the License at
448 
449     http://www.apache.org/licenses/LICENSE-2.0
450 
451     Unless required by applicable law or agreed to in writing, software
452     distributed under the License is distributed on an "AS IS" BASIS,
453     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
454     See the License for the specific language governing permissions and
455     limitations under the License.
456 
457 
458 */
459 
460 // pragma solidity 0.6.10;
461 // pragma experimental ABIEncoderV2;
462 
463 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
464 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
465 
466 
467 /**
468  * @title PreciseUnitMath
469  * @author Set Protocol
470  *
471  * Arithmetic for fixed-point numbers with 18 decimals of precision. Some functions taken from
472  * dYdX's BaseMath library.
473  */
474 library PreciseUnitMath {
475     using SafeMath for uint256;
476     using SignedSafeMath for int256;
477 
478     // The number One in precise units.
479     uint256 constant internal PRECISE_UNIT = 10 ** 18;
480     int256 constant internal PRECISE_UNIT_INT = 10 ** 18;
481 
482     // Max unsigned integer value
483     uint256 constant internal MAX_UINT_256 = type(uint256).max;
484     // Max and min signed integer value
485     int256 constant internal MAX_INT_256 = type(int256).max;
486     int256 constant internal MIN_INT_256 = type(int256).min;
487 
488     /**
489      * @dev Getter function since constants can't be read directly from libraries.
490      */
491     function preciseUnit() internal pure returns (uint256) {
492         return PRECISE_UNIT;
493     }
494 
495     /**
496      * @dev Getter function since constants can't be read directly from libraries.
497      */
498     function preciseUnitInt() internal pure returns (int256) {
499         return PRECISE_UNIT_INT;
500     }
501 
502     /**
503      * @dev Getter function since constants can't be read directly from libraries.
504      */
505     function maxUint256() internal pure returns (uint256) {
506         return MAX_UINT_256;
507     }
508 
509     /**
510      * @dev Getter function since constants can't be read directly from libraries.
511      */
512     function maxInt256() internal pure returns (int256) {
513         return MAX_INT_256;
514     }
515 
516     /**
517      * @dev Getter function since constants can't be read directly from libraries.
518      */
519     function minInt256() internal pure returns (int256) {
520         return MIN_INT_256;
521     }
522 
523     /**
524      * @dev Multiplies value a by value b (result is rounded down). It's assumed that the value b is the significand
525      * of a number with 18 decimals precision.
526      */
527     function preciseMul(uint256 a, uint256 b) internal pure returns (uint256) {
528         return a.mul(b).div(PRECISE_UNIT);
529     }
530 
531     /**
532      * @dev Multiplies value a by value b (result is rounded towards zero). It's assumed that the value b is the
533      * significand of a number with 18 decimals precision.
534      */
535     function preciseMul(int256 a, int256 b) internal pure returns (int256) {
536         return a.mul(b).div(PRECISE_UNIT_INT);
537     }
538 
539     /**
540      * @dev Multiplies value a by value b (result is rounded up). It's assumed that the value b is the significand
541      * of a number with 18 decimals precision.
542      */
543     function preciseMulCeil(uint256 a, uint256 b) internal pure returns (uint256) {
544         if (a == 0 || b == 0) {
545             return 0;
546         }
547         return a.mul(b).sub(1).div(PRECISE_UNIT).add(1);
548     }
549 
550     /**
551      * @dev Divides value a by value b (result is rounded down).
552      */
553     function preciseDiv(uint256 a, uint256 b) internal pure returns (uint256) {
554         return a.mul(PRECISE_UNIT).div(b);
555     }
556 
557 
558     /**
559      * @dev Divides value a by value b (result is rounded towards 0).
560      */
561     function preciseDiv(int256 a, int256 b) internal pure returns (int256) {
562         return a.mul(PRECISE_UNIT_INT).div(b);
563     }
564 
565     /**
566      * @dev Divides value a by value b (result is rounded up or away from 0).
567      */
568     function preciseDivCeil(uint256 a, uint256 b) internal pure returns (uint256) {
569         require(b != 0, "Cant divide by 0");
570 
571         return a > 0 ? a.mul(PRECISE_UNIT).sub(1).div(b).add(1) : 0;
572     }
573 
574     /**
575      * @dev Divides value a by value b (result is rounded down - positive numbers toward 0 and negative away from 0).
576      */
577     function divDown(int256 a, int256 b) internal pure returns (int256) {
578         require(b != 0, "Cant divide by 0");
579         require(a != MIN_INT_256 || b != -1, "Invalid input");
580 
581         int256 result = a.div(b);
582         if (a ^ b < 0 && a % b != 0) {
583             result = result.sub(1);
584         }
585 
586         return result;
587     }
588 
589     /**
590      * @dev Multiplies value a by value b where rounding is towards the lesser number. 
591      * (positive values are rounded towards zero and negative values are rounded away from 0). 
592      */
593     function conservativePreciseMul(int256 a, int256 b) internal pure returns (int256) {
594         return divDown(a.mul(b), PRECISE_UNIT_INT);
595     }
596 
597     /**
598      * @dev Divides value a by value b where rounding is towards the lesser number. 
599      * (positive values are rounded towards zero and negative values are rounded away from 0). 
600      */
601     function conservativePreciseDiv(int256 a, int256 b) internal pure returns (int256) {
602         return divDown(a.mul(PRECISE_UNIT_INT), b);
603     }
604 }
605 // Dependency file: contracts/protocol/lib/Position.sol
606 
607 /*
608     Copyright 2020 Set Labs Inc.
609 
610     Licensed under the Apache License, Version 2.0 (the "License");
611     you may not use this file except in compliance with the License.
612     You may obtain a copy of the License at
613 
614     http://www.apache.org/licenses/LICENSE-2.0
615 
616     Unless required by applicable law or agreed to in writing, software
617     distributed under the License is distributed on an "AS IS" BASIS,
618     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
619     See the License for the specific language governing permissions and
620     limitations under the License.
621 
622 
623 */
624 
625 // pragma solidity 0.6.10;
626 // pragma experimental "ABIEncoderV2";
627 
628 // import { SafeCast } from "@openzeppelin/contracts/utils/SafeCast.sol";
629 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
630 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
631 
632 // import { ISetToken } from "../../interfaces/ISetToken.sol";
633 // import { PreciseUnitMath } from "../../lib/PreciseUnitMath.sol";
634 
635 /**
636  * @title Position
637  * @author Set Protocol
638  *
639  * Collection of helper functions for handling and updating SetToken Positions
640  */
641 library Position {
642     using SafeCast for uint256;
643     using SafeMath for uint256;
644     using SafeCast for int256;
645     using SignedSafeMath for int256;
646     using PreciseUnitMath for uint256;
647 
648     /* ============ Helper ============ */
649 
650     /**
651      * Returns whether the SetToken has a default position for a given component (if the real unit is > 0)
652      */
653     function hasDefaultPosition(ISetToken _setToken, address _component) internal view returns(bool) {
654         return _setToken.getDefaultPositionRealUnit(_component) > 0;
655     }
656 
657     /**
658      * Returns whether the SetToken has an external position for a given component (if # of position modules is > 0)
659      */
660     function hasExternalPosition(ISetToken _setToken, address _component) internal view returns(bool) {
661         return _setToken.getExternalPositionModules(_component).length > 0;
662     }
663     
664     /**
665      * Returns whether the SetToken component default position real unit is greater than or equal to units passed in.
666      */
667     function hasSufficientDefaultUnits(ISetToken _setToken, address _component, uint256 _unit) internal view returns(bool) {
668         return _setToken.getDefaultPositionRealUnit(_component) >= _unit.toInt256();
669     }
670 
671     /**
672      * Returns whether the SetToken component external position is greater than or equal to the real units passed in.
673      */
674     function hasSufficientExternalUnits(
675         ISetToken _setToken,
676         address _component,
677         address _positionModule,
678         uint256 _unit
679     )
680         internal
681         view
682         returns(bool)
683     {
684        return _setToken.getExternalPositionRealUnit(_component, _positionModule) >= _unit.toInt256();    
685     }
686 
687     /**
688      * If the position does not exist, create a new Position and add to the SetToken. If it already exists,
689      * then set the position units. If the new units is 0, remove the position. Handles adding/removing of 
690      * components where needed (in light of potential external positions).
691      *
692      * @param _setToken           Address of SetToken being modified
693      * @param _component          Address of the component
694      * @param _newUnit            Quantity of Position units - must be >= 0
695      */
696     function editDefaultPosition(ISetToken _setToken, address _component, uint256 _newUnit) internal {
697         bool isPositionFound = hasDefaultPosition(_setToken, _component);
698         if (!isPositionFound && _newUnit > 0) {
699             // If there is no Default Position and no External Modules, then component does not exist
700             if (!hasExternalPosition(_setToken, _component)) {
701                 _setToken.addComponent(_component);
702             }
703         } else if (isPositionFound && _newUnit == 0) {
704             // If there is a Default Position and no external positions, remove the component
705             if (!hasExternalPosition(_setToken, _component)) {
706                 _setToken.removeComponent(_component);
707             }
708         }
709 
710         _setToken.editDefaultPositionUnit(_component, _newUnit.toInt256());
711     }
712 
713     /**
714      * Update an external position and remove and external positions or components if necessary. The logic flows as follows:
715      * 1) If component is not already added then add component and external position. 
716      * 2) If component is added but no existing external position using the passed module exists then add the external position.
717      * 3) If the existing position is being added to then just update the unit
718      * 4) If the position is being closed and no other external positions or default positions are associated with the component
719      *    then untrack the component and remove external position.
720      * 5) If the position is being closed and  other existing positions still exist for the component then just remove the
721      *    external position.
722      *
723      * @param _setToken         SetToken being updated
724      * @param _component        Component position being updated
725      * @param _module           Module external position is associated with
726      * @param _newUnit          Position units of new external position
727      * @param _data             Arbitrary data associated with the position
728      */
729     function editExternalPosition(
730         ISetToken _setToken,
731         address _component,
732         address _module,
733         int256 _newUnit,
734         bytes memory _data
735     )
736         internal
737     {
738         if (!_setToken.isComponent(_component)) {
739             _setToken.addComponent(_component);
740             addExternalPosition(_setToken, _component, _module, _newUnit, _data);
741         } else if (!_setToken.isExternalPositionModule(_component, _module)) {
742             addExternalPosition(_setToken, _component, _module, _newUnit, _data);
743         } else if (_newUnit != 0) {
744             _setToken.editExternalPositionUnit(_component, _module, _newUnit);
745         } else {
746             // If no default or external position remaining then remove component from components array
747             if (_setToken.getDefaultPositionRealUnit(_component) == 0 && _setToken.getExternalPositionModules(_component).length == 1) {
748                 _setToken.removeComponent(_component);
749             }
750             _setToken.removeExternalPositionModule(_component, _module);
751         }
752     }
753 
754     /**
755      * Add a new external position from a previously untracked module.
756      *
757      * @param _setToken         SetToken being updated
758      * @param _component        Component position being updated
759      * @param _module           Module external position is associated with
760      * @param _newUnit          Position units of new external position
761      * @param _data             Arbitrary data associated with the position
762      */
763     function addExternalPosition(
764         ISetToken _setToken,
765         address _component,
766         address _module,
767         int256 _newUnit,
768         bytes memory _data
769     )
770         internal
771     {
772         _setToken.addExternalPositionModule(_component, _module);
773         _setToken.editExternalPositionUnit(_component, _module, _newUnit);
774         _setToken.editExternalPositionData(_component, _module, _data);
775     }
776 
777     /**
778      * Get total notional amount of Default position
779      *
780      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
781      * @param _positionUnit       Quantity of Position units
782      *
783      * @return                    Total notional amount of units
784      */
785     function getDefaultTotalNotional(uint256 _setTokenSupply, uint256 _positionUnit) internal pure returns (uint256) {
786         return _setTokenSupply.preciseMul(_positionUnit);
787     }
788 
789     /**
790      * Get position unit from total notional amount
791      *
792      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
793      * @param _totalNotional      Total notional amount of component prior to
794      * @return                    Default position unit
795      */
796     function getDefaultPositionUnit(uint256 _setTokenSupply, uint256 _totalNotional) internal pure returns (uint256) {
797         return _totalNotional.preciseDiv(_setTokenSupply);
798     }
799 
800     /**
801      * Calculate the new position unit given total notional values pre and post executing an action that changes SetToken state
802      * The intention is to make updates to the units without accidentally picking up airdropped assets as well.
803      *
804      * @param _setTokenSupply     Supply of SetToken in precise units (10^18)
805      * @param _preTotalNotional   Total notional amount of component prior to executing action
806      * @param _postTotalNotional  Total notional amount of component after the executing action
807      * @param _prePositionUnit    Position unit of SetToken prior to executing action
808      * @return                    New position unit
809      */
810     function calculateDefaultEditPositionUnit(
811         uint256 _setTokenSupply,
812         uint256 _preTotalNotional,
813         uint256 _postTotalNotional,
814         uint256 _prePositionUnit
815     )
816         internal
817         pure
818         returns (uint256)
819     {
820         // If pre action total notional amount is greater then subtract post action total notional and calculate new position units
821         if (_preTotalNotional >= _postTotalNotional) {
822             uint256 unitsToSub = _preTotalNotional.sub(_postTotalNotional).preciseDivCeil(_setTokenSupply);
823             return _prePositionUnit.sub(unitsToSub);
824         } else {
825             // Else subtract post action total notional from pre action total notional and calculate new position units
826             uint256 unitsToAdd = _postTotalNotional.sub(_preTotalNotional).preciseDiv(_setTokenSupply);
827             return _prePositionUnit.add(unitsToAdd);
828         }
829     }
830 }
831 
832 // Dependency file: contracts/interfaces/ISetToken.sol
833 
834 /*
835     Copyright 2020 Set Labs Inc.
836 
837     Licensed under the Apache License, Version 2.0 (the "License");
838     you may not use this file except in compliance with the License.
839     You may obtain a copy of the License at
840 
841     http://www.apache.org/licenses/LICENSE-2.0
842 
843     Unless required by applicable law or agreed to in writing, software
844     distributed under the License is distributed on an "AS IS" BASIS,
845     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
846     See the License for the specific language governing permissions and
847     limitations under the License.
848 
849 
850 */
851 // pragma solidity 0.6.10;
852 // pragma experimental "ABIEncoderV2";
853 
854 // import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
855 
856 /**
857  * @title ISetToken
858  * @author Set Protocol
859  *
860  * Interface for operating with SetTokens.
861  */
862 interface ISetToken is IERC20 {
863 
864     /* ============ Enums ============ */
865 
866     enum ModuleState {
867         NONE,
868         PENDING,
869         INITIALIZED
870     }
871 
872     /* ============ Structs ============ */
873     /**
874      * The base definition of a SetToken Position
875      *
876      * @param component           Address of token in the Position
877      * @param module              If not in default state, the address of associated module
878      * @param unit                Each unit is the # of components per 10^18 of a SetToken
879      * @param positionState       Position ENUM. Default is 0; External is 1
880      * @param data                Arbitrary data
881      */
882     struct Position {
883         address component;
884         address module;
885         int256 unit;
886         uint8 positionState;
887         bytes data;
888     }
889 
890     /**
891      * A struct that stores a component's cash position details and external positions
892      * This data structure allows O(1) access to a component's cash position units and 
893      * virtual units.
894      *
895      * @param virtualUnit               Virtual value of a component's DEFAULT position. Stored as virtual for efficiency
896      *                                  updating all units at once via the position multiplier. Virtual units are achieved
897      *                                  by dividing a "real" value by the "positionMultiplier"
898      * @param componentIndex            
899      * @param externalPositionModules   List of external modules attached to each external position. Each module
900      *                                  maps to an external position
901      * @param externalPositions         Mapping of module => ExternalPosition struct for a given component
902      */
903     struct ComponentPosition {
904       int256 virtualUnit;
905       address[] externalPositionModules;
906       mapping(address => ExternalPosition) externalPositions;
907     }
908 
909     /**
910      * A struct that stores a component's external position details including virtual unit and any
911      * auxiliary data.
912      *
913      * @param virtualUnit       Virtual value of a component's EXTERNAL position.
914      * @param data              Arbitrary data
915      */
916     struct ExternalPosition {
917       int256 virtualUnit;
918       bytes data;
919     }
920 
921 
922     /* ============ Functions ============ */
923     
924     function addComponent(address _component) external;
925     function removeComponent(address _component) external;
926     function editDefaultPositionUnit(address _component, int256 _realUnit) external;
927     function addExternalPositionModule(address _component, address _positionModule) external;
928     function removeExternalPositionModule(address _component, address _positionModule) external;
929     function editExternalPositionUnit(address _component, address _positionModule, int256 _realUnit) external;
930     function editExternalPositionData(address _component, address _positionModule, bytes calldata _data) external;
931 
932     function invoke(address _target, uint256 _value, bytes calldata _data) external returns(bytes memory);
933 
934     function editPositionMultiplier(int256 _newMultiplier) external;
935 
936     function mint(address _account, uint256 _quantity) external;
937     function burn(address _account, uint256 _quantity) external;
938 
939     function lock() external;
940     function unlock() external;
941 
942     function addModule(address _module) external;
943     function removeModule(address _module) external;
944     function initializeModule() external;
945 
946     function setManager(address _manager) external;
947 
948     function manager() external view returns (address);
949     function moduleStates(address _module) external view returns (ModuleState);
950     function getModules() external view returns (address[] memory);
951     
952     function getDefaultPositionRealUnit(address _component) external view returns(int256);
953     function getExternalPositionRealUnit(address _component, address _positionModule) external view returns(int256);
954     function getComponents() external view returns(address[] memory);
955     function getExternalPositionModules(address _component) external view returns(address[] memory);
956     function getExternalPositionData(address _component, address _positionModule) external view returns(bytes memory);
957     function isExternalPositionModule(address _component, address _module) external view returns(bool);
958     function isComponent(address _component) external view returns(bool);
959     
960     function positionMultiplier() external view returns (int256);
961     function getPositions() external view returns (Position[] memory);
962     function getTotalComponentRealUnits(address _component) external view returns(int256);
963 
964     function isInitializedModule(address _module) external view returns(bool);
965     function isPendingModule(address _module) external view returns(bool);
966     function isLocked() external view returns (bool);
967 }
968 // Dependency file: contracts/interfaces/IModule.sol
969 
970 /*
971     Copyright 2020 Set Labs Inc.
972 
973     Licensed under the Apache License, Version 2.0 (the "License");
974     you may not use this file except in compliance with the License.
975     You may obtain a copy of the License at
976 
977     http://www.apache.org/licenses/LICENSE-2.0
978 
979     Unless required by applicable law or agreed to in writing, software
980     distributed under the License is distributed on an "AS IS" BASIS,
981     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
982     See the License for the specific language governing permissions and
983     limitations under the License.
984 
985 
986 */
987 // pragma solidity 0.6.10;
988 
989 
990 /**
991  * @title IModule
992  * @author Set Protocol
993  *
994  * Interface for interacting with Modules.
995  */
996 interface IModule {
997     /**
998      * Called by a SetToken to notify that this module was removed from the Set token. Any logic can be included
999      * in case checks need to be made or state needs to be cleared.
1000      */
1001     function removeModule() external;
1002 }
1003 // Dependency file: contracts/interfaces/IController.sol
1004 
1005 /*
1006     Copyright 2020 Set Labs Inc.
1007 
1008     Licensed under the Apache License, Version 2.0 (the "License");
1009     you may not use this file except in compliance with the License.
1010     You may obtain a copy of the License at
1011 
1012     http://www.apache.org/licenses/LICENSE-2.0
1013 
1014     Unless required by applicable law or agreed to in writing, software
1015     distributed under the License is distributed on an "AS IS" BASIS,
1016     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1017     See the License for the specific language governing permissions and
1018     limitations under the License.
1019 
1020 
1021 */
1022 // pragma solidity 0.6.10;
1023 
1024 interface IController {
1025     function addSet(address _setToken) external;
1026     function getModuleFee(address _module, uint256 _feeType) external view returns(uint256);
1027     function resourceId(uint256 _id) external view returns(address);
1028     function feeRecipient() external view returns(address);
1029     function isModule(address _module) external view returns(bool);
1030     function isSet(address _setToken) external view returns(bool);
1031     function isSystemContract(address _contractAddress) external view returns (bool);
1032 }
1033 // Dependency file: @openzeppelin/contracts/math/SignedSafeMath.sol
1034 
1035 
1036 
1037 // pragma solidity ^0.6.0;
1038 
1039 /**
1040  * @title SignedSafeMath
1041  * @dev Signed math operations with safety checks that revert on error.
1042  */
1043 library SignedSafeMath {
1044     int256 constant private _INT256_MIN = -2**255;
1045 
1046         /**
1047      * @dev Returns the multiplication of two signed integers, reverting on
1048      * overflow.
1049      *
1050      * Counterpart to Solidity's `*` operator.
1051      *
1052      * Requirements:
1053      *
1054      * - Multiplication cannot overflow.
1055      */
1056     function mul(int256 a, int256 b) internal pure returns (int256) {
1057         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1058         // benefit is lost if 'b' is also tested.
1059         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1060         if (a == 0) {
1061             return 0;
1062         }
1063 
1064         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
1065 
1066         int256 c = a * b;
1067         require(c / a == b, "SignedSafeMath: multiplication overflow");
1068 
1069         return c;
1070     }
1071 
1072     /**
1073      * @dev Returns the integer division of two signed integers. Reverts on
1074      * division by zero. The result is rounded towards zero.
1075      *
1076      * Counterpart to Solidity's `/` operator. Note: this function uses a
1077      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1078      * uses an invalid opcode to revert (consuming all remaining gas).
1079      *
1080      * Requirements:
1081      *
1082      * - The divisor cannot be zero.
1083      */
1084     function div(int256 a, int256 b) internal pure returns (int256) {
1085         require(b != 0, "SignedSafeMath: division by zero");
1086         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
1087 
1088         int256 c = a / b;
1089 
1090         return c;
1091     }
1092 
1093     /**
1094      * @dev Returns the subtraction of two signed integers, reverting on
1095      * overflow.
1096      *
1097      * Counterpart to Solidity's `-` operator.
1098      *
1099      * Requirements:
1100      *
1101      * - Subtraction cannot overflow.
1102      */
1103     function sub(int256 a, int256 b) internal pure returns (int256) {
1104         int256 c = a - b;
1105         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
1106 
1107         return c;
1108     }
1109 
1110     /**
1111      * @dev Returns the addition of two signed integers, reverting on
1112      * overflow.
1113      *
1114      * Counterpart to Solidity's `+` operator.
1115      *
1116      * Requirements:
1117      *
1118      * - Addition cannot overflow.
1119      */
1120     function add(int256 a, int256 b) internal pure returns (int256) {
1121         int256 c = a + b;
1122         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
1123 
1124         return c;
1125     }
1126 }
1127 
1128 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
1129 
1130 
1131 
1132 // pragma solidity ^0.6.0;
1133 
1134 /**
1135  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1136  * checks.
1137  *
1138  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1139  * in bugs, because programmers usually assume that an overflow raises an
1140  * error, which is the standard behavior in high level programming languages.
1141  * `SafeMath` restores this intuition by reverting the transaction when an
1142  * operation overflows.
1143  *
1144  * Using this library instead of the unchecked operations eliminates an entire
1145  * class of bugs, so it's recommended to use it always.
1146  */
1147 library SafeMath {
1148     /**
1149      * @dev Returns the addition of two unsigned integers, reverting on
1150      * overflow.
1151      *
1152      * Counterpart to Solidity's `+` operator.
1153      *
1154      * Requirements:
1155      *
1156      * - Addition cannot overflow.
1157      */
1158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1159         uint256 c = a + b;
1160         require(c >= a, "SafeMath: addition overflow");
1161 
1162         return c;
1163     }
1164 
1165     /**
1166      * @dev Returns the subtraction of two unsigned integers, reverting on
1167      * overflow (when the result is negative).
1168      *
1169      * Counterpart to Solidity's `-` operator.
1170      *
1171      * Requirements:
1172      *
1173      * - Subtraction cannot overflow.
1174      */
1175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1176         return sub(a, b, "SafeMath: subtraction overflow");
1177     }
1178 
1179     /**
1180      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1181      * overflow (when the result is negative).
1182      *
1183      * Counterpart to Solidity's `-` operator.
1184      *
1185      * Requirements:
1186      *
1187      * - Subtraction cannot overflow.
1188      */
1189     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1190         require(b <= a, errorMessage);
1191         uint256 c = a - b;
1192 
1193         return c;
1194     }
1195 
1196     /**
1197      * @dev Returns the multiplication of two unsigned integers, reverting on
1198      * overflow.
1199      *
1200      * Counterpart to Solidity's `*` operator.
1201      *
1202      * Requirements:
1203      *
1204      * - Multiplication cannot overflow.
1205      */
1206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1207         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1208         // benefit is lost if 'b' is also tested.
1209         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1210         if (a == 0) {
1211             return 0;
1212         }
1213 
1214         uint256 c = a * b;
1215         require(c / a == b, "SafeMath: multiplication overflow");
1216 
1217         return c;
1218     }
1219 
1220     /**
1221      * @dev Returns the integer division of two unsigned integers. Reverts on
1222      * division by zero. The result is rounded towards zero.
1223      *
1224      * Counterpart to Solidity's `/` operator. Note: this function uses a
1225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1226      * uses an invalid opcode to revert (consuming all remaining gas).
1227      *
1228      * Requirements:
1229      *
1230      * - The divisor cannot be zero.
1231      */
1232     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1233         return div(a, b, "SafeMath: division by zero");
1234     }
1235 
1236     /**
1237      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1238      * division by zero. The result is rounded towards zero.
1239      *
1240      * Counterpart to Solidity's `/` operator. Note: this function uses a
1241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1242      * uses an invalid opcode to revert (consuming all remaining gas).
1243      *
1244      * Requirements:
1245      *
1246      * - The divisor cannot be zero.
1247      */
1248     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1249         require(b > 0, errorMessage);
1250         uint256 c = a / b;
1251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1252 
1253         return c;
1254     }
1255 
1256     /**
1257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1258      * Reverts when dividing by zero.
1259      *
1260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1261      * opcode (which leaves remaining gas untouched) while Solidity uses an
1262      * invalid opcode to revert (consuming all remaining gas).
1263      *
1264      * Requirements:
1265      *
1266      * - The divisor cannot be zero.
1267      */
1268     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1269         return mod(a, b, "SafeMath: modulo by zero");
1270     }
1271 
1272     /**
1273      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1274      * Reverts with custom message when dividing by zero.
1275      *
1276      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1277      * opcode (which leaves remaining gas untouched) while Solidity uses an
1278      * invalid opcode to revert (consuming all remaining gas).
1279      *
1280      * Requirements:
1281      *
1282      * - The divisor cannot be zero.
1283      */
1284     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1285         require(b != 0, errorMessage);
1286         return a % b;
1287     }
1288 }
1289 
1290 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
1291 
1292 
1293 
1294 // pragma solidity ^0.6.0;
1295 
1296 // import "../../GSN/Context.sol";
1297 // import "./IERC20.sol";
1298 // import "../../math/SafeMath.sol";
1299 // import "../../utils/Address.sol";
1300 
1301 /**
1302  * @dev Implementation of the {IERC20} interface.
1303  *
1304  * This implementation is agnostic to the way tokens are created. This means
1305  * that a supply mechanism has to be added in a derived contract using {_mint}.
1306  * For a generic mechanism see {ERC20PresetMinterPauser}.
1307  *
1308  * TIP: For a detailed writeup see our guide
1309  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1310  * to implement supply mechanisms].
1311  *
1312  * We have followed general OpenZeppelin guidelines: functions revert instead
1313  * of returning `false` on failure. This behavior is nonetheless conventional
1314  * and does not conflict with the expectations of ERC20 applications.
1315  *
1316  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1317  * This allows applications to reconstruct the allowance for all accounts just
1318  * by listening to said events. Other implementations of the EIP may not emit
1319  * these events, as it isn't required by the specification.
1320  *
1321  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1322  * functions have been added to mitigate the well-known issues around setting
1323  * allowances. See {IERC20-approve}.
1324  */
1325 contract ERC20 is Context, IERC20 {
1326     using SafeMath for uint256;
1327     using Address for address;
1328 
1329     mapping (address => uint256) private _balances;
1330 
1331     mapping (address => mapping (address => uint256)) private _allowances;
1332 
1333     uint256 private _totalSupply;
1334 
1335     string private _name;
1336     string private _symbol;
1337     uint8 private _decimals;
1338 
1339     /**
1340      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1341      * a default value of 18.
1342      *
1343      * To select a different value for {decimals}, use {_setupDecimals}.
1344      *
1345      * All three of these values are immutable: they can only be set once during
1346      * construction.
1347      */
1348     constructor (string memory name, string memory symbol) public {
1349         _name = name;
1350         _symbol = symbol;
1351         _decimals = 18;
1352     }
1353 
1354     /**
1355      * @dev Returns the name of the token.
1356      */
1357     function name() public view returns (string memory) {
1358         return _name;
1359     }
1360 
1361     /**
1362      * @dev Returns the symbol of the token, usually a shorter version of the
1363      * name.
1364      */
1365     function symbol() public view returns (string memory) {
1366         return _symbol;
1367     }
1368 
1369     /**
1370      * @dev Returns the number of decimals used to get its user representation.
1371      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1372      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1373      *
1374      * Tokens usually opt for a value of 18, imitating the relationship between
1375      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1376      * called.
1377      *
1378      * NOTE: This information is only used for _display_ purposes: it in
1379      * no way affects any of the arithmetic of the contract, including
1380      * {IERC20-balanceOf} and {IERC20-transfer}.
1381      */
1382     function decimals() public view returns (uint8) {
1383         return _decimals;
1384     }
1385 
1386     /**
1387      * @dev See {IERC20-totalSupply}.
1388      */
1389     function totalSupply() public view override returns (uint256) {
1390         return _totalSupply;
1391     }
1392 
1393     /**
1394      * @dev See {IERC20-balanceOf}.
1395      */
1396     function balanceOf(address account) public view override returns (uint256) {
1397         return _balances[account];
1398     }
1399 
1400     /**
1401      * @dev See {IERC20-transfer}.
1402      *
1403      * Requirements:
1404      *
1405      * - `recipient` cannot be the zero address.
1406      * - the caller must have a balance of at least `amount`.
1407      */
1408     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1409         _transfer(_msgSender(), recipient, amount);
1410         return true;
1411     }
1412 
1413     /**
1414      * @dev See {IERC20-allowance}.
1415      */
1416     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1417         return _allowances[owner][spender];
1418     }
1419 
1420     /**
1421      * @dev See {IERC20-approve}.
1422      *
1423      * Requirements:
1424      *
1425      * - `spender` cannot be the zero address.
1426      */
1427     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1428         _approve(_msgSender(), spender, amount);
1429         return true;
1430     }
1431 
1432     /**
1433      * @dev See {IERC20-transferFrom}.
1434      *
1435      * Emits an {Approval} event indicating the updated allowance. This is not
1436      * required by the EIP. See the note at the beginning of {ERC20};
1437      *
1438      * Requirements:
1439      * - `sender` and `recipient` cannot be the zero address.
1440      * - `sender` must have a balance of at least `amount`.
1441      * - the caller must have allowance for ``sender``'s tokens of at least
1442      * `amount`.
1443      */
1444     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1445         _transfer(sender, recipient, amount);
1446         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1447         return true;
1448     }
1449 
1450     /**
1451      * @dev Atomically increases the allowance granted to `spender` by the caller.
1452      *
1453      * This is an alternative to {approve} that can be used as a mitigation for
1454      * problems described in {IERC20-approve}.
1455      *
1456      * Emits an {Approval} event indicating the updated allowance.
1457      *
1458      * Requirements:
1459      *
1460      * - `spender` cannot be the zero address.
1461      */
1462     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1463         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1464         return true;
1465     }
1466 
1467     /**
1468      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1469      *
1470      * This is an alternative to {approve} that can be used as a mitigation for
1471      * problems described in {IERC20-approve}.
1472      *
1473      * Emits an {Approval} event indicating the updated allowance.
1474      *
1475      * Requirements:
1476      *
1477      * - `spender` cannot be the zero address.
1478      * - `spender` must have allowance for the caller of at least
1479      * `subtractedValue`.
1480      */
1481     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1483         return true;
1484     }
1485 
1486     /**
1487      * @dev Moves tokens `amount` from `sender` to `recipient`.
1488      *
1489      * This is internal function is equivalent to {transfer}, and can be used to
1490      * e.g. implement automatic token fees, slashing mechanisms, etc.
1491      *
1492      * Emits a {Transfer} event.
1493      *
1494      * Requirements:
1495      *
1496      * - `sender` cannot be the zero address.
1497      * - `recipient` cannot be the zero address.
1498      * - `sender` must have a balance of at least `amount`.
1499      */
1500     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1501         require(sender != address(0), "ERC20: transfer from the zero address");
1502         require(recipient != address(0), "ERC20: transfer to the zero address");
1503 
1504         _beforeTokenTransfer(sender, recipient, amount);
1505 
1506         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1507         _balances[recipient] = _balances[recipient].add(amount);
1508         emit Transfer(sender, recipient, amount);
1509     }
1510 
1511     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1512      * the total supply.
1513      *
1514      * Emits a {Transfer} event with `from` set to the zero address.
1515      *
1516      * Requirements
1517      *
1518      * - `to` cannot be the zero address.
1519      */
1520     function _mint(address account, uint256 amount) internal virtual {
1521         require(account != address(0), "ERC20: mint to the zero address");
1522 
1523         _beforeTokenTransfer(address(0), account, amount);
1524 
1525         _totalSupply = _totalSupply.add(amount);
1526         _balances[account] = _balances[account].add(amount);
1527         emit Transfer(address(0), account, amount);
1528     }
1529 
1530     /**
1531      * @dev Destroys `amount` tokens from `account`, reducing the
1532      * total supply.
1533      *
1534      * Emits a {Transfer} event with `to` set to the zero address.
1535      *
1536      * Requirements
1537      *
1538      * - `account` cannot be the zero address.
1539      * - `account` must have at least `amount` tokens.
1540      */
1541     function _burn(address account, uint256 amount) internal virtual {
1542         require(account != address(0), "ERC20: burn from the zero address");
1543 
1544         _beforeTokenTransfer(account, address(0), amount);
1545 
1546         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1547         _totalSupply = _totalSupply.sub(amount);
1548         emit Transfer(account, address(0), amount);
1549     }
1550 
1551     /**
1552      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1553      *
1554      * This is internal function is equivalent to `approve`, and can be used to
1555      * e.g. set automatic allowances for certain subsystems, etc.
1556      *
1557      * Emits an {Approval} event.
1558      *
1559      * Requirements:
1560      *
1561      * - `owner` cannot be the zero address.
1562      * - `spender` cannot be the zero address.
1563      */
1564     function _approve(address owner, address spender, uint256 amount) internal virtual {
1565         require(owner != address(0), "ERC20: approve from the zero address");
1566         require(spender != address(0), "ERC20: approve to the zero address");
1567 
1568         _allowances[owner][spender] = amount;
1569         emit Approval(owner, spender, amount);
1570     }
1571 
1572     /**
1573      * @dev Sets {decimals} to a value other than the default one of 18.
1574      *
1575      * WARNING: This function should only be called from the constructor. Most
1576      * applications that interact with token contracts will not expect
1577      * {decimals} to ever change, and may work incorrectly if it does.
1578      */
1579     function _setupDecimals(uint8 decimals_) internal {
1580         _decimals = decimals_;
1581     }
1582 
1583     /**
1584      * @dev Hook that is called before any transfer of tokens. This includes
1585      * minting and burning.
1586      *
1587      * Calling conditions:
1588      *
1589      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1590      * will be to transferred to `to`.
1591      * - when `from` is zero, `amount` tokens will be minted for `to`.
1592      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1593      * - `from` and `to` are never both zero.
1594      *
1595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1596      */
1597     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1598 }
1599 
1600 // Dependency file: @openzeppelin/contracts/utils/Address.sol
1601 
1602 
1603 
1604 // pragma solidity ^0.6.2;
1605 
1606 /**
1607  * @dev Collection of functions related to the address type
1608  */
1609 library Address {
1610     /**
1611      * @dev Returns true if `account` is a contract.
1612      *
1613      * [// importANT]
1614      * ====
1615      * It is unsafe to assume that an address for which this function returns
1616      * false is an externally-owned account (EOA) and not a contract.
1617      *
1618      * Among others, `isContract` will return false for the following
1619      * types of addresses:
1620      *
1621      *  - an externally-owned account
1622      *  - a contract in construction
1623      *  - an address where a contract will be created
1624      *  - an address where a contract lived, but was destroyed
1625      * ====
1626      */
1627     function isContract(address account) internal view returns (bool) {
1628         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1629         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1630         // for accounts without code, i.e. `keccak256('')`
1631         bytes32 codehash;
1632         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1633         // solhint-disable-next-line no-inline-assembly
1634         assembly { codehash := extcodehash(account) }
1635         return (codehash != accountHash && codehash != 0x0);
1636     }
1637 
1638     /**
1639      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1640      * `recipient`, forwarding all available gas and reverting on errors.
1641      *
1642      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1643      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1644      * imposed by `transfer`, making them unable to receive funds via
1645      * `transfer`. {sendValue} removes this limitation.
1646      *
1647      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1648      *
1649      * // importANT: because control is transferred to `recipient`, care must be
1650      * taken to not create reentrancy vulnerabilities. Consider using
1651      * {ReentrancyGuard} or the
1652      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1653      */
1654     function sendValue(address payable recipient, uint256 amount) internal {
1655         require(address(this).balance >= amount, "Address: insufficient balance");
1656 
1657         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1658         (bool success, ) = recipient.call{ value: amount }("");
1659         require(success, "Address: unable to send value, recipient may have reverted");
1660     }
1661 
1662     /**
1663      * @dev Performs a Solidity function call using a low level `call`. A
1664      * plain`call` is an unsafe replacement for a function call: use this
1665      * function instead.
1666      *
1667      * If `target` reverts with a revert reason, it is bubbled up by this
1668      * function (like regular Solidity function calls).
1669      *
1670      * Returns the raw returned data. To convert to the expected return value,
1671      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1672      *
1673      * Requirements:
1674      *
1675      * - `target` must be a contract.
1676      * - calling `target` with `data` must not revert.
1677      *
1678      * _Available since v3.1._
1679      */
1680     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1681       return functionCall(target, data, "Address: low-level call failed");
1682     }
1683 
1684     /**
1685      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1686      * `errorMessage` as a fallback revert reason when `target` reverts.
1687      *
1688      * _Available since v3.1._
1689      */
1690     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1691         return _functionCallWithValue(target, data, 0, errorMessage);
1692     }
1693 
1694     /**
1695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1696      * but also transferring `value` wei to `target`.
1697      *
1698      * Requirements:
1699      *
1700      * - the calling contract must have an ETH balance of at least `value`.
1701      * - the called Solidity function must be `payable`.
1702      *
1703      * _Available since v3.1._
1704      */
1705     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1706         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1707     }
1708 
1709     /**
1710      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1711      * with `errorMessage` as a fallback revert reason when `target` reverts.
1712      *
1713      * _Available since v3.1._
1714      */
1715     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1716         require(address(this).balance >= value, "Address: insufficient balance for call");
1717         return _functionCallWithValue(target, data, value, errorMessage);
1718     }
1719 
1720     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
1721         require(isContract(target), "Address: call to non-contract");
1722 
1723         // solhint-disable-next-line avoid-low-level-calls
1724         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
1725         if (success) {
1726             return returndata;
1727         } else {
1728             // Look for revert reason and bubble it up if present
1729             if (returndata.length > 0) {
1730                 // The easiest way to bubble the revert reason is using memory via assembly
1731 
1732                 // solhint-disable-next-line no-inline-assembly
1733                 assembly {
1734                     let returndata_size := mload(returndata)
1735                     revert(add(32, returndata), returndata_size)
1736                 }
1737             } else {
1738                 revert(errorMessage);
1739             }
1740         }
1741     }
1742 }
1743 
1744 /*
1745     Copyright 2020 Set Labs Inc.
1746 
1747     Licensed under the Apache License, Version 2.0 (the "License");
1748     you may not use this file except in compliance with the License.
1749     You may obtain a copy of the License at
1750 
1751     http://www.apache.org/licenses/LICENSE-2.0
1752 
1753     Unless required by applicable law or agreed to in writing, software
1754     distributed under the License is distributed on an "AS IS" BASIS,
1755     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1756     See the License for the specific language governing permissions and
1757     limitations under the License.
1758 
1759 
1760 */
1761 
1762 pragma solidity 0.6.10;
1763 pragma experimental "ABIEncoderV2";
1764 
1765 // import { Address } from "@openzeppelin/contracts/utils/Address.sol";
1766 // import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
1767 // import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
1768 // import { SignedSafeMath } from "@openzeppelin/contracts/math/SignedSafeMath.sol";
1769 
1770 // import { IController } from "../interfaces/IController.sol";
1771 // import { IModule } from "../interfaces/IModule.sol";
1772 // import { ISetToken } from "../interfaces/ISetToken.sol";
1773 // import { Position } from "./lib/Position.sol";
1774 // import { PreciseUnitMath } from "../lib/PreciseUnitMath.sol";
1775 // import { AddressArrayUtils } from "../lib/AddressArrayUtils.sol";
1776 
1777 
1778 /**
1779  * @title SetToken
1780  * @author Set Protocol
1781  *
1782  * ERC20 Token contract that allows privileged modules to make modifications to its positions and invoke function calls
1783  * from the SetToken. 
1784  */
1785 contract SetToken is ERC20 {
1786     using SafeMath for uint256;
1787     using SignedSafeMath for int256;
1788     using PreciseUnitMath for int256;
1789     using Address for address;
1790     using AddressArrayUtils for address[];
1791 
1792     /* ============ Constants ============ */
1793 
1794     /*
1795         The PositionState is the status of the Position, whether it is Default (held on the SetToken)
1796         or otherwise held on a separate smart contract (whether a module or external source).
1797         There are issues with cross-usage of enums, so we are defining position states
1798         as a uint8.
1799     */
1800     uint8 internal constant DEFAULT = 0;
1801     uint8 internal constant EXTERNAL = 1;
1802 
1803     /* ============ Events ============ */
1804 
1805     event Invoked(address indexed _target, uint indexed _value, bytes _data, bytes _returnValue);
1806     event ModuleAdded(address indexed _module);
1807     event ModuleRemoved(address indexed _module);    
1808     event ModuleInitialized(address indexed _module);
1809     event ManagerEdited(address _newManager, address _oldManager);
1810     event PendingModuleRemoved(address indexed _module);
1811     event PositionMultiplierEdited(int256 _newMultiplier);
1812     event ComponentAdded(address indexed _component);
1813     event ComponentRemoved(address indexed _component);
1814     event DefaultPositionUnitEdited(address indexed _component, int256 _realUnit);
1815     event ExternalPositionUnitEdited(address indexed _component, address indexed _positionModule, int256 _realUnit);
1816     event ExternalPositionDataEdited(address indexed _component, address indexed _positionModule, bytes _data);
1817     event PositionModuleAdded(address indexed _component, address indexed _positionModule);
1818     event PositionModuleRemoved(address indexed _component, address indexed _positionModule);
1819 
1820     /* ============ Modifiers ============ */
1821 
1822     /**
1823      * Throws if the sender is not a SetToken's module or module not enabled
1824      */
1825     modifier onlyModule() {
1826         // Internal function used to reduce bytecode size
1827         _validateOnlyModule();
1828         _;
1829     }
1830 
1831     /**
1832      * Throws if the sender is not the SetToken's manager
1833      */
1834     modifier onlyManager() {
1835         _validateOnlyManager();
1836         _;
1837     }
1838 
1839     /**
1840      * Throws if SetToken is locked and called by any account other than the locker.
1841      */
1842     modifier whenLockedOnlyLocker() {
1843         _validateWhenLockedOnlyLocker();
1844         _;
1845     }
1846 
1847     /* ============ State Variables ============ */
1848 
1849     // Address of the controller
1850     IController public controller;
1851 
1852     // The manager has the privelege to add modules, remove, and set a new manager
1853     address public manager;
1854 
1855     // A module that has locked other modules from privileged functionality, typically required
1856     // for multi-block module actions such as auctions
1857     address public locker;
1858 
1859     // List of initialized Modules; Modules extend the functionality of SetTokens
1860     address[] public modules;
1861 
1862     // Modules are initialized from NONE -> PENDING -> INITIALIZED through the
1863     // addModule (called by manager) and initialize  (called by module) functions
1864     mapping(address => ISetToken.ModuleState) public moduleStates;
1865 
1866     // When locked, only the locker (a module) can call privileged functionality
1867     // Typically utilized if a module (e.g. Auction) needs multiple transactions to complete an action
1868     // without interruption
1869     bool public isLocked;
1870 
1871     // List of components
1872     address[] public components;
1873 
1874     // Mapping that stores all Default and External position information for a given component.
1875     // Position quantities are represented as virtual units; Default positions are on the top-level,
1876     // while external positions are stored in a module array and accessed through its externalPositions mapping
1877     mapping(address => ISetToken.ComponentPosition) private componentPositions;
1878 
1879     // The multiplier applied to the virtual position unit to achieve the real/actual unit.
1880     // This multiplier is used for efficiently modifying the entire position units (e.g. streaming fee)
1881     int256 public positionMultiplier;
1882 
1883 
1884     /* ============ Constructor ============ */
1885 
1886     /**
1887      * When a new SetToken is created, initializes Positions in default state and adds modules into pending state.
1888      * All parameter validations are on the SetTokenCreator contract. Validations are performed already on the 
1889      * SetTokenCreator. Initiates the positionMultiplier as 1e18 (no adjustments).
1890      *
1891      * @param _components             List of addresses of components for initial Positions
1892      * @param _units                  List of units. Each unit is the # of components per 10^18 of a SetToken
1893      * @param _modules                List of modules to enable. All modules must be approved by the Controller
1894      * @param _controller             Address of the controller
1895      * @param _manager                Address of the manager
1896      * @param _name                   Name of the SetToken
1897      * @param _symbol                 Symbol of the SetToken
1898      */
1899     constructor(
1900         address[] memory _components,
1901         int256[] memory _units,
1902         address[] memory _modules,
1903         IController _controller,
1904         address _manager,
1905         string memory _name,
1906         string memory _symbol
1907     )
1908         public
1909         ERC20(_name, _symbol)
1910     {
1911         controller = _controller;
1912         manager = _manager;
1913         positionMultiplier = PreciseUnitMath.preciseUnitInt();
1914         components = _components;
1915 
1916         // Modules are put in PENDING state, as they need to be individually initialized by the Module
1917         for (uint256 i = 0; i < _modules.length; i++) {
1918             moduleStates[_modules[i]] = ISetToken.ModuleState.PENDING;
1919         }
1920 
1921         // Positions are put in default state initially
1922         for (uint256 j = 0; j < _components.length; j++) {
1923             componentPositions[_components[j]].virtualUnit = _units[j];
1924         }
1925     }
1926 
1927     /* ============ External Functions ============ */
1928 
1929     /**
1930      * PRIVELEGED MODULE FUNCTION. Low level function that allows a module to make an arbitrary function
1931      * call to any contract.
1932      *
1933      * @param _target                 Address of the smart contract to call
1934      * @param _value                  Quantity of Ether to provide the call (typically 0)
1935      * @param _data                   Encoded function selector and arguments
1936      * @return _returnValue           Bytes encoded return value
1937      */
1938     function invoke(
1939         address _target,
1940         uint256 _value,
1941         bytes calldata _data
1942     )
1943         external
1944         onlyModule
1945         whenLockedOnlyLocker
1946         returns (bytes memory _returnValue)
1947     {
1948         _returnValue = _target.functionCallWithValue(_data, _value);
1949 
1950         emit Invoked(_target, _value, _data, _returnValue);
1951 
1952         return _returnValue;
1953     }
1954 
1955     /**
1956      * PRIVELEGED MODULE FUNCTION. Low level function that adds a component to the components array.
1957      */
1958     function addComponent(address _component) external onlyModule whenLockedOnlyLocker {
1959         components.push(_component);
1960 
1961         emit ComponentAdded(_component);
1962     }
1963 
1964     /**
1965      * PRIVELEGED MODULE FUNCTION. Low level function that removes a component from the components array.
1966      */
1967     function removeComponent(address _component) external onlyModule whenLockedOnlyLocker {
1968         components = components.remove(_component);
1969 
1970         emit ComponentRemoved(_component);
1971     }
1972 
1973     /**
1974      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's virtual unit. Takes a real unit
1975      * and converts it to virtual before committing.
1976      */
1977     function editDefaultPositionUnit(address _component, int256 _realUnit) external onlyModule whenLockedOnlyLocker {
1978         int256 virtualUnit = _convertRealToVirtualUnit(_realUnit);
1979 
1980         // These checks ensure that the virtual unit does not return a result that has rounded down to 0
1981         if (_realUnit > 0 && virtualUnit == 0) {
1982             revert("Virtual unit conversion invalid");
1983         }
1984 
1985         componentPositions[_component].virtualUnit = virtualUnit;
1986 
1987         emit DefaultPositionUnitEdited(_component, _realUnit);
1988     }
1989 
1990     /**
1991      * PRIVELEGED MODULE FUNCTION. Low level function that adds a module to a component's externalPositionModules array
1992      */
1993     function addExternalPositionModule(address _component, address _positionModule) external onlyModule whenLockedOnlyLocker {
1994         componentPositions[_component].externalPositionModules.push(_positionModule);
1995 
1996         emit PositionModuleAdded(_component, _positionModule);
1997     }
1998 
1999     /**
2000      * PRIVELEGED MODULE FUNCTION. Low level function that removes a module from a component's 
2001      * externalPositionModules array and deletes the associated externalPosition.
2002      */
2003     function removeExternalPositionModule(
2004         address _component,
2005         address _positionModule
2006     )
2007         external
2008         onlyModule
2009         whenLockedOnlyLocker
2010     {
2011         componentPositions[_component].externalPositionModules = _externalPositionModules(_component).remove(_positionModule);
2012         delete componentPositions[_component].externalPositions[_positionModule];
2013 
2014         emit PositionModuleRemoved(_component, _positionModule);
2015     }
2016 
2017     /**
2018      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's external position virtual unit. 
2019      * Takes a real unit and converts it to virtual before committing.
2020      */
2021     function editExternalPositionUnit(
2022         address _component,
2023         address _positionModule,
2024         int256 _realUnit
2025     )
2026         external
2027         onlyModule
2028         whenLockedOnlyLocker
2029     {
2030         int256 virtualUnit = _convertRealToVirtualUnit(_realUnit);
2031 
2032         // These checks ensure that the virtual unit does not return a result that has rounded to 0
2033         if ((_realUnit > 0 && virtualUnit == 0)) {
2034             revert("Virtual unit conversion invalid");
2035         }
2036 
2037         componentPositions[_component].externalPositions[_positionModule].virtualUnit = virtualUnit;
2038 
2039         emit ExternalPositionUnitEdited(_component, _positionModule, _realUnit);
2040     }
2041 
2042     /**
2043      * PRIVELEGED MODULE FUNCTION. Low level function that edits a component's external position data
2044      */
2045     function editExternalPositionData(
2046         address _component,
2047         address _positionModule,
2048         bytes calldata _data
2049     )
2050         external
2051         onlyModule
2052         whenLockedOnlyLocker
2053     {
2054         componentPositions[_component].externalPositions[_positionModule].data = _data;
2055 
2056         emit ExternalPositionDataEdited(_component, _positionModule, _data);
2057     }
2058 
2059     /**
2060      * PRIVELEGED MODULE FUNCTION. Modifies the position multiplier. This is typically used to efficiently
2061      * update all the Positions' units at once in applications where inflation is awarded (e.g. subscription fees).
2062      */
2063     function editPositionMultiplier(int256 _newMultiplier) external onlyModule whenLockedOnlyLocker {
2064         require(_newMultiplier > 0, "Must be greater than 0");
2065 
2066         positionMultiplier = _newMultiplier;
2067 
2068         emit PositionMultiplierEdited(_newMultiplier);
2069     }
2070 
2071     /**
2072      * PRIVELEGED MODULE FUNCTION. Increases the "account" balance by the "quantity".
2073      */
2074     function mint(address _account, uint256 _quantity) external onlyModule whenLockedOnlyLocker {
2075         _mint(_account, _quantity);
2076     }
2077 
2078     /**
2079      * PRIVELEGED MODULE FUNCTION. Decreases the "account" balance by the "quantity".
2080      * _burn checks that the "account" already has the required "quantity".
2081      */
2082     function burn(address _account, uint256 _quantity) external onlyModule whenLockedOnlyLocker {
2083         _burn(_account, _quantity);
2084     }
2085 
2086     /**
2087      * PRIVELEGED MODULE FUNCTION. When a SetToken is locked, only the locker can call privileged functions.
2088      */
2089     function lock() external onlyModule {
2090         require(!isLocked, "Must not be locked");
2091         locker = msg.sender;
2092         isLocked = true;
2093     }
2094 
2095     /**
2096      * PRIVELEGED MODULE FUNCTION. Unlocks the SetToken and clears the locker
2097      */
2098     function unlock() external onlyModule {
2099         require(isLocked, "Must be locked");
2100         require(locker == msg.sender, "Must be locker");
2101         delete locker;
2102         isLocked = false;
2103     }
2104 
2105     /**
2106      * MANAGER ONLY. Adds a module into a PENDING state; Module must later be initialized via 
2107      * module's initialize function
2108      */
2109     function addModule(address _module) external onlyManager {
2110         require(moduleStates[_module] == ISetToken.ModuleState.NONE, "Module must not be added");
2111         require(controller.isModule(_module), "Must be enabled on Controller");
2112 
2113         moduleStates[_module] = ISetToken.ModuleState.PENDING;
2114 
2115         emit ModuleAdded(_module);
2116     }
2117 
2118     /**
2119      * MANAGER ONLY. Removes a module from the SetToken. SetToken calls removeModule on module itself to confirm
2120      * it is not needed to manage any remaining positions and to remove state.
2121      */
2122     function removeModule(address _module) external onlyManager {
2123         require(!isLocked, "Only when unlocked");
2124         require(moduleStates[_module] == ISetToken.ModuleState.INITIALIZED, "Module must be added");
2125 
2126         IModule(_module).removeModule();
2127 
2128         moduleStates[_module] = ISetToken.ModuleState.NONE;
2129 
2130         modules = modules.remove(_module);
2131 
2132         emit ModuleRemoved(_module);
2133     }
2134 
2135     /**
2136      * MANAGER ONLY. Removes a pending module from the SetToken.
2137      */
2138     function removePendingModule(address _module) external onlyManager {
2139         require(!isLocked, "Only when unlocked");
2140         require(moduleStates[_module] == ISetToken.ModuleState.PENDING, "Module must be pending");
2141 
2142         moduleStates[_module] = ISetToken.ModuleState.NONE;
2143 
2144         emit PendingModuleRemoved(_module);
2145     }
2146 
2147     /**
2148      * Initializes an added module from PENDING to INITIALIZED state. Can only call when unlocked.
2149      * An address can only enter a PENDING state if it is an enabled module added by the manager.
2150      * Only callable by the module itself, hence msg.sender is the subject of update.
2151      */
2152     function initializeModule() external {
2153         require(!isLocked, "Only when unlocked");
2154         require(moduleStates[msg.sender] == ISetToken.ModuleState.PENDING, "Module must be pending");
2155         
2156         moduleStates[msg.sender] = ISetToken.ModuleState.INITIALIZED;
2157         modules.push(msg.sender);
2158 
2159         emit ModuleInitialized(msg.sender);
2160     }
2161 
2162     /**
2163      * MANAGER ONLY. Changes manager; We allow null addresses in case the manager wishes to wind down the SetToken.
2164      * Modules may rely on the manager state, so only changable when unlocked
2165      */
2166     function setManager(address _manager) external onlyManager {
2167         require(!isLocked, "Only when unlocked");
2168         address oldManager = manager;
2169         manager = _manager;
2170 
2171         emit ManagerEdited(_manager, oldManager);
2172     }
2173 
2174     /* ============ External Getter Functions ============ */
2175 
2176     function getComponents() external view returns(address[] memory) {
2177         return components;
2178     }
2179 
2180     function getDefaultPositionRealUnit(address _component) public view returns(int256) {
2181         return _convertVirtualToRealUnit(_defaultPositionVirtualUnit(_component));
2182     }
2183 
2184     function getExternalPositionRealUnit(address _component, address _positionModule) public view returns(int256) {
2185         return _convertVirtualToRealUnit(_externalPositionVirtualUnit(_component, _positionModule));
2186     }
2187 
2188     function getExternalPositionModules(address _component) external view returns(address[] memory) {
2189         return _externalPositionModules(_component);
2190     }
2191 
2192     function getExternalPositionData(address _component,address _positionModule) external view returns(bytes memory) {
2193         return _externalPositionData(_component, _positionModule);
2194     }
2195 
2196     function getModules() external view returns (address[] memory) {
2197         return modules;
2198     }
2199 
2200     function isComponent(address _component) external view returns(bool) {
2201         return components.contains(_component);
2202     }
2203 
2204     function isExternalPositionModule(address _component, address _module) external view returns(bool) {
2205         return _externalPositionModules(_component).contains(_module);
2206     }
2207 
2208     /**
2209      * Only ModuleStates of INITIALIZED modules are considered enabled
2210      */
2211     function isInitializedModule(address _module) external view returns (bool) {
2212         return moduleStates[_module] == ISetToken.ModuleState.INITIALIZED;
2213     }
2214 
2215     /**
2216      * Returns whether the module is in a pending state
2217      */
2218     function isPendingModule(address _module) external view returns (bool) {
2219         return moduleStates[_module] == ISetToken.ModuleState.PENDING;
2220     }
2221 
2222     /**
2223      * Returns a list of Positions, through traversing the components. Each component with a non-zero virtual unit
2224      * is considered a Default Position, and each externalPositionModule will generate a unique position.
2225      * Virtual units are converted to real units. This function is typically used off-chain for data presentation purposes.
2226      */
2227     function getPositions() external view returns (ISetToken.Position[] memory) {
2228         ISetToken.Position[] memory positions = new ISetToken.Position[](_getPositionCount());
2229         uint256 positionCount = 0;
2230 
2231         for (uint256 i = 0; i < components.length; i++) {
2232             address component = components[i];
2233 
2234             // A default position exists if the default virtual unit is > 0
2235             if (_defaultPositionVirtualUnit(component) > 0) {
2236                 positions[positionCount] = ISetToken.Position({
2237                     component: component,
2238                     module: address(0),
2239                     unit: getDefaultPositionRealUnit(component),
2240                     positionState: DEFAULT,
2241                     data: ""
2242                 });
2243 
2244                 positionCount++;
2245             }
2246 
2247             address[] memory externalModules = _externalPositionModules(component);
2248             for (uint256 j = 0; j < externalModules.length; j++) {
2249                 address currentModule = externalModules[j];
2250 
2251                 positions[positionCount] = ISetToken.Position({
2252                     component: component,
2253                     module: currentModule,
2254                     unit: getExternalPositionRealUnit(component, currentModule),
2255                     positionState: EXTERNAL,
2256                     data: _externalPositionData(component, currentModule)
2257                 });
2258 
2259                 positionCount++;
2260             }
2261         }
2262 
2263         return positions;
2264     }
2265 
2266     /**
2267      * Returns the total Real Units for a given component, summing the default and external position units.
2268      */
2269     function getTotalComponentRealUnits(address _component) external view returns(int256) {
2270         int256 totalUnits = getDefaultPositionRealUnit(_component);
2271 
2272 		address[] memory externalModules = _externalPositionModules(_component);
2273 		for (uint256 i = 0; i < externalModules.length; i++) {
2274             // We will perform the summation no matter what, as an external position virtual unit can be negative
2275 			totalUnits = totalUnits.add(getExternalPositionRealUnit(_component, externalModules[i]));
2276 		}
2277 
2278 		return totalUnits;
2279     }
2280 
2281 
2282     receive() external payable {} // solium-disable-line quotes
2283 
2284     /* ============ Internal Functions ============ */
2285 
2286     function _defaultPositionVirtualUnit(address _component) internal view returns(int256) {
2287     	return componentPositions[_component].virtualUnit;
2288     }
2289 
2290     function _externalPositionModules(address _component) internal view returns(address[] memory) {
2291     	return componentPositions[_component].externalPositionModules;
2292     }
2293 
2294     function _externalPositionVirtualUnit(address _component, address _module) internal view returns(int256) {
2295     	return componentPositions[_component].externalPositions[_module].virtualUnit;
2296     }
2297 
2298     function _externalPositionData(address _component, address _module) internal view returns(bytes memory) {
2299     	return componentPositions[_component].externalPositions[_module].data;
2300     }
2301 
2302     /**
2303      * Takes a real unit and divides by the position multiplier to return the virtual unit
2304      */
2305     function _convertRealToVirtualUnit(int256 _realUnit) internal view returns(int256) {
2306         return _realUnit.conservativePreciseDiv(positionMultiplier);
2307     }
2308 
2309     /**
2310      * Takes a virtual unit and multiplies by the position multiplier to return the real unit
2311      */
2312     function _convertVirtualToRealUnit(int256 _virtualUnit) internal view returns(int256) {
2313         return _virtualUnit.conservativePreciseMul(positionMultiplier);
2314     }
2315 
2316     /**
2317      * Gets the total number of positions, defined as the following:
2318      * - Each component has a default position if its virtual unit is > 0
2319      * - Each component's external positions module is counted as a position
2320      */
2321     function _getPositionCount() internal view returns (uint256) {
2322         uint256 positionCount;
2323         for (uint256 i = 0; i < components.length; i++) {
2324             address component = components[i];
2325 
2326             // Increment the position count if the default position is > 0
2327             if (_defaultPositionVirtualUnit(component) > 0) {
2328                 positionCount++;
2329             }
2330 
2331             // Increment the position count by each external position module
2332             address[] memory externalModules = _externalPositionModules(component);
2333             if (externalModules.length > 0) {
2334             	positionCount = positionCount.add(externalModules.length);	
2335             }
2336         }
2337 
2338         return positionCount;
2339     }
2340 
2341     /**
2342      * Due to reason error bloat, internal functions are used to reduce bytecode size
2343      *
2344      * Module must be initialized on the SetToken and enabled by the controller
2345      */
2346     function _validateOnlyModule() internal view {
2347         require(
2348             moduleStates[msg.sender] == ISetToken.ModuleState.INITIALIZED,
2349             "Only the module can call"
2350         );
2351 
2352         require(
2353             controller.isModule(msg.sender),
2354             "Module must be enabled on controller"
2355         );
2356     }
2357 
2358     function _validateOnlyManager() internal view {
2359         require(msg.sender == manager, "Only manager can call");
2360     }
2361 
2362     function _validateWhenLockedOnlyLocker() internal view {
2363         if (isLocked) {
2364             require(msg.sender == locker, "When locked, only the locker can call");
2365         }
2366     }
2367 }