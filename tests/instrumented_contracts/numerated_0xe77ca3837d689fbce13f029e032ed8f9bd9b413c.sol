1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
68 
69 pragma solidity ^0.5.2;
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor () internal {
86         _owner = msg.sender;
87         emit OwnershipTransferred(address(0), _owner);
88     }
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner());
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allows the current owner to relinquish control of the contract.
114      * It will not be possible to call the functions with the `onlyOwner`
115      * modifier anymore.
116      * @notice Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124     /**
125      * @dev Allows the current owner to transfer control of the contract to a newOwner.
126      * @param newOwner The address to transfer ownership to.
127      */
128     function transferOwnership(address newOwner) public onlyOwner {
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers control of the contract to a newOwner.
134      * @param newOwner The address to transfer ownership to.
135      */
136     function _transferOwnership(address newOwner) internal {
137         require(newOwner != address(0));
138         emit OwnershipTransferred(_owner, newOwner);
139         _owner = newOwner;
140     }
141 }
142 
143 // File: set-protocol-contracts/contracts/lib/TimeLockUpgradeV2.sol
144 
145 /*
146     Copyright 2018 Set Labs Inc.
147 
148     Licensed under the Apache License, Version 2.0 (the "License");
149     you may not use this file except in compliance with the License.
150     You may obtain a copy of the License at
151 
152     http://www.apache.org/licenses/LICENSE-2.0
153 
154     Unless required by applicable law or agreed to in writing, software
155     distributed under the License is distributed on an "AS IS" BASIS,
156     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
157     See the License for the specific language governing permissions and
158     limitations under the License.
159 */
160 
161 pragma solidity 0.5.7;
162 
163 
164 
165 
166 /**
167  * @title TimeLockUpgradeV2
168  * @author Set Protocol
169  *
170  * The TimeLockUpgradeV2 contract contains a modifier for handling minimum time period updates
171  *
172  * CHANGELOG:
173  * - Requires that the caller is the owner
174  * - New function to allow deletion of existing timelocks
175  * - Added upgradeData to UpgradeRegistered event
176  */
177 contract TimeLockUpgradeV2 is
178     Ownable
179 {
180     using SafeMath for uint256;
181 
182     /* ============ State Variables ============ */
183 
184     // Timelock Upgrade Period in seconds
185     uint256 public timeLockPeriod;
186 
187     // Mapping of maps hash of registered upgrade to its registration timestam
188     mapping(bytes32 => uint256) public timeLockedUpgrades;
189 
190     /* ============ Events ============ */
191 
192     event UpgradeRegistered(
193         bytes32 indexed _upgradeHash,
194         uint256 _timestamp,
195         bytes _upgradeData
196     );
197 
198     event RemoveRegisteredUpgrade(
199         bytes32 indexed _upgradeHash
200     );
201 
202     /* ============ Modifiers ============ */
203 
204     modifier timeLockUpgrade() {
205         require(
206             isOwner(),
207             "TimeLockUpgradeV2: The caller must be the owner"
208         );
209 
210         // If the time lock period is 0, then allow non-timebound upgrades.
211         // This is useful for initialization of the protocol and for testing.
212         if (timeLockPeriod > 0) {
213             // The upgrade hash is defined by the hash of the transaction call data,
214             // which uniquely identifies the function as well as the passed in arguments.
215             bytes32 upgradeHash = keccak256(
216                 abi.encodePacked(
217                     msg.data
218                 )
219             );
220 
221             uint256 registrationTime = timeLockedUpgrades[upgradeHash];
222 
223             // If the upgrade hasn't been registered, register with the current time.
224             if (registrationTime == 0) {
225                 timeLockedUpgrades[upgradeHash] = block.timestamp;
226 
227                 emit UpgradeRegistered(
228                     upgradeHash,
229                     block.timestamp,
230                     msg.data
231                 );
232 
233                 return;
234             }
235 
236             require(
237                 block.timestamp >= registrationTime.add(timeLockPeriod),
238                 "TimeLockUpgradeV2: Time lock period must have elapsed."
239             );
240 
241             // Reset the timestamp to 0
242             timeLockedUpgrades[upgradeHash] = 0;
243 
244         }
245 
246         // Run the rest of the upgrades
247         _;
248     }
249 
250     /* ============ Function ============ */
251 
252     /**
253      * Removes an existing upgrade.
254      *
255      * @param  _upgradeHash    Keccack256 hash that uniquely identifies function called and arguments
256      */
257     function removeRegisteredUpgrade(
258         bytes32 _upgradeHash
259     )
260         external
261         onlyOwner
262     {
263         require(
264             timeLockedUpgrades[_upgradeHash] != 0,
265             "TimeLockUpgradeV2.removeRegisteredUpgrade: Upgrade hash must be registered"
266         );
267 
268         // Reset the timestamp to 0
269         timeLockedUpgrades[_upgradeHash] = 0;
270 
271         emit RemoveRegisteredUpgrade(
272             _upgradeHash
273         );
274     }
275 
276     /**
277      * Change timeLockPeriod period. Generally called after initially settings have been set up.
278      *
279      * @param  _timeLockPeriod   Time in seconds that upgrades need to be evaluated before execution
280      */
281     function setTimeLockPeriod(
282         uint256 _timeLockPeriod
283     )
284         external
285         onlyOwner
286     {
287         // Only allow setting of the timeLockPeriod if the period is greater than the existing
288         require(
289             _timeLockPeriod > timeLockPeriod,
290             "TimeLockUpgradeV2: New period must be greater than existing"
291         );
292 
293         timeLockPeriod = _timeLockPeriod;
294     }
295 }
296 
297 // File: contracts/meta-oracles/lib/DataSourceLinearInterpolationLibrary.sol
298 
299 /*
300     Copyright 2019 Set Labs Inc.
301 
302     Licensed under the Apache License, Version 2.0 (the "License");
303     you may not use this file except in compliance with the License.
304     You may obtain a copy of the License at
305 
306     http://www.apache.org/licenses/LICENSE-2.0
307 
308     Unless required by applicable law or agreed to in writing, software
309     distributed under the License is distributed on an "AS IS" BASIS,
310     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
311     See the License for the specific language governing permissions and
312     limitations under the License.
313 */
314 
315 pragma solidity 0.5.7;
316 
317 
318 
319 /**
320  * @title LinearInterpolationLibrary
321  * @author Set Protocol
322  *
323  * Library used to determine linearly interpolated value for DataSource contracts when TimeSeriesFeed
324  * is updated after interpolationThreshold has passed.
325  */
326 library DataSourceLinearInterpolationLibrary {
327     using SafeMath for uint256;
328 
329     /* ============ External ============ */
330 
331     /*
332      * When the update time has surpassed the currentTime + interpolationThreshold, linearly interpolate the
333      * price between the current time and price and the last updated time and price to reduce potential error. This
334      * is done with the following series of equations, modified in this instance to deal unsigned integers:
335      *
336      * price = (currentPrice * updateInterval + previousLoggedPrice * timeFromExpectedUpdate) / timeFromLastUpdate
337      *
338      * Where updateTimeFraction represents the fraction of time passed between the last update and now spent in
339      * the previous update window. It's worth noting that because we consider updates to occur on their update
340      * timestamp we can make the assumption that the amount of time spent in the previous update window is equal
341      * to the update frequency.
342      *
343      * By way of example, assume updateInterval of 24 hours and a interpolationThreshold of 1 hour. At time 1 the
344      * update is missed by one day and when the oracle is finally called the price is 150, the price feed
345      * then interpolates this price to imply a price at t1 equal to 125. Time 2 the update is 10 minutes late but
346      * since it's within the interpolationThreshold the value isn't interpolated. At time 3 everything
347      * falls back in line.
348      *
349      * +----------------------+------+-------+-------+-------+
350      * |                      | 0    | 1     | 2     | 3     |
351      * +----------------------+------+-------+-------+-------+
352      * | Expected Update Time | 0:00 | 24:00 | 48:00 | 72:00 |
353      * +----------------------+------+-------+-------+-------+
354      * | Actual Update Time   | 0:00 | 48:00 | 48:10 | 72:00 |
355      * +----------------------+------+-------+-------+-------+
356      * | Logged Px            | 100  | 125   | 151   | 130   |
357      * +----------------------+------+-------+-------+-------+
358      * | Received Oracle Px   | 100  | 150   | 151   | 130   |
359      * +----------------------+------+-------+-------+-------+
360      * | Actual Price         | 100  | 110   | 151   | 130   |
361      * +------------------------------------------------------
362      *
363      * @param  _currentPrice                Current price returned by oracle
364      * @param  _updateInterval              Update interval of TimeSeriesFeed
365      * @param  _timeFromExpectedUpdate      Time passed from expected update
366      * @param  _previousLoggedDataPoint     Previously logged price from TimeSeriesFeed
367      * @returns                             Interpolated price value
368      */
369     function interpolateDelayedPriceUpdate(
370         uint256 _currentPrice,
371         uint256 _updateInterval,
372         uint256 _timeFromExpectedUpdate,
373         uint256 _previousLoggedDataPoint
374     )
375         internal
376         pure
377         returns (uint256)
378     {
379         // Calculate how much time has passed from timestamp corresponding to last update
380         uint256 timeFromLastUpdate = _timeFromExpectedUpdate.add(_updateInterval);
381 
382         // Linearly interpolate between last updated price (with corresponding timestamp) and current price (with
383         // current timestamp) to imply price at the timestamp we are updating
384         return _currentPrice.mul(_updateInterval)
385             .add(_previousLoggedDataPoint.mul(_timeFromExpectedUpdate))
386             .div(timeFromLastUpdate);
387     }
388 }
389 
390 // File: contracts/meta-oracles/interfaces/IOracle.sol
391 
392 /*
393     Copyright 2019 Set Labs Inc.
394 
395     Licensed under the Apache License, Version 2.0 (the "License");
396     you may not use this file except in compliance with the License.
397     You may obtain a copy of the License at
398 
399     http://www.apache.org/licenses/LICENSE-2.0
400 
401     Unless required by applicable law or agreed to in writing, software
402     distributed under the License is distributed on an "AS IS" BASIS,
403     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
404     See the License for the specific language governing permissions and
405     limitations under the License.
406 */
407 
408 pragma solidity 0.5.7;
409 
410 
411 /**
412  * @title IOracle
413  * @author Set Protocol
414  *
415  * Interface for operating with any external Oracle that returns uint256 or
416  * an adapting contract that converts oracle output to uint256
417  */
418 interface IOracle {
419 
420     /**
421      * Returns the queried data from an oracle returning uint256
422      *
423      * @return  Current price of asset represented in uint256
424      */
425     function read()
426         external
427         view
428         returns (uint256);
429 }
430 
431 // File: contracts/meta-oracles/lib/LinkedListLibraryV3.sol
432 
433 /*
434     Copyright 2019 Set Labs Inc.
435 
436     Licensed under the Apache License, Version 2.0 (the "License");
437     you may not use this file except in compliance with the License.
438     You may obtain a copy of the License at
439 
440     http://www.apache.org/licenses/LICENSE-2.0
441 
442     Unless required by applicable law or agreed to in writing, software
443     distributed under the License is distributed on an "AS IS" BASIS,
444     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
445     See the License for the specific language governing permissions and
446     limitations under the License.
447 */
448 
449 pragma solidity 0.5.7;
450 pragma experimental "ABIEncoderV2";
451 
452 
453 
454 /**
455  * @title LinkedListLibraryV3
456  * @author Set Protocol
457  *
458  * Library for creating and altering uni-directional circularly linked lists, optimized for sequential updating
459  * Version two of this contract is a library vs. a contract.
460  *
461  *
462  * CHANGELOG
463  * - LinkedListLibraryV3's readList function does not load LinkedList into memory
464  * - readListMemory is removed
465  */
466 library LinkedListLibraryV3 {
467 
468     using SafeMath for uint256;
469 
470     /* ============ Structs ============ */
471 
472     struct LinkedList{
473         uint256 dataSizeLimit;
474         uint256 lastUpdatedIndex;
475         uint256[] dataArray;
476     }
477 
478     /*
479      * Initialize LinkedList by setting limit on amount of nodes and initial value of node 0
480      *
481      * @param  _self                        LinkedList to operate on
482      * @param  _dataSizeLimit               Max amount of nodes allowed in LinkedList
483      * @param  _initialValue                Initial value of node 0 in LinkedList
484      */
485     function initialize(
486         LinkedList storage _self,
487         uint256 _dataSizeLimit,
488         uint256 _initialValue
489     )
490         internal
491     {
492         // Check dataArray is empty
493         require(
494             _self.dataArray.length == 0,
495             "LinkedListLibrary.initialize: Initialized LinkedList must be empty"
496         );
497 
498         // Check that LinkedList is intialized to be greater than 0 size
499         require(
500             _dataSizeLimit > 0,
501             "LinkedListLibrary.initialize: dataSizeLimit must be greater than 0."
502         );
503 
504         // Initialize Linked list by defining upper limit of data points in the list and setting
505         // initial value
506         _self.dataSizeLimit = _dataSizeLimit;
507         _self.dataArray.push(_initialValue);
508         _self.lastUpdatedIndex = 0;
509     }
510 
511     /*
512      * Add new value to list by either creating new node if node limit not reached or updating
513      * existing node value
514      *
515      * @param  _self                        LinkedList to operate on
516      * @param  _addedValue                  Value to add to list
517      */
518     function editList(
519         LinkedList storage _self,
520         uint256 _addedValue
521     )
522         internal
523     {
524         // Add node if data hasn't reached size limit, otherwise update next node
525         _self.dataArray.length < _self.dataSizeLimit ? addNode(_self, _addedValue)
526             : updateNode(_self, _addedValue);
527     }
528 
529     /*
530      * Add new value to list by either creating new node. Node limit must not be reached.
531      *
532      * @param  _self                        LinkedList to operate on
533      * @param  _addedValue                  Value to add to list
534      */
535     function addNode(
536         LinkedList storage _self,
537         uint256 _addedValue
538     )
539         internal
540     {
541         uint256 newNodeIndex = _self.lastUpdatedIndex.add(1);
542 
543         require(
544             newNodeIndex == _self.dataArray.length,
545             "LinkedListLibrary: Node must be added at next expected index in list"
546         );
547 
548         require(
549             newNodeIndex < _self.dataSizeLimit,
550             "LinkedListLibrary: Attempting to add node that exceeds data size limit"
551         );
552 
553         // Add node value
554         _self.dataArray.push(_addedValue);
555 
556         // Update lastUpdatedIndex value
557         _self.lastUpdatedIndex = newNodeIndex;
558     }
559 
560     /*
561      * Add new value to list by updating existing node. Updates only happen if node limit has been
562      * reached.
563      *
564      * @param  _self                        LinkedList to operate on
565      * @param  _addedValue                  Value to add to list
566      */
567     function updateNode(
568         LinkedList storage _self,
569         uint256 _addedValue
570     )
571         internal
572     {
573         // Determine the next node in list to be updated
574         uint256 updateNodeIndex = _self.lastUpdatedIndex.add(1) % _self.dataSizeLimit;
575 
576         // Require that updated node has been previously added
577         require(
578             updateNodeIndex < _self.dataArray.length,
579             "LinkedListLibrary: Attempting to update non-existent node"
580         );
581 
582         // Update node value and last updated index
583         _self.dataArray[updateNodeIndex] = _addedValue;
584         _self.lastUpdatedIndex = updateNodeIndex;
585     }
586 
587     /*
588      * Read list from the lastUpdatedIndex back the passed amount of data points.
589      *
590      * @param  _self                        LinkedList to operate on
591      * @param  _dataPoints                  Number of data points to return
592      * @return                              Array of length dataPoints containing most recent values
593      */
594     function readList(
595         LinkedList storage _self,
596         uint256 _dataPoints
597     )
598         internal
599         view
600         returns (uint256[] memory)
601     {
602         // Make sure query isn't for more data than collected
603         require(
604             _dataPoints <= _self.dataArray.length,
605             "LinkedListLibrary: Querying more data than available"
606         );
607 
608         // Instantiate output array in memory
609         uint256[] memory outputArray = new uint256[](_dataPoints);
610 
611         // Find head of list
612         uint256 linkedListIndex = _self.lastUpdatedIndex;
613         for (uint256 i = 0; i < _dataPoints; i++) {
614             // Get value at index in linkedList
615             outputArray[i] = _self.dataArray[linkedListIndex];
616 
617             // Find next linked index
618             linkedListIndex = linkedListIndex == 0 ? _self.dataSizeLimit.sub(1) : linkedListIndex.sub(1);
619         }
620 
621         return outputArray;
622     }
623 
624     /*
625      * Get latest value from LinkedList.
626      *
627      * @param  _self                        LinkedList to operate on
628      * @return                              Latest logged value in LinkedList
629      */
630     function getLatestValue(
631         LinkedList storage _self
632     )
633         internal
634         view
635         returns (uint256)
636     {
637         return _self.dataArray[_self.lastUpdatedIndex];
638     }
639 }
640 
641 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
642 
643 pragma solidity ^0.5.2;
644 
645 /**
646  * @title Helps contracts guard against reentrancy attacks.
647  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
648  * @dev If you mark a function `nonReentrant`, you should also
649  * mark it `external`.
650  */
651 contract ReentrancyGuard {
652     /// @dev counter to allow mutex lock with only one SSTORE operation
653     uint256 private _guardCounter;
654 
655     constructor () internal {
656         // The counter starts at one to prevent changing it from zero to a non-zero
657         // value, which is a more expensive operation.
658         _guardCounter = 1;
659     }
660 
661     /**
662      * @dev Prevents a contract from calling itself, directly or indirectly.
663      * Calling a `nonReentrant` function from another `nonReentrant`
664      * function is not supported. It is possible to prevent this from happening
665      * by making the `nonReentrant` function external, and make it call a
666      * `private` function that does the actual work.
667      */
668     modifier nonReentrant() {
669         _guardCounter += 1;
670         uint256 localCounter = _guardCounter;
671         _;
672         require(localCounter == _guardCounter);
673     }
674 }
675 
676 // File: contracts/meta-oracles/lib/TimeSeriesFeedV2.sol
677 
678 /*
679     Copyright 2019 Set Labs Inc.
680 
681     Licensed under the Apache License, Version 2.0 (the "License");
682     you may not use this file except in compliance with the License.
683     You may obtain a copy of the License at
684 
685     http://www.apache.org/licenses/LICENSE-2.0
686 
687     Unless required by applicable law or agreed to in writing, software
688     distributed under the License is distributed on an "AS IS" BASIS,
689     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
690     See the License for the specific language governing permissions and
691     limitations under the License.
692 */
693 
694 pragma solidity 0.5.7;
695 
696 
697 
698 
699 
700 /**
701  * @title TimeSeriesFeedV2
702  * @author Set Protocol
703  *
704  * Contract used to track time-series data. This is meant to be inherited, as the calculateNextValue
705  * function is unimplemented. New data is appended by calling the poke function, which retrieves the
706  * latest value using the calculateNextValue function.
707  *
708  * CHANGELOG
709  * - Built to be inherited by contract that implements new calculateNextValue function
710  * - Uses LinkedListLibraryV3
711  * - nextEarliestUpdate is passed into constructor
712  */
713 contract TimeSeriesFeedV2 is
714     ReentrancyGuard
715 {
716     using SafeMath for uint256;
717     using LinkedListLibraryV3 for LinkedListLibraryV3.LinkedList;
718 
719     /* ============ State Variables ============ */
720     uint256 public updateInterval;
721     uint256 public maxDataPoints;
722     // Unix Timestamp in seconds of next earliest update time
723     uint256 public nextEarliestUpdate;
724 
725     LinkedListLibraryV3.LinkedList internal timeSeriesData;
726 
727     /* ============ Constructor ============ */
728 
729     /*
730      * Stores time-series values in a LinkedList and updated using data from a specific data source.
731      * Updates must be triggered off chain to be stored in this smart contract.
732      *
733      * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
734                                           off deployment timestamp. A certain data point can't be logged before
735                                           it's expected timestamp but can be logged after
736      * @param  _nextEarliestUpdate        Time the first on-chain price update becomes available
737      * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold
738      * @param  _seededValues              Array of previous timeseries values to seed initial values in list.
739      *                                    The last value should contain the most current piece of data
740      */
741     constructor(
742         uint256 _updateInterval,
743         uint256 _nextEarliestUpdate,
744         uint256 _maxDataPoints,
745         uint256[] memory _seededValues
746     )
747         public
748     {
749 
750         // Check that nextEarliestUpdate is greater than current block timestamp
751         require(
752             _nextEarliestUpdate > block.timestamp,
753             "TimeSeriesFeed.constructor: nextEarliestUpdate must be greater than current timestamp."
754         );
755 
756         // Check that at least one seeded value is passed in
757         require(
758             _seededValues.length > 0,
759             "TimeSeriesFeed.constructor: Must include at least one seeded value."
760         );
761 
762         // Check that maxDataPoints greater than 0
763         require(
764             _maxDataPoints > 0,
765             "TimeSeriesFeed.constructor: Max data points must be greater than 0."
766         );
767 
768         // Check that updateInterval greater than 0
769         require(
770             _updateInterval > 0,
771             "TimeSeriesFeed.constructor: Update interval must be greater than 0."
772         );
773 
774         // Set updateInterval and maxDataPoints
775         updateInterval = _updateInterval;
776         maxDataPoints = _maxDataPoints;
777 
778         // Define upper data size limit for linked list and input initial value
779         timeSeriesData.initialize(_maxDataPoints, _seededValues[0]);
780 
781         // Cycle through input values array (skipping first value used to initialize LinkedList)
782         // and add to timeSeriesData
783         for (uint256 i = 1; i < _seededValues.length; i++) {
784             timeSeriesData.editList(_seededValues[i]);
785         }
786 
787         // Set nextEarliestUpdate
788         nextEarliestUpdate = _nextEarliestUpdate;
789     }
790 
791     /* ============ External ============ */
792 
793     /*
794      * Updates linked list with newest data point by calling the implemented calculateNextValue function
795      */
796     function poke()
797         external
798         nonReentrant
799     {
800         // Make sure block timestamp exceeds nextEarliestUpdate
801         require(
802             block.timestamp >= nextEarliestUpdate,
803             "TimeSeriesFeed.poke: Not enough time elapsed since last update"
804         );
805 
806         // Get the most current data point
807         uint256 newValue = calculateNextValue();
808 
809         // Update the nextEarliestUpdate to previous nextEarliestUpdate plus updateInterval
810         nextEarliestUpdate = nextEarliestUpdate.add(updateInterval);
811 
812         // Update linkedList with new price
813         timeSeriesData.editList(newValue);
814     }
815 
816     /*
817      * Query linked list for specified days of data. Will revert if number of days
818      * passed exceeds amount of days collected. Will revert if not enough days of
819      * data logged.
820      *
821      * @param  _numDataPoints  Number of datapoints to query
822      * @returns                Array of datapoints of length _numDataPoints from most recent to oldest
823      */
824     function read(
825         uint256 _numDataPoints
826     )
827         external
828         view
829         returns (uint256[] memory)
830     {
831         return timeSeriesData.readList(_numDataPoints);
832     }
833 
834 
835     /* ============ Internal ============ */
836 
837     function calculateNextValue()
838         internal
839         returns (uint256);
840 
841 }
842 
843 // File: contracts/meta-oracles/feeds/TwoAssetLinearizedTimeSeriesFeed.sol
844 
845 /*
846     Copyright 2019 Set Labs Inc.
847 
848     Licensed under the Apache License, Version 2.0 (the "License");
849     you may not use this file except in compliance with the License.
850     You may obtain a copy of the License at
851 
852     http://www.apache.org/licenses/LICENSE-2.0
853 
854     Unless required by applicable law or agreed to in writing, software
855     distributed under the License is distributed on an "AS IS" BASIS,
856     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
857     See the License for the specific language governing permissions and
858     limitations under the License.
859 */
860 
861 pragma solidity 0.5.7;
862 
863 
864 
865 
866 
867 
868 
869 
870 /**
871  * @title TwoAssetLinearizedTimeSeriesFeed
872  * @author Set Protocol
873  *
874  * This TimeSeriesFeed calculates the ratio of base to quote asset and stores it using the
875  * inherited TimeSeriesFeedV2 contract. On calculation, if the interpolationThreshold
876  * is reached, then it returns a linearly interpolated value.
877  */
878 contract TwoAssetLinearizedTimeSeriesFeed is
879     TimeSeriesFeedV2,
880     TimeLockUpgradeV2
881 {
882     using SafeMath for uint256;
883     using LinkedListLibraryV3 for LinkedListLibraryV3.LinkedList;
884 
885     /* ============ State Variables ============ */
886 
887     // Amount of time after which read interpolates price result, in seconds
888     uint256 public interpolationThreshold;
889     string public dataDescription;
890     IOracle public baseOracleInstance;
891     IOracle public quoteOracleInstance;
892 
893 
894     /* ============ Events ============ */
895 
896     event LogOracleUpdated(
897         address indexed newOracleAddress
898     );
899 
900     /* ============ Constructor ============ */
901 
902     /*
903      * Set interpolationThreshold, data description, quote oracle and base oracle and instantiate oracle
904      *
905      * @param  _updateInterval            Cadence at which data is optimally logged. Optimal schedule is based
906                                           off deployment timestamp. A certain data point can't be logged before
907                                           it's expected timestamp but can be logged after (for TimeSeriesFeed)
908      * @param  _nextEarliestUpdate        Time the first on-chain price update becomes available (for TimeSeriesFeed)
909      * @param  _maxDataPoints             The maximum amount of data points the linkedList will hold (for TimeSeriesFeed)
910      * @param  _seededValues              Array of previous timeseries values to seed initial values in list.
911      *                                    The last value should contain the most current piece of data (for TimeSeriesFeed)
912      * @param  _interpolationThreshold    The minimum time in seconds where interpolation is enabled
913      * @param  _baseOracleAddress         The address of the base oracle to read current data from
914      * @param  _quoteOracleAddress        The address of the quote oracle to read current data from
915      * @param  _dataDescription           Description of contract for Etherscan / other applications
916      */
917     constructor(
918         uint256 _updateInterval,
919         uint256 _nextEarliestUpdate,
920         uint256 _maxDataPoints,
921         uint256[] memory _seededValues,
922         uint256 _interpolationThreshold,
923         IOracle _baseOracleAddress,
924         IOracle _quoteOracleAddress,
925         string memory _dataDescription
926     )
927         public
928         TimeSeriesFeedV2(
929             _updateInterval,
930             _nextEarliestUpdate,
931             _maxDataPoints,
932             _seededValues
933         )
934     {
935         interpolationThreshold = _interpolationThreshold;
936         baseOracleInstance = _baseOracleAddress;
937         quoteOracleInstance = _quoteOracleAddress;
938         dataDescription = _dataDescription;
939     }
940 
941     /* ============ External ============ */
942 
943     /*
944      * Change base asset oracle in case current one fails or is deprecated. Only contract
945      * owner is allowed to change.
946      *
947      * @param  _newBaseOracleAddress       Address of new oracle to pull data from
948      */
949     function changeBaseOracle(
950         IOracle _newBaseOracleAddress
951     )
952         external
953         timeLockUpgrade
954     {
955         // Check to make sure new base oracle address is passed
956         require(
957             address(_newBaseOracleAddress) != address(baseOracleInstance),
958             "TwoAssetLinearizedTimeSeriesFeed.changeBaseOracle: Must give new base oracle address."
959         );
960 
961         baseOracleInstance = _newBaseOracleAddress;
962 
963         emit LogOracleUpdated(address(_newBaseOracleAddress));
964     }
965 
966     /*
967      * Change quote asset oracle in case current one fails or is deprecated. Only contract
968      * owner is allowed to change.
969      *
970      * @param  _newQuoteOracleAddress       Address of new oracle to pull data from
971      */
972     function changeQuoteOracle(
973         IOracle _newQuoteOracleAddress
974     )
975         external
976         timeLockUpgrade
977     {
978         // Check to make sure new quote oracle address is passed
979         require(
980             address(_newQuoteOracleAddress) != address(quoteOracleInstance),
981             "TwoAssetLinearizedTimeSeriesFeed.changeQuoteOracle: Must give new quote oracle address."
982         );
983 
984         quoteOracleInstance = _newQuoteOracleAddress;
985 
986         emit LogOracleUpdated(address(_newQuoteOracleAddress));
987     }
988 
989     /* ============ Internal ============ */
990 
991     /*
992      * Returns the data from the oracle contract. If the current timestamp has surpassed
993      * the interpolationThreshold, then the current price is retrieved and interpolated based on
994      * the previous value and the time that has elapsed since the intended update value.
995      *
996      * Returns with newest data point by querying oracle. Is eligible to be
997      * called after nextAvailableUpdate timestamp has passed. Because the nextAvailableUpdate occurs
998      * on a predetermined cadence based on the time of deployment, delays in calling poke do not propogate
999      * throughout the whole dataset and the drift caused by previous poke transactions not being mined
1000      * exactly on nextAvailableUpdate do not compound as they would if it was required that poke is called
1001      * an updateInterval amount of time after the last poke.
1002      *
1003      * @returns                         Returns the datapoint from the oracle contract
1004      */
1005     function calculateNextValue()
1006         internal
1007         returns (uint256)
1008     {
1009         // Get current base oracle value
1010         uint256 baseOracleValue = baseOracleInstance.read();
1011 
1012         // Get current quote oracle value
1013         uint256 quoteOracleValue = quoteOracleInstance.read();
1014 
1015         // Calculate the current base / quote asset ratio with 10 ** 18 precision
1016         uint256 currentRatioValue = baseOracleValue.mul(10 ** 18).div(quoteOracleValue);
1017 
1018         // Calculate how much time has passed from last expected update
1019         uint256 timeFromExpectedUpdate = block.timestamp.sub(nextEarliestUpdate);
1020 
1021         // If block timeFromExpectedUpdate is greater than interpolationThreshold we linearize
1022         // the current price to try to reduce error
1023         if (timeFromExpectedUpdate < interpolationThreshold) {
1024             return currentRatioValue;
1025         } else {
1026             // Get the previous value
1027             uint256 previousRatioValue = timeSeriesData.getLatestValue();
1028 
1029             return DataSourceLinearInterpolationLibrary.interpolateDelayedPriceUpdate(
1030                 currentRatioValue,
1031                 updateInterval,
1032                 timeFromExpectedUpdate,
1033                 previousRatioValue
1034             );
1035         }
1036     }
1037 }