1 // File: contracts/BTRFLY.sol
2 
3 
4 pragma solidity 0.7.5;
5 
6 library EnumerableSet {
7 
8   // To implement this library for multiple types with as little code
9   // repetition as possible, we write it in terms of a generic Set type with
10   // bytes32 values.
11   // The Set implementation uses private functions, and user-facing
12   // implementations (such as AddressSet) are just wrappers around the
13   // underlying Set.
14   // This means that we can only create new EnumerableSets for types that fit
15   // in bytes32.
16   struct Set {
17     // Storage of set values
18     bytes32[] _values;
19 
20     // Position of the value in the `values` array, plus 1 because index 0
21     // means a value is not in the set.
22     mapping (bytes32 => uint256) _indexes;
23   }
24 
25   /**
26    * @dev Add a value to a set. O(1).
27    *
28    * Returns true if the value was added to the set, that is if it was not
29    * already present.
30    */
31   function _add(Set storage set, bytes32 value) private returns (bool) {
32     if (!_contains(set, value)) {
33       set._values.push(value);
34       // The value is stored at length-1, but we add 1 to all indexes
35       // and use 0 as a sentinel value
36       set._indexes[value] = set._values.length;
37       return true;
38     } else {
39       return false;
40     }
41   }
42 
43   /**
44    * @dev Removes a value from a set. O(1).
45    *
46    * Returns true if the value was removed from the set, that is if it was
47    * present.
48    */
49   function _remove(Set storage set, bytes32 value) private returns (bool) {
50     // We read and store the value's index to prevent multiple reads from the same storage slot
51     uint256 valueIndex = set._indexes[value];
52 
53     if (valueIndex != 0) { // Equivalent to contains(set, value)
54       // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
55       // the array, and then remove the last element (sometimes called as 'swap and pop').
56       // This modifies the order of the array, as noted in {at}.
57 
58       uint256 toDeleteIndex = valueIndex - 1;
59       uint256 lastIndex = set._values.length - 1;
60 
61       // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
62       // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
63 
64       bytes32 lastvalue = set._values[lastIndex];
65 
66       // Move the last value to the index where the value to delete is
67       set._values[toDeleteIndex] = lastvalue;
68       // Update the index for the moved value
69       set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
70 
71       // Delete the slot where the moved value was stored
72       set._values.pop();
73 
74       // Delete the index for the deleted slot
75       delete set._indexes[value];
76 
77       return true;
78     } else {
79       return false;
80     }
81   }
82 
83   /**
84    * @dev Returns true if the value is in the set. O(1).
85    */
86   function _contains(Set storage set, bytes32 value) private view returns (bool) {
87     return set._indexes[value] != 0;
88   }
89 
90   /**
91    * @dev Returns the number of values on the set. O(1).
92    */
93   function _length(Set storage set) private view returns (uint256) {
94     return set._values.length;
95   }
96 
97    /**
98     * @dev Returns the value stored at position `index` in the set. O(1).
99     *
100     * Note that there are no guarantees on the ordering of values inside the
101     * array, and it may change when more values are added or removed.
102     *
103     * Requirements:
104     *
105     * - `index` must be strictly less than {length}.
106     */
107   function _at(Set storage set, uint256 index) private view returns (bytes32) {
108     require(set._values.length > index, "EnumerableSet: index out of bounds");
109     return set._values[index];
110   }
111 
112   function _getValues( Set storage set_ ) private view returns ( bytes32[] storage ) {
113     return set_._values;
114   }
115 
116   // TODO needs insert function that maintains order.
117   // TODO needs NatSpec documentation comment.
118   /**
119    * Inserts new value by moving existing value at provided index to end of array and setting provided value at provided index
120    */
121   function _insert(Set storage set_, uint256 index_, bytes32 valueToInsert_ ) private returns ( bool ) {
122     require(  set_._values.length > index_ );
123     require( !_contains( set_, valueToInsert_ ), "Remove value you wish to insert if you wish to reorder array." );
124     bytes32 existingValue_ = _at( set_, index_ );
125     set_._values[index_] = valueToInsert_;
126     return _add( set_, existingValue_);
127   } 
128 
129   struct Bytes4Set {
130     Set _inner;
131   }
132 
133   /**
134    * @dev Add a value to a set. O(1).
135    *
136    * Returns true if the value was added to the set, that is if it was not
137    * already present.
138    */
139   function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
140     return _add(set._inner, value);
141   }
142 
143   /**
144    * @dev Removes a value from a set. O(1).
145    *
146    * Returns true if the value was removed from the set, that is if it was
147    * present.
148    */
149   function remove(Bytes4Set storage set, bytes4 value) internal returns (bool) {
150     return _remove(set._inner, value);
151   }
152 
153   /**
154    * @dev Returns true if the value is in the set. O(1).
155    */
156   function contains(Bytes4Set storage set, bytes4 value) internal view returns (bool) {
157     return _contains(set._inner, value);
158   }
159 
160   /**
161    * @dev Returns the number of values on the set. O(1).
162    */
163   function length(Bytes4Set storage set) internal view returns (uint256) {
164     return _length(set._inner);
165   }
166 
167   /**
168    * @dev Returns the value stored at position `index` in the set. O(1).
169    *
170    * Note that there are no guarantees on the ordering of values inside the
171    * array, and it may change when more values are added or removed.
172    *
173    * Requirements:
174    *
175    * - `index` must be strictly less than {length}.
176    */
177   function at(Bytes4Set storage set, uint256 index) internal view returns ( bytes4 ) {
178     return bytes4( _at( set._inner, index ) );
179   }
180 
181   function getValues( Bytes4Set storage set_ ) internal view returns ( bytes4[] memory ) {
182     bytes4[] memory bytes4Array_;
183     for( uint256 iteration_ = 0; _length( set_._inner ) > iteration_; iteration_++ ) {
184       bytes4Array_[iteration_] = bytes4( _at( set_._inner, iteration_ ) );
185     }
186     return bytes4Array_;
187   }
188 
189   function insert( Bytes4Set storage set_, uint256 index_, bytes4 valueToInsert_ ) internal returns ( bool ) {
190     return _insert( set_._inner, index_, valueToInsert_ );
191   }
192 
193     struct Bytes32Set {
194         Set _inner;
195     }
196 
197     /**
198      * @dev Add a value to a set. O(1).
199      *
200      * Returns true if the value was added to the set, that is if it was not
201      * already present.
202      */
203     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
204         return _add(set._inner, value);
205     }
206 
207     /**
208      * @dev Removes a value from a set. O(1).
209      *
210      * Returns true if the value was removed from the set, that is if it was
211      * present.
212      */
213     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
214         return _remove(set._inner, value);
215     }
216 
217     /**
218      * @dev Returns true if the value is in the set. O(1).
219      */
220     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
221         return _contains(set._inner, value);
222     }
223 
224     /**
225      * @dev Returns the number of values on the set. O(1).
226      */
227     function length(Bytes32Set storage set) internal view returns (uint256) {
228         return _length(set._inner);
229     }
230 
231     /**
232      * @dev Returns the value stored at position `index` in the set. O(1).
233      *
234      * Note that there are no guarantees on the ordering of values inside the
235      * array, and it may change when more values are added or removed.
236      *
237      * Requirements:
238      *
239      * - `index` must be strictly less than {length}.
240      */
241     function at(Bytes32Set storage set, uint256 index) internal view returns ( bytes32 ) {
242         return _at(set._inner, index);
243     }
244 
245   function getValues( Bytes32Set storage set_ ) internal view returns ( bytes4[] memory ) {
246     bytes4[] memory bytes4Array_;
247 
248       for( uint256 iteration_ = 0; _length( set_._inner ) >= iteration_; iteration_++ ){
249         bytes4Array_[iteration_] = bytes4( at( set_, iteration_ ) );
250       }
251 
252       return bytes4Array_;
253   }
254 
255   function insert( Bytes32Set storage set_, uint256 index_, bytes32 valueToInsert_ ) internal returns ( bool ) {
256     return _insert( set_._inner, index_, valueToInsert_ );
257   }
258 
259   // AddressSet
260   struct AddressSet {
261     Set _inner;
262   }
263 
264   /**
265    * @dev Add a value to a set. O(1).
266    *
267    * Returns true if the value was added to the set, that is if it was not
268    * already present.
269    */
270   function add(AddressSet storage set, address value) internal returns (bool) {
271     return _add(set._inner, bytes32(uint256(value)));
272   }
273 
274   /**
275    * @dev Removes a value from a set. O(1).
276    *
277    * Returns true if the value was removed from the set, that is if it was
278    * present.
279    */
280   function remove(AddressSet storage set, address value) internal returns (bool) {
281     return _remove(set._inner, bytes32(uint256(value)));
282   }
283 
284   /**
285    * @dev Returns true if the value is in the set. O(1).
286    */
287   function contains(AddressSet storage set, address value) internal view returns (bool) {
288     return _contains(set._inner, bytes32(uint256(value)));
289   }
290 
291   /**
292    * @dev Returns the number of values in the set. O(1).
293    */
294   function length(AddressSet storage set) internal view returns (uint256) {
295     return _length(set._inner);
296   }
297 
298   /**
299    * @dev Returns the value stored at position `index` in the set. O(1).
300    *
301    * Note that there are no guarantees on the ordering of values inside the
302    * array, and it may change when more values are added or removed.
303    *
304    * Requirements:
305    *
306    * - `index` must be strictly less than {length}.
307    */
308   function at(AddressSet storage set, uint256 index) internal view returns (address) {
309     return address(uint256(_at(set._inner, index)));
310   }
311 
312   /**
313    * TODO Might require explicit conversion of bytes32[] to address[].
314    *  Might require iteration.
315    */
316   function getValues( AddressSet storage set_ ) internal view returns ( address[] memory ) {
317 
318     address[] memory addressArray;
319 
320     for( uint256 iteration_ = 0; _length(set_._inner) >= iteration_; iteration_++ ){
321       addressArray[iteration_] = at( set_, iteration_ );
322     }
323 
324     return addressArray;
325   }
326 
327   function insert(AddressSet storage set_, uint256 index_, address valueToInsert_ ) internal returns ( bool ) {
328     return _insert( set_._inner, index_, bytes32(uint256(valueToInsert_)) );
329   }
330 
331 
332     // UintSet
333 
334     struct UintSet {
335         Set _inner;
336     }
337 
338     /**
339      * @dev Add a value to a set. O(1).
340      *
341      * Returns true if the value was added to the set, that is if it was not
342      * already present.
343      */
344     function add(UintSet storage set, uint256 value) internal returns (bool) {
345         return _add(set._inner, bytes32(value));
346     }
347 
348     /**
349      * @dev Removes a value from a set. O(1).
350      *
351      * Returns true if the value was removed from the set, that is if it was
352      * present.
353      */
354     function remove(UintSet storage set, uint256 value) internal returns (bool) {
355         return _remove(set._inner, bytes32(value));
356     }
357 
358     /**
359      * @dev Returns true if the value is in the set. O(1).
360      */
361     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
362         return _contains(set._inner, bytes32(value));
363     }
364 
365     /**
366      * @dev Returns the number of values on the set. O(1).
367      */
368     function length(UintSet storage set) internal view returns (uint256) {
369         return _length(set._inner);
370     }
371 
372    /**
373     * @dev Returns the value stored at position `index` in the set. O(1).
374     *
375     * Note that there are no guarantees on the ordering of values inside the
376     * array, and it may change when more values are added or removed.
377     *
378     * Requirements:
379     *
380     * - `index` must be strictly less than {length}.
381     */
382     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
383         return uint256(_at(set._inner, index));
384     }
385 
386     struct UInt256Set {
387         Set _inner;
388     }
389 
390     /**
391      * @dev Add a value to a set. O(1).
392      *
393      * Returns true if the value was added to the set, that is if it was not
394      * already present.
395      */
396     function add(UInt256Set storage set, uint256 value) internal returns (bool) {
397         return _add(set._inner, bytes32(value));
398     }
399 
400     /**
401      * @dev Removes a value from a set. O(1).
402      *
403      * Returns true if the value was removed from the set, that is if it was
404      * present.
405      */
406     function remove(UInt256Set storage set, uint256 value) internal returns (bool) {
407         return _remove(set._inner, bytes32(value));
408     }
409 
410     /**
411      * @dev Returns true if the value is in the set. O(1).
412      */
413     function contains(UInt256Set storage set, uint256 value) internal view returns (bool) {
414         return _contains(set._inner, bytes32(value));
415     }
416 
417     /**
418      * @dev Returns the number of values on the set. O(1).
419      */
420     function length(UInt256Set storage set) internal view returns (uint256) {
421         return _length(set._inner);
422     }
423 
424     /**
425      * @dev Returns the value stored at position `index` in the set. O(1).
426      *
427      * Note that there are no guarantees on the ordering of values inside the
428      * array, and it may change when more values are added or removed.
429      *
430      * Requirements:
431      *
432      * - `index` must be strictly less than {length}.
433      */
434     function at(UInt256Set storage set, uint256 index) internal view returns (uint256) {
435         return uint256(_at(set._inner, index));
436     }
437 }
438 
439 interface IERC20 {
440   /**
441    * @dev Returns the amount of tokens in existence.
442    */
443   function totalSupply() external view returns (uint256);
444 
445   /**
446    * @dev Returns the amount of tokens owned by `account`.
447    */
448   function balanceOf(address account) external view returns (uint256);
449 
450   /**
451    * @dev Moves `amount` tokens from the caller's account to `recipient`.
452    *
453    * Returns a boolean value indicating whether the operation succeeded.
454    *
455    * Emits a {Transfer} event.
456    */
457   function transfer(address recipient, uint256 amount) external returns (bool);
458 
459   /**
460    * @dev Returns the remaining number of tokens that `spender` will be
461    * allowed to spend on behalf of `owner` through {transferFrom}. This is
462    * zero by default.
463    *
464    * This value changes when {approve} or {transferFrom} are called.
465    */
466   function allowance(address owner, address spender) external view returns (uint256);
467 
468   /**
469    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
470    *
471    * Returns a boolean value indicating whether the operation succeeded.
472    *
473    * IMPORTANT: Beware that changing an allowance with this method brings the risk
474    * that someone may use both the old and the new allowance by unfortunate
475    * transaction ordering. One possible solution to mitigate this race
476    * condition is to first reduce the spender's allowance to 0 and set the
477    * desired value afterwards:
478    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
479    *
480    * Emits an {Approval} event.
481    */
482   function approve(address spender, uint256 amount) external returns (bool);
483 
484   /**
485    * @dev Moves `amount` tokens from `sender` to `recipient` using the
486    * allowance mechanism. `amount` is then deducted from the caller's
487    * allowance.
488    *
489    * Returns a boolean value indicating whether the operation succeeded.
490    *
491    * Emits a {Transfer} event.
492    */
493   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
494 
495   /**
496    * @dev Emitted when `value` tokens are moved from one account (`from`) to
497    * another (`to`).
498    *
499    * Note that `value` may be zero.
500    */
501   event Transfer(address indexed from, address indexed to, uint256 value);
502 
503   /**
504    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
505    * a call to {approve}. `value` is the new allowance.
506    */
507   event Approval(address indexed owner, address indexed spender, uint256 value);
508 }
509 
510 library SafeMath {
511 
512     function add(uint256 a, uint256 b) internal pure returns (uint256) {
513         uint256 c = a + b;
514         require(c >= a, "SafeMath: addition overflow");
515 
516         return c;
517     }
518 
519     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
520         return sub(a, b, "SafeMath: subtraction overflow");
521     }
522 
523     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b <= a, errorMessage);
525         uint256 c = a - b;
526 
527         return c;
528     }
529 
530     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
531 
532         if (a == 0) {
533             return 0;
534         }
535 
536         uint256 c = a * b;
537         require(c / a == b, "SafeMath: multiplication overflow");
538 
539         return c;
540     }
541 
542     function div(uint256 a, uint256 b) internal pure returns (uint256) {
543         return div(a, b, "SafeMath: division by zero");
544     }
545 
546     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
547         require(b > 0, errorMessage);
548         uint256 c = a / b;
549         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
550 
551         return c;
552     }
553 
554     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
555         return mod(a, b, "SafeMath: modulo by zero");
556     }
557 
558     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
559         require(b != 0, errorMessage);
560         return a % b;
561     }
562 
563     function sqrrt(uint256 a) internal pure returns (uint c) {
564         if (a > 3) {
565             c = a;
566             uint b = add( div( a, 2), 1 );
567             while (b < c) {
568                 c = b;
569                 b = div( add( div( a, b ), b), 2 );
570             }
571         } else if (a != 0) {
572             c = 1;
573         }
574     }
575 
576     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
577         return div( mul( total_, percentage_ ), 1000 );
578     }
579 
580     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
581         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
582     }
583 
584     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
585         return div( mul(part_, 100) , total_ );
586     }
587 
588     function average(uint256 a, uint256 b) internal pure returns (uint256) {
589         // (a + b) / 2 can overflow, so we distribute
590         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
591     }
592 
593     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
594         return sqrrt( mul( multiplier_, payment_ ) );
595     }
596 
597   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
598       return mul( multiplier_, supply_ );
599   }
600 }
601 
602 abstract contract ERC20 is IERC20 {
603 
604   using SafeMath for uint256;
605 
606   // TODO comment actual hash value.
607   bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
608     
609   // Present in ERC777
610   mapping (address => uint256) internal _balances;
611 
612   // Present in ERC777
613   mapping (address => mapping (address => uint256)) internal _allowances;
614 
615   // Present in ERC777
616   uint256 internal _totalSupply;
617 
618   // Present in ERC777
619   string internal _name;
620     
621   // Present in ERC777
622   string internal _symbol;
623     
624   // Present in ERC777
625   uint8 internal _decimals;
626 
627   constructor (string memory name_, string memory symbol_, uint8 decimals_) {
628     _name = name_;
629     _symbol = symbol_;
630     _decimals = decimals_;
631   }
632 
633   function name() public view returns (string memory) {
634     return _name;
635   }
636 
637   function symbol() public view returns (string memory) {
638     return _symbol;
639   }
640 
641   function decimals() public view returns (uint8) {
642     return _decimals;
643   }
644 
645   function totalSupply() public view override returns (uint256) {
646     return _totalSupply;
647   }
648 
649   function balanceOf(address account) public view virtual override returns (uint256) {
650     return _balances[account];
651   }
652 
653   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
654     _transfer(msg.sender, recipient, amount);
655     return true;
656   }
657 
658     function allowance(address owner, address spender) public view virtual override returns (uint256) {
659         return _allowances[owner][spender];
660     }
661 
662     function approve(address spender, uint256 amount) public virtual override returns (bool) {
663         _approve(msg.sender, spender, amount);
664         return true;
665     }
666 
667     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
668         _transfer(sender, recipient, amount);
669         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
670         return true;
671     }
672 
673     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
674         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
675         return true;
676     }
677 
678     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
679         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
680         return true;
681     }
682 
683     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
684       require(sender != address(0), "ERC20: transfer from the zero address");
685       require(recipient != address(0), "ERC20: transfer to the zero address");
686 
687       _beforeTokenTransfer(sender, recipient, amount);
688 
689       _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
690       _balances[recipient] = _balances[recipient].add(amount);
691       emit Transfer(sender, recipient, amount);
692     }
693 
694     function _mint(address account_, uint256 amount_) internal virtual {
695         require(account_ != address(0), "ERC20: mint to the zero address");
696         _beforeTokenTransfer(address( this ), account_, amount_);
697         _totalSupply = _totalSupply.add(amount_);
698         _balances[account_] = _balances[account_].add(amount_);
699         emit Transfer(address( this ), account_, amount_);
700     }
701 
702     function _burn(address account, uint256 amount) internal virtual {
703         require(account != address(0), "ERC20: burn from the zero address");
704 
705         _beforeTokenTransfer(account, address(0), amount);
706 
707         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
708         _totalSupply = _totalSupply.sub(amount);
709         emit Transfer(account, address(0), amount);
710     }
711 
712     function _approve(address owner, address spender, uint256 amount) internal virtual {
713         require(owner != address(0), "ERC20: approve from the zero address");
714         require(spender != address(0), "ERC20: approve to the zero address");
715 
716         _allowances[owner][spender] = amount;
717         emit Approval(owner, spender, amount);
718     }
719 
720   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
721 }
722 
723 library Counters {
724     using SafeMath for uint256;
725 
726     struct Counter {
727         uint256 _value; // default: 0
728     }
729 
730     function current(Counter storage counter) internal view returns (uint256) {
731         return counter._value;
732     }
733 
734     function increment(Counter storage counter) internal {
735         counter._value += 1;
736     }
737 
738     function decrement(Counter storage counter) internal {
739         counter._value = counter._value.sub(1);
740     }
741 }
742 
743 interface IERC2612Permit {
744 
745     function permit(
746         address owner,
747         address spender,
748         uint256 amount,
749         uint256 deadline,
750         uint8 v,
751         bytes32 r,
752         bytes32 s
753     ) external;
754 
755     function nonces(address owner) external view returns (uint256);
756 }
757 
758 abstract contract ERC20Permit is ERC20, IERC2612Permit {
759     using Counters for Counters.Counter;
760 
761     mapping(address => Counters.Counter) private _nonces;
762 
763     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
764     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
765 
766     bytes32 public DOMAIN_SEPARATOR;
767 
768     constructor() {
769         uint256 chainID;
770         assembly {
771             chainID := chainid()
772         }
773 
774         DOMAIN_SEPARATOR = keccak256(
775             abi.encode(
776                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
777                 keccak256(bytes(name())),
778                 keccak256(bytes("1")), // Version
779                 chainID,
780                 address(this)
781             )
782         );
783     }
784 
785     function permit(
786         address owner,
787         address spender,
788         uint256 amount,
789         uint256 deadline,
790         uint8 v,
791         bytes32 r,
792         bytes32 s
793     ) public virtual override {
794         require(block.timestamp <= deadline, "Permit: expired deadline");
795 
796         bytes32 hashStruct =
797             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
798 
799         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
800 
801         address signer = ecrecover(_hash, v, r, s);
802         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
803 
804         _nonces[owner].increment();
805         _approve(owner, spender, amount);
806     }
807 
808     function nonces(address owner) public view override returns (uint256) {
809         return _nonces[owner].current();
810     }
811 }
812 
813 interface IOwnable {
814   function owner() external view returns (address);
815 
816   function renounceOwnership() external;
817   
818   function transferOwnership( address newOwner_ ) external;
819 }
820 
821 contract Ownable is IOwnable {
822     
823   address internal _owner;
824 
825   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
826 
827   constructor () {
828     _owner = msg.sender;
829     emit OwnershipTransferred( address(0), _owner );
830   }
831 
832   function owner() public view override returns (address) {
833     return _owner;
834   }
835 
836   modifier onlyOwner() {
837     require( _owner == msg.sender, "Ownable: caller is not the owner" );
838     _;
839   }
840 
841   function renounceOwnership() public virtual override onlyOwner() {
842     emit OwnershipTransferred( _owner, address(0) );
843     _owner = address(0);
844   }
845 
846   function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
847     require( newOwner_ != address(0), "Ownable: new owner is the zero address");
848     emit OwnershipTransferred( _owner, newOwner_ );
849     _owner = newOwner_;
850   }
851 }
852 
853 contract VaultOwned is Ownable {
854     
855   address internal _vault;
856 
857   function setVault( address vault_ ) public onlyOwner() returns ( bool ) {
858     _vault = vault_;
859 
860     return true;
861   }
862 
863   function vault() public view returns (address) {
864     return _vault;
865   }
866 
867   modifier onlyVault() {
868     require( _vault == msg.sender, "VaultOwned: caller is not the Vault" );
869     _;
870   }
871 
872 }
873 
874 
875 abstract contract FrozenToken is ERC20Permit, Ownable {
876 
877   using SafeMath for uint256;
878 
879   bool public isTokenFrozen = true;
880   mapping (address => bool ) public isAuthorisedOperators;
881 
882 
883   modifier onlyAuthorisedOperators () {
884     require(!isTokenFrozen || isAuthorisedOperators[msg.sender], 'Frozen: token frozen or msg.sender not authorised');
885     _;
886   }
887 
888 
889   function unFreezeToken () external onlyOwner () {
890     isTokenFrozen = false;
891   }
892 
893   function changeAuthorisation (address operator, bool status) public onlyOwner {
894     require(operator != address(0), "Frozen: new operator cant be zero address");
895     isAuthorisedOperators[operator] = status; 
896   }
897 
898 
899   function addBatchAuthorisedOperators(address[] memory authorisedOperatorsArray) external onlyOwner {
900     for (uint i = 0; i < authorisedOperatorsArray.length; i++) {
901     changeAuthorisation(authorisedOperatorsArray[i],true);
902     }
903   }
904 
905 
906   function transfer(address recipient, uint256 amount) public virtual override onlyAuthorisedOperators returns (bool){
907   _transfer(msg.sender, recipient, amount);
908     return true;
909   }
910 
911   function transferFrom(address sender, address recipient, uint256 amount) public virtual override onlyAuthorisedOperators returns (bool) {
912     _transfer(sender, recipient, amount);
913     _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
914     return true;
915   }
916 
917 }
918 
919 contract BTRFLY is VaultOwned, FrozenToken {
920   using SafeMath for uint256;
921 
922   constructor() ERC20("BTRFLY", "BTRFLY", 9) ERC20Permit() {
923     setVault(msg.sender);
924   }
925 
926   function mint(address account_, uint256 amount_) external onlyVault() {
927   _mint(account_, amount_);
928   }
929 
930   function burn(uint256 amount) public virtual {
931     _burn(msg.sender, amount);
932   }
933   
934   function burnFrom(address account_, uint256 amount_) public virtual {
935     _burnFrom(account_, amount_);
936   }
937 
938   function _burnFrom(address account_, uint256 amount_) public virtual {
939     uint256 decreasedAllowance_ =
940         allowance(account_, msg.sender).sub(
941             amount_,
942             "ERC20: burn amount exceeds allowance"
943         );
944 
945     _approve(account_, msg.sender, decreasedAllowance_);
946     _burn(account_, amount_);
947   }
948   
949 }