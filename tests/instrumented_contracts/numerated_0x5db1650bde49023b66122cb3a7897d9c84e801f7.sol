1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 pragma solidity ^0.5.2;
72 
73 /**
74  * @title Ownable
75  * @dev The Ownable contract has an owner address, and provides basic authorization control
76  * functions, this simplifies the implementation of "user permissions".
77  */
78 contract Ownable {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor () internal {
88         _owner = msg.sender;
89         emit OwnershipTransferred(address(0), _owner);
90     }
91 
92     /**
93      * @return the address of the owner.
94      */
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOwner() {
103         require(isOwner());
104         _;
105     }
106 
107     /**
108      * @return true if `msg.sender` is the owner of the contract.
109      */
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     /**
115      * @dev Allows the current owner to relinquish control of the contract.
116      * It will not be possible to call the functions with the `onlyOwner`
117      * modifier anymore.
118      * @notice Renouncing ownership will leave the contract without an owner,
119      * thereby removing any functionality that is only available to the owner.
120      */
121     function renounceOwnership() public onlyOwner {
122         emit OwnershipTransferred(_owner, address(0));
123         _owner = address(0);
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function _transferOwnership(address newOwner) internal {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(_owner, newOwner);
141         _owner = newOwner;
142     }
143 }
144 
145 // File: set-protocol-contracts/contracts/lib/TimeLockUpgrade.sol
146 
147 /*
148     Copyright 2018 Set Labs Inc.
149 
150     Licensed under the Apache License, Version 2.0 (the "License");
151     you may not use this file except in compliance with the License.
152     You may obtain a copy of the License at
153 
154     http://www.apache.org/licenses/LICENSE-2.0
155 
156     Unless required by applicable law or agreed to in writing, software
157     distributed under the License is distributed on an "AS IS" BASIS,
158     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
159     See the License for the specific language governing permissions and
160     limitations under the License.
161 */
162 
163 pragma solidity 0.5.7;
164 
165 
166 
167 
168 /**
169  * @title TimeLockUpgrade
170  * @author Set Protocol
171  *
172  * The TimeLockUpgrade contract contains a modifier for handling minimum time period updates
173  */
174 contract TimeLockUpgrade is
175     Ownable
176 {
177     using SafeMath for uint256;
178 
179     /* ============ State Variables ============ */
180 
181     // Timelock Upgrade Period in seconds
182     uint256 public timeLockPeriod;
183 
184     // Mapping of upgradable units and initialized timelock
185     mapping(bytes32 => uint256) public timeLockedUpgrades;
186 
187     /* ============ Events ============ */
188 
189     event UpgradeRegistered(
190         bytes32 _upgradeHash,
191         uint256 _timestamp
192     );
193 
194     /* ============ Modifiers ============ */
195 
196     modifier timeLockUpgrade() {
197         // If the time lock period is 0, then allow non-timebound upgrades.
198         // This is useful for initialization of the protocol and for testing.
199         if (timeLockPeriod == 0) {
200             _;
201 
202             return;
203         }
204 
205         // The upgrade hash is defined by the hash of the transaction call data,
206         // which uniquely identifies the function as well as the passed in arguments.
207         bytes32 upgradeHash = keccak256(
208             abi.encodePacked(
209                 msg.data
210             )
211         );
212 
213         uint256 registrationTime = timeLockedUpgrades[upgradeHash];
214 
215         // If the upgrade hasn't been registered, register with the current time.
216         if (registrationTime == 0) {
217             timeLockedUpgrades[upgradeHash] = block.timestamp;
218 
219             emit UpgradeRegistered(
220                 upgradeHash,
221                 block.timestamp
222             );
223 
224             return;
225         }
226 
227         require(
228             block.timestamp >= registrationTime.add(timeLockPeriod),
229             "TimeLockUpgrade: Time lock period must have elapsed."
230         );
231 
232         // Reset the timestamp to 0
233         timeLockedUpgrades[upgradeHash] = 0;
234 
235         // Run the rest of the upgrades
236         _;
237     }
238 
239     /* ============ Function ============ */
240 
241     /**
242      * Change timeLockPeriod period. Generally called after initially settings have been set up.
243      *
244      * @param  _timeLockPeriod   Time in seconds that upgrades need to be evaluated before execution
245      */
246     function setTimeLockPeriod(
247         uint256 _timeLockPeriod
248     )
249         external
250         onlyOwner
251     {
252         // Only allow setting of the timeLockPeriod if the period is greater than the existing
253         require(
254             _timeLockPeriod > timeLockPeriod,
255             "TimeLockUpgrade: New period must be greater than existing"
256         );
257 
258         timeLockPeriod = _timeLockPeriod;
259     }
260 }
261 
262 // File: contracts/meta-oracles/lib/DataSourceLinearInterpolationLibrary.sol
263 
264 /*
265     Copyright 2019 Set Labs Inc.
266 
267     Licensed under the Apache License, Version 2.0 (the "License");
268     you may not use this file except in compliance with the License.
269     You may obtain a copy of the License at
270 
271     http://www.apache.org/licenses/LICENSE-2.0
272 
273     Unless required by applicable law or agreed to in writing, software
274     distributed under the License is distributed on an "AS IS" BASIS,
275     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
276     See the License for the specific language governing permissions and
277     limitations under the License.
278 */
279 
280 pragma solidity 0.5.7;
281 
282 
283 
284 /**
285  * @title LinearInterpolationLibrary
286  * @author Set Protocol
287  *
288  * Library used to determine linearly interpolated value for DataSource contracts when TimeSeriesFeed
289  * is updated after interpolationThreshold has passed.
290  */
291 library DataSourceLinearInterpolationLibrary {
292     using SafeMath for uint256;
293 
294     /* ============ External ============ */
295 
296     /*
297      * When the update time has surpassed the currentTime + interpolationThreshold, linearly interpolate the
298      * price between the current time and price and the last updated time and price to reduce potential error. This
299      * is done with the following series of equations, modified in this instance to deal unsigned integers:
300      *
301      * price = (currentPrice * updateInterval + previousLoggedPrice * timeFromExpectedUpdate) / timeFromLastUpdate
302      *
303      * Where updateTimeFraction represents the fraction of time passed between the last update and now spent in
304      * the previous update window. It's worth noting that because we consider updates to occur on their update
305      * timestamp we can make the assumption that the amount of time spent in the previous update window is equal
306      * to the update frequency.
307      *
308      * By way of example, assume updateInterval of 24 hours and a interpolationThreshold of 1 hour. At time 1 the
309      * update is missed by one day and when the oracle is finally called the price is 150, the price feed
310      * then interpolates this price to imply a price at t1 equal to 125. Time 2 the update is 10 minutes late but
311      * since it's within the interpolationThreshold the value isn't interpolated. At time 3 everything
312      * falls back in line.
313      *
314      * +----------------------+------+-------+-------+-------+
315      * |                      | 0    | 1     | 2     | 3     |
316      * +----------------------+------+-------+-------+-------+
317      * | Expected Update Time | 0:00 | 24:00 | 48:00 | 72:00 |
318      * +----------------------+------+-------+-------+-------+
319      * | Actual Update Time   | 0:00 | 48:00 | 48:10 | 72:00 |
320      * +----------------------+------+-------+-------+-------+
321      * | Logged Px            | 100  | 125   | 151   | 130   |
322      * +----------------------+------+-------+-------+-------+
323      * | Received Oracle Px   | 100  | 150   | 151   | 130   |
324      * +----------------------+------+-------+-------+-------+
325      * | Actual Price         | 100  | 110   | 151   | 130   |
326      * +------------------------------------------------------
327      *
328      * @param  _currentPrice                Current price returned by oracle
329      * @param  _updateInterval              Update interval of TimeSeriesFeed
330      * @param  _timeFromExpectedUpdate      Time passed from expected update
331      * @param  _previousLoggedDataPoint     Previously logged price from TimeSeriesFeed
332      * @returns                             Interpolated price value
333      */
334     function interpolateDelayedPriceUpdate(
335         uint256 _currentPrice,
336         uint256 _updateInterval,
337         uint256 _timeFromExpectedUpdate,
338         uint256 _previousLoggedDataPoint
339     )
340         internal
341         pure
342         returns (uint256)
343     {
344         // Calculate how much time has passed from timestamp corresponding to last update
345         uint256 timeFromLastUpdate = _timeFromExpectedUpdate.add(_updateInterval);
346 
347         // Linearly interpolate between last updated price (with corresponding timestamp) and current price (with
348         // current timestamp) to imply price at the timestamp we are updating
349         return _currentPrice.mul(_updateInterval)
350             .add(_previousLoggedDataPoint.mul(_timeFromExpectedUpdate))
351             .div(timeFromLastUpdate);
352     }
353 }
354 
355 // File: contracts/meta-oracles/lib/EMALibrary.sol
356 
357 /*
358     Copyright 2019 Set Labs Inc.
359 
360     Licensed under the Apache License, Version 2.0 (the "License");
361     you may not use this file except in compliance with the License.
362     You may obtain a copy of the License at
363 
364     http://www.apache.org/licenses/LICENSE-2.0
365 
366     Unless required by applicable law or agreed to in writing, software
367     distributed under the License is distributed on an "AS IS" BASIS,
368     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
369     See the License for the specific language governing permissions and
370     limitations under the License.
371 */
372 
373 pragma solidity 0.5.7;
374 
375 
376 
377 /**
378  * @title EMALibrary
379  * @author Set Protocol
380  *
381  * Library for calculate the Exponential Moving Average
382  *
383  */
384 library EMALibrary{
385 
386     using SafeMath for uint256;
387 
388     /*
389      * Calculates the new exponential moving average value using the previous value,
390      * EMA time period, and the current asset price.
391      *
392      * Weighted Multiplier = 2 / (timePeriod + 1)
393      *
394      * EMA = Price(Today) x Weighted Multiplier +
395      *       EMA(Yesterday) -
396      *       EMA(Yesterday) x Weighted Multiplier
397      *
398      * Our implementation is simplified to the following for efficiency:
399      *
400      * EMA = (Price(Today) * 2 + EMA(Yesterday) * (timePeriod - 1)) / (timePeriod + 1)
401      *
402      *
403      * @param  _previousEMAValue         The previous Exponential Moving average value
404      * @param  _timePeriod               The number of days the calculate the EMA with
405      * @param  _currentAssetPrice        The current asset price
406      * @returns                          The exponential moving average
407      */
408     function calculate(
409         uint256 _previousEMAValue,
410         uint256 _timePeriod,
411         uint256 _currentAssetPrice
412     )
413         internal
414         pure
415         returns (uint256)
416     {
417         uint256 a = _currentAssetPrice.mul(2);
418         uint256 b = _previousEMAValue.mul(_timePeriod.sub(1));
419         uint256 c = _timePeriod.add(1);
420 
421         return a.add(b).div(c);
422     }
423 }
424 
425 // File: contracts/meta-oracles/interfaces/IOracle.sol
426 
427 /*
428     Copyright 2019 Set Labs Inc.
429 
430     Licensed under the Apache License, Version 2.0 (the "License");
431     you may not use this file except in compliance with the License.
432     You may obtain a copy of the License at
433 
434     http://www.apache.org/licenses/LICENSE-2.0
435 
436     Unless required by applicable law or agreed to in writing, software
437     distributed under the License is distributed on an "AS IS" BASIS,
438     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
439     See the License for the specific language governing permissions and
440     limitations under the License.
441 */
442 
443 pragma solidity 0.5.7;
444 
445 
446 /**
447  * @title IOracle
448  * @author Set Protocol
449  *
450  * Interface for operating with any external Oracle that returns uint256 or
451  * an adapting contract that converts oracle output to uint256
452  */
453 interface IOracle {
454 
455     /**
456      * Returns the queried data from an oracle returning uint256
457      *
458      * @return  Current price of asset represented in uint256
459      */
460     function read()
461         external
462         view
463         returns (uint256);
464 }
465 
466 // File: contracts/meta-oracles/lib/LinkedListLibraryV3.sol
467 
468 /*
469     Copyright 2019 Set Labs Inc.
470 
471     Licensed under the Apache License, Version 2.0 (the "License");
472     you may not use this file except in compliance with the License.
473     You may obtain a copy of the License at
474 
475     http://www.apache.org/licenses/LICENSE-2.0
476 
477     Unless required by applicable law or agreed to in writing, software
478     distributed under the License is distributed on an "AS IS" BASIS,
479     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
480     See the License for the specific language governing permissions and
481     limitations under the License.
482 */
483 
484 pragma solidity 0.5.7;
485 
486 
487 
488 /**
489  * @title LinkedListLibraryV3
490  * @author Set Protocol
491  *
492  * Library for creating and altering uni-directional circularly linked lists, optimized for sequential updating
493  * Version two of this contract is a library vs. a contract.
494  *
495  *
496  * CHANGELOG
497  * - LinkedListLibraryV3's readList function does not load LinkedList into memory
498  * - readListMemory is removed
499  */
500 library LinkedListLibraryV3 {
501 
502     using SafeMath for uint256;
503 
504     /* ============ Structs ============ */
505 
506     struct LinkedList{
507         uint256 dataSizeLimit;
508         uint256 lastUpdatedIndex;
509         uint256[] dataArray;
510     }
511 
512     /*
513      * Initialize LinkedList by setting limit on amount of nodes and initial value of node 0
514      *
515      * @param  _self                        LinkedList to operate on
516      * @param  _dataSizeLimit               Max amount of nodes allowed in LinkedList
517      * @param  _initialValue                Initial value of node 0 in LinkedList
518      */
519     function initialize(
520         LinkedList storage _self,
521         uint256 _dataSizeLimit,
522         uint256 _initialValue
523     )
524         internal
525     {
526         // Check dataArray is empty
527         require(
528             _self.dataArray.length == 0,
529             "LinkedListLibrary.initialize: Initialized LinkedList must be empty"
530         );
531 
532         // Check that LinkedList is intialized to be greater than 0 size
533         require(
534             _dataSizeLimit > 0,
535             "LinkedListLibrary.initialize: dataSizeLimit must be greater than 0."
536         );
537 
538         // Initialize Linked list by defining upper limit of data points in the list and setting
539         // initial value
540         _self.dataSizeLimit = _dataSizeLimit;
541         _self.dataArray.push(_initialValue);
542         _self.lastUpdatedIndex = 0;
543     }
544 
545     /*
546      * Add new value to list by either creating new node if node limit not reached or updating
547      * existing node value
548      *
549      * @param  _self                        LinkedList to operate on
550      * @param  _addedValue                  Value to add to list
551      */
552     function editList(
553         LinkedList storage _self,
554         uint256 _addedValue
555     )
556         internal
557     {
558         // Add node if data hasn't reached size limit, otherwise update next node
559         _self.dataArray.length < _self.dataSizeLimit ? addNode(_self, _addedValue)
560             : updateNode(_self, _addedValue);
561     }
562 
563     /*
564      * Add new value to list by either creating new node. Node limit must not be reached.
565      *
566      * @param  _self                        LinkedList to operate on
567      * @param  _addedValue                  Value to add to list
568      */
569     function addNode(
570         LinkedList storage _self,
571         uint256 _addedValue
572     )
573         internal
574     {
575         uint256 newNodeIndex = _self.lastUpdatedIndex.add(1);
576 
577         require(
578             newNodeIndex == _self.dataArray.length,
579             "LinkedListLibrary: Node must be added at next expected index in list"
580         );
581 
582         require(
583             newNodeIndex < _self.dataSizeLimit,
584             "LinkedListLibrary: Attempting to add node that exceeds data size limit"
585         );
586 
587         // Add node value
588         _self.dataArray.push(_addedValue);
589 
590         // Update lastUpdatedIndex value
591         _self.lastUpdatedIndex = newNodeIndex;
592     }
593 
594     /*
595      * Add new value to list by updating existing node. Updates only happen if node limit has been
596      * reached.
597      *
598      * @param  _self                        LinkedList to operate on
599      * @param  _addedValue                  Value to add to list
600      */
601     function updateNode(
602         LinkedList storage _self,
603         uint256 _addedValue
604     )
605         internal
606     {
607         // Determine the next node in list to be updated
608         uint256 updateNodeIndex = _self.lastUpdatedIndex.add(1) % _self.dataSizeLimit;
609 
610         // Require that updated node has been previously added
611         require(
612             updateNodeIndex < _self.dataArray.length,
613             "LinkedListLibrary: Attempting to update non-existent node"
614         );
615 
616         // Update node value and last updated index
617         _self.dataArray[updateNodeIndex] = _addedValue;
618         _self.lastUpdatedIndex = updateNodeIndex;
619     }
620 
621     /*
622      * Read list from the lastUpdatedIndex back the passed amount of data points.
623      *
624      * @param  _self                        LinkedList to operate on
625      * @param  _dataPoints                  Number of data points to return
626      * @return                              Array of length dataPoints containing most recent values
627      */
628     function readList(
629         LinkedList storage _self,
630         uint256 _dataPoints
631     )
632         internal
633         view
634         returns (uint256[] memory)
635     {
636         // Make sure query isn't for more data than collected
637         require(
638             _dataPoints <= _self.dataArray.length,
639             "LinkedListLibrary: Querying more data than available"
640         );
641 
642         // Instantiate output array in memory
643         uint256[] memory outputArray = new uint256[](_dataPoints);
644 
645         // Find head of list
646         uint256 linkedListIndex = _self.lastUpdatedIndex;
647         for (uint256 i = 0; i < _dataPoints; i++) {
648             // Get value at index in linkedList
649             outputArray[i] = _self.dataArray[linkedListIndex];
650 
651             // Find next linked index
652             linkedListIndex = linkedListIndex == 0 ? _self.dataSizeLimit.sub(1) : linkedListIndex.sub(1);
653         }
654 
655         return outputArray;
656     }
657 
658     /*
659      * Get latest value from LinkedList.
660      *
661      * @param  _self                        LinkedList to operate on
662      * @return                              Latest logged value in LinkedList
663      */
664     function getLatestValue(
665         LinkedList storage _self
666     )
667         internal
668         view
669         returns (uint256)
670     {
671         return _self.dataArray[_self.lastUpdatedIndex];
672     }
673 }
674 
675 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
676 
677 pragma solidity ^0.5.2;
678 
679 /**
680  * @title Helps contracts guard against reentrancy attacks.
681  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
682  * @dev If you mark a function `nonReentrant`, you should also
683  * mark it `external`.
684  */
685 contract ReentrancyGuard {
686     /// @dev counter to allow mutex lock with only one SSTORE operation
687     uint256 private _guardCounter;
688 
689     constructor () internal {
690         // The counter starts at one to prevent changing it from zero to a non-zero
691         // value, which is a more expensive operation.
692         _guardCounter = 1;
693     }
694 
695     /**
696      * @dev Prevents a contract from calling itself, directly or indirectly.
697      * Calling a `nonReentrant` function from another `nonReentrant`
698      * function is not supported. It is possible to prevent this from happening
699      * by making the `nonReentrant` function external, and make it call a
700      * `private` function that does the actual work.
701      */
702     modifier nonReentrant() {
703         _guardCounter += 1;
704         uint256 localCounter = _guardCounter;
705         _;
706         require(localCounter == _guardCounter);
707     }
708 }
709 
710 // File: contracts/meta-oracles/lib/TimeSeriesFeedV2.sol
711 
712 /*
713     Copyright 2019 Set Labs Inc.
714 
715     Licensed under the Apache License, Version 2.0 (the "License");
716     you may not use this file except in compliance with the License.
717     You may obtain a copy of the License at
718 
719     http://www.apache.org/licenses/LICENSE-2.0
720 
721     Unless required by applicable law or agreed to in writing, software
722     distributed under the License is distributed on an "AS IS" BASIS,
723     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
724     See the License for the specific language governing permissions and
725     limitations under the License.
726 */
727 
728 pragma solidity 0.5.7;
729 
730 
731 
732 
733 
734 /**
735  * @title TimeSeriesFeedV2
736  * @author Set Protocol
737  *
738  * Contract used to track time-series data. This is meant to be inherited, as the calculateNextValue
739  * function is unimplemented. New data is appended by calling the poke function, which retrieves the
740  * latest value using the calculateNextValue function.
741  *
742  * CHANGELOG
743  * - Built to be inherited by contract that implements new calculateNextValue function
744  * - Uses LinkedListLibraryV3
745  * - nextEarliestUpdate is passed into constructor
746  */
747 contract TimeSeriesFeedV2 is
748     ReentrancyGuard
749 {
750     using SafeMath for uint256;
751     using LinkedListLibraryV3 for LinkedListLibraryV3.LinkedList;
752 
753     /* ============ State Variables ============ */
754     uint256 public updateInterval;
755     uint256 public maxDataPoints;
756     // Unix Timestamp in seconds of next earliest update time
757     uint256 public nextEarliestUpdate;
758 
759     LinkedListLibraryV3.LinkedList internal timeSeriesData;
760 
761     /* ============ Constructor ============ */
762 
763     /*
764      * Stores time-series values in a LinkedList and updated using data from a specific data source.
765      * Updates must be triggered off chain to be stored in this smart contract.
766      *
767      * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
768                                           off deployment timestamp. A certain data point can't be logged before
769                                           it's expected timestamp but can be logged after
770      * @param  _nextEarliestUpdate        Time the first on-chain price update becomes available
771      * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold
772      * @param  _seededValues              Array of previous timeseries values to seed initial values in list.
773      *                                    The last value should contain the most current piece of data
774      */
775     constructor(
776         uint256 _updateInterval,
777         uint256 _nextEarliestUpdate,
778         uint256 _maxDataPoints,
779         uint256[] memory _seededValues
780     )
781         public
782     {
783 
784         // Check that nextEarliestUpdate is greater than current block timestamp
785         require(
786             _nextEarliestUpdate > block.timestamp,
787             "TimeSeriesFeed.constructor: nextEarliestUpdate must be greater than current timestamp."
788         );
789 
790         // Check that at least one seeded value is passed in
791         require(
792             _seededValues.length > 0,
793             "TimeSeriesFeed.constructor: Must include at least one seeded value."
794         );
795 
796         // Check that maxDataPoints greater than 0
797         require(
798             _maxDataPoints > 0,
799             "TimeSeriesFeed.constructor: Max data points must be greater than 0."
800         );
801 
802         // Check that updateInterval greater than 0
803         require(
804             _updateInterval > 0,
805             "TimeSeriesFeed.constructor: Update interval must be greater than 0."
806         );
807 
808         // Set updateInterval and maxDataPoints
809         updateInterval = _updateInterval;
810         maxDataPoints = _maxDataPoints;
811 
812         // Define upper data size limit for linked list and input initial value
813         timeSeriesData.initialize(_maxDataPoints, _seededValues[0]);
814 
815         // Cycle through input values array (skipping first value used to initialize LinkedList)
816         // and add to timeSeriesData
817         for (uint256 i = 1; i < _seededValues.length; i++) {
818             timeSeriesData.editList(_seededValues[i]);
819         }
820 
821         // Set nextEarliestUpdate
822         nextEarliestUpdate = _nextEarliestUpdate;
823     }
824 
825     /* ============ External ============ */
826 
827     /*
828      * Updates linked list with newest data point by calling the implemented calculateNextValue function
829      */
830     function poke()
831         external
832         nonReentrant
833     {
834         // Make sure block timestamp exceeds nextEarliestUpdate
835         require(
836             block.timestamp >= nextEarliestUpdate,
837             "TimeSeriesFeed.poke: Not enough time elapsed since last update"
838         );
839 
840         // Get the most current data point
841         uint256 newValue = calculateNextValue();
842 
843         // Update the nextEarliestUpdate to previous nextEarliestUpdate plus updateInterval
844         nextEarliestUpdate = nextEarliestUpdate.add(updateInterval);
845 
846         // Update linkedList with new price
847         timeSeriesData.editList(newValue);
848     }
849 
850     /*
851      * Query linked list for specified days of data. Will revert if number of days
852      * passed exceeds amount of days collected. Will revert if not enough days of
853      * data logged.
854      *
855      * @param  _numDataPoints  Number of datapoints to query
856      * @returns                Array of datapoints of length _numDataPoints from most recent to oldest
857      */
858     function read(
859         uint256 _numDataPoints
860     )
861         external
862         view
863         returns (uint256[] memory)
864     {
865         return timeSeriesData.readList(_numDataPoints);
866     }
867 
868 
869     /* ============ Internal ============ */
870 
871     function calculateNextValue()
872         internal
873         returns (uint256);
874 
875 }
876 
877 // File: contracts/meta-oracles/feeds/LinearizedEMATimeSeriesFeed.sol
878 
879 /*
880     Copyright 2019 Set Labs Inc.
881 
882     Licensed under the Apache License, Version 2.0 (the "License");
883     you may not use this file except in compliance with the License.
884     You may obtain a copy of the License at
885 
886     http://www.apache.org/licenses/LICENSE-2.0
887 
888     Unless required by applicable law or agreed to in writing, software
889     distributed under the License is distributed on an "AS IS" BASIS,
890     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
891     See the License for the specific language governing permissions and
892     limitations under the License.
893 */
894 
895 pragma solidity 0.5.7;
896 pragma experimental "ABIEncoderV2";
897 
898 
899 
900 
901 
902 
903 
904 
905 
906 /**
907  * @title LinearizedEMATimeSeriesFeed
908  * @author Set Protocol
909  *
910  * This TimeSeriesFeed calculates the current EMA price and stores it using the
911  * inherited TimeSeriesFeedV2 contract. On calculation, if the interpolationThreshold
912  * is reached, then it returns a linearly interpolated value.
913  */
914 contract LinearizedEMATimeSeriesFeed is
915     TimeSeriesFeedV2,
916     TimeLockUpgrade
917 {
918     using SafeMath for uint256;
919     using LinkedListLibraryV3 for LinkedListLibraryV3.LinkedList;
920 
921     /* ============ State Variables ============ */
922     // Number of EMA Days
923     uint256 public emaTimePeriod;
924 
925     // Amount of time after which read interpolates price result, in seconds
926     uint256 public interpolationThreshold;
927     string public dataDescription;
928     IOracle public oracleInstance;
929 
930     /* ============ Events ============ */
931 
932     event LogOracleUpdated(
933         address indexed newOracleAddress
934     );
935 
936     /* ============ Constructor ============ */
937 
938     /*
939      * Set interpolationThreshold, data description, emaTimePeriod, and instantiate oracle
940      *
941      * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
942                                           off deployment timestamp. A certain data point can't be logged before
943                                           it's expected timestamp but can be logged after (for TimeSeriesFeed)
944      * @param  _nextEarliestUpdate        Time the first on-chain price update becomes available (for TimeSeriesFeed)
945      * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold (for TimeSeriesFeed)
946      * @param  _seededValues              Array of previous timeseries values to seed initial values in list.
947      *                                    The last value should contain the most current piece of data (for TimeSeriesFeed)
948      * @param  _emaTimePeriod             The time period the exponential moving average is based off of
949      * @param  _interpolationThreshold    The minimum time in seconds where interpolation is enabled
950      * @param  _oracleAddress             The address to read current data from
951      * @param  _dataDescription           Description of contract for Etherscan / other applications
952      */
953     constructor(
954         uint256 _updateInterval,
955         uint256 _nextEarliestUpdate,
956         uint256 _maxDataPoints,
957         uint256[] memory _seededValues,
958         uint256 _emaTimePeriod,
959         uint256 _interpolationThreshold,
960         IOracle _oracleAddress,
961         string memory _dataDescription
962     )
963         public
964         TimeSeriesFeedV2(
965             _updateInterval,
966             _nextEarliestUpdate,
967             _maxDataPoints,
968             _seededValues
969         )
970     {
971         require(
972             _emaTimePeriod > 0,
973             "LinearizedEMADataSource.constructor: Time Period must be greater than 0."
974         );
975 
976         interpolationThreshold = _interpolationThreshold;
977         emaTimePeriod = _emaTimePeriod;
978         oracleInstance = _oracleAddress;
979         dataDescription = _dataDescription;
980     }
981 
982     /* ============ External ============ */
983 
984     /*
985      * Change oracle in case current one fails or is deprecated. Only contract
986      * owner is allowed to change.
987      *
988      * @param  _newOracleAddress       Address of new oracle to pull data from
989      */
990     function changeOracle(
991         IOracle _newOracleAddress
992     )
993         external
994         onlyOwner
995         timeLockUpgrade // Must be placed after onlyOwner
996     {
997         // Check to make sure new oracle address is passed
998         require(
999             address(_newOracleAddress) != address(oracleInstance),
1000             "LinearizedEMADataSource.changeOracle: Must give new oracle address."
1001         );
1002 
1003         oracleInstance = _newOracleAddress;
1004 
1005         emit LogOracleUpdated(address(_newOracleAddress));
1006     }
1007 
1008     /* ============ Internal ============ */
1009 
1010     /*
1011      * Returns the data from the oracle contract. If the current timestamp has surpassed
1012      * the interpolationThreshold, then the current price is retrieved and interpolated based on
1013      * the previous value and the time that has elapsed since the intended update value.
1014      *
1015      * Returns with newest data point by querying oracle. Is eligible to be
1016      * called after nextAvailableUpdate timestamp has passed. Because the nextAvailableUpdate occurs
1017      * on a predetermined cadence based on the time of deployment, delays in calling poke do not propogate
1018      * throughout the whole dataset and the drift caused by previous poke transactions not being mined
1019      * exactly on nextAvailableUpdate do not compound as they would if it was required that poke is called
1020      * an updateInterval amount of time after the last poke.
1021      *
1022      * @param  _timeSeriesState         Struct of TimeSeriesFeed state
1023      * @returns                         Returns the datapoint from the oracle contract
1024      */
1025     function calculateNextValue()
1026         internal
1027         returns (uint256)
1028     {
1029         // Get current oracle value
1030         uint256 oracleValue = oracleInstance.read();
1031 
1032         // Get the previous EMA Value
1033         uint256 previousEMAValue = timeSeriesData.getLatestValue();
1034 
1035         // Calculate the current EMA
1036         uint256 currentEMAValue = EMALibrary.calculate(
1037             previousEMAValue,
1038             emaTimePeriod,
1039             oracleValue
1040         );
1041 
1042         // Calculate how much time has passed from last expected update
1043         uint256 timeFromExpectedUpdate = block.timestamp.sub(nextEarliestUpdate);
1044 
1045         // If block timeFromExpectedUpdate is greater than interpolationThreshold we linearize
1046         // the current price to try to reduce error
1047         if (timeFromExpectedUpdate < interpolationThreshold) {
1048             return currentEMAValue;
1049         } else {
1050             return DataSourceLinearInterpolationLibrary.interpolateDelayedPriceUpdate(
1051                 currentEMAValue,
1052                 updateInterval,
1053                 timeFromExpectedUpdate,
1054                 previousEMAValue
1055             );
1056         }
1057     }
1058 }