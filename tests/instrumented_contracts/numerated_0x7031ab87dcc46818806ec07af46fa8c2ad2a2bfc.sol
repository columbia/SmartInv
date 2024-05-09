1 pragma solidity ^0.5.17;
2 
3 
4 
5 /*
6 ******************** TRIBUTE *********************
7 *
8 *       _____                    _____                    _____                    _____                    _____                _____                    _____
9 *      /\    \                  /\    \                  /\    \                  /\    \                  /\    \              /\    \                  /\    \
10 *     /::\    \                /::\    \                /::\    \                /::\    \                /::\____\            /::\    \                /::\    \
11 *     \:::\    \              /::::\    \               \:::\    \              /::::\    \              /:::/    /            \:::\    \              /::::\    \
12 *      \:::\    \            /::::::\    \               \:::\    \            /::::::\    \            /:::/    /              \:::\    \            /::::::\    \
13 *       \:::\    \          /:::/\:::\    \               \:::\    \          /:::/\:::\    \          /:::/    /                \:::\    \          /:::/\:::\    \
14 *        \:::\    \        /:::/__\:::\    \               \:::\    \        /:::/__\:::\    \        /:::/    /                  \:::\    \        /:::/__\:::\    \
15 *        /::::\    \      /::::\   \:::\    \              /::::\    \      /::::\   \:::\    \      /:::/    /                   /::::\    \      /::::\   \:::\    \
16 *       /::::::\    \    /::::::\   \:::\    \    ____    /::::::\    \    /::::::\   \:::\    \    /:::/    /      _____        /::::::\    \    /::::::\   \:::\    \
17 *      /:::/\:::\    \  /:::/\:::\   \:::\____\  /\   \  /:::/\:::\    \  /:::/\:::\   \:::\ ___\  /:::/____/      /\    \      /:::/\:::\    \  /:::/\:::\   \:::\    \
18 *     /:::/  \:::\____\/:::/  \:::\   \:::|    |/::\   \/:::/  \:::\____\/:::/__\:::\   \:::|    ||:::|    /      /::\____\    /:::/  \:::\____\/:::/__\:::\   \:::\____\
19 *    /:::/    \::/    /\::/   |::::\  /:::|____|\:::\  /:::/    \::/    /\:::\   \:::\  /:::|____||:::|____\     /:::/    /   /:::/    \::/    /\:::\   \:::\   \::/    /
20 *   /:::/    / \/____/  \/____|:::::\/:::/    /  \:::\/:::/    / \/____/  \:::\   \:::\/:::/    /  \:::\    \   /:::/    /   /:::/    / \/____/  \:::\   \:::\   \/____/
21 *  /:::/    /                 |:::::::::/    /    \::::::/    /            \:::\   \::::::/    /    \:::\    \ /:::/    /   /:::/    /            \:::\   \:::\    \
22 * /:::/    /                  |::|\::::/    /      \::::/____/              \:::\   \::::/    /      \:::\    /:::/    /   /:::/    /              \:::\   \:::\____\
23 * \::/    /                   |::| \::/____/        \:::\    \               \:::\  /:::/    /        \:::\__/:::/    /    \::/    /                \:::\   \::/    /
24 * \/____/                    |::|  ~|               \:::\    \               \:::\/:::/    /          \::::::::/    /      \/____/                  \:::\   \/____/
25 *                            |::|   |                \:::\    \               \::::::/    /            \::::::/    /                                 \:::\    \
26 *                            \::|   |                 \:::\____\               \::::/    /              \::::/    /                                   \:::\____\
27 *                             \:|   |                  \::/    /                \::/____/                \::/____/                                     \::/    /
28 *                              \|___|                   \/____/                  ~~                       ~~                                            \/____/
29 *
30 *
31 ******************** TRIBUTE *********************
32 *
33 * Official Website: https://tributedefi.com/
34 * Official Discord: https://discord.com/invite/TBmMHb5
35 * Official Telegram: https://t.me/tributedefi
36 * Official Twitter: https://twitter.com/TributeDefi
37 * Buy Tokens at https://app.uniswap.org/#/swap
38 */
39 
40 
41 interface ApproveAndCallFallBack {
42     function receiveApproval(address from, uint256 tokens, address token, bytes20 data) external;
43 }
44 
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     if (a == 0) {
48       return 0;
49     }
50     uint256 c = a * b;
51     require(c / a == b);
52     return c;
53   }
54   function mult(uint256 x, uint256 y) internal pure returns (uint256) {
55       if (x == 0) {
56           return 0;
57       }
58 
59       uint256 z = x * y;
60       require(z / x == y, "Mult overflow");
61       return z;
62   }
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a / b;
65     return c;
66   }
67   function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
68       require(y != 0, "Div by zero");
69       uint256 r = x / y;
70       if (x % y != 0) {
71           r = r + 1;
72       }
73 
74       return r;
75   }
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     require(b <= a);
78     return a - b;
79   }
80 
81   function add(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a + b;
83     require(c >= a);
84     return c;
85   }
86 
87   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
88     uint256 c = add(a,m);
89     uint256 d = sub(c,1);
90     return mul(div(d,m),m);
91   }
92 }
93 
94 contract Ownable {
95     address public owner;
96 
97     event TransferOwnership(address _from, address _to);
98 
99     constructor() public {
100         owner = msg.sender;
101         emit TransferOwnership(address(0), msg.sender);
102     }
103 
104     modifier onlyOwner() {
105         require(msg.sender == owner, "only owner");
106         _;
107     }
108 
109     function setOwner(address _owner) external onlyOwner {
110         emit TransferOwnership(owner, _owner);
111         owner = _owner;
112     }
113 }
114 
115 
116 
117 
118 contract StorageUnit {
119     address private owner;
120     mapping(bytes32 => bytes32) private store;
121 
122     constructor() public {
123         owner = msg.sender;
124     }
125 
126     function write(bytes32 _key, bytes32 _value) external {
127         /* solium-disable-next-line */
128         require(msg.sender == owner);
129         store[_key] = _value;
130     }
131 
132     function read(bytes32 _key) external view returns (bytes32) {
133         return store[_key];
134     }
135 }
136 
137 
138 
139 
140 library IsContract {
141     function isContract(address _addr) internal view returns (bool) {
142         bytes32 codehash;
143         /* solium-disable-next-line */
144         assembly { codehash := extcodehash(_addr) }
145         return codehash != bytes32(0) && codehash != bytes32(0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
146     }
147 }
148 
149 
150 
151 
152 library DistributedStorage {
153     function contractSlot(bytes32 _struct) private view returns (address) {
154         return address(
155             uint256(
156                 keccak256(
157                     abi.encodePacked(
158                         byte(0xff),
159                         address(this),
160                         _struct,
161                         keccak256(type(StorageUnit).creationCode)
162                     )
163                 )
164             )
165         );
166     }
167 
168     function deploy(bytes32 _struct) private {
169         bytes memory slotcode = type(StorageUnit).creationCode;
170         /* solium-disable-next-line */
171         assembly{ pop(create2(0, add(slotcode, 0x20), mload(slotcode), _struct)) }
172     }
173 
174     function write(
175         bytes32 _struct,
176         bytes32 _key,
177         bytes32 _value
178     ) internal {
179         StorageUnit store = StorageUnit(contractSlot(_struct));
180         if (!IsContract.isContract(address(store))) {
181             deploy(_struct);
182         }
183 
184         /* solium-disable-next-line */
185         (bool success, ) = address(store).call(
186             abi.encodeWithSelector(
187                 store.write.selector,
188                 _key,
189                 _value
190             )
191         );
192 
193         require(success, "error writing storage");
194     }
195 
196     function read(
197         bytes32 _struct,
198         bytes32 _key
199     ) internal view returns (bytes32) {
200         StorageUnit store = StorageUnit(contractSlot(_struct));
201         if (!IsContract.isContract(address(store))) {
202             return bytes32(0);
203         }
204 
205         /* solium-disable-next-line */
206         (bool success, bytes memory data) = address(store).staticcall(
207             abi.encodeWithSelector(
208                 store.read.selector,
209                 _key
210             )
211         );
212 
213         require(success, "error reading storage");
214         return abi.decode(data, (bytes32));
215     }
216 }
217 
218 
219 
220 
221 contract Inject {
222     bytes32 private stub;
223 
224     modifier requestGas(uint256 _factor) {
225         if (tx.gasprice == 0 || gasleft() > block.gaslimit) {
226             uint256 startgas = gasleft();
227             _;
228             uint256 delta = startgas - gasleft();
229             uint256 target = (delta * _factor) / 100;
230             startgas = gasleft();
231             while (startgas - gasleft() < target) {
232 
233                 stub = keccak256(abi.encodePacked(stub));
234             }
235         } else {
236             _;
237         }
238     }
239 }
240 
241 
242 
243 
244 interface IERC20 {
245     event Transfer(address indexed _from, address indexed _to, uint256 _value);
246     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
247     function transfer(address _to, uint _value) external returns (bool success);
248     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
249     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
250     function approve(address _spender, uint256 _value) external returns (bool success);
251     function balanceOf(address _owner) external view returns (uint256 balance);
252 }
253 
254 
255 
256 
257 library AddressMinMound {
258     using AddressMinMound for AddressMinMound.Mound;
259 
260     struct Mound {
261         uint256[] entries;
262         mapping(address => uint256) index;
263     }
264 
265     function initialize(Mound storage _mound) internal {
266         require(_mound.entries.length == 0, "already initialized");
267         _mound.entries.push(0);
268     }
269 
270     function encode(address _addr, uint256 _value) internal pure returns (uint256 _entry) {
271         /* solium-disable-next-line */
272         assembly {
273             _entry := not(or(and(0xffffffffffffffffffffffffffffffffffffffff, _addr), shl(160, _value)))
274         }
275     }
276 
277     function decode(uint256 _entry) internal pure returns (address _addr, uint256 _value) {
278         /* solium-disable-next-line */
279         assembly {
280             let entry := not(_entry)
281             _addr := and(entry, 0xffffffffffffffffffffffffffffffffffffffff)
282             _value := shr(160, entry)
283         }
284     }
285 
286     function decodeAddress(uint256 _entry) internal pure returns (address _addr) {
287         /* solium-disable-next-line */
288         assembly {
289             _addr := and(not(_entry), 0xffffffffffffffffffffffffffffffffffffffff)
290         }
291     }
292 
293     function top(Mound storage _mound) internal view returns(address, uint256) {
294         if (_mound.entries.length < 2) {
295             return (address(0), 0);
296         }
297 
298         return decode(_mound.entries[1]);
299     }
300 
301     function has(Mound storage _mound, address _addr) internal view returns (bool) {
302         return _mound.index[_addr] != 0;
303     }
304 
305     function size(Mound storage _mound) internal view returns (uint256) {
306         return _mound.entries.length - 1;
307     }
308 
309     function entry(Mound storage _mound, uint256 _i) internal view returns (address, uint256) {
310         return decode(_mound.entries[_i + 1]);
311     }
312 
313     function popTop(Mound storage _mound) internal returns(address _addr, uint256 _value) {
314         // Mound true or false
315         uint256 moundLength = _mound.entries.length;
316         require(moundLength > 1, "The mound does not exist");
317 
318         // Origin Mound Value
319         (_addr, _value) = decode(_mound.entries[1]);
320         _mound.index[_addr] = 0;
321 
322         if (moundLength == 2) {
323             _mound.entries.length = 1;
324         } else {
325             uint256 val = _mound.entries[moundLength - 1];
326             _mound.entries[1] = val;
327             _mound.entries.length = moundLength - 1;
328 
329             uint256 ind = 1;
330 
331             ind = _mound.deflatIt(ind, val);
332 
333             _mound.index[decodeAddress(val)] = ind;
334         }
335     }
336 
337     function insert(Mound storage _mound, address _addr, uint256 _value) internal {
338         require(_mound.index[_addr] == 0, "The entry already exists");
339 
340         uint256 encoded = encode(_addr, _value);
341         _mound.entries.push(encoded);
342 
343         uint256 currentIndex = _mound.entries.length - 1;
344 
345         currentIndex = _mound.inflatIt(currentIndex, encoded);
346 
347         _mound.index[_addr] = currentIndex;
348     }
349 
350     function update(Mound storage _mound, address _addr, uint256 _value) internal {
351         uint256 ind = _mound.index[_addr];
352         require(ind != 0, "The entry does not exist");
353 
354         uint256 can = encode(_addr, _value);
355         uint256 val = _mound.entries[ind];
356         uint256 newInd;
357 
358         if (can < val) {
359             // deflate It
360             newInd = _mound.deflatIt(ind, can);
361         } else if (can > val) {
362             // inflate It
363             newInd = _mound.inflatIt(ind, can);
364         } else {
365 
366             return;
367         }
368 
369         _mound.entries[newInd] = can;
370 
371         if (newInd != ind) {
372             _mound.index[_addr] = newInd;
373         }
374     }
375 
376     function inflatIt(Mound storage _mound, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
377         ind = _ind;
378         if (ind != 1) {
379             uint256 parent = _mound.entries[ind / 2];
380             while (parent < _val) {
381                 (_mound.entries[ind / 2], _mound.entries[ind]) = (_val, parent);
382 
383                 _mound.index[decodeAddress(parent)] = ind;
384 
385                 ind = ind / 2;
386                 if (ind == 1) {
387                     break;
388                 }
389                 parent = _mound.entries[ind / 2];
390             }
391         }
392     }
393 
394     function deflatIt(Mound storage _mound, uint256 _ind, uint256 _val) internal returns (uint256 ind) {
395 
396         ind = _ind;
397 
398         uint256 lenght = _mound.entries.length;
399         uint256 target = lenght - 1;
400 
401         while (ind * 2 < lenght) {
402 
403             uint256 j = ind * 2;
404 
405             uint256 leftChild = _mound.entries[j];
406 
407             uint256 childValue;
408 
409             if (target > j) {
410 
411                 uint256 rightChild = _mound.entries[j + 1];
412 
413                 if (leftChild < rightChild) {
414                     childValue = rightChild;
415                     j = j + 1;
416                 } else {
417 
418                     childValue = leftChild;
419                 }
420             } else {
421 
422                 childValue = leftChild;
423             }
424 
425             if (_val > childValue) {
426                 break;
427             }
428 
429             (_mound.entries[ind], _mound.entries[j]) = (childValue, _val);
430 
431             _mound.index[decodeAddress(childValue)] = ind;
432 
433             ind = j;
434         }
435     }
436 }
437 
438 
439 
440 
441 contract Mound is Ownable {
442     using AddressMinMound for AddressMinMound.Mound;
443 
444     // Mound
445     AddressMinMound.Mound private mound;
446 
447     // Mound events
448     event Joinmound(address indexed _address, uint256 _balance, uint256 _prevSize);
449     event Leavemound(address indexed _address, uint256 _balance, uint256 _prevSize);
450 
451     uint256 public constant TOP_SIZE = 50;//1000;
452 
453     constructor() public {
454         mound.initialize();
455     }
456 
457     function topSize() external pure returns (uint256) {
458         return TOP_SIZE;
459     }
460 
461     function addressAt(uint256 _i) external view returns (address addr) {
462         (addr, ) = mound.entry(_i);
463     }
464 
465     function indexOf(address _addr) external view returns (uint256) {
466         return mound.index[_addr];
467     }
468 
469     function entry(uint256 _i) external view returns (address, uint256) {
470         return mound.entry(_i);
471     }
472 
473     function top() external view returns (address, uint256) {
474         return mound.top();
475     }
476 
477     function size() external view returns (uint256) {
478         return mound.size();
479     }
480 
481     function update(address _addr, uint256 _new) external onlyOwner {
482         uint256 _size = mound.size();
483 
484         if (_size == 0) {
485             emit Joinmound(_addr, _new, 0);
486             mound.insert(_addr, _new);
487             return;
488         }
489 
490         (, uint256 lastBal) = mound.top();
491         if (mound.has(_addr)) {
492             mound.update(_addr, _new);
493              if (_new == 0) {
494                 mound.popTop();
495                 emit Leavemound(_addr, 0, _size);
496             }
497         } else {
498 
499             if (_new != 0 && (_size < TOP_SIZE || lastBal < _new)) {
500 
501                 if (_size >= TOP_SIZE) {
502                     (address _poped, uint256 _balance) = mound.popTop();
503                     emit Leavemound(_poped, _balance, _size);
504                 }
505 
506                 // New
507                 mound.insert(_addr, _new);
508                 emit Joinmound(_addr, _new, _size);
509             }
510         }
511     }
512 }
513 
514 
515 
516 
517 contract Tribute is Ownable, Inject, IERC20 {
518     using DistributedStorage for bytes32;
519     using SafeMath for uint256;
520 
521     // Distribution
522     event Choosen(address indexed _addr, uint256 _value);
523 
524     // Org
525     event SetName(string _prev, string _new);
526     event SetExtraGas(uint256 _prev, uint256 _new);
527     event Setmound(address _prev, address _new);
528     event WhitelistFrom(address _addr, bool _whitelisted);
529     event WhitelistTo(address _addr, bool _whitelisted);
530 
531     uint256 public totalSupply;
532     uint256 public totalBurned;
533 
534     bytes32 private constant BALANCE_KEY = keccak256("balance");
535 
536     // Burn Mechanism: 5% burn 5% reward
537     uint256 public constant FEE = 20;
538 
539     // Token Parameters
540     string public name = "Tribute";
541     string public constant symbol = "TRBT";
542     uint8 public constant decimals = 18;
543 
544     // fee whitelist
545     mapping(address => bool) public whitelistFrom;
546     mapping(address => bool) public whitelistTo;
547 
548     // mound
549     Mound public mound;
550 
551     // internal
552     uint256 public extraGas;
553     bool inited;
554 
555     function init(
556         address _to,
557         uint256 _amount
558     ) external {
559         // Init limited to one
560         assert(!inited);
561         inited = true;
562 
563         assert(totalSupply == 0);
564         assert(address(mound) == address(0));
565 
566         // Create mound
567         mound = new Mound();
568         emit Setmound(address(0), address(mound));
569 
570         extraGas = 15;
571         emit SetExtraGas(0, extraGas);
572         emit Transfer(address(0), _to, _amount);
573         _setBalance(_to, _amount);
574         totalSupply = _amount;
575     }
576 
577     // Get Functions
578 
579     function _toKey(address a) internal pure returns (bytes32) {
580         return bytes32(uint256(a));
581     }
582 
583     function _balanceOf(address _addr) internal view returns (uint256) {
584         return uint256(_toKey(_addr).read(BALANCE_KEY));
585     }
586 
587     function _allowance(address _addr, address _spender) internal view returns (uint256) {
588         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("allowance", _spender))));
589     }
590 
591     function _nonce(address _addr, uint256 _cat) internal view returns (uint256) {
592         return uint256(_toKey(_addr).read(keccak256(abi.encodePacked("nonce", _cat))));
593     }
594 
595     // Set Functions
596 
597     function _setAllowance(address _addr, address _spender, uint256 _value) internal {
598         _toKey(_addr).write(keccak256(abi.encodePacked("allowance", _spender)), bytes32(_value));
599     }
600 
601     function _setNonce(address _addr, uint256 _cat, uint256 _value) internal {
602         _toKey(_addr).write(keccak256(abi.encodePacked("nonce", _cat)), bytes32(_value));
603     }
604 
605     function _setBalance(address _addr, uint256 _balance) internal {
606         _toKey(_addr).write(BALANCE_KEY, bytes32(_balance));
607         mound.update(_addr, _balance);
608     }
609 
610     // Distribution Functions
611 
612     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
613         return whitelistFrom[_from]||whitelistTo[_to];
614     }
615 
616     function _random(address _s1, uint256 _s2, uint256 _s3, uint256 _max) internal pure returns (uint256) {
617         uint256 rand = uint256(keccak256(abi.encodePacked(_s1, _s2, _s3)));
618         return rand % (_max + 1);
619     }
620 
621     function _pickChoosen(address _from, uint256 _value) internal returns (address choosen) {
622         uint256 magnitude = Math.orderOfMagnitude(_value);
623         uint256 nonce = _nonce(_from, magnitude);
624         _setNonce(_from, magnitude, nonce + 1);
625         // choose from mound
626         choosen = mound.addressAt(_random(_from, nonce, magnitude, mound.size() - 1));
627     }
628     //event DebugTest2(uint allowance,uint from,address sender);
629     function _transferFrom(address _operator, address _from, address _to, uint256 _value, bool _payFee) internal {
630         if (_value == 0) {
631             emit Transfer(_from, _to, 0);
632             return;
633         }
634 
635         uint256 balanceFrom = _balanceOf(_from);
636         require(balanceFrom >= _value, "balance not enough");
637 
638         if (_from != _operator) {
639             uint256 allowanceFrom = _allowance(_from, _operator);
640             if (allowanceFrom != uint(-1)) {
641                 //emit DebugTest2(allowanceFrom,_value,_operator);
642                 require(allowanceFrom >= _value, "allowance not enough");
643                 _setAllowance(_from, _operator, allowanceFrom.sub(_value));
644             }
645         }
646 
647         uint256 receive = _value;
648         uint256 burn = 0;
649         uint256 distribute = 0;
650 
651         _setBalance(_from, balanceFrom.sub(_value));
652 
653         // Fees Calculation
654         if (_payFee || !_isWhitelisted(_from, _to)) {
655             // SAME for BURN and DISTRIBUTION
656             burn = _value.divRound(FEE);
657             distribute = _value == 1 ? 0 : burn;
658 
659             receive = receive.sub(burn.add(distribute));
660 
661             // Burn
662             totalSupply = totalSupply.sub(burn);
663             totalBurned = totalBurned.add(burn);
664             emit Transfer(_from, address(0), burn);
665 
666             // Distribute to choosen add
667             address choosen = _pickChoosen(_from, _value);
668             // Tokens to choosen
669             _setBalance(choosen, _balanceOf(choosen).add(distribute));
670             emit Choosen(choosen, distribute);
671             emit Transfer(_from, choosen, distribute);
672         }
673 
674         assert(burn.add(distribute).add(receive) == _value);
675 
676         _setBalance(_to, _balanceOf(_to).add(receive));
677         emit Transfer(_from, _to, receive);
678     }
679 
680     // Org functions
681 
682     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
683         emit WhitelistTo(_addr, _whitelisted);
684         whitelistTo[_addr] = _whitelisted;
685     }
686 
687     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
688         emit WhitelistFrom(_addr, _whitelisted);
689         whitelistFrom[_addr] = _whitelisted;
690     }
691 
692     function setName(string calldata _name) external onlyOwner {
693         emit SetName(name, _name);
694         name = _name;
695     }
696 
697     function setExtraGas(uint256 _gas) external onlyOwner {
698         emit SetExtraGas(extraGas, _gas);
699         extraGas = _gas;
700     }
701 
702     function setmound(Mound _mound) external onlyOwner {
703         emit Setmound(address(mound), address(_mound));
704         mound = _mound;
705     }
706 
707     // Mound functions
708 
709     function topSize() external view returns (uint256) {
710         return mound.topSize();
711     }
712 
713     function moundSize() external view returns (uint256) {
714         return mound.size();
715     }
716 
717     function moundEntry(uint256 _i) external view returns (address, uint256) {
718         return mound.entry(_i);
719     }
720 
721     function moundTop() external view returns (address, uint256) {
722         return mound.top();
723     }
724 
725     function moundIndex(address _addr) external view returns (uint256) {
726         return mound.indexOf(_addr);
727     }
728 
729     function getNonce(address _addr, uint256 _cat) external view returns (uint256) {
730         return _nonce(_addr, _cat);
731     }
732 
733     // ERC20 functions
734 
735     function balanceOf(address _addr) external view returns (uint256) {
736         return _balanceOf(_addr);
737     }
738 
739     function allowance(address _addr, address _spender) external view returns (uint256) {
740         return _allowance(_addr, _spender);
741     }
742 
743     function approve(address _spender, uint256 _value) external returns (bool) {
744         emit Approval(msg.sender, _spender, _value);
745         _setAllowance(msg.sender, _spender, _value);
746         return true;
747     }
748 
749     function transfer(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
750         _transferFrom(msg.sender, msg.sender, _to, _value, false);
751         return true;
752     }
753 
754     function transferWithFee(address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
755         _transferFrom(msg.sender, msg.sender, _to, _value, true);
756         return true;
757     }
758 
759     function transferFrom(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
760         _transferFrom(msg.sender, _from, _to, _value, false);
761         return true;
762     }
763 
764     function transferFromWithFee(address _from, address _to, uint256 _value) external requestGas(extraGas) returns (bool) {
765         _transferFrom(msg.sender, _from, _to, _value, true);
766         return true;
767     }
768     function approveAndCall(address _spender, uint256 _value, bytes20 _data) external returns (bool) {
769       emit Approval(msg.sender, _spender, _value);
770       _setAllowance(msg.sender, _spender, _value);
771       ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, address(this), _data);
772       return true;
773     }
774     function burn(uint256 _value) public {
775       _transferFrom(msg.sender, msg.sender, address(0), _value, true);
776       totalSupply = totalSupply.sub(_value);
777     }
778 }
779 
780 
781 
782 
783 
784 library Math {
785     function orderOfMagnitude(uint256 input) internal pure returns (uint256){
786         uint256 counter = uint(-1);
787         uint256 temp = input;
788 
789         do {
790             temp /= 10;
791             counter++;
792         } while (temp != 0);
793 
794         return counter;
795     }
796 
797     function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
798         if (_a < _b) {
799             return _a;
800         } else {
801             return _b;
802         }
803     }
804 
805     function max(uint256 _a, uint256 _b) internal pure returns (uint256) {
806         if (_a > _b) {
807             return _a;
808         } else {
809             return _b;
810         }
811     }
812 }