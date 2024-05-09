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
216 library AddressUtils {
217 
218   /**
219    * Returns whether the target address is a contract
220    * @dev This function will return false if invoked during the constructor of a contract,
221    * as the code is not actually created until after the constructor finishes.
222    * @param addr address to check
223    * @return whether the target address is a contract
224    */
225   function isContract(address addr) internal view returns (bool) {
226     uint256 size;
227     // XXX Currently there is no better way to check if there is a contract in an address
228     // than to check the size of the code at that address.
229     // See https://ethereum.stackexchange.com/a/14016/36603
230     // for more details about how this works.
231     // TODO Check this again before the Serenity release, because all addresses will be
232     // contracts then.
233     // solium-disable-next-line security/no-inline-assembly
234     assembly { size := extcodesize(addr) }
235     return size > 0;
236   }
237 
238 }
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
294  * @title ERC20Basic
295  * @dev Simpler version of ERC20 interface
296  * See https://github.com/ethereum/EIPs/issues/179
297  */
298 contract ERC20Basic {
299   function totalSupply() public view returns (uint256);
300   function balanceOf(address who) public view returns (uint256);
301   function transfer(address to, uint256 value) public returns (bool);
302   event Transfer(address indexed from, address indexed to, uint256 value);
303 }
304 
305 /**
306  * @title ERC20 interface
307  * @dev see https://github.com/ethereum/EIPs/issues/20
308  */
309 contract ERC20 is ERC20Basic {
310   function allowance(address owner, address spender)
311     public view returns (uint256);
312 
313   function transferFrom(address from, address to, uint256 value)
314     public returns (bool);
315 
316   function approve(address spender, uint256 value) public returns (bool);
317   event Approval(
318     address indexed owner,
319     address indexed spender,
320     uint256 value
321   );
322 }
323 
324 /**
325 * @title Lockable
326 * @dev Base contract which allows children to lock certain methods from being called by clients.
327 * Locked methods are deemed unsafe by default, but must be implemented in children functionality to adhere by
328 * some inherited standard, for example. 
329 */
330 
331 contract Lockable is Ownable {
332 
333 	// Events
334 	event Unlocked();
335 	event Locked();
336 
337 	// Fields
338 	bool public isMethodEnabled = false;
339 
340 	// Modifiers
341 	/**
342 	* @dev Modifier that disables functions by default unless they are explicitly enabled
343 	*/
344 	modifier whenUnlocked() {
345 		require(isMethodEnabled);
346 		_;
347 	}
348 
349 	// Methods
350 	/**
351 	* @dev called by the owner to enable method
352 	*/
353 	function unlock() onlyOwner public {
354 		isMethodEnabled = true;
355 		emit Unlocked();
356 	}
357 
358 	/**
359 	* @dev called by the owner to disable method, back to normal state
360 	*/
361 	function lock() onlyOwner public {
362 		isMethodEnabled = false;
363 		emit Locked();
364 	}
365 
366 }
367 
368 /**
369  * @title Pausable
370  * @dev Base contract which allows children to implement an emergency stop mechanism. Identical to OpenZeppelin version
371  * except that it uses local Ownable contract
372  */
373 contract Pausable is Ownable {
374   event Pause();
375   event Unpause();
376 
377   bool public paused = false;
378 
379 
380   /**
381    * @dev Modifier to make a function callable only when the contract is not paused.
382    */
383   modifier whenNotPaused() {
384     require(!paused);
385     _;
386   }
387 
388   /**
389    * @dev Modifier to make a function callable only when the contract is paused.
390    */
391   modifier whenPaused() {
392     require(paused);
393     _;
394   }
395 
396   /**
397    * @dev called by the owner to pause, triggers stopped state
398    */
399   function pause() onlyOwner whenNotPaused public {
400     paused = true;
401     emit Pause();
402   }
403 
404   /**
405    * @dev called by the owner to unpause, returns to normal state
406    */
407   function unpause() onlyOwner whenPaused public {
408     paused = false;
409     emit Unpause();
410   }
411 }
412 
413 /**
414 *
415 * @dev Stores permissions and validators and provides setter and getter methods. 
416 * Permissions determine which methods users have access to call. Validators
417 * are able to mutate permissions at the Regulator level.
418 *
419 */
420 contract RegulatorStorage is Ownable {
421     
422     /** 
423         Structs 
424     */
425 
426     /* Contains metadata about a permission to execute a particular method signature. */
427     struct Permission {
428         string name; // A one-word description for the permission. e.g. "canMint"
429         string description; // A longer description for the permission. e.g. "Allows user to mint tokens."
430         string contract_name; // e.g. "PermissionedToken"
431         bool active; // Permissions can be turned on or off by regulator
432     }
433 
434     /** 
435         Constants: stores method signatures. These are potential permissions that a user can have, 
436         and each permission gives the user the ability to call the associated PermissionedToken method signature
437     */
438     bytes4 public constant MINT_SIG = bytes4(keccak256("mint(address,uint256)"));
439     bytes4 public constant MINT_CUSD_SIG = bytes4(keccak256("mintCUSD(address,uint256)"));
440     bytes4 public constant CONVERT_WT_SIG = bytes4(keccak256("convertWT(uint256)"));
441     bytes4 public constant BURN_SIG = bytes4(keccak256("burn(uint256)"));
442     bytes4 public constant CONVERT_CARBON_DOLLAR_SIG = bytes4(keccak256("convertCarbonDollar(address,uint256)"));
443     bytes4 public constant BURN_CARBON_DOLLAR_SIG = bytes4(keccak256("burnCarbonDollar(address,uint256)"));
444     bytes4 public constant DESTROY_BLACKLISTED_TOKENS_SIG = bytes4(keccak256("destroyBlacklistedTokens(address,uint256)"));
445     bytes4 public constant APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG = bytes4(keccak256("approveBlacklistedAddressSpender(address)"));
446     bytes4 public constant BLACKLISTED_SIG = bytes4(keccak256("blacklisted()"));
447 
448     /** 
449         Mappings 
450     */
451 
452     /* each method signature maps to a Permission */
453     mapping (bytes4 => Permission) public permissions;
454     /* list of validators, either active or inactive */
455     mapping (address => bool) public validators;
456     /* each user can be given access to a given method signature */
457     mapping (address => mapping (bytes4 => bool)) public userPermissions;
458 
459     /** 
460         Events 
461     */
462     event PermissionAdded(bytes4 methodsignature);
463     event PermissionRemoved(bytes4 methodsignature);
464     event ValidatorAdded(address indexed validator);
465     event ValidatorRemoved(address indexed validator);
466 
467     /** 
468         Modifiers 
469     */
470     /**
471     * @notice Throws if called by any account that does not have access to set attributes
472     */
473     modifier onlyValidator() {
474         require (isValidator(msg.sender), "Sender must be validator");
475         _;
476     }
477 
478     /**
479     * @notice Sets a permission within the list of permissions.
480     * @param _methodsignature Signature of the method that this permission controls.
481     * @param _permissionName A "slug" name for this permission (e.g. "canMint").
482     * @param _permissionDescription A lengthier description for this permission (e.g. "Allows user to mint tokens").
483     * @param _contractName Name of the contract that the method belongs to.
484     */
485     function addPermission(
486         bytes4 _methodsignature, 
487         string _permissionName, 
488         string _permissionDescription, 
489         string _contractName) public onlyValidator { 
490         Permission memory p = Permission(_permissionName, _permissionDescription, _contractName, true);
491         permissions[_methodsignature] = p;
492         emit PermissionAdded(_methodsignature);
493     }
494 
495     /**
496     * @notice Removes a permission the list of permissions.
497     * @param _methodsignature Signature of the method that this permission controls.
498     */
499     function removePermission(bytes4 _methodsignature) public onlyValidator {
500         permissions[_methodsignature].active = false;
501         emit PermissionRemoved(_methodsignature);
502     }
503     
504     /**
505     * @notice Sets a permission in the list of permissions that a user has.
506     * @param _methodsignature Signature of the method that this permission controls.
507     */
508     function setUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
509         require(permissions[_methodsignature].active, "Permission being set must be for a valid method signature");
510         userPermissions[_who][_methodsignature] = true;
511     }
512 
513     /**
514     * @notice Removes a permission from the list of permissions that a user has.
515     * @param _methodsignature Signature of the method that this permission controls.
516     */
517     function removeUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
518         require(permissions[_methodsignature].active, "Permission being removed must be for a valid method signature");
519         userPermissions[_who][_methodsignature] = false;
520     }
521 
522     /**
523     * @notice add a Validator
524     * @param _validator Address of validator to add
525     */
526     function addValidator(address _validator) public onlyOwner {
527         validators[_validator] = true;
528         emit ValidatorAdded(_validator);
529     }
530 
531     /**
532     * @notice remove a Validator
533     * @param _validator Address of validator to remove
534     */
535     function removeValidator(address _validator) public onlyOwner {
536         validators[_validator] = false;
537         emit ValidatorRemoved(_validator);
538     }
539 
540     /**
541     * @notice does validator exist?
542     * @return true if yes, false if no
543     **/
544     function isValidator(address _validator) public view returns (bool) {
545         return validators[_validator];
546     }
547 
548     /**
549     * @notice does permission exist?
550     * @return true if yes, false if no
551     **/
552     function isPermission(bytes4 _methodsignature) public view returns (bool) {
553         return permissions[_methodsignature].active;
554     }
555 
556     /**
557     * @notice get Permission structure
558     * @param _methodsignature request to retrieve the Permission struct for this methodsignature
559     * @return Permission
560     **/
561     function getPermission(bytes4 _methodsignature) public view returns 
562         (string name, 
563          string description, 
564          string contract_name,
565          bool active) {
566         return (permissions[_methodsignature].name,
567                 permissions[_methodsignature].description,
568                 permissions[_methodsignature].contract_name,
569                 permissions[_methodsignature].active);
570     }
571 
572     /**
573     * @notice does permission exist?
574     * @return true if yes, false if no
575     **/
576     function hasUserPermission(address _who, bytes4 _methodsignature) public view returns (bool) {
577         return userPermissions[_who][_methodsignature];
578     }
579 }
580 
581 /**
582  * @title Regulator
583  * @dev Regulator can be configured to meet relevant securities regulations, KYC policies
584  * AML requirements, tax laws, and more. The Regulator ensures that the PermissionedToken
585  * makes compliant transfers possible. Contains the userPermissions necessary
586  * for regulatory compliance.
587  *
588  */
589 contract Regulator is RegulatorStorage {
590     
591     /** 
592         Modifiers 
593     */
594     /**
595     * @notice Throws if called by any account that does not have access to set attributes
596     */
597     modifier onlyValidator() {
598         require (isValidator(msg.sender), "Sender must be validator");
599         _;
600     }
601 
602     /** 
603         Events 
604     */
605     event LogWhitelistedUser(address indexed who);
606     event LogBlacklistedUser(address indexed who);
607     event LogNonlistedUser(address indexed who);
608     event LogSetMinter(address indexed who);
609     event LogRemovedMinter(address indexed who);
610     event LogSetBlacklistDestroyer(address indexed who);
611     event LogRemovedBlacklistDestroyer(address indexed who);
612     event LogSetBlacklistSpender(address indexed who);
613     event LogRemovedBlacklistSpender(address indexed who);
614 
615     /**
616     * @notice Sets the necessary permissions for a user to mint tokens.
617     * @param _who The address of the account that we are setting permissions for.
618     */
619     function setMinter(address _who) public onlyValidator {
620         _setMinter(_who);
621     }
622 
623     /**
624     * @notice Removes the necessary permissions for a user to mint tokens.
625     * @param _who The address of the account that we are removing permissions for.
626     */
627     function removeMinter(address _who) public onlyValidator {
628         _removeMinter(_who);
629     }
630 
631     /**
632     * @notice Sets the necessary permissions for a user to spend tokens from a blacklisted account.
633     * @param _who The address of the account that we are setting permissions for.
634     */
635     function setBlacklistSpender(address _who) public onlyValidator {
636         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
637         setUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
638         emit LogSetBlacklistSpender(_who);
639     }
640     
641     /**
642     * @notice Removes the necessary permissions for a user to spend tokens from a blacklisted account.
643     * @param _who The address of the account that we are removing permissions for.
644     */
645     function removeBlacklistSpender(address _who) public onlyValidator {
646         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
647         removeUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
648         emit LogRemovedBlacklistSpender(_who);
649     }
650 
651     /**
652     * @notice Sets the necessary permissions for a user to destroy tokens from a blacklisted account.
653     * @param _who The address of the account that we are setting permissions for.
654     */
655     function setBlacklistDestroyer(address _who) public onlyValidator {
656         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
657         setUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
658         emit LogSetBlacklistDestroyer(_who);
659     }
660     
661 
662     /**
663     * @notice Removes the necessary permissions for a user to destroy tokens from a blacklisted account.
664     * @param _who The address of the account that we are removing permissions for.
665     */
666     function removeBlacklistDestroyer(address _who) public onlyValidator {
667         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
668         removeUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
669         emit LogRemovedBlacklistDestroyer(_who);
670     }
671 
672     /**
673     * @notice Sets the necessary permissions for a "whitelisted" user.
674     * @param _who The address of the account that we are setting permissions for.
675     */
676     function setWhitelistedUser(address _who) public onlyValidator {
677         _setWhitelistedUser(_who);
678     }
679 
680     /**
681     * @notice Sets the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
682     * frozen; they cannot transfer, burn, or withdraw any tokens.
683     * @param _who The address of the account that we are setting permissions for.
684     */
685     function setBlacklistedUser(address _who) public onlyValidator {
686         _setBlacklistedUser(_who);
687     }
688 
689     /**
690     * @notice Sets the necessary permissions for a "nonlisted" user. Nonlisted users can trade tokens,
691     * but cannot burn them (and therefore cannot convert them into fiat.)
692     * @param _who The address of the account that we are setting permissions for.
693     */
694     function setNonlistedUser(address _who) public onlyValidator {
695         _setNonlistedUser(_who);
696     }
697 
698     /** Returns whether or not a user is whitelisted.
699      * @param _who The address of the account in question.
700      * @return `true` if the user is whitelisted, `false` otherwise.
701      */
702     function isWhitelistedUser(address _who) public view returns (bool) {
703         return (hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
704     }
705 
706     /** Returns whether or not a user is blacklisted.
707      * @param _who The address of the account in question.
708      * @return `true` if the user is blacklisted, `false` otherwise.
709      */
710     function isBlacklistedUser(address _who) public view returns (bool) {
711         return (!hasUserPermission(_who, BURN_SIG) && hasUserPermission(_who, BLACKLISTED_SIG));
712     }
713 
714     /** Returns whether or not a user is nonlisted.
715      * @param _who The address of the account in question.
716      * @return `true` if the user is nonlisted, `false` otherwise.
717      */
718     function isNonlistedUser(address _who) public view returns (bool) {
719         return (!hasUserPermission(_who, BURN_SIG) && !hasUserPermission(_who, BLACKLISTED_SIG));
720     }
721 
722     /** Returns whether or not a user is a blacklist spender.
723      * @param _who The address of the account in question.
724      * @return `true` if the user is a blacklist spender, `false` otherwise.
725      */
726     function isBlacklistSpender(address _who) public view returns (bool) {
727         return hasUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
728     }
729 
730     /** Returns whether or not a user is a blacklist destroyer.
731      * @param _who The address of the account in question.
732      * @return `true` if the user is a blacklist destroyer, `false` otherwise.
733      */
734     function isBlacklistDestroyer(address _who) public view returns (bool) {
735         return hasUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
736     }
737 
738     /** Returns whether or not a user is a minter.
739      * @param _who The address of the account in question.
740      * @return `true` if the user is a minter, `false` otherwise.
741      */
742     function isMinter(address _who) public view returns (bool) {
743         return hasUserPermission(_who, MINT_SIG);
744     }
745 
746     /** Internal Functions **/
747 
748     function _setMinter(address _who) internal {
749         require(isPermission(MINT_SIG), "Minting not supported by token");
750         setUserPermission(_who, MINT_SIG);
751         emit LogSetMinter(_who);
752     }
753 
754     function _removeMinter(address _who) internal {
755         require(isPermission(MINT_SIG), "Minting not supported by token");
756         removeUserPermission(_who, MINT_SIG);
757         emit LogRemovedMinter(_who);
758     }
759 
760     function _setNonlistedUser(address _who) internal {
761         require(isPermission(BURN_SIG), "Burn method not supported by token");
762         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
763         removeUserPermission(_who, BURN_SIG);
764         removeUserPermission(_who, BLACKLISTED_SIG);
765         emit LogNonlistedUser(_who);
766     }
767 
768     function _setBlacklistedUser(address _who) internal {
769         require(isPermission(BURN_SIG), "Burn method not supported by token");
770         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
771         removeUserPermission(_who, BURN_SIG);
772         setUserPermission(_who, BLACKLISTED_SIG);
773         emit LogBlacklistedUser(_who);
774     }
775 
776     function _setWhitelistedUser(address _who) internal {
777         require(isPermission(BURN_SIG), "Burn method not supported by token");
778         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
779         setUserPermission(_who, BURN_SIG);
780         removeUserPermission(_who, BLACKLISTED_SIG);
781         emit LogWhitelistedUser(_who);
782     }
783 }
784 
785 /**
786 * @title PermissionedToken
787 * @notice A permissioned token that enables transfers, withdrawals, and deposits to occur 
788 * if and only if it is approved by an on-chain Regulator service. PermissionedToken is an
789 * ERC-20 smart contract representing ownership of securities and overrides the
790 * transfer, burn, and mint methods to check with the Regulator.
791 */
792 contract PermissionedToken is ERC20, Pausable, Lockable {
793     using SafeMath for uint256;
794 
795     /** Events */
796     event DestroyedBlacklistedTokens(address indexed account, uint256 amount);
797     event ApprovedBlacklistedAddressSpender(address indexed owner, address indexed spender, uint256 value);
798     event Mint(address indexed to, uint256 value);
799     event Burn(address indexed burner, uint256 value);
800     event Transfer(address indexed from, address indexed to, uint256 value);
801     event Approval(address indexed owner, address indexed spender, uint256 value);
802     event ChangedRegulator(address indexed oldRegulator, address indexed newRegulator );
803 
804     PermissionedTokenStorage public tokenStorage;
805     Regulator public regulator;
806 
807     /**
808     * @dev create a new PermissionedToken with a brand new data storage
809     **/
810     constructor (address _regulator) public {
811         regulator = Regulator(_regulator);
812         tokenStorage = new PermissionedTokenStorage();
813     }
814 
815     /** Modifiers **/
816 
817     /** @notice Modifier that allows function access to be restricted based on
818     * whether the regulator allows the message sender to execute that function.
819     **/
820     modifier requiresPermission() {
821         require (regulator.hasUserPermission(msg.sender, msg.sig), "User does not have permission to execute function");
822         _;
823     }
824 
825     /** @notice Modifier that checks whether or not a transferFrom operation can
826     * succeed with the given _from and _to address. See transferFrom()'s documentation for
827     * more details.
828     **/
829     modifier transferFromConditionsRequired(address _from, address _to) {
830         require(!regulator.isBlacklistedUser(_to), "Recipient cannot be blacklisted");
831         
832         // If the origin user is blacklisted, the transaction can only succeed if 
833         // the message sender is a user that has been approved to transfer 
834         // blacklisted tokens out of this address.
835         bool is_origin_blacklisted = regulator.isBlacklistedUser(_from);
836 
837         // Is the message sender a person with the ability to transfer tokens out of a blacklisted account?
838         bool sender_can_spend_from_blacklisted_address = regulator.isBlacklistSpender(msg.sender);
839         require(!is_origin_blacklisted || sender_can_spend_from_blacklisted_address, "Origin cannot be blacklisted if spender is not an approved blacklist spender");
840         _;
841     }
842 
843     /** @notice Modifier that checks whether a user is whitelisted.
844      * @param _user The address of the user to check.
845     **/
846     modifier userWhitelisted(address _user) {
847         require(regulator.isWhitelistedUser(_user), "User must be whitelisted");
848         _;
849     }
850 
851     /** @notice Modifier that checks whether a user is blacklisted.
852      * @param _user The address of the user to check.
853     **/
854     modifier userBlacklisted(address _user) {
855         require(regulator.isBlacklistedUser(_user), "User must be blacklisted");
856         _;
857     }
858 
859     /** @notice Modifier that checks whether a user is not blacklisted.
860      * @param _user The address of the user to check.
861     **/
862     modifier userNotBlacklisted(address _user) {
863         require(!regulator.isBlacklistedUser(_user), "User must not be blacklisted");
864         _;
865     }
866 
867     /** Functions **/
868 
869     /**
870     * @notice Allows user to mint if they have the appropriate permissions. User generally
871     * has to be some sort of centralized authority.
872     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
873     * @param _to The address of the receiver
874     * @param _amount The number of tokens to mint
875     */
876     function mint(address _to, uint256 _amount) public requiresPermission whenNotPaused {
877         _mint(_to, _amount);
878     }
879 
880     /**
881     * @notice Allows user to mint if they have the appropriate permissions. User generally
882     * is just a "whitelisted" user (i.e. a user registered with the fiat gateway.)
883     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
884     * @param _amount The number of tokens to burn
885     * @return `true` if successful and `false` if unsuccessful
886     */
887     function burn(uint256 _amount) public requiresPermission whenNotPaused {
888         _burn(msg.sender, _amount);
889     }
890 
891     /**
892     * @notice Implements ERC-20 standard approve function. Locked or disabled by default to protect against
893     * double spend attacks. To modify allowances, clients should call safer increase/decreaseApproval methods.
894     * Upon construction, all calls to approve() will revert unless this contract owner explicitly unlocks approve()
895     */
896     function approve(address _spender, uint256 _value) 
897     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused whenUnlocked returns (bool) {
898         tokenStorage.setAllowance(msg.sender, _spender, _value);
899         emit Approval(msg.sender, _spender, _value);
900         return true;
901     }
902 
903     /**
904      * @dev Increase the amount of tokens that an owner allowed to a spender.
905      * @notice increaseApproval should be used instead of approve when the user's allowance
906      * is greater than 0. Using increaseApproval protects against potential double-spend attacks
907      * by moving the check of whether the user has spent their allowance to the time that the transaction 
908      * is mined, removing the user's ability to double-spend
909      * @param _spender The address which will spend the funds.
910      * @param _addedValue The amount of tokens to increase the allowance by.
911      */
912     function increaseApproval(address _spender, uint256 _addedValue) 
913     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
914         _increaseApproval(_spender, _addedValue, msg.sender);
915         return true;
916     }
917 
918     /**
919      * @dev Decrease the amount of tokens that an owner allowed to a spender.
920      * @notice decreaseApproval should be used instead of approve when the user's allowance
921      * is greater than 0. Using decreaseApproval protects against potential double-spend attacks
922      * by moving the check of whether the user has spent their allowance to the time that the transaction 
923      * is mined, removing the user's ability to double-spend
924      * @param _spender The address which will spend the funds.
925      * @param _subtractedValue The amount of tokens to decrease the allowance by.
926      */
927     function decreaseApproval(address _spender, uint256 _subtractedValue) 
928     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
929         _decreaseApproval(_spender, _subtractedValue, msg.sender);
930         return true;
931     }
932 
933     /**
934     * @notice Destroy the tokens owned by a blacklisted account. This function can generally
935     * only be called by a central authority.
936     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
937     * @param _who Account to destroy tokens from. Must be a blacklisted account.
938     */
939     function destroyBlacklistedTokens(address _who, uint256 _amount) public userBlacklisted(_who) whenNotPaused requiresPermission {
940         tokenStorage.subBalance(_who, _amount);
941         tokenStorage.subTotalSupply(_amount);
942         emit DestroyedBlacklistedTokens(_who, _amount);
943     }
944     /**
945     * @notice Allows a central authority to approve themselves as a spender on a blacklisted account.
946     * By default, the allowance is set to the balance of the blacklisted account, so that the
947     * authority has full control over the account balance.
948     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
949     * @param _blacklistedAccount The blacklisted account.
950     */
951     function approveBlacklistedAddressSpender(address _blacklistedAccount) 
952     public userBlacklisted(_blacklistedAccount) whenNotPaused requiresPermission {
953         tokenStorage.setAllowance(_blacklistedAccount, msg.sender, balanceOf(_blacklistedAccount));
954         emit ApprovedBlacklistedAddressSpender(_blacklistedAccount, msg.sender, balanceOf(_blacklistedAccount));
955     }
956 
957     /**
958     * @notice Initiates a "send" operation towards another user. See `transferFrom` for details.
959     * @param _to The address of the receiver. This user must not be blacklisted, or else the tranfer
960     * will fail.
961     * @param _amount The number of tokens to transfer
962     *
963     * @return `true` if successful 
964     */
965     function transfer(address _to, uint256 _amount) public userNotBlacklisted(_to) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
966         require(_to != address(0),"to address cannot be 0x0");
967         require(_amount <= balanceOf(msg.sender),"not enough balance to transfer");
968 
969         tokenStorage.subBalance(msg.sender, _amount);
970         tokenStorage.addBalance(_to, _amount);
971         emit Transfer(msg.sender, _to, _amount);
972         return true;
973     }
974 
975     /**
976     * @notice Initiates a transfer operation between address `_from` and `_to`. Requires that the
977     * message sender is an approved spender on the _from account.
978     * @dev When implemented, it should use the transferFromConditionsRequired() modifier.
979     * @param _to The address of the recipient. This address must not be blacklisted.
980     * @param _from The address of the origin of funds. This address _could_ be blacklisted, because
981     * a regulator may want to transfer tokens out of a blacklisted account, for example.
982     * In order to do so, the regulator would have to add themselves as an approved spender
983     * on the account via `addBlacklistAddressSpender()`, and would then be able to transfer tokens out of it.
984     * @param _amount The number of tokens to transfer
985     * @return `true` if successful 
986     */
987     function transferFrom(address _from, address _to, uint256 _amount) 
988     public whenNotPaused transferFromConditionsRequired(_from, _to) returns (bool) {
989         require(_amount <= allowance(_from, msg.sender),"not enough allowance to transfer");
990         require(_to != address(0),"to address cannot be 0x0");
991         require(_amount <= balanceOf(_from),"not enough balance to transfer");
992         
993         tokenStorage.subAllowance(_from, msg.sender, _amount);
994         tokenStorage.addBalance(_to, _amount);
995         tokenStorage.subBalance(_from, _amount);
996         emit Transfer(_from, _to, _amount);
997         return true;
998     }
999 
1000     /**
1001     *
1002     * @dev Only the token owner can change its regulator
1003     * @param _newRegulator the new Regulator for this token
1004     *
1005     */
1006     function setRegulator(address _newRegulator) public onlyOwner {
1007         require(_newRegulator != address(regulator), "Must be a new regulator");
1008         require(AddressUtils.isContract(_newRegulator), "Cannot set a regulator storage to a non-contract address");
1009         address old = address(regulator);
1010         regulator = Regulator(_newRegulator);
1011         emit ChangedRegulator(old, _newRegulator);
1012     }
1013 
1014     /**
1015     * @notice If a user is blacklisted, they will have the permission to 
1016     * execute this dummy function. This function effectively acts as a marker 
1017     * to indicate that a user is blacklisted. We include this function to be consistent with our
1018     * invariant that every possible userPermission (listed in Regulator) enables access to a single 
1019     * PermissionedToken function. Thus, the 'BLACKLISTED' permission gives access to this function
1020     * @return `true` if successful
1021     */
1022     function blacklisted() public view requiresPermission returns (bool) {
1023         return true;
1024     }
1025 
1026     /**
1027     * ERC20 standard functions
1028     */
1029     function allowance(address owner, address spender) public view returns (uint256) {
1030         return tokenStorage.allowances(owner, spender);
1031     }
1032 
1033     function totalSupply() public view returns (uint256) {
1034         return tokenStorage.totalSupply();
1035     }
1036 
1037     function balanceOf(address _addr) public view returns (uint256) {
1038         return tokenStorage.balances(_addr);
1039     }
1040 
1041 
1042     /** Internal functions **/
1043     
1044     function _decreaseApproval(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
1045         uint256 oldValue = allowance(_tokenHolder, _spender);
1046         if (_subtractedValue > oldValue) {
1047             tokenStorage.setAllowance(_tokenHolder, _spender, 0);
1048         } else {
1049             tokenStorage.subAllowance(_tokenHolder, _spender, _subtractedValue);
1050         }
1051         emit Approval(_tokenHolder, _spender, allowance(_tokenHolder, _spender));
1052     }
1053 
1054     function _increaseApproval(address _spender, uint256 _addedValue, address _tokenHolder) internal {
1055         tokenStorage.addAllowance(_tokenHolder, _spender, _addedValue);
1056         emit Approval(_tokenHolder, _spender, allowance(_tokenHolder, _spender));
1057     }
1058 
1059     function _burn(address _tokensOf, uint256 _amount) internal {
1060         require(_amount <= balanceOf(_tokensOf),"not enough balance to burn");
1061         // no need to require value <= totalSupply, since that would imply the
1062         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1063         tokenStorage.subBalance(_tokensOf, _amount);
1064         tokenStorage.subTotalSupply(_amount);
1065         emit Burn(_tokensOf, _amount);
1066         emit Transfer(_tokensOf, address(0), _amount);
1067     }
1068 
1069     function _mint(address _to, uint256 _amount) internal userWhitelisted(_to) {
1070         tokenStorage.addTotalSupply(_amount);
1071         tokenStorage.addBalance(_to, _amount);
1072         emit Mint(_to, _amount);
1073         emit Transfer(address(0), _to, _amount);
1074     }
1075 
1076 }
1077 
1078 /**
1079  * @title CarbonDollarRegulator
1080  * @dev CarbonDollarRegulator is a type of Regulator that modifies its definitions of
1081  * what constitutes a "whitelisted/nonlisted/blacklisted" user. A CarbonDollar
1082  * provides a user the additional ability to convert from CUSD into a whtielisted stablecoin
1083  *
1084  */
1085 contract CarbonDollarRegulator is Regulator {
1086 
1087     // Getters
1088     function isWhitelistedUser(address _who) public view returns(bool) {
1089         return (hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
1090         && hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
1091         && !hasUserPermission(_who, BLACKLISTED_SIG));
1092     }
1093 
1094     function isBlacklistedUser(address _who) public view returns(bool) {
1095         return (!hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
1096         && !hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
1097         && hasUserPermission(_who, BLACKLISTED_SIG));
1098     }
1099 
1100     function isNonlistedUser(address _who) public view returns(bool) {
1101         return (!hasUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG) 
1102         && !hasUserPermission(_who, BURN_CARBON_DOLLAR_SIG) 
1103         && !hasUserPermission(_who, BLACKLISTED_SIG));
1104     }
1105 
1106     /** Internal functions **/
1107     
1108     // Setters: CarbonDollarRegulator overrides the definitions of whitelisted, nonlisted, and blacklisted setUserPermission
1109 
1110     // CarbonDollar whitelisted users burn CUSD into a WhitelistedToken. Unlike PermissionedToken 
1111     // whitelisted users, CarbonDollar whitelisted users cannot burn ordinary CUSD without converting into WT
1112     function _setWhitelistedUser(address _who) internal {
1113         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
1114         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
1115         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
1116         setUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
1117         setUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
1118         removeUserPermission(_who, BLACKLISTED_SIG);
1119         emit LogWhitelistedUser(_who);
1120     }
1121 
1122     function _setBlacklistedUser(address _who) internal {
1123         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
1124         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
1125         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
1126         removeUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
1127         removeUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
1128         setUserPermission(_who, BLACKLISTED_SIG);
1129         emit LogBlacklistedUser(_who);
1130     }
1131 
1132     function _setNonlistedUser(address _who) internal {
1133         require(isPermission(CONVERT_CARBON_DOLLAR_SIG), "Converting CUSD not supported");
1134         require(isPermission(BURN_CARBON_DOLLAR_SIG), "Burning CUSD not supported");
1135         require(isPermission(BLACKLISTED_SIG), "Blacklisting not supported");
1136         removeUserPermission(_who, CONVERT_CARBON_DOLLAR_SIG);
1137         removeUserPermission(_who, BURN_CARBON_DOLLAR_SIG);
1138         removeUserPermission(_who, BLACKLISTED_SIG);
1139         emit LogNonlistedUser(_who);
1140     }
1141 }
1142 
1143 /**
1144 * @title CarbonDollar
1145 * @notice The main functionality for the CarbonUSD metatoken. (CarbonUSD is just a proxy
1146 * that implements this contract's functionality.) This is a permissioned token, so users have to be 
1147 * whitelisted before they can do any mint/burn/convert operation. Every CarbonDollar token is backed by one
1148 * whitelisted stablecoin credited to the balance of this contract address.
1149 */
1150 contract CarbonDollar is PermissionedToken {
1151     
1152     // Events
1153 
1154     event ConvertedToWT(address indexed user, uint256 amount);
1155     event BurnedCUSD(address indexed user, uint256 feedAmount, uint256 chargedFee);
1156     
1157     /**
1158         Modifiers
1159     */
1160     modifier requiresWhitelistedToken() {
1161         require(isWhitelisted(msg.sender), "Sender must be a whitelisted token contract");
1162         _;
1163     }
1164 
1165     CarbonDollarStorage public tokenStorage_CD;
1166 
1167     /** CONSTRUCTOR
1168     * @dev Passes along arguments to base class.
1169     */
1170     constructor(address _regulator) public PermissionedToken(_regulator) {
1171 
1172         // base class override
1173         regulator = CarbonDollarRegulator(_regulator);
1174 
1175         tokenStorage_CD = new CarbonDollarStorage();
1176     }
1177 
1178     /**
1179      * @notice Add new stablecoin to whitelist.
1180      * @param _stablecoin Address of stablecoin contract.
1181      */
1182     function listToken(address _stablecoin) public onlyOwner whenNotPaused {
1183         tokenStorage_CD.addStablecoin(_stablecoin); 
1184     }
1185 
1186     /**
1187      * @notice Remove existing stablecoin from whitelist.
1188      * @param _stablecoin Address of stablecoin contract.
1189      */
1190     function unlistToken(address _stablecoin) public onlyOwner whenNotPaused {
1191         tokenStorage_CD.removeStablecoin(_stablecoin);
1192     }
1193 
1194     /**
1195      * @notice Change fees associated with going from CarbonUSD to a particular stablecoin.
1196      * @param stablecoin Address of the stablecoin contract.
1197      * @param _newFee The new fee rate to set, in tenths of a percent. 
1198      */
1199     function setFee(address stablecoin, uint256 _newFee) public onlyOwner whenNotPaused {
1200         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1201         tokenStorage_CD.setFee(stablecoin, _newFee);
1202     }
1203 
1204     /**
1205      * @notice Remove fees associated with going from CarbonUSD to a particular stablecoin.
1206      * The default fee still may apply.
1207      * @param stablecoin Address of the stablecoin contract.
1208      */
1209     function removeFee(address stablecoin) public onlyOwner whenNotPaused {
1210         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1211        tokenStorage_CD.removeFee(stablecoin);
1212     }
1213 
1214     /**
1215      * @notice Change the default fee associated with going from CarbonUSD to a WhitelistedToken.
1216      * This fee amount is used if the fee for a WhitelistedToken is not specified.
1217      * @param _newFee The new fee rate to set, in tenths of a percent.
1218      */
1219     function setDefaultFee(uint256 _newFee) public onlyOwner whenNotPaused {
1220         tokenStorage_CD.setDefaultFee(_newFee);
1221     }
1222 
1223     /**
1224      * @notice Mints CUSD on behalf of a user. Note the use of the "requiresWhitelistedToken"
1225      * modifier; this means that minting authority does not belong to any personal account; 
1226      * only whitelisted token contracts can call this function. The intended functionality is that the only
1227      * way to mint CUSD is for the user to actually burn a whitelisted token to convert into CUSD
1228      * @param _to User to send CUSD to
1229      * @param _amount Amount of CarbonUSD to mint.
1230      */
1231     function mint(address _to, uint256 _amount) public requiresWhitelistedToken whenNotPaused {
1232         _mint(_to, _amount);
1233     }
1234 
1235     /**
1236      * @notice user can convert CarbonUSD umbrella token into a whitelisted stablecoin. 
1237      * @param stablecoin represents the type of coin the users wishes to receive for burning carbonUSD
1238      * @param _amount Amount of CarbonUSD to convert.
1239      * we credit the user's account at the sender address with the _amount minus the percentage fee we want to charge.
1240      */
1241     function convertCarbonDollar(address stablecoin, uint256 _amount) public requiresPermission whenNotPaused  {
1242         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1243         WhitelistedToken whitelisted = WhitelistedToken(stablecoin);
1244         require(whitelisted.balanceOf(address(this)) >= _amount, "Carbon escrow account in WT0 doesn't have enough tokens for burning");
1245  
1246         // Send back WT0 to calling user, but with a fee reduction.
1247         // Transfer this fee into the whitelisted token's CarbonDollar account (this contract's address)
1248         uint256 chargedFee = tokenStorage_CD.computeFee(_amount, computeFeeRate(stablecoin));
1249         uint256 feedAmount = _amount.sub(chargedFee);
1250         _burn(msg.sender, _amount);
1251         require(whitelisted.transfer(msg.sender, feedAmount));
1252         whitelisted.burn(chargedFee);
1253         _mint(address(this), chargedFee);
1254         emit ConvertedToWT(msg.sender, _amount);
1255     }
1256 
1257      /**
1258      * @notice burns CarbonDollar and an equal amount of whitelisted stablecoin from the CarbonDollar address
1259      * @param stablecoin Represents the stablecoin whose fee will be charged.
1260      * @param _amount Amount of CarbonUSD to burn.
1261      */
1262     function burnCarbonDollar(address stablecoin, uint256 _amount) public requiresPermission whenNotPaused {
1263         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1264         WhitelistedToken whitelisted = WhitelistedToken(stablecoin);
1265         require(whitelisted.balanceOf(address(this)) >= _amount, "Carbon escrow account in WT0 doesn't have enough tokens for burning");
1266  
1267         // Burn user's CUSD, but with a fee reduction.
1268         uint256 chargedFee = tokenStorage_CD.computeFee(_amount, computeFeeRate(stablecoin));
1269         uint256 feedAmount = _amount.sub(chargedFee);
1270         _burn(msg.sender, _amount);
1271         whitelisted.burn(_amount);
1272         _mint(address(this), chargedFee);
1273         emit BurnedCUSD(msg.sender, feedAmount, chargedFee); // Whitelisted trust account should send user feedAmount USD
1274     }
1275 
1276     /** 
1277     * @notice release collected CUSD fees to owner 
1278     * @param _amount Amount of CUSD to release
1279     * @return `true` if successful 
1280     */
1281     function releaseCarbonDollar(uint256 _amount) public onlyOwner returns (bool) {
1282         require(_amount <= balanceOf(address(this)),"not enough balance to transfer");
1283 
1284         tokenStorage.subBalance(address(this), _amount);
1285         tokenStorage.addBalance(msg.sender, _amount);
1286         emit Transfer(address(this), msg.sender, _amount);
1287         return true;
1288     }
1289 
1290     /** Computes fee percentage associated with burning into a particular stablecoin.
1291      * @param stablecoin The stablecoin whose fee will be charged. Precondition: is a whitelisted
1292      * stablecoin.
1293      * @return The fee that will be charged. If the stablecoin's fee is not set, the default
1294      * fee is returned.
1295      */
1296     function computeFeeRate(address stablecoin) public view returns (uint256 feeRate) {
1297         if (getFee(stablecoin) > 0) 
1298             feeRate = getFee(stablecoin);
1299         else
1300             feeRate = getDefaultFee();
1301     }
1302 
1303     /**
1304     * @notice Check if whitelisted token is whitelisted
1305     * @return bool true if whitelisted, false if not
1306     **/
1307     function isWhitelisted(address _stablecoin) public view returns (bool) {
1308         return tokenStorage_CD.whitelist(_stablecoin);
1309     }
1310 
1311     /**
1312      * @notice Get the fee associated with going from CarbonUSD to a specific WhitelistedToken.
1313      * @param stablecoin The stablecoin whose fee is being checked.
1314      * @return The fee associated with the stablecoin.
1315      */
1316     function getFee(address stablecoin) public view returns (uint256) {
1317         return tokenStorage_CD.fees(stablecoin);
1318     }
1319 
1320     /**
1321      * @notice Get the default fee associated with going from CarbonUSD to a specific WhitelistedToken.
1322      * @return The default fee for stablecoin trades.
1323      */
1324     function getDefaultFee() public view returns (uint256) {
1325         return tokenStorage_CD.defaultFee();
1326     }
1327 
1328     function _mint(address _to, uint256 _amount) internal {
1329         super._mint(_to, _amount);
1330     }
1331 
1332 }
1333 
1334 /**
1335  * @title WhitelistedTokenRegulator
1336  * @dev WhitelistedTokenRegulator is a type of Regulator that modifies its definitions of
1337  * what constitutes a "whitelisted/nonlisted/blacklisted" user. A WhitelistedToken
1338  * provides a user the additional ability to convert from a whtielisted stablecoin into the
1339  * meta-token CUSD, or mint CUSD directly through a specific WT.
1340  *
1341  */
1342 contract WhitelistedTokenRegulator is Regulator {
1343 
1344     function isMinter(address _who) public view returns (bool) {
1345         return (super.isMinter(_who) && hasUserPermission(_who, MINT_CUSD_SIG));
1346     }
1347 
1348     // Getters
1349 
1350     function isWhitelistedUser(address _who) public view returns (bool) {
1351         return (hasUserPermission(_who, CONVERT_WT_SIG) && super.isWhitelistedUser(_who));
1352     }
1353 
1354     function isBlacklistedUser(address _who) public view returns (bool) {
1355         return (!hasUserPermission(_who, CONVERT_WT_SIG) && super.isBlacklistedUser(_who));
1356     }
1357 
1358     function isNonlistedUser(address _who) public view returns (bool) {
1359         return (!hasUserPermission(_who, CONVERT_WT_SIG) && super.isNonlistedUser(_who));
1360     }   
1361 
1362     /** Internal functions **/
1363 
1364     // A WT minter should have option to either mint directly into CUSD via mintCUSD(), or
1365     // mint the WT via an ordinary mint() 
1366     function _setMinter(address _who) internal {
1367         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
1368         setUserPermission(_who, MINT_CUSD_SIG);
1369         super._setMinter(_who);
1370     }
1371 
1372     function _removeMinter(address _who) internal {
1373         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
1374         removeUserPermission(_who, MINT_CUSD_SIG);
1375         super._removeMinter(_who);
1376     }
1377 
1378     // Setters
1379 
1380     // A WT whitelisted user should gain ability to convert their WT into CUSD. They can also burn their WT, as a
1381     // PermissionedToken whitelisted user can do
1382     function _setWhitelistedUser(address _who) internal {
1383         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
1384         setUserPermission(_who, CONVERT_WT_SIG);
1385         super._setWhitelistedUser(_who);
1386     }
1387 
1388     function _setBlacklistedUser(address _who) internal {
1389         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
1390         removeUserPermission(_who, CONVERT_WT_SIG);
1391         super._setBlacklistedUser(_who);
1392     }
1393 
1394     function _setNonlistedUser(address _who) internal {
1395         require(isPermission(CONVERT_WT_SIG), "Converting to CUSD not supported by token");
1396         removeUserPermission(_who, CONVERT_WT_SIG);
1397         super._setNonlistedUser(_who);
1398     }
1399 
1400 }
1401 
1402 /**
1403 * @title WhitelistedToken
1404 * @notice A WhitelistedToken can be converted into CUSD and vice versa. Converting a WT into a CUSD
1405 * is the only way for a user to obtain CUSD. This is a permissioned token, so users have to be 
1406 * whitelisted before they can do any mint/burn/convert operation.
1407 */
1408 contract WhitelistedToken is PermissionedToken {
1409 
1410 
1411     address public cusdAddress;
1412 
1413     /**
1414         Events
1415      */
1416     event CUSDAddressChanged(address indexed oldCUSD, address indexed newCUSD);
1417     event MintedToCUSD(address indexed user, uint256 amount);
1418     event ConvertedToCUSD(address indexed user, uint256 amount);
1419 
1420     /**
1421     * @notice Constructor sets the regulator contract and the address of the
1422     * CarbonUSD meta-token contract. The latter is necessary in order to make transactions
1423     * with the CarbonDollar smart contract.
1424     */
1425     constructor(address _regulator, address _cusd) public PermissionedToken(_regulator) {
1426 
1427         // base class fields
1428         regulator = WhitelistedTokenRegulator(_regulator);
1429 
1430         cusdAddress = _cusd;
1431 
1432     }
1433 
1434     /**
1435     * @notice Mints CarbonUSD for the user. Stores the WT0 that backs the CarbonUSD
1436     * into the CarbonUSD contract's escrow account.
1437     * @param _to The address of the receiver
1438     * @param _amount The number of CarbonTokens to mint to user
1439     */
1440     function mintCUSD(address _to, uint256 _amount) public requiresPermission whenNotPaused userWhitelisted(_to) {
1441         return _mintCUSD(_to, _amount);
1442     }
1443 
1444     /**
1445     * @notice Converts WT0 to CarbonUSD for the user. Stores the WT0 that backs the CarbonUSD
1446     * into the CarbonUSD contract's escrow account.
1447     * @param _amount The number of Whitelisted tokens to convert
1448     */
1449     function convertWT(uint256 _amount) public requiresPermission whenNotPaused {
1450         require(balanceOf(msg.sender) >= _amount, "Conversion amount should be less than balance");
1451         _burn(msg.sender, _amount);
1452         _mintCUSD(msg.sender, _amount);
1453         emit ConvertedToCUSD(msg.sender, _amount);
1454     }
1455 
1456     /**
1457      * @notice Change the cusd address.
1458      * @param _cusd the cusd address.
1459      */
1460     function setCUSDAddress(address _cusd) public onlyOwner {
1461         require(_cusd != address(cusdAddress), "Must be a new cusd address");
1462         require(AddressUtils.isContract(_cusd), "Must be an actual contract");
1463         address oldCUSD = address(cusdAddress);
1464         cusdAddress = _cusd;
1465         emit CUSDAddressChanged(oldCUSD, _cusd);
1466     }
1467 
1468     function _mintCUSD(address _to, uint256 _amount) internal {
1469         require(_to != cusdAddress, "Cannot mint to CarbonUSD contract"); // This is to prevent Carbon Labs from printing money out of thin air!
1470         CarbonDollar(cusdAddress).mint(_to, _amount);
1471         _mint(cusdAddress, _amount);
1472         emit MintedToCUSD(_to, _amount);
1473     }
1474 }
1475 
1476 /**
1477 * @title CarbonDollar
1478 * @notice The main functionality for the CarbonUSD metatoken. (CarbonUSD is just a proxy
1479 * that implements this contract's functionality.) This is a permissioned token, so users have to be 
1480 * whitelisted before they can do any mint/burn/convert operation. Every CarbonDollar token is backed by one
1481 * whitelisted stablecoin credited to the balance of this contract address.
1482 */
1483 // contract CarbonDollar is PermissionedToken {
1484     
1485 //     // Events
1486 
1487 //     event ConvertedToWT(address indexed user, uint256 amount);
1488 //     event BurnedCUSD(address indexed user, uint256 feedAmount, uint256 chargedFee);
1489     
1490 //     /**
1491 //         Modifiers
1492 //     */
1493 //     modifier requiresWhitelistedToken() {
1494 //         require(isWhitelisted(msg.sender), "Sender must be a whitelisted token contract");
1495 //         _;
1496 //     }
1497 
1498 //     CarbonDollarStorage public tokenStorage_CD;
1499 
1500 //     /** CONSTRUCTOR
1501 //     * @dev Passes along arguments to base class.
1502 //     */
1503 //     constructor(address _regulator) public PermissionedToken(_regulator) {
1504 
1505 //         // base class override
1506 //         regulator = CarbonDollarRegulator(_regulator);
1507 
1508 //         tokenStorage_CD = new CarbonDollarStorage();
1509 //     }
1510 
1511 //     /**
1512 //      * @notice Add new stablecoin to whitelist.
1513 //      * @param _stablecoin Address of stablecoin contract.
1514 //      */
1515 //     function listToken(address _stablecoin) public onlyOwner whenNotPaused {
1516 //         tokenStorage_CD.addStablecoin(_stablecoin); 
1517 //     }
1518 
1519 //     /**
1520 //      * @notice Remove existing stablecoin from whitelist.
1521 //      * @param _stablecoin Address of stablecoin contract.
1522 //      */
1523 //     function unlistToken(address _stablecoin) public onlyOwner whenNotPaused {
1524 //         tokenStorage_CD.removeStablecoin(_stablecoin);
1525 //     }
1526 
1527 //     /**
1528 //      * @notice Change fees associated with going from CarbonUSD to a particular stablecoin.
1529 //      * @param stablecoin Address of the stablecoin contract.
1530 //      * @param _newFee The new fee rate to set, in tenths of a percent. 
1531 //      */
1532 //     function setFee(address stablecoin, uint256 _newFee) public onlyOwner whenNotPaused {
1533 //         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1534 //         tokenStorage_CD.setFee(stablecoin, _newFee);
1535 //     }
1536 
1537 //     /**
1538 //      * @notice Remove fees associated with going from CarbonUSD to a particular stablecoin.
1539 //      * The default fee still may apply.
1540 //      * @param stablecoin Address of the stablecoin contract.
1541 //      */
1542 //     function removeFee(address stablecoin) public onlyOwner whenNotPaused {
1543 //         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1544 //        tokenStorage_CD.removeFee(stablecoin);
1545 //     }
1546 
1547 //     /**
1548 //      * @notice Change the default fee associated with going from CarbonUSD to a WhitelistedToken.
1549 //      * This fee amount is used if the fee for a WhitelistedToken is not specified.
1550 //      * @param _newFee The new fee rate to set, in tenths of a percent.
1551 //      */
1552 //     function setDefaultFee(uint256 _newFee) public onlyOwner whenNotPaused {
1553 //         tokenStorage_CD.setDefaultFee(_newFee);
1554 //     }
1555 
1556 //     /**
1557 //      * @notice Mints CUSD on behalf of a user. Note the use of the "requiresWhitelistedToken"
1558 //      * modifier; this means that minting authority does not belong to any personal account; 
1559 //      * only whitelisted token contracts can call this function. The intended functionality is that the only
1560 //      * way to mint CUSD is for the user to actually burn a whitelisted token to convert into CUSD
1561 //      * @param _to User to send CUSD to
1562 //      * @param _amount Amount of CarbonUSD to mint.
1563 //      */
1564 //     function mint(address _to, uint256 _amount) public requiresWhitelistedToken whenNotPaused {
1565 //         _mint(_to, _amount);
1566 //     }
1567 
1568 //     /**
1569 //      * @notice user can convert CarbonUSD umbrella token into a whitelisted stablecoin. 
1570 //      * @param stablecoin represents the type of coin the users wishes to receive for burning carbonUSD
1571 //      * @param _amount Amount of CarbonUSD to convert.
1572 //      * we credit the user's account at the sender address with the _amount minus the percentage fee we want to charge.
1573 //      */
1574 //     function convertCarbonDollar(address stablecoin, uint256 _amount) public requiresPermission whenNotPaused  {
1575 //         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1576 //         WhitelistedToken whitelisted = WhitelistedToken(stablecoin);
1577 //         require(whitelisted.balanceOf(address(this)) >= _amount, "Carbon escrow account in WT0 doesn't have enough tokens for burning");
1578  
1579 //         // Send back WT0 to calling user, but with a fee reduction.
1580 //         // Transfer this fee into the whitelisted token's CarbonDollar account (this contract's address)
1581 //         uint256 chargedFee = tokenStorage_CD.computeFee(_amount, computeFeeRate(stablecoin));
1582 //         uint256 feedAmount = _amount.sub(chargedFee);
1583 //         _burn(msg.sender, _amount);
1584 //         require(whitelisted.transfer(msg.sender, feedAmount));
1585 //         whitelisted.burn(chargedFee);
1586 //         _mint(address(this), chargedFee);
1587 //         emit ConvertedToWT(msg.sender, _amount);
1588 //     }
1589 
1590 //      /**
1591 //      * @notice burns CarbonDollar and an equal amount of whitelisted stablecoin from the CarbonDollar address
1592 //      * @param stablecoin Represents the stablecoin whose fee will be charged.
1593 //      * @param _amount Amount of CarbonUSD to burn.
1594 //      */
1595 //     function burnCarbonDollar(address stablecoin, uint256 _amount) public requiresPermission whenNotPaused {
1596 //         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1597 //         WhitelistedToken whitelisted = WhitelistedToken(stablecoin);
1598 //         require(whitelisted.balanceOf(address(this)) >= _amount, "Carbon escrow account in WT0 doesn't have enough tokens for burning");
1599  
1600 //         // Burn user's CUSD, but with a fee reduction.
1601 //         uint256 chargedFee = tokenStorage_CD.computeFee(_amount, computeFeeRate(stablecoin));
1602 //         uint256 feedAmount = _amount.sub(chargedFee);
1603 //         _burn(msg.sender, _amount);
1604 //         whitelisted.burn(_amount);
1605 //         _mint(address(this), chargedFee);
1606 //         emit BurnedCUSD(msg.sender, feedAmount, chargedFee); // Whitelisted trust account should send user feedAmount USD
1607 //     }
1608 
1609 //     /** 
1610 //     * @notice release collected CUSD fees to owner 
1611 //     * @param _amount Amount of CUSD to release
1612 //     * @return `true` if successful 
1613 //     */
1614 //     function releaseCarbonDollar(uint256 _amount) public onlyOwner returns (bool) {
1615 //         require(_amount <= balanceOf(address(this)),"not enough balance to transfer");
1616 
1617 //         tokenStorage.subBalance(address(this), _amount);
1618 //         tokenStorage.addBalance(msg.sender, _amount);
1619 //         emit Transfer(address(this), msg.sender, _amount);
1620 //         return true;
1621 //     }
1622 
1623 //     /** Computes fee percentage associated with burning into a particular stablecoin.
1624 //      * @param stablecoin The stablecoin whose fee will be charged. Precondition: is a whitelisted
1625 //      * stablecoin.
1626 //      * @return The fee that will be charged. If the stablecoin's fee is not set, the default
1627 //      * fee is returned.
1628 //      */
1629 //     function computeFeeRate(address stablecoin) public view returns (uint256 feeRate) {
1630 //         if (getFee(stablecoin) > 0) 
1631 //             feeRate = getFee(stablecoin);
1632 //         else
1633 //             feeRate = getDefaultFee();
1634 //     }
1635 
1636 //     /**
1637 //     * @notice Check if whitelisted token is whitelisted
1638 //     * @return bool true if whitelisted, false if not
1639 //     **/
1640 //     function isWhitelisted(address _stablecoin) public view returns (bool) {
1641 //         return tokenStorage_CD.whitelist(_stablecoin);
1642 //     }
1643 
1644 //     /**
1645 //      * @notice Get the fee associated with going from CarbonUSD to a specific WhitelistedToken.
1646 //      * @param stablecoin The stablecoin whose fee is being checked.
1647 //      * @return The fee associated with the stablecoin.
1648 //      */
1649 //     function getFee(address stablecoin) public view returns (uint256) {
1650 //         return tokenStorage_CD.fees(stablecoin);
1651 //     }
1652 
1653 //     /**
1654 //      * @notice Get the default fee associated with going from CarbonUSD to a specific WhitelistedToken.
1655 //      * @return The default fee for stablecoin trades.
1656 //      */
1657 //     function getDefaultFee() public view returns (uint256) {
1658 //         return tokenStorage_CD.defaultFee();
1659 //     }
1660 
1661 //     function _mint(address _to, uint256 _amount) internal {
1662 //         super._mint(_to, _amount);
1663 //     }
1664 
1665 // }