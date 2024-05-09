1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.6.12;
4 
5 library SafeMaths {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      */
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13 
14         return c;
15     }
16 
17     /**
18      * @dev Returns the subtraction of two unsigned integers, reverting on
19      * overflow (when the result is negative).
20      */
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a, "SafeMath: subtraction overflow");
23         uint256 c = a - b;
24 
25         return c;
26     }
27 
28     /**
29      * @dev Returns the multiplication of two unsigned integers, reverting on
30      * overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42 
43     /**
44      * @dev Returns the integer division of two unsigned integers. Reverts on
45      * division by zero. The result is rounded towards zero.
46      */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         require(b > 0, "SafeMath: division by zero");
49         uint256 c = a / b;
50 
51         return c;
52     }
53 
54 }
55 
56 contract Memefund {
57 
58     using SafeMaths for uint256;
59 
60     address public rebaseOracle;       // Used for authentication
61     address public owner;              // Used for authentication
62     address public newOwner;
63 
64     uint8 public decimals;
65     uint256 public totalSupply;
66     string public name;
67     string public symbol;
68 
69     uint256 private constant MAX_UINT256 = ~uint256(0);   // (2^256) - 1
70     uint256 private constant MAXSUPPLY = ~uint128(0);  // (2^128) - 1
71 
72     uint256 private totalAtoms;
73     uint256 private atomsPerMolecule;
74 
75     mapping (address => uint256) private atomBalances;
76     mapping (address => mapping (address => uint256)) private allowedMolecules;
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     event LogRebase(uint256 _totalSupply);
81     event LogNewRebaseOracle(address _rebaseOracle);
82     event OwnershipTransferred(address indexed _from, address indexed _to);
83 
84     constructor() public
85     {
86         decimals = 9;                               // decimals  
87         totalSupply = 100000000*10**9;                // initialSupply
88         name = "Memefund";                         // Set the name for display purposes
89         symbol = "MFUND";                            // Set the symbol for display purposes
90 
91         owner = msg.sender;
92         totalAtoms = MAX_UINT256 - (MAX_UINT256 % totalSupply);     // totalAtoms is a multiple of totalSupply so that atomsPerMolecule is an integer.
93         atomBalances[msg.sender] = totalAtoms;
94         atomsPerMolecule = totalAtoms.div(totalSupply);
95 
96         emit Transfer(address(0), msg.sender, totalSupply);
97     }
98 
99     /**
100      * @param newRebaseOracle The address of the new oracle for rebasement (used for authentication).
101      */
102     function setRebaseOracle(address newRebaseOracle) external {
103         require(msg.sender == owner, "Can only be executed by owner.");
104         rebaseOracle = newRebaseOracle;
105 
106         emit LogNewRebaseOracle(rebaseOracle);
107     }
108 
109     /**
110      * @dev Propose a new owner.
111      * @param _newOwner The address of the new owner.
112      */
113     function transferOwnership(address _newOwner) public
114     {
115         require(msg.sender == owner, "Can only be executed by owner.");
116         require(_newOwner != address(0), "0x00 address not allowed.");
117         newOwner = _newOwner;
118     }
119 
120     /**
121      * @dev Accept new owner.
122      */
123     function acceptOwnership() public
124     {
125         require(msg.sender == newOwner, "Sender not authorized.");
126         emit OwnershipTransferred(owner, newOwner);
127         owner = newOwner;
128         newOwner = address(0);
129     }
130 
131     /**
132      * @dev Notifies Benchmark contract about a new rebase cycle.
133      * @param supplyDelta The number of new molecule tokens to add into or remove from circulation.
134      * @param increaseSupply Whether to increase or decrease the total supply.
135      * @return The total number of molecules after the supply adjustment.
136      */
137     function rebase(uint256 supplyDelta, bool increaseSupply) external returns (uint256) {
138         require(msg.sender == rebaseOracle, "Can only be executed by rebaseOracle.");
139         
140         if (supplyDelta == 0) {
141             emit LogRebase(totalSupply);
142             return totalSupply;
143         }
144 
145         if (increaseSupply == true) {
146             totalSupply = totalSupply.add(supplyDelta);
147         } else {
148             totalSupply = totalSupply.sub(supplyDelta);
149         }
150 
151         if (totalSupply > MAXSUPPLY) {
152             totalSupply = MAXSUPPLY;
153         }
154 
155         atomsPerMolecule = totalAtoms.div(totalSupply);
156 
157         emit LogRebase(totalSupply);
158         return totalSupply;
159     }
160 
161     /**
162      * @param who The address to query.
163      * @return The balance of the specified address.
164      */
165     function balanceOf(address who) public view returns (uint256) {
166         return atomBalances[who].div(atomsPerMolecule);
167     }
168 
169     /**
170      * @dev Transfer tokens to a specified address.
171      * @param to The address to transfer to.
172      * @param value The amount to be transferred.
173      * @return True on success, false otherwise.
174      */
175     function transfer(address to, uint256 value) public returns (bool) {
176         require(to != address(0),"Invalid address.");
177         require(to != address(this),"Molecules contract can't receive MARK.");
178 
179         uint256 atomValue = value.mul(atomsPerMolecule);
180 
181         atomBalances[msg.sender] = atomBalances[msg.sender].sub(atomValue);
182         atomBalances[to] = atomBalances[to].add(atomValue);
183 
184         emit Transfer(msg.sender, to, value);
185         return true;
186     }
187 
188     /**
189      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
190      * @param owner_ The address which owns the funds.
191      * @param spender The address which will spend the funds.
192      * @return The number of tokens still available for the spender.
193      */
194     function allowance(address owner_, address spender) public view returns (uint256) {
195         return allowedMolecules[owner_][spender];
196     }
197 
198     /**
199      * @dev Transfer tokens from one address to another.
200      * @param from The address you want to send tokens from.
201      * @param to The address you want to transfer to.
202      * @param value The amount of tokens to be transferred.
203      */
204     function transferFrom(address from, address to, uint256 value) public returns (bool) {
205         require(to != address(0),"Invalid address.");
206         require(to != address(this),"Molecules contract can't receive MARK.");
207 
208         allowedMolecules[from][msg.sender] = allowedMolecules[from][msg.sender].sub(value);
209 
210         uint256 atomValue = value.mul(atomsPerMolecule);
211         atomBalances[from] = atomBalances[from].sub(atomValue);
212         atomBalances[to] = atomBalances[to].add(atomValue);
213         
214         emit Transfer(from, to, value);
215         return true;
216     }
217 
218     /**
219      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
220      * msg.sender. This method is included for ERC20 compatibility.
221      * IncreaseAllowance and decreaseAllowance should be used instead.
222      * @param spender The address which will spend the funds.
223      * @param value The amount of tokens to be spent.
224      */
225     function approve(address spender, uint256 value) public returns (bool) {
226         allowedMolecules[msg.sender][spender] = value;
227 
228         emit Approval(msg.sender, spender, value);
229         return true;
230     }
231 
232     /**
233      * @dev Increase the amount of tokens that an owner has allowed to a spender.
234      * This method should be used instead of approve() to avoid the double approval vulnerability.
235      * @param spender The address which will spend the funds.
236      * @param addedValue The amount of tokens to increase the allowance by.
237      */
238     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
239         allowedMolecules[msg.sender][spender] = allowedMolecules[msg.sender][spender].add(addedValue);
240 
241         emit Approval(msg.sender, spender, allowedMolecules[msg.sender][spender]);
242         return true;
243     }
244 
245     /**
246      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
247      * @param spender The address which will spend the funds.
248      * @param subtractedValue The amount of tokens to decrease the allowance by.
249      */
250     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
251         uint256 oldValue = allowedMolecules[msg.sender][spender];
252         if (subtractedValue >= oldValue) {
253             allowedMolecules[msg.sender][spender] = 0;
254         } else {
255             allowedMolecules[msg.sender][spender] = oldValue.sub(subtractedValue);
256         }
257         emit Approval(msg.sender, spender, allowedMolecules[msg.sender][spender]);
258         return true;
259     }
260 }
261 
262 abstract contract Context {
263     function _msgSender() internal view virtual returns (address payable) {
264         return msg.sender;
265     }
266 
267     function _msgData() internal view virtual returns (bytes memory) {
268         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
269         return msg.data;
270     }
271 }
272 
273 interface IERC20 {
274     /**
275      * @dev Returns the amount of tokens in existence.
276      */
277     function totalSupply() external view returns (uint256);
278 
279     /**
280      * @dev Returns the amount of tokens owned by `account`.
281      */
282     function balanceOf(address account) external view returns (uint256);
283 
284     /**
285      * @dev Moves `amount` tokens from the caller's account to `recipient`.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transfer(address recipient, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Returns the remaining number of tokens that `spender` will be
295      * allowed to spend on behalf of `owner` through {transferFrom}. This is
296      * zero by default.
297      *
298      * This value changes when {approve} or {transferFrom} are called.
299      */
300     function allowance(address owner, address spender) external view returns (uint256);
301 
302     /**
303      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * IMPORTANT: Beware that changing an allowance with this method brings the risk
308      * that someone may use both the old and the new allowance by unfortunate
309      * transaction ordering. One possible solution to mitigate this race
310      * condition is to first reduce the spender's allowance to 0 and set the
311      * desired value afterwards:
312      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
313      *
314      * Emits an {Approval} event.
315      */
316     function approve(address spender, uint256 amount) external returns (bool);
317 
318     /**
319      * @dev Moves `amount` tokens from `sender` to `recipient` using the
320      * allowance mechanism. `amount` is then deducted from the caller's
321      * allowance.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
328 
329     /**
330      * @dev Emitted when `value` tokens are moved from one account (`from`) to
331      * another (`to`).
332      *
333      * Note that `value` may be zero.
334      */
335     event Transfer(address indexed from, address indexed to, uint256 value);
336 
337     /**
338      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
339      * a call to {approve}. `value` is the new allowance.
340      */
341     event Approval(address indexed owner, address indexed spender, uint256 value);
342 }
343 
344 
345 library EnumerableSet {
346     // To implement this library for multiple types with as little code
347     // repetition as possible, we write it in terms of a generic Set type with
348     // bytes32 values.
349     // The Set implementation uses private functions, and user-facing
350     // implementations (such as AddressSet) are just wrappers around the
351     // underlying Set.
352     // This means that we can only create new EnumerableSets for types that fit
353     // in bytes32.
354 
355     struct Set {
356         // Storage of set values
357         bytes32[] _values;
358 
359         // Position of the value in the `values` array, plus 1 because index 0
360         // means a value is not in the set.
361         mapping (bytes32 => uint256) _indexes;
362     }
363 
364     /**
365      * @dev Add a value to a set. O(1).
366      *
367      * Returns true if the value was added to the set, that is if it was not
368      * already present.
369      */
370     function _add(Set storage set, bytes32 value) private returns (bool) {
371         if (!_contains(set, value)) {
372             set._values.push(value);
373             // The value is stored at length-1, but we add 1 to all indexes
374             // and use 0 as a sentinel value
375             set._indexes[value] = set._values.length;
376             return true;
377         } else {
378             return false;
379         }
380     }
381 
382     /**
383      * @dev Removes a value from a set. O(1).
384      *
385      * Returns true if the value was removed from the set, that is if it was
386      * present.
387      */
388     function _remove(Set storage set, bytes32 value) private returns (bool) {
389         // We read and store the value's index to prevent multiple reads from the same storage slot
390         uint256 valueIndex = set._indexes[value];
391 
392         if (valueIndex != 0) { // Equivalent to contains(set, value)
393             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
394             // the array, and then remove the last element (sometimes called as 'swap and pop').
395             // This modifies the order of the array, as noted in {at}.
396 
397             uint256 toDeleteIndex = valueIndex - 1;
398             uint256 lastIndex = set._values.length - 1;
399 
400             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
401             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
402 
403             bytes32 lastvalue = set._values[lastIndex];
404 
405             // Move the last value to the index where the value to delete is
406             set._values[toDeleteIndex] = lastvalue;
407             // Update the index for the moved value
408             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
409 
410             // Delete the slot where the moved value was stored
411             set._values.pop();
412 
413             // Delete the index for the deleted slot
414             delete set._indexes[value];
415 
416             return true;
417         } else {
418             return false;
419         }
420     }
421 
422     /**
423      * @dev Returns true if the value is in the set. O(1).
424      */
425     function _contains(Set storage set, bytes32 value) private view returns (bool) {
426         return set._indexes[value] != 0;
427     }
428 
429     /**
430      * @dev Returns the number of values on the set. O(1).
431      */
432     function _length(Set storage set) private view returns (uint256) {
433         return set._values.length;
434     }
435 
436    /**
437     * @dev Returns the value stored at position `index` in the set. O(1).
438     *
439     * Note that there are no guarantees on the ordering of values inside the
440     * array, and it may change when more values are added or removed.
441     *
442     * Requirements:
443     *
444     * - `index` must be strictly less than {length}.
445     */
446     function _at(Set storage set, uint256 index) private view returns (bytes32) {
447         require(set._values.length > index, "EnumerableSet: index out of bounds");
448         return set._values[index];
449     }
450 
451     // Bytes32Set
452 
453     struct Bytes32Set {
454         Set _inner;
455     }
456 
457     /**
458      * @dev Add a value to a set. O(1).
459      *
460      * Returns true if the value was added to the set, that is if it was not
461      * already present.
462      */
463     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
464         return _add(set._inner, value);
465     }
466 
467     /**
468      * @dev Removes a value from a set. O(1).
469      *
470      * Returns true if the value was removed from the set, that is if it was
471      * present.
472      */
473     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
474         return _remove(set._inner, value);
475     }
476 
477     /**
478      * @dev Returns true if the value is in the set. O(1).
479      */
480     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
481         return _contains(set._inner, value);
482     }
483 
484     /**
485      * @dev Returns the number of values in the set. O(1).
486      */
487     function length(Bytes32Set storage set) internal view returns (uint256) {
488         return _length(set._inner);
489     }
490 
491    /**
492     * @dev Returns the value stored at position `index` in the set. O(1).
493     *
494     * Note that there are no guarantees on the ordering of values inside the
495     * array, and it may change when more values are added or removed.
496     *
497     * Requirements:
498     *
499     * - `index` must be strictly less than {length}.
500     */
501     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
502         return _at(set._inner, index);
503     }
504 
505     // AddressSet
506 
507     struct AddressSet {
508         Set _inner;
509     }
510 
511     /**
512      * @dev Add a value to a set. O(1).
513      *
514      * Returns true if the value was added to the set, that is if it was not
515      * already present.
516      */
517     function add(AddressSet storage set, address value) internal returns (bool) {
518         return _add(set._inner, bytes32(uint256(value)));
519     }
520 
521     /**
522      * @dev Removes a value from a set. O(1).
523      *
524      * Returns true if the value was removed from the set, that is if it was
525      * present.
526      */
527     function remove(AddressSet storage set, address value) internal returns (bool) {
528         return _remove(set._inner, bytes32(uint256(value)));
529     }
530 
531     /**
532      * @dev Returns true if the value is in the set. O(1).
533      */
534     function contains(AddressSet storage set, address value) internal view returns (bool) {
535         return _contains(set._inner, bytes32(uint256(value)));
536     }
537 
538     /**
539      * @dev Returns the number of values in the set. O(1).
540      */
541     function length(AddressSet storage set) internal view returns (uint256) {
542         return _length(set._inner);
543     }
544 
545    /**
546     * @dev Returns the value stored at position `index` in the set. O(1).
547     *
548     * Note that there are no guarantees on the ordering of values inside the
549     * array, and it may change when more values are added or removed.
550     *
551     * Requirements:
552     *
553     * - `index` must be strictly less than {length}.
554     */
555     function at(AddressSet storage set, uint256 index) internal view returns (address) {
556         return address(uint256(_at(set._inner, index)));
557     }
558 
559 
560     // UintSet
561 
562     struct UintSet {
563         Set _inner;
564     }
565 
566     /**
567      * @dev Add a value to a set. O(1).
568      *
569      * Returns true if the value was added to the set, that is if it was not
570      * already present.
571      */
572     function add(UintSet storage set, uint256 value) internal returns (bool) {
573         return _add(set._inner, bytes32(value));
574     }
575 
576     /**
577      * @dev Removes a value from a set. O(1).
578      *
579      * Returns true if the value was removed from the set, that is if it was
580      * present.
581      */
582     function remove(UintSet storage set, uint256 value) internal returns (bool) {
583         return _remove(set._inner, bytes32(value));
584     }
585 
586     /**
587      * @dev Returns true if the value is in the set. O(1).
588      */
589     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
590         return _contains(set._inner, bytes32(value));
591     }
592 
593     /**
594      * @dev Returns the number of values on the set. O(1).
595      */
596     function length(UintSet storage set) internal view returns (uint256) {
597         return _length(set._inner);
598     }
599 
600    /**
601     * @dev Returns the value stored at position `index` in the set. O(1).
602     *
603     * Note that there are no guarantees on the ordering of values inside the
604     * array, and it may change when more values are added or removed.
605     *
606     * Requirements:
607     *
608     * - `index` must be strictly less than {length}.
609     */
610     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
611         return uint256(_at(set._inner, index));
612     }
613 }
614 
615 /**
616  * @dev Wrappers over Solidity's arithmetic operations with added overflow
617  * checks.
618  *
619  * Arithmetic operations in Solidity wrap on overflow. This can easily result
620  * in bugs, because programmers usually assume that an overflow raises an
621  * error, which is the standard behavior in high level programming languages.
622  * `SafeMath` restores this intuition by reverting the transaction when an
623  * operation overflows.
624  *
625  * Using this library instead of the unchecked operations eliminates an entire
626  * class of bugs, so it's recommended to use it always.
627  */
628 library SafeMath {
629     /**
630      * @dev Returns the addition of two unsigned integers, reverting on
631      * overflow.
632      *
633      * Counterpart to Solidity's `+` operator.
634      *
635      * Requirements:
636      *
637      * - Addition cannot overflow.
638      */
639     function add(uint256 a, uint256 b) internal pure returns (uint256) {
640         uint256 c = a + b;
641         require(c >= a, "SafeMath: addition overflow");
642 
643         return c;
644     }
645 
646     /**
647      * @dev Returns the subtraction of two unsigned integers, reverting on
648      * overflow (when the result is negative).
649      *
650      * Counterpart to Solidity's `-` operator.
651      *
652      * Requirements:
653      *
654      * - Subtraction cannot overflow.
655      */
656     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
657         return sub(a, b, "SafeMath: subtraction overflow");
658     }
659 
660     /**
661      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
662      * overflow (when the result is negative).
663      *
664      * Counterpart to Solidity's `-` operator.
665      *
666      * Requirements:
667      *
668      * - Subtraction cannot overflow.
669      */
670     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
671         require(b <= a, errorMessage);
672         uint256 c = a - b;
673 
674         return c;
675     }
676 
677     /**
678      * @dev Returns the multiplication of two unsigned integers, reverting on
679      * overflow.
680      *
681      * Counterpart to Solidity's `*` operator.
682      *
683      * Requirements:
684      *
685      * - Multiplication cannot overflow.
686      */
687     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
688         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
689         // benefit is lost if 'b' is also tested.
690         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
691         if (a == 0) {
692             return 0;
693         }
694 
695         uint256 c = a * b;
696         require(c / a == b, "SafeMath: multiplication overflow");
697 
698         return c;
699     }
700 
701     /**
702      * @dev Returns the integer division of two unsigned integers. Reverts on
703      * division by zero. The result is rounded towards zero.
704      *
705      * Counterpart to Solidity's `/` operator. Note: this function uses a
706      * `revert` opcode (which leaves remaining gas untouched) while Solidity
707      * uses an invalid opcode to revert (consuming all remaining gas).
708      *
709      * Requirements:
710      *
711      * - The divisor cannot be zero.
712      */
713     function div(uint256 a, uint256 b) internal pure returns (uint256) {
714         return div(a, b, "SafeMath: division by zero");
715     }
716 
717     /**
718      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
719      * division by zero. The result is rounded towards zero.
720      *
721      * Counterpart to Solidity's `/` operator. Note: this function uses a
722      * `revert` opcode (which leaves remaining gas untouched) while Solidity
723      * uses an invalid opcode to revert (consuming all remaining gas).
724      *
725      * Requirements:
726      *
727      * - The divisor cannot be zero.
728      */
729     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
730         require(b > 0, errorMessage);
731         uint256 c = a / b;
732         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
733 
734         return c;
735     }
736 
737     /**
738      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
739      * Reverts when dividing by zero.
740      *
741      * Counterpart to Solidity's `%` operator. This function uses a `revert`
742      * opcode (which leaves remaining gas untouched) while Solidity uses an
743      * invalid opcode to revert (consuming all remaining gas).
744      *
745      * Requirements:
746      *
747      * - The divisor cannot be zero.
748      */
749     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
750         return mod(a, b, "SafeMath: modulo by zero");
751     }
752 
753     /**
754      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
755      * Reverts with custom message when dividing by zero.
756      *
757      * Counterpart to Solidity's `%` operator. This function uses a `revert`
758      * opcode (which leaves remaining gas untouched) while Solidity uses an
759      * invalid opcode to revert (consuming all remaining gas).
760      *
761      * Requirements:
762      *
763      * - The divisor cannot be zero.
764      */
765     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
766         require(b != 0, errorMessage);
767         return a % b;
768     }
769 }
770 
771 /**
772  * @dev Collection of functions related to the address type
773  */
774 library Address {
775     /**
776      * @dev Returns true if `account` is a contract.
777      *
778      * [IMPORTANT]
779      * ====
780      * It is unsafe to assume that an address for which this function returns
781      * false is an externally-owned account (EOA) and not a contract.
782      *
783      * Among others, `isContract` will return false for the following
784      * types of addresses:
785      *
786      *  - an externally-owned account
787      *  - a contract in construction
788      *  - an address where a contract will be created
789      *  - an address where a contract lived, but was destroyed
790      * ====
791      */
792     function isContract(address account) internal view returns (bool) {
793         // This method relies on extcodesize, which returns 0 for contracts in
794         // construction, since the code is only stored at the end of the
795         // constructor execution.
796 
797         uint256 size;
798         // solhint-disable-next-line no-inline-assembly
799         assembly { size := extcodesize(account) }
800         return size > 0;
801     }
802 
803     /**
804      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
805      * `recipient`, forwarding all available gas and reverting on errors.
806      *
807      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
808      * of certain opcodes, possibly making contracts go over the 2300 gas limit
809      * imposed by `transfer`, making them unable to receive funds via
810      * `transfer`. {sendValue} removes this limitation.
811      *
812      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
813      *
814      * IMPORTANT: because control is transferred to `recipient`, care must be
815      * taken to not create reentrancy vulnerabilities. Consider using
816      * {ReentrancyGuard} or the
817      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
818      */
819     function sendValue(address payable recipient, uint256 amount) internal {
820         require(address(this).balance >= amount, "Address: insufficient balance");
821 
822         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
823         (bool success, ) = recipient.call{ value: amount }("");
824         require(success, "Address: unable to send value, recipient may have reverted");
825     }
826 
827     /**
828      * @dev Performs a Solidity function call using a low level `call`. A
829      * plain`call` is an unsafe replacement for a function call: use this
830      * function instead.
831      *
832      * If `target` reverts with a revert reason, it is bubbled up by this
833      * function (like regular Solidity function calls).
834      *
835      * Returns the raw returned data. To convert to the expected return value,
836      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
837      *
838      * Requirements:
839      *
840      * - `target` must be a contract.
841      * - calling `target` with `data` must not revert.
842      *
843      * _Available since v3.1._
844      */
845     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
846       return functionCall(target, data, "Address: low-level call failed");
847     }
848 
849     /**
850      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
851      * `errorMessage` as a fallback revert reason when `target` reverts.
852      *
853      * _Available since v3.1._
854      */
855     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
856         return functionCallWithValue(target, data, 0, errorMessage);
857     }
858 
859     /**
860      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
861      * but also transferring `value` wei to `target`.
862      *
863      * Requirements:
864      *
865      * - the calling contract must have an ETH balance of at least `value`.
866      * - the called Solidity function must be `payable`.
867      *
868      * _Available since v3.1._
869      */
870     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
871         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
872     }
873 
874     /**
875      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
876      * with `errorMessage` as a fallback revert reason when `target` reverts.
877      *
878      * _Available since v3.1._
879      */
880     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
881         require(address(this).balance >= value, "Address: insufficient balance for call");
882         require(isContract(target), "Address: call to non-contract");
883 
884         // solhint-disable-next-line avoid-low-level-calls
885         (bool success, bytes memory returndata) = target.call{ value: value }(data);
886         return _verifyCallResult(success, returndata, errorMessage);
887     }
888 
889     /**
890      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
891      * but performing a static call.
892      *
893      * _Available since v3.3._
894      */
895     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
896         return functionStaticCall(target, data, "Address: low-level static call failed");
897     }
898 
899     /**
900      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
901      * but performing a static call.
902      *
903      * _Available since v3.3._
904      */
905     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
906         require(isContract(target), "Address: static call to non-contract");
907 
908         // solhint-disable-next-line avoid-low-level-calls
909         (bool success, bytes memory returndata) = target.staticcall(data);
910         return _verifyCallResult(success, returndata, errorMessage);
911     }
912 
913     /**
914      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
915      * but performing a delegate call.
916      *
917      * _Available since v3.4._
918      */
919     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
920         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
921     }
922 
923     /**
924      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
925      * but performing a delegate call.
926      *
927      * _Available since v3.4._
928      */
929     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
930         require(isContract(target), "Address: delegate call to non-contract");
931 
932         // solhint-disable-next-line avoid-low-level-calls
933         (bool success, bytes memory returndata) = target.delegatecall(data);
934         return _verifyCallResult(success, returndata, errorMessage);
935     }
936 
937     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
938         if (success) {
939             return returndata;
940         } else {
941             // Look for revert reason and bubble it up if present
942             if (returndata.length > 0) {
943                 // The easiest way to bubble the revert reason is using memory via assembly
944 
945                 // solhint-disable-next-line no-inline-assembly
946                 assembly {
947                     let returndata_size := mload(returndata)
948                     revert(add(32, returndata), returndata_size)
949                 }
950             } else {
951                 revert(errorMessage);
952             }
953         }
954     }
955 }
956 
957 
958 /**
959  * @title SafeERC20
960  * @dev Wrappers around ERC20 operations that throw on failure (when the token
961  * contract returns false). Tokens that return no value (and instead revert or
962  * throw on failure) are also supported, non-reverting calls are assumed to be
963  * successful.
964  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
965  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
966  */
967 library SafeERC20 {
968     using SafeMath for uint256;
969     using Address for address;
970 
971     function safeTransfer(IERC20 token, address to, uint256 value) internal {
972         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
973     }
974 
975     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
976         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
977     }
978 
979     /**
980      * @dev Deprecated. This function has issues similar to the ones found in
981      * {IERC20-approve}, and its usage is discouraged.
982      *
983      * Whenever possible, use {safeIncreaseAllowance} and
984      * {safeDecreaseAllowance} instead.
985      */
986     function safeApprove(IERC20 token, address spender, uint256 value) internal {
987         // safeApprove should only be called when setting an initial allowance,
988         // or when resetting it to zero. To increase and decrease it, use
989         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
990         // solhint-disable-next-line max-line-length
991         require((value == 0) || (token.allowance(address(this), spender) == 0),
992             "SafeERC20: approve from non-zero to non-zero allowance"
993         );
994         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
995     }
996 
997     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
998         uint256 newAllowance = token.allowance(address(this), spender).add(value);
999         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1000     }
1001 
1002     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1003         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1004         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1005     }
1006 
1007     /**
1008      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1009      * on the return value: the return value is optional (but if data is returned, it must not be false).
1010      * @param token The token targeted by the call.
1011      * @param data The call data (encoded using abi.encode or one of its variants).
1012      */
1013     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1014         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1015         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1016         // the target address contains contract code and also asserts for success in the low-level call.
1017 
1018         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1019         if (returndata.length > 0) { // Return data is optional
1020             // solhint-disable-next-line max-line-length
1021             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1022         }
1023     }
1024 }
1025 
1026 
1027 contract Ownable is Context {
1028     address private _owner;
1029 
1030     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1031 
1032     /**
1033      * @dev Initializes the contract setting the deployer as the initial owner.
1034      */
1035     constructor () internal {
1036         address msgSender = _msgSender();
1037         _owner = msgSender;
1038         emit OwnershipTransferred(address(0), msgSender);
1039     }
1040 
1041     /**
1042      * @dev Returns the address of the current owner.
1043      */
1044     function owner() public view returns (address) {
1045         return _owner;
1046     }
1047 
1048     /**
1049      * @dev Throws if called by any account other than the owner.
1050      */
1051     modifier onlyOwner() {
1052         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1053         _;
1054     }
1055 
1056     /**
1057      * @dev Leaves the contract without owner. It will not be possible to call
1058      * `onlyOwner` functions anymore. Can only be called by the current owner.
1059      *
1060      * NOTE: Renouncing ownership will leave the contract without an owner,
1061      * thereby removing any functionality that is only available to the owner.
1062      */
1063     function renounceOwnership() public virtual onlyOwner {
1064         emit OwnershipTransferred(_owner, address(0));
1065         _owner = address(0);
1066     }
1067 
1068     /**
1069      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1070      * Can only be called by the current owner.
1071      */
1072     function transferOwnership(address newOwner) public virtual onlyOwner {
1073         require(newOwner != address(0), "Ownable: new owner is the zero address");
1074         emit OwnershipTransferred(_owner, newOwner);
1075         _owner = newOwner;
1076     }
1077 }
1078 
1079 contract Memestake is Ownable {
1080     using SafeMath for uint256;
1081     using SafeERC20 for IERC20; 
1082     
1083        
1084     struct UserInfo{
1085         uint256 amount; // How many tokens got staked by user.
1086         uint256 rewardDebt; // Reward debt. See Explanation below.
1087 
1088         // We do some fancy math here. Basically, any point in time, the amount of 
1089         // claimable MFUND by a user is:
1090         //
1091         //   pending reward = (user.amount * pool.accMFundPerShare) - user.rewardDebt
1092         //
1093         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1094         //   1. The pool's `accMfundPerShare` (and `lastRewardedBlock`) gets updated.
1095         //   2. User receives the pending reward sent to his/her address.
1096         //   3. User's `amount` gets updated.
1097         //   4. User's `rewardDebt` gets updated.
1098     }
1099 
1100     struct PoolInfo {
1101         IERC20 tokenContract; // Address of Token contract.
1102         uint256 allocPoint; // Allocation points from the pool
1103         uint256 lastRewardBlock; // Last block number where MFUND got distributed.
1104         uint256 accMfundPerShare; // Accumulated MFUND per share.
1105     }
1106 
1107     Memefund public mFundToken;
1108     uint256 public mFundPerBlock;
1109 
1110     PoolInfo[] public poolInfo;
1111 
1112     mapping (uint256 => mapping(address => UserInfo)) public userInfo;
1113 
1114     mapping (address => bool) isTokenContractAdded;
1115 
1116     uint256 public totalAllocPoint;
1117 
1118     uint256 public totalMfund;
1119 
1120     uint256 public startBlock;
1121 
1122     uint256 public endBlock;
1123 
1124     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1125     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1126     event Claim(address indexed user, uint256 indexed pid, uint256 amount);
1127     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1128 
1129 
1130 
1131     constructor(Memefund _mFundToken,
1132                 uint256 _totalMfund,
1133                 uint256 _startBlock,
1134                 uint256 _endBlock) public{
1135                 require(address(_mFundToken) != address(0), "constructor: _mFundToken must not be zero address!");
1136                 require(_totalMfund > 0, "constructor: _totalMfund must be greater than 0");
1137 
1138                 mFundToken = _mFundToken;
1139                 totalMfund = _totalMfund;
1140                 startBlock = _startBlock;
1141                 endBlock = _endBlock;
1142                 
1143                 uint256 numberOfBlocksForFarming = endBlock.sub(startBlock);
1144                 mFundPerBlock = totalMfund.div(numberOfBlocksForFarming);
1145     }
1146     
1147     /// @notice Returns the number of pools that have been added by the owner
1148     /// @return Number of pools
1149     function numberOfPools() external view returns(uint256){
1150         return poolInfo.length;
1151     }
1152     
1153 
1154     /// @notice Create a new LPT pool by whitelisting a new ERC20 token.
1155     /// @dev Can only be called by the contract owner
1156     /// @param _allocPoint Governs what percentage of the total LPT rewards this pool and other pools will get
1157     /// @param _tokenContract Address of the staking token being whitelisted
1158     /// @param _withUpdate Set to true for updating all pools before adding this one
1159     function add(uint256 _allocPoint, IERC20 _tokenContract, bool _withUpdate) public onlyOwner {
1160         require(block.number < endBlock, "add: must be before end");
1161         address tokenContractAddress = address(_tokenContract);
1162         require(tokenContractAddress != address(0), "add: _tokenConctract must not be zero address");
1163         require(isTokenContractAdded[tokenContractAddress] == false, "add: already whitelisted");
1164 
1165         if (_withUpdate) {
1166             massUpdatePools();
1167         }
1168 
1169         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1170         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1171         poolInfo.push(PoolInfo({
1172             tokenContract : _tokenContract,
1173             allocPoint : _allocPoint,
1174             lastRewardBlock : lastRewardBlock,
1175             accMfundPerShare : 0
1176         }));
1177 
1178         isTokenContractAdded[tokenContractAddress] = true;
1179     }
1180 
1181     /// @notice Update a pool's allocation point to increase or decrease its share of contract-level rewards
1182     /// @notice Can also update the max amount that can be staked per user
1183     /// @dev Can only be called by the owner
1184     /// @param _pid ID of the pool being updated
1185     /// @param _allocPoint New allocation point
1186     /// @param _withUpdate Set to true if you want to update all pools before making this change - it will checkpoint those rewards
1187     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1188         require(block.number < endBlock, "set: must be before end");
1189         require(_pid < poolInfo.length, "set: invalid _pid");
1190 
1191         if (_withUpdate) {
1192             massUpdatePools();
1193         }
1194 
1195         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1196 
1197         poolInfo[_pid].allocPoint = _allocPoint;
1198     }
1199 
1200     /// @notice View function to see pending and unclaimed Mfunds for a given user
1201     /// @param _pid ID of the pool where a user has a stake
1202     /// @param _user Account being queried
1203     /// @return Amount of MFUND tokens due to a user
1204     function pendingRewards(uint256 _pid, address _user) external view returns (uint256) {
1205         require(_pid < poolInfo.length, "pendingMfund: invalid _pid");
1206 
1207         PoolInfo storage pool = poolInfo[_pid];
1208         UserInfo storage user = userInfo[_pid][_user];
1209 
1210         uint256 accMfundPerShare = pool.accMfundPerShare;
1211         uint256 lpSupply = pool.tokenContract.balanceOf(address(this));
1212 
1213         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1214             uint256 maxBlock = block.number <= endBlock ? block.number : endBlock;
1215             uint256 multiplier = getMultiplier(pool.lastRewardBlock, maxBlock);
1216             uint256 mFundReward = multiplier.mul(mFundPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1217             accMfundPerShare = accMfundPerShare.add(mFundReward.mul(1e18).div(lpSupply));
1218         }
1219 
1220         return user.amount.mul(accMfundPerShare).div(1e18).sub(user.rewardDebt);
1221     }
1222     
1223     
1224     function claimRewards(uint256 _pid) public{
1225         PoolInfo storage pool = poolInfo[_pid];
1226         UserInfo storage user = userInfo[_pid][msg.sender];
1227         updatePool(_pid);
1228         uint256 pending = user.amount.mul(pool.accMfundPerShare).div(1e24).sub(user.rewardDebt);
1229         require(pending > 0, "harvest: no reward owed");
1230         user.rewardDebt = user.amount.mul(pool.accMfundPerShare).div(1e24);
1231         safeMfundTransfer(msg.sender, pending);
1232         emit Claim(msg.sender, _pid, pending);
1233     }
1234         /// @notice Cycles through the pools to update all of the rewards accrued
1235     function massUpdatePools() public {
1236         uint256 length = poolInfo.length;
1237         for (uint256 pid = 0; pid < length; ++pid) {
1238             updatePool(pid);
1239         }
1240     }
1241     
1242     
1243     
1244 
1245     /// @notice Updates a specific pool to track all of the rewards accrued up to the TX block
1246     /// @param _pid ID of the pool
1247     function updatePool(uint256 _pid) public {
1248         require(_pid < poolInfo.length, "updatePool: invalid _pid");
1249 
1250         PoolInfo storage pool = poolInfo[_pid];
1251         if (block.number <= pool.lastRewardBlock) {
1252             return;
1253         }
1254 
1255         uint256 tokenContractSupply = pool.tokenContract.balanceOf(address(this));
1256         if (tokenContractSupply == 0) {
1257             pool.lastRewardBlock = block.number;
1258             return;
1259         }
1260 
1261         uint256 maxEndBlock = block.number <= endBlock ? block.number : endBlock;
1262         uint256 multiplier = getMultiplier(pool.lastRewardBlock, maxEndBlock);
1263 
1264         // No point in doing any more logic as the rewards have ended
1265         if (multiplier == 0) {
1266             return;
1267         }
1268 
1269         uint256 mFundReward = multiplier.mul(mFundPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1270 
1271         pool.accMfundPerShare = pool.accMfundPerShare.add(mFundReward.mul(1e18).div(tokenContractSupply));
1272         pool.lastRewardBlock = maxEndBlock;
1273     }
1274 
1275     /// @notice Where any user can stake their ERC20 tokens into a pool in order to farm $LPT
1276     /// @param _pid ID of the pool
1277     /// @param _amount Amount of ERC20 being staked
1278     function deposit(uint256 _pid, uint256 _amount) external {
1279         PoolInfo storage pool = poolInfo[_pid];
1280         UserInfo storage user = userInfo[_pid][msg.sender];
1281         updatePool(_pid);
1282 
1283         if (user.amount > 0) {
1284             uint256 pending = user.amount.mul(pool.accMfundPerShare).div(1e18).sub(user.rewardDebt);
1285             if (pending > 0) {
1286                 safeMfundTransfer(msg.sender, pending);
1287             }
1288         }
1289 
1290         if (_amount > 0) {
1291             pool.tokenContract.safeTransferFrom(address(msg.sender), address(this), _amount);
1292             user.amount = user.amount.add(_amount);
1293         }
1294 
1295         user.rewardDebt = user.amount.mul(pool.accMfundPerShare).div(1e18);
1296         emit Deposit(msg.sender, _pid, _amount);
1297     }
1298 
1299     /// @notice Allows a user to withdraw any ERC20 tokens staked in a pool
1300     /// @dev Partial withdrawals permitted
1301     /// @param _pid Pool ID
1302     /// @param _amount Being withdrawn
1303     function withdraw(uint256 _pid, uint256 _amount) external {
1304         PoolInfo storage pool = poolInfo[_pid];
1305         UserInfo storage user = userInfo[_pid][msg.sender];
1306 
1307         require(user.amount >= _amount, "withdraw: _amount not good");
1308 
1309         updatePool(_pid);
1310 
1311         uint256 pending = user.amount.mul(pool.accMfundPerShare).div(1e18).sub(user.rewardDebt);
1312         if (pending > 0) {
1313             safeMfundTransfer(msg.sender, pending);
1314         }
1315 
1316         if (_amount > 0) {
1317             user.amount = user.amount.sub(_amount);
1318             pool.tokenContract.safeTransfer(address(msg.sender), _amount);
1319         }
1320 
1321         user.rewardDebt = user.amount.mul(pool.accMfundPerShare).div(1e18);
1322         emit Withdraw(msg.sender, _pid, _amount);
1323     }
1324 
1325     /// @notice Emergency only. Should the rewards issuance mechanism fail, people can still withdraw their stake
1326     /// @param _pid Pool ID
1327     function emergencyWithdraw(uint256 _pid) external {
1328         require(_pid < poolInfo.length, "updatePool: invalid _pid");
1329 
1330         PoolInfo storage pool = poolInfo[_pid];
1331         UserInfo storage user = userInfo[_pid][msg.sender];
1332 
1333         uint256 amount = user.amount;
1334         user.amount = 0;
1335         user.rewardDebt = 0;
1336 
1337         pool.tokenContract.safeTransfer(address(msg.sender), amount);
1338         emit EmergencyWithdraw(msg.sender, _pid, amount);
1339     }
1340 
1341     ////////////
1342     // Private /
1343     ////////////
1344 
1345     /// @dev Safe MFUND transfer function, just in case if rounding error causes pool to not have enough LPTs.
1346     /// @param _to Whom to send MFUND into
1347     /// @param _amount of MFUND to send
1348     function safeMfundTransfer(address _to, uint256 _amount) internal {
1349         uint256 mFundBal = mFundToken.balanceOf(address(this));
1350         if (_amount > mFundBal) {
1351             mFundToken.transfer(_to, mFundBal);
1352         } else {
1353             mFundToken.transfer(_to, _amount);
1354         }
1355     }
1356 
1357     /// @notice Return reward multiplier over the given _from to _to block.
1358     /// @param _from Block number
1359     /// @param _to Block number
1360     /// @return Number of blocks that have passed
1361     function getMultiplier(uint256 _from, uint256 _to) private view returns (uint256) {
1362         return _to.sub(_from);
1363     }
1364 }