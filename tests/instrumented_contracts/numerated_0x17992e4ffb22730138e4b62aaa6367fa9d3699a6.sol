1 /*
2 
3   Copyright 2018 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 
21 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
22 /// @author Stefan George - <stefan.george@consensys.net>
23 contract MultiSigWallet {
24 
25     /*
26      *  Events
27      */
28     event Confirmation(address indexed sender, uint indexed transactionId);
29     event Revocation(address indexed sender, uint indexed transactionId);
30     event Submission(uint indexed transactionId);
31     event Execution(uint indexed transactionId);
32     event ExecutionFailure(uint indexed transactionId);
33     event Deposit(address indexed sender, uint value);
34     event OwnerAddition(address indexed owner);
35     event OwnerRemoval(address indexed owner);
36     event RequirementChange(uint required);
37 
38     /*
39      *  Constants
40      */
41     uint constant public MAX_OWNER_COUNT = 50;
42 
43     /*
44      *  Storage
45      */
46     mapping (uint => Transaction) public transactions;
47     mapping (uint => mapping (address => bool)) public confirmations;
48     mapping (address => bool) public isOwner;
49     address[] public owners;
50     uint public required;
51     uint public transactionCount;
52 
53     struct Transaction {
54         address destination;
55         uint value;
56         bytes data;
57         bool executed;
58     }
59 
60     /*
61      *  Modifiers
62      */
63     modifier onlyWallet() {
64         require(msg.sender == address(this));
65         _;
66     }
67 
68     modifier ownerDoesNotExist(address owner) {
69         require(!isOwner[owner]);
70         _;
71     }
72 
73     modifier ownerExists(address owner) {
74         require(isOwner[owner]);
75         _;
76     }
77 
78     modifier transactionExists(uint transactionId) {
79         require(transactions[transactionId].destination != 0);
80         _;
81     }
82 
83     modifier confirmed(uint transactionId, address owner) {
84         require(confirmations[transactionId][owner]);
85         _;
86     }
87 
88     modifier notConfirmed(uint transactionId, address owner) {
89         require(!confirmations[transactionId][owner]);
90         _;
91     }
92 
93     modifier notExecuted(uint transactionId) {
94         require(!transactions[transactionId].executed);
95         _;
96     }
97 
98     modifier notNull(address _address) {
99         require(_address != 0);
100         _;
101     }
102 
103     modifier validRequirement(uint ownerCount, uint _required) {
104         require(ownerCount <= MAX_OWNER_COUNT
105             && _required <= ownerCount
106             && _required != 0
107             && ownerCount != 0);
108         _;
109     }
110 
111     /// @dev Fallback function allows to deposit ether.
112     function()
113         payable
114     {
115         if (msg.value > 0)
116             Deposit(msg.sender, msg.value);
117     }
118 
119     /*
120      * Public functions
121      */
122     /// @dev Contract constructor sets initial owners and required number of confirmations.
123     /// @param _owners List of initial owners.
124     /// @param _required Number of required confirmations.
125     function MultiSigWallet(address[] _owners, uint _required)
126         public
127         validRequirement(_owners.length, _required)
128     {
129         for (uint i=0; i<_owners.length; i++) {
130             require(!isOwner[_owners[i]] && _owners[i] != 0);
131             isOwner[_owners[i]] = true;
132         }
133         owners = _owners;
134         required = _required;
135     }
136 
137     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
138     /// @param owner Address of new owner.
139     function addOwner(address owner)
140         public
141         onlyWallet
142         ownerDoesNotExist(owner)
143         notNull(owner)
144         validRequirement(owners.length + 1, required)
145     {
146         isOwner[owner] = true;
147         owners.push(owner);
148         OwnerAddition(owner);
149     }
150 
151     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
152     /// @param owner Address of owner.
153     function removeOwner(address owner)
154         public
155         onlyWallet
156         ownerExists(owner)
157     {
158         isOwner[owner] = false;
159         for (uint i=0; i<owners.length - 1; i++)
160             if (owners[i] == owner) {
161                 owners[i] = owners[owners.length - 1];
162                 break;
163             }
164         owners.length -= 1;
165         if (required > owners.length)
166             changeRequirement(owners.length);
167         OwnerRemoval(owner);
168     }
169 
170     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
171     /// @param owner Address of owner to be replaced.
172     /// @param newOwner Address of new owner.
173     function replaceOwner(address owner, address newOwner)
174         public
175         onlyWallet
176         ownerExists(owner)
177         ownerDoesNotExist(newOwner)
178     {
179         for (uint i=0; i<owners.length; i++)
180             if (owners[i] == owner) {
181                 owners[i] = newOwner;
182                 break;
183             }
184         isOwner[owner] = false;
185         isOwner[newOwner] = true;
186         OwnerRemoval(owner);
187         OwnerAddition(newOwner);
188     }
189 
190     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
191     /// @param _required Number of required confirmations.
192     function changeRequirement(uint _required)
193         public
194         onlyWallet
195         validRequirement(owners.length, _required)
196     {
197         required = _required;
198         RequirementChange(_required);
199     }
200 
201     /// @dev Allows an owner to submit and confirm a transaction.
202     /// @param destination Transaction target address.
203     /// @param value Transaction ether value.
204     /// @param data Transaction data payload.
205     /// @return Returns transaction ID.
206     function submitTransaction(address destination, uint value, bytes data)
207         public
208         returns (uint transactionId)
209     {
210         transactionId = addTransaction(destination, value, data);
211         confirmTransaction(transactionId);
212     }
213 
214     /// @dev Allows an owner to confirm a transaction.
215     /// @param transactionId Transaction ID.
216     function confirmTransaction(uint transactionId)
217         public
218         ownerExists(msg.sender)
219         transactionExists(transactionId)
220         notConfirmed(transactionId, msg.sender)
221     {
222         confirmations[transactionId][msg.sender] = true;
223         Confirmation(msg.sender, transactionId);
224         executeTransaction(transactionId);
225     }
226 
227     /// @dev Allows an owner to revoke a confirmation for a transaction.
228     /// @param transactionId Transaction ID.
229     function revokeConfirmation(uint transactionId)
230         public
231         ownerExists(msg.sender)
232         confirmed(transactionId, msg.sender)
233         notExecuted(transactionId)
234     {
235         confirmations[transactionId][msg.sender] = false;
236         Revocation(msg.sender, transactionId);
237     }
238 
239     /// @dev Allows anyone to execute a confirmed transaction.
240     /// @param transactionId Transaction ID.
241     function executeTransaction(uint transactionId)
242         public
243         ownerExists(msg.sender)
244         confirmed(transactionId, msg.sender)
245         notExecuted(transactionId)
246     {
247         if (isConfirmed(transactionId)) {
248             Transaction storage txn = transactions[transactionId];
249             txn.executed = true;
250             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
251                 Execution(transactionId);
252             else {
253                 ExecutionFailure(transactionId);
254                 txn.executed = false;
255             }
256         }
257     }
258 
259     // call has been separated into its own function in order to take advantage
260     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
261     function external_call(address destination, uint value, uint dataLength, bytes data) internal returns (bool) {
262         bool result;
263         assembly {
264             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
265             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
266             result := call(
267                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
268                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
269                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
270                 destination,
271                 value,
272                 d,
273                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
274                 x,
275                 0                  // Output is ignored, therefore the output size is zero
276             )
277         }
278         return result;
279     }
280 
281     /// @dev Returns the confirmation status of a transaction.
282     /// @param transactionId Transaction ID.
283     /// @return Confirmation status.
284     function isConfirmed(uint transactionId)
285         public
286         constant
287         returns (bool)
288     {
289         uint count = 0;
290         for (uint i=0; i<owners.length; i++) {
291             if (confirmations[transactionId][owners[i]])
292                 count += 1;
293             if (count == required)
294                 return true;
295         }
296     }
297 
298     /*
299      * Internal functions
300      */
301     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
302     /// @param destination Transaction target address.
303     /// @param value Transaction ether value.
304     /// @param data Transaction data payload.
305     /// @return Returns transaction ID.
306     function addTransaction(address destination, uint value, bytes data)
307         internal
308         notNull(destination)
309         returns (uint transactionId)
310     {
311         transactionId = transactionCount;
312         transactions[transactionId] = Transaction({
313             destination: destination,
314             value: value,
315             data: data,
316             executed: false
317         });
318         transactionCount += 1;
319         Submission(transactionId);
320     }
321 
322     /*
323      * Web3 call functions
324      */
325     /// @dev Returns number of confirmations of a transaction.
326     /// @param transactionId Transaction ID.
327     /// @return Number of confirmations.
328     function getConfirmationCount(uint transactionId)
329         public
330         constant
331         returns (uint count)
332     {
333         for (uint i=0; i<owners.length; i++)
334             if (confirmations[transactionId][owners[i]])
335                 count += 1;
336     }
337 
338     /// @dev Returns total number of transactions after filers are applied.
339     /// @param pending Include pending transactions.
340     /// @param executed Include executed transactions.
341     /// @return Total number of transactions after filters are applied.
342     function getTransactionCount(bool pending, bool executed)
343         public
344         constant
345         returns (uint count)
346     {
347         for (uint i=0; i<transactionCount; i++)
348             if (   pending && !transactions[i].executed
349                 || executed && transactions[i].executed)
350                 count += 1;
351     }
352 
353     /// @dev Returns list of owners.
354     /// @return List of owner addresses.
355     function getOwners()
356         public
357         constant
358         returns (address[])
359     {
360         return owners;
361     }
362 
363     /// @dev Returns array with owner addresses, which confirmed transaction.
364     /// @param transactionId Transaction ID.
365     /// @return Returns array of owner addresses.
366     function getConfirmations(uint transactionId)
367         public
368         constant
369         returns (address[] _confirmations)
370     {
371         address[] memory confirmationsTemp = new address[](owners.length);
372         uint count = 0;
373         uint i;
374         for (i=0; i<owners.length; i++)
375             if (confirmations[transactionId][owners[i]]) {
376                 confirmationsTemp[count] = owners[i];
377                 count += 1;
378             }
379         _confirmations = new address[](count);
380         for (i=0; i<count; i++)
381             _confirmations[i] = confirmationsTemp[i];
382     }
383 
384     /// @dev Returns list of transaction IDs in defined range.
385     /// @param from Index start position of transaction array.
386     /// @param to Index end position of transaction array.
387     /// @param pending Include pending transactions.
388     /// @param executed Include executed transactions.
389     /// @return Returns array of transaction IDs.
390     function getTransactionIds(uint from, uint to, bool pending, bool executed)
391         public
392         constant
393         returns (uint[] _transactionIds)
394     {
395         uint[] memory transactionIdsTemp = new uint[](transactionCount);
396         uint count = 0;
397         uint i;
398         for (i=0; i<transactionCount; i++)
399             if (   pending && !transactions[i].executed
400                 || executed && transactions[i].executed)
401             {
402                 transactionIdsTemp[count] = i;
403                 count += 1;
404             }
405         _transactionIds = new uint[](to - from);
406         for (i=from; i<to; i++)
407             _transactionIds[i - from] = transactionIdsTemp[i];
408     }
409 }
410 
411 /// @title Multisignature wallet with time lock- Allows multiple parties to execute a transaction after a time lock has passed.
412 /// @author Amir Bandeali - <amir@0xProject.com>
413 // solhint-disable not-rely-on-time
414 contract MultiSigWalletWithTimeLock is
415     MultiSigWallet
416 {
417     event ConfirmationTimeSet(uint256 indexed transactionId, uint256 confirmationTime);
418     event TimeLockChange(uint256 secondsTimeLocked);
419 
420     uint256 public secondsTimeLocked;
421 
422     mapping (uint256 => uint256) public confirmationTimes;
423 
424     modifier notFullyConfirmed(uint256 transactionId) {
425         require(
426             !isConfirmed(transactionId),
427             "TX_FULLY_CONFIRMED"
428         );
429         _;
430     }
431 
432     modifier fullyConfirmed(uint256 transactionId) {
433         require(
434             isConfirmed(transactionId),
435             "TX_NOT_FULLY_CONFIRMED"
436         );
437         _;
438     }
439 
440     modifier pastTimeLock(uint256 transactionId) {
441         require(
442             block.timestamp >= confirmationTimes[transactionId] + secondsTimeLocked,
443             "TIME_LOCK_INCOMPLETE"
444         );
445         _;
446     }
447 
448     /// @dev Contract constructor sets initial owners, required number of confirmations, and time lock.
449     /// @param _owners List of initial owners.
450     /// @param _required Number of required confirmations.
451     /// @param _secondsTimeLocked Duration needed after a transaction is confirmed and before it becomes executable, in seconds.
452     constructor (
453         address[] _owners,
454         uint256 _required,
455         uint256 _secondsTimeLocked
456     )
457         public
458         MultiSigWallet(_owners, _required)
459     {
460         secondsTimeLocked = _secondsTimeLocked;
461     }
462 
463     /// @dev Changes the duration of the time lock for transactions.
464     /// @param _secondsTimeLocked Duration needed after a transaction is confirmed and before it becomes executable, in seconds.
465     function changeTimeLock(uint256 _secondsTimeLocked)
466         public
467         onlyWallet
468     {
469         secondsTimeLocked = _secondsTimeLocked;
470         emit TimeLockChange(_secondsTimeLocked);
471     }
472 
473     /// @dev Allows an owner to confirm a transaction.
474     /// @param transactionId Transaction ID.
475     function confirmTransaction(uint256 transactionId)
476         public
477         ownerExists(msg.sender)
478         transactionExists(transactionId)
479         notConfirmed(transactionId, msg.sender)
480         notFullyConfirmed(transactionId)
481     {
482         confirmations[transactionId][msg.sender] = true;
483         emit Confirmation(msg.sender, transactionId);
484         if (isConfirmed(transactionId)) {
485             setConfirmationTime(transactionId, block.timestamp);
486         }
487     }
488 
489     /// @dev Allows anyone to execute a confirmed transaction.
490     /// @param transactionId Transaction ID.
491     function executeTransaction(uint256 transactionId)
492         public
493         notExecuted(transactionId)
494         fullyConfirmed(transactionId)
495         pastTimeLock(transactionId)
496     {
497         Transaction storage txn = transactions[transactionId];
498         txn.executed = true;
499         if (external_call(txn.destination, txn.value, txn.data.length, txn.data)) {
500             emit Execution(transactionId);
501         } else {
502             emit ExecutionFailure(transactionId);
503             txn.executed = false;
504         }
505     }
506 
507     /// @dev Sets the time of when a submission first passed.
508     function setConfirmationTime(uint256 transactionId, uint256 confirmationTime)
509         internal
510     {
511         confirmationTimes[transactionId] = confirmationTime;
512         emit ConfirmationTimeSet(transactionId, confirmationTime);
513     }
514 }
515 
516 library LibBytes {
517 
518     using LibBytes for bytes;
519 
520     /// @dev Gets the memory address for a byte array.
521     /// @param input Byte array to lookup.
522     /// @return memoryAddress Memory address of byte array. This
523     ///         points to the header of the byte array which contains
524     ///         the length.
525     function rawAddress(bytes memory input)
526         internal
527         pure
528         returns (uint256 memoryAddress)
529     {
530         assembly {
531             memoryAddress := input
532         }
533         return memoryAddress;
534     }
535     
536     /// @dev Gets the memory address for the contents of a byte array.
537     /// @param input Byte array to lookup.
538     /// @return memoryAddress Memory address of the contents of the byte array.
539     function contentAddress(bytes memory input)
540         internal
541         pure
542         returns (uint256 memoryAddress)
543     {
544         assembly {
545             memoryAddress := add(input, 32)
546         }
547         return memoryAddress;
548     }
549 
550     /// @dev Copies `length` bytes from memory location `source` to `dest`.
551     /// @param dest memory address to copy bytes to.
552     /// @param source memory address to copy bytes from.
553     /// @param length number of bytes to copy.
554     function memCopy(
555         uint256 dest,
556         uint256 source,
557         uint256 length
558     )
559         internal
560         pure
561     {
562         if (length < 32) {
563             // Handle a partial word by reading destination and masking
564             // off the bits we are interested in.
565             // This correctly handles overlap, zero lengths and source == dest
566             assembly {
567                 let mask := sub(exp(256, sub(32, length)), 1)
568                 let s := and(mload(source), not(mask))
569                 let d := and(mload(dest), mask)
570                 mstore(dest, or(s, d))
571             }
572         } else {
573             // Skip the O(length) loop when source == dest.
574             if (source == dest) {
575                 return;
576             }
577 
578             // For large copies we copy whole words at a time. The final
579             // word is aligned to the end of the range (instead of after the
580             // previous) to handle partial words. So a copy will look like this:
581             //
582             //  ####
583             //      ####
584             //          ####
585             //            ####
586             //
587             // We handle overlap in the source and destination range by
588             // changing the copying direction. This prevents us from
589             // overwriting parts of source that we still need to copy.
590             //
591             // This correctly handles source == dest
592             //
593             if (source > dest) {
594                 assembly {
595                     // We subtract 32 from `sEnd` and `dEnd` because it
596                     // is easier to compare with in the loop, and these
597                     // are also the addresses we need for copying the
598                     // last bytes.
599                     length := sub(length, 32)
600                     let sEnd := add(source, length)
601                     let dEnd := add(dest, length)
602 
603                     // Remember the last 32 bytes of source
604                     // This needs to be done here and not after the loop
605                     // because we may have overwritten the last bytes in
606                     // source already due to overlap.
607                     let last := mload(sEnd)
608 
609                     // Copy whole words front to back
610                     // Note: the first check is always true,
611                     // this could have been a do-while loop.
612                     // solhint-disable-next-line no-empty-blocks
613                     for {} lt(source, sEnd) {} {
614                         mstore(dest, mload(source))
615                         source := add(source, 32)
616                         dest := add(dest, 32)
617                     }
618                     
619                     // Write the last 32 bytes
620                     mstore(dEnd, last)
621                 }
622             } else {
623                 assembly {
624                     // We subtract 32 from `sEnd` and `dEnd` because those
625                     // are the starting points when copying a word at the end.
626                     length := sub(length, 32)
627                     let sEnd := add(source, length)
628                     let dEnd := add(dest, length)
629 
630                     // Remember the first 32 bytes of source
631                     // This needs to be done here and not after the loop
632                     // because we may have overwritten the first bytes in
633                     // source already due to overlap.
634                     let first := mload(source)
635 
636                     // Copy whole words back to front
637                     // We use a signed comparisson here to allow dEnd to become
638                     // negative (happens when source and dest < 32). Valid
639                     // addresses in local memory will never be larger than
640                     // 2**255, so they can be safely re-interpreted as signed.
641                     // Note: the first check is always true,
642                     // this could have been a do-while loop.
643                     // solhint-disable-next-line no-empty-blocks
644                     for {} slt(dest, dEnd) {} {
645                         mstore(dEnd, mload(sEnd))
646                         sEnd := sub(sEnd, 32)
647                         dEnd := sub(dEnd, 32)
648                     }
649                     
650                     // Write the first 32 bytes
651                     mstore(dest, first)
652                 }
653             }
654         }
655     }
656 
657     /// @dev Returns a slices from a byte array.
658     /// @param b The byte array to take a slice from.
659     /// @param from The starting index for the slice (inclusive).
660     /// @param to The final index for the slice (exclusive).
661     /// @return result The slice containing bytes at indices [from, to)
662     function slice(
663         bytes memory b,
664         uint256 from,
665         uint256 to
666     )
667         internal
668         pure
669         returns (bytes memory result)
670     {
671         require(
672             from <= to,
673             "FROM_LESS_THAN_TO_REQUIRED"
674         );
675         require(
676             to < b.length,
677             "TO_LESS_THAN_LENGTH_REQUIRED"
678         );
679         
680         // Create a new bytes structure and copy contents
681         result = new bytes(to - from);
682         memCopy(
683             result.contentAddress(),
684             b.contentAddress() + from,
685             result.length
686         );
687         return result;
688     }
689     
690     /// @dev Returns a slice from a byte array without preserving the input.
691     /// @param b The byte array to take a slice from. Will be destroyed in the process.
692     /// @param from The starting index for the slice (inclusive).
693     /// @param to The final index for the slice (exclusive).
694     /// @return result The slice containing bytes at indices [from, to)
695     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
696     function sliceDestructive(
697         bytes memory b,
698         uint256 from,
699         uint256 to
700     )
701         internal
702         pure
703         returns (bytes memory result)
704     {
705         require(
706             from <= to,
707             "FROM_LESS_THAN_TO_REQUIRED"
708         );
709         require(
710             to < b.length,
711             "TO_LESS_THAN_LENGTH_REQUIRED"
712         );
713         
714         // Create a new bytes structure around [from, to) in-place.
715         assembly {
716             result := add(b, from)
717             mstore(result, sub(to, from))
718         }
719         return result;
720     }
721 
722     /// @dev Pops the last byte off of a byte array by modifying its length.
723     /// @param b Byte array that will be modified.
724     /// @return The byte that was popped off.
725     function popLastByte(bytes memory b)
726         internal
727         pure
728         returns (bytes1 result)
729     {
730         require(
731             b.length > 0,
732             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
733         );
734 
735         // Store last byte.
736         result = b[b.length - 1];
737 
738         assembly {
739             // Decrement length of byte array.
740             let newLen := sub(mload(b), 1)
741             mstore(b, newLen)
742         }
743         return result;
744     }
745 
746     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
747     /// @param b Byte array that will be modified.
748     /// @return The 20 byte address that was popped off.
749     function popLast20Bytes(bytes memory b)
750         internal
751         pure
752         returns (address result)
753     {
754         require(
755             b.length >= 20,
756             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
757         );
758 
759         // Store last 20 bytes.
760         result = readAddress(b, b.length - 20);
761 
762         assembly {
763             // Subtract 20 from byte array length.
764             let newLen := sub(mload(b), 20)
765             mstore(b, newLen)
766         }
767         return result;
768     }
769 
770     /// @dev Tests equality of two byte arrays.
771     /// @param lhs First byte array to compare.
772     /// @param rhs Second byte array to compare.
773     /// @return True if arrays are the same. False otherwise.
774     function equals(
775         bytes memory lhs,
776         bytes memory rhs
777     )
778         internal
779         pure
780         returns (bool equal)
781     {
782         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
783         // We early exit on unequal lengths, but keccak would also correctly
784         // handle this.
785         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
786     }
787 
788     /// @dev Reads an address from a position in a byte array.
789     /// @param b Byte array containing an address.
790     /// @param index Index in byte array of address.
791     /// @return address from byte array.
792     function readAddress(
793         bytes memory b,
794         uint256 index
795     )
796         internal
797         pure
798         returns (address result)
799     {
800         require(
801             b.length >= index + 20,  // 20 is length of address
802             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
803         );
804 
805         // Add offset to index:
806         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
807         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
808         index += 20;
809 
810         // Read address from array memory
811         assembly {
812             // 1. Add index to address of bytes array
813             // 2. Load 32-byte word from memory
814             // 3. Apply 20-byte mask to obtain address
815             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
816         }
817         return result;
818     }
819 
820     /// @dev Writes an address into a specific position in a byte array.
821     /// @param b Byte array to insert address into.
822     /// @param index Index in byte array of address.
823     /// @param input Address to put into byte array.
824     function writeAddress(
825         bytes memory b,
826         uint256 index,
827         address input
828     )
829         internal
830         pure
831     {
832         require(
833             b.length >= index + 20,  // 20 is length of address
834             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
835         );
836 
837         // Add offset to index:
838         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
839         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
840         index += 20;
841 
842         // Store address into array memory
843         assembly {
844             // The address occupies 20 bytes and mstore stores 32 bytes.
845             // First fetch the 32-byte word where we'll be storing the address, then
846             // apply a mask so we have only the bytes in the word that the address will not occupy.
847             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
848 
849             // 1. Add index to address of bytes array
850             // 2. Load 32-byte word from memory
851             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
852             let neighbors := and(
853                 mload(add(b, index)),
854                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
855             )
856             
857             // Make sure input address is clean.
858             // (Solidity does not guarantee this)
859             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
860 
861             // Store the neighbors and address into memory
862             mstore(add(b, index), xor(input, neighbors))
863         }
864     }
865 
866     /// @dev Reads a bytes32 value from a position in a byte array.
867     /// @param b Byte array containing a bytes32 value.
868     /// @param index Index in byte array of bytes32 value.
869     /// @return bytes32 value from byte array.
870     function readBytes32(
871         bytes memory b,
872         uint256 index
873     )
874         internal
875         pure
876         returns (bytes32 result)
877     {
878         require(
879             b.length >= index + 32,
880             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
881         );
882 
883         // Arrays are prefixed by a 256 bit length parameter
884         index += 32;
885 
886         // Read the bytes32 from array memory
887         assembly {
888             result := mload(add(b, index))
889         }
890         return result;
891     }
892 
893     /// @dev Writes a bytes32 into a specific position in a byte array.
894     /// @param b Byte array to insert <input> into.
895     /// @param index Index in byte array of <input>.
896     /// @param input bytes32 to put into byte array.
897     function writeBytes32(
898         bytes memory b,
899         uint256 index,
900         bytes32 input
901     )
902         internal
903         pure
904     {
905         require(
906             b.length >= index + 32,
907             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
908         );
909 
910         // Arrays are prefixed by a 256 bit length parameter
911         index += 32;
912 
913         // Read the bytes32 from array memory
914         assembly {
915             mstore(add(b, index), input)
916         }
917     }
918 
919     /// @dev Reads a uint256 value from a position in a byte array.
920     /// @param b Byte array containing a uint256 value.
921     /// @param index Index in byte array of uint256 value.
922     /// @return uint256 value from byte array.
923     function readUint256(
924         bytes memory b,
925         uint256 index
926     )
927         internal
928         pure
929         returns (uint256 result)
930     {
931         result = uint256(readBytes32(b, index));
932         return result;
933     }
934 
935     /// @dev Writes a uint256 into a specific position in a byte array.
936     /// @param b Byte array to insert <input> into.
937     /// @param index Index in byte array of <input>.
938     /// @param input uint256 to put into byte array.
939     function writeUint256(
940         bytes memory b,
941         uint256 index,
942         uint256 input
943     )
944         internal
945         pure
946     {
947         writeBytes32(b, index, bytes32(input));
948     }
949 
950     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
951     /// @param b Byte array containing a bytes4 value.
952     /// @param index Index in byte array of bytes4 value.
953     /// @return bytes4 value from byte array.
954     function readBytes4(
955         bytes memory b,
956         uint256 index
957     )
958         internal
959         pure
960         returns (bytes4 result)
961     {
962         require(
963             b.length >= index + 4,
964             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
965         );
966 
967         // Arrays are prefixed by a 32 byte length field
968         index += 32;
969 
970         // Read the bytes4 from array memory
971         assembly {
972             result := mload(add(b, index))
973             // Solidity does not require us to clean the trailing bytes.
974             // We do it anyway
975             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
976         }
977         return result;
978     }
979 
980     /// @dev Reads nested bytes from a specific position.
981     /// @dev NOTE: the returned value overlaps with the input value.
982     ///            Both should be treated as immutable.
983     /// @param b Byte array containing nested bytes.
984     /// @param index Index of nested bytes.
985     /// @return result Nested bytes.
986     function readBytesWithLength(
987         bytes memory b,
988         uint256 index
989     )
990         internal
991         pure
992         returns (bytes memory result)
993     {
994         // Read length of nested bytes
995         uint256 nestedBytesLength = readUint256(b, index);
996         index += 32;
997 
998         // Assert length of <b> is valid, given
999         // length of nested bytes
1000         require(
1001             b.length >= index + nestedBytesLength,
1002             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
1003         );
1004         
1005         // Return a pointer to the byte array as it exists inside `b`
1006         assembly {
1007             result := add(b, index)
1008         }
1009         return result;
1010     }
1011 
1012     /// @dev Inserts bytes at a specific position in a byte array.
1013     /// @param b Byte array to insert <input> into.
1014     /// @param index Index in byte array of <input>.
1015     /// @param input bytes to insert.
1016     function writeBytesWithLength(
1017         bytes memory b,
1018         uint256 index,
1019         bytes memory input
1020     )
1021         internal
1022         pure
1023     {
1024         // Assert length of <b> is valid, given
1025         // length of input
1026         require(
1027             b.length >= index + 32 + input.length,  // 32 bytes to store length
1028             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
1029         );
1030 
1031         // Copy <input> into <b>
1032         memCopy(
1033             b.contentAddress() + index,
1034             input.rawAddress(), // includes length of <input>
1035             input.length + 32   // +32 bytes to store <input> length
1036         );
1037     }
1038 
1039     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
1040     /// @param dest Byte array that will be overwritten with source bytes.
1041     /// @param source Byte array to copy onto dest bytes.
1042     function deepCopyBytes(
1043         bytes memory dest,
1044         bytes memory source
1045     )
1046         internal
1047         pure
1048     {
1049         uint256 sourceLen = source.length;
1050         // Dest length must be >= source length, or some bytes would not be copied.
1051         require(
1052             dest.length >= sourceLen,
1053             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
1054         );
1055         memCopy(
1056             dest.contentAddress(),
1057             source.contentAddress(),
1058             sourceLen
1059         );
1060     }
1061 }
1062 
1063 contract AssetProxyOwner is
1064     MultiSigWalletWithTimeLock
1065 {
1066     using LibBytes for bytes;
1067 
1068     event AssetProxyRegistration(address assetProxyContract, bool isRegistered);
1069 
1070     // Mapping of AssetProxy contract address =>
1071     // if this contract is allowed to call the AssetProxy's `removeAuthorizedAddressAtIndex` method without a time lock.
1072     mapping (address => bool) public isAssetProxyRegistered;
1073 
1074     bytes4 constant internal REMOVE_AUTHORIZED_ADDRESS_AT_INDEX_SELECTOR = bytes4(keccak256("removeAuthorizedAddressAtIndex(address,uint256)"));
1075 
1076     /// @dev Function will revert if the transaction does not call `removeAuthorizedAddressAtIndex`
1077     ///      on an approved AssetProxy contract.
1078     modifier validRemoveAuthorizedAddressAtIndexTx(uint256 transactionId) {
1079         Transaction storage txn = transactions[transactionId];
1080         require(
1081             isAssetProxyRegistered[txn.destination],
1082             "UNREGISTERED_ASSET_PROXY"
1083         );
1084         require(
1085             txn.data.readBytes4(0) == REMOVE_AUTHORIZED_ADDRESS_AT_INDEX_SELECTOR,
1086             "INVALID_FUNCTION_SELECTOR"
1087         );
1088         _;
1089     }
1090 
1091     /// @dev Contract constructor sets initial owners, required number of confirmations,
1092     ///      time lock, and list of AssetProxy addresses.
1093     /// @param _owners List of initial owners.
1094     /// @param _assetProxyContracts Array of AssetProxy contract addresses.
1095     /// @param _required Number of required confirmations.
1096     /// @param _secondsTimeLocked Duration needed after a transaction is confirmed and before it becomes executable, in seconds.
1097     constructor (
1098         address[] memory _owners,
1099         address[] memory _assetProxyContracts,
1100         uint256 _required,
1101         uint256 _secondsTimeLocked
1102     )
1103         public
1104         MultiSigWalletWithTimeLock(_owners, _required, _secondsTimeLocked)
1105     {
1106         for (uint256 i = 0; i < _assetProxyContracts.length; i++) {
1107             address assetProxy = _assetProxyContracts[i];
1108             require(
1109                 assetProxy != address(0),
1110                 "INVALID_ASSET_PROXY"
1111             );
1112             isAssetProxyRegistered[assetProxy] = true;
1113         }
1114     }
1115 
1116     /// @dev Registers or deregisters an AssetProxy to be able to execute
1117     ///      `removeAuthorizedAddressAtIndex` without a timelock.
1118     /// @param assetProxyContract Address of AssetProxy contract.
1119     /// @param isRegistered Status of approval for AssetProxy contract.
1120     function registerAssetProxy(address assetProxyContract, bool isRegistered)
1121         public
1122         onlyWallet
1123         notNull(assetProxyContract)
1124     {
1125         isAssetProxyRegistered[assetProxyContract] = isRegistered;
1126         emit AssetProxyRegistration(assetProxyContract, isRegistered);
1127     }
1128 
1129     /// @dev Allows execution of `removeAuthorizedAddressAtIndex` without time lock.
1130     /// @param transactionId Transaction ID.
1131     function executeRemoveAuthorizedAddressAtIndex(uint256 transactionId)
1132         public
1133         notExecuted(transactionId)
1134         fullyConfirmed(transactionId)
1135         validRemoveAuthorizedAddressAtIndexTx(transactionId)
1136     {
1137         Transaction storage txn = transactions[transactionId];
1138         txn.executed = true;
1139         if (external_call(txn.destination, txn.value, txn.data.length, txn.data)) {
1140             emit Execution(transactionId);
1141         } else {
1142             emit ExecutionFailure(transactionId);
1143             txn.executed = false;
1144         }
1145     }
1146 }