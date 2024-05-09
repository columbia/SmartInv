1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity 0.7.5;
5 
6 library EnumerableSet {
7 
8     // To implement this library for multiple types with as little code
9     // repetition as possible, we write it in terms of a generic Set type with
10     // bytes32 values.
11     // The Set implementation uses private functions, and user-facing
12     // implementations (such as AddressSet) are just wrappers around the
13     // underlying Set.
14     // This means that we can only create new EnumerableSets for types that fit
15     // in bytes32.
16     struct Set {
17         // Storage of set values
18         bytes32[] _values;
19 
20         // Position of the value in the `values` array, plus 1 because index 0
21         // means a value is not in the set.
22         mapping(bytes32 => uint256) _indexes;
23     }
24 
25     /**
26      * @dev Add a value to a set. O(1).
27    *
28    * Returns true if the value was added to the set, that is if it was not
29    * already present.
30    */
31     function _add(Set storage set, bytes32 value) private returns (bool) {
32         if (!_contains(set, value)) {
33             set._values.push(value);
34             // The value is stored at length-1, but we add 1 to all indexes
35             // and use 0 as a sentinel value
36             set._indexes[value] = set._values.length;
37             return true;
38         } else {
39             return false;
40         }
41     }
42 
43     /**
44      * @dev Removes a value from a set. O(1).
45    *
46    * Returns true if the value was removed from the set, that is if it was
47    * present.
48    */
49     function _remove(Set storage set, bytes32 value) private returns (bool) {
50         // We read and store the value's index to prevent multiple reads from the same storage slot
51         uint256 valueIndex = set._indexes[value];
52 
53         if (valueIndex != 0) {// Equivalent to contains(set, value)
54             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
55             // the array, and then remove the last element (sometimes called as 'swap and pop').
56             // This modifies the order of the array, as noted in {at}.
57 
58             uint256 toDeleteIndex = valueIndex - 1;
59             uint256 lastIndex = set._values.length - 1;
60 
61             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
62             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
63 
64             bytes32 lastvalue = set._values[lastIndex];
65 
66             // Move the last value to the index where the value to delete is
67             set._values[toDeleteIndex] = lastvalue;
68             // Update the index for the moved value
69             set._indexes[lastvalue] = toDeleteIndex + 1;
70             // All indexes are 1-based
71 
72             // Delete the slot where the moved value was stored
73             set._values.pop();
74 
75             // Delete the index for the deleted slot
76             delete set._indexes[value];
77 
78             return true;
79         } else {
80             return false;
81         }
82     }
83 
84     /**
85      * @dev Returns true if the value is in the set. O(1).
86    */
87     function _contains(Set storage set, bytes32 value) private view returns (bool) {
88         return set._indexes[value] != 0;
89     }
90 
91     /**
92      * @dev Returns the number of values on the set. O(1).
93    */
94     function _length(Set storage set) private view returns (uint256) {
95         return set._values.length;
96     }
97 
98     /**
99      * @dev Returns the value stored at position `index` in the set. O(1).
100     *
101     * Note that there are no guarantees on the ordering of values inside the
102     * array, and it may change when more values are added or removed.
103     *
104     * Requirements:
105     *
106     * - `index` must be strictly less than {length}.
107     */
108     function _at(Set storage set, uint256 index) private view returns (bytes32) {
109         require(set._values.length > index, "EnumerableSet: index out of bounds");
110         return set._values[index];
111     }
112 
113     function _getValues(Set storage set_) private view returns (bytes32[] storage) {
114         return set_._values;
115     }
116 
117     // TODO needs insert function that maintains order.
118     // TODO needs NatSpec documentation comment.
119     /**
120      * Inserts new value by moving existing value at provided index to end of array and setting provided value at provided index
121      */
122     function _insert(Set storage set_, uint256 index_, bytes32 valueToInsert_) private returns (bool) {
123         require(set_._values.length > index_);
124         require(!_contains(set_, valueToInsert_), "Remove value you wish to insert if you wish to reorder array.");
125         bytes32 existingValue_ = _at(set_, index_);
126         set_._values[index_] = valueToInsert_;
127         return _add(set_, existingValue_);
128     }
129 
130     struct Bytes4Set {
131         Set _inner;
132     }
133 
134     /**
135      * @dev Add a value to a set. O(1).
136    *
137    * Returns true if the value was added to the set, that is if it was not
138    * already present.
139    */
140     function add(Bytes4Set storage set, bytes4 value) internal returns (bool) {
141         return _add(set._inner, value);
142     }
143 
144     /**
145      * @dev Removes a value from a set. O(1).
146    *
147    * Returns true if the value was removed from the set, that is if it was
148    * present.
149    */
150     function remove(Bytes4Set storage set, bytes4 value) internal returns (bool) {
151         return _remove(set._inner, value);
152     }
153 
154     /**
155      * @dev Returns true if the value is in the set. O(1).
156    */
157     function contains(Bytes4Set storage set, bytes4 value) internal view returns (bool) {
158         return _contains(set._inner, value);
159     }
160 
161     /**
162      * @dev Returns the number of values on the set. O(1).
163    */
164     function length(Bytes4Set storage set) internal view returns (uint256) {
165         return _length(set._inner);
166     }
167 
168     /**
169      * @dev Returns the value stored at position `index` in the set. O(1).
170    *
171    * Note that there are no guarantees on the ordering of values inside the
172    * array, and it may change when more values are added or removed.
173    *
174    * Requirements:
175    *
176    * - `index` must be strictly less than {length}.
177    */
178     function at(Bytes4Set storage set, uint256 index) internal view returns (bytes4) {
179         return bytes4(_at(set._inner, index));
180     }
181 
182     function getValues(Bytes4Set storage set_) internal view returns (bytes4[] memory) {
183         bytes4[] memory bytes4Array_;
184         for (uint256 iteration_ = 0; _length(set_._inner) > iteration_; iteration_++) {
185             bytes4Array_[iteration_] = bytes4(_at(set_._inner, iteration_));
186         }
187         return bytes4Array_;
188     }
189 
190     function insert(Bytes4Set storage set_, uint256 index_, bytes4 valueToInsert_) internal returns (bool) {
191         return _insert(set_._inner, index_, valueToInsert_);
192     }
193 
194     struct Bytes32Set {
195         Set _inner;
196     }
197 
198     /**
199      * @dev Add a value to a set. O(1).
200      *
201      * Returns true if the value was added to the set, that is if it was not
202      * already present.
203      */
204     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
205         return _add(set._inner, value);
206     }
207 
208     /**
209      * @dev Removes a value from a set. O(1).
210      *
211      * Returns true if the value was removed from the set, that is if it was
212      * present.
213      */
214     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
215         return _remove(set._inner, value);
216     }
217 
218     /**
219      * @dev Returns true if the value is in the set. O(1).
220      */
221     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
222         return _contains(set._inner, value);
223     }
224 
225     /**
226      * @dev Returns the number of values on the set. O(1).
227      */
228     function length(Bytes32Set storage set) internal view returns (uint256) {
229         return _length(set._inner);
230     }
231 
232     /**
233      * @dev Returns the value stored at position `index` in the set. O(1).
234      *
235      * Note that there are no guarantees on the ordering of values inside the
236      * array, and it may change when more values are added or removed.
237      *
238      * Requirements:
239      *
240      * - `index` must be strictly less than {length}.
241      */
242     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
243         return _at(set._inner, index);
244     }
245 
246     function getValues(Bytes32Set storage set_) internal view returns (bytes4[] memory) {
247         bytes4[] memory bytes4Array_;
248 
249         for (uint256 iteration_ = 0; _length(set_._inner) >= iteration_; iteration_++) {
250             bytes4Array_[iteration_] = bytes4(at(set_, iteration_));
251         }
252 
253         return bytes4Array_;
254     }
255 
256     function insert(Bytes32Set storage set_, uint256 index_, bytes32 valueToInsert_) internal returns (bool) {
257         return _insert(set_._inner, index_, valueToInsert_);
258     }
259 
260     // AddressSet
261     struct AddressSet {
262         Set _inner;
263     }
264 
265     /**
266      * @dev Add a value to a set. O(1).
267    *
268    * Returns true if the value was added to the set, that is if it was not
269    * already present.
270    */
271     function add(AddressSet storage set, address value) internal returns (bool) {
272         return _add(set._inner, bytes32(uint256(value)));
273     }
274 
275     /**
276      * @dev Removes a value from a set. O(1).
277    *
278    * Returns true if the value was removed from the set, that is if it was
279    * present.
280    */
281     function remove(AddressSet storage set, address value) internal returns (bool) {
282         return _remove(set._inner, bytes32(uint256(value)));
283     }
284 
285     /**
286      * @dev Returns true if the value is in the set. O(1).
287    */
288     function contains(AddressSet storage set, address value) internal view returns (bool) {
289         return _contains(set._inner, bytes32(uint256(value)));
290     }
291 
292     /**
293      * @dev Returns the number of values in the set. O(1).
294    */
295     function length(AddressSet storage set) internal view returns (uint256) {
296         return _length(set._inner);
297     }
298 
299     /**
300      * @dev Returns the value stored at position `index` in the set. O(1).
301    *
302    * Note that there are no guarantees on the ordering of values inside the
303    * array, and it may change when more values are added or removed.
304    *
305    * Requirements:
306    *
307    * - `index` must be strictly less than {length}.
308    */
309     function at(AddressSet storage set, uint256 index) internal view returns (address) {
310         return address(uint256(_at(set._inner, index)));
311     }
312 
313     /**
314      * TODO Might require explicit conversion of bytes32[] to address[].
315      *  Might require iteration.
316      */
317     function getValues(AddressSet storage set_) internal view returns (address[] memory) {
318 
319         address[] memory addressArray;
320 
321         for (uint256 iteration_ = 0; _length(set_._inner) >= iteration_; iteration_++) {
322             addressArray[iteration_] = at(set_, iteration_);
323         }
324 
325         return addressArray;
326     }
327 
328     function insert(AddressSet storage set_, uint256 index_, address valueToInsert_) internal returns (bool) {
329         return _insert(set_._inner, index_, bytes32(uint256(valueToInsert_)));
330     }
331 
332 
333     // UintSet
334 
335     struct UintSet {
336         Set _inner;
337     }
338 
339     /**
340      * @dev Add a value to a set. O(1).
341      *
342      * Returns true if the value was added to the set, that is if it was not
343      * already present.
344      */
345     function add(UintSet storage set, uint256 value) internal returns (bool) {
346         return _add(set._inner, bytes32(value));
347     }
348 
349     /**
350      * @dev Removes a value from a set. O(1).
351      *
352      * Returns true if the value was removed from the set, that is if it was
353      * present.
354      */
355     function remove(UintSet storage set, uint256 value) internal returns (bool) {
356         return _remove(set._inner, bytes32(value));
357     }
358 
359     /**
360      * @dev Returns true if the value is in the set. O(1).
361      */
362     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
363         return _contains(set._inner, bytes32(value));
364     }
365 
366     /**
367      * @dev Returns the number of values on the set. O(1).
368      */
369     function length(UintSet storage set) internal view returns (uint256) {
370         return _length(set._inner);
371     }
372 
373     /**
374      * @dev Returns the value stored at position `index` in the set. O(1).
375     *
376     * Note that there are no guarantees on the ordering of values inside the
377     * array, and it may change when more values are added or removed.
378     *
379     * Requirements:
380     *
381     * - `index` must be strictly less than {length}.
382     */
383     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
384         return uint256(_at(set._inner, index));
385     }
386 
387     struct UInt256Set {
388         Set _inner;
389     }
390 
391     /**
392      * @dev Add a value to a set. O(1).
393      *
394      * Returns true if the value was added to the set, that is if it was not
395      * already present.
396      */
397     function add(UInt256Set storage set, uint256 value) internal returns (bool) {
398         return _add(set._inner, bytes32(value));
399     }
400 
401     /**
402      * @dev Removes a value from a set. O(1).
403      *
404      * Returns true if the value was removed from the set, that is if it was
405      * present.
406      */
407     function remove(UInt256Set storage set, uint256 value) internal returns (bool) {
408         return _remove(set._inner, bytes32(value));
409     }
410 
411     /**
412      * @dev Returns true if the value is in the set. O(1).
413      */
414     function contains(UInt256Set storage set, uint256 value) internal view returns (bool) {
415         return _contains(set._inner, bytes32(value));
416     }
417 
418     /**
419      * @dev Returns the number of values on the set. O(1).
420      */
421     function length(UInt256Set storage set) internal view returns (uint256) {
422         return _length(set._inner);
423     }
424 
425     /**
426      * @dev Returns the value stored at position `index` in the set. O(1).
427      *
428      * Note that there are no guarantees on the ordering of values inside the
429      * array, and it may change when more values are added or removed.
430      *
431      * Requirements:
432      *
433      * - `index` must be strictly less than {length}.
434      */
435     function at(UInt256Set storage set, uint256 index) internal view returns (uint256) {
436         return uint256(_at(set._inner, index));
437     }
438 }
439 
440 interface IERC20 {
441     /**
442      * @dev Returns the amount of tokens in existence.
443    */
444     function totalSupply() external view returns (uint256);
445 
446     /**
447      * @dev Returns the amount of tokens owned by `account`.
448    */
449     function balanceOf(address account) external view returns (uint256);
450 
451     /**
452      * @dev Moves `amount` tokens from the caller's account to `recipient`.
453    *
454    * Returns a boolean value indicating whether the operation succeeded.
455    *
456    * Emits a {Transfer} event.
457    */
458     function transfer(address recipient, uint256 amount) external returns (bool);
459 
460     /**
461      * @dev Returns the remaining number of tokens that `spender` will be
462    * allowed to spend on behalf of `owner` through {transferFrom}. This is
463    * zero by default.
464    *
465    * This value changes when {approve} or {transferFrom} are called.
466    */
467     function allowance(address owner, address spender) external view returns (uint256);
468 
469     /**
470      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
471    *
472    * Returns a boolean value indicating whether the operation succeeded.
473    *
474    * IMPORTANT: Beware that changing an allowance with this method brings the risk
475    * that someone may use both the old and the new allowance by unfortunate
476    * transaction ordering. One possible solution to mitigate this race
477    * condition is to first reduce the spender's allowance to 0 and set the
478    * desired value afterwards:
479    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
480    *
481    * Emits an {Approval} event.
482    */
483     function approve(address spender, uint256 amount) external returns (bool);
484 
485     /**
486      * @dev Moves `amount` tokens from `sender` to `recipient` using the
487    * allowance mechanism. `amount` is then deducted from the caller's
488    * allowance.
489    *
490    * Returns a boolean value indicating whether the operation succeeded.
491    *
492    * Emits a {Transfer} event.
493    */
494     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
495 
496     /**
497      * @dev Emitted when `value` tokens are moved from one account (`from`) to
498    * another (`to`).
499    *
500    * Note that `value` may be zero.
501    */
502     event Transfer(address indexed from, address indexed to, uint256 value);
503 
504     /**
505      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
506    * a call to {approve}. `value` is the new allowance.
507    */
508     event Approval(address indexed owner, address indexed spender, uint256 value);
509 }
510 
511 library SafeMath {
512 
513     function add(uint256 a, uint256 b) internal pure returns (uint256) {
514         uint256 c = a + b;
515         require(c >= a, "SafeMath: addition overflow");
516 
517         return c;
518     }
519 
520     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
521         return sub(a, b, "SafeMath: subtraction overflow");
522     }
523 
524     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
525         require(b <= a, errorMessage);
526         uint256 c = a - b;
527 
528         return c;
529     }
530 
531     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
532 
533         if (a == 0) {
534             return 0;
535         }
536 
537         uint256 c = a * b;
538         require(c / a == b, "SafeMath: multiplication overflow");
539 
540         return c;
541     }
542 
543     function div(uint256 a, uint256 b) internal pure returns (uint256) {
544         return div(a, b, "SafeMath: division by zero");
545     }
546 
547     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
548         require(b > 0, errorMessage);
549         uint256 c = a / b;
550         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
551 
552         return c;
553     }
554 
555     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
556         return mod(a, b, "SafeMath: modulo by zero");
557     }
558 
559     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b != 0, errorMessage);
561         return a % b;
562     }
563 
564     function sqrrt(uint256 a) internal pure returns (uint c) {
565         if (a > 3) {
566             c = a;
567             uint b = add(div(a, 2), 1);
568             while (b < c) {
569                 c = b;
570                 b = div(add(div(a, b), b), 2);
571             }
572         } else if (a != 0) {
573             c = 1;
574         }
575     }
576 
577     function percentageAmount(uint256 total_, uint8 percentage_) internal pure returns (uint256 percentAmount_) {
578         return div(mul(total_, percentage_), 1000);
579     }
580 
581     function substractPercentage(uint256 total_, uint8 percentageToSub_) internal pure returns (uint256 result_) {
582         return sub(total_, div(mul(total_, percentageToSub_), 1000));
583     }
584 
585     function percentageOfTotal(uint256 part_, uint256 total_) internal pure returns (uint256 percent_) {
586         return div(mul(part_, 100), total_);
587     }
588 
589     function average(uint256 a, uint256 b) internal pure returns (uint256) {
590         // (a + b) / 2 can overflow, so we distribute
591         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
592     }
593 
594     function quadraticPricing(uint256 payment_, uint256 multiplier_) internal pure returns (uint256) {
595         return sqrrt(mul(multiplier_, payment_));
596     }
597 
598     function bondingCurve(uint256 supply_, uint256 multiplier_) internal pure returns (uint256) {
599         return mul(multiplier_, supply_);
600     }
601 }
602 
603 abstract contract ERC20 is IERC20 {
604 
605     using SafeMath for uint256;
606 
607     // TODO comment actual hash value.
608     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256("ERC20Token");
609 
610     // Present in ERC777
611     mapping(address => uint256) internal _balances;
612 
613     // Present in ERC777
614     mapping(address => mapping(address => uint256)) internal _allowances;
615 
616     // Present in ERC777
617     uint256 internal _totalSupply;
618 
619     // Present in ERC777
620     string internal _name;
621 
622     // Present in ERC777
623     string internal _symbol;
624 
625     // Present in ERC777
626     uint8 internal _decimals;
627 
628     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
629         _name = name_;
630         _symbol = symbol_;
631         _decimals = decimals_;
632     }
633 
634     function name() public view returns (string memory) {
635         return _name;
636     }
637 
638     function symbol() public view returns (string memory) {
639         return _symbol;
640     }
641 
642     function decimals() public view returns (uint8) {
643         return _decimals;
644     }
645 
646     function totalSupply() public view override returns (uint256) {
647         return _totalSupply;
648     }
649 
650     function balanceOf(address account) public view virtual override returns (uint256) {
651         return _balances[account];
652     }
653 
654     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
655         _transfer(msg.sender, recipient, amount);
656         return true;
657     }
658 
659     function allowance(address owner, address spender) public view virtual override returns (uint256) {
660         return _allowances[owner][spender];
661     }
662 
663     function approve(address spender, uint256 amount) public virtual override returns (bool) {
664         _approve(msg.sender, spender, amount);
665         return true;
666     }
667 
668     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
669         _transfer(sender, recipient, amount);
670         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
671         return true;
672     }
673 
674     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
675         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
676         return true;
677     }
678 
679     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
680         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
681         return true;
682     }
683 
684     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
685         require(sender != address(0), "ERC20: transfer from the zero address");
686         require(recipient != address(0), "ERC20: transfer to the zero address");
687 
688         _beforeTokenTransfer(sender, recipient, amount);
689 
690         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
691         _balances[recipient] = _balances[recipient].add(amount);
692         emit Transfer(sender, recipient, amount);
693     }
694 
695     function _mint(address account_, uint256 amount_) internal virtual {
696         require(account_ != address(0), "ERC20: mint to the zero address");
697         _beforeTokenTransfer(address(this), account_, amount_);
698         _totalSupply = _totalSupply.add(amount_);
699         _balances[account_] = _balances[account_].add(amount_);
700         emit Transfer(address(this), account_, amount_);
701     }
702 
703     function _burn(address account, uint256 amount) internal virtual {
704         require(account != address(0), "ERC20: burn from the zero address");
705 
706         _beforeTokenTransfer(account, address(0), amount);
707 
708         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
709         _totalSupply = _totalSupply.sub(amount);
710         emit Transfer(account, address(0), amount);
711     }
712 
713     function _approve(address owner, address spender, uint256 amount) internal virtual {
714         require(owner != address(0), "ERC20: approve from the zero address");
715         require(spender != address(0), "ERC20: approve to the zero address");
716 
717         _allowances[owner][spender] = amount;
718         emit Approval(owner, spender, amount);
719     }
720 
721     function _beforeTokenTransfer(address from_, address to_, uint256 amount_) internal virtual {}
722 }
723 
724 library Counters {
725     using SafeMath for uint256;
726 
727     struct Counter {
728         uint256 _value; // default: 0
729     }
730 
731     function current(Counter storage counter) internal view returns (uint256) {
732         return counter._value;
733     }
734 
735     function increment(Counter storage counter) internal {
736         counter._value += 1;
737     }
738 
739     function decrement(Counter storage counter) internal {
740         counter._value = counter._value.sub(1);
741     }
742 }
743 
744 interface IERC2612Permit {
745 
746     function permit(
747         address owner,
748         address spender,
749         uint256 amount,
750         uint256 deadline,
751         uint8 v,
752         bytes32 r,
753         bytes32 s
754     ) external;
755 
756     function nonces(address owner) external view returns (uint256);
757 }
758 
759 abstract contract ERC20Permit is ERC20, IERC2612Permit {
760     using Counters for Counters.Counter;
761 
762     mapping(address => Counters.Counter) private _nonces;
763 
764     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
765     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
766 
767     bytes32 public DOMAIN_SEPARATOR;
768 
769     constructor() {
770         uint256 chainID;
771         assembly {
772             chainID := chainid()
773         }
774 
775         DOMAIN_SEPARATOR = keccak256(
776             abi.encode(
777                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
778                 keccak256(bytes(name())),
779                 keccak256(bytes("1")), // Version
780                 chainID,
781                 address(this)
782             )
783         );
784     }
785 
786     function permit(
787         address owner,
788         address spender,
789         uint256 amount,
790         uint256 deadline,
791         uint8 v,
792         bytes32 r,
793         bytes32 s
794     ) public virtual override {
795         require(block.timestamp <= deadline, "Permit: expired deadline");
796 
797         bytes32 hashStruct =
798         keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, amount, _nonces[owner].current(), deadline));
799 
800         bytes32 _hash = keccak256(abi.encodePacked(uint16(0x1901), DOMAIN_SEPARATOR, hashStruct));
801 
802         address signer = ecrecover(_hash, v, r, s);
803         require(signer != address(0) && signer == owner, "ZeroSwapPermit: Invalid signature");
804 
805         _nonces[owner].increment();
806         _approve(owner, spender, amount);
807     }
808 
809     function nonces(address owner) public view override returns (uint256) {
810         return _nonces[owner].current();
811     }
812 }
813 
814 interface IOwnable {
815     function owner() external view returns (address);
816 
817     function renounceOwnership() external;
818 
819     function transferOwnership(address newOwner_) external;
820 }
821 
822 contract Ownable is IOwnable {
823 
824     address internal _owner;
825 
826     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
827 
828     constructor () {
829         _owner = msg.sender;
830         emit OwnershipTransferred(address(0), _owner);
831     }
832 
833     function owner() public view override returns (address) {
834         return _owner;
835     }
836 
837     modifier onlyOwner() {
838         require(_owner == msg.sender, "Ownable: caller is not the owner");
839         _;
840     }
841 
842     function renounceOwnership() public virtual override onlyOwner() {
843         emit OwnershipTransferred(_owner, address(0));
844         _owner = address(0);
845     }
846 
847     function transferOwnership(address newOwner_) public virtual override onlyOwner() {
848         require(newOwner_ != address(0), "Ownable: new owner is the zero address");
849         emit OwnershipTransferred(_owner, newOwner_);
850         _owner = newOwner_;
851     }
852 }
853 
854 contract VaultOwned is Ownable {
855 
856     address internal _vault;
857     constructor() {
858         _vault = msg.sender;
859     }
860     function setVault(address vault_) external onlyOwner() returns (bool) {
861         _vault = vault_;
862 
863         return true;
864     }
865 
866     function vault() public view returns (address) {
867         return _vault;
868     }
869 
870     modifier onlyVault() {
871         require(_vault == msg.sender, "VaultOwned: caller is not the Vault");
872         _;
873     }
874 
875 }
876 
877 contract GenerationalWealthSocietyERC20Token is ERC20Permit, VaultOwned {
878     using SafeMath for uint256;
879 
880     event UpdateTeamTaxFee(uint teamTaxFee_);
881     event UpdateTeamTaxFeeAddress(address teamTaxFeeAddress_);
882     event UpdateBurnTaxFee(uint burnTaxFee_);
883     event UpdateBurnTaxFeeAddress(address burnTaxFeeAddress_);
884     event UpdateMaxTxAmount(uint256 maxTxAmount_);
885     event UpdateTaxesDisabled(bool disableTaxes_);
886     event UpdateMaxTxAmountDisabled(bool maxTxAmountDisabled_);
887     event UpdateExcludedFromMaxTransactionAmount(address addr_, bool isExcl_);
888     event UpdateExcludedFromMultipleMaxTransactionAmount(address[] accounts, bool isExcluded);
889     event UpdateAutomatedMarketMakerPair(address pair_, bool value_);
890     
891     mapping (address => bool) public isExcludedMaxTransactionAmount;
892     mapping (address => bool) public automatedMarketMakerPairs;
893 
894     address public teamTaxFeeAddress;
895     address public burnTaxFeeAddress;
896 
897     uint256 public constant MINIMUM_MAX_TX_AMOUNT = 10 * 10**9;
898     uint256 public maxTxAmount = 0;
899 
900     uint public teamTaxFee = 2;
901     uint public burnTaxFee = 8;
902 
903     bool public taxesDisabled = false;
904     bool public maxTxAmountDisabled = false;
905 
906     constructor() ERC20("GWS", "GWS", 9) {
907         isExcludedMaxTransactionAmount[owner()] = true;
908         isExcludedMaxTransactionAmount[address(this)] = true;
909     }
910 
911     function mint(address account_, uint256 amount_) external onlyVault() {
912         _mint(account_, amount_);
913     }
914 
915     function burn(uint256 amount) public virtual {
916         _burn(msg.sender, amount);
917     }
918 
919     function burnFrom(address account_, uint256 amount_) public virtual {
920         _burnFrom(account_, amount_);
921     }
922 
923     function _burnFrom(address account_, uint256 amount_) public virtual {
924         uint256 decreasedAllowance_ =
925         allowance(account_, msg.sender).sub(
926             amount_,
927             "ERC20: burn amount exceeds allowance"
928         );
929 
930         _approve(account_, msg.sender, decreasedAllowance_);
931         _burn(account_, amount_);
932     }
933 
934     function calculateTeamTaxFee(uint256 _amount) private view returns (uint256) {
935           return _amount.mul(teamTaxFee).div(
936             10**2
937         );
938     }
939 
940     function calculateBurnTaxFee(uint256 _amount) private view returns (uint256) {
941         return _amount.mul(burnTaxFee).div(
942             10**2
943         );
944     }
945 
946     function _transfer(address sender, address recipient, uint256 amount) override internal virtual {
947         require(sender != address(0), "ERC20: transfer from the zero address");
948         require(recipient != address(0), "ERC20: transfer to the zero address");
949 
950         // when amount = 0
951         if(amount == 0) {
952             super._transfer(sender, recipient, 0);
953             return;
954         }
955 
956         // when sell
957         uint256 receiveAmount = amount;
958         if(
959             !taxesDisabled &&
960             automatedMarketMakerPairs[recipient] &&
961             burnTaxFeeAddress != address(0) && 
962             teamTaxFeeAddress != address(0)
963         ) {
964             uint256 teamTax = calculateTeamTaxFee(amount);
965             uint256 burnTax = calculateBurnTaxFee(amount);
966             uint256 totalTax = teamTax.add(burnTax);
967 
968             super._transfer(sender, teamTaxFeeAddress, teamTax);
969             super._transfer(sender, burnTaxFeeAddress, burnTax);
970 
971             receiveAmount = receiveAmount.sub(totalTax);
972         }
973 
974         // when buy
975         if(
976             !maxTxAmountDisabled &&
977             automatedMarketMakerPairs[sender] &&
978             !isExcludedMaxTransactionAmount[sender] && 
979             !isExcludedMaxTransactionAmount[recipient]
980         ) {
981             require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
982         }
983 
984         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
985         _balances[recipient] = _balances[recipient].add(receiveAmount);
986         emit Transfer(sender, recipient, receiveAmount);
987     }
988 
989     function setMaxTxAmount(uint256 maxTxAmount_) external onlyOwner() {
990         require(maxTxAmount_ >= MINIMUM_MAX_TX_AMOUNT, "Max tx amount cannot be lower than the minimum tx amount");
991         maxTxAmount = maxTxAmount_;
992 
993         emit UpdateMaxTxAmount(maxTxAmount_);
994     }
995 
996     function setTeamTaxFeeAddress(address teamTaxFeeAddress_) public onlyOwner() {
997         require(teamTaxFeeAddress_ != address(0), 'Is the zero address');
998         teamTaxFeeAddress = teamTaxFeeAddress_;
999 
1000         emit UpdateTeamTaxFeeAddress(teamTaxFeeAddress_);
1001     }
1002 
1003     function setBurnTaxFeeAddress(address burnTaxFeeAddress_) public onlyOwner() {
1004         require(burnTaxFeeAddress_ != address(0), 'Is the zero address');
1005         burnTaxFeeAddress = burnTaxFeeAddress_;
1006 
1007         emit UpdateBurnTaxFeeAddress(burnTaxFeeAddress_);
1008     }
1009 
1010     function setTaxes(uint teamTaxFee_, uint burnTaxFee_) public onlyOwner() {
1011         teamTaxFee = teamTaxFee_;
1012         burnTaxFee = burnTaxFee_;
1013         require(teamTaxFee_.add(burnTaxFee_) <= 20, 'Must keep sell taxes below or equal to 20%');
1014 
1015         emit UpdateTeamTaxFee(teamTaxFee_);
1016         emit UpdateBurnTaxFee(burnTaxFee_);
1017     }
1018 
1019     function setAutomatedMarketMakerPair(address pair_, bool value_) public onlyOwner {
1020         automatedMarketMakerPairs[pair_] = value_;
1021 
1022         emit UpdateAutomatedMarketMakerPair(pair_, value_);
1023     }
1024 
1025     function excludeFromMaxTransactionAmount(address addr_, bool isExcl_) public onlyOwner {
1026         isExcludedMaxTransactionAmount[addr_] = isExcl_;
1027 
1028         emit UpdateExcludedFromMaxTransactionAmount(addr_, isExcl_);
1029     }
1030 
1031      function excludeFromMultipleMaxTransactionAmount(address[] calldata adresses_, bool isExcl_) public onlyOwner {
1032         for(uint256 i = 0; i < adresses_.length; i++) {
1033             isExcludedMaxTransactionAmount[adresses_[i]] = isExcl_;
1034         }
1035 
1036         emit UpdateExcludedFromMultipleMaxTransactionAmount(adresses_, isExcl_);
1037     }
1038 
1039     function disableTaxes(bool disableTaxes_) public onlyOwner() {
1040         taxesDisabled = disableTaxes_;
1041         
1042         emit UpdateTaxesDisabled(disableTaxes_);
1043     }
1044 
1045     function disableMaxTxAmount(bool maxTxAmountDisabled_) public onlyOwner() {
1046         maxTxAmountDisabled = maxTxAmountDisabled_;
1047         
1048         emit UpdateMaxTxAmountDisabled(maxTxAmountDisabled_);
1049     }
1050 }