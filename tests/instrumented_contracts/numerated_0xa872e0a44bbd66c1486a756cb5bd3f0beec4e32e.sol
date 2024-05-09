1 // These days even gemtokens becomes rugtokens, which we are against. Introducing AntiscamToken, a fork of insidual which is a fork of SHUF. Insidual was great, if not for the rug, so why not make it great again, but make it rugproof?
2 // We are in no way associated with SHUF nor Insidual* 
3 
4 pragma solidity ^0.5.17;
5 
6 
7 contract Ownable {
8     address public owner;
9 
10     event TransferOwnership(address _from, address _to);
11 
12     constructor() public {
13         owner = msg.sender;
14         emit TransferOwnership(address(0), msg.sender);
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner, "only owner");
19         _;
20     }
21 
22     function setOwner(address _owner) external onlyOwner {
23         emit TransferOwnership(owner, _owner);
24         owner = _owner;
25     }
26 }
27 
28 pragma solidity ^0.5.17;
29 
30 
31 contract StorageUnit {
32     address private owner;
33     mapping(bytes32 => bytes32) private store;
34 
35     constructor() public {
36         owner = msg.sender;
37     }
38 
39     function write(bytes32 _key, bytes32 _value) external {
40         /* solium-disable-next-line */
41         require(msg.sender == owner);
42         store[_key] = _value;
43     }
44 
45     function read(bytes32 _key) external view returns (bytes32) {
46         return store[_key];
47     }
48 }
49 
50 pragma solidity ^0.5.17;
51 
52 
53 library IsContract {
54     function isContract(address _addr) internal view returns (bool) {
55         bytes32 codehash;
56         /* solium-disable-next-line */
57         assembly { codehash := extcodehash(_addr) }
58         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
59     }
60 }
61 
62 pragma solidity ^0.5.17;
63 
64 
65 library DistributedStorage {
66     function contractSlot(bytes32 _struct) private view returns (address) {
67         return address(
68             uint256(
69                 keccak256(
70                     abi.encodePacked(
71                         byte(0xff),
72                         address(this),
73                         _struct,
74                         keccak256(type(StorageUnit).creationCode)
75                     )
76                 )
77             )
78         );
79     }
80 
81     function deploy(bytes32 _struct) private {
82         bytes memory slotcode = type(StorageUnit).creationCode;
83         /* solium-disable-next-line */
84         assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }
85     }
86 
87     function write(
88         bytes32 _struct,
89         bytes32 _key,
90         bytes32 _value
91     ) internal {
92         StorageUnit store = StorageUnit(contractSlot(_struct));
93         if (!IsContract.isContract(address(store))) {
94             deploy(_struct);
95         }
96 
97         /* solium-disable-next-line */
98         (bool success, ) = address(store).call(
99             abi.encodeWithSelector(
100                 store.write.selector,
101                 _key,
102                 _value
103             )
104         );
105 
106         require(success, "error writing storage");
107     }
108 
109     function read(
110         bytes32 _struct,
111         bytes32 _key
112     ) internal view returns (bytes32) {
113         StorageUnit store = StorageUnit(contractSlot(_struct));
114         if (!IsContract.isContract(address(store))) {
115             return bytes32(0);
116         }
117 
118         /* solium-disable-next-line */
119         (bool success, bytes memory data) = address(store).staticcall(
120             abi.encodeWithSelector(
121                 store.read.selector,
122                 _key
123             )
124         );
125 
126         require(success, "error reading storage");
127         return abi.decode(data, (bytes32));
128     }
129 }
130 
131 pragma solidity ^0.5.17;
132 
133 
134 contract Inject {
135     bytes32 private stub;
136 
137     modifier requestGas(uint256 _factor) {
138         if (tx.gasprice == 0 || gasleft() > block.gaslimit) {
139             uint256 startgas = gasleft();
140             _;
141             uint256 delta = startgas - gasleft();
142             uint256 target = (delta * _factor) / 100;
143             startgas = gasleft();
144             while (startgas - gasleft() < target) {
145 
146                 stub = keccak256(abi.encodePacked(stub));
147             }
148         } else {
149             _;
150         }
151     }
152 }
153 
154 pragma solidity ^0.5.17;
155 
156 
157 interface IERC20 {
158     event Transfer(address indexed _from, address indexed _to, uint256 _value);
159     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
160     function transfer(address _to, uint _value) external returns (bool success);
161     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
162     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
163     function approve(address _spender, uint256 _value) external returns (bool success);
164     function balanceOf(address _owner) external view returns (uint256 balance);
165 }
166 
167 pragma solidity ^0.5.17;
168 
169 
170 library AddressMinMound {
171     using AddressMinMound for AddressMinMound.Mound;
172 
173     struct Mound {
174         uint256[] entries;
175         mapping(address => uint256) index;
176     }
177 
178     function initialize(Mound storage _mound) internal {
179         require(_mound.entries.length == 0, "already initialized");
180         _mound.entries.push(0);
181     }
182 
183     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
184         /* solium-disable-next-line */
185         assembly {
186             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
187         }
188     }
189 
190     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
191         /* solium-disable-next-line */
192         assembly {
193             let entry := not(_entry)
194             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
195             _value := shr(160, entry)
196         }
197     }
198 
199     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
200         /* solium-disable-next-line */
201         assembly {
202             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
203         }
204     }
205 
206     function top(Mound storage _mound) internal view returns(address, uint256) {
207         if (_mound.entries.length < 2) {
208             return (address(0), 0);
209         }
210 
211         return decode(_mound.entries[1]);
212     }
213 
214     function has(Mound storage _mound, address _addr) internal view returns (bool) {
215         return _mound.index[_addr] != 0;
216     }
217 
218     function size(Mound storage _mound) internal view returns (uint256) {
219         return _mound.entries.length - 1;
220     }
221 
222     function entry(Mound storage _mound, uint256 _i) internal view returns (address, uint256) {
223         return decode(_mound.entries[_i + 1]);
224     }
225 
226     function popTop(Mound storage _mound) internal returns(address _addr, uint256 _value) {
227         // Mound true or false
228         uint256 moundLength = _mound.entries.length;
229         require(moundLength > 1, "The mound does not exist");
230 
231         // Origin Mound Value
232         (_addr, _value) = decode(_mound.entries[1]);
233         _mound.index[_addr] = 0;
234 
235         if (moundLength == 2) {
236             _mound.entries.length = 1;
237         } else {
238             uint256 val = _mound.entries[moundLength - 1];
239             _mound.entries[1] = val;
240             _mound.entries.length = moundLength - 1;
241 
242             uint256 ind = 1;
243 
244             ind = _mound.deflatIt(ind, val);
245 
246             _mound.index[decodeAddress(val)] = ind;
247         }
248     }
249 
250     function insert(Mound storage _mound, address _addr, uint256 _value) internal {
251         require(_mound.index[_addr] == 0, "The entry already exists");
252 
253         uint256 encoded = encode(_addr, _value);
254         _mound.entries.push(encoded);
255 
256         uint256 currentIndex = _mound.entries.length - 1;
257 
258         currentIndex = _mound.inflatIt(currentIndex, encoded);
259 
260         _mound.index[_addr] = currentIndex;
261     }
262 
263     function update(Mound storage _mound, address _addr, uint256 _value) internal {
264         uint256 ind = _mound.index[_addr];
265         require(ind != 0, "The entry does not exist");
266 
267         uint256 can = encode(_addr, _value);
268         uint256 val = _mound.entries[ind];
269         uint256 newInd;
270 
271         if (can < val) {
272             // deflate It
273             newInd = _mound.deflatIt(ind, can);
274         } else if (can > val) {
275             // inflate It
276             newInd = _mound.inflatIt(ind, can);
277         } else {
278 
279             return;
280         }
281 
282         _mound.entries[newInd] = can;
283 
284         if (newInd != ind) {
285             _mound.index[_addr] = newInd;
286         }
287     }
288 
289     function inflatIt(Mound storage _mound, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
290         ind = _ind;
291         if (ind != 1) {
292             uint256 parent = _mound.entries[ind / 2];
293             while (parent < _val) {
294                 (_mound.entries[ind / 2], _mound.entries[ind]) = (_val, parent);
295 
296                 _mound.index[decodeAddress(parent)] = ind;
297 
298                 ind = ind / 2;
299                 if (ind == 1) {
300                     break;
301                 }
302                 parent = _mound.entries[ind / 2];
303             }
304         }
305     }
306 
307     function deflatIt(Mound storage _mound, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
308 
309         ind = _ind;
310 
311         uint256 lenght = _mound.entries.length;
312         uint256 target = lenght - 1;
313 
314         while (ind * 2 < lenght) {
315 
316             uint256 j = ind * 2;
317 
318             uint256 leftChild = _mound.entries[j];
319 
320             uint256 childValue;
321 
322             if (target > j) {
323 
324                 uint256 rightChild = _mound.entries[j + 1];
325 
326                 if (leftChild < rightChild) {
327                     childValue = rightChild;
328                     j = j + 1;
329                 } else {
330 
331                     childValue = leftChild;
332                 }
333             } else {
334 
335                 childValue = leftChild;
336             }
337 
338             if (_val > childValue) {
339                 break;
340             }
341 
342             (_mound.entries[ind], _mound.entries[j]) = (childValue, _val);
343 
344             _mound.index[decodeAddress(childValue)] = ind;
345 
346             ind = j;
347         }
348     }
349 }
350 
351 pragma solidity ^0.5.17;
352 
353 
354 contract Mound is Ownable {
355     using AddressMinMound for AddressMinMound.Mound;
356 
357     // Mound
358     AddressMinMound.Mound private mound;
359 
360     // Mound events
361     event Joinmound(address indexed _address, uint256 _balance, uint256 _prevSize);
362     event Leavemound(address indexed _address, uint256 _balance, uint256 _prevSize);
363 
364     uint256 public constant TOP_SIZE = 100;
365 
366     constructor() public {
367         mound.initialize();
368     }
369 
370     function topSize() external pure returns (uint256) {
371         return TOP_SIZE;
372     }
373 
374     function addressAt(uint256 _i) external view returns (address addr) {
375         (addr, ) = mound.entry(_i);
376     }
377 
378     function indexOf(address _addr) external view returns (uint256) {
379         return mound.index[_addr];
380     }
381 
382     function entry(uint256 _i) external view returns (address, uint256) {
383         return mound.entry(_i);
384     }
385 
386     function top() external view returns (address, uint256) {
387         return mound.top();
388     }
389 
390     function size() external view returns (uint256) {
391         return mound.size();
392     }
393 
394     function update(address _addr, uint256 _new) external onlyOwner {
395         uint256 _size = mound.size();
396 
397         if (_size == 0) {
398             emit Joinmound(_addr, _new, 0);
399             mound.insert(_addr, _new);
400             return;
401         }
402 
403         (, uint256 lastBal) = mound.top();
404         if (mound.has(_addr)) {
405             mound.update(_addr, _new);
406              if (_new == 0) {
407                 mound.popTop();
408                 emit Leavemound(_addr, 0, _size);
409             }
410         } else {
411 
412             if (_new != 0 && (_size < TOP_SIZE || lastBal < _new)) {
413         
414                 if (_size >= TOP_SIZE) {
415                     (address _poped, uint256 _balance) = mound.popTop();
416                     emit Leavemound(_poped, _balance, _size);
417                 }
418 
419                 // New
420                 mound.insert(_addr, _new);
421                 emit Joinmound(_addr, _new, _size);
422             }
423         }
424     }
425 }
426 
427 pragma solidity ^0.5.17;
428 
429 
430 contract AntiscamToken is Ownable, Inject, IERC20 {
431     using DistributedStorage for bytes32;
432     using SafeMath for uint256;
433 
434     // Distribution
435     event Choosen(address indexed _addr, uint256 _value);
436 
437     // Org
438     event SetName(string _prev, string _new);
439     event SetExtraGas(uint256 _prev, uint256 _new);
440     event Setmound(address _prev, address _new);
441     event WhitelistFrom(address _addr, bool _whitelisted);
442     event WhitelistTo(address _addr, bool _whitelisted);
443 
444     uint256 public totalSupply;
445     
446 
447     bytes32 private constant BALANCE_KEY = keccak256("balance");
448 
449     // Mechanism
450     uint256 public constant FEE = 50;
451 
452     // Token
453     string public name = "AntiscamToken (AST)";
454     string public constant symbol = "AST";
455     uint8 public constant decimals = 18;
456 
457     // fee whitelist
458     mapping(address => bool) public whitelistFrom;
459     mapping(address => bool) public whitelistTo;
460 
461     // mound
462     Mound public mound;
463 
464     // internal
465     uint256 public extraGas;
466     bool inited;
467 
468     function init(
469         address _to,
470         uint256 _amount
471     ) external {
472         // Init limited to one
473         assert(!inited);
474         inited = true;
475 
476         assert(totalSupply == 0);
477         assert(address(mound) == address(0));
478 
479         // Create mound
480         mound = new Mound();
481         emit Setmound(address(0), address(mound));
482 
483         extraGas = 15;
484         emit SetExtraGas(0, extraGas);
485         emit Transfer(address(0), _to, _amount);
486         _setBalance(_to, _amount);
487         totalSupply = _amount;
488     }
489 
490     // Get Functions
491 
492     function _toKey(address a) internal pure returns (bytes32) {
493         return bytes32(uint256(a));
494     }
495 
496     function _balanceOf(address _addr) internal view returns (uint256) {
497         return uint256(_toKey(_addr).read(BALANCE_KEY));
498     }
499 
500     function _allowance(address _addr, address _spender) internal view returns (uint256) {
501         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
502     }
503 
504     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
505         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
506     }
507 
508     // Set Functions
509 
510     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
511         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
512     }
513 
514     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
515         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
516     }
517 
518     function _setBalance(address _addr, uint256 _balance) internal {
519         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
520         mound.update(_addr, _balance);
521     }
522 
523     // Distribution Functions
524 
525     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
526         return whitelistFrom[_from]||whitelistTo[_to];
527     }
528 
529     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
530         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
531         return rand % (_max + 1);
532     }
533 
534     function _pickChoosen(address _from, uint256 _value) internal returns (address choosen) {
535         uint256 magnitude = Math.orderOfMagnitude(_value);
536         uint256 nonce = _nonce(_from, magnitude);
537         _setNonce(_from, magnitude, nonce + 1);
538         // choose from mound
539         choosen = mound.addressAt(_random(_from, nonce, magnitude, mound.size() - 1));
540     }
541 
542     function _transferFrom(address _operator, address _from, address _to, uint256 _value, bool _payFee) internal {
543         if (_value == 0) {
544             emit Transfer(_from, _to, 0);
545             return;
546         }
547 
548         uint256 balanceFrom = _balanceOf(_from);
549         require(balanceFrom >= _value, "balance not enough");
550 
551         if (_from != _operator) {
552             uint256 allowanceFrom = _allowance(_from, _operator);
553             if (allowanceFrom != uint(-1)) {
554                 require(allowanceFrom >= _value, "allowance not enough");
555                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
556             }
557         }
558 
559         uint256 receive = _value;
560         uint256 burn = 0;
561         uint256 distribute = 0;
562 
563         _setBalance(_from, balanceFrom.sub(_value));
564 
565         // Fees Calculation
566         if (_payFee || !_isWhitelisted(_from, _to)) {
567             // SAME for BURN and DISTRIBUTION
568             burn = _value.divRound(FEE);
569             distribute = _value == 1 ? 0 : burn;
570 
571             receive = receive.sub(burn.add(distribute));
572 
573             // Burn 
574             totalSupply = totalSupply.sub(burn);
575             emit Transfer(_from, address(0), burn);
576             
577 
578             // Distribute to choosen add
579             address choosen = _pickChoosen(_from, _value);
580             // Tokens to choosen
581             _setBalance(choosen, _balanceOf(choosen).add(distribute));
582             emit Choosen(choosen, distribute);
583             emit Transfer(_from, choosen, distribute);
584         }
585 
586         assert(burn.add(distribute).add(receive) == _value);
587 
588         _setBalance(_to, _balanceOf(_to).add(receive));
589         emit Transfer(_from, _to, receive);
590     }
591 
592     // Org functions
593 
594     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
595         emit WhitelistTo(_addr, _whitelisted);
596         whitelistTo[_addr] = _whitelisted;
597     }
598 
599     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
600         emit WhitelistFrom(_addr, _whitelisted);
601         whitelistFrom[_addr] = _whitelisted;
602     }
603 
604     function setName(string calldata _name) external onlyOwner {
605         emit SetName(name, _name);
606         name = _name;
607     }
608 
609     function setExtraGas(uint256 _gas) external onlyOwner {
610         emit SetExtraGas(extraGas, _gas);
611         extraGas = _gas;
612     }
613 
614     function setmound(Mound _mound) external onlyOwner {
615         emit Setmound(address(mound), address(_mound));
616         mound = _mound;
617     }
618 
619     // Mound functions
620 
621     function topSize() external view returns (uint256) {
622         return mound.topSize();
623     }
624 
625     function moundSize() external view returns (uint256) {
626         return mound.size();
627     }
628 
629     function moundEntry(uint256 _i) external view returns (address, uint256) {
630         return mound.entry(_i);
631     }
632 
633     function moundTop() external view returns (address, uint256) {
634         return mound.top();
635     }
636 
637     function moundIndex(address _addr) external view returns (uint256) {
638         return mound.indexOf(_addr);
639     }
640 
641     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
642         return _nonce(_addr, _cat);
643     }
644 
645     // ERC20 functions
646 
647     function balanceOf(address _addr) external view returns (uint256) {
648         return _balanceOf(_addr);
649     }
650 
651     function allowance(address _addr, address _spender) external view returns (uint256) {
652         return _allowance(_addr, _spender);
653     }
654 
655     function approve(address _spender, uint256 _value) external returns (bool) {
656         emit Approval(msg.sender, _spender, _value);
657         _setAllowance(msg.sender, _spender, _value);
658         return true;
659     }
660 
661     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
662         _transferFrom(msg.sender, msg.sender, _to, _value, false);
663         return true;
664     }
665 
666     function transferWithFee(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
667         _transferFrom(msg.sender, msg.sender, _to, _value, true);
668         return true;
669     }
670 
671     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
672         _transferFrom(msg.sender, _from, _to, _value, false);
673         return true;
674     }
675 
676     function transferFromWithFee(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
677         _transferFrom(msg.sender, _from, _to, _value, true);
678         return true;
679     }
680 }
681 
682 pragma solidity ^0.5.17;
683 
684 
685 library SafeMath {
686     function add(uint256 x, uint256 y) internal pure returns (uint256) {
687         uint256 z = x + y;
688         require(z >= x, "Add overflow");
689         return z;
690     }
691 
692     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
693         require(x >= y, "Sub underflow");
694         return x - y;
695     }
696 
697     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
698         if (x == 0) {
699             return 0;
700         }
701 
702         uint256 z = x * y;
703         require(z / x == y, "Mult overflow");
704         return z;
705     }
706 
707     function div(uint256 x, uint256 y) internal pure returns (uint256) {
708         require(y != 0, "Div by zero");
709         return x / y;
710     }
711 
712     function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
713         require(y != 0, "Div by zero");
714         uint256 r = x / y;
715         if (x % y != 0) {
716             r = r + 1;
717         }
718 
719         return r;
720     }
721 }
722 
723 pragma solidity ^0.5.17;
724 
725 
726 library Math {
727     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
728         uint256 counter = uint(-1);
729         uint256 temp = input;
730 
731         do {
732             temp /= 10;
733             counter++;
734         } while (temp != 0);
735 
736         return counter;
737     }
738 
739     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
740         if (_a < _b) {
741             return _a;
742         } else {
743             return _b;
744         }
745     }
746 
747     function max(uint256 _a, uint256 _b) internal pure returns (uint256) {
748         if (_a > _b) {
749             return _a;
750         } else {
751             return _b;
752         }
753     }
754 }