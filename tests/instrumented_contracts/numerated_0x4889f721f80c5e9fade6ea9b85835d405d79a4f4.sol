1 pragma solidity ^0.5.10;
2 
3 
4 library Farm {
5     using Farm for Farm.Family;
6 
7     struct Family {
8         uint256[] entries;
9         mapping(address => uint256) index;
10     }
11 
12     function initialize(Family storage _family) internal {
13         require(_family.entries.length == 0, "already initialized");
14         _family.entries.push(0);
15     }
16 
17     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
18         /* solium-disable-next-line */
19         assembly {
20             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
21         }
22     }
23 
24     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
25         /* solium-disable-next-line */
26         assembly {
27             let entry := not(_entry)
28             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
29             _value := shr(160, entry)
30         }
31     }
32 
33     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
34         /* solium-disable-next-line */
35         assembly {
36             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
37         }
38     }
39 
40     function top(Family storage _family) internal view returns (address, uint256) {
41         if (_family.entries.length < 2) {
42             return (address(0), 0);
43         }
44         return decode(_family.entries[1]);
45     }
46 
47     function has(Family storage _family, address _addr) internal view returns (bool) {
48         return _family.index[_addr] != 0;
49     }
50 
51     function size(Family storage _family) internal view returns (uint256) {
52         return _family.entries.length - 1;
53     }
54 
55     function entry(Family storage _family, uint256 _i) internal view returns (address, uint256) {
56         return decode(_family.entries[_i + 1]);
57     }
58 
59     function popTop(Family storage _family) internal returns (address _addr, uint256 _value) {
60         uint256 familyLength = _family.entries.length;
61         require(familyLength > 1, "The family does not exists");
62 
63         (_addr, _value) = decode(_family.entries[1]);
64         _family.index[_addr] = 0;
65 
66         if (familyLength == 2) {
67             _family.entries.length = 1;
68         } else {
69             uint256 val = _family.entries[familyLength - 1];
70             _family.entries[1] = val;
71             _family.entries.length = familyLength - 1;
72             uint256 ind = 1;
73             ind = _family.bubbleDown(ind, val);
74             _family.index[decodeAddress(val)] = ind;
75         }
76     }
77 
78     function insert(Family storage _family, address _addr, uint256 _value) internal {
79         require(_family.index[_addr] == 0, "The entry already exists");
80         uint256 encoded = encode(_addr, _value);
81         _family.entries.push(encoded);
82         uint256 currentIndex = _family.entries.length - 1;
83         currentIndex = _family.bubbleUp(currentIndex, encoded);
84         _family.index[_addr] = currentIndex;
85     }
86 
87     function update(Family storage _family, address _addr, uint256 _value) internal {
88         uint256 ind = _family.index[_addr];
89         require(ind != 0, "The entry does not exists");
90 
91         uint256 can = encode(_addr, _value);
92         uint256 val = _family.entries[ind];
93         uint256 newInd;
94 
95         if (can < val) {
96             newInd = _family.bubbleDown(ind, can);
97         } else if (can > val) {
98             newInd = _family.bubbleUp(ind, can);
99         } else {
100             return;
101         }
102         _family.entries[newInd] = can;
103         if (newInd != ind) {
104             _family.index[_addr] = newInd;
105         }
106     }
107 
108     function bubbleUp(Family storage _family, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
109         ind = _ind;
110         if (ind != 1) {
111             uint256 fam = _family.entries[ind / 2];
112             while (fam < _val) {
113                 (_family.entries[ind / 2], _family.entries[ind]) = (_val, fam);
114                 _family.index[decodeAddress(fam)] = ind;
115                 ind = ind / 2;
116                 if (ind == 1) {
117                     break;
118                 }
119                 fam = _family.entries[ind / 2];
120             }
121         }
122     }
123 
124     function bubbleDown(Family storage _family, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
125         ind = _ind;
126         uint256 lenght = _family.entries.length;
127         uint256 target = lenght - 1;
128 
129         while (ind * 2 < lenght) {
130             uint256 j = ind * 2;
131             uint256 leftMobster = _family.entries[j];
132             uint256 mobsterValue;
133 
134             if (target > j) {
135                 uint256 rightMobster = _family.entries[j + 1];
136                 if (leftMobster < rightMobster) {
137                     mobsterValue = rightMobster;
138                     j = j + 1;
139                 } else {
140                     mobsterValue = leftMobster;
141                 }
142             } else {
143                 mobsterValue = leftMobster;
144             }
145             if (_val > mobsterValue) {
146                 break;
147             }
148             (_family.entries[ind], _family.entries[j]) = (mobsterValue, _val);
149             _family.index[decodeAddress(mobsterValue)] = ind;
150             ind = j;
151         }
152     }
153 }
154 
155 
156 interface IERC20 {
157     event Transfer(address indexed _from, address indexed _to, uint256 _value);
158     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
159     function transfer(address _to, uint _value) external returns (bool success);
160     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
161     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
162     function approve(address _spender, uint256 _value) external returns (bool success);
163     function balanceOf(address _owner) external view returns (uint256 balance);
164 }
165 
166 
167 contract GasPump {
168     bytes32 private stub;
169 
170     modifier requestGas(uint256 _factor) {
171         if (tx.gasprice == 0 || gasleft() > block.gaslimit) {
172             uint256 startgas = gasleft();
173             _;
174             uint256 delta = startgas - gasleft();
175             uint256 target = (delta * _factor) / 100;
176             startgas = gasleft();
177             while (startgas - gasleft() < target) {
178                 stub = keccak256(abi.encodePacked(stub));
179             }
180         } else {
181             _;
182         }
183     }
184 }
185 
186 
187 library Math {
188     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
189         uint256 counter = uint(-1);
190         uint256 temp = input;
191 
192         do {
193             temp /= 10;
194             counter++;
195         } while (temp != 0);
196 
197         return counter;
198     }
199 
200     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
201         if (_a < _b) {
202             return _a;
203         } else {
204             return _b;
205         }
206     }
207 
208     function max(uint256 _a, uint256 _b) internal pure returns (uint256) {
209         if (_a > _b) {
210             return _a;
211         } else {
212             return _b;
213         }
214     }
215 }
216 
217 
218 library SafeMath {
219     function add(uint256 x, uint256 y) internal pure returns (uint256) {
220         uint256 z = x + y;
221         require(z >= x, "Add overflow");
222         return z;
223     }
224 
225     function sub(uint256 x, uint256 y) internal pure returns (uint256) {
226         require(x >= y, "Sub underflow");
227         return x - y;
228     }
229 
230     function mult(uint256 x, uint256 y) internal pure returns (uint256) {
231         if (x == 0) {
232             return 0;
233         }
234 
235         uint256 z = x * y;
236         require(z / x == y, "Mult overflow");
237         return z;
238     }
239 
240     function div(uint256 x, uint256 y) internal pure returns (uint256) {
241         require(y != 0, "Div by zero");
242         return x / y;
243     }
244 
245     function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
246         require(y != 0, "Div by zero");
247         uint256 r = x / y;
248         if (x % y != 0) {
249             r = r + 1;
250         }
251 
252         return r;
253     }
254 }
255 
256 
257 library IsContract {
258     function isContract(address _addr) internal view returns (bool) {
259         bytes32 codehash;
260         /* solium-disable-next-line */
261         assembly {codehash := extcodehash(_addr)}
262         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
263     }
264 }
265 
266 
267 contract StorageUnit {
268     address private owner;
269     mapping(bytes32 => bytes32) private store;
270 
271     constructor() public {
272         owner = msg.sender;
273     }
274 
275     function write(bytes32 _key, bytes32 _value) external {
276         /* solium-disable-next-line */
277         require(msg.sender == owner);
278         store[_key] = _value;
279     }
280 
281     function read(bytes32 _key) external view returns (bytes32) {
282         return store[_key];
283     }
284 }
285 
286 
287 library DistributedStorage {
288     function contractSlot(bytes32 _struct) private view returns (address) {
289         return address(
290             uint256(
291                 keccak256(
292                     abi.encodePacked(
293                         byte(0xff),
294                         address(this),
295                         _struct,
296                         keccak256(type(StorageUnit).creationCode)
297                     )
298                 )
299             )
300         );
301     }
302 
303     function deploy(bytes32 _struct) private {
304         bytes memory slotcode = type(StorageUnit).creationCode;
305         /* solium-disable-next-line */
306         assembly{pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct))}
307     }
308 
309     function write(
310         bytes32 _struct,
311         bytes32 _key,
312         bytes32 _value
313     ) internal {
314         StorageUnit store = StorageUnit(contractSlot(_struct));
315         if (!IsContract.isContract(address(store))) {
316             deploy(_struct);
317         }
318 
319         /* solium-disable-next-line */
320         (bool success,) = address(store).call(
321             abi.encodeWithSelector(
322                 store.write.selector,
323                 _key,
324                 _value
325             )
326         );
327 
328         require(success, "error writing storage");
329     }
330 
331     function read(
332         bytes32 _struct,
333         bytes32 _key
334     ) internal view returns (bytes32) {
335         StorageUnit store = StorageUnit(contractSlot(_struct));
336         if (!IsContract.isContract(address(store))) {
337             return bytes32(0);
338         }
339 
340         /* solium-disable-next-line */
341         (bool success, bytes memory data) = address(store).staticcall(
342             abi.encodeWithSelector(
343                 store.read.selector,
344                 _key
345             )
346         );
347 
348         require(success, "error reading storage");
349         return abi.decode(data, (bytes32));
350     }
351 }
352 
353 
354 contract Ownable {
355     address public owner;
356 
357     event TransferOwnership(address _from, address _to);
358 
359     constructor() public {
360         owner = msg.sender;
361         emit TransferOwnership(address(0), msg.sender);
362     }
363 
364     modifier onlyOwner() {
365         require(msg.sender == owner, "only owner");
366         _;
367     }
368 
369     function setOwner(address _owner) external onlyOwner {
370         emit TransferOwnership(owner, _owner);
371         owner = _owner;
372     }
373 }
374 
375 
376 contract Family is Ownable {
377     using Farm for Farm.Family;
378 
379     Farm.Family private family;
380 
381     event JoinFamily(address indexed _address, uint256 _balance, uint256 _prevSize);
382     event LeaveFamily(address indexed _address, uint256 _balance, uint256 _prevSize);
383 
384     uint256 public constant TOP_SIZE = 100;
385 
386     constructor() public {
387         family.initialize();
388     }
389 
390     function topSize() external pure returns (uint256) {
391         return TOP_SIZE;
392     }
393 
394     function addressAt(uint256 _i) external view returns (address addr) {
395         (addr,) = family.entry(_i);
396     }
397 
398     function indexOf(address _addr) external view returns (uint256) {
399         return family.index[_addr];
400     }
401 
402     function entry(uint256 _i) external view returns (address, uint256) {
403         return family.entry(_i);
404     }
405 
406     function top() external view returns (address, uint256) {
407         return family.top();
408     }
409 
410     function size() external view returns (uint256) {
411         return family.size();
412     }
413 
414     function update(address _addr, uint256 _new) external onlyOwner {
415         uint256 _size = family.size();
416 
417         if (_size == 0) {
418             emit JoinFamily(_addr, _new, 0);
419             family.insert(_addr, _new);
420             return;
421         }
422 
423         (, uint256 lastBal) = family.top();
424 
425         if (family.has(_addr)) {
426             family.update(_addr, _new);
427             if (_new == 0) {
428                 family.popTop();
429                 emit LeaveFamily(_addr, 0, _size);
430             }
431         } else {
432             if (_new != 0 && (_size < TOP_SIZE || lastBal < _new)) {
433                 if (_size >= TOP_SIZE) {
434                     (address _poped, uint256 _balance) = family.popTop();
435                     emit LeaveFamily(_poped, _balance, _size);
436                 }
437                 family.insert(_addr, _new);
438                 emit JoinFamily(_addr, _new, _size);
439             }
440         }
441     }
442 }
443 
444 
445 contract Mafia is Ownable, GasPump, IERC20 {
446     using DistributedStorage for bytes32;
447     using SafeMath for uint256;
448 
449     event Winner(address indexed _addr, uint256 _value);
450     event SetName(string _prev, string _new);
451     event SetExtraGas(uint256 _prev, uint256 _new);
452     event SetFamily(address _prev, address _new);
453     event WhitelistFrom(address _addr, bool _whitelisted);
454     event WhitelistTo(address _addr, bool _whitelisted);
455 
456     uint256 public totalSupply;
457     bytes32 private constant BALANCE_KEY = keccak256("balance");
458     uint256 public constant FEE = 100;
459 
460     string public name = "Mafia.Network";
461     string public constant symbol = "MAFI";
462     uint8 public constant decimals = 18;
463     mapping(address => bool) public whitelistFrom;
464     mapping(address => bool) public whitelistTo;
465 
466     Family public family;
467     uint256 public extraGas;
468     bool inited;
469 
470     function init(
471         address _to,
472         uint256 _amount
473     ) external {
474         assert(!inited);
475         inited = true;
476         assert(totalSupply == 0);
477         assert(address(family) == address(0));
478         family = new Family();
479         emit SetFamily(address(0), address(family));
480         extraGas = 15;
481         emit SetExtraGas(0, extraGas);
482         emit Transfer(address(0), _to, _amount);
483         _setBalance(_to, _amount);
484         totalSupply = _amount;
485     }
486 
487 
488     function _toKey(address a) internal pure returns (bytes32) {
489         return bytes32(uint256(a));
490     }
491 
492     function _balanceOf(address _addr) internal view returns (uint256) {
493         return uint256(_toKey(_addr).read(BALANCE_KEY));
494     }
495 
496     function _allowance(address _addr, address _spender) internal view returns (uint256) {
497         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
498     }
499 
500     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
501         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
502     }
503 
504     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
505         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
506     }
507 
508     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
509         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
510     }
511 
512     function _setBalance(address _addr, uint256 _balance) internal {
513         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
514         family.update(_addr, _balance);
515     }
516 
517     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
518         return whitelistFrom[_from]||whitelistTo[_to];
519     }
520 
521     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
522         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
523         return rand % (_max + 1);
524     }
525 
526     function _pickWinner(address _from, uint256 _value) internal returns (address winner) {
527         uint256 magnitude = Math.orderOfMagnitude(_value);
528         uint256 nonce = _nonce(_from, magnitude);
529         _setNonce(_from, magnitude, nonce + 1);
530         winner = family.addressAt(_random(_from, nonce, magnitude, family.size() - 1));
531     }
532 
533     function _transferFrom(address _operator, address _from, address _to, uint256 _value, bool _payFee) internal {
534         if (_value == 0) {
535             emit Transfer(_from, _to, 0);
536             return;
537         }
538 
539         uint256 balanceFrom = _balanceOf(_from);
540         require(balanceFrom >= _value, "balance not enough");
541 
542         if (_from != _operator) {
543             uint256 allowanceFrom = _allowance(_from, _operator);
544             if (allowanceFrom != uint(-1)) {
545                 require(allowanceFrom >= _value, "allowance not enough");
546                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
547             }
548         }
549 
550         uint256 receive = _value;
551         uint256 burn = 0;
552         uint256 mafi = 0;
553 
554         _setBalance(_from, balanceFrom.sub(_value));
555 
556         if (_payFee || !_isWhitelisted(_from, _to)) {
557             burn = _value.divRound(FEE);
558             mafi = _value == 1 ? 0 : burn;
559             receive = receive.sub(burn.add(mafi));
560             totalSupply = totalSupply.sub(burn);
561             emit Transfer(_from, address(0), burn);
562 
563             address winner = _pickWinner(_from, _value);
564             _setBalance(winner, _balanceOf(winner).add(mafi));
565             emit Winner(winner, mafi);
566             emit Transfer(_from, winner, mafi);
567         }
568 
569         assert(burn.add(mafi).add(receive) == _value);
570 
571         _setBalance(_to, _balanceOf(_to).add(receive));
572         emit Transfer(_from, _to, receive);
573     }
574 
575     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
576         emit WhitelistTo(_addr, _whitelisted);
577         whitelistTo[_addr] = _whitelisted;
578     }
579 
580     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
581         emit WhitelistFrom(_addr, _whitelisted);
582         whitelistFrom[_addr] = _whitelisted;
583     }
584 
585     function setName(string calldata _name) external onlyOwner {
586         emit SetName(name, _name);
587         name = _name;
588     }
589 
590     function setExtraGas(uint256 _gas) external onlyOwner {
591         emit SetExtraGas(extraGas, _gas);
592         extraGas = _gas;
593     }
594 
595     function setFamily(Family _family) external onlyOwner {
596         emit SetFamily(address(family), address(_family));
597         family = _family;
598     }
599 
600     function topSize() external view returns (uint256) {
601         return family.topSize();
602     }
603 
604     function familySize() external view returns (uint256) {
605         return family.size();
606     }
607 
608     function familyEntry(uint256 _i) external view returns (address, uint256) {
609         return family.entry(_i);
610     }
611 
612     function familyTop() external view returns (address, uint256) {
613         return family.top();
614     }
615 
616     function familyIndex(address _addr) external view returns (uint256) {
617         return family.indexOf(_addr);
618     }
619 
620     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
621         return _nonce(_addr, _cat);
622     }
623 
624     function balanceOf(address _addr) external view returns (uint256) {
625         return _balanceOf(_addr);
626     }
627 
628     function allowance(address _addr, address _spender) external view returns (uint256) {
629         return _allowance(_addr, _spender);
630     }
631 
632     function approve(address _spender, uint256 _value) external returns (bool) {
633         emit Approval(msg.sender, _spender, _value);
634         _setAllowance(msg.sender, _spender, _value);
635         return true;
636     }
637 
638     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
639         _transferFrom(msg.sender, msg.sender, _to, _value, false);
640         return true;
641     }
642 
643     function transferWithFee(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
644         _transferFrom(msg.sender, msg.sender, _to, _value, true);
645         return true;
646     }
647 
648     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
649         _transferFrom(msg.sender, _from, _to, _value, false);
650         return true;
651     }
652 
653     function transferFromWithFee(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
654         _transferFrom(msg.sender, _from, _to, _value, true);
655         return true;
656     }
657 }