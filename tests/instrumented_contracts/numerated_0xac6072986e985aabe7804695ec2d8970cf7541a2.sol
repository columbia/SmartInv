1 pragma solidity ^0.4.24;
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
26     function execute(address to, uint256 value, bytes data, Enum.Operation operation, uint256 txGas)
27         internal
28         returns (bool success)
29     {
30         if (operation == Enum.Operation.Call)
31             success = executeCall(to, value, data, txGas);
32         else if (operation == Enum.Operation.DelegateCall)
33             success = executeDelegateCall(to, data, txGas);
34         else {
35             address newContract = executeCreate(data);
36             success = newContract != 0;
37             emit ContractCreation(newContract);
38         }
39     }
40 
41     function executeCall(address to, uint256 value, bytes data, uint256 txGas)
42         internal
43         returns (bool success)
44     {
45         // solium-disable-next-line security/no-inline-assembly
46         assembly {
47             success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
48         }
49     }
50 
51     function executeDelegateCall(address to, bytes data, uint256 txGas)
52         internal
53         returns (bool success)
54     {
55         // solium-disable-next-line security/no-inline-assembly
56         assembly {
57             success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
58         }
59     }
60 
61     function executeCreate(bytes data)
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
116     function setupModules(address to, bytes data)
117         internal
118     {
119         require(modules[SENTINEL_MODULES] == 0, "Modules have already been initialized");
120         modules[SENTINEL_MODULES] = SENTINEL_MODULES;
121         if (to != 0)
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
134         require(address(module) != 0 && address(module) != SENTINEL_MODULES, "Invalid module address provided");
135         // Module cannot be added twice.
136         require(modules[module] == 0, "Module has already been added");
137         modules[module] = modules[SENTINEL_MODULES];
138         modules[SENTINEL_MODULES] = module;
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
151         require(address(module) != 0 && address(module) != SENTINEL_MODULES, "Invalid module address provided");
152         require(modules[prevModule] == address(module), "Invalid prevModule, module pair provided");
153         modules[prevModule] = modules[module];
154         modules[module] = 0;
155         emit DisabledModule(module);
156     }
157 
158     /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
159     /// @param to Destination address of module transaction.
160     /// @param value Ether value of module transaction.
161     /// @param data Data payload of module transaction.
162     /// @param operation Operation type of module transaction.
163     function execTransactionFromModule(address to, uint256 value, bytes data, Enum.Operation operation)
164         public
165         returns (bool success)
166     {
167         // Only whitelisted modules are allowed.
168         require(modules[msg.sender] != 0, "Method can only be called from an enabled module");
169         // Execute transaction without further confirmations.
170         success = execute(to, value, data, operation, gasleft());
171     }
172 
173     /// @dev Returns array of modules.
174     /// @return Array of modules.
175     function getModules()
176         public
177         view
178         returns (address[])
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
216     function setupOwners(address[] _owners, uint256 _threshold)
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
231             require(owner != 0 && owner != SENTINEL_OWNERS, "Invalid owner address provided");
232             // No duplicate owners allowed.
233             require(owners[owner] == 0, "Duplicate owner address provided");
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
251         require(owner != 0 && owner != SENTINEL_OWNERS, "Invalid owner address provided");
252         // No duplicate owners allowed.
253         require(owners[owner] == 0, "Address is already an owner");
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
275         require(owner != 0 && owner != SENTINEL_OWNERS, "Invalid owner address provided");
276         require(owners[prevOwner] == owner, "Invalid prevOwner, owner pair provided");
277         owners[prevOwner] = owners[owner];
278         owners[owner] = 0;
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
296         require(newOwner != 0 && newOwner != SENTINEL_OWNERS, "Invalid owner address provided");
297         // No duplicate owners allowed.
298         require(owners[newOwner] == 0, "Address is already an owner");
299         // Validate oldOwner address and check that it corresponds to owner index.
300         require(oldOwner != 0 && oldOwner != SENTINEL_OWNERS, "Invalid owner address provided");
301         require(owners[prevOwner] == oldOwner, "Invalid prevOwner, owner pair provided");
302         owners[newOwner] = owners[oldOwner];
303         owners[prevOwner] = newOwner;
304         owners[oldOwner] = 0;
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
337         return owners[owner] != 0;
338     }
339 
340     /// @dev Returns array of owners.
341     /// @return Array of Safe owners.
342     function getOwners()
343         public
344         view
345         returns (address[])
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
368     function setupSafe(address[] _owners, uint256 _threshold, address to, bytes data)
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
389         require(_masterCopy != 0, "Invalid master copy address provided");
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
408         require(address(manager) == 0, "Manager has already been set");
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
421         bytes messageSignature,
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
435     /// @dev divides bytes signature into `uint8 v, bytes32 r, bytes32 s`
436     /// @param pos which signature to read
437     /// @param signatures concatenated rsv signatures
438     function signatureSplit(bytes signatures, uint256 pos)
439         internal
440         pure
441         returns (uint8 v, bytes32 r, bytes32 s)
442     {
443         // The signature format is a compact form of:
444         //   {bytes32 r}{bytes32 s}{uint8 v}
445         // Compact means, uint8 is not padded to 32 bytes.
446         // solium-disable-next-line security/no-inline-assembly
447         assembly {
448             let signaturePos := mul(0x41, pos)
449             r := mload(add(signatures, add(signaturePos, 0x20)))
450             s := mload(add(signatures, add(signaturePos, 0x40)))
451             // Here we are loading the last 32 bytes, including 31 bytes
452             // of 's'. There is no 'mload8' to do this.
453             //
454             // 'byte' is not working due to the Solidity parser, so lets
455             // use the second best option, 'and'
456             v := and(mload(add(signatures, add(signaturePos, 0x41))), 0xff)
457         }
458     }
459 }
460 
461 contract ISignatureValidator {
462     /**
463     * @dev Should return whether the signature provided is valid for the provided data
464     * @param _data Arbitrary length data signed on the behalf of address(this)
465     * @param _signature Signature byte array associated with _data
466     *
467     * MUST return a bool upon valid or invalid signature with corresponding _data
468     * MUST take (bytes, bytes) as arguments
469     */ 
470     function isValidSignature(
471         bytes _data, 
472         bytes _signature)
473         public
474         returns (bool isValid); 
475 }
476 
477 contract GnosisSafe is MasterCopy, BaseSafe, SignatureDecoder, SecuredTokenTransfer, ISignatureValidator {
478 
479     string public constant NAME = "Gnosis Safe";
480     string public constant VERSION = "0.0.2";
481 
482     //keccak256(
483     //    "EIP712Domain(address verifyingContract)"
484     //);
485     bytes32 public constant DOMAIN_SEPARATOR_TYPEHASH = 0x035aff83d86937d35b32e04f0ddc6ff469290eef2f1b692d8a815c89404d4749;
486 
487     //keccak256(
488     //    "SafeTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 dataGas,uint256 gasPrice,address gasToken,address refundReceiver,uint256 nonce)"
489     //);
490     bytes32 public constant SAFE_TX_TYPEHASH = 0x14d461bc7412367e924637b363c7bf29b8f47e2f84869f4426e5633d8af47b20;
491 
492     //keccak256(
493     //    "SafeMessage(bytes message)"
494     //);
495     bytes32 public constant SAFE_MSG_TYPEHASH = 0x60b3cbf8b4a223d68d641b3b6ddf9a298e7f33710cf3d3a9d1146b5a6150fbca;
496 
497     event ExecutionFailed(bytes32 txHash);
498 
499     uint256 public nonce;
500     bytes32 public domainSeparator;
501     // Mapping to keep track of all message hashes that have been approve by ALL REQUIRED owners
502     mapping(bytes32 => uint256) public signedMessages;
503     // Mapping to keep track of all hashes (message or transaction) that have been approve by ANY owners
504     mapping(address => mapping(bytes32 => uint256)) public approvedHashes;
505 
506     /// @dev Setup function sets initial storage of contract.
507     /// @param _owners List of Safe owners.
508     /// @param _threshold Number of required confirmations for a Safe transaction.
509     /// @param to Contract address for optional delegate call.
510     /// @param data Data payload for optional delegate call.
511     function setup(address[] _owners, uint256 _threshold, address to, bytes data)
512         public
513     {
514         require(domainSeparator == 0, "Domain Separator already set!");
515         domainSeparator = keccak256(abi.encode(DOMAIN_SEPARATOR_TYPEHASH, this));
516         setupSafe(_owners, _threshold, to, data);
517     }
518 
519     /// @dev Allows to execute a Safe transaction confirmed by required number of owners and then pays the account that submitted the transaction.
520     ///      Note: The fees are always transfered, even if the user transaction fails.
521     /// @param to Destination address of Safe transaction.
522     /// @param value Ether value of Safe transaction.
523     /// @param data Data payload of Safe transaction.
524     /// @param operation Operation type of Safe transaction.
525     /// @param safeTxGas Gas that should be used for the Safe transaction.
526     /// @param dataGas Gas costs for data used to trigger the safe transaction and to pay the payment transfer
527     /// @param gasPrice Gas price that should be used for the payment calculation.
528     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
529     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
530     /// @param signatures Packed signature data ({bytes32 r}{bytes32 s}{uint8 v})
531     function execTransaction(
532         address to,
533         uint256 value,
534         bytes data,
535         Enum.Operation operation,
536         uint256 safeTxGas,
537         uint256 dataGas,
538         uint256 gasPrice,
539         address gasToken,
540         address refundReceiver,
541         bytes signatures
542     )
543         public
544         returns (bool success)
545     {
546         uint256 startGas = gasleft();
547         bytes memory txHashData = encodeTransactionData(
548             to, value, data, operation, // Transaction info
549             safeTxGas, dataGas, gasPrice, gasToken, refundReceiver, // Payment info
550             nonce
551         );
552         require(checkSignatures(keccak256(txHashData), txHashData, signatures, true), "Invalid signatures provided");
553         // Increase nonce and execute transaction.
554         nonce++;
555         require(gasleft() >= safeTxGas, "Not enough gas to execute safe transaction");
556         // If no safeTxGas has been set and the gasPrice is 0 we assume that all available gas can be used
557         success = execute(to, value, data, operation, safeTxGas == 0 && gasPrice == 0 ? gasleft() : safeTxGas);
558         if (!success) {
559             emit ExecutionFailed(keccak256(txHashData));
560         }
561 
562         // We transfer the calculated tx costs to the tx.origin to avoid sending it to intermediate contracts that have made calls
563         if (gasPrice > 0) {
564             handlePayment(startGas, dataGas, gasPrice, gasToken, refundReceiver);
565         }
566     }
567 
568     function handlePayment(
569         uint256 gasUsed,
570         uint256 dataGas,
571         uint256 gasPrice,
572         address gasToken,
573         address refundReceiver
574     )
575         private
576     {
577         uint256 amount = ((gasUsed - gasleft()) + dataGas) * gasPrice;
578         // solium-disable-next-line security/no-tx-origin
579         address receiver = refundReceiver == address(0) ? tx.origin : refundReceiver;
580         if (gasToken == address(0)) {
581                 // solium-disable-next-line security/no-send
582             require(receiver.send(amount), "Could not pay gas costs with ether");
583         } else {
584             require(transferToken(gasToken, receiver, amount), "Could not pay gas costs with token");
585         }
586     }
587 
588     /**
589     * @dev Should return whether the signature provided is valid for the provided data, hash
590     * @param dataHash Hash of the data (could be either a message hash or transaction hash)
591     * @param data That should be signed (this is passed to an external validator contract)
592     * @param signatures Signature data that should be verified. Can be ECDSA signature, contract signature (EIP-1271) or approved hash.
593     * @param consumeHash Indicates that in case of an approved hash the storage can be freed to save gas
594     * @return a bool upon valid or invalid signature with corresponding _data
595     */
596     function checkSignatures(bytes32 dataHash, bytes data, bytes signatures, bool consumeHash)
597         internal
598         returns (bool)
599     {
600         // Check that the provided signature data is not too short
601         if (signatures.length < threshold * 65) {
602             return false;
603         }
604         // There cannot be an owner with address 0.
605         address lastOwner = address(0);
606         address currentOwner;
607         uint8 v;
608         bytes32 r;
609         bytes32 s;
610         uint256 i;
611         for (i = 0; i < threshold; i++) {
612             (v, r, s) = signatureSplit(signatures, i);
613             // If v is 0 then it is a contract signature
614             if (v == 0) {
615                 // When handling contract signatures the address of the contract is encoded into r
616                 currentOwner = address(r);
617                 bytes memory contractSignature;
618                 // solium-disable-next-line security/no-inline-assembly
619                 assembly {
620                     // The signature data for contract signatures is appended to the concatenated signatures and the offset is stored in s
621                     contractSignature := add(add(signatures, s), 0x20)
622                 }
623                 if (!ISignatureValidator(currentOwner).isValidSignature(data, contractSignature)) {
624                     return false;
625                 }
626             // If v is 1 then it is an approved hash
627             } else if (v == 1) {
628                 // When handling approved hashes the address of the approver is encoded into r
629                 currentOwner = address(r);
630                 // Hashes are automatically approved by the sender of the message or when they have been pre-approved via a separate transaction
631                 if (msg.sender != currentOwner && approvedHashes[currentOwner][dataHash] == 0) {
632                     return false;
633                 }
634                 // Hash has been marked for consumption. If this hash was pre-approved free storage
635                 if (consumeHash && msg.sender != currentOwner) {
636                     approvedHashes[currentOwner][dataHash] = 0;
637                 }
638             } else {
639                 // Use ecrecover with the messageHash for EOA signatures
640                 currentOwner = ecrecover(dataHash, v, r, s);
641             }
642             if (currentOwner <= lastOwner || owners[currentOwner] == 0) {
643                 return false;
644             }
645             lastOwner = currentOwner;
646         }
647         return true;
648     }
649 
650     /// @dev Allows to estimate a Safe transaction.
651     ///      This method is only meant for estimation purpose, therfore two different protection mechanism against execution in a transaction have been made:
652     ///      1.) The method can only be called from the safe itself
653     ///      2.) The response is returned with a revert
654     ///      When estimating set `from` to the address of the safe.
655     ///      Since the `estimateGas` function includes refunds, call this method to get an estimated of the costs that are deducted from the safe with `execTransaction`
656     /// @param to Destination address of Safe transaction.
657     /// @param value Ether value of Safe transaction.
658     /// @param data Data payload of Safe transaction.
659     /// @param operation Operation type of Safe transaction.
660     /// @return Estimate without refunds and overhead fees (base transaction and payload data gas costs).
661     function requiredTxGas(address to, uint256 value, bytes data, Enum.Operation operation)
662         public
663         authorized
664         returns (uint256)
665     {
666         uint256 startGas = gasleft();
667         // We don't provide an error message here, as we use it to return the estimate
668         // solium-disable-next-line error-reason
669         require(execute(to, value, data, operation, gasleft()));
670         uint256 requiredGas = startGas - gasleft();
671         // Convert response to string and return via error message
672         revert(string(abi.encodePacked(requiredGas)));
673     }
674 
675     /**
676     * @dev Marks a hash as approved. This can be used to validate a hash that is used by a signature.
677     * @param hashToApprove The hash that should be marked as approved for signatures that are verified by this contract.
678     */
679     function approveHash(bytes32 hashToApprove)
680         public
681     {
682         require(owners[msg.sender] != 0, "Only owners can approve a hash");
683         approvedHashes[msg.sender][hashToApprove] = 1;
684     }
685 
686     /**
687     * @dev Marks a message as signed
688     * @param _data Arbitrary length data that should be marked as signed on the behalf of address(this)
689     */
690     function signMessage(bytes _data)
691         public
692         authorized
693     {
694         signedMessages[getMessageHash(_data)] = 1;
695     }
696 
697     /**
698     * @dev Should return whether the signature provided is valid for the provided data
699     * @param _data Arbitrary length data signed on the behalf of address(this)
700     * @param _signature Signature byte array associated with _data
701     * @return a bool upon valid or invalid signature with corresponding _data
702     */
703     function isValidSignature(bytes _data, bytes _signature)
704         public
705         returns (bool isValid)
706     {
707         bytes32 messageHash = getMessageHash(_data);
708         if (_signature.length == 0) {
709             isValid = signedMessages[messageHash] != 0;
710         } else {
711             // consumeHash needs to be false, as the state should not be changed
712             isValid = checkSignatures(messageHash, _data, _signature, false);
713         }
714     }
715 
716     /// @dev Returns hash of a message that can be signed by owners.
717     /// @param message Message that should be hashed
718     /// @return Message hash.
719     function getMessageHash(
720         bytes message
721     )
722         public
723         view
724         returns (bytes32)
725     {
726         bytes32 safeMessageHash = keccak256(
727             abi.encode(SAFE_MSG_TYPEHASH, keccak256(message))
728         );
729         return keccak256(
730             abi.encodePacked(byte(0x19), byte(1), domainSeparator, safeMessageHash)
731         );
732     }
733 
734     /// @dev Returns the bytes that are hashed to be signed by owners.
735     /// @param to Destination address.
736     /// @param value Ether value.
737     /// @param data Data payload.
738     /// @param operation Operation type.
739     /// @param safeTxGas Fas that should be used for the safe transaction.
740     /// @param dataGas Gas costs for data used to trigger the safe transaction.
741     /// @param gasPrice Maximum gas price that should be used for this transaction.
742     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
743     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
744     /// @param _nonce Transaction nonce.
745     /// @return Transaction hash bytes.
746     function encodeTransactionData(
747         address to,
748         uint256 value,
749         bytes data,
750         Enum.Operation operation,
751         uint256 safeTxGas,
752         uint256 dataGas,
753         uint256 gasPrice,
754         address gasToken,
755         address refundReceiver,
756         uint256 _nonce
757     )
758         public
759         view
760         returns (bytes)
761     {
762         bytes32 safeTxHash = keccak256(
763             abi.encode(SAFE_TX_TYPEHASH, to, value, keccak256(data), operation, safeTxGas, dataGas, gasPrice, gasToken, refundReceiver, _nonce)
764         );
765         return abi.encodePacked(byte(0x19), byte(1), domainSeparator, safeTxHash);
766     }
767 
768     /// @dev Returns hash to be signed by owners.
769     /// @param to Destination address.
770     /// @param value Ether value.
771     /// @param data Data payload.
772     /// @param operation Operation type.
773     /// @param safeTxGas Fas that should be used for the safe transaction.
774     /// @param dataGas Gas costs for data used to trigger the safe transaction.
775     /// @param gasPrice Maximum gas price that should be used for this transaction.
776     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
777     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
778     /// @param _nonce Transaction nonce.
779     /// @return Transaction hash.
780     function getTransactionHash(
781         address to,
782         uint256 value,
783         bytes data,
784         Enum.Operation operation,
785         uint256 safeTxGas,
786         uint256 dataGas,
787         uint256 gasPrice,
788         address gasToken,
789         address refundReceiver,
790         uint256 _nonce
791     )
792         public
793         view
794         returns (bytes32)
795     {
796         return keccak256(encodeTransactionData(to, value, data, operation, safeTxGas, dataGas, gasPrice, gasToken, refundReceiver, _nonce));
797     }
798 }