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
237 // File: contracts/ownership/OwnableProxy.sol
238 
239 /**
240  * @title OwnableProxy
241  */
242 contract OwnableProxy {
243     event OwnershipRenounced(address indexed previousOwner);
244     event OwnershipTransferred(
245         address indexed previousOwner,
246         address indexed newOwner
247     );
248 
249     /**
250      * @dev Storage slot with the owner of the contract.
251      * This is the keccak-256 hash of "org.monetha.proxy.owner", and is
252      * validated in the constructor.
253      */
254     bytes32 private constant OWNER_SLOT = 0x3ca57e4b51fc2e18497b219410298879868edada7e6fe5132c8feceb0a080d22;
255 
256     /**
257      * @dev The OwnableProxy constructor sets the original `owner` of the contract to the sender
258      * account.
259      */
260     constructor() public {
261         assert(OWNER_SLOT == keccak256("org.monetha.proxy.owner"));
262 
263         _setOwner(msg.sender);
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(msg.sender == _getOwner());
271         _;
272     }
273 
274     /**
275      * @dev Allows the current owner to relinquish control of the contract.
276      * @notice Renouncing to ownership will leave the contract without an owner.
277      * It will not be possible to call the functions with the `onlyOwner`
278      * modifier anymore.
279      */
280     function renounceOwnership() public onlyOwner {
281         emit OwnershipRenounced(_getOwner());
282         _setOwner(address(0));
283     }
284 
285     /**
286      * @dev Allows the current owner to transfer control of the contract to a newOwner.
287      * @param _newOwner The address to transfer ownership to.
288      */
289     function transferOwnership(address _newOwner) public onlyOwner {
290         _transferOwnership(_newOwner);
291     }
292 
293     /**
294      * @dev Transfers control of the contract to a newOwner.
295      * @param _newOwner The address to transfer ownership to.
296      */
297     function _transferOwnership(address _newOwner) internal {
298         require(_newOwner != address(0));
299         emit OwnershipTransferred(_getOwner(), _newOwner);
300         _setOwner(_newOwner);
301     }
302 
303     /**
304      * @return The owner address.
305      */
306     function owner() public view returns (address) {
307         return _getOwner();
308     }
309 
310     /**
311      * @return The owner address.
312      */
313     function _getOwner() internal view returns (address own) {
314         bytes32 slot = OWNER_SLOT;
315         assembly {
316             own := sload(slot)
317         }
318     }
319 
320     /**
321      * @dev Sets the address of the proxy owner.
322      * @param _newOwner Address of the new proxy owner.
323      */
324     function _setOwner(address _newOwner) internal {
325         bytes32 slot = OWNER_SLOT;
326 
327         assembly {
328             sstore(slot, _newOwner)
329         }
330     }
331 }
332 
333 // File: contracts/ownership/ClaimableProxy.sol
334 
335 /**
336  * @title ClaimableProxy
337  * @dev Extension for the OwnableProxy contract, where the ownership needs to be claimed.
338  * This allows the new owner to accept the transfer.
339  */
340 contract ClaimableProxy is OwnableProxy {
341     /**
342      * @dev Storage slot with the pending owner of the contract.
343      * This is the keccak-256 hash of "org.monetha.proxy.pendingOwner", and is
344      * validated in the constructor.
345      */
346     bytes32 private constant PENDING_OWNER_SLOT = 0xcfd0c6ea5352192d7d4c5d4e7a73c5da12c871730cb60ff57879cbe7b403bb52;
347 
348     /**
349      * @dev The ClaimableProxy constructor validates PENDING_OWNER_SLOT constant.
350      */
351     constructor() public {
352         assert(PENDING_OWNER_SLOT == keccak256("org.monetha.proxy.pendingOwner"));
353     }
354 
355     function pendingOwner() public view returns (address) {
356         return _getPendingOwner();
357     }
358 
359     /**
360      * @dev Modifier throws if called by any account other than the pendingOwner.
361      */
362     modifier onlyPendingOwner() {
363         require(msg.sender == _getPendingOwner());
364         _;
365     }
366 
367     /**
368      * @dev Allows the current owner to set the pendingOwner address.
369      * @param newOwner The address to transfer ownership to.
370      */
371     function transferOwnership(address newOwner) public onlyOwner {
372         _setPendingOwner(newOwner);
373     }
374 
375     /**
376      * @dev Allows the pendingOwner address to finalize the transfer.
377      */
378     function claimOwnership() public onlyPendingOwner {
379         emit OwnershipTransferred(_getOwner(), _getPendingOwner());
380         _setOwner(_getPendingOwner());
381         _setPendingOwner(address(0));
382     }
383 
384     /**
385      * @return The pending owner address.
386      */
387     function _getPendingOwner() internal view returns (address penOwn) {
388         bytes32 slot = PENDING_OWNER_SLOT;
389         assembly {
390             penOwn := sload(slot)
391         }
392     }
393 
394     /**
395      * @dev Sets the address of the pending owner.
396      * @param _newPendingOwner Address of the new pending owner.
397      */
398     function _setPendingOwner(address _newPendingOwner) internal {
399         bytes32 slot = PENDING_OWNER_SLOT;
400 
401         assembly {
402             sstore(slot, _newPendingOwner)
403         }
404     }
405 }
406 
407 // File: contracts/lifecycle/DestructibleProxy.sol
408 
409 /**
410  * @title Destructible
411  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
412  */
413 contract DestructibleProxy is OwnableProxy {
414     /**
415      * @dev Transfers the current balance to the owner and terminates the contract.
416      */
417     function destroy() public onlyOwner {
418         selfdestruct(_getOwner());
419     }
420 
421     function destroyAndSend(address _recipient) public onlyOwner {
422         selfdestruct(_recipient);
423     }
424 }
425 
426 // File: contracts/IPassportLogicRegistry.sol
427 
428 interface IPassportLogicRegistry {
429     /**
430      * @dev This event will be emitted every time a new passport logic implementation is registered
431      * @param version representing the version name of the registered passport logic implementation
432      * @param implementation representing the address of the registered passport logic implementation
433      */
434     event PassportLogicAdded(string version, address implementation);
435 
436     /**
437      * @dev This event will be emitted every time a new passport logic implementation is set as current one
438      * @param version representing the version name of the current passport logic implementation
439      * @param implementation representing the address of the current passport logic implementation
440      */
441     event CurrentPassportLogicSet(string version, address implementation);
442 
443     /**
444      * @dev Tells the address of the passport logic implementation for a given version
445      * @param _version to query the implementation of
446      * @return address of the passport logic implementation registered for the given version
447      */
448     function getPassportLogic(string _version) external view returns (address);
449 
450     /**
451      * @dev Tells the version of the current passport logic implementation
452      * @return version of the current passport logic implementation
453      */
454     function getCurrentPassportLogicVersion() external view returns (string);
455 
456     /**
457      * @dev Tells the address of the current passport logic implementation
458      * @return address of the current passport logic implementation
459      */
460     function getCurrentPassportLogic() external view returns (address);
461 }
462 
463 // File: contracts/upgradeability/Proxy.sol
464 
465 /**
466  * @title Proxy
467  * @dev Implements delegation of calls to other contracts, with proper
468  * forwarding of return values and bubbling of failures.
469  * It defines a fallback function that delegates all calls to the address
470  * returned by the abstract _implementation() internal function.
471  */
472 contract Proxy {
473     /**
474      * @dev Fallback function.
475      * Implemented entirely in `_fallback`.
476      */
477     function () payable external {
478         _delegate(_implementation());
479     }
480 
481     /**
482      * @return The Address of the implementation.
483      */
484     function _implementation() internal view returns (address);
485 
486     /**
487      * @dev Delegates execution to an implementation contract.
488      * This is a low level function that doesn't return to its internal call site.
489      * It will return to the external caller whatever the implementation returns.
490      * @param implementation Address to delegate.
491      */
492     function _delegate(address implementation) internal {
493         assembly {
494         // Copy msg.data. We take full control of memory in this inline assembly
495         // block because it will not return to Solidity code. We overwrite the
496         // Solidity scratch pad at memory position 0.
497             calldatacopy(0, 0, calldatasize)
498 
499         // Call the implementation.
500         // out and outsize are 0 because we don't know the size yet.
501             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
502 
503         // Copy the returned data.
504             returndatacopy(0, 0, returndatasize)
505 
506             switch result
507             // delegatecall returns 0 on error.
508             case 0 { revert(0, returndatasize) }
509             default { return(0, returndatasize) }
510         }
511     }
512 }
513 
514 // File: contracts/Passport.sol
515 
516 /**
517  * @title Passport
518  */
519 contract Passport is Proxy, ClaimableProxy, DestructibleProxy {
520 
521     event PassportLogicRegistryChanged(
522         address indexed previousRegistry,
523         address indexed newRegistry
524     );
525 
526     /**
527      * @dev Storage slot with the address of the current registry of the passport implementations.
528      * This is the keccak-256 hash of "org.monetha.passport.proxy.registry", and is
529      * validated in the constructor.
530      */
531     bytes32 private constant REGISTRY_SLOT = 0xa04bab69e45aeb4c94a78ba5bc1be67ef28977c4fdf815a30b829a794eb67a4a;
532 
533     /**
534      * @dev Contract constructor.
535      * @param _registry Address of the passport implementations registry.
536      */
537     constructor(IPassportLogicRegistry _registry) public {
538         assert(REGISTRY_SLOT == keccak256("org.monetha.passport.proxy.registry"));
539 
540         _setRegistry(_registry);
541     }
542 
543     /**
544      * @return the address of passport logic registry.
545      */
546     function getPassportLogicRegistry() public view returns (address) {
547         return _getRegistry();
548     }
549 
550     /**
551      * @dev Returns the current passport logic implementation (used in Proxy fallback function to delegate call
552      * to passport logic implementation).
553      * @return Address of the current passport implementation
554      */
555     function _implementation() internal view returns (address) {
556         return _getRegistry().getCurrentPassportLogic();
557     }
558 
559     /**
560      * @dev Returns the current passport implementations registry.
561      * @return Address of the current implementation
562      */
563     function _getRegistry() internal view returns (IPassportLogicRegistry reg) {
564         bytes32 slot = REGISTRY_SLOT;
565         assembly {
566             reg := sload(slot)
567         }
568     }
569 
570     function _setRegistry(IPassportLogicRegistry _registry) internal {
571         require(address(_registry) != 0x0, "Cannot set registry to a zero address");
572 
573         bytes32 slot = REGISTRY_SLOT;
574         assembly {
575             sstore(slot, _registry)
576         }
577     }
578 }
579 
580 // File: contracts/PassportFactory.sol
581 
582 /**
583  * @title PassportFactory
584  * @dev This contract works as a passport factory.
585  */
586 contract PassportFactory is Ownable, HasNoEther, HasNoTokens {
587     IPassportLogicRegistry private registry;
588 
589     /**
590     * @dev This event will be emitted every time a new passport is created
591     * @param passport representing the address of the passport created
592     * @param owner representing the address of the passport owner
593     */
594     event PassportCreated(address indexed passport, address indexed owner);
595 
596     /**
597     * @dev This event will be emitted every time a passport logic registry is changed
598     * @param oldRegistry representing the address of the old passport logic registry
599     * @param newRegistry representing the address of the new passport logic registry
600     */
601     event PassportLogicRegistryChanged(address indexed oldRegistry, address indexed newRegistry);
602 
603     constructor(IPassportLogicRegistry _registry) public {
604         _setRegistry(_registry);
605     }
606 
607     function setRegistry(IPassportLogicRegistry _registry) public onlyOwner {
608         emit PassportLogicRegistryChanged(registry, _registry);
609         _setRegistry(_registry);
610     }
611 
612     function getRegistry() external view returns (address) {
613         return registry;
614     }
615 
616     /**
617     * @dev Creates new passport. The method should be called by the owner of the created passport.
618     * After the passport is created, the owner must call the claimOwnership() passport method to become a full owner.
619     * @return address of the created passport
620     */
621     function createPassport() public returns (Passport) {
622         Passport pass = new Passport(registry);
623         pass.transferOwnership(msg.sender); // owner needs to call claimOwnership()
624         emit PassportCreated(pass, msg.sender);
625         return pass;
626     }
627 
628     function _setRegistry(IPassportLogicRegistry _registry) internal {
629         require(address(_registry) != 0x0);
630         registry = _registry;
631     }
632 }