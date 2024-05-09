1 /*
2 
3     Copyright 2019 dYdX Trading Inc.
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.7;
20 pragma experimental ABIEncoderV2;
21 
22 // File: contracts/external/multisig/MultiSig.sol
23 
24 /**
25  * @title MultiSig
26  * @author dYdX
27  *
28  * Multi-Signature Wallet.
29  * Allows multiple parties to agree on transactions before execution.
30  * Adapted from Stefan George's MultiSigWallet contract.
31  *
32  * Logic Changes:
33  *  - Removed the fallback function
34  *  - Ensure newOwner is notNull
35  *
36  * Syntax Changes:
37  *  - Update Solidity syntax for 0.5.X: use `emit` keyword (events), use `view` keyword (functions)
38  *  - Add braces to all `if` and `for` statements
39  *  - Remove named return variables
40  *  - Add space before and after comparison operators
41  *  - Add ADDRESS_ZERO as a constant
42  *  - uint => uint256
43  *  - external_call => externalCall
44  */
45 contract MultiSig {
46 
47     // ============ Events ============
48 
49     event Confirmation(address indexed sender, uint256 indexed transactionId);
50     event Revocation(address indexed sender, uint256 indexed transactionId);
51     event Submission(uint256 indexed transactionId);
52     event Execution(uint256 indexed transactionId);
53     event ExecutionFailure(uint256 indexed transactionId);
54     event OwnerAddition(address indexed owner);
55     event OwnerRemoval(address indexed owner);
56     event RequirementChange(uint256 required);
57 
58     // ============ Constants ============
59 
60     uint256 constant public MAX_OWNER_COUNT = 50;
61     address constant ADDRESS_ZERO = address(0x0);
62 
63     // ============ Storage ============
64 
65     mapping (uint256 => Transaction) public transactions;
66     mapping (uint256 => mapping (address => bool)) public confirmations;
67     mapping (address => bool) public isOwner;
68     address[] public owners;
69     uint256 public required;
70     uint256 public transactionCount;
71 
72     // ============ Structs ============
73 
74     struct Transaction {
75         address destination;
76         uint256 value;
77         bytes data;
78         bool executed;
79     }
80 
81     // ============ Modifiers ============
82 
83     modifier onlyWallet() {
84         /* solium-disable-next-line error-reason */
85         require(msg.sender == address(this));
86         _;
87     }
88 
89     modifier ownerDoesNotExist(
90         address owner
91     ) {
92         /* solium-disable-next-line error-reason */
93         require(!isOwner[owner]);
94         _;
95     }
96 
97     modifier ownerExists(
98         address owner
99     ) {
100         /* solium-disable-next-line error-reason */
101         require(isOwner[owner]);
102         _;
103     }
104 
105     modifier transactionExists(
106         uint256 transactionId
107     ) {
108         /* solium-disable-next-line error-reason */
109         require(transactions[transactionId].destination != ADDRESS_ZERO);
110         _;
111     }
112 
113     modifier confirmed(
114         uint256 transactionId,
115         address owner
116     ) {
117         /* solium-disable-next-line error-reason */
118         require(confirmations[transactionId][owner]);
119         _;
120     }
121 
122     modifier notConfirmed(
123         uint256 transactionId,
124         address owner
125     ) {
126         /* solium-disable-next-line error-reason */
127         require(!confirmations[transactionId][owner]);
128         _;
129     }
130 
131     modifier notExecuted(
132         uint256 transactionId
133     ) {
134         /* solium-disable-next-line error-reason */
135         require(!transactions[transactionId].executed);
136         _;
137     }
138 
139     modifier notNull(
140         address _address
141     ) {
142         /* solium-disable-next-line error-reason */
143         require(_address != ADDRESS_ZERO);
144         _;
145     }
146 
147     modifier validRequirement(
148         uint256 ownerCount,
149         uint256 _required
150     ) {
151         /* solium-disable-next-line error-reason */
152         require(
153             ownerCount <= MAX_OWNER_COUNT
154             && _required <= ownerCount
155             && _required != 0
156             && ownerCount != 0
157         );
158         _;
159     }
160 
161     // ============ Constructor ============
162 
163     /**
164      * Contract constructor sets initial owners and required number of confirmations.
165      *
166      * @param  _owners    List of initial owners.
167      * @param  _required  Number of required confirmations.
168      */
169     constructor(
170         address[] memory _owners,
171         uint256 _required
172     )
173         public
174         validRequirement(_owners.length, _required)
175     {
176         for (uint256 i = 0; i < _owners.length; i++) {
177             /* solium-disable-next-line error-reason */
178             require(!isOwner[_owners[i]] && _owners[i] != ADDRESS_ZERO);
179             isOwner[_owners[i]] = true;
180         }
181         owners = _owners;
182         required = _required;
183     }
184 
185     // ============ Wallet-Only Functions ============
186 
187     /**
188      * Allows to add a new owner. Transaction has to be sent by wallet.
189      *
190      * @param  owner  Address of new owner.
191      */
192     function addOwner(
193         address owner
194     )
195         public
196         onlyWallet
197         ownerDoesNotExist(owner)
198         notNull(owner)
199         validRequirement(owners.length + 1, required)
200     {
201         isOwner[owner] = true;
202         owners.push(owner);
203         emit OwnerAddition(owner);
204     }
205 
206     /**
207      * Allows to remove an owner. Transaction has to be sent by wallet.
208      *
209      * @param  owner  Address of owner.
210      */
211     function removeOwner(
212         address owner
213     )
214         public
215         onlyWallet
216         ownerExists(owner)
217     {
218         isOwner[owner] = false;
219         for (uint256 i = 0; i < owners.length - 1; i++) {
220             if (owners[i] == owner) {
221                 owners[i] = owners[owners.length - 1];
222                 break;
223             }
224         }
225         owners.length -= 1;
226         if (required > owners.length) {
227             changeRequirement(owners.length);
228         }
229         emit OwnerRemoval(owner);
230     }
231 
232     /**
233      * Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
234      *
235      * @param  owner     Address of owner to be replaced.
236      * @param  newOwner  Address of new owner.
237      */
238     function replaceOwner(
239         address owner,
240         address newOwner
241     )
242         public
243         onlyWallet
244         ownerExists(owner)
245         ownerDoesNotExist(newOwner)
246         notNull(newOwner)
247     {
248         for (uint256 i = 0; i < owners.length; i++) {
249             if (owners[i] == owner) {
250                 owners[i] = newOwner;
251                 break;
252             }
253         }
254         isOwner[owner] = false;
255         isOwner[newOwner] = true;
256         emit OwnerRemoval(owner);
257         emit OwnerAddition(newOwner);
258     }
259 
260     /**
261      * Allows to change the number of required confirmations. Transaction has to be sent by wallet.
262      *
263      * @param  _required  Number of required confirmations.
264      */
265     function changeRequirement(
266         uint256 _required
267     )
268         public
269         onlyWallet
270         validRequirement(owners.length, _required)
271     {
272         required = _required;
273         emit RequirementChange(_required);
274     }
275 
276     // ============ Owner Functions ============
277 
278     /**
279      * Allows an owner to submit and confirm a transaction.
280      *
281      * @param  destination  Transaction target address.
282      * @param  value        Transaction ether value.
283      * @param  data         Transaction data payload.
284      * @return              Transaction ID.
285      */
286     function submitTransaction(
287         address destination,
288         uint256 value,
289         bytes memory data
290     )
291         public
292         returns (uint256)
293     {
294         uint256 transactionId = addTransaction(destination, value, data);
295         confirmTransaction(transactionId);
296         return transactionId;
297     }
298 
299     /**
300      * Allows an owner to confirm a transaction.
301      *
302      * @param  transactionId  Transaction ID.
303      */
304     function confirmTransaction(
305         uint256 transactionId
306     )
307         public
308         ownerExists(msg.sender)
309         transactionExists(transactionId)
310         notConfirmed(transactionId, msg.sender)
311     {
312         confirmations[transactionId][msg.sender] = true;
313         emit Confirmation(msg.sender, transactionId);
314         executeTransaction(transactionId);
315     }
316 
317     /**
318      * Allows an owner to revoke a confirmation for a transaction.
319      *
320      * @param  transactionId  Transaction ID.
321      */
322     function revokeConfirmation(
323         uint256 transactionId
324     )
325         public
326         ownerExists(msg.sender)
327         confirmed(transactionId, msg.sender)
328         notExecuted(transactionId)
329     {
330         confirmations[transactionId][msg.sender] = false;
331         emit Revocation(msg.sender, transactionId);
332     }
333 
334     /**
335      * Allows an owner to execute a confirmed transaction.
336      *
337      * @param  transactionId  Transaction ID.
338      */
339     function executeTransaction(
340         uint256 transactionId
341     )
342         public
343         ownerExists(msg.sender)
344         confirmed(transactionId, msg.sender)
345         notExecuted(transactionId)
346     {
347         if (isConfirmed(transactionId)) {
348             Transaction storage txn = transactions[transactionId];
349             txn.executed = true;
350             if (externalCall(
351                 txn.destination,
352                 txn.value,
353                 txn.data.length,
354                 txn.data)
355             ) {
356                 emit Execution(transactionId);
357             } else {
358                 emit ExecutionFailure(transactionId);
359                 txn.executed = false;
360             }
361         }
362     }
363 
364     // ============ Getter Functions ============
365 
366     /**
367      * Returns the confirmation status of a transaction.
368      *
369      * @param  transactionId  Transaction ID.
370      * @return                Confirmation status.
371      */
372     function isConfirmed(
373         uint256 transactionId
374     )
375         public
376         view
377         returns (bool)
378     {
379         uint256 count = 0;
380         for (uint256 i = 0; i < owners.length; i++) {
381             if (confirmations[transactionId][owners[i]]) {
382                 count += 1;
383             }
384             if (count == required) {
385                 return true;
386             }
387         }
388     }
389 
390     /**
391      * Returns number of confirmations of a transaction.
392      *
393      * @param  transactionId  Transaction ID.
394      * @return                Number of confirmations.
395      */
396     function getConfirmationCount(
397         uint256 transactionId
398     )
399         public
400         view
401         returns (uint256)
402     {
403         uint256 count = 0;
404         for (uint256 i = 0; i < owners.length; i++) {
405             if (confirmations[transactionId][owners[i]]) {
406                 count += 1;
407             }
408         }
409         return count;
410     }
411 
412     /**
413      * Returns total number of transactions after filers are applied.
414      *
415      * @param  pending   Include pending transactions.
416      * @param  executed  Include executed transactions.
417      * @return           Total number of transactions after filters are applied.
418      */
419     function getTransactionCount(
420         bool pending,
421         bool executed
422     )
423         public
424         view
425         returns (uint256)
426     {
427         uint256 count = 0;
428         for (uint256 i = 0; i < transactionCount; i++) {
429             if (
430                 pending && !transactions[i].executed
431                 || executed && transactions[i].executed
432             ) {
433                 count += 1;
434             }
435         }
436         return count;
437     }
438 
439     /**
440      * Returns array of owners.
441      *
442      * @return  Array of owner addresses.
443      */
444     function getOwners()
445         public
446         view
447         returns (address[] memory)
448     {
449         return owners;
450     }
451 
452     /**
453      * Returns array with owner addresses, which confirmed transaction.
454      *
455      * @param  transactionId  Transaction ID.
456      * @return                Array of owner addresses.
457      */
458     function getConfirmations(
459         uint256 transactionId
460     )
461         public
462         view
463         returns (address[] memory)
464     {
465         address[] memory confirmationsTemp = new address[](owners.length);
466         uint256 count = 0;
467         uint256 i;
468         for (i = 0; i < owners.length; i++) {
469             if (confirmations[transactionId][owners[i]]) {
470                 confirmationsTemp[count] = owners[i];
471                 count += 1;
472             }
473         }
474         address[] memory _confirmations = new address[](count);
475         for (i = 0; i < count; i++) {
476             _confirmations[i] = confirmationsTemp[i];
477         }
478         return _confirmations;
479     }
480 
481     /**
482      * Returns list of transaction IDs in defined range.
483      *
484      * @param  from      Index start position of transaction array.
485      * @param  to        Index end position of transaction array.
486      * @param  pending   Include pending transactions.
487      * @param  executed  Include executed transactions.
488      * @return           Array of transaction IDs.
489      */
490     function getTransactionIds(
491         uint256 from,
492         uint256 to,
493         bool pending,
494         bool executed
495     )
496         public
497         view
498         returns (uint256[] memory)
499     {
500         uint256[] memory transactionIdsTemp = new uint256[](transactionCount);
501         uint256 count = 0;
502         uint256 i;
503         for (i = 0; i < transactionCount; i++) {
504             if (
505                 pending && !transactions[i].executed
506                 || executed && transactions[i].executed
507             ) {
508                 transactionIdsTemp[count] = i;
509                 count += 1;
510             }
511         }
512         uint256[] memory _transactionIds = new uint256[](to - from);
513         for (i = from; i < to; i++) {
514             _transactionIds[i - from] = transactionIdsTemp[i];
515         }
516         return _transactionIds;
517     }
518 
519     // ============ Helper Functions ============
520 
521     // call has been separated into its own function in order to take advantage
522     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
523     function externalCall(
524         address destination,
525         uint256 value,
526         uint256 dataLength,
527         bytes memory data
528     )
529         internal
530         returns (bool)
531     {
532         bool result;
533         /* solium-disable-next-line security/no-inline-assembly */
534         assembly {
535             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
536             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
537             result := call(
538                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
539                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
540                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
541                 destination,
542                 value,
543                 d,
544                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
545                 x,
546                 0                  // Output is ignored, therefore the output size is zero
547             )
548         }
549         return result;
550     }
551 
552     /**
553      * Adds a new transaction to the transaction mapping, if transaction does not exist yet.
554      *
555      * @param  destination  Transaction target address.
556      * @param  value        Transaction ether value.
557      * @param  data         Transaction data payload.
558      * @return              Transaction ID.
559      */
560     function addTransaction(
561         address destination,
562         uint256 value,
563         bytes memory data
564     )
565         internal
566         notNull(destination)
567         returns (uint256)
568     {
569         uint256 transactionId = transactionCount;
570         transactions[transactionId] = Transaction({
571             destination: destination,
572             value: value,
573             data: data,
574             executed: false
575         });
576         transactionCount += 1;
577         emit Submission(transactionId);
578         return transactionId;
579     }
580 }
581 
582 // File: contracts/external/multisig/DelayedMultiSig.sol
583 
584 /**
585  * @title DelayedMultiSig
586  * @author dYdX
587  *
588  * Multi-Signature Wallet with delay in execution.
589  * Allows multiple parties to execute a transaction after a time lock has passed.
590  * Adapted from Amir Bandeali's MultiSigWalletWithTimeLock contract.
591 
592  * Logic Changes:
593  *  - Only owners can execute transactions
594  *  - Require that each transaction succeeds
595  *  - Added function to execute multiple transactions within the same Ethereum transaction
596  */
597 contract DelayedMultiSig is
598     MultiSig
599 {
600     // ============ Events ============
601 
602     event ConfirmationTimeSet(uint256 indexed transactionId, uint256 confirmationTime);
603     event TimeLockChange(uint32 secondsTimeLocked);
604 
605     // ============ Storage ============
606 
607     uint32 public secondsTimeLocked;
608     mapping (uint256 => uint256) public confirmationTimes;
609 
610     // ============ Modifiers ============
611 
612     modifier notFullyConfirmed(
613         uint256 transactionId
614     ) {
615         require(
616             !isConfirmed(transactionId),
617             "TX_FULLY_CONFIRMED"
618         );
619         _;
620     }
621 
622     modifier fullyConfirmed(
623         uint256 transactionId
624     ) {
625         require(
626             isConfirmed(transactionId),
627             "TX_NOT_FULLY_CONFIRMED"
628         );
629         _;
630     }
631 
632     modifier pastTimeLock(
633         uint256 transactionId
634     ) {
635         require(
636             block.timestamp >= confirmationTimes[transactionId] + secondsTimeLocked,
637             "TIME_LOCK_INCOMPLETE"
638         );
639         _;
640     }
641 
642     // ============ Constructor ============
643 
644     /**
645      * Contract constructor sets initial owners, required number of confirmations, and time lock.
646      *
647      * @param  _owners             List of initial owners.
648      * @param  _required           Number of required confirmations.
649      * @param  _secondsTimeLocked  Duration needed after a transaction is confirmed and before it
650      *                             becomes executable, in seconds.
651      */
652     constructor (
653         address[] memory _owners,
654         uint256 _required,
655         uint32 _secondsTimeLocked
656     )
657         public
658         MultiSig(_owners, _required)
659     {
660         secondsTimeLocked = _secondsTimeLocked;
661     }
662 
663     // ============ Wallet-Only Functions ============
664 
665     /**
666      * Changes the duration of the time lock for transactions.
667      *
668      * @param  _secondsTimeLocked  Duration needed after a transaction is confirmed and before it
669      *                             becomes executable, in seconds.
670      */
671     function changeTimeLock(
672         uint32 _secondsTimeLocked
673     )
674         public
675         onlyWallet
676     {
677         secondsTimeLocked = _secondsTimeLocked;
678         emit TimeLockChange(_secondsTimeLocked);
679     }
680 
681     // ============ Owner Functions ============
682 
683     /**
684      * Allows an owner to confirm a transaction.
685      * Overrides the function in MultiSig.
686      *
687      * @param  transactionId  Transaction ID.
688      */
689     function confirmTransaction(
690         uint256 transactionId
691     )
692         public
693         ownerExists(msg.sender)
694         transactionExists(transactionId)
695         notConfirmed(transactionId, msg.sender)
696         notFullyConfirmed(transactionId)
697     {
698         confirmations[transactionId][msg.sender] = true;
699         emit Confirmation(msg.sender, transactionId);
700         if (isConfirmed(transactionId)) {
701             setConfirmationTime(transactionId, block.timestamp);
702         }
703     }
704 
705     /**
706      * Allows an owner to execute a confirmed transaction.
707      * Overrides the function in MultiSig.
708      *
709      * @param  transactionId  Transaction ID.
710      */
711     function executeTransaction(
712         uint256 transactionId
713     )
714         public
715         ownerExists(msg.sender)
716         notExecuted(transactionId)
717         fullyConfirmed(transactionId)
718         pastTimeLock(transactionId)
719     {
720         Transaction storage txn = transactions[transactionId];
721         txn.executed = true;
722         bool success = externalCall(
723             txn.destination,
724             txn.value,
725             txn.data.length,
726             txn.data
727         );
728         require(
729             success,
730             "TX_REVERTED"
731         );
732         emit Execution(transactionId);
733     }
734 
735     /**
736      * Allows an owner to execute multiple confirmed transactions.
737      *
738      * @param  transactionIds  List of transaction IDs.
739      */
740     function executeMultipleTransactions(
741         uint256[] memory transactionIds
742     )
743         public
744         ownerExists(msg.sender)
745     {
746         for (uint256 i = 0; i < transactionIds.length; i++) {
747             executeTransaction(transactionIds[i]);
748         }
749     }
750 
751     // ============ Helper Functions ============
752 
753     /**
754      * Sets the time of when a submission first passed.
755      */
756     function setConfirmationTime(
757         uint256 transactionId,
758         uint256 confirmationTime
759     )
760         internal
761     {
762         confirmationTimes[transactionId] = confirmationTime;
763         emit ConfirmationTimeSet(transactionId, confirmationTime);
764     }
765 }
766 
767 // File: contracts/external/multisig/PartiallyDelayedMultiSig.sol
768 
769 /**
770  * @title PartiallyDelayedMultiSig
771  * @author dYdX
772  *
773  * Multi-Signature Wallet with delay in execution except for some function selectors.
774  */
775 contract PartiallyDelayedMultiSig is
776     DelayedMultiSig
777 {
778     // ============ Events ============
779 
780     event SelectorSet(address destination, bytes4 selector, bool approved);
781 
782     // ============ Constants ============
783 
784     bytes4 constant internal BYTES_ZERO = bytes4(0x0);
785 
786     // ============ Storage ============
787 
788     // destination => function selector => can bypass timelock
789     mapping (address => mapping (bytes4 => bool)) public instantData;
790 
791     // ============ Modifiers ============
792 
793     // Overrides old modifier that requires a timelock for every transaction
794     modifier pastTimeLock(
795         uint256 transactionId
796     ) {
797         // if the function selector is not exempt from timelock, then require timelock
798         require(
799             block.timestamp >= confirmationTimes[transactionId] + secondsTimeLocked
800             || txCanBeExecutedInstantly(transactionId),
801             "TIME_LOCK_INCOMPLETE"
802         );
803         _;
804     }
805 
806     // ============ Constructor ============
807 
808     /**
809      * Contract constructor sets initial owners, required number of confirmations, and time lock.
810      *
811      * @param  _owners               List of initial owners.
812      * @param  _required             Number of required confirmations.
813      * @param  _secondsTimeLocked    Duration needed after a transaction is confirmed and before it
814      *                               becomes executable, in seconds.
815      * @param  _noDelayDestinations  List of destinations that correspond with the selectors.
816      *                               Zero address allows the function selector to be used with any
817      *                               address.
818      * @param  _noDelaySelectors     All function selectors that do not require a delay to execute.
819      *                               Fallback function is 0x00000000.
820      */
821     constructor (
822         address[] memory _owners,
823         uint256 _required,
824         uint32 _secondsTimeLocked,
825         address[] memory _noDelayDestinations,
826         bytes4[] memory _noDelaySelectors
827     )
828         public
829         DelayedMultiSig(_owners, _required, _secondsTimeLocked)
830     {
831         require(
832             _noDelayDestinations.length == _noDelaySelectors.length,
833             "ADDRESS_AND_SELECTOR_MISMATCH"
834         );
835 
836         for (uint256 i = 0; i < _noDelaySelectors.length; i++) {
837             address destination = _noDelayDestinations[i];
838             bytes4 selector = _noDelaySelectors[i];
839             instantData[destination][selector] = true;
840             emit SelectorSet(destination, selector, true);
841         }
842     }
843 
844     // ============ Wallet-Only Functions ============
845 
846     /**
847      * Adds or removes functions that can be executed instantly. Transaction must be sent by wallet.
848      *
849      * @param  destination  Destination address of function. Zero address allows the function to be
850      *                      sent to any address.
851      * @param  selector     4-byte selector of the function. Fallback function is 0x00000000.
852      * @param  approved     True if adding approval, false if removing approval.
853      */
854     function setSelector(
855         address destination,
856         bytes4 selector,
857         bool approved
858     )
859         public
860         onlyWallet
861     {
862         instantData[destination][selector] = approved;
863         emit SelectorSet(destination, selector, approved);
864     }
865 
866     // ============ Helper Functions ============
867 
868     /**
869      * Returns true if transaction can be executed instantly (without timelock).
870      */
871     function txCanBeExecutedInstantly(
872         uint256 transactionId
873     )
874         internal
875         view
876         returns (bool)
877     {
878         // get transaction from storage
879         Transaction memory txn = transactions[transactionId];
880         address dest = txn.destination;
881         bytes memory data = txn.data;
882 
883         // fallback function
884         if (data.length == 0) {
885             return selectorCanBeExecutedInstantly(dest, BYTES_ZERO);
886         }
887 
888         // invalid function selector
889         if (data.length < 4) {
890             return false;
891         }
892 
893         // check first four bytes (function selector)
894         bytes32 rawData;
895         /* solium-disable-next-line security/no-inline-assembly */
896         assembly {
897             rawData := mload(add(data, 32))
898         }
899         bytes4 selector = bytes4(rawData);
900 
901         return selectorCanBeExecutedInstantly(dest, selector);
902     }
903 
904     /**
905      * Function selector is in instantData for address dest (or for address zero).
906      */
907     function selectorCanBeExecutedInstantly(
908         address destination,
909         bytes4 selector
910     )
911         internal
912         view
913         returns (bool)
914     {
915         return instantData[destination][selector]
916             || instantData[ADDRESS_ZERO][selector];
917     }
918 }