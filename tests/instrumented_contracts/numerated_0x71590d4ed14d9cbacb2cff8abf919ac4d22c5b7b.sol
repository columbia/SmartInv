1 /**
2 
3     This token is based on the original work of Shuffle Monster token https://shuffle.monster/ (0x3A9FfF453d50D4Ac52A6890647b823379ba36B9E)
4 
5 */
6 
7 pragma solidity ^0.5.10;
8 
9 // File: contracts/commons/Ownable.sol
10 
11 
12 contract Ownable {
13     address public owner;
14 
15     event TransferOwnership(address _from, address _to);
16 
17     constructor() public {
18         owner = msg.sender;
19         emit TransferOwnership(address(0), msg.sender);
20     }
21 
22     modifier onlyOwner() {
23         require(msg.sender == owner, "only owner");
24         _;
25     }
26 
27     function setOwner(address _owner) external onlyOwner {
28         emit TransferOwnership(owner, _owner);
29         owner = _owner;
30     }
31 }
32 
33 // File: contracts/commons/StorageUnit.sol
34 
35 pragma solidity ^0.5.10;
36 
37 
38 contract StorageUnit {
39     address private owner;
40     mapping(bytes32 => bytes32) private store;
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     function write(bytes32 _key, bytes32 _value) external {
47         /* solium-disable-next-line */
48         require(msg.sender == owner);
49         store[_key] = _value;
50     }
51 
52     function read(bytes32 _key) external view returns (bytes32) {
53         return store[_key];
54     }
55 }
56 
57 // File: contracts/utils/IsContract.sol
58 
59 pragma solidity ^0.5.10;
60 
61 
62 library IsContract {
63     function isContract(address _addr) internal view returns (bool) {
64         bytes32 codehash;
65         /* solium-disable-next-line */
66         assembly { codehash := extcodehash(_addr) }
67         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
68     }
69 }
70 
71 // File: contracts/utils/DistributedStorage.sol
72 
73 pragma solidity ^0.5.10;
74 
75 
76 
77 
78 library DistributedStorage {
79     function contractSlot(bytes32 _struct) private view returns (address) {
80         return address(
81             uint256(
82                 keccak256(
83                     abi.encodePacked(
84                         byte(0xff),
85                         address(this),
86                         _struct,
87                         keccak256(type(StorageUnit).creationCode)
88                     )
89                 )
90             )
91         );
92     }
93 
94     function deploy(bytes32 _struct) private {
95         bytes memory slotcode = type(StorageUnit).creationCode;
96         /* solium-disable-next-line */
97         assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }
98     }
99 
100     function write(
101         bytes32 _struct,
102         bytes32 _key,
103         bytes32 _value
104     ) internal {
105         StorageUnit store = StorageUnit(contractSlot(_struct));
106         if (!IsContract.isContract(address(store))) {
107             deploy(_struct);
108         }
109 
110         /* solium-disable-next-line */
111         (bool success, ) = address(store).call(
112             abi.encodeWithSelector(
113                 store.write.selector,
114                 _key,
115                 _value
116             )
117         );
118 
119         require(success, "error writing storage");
120     }
121 
122     function read(
123         bytes32 _struct,
124         bytes32 _key
125     ) internal view returns (bytes32) {
126         StorageUnit store = StorageUnit(contractSlot(_struct));
127         if (!IsContract.isContract(address(store))) {
128             return bytes32(0);
129         }
130 
131         /* solium-disable-next-line */
132         (bool success, bytes memory data) = address(store).staticcall(
133             abi.encodeWithSelector(
134                 store.read.selector,
135                 _key
136             )
137         );
138 
139         require(success, "error reading storage");
140         return abi.decode(data, (bytes32));
141     }
142 }
143 
144 // File: contracts/utils/SafeMath.sol
145 
146 pragma solidity ^0.5.10;
147 
148 
149 library SafeMath {
150     function add(uint256 x, uint256 y) internal pure returns (uint256) {
151         uint256 z = x + y;
152         require(z >= x, "Add overflow");
153         return z;
154     }
155 
156     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
157         require(x >= y, "Sub underflow");
158         return x - y;
159     }
160 
161     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
162         if (x == 0) {
163             return 0;
164         }
165 
166         uint256 z = x * y;
167         require(z / x == y, "Mult overflow");
168         return z;
169     }
170 
171     function div(uint256 x, uint256 y) internal pure returns (uint256) {
172         require(y != 0, "Div by zero");
173         return x / y;
174     }
175 
176     function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
177         require(y != 0, "Div by zero");
178         uint256 r = x / y;
179         if (x % y != 0) {
180             r = r + 1;
181         }
182 
183         return r;
184     }
185 }
186 
187 // File: contracts/utils/Math.sol
188 
189 pragma solidity ^0.5.10;
190 
191 
192 library Math {
193     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
194         uint256 counter = uint(-1);
195         uint256 temp = input;
196 
197         do {
198             temp /= 10;
199             counter++;
200         } while (temp != 0);
201 
202         return counter;
203     }
204 
205     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
206         if (_a < _b) {
207             return _a;
208         } else {
209             return _b;
210         }
211     }
212 
213     function max(uint256 _a, uint256 _b) internal pure returns (uint256) {
214         if (_a > _b) {
215             return _a;
216         } else {
217             return _b;
218         }
219     }
220 }
221 
222 // File: contracts/utils/GasPump.sol
223 
224 pragma solidity ^0.5.10;
225 
226 
227 contract GasPump {
228     bytes32 private stub;
229 
230     modifier requestGas(uint256 _factor) {
231         if (tx.gasprice == 0 || gasleft() > block.gaslimit) {
232             uint256 startgas = gasleft();
233             _;
234             uint256 delta = startgas - gasleft();
235             uint256 target = (delta * _factor) / 100;
236             startgas = gasleft();
237             while (startgas - gasleft() < target) {
238                 // Burn gas
239                 stub = keccak256(abi.encodePacked(stub));
240             }
241         } else {
242             _;
243         }
244     }
245 }
246 
247 // File: contracts/interfaces/IERC20.sol
248 
249 pragma solidity ^0.5.10;
250 
251 
252 interface IERC20 {
253     event Transfer(address indexed _from, address indexed _to, uint256 _value);
254     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
255     function transfer(address _to, uint _value) external returns (bool success);
256     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
257     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
258     function approve(address _spender, uint256 _value) external returns (bool success);
259     function balanceOf(address _owner) external view returns (uint256 balance);
260 }
261 
262 // File: contracts/commons/AddressMinHeap.sol
263 
264 pragma solidity ^0.5.10;
265 
266 /*
267     @author Agustin Aguilar <agusxrun@gmail.com>
268 */
269 
270 
271 library AddressMinHeap {
272     using AddressMinHeap for AddressMinHeap.Heap;
273 
274     struct Heap {
275         uint256[] entries;
276         mapping(address => uint256) index;
277     }
278 
279     function initialize(Heap storage _heap) internal {
280         require(_heap.entries.length == 0, "already initialized");
281         _heap.entries.push(0);
282     }
283 
284     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
285         /* solium-disable-next-line */
286         assembly {
287             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
288         }
289     }
290 
291     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
292         /* solium-disable-next-line */
293         assembly {
294             let entry := not(_entry)
295             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
296             _value := shr(160, entry)
297         }
298     }
299 
300     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
301         /* solium-disable-next-line */
302         assembly {
303             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
304         }
305     }
306 
307     function top(Heap storage _heap) internal view returns(address, uint256) {
308         if (_heap.entries.length < 2) {
309             return (address(0), 0);
310         }
311 
312         return decode(_heap.entries[1]);
313     }
314 
315     function has(Heap storage _heap, address _addr) internal view returns (bool) {
316         return _heap.index[_addr] != 0;
317     }
318 
319     function size(Heap storage _heap) internal view returns (uint256) {
320         return _heap.entries.length - 1;
321     }
322 
323     function entry(Heap storage _heap, uint256 _i) internal view returns (address, uint256) {
324         return decode(_heap.entries[_i + 1]);
325     }
326 
327     // RemoveMax pops off the root element of the heap (the highest value here) and rebalances the heap
328     function popTop(Heap storage _heap) internal returns(address _addr, uint256 _value) {
329         // Ensure the heap exists
330         uint256 heapLength = _heap.entries.length;
331         require(heapLength > 1, "The heap does not exists");
332 
333         // take the root value of the heap
334         (_addr, _value) = decode(_heap.entries[1]);
335         _heap.index[_addr] = 0;
336 
337         if (heapLength == 2) {
338             _heap.entries.length = 1;
339         } else {
340             // Takes the last element of the array and put it at the root
341             uint256 val = _heap.entries[heapLength - 1];
342             _heap.entries[1] = val;
343 
344             // Delete the last element from the array
345             _heap.entries.length = heapLength - 1;
346 
347             // Start at the top
348             uint256 ind = 1;
349 
350             // Bubble down
351             ind = _heap.bubbleDown(ind, val);
352 
353             // Update index
354             _heap.index[decodeAddress(val)] = ind;
355         }
356     }
357 
358     // Inserts adds in a value to our heap.
359     function insert(Heap storage _heap, address _addr, uint256 _value) internal {
360         require(_heap.index[_addr] == 0, "The entry already exists");
361 
362         // Add the value to the end of our array
363         uint256 encoded = encode(_addr, _value);
364         _heap.entries.push(encoded);
365 
366         // Start at the end of the array
367         uint256 currentIndex = _heap.entries.length - 1;
368 
369         // Bubble Up
370         currentIndex = _heap.bubbleUp(currentIndex, encoded);
371 
372         // Update index
373         _heap.index[_addr] = currentIndex;
374     }
375 
376     function update(Heap storage _heap, address _addr, uint256 _value) internal {
377         uint256 ind = _heap.index[_addr];
378         require(ind != 0, "The entry does not exists");
379 
380         uint256 can = encode(_addr, _value);
381         uint256 val = _heap.entries[ind];
382         uint256 newInd;
383 
384         if (can < val) {
385             // Bubble down
386             newInd = _heap.bubbleDown(ind, can);
387         } else if (can > val) {
388             // Bubble up
389             newInd = _heap.bubbleUp(ind, can);
390         } else {
391             // no changes needed
392             return;
393         }
394 
395         // Update entry
396         _heap.entries[newInd] = can;
397 
398         // Update index
399         if (newInd != ind) {
400             _heap.index[_addr] = newInd;
401         }
402     }
403 
404     function bubbleUp(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
405         // Bubble up
406         ind = _ind;
407         if (ind != 1) {
408             uint256 parent = _heap.entries[ind / 2];
409             while (parent < _val) {
410                 // If the parent value is lower than our current value, we swap them
411                 (_heap.entries[ind / 2], _heap.entries[ind]) = (_val, parent);
412 
413                 // Update moved Index
414                 _heap.index[decodeAddress(parent)] = ind;
415 
416                 // change our current Index to go up to the parent
417                 ind = ind / 2;
418                 if (ind == 1) {
419                     break;
420                 }
421 
422                 // Update parent
423                 parent = _heap.entries[ind / 2];
424             }
425         }
426     }
427 
428     function bubbleDown(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
429         // Bubble down
430         ind = _ind;
431 
432         uint256 lenght = _heap.entries.length;
433         uint256 target = lenght - 1;
434 
435         while (ind * 2 < lenght) {
436             // get the current index of the children
437             uint256 j = ind * 2;
438 
439             // left child value
440             uint256 leftChild = _heap.entries[j];
441 
442             // Store the value of the child
443             uint256 childValue;
444 
445             if (target > j) {
446                 // The parent has two childs 👨‍👧‍👦
447 
448                 // Load right child value
449                 uint256 rightChild = _heap.entries[j + 1];
450 
451                 // Compare the left and right child.
452                 // if the rightChild is greater, then point j to it's index
453                 // and save the value
454                 if (leftChild < rightChild) {
455                     childValue = rightChild;
456                     j = j + 1;
457                 } else {
458                     // The left child is greater
459                     childValue = leftChild;
460                 }
461             } else {
462                 // The parent has a single child 👨‍👦
463                 childValue = leftChild;
464             }
465 
466             // Check if the child has a lower value
467             if (_val > childValue) {
468                 break;
469             }
470 
471             // else swap the value
472             (_heap.entries[ind], _heap.entries[j]) = (childValue, _val);
473 
474             // Update moved Index
475             _heap.index[decodeAddress(childValue)] = ind;
476 
477             // and let's keep going down the heap
478             ind = j;
479         }
480     }
481 }
482 
483 // File: contracts/Heap.sol
484 
485 pragma solidity ^0.5.10;
486 
487 
488 
489 contract Heap is Ownable {
490     using AddressMinHeap for AddressMinHeap.Heap;
491 
492     // heap
493     AddressMinHeap.Heap private heap;
494 
495     // Heap events
496     event JoinHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
497     event LeaveHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
498 
499     uint256 public constant TOP_SIZE = 512;
500 
501     constructor() public {
502         heap.initialize();
503     }
504 
505     function topSize() external pure returns (uint256) {
506         return TOP_SIZE;
507     }
508 
509     function addressAt(uint256 _i) external view returns (address addr) {
510         (addr, ) = heap.entry(_i);
511     }
512 
513     function indexOf(address _addr) external view returns (uint256) {
514         return heap.index[_addr];
515     }
516 
517     function entry(uint256 _i) external view returns (address, uint256) {
518         return heap.entry(_i);
519     }
520 
521     function top() external view returns (address, uint256) {
522         return heap.top();
523     }
524 
525     function size() external view returns (uint256) {
526         return heap.size();
527     }
528 
529     function update(address _addr, uint256 _new) external onlyOwner {
530         uint256 _size = heap.size();
531 
532         // If the heap is empty
533         // join the _addr
534         if (_size == 0) {
535             emit JoinHeap(_addr, _new, 0);
536             heap.insert(_addr, _new);
537             return;
538         }
539 
540         // Load top value of the heap
541         (, uint256 lastBal) = heap.top();
542 
543         // If our target address already is in the heap
544         if (heap.has(_addr)) {
545             // Update the target address value
546             heap.update(_addr, _new);
547             // If the new value is 0
548             // always pop the heap
549             // we updated the heap, so our address should be on top
550             if (_new == 0) {
551                 heap.popTop();
552                 emit LeaveHeap(_addr, 0, _size);
553             }
554         } else {
555             // IF heap is full or new balance is higher than pop heap
556             if (_new != 0 && (_size < TOP_SIZE || lastBal < _new)) {
557                 // If heap is full pop heap
558                 if (_size >= TOP_SIZE) {
559                     (address _poped, uint256 _balance) = heap.popTop();
560                     emit LeaveHeap(_poped, _balance, _size);
561                 }
562 
563                 // Insert new value
564                 heap.insert(_addr, _new);
565                 emit JoinHeap(_addr, _new, _size);
566             }
567         }
568     }
569 }
570 
571 // File: contracts/AshToken.sol
572 
573 pragma solidity ^0.5.10;
574 
575 
576 
577 
578 
579 
580 
581 
582 contract AshToken is Ownable, GasPump, IERC20 {
583     using DistributedStorage for bytes32;
584     using SafeMath for uint256;
585 
586     // Ash events
587     event Winner(address indexed _addr, uint256 _value);
588 
589     // Managment events
590     event SetName(string _prev, string _new);
591     event SetExtraGas(uint256 _prev, uint256 _new);
592     event SetHeap(address _prev, address _new);
593     event WhitelistFrom(address _addr, bool _whitelisted);
594     event WhitelistTo(address _addr, bool _whitelisted);
595 
596     uint256 public totalSupply;
597 
598     bytes32 private constant BALANCE_KEY = keccak256("balance");
599 
600     // game
601     uint256 public constant FEE = 100;
602 
603     // metadata
604     string public name = "Ash";
605     string public constant symbol = "ASH";
606     uint8 public constant decimals = 18;
607 
608     string public about = "This token is based on the original work of Shuffle Monster token https://shuffle.monster/ (0x3A9FfF453d50D4Ac52A6890647b823379ba36B9E)";
609 
610     // fee whitelist
611     mapping(address => bool) public whitelistFrom;
612     mapping(address => bool) public whitelistTo;
613 
614     // heap
615     Heap public heap;
616 
617     // internal
618     uint256 public extraGas;
619     bool inited;
620 
621     function init(
622         address[] calldata _addrs,
623         uint256[] calldata _amounts
624     ) external {
625         // Only init once
626         assert(!inited);
627         inited = true;
628 
629         // Sanity checks
630         assert(totalSupply == 0);
631         assert(address(heap) == address(0));
632 
633         // Create Heap
634         heap = new Heap();
635         emit SetHeap(address(0), address(heap));
636 
637         // Init contract variables and mint
638         // entire token balance
639         extraGas = 15;
640         emit SetExtraGas(0, extraGas);
641         
642         // Emit initial supply
643         assert(_addrs.length == _amounts.length);
644         for (uint256 i = 0; i < _addrs.length; i++) {
645             address _to = _addrs[i];
646             uint256 _amount = _amounts[i];
647             emit Transfer(address(0), _to, _amount);
648             _setBalance(_to, _amount);
649             totalSupply = totalSupply.add(_amount);
650         }
651     }
652 
653     ///
654     // Storage access functions
655     ///
656 
657     // Getters
658 
659     function _toKey(address a) internal pure returns (bytes32) {
660         return bytes32(uint256(a));
661     }
662 
663     function _balanceOf(address _addr) internal view returns (uint256) {
664         return uint256(_toKey(_addr).read(BALANCE_KEY));
665     }
666 
667     function _allowance(address _addr, address _spender) internal view returns (uint256) {
668         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
669     }
670 
671     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
672         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
673     }
674 
675     // Setters
676 
677     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
678         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
679     }
680 
681     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
682         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
683     }
684 
685     function _setBalance(address _addr, uint256 _balance) internal {
686         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
687         heap.update(_addr, _balance);
688     }
689 
690     ///
691     // Internal methods
692     ///
693 
694     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
695         return whitelistFrom[_from]||whitelistTo[_to];
696     }
697 
698     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
699         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
700         return rand % (_max + 1);
701     }
702 
703     function _pickWinner(address _from, uint256 _value) internal returns (address winner) {
704         // Get order of magnitude of the tx
705         uint256 magnitude = Math.orderOfMagnitude(_value);
706         // Pull nonce for a given order of magnitude
707         uint256 nonce = _nonce(_from, magnitude);
708         _setNonce(_from, magnitude, nonce + 1);
709         // pick entry from heap
710         winner = heap.addressAt(_random(_from, nonce, magnitude, heap.size() - 1));
711     }
712 
713     function _transferFrom(address _operator, address _from, address _to, uint256 _value, bool _payFee) internal {
714         // If transfer amount is zero
715         // emit event and stop execution
716         if (_value == 0) {
717             emit Transfer(_from, _to, 0);
718             return;
719         }
720 
721         // Load sender balance
722         uint256 balanceFrom = _balanceOf(_from);
723         require(balanceFrom >= _value, "balance not enough");
724 
725         // Check if operator is sender
726         if (_from != _operator) {
727             // If not, validate allowance
728             uint256 allowanceFrom = _allowance(_from, _operator);
729             // If allowance is not 2 ** 256 - 1, consume allowance
730             if (allowanceFrom != uint(-1)) {
731                 // Check allowance and save new one
732                 require(allowanceFrom >= _value, "allowance not enough");
733                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
734             }
735         }
736 
737         // Calculate receiver balance
738         // initial receive is full value
739         uint256 receive = _value;
740         uint256 burn = 0;
741         uint256 shuf = 0;
742 
743         // Change sender balance
744         _setBalance(_from, balanceFrom.sub(_value));
745 
746         // If the transaction is not whitelisted
747         // or if sender requested to pay the fee
748         // calculate fees
749         if (_payFee || !_isWhitelisted(_from, _to)) {
750             // Fee is the same for BURN and SHUF
751             // If we are sending value one
752             // give priority to BURN
753             burn = _value.divRound(FEE);
754             shuf = _value == 1 ? 0 : burn;
755 
756             // Subtract fees from receiver amount
757             receive = receive.sub(burn.add(shuf));
758 
759             // Burn tokens
760             totalSupply = totalSupply.sub(burn);
761             emit Transfer(_from, address(0), burn);
762 
763             // Ash tokens
764             // Pick winner pseudo-randomly
765             address winner = _pickWinner(_from, _value);
766             // Transfer balance to winner
767             _setBalance(winner, _balanceOf(winner).add(shuf));
768             emit Winner(winner, shuf);
769             emit Transfer(_from, winner, shuf);
770         }
771 
772         // Sanity checks
773         // no tokens where created
774         assert(burn.add(shuf).add(receive) == _value);
775 
776         // Add tokens to receiver
777         _setBalance(_to, _balanceOf(_to).add(receive));
778         emit Transfer(_from, _to, receive);
779     }
780 
781     ///
782     // Managment
783     ///
784 
785     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
786         emit WhitelistTo(_addr, _whitelisted);
787         whitelistTo[_addr] = _whitelisted;
788     }
789 
790     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
791         emit WhitelistFrom(_addr, _whitelisted);
792         whitelistFrom[_addr] = _whitelisted;
793     }
794 
795     function setName(string calldata _name) external onlyOwner {
796         emit SetName(name, _name);
797         name = _name;
798     }
799 
800     function setExtraGas(uint256 _gas) external onlyOwner {
801         emit SetExtraGas(extraGas, _gas);
802         extraGas = _gas;
803     }
804 
805     function setHeap(Heap _heap) external onlyOwner {
806         emit SetHeap(address(heap), address(_heap));
807         heap = _heap;
808     }
809 
810     /////
811     // Heap methods
812     /////
813 
814     function topSize() external view returns (uint256) {
815         return heap.topSize();
816     }
817 
818     function heapSize() external view returns (uint256) {
819         return heap.size();
820     }
821 
822     function heapEntry(uint256 _i) external view returns (address, uint256) {
823         return heap.entry(_i);
824     }
825 
826     function heapTop() external view returns (address, uint256) {
827         return heap.top();
828     }
829 
830     function heapIndex(address _addr) external view returns (uint256) {
831         return heap.indexOf(_addr);
832     }
833 
834     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
835         return _nonce(_addr, _cat);
836     }
837 
838     /////
839     // ERC20
840     /////
841 
842     function balanceOf(address _addr) external view returns (uint256) {
843         return _balanceOf(_addr);
844     }
845 
846     function allowance(address _addr, address _spender) external view returns (uint256) {
847         return _allowance(_addr, _spender);
848     }
849 
850     function approve(address _spender, uint256 _value) external returns (bool) {
851         emit Approval(msg.sender, _spender, _value);
852         _setAllowance(msg.sender, _spender, _value);
853         return true;
854     }
855 
856     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
857         _transferFrom(msg.sender, msg.sender, _to, _value, false);
858         return true;
859     }
860 
861     function transferWithFee(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
862         _transferFrom(msg.sender, msg.sender, _to, _value, true);
863         return true;
864     }
865 
866     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
867         _transferFrom(msg.sender, _from, _to, _value, false);
868         return true;
869     }
870 
871     function transferFromWithFee(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
872         _transferFrom(msg.sender, _from, _to, _value, true);
873         return true;
874     }
875 }