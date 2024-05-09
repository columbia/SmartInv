1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-06-06
7 */
8 
9 /**
10  * Source Code first verified at https://etherscan.io on Wednesday, April 24, 2019
11  (UTC) */
12 
13 pragma solidity ^0.4.25;
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     function transfer(address to, uint256 value) external returns (bool);
23 
24     function approve(address spender, uint256 value) external returns (bool);
25 
26     function transferFrom(address from, address to, uint256 value) external returns (bool);
27 
28     event Transfer(
29         address indexed from,
30         address indexed to,
31         uint256 value
32     );
33 
34     event Approval(
35         address indexed owner,
36         address indexed spender,
37         uint256 value
38     );
39 }
40 
41 /**
42  * @title math operations that returns specific size reults (32, 64 and 256
43  *        bits)
44  */
45 library SafeMath {
46 
47     /**
48      * @dev Multiplies two numbers and returns a uint64
49      * @param a A number
50      * @param b A number
51      * @return a * b as a uint64
52      */
53     function mul64(uint256 a, uint256 b) internal pure returns (uint64) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         require(c / a == b);
59         require(c < 2**64);
60         return uint64(c);
61     }
62 
63     /**
64      * @dev Divides two numbers and returns a uint64
65      * @param a A number
66      * @param b A number
67      * @return a / b as a uint64
68      */
69     function div64(uint256 a, uint256 b) internal pure returns (uint64) {
70         uint256 c = a / b;
71         require(c < 2**64);
72         /* solcov ignore next */
73         return uint64(c);
74     }
75 
76     /**
77      * @dev Substracts two numbers and returns a uint64
78      * @param a A number
79      * @param b A number
80      * @return a - b as a uint64
81      */
82     function sub64(uint256 a, uint256 b) internal pure returns (uint64) {
83         require(b <= a);
84         uint256 c = a - b;
85         require(c < 2**64);
86         /* solcov ignore next */
87         return uint64(c);
88     }
89 
90     /**
91      * @dev Adds two numbers and returns a uint64
92      * @param a A number
93      * @param b A number
94      * @return a + b as a uint64
95      */
96     function add64(uint256 a, uint256 b) internal pure returns (uint64) {
97         uint256 c = a + b;
98         require(c >= a && c < 2**64);
99         /* solcov ignore next */
100         return uint64(c);
101     }
102 
103     /**
104      * @dev Multiplies two numbers and returns a uint32
105      * @param a A number
106      * @param b A number
107      * @return a * b as a uint32
108      */
109     function mul32(uint256 a, uint256 b) internal pure returns (uint32) {
110         if (a == 0) {
111             return 0;
112         }
113         uint256 c = a * b;
114         require(c / a == b);
115         require(c < 2**32);
116         /* solcov ignore next */
117         return uint32(c);
118     }
119 
120     /**
121      * @dev Divides two numbers and returns a uint32
122      * @param a A number
123      * @param b A number
124      * @return a / b as a uint32
125      */
126     function div32(uint256 a, uint256 b) internal pure returns (uint32) {
127         uint256 c = a / b;
128         require(c < 2**32);
129         /* solcov ignore next */
130         return uint32(c);
131     }
132 
133     /**
134      * @dev Substracts two numbers and returns a uint32
135      * @param a A number
136      * @param b A number
137      * @return a - b as a uint32
138      */
139     function sub32(uint256 a, uint256 b) internal pure returns (uint32) {
140         require(b <= a);
141         uint256 c = a - b;
142         require(c < 2**32);
143         /* solcov ignore next */
144         return uint32(c);
145     }
146 
147     /**
148      * @dev Adds two numbers and returns a uint32
149      * @param a A number
150      * @param b A number
151      * @return a + b as a uint32
152      */
153     function add32(uint256 a, uint256 b) internal pure returns (uint32) {
154         uint256 c = a + b;
155         require(c >= a && c < 2**32);
156         return uint32(c);
157     }
158 
159     /**
160      * @dev Multiplies two numbers and returns a uint256
161      * @param a A number
162      * @param b A number
163      * @return a * b as a uint256
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         if (a == 0) {
167             return 0;
168         }
169         uint256 c = a * b;
170         require(c / a == b);
171         /* solcov ignore next */
172         return c;
173     }
174 
175     /**
176      * @dev Divides two numbers and returns a uint256
177      * @param a A number
178      * @param b A number
179      * @return a / b as a uint256
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         uint256 c = a / b;
183         /* solcov ignore next */
184         return c;
185     }
186 
187     /**
188      * @dev Substracts two numbers and returns a uint256
189      * @param a A number
190      * @param b A number
191      * @return a - b as a uint256
192      */
193     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194         require(b <= a);
195         return a - b;
196     }
197 
198     /**
199      * @dev Adds two numbers and returns a uint256
200      * @param a A number
201      * @param b A number
202      * @return a + b as a uint256
203      */
204     function add(uint256 a, uint256 b) internal pure returns (uint256) {
205         uint256 c = a + b;
206         require(c >= a);
207         return c;
208     }
209 }
210 
211 
212 
213 /**
214  * @title Merkle Tree's proof helper contract
215  */
216 library Merkle {
217 
218     /**
219      * @dev calculates the hash of two child nodes on the merkle tree.
220      * @param a Hash of the left child node.
221      * @param b Hash of the right child node.
222      * @return sha3 hash of the resulting node.
223      */
224     function combinedHash(bytes32 a, bytes32 b) public pure returns(bytes32) {
225         return keccak256(abi.encodePacked(a, b));
226     }
227 
228     /**
229      * @dev calculates a root hash associated with a Merkle proof
230      * @param proof array of proof hashes
231      * @param key index of the leaf element list.
232      *        this key indicates the specific position of the leaf
233      *        in the merkle tree. It will be used to know if the
234      *        node that will be hashed along with the proof node
235      *        is placed on the right or the left of the current
236      *        tree level. That is achieved by doing the modulo of
237      *        the current key/position. A new level of nodes will
238      *        be evaluated after that, and the new left or right
239      *        position is obtained by doing the same operation, 
240      *        after dividing the key/position by two.
241      * @param leaf the leaf element to verify on the set.
242      * @return the hash of the Merkle proof. Should match the Merkle root
243      *         if the proof is valid
244      */
245     function getProofRootHash(bytes32[] memory proof, uint256 key, bytes32 leaf) public pure returns(bytes32) {
246         bytes32 hash = keccak256(abi.encodePacked(leaf));
247         uint256 k = key;
248         for(uint i = 0; i<proof.length; i++) {
249             uint256 bit = k % 2;
250             k = k / 2;
251 
252             if (bit == 0)
253                 hash = combinedHash(hash, proof[i]);
254             else
255                 hash = combinedHash(proof[i], hash);
256         }
257         return hash;
258     }
259 }
260 
261 /**
262  * @title Data Structures for BatPay: Accounts, Payments & Challenge
263  */
264 contract Data {
265     struct Account {
266         address owner;
267         uint64  balance;
268         uint32  lastCollectedPaymentId;
269     }
270 
271     struct BulkRegistration {
272         bytes32 rootHash;
273         uint32  recordCount;
274         uint32  smallestRecordId;
275     }
276 
277     struct Payment {
278         uint32  fromAccountId;
279         uint64  amount;
280         uint64  fee;
281         uint32  smallestAccountId;
282         uint32  greatestAccountId;
283         uint32  totalNumberOfPayees;
284         uint64  lockTimeoutBlockNumber;
285         bytes32 paymentDataHash;
286         bytes32 lockingKeyHash;
287         bytes32 metadata;
288     }
289 
290     struct CollectSlot {
291         uint32  minPayIndex;
292         uint32  maxPayIndex;
293         uint64  amount;
294         uint64  delegateAmount;
295         uint32  to;
296         uint64  block;
297         uint32  delegate;
298         uint32  challenger;
299         uint32  index;
300         uint64  challengeAmount;
301         uint8   status;
302         address addr;
303         bytes32 data;
304     }
305 
306     struct Config {
307         uint32 maxBulk;
308         uint32 maxTransfer;
309         uint32 challengeBlocks;
310         uint32 challengeStepBlocks;
311         uint64 collectStake;
312         uint64 challengeStake;
313         uint32 unlockBlocks;
314         uint32 massExitIdBlocks;
315         uint32 massExitIdStepBlocks;
316         uint32 massExitBalanceBlocks;
317         uint32 massExitBalanceStepBlocks;
318         uint64 massExitStake;
319         uint64 massExitChallengeStake;
320         uint64 maxCollectAmount;
321     }
322 
323     Config public params;
324     address public owner;
325 
326     uint public constant MAX_ACCOUNT_ID = 2**32-1;    // Maximum account id (32-bits)
327     uint public constant NEW_ACCOUNT_FLAG = 2**256-1; // Request registration of new account
328     uint public constant INSTANT_SLOT = 32768;
329 
330 }
331 
332 
333 /**
334   * @title Accounts, methods to manage accounts and balances
335   */
336 
337 contract Accounts is Data {
338     event BulkRegister(uint bulkSize, uint smallestAccountId, uint bulkId );
339     event AccountRegistered(uint accountId, address accountAddress);
340 
341     IERC20 public token;
342     Account[] public accounts;
343     BulkRegistration[] public bulkRegistrations;
344 
345     /**
346       * @dev determines whether accountId is valid
347       * @param accountId an account id
348       * @return boolean
349       */
350     function isValidId(uint accountId) public view returns (bool) {
351         return (accountId < accounts.length);
352     }
353 
354     /**
355       * @dev determines whether accountId is the owner of the account
356       * @param accountId an account id
357       * @return boolean
358       */
359     function isAccountOwner(uint accountId) public view returns (bool) {
360         return isValidId(accountId) && msg.sender == accounts[accountId].owner;
361     }
362 
363     /**
364       * @dev modifier to restrict that accountId is valid
365       * @param accountId an account id
366       */
367     modifier validId(uint accountId) {
368         require(isValidId(accountId), "accountId is not valid");
369         _;
370     }
371 
372     /**
373       * @dev modifier to restrict that accountId is owner
374       * @param accountId an account ID
375       */
376     modifier onlyAccountOwner(uint accountId) {
377         require(isAccountOwner(accountId), "Only account owner can invoke this method");
378         _;
379     }
380 
381     /**
382       * @dev Reserve accounts but delay assigning addresses.
383       *      Accounts will be claimed later using MerkleTree's rootHash.
384       * @param bulkSize Number of accounts to reserve.
385       * @param rootHash Hash of the root node of the Merkle Tree referencing the list of addresses.
386       */
387     function bulkRegister(uint256 bulkSize, bytes32 rootHash) public {
388         require(bulkSize > 0, "Bulk size can't be zero");
389         require(bulkSize < params.maxBulk, "Cannot register this number of ids simultaneously");
390         require(SafeMath.add(accounts.length, bulkSize) <= MAX_ACCOUNT_ID, "Cannot register: ran out of ids");
391         require(rootHash > 0, "Root hash can't be zero");
392 
393         emit BulkRegister(bulkSize, accounts.length, bulkRegistrations.length);
394         bulkRegistrations.push(BulkRegistration(rootHash, uint32(bulkSize), uint32(accounts.length)));
395         accounts.length = SafeMath.add(accounts.length, bulkSize);
396     }
397 
398     /** @dev Complete registration for a reserved account by showing the
399       *     bulkRegistration-id and Merkle proof associated with this address
400       * @param addr Address claiming this account
401       * @param proof Merkle proof for address and id
402       * @param accountId Id of the account to be registered.
403       * @param bulkId BulkRegistration id for the transaction reserving this account
404       */
405     function claimBulkRegistrationId(address addr, bytes32[] memory proof, uint accountId, uint bulkId) public {
406         require(bulkId < bulkRegistrations.length, "the bulkId referenced is invalid");
407         uint smallestAccountId = bulkRegistrations[bulkId].smallestRecordId;
408         uint n = bulkRegistrations[bulkId].recordCount;
409         bytes32 rootHash = bulkRegistrations[bulkId].rootHash;
410         bytes32 hash = Merkle.getProofRootHash(proof, SafeMath.sub(accountId, smallestAccountId), bytes32(addr));
411 
412         require(accountId >= smallestAccountId && accountId < smallestAccountId + n,
413             "the accountId specified is not part of that bulk registration slot");
414         require(hash == rootHash, "invalid Merkle proof");
415         emit AccountRegistered(accountId, addr);
416 
417         accounts[accountId].owner = addr;
418     }
419 
420     /**
421       * @dev Register a new account
422       * @return the id of the new account
423       */
424     function register() public returns (uint32 ret) {
425         require(accounts.length < MAX_ACCOUNT_ID, "no more accounts left");
426         ret = (uint32)(accounts.length);
427         accounts.push(Account(msg.sender, 0, 0));
428         emit AccountRegistered(ret, msg.sender);
429         return ret;
430     }
431 
432     /**
433      * @dev withdraw tokens from the BatchPayment contract into the original address.
434      * @param amount Amount of tokens to withdraw.
435      * @param accountId Id of the user requesting the withdraw.
436      */
437     function withdraw(uint64 amount, uint256 accountId)
438         external
439         onlyAccountOwner(accountId)
440     {
441         uint64 balance = accounts[accountId].balance;
442 
443         require(balance >= amount, "insufficient funds");
444         require(amount > 0, "amount should be nonzero");
445 
446         balanceSub(accountId, amount);
447 
448         require(token.transfer(msg.sender, amount), "transfer failed");
449     }
450 
451     /**
452      * @dev Deposit tokens into the BatchPayment contract to enable scalable payments
453      * @param amount Amount of tokens to deposit on `accountId`. User should have
454      *        enough balance and issue an `approve()` method prior to calling this.
455      * @param accountId The id of the user account. In case `NEW_ACCOUNT_FLAG` is used,
456      *        a new account will be registered and the requested amount will be
457      *        deposited in a single operation.
458      */
459     function deposit(uint64 amount, uint256 accountId) external {
460         require(accountId < accounts.length || accountId == NEW_ACCOUNT_FLAG, "invalid accountId");
461         require(amount > 0, "amount should be positive");
462 
463         if (accountId == NEW_ACCOUNT_FLAG) {
464             // new account
465             uint newId = register();
466             accounts[newId].balance = amount;
467         } else {
468             // existing account
469             balanceAdd(accountId, amount);
470         }
471 
472         require(token.transferFrom(msg.sender, address(this), amount), "transfer failed");
473     }
474 
475     /**
476      * @dev Increase the specified account balance by `amount` tokens.
477      * @param accountId An account id
478      * @param amount number of tokens
479      */
480     function balanceAdd(uint accountId, uint64 amount)
481     internal
482     validId(accountId)
483     {
484         accounts[accountId].balance = SafeMath.add64(accounts[accountId].balance, amount);
485     }
486 
487     /**
488      *  @dev Substract `amount` tokens from the specified account's balance
489      *  @param accountId An account id
490      *  @param amount number of tokens
491      */
492     function balanceSub(uint accountId, uint64 amount)
493     internal
494     validId(accountId)
495     {
496         uint64 balance = accounts[accountId].balance;
497         require(balance >= amount, "not enough funds");
498         accounts[accountId].balance = SafeMath.sub64(balance, amount);
499     }
500 
501     /**
502      *  @dev returns the balance associated with the account in tokens
503      *  @param accountId account requested.
504      */
505     function balanceOf(uint accountId)
506         external
507         view
508         validId(accountId)
509         returns (uint64)
510     {
511         return accounts[accountId].balance;
512     }
513 
514     /**
515       * @dev gets number of accounts registered and reserved.
516       * @return returns the size of the accounts array.
517       */
518     function getAccountsLength() external view returns (uint) {
519         return accounts.length;
520     }
521 
522     /**
523       * @dev gets the number of bulk registrations performed
524       * @return the size of the bulkRegistrations array.
525       */
526     function getBulkLength() external view returns (uint) {
527         return bulkRegistrations.length;
528     }
529 }
530 
531 
532 /**
533  * @title Challenge helper library
534  */
535 library Challenge {
536 
537     uint8 public constant PAY_DATA_HEADER_MARKER = 0xff; // marker in payData header
538 
539     /**
540      * @dev Reverts if challenge period has expired or Collect Slot status is
541      *      not a valid one.
542      */
543     modifier onlyValidCollectSlot(Data.CollectSlot storage collectSlot, uint8 validStatus) {
544         require(!challengeHasExpired(collectSlot), "Challenge has expired");
545         require(isSlotStatusValid(collectSlot, validStatus), "Wrong Collect Slot status");
546         _;
547     }
548 
549     /**
550      * @return true if the current block number is greater or equal than the
551      *         allowed block for this challenge.
552      */
553     function challengeHasExpired(Data.CollectSlot storage collectSlot) public view returns (bool) {
554         return collectSlot.block <= block.number;
555     }
556 
557     /**
558      * @return true if the Slot status is valid.
559      */
560     function isSlotStatusValid(Data.CollectSlot storage collectSlot, uint8 validStatus) public view returns (bool) {
561         return collectSlot.status == validStatus;
562     }
563 
564     /** @dev calculates new block numbers based on the current block and a
565      *      delta constant specified by the protocol policy.
566      * @param delta number of blocks into the future to calculate.
567      * @return future block number.
568      */
569     function getFutureBlock(uint delta) public view returns(uint64) {
570         return SafeMath.add64(block.number, delta);
571     }
572 
573     /**
574      * @dev Inspects the compact payment list provided and calculates the sum
575      *      of the amounts referenced
576      * @param data binary array, with 12 bytes per item. 8-bytes amount,
577      *        4-bytes payment index.
578      * @return the sum of the amounts referenced on the array.
579      */
580     function getDataSum(bytes memory data) public pure returns (uint sum) {
581         require(data.length > 0, "no data provided");
582         require(data.length % 12 == 0, "wrong data format, data length should be multiple of 12");
583 
584         uint n = SafeMath.div(data.length, 12);
585         uint maxSafeAmount = 2**64;
586         uint maxSafePayIndex = 2**32;
587         int previousPayIndex = -1;
588         int currentPayIndex = 0;
589 
590         // Get the sum of the stated amounts in data
591         // Each entry in data is [8-bytes amount][4-bytes payIndex]
592         sum = 0;
593         for (uint i = 0; i < n; i++) {
594             // solium-disable-next-line security/no-inline-assembly
595             assembly {
596               sum := add(sum, mod(mload(add(data, add(8, mul(i, 12)))), maxSafeAmount))
597               currentPayIndex := mod(mload(add(data, mul(add(i, 1), 12))), maxSafePayIndex)
598             }
599             require(sum < maxSafeAmount, "max cashout exceeded");
600             require(previousPayIndex < currentPayIndex, "wrong data format, data should be ordered by payIndex");
601             previousPayIndex = currentPayIndex;
602         }
603     }
604 
605     /**
606      * @dev Helper function that obtains the amount/payIndex pair located at
607      *      position `index`.
608      * @param data binary array, with 12 bytes per item. 8-bytes amount,
609      *        4-bytes payment index.
610      * @param index Array item requested.
611      * @return amount and payIndex requested.
612      */
613     function getDataAtIndex(bytes memory data, uint index) public pure returns (uint64 amount, uint32 payIndex) {
614         require(data.length > 0, "no data provided");
615         require(data.length % 12 == 0, "wrong data format, data length should be multiple of 12");
616 
617         uint mod1 = 2**64;
618         uint mod2 = 2**32;
619         uint i = SafeMath.mul(index, 12);
620 
621         require(i <= SafeMath.sub(data.length, 12), "index * 12 must be less or equal than (data.length - 12)");
622 
623         // solium-disable-next-line security/no-inline-assembly
624         assembly {
625             amount := mod( mload(add(data, add(8, i))), mod1 )
626 
627             payIndex := mod( mload(add(data, add(12, i))), mod2 )
628         }
629     }
630 
631     /**
632      * @dev obtains the number of bytes per id in `payData`
633      * @param payData efficient binary representation of a list of accountIds
634      * @return bytes per id in `payData`
635      */
636     function getBytesPerId(bytes payData) internal pure returns (uint) {
637         // payData includes a 2 byte header and a list of ids
638         // [0xff][bytesPerId]
639 
640         uint len = payData.length;
641         require(len >= 2, "payData length should be >= 2");
642         require(uint8(payData[0]) == PAY_DATA_HEADER_MARKER, "payData header missing");
643         uint bytesPerId = uint(payData[1]);
644         require(bytesPerId > 0 && bytesPerId < 32, "second byte of payData should be positive and less than 32");
645 
646         // remaining bytes should be a multiple of bytesPerId
647         require((len - 2) % bytesPerId == 0,
648         "payData length is invalid, all payees must have same amount of bytes (payData[1])");
649 
650         return bytesPerId;
651     }
652 
653     /**
654      * @dev Process payData, inspecting the list of ids, accumulating the amount for
655      *    each entry of `id`.
656      *   `payData` includes 2 header bytes, followed by n bytesPerId-bytes entries.
657      *   `payData` format: [byte 0xff][byte bytesPerId][delta 0][delta 1]..[delta n-1]
658      * @param payData List of payees of a specific Payment, with the above format.
659      * @param id ID to look for in `payData`
660      * @param amount amount per occurrence of `id` in `payData`
661      * @return the amount sum for all occurrences of `id` in `payData`
662      */
663     function getPayDataSum(bytes memory payData, uint id, uint amount) public pure returns (uint sum) {
664         uint bytesPerId = getBytesPerId(payData);
665         uint modulus = 1 << SafeMath.mul(bytesPerId, 8);
666         uint currentId = 0;
667 
668         sum = 0;
669 
670         for (uint i = 2; i < payData.length; i += bytesPerId) {
671             // Get next id delta from paydata
672             // currentId += payData[2+i*bytesPerId]
673 
674             // solium-disable-next-line security/no-inline-assembly
675             assembly {
676                 currentId := add(
677                     currentId,
678                     mod(
679                         mload(add(payData, add(i, bytesPerId))),
680                         modulus))
681 
682                 switch eq(currentId, id)
683                 case 1 { sum := add(sum, amount) }
684             }
685         }
686     }
687 
688     /**
689      * @dev calculates the number of accounts included in payData
690      * @param payData efficient binary representation of a list of accountIds
691      * @return number of accounts present
692      */
693     function getPayDataCount(bytes payData) public pure returns (uint) {
694         uint bytesPerId = getBytesPerId(payData);
695 
696         // calculate number of records
697         return SafeMath.div(payData.length - 2, bytesPerId);
698     }
699 
700     /**
701      * @dev function. Phase I of the challenging game
702      * @param collectSlot Collect slot
703      * @param config Various parameters
704      * @param accounts a reference to the main accounts array
705      * @param challenger id of the challenger user
706      */
707     function challenge_1(
708         Data.CollectSlot storage collectSlot,
709         Data.Config storage config,
710         Data.Account[] storage accounts,
711         uint32 challenger
712     )
713         public
714         onlyValidCollectSlot(collectSlot, 1)
715     {
716         require(accounts[challenger].balance >= config.challengeStake, "not enough balance");
717 
718         collectSlot.status = 2;
719         collectSlot.challenger = challenger;
720         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
721 
722         accounts[challenger].balance -= config.challengeStake;
723     }
724 
725     /**
726      * @dev Internal function. Phase II of the challenging game
727      * @param collectSlot Collect slot
728      * @param config Various parameters
729      * @param data Binary array listing the payments in which the user was referenced.
730      */
731     function challenge_2(
732         Data.CollectSlot storage collectSlot,
733         Data.Config storage config,
734         bytes memory data
735     )
736         public
737         onlyValidCollectSlot(collectSlot, 2)
738     {
739         require(getDataSum(data) == collectSlot.amount, "data doesn't represent collected amount");
740 
741         collectSlot.data = keccak256(data);
742         collectSlot.status = 3;
743         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
744     }
745 
746     /**
747      * @dev Internal function. Phase III of the challenging game
748      * @param collectSlot Collect slot
749      * @param config Various parameters
750      * @param data Binary array listing the payments in which the user was referenced.
751      * @param disputedPaymentIndex index selecting the disputed payment
752      */
753     function challenge_3(
754         Data.CollectSlot storage collectSlot,
755         Data.Config storage config,
756         bytes memory data,
757         uint32 disputedPaymentIndex
758     )
759         public
760         onlyValidCollectSlot(collectSlot, 3)
761     {
762         require(collectSlot.data == keccak256(data),
763         "data mismatch, collected data hash doesn't match provided data hash");
764         (collectSlot.challengeAmount, collectSlot.index) = getDataAtIndex(data, disputedPaymentIndex);
765         collectSlot.status = 4;
766         collectSlot.block = getFutureBlock(config.challengeStepBlocks);
767     }
768 
769     /**
770      * @dev Internal function. Phase IV of the challenging game
771      * @param collectSlot Collect slot
772      * @param payments a reference to the BatPay payments array
773      * @param payData binary data describing the list of account receiving
774      *        tokens on the selected transfer
775      */
776     function challenge_4(
777         Data.CollectSlot storage collectSlot,
778         Data.Payment[] storage payments,
779         bytes memory payData
780     )
781         public
782         onlyValidCollectSlot(collectSlot, 4)
783     {
784         require(collectSlot.index >= collectSlot.minPayIndex && collectSlot.index < collectSlot.maxPayIndex,
785             "payment referenced is out of range");
786         Data.Payment memory p = payments[collectSlot.index];
787         require(keccak256(payData) == p.paymentDataHash,
788         "payData mismatch, payment's data hash doesn't match provided payData hash");
789         require(p.lockingKeyHash == 0, "payment is locked");
790 
791         uint collected = getPayDataSum(payData, collectSlot.to, p.amount);
792 
793         // Check if id is included in bulkRegistration within payment
794         if (collectSlot.to >= p.smallestAccountId && collectSlot.to < p.greatestAccountId) {
795             collected = SafeMath.add(collected, p.amount);
796         }
797 
798         require(collected == collectSlot.challengeAmount,
799         "amount mismatch, provided payData sum doesn't match collected challenge amount");
800 
801         collectSlot.status = 5;
802     }
803 
804     /**
805      * @dev the challenge was completed successfully, or the delegate failed to respond on time.
806      *      The challenger will collect the stake.
807      * @param collectSlot Collect slot
808      * @param config Various parameters
809      * @param accounts a reference to the main accounts array
810      */
811     function challenge_success(
812         Data.CollectSlot storage collectSlot,
813         Data.Config storage config,
814         Data.Account[] storage accounts
815     )
816         public
817     {
818         require((collectSlot.status == 2 || collectSlot.status == 4),
819             "Wrong Collect Slot status");
820         require(challengeHasExpired(collectSlot),
821             "Challenge not yet finished");
822 
823         accounts[collectSlot.challenger].balance = SafeMath.add64(
824             accounts[collectSlot.challenger].balance,
825             SafeMath.add64(config.collectStake, config.challengeStake));
826 
827         collectSlot.status = 0;
828     }
829 
830     /**
831      * @dev Internal function. The delegate proved the challenger wrong, or
832      *      the challenger failed to respond on time. The delegae collects the stake.
833      * @param collectSlot Collect slot
834      * @param config Various parameters
835      * @param accounts a reference to the main accounts array
836      */
837     function challenge_failed(
838         Data.CollectSlot storage collectSlot,
839         Data.Config storage config,
840         Data.Account[] storage accounts
841     )
842         public
843     {
844         require(collectSlot.status == 5 || (collectSlot.status == 3 && block.number >= collectSlot.block),
845             "challenge not completed");
846 
847         // Challenge failed
848         // delegate wins Stake
849         accounts[collectSlot.delegate].balance = SafeMath.add64(
850             accounts[collectSlot.delegate].balance,
851             config.challengeStake);
852 
853         // reset slot to status=1, waiting for challenges
854         collectSlot.challenger = 0;
855         collectSlot.status = 1;
856         collectSlot.block = getFutureBlock(config.challengeBlocks);
857     }
858 
859     /**
860      * @dev Helps verify a ECDSA signature, while recovering the signing address.
861      * @param hash Hash of the signed message
862      * @param sig binary representation of the r, s & v parameters.
863      * @return address of the signer if data provided is valid, zero otherwise.
864      */
865     function recoverHelper(bytes32 hash, bytes sig) public pure returns (address) {
866         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
867         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
868 
869         bytes32 r;
870         bytes32 s;
871         uint8 v;
872 
873         // Check the signature length
874         if (sig.length != 65) {
875             return (address(0));
876         }
877 
878         // Divide the signature in r, s and v variables
879         // ecrecover takes the signature parameters, and the only way to get them
880         // currently is to use assembly.
881         // solium-disable-next-line security/no-inline-assembly
882         assembly {
883             r := mload(add(sig, 32))
884             s := mload(add(sig, 64))
885             v := byte(0, mload(add(sig, 96)))
886         }
887 
888         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
889         if (v < 27) {
890             v += 27;
891         }
892 
893         // If the version is correct return the signer address
894         if (v != 27 && v != 28) {
895             return address(0);
896         }
897 
898         return ecrecover(prefixedHash, v, r, s);
899     }
900 }
901 
902 
903 /**
904  * @title Payments and Challenge game - Performs the operations associated with
905  *        transfer and the different steps of the collect challenge game.
906  */
907 contract Payments is Accounts {
908     event PaymentRegistered(
909         uint32 indexed payIndex,
910         uint indexed from,
911         uint totalNumberOfPayees,
912         uint amount
913     );
914 
915     event PaymentUnlocked(uint32 indexed payIndex, bytes key);
916     event PaymentRefunded(uint32 beneficiaryAccountId, uint64 amountRefunded);
917 
918     /**
919      * Event for collection logging. Off-chain monitoring services may listen
920      * to this event to trigger challenges.
921      */
922     event Collect(
923         uint indexed delegate,
924         uint indexed slot,
925         uint indexed to,
926         uint32 fromPayindex,
927         uint32 toPayIndex,
928         uint amount
929     );
930 
931     event Challenge1(uint indexed delegate, uint indexed slot, uint challenger);
932     event Challenge2(uint indexed delegate, uint indexed slot);
933     event Challenge3(uint indexed delegate, uint indexed slot, uint index);
934     event Challenge4(uint indexed delegate, uint indexed slot);
935     event ChallengeSuccess(uint indexed delegate, uint indexed slot);
936     event ChallengeFailed(uint indexed delegate, uint indexed slot);
937 
938     Payment[] public payments;
939     mapping (uint32 => mapping (uint32 => CollectSlot)) public collects;
940 
941     /**
942      * @dev Register token payment to multiple recipients
943      * @param fromId Account id for the originator of the transaction
944      * @param amount Amount of tokens to pay each destination.
945      * @param fee Fee in tokens to be payed to the party providing the unlocking service
946      * @param payData Efficient representation of the destination account list
947      * @param newCount Number of new destination accounts that will be reserved during the registerPayment transaction
948      * @param rootHash Hash of the root hash of the Merkle tree listing the addresses reserved.
949      * @param lockingKeyHash hash resulting of calculating the keccak256 of
950      *        of the key locking this payment to help in atomic data swaps.
951      *        This hash will later be used by the `unlock` function to unlock the payment we are registering.
952      *         The `lockingKeyHash` must be equal to the keccak256 of the packed
953      *         encoding of the unlockerAccountId and the key used by the unlocker to encrypt the traded data:
954      *             `keccak256(abi.encodePacked(unlockerAccountId, key))`
955      *         DO NOT use previously used locking keys, since an attacker could realize that by comparing key hashes
956      * @param metadata Application specific data to be stored associated with the payment
957      */
958     function registerPayment(
959         uint32 fromId,
960         uint64 amount,
961         uint64 fee,
962         bytes payData,
963         uint newCount,
964         bytes32 rootHash,
965         bytes32 lockingKeyHash,
966         bytes32 metadata
967     )
968         external
969     {
970         require(payments.length < 2**32, "Cannot add more payments");
971         require(isAccountOwner(fromId), "Invalid fromId");
972         require(amount > 0, "Invalid amount");
973         require(newCount == 0 || rootHash > 0, "Invalid root hash"); // although bulkRegister checks this, we anticipate
974         require(fee == 0 || lockingKeyHash > 0, "Invalid lock hash");
975 
976         Payment memory p;
977 
978         // Prepare a Payment struct
979         p.totalNumberOfPayees = SafeMath.add32(Challenge.getPayDataCount(payData), newCount);
980         require(p.totalNumberOfPayees > 0, "Invalid number of payees, should at least be 1 payee");
981         require(p.totalNumberOfPayees < params.maxTransfer,
982         "Too many payees, it should be less than config maxTransfer");
983 
984         p.fromAccountId = fromId;
985         p.amount = amount;
986         p.fee = fee;
987         p.lockingKeyHash = lockingKeyHash;
988         p.metadata = metadata;
989         p.smallestAccountId = uint32(accounts.length);
990         p.greatestAccountId = SafeMath.add32(p.smallestAccountId, newCount);
991         p.lockTimeoutBlockNumber = SafeMath.add64(block.number, params.unlockBlocks);
992         p.paymentDataHash = keccak256(abi.encodePacked(payData));
993 
994         // calculate total cost of payment
995         uint64 totalCost = SafeMath.mul64(amount, p.totalNumberOfPayees);
996         totalCost = SafeMath.add64(totalCost, fee);
997 
998         // Check that fromId has enough balance and substract totalCost
999         balanceSub(fromId, totalCost);
1000 
1001         // If this operation includes new accounts, do a bulkRegister
1002         if (newCount > 0) {
1003             bulkRegister(newCount, rootHash);
1004         }
1005 
1006         // Save the new Payment
1007         payments.push(p);
1008 
1009         emit PaymentRegistered(SafeMath.sub32(payments.length, 1), p.fromAccountId, p.totalNumberOfPayees, p.amount);
1010     }
1011 
1012     /**
1013      * @dev provide the required key, releasing the payment and enabling the buyer decryption the digital content.
1014      * @param payIndex payment Index associated with the registerPayment operation.
1015      * @param unlockerAccountId id of the party providing the unlocking service. Fees wil be payed to this id.
1016      * @param key Cryptographic key used to encrypt traded data.
1017      */
1018     function unlock(uint32 payIndex, uint32 unlockerAccountId, bytes memory key) public returns(bool) {
1019         require(payIndex < payments.length, "invalid payIndex, payments is not that long yet");
1020         require(isValidId(unlockerAccountId), "Invalid unlockerAccountId");
1021         require(block.number < payments[payIndex].lockTimeoutBlockNumber, "Hash lock expired");
1022         bytes32 h = keccak256(abi.encodePacked(unlockerAccountId, key));
1023         require(h == payments[payIndex].lockingKeyHash, "Invalid key");
1024 
1025         payments[payIndex].lockingKeyHash = bytes32(0);
1026         balanceAdd(unlockerAccountId, payments[payIndex].fee);
1027 
1028         emit PaymentUnlocked(payIndex, key);
1029         return true;
1030     }
1031 
1032     /**
1033      * @dev Enables the buyer to recover funds associated with a `registerPayment()`
1034      *      operation for which decryption keys were not provided.
1035      * @param payIndex Index of the payment transaction associated with this request.
1036      * @return true if the operation succeded.
1037      */
1038     function refundLockedPayment(uint32 payIndex) external returns (bool) {
1039         require(payIndex < payments.length, "invalid payIndex, payments is not that long yet");
1040         require(payments[payIndex].lockingKeyHash != 0, "payment is already unlocked");
1041         require(block.number >= payments[payIndex].lockTimeoutBlockNumber, "Hash lock has not expired yet");
1042         Payment memory payment = payments[payIndex];
1043         require(payment.totalNumberOfPayees > 0, "payment already refunded");
1044 
1045         uint64 total = SafeMath.add64(
1046             SafeMath.mul64(payment.totalNumberOfPayees, payment.amount),
1047             payment.fee
1048         );
1049 
1050         payment.totalNumberOfPayees = 0;
1051         payment.fee = 0;
1052         payment.amount = 0;
1053         payments[payIndex] = payment;
1054 
1055         // Complete refund
1056         balanceAdd(payment.fromAccountId, total);
1057         emit PaymentRefunded(payment.fromAccountId, total);
1058 
1059         return true;
1060     }
1061 
1062     /**
1063      * @dev let users claim pending balance associated with prior transactions
1064             Users ask a delegate to complete the transaction on their behalf,
1065             the delegate calculates the apropiate amount (declaredAmount) and
1066             waits for a possible challenger.
1067             If this is an instant collect, tokens are transfered immediatly.
1068      * @param delegate id of the delegate account performing the operation on the name of the user.
1069      * @param slotId Individual slot used for the challenge game.
1070      * @param toAccountId Destination of the collect operation.
1071      * @param maxPayIndex payIndex of the first payment index not covered by this application.
1072      * @param declaredAmount amount of tokens owed to this user account
1073      * @param fee fee in tokens to be paid for the end user help.
1074      * @param destination Address to withdraw the full account balance.
1075      * @param signature An R,S,V ECDS signature provided by a user.
1076      */
1077     function collect(
1078         uint32 delegate,
1079         uint32 slotId,
1080         uint32 toAccountId,
1081         uint32 maxPayIndex,
1082         uint64 declaredAmount,
1083         uint64 fee,
1084         address destination,
1085         bytes memory signature
1086     )
1087     public
1088     {
1089         // Check delegate and toAccountId are valid
1090         require(isAccountOwner(delegate), "invalid delegate");
1091         require(isValidId(toAccountId), "toAccountId must be a valid account id");
1092 
1093         // make sure the game slot is empty (release it if necessary)
1094         freeSlot(delegate, slotId);
1095 
1096         Account memory tacc = accounts[toAccountId];
1097         require(tacc.owner != 0, "account registration has to be completed");
1098 
1099         if (delegate != toAccountId) {
1100             // If "toAccountId" != delegate, check who signed this transaction
1101             bytes32 hash =
1102             keccak256(
1103             abi.encodePacked(
1104                 address(this), delegate, toAccountId, tacc.lastCollectedPaymentId,
1105                 maxPayIndex, declaredAmount, fee, destination
1106             ));
1107             require(Challenge.recoverHelper(hash, signature) == tacc.owner, "Bad user signature");
1108         }
1109 
1110         // Check maxPayIndex is valid
1111         require(maxPayIndex > 0 && maxPayIndex <= payments.length,
1112         "invalid maxPayIndex, payments is not that long yet");
1113         require(maxPayIndex > tacc.lastCollectedPaymentId, "account already collected payments up to maxPayIndex");
1114         require(payments[maxPayIndex - 1].lockTimeoutBlockNumber < block.number,
1115             "cannot collect payments that can be unlocked");
1116 
1117         // Check if declaredAmount and fee are valid
1118         require(declaredAmount <= params.maxCollectAmount, "declaredAmount is too big");
1119         require(fee <= declaredAmount, "fee is too big, should be smaller than declaredAmount");
1120 
1121         // Prepare the challenge slot
1122         CollectSlot storage sl = collects[delegate][slotId];
1123         sl.delegate = delegate;
1124         sl.minPayIndex = tacc.lastCollectedPaymentId;
1125         sl.maxPayIndex = maxPayIndex;
1126         sl.amount = declaredAmount;
1127         sl.to = toAccountId;
1128         sl.block = Challenge.getFutureBlock(params.challengeBlocks);
1129         sl.status = 1;
1130 
1131         // Calculate how many tokens needs the delegate, and setup delegateAmount and addr
1132         uint64 needed = params.collectStake;
1133 
1134         // check if this is an instant collect
1135         if (slotId >= INSTANT_SLOT) {
1136             uint64 declaredAmountLessFee = SafeMath.sub64(declaredAmount, fee);
1137             sl.delegateAmount = declaredAmount;
1138             needed = SafeMath.add64(needed, declaredAmountLessFee);
1139             sl.addr = address(0);
1140 
1141             // Instant-collect, toAccount gets the declaredAmount now
1142             balanceAdd(toAccountId, declaredAmountLessFee);
1143         } else
1144         {   // not instant-collect
1145             sl.delegateAmount = fee;
1146             sl.addr = destination;
1147         }
1148 
1149         // Check delegate has enough funds
1150         require(accounts[delegate].balance >= needed, "not enough funds");
1151 
1152         // Update the lastCollectPaymentId for the toAccount
1153         accounts[toAccountId].lastCollectedPaymentId = uint32(maxPayIndex);
1154 
1155         // Now the delegate Pays
1156         balanceSub(delegate, needed);
1157 
1158         // Proceed if the user is withdrawing its balance
1159         if (destination != address(0) && slotId >= INSTANT_SLOT) {
1160             uint64 toWithdraw = accounts[toAccountId].balance;
1161             accounts[toAccountId].balance = 0;
1162             require(token.transfer(destination, toWithdraw), "transfer failed");
1163         }
1164 
1165         emit Collect(delegate, slotId, toAccountId, tacc.lastCollectedPaymentId, maxPayIndex, declaredAmount);
1166     }
1167 
1168     /**
1169      * @dev gets the number of payments issued
1170      * @return returns the size of the payments array.
1171      */
1172     function getPaymentsLength() external view returns (uint) {
1173         return payments.length;
1174     }
1175 
1176     /**
1177      * @dev initiate a challenge game
1178      * @param delegate id of the delegate that performed the collect operation
1179      *        in the name of the end-user.
1180      * @param slot slot used for the challenge game. Every user has a sperate
1181      *        set of slots
1182      * @param challenger id of the user account challenging the delegate.
1183      */
1184     function challenge_1(
1185         uint32 delegate,
1186         uint32 slot,
1187         uint32 challenger
1188     )
1189         public
1190         validId(delegate)
1191         onlyAccountOwner(challenger)
1192     {
1193         Challenge.challenge_1(collects[delegate][slot], params, accounts, challenger);
1194         emit Challenge1(delegate, slot, challenger);
1195     }
1196 
1197     /**
1198      * @dev The delegate provides the list of payments that mentions the enduser
1199      * @param delegate id of the delegate performing the collect operation
1200      * @param slot slot used for the operation
1201      * @param data binary list of payment indexes associated with this collect operation.
1202      */
1203     function challenge_2(
1204         uint32 delegate,
1205         uint32 slot,
1206         bytes memory data
1207     )
1208         public
1209         onlyAccountOwner(delegate)
1210     {
1211         Challenge.challenge_2(collects[delegate][slot], params, data);
1212         emit Challenge2(delegate, slot);
1213     }
1214 
1215     /**
1216      * @dev the Challenger chooses a single index into the delegate provided data list
1217      * @param delegate id of the delegate performing the collect operation
1218      * @param slot slot used for the operation
1219      * @param data binary list of payment indexes associated with this collect operation.
1220      * @param index index into the data array for the payment id selected by the challenger
1221      */
1222     function challenge_3(
1223         uint32 delegate,
1224         uint32 slot,
1225         bytes memory data,
1226         uint32 index
1227     )
1228         public
1229         validId(delegate)
1230     {
1231         require(isAccountOwner(collects[delegate][slot].challenger), "only challenger can call challenge_2");
1232 
1233         Challenge.challenge_3(collects[delegate][slot], params, data, index);
1234         emit Challenge3(delegate, slot, index);
1235     }
1236 
1237     /**
1238      * @dev the delegate provides proof that the destination account was
1239      *      included on that payment, winning the game
1240      * @param delegate id of the delegate performing the collect operation
1241      * @param slot slot used for the operation
1242      */
1243     function challenge_4(
1244         uint32 delegate,
1245         uint32 slot,
1246         bytes memory payData
1247     )
1248         public
1249         onlyAccountOwner(delegate)
1250     {
1251         Challenge.challenge_4(
1252             collects[delegate][slot],
1253             payments,
1254             payData
1255             );
1256         emit Challenge4(delegate, slot);
1257     }
1258 
1259     /**
1260      * @dev the challenge was completed successfully. The delegate stake is slashed.
1261      * @param delegate id of the delegate performing the collect operation
1262      * @param slot slot used for the operation
1263      */
1264     function challenge_success(
1265         uint32 delegate,
1266         uint32 slot
1267     )
1268         public
1269         validId(delegate)
1270     {
1271         Challenge.challenge_success(collects[delegate][slot], params, accounts);
1272         emit ChallengeSuccess(delegate, slot);
1273     }
1274 
1275     /**
1276      * @dev The delegate won the challenge game. He gets the challenge stake.
1277      * @param delegate id of the delegate performing the collect operation
1278      * @param slot slot used for the operation
1279      */
1280     function challenge_failed(
1281         uint32 delegate,
1282         uint32 slot
1283     )
1284         public
1285         onlyAccountOwner(delegate)
1286     {
1287         Challenge.challenge_failed(collects[delegate][slot], params, accounts);
1288         emit ChallengeFailed(delegate, slot);
1289     }
1290 
1291     /**
1292      * @dev Releases a slot used by the collect channel game, only when the game is finished.
1293      *      This does three things:
1294      *        1. Empty the slot
1295      *        2. Pay the delegate
1296      *        3. Pay the destinationAccount
1297      *      Also, if a token.transfer was requested, transfer the outstanding balance to the specified address.
1298      * @param delegate id of the account requesting the release operation
1299      * @param slot id of the slot requested for the duration of the challenge game
1300      */
1301     function freeSlot(uint32 delegate, uint32 slot) public {
1302         CollectSlot memory s = collects[delegate][slot];
1303 
1304         // If this is slot is empty, nothing else to do here.
1305         if (s.status == 0) return;
1306 
1307         // Make sure this slot is ready to be freed.
1308         // It should be in the waiting state(1) and with challenge time ran-out
1309         require(s.status == 1, "slot not available");
1310         require(block.number >= s.block, "slot not available");
1311 
1312         // 1. Put the slot in the empty state
1313         collects[delegate][slot].status = 0;
1314 
1315         // 2. Pay the delegate
1316         // This includes the stake as well as fees and other tokens reserved during collect()
1317         // [delegateAmount + stake] => delegate
1318         balanceAdd(delegate, SafeMath.add64(s.delegateAmount, params.collectStake));
1319 
1320         // 3. Pay the destination account
1321         // [amount - delegateAmount] => to
1322         uint64 balance = SafeMath.sub64(s.amount, s.delegateAmount);
1323 
1324         // was a transfer requested?
1325         if (s.addr != address(0))
1326         {
1327             // empty the account balance
1328             balance = SafeMath.add64(balance, accounts[s.to].balance);
1329             accounts[s.to].balance = 0;
1330             if (balance != 0)
1331                 require(token.transfer(s.addr, balance), "transfer failed");
1332         } else
1333         {
1334             balanceAdd(s.to, balance);
1335         }
1336     }
1337 }
1338 
1339 
1340 /**
1341  * @title BatchPayment processing
1342  * @notice This contract allows to scale ERC-20 token transfer for fees or
1343  *         micropayments on the few-buyers / many-sellers setting.
1344  */
1345 contract BatPay is Payments {
1346 
1347     /**
1348      * @dev Contract constructor, sets ERC20 token this contract will use for payments
1349      * @param token_ ERC20 contract address
1350      * @param maxBulk Maximum number of users to register in a single bulkRegister
1351      * @param maxTransfer Maximum number of destinations on a single payment
1352      * @param challengeBlocks number of blocks to wait for a challenge
1353      * @param challengeStepBlocks number of blocks to wait for a single step on
1354      *        the challenge game
1355      * @param collectStake stake in tokens for a collect operation
1356      * @param challengeStake stake in tokens for the challenger of a collect operation
1357      * @param unlockBlocks number of blocks to wait after registering payment
1358      *        for an unlock operation
1359      * @param maxCollectAmount Maximum amount of tokens to be collected in a
1360      *        single transaction
1361      */
1362     constructor(
1363         IERC20 token_,
1364         uint32 maxBulk,
1365         uint32 maxTransfer,
1366         uint32 challengeBlocks,
1367         uint32 challengeStepBlocks,
1368         uint64 collectStake,
1369         uint64 challengeStake,
1370         uint32 unlockBlocks,
1371         uint64 maxCollectAmount
1372     )
1373         public
1374     {
1375         require(token_ != address(0), "Token address can't be zero");
1376         require(maxBulk > 0, "Parameter maxBulk can't be zero");
1377         require(maxTransfer > 0, "Parameter maxTransfer can't be zero");
1378         require(challengeBlocks > 0, "Parameter challengeBlocks can't be zero");
1379         require(challengeStepBlocks > 0, "Parameter challengeStepBlocks can't be zero");
1380         require(collectStake > 0, "Parameter collectStake can't be zero");
1381         require(challengeStake > 0, "Parameter challengeStake can't be zero");
1382         require(unlockBlocks > 0, "Parameter unlockBlocks can't be zero");
1383         require(maxCollectAmount > 0, "Parameter maxCollectAmount can't be zero");
1384 
1385         owner = msg.sender;
1386         token = IERC20(token_);
1387         params.maxBulk = maxBulk;
1388         params.maxTransfer = maxTransfer;
1389         params.challengeBlocks = challengeBlocks;
1390         params.challengeStepBlocks = challengeStepBlocks;
1391         params.collectStake = collectStake;
1392         params.challengeStake = challengeStake;
1393         params.unlockBlocks = unlockBlocks;
1394         params.maxCollectAmount = maxCollectAmount;
1395     }
1396 }