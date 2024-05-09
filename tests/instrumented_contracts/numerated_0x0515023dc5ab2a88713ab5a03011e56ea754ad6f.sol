1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-11
3 */
4 
5 pragma solidity ^0.5.10;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  */
19 contract ReentrancyGuard {
20     // counter to allow mutex lock with only one SSTORE operation
21     uint256 private _guardCounter;
22 
23     constructor () internal {
24         // The counter starts at one to prevent changing it from zero to a non-zero
25         // value, which is a more expensive operation.
26         _guardCounter = 1;
27     }
28 
29     /**
30      * @dev Prevents a contract from calling itself, directly or indirectly.
31      * Calling a `nonReentrant` function from another `nonReentrant`
32      * function is not supported. It is possible to prevent this from happening
33      * by making the `nonReentrant` function external, and make it call a
34      * `private` function that does the actual work.
35      */
36     modifier nonReentrant() {
37         _guardCounter += 1;
38         uint256 localCounter = _guardCounter;
39         _;
40         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
41     }
42 }
43 
44 // File: contracts/commons/Ownable.sol
45 
46 pragma solidity ^0.5.10;
47 
48 
49 contract Ownable {
50     address public owner;
51 
52     event TransferOwnership(address _from, address _to);
53 
54     constructor() public {
55         owner = msg.sender;
56         emit TransferOwnership(address(0), msg.sender);
57     }
58 
59     modifier onlyOwner() {
60         require(msg.sender == owner, "only owner");
61         _;
62     }
63 
64     function setOwner(address _owner) external onlyOwner {
65         emit TransferOwnership(owner, _owner);
66         owner = _owner;
67     }
68 }
69 
70 // File: contracts/commons/StorageUnit.sol
71 
72 pragma solidity ^0.5.10;
73 
74 
75 contract StorageUnit {
76     address private owner;
77     mapping(bytes32 => bytes32) private store;
78 
79     constructor() public {
80         owner = msg.sender;
81     }
82 
83     function write(bytes32 _key, bytes32 _value) external {
84         /* solium-disable-next-line */
85         require(msg.sender == owner);
86         store[_key] = _value;
87     }
88 
89     function read(bytes32 _key) external view returns (bytes32) {
90         return store[_key];
91     }
92 }
93 
94 // File: contracts/utils/IsContract.sol
95 
96 pragma solidity ^0.5.10;
97 
98 
99 library IsContract {
100     function isContract(address _addr) internal view returns (bool) {
101         bytes32 codehash;
102         /* solium-disable-next-line */
103         assembly { codehash := extcodehash(_addr) }
104         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
105     }
106 }
107 
108 // File: contracts/utils/DistributedStorage.sol
109 
110 pragma solidity ^0.5.10;
111 
112 
113 
114 
115 library DistributedStorage {
116     function contractSlot(bytes32 _struct) private view returns (address) {
117         return address(
118             uint256(
119                 keccak256(
120                     abi.encodePacked(
121                         byte(0xff),
122                         address(this),
123                         _struct,
124                         keccak256(type(StorageUnit).creationCode)
125                     )
126                 )
127             )
128         );
129     }
130 
131     function deploy(bytes32 _struct) private {
132         bytes memory slotcode = type(StorageUnit).creationCode;
133         /* solium-disable-next-line */
134         assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }
135     }
136 
137     function write(
138         bytes32 _struct,
139         bytes32 _key,
140         bytes32 _value
141     ) internal {
142         StorageUnit store = StorageUnit(contractSlot(_struct));
143         if (!IsContract.isContract(address(store))) {
144             deploy(_struct);
145         }
146 
147         /* solium-disable-next-line */
148         (bool success, ) = address(store).call(
149             abi.encodeWithSelector(
150                 store.write.selector,
151                 _key,
152                 _value
153             )
154         );
155 
156         require(success, "error writing storage");
157     }
158 
159     function read(
160         bytes32 _struct,
161         bytes32 _key
162     ) internal view returns (bytes32) {
163         StorageUnit store = StorageUnit(contractSlot(_struct));
164         if (!IsContract.isContract(address(store))) {
165             return bytes32(0);
166         }
167 
168         /* solium-disable-next-line */
169         (bool success, bytes memory data) = address(store).staticcall(
170             abi.encodeWithSelector(
171                 store.read.selector,
172                 _key
173             )
174         );
175 
176         require(success, "error reading storage");
177         return abi.decode(data, (bytes32));
178     }
179 }
180 
181 // File: contracts/utils/SafeMath.sol
182 
183 pragma solidity ^0.5.10;
184 
185 
186 library SafeMath {
187     function add(uint256 x, uint256 y) internal pure returns (uint256) {
188         uint256 z = x + y;
189         require(z >= x, "Add overflow");
190         return z;
191     }
192 
193     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
194         require(x >= y, "Sub underflow");
195         return x - y;
196     }
197 
198     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
199         if (x == 0) {
200             return 0;
201         }
202 
203         uint256 z = x * y;
204         require(z / x == y, "Mult overflow");
205         return z;
206     }
207 
208     function div(uint256 x, uint256 y) internal pure returns (uint256) {
209         require(y != 0, "Div by zero");
210         return x / y;
211     }
212 
213     function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
214         require(y != 0, "Div by zero");
215         uint256 r = x / y;
216         if (x % y != 0) {
217             r = r + 1;
218         }
219 
220         return r;
221     }
222 }
223 
224 // File: contracts/utils/Math.sol
225 
226 pragma solidity ^0.5.10;
227 
228 
229 library Math {
230     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
231         uint256 counter = uint(-1);
232         uint256 temp = input;
233 
234         do {
235             temp /= 10;
236             counter++;
237         } while (temp != 0);
238 
239         return counter;
240     }
241 
242     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
243         if (_a < _b) {
244             return _a;
245         } else {
246             return _b;
247         }
248     }
249 
250     function max(uint256 _a, uint256 _b) internal pure returns (uint256) {
251         if (_a > _b) {
252             return _a;
253         } else {
254             return _b;
255         }
256     }
257 }
258 
259 // File: contracts/utils/GasPump.sol
260 
261 pragma solidity ^0.5.10;
262 
263 
264 contract GasPump {
265     bytes32 private stub;
266 
267     modifier requestGas(uint256 _factor) {
268         if (tx.gasprice == 0 || gasleft() > block.gaslimit) {
269             uint256 startgas = gasleft();
270             _;
271             uint256 delta = startgas - gasleft();
272             uint256 target = (delta * _factor) / 100;
273             startgas = gasleft();
274             while (startgas - gasleft() < target) {
275                 // Burn gas
276                 stub = keccak256(abi.encodePacked(stub));
277             }
278         } else {
279             _;
280         }
281     }
282 }
283 
284 // File: contracts/interfaces/IERC20.sol
285 
286 pragma solidity ^0.5.10;
287 
288 
289 interface IERC20 {
290     event Transfer(address indexed _from, address indexed _to, uint256 _value);
291     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
292     function transfer(address _to, uint _value) external returns (bool success);
293     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
294     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
295     function approve(address _spender, uint256 _value) external returns (bool success);
296     function balanceOf(address _owner) external view returns (uint256 balance);
297 }
298 
299 // File: contracts/commons/AddressMinHeap.sol
300 
301 pragma solidity ^0.5.10;
302 
303 /*
304     @author Agustin Aguilar <agusxrun@gmail.com>
305 */
306 
307 
308 library AddressMinHeap {
309     using AddressMinHeap for AddressMinHeap.Heap;
310 
311     struct Heap {
312         uint256[] entries;
313         mapping(address => uint256) index;
314     }
315 
316     function initialize(Heap storage _heap) internal {
317         require(_heap.entries.length == 0, "already initialized");
318         _heap.entries.push(0);
319     }
320 
321     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
322         /* solium-disable-next-line */
323         assembly {
324             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
325         }
326     }
327 
328     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
329         /* solium-disable-next-line */
330         assembly {
331             let entry := not(_entry)
332             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
333             _value := shr(160, entry)
334         }
335     }
336 
337     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
338         /* solium-disable-next-line */
339         assembly {
340             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
341         }
342     }
343 
344     function top(Heap storage _heap) internal view returns(address, uint256) {
345         if (_heap.entries.length < 2) {
346             return (address(0), 0);
347         }
348 
349         return decode(_heap.entries[1]);
350     }
351 
352     function has(Heap storage _heap, address _addr) internal view returns (bool) {
353         return _heap.index[_addr] != 0;
354     }
355 
356     function size(Heap storage _heap) internal view returns (uint256) {
357         return _heap.entries.length - 1;
358     }
359 
360     function entry(Heap storage _heap, uint256 _i) internal view returns (address, uint256) {
361         return decode(_heap.entries[_i + 1]);
362     }
363 
364     // RemoveMax pops off the root element of the heap (the highest value here) and rebalances the heap
365     function popTop(Heap storage _heap) internal returns(address _addr, uint256 _value) {
366         // Ensure the heap exists
367         uint256 heapLength = _heap.entries.length;
368         require(heapLength > 1, "The heap does not exists");
369 
370         // take the root value of the heap
371         (_addr, _value) = decode(_heap.entries[1]);
372         _heap.index[_addr] = 0;
373 
374         if (heapLength == 2) {
375             _heap.entries.length = 1;
376         } else {
377             // Takes the last element of the array and put it at the root
378             uint256 val = _heap.entries[heapLength - 1];
379             _heap.entries[1] = val;
380 
381             // Delete the last element from the array
382             _heap.entries.length = heapLength - 1;
383 
384             // Start at the top
385             uint256 ind = 1;
386 
387             // Bubble down
388             ind = _heap.bubbleDown(ind, val);
389 
390             // Update index
391             _heap.index[decodeAddress(val)] = ind;
392         }
393     }
394 
395     // Inserts adds in a value to our heap.
396     function insert(Heap storage _heap, address _addr, uint256 _value) internal {
397         require(_heap.index[_addr] == 0, "The entry already exists");
398 
399         // Add the value to the end of our array
400         uint256 encoded = encode(_addr, _value);
401         _heap.entries.push(encoded);
402 
403         // Start at the end of the array
404         uint256 currentIndex = _heap.entries.length - 1;
405 
406         // Bubble Up
407         currentIndex = _heap.bubbleUp(currentIndex, encoded);
408 
409         // Update index
410         _heap.index[_addr] = currentIndex;
411     }
412 
413     function update(Heap storage _heap, address _addr, uint256 _value) internal {
414         uint256 ind = _heap.index[_addr];
415         require(ind != 0, "The entry does not exists");
416 
417         uint256 can = encode(_addr, _value);
418         uint256 val = _heap.entries[ind];
419         uint256 newInd;
420 
421         if (can < val) {
422             // Bubble down
423             newInd = _heap.bubbleDown(ind, can);
424         } else if (can > val) {
425             // Bubble up
426             newInd = _heap.bubbleUp(ind, can);
427         } else {
428             // no changes needed
429             return;
430         }
431 
432         // Update entry
433         _heap.entries[newInd] = can;
434 
435         // Update index
436         if (newInd != ind) {
437             _heap.index[_addr] = newInd;
438         }
439     }
440 
441     function bubbleUp(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
442         // Bubble up
443         ind = _ind;
444         if (ind != 1) {
445             uint256 parent = _heap.entries[ind / 2];
446             while (parent < _val) {
447                 // If the parent value is lower than our current value, we swap them
448                 (_heap.entries[ind / 2], _heap.entries[ind]) = (_val, parent);
449 
450                 // Update moved Index
451                 _heap.index[decodeAddress(parent)] = ind;
452 
453                 // change our current Index to go up to the parent
454                 ind = ind / 2;
455                 if (ind == 1) {
456                     break;
457                 }
458 
459                 // Update parent
460                 parent = _heap.entries[ind / 2];
461             }
462         }
463     }
464 
465     function bubbleDown(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
466         // Bubble down
467         ind = _ind;
468 
469         uint256 lenght = _heap.entries.length;
470         uint256 target = lenght - 1;
471 
472         while (ind * 2 < lenght) {
473             // get the current index of the children
474             uint256 j = ind * 2;
475 
476             // left child value
477             uint256 leftChild = _heap.entries[j];
478 
479             // Store the value of the child
480             uint256 childValue;
481 
482             if (target > j) {
483                 // The parent has two childs 👨‍👧‍👦
484 
485                 // Load right child value
486                 uint256 rightChild = _heap.entries[j + 1];
487 
488                 // Compare the left and right child.
489                 // if the rightChild is greater, then point j to it's index
490                 // and save the value
491                 if (leftChild < rightChild) {
492                     childValue = rightChild;
493                     j = j + 1;
494                 } else {
495                     // The left child is greater
496                     childValue = leftChild;
497                 }
498             } else {
499                 // The parent has a single child 👨‍👦
500                 childValue = leftChild;
501             }
502 
503             // Check if the child has a lower value
504             if (_val > childValue) {
505                 break;
506             }
507 
508             // else swap the value
509             (_heap.entries[ind], _heap.entries[j]) = (childValue, _val);
510 
511             // Update moved Index
512             _heap.index[decodeAddress(childValue)] = ind;
513 
514             // and let's keep going down the heap
515             ind = j;
516         }
517     }
518 }
519 
520 // File: contracts/Heap.sol
521 
522 pragma solidity ^0.5.10;
523 
524 
525 
526 contract Heap is Ownable {
527     using AddressMinHeap for AddressMinHeap.Heap;
528 
529     // heap
530     AddressMinHeap.Heap private heap;
531 
532     // Heap events
533     event JoinHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
534     event LeaveHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
535 
536     uint256 public constant TOP_SIZE = 512;
537 
538     constructor() public {
539         heap.initialize();
540     }
541 
542     function topSize() external pure returns (uint256) {
543         return TOP_SIZE;
544     }
545 
546     function addressAt(uint256 _i) external view returns (address addr) {
547         (addr, ) = heap.entry(_i);
548     }
549 
550     function indexOf(address _addr) external view returns (uint256) {
551         return heap.index[_addr];
552     }
553 
554     function entry(uint256 _i) external view returns (address, uint256) {
555         return heap.entry(_i);
556     }
557 
558     function top() external view returns (address, uint256) {
559         return heap.top();
560     }
561 
562     function size() external view returns (uint256) {
563         return heap.size();
564     }
565 
566     function update(address _addr, uint256 _new) external onlyOwner {
567         uint256 _size = heap.size();
568 
569         // If the heap is empty
570         // join the _addr
571         if (_size == 0) {
572             emit JoinHeap(_addr, _new, 0);
573             heap.insert(_addr, _new);
574             return;
575         }
576 
577         // Load top value of the heap
578         (, uint256 lastBal) = heap.top();
579 
580         // If our target address already is in the heap
581         if (heap.has(_addr)) {
582             // Update the target address value
583             heap.update(_addr, _new);
584             // If the new value is 0
585             // always pop the heap
586             // we updated the heap, so our address should be on top
587             if (_new == 0) {
588                 heap.popTop();
589                 emit LeaveHeap(_addr, 0, _size);
590             }
591         } else {
592             // IF heap is full or new balance is higher than pop heap
593             if (_new != 0 && (_size < TOP_SIZE || lastBal < _new)) {
594                 // If heap is full pop heap
595                 if (_size >= TOP_SIZE) {
596                     (address _poped, uint256 _balance) = heap.popTop();
597                     emit LeaveHeap(_poped, _balance, _size);
598                 }
599 
600                 // Insert new value
601                 heap.insert(_addr, _new);
602                 emit JoinHeap(_addr, _new, _size);
603             }
604         }
605     }
606 }
607 
608 // File: contracts/ShuffleToken.sol
609 
610 pragma solidity ^0.5.10;
611 
612 
613 
614 
615 
616 
617 
618 
619 contract ShuffleToken is Ownable, GasPump, IERC20 {
620     using DistributedStorage for bytes32;
621     using SafeMath for uint256;
622 
623     // Shuffle events
624     event Winner(address indexed _addr, uint256 _value);
625 
626     // Managment events
627     event SetName(string _prev, string _new);
628     event SetExtraGas(uint256 _prev, uint256 _new);
629     event SetHeap(address _prev, address _new);
630     event WhitelistFrom(address _addr, bool _whitelisted);
631     event WhitelistTo(address _addr, bool _whitelisted);
632 
633     uint256 public totalSupply;
634 
635     bytes32 private constant BALANCE_KEY = keccak256("balance");
636 
637     // game
638     uint256 public constant FEE = 100;
639 
640     // metadata
641     string public name = "Shuffle.Monster V3";
642     string public constant symbol = "SHUF";
643     uint8 public constant decimals = 18;
644 
645     // fee whitelist
646     mapping(address => bool) public whitelistFrom;
647     mapping(address => bool) public whitelistTo;
648 
649     // heap
650     Heap public heap;
651 
652     // internal
653     uint256 public extraGas;
654     bool inited;
655 
656     function init(
657         address _to,
658         uint256 _amount
659     ) external {
660         // Only init once
661         assert(!inited);
662         inited = true;
663 
664         // Sanity checks
665         assert(totalSupply == 0);
666         assert(address(heap) == address(0));
667 
668         // Create Heap
669         heap = new Heap();
670         emit SetHeap(address(0), address(heap));
671 
672         // Init contract variables and mint
673         // entire token balance
674         extraGas = 15;
675         emit SetExtraGas(0, extraGas);
676         emit Transfer(address(0), _to, _amount);
677         _setBalance(_to, _amount);
678         totalSupply = _amount;
679     }
680 
681     ///
682     // Storage access functions
683     ///
684 
685     // Getters
686 
687     function _toKey(address a) internal pure returns (bytes32) {
688         return bytes32(uint256(a));
689     }
690 
691     function _balanceOf(address _addr) internal view returns (uint256) {
692         return uint256(_toKey(_addr).read(BALANCE_KEY));
693     }
694 
695     function _allowance(address _addr, address _spender) internal view returns (uint256) {
696         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
697     }
698 
699     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
700         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
701     }
702 
703     // Setters
704 
705     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
706         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
707     }
708 
709     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
710         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
711     }
712 
713     function _setBalance(address _addr, uint256 _balance) internal {
714         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
715         heap.update(_addr, _balance);
716     }
717 
718     ///
719     // Internal methods
720     ///
721 
722     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
723         return whitelistFrom[_from]||whitelistTo[_to];
724     }
725 
726     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
727         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
728         return rand % (_max + 1);
729     }
730 
731     function _pickWinner(address _from, uint256 _value) internal returns (address winner) {
732         // Get order of magnitude of the tx
733         uint256 magnitude = Math.orderOfMagnitude(_value);
734         // Pull nonce for a given order of magnitude
735         uint256 nonce = _nonce(_from, magnitude);
736         _setNonce(_from, magnitude, nonce + 1);
737         // pick entry from heap
738         winner = heap.addressAt(_random(_from, nonce, magnitude, heap.size() - 1));
739     }
740 
741     function _transferFrom(address _operator, address _from, address _to, uint256 _value, bool _payFee) internal {
742         // If transfer amount is zero
743         // emit event and stop execution
744         if (_value == 0) {
745             emit Transfer(_from, _to, 0);
746             return;
747         }
748 
749         // Load sender balance
750         uint256 balanceFrom = _balanceOf(_from);
751         require(balanceFrom >= _value, "balance not enough");
752 
753         // Check if operator is sender
754         if (_from != _operator) {
755             // If not, validate allowance
756             uint256 allowanceFrom = _allowance(_from, _operator);
757             // If allowance is not 2 ** 256 - 1, consume allowance
758             if (allowanceFrom != uint(-1)) {
759                 // Check allowance and save new one
760                 require(allowanceFrom >= _value, "allowance not enough");
761                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
762             }
763         }
764 
765         // Calculate receiver balance
766         // initial receive is full value
767         uint256 receive = _value;
768         uint256 burn = 0;
769         uint256 shuf = 0;
770 
771         // Change sender balance
772         _setBalance(_from, balanceFrom.sub(_value));
773 
774         // If the transaction is not whitelisted
775         // or if sender requested to pay the fee
776         // calculate fees
777         if (_payFee || !_isWhitelisted(_from, _to)) {
778             // Fee is the same for BURN and SHUF
779             // If we are sending value one
780             // give priority to BURN
781             burn = _value.divRound(FEE);
782             shuf = _value == 1 ? 0 : burn;
783 
784             // Subtract fees from receiver amount
785             receive = receive.sub(burn.add(shuf));
786 
787             // Burn tokens
788             totalSupply = totalSupply.sub(burn);
789             emit Transfer(_from, address(0), burn);
790 
791             // Shuffle tokens
792             // Pick winner pseudo-randomly
793             address winner = _pickWinner(_from, _value);
794             // Transfer balance to winner
795             _setBalance(winner, _balanceOf(winner).add(shuf));
796             emit Winner(winner, shuf);
797             emit Transfer(_from, winner, shuf);
798         }
799 
800         // Sanity checks
801         // no tokens where created
802         assert(burn.add(shuf).add(receive) == _value);
803 
804         // Add tokens to receiver
805         _setBalance(_to, _balanceOf(_to).add(receive));
806         emit Transfer(_from, _to, receive);
807     }
808 
809     ///
810     // Managment
811     ///
812 
813     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
814         emit WhitelistTo(_addr, _whitelisted);
815         whitelistTo[_addr] = _whitelisted;
816     }
817 
818     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
819         emit WhitelistFrom(_addr, _whitelisted);
820         whitelistFrom[_addr] = _whitelisted;
821     }
822 
823     function setName(string calldata _name) external onlyOwner {
824         emit SetName(name, _name);
825         name = _name;
826     }
827 
828     function setExtraGas(uint256 _gas) external onlyOwner {
829         emit SetExtraGas(extraGas, _gas);
830         extraGas = _gas;
831     }
832 
833     function setHeap(Heap _heap) external onlyOwner {
834         emit SetHeap(address(heap), address(_heap));
835         heap = _heap;
836     }
837 
838     /////
839     // Heap methods
840     /////
841 
842     function topSize() external view returns (uint256) {
843         return heap.topSize();
844     }
845 
846     function heapSize() external view returns (uint256) {
847         return heap.size();
848     }
849 
850     function heapEntry(uint256 _i) external view returns (address, uint256) {
851         return heap.entry(_i);
852     }
853 
854     function heapTop() external view returns (address, uint256) {
855         return heap.top();
856     }
857 
858     function heapIndex(address _addr) external view returns (uint256) {
859         return heap.indexOf(_addr);
860     }
861 
862     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
863         return _nonce(_addr, _cat);
864     }
865 
866     /////
867     // ERC20
868     /////
869 
870     function balanceOf(address _addr) external view returns (uint256) {
871         return _balanceOf(_addr);
872     }
873 
874     function allowance(address _addr, address _spender) external view returns (uint256) {
875         return _allowance(_addr, _spender);
876     }
877 
878     function approve(address _spender, uint256 _value) external returns (bool) {
879         emit Approval(msg.sender, _spender, _value);
880         _setAllowance(msg.sender, _spender, _value);
881         return true;
882     }
883 
884     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
885         _transferFrom(msg.sender, msg.sender, _to, _value, false);
886         return true;
887     }
888 
889     function transferWithFee(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
890         _transferFrom(msg.sender, msg.sender, _to, _value, true);
891         return true;
892     }
893 
894     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
895         _transferFrom(msg.sender, _from, _to, _value, false);
896         return true;
897     }
898 
899     function transferFromWithFee(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
900         _transferFrom(msg.sender, _from, _to, _value, true);
901         return true;
902     }
903 }
904 
905 // File: contracts/utils/SigUtils.sol
906 
907 pragma solidity ^0.5.10;
908 
909 
910 library SigUtils {
911     /**
912       @dev Recovers address who signed the message
913       @param _hash operation ethereum signed message hash
914       @param _signature message `hash` signature
915     */
916     function ecrecover2(
917         bytes32 _hash,
918         bytes memory _signature
919     ) internal pure returns (address) {
920         bytes32 r;
921         bytes32 s;
922         uint8 v;
923 
924         /* solium-disable-next-line */
925         assembly {
926             r := mload(add(_signature, 32))
927             s := mload(add(_signature, 64))
928             v := and(mload(add(_signature, 65)), 255)
929         }
930 
931         if (v < 27) {
932             v += 27;
933         }
934 
935         return ecrecover(
936             _hash,
937             v,
938             r,
939             s
940         );
941     }
942 }
943 
944 // File: contracts/utils/SafeCast.sol
945 
946 pragma solidity ^0.5.10;
947 
948 
949 library SafeCast {
950     function toUint96(uint256 _a) internal pure returns (uint96) {
951         require(_a <= 2 ** 96 - 1, "cast uint96 overflow");
952         return uint96(_a);
953     }
954 }
955 
956 // File: contracts/Airdrop.sol
957 
958 pragma solidity ^0.5.10;
959 
960 
961 
962 
963 
964 
965 
966 
967 
968 contract Airdrop is Ownable, ReentrancyGuard {
969     using IsContract for address payable;
970     using SafeCast for uint256;
971     using SafeMath for uint256;
972 
973     ShuffleToken public shuffleToken;
974 
975     // Managment
976     uint64 public maxClaimedBy = 0;
977     uint256 public refsCut;
978     mapping(address => uint256) public customMaxClaimedBy;
979     bool public paused;
980 
981     event SetMaxClaimedBy(uint256 _max);
982     event SetCustomMaxClaimedBy(address _address, uint256 _max);
983     event SetSigner(address _signer, bool _active);
984     event SetMigrator(address _migrator, bool _active);
985     event SetFuse(address _fuse, bool _active);
986     event SetPaused(bool _paused);
987     event SetRefsCut(uint256 _prev, uint256 _new);
988     event Claimed(address _by, address _to, address _signer, uint256 _value, uint256 _claimed, bytes _signature);
989     event RefClaim(address _ref, uint256 _val);
990     event ClaimedOwner(address _owner, uint256 _tokens);
991 
992     uint256 public constant MINT_AMOUNT = 1000000 * 10 ** 18;
993     uint256 public constant SHUFLE_BY_ETH = 150;
994     uint256 public constant MAX_CLAIM_ETH = 10 ether;
995 
996     mapping(address => bool) public isSigner;
997     mapping(address => bool) public isMigrator;
998     mapping(address => bool) public isFuse;
999 
1000     mapping(address => uint256) public claimed;
1001     mapping(address => uint256) public numberClaimedBy;
1002 
1003     constructor(ShuffleToken _token) public {
1004         shuffleToken = _token;
1005         emit SetMaxClaimedBy(maxClaimedBy);
1006     }
1007 
1008     // ///
1009     // Managment
1010     // ///
1011 
1012     modifier notPaused() {
1013         require(!paused, "contract is paused");
1014         _;
1015     }
1016 
1017     function setMaxClaimedBy(uint64 _max) external onlyOwner {
1018         maxClaimedBy = _max;
1019         emit SetMaxClaimedBy(_max);
1020     }
1021 
1022     function setSigner(address _signer, bool _active) external onlyOwner {
1023         isSigner[_signer] = _active;
1024         emit SetSigner(_signer, _active);
1025     }
1026 
1027     function setMigrator(address _migrator, bool _active) external onlyOwner {
1028         isMigrator[_migrator] = _active;
1029         emit SetMigrator(_migrator, _active);
1030     }
1031 
1032     function setFuse(address _fuse, bool _active) external onlyOwner {
1033         isFuse[_fuse] = _active;
1034         emit SetFuse(_fuse, _active);
1035     }
1036 
1037     function setSigners(address[] calldata _signers, bool _active) external onlyOwner {
1038         for (uint256 i = 0; i < _signers.length; i++) {
1039             address signer = _signers[i];
1040             isSigner[signer] = _active;
1041             emit SetSigner(signer, _active);
1042         }
1043     }
1044 
1045     function setCustomMaxClaimedBy(address _address, uint256 _max) external onlyOwner {
1046         customMaxClaimedBy[_address] = _max;
1047         emit SetCustomMaxClaimedBy(_address, _max);
1048     }
1049 
1050     function setRefsCut(uint256 _val) external onlyOwner {
1051         emit SetRefsCut(refsCut, _val);
1052         refsCut = _val;
1053     }
1054 
1055     function pause() external {
1056         require(
1057             isFuse[msg.sender] ||
1058             msg.sender == owner ||
1059             isMigrator[msg.sender] ||
1060             isSigner[msg.sender],
1061             "not authorized"
1062         );
1063 
1064         paused = true;
1065         emit SetPaused(true);
1066     }
1067 
1068     function start() external onlyOwner {
1069         emit SetPaused(false);
1070         paused = false;
1071     }
1072 
1073     // ///
1074     // Airdrop
1075     // ///
1076 
1077     function _selfBalance() internal view returns (uint256) {
1078         return shuffleToken.balanceOf(address(this));
1079     }
1080 
1081     function checkFallback(address _to) private returns (bool success) {
1082         /* solium-disable-next-line */
1083         (success, ) = _to.call.value(1)("");
1084     }
1085 
1086     function claim(
1087         address _to,
1088         address _ref,
1089         uint256 _val,
1090         bytes calldata _sig
1091     ) external notPaused nonReentrant {
1092         // Load values
1093         uint96 val = _val.toUint96();
1094 
1095         // Validate signature
1096         bytes32 _hash = keccak256(abi.encodePacked(_to, val));
1097         address signer = SigUtils.ecrecover2(_hash, _sig);
1098         require(isSigner[signer], "signature not valid");
1099 
1100         // Prepare claim amount
1101         uint256 balance = _selfBalance();
1102         uint256 claimVal = Math.min(
1103             balance,
1104             Math.min(
1105                 val,
1106                 MAX_CLAIM_ETH
1107             ).mult(SHUFLE_BY_ETH)
1108         );
1109 
1110         // Sanity checks
1111         assert(claimVal <= SHUFLE_BY_ETH.mult(val));
1112         assert(claimVal <= MAX_CLAIM_ETH.mult(SHUFLE_BY_ETH));
1113         assert(claimVal.div(SHUFLE_BY_ETH) <= MAX_CLAIM_ETH);
1114         assert(
1115             claimVal.div(SHUFLE_BY_ETH) == _val ||
1116             claimVal.div(SHUFLE_BY_ETH) == MAX_CLAIM_ETH ||
1117             claimVal == balance
1118         );
1119 
1120         // Claim, only once
1121         require(claimed[_to] == 0, "already claimed");
1122         claimed[_to] = claimVal;
1123 
1124         // External claim checks
1125         if (msg.sender != _to) {
1126             // Validate max external claims
1127             uint256 _numberClaimedBy = numberClaimedBy[msg.sender].add(1);
1128             require(_numberClaimedBy <= Math.max(maxClaimedBy, customMaxClaimedBy[msg.sender]), "max claim reached");
1129             numberClaimedBy[msg.sender] = _numberClaimedBy;
1130             // Check if _to address can receive ETH
1131             require(checkFallback(_to), "_to address can't receive tokens");
1132         }
1133 
1134         // Transfer Shuffle token, paying fee
1135         shuffleToken.transferWithFee(_to, claimVal);
1136 
1137         // Emit events
1138         emit Claimed(msg.sender, _to, signer, val, claimVal, _sig);
1139 
1140         // Ref links
1141         if (refsCut != 0) {
1142             // Only valid for self-claims
1143             if (msg.sender == _to && _ref != address(0)) {
1144                 // Calc transfer extra
1145                 uint256 extra = claimVal.mult(refsCut).div(10000);
1146                 // Ignore ref fee if Airdrop balance is not enought
1147                 if (_selfBalance() >= extra) {
1148                     shuffleToken.transferWithFee(_ref, extra);
1149                     emit RefClaim(_ref, extra);
1150 
1151                     // Sanity checks
1152                     assert(extra <= MAX_CLAIM_ETH.mult(SHUFLE_BY_ETH));
1153                     assert(extra <= claimVal);
1154                     assert(extra == (claimVal * refsCut) / 10000);
1155                 }
1156             }
1157         }
1158 
1159         // If contract is empty, perform self destruct
1160         if (balance == claimVal && _selfBalance() == 0) {
1161             selfdestruct(address(uint256(owner)));
1162         }
1163     }
1164 
1165     // Migration methods
1166 
1167     event Migrated(address _addr, uint256 _balance);
1168     mapping(address => uint256) public migrated;
1169 
1170     function migrate(address _addr, uint256 _balance, uint256 _require) external notPaused {
1171         // Check if migrator is a migrator
1172         require(isMigrator[msg.sender], "only migrator can migrate");
1173 
1174         // Check if expected migrated matches current migrated
1175         require(migrated[_addr] == _require, "_require prev migrate failed");
1176 
1177         // Save migrated amount
1178         migrated[_addr] = migrated[_addr].add(_balance);
1179 
1180         // Transfer tokens and emit event
1181         shuffleToken.transfer(_addr, _balance);
1182         emit Migrated(_addr, _balance);
1183     }
1184 
1185     function fund() external payable { }
1186 }