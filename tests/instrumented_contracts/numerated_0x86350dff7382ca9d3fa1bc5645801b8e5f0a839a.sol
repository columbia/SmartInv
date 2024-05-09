1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, April 24, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.25;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(
21         address indexed from,
22         address indexed to,
23         uint256 value
24     );
25 
26     event Approval(
27         address indexed owner,
28         address indexed spender,
29         uint256 value
30     );
31 }
32 
33 /**
34  * @title math operations that returns specific size reults (32, 64 and 256
35  *        bits)
36  */
37 library SafeMath {
38 
39     /**
40      * @dev Multiplies two numbers and returns a uint64
41      * @param a A number
42      * @param b A number
43      * @return a * b as a uint64
44      */
45     function mul64(uint256 a, uint256 b) internal pure returns (uint64) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b);
51         require(c < 2**64);
52         return uint64(c);
53     }
54 
55     /**
56      * @dev Divides two numbers and returns a uint64
57      * @param a A number
58      * @param b A number
59      * @return a / b as a uint64
60      */
61     function div64(uint256 a, uint256 b) internal pure returns (uint64) {
62         uint256 c = a / b;
63         require(c < 2**64);
64         /* solcov ignore next */
65         return uint64(c);
66     }
67 
68     /**
69      * @dev Substracts two numbers and returns a uint64
70      * @param a A number
71      * @param b A number
72      * @return a - b as a uint64
73      */
74     function sub64(uint256 a, uint256 b) internal pure returns (uint64) {
75         require(b <= a);
76         uint256 c = a - b;
77         require(c < 2**64);
78         /* solcov ignore next */
79         return uint64(c);
80     }
81 
82     /**
83      * @dev Adds two numbers and returns a uint64
84      * @param a A number
85      * @param b A number
86      * @return a + b as a uint64
87      */
88     function add64(uint256 a, uint256 b) internal pure returns (uint64) {
89         uint256 c = a + b;
90         require(c >= a && c < 2**64);
91         /* solcov ignore next */
92         return uint64(c);
93     }
94 
95     /**
96      * @dev Multiplies two numbers and returns a uint32
97      * @param a A number
98      * @param b A number
99      * @return a * b as a uint32
100      */
101     function mul32(uint256 a, uint256 b) internal pure returns (uint32) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         require(c / a == b);
107         require(c < 2**32);
108         /* solcov ignore next */
109         return uint32(c);
110     }
111 
112     /**
113      * @dev Divides two numbers and returns a uint32
114      * @param a A number
115      * @param b A number
116      * @return a / b as a uint32
117      */
118     function div32(uint256 a, uint256 b) internal pure returns (uint32) {
119         uint256 c = a / b;
120         require(c < 2**32);
121         /* solcov ignore next */
122         return uint32(c);
123     }
124 
125     /**
126      * @dev Substracts two numbers and returns a uint32
127      * @param a A number
128      * @param b A number
129      * @return a - b as a uint32
130      */
131     function sub32(uint256 a, uint256 b) internal pure returns (uint32) {
132         require(b <= a);
133         uint256 c = a - b;
134         require(c < 2**32);
135         /* solcov ignore next */
136         return uint32(c);
137     }
138 
139     /**
140      * @dev Adds two numbers and returns a uint32
141      * @param a A number
142      * @param b A number
143      * @return a + b as a uint32
144      */
145     function add32(uint256 a, uint256 b) internal pure returns (uint32) {
146         uint256 c = a + b;
147         require(c >= a && c < 2**32);
148         return uint32(c);
149     }
150 
151     /**
152      * @dev Multiplies two numbers and returns a uint256
153      * @param a A number
154      * @param b A number
155      * @return a * b as a uint256
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         if (a == 0) {
159             return 0;
160         }
161         uint256 c = a * b;
162         require(c / a == b);
163         /* solcov ignore next */
164         return c;
165     }
166 
167     /**
168      * @dev Divides two numbers and returns a uint256
169      * @param a A number
170      * @param b A number
171      * @return a / b as a uint256
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a / b;
175         /* solcov ignore next */
176         return c;
177     }
178 
179     /**
180      * @dev Substracts two numbers and returns a uint256
181      * @param a A number
182      * @param b A number
183      * @return a - b as a uint256
184      */
185     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186         require(b <= a);
187         return a - b;
188     }
189 
190     /**
191      * @dev Adds two numbers and returns a uint256
192      * @param a A number
193      * @param b A number
194      * @return a + b as a uint256
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a);
199         return c;
200     }
201 }
202 
203 
204 
205 /**
206  * @title Merkle Tree's proof helper contract
207  */
208 library Merkle {
209 
210     /**
211      * @dev calculates the hash of two child nodes on the merkle tree.
212      * @param a Hash of the left child node.
213      * @param b Hash of the right child node.
214      * @return sha3 hash of the resulting node.
215      */
216     function combinedHash(bytes32 a, bytes32 b) public pure returns(bytes32) {
217         return keccak256(abi.encodePacked(a, b));
218     }
219 
220     /**
221      * @dev calculates a root hash associated with a Merkle proof
222      * @param proof array of proof hashes
223      * @param key index of the leaf element list.
224      *        this key indicates the specific position of the leaf
225      *        in the merkle tree. It will be used to know if the
226      *        node that will be hashed along with the proof node
227      *        is placed on the right or the left of the current
228      *        tree level. That is achieved by doing the modulo of
229      *        the current key/position. A new level of nodes will
230      *        be evaluated after that, and the new left or right
231      *        position is obtained by doing the same operation, 
232      *        after dividing the key/position by two.
233      * @param leaf the leaf element to verify on the set.
234      * @return the hash of the Merkle proof. Should match the Merkle root
235      *         if the proof is valid
236      */
237     function getProofRootHash(bytes32[] memory proof, uint256 key, bytes32 leaf) public pure returns(bytes32) {
238         bytes32 hash = keccak256(abi.encodePacked(leaf));
239         uint256 k = key;
240         for(uint i = 0; i<proof.length; i++) {
241             uint256 bit = k % 2;
242             k = k / 2;
243 
244             if (bit == 0)
245                 hash = combinedHash(hash, proof[i]);
246             else
247                 hash = combinedHash(proof[i], hash);
248         }
249         return hash;
250     }
251 }
252 
253 /**
254  * @title Data Structures for BatPay: Accounts, Payments & Challenge
255  */
256 contract Data {
257     struct Account {
258         address owner;
259         uint64  balance;
260         uint32  lastCollectedPaymentId;
261     }
262 
263     struct BulkRegistration {
264         bytes32 rootHash;
265         uint32  recordCount;
266         uint32  smallestRecordId;
267     }
268 
269     struct Payment {
270         uint32  fromAccountId;
271         uint64  amount;
272         uint64  fee;
273         uint32  smallestAccountId;
274         uint32  greatestAccountId;
275         uint32  totalNumberOfPayees;
276         uint64  lockTimeoutBlockNumber;
277         bytes32 paymentDataHash;
278         bytes32 lockingKeyHash;
279         bytes32 metadata;
280     }
281 
282     struct CollectSlot {
283         uint32  minPayIndex;
284         uint32  maxPayIndex;
285         uint64  amount;
286         uint64  delegateAmount;
287         uint32  to;
288         uint64  block;
289         uint32  delegate;
290         uint32  challenger;
291         uint32  index;
292         uint64  challengeAmount;
293         uint8   status;
294         address addr;
295         bytes32 data;
296     }
297 
298     struct Config {
299         uint32 maxBulk;
300         uint32 maxTransfer;
301         uint32 challengeBlocks;
302         uint32 challengeStepBlocks;
303         uint64 collectStake;
304         uint64 challengeStake;
305         uint32 unlockBlocks;
306         uint32 massExitIdBlocks;
307         uint32 massExitIdStepBlocks;
308         uint32 massExitBalanceBlocks;
309         uint32 massExitBalanceStepBlocks;
310         uint64 massExitStake;
311         uint64 massExitChallengeStake;
312         uint64 maxCollectAmount;
313     }
314 
315     Config public params;
316     address public owner;
317 
318     uint public constant MAX_ACCOUNT_ID = 2**32-1;    // Maximum account id (32-bits)
319     uint public constant NEW_ACCOUNT_FLAG = 2**256-1; // Request registration of new account
320     uint public constant INSTANT_SLOT = 32768;
321 
322 }
323 
324 
325 /**
326   * @title Accounts, methods to manage accounts and balances
327   */
328 
329 contract Accounts is Data {
330     event BulkRegister(uint bulkSize, uint smallestAccountId, uint bulkId );
331     event AccountRegistered(uint accountId, address accountAddress);
332 
333     IERC20 public token;
334     Account[] public accounts;
335     BulkRegistration[] public bulkRegistrations;
336 
337     /**
338       * @dev determines whether accountId is valid
339       * @param accountId an account id
340       * @return boolean
341       */
342     function isValidId(uint accountId) public view returns (bool) {
343         return (accountId < accounts.length);
344     }
345 
346     /**
347       * @dev determines whether accountId is the owner of the account
348       * @param accountId an account id
349       * @return boolean
350       */
351     function isAccountOwner(uint accountId) public view returns (bool) {
352         return isValidId(accountId) && msg.sender == accounts[accountId].owner;
353     }
354 
355     /**
356       * @dev modifier to restrict that accountId is valid
357       * @param accountId an account id
358       */
359     modifier validId(uint accountId) {
360         require(isValidId(accountId), "accountId is not valid");
361         _;
362     }
363 
364     /**
365       * @dev modifier to restrict that accountId is owner
366       * @param accountId an account ID
367       */
368     modifier onlyAccountOwner(uint accountId) {
369         require(isAccountOwner(accountId), "Only account owner can invoke this method");
370         _;
371     }
372 
373     /**
374       * @dev Reserve accounts but delay assigning addresses.
375       *      Accounts will be claimed later using MerkleTree's rootHash.
376       * @param bulkSize Number of accounts to reserve.
377       * @param rootHash Hash of the root node of the Merkle Tree referencing the list of addresses.
378       */
379     function bulkRegister(uint256 bulkSize, bytes32 rootHash) public {
380         require(bulkSize > 0, "Bulk size can't be zero");
381         require(bulkSize < params.maxBulk, "Cannot register this number of ids simultaneously");
382         require(SafeMath.add(accounts.length, bulkSize) <= MAX_ACCOUNT_ID, "Cannot register: ran out of ids");
383         require(rootHash > 0, "Root hash can't be zero");
384 
385         emit BulkRegister(bulkSize, accounts.length, bulkRegistrations.length);
386         bulkRegistrations.push(BulkRegistration(rootHash, uint32(bulkSize), uint32(accounts.length)));
387         accounts.length = SafeMath.add(accounts.length, bulkSize);
388     }
389 
390     /** @dev Complete registration for a reserved account by showing the
391       *     bulkRegistration-id and Merkle proof associated with this address
392       * @param addr Address claiming this account
393       * @param proof Merkle proof for address and id
394       * @param accountId Id of the account to be registered.
395       * @param bulkId BulkRegistration id for the transaction reserving this account
396       */
397     function claimBulkRegistrationId(address addr, bytes32[] memory proof, uint accountId, uint bulkId) public {
398         require(bulkId < bulkRegistrations.length, "the bulkId referenced is invalid");
399         uint smallestAccountId = bulkRegistrations[bulkId].smallestRecordId;
400         uint n = bulkRegistrations[bulkId].recordCount;
401         bytes32 rootHash = bulkRegistrations[bulkId].rootHash;
402         bytes32 hash = Merkle.getProofRootHash(proof, SafeMath.sub(accountId, smallestAccountId), bytes32(addr));
403 
404         require(accountId >= smallestAccountId && accountId < smallestAccountId + n,
405             "the accountId specified is not part of that bulk registration slot");
406         require(hash == rootHash, "invalid Merkle proof");
407         emit AccountRegistered(accountId, addr);
408 
409         accounts[accountId].owner = addr;
410     }
411 
412     /**
413       * @dev Register a new account
414       * @return the id of the new account
415       */
416     function register() public returns (uint32 ret) {
417         require(accounts.length < MAX_ACCOUNT_ID, "no more accounts left");
418         ret = (uint32)(accounts.length);
419         accounts.push(Account(msg.sender, 0, 0));
420         emit AccountRegistered(ret, msg.sender);
421         return ret;
422     }
423 
424     /**
425      * @dev withdraw tokens from the BatchPayment contract into the original address.
426      * @param amount Amount of tokens to withdraw.
427      * @param accountId Id of the user requesting the withdraw.
428      */
429     function withdraw(uint64 amount, uint256 accountId)
430         external
431         onlyAccountOwner(accountId)
432     {
433         uint64 balance = accounts[accountId].balance;
434 
435         require(balance >= amount, "insufficient funds");
436         require(amount > 0, "amount should be nonzero");
437 
438         balanceSub(accountId, amount);
439 
440         require(token.transfer(msg.sender, amount), "transfer failed");
441     }
442 
443     /**
444      * @dev Deposit tokens into the BatchPayment contract to enable scalable payments
445      * @param amount Amount of tokens to deposit on `accountId`. User should have
446      *        enough balance and issue an `approve()` method prior to calling this.
447      * @param accountId The id of the user account. In case `NEW_ACCOUNT_FLAG` is used,
448      *        a new account will be registered and the requested amount will be
449      *        deposited in a single operation.
450      */
451     function deposit(uint64 amount, uint256 accountId) external {
452         require(accountId < accounts.length || accountId == NEW_ACCOUNT_FLAG, "invalid accountId");
453         require(amount > 0, "amount should be positive");
454 
455         if (accountId == NEW_ACCOUNT_FLAG) {
456             // new account
457             uint newId = register();
458             accounts[newId].balance = amount;
459         } else {
460             // existing account
461             balanceAdd(accountId, amount);
462         }
463 
464         require(token.transferFrom(msg.sender, address(this), amount), "transfer failed");
465     }
466 
467     /**
468      * @dev Increase the specified account balance by `amount` tokens.
469      * @param accountId An account id
470      * @param amount number of tokens
471      */
472     function balanceAdd(uint accountId, uint64 amount)
473     internal
474     validId(accountId)
475     {
476         accounts[accountId].balance = SafeMath.add64(accounts[accountId].balance, amount);
477     }
478 
479     /**
480      *  @dev Substract `amount` tokens from the specified account's balance
481      *  @param accountId An account id
482      *  @param amount number of tokens
483      */
484     function balanceSub(uint accountId, uint64 amount)
485     internal
486     validId(accountId)
487     {
488         uint64 balance = accounts[accountId].balance;
489         require(balance >= amount, "not enough funds");
490         accounts[accountId].balance = SafeMath.sub64(balance, amount);
491     }
492 
493     /**
494      *  @dev returns the balance associated with the account in tokens
495      *  @param accountId account requested.
496      */
497     function balanceOf(uint accountId)
498         external
499         view
500         validId(accountId)
501         returns (uint64)
502     {
503         return accounts[accountId].balance;
504     }
505 
506     /**
507       * @dev gets number of accounts registered and reserved.
508       * @return returns the size of the accounts array.
509       */
510     function getAccountsLength() external view returns (uint) {
511         return accounts.length;
512     }
513 
514     /**
515       * @dev gets the number of bulk registrations performed
516       * @return the size of the bulkRegistrations array.
517       */
518     function getBulkLength() external view returns (uint) {
519         return bulkRegistrations.length;
520     }
521 }
522 
523 
524 /**
525  * @title Challenge helper library
526  */
527 library Challenge {
528 
529     uint8 public constant PAY_DATA_HEADER_MARKER = 0xff; // marker in payData header
530 
531     /**
532      * @dev Reverts if challenge period has expired or Collect Slot status is
533      *      not a valid one.
534      */
535     modifier onlyValidCollectSlot(Data.CollectSlot storage collectSlot, uint8 validStatus) {
536         require(!challengeHasExpired(collectSlot), "Challenge has expired");
537         require(isSlotStatusValid(collectSlot, validStatus), "Wrong Collect Slot status");
538         _;
539     }
540 
541     /**
542      * @return true if the current block number is greater or equal than the
543      *         allowed block for this challenge.
544      */
545     function challengeHasExpired(Data.CollectSlot storage collectSlot) public view returns (bool) {
546         return collectSlot.block <= block.number;
547     }
548 
549     /**
550      * @return true if the Slot status is valid.
551      */
552     function isSlotStatusValid(Data.CollectSlot storage collectSlot, uint8 validStatus) public view returns (bool) {
553         return collectSlot.status == validStatus;
554     }
555 
556     /** @dev calculates new block numbers based on the current block and a
557      *      delta constant specified by the protocol policy.
558      * @param delta number of blocks into the future to calculate.
559      * @return future block number.
560      */
561     function getFutureBlock(uint delta) public view returns(uint64) {
562         return SafeMath.add64(block.number, delta);
563     }
564 
565     /**
566      * @dev Inspects the compact payment list provided and calculates the sum
567      *      of the amounts referenced
568      * @param data binary array, with 12 bytes per item. 8-bytes amount,
569      *        4-bytes payment index.
570      * @return the sum of the amounts referenced on the array.
571      */
572     function getDataSum(bytes memory data) public pure returns (uint sum) {
573         require(data.length > 0, "no data provided");
574         require(data.length % 12 == 0, "wrong data format, data length should be multiple of 12");
575 
576         uint n = SafeMath.div(data.length, 12);
577         uint modulus = 2**64;
578 
579         sum = 0;
580 
581         // Get the sum of the stated amounts in data
582         // Each entry in data is [8-bytes amount][4-bytes payIndex]
583 
584         for (uint i = 0; i < n; i++) {
585             // solium-disable-next-line security/no-inline-assembly
586             assembly {
587                 let amount := mod(mload(add(data, add(8, mul(i, 12)))), modulus)
588                 let result := add(sum, amount)
589                 switch or(gt(result, modulus), eq(result, modulus))
590                 case 1 { revert (0, 0) }
591                 default { sum := result }
592             }
593         }
594     }
595 
596     /**
597      * @dev Helper function that obtains the amount/payIndex pair located at
598      *      position `index`.
599      * @param data binary array, with 12 bytes per item. 8-bytes amount,
600      *        4-bytes payment index.
601      * @param index Array item requested.
602      * @return amount and payIndex requested.
603      */
604     function getDataAtIndex(bytes memory data, uint index) public pure returns (uint64 amount, uint32 payIndex) {
605         require(data.length > 0, "no data provided");
606         require(data.length % 12 == 0, "wrong data format, data length should be multiple of 12");
607 
608         uint mod1 = 2**64;
609         uint mod2 = 2**32;
610         uint i = SafeMath.mul(index, 12);
611 
612         require(i <= SafeMath.sub(data.length, 12), "index * 12 must be less or equal than (data.length - 12)");
613 
614         // solium-disable-next-line security/no-inline-assembly
615         assembly {
616             amount := mod( mload(add(data, add(8, i))), mod1 )
617 
618             payIndex := mod( mload(add(data, add(12, i))), mod2 )
619         }
620     }
621 
622     /**
623      * @dev obtains the number of bytes per id in `payData`
624      * @param payData efficient binary representation of a list of accountIds
625      * @return bytes per id in `payData`
626      */
627     function getBytesPerId(bytes payData) internal pure returns (uint) {
628         // payData includes a 2 byte header and a list of ids
629         // [0xff][bytesPerId]
630 
631         uint len = payData.length;
632         require(len >= 2, "payData length should be >= 2");
633         require(uint8(payData[0]) == PAY_DATA_HEADER_MARKER, "payData header missing");
634         uint bytesPerId = uint(payData[1]);
635         require(bytesPerId > 0 && bytesPerId < 32, "second byte of payData should be positive and less than 32");
636 
637         // remaining bytes should be a multiple of bytesPerId
638         require((len - 2) % bytesPerId == 0,
639         "payData length is invalid, all payees must have same amount of bytes (payData[1])");
640 
641         return bytesPerId;
642     }
643 
644     /**
645      * @dev Process payData, inspecting the list of ids, accumulating the amount for
646      *    each entry of `id`.
647      *   `payData` includes 2 header bytes, followed by n bytesPerId-bytes entries.
648      *   `payData` format: [byte 0xff][byte bytesPerId][delta 0][delta 1]..[delta n-1]
649      * @param payData List of payees of a specific Payment, with the above format.
650      * @param id ID to look for in `payData`
651      * @param amount amount per occurrence of `id` in `payData`
652      * @return the amount sum for all occurrences of `id` in `payData`
653      */
654     function getPayDataSum(bytes memory payData, uint id, uint amount) public pure returns (uint sum) {
655         uint bytesPerId = getBytesPerId(payData);
656         uint modulus = 1 << SafeMath.mul(bytesPerId, 8);
657         uint currentId = 0;
658 
659         sum = 0;
660 
661         for (uint i = 2; i < payData.length; i += bytesPerId) {
662             // Get next id delta from paydata
663             // currentId += payData[2+i*bytesPerId]
664 
665             // solium-disable-next-line security/no-inline-assembly
666             assembly {
667                 currentId := add(
668                     currentId,
669                     mod(
670                         mload(add(payData, add(i, bytesPerId))),
671                         modulus))
672 
673                 switch eq(currentId, id)
674                 case 1 { sum := add(sum, amount) }
675             }
676         }
677     }
678 
679     /**
680      * @dev calculates the number of accounts included in payData
681      * @param payData efficient binary representation of a list of accountIds
682      * @return number of accounts present
683      */
684     function getPayDataCount(bytes payData) public pure returns (uint) {
685         uint bytesPerId = getBytesPerId(payData);
686 
687         // calculate number of records
688         return SafeMath.div(payData.length - 2, bytesPerId);
689     }
690 
691     /**
692      * @dev function. Phase I of the challenging game
693      * @param collectSlot Collect slot
694      * @param config Various parameters
695      * @param accounts a reference to the main accounts array
696      * @param challenger id of the challenger user
697      */
698     function challenge_1(
699         Data.CollectSlot storage collectSlot,
700         Data.Config storage config,
701         Data.Account[] storage accounts,
702         uint32 challenger
703     )
704         public
705         onlyValidCollectSlot(collectSlot, 1)
706     {
707         require(accounts[challenger].balance >= config.challengeStake, "not enough balance");
708 
709         collectSlot.status = 2;
710         collectSlot.challenger = challenger;
711         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
712 
713         accounts[challenger].balance -= config.challengeStake;
714     }
715 
716     /**
717      * @dev Internal function. Phase II of the challenging game
718      * @param collectSlot Collect slot
719      * @param config Various parameters
720      * @param data Binary array listing the payments in which the user was referenced.
721      */
722     function challenge_2(
723         Data.CollectSlot storage collectSlot,
724         Data.Config storage config,
725         bytes memory data
726     )
727         public
728         onlyValidCollectSlot(collectSlot, 2)
729     {
730         require(getDataSum(data) == collectSlot.amount, "data doesn't represent collected amount");
731 
732         collectSlot.data = keccak256(data);
733         collectSlot.status = 3;
734         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
735     }
736 
737     /**
738      * @dev Internal function. Phase III of the challenging game
739      * @param collectSlot Collect slot
740      * @param config Various parameters
741      * @param data Binary array listing the payments in which the user was referenced.
742      * @param disputedPaymentIndex index selecting the disputed payment
743      */
744     function challenge_3(
745         Data.CollectSlot storage collectSlot,
746         Data.Config storage config,
747         bytes memory data,
748         uint32 disputedPaymentIndex
749     )
750         public
751         onlyValidCollectSlot(collectSlot, 3)
752     {
753         require(collectSlot.data == keccak256(data),
754         "data mismatch, collected data hash doesn't match provided data hash");
755         (collectSlot.challengeAmount, collectSlot.index) = getDataAtIndex(data, disputedPaymentIndex);
756         collectSlot.status = 4;
757         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
758     }
759 
760     /**
761      * @dev Internal function. Phase IV of the challenging game
762      * @param collectSlot Collect slot
763      * @param payments a reference to the BatPay payments array
764      * @param payData binary data describing the list of account receiving
765      *        tokens on the selected transfer
766      */
767     function challenge_4(
768         Data.CollectSlot storage collectSlot,
769         Data.Payment[] storage payments,
770         bytes memory payData
771     )
772         public
773         onlyValidCollectSlot(collectSlot, 4)
774     {
775         require(collectSlot.index >= collectSlot.minPayIndex && collectSlot.index < collectSlot.maxPayIndex,
776             "payment referenced is out of range");
777         Data.Payment memory p = payments[collectSlot.index];
778         require(keccak256(payData) == p.paymentDataHash,
779         "payData mismatch, payment's data hash doesn't match provided payData hash");
780         require(p.lockingKeyHash == 0, "payment is locked");
781 
782         uint collected = getPayDataSum(payData, collectSlot.to, p.amount);
783 
784         // Check if id is included in bulkRegistration within payment
785         if (collectSlot.to >= p.smallestAccountId && collectSlot.to < p.greatestAccountId) {
786             collected = SafeMath.add(collected, p.amount);
787         }
788 
789         require(collected == collectSlot.challengeAmount,
790         "amount mismatch, provided payData sum doesn't match collected challenge amount");
791 
792         collectSlot.status = 5;
793     }
794 
795     /**
796      * @dev the challenge was completed successfully, or the delegate failed to respond on time.
797      *      The challenger will collect the stake.
798      * @param collectSlot Collect slot
799      * @param config Various parameters
800      * @param accounts a reference to the main accounts array
801      */
802     function challenge_success(
803         Data.CollectSlot storage collectSlot,
804         Data.Config storage config,
805         Data.Account[] storage accounts
806     )
807         public
808     {
809         require((collectSlot.status == 2 || collectSlot.status == 4),
810             "Wrong Collect Slot status");
811         require(challengeHasExpired(collectSlot),
812             "Challenge not yet finished");
813 
814         accounts[collectSlot.challenger].balance = SafeMath.add64(
815             accounts[collectSlot.challenger].balance,
816             SafeMath.add64(config.collectStake, config.challengeStake));
817 
818         collectSlot.status = 0;
819     }
820 
821     /**
822      * @dev Internal function. The delegate proved the challenger wrong, or
823      *      the challenger failed to respond on time. The delegae collects the stake.
824      * @param collectSlot Collect slot
825      * @param config Various parameters
826      * @param accounts a reference to the main accounts array
827      */
828     function challenge_failed(
829         Data.CollectSlot storage collectSlot,
830         Data.Config storage config,
831         Data.Account[] storage accounts
832     )
833         public
834     {
835         require(collectSlot.status == 5 || (collectSlot.status == 3 && block.number >= collectSlot.block),
836             "challenge not completed");
837 
838         // Challenge failed
839         // delegate wins Stake
840         accounts[collectSlot.delegate].balance = SafeMath.add64(
841             accounts[collectSlot.delegate].balance,
842             config.challengeStake);
843 
844         // reset slot to status=1, waiting for challenges
845         collectSlot.challenger = 0;
846         collectSlot.status = 1;
847         collectSlot.block = getFutureBlock(config.challengeBlocks);
848     }
849 
850     /**
851      * @dev Helps verify a ECDSA signature, while recovering the signing address.
852      * @param hash Hash of the signed message
853      * @param sig binary representation of the r, s & v parameters.
854      * @return address of the signer if data provided is valid, zero otherwise.
855      */
856     function recoverHelper(bytes32 hash, bytes sig) public pure returns (address) {
857         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
858         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
859 
860         bytes32 r;
861         bytes32 s;
862         uint8 v;
863 
864         // Check the signature length
865         if (sig.length != 65) {
866             return (address(0));
867         }
868 
869         // Divide the signature in r, s and v variables
870         // ecrecover takes the signature parameters, and the only way to get them
871         // currently is to use assembly.
872         // solium-disable-next-line security/no-inline-assembly
873         assembly {
874             r := mload(add(sig, 32))
875             s := mload(add(sig, 64))
876             v := byte(0, mload(add(sig, 96)))
877         }
878 
879         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
880         if (v < 27) {
881             v += 27;
882         }
883 
884         // If the version is correct return the signer address
885         if (v != 27 && v != 28) {
886             return address(0);
887         }
888 
889         return ecrecover(prefixedHash, v, r, s);
890     }
891 }
892 
893 
894 /**
895  * @title Payments and Challenge game - Performs the operations associated with
896  *        transfer and the different steps of the collect challenge game.
897  */
898 contract Payments is Accounts {
899     event PaymentRegistered(
900         uint32 indexed payIndex,
901         uint indexed from,
902         uint totalNumberOfPayees,
903         uint amount
904     );
905 
906     event PaymentUnlocked(uint32 indexed payIndex, bytes key);
907     event PaymentRefunded(uint32 beneficiaryAccountId, uint64 amountRefunded);
908 
909     /**
910      * Event for collection logging. Off-chain monitoring services may listen
911      * to this event to trigger challenges.
912      */
913     event Collect(
914         uint indexed delegate,
915         uint indexed slot,
916         uint indexed to,
917         uint32 fromPayindex,
918         uint32 toPayIndex,
919         uint amount
920     );
921 
922     event Challenge1(uint indexed delegate, uint indexed slot, uint challenger);
923     event Challenge2(uint indexed delegate, uint indexed slot);
924     event Challenge3(uint indexed delegate, uint indexed slot, uint index);
925     event Challenge4(uint indexed delegate, uint indexed slot);
926     event ChallengeSuccess(uint indexed delegate, uint indexed slot);
927     event ChallengeFailed(uint indexed delegate, uint indexed slot);
928 
929     Payment[] public payments;
930     mapping (uint32 => mapping (uint32 => CollectSlot)) public collects;
931 
932     /**
933      * @dev Register token payment to multiple recipients
934      * @param fromId Account id for the originator of the transaction
935      * @param amount Amount of tokens to pay each destination.
936      * @param fee Fee in tokens to be payed to the party providing the unlocking service
937      * @param payData Efficient representation of the destination account list
938      * @param newCount Number of new destination accounts that will be reserved during the registerPayment transaction
939      * @param rootHash Hash of the root hash of the Merkle tree listing the addresses reserved.
940      * @param lockingKeyHash hash resulting of calculating the keccak256 of
941      *        of the key locking this payment to help in atomic data swaps.
942      *        This hash will later be used by the `unlock` function to unlock the payment we are registering.
943      *         The `lockingKeyHash` must be equal to the keccak256 of the packed
944      *         encoding of the unlockerAccountId and the key used by the unlocker to encrypt the traded data:
945      *             `keccak256(abi.encodePacked(unlockerAccountId, key))`
946      *         DO NOT use previously used locking keys, since an attacker could realize that by comparing key hashes
947      * @param metadata Application specific data to be stored associated with the payment
948      */
949     function registerPayment(
950         uint32 fromId,
951         uint64 amount,
952         uint64 fee,
953         bytes payData,
954         uint newCount,
955         bytes32 rootHash,
956         bytes32 lockingKeyHash,
957         bytes32 metadata
958     )
959         external
960     {
961         require(payments.length < 2**32, "Cannot add more payments");
962         require(isAccountOwner(fromId), "Invalid fromId");
963         require(amount > 0, "Invalid amount");
964         require(newCount == 0 || rootHash > 0, "Invalid root hash"); // although bulkRegister checks this, we anticipate
965         require(fee == 0 || lockingKeyHash > 0, "Invalid lock hash");
966 
967         Payment memory p;
968 
969         // Prepare a Payment struct
970         p.totalNumberOfPayees = SafeMath.add32(Challenge.getPayDataCount(payData), newCount);
971         require(p.totalNumberOfPayees > 0, "Invalid number of payees, should at least be 1 payee");
972         require(p.totalNumberOfPayees < params.maxTransfer,
973         "Too many payees, it should be less than config maxTransfer");
974 
975         p.fromAccountId = fromId;
976         p.amount = amount;
977         p.fee = fee;
978         p.lockingKeyHash = lockingKeyHash;
979         p.metadata = metadata;
980         p.smallestAccountId = uint32(accounts.length);
981         p.greatestAccountId = SafeMath.add32(p.smallestAccountId, newCount);
982         p.lockTimeoutBlockNumber = SafeMath.add64(block.number, params.unlockBlocks);
983         p.paymentDataHash = keccak256(abi.encodePacked(payData));
984 
985         // calculate total cost of payment
986         uint64 totalCost = SafeMath.mul64(amount, p.totalNumberOfPayees);
987         totalCost = SafeMath.add64(totalCost, fee);
988 
989         // Check that fromId has enough balance and substract totalCost
990         balanceSub(fromId, totalCost);
991 
992         // If this operation includes new accounts, do a bulkRegister
993         if (newCount > 0) {
994             bulkRegister(newCount, rootHash);
995         }
996 
997         // Save the new Payment
998         payments.push(p);
999 
1000         emit PaymentRegistered(SafeMath.sub32(payments.length, 1), p.fromAccountId, p.totalNumberOfPayees, p.amount);
1001     }
1002 
1003     /**
1004      * @dev provide the required key, releasing the payment and enabling the buyer decryption the digital content.
1005      * @param payIndex payment Index associated with the registerPayment operation.
1006      * @param unlockerAccountId id of the party providing the unlocking service. Fees wil be payed to this id.
1007      * @param key Cryptographic key used to encrypt traded data.
1008      */
1009     function unlock(uint32 payIndex, uint32 unlockerAccountId, bytes memory key) public returns(bool) {
1010         require(payIndex < payments.length, "invalid payIndex, payments is not that long yet");
1011         require(isValidId(unlockerAccountId), "Invalid unlockerAccountId");
1012         require(block.number < payments[payIndex].lockTimeoutBlockNumber, "Hash lock expired");
1013         bytes32 h = keccak256(abi.encodePacked(unlockerAccountId, key));
1014         require(h == payments[payIndex].lockingKeyHash, "Invalid key");
1015 
1016         payments[payIndex].lockingKeyHash = bytes32(0);
1017         balanceAdd(unlockerAccountId, payments[payIndex].fee);
1018 
1019         emit PaymentUnlocked(payIndex, key);
1020         return true;
1021     }
1022 
1023     /**
1024      * @dev Enables the buyer to recover funds associated with a `registerPayment()`
1025      *      operation for which decryption keys were not provided.
1026      * @param payIndex Index of the payment transaction associated with this request.
1027      * @return true if the operation succeded.
1028      */
1029     function refundLockedPayment(uint32 payIndex) external returns (bool) {
1030         require(payIndex < payments.length, "invalid payIndex, payments is not that long yet");
1031         require(payments[payIndex].lockingKeyHash != 0, "payment is already unlocked");
1032         require(block.number >= payments[payIndex].lockTimeoutBlockNumber, "Hash lock has not expired yet");
1033         Payment memory payment = payments[payIndex];
1034         require(payment.totalNumberOfPayees > 0, "payment already refunded");
1035 
1036         uint64 total = SafeMath.add64(
1037             SafeMath.mul64(payment.totalNumberOfPayees, payment.amount),
1038             payment.fee
1039         );
1040 
1041         payment.totalNumberOfPayees = 0;
1042         payment.fee = 0;
1043         payment.amount = 0;
1044         payments[payIndex] = payment;
1045 
1046         // Complete refund
1047         balanceAdd(payment.fromAccountId, total);
1048         emit PaymentRefunded(payment.fromAccountId, total);
1049 
1050         return true;
1051     }
1052 
1053     /**
1054      * @dev let users claim pending balance associated with prior transactions
1055             Users ask a delegate to complete the transaction on their behalf,
1056             the delegate calculates the apropiate amount (declaredAmount) and
1057             waits for a possible challenger.
1058             If this is an instant collect, tokens are transfered immediatly.
1059      * @param delegate id of the delegate account performing the operation on the name of the user.
1060      * @param slotId Individual slot used for the challenge game.
1061      * @param toAccountId Destination of the collect operation.
1062      * @param maxPayIndex payIndex of the first payment index not covered by this application.
1063      * @param declaredAmount amount of tokens owed to this user account
1064      * @param fee fee in tokens to be paid for the end user help.
1065      * @param destination Address to withdraw the full account balance.
1066      * @param signature An R,S,V ECDS signature provided by a user.
1067      */
1068     function collect(
1069         uint32 delegate,
1070         uint32 slotId,
1071         uint32 toAccountId,
1072         uint32 maxPayIndex,
1073         uint64 declaredAmount,
1074         uint64 fee,
1075         address destination,
1076         bytes memory signature
1077     )
1078     public
1079     {
1080         // Check delegate and toAccountId are valid
1081         require(isAccountOwner(delegate), "invalid delegate");
1082         require(isValidId(toAccountId), "toAccountId must be a valid account id");
1083 
1084         // make sure the game slot is empty (release it if necessary)
1085         freeSlot(delegate, slotId);
1086 
1087         Account memory tacc = accounts[toAccountId];
1088         require(tacc.owner != 0, "account registration has to be completed");
1089 
1090         if (delegate != toAccountId) {
1091             // If "toAccountId" != delegate, check who signed this transaction
1092             bytes32 hash =
1093             keccak256(
1094             abi.encodePacked(
1095                 address(this), delegate, toAccountId, tacc.lastCollectedPaymentId,
1096                 maxPayIndex, declaredAmount, fee, destination
1097             ));
1098             require(Challenge.recoverHelper(hash, signature) == tacc.owner, "Bad user signature");
1099         }
1100 
1101         // Check maxPayIndex is valid
1102         require(maxPayIndex > 0 && maxPayIndex <= payments.length,
1103         "invalid maxPayIndex, payments is not that long yet");
1104         require(maxPayIndex > tacc.lastCollectedPaymentId, "account already collected payments up to maxPayIndex");
1105         require(payments[maxPayIndex - 1].lockTimeoutBlockNumber < block.number,
1106             "cannot collect payments that can be unlocked");
1107 
1108         // Check if declaredAmount and fee are valid
1109         require(declaredAmount <= params.maxCollectAmount, "declaredAmount is too big");
1110         require(fee <= declaredAmount, "fee is too big, should be smaller than declaredAmount");
1111 
1112         // Prepare the challenge slot
1113         CollectSlot storage sl = collects[delegate][slotId];
1114         sl.delegate = delegate;
1115         sl.minPayIndex = tacc.lastCollectedPaymentId;
1116         sl.maxPayIndex = maxPayIndex;
1117         sl.amount = declaredAmount;
1118         sl.to = toAccountId;
1119         sl.block = Challenge.getFutureBlock(params.challengeBlocks);
1120         sl.status = 1;
1121 
1122         // Calculate how many tokens needs the delegate, and setup delegateAmount and addr
1123         uint64 needed = params.collectStake;
1124 
1125         // check if this is an instant collect
1126         if (slotId >= INSTANT_SLOT) {
1127             uint64 declaredAmountLessFee = SafeMath.sub64(declaredAmount, fee);
1128             sl.delegateAmount = declaredAmount;
1129             needed = SafeMath.add64(needed, declaredAmountLessFee);
1130             sl.addr = address(0);
1131 
1132             // Instant-collect, toAccount gets the declaredAmount now
1133             balanceAdd(toAccountId, declaredAmountLessFee);
1134         } else
1135         {   // not instant-collect
1136             sl.delegateAmount = fee;
1137             sl.addr = destination;
1138         }
1139 
1140         // Check delegate has enough funds
1141         require(accounts[delegate].balance >= needed, "not enough funds");
1142 
1143         // Update the lastCollectPaymentId for the toAccount
1144         accounts[toAccountId].lastCollectedPaymentId = uint32(maxPayIndex);
1145 
1146         // Now the delegate Pays
1147         balanceSub(delegate, needed);
1148 
1149         // Proceed if the user is withdrawing its balance
1150         if (destination != address(0) && slotId >= INSTANT_SLOT) {
1151             uint64 toWithdraw = accounts[toAccountId].balance;
1152             accounts[toAccountId].balance = 0;
1153             require(token.transfer(destination, toWithdraw), "transfer failed");
1154         }
1155 
1156         emit Collect(delegate, slotId, toAccountId, tacc.lastCollectedPaymentId, maxPayIndex, declaredAmount);
1157     }
1158 
1159     /**
1160      * @dev gets the number of payments issued
1161      * @return returns the size of the payments array.
1162      */
1163     function getPaymentsLength() external view returns (uint) {
1164         return payments.length;
1165     }
1166 
1167     /**
1168      * @dev initiate a challenge game
1169      * @param delegate id of the delegate that performed the collect operation
1170      *        in the name of the end-user.
1171      * @param slot slot used for the challenge game. Every user has a sperate
1172      *        set of slots
1173      * @param challenger id of the user account challenging the delegate.
1174      */
1175     function challenge_1(
1176         uint32 delegate,
1177         uint32 slot,
1178         uint32 challenger
1179     )
1180         public
1181         validId(delegate)
1182         onlyAccountOwner(challenger)
1183     {
1184         Challenge.challenge_1(collects[delegate][slot], params, accounts, challenger);
1185         emit Challenge1(delegate, slot, challenger);
1186     }
1187 
1188     /**
1189      * @dev The delegate provides the list of payments that mentions the enduser
1190      * @param delegate id of the delegate performing the collect operation
1191      * @param slot slot used for the operation
1192      * @param data binary list of payment indexes associated with this collect operation.
1193      */
1194     function challenge_2(
1195         uint32 delegate,
1196         uint32 slot,
1197         bytes memory data
1198     )
1199         public
1200         onlyAccountOwner(delegate)
1201     {
1202         Challenge.challenge_2(collects[delegate][slot], params, data);
1203         emit Challenge2(delegate, slot);
1204     }
1205 
1206     /**
1207      * @dev the Challenger chooses a single index into the delegate provided data list
1208      * @param delegate id of the delegate performing the collect operation
1209      * @param slot slot used for the operation
1210      * @param data binary list of payment indexes associated with this collect operation.
1211      * @param index index into the data array for the payment id selected by the challenger
1212      */
1213     function challenge_3(
1214         uint32 delegate,
1215         uint32 slot,
1216         bytes memory data,
1217         uint32 index
1218     )
1219         public
1220         validId(delegate)
1221     {
1222         require(isAccountOwner(collects[delegate][slot].challenger), "only challenger can call challenge_2");
1223 
1224         Challenge.challenge_3(collects[delegate][slot], params, data, index);
1225         emit Challenge3(delegate, slot, index);
1226     }
1227 
1228     /**
1229      * @dev the delegate provides proof that the destination account was
1230      *      included on that payment, winning the game
1231      * @param delegate id of the delegate performing the collect operation
1232      * @param slot slot used for the operation
1233      */
1234     function challenge_4(
1235         uint32 delegate,
1236         uint32 slot,
1237         bytes memory payData
1238     )
1239         public
1240         onlyAccountOwner(delegate)
1241     {
1242         Challenge.challenge_4(
1243             collects[delegate][slot],
1244             payments,
1245             payData
1246             );
1247         emit Challenge4(delegate, slot);
1248     }
1249 
1250     /**
1251      * @dev the challenge was completed successfully. The delegate stake is slashed.
1252      * @param delegate id of the delegate performing the collect operation
1253      * @param slot slot used for the operation
1254      */
1255     function challenge_success(
1256         uint32 delegate,
1257         uint32 slot
1258     )
1259         public
1260         validId(delegate)
1261     {
1262         Challenge.challenge_success(collects[delegate][slot], params, accounts);
1263         emit ChallengeSuccess(delegate, slot);
1264     }
1265 
1266     /**
1267      * @dev The delegate won the challenge game. He gets the challenge stake.
1268      * @param delegate id of the delegate performing the collect operation
1269      * @param slot slot used for the operation
1270      */
1271     function challenge_failed(
1272         uint32 delegate,
1273         uint32 slot
1274     )
1275         public
1276         onlyAccountOwner(delegate)
1277     {
1278         Challenge.challenge_failed(collects[delegate][slot], params, accounts);
1279         emit ChallengeFailed(delegate, slot);
1280     }
1281 
1282     /**
1283      * @dev Releases a slot used by the collect channel game, only when the game is finished.
1284      *      This does three things:
1285      *        1. Empty the slot
1286      *        2. Pay the delegate
1287      *        3. Pay the destinationAccount
1288      *      Also, if a token.transfer was requested, transfer the outstanding balance to the specified address.
1289      * @param delegate id of the account requesting the release operation
1290      * @param slot id of the slot requested for the duration of the challenge game
1291      */
1292     function freeSlot(uint32 delegate, uint32 slot) public {
1293         CollectSlot memory s = collects[delegate][slot];
1294 
1295         // If this is slot is empty, nothing else to do here.
1296         if (s.status == 0) return;
1297 
1298         // Make sure this slot is ready to be freed.
1299         // It should be in the waiting state(1) and with challenge time ran-out
1300         require(s.status == 1, "slot not available");
1301         require(block.number >= s.block, "slot not available");
1302 
1303         // 1. Put the slot in the empty state
1304         collects[delegate][slot].status = 0;
1305 
1306         // 2. Pay the delegate
1307         // This includes the stake as well as fees and other tokens reserved during collect()
1308         // [delegateAmount + stake] => delegate
1309         balanceAdd(delegate, SafeMath.add64(s.delegateAmount, params.collectStake));
1310 
1311         // 3. Pay the destination account
1312         // [amount - delegateAmount] => to
1313         uint64 balance = SafeMath.sub64(s.amount, s.delegateAmount);
1314 
1315         // was a transfer requested?
1316         if (s.addr != address(0))
1317         {
1318             // empty the account balance
1319             balance = SafeMath.add64(balance, accounts[s.to].balance);
1320             accounts[s.to].balance = 0;
1321             if (balance != 0)
1322                 require(token.transfer(s.addr, balance), "transfer failed");
1323         } else
1324         {
1325             balanceAdd(s.to, balance);
1326         }
1327     }
1328 }
1329 
1330 
1331 /**
1332  * @title BatchPayment processing
1333  * @notice This contract allows to scale ERC-20 token transfer for fees or
1334  *         micropayments on the few-buyers / many-sellers setting.
1335  */
1336 contract BatPay is Payments {
1337 
1338     /**
1339      * @dev Contract constructor, sets ERC20 token this contract will use for payments
1340      * @param token_ ERC20 contract address
1341      * @param maxBulk Maximum number of users to register in a single bulkRegister
1342      * @param maxTransfer Maximum number of destinations on a single payment
1343      * @param challengeBlocks number of blocks to wait for a challenge
1344      * @param challengeStepBlocks number of blocks to wait for a single step on
1345      *        the challenge game
1346      * @param collectStake stake in tokens for a collect operation
1347      * @param challengeStake stake in tokens for the challenger of a collect operation
1348      * @param unlockBlocks number of blocks to wait after registering payment
1349      *        for an unlock operation
1350      * @param maxCollectAmount Maximum amount of tokens to be collected in a
1351      *        single transaction
1352      */
1353     constructor(
1354         IERC20 token_,
1355         uint32 maxBulk,
1356         uint32 maxTransfer,
1357         uint32 challengeBlocks,
1358         uint32 challengeStepBlocks,
1359         uint64 collectStake,
1360         uint64 challengeStake,
1361         uint32 unlockBlocks,
1362         uint64 maxCollectAmount
1363     )
1364         public
1365     {
1366         require(token_ != address(0), "Token address can't be zero");
1367         require(maxBulk > 0, "Parameter maxBulk can't be zero");
1368         require(maxTransfer > 0, "Parameter maxTransfer can't be zero");
1369         require(challengeBlocks > 0, "Parameter challengeBlocks can't be zero");
1370         require(challengeStepBlocks > 0, "Parameter challengeStepBlocks can't be zero");
1371         require(collectStake > 0, "Parameter collectStake can't be zero");
1372         require(challengeStake > 0, "Parameter challengeStake can't be zero");
1373         require(unlockBlocks > 0, "Parameter unlockBlocks can't be zero");
1374         require(maxCollectAmount > 0, "Parameter maxCollectAmount can't be zero");
1375 
1376         owner = msg.sender;
1377         token = IERC20(token_);
1378         params.maxBulk = maxBulk;
1379         params.maxTransfer = maxTransfer;
1380         params.challengeBlocks = challengeBlocks;
1381         params.challengeStepBlocks = challengeStepBlocks;
1382         params.collectStake = collectStake;
1383         params.challengeStake = challengeStake;
1384         params.unlockBlocks = unlockBlocks;
1385         params.maxCollectAmount = maxCollectAmount;
1386     }
1387 }