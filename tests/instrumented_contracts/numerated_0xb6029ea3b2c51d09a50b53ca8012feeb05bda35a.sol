1 pragma solidity ^0.5.0;
2 
3 contract Enum {
4     enum Operation {
5         Call,
6         DelegateCall,
7         Create
8     }
9 }
10 
11 contract EtherPaymentFallback {
12 
13     /// @dev Fallback function accepts Ether transactions.
14     function ()
15         external
16         payable
17     {
18 
19     }
20 }
21 
22 contract Executor is EtherPaymentFallback {
23 
24     event ContractCreation(address newContract);
25 
26     function execute(address to, uint256 value, bytes memory data, Enum.Operation operation, uint256 txGas)
27         internal
28         returns (bool success)
29     {
30         if (operation == Enum.Operation.Call)
31             success = executeCall(to, value, data, txGas);
32         else if (operation == Enum.Operation.DelegateCall)
33             success = executeDelegateCall(to, data, txGas);
34         else {
35             address newContract = executeCreate(data);
36             success = newContract != address(0);
37             emit ContractCreation(newContract);
38         }
39     }
40 
41     function executeCall(address to, uint256 value, bytes memory data, uint256 txGas)
42         internal
43         returns (bool success)
44     {
45         // solium-disable-next-line security/no-inline-assembly
46         assembly {
47             success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
48         }
49     }
50 
51     function executeDelegateCall(address to, bytes memory data, uint256 txGas)
52         internal
53         returns (bool success)
54     {
55         // solium-disable-next-line security/no-inline-assembly
56         assembly {
57             success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
58         }
59     }
60 
61     function executeCreate(bytes memory data)
62         internal
63         returns (address newContract)
64     {
65         // solium-disable-next-line security/no-inline-assembly
66         assembly {
67             newContract := create(0, add(data, 0x20), mload(data))
68         }
69     }
70 }
71 
72 contract SecuredTokenTransfer {
73 
74     /// @dev Transfers a token and returns if it was a success
75     /// @param token Token that should be transferred
76     /// @param receiver Receiver to whom the token should be transferred
77     /// @param amount The amount of tokens that should be transferred
78     function transferToken (
79         address token, 
80         address receiver,
81         uint256 amount
82     )
83         internal
84         returns (bool transferred)
85     {
86         bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", receiver, amount);
87         // solium-disable-next-line security/no-inline-assembly
88         assembly {
89             let success := call(sub(gas, 10000), token, 0, add(data, 0x20), mload(data), 0, 0)
90             let ptr := mload(0x40)
91             returndatacopy(ptr, 0, returndatasize)
92             switch returndatasize 
93             case 0 { transferred := success }
94             case 0x20 { transferred := iszero(or(iszero(success), iszero(mload(ptr)))) }
95             default { transferred := 0 }
96         }
97     }
98 }
99 
100 contract SelfAuthorized {
101     modifier authorized() {
102         require(msg.sender == address(this), "Method can only be called from this contract");
103         _;
104     }
105 }
106 
107 contract ModuleManager is SelfAuthorized, Executor {
108 
109     event EnabledModule(Module module);
110     event DisabledModule(Module module);
111 
112     address public constant SENTINEL_MODULES = address(0x1);
113 
114     mapping (address => address) internal modules;
115     
116     function setupModules(address to, bytes memory data)
117         internal
118     {
119         require(modules[SENTINEL_MODULES] == address(0), "Modules have already been initialized");
120         modules[SENTINEL_MODULES] = SENTINEL_MODULES;
121         if (to != address(0))
122             // Setup has to complete successfully or transaction fails.
123             require(executeDelegateCall(to, data, gasleft()), "Could not finish initialization");
124     }
125 
126     /// @dev Allows to add a module to the whitelist.
127     ///      This can only be done via a Safe transaction.
128     /// @param module Module to be whitelisted.
129     function enableModule(Module module)
130         public
131         authorized
132     {
133         // Module address cannot be null or sentinel.
134         require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
135         // Module cannot be added twice.
136         require(modules[address(module)] == address(0), "Module has already been added");
137         modules[address(module)] = modules[SENTINEL_MODULES];
138         modules[SENTINEL_MODULES] = address(module);
139         emit EnabledModule(module);
140     }
141 
142     /// @dev Allows to remove a module from the whitelist.
143     ///      This can only be done via a Safe transaction.
144     /// @param prevModule Module that pointed to the module to be removed in the linked list
145     /// @param module Module to be removed.
146     function disableModule(Module prevModule, Module module)
147         public
148         authorized
149     {
150         // Validate module address and check that it corresponds to module index.
151         require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
152         require(modules[address(prevModule)] == address(module), "Invalid prevModule, module pair provided");
153         modules[address(prevModule)] = modules[address(module)];
154         modules[address(module)] = address(0);
155         emit DisabledModule(module);
156     }
157 
158     /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
159     /// @param to Destination address of module transaction.
160     /// @param value Ether value of module transaction.
161     /// @param data Data payload of module transaction.
162     /// @param operation Operation type of module transaction.
163     function execTransactionFromModule(address to, uint256 value, bytes memory data, Enum.Operation operation)
164         public
165         returns (bool success)
166     {
167         // Only whitelisted modules are allowed.
168         require(msg.sender != SENTINEL_MODULES && modules[msg.sender] != address(0), "Method can only be called from an enabled module");
169         // Execute transaction without further confirmations.
170         success = execute(to, value, data, operation, gasleft());
171     }
172 
173     /// @dev Returns array of modules.
174     /// @return Array of modules.
175     function getModules()
176         public
177         view
178         returns (address[] memory)
179     {
180         // Calculate module count
181         uint256 moduleCount = 0;
182         address currentModule = modules[SENTINEL_MODULES];
183         while(currentModule != SENTINEL_MODULES) {
184             currentModule = modules[currentModule];
185             moduleCount ++;
186         }
187         address[] memory array = new address[](moduleCount);
188 
189         // populate return array
190         moduleCount = 0;
191         currentModule = modules[SENTINEL_MODULES];
192         while(currentModule != SENTINEL_MODULES) {
193             array[moduleCount] = currentModule;
194             currentModule = modules[currentModule];
195             moduleCount ++;
196         }
197         return array;
198     }
199 }
200 
201 contract OwnerManager is SelfAuthorized {
202 
203     event AddedOwner(address owner);
204     event RemovedOwner(address owner);
205     event ChangedThreshold(uint256 threshold);
206 
207     address public constant SENTINEL_OWNERS = address(0x1);
208 
209     mapping(address => address) internal owners;
210     uint256 ownerCount;
211     uint256 internal threshold;
212 
213     /// @dev Setup function sets initial storage of contract.
214     /// @param _owners List of Safe owners.
215     /// @param _threshold Number of required confirmations for a Safe transaction.
216     function setupOwners(address[] memory _owners, uint256 _threshold)
217         internal
218     {
219         // Threshold can only be 0 at initialization.
220         // Check ensures that setup function can only be called once.
221         require(threshold == 0, "Owners have already been setup");
222         // Validate that threshold is smaller than number of added owners.
223         require(_threshold <= _owners.length, "Threshold cannot exceed owner count");
224         // There has to be at least one Safe owner.
225         require(_threshold >= 1, "Threshold needs to be greater than 0");
226         // Initializing Safe owners.
227         address currentOwner = SENTINEL_OWNERS;
228         for (uint256 i = 0; i < _owners.length; i++) {
229             // Owner address cannot be null.
230             address owner = _owners[i];
231             require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
232             // No duplicate owners allowed.
233             require(owners[owner] == address(0), "Duplicate owner address provided");
234             owners[currentOwner] = owner;
235             currentOwner = owner;
236         }
237         owners[currentOwner] = SENTINEL_OWNERS;
238         ownerCount = _owners.length;
239         threshold = _threshold;
240     }
241 
242     /// @dev Allows to add a new owner to the Safe and update the threshold at the same time.
243     ///      This can only be done via a Safe transaction.
244     /// @param owner New owner address.
245     /// @param _threshold New threshold.
246     function addOwnerWithThreshold(address owner, uint256 _threshold)
247         public
248         authorized
249     {
250         // Owner address cannot be null.
251         require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
252         // No duplicate owners allowed.
253         require(owners[owner] == address(0), "Address is already an owner");
254         owners[owner] = owners[SENTINEL_OWNERS];
255         owners[SENTINEL_OWNERS] = owner;
256         ownerCount++;
257         emit AddedOwner(owner);
258         // Change threshold if threshold was changed.
259         if (threshold != _threshold)
260             changeThreshold(_threshold);
261     }
262 
263     /// @dev Allows to remove an owner from the Safe and update the threshold at the same time.
264     ///      This can only be done via a Safe transaction.
265     /// @param prevOwner Owner that pointed to the owner to be removed in the linked list
266     /// @param owner Owner address to be removed.
267     /// @param _threshold New threshold.
268     function removeOwner(address prevOwner, address owner, uint256 _threshold)
269         public
270         authorized
271     {
272         // Only allow to remove an owner, if threshold can still be reached.
273         require(ownerCount - 1 >= _threshold, "New owner count needs to be larger than new threshold");
274         // Validate owner address and check that it corresponds to owner index.
275         require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
276         require(owners[prevOwner] == owner, "Invalid prevOwner, owner pair provided");
277         owners[prevOwner] = owners[owner];
278         owners[owner] = address(0);
279         ownerCount--;
280         emit RemovedOwner(owner);
281         // Change threshold if threshold was changed.
282         if (threshold != _threshold)
283             changeThreshold(_threshold);
284     }
285 
286     /// @dev Allows to swap/replace an owner from the Safe with another address.
287     ///      This can only be done via a Safe transaction.
288     /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
289     /// @param oldOwner Owner address to be replaced.
290     /// @param newOwner New owner address.
291     function swapOwner(address prevOwner, address oldOwner, address newOwner)
292         public
293         authorized
294     {
295         // Owner address cannot be null.
296         require(newOwner != address(0) && newOwner != SENTINEL_OWNERS, "Invalid owner address provided");
297         // No duplicate owners allowed.
298         require(owners[newOwner] == address(0), "Address is already an owner");
299         // Validate oldOwner address and check that it corresponds to owner index.
300         require(oldOwner != address(0) && oldOwner != SENTINEL_OWNERS, "Invalid owner address provided");
301         require(owners[prevOwner] == oldOwner, "Invalid prevOwner, owner pair provided");
302         owners[newOwner] = owners[oldOwner];
303         owners[prevOwner] = newOwner;
304         owners[oldOwner] = address(0);
305         emit RemovedOwner(oldOwner);
306         emit AddedOwner(newOwner);
307     }
308 
309     /// @dev Allows to update the number of required confirmations by Safe owners.
310     ///      This can only be done via a Safe transaction.
311     /// @param _threshold New threshold.
312     function changeThreshold(uint256 _threshold)
313         public
314         authorized
315     {
316         // Validate that threshold is smaller than number of owners.
317         require(_threshold <= ownerCount, "Threshold cannot exceed owner count");
318         // There has to be at least one Safe owner.
319         require(_threshold >= 1, "Threshold needs to be greater than 0");
320         threshold = _threshold;
321         emit ChangedThreshold(threshold);
322     }
323 
324     function getThreshold()
325         public
326         view
327         returns (uint256)
328     {
329         return threshold;
330     }
331 
332     function isOwner(address owner)
333         public
334         view
335         returns (bool)
336     {
337         return owner != SENTINEL_OWNERS && owners[owner] != address(0);
338     }
339 
340     /// @dev Returns array of owners.
341     /// @return Array of Safe owners.
342     function getOwners()
343         public
344         view
345         returns (address[] memory)
346     {
347         address[] memory array = new address[](ownerCount);
348 
349         // populate return array
350         uint256 index = 0;
351         address currentOwner = owners[SENTINEL_OWNERS];
352         while(currentOwner != SENTINEL_OWNERS) {
353             array[index] = currentOwner;
354             currentOwner = owners[currentOwner];
355             index ++;
356         }
357         return array;
358     }
359 }
360 
361 contract BaseSafe is ModuleManager, OwnerManager {
362 
363     /// @dev Setup function sets initial storage of contract.
364     /// @param _owners List of Safe owners.
365     /// @param _threshold Number of required confirmations for a Safe transaction.
366     /// @param to Contract address for optional delegate call.
367     /// @param data Data payload for optional delegate call.
368     function setupSafe(address[] memory _owners, uint256 _threshold, address to, bytes memory data)
369         internal
370     {
371         setupOwners(_owners, _threshold);
372         // As setupOwners can only be called if the contract has not been initialized we don't need a check for setupModules
373         setupModules(to, data);
374     }
375 }
376 
377 contract MasterCopy is SelfAuthorized {
378   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
379   // It should also always be ensured that the address is stored alone (uses a full word)
380     address masterCopy;
381 
382   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
383   /// @param _masterCopy New contract address.
384     function changeMasterCopy(address _masterCopy)
385         public
386         authorized
387     {
388         // Master copy address cannot be null.
389         require(_masterCopy != address(0), "Invalid master copy address provided");
390         masterCopy = _masterCopy;
391     }
392 }
393 
394 contract Module is MasterCopy {
395 
396     ModuleManager public manager;
397 
398     modifier authorized() {
399         require(msg.sender == address(manager), "Method can only be called from manager");
400         _;
401     }
402 
403     function setManager()
404         internal
405     {
406         // manager can only be 0 at initalization of contract.
407         // Check ensures that setup function can only be called once.
408         require(address(manager) == address(0), "Manager has already been set");
409         manager = ModuleManager(msg.sender);
410     }
411 }
412 
413 contract SignatureDecoder {
414     
415     /// @dev Recovers address who signed the message 
416     /// @param messageHash operation ethereum signed message hash
417     /// @param messageSignature message `txHash` signature
418     /// @param pos which signature to read
419     function recoverKey (
420         bytes32 messageHash, 
421         bytes memory messageSignature,
422         uint256 pos
423     )
424         internal
425         pure
426         returns (address) 
427     {
428         uint8 v;
429         bytes32 r;
430         bytes32 s;
431         (v, r, s) = signatureSplit(messageSignature, pos);
432         return ecrecover(messageHash, v, r, s);
433     }
434 
435     /// @dev divides bytes signature into `uint8 v, bytes32 r, bytes32 s`. 
436     /// @notice Make sure to peform a bounds check for @param pos, to avoid out of bounds access on @param signatures
437     /// @param pos which signature to read. A prior bounds check of this parameter should be performed, to avoid out of bounds access
438     /// @param signatures concatenated rsv signatures
439     function signatureSplit(bytes memory signatures, uint256 pos)
440         internal
441         pure
442         returns (uint8 v, bytes32 r, bytes32 s)
443     {
444         // The signature format is a compact form of:
445         //   {bytes32 r}{bytes32 s}{uint8 v}
446         // Compact means, uint8 is not padded to 32 bytes.
447         // solium-disable-next-line security/no-inline-assembly
448         assembly {
449             let signaturePos := mul(0x41, pos)
450             r := mload(add(signatures, add(signaturePos, 0x20)))
451             s := mload(add(signatures, add(signaturePos, 0x40)))
452             // Here we are loading the last 32 bytes, including 31 bytes
453             // of 's'. There is no 'mload8' to do this.
454             //
455             // 'byte' is not working due to the Solidity parser, so lets
456             // use the second best option, 'and'
457             v := and(mload(add(signatures, add(signaturePos, 0x41))), 0xff)
458         }
459     }
460 }
461 
462 library SafeMath {
463 
464   /**
465   * @dev Multiplies two numbers, reverts on overflow.
466   */
467   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
468     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
469     // benefit is lost if 'b' is also tested.
470     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
471     if (a == 0) {
472       return 0;
473     }
474 
475     uint256 c = a * b;
476     require(c / a == b);
477 
478     return c;
479   }
480 
481   /**
482   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
483   */
484   function div(uint256 a, uint256 b) internal pure returns (uint256) {
485     require(b > 0); // Solidity only automatically asserts when dividing by 0
486     uint256 c = a / b;
487     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
488 
489     return c;
490   }
491 
492   /**
493   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
494   */
495   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
496     require(b <= a);
497     uint256 c = a - b;
498 
499     return c;
500   }
501 
502   /**
503   * @dev Adds two numbers, reverts on overflow.
504   */
505   function add(uint256 a, uint256 b) internal pure returns (uint256) {
506     uint256 c = a + b;
507     require(c >= a);
508 
509     return c;
510   }
511 
512   /**
513   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
514   * reverts when dividing by zero.
515   */
516   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
517     require(b != 0);
518     return a % b;
519   }
520 }
521 
522 contract ISignatureValidator {
523     // bytes4(keccak256("isValidSignature(bytes,bytes)")
524     bytes4 constant internal EIP1271_MAGIC_VALUE = 0x20c13b0b;
525 
526     /**
527     * @dev Should return whether the signature provided is valid for the provided data
528     * @param _data Arbitrary length data signed on the behalf of address(this)
529     * @param _signature Signature byte array associated with _data
530     *
531     * MUST return the bytes4 magic value 0x20c13b0b when function passes.
532     * MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
533     * MUST allow external calls
534     */ 
535     function isValidSignature(
536         bytes calldata _data, 
537         bytes calldata _signature)
538         external 
539         returns (bytes4);
540 }
541 
542 contract GnosisSafe is MasterCopy, BaseSafe, SignatureDecoder, SecuredTokenTransfer, ISignatureValidator {
543 
544     using SafeMath for uint256;
545 
546     string public constant NAME = "Gnosis Safe";
547     string public constant VERSION = "1.0.0";
548 
549     //keccak256(
550     //    "EIP712Domain(address verifyingContract)"
551     //);
552     bytes32 public constant DOMAIN_SEPARATOR_TYPEHASH = 0x035aff83d86937d35b32e04f0ddc6ff469290eef2f1b692d8a815c89404d4749;
553 
554     //keccak256(
555     //    "SafeTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 baseGas,uint256 gasPrice,address gasToken,address refundReceiver,uint256 nonce)"
556     //);
557     bytes32 public constant SAFE_TX_TYPEHASH = 0xbb8310d486368db6bd6f849402fdd73ad53d316b5a4b2644ad6efe0f941286d8;
558 
559     //keccak256(
560     //    "SafeMessage(bytes message)"
561     //);
562     bytes32 public constant SAFE_MSG_TYPEHASH = 0x60b3cbf8b4a223d68d641b3b6ddf9a298e7f33710cf3d3a9d1146b5a6150fbca;
563 
564     event ExecutionFailed(bytes32 txHash);
565 
566     uint256 public nonce;
567     bytes32 public domainSeparator;
568     // Mapping to keep track of all message hashes that have been approve by ALL REQUIRED owners
569     mapping(bytes32 => uint256) public signedMessages;
570     // Mapping to keep track of all hashes (message or transaction) that have been approve by ANY owners
571     mapping(address => mapping(bytes32 => uint256)) public approvedHashes;
572 
573     /// @dev Setup function sets initial storage of contract.
574     /// @param _owners List of Safe owners.
575     /// @param _threshold Number of required confirmations for a Safe transaction.
576     /// @param to Contract address for optional delegate call.
577     /// @param data Data payload for optional delegate call.
578     /// @param paymentToken Token that should be used for the payment (0 is ETH)
579     /// @param payment Value that should be paid
580     /// @param paymentReceiver Adddress that should receive the payment (or 0 if tx.origin)
581     function setup(address[] calldata _owners, uint256 _threshold, address to, bytes calldata data, address paymentToken, uint256 payment, address payable paymentReceiver)
582         external
583     {
584         require(domainSeparator == 0, "Domain Separator already set!");
585         domainSeparator = keccak256(abi.encode(DOMAIN_SEPARATOR_TYPEHASH, this));
586         setupSafe(_owners, _threshold, to, data);
587         
588         if (payment > 0) {
589             // To avoid running into issues with EIP-170 we reuse the handlePayment function (to avoid adjusting code of that has been verified we do not adjust the method itself)
590             // baseGas = 0, gasPrice = 1 and gas = payment => amount = (payment + 0) * 1 = payment
591             handlePayment(payment, 0, 1, paymentToken, paymentReceiver);
592         } 
593     }
594 
595     /// @dev Allows to execute a Safe transaction confirmed by required number of owners and then pays the account that submitted the transaction.
596     ///      Note: The fees are always transfered, even if the user transaction fails.
597     /// @param to Destination address of Safe transaction.
598     /// @param value Ether value of Safe transaction.
599     /// @param data Data payload of Safe transaction.
600     /// @param operation Operation type of Safe transaction.
601     /// @param safeTxGas Gas that should be used for the Safe transaction.
602     /// @param baseGas Gas costs for that are indipendent of the transaction execution(e.g. base transaction fee, signature check, payment of the refund)
603     /// @param gasPrice Gas price that should be used for the payment calculation.
604     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
605     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
606     /// @param signatures Packed signature data ({bytes32 r}{bytes32 s}{uint8 v})
607     function execTransaction(
608         address to,
609         uint256 value,
610         bytes calldata data,
611         Enum.Operation operation,
612         uint256 safeTxGas,
613         uint256 baseGas,
614         uint256 gasPrice,
615         address gasToken,
616         address payable refundReceiver,
617         bytes calldata signatures
618     )
619         external
620         returns (bool success)
621     {
622         bytes memory txHashData = encodeTransactionData(
623             to, value, data, operation, // Transaction info
624             safeTxGas, baseGas, gasPrice, gasToken, refundReceiver, // Payment info
625             nonce
626         );
627         // Increase nonce and execute transaction.
628         nonce++;
629         checkSignatures(keccak256(txHashData), txHashData, signatures, true);
630         require(gasleft() >= safeTxGas, "Not enough gas to execute safe transaction");
631         uint256 gasUsed = gasleft();
632         // If no safeTxGas has been set and the gasPrice is 0 we assume that all available gas can be used
633         success = execute(to, value, data, operation, safeTxGas == 0 && gasPrice == 0 ? gasleft() : safeTxGas);
634         gasUsed = gasUsed.sub(gasleft());
635         if (!success) {
636             emit ExecutionFailed(keccak256(txHashData));
637         }
638 
639         // We transfer the calculated tx costs to the tx.origin to avoid sending it to intermediate contracts that have made calls
640         if (gasPrice > 0) {
641             handlePayment(gasUsed, baseGas, gasPrice, gasToken, refundReceiver);
642         }
643     }
644 
645     function handlePayment(
646         uint256 gasUsed,
647         uint256 baseGas,
648         uint256 gasPrice,
649         address gasToken,
650         address payable refundReceiver
651     )
652         private
653     {
654         uint256 amount = gasUsed.add(baseGas).mul(gasPrice);
655         // solium-disable-next-line security/no-tx-origin
656         address payable receiver = refundReceiver == address(0) ? tx.origin : refundReceiver;
657         if (gasToken == address(0)) {
658             // solium-disable-next-line security/no-send
659             require(receiver.send(amount), "Could not pay gas costs with ether");
660         } else {
661             require(transferToken(gasToken, receiver, amount), "Could not pay gas costs with token");
662         }
663     }
664 
665     /**
666     * @dev Checks whether the signature provided is valid for the provided data, hash. Will revert otherwise.
667     * @param dataHash Hash of the data (could be either a message hash or transaction hash)
668     * @param data That should be signed (this is passed to an external validator contract)
669     * @param signatures Signature data that should be verified. Can be ECDSA signature, contract signature (EIP-1271) or approved hash.
670     * @param consumeHash Indicates that in case of an approved hash the storage can be freed to save gas
671     */
672     function checkSignatures(bytes32 dataHash, bytes memory data, bytes memory signatures, bool consumeHash)
673         internal
674     {
675         // Check that the provided signature data is not too short
676         require(signatures.length >= threshold.mul(65), "Signatures data too short");
677         // There cannot be an owner with address 0.
678         address lastOwner = address(0);
679         address currentOwner;
680         uint8 v;
681         bytes32 r;
682         bytes32 s;
683         uint256 i;
684         for (i = 0; i < threshold; i++) {
685             (v, r, s) = signatureSplit(signatures, i);
686             // If v is 0 then it is a contract signature
687             if (v == 0) {
688                 // When handling contract signatures the address of the contract is encoded into r
689                 currentOwner = address(uint256(r));
690 
691                 // Check that signature data pointer (s) is not pointing inside the static part of the signatures bytes
692                 // This check is not completely accurate, since it is possible that more signatures than the threshold are send.
693                 // Here we only check that the pointer is not pointing inside the part that is being processed
694                 require(uint256(s) >= threshold.mul(65), "Invalid contract signature location: inside static part");
695 
696                 // Check that signature data pointer (s) is in bounds (points to the length of data -> 32 bytes)
697                 require(uint256(s).add(32) <= signatures.length, "Invalid contract signature location: length not present");
698 
699                 // Check if the contract signature is in bounds: start of data is s + 32 and end is start + signature length
700                 uint256 contractSignatureLen;
701                 // solium-disable-next-line security/no-inline-assembly
702                 assembly {
703                     contractSignatureLen := mload(add(add(signatures, s), 0x20))
704                 }
705                 require(uint256(s).add(32).add(contractSignatureLen) <= signatures.length, "Invalid contract signature location: data not complete");
706 
707                 // Check signature
708                 bytes memory contractSignature;
709                 // solium-disable-next-line security/no-inline-assembly
710                 assembly {
711                     // The signature data for contract signatures is appended to the concatenated signatures and the offset is stored in s
712                     contractSignature := add(add(signatures, s), 0x20)
713                 }
714                 require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE, "Invalid contract signature provided");
715             // If v is 1 then it is an approved hash
716             } else if (v == 1) {
717                 // When handling approved hashes the address of the approver is encoded into r
718                 currentOwner = address(uint256(r));
719                 // Hashes are automatically approved by the sender of the message or when they have been pre-approved via a separate transaction
720                 require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "Hash has not been approved");
721                 // Hash has been marked for consumption. If this hash was pre-approved free storage
722                 if (consumeHash && msg.sender != currentOwner) {
723                     approvedHashes[currentOwner][dataHash] = 0;
724                 }
725             } else {
726                 // Use ecrecover with the messageHash for EOA signatures
727                 currentOwner = ecrecover(dataHash, v, r, s);
728             }
729             require (currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS, "Invalid owner provided");
730             lastOwner = currentOwner;
731         }
732     }
733 
734     /// @dev Allows to estimate a Safe transaction.
735     ///      This method is only meant for estimation purpose, therfore two different protection mechanism against execution in a transaction have been made:
736     ///      1.) The method can only be called from the safe itself
737     ///      2.) The response is returned with a revert
738     ///      When estimating set `from` to the address of the safe.
739     ///      Since the `estimateGas` function includes refunds, call this method to get an estimated of the costs that are deducted from the safe with `execTransaction`
740     /// @param to Destination address of Safe transaction.
741     /// @param value Ether value of Safe transaction.
742     /// @param data Data payload of Safe transaction.
743     /// @param operation Operation type of Safe transaction.
744     /// @return Estimate without refunds and overhead fees (base transaction and payload data gas costs).
745     function requiredTxGas(address to, uint256 value, bytes calldata data, Enum.Operation operation)
746         external
747         authorized
748         returns (uint256)
749     {
750         uint256 startGas = gasleft();
751         // We don't provide an error message here, as we use it to return the estimate
752         // solium-disable-next-line error-reason
753         require(execute(to, value, data, operation, gasleft()));
754         uint256 requiredGas = startGas - gasleft();
755         // Convert response to string and return via error message
756         revert(string(abi.encodePacked(requiredGas)));
757     }
758 
759     /**
760     * @dev Marks a hash as approved. This can be used to validate a hash that is used by a signature.
761     * @param hashToApprove The hash that should be marked as approved for signatures that are verified by this contract.
762     */
763     function approveHash(bytes32 hashToApprove)
764         external
765     {
766         require(owners[msg.sender] != address(0), "Only owners can approve a hash");
767         approvedHashes[msg.sender][hashToApprove] = 1;
768     }
769 
770     /**
771     * @dev Marks a message as signed
772     * @param _data Arbitrary length data that should be marked as signed on the behalf of address(this)
773     */ 
774     function signMessage(bytes calldata _data) 
775         external
776         authorized
777     {
778         signedMessages[getMessageHash(_data)] = 1;
779     }
780 
781     /**
782     * @dev Should return whether the signature provided is valid for the provided data
783     * @param _data Arbitrary length data signed on the behalf of address(this)
784     * @param _signature Signature byte array associated with _data
785     * @return a bool upon valid or invalid signature with corresponding _data
786     */ 
787     function isValidSignature(bytes calldata _data, bytes calldata _signature)
788         external
789         returns (bytes4)
790     {
791         bytes32 messageHash = getMessageHash(_data);
792         if (_signature.length == 0) {
793             require(signedMessages[messageHash] != 0, "Hash not approved");
794         } else {
795             // consumeHash needs to be false, as the state should not be changed
796             checkSignatures(messageHash, _data, _signature, false);
797         }
798         return EIP1271_MAGIC_VALUE;
799     }
800 
801     /// @dev Returns hash of a message that can be signed by owners.
802     /// @param message Message that should be hashed
803     /// @return Message hash.
804     function getMessageHash(
805         bytes memory message
806     )
807         public
808         view
809         returns (bytes32)
810     {
811         bytes32 safeMessageHash = keccak256(
812             abi.encode(SAFE_MSG_TYPEHASH, keccak256(message))
813         );
814         return keccak256(
815             abi.encodePacked(byte(0x19), byte(0x01), domainSeparator, safeMessageHash)
816         );
817     }
818 
819     /// @dev Returns the bytes that are hashed to be signed by owners.
820     /// @param to Destination address.
821     /// @param value Ether value.
822     /// @param data Data payload.
823     /// @param operation Operation type.
824     /// @param safeTxGas Fas that should be used for the safe transaction.
825     /// @param baseGas Gas costs for data used to trigger the safe transaction.
826     /// @param gasPrice Maximum gas price that should be used for this transaction.
827     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
828     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
829     /// @param _nonce Transaction nonce.
830     /// @return Transaction hash bytes.
831     function encodeTransactionData(
832         address to, 
833         uint256 value, 
834         bytes memory data, 
835         Enum.Operation operation, 
836         uint256 safeTxGas, 
837         uint256 baseGas, 
838         uint256 gasPrice,
839         address gasToken,
840         address refundReceiver,
841         uint256 _nonce
842     )
843         public
844         view
845         returns (bytes memory)
846     {
847         bytes32 safeTxHash = keccak256(
848             abi.encode(SAFE_TX_TYPEHASH, to, value, keccak256(data), operation, safeTxGas, baseGas, gasPrice, gasToken, refundReceiver, _nonce)
849         );
850         return abi.encodePacked(byte(0x19), byte(0x01), domainSeparator, safeTxHash);
851     }
852 
853     /// @dev Returns hash to be signed by owners.
854     /// @param to Destination address.
855     /// @param value Ether value.
856     /// @param data Data payload.
857     /// @param operation Operation type.
858     /// @param safeTxGas Fas that should be used for the safe transaction.
859     /// @param baseGas Gas costs for data used to trigger the safe transaction.
860     /// @param gasPrice Maximum gas price that should be used for this transaction.
861     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
862     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
863     /// @param _nonce Transaction nonce.
864     /// @return Transaction hash.
865     function getTransactionHash(
866         address to, 
867         uint256 value, 
868         bytes memory data, 
869         Enum.Operation operation, 
870         uint256 safeTxGas, 
871         uint256 baseGas, 
872         uint256 gasPrice,
873         address gasToken,
874         address refundReceiver,
875         uint256 _nonce
876     )
877         public
878         view
879         returns (bytes32)
880     {
881         return keccak256(encodeTransactionData(to, value, data, operation, safeTxGas, baseGas, gasPrice, gasToken, refundReceiver, _nonce));
882     }
883 }