1 pragma solidity ^0.5.10;
2 
3 /**
4  * @dev Contract module that helps prevent reentrant calls to a function.
5  *
6  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
7  * available, which can be applied to functions to make sure there are no nested
8  * (reentrant) calls to them.
9  *
10  * Note that because there is a single `nonReentrant` guard, functions marked as
11  * `nonReentrant` may not call one another. This can be worked around by making
12  * those functions `private`, and then adding `external` `nonReentrant` entry
13  * points to them.
14  */
15 contract ReentrancyGuard {
16     // counter to allow mutex lock with only one SSTORE operation
17     uint256 private _guardCounter;
18 
19     constructor () internal {
20         // The counter starts at one to prevent changing it from zero to a non-zero
21         // value, which is a more expensive operation.
22         _guardCounter = 1;
23     }
24 
25     /**
26      * @dev Prevents a contract from calling itself, directly or indirectly.
27      * Calling a `nonReentrant` function from another `nonReentrant`
28      * function is not supported. It is possible to prevent this from happening
29      * by making the `nonReentrant` function external, and make it call a
30      * `private` function that does the actual work.
31      */
32     modifier nonReentrant() {
33         _guardCounter += 1;
34         uint256 localCounter = _guardCounter;
35         _;
36         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
37     }
38 }
39 
40 // File: contracts/commons/Ownable.sol
41 
42 pragma solidity ^0.5.10;
43 
44 
45 contract Ownable {
46     address public owner;
47 
48     event TransferOwnership(address _from, address _to);
49 
50     constructor() public {
51         owner = msg.sender;
52         emit TransferOwnership(address(0), msg.sender);
53     }
54 
55     modifier onlyOwner() {
56         require(msg.sender == owner, "only owner");
57         _;
58     }
59 
60     function setOwner(address _owner) external onlyOwner {
61         emit TransferOwnership(owner, _owner);
62         owner = _owner;
63     }
64 }
65 
66 // File: contracts/commons/StorageUnit.sol
67 
68 pragma solidity ^0.5.10;
69 
70 
71 contract StorageUnit {
72     address private owner;
73     mapping(bytes32 => bytes32) private store;
74 
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     function write(bytes32 _key, bytes32 _value) external {
80         /* solium-disable-next-line */
81         require(msg.sender == owner);
82         store[_key] = _value;
83     }
84 
85     function read(bytes32 _key) external view returns (bytes32) {
86         return store[_key];
87     }
88 }
89 
90 // File: contracts/utils/IsContract.sol
91 
92 pragma solidity ^0.5.10;
93 
94 
95 library IsContract {
96     function isContract(address _addr) internal view returns (bool) {
97         bytes32 codehash;
98         /* solium-disable-next-line */
99         assembly { codehash := extcodehash(_addr) }
100         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
101     }
102 }
103 
104 // File: contracts/utils/DistributedStorage.sol
105 
106 pragma solidity ^0.5.10;
107 
108 
109 
110 
111 library DistributedStorage {
112     function contractSlot(bytes32 _struct) private view returns (address) {
113         return address(
114             uint256(
115                 keccak256(
116                     abi.encodePacked(
117                         byte(0xff),
118                         address(this),
119                         _struct,
120                         keccak256(type(StorageUnit).creationCode)
121                     )
122                 )
123             )
124         );
125     }
126 
127     function deploy(bytes32 _struct) private {
128         bytes memory slotcode = type(StorageUnit).creationCode;
129         /* solium-disable-next-line */
130         assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }
131     }
132 
133     function write(
134         bytes32 _struct,
135         bytes32 _key,
136         bytes32 _value
137     ) internal {
138         StorageUnit store = StorageUnit(contractSlot(_struct));
139         if (!IsContract.isContract(address(store))) {
140             deploy(_struct);
141         }
142 
143         /* solium-disable-next-line */
144         (bool success, ) = address(store).call(
145             abi.encodeWithSelector(
146                 store.write.selector,
147                 _key,
148                 _value
149             )
150         );
151 
152         require(success, "error writing storage");
153     }
154 
155     function read(
156         bytes32 _struct,
157         bytes32 _key
158     ) internal view returns (bytes32) {
159         StorageUnit store = StorageUnit(contractSlot(_struct));
160         if (!IsContract.isContract(address(store))) {
161             return bytes32(0);
162         }
163 
164         /* solium-disable-next-line */
165         (bool success, bytes memory data) = address(store).staticcall(
166             abi.encodeWithSelector(
167                 store.read.selector,
168                 _key
169             )
170         );
171 
172         require(success, "error reading storage");
173         return abi.decode(data, (bytes32));
174     }
175 }
176 
177 // File: contracts/utils/SafeMath.sol
178 
179 pragma solidity ^0.5.10;
180 
181 
182 library SafeMath {
183     function add(uint256 x, uint256 y) internal pure returns (uint256) {
184         uint256 z = x + y;
185         require(z >= x, "Add overflow");
186         return z;
187     }
188 
189     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
190         require(x >= y, "Sub underflow");
191         return x - y;
192     }
193 
194     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
195         if (x == 0) {
196             return 0;
197         }
198 
199         uint256 z = x * y;
200         require(z / x == y, "Mult overflow");
201         return z;
202     }
203 
204     function div(uint256 x, uint256 y) internal pure returns (uint256) {
205         require(y != 0, "Div by zero");
206         return x / y;
207     }
208 
209     function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
210         require(y != 0, "Div by zero");
211         uint256 r = x / y;
212         if (x % y != 0) {
213             r = r + 1;
214         }
215 
216         return r;
217     }
218 }
219 
220 // File: contracts/utils/Math.sol
221 
222 pragma solidity ^0.5.10;
223 
224 
225 library Math {
226     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
227         uint256 counter = uint(-1);
228         uint256 temp = input;
229 
230         do {
231             temp /= 10;
232             counter++;
233         } while (temp != 0);
234 
235         return counter;
236     }
237 
238     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
239         if (_a < _b) {
240             return _a;
241         } else {
242             return _b;
243         }
244     }
245 
246     function max(uint256 _a, uint256 _b) internal pure returns (uint256) {
247         if (_a > _b) {
248             return _a;
249         } else {
250             return _b;
251         }
252     }
253 }
254 
255 // File: contracts/utils/GasPump.sol
256 
257 pragma solidity ^0.5.10;
258 
259 
260 contract GasPump {
261     bytes32 private stub;
262 
263     modifier requestGas(uint256 _factor) {
264         if (tx.gasprice == 0 || gasleft() > block.gaslimit) {
265             uint256 startgas = gasleft();
266             _;
267             uint256 delta = startgas - gasleft();
268             uint256 target = (delta * _factor) / 100;
269             startgas = gasleft();
270             while (startgas - gasleft() < target) {
271                 // Burn gas
272                 stub = keccak256(abi.encodePacked(stub));
273             }
274         } else {
275             _;
276         }
277     }
278 }
279 
280 // File: contracts/interfaces/IERC20.sol
281 
282 pragma solidity ^0.5.10;
283 
284 
285 interface IERC20 {
286     event Transfer(address indexed _from, address indexed _to, uint256 _value);
287     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
288     function transfer(address _to, uint _value) external returns (bool success);
289     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
290     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
291     function approve(address _spender, uint256 _value) external returns (bool success);
292     function balanceOf(address _owner) external view returns (uint256 balance);
293 }
294 
295 // File: contracts/commons/AddressMinHeap.sol
296 
297 pragma solidity ^0.5.10;
298 
299 /*
300     @author Agustin Aguilar <agusxrun@gmail.com>
301 */
302 
303 
304 library AddressMinHeap {
305     using AddressMinHeap for AddressMinHeap.Heap;
306 
307     struct Heap {
308         uint256[] entries;
309         mapping(address => uint256) index;
310     }
311 
312     function initialize(Heap storage _heap) internal {
313         require(_heap.entries.length == 0, "already initialized");
314         _heap.entries.push(0);
315     }
316 
317     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
318         /* solium-disable-next-line */
319         assembly {
320             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
321         }
322     }
323 
324     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
325         /* solium-disable-next-line */
326         assembly {
327             let entry := not(_entry)
328             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
329             _value := shr(160, entry)
330         }
331     }
332 
333     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
334         /* solium-disable-next-line */
335         assembly {
336             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
337         }
338     }
339 
340     function top(Heap storage _heap) internal view returns(address, uint256) {
341         if (_heap.entries.length < 2) {
342             return (address(0), 0);
343         }
344 
345         return decode(_heap.entries[1]);
346     }
347 
348     function has(Heap storage _heap, address _addr) internal view returns (bool) {
349         return _heap.index[_addr] != 0;
350     }
351 
352     function size(Heap storage _heap) internal view returns (uint256) {
353         return _heap.entries.length - 1;
354     }
355 
356     function entry(Heap storage _heap, uint256 _i) internal view returns (address, uint256) {
357         return decode(_heap.entries[_i + 1]);
358     }
359 
360     // RemoveMax pops off the root element of the heap (the highest value here) and rebalances the heap
361     function popTop(Heap storage _heap) internal returns(address _addr, uint256 _value) {
362         // Ensure the heap exists
363         uint256 heapLength = _heap.entries.length;
364         require(heapLength > 1, "The heap does not exists");
365 
366         // take the root value of the heap
367         (_addr, _value) = decode(_heap.entries[1]);
368         _heap.index[_addr] = 0;
369 
370         if (heapLength == 2) {
371             _heap.entries.length = 1;
372         } else {
373             // Takes the last element of the array and put it at the root
374             uint256 val = _heap.entries[heapLength - 1];
375             _heap.entries[1] = val;
376 
377             // Delete the last element from the array
378             _heap.entries.length = heapLength - 1;
379 
380             // Start at the top
381             uint256 ind = 1;
382 
383             // Bubble down
384             ind = _heap.bubbleDown(ind, val);
385 
386             // Update index
387             _heap.index[decodeAddress(val)] = ind;
388         }
389     }
390 
391     // Inserts adds in a value to our heap.
392     function insert(Heap storage _heap, address _addr, uint256 _value) internal {
393         require(_heap.index[_addr] == 0, "The entry already exists");
394 
395         // Add the value to the end of our array
396         uint256 encoded = encode(_addr, _value);
397         _heap.entries.push(encoded);
398 
399         // Start at the end of the array
400         uint256 currentIndex = _heap.entries.length - 1;
401 
402         // Bubble Up
403         currentIndex = _heap.bubbleUp(currentIndex, encoded);
404 
405         // Update index
406         _heap.index[_addr] = currentIndex;
407     }
408 
409     function update(Heap storage _heap, address _addr, uint256 _value) internal {
410         uint256 ind = _heap.index[_addr];
411         require(ind != 0, "The entry does not exists");
412 
413         uint256 can = encode(_addr, _value);
414         uint256 val = _heap.entries[ind];
415         uint256 newInd;
416 
417         if (can < val) {
418             // Bubble down
419             newInd = _heap.bubbleDown(ind, can);
420         } else if (can > val) {
421             // Bubble up
422             newInd = _heap.bubbleUp(ind, can);
423         } else {
424             // no changes needed
425             return;
426         }
427 
428         // Update entry
429         _heap.entries[newInd] = can;
430 
431         // Update index
432         if (newInd != ind) {
433             _heap.index[_addr] = newInd;
434         }
435     }
436 
437     function bubbleUp(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
438         // Bubble up
439         ind = _ind;
440         if (ind != 1) {
441             uint256 parent = _heap.entries[ind / 2];
442             while (parent < _val) {
443                 // If the parent value is lower than our current value, we swap them
444                 (_heap.entries[ind / 2], _heap.entries[ind]) = (_val, parent);
445 
446                 // Update moved Index
447                 _heap.index[decodeAddress(parent)] = ind;
448 
449                 // change our current Index to go up to the parent
450                 ind = ind / 2;
451                 if (ind == 1) {
452                     break;
453                 }
454 
455                 // Update parent
456                 parent = _heap.entries[ind / 2];
457             }
458         }
459     }
460 
461     function bubbleDown(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
462         // Bubble down
463         ind = _ind;
464 
465         uint256 lenght = _heap.entries.length;
466         uint256 target = lenght - 1;
467 
468         while (ind * 2 < lenght) {
469             // get the current index of the children
470             uint256 j = ind * 2;
471 
472             // left child value
473             uint256 leftChild = _heap.entries[j];
474 
475             // Store the value of the child
476             uint256 childValue;
477 
478             if (target > j) {
479                 // The parent has two childs 👨‍👧‍👦
480 
481                 // Load right child value
482                 uint256 rightChild = _heap.entries[j + 1];
483 
484                 // Compare the left and right child.
485                 // if the rightChild is greater, then point j to it's index
486                 // and save the value
487                 if (leftChild < rightChild) {
488                     childValue = rightChild;
489                     j = j + 1;
490                 } else {
491                     // The left child is greater
492                     childValue = leftChild;
493                 }
494             } else {
495                 // The parent has a single child 👨‍👦
496                 childValue = leftChild;
497             }
498 
499             // Check if the child has a lower value
500             if (_val > childValue) {
501                 break;
502             }
503 
504             // else swap the value
505             (_heap.entries[ind], _heap.entries[j]) = (childValue, _val);
506 
507             // Update moved Index
508             _heap.index[decodeAddress(childValue)] = ind;
509 
510             // and let's keep going down the heap
511             ind = j;
512         }
513     }
514 }
515 
516 // File: contracts/Heap.sol
517 
518 pragma solidity ^0.5.10;
519 
520 
521 
522 contract Heap is Ownable {
523     using AddressMinHeap for AddressMinHeap.Heap;
524 
525     // heap
526     AddressMinHeap.Heap private heap;
527 
528     // Heap events
529     event JoinHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
530     event LeaveHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
531 
532     uint256 public constant TOP_SIZE = 512;
533 
534     constructor() public {
535         heap.initialize();
536     }
537 
538     function topSize() external pure returns (uint256) {
539         return TOP_SIZE;
540     }
541 
542     function addressAt(uint256 _i) external view returns (address addr) {
543         (addr, ) = heap.entry(_i);
544     }
545 
546     function indexOf(address _addr) external view returns (uint256) {
547         return heap.index[_addr];
548     }
549 
550     function entry(uint256 _i) external view returns (address, uint256) {
551         return heap.entry(_i);
552     }
553 
554     function top() external view returns (address, uint256) {
555         return heap.top();
556     }
557 
558     function size() external view returns (uint256) {
559         return heap.size();
560     }
561 
562     function update(address _addr, uint256 _new) external onlyOwner {
563         uint256 _size = heap.size();
564 
565         // If the heap is empty
566         // join the _addr
567         if (_size == 0) {
568             emit JoinHeap(_addr, _new, 0);
569             heap.insert(_addr, _new);
570             return;
571         }
572 
573         // Load top value of the heap
574         (, uint256 lastBal) = heap.top();
575 
576         // If our target address already is in the heap
577         if (heap.has(_addr)) {
578             // Update the target address value
579             heap.update(_addr, _new);
580             // If the new value is 0
581             // always pop the heap
582             // we updated the heap, so our address should be on top
583             if (_new == 0) {
584                 heap.popTop();
585                 emit LeaveHeap(_addr, 0, _size);
586             }
587         } else {
588             // IF heap is full or new balance is higher than pop heap
589             if (_new != 0 && (_size < TOP_SIZE || lastBal < _new)) {
590                 // If heap is full pop heap
591                 if (_size >= TOP_SIZE) {
592                     (address _poped, uint256 _balance) = heap.popTop();
593                     emit LeaveHeap(_poped, _balance, _size);
594                 }
595 
596                 // Insert new value
597                 heap.insert(_addr, _new);
598                 emit JoinHeap(_addr, _new, _size);
599             }
600         }
601     }
602 }
603 
604 // File: contracts/ShuffleToken.sol
605 
606 pragma solidity ^0.5.10;
607 
608 
609 
610 
611 
612 
613 
614 
615 contract ShuffleToken is Ownable, GasPump, IERC20 {
616     using DistributedStorage for bytes32;
617     using SafeMath for uint256;
618 
619     // Shuffle events
620     event Winner(address indexed _addr, uint256 _value);
621 
622     // Managment events
623     event SetName(string _prev, string _new);
624     event SetExtraGas(uint256 _prev, uint256 _new);
625     event SetHeap(address _prev, address _new);
626     event WhitelistFrom(address _addr, bool _whitelisted);
627     event WhitelistTo(address _addr, bool _whitelisted);
628 
629     uint256 public totalSupply;
630 
631     bytes32 private constant BALANCE_KEY = keccak256("balance");
632 
633     // game
634     uint256 public constant FEE = 100;
635 
636     // metadata
637     string public name = "Shuffle.Monster V3";
638     string public constant symbol = "SHUF";
639     uint8 public constant decimals = 18;
640 
641     // fee whitelist
642     mapping(address => bool) public whitelistFrom;
643     mapping(address => bool) public whitelistTo;
644 
645     // heap
646     Heap public heap;
647 
648     // internal
649     uint256 public extraGas;
650     bool inited;
651 
652     function init(
653         address _to,
654         uint256 _amount
655     ) external {
656         // Only init once
657         assert(!inited);
658         inited = true;
659 
660         // Sanity checks
661         assert(totalSupply == 0);
662         assert(address(heap) == address(0));
663 
664         // Create Heap
665         heap = new Heap();
666         emit SetHeap(address(0), address(heap));
667 
668         // Init contract variables and mint
669         // entire token balance
670         extraGas = 15;
671         emit SetExtraGas(0, extraGas);
672         emit Transfer(address(0), _to, _amount);
673         _setBalance(_to, _amount);
674         totalSupply = _amount;
675     }
676 
677     ///
678     // Storage access functions
679     ///
680 
681     // Getters
682 
683     function _toKey(address a) internal pure returns (bytes32) {
684         return bytes32(uint256(a));
685     }
686 
687     function _balanceOf(address _addr) internal view returns (uint256) {
688         return uint256(_toKey(_addr).read(BALANCE_KEY));
689     }
690 
691     function _allowance(address _addr, address _spender) internal view returns (uint256) {
692         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
693     }
694 
695     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
696         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
697     }
698 
699     // Setters
700 
701     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
702         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
703     }
704 
705     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
706         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
707     }
708 
709     function _setBalance(address _addr, uint256 _balance) internal {
710         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
711         heap.update(_addr, _balance);
712     }
713 
714     ///
715     // Internal methods
716     ///
717 
718     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
719         return whitelistFrom[_from]||whitelistTo[_to];
720     }
721 
722     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
723         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
724         return rand % (_max + 1);
725     }
726 
727     function _pickWinner(address _from, uint256 _value) internal returns (address winner) {
728         // Get order of magnitude of the tx
729         uint256 magnitude = Math.orderOfMagnitude(_value);
730         // Pull nonce for a given order of magnitude
731         uint256 nonce = _nonce(_from, magnitude);
732         _setNonce(_from, magnitude, nonce + 1);
733         // pick entry from heap
734         winner = heap.addressAt(_random(_from, nonce, magnitude, heap.size() - 1));
735     }
736 
737     function _transferFrom(address _operator, address _from, address _to, uint256 _value, bool _payFee) internal {
738         // If transfer amount is zero
739         // emit event and stop execution
740         if (_value == 0) {
741             emit Transfer(_from, _to, 0);
742             return;
743         }
744 
745         // Load sender balance
746         uint256 balanceFrom = _balanceOf(_from);
747         require(balanceFrom >= _value, "balance not enough");
748 
749         // Check if operator is sender
750         if (_from != _operator) {
751             // If not, validate allowance
752             uint256 allowanceFrom = _allowance(_from, _operator);
753             // If allowance is not 2 ** 256 - 1, consume allowance
754             if (allowanceFrom != uint(-1)) {
755                 // Check allowance and save new one
756                 require(allowanceFrom >= _value, "allowance not enough");
757                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
758             }
759         }
760 
761         // Calculate receiver balance
762         // initial receive is full value
763         uint256 receive = _value;
764         uint256 burn = 0;
765         uint256 shuf = 0;
766 
767         // Change sender balance
768         _setBalance(_from, balanceFrom.sub(_value));
769 
770         // If the transaction is not whitelisted
771         // or if sender requested to pay the fee
772         // calculate fees
773         if (_payFee || !_isWhitelisted(_from, _to)) {
774             // Fee is the same for BURN and SHUF
775             // If we are sending value one
776             // give priority to BURN
777             burn = _value.divRound(FEE);
778             shuf = _value == 1 ? 0 : burn;
779 
780             // Subtract fees from receiver amount
781             receive = receive.sub(burn.add(shuf));
782 
783             // Burn tokens
784             totalSupply = totalSupply.sub(burn);
785             emit Transfer(_from, address(0), burn);
786 
787             // Shuffle tokens
788             // Pick winner pseudo-randomly
789             address winner = _pickWinner(_from, _value);
790             // Transfer balance to winner
791             _setBalance(winner, _balanceOf(winner).add(shuf));
792             emit Winner(winner, shuf);
793             emit Transfer(_from, winner, shuf);
794         }
795 
796         // Sanity checks
797         // no tokens where created
798         assert(burn.add(shuf).add(receive) == _value);
799 
800         // Add tokens to receiver
801         _setBalance(_to, _balanceOf(_to).add(receive));
802         emit Transfer(_from, _to, receive);
803     }
804 
805     ///
806     // Managment
807     ///
808 
809     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
810         emit WhitelistTo(_addr, _whitelisted);
811         whitelistTo[_addr] = _whitelisted;
812     }
813 
814     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
815         emit WhitelistFrom(_addr, _whitelisted);
816         whitelistFrom[_addr] = _whitelisted;
817     }
818 
819     function setName(string calldata _name) external onlyOwner {
820         emit SetName(name, _name);
821         name = _name;
822     }
823 
824     function setExtraGas(uint256 _gas) external onlyOwner {
825         emit SetExtraGas(extraGas, _gas);
826         extraGas = _gas;
827     }
828 
829     function setHeap(Heap _heap) external onlyOwner {
830         emit SetHeap(address(heap), address(_heap));
831         heap = _heap;
832     }
833 
834     /////
835     // Heap methods
836     /////
837 
838     function topSize() external view returns (uint256) {
839         return heap.topSize();
840     }
841 
842     function heapSize() external view returns (uint256) {
843         return heap.size();
844     }
845 
846     function heapEntry(uint256 _i) external view returns (address, uint256) {
847         return heap.entry(_i);
848     }
849 
850     function heapTop() external view returns (address, uint256) {
851         return heap.top();
852     }
853 
854     function heapIndex(address _addr) external view returns (uint256) {
855         return heap.indexOf(_addr);
856     }
857 
858     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
859         return _nonce(_addr, _cat);
860     }
861 
862     /////
863     // ERC20
864     /////
865 
866     function balanceOf(address _addr) external view returns (uint256) {
867         return _balanceOf(_addr);
868     }
869 
870     function allowance(address _addr, address _spender) external view returns (uint256) {
871         return _allowance(_addr, _spender);
872     }
873 
874     function approve(address _spender, uint256 _value) external returns (bool) {
875         emit Approval(msg.sender, _spender, _value);
876         _setAllowance(msg.sender, _spender, _value);
877         return true;
878     }
879 
880     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
881         _transferFrom(msg.sender, msg.sender, _to, _value, false);
882         return true;
883     }
884 
885     function transferWithFee(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
886         _transferFrom(msg.sender, msg.sender, _to, _value, true);
887         return true;
888     }
889 
890     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
891         _transferFrom(msg.sender, _from, _to, _value, false);
892         return true;
893     }
894 
895     function transferFromWithFee(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
896         _transferFrom(msg.sender, _from, _to, _value, true);
897         return true;
898     }
899 }
900 
901 // File: contracts/utils/SigUtils.sol
902 
903 pragma solidity ^0.5.10;
904 
905 
906 library SigUtils {
907     /**
908       @dev Recovers address who signed the message
909       @param _hash operation ethereum signed message hash
910       @param _signature message `hash` signature
911     */
912     function ecrecover2(
913         bytes32 _hash,
914         bytes memory _signature
915     ) internal pure returns (address) {
916         bytes32 r;
917         bytes32 s;
918         uint8 v;
919 
920         /* solium-disable-next-line */
921         assembly {
922             r := mload(add(_signature, 32))
923             s := mload(add(_signature, 64))
924             v := and(mload(add(_signature, 65)), 255)
925         }
926 
927         if (v < 27) {
928             v += 27;
929         }
930 
931         return ecrecover(
932             _hash,
933             v,
934             r,
935             s
936         );
937     }
938 }
939 
940 // File: contracts/utils/SafeCast.sol
941 
942 pragma solidity ^0.5.10;
943 
944 
945 library SafeCast {
946     function toUint96(uint256 _a) internal pure returns (uint96) {
947         require(_a <= 2 ** 96 - 1, "cast uint96 overflow");
948         return uint96(_a);
949     }
950 }
951 
952 // File: contracts/Airdrop.sol
953 
954 pragma solidity ^0.5.10;
955 
956 
957 
958 
959 
960 
961 
962 
963 
964 contract Airdrop is Ownable, ReentrancyGuard {
965     using IsContract for address payable;
966     using SafeCast for uint256;
967     using SafeMath for uint256;
968 
969     ShuffleToken public shuffleToken;
970 
971     // Managment
972     uint64 public maxClaimedBy = 0;
973     uint256 public refsCut;
974     mapping(address => uint256) public customMaxClaimedBy;
975     bool public paused;
976 
977     event SetMaxClaimedBy(uint256 _max);
978     event SetCustomMaxClaimedBy(address _address, uint256 _max);
979     event SetSigner(address _signer, bool _active);
980     event SetMigrator(address _migrator, bool _active);
981     event SetFuse(address _fuse, bool _active);
982     event SetPaused(bool _paused);
983     event SetRefsCut(uint256 _prev, uint256 _new);
984     event Claimed(address _by, address _to, address _signer, uint256 _value, uint256 _claimed);
985     event RefClaim(address _ref, uint256 _val);
986     event ClaimedOwner(address _owner, uint256 _tokens);
987 
988     uint256 public constant MINT_AMOUNT = 1000000 * 10 ** 18;
989     uint256 public constant SHUFLE_BY_ETH = 150;
990     uint256 public constant MAX_CLAIM_ETH = 10 ether;
991 
992     mapping(address => bool) public isSigner;
993     mapping(address => bool) public isMigrator;
994     mapping(address => bool) public isFuse;
995 
996     mapping(address => uint256) public claimed;
997     mapping(address => uint256) public numberClaimedBy;
998 
999     constructor(ShuffleToken _token) public {
1000         shuffleToken = _token;
1001         shuffleToken.init(address(this), MINT_AMOUNT);
1002         emit SetMaxClaimedBy(maxClaimedBy);
1003     }
1004 
1005     // ///
1006     // Managment
1007     // ///
1008 
1009     modifier notPaused() {
1010         require(!paused, "contract is paused");
1011         _;
1012     }
1013 
1014     function setMaxClaimedBy(uint64 _max) external onlyOwner {
1015         maxClaimedBy = _max;
1016         emit SetMaxClaimedBy(_max);
1017     }
1018 
1019     function setSigner(address _signer, bool _active) external onlyOwner {
1020         isSigner[_signer] = _active;
1021         emit SetSigner(_signer, _active);
1022     }
1023 
1024     function setMigrator(address _migrator, bool _active) external onlyOwner {
1025         isMigrator[_migrator] = _active;
1026         emit SetMigrator(_migrator, _active);
1027     }
1028 
1029     function setFuse(address _fuse, bool _active) external onlyOwner {
1030         isFuse[_fuse] = _active;
1031         emit SetFuse(_fuse, _active);
1032     }
1033 
1034     function setSigners(address[] calldata _signers, bool _active) external onlyOwner {
1035         for (uint256 i = 0; i < _signers.length; i++) {
1036             address signer = _signers[i];
1037             isSigner[signer] = _active;
1038             emit SetSigner(signer, _active);
1039         }
1040     }
1041 
1042     function setCustomMaxClaimedBy(address _address, uint256 _max) external onlyOwner {
1043         customMaxClaimedBy[_address] = _max;
1044         emit SetCustomMaxClaimedBy(_address, _max);
1045     }
1046 
1047     function setRefsCut(uint256 _val) external onlyOwner {
1048         emit SetRefsCut(refsCut, _val);
1049         refsCut = _val;
1050     }
1051 
1052     function pause() external {
1053         require(
1054             isFuse[msg.sender] ||
1055             msg.sender == owner ||
1056             isMigrator[msg.sender] ||
1057             isSigner[msg.sender],
1058             "not authorized"
1059         );
1060 
1061         paused = true;
1062         emit SetPaused(true);
1063     }
1064 
1065     function start() external onlyOwner {
1066         emit SetPaused(false);
1067         paused = false;
1068     }
1069 
1070     // ///
1071     // Airdrop
1072     // ///
1073 
1074     function _selfBalance() internal view returns (uint256) {
1075         return shuffleToken.balanceOf(address(this));
1076     }
1077 
1078     function checkFallback(address _to) private returns (bool success) {
1079         /* solium-disable-next-line */
1080         (success, ) = _to.call.value(1)("");
1081     }
1082 
1083     function claim(
1084         address _to,
1085         address _ref,
1086         uint256 _val,
1087         bytes calldata _sig
1088     ) external notPaused nonReentrant {
1089         // Load values
1090         uint96 val = _val.toUint96();
1091 
1092         // Validate signature
1093         bytes32 _hash = keccak256(abi.encodePacked(_to, val));
1094         address signer = SigUtils.ecrecover2(_hash, _sig);
1095         require(isSigner[signer], "signature not valid");
1096 
1097         // Prepare claim amount
1098         uint256 balance = _selfBalance();
1099         uint256 claimVal = Math.min(
1100             balance,
1101             Math.min(
1102                 val,
1103                 MAX_CLAIM_ETH
1104             ).mult(SHUFLE_BY_ETH)
1105         );
1106 
1107         // Sanity checks
1108         assert(claimVal <= SHUFLE_BY_ETH.mult(val));
1109         assert(claimVal <= MAX_CLAIM_ETH.mult(SHUFLE_BY_ETH));
1110         assert(claimVal.div(SHUFLE_BY_ETH) <= MAX_CLAIM_ETH);
1111         assert(
1112             claimVal.div(SHUFLE_BY_ETH) == _val ||
1113             claimVal.div(SHUFLE_BY_ETH) == MAX_CLAIM_ETH ||
1114             claimVal == balance
1115         );
1116 
1117         // Claim, only once
1118         require(claimed[_to] == 0, "already claimed");
1119         claimed[_to] = claimVal;
1120 
1121         // External claim checks
1122         if (msg.sender != _to) {
1123             // Validate max external claims
1124             uint256 _numberClaimedBy = numberClaimedBy[msg.sender].add(1);
1125             require(_numberClaimedBy <= Math.max(maxClaimedBy, customMaxClaimedBy[msg.sender]), "max claim reached");
1126             numberClaimedBy[msg.sender] = _numberClaimedBy;
1127             // Check if _to address can receive ETH
1128             require(checkFallback(_to), "_to address can't receive tokens");
1129         }
1130 
1131         // Transfer Shuffle token, paying fee
1132         shuffleToken.transferWithFee(_to, claimVal);
1133 
1134         // Emit events
1135         emit Claimed(msg.sender, _to, signer, val, claimVal);
1136 
1137         // Ref links
1138         if (refsCut != 0) {
1139             // Only valid for self-claims
1140             if (msg.sender == _to && _ref != address(0)) {
1141                 // Calc transfer extra
1142                 uint256 extra = claimVal.mult(refsCut).div(10000);
1143                 // Ignore ref fee if Airdrop balance is not enought
1144                 if (_selfBalance() >= extra) {
1145                     shuffleToken.transferWithFee(_ref, extra);
1146                     emit RefClaim(_ref, extra);
1147 
1148                     // Sanity checks
1149                     assert(extra <= MAX_CLAIM_ETH.mult(SHUFLE_BY_ETH));
1150                     assert(extra <= claimVal);
1151                     assert(extra == (claimVal * refsCut) / 10000);
1152                 }
1153             }
1154         }
1155 
1156         // If contract is empty, perform self destruct
1157         if (balance == claimVal && _selfBalance() == 0) {
1158             selfdestruct(address(uint256(owner)));
1159         }
1160     }
1161 
1162     // Migration methods
1163 
1164     event Migrated(address _addr, uint256 _balance);
1165     mapping(address => uint256) public migrated;
1166 
1167     function migrate(address _addr, uint256 _balance, uint256 _require) external notPaused {
1168         // Check if migrator is a migrator
1169         require(isMigrator[msg.sender], "only migrator can migrate");
1170 
1171         // Check if expected migrated matches current migrated
1172         require(migrated[_addr] == _require, "_require prev migrate failed");
1173 
1174         // Save migrated amount
1175         migrated[_addr] = migrated[_addr].add(_balance);
1176 
1177         // Transfer tokens and emit event
1178         shuffleToken.transfer(_addr, _balance);
1179         emit Migrated(_addr, _balance);
1180     }
1181 
1182     function fund() external payable { }
1183 }