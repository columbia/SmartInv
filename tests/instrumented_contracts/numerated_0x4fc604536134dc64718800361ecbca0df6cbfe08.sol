1 pragma solidity 0.5.0;
2 
3 library UniformRandomNumber {
4   /// @author Brendan Asselstine
5   /// @notice Select a random number without modulo bias using a random seed and upper bound
6   /// @param _entropy The seed for randomness
7   /// @param _upperBound The upper bound of the desired number
8   /// @return A random number less than the _upperBound
9   function uniform(uint256 _entropy, uint256 _upperBound) internal pure returns (uint256) {
10     uint256 min = -_upperBound % _upperBound;
11     uint256 random = _entropy;
12     while (true) {
13       if (random >= min) {
14         break;
15       }
16       random = uint256(keccak256(abi.encodePacked(random)));
17     }
18     return random % _upperBound;
19   }
20 }
21 
22 contract ICErc20 {
23     address public underlying;
24     function mint(uint mintAmount) external returns (uint);
25     function redeemUnderlying(uint redeemAmount) external returns (uint);
26     function balanceOfUnderlying(address owner) external returns (uint);
27     function getCash() external view returns (uint);
28     function supplyRatePerBlock() external view returns (uint);
29 }
30 
31 
32 /**
33  * @title ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/20
35  */
36 interface IERC20 {
37     function transfer(address to, uint256 value) external returns (bool);
38 
39     function approve(address spender, uint256 value) external returns (bool);
40 
41     function transferFrom(address from, address to, uint256 value) external returns (bool);
42 
43     function totalSupply() external view returns (uint256);
44 
45     function balanceOf(address who) external view returns (uint256);
46 
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 
55 
56 
57 
58 /**
59  * @title SafeMath
60  * @dev Unsigned math operations with safety checks that revert on error
61  */
62 library SafeMath {
63     /**
64     * @dev Multiplies two unsigned integers, reverts on overflow.
65     */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
82     */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0);
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94     */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b <= a);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103     * @dev Adds two unsigned integers, reverts on overflow.
104     */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a);
108 
109         return c;
110     }
111 
112     /**
113     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
114     * reverts when dividing by zero.
115     */
116     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
117         require(b != 0);
118         return a % b;
119     }
120 }
121 
122 
123 
124 
125 
126 
127 
128 /**
129  * @title Initializable
130  *
131  * @dev Helper contract to support initializer functions. To use it, replace
132  * the constructor with a function that has the `initializer` modifier.
133  * WARNING: Unlike constructors, initializer functions must be manually
134  * invoked. This applies both to deploying an Initializable contract, as well
135  * as extending an Initializable contract via inheritance.
136  * WARNING: When used with inheritance, manual care must be taken to not invoke
137  * a parent initializer twice, or ensure that all initializers are idempotent,
138  * because this is not dealt with automatically as with constructors.
139  */
140 contract Initializable {
141 
142   /**
143    * @dev Indicates that the contract has been initialized.
144    */
145   bool private initialized;
146 
147   /**
148    * @dev Indicates that the contract is in the process of being initialized.
149    */
150   bool private initializing;
151 
152   /**
153    * @dev Modifier to use in the initializer function of a contract.
154    */
155   modifier initializer() {
156     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
157 
158     bool wasInitializing = initializing;
159     initializing = true;
160     initialized = true;
161 
162     _;
163 
164     initializing = wasInitializing;
165   }
166 
167   /// @dev Returns true if and only if the function is running in the constructor
168   function isConstructor() private view returns (bool) {
169     // extcodesize checks the size of the code stored in an address, and
170     // address returns the current address. Since the code is still not
171     // deployed when running a constructor, any checks on its code size will
172     // yield zero, making it an effective way to detect if a contract is
173     // under construction or not.
174     uint256 cs;
175     assembly { cs := extcodesize(address) }
176     return cs == 0;
177   }
178 
179   // Reserved storage space to allow for layout changes in the future.
180   uint256[50] private ______gap;
181 }
182 
183 
184 /**
185  * @title Ownable
186  * @dev The Ownable contract has an owner address, and provides basic authorization control
187  * functions, this simplifies the implementation of "user permissions".
188  */
189 contract Ownable is Initializable {
190     address private _owner;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194     /**
195      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
196      * account.
197      */
198     function initialize(address sender) public initializer {
199         _owner = sender;
200         emit OwnershipTransferred(address(0), _owner);
201     }
202 
203     /**
204      * @return the address of the owner.
205      */
206     function owner() public view returns (address) {
207         return _owner;
208     }
209 
210     /**
211      * @dev Throws if called by any account other than the owner.
212      */
213     modifier onlyOwner() {
214         require(isOwner());
215         _;
216     }
217 
218     /**
219      * @return true if `msg.sender` is the owner of the contract.
220      */
221     function isOwner() public view returns (bool) {
222         return msg.sender == _owner;
223     }
224 
225     /**
226      * @dev Allows the current owner to relinquish control of the contract.
227      * @notice Renouncing to ownership will leave the contract without an owner.
228      * It will not be possible to call the functions with the `onlyOwner`
229      * modifier anymore.
230      */
231     function renounceOwnership() public onlyOwner {
232         emit OwnershipTransferred(_owner, address(0));
233         _owner = address(0);
234     }
235 
236     /**
237      * @dev Allows the current owner to transfer control of the contract to a newOwner.
238      * @param newOwner The address to transfer ownership to.
239      */
240     function transferOwnership(address newOwner) public onlyOwner {
241         _transferOwnership(newOwner);
242     }
243 
244     /**
245      * @dev Transfers control of the contract to a newOwner.
246      * @param newOwner The address to transfer ownership to.
247      */
248     function _transferOwnership(address newOwner) internal {
249         require(newOwner != address(0));
250         emit OwnershipTransferred(_owner, newOwner);
251         _owner = newOwner;
252     }
253 
254     uint256[50] private ______gap;
255 }
256 
257 /**
258  *  @reviewers: [@clesaege, @unknownunknown1, @ferittuncer]
259  *  @auditors: []
260  *  @bounties: [<14 days 10 ETH max payout>]
261  *  @deployments: []
262  */
263 
264 
265 
266 /**
267  *  @title SortitionSumTreeFactory
268  *  @author Enrique Piqueras - <epiquerass@gmail.com>
269  *  @dev A factory of trees that keep track of staked values for sortition.
270  */
271 library SortitionSumTreeFactory {
272     /* Structs */
273 
274     struct SortitionSumTree {
275         uint K; // The maximum number of childs per node.
276         // We use this to keep track of vacant positions in the tree after removing a leaf. This is for keeping the tree as balanced as possible without spending gas on moving nodes around.
277         uint[] stack;
278         uint[] nodes;
279         // Two-way mapping of IDs to node indexes. Note that node index 0 is reserved for the root node, and means the ID does not have a node.
280         mapping(bytes32 => uint) IDsToNodeIndexes;
281         mapping(uint => bytes32) nodeIndexesToIDs;
282     }
283 
284     /* Storage */
285 
286     struct SortitionSumTrees {
287         mapping(bytes32 => SortitionSumTree) sortitionSumTrees;
288     }
289 
290     /* Public */
291 
292     /**
293      *  @dev Create a sortition sum tree at the specified key.
294      *  @param _key The key of the new tree.
295      *  @param _K The number of children each node in the tree should have.
296      */
297     function createTree(SortitionSumTrees storage self, bytes32 _key, uint _K) public {
298         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
299         require(tree.K == 0, "Tree already exists.");
300         require(_K > 1, "K must be greater than one.");
301         tree.K = _K;
302         tree.stack.length = 0;
303         tree.nodes.length = 0;
304         tree.nodes.push(0);
305     }
306 
307     /**
308      *  @dev Set a value of a tree.
309      *  @param _key The key of the tree.
310      *  @param _value The new value.
311      *  @param _ID The ID of the value.
312      *  `O(log_k(n))` where
313      *  `k` is the maximum number of childs per node in the tree,
314      *   and `n` is the maximum number of nodes ever appended.
315      */
316     function set(SortitionSumTrees storage self, bytes32 _key, uint _value, bytes32 _ID) public {
317         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
318         uint treeIndex = tree.IDsToNodeIndexes[_ID];
319 
320         if (treeIndex == 0) { // No existing node.
321             if (_value != 0) { // Non zero value.
322                 // Append.
323                 // Add node.
324                 if (tree.stack.length == 0) { // No vacant spots.
325                     // Get the index and append the value.
326                     treeIndex = tree.nodes.length;
327                     tree.nodes.push(_value);
328 
329                     // Potentially append a new node and make the parent a sum node.
330                     if (treeIndex != 1 && (treeIndex - 1) % tree.K == 0) { // Is first child.
331                         uint parentIndex = treeIndex / tree.K;
332                         bytes32 parentID = tree.nodeIndexesToIDs[parentIndex];
333                         uint newIndex = treeIndex + 1;
334                         tree.nodes.push(tree.nodes[parentIndex]);
335                         delete tree.nodeIndexesToIDs[parentIndex];
336                         tree.IDsToNodeIndexes[parentID] = newIndex;
337                         tree.nodeIndexesToIDs[newIndex] = parentID;
338                     }
339                 } else { // Some vacant spot.
340                     // Pop the stack and append the value.
341                     treeIndex = tree.stack[tree.stack.length - 1];
342                     tree.stack.length--;
343                     tree.nodes[treeIndex] = _value;
344                 }
345 
346                 // Add label.
347                 tree.IDsToNodeIndexes[_ID] = treeIndex;
348                 tree.nodeIndexesToIDs[treeIndex] = _ID;
349 
350                 updateParents(self, _key, treeIndex, true, _value);
351             }
352         } else { // Existing node.
353             if (_value == 0) { // Zero value.
354                 // Remove.
355                 // Remember value and set to 0.
356                 uint value = tree.nodes[treeIndex];
357                 tree.nodes[treeIndex] = 0;
358 
359                 // Push to stack.
360                 tree.stack.push(treeIndex);
361 
362                 // Clear label.
363                 delete tree.IDsToNodeIndexes[_ID];
364                 delete tree.nodeIndexesToIDs[treeIndex];
365 
366                 updateParents(self, _key, treeIndex, false, value);
367             } else if (_value != tree.nodes[treeIndex]) { // New, non zero value.
368                 // Set.
369                 bool plusOrMinus = tree.nodes[treeIndex] <= _value;
370                 uint plusOrMinusValue = plusOrMinus ? _value - tree.nodes[treeIndex] : tree.nodes[treeIndex] - _value;
371                 tree.nodes[treeIndex] = _value;
372 
373                 updateParents(self, _key, treeIndex, plusOrMinus, plusOrMinusValue);
374             }
375         }
376     }
377 
378     /* Public Views */
379 
380     /**
381      *  @dev Query the leaves of a tree. Note that if `startIndex == 0`, the tree is empty and the root node will be returned.
382      *  @param _key The key of the tree to get the leaves from.
383      *  @param _cursor The pagination cursor.
384      *  @param _count The number of items to return.
385      *  @return The index at which leaves start, the values of the returned leaves, and whether there are more for pagination.
386      *  `O(n)` where
387      *  `n` is the maximum number of nodes ever appended.
388      */
389     function queryLeafs(
390         SortitionSumTrees storage self,
391         bytes32 _key,
392         uint _cursor,
393         uint _count
394     ) public view returns(uint startIndex, uint[] memory values, bool hasMore) {
395         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
396 
397         // Find the start index.
398         for (uint i = 0; i < tree.nodes.length; i++) {
399             if ((tree.K * i) + 1 >= tree.nodes.length) {
400                 startIndex = i;
401                 break;
402             }
403         }
404 
405         // Get the values.
406         uint loopStartIndex = startIndex + _cursor;
407         values = new uint[](loopStartIndex + _count > tree.nodes.length ? tree.nodes.length - loopStartIndex : _count);
408         uint valuesIndex = 0;
409         for (uint j = loopStartIndex; j < tree.nodes.length; j++) {
410             if (valuesIndex < _count) {
411                 values[valuesIndex] = tree.nodes[j];
412                 valuesIndex++;
413             } else {
414                 hasMore = true;
415                 break;
416             }
417         }
418     }
419 
420     /**
421      *  @dev Draw an ID from a tree using a number. Note that this function reverts if the sum of all values in the tree is 0.
422      *  @param _key The key of the tree.
423      *  @param _drawnNumber The drawn number.
424      *  @return The drawn ID.
425      *  `O(k * log_k(n))` where
426      *  `k` is the maximum number of childs per node in the tree,
427      *   and `n` is the maximum number of nodes ever appended.
428      */
429     function draw(SortitionSumTrees storage self, bytes32 _key, uint _drawnNumber) public view returns(bytes32 ID) {
430         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
431         uint treeIndex = 0;
432         uint currentDrawnNumber = _drawnNumber % tree.nodes[0];
433 
434         while ((tree.K * treeIndex) + 1 < tree.nodes.length)  // While it still has children.
435             for (uint i = 1; i <= tree.K; i++) { // Loop over children.
436                 uint nodeIndex = (tree.K * treeIndex) + i;
437                 uint nodeValue = tree.nodes[nodeIndex];
438 
439                 if (currentDrawnNumber >= nodeValue) currentDrawnNumber -= nodeValue; // Go to the next child.
440                 else { // Pick this child.
441                     treeIndex = nodeIndex;
442                     break;
443                 }
444             }
445         
446         ID = tree.nodeIndexesToIDs[treeIndex];
447     }
448 
449     /** @dev Gets a specified ID's associated value.
450      *  @param _key The key of the tree.
451      *  @param _ID The ID of the value.
452      *  @return The associated value.
453      */
454     function stakeOf(SortitionSumTrees storage self, bytes32 _key, bytes32 _ID) public view returns(uint value) {
455         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
456         uint treeIndex = tree.IDsToNodeIndexes[_ID];
457 
458         if (treeIndex == 0) value = 0;
459         else value = tree.nodes[treeIndex];
460     }
461 
462     /* Private */
463 
464     /**
465      *  @dev Update all the parents of a node.
466      *  @param _key The key of the tree to update.
467      *  @param _treeIndex The index of the node to start from.
468      *  @param _plusOrMinus Wether to add (true) or substract (false).
469      *  @param _value The value to add or substract.
470      *  `O(log_k(n))` where
471      *  `k` is the maximum number of childs per node in the tree,
472      *   and `n` is the maximum number of nodes ever appended.
473      */
474     function updateParents(SortitionSumTrees storage self, bytes32 _key, uint _treeIndex, bool _plusOrMinus, uint _value) private {
475         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
476 
477         uint parentIndex = _treeIndex;
478         while (parentIndex != 0) {
479             parentIndex = (parentIndex - 1) / tree.K;
480             tree.nodes[parentIndex] = _plusOrMinus ? tree.nodes[parentIndex] + _value : tree.nodes[parentIndex] - _value;
481         }
482     }
483 }
484 
485 
486 
487 
488 
489 /**
490  * @title FixidityLib
491  * @author Gadi Guy, Alberto Cuesta Canada
492  * @notice This library provides fixed point arithmetic with protection against
493  * overflow. 
494  * All operations are done with int256 and the operands must have been created 
495  * with any of the newFrom* functions, which shift the comma digits() to the 
496  * right and check for limits.
497  * When using this library be sure of using maxNewFixed() as the upper limit for
498  * creation of fixed point numbers. Use maxFixedMul(), maxFixedDiv() and
499  * maxFixedAdd() if you want to be certain that those operations don't 
500  * overflow.
501  */
502 library FixidityLib {
503 
504     /**
505      * @notice Number of positions that the comma is shifted to the right.
506      */
507     function digits() public pure returns(uint8) {
508         return 24;
509     }
510     
511     /**
512      * @notice This is 1 in the fixed point units used in this library.
513      * @dev Test fixed1() equals 10^digits()
514      * Hardcoded to 24 digits.
515      */
516     function fixed1() public pure returns(int256) {
517         return 1000000000000000000000000;
518     }
519 
520     /**
521      * @notice The amount of decimals lost on each multiplication operand.
522      * @dev Test mulPrecision() equals sqrt(fixed1)
523      * Hardcoded to 24 digits.
524      */
525     function mulPrecision() public pure returns(int256) {
526         return 1000000000000;
527     }
528 
529     /**
530      * @notice Maximum value that can be represented in an int256
531      * @dev Test maxInt256() equals 2^255 -1
532      */
533     function maxInt256() public pure returns(int256) {
534         return 57896044618658097711785492504343953926634992332820282019728792003956564819967;
535     }
536 
537     /**
538      * @notice Minimum value that can be represented in an int256
539      * @dev Test minInt256 equals (2^255) * (-1)
540      */
541     function minInt256() public pure returns(int256) {
542         return -57896044618658097711785492504343953926634992332820282019728792003956564819968;
543     }
544 
545     /**
546      * @notice Maximum value that can be converted to fixed point. Optimize for
547      * @dev deployment. 
548      * Test maxNewFixed() equals maxInt256() / fixed1()
549      * Hardcoded to 24 digits.
550      */
551     function maxNewFixed() public pure returns(int256) {
552         return 57896044618658097711785492504343953926634992332820282;
553     }
554 
555     /**
556      * @notice Maximum value that can be converted to fixed point. Optimize for
557      * deployment. 
558      * @dev Test minNewFixed() equals -(maxInt256()) / fixed1()
559      * Hardcoded to 24 digits.
560      */
561     function minNewFixed() public pure returns(int256) {
562         return -57896044618658097711785492504343953926634992332820282;
563     }
564 
565     /**
566      * @notice Maximum value that can be safely used as an addition operator.
567      * @dev Test maxFixedAdd() equals maxInt256()-1 / 2
568      * Test add(maxFixedAdd(),maxFixedAdd()) equals maxFixedAdd() + maxFixedAdd()
569      * Test add(maxFixedAdd()+1,maxFixedAdd()) throws 
570      * Test add(-maxFixedAdd(),-maxFixedAdd()) equals -maxFixedAdd() - maxFixedAdd()
571      * Test add(-maxFixedAdd(),-maxFixedAdd()-1) throws 
572      */
573     function maxFixedAdd() public pure returns(int256) {
574         return 28948022309329048855892746252171976963317496166410141009864396001978282409983;
575     }
576 
577     /**
578      * @notice Maximum negative value that can be safely in a subtraction.
579      * @dev Test maxFixedSub() equals minInt256() / 2
580      */
581     function maxFixedSub() public pure returns(int256) {
582         return -28948022309329048855892746252171976963317496166410141009864396001978282409984;
583     }
584 
585     /**
586      * @notice Maximum value that can be safely used as a multiplication operator.
587      * @dev Calculated as sqrt(maxInt256()*fixed1()). 
588      * Be careful with your sqrt() implementation. I couldn't find a calculator
589      * that would give the exact square root of maxInt256*fixed1 so this number
590      * is below the real number by no more than 3*10**28. It is safe to use as
591      * a limit for your multiplications, although powers of two of numbers over
592      * this value might still work.
593      * Test multiply(maxFixedMul(),maxFixedMul()) equals maxFixedMul() * maxFixedMul()
594      * Test multiply(maxFixedMul(),maxFixedMul()+1) throws 
595      * Test multiply(-maxFixedMul(),maxFixedMul()) equals -maxFixedMul() * maxFixedMul()
596      * Test multiply(-maxFixedMul(),maxFixedMul()+1) throws 
597      * Hardcoded to 24 digits.
598      */
599     function maxFixedMul() public pure returns(int256) {
600         return 240615969168004498257251713877715648331380787511296;
601     }
602 
603     /**
604      * @notice Maximum value that can be safely used as a dividend.
605      * @dev divide(maxFixedDiv,newFixedFraction(1,fixed1())) = maxInt256().
606      * Test maxFixedDiv() equals maxInt256()/fixed1()
607      * Test divide(maxFixedDiv(),multiply(mulPrecision(),mulPrecision())) = maxFixedDiv()*(10^digits())
608      * Test divide(maxFixedDiv()+1,multiply(mulPrecision(),mulPrecision())) throws
609      * Hardcoded to 24 digits.
610      */
611     function maxFixedDiv() public pure returns(int256) {
612         return 57896044618658097711785492504343953926634992332820282;
613     }
614 
615     /**
616      * @notice Maximum value that can be safely used as a divisor.
617      * @dev Test maxFixedDivisor() equals fixed1()*fixed1() - Or 10**(digits()*2)
618      * Test divide(10**(digits()*2 + 1),10**(digits()*2)) = returns 10*fixed1()
619      * Test divide(10**(digits()*2 + 1),10**(digits()*2 + 1)) = throws
620      * Hardcoded to 24 digits.
621      */
622     function maxFixedDivisor() public pure returns(int256) {
623         return 1000000000000000000000000000000000000000000000000;
624     }
625 
626     /**
627      * @notice Converts an int256 to fixed point units, equivalent to multiplying
628      * by 10^digits().
629      * @dev Test newFixed(0) returns 0
630      * Test newFixed(1) returns fixed1()
631      * Test newFixed(maxNewFixed()) returns maxNewFixed() * fixed1()
632      * Test newFixed(maxNewFixed()+1) fails
633      */
634     function newFixed(int256 x)
635         public
636         pure
637         returns (int256)
638     {
639         assert(x <= maxNewFixed());
640         assert(x >= minNewFixed());
641         return x * fixed1();
642     }
643 
644     /**
645      * @notice Converts an int256 in the fixed point representation of this 
646      * library to a non decimal. All decimal digits will be truncated.
647      */
648     function fromFixed(int256 x)
649         public
650         pure
651         returns (int256)
652     {
653         return x / fixed1();
654     }
655 
656     /**
657      * @notice Converts an int256 which is already in some fixed point 
658      * representation to a different fixed precision representation.
659      * Both the origin and destination precisions must be 38 or less digits.
660      * Origin values with a precision higher than the destination precision
661      * will be truncated accordingly.
662      * @dev 
663      * Test convertFixed(1,0,0) returns 1;
664      * Test convertFixed(1,1,1) returns 1;
665      * Test convertFixed(1,1,0) returns 0;
666      * Test convertFixed(1,0,1) returns 10;
667      * Test convertFixed(10,1,0) returns 1;
668      * Test convertFixed(10,0,1) returns 100;
669      * Test convertFixed(100,1,0) returns 10;
670      * Test convertFixed(100,0,1) returns 1000;
671      * Test convertFixed(1000,2,0) returns 10;
672      * Test convertFixed(1000,0,2) returns 100000;
673      * Test convertFixed(1000,2,1) returns 100;
674      * Test convertFixed(1000,1,2) returns 10000;
675      * Test convertFixed(maxInt256,1,0) returns maxInt256/10;
676      * Test convertFixed(maxInt256,0,1) throws
677      * Test convertFixed(maxInt256,38,0) returns maxInt256/(10**38);
678      * Test convertFixed(1,0,38) returns 10**38;
679      * Test convertFixed(maxInt256,39,0) throws
680      * Test convertFixed(1,0,39) throws
681      */
682     function convertFixed(int256 x, uint8 _originDigits, uint8 _destinationDigits)
683         public
684         pure
685         returns (int256)
686     {
687         assert(_originDigits <= 38 && _destinationDigits <= 38);
688         
689         uint8 decimalDifference;
690         if ( _originDigits > _destinationDigits ){
691             decimalDifference = _originDigits - _destinationDigits;
692             return x/(uint128(10)**uint128(decimalDifference));
693         }
694         else if ( _originDigits < _destinationDigits ){
695             decimalDifference = _destinationDigits - _originDigits;
696             // Cast uint8 -> uint128 is safe
697             // Exponentiation is safe:
698             //     _originDigits and _destinationDigits limited to 38 or less
699             //     decimalDifference = abs(_destinationDigits - _originDigits)
700             //     decimalDifference < 38
701             //     10**38 < 2**128-1
702             assert(x <= maxInt256()/uint128(10)**uint128(decimalDifference));
703             assert(x >= minInt256()/uint128(10)**uint128(decimalDifference));
704             return x*(uint128(10)**uint128(decimalDifference));
705         }
706         // _originDigits == digits()) 
707         return x;
708     }
709 
710     /**
711      * @notice Converts an int256 which is already in some fixed point 
712      * representation to that of this library. The _originDigits parameter is the
713      * precision of x. Values with a precision higher than FixidityLib.digits()
714      * will be truncated accordingly.
715      */
716     function newFixed(int256 x, uint8 _originDigits)
717         public
718         pure
719         returns (int256)
720     {
721         return convertFixed(x, _originDigits, digits());
722     }
723 
724     /**
725      * @notice Converts an int256 in the fixed point representation of this 
726      * library to a different representation. The _destinationDigits parameter is the
727      * precision of the output x. Values with a precision below than 
728      * FixidityLib.digits() will be truncated accordingly.
729      */
730     function fromFixed(int256 x, uint8 _destinationDigits)
731         public
732         pure
733         returns (int256)
734     {
735         return convertFixed(x, digits(), _destinationDigits);
736     }
737 
738     /**
739      * @notice Converts two int256 representing a fraction to fixed point units,
740      * equivalent to multiplying dividend and divisor by 10^digits().
741      * @dev 
742      * Test newFixedFraction(maxFixedDiv()+1,1) fails
743      * Test newFixedFraction(1,maxFixedDiv()+1) fails
744      * Test newFixedFraction(1,0) fails     
745      * Test newFixedFraction(0,1) returns 0
746      * Test newFixedFraction(1,1) returns fixed1()
747      * Test newFixedFraction(maxFixedDiv(),1) returns maxFixedDiv()*fixed1()
748      * Test newFixedFraction(1,fixed1()) returns 1
749      * Test newFixedFraction(1,fixed1()-1) returns 0
750      */
751     function newFixedFraction(
752         int256 numerator, 
753         int256 denominator
754         )
755         public
756         pure
757         returns (int256)
758     {
759         assert(numerator <= maxNewFixed());
760         assert(denominator <= maxNewFixed());
761         assert(denominator != 0);
762         int256 convertedNumerator = newFixed(numerator);
763         int256 convertedDenominator = newFixed(denominator);
764         return divide(convertedNumerator, convertedDenominator);
765     }
766 
767     /**
768      * @notice Returns the integer part of a fixed point number.
769      * @dev 
770      * Test integer(0) returns 0
771      * Test integer(fixed1()) returns fixed1()
772      * Test integer(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()
773      * Test integer(-fixed1()) returns -fixed1()
774      * Test integer(newFixed(-maxNewFixed())) returns -maxNewFixed()*fixed1()
775      */
776     function integer(int256 x) public pure returns (int256) {
777         return (x / fixed1()) * fixed1(); // Can't overflow
778     }
779 
780     /**
781      * @notice Returns the fractional part of a fixed point number. 
782      * In the case of a negative number the fractional is also negative.
783      * @dev 
784      * Test fractional(0) returns 0
785      * Test fractional(fixed1()) returns 0
786      * Test fractional(fixed1()-1) returns 10^24-1
787      * Test fractional(-fixed1()) returns 0
788      * Test fractional(-fixed1()+1) returns -10^24-1
789      */
790     function fractional(int256 x) public pure returns (int256) {
791         return x - (x / fixed1()) * fixed1(); // Can't overflow
792     }
793 
794     /**
795      * @notice Converts to positive if negative.
796      * Due to int256 having one more negative number than positive numbers 
797      * abs(minInt256) reverts.
798      * @dev 
799      * Test abs(0) returns 0
800      * Test abs(fixed1()) returns -fixed1()
801      * Test abs(-fixed1()) returns fixed1()
802      * Test abs(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()
803      * Test abs(newFixed(minNewFixed())) returns -minNewFixed()*fixed1()
804      */
805     function abs(int256 x) public pure returns (int256) {
806         if (x >= 0) {
807             return x;
808         } else {
809             int256 result = -x;
810             assert (result > 0);
811             return result;
812         }
813     }
814 
815     /**
816      * @notice x+y. If any operator is higher than maxFixedAdd() it 
817      * might overflow.
818      * In solidity maxInt256 + 1 = minInt256 and viceversa.
819      * @dev 
820      * Test add(maxFixedAdd(),maxFixedAdd()) returns maxInt256()-1
821      * Test add(maxFixedAdd()+1,maxFixedAdd()+1) fails
822      * Test add(-maxFixedSub(),-maxFixedSub()) returns minInt256()
823      * Test add(-maxFixedSub()-1,-maxFixedSub()-1) fails
824      * Test add(maxInt256(),maxInt256()) fails
825      * Test add(minInt256(),minInt256()) fails
826      */
827     function add(int256 x, int256 y) public pure returns (int256) {
828         int256 z = x + y;
829         if (x > 0 && y > 0) assert(z > x && z > y);
830         if (x < 0 && y < 0) assert(z < x && z < y);
831         return z;
832     }
833 
834     /**
835      * @notice x-y. You can use add(x,-y) instead. 
836      * @dev Tests covered by add(x,y)
837      */
838     function subtract(int256 x, int256 y) public pure returns (int256) {
839         return add(x,-y);
840     }
841 
842     /**
843      * @notice x*y. If any of the operators is higher than maxFixedMul() it 
844      * might overflow.
845      * @dev 
846      * Test multiply(0,0) returns 0
847      * Test multiply(maxFixedMul(),0) returns 0
848      * Test multiply(0,maxFixedMul()) returns 0
849      * Test multiply(maxFixedMul(),fixed1()) returns maxFixedMul()
850      * Test multiply(fixed1(),maxFixedMul()) returns maxFixedMul()
851      * Test all combinations of (2,-2), (2, 2.5), (2, -2.5) and (0.5, -0.5)
852      * Test multiply(fixed1()/mulPrecision(),fixed1()*mulPrecision())
853      * Test multiply(maxFixedMul()-1,maxFixedMul()) equals multiply(maxFixedMul(),maxFixedMul()-1)
854      * Test multiply(maxFixedMul(),maxFixedMul()) returns maxInt256() // Probably not to the last digits
855      * Test multiply(maxFixedMul()+1,maxFixedMul()) fails
856      * Test multiply(maxFixedMul(),maxFixedMul()+1) fails
857      */
858     function multiply(int256 x, int256 y) public pure returns (int256) {
859         if (x == 0 || y == 0) return 0;
860         if (y == fixed1()) return x;
861         if (x == fixed1()) return y;
862 
863         // Separate into integer and fractional parts
864         // x = x1 + x2, y = y1 + y2
865         int256 x1 = integer(x) / fixed1();
866         int256 x2 = fractional(x);
867         int256 y1 = integer(y) / fixed1();
868         int256 y2 = fractional(y);
869         
870         // (x1 + x2) * (y1 + y2) = (x1 * y1) + (x1 * y2) + (x2 * y1) + (x2 * y2)
871         int256 x1y1 = x1 * y1;
872         if (x1 != 0) assert(x1y1 / x1 == y1); // Overflow x1y1
873         
874         // x1y1 needs to be multiplied back by fixed1
875         // solium-disable-next-line mixedcase
876         int256 fixed_x1y1 = x1y1 * fixed1();
877         if (x1y1 != 0) assert(fixed_x1y1 / x1y1 == fixed1()); // Overflow x1y1 * fixed1
878         x1y1 = fixed_x1y1;
879 
880         int256 x2y1 = x2 * y1;
881         if (x2 != 0) assert(x2y1 / x2 == y1); // Overflow x2y1
882 
883         int256 x1y2 = x1 * y2;
884         if (x1 != 0) assert(x1y2 / x1 == y2); // Overflow x1y2
885 
886         x2 = x2 / mulPrecision();
887         y2 = y2 / mulPrecision();
888         int256 x2y2 = x2 * y2;
889         if (x2 != 0) assert(x2y2 / x2 == y2); // Overflow x2y2
890 
891         // result = fixed1() * x1 * y1 + x1 * y2 + x2 * y1 + x2 * y2 / fixed1();
892         int256 result = x1y1;
893         result = add(result, x2y1); // Add checks for overflow
894         result = add(result, x1y2); // Add checks for overflow
895         result = add(result, x2y2); // Add checks for overflow
896         return result;
897     }
898     
899     /**
900      * @notice 1/x
901      * @dev 
902      * Test reciprocal(0) fails
903      * Test reciprocal(fixed1()) returns fixed1()
904      * Test reciprocal(fixed1()*fixed1()) returns 1 // Testing how the fractional is truncated
905      * Test reciprocal(2*fixed1()*fixed1()) returns 0 // Testing how the fractional is truncated
906      */
907     function reciprocal(int256 x) public pure returns (int256) {
908         assert(x != 0);
909         return (fixed1()*fixed1()) / x; // Can't overflow
910     }
911 
912     /**
913      * @notice x/y. If the dividend is higher than maxFixedDiv() it 
914      * might overflow. You can use multiply(x,reciprocal(y)) instead.
915      * There is a loss of precision on division for the lower mulPrecision() decimals.
916      * @dev 
917      * Test divide(fixed1(),0) fails
918      * Test divide(maxFixedDiv(),1) = maxFixedDiv()*(10^digits())
919      * Test divide(maxFixedDiv()+1,1) throws
920      * Test divide(maxFixedDiv(),maxFixedDiv()) returns fixed1()
921      */
922     function divide(int256 x, int256 y) public pure returns (int256) {
923         if (y == fixed1()) return x;
924         assert(y != 0);
925         assert(y <= maxFixedDivisor());
926         return multiply(x, reciprocal(y));
927     }
928 }
929 
930 
931 /**
932  * @title The Pool contract for PoolTogether
933  * @author Brendan Asselstine
934  * @notice This contract implements a "lossless pool".  The pool exists in three states: open, locked, and complete.
935  * The pool begins in the open state during which users can buy any number of tickets.  The more tickets they purchase, the greater their chances of winning.
936  * After the lockStartBlock the owner may lock the pool.  The pool transfers the pool of ticket money into the Compound Finance money market and no more tickets are sold.
937  * After the lockEndBlock the owner may unlock the pool.  The pool will withdraw the ticket money from the money market, plus earned interest, back into the contract.  The fee will be sent to
938  * the owner, and users will be able to withdraw their ticket money and winnings, if any.
939  * @dev All monetary values are stored internally as fixed point 24.
940  */
941 contract Pool is Ownable {
942   using SafeMath for uint256;
943 
944   /**
945    * Emitted when "tickets" have been purchased.
946    * @param sender The purchaser of the tickets
947    * @param count The number of tickets purchased
948    * @param totalPrice The total cost of the tickets
949    */
950   event BoughtTickets(address indexed sender, int256 count, uint256 totalPrice);
951 
952   /**
953    * Emitted when a user withdraws from the pool.
954    * @param sender The user that is withdrawing from the pool
955    * @param amount The amount that the user withdrew
956    */
957   event Withdrawn(address indexed sender, int256 amount);
958 
959   /**
960    * Emitted when the pool is locked.
961    */
962   event PoolLocked();
963 
964   /**
965    * Emitted when the pool is unlocked.
966    */
967   event PoolUnlocked();
968 
969   /**
970    * Emitted when the pool is complete
971    */
972   event PoolComplete(address indexed winner);
973 
974   enum State {
975     OPEN,
976     LOCKED,
977     UNLOCKED,
978     COMPLETE
979   }
980 
981   struct Entry {
982     address addr;
983     int256 amount;
984     uint256 ticketCount;
985     int256 withdrawnNonFixed;
986   }
987 
988   bytes32 public constant SUM_TREE_KEY = "PoolPool";
989 
990   int256 private totalAmount; // fixed point 24
991   uint256 private lockStartBlock;
992   uint256 private lockEndBlock;
993   bytes32 private secretHash;
994   bytes32 private secret;
995   State public state;
996   int256 private finalAmount; //fixed point 24
997   mapping (address => Entry) private entries;
998   uint256 public entryCount;
999   ICErc20 public moneyMarket;
1000   IERC20 public token;
1001   int256 private ticketPrice; //fixed point 24
1002   int256 private feeFraction; //fixed point 24
1003   bool private ownerHasWithdrawn;
1004   bool public allowLockAnytime;
1005 
1006   using SortitionSumTreeFactory for SortitionSumTreeFactory.SortitionSumTrees;
1007   SortitionSumTreeFactory.SortitionSumTrees internal sortitionSumTrees;
1008 
1009   /**
1010    * @notice Creates a new Pool.
1011    * @param _moneyMarket The Compound money market to supply tokens to.
1012    * @param _token The ERC20 token to be used.
1013    * @param _lockStartBlock The block number on or after which the deposit can be made to Compound
1014    * @param _lockEndBlock The block number on or after which the Compound supply can be withdrawn
1015    * @param _ticketPrice The price of each ticket (fixed point 18)
1016    * @param _feeFractionFixedPoint18 The fraction of the winnings going to the owner (fixed point 18)
1017    */
1018   constructor (
1019     ICErc20 _moneyMarket,
1020     IERC20 _token,
1021     uint256 _lockStartBlock,
1022     uint256 _lockEndBlock,
1023     int256 _ticketPrice,
1024     int256 _feeFractionFixedPoint18,
1025     bool _allowLockAnytime
1026   ) public {
1027     require(_lockEndBlock > _lockStartBlock, "lock end block is not after start block");
1028     require(address(_moneyMarket) != address(0), "money market address cannot be zero");
1029     require(address(_token) != address(0), "token address cannot be zero");
1030     require(_ticketPrice > 0, "ticket price must be greater than zero");
1031     require(_feeFractionFixedPoint18 >= 0, "fee must be zero or greater");
1032     require(_feeFractionFixedPoint18 <= 1000000000000000000, "fee fraction must be less than 1");
1033     feeFraction = FixidityLib.newFixed(_feeFractionFixedPoint18, uint8(18));
1034     ticketPrice = FixidityLib.newFixed(_ticketPrice);
1035     sortitionSumTrees.createTree(SUM_TREE_KEY, 4);
1036 
1037     state = State.OPEN;
1038     moneyMarket = _moneyMarket;
1039     token = _token;
1040     lockStartBlock = _lockStartBlock;
1041     lockEndBlock = _lockEndBlock;
1042     allowLockAnytime = _allowLockAnytime;
1043   }
1044 
1045   /**
1046    * @notice Buys a pool ticket.  Only possible while the Pool is in the "open" state.  The
1047    * user can buy any number of tickets.  Each ticket is a chance at winning.
1048    * @param _countNonFixed The number of tickets the user wishes to buy.
1049    */
1050   function buyTickets (int256 _countNonFixed) public requireOpen {
1051     require(_countNonFixed > 0, "number of tickets is less than or equal to zero");
1052     int256 count = FixidityLib.newFixed(_countNonFixed);
1053     int256 totalDeposit = FixidityLib.multiply(ticketPrice, count);
1054     uint256 totalDepositNonFixed = uint256(FixidityLib.fromFixed(totalDeposit));
1055     require(token.transferFrom(msg.sender, address(this), totalDepositNonFixed), "token transfer failed");
1056 
1057     if (_hasEntry(msg.sender)) {
1058       entries[msg.sender].amount = FixidityLib.add(entries[msg.sender].amount, totalDeposit);
1059       entries[msg.sender].ticketCount = entries[msg.sender].ticketCount.add(uint256(_countNonFixed));
1060     } else {
1061       entries[msg.sender] = Entry(
1062         msg.sender,
1063         totalDeposit,
1064         uint256(_countNonFixed),
1065         0
1066       );
1067       entryCount = entryCount.add(1);
1068     }
1069 
1070     int256 amountNonFixed = FixidityLib.fromFixed(entries[msg.sender].amount);
1071     sortitionSumTrees.set(SUM_TREE_KEY, uint256(amountNonFixed), bytes32(uint256(msg.sender)));
1072 
1073     totalAmount = FixidityLib.add(totalAmount, totalDeposit);
1074 
1075     // the total amount cannot exceed the max pool size
1076     require(totalAmount <= maxPoolSizeFixedPoint24(FixidityLib.maxFixedDiv()), "pool size exceeds maximum");
1077 
1078     emit BoughtTickets(msg.sender, _countNonFixed, totalDepositNonFixed);
1079   }
1080 
1081   /**
1082    * @notice Pools the deposits and supplies them to Compound.
1083    * Can only be called by the owner when the pool is open.
1084    * Fires the PoolLocked event.
1085    */
1086   function lock(bytes32 _secretHash) external requireOpen onlyOwner {
1087     if (allowLockAnytime) {
1088       lockStartBlock = block.number;
1089     } else {
1090       require(block.number >= lockStartBlock, "pool can only be locked on or after lock start block");
1091     }
1092     require(_secretHash != 0, "secret hash must be defined");
1093     secretHash = _secretHash;
1094     state = State.LOCKED;
1095 
1096     if (totalAmount > 0) {
1097       uint256 totalAmountNonFixed = uint256(FixidityLib.fromFixed(totalAmount));
1098       require(token.approve(address(moneyMarket), totalAmountNonFixed), "could not approve money market spend");
1099       require(moneyMarket.mint(totalAmountNonFixed) == 0, "could not supply money market");
1100     }
1101 
1102     emit PoolLocked();
1103   }
1104 
1105   function unlock() public requireLocked {
1106     if (allowLockAnytime && msg.sender == owner()) {
1107       lockEndBlock = block.number;
1108     } else {
1109       require(lockEndBlock < block.number, "pool cannot be unlocked yet");
1110     }
1111 
1112     uint256 balance = moneyMarket.balanceOfUnderlying(address(this));
1113 
1114     if (balance > 0) {
1115       require(moneyMarket.redeemUnderlying(balance) == 0, "could not redeem from compound");
1116       finalAmount = FixidityLib.newFixed(int256(balance));
1117     }
1118 
1119     state = State.UNLOCKED;
1120 
1121     emit PoolUnlocked();
1122   }
1123 
1124   /**
1125    * @notice Withdraws the deposit from Compound and selects a winner.
1126    * Can only be called by the owner after the lock end block.
1127    * Fires the PoolUnlocked event.
1128    */
1129   function complete(bytes32 _secret) public onlyOwner {
1130     if (state == State.LOCKED) {
1131       unlock();
1132     }
1133     require(state == State.UNLOCKED, "state must be unlocked");
1134     require(keccak256(abi.encodePacked(_secret)) == secretHash, "secret does not match");
1135     secret = _secret;
1136     state = State.COMPLETE;
1137 
1138     uint256 fee = feeAmount();
1139     if (fee > 0) {
1140       require(token.transfer(owner(), fee), "could not transfer winnings");
1141     }
1142 
1143     emit PoolComplete(winnerAddress());
1144   }
1145 
1146   /**
1147    * @notice Transfers a users deposit, and potential winnings, back to them.
1148    * The Pool must be unlocked.
1149    * The user must have deposited funds.  Fires the Withdrawn event.
1150    */
1151   function withdraw() public {
1152     require(_hasEntry(msg.sender), "entrant exists");
1153     require(state == State.UNLOCKED || state == State.COMPLETE, "pool has not been unlocked");
1154     Entry storage entry = entries[msg.sender];
1155     int256 remainingBalanceNonFixed = balanceOf(msg.sender);
1156     require(remainingBalanceNonFixed > 0, "entrant has already withdrawn");
1157     entry.withdrawnNonFixed = entry.withdrawnNonFixed + remainingBalanceNonFixed;
1158 
1159     emit Withdrawn(msg.sender, remainingBalanceNonFixed);
1160 
1161     require(token.transfer(msg.sender, uint256(remainingBalanceNonFixed)), "could not transfer winnings");
1162   }
1163 
1164   /**
1165    * @notice Calculates a user's winnings.  This is their deposit plus their winnings, if any.
1166    * @param _addr The address of the user
1167    */
1168   function winnings(address _addr) public view returns (int256) {
1169     Entry storage entry = entries[_addr];
1170     if (entry.addr == address(0)) { //if does not have an entry
1171       return 0;
1172     }
1173     int256 winningTotal = entry.amount;
1174     if (state == State.COMPLETE && _addr == winnerAddress()) {
1175       winningTotal = FixidityLib.add(winningTotal, netWinningsFixedPoint24());
1176     }
1177     return FixidityLib.fromFixed(winningTotal);
1178   }
1179 
1180   /**
1181    * @notice Calculates a user's remaining balance.  This is their winnings less how much they've withdrawn.
1182    * @return The users's current balance.
1183    */
1184   function balanceOf(address _addr) public view returns (int256) {
1185     Entry storage entry = entries[_addr];
1186     int256 winningTotalNonFixed = winnings(_addr);
1187     return winningTotalNonFixed - entry.withdrawnNonFixed;
1188   }
1189 
1190   /**
1191    * @notice Selects and returns the winner's address
1192    * @return The winner's address
1193    */
1194   function winnerAddress() public view returns (address) {
1195     if (totalAmount > 0) {
1196       return address(uint256(sortitionSumTrees.draw(SUM_TREE_KEY, randomToken())));
1197     } else {
1198       return address(0);
1199     }
1200   }
1201 
1202   /**
1203    * @notice Returns the total interest on the pool less the fee as a whole number
1204    * @return The total interest on the pool less the fee as a whole number
1205    */
1206   function netWinnings() public view returns (int256) {
1207     return FixidityLib.fromFixed(netWinningsFixedPoint24());
1208   }
1209 
1210   /**
1211    * @notice Computes the total interest earned on the pool less the fee as a fixed point 24.
1212    * @return The total interest earned on the pool less the fee as a fixed point 24.
1213    */
1214   function netWinningsFixedPoint24() internal view returns (int256) {
1215     return grossWinningsFixedPoint24() - feeAmountFixedPoint24();
1216   }
1217 
1218   /**
1219    * @notice Computes the total interest earned on the pool as a fixed point 24.
1220    * This is what the winner will earn once the pool is unlocked.
1221    * @return The total interest earned on the pool as a fixed point 24.
1222    */
1223   function grossWinningsFixedPoint24() internal view returns (int256) {
1224     return FixidityLib.subtract(finalAmount, totalAmount);
1225   }
1226 
1227   /**
1228    * @notice Calculates the size of the fee based on the gross winnings
1229    * @return The fee for the pool to be transferred to the owner
1230    */
1231   function feeAmount() public view returns (uint256) {
1232     return uint256(FixidityLib.fromFixed(feeAmountFixedPoint24()));
1233   }
1234 
1235   /**
1236    * @notice Calculates the fee for the pool by multiplying the gross winnings by the fee fraction.
1237    * @return The fee for the pool as a fixed point 24
1238    */
1239   function feeAmountFixedPoint24() internal view returns (int256) {
1240     return FixidityLib.multiply(grossWinningsFixedPoint24(), feeFraction);
1241   }
1242 
1243   /**
1244    * @notice Selects a random number in the range from [0, total tokens deposited)
1245    * @return If the current block is before the end it returns 0, otherwise it returns the random number.
1246    */
1247   function randomToken() public view returns (uint256) {
1248     if (block.number <= lockEndBlock) {
1249       return 0;
1250     } else {
1251       return _selectRandom(uint256(FixidityLib.fromFixed(totalAmount)));
1252     }
1253   }
1254 
1255   /**
1256    * @notice Selects a random number in the range [0, total)
1257    * @param total The upper bound for the random number
1258    * @return The random number
1259    */
1260   function _selectRandom(uint256 total) internal view returns (uint256) {
1261     return UniformRandomNumber.uniform(_entropy(), total);
1262   }
1263 
1264   /**
1265    * @notice Computes the entropy used to generate the random number.
1266    * The blockhash of the lock end block is XOR'd with the secret revealed by the owner.
1267    * @return The computed entropy value
1268    */
1269   function _entropy() internal view returns (uint256) {
1270     return uint256(blockhash(lockEndBlock) ^ secret);
1271   }
1272 
1273   /**
1274    * @notice Retrieves information about the pool.
1275    * @return A tuple containing:
1276    *    entryTotal (the total of all deposits)
1277    *    startBlock (the block after which the pool can be locked)
1278    *    endBlock (the block after which the pool can be unlocked)
1279    *    poolState (either OPEN, LOCKED, COMPLETE)
1280    *    winner (the address of the winner)
1281    *    supplyBalanceTotal (the total deposits plus any interest from Compound)
1282    *    ticketCost (the cost of each ticket in DAI)
1283    *    participantCount (the number of unique purchasers of tickets)
1284    *    maxPoolSize (the maximum theoretical size of the pool to prevent overflow)
1285    *    estimatedInterestFixedPoint18 (the estimated total interest percent for this pool)
1286    *    hashOfSecret (the hash of the secret the owner submitted upon locking)
1287    */
1288   function getInfo() public view returns (
1289     int256 entryTotal,
1290     uint256 startBlock,
1291     uint256 endBlock,
1292     State poolState,
1293     address winner,
1294     int256 supplyBalanceTotal,
1295     int256 ticketCost,
1296     uint256 participantCount,
1297     int256 maxPoolSize,
1298     int256 estimatedInterestFixedPoint18,
1299     bytes32 hashOfSecret
1300   ) {
1301     address winAddr = address(0);
1302     if (state == State.COMPLETE) {
1303       winAddr = winnerAddress();
1304     }
1305     return (
1306       FixidityLib.fromFixed(totalAmount),
1307       lockStartBlock,
1308       lockEndBlock,
1309       state,
1310       winAddr,
1311       FixidityLib.fromFixed(finalAmount),
1312       FixidityLib.fromFixed(ticketPrice),
1313       entryCount,
1314       FixidityLib.fromFixed(maxPoolSizeFixedPoint24(FixidityLib.maxFixedDiv())),
1315       FixidityLib.fromFixed(currentInterestFractionFixedPoint24(), uint8(18)),
1316       secretHash
1317     );
1318   }
1319 
1320   /**
1321    * @notice Retrieves information about a user's entry in the Pool.
1322    * @return Returns a tuple containing:
1323    *    addr (the address of the user)
1324    *    amount (the amount they deposited)
1325    *    ticketCount (the number of tickets they have bought)
1326    *    withdrawn (the amount they have withdrawn)
1327    */
1328   function getEntry(address _addr) public view returns (
1329     address addr,
1330     int256 amount,
1331     uint256 ticketCount,
1332     int256 withdrawn
1333   ) {
1334     Entry storage entry = entries[_addr];
1335     return (
1336       entry.addr,
1337       FixidityLib.fromFixed(entry.amount),
1338       entry.ticketCount,
1339       entry.withdrawnNonFixed
1340     );
1341   }
1342 
1343   /**
1344    * @notice Calculates the maximum pool size so that it doesn't overflow after earning interest
1345    * @dev poolSize = totalDeposits + totalDeposits * interest => totalDeposits = poolSize / (1 + interest)
1346    * @return The maximum size of the pool to be deposited into the money market
1347    */
1348   function maxPoolSizeFixedPoint24(int256 _maxValueFixedPoint24) public view returns (int256) {
1349     /// Double the interest rate in case it increases over the lock period.  Somewhat arbitrarily.
1350     int256 interestFraction = FixidityLib.multiply(currentInterestFractionFixedPoint24(), FixidityLib.newFixed(2));
1351     return FixidityLib.divide(_maxValueFixedPoint24, FixidityLib.add(interestFraction, FixidityLib.newFixed(1)));
1352   }
1353 
1354   /**
1355    * @notice Estimates the current effective interest rate using the money market's current supplyRateMantissa and the lock duration in blocks.
1356    * @return The current estimated effective interest rate
1357    */
1358   function currentInterestFractionFixedPoint24() public view returns (int256) {
1359     int256 blockDuration = int256(lockEndBlock - lockStartBlock);
1360     int256 supplyRateMantissaFixedPoint24 = FixidityLib.newFixed(int256(supplyRateMantissa()), uint8(18));
1361     return FixidityLib.multiply(supplyRateMantissaFixedPoint24, FixidityLib.newFixed(blockDuration));
1362   }
1363 
1364   /**
1365    * @notice Extracts the supplyRateMantissa value from the money market contract
1366    * @return The money market supply rate per block
1367    */
1368   function supplyRateMantissa() public view returns (uint256) {
1369     return moneyMarket.supplyRatePerBlock();
1370   }
1371 
1372   /**
1373    * @notice Determines whether a given address has bought tickets
1374    * @param _addr The given address
1375    * @return Returns true if the given address bought tickets, false otherwise.
1376    */
1377   function _hasEntry(address _addr) internal view returns (bool) {
1378     return entries[_addr].addr == _addr;
1379   }
1380 
1381   modifier requireOpen() {
1382     require(state == State.OPEN, "state is not open");
1383     _;
1384   }
1385 
1386   modifier requireLocked() {
1387     require(state == State.LOCKED, "state is not locked");
1388     _;
1389   }
1390 
1391   modifier requireComplete() {
1392     require(state == State.COMPLETE, "pool is not complete");
1393     require(block.number > lockEndBlock, "block is before lock end period");
1394     _;
1395   }
1396 }