1 pragma solidity 0.5.3;
2 
3 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/external/Token.sol
4 
5 /*
6   Abstract contract for the full ERC 20 Token standard
7   https://github.com/ethereum/EIPs/issues/20
8 */
9 contract Token {
10   /* This is a slight change to the ERC20 base standard.
11   function totalSupply() view returns (uint supply);
12   is replaced map:
13   uint public totalSupply;
14   This automatically creates a getter function for the totalSupply.
15   This is moved to the base contract since public getter functions are not
16   currently recognised as an implementation of the matching abstract
17   function by the compiler.
18   */
19   /// total amount of tokens
20   uint public totalSupply;
21 
22   /// @param _owner The address from which the balance will be retrieved
23   /// @return The balance
24   function balanceOf(address _owner) public view returns (uint balance);
25 
26   /// @notice send `_value` token to `_to` from `msg.sender`
27   /// @param _to The address of the recipient
28   /// @param _value The amount of token to be transferred
29   /// @return Whether the transfer was successful or not
30   function transfer(address _to, uint _value) public returns (bool success);
31 
32   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
33   /// @param _from The address of the sender
34   /// @param _to The address of the recipient
35   /// @param _value The amount of token to be transferred
36   /// @return Whether the transfer was successful or not
37   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
38 
39   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
40   /// @param _spender The address of the account able to transfer the tokens
41   /// @param _value The amount of tokens to be approved for transfer
42   /// @return Whether the approval was successful or not
43   function approve(address _spender, uint _value) public returns (bool success);
44 
45   /// @param _owner The address of the account owning tokens
46   /// @param _spender The address of the account able to transfer the tokens
47   /// @return Amount of remaining tokens allowed to spent
48   function allowance(address _owner, address _spender) public view returns (uint remaining);
49 
50   event Transfer(address indexed _from, address indexed _to, uint _value);
51   event Approval(address indexed _owner, address indexed _spender, uint _value);
52 }
53 
54 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/external/MerkleProof.sol
55 
56 // note: can use a deployed https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/MerkleProof.sol
57 contract MerkleProof {
58 
59   /*
60    * Verifies the inclusion of a leaf in a Merkle tree using a Merkle proof.
61    *
62    * Based on https://github.com/ameensol/merkle-tree-solidity/src/MerkleProof.sol
63    */
64   function checkProof(bytes memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
65     if (proof.length % 32 != 0) return false; // Check if proof is made of bytes32 slices
66 
67     bytes memory elements = proof;
68     bytes32 element;
69     bytes32 hash = leaf;
70     for (uint i = 32; i <= proof.length; i += 32) {
71       assembly {
72       // Load the current element of the proofOfInclusion (optimal way to get a bytes32 slice)
73         element := mload(add(elements, i))
74       }
75       hash = keccak256(abi.encodePacked(hash < element ? abi.encodePacked(hash, element) : abi.encodePacked(element, hash)));
76     }
77     return hash == root;
78   }
79 
80   // from StorJ -- https://github.com/nginnever/storj-audit-verifier/contracts/MerkleVerifyv3.sol
81   function checkProofOrdered(bytes memory proof, bytes32 root, bytes32 leaf, uint index) public pure returns (bool) {
82     if (proof.length % 32 != 0) return false; // Check if proof is made of bytes32 slices
83 
84     // use the index to determine the node ordering (index ranges 1 to n)
85     bytes32 element;
86     bytes32 hash = leaf;
87     uint remaining;
88     for (uint j = 32; j <= proof.length; j += 32) {
89       assembly {
90         element := mload(add(proof, j))
91       }
92 
93       // calculate remaining elements in proof
94       remaining = (proof.length - j + 32) / 32;
95 
96       // we don't assume that the tree is padded to a power of 2
97       // if the index is odd then the proof will start with a hash at a higher layer,
98       // so we have to adjust the index to be the index at that layer
99       while (remaining > 0 && index % 2 == 1 && index > 2 ** remaining) {
100         index = uint(index) / 2 + 1;
101       }
102 
103       if (index % 2 == 0) {
104         hash = keccak256(abi.encodePacked(abi.encodePacked(element, hash)));
105         index = index / 2;
106       } else {
107         hash = keccak256(abi.encodePacked(abi.encodePacked(hash, element)));
108         index = uint(index) / 2 + 1;
109       }
110     }
111     return hash == root;
112   }
113 
114   /** Verifies the inclusion of a leaf in a Merkle tree using a Merkle proof */
115   function verifyIncluded(bytes memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
116     return checkProof(proof, root, leaf);
117   }
118 
119   /** Verifies the inclusion of a leaf is at a specific place in an ordered Merkle tree using a Merkle proof */
120   function verifyIncludedAtIndex(bytes memory proof, bytes32 root, bytes32 leaf, uint index) public pure returns (bool) {
121     return checkProofOrdered(proof, root, leaf, index);
122   }
123 }
124 
125 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Stoppable.sol
126 
127 /* using a master switch, allowing to permanently turn-off functionality */
128 contract Stoppable {
129 
130   /************************************ abstract **********************************/
131   modifier onlyOwner { _; }
132   /********************************************************************************/
133 
134   bool public isOn = true;
135 
136   modifier whenOn() { require(isOn, "must be on"); _; }
137   modifier whenOff() { require(!isOn, "must be off"); _; }
138 
139   function switchOff() external onlyOwner {
140     if (isOn) {
141       isOn = false;
142       emit Off();
143     }
144   }
145   event Off();
146 }
147 
148 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Validating.sol
149 
150 contract Validating {
151 
152   modifier notZero(uint number) { require(number != 0, "invalid 0 value"); _; }
153   modifier notEmpty(string memory text) { require(bytes(text).length != 0, "invalid empty string"); _; }
154   modifier validAddress(address value) { require(value != address(0x0), "invalid address");  _; }
155 
156 }
157 
158 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/HasOwners.sol
159 
160 contract HasOwners is Validating {
161 
162   mapping(address => bool) public isOwner;
163   address[] private owners;
164 
165   constructor(address[] memory _owners) public {
166     for (uint i = 0; i < _owners.length; i++) _addOwner_(_owners[i]);
167     owners = _owners;
168   }
169 
170   modifier onlyOwner { require(isOwner[msg.sender], "invalid sender; must be owner"); _; }
171 
172   function getOwners() public view returns (address[] memory) { return owners; }
173 
174   function addOwner(address owner) external onlyOwner {  _addOwner_(owner); }
175 
176   function _addOwner_(address owner) private validAddress(owner) {
177     if (!isOwner[owner]) {
178       isOwner[owner] = true;
179       owners.push(owner);
180       emit OwnerAdded(owner);
181     }
182   }
183   event OwnerAdded(address indexed owner);
184 
185   function removeOwner(address owner) external onlyOwner {
186     if (isOwner[owner]) {
187       require(owners.length > 1, "removing the last owner is not allowed");
188       isOwner[owner] = false;
189       for (uint i = 0; i < owners.length - 1; i++) {
190         if (owners[i] == owner) {
191           owners[i] = owners[owners.length - 1]; // replace map last entry
192           delete owners[owners.length - 1];
193           break;
194         }
195       }
196       owners.length -= 1;
197       emit OwnerRemoved(owner);
198     }
199   }
200   event OwnerRemoved(address indexed owner);
201 }
202 
203 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/Versioned.sol
204 
205 contract Versioned {
206   string public version;
207 
208   constructor(string memory _version) public {
209     version = _version;
210   }
211 
212 }
213 
214 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/custodian/Ledger.sol
215 
216 contract Ledger {
217 
218   function extractEntry(address[] memory addresses, uint[] memory uints) internal view returns (Entry memory result) {
219     addresses[0] = address(this);  /* ledgerId */
220     result.account = addresses[1];
221     result.asset = addresses[2];
222     result.entryType = EntryType(uints[0]);
223     result.action = uints[1];
224     result.timestamp = uints[2];
225     result.id = uints[3];
226     result.quantity = uints[4];
227     result.balance = uints[5];
228     result.previous = uints[6];
229     result.addresses = addresses;
230     result.uints = uints;
231     result.hash = calculateEvmConstrainedHash(result.entryType, addresses, uints);
232   }
233 
234   /**
235    * the Evm has a limit of psuedo 16 local variables (including parameters and return parameters).
236    * on exceeding this constraint, the Solidity compiler will bail out map:
237    *    'Error: Stack too deep, try removing local variables'
238    * so ... we opt to calculate the hash in chunks
239    */
240   function calculateEvmConstrainedHash(EntryType entryType, address[] memory addresses, uint[] memory uints) internal view returns (bytes32) {
241     bytes32 entryHash = calculateEntryHash(addresses, uints);
242     bytes32 witnessHash = calculateWitnessHash(entryType, addresses, uints);
243     return keccak256(abi.encodePacked(abi.encodePacked(entryHash, witnessHash)));
244   }
245   function calculateEntryHash(address[] memory addresses, uint[] memory uints) private pure returns (bytes32) {
246     return keccak256(abi.encodePacked(
247         addresses[0],
248         addresses[1],
249         addresses[2],
250         uints[0],
251         uints[1],
252         uints[2],
253         uints[3],
254         uints[4],
255         uints[5],
256         uints[6]
257       ));
258   }
259   function calculateWitnessHash(EntryType entryType, address[] memory addresses, uint[] memory uints) private view returns (bytes32) {
260     if (entryType == EntryType.Deposit) return calculateDepositInfoWitnessHash(uints);
261     if (entryType == EntryType.Withdrawal) return calculateWithdrawalRequestWitnessHash(addresses, uints);
262     if (entryType == EntryType.Trade || entryType == EntryType.Fee) return calculateMatchWitnessHash(addresses, uints);
263     return keccak256(abi.encodePacked(abi.encodePacked(uint(0))));
264   }
265   function calculateDepositInfoWitnessHash(uint[] memory uints) private view returns (bytes32) {
266     return keccak256(abi.encodePacked(
267         uints[offsets.uints.witness + 0],
268         uints[offsets.uints.witness + 1]
269       ));
270   }
271   function calculateWithdrawalRequestWitnessHash(address[] memory addresses, uint[] memory uints) private view returns (bytes32) {
272     return keccak256(abi.encodePacked(
273         addresses[offsets.addresses.witness + 0],
274         addresses[offsets.addresses.witness + 1],
275         uints[offsets.uints.witness + 0],
276         uints[offsets.uints.witness + 1]
277       ));
278   }
279   function calculateMatchWitnessHash(address[] memory addresses, uint[] memory uints) private view returns (bytes32) {
280     return keccak256(abi.encodePacked(
281         calculateFillHash(addresses, uints, offsets.addresses.witness, offsets.uints.witness),    // fill
282         calculateOrderHash(addresses, uints, offsets.addresses.maker, offsets.uints.maker), // maker
283         calculateOrderHash(addresses, uints, offsets.addresses.taker, offsets.uints.taker)  // taker
284       ));
285   }
286   function calculateFillHash(address[] memory addresses, uint[] memory uints, uint8 addressesOffset, uint8 uintsOffset) private pure returns (bytes32) {
287     return keccak256(abi.encodePacked(
288         addresses[addressesOffset + 0],
289         uints[uintsOffset + 0],
290         uints[uintsOffset + 1],
291         uints[uintsOffset + 2]
292       ));
293   }
294   function calculateOrderHash(address[] memory addresses, uint[] memory uints, uint8 addressesOffset, uint8 uintsOffset) private pure returns (bytes32) {
295     return keccak256(abi.encodePacked(
296         addresses[addressesOffset + 0],
297         addresses[addressesOffset + 1],
298         uints[uintsOffset + 0],
299         uints[uintsOffset + 1],
300         uints[uintsOffset + 2],
301         uints[uintsOffset + 3],
302         uints[uintsOffset + 4],
303         uints[uintsOffset + 5],
304         uints[uintsOffset + 6]
305       ));
306   }
307 
308   Offsets private offsets = getOffsets();
309   function getOffsets() private pure returns (Offsets memory) {
310     uint8 addressesInEntry = 3;
311     uint8 uintsInEntry = 7;
312     uint8 addressesInFill = 1;
313     uint8 uintsInFill = 3;
314     uint8 addressesInOrder = 2;
315     uint8 uintsInOrder = 7;
316     uint8 addressesInDeposit = 3;
317     uint8 uintsInDeposit = 3;
318     return Offsets({
319       addresses: OffsetKind({
320         deposit: addressesInDeposit,
321         witness: addressesInEntry,
322         maker: addressesInEntry + addressesInFill,
323         taker: addressesInEntry + addressesInFill + addressesInOrder
324         }),
325       uints: OffsetKind({
326         deposit: uintsInDeposit,
327         witness: uintsInEntry,
328         maker: uintsInEntry + uintsInFill,
329         taker: uintsInEntry + uintsInFill + uintsInOrder
330         })
331       });
332   }
333   struct OffsetKind { uint8 deposit; uint8 witness; uint8 maker; uint8 taker; }
334   struct Offsets { OffsetKind addresses; OffsetKind uints; }
335 
336 
337   enum EntryType { Unknown, Origin, Deposit, Withdrawal, Exited, Trade, Fee }
338 
339   struct Entry {
340     EntryType entryType;
341     uint action;
342     uint timestamp;
343     uint id;
344     address account;
345     address asset;
346     uint quantity;
347     uint balance;
348     uint previous;
349     address[] addresses;
350     uint[] uints;
351     bytes32 hash;
352   }
353 
354   struct DepositCommitmentRecord {
355     address account;
356     address asset;
357     uint quantity;
358     uint nonce;
359     uint designatedGblock;
360     bytes32 hash;
361   }
362 
363 
364 /***********************************************************************************************************************
365 for future fraud-proofs
366 
367   function getDepositWitness(Entry memory entry) internal view returns (DepositInfo memory result) {
368     require(entry.entryType == EntryType.Deposit, "entry must be of type Deposit");
369     result.nonce = entry.uints[offsets.uints.witness + 1];
370     result.designatedGblock = entry.uints[offsets.uints.witness + 1];
371   }
372 
373   function getWithdrawalRequestWitness(Entry memory entry) internal view returns (WithdrawalRequest memory result) {
374     require(entry.entryType == EntryType.Withdrawal, "entry must be of type Withdrawal");
375     result.account = entry.addresses[offsets.addresses.witness + 0];
376     result.asset = entry.addresses[offsets.addresses.witness + 1];
377     result.quantity = entry.uints[offsets.uints.witness + 0];
378     result.originatorTimestamp = entry.uints[offsets.uints.witness + 1];
379   }
380 
381   function getMatchWitness(Entry memory entry) internal view returns (Match memory match_) {
382     require(entry.entryType == EntryType.Trade || entry.entryType == EntryType.Fee, "entry must of type Trade or Fee");
383     match_.fill = getFill(entry, offsets.addresses.witness, offsets.uints.witness);
384     match_.maker = getOrder(entry, offsets.addresses.maker, offsets.uints.maker);
385     match_.taker = getOrder(entry, offsets.addresses.taker, offsets.uints.taker);
386   }
387 
388   function getFill(Entry memory entry, uint8 addressesOffset, uint8 uintsOffset) private pure returns (Fill memory result) {
389     result.token = entry.addresses[addressesOffset + 0];
390     result.timestamp = entry.uints[uintsOffset + 0];
391     result.quantity = entry.uints[uintsOffset + 1];
392     result.price = entry.uints[uintsOffset + 2];
393   }
394 
395   function getOrder(Entry memory entry, uint8 addressesOffset, uint8 uintsOffset) private pure returns (Order memory result) {
396     result.account = entry.addresses[addressesOffset + 0];
397     result.token = entry.addresses[addressesOffset + 1];
398     result.originatorTimestamp = entry.uints[uintsOffset + 0];
399     result.orderType = entry.uints[uintsOffset + 1];
400     result.side = entry.uints[uintsOffset + 2];
401     result.quantity = entry.uints[uintsOffset + 3];
402     result.price = entry.uints[uintsOffset + 4];
403     result.operatorTimestamp = entry.uints[uintsOffset + 5];
404     result.filled = entry.uints[uintsOffset + 6];
405   }
406 
407 
408   struct DepositInfo {
409     uint nonce;
410     uint designatedGblock;
411   }
412 
413   struct WithdrawalRequest {
414     address account;
415     address asset;
416     uint quantity;
417     uint originatorTimestamp;
418   }
419 
420   struct Match { Fill fill; Order maker; Order taker; }
421 
422   struct Fill {
423     uint timestamp;
424     address token;
425     uint quantity;
426     uint price;
427   }
428 
429   struct Order {
430     uint originatorTimestamp;
431     uint orderType;
432     address account;
433     address token;
434     uint side;
435     uint quantity;
436     uint price;
437     uint operatorTimestamp;
438     uint filled;
439   }
440 ***********************************************************************************************************************/
441 }
442 
443 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/custodian/Depositing.sol
444 
445 interface Depositing {
446 
447   function depositEther() external payable;
448 
449   function depositToken(address token, uint quantity) external;
450 
451   function reclaimDeposit(
452     address[] calldata addresses,
453     uint[] calldata uints,
454     bytes32[] calldata leaves,
455     uint[] calldata indexes,
456     bytes calldata predecessor,
457     bytes calldata successor
458   ) external;
459 }
460 
461 // File: /private/var/folders/2q/x2n3s2rx0d16552ynj1lx90r0000gn/T/tmp.ODkPvI0P/gluon-plasma/packages/on-chain/contracts/custodian/Withdrawing.sol
462 
463 interface Withdrawing {
464 
465   function withdraw(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;
466 
467   function claimExit(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;
468 
469   function exit(bytes32 entryHash, bytes calldata proof, bytes32 root) external;
470 
471   function exitOnHalt(address[] calldata addresses, uint[] calldata uints, bytes calldata signature, bytes calldata proof, bytes32 root) external;
472 }
473 
474 // File: contracts/custodian/Custodian.sol
475 
476 contract Custodian is Stoppable, HasOwners, MerkleProof, Ledger, Depositing, Withdrawing, Versioned {
477 
478   address public constant ETH = address(0x0);
479   uint public constant confirmationDelay = 5;
480   uint public constant visibilityDelay = 3;
481   uint public nonceGenerator = 0;
482 
483   address public operator;
484   address public registry;
485 
486   constructor(address[] memory _owners, address _registry, address _operator, uint _submissionInterval, string memory _version)
487     HasOwners(_owners)
488     Versioned(_version)
489     public validAddress(_registry) validAddress(_operator)
490   {
491     operator = _operator;
492     registry = _registry;
493     submissionInterval = _submissionInterval;
494   }
495 
496   // note: can move to a library
497   function transfer(uint quantity, address asset, address account) internal {
498     asset == ETH ?
499       require(address(uint160(account)).send(quantity), "failed to transfer ether") : // explicit casting to `address payable`
500       require(Token(asset).transfer(account, quantity), "failed to transfer token");
501   }
502 
503   /**
504    * @dev Recover signer address from a message by using their signature
505    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
506    * @param signature bytes generated using web3.eth.account.sign().signature
507    *
508    * Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
509    * TODO: Remove this library once solidity supports passing a signature to ecrecover.
510    * See https://github.com/ethereum/solidity/issues/864
511    */
512   // note: can move to a library
513   // note: can use a deployed https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/ECDSA.sol
514   function recover(bytes32 hash, bytes memory signature) private pure returns (address) {
515     bytes32 r; bytes32 s; uint8 v;
516     if (signature.length != 65) return (address(0)); //Check the signature length
517 
518     // Divide the signature into r, s and v variables
519     assembly {
520       r := mload(add(signature, 32))
521       s := mload(add(signature, 64))
522       v := byte(0, mload(add(signature, 96)))
523     }
524 
525     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
526     if (v < 27) v += 27;
527 
528     // If the version is correct return the signer address
529     return (v != 27 && v != 28) ? (address(0)) : ecrecover(hash, v, r, s);
530   }
531 
532   function verifySignedBy(bytes32 hash, bytes memory signature, address signer) internal pure {
533     require(recover(hash, signature) == signer, "failed to verify signature");
534   }
535 
536   /**************************************************** Depositing ****************************************************/
537 
538   mapping (bytes32 => bool) public deposits;
539 
540   modifier validToken(address value) { require(value != ETH, "value must be a valid ERC20 token address"); _; }
541 
542   function () external payable { deposit(msg.sender, ETH, msg.value); }
543   function depositEther() external payable { deposit(msg.sender, ETH, msg.value); }
544 
545   // note: an account must call token.approve(custodian, quantity) beforehand
546   function depositToken(address token, uint quantity) external validToken(token) {
547     uint balanceBefore = Token(token).balanceOf(address(this));
548     require(Token(token).transferFrom(msg.sender, address(this), quantity), "failure to transfer quantity from token");
549     uint balanceAfter = Token(token).balanceOf(address(this));
550     require(balanceAfter - balanceBefore == quantity, "bad Token; transferFrom erroneously reported of successful transfer");
551     deposit(msg.sender, token, quantity);
552   }
553 
554   function deposit(address account, address asset, uint quantity) private whenOn {
555     uint nonce = ++nonceGenerator;
556     uint designatedGblock = currentGblockNumber + visibilityDelay;
557     DepositCommitmentRecord memory record = toDepositCommitmentRecord(account, asset, quantity, nonce, designatedGblock);
558     deposits[record.hash] = true;
559     emit Deposited(address(this), account, asset, quantity, nonce, designatedGblock);
560   }
561 
562   function reclaimDeposit(
563     address[] calldata addresses,
564     uint[] calldata uints,
565     bytes32[] calldata leaves,
566     uint[] calldata indexes,
567     bytes calldata predecessor,
568     bytes calldata successor
569   ) external {
570     ProofOfExclusionOfDeposit memory proof = extractProofOfExclusionOfDeposit(addresses, uints, leaves, indexes, predecessor, successor);
571     DepositCommitmentRecord memory record = proof.excluded;
572     require(record.account == msg.sender, "claimant must be the original depositor");
573     require(currentGblockNumber > record.designatedGblock && record.designatedGblock != 0, "designated gblock is unconfirmed or unknown");
574 
575     Gblock memory designatedGblock = gblocksByNumber[record.designatedGblock];
576     require(proveIsExcludedFromDeposits(designatedGblock.depositsRoot, proof), "failed to proof exclusion of deposit");
577 
578     _reclaimDeposit_(record);
579   }
580 
581   function proveIsExcludedFromDeposits(bytes32 root, ProofOfExclusionOfDeposit memory proof) private pure returns (bool) {
582     return
583       proof.successor.index == proof.predecessor.index + 1 && // predecessor & successor must be consecutive
584       verifyIncludedAtIndex(proof.predecessor.proof, root, proof.predecessor.leaf, proof.predecessor.index) &&
585       verifyIncludedAtIndex(proof.successor.proof, root, proof.successor.leaf, proof.successor.index);
586   }
587 
588   function reclaimDepositOnHalt(address asset, uint quantity, uint nonce, uint designatedGblock) external whenOff {
589     DepositCommitmentRecord memory record = toDepositCommitmentRecord(msg.sender, asset, quantity, nonce, designatedGblock);
590     require(record.designatedGblock >= currentGblockNumber, "designated gblock is already confirmed; use exitOnHalt instead");
591     _reclaimDeposit_(record);
592   }
593 
594   function _reclaimDeposit_(DepositCommitmentRecord memory record) private {
595     require(deposits[record.hash], "unknown deposit");
596     delete deposits[record.hash];
597     transfer(record.quantity, record.asset, record.account);
598     emit DepositReclaimed(address(this), record.account, record.asset, record.quantity, record.nonce);
599   }
600 
601   function extractProofOfExclusionOfDeposit(
602     address[] memory addresses,
603     uint[] memory uints,
604     bytes32[] memory leaves,
605     uint[] memory indexes,
606     bytes memory predecessor,
607     bytes memory successor
608   ) private view returns (ProofOfExclusionOfDeposit memory result) {
609     result.excluded = extractDepositCommitmentRecord(addresses, uints);
610     result.predecessor = ProofOfInclusionAtIndex(leaves[0], indexes[0], predecessor);
611     result.successor = ProofOfInclusionAtIndex(leaves[1], indexes[1], successor);
612   }
613 
614   function extractDepositCommitmentRecord(address[] memory addresses, uint[] memory uints) private view returns (DepositCommitmentRecord memory) {
615     return toDepositCommitmentRecord(
616       addresses[1],
617       addresses[2],
618       uints[0],
619       uints[1],
620       uints[2]
621     );
622   }
623 
624   function toDepositCommitmentRecord(
625     address account,
626     address asset,
627     uint quantity,
628     uint nonce,
629     uint designatedGblock
630   ) private view returns (DepositCommitmentRecord memory result) {
631     result.account = account;
632     result.asset = asset;
633     result.quantity = quantity;
634     result.nonce = nonce;
635     result.designatedGblock = designatedGblock;
636     result.hash = keccak256(abi.encodePacked(
637       address(this),
638       account,
639       asset,
640       quantity,
641       nonce,
642       designatedGblock
643     ));
644   }
645 
646   event Deposited(address indexed custodian, address indexed account, address indexed asset, uint quantity, uint nonce, uint designatedGblock);
647   event DepositReclaimed(address indexed custodian, address indexed account, address indexed asset, uint quantity, uint nonce);
648 
649   struct ProofOfInclusionAtIndex { bytes32 leaf; uint index; bytes proof; }
650   struct ProofOfExclusionOfDeposit { DepositCommitmentRecord excluded; ProofOfInclusionAtIndex predecessor; ProofOfInclusionAtIndex successor; }
651 
652   /**************************************************** Withdrawing ***************************************************/
653 
654   mapping (bytes32 => bool) public withdrawn;
655   mapping (bytes32 => ExitClaim) private exitClaims;
656   mapping (address => mapping (address => bool)) public exited; // account => asset => did-exit
657 
658   function withdraw(
659     address[] calldata addresses,
660     uint[] calldata uints,
661     bytes calldata signature,
662     bytes calldata proof,
663     bytes32 root
664   ) external {
665     Entry memory entry = extractEntry(addresses, uints);
666     verifySignedBy(entry.hash, signature, operator);
667     require(entry.account == msg.sender, "withdrawer must be entry's account");
668     require(entry.entryType == EntryType.Withdrawal, "entry must be of type Withdrawal");
669     require(proveInConfirmedWithdrawals(proof, root, entry.hash), "invalid entry proof");
670     require(!withdrawn[entry.hash], "entry already withdrawn");
671     withdrawn[entry.hash] = true;
672     transfer(entry.quantity, entry.asset, entry.account);
673     emit Withdrawn(entry.hash, entry.account, entry.asset, entry.quantity);
674   }
675 
676   function claimExit(
677     address[] calldata addresses,
678     uint[] calldata uints,
679     bytes calldata signature,
680     bytes calldata proof,
681     bytes32 root
682   ) external whenOn {
683     Entry memory entry = extractEntry(addresses, uints);
684     verifySignedBy(entry.hash, signature, operator);
685     require(entry.account == msg.sender, "claimant must be entry's account");
686     require(!hasExited(entry.account, entry.asset), "previously exited");
687     require(proveInConfirmedBalances(proof, root, entry.hash), "invalid balance proof");
688 
689     uint confirmationThreshold = currentGblockNumber + confirmationDelay;
690     exitClaims[entry.hash] = ExitClaim(entry, confirmationThreshold);
691     emit ExitClaimed(entry.hash, entry.account, entry.asset, entry.balance, entry.timestamp, confirmationThreshold);
692   }
693 
694   function exit(bytes32 entryHash, bytes calldata proof, bytes32 root) external whenOn {
695     ExitClaim memory claim = exitClaims[entryHash];
696     require(canExit(entryHash), "no prior claim found to withdraw OR balances are yet to be confirmed");
697     require(proveInUnconfirmedBalances(proof, root, entryHash), "invalid balance proof");
698     delete exitClaims[entryHash];
699     _exit_(claim.entry);
700   }
701 
702   function exitOnHalt(
703     address[] calldata addresses,
704     uint[] calldata uints,
705     bytes calldata signature,
706     bytes calldata proof,
707     bytes32 root
708   ) external whenOff {
709     Entry memory entry = extractEntry(addresses, uints);
710     verifySignedBy(entry.hash, signature, operator);
711     require(entry.account == msg.sender, "claimant must be entry's account");
712     require(proveInConfirmedBalances(proof, root, entry.hash), "invalid balance proof");
713     _exit_(entry);
714   }
715 
716   function _exit_(Entry memory entry) private {
717     require(!hasExited(entry.account, entry.asset), "previously exited");
718     exited[entry.account][entry.asset] = true;
719     transfer(entry.balance, entry.asset, entry.account);
720     emit Exited(entry.account, entry.asset, entry.balance);
721   }
722 
723   function hasExited(address account, address asset) public view returns (bool) { return exited[account][asset]; }
724 
725   function canExit(bytes32 entryHash) public view returns (bool) {
726     return
727       exitClaims[entryHash].confirmationThreshold != 0 &&  // exists
728       currentGblockNumber >= exitClaims[entryHash].confirmationThreshold;
729   }
730 
731   event ExitClaimed(bytes32 hash, address indexed account, address indexed asset, uint quantity, uint timestamp, uint confirmationThreshold);
732   event Exited(address indexed account, address indexed asset, uint quantity);
733   event Withdrawn(bytes32 hash, address indexed account, address indexed asset, uint quantity);
734 
735   struct ExitClaim { Entry entry; uint confirmationThreshold; }
736 
737   /**************************************************** FraudProof ****************************************************/
738 
739   uint public currentGblockNumber;
740   mapping(uint => Gblock) public gblocksByNumber;
741   mapping(bytes32 => uint) public gblocksByDepositsRoot;
742   mapping(bytes32 => uint) public gblocksByWithdrawalsRoot;
743   mapping(bytes32 => uint) public gblocksByBalancesRoot;
744   uint public submissionInterval;
745   uint public submissionBlock = block.number;
746 
747   function canSubmit() public view returns (bool) { return block.number >= submissionBlock; }
748 
749   function submit(uint gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot) external whenOn {
750     require(canSubmit(), "cannot submit yet");
751     require(msg.sender == operator, "submitter must be the operator");
752     require(gblockNumber == currentGblockNumber + 1, "gblock must be the next in sequence");
753     Gblock memory gblock = Gblock(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot);
754     gblocksByNumber[gblockNumber] = gblock;
755     gblocksByDepositsRoot[depositsRoot] = gblockNumber;
756     gblocksByWithdrawalsRoot[withdrawalsRoot] = gblockNumber;
757     gblocksByBalancesRoot[balancesRoot] = gblockNumber;
758     currentGblockNumber = gblockNumber;
759     submissionBlock = block.number + submissionInterval;
760     emit Submitted(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot);
761   }
762 
763   function proveInConfirmedWithdrawals(bytes memory proof, bytes32 root, bytes32 entryHash) public view returns (bool) {
764     return isConfirmedWithdrawals(root) && verifyIncluded(proof, root, entryHash);
765   }
766 
767   function proveInConfirmedBalances(bytes memory proof, bytes32 root, bytes32 entryHash) public view returns (bool) {
768     return
769       root == gblocksByNumber[currentGblockNumber - 1 /* last-confirmed gblock */].balancesRoot &&
770       verifyIncluded(proof, root, entryHash);
771   }
772 
773   function proveInUnconfirmedBalances(bytes memory proof, bytes32 root, bytes32 entryHash) public view returns (bool) {
774     return
775       root == gblocksByNumber[currentGblockNumber /* unconfirmed gblock */].balancesRoot &&
776       verifyIncluded(proof, root, entryHash);
777   }
778 
779   function isConfirmedWithdrawals(bytes32 root) public view returns (bool) { return isConfirmedGblock(gblocksByWithdrawalsRoot[root]); }
780   function isUnconfirmedWithdrawals(bytes32 root) public view returns (bool) { return gblocksByWithdrawalsRoot[root] == currentGblockNumber; }
781   function includesWithdrawals(bytes32 root) public view returns (bool) { return gblocksByWithdrawalsRoot[root] != 0; }
782 
783   function isUnconfirmedBalances(bytes32 root) public view returns (bool) { return gblocksByBalancesRoot[root] == currentGblockNumber; }
784 
785   function isConfirmedGblock(uint number) public view returns (bool) { return 0 < number && number < currentGblockNumber; }
786 
787   event Submitted(uint gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot);
788 
789   struct Gblock { uint number; bytes32 withdrawalsRoot; bytes32 depositsRoot; bytes32 balancesRoot; }
790 
791   /********************************************************************************************************************/
792 }
