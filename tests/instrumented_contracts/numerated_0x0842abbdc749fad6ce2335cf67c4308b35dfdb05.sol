1 pragma solidity ^0.4.24;
2 
3 /* Required code start */
4 contract MarketplaceProxy {
5     function calculatePlatformCommission(uint256 weiAmount) public view returns (uint256);
6     function payPlatformIncomingTransactionCommission(address clientAddress) public payable;
7     function payPlatformOutgoingTransactionCommission() public payable;
8     function isUserBlockedByContract(address contractAddress) public view returns (bool);
9 }
10 /* Required code end */
11 
12 /// @title Multisignature wallet - Allows multiple parties to agree on transactions before execution.
13 /// @author Stefan George - <stefan.george@consensys.net>
14 contract Fund {
15 
16     /*
17      *  Events
18      */
19     event Confirmation(address sender, uint256 transactionId);
20     event Revocation(address sender, uint256 transactionId);
21     event Submission(uint256 transactionId);
22     event Execution(uint256 transactionId);
23     event ExecutionFailure(uint256 transactionId);
24     event OwnerAddition(address owner);
25     event OwnerRemoval(address owner);
26     event RequirementChange(uint256 required);
27     event MemberAdded(address member);
28     event MemberBlocked(address member);
29     event MemberUnblocked(address member);
30     event FeeAmountChanged(uint256 feeAmount);
31     event NextMemberPaymentAdded(address member, uint256 expectingAmount, uint256 platformCommission);
32     event NextMemberPaymentUpdated(address member, uint256 expectingAmount, uint256 platformCommission);
33     event IncomingPayment(address sender, uint256 value);
34     event Claim(address to, uint256 value);
35     event Transfer(address to, uint256 value);
36 
37     /*
38      *  Constants
39      */
40     uint256 constant public MAX_OWNER_COUNT = 50;
41 
42     /*
43      *  Storage
44      */
45     mapping (uint256 => Transaction) public transactions;
46     mapping (uint256 => mapping (address => bool)) public confirmations;
47     mapping (address => bool) public isOwner;
48     mapping (address => Member) public members;
49     mapping (address => NextMemberPayment) public nextMemberPayments;
50     address[] public owners;
51     address public creator;
52     uint256 public required;
53     uint256 public transactionCount;
54     uint256 public feeAmount;   // amount in wei
55     struct Transaction {
56         address destination;
57         uint256 value;
58         bytes data;
59         bool executed;
60     }
61     struct Member {
62         bool exists;
63         bool blocked;
64     }
65     struct NextMemberPayment {
66         bool exists;
67         uint256 expectingValue;       // wei, value that we wait in member incoiming transaction
68         uint256 platformCommission;   // wei, value that we send to Marketplace contract
69     }
70 
71     /* Required code start */
72     MarketplaceProxy public mp;
73     event PlatformIncomingTransactionCommission(uint256 amount, address clientAddress);
74     event PlatformOutgoingTransactionCommission(uint256 amount);
75     event Blocked();
76     /* Required code end */
77 
78     /*
79      *  Modifiers
80      */
81     modifier ownerDoesNotExist(address owner) {
82         require(!isOwner[owner]);
83         _;
84     }
85 
86     modifier ownerExists(address owner) {
87         require(isOwner[owner]);
88         _;
89     }
90 
91     modifier transactionExists(uint256 transactionId) {
92         require(transactions[transactionId].destination != 0);
93         _;
94     }
95 
96     modifier confirmed(uint256 transactionId, address owner) {
97         require(confirmations[transactionId][owner]);
98         _;
99     }
100 
101     modifier notConfirmed(uint256 transactionId, address owner) {
102         require(!confirmations[transactionId][owner]);
103         _;
104     }
105 
106     modifier notExecuted(uint256 transactionId) {
107         require(!transactions[transactionId].executed);
108         _;
109     }
110 
111     modifier notNull(address _address) {
112         require(_address != 0);
113         _;
114     }
115 
116     modifier validRequirement(uint256 ownerCount, uint256 _required) {
117         require(ownerCount <= MAX_OWNER_COUNT
118             && _required <= ownerCount
119             && _required != 0
120             && ownerCount != 0);
121         _;
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the creator.
126      */
127     modifier onlyCreator() {
128         require(msg.sender == creator);
129         _;
130     }
131 
132     /**
133      * @dev Throws if member does not exist.
134      */
135     modifier memberExists(address member) {
136         require(members[member].exists);
137         _;
138     }
139 
140     /**
141      * @dev Throws if member exists.
142      */
143     modifier memberDoesNotExist(address member) {
144         require(!members[member].exists);
145         _;
146     }
147 
148     /**
149      * @dev Throws if does not exist.
150      */
151     modifier nextMemberPaymentExists(address member) {
152         require(nextMemberPayments[member].exists);
153         _;
154     }
155 
156     /**
157      * @dev Throws if exists.
158      */
159     modifier nextMemberPaymentDoesNotExist(address member) {
160         require(!nextMemberPayments[member].exists);
161         _;
162     }
163 
164     /// @dev Fallback function allows to deposit ether.
165     function()
166         public
167         payable
168     {
169         handleIncomingPayment(msg.sender);
170     }
171 
172     /**
173      * @dev Handles payment gateway transactions
174      * @param member when payment method is fiat money
175      */
176     function fromPaymentGateway(address member)
177         public
178         memberExists(member)
179         nextMemberPaymentExists(member)
180         payable
181     {
182         handleIncomingPayment(member);
183     }
184 
185     /**
186      * @dev Send commission to marketplace
187      * @param member address
188      */
189     function handleIncomingPayment(address member)
190         private
191     {
192         if (nextMemberPayments[member].exists) {
193             NextMemberPayment storage nextMemberPayment = nextMemberPayments[member];
194 
195             require(nextMemberPayment.expectingValue == msg.value);
196 
197             /* Required code start */
198             // Send all incoming eth if user blocked
199             if (mp.isUserBlockedByContract(address(this))) {
200                 mp.payPlatformIncomingTransactionCommission.value(msg.value)(member);
201                 emit Blocked();
202             } else {
203                 mp.payPlatformIncomingTransactionCommission.value(nextMemberPayment.platformCommission)(member);
204                 emit PlatformIncomingTransactionCommission(nextMemberPayment.platformCommission, member);
205             }
206             /* Required code end */
207         }
208 
209         emit IncomingPayment(member, msg.value);
210     }
211 
212     /**
213      * @dev Creator can add ETH to contract without commission
214      */
215     function addEth()
216         public
217         onlyCreator
218         payable
219     {
220 
221     }
222 
223     /*
224      * Public functions
225      */
226     /// @dev Contract constructor sets initial owners and required number of confirmations.
227     constructor()
228         public
229     {
230         required = 1;           // Initial value
231         creator = msg.sender;
232 
233         /* Required code start */
234         // NOTE: CHANGE ADDRESS ON PRODUCTION
235         mp = MarketplaceProxy(0x7b71342582610452641989D599a684501922Cb57);
236         /* Required code end */
237 
238     }
239 
240     /// @dev Allows to add a new owner. Transaction has to be sent by wallet.
241     /// @param owner Address of new owner.
242     function addOwner(address owner)
243         public
244         onlyCreator
245         ownerDoesNotExist(owner)
246         notNull(owner)
247         validRequirement(owners.length + 1, required)
248     {
249         isOwner[owner] = true;
250         owners.push(owner);
251         emit OwnerAddition(owner);
252     }
253 
254     /// @dev Allows to remove an owner. Transaction has to be sent by wallet.
255     /// @param owner Address of owner.
256     function removeOwner(address owner)
257         public
258         onlyCreator
259         ownerExists(owner)
260     {
261         isOwner[owner] = false;
262         for (uint256 i=0; i<owners.length - 1; i++)
263             if (owners[i] == owner) {
264                 owners[i] = owners[owners.length - 1];
265                 break;
266             }
267         owners.length -= 1;
268         if (required > owners.length)
269             changeRequirement(owners.length);
270         emit OwnerRemoval(owner);
271     }
272 
273     /// @dev Allows to replace an owner with a new owner. Transaction has to be sent by wallet.
274     /// @param owner Address of owner to be replaced.
275     /// @param newOwner Address of new owner.
276     function replaceOwner(address owner, address newOwner)
277         public
278         onlyCreator
279         ownerExists(owner)
280         ownerDoesNotExist(newOwner)
281     {
282         for (uint256 i=0; i<owners.length; i++)
283             if (owners[i] == owner) {
284                 owners[i] = newOwner;
285                 break;
286             }
287         isOwner[owner] = false;
288         isOwner[newOwner] = true;
289         emit OwnerRemoval(owner);
290         emit OwnerAddition(newOwner);
291     }
292 
293     /// @dev Allows to change the number of required confirmations. Transaction has to be sent by wallet.
294     /// @param _required Number of required confirmations.
295     function changeRequirement(uint256 _required)
296         public
297         onlyCreator
298         validRequirement(owners.length, _required)
299     {
300         required = _required;
301         emit RequirementChange(_required);
302     }
303 
304     /// @dev Allows a creator to init a transaction.
305     /// @param destination Transaction target address.
306     /// @param value Transaction ether value.
307     /// @return Returns transaction ID.
308     function initTransaction(address destination, uint256 value)
309         public
310         onlyCreator
311         returns (uint256 transactionId)
312     {
313         transactionId = addTransaction(destination, value);
314     }
315 
316     /// @dev Allows an owner to confirm a transaction.
317     /// @param transactionId Transaction ID.
318     function confirmTransaction(uint256 transactionId)
319         public
320         ownerExists(msg.sender)
321         transactionExists(transactionId)
322         notConfirmed(transactionId, msg.sender)
323     {
324         confirmations[transactionId][msg.sender] = true;
325         emit Confirmation(msg.sender, transactionId);
326         executeTransaction(transactionId);
327     }
328 
329     /// @dev Allows an owner to revoke a confirmation for a transaction.
330     /// @param transactionId Transaction ID.
331     function revokeConfirmation(uint256 transactionId)
332         public
333         ownerExists(msg.sender)
334         confirmed(transactionId, msg.sender)
335         notExecuted(transactionId)
336     {
337         confirmations[transactionId][msg.sender] = false;
338         emit Revocation(msg.sender, transactionId);
339     }
340 
341     /// @dev Allows anyone to execute a confirmed transaction.
342     /// @param transactionId Transaction ID.
343     function executeTransaction(uint256 transactionId)
344         public
345         ownerExists(msg.sender)
346         confirmed(transactionId, msg.sender)
347         notExecuted(transactionId)
348     {
349         if (isConfirmed(transactionId)) {
350             Transaction storage txn = transactions[transactionId];
351             txn.executed = true;
352             if (external_call(txn.destination, txn.value, txn.data.length, txn.data))
353                 emit Execution(transactionId);
354             else {
355                 emit ExecutionFailure(transactionId);
356                 txn.executed = false;
357             }
358         }
359     }
360 
361     // call has been separated into its own function in order to take advantage
362     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
363     function external_call(address destination, uint256 value, uint256 dataLength, bytes data) private returns (bool) {
364         bool result;
365         assembly {
366             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
367             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
368             result := call(
369                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
370                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
371                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
372                 destination,
373                 value,
374                 d,
375                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
376                 x,
377                 0                  // Output is ignored, therefore the output size is zero
378             )
379         }
380         return result;
381     }
382 
383     /// @dev Returns the confirmation status of a transaction.
384     /// @param transactionId Transaction ID.
385     /// @return Confirmation status.
386     function isConfirmed(uint256 transactionId)
387         public
388         view
389         returns (bool)
390     {
391         uint256 count = 0;
392         for (uint256 i=0; i<owners.length; i++) {
393             if (confirmations[transactionId][owners[i]])
394                 count += 1;
395             if (count == required)
396                 return true;
397         }
398     }
399 
400     /**
401      * @dev Block existing member.
402      * @param member address
403      */
404     function blockMember(address member)
405         public
406         onlyCreator
407         memberExists(member)
408     {
409         members[member].blocked = true;
410         emit MemberBlocked(member);
411     }
412 
413     /**
414      * @dev Unblock existing member.
415      * @param member address
416      */
417     function unblockMember(address member)
418         public
419         onlyCreator
420         memberExists(member)
421     {
422         members[member].blocked = false;
423         emit MemberUnblocked(member);
424     }
425 
426     /**
427      * @param member address
428      * @return bool
429      */
430     function isMemberBlocked(address member)
431         public
432         view
433         memberExists(member)
434         returns (bool)
435     {
436         return members[member].blocked;
437     }
438 
439     /**
440      * @dev Add a new member to structure.
441      * @param member address
442      */
443     function addMember(address member)
444         public
445         onlyCreator
446         notNull(member)
447         memberDoesNotExist(member)
448     {
449         members[member] = Member(
450             true,   // exists
451             false   // blocked
452         );
453         emit MemberAdded(member);
454     }
455 
456     /**
457      * @param _feeAmount new amount in wei
458      */
459     function setFeeAmount(uint256 _feeAmount)
460         public
461         onlyCreator
462     {
463         feeAmount = _feeAmount;
464         emit FeeAmountChanged(_feeAmount);
465     }
466 
467     /**
468      * @param member address
469      * @return bool
470      */
471     function addNextMemberPayment(address member, uint256 expectingValue, uint256 platformCommission)
472         public
473         onlyCreator
474         memberExists(member)
475         nextMemberPaymentDoesNotExist(member)
476     {
477         nextMemberPayments[member] = NextMemberPayment(
478             true,
479             expectingValue,
480             platformCommission
481         );
482         emit NextMemberPaymentAdded(member, expectingValue, platformCommission);
483     }
484 
485     /**
486      * @param member address
487      * @return bool
488      */
489     function updateNextMemberPayment(address member, uint256 _expectingValue, uint256 _platformCommission)
490         public
491         onlyCreator
492         memberExists(member)
493         nextMemberPaymentExists(member)
494     {
495         nextMemberPayments[member].expectingValue = _expectingValue;
496         nextMemberPayments[member].platformCommission = _platformCommission;
497         emit NextMemberPaymentUpdated(member, _expectingValue, _platformCommission);
498     }
499 
500     /**
501      * @param to send ETH on this address
502      * @param amount 18 decimals (wei)
503      */
504     function claim(address to, uint256 amount)
505         public
506         onlyCreator
507         memberExists(to)
508     {
509         /* Required code start */
510         // Get commission amount from marketplace
511         uint256 commission = mp.calculatePlatformCommission(amount);
512         require(address(this).balance > (amount + commission));
513 
514         // Send commission to marketplace
515         mp.payPlatformOutgoingTransactionCommission.value(commission)();
516         emit PlatformOutgoingTransactionCommission(commission);
517         /* Required code end */
518 
519         to.transfer(amount);
520 
521         emit Claim(to, amount);
522     }
523 
524     /**
525      * @param to send ETH on this address
526      * @param amount 18 decimals (wei)
527      */
528     function transfer(address to, uint256 amount)
529         public
530         onlyCreator
531         ownerExists(to)
532     {
533         /* Required code start */
534         require(address(this).balance > amount);
535         /* Required code end */
536 
537         to.transfer(amount);
538 
539         emit Transfer(to, amount);
540     }
541 
542     /*
543      * Internal functions
544      */
545     /// @dev Adds a new transaction to the transaction mapping, if transaction does not exist yet.
546     /// @param destination Transaction target address.
547     /// @param value Transaction ether value.
548     /// @return Returns transaction ID.
549     function addTransaction(address destination, uint256 value)
550         internal
551         notNull(destination)
552         returns (uint256 transactionId)
553     {
554         transactionId = transactionCount;
555         transactions[transactionId] = Transaction({
556             destination: destination,
557             value: value,
558             data: "",
559             executed: false
560         });
561         transactionCount += 1;
562         emit Submission(transactionId);
563     }
564 
565     /*
566      * Web3 call functions
567      */
568     /// @dev Returns number of confirmations of a transaction.
569     /// @param transactionId Transaction ID.
570     /// @return Number of confirmations.
571     function getConfirmationCount(uint256 transactionId)
572         public
573         view
574         returns (uint256 count)
575     {
576         for (uint256 i=0; i<owners.length; i++)
577             if (confirmations[transactionId][owners[i]])
578                 count += 1;
579     }
580 
581     /// @dev Returns total number of transactions after filers are applied.
582     /// @param pending Include pending transactions.
583     /// @param executed Include executed transactions.
584     /// @return Total number of transactions after filters are applied.
585     function getTransactionCount(bool pending, bool executed)
586         public
587         view
588         returns (uint256 count)
589     {
590         for (uint256 i=0; i<transactionCount; i++)
591             if (   pending && !transactions[i].executed
592                 || executed && transactions[i].executed)
593                 count += 1;
594     }
595 
596     /// @dev Returns list of owners.
597     /// @return List of owner addresses.
598     function getOwners()
599         public
600         view
601         returns (address[])
602     {
603         return owners;
604     }
605 
606     /// @dev Returns array with owner addresses, which confirmed transaction.
607     /// @param transactionId Transaction ID.
608     /// @return Returns array of owner addresses.
609     function getConfirmations(uint256 transactionId)
610         public
611         view
612         returns (address[] _confirmations)
613     {
614         address[] memory confirmationsTemp = new address[](owners.length);
615         uint256 count = 0;
616         uint256 i;
617         for (i=0; i<owners.length; i++)
618             if (confirmations[transactionId][owners[i]]) {
619                 confirmationsTemp[count] = owners[i];
620                 count += 1;
621             }
622         _confirmations = new address[](count);
623         for (i=0; i<count; i++)
624             _confirmations[i] = confirmationsTemp[i];
625     }
626 
627     /// @dev Returns list of transaction IDs in defined range.
628     /// @param from Index start position of transaction array.
629     /// @param to Index end position of transaction array.
630     /// @param pending Include pending transactions.
631     /// @param executed Include executed transactions.
632     /// @return Returns array of transaction IDs.
633     function getTransactionIds(uint256 from, uint256 to, bool pending, bool executed)
634         public
635         view
636         returns (uint[] _transactionIds)
637     {
638         uint[] memory transactionIdsTemp = new uint[](transactionCount);
639         uint256 count = 0;
640         uint256 i;
641         for (i=0; i<transactionCount; i++)
642             if (   pending && !transactions[i].executed
643                 || executed && transactions[i].executed)
644             {
645                 transactionIdsTemp[count] = i;
646                 count += 1;
647             }
648         _transactionIds = new uint[](to - from);
649         for (i=from; i<to; i++)
650             _transactionIds[i - from] = transactionIdsTemp[i];
651     }
652 }