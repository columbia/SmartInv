1 /**
2     This AMGO token is based on the original work of Shuffle Monster token https://shuffle.monster/ (0x3A9FfF453d50D4Ac52A6890647b823379ba36B9E)
3 */
4 
5 pragma solidity ^0.5.10;
6 
7 // File: contracts/commons/Ownable.sol
8 
9 
10 contract Ownable {
11     address public owner;
12 
13     event TransferOwnership(address _from, address _to);
14 
15     constructor() public {
16         owner = msg.sender;
17         emit TransferOwnership(address(0), msg.sender);
18     }
19 
20     modifier onlyOwner() {
21         require(msg.sender == owner, "only owner");
22         _;
23     }
24 
25     function setOwner(address _owner) external onlyOwner {
26         emit TransferOwnership(owner, _owner);
27         owner = _owner;
28     }
29 }
30 
31 // File: contracts/commons/StorageUnit.sol
32 
33 pragma solidity ^0.5.10;
34 
35 
36 contract StorageUnit {
37     address private owner;
38     mapping(bytes32 => bytes32) private store;
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     function write(bytes32 _key, bytes32 _value) external {
45         /* solium-disable-next-line */
46         require(msg.sender == owner);
47         store[_key] = _value;
48     }
49 
50     function read(bytes32 _key) external view returns (bytes32) {
51         return store[_key];
52     }
53 }
54 
55 // File: contracts/utils/IsContract.sol
56 
57 pragma solidity ^0.5.10;
58 
59 
60 library IsContract {
61     function isContract(address _addr) internal view returns (bool) {
62         bytes32 codehash;
63         /* solium-disable-next-line */
64         assembly { codehash := extcodehash(_addr) }
65         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
66     }
67 }
68 
69 // File: contracts/utils/DistributedStorage.sol
70 
71 pragma solidity ^0.5.10;
72 
73 
74 
75 
76 library DistributedStorage {
77     function contractSlot(bytes32 _struct) private view returns (address) {
78         return address(
79             uint256(
80                 keccak256(
81                     abi.encodePacked(
82                         byte(0xff),
83                         address(this),
84                         _struct,
85                         keccak256(type(StorageUnit).creationCode)
86                     )
87                 )
88             )
89         );
90     }
91 
92     function deploy(bytes32 _struct) private {
93         bytes memory slotcode = type(StorageUnit).creationCode;
94         /* solium-disable-next-line */
95         assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }
96     }
97 
98     function write(
99         bytes32 _struct,
100         bytes32 _key,
101         bytes32 _value
102     ) internal {
103         StorageUnit store = StorageUnit(contractSlot(_struct));
104         if (!IsContract.isContract(address(store))) {
105             deploy(_struct);
106         }
107 
108         /* solium-disable-next-line */
109         (bool success, ) = address(store).call(
110             abi.encodeWithSelector(
111                 store.write.selector,
112                 _key,
113                 _value
114             )
115         );
116 
117         require(success, "error writing storage");
118     }
119 
120     function read(
121         bytes32 _struct,
122         bytes32 _key
123     ) internal view returns (bytes32) {
124         StorageUnit store = StorageUnit(contractSlot(_struct));
125         if (!IsContract.isContract(address(store))) {
126             return bytes32(0);
127         }
128 
129         /* solium-disable-next-line */
130         (bool success, bytes memory data) = address(store).staticcall(
131             abi.encodeWithSelector(
132                 store.read.selector,
133                 _key
134             )
135         );
136 
137         require(success, "error reading storage");
138         return abi.decode(data, (bytes32));
139     }
140 }
141 
142 // File: contracts/utils/SafeMath.sol
143 
144 pragma solidity ^0.5.10;
145 
146 
147 library SafeMath {
148     function add(uint256 x, uint256 y) internal pure returns (uint256) {
149         uint256 z = x + y;
150         require(z >= x, "Add overflow");
151         return z;
152     }
153 
154     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
155         require(x >= y, "Sub underflow");
156         return x - y;
157     }
158 
159     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
160         if (x == 0) {
161             return 0;
162         }
163 
164         uint256 z = x * y;
165         require(z / x == y, "Mult overflow");
166         return z;
167     }
168 
169     function div(uint256 x, uint256 y) internal pure returns (uint256) {
170         require(y != 0, "Div by zero");
171         return x / y;
172     }
173 
174     function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
175         require(y != 0, "Div by zero");
176         uint256 r = x / y;
177         if (x % y != 0) {
178             r = r + 1;
179         }
180 
181         return r;
182     }
183 }
184 
185 // File: contracts/utils/Math.sol
186 
187 pragma solidity ^0.5.10;
188 
189 
190 library Math {
191     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
192         uint256 counter = uint(-1);
193         uint256 temp = input;
194 
195         do {
196             temp /= 10;
197             counter++;
198         } while (temp != 0);
199 
200         return counter;
201     }
202 
203     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
204         if (_a < _b) {
205             return _a;
206         } else {
207             return _b;
208         }
209     }
210 
211     function max(uint256 _a, uint256 _b) internal pure returns (uint256) {
212         if (_a > _b) {
213             return _a;
214         } else {
215             return _b;
216         }
217     }
218 }
219 
220 // File: contracts/utils/GasPump.sol
221 
222 pragma solidity ^0.5.10;
223 
224 
225 contract GasPump {
226     bytes32 private stub;
227 
228     modifier requestGas(uint256 _factor) {
229         if (tx.gasprice == 0 || gasleft() > block.gaslimit) {
230             uint256 startgas = gasleft();
231             _;
232             uint256 delta = startgas - gasleft();
233             uint256 target = (delta * _factor) / 100;
234             startgas = gasleft();
235             while (startgas - gasleft() < target) {
236                 // Burn gas
237                 stub = keccak256(abi.encodePacked(stub));
238             }
239         } else {
240             _;
241         }
242     }
243 }
244 
245 // File: contracts/interfaces/IERC20.sol
246 
247 pragma solidity ^0.5.10;
248 
249 
250 interface IERC20 {
251     event Transfer(address indexed _from, address indexed _to, uint256 _value);
252     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
253     function transfer(address _to, uint _value) external returns (bool success);
254     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
255     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
256     function approve(address _spender, uint256 _value) external returns (bool success);
257     function balanceOf(address _owner) external view returns (uint256 balance);
258 }
259 
260 // File: contracts/commons/AddressMinHeap.sol
261 
262 pragma solidity ^0.5.10;
263 
264 /*
265     @author Agustin Aguilar <agusxrun@gmail.com>
266 */
267 
268 
269 library AddressMinHeap {
270     using AddressMinHeap for AddressMinHeap.Heap;
271 
272     struct Heap {
273         uint256[] entries;
274         mapping(address => uint256) index;
275     }
276 
277     function initialize(Heap storage _heap) internal {
278         require(_heap.entries.length == 0, "already initialized");
279         _heap.entries.push(0);
280     }
281 
282     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
283         /* solium-disable-next-line */
284         assembly {
285             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
286         }
287     }
288 
289     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
290         /* solium-disable-next-line */
291         assembly {
292             let entry := not(_entry)
293             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
294             _value := shr(160, entry)
295         }
296     }
297 
298     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
299         /* solium-disable-next-line */
300         assembly {
301             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
302         }
303     }
304 
305     function top(Heap storage _heap) internal view returns(address, uint256) {
306         if (_heap.entries.length < 2) {
307             return (address(0), 0);
308         }
309 
310         return decode(_heap.entries[1]);
311     }
312 
313     function has(Heap storage _heap, address _addr) internal view returns (bool) {
314         return _heap.index[_addr] != 0;
315     }
316 
317     function size(Heap storage _heap) internal view returns (uint256) {
318         return _heap.entries.length - 1;
319     }
320 
321     function entry(Heap storage _heap, uint256 _i) internal view returns (address, uint256) {
322         return decode(_heap.entries[_i + 1]);
323     }
324 
325     // RemoveMax pops off the root element of the heap (the highest value here) and rebalances the heap
326     function popTop(Heap storage _heap) internal returns(address _addr, uint256 _value) {
327         // Ensure the heap exists
328         uint256 heapLength = _heap.entries.length;
329         require(heapLength > 1, "The heap does not exists");
330 
331         // take the root value of the heap
332         (_addr, _value) = decode(_heap.entries[1]);
333         _heap.index[_addr] = 0;
334 
335         if (heapLength == 2) {
336             _heap.entries.length = 1;
337         } else {
338             // Takes the last element of the array and put it at the root
339             uint256 val = _heap.entries[heapLength - 1];
340             _heap.entries[1] = val;
341 
342             // Delete the last element from the array
343             _heap.entries.length = heapLength - 1;
344 
345             // Start at the top
346             uint256 ind = 1;
347 
348             // Bubble down
349             ind = _heap.bubbleDown(ind, val);
350 
351             // Update index
352             _heap.index[decodeAddress(val)] = ind;
353         }
354     }
355 
356     // Inserts adds in a value to our heap.
357     function insert(Heap storage _heap, address _addr, uint256 _value) internal {
358         require(_heap.index[_addr] == 0, "The entry already exists");
359 
360         // Add the value to the end of our array
361         uint256 encoded = encode(_addr, _value);
362         _heap.entries.push(encoded);
363 
364         // Start at the end of the array
365         uint256 currentIndex = _heap.entries.length - 1;
366 
367         // Bubble Up
368         currentIndex = _heap.bubbleUp(currentIndex, encoded);
369 
370         // Update index
371         _heap.index[_addr] = currentIndex;
372     }
373 
374     function update(Heap storage _heap, address _addr, uint256 _value) internal {
375         uint256 ind = _heap.index[_addr];
376         require(ind != 0, "The entry does not exists");
377 
378         uint256 can = encode(_addr, _value);
379         uint256 val = _heap.entries[ind];
380         uint256 newInd;
381 
382         if (can < val) {
383             // Bubble down
384             newInd = _heap.bubbleDown(ind, can);
385         } else if (can > val) {
386             // Bubble up
387             newInd = _heap.bubbleUp(ind, can);
388         } else {
389             // no changes needed
390             return;
391         }
392 
393         // Update entry
394         _heap.entries[newInd] = can;
395 
396         // Update index
397         if (newInd != ind) {
398             _heap.index[_addr] = newInd;
399         }
400     }
401 
402     function bubbleUp(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
403         // Bubble up
404         ind = _ind;
405         if (ind != 1) {
406             uint256 parent = _heap.entries[ind / 2];
407             while (parent < _val) {
408                 // If the parent value is lower than our current value, we swap them
409                 (_heap.entries[ind / 2], _heap.entries[ind]) = (_val, parent);
410 
411                 // Update moved Index
412                 _heap.index[decodeAddress(parent)] = ind;
413 
414                 // change our current Index to go up to the parent
415                 ind = ind / 2;
416                 if (ind == 1) {
417                     break;
418                 }
419 
420                 // Update parent
421                 parent = _heap.entries[ind / 2];
422             }
423         }
424     }
425 
426     function bubbleDown(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
427         // Bubble down
428         ind = _ind;
429 
430         uint256 lenght = _heap.entries.length;
431         uint256 target = lenght - 1;
432 
433         while (ind * 2 < lenght) {
434             // get the current index of the children
435             uint256 j = ind * 2;
436 
437             // left child value
438             uint256 leftChild = _heap.entries[j];
439 
440             // Store the value of the child
441             uint256 childValue;
442 
443             if (target > j) {
444                 // The parent has two childs 👨‍👧‍👦
445 
446                 // Load right child value
447                 uint256 rightChild = _heap.entries[j + 1];
448 
449                 // Compare the left and right child.
450                 // if the rightChild is greater, then point j to it's index
451                 // and save the value
452                 if (leftChild < rightChild) {
453                     childValue = rightChild;
454                     j = j + 1;
455                 } else {
456                     // The left child is greater
457                     childValue = leftChild;
458                 }
459             } else {
460                 // The parent has a single child 👨‍👦
461                 childValue = leftChild;
462             }
463 
464             // Check if the child has a lower value
465             if (_val > childValue) {
466                 break;
467             }
468 
469             // else swap the value
470             (_heap.entries[ind], _heap.entries[j]) = (childValue, _val);
471 
472             // Update moved Index
473             _heap.index[decodeAddress(childValue)] = ind;
474 
475             // and let's keep going down the heap
476             ind = j;
477         }
478     }
479 }
480 
481 // File: contracts/Heap.sol
482 
483 pragma solidity ^0.5.10;
484 
485 
486 
487 contract Heap is Ownable {
488     using AddressMinHeap for AddressMinHeap.Heap;
489 
490     // heap
491     AddressMinHeap.Heap private heap;
492 
493     // Heap events
494     event JoinHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
495     event LeaveHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
496 
497     uint256 public constant TOP_SIZE = 212;
498 
499     constructor() public {
500         heap.initialize();
501     }
502 
503     function topSize() external pure returns (uint256) {
504         return TOP_SIZE;
505     }
506 
507     function addressAt(uint256 _i) external view returns (address addr) {
508         (addr, ) = heap.entry(_i);
509     }
510 
511     function indexOf(address _addr) external view returns (uint256) {
512         return heap.index[_addr];
513     }
514 
515     function entry(uint256 _i) external view returns (address, uint256) {
516         return heap.entry(_i);
517     }
518 
519     function top() external view returns (address, uint256) {
520         return heap.top();
521     }
522 
523     function size() external view returns (uint256) {
524         return heap.size();
525     }
526 
527     function update(address _addr, uint256 _new) external onlyOwner {
528         uint256 _size = heap.size();
529 
530         // If the heap is empty
531         // join the _addr
532         if (_size == 0) {
533             emit JoinHeap(_addr, _new, 0);
534             heap.insert(_addr, _new);
535             return;
536         }
537 
538         // Load top value of the heap
539         (, uint256 lastBal) = heap.top();
540 
541         // If our target address already is in the heap
542         if (heap.has(_addr)) {
543             // Update the target address value
544             heap.update(_addr, _new);
545             // If the new value is 0
546             // always pop the heap
547             // we updated the heap, so our address should be on top
548             if (_new == 0) {
549                 heap.popTop();
550                 emit LeaveHeap(_addr, 0, _size);
551             }
552         } else {
553             // IF heap is full or new balance is higher than pop heap
554             if (_new != 0 && (_size < TOP_SIZE || lastBal < _new)) {
555                 // If heap is full pop heap
556                 if (_size >= TOP_SIZE) {
557                     (address _poped, uint256 _balance) = heap.popTop();
558                     emit LeaveHeap(_poped, _balance, _size);
559                 }
560 
561                 // Insert new value
562                 heap.insert(_addr, _new);
563                 emit JoinHeap(_addr, _new, _size);
564             }
565         }
566     }
567 }
568 
569 // File: contracts/AMGOToken.sol
570 
571 pragma solidity ^0.5.10;
572 
573 
574 
575 
576 
577 
578 
579 
580 contract AMGOToken is Ownable, GasPump, IERC20 {
581     using DistributedStorage for bytes32;
582     using SafeMath for uint256;
583 
584     // AMGO events
585     event Winner(address indexed _addr, uint256 _value);
586 
587     // Managment events
588     event SetName(string _prev, string _new);
589     event SetExtraGas(uint256 _prev, uint256 _new);
590     event SetHeap(address _prev, address _new);
591     event WhitelistFrom(address _addr, bool _whitelisted);
592     event WhitelistTo(address _addr, bool _whitelisted);
593 
594     uint256 public totalSupply;
595 
596     bytes32 private constant BALANCE_KEY = keccak256("balance");
597 
598     // game
599     uint256 public constant FEE = 100;
600 
601     // metadata
602     string public name = "AMGO - Arena Match Gold";
603     string public constant symbol = "AMGO";
604     uint8 public constant decimals = 18;
605 
606     string public about = "AMGO token is based on the original work of Shuffle Monster token https://shuffle.monster/ (0x3A9FfF453d50D4Ac52A6890647b823379ba36B9E)";
607 
608     // fee whitelist
609     mapping(address => bool) public whitelistFrom;
610     mapping(address => bool) public whitelistTo;
611 
612     // heap
613     Heap public heap;
614 
615     // internal
616     uint256 public extraGas;
617     bool inited;
618 
619     function init(
620         address[] calldata _addrs,
621         uint256[] calldata _amounts
622     ) external {
623         // Only init once
624         assert(!inited);
625         inited = true;
626 
627         // Sanity checks
628         assert(totalSupply == 0);
629         assert(address(heap) == address(0));
630 
631         // Create Heap
632         heap = new Heap();
633         emit SetHeap(address(0), address(heap));
634 
635         // Init contract variables and mint
636         // entire token balance
637         extraGas = 15;
638         emit SetExtraGas(0, extraGas);
639         
640         // Emit initial supply
641         assert(_addrs.length == _amounts.length);
642         for (uint256 i = 0; i < _addrs.length; i++) {
643             address _to = _addrs[i];
644             uint256 _amount = _amounts[i];
645             emit Transfer(address(0), _to, _amount);
646             _setBalance(_to, _amount);
647             totalSupply = totalSupply.add(_amount);
648         }
649     }
650 
651     ///
652     // Storage access functions
653     ///
654 
655     // Getters
656 
657     function _toKey(address a) internal pure returns (bytes32) {
658         return bytes32(uint256(a));
659     }
660 
661     function _balanceOf(address _addr) internal view returns (uint256) {
662         return uint256(_toKey(_addr).read(BALANCE_KEY));
663     }
664 
665     function _allowance(address _addr, address _spender) internal view returns (uint256) {
666         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
667     }
668 
669     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
670         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
671     }
672 
673     // Setters
674 
675     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
676         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
677     }
678 
679     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
680         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
681     }
682 
683     function _setBalance(address _addr, uint256 _balance) internal {
684         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
685         heap.update(_addr, _balance);
686     }
687 
688     ///
689     // Internal methods
690     ///
691 
692     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
693         return whitelistFrom[_from]||whitelistTo[_to];
694     }
695 
696     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
697         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
698         return rand % (_max + 1);
699     }
700 
701     function _pickWinner(address _from, uint256 _value) internal returns (address winner) {
702         // Get order of magnitude of the tx
703         uint256 magnitude = Math.orderOfMagnitude(_value);
704         // Pull nonce for a given order of magnitude
705         uint256 nonce = _nonce(_from, magnitude);
706         _setNonce(_from, magnitude, nonce + 1);
707         // pick entry from heap
708         winner = heap.addressAt(_random(_from, nonce, magnitude, heap.size() - 1));
709     }
710 
711     function _transferFrom(address _operator, address _from, address _to, uint256 _value, bool _payFee) internal {
712         // If transfer amount is zero
713         // emit event and stop execution
714         if (_value == 0) {
715             emit Transfer(_from, _to, 0);
716             return;
717         }
718 
719         // Load sender balance
720         uint256 balanceFrom = _balanceOf(_from);
721         require(balanceFrom >= _value, "balance not enough");
722 
723         // Check if operator is sender
724         if (_from != _operator) {
725             // If not, validate allowance
726             uint256 allowanceFrom = _allowance(_from, _operator);
727             // If allowance is not 2 ** 256 - 1, consume allowance
728             if (allowanceFrom != uint(-1)) {
729                 // Check allowance and save new one
730                 require(allowanceFrom >= _value, "allowance not enough");
731                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
732             }
733         }
734 
735         // Calculate receiver balance
736         // initial receive is full value
737         uint256 receive = _value;
738         uint256 burn = 0;
739         uint256 shuf = 0;
740 
741         // Change sender balance
742         _setBalance(_from, balanceFrom.sub(_value));
743 
744         // If the transaction is not whitelisted
745         // or if sender requested to pay the fee
746         // calculate fees
747         if (_payFee || !_isWhitelisted(_from, _to)) {
748             // Fee is the same for BURN and SHUF
749             // If we are sending value one
750             // give priority to BURN
751             burn = _value.divRound(FEE);
752             shuf = _value == 1 ? 0 : burn;
753 
754             // Subtract fees from receiver amount
755             receive = receive.sub(burn.add(shuf));
756 
757             // Burn tokens
758             totalSupply = totalSupply.sub(burn);
759             emit Transfer(_from, address(0), burn);
760 
761             // TTTT tokens
762             // Pick winner pseudo-randomly
763             address winner = _pickWinner(_from, _value);
764             // Transfer balance to winner
765             _setBalance(winner, _balanceOf(winner).add(shuf));
766             emit Winner(winner, shuf);
767             emit Transfer(_from, winner, shuf);
768         }
769 
770         // Sanity checks
771         // no tokens where created
772         assert(burn.add(shuf).add(receive) == _value);
773 
774         // Add tokens to receiver
775         _setBalance(_to, _balanceOf(_to).add(receive));
776         emit Transfer(_from, _to, receive);
777     }
778 
779     ///
780     // Managment
781     ///
782 
783     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
784         emit WhitelistTo(_addr, _whitelisted);
785         whitelistTo[_addr] = _whitelisted;
786     }
787 
788     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
789         emit WhitelistFrom(_addr, _whitelisted);
790         whitelistFrom[_addr] = _whitelisted;
791     }
792 
793     function setName(string calldata _name) external onlyOwner {
794         emit SetName(name, _name);
795         name = _name;
796     }
797 
798     function setExtraGas(uint256 _gas) external onlyOwner {
799         emit SetExtraGas(extraGas, _gas);
800         extraGas = _gas;
801     }
802 
803     function setHeap(Heap _heap) external onlyOwner {
804         emit SetHeap(address(heap), address(_heap));
805         heap = _heap;
806     }
807 
808     /////
809     // Heap methods
810     /////
811 
812     function topSize() external view returns (uint256) {
813         return heap.topSize();
814     }
815 
816     function heapSize() external view returns (uint256) {
817         return heap.size();
818     }
819 
820     function heapEntry(uint256 _i) external view returns (address, uint256) {
821         return heap.entry(_i);
822     }
823 
824     function heapTop() external view returns (address, uint256) {
825         return heap.top();
826     }
827 
828     function heapIndex(address _addr) external view returns (uint256) {
829         return heap.indexOf(_addr);
830     }
831 
832     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
833         return _nonce(_addr, _cat);
834     }
835 
836     /////
837     // ERC20
838     /////
839 
840     function balanceOf(address _addr) external view returns (uint256) {
841         return _balanceOf(_addr);
842     }
843 
844     function allowance(address _addr, address _spender) external view returns (uint256) {
845         return _allowance(_addr, _spender);
846     }
847 
848     function approve(address _spender, uint256 _value) external returns (bool) {
849         emit Approval(msg.sender, _spender, _value);
850         _setAllowance(msg.sender, _spender, _value);
851         return true;
852     }
853 
854     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
855         _transferFrom(msg.sender, msg.sender, _to, _value, false);
856         return true;
857     }
858 
859     function transferWithFee(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
860         _transferFrom(msg.sender, msg.sender, _to, _value, true);
861         return true;
862     }
863 
864     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
865         _transferFrom(msg.sender, _from, _to, _value, false);
866         return true;
867     }
868 
869     function transferFromWithFee(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
870         _transferFrom(msg.sender, _from, _to, _value, true);
871         return true;
872     }
873 }