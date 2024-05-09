1 /**
2  * Copyright 2017–2018, bZeroX, LLC. All Rights Reserved.
3  * Adapted from MultiSigWalletWithTimeLock.sol, Copyright 2017 ZeroEx Intl.
4  * Licensed under the Apache License, Version 2.0.
5  */
6 
7 pragma solidity 0.4.24;
8 
9 
10 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
11 /// @author Stefan George - <stefan.george@consensys.net>
12 contract MultiSigWallet {
13 
14     /*
15      *  Events
16      */
17     event Confirmation(address indexed sender, uint indexed transactionId);
18     event Revocation(address indexed sender, uint indexed transactionId);
19     event Submission(uint indexed transactionId);
20     event Execution(uint indexed transactionId);
21     event ExecutionFailure(uint indexed transactionId);
22     event Deposit(address indexed sender, uint value);
23     event OwnerAddition(address indexed owner);
24     event OwnerRemoval(address indexed owner);
25     event RequirementChange(uint required);
26 
27     /*
28      *  Constants
29      */
30     uint constant public MAX_OWNER_COUNT = 50;
31 
32     /*
33      *  Storage
34      */
35     mapping (uint => Transaction) public transactions;
36     mapping (uint => mapping (address => bool)) public confirmations;
37     mapping (address => bool) public isOwner;
38     address[] public owners;
39     uint public required;
40     uint public transactionCount;
41 
42     struct Transaction {
43         address destination;
44         uint value;
45         bytes data;
46         bool executed;
47     }
48 
49     /*
50      *  Modifiers
51      */
52     modifier onlyWallet() {
53         require(msg.sender == address(this));
54         _;
55     }
56 
57     modifier ownerDoesNotExist(address owner) {
58         require(!isOwner[owner]);
59         _;
60     }
61 
62     modifier ownerExists(address owner) {
63         require(isOwner[owner]);
64         _;
65     }
66 
67     modifier transactionExists(uint transactionId) {
68         require(transactions[transactionId].destination != 0);
69         _;
70     }
71 
72     modifier confirmed(uint transactionId, address owner) {
73         require(confirmations[transactionId][owner]);
74         _;
75     }
76 
77     modifier notConfirmed(uint transactionId, address owner) {
78         require(!confirmations[transactionId][owner]);
79         _;
80     }
81 
82     modifier notExecuted(uint transactionId) {
83         require(!transactions[transactionId].executed);
84         _;
85     }
86 
87     modifier notNull(address _address) {
88         require(_address != 0);
89         _;
90     }
91 
92     modifier validRequirement(uint ownerCount, uint _required) {
93         require(ownerCount <= MAX_OWNER_COUNT
94             && _required <= ownerCount
95             && _required != 0
96             && ownerCount != 0);
97         _;
98     }
99 
100     /// @dev Fallback function allows to deposit ether.
101     function()
102         public
103         payable
104     {
105         if (msg.value > 0)
106             emit Deposit(msg.sender, msg.value);
107     }
108 
109     /*
110      * Public functions
111      */
112     /// @dev Contract constructor sets initial owners and required number of confirmations.
113     /// @param _owners List of initial owners.
114     /// @param _required Number of required confirmations.
115     constructor(address[] _owners, uint _required)
116         public
117         validRequirement(_owners.length, _required)
118     {
119         for (uint i=0; i<_owners.length; i++) {
120             require(!isOwner[_owners[i]] && _owners[i] != 0);
121             isOwner[_owners[i]] = true;
122         }
123         owners = _owners;
124         required = _required;
125     }
126 
127     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
128     /// @param owner Address of new owner.
129     function addOwner(address owner)
130         public
131         onlyWallet
132         ownerDoesNotExist(owner)
133         notNull(owner)
134         validRequirement(owners.length + 1, required)
135     {
136         isOwner[owner] = true;
137         owners.push(owner);
138         emit OwnerAddition(owner);
139     }
140 
141     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
142     /// @param owner Address of owner.
143     function removeOwner(address owner)
144         public
145         onlyWallet
146         ownerExists(owner)
147     {
148         isOwner[owner] = false;
149         for (uint i=0; i<owners.length - 1; i++)
150             if (owners[i] == owner) {
151                 owners[i] = owners[owners.length - 1];
152                 break;
153             }
154         owners.length -= 1;
155         if (required > owners.length)
156             changeRequirement(owners.length);
157         emit OwnerRemoval(owner);
158     }
159 
160     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
161     /// @param owner Address of owner to be replaced.
162     /// @param newOwner Address of new owner.
163     function replaceOwner(address owner, address newOwner)
164         public
165         onlyWallet
166         ownerExists(owner)
167         ownerDoesNotExist(newOwner)
168     {
169         for (uint i=0; i<owners.length; i++)
170             if (owners[i] == owner) {
171                 owners[i] = newOwner;
172                 break;
173             }
174         isOwner[owner] = false;
175         isOwner[newOwner] = true;
176         emit OwnerRemoval(owner);
177         emit OwnerAddition(newOwner);
178     }
179 
180     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
181     /// @param _required Number of required confirmations.
182     function changeRequirement(uint _required)
183         public
184         onlyWallet
185         validRequirement(owners.length, _required)
186     {
187         required = _required;
188         emit RequirementChange(_required);
189     }
190 
191     /// @dev Allows an owner to submit and confirm a transaction.
192     /// @param destination Transaction target address.
193     /// @param value Transaction ether value.
194     /// @param data Transaction data payload.
195     /// @return Returns transaction ID.
196     function submitTransaction(address destination, uint value, bytes data)
197         public
198         returns (uint transactionId)
199     {
200         transactionId = addTransaction(destination, value, data);
201         confirmTransaction(transactionId);
202     }
203 
204     /// @dev Allows an owner to confirm a transaction.
205     /// @param transactionId Transaction ID.
206     function confirmTransaction(uint transactionId)
207         public
208         ownerExists(msg.sender)
209         transactionExists(transactionId)
210         notConfirmed(transactionId, msg.sender)
211     {
212         confirmations[transactionId][msg.sender] = true;
213         emit Confirmation(msg.sender, transactionId);
214         executeTransaction(transactionId);
215     }
216 
217     /// @dev Allows an owner to revoke a confirmation for a transaction.
218     /// @param transactionId Transaction ID.
219     function revokeConfirmation(uint transactionId)
220         public
221         ownerExists(msg.sender)
222         confirmed(transactionId, msg.sender)
223         notExecuted(transactionId)
224     {
225         confirmations[transactionId][msg.sender] = false;
226         emit Revocation(msg.sender, transactionId);
227     }
228 
229     /// @dev Allows anyone to execute a confirmed transaction.
230     /// @param transactionId Transaction ID.
231     function executeTransaction(uint transactionId)
232         public
233         ownerExists(msg.sender)
234         confirmed(transactionId, msg.sender)
235         notExecuted(transactionId)
236     {
237         if (isConfirmed(transactionId)) {
238             Transaction storage txn = transactions[transactionId];
239             txn.executed = true;
240             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
241                 emit Execution(transactionId);
242             else {
243                 emit ExecutionFailure(transactionId);
244                 txn.executed = false;
245             }
246         }
247     }
248 
249     // call has been separated into its own function in order to take advantage
250     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
251     function external_call(address destination, uint value, uint dataLength, bytes data) internal returns (bool) {
252         bool result;
253         assembly {
254             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
255             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
256             result := call(
257                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
258                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
259                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
260                 destination,
261                 value,
262                 d,
263                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
264                 x,
265                 0                  // Output is ignored, therefore the output size is zero
266             )
267         }
268         return result;
269     }
270 
271     /// @dev Returns the confirmation status of a transaction.
272     /// @param transactionId Transaction ID.
273     /// @return Confirmation status.
274     function isConfirmed(uint transactionId)
275         public
276         constant
277         returns (bool)
278     {
279         uint count = 0;
280         for (uint i=0; i<owners.length; i++) {
281             if (confirmations[transactionId][owners[i]])
282                 count += 1;
283             if (count == required)
284                 return true;
285         }
286     }
287 
288     /*
289      * Internal functions
290      */
291     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
292     /// @param destination Transaction target address.
293     /// @param value Transaction ether value.
294     /// @param data Transaction data payload.
295     /// @return Returns transaction ID.
296     function addTransaction(address destination, uint value, bytes data)
297         internal
298         notNull(destination)
299         returns (uint transactionId)
300     {
301         transactionId = transactionCount;
302         transactions[transactionId] = Transaction({
303             destination: destination,
304             value: value,
305             data: data,
306             executed: false
307         });
308         transactionCount += 1;
309         emit Submission(transactionId);
310     }
311 
312     /*
313      * Web3 call functions
314      */
315     /// @dev Returns number of confirmations of a transaction.
316     /// @param transactionId Transaction ID.
317     /// @return Number of confirmations.
318     function getConfirmationCount(uint transactionId)
319         public
320         constant
321         returns (uint count)
322     {
323         for (uint i=0; i<owners.length; i++)
324             if (confirmations[transactionId][owners[i]])
325                 count += 1;
326     }
327 
328     /// @dev Returns total number of transactions after filers are applied.
329     /// @param pending Include pending transactions.
330     /// @param executed Include executed transactions.
331     /// @return Total number of transactions after filters are applied.
332     function getTransactionCount(bool pending, bool executed)
333         public
334         constant
335         returns (uint count)
336     {
337         for (uint i=0; i<transactionCount; i++)
338             if (   pending && !transactions[i].executed
339                 || executed && transactions[i].executed)
340                 count += 1;
341     }
342 
343     /// @dev Returns list of owners.
344     /// @return List of owner addresses.
345     function getOwners()
346         public
347         constant
348         returns (address[])
349     {
350         return owners;
351     }
352 
353     /// @dev Returns array with owner addresses, which confirmed transaction.
354     /// @param transactionId Transaction ID.
355     /// @return Returns array of owner addresses.
356     function getConfirmations(uint transactionId)
357         public
358         constant
359         returns (address[] _confirmations)
360     {
361         address[] memory confirmationsTemp = new address[](owners.length);
362         uint count = 0;
363         uint i;
364         for (i=0; i<owners.length; i++)
365             if (confirmations[transactionId][owners[i]]) {
366                 confirmationsTemp[count] = owners[i];
367                 count += 1;
368             }
369         _confirmations = new address[](count);
370         for (i=0; i<count; i++)
371             _confirmations[i] = confirmationsTemp[i];
372     }
373 
374     /// @dev Returns list of transaction IDs in defined range.
375     /// @param from Index start position of transaction array.
376     /// @param to Index end position of transaction array.
377     /// @param pending Include pending transactions.
378     /// @param executed Include executed transactions.
379     /// @return Returns array of transaction IDs.
380     function getTransactionIds(uint from, uint to, bool pending, bool executed)
381         public
382         constant
383         returns (uint[] _transactionIds)
384     {
385         uint[] memory transactionIdsTemp = new uint[](transactionCount);
386         uint count = 0;
387         uint i;
388         for (i=0; i<transactionCount; i++)
389             if (   pending && !transactions[i].executed
390                 || executed && transactions[i].executed)
391             {
392                 transactionIdsTemp[count] = i;
393                 count += 1;
394             }
395         _transactionIds = new uint[](to - from);
396         for (i=from; i<to; i++)
397             _transactionIds[i - from] = transactionIdsTemp[i];
398     }
399 }
400 
401 contract MultiSigWalletWithCustomTimeLocks is MultiSigWallet {
402 
403     event ConfirmationTimeSet(uint indexed transactionId, uint confirmationTime);
404     event TimeLockDefaultChange(uint secondsTimeLockedDefault);
405     event TimeLockCustomChange(string funcHeader, uint secondsTimeLockedCustom);
406     event TimeLockCustomRemove(string funcHeader);
407 
408     struct CustomTimeLock {
409         uint secondsTimeLocked;
410         bool isSet;
411     }
412     
413     uint public secondsTimeLockedDefault; // default timelock for functions without a custom setting
414     mapping (bytes4 => CustomTimeLock) public customTimeLocks; // mapping of function headers to CustomTimeLock structs
415     string[] public customTimeLockFunctions; // array of functions with custom values
416 
417     mapping (uint => uint) public confirmationTimes;
418 
419     modifier notFullyConfirmed(uint transactionId) {
420         require(!isConfirmed(transactionId));
421         _;
422     }
423 
424     modifier fullyConfirmed(uint transactionId) {
425         require(isConfirmed(transactionId));
426         _;
427     }
428 
429     modifier pastTimeLock(uint transactionId) {
430         uint timelock = getSecondsTimeLockedByTx(transactionId);
431         require(timelock == 0 || block.timestamp >= confirmationTimes[transactionId] + timelock);
432         _;
433     }
434 
435     /*
436      * Public functions
437      */
438 
439     /// @dev Contract constructor sets initial owners, required number of confirmations, and time lock.
440     /// @param _owners List of initial owners.
441     /// @param _required Number of required confirmations.
442     /// @param _secondsTimeLockedDefault Default duration needed after a transaction is confirmed and before it becomes executable, in seconds.
443     constructor(address[] _owners, uint _required, uint _secondsTimeLockedDefault)
444         public
445         MultiSigWallet(_owners, _required)
446     {
447         secondsTimeLockedDefault = _secondsTimeLockedDefault;
448 
449         customTimeLockFunctions.push("transferOwnership(address)");
450         customTimeLocks[bytes4(keccak256("transferOwnership(address)"))].isSet = true;
451         customTimeLocks[bytes4(keccak256("transferOwnership(address)"))].secondsTimeLocked = 2419200; // 28 days
452 
453         customTimeLockFunctions.push("transferBZxOwnership(address)");
454         customTimeLocks[bytes4(keccak256("transferBZxOwnership(address)"))].isSet = true;
455         customTimeLocks[bytes4(keccak256("transferBZxOwnership(address)"))].secondsTimeLocked = 2419200;
456 
457         customTimeLockFunctions.push("replaceContract(address)");
458         customTimeLocks[bytes4(keccak256("replaceContract(address)"))].isSet = true;
459         customTimeLocks[bytes4(keccak256("replaceContract(address)"))].secondsTimeLocked = 2419200;
460 
461         customTimeLockFunctions.push("setTarget(string,address)");
462         customTimeLocks[bytes4(keccak256("setTarget(string,address)"))].isSet = true;
463         customTimeLocks[bytes4(keccak256("setTarget(string,address)"))].secondsTimeLocked = 2419200;
464 
465         customTimeLockFunctions.push("setBZxAddresses(address,address,address,address,address)");
466         customTimeLocks[bytes4(keccak256("setBZxAddresses(address,address,address,address,address)"))].isSet = true;
467         customTimeLocks[bytes4(keccak256("setBZxAddresses(address,address,address,address,address)"))].secondsTimeLocked = 2419200;
468 
469         customTimeLockFunctions.push("setVault(address)");
470         customTimeLocks[bytes4(keccak256("setVault(address)"))].isSet = true;
471         customTimeLocks[bytes4(keccak256("setVault(address)"))].secondsTimeLocked = 2419200;
472 
473         customTimeLockFunctions.push("changeDefaultTimeLock(uint256)");
474         customTimeLocks[bytes4(keccak256("changeDefaultTimeLock(uint256)"))].isSet = true;
475         customTimeLocks[bytes4(keccak256("changeDefaultTimeLock(uint256)"))].secondsTimeLocked = 2419200;
476 
477         customTimeLockFunctions.push("changeCustomTimeLock(string,uint256)");
478         customTimeLocks[bytes4(keccak256("changeCustomTimeLock(string,uint256)"))].isSet = true;
479         customTimeLocks[bytes4(keccak256("changeCustomTimeLock(string,uint256)"))].secondsTimeLocked = 2419200;
480 
481         customTimeLockFunctions.push("removeCustomTimeLock(string)");
482         customTimeLocks[bytes4(keccak256("removeCustomTimeLock(string)"))].isSet = true;
483         customTimeLocks[bytes4(keccak256("removeCustomTimeLock(string)"))].secondsTimeLocked = 2419200;
484 
485         customTimeLockFunctions.push("toggleTargetPause(string,bool)");
486         customTimeLocks[bytes4(keccak256("toggleTargetPause(string,bool)"))].isSet = true;
487         customTimeLocks[bytes4(keccak256("toggleTargetPause(string,bool)"))].secondsTimeLocked = 0;
488 
489         customTimeLockFunctions.push("toggleDebug(bool)");
490         customTimeLocks[bytes4(keccak256("toggleDebug(bool)"))].isSet = true;
491         customTimeLocks[bytes4(keccak256("toggleDebug(bool)"))].secondsTimeLocked = 0;
492     }
493 
494     /// @dev Changes the default duration of the time lock for transactions.
495     /// @param _secondsTimeLockedDefault Default duration needed after a transaction is confirmed and before it becomes executable, in seconds.
496     function changeDefaultTimeLock(uint _secondsTimeLockedDefault)
497         public
498         onlyWallet
499     {
500         secondsTimeLockedDefault = _secondsTimeLockedDefault;
501         emit TimeLockDefaultChange(_secondsTimeLockedDefault);
502     }
503 
504     /// @dev Changes the custom duration of the time lock for transactions to a specific function.
505     /// @param _funcId example: "functionName(address[6],uint256[10],address,uint256,bytes)"
506     /// @param _secondsTimeLockedCustom Custom duration needed after a transaction is confirmed and before it becomes executable, in seconds.
507     function changeCustomTimeLock(string _funcId, uint _secondsTimeLockedCustom)
508         public
509         onlyWallet
510     {
511         bytes4 f = bytes4(keccak256(abi.encodePacked(_funcId)));
512         if (!customTimeLocks[f].isSet) {
513             customTimeLocks[f].isSet = true;
514             customTimeLockFunctions.push(_funcId);
515         }
516         customTimeLocks[f].secondsTimeLocked = _secondsTimeLockedCustom;
517         emit TimeLockCustomChange(_funcId, _secondsTimeLockedCustom);
518     }
519 
520     /// @dev Removes the custom duration of the time lock for transactions to a specific function.
521     /// @param _funcId example: "functionName(address[6],uint256[10],address,uint256,bytes)"
522     function removeCustomTimeLock(string _funcId)
523         public
524         onlyWallet
525     {
526         bytes4 f = bytes4(keccak256(abi.encodePacked(_funcId)));
527         if (!customTimeLocks[f].isSet)
528             revert();
529 
530         for (uint i=0; i < customTimeLockFunctions.length; i++) {
531             if (keccak256(bytes(customTimeLockFunctions[i])) == keccak256(bytes(_funcId))) {
532                 if (i < customTimeLockFunctions.length - 1)
533                     customTimeLockFunctions[i] = customTimeLockFunctions[customTimeLockFunctions.length - 1];
534                 customTimeLockFunctions.length--;
535 
536                 customTimeLocks[f].secondsTimeLocked = 0;
537                 customTimeLocks[f].isSet = false;
538 
539                 emit TimeLockCustomRemove(_funcId);
540 
541                 break;
542             }
543         }
544     }
545 
546     /// @dev Allows an owner to confirm a transaction.
547     /// @param transactionId Transaction ID.
548     function confirmTransaction(uint transactionId)
549         public
550         ownerExists(msg.sender)
551         transactionExists(transactionId)
552         notConfirmed(transactionId, msg.sender)
553         notFullyConfirmed(transactionId)
554     {
555         confirmations[transactionId][msg.sender] = true;
556         emit Confirmation(msg.sender, transactionId);
557         if (getSecondsTimeLockedByTx(transactionId) > 0 && isConfirmed(transactionId)) {
558             setConfirmationTime(transactionId, block.timestamp);
559         }
560     }
561 
562     /// @dev Allows an owner to revoke a confirmation for a transaction.
563     /// @param transactionId Transaction ID.
564     function revokeConfirmation(uint transactionId)
565         public
566         ownerExists(msg.sender)
567         confirmed(transactionId, msg.sender)
568         notExecuted(transactionId)
569         notFullyConfirmed(transactionId)
570     {
571         confirmations[transactionId][msg.sender] = false;
572         emit Revocation(msg.sender, transactionId);
573     }
574 
575     /// @dev Allows anyone to execute a confirmed transaction.
576     /// @param transactionId Transaction ID.
577     function executeTransaction(uint transactionId)
578         public
579         notExecuted(transactionId)
580         fullyConfirmed(transactionId)
581         pastTimeLock(transactionId)
582     {
583         Transaction storage txn = transactions[transactionId];
584         txn.executed = true;
585         if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
586             emit Execution(transactionId);
587         else {
588             emit ExecutionFailure(transactionId);
589             txn.executed = false;
590         }
591     }
592 
593     /// @dev Returns the custom timelock for a function, or the default timelock if a custom value isn't set
594     /// @param _funcId Function signature (encoded bytes)
595     /// @return Timelock value
596     function getSecondsTimeLocked(bytes4 _funcId)
597         public
598         view
599         returns (uint)
600     {
601         if (customTimeLocks[_funcId].isSet)
602             return customTimeLocks[_funcId].secondsTimeLocked;
603         else
604             return secondsTimeLockedDefault;
605     }
606 
607     /// @dev Returns the custom timelock for a function, or the default timelock if a custom value isn't set
608     /// @param _funcId Function signature (complete string)
609     /// @return Timelock value
610     function getSecondsTimeLockedByString(string _funcId)
611         public
612         view
613         returns (uint)
614     {
615         return (getSecondsTimeLocked(bytes4(keccak256(abi.encodePacked(_funcId)))));
616     }
617 
618     /// @dev Returns the custom timelock for a transaction, or the default timelock if a custom value isn't set
619     /// @param transactionId Transaction ID.
620     /// @return Timelock value
621     function getSecondsTimeLockedByTx(uint transactionId)
622         public
623         view
624         returns (uint)
625     {
626         Transaction memory txn = transactions[transactionId];
627         bytes memory data = txn.data;
628         bytes4 funcId;
629         assembly {
630             funcId := mload(add(data, 32))
631         }
632         return (getSecondsTimeLocked(funcId));
633     }
634 
635     /// @dev Returns the number of seconds until a fully confirmed transaction can be executed
636     /// @param transactionId Transaction ID.
637     /// @return Seconds in the timelock remaining
638     function getTimeLockSecondsRemaining(uint transactionId)
639         public
640         view
641         returns (uint)
642     {
643         uint timelock = getSecondsTimeLockedByTx(transactionId);
644         if (timelock > 0 && confirmationTimes[transactionId] > 0) {
645             uint timelockEnding = confirmationTimes[transactionId] + timelock;
646             if (timelockEnding > block.timestamp)
647                 return timelockEnding - block.timestamp;
648         }
649         return 0;
650     }
651 
652     /*
653      * Internal functions
654      */
655 
656     /// @dev Sets the time of when a submission first passed.
657     function setConfirmationTime(uint transactionId, uint confirmationTime)
658         internal
659     {
660         confirmationTimes[transactionId] = confirmationTime;
661         emit ConfirmationTimeSet(transactionId, confirmationTime);
662     }
663 }