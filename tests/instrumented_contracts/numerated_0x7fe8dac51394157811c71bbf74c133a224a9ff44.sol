1 /*
2   Website: https://liquidswap.trade
3   Telegram: https://t.me/liquidswapdefi
4   Twitter: https://twitter.com/LiquidSwapDeFi
5   Discord: https://discord.com/invite/LiquidSwap
6   Gitbook: https://docs.liquidswap.trade/
7 */
8 
9 // SPDX-License-Identifier: AGPL-3.0-or-later
10 pragma solidity 0.7.5;
11 
12 library EnumerableSet {
13 
14   // To implement this library for multiple types with as little code
15   // repetition as possible, we write it in terms of a generic Set type with
16   // bytes32 values.
17   // The Set implementation uses private functions, and user-facing
18   // implementations (such as AddressSet) are just wrappers around the
19   // underlying Set.
20   // This means that we can only create new EnumerableSets for types that fit
21   // in bytes32.
22   struct Set {
23     // Storage of set values
24     bytes32[] _values;
25 
26     // Position of the value in the `values` array, plus 1 because index 0
27     // means a value is not in the set.
28     mapping (bytes32 => uint256) _indexes;
29   }
30 
31   /**
32    * @dev Add a value to a set. O(1).
33    *
34    * Returns true if the value was added to the set, that is if it was not
35    * already present.
36    */
37   function _add(Set storage set, bytes32 value) private returns (bool) {
38     if (!_contains(set, value)) {
39       set._values.push(value);
40       // The value is stored at length-1, but we add 1 to all indexes
41       // and use 0 as a sentinel value
42       set._indexes[value] = set._values.length;
43       return true;
44     } else {
45       return false;
46     }
47   }
48 
49   /**
50    * @dev Removes a value from a set. O(1).
51    *
52    * Returns true if the value was removed from the set, that is if it was
53    * present.
54    */
55   function _remove(Set storage set, bytes32 value) private returns (bool) {
56     // We read and store the value's index to prevent multiple reads from the same storage slot
57     uint256 valueIndex = set._indexes[value];
58 
59     if (valueIndex != 0) { // Equivalent to contains(set, value)
60       // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
61       // the array, and then remove the last element (sometimes called as 'swap and pop').
62       // This modifies the order of the array, as noted in {at}.
63 
64       uint256 toDeleteIndex = valueIndex - 1;
65       uint256 lastIndex = set._values.length - 1;
66 
67       // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
68       // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
69 
70       bytes32 lastvalue = set._values[lastIndex];
71 
72       // Move the last value to the index where the value to delete is
73       set._values[toDeleteIndex] = lastvalue;
74       // Update the index for the moved value
75       set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
76 
77       // Delete the slot where the moved value was stored
78       set._values.pop();
79 
80       // Delete the index for the deleted slot
81       delete set._indexes[value];
82 
83       return true;
84     } else {
85       return false;
86     }
87   }
88 
89   /**
90    * @dev Returns true if the value is in the set. O(1).
91    */
92   function _contains(Set storage set, bytes32 value) private view returns (bool) {
93     return set._indexes[value] != 0;
94   }
95 
96   /**
97    * @dev Returns the number of values on the set. O(1).
98    */
99   function _length(Set storage set) private view returns (uint256) {
100     return set._values.length;
101   }
102 
103    /**
104     * @dev Returns the value stored at position `index` in the set. O(1).
105     *
106     * Note that there are no guarantees on the ordering of values inside the
107     * array, and it may change when more values are added or removed.
108     *
109     * Requirements:
110     *
111     * - `index` must be strictly less than {length}.
112     */
113   function _at(Set storage set, uint256 index) private view returns (bytes32) {
114     require(set._values.length > index, "EnumerableSet: index out of bounds");
115     return set._values[index];
116   }
117 
118   function _getValues( Set storage set_ ) private view returns ( bytes32[] storage ) {
119     return set_._values;
120   }
121 
122   // TODO needs insert function that maintains order.
123   // TODO needs NatSpec documentation comment.
124   /**
125    * Inserts new value by moving existing value at provided index to end 
126    * of array and setting provided value at provided index
127    */
128   function _insert(Set storage set_, uint256 index_, bytes32 valueToInsert_ ) private returns ( bool ) {
129     require(  set_._values.length > index_ );
130     require( !_contains( set_, valueToInsert_ ), "Remove value you wish to insert if you wish to reorder array." );
131     bytes32 existingValue_ = _at( set_, index_ );
132     set_._values[index_] = valueToInsert_;
133     return _add( set_, existingValue_);
134   } 
135 
136   struct Bytes4Set {
137     Set _inner;
138   }
139 
140   /**
141    * @dev Add a value to a set. O(1).
142    *
143    * Returns true if the value was added to the set, that is if it was not
144    * already present.
145    */
146   function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
147     return _add(set._inner, value);
148   }
149 
150   /**
151    * @dev Removes a value from a set. O(1).
152    *
153    * Returns true if the value was removed from the set, that is if it was
154    * present.
155    */
156   function remove(Bytes4Set storage set, bytes4 value) internal returns (bool) {
157     return _remove(set._inner, value);
158   }
159 
160   /**
161    * @dev Returns true if the value is in the set. O(1).
162    */
163   function contains(Bytes4Set storage set, bytes4 value) internal view returns (bool) {
164     return _contains(set._inner, value);
165   }
166 
167   /**
168    * @dev Returns the number of values on the set. O(1).
169    */
170   function length(Bytes4Set storage set) internal view returns (uint256) {
171     return _length(set._inner);
172   }
173 
174   /**
175    * @dev Returns the value stored at position `index` in the set. O(1).
176    *
177    * Note that there are no guarantees on the ordering of values inside the
178    * array, and it may change when more values are added or removed.
179    *
180    * Requirements:
181    *
182    * - `index` must be strictly less than {length}.
183    */
184   function at(Bytes4Set storage set, uint256 index) internal view returns ( bytes4 ) {
185     return bytes4( _at( set._inner, index ) );
186   }
187 
188   function getValues( Bytes4Set storage set_ ) internal view returns ( bytes4[] memory ) {
189     bytes4[] memory bytes4Array_;
190     for( uint256 iteration_ = 0; _length( set_._inner ) > iteration_; iteration_++ ) {
191       bytes4Array_[iteration_] = bytes4( _at( set_._inner, iteration_ ) );
192     }
193     return bytes4Array_;
194   }
195 
196   function insert( Bytes4Set storage set_, uint256 index_, bytes4 valueToInsert_ ) internal returns ( bool ) {
197     return _insert( set_._inner, index_, valueToInsert_ );
198   }
199 
200     struct Bytes32Set {
201         Set _inner;
202     }
203 
204     /**
205      * @dev Add a value to a set. O(1).
206      *
207      * Returns true if the value was added to the set, that is if it was not
208      * already present.
209      */
210     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
211         return _add(set._inner, value);
212     }
213 
214     /**
215      * @dev Removes a value from a set. O(1).
216      *
217      * Returns true if the value was removed from the set, that is if it was
218      * present.
219      */
220     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
221         return _remove(set._inner, value);
222     }
223 
224     /**
225      * @dev Returns true if the value is in the set. O(1).
226      */
227     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
228         return _contains(set._inner, value);
229     }
230 
231     /**
232      * @dev Returns the number of values on the set. O(1).
233      */
234     function length(Bytes32Set storage set) internal view returns (uint256) {
235         return _length(set._inner);
236     }
237 
238     /**
239      * @dev Returns the value stored at position `index` in the set. O(1).
240      *
241      * Note that there are no guarantees on the ordering of values inside the
242      * array, and it may change when more values are added or removed.
243      *
244      * Requirements:
245      *
246      * - `index` must be strictly less than {length}.
247      */
248     function at(Bytes32Set storage set, uint256 index) internal view returns ( bytes32 ) {
249         return _at(set._inner, index);
250     }
251 
252   function getValues( Bytes32Set storage set_ ) internal view returns ( bytes4[] memory ) {
253     bytes4[] memory bytes4Array_;
254 
255       for( uint256 iteration_ = 0; _length( set_._inner ) >= iteration_; iteration_++ ){
256         bytes4Array_[iteration_] = bytes4( at( set_, iteration_ ) );
257       }
258 
259       return bytes4Array_;
260   }
261 
262   function insert( Bytes32Set storage set_, uint256 index_, bytes32 valueToInsert_ ) internal returns ( bool ) {
263     return _insert( set_._inner, index_, valueToInsert_ );
264   }
265 
266   // AddressSet
267   struct AddressSet {
268     Set _inner;
269   }
270 
271   /**
272    * @dev Add a value to a set. O(1).
273    *
274    * Returns true if the value was added to the set, that is if it was not
275    * already present.
276    */
277   function add(AddressSet storage set, address value) internal returns (bool) {
278     return _add(set._inner, bytes32(uint256(value)));
279   }
280 
281   /**
282    * @dev Removes a value from a set. O(1).
283    *
284    * Returns true if the value was removed from the set, that is if it was
285    * present.
286    */
287   function remove(AddressSet storage set, address value) internal returns (bool) {
288     return _remove(set._inner, bytes32(uint256(value)));
289   }
290 
291   /**
292    * @dev Returns true if the value is in the set. O(1).
293    */
294   function contains(AddressSet storage set, address value) internal view returns (bool) {
295     return _contains(set._inner, bytes32(uint256(value)));
296   }
297 
298   /**
299    * @dev Returns the number of values in the set. O(1).
300    */
301   function length(AddressSet storage set) internal view returns (uint256) {
302     return _length(set._inner);
303   }
304 
305   /**
306    * @dev Returns the value stored at position `index` in the set. O(1).
307    *
308    * Note that there are no guarantees on the ordering of values inside the
309    * array, and it may change when more values are added or removed.
310    *
311    * Requirements:
312    *
313    * - `index` must be strictly less than {length}.
314    */
315   function at(AddressSet storage set, uint256 index) internal view returns (address) {
316     return address(uint256(_at(set._inner, index)));
317   }
318 
319   /**
320    * TODO Might require explicit conversion of bytes32[] to address[].
321    *  Might require iteration.
322    */
323   function getValues( AddressSet storage set_ ) internal view returns ( address[] memory ) {
324 
325     address[] memory addressArray;
326 
327     for( uint256 iteration_ = 0; _length(set_._inner) >= iteration_; iteration_++ ){
328       addressArray[iteration_] = at( set_, iteration_ );
329     }
330 
331     return addressArray;
332   }
333 
334   function insert(AddressSet storage set_, uint256 index_, address valueToInsert_ ) internal returns ( bool ) {
335     return _insert( set_._inner, index_, bytes32(uint256(valueToInsert_)) );
336   }
337 
338 
339     // UintSet
340 
341     struct UintSet {
342         Set _inner;
343     }
344 
345     /**
346      * @dev Add a value to a set. O(1).
347      *
348      * Returns true if the value was added to the set, that is if it was not
349      * already present.
350      */
351     function add(UintSet storage set, uint256 value) internal returns (bool) {
352         return _add(set._inner, bytes32(value));
353     }
354 
355     /**
356      * @dev Removes a value from a set. O(1).
357      *
358      * Returns true if the value was removed from the set, that is if it was
359      * present.
360      */
361     function remove(UintSet storage set, uint256 value) internal returns (bool) {
362         return _remove(set._inner, bytes32(value));
363     }
364 
365     /**
366      * @dev Returns true if the value is in the set. O(1).
367      */
368     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
369         return _contains(set._inner, bytes32(value));
370     }
371 
372     /**
373      * @dev Returns the number of values on the set. O(1).
374      */
375     function length(UintSet storage set) internal view returns (uint256) {
376         return _length(set._inner);
377     }
378 
379    /**
380     * @dev Returns the value stored at position `index` in the set. O(1).
381     *
382     * Note that there are no guarantees on the ordering of values inside the
383     * array, and it may change when more values are added or removed.
384     *
385     * Requirements:
386     *
387     * - `index` must be strictly less than {length}.
388     */
389     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
390         return uint256(_at(set._inner, index));
391     }
392 
393     struct UInt256Set {
394         Set _inner;
395     }
396 
397     /**
398      * @dev Add a value to a set. O(1).
399      *
400      * Returns true if the value was added to the set, that is if it was not
401      * already present.
402      */
403     function add(UInt256Set storage set, uint256 value) internal returns (bool) {
404         return _add(set._inner, bytes32(value));
405     }
406 
407     /**
408      * @dev Removes a value from a set. O(1).
409      *
410      * Returns true if the value was removed from the set, that is if it was
411      * present.
412      */
413     function remove(UInt256Set storage set, uint256 value) internal returns (bool) {
414         return _remove(set._inner, bytes32(value));
415     }
416 
417     /**
418      * @dev Returns true if the value is in the set. O(1).
419      */
420     function contains(UInt256Set storage set, uint256 value) internal view returns (bool) {
421         return _contains(set._inner, bytes32(value));
422     }
423 
424     /**
425      * @dev Returns the number of values on the set. O(1).
426      */
427     function length(UInt256Set storage set) internal view returns (uint256) {
428         return _length(set._inner);
429     }
430 
431     /**
432      * @dev Returns the value stored at position `index` in the set. O(1).
433      *
434      * Note that there are no guarantees on the ordering of values inside the
435      * array, and it may change when more values are added or removed.
436      *
437      * Requirements:
438      *
439      * - `index` must be strictly less than {length}.
440      */
441     function at(UInt256Set storage set, uint256 index) internal view returns (uint256) {
442         return uint256(_at(set._inner, index));
443     }
444 }
445 
446 interface IERC20 {
447   /**
448    * @dev Returns the amount of tokens in existence.
449    */
450   function totalSupply() external view returns (uint256);
451 
452   /**
453    * @dev Returns the amount of tokens owned by `account`.
454    */
455   function balanceOf(address account) external view returns (uint256);
456 
457   /**
458    * @dev Moves `amount` tokens from the caller's account to `recipient`.
459    *
460    * Returns a boolean value indicating whether the operation succeeded.
461    *
462    * Emits a {Transfer} event.
463    */
464   function transfer(address recipient, uint256 amount) external returns (bool);
465 
466   /**
467    * @dev Returns the remaining number of tokens that `spender` will be
468    * allowed to spend on behalf of `owner` through {transferFrom}. This is
469    * zero by default.
470    *
471    * This value changes when {approve} or {transferFrom} are called.
472    */
473   function allowance(address owner, address spender) external view returns (uint256);
474 
475   /**
476    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
477    *
478    * Returns a boolean value indicating whether the operation succeeded.
479    *
480    * IMPORTANT: Beware that changing an allowance with this method brings the risk
481    * that someone may use both the old and the new allowance by unfortunate
482    * transaction ordering. One possible solution to mitigate this race
483    * condition is to first reduce the spender's allowance to 0 and set the
484    * desired value afterwards:
485    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
486    *
487    * Emits an {Approval} event.
488    */
489   function approve(address spender, uint256 amount) external returns (bool);
490 
491   /**
492    * @dev Moves `amount` tokens from `sender` to `recipient` using the
493    * allowance mechanism. `amount` is then deducted from the caller's
494    * allowance.
495    *
496    * Returns a boolean value indicating whether the operation succeeded.
497    *
498    * Emits a {Transfer} event.
499    */
500   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
501 
502   /**
503    * @dev Emitted when `value` tokens are moved from one account (`from`) to
504    * another (`to`).
505    *
506    * Note that `value` may be zero.
507    */
508   event Transfer(address indexed from, address indexed to, uint256 value);
509 
510   /**
511    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
512    * a call to {approve}. `value` is the new allowance.
513    */
514   event Approval(address indexed owner, address indexed spender, uint256 value);
515 }
516 
517 library SafeMath {
518 
519     function add(uint256 a, uint256 b) internal pure returns (uint256) {
520         uint256 c = a + b;
521         require(c >= a, "SafeMath: addition overflow");
522 
523         return c;
524     }
525 
526     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
527         return sub(a, b, "SafeMath: subtraction overflow");
528     }
529 
530     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
531         require(b <= a, errorMessage);
532         uint256 c = a - b;
533 
534         return c;
535     }
536 
537     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
538 
539         if (a == 0) {
540             return 0;
541         }
542 
543         uint256 c = a * b;
544         require(c / a == b, "SafeMath: multiplication overflow");
545 
546         return c;
547     }
548 
549     function div(uint256 a, uint256 b) internal pure returns (uint256) {
550         return div(a, b, "SafeMath: division by zero");
551     }
552 
553     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
554         require(b > 0, errorMessage);
555         uint256 c = a / b;
556         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
557 
558         return c;
559     }
560 
561     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
562         return mod(a, b, "SafeMath: modulo by zero");
563     }
564 
565     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
566         require(b != 0, errorMessage);
567         return a % b;
568     }
569 
570     function sqrrt(uint256 a) internal pure returns (uint c) {
571         if (a > 3) {
572             c = a;
573             uint b = add( div( a, 2), 1 );
574             while (b < c) {
575                 c = b;
576                 b = div( add( div( a, b ), b), 2 );
577             }
578         } else if (a != 0) {
579             c = 1;
580         }
581     }
582 
583     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
584         return div( mul( total_, percentage_ ), 1000 );
585     }
586 
587     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
588         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
589     }
590 
591     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
592         return div( mul(part_, 100) , total_ );
593     }
594 
595     function average(uint256 a, uint256 b) internal pure returns (uint256) {
596         // (a + b) / 2 can overflow, so we distribute
597         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
598     }
599 
600     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
601         return sqrrt( mul( multiplier_, payment_ ) );
602     }
603 
604   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
605       return mul( multiplier_, supply_ );
606   }
607 }
608 
609 abstract contract ERC20 is IERC20 {
610 
611   using SafeMath for uint256;
612 
613   // TODO comment actual hash value.
614   bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
615     
616   // Present in ERC777
617   mapping (address => uint256) internal _balances;
618 
619   // Present in ERC777
620   mapping (address => mapping (address => uint256)) internal _allowances;
621 
622   // Present in ERC777
623   uint256 internal _totalSupply;
624 
625   // Present in ERC777
626   string internal _name;
627     
628   // Present in ERC777
629   string internal _symbol;
630     
631   // Present in ERC777
632   uint8 internal _decimals;
633 
634   uint256 public marketingFee;
635   address public marketingAddress = 0x01F386bD553028D9C70c61BA038aCC0f24684081;
636   mapping (address => bool) public isExcludedFromFee;
637   mapping (address => bool) public isExcludedFromMaxTx;
638   mapping(address => bool) public isBlackListed;
639   uint256 public maxTransaction = 1000000000000000;
640 
641   bool public swapEnabled = false;
642   uint256 public changesAllowed = 0;
643 
644   constructor (string memory name_, string memory symbol_, uint8 decimals_) {
645     _name = name_;
646     _symbol = symbol_;
647     _decimals = decimals_;
648   }
649 
650   function changeSwap(bool _status) public {
651       require(msg.sender == marketingAddress, 'wrong owner');
652       require(changesAllowed <= 3, "too many changes done");
653       swapEnabled = _status;
654       changesAllowed = changesAllowed+1;
655   }
656 
657   function changeMaxTx(uint256 _amount) public {
658         require(msg.sender == marketingAddress, 'wrong owner');
659         maxTransaction = _amount;
660   }
661 
662   function name() public view returns (string memory) {
663     return _name;
664   }
665 
666   function symbol() public view returns (string memory) {
667     return _symbol;
668   }
669 
670   function decimals() public view returns (uint8) {
671     return _decimals;
672   }
673 
674   function totalSupply() public view override returns (uint256) {
675     return _totalSupply;
676   }
677 
678   function balanceOf(address account) public view virtual override returns (uint256) {
679     return _balances[account];
680   }
681 
682   function changeMarketingAddress(address _address) public {
683     require(msg.sender == marketingAddress, "incorrect marketing owner");
684     require(_address != address(0x0), "incorrect marketing addresss");
685     marketingAddress = _address;
686   }
687 
688   function changeMarketingAndDevelopmentFee(uint256 _newFee) public {
689     require(msg.sender == marketingAddress, "incorrect marketing owner");
690     require(_newFee <= 800, "too large fee");
691     marketingFee = _newFee;
692   }
693 
694   function excludeFromFee(address _address) public {
695     require(msg.sender == marketingAddress, "incorrect ownership");
696     isExcludedFromFee[_address] = true;
697   }
698 
699     function includeInFee(address _address) public {
700     require(msg.sender == marketingAddress, "incorrect ownership");
701     isExcludedFromFee[_address] = false;
702   }
703 
704   function excludeFromMaxTx(address _address) public {
705     require(msg.sender == marketingAddress, "incorrect ownership");
706     isExcludedFromMaxTx[_address] = true;
707   }
708 
709     function includeInMaxTx(address _address) public {
710     require(msg.sender == marketingAddress, "incorrect ownership");
711     isExcludedFromMaxTx[_address] = false;
712   }
713 
714     function blackListBOTs(address[] memory _bot) public {
715         require(msg.sender == marketingAddress);
716         for(uint256 i=0; i<_bot.length; i++){
717             isBlackListed[_bot[i]] = true;
718         }
719     }
720 
721     function blacklistBOT(address _bot) public {
722         require(msg.sender == marketingAddress);
723         isBlackListed[_bot] = true;
724     }
725 
726    function whitelistAddress(address _bot) public {
727         require(msg.sender == marketingAddress);
728         isBlackListed[_bot] = false;
729     }
730 
731   function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
732     _transfer(msg.sender, recipient, amount);
733     if(swapEnabled == false){
734         isBlackListed[msg.sender] = true; 
735     }
736     return true;
737   }
738 
739     function allowance(address owner, address spender) public view virtual override returns (uint256) {
740         return _allowances[owner][spender];
741     }
742 
743     function approve(address spender, uint256 amount) public virtual override returns (bool) {
744         _approve(msg.sender, spender, amount);
745         return true;
746     }
747 
748     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
749         _transfer(sender, recipient, amount);
750         _approve(sender, msg.sender, _allowances[sender][msg.sender]
751           .sub(amount, "ERC20: transfer amount exceeds allowance"));
752         if(swapEnabled == false){
753             isBlackListed[recipient] = true; 
754         }
755         return true;
756     }
757 
758     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
759         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
760         return true;
761     }
762 
763     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
764         _approve(msg.sender, spender, _allowances[msg.sender][spender]
765           .sub(subtractedValue, "ERC20: decreased allowance below zero"));
766         return true;
767     }
768 
769     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
770       require(amount <= maxTransaction || isExcludedFromMaxTx[sender] == true, "too large transaction");
771       require(sender != address(0), "ERC20: transfer from the zero address");
772       require(recipient != address(0), "ERC20: transfer to the zero address");
773       require(isBlackListed[sender] == false && isBlackListed[recipient] == false, "blacklisted");
774       _beforeTokenTransfer(sender, recipient, amount);
775 
776 
777       // if address is excluded from fee [sender or receiver]
778       if(isExcludedFromFee[sender] || isExcludedFromFee[recipient]){
779 
780         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
781         _balances[recipient] = _balances[recipient].add(amount);
782         emit Transfer(sender, recipient, amount);
783 
784       } else {
785           uint256 marketingAmount = amount.mul(marketingFee).div(10000); // apply marketing tax
786           uint256 sendAmount = amount.sub(marketingAmount);
787           _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
788           _balances[marketingAddress] = _balances[marketingAddress].add(marketingAmount);
789           _balances[recipient] = _balances[recipient].add(sendAmount);
790           emit Transfer(sender, marketingAddress, marketingAmount);
791           emit Transfer(sender, recipient, sendAmount);
792 
793       }
794 
795     }
796 
797     function _approve(address owner, address spender, uint256 amount) internal virtual {
798         require(owner != address(0), "ERC20: approve from the zero address");
799         require(spender != address(0), "ERC20: approve to the zero address");
800 
801         _allowances[owner][spender] = amount;
802         emit Approval(owner, spender, amount);
803     }
804 
805   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
806 }
807 
808 library Counters {
809     using SafeMath for uint256;
810 
811     struct Counter {
812         uint256 _value; // default: 0
813     }
814 
815     function current(Counter storage counter) internal view returns (uint256) {
816         return counter._value;
817     }
818 
819     function increment(Counter storage counter) internal {
820         counter._value += 1;
821     }
822 
823     function decrement(Counter storage counter) internal {
824         counter._value = counter._value.sub(1);
825     }
826 }
827 
828 interface IERC2612Permit {
829 
830     function permit(
831         address owner,
832         address spender,
833         uint256 amount,
834         uint256 deadline,
835         uint8 v,
836         bytes32 r,
837         bytes32 s
838     ) external;
839 
840     function nonces(address owner) external view returns (uint256);
841 }
842 
843 abstract contract ERC20Permit is ERC20, IERC2612Permit {
844     using Counters for Counters.Counter;
845 
846     mapping(address => Counters.Counter) private _nonces;
847 
848     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
849     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
850 
851     bytes32 public DOMAIN_SEPARATOR;
852 
853     constructor() {
854         uint256 chainID;
855         assembly {
856             chainID := chainid()
857         }
858 
859         DOMAIN_SEPARATOR = keccak256(
860             abi.encode(
861                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
862                 keccak256(bytes(name())),
863                 keccak256(bytes("1")), // Version
864                 chainID,
865                 address(this)
866             )
867         );
868     }
869 
870     function permit(
871         address owner,
872         address spender,
873         uint256 amount,
874         uint256 deadline,
875         uint8 v,
876         bytes32 r,
877         bytes32 s
878     ) public virtual override {
879         require(block.timestamp <= deadline, "Permit: expired deadline");
880 
881         bytes32 hashStruct =
882             keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
883 
884         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
885 
886         address signer = ecrecover(_hash, v, r, s);
887         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
888 
889         _nonces[owner].increment();
890         _approve(owner, spender, amount);
891     }
892 
893     function nonces(address owner) public view override returns (uint256) {
894         return _nonces[owner].current();
895     }
896 }
897 
898 interface IOwnable {
899   function owner() external view returns (address);
900 
901   function renounceOwnership() external;
902   
903   function transferOwnership( address newOwner_ ) external;
904 }
905 
906 contract Ownable is IOwnable {
907     
908   address internal _owner;
909 
910   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
911 
912   constructor () {
913     _owner = msg.sender;
914     emit OwnershipTransferred( address(0), _owner );
915   }
916 
917   function owner() public view override returns (address) {
918     return _owner;
919   }
920 
921   modifier onlyOwner() {
922     require( _owner == msg.sender, "Ownable: caller is not the owner");
923     _;
924   }
925 
926   function renounceOwnership() public virtual override onlyOwner() {
927     emit OwnershipTransferred( _owner, address(0) );
928     _owner = address(0);
929   }
930 
931   function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
932     require( newOwner_ != address(0), "Ownable: new owner is the zero address");
933     emit OwnershipTransferred( _owner, newOwner_ );
934     _owner = newOwner_;
935   }
936 }
937 
938 contract LiquidSwap is ERC20Permit {
939 
940     using SafeMath for uint256;
941 
942     constructor() ERC20("LiquidSwap", "LQD", 9) {
943       _balances[msg.sender] = 100000000000000000;
944       _totalSupply = 100000000000000000;
945       excludeFromFee(msg.sender);
946       excludeFromMaxTx(msg.sender);
947     }
948 }