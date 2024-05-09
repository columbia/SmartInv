1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-21
3 */
4 
5 // File: contracts/commons/Ownable.sol
6 
7 pragma solidity ^0.5.10;
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
31 // File: contracts/commons/AddressMinHeap.sol
32 
33 pragma solidity ^0.5.10;
34 
35 /*
36     @author Agustin Aguilar <agusxrun@gmail.com>
37 */
38 
39 
40 library AddressMinHeap {
41     using AddressMinHeap for AddressMinHeap.Heap;
42 
43     struct Heap {
44         uint256[] entries;
45         mapping(address => uint256) index;
46     }
47 
48     function initialize(Heap storage _heap) internal {
49         require(_heap.entries.length == 0, "already initialized");
50         _heap.entries.push(0);
51     }
52 
53     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
54         /* solium-disable-next-line */
55         assembly {
56             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
57         }
58     }
59 
60     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
61         /* solium-disable-next-line */
62         assembly {
63             let entry := not(_entry)
64             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
65             _value := shr(160, entry)
66         }
67     }
68 
69     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
70         /* solium-disable-next-line */
71         assembly {
72             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
73         }
74     }
75 
76     function top(Heap storage _heap) internal view returns(address, uint256) {
77         if (_heap.entries.length < 2) {
78             return (address(0), 0);
79         }
80 
81         return decode(_heap.entries[1]);
82     }
83 
84     function has(Heap storage _heap, address _addr) internal view returns (bool) {
85         return _heap.index[_addr] != 0;
86     }
87 
88     function size(Heap storage _heap) internal view returns (uint256) {
89         return _heap.entries.length - 1;
90     }
91 
92     function entry(Heap storage _heap, uint256 _i) internal view returns (address, uint256) {
93         return decode(_heap.entries[_i + 1]);
94     }
95 
96     // RemoveMax pops off the root element of the heap (the highest value here) and rebalances the heap
97     function popTop(Heap storage _heap) internal returns(address _addr, uint256 _value) {
98         // Ensure the heap exists
99         uint256 heapLength = _heap.entries.length;
100         require(heapLength > 1, "The heap does not exists");
101 
102         // take the root value of the heap
103         (_addr, _value) = decode(_heap.entries[1]);
104         _heap.index[_addr] = 0;
105 
106         if (heapLength == 2) {
107             _heap.entries.length = 1;
108         } else {
109             // Takes the last element of the array and put it at the root
110             uint256 val = _heap.entries[heapLength - 1];
111             _heap.entries[1] = val;
112 
113             // Delete the last element from the array
114             _heap.entries.length = heapLength - 1;
115 
116             // Start at the top
117             uint256 ind = 1;
118 
119             // Bubble down
120             ind = _heap.bubbleDown(ind, val);
121 
122             // Update index
123             _heap.index[decodeAddress(val)] = ind;
124         }
125     }
126 
127     // Inserts adds in a value to our heap.
128     function insert(Heap storage _heap, address _addr, uint256 _value) internal {
129         require(_heap.index[_addr] == 0, "The entry already exists");
130 
131         // Add the value to the end of our array
132         uint256 encoded = encode(_addr, _value);
133         _heap.entries.push(encoded);
134 
135         // Start at the end of the array
136         uint256 currentIndex = _heap.entries.length - 1;
137 
138         // Bubble Up
139         currentIndex = _heap.bubbleUp(currentIndex, encoded);
140 
141         // Update index
142         _heap.index[_addr] = currentIndex;
143     }
144 
145     function update(Heap storage _heap, address _addr, uint256 _value) internal {
146         uint256 ind = _heap.index[_addr];
147         require(ind != 0, "The entry does not exists");
148 
149         uint256 can = encode(_addr, _value);
150         uint256 val = _heap.entries[ind];
151         uint256 newInd;
152 
153         if (can < val) {
154             // Bubble down
155             newInd = _heap.bubbleDown(ind, can);
156         } else if (can > val) {
157             // Bubble up
158             newInd = _heap.bubbleUp(ind, can);
159         } else {
160             // no changes needed
161             return;
162         }
163 
164         // Update entry
165         _heap.entries[newInd] = can;
166 
167         // Update index
168         if (newInd != ind) {
169             _heap.index[_addr] = newInd;
170         }
171     }
172 
173     function bubbleUp(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
174         // Bubble up
175         ind = _ind;
176         if (ind != 1) {
177             uint256 parent = _heap.entries[ind / 2];
178             while (parent < _val) {
179                 // If the parent value is lower than our current value, we swap them
180                 (_heap.entries[ind / 2], _heap.entries[ind]) = (_val, parent);
181 
182                 // Update moved Index
183                 _heap.index[decodeAddress(parent)] = ind;
184 
185                 // change our current Index to go up to the parent
186                 ind = ind / 2;
187                 if (ind == 1) {
188                     break;
189                 }
190 
191                 // Update parent
192                 parent = _heap.entries[ind / 2];
193             }
194         }
195     }
196 
197     function bubbleDown(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
198         // Bubble down
199         ind = _ind;
200 
201         uint256 lenght = _heap.entries.length;
202         uint256 target = lenght - 1;
203 
204         while (ind * 2 < lenght) {
205             // get the current index of the children
206             uint256 j = ind * 2;
207 
208             // left child value
209             uint256 leftChild = _heap.entries[j];
210 
211             // Store the value of the child
212             uint256 childValue;
213 
214             if (target > j) {
215                 // The parent has two childs 👨‍👧‍👦
216 
217                 // Load right child value
218                 uint256 rightChild = _heap.entries[j + 1];
219 
220                 // Compare the left and right child.
221                 // if the rightChild is greater, then point j to it's index
222                 // and save the value
223                 if (leftChild < rightChild) {
224                     childValue = rightChild;
225                     j = j + 1;
226                 } else {
227                     // The left child is greater
228                     childValue = leftChild;
229                 }
230             } else {
231                 // The parent has a single child 👨‍👦
232                 childValue = leftChild;
233             }
234 
235             // Check if the child has a lower value
236             if (_val > childValue) {
237                 break;
238             }
239 
240             // else swap the value
241             (_heap.entries[ind], _heap.entries[j]) = (childValue, _val);
242 
243             // Update moved Index
244             _heap.index[decodeAddress(childValue)] = ind;
245 
246             // and let's keep going down the heap
247             ind = j;
248         }
249     }
250 }
251 
252 // File: contracts/commons/StorageUnit.sol
253 
254 pragma solidity ^0.5.10;
255 
256 
257 contract StorageUnit {
258     address private owner;
259     mapping(bytes32 => bytes32) private store;
260 
261     constructor() public {
262         owner = msg.sender;
263     }
264 
265     function write(bytes32 _key, bytes32 _value) external {
266         /* solium-disable-next-line */
267         require(msg.sender == owner);
268         store[_key] = _value;
269     }
270 
271     function read(bytes32 _key) external view returns (bytes32) {
272         return store[_key];
273     }
274 }
275 
276 // File: contracts/utils/IsContract.sol
277 
278 pragma solidity ^0.5.10;
279 
280 
281 library IsContract {
282     function isContract(address _addr) internal view returns (bool) {
283         bytes32 codehash;
284         /* solium-disable-next-line */
285         assembly { codehash := extcodehash(_addr) }
286         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
287     }
288 }
289 
290 // File: contracts/utils/DistributedStorage.sol
291 
292 pragma solidity ^0.5.10;
293 
294 
295 
296 
297 library DistributedStorage {
298     function contractSlot(bytes32 _key) private view returns (address) {
299         return address(
300             uint256(
301                 keccak256(
302                     abi.encodePacked(
303                         byte(0xff),
304                         address(this),
305                         _key,
306                         keccak256(type(StorageUnit).creationCode)
307                     )
308                 )
309             )
310         );
311     }
312 
313     function deploy(bytes32 _key) private {
314         bytes memory slotcode = type(StorageUnit).creationCode;
315         /* solium-disable-next-line */
316         assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _key)) }
317     }
318 
319     function write(
320         bytes32 _struct,
321         bytes32 _key,
322         bytes32 _value
323     ) internal {
324         StorageUnit store = StorageUnit(contractSlot(_struct));
325         if (!IsContract.isContract(address(store))) {
326             deploy(_struct);
327         }
328 
329         /* solium-disable-next-line */
330         (bool success, ) = address(store).call(
331             abi.encodeWithSelector(
332                 store.write.selector,
333                 _key,
334                 _value
335             )
336         );
337 
338         require(success, "error writing storage");
339     }
340 
341     function read(
342         bytes32 _struct,
343         bytes32 _key
344     ) internal view returns (bytes32) {
345         StorageUnit store = StorageUnit(contractSlot(_struct));
346         if (!IsContract.isContract(address(store))) {
347             return bytes32(0);
348         }
349 
350         /* solium-disable-next-line */
351         (bool success, bytes memory data) = address(store).staticcall(
352             abi.encodeWithSelector(
353                 store.read.selector,
354                 _key
355             )
356         );
357 
358         require(success, "error reading storage");
359         return abi.decode(data, (bytes32));
360     }
361 }
362 
363 // File: contracts/utils/SafeMath.sol
364 
365 pragma solidity ^0.5.10;
366 
367 
368 library SafeMath {
369     function add(uint256 x, uint256 y) internal pure returns (uint256) {
370         uint256 z = x + y;
371         require(z >= x, "Add overflow");
372         return z;
373     }
374 
375     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
376         require(x >= y, "Sub underflow");
377         return x - y;
378     }
379 
380     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
381         if (x == 0) {
382             return 0;
383         }
384 
385         uint256 z = x * y;
386         require(z / x == y, "Mult overflow");
387         return z;
388     }
389 
390     function div(uint256 x, uint256 y) internal pure returns (uint256) {
391         require(y != 0, "Div by zero");
392         return x / y;
393     }
394 
395     function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
396         require(y != 0, "Div by zero");
397         uint256 r = x / y;
398         if (x % y != 0) {
399             r = r + 1;
400         }
401 
402         return r;
403     }
404 }
405 
406 // File: contracts/utils/Math.sol
407 
408 pragma solidity ^0.5.10;
409 
410 
411 library Math {
412     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
413         uint256 counter = uint(-1);
414         uint256 temp = input;
415 
416         do {
417             temp /= 10;
418             counter++;
419         } while (temp != 0);
420 
421         return counter;
422     }
423 
424     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
425         if (_a < _b) {
426             return _a;
427         } else {
428             return _b;
429         }
430     }
431 }
432 
433 // File: contracts/utils/GasPump.sol
434 
435 pragma solidity ^0.5.10;
436 
437 
438 contract GasPump {
439     bytes32 private stub;
440 
441     modifier requestGas(uint256 _factor) {
442         if (tx.gasprice == 0) {
443             uint256 startgas = gasleft();
444             _;
445             uint256 delta = startgas - gasleft();
446             uint256 target = (delta * _factor) / 100;
447             startgas = gasleft();
448             while (startgas - gasleft() < target) {
449                 // Burn gas
450                 stub = keccak256(abi.encodePacked(stub));
451             }
452         } else {
453             _;
454         }
455     }
456 }
457 
458 // File: contracts/interfaces/IERC20.sol
459 
460 pragma solidity ^0.5.10;
461 
462 
463 interface IERC20 {
464     event Transfer(address indexed _from, address indexed _to, uint256 _value);
465     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
466     function transfer(address _to, uint _value) external returns (bool success);
467     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
468     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
469     function approve(address _spender, uint256 _value) external returns (bool success);
470     function balanceOf(address _owner) external view returns (uint256 balance);
471 }
472 
473 // File: contracts/ShuffleToken.sol
474 
475 pragma solidity ^0.5.10;
476 
477 
478 
479 
480 
481 
482 
483 
484 
485 contract ShuffleToken is Ownable, GasPump, IERC20 {
486     using AddressMinHeap for AddressMinHeap.Heap;
487     using DistributedStorage for bytes32;
488     using SafeMath for uint256;
489 
490     // Shuffle events
491     event Winner(address indexed _addr, uint256 _value);
492 
493     // Heap events
494     event JoinHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
495     event LeaveHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
496 
497     // Managment events
498     event SetName(string _prev, string _new);
499     event SetExtraGas(uint256 _prev, uint256 _new);
500     event WhitelistFrom(address _addr, bool _whitelisted);
501     event WhitelistTo(address _addr, bool _whitelisted);
502 
503     uint256 public totalSupply;
504 
505     bytes32 private constant BALANCE_KEY = keccak256("balance");
506     bytes32 private constant NONCE_KEY = keccak256("nonce");
507 
508     // game
509     uint256 public constant FEE = 100;
510     uint256 public constant TOP_SIZE = 512;
511 
512     // heap
513     AddressMinHeap.Heap private heap;
514 
515     // metadata
516     string public name = "shuffle.monster token V2";
517     string public constant symbol = "SHUF";
518     uint8 public constant decimals = 18;
519 
520     // fee whitelist
521     mapping(address => bool) public whitelistFrom;
522     mapping(address => bool) public whitelistTo;
523 
524     // internal
525     uint256 public extraGas;
526     bool inited;
527 
528     function init(
529         address _to,
530         uint256 _amount
531     ) external {
532         require(!inited);
533         inited = true;
534         heap.initialize();
535         extraGas = 15;
536         emit SetExtraGas(0, extraGas);
537         emit Transfer(address(0), _to, _amount);
538         _setBalance(_to, _amount);
539         totalSupply = _amount;
540     }
541 
542     ///
543     // Storage access functions
544     ///
545 
546     function _toKey(address a) internal pure returns (bytes32) {
547         return bytes32(uint256(a));
548     }
549 
550     function _balanceOf(address _addr) internal view returns (uint256) {
551         return uint256(_toKey(_addr).read(BALANCE_KEY));
552     }
553 
554     function _allowance(address _addr, address _spender) internal view returns (uint256) {
555         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
556     }
557 
558     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
559         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
560     }
561 
562     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
563         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
564     }
565 
566     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
567         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
568     }
569 
570     function _setBalance(address _addr, uint256 _balance) internal {
571         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
572         _computeHeap(_addr, _balance);
573     }
574 
575     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
576         return _nonce(_addr, _cat);
577     }
578 
579     ///
580     // Internal methods
581     ///
582 
583     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
584         return whitelistFrom[_from]||whitelistTo[_to];
585     }
586 
587     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
588         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
589         return rand % (_max + 1);
590     }
591 
592     function _pickWinner(address _from, uint256 _value) internal returns (address winner) {
593         // Get order of magnitude of the tx
594         uint256 magnitude = Math.orderOfMagnitude(_value);
595         // Pull nonce for a given order of magnitude
596         uint256 nonce = _nonce(_from, magnitude);
597         _setNonce(_from, magnitude, nonce + 1);
598         // pick entry from heap
599         (winner,) = heap.entry(_random(_from, nonce, magnitude, heap.size() - 1));
600     }
601 
602     function _transferFrom(address _operator, address _from, address _to, uint256 _value, bool _skipWhitelist) internal {
603         if (_value == 0) {
604             emit Transfer(_from, _to, 0);
605             return;
606         }
607 
608         uint256 balanceFrom = _balanceOf(_from);
609         require(balanceFrom >= _value, "balance not enough");
610 
611         if (_from != _operator) {
612             uint256 allowanceFrom = _allowance(_from, _operator);
613             if (allowanceFrom != uint(-1)) {
614                 require(allowanceFrom >= _value, "allowance not enough");
615                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
616             }
617         }
618 
619         uint256 receive = _value;
620         _setBalance(_from, balanceFrom.sub(_value));
621 
622         if (_skipWhitelist || !_isWhitelisted(_from, _to)) {
623             uint256 burn = _value.divRound(FEE);
624             uint256 shuf = _value == 1 ? 0 : burn;
625             receive = receive.sub(burn.add(shuf));
626 
627             // Burn tokens
628             totalSupply = totalSupply.sub(burn);
629             emit Transfer(_from, address(0), burn);
630 
631             // Shuffle tokens
632             // Pick winner pseudo-randomly
633             address winner = _pickWinner(_from, _value);
634             // Transfer balance to winner
635             _setBalance(winner, _balanceOf(winner).add(shuf));
636             emit Winner(winner, shuf);
637             emit Transfer(_from, winner, shuf);
638         }
639 
640         // Transfer tokens
641         _setBalance(_to, _balanceOf(_to).add(receive));
642         emit Transfer(_from, _to, receive);
643     }
644 
645     function _computeHeap(address _addr, uint256 _new) internal {
646         uint256 size = heap.size();
647         if (size == 0) {
648             emit JoinHeap(_addr, _new, 0);
649             heap.insert(_addr, _new);
650             return;
651         }
652 
653         (, uint256 lastBal) = heap.top();
654 
655         if (heap.has(_addr)) {
656             heap.update(_addr, _new);
657             if (_new == 0) {
658                 heap.popTop();
659                 emit LeaveHeap(_addr, 0, size);
660             }
661         } else {
662             // IF heap is full or new bal is better than pop heap
663             if (_new != 0 && (size < TOP_SIZE || lastBal < _new)) {
664                 // If heap is full pop heap
665                 if (size >= TOP_SIZE) {
666                     (address _poped, uint256 _balance) = heap.popTop();
667                     emit LeaveHeap(_poped, _balance, size);
668                 }
669 
670                 // Insert new value
671                 heap.insert(_addr, _new);
672                 emit JoinHeap(_addr, _new, size);
673             }
674         }
675     }
676 
677     ///
678     // Managment
679     ///
680 
681     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
682         emit WhitelistTo(_addr, _whitelisted);
683         whitelistTo[_addr] = _whitelisted;
684     }
685 
686     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
687         emit WhitelistFrom(_addr, _whitelisted);
688         whitelistFrom[_addr] = _whitelisted;
689     }
690 
691     function setName(string calldata _name) external onlyOwner {
692         emit SetName(name, _name);
693         name = _name;
694     }
695 
696     function setExtraGas(uint256 _gas) external onlyOwner {
697         emit SetExtraGas(extraGas, _gas);
698         extraGas = _gas;
699     }
700 
701     /////
702     // Heap methods
703     /////
704 
705     function heapSize() external view returns (uint256) {
706         return heap.size();
707     }
708 
709     function heapEntry(uint256 _i) external view returns (address, uint256) {
710         return heap.entry(_i);
711     }
712 
713     function heapTop() external view returns (address, uint256) {
714         return heap.top();
715     }
716 
717     function heapIndex(address _addr) external view returns (uint256) {
718         return heap.index[_addr];
719     }
720 
721     /////
722     // ERC20
723     /////
724 
725     function balanceOf(address _addr) external view returns (uint256) {
726         return _balanceOf(_addr);
727     }
728 
729     function allowance(address _addr, address _spender) external view returns (uint256) {
730         return _allowance(_addr, _spender);
731     }
732 
733     function approve(address _spender, uint256 _value) external returns (bool) {
734         emit Approval(msg.sender, _spender, _value);
735         _setAllowance(msg.sender, _spender, _value);
736         return true;
737     }
738 
739     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
740         _transferFrom(msg.sender, msg.sender, _to, _value, false);
741         return true;
742     }
743 
744     function transferWithFee(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
745         _transferFrom(msg.sender, msg.sender, _to, _value, true);
746         return true;
747     }
748 
749     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
750         _transferFrom(msg.sender, _from, _to, _value, false);
751         return true;
752     }
753 }