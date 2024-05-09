1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-06
3 */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Wednesday, April 24, 2019
7  (UTC) */
8 
9 pragma solidity ^0.4.25;
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address who) external view returns (uint256);
15 
16     function allowance(address owner, address spender) external view returns (uint256);
17 
18     function transfer(address to, uint256 value) external returns (bool);
19 
20     function approve(address spender, uint256 value) external returns (bool);
21 
22     function transferFrom(address from, address to, uint256 value) external returns (bool);
23 
24     event Transfer(
25         address indexed from,
26         address indexed to,
27         uint256 value
28     );
29 
30     event Approval(
31         address indexed owner,
32         address indexed spender,
33         uint256 value
34     );
35 }
36 
37 /**
38  * @title math operations that returns specific size reults (32, 64 and 256
39  *        bits)
40  */
41 library SafeMath {
42 
43     /**
44      * @dev Multiplies two numbers and returns a uint64
45      * @param a A number
46      * @param b A number
47      * @return a * b as a uint64
48      */
49     function mul64(uint256 a, uint256 b) internal pure returns (uint64) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b);
55         require(c < 2**64);
56         return uint64(c);
57     }
58 
59     /**
60      * @dev Divides two numbers and returns a uint64
61      * @param a A number
62      * @param b A number
63      * @return a / b as a uint64
64      */
65     function div64(uint256 a, uint256 b) internal pure returns (uint64) {
66         uint256 c = a / b;
67         require(c < 2**64);
68         /* solcov ignore next */
69         return uint64(c);
70     }
71 
72     /**
73      * @dev Substracts two numbers and returns a uint64
74      * @param a A number
75      * @param b A number
76      * @return a - b as a uint64
77      */
78     function sub64(uint256 a, uint256 b) internal pure returns (uint64) {
79         require(b <= a);
80         uint256 c = a - b;
81         require(c < 2**64);
82         /* solcov ignore next */
83         return uint64(c);
84     }
85 
86     /**
87      * @dev Adds two numbers and returns a uint64
88      * @param a A number
89      * @param b A number
90      * @return a + b as a uint64
91      */
92     function add64(uint256 a, uint256 b) internal pure returns (uint64) {
93         uint256 c = a + b;
94         require(c >= a && c < 2**64);
95         /* solcov ignore next */
96         return uint64(c);
97     }
98 
99     /**
100      * @dev Multiplies two numbers and returns a uint32
101      * @param a A number
102      * @param b A number
103      * @return a * b as a uint32
104      */
105     function mul32(uint256 a, uint256 b) internal pure returns (uint32) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b);
111         require(c < 2**32);
112         /* solcov ignore next */
113         return uint32(c);
114     }
115 
116     /**
117      * @dev Divides two numbers and returns a uint32
118      * @param a A number
119      * @param b A number
120      * @return a / b as a uint32
121      */
122     function div32(uint256 a, uint256 b) internal pure returns (uint32) {
123         uint256 c = a / b;
124         require(c < 2**32);
125         /* solcov ignore next */
126         return uint32(c);
127     }
128 
129     /**
130      * @dev Substracts two numbers and returns a uint32
131      * @param a A number
132      * @param b A number
133      * @return a - b as a uint32
134      */
135     function sub32(uint256 a, uint256 b) internal pure returns (uint32) {
136         require(b <= a);
137         uint256 c = a - b;
138         require(c < 2**32);
139         /* solcov ignore next */
140         return uint32(c);
141     }
142 
143     /**
144      * @dev Adds two numbers and returns a uint32
145      * @param a A number
146      * @param b A number
147      * @return a + b as a uint32
148      */
149     function add32(uint256 a, uint256 b) internal pure returns (uint32) {
150         uint256 c = a + b;
151         require(c >= a && c < 2**32);
152         return uint32(c);
153     }
154 
155     /**
156      * @dev Multiplies two numbers and returns a uint256
157      * @param a A number
158      * @param b A number
159      * @return a * b as a uint256
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         if (a == 0) {
163             return 0;
164         }
165         uint256 c = a * b;
166         require(c / a == b);
167         /* solcov ignore next */
168         return c;
169     }
170 
171     /**
172      * @dev Divides two numbers and returns a uint256
173      * @param a A number
174      * @param b A number
175      * @return a / b as a uint256
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         uint256 c = a / b;
179         /* solcov ignore next */
180         return c;
181     }
182 
183     /**
184      * @dev Substracts two numbers and returns a uint256
185      * @param a A number
186      * @param b A number
187      * @return a - b as a uint256
188      */
189     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190         require(b <= a);
191         return a - b;
192     }
193 
194     /**
195      * @dev Adds two numbers and returns a uint256
196      * @param a A number
197      * @param b A number
198      * @return a + b as a uint256
199      */
200     function add(uint256 a, uint256 b) internal pure returns (uint256) {
201         uint256 c = a + b;
202         require(c >= a);
203         return c;
204     }
205 }
206 
207 
208 
209 /**
210  * @title Merkle Tree's proof helper contract
211  */
212 library Merkle {
213 
214     /**
215      * @dev calculates the hash of two child nodes on the merkle tree.
216      * @param a Hash of the left child node.
217      * @param b Hash of the right child node.
218      * @return sha3 hash of the resulting node.
219      */
220     function combinedHash(bytes32 a, bytes32 b) public pure returns(bytes32) {
221         return keccak256(abi.encodePacked(a, b));
222     }
223 
224     /**
225      * @dev calculates a root hash associated with a Merkle proof
226      * @param proof array of proof hashes
227      * @param key index of the leaf element list.
228      *        this key indicates the specific position of the leaf
229      *        in the merkle tree. It will be used to know if the
230      *        node that will be hashed along with the proof node
231      *        is placed on the right or the left of the current
232      *        tree level. That is achieved by doing the modulo of
233      *        the current key/position. A new level of nodes will
234      *        be evaluated after that, and the new left or right
235      *        position is obtained by doing the same operation, 
236      *        after dividing the key/position by two.
237      * @param leaf the leaf element to verify on the set.
238      * @return the hash of the Merkle proof. Should match the Merkle root
239      *         if the proof is valid
240      */
241     function getProofRootHash(bytes32[] memory proof, uint256 key, bytes32 leaf) public pure returns(bytes32) {
242         bytes32 hash = keccak256(abi.encodePacked(leaf));
243         uint256 k = key;
244         for(uint i = 0; i<proof.length; i++) {
245             uint256 bit = k % 2;
246             k = k / 2;
247 
248             if (bit == 0)
249                 hash = combinedHash(hash, proof[i]);
250             else
251                 hash = combinedHash(proof[i], hash);
252         }
253         return hash;
254     }
255 }
256 
257 /**
258  * @title Data Structures for BatPay: Accounts, Payments & Challenge
259  */
260 contract Data {
261     struct Account {
262         address owner;
263         uint64  balance;
264         uint32  lastCollectedPaymentId;
265     }
266 
267     struct BulkRegistration {
268         bytes32 rootHash;
269         uint32  recordCount;
270         uint32  smallestRecordId;
271     }
272 
273     struct Payment {
274         uint32  fromAccountId;
275         uint64  amount;
276         uint64  fee;
277         uint32  smallestAccountId;
278         uint32  greatestAccountId;
279         uint32  totalNumberOfPayees;
280         uint64  lockTimeoutBlockNumber;
281         bytes32 paymentDataHash;
282         bytes32 lockingKeyHash;
283         bytes32 metadata;
284     }
285 
286     struct CollectSlot {
287         uint32  minPayIndex;
288         uint32  maxPayIndex;
289         uint64  amount;
290         uint64  delegateAmount;
291         uint32  to;
292         uint64  block;
293         uint32  delegate;
294         uint32  challenger;
295         uint32  index;
296         uint64  challengeAmount;
297         uint8   status;
298         address addr;
299         bytes32 data;
300     }
301 
302     struct Config {
303         uint32 maxBulk;
304         uint32 maxTransfer;
305         uint32 challengeBlocks;
306         uint32 challengeStepBlocks;
307         uint64 collectStake;
308         uint64 challengeStake;
309         uint32 unlockBlocks;
310         uint32 massExitIdBlocks;
311         uint32 massExitIdStepBlocks;
312         uint32 massExitBalanceBlocks;
313         uint32 massExitBalanceStepBlocks;
314         uint64 massExitStake;
315         uint64 massExitChallengeStake;
316         uint64 maxCollectAmount;
317     }
318 
319     Config public params;
320     address public owner;
321 
322     uint public constant MAX_ACCOUNT_ID = 2**32-1;    // Maximum account id (32-bits)
323     uint public constant NEW_ACCOUNT_FLAG = 2**256-1; // Request registration of new account
324     uint public constant INSTANT_SLOT = 32768;
325 
326 }
327 
328 
329 /**
330   * @title Accounts, methods to manage accounts and balances
331   */
332 
333 contract Accounts is Data {
334     event BulkRegister(uint bulkSize, uint smallestAccountId, uint bulkId );
335     event AccountRegistered(uint accountId, address accountAddress);
336 
337     IERC20 public token;
338     Account[] public accounts;
339     BulkRegistration[] public bulkRegistrations;
340 
341     /**
342       * @dev determines whether accountId is valid
343       * @param accountId an account id
344       * @return boolean
345       */
346     function isValidId(uint accountId) public view returns (bool) {
347         return (accountId < accounts.length);
348     }
349 
350     /**
351       * @dev determines whether accountId is the owner of the account
352       * @param accountId an account id
353       * @return boolean
354       */
355     function isAccountOwner(uint accountId) public view returns (bool) {
356         return isValidId(accountId) && msg.sender == accounts[accountId].owner;
357     }
358 
359     /**
360       * @dev modifier to restrict that accountId is valid
361       * @param accountId an account id
362       */
363     modifier validId(uint accountId) {
364         require(isValidId(accountId), "accountId is not valid");
365         _;
366     }
367 
368     /**
369       * @dev modifier to restrict that accountId is owner
370       * @param accountId an account ID
371       */
372     modifier onlyAccountOwner(uint accountId) {
373         require(isAccountOwner(accountId), "Only account owner can invoke this method");
374         _;
375     }
376 
377     /**
378       * @dev Reserve accounts but delay assigning addresses.
379       *      Accounts will be claimed later using MerkleTree's rootHash.
380       * @param bulkSize Number of accounts to reserve.
381       * @param rootHash Hash of the root node of the Merkle Tree referencing the list of addresses.
382       */
383     function bulkRegister(uint256 bulkSize, bytes32 rootHash) public {
384         require(bulkSize > 0, "Bulk size can't be zero");
385         require(bulkSize < params.maxBulk, "Cannot register this number of ids simultaneously");
386         require(SafeMath.add(accounts.length, bulkSize) <= MAX_ACCOUNT_ID, "Cannot register: ran out of ids");
387         require(rootHash > 0, "Root hash can't be zero");
388 
389         emit BulkRegister(bulkSize, accounts.length, bulkRegistrations.length);
390         bulkRegistrations.push(BulkRegistration(rootHash, uint32(bulkSize), uint32(accounts.length)));
391         accounts.length = SafeMath.add(accounts.length, bulkSize);
392     }
393 
394     /** @dev Complete registration for a reserved account by showing the
395       *     bulkRegistration-id and Merkle proof associated with this address
396       * @param addr Address claiming this account
397       * @param proof Merkle proof for address and id
398       * @param accountId Id of the account to be registered.
399       * @param bulkId BulkRegistration id for the transaction reserving this account
400       */
401     function claimBulkRegistrationId(address addr, bytes32[] memory proof, uint accountId, uint bulkId) public {
402         require(bulkId < bulkRegistrations.length, "the bulkId referenced is invalid");
403         uint smallestAccountId = bulkRegistrations[bulkId].smallestRecordId;
404         uint n = bulkRegistrations[bulkId].recordCount;
405         bytes32 rootHash = bulkRegistrations[bulkId].rootHash;
406         bytes32 hash = Merkle.getProofRootHash(proof, SafeMath.sub(accountId, smallestAccountId), bytes32(addr));
407 
408         require(accountId >= smallestAccountId && accountId < smallestAccountId + n,
409             "the accountId specified is not part of that bulk registration slot");
410         require(hash == rootHash, "invalid Merkle proof");
411         emit AccountRegistered(accountId, addr);
412 
413         accounts[accountId].owner = addr;
414     }
415 
416     /**
417       * @dev Register a new account
418       * @return the id of the new account
419       */
420     function register() public returns (uint32 ret) {
421         require(accounts.length < MAX_ACCOUNT_ID, "no more accounts left");
422         ret = (uint32)(accounts.length);
423         accounts.push(Account(msg.sender, 0, 0));
424         emit AccountRegistered(ret, msg.sender);
425         return ret;
426     }
427 
428     /**
429      * @dev withdraw tokens from the BatchPayment contract into the original address.
430      * @param amount Amount of tokens to withdraw.
431      * @param accountId Id of the user requesting the withdraw.
432      */
433     function withdraw(uint64 amount, uint256 accountId)
434         external
435         onlyAccountOwner(accountId)
436     {
437         uint64 balance = accounts[accountId].balance;
438 
439         require(balance >= amount, "insufficient funds");
440         require(amount > 0, "amount should be nonzero");
441 
442         balanceSub(accountId, amount);
443 
444         require(token.transfer(msg.sender, amount), "transfer failed");
445     }
446 
447     /**
448      * @dev Deposit tokens into the BatchPayment contract to enable scalable payments
449      * @param amount Amount of tokens to deposit on `accountId`. User should have
450      *        enough balance and issue an `approve()` method prior to calling this.
451      * @param accountId The id of the user account. In case `NEW_ACCOUNT_FLAG` is used,
452      *        a new account will be registered and the requested amount will be
453      *        deposited in a single operation.
454      */
455     function deposit(uint64 amount, uint256 accountId) external {
456         require(accountId < accounts.length || accountId == NEW_ACCOUNT_FLAG, "invalid accountId");
457         require(amount > 0, "amount should be positive");
458 
459         if (accountId == NEW_ACCOUNT_FLAG) {
460             // new account
461             uint newId = register();
462             accounts[newId].balance = amount;
463         } else {
464             // existing account
465             balanceAdd(accountId, amount);
466         }
467 
468         require(token.transferFrom(msg.sender, address(this), amount), "transfer failed");
469     }
470 
471     /**
472      * @dev Increase the specified account balance by `amount` tokens.
473      * @param accountId An account id
474      * @param amount number of tokens
475      */
476     function balanceAdd(uint accountId, uint64 amount)
477     internal
478     validId(accountId)
479     {
480         accounts[accountId].balance = SafeMath.add64(accounts[accountId].balance, amount);
481     }
482 
483     /**
484      *  @dev Substract `amount` tokens from the specified account's balance
485      *  @param accountId An account id
486      *  @param amount number of tokens
487      */
488     function balanceSub(uint accountId, uint64 amount)
489     internal
490     validId(accountId)
491     {
492         uint64 balance = accounts[accountId].balance;
493         require(balance >= amount, "not enough funds");
494         accounts[accountId].balance = SafeMath.sub64(balance, amount);
495     }
496 
497     /**
498      *  @dev returns the balance associated with the account in tokens
499      *  @param accountId account requested.
500      */
501     function balanceOf(uint accountId)
502         external
503         view
504         validId(accountId)
505         returns (uint64)
506     {
507         return accounts[accountId].balance;
508     }
509 
510     /**
511       * @dev gets number of accounts registered and reserved.
512       * @return returns the size of the accounts array.
513       */
514     function getAccountsLength() external view returns (uint) {
515         return accounts.length;
516     }
517 
518     /**
519       * @dev gets the number of bulk registrations performed
520       * @return the size of the bulkRegistrations array.
521       */
522     function getBulkLength() external view returns (uint) {
523         return bulkRegistrations.length;
524     }
525 }
526 
527 
528 /**
529  * @title Challenge helper library
530  */
531 library Challenge {
532 
533     uint8 public constant PAY_DATA_HEADER_MARKER = 0xff; // marker in payData header
534 
535     /**
536      * @dev Reverts if challenge period has expired or Collect Slot status is
537      *      not a valid one.
538      */
539     modifier onlyValidCollectSlot(Data.CollectSlot storage collectSlot, uint8 validStatus) {
540         require(!challengeHasExpired(collectSlot), "Challenge has expired");
541         require(isSlotStatusValid(collectSlot, validStatus), "Wrong Collect Slot status");
542         _;
543     }
544 
545     /**
546      * @return true if the current block number is greater or equal than the
547      *         allowed block for this challenge.
548      */
549     function challengeHasExpired(Data.CollectSlot storage collectSlot) public view returns (bool) {
550         return collectSlot.block <= block.number;
551     }
552 
553     /**
554      * @return true if the Slot status is valid.
555      */
556     function isSlotStatusValid(Data.CollectSlot storage collectSlot, uint8 validStatus) public view returns (bool) {
557         return collectSlot.status == validStatus;
558     }
559 
560     /** @dev calculates new block numbers based on the current block and a
561      *      delta constant specified by the protocol policy.
562      * @param delta number of blocks into the future to calculate.
563      * @return future block number.
564      */
565     function getFutureBlock(uint delta) public view returns(uint64) {
566         return SafeMath.add64(block.number, delta);
567     }
568 
569     /**
570      * @dev Inspects the compact payment list provided and calculates the sum
571      *      of the amounts referenced
572      * @param data binary array, with 12 bytes per item. 8-bytes amount,
573      *        4-bytes payment index.
574      * @return the sum of the amounts referenced on the array.
575      */
576     function getDataSum(bytes memory data) public pure returns (uint sum) {
577         require(data.length > 0, "no data provided");
578         require(data.length % 12 == 0, "wrong data format, data length should be multiple of 12");
579 
580         uint n = SafeMath.div(data.length, 12);
581         uint modulus = 2**64;
582 
583         sum = 0;
584 
585         // Get the sum of the stated amounts in data
586         // Each entry in data is [8-bytes amount][4-bytes payIndex]
587 
588         for (uint i = 0; i < n; i++) {
589             // solium-disable-next-line security/no-inline-assembly
590             assembly {
591                 let amount := mod(mload(add(data, add(8, mul(i, 12)))), modulus)
592                 let result := add(sum, amount)
593                 switch or(gt(result, modulus), eq(result, modulus))
594                 case 1 { revert (0, 0) }
595                 default { sum := result }
596             }
597         }
598     }
599 
600     /**
601      * @dev Helper function that obtains the amount/payIndex pair located at
602      *      position `index`.
603      * @param data binary array, with 12 bytes per item. 8-bytes amount,
604      *        4-bytes payment index.
605      * @param index Array item requested.
606      * @return amount and payIndex requested.
607      */
608     function getDataAtIndex(bytes memory data, uint index) public pure returns (uint64 amount, uint32 payIndex) {
609         require(data.length > 0, "no data provided");
610         require(data.length % 12 == 0, "wrong data format, data length should be multiple of 12");
611 
612         uint mod1 = 2**64;
613         uint mod2 = 2**32;
614         uint i = SafeMath.mul(index, 12);
615 
616         require(i <= SafeMath.sub(data.length, 12), "index * 12 must be less or equal than (data.length - 12)");
617 
618         // solium-disable-next-line security/no-inline-assembly
619         assembly {
620             amount := mod( mload(add(data, add(8, i))), mod1 )
621 
622             payIndex := mod( mload(add(data, add(12, i))), mod2 )
623         }
624     }
625 
626     /**
627      * @dev obtains the number of bytes per id in `payData`
628      * @param payData efficient binary representation of a list of accountIds
629      * @return bytes per id in `payData`
630      */
631     function getBytesPerId(bytes payData) internal pure returns (uint) {
632         // payData includes a 2 byte header and a list of ids
633         // [0xff][bytesPerId]
634 
635         uint len = payData.length;
636         require(len >= 2, "payData length should be >= 2");
637         require(uint8(payData[0]) == PAY_DATA_HEADER_MARKER, "payData header missing");
638         uint bytesPerId = uint(payData[1]);
639         require(bytesPerId > 0 && bytesPerId < 32, "second byte of payData should be positive and less than 32");
640 
641         // remaining bytes should be a multiple of bytesPerId
642         require((len - 2) % bytesPerId == 0,
643         "payData length is invalid, all payees must have same amount of bytes (payData[1])");
644 
645         return bytesPerId;
646     }
647 
648     /**
649      * @dev Process payData, inspecting the list of ids, accumulating the amount for
650      *    each entry of `id`.
651      *   `payData` includes 2 header bytes, followed by n bytesPerId-bytes entries.
652      *   `payData` format: [byte 0xff][byte bytesPerId][delta 0][delta 1]..[delta n-1]
653      * @param payData List of payees of a specific Payment, with the above format.
654      * @param id ID to look for in `payData`
655      * @param amount amount per occurrence of `id` in `payData`
656      * @return the amount sum for all occurrences of `id` in `payData`
657      */
658     function getPayDataSum(bytes memory payData, uint id, uint amount) public pure returns (uint sum) {
659         uint bytesPerId = getBytesPerId(payData);
660         uint modulus = 1 << SafeMath.mul(bytesPerId, 8);
661         uint currentId = 0;
662 
663         sum = 0;
664 
665         for (uint i = 2; i < payData.length; i += bytesPerId) {
666             // Get next id delta from paydata
667             // currentId += payData[2+i*bytesPerId]
668 
669             // solium-disable-next-line security/no-inline-assembly
670             assembly {
671                 currentId := add(
672                     currentId,
673                     mod(
674                         mload(add(payData, add(i, bytesPerId))),
675                         modulus))
676 
677                 switch eq(currentId, id)
678                 case 1 { sum := add(sum, amount) }
679             }
680         }
681     }
682 
683     /**
684      * @dev calculates the number of accounts included in payData
685      * @param payData efficient binary representation of a list of accountIds
686      * @return number of accounts present
687      */
688     function getPayDataCount(bytes payData) public pure returns (uint) {
689         uint bytesPerId = getBytesPerId(payData);
690 
691         // calculate number of records
692         return SafeMath.div(payData.length - 2, bytesPerId);
693     }
694 
695     /**
696      * @dev function. Phase I of the challenging game
697      * @param collectSlot Collect slot
698      * @param config Various parameters
699      * @param accounts a reference to the main accounts array
700      * @param challenger id of the challenger user
701      */
702     function challenge_1(
703         Data.CollectSlot storage collectSlot,
704         Data.Config storage config,
705         Data.Account[] storage accounts,
706         uint32 challenger
707     )
708         public
709         onlyValidCollectSlot(collectSlot, 1)
710     {
711         require(accounts[challenger].balance >= config.challengeStake, "not enough balance");
712 
713         collectSlot.status = 2;
714         collectSlot.challenger = challenger;
715         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
716 
717         accounts[challenger].balance -= config.challengeStake;
718     }
719 
720     /**
721      * @dev Internal function. Phase II of the challenging game
722      * @param collectSlot Collect slot
723      * @param config Various parameters
724      * @param data Binary array listing the payments in which the user was referenced.
725      */
726     function challenge_2(
727         Data.CollectSlot storage collectSlot,
728         Data.Config storage config,
729         bytes memory data
730     )
731         public
732         onlyValidCollectSlot(collectSlot, 2)
733     {
734         require(getDataSum(data) == collectSlot.amount, "data doesn't represent collected amount");
735 
736         collectSlot.data = keccak256(data);
737         collectSlot.status = 3;
738         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
739     }
740 
741     /**
742      * @dev Internal function. Phase III of the challenging game
743      * @param collectSlot Collect slot
744      * @param config Various parameters
745      * @param data Binary array listing the payments in which the user was referenced.
746      * @param disputedPaymentIndex index selecting the disputed payment
747      */
748     function challenge_3(
749         Data.CollectSlot storage collectSlot,
750         Data.Config storage config,
751         bytes memory data,
752         uint32 disputedPaymentIndex
753     )
754         public
755         onlyValidCollectSlot(collectSlot, 3)
756     {
757         require(collectSlot.data == keccak256(data),
758         "data mismatch, collected data hash doesn't match provided data hash");
759         (collectSlot.challengeAmount, collectSlot.index) = getDataAtIndex(data, disputedPaymentIndex);
760         collectSlot.status = 4;
761         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
762     }
763 
764     /**
765      * @dev Internal function. Phase IV of the challenging game
766      * @param collectSlot Collect slot
767      * @param payments a reference to the BatPay payments array
768      * @param payData binary data describing the list of account receiving
769      *        tokens on the selected transfer
770      */
771     function challenge_4(
772         Data.CollectSlot storage collectSlot,
773         Data.Payment[] storage payments,
774         bytes memory payData
775     )
776         public
777         onlyValidCollectSlot(collectSlot, 4)
778     {
779         require(collectSlot.index >= collectSlot.minPayIndex && collectSlot.index < collectSlot.maxPayIndex,
780             "payment referenced is out of range");
781         Data.Payment memory p = payments[collectSlot.index];
782         require(keccak256(payData) == p.paymentDataHash,
783         "payData mismatch, payment's data hash doesn't match provided payData hash");
784         require(p.lockingKeyHash == 0, "payment is locked");
785 
786         uint collected = getPayDataSum(payData, collectSlot.to, p.amount);
787 
788         // Check if id is included in bulkRegistration within payment
789         if (collectSlot.to >= p.smallestAccountId && collectSlot.to < p.greatestAccountId) {
790             collected = SafeMath.add(collected, p.amount);
791         }
792 
793         require(collected == collectSlot.challengeAmount,
794         "amount mismatch, provided payData sum doesn't match collected challenge amount");
795 
796         collectSlot.status = 5;
797     }
798 
799     /**
800      * @dev the challenge was completed successfully, or the delegate failed to respond on time.
801      *      The challenger will collect the stake.
802      * @param collectSlot Collect slot
803      * @param config Various parameters
804      * @param accounts a reference to the main accounts array
805      */
806     function challenge_success(
807         Data.CollectSlot storage collectSlot,
808         Data.Config storage config,
809         Data.Account[] storage accounts
810     )
811         public
812     {
813         require((collectSlot.status == 2 || collectSlot.status == 4),
814             "Wrong Collect Slot status");
815         require(challengeHasExpired(collectSlot),
816             "Challenge not yet finished");
817 
818         accounts[collectSlot.challenger].balance = SafeMath.add64(
819             accounts[collectSlot.challenger].balance,
820             SafeMath.add64(config.collectStake, config.challengeStake));
821 
822         collectSlot.status = 0;
823     }
824 
825     /**
826      * @dev Internal function. The delegate proved the challenger wrong, or
827      *      the challenger failed to respond on time. The delegae collects the stake.
828      * @param collectSlot Collect slot
829      * @param config Various parameters
830      * @param accounts a reference to the main accounts array
831      */
832     function challenge_failed(
833         Data.CollectSlot storage collectSlot,
834         Data.Config storage config,
835         Data.Account[] storage accounts
836     )
837         public
838     {
839         require(collectSlot.status == 5 || (collectSlot.status == 3 && block.number >= collectSlot.block),
840             "challenge not completed");
841 
842         // Challenge failed
843         // delegate wins Stake
844         accounts[collectSlot.delegate].balance = SafeMath.add64(
845             accounts[collectSlot.delegate].balance,
846             config.challengeStake);
847 
848         // reset slot to status=1, waiting for challenges
849         collectSlot.challenger = 0;
850         collectSlot.status = 1;
851         collectSlot.block = getFutureBlock(config.challengeBlocks);
852     }
853 
854     /**
855      * @dev Helps verify a ECDSA signature, while recovering the signing address.
856      * @param hash Hash of the signed message
857      * @param sig binary representation of the r, s & v parameters.
858      * @return address of the signer if data provided is valid, zero otherwise.
859      */
860     function recoverHelper(bytes32 hash, bytes sig) public pure returns (address) {
861         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
862         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
863 
864         bytes32 r;
865         bytes32 s;
866         uint8 v;
867 
868         // Check the signature length
869         if (sig.length != 65) {
870             return (address(0));
871         }
872 
873         // Divide the signature in r, s and v variables
874         // ecrecover takes the signature parameters, and the only way to get them
875         // currently is to use assembly.
876         // solium-disable-next-line security/no-inline-assembly
877         assembly {
878             r := mload(add(sig, 32))
879             s := mload(add(sig, 64))
880             v := byte(0, mload(add(sig, 96)))
881         }
882 
883         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
884         if (v < 27) {
885             v += 27;
886         }
887 
888         // If the version is correct return the signer address
889         if (v != 27 && v != 28) {
890             return address(0);
891         }
892 
893         return ecrecover(prefixedHash, v, r, s);
894     }
895 }
896 
897 
898 /**
899  * @title Payments and Challenge game - Performs the operations associated with
900  *        transfer and the different steps of the collect challenge game.
901  */
902 contract Payments is Accounts {
903     event PaymentRegistered(
904         uint32 indexed payIndex,
905         uint indexed from,
906         uint totalNumberOfPayees,
907         uint amount
908     );
909 
910     event PaymentUnlocked(uint32 indexed payIndex, bytes key);
911     event PaymentRefunded(uint32 beneficiaryAccountId, uint64 amountRefunded);
912 
913     /**
914      * Event for collection logging. Off-chain monitoring services may listen
915      * to this event to trigger challenges.
916      */
917     event Collect(
918         uint indexed delegate,
919         uint indexed slot,
920         uint indexed to,
921         uint32 fromPayindex,
922         uint32 toPayIndex,
923         uint amount
924     );
925 
926     event Challenge1(uint indexed delegate, uint indexed slot, uint challenger);
927     event Challenge2(uint indexed delegate, uint indexed slot);
928     event Challenge3(uint indexed delegate, uint indexed slot, uint index);
929     event Challenge4(uint indexed delegate, uint indexed slot);
930     event ChallengeSuccess(uint indexed delegate, uint indexed slot);
931     event ChallengeFailed(uint indexed delegate, uint indexed slot);
932 
933     Payment[] public payments;
934     mapping (uint32 => mapping (uint32 => CollectSlot)) public collects;
935 
936     /**
937      * @dev Register token payment to multiple recipients
938      * @param fromId Account id for the originator of the transaction
939      * @param amount Amount of tokens to pay each destination.
940      * @param fee Fee in tokens to be payed to the party providing the unlocking service
941      * @param payData Efficient representation of the destination account list
942      * @param newCount Number of new destination accounts that will be reserved during the registerPayment transaction
943      * @param rootHash Hash of the root hash of the Merkle tree listing the addresses reserved.
944      * @param lockingKeyHash hash resulting of calculating the keccak256 of
945      *        of the key locking this payment to help in atomic data swaps.
946      *        This hash will later be used by the `unlock` function to unlock the payment we are registering.
947      *         The `lockingKeyHash` must be equal to the keccak256 of the packed
948      *         encoding of the unlockerAccountId and the key used by the unlocker to encrypt the traded data:
949      *             `keccak256(abi.encodePacked(unlockerAccountId, key))`
950      *         DO NOT use previously used locking keys, since an attacker could realize that by comparing key hashes
951      * @param metadata Application specific data to be stored associated with the payment
952      */
953     function registerPayment(
954         uint32 fromId,
955         uint64 amount,
956         uint64 fee,
957         bytes payData,
958         uint newCount,
959         bytes32 rootHash,
960         bytes32 lockingKeyHash,
961         bytes32 metadata
962     )
963         external
964     {
965         require(payments.length < 2**32, "Cannot add more payments");
966         require(isAccountOwner(fromId), "Invalid fromId");
967         require(amount > 0, "Invalid amount");
968         require(newCount == 0 || rootHash > 0, "Invalid root hash"); // although bulkRegister checks this, we anticipate
969         require(fee == 0 || lockingKeyHash > 0, "Invalid lock hash");
970 
971         Payment memory p;
972 
973         // Prepare a Payment struct
974         p.totalNumberOfPayees = SafeMath.add32(Challenge.getPayDataCount(payData), newCount);
975         require(p.totalNumberOfPayees > 0, "Invalid number of payees, should at least be 1 payee");
976         require(p.totalNumberOfPayees < params.maxTransfer,
977         "Too many payees, it should be less than config maxTransfer");
978 
979         p.fromAccountId = fromId;
980         p.amount = amount;
981         p.fee = fee;
982         p.lockingKeyHash = lockingKeyHash;
983         p.metadata = metadata;
984         p.smallestAccountId = uint32(accounts.length);
985         p.greatestAccountId = SafeMath.add32(p.smallestAccountId, newCount);
986         p.lockTimeoutBlockNumber = SafeMath.add64(block.number, params.unlockBlocks);
987         p.paymentDataHash = keccak256(abi.encodePacked(payData));
988 
989         // calculate total cost of payment
990         uint64 totalCost = SafeMath.mul64(amount, p.totalNumberOfPayees);
991         totalCost = SafeMath.add64(totalCost, fee);
992 
993         // Check that fromId has enough balance and substract totalCost
994         balanceSub(fromId, totalCost);
995 
996         // If this operation includes new accounts, do a bulkRegister
997         if (newCount > 0) {
998             bulkRegister(newCount, rootHash);
999         }
1000 
1001         // Save the new Payment
1002         payments.push(p);
1003 
1004         emit PaymentRegistered(SafeMath.sub32(payments.length, 1), p.fromAccountId, p.totalNumberOfPayees, p.amount);
1005     }
1006 
1007     /**
1008      * @dev provide the required key, releasing the payment and enabling the buyer decryption the digital content.
1009      * @param payIndex payment Index associated with the registerPayment operation.
1010      * @param unlockerAccountId id of the party providing the unlocking service. Fees wil be payed to this id.
1011      * @param key Cryptographic key used to encrypt traded data.
1012      */
1013     function unlock(uint32 payIndex, uint32 unlockerAccountId, bytes memory key) public returns(bool) {
1014         require(payIndex < payments.length, "invalid payIndex, payments is not that long yet");
1015         require(isValidId(unlockerAccountId), "Invalid unlockerAccountId");
1016         require(block.number < payments[payIndex].lockTimeoutBlockNumber, "Hash lock expired");
1017         bytes32 h = keccak256(abi.encodePacked(unlockerAccountId, key));
1018         require(h == payments[payIndex].lockingKeyHash, "Invalid key");
1019 
1020         payments[payIndex].lockingKeyHash = bytes32(0);
1021         balanceAdd(unlockerAccountId, payments[payIndex].fee);
1022 
1023         emit PaymentUnlocked(payIndex, key);
1024         return true;
1025     }
1026 
1027     /**
1028      * @dev Enables the buyer to recover funds associated with a `registerPayment()`
1029      *      operation for which decryption keys were not provided.
1030      * @param payIndex Index of the payment transaction associated with this request.
1031      * @return true if the operation succeded.
1032      */
1033     function refundLockedPayment(uint32 payIndex) external returns (bool) {
1034         require(payIndex < payments.length, "invalid payIndex, payments is not that long yet");
1035         require(payments[payIndex].lockingKeyHash != 0, "payment is already unlocked");
1036         require(block.number >= payments[payIndex].lockTimeoutBlockNumber, "Hash lock has not expired yet");
1037         Payment memory payment = payments[payIndex];
1038         require(payment.totalNumberOfPayees > 0, "payment already refunded");
1039 
1040         uint64 total = SafeMath.add64(
1041             SafeMath.mul64(payment.totalNumberOfPayees, payment.amount),
1042             payment.fee
1043         );
1044 
1045         payment.totalNumberOfPayees = 0;
1046         payment.fee = 0;
1047         payment.amount = 0;
1048         payments[payIndex] = payment;
1049 
1050         // Complete refund
1051         balanceAdd(payment.fromAccountId, total);
1052         emit PaymentRefunded(payment.fromAccountId, total);
1053 
1054         return true;
1055     }
1056 
1057     /**
1058      * @dev let users claim pending balance associated with prior transactions
1059             Users ask a delegate to complete the transaction on their behalf,
1060             the delegate calculates the apropiate amount (declaredAmount) and
1061             waits for a possible challenger.
1062             If this is an instant collect, tokens are transfered immediatly.
1063      * @param delegate id of the delegate account performing the operation on the name of the user.
1064      * @param slotId Individual slot used for the challenge game.
1065      * @param toAccountId Destination of the collect operation.
1066      * @param maxPayIndex payIndex of the first payment index not covered by this application.
1067      * @param declaredAmount amount of tokens owed to this user account
1068      * @param fee fee in tokens to be paid for the end user help.
1069      * @param destination Address to withdraw the full account balance.
1070      * @param signature An R,S,V ECDS signature provided by a user.
1071      */
1072     function collect(
1073         uint32 delegate,
1074         uint32 slotId,
1075         uint32 toAccountId,
1076         uint32 maxPayIndex,
1077         uint64 declaredAmount,
1078         uint64 fee,
1079         address destination,
1080         bytes memory signature
1081     )
1082     public
1083     {
1084         // Check delegate and toAccountId are valid
1085         require(isAccountOwner(delegate), "invalid delegate");
1086         require(isValidId(toAccountId), "toAccountId must be a valid account id");
1087 
1088         // make sure the game slot is empty (release it if necessary)
1089         freeSlot(delegate, slotId);
1090 
1091         Account memory tacc = accounts[toAccountId];
1092         require(tacc.owner != 0, "account registration has to be completed");
1093 
1094         if (delegate != toAccountId) {
1095             // If "toAccountId" != delegate, check who signed this transaction
1096             bytes32 hash =
1097             keccak256(
1098             abi.encodePacked(
1099                 address(this), delegate, toAccountId, tacc.lastCollectedPaymentId,
1100                 maxPayIndex, declaredAmount, fee, destination
1101             ));
1102             require(Challenge.recoverHelper(hash, signature) == tacc.owner, "Bad user signature");
1103         }
1104 
1105         // Check maxPayIndex is valid
1106         require(maxPayIndex > 0 && maxPayIndex <= payments.length,
1107         "invalid maxPayIndex, payments is not that long yet");
1108         require(maxPayIndex > tacc.lastCollectedPaymentId, "account already collected payments up to maxPayIndex");
1109         require(payments[maxPayIndex - 1].lockTimeoutBlockNumber < block.number,
1110             "cannot collect payments that can be unlocked");
1111 
1112         // Check if declaredAmount and fee are valid
1113         require(declaredAmount <= params.maxCollectAmount, "declaredAmount is too big");
1114         require(fee <= declaredAmount, "fee is too big, should be smaller than declaredAmount");
1115 
1116         // Prepare the challenge slot
1117         CollectSlot storage sl = collects[delegate][slotId];
1118         sl.delegate = delegate;
1119         sl.minPayIndex = tacc.lastCollectedPaymentId;
1120         sl.maxPayIndex = maxPayIndex;
1121         sl.amount = declaredAmount;
1122         sl.to = toAccountId;
1123         sl.block = Challenge.getFutureBlock(params.challengeBlocks);
1124         sl.status = 1;
1125 
1126         // Calculate how many tokens needs the delegate, and setup delegateAmount and addr
1127         uint64 needed = params.collectStake;
1128 
1129         // check if this is an instant collect
1130         if (slotId >= INSTANT_SLOT) {
1131             uint64 declaredAmountLessFee = SafeMath.sub64(declaredAmount, fee);
1132             sl.delegateAmount = declaredAmount;
1133             needed = SafeMath.add64(needed, declaredAmountLessFee);
1134             sl.addr = address(0);
1135 
1136             // Instant-collect, toAccount gets the declaredAmount now
1137             balanceAdd(toAccountId, declaredAmountLessFee);
1138         } else
1139         {   // not instant-collect
1140             sl.delegateAmount = fee;
1141             sl.addr = destination;
1142         }
1143 
1144         // Check delegate has enough funds
1145         require(accounts[delegate].balance >= needed, "not enough funds");
1146 
1147         // Update the lastCollectPaymentId for the toAccount
1148         accounts[toAccountId].lastCollectedPaymentId = uint32(maxPayIndex);
1149 
1150         // Now the delegate Pays
1151         balanceSub(delegate, needed);
1152 
1153         // Proceed if the user is withdrawing its balance
1154         if (destination != address(0) && slotId >= INSTANT_SLOT) {
1155             uint64 toWithdraw = accounts[toAccountId].balance;
1156             accounts[toAccountId].balance = 0;
1157             require(token.transfer(destination, toWithdraw), "transfer failed");
1158         }
1159 
1160         emit Collect(delegate, slotId, toAccountId, tacc.lastCollectedPaymentId, maxPayIndex, declaredAmount);
1161     }
1162 
1163     /**
1164      * @dev gets the number of payments issued
1165      * @return returns the size of the payments array.
1166      */
1167     function getPaymentsLength() external view returns (uint) {
1168         return payments.length;
1169     }
1170 
1171     /**
1172      * @dev initiate a challenge game
1173      * @param delegate id of the delegate that performed the collect operation
1174      *        in the name of the end-user.
1175      * @param slot slot used for the challenge game. Every user has a sperate
1176      *        set of slots
1177      * @param challenger id of the user account challenging the delegate.
1178      */
1179     function challenge_1(
1180         uint32 delegate,
1181         uint32 slot,
1182         uint32 challenger
1183     )
1184         public
1185         validId(delegate)
1186         onlyAccountOwner(challenger)
1187     {
1188         Challenge.challenge_1(collects[delegate][slot], params, accounts, challenger);
1189         emit Challenge1(delegate, slot, challenger);
1190     }
1191 
1192     /**
1193      * @dev The delegate provides the list of payments that mentions the enduser
1194      * @param delegate id of the delegate performing the collect operation
1195      * @param slot slot used for the operation
1196      * @param data binary list of payment indexes associated with this collect operation.
1197      */
1198     function challenge_2(
1199         uint32 delegate,
1200         uint32 slot,
1201         bytes memory data
1202     )
1203         public
1204         onlyAccountOwner(delegate)
1205     {
1206         Challenge.challenge_2(collects[delegate][slot], params, data);
1207         emit Challenge2(delegate, slot);
1208     }
1209 
1210     /**
1211      * @dev the Challenger chooses a single index into the delegate provided data list
1212      * @param delegate id of the delegate performing the collect operation
1213      * @param slot slot used for the operation
1214      * @param data binary list of payment indexes associated with this collect operation.
1215      * @param index index into the data array for the payment id selected by the challenger
1216      */
1217     function challenge_3(
1218         uint32 delegate,
1219         uint32 slot,
1220         bytes memory data,
1221         uint32 index
1222     )
1223         public
1224         validId(delegate)
1225     {
1226         require(isAccountOwner(collects[delegate][slot].challenger), "only challenger can call challenge_2");
1227 
1228         Challenge.challenge_3(collects[delegate][slot], params, data, index);
1229         emit Challenge3(delegate, slot, index);
1230     }
1231 
1232     /**
1233      * @dev the delegate provides proof that the destination account was
1234      *      included on that payment, winning the game
1235      * @param delegate id of the delegate performing the collect operation
1236      * @param slot slot used for the operation
1237      */
1238     function challenge_4(
1239         uint32 delegate,
1240         uint32 slot,
1241         bytes memory payData
1242     )
1243         public
1244         onlyAccountOwner(delegate)
1245     {
1246         Challenge.challenge_4(
1247             collects[delegate][slot],
1248             payments,
1249             payData
1250             );
1251         emit Challenge4(delegate, slot);
1252     }
1253 
1254     /**
1255      * @dev the challenge was completed successfully. The delegate stake is slashed.
1256      * @param delegate id of the delegate performing the collect operation
1257      * @param slot slot used for the operation
1258      */
1259     function challenge_success(
1260         uint32 delegate,
1261         uint32 slot
1262     )
1263         public
1264         validId(delegate)
1265     {
1266         Challenge.challenge_success(collects[delegate][slot], params, accounts);
1267         emit ChallengeSuccess(delegate, slot);
1268     }
1269 
1270     /**
1271      * @dev The delegate won the challenge game. He gets the challenge stake.
1272      * @param delegate id of the delegate performing the collect operation
1273      * @param slot slot used for the operation
1274      */
1275     function challenge_failed(
1276         uint32 delegate,
1277         uint32 slot
1278     )
1279         public
1280         onlyAccountOwner(delegate)
1281     {
1282         Challenge.challenge_failed(collects[delegate][slot], params, accounts);
1283         emit ChallengeFailed(delegate, slot);
1284     }
1285 
1286     /**
1287      * @dev Releases a slot used by the collect channel game, only when the game is finished.
1288      *      This does three things:
1289      *        1. Empty the slot
1290      *        2. Pay the delegate
1291      *        3. Pay the destinationAccount
1292      *      Also, if a token.transfer was requested, transfer the outstanding balance to the specified address.
1293      * @param delegate id of the account requesting the release operation
1294      * @param slot id of the slot requested for the duration of the challenge game
1295      */
1296     function freeSlot(uint32 delegate, uint32 slot) public {
1297         CollectSlot memory s = collects[delegate][slot];
1298 
1299         // If this is slot is empty, nothing else to do here.
1300         if (s.status == 0) return;
1301 
1302         // Make sure this slot is ready to be freed.
1303         // It should be in the waiting state(1) and with challenge time ran-out
1304         require(s.status == 1, "slot not available");
1305         require(block.number >= s.block, "slot not available");
1306 
1307         // 1. Put the slot in the empty state
1308         collects[delegate][slot].status = 0;
1309 
1310         // 2. Pay the delegate
1311         // This includes the stake as well as fees and other tokens reserved during collect()
1312         // [delegateAmount + stake] => delegate
1313         balanceAdd(delegate, SafeMath.add64(s.delegateAmount, params.collectStake));
1314 
1315         // 3. Pay the destination account
1316         // [amount - delegateAmount] => to
1317         uint64 balance = SafeMath.sub64(s.amount, s.delegateAmount);
1318 
1319         // was a transfer requested?
1320         if (s.addr != address(0))
1321         {
1322             // empty the account balance
1323             balance = SafeMath.add64(balance, accounts[s.to].balance);
1324             accounts[s.to].balance = 0;
1325             if (balance != 0)
1326                 require(token.transfer(s.addr, balance), "transfer failed");
1327         } else
1328         {
1329             balanceAdd(s.to, balance);
1330         }
1331     }
1332 }
1333 
1334 
1335 /**
1336  * @title BatchPayment processing
1337  * @notice This contract allows to scale ERC-20 token transfer for fees or
1338  *         micropayments on the few-buyers / many-sellers setting.
1339  */
1340 contract BatPay is Payments {
1341 
1342     /**
1343      * @dev Contract constructor, sets ERC20 token this contract will use for payments
1344      * @param token_ ERC20 contract address
1345      * @param maxBulk Maximum number of users to register in a single bulkRegister
1346      * @param maxTransfer Maximum number of destinations on a single payment
1347      * @param challengeBlocks number of blocks to wait for a challenge
1348      * @param challengeStepBlocks number of blocks to wait for a single step on
1349      *        the challenge game
1350      * @param collectStake stake in tokens for a collect operation
1351      * @param challengeStake stake in tokens for the challenger of a collect operation
1352      * @param unlockBlocks number of blocks to wait after registering payment
1353      *        for an unlock operation
1354      * @param maxCollectAmount Maximum amount of tokens to be collected in a
1355      *        single transaction
1356      */
1357     constructor(
1358         IERC20 token_,
1359         uint32 maxBulk,
1360         uint32 maxTransfer,
1361         uint32 challengeBlocks,
1362         uint32 challengeStepBlocks,
1363         uint64 collectStake,
1364         uint64 challengeStake,
1365         uint32 unlockBlocks,
1366         uint64 maxCollectAmount
1367     )
1368         public
1369     {
1370         require(token_ != address(0), "Token address can't be zero");
1371         require(maxBulk > 0, "Parameter maxBulk can't be zero");
1372         require(maxTransfer > 0, "Parameter maxTransfer can't be zero");
1373         require(challengeBlocks > 0, "Parameter challengeBlocks can't be zero");
1374         require(challengeStepBlocks > 0, "Parameter challengeStepBlocks can't be zero");
1375         require(collectStake > 0, "Parameter collectStake can't be zero");
1376         require(challengeStake > 0, "Parameter challengeStake can't be zero");
1377         require(unlockBlocks > 0, "Parameter unlockBlocks can't be zero");
1378         require(maxCollectAmount > 0, "Parameter maxCollectAmount can't be zero");
1379 
1380         owner = msg.sender;
1381         token = IERC20(token_);
1382         params.maxBulk = maxBulk;
1383         params.maxTransfer = maxTransfer;
1384         params.challengeBlocks = challengeBlocks;
1385         params.challengeStepBlocks = challengeStepBlocks;
1386         params.collectStake = collectStake;
1387         params.challengeStake = challengeStake;
1388         params.unlockBlocks = unlockBlocks;
1389         params.maxCollectAmount = maxCollectAmount;
1390     }
1391 }