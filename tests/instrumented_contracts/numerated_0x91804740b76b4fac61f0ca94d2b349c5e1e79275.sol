1 pragma solidity ^0.4.19;
2 
3 /**
4  * Joule source codes are available at https://github.com/MyWishPlatform/joule
5  * Joule UI is available at https://joule.mywish.io
6  * Joule was made by MyWish team, please welcome to our site https://mywish.io
7  */
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 contract JouleAPI {
50     event Invoked(address indexed _invoker, address indexed _address, bool _status, uint _usedGas);
51     event Registered(address indexed _registrant, address indexed _address, uint _timestamp, uint _gasLimit, uint _gasPrice);
52     event Unregistered(address indexed _registrant, address indexed _address, uint _timestamp, uint _gasLimit, uint _gasPrice, uint _amount);
53 
54     /**
55      * @dev Registers the specified contract to invoke at the specified time with the specified gas and price.
56      * @notice Registration requires the specified amount of ETH in value, to cover invoke bonus. See getPrice method.
57      *
58      * @param _address      Contract's address. Contract MUST implements Checkable interface.
59      * @param _timestamp    Timestamp at what moment contract should be called. It MUST be in future.
60      * @param _gasLimit     Gas which will be posted to call.
61      * @param _gasPrice     Gas price which is recommended to use for this invocation.
62      * @return Amount of change.
63      */
64     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint);
65 
66     /**
67      * @dev Registers the specified contract to invoke at the specified time with the specified gas and price.
68      * @notice Registration requires the specified amount of ETH in value, to cover invoke bonus. See getPrice method.
69      * @notice If value would be more then required (see getPrice) change will be returned to msg.sender (not to _registrant!).
70      *
71      * @param _registrant   Any address which will be owners for this registration. Only he can unregister. Useful for calling from contract.
72      * @param _address      Contract's address. Contract MUST implements Checkable interface.
73      * @param _timestamp    Timestamp at what moment contract should be called. It MUST be in future.
74      * @param _gasLimit     Gas which will be posted to call.
75      * @param _gasPrice     Gas price which is recommended to use for this invocation.
76      * @return Amount of change.
77      */
78     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable returns (uint);
79 
80     /**
81      * @dev Remove registration of the specified contract (with exact parameters) by the specified key. See findKey method for looking for key.
82      * @notice It returns not full amount of ETH.
83      * @notice Only registrant can remove their registration.
84      * @notice Only registrations in future can be removed.
85      *
86      * @param _key          Contract key, to fast finding during unregister. See findKey method for getting key.
87      * @param _address      Contract's address. Contract MUST implements Checkable interface.
88      * @param _timestamp    Timestamp at what moment contract should be called. It MUST be in future.
89      * @param _gasLimit     Gas which will be posted to call.
90      * @param _gasPrice     Gas price which is recommended to use for this invocation.
91      * @return Amount of refund.
92      */
93     function unregister(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external returns (uint);
94 
95     /**
96      * @dev Invokes next contracts in the queue.
97      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
98      * @return Reward amount.
99      */
100     function invoke() public returns (uint);
101 
102     /**
103      * @dev Invokes next contracts in the queue.
104      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
105      * @param _invoker Any address from which event will be threw. Useful for calling from contract.
106      * @return Reward amount.
107      */
108     function invokeFor(address _invoker) public returns (uint);
109 
110     /**
111      * @dev Invokes the top contract in the queue.
112      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
113      * @return Reward amount.
114      */
115     function invokeOnce() public returns (uint);
116 
117     /**
118      * @dev Invokes the top contract in the queue.
119      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
120      * @param _invoker Any address from which event will be threw. Useful for calling from contract.
121      * @return Reward amount.
122      */
123     function invokeOnceFor(address _invoker) public returns (uint);
124 
125     /**
126      * @dev Calculates required to register amount of WEI.
127      *
128      * @param _gasLimit Gas which will be posted to call.
129      * @param _gasPrice Gas price which is recommended to use for this invocation.
130      * @return Amount in wei.
131      */
132     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint);
133 
134     /**
135      * @dev Gets how many contracts are registered (and not invoked).
136      */
137     function getCount() public view returns (uint);
138 
139     /**
140      * @dev Gets top contract (the next to invoke).
141      *
142      * @return contractAddress  The contract address.
143      * @return timestamp        The invocation timestamp.
144      * @return gasLimit         The contract gas.
145      * @return gasPrice         The invocation expected price.
146      * @return invokeGas        The minimal amount of gas to invoke (including gas for joule).
147      * @return rewardAmount     The amount of reward for invocation.
148      */
149     function getTopOnce() external view returns (
150         address contractAddress,
151         uint timestamp,
152         uint gasLimit,
153         uint gasPrice,
154         uint invokeGas,
155         uint rewardAmount
156     );
157 
158     /**
159      * @dev Gets one next contract by the specified previous in order to invoke.
160      *
161      * @param _contractAddress  The previous contract address.
162      * @param _timestamp        The previous invocation timestamp.
163      * @param _gasLimit         The previous invocation maximum gas.
164      * @param _gasPrice         The previous invocation expected price.
165      * @return contractAddress  The contract address.
166      * @return gasLimit         The contract gas.
167      * @return gasPrice         The invocation expected price.
168      * @return invokeGas        The minimal amount of gas to invoke (including gas for joule).
169      * @return rewardAmount     The amount of reward for invocation.
170      */
171     function getNextOnce(address _contractAddress,
172                      uint _timestamp,
173                      uint _gasLimit,
174                      uint _gasPrice) public view returns (
175         address contractAddress,
176         uint timestamp,
177         uint gasLimit,
178         uint gasPrice,
179         uint invokeGas,
180         uint rewardAmount
181     );
182 
183     /**
184      * @dev Gets _count next contracts by the specified previous in order to invoke.
185      * @notice Unlike getTop this method return exact _count values.
186      *
187      * @param _count            The count of result contracts.
188      * @param _contractAddress  The previous contract address.
189      * @param _timestamp        The previous invocation timestamp.
190      * @param _gasLimit         The previous invocation maximum gas.
191      * @param _gasPrice         The previous invocation expected price.
192      * @return contractAddress  The contract address.
193      * @return gasLimit         The contract gas.
194      * @return gasPrice         The invocation expected price.
195      * @return invokeGas        The minimal amount of gas to invoke (including gas for joule).
196      * @return rewardAmount     The amount of reward for invocation.
197      */
198     function getNext(uint _count,
199                 address _contractAddress,
200                 uint _timestamp,
201                 uint _gasLimit,
202                 uint _gasPrice) external view returns (
203         address[] addresses,
204         uint[] timestamps,
205         uint[] gasLimits,
206         uint[] gasPrices,
207         uint[] invokeGases,
208         uint[] rewardAmounts
209     );
210 
211     /**
212      * @dev Gets top _count contracts (in order to invoke).
213      *
214      * @param _count            How many records will be returned.
215      * @return addresses        The contracts addresses.
216      * @return timestamps       The invocation timestamps.
217      * @return gasLimits        The contract gas.
218      * @return gasPrices        The invocation expected price.
219      * @return invokeGases      The minimal amount of gas to invoke (including gas for joule).
220      * @return rewardAmounts    The amount of reward for invocation.
221      */
222     function getTop(uint _count) external view returns (
223         address[] addresses,
224         uint[] timestamps,
225         uint[] gasLimits,
226         uint[] gasPrices,
227         uint[] invokeGases,
228         uint[] rewardAmounts
229     );
230 
231     /**
232      * @dev Finds key for the registration with exact parameters. Be careful, key might be changed because of other registrations.
233      * @param _address      Contract's address. Contract MUST implements Checkable interface.
234      * @param _timestamp    Timestamp at what moment contract should be called. It MUST be in future.
235      * @param _gasLimit     Gas which will be posted to call.
236      * @param _gasPrice     Gas price which is recommended to use for this invocation.
237      * @return _key         Key of the specified registration.
238      */
239     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32);
240 
241     /**
242      * @dev Gets actual code version.
243      * @return Code version. Mask: 0xff.0xff.0xffff-0xffffffff (major.minor.build-hash)
244      */
245     function getVersion() external view returns (bytes8);
246 
247     /**
248      * @dev Gets minimal gas price, specified by maintainer.
249      */
250     function getMinGasPrice() public view returns (uint);
251 }
252 
253 /**
254  * @title ERC20Basic
255  * @dev Simpler version of ERC20 interface
256  * @dev see https://github.com/ethereum/EIPs/issues/179
257  */
258 contract ERC20Basic {
259   uint256 public totalSupply;
260   function balanceOf(address who) public constant returns (uint256);
261   function transfer(address to, uint256 value) public returns (bool);
262   event Transfer(address indexed from, address indexed to, uint256 value);
263 }
264 contract TransferToken is Ownable {
265     function transferToken(ERC20Basic _token, address _to, uint _value) public onlyOwner {
266         _token.transfer(_to, _value);
267     }
268 }
269 contract JouleProxyAPI {
270     /**
271      * Function hash is: 0x73027f6d
272      */
273     function callback(address _invoker, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public returns (bool);
274 }
275 contract CheckableContract {
276     event Checked();
277     /*
278      * Function hash is 0x919840ad.
279      */
280     function check() public;
281 }
282 
283 contract usingConsts {
284     uint constant GWEI = 0.001 szabo;
285 
286     // this values influence to the reward price! do not change for already registered contracts!
287     uint constant TRANSACTION_GAS = 22000;
288     // remaining gas - amount of gas to finish transaction after invoke
289     uint constant REMAINING_GAS = 30000;
290     // joule gas - gas to joule (including proxy and others) invocation, excluding contract gas
291     uint constant JOULE_GAS = TRANSACTION_GAS + REMAINING_GAS + 5000;
292 
293     // minimal default gas price (because of network load)
294     uint32 constant DEFAULT_MIN_GAS_PRICE_GWEI = 20;
295     // min gas price
296     uint constant MIN_GAS_PRICE = GWEI;
297     // max gas price
298     uint constant MAX_GAS_PRICE = 0xffffffff * GWEI;
299     // not, it mist be less then 0x00ffffff, because high bytes might be used for storing flags
300     uint constant MAX_GAS = 4000000;
301     // Code version
302     bytes8 constant VERSION = 0x0108007600aa60ef;
303     //                          ^^ - major
304     //                            ^^ - minor
305     //                              ^^^^ - build
306     //                                  ^^^^^^^^ - git hash
307 }
308 
309 
310 library KeysUtils {
311     // Such order is important to load from state
312     struct Object {
313         uint32 gasPriceGwei;
314         uint32 gasLimit;
315         uint32 timestamp;
316         address contractAddress;
317     }
318 
319     function toKey(Object _obj) internal pure returns (bytes32) {
320         return toKey(_obj.contractAddress, _obj.timestamp, _obj.gasLimit, _obj.gasPriceGwei);
321     }
322 
323     function toKeyFromStorage(Object storage _obj) internal view returns (bytes32 _key) {
324         assembly {
325             _key := sload(_obj_slot)
326         }
327     }
328 
329     function toKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal pure returns (bytes32 result) {
330         result = 0x0000000000000000000000000000000000000000000000000000000000000000;
331         //         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - address (20 bytes)
332         //                                                 ^^^^^^^^ - timestamp (4 bytes)
333         //                                                         ^^^^^^^^ - gas limit (4 bytes)
334         //                                                                 ^^^^^^^^ - gas price (4 bytes)
335         assembly {
336             result := or(result, mul(_address, 0x1000000000000000000000000))
337             result := or(result, mul(and(_timestamp, 0xffffffff), 0x10000000000000000))
338             result := or(result, mul(and(_gasLimit, 0xffffffff), 0x100000000))
339             result := or(result, and(_gasPrice, 0xffffffff))
340         }
341     }
342 
343     function toMemoryObject(bytes32 _key, Object memory _dest) internal pure {
344         assembly {
345             mstore(_dest, and(_key, 0xffffffff))
346             mstore(add(_dest, 0x20), and(div(_key, 0x100000000), 0xffffffff))
347             mstore(add(_dest, 0x40), and(div(_key, 0x10000000000000000), 0xffffffff))
348             mstore(add(_dest, 0x60), div(_key, 0x1000000000000000000000000))
349         }
350     }
351 
352     function toObject(bytes32 _key) internal pure returns (Object memory _dest) {
353         toMemoryObject(_key, _dest);
354     }
355 
356     function toStateObject(bytes32 _key, Object storage _dest) internal {
357         assembly {
358             sstore(_dest_slot, _key)
359         }
360     }
361 
362     function getTimestamp(bytes32 _key) internal pure returns (uint result) {
363         assembly {
364             result := and(div(_key, 0x10000000000000000), 0xffffffff)
365         }
366     }
367 }
368 
369 contract Restriction {
370     mapping (address => bool) internal accesses;
371 
372     function Restriction() public {
373         accesses[msg.sender] = true;
374     }
375 
376     function giveAccess(address _addr) public restricted {
377         accesses[_addr] = true;
378     }
379 
380     function removeAccess(address _addr) public restricted {
381         delete accesses[_addr];
382     }
383 
384     function hasAccess() public constant returns (bool) {
385         return accesses[msg.sender];
386     }
387 
388     modifier restricted() {
389         require(hasAccess());
390         _;
391     }
392 }
393 
394 contract JouleStorage is Restriction {
395     mapping(bytes32 => bytes32) map;
396 
397     function get(bytes32 _key) public view returns (bytes32 _value) {
398         return map[_key];
399     }
400 
401     function set(bytes32 _key, bytes32 _value) public restricted {
402         map[_key] = _value;
403     }
404 
405     function del(bytes32 _key) public restricted {
406         delete map[_key];
407     }
408 
409     function getAndDel(bytes32 _key) public restricted returns (bytes32 _value) {
410         _value = map[_key];
411         delete map[_key];
412     }
413 
414     function swap(bytes32 _from, bytes32 _to) public restricted returns (bytes32 _value) {
415         _value = map[_to];
416         map[_to] = map[_from];
417         delete map[_from];
418     }
419 }
420 
421 contract JouleIndexCore {
422     using KeysUtils for bytes32;
423     uint constant YEAR = 0x1DFE200;
424     bytes32 constant HEAD = 0x0;
425 
426     // YEAR -> week -> hour -> minute
427     JouleStorage public state;
428 
429     function JouleIndexCore(JouleStorage _storage) public {
430         state = _storage;
431     }
432 
433     function insertIndex(bytes32 _key) internal {
434         uint timestamp = _key.getTimestamp();
435         bytes32 year = toKey(timestamp, YEAR);
436         bytes32 headLow;
437         bytes32 headHigh;
438         (headLow, headHigh) = fromValue(state.get(HEAD));
439         if (year < headLow || headLow == 0 || year > headHigh) {
440             if (year < headLow || headLow == 0) {
441                 headLow = year;
442             }
443             if (year > headHigh) {
444                 headHigh = year;
445             }
446             state.set(HEAD, toValue(headLow, headHigh));
447         }
448 
449         bytes32 week = toKey(timestamp, 1 weeks);
450         bytes32 low;
451         bytes32 high;
452         (low, high) = fromValue(state.get(year));
453         if (week < low || week > high) {
454             if (week < low || low == 0) {
455                 low = week;
456             }
457             if (week > high) {
458                 high = week;
459             }
460             state.set(year, toValue(low, high));
461         }
462 
463         (low, high) = fromValue(state.get(week));
464         bytes32 hour = toKey(timestamp, 1 hours);
465         if (hour < low || hour > high) {
466             if (hour < low || low == 0) {
467                 low = hour;
468             }
469             if (hour > high) {
470                 high = hour;
471             }
472             state.set(week, toValue(low, high));
473         }
474 
475         (low, high) = fromValue(state.get(hour));
476         bytes32 minute = toKey(timestamp, 1 minutes);
477         if (minute < low || minute > high) {
478             if (minute < low || low == 0) {
479                 low = minute;
480             }
481             if (minute > high) {
482                 high = minute;
483             }
484             state.set(hour, toValue(low, high));
485         }
486 
487         (low, high) = fromValue(state.get(minute));
488         bytes32 tsKey = toKey(timestamp);
489         if (tsKey < low || tsKey > high) {
490             if (tsKey < low || low == 0) {
491                 low = tsKey;
492             }
493             if (tsKey > high) {
494                 high = tsKey;
495             }
496             state.set(minute, toValue(low, high));
497         }
498 
499         state.set(tsKey, _key);
500     }
501 
502     /**
503      * @dev Update key value from the previous state to new. Timestamp MUST be the same on both keys.
504      */
505     function updateIndex(bytes32 _prev, bytes32 _key) internal {
506         uint timestamp = _key.getTimestamp();
507         bytes32 tsKey = toKey(timestamp);
508         bytes32 prevKey = state.get(tsKey);
509         // on the same timestamp might be other key, in that case we do not need to update it
510         if (prevKey != _prev) {
511             return;
512         }
513         state.set(tsKey, _key);
514     }
515 
516     function findFloorKeyYear(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
517         bytes32 year = toKey(_timestamp, YEAR);
518         if (year < _low) {
519             return 0;
520         }
521         if (year > _high) {
522             // week
523             (low, high) = fromValue(state.get(_high));
524             // hour
525             (low, high) = fromValue(state.get(high));
526             // minute
527             (low, high) = fromValue(state.get(high));
528             // ts
529             (low, high) = fromValue(state.get(high));
530             return state.get(high);
531         }
532 
533         bytes32 low;
534         bytes32 high;
535 
536         while (year >= _low) {
537             (low, high) = fromValue(state.get(year));
538             if (low != 0) {
539                 bytes32 key = findFloorKeyWeek(_timestamp, low, high);
540                 if (key != 0) {
541                     return key;
542                 }
543             }
544             // 0x1DFE200 = 52 weeks = 31449600
545             assembly {
546                 year := sub(year, 0x1DFE200)
547             }
548         }
549 
550         return 0;
551     }
552 
553     function findFloorKeyWeek(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
554         bytes32 week = toKey(_timestamp, 1 weeks);
555         if (week < _low) {
556             return 0;
557         }
558 
559         bytes32 low;
560         bytes32 high;
561 
562         if (week > _high) {
563             // hour
564             (low, high) = fromValue(state.get(_high));
565             // minute
566             (low, high) = fromValue(state.get(high));
567             // ts
568             (low, high) = fromValue(state.get(high));
569             return state.get(high);
570         }
571 
572         while (week >= _low) {
573             (low, high) = fromValue(state.get(week));
574             if (low != 0) {
575                 bytes32 key = findFloorKeyHour(_timestamp, low, high);
576                 if (key != 0) {
577                     return key;
578                 }
579             }
580 
581             // 1 weeks = 604800
582             assembly {
583                 week := sub(week, 604800)
584             }
585         }
586         return 0;
587     }
588 
589 
590     function findFloorKeyHour(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
591         bytes32 hour = toKey(_timestamp, 1 hours);
592         if (hour < _low) {
593             return 0;
594         }
595 
596         bytes32 low;
597         bytes32 high;
598 
599         if (hour > _high) {
600             // minute
601             (low, high) = fromValue(state.get(_high));
602             // ts
603             (low, high) = fromValue(state.get(high));
604             return state.get(high);
605         }
606 
607         while (hour >= _low) {
608             (low, high) = fromValue(state.get(hour));
609             if (low != 0) {
610                 bytes32 key = findFloorKeyMinute(_timestamp, low, high);
611                 if (key != 0) {
612                     return key;
613                 }
614             }
615 
616             // 1 hours = 3600
617             assembly {
618                 hour := sub(hour, 3600)
619             }
620         }
621         return 0;
622     }
623 
624     function findFloorKeyMinute(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
625         bytes32 minute = toKey(_timestamp, 1 minutes);
626         if (minute < _low) {
627             return 0;
628         }
629 
630         bytes32 low;
631         bytes32 high;
632 
633         if (minute > _high) {
634             // ts
635             (low, high) = fromValue(state.get(_high));
636             return state.get(high);
637         }
638 
639         while (minute >= _low) {
640             (low, high) = fromValue(state.get(minute));
641             if (low != 0) {
642                 bytes32 key = findFloorKeyTimestamp(_timestamp, low, high);
643                 if (key != 0) {
644                     return key;
645                 }
646             }
647 
648             // 1 minutes = 60
649             assembly {
650                 minute := sub(minute, 60)
651             }
652         }
653 
654         return 0;
655     }
656 
657     function findFloorKeyTimestamp(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
658         bytes32 tsKey = toKey(_timestamp);
659         if (tsKey < _low) {
660             return 0;
661         }
662         if (tsKey > _high) {
663             return state.get(_high);
664         }
665 
666         while (tsKey >= _low) {
667             bytes32 key = state.get(tsKey);
668             if (key != 0) {
669                 return key;
670             }
671             assembly {
672                 tsKey := sub(tsKey, 1)
673             }
674         }
675         return 0;
676     }
677 
678     function findFloorKeyIndex(uint _timestamp) view internal returns (bytes32) {
679 //        require(_timestamp > 0xffffffff);
680 //        if (_timestamp < 1515612415) {
681 //            return 0;
682 //        }
683 
684         bytes32 yearLow;
685         bytes32 yearHigh;
686         (yearLow, yearHigh) = fromValue(state.get(HEAD));
687 
688         return findFloorKeyYear(_timestamp, yearLow, yearHigh);
689     }
690 
691     function toKey(uint _timestamp, uint rounder) pure private returns (bytes32 result) {
692         // 0x0...00000000000000000
693         //        ^^^^^^^^ - rounder marker (eg, to avoid crossing first day of year with year)
694         //                ^^^^^^^^ - rounded moment (year, week, etc)
695         assembly {
696             result := or(mul(rounder, 0x100000000), mul(div(_timestamp, rounder), rounder))
697         }
698     }
699 
700     function toValue(bytes32 _lowKey, bytes32 _highKey) pure private returns (bytes32 result) {
701         assembly {
702             result := or(mul(_lowKey, 0x10000000000000000), _highKey)
703         }
704     }
705 
706     function fromValue(bytes32 _value) pure private returns (bytes32 _lowKey, bytes32 _highKey) {
707         assembly {
708             _lowKey := and(div(_value, 0x10000000000000000), 0xffffffffffffffff)
709             _highKey := and(_value, 0xffffffffffffffff)
710         }
711     }
712 
713     function toKey(uint timestamp) pure internal returns (bytes32) {
714         return bytes32(timestamp);
715     }
716 }
717 
718 contract JouleContractHolder is JouleIndexCore, usingConsts {
719     using KeysUtils for bytes32;
720     uint internal length;
721     bytes32 public head;
722 
723     function JouleContractHolder(bytes32 _head, uint _length, JouleStorage _storage) public
724             JouleIndexCore(_storage) {
725         head = _head;
726         length = _length;
727     }
728 
729     function insert(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal {
730         length ++;
731         bytes32 id = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
732         if (head == 0) {
733             head = id;
734             insertIndex(id);
735 //            Found(0xffffffff);
736             return;
737         }
738         bytes32 previous = findFloorKeyIndex(_timestamp);
739 
740         // reject duplicate key on the end
741         require(previous != id);
742         // reject duplicate in the middle
743         require(state.get(id) == 0);
744 
745         uint prevTimestamp = previous.getTimestamp();
746 //        Found(prevTimestamp);
747         uint headTimestamp = head.getTimestamp();
748         // add as head, prevTimestamp == 0 or in the past
749         if (prevTimestamp < headTimestamp) {
750             state.set(id, head);
751             head = id;
752         }
753         // add after the previous
754         else {
755             state.set(id, state.get(previous));
756             state.set(previous, id);
757         }
758         insertIndex(id);
759     }
760 
761     function updateGas(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice, uint _newGasLimit) internal {
762         bytes32 id = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
763         bytes32 newId = KeysUtils.toKey(_address, _timestamp, _newGasLimit, _gasPrice);
764         if (id == head) {
765             head = newId;
766         }
767         else {
768             require(state.get(_key) == id);
769             state.set(_key, newId);
770         }
771         state.swap(id, newId);
772         updateIndex(id, newId);
773     }
774 
775     function next() internal {
776         head = state.getAndDel(head);
777         length--;
778     }
779 
780     function getCount() public view returns (uint) {
781         return length;
782     }
783 
784     function getRecord(bytes32 _parent) internal view returns (bytes32 _record) {
785         if (_parent == 0) {
786             _record = head;
787         }
788         else {
789             _record = state.get(_parent);
790         }
791     }
792 
793     /**
794      * @dev Find previous key for existing value.
795      */
796     function findPrevious(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal view returns (bytes32) {
797         bytes32 target = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
798         bytes32 previous = head;
799         if (target == previous) {
800             return 0;
801         }
802         // if it is not head time
803         if (_timestamp != previous.getTimestamp()) {
804             previous = findFloorKeyIndex(_timestamp - 1);
805         }
806         bytes32 current = state.get(previous);
807         while (current != target) {
808             previous = current;
809             current = state.get(previous);
810         }
811         return previous;
812     }
813 }
814 
815 contract JouleVault is Ownable {
816     address public joule;
817 
818     function setJoule(address _joule) public onlyOwner {
819         joule = _joule;
820     }
821 
822     modifier onlyJoule() {
823         require(msg.sender == address(joule));
824         _;
825     }
826 
827     function withdraw(address _receiver, uint _amount) public onlyJoule {
828         _receiver.transfer(_amount);
829     }
830 
831     function () public payable {
832 
833     }
834 }
835 
836 contract JouleCore is JouleContractHolder {
837     JouleVault public vault;
838     uint32 public minGasPriceGwei = DEFAULT_MIN_GAS_PRICE_GWEI;
839     using KeysUtils for bytes32;
840 
841     function JouleCore(JouleVault _vault, bytes32 _head, uint _length, JouleStorage _storage) public
842         JouleContractHolder(_head, _length, _storage) {
843         vault = _vault;
844     }
845 
846     function innerRegister(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal returns (uint) {
847         uint price = getPriceInner(_gasLimit, _gasPrice);
848         require(msg.value >= price);
849         vault.transfer(price);
850 
851         // this restriction to avoid attack to brake index tree (crossing key)
852         require(_address != 0);
853         require(_timestamp > now);
854         require(_timestamp < 0x100000000);
855         require(_gasLimit <= MAX_GAS);
856         require(_gasLimit != 0);
857         // from 1 gwei to 0x100000000 gwei
858         require(_gasPrice >= minGasPriceGwei * GWEI);
859         require(_gasPrice < MAX_GAS_PRICE);
860         // 0 means not yet registered
861         require(_registrant != 0x0);
862 
863         uint innerGasPrice = _gasPrice / GWEI;
864         insert(_address, _timestamp, _gasLimit, innerGasPrice);
865         saveRegistrant(_registrant, _address, _timestamp, _gasLimit, innerGasPrice);
866 
867         if (msg.value > price) {
868             msg.sender.transfer(msg.value - price);
869             return msg.value - price;
870         }
871         return 0;
872     }
873 
874     function saveRegistrant(address _registrant, address _address, uint _timestamp, uint, uint) internal {
875         bytes32 id = KeysUtils.toKey(_address, _timestamp, 0, 0);
876         require(state.get(id) == 0);
877         state.set(id, bytes32(_registrant));
878     }
879 
880     function getRegistrant(address _address, uint _timestamp, uint, uint) internal view returns (address) {
881         bytes32 id = KeysUtils.toKey(_address, _timestamp, 0, 0);
882         return address(state.get(id));
883     }
884 
885     function delRegistrant(KeysUtils.Object memory current) internal {
886         bytes32 id = KeysUtils.toKey(current.contractAddress, current.timestamp, 0, 0);
887         state.del(id);
888     }
889 
890     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32) {
891         require(_address != 0);
892         require(_timestamp > now);
893         require(_timestamp < 0x100000000);
894         require(_gasLimit < MAX_GAS);
895         require(_gasPrice > GWEI);
896         require(_gasPrice < 0x100000000 * GWEI);
897         return findPrevious(_address, _timestamp, _gasLimit, _gasPrice / GWEI);
898     }
899 
900     function innerUnregister(address _registrant, bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal returns (uint) {
901         // only future registrations might be updated, to avoid race condition in block (with invoke)
902         require(_timestamp > now);
903         // to avoid removing already removed keys
904         require(_gasLimit != 0);
905         uint innerGasPrice = _gasPrice / GWEI;
906         // check registrant
907         address registrant = getRegistrant(_address, _timestamp, _gasLimit, innerGasPrice);
908         require(registrant == _registrant);
909 
910         updateGas(_key, _address, _timestamp, _gasLimit, innerGasPrice, 0);
911         uint amount = _gasLimit * _gasPrice;
912         if (amount != 0) {
913             vault.withdraw(registrant, amount);
914         }
915         return amount;
916     }
917 
918     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
919         require(_gasLimit <= MAX_GAS);
920         require(_gasPrice > GWEI);
921         require(_gasPrice < 0x100000000 * GWEI);
922 
923         return getPriceInner(_gasLimit, _gasPrice);
924     }
925 
926     function getPriceInner(uint _gasLimit, uint _gasPrice) internal pure returns (uint) {
927         // if this logic will be changed, look also to the innerUnregister method
928         return (_gasLimit + JOULE_GAS) * _gasPrice;
929     }
930 
931     function getVersion() external view returns (bytes8) {
932         return VERSION;
933     }
934 
935     function getTop(uint _count) external view returns (
936         address[] _addresses,
937         uint[] _timestamps,
938         uint[] _gasLimits,
939         uint[] _gasPrices,
940         uint[] _invokeGases,
941         uint[] _rewardAmounts
942     ) {
943         uint amount = _count <= length ? _count : length;
944 
945         _addresses = new address[](amount);
946         _timestamps = new uint[](amount);
947         _gasLimits = new uint[](amount);
948         _gasPrices = new uint[](amount);
949         _invokeGases = new uint[](amount);
950         _rewardAmounts = new uint[](amount);
951 
952         bytes32 current = getRecord(0);
953         for (uint i = 0; i < amount; i ++) {
954             KeysUtils.Object memory obj = current.toObject();
955             _addresses[i] = obj.contractAddress;
956             _timestamps[i] = obj.timestamp;
957             uint gasLimit = obj.gasLimit;
958             _gasLimits[i] = gasLimit;
959             uint gasPrice = obj.gasPriceGwei * GWEI;
960             _gasPrices[i] = gasPrice;
961             uint invokeGas = gasLimit + JOULE_GAS;
962             _invokeGases[i] = invokeGas;
963             _rewardAmounts[i] = invokeGas * gasPrice;
964             current = getRecord(current);
965         }
966     }
967 
968     function getTopOnce() external view returns (
969         address contractAddress,
970         uint timestamp,
971         uint gasLimit,
972         uint gasPrice,
973         uint invokeGas,
974         uint rewardAmount
975     ) {
976         KeysUtils.Object memory obj = getRecord(0).toObject();
977 
978         contractAddress = obj.contractAddress;
979         timestamp = obj.timestamp;
980         gasLimit = obj.gasLimit;
981         gasPrice = obj.gasPriceGwei * GWEI;
982         invokeGas = gasLimit + JOULE_GAS;
983         rewardAmount = invokeGas * gasPrice;
984     }
985 
986     function getNextOnce(address _contractAddress,
987                      uint _timestamp,
988                      uint _gasLimit,
989                      uint _gasPrice) public view returns (
990         address contractAddress,
991         uint timestamp,
992         uint gasLimit,
993         uint gasPrice,
994         uint invokeGas,
995         uint rewardAmount
996     ) {
997         if (_timestamp == 0) {
998             return this.getTopOnce();
999         }
1000 
1001         bytes32 prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
1002         bytes32 current = getRecord(prev);
1003         KeysUtils.Object memory obj = current.toObject();
1004 
1005         contractAddress = obj.contractAddress;
1006         timestamp = obj.timestamp;
1007         gasLimit = obj.gasLimit;
1008         gasPrice = obj.gasPriceGwei * GWEI;
1009         invokeGas = gasLimit + JOULE_GAS;
1010         rewardAmount = invokeGas * gasPrice;
1011     }
1012 
1013     function getNext(uint _count,
1014                     address _contractAddress,
1015                     uint _timestamp,
1016                     uint _gasLimit,
1017                     uint _gasPrice) external view returns (address[] _addresses,
1018                                                         uint[] _timestamps,
1019                                                         uint[] _gasLimits,
1020                                                         uint[] _gasPrices,
1021                                                         uint[] _invokeGases,
1022                                                         uint[] _rewardAmounts) {
1023         _addresses = new address[](_count);
1024         _timestamps = new uint[](_count);
1025         _gasLimits = new uint[](_count);
1026         _gasPrices = new uint[](_count);
1027         _invokeGases = new uint[](_count);
1028         _rewardAmounts = new uint[](_count);
1029 
1030         bytes32 prev;
1031         if (_timestamp != 0) {
1032             prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
1033         }
1034 
1035         uint index = 0;
1036         while (index < _count) {
1037             bytes32 current = getRecord(prev);
1038             if (current == 0) {
1039                 break;
1040             }
1041             KeysUtils.Object memory obj = current.toObject();
1042 
1043             _addresses[index] = obj.contractAddress;
1044             _timestamps[index] = obj.timestamp;
1045             _gasLimits[index] = obj.gasLimit;
1046             _gasPrices[index] = obj.gasPriceGwei * GWEI;
1047             _invokeGases[index] = obj.gasLimit + JOULE_GAS;
1048             _rewardAmounts[index] = (obj.gasLimit + JOULE_GAS) * obj.gasPriceGwei * GWEI;
1049 
1050             prev = current;
1051             index ++;
1052         }
1053     }
1054 
1055     function next(KeysUtils.Object memory current) internal {
1056         delRegistrant(current);
1057         next();
1058     }
1059 
1060 
1061     function innerInvoke(address _invoker) internal returns (uint _amount) {
1062         KeysUtils.Object memory current = KeysUtils.toObject(head);
1063 
1064         uint amount;
1065         while (current.timestamp != 0 && current.timestamp < now && msg.gas > (current.gasLimit + REMAINING_GAS)) {
1066             if (current.gasLimit != 0) {
1067                 invokeCallback(_invoker, current);
1068             }
1069 
1070             amount += getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
1071             next(current);
1072             current = head.toObject();
1073         }
1074         if (amount > 0) {
1075             vault.withdraw(msg.sender, amount);
1076         }
1077         return amount;
1078     }
1079 
1080     function innerInvokeOnce(address _invoker) internal returns (uint _amount) {
1081         KeysUtils.Object memory current = head.toObject();
1082         next(current);
1083         if (current.gasLimit != 0) {
1084             invokeCallback(_invoker, current);
1085         }
1086 
1087         uint amount = getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
1088 
1089         if (amount > 0) {
1090             vault.withdraw(msg.sender, amount);
1091         }
1092         return amount;
1093     }
1094 
1095 
1096     function invokeCallback(address, KeysUtils.Object memory _record) internal returns (bool) {
1097         require(msg.gas >= _record.gasLimit);
1098         return _record.contractAddress.call.gas(_record.gasLimit)(0x919840ad);
1099     }
1100 
1101 }
1102 
1103 
1104 contract JouleBehindProxy is JouleCore, Ownable, TransferToken {
1105     JouleProxyAPI public proxy;
1106 
1107     function JouleBehindProxy(JouleVault _vault, bytes32 _head, uint _length, JouleStorage _storage) public
1108         JouleCore(_vault, _head, _length, _storage) {
1109     }
1110 
1111     function setProxy(JouleProxyAPI _proxy) public onlyOwner {
1112         proxy = _proxy;
1113     }
1114 
1115     modifier onlyProxy() {
1116         require(msg.sender == address(proxy));
1117         _;
1118     }
1119 
1120     function setMinGasPrice(uint _minGasPrice) public onlyOwner {
1121         require(_minGasPrice >= MIN_GAS_PRICE);
1122         require(_minGasPrice <= MAX_GAS_PRICE);
1123         minGasPriceGwei = uint32(_minGasPrice / GWEI);
1124     }
1125 
1126     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable onlyProxy returns (uint) {
1127         return innerRegister(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1128     }
1129 
1130     function unregisterFor(address _registrant, bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public onlyProxy returns (uint) {
1131         return innerUnregister(_registrant, _key, _address, _timestamp, _gasLimit, _gasPrice);
1132     }
1133 
1134     function invokeFor(address _invoker) public onlyProxy returns (uint) {
1135         return innerInvoke(_invoker);
1136     }
1137 
1138     function invokeOnceFor(address _invoker) public onlyProxy returns (uint) {
1139         return innerInvokeOnce(_invoker);
1140     }
1141 
1142     function invokeCallback(address _invoker, KeysUtils.Object memory _record) internal returns (bool) {
1143         return proxy.callback(_invoker, _record.contractAddress, _record.timestamp, _record.gasLimit, _record.gasPriceGwei * GWEI);
1144     }
1145 }
1146 
1147 contract JouleProxy is JouleProxyAPI, JouleAPI, Ownable, TransferToken, usingConsts {
1148     JouleBehindProxy public joule;
1149 
1150     function setJoule(JouleBehindProxy _joule) public onlyOwner {
1151         joule = _joule;
1152     }
1153 
1154     modifier onlyJoule() {
1155         require(msg.sender == address(joule));
1156         _;
1157     }
1158 
1159     function () public payable {
1160     }
1161 
1162     function getCount() public view returns (uint) {
1163         return joule.getCount();
1164     }
1165 
1166     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint) {
1167         return registerFor(msg.sender, _address, _timestamp, _gasLimit, _gasPrice);
1168     }
1169 
1170     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable returns (uint) {
1171         Registered(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1172         uint change = joule.registerFor.value(msg.value)(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1173         if (change > 0) {
1174             msg.sender.transfer(change);
1175         }
1176         return change;
1177     }
1178 
1179     function unregister(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external returns (uint) {
1180         // unregister will return funds to registrant, not to msg.sender (unlike register)
1181         uint amount = joule.unregisterFor(msg.sender, _key, _address, _timestamp, _gasLimit, _gasPrice);
1182         Unregistered(msg.sender, _address, _timestamp, _gasLimit, _gasPrice, amount);
1183         return amount;
1184     }
1185 
1186     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32) {
1187         return joule.findKey(_address, _timestamp, _gasLimit, _gasPrice);
1188     }
1189 
1190     function invoke() public returns (uint) {
1191         return invokeFor(msg.sender);
1192     }
1193 
1194     function invokeFor(address _invoker) public returns (uint) {
1195         uint amount = joule.invokeFor(_invoker);
1196         if (amount > 0) {
1197             msg.sender.transfer(amount);
1198         }
1199         return amount;
1200     }
1201 
1202     function invokeOnce() public returns (uint) {
1203         return invokeOnceFor(msg.sender);
1204     }
1205 
1206     function invokeOnceFor(address _invoker) public returns (uint) {
1207         uint amount = joule.invokeOnceFor(_invoker);
1208         if (amount > 0) {
1209             msg.sender.transfer(amount);
1210         }
1211         return amount;
1212     }
1213 
1214 
1215     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
1216         return joule.getPrice(_gasLimit, _gasPrice);
1217     }
1218 
1219     function getTopOnce() external view returns (
1220         address contractAddress,
1221         uint timestamp,
1222         uint gasLimit,
1223         uint gasPrice,
1224         uint invokeGas,
1225         uint rewardAmount
1226     ) {
1227         (contractAddress, timestamp, gasLimit, gasPrice, invokeGas, rewardAmount) = joule.getTopOnce();
1228     }
1229 
1230     function getNextOnce(address _contractAddress,
1231                      uint _timestamp,
1232                      uint _gasLimit,
1233                      uint _gasPrice) public view returns (
1234         address contractAddress,
1235         uint timestamp,
1236         uint gasLimit,
1237         uint gasPrice,
1238         uint invokeGas,
1239         uint rewardAmount
1240     ) {
1241         (contractAddress, timestamp, gasLimit, gasPrice, invokeGas, rewardAmount) = joule.getNextOnce(_contractAddress, _timestamp, _gasLimit, _gasPrice);
1242     }
1243 
1244 
1245     function getNext(uint _count,
1246                     address _contractAddress,
1247                     uint _timestamp,
1248                     uint _gasLimit,
1249                     uint _gasPrice) external view returns (
1250         address[] _addresses,
1251         uint[] _timestamps,
1252         uint[] _gasLimits,
1253         uint[] _gasPrices,
1254         uint[] _invokeGases,
1255         uint[] _rewardAmounts
1256     ) {
1257         _addresses = new address[](_count);
1258         _timestamps = new uint[](_count);
1259         _gasLimits = new uint[](_count);
1260         _gasPrices = new uint[](_count);
1261         _invokeGases = new uint[](_count);
1262         _rewardAmounts = new uint[](_count);
1263 
1264         uint i = 0;
1265 
1266         (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_contractAddress, _timestamp, _gasLimit, _gasPrice);
1267 
1268         for (i += 1; i < _count; i ++) {
1269             if (_timestamps[i - 1] == 0) {
1270                 break;
1271             }
1272             (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_addresses[i - 1], _timestamps[i - 1], _gasLimits[i - 1], _gasPrices[i - 1]);
1273         }
1274     }
1275 
1276 
1277     function getTop(uint _count) external view returns (
1278         address[] _addresses,
1279         uint[] _timestamps,
1280         uint[] _gasLimits,
1281         uint[] _gasPrices,
1282         uint[] _invokeGases,
1283         uint[] _rewardAmounts
1284     ) {
1285         uint length = joule.getCount();
1286         uint amount = _count <= length ? _count : length;
1287 
1288         _addresses = new address[](amount);
1289         _timestamps = new uint[](amount);
1290         _gasLimits = new uint[](amount);
1291         _gasPrices = new uint[](amount);
1292         _invokeGases = new uint[](amount);
1293         _rewardAmounts = new uint[](amount);
1294 
1295         uint i = 0;
1296 
1297         (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getTopOnce();
1298 
1299         for (i += 1; i < amount; i ++) {
1300             (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_addresses[i - 1], _timestamps[i - 1], _gasLimits[i - 1], _gasPrices[i - 1]);
1301         }
1302     }
1303 
1304     function getVersion() external view returns (bytes8) {
1305         return joule.getVersion();
1306     }
1307 
1308     function getMinGasPrice() public view returns (uint) {
1309         return joule.minGasPriceGwei() * GWEI;
1310     }
1311 
1312     function callback(address _invoker, address _address, uint, uint _gasLimit, uint) public onlyJoule returns (bool) {
1313         require(msg.gas >= _gasLimit);
1314         uint gas = msg.gas;
1315         bool status = _address.call.gas(_gasLimit)(0x919840ad);
1316         Invoked(_invoker, _address, status, gas - msg.gas);
1317         return status;
1318     }
1319 }