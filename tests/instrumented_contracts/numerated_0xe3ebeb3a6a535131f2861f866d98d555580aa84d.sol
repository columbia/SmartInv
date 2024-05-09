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
168         require(modules[msg.sender] != address(0), "Method can only be called from an enabled module");
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
337         return owners[owner] != address(0);
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
435     /// @dev divides bytes signature into `uint8 v, bytes32 r, bytes32 s`
436     /// @param pos which signature to read
437     /// @param signatures concatenated rsv signatures
438     function signatureSplit(bytes memory signatures, uint256 pos)
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
461 library SafeMath {
462 
463   /**
464   * @dev Multiplies two numbers, reverts on overflow.
465   */
466   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
467     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
468     // benefit is lost if 'b' is also tested.
469     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
470     if (a == 0) {
471       return 0;
472     }
473 
474     uint256 c = a * b;
475     require(c / a == b);
476 
477     return c;
478   }
479 
480   /**
481   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
482   */
483   function div(uint256 a, uint256 b) internal pure returns (uint256) {
484     require(b > 0); // Solidity only automatically asserts when dividing by 0
485     uint256 c = a / b;
486     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
487 
488     return c;
489   }
490 
491   /**
492   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
493   */
494   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
495     require(b <= a);
496     uint256 c = a - b;
497 
498     return c;
499   }
500 
501   /**
502   * @dev Adds two numbers, reverts on overflow.
503   */
504   function add(uint256 a, uint256 b) internal pure returns (uint256) {
505     uint256 c = a + b;
506     require(c >= a);
507 
508     return c;
509   }
510 
511   /**
512   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
513   * reverts when dividing by zero.
514   */
515   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
516     require(b != 0);
517     return a % b;
518   }
519 }
520 
521 contract ISignatureValidator {
522     /**
523     * @dev Should return whether the signature provided is valid for the provided data
524     * @param _data Arbitrary length data signed on the behalf of address(this)
525     * @param _signature Signature byte array associated with _data
526     *
527     * MUST return a bool upon valid or invalid signature with corresponding _data
528     * MUST take (bytes, bytes) as arguments
529     */ 
530     function isValidSignature(
531         bytes calldata _data, 
532         bytes calldata _signature)
533         external
534         returns (bool isValid) {}
535 }
536 
537 contract GnosisSafe is MasterCopy, BaseSafe, SignatureDecoder, SecuredTokenTransfer, ISignatureValidator {
538 
539     using SafeMath for uint256;
540 
541     string public constant NAME = "Gnosis Safe";
542     string public constant VERSION = "0.1.0";
543 
544     //keccak256(
545     //    "EIP712Domain(address verifyingContract)"
546     //);
547     bytes32 public constant DOMAIN_SEPARATOR_TYPEHASH = 0x035aff83d86937d35b32e04f0ddc6ff469290eef2f1b692d8a815c89404d4749;
548 
549     //keccak256(
550     //    "SafeTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 dataGas,uint256 gasPrice,address gasToken,address refundReceiver,uint256 nonce)"
551     //);
552     bytes32 public constant SAFE_TX_TYPEHASH = 0x14d461bc7412367e924637b363c7bf29b8f47e2f84869f4426e5633d8af47b20;
553 
554     //keccak256(
555     //    "SafeMessage(bytes message)"
556     //);
557     bytes32 public constant SAFE_MSG_TYPEHASH = 0x60b3cbf8b4a223d68d641b3b6ddf9a298e7f33710cf3d3a9d1146b5a6150fbca;
558 
559     event ExecutionFailed(bytes32 txHash);
560 
561     uint256 public nonce;
562     bytes32 public domainSeparator;
563     // Mapping to keep track of all message hashes that have been approve by ALL REQUIRED owners
564     mapping(bytes32 => uint256) public signedMessages;
565     // Mapping to keep track of all hashes (message or transaction) that have been approve by ANY owners
566     mapping(address => mapping(bytes32 => uint256)) public approvedHashes;
567 
568     /// @dev Setup function sets initial storage of contract.
569     /// @param _owners List of Safe owners.
570     /// @param _threshold Number of required confirmations for a Safe transaction.
571     /// @param to Contract address for optional delegate call.
572     /// @param data Data payload for optional delegate call.
573     function setup(address[] calldata _owners, uint256 _threshold, address to, bytes calldata data)
574         external
575     {
576         require(domainSeparator == 0, "Domain Separator already set!");
577         domainSeparator = keccak256(abi.encode(DOMAIN_SEPARATOR_TYPEHASH, this));
578         setupSafe(_owners, _threshold, to, data);
579     }
580 
581     /// @dev Allows to execute a Safe transaction confirmed by required number of owners and then pays the account that submitted the transaction.
582     ///      Note: The fees are always transfered, even if the user transaction fails.
583     /// @param to Destination address of Safe transaction.
584     /// @param value Ether value of Safe transaction.
585     /// @param data Data payload of Safe transaction.
586     /// @param operation Operation type of Safe transaction.
587     /// @param safeTxGas Gas that should be used for the Safe transaction.
588     /// @param dataGas Gas costs for data used to trigger the safe transaction and to pay the payment transfer
589     /// @param gasPrice Gas price that should be used for the payment calculation.
590     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
591     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
592     /// @param signatures Packed signature data ({bytes32 r}{bytes32 s}{uint8 v})
593     function execTransaction(
594         address to,
595         uint256 value,
596         bytes calldata data,
597         Enum.Operation operation,
598         uint256 safeTxGas,
599         uint256 dataGas,
600         uint256 gasPrice,
601         address gasToken,
602         address payable refundReceiver,
603         bytes calldata signatures
604     )
605         external
606         returns (bool success)
607     {
608         uint256 startGas = gasleft();
609         bytes memory txHashData = encodeTransactionData(
610             to, value, data, operation, // Transaction info
611             safeTxGas, dataGas, gasPrice, gasToken, refundReceiver, // Payment info
612             nonce
613         );
614         require(checkSignatures(keccak256(txHashData), txHashData, signatures, true), "Invalid signatures provided");
615         // Increase nonce and execute transaction.
616         nonce++;
617         require(gasleft() >= safeTxGas, "Not enough gas to execute safe transaction");
618         // If no safeTxGas has been set and the gasPrice is 0 we assume that all available gas can be used
619         success = execute(to, value, data, operation, safeTxGas == 0 && gasPrice == 0 ? gasleft() : safeTxGas);
620         if (!success) {
621             emit ExecutionFailed(keccak256(txHashData));
622         }
623 
624         // We transfer the calculated tx costs to the tx.origin to avoid sending it to intermediate contracts that have made calls
625         if (gasPrice > 0) {
626             handlePayment(startGas, dataGas, gasPrice, gasToken, refundReceiver);
627         }
628     }
629 
630     function handlePayment(
631         uint256 startGas,
632         uint256 dataGas,
633         uint256 gasPrice,
634         address gasToken,
635         address payable refundReceiver
636     )
637         private
638     {
639         uint256 amount = startGas.sub(gasleft()).add(dataGas).mul(gasPrice);
640         // solium-disable-next-line security/no-tx-origin
641         address payable receiver = refundReceiver == address(0) ? tx.origin : refundReceiver;
642         if (gasToken == address(0)) {
643             // solium-disable-next-line security/no-send
644             require(receiver.send(amount), "Could not pay gas costs with ether");
645         } else {
646             require(transferToken(gasToken, receiver, amount), "Could not pay gas costs with token");
647         }
648     }
649 
650     /**
651     * @dev Should return whether the signature provided is valid for the provided data, hash
652     * @param dataHash Hash of the data (could be either a message hash or transaction hash)
653     * @param data That should be signed (this is passed to an external validator contract)
654     * @param signatures Signature data that should be verified. Can be ECDSA signature, contract signature (EIP-1271) or approved hash.
655     * @param consumeHash Indicates that in case of an approved hash the storage can be freed to save gas
656     * @return a bool upon valid or invalid signature with corresponding _data
657     */
658     function checkSignatures(bytes32 dataHash, bytes memory data, bytes memory signatures, bool consumeHash)
659         internal
660         returns (bool)
661     {
662         // Check that the provided signature data is not too short
663         if (signatures.length < threshold * 65) {
664             return false;
665         }
666         // There cannot be an owner with address 0.
667         address lastOwner = address(0);
668         address currentOwner;
669         uint8 v;
670         bytes32 r;
671         bytes32 s;
672         uint256 i;
673         for (i = 0; i < threshold; i++) {
674             (v, r, s) = signatureSplit(signatures, i);
675             // If v is 0 then it is a contract signature
676             if (v == 0) {
677                 // When handling contract signatures the address of the contract is encoded into r
678                 currentOwner = address(uint256(r));
679                 bytes memory contractSignature;
680                 // solium-disable-next-line security/no-inline-assembly
681                 assembly {
682                     // The signature data for contract signatures is appended to the concatenated signatures and the offset is stored in s
683                     contractSignature := add(add(signatures, s), 0x20)
684                 }
685                 if (!ISignatureValidator(currentOwner).isValidSignature(data, contractSignature)) {
686                     return false;
687                 }
688             // If v is 1 then it is an approved hash
689             } else if (v == 1) {
690                 // When handling approved hashes the address of the approver is encoded into r
691                 currentOwner = address(uint256(r));
692                 // Hashes are automatically approved by the sender of the message or when they have been pre-approved via a separate transaction
693                 if (msg.sender != currentOwner && approvedHashes[currentOwner][dataHash] == 0) {
694                     return false;
695                 }
696                 // Hash has been marked for consumption. If this hash was pre-approved free storage
697                 if (consumeHash && msg.sender != currentOwner) {
698                     approvedHashes[currentOwner][dataHash] = 0;
699                 }
700             } else {
701                 // Use ecrecover with the messageHash for EOA signatures
702                 currentOwner = ecrecover(dataHash, v, r, s);
703             }
704             if (currentOwner <= lastOwner || owners[currentOwner] == address(0)) {
705                 return false;
706             }
707             lastOwner = currentOwner;
708         }
709         return true;
710     }
711 
712     /// @dev Allows to estimate a Safe transaction.
713     ///      This method is only meant for estimation purpose, therfore two different protection mechanism against execution in a transaction have been made:
714     ///      1.) The method can only be called from the safe itself
715     ///      2.) The response is returned with a revert
716     ///      When estimating set `from` to the address of the safe.
717     ///      Since the `estimateGas` function includes refunds, call this method to get an estimated of the costs that are deducted from the safe with `execTransaction`
718     /// @param to Destination address of Safe transaction.
719     /// @param value Ether value of Safe transaction.
720     /// @param data Data payload of Safe transaction.
721     /// @param operation Operation type of Safe transaction.
722     /// @return Estimate without refunds and overhead fees (base transaction and payload data gas costs).
723     function requiredTxGas(address to, uint256 value, bytes calldata data, Enum.Operation operation)
724         external
725         authorized
726         returns (uint256)
727     {
728         uint256 startGas = gasleft();
729         // We don't provide an error message here, as we use it to return the estimate
730         // solium-disable-next-line error-reason
731         require(execute(to, value, data, operation, gasleft()));
732         uint256 requiredGas = startGas - gasleft();
733         // Convert response to string and return via error message
734         revert(string(abi.encodePacked(requiredGas)));
735     }
736 
737     /**
738     * @dev Marks a hash as approved. This can be used to validate a hash that is used by a signature.
739     * @param hashToApprove The hash that should be marked as approved for signatures that are verified by this contract.
740     */
741     function approveHash(bytes32 hashToApprove)
742         external
743     {
744         require(owners[msg.sender] != address(0), "Only owners can approve a hash");
745         approvedHashes[msg.sender][hashToApprove] = 1;
746     }
747 
748     /**
749     * @dev Marks a message as signed
750     * @param _data Arbitrary length data that should be marked as signed on the behalf of address(this)
751     */ 
752     function signMessage(bytes calldata _data) 
753         external
754         authorized
755     {
756         signedMessages[getMessageHash(_data)] = 1;
757     }
758 
759     /**
760     * @dev Should return whether the signature provided is valid for the provided data
761     * @param _data Arbitrary length data signed on the behalf of address(this)
762     * @param _signature Signature byte array associated with _data
763     * @return a bool upon valid or invalid signature with corresponding _data
764     */ 
765     function isValidSignature(bytes calldata _data, bytes calldata _signature)
766         external
767         returns (bool isValid)
768     {
769         bytes32 messageHash = getMessageHash(_data);
770         if (_signature.length == 0) {
771             isValid = signedMessages[messageHash] != 0;
772         } else {
773             // consumeHash needs to be false, as the state should not be changed
774             isValid = checkSignatures(messageHash, _data, _signature, false);
775         }
776     }
777 
778     /// @dev Returns hash of a message that can be signed by owners.
779     /// @param message Message that should be hashed
780     /// @return Message hash.
781     function getMessageHash(
782         bytes memory message
783     )
784         public
785         view
786         returns (bytes32)
787     {
788         bytes32 safeMessageHash = keccak256(
789             abi.encode(SAFE_MSG_TYPEHASH, keccak256(message))
790         );
791         return keccak256(
792             abi.encodePacked(byte(0x19), byte(0x01), domainSeparator, safeMessageHash)
793         );
794     }
795 
796     /// @dev Returns the bytes that are hashed to be signed by owners.
797     /// @param to Destination address.
798     /// @param value Ether value.
799     /// @param data Data payload.
800     /// @param operation Operation type.
801     /// @param safeTxGas Fas that should be used for the safe transaction.
802     /// @param dataGas Gas costs for data used to trigger the safe transaction.
803     /// @param gasPrice Maximum gas price that should be used for this transaction.
804     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
805     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
806     /// @param _nonce Transaction nonce.
807     /// @return Transaction hash bytes.
808     function encodeTransactionData(
809         address to, 
810         uint256 value, 
811         bytes memory data, 
812         Enum.Operation operation, 
813         uint256 safeTxGas, 
814         uint256 dataGas, 
815         uint256 gasPrice,
816         address gasToken,
817         address refundReceiver,
818         uint256 _nonce
819     )
820         public
821         view
822         returns (bytes memory)
823     {
824         bytes32 safeTxHash = keccak256(
825             abi.encode(SAFE_TX_TYPEHASH, to, value, keccak256(data), operation, safeTxGas, dataGas, gasPrice, gasToken, refundReceiver, _nonce)
826         );
827         return abi.encodePacked(byte(0x19), byte(0x01), domainSeparator, safeTxHash);
828     }
829 
830     /// @dev Returns hash to be signed by owners.
831     /// @param to Destination address.
832     /// @param value Ether value.
833     /// @param data Data payload.
834     /// @param operation Operation type.
835     /// @param safeTxGas Fas that should be used for the safe transaction.
836     /// @param dataGas Gas costs for data used to trigger the safe transaction.
837     /// @param gasPrice Maximum gas price that should be used for this transaction.
838     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
839     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
840     /// @param _nonce Transaction nonce.
841     /// @return Transaction hash.
842     function getTransactionHash(
843         address to, 
844         uint256 value, 
845         bytes memory data, 
846         Enum.Operation operation, 
847         uint256 safeTxGas, 
848         uint256 dataGas, 
849         uint256 gasPrice,
850         address gasToken,
851         address refundReceiver,
852         uint256 _nonce
853     )
854         public
855         view
856         returns (bytes32)
857     {
858         return keccak256(encodeTransactionData(to, value, data, operation, safeTxGas, dataGas, gasPrice, gasToken, refundReceiver, _nonce));
859     }
860 }
861 
862 /// @title DutchX Base Module - Expose a set of methods to enable a Safe to interact with a DX
863 /// @author Denis Granha - <denis@gnosis.pm>
864 contract DutchXBaseModule is Module {
865 
866     address public dutchXAddress;
867     // isWhitelistedToken mapping maps destination address to boolean.
868     mapping (address => bool) public isWhitelistedToken;
869     mapping (address => bool) public isOperator;
870 
871     // helper variables used by the CLI
872     address[] public whitelistedTokens; 
873     address[] public whitelistedOperators;
874 
875     /// @dev Setup function sets initial storage of contract.
876     /// @param dx DutchX Proxy Address.
877     /// @param tokens List of whitelisted tokens.
878     /// @param operators List of addresses that can operate the module.
879     /// @param _manager Address of the manager, the safe contract.
880     function setup(address dx, address[] memory tokens, address[] memory operators, address payable _manager)
881         public
882     {
883         require(address(manager) == address(0), "Manager has already been set");
884         if (_manager == address(0)){
885             manager = ModuleManager(msg.sender);
886         }
887         else{
888             manager = ModuleManager(_manager);
889         }
890 
891         dutchXAddress = dx;
892 
893         for (uint256 i = 0; i < tokens.length; i++) {
894             address token = tokens[i];
895             require(token != address(0), "Invalid token provided");
896             isWhitelistedToken[token] = true;
897         }
898 
899         whitelistedTokens = tokens;
900 
901         for (uint256 i = 0; i < operators.length; i++) {
902             address operator = operators[i];
903             require(operator != address(0), "Invalid operator address provided");
904             isOperator[operator] = true;
905         }
906 
907         whitelistedOperators = operators;
908     }
909 
910     /// @dev Allows to add token to whitelist. This can only be done via a Safe transaction.
911     /// @param token ERC20 token address.
912     function addToWhitelist(address token)
913         public
914         authorized
915     {
916         require(token != address(0), "Invalid token provided");
917         require(!isWhitelistedToken[token], "Token is already whitelisted");
918         isWhitelistedToken[token] = true;
919         whitelistedTokens.push(token);
920     }
921 
922     /// @dev Allows to remove token from whitelist. This can only be done via a Safe transaction.
923     /// @param token ERC20 token address.
924     function removeFromWhitelist(address token)
925         public
926         authorized
927     {
928         require(isWhitelistedToken[token], "Token is not whitelisted");
929         isWhitelistedToken[token] = false;
930 
931         for (uint i = 0; i<whitelistedTokens.length - 1; i++)
932             if(whitelistedTokens[i] == token){
933                 whitelistedTokens[i] = whitelistedTokens[whitelistedTokens.length-1];
934                 break;
935             }
936         whitelistedTokens.length -= 1;
937     }
938 
939     /// @dev Allows to add operator to whitelist. This can only be done via a Safe transaction.
940     /// @param operator ethereum address.
941     function addOperator(address operator)
942         public
943         authorized
944     {
945         require(operator != address(0), "Invalid address provided");
946         require(!isOperator[operator], "Operator is already whitelisted");
947         isOperator[operator] = true;
948         whitelistedOperators.push(operator);
949     }
950 
951     /// @dev Allows to remove operator from whitelist. This can only be done via a Safe transaction.
952     /// @param operator ethereum address.
953     function removeOperator(address operator)
954         public
955         authorized
956     {
957         require(isOperator[operator], "Operator is not whitelisted");
958         isOperator[operator] = false;
959 
960         for (uint i = 0; i<whitelistedOperators.length - 1; i++)
961             if(whitelistedOperators[i] == operator){
962                 whitelistedOperators[i] = whitelistedOperators[whitelistedOperators.length-1];
963                 break;
964             }
965         whitelistedOperators.length -= 1;
966 
967     }
968 
969     /// @dev Allows to change DutchX Proxy contract address. This can only be done via a Safe transaction.
970     /// @param dx New proxy contract address for DutchX.
971     function changeDXProxy(address dx)
972         public
973         authorized
974     {
975         require(dx != address(0), "Invalid address provided");
976         dutchXAddress = dx;
977     }
978 
979     /// @dev Abstract method. Returns if Safe transaction is to DutchX contract and with whitelisted tokens.
980     /// @param to Dutch X address or Whitelisted token (only for approve operations for DX).
981     /// @param value Not checked.
982     /// @param data Allowed operations
983     /// @return Returns if transaction can be executed.
984     function executeWhitelisted(address to, uint256 value, bytes memory data)
985         public
986         returns (bool);
987 
988 
989     /// @dev Returns list of whitelisted tokens.
990     /// @return List of whitelisted tokens addresses.
991     function getWhitelistedTokens()
992         public
993         view
994         returns (address[] memory)
995     {
996         return whitelistedTokens;
997     }
998 
999     /// @dev Returns list of whitelisted operators.
1000     /// @return List of whitelisted operators addresses.
1001     function getWhitelistedOperators()
1002         public
1003         view
1004         returns (address[] memory)
1005     {
1006         return whitelistedOperators;
1007     }
1008 }
1009 
1010 // @title DutchX Token Interface - Represents the allowed methods of ERC20 token contracts to be executed from the safe module DutchXModule
1011 /// @author Denis Granha - <denis@gnosis.pm>
1012 interface DutchXTokenInterface {
1013 	function transfer(address to, uint value) external;
1014     function approve(address spender, uint amount) external;
1015     function deposit() external payable;
1016     function withdraw() external;
1017 }
1018 
1019 // @title DutchX Interface - Represents the allowed methods to be executed from the safe module DutchXModule
1020 /// @author Denis Granha - <denis@gnosis.pm>
1021 interface DutchXInterface {
1022 	function deposit(address token, uint256 amount) external;
1023     function postSellOrder(address sellToken, address buyToken, uint256 auctionIndex, uint256 amount) external;
1024     function postBuyOrder(address sellToken, address buyToken, uint256 auctionIndex, uint256 amount) external;
1025 
1026     function claimTokensFromSeveralAuctionsAsBuyer(
1027         address[] calldata auctionSellTokens, 
1028         address[] calldata auctionBuyTokens,
1029         uint[] calldata auctionIndices, 
1030         address user
1031     ) external;
1032 
1033     function claimTokensFromSeveralAuctionsAsSeller(
1034         address[] calldata auctionSellTokens,
1035         address[] calldata auctionBuyTokens,
1036         uint[] calldata auctionIndices,
1037         address user
1038     ) external;
1039 
1040     function withdraw() external;
1041 }
1042 
1043 /// @title DutchX Module - Allows to execute transactions to DutchX contract for whitelisted token pairs without confirmations and deposit tokens in the DutchX.
1044 //  differs from the Complete module in the allowed functions, it doesn't allow to perform buy operations.
1045 /// @author Denis Granha - <denis@gnosis.pm>
1046 contract DutchXSellerModule is DutchXBaseModule {
1047 
1048     string public constant NAME = "DutchX Seller Module";
1049     string public constant VERSION = "0.0.2";
1050 
1051     /// @dev Returns if Safe transaction is to DutchX contract and with whitelisted tokens.
1052     /// @param to Dutch X address or Whitelisted token (only for approve operations for DX).
1053     /// @param value Not checked.
1054     /// @param data Allowed operations (postSellOrder, postBuyOrder, claimTokensFromSeveralAuctionsAsBuyer, claimTokensFromSeveralAuctionsAsSeller, deposit).
1055     /// @return Returns if transaction can be executed.
1056     function executeWhitelisted(address to, uint256 value, bytes memory data)
1057         public
1058         returns (bool)
1059     {
1060 
1061         // Load allowed method interfaces
1062         DutchXTokenInterface tokenInterface;
1063         DutchXInterface dxInterface;
1064 
1065         // Only Safe owners are allowed to execute transactions to whitelisted accounts.
1066         require(isOperator[msg.sender], "Method can only be called by an operator");
1067 
1068         // Only DutchX Proxy and Whitelisted tokens are allowed as destination
1069         require(to == dutchXAddress || isWhitelistedToken[to], "Destination address is not allowed");
1070 
1071         // Decode data
1072         bytes4 functionIdentifier;
1073         // solium-disable-next-line security/no-inline-assembly
1074         assembly {
1075             functionIdentifier := mload(add(data, 0x20))
1076         }
1077 
1078         // Only approve tokens function and deposit (in the case of WETH) is allowed against token contracts, and DutchX proxy must be the spender (for approve)
1079         if (functionIdentifier != tokenInterface.deposit.selector){
1080             require(value == 0, "Eth transactions only allowed for wrapping ETH");
1081         }
1082 
1083         // Only these functions:
1084         // PostSellOrder, claimTokensFromSeveralAuctionsAsBuyer, claimTokensFromSeveralAuctionsAsSeller, deposit
1085         // Are allowed for the Dutch X contract
1086         if (functionIdentifier == tokenInterface.approve.selector) {
1087             uint spender;
1088             // solium-disable-next-line security/no-inline-assembly
1089             assembly {
1090                 spender := mload(add(data, 0x24))
1091             }
1092 
1093             // TODO we need abi.decodeWithSelector
1094             // approve(address spender, uint256 amount) we skip the amount
1095             // (address spender) = abi.decode(dataParams, (address));
1096 
1097             require(address(spender) == dutchXAddress, "Spender must be the DutchX Contract");
1098         } else if (functionIdentifier == dxInterface.deposit.selector) {
1099             // TODO we need abi.decodeWithSelector
1100             // deposit(address token, uint256 amount) we skip the amount
1101             // (address token) = abi.decode(data, (address));
1102 
1103             uint depositToken;
1104             // solium-disable-next-line security/no-inline-assembly
1105             assembly {
1106                 depositToken := mload(add(data, 0x24))
1107             }
1108             require (isWhitelistedToken[address(depositToken)], "Only whitelisted tokens can be deposit on the DutchX");
1109         } else if (functionIdentifier == dxInterface.postSellOrder.selector) {
1110             // TODO we need abi.decodeWithSelector
1111             // postSellOrder(address sellToken, address buyToken, uint256 auctionIndex, uint256 amount) we skip auctionIndex and amount
1112             // (address sellToken, address buyToken) = abi.decode(data, (address, address));
1113 
1114             uint sellToken;
1115             uint buyToken;
1116             // solium-disable-next-line security/no-inline-assembly
1117             assembly {
1118                 sellToken := mload(add(data, 0x24))
1119                 buyToken := mload(add(data, 0x44))
1120             }
1121             require (isWhitelistedToken[address(sellToken)] && isWhitelistedToken[address(buyToken)], "Only whitelisted tokens can be sold");
1122         } else {
1123             // Other functions different than claim and deposit are not allowed
1124             require(functionIdentifier == dxInterface.claimTokensFromSeveralAuctionsAsSeller.selector || functionIdentifier == dxInterface.claimTokensFromSeveralAuctionsAsBuyer.selector || functionIdentifier == tokenInterface.deposit.selector, "Function not allowed");
1125         }
1126 
1127         require(manager.execTransactionFromModule(to, value, data, Enum.Operation.Call), "Could not execute transaction");
1128     }
1129 }