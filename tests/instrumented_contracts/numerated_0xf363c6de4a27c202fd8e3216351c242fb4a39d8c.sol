1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Proxy
5  * @dev Implements delegation of calls to other contracts, with proper
6  * forwarding of return values and bubbling of failures.
7  * It defines a fallback function that delegates all calls to the address
8  * returned by the abstract _implementation() internal function.
9  */
10 contract Proxy {
11   /**
12    * @dev Fallback function.
13    * Implemented entirely in `_fallback`.
14    */
15   function () payable external {
16     _fallback();
17   }
18 
19   /**
20    * @return The Address of the implementation.
21    */
22   function _implementation() internal view returns (address);
23 
24   /**
25    * @dev Delegates execution to an implementation contract.
26    * This is a low level function that doesn't return to its internal call site.
27    * It will return to the external caller whatever the implementation returns.
28    * @param implementation Address to delegate.
29    */
30   function _delegate(address implementation) internal {
31     assembly {
32       // Copy msg.data. We take full control of memory in this inline assembly
33       // block because it will not return to Solidity code. We overwrite the
34       // Solidity scratch pad at memory position 0.
35       calldatacopy(0, 0, calldatasize)
36 
37       // Call the implementation.
38       // out and outsize are 0 because we don't know the size yet.
39       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
40 
41       // Copy the returned data.
42       returndatacopy(0, 0, returndatasize)
43 
44       switch result
45       // delegatecall returns 0 on error.
46       case 0 { revert(0, returndatasize) }
47       default { return(0, returndatasize) }
48     }
49   }
50 
51   /**
52    * @dev Function that is run as the first thing in the fallback function.
53    * Can be redefined in derived contracts to add functionality.
54    * Redefinitions must call super._willFallback().
55    */
56   function _willFallback() internal {
57   }
58 
59   /**
60    * @dev fallback implementation.
61    * Extracted to enable manual triggering.
62    */
63   function _fallback() internal {
64     _willFallback();
65     _delegate(_implementation());
66   }
67 }
68 
69 /**
70  * Utility library of inline functions on addresses
71  */
72 library AddressUtils {
73 
74   /**
75    * Returns whether the target address is a contract
76    * @dev This function will return false if invoked during the constructor of a contract,
77    *  as the code is not actually created until after the constructor finishes.
78    * @param addr address to check
79    * @return whether the target address is a contract
80    */
81   function isContract(address addr) internal view returns (bool) {
82     uint256 size;
83     // XXX Currently there is no better way to check if there is a contract in an address
84     // than to check the size of the code at that address.
85     // See https://ethereum.stackexchange.com/a/14016/36603
86     // for more details about how this works.
87     // TODO Check this again before the Serenity release, because all addresses will be
88     // contracts then.
89     // solium-disable-next-line security/no-inline-assembly
90     assembly { size := extcodesize(addr) }
91     return size > 0;
92   }
93 
94 }
95 
96 /**
97  * @title UpgradeabilityProxy
98  * @dev This contract implements a proxy that allows to change the
99  * implementation address to which it will delegate.
100  * Such a change is called an implementation upgrade.
101  */
102 contract UpgradeabilityProxy is Proxy {
103   /**
104    * @dev Emitted when the implementation is upgraded.
105    * @param implementation Address of the new implementation.
106    */
107   event Upgraded(address implementation);
108 
109   /**
110    * @dev Storage slot with the address of the current implementation.
111    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
112    * validated in the constructor.
113    */
114   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
115 
116   /**
117    * @dev Contract constructor.
118    * @param _implementation Address of the initial implementation.
119    */
120   constructor(address _implementation) public {
121     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
122 
123     _setImplementation(_implementation);
124   }
125 
126   /**
127    * @dev Returns the current implementation.
128    * @return Address of the current implementation
129    */
130   function _implementation() internal view returns (address impl) {
131     bytes32 slot = IMPLEMENTATION_SLOT;
132     assembly {
133       impl := sload(slot)
134     }
135   }
136 
137   /**
138    * @dev Upgrades the proxy to a new implementation.
139    * @param newImplementation Address of the new implementation.
140    */
141   function _upgradeTo(address newImplementation) internal {
142     _setImplementation(newImplementation);
143     emit Upgraded(newImplementation);
144   }
145 
146   /**
147    * @dev Sets the implementation address of the proxy.
148    * @param newImplementation Address of the new implementation.
149    */
150   function _setImplementation(address newImplementation) private {
151     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
152 
153     bytes32 slot = IMPLEMENTATION_SLOT;
154 
155     assembly {
156       sstore(slot, newImplementation)
157     }
158   }
159 }
160 
161 /**
162  * @title Ownable
163  * @dev The Ownable contract has an owner address, and provides basic authorization control
164  * functions, this simplifies the implementation of "user permissions". This adds two-phase
165  * ownership control to OpenZeppelin's Ownable class. In this model, the original owner 
166  * designates a new owner but does not actually transfer ownership. The new owner then accepts 
167  * ownership and completes the transfer.
168  */
169 contract Ownable {
170   address public owner;
171   address public pendingOwner;
172 
173 
174   event OwnershipTransferred(
175     address indexed previousOwner,
176     address indexed newOwner
177   );
178 
179 
180   /**
181    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
182    * account.
183    */
184   constructor() public {
185     owner = msg.sender;
186     pendingOwner = address(0);
187   }
188 
189   /**
190    * @dev Throws if called by any account other than the owner.
191    */
192   modifier onlyOwner() {
193     require(msg.sender == owner);
194     _;
195   }
196 
197   /**
198    * @dev Throws if called by any account other than the owner.
199    */
200   modifier onlyPendingOwner() {
201     require(msg.sender == pendingOwner);
202     _;
203   }
204 
205   /**
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param _newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address _newOwner) public onlyOwner {
210     require(_newOwner != address(0));
211     pendingOwner = _newOwner;
212   }
213 
214   /**
215    * @dev Allows the pendingOwner address to finalize the transfer.
216    */
217   function claimOwnership() onlyPendingOwner public {
218     emit OwnershipTransferred(owner, pendingOwner);
219     owner = pendingOwner;
220     pendingOwner = address(0);
221   }
222 
223 
224 }
225 
226 /**
227 *
228 * @dev Stores permissions and validators and provides setter and getter methods. 
229 * Permissions determine which methods users have access to call. Validators
230 * are able to mutate permissions at the Regulator level.
231 *
232 */
233 contract RegulatorStorage is Ownable {
234     
235     /** 
236         Structs 
237     */
238 
239     /* Contains metadata about a permission to execute a particular method signature. */
240     struct Permission {
241         string name; // A one-word description for the permission. e.g. "canMint"
242         string description; // A longer description for the permission. e.g. "Allows user to mint tokens."
243         string contract_name; // e.g. "PermissionedToken"
244         bool active; // Permissions can be turned on or off by regulator
245     }
246 
247     /** 
248         Constants: stores method signatures. These are potential permissions that a user can have, 
249         and each permission gives the user the ability to call the associated PermissionedToken method signature
250     */
251     bytes4 public constant MINT_SIG = bytes4(keccak256("mint(address,uint256)"));
252     bytes4 public constant MINT_CUSD_SIG = bytes4(keccak256("mintCUSD(address,uint256)"));
253     bytes4 public constant CONVERT_WT_SIG = bytes4(keccak256("convertWT(uint256)"));
254     bytes4 public constant BURN_SIG = bytes4(keccak256("burn(uint256)"));
255     bytes4 public constant CONVERT_CARBON_DOLLAR_SIG = bytes4(keccak256("convertCarbonDollar(address,uint256)"));
256     bytes4 public constant BURN_CARBON_DOLLAR_SIG = bytes4(keccak256("burnCarbonDollar(address,uint256)"));
257     bytes4 public constant DESTROY_BLACKLISTED_TOKENS_SIG = bytes4(keccak256("destroyBlacklistedTokens(address,uint256)"));
258     bytes4 public constant APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG = bytes4(keccak256("approveBlacklistedAddressSpender(address)"));
259     bytes4 public constant BLACKLISTED_SIG = bytes4(keccak256("blacklisted()"));
260 
261     /** 
262         Mappings 
263     */
264 
265     /* each method signature maps to a Permission */
266     mapping (bytes4 => Permission) public permissions;
267     /* list of validators, either active or inactive */
268     mapping (address => bool) public validators;
269     /* each user can be given access to a given method signature */
270     mapping (address => mapping (bytes4 => bool)) public userPermissions;
271 
272     /** 
273         Events 
274     */
275     event PermissionAdded(bytes4 methodsignature);
276     event PermissionRemoved(bytes4 methodsignature);
277     event ValidatorAdded(address indexed validator);
278     event ValidatorRemoved(address indexed validator);
279 
280     /** 
281         Modifiers 
282     */
283     /**
284     * @notice Throws if called by any account that does not have access to set attributes
285     */
286     modifier onlyValidator() {
287         require (isValidator(msg.sender), "Sender must be validator");
288         _;
289     }
290 
291     /**
292     * @notice Sets a permission within the list of permissions.
293     * @param _methodsignature Signature of the method that this permission controls.
294     * @param _permissionName A "slug" name for this permission (e.g. "canMint").
295     * @param _permissionDescription A lengthier description for this permission (e.g. "Allows user to mint tokens").
296     * @param _contractName Name of the contract that the method belongs to.
297     */
298     function addPermission(
299         bytes4 _methodsignature, 
300         string _permissionName, 
301         string _permissionDescription, 
302         string _contractName) public onlyValidator { 
303         Permission memory p = Permission(_permissionName, _permissionDescription, _contractName, true);
304         permissions[_methodsignature] = p;
305         emit PermissionAdded(_methodsignature);
306     }
307 
308     /**
309     * @notice Removes a permission the list of permissions.
310     * @param _methodsignature Signature of the method that this permission controls.
311     */
312     function removePermission(bytes4 _methodsignature) public onlyValidator {
313         permissions[_methodsignature].active = false;
314         emit PermissionRemoved(_methodsignature);
315     }
316     
317     /**
318     * @notice Sets a permission in the list of permissions that a user has.
319     * @param _methodsignature Signature of the method that this permission controls.
320     */
321     function setUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
322         require(permissions[_methodsignature].active, "Permission being set must be for a valid method signature");
323         userPermissions[_who][_methodsignature] = true;
324     }
325 
326     /**
327     * @notice Removes a permission from the list of permissions that a user has.
328     * @param _methodsignature Signature of the method that this permission controls.
329     */
330     function removeUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
331         require(permissions[_methodsignature].active, "Permission being removed must be for a valid method signature");
332         userPermissions[_who][_methodsignature] = false;
333     }
334 
335     /**
336     * @notice add a Validator
337     * @param _validator Address of validator to add
338     */
339     function addValidator(address _validator) public onlyOwner {
340         validators[_validator] = true;
341         emit ValidatorAdded(_validator);
342     }
343 
344     /**
345     * @notice remove a Validator
346     * @param _validator Address of validator to remove
347     */
348     function removeValidator(address _validator) public onlyOwner {
349         validators[_validator] = false;
350         emit ValidatorRemoved(_validator);
351     }
352 
353     /**
354     * @notice does validator exist?
355     * @return true if yes, false if no
356     **/
357     function isValidator(address _validator) public view returns (bool) {
358         return validators[_validator];
359     }
360 
361     /**
362     * @notice does permission exist?
363     * @return true if yes, false if no
364     **/
365     function isPermission(bytes4 _methodsignature) public view returns (bool) {
366         return permissions[_methodsignature].active;
367     }
368 
369     /**
370     * @notice get Permission structure
371     * @param _methodsignature request to retrieve the Permission struct for this methodsignature
372     * @return Permission
373     **/
374     function getPermission(bytes4 _methodsignature) public view returns 
375         (string name, 
376          string description, 
377          string contract_name,
378          bool active) {
379         return (permissions[_methodsignature].name,
380                 permissions[_methodsignature].description,
381                 permissions[_methodsignature].contract_name,
382                 permissions[_methodsignature].active);
383     }
384 
385     /**
386     * @notice does permission exist?
387     * @return true if yes, false if no
388     **/
389     function hasUserPermission(address _who, bytes4 _methodsignature) public view returns (bool) {
390         return userPermissions[_who][_methodsignature];
391     }
392 }
393 
394 /**
395  * @title RegulatorProxy
396  * @dev A RegulatorProxy is a proxy contract that acts identically to a Regulator from the
397  * user's point of view. A proxy can change its data storage locations and can also
398  * change its implementation contract location. A call to RegulatorProxy delegates the function call
399  * to the latest implementation contract's version of the function and the proxy then
400  * calls that function in the context of the proxy's data storage
401  *
402  */
403 contract RegulatorProxy is UpgradeabilityProxy, RegulatorStorage {
404 
405     
406     /**
407     * @dev CONSTRUCTOR
408     * @param _implementation the contract who's logic the proxy will initially delegate functionality to
409     **/
410     constructor(address _implementation) public UpgradeabilityProxy(_implementation) {}
411 
412     /**
413     * @dev Upgrade the backing implementation of the proxy.
414     * Only the admin can call this function.
415     * @param newImplementation Address of the new implementation.
416     */
417     function upgradeTo(address newImplementation) public onlyOwner {
418         _upgradeTo(newImplementation);
419 
420     }
421 
422       /**
423     * @return The address of the implementation.
424     */
425     function implementation() public view returns (address) {
426         return _implementation();
427     }
428 }
429 
430 /**
431  * @title Regulator
432  * @dev Regulator can be configured to meet relevant securities regulations, KYC policies
433  * AML requirements, tax laws, and more. The Regulator ensures that the PermissionedToken
434  * makes compliant transfers possible. Contains the userPermissions necessary
435  * for regulatory compliance.
436  *
437  */
438 contract Regulator is RegulatorStorage {
439     
440     /** 
441         Modifiers 
442     */
443     /**
444     * @notice Throws if called by any account that does not have access to set attributes
445     */
446     modifier onlyValidator() {
447         require (isValidator(msg.sender), "Sender must be validator");
448         _;
449     }
450 
451     /** 
452         Events 
453     */
454     event LogWhitelistedUser(address indexed who);
455     event LogBlacklistedUser(address indexed who);
456     event LogNonlistedUser(address indexed who);
457     event LogSetMinter(address indexed who);
458     event LogRemovedMinter(address indexed who);
459     event LogSetBlacklistDestroyer(address indexed who);
460     event LogRemovedBlacklistDestroyer(address indexed who);
461     event LogSetBlacklistSpender(address indexed who);
462     event LogRemovedBlacklistSpender(address indexed who);
463 
464     /**
465     * @notice Sets the necessary permissions for a user to mint tokens.
466     * @param _who The address of the account that we are setting permissions for.
467     */
468     function setMinter(address _who) public onlyValidator {
469         _setMinter(_who);
470     }
471 
472     /**
473     * @notice Removes the necessary permissions for a user to mint tokens.
474     * @param _who The address of the account that we are removing permissions for.
475     */
476     function removeMinter(address _who) public onlyValidator {
477         _removeMinter(_who);
478     }
479 
480     /**
481     * @notice Sets the necessary permissions for a user to spend tokens from a blacklisted account.
482     * @param _who The address of the account that we are setting permissions for.
483     */
484     function setBlacklistSpender(address _who) public onlyValidator {
485         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
486         setUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
487         emit LogSetBlacklistSpender(_who);
488     }
489     
490     /**
491     * @notice Removes the necessary permissions for a user to spend tokens from a blacklisted account.
492     * @param _who The address of the account that we are removing permissions for.
493     */
494     function removeBlacklistSpender(address _who) public onlyValidator {
495         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
496         removeUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
497         emit LogRemovedBlacklistSpender(_who);
498     }
499 
500     /**
501     * @notice Sets the necessary permissions for a user to destroy tokens from a blacklisted account.
502     * @param _who The address of the account that we are setting permissions for.
503     */
504     function setBlacklistDestroyer(address _who) public onlyValidator {
505         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
506         setUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
507         emit LogSetBlacklistDestroyer(_who);
508     }
509     
510 
511     /**
512     * @notice Removes the necessary permissions for a user to destroy tokens from a blacklisted account.
513     * @param _who The address of the account that we are removing permissions for.
514     */
515     function removeBlacklistDestroyer(address _who) public onlyValidator {
516         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
517         removeUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
518         emit LogRemovedBlacklistDestroyer(_who);
519     }
520 
521     /**
522     * @notice Sets the necessary permissions for a "whitelisted" user.
523     * @param _who The address of the account that we are setting permissions for.
524     */
525     function setWhitelistedUser(address _who) public onlyValidator {
526         _setWhitelistedUser(_who);
527     }
528 
529     /**
530     * @notice Sets the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
531     * frozen; they cannot transfer, burn, or withdraw any tokens.
532     * @param _who The address of the account that we are setting permissions for.
533     */
534     function setBlacklistedUser(address _who) public onlyValidator {
535         _setBlacklistedUser(_who);
536     }
537 
538     /**
539     * @notice Sets the necessary permissions for a "nonlisted" user. Nonlisted users can trade tokens,
540     * but cannot burn them (and therefore cannot convert them into fiat.)
541     * @param _who The address of the account that we are setting permissions for.
542     */
543     function setNonlistedUser(address _who) public onlyValidator {
544         _setNonlistedUser(_who);
545     }
546 
547     /** Returns whether or not a user is whitelisted.
548      * @param _who The address of the account in question.
549      * @return `true` if the user is whitelisted, `false` otherwise.
550      */
551     function isWhitelistedUser(address _who) public view returns (bool) {
552         return (hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
553     }
554 
555     /** Returns whether or not a user is blacklisted.
556      * @param _who The address of the account in question.
557      * @return `true` if the user is blacklisted, `false` otherwise.
558      */
559     function isBlacklistedUser(address _who) public view returns (bool) {
560         return (!hasUserPermission(_who, BURN_SIG) && hasUserPermission(_who, BLACKLISTED_SIG));
561     }
562 
563     /** Returns whether or not a user is nonlisted.
564      * @param _who The address of the account in question.
565      * @return `true` if the user is nonlisted, `false` otherwise.
566      */
567     function isNonlistedUser(address _who) public view returns (bool) {
568         return (!hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
569     }
570 
571     /** Returns whether or not a user is a blacklist spender.
572      * @param _who The address of the account in question.
573      * @return `true` if the user is a blacklist spender, `false` otherwise.
574      */
575     function isBlacklistSpender(address _who) public view returns (bool) {
576         return hasUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
577     }
578 
579     /** Returns whether or not a user is a blacklist destroyer.
580      * @param _who The address of the account in question.
581      * @return `true` if the user is a blacklist destroyer, `false` otherwise.
582      */
583     function isBlacklistDestroyer(address _who) public view returns (bool) {
584         return hasUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
585     }
586 
587     /** Returns whether or not a user is a minter.
588      * @param _who The address of the account in question.
589      * @return `true` if the user is a minter, `false` otherwise.
590      */
591     function isMinter(address _who) public view returns (bool) {
592         return hasUserPermission(_who, MINT_SIG);
593     }
594 
595     /** Internal Functions **/
596 
597     function _setMinter(address _who) internal {
598         require(isPermission(MINT_SIG), "Minting not supported by token");
599         setUserPermission(_who, MINT_SIG);
600         emit LogSetMinter(_who);
601     }
602 
603     function _removeMinter(address _who) internal {
604         require(isPermission(MINT_SIG), "Minting not supported by token");
605         removeUserPermission(_who, MINT_SIG);
606         emit LogRemovedMinter(_who);
607     }
608 
609     function _setNonlistedUser(address _who) internal {
610         require(isPermission(BURN_SIG), "Burn method not supported by token");
611         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
612         removeUserPermission(_who, BURN_SIG);
613         removeUserPermission(_who, BLACKLISTED_SIG);
614         emit LogNonlistedUser(_who);
615     }
616 
617     function _setBlacklistedUser(address _who) internal {
618         require(isPermission(BURN_SIG), "Burn method not supported by token");
619         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
620         removeUserPermission(_who, BURN_SIG);
621         setUserPermission(_who, BLACKLISTED_SIG);
622         emit LogBlacklistedUser(_who);
623     }
624 
625     function _setWhitelistedUser(address _who) internal {
626         require(isPermission(BURN_SIG), "Burn method not supported by token");
627         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
628         setUserPermission(_who, BURN_SIG);
629         removeUserPermission(_who, BLACKLISTED_SIG);
630         emit LogWhitelistedUser(_who);
631     }
632 }
633 
634 /**
635 *
636 * @dev RegulatorProxyFactory creates new RegulatorProxy contracts with new data storage sheets, properly configured
637 * with ownership, and the proxy logic implementations are based on a user-specified Regulator. 
638 *
639 **/
640 contract RegulatorProxyFactory {
641 
642     // TODO: Instead of a single array of addresses, this should be a mapping or an array
643     // of objects of type { address: ...new_regulator, type: whitelisted_or_cusd }
644     address[] public regulators;
645 
646     // Events
647     event CreatedRegulatorProxy(address newRegulator, uint256 index);
648 
649     /**
650     *
651     * @dev generate a new proxyaddress that users can cast to a Regulator or RegulatorProxy. The
652     * proxy has empty data storage contracts connected to it and it is set with an initial logic contract
653     * to which it will delegate functionality
654     * @notice the method caller will have to claim ownership of regulators since regulators are claimable
655     * @param regulatorImplementation the address of the logic contract that the proxy will initialize its implementation to
656     *
657     **/
658     function createRegulatorProxy(address regulatorImplementation) public {
659 
660         // Store new data storage contracts for regulator proxy
661         address proxy = address(new RegulatorProxy(regulatorImplementation));
662         Regulator newRegulator = Regulator(proxy);
663 
664         // Testing: Add msg.sender as a validator, add all permissions
665         newRegulator.addValidator(msg.sender);
666         addAllPermissions(newRegulator);
667 
668         // The function caller should own the proxy contract, so they will need to claim ownership
669         RegulatorProxy(proxy).transferOwnership(msg.sender);
670 
671         regulators.push(proxy);
672         emit CreatedRegulatorProxy(proxy, getCount()-1);
673     }
674 
675     /**
676     *
677     * @dev Add all permission signatures to regulator
678     *
679     **/
680     function addAllPermissions(Regulator regulator) public {
681 
682         // Make this contract a temporary validator to add all permissions
683         regulator.addValidator(this);
684         regulator.addPermission(regulator.MINT_SIG(), "", "", "" );
685         regulator.addPermission(regulator.BURN_SIG(), "", "", "" );
686         regulator.addPermission(regulator.DESTROY_BLACKLISTED_TOKENS_SIG(), "", "", "" );
687         regulator.addPermission(regulator.APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG(), "", "", "" );
688         regulator.addPermission(regulator.BLACKLISTED_SIG(), "", "", "" );
689         regulator.addPermission(regulator.CONVERT_CARBON_DOLLAR_SIG(), "", "", "" );
690         regulator.addPermission(regulator.BURN_CARBON_DOLLAR_SIG(), "", "", "" );
691         regulator.addPermission(regulator.MINT_CUSD_SIG(), "", "", "" );
692         regulator.addPermission(regulator.CONVERT_WT_SIG(), "", "", "" );
693         regulator.removeValidator(this);
694     }
695 
696     // Return number of proxies created 
697     function getCount() public view returns (uint256) {
698         return regulators.length;
699     }
700 
701     // Return the i'th created proxy. The most recently created proxy will be at position getCount()-1.
702     function getRegulatorProxy(uint256 i) public view returns(address) {
703         require((i < regulators.length) && (i >= 0), "Invalid index");
704         return regulators[i];
705     }
706 }