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
119 * @title CarbonDollarStorage
120 * @notice Contains necessary storage contracts for CarbonDollar (FeeSheet and StablecoinWhitelist).
121 */
122 contract CarbonDollarStorage is Ownable {
123     using SafeMath for uint256;
124 
125     /** 
126         Mappings
127     */
128     /* fees for withdrawing to stablecoin, in tenths of a percent) */
129     mapping (address => uint256) public fees;
130     /** @dev Units for fees are always in a tenth of a percent */
131     uint256 public defaultFee;
132     /* is the token address referring to a stablecoin/whitelisted token? */
133     mapping (address => bool) public whitelist;
134 
135 
136     /** 
137         Events
138     */
139     event DefaultFeeChanged(uint256 oldFee, uint256 newFee);
140     event FeeChanged(address indexed stablecoin, uint256 oldFee, uint256 newFee);
141     event FeeRemoved(address indexed stablecoin, uint256 oldFee);
142     event StablecoinAdded(address indexed stablecoin);
143     event StablecoinRemoved(address indexed stablecoin);
144 
145     /** @notice Sets the default fee for burning CarbonDollar into a whitelisted stablecoin.
146         @param _fee The default fee.
147     */
148     function setDefaultFee(uint256 _fee) public onlyOwner {
149         uint256 oldFee = defaultFee;
150         defaultFee = _fee;
151         if (oldFee != defaultFee)
152             emit DefaultFeeChanged(oldFee, _fee);
153     }
154     
155     /** @notice Set a fee for burning CarbonDollar into a stablecoin.
156         @param _stablecoin Address of a whitelisted stablecoin.
157         @param _fee the fee.
158     */
159     function setFee(address _stablecoin, uint256 _fee) public onlyOwner {
160         uint256 oldFee = fees[_stablecoin];
161         fees[_stablecoin] = _fee;
162         if (oldFee != _fee)
163             emit FeeChanged(_stablecoin, oldFee, _fee);
164     }
165 
166     /** @notice Remove the fee for burning CarbonDollar into a particular kind of stablecoin.
167         @param _stablecoin Address of stablecoin.
168     */
169     function removeFee(address _stablecoin) public onlyOwner {
170         uint256 oldFee = fees[_stablecoin];
171         fees[_stablecoin] = 0;
172         if (oldFee != 0)
173             emit FeeRemoved(_stablecoin, oldFee);
174     }
175 
176     /** @notice Add a token to the whitelist.
177         @param _stablecoin Address of the new stablecoin.
178     */
179     function addStablecoin(address _stablecoin) public onlyOwner {
180         whitelist[_stablecoin] = true;
181         emit StablecoinAdded(_stablecoin);
182     }
183 
184     /** @notice Removes a token from the whitelist.
185         @param _stablecoin Address of the ex-stablecoin.
186     */
187     function removeStablecoin(address _stablecoin) public onlyOwner {
188         whitelist[_stablecoin] = false;
189         emit StablecoinRemoved(_stablecoin);
190     }
191 
192 
193     /**
194      * @notice Compute the fee that will be charged on a "burn" operation.
195      * @param _amount The amount that will be traded.
196      * @param _stablecoin The stablecoin whose fee will be used.
197      */
198     function computeStablecoinFee(uint256 _amount, address _stablecoin) public view returns (uint256) {
199         uint256 fee = fees[_stablecoin];
200         return computeFee(_amount, fee);
201     }
202 
203     /**
204      * @notice Compute the fee that will be charged on a "burn" operation.
205      * @param _amount The amount that will be traded.
206      * @param _fee The fee that will be charged, in tenths of a percent.
207      */
208     function computeFee(uint256 _amount, uint256 _fee) public pure returns (uint256) {
209         return _amount.mul(_fee).div(1000);
210     }
211 }
212 
213 /**
214  * Utility library of inline functions on addresses
215  */
216 // library AddressUtils {
217 
218 //   /**
219 //    * Returns whether the target address is a contract
220 //    * @dev This function will return false if invoked during the constructor of a contract,
221 //    * as the code is not actually created until after the constructor finishes.
222 //    * @param addr address to check
223 //    * @return whether the target address is a contract
224 //    */
225 //   function isContract(address addr) internal view returns (bool) {
226 //     uint256 size;
227 //     // XXX Currently there is no better way to check if there is a contract in an address
228 //     // than to check the size of the code at that address.
229 //     // See https://ethereum.stackexchange.com/a/14016/36603
230 //     // for more details about how this works.
231 //     // TODO Check this again before the Serenity release, because all addresses will be
232 //     // contracts then.
233 //     // solium-disable-next-line security/no-inline-assembly
234 //     assembly { size := extcodesize(addr) }
235 //     return size > 0;
236 //   }
237 
238 // }
239 
240 /**
241 * @title PermissionedTokenStorage
242 * @notice a PermissionedTokenStorage is constructed by setting Regulator, BalanceSheet, and AllowanceSheet locations.
243 * Once the storages are set, they cannot be changed.
244 */
245 contract PermissionedTokenStorage is Ownable {
246     using SafeMath for uint256;
247 
248     /**
249         Storage
250     */
251     mapping (address => mapping (address => uint256)) public allowances;
252     mapping (address => uint256) public balances;
253     uint256 public totalSupply;
254 
255     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
256         allowances[_tokenHolder][_spender] = allowances[_tokenHolder][_spender].add(_value);
257     }
258 
259     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
260         allowances[_tokenHolder][_spender] = allowances[_tokenHolder][_spender].sub(_value);
261     }
262 
263     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
264         allowances[_tokenHolder][_spender] = _value;
265     }
266 
267     function addBalance(address _addr, uint256 _value) public onlyOwner {
268         balances[_addr] = balances[_addr].add(_value);
269     }
270 
271     function subBalance(address _addr, uint256 _value) public onlyOwner {
272         balances[_addr] = balances[_addr].sub(_value);
273     }
274 
275     function setBalance(address _addr, uint256 _value) public onlyOwner {
276         balances[_addr] = _value;
277     }
278 
279     function addTotalSupply(uint256 _value) public onlyOwner {
280         totalSupply = totalSupply.add(_value);
281     }
282 
283     function subTotalSupply(uint256 _value) public onlyOwner {
284         totalSupply = totalSupply.sub(_value);
285     }
286 
287     function setTotalSupply(uint256 _value) public onlyOwner {
288         totalSupply = _value;
289     }
290 
291 }
292 
293 /**
294  * @title Proxy
295  * @dev Implements delegation of calls to other contracts, with proper
296  * forwarding of return values and bubbling of failures.
297  * It defines a fallback function that delegates all calls to the address
298  * returned by the abstract _implementation() internal function.
299  */
300 contract Proxy {
301   /**
302    * @dev Fallback function.
303    * Implemented entirely in `_fallback`.
304    */
305   function () payable external {
306     _fallback();
307   }
308 
309   /**
310    * @return The Address of the implementation.
311    */
312   function _implementation() internal view returns (address);
313 
314   /**
315    * @dev Delegates execution to an implementation contract.
316    * This is a low level function that doesn't return to its internal call site.
317    * It will return to the external caller whatever the implementation returns.
318    * @param implementation Address to delegate.
319    */
320   function _delegate(address implementation) internal {
321     assembly {
322       // Copy msg.data. We take full control of memory in this inline assembly
323       // block because it will not return to Solidity code. We overwrite the
324       // Solidity scratch pad at memory position 0.
325       calldatacopy(0, 0, calldatasize)
326 
327       // Call the implementation.
328       // out and outsize are 0 because we don't know the size yet.
329       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
330 
331       // Copy the returned data.
332       returndatacopy(0, 0, returndatasize)
333 
334       switch result
335       // delegatecall returns 0 on error.
336       case 0 { revert(0, returndatasize) }
337       default { return(0, returndatasize) }
338     }
339   }
340 
341   /**
342    * @dev Function that is run as the first thing in the fallback function.
343    * Can be redefined in derived contracts to add functionality.
344    * Redefinitions must call super._willFallback().
345    */
346   function _willFallback() internal {
347   }
348 
349   /**
350    * @dev fallback implementation.
351    * Extracted to enable manual triggering.
352    */
353   function _fallback() internal {
354     _willFallback();
355     _delegate(_implementation());
356   }
357 }
358 
359 /**
360  * Utility library of inline functions on addresses
361  */
362 library AddressUtils {
363 
364   /**
365    * Returns whether the target address is a contract
366    * @dev This function will return false if invoked during the constructor of a contract,
367    *  as the code is not actually created until after the constructor finishes.
368    * @param addr address to check
369    * @return whether the target address is a contract
370    */
371   function isContract(address addr) internal view returns (bool) {
372     uint256 size;
373     // XXX Currently there is no better way to check if there is a contract in an address
374     // than to check the size of the code at that address.
375     // See https://ethereum.stackexchange.com/a/14016/36603
376     // for more details about how this works.
377     // TODO Check this again before the Serenity release, because all addresses will be
378     // contracts then.
379     // solium-disable-next-line security/no-inline-assembly
380     assembly { size := extcodesize(addr) }
381     return size > 0;
382   }
383 
384 }
385 
386 /**
387  * @title UpgradeabilityProxy
388  * @dev This contract implements a proxy that allows to change the
389  * implementation address to which it will delegate.
390  * Such a change is called an implementation upgrade.
391  */
392 contract UpgradeabilityProxy is Proxy {
393   /**
394    * @dev Emitted when the implementation is upgraded.
395    * @param implementation Address of the new implementation.
396    */
397   event Upgraded(address implementation);
398 
399   /**
400    * @dev Storage slot with the address of the current implementation.
401    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
402    * validated in the constructor.
403    */
404   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
405 
406   /**
407    * @dev Contract constructor.
408    * @param _implementation Address of the initial implementation.
409    */
410   constructor(address _implementation) public {
411     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
412 
413     _setImplementation(_implementation);
414   }
415 
416   /**
417    * @dev Returns the current implementation.
418    * @return Address of the current implementation
419    */
420   function _implementation() internal view returns (address impl) {
421     bytes32 slot = IMPLEMENTATION_SLOT;
422     assembly {
423       impl := sload(slot)
424     }
425   }
426 
427   /**
428    * @dev Upgrades the proxy to a new implementation.
429    * @param newImplementation Address of the new implementation.
430    */
431   function _upgradeTo(address newImplementation) internal {
432     _setImplementation(newImplementation);
433     emit Upgraded(newImplementation);
434   }
435 
436   /**
437    * @dev Sets the implementation address of the proxy.
438    * @param newImplementation Address of the new implementation.
439    */
440   function _setImplementation(address newImplementation) private {
441     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
442 
443     bytes32 slot = IMPLEMENTATION_SLOT;
444 
445     assembly {
446       sstore(slot, newImplementation)
447     }
448   }
449 }
450 
451 /**
452 *
453 * @dev Stores permissions and validators and provides setter and getter methods. 
454 * Permissions determine which methods users have access to call. Validators
455 * are able to mutate permissions at the Regulator level.
456 *
457 */
458 contract RegulatorStorage is Ownable {
459     
460     /** 
461         Structs 
462     */
463 
464     /* Contains metadata about a permission to execute a particular method signature. */
465     struct Permission {
466         string name; // A one-word description for the permission. e.g. "canMint"
467         string description; // A longer description for the permission. e.g. "Allows user to mint tokens."
468         string contract_name; // e.g. "PermissionedToken"
469         bool active; // Permissions can be turned on or off by regulator
470     }
471 
472     /** 
473         Constants: stores method signatures. These are potential permissions that a user can have, 
474         and each permission gives the user the ability to call the associated PermissionedToken method signature
475     */
476     bytes4 public constant MINT_SIG = bytes4(keccak256("mint(address,uint256)"));
477     bytes4 public constant MINT_CUSD_SIG = bytes4(keccak256("mintCUSD(address,uint256)"));
478     bytes4 public constant CONVERT_WT_SIG = bytes4(keccak256("convertWT(uint256)"));
479     bytes4 public constant BURN_SIG = bytes4(keccak256("burn(uint256)"));
480     bytes4 public constant CONVERT_CARBON_DOLLAR_SIG = bytes4(keccak256("convertCarbonDollar(address,uint256)"));
481     bytes4 public constant BURN_CARBON_DOLLAR_SIG = bytes4(keccak256("burnCarbonDollar(address,uint256)"));
482     bytes4 public constant DESTROY_BLACKLISTED_TOKENS_SIG = bytes4(keccak256("destroyBlacklistedTokens(address,uint256)"));
483     bytes4 public constant APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG = bytes4(keccak256("approveBlacklistedAddressSpender(address)"));
484     bytes4 public constant BLACKLISTED_SIG = bytes4(keccak256("blacklisted()"));
485 
486     /** 
487         Mappings 
488     */
489 
490     /* each method signature maps to a Permission */
491     mapping (bytes4 => Permission) public permissions;
492     /* list of validators, either active or inactive */
493     mapping (address => bool) public validators;
494     /* each user can be given access to a given method signature */
495     mapping (address => mapping (bytes4 => bool)) public userPermissions;
496 
497     /** 
498         Events 
499     */
500     event PermissionAdded(bytes4 methodsignature);
501     event PermissionRemoved(bytes4 methodsignature);
502     event ValidatorAdded(address indexed validator);
503     event ValidatorRemoved(address indexed validator);
504 
505     /** 
506         Modifiers 
507     */
508     /**
509     * @notice Throws if called by any account that does not have access to set attributes
510     */
511     modifier onlyValidator() {
512         require (isValidator(msg.sender), "Sender must be validator");
513         _;
514     }
515 
516     /**
517     * @notice Sets a permission within the list of permissions.
518     * @param _methodsignature Signature of the method that this permission controls.
519     * @param _permissionName A "slug" name for this permission (e.g. "canMint").
520     * @param _permissionDescription A lengthier description for this permission (e.g. "Allows user to mint tokens").
521     * @param _contractName Name of the contract that the method belongs to.
522     */
523     function addPermission(
524         bytes4 _methodsignature, 
525         string _permissionName, 
526         string _permissionDescription, 
527         string _contractName) public onlyValidator { 
528         Permission memory p = Permission(_permissionName, _permissionDescription, _contractName, true);
529         permissions[_methodsignature] = p;
530         emit PermissionAdded(_methodsignature);
531     }
532 
533     /**
534     * @notice Removes a permission the list of permissions.
535     * @param _methodsignature Signature of the method that this permission controls.
536     */
537     function removePermission(bytes4 _methodsignature) public onlyValidator {
538         permissions[_methodsignature].active = false;
539         emit PermissionRemoved(_methodsignature);
540     }
541     
542     /**
543     * @notice Sets a permission in the list of permissions that a user has.
544     * @param _methodsignature Signature of the method that this permission controls.
545     */
546     function setUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
547         require(permissions[_methodsignature].active, "Permission being set must be for a valid method signature");
548         userPermissions[_who][_methodsignature] = true;
549     }
550 
551     /**
552     * @notice Removes a permission from the list of permissions that a user has.
553     * @param _methodsignature Signature of the method that this permission controls.
554     */
555     function removeUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
556         require(permissions[_methodsignature].active, "Permission being removed must be for a valid method signature");
557         userPermissions[_who][_methodsignature] = false;
558     }
559 
560     /**
561     * @notice add a Validator
562     * @param _validator Address of validator to add
563     */
564     function addValidator(address _validator) public onlyOwner {
565         validators[_validator] = true;
566         emit ValidatorAdded(_validator);
567     }
568 
569     /**
570     * @notice remove a Validator
571     * @param _validator Address of validator to remove
572     */
573     function removeValidator(address _validator) public onlyOwner {
574         validators[_validator] = false;
575         emit ValidatorRemoved(_validator);
576     }
577 
578     /**
579     * @notice does validator exist?
580     * @return true if yes, false if no
581     **/
582     function isValidator(address _validator) public view returns (bool) {
583         return validators[_validator];
584     }
585 
586     /**
587     * @notice does permission exist?
588     * @return true if yes, false if no
589     **/
590     function isPermission(bytes4 _methodsignature) public view returns (bool) {
591         return permissions[_methodsignature].active;
592     }
593 
594     /**
595     * @notice get Permission structure
596     * @param _methodsignature request to retrieve the Permission struct for this methodsignature
597     * @return Permission
598     **/
599     function getPermission(bytes4 _methodsignature) public view returns 
600         (string name, 
601          string description, 
602          string contract_name,
603          bool active) {
604         return (permissions[_methodsignature].name,
605                 permissions[_methodsignature].description,
606                 permissions[_methodsignature].contract_name,
607                 permissions[_methodsignature].active);
608     }
609 
610     /**
611     * @notice does permission exist?
612     * @return true if yes, false if no
613     **/
614     function hasUserPermission(address _who, bytes4 _methodsignature) public view returns (bool) {
615         return userPermissions[_who][_methodsignature];
616     }
617 }
618 
619 /**
620  * @title Regulator
621  * @dev Regulator can be configured to meet relevant securities regulations, KYC policies
622  * AML requirements, tax laws, and more. The Regulator ensures that the PermissionedToken
623  * makes compliant transfers possible. Contains the userPermissions necessary
624  * for regulatory compliance.
625  *
626  */
627 contract Regulator is RegulatorStorage {
628     
629     /** 
630         Modifiers 
631     */
632     /**
633     * @notice Throws if called by any account that does not have access to set attributes
634     */
635     modifier onlyValidator() {
636         require (isValidator(msg.sender), "Sender must be validator");
637         _;
638     }
639 
640     /** 
641         Events 
642     */
643     event LogWhitelistedUser(address indexed who);
644     event LogBlacklistedUser(address indexed who);
645     event LogNonlistedUser(address indexed who);
646     event LogSetMinter(address indexed who);
647     event LogRemovedMinter(address indexed who);
648     event LogSetBlacklistDestroyer(address indexed who);
649     event LogRemovedBlacklistDestroyer(address indexed who);
650     event LogSetBlacklistSpender(address indexed who);
651     event LogRemovedBlacklistSpender(address indexed who);
652 
653     /**
654     * @notice Sets the necessary permissions for a user to mint tokens.
655     * @param _who The address of the account that we are setting permissions for.
656     */
657     function setMinter(address _who) public onlyValidator {
658         _setMinter(_who);
659     }
660 
661     /**
662     * @notice Removes the necessary permissions for a user to mint tokens.
663     * @param _who The address of the account that we are removing permissions for.
664     */
665     function removeMinter(address _who) public onlyValidator {
666         _removeMinter(_who);
667     }
668 
669     /**
670     * @notice Sets the necessary permissions for a user to spend tokens from a blacklisted account.
671     * @param _who The address of the account that we are setting permissions for.
672     */
673     function setBlacklistSpender(address _who) public onlyValidator {
674         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
675         setUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
676         emit LogSetBlacklistSpender(_who);
677     }
678     
679     /**
680     * @notice Removes the necessary permissions for a user to spend tokens from a blacklisted account.
681     * @param _who The address of the account that we are removing permissions for.
682     */
683     function removeBlacklistSpender(address _who) public onlyValidator {
684         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
685         removeUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
686         emit LogRemovedBlacklistSpender(_who);
687     }
688 
689     /**
690     * @notice Sets the necessary permissions for a user to destroy tokens from a blacklisted account.
691     * @param _who The address of the account that we are setting permissions for.
692     */
693     function setBlacklistDestroyer(address _who) public onlyValidator {
694         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
695         setUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
696         emit LogSetBlacklistDestroyer(_who);
697     }
698     
699 
700     /**
701     * @notice Removes the necessary permissions for a user to destroy tokens from a blacklisted account.
702     * @param _who The address of the account that we are removing permissions for.
703     */
704     function removeBlacklistDestroyer(address _who) public onlyValidator {
705         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
706         removeUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
707         emit LogRemovedBlacklistDestroyer(_who);
708     }
709 
710     /**
711     * @notice Sets the necessary permissions for a "whitelisted" user.
712     * @param _who The address of the account that we are setting permissions for.
713     */
714     function setWhitelistedUser(address _who) public onlyValidator {
715         _setWhitelistedUser(_who);
716     }
717 
718     /**
719     * @notice Sets the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
720     * frozen; they cannot transfer, burn, or withdraw any tokens.
721     * @param _who The address of the account that we are setting permissions for.
722     */
723     function setBlacklistedUser(address _who) public onlyValidator {
724         _setBlacklistedUser(_who);
725     }
726 
727     /**
728     * @notice Sets the necessary permissions for a "nonlisted" user. Nonlisted users can trade tokens,
729     * but cannot burn them (and therefore cannot convert them into fiat.)
730     * @param _who The address of the account that we are setting permissions for.
731     */
732     function setNonlistedUser(address _who) public onlyValidator {
733         _setNonlistedUser(_who);
734     }
735 
736     /** Returns whether or not a user is whitelisted.
737      * @param _who The address of the account in question.
738      * @return `true` if the user is whitelisted, `false` otherwise.
739      */
740     function isWhitelistedUser(address _who) public view returns (bool) {
741         return (hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
742     }
743 
744     /** Returns whether or not a user is blacklisted.
745      * @param _who The address of the account in question.
746      * @return `true` if the user is blacklisted, `false` otherwise.
747      */
748     function isBlacklistedUser(address _who) public view returns (bool) {
749         return (!hasUserPermission(_who, BURN_SIG) && hasUserPermission(_who, BLACKLISTED_SIG));
750     }
751 
752     /** Returns whether or not a user is nonlisted.
753      * @param _who The address of the account in question.
754      * @return `true` if the user is nonlisted, `false` otherwise.
755      */
756     function isNonlistedUser(address _who) public view returns (bool) {
757         return (!hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
758     }
759 
760     /** Returns whether or not a user is a blacklist spender.
761      * @param _who The address of the account in question.
762      * @return `true` if the user is a blacklist spender, `false` otherwise.
763      */
764     function isBlacklistSpender(address _who) public view returns (bool) {
765         return hasUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
766     }
767 
768     /** Returns whether or not a user is a blacklist destroyer.
769      * @param _who The address of the account in question.
770      * @return `true` if the user is a blacklist destroyer, `false` otherwise.
771      */
772     function isBlacklistDestroyer(address _who) public view returns (bool) {
773         return hasUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
774     }
775 
776     /** Returns whether or not a user is a minter.
777      * @param _who The address of the account in question.
778      * @return `true` if the user is a minter, `false` otherwise.
779      */
780     function isMinter(address _who) public view returns (bool) {
781         return hasUserPermission(_who, MINT_SIG);
782     }
783 
784     /** Internal Functions **/
785 
786     function _setMinter(address _who) internal {
787         require(isPermission(MINT_SIG), "Minting not supported by token");
788         setUserPermission(_who, MINT_SIG);
789         emit LogSetMinter(_who);
790     }
791 
792     function _removeMinter(address _who) internal {
793         require(isPermission(MINT_SIG), "Minting not supported by token");
794         removeUserPermission(_who, MINT_SIG);
795         emit LogRemovedMinter(_who);
796     }
797 
798     function _setNonlistedUser(address _who) internal {
799         require(isPermission(BURN_SIG), "Burn method not supported by token");
800         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
801         removeUserPermission(_who, BURN_SIG);
802         removeUserPermission(_who, BLACKLISTED_SIG);
803         emit LogNonlistedUser(_who);
804     }
805 
806     function _setBlacklistedUser(address _who) internal {
807         require(isPermission(BURN_SIG), "Burn method not supported by token");
808         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
809         removeUserPermission(_who, BURN_SIG);
810         setUserPermission(_who, BLACKLISTED_SIG);
811         emit LogBlacklistedUser(_who);
812     }
813 
814     function _setWhitelistedUser(address _who) internal {
815         require(isPermission(BURN_SIG), "Burn method not supported by token");
816         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
817         setUserPermission(_who, BURN_SIG);
818         removeUserPermission(_who, BLACKLISTED_SIG);
819         emit LogWhitelistedUser(_who);
820     }
821 }
822 
823 /**
824 * @title PermissionedTokenProxy
825 * @notice A proxy contract that serves the latest implementation of PermissionedToken.
826 */
827 contract PermissionedTokenProxy is UpgradeabilityProxy, Ownable {
828     
829     PermissionedTokenStorage public tokenStorage;
830     Regulator public regulator;
831 
832     // Events
833     event ChangedRegulator(address indexed oldRegulator, address indexed newRegulator );
834 
835 
836     /**
837     * @dev create a new PermissionedToken as a proxy contract
838     * with a brand new data storage 
839     **/
840     constructor(address _implementation, address _regulator) 
841     UpgradeabilityProxy(_implementation) public {
842         regulator = Regulator(_regulator);
843         tokenStorage = new PermissionedTokenStorage();
844     }
845 
846     /**
847     * @dev Upgrade the backing implementation of the proxy.
848     * Only the admin can call this function.
849     * @param newImplementation Address of the new implementation.
850     */
851     function upgradeTo(address newImplementation) public onlyOwner {
852         _upgradeTo(newImplementation);
853     }
854 
855 
856     /**
857     * @return The address of the implementation.
858     */
859     function implementation() public view returns (address) {
860         return _implementation();
861     }
862 }
863 
864 /**
865  * @title CarbonDollarRegulator
866  * @dev CarbonDollarRegulator is a type of Regulator that modifies its definitions of
867  * what constitutes a "whitelisted/nonlisted/blacklisted" user. A CarbonDollar
868  * provides a user the additional ability to convert from CUSD into a whtielisted stablecoin
869  *
870  */
871 contract CarbonDollarRegulator is Regulator {
872 
873     // Getters
874     function isWhitelistedUser(address _who) public view returns(bool) {
875         return (hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
876         && hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
877         && !hasUserPermission(_who, BLACKLISTED_SIG));
878     }
879 
880     function isBlacklistedUser(address _who) public view returns(bool) {
881         return (!hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
882         && !hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
883         && hasUserPermission(_who, BLACKLISTED_SIG));
884     }
885 
886     function isNonlistedUser(address _who) public view returns(bool) {
887         return (!hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
888         && !hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
889         && !hasUserPermission(_who, BLACKLISTED_SIG));
890     }
891 
892     /** Internal functions **/
893     
894     // Setters: CarbonDollarRegulator overrides the definitions of whitelisted, nonlisted, and blacklisted setUserPermission
895 
896     // CarbonDollar whitelisted users burn CUSD into a WhitelistedToken. Unlike PermissionedToken 
897     // whitelisted users, CarbonDollar whitelisted users cannot burn ordinary CUSD without converting into WT
898     function _setWhitelistedUser(address _who) internal {
899         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
900         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
901         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
902         setUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
903         setUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
904         removeUserPermission(_who, BLACKLISTED_SIG);
905         emit LogWhitelistedUser(_who);
906     }
907 
908     function _setBlacklistedUser(address _who) internal {
909         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
910         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
911         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
912         removeUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
913         removeUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
914         setUserPermission(_who, BLACKLISTED_SIG);
915         emit LogBlacklistedUser(_who);
916     }
917 
918     function _setNonlistedUser(address _who) internal {
919         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
920         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
921         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
922         removeUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
923         removeUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
924         removeUserPermission(_who, BLACKLISTED_SIG);
925         emit LogNonlistedUser(_who);
926     }
927 }
928 
929 /**
930 * @title CarbonDollarProxy
931 * @notice This contract will be the public facing CarbonUSD. All calls to the CarbonUSD contract will
932 * be routed through this proxy, since this proxy contract is the owner of the
933 * storage contracts.
934 */
935 contract CarbonDollarProxy is PermissionedTokenProxy {
936     
937     CarbonDollarStorage public tokenStorage_CD;
938 
939     /** CONSTRUCTOR
940     * @dev Passes along arguments to base class.
941     */
942     constructor(address _implementation, address _regulator) public PermissionedTokenProxy(_implementation, _regulator) {
943         // base class override
944         regulator = CarbonDollarRegulator(_regulator);
945 
946         tokenStorage_CD = new CarbonDollarStorage();
947 
948     }
949 }
950 
951 /**
952 *
953 * @dev CarbonDollarProxyFactory creates new CarbonDollarProxy contracts with new data storage sheets, properly configured
954 * with ownership, and the proxy logic implementations are based on a user-specified CarbonDollar. 
955 *
956 **/
957 contract CarbonDollarProxyFactory {
958     // Parameters
959     address[] public tokens;
960 
961     // Events
962     event CreatedCarbonDollarProxy(address newToken, uint256 index);
963     
964     /**
965     *
966     * @dev generate a new proxy address that users can cast to a PermissionedToken or PermissionedTokenProxy. The
967     * proxy has empty data storage contracts connected to it and it is set with an initial logic contract
968     * to which it will delegate functionality
969     * @param regulator the address of the initial regulator contract that regulates the proxy
970     * @param tokenImplementation the address of the initial PT token implementation
971     *
972     **/
973     function createToken(address tokenImplementation, address regulator) public {
974         
975         address proxy = address(new CarbonDollarProxy(tokenImplementation, regulator));
976 
977         // The function caller should own the proxy contract
978         CarbonDollarProxy(proxy).transferOwnership(msg.sender);
979 
980         tokens.push(proxy);
981         emit CreatedCarbonDollarProxy(proxy, getCount()-1);
982     }
983 
984     // Return number of token proxy contracts created so far
985     function getCount() public view returns (uint256) {
986         return tokens.length;
987     }
988 
989     // Return the i'th created token
990     function getToken(uint i) public view returns(address) {
991         require((i < tokens.length) && (i >= 0), "Invalid index");
992         return tokens[i];
993     }
994 }