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
121 library AddressUtils {
122 
123   /**
124    * Returns whether the target address is a contract
125    * @dev This function will return false if invoked during the constructor of a contract,
126    * as the code is not actually created until after the constructor finishes.
127    * @param addr address to check
128    * @return whether the target address is a contract
129    */
130   function isContract(address addr) internal view returns (bool) {
131     uint256 size;
132     // XXX Currently there is no better way to check if there is a contract in an address
133     // than to check the size of the code at that address.
134     // See https://ethereum.stackexchange.com/a/14016/36603
135     // for more details about how this works.
136     // TODO Check this again before the Serenity release, because all addresses will be
137     // contracts then.
138     // solium-disable-next-line security/no-inline-assembly
139     assembly { size := extcodesize(addr) }
140     return size > 0;
141   }
142 
143 }
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
199  * @title ERC20Basic
200  * @dev Simpler version of ERC20 interface
201  * See https://github.com/ethereum/EIPs/issues/179
202  */
203 contract ERC20Basic {
204   function totalSupply() public view returns (uint256);
205   function balanceOf(address who) public view returns (uint256);
206   function transfer(address to, uint256 value) public returns (bool);
207   event Transfer(address indexed from, address indexed to, uint256 value);
208 }
209 
210 /**
211  * @title ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/20
213  */
214 contract ERC20 is ERC20Basic {
215   function allowance(address owner, address spender)
216     public view returns (uint256);
217 
218   function transferFrom(address from, address to, uint256 value)
219     public returns (bool);
220 
221   function approve(address spender, uint256 value) public returns (bool);
222   event Approval(
223     address indexed owner,
224     address indexed spender,
225     uint256 value
226   );
227 }
228 
229 /**
230 * @title Lockable
231 * @dev Base contract which allows children to lock certain methods from being called by clients.
232 * Locked methods are deemed unsafe by default, but must be implemented in children functionality to adhere by
233 * some inherited standard, for example. 
234 */
235 
236 contract Lockable is Ownable {
237 
238 	// Events
239 	event Unlocked();
240 	event Locked();
241 
242 	// Fields
243 	bool public isMethodEnabled = false;
244 
245 	// Modifiers
246 	/**
247 	* @dev Modifier that disables functions by default unless they are explicitly enabled
248 	*/
249 	modifier whenUnlocked() {
250 		require(isMethodEnabled);
251 		_;
252 	}
253 
254 	// Methods
255 	/**
256 	* @dev called by the owner to enable method
257 	*/
258 	function unlock() onlyOwner public {
259 		isMethodEnabled = true;
260 		emit Unlocked();
261 	}
262 
263 	/**
264 	* @dev called by the owner to disable method, back to normal state
265 	*/
266 	function lock() onlyOwner public {
267 		isMethodEnabled = false;
268 		emit Locked();
269 	}
270 
271 }
272 
273 /**
274  * @title Pausable
275  * @dev Base contract which allows children to implement an emergency stop mechanism. Identical to OpenZeppelin version
276  * except that it uses local Ownable contract
277  */
278 contract Pausable is Ownable {
279   event Pause();
280   event Unpause();
281 
282   bool public paused = false;
283 
284 
285   /**
286    * @dev Modifier to make a function callable only when the contract is not paused.
287    */
288   modifier whenNotPaused() {
289     require(!paused);
290     _;
291   }
292 
293   /**
294    * @dev Modifier to make a function callable only when the contract is paused.
295    */
296   modifier whenPaused() {
297     require(paused);
298     _;
299   }
300 
301   /**
302    * @dev called by the owner to pause, triggers stopped state
303    */
304   function pause() onlyOwner whenNotPaused public {
305     paused = true;
306     emit Pause();
307   }
308 
309   /**
310    * @dev called by the owner to unpause, returns to normal state
311    */
312   function unpause() onlyOwner whenPaused public {
313     paused = false;
314     emit Unpause();
315   }
316 }
317 
318 /**
319 *
320 * @dev Stores permissions and validators and provides setter and getter methods. 
321 * Permissions determine which methods users have access to call. Validators
322 * are able to mutate permissions at the Regulator level.
323 *
324 */
325 contract RegulatorStorage is Ownable {
326     
327     /** 
328         Structs 
329     */
330 
331     /* Contains metadata about a permission to execute a particular method signature. */
332     struct Permission {
333         string name; // A one-word description for the permission. e.g. "canMint"
334         string description; // A longer description for the permission. e.g. "Allows user to mint tokens."
335         string contract_name; // e.g. "PermissionedToken"
336         bool active; // Permissions can be turned on or off by regulator
337     }
338 
339     /** 
340         Constants: stores method signatures. These are potential permissions that a user can have, 
341         and each permission gives the user the ability to call the associated PermissionedToken method signature
342     */
343     bytes4 public constant MINT_SIG = bytes4(keccak256("mint(address,uint256)"));
344     bytes4 public constant MINT_CUSD_SIG = bytes4(keccak256("mintCUSD(address,uint256)"));
345     bytes4 public constant CONVERT_WT_SIG = bytes4(keccak256("convertWT(uint256)"));
346     bytes4 public constant BURN_SIG = bytes4(keccak256("burn(uint256)"));
347     bytes4 public constant CONVERT_CARBON_DOLLAR_SIG = bytes4(keccak256("convertCarbonDollar(address,uint256)"));
348     bytes4 public constant BURN_CARBON_DOLLAR_SIG = bytes4(keccak256("burnCarbonDollar(address,uint256)"));
349     bytes4 public constant DESTROY_BLACKLISTED_TOKENS_SIG = bytes4(keccak256("destroyBlacklistedTokens(address,uint256)"));
350     bytes4 public constant APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG = bytes4(keccak256("approveBlacklistedAddressSpender(address)"));
351     bytes4 public constant BLACKLISTED_SIG = bytes4(keccak256("blacklisted()"));
352 
353     /** 
354         Mappings 
355     */
356 
357     /* each method signature maps to a Permission */
358     mapping (bytes4 => Permission) public permissions;
359     /* list of validators, either active or inactive */
360     mapping (address => bool) public validators;
361     /* each user can be given access to a given method signature */
362     mapping (address => mapping (bytes4 => bool)) public userPermissions;
363 
364     /** 
365         Events 
366     */
367     event PermissionAdded(bytes4 methodsignature);
368     event PermissionRemoved(bytes4 methodsignature);
369     event ValidatorAdded(address indexed validator);
370     event ValidatorRemoved(address indexed validator);
371 
372     /** 
373         Modifiers 
374     */
375     /**
376     * @notice Throws if called by any account that does not have access to set attributes
377     */
378     modifier onlyValidator() {
379         require (isValidator(msg.sender), "Sender must be validator");
380         _;
381     }
382 
383     /**
384     * @notice Sets a permission within the list of permissions.
385     * @param _methodsignature Signature of the method that this permission controls.
386     * @param _permissionName A "slug" name for this permission (e.g. "canMint").
387     * @param _permissionDescription A lengthier description for this permission (e.g. "Allows user to mint tokens").
388     * @param _contractName Name of the contract that the method belongs to.
389     */
390     function addPermission(
391         bytes4 _methodsignature, 
392         string _permissionName, 
393         string _permissionDescription, 
394         string _contractName) public onlyValidator { 
395         Permission memory p = Permission(_permissionName, _permissionDescription, _contractName, true);
396         permissions[_methodsignature] = p;
397         emit PermissionAdded(_methodsignature);
398     }
399 
400     /**
401     * @notice Removes a permission the list of permissions.
402     * @param _methodsignature Signature of the method that this permission controls.
403     */
404     function removePermission(bytes4 _methodsignature) public onlyValidator {
405         permissions[_methodsignature].active = false;
406         emit PermissionRemoved(_methodsignature);
407     }
408     
409     /**
410     * @notice Sets a permission in the list of permissions that a user has.
411     * @param _methodsignature Signature of the method that this permission controls.
412     */
413     function setUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
414         require(permissions[_methodsignature].active, "Permission being set must be for a valid method signature");
415         userPermissions[_who][_methodsignature] = true;
416     }
417 
418     /**
419     * @notice Removes a permission from the list of permissions that a user has.
420     * @param _methodsignature Signature of the method that this permission controls.
421     */
422     function removeUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
423         require(permissions[_methodsignature].active, "Permission being removed must be for a valid method signature");
424         userPermissions[_who][_methodsignature] = false;
425     }
426 
427     /**
428     * @notice add a Validator
429     * @param _validator Address of validator to add
430     */
431     function addValidator(address _validator) public onlyOwner {
432         validators[_validator] = true;
433         emit ValidatorAdded(_validator);
434     }
435 
436     /**
437     * @notice remove a Validator
438     * @param _validator Address of validator to remove
439     */
440     function removeValidator(address _validator) public onlyOwner {
441         validators[_validator] = false;
442         emit ValidatorRemoved(_validator);
443     }
444 
445     /**
446     * @notice does validator exist?
447     * @return true if yes, false if no
448     **/
449     function isValidator(address _validator) public view returns (bool) {
450         return validators[_validator];
451     }
452 
453     /**
454     * @notice does permission exist?
455     * @return true if yes, false if no
456     **/
457     function isPermission(bytes4 _methodsignature) public view returns (bool) {
458         return permissions[_methodsignature].active;
459     }
460 
461     /**
462     * @notice get Permission structure
463     * @param _methodsignature request to retrieve the Permission struct for this methodsignature
464     * @return Permission
465     **/
466     function getPermission(bytes4 _methodsignature) public view returns 
467         (string name, 
468          string description, 
469          string contract_name,
470          bool active) {
471         return (permissions[_methodsignature].name,
472                 permissions[_methodsignature].description,
473                 permissions[_methodsignature].contract_name,
474                 permissions[_methodsignature].active);
475     }
476 
477     /**
478     * @notice does permission exist?
479     * @return true if yes, false if no
480     **/
481     function hasUserPermission(address _who, bytes4 _methodsignature) public view returns (bool) {
482         return userPermissions[_who][_methodsignature];
483     }
484 }
485 
486 /**
487  * @title Regulator
488  * @dev Regulator can be configured to meet relevant securities regulations, KYC policies
489  * AML requirements, tax laws, and more. The Regulator ensures that the PermissionedToken
490  * makes compliant transfers possible. Contains the userPermissions necessary
491  * for regulatory compliance.
492  *
493  */
494 contract Regulator is RegulatorStorage {
495     
496     /** 
497         Modifiers 
498     */
499     /**
500     * @notice Throws if called by any account that does not have access to set attributes
501     */
502     modifier onlyValidator() {
503         require (isValidator(msg.sender), "Sender must be validator");
504         _;
505     }
506 
507     /** 
508         Events 
509     */
510     event LogWhitelistedUser(address indexed who);
511     event LogBlacklistedUser(address indexed who);
512     event LogNonlistedUser(address indexed who);
513     event LogSetMinter(address indexed who);
514     event LogRemovedMinter(address indexed who);
515     event LogSetBlacklistDestroyer(address indexed who);
516     event LogRemovedBlacklistDestroyer(address indexed who);
517     event LogSetBlacklistSpender(address indexed who);
518     event LogRemovedBlacklistSpender(address indexed who);
519 
520     /**
521     * @notice Sets the necessary permissions for a user to mint tokens.
522     * @param _who The address of the account that we are setting permissions for.
523     */
524     function setMinter(address _who) public onlyValidator {
525         _setMinter(_who);
526     }
527 
528     /**
529     * @notice Removes the necessary permissions for a user to mint tokens.
530     * @param _who The address of the account that we are removing permissions for.
531     */
532     function removeMinter(address _who) public onlyValidator {
533         _removeMinter(_who);
534     }
535 
536     /**
537     * @notice Sets the necessary permissions for a user to spend tokens from a blacklisted account.
538     * @param _who The address of the account that we are setting permissions for.
539     */
540     function setBlacklistSpender(address _who) public onlyValidator {
541         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
542         setUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
543         emit LogSetBlacklistSpender(_who);
544     }
545     
546     /**
547     * @notice Removes the necessary permissions for a user to spend tokens from a blacklisted account.
548     * @param _who The address of the account that we are removing permissions for.
549     */
550     function removeBlacklistSpender(address _who) public onlyValidator {
551         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
552         removeUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
553         emit LogRemovedBlacklistSpender(_who);
554     }
555 
556     /**
557     * @notice Sets the necessary permissions for a user to destroy tokens from a blacklisted account.
558     * @param _who The address of the account that we are setting permissions for.
559     */
560     function setBlacklistDestroyer(address _who) public onlyValidator {
561         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
562         setUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
563         emit LogSetBlacklistDestroyer(_who);
564     }
565     
566 
567     /**
568     * @notice Removes the necessary permissions for a user to destroy tokens from a blacklisted account.
569     * @param _who The address of the account that we are removing permissions for.
570     */
571     function removeBlacklistDestroyer(address _who) public onlyValidator {
572         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
573         removeUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
574         emit LogRemovedBlacklistDestroyer(_who);
575     }
576 
577     /**
578     * @notice Sets the necessary permissions for a "whitelisted" user.
579     * @param _who The address of the account that we are setting permissions for.
580     */
581     function setWhitelistedUser(address _who) public onlyValidator {
582         _setWhitelistedUser(_who);
583     }
584 
585     /**
586     * @notice Sets the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
587     * frozen; they cannot transfer, burn, or withdraw any tokens.
588     * @param _who The address of the account that we are setting permissions for.
589     */
590     function setBlacklistedUser(address _who) public onlyValidator {
591         _setBlacklistedUser(_who);
592     }
593 
594     /**
595     * @notice Sets the necessary permissions for a "nonlisted" user. Nonlisted users can trade tokens,
596     * but cannot burn them (and therefore cannot convert them into fiat.)
597     * @param _who The address of the account that we are setting permissions for.
598     */
599     function setNonlistedUser(address _who) public onlyValidator {
600         _setNonlistedUser(_who);
601     }
602 
603     /** Returns whether or not a user is whitelisted.
604      * @param _who The address of the account in question.
605      * @return `true` if the user is whitelisted, `false` otherwise.
606      */
607     function isWhitelistedUser(address _who) public view returns (bool) {
608         return (hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
609     }
610 
611     /** Returns whether or not a user is blacklisted.
612      * @param _who The address of the account in question.
613      * @return `true` if the user is blacklisted, `false` otherwise.
614      */
615     function isBlacklistedUser(address _who) public view returns (bool) {
616         return (!hasUserPermission(_who, BURN_SIG) && hasUserPermission(_who, BLACKLISTED_SIG));
617     }
618 
619     /** Returns whether or not a user is nonlisted.
620      * @param _who The address of the account in question.
621      * @return `true` if the user is nonlisted, `false` otherwise.
622      */
623     function isNonlistedUser(address _who) public view returns (bool) {
624         return (!hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
625     }
626 
627     /** Returns whether or not a user is a blacklist spender.
628      * @param _who The address of the account in question.
629      * @return `true` if the user is a blacklist spender, `false` otherwise.
630      */
631     function isBlacklistSpender(address _who) public view returns (bool) {
632         return hasUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
633     }
634 
635     /** Returns whether or not a user is a blacklist destroyer.
636      * @param _who The address of the account in question.
637      * @return `true` if the user is a blacklist destroyer, `false` otherwise.
638      */
639     function isBlacklistDestroyer(address _who) public view returns (bool) {
640         return hasUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
641     }
642 
643     /** Returns whether or not a user is a minter.
644      * @param _who The address of the account in question.
645      * @return `true` if the user is a minter, `false` otherwise.
646      */
647     function isMinter(address _who) public view returns (bool) {
648         return hasUserPermission(_who, MINT_SIG);
649     }
650 
651     /** Internal Functions **/
652 
653     function _setMinter(address _who) internal {
654         require(isPermission(MINT_SIG), "Minting not supported by token");
655         setUserPermission(_who, MINT_SIG);
656         emit LogSetMinter(_who);
657     }
658 
659     function _removeMinter(address _who) internal {
660         require(isPermission(MINT_SIG), "Minting not supported by token");
661         removeUserPermission(_who, MINT_SIG);
662         emit LogRemovedMinter(_who);
663     }
664 
665     function _setNonlistedUser(address _who) internal {
666         require(isPermission(BURN_SIG), "Burn method not supported by token");
667         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
668         removeUserPermission(_who, BURN_SIG);
669         removeUserPermission(_who, BLACKLISTED_SIG);
670         emit LogNonlistedUser(_who);
671     }
672 
673     function _setBlacklistedUser(address _who) internal {
674         require(isPermission(BURN_SIG), "Burn method not supported by token");
675         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
676         removeUserPermission(_who, BURN_SIG);
677         setUserPermission(_who, BLACKLISTED_SIG);
678         emit LogBlacklistedUser(_who);
679     }
680 
681     function _setWhitelistedUser(address _who) internal {
682         require(isPermission(BURN_SIG), "Burn method not supported by token");
683         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
684         setUserPermission(_who, BURN_SIG);
685         removeUserPermission(_who, BLACKLISTED_SIG);
686         emit LogWhitelistedUser(_who);
687     }
688 }
689 
690 /**
691 * @title PermissionedToken
692 * @notice A permissioned token that enables transfers, withdrawals, and deposits to occur 
693 * if and only if it is approved by an on-chain Regulator service. PermissionedToken is an
694 * ERC-20 smart contract representing ownership of securities and overrides the
695 * transfer, burn, and mint methods to check with the Regulator.
696 */
697 contract PermissionedToken is ERC20, Pausable, Lockable {
698     using SafeMath for uint256;
699 
700     /** Events */
701     event DestroyedBlacklistedTokens(address indexed account, uint256 amount);
702     event ApprovedBlacklistedAddressSpender(address indexed owner, address indexed spender, uint256 value);
703     event Mint(address indexed to, uint256 value);
704     event Burn(address indexed burner, uint256 value);
705     event Transfer(address indexed from, address indexed to, uint256 value);
706     event Approval(address indexed owner, address indexed spender, uint256 value);
707     event ChangedRegulator(address indexed oldRegulator, address indexed newRegulator );
708 
709     PermissionedTokenStorage public tokenStorage;
710     Regulator public regulator;
711 
712     /**
713     * @dev create a new PermissionedToken with a brand new data storage
714     **/
715     constructor (address _regulator) public {
716         regulator = Regulator(_regulator);
717         tokenStorage = new PermissionedTokenStorage();
718     }
719 
720     /** Modifiers **/
721 
722     /** @notice Modifier that allows function access to be restricted based on
723     * whether the regulator allows the message sender to execute that function.
724     **/
725     modifier requiresPermission() {
726         require (regulator.hasUserPermission(msg.sender, msg.sig), "User does not have permission to execute function");
727         _;
728     }
729 
730     /** @notice Modifier that checks whether or not a transferFrom operation can
731     * succeed with the given _from and _to address. See transferFrom()'s documentation for
732     * more details.
733     **/
734     modifier transferFromConditionsRequired(address _from, address _to) {
735         require(!regulator.isBlacklistedUser(_to), "Recipient cannot be blacklisted");
736         
737         // If the origin user is blacklisted, the transaction can only succeed if 
738         // the message sender is a user that has been approved to transfer 
739         // blacklisted tokens out of this address.
740         bool is_origin_blacklisted = regulator.isBlacklistedUser(_from);
741 
742         // Is the message sender a person with the ability to transfer tokens out of a blacklisted account?
743         bool sender_can_spend_from_blacklisted_address = regulator.isBlacklistSpender(msg.sender);
744         require(!is_origin_blacklisted || sender_can_spend_from_blacklisted_address, "Origin cannot be blacklisted if spender is not an approved blacklist spender");
745         _;
746     }
747 
748     /** @notice Modifier that checks whether a user is whitelisted.
749      * @param _user The address of the user to check.
750     **/
751     modifier userWhitelisted(address _user) {
752         require(regulator.isWhitelistedUser(_user), "User must be whitelisted");
753         _;
754     }
755 
756     /** @notice Modifier that checks whether a user is blacklisted.
757      * @param _user The address of the user to check.
758     **/
759     modifier userBlacklisted(address _user) {
760         require(regulator.isBlacklistedUser(_user), "User must be blacklisted");
761         _;
762     }
763 
764     /** @notice Modifier that checks whether a user is not blacklisted.
765      * @param _user The address of the user to check.
766     **/
767     modifier userNotBlacklisted(address _user) {
768         require(!regulator.isBlacklistedUser(_user), "User must not be blacklisted");
769         _;
770     }
771 
772     /** Functions **/
773 
774     /**
775     * @notice Allows user to mint if they have the appropriate permissions. User generally
776     * has to be some sort of centralized authority.
777     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
778     * @param _to The address of the receiver
779     * @param _amount The number of tokens to mint
780     */
781     function mint(address _to, uint256 _amount) public requiresPermission whenNotPaused {
782         _mint(_to, _amount);
783     }
784 
785     /**
786     * @notice Allows user to mint if they have the appropriate permissions. User generally
787     * is just a "whitelisted" user (i.e. a user registered with the fiat gateway.)
788     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
789     * @param _amount The number of tokens to burn
790     * @return `true` if successful and `false` if unsuccessful
791     */
792     function burn(uint256 _amount) public requiresPermission whenNotPaused {
793         _burn(msg.sender, _amount);
794     }
795 
796     /**
797     * @notice Implements ERC-20 standard approve function. Locked or disabled by default to protect against
798     * double spend attacks. To modify allowances, clients should call safer increase/decreaseApproval methods.
799     * Upon construction, all calls to approve() will revert unless this contract owner explicitly unlocks approve()
800     */
801     function approve(address _spender, uint256 _value) 
802     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused whenUnlocked returns (bool) {
803         tokenStorage.setAllowance(msg.sender, _spender, _value);
804         emit Approval(msg.sender, _spender, _value);
805         return true;
806     }
807 
808     /**
809      * @dev Increase the amount of tokens that an owner allowed to a spender.
810      * @notice increaseApproval should be used instead of approve when the user's allowance
811      * is greater than 0. Using increaseApproval protects against potential double-spend attacks
812      * by moving the check of whether the user has spent their allowance to the time that the transaction 
813      * is mined, removing the user's ability to double-spend
814      * @param _spender The address which will spend the funds.
815      * @param _addedValue The amount of tokens to increase the allowance by.
816      */
817     function increaseApproval(address _spender, uint256 _addedValue) 
818     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
819         _increaseApproval(_spender, _addedValue, msg.sender);
820         return true;
821     }
822 
823     /**
824      * @dev Decrease the amount of tokens that an owner allowed to a spender.
825      * @notice decreaseApproval should be used instead of approve when the user's allowance
826      * is greater than 0. Using decreaseApproval protects against potential double-spend attacks
827      * by moving the check of whether the user has spent their allowance to the time that the transaction 
828      * is mined, removing the user's ability to double-spend
829      * @param _spender The address which will spend the funds.
830      * @param _subtractedValue The amount of tokens to decrease the allowance by.
831      */
832     function decreaseApproval(address _spender, uint256 _subtractedValue) 
833     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
834         _decreaseApproval(_spender, _subtractedValue, msg.sender);
835         return true;
836     }
837 
838     /**
839     * @notice Destroy the tokens owned by a blacklisted account. This function can generally
840     * only be called by a central authority.
841     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
842     * @param _who Account to destroy tokens from. Must be a blacklisted account.
843     */
844     function destroyBlacklistedTokens(address _who, uint256 _amount) public userBlacklisted(_who) whenNotPaused requiresPermission {
845         tokenStorage.subBalance(_who, _amount);
846         tokenStorage.subTotalSupply(_amount);
847         emit DestroyedBlacklistedTokens(_who, _amount);
848     }
849     /**
850     * @notice Allows a central authority to approve themselves as a spender on a blacklisted account.
851     * By default, the allowance is set to the balance of the blacklisted account, so that the
852     * authority has full control over the account balance.
853     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
854     * @param _blacklistedAccount The blacklisted account.
855     */
856     function approveBlacklistedAddressSpender(address _blacklistedAccount) 
857     public userBlacklisted(_blacklistedAccount) whenNotPaused requiresPermission {
858         tokenStorage.setAllowance(_blacklistedAccount, msg.sender, balanceOf(_blacklistedAccount));
859         emit ApprovedBlacklistedAddressSpender(_blacklistedAccount, msg.sender, balanceOf(_blacklistedAccount));
860     }
861 
862     /**
863     * @notice Initiates a "send" operation towards another user. See `transferFrom` for details.
864     * @param _to The address of the receiver. This user must not be blacklisted, or else the tranfer
865     * will fail.
866     * @param _amount The number of tokens to transfer
867     *
868     * @return `true` if successful 
869     */
870     function transfer(address _to, uint256 _amount) public userNotBlacklisted(_to) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
871         require(_to != address(0),"to address cannot be 0x0");
872         require(_amount <= balanceOf(msg.sender),"not enough balance to transfer");
873 
874         tokenStorage.subBalance(msg.sender, _amount);
875         tokenStorage.addBalance(_to, _amount);
876         emit Transfer(msg.sender, _to, _amount);
877         return true;
878     }
879 
880     /**
881     * @notice Initiates a transfer operation between address `_from` and `_to`. Requires that the
882     * message sender is an approved spender on the _from account.
883     * @dev When implemented, it should use the transferFromConditionsRequired() modifier.
884     * @param _to The address of the recipient. This address must not be blacklisted.
885     * @param _from The address of the origin of funds. This address _could_ be blacklisted, because
886     * a regulator may want to transfer tokens out of a blacklisted account, for example.
887     * In order to do so, the regulator would have to add themselves as an approved spender
888     * on the account via `addBlacklistAddressSpender()`, and would then be able to transfer tokens out of it.
889     * @param _amount The number of tokens to transfer
890     * @return `true` if successful 
891     */
892     function transferFrom(address _from, address _to, uint256 _amount) 
893     public whenNotPaused transferFromConditionsRequired(_from, _to) returns (bool) {
894         require(_amount <= allowance(_from, msg.sender),"not enough allowance to transfer");
895         require(_to != address(0),"to address cannot be 0x0");
896         require(_amount <= balanceOf(_from),"not enough balance to transfer");
897         
898         tokenStorage.subAllowance(_from, msg.sender, _amount);
899         tokenStorage.addBalance(_to, _amount);
900         tokenStorage.subBalance(_from, _amount);
901         emit Transfer(_from, _to, _amount);
902         return true;
903     }
904 
905     /**
906     *
907     * @dev Only the token owner can change its regulator
908     * @param _newRegulator the new Regulator for this token
909     *
910     */
911     function setRegulator(address _newRegulator) public onlyOwner {
912         require(_newRegulator != address(regulator), "Must be a new regulator");
913         require(AddressUtils.isContract(_newRegulator), "Cannot set a regulator storage to a non-contract address");
914         address old = address(regulator);
915         regulator = Regulator(_newRegulator);
916         emit ChangedRegulator(old, _newRegulator);
917     }
918 
919     /**
920     * @notice If a user is blacklisted, they will have the permission to 
921     * execute this dummy function. This function effectively acts as a marker 
922     * to indicate that a user is blacklisted. We include this function to be consistent with our
923     * invariant that every possible userPermission (listed in Regulator) enables access to a single 
924     * PermissionedToken function. Thus, the 'BLACKLISTED' permission gives access to this function
925     * @return `true` if successful
926     */
927     function blacklisted() public view requiresPermission returns (bool) {
928         return true;
929     }
930 
931     /**
932     * ERC20 standard functions
933     */
934     function allowance(address owner, address spender) public view returns (uint256) {
935         return tokenStorage.allowances(owner, spender);
936     }
937 
938     function totalSupply() public view returns (uint256) {
939         return tokenStorage.totalSupply();
940     }
941 
942     function balanceOf(address _addr) public view returns (uint256) {
943         return tokenStorage.balances(_addr);
944     }
945 
946 
947     /** Internal functions **/
948     
949     function _decreaseApproval(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
950         uint256 oldValue = allowance(_tokenHolder, _spender);
951         if (_subtractedValue > oldValue) {
952             tokenStorage.setAllowance(_tokenHolder, _spender, 0);
953         } else {
954             tokenStorage.subAllowance(_tokenHolder, _spender, _subtractedValue);
955         }
956         emit Approval(_tokenHolder, _spender, allowance(_tokenHolder, _spender));
957     }
958 
959     function _increaseApproval(address _spender, uint256 _addedValue, address _tokenHolder) internal {
960         tokenStorage.addAllowance(_tokenHolder, _spender, _addedValue);
961         emit Approval(_tokenHolder, _spender, allowance(_tokenHolder, _spender));
962     }
963 
964     function _burn(address _tokensOf, uint256 _amount) internal {
965         require(_amount <= balanceOf(_tokensOf),"not enough balance to burn");
966         // no need to require value <= totalSupply, since that would imply the
967         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
968         tokenStorage.subBalance(_tokensOf, _amount);
969         tokenStorage.subTotalSupply(_amount);
970         emit Burn(_tokensOf, _amount);
971         emit Transfer(_tokensOf, address(0), _amount);
972     }
973 
974     function _mint(address _to, uint256 _amount) internal userWhitelisted(_to) {
975         tokenStorage.addTotalSupply(_amount);
976         tokenStorage.addBalance(_to, _amount);
977         emit Mint(_to, _amount);
978         emit Transfer(address(0), _to, _amount);
979     }
980 
981 }
982 
983 /**
984 * @title CarbonDollarStorage
985 * @notice Contains necessary storage contracts for CarbonDollar (FeeSheet and StablecoinWhitelist).
986 */
987 contract CarbonDollarStorage is Ownable {
988     using SafeMath for uint256;
989 
990     /** 
991         Mappings
992     */
993     /* fees for withdrawing to stablecoin, in tenths of a percent) */
994     mapping (address => uint256) public fees;
995     /** @dev Units for fees are always in a tenth of a percent */
996     uint256 public defaultFee;
997     /* is the token address referring to a stablecoin/whitelisted token? */
998     mapping (address => bool) public whitelist;
999 
1000 
1001     /** 
1002         Events
1003     */
1004     event DefaultFeeChanged(uint256 oldFee, uint256 newFee);
1005     event FeeChanged(address indexed stablecoin, uint256 oldFee, uint256 newFee);
1006     event FeeRemoved(address indexed stablecoin, uint256 oldFee);
1007     event StablecoinAdded(address indexed stablecoin);
1008     event StablecoinRemoved(address indexed stablecoin);
1009 
1010     /** @notice Sets the default fee for burning CarbonDollar into a whitelisted stablecoin.
1011         @param _fee The default fee.
1012     */
1013     function setDefaultFee(uint256 _fee) public onlyOwner {
1014         uint256 oldFee = defaultFee;
1015         defaultFee = _fee;
1016         if (oldFee != defaultFee)
1017             emit DefaultFeeChanged(oldFee, _fee);
1018     }
1019     
1020     /** @notice Set a fee for burning CarbonDollar into a stablecoin.
1021         @param _stablecoin Address of a whitelisted stablecoin.
1022         @param _fee the fee.
1023     */
1024     function setFee(address _stablecoin, uint256 _fee) public onlyOwner {
1025         uint256 oldFee = fees[_stablecoin];
1026         fees[_stablecoin] = _fee;
1027         if (oldFee != _fee)
1028             emit FeeChanged(_stablecoin, oldFee, _fee);
1029     }
1030 
1031     /** @notice Remove the fee for burning CarbonDollar into a particular kind of stablecoin.
1032         @param _stablecoin Address of stablecoin.
1033     */
1034     function removeFee(address _stablecoin) public onlyOwner {
1035         uint256 oldFee = fees[_stablecoin];
1036         fees[_stablecoin] = 0;
1037         if (oldFee != 0)
1038             emit FeeRemoved(_stablecoin, oldFee);
1039     }
1040 
1041     /** @notice Add a token to the whitelist.
1042         @param _stablecoin Address of the new stablecoin.
1043     */
1044     function addStablecoin(address _stablecoin) public onlyOwner {
1045         whitelist[_stablecoin] = true;
1046         emit StablecoinAdded(_stablecoin);
1047     }
1048 
1049     /** @notice Removes a token from the whitelist.
1050         @param _stablecoin Address of the ex-stablecoin.
1051     */
1052     function removeStablecoin(address _stablecoin) public onlyOwner {
1053         whitelist[_stablecoin] = false;
1054         emit StablecoinRemoved(_stablecoin);
1055     }
1056 
1057 
1058     /**
1059      * @notice Compute the fee that will be charged on a "burn" operation.
1060      * @param _amount The amount that will be traded.
1061      * @param _stablecoin The stablecoin whose fee will be used.
1062      */
1063     function computeStablecoinFee(uint256 _amount, address _stablecoin) public view returns (uint256) {
1064         uint256 fee = fees[_stablecoin];
1065         return computeFee(_amount, fee);
1066     }
1067 
1068     /**
1069      * @notice Compute the fee that will be charged on a "burn" operation.
1070      * @param _amount The amount that will be traded.
1071      * @param _fee The fee that will be charged, in tenths of a percent.
1072      */
1073     function computeFee(uint256 _amount, uint256 _fee) public pure returns (uint256) {
1074         return _amount.mul(_fee).div(1000);
1075     }
1076 }
1077 
1078 /**
1079  * @title WhitelistedTokenRegulator
1080  * @dev WhitelistedTokenRegulator is a type of Regulator that modifies its definitions of
1081  * what constitutes a "whitelisted/nonlisted/blacklisted" user. A WhitelistedToken
1082  * provides a user the additional ability to convert from a whtielisted stablecoin into the
1083  * meta-token CUSD, or mint CUSD directly through a specific WT.
1084  *
1085  */
1086 contract WhitelistedTokenRegulator is Regulator {
1087 
1088     function isMinter(address _who) public view returns (bool) {
1089         return (super.isMinter(_who) && hasUserPermission(_who, MINT_CUSD_SIG));
1090     }
1091 
1092     // Getters
1093 
1094     function isWhitelistedUser(address _who) public view returns (bool) {
1095         return (hasUserPermission(_who, CONVERT_WT_SIG) && super.isWhitelistedUser(_who));
1096     }
1097 
1098     function isBlacklistedUser(address _who) public view returns (bool) {
1099         return (!hasUserPermission(_who, CONVERT_WT_SIG) && super.isBlacklistedUser(_who));
1100     }
1101 
1102     function isNonlistedUser(address _who) public view returns (bool) {
1103         return (!hasUserPermission(_who, CONVERT_WT_SIG) && super.isNonlistedUser(_who));
1104     }   
1105 
1106     /** Internal functions **/
1107 
1108     // A WT minter should have option to either mint directly into CUSD via mintCUSD(), or
1109     // mint the WT via an ordinary mint() 
1110     function _setMinter(address _who) internal {
1111         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
1112         setUserPermission(_who, MINT_CUSD_SIG);
1113         super._setMinter(_who);
1114     }
1115 
1116     function _removeMinter(address _who) internal {
1117         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
1118         removeUserPermission(_who, MINT_CUSD_SIG);
1119         super._removeMinter(_who);
1120     }
1121 
1122     // Setters
1123 
1124     // A WT whitelisted user should gain ability to convert their WT into CUSD. They can also burn their WT, as a
1125     // PermissionedToken whitelisted user can do
1126     function _setWhitelistedUser(address _who) internal {
1127         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
1128         setUserPermission(_who, CONVERT_WT_SIG);
1129         super._setWhitelistedUser(_who);
1130     }
1131 
1132     function _setBlacklistedUser(address _who) internal {
1133         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
1134         removeUserPermission(_who, CONVERT_WT_SIG);
1135         super._setBlacklistedUser(_who);
1136     }
1137 
1138     function _setNonlistedUser(address _who) internal {
1139         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
1140         removeUserPermission(_who, CONVERT_WT_SIG);
1141         super._setNonlistedUser(_who);
1142     }
1143 
1144 }
1145 
1146 /**
1147 * @title WhitelistedToken
1148 * @notice A WhitelistedToken can be converted into CUSD and vice versa. Converting a WT into a CUSD
1149 * is the only way for a user to obtain CUSD. This is a permissioned token, so users have to be 
1150 * whitelisted before they can do any mint/burn/convert operation.
1151 */
1152 contract WhitelistedToken is PermissionedToken {
1153 
1154 
1155     address public cusdAddress;
1156 
1157     /**
1158         Events
1159      */
1160     event CUSDAddressChanged(address indexed oldCUSD, address indexed newCUSD);
1161     event MintedToCUSD(address indexed user, uint256 amount);
1162     event ConvertedToCUSD(address indexed user, uint256 amount);
1163 
1164     /**
1165     * @notice Constructor sets the regulator contract and the address of the
1166     * CarbonUSD meta-token contract. The latter is necessary in order to make transactions
1167     * with the CarbonDollar smart contract.
1168     */
1169     constructor(address _regulator, address _cusd) public PermissionedToken(_regulator) {
1170 
1171         // base class fields
1172         regulator = WhitelistedTokenRegulator(_regulator);
1173 
1174         cusdAddress = _cusd;
1175 
1176     }
1177 
1178     /**
1179     * @notice Mints CarbonUSD for the user. Stores the WT0 that backs the CarbonUSD
1180     * into the CarbonUSD contract's escrow account.
1181     * @param _to The address of the receiver
1182     * @param _amount The number of CarbonTokens to mint to user
1183     */
1184     function mintCUSD(address _to, uint256 _amount) public requiresPermission whenNotPaused userWhitelisted(_to) {
1185         return _mintCUSD(_to, _amount);
1186     }
1187 
1188     /**
1189     * @notice Converts WT0 to CarbonUSD for the user. Stores the WT0 that backs the CarbonUSD
1190     * into the CarbonUSD contract's escrow account.
1191     * @param _amount The number of Whitelisted tokens to convert
1192     */
1193     function convertWT(uint256 _amount) public requiresPermission whenNotPaused {
1194         require(balanceOf(msg.sender) >= _amount, "Conversion amount should be less than balance");
1195         _burn(msg.sender, _amount);
1196         _mintCUSD(msg.sender, _amount);
1197         emit ConvertedToCUSD(msg.sender, _amount);
1198     }
1199 
1200     /**
1201      * @notice Change the cusd address.
1202      * @param _cusd the cusd address.
1203      */
1204     function setCUSDAddress(address _cusd) public onlyOwner {
1205         require(_cusd != address(cusdAddress), "Must be a new cusd address");
1206         require(AddressUtils.isContract(_cusd), "Must be an actual contract");
1207         address oldCUSD = address(cusdAddress);
1208         cusdAddress = _cusd;
1209         emit CUSDAddressChanged(oldCUSD, _cusd);
1210     }
1211 
1212     function _mintCUSD(address _to, uint256 _amount) internal {
1213         require(_to != cusdAddress, "Cannot mint to CarbonUSD contract"); // This is to prevent Carbon Labs from printing money out of thin air!
1214         CarbonDollar(cusdAddress).mint(_to, _amount);
1215         _mint(cusdAddress, _amount);
1216         emit MintedToCUSD(_to, _amount);
1217     }
1218 }
1219 
1220 /**
1221  * @title CarbonDollarRegulator
1222  * @dev CarbonDollarRegulator is a type of Regulator that modifies its definitions of
1223  * what constitutes a "whitelisted/nonlisted/blacklisted" user. A CarbonDollar
1224  * provides a user the additional ability to convert from CUSD into a whtielisted stablecoin
1225  *
1226  */
1227 contract CarbonDollarRegulator is Regulator {
1228 
1229     // Getters
1230     function isWhitelistedUser(address _who) public view returns(bool) {
1231         return (hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
1232         && hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
1233         && !hasUserPermission(_who, BLACKLISTED_SIG));
1234     }
1235 
1236     function isBlacklistedUser(address _who) public view returns(bool) {
1237         return (!hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
1238         && !hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
1239         && hasUserPermission(_who, BLACKLISTED_SIG));
1240     }
1241 
1242     function isNonlistedUser(address _who) public view returns(bool) {
1243         return (!hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
1244         && !hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
1245         && !hasUserPermission(_who, BLACKLISTED_SIG));
1246     }
1247 
1248     /** Internal functions **/
1249     
1250     // Setters: CarbonDollarRegulator overrides the definitions of whitelisted, nonlisted, and blacklisted setUserPermission
1251 
1252     // CarbonDollar whitelisted users burn CUSD into a WhitelistedToken. Unlike PermissionedToken 
1253     // whitelisted users, CarbonDollar whitelisted users cannot burn ordinary CUSD without converting into WT
1254     function _setWhitelistedUser(address _who) internal {
1255         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
1256         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
1257         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
1258         setUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
1259         setUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
1260         removeUserPermission(_who, BLACKLISTED_SIG);
1261         emit LogWhitelistedUser(_who);
1262     }
1263 
1264     function _setBlacklistedUser(address _who) internal {
1265         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
1266         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
1267         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
1268         removeUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
1269         removeUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
1270         setUserPermission(_who, BLACKLISTED_SIG);
1271         emit LogBlacklistedUser(_who);
1272     }
1273 
1274     function _setNonlistedUser(address _who) internal {
1275         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
1276         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
1277         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
1278         removeUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
1279         removeUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
1280         removeUserPermission(_who, BLACKLISTED_SIG);
1281         emit LogNonlistedUser(_who);
1282     }
1283 }
1284 
1285 /**
1286 * @title CarbonDollar
1287 * @notice The main functionality for the CarbonUSD metatoken. (CarbonUSD is just a proxy
1288 * that implements this contract's functionality.) This is a permissioned token, so users have to be 
1289 * whitelisted before they can do any mint/burn/convert operation. Every CarbonDollar token is backed by one
1290 * whitelisted stablecoin credited to the balance of this contract address.
1291 */
1292 contract CarbonDollar is PermissionedToken {
1293     
1294     // Events
1295 
1296     event ConvertedToWT(address indexed user, uint256 amount);
1297     event BurnedCUSD(address indexed user, uint256 feedAmount, uint256 chargedFee);
1298     
1299     /**
1300         Modifiers
1301     */
1302     modifier requiresWhitelistedToken() {
1303         require(isWhitelisted(msg.sender), "Sender must be a whitelisted token contract");
1304         _;
1305     }
1306 
1307     CarbonDollarStorage public tokenStorage_CD;
1308 
1309     /** CONSTRUCTOR
1310     * @dev Passes along arguments to base class.
1311     */
1312     constructor(address _regulator) public PermissionedToken(_regulator) {
1313 
1314         // base class override
1315         regulator = CarbonDollarRegulator(_regulator);
1316 
1317         tokenStorage_CD = new CarbonDollarStorage();
1318     }
1319 
1320     /**
1321      * @notice Add new stablecoin to whitelist.
1322      * @param _stablecoin Address of stablecoin contract.
1323      */
1324     function listToken(address _stablecoin) public onlyOwner whenNotPaused {
1325         tokenStorage_CD.addStablecoin(_stablecoin); 
1326     }
1327 
1328     /**
1329      * @notice Remove existing stablecoin from whitelist.
1330      * @param _stablecoin Address of stablecoin contract.
1331      */
1332     function unlistToken(address _stablecoin) public onlyOwner whenNotPaused {
1333         tokenStorage_CD.removeStablecoin(_stablecoin);
1334     }
1335 
1336     /**
1337      * @notice Change fees associated with going from CarbonUSD to a particular stablecoin.
1338      * @param stablecoin Address of the stablecoin contract.
1339      * @param _newFee The new fee rate to set, in tenths of a percent. 
1340      */
1341     function setFee(address stablecoin, uint256 _newFee) public onlyOwner whenNotPaused {
1342         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1343         tokenStorage_CD.setFee(stablecoin, _newFee);
1344     }
1345 
1346     /**
1347      * @notice Remove fees associated with going from CarbonUSD to a particular stablecoin.
1348      * The default fee still may apply.
1349      * @param stablecoin Address of the stablecoin contract.
1350      */
1351     function removeFee(address stablecoin) public onlyOwner whenNotPaused {
1352         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1353        tokenStorage_CD.removeFee(stablecoin);
1354     }
1355 
1356     /**
1357      * @notice Change the default fee associated with going from CarbonUSD to a WhitelistedToken.
1358      * This fee amount is used if the fee for a WhitelistedToken is not specified.
1359      * @param _newFee The new fee rate to set, in tenths of a percent.
1360      */
1361     function setDefaultFee(uint256 _newFee) public onlyOwner whenNotPaused {
1362         tokenStorage_CD.setDefaultFee(_newFee);
1363     }
1364 
1365     /**
1366      * @notice Mints CUSD on behalf of a user. Note the use of the "requiresWhitelistedToken"
1367      * modifier; this means that minting authority does not belong to any personal account; 
1368      * only whitelisted token contracts can call this function. The intended functionality is that the only
1369      * way to mint CUSD is for the user to actually burn a whitelisted token to convert into CUSD
1370      * @param _to User to send CUSD to
1371      * @param _amount Amount of CarbonUSD to mint.
1372      */
1373     function mint(address _to, uint256 _amount) public requiresWhitelistedToken whenNotPaused {
1374         _mint(_to, _amount);
1375     }
1376 
1377     /**
1378      * @notice user can convert CarbonUSD umbrella token into a whitelisted stablecoin. 
1379      * @param stablecoin represents the type of coin the users wishes to receive for burning carbonUSD
1380      * @param _amount Amount of CarbonUSD to convert.
1381      * we credit the user's account at the sender address with the _amount minus the percentage fee we want to charge.
1382      */
1383     function convertCarbonDollar(address stablecoin, uint256 _amount) public requiresPermission whenNotPaused  {
1384         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1385         WhitelistedToken whitelisted = WhitelistedToken(stablecoin);
1386         require(whitelisted.balanceOf(address(this)) >= _amount, "Carbon escrow account in WT0 doesn't have enough tokens for burning");
1387  
1388         // Send back WT0 to calling user, but with a fee reduction.
1389         // Transfer this fee into the whitelisted token's CarbonDollar account (this contract's address)
1390         uint256 chargedFee = tokenStorage_CD.computeFee(_amount, computeFeeRate(stablecoin));
1391         uint256 feedAmount = _amount.sub(chargedFee);
1392         _burn(msg.sender, _amount);
1393         require(whitelisted.transfer(msg.sender, feedAmount));
1394         whitelisted.burn(chargedFee);
1395         _mint(address(this), chargedFee);
1396         emit ConvertedToWT(msg.sender, _amount);
1397     }
1398 
1399      /**
1400      * @notice burns CarbonDollar and an equal amount of whitelisted stablecoin from the CarbonDollar address
1401      * @param stablecoin Represents the stablecoin whose fee will be charged.
1402      * @param _amount Amount of CarbonUSD to burn.
1403      */
1404     function burnCarbonDollar(address stablecoin, uint256 _amount) public requiresPermission whenNotPaused {
1405         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1406         WhitelistedToken whitelisted = WhitelistedToken(stablecoin);
1407         require(whitelisted.balanceOf(address(this)) >= _amount, "Carbon escrow account in WT0 doesn't have enough tokens for burning");
1408  
1409         // Burn user's CUSD, but with a fee reduction.
1410         uint256 chargedFee = tokenStorage_CD.computeFee(_amount, computeFeeRate(stablecoin));
1411         uint256 feedAmount = _amount.sub(chargedFee);
1412         _burn(msg.sender, _amount);
1413         whitelisted.burn(_amount);
1414         _mint(address(this), chargedFee);
1415         emit BurnedCUSD(msg.sender, feedAmount, chargedFee); // Whitelisted trust account should send user feedAmount USD
1416     }
1417 
1418     /** 
1419     * @notice release collected CUSD fees to owner 
1420     * @param _amount Amount of CUSD to release
1421     * @return `true` if successful 
1422     */
1423     function releaseCarbonDollar(uint256 _amount) public onlyOwner returns (bool) {
1424         require(_amount <= balanceOf(address(this)),"not enough balance to transfer");
1425 
1426         tokenStorage.subBalance(address(this), _amount);
1427         tokenStorage.addBalance(msg.sender, _amount);
1428         emit Transfer(address(this), msg.sender, _amount);
1429         return true;
1430     }
1431 
1432     /** Computes fee percentage associated with burning into a particular stablecoin.
1433      * @param stablecoin The stablecoin whose fee will be charged. Precondition: is a whitelisted
1434      * stablecoin.
1435      * @return The fee that will be charged. If the stablecoin's fee is not set, the default
1436      * fee is returned.
1437      */
1438     function computeFeeRate(address stablecoin) public view returns (uint256 feeRate) {
1439         if (getFee(stablecoin) > 0) 
1440             feeRate = getFee(stablecoin);
1441         else
1442             feeRate = getDefaultFee();
1443     }
1444 
1445     /**
1446     * @notice Check if whitelisted token is whitelisted
1447     * @return bool true if whitelisted, false if not
1448     **/
1449     function isWhitelisted(address _stablecoin) public view returns (bool) {
1450         return tokenStorage_CD.whitelist(_stablecoin);
1451     }
1452 
1453     /**
1454      * @notice Get the fee associated with going from CarbonUSD to a specific WhitelistedToken.
1455      * @param stablecoin The stablecoin whose fee is being checked.
1456      * @return The fee associated with the stablecoin.
1457      */
1458     function getFee(address stablecoin) public view returns (uint256) {
1459         return tokenStorage_CD.fees(stablecoin);
1460     }
1461 
1462     /**
1463      * @notice Get the default fee associated with going from CarbonUSD to a specific WhitelistedToken.
1464      * @return The default fee for stablecoin trades.
1465      */
1466     function getDefaultFee() public view returns (uint256) {
1467         return tokenStorage_CD.defaultFee();
1468     }
1469 
1470     function _mint(address _to, uint256 _amount) internal {
1471         super._mint(_to, _amount);
1472     }
1473 
1474 }
1475 
1476 /**
1477 * @title WhitelistedToken
1478 * @notice A WhitelistedToken can be converted into CUSD and vice versa. Converting a WT into a CUSD
1479 * is the only way for a user to obtain CUSD. This is a permissioned token, so users have to be 
1480 * whitelisted before they can do any mint/burn/convert operation.
1481 */
1482 // contract WhitelistedToken is PermissionedToken {
1483 
1484 
1485 //     address public cusdAddress;
1486 
1487 //     /**
1488 //         Events
1489 //      */
1490 //     event CUSDAddressChanged(address indexed oldCUSD, address indexed newCUSD);
1491 //     event MintedToCUSD(address indexed user, uint256 amount);
1492 //     event ConvertedToCUSD(address indexed user, uint256 amount);
1493 
1494 //     /**
1495 //     * @notice Constructor sets the regulator contract and the address of the
1496 //     * CarbonUSD meta-token contract. The latter is necessary in order to make transactions
1497 //     * with the CarbonDollar smart contract.
1498 //     */
1499 //     constructor(address _regulator, address _cusd) public PermissionedToken(_regulator) {
1500 
1501 //         // base class fields
1502 //         regulator = WhitelistedTokenRegulator(_regulator);
1503 
1504 //         cusdAddress = _cusd;
1505 
1506 //     }
1507 
1508 //     /**
1509 //     * @notice Mints CarbonUSD for the user. Stores the WT0 that backs the CarbonUSD
1510 //     * into the CarbonUSD contract's escrow account.
1511 //     * @param _to The address of the receiver
1512 //     * @param _amount The number of CarbonTokens to mint to user
1513 //     */
1514 //     function mintCUSD(address _to, uint256 _amount) public requiresPermission whenNotPaused userWhitelisted(_to) {
1515 //         return _mintCUSD(_to, _amount);
1516 //     }
1517 
1518 //     *
1519 //     * @notice Converts WT0 to CarbonUSD for the user. Stores the WT0 that backs the CarbonUSD
1520 //     * into the CarbonUSD contract's escrow account.
1521 //     * @param _amount The number of Whitelisted tokens to convert
1522     
1523 //     function convertWT(uint256 _amount) public requiresPermission whenNotPaused {
1524 //         require(balanceOf(msg.sender) >= _amount, "Conversion amount should be less than balance");
1525 //         _burn(msg.sender, _amount);
1526 //         _mintCUSD(msg.sender, _amount);
1527 //         emit ConvertedToCUSD(msg.sender, _amount);
1528 //     }
1529 
1530 //     /**
1531 //      * @notice Change the cusd address.
1532 //      * @param _cusd the cusd address.
1533 //      */
1534 //     function setCUSDAddress(address _cusd) public onlyOwner {
1535 //         require(_cusd != address(cusdAddress), "Must be a new cusd address");
1536 //         require(AddressUtils.isContract(_cusd), "Must be an actual contract");
1537 //         address oldCUSD = address(cusdAddress);
1538 //         cusdAddress = _cusd;
1539 //         emit CUSDAddressChanged(oldCUSD, _cusd);
1540 //     }
1541 
1542 //     function _mintCUSD(address _to, uint256 _amount) internal {
1543 //         require(_to != cusdAddress, "Cannot mint to CarbonUSD contract"); // This is to prevent Carbon Labs from printing money out of thin air!
1544 //         CarbonDollar(cusdAddress).mint(_to, _amount);
1545 //         _mint(cusdAddress, _amount);
1546 //         emit MintedToCUSD(_to, _amount);
1547 //     }
1548 // }