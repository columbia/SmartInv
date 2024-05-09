1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol
68 
69 /**
70  * @title Contracts that should not own Ether
71  * @author Remco Bloemen <remco@2π.com>
72  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
73  * in the contract, it will allow the owner to reclaim this Ether.
74  * @notice Ether can still be sent to this contract by:
75  * calling functions labeled `payable`
76  * `selfdestruct(contract_address)`
77  * mining directly to the contract address
78  */
79 contract HasNoEther is Ownable {
80 
81   /**
82   * @dev Constructor that rejects incoming Ether
83   * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
84   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
85   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
86   * we could use assembly to access msg.value.
87   */
88   constructor() public payable {
89     require(msg.value == 0);
90   }
91 
92   /**
93    * @dev Disallows direct send by setting a default function without the `payable` flag.
94    */
95   function() external {
96   }
97 
98   /**
99    * @dev Transfer all Ether held by the contract to the owner.
100    */
101   function reclaimEther() external onlyOwner {
102     owner.transfer(address(this).balance);
103   }
104 }
105 
106 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * See https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address _who) public view returns (uint256);
116   function transfer(address _to, uint256 _value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address _owner, address _spender)
128     public view returns (uint256);
129 
130   function transferFrom(address _from, address _to, uint256 _value)
131     public returns (bool);
132 
133   function approve(address _spender, uint256 _value) public returns (bool);
134   event Approval(
135     address indexed owner,
136     address indexed spender,
137     uint256 value
138   );
139 }
140 
141 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
142 
143 /**
144  * @title SafeERC20
145  * @dev Wrappers around ERC20 operations that throw on failure.
146  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
147  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
148  */
149 library SafeERC20 {
150   function safeTransfer(
151     ERC20Basic _token,
152     address _to,
153     uint256 _value
154   )
155     internal
156   {
157     require(_token.transfer(_to, _value));
158   }
159 
160   function safeTransferFrom(
161     ERC20 _token,
162     address _from,
163     address _to,
164     uint256 _value
165   )
166     internal
167   {
168     require(_token.transferFrom(_from, _to, _value));
169   }
170 
171   function safeApprove(
172     ERC20 _token,
173     address _spender,
174     uint256 _value
175   )
176     internal
177   {
178     require(_token.approve(_spender, _value));
179   }
180 }
181 
182 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
183 
184 /**
185  * @title Contracts that should be able to recover tokens
186  * @author SylTi
187  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
188  * This will prevent any accidental loss of tokens.
189  */
190 contract CanReclaimToken is Ownable {
191   using SafeERC20 for ERC20Basic;
192 
193   /**
194    * @dev Reclaim all ERC20Basic compatible tokens
195    * @param _token ERC20Basic The address of the token contract
196    */
197   function reclaimToken(ERC20Basic _token) external onlyOwner {
198     uint256 balance = _token.balanceOf(this);
199     _token.safeTransfer(owner, balance);
200   }
201 
202 }
203 
204 // File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol
205 
206 /**
207  * @title Contracts that should not own Tokens
208  * @author Remco Bloemen <remco@2π.com>
209  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
210  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
211  * owner to reclaim the tokens.
212  */
213 contract HasNoTokens is CanReclaimToken {
214 
215  /**
216   * @dev Reject all ERC223 compatible tokens
217   * @param _from address The address that is transferring the tokens
218   * @param _value uint256 the amount of the specified token
219   * @param _data Bytes The data passed from the caller.
220   */
221   function tokenFallback(
222     address _from,
223     uint256 _value,
224     bytes _data
225   )
226     external
227     pure
228   {
229     _from;
230     _value;
231     _data;
232     revert();
233   }
234 
235 }
236 
237 // File: contracts/lifecycle/PausableProxy.sol
238 
239 /**
240  * @title PausableProxy
241  * @dev Base contract which allows children to implement an emergency stop mechanism.
242  */
243 contract PausableProxy {
244     /**
245      * @dev Storage slot with the paused state of the contract.
246      * This is the keccak-256 hash of "org.monetha.proxy.paused", and is
247      * validated in the constructor.
248      */
249     bytes32 private constant PAUSED_OWNER_SLOT = 0x9e7945c55c116aa3404b99fe56db7af9613d3b899554a437c2616a4749a94d8a;
250 
251     /**
252      * @dev The ClaimableProxy constructor validates PENDING_OWNER_SLOT constant.
253      */
254     constructor() public {
255         assert(PAUSED_OWNER_SLOT == keccak256("org.monetha.proxy.paused"));
256     }
257 
258     /**
259      * @dev Modifier to make a function callable only when the contract is not paused.
260      */
261     modifier whenNotPaused() {
262         require(!_getPaused(), "contract should not be paused");
263         _;
264     }
265 
266     /**
267      * @dev Modifier to make a function callable only when the contract is paused.
268      */
269     modifier whenPaused() {
270         require(_getPaused(), "contract should be paused");
271         _;
272     }
273 
274     /**
275      * @return True when the contract is paused.
276      */
277     function _getPaused() internal view returns (bool paused) {
278         bytes32 slot = PAUSED_OWNER_SLOT;
279         assembly {
280             paused := sload(slot)
281         }
282     }
283 
284     /**
285      * @dev Sets the paused state.
286      * @param _paused New paused state.
287      */
288     function _setPaused(bool _paused) internal {
289         bytes32 slot = PAUSED_OWNER_SLOT;
290         assembly {
291             sstore(slot, _paused)
292         }
293     }
294 }
295 
296 // File: contracts/ownership/OwnableProxy.sol
297 
298 /**
299  * @title OwnableProxy
300  */
301 contract OwnableProxy is PausableProxy {
302     event OwnershipRenounced(address indexed previousOwner);
303     event OwnershipTransferred(
304         address indexed previousOwner,
305         address indexed newOwner
306     );
307 
308     /**
309      * @dev Storage slot with the owner of the contract.
310      * This is the keccak-256 hash of "org.monetha.proxy.owner", and is
311      * validated in the constructor.
312      */
313     bytes32 private constant OWNER_SLOT = 0x3ca57e4b51fc2e18497b219410298879868edada7e6fe5132c8feceb0a080d22;
314 
315     /**
316      * @dev The OwnableProxy constructor sets the original `owner` of the contract to the sender
317      * account.
318      */
319     constructor() public {
320         assert(OWNER_SLOT == keccak256("org.monetha.proxy.owner"));
321 
322         _setOwner(msg.sender);
323     }
324 
325     /**
326      * @dev Throws if called by any account other than the owner.
327      */
328     modifier onlyOwner() {
329         require(msg.sender == _getOwner());
330         _;
331     }
332 
333     /**
334      * @dev Allows the current owner to relinquish control of the contract.
335      * @notice Renouncing to ownership will leave the contract without an owner.
336      * It will not be possible to call the functions with the `onlyOwner`
337      * modifier anymore.
338      */
339     function renounceOwnership() public onlyOwner whenNotPaused {
340         emit OwnershipRenounced(_getOwner());
341         _setOwner(address(0));
342     }
343 
344     /**
345      * @dev Allows the current owner to transfer control of the contract to a newOwner.
346      * @param _newOwner The address to transfer ownership to.
347      */
348     function transferOwnership(address _newOwner) public onlyOwner whenNotPaused {
349         _transferOwnership(_newOwner);
350     }
351 
352     /**
353      * @dev Transfers control of the contract to a newOwner.
354      * @param _newOwner The address to transfer ownership to.
355      */
356     function _transferOwnership(address _newOwner) internal {
357         require(_newOwner != address(0));
358         emit OwnershipTransferred(_getOwner(), _newOwner);
359         _setOwner(_newOwner);
360     }
361 
362     /**
363      * @return The owner address.
364      */
365     function owner() public view returns (address) {
366         return _getOwner();
367     }
368 
369     /**
370      * @return The owner address.
371      */
372     function _getOwner() internal view returns (address own) {
373         bytes32 slot = OWNER_SLOT;
374         assembly {
375             own := sload(slot)
376         }
377     }
378 
379     /**
380      * @dev Sets the address of the proxy owner.
381      * @param _newOwner Address of the new proxy owner.
382      */
383     function _setOwner(address _newOwner) internal {
384         bytes32 slot = OWNER_SLOT;
385 
386         assembly {
387             sstore(slot, _newOwner)
388         }
389     }
390 }
391 
392 // File: contracts/ownership/ClaimableProxy.sol
393 
394 /**
395  * @title ClaimableProxy
396  * @dev Extension for the OwnableProxy contract, where the ownership needs to be claimed.
397  * This allows the new owner to accept the transfer.
398  */
399 contract ClaimableProxy is OwnableProxy {
400     /**
401      * @dev Storage slot with the pending owner of the contract.
402      * This is the keccak-256 hash of "org.monetha.proxy.pendingOwner", and is
403      * validated in the constructor.
404      */
405     bytes32 private constant PENDING_OWNER_SLOT = 0xcfd0c6ea5352192d7d4c5d4e7a73c5da12c871730cb60ff57879cbe7b403bb52;
406 
407     /**
408      * @dev The ClaimableProxy constructor validates PENDING_OWNER_SLOT constant.
409      */
410     constructor() public {
411         assert(PENDING_OWNER_SLOT == keccak256("org.monetha.proxy.pendingOwner"));
412     }
413 
414     function pendingOwner() public view returns (address) {
415         return _getPendingOwner();
416     }
417 
418     /**
419      * @dev Modifier throws if called by any account other than the pendingOwner.
420      */
421     modifier onlyPendingOwner() {
422         require(msg.sender == _getPendingOwner());
423         _;
424     }
425 
426     /**
427      * @dev Allows the current owner to set the pendingOwner address.
428      * @param newOwner The address to transfer ownership to.
429      */
430     function transferOwnership(address newOwner) public onlyOwner whenNotPaused {
431         _setPendingOwner(newOwner);
432     }
433 
434     /**
435      * @dev Allows the pendingOwner address to finalize the transfer.
436      */
437     function claimOwnership() public onlyPendingOwner whenNotPaused {
438         emit OwnershipTransferred(_getOwner(), _getPendingOwner());
439         _setOwner(_getPendingOwner());
440         _setPendingOwner(address(0));
441     }
442 
443     /**
444      * @return The pending owner address.
445      */
446     function _getPendingOwner() internal view returns (address penOwn) {
447         bytes32 slot = PENDING_OWNER_SLOT;
448         assembly {
449             penOwn := sload(slot)
450         }
451     }
452 
453     /**
454      * @dev Sets the address of the pending owner.
455      * @param _newPendingOwner Address of the new pending owner.
456      */
457     function _setPendingOwner(address _newPendingOwner) internal {
458         bytes32 slot = PENDING_OWNER_SLOT;
459 
460         assembly {
461             sstore(slot, _newPendingOwner)
462         }
463     }
464 }
465 
466 // File: contracts/lifecycle/DestructibleProxy.sol
467 
468 /**
469  * @title Destructible
470  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
471  */
472 contract DestructibleProxy is OwnableProxy {
473     /**
474      * @dev Transfers the current balance to the owner and terminates the contract.
475      */
476     function destroy() public onlyOwner whenNotPaused {
477         selfdestruct(_getOwner());
478     }
479 
480     function destroyAndSend(address _recipient) public onlyOwner whenNotPaused {
481         selfdestruct(_recipient);
482     }
483 }
484 
485 // File: contracts/IPassportLogicRegistry.sol
486 
487 interface IPassportLogicRegistry {
488     /**
489      * @dev This event will be emitted every time a new passport logic implementation is registered
490      * @param version representing the version name of the registered passport logic implementation
491      * @param implementation representing the address of the registered passport logic implementation
492      */
493     event PassportLogicAdded(string version, address implementation);
494 
495     /**
496      * @dev This event will be emitted every time a new passport logic implementation is set as current one
497      * @param version representing the version name of the current passport logic implementation
498      * @param implementation representing the address of the current passport logic implementation
499      */
500     event CurrentPassportLogicSet(string version, address implementation);
501 
502     /**
503      * @dev Tells the address of the passport logic implementation for a given version
504      * @param _version to query the implementation of
505      * @return address of the passport logic implementation registered for the given version
506      */
507     function getPassportLogic(string _version) external view returns (address);
508 
509     /**
510      * @dev Tells the version of the current passport logic implementation
511      * @return version of the current passport logic implementation
512      */
513     function getCurrentPassportLogicVersion() external view returns (string);
514 
515     /**
516      * @dev Tells the address of the current passport logic implementation
517      * @return address of the current passport logic implementation
518      */
519     function getCurrentPassportLogic() external view returns (address);
520 }
521 
522 // File: contracts/upgradeability/Proxy.sol
523 
524 /**
525  * @title Proxy
526  * @dev Implements delegation of calls to other contracts, with proper
527  * forwarding of return values and bubbling of failures.
528  * It defines a fallback function that delegates all calls to the address
529  * returned by the abstract _implementation() internal function.
530  */
531 contract Proxy {
532     /**
533      * @dev Fallback function.
534      * Implemented entirely in `_fallback`.
535      */
536     function () payable external {
537         _delegate(_implementation());
538     }
539 
540     /**
541      * @return The Address of the implementation.
542      */
543     function _implementation() internal view returns (address);
544 
545     /**
546      * @dev Delegates execution to an implementation contract.
547      * This is a low level function that doesn't return to its internal call site.
548      * It will return to the external caller whatever the implementation returns.
549      * @param implementation Address to delegate.
550      */
551     function _delegate(address implementation) internal {
552         assembly {
553         // Copy msg.data. We take full control of memory in this inline assembly
554         // block because it will not return to Solidity code. We overwrite the
555         // Solidity scratch pad at memory position 0.
556             calldatacopy(0, 0, calldatasize)
557 
558         // Call the implementation.
559         // out and outsize are 0 because we don't know the size yet.
560             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
561 
562         // Copy the returned data.
563             returndatacopy(0, 0, returndatasize)
564 
565             switch result
566             // delegatecall returns 0 on error.
567             case 0 { revert(0, returndatasize) }
568             default { return(0, returndatasize) }
569         }
570     }
571 }
572 
573 // File: contracts/Passport.sol
574 
575 /**
576  * @title Passport
577  */
578 contract Passport is Proxy, ClaimableProxy, DestructibleProxy {
579 
580     event PassportLogicRegistryChanged(
581         address indexed previousRegistry,
582         address indexed newRegistry
583     );
584 
585     /**
586      * @dev Storage slot with the address of the current registry of the passport implementations.
587      * This is the keccak-256 hash of "org.monetha.passport.proxy.registry", and is
588      * validated in the constructor.
589      */
590     bytes32 private constant REGISTRY_SLOT = 0xa04bab69e45aeb4c94a78ba5bc1be67ef28977c4fdf815a30b829a794eb67a4a;
591 
592     /**
593      * @dev Contract constructor.
594      * @param _registry Address of the passport implementations registry.
595      */
596     constructor(IPassportLogicRegistry _registry) public {
597         assert(REGISTRY_SLOT == keccak256("org.monetha.passport.proxy.registry"));
598 
599         _setRegistry(_registry);
600     }
601 
602     /**
603      * @return the address of passport logic registry.
604      */
605     function getPassportLogicRegistry() public view returns (address) {
606         return _getRegistry();
607     }
608 
609     /**
610      * @dev Returns the current passport logic implementation (used in Proxy fallback function to delegate call
611      * to passport logic implementation).
612      * @return Address of the current passport implementation
613      */
614     function _implementation() internal view returns (address) {
615         return _getRegistry().getCurrentPassportLogic();
616     }
617 
618     /**
619      * @dev Returns the current passport implementations registry.
620      * @return Address of the current implementation
621      */
622     function _getRegistry() internal view returns (IPassportLogicRegistry reg) {
623         bytes32 slot = REGISTRY_SLOT;
624         assembly {
625             reg := sload(slot)
626         }
627     }
628 
629     function _setRegistry(IPassportLogicRegistry _registry) internal {
630         require(address(_registry) != 0x0, "Cannot set registry to a zero address");
631 
632         bytes32 slot = REGISTRY_SLOT;
633         assembly {
634             sstore(slot, _registry)
635         }
636     }
637 }
638 
639 // File: contracts/PassportFactory.sol
640 
641 /**
642  * @title PassportFactory
643  * @dev This contract works as a passport factory.
644  */
645 contract PassportFactory is Ownable, HasNoEther, HasNoTokens {
646     IPassportLogicRegistry private registry;
647 
648     /**
649     * @dev This event will be emitted every time a new passport is created
650     * @param passport representing the address of the passport created
651     * @param owner representing the address of the passport owner
652     */
653     event PassportCreated(address indexed passport, address indexed owner);
654 
655     /**
656     * @dev This event will be emitted every time a passport logic registry is changed
657     * @param oldRegistry representing the address of the old passport logic registry
658     * @param newRegistry representing the address of the new passport logic registry
659     */
660     event PassportLogicRegistryChanged(address indexed oldRegistry, address indexed newRegistry);
661 
662     constructor(IPassportLogicRegistry _registry) public {
663         _setRegistry(_registry);
664     }
665 
666     function setRegistry(IPassportLogicRegistry _registry) public onlyOwner {
667         emit PassportLogicRegistryChanged(registry, _registry);
668         _setRegistry(_registry);
669     }
670 
671     function getRegistry() external view returns (address) {
672         return registry;
673     }
674 
675     /**
676     * @dev Creates new passport. The method should be called by the owner of the created passport.
677     * After the passport is created, the owner must call the claimOwnership() passport method to become a full owner.
678     * @return address of the created passport
679     */
680     function createPassport() public returns (Passport) {
681         Passport pass = new Passport(registry);
682         pass.transferOwnership(msg.sender); // owner needs to call claimOwnership()
683         emit PassportCreated(pass, msg.sender);
684         return pass;
685     }
686 
687     function _setRegistry(IPassportLogicRegistry _registry) internal {
688         require(address(_registry) != 0x0);
689         registry = _registry;
690     }
691 }