1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions". This adds two-phase
57  * ownership control to OpenZeppelin's Ownable class. In this model, the original owner 
58  * designates a new owner but does not actually transfer ownership. The new owner then accepts 
59  * ownership and completes the transfer.
60  */
61 contract Ownable {
62   address public owner;
63   address public pendingOwner;
64 
65 
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   constructor() public {
77     owner = msg.sender;
78     pendingOwner = address(0);
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyPendingOwner() {
93     require(msg.sender == pendingOwner);
94     _;
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     require(_newOwner != address(0));
103     pendingOwner = _newOwner;
104   }
105 
106   /**
107    * @dev Allows the pendingOwner address to finalize the transfer.
108    */
109   function claimOwnership() onlyPendingOwner public {
110     emit OwnershipTransferred(owner, pendingOwner);
111     owner = pendingOwner;
112     pendingOwner = address(0);
113   }
114 
115 
116 }
117 
118 /**
119  * Utility library of inline functions on addresses
120  */
121 // library AddressUtils {
122 
123 //   /**
124 //    * Returns whether the target address is a contract
125 //    * @dev This function will return false if invoked during the constructor of a contract,
126 //    * as the code is not actually created until after the constructor finishes.
127 //    * @param addr address to check
128 //    * @return whether the target address is a contract
129 //    */
130 //   function isContract(address addr) internal view returns (bool) {
131 //     uint256 size;
132 //     // XXX Currently there is no better way to check if there is a contract in an address
133 //     // than to check the size of the code at that address.
134 //     // See https://ethereum.stackexchange.com/a/14016/36603
135 //     // for more details about how this works.
136 //     // TODO Check this again before the Serenity release, because all addresses will be
137 //     // contracts then.
138 //     // solium-disable-next-line security/no-inline-assembly
139 //     assembly { size := extcodesize(addr) }
140 //     return size > 0;
141 //   }
142 
143 // }
144 
145 /**
146 * @title PermissionedTokenStorage
147 * @notice a PermissionedTokenStorage is constructed by setting Regulator, BalanceSheet, and AllowanceSheet locations.
148 * Once the storages are set, they cannot be changed.
149 */
150 contract PermissionedTokenStorage is Ownable {
151     using SafeMath for uint256;
152 
153     /**
154         Storage
155     */
156     mapping (address => mapping (address => uint256)) public allowances;
157     mapping (address => uint256) public balances;
158     uint256 public totalSupply;
159 
160     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
161         allowances[_tokenHolder][_spender] = allowances[_tokenHolder][_spender].add(_value);
162     }
163 
164     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
165         allowances[_tokenHolder][_spender] = allowances[_tokenHolder][_spender].sub(_value);
166     }
167 
168     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
169         allowances[_tokenHolder][_spender] = _value;
170     }
171 
172     function addBalance(address _addr, uint256 _value) public onlyOwner {
173         balances[_addr] = balances[_addr].add(_value);
174     }
175 
176     function subBalance(address _addr, uint256 _value) public onlyOwner {
177         balances[_addr] = balances[_addr].sub(_value);
178     }
179 
180     function setBalance(address _addr, uint256 _value) public onlyOwner {
181         balances[_addr] = _value;
182     }
183 
184     function addTotalSupply(uint256 _value) public onlyOwner {
185         totalSupply = totalSupply.add(_value);
186     }
187 
188     function subTotalSupply(uint256 _value) public onlyOwner {
189         totalSupply = totalSupply.sub(_value);
190     }
191 
192     function setTotalSupply(uint256 _value) public onlyOwner {
193         totalSupply = _value;
194     }
195 
196 }
197 
198 /**
199  * @title Proxy
200  * @dev Implements delegation of calls to other contracts, with proper
201  * forwarding of return values and bubbling of failures.
202  * It defines a fallback function that delegates all calls to the address
203  * returned by the abstract _implementation() internal function.
204  */
205 contract Proxy {
206   /**
207    * @dev Fallback function.
208    * Implemented entirely in `_fallback`.
209    */
210   function () payable external {
211     _fallback();
212   }
213 
214   /**
215    * @return The Address of the implementation.
216    */
217   function _implementation() internal view returns (address);
218 
219   /**
220    * @dev Delegates execution to an implementation contract.
221    * This is a low level function that doesn't return to its internal call site.
222    * It will return to the external caller whatever the implementation returns.
223    * @param implementation Address to delegate.
224    */
225   function _delegate(address implementation) internal {
226     assembly {
227       // Copy msg.data. We take full control of memory in this inline assembly
228       // block because it will not return to Solidity code. We overwrite the
229       // Solidity scratch pad at memory position 0.
230       calldatacopy(0, 0, calldatasize)
231 
232       // Call the implementation.
233       // out and outsize are 0 because we don't know the size yet.
234       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
235 
236       // Copy the returned data.
237       returndatacopy(0, 0, returndatasize)
238 
239       switch result
240       // delegatecall returns 0 on error.
241       case 0 { revert(0, returndatasize) }
242       default { return(0, returndatasize) }
243     }
244   }
245 
246   /**
247    * @dev Function that is run as the first thing in the fallback function.
248    * Can be redefined in derived contracts to add functionality.
249    * Redefinitions must call super._willFallback().
250    */
251   function _willFallback() internal {
252   }
253 
254   /**
255    * @dev fallback implementation.
256    * Extracted to enable manual triggering.
257    */
258   function _fallback() internal {
259     _willFallback();
260     _delegate(_implementation());
261   }
262 }
263 
264 /**
265  * Utility library of inline functions on addresses
266  */
267 library AddressUtils {
268 
269   /**
270    * Returns whether the target address is a contract
271    * @dev This function will return false if invoked during the constructor of a contract,
272    *  as the code is not actually created until after the constructor finishes.
273    * @param addr address to check
274    * @return whether the target address is a contract
275    */
276   function isContract(address addr) internal view returns (bool) {
277     uint256 size;
278     // XXX Currently there is no better way to check if there is a contract in an address
279     // than to check the size of the code at that address.
280     // See https://ethereum.stackexchange.com/a/14016/36603
281     // for more details about how this works.
282     // TODO Check this again before the Serenity release, because all addresses will be
283     // contracts then.
284     // solium-disable-next-line security/no-inline-assembly
285     assembly { size := extcodesize(addr) }
286     return size > 0;
287   }
288 
289 }
290 
291 /**
292  * @title UpgradeabilityProxy
293  * @dev This contract implements a proxy that allows to change the
294  * implementation address to which it will delegate.
295  * Such a change is called an implementation upgrade.
296  */
297 contract UpgradeabilityProxy is Proxy {
298   /**
299    * @dev Emitted when the implementation is upgraded.
300    * @param implementation Address of the new implementation.
301    */
302   event Upgraded(address implementation);
303 
304   /**
305    * @dev Storage slot with the address of the current implementation.
306    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
307    * validated in the constructor.
308    */
309   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
310 
311   /**
312    * @dev Contract constructor.
313    * @param _implementation Address of the initial implementation.
314    */
315   constructor(address _implementation) public {
316     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
317 
318     _setImplementation(_implementation);
319   }
320 
321   /**
322    * @dev Returns the current implementation.
323    * @return Address of the current implementation
324    */
325   function _implementation() internal view returns (address impl) {
326     bytes32 slot = IMPLEMENTATION_SLOT;
327     assembly {
328       impl := sload(slot)
329     }
330   }
331 
332   /**
333    * @dev Upgrades the proxy to a new implementation.
334    * @param newImplementation Address of the new implementation.
335    */
336   function _upgradeTo(address newImplementation) internal {
337     _setImplementation(newImplementation);
338     emit Upgraded(newImplementation);
339   }
340 
341   /**
342    * @dev Sets the implementation address of the proxy.
343    * @param newImplementation Address of the new implementation.
344    */
345   function _setImplementation(address newImplementation) private {
346     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
347 
348     bytes32 slot = IMPLEMENTATION_SLOT;
349 
350     assembly {
351       sstore(slot, newImplementation)
352     }
353   }
354 }
355 
356 /**
357 *
358 * @dev Stores permissions and validators and provides setter and getter methods. 
359 * Permissions determine which methods users have access to call. Validators
360 * are able to mutate permissions at the Regulator level.
361 *
362 */
363 contract RegulatorStorage is Ownable {
364     
365     /** 
366         Structs 
367     */
368 
369     /* Contains metadata about a permission to execute a particular method signature. */
370     struct Permission {
371         string name; // A one-word description for the permission. e.g. "canMint"
372         string description; // A longer description for the permission. e.g. "Allows user to mint tokens."
373         string contract_name; // e.g. "PermissionedToken"
374         bool active; // Permissions can be turned on or off by regulator
375     }
376 
377     /** 
378         Constants: stores method signatures. These are potential permissions that a user can have, 
379         and each permission gives the user the ability to call the associated PermissionedToken method signature
380     */
381     bytes4 public constant MINT_SIG = bytes4(keccak256("mint(address,uint256)"));
382     bytes4 public constant MINT_CUSD_SIG = bytes4(keccak256("mintCUSD(address,uint256)"));
383     bytes4 public constant CONVERT_WT_SIG = bytes4(keccak256("convertWT(uint256)"));
384     bytes4 public constant BURN_SIG = bytes4(keccak256("burn(uint256)"));
385     bytes4 public constant CONVERT_CARBON_DOLLAR_SIG = bytes4(keccak256("convertCarbonDollar(address,uint256)"));
386     bytes4 public constant BURN_CARBON_DOLLAR_SIG = bytes4(keccak256("burnCarbonDollar(address,uint256)"));
387     bytes4 public constant DESTROY_BLACKLISTED_TOKENS_SIG = bytes4(keccak256("destroyBlacklistedTokens(address,uint256)"));
388     bytes4 public constant APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG = bytes4(keccak256("approveBlacklistedAddressSpender(address)"));
389     bytes4 public constant BLACKLISTED_SIG = bytes4(keccak256("blacklisted()"));
390 
391     /** 
392         Mappings 
393     */
394 
395     /* each method signature maps to a Permission */
396     mapping (bytes4 => Permission) public permissions;
397     /* list of validators, either active or inactive */
398     mapping (address => bool) public validators;
399     /* each user can be given access to a given method signature */
400     mapping (address => mapping (bytes4 => bool)) public userPermissions;
401 
402     /** 
403         Events 
404     */
405     event PermissionAdded(bytes4 methodsignature);
406     event PermissionRemoved(bytes4 methodsignature);
407     event ValidatorAdded(address indexed validator);
408     event ValidatorRemoved(address indexed validator);
409 
410     /** 
411         Modifiers 
412     */
413     /**
414     * @notice Throws if called by any account that does not have access to set attributes
415     */
416     modifier onlyValidator() {
417         require (isValidator(msg.sender), "Sender must be validator");
418         _;
419     }
420 
421     /**
422     * @notice Sets a permission within the list of permissions.
423     * @param _methodsignature Signature of the method that this permission controls.
424     * @param _permissionName A "slug" name for this permission (e.g. "canMint").
425     * @param _permissionDescription A lengthier description for this permission (e.g. "Allows user to mint tokens").
426     * @param _contractName Name of the contract that the method belongs to.
427     */
428     function addPermission(
429         bytes4 _methodsignature, 
430         string _permissionName, 
431         string _permissionDescription, 
432         string _contractName) public onlyValidator { 
433         Permission memory p = Permission(_permissionName, _permissionDescription, _contractName, true);
434         permissions[_methodsignature] = p;
435         emit PermissionAdded(_methodsignature);
436     }
437 
438     /**
439     * @notice Removes a permission the list of permissions.
440     * @param _methodsignature Signature of the method that this permission controls.
441     */
442     function removePermission(bytes4 _methodsignature) public onlyValidator {
443         permissions[_methodsignature].active = false;
444         emit PermissionRemoved(_methodsignature);
445     }
446     
447     /**
448     * @notice Sets a permission in the list of permissions that a user has.
449     * @param _methodsignature Signature of the method that this permission controls.
450     */
451     function setUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
452         require(permissions[_methodsignature].active, "Permission being set must be for a valid method signature");
453         userPermissions[_who][_methodsignature] = true;
454     }
455 
456     /**
457     * @notice Removes a permission from the list of permissions that a user has.
458     * @param _methodsignature Signature of the method that this permission controls.
459     */
460     function removeUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
461         require(permissions[_methodsignature].active, "Permission being removed must be for a valid method signature");
462         userPermissions[_who][_methodsignature] = false;
463     }
464 
465     /**
466     * @notice add a Validator
467     * @param _validator Address of validator to add
468     */
469     function addValidator(address _validator) public onlyOwner {
470         validators[_validator] = true;
471         emit ValidatorAdded(_validator);
472     }
473 
474     /**
475     * @notice remove a Validator
476     * @param _validator Address of validator to remove
477     */
478     function removeValidator(address _validator) public onlyOwner {
479         validators[_validator] = false;
480         emit ValidatorRemoved(_validator);
481     }
482 
483     /**
484     * @notice does validator exist?
485     * @return true if yes, false if no
486     **/
487     function isValidator(address _validator) public view returns (bool) {
488         return validators[_validator];
489     }
490 
491     /**
492     * @notice does permission exist?
493     * @return true if yes, false if no
494     **/
495     function isPermission(bytes4 _methodsignature) public view returns (bool) {
496         return permissions[_methodsignature].active;
497     }
498 
499     /**
500     * @notice get Permission structure
501     * @param _methodsignature request to retrieve the Permission struct for this methodsignature
502     * @return Permission
503     **/
504     function getPermission(bytes4 _methodsignature) public view returns 
505         (string name, 
506          string description, 
507          string contract_name,
508          bool active) {
509         return (permissions[_methodsignature].name,
510                 permissions[_methodsignature].description,
511                 permissions[_methodsignature].contract_name,
512                 permissions[_methodsignature].active);
513     }
514 
515     /**
516     * @notice does permission exist?
517     * @return true if yes, false if no
518     **/
519     function hasUserPermission(address _who, bytes4 _methodsignature) public view returns (bool) {
520         return userPermissions[_who][_methodsignature];
521     }
522 }
523 
524 /**
525  * @title Regulator
526  * @dev Regulator can be configured to meet relevant securities regulations, KYC policies
527  * AML requirements, tax laws, and more. The Regulator ensures that the PermissionedToken
528  * makes compliant transfers possible. Contains the userPermissions necessary
529  * for regulatory compliance.
530  *
531  */
532 contract Regulator is RegulatorStorage {
533     
534     /** 
535         Modifiers 
536     */
537     /**
538     * @notice Throws if called by any account that does not have access to set attributes
539     */
540     modifier onlyValidator() {
541         require (isValidator(msg.sender), "Sender must be validator");
542         _;
543     }
544 
545     /** 
546         Events 
547     */
548     event LogWhitelistedUser(address indexed who);
549     event LogBlacklistedUser(address indexed who);
550     event LogNonlistedUser(address indexed who);
551     event LogSetMinter(address indexed who);
552     event LogRemovedMinter(address indexed who);
553     event LogSetBlacklistDestroyer(address indexed who);
554     event LogRemovedBlacklistDestroyer(address indexed who);
555     event LogSetBlacklistSpender(address indexed who);
556     event LogRemovedBlacklistSpender(address indexed who);
557 
558     /**
559     * @notice Sets the necessary permissions for a user to mint tokens.
560     * @param _who The address of the account that we are setting permissions for.
561     */
562     function setMinter(address _who) public onlyValidator {
563         _setMinter(_who);
564     }
565 
566     /**
567     * @notice Removes the necessary permissions for a user to mint tokens.
568     * @param _who The address of the account that we are removing permissions for.
569     */
570     function removeMinter(address _who) public onlyValidator {
571         _removeMinter(_who);
572     }
573 
574     /**
575     * @notice Sets the necessary permissions for a user to spend tokens from a blacklisted account.
576     * @param _who The address of the account that we are setting permissions for.
577     */
578     function setBlacklistSpender(address _who) public onlyValidator {
579         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
580         setUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
581         emit LogSetBlacklistSpender(_who);
582     }
583     
584     /**
585     * @notice Removes the necessary permissions for a user to spend tokens from a blacklisted account.
586     * @param _who The address of the account that we are removing permissions for.
587     */
588     function removeBlacklistSpender(address _who) public onlyValidator {
589         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
590         removeUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
591         emit LogRemovedBlacklistSpender(_who);
592     }
593 
594     /**
595     * @notice Sets the necessary permissions for a user to destroy tokens from a blacklisted account.
596     * @param _who The address of the account that we are setting permissions for.
597     */
598     function setBlacklistDestroyer(address _who) public onlyValidator {
599         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
600         setUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
601         emit LogSetBlacklistDestroyer(_who);
602     }
603     
604 
605     /**
606     * @notice Removes the necessary permissions for a user to destroy tokens from a blacklisted account.
607     * @param _who The address of the account that we are removing permissions for.
608     */
609     function removeBlacklistDestroyer(address _who) public onlyValidator {
610         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
611         removeUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
612         emit LogRemovedBlacklistDestroyer(_who);
613     }
614 
615     /**
616     * @notice Sets the necessary permissions for a "whitelisted" user.
617     * @param _who The address of the account that we are setting permissions for.
618     */
619     function setWhitelistedUser(address _who) public onlyValidator {
620         _setWhitelistedUser(_who);
621     }
622 
623     /**
624     * @notice Sets the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
625     * frozen; they cannot transfer, burn, or withdraw any tokens.
626     * @param _who The address of the account that we are setting permissions for.
627     */
628     function setBlacklistedUser(address _who) public onlyValidator {
629         _setBlacklistedUser(_who);
630     }
631 
632     /**
633     * @notice Sets the necessary permissions for a "nonlisted" user. Nonlisted users can trade tokens,
634     * but cannot burn them (and therefore cannot convert them into fiat.)
635     * @param _who The address of the account that we are setting permissions for.
636     */
637     function setNonlistedUser(address _who) public onlyValidator {
638         _setNonlistedUser(_who);
639     }
640 
641     /** Returns whether or not a user is whitelisted.
642      * @param _who The address of the account in question.
643      * @return `true` if the user is whitelisted, `false` otherwise.
644      */
645     function isWhitelistedUser(address _who) public view returns (bool) {
646         return (hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
647     }
648 
649     /** Returns whether or not a user is blacklisted.
650      * @param _who The address of the account in question.
651      * @return `true` if the user is blacklisted, `false` otherwise.
652      */
653     function isBlacklistedUser(address _who) public view returns (bool) {
654         return (!hasUserPermission(_who, BURN_SIG) && hasUserPermission(_who, BLACKLISTED_SIG));
655     }
656 
657     /** Returns whether or not a user is nonlisted.
658      * @param _who The address of the account in question.
659      * @return `true` if the user is nonlisted, `false` otherwise.
660      */
661     function isNonlistedUser(address _who) public view returns (bool) {
662         return (!hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
663     }
664 
665     /** Returns whether or not a user is a blacklist spender.
666      * @param _who The address of the account in question.
667      * @return `true` if the user is a blacklist spender, `false` otherwise.
668      */
669     function isBlacklistSpender(address _who) public view returns (bool) {
670         return hasUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
671     }
672 
673     /** Returns whether or not a user is a blacklist destroyer.
674      * @param _who The address of the account in question.
675      * @return `true` if the user is a blacklist destroyer, `false` otherwise.
676      */
677     function isBlacklistDestroyer(address _who) public view returns (bool) {
678         return hasUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
679     }
680 
681     /** Returns whether or not a user is a minter.
682      * @param _who The address of the account in question.
683      * @return `true` if the user is a minter, `false` otherwise.
684      */
685     function isMinter(address _who) public view returns (bool) {
686         return hasUserPermission(_who, MINT_SIG);
687     }
688 
689     /** Internal Functions **/
690 
691     function _setMinter(address _who) internal {
692         require(isPermission(MINT_SIG), "Minting not supported by token");
693         setUserPermission(_who, MINT_SIG);
694         emit LogSetMinter(_who);
695     }
696 
697     function _removeMinter(address _who) internal {
698         require(isPermission(MINT_SIG), "Minting not supported by token");
699         removeUserPermission(_who, MINT_SIG);
700         emit LogRemovedMinter(_who);
701     }
702 
703     function _setNonlistedUser(address _who) internal {
704         require(isPermission(BURN_SIG), "Burn method not supported by token");
705         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
706         removeUserPermission(_who, BURN_SIG);
707         removeUserPermission(_who, BLACKLISTED_SIG);
708         emit LogNonlistedUser(_who);
709     }
710 
711     function _setBlacklistedUser(address _who) internal {
712         require(isPermission(BURN_SIG), "Burn method not supported by token");
713         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
714         removeUserPermission(_who, BURN_SIG);
715         setUserPermission(_who, BLACKLISTED_SIG);
716         emit LogBlacklistedUser(_who);
717     }
718 
719     function _setWhitelistedUser(address _who) internal {
720         require(isPermission(BURN_SIG), "Burn method not supported by token");
721         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
722         setUserPermission(_who, BURN_SIG);
723         removeUserPermission(_who, BLACKLISTED_SIG);
724         emit LogWhitelistedUser(_who);
725     }
726 }
727 
728 /**
729 * @title PermissionedTokenProxy
730 * @notice A proxy contract that serves the latest implementation of PermissionedToken.
731 */
732 contract PermissionedTokenProxy is UpgradeabilityProxy, Ownable {
733     
734     PermissionedTokenStorage public tokenStorage;
735     Regulator public regulator;
736 
737     // Events
738     event ChangedRegulator(address indexed oldRegulator, address indexed newRegulator );
739 
740 
741     /**
742     * @dev create a new PermissionedToken as a proxy contract
743     * with a brand new data storage 
744     **/
745     constructor(address _implementation, address _regulator) 
746     UpgradeabilityProxy(_implementation) public {
747         regulator = Regulator(_regulator);
748         tokenStorage = new PermissionedTokenStorage();
749     }
750 
751     /**
752     * @dev Upgrade the backing implementation of the proxy.
753     * Only the admin can call this function.
754     * @param newImplementation Address of the new implementation.
755     */
756     function upgradeTo(address newImplementation) public onlyOwner {
757         _upgradeTo(newImplementation);
758     }
759 
760 
761     /**
762     * @return The address of the implementation.
763     */
764     function implementation() public view returns (address) {
765         return _implementation();
766     }
767 }
768 
769 /**
770  * @title WhitelistedTokenRegulator
771  * @dev WhitelistedTokenRegulator is a type of Regulator that modifies its definitions of
772  * what constitutes a "whitelisted/nonlisted/blacklisted" user. A WhitelistedToken
773  * provides a user the additional ability to convert from a whtielisted stablecoin into the
774  * meta-token CUSD, or mint CUSD directly through a specific WT.
775  *
776  */
777 contract WhitelistedTokenRegulator is Regulator {
778 
779     function isMinter(address _who) public view returns (bool) {
780         return (super.isMinter(_who) && hasUserPermission(_who, MINT_CUSD_SIG));
781     }
782 
783     // Getters
784 
785     function isWhitelistedUser(address _who) public view returns (bool) {
786         return (hasUserPermission(_who, CONVERT_WT_SIG) && super.isWhitelistedUser(_who));
787     }
788 
789     function isBlacklistedUser(address _who) public view returns (bool) {
790         return (!hasUserPermission(_who, CONVERT_WT_SIG) && super.isBlacklistedUser(_who));
791     }
792 
793     function isNonlistedUser(address _who) public view returns (bool) {
794         return (!hasUserPermission(_who, CONVERT_WT_SIG) && super.isNonlistedUser(_who));
795     }   
796 
797     /** Internal functions **/
798 
799     // A WT minter should have option to either mint directly into CUSD via mintCUSD(), or
800     // mint the WT via an ordinary mint() 
801     function _setMinter(address _who) internal {
802         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
803         setUserPermission(_who, MINT_CUSD_SIG);
804         super._setMinter(_who);
805     }
806 
807     function _removeMinter(address _who) internal {
808         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
809         removeUserPermission(_who, MINT_CUSD_SIG);
810         super._removeMinter(_who);
811     }
812 
813     // Setters
814 
815     // A WT whitelisted user should gain ability to convert their WT into CUSD. They can also burn their WT, as a
816     // PermissionedToken whitelisted user can do
817     function _setWhitelistedUser(address _who) internal {
818         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
819         setUserPermission(_who, CONVERT_WT_SIG);
820         super._setWhitelistedUser(_who);
821     }
822 
823     function _setBlacklistedUser(address _who) internal {
824         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
825         removeUserPermission(_who, CONVERT_WT_SIG);
826         super._setBlacklistedUser(_who);
827     }
828 
829     function _setNonlistedUser(address _who) internal {
830         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
831         removeUserPermission(_who, CONVERT_WT_SIG);
832         super._setNonlistedUser(_who);
833     }
834 
835 }
836 
837 /**
838 * @title WhitelistedTokenProxy
839 * @notice This contract IS a WhitelistedToken. All calls to the WhitelistedToken contract will
840 * be routed through this proxy, since this proxy contract is the owner of the
841 * storage contracts.
842 */
843 contract WhitelistedTokenProxy is PermissionedTokenProxy {
844     address public cusdAddress;
845 
846 
847     constructor(address _implementation, 
848                 address _regulator, 
849                 address _cusd) public PermissionedTokenProxy(_implementation, _regulator) {
850         // base class override
851         regulator = WhitelistedTokenRegulator(_regulator);
852 
853         cusdAddress = _cusd;
854 
855     }
856 }
857 
858 /**
859 *
860 * @dev WhitelistedTokenProxyFactory creates new WhitelistedTokenProxy contracts with new data storage sheets, properly configured
861 * with ownership, and the proxy logic implementations are based on a user-specified WhitelistedTokenProxy. 
862 *
863 **/
864 contract WhitelistedTokenProxyFactory {
865     // Parameters
866     address[] public tokens;
867 
868     // Events
869     event CreatedWhitelistedTokenProxy(address newToken, uint256 index);
870 
871     /**
872     *
873     * @dev generate a new proxy address that users can cast to a PermissionedToken or PermissionedTokenProxy. The
874     * proxy has empty data storage contracts connected to it and it is set with an initial logic contract
875     * to which it will delegate functionality
876     * @param regulator the address of the initial regulator contract that regulates the proxy
877     * @param tokenImplementation the address of the initial PT token implementation
878     *
879     **/
880     function createToken(address tokenImplementation, address cusdAddress, address regulator) public {
881         
882         address proxy = address(new WhitelistedTokenProxy(tokenImplementation, regulator, cusdAddress));
883 
884         // The function caller should own the proxy contract
885         WhitelistedTokenProxy(proxy).transferOwnership(msg.sender);
886 
887         tokens.push(proxy);
888         emit CreatedWhitelistedTokenProxy(proxy, getCount()-1);
889     }
890 
891     // Return number of token proxy contracts created so far
892     function getCount() public view returns (uint256) {
893         return tokens.length;
894     }
895 
896     // Return the i'th created token
897     function getToken(uint256 i) public view returns(address) {
898         require((i < tokens.length) && (i >= 0), "Invalid index");
899         return tokens[i];
900     }
901 }