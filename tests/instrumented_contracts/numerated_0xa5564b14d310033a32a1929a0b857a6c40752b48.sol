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
145 // File: set-protocol-contracts/contracts/lib/TimeLockUpgradeV2.sol
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
169  * @title TimeLockUpgradeV2
170  * @author Set Protocol
171  *
172  * The TimeLockUpgradeV2 contract contains a modifier for handling minimum time period updates
173  *
174  * CHANGELOG:
175  * - Requires that the caller is the owner
176  * - New function to allow deletion of existing timelocks
177  * - Added upgradeData to UpgradeRegistered event
178  */
179 contract TimeLockUpgradeV2 is
180     Ownable
181 {
182     using SafeMath for uint256;
183 
184     /* ============ State Variables ============ */
185 
186     // Timelock Upgrade Period in seconds
187     uint256 public timeLockPeriod;
188 
189     // Mapping of maps hash of registered upgrade to its registration timestam
190     mapping(bytes32 => uint256) public timeLockedUpgrades;
191 
192     /* ============ Events ============ */
193 
194     event UpgradeRegistered(
195         bytes32 indexed _upgradeHash,
196         uint256 _timestamp,
197         bytes _upgradeData
198     );
199 
200     event RemoveRegisteredUpgrade(
201         bytes32 indexed _upgradeHash
202     );
203 
204     /* ============ Modifiers ============ */
205 
206     modifier timeLockUpgrade() {
207         require(
208             isOwner(),
209             "TimeLockUpgradeV2: The caller must be the owner"
210         );
211 
212         // If the time lock period is 0, then allow non-timebound upgrades.
213         // This is useful for initialization of the protocol and for testing.
214         if (timeLockPeriod > 0) {
215             // The upgrade hash is defined by the hash of the transaction call data,
216             // which uniquely identifies the function as well as the passed in arguments.
217             bytes32 upgradeHash = keccak256(
218                 abi.encodePacked(
219                     msg.data
220                 )
221             );
222 
223             uint256 registrationTime = timeLockedUpgrades[upgradeHash];
224 
225             // If the upgrade hasn't been registered, register with the current time.
226             if (registrationTime == 0) {
227                 timeLockedUpgrades[upgradeHash] = block.timestamp;
228 
229                 emit UpgradeRegistered(
230                     upgradeHash,
231                     block.timestamp,
232                     msg.data
233                 );
234 
235                 return;
236             }
237 
238             require(
239                 block.timestamp >= registrationTime.add(timeLockPeriod),
240                 "TimeLockUpgradeV2: Time lock period must have elapsed."
241             );
242 
243             // Reset the timestamp to 0
244             timeLockedUpgrades[upgradeHash] = 0;
245 
246         }
247 
248         // Run the rest of the upgrades
249         _;
250     }
251 
252     /* ============ Function ============ */
253 
254     /**
255      * Removes an existing upgrade.
256      *
257      * @param  _upgradeHash    Keccack256 hash that uniquely identifies function called and arguments
258      */
259     function removeRegisteredUpgrade(
260         bytes32 _upgradeHash
261     )
262         external
263         onlyOwner
264     {
265         require(
266             timeLockedUpgrades[_upgradeHash] != 0,
267             "TimeLockUpgradeV2.removeRegisteredUpgrade: Upgrade hash must be registered"
268         );
269 
270         // Reset the timestamp to 0
271         timeLockedUpgrades[_upgradeHash] = 0;
272 
273         emit RemoveRegisteredUpgrade(
274             _upgradeHash
275         );
276     }
277 
278     /**
279      * Change timeLockPeriod period. Generally called after initially settings have been set up.
280      *
281      * @param  _timeLockPeriod   Time in seconds that upgrades need to be evaluated before execution
282      */
283     function setTimeLockPeriod(
284         uint256 _timeLockPeriod
285     )
286         external
287         onlyOwner
288     {
289         // Only allow setting of the timeLockPeriod if the period is greater than the existing
290         require(
291             _timeLockPeriod > timeLockPeriod,
292             "TimeLockUpgradeV2: New period must be greater than existing"
293         );
294 
295         timeLockPeriod = _timeLockPeriod;
296     }
297 }
298 
299 // File: contracts/meta-oracles/lib/DataSourceLinearInterpolationLibrary.sol
300 
301 /*
302     Copyright 2019 Set Labs Inc.
303 
304     Licensed under the Apache License, Version 2.0 (the "License");
305     you may not use this file except in compliance with the License.
306     You may obtain a copy of the License at
307 
308     http://www.apache.org/licenses/LICENSE-2.0
309 
310     Unless required by applicable law or agreed to in writing, software
311     distributed under the License is distributed on an "AS IS" BASIS,
312     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
313     See the License for the specific language governing permissions and
314     limitations under the License.
315 */
316 
317 pragma solidity 0.5.7;
318 
319 
320 
321 /**
322  * @title LinearInterpolationLibrary
323  * @author Set Protocol
324  *
325  * Library used to determine linearly interpolated value for DataSource contracts when TimeSeriesFeed
326  * is updated after interpolationThreshold has passed.
327  */
328 library DataSourceLinearInterpolationLibrary {
329     using SafeMath for uint256;
330 
331     /* ============ External ============ */
332 
333     /*
334      * When the update time has surpassed the currentTime + interpolationThreshold, linearly interpolate the
335      * price between the current time and price and the last updated time and price to reduce potential error. This
336      * is done with the following series of equations, modified in this instance to deal unsigned integers:
337      *
338      * price = (currentPrice * updateInterval + previousLoggedPrice * timeFromExpectedUpdate) / timeFromLastUpdate
339      *
340      * Where updateTimeFraction represents the fraction of time passed between the last update and now spent in
341      * the previous update window. It's worth noting that because we consider updates to occur on their update
342      * timestamp we can make the assumption that the amount of time spent in the previous update window is equal
343      * to the update frequency.
344      *
345      * By way of example, assume updateInterval of 24 hours and a interpolationThreshold of 1 hour. At time 1 the
346      * update is missed by one day and when the oracle is finally called the price is 150, the price feed
347      * then interpolates this price to imply a price at t1 equal to 125. Time 2 the update is 10 minutes late but
348      * since it's within the interpolationThreshold the value isn't interpolated. At time 3 everything
349      * falls back in line.
350      *
351      * +----------------------+------+-------+-------+-------+
352      * |                      | 0    | 1     | 2     | 3     |
353      * +----------------------+------+-------+-------+-------+
354      * | Expected Update Time | 0:00 | 24:00 | 48:00 | 72:00 |
355      * +----------------------+------+-------+-------+-------+
356      * | Actual Update Time   | 0:00 | 48:00 | 48:10 | 72:00 |
357      * +----------------------+------+-------+-------+-------+
358      * | Logged Px            | 100  | 125   | 151   | 130   |
359      * +----------------------+------+-------+-------+-------+
360      * | Received Oracle Px   | 100  | 150   | 151   | 130   |
361      * +----------------------+------+-------+-------+-------+
362      * | Actual Price         | 100  | 110   | 151   | 130   |
363      * +------------------------------------------------------
364      *
365      * @param  _currentPrice                Current price returned by oracle
366      * @param  _updateInterval              Update interval of TimeSeriesFeed
367      * @param  _timeFromExpectedUpdate      Time passed from expected update
368      * @param  _previousLoggedDataPoint     Previously logged price from TimeSeriesFeed
369      * @returns                             Interpolated price value
370      */
371     function interpolateDelayedPriceUpdate(
372         uint256 _currentPrice,
373         uint256 _updateInterval,
374         uint256 _timeFromExpectedUpdate,
375         uint256 _previousLoggedDataPoint
376     )
377         internal
378         pure
379         returns (uint256)
380     {
381         // Calculate how much time has passed from timestamp corresponding to last update
382         uint256 timeFromLastUpdate = _timeFromExpectedUpdate.add(_updateInterval);
383 
384         // Linearly interpolate between last updated price (with corresponding timestamp) and current price (with
385         // current timestamp) to imply price at the timestamp we are updating
386         return _currentPrice.mul(_updateInterval)
387             .add(_previousLoggedDataPoint.mul(_timeFromExpectedUpdate))
388             .div(timeFromLastUpdate);
389     }
390 }
391 
392 // File: contracts/meta-oracles/interfaces/IOracle.sol
393 
394 /*
395     Copyright 2019 Set Labs Inc.
396 
397     Licensed under the Apache License, Version 2.0 (the "License");
398     you may not use this file except in compliance with the License.
399     You may obtain a copy of the License at
400 
401     http://www.apache.org/licenses/LICENSE-2.0
402 
403     Unless required by applicable law or agreed to in writing, software
404     distributed under the License is distributed on an "AS IS" BASIS,
405     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
406     See the License for the specific language governing permissions and
407     limitations under the License.
408 */
409 
410 pragma solidity 0.5.7;
411 
412 
413 /**
414  * @title IOracle
415  * @author Set Protocol
416  *
417  * Interface for operating with any external Oracle that returns uint256 or
418  * an adapting contract that converts oracle output to uint256
419  */
420 interface IOracle {
421 
422     /**
423      * Returns the queried data from an oracle returning uint256
424      *
425      * @return  Current price of asset represented in uint256
426      */
427     function read()
428         external
429         view
430         returns (uint256);
431 }
432 
433 // File: contracts/meta-oracles/lib/LinkedListLibraryV3.sol
434 
435 /*
436     Copyright 2019 Set Labs Inc.
437 
438     Licensed under the Apache License, Version 2.0 (the "License");
439     you may not use this file except in compliance with the License.
440     You may obtain a copy of the License at
441 
442     http://www.apache.org/licenses/LICENSE-2.0
443 
444     Unless required by applicable law or agreed to in writing, software
445     distributed under the License is distributed on an "AS IS" BASIS,
446     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
447     See the License for the specific language governing permissions and
448     limitations under the License.
449 */
450 
451 pragma solidity 0.5.7;
452 pragma experimental "ABIEncoderV2";
453 
454 
455 
456 /**
457  * @title LinkedListLibraryV3
458  * @author Set Protocol
459  *
460  * Library for creating and altering uni-directional circularly linked lists, optimized for sequential updating
461  * Version two of this contract is a library vs. a contract.
462  *
463  *
464  * CHANGELOG
465  * - LinkedListLibraryV3's readList function does not load LinkedList into memory
466  * - readListMemory is removed
467  */
468 library LinkedListLibraryV3 {
469 
470     using SafeMath for uint256;
471 
472     /* ============ Structs ============ */
473 
474     struct LinkedList{
475         uint256 dataSizeLimit;
476         uint256 lastUpdatedIndex;
477         uint256[] dataArray;
478     }
479 
480     /*
481      * Initialize LinkedList by setting limit on amount of nodes and initial value of node 0
482      *
483      * @param  _self                        LinkedList to operate on
484      * @param  _dataSizeLimit               Max amount of nodes allowed in LinkedList
485      * @param  _initialValue                Initial value of node 0 in LinkedList
486      */
487     function initialize(
488         LinkedList storage _self,
489         uint256 _dataSizeLimit,
490         uint256 _initialValue
491     )
492         internal
493     {
494         // Check dataArray is empty
495         require(
496             _self.dataArray.length == 0,
497             "LinkedListLibrary.initialize: Initialized LinkedList must be empty"
498         );
499 
500         // Check that LinkedList is intialized to be greater than 0 size
501         require(
502             _dataSizeLimit > 0,
503             "LinkedListLibrary.initialize: dataSizeLimit must be greater than 0."
504         );
505 
506         // Initialize Linked list by defining upper limit of data points in the list and setting
507         // initial value
508         _self.dataSizeLimit = _dataSizeLimit;
509         _self.dataArray.push(_initialValue);
510         _self.lastUpdatedIndex = 0;
511     }
512 
513     /*
514      * Add new value to list by either creating new node if node limit not reached or updating
515      * existing node value
516      *
517      * @param  _self                        LinkedList to operate on
518      * @param  _addedValue                  Value to add to list
519      */
520     function editList(
521         LinkedList storage _self,
522         uint256 _addedValue
523     )
524         internal
525     {
526         // Add node if data hasn't reached size limit, otherwise update next node
527         _self.dataArray.length < _self.dataSizeLimit ? addNode(_self, _addedValue)
528             : updateNode(_self, _addedValue);
529     }
530 
531     /*
532      * Add new value to list by either creating new node. Node limit must not be reached.
533      *
534      * @param  _self                        LinkedList to operate on
535      * @param  _addedValue                  Value to add to list
536      */
537     function addNode(
538         LinkedList storage _self,
539         uint256 _addedValue
540     )
541         internal
542     {
543         uint256 newNodeIndex = _self.lastUpdatedIndex.add(1);
544 
545         require(
546             newNodeIndex == _self.dataArray.length,
547             "LinkedListLibrary: Node must be added at next expected index in list"
548         );
549 
550         require(
551             newNodeIndex < _self.dataSizeLimit,
552             "LinkedListLibrary: Attempting to add node that exceeds data size limit"
553         );
554 
555         // Add node value
556         _self.dataArray.push(_addedValue);
557 
558         // Update lastUpdatedIndex value
559         _self.lastUpdatedIndex = newNodeIndex;
560     }
561 
562     /*
563      * Add new value to list by updating existing node. Updates only happen if node limit has been
564      * reached.
565      *
566      * @param  _self                        LinkedList to operate on
567      * @param  _addedValue                  Value to add to list
568      */
569     function updateNode(
570         LinkedList storage _self,
571         uint256 _addedValue
572     )
573         internal
574     {
575         // Determine the next node in list to be updated
576         uint256 updateNodeIndex = _self.lastUpdatedIndex.add(1) % _self.dataSizeLimit;
577 
578         // Require that updated node has been previously added
579         require(
580             updateNodeIndex < _self.dataArray.length,
581             "LinkedListLibrary: Attempting to update non-existent node"
582         );
583 
584         // Update node value and last updated index
585         _self.dataArray[updateNodeIndex] = _addedValue;
586         _self.lastUpdatedIndex = updateNodeIndex;
587     }
588 
589     /*
590      * Read list from the lastUpdatedIndex back the passed amount of data points.
591      *
592      * @param  _self                        LinkedList to operate on
593      * @param  _dataPoints                  Number of data points to return
594      * @return                              Array of length dataPoints containing most recent values
595      */
596     function readList(
597         LinkedList storage _self,
598         uint256 _dataPoints
599     )
600         internal
601         view
602         returns (uint256[] memory)
603     {
604         // Make sure query isn't for more data than collected
605         require(
606             _dataPoints <= _self.dataArray.length,
607             "LinkedListLibrary: Querying more data than available"
608         );
609 
610         // Instantiate output array in memory
611         uint256[] memory outputArray = new uint256[](_dataPoints);
612 
613         // Find head of list
614         uint256 linkedListIndex = _self.lastUpdatedIndex;
615         for (uint256 i = 0; i < _dataPoints; i++) {
616             // Get value at index in linkedList
617             outputArray[i] = _self.dataArray[linkedListIndex];
618 
619             // Find next linked index
620             linkedListIndex = linkedListIndex == 0 ? _self.dataSizeLimit.sub(1) : linkedListIndex.sub(1);
621         }
622 
623         return outputArray;
624     }
625 
626     /*
627      * Get latest value from LinkedList.
628      *
629      * @param  _self                        LinkedList to operate on
630      * @return                              Latest logged value in LinkedList
631      */
632     function getLatestValue(
633         LinkedList storage _self
634     )
635         internal
636         view
637         returns (uint256)
638     {
639         return _self.dataArray[_self.lastUpdatedIndex];
640     }
641 }
642 
643 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
644 
645 pragma solidity ^0.5.2;
646 
647 /**
648  * @title Helps contracts guard against reentrancy attacks.
649  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
650  * @dev If you mark a function `nonReentrant`, you should also
651  * mark it `external`.
652  */
653 contract ReentrancyGuard {
654     /// @dev counter to allow mutex lock with only one SSTORE operation
655     uint256 private _guardCounter;
656 
657     constructor () internal {
658         // The counter starts at one to prevent changing it from zero to a non-zero
659         // value, which is a more expensive operation.
660         _guardCounter = 1;
661     }
662 
663     /**
664      * @dev Prevents a contract from calling itself, directly or indirectly.
665      * Calling a `nonReentrant` function from another `nonReentrant`
666      * function is not supported. It is possible to prevent this from happening
667      * by making the `nonReentrant` function external, and make it call a
668      * `private` function that does the actual work.
669      */
670     modifier nonReentrant() {
671         _guardCounter += 1;
672         uint256 localCounter = _guardCounter;
673         _;
674         require(localCounter == _guardCounter);
675     }
676 }
677 
678 // File: contracts/meta-oracles/lib/TimeSeriesFeedV2.sol
679 
680 /*
681     Copyright 2019 Set Labs Inc.
682 
683     Licensed under the Apache License, Version 2.0 (the "License");
684     you may not use this file except in compliance with the License.
685     You may obtain a copy of the License at
686 
687     http://www.apache.org/licenses/LICENSE-2.0
688 
689     Unless required by applicable law or agreed to in writing, software
690     distributed under the License is distributed on an "AS IS" BASIS,
691     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
692     See the License for the specific language governing permissions and
693     limitations under the License.
694 */
695 
696 pragma solidity 0.5.7;
697 
698 
699 
700 
701 
702 /**
703  * @title TimeSeriesFeedV2
704  * @author Set Protocol
705  *
706  * Contract used to track time-series data. This is meant to be inherited, as the calculateNextValue
707  * function is unimplemented. New data is appended by calling the poke function, which retrieves the
708  * latest value using the calculateNextValue function.
709  *
710  * CHANGELOG
711  * - Built to be inherited by contract that implements new calculateNextValue function
712  * - Uses LinkedListLibraryV3
713  * - nextEarliestUpdate is passed into constructor
714  */
715 contract TimeSeriesFeedV2 is
716     ReentrancyGuard
717 {
718     using SafeMath for uint256;
719     using LinkedListLibraryV3 for LinkedListLibraryV3.LinkedList;
720 
721     /* ============ State Variables ============ */
722     uint256 public updateInterval;
723     uint256 public maxDataPoints;
724     // Unix Timestamp in seconds of next earliest update time
725     uint256 public nextEarliestUpdate;
726 
727     LinkedListLibraryV3.LinkedList internal timeSeriesData;
728 
729     /* ============ Constructor ============ */
730 
731     /*
732      * Stores time-series values in a LinkedList and updated using data from a specific data source.
733      * Updates must be triggered off chain to be stored in this smart contract.
734      *
735      * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
736                                           off deployment timestamp. A certain data point can't be logged before
737                                           it's expected timestamp but can be logged after
738      * @param  _nextEarliestUpdate        Time the first on-chain price update becomes available
739      * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold
740      * @param  _seededValues              Array of previous timeseries values to seed initial values in list.
741      *                                    The last value should contain the most current piece of data
742      */
743     constructor(
744         uint256 _updateInterval,
745         uint256 _nextEarliestUpdate,
746         uint256 _maxDataPoints,
747         uint256[] memory _seededValues
748     )
749         public
750     {
751 
752         // Check that nextEarliestUpdate is greater than current block timestamp
753         require(
754             _nextEarliestUpdate > block.timestamp,
755             "TimeSeriesFeed.constructor: nextEarliestUpdate must be greater than current timestamp."
756         );
757 
758         // Check that at least one seeded value is passed in
759         require(
760             _seededValues.length > 0,
761             "TimeSeriesFeed.constructor: Must include at least one seeded value."
762         );
763 
764         // Check that maxDataPoints greater than 0
765         require(
766             _maxDataPoints > 0,
767             "TimeSeriesFeed.constructor: Max data points must be greater than 0."
768         );
769 
770         // Check that updateInterval greater than 0
771         require(
772             _updateInterval > 0,
773             "TimeSeriesFeed.constructor: Update interval must be greater than 0."
774         );
775 
776         // Set updateInterval and maxDataPoints
777         updateInterval = _updateInterval;
778         maxDataPoints = _maxDataPoints;
779 
780         // Define upper data size limit for linked list and input initial value
781         timeSeriesData.initialize(_maxDataPoints, _seededValues[0]);
782 
783         // Cycle through input values array (skipping first value used to initialize LinkedList)
784         // and add to timeSeriesData
785         for (uint256 i = 1; i < _seededValues.length; i++) {
786             timeSeriesData.editList(_seededValues[i]);
787         }
788 
789         // Set nextEarliestUpdate
790         nextEarliestUpdate = _nextEarliestUpdate;
791     }
792 
793     /* ============ External ============ */
794 
795     /*
796      * Updates linked list with newest data point by calling the implemented calculateNextValue function
797      */
798     function poke()
799         external
800         nonReentrant
801     {
802         // Make sure block timestamp exceeds nextEarliestUpdate
803         require(
804             block.timestamp >= nextEarliestUpdate,
805             "TimeSeriesFeed.poke: Not enough time elapsed since last update"
806         );
807 
808         // Get the most current data point
809         uint256 newValue = calculateNextValue();
810 
811         // Update the nextEarliestUpdate to previous nextEarliestUpdate plus updateInterval
812         nextEarliestUpdate = nextEarliestUpdate.add(updateInterval);
813 
814         // Update linkedList with new price
815         timeSeriesData.editList(newValue);
816     }
817 
818     /*
819      * Query linked list for specified days of data. Will revert if number of days
820      * passed exceeds amount of days collected. Will revert if not enough days of
821      * data logged.
822      *
823      * @param  _numDataPoints  Number of datapoints to query
824      * @returns                Array of datapoints of length _numDataPoints from most recent to oldest
825      */
826     function read(
827         uint256 _numDataPoints
828     )
829         external
830         view
831         returns (uint256[] memory)
832     {
833         return timeSeriesData.readList(_numDataPoints);
834     }
835 
836 
837     /* ============ Internal ============ */
838 
839     function calculateNextValue()
840         internal
841         returns (uint256);
842 
843 }
844 
845 // File: contracts/meta-oracles/feeds/TwoAssetLinearizedTimeSeriesFeed.sol
846 
847 /*
848     Copyright 2019 Set Labs Inc.
849 
850     Licensed under the Apache License, Version 2.0 (the "License");
851     you may not use this file except in compliance with the License.
852     You may obtain a copy of the License at
853 
854     http://www.apache.org/licenses/LICENSE-2.0
855 
856     Unless required by applicable law or agreed to in writing, software
857     distributed under the License is distributed on an "AS IS" BASIS,
858     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
859     See the License for the specific language governing permissions and
860     limitations under the License.
861 */
862 
863 pragma solidity 0.5.7;
864 
865 
866 
867 
868 
869 
870 
871 
872 /**
873  * @title TwoAssetLinearizedTimeSeriesFeed
874  * @author Set Protocol
875  *
876  * This TimeSeriesFeed calculates the ratio of base to quote asset and stores it using the
877  * inherited TimeSeriesFeedV2 contract. On calculation, if the interpolationThreshold
878  * is reached, then it returns a linearly interpolated value.
879  */
880 contract TwoAssetLinearizedTimeSeriesFeed is
881     TimeSeriesFeedV2,
882     TimeLockUpgradeV2
883 {
884     using SafeMath for uint256;
885     using LinkedListLibraryV3 for LinkedListLibraryV3.LinkedList;
886 
887     /* ============ State Variables ============ */
888 
889     // Amount of time after which read interpolates price result, in seconds
890     uint256 public interpolationThreshold;
891     string public dataDescription;
892     IOracle public baseOracleInstance;
893     IOracle public quoteOracleInstance;
894 
895 
896     /* ============ Events ============ */
897 
898     event LogOracleUpdated(
899         address indexed newOracleAddress
900     );
901 
902     /* ============ Constructor ============ */
903 
904     /*
905      * Set interpolationThreshold, data description, quote oracle and base oracle and instantiate oracle
906      *
907      * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
908                                           off deployment timestamp. A certain data point can't be logged before
909                                           it's expected timestamp but can be logged after (for TimeSeriesFeed)
910      * @param  _nextEarliestUpdate        Time the first on-chain price update becomes available (for TimeSeriesFeed)
911      * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold (for TimeSeriesFeed)
912      * @param  _seededValues              Array of previous timeseries values to seed initial values in list.
913      *                                    The last value should contain the most current piece of data (for TimeSeriesFeed)
914      * @param  _interpolationThreshold    The minimum time in seconds where interpolation is enabled
915      * @param  _baseOracleAddress         The address of the base oracle to read current data from
916      * @param  _quoteOracleAddress        The address of the quote oracle to read current data from
917      * @param  _dataDescription           Description of contract for Etherscan / other applications
918      */
919     constructor(
920         uint256 _updateInterval,
921         uint256 _nextEarliestUpdate,
922         uint256 _maxDataPoints,
923         uint256[] memory _seededValues,
924         uint256 _interpolationThreshold,
925         IOracle _baseOracleAddress,
926         IOracle _quoteOracleAddress,
927         string memory _dataDescription
928     )
929         public
930         TimeSeriesFeedV2(
931             _updateInterval,
932             _nextEarliestUpdate,
933             _maxDataPoints,
934             _seededValues
935         )
936     {
937         interpolationThreshold = _interpolationThreshold;
938         baseOracleInstance = _baseOracleAddress;
939         quoteOracleInstance = _quoteOracleAddress;
940         dataDescription = _dataDescription;
941     }
942 
943     /* ============ External ============ */
944 
945     /*
946      * Change base asset oracle in case current one fails or is deprecated. Only contract
947      * owner is allowed to change.
948      *
949      * @param  _newBaseOracleAddress       Address of new oracle to pull data from
950      */
951     function changeBaseOracle(
952         IOracle _newBaseOracleAddress
953     )
954         external
955         timeLockUpgrade
956     {
957         // Check to make sure new base oracle address is passed
958         require(
959             address(_newBaseOracleAddress) != address(baseOracleInstance),
960             "TwoAssetLinearizedTimeSeriesFeed.changeBaseOracle: Must give new base oracle address."
961         );
962 
963         baseOracleInstance = _newBaseOracleAddress;
964 
965         emit LogOracleUpdated(address(_newBaseOracleAddress));
966     }
967 
968     /*
969      * Change quote asset oracle in case current one fails or is deprecated. Only contract
970      * owner is allowed to change.
971      *
972      * @param  _newQuoteOracleAddress       Address of new oracle to pull data from
973      */
974     function changeQuoteOracle(
975         IOracle _newQuoteOracleAddress
976     )
977         external
978         timeLockUpgrade
979     {
980         // Check to make sure new quote oracle address is passed
981         require(
982             address(_newQuoteOracleAddress) != address(quoteOracleInstance),
983             "TwoAssetLinearizedTimeSeriesFeed.changeQuoteOracle: Must give new quote oracle address."
984         );
985 
986         quoteOracleInstance = _newQuoteOracleAddress;
987 
988         emit LogOracleUpdated(address(_newQuoteOracleAddress));
989     }
990 
991     /* ============ Internal ============ */
992 
993     /*
994      * Returns the data from the oracle contract. If the current timestamp has surpassed
995      * the interpolationThreshold, then the current price is retrieved and interpolated based on
996      * the previous value and the time that has elapsed since the intended update value.
997      *
998      * Returns with newest data point by querying oracle. Is eligible to be
999      * called after nextAvailableUpdate timestamp has passed. Because the nextAvailableUpdate occurs
1000      * on a predetermined cadence based on the time of deployment, delays in calling poke do not propogate
1001      * throughout the whole dataset and the drift caused by previous poke transactions not being mined
1002      * exactly on nextAvailableUpdate do not compound as they would if it was required that poke is called
1003      * an updateInterval amount of time after the last poke.
1004      *
1005      * @returns                         Returns the datapoint from the oracle contract
1006      */
1007     function calculateNextValue()
1008         internal
1009         returns (uint256)
1010     {
1011         // Get current base oracle value
1012         uint256 baseOracleValue = baseOracleInstance.read();
1013 
1014         // Get current quote oracle value
1015         uint256 quoteOracleValue = quoteOracleInstance.read();
1016 
1017         // Calculate the current base / quote asset ratio with 10 ** 18 precision
1018         uint256 currentRatioValue = baseOracleValue.mul(10 ** 18).div(quoteOracleValue);
1019 
1020         // Calculate how much time has passed from last expected update
1021         uint256 timeFromExpectedUpdate = block.timestamp.sub(nextEarliestUpdate);
1022 
1023         // If block timeFromExpectedUpdate is greater than interpolationThreshold we linearize
1024         // the current price to try to reduce error
1025         if (timeFromExpectedUpdate < interpolationThreshold) {
1026             return currentRatioValue;
1027         } else {
1028             // Get the previous value
1029             uint256 previousRatioValue = timeSeriesData.getLatestValue();
1030 
1031             return DataSourceLinearInterpolationLibrary.interpolateDelayedPriceUpdate(
1032                 currentRatioValue,
1033                 updateInterval,
1034                 timeFromExpectedUpdate,
1035                 previousRatioValue
1036             );
1037         }
1038     }
1039 }