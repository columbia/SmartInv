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
253     bytes4 public constant DESTROY_BLACKLISTED_TOKENS_SIG = bytes4(keccak256("destroyBlacklistedTokens(address,uint256)"));
254     bytes4 public constant APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG = bytes4(keccak256("approveBlacklistedAddressSpender(address)"));
255     bytes4 public constant BLACKLISTED_SIG = bytes4(keccak256("blacklisted()"));
256 
257     /** 
258         Mappings 
259     */
260 
261     /* each method signature maps to a Permission */
262     mapping (bytes4 => Permission) public permissions;
263     /* list of validators, either active or inactive */
264     mapping (address => bool) public validators;
265     /* each user can be given access to a given method signature */
266     mapping (address => mapping (bytes4 => bool)) public userPermissions;
267 
268     /** 
269         Events 
270     */
271     event PermissionAdded(bytes4 methodsignature);
272     event PermissionRemoved(bytes4 methodsignature);
273     event ValidatorAdded(address indexed validator);
274     event ValidatorRemoved(address indexed validator);
275 
276     /** 
277         Modifiers 
278     */
279     /**
280     * @notice Throws if called by any account that does not have access to set attributes
281     */
282     modifier onlyValidator() {
283         require (isValidator(msg.sender), "Sender must be validator");
284         _;
285     }
286 
287     /**
288     * @notice Sets a permission within the list of permissions.
289     * @param _methodsignature Signature of the method that this permission controls.
290     * @param _permissionName A "slug" name for this permission (e.g. "canMint").
291     * @param _permissionDescription A lengthier description for this permission (e.g. "Allows user to mint tokens").
292     * @param _contractName Name of the contract that the method belongs to.
293     */
294     function addPermission(
295         bytes4 _methodsignature, 
296         string _permissionName, 
297         string _permissionDescription, 
298         string _contractName) public onlyValidator { 
299         Permission memory p = Permission(_permissionName, _permissionDescription, _contractName, true);
300         permissions[_methodsignature] = p;
301         emit PermissionAdded(_methodsignature);
302     }
303 
304     /**
305     * @notice Removes a permission the list of permissions.
306     * @param _methodsignature Signature of the method that this permission controls.
307     */
308     function removePermission(bytes4 _methodsignature) public onlyValidator {
309         permissions[_methodsignature].active = false;
310         emit PermissionRemoved(_methodsignature);
311     }
312     
313     /**
314     * @notice Sets a permission in the list of permissions that a user has.
315     * @param _methodsignature Signature of the method that this permission controls.
316     */
317     function setUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
318         require(permissions[_methodsignature].active, "Permission being set must be for a valid method signature");
319         userPermissions[_who][_methodsignature] = true;
320     }
321 
322     /**
323     * @notice Removes a permission from the list of permissions that a user has.
324     * @param _methodsignature Signature of the method that this permission controls.
325     */
326     function removeUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
327         require(permissions[_methodsignature].active, "Permission being removed must be for a valid method signature");
328         userPermissions[_who][_methodsignature] = false;
329     }
330 
331     /**
332     * @notice add a Validator
333     * @param _validator Address of validator to add
334     */
335     function addValidator(address _validator) public onlyOwner {
336         validators[_validator] = true;
337         emit ValidatorAdded(_validator);
338     }
339 
340     /**
341     * @notice remove a Validator
342     * @param _validator Address of validator to remove
343     */
344     function removeValidator(address _validator) public onlyOwner {
345         validators[_validator] = false;
346         emit ValidatorRemoved(_validator);
347     }
348 
349     /**
350     * @notice does validator exist?
351     * @return true if yes, false if no
352     **/
353     function isValidator(address _validator) public view returns (bool) {
354         return validators[_validator];
355     }
356 
357     /**
358     * @notice does permission exist?
359     * @return true if yes, false if no
360     **/
361     function isPermission(bytes4 _methodsignature) public view returns (bool) {
362         return permissions[_methodsignature].active;
363     }
364 
365     /**
366     * @notice get Permission structure
367     * @param _methodsignature request to retrieve the Permission struct for this methodsignature
368     * @return Permission
369     **/
370     function getPermission(bytes4 _methodsignature) public view returns 
371         (string name, 
372          string description, 
373          string contract_name,
374          bool active) {
375         return (permissions[_methodsignature].name,
376                 permissions[_methodsignature].description,
377                 permissions[_methodsignature].contract_name,
378                 permissions[_methodsignature].active);
379     }
380 
381     /**
382     * @notice does permission exist?
383     * @return true if yes, false if no
384     **/
385     function hasUserPermission(address _who, bytes4 _methodsignature) public view returns (bool) {
386         return userPermissions[_who][_methodsignature];
387     }
388 }
389 
390 /**
391  * @title RegulatorProxy
392  * @dev A RegulatorProxy is a proxy contract that acts identically to a Regulator from the
393  * user's point of view. A proxy can change its data storage locations and can also
394  * change its implementation contract location. A call to RegulatorProxy delegates the function call
395  * to the latest implementation contract's version of the function and the proxy then
396  * calls that function in the context of the proxy's data storage
397  *
398  */
399 contract RegulatorProxy is UpgradeabilityProxy, RegulatorStorage {
400 
401     
402     /**
403     * @dev CONSTRUCTOR
404     * @param _implementation the contract who's logic the proxy will initially delegate functionality to
405     **/
406     constructor(address _implementation) public UpgradeabilityProxy(_implementation) {}
407 
408     /**
409     * @dev Upgrade the backing implementation of the proxy.
410     * Only the admin can call this function.
411     * @param newImplementation Address of the new implementation.
412     */
413     function upgradeTo(address newImplementation) public onlyOwner {
414         _upgradeTo(newImplementation);
415 
416     }
417 
418       /**
419     * @return The address of the implementation.
420     */
421     function implementation() public view returns (address) {
422         return _implementation();
423     }
424 }
425 
426 /**
427  * @title Regulator
428  * @dev Regulator can be configured to meet relevant securities regulations, KYC policies
429  * AML requirements, tax laws, and more. The Regulator ensures that the PermissionedToken
430  * makes compliant transfers possible. Contains the userPermissions necessary
431  * for regulatory compliance.
432  *
433  */
434 contract Regulator is RegulatorStorage {
435     
436     /** 
437         Modifiers 
438     */
439     /**
440     * @notice Throws if called by any account that does not have access to set attributes
441     */
442     modifier onlyValidator() {
443         require (isValidator(msg.sender), "Sender must be validator");
444         _;
445     }
446 
447     /** 
448         Events 
449     */
450     event LogBlacklistedUser(address indexed who);
451     event LogRemovedBlacklistedUser(address indexed who);
452     event LogSetMinter(address indexed who);
453     event LogRemovedMinter(address indexed who);
454     event LogSetBlacklistDestroyer(address indexed who);
455     event LogRemovedBlacklistDestroyer(address indexed who);
456     event LogSetBlacklistSpender(address indexed who);
457     event LogRemovedBlacklistSpender(address indexed who);
458 
459     /**
460     * @notice Sets the necessary permissions for a user to mint tokens.
461     * @param _who The address of the account that we are setting permissions for.
462     */
463     function setMinter(address _who) public onlyValidator {
464         _setMinter(_who);
465     }
466 
467     /**
468     * @notice Removes the necessary permissions for a user to mint tokens.
469     * @param _who The address of the account that we are removing permissions for.
470     */
471     function removeMinter(address _who) public onlyValidator {
472         _removeMinter(_who);
473     }
474 
475     /**
476     * @notice Sets the necessary permissions for a user to spend tokens from a blacklisted account.
477     * @param _who The address of the account that we are setting permissions for.
478     */
479     function setBlacklistSpender(address _who) public onlyValidator {
480         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
481         setUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
482         emit LogSetBlacklistSpender(_who);
483     }
484     
485     /**
486     * @notice Removes the necessary permissions for a user to spend tokens from a blacklisted account.
487     * @param _who The address of the account that we are removing permissions for.
488     */
489     function removeBlacklistSpender(address _who) public onlyValidator {
490         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
491         removeUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
492         emit LogRemovedBlacklistSpender(_who);
493     }
494 
495     /**
496     * @notice Sets the necessary permissions for a user to destroy tokens from a blacklisted account.
497     * @param _who The address of the account that we are setting permissions for.
498     */
499     function setBlacklistDestroyer(address _who) public onlyValidator {
500         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
501         setUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
502         emit LogSetBlacklistDestroyer(_who);
503     }
504     
505 
506     /**
507     * @notice Removes the necessary permissions for a user to destroy tokens from a blacklisted account.
508     * @param _who The address of the account that we are removing permissions for.
509     */
510     function removeBlacklistDestroyer(address _who) public onlyValidator {
511         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
512         removeUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
513         emit LogRemovedBlacklistDestroyer(_who);
514     }
515 
516     /**
517     * @notice Sets the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
518     * frozen; they cannot transfer, burn, or withdraw any tokens.
519     * @param _who The address of the account that we are setting permissions for.
520     */
521     function setBlacklistedUser(address _who) public onlyValidator {
522         _setBlacklistedUser(_who);
523     }
524 
525     /**
526     * @notice Removes the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
527     * frozen; they cannot transfer, burn, or withdraw any tokens.
528     * @param _who The address of the account that we are changing permissions for.
529     */
530     function removeBlacklistedUser(address _who) public onlyValidator {
531         _removeBlacklistedUser(_who);
532     }
533 
534     /** Returns whether or not a user is blacklisted.
535      * @param _who The address of the account in question.
536      * @return `true` if the user is blacklisted, `false` otherwise.
537      */
538     function isBlacklistedUser(address _who) public view returns (bool) {
539         return (hasUserPermission(_who, BLACKLISTED_SIG));
540     }
541 
542 
543     /** Returns whether or not a user is a blacklist spender.
544      * @param _who The address of the account in question.
545      * @return `true` if the user is a blacklist spender, `false` otherwise.
546      */
547     function isBlacklistSpender(address _who) public view returns (bool) {
548         return hasUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
549     }
550 
551     /** Returns whether or not a user is a blacklist destroyer.
552      * @param _who The address of the account in question.
553      * @return `true` if the user is a blacklist destroyer, `false` otherwise.
554      */
555     function isBlacklistDestroyer(address _who) public view returns (bool) {
556         return hasUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
557     }
558 
559     /** Returns whether or not a user is a minter.
560      * @param _who The address of the account in question.
561      * @return `true` if the user is a minter, `false` otherwise.
562      */
563     function isMinter(address _who) public view returns (bool) {
564         return (hasUserPermission(_who, MINT_SIG) && hasUserPermission(_who, MINT_CUSD_SIG));
565     }
566 
567     /** Internal Functions **/
568 
569     function _setMinter(address _who) internal {
570         require(isPermission(MINT_SIG), "Minting not supported by token");
571         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
572         setUserPermission(_who, MINT_SIG);
573         setUserPermission(_who, MINT_CUSD_SIG);
574         emit LogSetMinter(_who);
575     }
576 
577     function _removeMinter(address _who) internal {
578         require(isPermission(MINT_SIG), "Minting not supported by token");
579         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
580         removeUserPermission(_who, MINT_CUSD_SIG);
581         removeUserPermission(_who, MINT_SIG);
582         emit LogRemovedMinter(_who);
583     }
584 
585     function _setBlacklistedUser(address _who) internal {
586         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
587         setUserPermission(_who, BLACKLISTED_SIG);
588         emit LogBlacklistedUser(_who);
589     }
590 
591     function _removeBlacklistedUser(address _who) internal {
592         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
593         removeUserPermission(_who, BLACKLISTED_SIG);
594         emit LogRemovedBlacklistedUser(_who);
595     }
596 }
597 
598 /**
599 *
600 * @dev RegulatorProxyFactory creates new RegulatorProxy contracts with new data storage sheets, properly configured
601 * with ownership, and the proxy logic implementations are based on a user-specified Regulator. 
602 *
603 **/
604 contract RegulatorProxyFactory {
605 
606     // TODO: Instead of a single array of addresses, this should be a mapping or an array
607     // of objects of type { address: ...new_regulator, type: whitelisted_or_cusd }
608     address[] public regulators;
609 
610     // Events
611     event CreatedRegulatorProxy(address newRegulator, uint256 index);
612 
613     /**
614     *
615     * @dev generate a new proxyaddress that users can cast to a Regulator or RegulatorProxy. The
616     * proxy has empty data storage contracts connected to it and it is set with an initial logic contract
617     * to which it will delegate functionality
618     * @notice the method caller will have to claim ownership of regulators since regulators are claimable
619     * @param regulatorImplementation the address of the logic contract that the proxy will initialize its implementation to
620     *
621     **/
622     function createRegulatorProxy(address regulatorImplementation) public {
623 
624         // Store new data storage contracts for regulator proxy
625         address proxy = address(new RegulatorProxy(regulatorImplementation));
626         Regulator newRegulator = Regulator(proxy);
627 
628         // Testing: Add msg.sender as a validator, add all permissions
629         newRegulator.addValidator(msg.sender);
630         addAllPermissions(newRegulator);
631 
632         // The function caller should own the proxy contract, so they will need to claim ownership
633         RegulatorProxy(proxy).transferOwnership(msg.sender);
634 
635         regulators.push(proxy);
636         emit CreatedRegulatorProxy(proxy, getCount()-1);
637     }
638 
639     /**
640     *
641     * @dev Add all permission signatures to regulator
642     *
643     **/
644     function addAllPermissions(Regulator regulator) public {
645 
646         // Make this contract a temporary validator to add all permissions
647         regulator.addValidator(this);
648         regulator.addPermission(regulator.MINT_SIG(), "", "", "" );
649         regulator.addPermission(regulator.DESTROY_BLACKLISTED_TOKENS_SIG(), "", "", "" );
650         regulator.addPermission(regulator.APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG(), "", "", "" );
651         regulator.addPermission(regulator.BLACKLISTED_SIG(), "", "", "" );
652         regulator.addPermission(regulator.MINT_CUSD_SIG(), "", "", "" );
653         regulator.removeValidator(this);
654     }
655 
656     // Return number of proxies created 
657     function getCount() public view returns (uint256) {
658         return regulators.length;
659     }
660 
661     // Return the i'th created proxy. The most recently created proxy will be at position getCount()-1.
662     function getRegulatorProxy(uint256 i) public view returns(address) {
663         require((i < regulators.length) && (i >= 0), "Invalid index");
664         return regulators[i];
665     }
666 }