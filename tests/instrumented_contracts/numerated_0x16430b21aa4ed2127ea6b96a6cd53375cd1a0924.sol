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
286     uint constant JOULE_GAS = TRANSACTION_GAS + REMAINING_GAS + 8000;
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
297     bytes8 constant VERSION = 0x0108007f086575bc;
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
760             head = newId;
761         }
762         else {
763             require(state.get(_key) == id);
764             state.set(_key, newId);
765         }
766         state.swap(id, newId);
767         updateIndex(id, newId);
768     }
769 
770     function next() internal {
771         head = state.getAndDel(head);
772         length--;
773     }
774 
775     function getCount() public view returns (uint) {
776         return length;
777     }
778 
779     function getRecord(bytes32 _parent) internal view returns (bytes32 _record) {
780         if (_parent == 0) {
781             _record = head;
782         }
783         else {
784             _record = state.get(_parent);
785         }
786     }
787 
788     /**
789      * @dev Find previous key for existing value.
790      */
791     function findPrevious(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal view returns (bytes32) {
792         bytes32 target = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
793         bytes32 previous = head;
794         if (target == previous) {
795             return 0;
796         }
797         // if it is not head time
798         if (_timestamp != previous.getTimestamp()) {
799             previous = findFloorKeyIndex(_timestamp - 1);
800         }
801         bytes32 current = state.get(previous);
802         while (current != target) {
803             previous = current;
804             current = state.get(previous);
805         }
806         return previous;
807     }
808 }
809 
810 contract JouleVault is Ownable {
811     address public joule;
812 
813     function setJoule(address _joule) public onlyOwner {
814         joule = _joule;
815     }
816 
817     modifier onlyJoule() {
818         require(msg.sender == address(joule));
819         _;
820     }
821 
822     function withdraw(address _receiver, uint _amount) public onlyJoule {
823         _receiver.transfer(_amount);
824     }
825 
826     function () public payable {
827 
828     }
829 }
830 
831 contract JouleCore is JouleContractHolder {
832     JouleVault public vault;
833     uint32 public minGasPriceGwei = DEFAULT_MIN_GAS_PRICE_GWEI;
834     using KeysUtils for bytes32;
835 
836     function JouleCore(JouleVault _vault, bytes32 _head, uint _length, JouleStorage _storage) public
837         JouleContractHolder(_head, _length, _storage) {
838         vault = _vault;
839     }
840 
841     function innerRegister(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal returns (uint) {
842         uint price = getPriceInner(_gasLimit, _gasPrice);
843         require(msg.value >= price);
844         vault.transfer(price);
845 
846         // this restriction to avoid attack to brake index tree (crossing key)
847         require(_address != 0);
848         require(_timestamp > now);
849         require(_timestamp < 0x100000000);
850         require(_gasLimit <= MAX_GAS);
851         require(_gasLimit != 0);
852         // from 1 gwei to 0x100000000 gwei
853         require(_gasPrice >= minGasPriceGwei * GWEI);
854         require(_gasPrice < MAX_GAS_PRICE);
855         // 0 means not yet registered
856         require(_registrant != 0x0);
857 
858         uint innerGasPrice = _gasPrice / GWEI;
859         insert(_address, _timestamp, _gasLimit, innerGasPrice);
860         saveRegistrant(_registrant, _address, _timestamp, _gasLimit, innerGasPrice);
861 
862         if (msg.value > price) {
863             msg.sender.transfer(msg.value - price);
864             return msg.value - price;
865         }
866         return 0;
867     }
868 
869     function saveRegistrant(address _registrant, address _address, uint _timestamp, uint, uint) internal {
870         bytes32 id = KeysUtils.toKey(_address, _timestamp, 0, 0);
871         require(state.get(id) == 0);
872         state.set(id, bytes32(_registrant));
873     }
874 
875     function getRegistrant(address _address, uint _timestamp, uint, uint) internal view returns (address) {
876         bytes32 id = KeysUtils.toKey(_address, _timestamp, 0, 0);
877         return address(state.get(id));
878     }
879 
880     function delRegistrant(KeysUtils.Object memory current) internal {
881         bytes32 id = KeysUtils.toKey(current.contractAddress, current.timestamp, 0, 0);
882         state.del(id);
883     }
884 
885     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32) {
886         require(_address != 0);
887         require(_timestamp > now);
888         require(_timestamp < 0x100000000);
889         require(_gasLimit < MAX_GAS);
890         require(_gasPrice > GWEI);
891         require(_gasPrice < 0x100000000 * GWEI);
892         return findPrevious(_address, _timestamp, _gasLimit, _gasPrice / GWEI);
893     }
894 
895     function innerUnregister(address _registrant, bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal returns (uint) {
896         // only future registrations might be updated, to avoid race condition in block (with invoke)
897         require(_timestamp > now);
898         // to avoid removing already removed keys
899         require(_gasLimit != 0);
900         uint innerGasPrice = _gasPrice / GWEI;
901         // check registrant
902         address registrant = getRegistrant(_address, _timestamp, _gasLimit, innerGasPrice);
903         require(registrant == _registrant);
904 
905         updateGas(_key, _address, _timestamp, _gasLimit, innerGasPrice, 0);
906         uint amount = _gasLimit * _gasPrice;
907         if (amount != 0) {
908             vault.withdraw(registrant, amount);
909         }
910         return amount;
911     }
912 
913     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
914         require(_gasLimit <= MAX_GAS);
915         require(_gasPrice > GWEI);
916         require(_gasPrice < 0x100000000 * GWEI);
917 
918         return getPriceInner(_gasLimit, _gasPrice);
919     }
920 
921     function getPriceInner(uint _gasLimit, uint _gasPrice) internal pure returns (uint) {
922         // if this logic will be changed, look also to the innerUnregister method
923         return (_gasLimit + JOULE_GAS) * _gasPrice;
924     }
925 
926     function getVersion() external view returns (bytes8) {
927         return VERSION;
928     }
929 
930     function getTop(uint _count) external view returns (
931         address[] _addresses,
932         uint[] _timestamps,
933         uint[] _gasLimits,
934         uint[] _gasPrices,
935         uint[] _invokeGases,
936         uint[] _rewardAmounts
937     ) {
938         uint amount = _count <= length ? _count : length;
939 
940         _addresses = new address[](amount);
941         _timestamps = new uint[](amount);
942         _gasLimits = new uint[](amount);
943         _gasPrices = new uint[](amount);
944         _invokeGases = new uint[](amount);
945         _rewardAmounts = new uint[](amount);
946 
947         bytes32 current = getRecord(0);
948         for (uint i = 0; i < amount; i ++) {
949             KeysUtils.Object memory obj = current.toObject();
950             _addresses[i] = obj.contractAddress;
951             _timestamps[i] = obj.timestamp;
952             uint gasLimit = obj.gasLimit;
953             _gasLimits[i] = gasLimit;
954             uint gasPrice = obj.gasPriceGwei * GWEI;
955             _gasPrices[i] = gasPrice;
956             uint invokeGas = gasLimit + JOULE_GAS;
957             _invokeGases[i] = invokeGas;
958             _rewardAmounts[i] = invokeGas * gasPrice;
959             current = getRecord(current);
960         }
961     }
962 
963     function getTopOnce() external view returns (
964         address contractAddress,
965         uint timestamp,
966         uint gasLimit,
967         uint gasPrice,
968         uint invokeGas,
969         uint rewardAmount
970     ) {
971         KeysUtils.Object memory obj = getRecord(0).toObject();
972 
973         contractAddress = obj.contractAddress;
974         timestamp = obj.timestamp;
975         gasLimit = obj.gasLimit;
976         gasPrice = obj.gasPriceGwei * GWEI;
977         invokeGas = gasLimit + JOULE_GAS;
978         rewardAmount = invokeGas * gasPrice;
979     }
980 
981     function getNextOnce(address _contractAddress,
982                      uint _timestamp,
983                      uint _gasLimit,
984                      uint _gasPrice) public view returns (
985         address contractAddress,
986         uint timestamp,
987         uint gasLimit,
988         uint gasPrice,
989         uint invokeGas,
990         uint rewardAmount
991     ) {
992         if (_timestamp == 0) {
993             return this.getTopOnce();
994         }
995 
996         bytes32 prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
997         bytes32 current = getRecord(prev);
998         KeysUtils.Object memory obj = current.toObject();
999 
1000         contractAddress = obj.contractAddress;
1001         timestamp = obj.timestamp;
1002         gasLimit = obj.gasLimit;
1003         gasPrice = obj.gasPriceGwei * GWEI;
1004         invokeGas = gasLimit + JOULE_GAS;
1005         rewardAmount = invokeGas * gasPrice;
1006     }
1007 
1008     function getNext(uint _count,
1009                     address _contractAddress,
1010                     uint _timestamp,
1011                     uint _gasLimit,
1012                     uint _gasPrice) external view returns (address[] _addresses,
1013                                                         uint[] _timestamps,
1014                                                         uint[] _gasLimits,
1015                                                         uint[] _gasPrices,
1016                                                         uint[] _invokeGases,
1017                                                         uint[] _rewardAmounts) {
1018         _addresses = new address[](_count);
1019         _timestamps = new uint[](_count);
1020         _gasLimits = new uint[](_count);
1021         _gasPrices = new uint[](_count);
1022         _invokeGases = new uint[](_count);
1023         _rewardAmounts = new uint[](_count);
1024 
1025         bytes32 prev;
1026         if (_timestamp != 0) {
1027             prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
1028         }
1029 
1030         uint index = 0;
1031         while (index < _count) {
1032             bytes32 current = getRecord(prev);
1033             if (current == 0) {
1034                 break;
1035             }
1036             KeysUtils.Object memory obj = current.toObject();
1037 
1038             _addresses[index] = obj.contractAddress;
1039             _timestamps[index] = obj.timestamp;
1040             _gasLimits[index] = obj.gasLimit;
1041             _gasPrices[index] = obj.gasPriceGwei * GWEI;
1042             _invokeGases[index] = obj.gasLimit + JOULE_GAS;
1043             _rewardAmounts[index] = (obj.gasLimit + JOULE_GAS) * obj.gasPriceGwei * GWEI;
1044 
1045             prev = current;
1046             index ++;
1047         }
1048     }
1049 
1050     function next(KeysUtils.Object memory current) internal {
1051         delRegistrant(current);
1052         next();
1053     }
1054 
1055 
1056     function innerInvoke(address _invoker) internal returns (uint _amount) {
1057         KeysUtils.Object memory current = KeysUtils.toObject(head);
1058 
1059         uint amount;
1060         while (current.timestamp != 0 && current.timestamp < now && msg.gas > (current.gasLimit + REMAINING_GAS)) {
1061             if (current.gasLimit != 0) {
1062                 invokeCallback(_invoker, current);
1063             }
1064 
1065             amount += getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
1066             next(current);
1067             current = head.toObject();
1068         }
1069         if (amount > 0) {
1070             vault.withdraw(msg.sender, amount);
1071         }
1072         return amount;
1073     }
1074 
1075     function innerInvokeOnce(address _invoker) internal returns (uint _amount) {
1076         KeysUtils.Object memory current = head.toObject();
1077         next(current);
1078         if (current.gasLimit != 0) {
1079             invokeCallback(_invoker, current);
1080         }
1081 
1082         uint amount = getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
1083 
1084         if (amount > 0) {
1085             vault.withdraw(msg.sender, amount);
1086         }
1087         return amount;
1088     }
1089 
1090 
1091     function invokeCallback(address, KeysUtils.Object memory _record) internal returns (bool) {
1092         require(msg.gas >= _record.gasLimit);
1093         return _record.contractAddress.call.gas(_record.gasLimit)(0x919840ad);
1094     }
1095 
1096 }
1097 
1098 
1099 contract JouleBehindProxy is JouleCore, Ownable, TransferToken {
1100     JouleProxyAPI public proxy;
1101 
1102     function JouleBehindProxy(JouleVault _vault, bytes32 _head, uint _length, JouleStorage _storage) public
1103         JouleCore(_vault, _head, _length, _storage) {
1104     }
1105 
1106     function setProxy(JouleProxyAPI _proxy) public onlyOwner {
1107         proxy = _proxy;
1108     }
1109 
1110     modifier onlyProxy() {
1111         require(msg.sender == address(proxy));
1112         _;
1113     }
1114 
1115     function setMinGasPrice(uint _minGasPrice) public onlyOwner {
1116         require(_minGasPrice >= MIN_GAS_PRICE);
1117         require(_minGasPrice <= MAX_GAS_PRICE);
1118         minGasPriceGwei = uint32(_minGasPrice / GWEI);
1119     }
1120 
1121     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable onlyProxy returns (uint) {
1122         return innerRegister(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1123     }
1124 
1125     function unregisterFor(address _registrant, bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public onlyProxy returns (uint) {
1126         return innerUnregister(_registrant, _key, _address, _timestamp, _gasLimit, _gasPrice);
1127     }
1128 
1129     function invokeFor(address _invoker) public onlyProxy returns (uint) {
1130         return innerInvoke(_invoker);
1131     }
1132 
1133     function invokeOnceFor(address _invoker) public onlyProxy returns (uint) {
1134         return innerInvokeOnce(_invoker);
1135     }
1136 
1137     function invokeCallback(address _invoker, KeysUtils.Object memory _record) internal returns (bool) {
1138         return proxy.callback(_invoker, _record.contractAddress, _record.timestamp, _record.gasLimit, _record.gasPriceGwei * GWEI);
1139     }
1140 }
1141 
1142 contract JouleProxy is JouleProxyAPI, JouleAPI, Ownable, TransferToken, usingConsts {
1143     JouleBehindProxy public joule;
1144 
1145     function setJoule(JouleBehindProxy _joule) public onlyOwner {
1146         joule = _joule;
1147     }
1148 
1149     modifier onlyJoule() {
1150         require(msg.sender == address(joule));
1151         _;
1152     }
1153 
1154     function () public payable {
1155     }
1156 
1157     function getCount() public view returns (uint) {
1158         return joule.getCount();
1159     }
1160 
1161     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint) {
1162         return registerFor(msg.sender, _address, _timestamp, _gasLimit, _gasPrice);
1163     }
1164 
1165     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable returns (uint) {
1166         Registered(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1167         uint change = joule.registerFor.value(msg.value)(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1168         if (change > 0) {
1169             msg.sender.transfer(change);
1170         }
1171         return change;
1172     }
1173 
1174     function unregister(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external returns (uint) {
1175         // unregister will return funds to registrant, not to msg.sender (unlike register)
1176         uint amount = joule.unregisterFor(msg.sender, _key, _address, _timestamp, _gasLimit, _gasPrice);
1177         Unregistered(msg.sender, _address, _timestamp, _gasLimit, _gasPrice, amount);
1178         return amount;
1179     }
1180 
1181     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32) {
1182         return joule.findKey(_address, _timestamp, _gasLimit, _gasPrice);
1183     }
1184 
1185     function invoke() public returns (uint) {
1186         return invokeFor(msg.sender);
1187     }
1188 
1189     function invokeFor(address _invoker) public returns (uint) {
1190         uint amount = joule.invokeFor(_invoker);
1191         if (amount > 0) {
1192             msg.sender.transfer(amount);
1193         }
1194         return amount;
1195     }
1196 
1197     function invokeOnce() public returns (uint) {
1198         return invokeOnceFor(msg.sender);
1199     }
1200 
1201     function invokeOnceFor(address _invoker) public returns (uint) {
1202         uint amount = joule.invokeOnceFor(_invoker);
1203         if (amount > 0) {
1204             msg.sender.transfer(amount);
1205         }
1206         return amount;
1207     }
1208 
1209 
1210     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
1211         return joule.getPrice(_gasLimit, _gasPrice);
1212     }
1213 
1214     function getTopOnce() external view returns (
1215         address contractAddress,
1216         uint timestamp,
1217         uint gasLimit,
1218         uint gasPrice,
1219         uint invokeGas,
1220         uint rewardAmount
1221     ) {
1222         (contractAddress, timestamp, gasLimit, gasPrice, invokeGas, rewardAmount) = joule.getTopOnce();
1223     }
1224 
1225     function getNextOnce(address _contractAddress,
1226                      uint _timestamp,
1227                      uint _gasLimit,
1228                      uint _gasPrice) public view returns (
1229         address contractAddress,
1230         uint timestamp,
1231         uint gasLimit,
1232         uint gasPrice,
1233         uint invokeGas,
1234         uint rewardAmount
1235     ) {
1236         (contractAddress, timestamp, gasLimit, gasPrice, invokeGas, rewardAmount) = joule.getNextOnce(_contractAddress, _timestamp, _gasLimit, _gasPrice);
1237     }
1238 
1239 
1240     function getNext(uint _count,
1241                     address _contractAddress,
1242                     uint _timestamp,
1243                     uint _gasLimit,
1244                     uint _gasPrice) external view returns (
1245         address[] _addresses,
1246         uint[] _timestamps,
1247         uint[] _gasLimits,
1248         uint[] _gasPrices,
1249         uint[] _invokeGases,
1250         uint[] _rewardAmounts
1251     ) {
1252         _addresses = new address[](_count);
1253         _timestamps = new uint[](_count);
1254         _gasLimits = new uint[](_count);
1255         _gasPrices = new uint[](_count);
1256         _invokeGases = new uint[](_count);
1257         _rewardAmounts = new uint[](_count);
1258 
1259         uint i = 0;
1260 
1261         (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_contractAddress, _timestamp, _gasLimit, _gasPrice);
1262 
1263         for (i += 1; i < _count; i ++) {
1264             if (_timestamps[i - 1] == 0) {
1265                 break;
1266             }
1267             (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_addresses[i - 1], _timestamps[i - 1], _gasLimits[i - 1], _gasPrices[i - 1]);
1268         }
1269     }
1270 
1271 
1272     function getTop(uint _count) external view returns (
1273         address[] _addresses,
1274         uint[] _timestamps,
1275         uint[] _gasLimits,
1276         uint[] _gasPrices,
1277         uint[] _invokeGases,
1278         uint[] _rewardAmounts
1279     ) {
1280         uint length = joule.getCount();
1281         uint amount = _count <= length ? _count : length;
1282 
1283         _addresses = new address[](amount);
1284         _timestamps = new uint[](amount);
1285         _gasLimits = new uint[](amount);
1286         _gasPrices = new uint[](amount);
1287         _invokeGases = new uint[](amount);
1288         _rewardAmounts = new uint[](amount);
1289 
1290         uint i = 0;
1291 
1292         (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getTopOnce();
1293 
1294         for (i += 1; i < amount; i ++) {
1295             (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_addresses[i - 1], _timestamps[i - 1], _gasLimits[i - 1], _gasPrices[i - 1]);
1296         }
1297     }
1298 
1299     function getVersion() external view returns (bytes8) {
1300         return joule.getVersion();
1301     }
1302 
1303     function getMinGasPrice() public view returns (uint) {
1304         return joule.minGasPriceGwei() * GWEI;
1305     }
1306 
1307     function callback(address _invoker, address _address, uint, uint _gasLimit, uint) public onlyJoule returns (bool) {
1308         require(msg.gas >= _gasLimit);
1309         uint gas = msg.gas;
1310         bool status = _address.call.gas(_gasLimit)(0x919840ad);
1311         Invoked(_invoker, _address, status, gas - msg.gas);
1312         return status;
1313     }
1314 }