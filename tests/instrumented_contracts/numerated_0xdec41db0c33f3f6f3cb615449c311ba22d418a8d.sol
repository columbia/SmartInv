1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.5;
3 
4 library EnumerableSet {
5   // To implement this library for multiple types with as little code
6   // repetition as possible, we write it in terms of a generic Set type with
7   // bytes32 values.
8   // The Set implementation uses private functions, and user-facing
9   // implementations (such as AddressSet) are just wrappers around the
10   // underlying Set.
11   // This means that we can only create new EnumerableSets for types that fit
12   // in bytes32.
13   struct Set {
14     // Storage of set values
15     bytes32[] _values;
16     // Position of the value in the `values` array, plus 1 because index 0
17     // means a value is not in the set.
18     mapping(bytes32 => uint256) _indexes;
19   }
20 
21   /**
22    * @dev Add a value to a set. O(1).
23    *
24    * Returns true if the value was added to the set, that is if it was not
25    * already present.
26    */
27   function _add(Set storage set, bytes32 value) private returns (bool) {
28     if (!_contains(set, value)) {
29       set._values.push(value);
30       // The value is stored at length-1, but we add 1 to all indexes
31       // and use 0 as a sentinel value
32       set._indexes[value] = set._values.length;
33       return true;
34     } else {
35       return false;
36     }
37   }
38 
39   /**
40    * @dev Removes a value from a set. O(1).
41    *
42    * Returns true if the value was removed from the set, that is if it was
43    * present.
44    */
45   function _remove(Set storage set, bytes32 value) private returns (bool) {
46     // We read and store the value's index to prevent multiple reads from the same storage slot
47     uint256 valueIndex = set._indexes[value];
48 
49     if (valueIndex != 0) {
50       // Equivalent to contains(set, value)
51       // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
52       // the array, and then remove the last element (sometimes called as 'swap and pop').
53       // This modifies the order of the array, as noted in {at}.
54 
55       uint256 toDeleteIndex = valueIndex - 1;
56       uint256 lastIndex = set._values.length - 1;
57 
58       // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
59       // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
60 
61       bytes32 lastvalue = set._values[lastIndex];
62 
63       // Move the last value to the index where the value to delete is
64       set._values[toDeleteIndex] = lastvalue;
65       // Update the index for the moved value
66       set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
67 
68       // Delete the slot where the moved value was stored
69       set._values.pop();
70 
71       // Delete the index for the deleted slot
72       delete set._indexes[value];
73 
74       return true;
75     } else {
76       return false;
77     }
78   }
79 
80   /**
81    * @dev Returns true if the value is in the set. O(1).
82    */
83   function _contains(Set storage set, bytes32 value)
84     private
85     view
86     returns (bool)
87   {
88     return set._indexes[value] != 0;
89   }
90 
91   /**
92    * @dev Returns the number of values on the set. O(1).
93    */
94   function _length(Set storage set) private view returns (uint256) {
95     return set._values.length;
96   }
97 
98   /**
99    * @dev Returns the value stored at position `index` in the set. O(1).
100    *
101    * Note that there are no guarantees on the ordering of values inside the
102    * array, and it may change when more values are added or removed.
103    *
104    * Requirements:
105    *
106    * - `index` must be strictly less than {length}.
107    */
108   function _at(Set storage set, uint256 index) private view returns (bytes32) {
109     require(set._values.length > index, "EnumerableSet: index out of bounds");
110     return set._values[index];
111   }
112 
113   function _getValues(Set storage set_)
114     private
115     view
116     returns (bytes32[] storage)
117   {
118     return set_._values;
119   }
120 
121   // TODO needs insert function that maintains order.
122   // TODO needs NatSpec documentation comment.
123   /**
124    * Inserts new value by moving existing value at provided index to end of array and setting provided value at provided index
125    */
126   function _insert(
127     Set storage set_,
128     uint256 index_,
129     bytes32 valueToInsert_
130   ) private returns (bool) {
131     require(set_._values.length > index_);
132     require(
133       !_contains(set_, valueToInsert_),
134       "Remove value you wish to insert if you wish to reorder array."
135     );
136     bytes32 existingValue_ = _at(set_, index_);
137     set_._values[index_] = valueToInsert_;
138     return _add(set_, existingValue_);
139   }
140 
141   struct Bytes4Set {
142     Set _inner;
143   }
144 
145   /**
146    * @dev Add a value to a set. O(1).
147    *
148    * Returns true if the value was added to the set, that is if it was not
149    * already present.
150    */
151   function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
152     return _add(set._inner, value);
153   }
154 
155   /**
156    * @dev Removes a value from a set. O(1).
157    *
158    * Returns true if the value was removed from the set, that is if it was
159    * present.
160    */
161   function remove(Bytes4Set storage set, bytes4 value) internal returns (bool) {
162     return _remove(set._inner, value);
163   }
164 
165   /**
166    * @dev Returns true if the value is in the set. O(1).
167    */
168   function contains(Bytes4Set storage set, bytes4 value)
169     internal
170     view
171     returns (bool)
172   {
173     return _contains(set._inner, value);
174   }
175 
176   /**
177    * @dev Returns the number of values on the set. O(1).
178    */
179   function length(Bytes4Set storage set) internal view returns (uint256) {
180     return _length(set._inner);
181   }
182 
183   /**
184    * @dev Returns the value stored at position `index` in the set. O(1).
185    *
186    * Note that there are no guarantees on the ordering of values inside the
187    * array, and it may change when more values are added or removed.
188    *
189    * Requirements:
190    *
191    * - `index` must be strictly less than {length}.
192    */
193   function at(Bytes4Set storage set, uint256 index)
194     internal
195     view
196     returns (bytes4)
197   {
198     return bytes4(_at(set._inner, index));
199   }
200 
201   function getValues(Bytes4Set storage set_)
202     internal
203     view
204     returns (bytes4[] memory)
205   {
206     bytes4[] memory bytes4Array_;
207     for (
208       uint256 iteration_ = 0;
209       _length(set_._inner) > iteration_;
210       iteration_++
211     ) {
212       bytes4Array_[iteration_] = bytes4(_at(set_._inner, iteration_));
213     }
214     return bytes4Array_;
215   }
216 
217   function insert(
218     Bytes4Set storage set_,
219     uint256 index_,
220     bytes4 valueToInsert_
221   ) internal returns (bool) {
222     return _insert(set_._inner, index_, valueToInsert_);
223   }
224 
225   struct Bytes32Set {
226     Set _inner;
227   }
228 
229   /**
230    * @dev Add a value to a set. O(1).
231    *
232    * Returns true if the value was added to the set, that is if it was not
233    * already present.
234    */
235   function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
236     return _add(set._inner, value);
237   }
238 
239   /**
240    * @dev Removes a value from a set. O(1).
241    *
242    * Returns true if the value was removed from the set, that is if it was
243    * present.
244    */
245   function remove(Bytes32Set storage set, bytes32 value)
246     internal
247     returns (bool)
248   {
249     return _remove(set._inner, value);
250   }
251 
252   /**
253    * @dev Returns true if the value is in the set. O(1).
254    */
255   function contains(Bytes32Set storage set, bytes32 value)
256     internal
257     view
258     returns (bool)
259   {
260     return _contains(set._inner, value);
261   }
262 
263   /**
264    * @dev Returns the number of values on the set. O(1).
265    */
266   function length(Bytes32Set storage set) internal view returns (uint256) {
267     return _length(set._inner);
268   }
269 
270   /**
271    * @dev Returns the value stored at position `index` in the set. O(1).
272    *
273    * Note that there are no guarantees on the ordering of values inside the
274    * array, and it may change when more values are added or removed.
275    *
276    * Requirements:
277    *
278    * - `index` must be strictly less than {length}.
279    */
280   function at(Bytes32Set storage set, uint256 index)
281     internal
282     view
283     returns (bytes32)
284   {
285     return _at(set._inner, index);
286   }
287 
288   function getValues(Bytes32Set storage set_)
289     internal
290     view
291     returns (bytes4[] memory)
292   {
293     bytes4[] memory bytes4Array_;
294 
295     for (
296       uint256 iteration_ = 0;
297       _length(set_._inner) >= iteration_;
298       iteration_++
299     ) {
300       bytes4Array_[iteration_] = bytes4(at(set_, iteration_));
301     }
302 
303     return bytes4Array_;
304   }
305 
306   function insert(
307     Bytes32Set storage set_,
308     uint256 index_,
309     bytes32 valueToInsert_
310   ) internal returns (bool) {
311     return _insert(set_._inner, index_, valueToInsert_);
312   }
313 
314   // AddressSet
315   struct AddressSet {
316     Set _inner;
317   }
318 
319   /**
320    * @dev Add a value to a set. O(1).
321    *
322    * Returns true if the value was added to the set, that is if it was not
323    * already present.
324    */
325   function add(AddressSet storage set, address value) internal returns (bool) {
326     return _add(set._inner, bytes32(uint256(value)));
327   }
328 
329   /**
330    * @dev Removes a value from a set. O(1).
331    *
332    * Returns true if the value was removed from the set, that is if it was
333    * present.
334    */
335   function remove(AddressSet storage set, address value)
336     internal
337     returns (bool)
338   {
339     return _remove(set._inner, bytes32(uint256(value)));
340   }
341 
342   /**
343    * @dev Returns true if the value is in the set. O(1).
344    */
345   function contains(AddressSet storage set, address value)
346     internal
347     view
348     returns (bool)
349   {
350     return _contains(set._inner, bytes32(uint256(value)));
351   }
352 
353   /**
354    * @dev Returns the number of values in the set. O(1).
355    */
356   function length(AddressSet storage set) internal view returns (uint256) {
357     return _length(set._inner);
358   }
359 
360   /**
361    * @dev Returns the value stored at position `index` in the set. O(1).
362    *
363    * Note that there are no guarantees on the ordering of values inside the
364    * array, and it may change when more values are added or removed.
365    *
366    * Requirements:
367    *
368    * - `index` must be strictly less than {length}.
369    */
370   function at(AddressSet storage set, uint256 index)
371     internal
372     view
373     returns (address)
374   {
375     return address(uint256(_at(set._inner, index)));
376   }
377 
378   /**
379    * TODO Might require explicit conversion of bytes32[] to address[].
380    *  Might require iteration.
381    */
382   function getValues(AddressSet storage set_)
383     internal
384     view
385     returns (address[] memory)
386   {
387     address[] memory addressArray;
388 
389     for (
390       uint256 iteration_ = 0;
391       _length(set_._inner) >= iteration_;
392       iteration_++
393     ) {
394       addressArray[iteration_] = at(set_, iteration_);
395     }
396 
397     return addressArray;
398   }
399 
400   function insert(
401     AddressSet storage set_,
402     uint256 index_,
403     address valueToInsert_
404   ) internal returns (bool) {
405     return _insert(set_._inner, index_, bytes32(uint256(valueToInsert_)));
406   }
407 
408   // UintSet
409 
410   struct UintSet {
411     Set _inner;
412   }
413 
414   /**
415    * @dev Add a value to a set. O(1).
416    *
417    * Returns true if the value was added to the set, that is if it was not
418    * already present.
419    */
420   function add(UintSet storage set, uint256 value) internal returns (bool) {
421     return _add(set._inner, bytes32(value));
422   }
423 
424   /**
425    * @dev Removes a value from a set. O(1).
426    *
427    * Returns true if the value was removed from the set, that is if it was
428    * present.
429    */
430   function remove(UintSet storage set, uint256 value) internal returns (bool) {
431     return _remove(set._inner, bytes32(value));
432   }
433 
434   /**
435    * @dev Returns true if the value is in the set. O(1).
436    */
437   function contains(UintSet storage set, uint256 value)
438     internal
439     view
440     returns (bool)
441   {
442     return _contains(set._inner, bytes32(value));
443   }
444 
445   /**
446    * @dev Returns the number of values on the set. O(1).
447    */
448   function length(UintSet storage set) internal view returns (uint256) {
449     return _length(set._inner);
450   }
451 
452   /**
453    * @dev Returns the value stored at position `index` in the set. O(1).
454    *
455    * Note that there are no guarantees on the ordering of values inside the
456    * array, and it may change when more values are added or removed.
457    *
458    * Requirements:
459    *
460    * - `index` must be strictly less than {length}.
461    */
462   function at(UintSet storage set, uint256 index)
463     internal
464     view
465     returns (uint256)
466   {
467     return uint256(_at(set._inner, index));
468   }
469 
470   struct UInt256Set {
471     Set _inner;
472   }
473 
474   /**
475    * @dev Add a value to a set. O(1).
476    *
477    * Returns true if the value was added to the set, that is if it was not
478    * already present.
479    */
480   function add(UInt256Set storage set, uint256 value) internal returns (bool) {
481     return _add(set._inner, bytes32(value));
482   }
483 
484   /**
485    * @dev Removes a value from a set. O(1).
486    *
487    * Returns true if the value was removed from the set, that is if it was
488    * present.
489    */
490   function remove(UInt256Set storage set, uint256 value)
491     internal
492     returns (bool)
493   {
494     return _remove(set._inner, bytes32(value));
495   }
496 
497   /**
498    * @dev Returns true if the value is in the set. O(1).
499    */
500   function contains(UInt256Set storage set, uint256 value)
501     internal
502     view
503     returns (bool)
504   {
505     return _contains(set._inner, bytes32(value));
506   }
507 
508   /**
509    * @dev Returns the number of values on the set. O(1).
510    */
511   function length(UInt256Set storage set) internal view returns (uint256) {
512     return _length(set._inner);
513   }
514 
515   /**
516    * @dev Returns the value stored at position `index` in the set. O(1).
517    *
518    * Note that there are no guarantees on the ordering of values inside the
519    * array, and it may change when more values are added or removed.
520    *
521    * Requirements:
522    *
523    * - `index` must be strictly less than {length}.
524    */
525   function at(UInt256Set storage set, uint256 index)
526     internal
527     view
528     returns (uint256)
529   {
530     return uint256(_at(set._inner, index));
531   }
532 }
533 
534 interface IERC20 {
535   /**
536    * @dev Returns the amount of tokens in existence.
537    */
538   function totalSupply() external view returns (uint256);
539 
540   /**
541    * @dev Returns the amount of tokens owned by `account`.
542    */
543   function balanceOf(address account) external view returns (uint256);
544 
545   /**
546    * @dev Moves `amount` tokens from the caller's account to `recipient`.
547    *
548    * Returns a boolean value indicating whether the operation succeeded.
549    *
550    * Emits a {Transfer} event.
551    */
552   function transfer(address recipient, uint256 amount) external returns (bool);
553 
554   /**
555    * @dev Returns the remaining number of tokens that `spender` will be
556    * allowed to spend on behalf of `owner` through {transferFrom}. This is
557    * zero by default.
558    *
559    * This value changes when {approve} or {transferFrom} are called.
560    */
561   function allowance(address owner, address spender)
562     external
563     view
564     returns (uint256);
565 
566   /**
567    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
568    *
569    * Returns a boolean value indicating whether the operation succeeded.
570    *
571    * IMPORTANT: Beware that changing an allowance with this method brings the risk
572    * that someone may use both the old and the new allowance by unfortunate
573    * transaction ordering. One possible solution to mitigate this race
574    * condition is to first reduce the spender's allowance to 0 and set the
575    * desired value afterwards:
576    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
577    *
578    * Emits an {Approval} event.
579    */
580   function approve(address spender, uint256 amount) external returns (bool);
581 
582   /**
583    * @dev Moves `amount` tokens from `sender` to `recipient` using the
584    * allowance mechanism. `amount` is then deducted from the caller's
585    * allowance.
586    *
587    * Returns a boolean value indicating whether the operation succeeded.
588    *
589    * Emits a {Transfer} event.
590    */
591   function transferFrom(
592     address sender,
593     address recipient,
594     uint256 amount
595   ) external returns (bool);
596 
597   /**
598    * @dev Emitted when `value` tokens are moved from one account (`from`) to
599    * another (`to`).
600    *
601    * Note that `value` may be zero.
602    */
603   event Transfer(address indexed from, address indexed to, uint256 value);
604 
605   /**
606    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
607    * a call to {approve}. `value` is the new allowance.
608    */
609   event Approval(address indexed owner, address indexed spender, uint256 value);
610 }
611 
612 library SafeMath {
613   function add(uint256 a, uint256 b) internal pure returns (uint256) {
614     uint256 c = a + b;
615     require(c >= a, "SafeMath: addition overflow");
616 
617     return c;
618   }
619 
620   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
621     return sub(a, b, "SafeMath: subtraction overflow");
622   }
623 
624   function sub(
625     uint256 a,
626     uint256 b,
627     string memory errorMessage
628   ) internal pure returns (uint256) {
629     require(b <= a, errorMessage);
630     uint256 c = a - b;
631 
632     return c;
633   }
634 
635   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
636     if (a == 0) {
637       return 0;
638     }
639 
640     uint256 c = a * b;
641     require(c / a == b, "SafeMath: multiplication overflow");
642 
643     return c;
644   }
645 
646   function div(uint256 a, uint256 b) internal pure returns (uint256) {
647     return div(a, b, "SafeMath: division by zero");
648   }
649 
650   function div(
651     uint256 a,
652     uint256 b,
653     string memory errorMessage
654   ) internal pure returns (uint256) {
655     require(b > 0, errorMessage);
656     uint256 c = a / b;
657     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
658 
659     return c;
660   }
661 
662   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
663     return mod(a, b, "SafeMath: modulo by zero");
664   }
665 
666   function mod(
667     uint256 a,
668     uint256 b,
669     string memory errorMessage
670   ) internal pure returns (uint256) {
671     require(b != 0, errorMessage);
672     return a % b;
673   }
674 
675   function sqrrt(uint256 a) internal pure returns (uint256 c) {
676     if (a > 3) {
677       c = a;
678       uint256 b = add(div(a, 2), 1);
679       while (b < c) {
680         c = b;
681         b = div(add(div(a, b), b), 2);
682       }
683     } else if (a != 0) {
684       c = 1;
685     }
686   }
687 
688   function percentageAmount(uint256 total_, uint8 percentage_)
689     internal
690     pure
691     returns (uint256 percentAmount_)
692   {
693     return div(mul(total_, percentage_), 1000);
694   }
695 
696   function substractPercentage(uint256 total_, uint8 percentageToSub_)
697     internal
698     pure
699     returns (uint256 result_)
700   {
701     return sub(total_, div(mul(total_, percentageToSub_), 1000));
702   }
703 
704   function percentageOfTotal(uint256 part_, uint256 total_)
705     internal
706     pure
707     returns (uint256 percent_)
708   {
709     return div(mul(part_, 100), total_);
710   }
711 
712   function average(uint256 a, uint256 b) internal pure returns (uint256) {
713     // (a + b) / 2 can overflow, so we distribute
714     return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
715   }
716 
717   function quadraticPricing(uint256 payment_, uint256 multiplier_)
718     internal
719     pure
720     returns (uint256)
721   {
722     return sqrrt(mul(multiplier_, payment_));
723   }
724 
725   function bondingCurve(uint256 supply_, uint256 multiplier_)
726     internal
727     pure
728     returns (uint256)
729   {
730     return mul(multiplier_, supply_);
731   }
732 }
733 
734 abstract contract ERC20 is IERC20 {
735   using SafeMath for uint256;
736 
737   // TODO comment actual hash value.
738   bytes32 private constant ERC20TOKEN_ERC1820_INTERFACE_ID =
739     keccak256("ERC20Token");
740 
741   // Present in ERC777
742   mapping(address => uint256) internal _balances;
743 
744   // Present in ERC777
745   mapping(address => mapping(address => uint256)) internal _allowances;
746 
747   // Present in ERC777
748   uint256 internal _totalSupply;
749 
750   // Present in ERC777
751   string internal _name;
752 
753   // Present in ERC777
754   string internal _symbol;
755 
756   // Present in ERC777
757   uint8 internal _decimals;
758 
759   constructor(
760     string memory name_,
761     string memory symbol_,
762     uint8 decimals_
763   ) {
764     _name = name_;
765     _symbol = symbol_;
766     _decimals = decimals_;
767   }
768 
769   function name() public view returns (string memory) {
770     return _name;
771   }
772 
773   function symbol() public view returns (string memory) {
774     return _symbol;
775   }
776 
777   function decimals() public view returns (uint8) {
778     return _decimals;
779   }
780 
781   function totalSupply() public view override returns (uint256) {
782     return _totalSupply;
783   }
784 
785   function balanceOf(address account)
786     public
787     view
788     virtual
789     override
790     returns (uint256)
791   {
792     return _balances[account];
793   }
794 
795   function transfer(address recipient, uint256 amount)
796     public
797     virtual
798     override
799     returns (bool)
800   {
801     _transfer(msg.sender, recipient, amount);
802     return true;
803   }
804 
805   function allowance(address owner, address spender)
806     public
807     view
808     virtual
809     override
810     returns (uint256)
811   {
812     return _allowances[owner][spender];
813   }
814 
815   function approve(address spender, uint256 amount)
816     public
817     virtual
818     override
819     returns (bool)
820   {
821     _approve(msg.sender, spender, amount);
822     return true;
823   }
824 
825   function transferFrom(
826     address sender,
827     address recipient,
828     uint256 amount
829   ) public virtual override returns (bool) {
830     _transfer(sender, recipient, amount);
831     _approve(
832       sender,
833       msg.sender,
834       _allowances[sender][msg.sender].sub(
835         amount,
836         "ERC20: transfer amount exceeds allowance"
837       )
838     );
839     return true;
840   }
841 
842   function increaseAllowance(address spender, uint256 addedValue)
843     public
844     virtual
845     returns (bool)
846   {
847     _approve(
848       msg.sender,
849       spender,
850       _allowances[msg.sender][spender].add(addedValue)
851     );
852     return true;
853   }
854 
855   function decreaseAllowance(address spender, uint256 subtractedValue)
856     public
857     virtual
858     returns (bool)
859   {
860     _approve(
861       msg.sender,
862       spender,
863       _allowances[msg.sender][spender].sub(
864         subtractedValue,
865         "ERC20: decreased allowance below zero"
866       )
867     );
868     return true;
869   }
870 
871   function _transfer(
872     address sender,
873     address recipient,
874     uint256 amount
875   ) internal virtual {
876     require(sender != address(0), "ERC20: transfer from the zero address");
877     require(recipient != address(0), "ERC20: transfer to the zero address");
878 
879     _beforeTokenTransfer(sender, recipient, amount);
880 
881     _balances[sender] = _balances[sender].sub(
882       amount,
883       "ERC20: transfer amount exceeds balance"
884     );
885     _balances[recipient] = _balances[recipient].add(amount);
886     emit Transfer(sender, recipient, amount);
887   }
888 
889   function _mint(address account_, uint256 amount_) internal virtual {
890     require(account_ != address(0), "ERC20: mint to the zero address");
891     _beforeTokenTransfer(address(this), account_, amount_);
892     _totalSupply = _totalSupply.add(amount_);
893     _balances[account_] = _balances[account_].add(amount_);
894     emit Transfer(address(this), account_, amount_);
895   }
896 
897   function _burn(address account, uint256 amount) internal virtual {
898     require(account != address(0), "ERC20: burn from the zero address");
899 
900     _beforeTokenTransfer(account, address(0), amount);
901 
902     _balances[account] = _balances[account].sub(
903       amount,
904       "ERC20: burn amount exceeds balance"
905     );
906     _totalSupply = _totalSupply.sub(amount);
907     emit Transfer(account, address(0), amount);
908   }
909 
910   function _approve(
911     address owner,
912     address spender,
913     uint256 amount
914   ) internal virtual {
915     require(owner != address(0), "ERC20: approve from the zero address");
916     require(spender != address(0), "ERC20: approve to the zero address");
917 
918     _allowances[owner][spender] = amount;
919     emit Approval(owner, spender, amount);
920   }
921 
922   function _beforeTokenTransfer(
923     address from_,
924     address to_,
925     uint256 amount_
926   ) internal virtual {}
927 }
928 
929 library Counters {
930   using SafeMath for uint256;
931 
932   struct Counter {
933     uint256 _value; // default: 0
934   }
935 
936   function current(Counter storage counter) internal view returns (uint256) {
937     return counter._value;
938   }
939 
940   function increment(Counter storage counter) internal {
941     counter._value += 1;
942   }
943 
944   function decrement(Counter storage counter) internal {
945     counter._value = counter._value.sub(1);
946   }
947 }
948 
949 interface IERC2612Permit {
950   function permit(
951     address owner,
952     address spender,
953     uint256 amount,
954     uint256 deadline,
955     uint8 v,
956     bytes32 r,
957     bytes32 s
958   ) external;
959 
960   function nonces(address owner) external view returns (uint256);
961 }
962 
963 abstract contract ERC20Permit is ERC20, IERC2612Permit {
964   using Counters for Counters.Counter;
965 
966   mapping(address => Counters.Counter) private _nonces;
967 
968   // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
969   bytes32 public constant PERMIT_TYPEHASH =
970     0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
971 
972   bytes32 public DOMAIN_SEPARATOR;
973 
974   constructor() {
975     uint256 chainID;
976     assembly {
977       chainID := chainid()
978     }
979 
980     DOMAIN_SEPARATOR = keccak256(
981       abi.encode(
982         keccak256(
983           "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
984         ),
985         keccak256(bytes(name())),
986         keccak256(bytes("1")), // Version
987         chainID,
988         address(this)
989       )
990     );
991   }
992 
993   function permit(
994     address owner,
995     address spender,
996     uint256 amount,
997     uint256 deadline,
998     uint8 v,
999     bytes32 r,
1000     bytes32 s
1001   ) public virtual override {
1002     require(block.timestamp <= deadline, "Permit: expired deadline");
1003 
1004     bytes32 hashStruct = keccak256(
1005       abi.encode(
1006         PERMIT_TYPEHASH,
1007         owner,
1008         spender,
1009         amount,
1010         _nonces[owner].current(),
1011         deadline
1012       )
1013     );
1014 
1015     bytes32 _hash = keccak256(
1016       abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct)
1017     );
1018 
1019     address signer = ecrecover(_hash, v, r, s);
1020     require(
1021       signer != address(0) && signer == owner,
1022       "ZeroSwapPermit: Invalid signature"
1023     );
1024 
1025     _nonces[owner].increment();
1026     _approve(owner, spender, amount);
1027   }
1028 
1029   function nonces(address owner) public view override returns (uint256) {
1030     return _nonces[owner].current();
1031   }
1032 }
1033 
1034 interface IOwnable {
1035   function owner() external view returns (address);
1036 
1037   function renounceOwnership() external;
1038 
1039   function transferOwnership(address newOwner_) external;
1040 }
1041 
1042 contract Ownable is IOwnable {
1043   address internal _owner;
1044 
1045   event OwnershipTransferred(
1046     address indexed previousOwner,
1047     address indexed newOwner
1048   );
1049 
1050   constructor() {
1051     _owner = msg.sender;
1052     emit OwnershipTransferred(address(0), _owner);
1053   }
1054 
1055   function owner() public view override returns (address) {
1056     return _owner;
1057   }
1058 
1059   modifier onlyOwner() {
1060     require(_owner == msg.sender, "Ownable: caller is not the owner");
1061     _;
1062   }
1063 
1064   function renounceOwnership() public virtual override onlyOwner {
1065     emit OwnershipTransferred(_owner, address(0));
1066     _owner = address(0);
1067   }
1068 
1069   function transferOwnership(address newOwner_)
1070     public
1071     virtual
1072     override
1073     onlyOwner
1074   {
1075     require(newOwner_ != address(0), "Ownable: new owner is the zero address");
1076     emit OwnershipTransferred(_owner, newOwner_);
1077     _owner = newOwner_;
1078   }
1079 }
1080 
1081 contract VaultOwned is Ownable {
1082   address internal _vault;
1083 
1084   function setVault(address vault_) external onlyOwner returns (bool) {
1085     _vault = vault_;
1086 
1087     return true;
1088   }
1089 
1090   function vault() public view returns (address) {
1091     return _vault;
1092   }
1093 
1094   modifier onlyVault() {
1095     require(_vault == msg.sender, "VaultOwned: caller is not the Vault");
1096     _;
1097   }
1098 }
1099 
1100 contract LobiERC20 is ERC20Permit, VaultOwned {
1101   using SafeMath for uint256;
1102 
1103   constructor() ERC20("Lobi", "LOBI", 9) {}
1104 
1105   function mint(address account_, uint256 amount_) external onlyVault {
1106     _mint(account_, amount_);
1107   }
1108 
1109   function burn(uint256 amount) public virtual {
1110     _burn(msg.sender, amount);
1111   }
1112 
1113   function burnFrom(address account_, uint256 amount_) public virtual {
1114     _burnFrom(account_, amount_);
1115   }
1116 
1117   function _burnFrom(address account_, uint256 amount_) public virtual {
1118     uint256 decreasedAllowance_ = allowance(account_, msg.sender).sub(
1119       amount_,
1120       "ERC20: burn amount exceeds allowance"
1121     );
1122 
1123     _approve(account_, msg.sender, decreasedAllowance_);
1124     _burn(account_, amount_);
1125   }
1126 }