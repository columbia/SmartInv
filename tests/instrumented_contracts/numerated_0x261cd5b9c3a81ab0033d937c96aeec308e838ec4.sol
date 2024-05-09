1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-26
3 */
4 
5 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
6 
7 pragma solidity ^0.5.2;
8 
9 /**
10  * @title Helps contracts guard against reentrancy attacks.
11  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
12  * @dev If you mark a function `nonReentrant`, you should also
13  * mark it `external`.
14  */
15 contract ReentrancyGuard {
16     /// @dev counter to allow mutex lock with only one SSTORE operation
17     uint256 private _guardCounter;
18 
19     constructor () internal {
20         // The counter starts at one to prevent changing it from zero to a non-zero
21         // value, which is a more expensive operation.
22         _guardCounter = 1;
23     }
24 
25     /**
26      * @dev Prevents a contract from calling itself, directly or indirectly.
27      * Calling a `nonReentrant` function from another `nonReentrant`
28      * function is not supported. It is possible to prevent this from happening
29      * by making the `nonReentrant` function external, and make it call a
30      * `private` function that does the actual work.
31      */
32     modifier nonReentrant() {
33         _guardCounter += 1;
34         uint256 localCounter = _guardCounter;
35         _;
36         require(localCounter == _guardCounter);
37     }
38 }
39 
40 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
41 
42 pragma solidity ^0.5.2;
43 
44 /**
45  * @title SafeMath
46  * @dev Unsigned math operations with safety checks that revert on error
47  */
48 library SafeMath {
49     /**
50      * @dev Multiplies two unsigned integers, reverts on overflow.
51      */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b);
62 
63         return c;
64     }
65 
66     /**
67      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
68      */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         // Solidity only automatically asserts when dividing by 0
71         require(b > 0);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     /**
79      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b <= a);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Adds two unsigned integers, reverts on overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a);
94 
95         return c;
96     }
97 
98     /**
99      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
100      * reverts when dividing by zero.
101      */
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b != 0);
104         return a % b;
105     }
106 }
107 
108 // File: contracts/lib/CommonMath.sol
109 
110 /*
111     Copyright 2018 Set Labs Inc.
112 
113     Licensed under the Apache License, Version 2.0 (the "License");
114     you may not use this file except in compliance with the License.
115     You may obtain a copy of the License at
116 
117     http://www.apache.org/licenses/LICENSE-2.0
118 
119     Unless required by applicable law or agreed to in writing, software
120     distributed under the License is distributed on an "AS IS" BASIS,
121     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
122     See the License for the specific language governing permissions and
123     limitations under the License.
124 */
125 
126 pragma solidity 0.5.7;
127 
128 
129 
130 library CommonMath {
131     using SafeMath for uint256;
132 
133     /**
134      * Calculates and returns the maximum value for a uint256
135      *
136      * @return  The maximum value for uint256
137      */
138     function maxUInt256()
139         internal
140         pure
141         returns (uint256)
142     {
143         return 2 ** 256 - 1;
144     }
145 
146     /**
147     * @dev Performs the power on a specified value, reverts on overflow.
148     */
149     function safePower(
150         uint256 a,
151         uint256 pow
152     )
153         internal
154         pure
155         returns (uint256)
156     {
157         require(a > 0);
158 
159         uint256 result = 1;
160         for (uint256 i = 0; i < pow; i++){
161             uint256 previousResult = result;
162 
163             // Using safemath multiplication prevents overflows
164             result = previousResult.mul(a);
165         }
166 
167         return result;
168     }
169 
170     /**
171      * Checks for rounding errors and returns value of potential partial amounts of a principal
172      *
173      * @param  _principal       Number fractional amount is derived from
174      * @param  _numerator       Numerator of fraction
175      * @param  _denominator     Denominator of fraction
176      * @return uint256          Fractional amount of principal calculated
177      */
178     function getPartialAmount(
179         uint256 _principal,
180         uint256 _numerator,
181         uint256 _denominator
182     )
183         internal
184         pure
185         returns (uint256)
186     {
187         // Get remainder of partial amount (if 0 not a partial amount)
188         uint256 remainder = mulmod(_principal, _numerator, _denominator);
189 
190         // Return if not a partial amount
191         if (remainder == 0) {
192             return _principal.mul(_numerator).div(_denominator);
193         }
194 
195         // Calculate error percentage
196         uint256 errPercentageTimes1000000 = remainder.mul(1000000).div(_numerator.mul(_principal));
197 
198         // Require error percentage is less than 0.1%.
199         require(
200             errPercentageTimes1000000 < 1000,
201             "CommonMath.getPartialAmount: Rounding error exceeds bounds"
202         );
203 
204         return _principal.mul(_numerator).div(_denominator);
205     }
206 
207 }
208 
209 // File: contracts/lib/AddressArrayUtils.sol
210 
211 // Pulled in from Cryptofin Solidity package in order to control Solidity compiler version
212 // https://github.com/cryptofinlabs/cryptofin-solidity/blob/master/contracts/array-utils/AddressArrayUtils.sol
213 
214 pragma solidity 0.5.7;
215 
216 
217 library AddressArrayUtils {
218 
219     /**
220      * Finds the index of the first occurrence of the given element.
221      * @param A The input array to search
222      * @param a The value to find
223      * @return Returns (index and isIn) for the first occurrence starting from index 0
224      */
225     function indexOf(address[] memory A, address a) internal pure returns (uint256, bool) {
226         uint256 length = A.length;
227         for (uint256 i = 0; i < length; i++) {
228             if (A[i] == a) {
229                 return (i, true);
230             }
231         }
232         return (0, false);
233     }
234 
235     /**
236     * Returns true if the value is present in the list. Uses indexOf internally.
237     * @param A The input array to search
238     * @param a The value to find
239     * @return Returns isIn for the first occurrence starting from index 0
240     */
241     function contains(address[] memory A, address a) internal pure returns (bool) {
242         bool isIn;
243         (, isIn) = indexOf(A, a);
244         return isIn;
245     }
246 
247     /// @return Returns index and isIn for the first occurrence starting from
248     /// end
249     function indexOfFromEnd(address[] memory A, address a) internal pure returns (uint256, bool) {
250         uint256 length = A.length;
251         for (uint256 i = length; i > 0; i--) {
252             if (A[i - 1] == a) {
253                 return (i, true);
254             }
255         }
256         return (0, false);
257     }
258 
259     /**
260      * Returns the combination of the two arrays
261      * @param A The first array
262      * @param B The second array
263      * @return Returns A extended by B
264      */
265     function extend(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
266         uint256 aLength = A.length;
267         uint256 bLength = B.length;
268         address[] memory newAddresses = new address[](aLength + bLength);
269         for (uint256 i = 0; i < aLength; i++) {
270             newAddresses[i] = A[i];
271         }
272         for (uint256 j = 0; j < bLength; j++) {
273             newAddresses[aLength + j] = B[j];
274         }
275         return newAddresses;
276     }
277 
278     /**
279      * Returns the array with a appended to A.
280      * @param A The first array
281      * @param a The value to append
282      * @return Returns A appended by a
283      */
284     function append(address[] memory A, address a) internal pure returns (address[] memory) {
285         address[] memory newAddresses = new address[](A.length + 1);
286         for (uint256 i = 0; i < A.length; i++) {
287             newAddresses[i] = A[i];
288         }
289         newAddresses[A.length] = a;
290         return newAddresses;
291     }
292 
293     /**
294      * Returns the combination of two storage arrays.
295      * @param A The first array
296      * @param B The second array
297      * @return Returns A appended by a
298      */
299     function sExtend(address[] storage A, address[] storage B) internal {
300         uint256 length = B.length;
301         for (uint256 i = 0; i < length; i++) {
302             A.push(B[i]);
303         }
304     }
305 
306     /**
307      * Returns the intersection of two arrays. Arrays are treated as collections, so duplicates are kept.
308      * @param A The first array
309      * @param B The second array
310      * @return The intersection of the two arrays
311      */
312     function intersect(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
313         uint256 length = A.length;
314         bool[] memory includeMap = new bool[](length);
315         uint256 newLength = 0;
316         for (uint256 i = 0; i < length; i++) {
317             if (contains(B, A[i])) {
318                 includeMap[i] = true;
319                 newLength++;
320             }
321         }
322         address[] memory newAddresses = new address[](newLength);
323         uint256 j = 0;
324         for (uint256 k = 0; k < length; k++) {
325             if (includeMap[k]) {
326                 newAddresses[j] = A[k];
327                 j++;
328             }
329         }
330         return newAddresses;
331     }
332 
333     /**
334      * Returns the union of the two arrays. Order is not guaranteed.
335      * @param A The first array
336      * @param B The second array
337      * @return The union of the two arrays
338      */
339     function union(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
340         address[] memory leftDifference = difference(A, B);
341         address[] memory rightDifference = difference(B, A);
342         address[] memory intersection = intersect(A, B);
343         return extend(leftDifference, extend(intersection, rightDifference));
344     }
345 
346     /**
347      * Alternate implementation
348      * Assumes there are no duplicates
349      */
350     function unionB(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
351         bool[] memory includeMap = new bool[](A.length + B.length);
352         uint256 count = 0;
353         for (uint256 i = 0; i < A.length; i++) {
354             includeMap[i] = true;
355             count++;
356         }
357         for (uint256 j = 0; j < B.length; j++) {
358             if (!contains(A, B[j])) {
359                 includeMap[A.length + j] = true;
360                 count++;
361             }
362         }
363         address[] memory newAddresses = new address[](count);
364         uint256 k = 0;
365         for (uint256 m = 0; m < A.length; m++) {
366             if (includeMap[m]) {
367                 newAddresses[k] = A[m];
368                 k++;
369             }
370         }
371         for (uint256 n = 0; n < B.length; n++) {
372             if (includeMap[A.length + n]) {
373                 newAddresses[k] = B[n];
374                 k++;
375             }
376         }
377         return newAddresses;
378     }
379 
380     /**
381      * Computes the difference of two arrays. Assumes there are no duplicates.
382      * @param A The first array
383      * @param B The second array
384      * @return The difference of the two arrays
385      */
386     function difference(address[] memory A, address[] memory B) internal pure returns (address[] memory) {
387         uint256 length = A.length;
388         bool[] memory includeMap = new bool[](length);
389         uint256 count = 0;
390         // First count the new length because can't push for in-memory arrays
391         for (uint256 i = 0; i < length; i++) {
392             address e = A[i];
393             if (!contains(B, e)) {
394                 includeMap[i] = true;
395                 count++;
396             }
397         }
398         address[] memory newAddresses = new address[](count);
399         uint256 j = 0;
400         for (uint256 k = 0; k < length; k++) {
401             if (includeMap[k]) {
402                 newAddresses[j] = A[k];
403                 j++;
404             }
405         }
406         return newAddresses;
407     }
408 
409     /**
410     * @dev Reverses storage array in place
411     */
412     function sReverse(address[] storage A) internal {
413         address t;
414         uint256 length = A.length;
415         for (uint256 i = 0; i < length / 2; i++) {
416             t = A[i];
417             A[i] = A[A.length - i - 1];
418             A[A.length - i - 1] = t;
419         }
420     }
421 
422     /**
423     * Removes specified index from array
424     * Resulting ordering is not guaranteed
425     * @return Returns the new array and the removed entry
426     */
427     function pop(address[] memory A, uint256 index)
428         internal
429         pure
430         returns (address[] memory, address)
431     {
432         uint256 length = A.length;
433         address[] memory newAddresses = new address[](length - 1);
434         for (uint256 i = 0; i < index; i++) {
435             newAddresses[i] = A[i];
436         }
437         for (uint256 j = index + 1; j < length; j++) {
438             newAddresses[j - 1] = A[j];
439         }
440         return (newAddresses, A[index]);
441     }
442 
443     /**
444      * @return Returns the new array
445      */
446     function remove(address[] memory A, address a)
447         internal
448         pure
449         returns (address[] memory)
450     {
451         (uint256 index, bool isIn) = indexOf(A, a);
452         if (!isIn) {
453             revert();
454         } else {
455             (address[] memory _A,) = pop(A, index);
456             return _A;
457         }
458     }
459 
460     function sPop(address[] storage A, uint256 index) internal returns (address) {
461         uint256 length = A.length;
462         if (index >= length) {
463             revert("Error: index out of bounds");
464         }
465         address entry = A[index];
466         for (uint256 i = index; i < length - 1; i++) {
467             A[i] = A[i + 1];
468         }
469         A.length--;
470         return entry;
471     }
472 
473     /**
474     * Deletes address at index and fills the spot with the last address.
475     * Order is not preserved.
476     * @return Returns the removed entry
477     */
478     function sPopCheap(address[] storage A, uint256 index) internal returns (address) {
479         uint256 length = A.length;
480         if (index >= length) {
481             revert("Error: index out of bounds");
482         }
483         address entry = A[index];
484         if (index != length - 1) {
485             A[index] = A[length - 1];
486             delete A[length - 1];
487         }
488         A.length--;
489         return entry;
490     }
491 
492     /**
493      * Deletes address at index. Works by swapping it with the last address, then deleting.
494      * Order is not preserved
495      * @param A Storage array to remove from
496      */
497     function sRemoveCheap(address[] storage A, address a) internal {
498         (uint256 index, bool isIn) = indexOf(A, a);
499         if (!isIn) {
500             revert("Error: entry not found");
501         } else {
502             sPopCheap(A, index);
503             return;
504         }
505     }
506 
507     /**
508      * Returns whether or not there's a duplicate. Runs in O(n^2).
509      * @param A Array to search
510      * @return Returns true if duplicate, false otherwise
511      */
512     function hasDuplicate(address[] memory A) internal pure returns (bool) {
513         if (A.length == 0) {
514             return false;
515         }
516         for (uint256 i = 0; i < A.length - 1; i++) {
517             for (uint256 j = i + 1; j < A.length; j++) {
518                 if (A[i] == A[j]) {
519                     return true;
520                 }
521             }
522         }
523         return false;
524     }
525 
526     /**
527      * Returns whether the two arrays are equal.
528      * @param A The first array
529      * @param B The second array
530      * @return True is the arrays are equal, false if not.
531      */
532     function isEqual(address[] memory A, address[] memory B) internal pure returns (bool) {
533         if (A.length != B.length) {
534             return false;
535         }
536         for (uint256 i = 0; i < A.length; i++) {
537             if (A[i] != B[i]) {
538                 return false;
539             }
540         }
541         return true;
542     }
543 
544     /**
545      * Returns the elements indexed at indexArray.
546      * @param A The array to index
547      * @param indexArray The array to use to index
548      * @return Returns array containing elements indexed at indexArray
549      */
550     function argGet(address[] memory A, uint256[] memory indexArray)
551         internal
552         pure
553         returns (address[] memory)
554     {
555         address[] memory array = new address[](indexArray.length);
556         for (uint256 i = 0; i < indexArray.length; i++) {
557             array[i] = A[indexArray[i]];
558         }
559         return array;
560     }
561 
562 }
563 
564 // File: contracts/core/interfaces/ICore.sol
565 
566 /*
567     Copyright 2018 Set Labs Inc.
568 
569     Licensed under the Apache License, Version 2.0 (the "License");
570     you may not use this file except in compliance with the License.
571     You may obtain a copy of the License at
572 
573     http://www.apache.org/licenses/LICENSE-2.0
574 
575     Unless required by applicable law or agreed to in writing, software
576     distributed under the License is distributed on an "AS IS" BASIS,
577     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
578     See the License for the specific language governing permissions and
579     limitations under the License.
580 */
581 
582 pragma solidity 0.5.7;
583 
584 
585 /**
586  * @title ICore
587  * @author Set Protocol
588  *
589  * The ICore Contract defines all the functions exposed in the Core through its
590  * various extensions and is a light weight way to interact with the contract.
591  */
592 interface ICore {
593     /**
594      * Return transferProxy address.
595      *
596      * @return address       transferProxy address
597      */
598     function transferProxy()
599         external
600         view
601         returns (address);
602 
603     /**
604      * Return vault address.
605      *
606      * @return address       vault address
607      */
608     function vault()
609         external
610         view
611         returns (address);
612 
613     /**
614      * Return address belonging to given exchangeId.
615      *
616      * @param  _exchangeId       ExchangeId number
617      * @return address           Address belonging to given exchangeId
618      */
619     function exchangeIds(
620         uint8 _exchangeId
621     )
622         external
623         view
624         returns (address);
625 
626     /*
627      * Returns if valid set
628      *
629      * @return  bool      Returns true if Set created through Core and isn't disabled
630      */
631     function validSets(address)
632         external
633         view
634         returns (bool);
635 
636     /*
637      * Returns if valid module
638      *
639      * @return  bool      Returns true if valid module
640      */
641     function validModules(address)
642         external
643         view
644         returns (bool);
645 
646     /**
647      * Return boolean indicating if address is a valid Rebalancing Price Library.
648      *
649      * @param  _priceLibrary    Price library address
650      * @return bool             Boolean indicating if valid Price Library
651      */
652     function validPriceLibraries(
653         address _priceLibrary
654     )
655         external
656         view
657         returns (bool);
658 
659     /**
660      * Exchanges components for Set Tokens
661      *
662      * @param  _set          Address of set to issue
663      * @param  _quantity     Quantity of set to issue
664      */
665     function issue(
666         address _set,
667         uint256 _quantity
668     )
669         external;
670 
671     /**
672      * Issues a specified Set for a specified quantity to the recipient
673      * using the caller's components from the wallet and vault.
674      *
675      * @param  _recipient    Address to issue to
676      * @param  _set          Address of the Set to issue
677      * @param  _quantity     Number of tokens to issue
678      */
679     function issueTo(
680         address _recipient,
681         address _set,
682         uint256 _quantity
683     )
684         external;
685 
686     /**
687      * Converts user's components into Set Tokens held directly in Vault instead of user's account
688      *
689      * @param _set          Address of the Set
690      * @param _quantity     Number of tokens to redeem
691      */
692     function issueInVault(
693         address _set,
694         uint256 _quantity
695     )
696         external;
697 
698     /**
699      * Function to convert Set Tokens into underlying components
700      *
701      * @param _set          The address of the Set token
702      * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
703      */
704     function redeem(
705         address _set,
706         uint256 _quantity
707     )
708         external;
709 
710     /**
711      * Redeem Set token and return components to specified recipient. The components
712      * are left in the vault
713      *
714      * @param _recipient    Recipient of Set being issued
715      * @param _set          Address of the Set
716      * @param _quantity     Number of tokens to redeem
717      */
718     function redeemTo(
719         address _recipient,
720         address _set,
721         uint256 _quantity
722     )
723         external;
724 
725     /**
726      * Function to convert Set Tokens held in vault into underlying components
727      *
728      * @param _set          The address of the Set token
729      * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
730      */
731     function redeemInVault(
732         address _set,
733         uint256 _quantity
734     )
735         external;
736 
737     /**
738      * Composite method to redeem and withdraw with a single transaction
739      *
740      * Normally, you should expect to be able to withdraw all of the tokens.
741      * However, some have central abilities to freeze transfers (e.g. EOS). _toExclude
742      * allows you to optionally specify which component tokens to exclude when
743      * redeeming. They will remain in the vault under the users' addresses.
744      *
745      * @param _set          Address of the Set
746      * @param _to           Address to withdraw or attribute tokens to
747      * @param _quantity     Number of tokens to redeem
748      * @param _toExclude    Mask of indexes of tokens to exclude from withdrawing
749      */
750     function redeemAndWithdrawTo(
751         address _set,
752         address _to,
753         uint256 _quantity,
754         uint256 _toExclude
755     )
756         external;
757 
758     /**
759      * Deposit multiple tokens to the vault. Quantities should be in the
760      * order of the addresses of the tokens being deposited.
761      *
762      * @param  _tokens           Array of the addresses of the ERC20 tokens
763      * @param  _quantities       Array of the number of tokens to deposit
764      */
765     function batchDeposit(
766         address[] calldata _tokens,
767         uint256[] calldata _quantities
768     )
769         external;
770 
771     /**
772      * Withdraw multiple tokens from the vault. Quantities should be in the
773      * order of the addresses of the tokens being withdrawn.
774      *
775      * @param  _tokens            Array of the addresses of the ERC20 tokens
776      * @param  _quantities        Array of the number of tokens to withdraw
777      */
778     function batchWithdraw(
779         address[] calldata _tokens,
780         uint256[] calldata _quantities
781     )
782         external;
783 
784     /**
785      * Deposit any quantity of tokens into the vault.
786      *
787      * @param  _token           The address of the ERC20 token
788      * @param  _quantity        The number of tokens to deposit
789      */
790     function deposit(
791         address _token,
792         uint256 _quantity
793     )
794         external;
795 
796     /**
797      * Withdraw a quantity of tokens from the vault.
798      *
799      * @param  _token           The address of the ERC20 token
800      * @param  _quantity        The number of tokens to withdraw
801      */
802     function withdraw(
803         address _token,
804         uint256 _quantity
805     )
806         external;
807 
808     /**
809      * Transfer tokens associated with the sender's account in vault to another user's
810      * account in vault.
811      *
812      * @param  _token           Address of token being transferred
813      * @param  _to              Address of user receiving tokens
814      * @param  _quantity        Amount of tokens being transferred
815      */
816     function internalTransfer(
817         address _token,
818         address _to,
819         uint256 _quantity
820     )
821         external;
822 
823     /**
824      * Deploys a new Set Token and adds it to the valid list of SetTokens
825      *
826      * @param  _factory              The address of the Factory to create from
827      * @param  _components           The address of component tokens
828      * @param  _units                The units of each component token
829      * @param  _naturalUnit          The minimum unit to be issued or redeemed
830      * @param  _name                 The bytes32 encoded name of the new Set
831      * @param  _symbol               The bytes32 encoded symbol of the new Set
832      * @param  _callData             Byte string containing additional call parameters
833      * @return setTokenAddress       The address of the new Set
834      */
835     function createSet(
836         address _factory,
837         address[] calldata _components,
838         uint256[] calldata _units,
839         uint256 _naturalUnit,
840         bytes32 _name,
841         bytes32 _symbol,
842         bytes calldata _callData
843     )
844         external
845         returns (address);
846 
847     /**
848      * Exposes internal function that deposits a quantity of tokens to the vault and attributes
849      * the tokens respectively, to system modules.
850      *
851      * @param  _from            Address to transfer tokens from
852      * @param  _to              Address to credit for deposit
853      * @param  _token           Address of token being deposited
854      * @param  _quantity        Amount of tokens to deposit
855      */
856     function depositModule(
857         address _from,
858         address _to,
859         address _token,
860         uint256 _quantity
861     )
862         external;
863 
864     /**
865      * Exposes internal function that withdraws a quantity of tokens from the vault and
866      * deattributes the tokens respectively, to system modules.
867      *
868      * @param  _from            Address to decredit for withdraw
869      * @param  _to              Address to transfer tokens to
870      * @param  _token           Address of token being withdrawn
871      * @param  _quantity        Amount of tokens to withdraw
872      */
873     function withdrawModule(
874         address _from,
875         address _to,
876         address _token,
877         uint256 _quantity
878     )
879         external;
880 
881     /**
882      * Exposes internal function that deposits multiple tokens to the vault, to system
883      * modules. Quantities should be in the order of the addresses of the tokens being
884      * deposited.
885      *
886      * @param  _from              Address to transfer tokens from
887      * @param  _to                Address to credit for deposits
888      * @param  _tokens            Array of the addresses of the tokens being deposited
889      * @param  _quantities        Array of the amounts of tokens to deposit
890      */
891     function batchDepositModule(
892         address _from,
893         address _to,
894         address[] calldata _tokens,
895         uint256[] calldata _quantities
896     )
897         external;
898 
899     /**
900      * Exposes internal function that withdraws multiple tokens from the vault, to system
901      * modules. Quantities should be in the order of the addresses of the tokens being withdrawn.
902      *
903      * @param  _from              Address to decredit for withdrawals
904      * @param  _to                Address to transfer tokens to
905      * @param  _tokens            Array of the addresses of the tokens being withdrawn
906      * @param  _quantities        Array of the amounts of tokens to withdraw
907      */
908     function batchWithdrawModule(
909         address _from,
910         address _to,
911         address[] calldata _tokens,
912         uint256[] calldata _quantities
913     )
914         external;
915 
916     /**
917      * Expose internal function that exchanges components for Set tokens,
918      * accepting any owner, to system modules
919      *
920      * @param  _owner        Address to use tokens from
921      * @param  _recipient    Address to issue Set to
922      * @param  _set          Address of the Set to issue
923      * @param  _quantity     Number of tokens to issue
924      */
925     function issueModule(
926         address _owner,
927         address _recipient,
928         address _set,
929         uint256 _quantity
930     )
931         external;
932 
933     /**
934      * Expose internal function that exchanges Set tokens for components,
935      * accepting any owner, to system modules
936      *
937      * @param  _burnAddress         Address to burn token from
938      * @param  _incrementAddress    Address to increment component tokens to
939      * @param  _set                 Address of the Set to redeem
940      * @param  _quantity            Number of tokens to redeem
941      */
942     function redeemModule(
943         address _burnAddress,
944         address _incrementAddress,
945         address _set,
946         uint256 _quantity
947     )
948         external;
949 
950     /**
951      * Expose vault function that increments user's balance in the vault.
952      * Available to system modules
953      *
954      * @param  _tokens          The addresses of the ERC20 tokens
955      * @param  _owner           The address of the token owner
956      * @param  _quantities      The numbers of tokens to attribute to owner
957      */
958     function batchIncrementTokenOwnerModule(
959         address[] calldata _tokens,
960         address _owner,
961         uint256[] calldata _quantities
962     )
963         external;
964 
965     /**
966      * Expose vault function that decrement user's balance in the vault
967      * Only available to system modules.
968      *
969      * @param  _tokens          The addresses of the ERC20 tokens
970      * @param  _owner           The address of the token owner
971      * @param  _quantities      The numbers of tokens to attribute to owner
972      */
973     function batchDecrementTokenOwnerModule(
974         address[] calldata _tokens,
975         address _owner,
976         uint256[] calldata _quantities
977     )
978         external;
979 
980     /**
981      * Expose vault function that transfer vault balances between users
982      * Only available to system modules.
983      *
984      * @param  _tokens           Addresses of tokens being transferred
985      * @param  _from             Address tokens being transferred from
986      * @param  _to               Address tokens being transferred to
987      * @param  _quantities       Amounts of tokens being transferred
988      */
989     function batchTransferBalanceModule(
990         address[] calldata _tokens,
991         address _from,
992         address _to,
993         uint256[] calldata _quantities
994     )
995         external;
996 
997     /**
998      * Transfers token from one address to another using the transfer proxy.
999      * Only available to system modules.
1000      *
1001      * @param  _token          The address of the ERC20 token
1002      * @param  _quantity       The number of tokens to transfer
1003      * @param  _from           The address to transfer from
1004      * @param  _to             The address to transfer to
1005      */
1006     function transferModule(
1007         address _token,
1008         uint256 _quantity,
1009         address _from,
1010         address _to
1011     )
1012         external;
1013 
1014     /**
1015      * Expose transfer proxy function to transfer tokens from one address to another
1016      * Only available to system modules.
1017      *
1018      * @param  _tokens         The addresses of the ERC20 token
1019      * @param  _quantities     The numbers of tokens to transfer
1020      * @param  _from           The address to transfer from
1021      * @param  _to             The address to transfer to
1022      */
1023     function batchTransferModule(
1024         address[] calldata _tokens,
1025         uint256[] calldata _quantities,
1026         address _from,
1027         address _to
1028     )
1029         external;
1030 }
1031 
1032 // File: contracts/core/interfaces/ISetToken.sol
1033 
1034 /*
1035     Copyright 2018 Set Labs Inc.
1036 
1037     Licensed under the Apache License, Version 2.0 (the "License");
1038     you may not use this file except in compliance with the License.
1039     You may obtain a copy of the License at
1040 
1041     http://www.apache.org/licenses/LICENSE-2.0
1042 
1043     Unless required by applicable law or agreed to in writing, software
1044     distributed under the License is distributed on an "AS IS" BASIS,
1045     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1046     See the License for the specific language governing permissions and
1047     limitations under the License.
1048 */
1049 
1050 pragma solidity 0.5.7;
1051 
1052 /**
1053  * @title ISetToken
1054  * @author Set Protocol
1055  *
1056  * The ISetToken interface provides a light-weight, structured way to interact with the
1057  * SetToken contract from another contract.
1058  */
1059 interface ISetToken {
1060 
1061     /* ============ External Functions ============ */
1062 
1063     /*
1064      * Get natural unit of Set
1065      *
1066      * @return  uint256       Natural unit of Set
1067      */
1068     function naturalUnit()
1069         external
1070         view
1071         returns (uint256);
1072 
1073     /*
1074      * Get addresses of all components in the Set
1075      *
1076      * @return  componentAddresses       Array of component tokens
1077      */
1078     function getComponents()
1079         external
1080         view
1081         returns (address[] memory);
1082 
1083     /*
1084      * Get units of all tokens in Set
1085      *
1086      * @return  units       Array of component units
1087      */
1088     function getUnits()
1089         external
1090         view
1091         returns (uint256[] memory);
1092 
1093     /*
1094      * Checks to make sure token is component of Set
1095      *
1096      * @param  _tokenAddress     Address of token being checked
1097      * @return  bool             True if token is component of Set
1098      */
1099     function tokenIsComponent(
1100         address _tokenAddress
1101     )
1102         external
1103         view
1104         returns (bool);
1105 
1106     /*
1107      * Mint set token for given address.
1108      * Can only be called by authorized contracts.
1109      *
1110      * @param  _issuer      The address of the issuing account
1111      * @param  _quantity    The number of sets to attribute to issuer
1112      */
1113     function mint(
1114         address _issuer,
1115         uint256 _quantity
1116     )
1117         external;
1118 
1119     /*
1120      * Burn set token for given address
1121      * Can only be called by authorized contracts
1122      *
1123      * @param  _from        The address of the redeeming account
1124      * @param  _quantity    The number of sets to burn from redeemer
1125      */
1126     function burn(
1127         address _from,
1128         uint256 _quantity
1129     )
1130         external;
1131 
1132     /**
1133     * Transfer token for a specified address
1134     *
1135     * @param to The address to transfer to.
1136     * @param value The amount to be transferred.
1137     */
1138     function transfer(
1139         address to,
1140         uint256 value
1141     )
1142         external;
1143 }
1144 
1145 // File: contracts/core/interfaces/IVault.sol
1146 
1147 /*
1148     Copyright 2018 Set Labs Inc.
1149 
1150     Licensed under the Apache License, Version 2.0 (the "License");
1151     you may not use this file except in compliance with the License.
1152     You may obtain a copy of the License at
1153 
1154     http://www.apache.org/licenses/LICENSE-2.0
1155 
1156     Unless required by applicable law or agreed to in writing, software
1157     distributed under the License is distributed on an "AS IS" BASIS,
1158     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1159     See the License for the specific language governing permissions and
1160     limitations under the License.
1161 */
1162 
1163 pragma solidity 0.5.7;
1164 
1165 /**
1166  * @title IVault
1167  * @author Set Protocol
1168  *
1169  * The IVault interface provides a light-weight, structured way to interact with the Vault
1170  * contract from another contract.
1171  */
1172 interface IVault {
1173 
1174     /*
1175      * Withdraws user's unassociated tokens to user account. Can only be
1176      * called by authorized core contracts.
1177      *
1178      * @param  _token          The address of the ERC20 token
1179      * @param  _to             The address to transfer token to
1180      * @param  _quantity       The number of tokens to transfer
1181      */
1182     function withdrawTo(
1183         address _token,
1184         address _to,
1185         uint256 _quantity
1186     )
1187         external;
1188 
1189     /*
1190      * Increment quantity owned of a token for a given address. Can
1191      * only be called by authorized core contracts.
1192      *
1193      * @param  _token           The address of the ERC20 token
1194      * @param  _owner           The address of the token owner
1195      * @param  _quantity        The number of tokens to attribute to owner
1196      */
1197     function incrementTokenOwner(
1198         address _token,
1199         address _owner,
1200         uint256 _quantity
1201     )
1202         external;
1203 
1204     /*
1205      * Decrement quantity owned of a token for a given address. Can only
1206      * be called by authorized core contracts.
1207      *
1208      * @param  _token           The address of the ERC20 token
1209      * @param  _owner           The address of the token owner
1210      * @param  _quantity        The number of tokens to deattribute to owner
1211      */
1212     function decrementTokenOwner(
1213         address _token,
1214         address _owner,
1215         uint256 _quantity
1216     )
1217         external;
1218 
1219     /**
1220      * Transfers tokens associated with one account to another account in the vault
1221      *
1222      * @param  _token          Address of token being transferred
1223      * @param  _from           Address token being transferred from
1224      * @param  _to             Address token being transferred to
1225      * @param  _quantity       Amount of tokens being transferred
1226      */
1227 
1228     function transferBalance(
1229         address _token,
1230         address _from,
1231         address _to,
1232         uint256 _quantity
1233     )
1234         external;
1235 
1236 
1237     /*
1238      * Withdraws user's unassociated tokens to user account. Can only be
1239      * called by authorized core contracts.
1240      *
1241      * @param  _tokens          The addresses of the ERC20 tokens
1242      * @param  _owner           The address of the token owner
1243      * @param  _quantities      The numbers of tokens to attribute to owner
1244      */
1245     function batchWithdrawTo(
1246         address[] calldata _tokens,
1247         address _to,
1248         uint256[] calldata _quantities
1249     )
1250         external;
1251 
1252     /*
1253      * Increment quantites owned of a collection of tokens for a given address. Can
1254      * only be called by authorized core contracts.
1255      *
1256      * @param  _tokens          The addresses of the ERC20 tokens
1257      * @param  _owner           The address of the token owner
1258      * @param  _quantities      The numbers of tokens to attribute to owner
1259      */
1260     function batchIncrementTokenOwner(
1261         address[] calldata _tokens,
1262         address _owner,
1263         uint256[] calldata _quantities
1264     )
1265         external;
1266 
1267     /*
1268      * Decrements quantites owned of a collection of tokens for a given address. Can
1269      * only be called by authorized core contracts.
1270      *
1271      * @param  _tokens          The addresses of the ERC20 tokens
1272      * @param  _owner           The address of the token owner
1273      * @param  _quantities      The numbers of tokens to attribute to owner
1274      */
1275     function batchDecrementTokenOwner(
1276         address[] calldata _tokens,
1277         address _owner,
1278         uint256[] calldata _quantities
1279     )
1280         external;
1281 
1282    /**
1283      * Transfers tokens associated with one account to another account in the vault
1284      *
1285      * @param  _tokens           Addresses of tokens being transferred
1286      * @param  _from             Address tokens being transferred from
1287      * @param  _to               Address tokens being transferred to
1288      * @param  _quantities       Amounts of tokens being transferred
1289      */
1290     function batchTransferBalance(
1291         address[] calldata _tokens,
1292         address _from,
1293         address _to,
1294         uint256[] calldata _quantities
1295     )
1296         external;
1297 
1298     /*
1299      * Get balance of particular contract for owner.
1300      *
1301      * @param  _token    The address of the ERC20 token
1302      * @param  _owner    The address of the token owner
1303      */
1304     function getOwnerBalance(
1305         address _token,
1306         address _owner
1307     )
1308         external
1309         view
1310         returns (uint256);
1311 }
1312 
1313 // File: contracts/core/modules/lib/ExchangeIssuanceLibrary.sol
1314 
1315 /*
1316     Copyright 2018 Set Labs Inc.
1317 
1318     Licensed under the Apache License, Version 2.0 (the "License");
1319     you may not use this file except in compliance with the License.
1320     You may obtain a copy of the License at
1321 
1322     http://www.apache.org/licenses/LICENSE-2.0
1323 
1324     Unless required by applicable law or agreed to in writing, software
1325     distributed under the License is distributed on an "AS IS" BASIS,
1326     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1327     See the License for the specific language governing permissions and
1328     limitations under the License.
1329 */
1330 
1331 pragma solidity 0.5.7;
1332 
1333 
1334 
1335 
1336 
1337 
1338 
1339 /**
1340  * @title ExchangeIssuanceLibrary
1341  * @author Set Protocol
1342  *
1343  * The ExchangeIssuanceLibrary contains functions for validating exchange order data
1344  */
1345 library ExchangeIssuanceLibrary {
1346     using SafeMath for uint256;
1347     using AddressArrayUtils for address[];
1348 
1349     // ============ Structs ============
1350 
1351     struct ExchangeIssuanceParams {
1352         address setAddress;
1353         uint256 quantity;
1354         uint8[] sendTokenExchangeIds;
1355         address[] sendTokens;
1356         uint256[] sendTokenAmounts;
1357         address[] receiveTokens;
1358         uint256[] receiveTokenAmounts;
1359     }
1360 
1361     /**
1362      * Validates that the quantity to issue is positive and a multiple of the Set natural unit.
1363      *
1364      * @param _set                The address of the Set
1365      * @param _quantity           The quantity of Sets to issue or redeem
1366      */
1367     function validateQuantity(
1368         address _set,
1369         uint256 _quantity
1370     )
1371         internal
1372         view
1373     {
1374         // Make sure quantity to issue is greater than 0
1375         require(
1376             _quantity > 0,
1377             "ExchangeIssuanceLibrary.validateQuantity: Quantity must be positive"
1378         );
1379 
1380         // Make sure Issue quantity is multiple of the Set natural unit
1381         require(
1382             _quantity.mod(ISetToken(_set).naturalUnit()) == 0,
1383             "ExchangeIssuanceLibrary.validateQuantity: Quantity must be multiple of natural unit"
1384         );
1385     }
1386 
1387     /**
1388      * Validates that the required Components and amounts are valid components and positive.
1389      * Duplicate receive token values are not allowed
1390      *
1391      * @param _receiveTokens           The addresses of components required for issuance
1392      * @param _receiveTokenAmounts     The quantities of components required for issuance
1393      */
1394     function validateReceiveTokens(
1395         address[] memory _receiveTokens,
1396         uint256[] memory _receiveTokenAmounts
1397     )
1398         internal
1399         view
1400     {
1401         uint256 receiveTokensCount = _receiveTokens.length;
1402 
1403         // Make sure required components array is non-empty
1404         require(
1405             receiveTokensCount > 0,
1406             "ExchangeIssuanceLibrary.validateReceiveTokens: Receive tokens must not be empty"
1407         );
1408 
1409         // Ensure the receive tokens has no duplicates
1410         require(
1411             !_receiveTokens.hasDuplicate(),
1412             "ExchangeIssuanceLibrary.validateReceiveTokens: Receive tokens must not have duplicates"
1413         );
1414 
1415         // Make sure required components and required component amounts are equal length
1416         require(
1417             receiveTokensCount == _receiveTokenAmounts.length,
1418             "ExchangeIssuanceLibrary.validateReceiveTokens: Receive tokens and amounts must be equal length"
1419         );
1420 
1421         for (uint256 i = 0; i < receiveTokensCount; i++) {
1422             // Make sure all required component amounts are non-zero
1423             require(
1424                 _receiveTokenAmounts[i] > 0,
1425                 "ExchangeIssuanceLibrary.validateReceiveTokens: Component amounts must be positive"
1426             );
1427         }
1428     }
1429 
1430     /**
1431      * Validates that the tokens received exceeds what we expect
1432      *
1433      * @param _vault                        The address of the Vault
1434      * @param _receiveTokens                The addresses of components required for issuance
1435      * @param _requiredBalances             The quantities of components required for issuance
1436      * @param _userToCheck                  The address of the user
1437      */
1438     function validatePostExchangeReceiveTokenBalances(
1439         address _vault,
1440         address[] memory _receiveTokens,
1441         uint256[] memory _requiredBalances,
1442         address _userToCheck
1443     )
1444         internal
1445         view
1446     {
1447         // Get vault instance
1448         IVault vault = IVault(_vault);
1449 
1450         // Check that caller's receive tokens in Vault have been incremented correctly
1451         for (uint256 i = 0; i < _receiveTokens.length; i++) {
1452             uint256 currentBal = vault.getOwnerBalance(
1453                 _receiveTokens[i],
1454                 _userToCheck
1455             );
1456 
1457             require(
1458                 currentBal >= _requiredBalances[i],
1459                 "ExchangeIssuanceLibrary.validatePostExchangeReceiveTokenBalances: Insufficient receive token acquired"
1460             );
1461         }
1462     }
1463 
1464     /**
1465      * Validates that the send tokens inputs are valid. Since tokens are sent to various exchanges,
1466      * duplicate send tokens are valid
1467      *
1468      * @param _core                         The address of Core
1469      * @param _sendTokenExchangeIds         List of exchange wrapper enumerations corresponding to
1470      *                                          the wrapper that will handle the component
1471      * @param _sendTokens                   The address of the send tokens
1472      * @param _sendTokenAmounts             The quantities of send tokens
1473      */
1474     function validateSendTokenParams(
1475         address _core,
1476         uint8[] memory _sendTokenExchangeIds,
1477         address[] memory _sendTokens,
1478         uint256[] memory _sendTokenAmounts
1479     )
1480         internal
1481         view
1482     {
1483         require(
1484             _sendTokens.length > 0,
1485             "ExchangeIssuanceLibrary.validateSendTokenParams: Send token inputs must not be empty"
1486         );
1487 
1488         require(
1489             _sendTokenExchangeIds.length == _sendTokens.length &&
1490             _sendTokens.length == _sendTokenAmounts.length,
1491             "ExchangeIssuanceLibrary.validateSendTokenParams: Send token inputs must be of the same length"
1492         );
1493 
1494         ICore core = ICore(_core);
1495 
1496         for (uint256 i = 0; i < _sendTokenExchangeIds.length; i++) {
1497             // Make sure all exchanges are valid
1498             require(
1499                 core.exchangeIds(_sendTokenExchangeIds[i]) != address(0),
1500                 "ExchangeIssuanceLibrary.validateSendTokenParams: Must be valid exchange"
1501             );
1502 
1503             // Make sure all send token amounts are non-zero
1504             require(
1505                 _sendTokenAmounts[i] > 0,
1506                 "ExchangeIssuanceLibrary.validateSendTokenParams: Send amounts must be positive"
1507             );
1508         }
1509     }
1510 }
1511 
1512 // File: contracts/lib/IERC20.sol
1513 
1514 /*
1515     Copyright 2018 Set Labs Inc.
1516 
1517     Licensed under the Apache License, Version 2.0 (the "License");
1518     you may not use this file except in compliance with the License.
1519     You may obtain a copy of the License at
1520 
1521     http://www.apache.org/licenses/LICENSE-2.0
1522 
1523     Unless required by applicable law or agreed to in writing, software
1524     distributed under the License is distributed on an "AS IS" BASIS,
1525     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1526     See the License for the specific language governing permissions and
1527     limitations under the License.
1528 */
1529 
1530 pragma solidity 0.5.7;
1531 
1532 
1533 /**
1534  * @title IERC20
1535  * @author Set Protocol
1536  *
1537  * Interface for using ERC20 Tokens. This interface is needed to interact with tokens that are not
1538  * fully ERC20 compliant and return something other than true on successful transfers.
1539  */
1540 interface IERC20 {
1541     function balanceOf(
1542         address _owner
1543     )
1544         external
1545         view
1546         returns (uint256);
1547 
1548     function allowance(
1549         address _owner,
1550         address _spender
1551     )
1552         external
1553         view
1554         returns (uint256);
1555 
1556     function transfer(
1557         address _to,
1558         uint256 _quantity
1559     )
1560         external;
1561 
1562     function transferFrom(
1563         address _from,
1564         address _to,
1565         uint256 _quantity
1566     )
1567         external;
1568 
1569     function approve(
1570         address _spender,
1571         uint256 _quantity
1572     )
1573         external
1574         returns (bool);
1575 
1576     function totalSupply()
1577         external
1578         returns (uint256);
1579 }
1580 
1581 // File: contracts/lib/ERC20Wrapper.sol
1582 
1583 /*
1584     Copyright 2018 Set Labs Inc.
1585 
1586     Licensed under the Apache License, Version 2.0 (the "License");
1587     you may not use this file except in compliance with the License.
1588     You may obtain a copy of the License at
1589 
1590     http://www.apache.org/licenses/LICENSE-2.0
1591 
1592     Unless required by applicable law or agreed to in writing, software
1593     distributed under the License is distributed on an "AS IS" BASIS,
1594     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1595     See the License for the specific language governing permissions and
1596     limitations under the License.
1597 */
1598 
1599 pragma solidity 0.5.7;
1600 
1601 
1602 
1603 
1604 /**
1605  * @title ERC20Wrapper
1606  * @author Set Protocol
1607  *
1608  * This library contains functions for interacting wtih ERC20 tokens, even those not fully compliant.
1609  * For all functions we will only accept tokens that return a null or true value, any other values will
1610  * cause the operation to revert.
1611  */
1612 library ERC20Wrapper {
1613 
1614     // ============ Internal Functions ============
1615 
1616     /**
1617      * Check balance owner's balance of ERC20 token
1618      *
1619      * @param  _token          The address of the ERC20 token
1620      * @param  _owner          The owner who's balance is being checked
1621      * @return  uint256        The _owner's amount of tokens
1622      */
1623     function balanceOf(
1624         address _token,
1625         address _owner
1626     )
1627         external
1628         view
1629         returns (uint256)
1630     {
1631         return IERC20(_token).balanceOf(_owner);
1632     }
1633 
1634     /**
1635      * Checks spender's allowance to use token's on owner's behalf.
1636      *
1637      * @param  _token          The address of the ERC20 token
1638      * @param  _owner          The token owner address
1639      * @param  _spender        The address the allowance is being checked on
1640      * @return  uint256        The spender's allowance on behalf of owner
1641      */
1642     function allowance(
1643         address _token,
1644         address _owner,
1645         address _spender
1646     )
1647         internal
1648         view
1649         returns (uint256)
1650     {
1651         return IERC20(_token).allowance(_owner, _spender);
1652     }
1653 
1654     /**
1655      * Transfers tokens from an address. Handle's tokens that return true or null.
1656      * If other value returned, reverts.
1657      *
1658      * @param  _token          The address of the ERC20 token
1659      * @param  _to             The address to transfer to
1660      * @param  _quantity       The amount of tokens to transfer
1661      */
1662     function transfer(
1663         address _token,
1664         address _to,
1665         uint256 _quantity
1666     )
1667         external
1668     {
1669         IERC20(_token).transfer(_to, _quantity);
1670 
1671         // Check that transfer returns true or null
1672         require(
1673             checkSuccess(),
1674             "ERC20Wrapper.transfer: Bad return value"
1675         );
1676     }
1677 
1678     /**
1679      * Transfers tokens from an address (that has set allowance on the proxy).
1680      * Handle's tokens that return true or null. If other value returned, reverts.
1681      *
1682      * @param  _token          The address of the ERC20 token
1683      * @param  _from           The address to transfer from
1684      * @param  _to             The address to transfer to
1685      * @param  _quantity       The number of tokens to transfer
1686      */
1687     function transferFrom(
1688         address _token,
1689         address _from,
1690         address _to,
1691         uint256 _quantity
1692     )
1693         external
1694     {
1695         IERC20(_token).transferFrom(_from, _to, _quantity);
1696 
1697         // Check that transferFrom returns true or null
1698         require(
1699             checkSuccess(),
1700             "ERC20Wrapper.transferFrom: Bad return value"
1701         );
1702     }
1703 
1704     /**
1705      * Grants spender ability to spend on owner's behalf.
1706      * Handle's tokens that return true or null. If other value returned, reverts.
1707      *
1708      * @param  _token          The address of the ERC20 token
1709      * @param  _spender        The address to approve for transfer
1710      * @param  _quantity       The amount of tokens to approve spender for
1711      */
1712     function approve(
1713         address _token,
1714         address _spender,
1715         uint256 _quantity
1716     )
1717         internal
1718     {
1719         IERC20(_token).approve(_spender, _quantity);
1720 
1721         // Check that approve returns true or null
1722         require(
1723             checkSuccess(),
1724             "ERC20Wrapper.approve: Bad return value"
1725         );
1726     }
1727 
1728     /**
1729      * Ensure's the owner has granted enough allowance for system to
1730      * transfer tokens.
1731      *
1732      * @param  _token          The address of the ERC20 token
1733      * @param  _owner          The address of the token owner
1734      * @param  _spender        The address to grant/check allowance for
1735      * @param  _quantity       The amount to see if allowed for
1736      */
1737     function ensureAllowance(
1738         address _token,
1739         address _owner,
1740         address _spender,
1741         uint256 _quantity
1742     )
1743         internal
1744     {
1745         uint256 currentAllowance = allowance(_token, _owner, _spender);
1746         if (currentAllowance < _quantity) {
1747             approve(
1748                 _token,
1749                 _spender,
1750                 CommonMath.maxUInt256()
1751             );
1752         }
1753     }
1754 
1755     // ============ Private Functions ============
1756 
1757     /**
1758      * Checks the return value of the previous function up to 32 bytes. Returns true if the previous
1759      * function returned 0 bytes or 1.
1760      */
1761     function checkSuccess(
1762     )
1763         private
1764         pure
1765         returns (bool)
1766     {
1767         // default to failure
1768         uint256 returnValue = 0;
1769 
1770         assembly {
1771             // check number of bytes returned from last function call
1772             switch returndatasize
1773 
1774             // no bytes returned: assume success
1775             case 0x0 {
1776                 returnValue := 1
1777             }
1778 
1779             // 32 bytes returned
1780             case 0x20 {
1781                 // copy 32 bytes into scratch space
1782                 returndatacopy(0x0, 0x0, 0x20)
1783 
1784                 // load those bytes into returnValue
1785                 returnValue := mload(0x0)
1786             }
1787 
1788             // not sure what was returned: dont mark as success
1789             default { }
1790         }
1791 
1792         // check if returned value is one or nothing
1793         return returnValue == 1;
1794     }
1795 }
1796 
1797 // File: contracts/core/interfaces/IExchangeIssuanceModule.sol
1798 
1799 /*
1800     Copyright 2018 Set Labs Inc.
1801 
1802     Licensed under the Apache License, Version 2.0 (the "License");
1803     you may not use this file except in compliance with the License.
1804     You may obtain a copy of the License at
1805 
1806     http://www.apache.org/licenses/LICENSE-2.0
1807 
1808     Unless required by applicable law or agreed to in writing, software
1809     distributed under the License is distributed on an "AS IS" BASIS,
1810     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1811     See the License for the specific language governing permissions and
1812     limitations under the License.
1813 */
1814 
1815 pragma solidity 0.5.7;
1816 pragma experimental "ABIEncoderV2";
1817 
1818 
1819 /**
1820  * @title IExchangeIssuanceModule
1821  * @author Set Protocol
1822  *
1823  * Interface for executing orders and issuing and redeeming a Set
1824  */
1825 interface IExchangeIssuanceModule {
1826 
1827     function exchangeIssue(
1828         ExchangeIssuanceLibrary.ExchangeIssuanceParams calldata _exchangeIssuanceParams,
1829         bytes calldata _orderData
1830     )
1831         external;
1832 
1833 
1834     function exchangeRedeem(
1835         ExchangeIssuanceLibrary.ExchangeIssuanceParams calldata _exchangeIssuanceParams,
1836         bytes calldata _orderData
1837     )
1838         external;
1839 }
1840 
1841 // File: contracts/core/lib/RebalancingLibrary.sol
1842 
1843 /*
1844     Copyright 2018 Set Labs Inc.
1845 
1846     Licensed under the Apache License, Version 2.0 (the "License");
1847     you may not use this file except in compliance with the License.
1848     You may obtain a copy of the License at
1849 
1850     http://www.apache.org/licenses/LICENSE-2.0
1851 
1852     Unless required by applicable law or agreed to in writing, software
1853     distributed under the License is distributed on an "AS IS" BASIS,
1854     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1855     See the License for the specific language governing permissions and
1856     limitations under the License.
1857 */
1858 
1859 pragma solidity 0.5.7;
1860 
1861 
1862 /**
1863  * @title RebalancingLibrary
1864  * @author Set Protocol
1865  *
1866  * The RebalancingLibrary contains functions for facilitating the rebalancing process for
1867  * Rebalancing Set Tokens. Removes the old calculation functions
1868  *
1869  */
1870 library RebalancingLibrary {
1871 
1872     /* ============ Enums ============ */
1873 
1874     enum State { Default, Proposal, Rebalance, Drawdown }
1875 
1876     /* ============ Structs ============ */
1877 
1878     struct AuctionPriceParameters {
1879         uint256 auctionStartTime;
1880         uint256 auctionTimeToPivot;
1881         uint256 auctionStartPrice;
1882         uint256 auctionPivotPrice;
1883     }
1884 
1885     struct BiddingParameters {
1886         uint256 minimumBid;
1887         uint256 remainingCurrentSets;
1888         uint256[] combinedCurrentUnits;
1889         uint256[] combinedNextSetUnits;
1890         address[] combinedTokenArray;
1891     }
1892 }
1893 
1894 // File: contracts/core/interfaces/IRebalancingSetToken.sol
1895 
1896 /*
1897     Copyright 2018 Set Labs Inc.
1898 
1899     Licensed under the Apache License, Version 2.0 (the "License");
1900     you may not use this file except in compliance with the License.
1901     You may obtain a copy of the License at
1902 
1903     http://www.apache.org/licenses/LICENSE-2.0
1904 
1905     Unless required by applicable law or agreed to in writing, software
1906     distributed under the License is distributed on an "AS IS" BASIS,
1907     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1908     See the License for the specific language governing permissions and
1909     limitations under the License.
1910 */
1911 
1912 pragma solidity 0.5.7;
1913 
1914 
1915 /**
1916  * @title IRebalancingSetToken
1917  * @author Set Protocol
1918  *
1919  * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
1920  * RebalancingSetToken contract from another contract.
1921  */
1922 
1923 interface IRebalancingSetToken {
1924 
1925     /*
1926      * Get the auction library contract used for the current rebalance
1927      *
1928      * @return address    Address of auction library used in the upcoming auction
1929      */
1930     function auctionLibrary()
1931         external
1932         view
1933         returns (address);
1934 
1935     /*
1936      * Get totalSupply of Rebalancing Set
1937      *
1938      * @return  totalSupply
1939      */
1940     function totalSupply()
1941         external
1942         view
1943         returns (uint256);
1944 
1945     /*
1946      * Get proposalTimeStamp of Rebalancing Set
1947      *
1948      * @return  proposalTimeStamp
1949      */
1950     function proposalStartTime()
1951         external
1952         view
1953         returns (uint256);
1954 
1955     /*
1956      * Get lastRebalanceTimestamp of Rebalancing Set
1957      *
1958      * @return  lastRebalanceTimestamp
1959      */
1960     function lastRebalanceTimestamp()
1961         external
1962         view
1963         returns (uint256);
1964 
1965     /*
1966      * Get rebalanceInterval of Rebalancing Set
1967      *
1968      * @return  rebalanceInterval
1969      */
1970     function rebalanceInterval()
1971         external
1972         view
1973         returns (uint256);
1974 
1975     /*
1976      * Get rebalanceState of Rebalancing Set
1977      *
1978      * @return RebalancingLibrary.State    Current rebalance state of the RebalancingSetToken
1979      */
1980     function rebalanceState()
1981         external
1982         view
1983         returns (RebalancingLibrary.State);
1984 
1985     /*
1986      * Get the starting amount of current SetToken for the current auction
1987      *
1988      * @return  rebalanceState
1989      */
1990     function startingCurrentSetAmount()
1991         external
1992         view
1993         returns (uint256);
1994 
1995     /**
1996      * Gets the balance of the specified address.
1997      *
1998      * @param owner      The address to query the balance of.
1999      * @return           A uint256 representing the amount owned by the passed address.
2000      */
2001     function balanceOf(
2002         address owner
2003     )
2004         external
2005         view
2006         returns (uint256);
2007 
2008     /**
2009      * Function used to set the terms of the next rebalance and start the proposal period
2010      *
2011      * @param _nextSet                      The Set to rebalance into
2012      * @param _auctionLibrary               The library used to calculate the Dutch Auction price
2013      * @param _auctionTimeToPivot           The amount of time for the auction to go ffrom start to pivot price
2014      * @param _auctionStartPrice            The price to start the auction at
2015      * @param _auctionPivotPrice            The price at which the price curve switches from linear to exponential
2016      */
2017     function propose(
2018         address _nextSet,
2019         address _auctionLibrary,
2020         uint256 _auctionTimeToPivot,
2021         uint256 _auctionStartPrice,
2022         uint256 _auctionPivotPrice
2023     )
2024         external;
2025 
2026     /*
2027      * Get natural unit of Set
2028      *
2029      * @return  uint256       Natural unit of Set
2030      */
2031     function naturalUnit()
2032         external
2033         view
2034         returns (uint256);
2035 
2036     /**
2037      * Returns the address of the current base SetToken with the current allocation
2038      *
2039      * @return           A address representing the base SetToken
2040      */
2041     function currentSet()
2042         external
2043         view
2044         returns (address);
2045 
2046     /**
2047      * Returns the address of the next base SetToken with the post auction allocation
2048      *
2049      * @return  address    Address representing the base SetToken
2050      */
2051     function nextSet()
2052         external
2053         view
2054         returns (address);
2055 
2056     /*
2057      * Get the unit shares of the rebalancing Set
2058      *
2059      * @return  unitShares       Unit Shares of the base Set
2060      */
2061     function unitShares()
2062         external
2063         view
2064         returns (uint256);
2065 
2066     /*
2067      * Burn set token for given address.
2068      * Can only be called by authorized contracts.
2069      *
2070      * @param  _from        The address of the redeeming account
2071      * @param  _quantity    The number of sets to burn from redeemer
2072      */
2073     function burn(
2074         address _from,
2075         uint256 _quantity
2076     )
2077         external;
2078 
2079     /*
2080      * Place bid during rebalance auction. Can only be called by Core.
2081      *
2082      * @param _quantity                 The amount of currentSet to be rebalanced
2083      * @return combinedTokenArray       Array of token addresses invovled in rebalancing
2084      * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
2085      * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
2086      */
2087     function placeBid(
2088         uint256 _quantity
2089     )
2090         external
2091         returns (address[] memory, uint256[] memory, uint256[] memory);
2092 
2093     /*
2094      * Get combinedTokenArray of Rebalancing Set
2095      *
2096      * @return  combinedTokenArray
2097      */
2098     function getCombinedTokenArrayLength()
2099         external
2100         view
2101         returns (uint256);
2102 
2103     /*
2104      * Get combinedTokenArray of Rebalancing Set
2105      *
2106      * @return  combinedTokenArray
2107      */
2108     function getCombinedTokenArray()
2109         external
2110         view
2111         returns (address[] memory);
2112 
2113     /*
2114      * Get failedAuctionWithdrawComponents of Rebalancing Set
2115      *
2116      * @return  failedAuctionWithdrawComponents
2117      */
2118     function getFailedAuctionWithdrawComponents()
2119         external
2120         view
2121         returns (address[] memory);
2122 
2123     /*
2124      * Get auctionPriceParameters for current auction
2125      *
2126      * @return uint256[4]    AuctionPriceParameters for current rebalance auction
2127      */
2128     function getAuctionPriceParameters()
2129         external
2130         view
2131         returns (uint256[] memory);
2132 
2133     /*
2134      * Get biddingParameters for current auction
2135      *
2136      * @return uint256[2]    BiddingParameters for current rebalance auction
2137      */
2138     function getBiddingParameters()
2139         external
2140         view
2141         returns (uint256[] memory);
2142 
2143 }
2144 
2145 // File: contracts/core/interfaces/ITransferProxy.sol
2146 
2147 /*
2148     Copyright 2018 Set Labs Inc.
2149 
2150     Licensed under the Apache License, Version 2.0 (the "License");
2151     you may not use this file except in compliance with the License.
2152     You may obtain a copy of the License at
2153 
2154     http://www.apache.org/licenses/LICENSE-2.0
2155 
2156     Unless required by applicable law or agreed to in writing, software
2157     distributed under the License is distributed on an "AS IS" BASIS,
2158     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2159     See the License for the specific language governing permissions and
2160     limitations under the License.
2161 */
2162 
2163 pragma solidity 0.5.7;
2164 
2165 /**
2166  * @title ITransferProxy
2167  * @author Set Protocol
2168  *
2169  * The ITransferProxy interface provides a light-weight, structured way to interact with the
2170  * TransferProxy contract from another contract.
2171  */
2172 interface ITransferProxy {
2173 
2174     /* ============ External Functions ============ */
2175 
2176     /**
2177      * Transfers tokens from an address (that has set allowance on the proxy).
2178      * Can only be called by authorized core contracts.
2179      *
2180      * @param  _token          The address of the ERC20 token
2181      * @param  _quantity       The number of tokens to transfer
2182      * @param  _from           The address to transfer from
2183      * @param  _to             The address to transfer to
2184      */
2185     function transfer(
2186         address _token,
2187         uint256 _quantity,
2188         address _from,
2189         address _to
2190     )
2191         external;
2192 
2193     /**
2194      * Transfers tokens from an address (that has set allowance on the proxy).
2195      * Can only be called by authorized core contracts.
2196      *
2197      * @param  _tokens         The addresses of the ERC20 token
2198      * @param  _quantities     The numbers of tokens to transfer
2199      * @param  _from           The address to transfer from
2200      * @param  _to             The address to transfer to
2201      */
2202     function batchTransfer(
2203         address[] calldata _tokens,
2204         uint256[] calldata _quantities,
2205         address _from,
2206         address _to
2207     )
2208         external;
2209 }
2210 
2211 // File: contracts/lib/IWETH.sol
2212 
2213 /*
2214     Copyright 2018 Set Labs Inc.
2215 
2216     Licensed under the Apache License, Version 2.0 (the "License");
2217     you may not use this file except in compliance with the License.
2218     You may obtain a copy of the License at
2219 
2220     http://www.apache.org/licenses/LICENSE-2.0
2221 
2222     Unless required by applicable law or agreed to in writing, software
2223     distributed under the License is distributed on an "AS IS" BASIS,
2224     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2225     See the License for the specific language governing permissions and
2226     limitations under the License.
2227 */
2228 
2229 pragma solidity 0.5.7;
2230 
2231 
2232 /**
2233  * @title IWETH
2234  * @author Set Protocol
2235  *
2236  * Interface for Wrapped Ether. This interface allows for interaction for wrapped ether's deposit and withdrawal
2237  * functionality.
2238  */
2239 interface IWETH {
2240     function deposit()
2241         external
2242         payable;
2243 
2244     function withdraw(
2245         uint256 wad
2246     )
2247         external;
2248 }
2249 
2250 // File: contracts/core/modules/lib/ModuleCoreStateV2.sol
2251 
2252 /*
2253     Copyright 2018 Set Labs Inc.
2254 
2255     Licensed under the Apache License, Version 2.0 (the "License");
2256     you may not use this file except in compliance with the License.
2257     You may obtain a copy of the License at
2258 
2259     http://www.apache.org/licenses/LICENSE-2.0
2260 
2261     Unless required by applicable law or agreed to in writing, software
2262     distributed under the License is distributed on an "AS IS" BASIS,
2263     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2264     See the License for the specific language governing permissions and
2265     limitations under the License.
2266 */
2267 
2268 pragma solidity 0.5.7;
2269 
2270 
2271 
2272 
2273 
2274 /**
2275  * @title ModuleCoreStateV2
2276  * @author Set Protocol
2277  *
2278  * The ModuleCoreStateV2 library maintains Core-related state for modules.
2279  *
2280  * CHANGELOG
2281  * - Adds transferProxy to the tracked state
2282  * - Removes address variables
2283  *
2284  */
2285 contract ModuleCoreStateV2 {
2286 
2287     /* ============ State Variables ============ */
2288 
2289     // Address of core contract
2290     ICore public coreInstance;
2291 
2292     // Address of vault contract
2293     IVault public vaultInstance;
2294 
2295     // Address of transferProxy contract
2296     ITransferProxy public transferProxyInstance;
2297 
2298     /* ============ Public Getters ============ */
2299 
2300     /**
2301      * Constructor function for ModuleCoreStateV2
2302      *
2303      * @param _core                The address of Core
2304      * @param _vault               The address of Vault
2305      * @param _transferProxy       The address of TransferProxy
2306      */
2307     constructor(
2308         ICore _core,
2309         IVault _vault,
2310         ITransferProxy _transferProxy
2311     )
2312         public
2313     {
2314         // Commit passed address to core state variable
2315         coreInstance = _core;
2316 
2317         // Commit passed address to vault state variable
2318         vaultInstance = _vault;
2319 
2320         // Commit passed address to vault state variable
2321         transferProxyInstance = _transferProxy;
2322     }
2323 }
2324 
2325 // File: contracts/core/modules/lib/TokenFlush.sol
2326 
2327 /*
2328     Copyright 2019 Set Labs Inc.
2329 
2330     Licensed under the Apache License, Version 2.0 (the "License");
2331     you may not use this file except in compliance with the License.
2332     You may obtain a copy of the License at
2333 
2334     http://www.apache.org/licenses/LICENSE-2.0
2335 
2336     Unless required by applicable law or agreed to in writing, software
2337     distributed under the License is distributed on an "AS IS" BASIS,
2338     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2339     See the License for the specific language governing permissions and
2340     limitations under the License.
2341 */
2342 
2343 pragma solidity 0.5.7;
2344 
2345 
2346 
2347 
2348 
2349 
2350 
2351 /**
2352  * @title TokenFlush
2353  * @author Set Protocol
2354  *
2355  * The TokenFlush contains utility functions to send tokens and base SetTokens from the
2356  * Vault or Contract to a specified user address
2357  */
2358 contract TokenFlush is
2359     ModuleCoreStateV2
2360 {
2361     using SafeMath for uint256;
2362     using AddressArrayUtils for address[];
2363 
2364     // ============ Internal ============
2365 
2366     /**
2367      * Checks the base SetToken balances on the contract and sends
2368      * any positive quantity to the user directly or into the Vault
2369      * depending on the keepChangeInVault flag.
2370      *
2371      * @param _baseSetAddress             The address of the base SetToken
2372      * @param _returnAddress              The address to send excess tokens to
2373      * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transfered to the user
2374      *                                     or left in the vault
2375      */
2376     function returnExcessBaseSetFromContract(
2377         address _baseSetAddress,
2378         address _returnAddress,
2379         bool _keepChangeInVault
2380     )
2381         internal
2382     {
2383         uint256 baseSetQuantity = ERC20Wrapper.balanceOf(_baseSetAddress, address(this));
2384 
2385         if (baseSetQuantity > 0) {
2386             if (_keepChangeInVault) {
2387                 // Ensure base SetToken allowance
2388                 ERC20Wrapper.ensureAllowance(
2389                     _baseSetAddress,
2390                     address(this),
2391                     address(transferProxyInstance),
2392                     baseSetQuantity
2393                 );
2394 
2395                 // Deposit base SetToken to the user
2396                 coreInstance.depositModule(
2397                     address(this),
2398                     _returnAddress,
2399                     _baseSetAddress,
2400                     baseSetQuantity
2401                 );
2402             } else {
2403                 // Transfer directly to the user
2404                 ERC20Wrapper.transfer(
2405                     _baseSetAddress,
2406                     _returnAddress,
2407                     baseSetQuantity
2408                 );
2409             }
2410         }
2411     }
2412 
2413     /**
2414      * Checks the base SetToken balances in the Vault and sends
2415      * any positive quantity to the user directly or into the Vault
2416      * depending on the keepChangeInVault flag.
2417      *
2418      * @param _baseSetAddress             The address of the base SetToken
2419      * @param _returnAddress              The address to send excess tokens to
2420      * @param  _keepChangeInVault         Boolean signifying whether excess base SetToken is transfered to the user
2421      *                                     or left in the vault
2422      */
2423     function returnExcessBaseSetInVault(
2424         address _baseSetAddress,
2425         address _returnAddress,
2426         bool _keepChangeInVault
2427     )
2428         internal
2429     {
2430         // Return base SetToken if any that are in the Vault
2431         uint256 baseSetQuantityInVault = vaultInstance.getOwnerBalance(
2432             _baseSetAddress,
2433             address(this)
2434         );
2435 
2436         if (baseSetQuantityInVault > 0) {
2437             if (_keepChangeInVault) {
2438                 // Transfer ownership within the vault to the user
2439                 coreInstance.internalTransfer(
2440                     _baseSetAddress,
2441                     _returnAddress,
2442                     baseSetQuantityInVault
2443                 );
2444             } else {
2445                 // Transfer ownership directly to the user
2446                 coreInstance.withdrawModule(
2447                     address(this),
2448                     _returnAddress,
2449                     _baseSetAddress,
2450                     baseSetQuantityInVault
2451                 );
2452             }
2453         }
2454     }
2455 
2456     /**
2457      * Withdraw any base Set components to the user from the contract.
2458      *
2459      * @param _baseSetToken               Instance of the Base SetToken
2460      * @param _returnAddress              The address to send excess tokens to
2461      */
2462     function returnExcessComponentsFromContract(
2463         ISetToken _baseSetToken,
2464         address _returnAddress
2465     )
2466         internal
2467     {
2468         // Return base Set components
2469         address[] memory baseSetComponents = _baseSetToken.getComponents();
2470         for (uint256 i = 0; i < baseSetComponents.length; i++) {
2471             uint256 withdrawQuantity = ERC20Wrapper.balanceOf(baseSetComponents[i], address(this));
2472             if (withdrawQuantity > 0) {
2473                 ERC20Wrapper.transfer(
2474                     baseSetComponents[i],
2475                     _returnAddress,
2476                     withdrawQuantity
2477                 );
2478             }
2479         }
2480     }
2481 
2482     /**
2483      * Any base Set components in the Vault are returned to the caller.
2484      *
2485      * @param _baseSetToken               Instance of the Base SetToken
2486      * @param _returnAddress              The address to send excess tokens to
2487      */
2488     function returnExcessComponentsFromVault(
2489         ISetToken _baseSetToken,
2490         address _returnAddress
2491     )
2492         internal
2493     {
2494         // Return base Set components not used in issuance of base set
2495         address[] memory baseSetComponents = _baseSetToken.getComponents();
2496         for (uint256 i = 0; i < baseSetComponents.length; i++) {
2497             uint256 vaultQuantity = vaultInstance.getOwnerBalance(baseSetComponents[i], address(this));
2498             if (vaultQuantity > 0) {
2499                 coreInstance.withdrawModule(
2500                     address(this),
2501                     _returnAddress,
2502                     baseSetComponents[i],
2503                     vaultQuantity
2504                 );
2505             }
2506         }
2507     }
2508 }
2509 
2510 // File: core/modules/RebalancingSetExchangeIssuanceModule.sol
2511 
2512 /*
2513     Copyright 2019 Set Labs Inc.
2514 
2515     Licensed under the Apache License, Version 2.0 (the "License");
2516     you may not use this file except in compliance with the License.
2517     You may obtain a copy of the License at
2518 
2519     http://www.apache.org/licenses/LICENSE-2.0
2520 
2521     Unless required by applicable law or agreed to in writing, software
2522     distributed under the License is distributed on an "AS IS" BASIS,
2523     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2524     See the License for the specific language governing permissions and
2525     limitations under the License.
2526 */
2527 
2528 pragma solidity 0.5.7;
2529 
2530 
2531 
2532 
2533 
2534 
2535 
2536 
2537 
2538 
2539 
2540 
2541 
2542 
2543 
2544 
2545 /**
2546  * @title RebalancingSetExchangeIssuanceModule
2547  * @author Set Protocol
2548  *
2549  * The RebalancingSetExchangeIssuanceModule supplementary smart contract allows a user to issue and redeem a Rebalancing Set
2550  * using a payment token or receiving a receive token atomically in a single transaction using liquidity from
2551  * decentralized exchanges.
2552  */
2553 contract RebalancingSetExchangeIssuanceModule is
2554     ModuleCoreStateV2,
2555     TokenFlush,
2556     ReentrancyGuard
2557 {
2558     using SafeMath for uint256;
2559 
2560     /* ============ State Variables ============ */
2561 
2562     // Address and instance of ExchangeIssuance Module contract
2563     IExchangeIssuanceModule public exchangeIssuanceModuleInstance;
2564 
2565     // Address and instance of Wrapped Ether contract
2566     IWETH public wethInstance;
2567 
2568     /* ============ Events ============ */
2569 
2570     event LogPayableExchangeIssue(
2571         address indexed rebalancingSetAddress,
2572         address indexed callerAddress,
2573         address paymentTokenAddress,
2574         uint256 rebalancingSetQuantity,
2575         uint256 paymentTokenReturned
2576     );
2577 
2578     event LogPayableExchangeRedeem(
2579         address indexed rebalancingSetAddress,
2580         address indexed callerAddress,
2581         address outputTokenAddress,
2582         uint256 rebalancingSetQuantity,
2583         uint256 outputTokenQuantity
2584     );
2585 
2586     /* ============ Constructor ============ */
2587 
2588     /**
2589      * Constructor function for RebalancingSetExchangeIssuanceModule
2590      *
2591      * @param _core                     The address of Core
2592      * @param _transferProxy            The address of the TransferProxy
2593      * @param _exchangeIssuanceModule   The address of ExchangeIssuanceModule
2594      * @param _wrappedEther             The address of wrapped ether
2595      * @param _vault                    The address of Vault
2596      */
2597     constructor(
2598         ICore _core,
2599         ITransferProxy _transferProxy,
2600         IExchangeIssuanceModule _exchangeIssuanceModule,
2601         IWETH _wrappedEther,
2602         IVault _vault
2603     )
2604         public
2605         ModuleCoreStateV2(
2606             _core,
2607             _vault,
2608             _transferProxy
2609         )
2610     {
2611         // Commit the instance of ExchangeIssuanceModule to state variables
2612         exchangeIssuanceModuleInstance = _exchangeIssuanceModule;
2613 
2614         // Commit the address and instance of Wrapped Ether to state variables
2615         wethInstance = _wrappedEther;
2616 
2617         // Add approvals of Wrapped Ether to the Transfer Proxy
2618         ERC20Wrapper.approve(
2619             address(_wrappedEther),
2620             address(_transferProxy),
2621             CommonMath.maxUInt256()
2622         );
2623     }
2624 
2625     /**
2626      * Fallback function. Disallows ether to be sent to this contract without data except when
2627      * unwrapping WETH.
2628      */
2629     function ()
2630         external
2631         payable
2632     {
2633         require(
2634             msg.sender == address(wethInstance),
2635             "RebalancingSetExchangeIssuanceModule.fallback: Cannot receive ETH directly unless unwrapping WETH"
2636         );
2637     }
2638 
2639     /* ============ Public Functions ============ */
2640 
2641     /**
2642      * Issue a Rebalancing Set using Wrapped Ether to acquire the base components of the Base Set.
2643      * The Base Set is then issued using ExchangeIssue and reissued into the Rebalancing Set.
2644      * All remaining tokens / change are flushed and returned to the user.
2645      *
2646      * @param  _rebalancingSetAddress    Address of the rebalancing Set to issue
2647      * @param  _rebalancingSetQuantity   Quantity of the rebalancing Set
2648      * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
2649      * @param  _orderData                Bytecode encoding exchange data for acquiring base set components
2650      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transferred to the user
2651      *                                     or left in the vault
2652      */
2653     function issueRebalancingSetWithEther(
2654         address _rebalancingSetAddress,
2655         uint256 _rebalancingSetQuantity,
2656         ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
2657         bytes memory _orderData,
2658         bool _keepChangeInVault
2659     )
2660         public
2661         payable
2662         nonReentrant
2663     {
2664         // Wrap all Ether; Wrapped Ether could be a component of the Set being issued.
2665         wethInstance.deposit.value(msg.value)();
2666 
2667         // Perform exchange transactions, mint the base SetToken, and issue the Rebalancing Set to the sender
2668         issueRebalancingSetInternal(
2669             _rebalancingSetAddress,
2670             _rebalancingSetQuantity,
2671             address(wethInstance),
2672             msg.value,
2673             _exchangeIssuanceParams,
2674             _orderData,
2675             _keepChangeInVault
2676         );
2677 
2678         // unwrap any leftover WETH and transfer to sender
2679         uint256 leftoverWeth = ERC20Wrapper.balanceOf(address(wethInstance), address(this));
2680         if (leftoverWeth > 0) {
2681             // Withdraw wrapped Ether
2682             wethInstance.withdraw(leftoverWeth);
2683 
2684             // Transfer ether to user
2685             msg.sender.transfer(leftoverWeth);
2686         }
2687 
2688         emit LogPayableExchangeIssue(
2689             _rebalancingSetAddress,
2690             msg.sender,
2691             address(wethInstance),
2692             _rebalancingSetQuantity,
2693             leftoverWeth
2694         );
2695     }
2696 
2697     /**
2698      * Issue a Rebalancing Set using a specified ERC20 payment token. The payment token is used in ExchangeIssue
2699      * to acquire the base SetToken components and issue the base SetToken. The base SetToken is then used to
2700      * issue the Rebalancing SetToken. The payment token can be utilized as a component of the base SetToken.
2701      * All remaining tokens / change are flushed and returned to the user.
2702      * Ahead of calling this function, the user must approve their paymentToken to the transferProxy.
2703      *
2704      * @param  _rebalancingSetAddress    Address of the rebalancing Set to issue
2705      * @param  _rebalancingSetQuantity   Quantity of the rebalancing Set
2706      * @param  _paymentTokenAddress      Address of the ERC20 token to pay with
2707      * @param  _paymentTokenQuantity     Quantity of the payment token
2708      * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
2709      * @param  _orderData                Bytecode formatted data with exchange data for acquiring base set components
2710      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
2711      *                                     or left in the vault
2712      */
2713     function issueRebalancingSetWithERC20(
2714         address _rebalancingSetAddress,
2715         uint256 _rebalancingSetQuantity,
2716         address _paymentTokenAddress,
2717         uint256 _paymentTokenQuantity,
2718         ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
2719         bytes memory _orderData,
2720         bool _keepChangeInVault
2721     )
2722         public
2723         nonReentrant
2724     {
2725         // Deposit the erc20 to this contract. The token must be approved the caller to the transferProxy
2726         coreInstance.transferModule(
2727             _paymentTokenAddress,
2728             _paymentTokenQuantity,
2729             msg.sender,
2730             address(this)
2731         );
2732 
2733         // Perform exchange transactions, mint the base SetToken, and issue the Rebalancing Set to the sender
2734         issueRebalancingSetInternal(
2735             _rebalancingSetAddress,
2736             _rebalancingSetQuantity,
2737             _paymentTokenAddress,
2738             _paymentTokenQuantity,
2739             _exchangeIssuanceParams,
2740             _orderData,
2741             _keepChangeInVault
2742         );
2743 
2744         // Send back any unused payment token
2745         uint256 leftoverPaymentTokenQuantity = ERC20Wrapper.balanceOf(_paymentTokenAddress, address(this));
2746         if (leftoverPaymentTokenQuantity > 0) {
2747             ERC20Wrapper.transfer(
2748                 _paymentTokenAddress,
2749                 msg.sender,
2750                 leftoverPaymentTokenQuantity
2751             );
2752         }
2753 
2754         emit LogPayableExchangeIssue(
2755             _rebalancingSetAddress,
2756             msg.sender,
2757             _paymentTokenAddress,
2758             _rebalancingSetQuantity,
2759             leftoverPaymentTokenQuantity
2760         );
2761     }
2762 
2763     /**
2764      * Redeems a Rebalancing Set into ether. The Rebalancing Set is redeemed into the Base Set, and
2765      * Base Set components are traded for WETH. The WETH is then withdrawn into ETH and the ETH sent to the caller.
2766      *
2767      * @param  _rebalancingSetAddress    Address of the rebalancing Set
2768      * @param  _rebalancingSetQuantity   Quantity of rebalancing Set to redeem
2769      * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
2770      * @param  _orderData                Bytecode encoding exchange data for disposing base set components
2771      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
2772      *                                     or left in the vault
2773      */
2774     function redeemRebalancingSetIntoEther(
2775         address _rebalancingSetAddress,
2776         uint256 _rebalancingSetQuantity,
2777         ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
2778         bytes memory _orderData,
2779         bool _keepChangeInVault
2780     )
2781         public
2782         nonReentrant
2783     {
2784         // Redeems the rebalancing Set into the base SetToken, redeems the base SetToken into its components,
2785         // and exchanges the components into wrapped ether to this contract.
2786         redeemRebalancingSetIntoComponentsInternal(
2787             _rebalancingSetAddress,
2788             _rebalancingSetQuantity,
2789             address(wethInstance),
2790             _exchangeIssuanceParams,
2791             _orderData
2792         );
2793 
2794         // In the event that exchangeIssue returns more receiveTokens or wrappedEth than
2795         // specified in receiveToken quantity, those tokens are also retrieved into this contract.
2796         // We also call this ahead of returnRedemptionChange to allow the unwrapping of the wrappedEther
2797         uint256 wethQuantityInVault = vaultInstance.getOwnerBalance(address(wethInstance), address(this));
2798         if (wethQuantityInVault > 0) {
2799             coreInstance.withdrawModule(
2800                 address(this),
2801                 address(this),
2802                 address(wethInstance),
2803                 wethQuantityInVault
2804             );
2805         }
2806 
2807         // Unwrap wrapped Ether and transfer Eth to user
2808         uint256 wethBalance = ERC20Wrapper.balanceOf(address(wethInstance), address(this));
2809         if (wethBalance > 0) {
2810             wethInstance.withdraw(wethBalance);
2811             msg.sender.transfer(wethBalance);
2812         }
2813 
2814         address baseSetAddress = _exchangeIssuanceParams.setAddress;
2815 
2816         // Send excess base Set to the user
2817         returnExcessBaseSetFromContract(
2818             baseSetAddress,
2819             msg.sender,
2820             _keepChangeInVault
2821         );
2822 
2823         // Return non-exchanged components to the user
2824         returnExcessComponentsFromContract(ISetToken(baseSetAddress), msg.sender);
2825 
2826         emit LogPayableExchangeRedeem(
2827             _rebalancingSetAddress,
2828             msg.sender,
2829             address(wethInstance),
2830             _rebalancingSetQuantity,
2831             wethBalance
2832         );
2833     }
2834 
2835     /**
2836      * Redeems a Rebalancing Set into a specified ERC20 token. The Rebalancing Set is redeemed into the Base Set, and
2837      * Base Set components are traded for the ERC20 and sent to the caller.
2838      *
2839      * @param  _rebalancingSetAddress    Address of the rebalancing Set
2840      * @param  _rebalancingSetQuantity   Quantity of rebalancing Set to redeem
2841      * @param  _outputTokenAddress       Address of the resulting ERC20 token sent to the user
2842      * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
2843      * @param  _orderData                Bytecode formatted data with exchange data for disposing base set components
2844      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
2845      *                                     or left in the vault
2846      */
2847     function redeemRebalancingSetIntoERC20(
2848         address _rebalancingSetAddress,
2849         uint256 _rebalancingSetQuantity,
2850         address _outputTokenAddress,
2851         ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
2852         bytes memory _orderData,
2853         bool _keepChangeInVault
2854     )
2855         public
2856         nonReentrant
2857     {
2858         // Redeems the rebalancing Set into the base SetToken, redeems the base SetToken into its components,
2859         // and exchanges the components into the receiveToken to this contract.
2860         redeemRebalancingSetIntoComponentsInternal(
2861             _rebalancingSetAddress,
2862             _rebalancingSetQuantity,
2863             _outputTokenAddress,
2864             _exchangeIssuanceParams,
2865             _orderData
2866         );
2867 
2868         // In the event that exchangeIssue returns more outputTokens than
2869         // specified in receiveToken quantity, those tokens are also retrieved into this contract.
2870         uint256 outputTokenInVault = vaultInstance.getOwnerBalance(_outputTokenAddress, address(this));
2871         if (outputTokenInVault > 0) {
2872             coreInstance.withdrawModule(
2873                 address(this),
2874                 address(this),
2875                 _outputTokenAddress,
2876                 outputTokenInVault
2877             );
2878         }
2879 
2880         // Transfer outputToken to the caller
2881         uint256 outputTokenBalance = ERC20Wrapper.balanceOf(_outputTokenAddress, address(this));
2882         ERC20Wrapper.transfer(
2883             _outputTokenAddress,
2884             msg.sender,
2885             outputTokenBalance
2886         );
2887 
2888         address baseSetAddress = _exchangeIssuanceParams.setAddress;
2889 
2890         // Send excess base SetToken to the user
2891         returnExcessBaseSetFromContract(
2892             baseSetAddress,
2893             msg.sender,
2894             _keepChangeInVault
2895         );
2896 
2897         // Non-exchanged base SetToken components are returned to the user
2898         returnExcessComponentsFromContract(ISetToken(baseSetAddress), msg.sender);
2899 
2900         emit LogPayableExchangeRedeem(
2901             _rebalancingSetAddress,
2902             msg.sender,
2903             _outputTokenAddress,
2904             _rebalancingSetQuantity,
2905             outputTokenBalance
2906         );
2907     }
2908 
2909 
2910     /* ============ Private Functions ============ */
2911 
2912     /**
2913      * Validate that the issuance parameters and inputs are congruent.
2914      *
2915      * @param  _transactTokenAddress     Address of the sendToken (issue) or receiveToken (redeem)
2916      * @param  _rebalancingSetAddress    Address of the rebalancing SetToken
2917      * @param  _rebalancingSetQuantity   Quantity of rebalancing SetToken to issue or redeem
2918      * @param  _baseSetAddress           Address of base SetToken in ExchangeIssueanceParams
2919      * @param  _transactTokenArray       List of addresses of send tokens (during issuance) and
2920      *                                     receive tokens (during redemption)
2921      */
2922     function validateExchangeIssuanceInputs(
2923         address _transactTokenAddress,
2924         IRebalancingSetToken _rebalancingSetAddress,
2925         uint256 _rebalancingSetQuantity,
2926         address _baseSetAddress,
2927         address[] memory _transactTokenArray
2928     )
2929         private
2930         view
2931     {
2932         // Expect rebalancing SetToken to be valid and enabled SetToken
2933         require(
2934             coreInstance.validSets(address(_rebalancingSetAddress)),
2935             "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Invalid or disabled SetToken address"
2936         );
2937 
2938         require(
2939             _rebalancingSetQuantity > 0,
2940             "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Quantity must be > 0"
2941         );
2942 
2943         // Make sure Issuance quantity is multiple of the rebalancing SetToken natural unit
2944         require(
2945             _rebalancingSetQuantity.mod(_rebalancingSetAddress.naturalUnit()) == 0,
2946             "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Quantity must be multiple of natural unit"
2947         );
2948 
2949         // Multiple items are allowed on the transactTokenArray. Specifically, this allows there to be
2950         // multiple sendToken items that are directed to the various exchangeWrappers.
2951         // The receiveTokenArray is implicitly limited to a single item, as the exchangeIssuanceModuleInstance
2952         // checks that the receive tokens do not have duplicates
2953         for (uint256 i = 0; i < _transactTokenArray.length; i++) {
2954             // The transact token array tokens must match the transact token.
2955             require(
2956                 _transactTokenAddress == _transactTokenArray[i],
2957                 "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Send/Receive token must match transact token"
2958             );
2959         }
2960 
2961         // Validate that the base Set address matches the issuanceParams Set Address
2962         address baseSet = _rebalancingSetAddress.currentSet();
2963         require(
2964             baseSet == _baseSetAddress,
2965             "RebalancingSetExchangeIssuance.validateExchangeIssuanceInputs: Base Set addresses must match"
2966         );
2967     }
2968 
2969     /**
2970      * Issue a Rebalancing Set using a specified ERC20 payment token. The payment token is used in ExchangeIssue
2971      * to acquire the base SetToken components and issue the base SetToken. The base SetToken is then used to
2972      * issue the Rebalancing SetToken. The payment token can be utilized as a component of the base SetToken.
2973      * All remaining tokens / change are flushed and returned to the user.
2974      *
2975      * Note: We do not validate the rebalancing SetToken quantity and the exchangeIssuanceParams base SetToken
2976      * quantity. Thus there could be extra base SetToken (or change) generated.
2977      *
2978      * @param  _rebalancingSetAddress    Address of the rebalancing Set to issue
2979      * @param  _rebalancingSetQuantity   Quantity of the rebalancing Set
2980      * @param  _paymentTokenAddress      Address of the ERC20 token to pay with
2981      * @param  _paymentTokenQuantity     Quantity of the payment token
2982      * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
2983      * @param  _orderData                Bytecode formatted data with exchange data for acquiring base set components
2984      * @param  _keepChangeInVault        Boolean signifying whether excess base SetToken is transfered to the user
2985      *                                     or left in the vault
2986      */
2987     function issueRebalancingSetInternal(
2988         address _rebalancingSetAddress,
2989         uint256 _rebalancingSetQuantity,
2990         address _paymentTokenAddress,
2991         uint256 _paymentTokenQuantity,
2992         ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
2993         bytes memory _orderData,
2994         bool _keepChangeInVault
2995     )
2996         private
2997     {
2998         address baseSetAddress = _exchangeIssuanceParams.setAddress;
2999         uint256 baseSetIssueQuantity = _exchangeIssuanceParams.quantity;
3000 
3001         // Validate parameters
3002         validateExchangeIssuanceInputs(
3003             _paymentTokenAddress,
3004             IRebalancingSetToken(_rebalancingSetAddress),
3005             _rebalancingSetQuantity,
3006             baseSetAddress,
3007             _exchangeIssuanceParams.sendTokens
3008         );
3009 
3010         // Ensure payment token allowance to the TransferProxy
3011         // Note that the paymentToken may also be used as a component to issue the Set
3012         // So the paymentTokenQuantity must be used vs. the exchangeIssuanceParams sendToken quantity
3013         ERC20Wrapper.ensureAllowance(
3014             _paymentTokenAddress,
3015             address(this),
3016             address(transferProxyInstance),
3017             _paymentTokenQuantity
3018         );
3019 
3020         // Atomically trade paymentToken for base SetToken components and mint the base SetToken
3021         exchangeIssuanceModuleInstance.exchangeIssue(
3022             _exchangeIssuanceParams,
3023             _orderData
3024         );
3025 
3026         // Approve base SetToken to transferProxy for minting rebalancing SetToken
3027         ERC20Wrapper.ensureAllowance(
3028             baseSetAddress,
3029             address(this),
3030             address(transferProxyInstance),
3031             baseSetIssueQuantity
3032         );
3033 
3034         // Issue rebalancing SetToken to the caller
3035         coreInstance.issueTo(
3036             msg.sender,
3037             _rebalancingSetAddress,
3038             _rebalancingSetQuantity
3039         );
3040 
3041         // Send excess base Set held in this contract to the user
3042         // If keepChangeInVault is true, the baseSetToken is held in the Vault
3043         // which is a UX improvement
3044         returnExcessBaseSetFromContract(
3045             baseSetAddress,
3046             msg.sender,
3047             _keepChangeInVault
3048         );
3049 
3050         // Return any extra components acquired during exchangeIssue to the user
3051         returnExcessComponentsFromVault(ISetToken(baseSetAddress), msg.sender);
3052     }
3053 
3054     /**
3055      * Redeems a Rebalancing Set into the receiveToken. The Rebalancing Set is redeemed into the Base Set, and
3056      * Base Set components are traded for the receiveToken located in this contract.
3057      *
3058      * Note: We do not validate the rebalancing SetToken quantity and the exchangeIssuanceParams base SetToken
3059      * quantity. Thus there could be extra base SetToken (or change) generated.
3060      *
3061      * @param  _rebalancingSetAddress    Address of the rebalancing Set
3062      * @param  _rebalancingSetQuantity   Quantity of rebalancing Set to redeem
3063      * @param  _receiveTokenAddress      Address of the receiveToken
3064      * @param  _exchangeIssuanceParams   Struct containing data around the base Set issuance
3065      * @param  _orderData                Bytecode formatted data with exchange data for disposing base set components
3066      */
3067     function redeemRebalancingSetIntoComponentsInternal(
3068         address _rebalancingSetAddress,
3069         uint256 _rebalancingSetQuantity,
3070         address _receiveTokenAddress,
3071         ExchangeIssuanceLibrary.ExchangeIssuanceParams memory _exchangeIssuanceParams,
3072         bytes memory _orderData
3073     )
3074         private
3075     {
3076         // Validate Params
3077         validateExchangeIssuanceInputs(
3078             _receiveTokenAddress,
3079             IRebalancingSetToken(_rebalancingSetAddress),
3080             _rebalancingSetQuantity,
3081             _exchangeIssuanceParams.setAddress,
3082             _exchangeIssuanceParams.receiveTokens
3083         );
3084 
3085         // Redeem rebalancing Set into the base SetToken from the user to this contract in the Vault
3086         coreInstance.redeemModule(
3087             msg.sender,
3088             address(this),
3089             _rebalancingSetAddress,
3090             _rebalancingSetQuantity
3091         );
3092 
3093         address baseSetAddress = _exchangeIssuanceParams.setAddress;
3094         uint256 baseSetVaultQuantity = vaultInstance.getOwnerBalance(baseSetAddress, address(this));
3095 
3096         // Withdraw base SetToken from Vault to this contract
3097         coreInstance.withdrawModule(
3098             address(this),
3099             address(this),
3100             baseSetAddress,
3101             baseSetVaultQuantity
3102         );
3103 
3104         // Redeem base SetToken into components and perform trades / exchanges
3105         // into the receiveToken. The receiveTokens are transferred to this contract
3106         // as well as the remaining non-exchanged components
3107         exchangeIssuanceModuleInstance.exchangeRedeem(
3108             _exchangeIssuanceParams,
3109             _orderData
3110         );
3111     }
3112 }