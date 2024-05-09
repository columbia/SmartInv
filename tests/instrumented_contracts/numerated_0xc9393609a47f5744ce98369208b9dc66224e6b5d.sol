1 /**************************************|
2     |      GoldOnSteroids GOS Token v1     |
3     |    https://www.goldonsteroids.com    |
4     |_____________________________________*/
5 
6 
7 // SPDX-License-Identifier: AGPL-3.0-or-later
8 pragma solidity 0.7.5;
9 
10 library EnumerableSet {
11 
12   // To implement this library for multiple types with as little code
13   // repetition as possible, we write it in terms of a generic Set type with
14   // bytes32 values.
15   // The Set implementation uses private functions, and user-facing
16   // implementations (such as AddressSet) are just wrappers around the
17   // underlying Set.
18   // This means that we can only create new EnumerableSets for types that fit
19   // in bytes32.
20   struct Set {
21     // Storage of set values
22     bytes32[] _values;
23 
24     // Position of the value in the `values` array, plus 1 because index 0
25     // means a value is not in the set.
26     mapping (bytes32 => uint256) _indexes;
27   }
28 
29   /**
30    * @dev Add a value to a set. O(1).
31    *
32    * Returns true if the value was added to the set, that is if it was not
33    * already present.
34    */
35   function _add(Set storage set, bytes32 value) private returns (bool) {
36     if (!_contains(set, value)) {
37       set._values.push(value);
38       // The value is stored at length-1, but we add 1 to all indexes
39       // and use 0 as a sentinel value
40       set._indexes[value] = set._values.length;
41       return true;
42     } else {
43       return false;
44     }
45   }
46 
47   /**
48    * @dev Removes a value from a set. O(1).
49    *
50    * Returns true if the value was removed from the set, that is if it was
51    * present.
52    */
53   function _remove(Set storage set, bytes32 value) private returns (bool) {
54     // We read and store the value's index to prevent multiple reads from the same storage slot
55     uint256 valueIndex = set._indexes[value];
56 
57     if (valueIndex != 0) { // Equivalent to contains(set, value)
58       // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
59       // the array, and then remove the last element (sometimes called as 'swap and pop').
60       // This modifies the order of the array, as noted in {at}.
61 
62       uint256 toDeleteIndex = valueIndex - 1;
63       uint256 lastIndex = set._values.length - 1;
64 
65       // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
66       // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
67 
68       bytes32 lastvalue = set._values[lastIndex];
69 
70       // Move the last value to the index where the value to delete is
71       set._values[toDeleteIndex] = lastvalue;
72       // Update the index for the moved value
73       set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
74 
75       // Delete the slot where the moved value was stored
76       set._values.pop();
77 
78       // Delete the index for the deleted slot
79       delete set._indexes[value];
80 
81       return true;
82     } else {
83       return false;
84     }
85   }
86 
87   /**
88    * @dev Returns true if the value is in the set. O(1).
89    */
90   function _contains(Set storage set, bytes32 value) private view returns (bool) {
91     return set._indexes[value] != 0;
92   }
93 
94   /**
95    * @dev Returns the number of values on the set. O(1).
96    */
97   function _length(Set storage set) private view returns (uint256) {
98     return set._values.length;
99   }
100 
101    /**
102     * @dev Returns the value stored at position `index` in the set. O(1).
103     *
104     * Note that there are no guarantees on the ordering of values inside the
105     * array, and it may change when more values are added or removed.
106     *
107     * Requirements:
108     *
109     * - `index` must be strictly less than {length}.
110     */
111   function _at(Set storage set, uint256 index) private view returns (bytes32) {
112     require(set._values.length > index, "EnumerableSet: index out of bounds");
113     return set._values[index];
114   }
115 
116   function _getValues( Set storage set_ ) private view returns ( bytes32[] storage ) {
117     return set_._values;
118   }
119 
120   // TODO needs insert function that maintains order.
121   // TODO needs NatSpec documentation comment.
122   /**
123    * Inserts new value by moving existing value at provided index to end 
124    * of array and setting provided value at provided index
125    */
126   function _insert(Set storage set_, uint256 index_, bytes32 valueToInsert_ ) private returns ( bool ) {
127     require(  set_._values.length > index_ );
128     require( !_contains( set_, valueToInsert_ ), "Remove value you wish to insert if you wish to reorder array." );
129     bytes32 existingValue_ = _at( set_, index_ );
130     set_._values[index_] = valueToInsert_;
131     return _add( set_, existingValue_);
132   } 
133 
134   struct Bytes4Set {
135     Set _inner;
136   }
137 
138   /**
139    * @dev Add a value to a set. O(1).
140    *
141    * Returns true if the value was added to the set, that is if it was not
142    * already present.
143    */
144   function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
145     return _add(set._inner, value);
146   }
147 
148   /**
149    * @dev Removes a value from a set. O(1).
150    *
151    * Returns true if the value was removed from the set, that is if it was
152    * present.
153    */
154   function remove(Bytes4Set storage set, bytes4 value) internal returns (bool) {
155     return _remove(set._inner, value);
156   }
157 
158   /**
159    * @dev Returns true if the value is in the set. O(1).
160    */
161   function contains(Bytes4Set storage set, bytes4 value) internal view returns (bool) {
162     return _contains(set._inner, value);
163   }
164 
165   /**
166    * @dev Returns the number of values on the set. O(1).
167    */
168   function length(Bytes4Set storage set) internal view returns (uint256) {
169     return _length(set._inner);
170   }
171 
172   /**
173    * @dev Returns the value stored at position `index` in the set. O(1).
174    *
175    * Note that there are no guarantees on the ordering of values inside the
176    * array, and it may change when more values are added or removed.
177    *
178    * Requirements:
179    *
180    * - `index` must be strictly less than {length}.
181    */
182   function at(Bytes4Set storage set, uint256 index) internal view returns ( bytes4 ) {
183     return bytes4( _at( set._inner, index ) );
184   }
185 
186   function getValues( Bytes4Set storage set_ ) internal view returns ( bytes4[] memory ) {
187     bytes4[] memory bytes4Array_;
188     for( uint256 iteration_ = 0; _length( set_._inner ) > iteration_; iteration_++ ) {
189       bytes4Array_[iteration_] = bytes4( _at( set_._inner, iteration_ ) );
190     }
191     return bytes4Array_;
192   }
193 
194   function insert( Bytes4Set storage set_, uint256 index_, bytes4 valueToInsert_ ) internal returns ( bool ) {
195     return _insert( set_._inner, index_, valueToInsert_ );
196   }
197 
198     struct Bytes32Set {
199         Set _inner;
200     }
201 
202     /**
203      * @dev Add a value to a set. O(1).
204      *
205      * Returns true if the value was added to the set, that is if it was not
206      * already present.
207      */
208     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
209         return _add(set._inner, value);
210     }
211 
212     /**
213      * @dev Removes a value from a set. O(1).
214      *
215      * Returns true if the value was removed from the set, that is if it was
216      * present.
217      */
218     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
219         return _remove(set._inner, value);
220     }
221 
222     /**
223      * @dev Returns true if the value is in the set. O(1).
224      */
225     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
226         return _contains(set._inner, value);
227     }
228 
229     /**
230      * @dev Returns the number of values on the set. O(1).
231      */
232     function length(Bytes32Set storage set) internal view returns (uint256) {
233         return _length(set._inner);
234     }
235 
236     /**
237      * @dev Returns the value stored at position `index` in the set. O(1).
238      *
239      * Note that there are no guarantees on the ordering of values inside the
240      * array, and it may change when more values are added or removed.
241      *
242      * Requirements:
243      *
244      * - `index` must be strictly less than {length}.
245      */
246     function at(Bytes32Set storage set, uint256 index) internal view returns ( bytes32 ) {
247         return _at(set._inner, index);
248     }
249 
250   function getValues( Bytes32Set storage set_ ) internal view returns ( bytes4[] memory ) {
251     bytes4[] memory bytes4Array_;
252 
253       for( uint256 iteration_ = 0; _length( set_._inner ) >= iteration_; iteration_++ ){
254         bytes4Array_[iteration_] = bytes4( at( set_, iteration_ ) );
255       }
256 
257       return bytes4Array_;
258   }
259 
260   function insert( Bytes32Set storage set_, uint256 index_, bytes32 valueToInsert_ ) internal returns ( bool ) {
261     return _insert( set_._inner, index_, valueToInsert_ );
262   }
263 
264   // AddressSet
265   struct AddressSet {
266     Set _inner;
267   }
268 
269   /**
270    * @dev Add a value to a set. O(1).
271    *
272    * Returns true if the value was added to the set, that is if it was not
273    * already present.
274    */
275   function add(AddressSet storage set, address value) internal returns (bool) {
276     return _add(set._inner, bytes32(uint256(value)));
277   }
278 
279   /**
280    * @dev Removes a value from a set. O(1).
281    *
282    * Returns true if the value was removed from the set, that is if it was
283    * present.
284    */
285   function remove(AddressSet storage set, address value) internal returns (bool) {
286     return _remove(set._inner, bytes32(uint256(value)));
287   }
288 
289   /**
290    * @dev Returns true if the value is in the set. O(1).
291    */
292   function contains(AddressSet storage set, address value) internal view returns (bool) {
293     return _contains(set._inner, bytes32(uint256(value)));
294   }
295 
296   /**
297    * @dev Returns the number of values in the set. O(1).
298    */
299   function length(AddressSet storage set) internal view returns (uint256) {
300     return _length(set._inner);
301   }
302 
303   /**
304    * @dev Returns the value stored at position `index` in the set. O(1).
305    *
306    * Note that there are no guarantees on the ordering of values inside the
307    * array, and it may change when more values are added or removed.
308    *
309    * Requirements:
310    *
311    * - `index` must be strictly less than {length}.
312    */
313   function at(AddressSet storage set, uint256 index) internal view returns (address) {
314     return address(uint256(_at(set._inner, index)));
315   }
316 
317   /**
318    * TODO Might require explicit conversion of bytes32[] to address[].
319    *  Might require iteration.
320    */
321   function getValues( AddressSet storage set_ ) internal view returns ( address[] memory ) {
322 
323     address[] memory addressArray;
324 
325     for( uint256 iteration_ = 0; _length(set_._inner) >= iteration_; iteration_++ ){
326       addressArray[iteration_] = at( set_, iteration_ );
327     }
328 
329     return addressArray;
330   }
331 
332   function insert(AddressSet storage set_, uint256 index_, address valueToInsert_ ) internal returns ( bool ) {
333     return _insert( set_._inner, index_, bytes32(uint256(valueToInsert_)) );
334   }
335 
336 
337     // UintSet
338 
339     struct UintSet {
340         Set _inner;
341     }
342 
343     /**
344      * @dev Add a value to a set. O(1).
345      *
346      * Returns true if the value was added to the set, that is if it was not
347      * already present.
348      */
349     function add(UintSet storage set, uint256 value) internal returns (bool) {
350         return _add(set._inner, bytes32(value));
351     }
352 
353     /**
354      * @dev Removes a value from a set. O(1).
355      *
356      * Returns true if the value was removed from the set, that is if it was
357      * present.
358      */
359     function remove(UintSet storage set, uint256 value) internal returns (bool) {
360         return _remove(set._inner, bytes32(value));
361     }
362 
363     /**
364      * @dev Returns true if the value is in the set. O(1).
365      */
366     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
367         return _contains(set._inner, bytes32(value));
368     }
369 
370     /**
371      * @dev Returns the number of values on the set. O(1).
372      */
373     function length(UintSet storage set) internal view returns (uint256) {
374         return _length(set._inner);
375     }
376 
377    /**
378     * @dev Returns the value stored at position `index` in the set. O(1).
379     *
380     * Note that there are no guarantees on the ordering of values inside the
381     * array, and it may change when more values are added or removed.
382     *
383     * Requirements:
384     *
385     * - `index` must be strictly less than {length}.
386     */
387     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
388         return uint256(_at(set._inner, index));
389     }
390 
391     struct UInt256Set {
392         Set _inner;
393     }
394 
395     /**
396      * @dev Add a value to a set. O(1).
397      *
398      * Returns true if the value was added to the set, that is if it was not
399      * already present.
400      */
401     function add(UInt256Set storage set, uint256 value) internal returns (bool) {
402         return _add(set._inner, bytes32(value));
403     }
404 
405     /**
406      * @dev Removes a value from a set. O(1).
407      *
408      * Returns true if the value was removed from the set, that is if it was
409      * present.
410      */
411     function remove(UInt256Set storage set, uint256 value) internal returns (bool) {
412         return _remove(set._inner, bytes32(value));
413     }
414 
415     /**
416      * @dev Returns true if the value is in the set. O(1).
417      */
418     function contains(UInt256Set storage set, uint256 value) internal view returns (bool) {
419         return _contains(set._inner, bytes32(value));
420     }
421 
422     /**
423      * @dev Returns the number of values on the set. O(1).
424      */
425     function length(UInt256Set storage set) internal view returns (uint256) {
426         return _length(set._inner);
427     }
428 
429     /**
430      * @dev Returns the value stored at position `index` in the set. O(1).
431      *
432      * Note that there are no guarantees on the ordering of values inside the
433      * array, and it may change when more values are added or removed.
434      *
435      * Requirements:
436      *
437      * - `index` must be strictly less than {length}.
438      */
439     function at(UInt256Set storage set, uint256 index) internal view returns (uint256) {
440         return uint256(_at(set._inner, index));
441     }
442 }
443 
444 interface IERC20 {
445   /**
446    * @dev Returns the amount of tokens in existence.
447    */
448   function totalSupply() external view returns (uint256);
449 
450   /**
451    * @dev Returns the amount of tokens owned by `account`.
452    */
453   function balanceOf(address account) external view returns (uint256);
454 
455   /**
456    * @dev Moves `amount` tokens from the caller's account to `recipient`.
457    *
458    * Returns a boolean value indicating whether the operation succeeded.
459    *
460    * Emits a {Transfer} event.
461    */
462   function transfer(address recipient, uint256 amount) external returns (bool);
463 
464   /**
465    * @dev Returns the remaining number of tokens that `spender` will be
466    * allowed to spend on behalf of `owner` through {transferFrom}. This is
467    * zero by default.
468    *
469    * This value changes when {approve} or {transferFrom} are called.
470    */
471   function allowance(address owner, address spender) external view returns (uint256);
472 
473   /**
474    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
475    *
476    * Returns a boolean value indicating whether the operation succeeded.
477    *
478    * IMPORTANT: Beware that changing an allowance with this method brings the risk
479    * that someone may use both the old and the new allowance by unfortunate
480    * transaction ordering. One possible solution to mitigate this race
481    * condition is to first reduce the spender's allowance to 0 and set the
482    * desired value afterwards:
483    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
484    *
485    * Emits an {Approval} event.
486    */
487   function approve(address spender, uint256 amount) external returns (bool);
488 
489   /**
490    * @dev Moves `amount` tokens from `sender` to `recipient` using the
491    * allowance mechanism. `amount` is then deducted from the caller's
492    * allowance.
493    *
494    * Returns a boolean value indicating whether the operation succeeded.
495    *
496    * Emits a {Transfer} event.
497    */
498   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
499 
500   /**
501    * @dev Emitted when `value` tokens are moved from one account (`from`) to
502    * another (`to`).
503    *
504    * Note that `value` may be zero.
505    */
506   event Transfer(address indexed from, address indexed to, uint256 value);
507 
508   /**
509    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
510    * a call to {approve}. `value` is the new allowance.
511    */
512   event Approval(address indexed owner, address indexed spender, uint256 value);
513 }
514 
515 library SafeMath {
516 
517     function add(uint256 a, uint256 b) internal pure returns (uint256) {
518         uint256 c = a + b;
519         require(c >= a, "SafeMath: addition overflow");
520 
521         return c;
522     }
523 
524     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
525         return sub(a, b, "SafeMath: subtraction overflow");
526     }
527 
528     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
529         require(b <= a, errorMessage);
530         uint256 c = a - b;
531 
532         return c;
533     }
534 
535     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
536 
537         if (a == 0) {
538             return 0;
539         }
540 
541         uint256 c = a * b;
542         require(c / a == b, "SafeMath: multiplication overflow");
543 
544         return c;
545     }
546 
547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
548         return div(a, b, "SafeMath: division by zero");
549     }
550 
551     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
552         require(b > 0, errorMessage);
553         uint256 c = a / b;
554         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
555 
556         return c;
557     }
558 
559     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
560         return mod(a, b, "SafeMath: modulo by zero");
561     }
562 
563     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b != 0, errorMessage);
565         return a % b;
566     }
567 
568     function sqrrt(uint256 a) internal pure returns (uint c) {
569         if (a > 3) {
570             c = a;
571             uint b = add( div( a, 2), 1 );
572             while (b < c) {
573                 c = b;
574                 b = div( add( div( a, b ), b), 2 );
575             }
576         } else if (a != 0) {
577             c = 1;
578         }
579     }
580 
581     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
582         return div( mul( total_, percentage_ ), 1000 );
583     }
584 
585     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
586         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
587     }
588 
589     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
590         return div( mul(part_, 100) , total_ );
591     }
592 
593     function average(uint256 a, uint256 b) internal pure returns (uint256) {
594         // (a + b) / 2 can overflow, so we distribute
595         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
596     }
597 
598     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
599         return sqrrt( mul( multiplier_, payment_ ) );
600     }
601 
602   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
603       return mul( multiplier_, supply_ );
604   }
605 }
606 
607 abstract contract ERC20 is IERC20 {
608 
609   using SafeMath for uint256;
610 
611   // TODO comment actual hash value.
612   bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
613     
614   // Present in ERC777
615   mapping (address => uint256) internal _balances;
616 
617   // Present in ERC777
618   mapping (address => mapping (address => uint256)) internal _allowances;
619 
620   // Present in ERC777
621   uint256 internal _totalSupply;
622 
623   // Present in ERC777
624   string internal _name;
625     
626   // Present in ERC777
627   string internal _symbol;
628     
629   // Present in ERC777
630   uint8 internal _decimals;
631 
632   constructor (string memory name_, string memory symbol_, uint8 decimals_) {
633     _name = name_;
634     _symbol = symbol_;
635     _decimals = decimals_;
636   }
637 
638   function name() public view returns (string memory) {
639     return _name;
640   }
641 
642   function symbol() public view returns (string memory) {
643     return _symbol;
644   }
645 
646   function decimals() public view returns (uint8) {
647     return _decimals;
648   }
649 
650   function totalSupply() public view override returns (uint256) {
651     return _totalSupply;
652   }
653 
654   function balanceOf(address account) public view virtual override returns (uint256) {
655     return _balances[account];
656   }
657 
658   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
659     _transfer(msg.sender, recipient, amount);
660     return true;
661   }
662 
663     function allowance(address owner, address spender) public view virtual override returns (uint256) {
664         return _allowances[owner][spender];
665     }
666 
667     function approve(address spender, uint256 amount) public virtual override returns (bool) {
668         _approve(msg.sender, spender, amount);
669         return true;
670     }
671 
672     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
673         _transfer(sender, recipient, amount);
674         _approve(sender, msg.sender, _allowances[sender][msg.sender]
675           .sub(amount, "ERC20: transfer amount exceeds allowance"));
676         return true;
677     }
678 
679     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
680         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
681         return true;
682     }
683 
684     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
685         _approve(msg.sender, spender, _allowances[msg.sender][spender]
686           .sub(subtractedValue, "ERC20: decreased allowance below zero"));
687         return true;
688     }
689 
690     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
691       require(sender != address(0), "ERC20: transfer from the zero address");
692       require(recipient != address(0), "ERC20: transfer to the zero address");
693 
694       _beforeTokenTransfer(sender, recipient, amount);
695 
696       _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
697       _balances[recipient] = _balances[recipient].add(amount);
698       emit Transfer(sender, recipient, amount);
699     }
700 
701     function _mint(address account_, uint256 amount_) internal virtual {
702         require(account_ != address(0), "ERC20: mint to the zero address");
703         _beforeTokenTransfer(address( this ), account_, amount_);
704         _totalSupply = _totalSupply.add(amount_);
705         _balances[account_] = _balances[account_].add(amount_);
706         emit Transfer(address( this ), account_, amount_);
707     }
708 
709     function _burn(address account, uint256 amount) internal virtual {
710         require(account != address(0), "ERC20: burn from the zero address");
711 
712         _beforeTokenTransfer(account, address(0), amount);
713 
714         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
715         _totalSupply = _totalSupply.sub(amount);
716         emit Transfer(account, address(0), amount);
717     }
718 
719     function _approve(address owner, address spender, uint256 amount) internal virtual {
720         require(owner != address(0), "ERC20: approve from the zero address");
721         require(spender != address(0), "ERC20: approve to the zero address");
722 
723         _allowances[owner][spender] = amount;
724         emit Approval(owner, spender, amount);
725     }
726 
727   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
728 }
729 
730 library Counters {
731     using SafeMath for uint256;
732 
733     struct Counter {
734         uint256 _value; // default: 0
735     }
736 
737     function current(Counter storage counter) internal view returns (uint256) {
738         return counter._value;
739     }
740 
741     function increment(Counter storage counter) internal {
742         counter._value += 1;
743     }
744 
745     function decrement(Counter storage counter) internal {
746         counter._value = counter._value.sub(1);
747     }
748 }
749 
750 interface IERC2612Permit {
751 
752     function permit(
753         address owner,
754         address spender,
755         uint256 amount,
756         uint256 deadline,
757         uint8 v,
758         bytes32 r,
759         bytes32 s
760     ) external;
761 
762     function nonces(address owner) external view returns (uint256);
763 }
764 
765 abstract contract ERC20Permit is ERC20, IERC2612Permit {
766     using Counters for Counters.Counter;
767 
768     mapping(address => Counters.Counter) private _nonces;
769 
770     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
771     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
772 
773     bytes32 public DOMAIN_SEPARATOR;
774 
775     constructor() {
776         uint256 chainID;
777         assembly {
778             chainID := chainid()
779         }
780 
781         DOMAIN_SEPARATOR = keccak256(
782             abi.encode(
783                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
784                 keccak256(bytes(name())),
785                 keccak256(bytes("1")), // Version
786                 chainID,
787                 address(this)
788             )
789         );
790     }
791 
792     function permit(
793         address owner,
794         address spender,
795         uint256 amount,
796         uint256 deadline,
797         uint8 v,
798         bytes32 r,
799         bytes32 s
800     ) public virtual override {
801         require(block.timestamp <= deadline, "Permit: expired deadline");
802 
803         bytes32 hashStruct =
804             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
805 
806         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
807 
808         address signer = ecrecover(_hash, v, r, s);
809         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
810 
811         _nonces[owner].increment();
812         _approve(owner, spender, amount);
813     }
814 
815     function nonces(address owner) public view override returns (uint256) {
816         return _nonces[owner].current();
817     }
818 }
819 
820 interface IOwnable {
821   function owner() external view returns (address);
822 
823   function renounceOwnership() external;
824   
825   function transferOwnership( address newOwner_ ) external;
826 }
827 
828 contract Ownable is IOwnable {
829     
830   address internal _owner;
831 
832   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
833 
834   constructor () {
835     _owner = msg.sender;
836     emit OwnershipTransferred( address(0), _owner );
837   }
838 
839   function owner() public view override returns (address) {
840     return _owner;
841   }
842 
843   modifier onlyOwner() {
844     require( _owner == msg.sender, "Ownable: caller is not the owner" );
845     _;
846   }
847 
848   function renounceOwnership() public virtual override onlyOwner() {
849     emit OwnershipTransferred( _owner, address(0) );
850     _owner = address(0);
851   }
852 
853   function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
854     require( newOwner_ != address(0), "Ownable: new owner is the zero address");
855     emit OwnershipTransferred( _owner, newOwner_ );
856     _owner = newOwner_;
857   }
858 }
859 
860 contract GoldOnSteroids is ERC20Permit, Ownable {
861 
862     using SafeMath for uint256;
863 
864     constructor() ERC20("GoldOnSteroids", "GOS", 6) {
865     	_mint(msg.sender, 1000000 * 10 ** 6);
866     }
867 
868     function mint(address account_, uint256 amount_) external onlyOwner() {
869         _mint(account_, amount_);
870     }
871 
872     function burn(uint256 amount) public virtual {
873         _burn(msg.sender, amount);
874     }
875      
876     function burnFrom(address account_, uint256 amount_) public virtual {
877         _burnFrom(account_, amount_);
878     }
879 
880     function _burnFrom(address account_, uint256 amount_) public virtual {
881         uint256 decreasedAllowance_ =
882             allowance(account_, msg.sender).sub(
883                 amount_,
884                 "ERC20: burn amount exceeds allowance"
885             );
886 
887         _approve(account_, msg.sender, decreasedAllowance_);
888         _burn(account_, amount_);
889     }
890 }