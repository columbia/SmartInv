1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 /**
5  * @dev Intended to update the TWAP for a token based on accepting an update call from that token.
6  *  expectation is to have this happen in the _beforeTokenTransfer function of ERC20.
7  *  Provides a method for a token to register its price sourve adaptor.
8  *  Provides a function for a token to register its TWAP updater. Defaults to token itself.
9  *  Provides a function a tokent to set its TWAP epoch.
10  *  Implements automatic closeing and opening up a TWAP epoch when epoch ends.
11  *  Provides a function to report the TWAP from the last epoch when passed a token address.
12  */
13 interface ITWAPOracle {
14 
15   function uniV2CompPairAddressForLastEpochUpdateBlockTimstamp( address ) external returns ( uint32 );
16 
17   function priceTokenAddressForPricingTokenAddressForLastEpochUpdateBlockTimstamp( address tokenToPrice_, address tokenForPriceComparison_, uint epochPeriod_ ) external returns ( uint32 );
18 
19   function pricedTokenForPricingTokenForEpochPeriodForPrice( address, address, uint ) external returns ( uint );
20 
21   function pricedTokenForPricingTokenForEpochPeriodForLastEpochPrice( address, address, uint ) external returns ( uint );
22 
23   function updateTWAP( address uniV2CompatPairAddressToUpdate_, uint eopchPeriodToUpdate_ ) external returns ( bool );
24 }
25 
26 library EnumerableSet {
27 
28   // To implement this library for multiple types with as little code
29   // repetition as possible, we write it in terms of a generic Set type with
30   // bytes32 values.
31   // The Set implementation uses private functions, and user-facing
32   // implementations (such as AddressSet) are just wrappers around the
33   // underlying Set.
34   // This means that we can only create new EnumerableSets for types that fit
35   // in bytes32.
36   struct Set {
37     // Storage of set values
38     bytes32[] _values;
39 
40     // Position of the value in the `values` array, plus 1 because index 0
41     // means a value is not in the set.
42     mapping (bytes32 => uint256) _indexes;
43   }
44 
45   /**
46    * @dev Add a value to a set. O(1).
47    *
48    * Returns true if the value was added to the set, that is if it was not
49    * already present.
50    */
51   function _add(Set storage set, bytes32 value) private returns (bool) {
52     if (!_contains(set, value)) {
53       set._values.push(value);
54       // The value is stored at length-1, but we add 1 to all indexes
55       // and use 0 as a sentinel value
56       set._indexes[value] = set._values.length;
57       return true;
58     } else {
59       return false;
60     }
61   }
62 
63   /**
64    * @dev Removes a value from a set. O(1).
65    *
66    * Returns true if the value was removed from the set, that is if it was
67    * present.
68    */
69   function _remove(Set storage set, bytes32 value) private returns (bool) {
70     // We read and store the value's index to prevent multiple reads from the same storage slot
71     uint256 valueIndex = set._indexes[value];
72 
73     if (valueIndex != 0) { // Equivalent to contains(set, value)
74       // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
75       // the array, and then remove the last element (sometimes called as 'swap and pop').
76       // This modifies the order of the array, as noted in {at}.
77 
78       uint256 toDeleteIndex = valueIndex - 1;
79       uint256 lastIndex = set._values.length - 1;
80 
81       // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
82       // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
83 
84       bytes32 lastvalue = set._values[lastIndex];
85 
86       // Move the last value to the index where the value to delete is
87       set._values[toDeleteIndex] = lastvalue;
88       // Update the index for the moved value
89       set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
90 
91       // Delete the slot where the moved value was stored
92       set._values.pop();
93 
94       // Delete the index for the deleted slot
95       delete set._indexes[value];
96 
97       return true;
98     } else {
99       return false;
100     }
101   }
102 
103   /**
104    * @dev Returns true if the value is in the set. O(1).
105    */
106   function _contains(Set storage set, bytes32 value) private view returns (bool) {
107     return set._indexes[value] != 0;
108   }
109 
110   /**
111    * @dev Returns the number of values on the set. O(1).
112    */
113   function _length(Set storage set) private view returns (uint256) {
114     return set._values.length;
115   }
116 
117    /**
118     * @dev Returns the value stored at position `index` in the set. O(1).
119     *
120     * Note that there are no guarantees on the ordering of values inside the
121     * array, and it may change when more values are added or removed.
122     *
123     * Requirements:
124     *
125     * - `index` must be strictly less than {length}.
126     */
127   function _at(Set storage set, uint256 index) private view returns (bytes32) {
128     require(set._values.length > index, "EnumerableSet: index out of bounds");
129     return set._values[index];
130   }
131 
132   function _getValues( Set storage set_ ) private view returns ( bytes32[] storage ) {
133     return set_._values;
134   }
135 
136   // TODO needs insert function that maintains order.
137   // TODO needs NatSpec documentation comment.
138   /**
139    * Inserts new value by moving existing value at provided index to end of array and setting provided value at provided index
140    */
141   function _insert(Set storage set_, uint256 index_, bytes32 valueToInsert_ ) private returns ( bool ) {
142     require(  set_._values.length > index_ );
143     require( !_contains( set_, valueToInsert_ ), "Remove value you wish to insert if you wish to reorder array." );
144     bytes32 existingValue_ = _at( set_, index_ );
145     set_._values[index_] = valueToInsert_;
146     return _add( set_, existingValue_);
147   } 
148 
149   struct Bytes4Set {
150     Set _inner;
151   }
152 
153   /**
154    * @dev Add a value to a set. O(1).
155    *
156    * Returns true if the value was added to the set, that is if it was not
157    * already present.
158    */
159   function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
160     return _add(set._inner, value);
161   }
162 
163   /**
164    * @dev Removes a value from a set. O(1).
165    *
166    * Returns true if the value was removed from the set, that is if it was
167    * present.
168    */
169   function remove(Bytes4Set storage set, bytes4 value) internal returns (bool) {
170     return _remove(set._inner, value);
171   }
172 
173   /**
174    * @dev Returns true if the value is in the set. O(1).
175    */
176   function contains(Bytes4Set storage set, bytes4 value) internal view returns (bool) {
177     return _contains(set._inner, value);
178   }
179 
180   /**
181    * @dev Returns the number of values on the set. O(1).
182    */
183   function length(Bytes4Set storage set) internal view returns (uint256) {
184     return _length(set._inner);
185   }
186 
187   /**
188    * @dev Returns the value stored at position `index` in the set. O(1).
189    *
190    * Note that there are no guarantees on the ordering of values inside the
191    * array, and it may change when more values are added or removed.
192    *
193    * Requirements:
194    *
195    * - `index` must be strictly less than {length}.
196    */
197   function at(Bytes4Set storage set, uint256 index) internal view returns ( bytes4 ) {
198     return bytes4( _at( set._inner, index ) );
199   }
200 
201   function getValues( Bytes4Set storage set_ ) internal view returns ( bytes4[] memory ) {
202     bytes4[] memory bytes4Array_;
203     for( uint256 iteration_ = 0; _length( set_._inner ) > iteration_; iteration_++ ) {
204       bytes4Array_[iteration_] = bytes4( _at( set_._inner, iteration_ ) );
205     }
206     return bytes4Array_;
207   }
208 
209   function insert( Bytes4Set storage set_, uint256 index_, bytes4 valueToInsert_ ) internal returns ( bool ) {
210     return _insert( set_._inner, index_, valueToInsert_ );
211   }
212 
213     struct Bytes32Set {
214         Set _inner;
215     }
216 
217     /**
218      * @dev Add a value to a set. O(1).
219      *
220      * Returns true if the value was added to the set, that is if it was not
221      * already present.
222      */
223     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
224         return _add(set._inner, value);
225     }
226 
227     /**
228      * @dev Removes a value from a set. O(1).
229      *
230      * Returns true if the value was removed from the set, that is if it was
231      * present.
232      */
233     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
234         return _remove(set._inner, value);
235     }
236 
237     /**
238      * @dev Returns true if the value is in the set. O(1).
239      */
240     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
241         return _contains(set._inner, value);
242     }
243 
244     /**
245      * @dev Returns the number of values on the set. O(1).
246      */
247     function length(Bytes32Set storage set) internal view returns (uint256) {
248         return _length(set._inner);
249     }
250 
251     /**
252      * @dev Returns the value stored at position `index` in the set. O(1).
253      *
254      * Note that there are no guarantees on the ordering of values inside the
255      * array, and it may change when more values are added or removed.
256      *
257      * Requirements:
258      *
259      * - `index` must be strictly less than {length}.
260      */
261     function at(Bytes32Set storage set, uint256 index) internal view returns ( bytes32 ) {
262         return _at(set._inner, index);
263     }
264 
265   function getValues( Bytes32Set storage set_ ) internal view returns ( bytes4[] memory ) {
266     bytes4[] memory bytes4Array_;
267 
268       for( uint256 iteration_ = 0; _length( set_._inner ) >= iteration_; iteration_++ ){
269         bytes4Array_[iteration_] = bytes4( at( set_, iteration_ ) );
270       }
271 
272       return bytes4Array_;
273   }
274 
275   function insert( Bytes32Set storage set_, uint256 index_, bytes32 valueToInsert_ ) internal returns ( bool ) {
276     return _insert( set_._inner, index_, valueToInsert_ );
277   }
278 
279   // AddressSet
280   struct AddressSet {
281     Set _inner;
282   }
283 
284   /**
285    * @dev Add a value to a set. O(1).
286    *
287    * Returns true if the value was added to the set, that is if it was not
288    * already present.
289    */
290   function add(AddressSet storage set, address value) internal returns (bool) {
291     return _add(set._inner, bytes32(uint256(value)));
292   }
293 
294   /**
295    * @dev Removes a value from a set. O(1).
296    *
297    * Returns true if the value was removed from the set, that is if it was
298    * present.
299    */
300   function remove(AddressSet storage set, address value) internal returns (bool) {
301     return _remove(set._inner, bytes32(uint256(value)));
302   }
303 
304   /**
305    * @dev Returns true if the value is in the set. O(1).
306    */
307   function contains(AddressSet storage set, address value) internal view returns (bool) {
308     return _contains(set._inner, bytes32(uint256(value)));
309   }
310 
311   /**
312    * @dev Returns the number of values in the set. O(1).
313    */
314   function length(AddressSet storage set) internal view returns (uint256) {
315     return _length(set._inner);
316   }
317 
318   /**
319    * @dev Returns the value stored at position `index` in the set. O(1).
320    *
321    * Note that there are no guarantees on the ordering of values inside the
322    * array, and it may change when more values are added or removed.
323    *
324    * Requirements:
325    *
326    * - `index` must be strictly less than {length}.
327    */
328   function at(AddressSet storage set, uint256 index) internal view returns (address) {
329     return address(uint256(_at(set._inner, index)));
330   }
331 
332   /**
333    * TODO Might require explicit conversion of bytes32[] to address[].
334    *  Might require iteration.
335    */
336   function getValues( AddressSet storage set_ ) internal view returns ( address[] memory ) {
337 
338     address[] memory addressArray;
339 
340     for( uint256 iteration_ = 0; _length(set_._inner) >= iteration_; iteration_++ ){
341       addressArray[iteration_] = at( set_, iteration_ );
342     }
343 
344     return addressArray;
345   }
346 
347   function insert(AddressSet storage set_, uint256 index_, address valueToInsert_ ) internal returns ( bool ) {
348     return _insert( set_._inner, index_, bytes32(uint256(valueToInsert_)) );
349   }
350 
351 
352     // UintSet
353 
354     struct UintSet {
355         Set _inner;
356     }
357 
358     /**
359      * @dev Add a value to a set. O(1).
360      *
361      * Returns true if the value was added to the set, that is if it was not
362      * already present.
363      */
364     function add(UintSet storage set, uint256 value) internal returns (bool) {
365         return _add(set._inner, bytes32(value));
366     }
367 
368     /**
369      * @dev Removes a value from a set. O(1).
370      *
371      * Returns true if the value was removed from the set, that is if it was
372      * present.
373      */
374     function remove(UintSet storage set, uint256 value) internal returns (bool) {
375         return _remove(set._inner, bytes32(value));
376     }
377 
378     /**
379      * @dev Returns true if the value is in the set. O(1).
380      */
381     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
382         return _contains(set._inner, bytes32(value));
383     }
384 
385     /**
386      * @dev Returns the number of values on the set. O(1).
387      */
388     function length(UintSet storage set) internal view returns (uint256) {
389         return _length(set._inner);
390     }
391 
392    /**
393     * @dev Returns the value stored at position `index` in the set. O(1).
394     *
395     * Note that there are no guarantees on the ordering of values inside the
396     * array, and it may change when more values are added or removed.
397     *
398     * Requirements:
399     *
400     * - `index` must be strictly less than {length}.
401     */
402     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
403         return uint256(_at(set._inner, index));
404     }
405 
406     struct UInt256Set {
407         Set _inner;
408     }
409 
410     /**
411      * @dev Add a value to a set. O(1).
412      *
413      * Returns true if the value was added to the set, that is if it was not
414      * already present.
415      */
416     function add(UInt256Set storage set, uint256 value) internal returns (bool) {
417         return _add(set._inner, bytes32(value));
418     }
419 
420     /**
421      * @dev Removes a value from a set. O(1).
422      *
423      * Returns true if the value was removed from the set, that is if it was
424      * present.
425      */
426     function remove(UInt256Set storage set, uint256 value) internal returns (bool) {
427         return _remove(set._inner, bytes32(value));
428     }
429 
430     /**
431      * @dev Returns true if the value is in the set. O(1).
432      */
433     function contains(UInt256Set storage set, uint256 value) internal view returns (bool) {
434         return _contains(set._inner, bytes32(value));
435     }
436 
437     /**
438      * @dev Returns the number of values on the set. O(1).
439      */
440     function length(UInt256Set storage set) internal view returns (uint256) {
441         return _length(set._inner);
442     }
443 
444     /**
445      * @dev Returns the value stored at position `index` in the set. O(1).
446      *
447      * Note that there are no guarantees on the ordering of values inside the
448      * array, and it may change when more values are added or removed.
449      *
450      * Requirements:
451      *
452      * - `index` must be strictly less than {length}.
453      */
454     function at(UInt256Set storage set, uint256 index) internal view returns (uint256) {
455         return uint256(_at(set._inner, index));
456     }
457 }
458 
459 interface IERC20 {
460   /**
461    * @dev Returns the amount of tokens in existence.
462    */
463   function totalSupply() external view returns (uint256);
464 
465   /**
466    * @dev Returns the amount of tokens owned by `account`.
467    */
468   function balanceOf(address account) external view returns (uint256);
469 
470   /**
471    * @dev Moves `amount` tokens from the caller's account to `recipient`.
472    *
473    * Returns a boolean value indicating whether the operation succeeded.
474    *
475    * Emits a {Transfer} event.
476    */
477   function transfer(address recipient, uint256 amount) external returns (bool);
478 
479   /**
480    * @dev Returns the remaining number of tokens that `spender` will be
481    * allowed to spend on behalf of `owner` through {transferFrom}. This is
482    * zero by default.
483    *
484    * This value changes when {approve} or {transferFrom} are called.
485    */
486   function allowance(address owner, address spender) external view returns (uint256);
487 
488   /**
489    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
490    *
491    * Returns a boolean value indicating whether the operation succeeded.
492    *
493    * IMPORTANT: Beware that changing an allowance with this method brings the risk
494    * that someone may use both the old and the new allowance by unfortunate
495    * transaction ordering. One possible solution to mitigate this race
496    * condition is to first reduce the spender's allowance to 0 and set the
497    * desired value afterwards:
498    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
499    *
500    * Emits an {Approval} event.
501    */
502   function approve(address spender, uint256 amount) external returns (bool);
503 
504   /**
505    * @dev Moves `amount` tokens from `sender` to `recipient` using the
506    * allowance mechanism. `amount` is then deducted from the caller's
507    * allowance.
508    *
509    * Returns a boolean value indicating whether the operation succeeded.
510    *
511    * Emits a {Transfer} event.
512    */
513   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
514 
515   /**
516    * @dev Emitted when `value` tokens are moved from one account (`from`) to
517    * another (`to`).
518    *
519    * Note that `value` may be zero.
520    */
521   event Transfer(address indexed from, address indexed to, uint256 value);
522 
523   /**
524    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
525    * a call to {approve}. `value` is the new allowance.
526    */
527   event Approval(address indexed owner, address indexed spender, uint256 value);
528 }
529 
530 library SafeMath {
531     /**
532      * @dev Returns the addition of two unsigned integers, reverting on
533      * overflow.
534      *
535      * Counterpart to Solidity's `+` operator.
536      *
537      * Requirements:
538      *
539      * - Addition cannot overflow.
540      */
541     function add(uint256 a, uint256 b) internal pure returns (uint256) {
542         uint256 c = a + b;
543         require(c >= a, "SafeMath: addition overflow");
544 
545         return c;
546     }
547 
548     /**
549      * @dev Returns the subtraction of two unsigned integers, reverting on
550      * overflow (when the result is negative).
551      *
552      * Counterpart to Solidity's `-` operator.
553      *
554      * Requirements:
555      *
556      * - Subtraction cannot overflow.
557      */
558     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
559         return sub(a, b, "SafeMath: subtraction overflow");
560     }
561 
562     /**
563      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
564      * overflow (when the result is negative).
565      *
566      * Counterpart to Solidity's `-` operator.
567      *
568      * Requirements:
569      *
570      * - Subtraction cannot overflow.
571      */
572     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
573         require(b <= a, errorMessage);
574         uint256 c = a - b;
575 
576         return c;
577     }
578 
579     /**
580      * @dev Returns the multiplication of two unsigned integers, reverting on
581      * overflow.
582      *
583      * Counterpart to Solidity's `*` operator.
584      *
585      * Requirements:
586      *
587      * - Multiplication cannot overflow.
588      */
589     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
590         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
591         // benefit is lost if 'b' is also tested.
592         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
593         if (a == 0) {
594             return 0;
595         }
596 
597         uint256 c = a * b;
598         require(c / a == b, "SafeMath: multiplication overflow");
599 
600         return c;
601     }
602 
603     /**
604      * @dev Returns the integer division of two unsigned integers. Reverts on
605      * division by zero. The result is rounded towards zero.
606      *
607      * Counterpart to Solidity's `/` operator. Note: this function uses a
608      * `revert` opcode (which leaves remaining gas untouched) while Solidity
609      * uses an invalid opcode to revert (consuming all remaining gas).
610      *
611      * Requirements:
612      *
613      * - The divisor cannot be zero.
614      */
615     function div(uint256 a, uint256 b) internal pure returns (uint256) {
616         return div(a, b, "SafeMath: division by zero");
617     }
618 
619     /**
620      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
621      * division by zero. The result is rounded towards zero.
622      *
623      * Counterpart to Solidity's `/` operator. Note: this function uses a
624      * `revert` opcode (which leaves remaining gas untouched) while Solidity
625      * uses an invalid opcode to revert (consuming all remaining gas).
626      *
627      * Requirements:
628      *
629      * - The divisor cannot be zero.
630      */
631     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
632         require(b > 0, errorMessage);
633         uint256 c = a / b;
634         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
635 
636         return c;
637     }
638 
639     /**
640      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
641      * Reverts when dividing by zero.
642      *
643      * Counterpart to Solidity's `%` operator. This function uses a `revert`
644      * opcode (which leaves remaining gas untouched) while Solidity uses an
645      * invalid opcode to revert (consuming all remaining gas).
646      *
647      * Requirements:
648      *
649      * - The divisor cannot be zero.
650      */
651     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
652         return mod(a, b, "SafeMath: modulo by zero");
653     }
654 
655     /**
656      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
657      * Reverts with custom message when dividing by zero.
658      *
659      * Counterpart to Solidity's `%` operator. This function uses a `revert`
660      * opcode (which leaves remaining gas untouched) while Solidity uses an
661      * invalid opcode to revert (consuming all remaining gas).
662      *
663      * Requirements:
664      *
665      * - The divisor cannot be zero.
666      */
667     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
668         require(b != 0, errorMessage);
669         return a % b;
670     }
671 
672     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
673     function sqrrt(uint256 a) internal pure returns (uint c) {
674         if (a > 3) {
675             c = a;
676             uint b = add( div( a, 2), 1 );
677             while (b < c) {
678                 c = b;
679                 b = div( add( div( a, b ), b), 2 );
680             }
681         } else if (a != 0) {
682             c = 1;
683         }
684     }
685 
686     /*
687      * Expects percentage to be trailed by 00,
688     */
689     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
690         return div( mul( total_, percentage_ ), 1000 );
691     }
692 
693     /*
694      * Expects percentage to be trailed by 00,
695     */
696     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
697         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
698     }
699 
700     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
701         return div( mul(part_, 100) , total_ );
702     }
703 
704     /**
705      * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
706      * @dev Returns the average of two numbers. The result is rounded towards
707      * zero.
708      */
709     function average(uint256 a, uint256 b) internal pure returns (uint256) {
710         // (a + b) / 2 can overflow, so we distribute
711         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
712     }
713 
714     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
715         return sqrrt( mul( multiplier_, payment_ ) );
716     }
717 
718   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
719       return mul( multiplier_, supply_ );
720   }
721 }
722 
723 abstract contract ERC20
724   is 
725     IERC20
726   {
727 
728   using SafeMath for uint256;
729 
730   // TODO comment actual hash value.
731   bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
732     
733   // Present in ERC777
734   mapping (address => uint256) internal _balances;
735 
736   // Present in ERC777
737   mapping (address => mapping (address => uint256)) internal _allowances;
738 
739   // Present in ERC777
740   uint256 internal _totalSupply;
741 
742   // Present in ERC777
743   string internal _name;
744     
745   // Present in ERC777
746   string internal _symbol;
747     
748   // Present in ERC777
749   uint8 internal _decimals;
750 
751   /**
752    * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
753    * a default value of 18.
754    *
755    * To select a different value for {decimals}, use {_setupDecimals}.
756    *
757    * All three of these values are immutable: they can only be set once during
758    * construction.
759    */
760   constructor (string memory name_, string memory symbol_, uint8 decimals_) {
761     _name = name_;
762     _symbol = symbol_;
763     _decimals = decimals_;
764   }
765 
766   /**
767    * @dev Returns the name of the token.
768    */
769   // Present in ERC777
770   function name() public view returns (string memory) {
771     return _name;
772   }
773 
774   /**
775    * @dev Returns the symbol of the token, usually a shorter version of the
776    * name.
777    */
778   // Present in ERC777
779   function symbol() public view returns (string memory) {
780     return _symbol;
781   }
782 
783   /**
784    * @dev Returns the number of decimals used to get its user representation.
785    * For example, if `decimals` equals `2`, a balance of `505` tokens should
786    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
787    *
788    * Tokens usually opt for a value of 18, imitating the relationship between
789    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
790    * called.
791    *
792    * NOTE: This information is only used for _display_ purposes: it in
793    * no way affects any of the arithmetic of the contract, including
794    * {IERC20-balanceOf} and {IERC20-transfer}.
795    */
796   // Present in ERC777
797   function decimals() public view returns (uint8) {
798     return _decimals;
799   }
800 
801   /**
802    * @dev See {IERC20-totalSupply}.
803    */
804   // Present in ERC777
805   function totalSupply() public view override returns (uint256) {
806     return _totalSupply;
807   }
808 
809   /**
810    * @dev See {IERC20-balanceOf}.
811    */
812   // Present in ERC777
813   function balanceOf(address account) public view virtual override returns (uint256) {
814     return _balances[account];
815   }
816 
817   /**
818    * @dev See {IERC20-transfer}.
819    *
820    * Requirements:
821    *
822    * - `recipient` cannot be the zero address.
823    * - the caller must have a balance of at least `amount`.
824    */
825   // Overrideen in ERC777
826   // Confirm that this behavior changes 
827   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
828     _transfer(msg.sender, recipient, amount);
829     return true;
830   }
831 
832     /**
833      * @dev See {IERC20-allowance}.
834      */
835     // Present in ERC777
836     function allowance(address owner, address spender) public view virtual override returns (uint256) {
837         return _allowances[owner][spender];
838     }
839 
840     /**
841      * @dev See {IERC20-approve}.
842      *
843      * Requirements:
844      *
845      * - `spender` cannot be the zero address.
846      */
847     // Present in ERC777
848     function approve(address spender, uint256 amount) public virtual override returns (bool) {
849         _approve(msg.sender, spender, amount);
850         return true;
851     }
852 
853     /**
854      * @dev See {IERC20-transferFrom}.
855      *
856      * Emits an {Approval} event indicating the updated allowance. This is not
857      * required by the EIP. See the note at the beginning of {ERC20}.
858      *
859      * Requirements:
860      *
861      * - `sender` and `recipient` cannot be the zero address.
862      * - `sender` must have a balance of at least `amount`.
863      * - the caller must have allowance for ``sender``'s tokens of at least
864      * `amount`.
865      */
866     // Present in ERC777
867     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
868         _transfer(sender, recipient, amount);
869         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
870         return true;
871     }
872 
873     /**
874      * @dev Atomically increases the allowance granted to `spender` by the caller.
875      *
876      * This is an alternative to {approve} that can be used as a mitigation for
877      * problems described in {IERC20-approve}.
878      *
879      * Emits an {Approval} event indicating the updated allowance.
880      *
881      * Requirements:
882      *
883      * - `spender` cannot be the zero address.
884      */
885     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
886         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
887         return true;
888     }
889 
890     /**
891      * @dev Atomically decreases the allowance granted to `spender` by the caller.
892      *
893      * This is an alternative to {approve} that can be used as a mitigation for
894      * problems described in {IERC20-approve}.
895      *
896      * Emits an {Approval} event indicating the updated allowance.
897      *
898      * Requirements:
899      *
900      * - `spender` cannot be the zero address.
901      * - `spender` must have allowance for the caller of at least
902      * `subtractedValue`.
903      */
904     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
905         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
906         return true;
907     }
908 
909   /**
910    * @dev Moves tokens `amount` from `sender` to `recipient`.
911    *
912    * This is internal function is equivalent to {transfer}, and can be used to
913    * e.g. implement automatic token fees, slashing mechanisms, etc.
914    *
915    * Emits a {Transfer} event.
916    *
917    * Requirements:
918    *
919    * - `sender` cannot be the zero address.
920    * - `recipient` cannot be the zero address.
921    * - `sender` must have a balance of at least `amount`.
922    */
923   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
924     require(sender != address(0), "ERC20: transfer from the zero address");
925     require(recipient != address(0), "ERC20: transfer to the zero address");
926 
927     _beforeTokenTransfer(sender, recipient, amount);
928 
929     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
930     _balances[recipient] = _balances[recipient].add(amount);
931     emit Transfer(sender, recipient, amount);
932   }
933 
934     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
935      * the total supply.
936      *
937      * Emits a {Transfer} event with `from` set to the zero address.
938      *
939      * Requirements:
940      *
941      * - `to` cannot be the zero address.
942      */
943     // Present in ERC777
944     function _mint(address account_, uint256 amount_) internal virtual {
945         require(account_ != address(0), "ERC20: mint to the zero address");
946         _beforeTokenTransfer(address( this ), account_, amount_);
947         _totalSupply = _totalSupply.add(amount_);
948         _balances[account_] = _balances[account_].add(amount_);
949         emit Transfer(address( this ), account_, amount_);
950     }
951 
952     /**
953      * @dev Destroys `amount` tokens from `account`, reducing the
954      * total supply.
955      *
956      * Emits a {Transfer} event with `to` set to the zero address.
957      *
958      * Requirements:
959      *
960      * - `account` cannot be the zero address.
961      * - `account` must have at least `amount` tokens.
962      */
963     // Present in ERC777
964     function _burn(address account, uint256 amount) internal virtual {
965         require(account != address(0), "ERC20: burn from the zero address");
966 
967         _beforeTokenTransfer(account, address(0), amount);
968 
969         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
970         _totalSupply = _totalSupply.sub(amount);
971         emit Transfer(account, address(0), amount);
972     }
973 
974     /**
975      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
976      *
977      * This internal function is equivalent to `approve`, and can be used to
978      * e.g. set automatic allowances for certain subsystems, etc.
979      *
980      * Emits an {Approval} event.
981      *
982      * Requirements:
983      *
984      * - `owner` cannot be the zero address.
985      * - `spender` cannot be the zero address.
986      */
987     // Present in ERC777
988     function _approve(address owner, address spender, uint256 amount) internal virtual {
989         require(owner != address(0), "ERC20: approve from the zero address");
990         require(spender != address(0), "ERC20: approve to the zero address");
991 
992         _allowances[owner][spender] = amount;
993         emit Approval(owner, spender, amount);
994     }
995 
996     /**
997      * @dev Sets {decimals} to a value other than the default one of 18.
998      *
999      * WARNING: This function should only be called from the constructor. Most
1000      * applications that interact with token contracts will not expect
1001      * {decimals} to ever change, and may work incorrectly if it does.
1002      */
1003     // Considering deprication to reduce size of bytecode as changing _decimals to internal acheived the same functionality.
1004     // function _setupDecimals(uint8 decimals_) internal {
1005     //     _decimals = decimals_;
1006     // }
1007 
1008   /**
1009    * @dev Hook that is called before any transfer of tokens. This includes
1010    * minting and burning.
1011    *
1012    * Calling conditions:
1013    *
1014    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1015    * will be to transferred to `to`.
1016    * - when `from` is zero, `amount` tokens will be minted for `to`.
1017    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1018    * - `from` and `to` are never both zero.
1019    *
1020    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1021    */
1022   // Present in ERC777
1023   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
1024 }
1025 
1026 library Counters {
1027     using SafeMath for uint256;
1028 
1029     struct Counter {
1030         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1031         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1032         // this feature: see https://github.com/ethereum/solidity/issues/4637
1033         uint256 _value; // default: 0
1034     }
1035 
1036     function current(Counter storage counter) internal view returns (uint256) {
1037         return counter._value;
1038     }
1039 
1040     function increment(Counter storage counter) internal {
1041         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1042         counter._value += 1;
1043     }
1044 
1045     function decrement(Counter storage counter) internal {
1046         counter._value = counter._value.sub(1);
1047     }
1048 }
1049 
1050 interface IERC2612Permit {
1051     /**
1052      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
1053      * given `owner`'s signed approval.
1054      *
1055      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1056      * ordering also apply here.
1057      *
1058      * Emits an {Approval} event.
1059      *
1060      * Requirements:
1061      *
1062      * - `owner` cannot be the zero address.
1063      * - `spender` cannot be the zero address.
1064      * - `deadline` must be a timestamp in the future.
1065      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1066      * over the EIP712-formatted function arguments.
1067      * - the signature must use ``owner``'s current nonce (see {nonces}).
1068      *
1069      * For more information on the signature format, see the
1070      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1071      * section].
1072      */
1073     function permit(
1074         address owner,
1075         address spender,
1076         uint256 amount,
1077         uint256 deadline,
1078         uint8 v,
1079         bytes32 r,
1080         bytes32 s
1081     ) external;
1082 
1083     /**
1084      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
1085      * included whenever a signature is generated for {permit}.
1086      *
1087      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1088      * prevents a signature from being used multiple times.
1089      */
1090     function nonces(address owner) external view returns (uint256);
1091 }
1092 
1093 abstract contract ERC20Permit is ERC20, IERC2612Permit {
1094     using Counters for Counters.Counter;
1095 
1096     mapping(address => Counters.Counter) private _nonces;
1097 
1098     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1099     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1100 
1101     bytes32 public DOMAIN_SEPARATOR;
1102 
1103     constructor() {
1104         uint256 chainID;
1105         assembly {
1106             chainID := chainid()
1107         }
1108 
1109         DOMAIN_SEPARATOR = keccak256(
1110             abi.encode(
1111                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
1112                 keccak256(bytes(name())),
1113                 keccak256(bytes("1")), // Version
1114                 chainID,
1115                 address(this)
1116             )
1117         );
1118     }
1119 
1120     /**
1121      * @dev See {IERC2612Permit-permit}.
1122      *
1123      */
1124     function permit(
1125         address owner,
1126         address spender,
1127         uint256 amount,
1128         uint256 deadline,
1129         uint8 v,
1130         bytes32 r,
1131         bytes32 s
1132     ) public virtual override {
1133         require(block.timestamp <= deadline, "Permit: expired deadline");
1134 
1135         bytes32 hashStruct =
1136             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
1137 
1138         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
1139 
1140         address signer = ecrecover(_hash, v, r, s);
1141         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
1142 
1143         _nonces[owner].increment();
1144         _approve(owner, spender, amount);
1145     }
1146 
1147     /**
1148      * @dev See {IERC2612Permit-nonces}.
1149      */
1150     function nonces(address owner) public view override returns (uint256) {
1151         return _nonces[owner].current();
1152     }
1153 }
1154 
1155 interface IOwnable {
1156 
1157   function owner() external view returns (address);
1158 
1159   function renounceOwnership() external;
1160   
1161   function transferOwnership( address newOwner_ ) external;
1162 }
1163 
1164 contract Ownable is IOwnable {
1165     
1166   address internal _owner;
1167 
1168   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1169 
1170   /**
1171    * @dev Initializes the contract setting the deployer as the initial owner.
1172    */
1173   constructor () {
1174     _owner = msg.sender;
1175     emit OwnershipTransferred( address(0), _owner );
1176   }
1177 
1178   /**
1179    * @dev Returns the address of the current owner.
1180    */
1181   function owner() public view override returns (address) {
1182     return _owner;
1183   }
1184 
1185   /**
1186    * @dev Throws if called by any account other than the owner.
1187    */
1188   modifier onlyOwner() {
1189     require( _owner == msg.sender, "Ownable: caller is not the owner" );
1190     _;
1191   }
1192 
1193   /**
1194    * @dev Leaves the contract without owner. It will not be possible to call
1195    * `onlyOwner` functions anymore. Can only be called by the current owner.
1196    *
1197    * NOTE: Renouncing ownership will leave the contract without an owner,
1198    * thereby removing any functionality that is only available to the owner.
1199    */
1200   function renounceOwnership() public virtual override onlyOwner() {
1201     emit OwnershipTransferred( _owner, address(0) );
1202     _owner = address(0);
1203   }
1204 
1205   /**
1206    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1207    * Can only be called by the current owner.
1208    */
1209   function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
1210     require( newOwner_ != address(0), "Ownable: new owner is the zero address");
1211     emit OwnershipTransferred( _owner, newOwner_ );
1212     _owner = newOwner_;
1213   }
1214 }
1215 
1216 contract VaultOwned is Ownable {
1217     
1218   address internal _vault;
1219 
1220   function setVault( address vault_ ) external onlyOwner() returns ( bool ) {
1221     _vault = vault_;
1222 
1223     return true;
1224   }
1225 
1226   /**
1227    * @dev Returns the address of the current vault.
1228    */
1229   function vault() public view returns (address) {
1230     return _vault;
1231   }
1232 
1233   /**
1234    * @dev Throws if called by any account other than the vault.
1235    */
1236   modifier onlyVault() {
1237     require( _vault == msg.sender, "VaultOwned: caller is not the Vault" );
1238     _;
1239   }
1240 
1241 }
1242 
1243 contract TWAPOracleUpdater is ERC20Permit, VaultOwned {
1244 
1245   using EnumerableSet for EnumerableSet.AddressSet;
1246 
1247   event TWAPOracleChanged( address indexed previousTWAPOracle, address indexed newTWAPOracle );
1248   event TWAPEpochChanged( uint previousTWAPEpochPeriod, uint newTWAPEpochPeriod );
1249   event TWAPSourceAdded( address indexed newTWAPSource );
1250   event TWAPSourceRemoved( address indexed removedTWAPSource );
1251     
1252   EnumerableSet.AddressSet private _dexPoolsTWAPSources;
1253 
1254   ITWAPOracle public twapOracle;
1255 
1256   uint public twapEpochPeriod;
1257 
1258   constructor(
1259         string memory name_,
1260         string memory symbol_,
1261         uint8 decimals_
1262     ) ERC20(name_, symbol_, decimals_) {
1263     }
1264 
1265   function changeTWAPOracle( address newTWAPOracle_ ) external onlyOwner() {
1266     emit TWAPOracleChanged( address(twapOracle), newTWAPOracle_);
1267     twapOracle = ITWAPOracle( newTWAPOracle_ );
1268   }
1269 
1270   function changeTWAPEpochPeriod( uint newTWAPEpochPeriod_ ) external onlyOwner() {
1271     require( newTWAPEpochPeriod_ > 0, "TWAPOracleUpdater: TWAP Epoch period must be greater than 0." );
1272     emit TWAPEpochChanged( twapEpochPeriod, newTWAPEpochPeriod_ );
1273     twapEpochPeriod = newTWAPEpochPeriod_;
1274   }
1275 
1276   function addTWAPSource( address newTWAPSourceDexPool_ ) external onlyOwner() {
1277     require( _dexPoolsTWAPSources.add( newTWAPSourceDexPool_ ), "OlympusERC20TOken: TWAP Source already stored." );
1278     emit TWAPSourceAdded( newTWAPSourceDexPool_ );
1279   }
1280 
1281   function removeTWAPSource( address twapSourceToRemove_ ) external onlyOwner() {
1282     require( _dexPoolsTWAPSources.remove( twapSourceToRemove_ ), "OlympusERC20TOken: TWAP source not present." );
1283     emit TWAPSourceRemoved( twapSourceToRemove_ );
1284   }
1285 
1286   function _uodateTWAPOracle( address dexPoolToUpdateFrom_, uint twapEpochPeriodToUpdate_ ) internal {
1287     if ( _dexPoolsTWAPSources.contains( dexPoolToUpdateFrom_ )) {
1288       twapOracle.updateTWAP( dexPoolToUpdateFrom_, twapEpochPeriodToUpdate_ );
1289     }
1290   }
1291 
1292   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal override virtual {
1293       if( _dexPoolsTWAPSources.contains( from_ ) ) {
1294         _uodateTWAPOracle( from_, twapEpochPeriod );
1295       } else {
1296         if ( _dexPoolsTWAPSources.contains( to_ ) ) {
1297           _uodateTWAPOracle( to_, twapEpochPeriod );
1298         }
1299       }
1300     }
1301 }
1302 
1303 contract Divine is TWAPOracleUpdater {
1304   constructor(
1305     string memory name_,
1306     string memory symbol_,
1307     uint8 decimals_
1308   ) TWAPOracleUpdater(name_, symbol_, decimals_) {
1309   }
1310 }
1311 
1312 contract OlympusERC20Token is Divine {
1313 
1314   using SafeMath for uint256;
1315 
1316     constructor() Divine("Olympus", "OHM", 9) {
1317     }
1318 
1319     function mint(address account_, uint256 amount_) external onlyVault() {
1320         _mint(account_, amount_);
1321     }
1322 
1323     /**
1324      * @dev Destroys `amount` tokens from the caller.
1325      *
1326      * See {ERC20-_burn}.
1327      */
1328     function burn(uint256 amount) public virtual {
1329         _burn(msg.sender, amount);
1330     }
1331 
1332     // function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal override virtual {
1333     //   if( _dexPoolsTWAPSources.contains( from_ ) ) {
1334     //     _uodateTWAPOracle( from_, twapEpochPeriod );
1335     //   } else {
1336     //     if ( _dexPoolsTWAPSources.contains( to_ ) ) {
1337     //       _uodateTWAPOracle( to_, twapEpochPeriod );
1338     //     }
1339     //   }
1340     // }
1341 
1342     /*
1343      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1344      * allowance.
1345      *
1346      * See {ERC20-_burn} and {ERC20-allowance}.
1347      *
1348      * Requirements:
1349      *
1350      * - the caller must have allowance for ``accounts``'s tokens of at least
1351      * `amount`.
1352      */
1353      
1354     function burnFrom(address account_, uint256 amount_) public virtual {
1355         _burnFrom(account_, amount_);
1356     }
1357 
1358     function _burnFrom(address account_, uint256 amount_) public virtual {
1359         uint256 decreasedAllowance_ =
1360             allowance(account_, msg.sender).sub(
1361                 amount_,
1362                 "ERC20: burn amount exceeds allowance"
1363             );
1364 
1365         _approve(account_, msg.sender, decreasedAllowance_);
1366         _burn(account_, amount_);
1367     }
1368 }