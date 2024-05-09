1 // File: contracts/commons/Ownable.sol
2 
3 pragma solidity ^0.5.10;
4 
5 
6 contract Ownable {
7     address public owner;
8 
9     event TransferOwnership(address _from, address _to);
10 
11     constructor() public {
12         owner = msg.sender;
13         emit TransferOwnership(address(0), msg.sender);
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner, "only owner");
18         _;
19     }
20 
21     function setOwner(address _owner) external onlyOwner {
22         emit TransferOwnership(owner, _owner);
23         owner = _owner;
24     }
25 }
26 
27 // File: contracts/commons/AddressMinHeap.sol
28 
29 pragma solidity ^0.5.10;
30 
31 /*
32     @author Agustin Aguilar <agusxrun@gmail.com>
33 */
34 
35 
36 library AddressMinHeap {
37     using AddressMinHeap for AddressMinHeap.Heap;
38 
39     struct Heap {
40         uint256[] entries;
41         mapping(address => uint256) index;
42     }
43 
44     function initialize(Heap storage _heap) internal {
45         require(_heap.entries.length == 0, "already initialized");
46         _heap.entries.push(0);
47     }
48 
49     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
50         /* solium-disable-next-line */
51         assembly {
52             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
53         }
54     }
55 
56     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
57         /* solium-disable-next-line */
58         assembly {
59             let entry := not(_entry)
60             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
61             _value := shr(160, entry)
62         }
63     }
64 
65     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
66         /* solium-disable-next-line */
67         assembly {
68             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
69         }
70     }
71 
72     function top(Heap storage _heap) internal view returns(address, uint256) {
73         if (_heap.entries.length < 2) {
74             return (address(0), 0);
75         }
76 
77         return decode(_heap.entries[1]);
78     }
79 
80     function has(Heap storage _heap, address _addr) internal view returns (bool) {
81         return _heap.index[_addr] != 0;
82     }
83 
84     function size(Heap storage _heap) internal view returns (uint256) {
85         return _heap.entries.length - 1;
86     }
87 
88     function entry(Heap storage _heap, uint256 _i) internal view returns (address, uint256) {
89         return decode(_heap.entries[_i + 1]);
90     }
91 
92     // RemoveMax pops off the root element of the heap (the highest value here) and rebalances the heap
93     function popTop(Heap storage _heap) internal returns(address _addr, uint256 _value) {
94         // Ensure the heap exists
95         uint256 heapLength = _heap.entries.length;
96         require(heapLength > 1, "The heap does not exists");
97 
98         // take the root value of the heap
99         (_addr, _value) = decode(_heap.entries[1]);
100         _heap.index[_addr] = 0;
101 
102         if (heapLength == 2) {
103             _heap.entries.length = 1;
104         } else {
105             // Takes the last element of the array and put it at the root
106             uint256 val = _heap.entries[heapLength - 1];
107             _heap.entries[1] = val;
108 
109             // Delete the last element from the array
110             _heap.entries.length = heapLength - 1;
111 
112             // Start at the top
113             uint256 ind = 1;
114 
115             // Bubble down
116             ind = _heap.bubbleDown(ind, val);
117 
118             // Update index
119             _heap.index[decodeAddress(val)] = ind;
120         }
121     }
122 
123     // Inserts adds in a value to our heap.
124     function insert(Heap storage _heap, address _addr, uint256 _value) internal {
125         require(_heap.index[_addr] == 0, "The entry already exists");
126 
127         // Add the value to the end of our array
128         uint256 encoded = encode(_addr, _value);
129         _heap.entries.push(encoded);
130 
131         // Start at the end of the array
132         uint256 currentIndex = _heap.entries.length - 1;
133 
134         // Bubble Up
135         currentIndex = _heap.bubbleUp(currentIndex, encoded);
136 
137         // Update index
138         _heap.index[_addr] = currentIndex;
139     }
140 
141     function update(Heap storage _heap, address _addr, uint256 _value) internal {
142         uint256 ind = _heap.index[_addr];
143         require(ind != 0, "The entry does not exists");
144 
145         uint256 can = encode(_addr, _value);
146         uint256 val = _heap.entries[ind];
147         uint256 newInd;
148 
149         if (can < val) {
150             // Bubble down
151             newInd = _heap.bubbleDown(ind, can);
152         } else if (can > val) {
153             // Bubble up
154             newInd = _heap.bubbleUp(ind, can);
155         } else {
156             // no changes needed
157             return;
158         }
159 
160         // Update entry
161         _heap.entries[newInd] = can;
162 
163         // Update index
164         if (newInd != ind) {
165             _heap.index[_addr] = newInd;
166         }
167     }
168 
169     function bubbleUp(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
170         // Bubble up
171         ind = _ind;
172         if (ind != 1) {
173             uint256 parent = _heap.entries[ind / 2];
174             while (parent < _val) {
175                 // If the parent value is lower than our current value, we swap them
176                 (_heap.entries[ind / 2], _heap.entries[ind]) = (_val, parent);
177 
178                 // Update moved Index
179                 _heap.index[decodeAddress(parent)] = ind;
180 
181                 // change our current Index to go up to the parent
182                 ind = ind / 2;
183                 if (ind == 1) {
184                     break;
185                 }
186 
187                 // Update parent
188                 parent = _heap.entries[ind / 2];
189             }
190         }
191     }
192 
193     function bubbleDown(Heap storage _heap, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
194         // Bubble down
195         ind = _ind;
196 
197         uint256 lenght = _heap.entries.length;
198         uint256 target = lenght - 1;
199 
200         while (ind * 2 < lenght) {
201             // get the current index of the children
202             uint256 j = ind * 2;
203 
204             // left child value
205             uint256 leftChild = _heap.entries[j];
206 
207             // Store the value of the child
208             uint256 childValue;
209 
210             if (target > j) {
211                 // The parent has two childs 👨‍👧‍👦
212 
213                 // Load right child value
214                 uint256 rightChild = _heap.entries[j + 1];
215 
216                 // Compare the left and right child.
217                 // if the rightChild is greater, then point j to it's index
218                 // and save the value
219                 if (leftChild < rightChild) {
220                     childValue = rightChild;
221                     j = j + 1;
222                 } else {
223                     // The left child is greater
224                     childValue = leftChild;
225                 }
226             } else {
227                 // The parent has a single child 👨‍👦
228                 childValue = leftChild;
229             }
230 
231             // Check if the child has a lower value
232             if (_val > childValue) {
233                 break;
234             }
235 
236             // else swap the value
237             (_heap.entries[ind], _heap.entries[j]) = (childValue, _val);
238 
239             // Update moved Index
240             _heap.index[decodeAddress(childValue)] = ind;
241 
242             // and let's keep going down the heap
243             ind = j;
244         }
245     }
246 }
247 
248 // File: contracts/commons/StorageUnit.sol
249 
250 pragma solidity ^0.5.10;
251 
252 
253 contract StorageUnit {
254     address private owner;
255     mapping(bytes32 => bytes32) private store;
256 
257     constructor() public {
258         owner = msg.sender;
259     }
260 
261     function write(bytes32 _key, bytes32 _value) external {
262         /* solium-disable-next-line */
263         require(msg.sender == owner);
264         store[_key] = _value;
265     }
266 
267     function read(bytes32 _key) external view returns (bytes32) {
268         return store[_key];
269     }
270 }
271 
272 // File: contracts/utils/IsContract.sol
273 
274 pragma solidity ^0.5.10;
275 
276 
277 library IsContract {
278     function isContract(address _addr) internal view returns (bool) {
279         bytes32 codehash;
280         /* solium-disable-next-line */
281         assembly { codehash := extcodehash(_addr) }
282         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
283     }
284 }
285 
286 // File: contracts/utils/DistributedStorage.sol
287 
288 pragma solidity ^0.5.10;
289 
290 
291 
292 
293 library DistributedStorage {
294     function contractSlot(bytes32 _key) private view returns (address) {
295         return address(
296             uint256(
297                 keccak256(
298                     abi.encodePacked(
299                         byte(0xff),
300                         address(this),
301                         _key,
302                         keccak256(type(StorageUnit).creationCode)
303                     )
304                 )
305             )
306         );
307     }
308 
309     function deploy(bytes32 _key) private {
310         bytes memory slotcode = type(StorageUnit).creationCode;
311         /* solium-disable-next-line */
312         assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _key)) }
313     }
314 
315     function write(
316         bytes32 _struct,
317         bytes32 _key,
318         bytes32 _value
319     ) internal {
320         StorageUnit store = StorageUnit(contractSlot(_struct));
321         if (!IsContract.isContract(address(store))) {
322             deploy(_struct);
323         }
324 
325         /* solium-disable-next-line */
326         (bool success, ) = address(store).call(
327             abi.encodeWithSelector(
328                 store.write.selector,
329                 _key,
330                 _value
331             )
332         );
333 
334         require(success, "error writing storage");
335     }
336 
337     function read(
338         bytes32 _struct,
339         bytes32 _key
340     ) internal view returns (bytes32) {
341         StorageUnit store = StorageUnit(contractSlot(_struct));
342         if (!IsContract.isContract(address(store))) {
343             return bytes32(0);
344         }
345 
346         /* solium-disable-next-line */
347         (bool success, bytes memory data) = address(store).staticcall(
348             abi.encodeWithSelector(
349                 store.read.selector,
350                 _key
351             )
352         );
353 
354         require(success, "error reading storage");
355         return abi.decode(data, (bytes32));
356     }
357 }
358 
359 // File: contracts/utils/SafeMath.sol
360 
361 pragma solidity ^0.5.10;
362 
363 
364 library SafeMath {
365     function add(uint256 x, uint256 y) internal pure returns (uint256) {
366         uint256 z = x + y;
367         require(z >= x, "Add overflow");
368         return z;
369     }
370 
371     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
372         require(x >= y, "Sub underflow");
373         return x - y;
374     }
375 
376     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
377         if (x == 0) {
378             return 0;
379         }
380 
381         uint256 z = x * y;
382         require(z / x == y, "Mult overflow");
383         return z;
384     }
385 
386     function div(uint256 x, uint256 y) internal pure returns (uint256) {
387         require(y != 0, "Div by zero");
388         return x / y;
389     }
390 
391     function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
392         require(y != 0, "Div by zero");
393         uint256 r = x / y;
394         if (x % y != 0) {
395             r = r + 1;
396         }
397 
398         return r;
399     }
400 }
401 
402 // File: contracts/utils/Math.sol
403 
404 pragma solidity ^0.5.10;
405 
406 
407 library Math {
408     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
409         uint256 counter = uint(-1);
410         uint256 temp = input;
411 
412         do {
413             temp /= 10;
414             counter++;
415         } while (temp != 0);
416 
417         return counter;
418     }
419 
420     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
421         if (_a < _b) {
422             return _a;
423         } else {
424             return _b;
425         }
426     }
427 }
428 
429 // File: contracts/utils/GasPump.sol
430 
431 pragma solidity ^0.5.10;
432 
433 
434 contract GasPump {
435     bytes32 private stub;
436 
437     modifier requestGas(uint256 _factor) {
438         if (tx.gasprice == 0) {
439             uint256 startgas = gasleft();
440             _;
441             uint256 delta = startgas - gasleft();
442             uint256 target = (delta * _factor) / 100;
443             startgas = gasleft();
444             while (startgas - gasleft() < target) {
445                 // Burn gas
446                 stub = keccak256(abi.encodePacked(stub));
447             }
448         } else {
449             _;
450         }
451     }
452 }
453 
454 // File: contracts/interfaces/IERC20.sol
455 
456 pragma solidity ^0.5.10;
457 
458 
459 interface IERC20 {
460     event Transfer(address indexed _from, address indexed _to, uint256 _value);
461     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
462     function transfer(address _to, uint _value) external returns (bool success);
463     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
464     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
465     function approve(address _spender, uint256 _value) external returns (bool success);
466     function balanceOf(address _owner) external view returns (uint256 balance);
467 }
468 
469 // File: contracts/ShuffleToken.sol
470 
471 pragma solidity ^0.5.10;
472 
473 
474 
475 
476 
477 
478 
479 
480 
481 contract ShuffleToken is Ownable, GasPump, IERC20 {
482     using AddressMinHeap for AddressMinHeap.Heap;
483     using DistributedStorage for bytes32;
484     using SafeMath for uint256;
485 
486     // Shuffle events
487     event Winner(address indexed _addr, uint256 _value);
488 
489     // Heap events
490     event JoinHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
491     event LeaveHeap(address indexed _address, uint256 _balance, uint256 _prevSize);
492 
493     // Managment events
494     event SetName(string _prev, string _new);
495     event SetExtraGas(uint256 _prev, uint256 _new);
496     event WhitelistFrom(address _addr, bool _whitelisted);
497     event WhitelistTo(address _addr, bool _whitelisted);
498 
499     uint256 public totalSupply;
500 
501     bytes32 private constant BALANCE_KEY = keccak256("balance");
502     bytes32 private constant NONCE_KEY = keccak256("nonce");
503 
504     // game
505     uint256 public constant FEE = 100;
506     uint256 public constant TOP_SIZE = 512;
507 
508     // heap
509     AddressMinHeap.Heap private heap;
510 
511     // metadata
512     string public name = "shuffle.monster token 🃏";
513     string public constant symbol = "Shuf";
514     uint8 public constant decimals = 18;
515 
516     // fee whitelist
517     mapping(address => bool) public whitelistFrom;
518     mapping(address => bool) public whitelistTo;
519 
520     // internal
521     uint256 public extraGas;
522 
523     constructor(
524         address _to,
525         uint256 _amount
526     ) public {
527         heap.initialize();
528         extraGas = 15;
529         emit SetExtraGas(0, extraGas);
530         emit Transfer(address(0), _to, _amount);
531         _setBalance(_to, _amount);
532         totalSupply = _amount;
533     }
534 
535     ///
536     // Storage access functions
537     ///
538 
539     function _toKey(address a) internal pure returns (bytes32) {
540         return bytes32(uint256(a));
541     }
542 
543     function _balanceOf(address _addr) internal view returns (uint256) {
544         return uint256(_toKey(_addr).read(BALANCE_KEY));
545     }
546 
547     function _allowance(address _addr, address _spender) internal view returns (uint256) {
548         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
549     }
550 
551     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
552         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
553     }
554 
555     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
556         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
557     }
558 
559     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
560         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
561     }
562 
563     function _setBalance(address _addr, uint256 _balance) internal {
564         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
565         _computeHeap(_addr, _balance);
566     }
567 
568     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
569         return _nonce(_addr, _cat);
570     }
571 
572     ///
573     // Internal methods
574     ///
575 
576     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
577         return whitelistFrom[_from]||whitelistTo[_to];
578     }
579 
580     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
581         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
582         return rand % (_max + 1);
583     }
584 
585     function _pickWinner(address _from, uint256 _value) internal returns (address winner) {
586         // Get order of magnitude of the tx
587         uint256 magnitude = Math.orderOfMagnitude(_value);
588         // Pull nonce for a given order of magnitude
589         uint256 nonce = _nonce(_from, magnitude);
590         _setNonce(_from, magnitude, nonce + 1);
591         // pick entry from heap
592         (winner,) = heap.entry(_random(_from, nonce, magnitude, heap.size() - 1));
593     }
594 
595     function _transferFrom(address _operator, address _from, address _to, uint256 _value) internal {
596         if (_value == 0) {
597             emit Transfer(_from, _to, 0);
598             return;
599         }
600 
601         uint256 balanceFrom = _balanceOf(_from);
602         require(balanceFrom >= _value, "balance not enough");
603 
604         if (_from != _operator) {
605             uint256 allowanceFrom = _allowance(_from, _operator);
606             if (allowanceFrom != uint(-1)) {
607                 require(allowanceFrom >= _value, "allowance not enough");
608                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
609             }
610         }
611 
612         uint256 receive = _value;
613 
614         if (!_isWhitelisted(_from, _to)) {
615             uint256 burn = _value.divRound(FEE);
616             uint256 shuf = _value == 1 ? 0 : burn;
617             receive = receive.sub(burn.add(shuf));
618 
619             _setBalance(_from, balanceFrom.sub(_value));
620 
621             // Burn tokens
622             totalSupply = totalSupply.sub(burn);
623             emit Transfer(_from, address(0), burn);
624 
625             // Shuffle tokens
626             // Pick winner pseudo-randomly
627             address winner = _pickWinner(_from, _value);
628             // Transfer balance to winner
629             _setBalance(winner, _balanceOf(winner).add(shuf));
630             emit Winner(winner, shuf);
631             emit Transfer(_from, winner, shuf);
632         }
633 
634         // Transfer tokens
635         _setBalance(_to, _balanceOf(_to).add(receive));
636         emit Transfer(_from, _to, receive);
637     }
638 
639     function _computeHeap(address _addr, uint256 _new) internal {
640         uint256 size = heap.size();
641         if (size == 0) {
642             emit JoinHeap(_addr, _new, 0);
643             heap.insert(_addr, _new);
644             return;
645         }
646 
647         (, uint256 lastBal) = heap.top();
648 
649         if (heap.has(_addr)) {
650             heap.update(_addr, _new);
651             if (_new == 0) {
652                 heap.popTop();
653                 emit LeaveHeap(_addr, 0, size);
654             }
655         } else {
656             // IF heap is full or new bal is better than pop heap
657             if (_new != 0 && (size < TOP_SIZE || lastBal < _new)) {
658                 // If heap is full pop heap
659                 if (size >= TOP_SIZE) {
660                     (address _poped, uint256 _balance) = heap.popTop();
661                     emit LeaveHeap(_poped, _balance, size);
662                 }
663 
664                 // Insert new value
665                 heap.insert(_addr, _new);
666                 emit JoinHeap(_addr, _new, size);
667             }
668         }
669     }
670 
671     ///
672     // Managment
673     ///
674 
675     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
676         emit WhitelistTo(_addr, _whitelisted);
677         whitelistTo[_addr] = _whitelisted;
678     }
679 
680     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
681         emit WhitelistFrom(_addr, _whitelisted);
682         whitelistFrom[_addr] = _whitelisted;
683     }
684 
685     function setName(string calldata _name) external onlyOwner {
686         emit SetName(name, _name);
687         name = _name;
688     }
689 
690     function setExtraGas(uint256 _gas) external onlyOwner {
691         emit SetExtraGas(extraGas, _gas);
692         extraGas = _gas;
693     }
694 
695     /////
696     // Heap methods
697     /////
698 
699     function heapSize() external view returns (uint256) {
700         return heap.size();
701     }
702 
703     function heapEntry(uint256 _i) external view returns (address, uint256) {
704         return heap.entry(_i);
705     }
706 
707     function heapTop() external view returns (address, uint256) {
708         return heap.top();
709     }
710 
711     function heapIndex(address _addr) external view returns (uint256) {
712         return heap.index[_addr];
713     }
714 
715     /////
716     // ERC20
717     /////
718 
719     function balanceOf(address _addr) external view returns (uint256) {
720         return _balanceOf(_addr);
721     }
722 
723     function allowance(address _addr, address _spender) external view returns (uint256) {
724         return _allowance(_addr, _spender);
725     }
726 
727     function approve(address _spender, uint256 _value) external returns (bool) {
728         emit Approval(msg.sender, _spender, _value);
729         _setAllowance(msg.sender, _spender, _value);
730         return true;
731     }
732 
733     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
734         _transferFrom(msg.sender, msg.sender, _to, _value);
735         return true;
736     }
737 
738     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
739         _transferFrom(msg.sender, _from, _to, _value);
740         return true;
741     }
742 }
743 
744 // File: contracts/utils/SigUtils.sol
745 
746 pragma solidity ^0.5.10;
747 
748 
749 library SigUtils {
750     /**
751       @dev Recovers address who signed the message
752       @param _hash operation ethereum signed message hash
753       @param _signature message `hash` signature
754     */
755     function ecrecover2(
756         bytes32 _hash,
757         bytes memory _signature
758     ) internal pure returns (address) {
759         bytes32 r;
760         bytes32 s;
761         uint8 v;
762 
763         /* solium-disable-next-line */
764         assembly {
765             r := mload(add(_signature, 32))
766             s := mload(add(_signature, 64))
767             v := and(mload(add(_signature, 65)), 255)
768         }
769 
770         if (v < 27) {
771             v += 27;
772         }
773 
774         return ecrecover(
775             _hash,
776             v,
777             r,
778             s
779         );
780     }
781 }
782 
783 // File: contracts/Airdrop.sol
784 
785 pragma solidity ^0.5.10;
786 
787 
788 
789 
790 
791 
792 contract Airdrop is Ownable {
793     using IsContract for address payable;
794 
795     ShuffleToken public shuffleToken;
796 
797     // Managment
798     uint64 public maxClaimedBy = 100;
799 
800     event SetMaxClaimedBy(uint256 _max);
801     event SetSigner(address _signer, bool _active);
802     event Claimed(address _by, address _to, address _signer, uint256 _value, uint256 _claimed);
803     event ClaimedOwner(address _owner, uint256 _tokens);
804 
805     uint256 public constant MINT_AMOUNT = 1010101010101010101010101;
806     uint256 public constant CREATOR_AMOUNT = (MINT_AMOUNT * 6) / 100;
807     uint256 public constant SHUFLE_BY_ETH = 150;
808     uint256 public constant MAX_CLAIM_ETH = 10 ether;
809 
810     mapping(address => bool) public isSigner;
811 
812     mapping(address => uint256) public claimed;
813     mapping(address => uint256) public numberClaimedBy;
814     bool public creatorClaimed;
815 
816     constructor() public {
817         shuffleToken = new ShuffleToken(address(this), MINT_AMOUNT);
818         emit SetMaxClaimedBy(maxClaimedBy);
819         shuffleToken.setOwner(msg.sender);
820     }
821 
822     // ///
823     // Managment
824     // ///
825 
826     function setMaxClaimedBy(uint64 _max) external onlyOwner {
827         maxClaimedBy = _max;
828         emit SetMaxClaimedBy(_max);
829     }
830 
831     function setSigner(address _signer, bool _active) external onlyOwner {
832         isSigner[_signer] = _active;
833         emit SetSigner(_signer, _active);
834     }
835 
836     function setSigners(address[] calldata _signers, bool _active) external onlyOwner {
837         for (uint256 i = 0; i < _signers.length; i++) {
838             address signer = _signers[i];
839             isSigner[signer] = _active;
840             emit SetSigner(signer, _active);
841         }
842     }
843 
844     // ///
845     // View
846     // ///
847 
848     mapping(address => bool) private cvf;
849 
850     event CallCVF(address _from, address _to);
851 
852     function supportsFallback(address _to) external returns (bool) {
853         emit CallCVF(msg.sender, _to);
854         require(!cvf[msg.sender], "cfv");
855         cvf[msg.sender] = true;
856         return checkFallback(_to);
857     }
858 
859     // ///
860     // Airdrop
861     // ///
862 
863     function _selfBalance() internal view returns (uint256) {
864         return shuffleToken.balanceOf(address(this));
865     }
866 
867     function checkFallback(address _to) private returns (bool success) {
868         /* solium-disable-next-line */
869         (success, ) = _to.call.value(1)("");
870     }
871 
872     function pullOwnerTokens() external onlyOwner {
873         require(!creatorClaimed, "creator already pulled");
874         creatorClaimed = true;
875         uint256 tokens = Math.min(CREATOR_AMOUNT, _selfBalance());
876         shuffleToken.transfer(msg.sender, tokens);
877         emit ClaimedOwner(msg.sender, tokens);
878     }
879 
880     function claim(
881         address _to,
882         uint256 _val,
883         bytes calldata _sig
884     ) external {
885         bytes32 _hash = keccak256(abi.encodePacked(_to, uint96(_val)));
886         address signer = SigUtils.ecrecover2(_hash, _sig);
887 
888         require(isSigner[signer], "signature not valid");
889 
890         uint256 balance = _selfBalance();
891         uint256 claimVal = Math.min(
892             balance,
893             Math.min(
894                 _val,
895                 MAX_CLAIM_ETH
896             ) * SHUFLE_BY_ETH
897         );
898 
899         require(claimed[_to] == 0, "already claimed");
900         claimed[_to] = claimVal;
901 
902         if (msg.sender != _to) {
903             uint256 _numberClaimedBy = numberClaimedBy[msg.sender];
904             require(_numberClaimedBy <= maxClaimedBy, "max claim reached");
905             numberClaimedBy[msg.sender] = _numberClaimedBy + 1;
906             require(checkFallback(_to), "_to address can't receive tokens");
907         }
908 
909         shuffleToken.transfer(_to, claimVal);
910 
911         emit Claimed(msg.sender, _to, signer, _val, claimVal);
912 
913         if (balance == claimVal && _selfBalance() == 0) {
914             selfdestruct(address(uint256(owner)));
915         }
916     }
917 }