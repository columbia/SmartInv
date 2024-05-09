1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
78 
79 pragma solidity ^0.5.2;
80 
81 /**
82  * @title SafeMath
83  * @dev Unsigned math operations with safety checks that revert on error
84  */
85 library SafeMath {
86     /**
87      * @dev Multiplies two unsigned integers, reverts on overflow.
88      */
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91         // benefit is lost if 'b' is also tested.
92         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
93         if (a == 0) {
94             return 0;
95         }
96 
97         uint256 c = a * b;
98         require(c / a == b);
99 
100         return c;
101     }
102 
103     /**
104      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         // Solidity only automatically asserts when dividing by 0
108         require(b > 0);
109         uint256 c = a / b;
110         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112         return c;
113     }
114 
115     /**
116      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a);
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Adds two unsigned integers, reverts on overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a);
131 
132         return c;
133     }
134 
135     /**
136      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
137      * reverts when dividing by zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         require(b != 0);
141         return a % b;
142     }
143 }
144 
145 // File: contracts/lib/TimeLockUpgrade.sol
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
262 // File: contracts/lib/AddressArrayUtils.sol
263 
264 // Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
265 // https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol
266 
267 pragma solidity 0.5.7;
268 
269 
270 library AddressArrayUtils {
271 
272     /**
273      * Finds the index of the first occurrence of the given element.
274      * @param A The input array to search
275      * @param a The value to find
276      * @return Returns (index and isIn) for the first occurrence starting from index 0
277      */
278     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
279         uint256 length = A.length;
280         for (uint256 i = 0; i < length; i++) {
281             if (A[i] == a) {
282                 return (i, true);
283             }
284         }
285         return (0, false);
286     }
287 
288     /**
289     * Returns true if the value is present in the list. Uses indexOf internally.
290     * @param A The input array to search
291     * @param a The value to find
292     * @return Returns isIn for the first occurrence starting from index 0
293     */
294     function contains(address[] memory A, address a) internal pure returns (bool) {
295         bool isIn;
296         (, isIn) = indexOf(A, a);
297         return isIn;
298     }
299 
300     /// @return Returns index and isIn for the first occurrence starting from
301     /// end
302     function indexOfFromEnd(address[] memory A, address a) internal pure returns (uint256, bool) {
303         uint256 length = A.length;
304         for (uint256 i = length; i > 0; i--) {
305             if (A[i - 1] == a) {
306                 return (i, true);
307             }
308         }
309         return (0, false);
310     }
311 
312     /**
313      * Returns the combination of the two arrays
314      * @param A The first array
315      * @param B The second array
316      * @return Returns A extended by B
317      */
318     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
319         uint256 aLength = A.length;
320         uint256 bLength = B.length;
321         address[] memory newAddresses = new address[](aLength + bLength);
322         for (uint256 i = 0; i < aLength; i++) {
323             newAddresses[i] = A[i];
324         }
325         for (uint256 j = 0; j < bLength; j++) {
326             newAddresses[aLength + j] = B[j];
327         }
328         return newAddresses;
329     }
330 
331     /**
332      * Returns the array with a appended to A.
333      * @param A The first array
334      * @param a The value to append
335      * @return Returns A appended by a
336      */
337     function append(address[] memory A, address a) internal pure returns (address[] memory) {
338         address[] memory newAddresses = new address[](A.length + 1);
339         for (uint256 i = 0; i < A.length; i++) {
340             newAddresses[i] = A[i];
341         }
342         newAddresses[A.length] = a;
343         return newAddresses;
344     }
345 
346     /**
347      * Returns the combination of two storage arrays.
348      * @param A The first array
349      * @param B The second array
350      * @return Returns A appended by a
351      */
352     function sExtend(address[] storage A, address[] storage B) internal {
353         uint256 length = B.length;
354         for (uint256 i = 0; i < length; i++) {
355             A.push(B[i]);
356         }
357     }
358 
359     /**
360      * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
361      * @param A The first array
362      * @param B The second array
363      * @return The intersection of the two arrays
364      */
365     function intersect(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
366         uint256 length = A.length;
367         bool[] memory includeMap = new bool[](length);
368         uint256 newLength = 0;
369         for (uint256 i = 0; i < length; i++) {
370             if (contains(B, A[i])) {
371                 includeMap[i] = true;
372                 newLength++;
373             }
374         }
375         address[] memory newAddresses = new address[](newLength);
376         uint256 j = 0;
377         for (uint256 k = 0; k < length; k++) {
378             if (includeMap[k]) {
379                 newAddresses[j] = A[k];
380                 j++;
381             }
382         }
383         return newAddresses;
384     }
385 
386     /**
387      * Returns the union of the two arrays. Order is not guaranteed.
388      * @param A The first array
389      * @param B The second array
390      * @return The union of the two arrays
391      */
392     function union(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
393         address[] memory leftDifference = difference(A, B);
394         address[] memory rightDifference = difference(B, A);
395         address[] memory intersection = intersect(A, B);
396         return extend(leftDifference, extend(intersection, rightDifference));
397     }
398 
399     /**
400      * Alternate implementation
401      * Assumes there are no duplicates
402      */
403     function unionB(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
404         bool[] memory includeMap = new bool[](A.length + B.length);
405         uint256 count = 0;
406         for (uint256 i = 0; i < A.length; i++) {
407             includeMap[i] = true;
408             count++;
409         }
410         for (uint256 j = 0; j < B.length; j++) {
411             if (!contains(A, B[j])) {
412                 includeMap[A.length + j] = true;
413                 count++;
414             }
415         }
416         address[] memory newAddresses = new address[](count);
417         uint256 k = 0;
418         for (uint256 m = 0; m < A.length; m++) {
419             if (includeMap[m]) {
420                 newAddresses[k] = A[m];
421                 k++;
422             }
423         }
424         for (uint256 n = 0; n < B.length; n++) {
425             if (includeMap[A.length + n]) {
426                 newAddresses[k] = B[n];
427                 k++;
428             }
429         }
430         return newAddresses;
431     }
432 
433     /**
434      * Computes the difference of two arrays. Assumes there are no duplicates.
435      * @param A The first array
436      * @param B The second array
437      * @return The difference of the two arrays
438      */
439     function difference(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
440         uint256 length = A.length;
441         bool[] memory includeMap = new bool[](length);
442         uint256 count = 0;
443         // First count the new length because can't push for in-memory arrays
444         for (uint256 i = 0; i < length; i++) {
445             address e = A[i];
446             if (!contains(B, e)) {
447                 includeMap[i] = true;
448                 count++;
449             }
450         }
451         address[] memory newAddresses = new address[](count);
452         uint256 j = 0;
453         for (uint256 k = 0; k < length; k++) {
454             if (includeMap[k]) {
455                 newAddresses[j] = A[k];
456                 j++;
457             }
458         }
459         return newAddresses;
460     }
461 
462     /**
463     * @dev Reverses storage array in place
464     */
465     function sReverse(address[] storage A) internal {
466         address t;
467         uint256 length = A.length;
468         for (uint256 i = 0; i < length / 2; i++) {
469             t = A[i];
470             A[i] = A[A.length - i - 1];
471             A[A.length - i - 1] = t;
472         }
473     }
474 
475     /**
476     * Removes specified index from array
477     * Resulting ordering is not guaranteed
478     * @return Returns the new array and the removed entry
479     */
480     function pop(address[] memory A, uint256 index)
481         internal
482         pure
483         returns (address[] memory, address)
484     {
485         uint256 length = A.length;
486         address[] memory newAddresses = new address[](length - 1);
487         for (uint256 i = 0; i < index; i++) {
488             newAddresses[i] = A[i];
489         }
490         for (uint256 j = index + 1; j < length; j++) {
491             newAddresses[j - 1] = A[j];
492         }
493         return (newAddresses, A[index]);
494     }
495 
496     /**
497      * @return Returns the new array
498      */
499     function remove(address[] memory A, address a)
500         internal
501         pure
502         returns (address[] memory)
503     {
504         (uint256 index, bool isIn) = indexOf(A, a);
505         if (!isIn) {
506             revert();
507         } else {
508             (address[] memory _A,) = pop(A, index);
509             return _A;
510         }
511     }
512 
513     function sPop(address[] storage A, uint256 index) internal returns (address) {
514         uint256 length = A.length;
515         if (index >= length) {
516             revert("Error: index out of bounds");
517         }
518         address entry = A[index];
519         for (uint256 i = index; i < length - 1; i++) {
520             A[i] = A[i + 1];
521         }
522         A.length--;
523         return entry;
524     }
525 
526     /**
527     * Deletes address at index and fills the spot with the last address.
528     * Order is not preserved.
529     * @return Returns the removed entry
530     */
531     function sPopCheap(address[] storage A, uint256 index) internal returns (address) {
532         uint256 length = A.length;
533         if (index >= length) {
534             revert("Error: index out of bounds");
535         }
536         address entry = A[index];
537         if (index != length - 1) {
538             A[index] = A[length - 1];
539             delete A[length - 1];
540         }
541         A.length--;
542         return entry;
543     }
544 
545     /**
546      * Deletes address at index. Works by swapping it with the last address, then deleting.
547      * Order is not preserved
548      * @param A Storage array to remove from
549      */
550     function sRemoveCheap(address[] storage A, address a) internal {
551         (uint256 index, bool isIn) = indexOf(A, a);
552         if (!isIn) {
553             revert("Error: entry not found");
554         } else {
555             sPopCheap(A, index);
556             return;
557         }
558     }
559 
560     /**
561      * Returns whether or not there's a duplicate. Runs in O(n^2).
562      * @param A Array to search
563      * @return Returns true if duplicate, false otherwise
564      */
565     function hasDuplicate(address[] memory A) internal pure returns (bool) {
566         if (A.length == 0) {
567             return false;
568         }
569         for (uint256 i = 0; i < A.length - 1; i++) {
570             for (uint256 j = i + 1; j < A.length; j++) {
571                 if (A[i] == A[j]) {
572                     return true;
573                 }
574             }
575         }
576         return false;
577     }
578 
579     /**
580      * Returns whether the two arrays are equal.
581      * @param A The first array
582      * @param B The second array
583      * @return True is the arrays are equal, false if not.
584      */
585     function isEqual(address[] memory A, address[] memory B) internal pure returns (bool) {
586         if (A.length != B.length) {
587             return false;
588         }
589         for (uint256 i = 0; i < A.length; i++) {
590             if (A[i] != B[i]) {
591                 return false;
592             }
593         }
594         return true;
595     }
596 
597     /**
598      * Returns the elements indexed at indexArray.
599      * @param A The array to index
600      * @param indexArray The array to use to index
601      * @return Returns array containing elements indexed at indexArray
602      */
603     function argGet(address[] memory A, uint256[] memory indexArray)
604         internal
605         pure
606         returns (address[] memory)
607     {
608         address[] memory array = new address[](indexArray.length);
609         for (uint256 i = 0; i < indexArray.length; i++) {
610             array[i] = A[indexArray[i]];
611         }
612         return array;
613     }
614 
615 }
616 
617 // File: contracts/lib/Whitelist.sol
618 
619 /*
620     Copyright 2018 Set Labs Inc.
621 
622     Licensed under the Apache License, Version 2.0 (the "License");
623     you may not use this file except in compliance with the License.
624     You may obtain a copy of the License at
625 
626     http://www.apache.org/licenses/LICENSE-2.0
627 
628     Unless required by applicable law or agreed to in writing, software
629     distributed under the License is distributed on an "AS IS" BASIS,
630     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
631     See the License for the specific language governing permissions and
632     limitations under the License.
633 */
634 
635 pragma solidity 0.5.7;
636 
637 
638 
639 
640 
641 /**
642  * @title Whitelist
643  * @author Set Protocol
644  *
645  * Generic whitelist for addresses
646  */
647 contract WhiteList is
648     Ownable,
649     TimeLockUpgrade
650 {
651     using AddressArrayUtils for address[];
652 
653     /* ============ State Variables ============ */
654 
655     address[] public addresses;
656     mapping(address => bool) public whiteList;
657 
658     /* ============ Events ============ */
659 
660     event AddressAdded(
661         address _address
662     );
663 
664     event AddressRemoved(
665         address _address
666     );
667 
668     /* ============ Constructor ============ */
669 
670     /**
671      * Constructor function for Whitelist
672      *
673      * Allow initial addresses to be passed in so a separate transaction is not required for each
674      *
675      * @param _initialAddresses    Starting set of addresses to whitelist
676      */
677     constructor(
678         address[] memory _initialAddresses
679     )
680         public
681     {
682         // Add each of initial addresses to state
683         for (uint256 i = 0; i < _initialAddresses.length; i++) {
684             address addressToAdd = _initialAddresses[i];
685 
686             addresses.push(addressToAdd);
687             whiteList[addressToAdd] = true;
688         }
689     }
690 
691     /* ============ External Functions ============ */
692 
693     /**
694      * Add an address to the whitelist
695      *
696      * @param _address    Address to add to the whitelist
697      */
698     function addAddress(
699         address _address
700     )
701         external
702         onlyOwner
703         timeLockUpgrade
704     {
705         require(
706             !whiteList[_address],
707             "WhiteList.addAddress: Address has already been whitelisted."
708         );
709 
710         addresses.push(_address);
711 
712         whiteList[_address] = true;
713 
714         emit AddressAdded(
715             _address
716         );
717     }
718 
719     /**
720      * Remove an address from the whitelist
721      *
722      * @param _address    Address to remove from the whitelist
723      */
724     function removeAddress(
725         address _address
726     )
727         external
728         onlyOwner
729     {
730         require(
731             whiteList[_address],
732             "WhiteList.removeAddress: Address is not current whitelisted."
733         );
734 
735         addresses = addresses.remove(_address);
736 
737         whiteList[_address] = false;
738 
739         emit AddressRemoved(
740             _address
741         );
742     }
743 
744     /**
745      * Return array of all whitelisted addresses
746      *
747      * @return address[]      Array of addresses
748      */
749     function validAddresses()
750         external
751         view
752         returns (address[] memory)
753     {
754         return addresses;
755     }
756 
757     /**
758      * Verifies an array of addresses against the whitelist
759      *
760      * @param  _addresses    Array of addresses to verify
761      * @return bool          Whether all addresses in the list are whitelsited
762      */
763     function areValidAddresses(
764         address[] calldata _addresses
765     )
766         external
767         view
768         returns (bool)
769     {
770         for (uint256 i = 0; i < _addresses.length; i++) {
771             if (!whiteList[_addresses[i]]) {
772                 return false;
773             }
774         }
775 
776         return true;
777     }
778 }