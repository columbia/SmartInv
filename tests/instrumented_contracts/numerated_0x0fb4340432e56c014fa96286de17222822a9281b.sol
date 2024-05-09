1 
2 // File: @gnosis.pm/safe-contracts/contracts/common/Enum.sol
3 
4 pragma solidity >=0.5.0 <0.7.0;
5 
6 
7 /// @title Enum - Collection of enums
8 /// @author Richard Meissner - <richard@gnosis.pm>
9 contract Enum {
10     enum Operation {
11         Call,
12         DelegateCall
13     }
14 }
15 
16 // File: @gnosis.pm/safe-contracts/contracts/proxies/Proxy.sol
17 
18 pragma solidity >=0.5.0 <0.7.0;
19 
20 /// @title IProxy - Helper interface to access masterCopy of the Proxy on-chain
21 /// @author Richard Meissner - <richard@gnosis.io>
22 interface IProxy {
23     function masterCopy() external view returns (address);
24 }
25 
26 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
27 /// @author Stefan George - <stefan@gnosis.io>
28 /// @author Richard Meissner - <richard@gnosis.io>
29 contract Proxy {
30 
31     // masterCopy always needs to be first declared variable, to ensure that it is at the same location in the contracts to which calls are delegated.
32     // To reduce deployment costs this variable is internal and needs to be retrieved via `getStorageAt`
33     address internal masterCopy;
34 
35     /// @dev Constructor function sets address of master copy contract.
36     /// @param _masterCopy Master copy address.
37     constructor(address _masterCopy)
38         public
39     {
40         require(_masterCopy != address(0), "Invalid master copy address provided");
41         masterCopy = _masterCopy;
42     }
43 
44     /// @dev Fallback function forwards all transactions and returns all received return data.
45     function ()
46         external
47         payable
48     {
49         // solium-disable-next-line security/no-inline-assembly
50         assembly {
51             let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
52             // 0xa619486e == keccak("masterCopy()"). The value is right padded to 32-bytes with 0s
53             if eq(calldataload(0), 0xa619486e00000000000000000000000000000000000000000000000000000000) {
54                 mstore(0, masterCopy)
55                 return(0, 0x20)
56             }
57             calldatacopy(0, 0, calldatasize())
58             let success := delegatecall(gas, masterCopy, 0, calldatasize(), 0, 0)
59             returndatacopy(0, 0, returndatasize())
60             if eq(success, 0) { revert(0, returndatasize()) }
61             return(0, returndatasize())
62         }
63     }
64 }
65 
66 // File: @gnosis.pm/safe-contracts/contracts/common/SelfAuthorized.sol
67 
68 pragma solidity >=0.5.0 <0.7.0;
69 
70 
71 /// @title SelfAuthorized - authorizes current contract to perform actions
72 /// @author Richard Meissner - <richard@gnosis.pm>
73 contract SelfAuthorized {
74     modifier authorized() {
75         require(msg.sender == address(this), "Method can only be called from this contract");
76         _;
77     }
78 }
79 
80 // File: @gnosis.pm/safe-contracts/contracts/base/Executor.sol
81 
82 pragma solidity >=0.5.0 <0.7.0;
83 
84 
85 
86 /// @title Executor - A contract that can execute transactions
87 /// @author Richard Meissner - <richard@gnosis.pm>
88 contract Executor {
89 
90     event ContractCreation(address newContract);
91 
92     function execute(address to, uint256 value, bytes memory data, Enum.Operation operation, uint256 txGas)
93         internal
94         returns (bool success)
95     {
96         if (operation == Enum.Operation.Call)
97             success = executeCall(to, value, data, txGas);
98         else if (operation == Enum.Operation.DelegateCall)
99             success = executeDelegateCall(to, data, txGas);
100         else
101             success = false;
102     }
103 
104     function executeCall(address to, uint256 value, bytes memory data, uint256 txGas)
105         internal
106         returns (bool success)
107     {
108         // solium-disable-next-line security/no-inline-assembly
109         assembly {
110             success := call(txGas, to, value, add(data, 0x20), mload(data), 0, 0)
111         }
112     }
113 
114     function executeDelegateCall(address to, bytes memory data, uint256 txGas)
115         internal
116         returns (bool success)
117     {
118         // solium-disable-next-line security/no-inline-assembly
119         assembly {
120             success := delegatecall(txGas, to, add(data, 0x20), mload(data), 0, 0)
121         }
122     }
123 }
124 
125 // File: @gnosis.pm/safe-contracts/contracts/common/MasterCopy.sol
126 
127 pragma solidity >=0.5.0 <0.7.0;
128 
129 
130 
131 /// @title MasterCopy - Base for master copy contracts (should always be first super contract)
132 ///         This contract is tightly coupled to our proxy contract (see `proxies/Proxy.sol`)
133 /// @author Richard Meissner - <richard@gnosis.io>
134 contract MasterCopy is SelfAuthorized {
135 
136     event ChangedMasterCopy(address masterCopy);
137 
138   // masterCopy always needs to be first declared variable, to ensure that it is at the same location as in the Proxy contract.
139   // It should also always be ensured that the address is stored alone (uses a full word)
140     address masterCopy;
141 
142   /// @dev Allows to upgrade the contract. This can only be done via a Safe transaction.
143   /// @param _masterCopy New contract address.
144     function changeMasterCopy(address _masterCopy)
145         public
146         authorized
147     {
148         // Master copy address cannot be null.
149         require(_masterCopy != address(0), "Invalid master copy address provided");
150         masterCopy = _masterCopy;
151         emit ChangedMasterCopy(_masterCopy);
152     }
153 }
154 
155 // File: @gnosis.pm/safe-contracts/contracts/base/ModuleManager.sol
156 
157 pragma solidity >=0.5.0 <0.7.0;
158 
159 
160 
161 
162 
163 
164 /// @title Module - Base class for modules.
165 /// @author Stefan George - <stefan@gnosis.pm>
166 /// @author Richard Meissner - <richard@gnosis.pm>
167 contract Module is MasterCopy {
168 
169     ModuleManager public manager;
170 
171     modifier authorized() {
172         require(msg.sender == address(manager), "Method can only be called from manager");
173         _;
174     }
175 
176     function setManager()
177         internal
178     {
179         // manager can only be 0 at initalization of contract.
180         // Check ensures that setup function can only be called once.
181         require(address(manager) == address(0), "Manager has already been set");
182         manager = ModuleManager(msg.sender);
183     }
184 }
185 
186 /// @title Module Manager - A contract that manages modules that can execute transactions via this contract
187 /// @author Stefan George - <stefan@gnosis.pm>
188 /// @author Richard Meissner - <richard@gnosis.pm>
189 contract ModuleManager is SelfAuthorized, Executor {
190 
191     event EnabledModule(Module module);
192     event DisabledModule(Module module);
193     event ExecutionFromModuleSuccess(address indexed module);
194     event ExecutionFromModuleFailure(address indexed module);
195 
196     address public constant SENTINEL_MODULES = address(0x1);
197 
198     mapping (address => address) internal modules;
199 
200     function setupModules(address to, bytes memory data)
201         internal
202     {
203         require(modules[SENTINEL_MODULES] == address(0), "Modules have already been initialized");
204         modules[SENTINEL_MODULES] = SENTINEL_MODULES;
205         if (to != address(0))
206             // Setup has to complete successfully or transaction fails.
207             require(executeDelegateCall(to, data, gasleft()), "Could not finish initialization");
208     }
209 
210     /// @dev Allows to add a module to the whitelist.
211     ///      This can only be done via a Safe transaction.
212     /// @param module Module to be whitelisted.
213     function enableModule(Module module)
214         public
215         authorized
216     {
217         // Module address cannot be null or sentinel.
218         require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
219         // Module cannot be added twice.
220         require(modules[address(module)] == address(0), "Module has already been added");
221         modules[address(module)] = modules[SENTINEL_MODULES];
222         modules[SENTINEL_MODULES] = address(module);
223         emit EnabledModule(module);
224     }
225 
226     /// @dev Allows to remove a module from the whitelist.
227     ///      This can only be done via a Safe transaction.
228     /// @param prevModule Module that pointed to the module to be removed in the linked list
229     /// @param module Module to be removed.
230     function disableModule(Module prevModule, Module module)
231         public
232         authorized
233     {
234         // Validate module address and check that it corresponds to module index.
235         require(address(module) != address(0) && address(module) != SENTINEL_MODULES, "Invalid module address provided");
236         require(modules[address(prevModule)] == address(module), "Invalid prevModule, module pair provided");
237         modules[address(prevModule)] = modules[address(module)];
238         modules[address(module)] = address(0);
239         emit DisabledModule(module);
240     }
241 
242     /// @dev Allows a Module to execute a Safe transaction without any further confirmations.
243     /// @param to Destination address of module transaction.
244     /// @param value Ether value of module transaction.
245     /// @param data Data payload of module transaction.
246     /// @param operation Operation type of module transaction.
247     function execTransactionFromModule(address to, uint256 value, bytes memory data, Enum.Operation operation)
248         public
249         returns (bool success)
250     {
251         // Only whitelisted modules are allowed.
252         require(msg.sender != SENTINEL_MODULES && modules[msg.sender] != address(0), "Method can only be called from an enabled module");
253         // Execute transaction without further confirmations.
254         success = execute(to, value, data, operation, gasleft());
255         if (success) emit ExecutionFromModuleSuccess(msg.sender);
256         else emit ExecutionFromModuleFailure(msg.sender);
257     }
258 
259     /// @dev Allows a Module to execute a Safe transaction without any further confirmations and return data
260     /// @param to Destination address of module transaction.
261     /// @param value Ether value of module transaction.
262     /// @param data Data payload of module transaction.
263     /// @param operation Operation type of module transaction.
264     function execTransactionFromModuleReturnData(address to, uint256 value, bytes memory data, Enum.Operation operation)
265         public
266         returns (bool success, bytes memory returnData)
267     {
268         success = execTransactionFromModule(to, value, data, operation);
269         // solium-disable-next-line security/no-inline-assembly
270         assembly {
271             // Load free memory location
272             let ptr := mload(0x40)
273             // We allocate memory for the return data by setting the free memory location to
274             // current free memory location + data size + 32 bytes for data size value
275             mstore(0x40, add(ptr, add(returndatasize(), 0x20)))
276             // Store the size
277             mstore(ptr, returndatasize())
278             // Store the data
279             returndatacopy(add(ptr, 0x20), 0, returndatasize())
280             // Point the return data to the correct memory location
281             returnData := ptr
282         }
283     }
284 
285     /// @dev Returns array of modules.
286     /// @return Array of modules.
287     function getModules()
288         public
289         view
290         returns (address[] memory)
291     {
292         // Calculate module count
293         uint256 moduleCount = 0;
294         address currentModule = modules[SENTINEL_MODULES];
295         while(currentModule != SENTINEL_MODULES) {
296             currentModule = modules[currentModule];
297             moduleCount ++;
298         }
299         address[] memory array = new address[](moduleCount);
300 
301         // populate return array
302         moduleCount = 0;
303         currentModule = modules[SENTINEL_MODULES];
304         while(currentModule != SENTINEL_MODULES) {
305             array[moduleCount] = currentModule;
306             currentModule = modules[currentModule];
307             moduleCount ++;
308         }
309         return array;
310     }
311 }
312 
313 // File: @gnosis.pm/safe-contracts/contracts/base/OwnerManager.sol
314 
315 pragma solidity >=0.5.0 <0.7.0;
316 
317 
318 /// @title OwnerManager - Manages a set of owners and a threshold to perform actions.
319 /// @author Stefan George - <stefan@gnosis.pm>
320 /// @author Richard Meissner - <richard@gnosis.pm>
321 contract OwnerManager is SelfAuthorized {
322 
323     event AddedOwner(address owner);
324     event RemovedOwner(address owner);
325     event ChangedThreshold(uint256 threshold);
326 
327     address public constant SENTINEL_OWNERS = address(0x1);
328 
329     mapping(address => address) internal owners;
330     uint256 ownerCount;
331     uint256 internal threshold;
332 
333     /// @dev Setup function sets initial storage of contract.
334     /// @param _owners List of Safe owners.
335     /// @param _threshold Number of required confirmations for a Safe transaction.
336     function setupOwners(address[] memory _owners, uint256 _threshold)
337         internal
338     {
339         // Threshold can only be 0 at initialization.
340         // Check ensures that setup function can only be called once.
341         require(threshold == 0, "Owners have already been setup");
342         // Validate that threshold is smaller than number of added owners.
343         require(_threshold <= _owners.length, "Threshold cannot exceed owner count");
344         // There has to be at least one Safe owner.
345         require(_threshold >= 1, "Threshold needs to be greater than 0");
346         // Initializing Safe owners.
347         address currentOwner = SENTINEL_OWNERS;
348         for (uint256 i = 0; i < _owners.length; i++) {
349             // Owner address cannot be null.
350             address owner = _owners[i];
351             require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
352             // No duplicate owners allowed.
353             require(owners[owner] == address(0), "Duplicate owner address provided");
354             owners[currentOwner] = owner;
355             currentOwner = owner;
356         }
357         owners[currentOwner] = SENTINEL_OWNERS;
358         ownerCount = _owners.length;
359         threshold = _threshold;
360     }
361 
362     /// @dev Allows to add a new owner to the Safe and update the threshold at the same time.
363     ///      This can only be done via a Safe transaction.
364     /// @param owner New owner address.
365     /// @param _threshold New threshold.
366     function addOwnerWithThreshold(address owner, uint256 _threshold)
367         public
368         authorized
369     {
370         // Owner address cannot be null.
371         require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
372         // No duplicate owners allowed.
373         require(owners[owner] == address(0), "Address is already an owner");
374         owners[owner] = owners[SENTINEL_OWNERS];
375         owners[SENTINEL_OWNERS] = owner;
376         ownerCount++;
377         emit AddedOwner(owner);
378         // Change threshold if threshold was changed.
379         if (threshold != _threshold)
380             changeThreshold(_threshold);
381     }
382 
383     /// @dev Allows to remove an owner from the Safe and update the threshold at the same time.
384     ///      This can only be done via a Safe transaction.
385     /// @param prevOwner Owner that pointed to the owner to be removed in the linked list
386     /// @param owner Owner address to be removed.
387     /// @param _threshold New threshold.
388     function removeOwner(address prevOwner, address owner, uint256 _threshold)
389         public
390         authorized
391     {
392         // Only allow to remove an owner, if threshold can still be reached.
393         require(ownerCount - 1 >= _threshold, "New owner count needs to be larger than new threshold");
394         // Validate owner address and check that it corresponds to owner index.
395         require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
396         require(owners[prevOwner] == owner, "Invalid prevOwner, owner pair provided");
397         owners[prevOwner] = owners[owner];
398         owners[owner] = address(0);
399         ownerCount--;
400         emit RemovedOwner(owner);
401         // Change threshold if threshold was changed.
402         if (threshold != _threshold)
403             changeThreshold(_threshold);
404     }
405 
406     /// @dev Allows to swap/replace an owner from the Safe with another address.
407     ///      This can only be done via a Safe transaction.
408     /// @param prevOwner Owner that pointed to the owner to be replaced in the linked list
409     /// @param oldOwner Owner address to be replaced.
410     /// @param newOwner New owner address.
411     function swapOwner(address prevOwner, address oldOwner, address newOwner)
412         public
413         authorized
414     {
415         // Owner address cannot be null.
416         require(newOwner != address(0) && newOwner != SENTINEL_OWNERS, "Invalid owner address provided");
417         // No duplicate owners allowed.
418         require(owners[newOwner] == address(0), "Address is already an owner");
419         // Validate oldOwner address and check that it corresponds to owner index.
420         require(oldOwner != address(0) && oldOwner != SENTINEL_OWNERS, "Invalid owner address provided");
421         require(owners[prevOwner] == oldOwner, "Invalid prevOwner, owner pair provided");
422         owners[newOwner] = owners[oldOwner];
423         owners[prevOwner] = newOwner;
424         owners[oldOwner] = address(0);
425         emit RemovedOwner(oldOwner);
426         emit AddedOwner(newOwner);
427     }
428 
429     /// @dev Allows to update the number of required confirmations by Safe owners.
430     ///      This can only be done via a Safe transaction.
431     /// @param _threshold New threshold.
432     function changeThreshold(uint256 _threshold)
433         public
434         authorized
435     {
436         // Validate that threshold is smaller than number of owners.
437         require(_threshold <= ownerCount, "Threshold cannot exceed owner count");
438         // There has to be at least one Safe owner.
439         require(_threshold >= 1, "Threshold needs to be greater than 0");
440         threshold = _threshold;
441         emit ChangedThreshold(threshold);
442     }
443 
444     function getThreshold()
445         public
446         view
447         returns (uint256)
448     {
449         return threshold;
450     }
451 
452     function isOwner(address owner)
453         public
454         view
455         returns (bool)
456     {
457         return owner != SENTINEL_OWNERS && owners[owner] != address(0);
458     }
459 
460     /// @dev Returns array of owners.
461     /// @return Array of Safe owners.
462     function getOwners()
463         public
464         view
465         returns (address[] memory)
466     {
467         address[] memory array = new address[](ownerCount);
468 
469         // populate return array
470         uint256 index = 0;
471         address currentOwner = owners[SENTINEL_OWNERS];
472         while(currentOwner != SENTINEL_OWNERS) {
473             array[index] = currentOwner;
474             currentOwner = owners[currentOwner];
475             index ++;
476         }
477         return array;
478     }
479 }
480 
481 // File: @gnosis.pm/safe-contracts/contracts/base/FallbackManager.sol
482 
483 pragma solidity >=0.5.0 <0.7.0;
484 
485 
486 /// @title Fallback Manager - A contract that manages fallback calls made to this contract
487 /// @author Richard Meissner - <richard@gnosis.pm>
488 contract FallbackManager is SelfAuthorized {
489 
490     event IncomingTransaction(address from, uint256 value);
491 
492     // keccak256("fallback_manager.handler.address")
493     bytes32 internal constant FALLBACK_HANDLER_STORAGE_SLOT = 0x6c9a6c4a39284e37ed1cf53d337577d14212a4870fb976a4366c693b939918d5;
494 
495     function internalSetFallbackHandler(address handler) internal {
496         bytes32 slot = FALLBACK_HANDLER_STORAGE_SLOT;
497         // solium-disable-next-line security/no-inline-assembly
498         assembly {
499             sstore(slot, handler)
500         }
501     }
502 
503     /// @dev Allows to add a contract to handle fallback calls.
504     ///      Only fallback calls without value and with data will be forwarded.
505     ///      This can only be done via a Safe transaction.
506     /// @param handler contract to handle fallbacks calls.
507     function setFallbackHandler(address handler)
508         public
509         authorized
510     {
511         internalSetFallbackHandler(handler);
512     }
513 
514     function ()
515         external
516         payable
517     {
518         // Only calls without value and with data will be forwarded
519         if (msg.value > 0 || msg.data.length == 0) {
520             emit IncomingTransaction(msg.sender, msg.value);
521             return;
522         }
523         bytes32 slot = FALLBACK_HANDLER_STORAGE_SLOT;
524         address handler;
525         // solium-disable-next-line security/no-inline-assembly
526         assembly {
527             handler := sload(slot)
528         }
529 
530         if (handler != address(0)) {
531             // solium-disable-next-line security/no-inline-assembly
532             assembly {
533                 calldatacopy(0, 0, calldatasize())
534                 let success := call(gas, handler, 0, 0, calldatasize(), 0, 0)
535                 returndatacopy(0, 0, returndatasize())
536                 if eq(success, 0) { revert(0, returndatasize()) }
537                 return(0, returndatasize())
538             }
539         }
540     }
541 }
542 
543 // File: @gnosis.pm/safe-contracts/contracts/common/SignatureDecoder.sol
544 
545 pragma solidity >=0.5.0 <0.7.0;
546 
547 
548 /// @title SignatureDecoder - Decodes signatures that a encoded as bytes
549 /// @author Ricardo Guilherme Schmidt (Status Research & Development GmbH)
550 /// @author Richard Meissner - <richard@gnosis.pm>
551 contract SignatureDecoder {
552     
553     /// @dev Recovers address who signed the message
554     /// @param messageHash operation ethereum signed message hash
555     /// @param messageSignature message `txHash` signature
556     /// @param pos which signature to read
557     function recoverKey (
558         bytes32 messageHash,
559         bytes memory messageSignature,
560         uint256 pos
561     )
562         internal
563         pure
564         returns (address)
565     {
566         uint8 v;
567         bytes32 r;
568         bytes32 s;
569         (v, r, s) = signatureSplit(messageSignature, pos);
570         return ecrecover(messageHash, v, r, s);
571     }
572 
573     /// @dev divides bytes signature into `uint8 v, bytes32 r, bytes32 s`.
574     /// @notice Make sure to peform a bounds check for @param pos, to avoid out of bounds access on @param signatures
575     /// @param pos which signature to read. A prior bounds check of this parameter should be performed, to avoid out of bounds access
576     /// @param signatures concatenated rsv signatures
577     function signatureSplit(bytes memory signatures, uint256 pos)
578         internal
579         pure
580         returns (uint8 v, bytes32 r, bytes32 s)
581     {
582         // The signature format is a compact form of:
583         //   {bytes32 r}{bytes32 s}{uint8 v}
584         // Compact means, uint8 is not padded to 32 bytes.
585         // solium-disable-next-line security/no-inline-assembly
586         assembly {
587             let signaturePos := mul(0x41, pos)
588             r := mload(add(signatures, add(signaturePos, 0x20)))
589             s := mload(add(signatures, add(signaturePos, 0x40)))
590             // Here we are loading the last 32 bytes, including 31 bytes
591             // of 's'. There is no 'mload8' to do this.
592             //
593             // 'byte' is not working due to the Solidity parser, so lets
594             // use the second best option, 'and'
595             v := and(mload(add(signatures, add(signaturePos, 0x41))), 0xff)
596         }
597     }
598 }
599 
600 // File: @gnosis.pm/safe-contracts/contracts/common/SecuredTokenTransfer.sol
601 
602 pragma solidity >=0.5.0 <0.7.0;
603 
604 
605 /// @title SecuredTokenTransfer - Secure token transfer
606 /// @author Richard Meissner - <richard@gnosis.pm>
607 contract SecuredTokenTransfer {
608 
609     /// @dev Transfers a token and returns if it was a success
610     /// @param token Token that should be transferred
611     /// @param receiver Receiver to whom the token should be transferred
612     /// @param amount The amount of tokens that should be transferred
613     function transferToken (
614         address token,
615         address receiver,
616         uint256 amount
617     )
618         internal
619         returns (bool transferred)
620     {
621         bytes memory data = abi.encodeWithSignature("transfer(address,uint256)", receiver, amount);
622         // solium-disable-next-line security/no-inline-assembly
623         assembly {
624             let success := call(sub(gas, 10000), token, 0, add(data, 0x20), mload(data), 0, 0)
625             let ptr := mload(0x40)
626             mstore(0x40, add(ptr, returndatasize()))
627             returndatacopy(ptr, 0, returndatasize())
628             switch returndatasize()
629             case 0 { transferred := success }
630             case 0x20 { transferred := iszero(or(iszero(success), iszero(mload(ptr)))) }
631             default { transferred := 0 }
632         }
633     }
634 }
635 
636 // File: @gnosis.pm/safe-contracts/contracts/interfaces/ISignatureValidator.sol
637 
638 pragma solidity >=0.5.0 <0.7.0;
639 
640 contract ISignatureValidatorConstants {
641     // bytes4(keccak256("isValidSignature(bytes,bytes)")
642     bytes4 constant internal EIP1271_MAGIC_VALUE = 0x20c13b0b;
643 }
644 
645 contract ISignatureValidator is ISignatureValidatorConstants {
646 
647     /**
648     * @dev Should return whether the signature provided is valid for the provided data
649     * @param _data Arbitrary length data signed on the behalf of address(this)
650     * @param _signature Signature byte array associated with _data
651     *
652     * MUST return the bytes4 magic value 0x20c13b0b when function passes.
653     * MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
654     * MUST allow external calls
655     */
656     function isValidSignature(
657         bytes memory _data,
658         bytes memory _signature)
659         public
660         view
661         returns (bytes4);
662 }
663 
664 // File: @gnosis.pm/safe-contracts/contracts/external/SafeMath.sol
665 
666 pragma solidity >=0.5.0 <0.7.0;
667 
668 /**
669  * @title SafeMath
670  * @dev Math operations with safety checks that revert on error
671  * TODO: remove once open zeppelin update to solc 0.5.0
672  */
673 library SafeMath {
674 
675   /**
676   * @dev Multiplies two numbers, reverts on overflow.
677   */
678   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
679     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
680     // benefit is lost if 'b' is also tested.
681     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
682     if (a == 0) {
683       return 0;
684     }
685 
686     uint256 c = a * b;
687     require(c / a == b);
688 
689     return c;
690   }
691 
692   /**
693   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
694   */
695   function div(uint256 a, uint256 b) internal pure returns (uint256) {
696     require(b > 0); // Solidity only automatically asserts when dividing by 0
697     uint256 c = a / b;
698     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
699 
700     return c;
701   }
702 
703   /**
704   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
705   */
706   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
707     require(b <= a);
708     uint256 c = a - b;
709 
710     return c;
711   }
712 
713   /**
714   * @dev Adds two numbers, reverts on overflow.
715   */
716   function add(uint256 a, uint256 b) internal pure returns (uint256) {
717     uint256 c = a + b;
718     require(c >= a);
719 
720     return c;
721   }
722 
723   /**
724   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
725   * reverts when dividing by zero.
726   */
727   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
728     require(b != 0);
729     return a % b;
730   }
731 }
732 
733 // File: @gnosis.pm/safe-contracts/contracts/GnosisSafe.sol
734 
735 pragma solidity >=0.5.0 <0.7.0;
736 
737 
738 
739 
740 
741 
742 
743 
744 
745 /// @title Gnosis Safe - A multisignature wallet with support for confirmations using signed messages based on ERC191.
746 /// @author Stefan George - <stefan@gnosis.io>
747 /// @author Richard Meissner - <richard@gnosis.io>
748 /// @author Ricardo Guilherme Schmidt - (Status Research & Development GmbH) - Gas Token Payment
749 contract GnosisSafe
750     is MasterCopy, ModuleManager, OwnerManager, SignatureDecoder, SecuredTokenTransfer, ISignatureValidatorConstants, FallbackManager {
751 
752     using SafeMath for uint256;
753 
754     string public constant NAME = "Gnosis Safe";
755     string public constant VERSION = "1.1.0";
756 
757     //keccak256(
758     //    "EIP712Domain(address verifyingContract)"
759     //);
760     bytes32 public constant DOMAIN_SEPARATOR_TYPEHASH = 0x035aff83d86937d35b32e04f0ddc6ff469290eef2f1b692d8a815c89404d4749;
761 
762     //keccak256(
763     //    "SafeTx(address to,uint256 value,bytes data,uint8 operation,uint256 safeTxGas,uint256 baseGas,uint256 gasPrice,address gasToken,address refundReceiver,uint256 nonce)"
764     //);
765     bytes32 public constant SAFE_TX_TYPEHASH = 0xbb8310d486368db6bd6f849402fdd73ad53d316b5a4b2644ad6efe0f941286d8;
766 
767     //keccak256(
768     //    "SafeMessage(bytes message)"
769     //);
770     bytes32 public constant SAFE_MSG_TYPEHASH = 0x60b3cbf8b4a223d68d641b3b6ddf9a298e7f33710cf3d3a9d1146b5a6150fbca;
771 
772     event ApproveHash(
773         bytes32 indexed approvedHash,
774         address indexed owner
775     );
776     event SignMsg(
777         bytes32 indexed msgHash
778     );
779     event ExecutionFailure(
780         bytes32 txHash, uint256 payment
781     );
782     event ExecutionSuccess(
783         bytes32 txHash, uint256 payment
784     );
785 
786     uint256 public nonce;
787     bytes32 public domainSeparator;
788     // Mapping to keep track of all message hashes that have been approve by ALL REQUIRED owners
789     mapping(bytes32 => uint256) public signedMessages;
790     // Mapping to keep track of all hashes (message or transaction) that have been approve by ANY owners
791     mapping(address => mapping(bytes32 => uint256)) public approvedHashes;
792 
793     /// @dev Setup function sets initial storage of contract.
794     /// @param _owners List of Safe owners.
795     /// @param _threshold Number of required confirmations for a Safe transaction.
796     /// @param to Contract address for optional delegate call.
797     /// @param data Data payload for optional delegate call.
798     /// @param fallbackHandler Handler for fallback calls to this contract
799     /// @param paymentToken Token that should be used for the payment (0 is ETH)
800     /// @param payment Value that should be paid
801     /// @param paymentReceiver Adddress that should receive the payment (or 0 if tx.origin)
802     function setup(
803         address[] calldata _owners,
804         uint256 _threshold,
805         address to,
806         bytes calldata data,
807         address fallbackHandler,
808         address paymentToken,
809         uint256 payment,
810         address payable paymentReceiver
811     )
812         external
813     {
814         require(domainSeparator == 0, "Domain Separator already set!");
815         domainSeparator = keccak256(abi.encode(DOMAIN_SEPARATOR_TYPEHASH, this));
816         setupOwners(_owners, _threshold);
817         // As setupOwners can only be called if the contract has not been initialized we don't need a check for setupModules
818         setupModules(to, data);
819         if (fallbackHandler != address(0)) internalSetFallbackHandler(fallbackHandler);
820 
821         if (payment > 0) {
822             // To avoid running into issues with EIP-170 we reuse the handlePayment function (to avoid adjusting code of that has been verified we do not adjust the method itself)
823             // baseGas = 0, gasPrice = 1 and gas = payment => amount = (payment + 0) * 1 = payment
824             handlePayment(payment, 0, 1, paymentToken, paymentReceiver);
825         }
826     }
827 
828     /// @dev Allows to execute a Safe transaction confirmed by required number of owners and then pays the account that submitted the transaction.
829     ///      Note: The fees are always transfered, even if the user transaction fails.
830     /// @param to Destination address of Safe transaction.
831     /// @param value Ether value of Safe transaction.
832     /// @param data Data payload of Safe transaction.
833     /// @param operation Operation type of Safe transaction.
834     /// @param safeTxGas Gas that should be used for the Safe transaction.
835     /// @param baseGas Gas costs for that are indipendent of the transaction execution(e.g. base transaction fee, signature check, payment of the refund)
836     /// @param gasPrice Gas price that should be used for the payment calculation.
837     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
838     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
839     /// @param signatures Packed signature data ({bytes32 r}{bytes32 s}{uint8 v})
840     function execTransaction(
841         address to,
842         uint256 value,
843         bytes calldata data,
844         Enum.Operation operation,
845         uint256 safeTxGas,
846         uint256 baseGas,
847         uint256 gasPrice,
848         address gasToken,
849         address payable refundReceiver,
850         bytes calldata signatures
851     )
852         external
853         returns (bool success)
854     {
855         bytes32 txHash;
856         // Use scope here to limit variable lifetime and prevent `stack too deep` errors
857         {
858             bytes memory txHashData = encodeTransactionData(
859                 to, value, data, operation, // Transaction info
860                 safeTxGas, baseGas, gasPrice, gasToken, refundReceiver, // Payment info
861                 nonce
862             );
863             // Increase nonce and execute transaction.
864             nonce++;
865             txHash = keccak256(txHashData);
866             checkSignatures(txHash, txHashData, signatures, true);
867         }
868         require(gasleft() >= safeTxGas, "Not enough gas to execute safe transaction");
869         // Use scope here to limit variable lifetime and prevent `stack too deep` errors
870         {
871             uint256 gasUsed = gasleft();
872             // If no safeTxGas has been set and the gasPrice is 0 we assume that all available gas can be used
873             success = execute(to, value, data, operation, safeTxGas == 0 && gasPrice == 0 ? gasleft() : safeTxGas);
874             gasUsed = gasUsed.sub(gasleft());
875             // We transfer the calculated tx costs to the tx.origin to avoid sending it to intermediate contracts that have made calls
876             uint256 payment = 0;
877             if (gasPrice > 0) {
878                 payment = handlePayment(gasUsed, baseGas, gasPrice, gasToken, refundReceiver);
879             }
880             if (success) emit ExecutionSuccess(txHash, payment);
881             else emit ExecutionFailure(txHash, payment);
882         }
883     }
884 
885     function handlePayment(
886         uint256 gasUsed,
887         uint256 baseGas,
888         uint256 gasPrice,
889         address gasToken,
890         address payable refundReceiver
891     )
892         private
893         returns (uint256 payment)
894     {
895         // solium-disable-next-line security/no-tx-origin
896         address payable receiver = refundReceiver == address(0) ? tx.origin : refundReceiver;
897         if (gasToken == address(0)) {
898             // For ETH we will only adjust the gas price to not be higher than the actual used gas price
899             payment = gasUsed.add(baseGas).mul(gasPrice < tx.gasprice ? gasPrice : tx.gasprice);
900             // solium-disable-next-line security/no-send
901             require(receiver.send(payment), "Could not pay gas costs with ether");
902         } else {
903             payment = gasUsed.add(baseGas).mul(gasPrice);
904             require(transferToken(gasToken, receiver, payment), "Could not pay gas costs with token");
905         }
906     }
907 
908     /**
909     * @dev Checks whether the signature provided is valid for the provided data, hash. Will revert otherwise.
910     * @param dataHash Hash of the data (could be either a message hash or transaction hash)
911     * @param data That should be signed (this is passed to an external validator contract)
912     * @param signatures Signature data that should be verified. Can be ECDSA signature, contract signature (EIP-1271) or approved hash.
913     * @param consumeHash Indicates that in case of an approved hash the storage can be freed to save gas
914     */
915     function checkSignatures(bytes32 dataHash, bytes memory data, bytes memory signatures, bool consumeHash)
916         internal
917     {
918         // Load threshold to avoid multiple storage loads
919         uint256 _threshold = threshold;
920         // Check that a threshold is set
921         require(_threshold > 0, "Threshold needs to be defined!");
922         // Check that the provided signature data is not too short
923         require(signatures.length >= _threshold.mul(65), "Signatures data too short");
924         // There cannot be an owner with address 0.
925         address lastOwner = address(0);
926         address currentOwner;
927         uint8 v;
928         bytes32 r;
929         bytes32 s;
930         uint256 i;
931         for (i = 0; i < _threshold; i++) {
932             (v, r, s) = signatureSplit(signatures, i);
933             // If v is 0 then it is a contract signature
934             if (v == 0) {
935                 // When handling contract signatures the address of the contract is encoded into r
936                 currentOwner = address(uint256(r));
937 
938                 // Check that signature data pointer (s) is not pointing inside the static part of the signatures bytes
939                 // This check is not completely accurate, since it is possible that more signatures than the threshold are send.
940                 // Here we only check that the pointer is not pointing inside the part that is being processed
941                 require(uint256(s) >= _threshold.mul(65), "Invalid contract signature location: inside static part");
942 
943                 // Check that signature data pointer (s) is in bounds (points to the length of data -> 32 bytes)
944                 require(uint256(s).add(32) <= signatures.length, "Invalid contract signature location: length not present");
945 
946                 // Check if the contract signature is in bounds: start of data is s + 32 and end is start + signature length
947                 uint256 contractSignatureLen;
948                 // solium-disable-next-line security/no-inline-assembly
949                 assembly {
950                     contractSignatureLen := mload(add(add(signatures, s), 0x20))
951                 }
952                 require(uint256(s).add(32).add(contractSignatureLen) <= signatures.length, "Invalid contract signature location: data not complete");
953 
954                 // Check signature
955                 bytes memory contractSignature;
956                 // solium-disable-next-line security/no-inline-assembly
957                 assembly {
958                     // The signature data for contract signatures is appended to the concatenated signatures and the offset is stored in s
959                     contractSignature := add(add(signatures, s), 0x20)
960                 }
961                 require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE, "Invalid contract signature provided");
962             // If v is 1 then it is an approved hash
963             } else if (v == 1) {
964                 // When handling approved hashes the address of the approver is encoded into r
965                 currentOwner = address(uint256(r));
966                 // Hashes are automatically approved by the sender of the message or when they have been pre-approved via a separate transaction
967                 require(msg.sender == currentOwner || approvedHashes[currentOwner][dataHash] != 0, "Hash has not been approved");
968                 // Hash has been marked for consumption. If this hash was pre-approved free storage
969                 if (consumeHash && msg.sender != currentOwner) {
970                     approvedHashes[currentOwner][dataHash] = 0;
971                 }
972             } else if (v > 30) {
973                 // To support eth_sign and similar we adjust v and hash the messageHash with the Ethereum message prefix before applying ecrecover
974                 currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4, r, s);
975             } else {
976                 // Use ecrecover with the messageHash for EOA signatures
977                 currentOwner = ecrecover(dataHash, v, r, s);
978             }
979             require (
980                 currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
981                 "Invalid owner provided"
982             );
983             lastOwner = currentOwner;
984         }
985     }
986 
987     /// @dev Allows to estimate a Safe transaction.
988     ///      This method is only meant for estimation purpose, therefore two different protection mechanism against execution in a transaction have been made:
989     ///      1.) The method can only be called from the safe itself
990     ///      2.) The response is returned with a revert
991     ///      When estimating set `from` to the address of the safe.
992     ///      Since the `estimateGas` function includes refunds, call this method to get an estimated of the costs that are deducted from the safe with `execTransaction`
993     /// @param to Destination address of Safe transaction.
994     /// @param value Ether value of Safe transaction.
995     /// @param data Data payload of Safe transaction.
996     /// @param operation Operation type of Safe transaction.
997     /// @return Estimate without refunds and overhead fees (base transaction and payload data gas costs).
998     function requiredTxGas(address to, uint256 value, bytes calldata data, Enum.Operation operation)
999         external
1000         authorized
1001         returns (uint256)
1002     {
1003         uint256 startGas = gasleft();
1004         // We don't provide an error message here, as we use it to return the estimate
1005         // solium-disable-next-line error-reason
1006         require(execute(to, value, data, operation, gasleft()));
1007         uint256 requiredGas = startGas - gasleft();
1008         // Convert response to string and return via error message
1009         revert(string(abi.encodePacked(requiredGas)));
1010     }
1011 
1012     /**
1013     * @dev Marks a hash as approved. This can be used to validate a hash that is used by a signature.
1014     * @param hashToApprove The hash that should be marked as approved for signatures that are verified by this contract.
1015     */
1016     function approveHash(bytes32 hashToApprove)
1017         external
1018     {
1019         require(owners[msg.sender] != address(0), "Only owners can approve a hash");
1020         approvedHashes[msg.sender][hashToApprove] = 1;
1021         emit ApproveHash(hashToApprove, msg.sender);
1022     }
1023 
1024     /**
1025     * @dev Marks a message as signed
1026     * @param _data Arbitrary length data that should be marked as signed on the behalf of address(this)
1027     */
1028     function signMessage(bytes calldata _data)
1029         external
1030         authorized
1031     {
1032         bytes32 msgHash = getMessageHash(_data);
1033         signedMessages[msgHash] = 1;
1034         emit SignMsg(msgHash);
1035     }
1036 
1037     /**
1038     * Implementation of ISignatureValidator (see `interfaces/ISignatureValidator.sol`)
1039     * @dev Should return whether the signature provided is valid for the provided data.
1040     *       The save does not implement the interface since `checkSignatures` is not a view method.
1041     *       The method will not perform any state changes (see parameters of `checkSignatures`)
1042     * @param _data Arbitrary length data signed on the behalf of address(this)
1043     * @param _signature Signature byte array associated with _data
1044     * @return a bool upon valid or invalid signature with corresponding _data
1045     */
1046     function isValidSignature(bytes calldata _data, bytes calldata _signature)
1047         external
1048         returns (bytes4)
1049     {
1050         bytes32 messageHash = getMessageHash(_data);
1051         if (_signature.length == 0) {
1052             require(signedMessages[messageHash] != 0, "Hash not approved");
1053         } else {
1054             // consumeHash needs to be false, as the state should not be changed
1055             checkSignatures(messageHash, _data, _signature, false);
1056         }
1057         return EIP1271_MAGIC_VALUE;
1058     }
1059 
1060     /// @dev Returns hash of a message that can be signed by owners.
1061     /// @param message Message that should be hashed
1062     /// @return Message hash.
1063     function getMessageHash(
1064         bytes memory message
1065     )
1066         public
1067         view
1068         returns (bytes32)
1069     {
1070         bytes32 safeMessageHash = keccak256(
1071             abi.encode(SAFE_MSG_TYPEHASH, keccak256(message))
1072         );
1073         return keccak256(
1074             abi.encodePacked(byte(0x19), byte(0x01), domainSeparator, safeMessageHash)
1075         );
1076     }
1077 
1078     /// @dev Returns the bytes that are hashed to be signed by owners.
1079     /// @param to Destination address.
1080     /// @param value Ether value.
1081     /// @param data Data payload.
1082     /// @param operation Operation type.
1083     /// @param safeTxGas Fas that should be used for the safe transaction.
1084     /// @param baseGas Gas costs for data used to trigger the safe transaction.
1085     /// @param gasPrice Maximum gas price that should be used for this transaction.
1086     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
1087     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
1088     /// @param _nonce Transaction nonce.
1089     /// @return Transaction hash bytes.
1090     function encodeTransactionData(
1091         address to,
1092         uint256 value,
1093         bytes memory data,
1094         Enum.Operation operation,
1095         uint256 safeTxGas,
1096         uint256 baseGas,
1097         uint256 gasPrice,
1098         address gasToken,
1099         address refundReceiver,
1100         uint256 _nonce
1101     )
1102         public
1103         view
1104         returns (bytes memory)
1105     {
1106         bytes32 safeTxHash = keccak256(
1107             abi.encode(SAFE_TX_TYPEHASH, to, value, keccak256(data), operation, safeTxGas, baseGas, gasPrice, gasToken, refundReceiver, _nonce)
1108         );
1109         return abi.encodePacked(byte(0x19), byte(0x01), domainSeparator, safeTxHash);
1110     }
1111 
1112     /// @dev Returns hash to be signed by owners.
1113     /// @param to Destination address.
1114     /// @param value Ether value.
1115     /// @param data Data payload.
1116     /// @param operation Operation type.
1117     /// @param safeTxGas Fas that should be used for the safe transaction.
1118     /// @param baseGas Gas costs for data used to trigger the safe transaction.
1119     /// @param gasPrice Maximum gas price that should be used for this transaction.
1120     /// @param gasToken Token address (or 0 if ETH) that is used for the payment.
1121     /// @param refundReceiver Address of receiver of gas payment (or 0 if tx.origin).
1122     /// @param _nonce Transaction nonce.
1123     /// @return Transaction hash.
1124     function getTransactionHash(
1125         address to,
1126         uint256 value,
1127         bytes memory data,
1128         Enum.Operation operation,
1129         uint256 safeTxGas,
1130         uint256 baseGas,
1131         uint256 gasPrice,
1132         address gasToken,
1133         address refundReceiver,
1134         uint256 _nonce
1135     )
1136         public
1137         view
1138         returns (bytes32)
1139     {
1140         return keccak256(encodeTransactionData(to, value, data, operation, safeTxGas, baseGas, gasPrice, gasToken, refundReceiver, _nonce));
1141     }
1142 }
1143 
1144 // File: contracts/CPKFactory.sol
1145 
1146 pragma solidity >=0.5.0 <0.7.0;
1147 
1148 
1149 
1150 
1151 contract CPKFactory {
1152     event ProxyCreation(Proxy proxy);
1153 
1154     function proxyCreationCode() external pure returns (bytes memory) {
1155         return type(Proxy).creationCode;
1156     }
1157 
1158     function createProxyAndExecTransaction(
1159         address masterCopy,
1160         uint256 saltNonce,
1161         address fallbackHandler,
1162         address to,
1163         uint256 value,
1164         bytes calldata data,
1165         Enum.Operation operation
1166     )
1167         external
1168         returns (bool execTransactionSuccess)
1169     {
1170         GnosisSafe proxy;
1171         bytes memory deploymentData = abi.encodePacked(type(Proxy).creationCode, abi.encode(masterCopy));
1172         bytes32 salt = keccak256(abi.encode(msg.sender, saltNonce));
1173         // solium-disable-next-line security/no-inline-assembly
1174         assembly {
1175             proxy := create2(0x0, add(0x20, deploymentData), mload(deploymentData), salt)
1176         }
1177         require(address(proxy) != address(0), "create2 call failed");
1178 
1179         {
1180             address[] memory tmp = new address[](1);
1181             tmp[0] = address(this);
1182             proxy.setup(tmp, 1, address(0), "", fallbackHandler, address(0), 0, address(0));
1183         }
1184 
1185         execTransactionSuccess = proxy.execTransaction(to, value, data, operation, 0, 0, 0, address(0), address(0),
1186             abi.encodePacked(uint(address(this)), uint(0), uint8(1)));
1187 
1188         proxy.execTransaction(
1189             address(proxy), 0,
1190             abi.encodeWithSignature("swapOwner(address,address,address)", address(1), address(this), msg.sender),
1191             Enum.Operation.Call,
1192             0, 0, 0, address(0), address(0),
1193             abi.encodePacked(uint(address(this)), uint(0), uint8(1))
1194         );
1195 
1196         emit ProxyCreation(Proxy(address(proxy)));
1197    }
1198 }
