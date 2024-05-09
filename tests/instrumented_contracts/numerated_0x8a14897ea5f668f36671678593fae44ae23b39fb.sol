1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 library EnumerableSet {
5 
6   // To implement this library for multiple types with as little code
7   // repetition as possible, we write it in terms of a generic Set type with
8   // bytes32 values.
9   // The Set implementation uses private functions, and user-facing
10   // implementations (such as AddressSet) are just wrappers around the
11   // underlying Set.
12   // This means that we can only create new EnumerableSets for types that fit
13   // in bytes32.
14   struct Set {
15     // Storage of set values
16     bytes32[] _values;
17 
18     // Position of the value in the `values` array, plus 1 because index 0
19     // means a value is not in the set.
20     mapping (bytes32 => uint256) _indexes;
21   }
22 
23   /**
24    * @dev Add a value to a set. O(1).
25    *
26    * Returns true if the value was added to the set, that is if it was not
27    * already present.
28    */
29   function _add(Set storage set, bytes32 value) private returns (bool) {
30     if (!_contains(set, value)) {
31       set._values.push(value);
32       // The value is stored at length-1, but we add 1 to all indexes
33       // and use 0 as a sentinel value
34       set._indexes[value] = set._values.length;
35       return true;
36     } else {
37       return false;
38     }
39   }
40 
41   /**
42    * @dev Removes a value from a set. O(1).
43    *
44    * Returns true if the value was removed from the set, that is if it was
45    * present.
46    */
47   function _remove(Set storage set, bytes32 value) private returns (bool) {
48     // We read and store the value's index to prevent multiple reads from the same storage slot
49     uint256 valueIndex = set._indexes[value];
50 
51     if (valueIndex != 0) { // Equivalent to contains(set, value)
52       // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
53       // the array, and then remove the last element (sometimes called as 'swap and pop').
54       // This modifies the order of the array, as noted in {at}.
55 
56       uint256 toDeleteIndex = valueIndex - 1;
57       uint256 lastIndex = set._values.length - 1;
58 
59       // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
60       // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
61 
62       bytes32 lastvalue = set._values[lastIndex];
63 
64       // Move the last value to the index where the value to delete is
65       set._values[toDeleteIndex] = lastvalue;
66       // Update the index for the moved value
67       set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
68 
69       // Delete the slot where the moved value was stored
70       set._values.pop();
71 
72       // Delete the index for the deleted slot
73       delete set._indexes[value];
74 
75       return true;
76     } else {
77       return false;
78     }
79   }
80 
81   /**
82    * @dev Returns true if the value is in the set. O(1).
83    */
84   function _contains(Set storage set, bytes32 value) private view returns (bool) {
85     return set._indexes[value] != 0;
86   }
87 
88   /**
89    * @dev Returns the number of values on the set. O(1).
90    */
91   function _length(Set storage set) private view returns (uint256) {
92     return set._values.length;
93   }
94 
95    /**
96     * @dev Returns the value stored at position `index` in the set. O(1).
97     *
98     * Note that there are no guarantees on the ordering of values inside the
99     * array, and it may change when more values are added or removed.
100     *
101     * Requirements:
102     *
103     * - `index` must be strictly less than {length}.
104     */
105   function _at(Set storage set, uint256 index) private view returns (bytes32) {
106     require(set._values.length > index, "EnumerableSet: index out of bounds");
107     return set._values[index];
108   }
109 
110   function _getValues( Set storage set_ ) private view returns ( bytes32[] storage ) {
111     return set_._values;
112   }
113 
114   // TODO needs insert function that maintains order.
115   // TODO needs NatSpec documentation comment.
116   /**
117    * Inserts new value by moving existing value at provided index to end of array and setting provided value at provided index
118    */
119   function _insert(Set storage set_, uint256 index_, bytes32 valueToInsert_ ) private returns ( bool ) {
120     require(  set_._values.length > index_ );
121     require( !_contains( set_, valueToInsert_ ), "Remove value you wish to insert if you wish to reorder array." );
122     bytes32 existingValue_ = _at( set_, index_ );
123     set_._values[index_] = valueToInsert_;
124     return _add( set_, existingValue_);
125   } 
126 
127   struct Bytes4Set {
128     Set _inner;
129   }
130 
131   /**
132    * @dev Add a value to a set. O(1).
133    *
134    * Returns true if the value was added to the set, that is if it was not
135    * already present.
136    */
137   function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
138     return _add(set._inner, value);
139   }
140 
141   /**
142    * @dev Removes a value from a set. O(1).
143    *
144    * Returns true if the value was removed from the set, that is if it was
145    * present.
146    */
147   function remove(Bytes4Set storage set, bytes4 value) internal returns (bool) {
148     return _remove(set._inner, value);
149   }
150 
151   /**
152    * @dev Returns true if the value is in the set. O(1).
153    */
154   function contains(Bytes4Set storage set, bytes4 value) internal view returns (bool) {
155     return _contains(set._inner, value);
156   }
157 
158   /**
159    * @dev Returns the number of values on the set. O(1).
160    */
161   function length(Bytes4Set storage set) internal view returns (uint256) {
162     return _length(set._inner);
163   }
164 
165   /**
166    * @dev Returns the value stored at position `index` in the set. O(1).
167    *
168    * Note that there are no guarantees on the ordering of values inside the
169    * array, and it may change when more values are added or removed.
170    *
171    * Requirements:
172    *
173    * - `index` must be strictly less than {length}.
174    */
175   function at(Bytes4Set storage set, uint256 index) internal view returns ( bytes4 ) {
176     return bytes4( _at( set._inner, index ) );
177   }
178 
179   function getValues( Bytes4Set storage set_ ) internal view returns ( bytes4[] memory ) {
180     bytes4[] memory bytes4Array_;
181     for( uint256 iteration_ = 0; _length( set_._inner ) > iteration_; iteration_++ ) {
182       bytes4Array_[iteration_] = bytes4( _at( set_._inner, iteration_ ) );
183     }
184     return bytes4Array_;
185   }
186 
187   function insert( Bytes4Set storage set_, uint256 index_, bytes4 valueToInsert_ ) internal returns ( bool ) {
188     return _insert( set_._inner, index_, valueToInsert_ );
189   }
190 
191     struct Bytes32Set {
192         Set _inner;
193     }
194 
195     /**
196      * @dev Add a value to a set. O(1).
197      *
198      * Returns true if the value was added to the set, that is if it was not
199      * already present.
200      */
201     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
202         return _add(set._inner, value);
203     }
204 
205     /**
206      * @dev Removes a value from a set. O(1).
207      *
208      * Returns true if the value was removed from the set, that is if it was
209      * present.
210      */
211     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
212         return _remove(set._inner, value);
213     }
214 
215     /**
216      * @dev Returns true if the value is in the set. O(1).
217      */
218     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
219         return _contains(set._inner, value);
220     }
221 
222     /**
223      * @dev Returns the number of values on the set. O(1).
224      */
225     function length(Bytes32Set storage set) internal view returns (uint256) {
226         return _length(set._inner);
227     }
228 
229     /**
230      * @dev Returns the value stored at position `index` in the set. O(1).
231      *
232      * Note that there are no guarantees on the ordering of values inside the
233      * array, and it may change when more values are added or removed.
234      *
235      * Requirements:
236      *
237      * - `index` must be strictly less than {length}.
238      */
239     function at(Bytes32Set storage set, uint256 index) internal view returns ( bytes32 ) {
240         return _at(set._inner, index);
241     }
242 
243   function getValues( Bytes32Set storage set_ ) internal view returns ( bytes4[] memory ) {
244     bytes4[] memory bytes4Array_;
245 
246       for( uint256 iteration_ = 0; _length( set_._inner ) >= iteration_; iteration_++ ){
247         bytes4Array_[iteration_] = bytes4( at( set_, iteration_ ) );
248       }
249 
250       return bytes4Array_;
251   }
252 
253   function insert( Bytes32Set storage set_, uint256 index_, bytes32 valueToInsert_ ) internal returns ( bool ) {
254     return _insert( set_._inner, index_, valueToInsert_ );
255   }
256 
257   // AddressSet
258   struct AddressSet {
259     Set _inner;
260   }
261 
262   /**
263    * @dev Add a value to a set. O(1).
264    *
265    * Returns true if the value was added to the set, that is if it was not
266    * already present.
267    */
268   function add(AddressSet storage set, address value) internal returns (bool) {
269     return _add(set._inner, bytes32(uint256(value)));
270   }
271 
272   /**
273    * @dev Removes a value from a set. O(1).
274    *
275    * Returns true if the value was removed from the set, that is if it was
276    * present.
277    */
278   function remove(AddressSet storage set, address value) internal returns (bool) {
279     return _remove(set._inner, bytes32(uint256(value)));
280   }
281 
282   /**
283    * @dev Returns true if the value is in the set. O(1).
284    */
285   function contains(AddressSet storage set, address value) internal view returns (bool) {
286     return _contains(set._inner, bytes32(uint256(value)));
287   }
288 
289   /**
290    * @dev Returns the number of values in the set. O(1).
291    */
292   function length(AddressSet storage set) internal view returns (uint256) {
293     return _length(set._inner);
294   }
295 
296   /**
297    * @dev Returns the value stored at position `index` in the set. O(1).
298    *
299    * Note that there are no guarantees on the ordering of values inside the
300    * array, and it may change when more values are added or removed.
301    *
302    * Requirements:
303    *
304    * - `index` must be strictly less than {length}.
305    */
306   function at(AddressSet storage set, uint256 index) internal view returns (address) {
307     return address(uint256(_at(set._inner, index)));
308   }
309 
310   /**
311    * TODO Might require explicit conversion of bytes32[] to address[].
312    *  Might require iteration.
313    */
314   function getValues( AddressSet storage set_ ) internal view returns ( address[] memory ) {
315 
316     address[] memory addressArray;
317 
318     for( uint256 iteration_ = 0; _length(set_._inner) >= iteration_; iteration_++ ){
319       addressArray[iteration_] = at( set_, iteration_ );
320     }
321 
322     return addressArray;
323   }
324 
325   function insert(AddressSet storage set_, uint256 index_, address valueToInsert_ ) internal returns ( bool ) {
326     return _insert( set_._inner, index_, bytes32(uint256(valueToInsert_)) );
327   }
328 
329 
330     // UintSet
331 
332     struct UintSet {
333         Set _inner;
334     }
335 
336     /**
337      * @dev Add a value to a set. O(1).
338      *
339      * Returns true if the value was added to the set, that is if it was not
340      * already present.
341      */
342     function add(UintSet storage set, uint256 value) internal returns (bool) {
343         return _add(set._inner, bytes32(value));
344     }
345 
346     /**
347      * @dev Removes a value from a set. O(1).
348      *
349      * Returns true if the value was removed from the set, that is if it was
350      * present.
351      */
352     function remove(UintSet storage set, uint256 value) internal returns (bool) {
353         return _remove(set._inner, bytes32(value));
354     }
355 
356     /**
357      * @dev Returns true if the value is in the set. O(1).
358      */
359     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
360         return _contains(set._inner, bytes32(value));
361     }
362 
363     /**
364      * @dev Returns the number of values on the set. O(1).
365      */
366     function length(UintSet storage set) internal view returns (uint256) {
367         return _length(set._inner);
368     }
369 
370    /**
371     * @dev Returns the value stored at position `index` in the set. O(1).
372     *
373     * Note that there are no guarantees on the ordering of values inside the
374     * array, and it may change when more values are added or removed.
375     *
376     * Requirements:
377     *
378     * - `index` must be strictly less than {length}.
379     */
380     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
381         return uint256(_at(set._inner, index));
382     }
383 
384     struct UInt256Set {
385         Set _inner;
386     }
387 
388     /**
389      * @dev Add a value to a set. O(1).
390      *
391      * Returns true if the value was added to the set, that is if it was not
392      * already present.
393      */
394     function add(UInt256Set storage set, uint256 value) internal returns (bool) {
395         return _add(set._inner, bytes32(value));
396     }
397 
398     /**
399      * @dev Removes a value from a set. O(1).
400      *
401      * Returns true if the value was removed from the set, that is if it was
402      * present.
403      */
404     function remove(UInt256Set storage set, uint256 value) internal returns (bool) {
405         return _remove(set._inner, bytes32(value));
406     }
407 
408     /**
409      * @dev Returns true if the value is in the set. O(1).
410      */
411     function contains(UInt256Set storage set, uint256 value) internal view returns (bool) {
412         return _contains(set._inner, bytes32(value));
413     }
414 
415     /**
416      * @dev Returns the number of values on the set. O(1).
417      */
418     function length(UInt256Set storage set) internal view returns (uint256) {
419         return _length(set._inner);
420     }
421 
422     /**
423      * @dev Returns the value stored at position `index` in the set. O(1).
424      *
425      * Note that there are no guarantees on the ordering of values inside the
426      * array, and it may change when more values are added or removed.
427      *
428      * Requirements:
429      *
430      * - `index` must be strictly less than {length}.
431      */
432     function at(UInt256Set storage set, uint256 index) internal view returns (uint256) {
433         return uint256(_at(set._inner, index));
434     }
435 }
436 
437 interface IERC20 {
438   /**
439    * @dev Returns the amount of tokens in existence.
440    */
441   function totalSupply() external view returns (uint256);
442 
443   /**
444    * @dev Returns the amount of tokens owned by `account`.
445    */
446   function balanceOf(address account) external view returns (uint256);
447 
448   /**
449    * @dev Moves `amount` tokens from the caller's account to `recipient`.
450    *
451    * Returns a boolean value indicating whether the operation succeeded.
452    *
453    * Emits a {Transfer} event.
454    */
455   function transfer(address recipient, uint256 amount) external returns (bool);
456 
457   /**
458    * @dev Returns the remaining number of tokens that `spender` will be
459    * allowed to spend on behalf of `owner` through {transferFrom}. This is
460    * zero by default.
461    *
462    * This value changes when {approve} or {transferFrom} are called.
463    */
464   function allowance(address owner, address spender) external view returns (uint256);
465 
466   /**
467    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
468    *
469    * Returns a boolean value indicating whether the operation succeeded.
470    *
471    * IMPORTANT: Beware that changing an allowance with this method brings the risk
472    * that someone may use both the old and the new allowance by unfortunate
473    * transaction ordering. One possible solution to mitigate this race
474    * condition is to first reduce the spender's allowance to 0 and set the
475    * desired value afterwards:
476    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
477    *
478    * Emits an {Approval} event.
479    */
480   function approve(address spender, uint256 amount) external returns (bool);
481 
482   /**
483    * @dev Moves `amount` tokens from `sender` to `recipient` using the
484    * allowance mechanism. `amount` is then deducted from the caller's
485    * allowance.
486    *
487    * Returns a boolean value indicating whether the operation succeeded.
488    *
489    * Emits a {Transfer} event.
490    */
491   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
492 
493   /**
494    * @dev Emitted when `value` tokens are moved from one account (`from`) to
495    * another (`to`).
496    *
497    * Note that `value` may be zero.
498    */
499   event Transfer(address indexed from, address indexed to, uint256 value);
500 
501   /**
502    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
503    * a call to {approve}. `value` is the new allowance.
504    */
505   event Approval(address indexed owner, address indexed spender, uint256 value);
506 }
507 
508 library SafeMath {
509 
510     function add(uint256 a, uint256 b) internal pure returns (uint256) {
511         uint256 c = a + b;
512         require(c >= a, "SafeMath: addition overflow");
513 
514         return c;
515     }
516 
517     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
518         return sub(a, b, "SafeMath: subtraction overflow");
519     }
520 
521     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
522         require(b <= a, errorMessage);
523         uint256 c = a - b;
524 
525         return c;
526     }
527 
528     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
529 
530         if (a == 0) {
531             return 0;
532         }
533 
534         uint256 c = a * b;
535         require(c / a == b, "SafeMath: multiplication overflow");
536 
537         return c;
538     }
539 
540     function div(uint256 a, uint256 b) internal pure returns (uint256) {
541         return div(a, b, "SafeMath: division by zero");
542     }
543 
544     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b > 0, errorMessage);
546         uint256 c = a / b;
547         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
548 
549         return c;
550     }
551 
552     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
553         return mod(a, b, "SafeMath: modulo by zero");
554     }
555 
556     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
557         require(b != 0, errorMessage);
558         return a % b;
559     }
560 
561     function sqrrt(uint256 a) internal pure returns (uint c) {
562         if (a > 3) {
563             c = a;
564             uint b = add( div( a, 2), 1 );
565             while (b < c) {
566                 c = b;
567                 b = div( add( div( a, b ), b), 2 );
568             }
569         } else if (a != 0) {
570             c = 1;
571         }
572     }
573 
574     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
575         return div( mul( total_, percentage_ ), 1000 );
576     }
577 
578     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
579         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
580     }
581 
582     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
583         return div( mul(part_, 100) , total_ );
584     }
585 
586     function average(uint256 a, uint256 b) internal pure returns (uint256) {
587         // (a + b) / 2 can overflow, so we distribute
588         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
589     }
590 
591     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
592         return sqrrt( mul( multiplier_, payment_ ) );
593     }
594 
595   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
596       return mul( multiplier_, supply_ );
597   }
598 }
599 
600 abstract contract ERC20 is IERC20 {
601 
602   using SafeMath for uint256;
603 
604   // TODO comment actual hash value.
605   bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
606     
607   // Present in ERC777
608   mapping (address => uint256) internal _balances;
609 
610   // Present in ERC777
611   mapping (address => mapping (address => uint256)) internal _allowances;
612 
613   // Present in ERC777
614   uint256 internal _totalSupply;
615 
616   // Present in ERC777
617   string internal _name;
618     
619   // Present in ERC777
620   string internal _symbol;
621     
622   // Present in ERC777
623   uint8 internal _decimals;
624 
625   constructor (string memory name_, string memory symbol_, uint8 decimals_) {
626     _name = name_;
627     _symbol = symbol_;
628     _decimals = decimals_;
629   }
630 
631   function name() public view returns (string memory) {
632     return _name;
633   }
634 
635   function symbol() public view returns (string memory) {
636     return _symbol;
637   }
638 
639   function decimals() public view returns (uint8) {
640     return _decimals;
641   }
642 
643   function totalSupply() public view override returns (uint256) {
644     return _totalSupply;
645   }
646 
647   function balanceOf(address account) public view virtual override returns (uint256) {
648     return _balances[account];
649   }
650 
651   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
652     _transfer(msg.sender, recipient, amount);
653     return true;
654   }
655 
656     function allowance(address owner, address spender) public view virtual override returns (uint256) {
657         return _allowances[owner][spender];
658     }
659 
660     function approve(address spender, uint256 amount) public virtual override returns (bool) {
661         _approve(msg.sender, spender, amount);
662         return true;
663     }
664 
665     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
666         _transfer(sender, recipient, amount);
667         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
668         return true;
669     }
670 
671     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
672         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
673         return true;
674     }
675 
676     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
677         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
678         return true;
679     }
680 
681     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
682       require(sender != address(0), "ERC20: transfer from the zero address");
683       require(recipient != address(0), "ERC20: transfer to the zero address");
684 
685       _beforeTokenTransfer(sender, recipient, amount);
686 
687       _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
688       _balances[recipient] = _balances[recipient].add(amount);
689       emit Transfer(sender, recipient, amount);
690     }
691 
692     function _mint(address account_, uint256 amount_) internal virtual {
693         require(account_ != address(0), "ERC20: mint to the zero address");
694         _beforeTokenTransfer(address( this ), account_, amount_);
695         _totalSupply = _totalSupply.add(amount_);
696         _balances[account_] = _balances[account_].add(amount_);
697         emit Transfer(address( this ), account_, amount_);
698     }
699 
700     function _burn(address account, uint256 amount) internal virtual {
701         require(account != address(0), "ERC20: burn from the zero address");
702 
703         _beforeTokenTransfer(account, address(0), amount);
704 
705         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
706         _totalSupply = _totalSupply.sub(amount);
707         emit Transfer(account, address(0), amount);
708     }
709 
710     function _approve(address owner, address spender, uint256 amount) internal virtual {
711         require(owner != address(0), "ERC20: approve from the zero address");
712         require(spender != address(0), "ERC20: approve to the zero address");
713 
714         _allowances[owner][spender] = amount;
715         emit Approval(owner, spender, amount);
716     }
717 
718   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
719 }
720 
721 library Counters {
722     using SafeMath for uint256;
723 
724     struct Counter {
725         uint256 _value; // default: 0
726     }
727 
728     function current(Counter storage counter) internal view returns (uint256) {
729         return counter._value;
730     }
731 
732     function increment(Counter storage counter) internal {
733         counter._value += 1;
734     }
735 
736     function decrement(Counter storage counter) internal {
737         counter._value = counter._value.sub(1);
738     }
739 }
740 
741 interface IERC2612Permit {
742 
743     function permit(
744         address owner,
745         address spender,
746         uint256 amount,
747         uint256 deadline,
748         uint8 v,
749         bytes32 r,
750         bytes32 s
751     ) external;
752 
753     function nonces(address owner) external view returns (uint256);
754 }
755 
756 abstract contract ERC20Permit is ERC20, IERC2612Permit {
757     using Counters for Counters.Counter;
758 
759     mapping(address => Counters.Counter) private _nonces;
760 
761     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
762     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
763 
764     bytes32 public DOMAIN_SEPARATOR;
765 
766     constructor() {
767         uint256 chainID;
768         assembly {
769             chainID := chainid()
770         }
771 
772         DOMAIN_SEPARATOR = keccak256(
773             abi.encode(
774                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
775                 keccak256(bytes(name())),
776                 keccak256(bytes("1")), // Version
777                 chainID,
778                 address(this)
779             )
780         );
781     }
782 
783     function permit(
784         address owner,
785         address spender,
786         uint256 amount,
787         uint256 deadline,
788         uint8 v,
789         bytes32 r,
790         bytes32 s
791     ) public virtual override {
792         require(block.timestamp <= deadline, "Permit: expired deadline");
793 
794         bytes32 hashStruct =
795             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
796 
797         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
798 
799         address signer = ecrecover(_hash, v, r, s);
800         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
801 
802         _nonces[owner].increment();
803         _approve(owner, spender, amount);
804     }
805 
806     function nonces(address owner) public view override returns (uint256) {
807         return _nonces[owner].current();
808     }
809 }
810 
811 interface IOwnable {
812   function owner() external view returns (address);
813 
814   function renounceOwnership() external;
815   
816   function transferOwnership( address newOwner_ ) external;
817 }
818 
819 contract Ownable is IOwnable {
820     
821   address internal _owner;
822 
823   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
824 
825   constructor () {
826     _owner = msg.sender;
827     emit OwnershipTransferred( address(0), _owner );
828   }
829 
830   function owner() public view override returns (address) {
831     return _owner;
832   }
833 
834   modifier onlyOwner() {
835     require( _owner == msg.sender, "Ownable: caller is not the owner" );
836     _;
837   }
838 
839   function renounceOwnership() public virtual override onlyOwner() {
840     emit OwnershipTransferred( _owner, address(0) );
841     _owner = address(0);
842   }
843 
844   function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
845     require( newOwner_ != address(0), "Ownable: new owner is the zero address");
846     emit OwnershipTransferred( _owner, newOwner_ );
847     _owner = newOwner_;
848   }
849 }
850 
851 contract VaultOwned is Ownable {
852     
853   address internal _vault;
854 
855   function setVault( address vault_ ) external onlyOwner() returns ( bool ) {
856     _vault = vault_;
857 
858     return true;
859   }
860 
861   function vault() public view returns (address) {
862     return _vault;
863   }
864 
865   modifier onlyVault() {
866     require( _vault == msg.sender, "VaultOwned: caller is not the Vault" );
867     _;
868   }
869 
870 }
871 
872 contract OlympusERC20Token is ERC20Permit, VaultOwned {
873 
874     using SafeMath for uint256;
875 
876     constructor() ERC20("Cerberus", "3DOG", 9) {
877     }
878 
879     function mint(address account_, uint256 amount_) external onlyVault() {
880         _mint(account_, amount_);
881     }
882 
883     function burn(uint256 amount) public virtual {
884         _burn(msg.sender, amount);
885     }
886      
887     function burnFrom(address account_, uint256 amount_) public virtual {
888         _burnFrom(account_, amount_);
889     }
890 
891     function _burnFrom(address account_, uint256 amount_) public virtual {
892         uint256 decreasedAllowance_ =
893             allowance(account_, msg.sender).sub(
894                 amount_,
895                 "ERC20: burn amount exceeds allowance"
896             );
897 
898         _approve(account_, msg.sender, decreasedAllowance_);
899         _burn(account_, amount_);
900     }
901 }