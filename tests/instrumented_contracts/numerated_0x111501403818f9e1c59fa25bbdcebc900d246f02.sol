1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 
53 library KeysUtils {
54     // Such order is important to load from state
55     struct Object {
56         uint32 gasPriceGwei;
57         uint32 gasLimit;
58         uint32 timestamp;
59         address contractAddress;
60     }
61 
62     function toKey(Object _obj) internal pure returns (bytes32) {
63         return toKey(_obj.contractAddress, _obj.timestamp, _obj.gasLimit, _obj.gasPriceGwei);
64     }
65 
66     function toKeyFromStorage(Object storage _obj) internal view returns (bytes32 _key) {
67         assembly {
68             _key := sload(_obj_slot)
69         }
70     }
71 
72     function toKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal pure returns (bytes32 result) {
73         result = 0x0000000000000000000000000000000000000000000000000000000000000000;
74         //         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - address (20 bytes)
75         //                                                 ^^^^^^^^ - timestamp (4 bytes)
76         //                                                         ^^^^^^^^ - gas limit (4 bytes)
77         //                                                                 ^^^^^^^^ - gas price (4 bytes)
78         assembly {
79             result := or(result, mul(_address, 0x1000000000000000000000000))
80             result := or(result, mul(and(_timestamp, 0xffffffff), 0x10000000000000000))
81             result := or(result, mul(and(_gasLimit, 0xffffffff), 0x100000000))
82             result := or(result, and(_gasPrice, 0xffffffff))
83         }
84     }
85 
86     function toMemoryObject(bytes32 _key, Object memory _dest) internal pure {
87         assembly {
88             mstore(_dest, and(_key, 0xffffffff))
89             mstore(add(_dest, 0x20), and(div(_key, 0x100000000), 0xffffffff))
90             mstore(add(_dest, 0x40), and(div(_key, 0x10000000000000000), 0xffffffff))
91             mstore(add(_dest, 0x60), div(_key, 0x1000000000000000000000000))
92         }
93     }
94 
95     function toObject(bytes32 _key) internal pure returns (Object memory _dest) {
96         toMemoryObject(_key, _dest);
97     }
98 
99     function toStateObject(bytes32 _key, Object storage _dest) internal {
100         assembly {
101             sstore(_dest_slot, _key)
102         }
103     }
104 
105     function getTimestamp(bytes32 _key) internal pure returns (uint result) {
106         assembly {
107             result := and(div(_key, 0x10000000000000000), 0xffffffff)
108         }
109     }
110 }
111 
112 contract TransferToken is Ownable {
113     function transferToken(ERC20Basic _token, address _to, uint _value) public onlyOwner {
114         _token.transfer(_to, _value);
115     }
116 }
117 
118 
119 contract JouleProxyAPI {
120     /**
121      * Function hash is: 0x73027f6d
122      */
123     function callback(address _contract) public;
124 }
125 
126 contract CheckableContract {
127     event Checked();
128     /*
129      * Function hash is 0x919840ad.
130      */
131     function check() public;
132 }
133 
134 
135 contract JouleAPI {
136     event Invoked(address indexed _address, bool _status, uint _usedGas);
137     event Registered(address indexed _address, uint _timestamp, uint _gasLimit, uint _gasPrice);
138 
139     /**
140      * @dev Registers the specified contract to invoke at the specified time with the specified gas and price.
141      * @notice It required amount of ETH as value, to cover gas usage. See getPrice method.
142      *
143      * @param _address Contract's address. Contract MUST implements Checkable interface.
144      * @param _timestamp Timestamp at what moment contract should be called. It MUST be in future.
145      * @param _gasLimit Gas which will be posted to call.
146      * @param _gasPrice Gas price which is recommended to use for this invocation.
147      */
148     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint);
149 
150     /**
151      * @dev Invokes next contracts in the queue.
152      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
153      * @return Reward amount.
154      */
155     function invoke() public returns (uint);
156 
157     /**
158      * @dev Invokes the top contract in the queue.
159      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
160      * @return Reward amount.
161      */
162     function invokeTop() public returns (uint);
163 
164     /**
165      * @dev Calculates required to register amount of WEI.
166      *
167      * @param _gasLimit Gas which will be posted to call.
168      * @param _gasPrice Gas price which is recommended to use for this invocation.
169      * @return Amount in wei.
170      */
171     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint);
172 
173     /**
174      * @dev Gets how many contracts are registered (and not invoked).
175      */
176     function getCount() public view returns (uint);
177 
178     /**
179      * @dev Gets top contract (the next to invoke).
180      *
181      * @return contractAddress  The contract address.
182      * @return timestamp        The invocation timestamp.
183      * @return gasLimit         The invocation maximum gas.
184      * @return gasPrice         The invocation expected price.
185      */
186     function getTop() external view returns (
187         address contractAddress,
188         uint timestamp,
189         uint gasLimit,
190         uint gasPrice
191     );
192 
193     /**
194      * @dev Gets top _count contracts (in order to invoke).
195      *
196      * @param _count        How many records will be returned.
197      * @return addresses    The contracts addresses.
198      * @return timestamps   The invocation timestamps.
199      * @return gasLimits    The invocation gas limits.
200      * @return gasPrices    The invocation expected prices.
201      */
202     function getTop(uint _count) external view returns (
203         address[] addresses,
204         uint[] timestamps,
205         uint[] gasLimits,
206         uint[] gasPrices
207     );
208 
209     /**
210      * @dev Gets actual code version.
211      * @return Code version. Mask: 0xff.0xff.0xffff-0xffffffff (major.minor.build-hash)
212      */
213     function getVersion() external view returns (bytes8);
214 }
215 
216 
217 
218 contract usingConsts {
219     uint constant GWEI = 0.001 szabo;
220     // this value influence to the reward price! do not change for already registered contracts!
221     uint constant IDLE_GAS = 22273;
222     uint constant MAX_GAS = 4000000;
223     // Code version
224     bytes8 constant VERSION = 0x0100001300000000;
225     //                        ^^ - major
226     //                          ^^ - minor
227     //                            ^^^^ - build
228     //                                ^^^^^^^^ - git hash
229 }
230 
231 
232 contract JouleIndex {
233     using KeysUtils for bytes32;
234     uint constant YEAR = 0x1DFE200;
235 
236     // year -> month -> day -> hour
237     mapping (bytes32 => bytes32) index;
238     bytes32 head;
239 
240     function insert(bytes32 _key) public {
241         uint timestamp = _key.getTimestamp();
242         bytes32 year = toKey(timestamp, YEAR);
243         bytes32 headLow;
244         bytes32 headHigh;
245         (headLow, headHigh) = fromValue(head);
246         if (year < headLow || headLow == 0 || year > headHigh) {
247             if (year < headLow || headLow == 0) {
248                 headLow = year;
249             }
250             if (year > headHigh) {
251                 headHigh = year;
252             }
253             head = toValue(headLow, headHigh);
254         }
255 
256         bytes32 week = toKey(timestamp, 1 weeks);
257         bytes32 low;
258         bytes32 high;
259         (low, high) = fromValue(index[year]);
260         if (week < low || week > high) {
261             if (week < low || low == 0) {
262                 low = week;
263             }
264             if (week > high) {
265                 high = week;
266             }
267             index[year] = toValue(low, high);
268         }
269 
270         (low, high) = fromValue(index[week]);
271         bytes32 hour = toKey(timestamp, 1 hours);
272         if (hour < low || hour > high) {
273             if (hour < low || low == 0) {
274                 low = hour;
275             }
276             if (hour > high) {
277                 high = hour;
278             }
279             index[week] = toValue(low, high);
280         }
281 
282         (low, high) = fromValue(index[hour]);
283         bytes32 minute = toKey(timestamp, 1 minutes);
284         if (minute < low || minute > high) {
285             if (minute < low || low == 0) {
286                 low = minute;
287             }
288             if (minute > high) {
289                 high = minute;
290             }
291             index[hour] = toValue(low, high);
292         }
293 
294         (low, high) = fromValue(index[minute]);
295         bytes32 tsKey = toKey(timestamp);
296         if (tsKey < low || tsKey > high) {
297             if (tsKey < low || low == 0) {
298                 low = tsKey;
299             }
300             if (tsKey > high) {
301                 high = tsKey;
302             }
303             index[minute] = toValue(low, high);
304         }
305 
306         index[tsKey] = _key;
307     }
308 
309     function findFloorKeyYear(uint _timestamp, bytes32 _low, bytes32 _high) view internal returns (bytes32) {
310         bytes32 year = toKey(_timestamp, YEAR);
311         if (year < _low) {
312             return 0;
313         }
314         if (year > _high) {
315             // week
316             (low, high) = fromValue(index[_high]);
317             // hour
318             (low, high) = fromValue(index[high]);
319             // minute
320             (low, high) = fromValue(index[high]);
321             // ts
322             (low, high) = fromValue(index[high]);
323             return index[high];
324         }
325 
326         bytes32 low;
327         bytes32 high;
328 
329         while (year >= _low) {
330             (low, high) = fromValue(index[year]);
331             if (low != 0) {
332                 bytes32 key = findFloorKeyWeek(_timestamp, low, high);
333                 if (key != 0) {
334                     return key;
335                 }
336             }
337             // 0x1DFE200 = 52 weeks = 31449600
338             assembly {
339                 year := sub(year, 0x1DFE200)
340             }
341         }
342 
343         return 0;
344     }
345 
346     function findFloorKeyWeek(uint _timestamp, bytes32 _low, bytes32 _high) view internal returns (bytes32) {
347         bytes32 week = toKey(_timestamp, 1 weeks);
348         if (week < _low) {
349             return 0;
350         }
351 
352         bytes32 low;
353         bytes32 high;
354 
355         if (week > _high) {
356             // hour
357             (low, high) = fromValue(index[_high]);
358             // minute
359             (low, high) = fromValue(index[high]);
360             // ts
361             (low, high) = fromValue(index[high]);
362             return index[high];
363         }
364 
365         while (week >= _low) {
366             (low, high) = fromValue(index[week]);
367             if (low != 0) {
368                 bytes32 key = findFloorKeyHour(_timestamp, low, high);
369                 if (key != 0) {
370                     return key;
371                 }
372             }
373 
374             // 1 weeks = 604800
375             assembly {
376                 week := sub(week, 604800)
377             }
378         }
379         return 0;
380     }
381 
382 
383     function findFloorKeyHour(uint _timestamp, bytes32 _low, bytes32 _high) view internal returns (bytes32) {
384         bytes32 hour = toKey(_timestamp, 1 hours);
385         if (hour < _low) {
386             return 0;
387         }
388 
389         bytes32 low;
390         bytes32 high;
391 
392         if (hour > _high) {
393             // minute
394             (low, high) = fromValue(index[_high]);
395             // ts
396             (low, high) = fromValue(index[high]);
397             return index[high];
398         }
399 
400         while (hour >= _low) {
401             (low, high) = fromValue(index[hour]);
402             if (low != 0) {
403                 bytes32 key = findFloorKeyMinute(_timestamp, low, high);
404                 if (key != 0) {
405                     return key;
406                 }
407             }
408 
409             // 1 hours = 3600
410             assembly {
411                 hour := sub(hour, 3600)
412             }
413         }
414         return 0;
415     }
416 
417     function findFloorKeyMinute(uint _timestamp, bytes32 _low, bytes32 _high) view internal returns (bytes32) {
418         bytes32 minute = toKey(_timestamp, 1 minutes);
419         if (minute < _low) {
420             return 0;
421         }
422 
423         bytes32 low;
424         bytes32 high;
425 
426         if (minute > _high) {
427             // ts
428             (low, high) = fromValue(index[_high]);
429             return index[high];
430         }
431 
432         while (minute >= _low) {
433             (low, high) = fromValue(index[minute]);
434             if (low != 0) {
435                 bytes32 key = findFloorKeyTimestamp(_timestamp, low, high);
436                 if (key != 0) {
437                     return key;
438                 }
439             }
440 
441             // 1 minutes = 60
442             assembly {
443                 minute := sub(minute, 60)
444             }
445         }
446 
447         return 0;
448     }
449 
450     function findFloorKeyTimestamp(uint _timestamp, bytes32 _low, bytes32 _high) view internal returns (bytes32) {
451         bytes32 tsKey = toKey(_timestamp);
452         if (tsKey < _low) {
453             return 0;
454         }
455         if (tsKey > _high) {
456             return index[_high];
457         }
458 
459         while (tsKey >= _low) {
460             bytes32 key = index[tsKey];
461             if (key != 0) {
462                 return key;
463             }
464             assembly {
465                 tsKey := sub(tsKey, 1)
466             }
467         }
468         return 0;
469     }
470 
471     function findFloorKey(uint _timestamp) view public returns (bytes32) {
472 //        require(_timestamp > 0xffffffff);
473 //        if (_timestamp < 1515612415) {
474 //            return 0;
475 //        }
476 
477         bytes32 yearLow;
478         bytes32 yearHigh;
479         (yearLow, yearHigh) = fromValue(head);
480 
481         return findFloorKeyYear(_timestamp, yearLow, yearHigh);
482     }
483 
484     function toKey(uint _timestamp, uint rounder) pure internal returns (bytes32 result) {
485         // 0x0...00000000000000000
486         //        ^^^^^^^^ - rounder marker (eg, to avoid crossing first day of year with year)
487         //                ^^^^^^^^ - rounded moment (year, week, etc)
488         assembly {
489             result := or(mul(rounder, 0x100000000), mul(div(_timestamp, rounder), rounder))
490         }
491     }
492 
493     function toValue(bytes32 _lowKey, bytes32 _highKey) pure internal returns (bytes32 result) {
494         assembly {
495             result := or(mul(_lowKey, 0x10000000000000000), _highKey)
496         }
497     }
498 
499     function fromValue(bytes32 _value) pure internal returns (bytes32 _lowKey, bytes32 _highKey) {
500         assembly {
501             _lowKey := and(div(_value, 0x10000000000000000), 0xffffffffffffffff)
502             _highKey := and(_value, 0xffffffffffffffff)
503         }
504     }
505 
506 
507     function toKey(uint timestamp) pure internal returns (bytes32) {
508         return bytes32(timestamp);
509     }
510 }
511 
512 
513 contract JouleContractHolder is usingConsts {
514     using KeysUtils for bytes32;
515 //    event Found(uint timestamp);
516     uint internal length;
517     bytes32 head;
518     mapping (bytes32 => bytes32) objects;
519     JouleIndex index;
520 
521     function JouleContractHolder() public {
522         index = new JouleIndex();
523     }
524 
525     function insert(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal {
526         length ++;
527         bytes32 id = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
528         if (head == 0) {
529             head = id;
530             index.insert(id);
531 //            Found(0xffffffff);
532             return;
533         }
534         bytes32 previous = index.findFloorKey(_timestamp);
535 
536         // reject duplicate key on the end
537         require(previous != id);
538         // reject duplicate in the middle
539         require(objects[id] == 0);
540 
541         uint prevTimestamp = previous.getTimestamp();
542 //        Found(prevTimestamp);
543         uint headTimestamp = head.getTimestamp();
544         // add as head, prevTimestamp == 0 or in the past
545         if (prevTimestamp < headTimestamp) {
546             objects[id] = head;
547             head = id;
548         }
549         // add after the previous
550         else {
551             objects[id] = objects[previous];
552             objects[previous] = id;
553         }
554         index.insert(id);
555     }
556 
557     function next() internal returns (KeysUtils.Object memory _next) {
558         head = objects[head];
559         length--;
560         _next = head.toObject();
561     }
562 
563     function getCount() public view returns (uint) {
564         return length;
565     }
566 
567     function getTop(uint _count) external view returns (
568         address[] _addresses,
569         uint[] _timestamps,
570         uint[] _gasLimits,
571         uint[] _gasPrices
572     ) {
573         uint amount = _count <= length ? _count : length;
574 
575         _addresses = new address[](amount);
576         _timestamps = new uint[](amount);
577         _gasLimits = new uint[](amount);
578         _gasPrices = new uint[](amount);
579 
580         bytes32 current = head;
581         for (uint i = 0; i < amount; i ++) {
582             KeysUtils.Object memory obj = current.toObject();
583             _addresses[i] = obj.contractAddress;
584             _timestamps[i] = obj.timestamp;
585             _gasLimits[i] = obj.gasLimit;
586             _gasPrices[i] = obj.gasPriceGwei * GWEI;
587             current = objects[current];
588         }
589         }
590 
591     function getTop() external view returns (
592         address contractAddress,
593         uint timestamp,
594         uint gasLimit,
595         uint gasPrice
596     ) {
597         KeysUtils.Object memory obj = head.toObject();
598 
599         contractAddress = obj.contractAddress;
600         timestamp = obj.timestamp;
601         gasLimit = obj.gasLimit;
602         gasPrice = obj.gasPriceGwei * GWEI;
603     }
604     
605         function getNext(address _contractAddress,
606                      uint _timestamp,
607                      uint _gasLimit,
608                      uint _gasPrice) public view returns (
609         address contractAddress,
610         uint timestamp,
611         uint gasLimit,
612         uint gasPrice
613     ) {
614         if (_timestamp == 0) {
615             return this.getTop();
616         }
617 
618         bytes32 prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
619         bytes32 current = objects[prev];
620         KeysUtils.Object memory obj = current.toObject();
621 
622         contractAddress = obj.contractAddress;
623         timestamp = obj.timestamp;
624         gasLimit = obj.gasLimit;
625         gasPrice = obj.gasPriceGwei * GWEI;
626     }
627 
628 }
629 
630 contract Joule is JouleAPI, JouleContractHolder {
631     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint) {
632         uint price = this.getPrice(_gasLimit, _gasPrice);
633         require(msg.value >= price);
634 
635         require(_timestamp > now);
636         require(_timestamp < 0x100000000);
637         require(_gasLimit < MAX_GAS);
638         // from 1 gwei to 0x100000000 gwei
639         require(_gasPrice > GWEI);
640         require(_gasPrice < 0x100000000 * GWEI);
641 
642         insert(_address, _timestamp, _gasLimit, _gasPrice / GWEI);
643 
644         Registered(_address, _timestamp, _gasLimit, _gasPrice);
645 
646         if (msg.value > price) {
647             msg.sender.transfer(msg.value - price);
648             return msg.value - price;
649         }
650         return 0;
651     }
652 
653     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
654         require(_gasLimit < 4300000);
655         require(_gasPrice > GWEI);
656         require(_gasPrice < 0x100000000 * GWEI);
657 
658         return getPriceInner(_gasLimit, _gasPrice);
659     }
660 
661     function getPriceInner(uint _gasLimit, uint _gasPrice) internal pure returns (uint) {
662         return (_gasLimit + IDLE_GAS) * _gasPrice;
663     }
664 
665     function invoke() public returns (uint) {
666         return innerInvoke(invokeCallback);
667     }
668 
669     function invokeTop() public returns (uint) {
670         return innerInvokeTop(invokeCallback);
671     }
672 
673     function getVersion() external view returns (bytes8) {
674         return VERSION;
675     }
676 
677     function innerInvoke(function (address, uint) internal returns (bool) _callback) internal returns (uint _amount) {
678         KeysUtils.Object memory current = KeysUtils.toObject(head);
679 
680         uint amount;
681         while (current.timestamp != 0 && current.timestamp < now && msg.gas >= current.gasLimit) {
682             uint gas = msg.gas;
683             bool status = _callback(current.contractAddress, current.gasLimit);
684 //            current.contractAddress.call.gas(current.gasLimit)(0x919840ad);
685             gas -= msg.gas;
686             Invoked(current.contractAddress, status, gas);
687 
688             amount += getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
689             current = next();
690         }
691         if (amount > 0) {
692             msg.sender.transfer(amount);
693         }
694         return amount;
695     }
696 
697     function innerInvokeTop(function (address, uint) internal returns (bool) _callback) internal returns (uint _amount) {
698         KeysUtils.Object memory current = KeysUtils.toObject(head);
699         next();
700         uint gas = msg.gas;
701         bool status = _callback(current.contractAddress, current.gasLimit);
702         gas -= msg.gas;
703 
704         Invoked(current.contractAddress, status, gas);
705 
706         uint amount = getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
707 
708         if (amount > 0) {
709             msg.sender.transfer(amount);
710         }
711         return amount;
712     }
713 
714 
715     function invokeCallback(address _contract, uint _gas) internal returns (bool) {
716         return _contract.call.gas(_gas)(0x919840ad);
717     }
718 
719 }
720 
721 contract JouleBehindProxy is Joule, Ownable, TransferToken {
722     address public proxy;
723 
724     function setProxy(address _proxy) public onlyOwner {
725         proxy = _proxy;
726     }
727 
728     modifier onlyProxy() {
729         require(msg.sender == proxy);
730         _;
731     }
732 
733     function invoke() public onlyProxy returns (uint) {
734         return super.invoke();
735     }
736 
737     function invokeTop() public onlyProxy returns (uint) {
738         return super.invokeTop();
739     }
740 
741     function invokeCallback(address _contract, uint _gas) internal returns (bool) {
742         return proxy.call.gas(_gas)(0x73027f6d, _contract);
743     }
744 }
745 
746 
747 contract JouleProxy is JouleProxyAPI, JouleAPI, Ownable, TransferToken {
748     JouleBehindProxy public joule;
749 
750     function setJoule(JouleBehindProxy _joule) public onlyOwner {
751         joule = _joule;
752     }
753 
754     modifier onlyJoule() {
755         require(msg.sender == address(joule));
756         _;
757     }
758 
759     function () public payable onlyJoule {
760     }
761 
762     function getCount() public view returns (uint) {
763         return joule.getCount();
764     }
765 
766     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint) {
767         uint change = joule.register.value(msg.value)(_address, _timestamp, _gasLimit, _gasPrice);
768         if (change > 0) {
769             msg.sender.transfer(change);
770         }
771         return change;
772     }
773 
774     function invoke() public returns (uint) {
775         uint amount = joule.invoke();
776         if (amount > 0) {
777             msg.sender.transfer(amount);
778         }
779         return amount;
780     }
781 
782     function invokeTop() public returns (uint) {
783         uint amount = joule.invokeTop();
784         if (amount > 0) {
785             msg.sender.transfer(amount);
786         }
787         return amount;
788     }
789 
790     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
791         return joule.getPrice(_gasLimit, _gasPrice);
792     }
793 
794     function getTop() external view returns (
795         address contractAddress,
796         uint timestamp,
797         uint gasLimit,
798         uint gasPrice
799     ) {
800         (contractAddress, timestamp, gasLimit, gasPrice) = joule.getTop();
801     }
802 
803     function getNext(address _contractAddress,
804                      uint _timestamp,
805                      uint _gasLimit,
806                      uint _gasPrice) public view returns (
807         address contractAddress,
808         uint timestamp,
809         uint gasLimit,
810         uint gasPrice
811     ) {
812         (contractAddress, timestamp, gasLimit, gasPrice) = joule.getNext(_contractAddress, _timestamp, _gasLimit, _gasPrice);
813     }
814 
815 
816 
817     function getTop(uint _count) external view returns (
818         address[] _addresses,
819         uint[] _timestamps,
820         uint[] _gasLimits,
821         uint[] _gasPrices
822     ) {
823         uint length = joule.getCount();
824         uint amount = _count <= length ? _count : length;
825 
826         _addresses = new address[](amount);
827         _timestamps = new uint[](amount);
828         _gasLimits = new uint[](amount);
829         _gasPrices = new uint[](amount);
830 
831         address contractAddress;
832         uint timestamp;
833         uint gasLimit;
834         uint gasPrice;
835 
836         (contractAddress, timestamp, gasLimit, gasPrice) = joule.getTop();
837         _addresses[0] = contractAddress;
838         _timestamps[0] = timestamp;
839         _gasLimits[0] = gasLimit;
840         _gasPrices[0] = gasPrice;
841 
842         for (uint i = 1; i < amount; i ++) {
843             (contractAddress, timestamp, gasLimit, gasPrice) = joule.getNext(contractAddress, timestamp, gasLimit, gasPrice);
844             _addresses[i] = contractAddress;
845             _timestamps[i] = timestamp;
846             _gasLimits[i] = gasLimit;
847             _gasPrices[i] = gasPrice;
848         }
849     }
850 
851     function getVersion() external view returns (bytes8) {
852         return joule.getVersion();
853     }
854 
855     function callback(address _contract) public onlyJoule {
856         CheckableContract(_contract).check();
857     }
858 }