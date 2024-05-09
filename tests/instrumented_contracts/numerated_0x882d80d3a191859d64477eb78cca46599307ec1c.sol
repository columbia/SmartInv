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
145 // File: contracts/lib/AddressArrayUtils.sol
146 
147 // Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
148 // https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol
149 
150 pragma solidity 0.5.7;
151 
152 
153 library AddressArrayUtils {
154 
155     /**
156      * Finds the index of the first occurrence of the given element.
157      * @param A The input array to search
158      * @param a The value to find
159      * @return Returns (index and isIn) for the first occurrence starting from index 0
160      */
161     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
162         uint256 length = A.length;
163         for (uint256 i = 0; i < length; i++) {
164             if (A[i] == a) {
165                 return (i, true);
166             }
167         }
168         return (0, false);
169     }
170 
171     /**
172     * Returns true if the value is present in the list. Uses indexOf internally.
173     * @param A The input array to search
174     * @param a The value to find
175     * @return Returns isIn for the first occurrence starting from index 0
176     */
177     function contains(address[] memory A, address a) internal pure returns (bool) {
178         bool isIn;
179         (, isIn) = indexOf(A, a);
180         return isIn;
181     }
182 
183     /// @return Returns index and isIn for the first occurrence starting from
184     /// end
185     function indexOfFromEnd(address[] memory A, address a) internal pure returns (uint256, bool) {
186         uint256 length = A.length;
187         for (uint256 i = length; i > 0; i--) {
188             if (A[i - 1] == a) {
189                 return (i, true);
190             }
191         }
192         return (0, false);
193     }
194 
195     /**
196      * Returns the combination of the two arrays
197      * @param A The first array
198      * @param B The second array
199      * @return Returns A extended by B
200      */
201     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
202         uint256 aLength = A.length;
203         uint256 bLength = B.length;
204         address[] memory newAddresses = new address[](aLength + bLength);
205         for (uint256 i = 0; i < aLength; i++) {
206             newAddresses[i] = A[i];
207         }
208         for (uint256 j = 0; j < bLength; j++) {
209             newAddresses[aLength + j] = B[j];
210         }
211         return newAddresses;
212     }
213 
214     /**
215      * Returns the array with a appended to A.
216      * @param A The first array
217      * @param a The value to append
218      * @return Returns A appended by a
219      */
220     function append(address[] memory A, address a) internal pure returns (address[] memory) {
221         address[] memory newAddresses = new address[](A.length + 1);
222         for (uint256 i = 0; i < A.length; i++) {
223             newAddresses[i] = A[i];
224         }
225         newAddresses[A.length] = a;
226         return newAddresses;
227     }
228 
229     /**
230      * Returns the combination of two storage arrays.
231      * @param A The first array
232      * @param B The second array
233      * @return Returns A appended by a
234      */
235     function sExtend(address[] storage A, address[] storage B) internal {
236         uint256 length = B.length;
237         for (uint256 i = 0; i < length; i++) {
238             A.push(B[i]);
239         }
240     }
241 
242     /**
243      * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
244      * @param A The first array
245      * @param B The second array
246      * @return The intersection of the two arrays
247      */
248     function intersect(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
249         uint256 length = A.length;
250         bool[] memory includeMap = new bool[](length);
251         uint256 newLength = 0;
252         for (uint256 i = 0; i < length; i++) {
253             if (contains(B, A[i])) {
254                 includeMap[i] = true;
255                 newLength++;
256             }
257         }
258         address[] memory newAddresses = new address[](newLength);
259         uint256 j = 0;
260         for (uint256 k = 0; k < length; k++) {
261             if (includeMap[k]) {
262                 newAddresses[j] = A[k];
263                 j++;
264             }
265         }
266         return newAddresses;
267     }
268 
269     /**
270      * Returns the union of the two arrays. Order is not guaranteed.
271      * @param A The first array
272      * @param B The second array
273      * @return The union of the two arrays
274      */
275     function union(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
276         address[] memory leftDifference = difference(A, B);
277         address[] memory rightDifference = difference(B, A);
278         address[] memory intersection = intersect(A, B);
279         return extend(leftDifference, extend(intersection, rightDifference));
280     }
281 
282     /**
283      * Alternate implementation
284      * Assumes there are no duplicates
285      */
286     function unionB(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
287         bool[] memory includeMap = new bool[](A.length + B.length);
288         uint256 count = 0;
289         for (uint256 i = 0; i < A.length; i++) {
290             includeMap[i] = true;
291             count++;
292         }
293         for (uint256 j = 0; j < B.length; j++) {
294             if (!contains(A, B[j])) {
295                 includeMap[A.length + j] = true;
296                 count++;
297             }
298         }
299         address[] memory newAddresses = new address[](count);
300         uint256 k = 0;
301         for (uint256 m = 0; m < A.length; m++) {
302             if (includeMap[m]) {
303                 newAddresses[k] = A[m];
304                 k++;
305             }
306         }
307         for (uint256 n = 0; n < B.length; n++) {
308             if (includeMap[A.length + n]) {
309                 newAddresses[k] = B[n];
310                 k++;
311             }
312         }
313         return newAddresses;
314     }
315 
316     /**
317      * Computes the difference of two arrays. Assumes there are no duplicates.
318      * @param A The first array
319      * @param B The second array
320      * @return The difference of the two arrays
321      */
322     function difference(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
323         uint256 length = A.length;
324         bool[] memory includeMap = new bool[](length);
325         uint256 count = 0;
326         // First count the new length because can't push for in-memory arrays
327         for (uint256 i = 0; i < length; i++) {
328             address e = A[i];
329             if (!contains(B, e)) {
330                 includeMap[i] = true;
331                 count++;
332             }
333         }
334         address[] memory newAddresses = new address[](count);
335         uint256 j = 0;
336         for (uint256 k = 0; k < length; k++) {
337             if (includeMap[k]) {
338                 newAddresses[j] = A[k];
339                 j++;
340             }
341         }
342         return newAddresses;
343     }
344 
345     /**
346     * @dev Reverses storage array in place
347     */
348     function sReverse(address[] storage A) internal {
349         address t;
350         uint256 length = A.length;
351         for (uint256 i = 0; i < length / 2; i++) {
352             t = A[i];
353             A[i] = A[A.length - i - 1];
354             A[A.length - i - 1] = t;
355         }
356     }
357 
358     /**
359     * Removes specified index from array
360     * Resulting ordering is not guaranteed
361     * @return Returns the new array and the removed entry
362     */
363     function pop(address[] memory A, uint256 index)
364         internal
365         pure
366         returns (address[] memory, address)
367     {
368         uint256 length = A.length;
369         address[] memory newAddresses = new address[](length - 1);
370         for (uint256 i = 0; i < index; i++) {
371             newAddresses[i] = A[i];
372         }
373         for (uint256 j = index + 1; j < length; j++) {
374             newAddresses[j - 1] = A[j];
375         }
376         return (newAddresses, A[index]);
377     }
378 
379     /**
380      * @return Returns the new array
381      */
382     function remove(address[] memory A, address a)
383         internal
384         pure
385         returns (address[] memory)
386     {
387         (uint256 index, bool isIn) = indexOf(A, a);
388         if (!isIn) {
389             revert();
390         } else {
391             (address[] memory _A,) = pop(A, index);
392             return _A;
393         }
394     }
395 
396     function sPop(address[] storage A, uint256 index) internal returns (address) {
397         uint256 length = A.length;
398         if (index >= length) {
399             revert("Error: index out of bounds");
400         }
401         address entry = A[index];
402         for (uint256 i = index; i < length - 1; i++) {
403             A[i] = A[i + 1];
404         }
405         A.length--;
406         return entry;
407     }
408 
409     /**
410     * Deletes address at index and fills the spot with the last address.
411     * Order is not preserved.
412     * @return Returns the removed entry
413     */
414     function sPopCheap(address[] storage A, uint256 index) internal returns (address) {
415         uint256 length = A.length;
416         if (index >= length) {
417             revert("Error: index out of bounds");
418         }
419         address entry = A[index];
420         if (index != length - 1) {
421             A[index] = A[length - 1];
422             delete A[length - 1];
423         }
424         A.length--;
425         return entry;
426     }
427 
428     /**
429      * Deletes address at index. Works by swapping it with the last address, then deleting.
430      * Order is not preserved
431      * @param A Storage array to remove from
432      */
433     function sRemoveCheap(address[] storage A, address a) internal {
434         (uint256 index, bool isIn) = indexOf(A, a);
435         if (!isIn) {
436             revert("Error: entry not found");
437         } else {
438             sPopCheap(A, index);
439             return;
440         }
441     }
442 
443     /**
444      * Returns whether or not there's a duplicate. Runs in O(n^2).
445      * @param A Array to search
446      * @return Returns true if duplicate, false otherwise
447      */
448     function hasDuplicate(address[] memory A) internal pure returns (bool) {
449         if (A.length == 0) {
450             return false;
451         }
452         for (uint256 i = 0; i < A.length - 1; i++) {
453             for (uint256 j = i + 1; j < A.length; j++) {
454                 if (A[i] == A[j]) {
455                     return true;
456                 }
457             }
458         }
459         return false;
460     }
461 
462     /**
463      * Returns whether the two arrays are equal.
464      * @param A The first array
465      * @param B The second array
466      * @return True is the arrays are equal, false if not.
467      */
468     function isEqual(address[] memory A, address[] memory B) internal pure returns (bool) {
469         if (A.length != B.length) {
470             return false;
471         }
472         for (uint256 i = 0; i < A.length; i++) {
473             if (A[i] != B[i]) {
474                 return false;
475             }
476         }
477         return true;
478     }
479 
480     /**
481      * Returns the elements indexed at indexArray.
482      * @param A The array to index
483      * @param indexArray The array to use to index
484      * @return Returns array containing elements indexed at indexArray
485      */
486     function argGet(address[] memory A, uint256[] memory indexArray)
487         internal
488         pure
489         returns (address[] memory)
490     {
491         address[] memory array = new address[](indexArray.length);
492         for (uint256 i = 0; i < indexArray.length; i++) {
493             array[i] = A[indexArray[i]];
494         }
495         return array;
496     }
497 
498 }
499 
500 // File: contracts/lib/TimeLockUpgrade.sol
501 
502 /*
503     Copyright 2018 Set Labs Inc.
504 
505     Licensed under the Apache License, Version 2.0 (the "License");
506     you may not use this file except in compliance with the License.
507     You may obtain a copy of the License at
508 
509     http://www.apache.org/licenses/LICENSE-2.0
510 
511     Unless required by applicable law or agreed to in writing, software
512     distributed under the License is distributed on an "AS IS" BASIS,
513     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
514     See the License for the specific language governing permissions and
515     limitations under the License.
516 */
517 
518 pragma solidity 0.5.7;
519 
520 
521 
522 
523 /**
524  * @title TimeLockUpgrade
525  * @author Set Protocol
526  *
527  * The TimeLockUpgrade contract contains a modifier for handling minimum time period updates
528  */
529 contract TimeLockUpgrade is
530     Ownable
531 {
532     using SafeMath for uint256;
533 
534     /* ============ State Variables ============ */
535 
536     // Timelock Upgrade Period in seconds
537     uint256 public timeLockPeriod;
538 
539     // Mapping of upgradable units and initialized timelock
540     mapping(bytes32 => uint256) public timeLockedUpgrades;
541 
542     /* ============ Events ============ */
543 
544     event UpgradeRegistered(
545         bytes32 _upgradeHash,
546         uint256 _timestamp
547     );
548 
549     /* ============ Modifiers ============ */
550 
551     modifier timeLockUpgrade() {
552         // If the time lock period is 0, then allow non-timebound upgrades.
553         // This is useful for initialization of the protocol and for testing.
554         if (timeLockPeriod == 0) {
555             _;
556 
557             return;
558         }
559 
560         // The upgrade hash is defined by the hash of the transaction call data,
561         // which uniquely identifies the function as well as the passed in arguments.
562         bytes32 upgradeHash = keccak256(
563             abi.encodePacked(
564                 msg.data
565             )
566         );
567 
568         uint256 registrationTime = timeLockedUpgrades[upgradeHash];
569 
570         // If the upgrade hasn't been registered, register with the current time.
571         if (registrationTime == 0) {
572             timeLockedUpgrades[upgradeHash] = block.timestamp;
573 
574             emit UpgradeRegistered(
575                 upgradeHash,
576                 block.timestamp
577             );
578 
579             return;
580         }
581 
582         require(
583             block.timestamp >= registrationTime.add(timeLockPeriod),
584             "TimeLockUpgrade: Time lock period must have elapsed."
585         );
586 
587         // Reset the timestamp to 0
588         timeLockedUpgrades[upgradeHash] = 0;
589 
590         // Run the rest of the upgrades
591         _;
592     }
593 
594     /* ============ Function ============ */
595 
596     /**
597      * Change timeLockPeriod period. Generally called after initially settings have been set up.
598      *
599      * @param  _timeLockPeriod   Time in seconds that upgrades need to be evaluated before execution
600      */
601     function setTimeLockPeriod(
602         uint256 _timeLockPeriod
603     )
604         external
605         onlyOwner
606     {
607         // Only allow setting of the timeLockPeriod if the period is greater than the existing
608         require(
609             _timeLockPeriod > timeLockPeriod,
610             "TimeLockUpgrade: New period must be greater than existing"
611         );
612 
613         timeLockPeriod = _timeLockPeriod;
614     }
615 }
616 
617 // File: contracts/lib/Authorizable.sol
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
641 
642 /**
643  * @title Authorizable
644  * @author Set Protocol
645  *
646  * The Authorizable contract is an inherited contract that sets permissions on certain function calls
647  * through the onlyAuthorized modifier. Permissions can be managed only by the Owner of the contract.
648  */
649 contract Authorizable is
650     Ownable,
651     TimeLockUpgrade
652 {
653     using SafeMath for uint256;
654     using AddressArrayUtils for address[];
655 
656     /* ============ State Variables ============ */
657 
658     // Mapping of addresses to bool indicator of authorization
659     mapping (address => bool) public authorized;
660 
661     // Array of authorized addresses
662     address[] public authorities;
663 
664     /* ============ Modifiers ============ */
665 
666     // Only authorized addresses can invoke functions with this modifier.
667     modifier onlyAuthorized {
668         require(
669             authorized[msg.sender],
670             "Authorizable.onlyAuthorized: Sender not included in authorities"
671         );
672         _;
673     }
674 
675     /* ============ Events ============ */
676 
677     // Event emitted when new address is authorized.
678     event AddressAuthorized (
679         address indexed authAddress,
680         address authorizedBy
681     );
682 
683     // Event emitted when address is deauthorized.
684     event AuthorizedAddressRemoved (
685         address indexed addressRemoved,
686         address authorizedBy
687     );
688 
689     /* ============ Setters ============ */
690 
691     /**
692      * Add authorized address to contract. Can only be set by owner.
693      *
694      * @param  _authTarget   The address of the new authorized contract
695      */
696 
697     function addAuthorizedAddress(address _authTarget)
698         external
699         onlyOwner
700         timeLockUpgrade
701     {
702         // Require that address is not already authorized
703         require(
704             !authorized[_authTarget],
705             "Authorizable.addAuthorizedAddress: Address already registered"
706         );
707 
708         // Set address authority to true
709         authorized[_authTarget] = true;
710 
711         // Add address to authorities array
712         authorities.push(_authTarget);
713 
714         // Emit authorized address event
715         emit AddressAuthorized(
716             _authTarget,
717             msg.sender
718         );
719     }
720 
721     /**
722      * Remove authorized address from contract. Can only be set by owner.
723      *
724      * @param  _authTarget   The address to be de-permissioned
725      */
726 
727     function removeAuthorizedAddress(address _authTarget)
728         external
729         onlyOwner
730     {
731         // Require address is authorized
732         require(
733             authorized[_authTarget],
734             "Authorizable.removeAuthorizedAddress: Address not authorized"
735         );
736 
737         // Delete address from authorized mapping
738         authorized[_authTarget] = false;
739 
740         authorities = authorities.remove(_authTarget);
741 
742         // Emit AuthorizedAddressRemoved event.
743         emit AuthorizedAddressRemoved(
744             _authTarget,
745             msg.sender
746         );
747     }
748 
749     /* ============ Getters ============ */
750 
751     /**
752      * Get array of authorized addresses.
753      *
754      * @return address[]   Array of authorized addresses
755      */
756     function getAuthorizedAddresses()
757         external
758         view
759         returns (address[] memory)
760     {
761         // Return array of authorized addresses
762         return authorities;
763     }
764 }
765 
766 // File: contracts/lib/CommonMath.sol
767 
768 /*
769     Copyright 2018 Set Labs Inc.
770 
771     Licensed under the Apache License, Version 2.0 (the "License");
772     you may not use this file except in compliance with the License.
773     You may obtain a copy of the License at
774 
775     http://www.apache.org/licenses/LICENSE-2.0
776 
777     Unless required by applicable law or agreed to in writing, software
778     distributed under the License is distributed on an "AS IS" BASIS,
779     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
780     See the License for the specific language governing permissions and
781     limitations under the License.
782 */
783 
784 pragma solidity 0.5.7;
785 
786 
787 
788 library CommonMath {
789     using SafeMath for uint256;
790 
791     /**
792      * Calculates and returns the maximum value for a uint256
793      *
794      * @return  The maximum value for uint256
795      */
796     function maxUInt256()
797         internal
798         pure
799         returns (uint256)
800     {
801         return 2 ** 256 - 1;
802     }
803 
804     /**
805     * @dev Performs the power on a specified value, reverts on overflow.
806     */
807     function safePower(
808         uint256 a,
809         uint256 pow
810     )
811         internal
812         pure
813         returns (uint256)
814     {
815         require(a > 0);
816 
817         uint256 result = 1;
818         for (uint256 i = 0; i < pow; i++){
819             uint256 previousResult = result;
820 
821             // Using safemath multiplication prevents overflows
822             result = previousResult.mul(a);
823         }
824 
825         return result;
826     }
827 
828     /**
829      * Checks for rounding errors and returns value of potential partial amounts of a principal
830      *
831      * @param  _principal       Number fractional amount is derived from
832      * @param  _numerator       Numerator of fraction
833      * @param  _denominator     Denominator of fraction
834      * @return uint256          Fractional amount of principal calculated
835      */
836     function getPartialAmount(
837         uint256 _principal,
838         uint256 _numerator,
839         uint256 _denominator
840     )
841         internal
842         pure
843         returns (uint256)
844     {
845         // Get remainder of partial amount (if 0 not a partial amount)
846         uint256 remainder = mulmod(_principal, _numerator, _denominator);
847 
848         // Return if not a partial amount
849         if (remainder == 0) {
850             return _principal.mul(_numerator).div(_denominator);
851         }
852 
853         // Calculate error percentage
854         uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));
855 
856         // Require error percentage is less than 0.1%.
857         require(
858             errPercentageTimes1000000 < 1000,
859             "CommonMath.getPartialAmount: Rounding error exceeds bounds"
860         );
861 
862         return _principal.mul(_numerator).div(_denominator);
863     }
864 
865 }
866 
867 // File: contracts/lib/IERC20.sol
868 
869 /*
870     Copyright 2018 Set Labs Inc.
871 
872     Licensed under the Apache License, Version 2.0 (the "License");
873     you may not use this file except in compliance with the License.
874     You may obtain a copy of the License at
875 
876     http://www.apache.org/licenses/LICENSE-2.0
877 
878     Unless required by applicable law or agreed to in writing, software
879     distributed under the License is distributed on an "AS IS" BASIS,
880     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
881     See the License for the specific language governing permissions and
882     limitations under the License.
883 */
884 
885 pragma solidity 0.5.7;
886 
887 
888 /**
889  * @title IERC20
890  * @author Set Protocol
891  *
892  * Interface for using ERC20 Tokens. This interface is needed to interact with tokens that are not
893  * fully ERC20 compliant and return something other than true on successful transfers.
894  */
895 interface IERC20 {
896     function balanceOf(
897         address _owner
898     )
899         external
900         view
901         returns (uint256);
902 
903     function allowance(
904         address _owner,
905         address _spender
906     )
907         external
908         view
909         returns (uint256);
910 
911     function transfer(
912         address _to,
913         uint256 _quantity
914     )
915         external;
916 
917     function transferFrom(
918         address _from,
919         address _to,
920         uint256 _quantity
921     )
922         external;
923 
924     function approve(
925         address _spender,
926         uint256 _quantity
927     )
928         external
929         returns (bool);
930 }
931 
932 // File: contracts/lib/ERC20Wrapper.sol
933 
934 /*
935     Copyright 2018 Set Labs Inc.
936 
937     Licensed under the Apache License, Version 2.0 (the "License");
938     you may not use this file except in compliance with the License.
939     You may obtain a copy of the License at
940 
941     http://www.apache.org/licenses/LICENSE-2.0
942 
943     Unless required by applicable law or agreed to in writing, software
944     distributed under the License is distributed on an "AS IS" BASIS,
945     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
946     See the License for the specific language governing permissions and
947     limitations under the License.
948 */
949 
950 pragma solidity 0.5.7;
951 
952 
953 
954 
955 /**
956  * @title ERC20Wrapper
957  * @author Set Protocol
958  *
959  * This library contains functions for interacting wtih ERC20 tokens, even those not fully compliant.
960  * For all functions we will only accept tokens that return a null or true value, any other values will
961  * cause the operation to revert.
962  */
963 library ERC20Wrapper {
964 
965     // ============ Internal Functions ============
966 
967     /**
968      * Check balance owner's balance of ERC20 token
969      *
970      * @param  _token          The address of the ERC20 token
971      * @param  _owner          The owner who's balance is being checked
972      * @return  uint256        The _owner's amount of tokens
973      */
974     function balanceOf(
975         address _token,
976         address _owner
977     )
978         external
979         view
980         returns (uint256)
981     {
982         return IERC20(_token).balanceOf(_owner);
983     }
984 
985     /**
986      * Checks spender's allowance to use token's on owner's behalf.
987      *
988      * @param  _token          The address of the ERC20 token
989      * @param  _owner          The token owner address
990      * @param  _spender        The address the allowance is being checked on
991      * @return  uint256        The spender's allowance on behalf of owner
992      */
993     function allowance(
994         address _token,
995         address _owner,
996         address _spender
997     )
998         internal
999         view
1000         returns (uint256)
1001     {
1002         return IERC20(_token).allowance(_owner, _spender);
1003     }
1004 
1005     /**
1006      * Transfers tokens from an address. Handle's tokens that return true or null.
1007      * If other value returned, reverts.
1008      *
1009      * @param  _token          The address of the ERC20 token
1010      * @param  _to             The address to transfer to
1011      * @param  _quantity       The amount of tokens to transfer
1012      */
1013     function transfer(
1014         address _token,
1015         address _to,
1016         uint256 _quantity
1017     )
1018         external
1019     {
1020         IERC20(_token).transfer(_to, _quantity);
1021 
1022         // Check that transfer returns true or null
1023         require(
1024             checkSuccess(),
1025             "ERC20Wrapper.transfer: Bad return value"
1026         );
1027     }
1028 
1029     /**
1030      * Transfers tokens from an address (that has set allowance on the proxy).
1031      * Handle's tokens that return true or null. If other value returned, reverts.
1032      *
1033      * @param  _token          The address of the ERC20 token
1034      * @param  _from           The address to transfer from
1035      * @param  _to             The address to transfer to
1036      * @param  _quantity       The number of tokens to transfer
1037      */
1038     function transferFrom(
1039         address _token,
1040         address _from,
1041         address _to,
1042         uint256 _quantity
1043     )
1044         external
1045     {
1046         IERC20(_token).transferFrom(_from, _to, _quantity);
1047 
1048         // Check that transferFrom returns true or null
1049         require(
1050             checkSuccess(),
1051             "ERC20Wrapper.transferFrom: Bad return value"
1052         );
1053     }
1054 
1055     /**
1056      * Grants spender ability to spend on owner's behalf.
1057      * Handle's tokens that return true or null. If other value returned, reverts.
1058      *
1059      * @param  _token          The address of the ERC20 token
1060      * @param  _spender        The address to approve for transfer
1061      * @param  _quantity       The amount of tokens to approve spender for
1062      */
1063     function approve(
1064         address _token,
1065         address _spender,
1066         uint256 _quantity
1067     )
1068         internal
1069     {
1070         IERC20(_token).approve(_spender, _quantity);
1071 
1072         // Check that approve returns true or null
1073         require(
1074             checkSuccess(),
1075             "ERC20Wrapper.approve: Bad return value"
1076         );
1077     }
1078 
1079     /**
1080      * Ensure's the owner has granted enough allowance for system to
1081      * transfer tokens.
1082      *
1083      * @param  _token          The address of the ERC20 token
1084      * @param  _owner          The address of the token owner
1085      * @param  _spender        The address to grant/check allowance for
1086      * @param  _quantity       The amount to see if allowed for
1087      */
1088     function ensureAllowance(
1089         address _token,
1090         address _owner,
1091         address _spender,
1092         uint256 _quantity
1093     )
1094         internal
1095     {
1096         uint256 currentAllowance = allowance(_token, _owner, _spender);
1097         if (currentAllowance < _quantity) {
1098             approve(
1099                 _token,
1100                 _spender,
1101                 CommonMath.maxUInt256()
1102             );
1103         }
1104     }
1105 
1106     // ============ Private Functions ============
1107 
1108     /**
1109      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
1110      * function returned 0 bytes or 1.
1111      */
1112     function checkSuccess(
1113     )
1114         private
1115         pure
1116         returns (bool)
1117     {
1118         // default to failure
1119         uint256 returnValue = 0;
1120 
1121         assembly {
1122             // check number of bytes returned from last function call
1123             switch returndatasize
1124 
1125             // no bytes returned: assume success
1126             case 0x0 {
1127                 returnValue := 1
1128             }
1129 
1130             // 32 bytes returned
1131             case 0x20 {
1132                 // copy 32 bytes into scratch space
1133                 returndatacopy(0x0, 0x0, 0x20)
1134 
1135                 // load those bytes into returnValue
1136                 returnValue := mload(0x0)
1137             }
1138 
1139             // not sure what was returned: dont mark as success
1140             default { }
1141         }
1142 
1143         // check if returned value is one or nothing
1144         return returnValue == 1;
1145     }
1146 }
1147 
1148 // File: contracts/core/TransferProxy.sol
1149 
1150 /*
1151     Copyright 2018 Set Labs Inc.
1152 
1153     Licensed under the Apache License, Version 2.0 (the "License");
1154     you may not use this file except in compliance with the License.
1155     You may obtain a copy of the License at
1156 
1157     http://www.apache.org/licenses/LICENSE-2.0
1158 
1159     Unless required by applicable law or agreed to in writing, software
1160     distributed under the License is distributed on an "AS IS" BASIS,
1161     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1162     See the License for the specific language governing permissions and
1163     limitations under the License.
1164 */
1165 
1166 pragma solidity 0.5.7;
1167 
1168 
1169 
1170 
1171 
1172 /**
1173  * @title TransferProxy
1174  * @author Set Protocol
1175  *
1176  * The transferProxy contract is responsible for moving tokens through the system to
1177  * assist with issuance and usage from modules.
1178  */
1179 
1180 contract TransferProxy is
1181     Authorizable
1182 {
1183     using SafeMath for uint256;
1184 
1185     /* ============ External Functions ============ */
1186 
1187     /**
1188      * Transfers tokens from an address (that has set allowance on the proxy).
1189      * Can only be called by Core.
1190      *
1191      * @param  _token          The address of the ERC20 token
1192      * @param  _quantity       The number of tokens to transfer
1193      * @param  _from           The address to transfer from
1194      * @param  _to             The address to transfer to
1195      */
1196     function transfer(
1197         address _token,
1198         uint256 _quantity,
1199         address _from,
1200         address _to
1201     )
1202         public
1203         onlyAuthorized
1204     {
1205         // Call specified ERC20 contract to transfer tokens (via proxy).
1206         if (_quantity > 0) {
1207             // Retrieve current balance of token for the receiver
1208             uint256 existingBalance = ERC20Wrapper.balanceOf(
1209                 _token,
1210                 _to
1211             );
1212 
1213             ERC20Wrapper.transferFrom(
1214                 _token,
1215                 _from,
1216                 _to,
1217                 _quantity
1218             );
1219 
1220             // Get new balance of transferred token for receiver
1221             uint256 newBalance = ERC20Wrapper.balanceOf(
1222                 _token,
1223                 _to
1224             );
1225 
1226             // Verify transfer quantity is reflected in balance
1227             require(
1228                 newBalance == existingBalance.add(_quantity),
1229                 "TransferProxy.transfer: Invalid post transfer balance"
1230             );
1231         }
1232     }
1233 
1234     /**
1235      * Transfers tokens from an address (that has set allowance on the proxy).
1236      * Can only be called by Core.
1237      *
1238      * @param  _tokens         The addresses of the ERC20 token
1239      * @param  _quantities     The numbers of tokens to transfer
1240      * @param  _from           The address to transfer from
1241      * @param  _to             The address to transfer to
1242      */
1243     function batchTransfer(
1244         address[] calldata _tokens,
1245         uint256[] calldata _quantities,
1246         address _from,
1247         address _to
1248     )
1249         external
1250         onlyAuthorized
1251     {
1252         // Storing token count to local variable to save on invocation
1253         uint256 tokenCount = _tokens.length;
1254 
1255         // Confirm and empty _tokens array is not passed
1256         require(
1257             tokenCount > 0,
1258             "TransferProxy.batchTransfer: Tokens must not be empty"
1259         );
1260 
1261         // Confirm there is one quantity for every token address
1262         require(
1263             tokenCount == _quantities.length,
1264             "TransferProxy.batchTransfer: Tokens and quantities lengths mismatch"
1265         );
1266 
1267         for (uint256 i = 0; i < tokenCount; i++) {
1268             if (_quantities[i] > 0) {
1269                 transfer(
1270                     _tokens[i],
1271                     _quantities[i],
1272                     _from,
1273                     _to
1274                 );
1275             }
1276         }
1277     }
1278 
1279 }