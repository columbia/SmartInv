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
291     uint constant JOULE_GAS = TRANSACTION_GAS + REMAINING_GAS + 8000;
292     // gas required to invoke, but all gas would be returned or not used, so it is rewarded
293     uint constant JOULE_INVOKE_GAS = 10000;
294     // there is correlation between amount of registered gas and required gas to invoke - 5%
295     uint constant JOULE_INVOKE_GAS_PERCENT = 5;
296 
297     // minimal default gas price (because of network load)
298     uint32 constant DEFAULT_MIN_GAS_PRICE_GWEI = 20;
299     // min gas price
300     uint constant MIN_GAS_PRICE = GWEI;
301     // max gas price
302     uint constant MAX_GAS_PRICE = 0xffffffff * GWEI;
303     // not, it mist be less then 0x00ffffff, because high bytes might be used for storing flags
304     uint constant MAX_GAS = 4000000;
305     // Code version
306     bytes8 constant VERSION = 0x010800b10266e773;
307     //                          ^^ - major
308     //                            ^^ - minor
309     //                              ^^^^ - build
310     //                                  ^^^^^^^^ - git hash
311 }
312 
313 
314 
315 library KeysUtils {
316     // Such order is important to load from state
317     struct Object {
318         uint32 gasPriceGwei;
319         uint32 gasLimit;
320         uint32 timestamp;
321         address contractAddress;
322     }
323 
324     function toKey(Object _obj) internal pure returns (bytes32) {
325         return toKey(_obj.contractAddress, _obj.timestamp, _obj.gasLimit, _obj.gasPriceGwei);
326     }
327 
328     function toKeyFromStorage(Object storage _obj) internal view returns (bytes32 _key) {
329         assembly {
330             _key := sload(_obj_slot)
331         }
332     }
333 
334     function toKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal pure returns (bytes32 result) {
335         result = 0x0000000000000000000000000000000000000000000000000000000000000000;
336         //         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ - address (20 bytes)
337         //                                                 ^^^^^^^^ - timestamp (4 bytes)
338         //                                                         ^^^^^^^^ - gas limit (4 bytes)
339         //                                                                 ^^^^^^^^ - gas price (4 bytes)
340         assembly {
341             result := or(result, mul(_address, 0x1000000000000000000000000))
342             result := or(result, mul(and(_timestamp, 0xffffffff), 0x10000000000000000))
343             result := or(result, mul(and(_gasLimit, 0xffffffff), 0x100000000))
344             result := or(result, and(_gasPrice, 0xffffffff))
345         }
346     }
347 
348     function toMemoryObject(bytes32 _key, Object memory _dest) internal pure {
349         assembly {
350             mstore(_dest, and(_key, 0xffffffff))
351             mstore(add(_dest, 0x20), and(div(_key, 0x100000000), 0xffffffff))
352             mstore(add(_dest, 0x40), and(div(_key, 0x10000000000000000), 0xffffffff))
353             mstore(add(_dest, 0x60), div(_key, 0x1000000000000000000000000))
354         }
355     }
356 
357     function toObject(bytes32 _key) internal pure returns (Object memory _dest) {
358         toMemoryObject(_key, _dest);
359     }
360 
361     function toStateObject(bytes32 _key, Object storage _dest) internal {
362         assembly {
363             sstore(_dest_slot, _key)
364         }
365     }
366 
367     function getTimestamp(bytes32 _key) internal pure returns (uint result) {
368         assembly {
369             result := and(div(_key, 0x10000000000000000), 0xffffffff)
370         }
371     }
372 }
373 
374 contract Restriction {
375     mapping (address => bool) internal accesses;
376 
377     function Restriction() public {
378         accesses[msg.sender] = true;
379     }
380 
381     function giveAccess(address _addr) public restricted {
382         accesses[_addr] = true;
383     }
384 
385     function removeAccess(address _addr) public restricted {
386         delete accesses[_addr];
387     }
388 
389     function hasAccess() public constant returns (bool) {
390         return accesses[msg.sender];
391     }
392 
393     modifier restricted() {
394         require(hasAccess());
395         _;
396     }
397 }
398 
399 contract JouleStorage is Restriction {
400     mapping(bytes32 => bytes32) map;
401 
402     function get(bytes32 _key) public view returns (bytes32 _value) {
403         return map[_key];
404     }
405 
406     function set(bytes32 _key, bytes32 _value) public restricted {
407         map[_key] = _value;
408     }
409 
410     function del(bytes32 _key) public restricted {
411         delete map[_key];
412     }
413 
414     function getAndDel(bytes32 _key) public restricted returns (bytes32 _value) {
415         _value = map[_key];
416         delete map[_key];
417     }
418 
419     function swap(bytes32 _from, bytes32 _to) public restricted returns (bytes32 _value) {
420         _value = map[_to];
421         map[_to] = map[_from];
422         delete map[_from];
423     }
424 }
425 
426 contract JouleIndexCore {
427     using KeysUtils for bytes32;
428     uint constant YEAR = 0x1DFE200;
429     bytes32 constant HEAD = 0x0;
430 
431     // YEAR -> week -> hour -> minute
432     JouleStorage public state;
433 
434     function JouleIndexCore(JouleStorage _storage) public {
435         state = _storage;
436     }
437 
438     function insertIndex(bytes32 _key) internal {
439         uint timestamp = _key.getTimestamp();
440         bytes32 year = toKey(timestamp, YEAR);
441         bytes32 headLow;
442         bytes32 headHigh;
443         (headLow, headHigh) = fromValue(state.get(HEAD));
444         if (year < headLow || headLow == 0 || year > headHigh) {
445             if (year < headLow || headLow == 0) {
446                 headLow = year;
447             }
448             if (year > headHigh) {
449                 headHigh = year;
450             }
451             state.set(HEAD, toValue(headLow, headHigh));
452         }
453 
454         bytes32 week = toKey(timestamp, 1 weeks);
455         bytes32 low;
456         bytes32 high;
457         (low, high) = fromValue(state.get(year));
458         if (week < low || week > high) {
459             if (week < low || low == 0) {
460                 low = week;
461             }
462             if (week > high) {
463                 high = week;
464             }
465             state.set(year, toValue(low, high));
466         }
467 
468         (low, high) = fromValue(state.get(week));
469         bytes32 hour = toKey(timestamp, 1 hours);
470         if (hour < low || hour > high) {
471             if (hour < low || low == 0) {
472                 low = hour;
473             }
474             if (hour > high) {
475                 high = hour;
476             }
477             state.set(week, toValue(low, high));
478         }
479 
480         (low, high) = fromValue(state.get(hour));
481         bytes32 minute = toKey(timestamp, 1 minutes);
482         if (minute < low || minute > high) {
483             if (minute < low || low == 0) {
484                 low = minute;
485             }
486             if (minute > high) {
487                 high = minute;
488             }
489             state.set(hour, toValue(low, high));
490         }
491 
492         (low, high) = fromValue(state.get(minute));
493         bytes32 tsKey = toKey(timestamp);
494         if (tsKey < low || tsKey > high) {
495             if (tsKey < low || low == 0) {
496                 low = tsKey;
497             }
498             if (tsKey > high) {
499                 high = tsKey;
500             }
501             state.set(minute, toValue(low, high));
502         }
503 
504         state.set(tsKey, _key);
505     }
506 
507     /**
508      * @dev Update key value from the previous state to new. Timestamp MUST be the same on both keys.
509      */
510     function updateIndex(bytes32 _prev, bytes32 _key) internal {
511         uint timestamp = _key.getTimestamp();
512         bytes32 tsKey = toKey(timestamp);
513         bytes32 prevKey = state.get(tsKey);
514         // on the same timestamp might be other key, in that case we do not need to update it
515         if (prevKey != _prev) {
516             return;
517         }
518         state.set(tsKey, _key);
519     }
520 
521     function findFloorKeyYear(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
522         bytes32 year = toKey(_timestamp, YEAR);
523         if (year < _low) {
524             return 0;
525         }
526         if (year > _high) {
527             // week
528             (low, high) = fromValue(state.get(_high));
529             // hour
530             (low, high) = fromValue(state.get(high));
531             // minute
532             (low, high) = fromValue(state.get(high));
533             // ts
534             (low, high) = fromValue(state.get(high));
535             return state.get(high);
536         }
537 
538         bytes32 low;
539         bytes32 high;
540 
541         while (year >= _low) {
542             (low, high) = fromValue(state.get(year));
543             if (low != 0) {
544                 bytes32 key = findFloorKeyWeek(_timestamp, low, high);
545                 if (key != 0) {
546                     return key;
547                 }
548             }
549             // 0x1DFE200 = 52 weeks = 31449600
550             assembly {
551                 year := sub(year, 0x1DFE200)
552             }
553         }
554 
555         return 0;
556     }
557 
558     function findFloorKeyWeek(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
559         bytes32 week = toKey(_timestamp, 1 weeks);
560         if (week < _low) {
561             return 0;
562         }
563 
564         bytes32 low;
565         bytes32 high;
566 
567         if (week > _high) {
568             // hour
569             (low, high) = fromValue(state.get(_high));
570             // minute
571             (low, high) = fromValue(state.get(high));
572             // ts
573             (low, high) = fromValue(state.get(high));
574             return state.get(high);
575         }
576 
577         while (week >= _low) {
578             (low, high) = fromValue(state.get(week));
579             if (low != 0) {
580                 bytes32 key = findFloorKeyHour(_timestamp, low, high);
581                 if (key != 0) {
582                     return key;
583                 }
584             }
585 
586             // 1 weeks = 604800
587             assembly {
588                 week := sub(week, 604800)
589             }
590         }
591         return 0;
592     }
593 
594 
595     function findFloorKeyHour(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
596         bytes32 hour = toKey(_timestamp, 1 hours);
597         if (hour < _low) {
598             return 0;
599         }
600 
601         bytes32 low;
602         bytes32 high;
603 
604         if (hour > _high) {
605             // minute
606             (low, high) = fromValue(state.get(_high));
607             // ts
608             (low, high) = fromValue(state.get(high));
609             return state.get(high);
610         }
611 
612         while (hour >= _low) {
613             (low, high) = fromValue(state.get(hour));
614             if (low != 0) {
615                 bytes32 key = findFloorKeyMinute(_timestamp, low, high);
616                 if (key != 0) {
617                     return key;
618                 }
619             }
620 
621             // 1 hours = 3600
622             assembly {
623                 hour := sub(hour, 3600)
624             }
625         }
626         return 0;
627     }
628 
629     function findFloorKeyMinute(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
630         bytes32 minute = toKey(_timestamp, 1 minutes);
631         if (minute < _low) {
632             return 0;
633         }
634 
635         bytes32 low;
636         bytes32 high;
637 
638         if (minute > _high) {
639             // ts
640             (low, high) = fromValue(state.get(_high));
641             return state.get(high);
642         }
643 
644         while (minute >= _low) {
645             (low, high) = fromValue(state.get(minute));
646             if (low != 0) {
647                 bytes32 key = findFloorKeyTimestamp(_timestamp, low, high);
648                 if (key != 0) {
649                     return key;
650                 }
651             }
652 
653             // 1 minutes = 60
654             assembly {
655                 minute := sub(minute, 60)
656             }
657         }
658 
659         return 0;
660     }
661 
662     function findFloorKeyTimestamp(uint _timestamp, bytes32 _low, bytes32 _high) view private returns (bytes32) {
663         bytes32 tsKey = toKey(_timestamp);
664         if (tsKey < _low) {
665             return 0;
666         }
667         if (tsKey > _high) {
668             return state.get(_high);
669         }
670 
671         while (tsKey >= _low) {
672             bytes32 key = state.get(tsKey);
673             if (key != 0) {
674                 return key;
675             }
676             assembly {
677                 tsKey := sub(tsKey, 1)
678             }
679         }
680         return 0;
681     }
682 
683     function findFloorKeyIndex(uint _timestamp) view internal returns (bytes32) {
684 //        require(_timestamp > 0xffffffff);
685 //        if (_timestamp < 1515612415) {
686 //            return 0;
687 //        }
688 
689         bytes32 yearLow;
690         bytes32 yearHigh;
691         (yearLow, yearHigh) = fromValue(state.get(HEAD));
692 
693         return findFloorKeyYear(_timestamp, yearLow, yearHigh);
694     }
695 
696     function toKey(uint _timestamp, uint rounder) pure private returns (bytes32 result) {
697         // 0x0...00000000000000000
698         //        ^^^^^^^^ - rounder marker (eg, to avoid crossing first day of year with year)
699         //                ^^^^^^^^ - rounded moment (year, week, etc)
700         assembly {
701             result := or(mul(rounder, 0x100000000), mul(div(_timestamp, rounder), rounder))
702         }
703     }
704 
705     function toValue(bytes32 _lowKey, bytes32 _highKey) pure private returns (bytes32 result) {
706         assembly {
707             result := or(mul(_lowKey, 0x10000000000000000), _highKey)
708         }
709     }
710 
711     function fromValue(bytes32 _value) pure private returns (bytes32 _lowKey, bytes32 _highKey) {
712         assembly {
713             _lowKey := and(div(_value, 0x10000000000000000), 0xffffffffffffffff)
714             _highKey := and(_value, 0xffffffffffffffff)
715         }
716     }
717 
718     function toKey(uint timestamp) pure internal returns (bytes32) {
719         return bytes32(timestamp);
720     }
721 }
722 
723 
724 contract JouleContractHolder is JouleIndexCore, usingConsts {
725     using KeysUtils for bytes32;
726     uint internal length;
727     bytes32 public head;
728 
729     function JouleContractHolder(bytes32 _head, uint _length, JouleStorage _storage) public
730             JouleIndexCore(_storage) {
731         head = _head;
732         length = _length;
733     }
734 
735     function insert(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal {
736         length ++;
737         bytes32 id = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
738         if (head == 0) {
739             head = id;
740             insertIndex(id);
741 //            Found(0xffffffff);
742             return;
743         }
744         bytes32 previous = findFloorKeyIndex(_timestamp);
745 
746         // reject duplicate key on the end
747         require(previous != id);
748         // reject duplicate in the middle
749         require(state.get(id) == 0);
750 
751         uint prevTimestamp = previous.getTimestamp();
752 //        Found(prevTimestamp);
753         uint headTimestamp = head.getTimestamp();
754         // add as head, prevTimestamp == 0 or in the past
755         if (prevTimestamp < headTimestamp) {
756             state.set(id, head);
757             head = id;
758         }
759         // add after the previous
760         else {
761             state.set(id, state.get(previous));
762             state.set(previous, id);
763         }
764         insertIndex(id);
765     }
766 
767     function updateGas(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice, uint _newGasLimit) internal {
768         bytes32 id = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
769         bytes32 newId = KeysUtils.toKey(_address, _timestamp, _newGasLimit, _gasPrice);
770         if (id == head) {
771             head = newId;
772         }
773         else {
774             require(state.get(_key) == id);
775             state.set(_key, newId);
776         }
777         state.swap(id, newId);
778         updateIndex(id, newId);
779     }
780 
781     function next() internal {
782         head = state.getAndDel(head);
783         length--;
784     }
785 
786     function getCount() public view returns (uint) {
787         return length;
788     }
789 
790     function getRecord(bytes32 _parent) internal view returns (bytes32 _record) {
791         if (_parent == 0) {
792             _record = head;
793         }
794         else {
795             _record = state.get(_parent);
796         }
797     }
798 
799     /**
800      * @dev Find previous key for existing value.
801      */
802     function findPrevious(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal view returns (bytes32) {
803         bytes32 target = KeysUtils.toKey(_address, _timestamp, _gasLimit, _gasPrice);
804         bytes32 previous = head;
805         if (target == previous) {
806             return 0;
807         }
808         // if it is not head time
809         if (_timestamp != previous.getTimestamp()) {
810             previous = findFloorKeyIndex(_timestamp - 1);
811         }
812         bytes32 current = state.get(previous);
813         while (current != target) {
814             previous = current;
815             current = state.get(previous);
816         }
817         return previous;
818     }
819 }
820 
821 contract JouleVault is Ownable {
822     address public joule;
823 
824     function setJoule(address _joule) public onlyOwner {
825         joule = _joule;
826     }
827 
828     modifier onlyJoule() {
829         require(msg.sender == address(joule));
830         _;
831     }
832 
833     function withdraw(address _receiver, uint _amount) public onlyJoule {
834         _receiver.transfer(_amount);
835     }
836 
837     function () public payable {
838 
839     }
840 }
841 
842 contract JouleCore is JouleContractHolder {
843     event Gas(uint);
844     JouleVault public vault;
845     uint32 public minGasPriceGwei = DEFAULT_MIN_GAS_PRICE_GWEI;
846     using KeysUtils for bytes32;
847 
848     function JouleCore(JouleVault _vault, bytes32 _head, uint _length, JouleStorage _storage) public
849         JouleContractHolder(_head, _length, _storage) {
850         vault = _vault;
851     }
852 
853     function innerRegister(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal returns (uint) {
854         uint price = getPriceInner(_gasLimit, _gasPrice);
855         require(msg.value >= price);
856         vault.transfer(price);
857 
858         // this restriction to avoid attack to brake index tree (crossing key)
859         require(_address != 0);
860         require(_timestamp > now);
861         require(_timestamp < 0x100000000);
862         require(_gasLimit <= MAX_GAS);
863         require(_gasLimit != 0);
864         // from 1 gwei to 0x100000000 gwei
865         require(_gasPrice >= minGasPriceGwei * GWEI);
866         require(_gasPrice < MAX_GAS_PRICE);
867         // 0 means not yet registered
868         require(_registrant != 0x0);
869 
870         uint innerGasPrice = _gasPrice / GWEI;
871         insert(_address, _timestamp, _gasLimit, innerGasPrice);
872         saveRegistrant(_registrant, _address, _timestamp, _gasLimit, innerGasPrice);
873 
874         if (msg.value > price) {
875             msg.sender.transfer(msg.value - price);
876             return msg.value - price;
877         }
878         return 0;
879     }
880 
881     function saveRegistrant(address _registrant, address _address, uint _timestamp, uint, uint) internal {
882         bytes32 id = KeysUtils.toKey(_address, _timestamp, 0, 0);
883         require(state.get(id) == 0);
884         state.set(id, bytes32(_registrant));
885     }
886 
887     function getRegistrant(address _address, uint _timestamp, uint, uint) internal view returns (address) {
888         bytes32 id = KeysUtils.toKey(_address, _timestamp, 0, 0);
889         return address(state.get(id));
890     }
891 
892     function delRegistrant(KeysUtils.Object memory current) internal {
893         bytes32 id = KeysUtils.toKey(current.contractAddress, current.timestamp, 0, 0);
894         state.del(id);
895     }
896 
897     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32) {
898         require(_address != 0);
899         require(_timestamp > now);
900         require(_timestamp < 0x100000000);
901         require(_gasLimit <= MAX_GAS);
902         require(_gasPrice > GWEI);
903         require(_gasPrice < 0x100000000 * GWEI);
904         return findPrevious(_address, _timestamp, _gasLimit, _gasPrice / GWEI);
905     }
906 
907     function innerUnregister(address _registrant, bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) internal returns (uint) {
908         // only future registrations might be updated, to avoid race condition in block (with invoke)
909         require(_timestamp > now);
910         // to avoid removing already removed keys
911         require(_gasLimit != 0);
912         uint innerGasPrice = _gasPrice / GWEI;
913         // check registrant
914         address registrant = getRegistrant(_address, _timestamp, _gasLimit, innerGasPrice);
915         require(registrant == _registrant);
916 
917         updateGas(_key, _address, _timestamp, _gasLimit, innerGasPrice, 0);
918         uint amount = _gasLimit * _gasPrice;
919         if (amount != 0) {
920             vault.withdraw(registrant, amount);
921         }
922         return amount;
923     }
924 
925     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
926         require(_gasLimit <= MAX_GAS);
927         require(_gasPrice > GWEI);
928         require(_gasPrice < 0x100000000 * GWEI);
929 
930         return getPriceInner(_gasLimit, _gasPrice);
931     }
932 
933     function getPriceInner(uint _gasLimit, uint _gasPrice) internal pure returns (uint) {
934         // if this logic will be changed, look also to the innerUnregister method
935         return (_gasLimit + JOULE_GAS) * _gasPrice;
936     }
937 
938     function getVersion() external view returns (bytes8) {
939         return VERSION;
940     }
941 
942     function getTop(uint _count) external view returns (
943         address[] _addresses,
944         uint[] _timestamps,
945         uint[] _gasLimits,
946         uint[] _gasPrices,
947         uint[] _invokeGases,
948         uint[] _rewardAmounts
949     ) {
950         uint amount = _count <= length ? _count : length;
951 
952         _addresses = new address[](amount);
953         _timestamps = new uint[](amount);
954         _gasLimits = new uint[](amount);
955         _gasPrices = new uint[](amount);
956         _invokeGases = new uint[](amount);
957         _rewardAmounts = new uint[](amount);
958 
959         bytes32 current = getRecord(0);
960         for (uint i = 0; i < amount; i ++) {
961             KeysUtils.Object memory obj = current.toObject();
962             _addresses[i] = obj.contractAddress;
963             _timestamps[i] = obj.timestamp;
964             _gasLimits[i] = obj.gasLimit;
965             _gasPrices[i] = obj.gasPriceGwei * GWEI;
966             _invokeGases[i] = calcInvokeGas(obj.gasLimit);
967             _rewardAmounts[i] = calcReward(obj.gasLimit, obj.gasPriceGwei);
968             current = getRecord(current);
969         }
970     }
971 
972     function getTopOnce() external view returns (
973         address contractAddress,
974         uint timestamp,
975         uint gasLimit,
976         uint gasPrice,
977         uint invokeGas,
978         uint rewardAmount
979     ) {
980         KeysUtils.Object memory obj = getRecord(0).toObject();
981 
982         contractAddress = obj.contractAddress;
983         timestamp = obj.timestamp;
984         gasLimit = obj.gasLimit;
985         gasPrice = obj.gasPriceGwei * GWEI;
986         invokeGas = calcInvokeGas(obj.gasLimit);
987         rewardAmount = calcReward(obj.gasLimit, obj.gasPriceGwei);
988     }
989 
990     function getNextOnce(address _contractAddress,
991                      uint _timestamp,
992                      uint _gasLimit,
993                      uint _gasPrice) public view returns (
994         address contractAddress,
995         uint timestamp,
996         uint gasLimit,
997         uint gasPrice,
998         uint invokeGas,
999         uint rewardAmount
1000     ) {
1001         if (_timestamp == 0) {
1002             return this.getTopOnce();
1003         }
1004 
1005         bytes32 prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
1006         bytes32 current = getRecord(prev);
1007         KeysUtils.Object memory obj = current.toObject();
1008 
1009         contractAddress = obj.contractAddress;
1010         timestamp = obj.timestamp;
1011         gasLimit = obj.gasLimit;
1012         gasPrice = obj.gasPriceGwei * GWEI;
1013         invokeGas = calcInvokeGas(obj.gasLimit);
1014         rewardAmount = calcReward(obj.gasLimit, obj.gasPriceGwei);
1015     }
1016 
1017     function getNext(uint _count,
1018                     address _contractAddress,
1019                     uint _timestamp,
1020                     uint _gasLimit,
1021                     uint _gasPrice) external view returns (address[] _addresses,
1022                                                         uint[] _timestamps,
1023                                                         uint[] _gasLimits,
1024                                                         uint[] _gasPrices,
1025                                                         uint[] _invokeGases,
1026                                                         uint[] _rewardAmounts) {
1027         _addresses = new address[](_count);
1028         _timestamps = new uint[](_count);
1029         _gasLimits = new uint[](_count);
1030         _gasPrices = new uint[](_count);
1031         _invokeGases = new uint[](_count);
1032         _rewardAmounts = new uint[](_count);
1033 
1034         bytes32 prev;
1035         if (_timestamp != 0) {
1036             prev = KeysUtils.toKey(_contractAddress, _timestamp, _gasLimit, _gasPrice / GWEI);
1037         }
1038 
1039         uint index = 0;
1040         while (index < _count) {
1041             bytes32 current = getRecord(prev);
1042             if (current == 0) {
1043                 break;
1044             }
1045             KeysUtils.Object memory obj = current.toObject();
1046 
1047             _addresses[index] = obj.contractAddress;
1048             _timestamps[index] = obj.timestamp;
1049             _gasLimits[index] = obj.gasLimit;
1050             _gasPrices[index] = obj.gasPriceGwei * GWEI;
1051             _invokeGases[index] = calcInvokeGas(obj.gasLimit);
1052             _rewardAmounts[index] = calcReward(obj.gasLimit, obj.gasPriceGwei);
1053 
1054             prev = current;
1055             index ++;
1056         }
1057     }
1058 
1059     function next(KeysUtils.Object memory current) internal {
1060         delRegistrant(current);
1061         next();
1062     }
1063 
1064     function innerInvoke(address _invoker) internal returns (uint _amount) {
1065         KeysUtils.Object memory current = head.toObject();
1066         uint amount;
1067         while (current.timestamp != 0 && current.timestamp < now && msg.gas >= (current.gasLimit + REMAINING_GAS)) {
1068             if (current.gasLimit != 0) {
1069                 invokeCallback(_invoker, current);
1070             }
1071 
1072             amount += getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
1073             next(current);
1074             current = head.toObject();
1075         }
1076         if (amount != 0) {
1077             vault.withdraw(msg.sender, amount);
1078         }
1079         return amount;
1080     }
1081 
1082     function innerInvokeOnce(address _invoker) internal returns (uint _amount) {
1083         KeysUtils.Object memory current = head.toObject();
1084         next(current);
1085         if (current.gasLimit != 0) {
1086             invokeCallback(_invoker, current);
1087         }
1088 
1089         uint amount = getPriceInner(current.gasLimit, current.gasPriceGwei * GWEI);
1090 
1091         if (amount > 0) {
1092             vault.withdraw(msg.sender, amount);
1093         }
1094         return amount;
1095     }
1096 
1097 
1098     function invokeCallback(address, KeysUtils.Object memory _record) internal returns (bool) {
1099         require(msg.gas >= _record.gasLimit);
1100         return _record.contractAddress.call.gas(_record.gasLimit)(0x919840ad);
1101     }
1102 
1103     function calcInvokeGas(uint _contractGasLimit) internal pure returns (uint) {
1104         return _contractGasLimit + JOULE_GAS + JOULE_INVOKE_GAS + _contractGasLimit * JOULE_INVOKE_GAS_PERCENT / 100;
1105     }
1106 
1107     function calcReward(uint _contractGasLimit, uint _gasPriceGwei) internal pure returns (uint) {
1108         return (_contractGasLimit + JOULE_GAS) * _gasPriceGwei * GWEI;
1109     }
1110 
1111 }
1112 
1113 
1114 contract JouleBehindProxy is JouleCore, Ownable, TransferToken {
1115     JouleProxyAPI public proxy;
1116 
1117     function JouleBehindProxy(JouleVault _vault, bytes32 _head, uint _length, JouleStorage _storage) public
1118         JouleCore(_vault, _head, _length, _storage) {
1119     }
1120 
1121     function setProxy(JouleProxyAPI _proxy) public onlyOwner {
1122         proxy = _proxy;
1123     }
1124 
1125     modifier onlyProxy() {
1126         require(msg.sender == address(proxy));
1127         _;
1128     }
1129 
1130     function setMinGasPrice(uint _minGasPrice) public onlyOwner {
1131         require(_minGasPrice >= MIN_GAS_PRICE);
1132         require(_minGasPrice <= MAX_GAS_PRICE);
1133         minGasPriceGwei = uint32(_minGasPrice / GWEI);
1134     }
1135 
1136     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable onlyProxy returns (uint) {
1137         return innerRegister(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1138     }
1139 
1140     function unregisterFor(address _registrant, bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public onlyProxy returns (uint) {
1141         return innerUnregister(_registrant, _key, _address, _timestamp, _gasLimit, _gasPrice);
1142     }
1143 
1144     function invokeFor(address _invoker) public onlyProxy returns (uint) {
1145         return innerInvoke(_invoker);
1146     }
1147 
1148     function invokeOnceFor(address _invoker) public onlyProxy returns (uint) {
1149         return innerInvokeOnce(_invoker);
1150     }
1151 
1152     function invokeCallback(address _invoker, KeysUtils.Object memory _record) internal returns (bool) {
1153         return proxy.callback(_invoker, _record.contractAddress, _record.timestamp, _record.gasLimit, _record.gasPriceGwei * GWEI);
1154     }
1155 }
1156 
1157 contract JouleProxy is JouleProxyAPI, JouleAPI, Ownable, TransferToken, usingConsts {
1158     JouleBehindProxy public joule;
1159 
1160     function setJoule(JouleBehindProxy _joule) public onlyOwner {
1161         joule = _joule;
1162     }
1163 
1164     modifier onlyJoule() {
1165         require(msg.sender == address(joule));
1166         _;
1167     }
1168 
1169     function () public payable {
1170     }
1171 
1172     function getCount() public view returns (uint) {
1173         return joule.getCount();
1174     }
1175 
1176     function register(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external payable returns (uint) {
1177         return registerFor(msg.sender, _address, _timestamp, _gasLimit, _gasPrice);
1178     }
1179 
1180     function registerFor(address _registrant, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public payable returns (uint) {
1181         Registered(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1182         uint change = joule.registerFor.value(msg.value)(_registrant, _address, _timestamp, _gasLimit, _gasPrice);
1183         if (change > 0) {
1184             msg.sender.transfer(change);
1185         }
1186         return change;
1187     }
1188 
1189     function unregister(bytes32 _key, address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) external returns (uint) {
1190         // unregister will return funds to registrant, not to msg.sender (unlike register)
1191         uint amount = joule.unregisterFor(msg.sender, _key, _address, _timestamp, _gasLimit, _gasPrice);
1192         Unregistered(msg.sender, _address, _timestamp, _gasLimit, _gasPrice, amount);
1193         return amount;
1194     }
1195 
1196     function findKey(address _address, uint _timestamp, uint _gasLimit, uint _gasPrice) public view returns (bytes32) {
1197         return joule.findKey(_address, _timestamp, _gasLimit, _gasPrice);
1198     }
1199 
1200     function invoke() public returns (uint) {
1201         return invokeFor(msg.sender);
1202     }
1203 
1204     function invokeFor(address _invoker) public returns (uint) {
1205         uint amount = joule.invokeFor(_invoker);
1206         if (amount > 0) {
1207             msg.sender.transfer(amount);
1208         }
1209         return amount;
1210     }
1211 
1212     function invokeOnce() public returns (uint) {
1213         return invokeOnceFor(msg.sender);
1214     }
1215 
1216     function invokeOnceFor(address _invoker) public returns (uint) {
1217         uint amount = joule.invokeOnceFor(_invoker);
1218         if (amount > 0) {
1219             msg.sender.transfer(amount);
1220         }
1221         return amount;
1222     }
1223 
1224 
1225     function getPrice(uint _gasLimit, uint _gasPrice) external view returns (uint) {
1226         return joule.getPrice(_gasLimit, _gasPrice);
1227     }
1228 
1229     function getTopOnce() external view returns (
1230         address contractAddress,
1231         uint timestamp,
1232         uint gasLimit,
1233         uint gasPrice,
1234         uint invokeGas,
1235         uint rewardAmount
1236     ) {
1237         (contractAddress, timestamp, gasLimit, gasPrice, invokeGas, rewardAmount) = joule.getTopOnce();
1238     }
1239 
1240     function getNextOnce(address _contractAddress,
1241                      uint _timestamp,
1242                      uint _gasLimit,
1243                      uint _gasPrice) public view returns (
1244         address contractAddress,
1245         uint timestamp,
1246         uint gasLimit,
1247         uint gasPrice,
1248         uint invokeGas,
1249         uint rewardAmount
1250     ) {
1251         (contractAddress, timestamp, gasLimit, gasPrice, invokeGas, rewardAmount) = joule.getNextOnce(_contractAddress, _timestamp, _gasLimit, _gasPrice);
1252     }
1253 
1254 
1255     function getNext(uint _count,
1256                     address _contractAddress,
1257                     uint _timestamp,
1258                     uint _gasLimit,
1259                     uint _gasPrice) external view returns (
1260         address[] _addresses,
1261         uint[] _timestamps,
1262         uint[] _gasLimits,
1263         uint[] _gasPrices,
1264         uint[] _invokeGases,
1265         uint[] _rewardAmounts
1266     ) {
1267         _addresses = new address[](_count);
1268         _timestamps = new uint[](_count);
1269         _gasLimits = new uint[](_count);
1270         _gasPrices = new uint[](_count);
1271         _invokeGases = new uint[](_count);
1272         _rewardAmounts = new uint[](_count);
1273 
1274         uint i = 0;
1275 
1276         (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_contractAddress, _timestamp, _gasLimit, _gasPrice);
1277 
1278         for (i += 1; i < _count; i ++) {
1279             if (_timestamps[i - 1] == 0) {
1280                 break;
1281             }
1282             (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_addresses[i - 1], _timestamps[i - 1], _gasLimits[i - 1], _gasPrices[i - 1]);
1283         }
1284     }
1285 
1286 
1287     function getTop(uint _count) external view returns (
1288         address[] _addresses,
1289         uint[] _timestamps,
1290         uint[] _gasLimits,
1291         uint[] _gasPrices,
1292         uint[] _invokeGases,
1293         uint[] _rewardAmounts
1294     ) {
1295         uint length = joule.getCount();
1296         uint amount = _count <= length ? _count : length;
1297 
1298         _addresses = new address[](amount);
1299         _timestamps = new uint[](amount);
1300         _gasLimits = new uint[](amount);
1301         _gasPrices = new uint[](amount);
1302         _invokeGases = new uint[](amount);
1303         _rewardAmounts = new uint[](amount);
1304 
1305         uint i = 0;
1306 
1307         (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getTopOnce();
1308 
1309         for (i += 1; i < amount; i ++) {
1310             (_addresses[i], _timestamps[i], _gasLimits[i], _gasPrices[i], _invokeGases[i], _rewardAmounts[i]) = joule.getNextOnce(_addresses[i - 1], _timestamps[i - 1], _gasLimits[i - 1], _gasPrices[i - 1]);
1311         }
1312     }
1313 
1314     function getVersion() external view returns (bytes8) {
1315         return joule.getVersion();
1316     }
1317 
1318     function getMinGasPrice() public view returns (uint) {
1319         return joule.minGasPriceGwei() * GWEI;
1320     }
1321 
1322     function callback(address _invoker, address _address, uint, uint _gasLimit, uint) public onlyJoule returns (bool) {
1323         require(msg.gas >= _gasLimit);
1324         uint gas = msg.gas;
1325         bool status = _address.call.gas(_gasLimit)(0x919840ad);
1326         Invoked(_invoker, _address, status, gas - msg.gas);
1327         return status;
1328     }
1329 }