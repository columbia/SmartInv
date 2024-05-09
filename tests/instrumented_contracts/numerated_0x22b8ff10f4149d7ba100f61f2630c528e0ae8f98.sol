1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 contract JouleAPI {
45     event Invoked(address indexed _invoker, address indexed _address, bool _status, uint _usedGas);
46     event Registered(address indexed _registrant, address indexed _address, uint _timestamp, uint _gasLimit, uint _gasPrice);
47     event Unregistered(address indexed _registrant, address indexed _address, uint _timestamp, uint _gasLimit, uint _gasPrice, uint _amount);
48 
49     /**
50      * @dev Registers the specified contract to invoke at the specified time with the specified gas and price.
51      * @notice Registration requires the specified amount of ETH in value, to cover invoke bonus. See getPrice method.
52      *
53      * @param _address      Contract's address. Contract MUST implements Checkable interface.
54      * @param _timestamp    Timestamp at what moment contract should be called. It MUST be in future.
55      * @param _gasLimit     Gas which will be posted to call.
56      * @param _gasPrice     Gas price which is recommended to use for this invocation.
57      * @return Amount of change.
58      */
59     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint);
60 
61     /**
62      * @dev Registers the specified contract to invoke at the specified time with the specified gas and price.
63      * @notice Registration requires the specified amount of ETH in value, to cover invoke bonus. See getPrice method.
64      * @notice If value would be more then required (see getPrice) change will be returned to msg.sender (not to _registrant!).
65      *
66      * @param _registrant   Any address which will be owners for this registration. Only he can unregister. Useful for calling from contract.
67      * @param _address      Contract's address. Contract MUST implements Checkable interface.
68      * @param _timestamp    Timestamp at what moment contract should be called. It MUST be in future.
69      * @param _gasLimit     Gas which will be posted to call.
70      * @param _gasPrice     Gas price which is recommended to use for this invocation.
71      * @return Amount of change.
72      */
73     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable returns (uint);
74 
75     /**
76      * @dev Remove registration of the specified contract (with exact parameters) by the specified key. See findKey method for looking for key.
77      * @notice It returns not full amount of ETH.
78      * @notice Only registrant can remove their registration.
79      * @notice Only registrations in future can be removed.
80      *
81      * @param _key          Contract key, to fast finding during unregister. See findKey method for getting key.
82      * @param _address      Contract's address. Contract MUST implements Checkable interface.
83      * @param _timestamp    Timestamp at what moment contract should be called. It MUST be in future.
84      * @param _gasLimit     Gas which will be posted to call.
85      * @param _gasPrice     Gas price which is recommended to use for this invocation.
86      * @return Amount of refund.
87      */
88     function unregister(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external returns (uint);
89 
90     /**
91      * @dev Invokes next contracts in the queue.
92      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
93      * @return Reward amount.
94      */
95     function invoke() public returns (uint);
96 
97     /**
98      * @dev Invokes next contracts in the queue.
99      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
100      * @param _invoker Any address from which event will be threw. Useful for calling from contract.
101      * @return Reward amount.
102      */
103     function invokeFor(address _invoker) public returns (uint);
104 
105     /**
106      * @dev Invokes the top contract in the queue.
107      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
108      * @return Reward amount.
109      */
110     function invokeOnce() public returns (uint);
111 
112     /**
113      * @dev Invokes the top contract in the queue.
114      * @notice Eth amount to cover gas will be returned if gas price is equal or less then specified for contract. Check getTop for right gas price.
115      * @param _invoker Any address from which event will be threw. Useful for calling from contract.
116      * @return Reward amount.
117      */
118     function invokeOnceFor(address _invoker) public returns (uint);
119 
120     /**
121      * @dev Calculates required to register amount of WEI.
122      *
123      * @param _gasLimit Gas which will be posted to call.
124      * @param _gasPrice Gas price which is recommended to use for this invocation.
125      * @return Amount in wei.
126      */
127     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint);
128 
129     /**
130      * @dev Gets how many contracts are registered (and not invoked).
131      */
132     function getCount() public view returns (uint);
133 
134     /**
135      * @dev Gets top contract (the next to invoke).
136      *
137      * @return contractAddress  The contract address.
138      * @return timestamp        The invocation timestamp.
139      * @return gasLimit         The contract gas.
140      * @return gasPrice         The invocation expected price.
141      * @return invokeGas        The minimal amount of gas to invoke (including gas for joule).
142      * @return rewardAmount     The amount of reward for invocation.
143      */
144     function getTopOnce() external view returns (
145         address contractAddress,
146         uint timestamp,
147         uint gasLimit,
148         uint gasPrice,
149         uint invokeGas,
150         uint rewardAmount
151     );
152 
153     /**
154      * @dev Gets one next contract by the specified previous in order to invoke.
155      *
156      * @param _contractAddress  The previous contract address.
157      * @param _timestamp        The previous invocation timestamp.
158      * @param _gasLimit         The previous invocation maximum gas.
159      * @param _gasPrice         The previous invocation expected price.
160      * @return contractAddress  The contract address.
161      * @return gasLimit         The contract gas.
162      * @return gasPrice         The invocation expected price.
163      * @return invokeGas        The minimal amount of gas to invoke (including gas for joule).
164      * @return rewardAmount     The amount of reward for invocation.
165      */
166     function getNextOnce(address _contractAddress,
167                      uint _timestamp,
168                      uint _gasLimit,
169                      uint _gasPrice) public view returns (
170         address contractAddress,
171         uint timestamp,
172         uint gasLimit,
173         uint gasPrice,
174         uint invokeGas,
175         uint rewardAmount
176     );
177 
178     /**
179      * @dev Gets _count next contracts by the specified previous in order to invoke.
180      * @notice Unlike getTop this method return exact _count values.
181      *
182      * @param _count            The count of result contracts.
183      * @param _contractAddress  The previous contract address.
184      * @param _timestamp        The previous invocation timestamp.
185      * @param _gasLimit         The previous invocation maximum gas.
186      * @param _gasPrice         The previous invocation expected price.
187      * @return contractAddress  The contract address.
188      * @return gasLimit         The contract gas.
189      * @return gasPrice         The invocation expected price.
190      * @return invokeGas        The minimal amount of gas to invoke (including gas for joule).
191      * @return rewardAmount     The amount of reward for invocation.
192      */
193     function getNext(uint _count,
194                 address _contractAddress,
195                 uint _timestamp,
196                 uint _gasLimit,
197                 uint _gasPrice) external view returns (
198         address[] addresses,
199         uint[] timestamps,
200         uint[] gasLimits,
201         uint[] gasPrices,
202         uint[] invokeGases,
203         uint[] rewardAmounts
204     );
205 
206     /**
207      * @dev Gets top _count contracts (in order to invoke).
208      *
209      * @param _count            How many records will be returned.
210      * @return addresses        The contracts addresses.
211      * @return timestamps       The invocation timestamps.
212      * @return gasLimits        The contract gas.
213      * @return gasPrices        The invocation expected price.
214      * @return invokeGases      The minimal amount of gas to invoke (including gas for joule).
215      * @return rewardAmounts    The amount of reward for invocation.
216      */
217     function getTop(uint _count) external view returns (
218         address[] addresses,
219         uint[] timestamps,
220         uint[] gasLimits,
221         uint[] gasPrices,
222         uint[] invokeGases,
223         uint[] rewardAmounts
224     );
225 
226     /**
227      * @dev Finds key for the registration with exact parameters. Be careful, key might be changed because of other registrations.
228      * @param _address      Contract's address. Contract MUST implements Checkable interface.
229      * @param _timestamp    Timestamp at what moment contract should be called. It MUST be in future.
230      * @param _gasLimit     Gas which will be posted to call.
231      * @param _gasPrice     Gas price which is recommended to use for this invocation.
232      * @return _key         Key of the specified registration.
233      */
234     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32);
235 
236     /**
237      * @dev Gets actual code version.
238      * @return Code version. Mask: 0xff.0xff.0xffff-0xffffffff (major.minor.build-hash)
239      */
240     function getVersion() external view returns (bytes8);
241 
242     /**
243      * @dev Gets minimal gas price, specified by maintainer.
244      */
245     function getMinGasPrice() public view returns (uint);
246 }
247 
248 /**
249  * @title ERC20Basic
250  * @dev Simpler version of ERC20 interface
251  * @dev see https://github.com/ethereum/EIPs/issues/179
252  */
253 contract ERC20Basic {
254   uint256 public totalSupply;
255   function balanceOf(address who) public constant returns (uint256);
256   function transfer(address to, uint256 value) public returns (bool);
257   event Transfer(address indexed from, address indexed to, uint256 value);
258 }
259 contract TransferToken is Ownable {
260     function transferToken(ERC20Basic _token, address _to, uint _value) public onlyOwner {
261         _token.transfer(_to, _value);
262     }
263 }
264 contract JouleProxyAPI {
265     /**
266      * Function hash is: 0x73027f6d
267      */
268     function callback(address _invoker, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public returns (bool);
269 }
270 contract CheckableContract {
271     event Checked();
272     /*
273      * Function hash is 0x919840ad.
274      */
275     function check() public;
276 }
277 
278 contract usingConsts {
279     uint constant GWEI = 0.001 szabo;
280 
281     // this values influence to the reward price! do not change for already registered contracts!
282     uint constant TRANSACTION_GAS = 22000;
283     // remaining gas - amount of gas to finish transaction after invoke
284     uint constant REMAINING_GAS = 30000;
285     // joule gas - gas to joule (including proxy and others) invocation, excluding contract gas
286     uint constant JOULE_GAS = TRANSACTION_GAS + REMAINING_GAS + 5000;
287 
288     // minimal default gas price (because of network load)
289     uint32 constant DEFAULT_MIN_GAS_PRICE_GWEI = 20;
290     // min gas price
291     uint constant MIN_GAS_PRICE = GWEI;
292     // max gas price
293     uint constant MAX_GAS_PRICE = 0xffffffff * GWEI;
294     // not, it mist be less then 0x00ffffff, because high bytes might be used for storing flags
295     uint constant MAX_GAS = 4000000;
296     // Code version
297     bytes8 constant VERSION = 0x0108000000000000;
298     //                          ^^ - major
299     //                            ^^ - minor
300     //                              ^^^^ - build
301     //                                  ^^^^^^^^ - git hash
302 }
303 
304 
305 library KeysUtils {
306     // Such order is important to load from state
307     struct Object {
308         uint32 gasPriceGwei;
309         uint32 gasLimit;
310         uint32 timestamp;
311         address contractAddress;
312     }
313 
314     function toKey(Object _obj) internal pure returns (bytes32) {
315         return toKey(_obj.contractAddress, _obj.timestamp, _obj.gasLimit, _obj.gasPriceGwei);
316     }
317 
318     function toKeyFromStorage(Object storage _obj) internal view returns (bytes32 _key) {
319         assembly {
320             _key := sload(_obj_slot)
321         }
322     }
323 
324     function toKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal pure returns (bytes32 result) {
325         result = 0x0000000000000000000000000000000000000000000000000000000000000000;
326         //         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - address (20 bytes)
327         //                                                 ^^^^^^^^ - timestamp (4 bytes)
328         //                                                         ^^^^^^^^ - gas limit (4 bytes)
329         //                                                                 ^^^^^^^^ - gas price (4 bytes)
330         assembly {
331             result := or(result, mul(_address, 0x1000000000000000000000000))
332             result := or(result, mul(and(_timestamp, 0xffffffff), 0x10000000000000000))
333             result := or(result, mul(and(_gasLimit, 0xffffffff), 0x100000000))
334             result := or(result, and(_gasPrice, 0xffffffff))
335         }
336     }
337 
338     function toMemoryObject(bytes32 _key, Object memory _dest) internal pure {
339         assembly {
340             mstore(_dest, and(_key, 0xffffffff))
341             mstore(add(_dest, 0x20), and(div(_key, 0x100000000), 0xffffffff))
342             mstore(add(_dest, 0x40), and(div(_key, 0x10000000000000000), 0xffffffff))
343             mstore(add(_dest, 0x60), div(_key, 0x1000000000000000000000000))
344         }
345     }
346 
347     function toObject(bytes32 _key) internal pure returns (Object memory _dest) {
348         toMemoryObject(_key, _dest);
349     }
350 
351     function toStateObject(bytes32 _key, Object storage _dest) internal {
352         assembly {
353             sstore(_dest_slot, _key)
354         }
355     }
356 
357     function getTimestamp(bytes32 _key) internal pure returns (uint result) {
358         assembly {
359             result := and(div(_key, 0x10000000000000000), 0xffffffff)
360         }
361     }
362 }
363 
364 contract Restriction {
365     mapping (address => bool) internal accesses;
366 
367     function Restriction() public {
368         accesses[msg.sender] = true;
369     }
370 
371     function giveAccess(address _addr) public restricted {
372         accesses[_addr] = true;
373     }
374 
375     function removeAccess(address _addr) public restricted {
376         delete accesses[_addr];
377     }
378 
379     function hasAccess() public constant returns (bool) {
380         return accesses[msg.sender];
381     }
382 
383     modifier restricted() {
384         require(hasAccess());
385         _;
386     }
387 }
388 
389 contract JouleStorage is Restriction {
390     mapping(bytes32 => bytes32) map;
391 
392     function get(bytes32 _key) public view returns (bytes32 _value) {
393         return map[_key];
394     }
395 
396     function set(bytes32 _key, bytes32 _value) public restricted {
397         map[_key] = _value;
398     }
399 
400     function del(bytes32 _key) public restricted {
401         delete map[_key];
402     }
403 
404     function getAndDel(bytes32 _key) public restricted returns (bytes32 _value) {
405         _value = map[_key];
406         delete map[_key];
407     }
408 
409     function swap(bytes32 _from, bytes32 _to) public restricted returns (bytes32 _value) {
410         _value = map[_to];
411         map[_to] = map[_from];
412         delete map[_from];
413     }
414 }
415 
416 contract JouleIndexCore {
417     using KeysUtils for bytes32;
418     uint constant YEAR = 0x1DFE200;
419     bytes32 constant HEAD = 0x0;
420 
421     // YEAR -> week -> hour -> minute
422     JouleStorage public state;
423 
424     function JouleIndexCore(JouleStorage _storage) public {
425         state = _storage;
426     }
427 
428     function insertIndex(bytes32 _key) internal {
429         uint timestamp = _key.getTimestamp();
430         bytes32 year = toKey(timestamp, YEAR);
431         bytes32 headLow;
432         bytes32 headHigh;
433         (headLow, headHigh) = fromValue(state.get(HEAD));
434         if (year < headLow || headLow == 0 || year > headHigh) {
435             if (year < headLow || headLow == 0) {
436                 headLow = year;
437             }
438             if (year > headHigh) {
439                 headHigh = year;
440             }
441             state.set(HEAD, toValue(headLow, headHigh));
442         }
443 
444         bytes32 week = toKey(timestamp, 1 weeks);
445         bytes32 low;
446         bytes32 high;
447         (low, high) = fromValue(state.get(year));
448         if (week < low || week > high) {
449             if (week < low || low == 0) {
450                 low = week;
451             }
452             if (week > high) {
453                 high = week;
454             }
455             state.set(year, toValue(low, high));
456         }
457 
458         (low, high) = fromValue(state.get(week));
459         bytes32 hour = toKey(timestamp, 1 hours);
460         if (hour < low || hour > high) {
461             if (hour < low || low == 0) {
462                 low = hour;
463             }
464             if (hour > high) {
465                 high = hour;
466             }
467             state.set(week, toValue(low, high));
468         }
469 
470         (low, high) = fromValue(state.get(hour));
471         bytes32 minute = toKey(timestamp, 1 minutes);
472         if (minute < low || minute > high) {
473             if (minute < low || low == 0) {
474                 low = minute;
475             }
476             if (minute > high) {
477                 high = minute;
478             }
479             state.set(hour, toValue(low, high));
480         }
481 
482         (low, high) = fromValue(state.get(minute));
483         bytes32 tsKey = toKey(timestamp);
484         if (tsKey < low || tsKey > high) {
485             if (tsKey < low || low == 0) {
486                 low = tsKey;
487             }
488             if (tsKey > high) {
489                 high = tsKey;
490             }
491             state.set(minute, toValue(low, high));
492         }
493 
494         state.set(tsKey, _key);
495     }
496 
497     /**
498      * @dev Update key value from the previous state to new. Timestamp MUST be the same on both keys.
499      */
500     function updateIndex(bytes32 _prev, bytes32 _key) internal {
501         uint timestamp = _key.getTimestamp();
502         bytes32 tsKey = toKey(timestamp);
503         bytes32 prevKey = state.get(tsKey);
504         // on the same timestamp might be other key, in that case we do not need to update it
505         if (prevKey != _prev) {
506             return;
507         }
508         state.set(tsKey, _key);
509     }
510 
511     function findFloorKeyYear(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
512         bytes32 year = toKey(_timestamp, YEAR);
513         if (year < _low) {
514             return 0;
515         }
516         if (year > _high) {
517             // week
518             (low, high) = fromValue(state.get(_high));
519             // hour
520             (low, high) = fromValue(state.get(high));
521             // minute
522             (low, high) = fromValue(state.get(high));
523             // ts
524             (low, high) = fromValue(state.get(high));
525             return state.get(high);
526         }
527 
528         bytes32 low;
529         bytes32 high;
530 
531         while (year >= _low) {
532             (low, high) = fromValue(state.get(year));
533             if (low != 0) {
534                 bytes32 key = findFloorKeyWeek(_timestamp, low, high);
535                 if (key != 0) {
536                     return key;
537                 }
538             }
539             // 0x1DFE200 = 52 weeks = 31449600
540             assembly {
541                 year := sub(year, 0x1DFE200)
542             }
543         }
544 
545         return 0;
546     }
547 
548     function findFloorKeyWeek(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
549         bytes32 week = toKey(_timestamp, 1 weeks);
550         if (week < _low) {
551             return 0;
552         }
553 
554         bytes32 low;
555         bytes32 high;
556 
557         if (week > _high) {
558             // hour
559             (low, high) = fromValue(state.get(_high));
560             // minute
561             (low, high) = fromValue(state.get(high));
562             // ts
563             (low, high) = fromValue(state.get(high));
564             return state.get(high);
565         }
566 
567         while (week >= _low) {
568             (low, high) = fromValue(state.get(week));
569             if (low != 0) {
570                 bytes32 key = findFloorKeyHour(_timestamp, low, high);
571                 if (key != 0) {
572                     return key;
573                 }
574             }
575 
576             // 1 weeks = 604800
577             assembly {
578                 week := sub(week, 604800)
579             }
580         }
581         return 0;
582     }
583 
584 
585     function findFloorKeyHour(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
586         bytes32 hour = toKey(_timestamp, 1 hours);
587         if (hour < _low) {
588             return 0;
589         }
590 
591         bytes32 low;
592         bytes32 high;
593 
594         if (hour > _high) {
595             // minute
596             (low, high) = fromValue(state.get(_high));
597             // ts
598             (low, high) = fromValue(state.get(high));
599             return state.get(high);
600         }
601 
602         while (hour >= _low) {
603             (low, high) = fromValue(state.get(hour));
604             if (low != 0) {
605                 bytes32 key = findFloorKeyMinute(_timestamp, low, high);
606                 if (key != 0) {
607                     return key;
608                 }
609             }
610 
611             // 1 hours = 3600
612             assembly {
613                 hour := sub(hour, 3600)
614             }
615         }
616         return 0;
617     }
618 
619     function findFloorKeyMinute(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
620         bytes32 minute = toKey(_timestamp, 1 minutes);
621         if (minute < _low) {
622             return 0;
623         }
624 
625         bytes32 low;
626         bytes32 high;
627 
628         if (minute > _high) {
629             // ts
630             (low, high) = fromValue(state.get(_high));
631             return state.get(high);
632         }
633 
634         while (minute >= _low) {
635             (low, high) = fromValue(state.get(minute));
636             if (low != 0) {
637                 bytes32 key = findFloorKeyTimestamp(_timestamp, low, high);
638                 if (key != 0) {
639                     return key;
640                 }
641             }
642 
643             // 1 minutes = 60
644             assembly {
645                 minute := sub(minute, 60)
646             }
647         }
648 
649         return 0;
650     }
651 
652     function findFloorKeyTimestamp(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
653         bytes32 tsKey = toKey(_timestamp);
654         if (tsKey < _low) {
655             return 0;
656         }
657         if (tsKey > _high) {
658             return state.get(_high);
659         }
660 
661         while (tsKey >= _low) {
662             bytes32 key = state.get(tsKey);
663             if (key != 0) {
664                 return key;
665             }
666             assembly {
667                 tsKey := sub(tsKey, 1)
668             }
669         }
670         return 0;
671     }
672 
673     function findFloorKeyIndex(uint _timestamp) view internal returns (bytes32) {
674 //        require(_timestamp > 0xffffffff);
675 //        if (_timestamp < 1515612415) {
676 //            return 0;
677 //        }
678 
679         bytes32 yearLow;
680         bytes32 yearHigh;
681         (yearLow, yearHigh) = fromValue(state.get(HEAD));
682 
683         return findFloorKeyYear(_timestamp, yearLow, yearHigh);
684     }
685 
686     function toKey(uint _timestamp, uint rounder) pure private returns (bytes32 result) {
687         // 0x0...00000000000000000
688         //        ^^^^^^^^ - rounder marker (eg, to avoid crossing first day of year with year)
689         //                ^^^^^^^^ - rounded moment (year, week, etc)
690         assembly {
691             result := or(mul(rounder, 0x100000000), mul(div(_timestamp, rounder), rounder))
692         }
693     }
694 
695     function toValue(bytes32 _lowKey, bytes32 _highKey) pure private returns (bytes32 result) {
696         assembly {
697             result := or(mul(_lowKey, 0x10000000000000000), _highKey)
698         }
699     }
700 
701     function fromValue(bytes32 _value) pure private returns (bytes32 _lowKey, bytes32 _highKey) {
702         assembly {
703             _lowKey := and(div(_value, 0x10000000000000000), 0xffffffffffffffff)
704             _highKey := and(_value, 0xffffffffffffffff)
705         }
706     }
707 
708     function toKey(uint timestamp) pure internal returns (bytes32) {
709         return bytes32(timestamp);
710     }
711 }
712 
713 contract JouleContractHolder is JouleIndexCore, usingConsts {
714     using KeysUtils for bytes32;
715     uint internal length;
716     bytes32 public head;
717 
718     function JouleContractHolder(bytes32 _head, uint _length, JouleStorage _storage) public
719             JouleIndexCore(_storage) {
720         head = _head;
721         length = _length;
722     }
723 
724     function insert(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal {
725         length ++;
726         bytes32 id = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
727         if (head == 0) {
728             head = id;
729             insertIndex(id);
730 //            Found(0xffffffff);
731             return;
732         }
733         bytes32 previous = findFloorKeyIndex(_timestamp);
734 
735         // reject duplicate key on the end
736         require(previous != id);
737         // reject duplicate in the middle
738         require(state.get(id) == 0);
739 
740         uint prevTimestamp = previous.getTimestamp();
741 //        Found(prevTimestamp);
742         uint headTimestamp = head.getTimestamp();
743         // add as head, prevTimestamp == 0 or in the past
744         if (prevTimestamp < headTimestamp) {
745             state.set(id, head);
746             head = id;
747         }
748         // add after the previous
749         else {
750             state.set(id, state.get(previous));
751             state.set(previous, id);
752         }
753         insertIndex(id);
754     }
755 
756     function updateGas(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice, uint _newGasLimit) internal {
757         bytes32 id = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
758         bytes32 newId = KeysUtils.toKey(_address, _timestamp, _newGasLimit, _gasPrice);
759         if (id == head) {
760             bytes32 afterHead = state.get(id);
761             head = newId;
762             state.set(newId, afterHead);
763             return;
764         }
765 
766         require(state.get(_key) == id);
767         state.set(_key, newId);
768         state.swap(id, newId);
769         updateIndex(id, newId);
770     }
771 
772     function next() internal {
773         head = state.getAndDel(head);
774         length--;
775     }
776 
777     function getCount() public view returns (uint) {
778         return length;
779     }
780 
781     function getRecord(bytes32 _parent) internal view returns (bytes32 _record) {
782         if (_parent == 0) {
783             _record = head;
784         }
785         else {
786             _record = state.get(_parent);
787         }
788     }
789 
790     /**
791      * @dev Find previous key for existing value.
792      */
793     function findPrevious(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal view returns (bytes32) {
794         bytes32 target = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
795         bytes32 previous = head;
796         if (target == previous) {
797             return 0;
798         }
799         // if it is not head time
800         if (_timestamp != previous.getTimestamp()) {
801             previous = findFloorKeyIndex(_timestamp - 1);
802         }
803         bytes32 current = state.get(previous);
804         while (current != target) {
805             previous = current;
806             current = state.get(previous);
807         }
808         return previous;
809     }
810 }
811 
812 contract JouleVault is Ownable {
813     address public joule;
814 
815     function setJoule(address _joule) public onlyOwner {
816         joule = _joule;
817     }
818 
819     modifier onlyJoule() {
820         require(msg.sender == address(joule));
821         _;
822     }
823 
824     function withdraw(address _receiver, uint _amount) public onlyJoule {
825         _receiver.transfer(_amount);
826     }
827 
828     function () public payable {
829 
830     }
831 }
832 
833 contract JouleCore is JouleContractHolder {
834     JouleVault public vault;
835     uint32 public minGasPriceGwei = DEFAULT_MIN_GAS_PRICE_GWEI;
836     using KeysUtils for bytes32;
837 
838     function JouleCore(JouleVault _vault, bytes32 _head, uint _length, JouleStorage _storage) public
839         JouleContractHolder(_head, _length, _storage) {
840         vault = _vault;
841     }
842 
843     function innerRegister(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal returns (uint) {
844         uint price = getPriceInner(_gasLimit, _gasPrice);
845         require(msg.value >= price);
846         vault.transfer(price);
847 
848         // this restriction to avoid attack to brake index tree (crossing key)
849         require(_address != 0);
850         require(_timestamp > now);
851         require(_timestamp < 0x100000000);
852         require(_gasLimit <= MAX_GAS);
853         require(_gasLimit != 0);
854         // from 1 gwei to 0x100000000 gwei
855         require(_gasPrice >= minGasPriceGwei * GWEI);
856         require(_gasPrice < MAX_GAS_PRICE);
857         // 0 means not yet registered
858         require(_registrant != 0x0);
859 
860         uint innerGasPrice = _gasPrice / GWEI;
861         insert(_address, _timestamp, _gasLimit, innerGasPrice);
862         saveRegistrant(_registrant, _address, _timestamp, _gasLimit, innerGasPrice);
863 
864         if (msg.value > price) {
865             msg.sender.transfer(msg.value - price);
866             return msg.value - price;
867         }
868         return 0;
869     }
870 
871     function saveRegistrant(address _registrant, address _address, uint _timestamp, uint, uint) internal {
872         bytes32 id = KeysUtils.toKey(_address, _timestamp, 0, 0);
873         require(state.get(id) == 0);
874         state.set(id, bytes32(_registrant));
875     }
876 
877     function getRegistrant(address _address, uint _timestamp, uint, uint) internal view returns (address) {
878         bytes32 id = KeysUtils.toKey(_address, _timestamp, 0, 0);
879         return address(state.get(id));
880     }
881 
882     function delRegistrant(KeysUtils.Object memory current) internal {
883         bytes32 id = KeysUtils.toKey(current.contractAddress, current.timestamp, 0, 0);
884         state.del(id);
885     }
886 
887     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32) {
888         require(_address != 0);
889         require(_timestamp > now);
890         require(_timestamp < 0x100000000);
891         require(_gasLimit < MAX_GAS);
892         require(_gasPrice > GWEI);
893         require(_gasPrice < 0x100000000 * GWEI);
894         return findPrevious(_address, _timestamp, _gasLimit, _gasPrice / GWEI);
895     }
896 
897     function innerUnregister(address _registrant, bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal returns (uint) {
898         // only future registrations might be updated, to avoid race condition in block (with invoke)
899         require(_timestamp > now);
900         // to avoid removing already removed keys
901         require(_gasLimit != 0);
902         uint innerGasPrice = _gasPrice / GWEI;
903         // check registrant
904         address registrant = getRegistrant(_address, _timestamp, _gasLimit, innerGasPrice);
905         require(registrant == _registrant);
906 
907         updateGas(_key, _address, _timestamp, _gasLimit, innerGasPrice, 0);
908         uint amount = _gasLimit * _gasPrice;
909         if (amount != 0) {
910             vault.withdraw(registrant, amount);
911         }
912         return amount;
913     }
914 
915     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
916         require(_gasLimit <= MAX_GAS);
917         require(_gasPrice > GWEI);
918         require(_gasPrice < 0x100000000 * GWEI);
919 
920         return getPriceInner(_gasLimit, _gasPrice);
921     }
922 
923     function getPriceInner(uint _gasLimit, uint _gasPrice) internal pure returns (uint) {
924         // if this logic will be changed, look also to the innerUnregister method
925         return (_gasLimit + JOULE_GAS) * _gasPrice;
926     }
927 
928     function getVersion() external view returns (bytes8) {
929         return VERSION;
930     }
931 
932     function getTop(uint _count) external view returns (
933         address[] _addresses,
934         uint[] _timestamps,
935         uint[] _gasLimits,
936         uint[] _gasPrices,
937         uint[] _invokeGases,
938         uint[] _rewardAmounts
939     ) {
940         uint amount = _count <= length ? _count : length;
941 
942         _addresses = new address[](amount);
943         _timestamps = new uint[](amount);
944         _gasLimits = new uint[](amount);
945         _gasPrices = new uint[](amount);
946         _invokeGases = new uint[](amount);
947         _rewardAmounts = new uint[](amount);
948 
949         bytes32 current = getRecord(0);
950         for (uint i = 0; i < amount; i ++) {
951             KeysUtils.Object memory obj = current.toObject();
952             _addresses[i] = obj.contractAddress;
953             _timestamps[i] = obj.timestamp;
954             uint gasLimit = obj.gasLimit;
955             _gasLimits[i] = gasLimit;
956             uint gasPrice = obj.gasPriceGwei * GWEI;
957             _gasPrices[i] = gasPrice;
958             uint invokeGas = gasLimit + JOULE_GAS;
959             _invokeGases[i] = invokeGas;
960             _rewardAmounts[i] = invokeGas * gasPrice;
961             current = getRecord(current);
962         }
963     }
964 
965     function getTopOnce() external view returns (
966         address contractAddress,
967         uint timestamp,
968         uint gasLimit,
969         uint gasPrice,
970         uint invokeGas,
971         uint rewardAmount
972     ) {
973         KeysUtils.Object memory obj = getRecord(0).toObject();
974 
975         contractAddress = obj.contractAddress;
976         timestamp = obj.timestamp;
977         gasLimit = obj.gasLimit;
978         gasPrice = obj.gasPriceGwei * GWEI;
979         invokeGas = gasLimit + JOULE_GAS;
980         rewardAmount = invokeGas * gasPrice;
981     }
982 
983     function getNextOnce(address _contractAddress,
984                      uint _timestamp,
985                      uint _gasLimit,
986                      uint _gasPrice) public view returns (
987         address contractAddress,
988         uint timestamp,
989         uint gasLimit,
990         uint gasPrice,
991         uint invokeGas,
992         uint rewardAmount
993     ) {
994         if (_timestamp == 0) {
995             return this.getTopOnce();
996         }
997 
998         bytes32 prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
999         bytes32 current = getRecord(prev);
1000         KeysUtils.Object memory obj = current.toObject();
1001 
1002         contractAddress = obj.contractAddress;
1003         timestamp = obj.timestamp;
1004         gasLimit = obj.gasLimit;
1005         gasPrice = obj.gasPriceGwei * GWEI;
1006         invokeGas = gasLimit + JOULE_GAS;
1007         rewardAmount = invokeGas * gasPrice;
1008     }
1009 
1010     function getNext(uint _count,
1011                     address _contractAddress,
1012                     uint _timestamp,
1013                     uint _gasLimit,
1014                     uint _gasPrice) external view returns (address[] _addresses,
1015                                                         uint[] _timestamps,
1016                                                         uint[] _gasLimits,
1017                                                         uint[] _gasPrices,
1018                                                         uint[] _invokeGases,
1019                                                         uint[] _rewardAmounts) {
1020         _addresses = new address[](_count);
1021         _timestamps = new uint[](_count);
1022         _gasLimits = new uint[](_count);
1023         _gasPrices = new uint[](_count);
1024         _invokeGases = new uint[](_count);
1025         _rewardAmounts = new uint[](_count);
1026 
1027         bytes32 prev;
1028         if (_timestamp != 0) {
1029             prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
1030         }
1031 
1032         uint index = 0;
1033         while (index < _count) {
1034             bytes32 current = getRecord(prev);
1035             if (current == 0) {
1036                 break;
1037             }
1038             KeysUtils.Object memory obj = current.toObject();
1039 
1040             _addresses[index] = obj.contractAddress;
1041             _timestamps[index] = obj.timestamp;
1042             _gasLimits[index] = obj.gasLimit;
1043             _gasPrices[index] = obj.gasPriceGwei * GWEI;
1044             _invokeGases[index] = obj.gasLimit + JOULE_GAS;
1045             _rewardAmounts[index] = (obj.gasLimit + JOULE_GAS) * obj.gasPriceGwei * GWEI;
1046 
1047             prev = current;
1048             index ++;
1049         }
1050     }
1051 
1052     function next(KeysUtils.Object memory current) internal {
1053         delRegistrant(current);
1054         next();
1055     }
1056 
1057 
1058     function innerInvoke(address _invoker) internal returns (uint _amount) {
1059         KeysUtils.Object memory current = KeysUtils.toObject(head);
1060 
1061         uint amount;
1062         while (current.timestamp != 0 && current.timestamp < now && msg.gas > (current.gasLimit + REMAINING_GAS)) {
1063             if (current.gasLimit != 0) {
1064                 invokeCallback(_invoker, current);
1065             }
1066 
1067             amount += getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
1068             next(current);
1069             current = head.toObject();
1070         }
1071         if (amount > 0) {
1072             vault.withdraw(msg.sender, amount);
1073         }
1074         return amount;
1075     }
1076 
1077     function innerInvokeOnce(address _invoker) internal returns (uint _amount) {
1078         KeysUtils.Object memory current = head.toObject();
1079         next(current);
1080         if (current.gasLimit != 0) {
1081             invokeCallback(_invoker, current);
1082         }
1083 
1084         uint amount = getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
1085 
1086         if (amount > 0) {
1087             vault.withdraw(msg.sender, amount);
1088         }
1089         return amount;
1090     }
1091 
1092 
1093     function invokeCallback(address, KeysUtils.Object memory _record) internal returns (bool) {
1094         require(msg.gas >= _record.gasLimit);
1095         return _record.contractAddress.call.gas(_record.gasLimit)(0x919840ad);
1096     }
1097 
1098 }
1099 
1100 
1101 contract JouleBehindProxy is JouleCore, Ownable, TransferToken {
1102     JouleProxyAPI public proxy;
1103 
1104     function JouleBehindProxy(JouleVault _vault, bytes32 _head, uint _length, JouleStorage _storage) public
1105         JouleCore(_vault, _head, _length, _storage) {
1106     }
1107 
1108     function setProxy(JouleProxyAPI _proxy) public onlyOwner {
1109         proxy = _proxy;
1110     }
1111 
1112     modifier onlyProxy() {
1113         require(msg.sender == address(proxy));
1114         _;
1115     }
1116 
1117     function setMinGasPrice(uint _minGasPrice) public onlyOwner {
1118         require(_minGasPrice >= MIN_GAS_PRICE);
1119         require(_minGasPrice <= MAX_GAS_PRICE);
1120         minGasPriceGwei = uint32(_minGasPrice / GWEI);
1121     }
1122 
1123     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable onlyProxy returns (uint) {
1124         return innerRegister(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1125     }
1126 
1127     function unregisterFor(address _registrant, bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public onlyProxy returns (uint) {
1128         return innerUnregister(_registrant, _key, _address, _timestamp, _gasLimit, _gasPrice);
1129     }
1130 
1131     function invokeFor(address _invoker) public onlyProxy returns (uint) {
1132         return innerInvoke(_invoker);
1133     }
1134 
1135     function invokeOnceFor(address _invoker) public onlyProxy returns (uint) {
1136         return innerInvokeOnce(_invoker);
1137     }
1138 
1139     function invokeCallback(address _invoker, KeysUtils.Object memory _record) internal returns (bool) {
1140         return proxy.callback(_invoker, _record.contractAddress, _record.timestamp, _record.gasLimit, _record.gasPriceGwei * GWEI);
1141     }
1142 }
1143 
1144 contract JouleProxy is JouleProxyAPI, JouleAPI, Ownable, TransferToken, usingConsts {
1145     JouleBehindProxy public joule;
1146 
1147     function setJoule(JouleBehindProxy _joule) public onlyOwner {
1148         joule = _joule;
1149     }
1150 
1151     modifier onlyJoule() {
1152         require(msg.sender == address(joule));
1153         _;
1154     }
1155 
1156     function () public payable {
1157     }
1158 
1159     function getCount() public view returns (uint) {
1160         return joule.getCount();
1161     }
1162 
1163     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint) {
1164         return registerFor(msg.sender, _address, _timestamp, _gasLimit, _gasPrice);
1165     }
1166 
1167     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable returns (uint) {
1168         Registered(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1169         uint change = joule.registerFor.value(msg.value)(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1170         if (change > 0) {
1171             msg.sender.transfer(change);
1172         }
1173         return change;
1174     }
1175 
1176     function unregister(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external returns (uint) {
1177         // unregister will return funds to registrant, not to msg.sender (unlike register)
1178         uint amount = joule.unregisterFor(msg.sender, _key, _address, _timestamp, _gasLimit, _gasPrice);
1179         Unregistered(msg.sender, _address, _timestamp, _gasLimit, _gasPrice, amount);
1180         return amount;
1181     }
1182 
1183     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32) {
1184         return joule.findKey(_address, _timestamp, _gasLimit, _gasPrice);
1185     }
1186 
1187     function invoke() public returns (uint) {
1188         return invokeFor(msg.sender);
1189     }
1190 
1191     function invokeFor(address _invoker) public returns (uint) {
1192         uint amount = joule.invokeFor(_invoker);
1193         if (amount > 0) {
1194             msg.sender.transfer(amount);
1195         }
1196         return amount;
1197     }
1198 
1199     function invokeOnce() public returns (uint) {
1200         return invokeOnceFor(msg.sender);
1201     }
1202 
1203     function invokeOnceFor(address _invoker) public returns (uint) {
1204         uint amount = joule.invokeOnceFor(_invoker);
1205         if (amount > 0) {
1206             msg.sender.transfer(amount);
1207         }
1208         return amount;
1209     }
1210 
1211 
1212     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
1213         return joule.getPrice(_gasLimit, _gasPrice);
1214     }
1215 
1216     function getTopOnce() external view returns (
1217         address contractAddress,
1218         uint timestamp,
1219         uint gasLimit,
1220         uint gasPrice,
1221         uint invokeGas,
1222         uint rewardAmount
1223     ) {
1224         (contractAddress, timestamp, gasLimit, gasPrice, invokeGas, rewardAmount) = joule.getTopOnce();
1225     }
1226 
1227     function getNextOnce(address _contractAddress,
1228                      uint _timestamp,
1229                      uint _gasLimit,
1230                      uint _gasPrice) public view returns (
1231         address contractAddress,
1232         uint timestamp,
1233         uint gasLimit,
1234         uint gasPrice,
1235         uint invokeGas,
1236         uint rewardAmount
1237     ) {
1238         (contractAddress, timestamp, gasLimit, gasPrice, invokeGas, rewardAmount) = joule.getNextOnce(_contractAddress, _timestamp, _gasLimit, _gasPrice);
1239     }
1240 
1241 
1242     function getNext(uint _count,
1243                     address _contractAddress,
1244                     uint _timestamp,
1245                     uint _gasLimit,
1246                     uint _gasPrice) external view returns (
1247         address[] _addresses,
1248         uint[] _timestamps,
1249         uint[] _gasLimits,
1250         uint[] _gasPrices,
1251         uint[] _invokeGases,
1252         uint[] _rewardAmounts
1253     ) {
1254         _addresses = new address[](_count);
1255         _timestamps = new uint[](_count);
1256         _gasLimits = new uint[](_count);
1257         _gasPrices = new uint[](_count);
1258         _invokeGases = new uint[](_count);
1259         _rewardAmounts = new uint[](_count);
1260 
1261         uint i = 0;
1262 
1263         (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_contractAddress, _timestamp, _gasLimit, _gasPrice);
1264 
1265         for (i += 1; i < _count; i ++) {
1266             if (_timestamps[i - 1] == 0) {
1267                 break;
1268             }
1269             (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_addresses[i - 1], _timestamps[i - 1], _gasLimits[i - 1], _gasPrices[i - 1]);
1270         }
1271     }
1272 
1273 
1274     function getTop(uint _count) external view returns (
1275         address[] _addresses,
1276         uint[] _timestamps,
1277         uint[] _gasLimits,
1278         uint[] _gasPrices,
1279         uint[] _invokeGases,
1280         uint[] _rewardAmounts
1281     ) {
1282         uint length = joule.getCount();
1283         uint amount = _count <= length ? _count : length;
1284 
1285         _addresses = new address[](amount);
1286         _timestamps = new uint[](amount);
1287         _gasLimits = new uint[](amount);
1288         _gasPrices = new uint[](amount);
1289         _invokeGases = new uint[](amount);
1290         _rewardAmounts = new uint[](amount);
1291 
1292         uint i = 0;
1293 
1294         (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getTopOnce();
1295 
1296         for (i += 1; i < amount; i ++) {
1297             (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_addresses[i - 1], _timestamps[i - 1], _gasLimits[i - 1], _gasPrices[i - 1]);
1298         }
1299     }
1300 
1301     function getVersion() external view returns (bytes8) {
1302         return joule.getVersion();
1303     }
1304 
1305     function getMinGasPrice() public view returns (uint) {
1306         return joule.minGasPriceGwei() * GWEI;
1307     }
1308 
1309     function callback(address _invoker, address _address, uint, uint _gasLimit, uint) public onlyJoule returns (bool) {
1310         require(msg.gas >= _gasLimit);
1311         uint gas = msg.gas;
1312         bool status = _address.call.gas(_gasLimit)(0x919840ad);
1313         Invoked(_invoker, _address, status, gas - msg.gas);
1314         return status;
1315     }
1316 }