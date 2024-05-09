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
440     bytes4 public constant DESTROY_BLACKLISTED_TOKENS_SIG = bytes4(keccak256("destroyBlacklistedTokens(address,uint256)"));
441     bytes4 public constant APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG = bytes4(keccak256("approveBlacklistedAddressSpender(address)"));
442     bytes4 public constant BLACKLISTED_SIG = bytes4(keccak256("blacklisted()"));
443 
444     /** 
445         Mappings 
446     */
447 
448     /* each method signature maps to a Permission */
449     mapping (bytes4 => Permission) public permissions;
450     /* list of validators, either active or inactive */
451     mapping (address => bool) public validators;
452     /* each user can be given access to a given method signature */
453     mapping (address => mapping (bytes4 => bool)) public userPermissions;
454 
455     /** 
456         Events 
457     */
458     event PermissionAdded(bytes4 methodsignature);
459     event PermissionRemoved(bytes4 methodsignature);
460     event ValidatorAdded(address indexed validator);
461     event ValidatorRemoved(address indexed validator);
462 
463     /** 
464         Modifiers 
465     */
466     /**
467     * @notice Throws if called by any account that does not have access to set attributes
468     */
469     modifier onlyValidator() {
470         require (isValidator(msg.sender), "Sender must be validator");
471         _;
472     }
473 
474     /**
475     * @notice Sets a permission within the list of permissions.
476     * @param _methodsignature Signature of the method that this permission controls.
477     * @param _permissionName A "slug" name for this permission (e.g. "canMint").
478     * @param _permissionDescription A lengthier description for this permission (e.g. "Allows user to mint tokens").
479     * @param _contractName Name of the contract that the method belongs to.
480     */
481     function addPermission(
482         bytes4 _methodsignature, 
483         string _permissionName, 
484         string _permissionDescription, 
485         string _contractName) public onlyValidator { 
486         Permission memory p = Permission(_permissionName, _permissionDescription, _contractName, true);
487         permissions[_methodsignature] = p;
488         emit PermissionAdded(_methodsignature);
489     }
490 
491     /**
492     * @notice Removes a permission the list of permissions.
493     * @param _methodsignature Signature of the method that this permission controls.
494     */
495     function removePermission(bytes4 _methodsignature) public onlyValidator {
496         permissions[_methodsignature].active = false;
497         emit PermissionRemoved(_methodsignature);
498     }
499     
500     /**
501     * @notice Sets a permission in the list of permissions that a user has.
502     * @param _methodsignature Signature of the method that this permission controls.
503     */
504     function setUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
505         require(permissions[_methodsignature].active, "Permission being set must be for a valid method signature");
506         userPermissions[_who][_methodsignature] = true;
507     }
508 
509     /**
510     * @notice Removes a permission from the list of permissions that a user has.
511     * @param _methodsignature Signature of the method that this permission controls.
512     */
513     function removeUserPermission(address _who, bytes4 _methodsignature) public onlyValidator {
514         require(permissions[_methodsignature].active, "Permission being removed must be for a valid method signature");
515         userPermissions[_who][_methodsignature] = false;
516     }
517 
518     /**
519     * @notice add a Validator
520     * @param _validator Address of validator to add
521     */
522     function addValidator(address _validator) public onlyOwner {
523         validators[_validator] = true;
524         emit ValidatorAdded(_validator);
525     }
526 
527     /**
528     * @notice remove a Validator
529     * @param _validator Address of validator to remove
530     */
531     function removeValidator(address _validator) public onlyOwner {
532         validators[_validator] = false;
533         emit ValidatorRemoved(_validator);
534     }
535 
536     /**
537     * @notice does validator exist?
538     * @return true if yes, false if no
539     **/
540     function isValidator(address _validator) public view returns (bool) {
541         return validators[_validator];
542     }
543 
544     /**
545     * @notice does permission exist?
546     * @return true if yes, false if no
547     **/
548     function isPermission(bytes4 _methodsignature) public view returns (bool) {
549         return permissions[_methodsignature].active;
550     }
551 
552     /**
553     * @notice get Permission structure
554     * @param _methodsignature request to retrieve the Permission struct for this methodsignature
555     * @return Permission
556     **/
557     function getPermission(bytes4 _methodsignature) public view returns 
558         (string name, 
559          string description, 
560          string contract_name,
561          bool active) {
562         return (permissions[_methodsignature].name,
563                 permissions[_methodsignature].description,
564                 permissions[_methodsignature].contract_name,
565                 permissions[_methodsignature].active);
566     }
567 
568     /**
569     * @notice does permission exist?
570     * @return true if yes, false if no
571     **/
572     function hasUserPermission(address _who, bytes4 _methodsignature) public view returns (bool) {
573         return userPermissions[_who][_methodsignature];
574     }
575 }
576 
577 /**
578  * @title Regulator
579  * @dev Regulator can be configured to meet relevant securities regulations, KYC policies
580  * AML requirements, tax laws, and more. The Regulator ensures that the PermissionedToken
581  * makes compliant transfers possible. Contains the userPermissions necessary
582  * for regulatory compliance.
583  *
584  */
585 contract Regulator is RegulatorStorage {
586     
587     /** 
588         Modifiers 
589     */
590     /**
591     * @notice Throws if called by any account that does not have access to set attributes
592     */
593     modifier onlyValidator() {
594         require (isValidator(msg.sender), "Sender must be validator");
595         _;
596     }
597 
598     /** 
599         Events 
600     */
601     event LogBlacklistedUser(address indexed who);
602     event LogRemovedBlacklistedUser(address indexed who);
603     event LogSetMinter(address indexed who);
604     event LogRemovedMinter(address indexed who);
605     event LogSetBlacklistDestroyer(address indexed who);
606     event LogRemovedBlacklistDestroyer(address indexed who);
607     event LogSetBlacklistSpender(address indexed who);
608     event LogRemovedBlacklistSpender(address indexed who);
609 
610     /**
611     * @notice Sets the necessary permissions for a user to mint tokens.
612     * @param _who The address of the account that we are setting permissions for.
613     */
614     function setMinter(address _who) public onlyValidator {
615         _setMinter(_who);
616     }
617 
618     /**
619     * @notice Removes the necessary permissions for a user to mint tokens.
620     * @param _who The address of the account that we are removing permissions for.
621     */
622     function removeMinter(address _who) public onlyValidator {
623         _removeMinter(_who);
624     }
625 
626     /**
627     * @notice Sets the necessary permissions for a user to spend tokens from a blacklisted account.
628     * @param _who The address of the account that we are setting permissions for.
629     */
630     function setBlacklistSpender(address _who) public onlyValidator {
631         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
632         setUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
633         emit LogSetBlacklistSpender(_who);
634     }
635     
636     /**
637     * @notice Removes the necessary permissions for a user to spend tokens from a blacklisted account.
638     * @param _who The address of the account that we are removing permissions for.
639     */
640     function removeBlacklistSpender(address _who) public onlyValidator {
641         require(isPermission(APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG), "Blacklist spending not supported by token");
642         removeUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
643         emit LogRemovedBlacklistSpender(_who);
644     }
645 
646     /**
647     * @notice Sets the necessary permissions for a user to destroy tokens from a blacklisted account.
648     * @param _who The address of the account that we are setting permissions for.
649     */
650     function setBlacklistDestroyer(address _who) public onlyValidator {
651         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
652         setUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
653         emit LogSetBlacklistDestroyer(_who);
654     }
655     
656 
657     /**
658     * @notice Removes the necessary permissions for a user to destroy tokens from a blacklisted account.
659     * @param _who The address of the account that we are removing permissions for.
660     */
661     function removeBlacklistDestroyer(address _who) public onlyValidator {
662         require(isPermission(DESTROY_BLACKLISTED_TOKENS_SIG), "Blacklist token destruction not supported by token");
663         removeUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
664         emit LogRemovedBlacklistDestroyer(_who);
665     }
666 
667     /**
668     * @notice Sets the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
669     * frozen; they cannot transfer, burn, or withdraw any tokens.
670     * @param _who The address of the account that we are setting permissions for.
671     */
672     function setBlacklistedUser(address _who) public onlyValidator {
673         _setBlacklistedUser(_who);
674     }
675 
676     /**
677     * @notice Removes the necessary permissions for a "blacklisted" user. A blacklisted user has their accounts
678     * frozen; they cannot transfer, burn, or withdraw any tokens.
679     * @param _who The address of the account that we are changing permissions for.
680     */
681     function removeBlacklistedUser(address _who) public onlyValidator {
682         _removeBlacklistedUser(_who);
683     }
684 
685     /** Returns whether or not a user is blacklisted.
686      * @param _who The address of the account in question.
687      * @return `true` if the user is blacklisted, `false` otherwise.
688      */
689     function isBlacklistedUser(address _who) public view returns (bool) {
690         return (hasUserPermission(_who, BLACKLISTED_SIG));
691     }
692 
693 
694     /** Returns whether or not a user is a blacklist spender.
695      * @param _who The address of the account in question.
696      * @return `true` if the user is a blacklist spender, `false` otherwise.
697      */
698     function isBlacklistSpender(address _who) public view returns (bool) {
699         return hasUserPermission(_who, APPROVE_BLACKLISTED_ADDRESS_SPENDER_SIG);
700     }
701 
702     /** Returns whether or not a user is a blacklist destroyer.
703      * @param _who The address of the account in question.
704      * @return `true` if the user is a blacklist destroyer, `false` otherwise.
705      */
706     function isBlacklistDestroyer(address _who) public view returns (bool) {
707         return hasUserPermission(_who, DESTROY_BLACKLISTED_TOKENS_SIG);
708     }
709 
710     /** Returns whether or not a user is a minter.
711      * @param _who The address of the account in question.
712      * @return `true` if the user is a minter, `false` otherwise.
713      */
714     function isMinter(address _who) public view returns (bool) {
715         return (hasUserPermission(_who, MINT_SIG) && hasUserPermission(_who, MINT_CUSD_SIG));
716     }
717 
718     /** Internal Functions **/
719 
720     function _setMinter(address _who) internal {
721         require(isPermission(MINT_SIG), "Minting not supported by token");
722         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
723         setUserPermission(_who, MINT_SIG);
724         setUserPermission(_who, MINT_CUSD_SIG);
725         emit LogSetMinter(_who);
726     }
727 
728     function _removeMinter(address _who) internal {
729         require(isPermission(MINT_SIG), "Minting not supported by token");
730         require(isPermission(MINT_CUSD_SIG), "Minting to CUSD not supported by token");
731         removeUserPermission(_who, MINT_CUSD_SIG);
732         removeUserPermission(_who, MINT_SIG);
733         emit LogRemovedMinter(_who);
734     }
735 
736     function _setBlacklistedUser(address _who) internal {
737         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
738         setUserPermission(_who, BLACKLISTED_SIG);
739         emit LogBlacklistedUser(_who);
740     }
741 
742     function _removeBlacklistedUser(address _who) internal {
743         require(isPermission(BLACKLISTED_SIG), "Self-destruct method not supported by token");
744         removeUserPermission(_who, BLACKLISTED_SIG);
745         emit LogRemovedBlacklistedUser(_who);
746     }
747 }
748 
749 /**
750 * @title PermissionedToken
751 * @notice A permissioned token that enables transfers, withdrawals, and deposits to occur 
752 * if and only if it is approved by an on-chain Regulator service. PermissionedToken is an
753 * ERC-20 smart contract representing ownership of securities and overrides the
754 * transfer, burn, and mint methods to check with the Regulator.
755 */
756 contract PermissionedToken is ERC20, Pausable, Lockable {
757     using SafeMath for uint256;
758 
759     /** Events */
760     event DestroyedBlacklistedTokens(address indexed account, uint256 amount);
761     event ApprovedBlacklistedAddressSpender(address indexed owner, address indexed spender, uint256 value);
762     event Mint(address indexed to, uint256 value);
763     event Burn(address indexed burner, uint256 value);
764     event Transfer(address indexed from, address indexed to, uint256 value);
765     event Approval(address indexed owner, address indexed spender, uint256 value);
766     event ChangedRegulator(address indexed oldRegulator, address indexed newRegulator );
767 
768     PermissionedTokenStorage public tokenStorage;
769     Regulator public regulator;
770 
771     /**
772     * @dev create a new PermissionedToken with a brand new data storage
773     **/
774     constructor (address _regulator) public {
775         regulator = Regulator(_regulator);
776         tokenStorage = new PermissionedTokenStorage();
777     }
778 
779     /** Modifiers **/
780 
781     /** @notice Modifier that allows function access to be restricted based on
782     * whether the regulator allows the message sender to execute that function.
783     **/
784     modifier requiresPermission() {
785         require (regulator.hasUserPermission(msg.sender, msg.sig), "User does not have permission to execute function");
786         _;
787     }
788 
789     /** @notice Modifier that checks whether or not a transferFrom operation can
790     * succeed with the given _from and _to address. See transferFrom()'s documentation for
791     * more details.
792     **/
793     modifier transferFromConditionsRequired(address _from, address _to) {
794         require(!regulator.isBlacklistedUser(_to), "Recipient cannot be blacklisted");
795         
796         // If the origin user is blacklisted, the transaction can only succeed if 
797         // the message sender is a user that has been approved to transfer 
798         // blacklisted tokens out of this address.
799         bool is_origin_blacklisted = regulator.isBlacklistedUser(_from);
800 
801         // Is the message sender a person with the ability to transfer tokens out of a blacklisted account?
802         bool sender_can_spend_from_blacklisted_address = regulator.isBlacklistSpender(msg.sender);
803         require(!is_origin_blacklisted || sender_can_spend_from_blacklisted_address, "Origin cannot be blacklisted if spender is not an approved blacklist spender");
804         _;
805     }
806 
807     /** @notice Modifier that checks whether a user is blacklisted.
808      * @param _user The address of the user to check.
809     **/
810     modifier userBlacklisted(address _user) {
811         require(regulator.isBlacklistedUser(_user), "User must be blacklisted");
812         _;
813     }
814 
815     /** @notice Modifier that checks whether a user is not blacklisted.
816      * @param _user The address of the user to check.
817     **/
818     modifier userNotBlacklisted(address _user) {
819         require(!regulator.isBlacklistedUser(_user), "User must not be blacklisted");
820         _;
821     }
822 
823     /** Functions **/
824 
825     /**
826     * @notice Allows user to mint if they have the appropriate permissions. User generally
827     * must have minting authority.
828     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
829     * @param _to The address of the receiver
830     * @param _amount The number of tokens to mint
831     */
832     function mint(address _to, uint256 _amount) public userNotBlacklisted(_to) requiresPermission whenNotPaused {
833         _mint(_to, _amount);
834     }
835 
836     /**
837     * @notice Remove CUSD from supply
838     * @param _amount The number of tokens to burn
839     * @return `true` if successful and `false` if unsuccessful
840     */
841     function burn(uint256 _amount) userNotBlacklisted(msg.sender) public whenNotPaused {
842         _burn(msg.sender, _amount);
843     }
844 
845     /**
846     * @notice Implements ERC-20 standard approve function. Locked or disabled by default to protect against
847     * double spend attacks. To modify allowances, clients should call safer increase/decreaseApproval methods.
848     * Upon construction, all calls to approve() will revert unless this contract owner explicitly unlocks approve()
849     */
850     function approve(address _spender, uint256 _value) 
851     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused whenUnlocked returns (bool) {
852         tokenStorage.setAllowance(msg.sender, _spender, _value);
853         emit Approval(msg.sender, _spender, _value);
854         return true;
855     }
856 
857     /**
858      * @dev Increase the amount of tokens that an owner allowed to a spender.
859      * @notice increaseApproval should be used instead of approve when the user's allowance
860      * is greater than 0. Using increaseApproval protects against potential double-spend attacks
861      * by moving the check of whether the user has spent their allowance to the time that the transaction 
862      * is mined, removing the user's ability to double-spend
863      * @param _spender The address which will spend the funds.
864      * @param _addedValue The amount of tokens to increase the allowance by.
865      */
866     function increaseApproval(address _spender, uint256 _addedValue) 
867     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
868         _increaseApproval(_spender, _addedValue, msg.sender);
869         return true;
870     }
871 
872     /**
873      * @dev Decrease the amount of tokens that an owner allowed to a spender.
874      * @notice decreaseApproval should be used instead of approve when the user's allowance
875      * is greater than 0. Using decreaseApproval protects against potential double-spend attacks
876      * by moving the check of whether the user has spent their allowance to the time that the transaction 
877      * is mined, removing the user's ability to double-spend
878      * @param _spender The address which will spend the funds.
879      * @param _subtractedValue The amount of tokens to decrease the allowance by.
880      */
881     function decreaseApproval(address _spender, uint256 _subtractedValue) 
882     public userNotBlacklisted(_spender) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
883         _decreaseApproval(_spender, _subtractedValue, msg.sender);
884         return true;
885     }
886 
887     /**
888     * @notice Destroy the tokens owned by a blacklisted account. This function can generally
889     * only be called by a central authority.
890     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
891     * @param _who Account to destroy tokens from. Must be a blacklisted account.
892     */
893     function destroyBlacklistedTokens(address _who, uint256 _amount) public userBlacklisted(_who) whenNotPaused requiresPermission {
894         tokenStorage.subBalance(_who, _amount);
895         tokenStorage.subTotalSupply(_amount);
896         emit DestroyedBlacklistedTokens(_who, _amount);
897     }
898     /**
899     * @notice Allows a central authority to approve themselves as a spender on a blacklisted account.
900     * By default, the allowance is set to the balance of the blacklisted account, so that the
901     * authority has full control over the account balance.
902     * @dev Should be access-restricted with the 'requiresPermission' modifier when implementing.
903     * @param _blacklistedAccount The blacklisted account.
904     */
905     function approveBlacklistedAddressSpender(address _blacklistedAccount) 
906     public userBlacklisted(_blacklistedAccount) whenNotPaused requiresPermission {
907         tokenStorage.setAllowance(_blacklistedAccount, msg.sender, balanceOf(_blacklistedAccount));
908         emit ApprovedBlacklistedAddressSpender(_blacklistedAccount, msg.sender, balanceOf(_blacklistedAccount));
909     }
910 
911     /**
912     * @notice Initiates a "send" operation towards another user. See `transferFrom` for details.
913     * @param _to The address of the receiver. This user must not be blacklisted, or else the tranfer
914     * will fail.
915     * @param _amount The number of tokens to transfer
916     *
917     * @return `true` if successful 
918     */
919     function transfer(address _to, uint256 _amount) public userNotBlacklisted(_to) userNotBlacklisted(msg.sender) whenNotPaused returns (bool) {
920         _transfer(_to, msg.sender, _amount);
921         return true;
922     }
923 
924     /**
925     * @notice Initiates a transfer operation between address `_from` and `_to`. Requires that the
926     * message sender is an approved spender on the _from account.
927     * @dev When implemented, it should use the transferFromConditionsRequired() modifier.
928     * @param _to The address of the recipient. This address must not be blacklisted.
929     * @param _from The address of the origin of funds. This address _could_ be blacklisted, because
930     * a regulator may want to transfer tokens out of a blacklisted account, for example.
931     * In order to do so, the regulator would have to add themselves as an approved spender
932     * on the account via `addBlacklistAddressSpender()`, and would then be able to transfer tokens out of it.
933     * @param _amount The number of tokens to transfer
934     * @return `true` if successful 
935     */
936     function transferFrom(address _from, address _to, uint256 _amount) 
937     public whenNotPaused transferFromConditionsRequired(_from, _to) returns (bool) {
938         require(_amount <= allowance(_from, msg.sender),"not enough allowance to transfer");
939         _transfer(_to, _from, _amount);
940         tokenStorage.subAllowance(_from, msg.sender, _amount);
941         return true;
942     }
943 
944     /**
945     *
946     * @dev Only the token owner can change its regulator
947     * @param _newRegulator the new Regulator for this token
948     *
949     */
950     function setRegulator(address _newRegulator) public onlyOwner {
951         require(_newRegulator != address(regulator), "Must be a new regulator");
952         require(AddressUtils.isContract(_newRegulator), "Cannot set a regulator storage to a non-contract address");
953         address old = address(regulator);
954         regulator = Regulator(_newRegulator);
955         emit ChangedRegulator(old, _newRegulator);
956     }
957 
958     /**
959     * @notice If a user is blacklisted, they will have the permission to 
960     * execute this dummy function. This function effectively acts as a marker 
961     * to indicate that a user is blacklisted. We include this function to be consistent with our
962     * invariant that every possible userPermission (listed in Regulator) enables access to a single 
963     * PermissionedToken function. Thus, the 'BLACKLISTED' permission gives access to this function
964     * @return `true` if successful
965     */
966     function blacklisted() public view requiresPermission returns (bool) {
967         return true;
968     }
969 
970     /**
971     * ERC20 standard functions
972     */
973     function allowance(address owner, address spender) public view returns (uint256) {
974         return tokenStorage.allowances(owner, spender);
975     }
976 
977     function totalSupply() public view returns (uint256) {
978         return tokenStorage.totalSupply();
979     }
980 
981     function balanceOf(address _addr) public view returns (uint256) {
982         return tokenStorage.balances(_addr);
983     }
984 
985 
986     /** Internal functions **/
987     
988     function _decreaseApproval(address _spender, uint256 _subtractedValue, address _tokenHolder) internal {
989         uint256 oldValue = allowance(_tokenHolder, _spender);
990         if (_subtractedValue > oldValue) {
991             tokenStorage.setAllowance(_tokenHolder, _spender, 0);
992         } else {
993             tokenStorage.subAllowance(_tokenHolder, _spender, _subtractedValue);
994         }
995         emit Approval(_tokenHolder, _spender, allowance(_tokenHolder, _spender));
996     }
997 
998     function _increaseApproval(address _spender, uint256 _addedValue, address _tokenHolder) internal {
999         tokenStorage.addAllowance(_tokenHolder, _spender, _addedValue);
1000         emit Approval(_tokenHolder, _spender, allowance(_tokenHolder, _spender));
1001     }
1002 
1003     function _burn(address _tokensOf, uint256 _amount) internal {
1004         require(_tokensOf != address(0),"burner address cannot be 0x0");
1005         require(_amount <= balanceOf(_tokensOf),"not enough balance to burn");
1006         // no need to require value <= totalSupply, since that would imply the
1007         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1008         tokenStorage.subBalance(_tokensOf, _amount);
1009         tokenStorage.subTotalSupply(_amount);
1010         emit Burn(_tokensOf, _amount);
1011         emit Transfer(_tokensOf, address(0), _amount);
1012     }
1013 
1014     function _mint(address _to, uint256 _amount) internal {
1015         require(_to != address(0),"to address cannot be 0x0");
1016         tokenStorage.addTotalSupply(_amount);
1017         tokenStorage.addBalance(_to, _amount);
1018         emit Mint(_to, _amount);
1019         emit Transfer(address(0), _to, _amount);
1020     }
1021 
1022     function _transfer(address _to, address _from, uint256 _amount) internal {
1023         require(_to != address(0),"to address cannot be 0x0");
1024         require(_amount <= balanceOf(_from),"not enough balance to transfer");
1025 
1026         tokenStorage.addBalance(_to, _amount);
1027         tokenStorage.subBalance(_from, _amount);
1028         emit Transfer(_from, _to, _amount);
1029     }
1030 
1031 }
1032 
1033 /**
1034 * @title WhitelistedToken
1035 * @notice A WhitelistedToken can be converted into CUSD and vice versa. Converting a WT into a CUSD
1036 * is the only way for a user to obtain CUSD. This is a permissioned token, so users have to be 
1037 * whitelisted before they can do any mint/burn/convert operation.
1038 */
1039 contract WhitelistedToken is PermissionedToken {
1040 
1041 
1042     address public cusdAddress;
1043 
1044     /**
1045         Events
1046      */
1047     event CUSDAddressChanged(address indexed oldCUSD, address indexed newCUSD);
1048     event MintedToCUSD(address indexed user, uint256 amount);
1049     event ConvertedToCUSD(address indexed user, uint256 amount);
1050 
1051     /**
1052     * @notice Constructor sets the regulator contract and the address of the
1053     * CarbonUSD meta-token contract. The latter is necessary in order to make transactions
1054     * with the CarbonDollar smart contract.
1055     */
1056     constructor(address _regulator, address _cusd) public PermissionedToken(_regulator) {
1057 
1058         // base class fields
1059         regulator = Regulator(_regulator);
1060 
1061         cusdAddress = _cusd;
1062 
1063     }
1064 
1065     /**
1066     * @notice Mints CarbonUSD for the user. Stores the WT0 that backs the CarbonUSD
1067     * into the CarbonUSD contract's escrow account.
1068     * @param _to The address of the receiver
1069     * @param _amount The number of CarbonTokens to mint to user
1070     */
1071     function mintCUSD(address _to, uint256 _amount) public requiresPermission whenNotPaused userNotBlacklisted(_to) {
1072         return _mintCUSD(_to, _amount);
1073     }
1074 
1075     /**
1076     * @notice Converts WT0 to CarbonUSD for the user. Stores the WT0 that backs the CarbonUSD
1077     * into the CarbonUSD contract's escrow account.
1078     * @param _amount The number of Whitelisted tokens to convert
1079     */
1080     function convertWT(uint256 _amount) public userNotBlacklisted(msg.sender) whenNotPaused {
1081         require(balanceOf(msg.sender) >= _amount, "Conversion amount should be less than balance");
1082         _burn(msg.sender, _amount);
1083         _mintCUSD(msg.sender, _amount);
1084         emit ConvertedToCUSD(msg.sender, _amount);
1085     }
1086 
1087     /**
1088      * @notice Change the cusd address.
1089      * @param _cusd the cusd address.
1090      */
1091     function setCUSDAddress(address _cusd) public onlyOwner {
1092         require(_cusd != address(cusdAddress), "Must be a new cusd address");
1093         require(AddressUtils.isContract(_cusd), "Must be an actual contract");
1094         address oldCUSD = address(cusdAddress);
1095         cusdAddress = _cusd;
1096         emit CUSDAddressChanged(oldCUSD, _cusd);
1097     }
1098 
1099     function _mintCUSD(address _to, uint256 _amount) internal {
1100         require(_to != cusdAddress, "Cannot mint to CarbonUSD contract"); // This is to prevent Carbon Labs from printing money out of thin air!
1101         CarbonDollar(cusdAddress).mint(_to, _amount);
1102         _mint(cusdAddress, _amount);
1103         emit MintedToCUSD(_to, _amount);
1104     }
1105 }
1106 
1107 /**
1108 * @title CarbonDollar
1109 * @notice The main functionality for the CarbonUSD metatoken. (CarbonUSD is just a proxy
1110 * that implements this contract's functionality.) This is a permissioned token, so users have to be 
1111 * whitelisted before they can do any mint/burn/convert operation. Every CarbonDollar token is backed by one
1112 * whitelisted stablecoin credited to the balance of this contract address.
1113 */
1114 contract CarbonDollar is PermissionedToken {
1115     
1116     // Events
1117 
1118     event ConvertedToWT(address indexed user, uint256 amount);
1119     event BurnedCUSD(address indexed user, uint256 feedAmount, uint256 chargedFee);
1120     
1121     /**
1122         Modifiers
1123     */
1124     modifier requiresWhitelistedToken() {
1125         require(isWhitelisted(msg.sender), "Sender must be a whitelisted token contract");
1126         _;
1127     }
1128 
1129     CarbonDollarStorage public tokenStorage_CD;
1130 
1131     /** CONSTRUCTOR
1132     * @dev Passes along arguments to base class.
1133     */
1134     constructor(address _regulator) public PermissionedToken(_regulator) {
1135 
1136         // base class override
1137         regulator = Regulator(_regulator);
1138 
1139         tokenStorage_CD = new CarbonDollarStorage();
1140     }
1141 
1142     /**
1143      * @notice Add new stablecoin to whitelist.
1144      * @param _stablecoin Address of stablecoin contract.
1145      */
1146     function listToken(address _stablecoin) public onlyOwner whenNotPaused {
1147         tokenStorage_CD.addStablecoin(_stablecoin); 
1148     }
1149 
1150     /**
1151      * @notice Remove existing stablecoin from whitelist.
1152      * @param _stablecoin Address of stablecoin contract.
1153      */
1154     function unlistToken(address _stablecoin) public onlyOwner whenNotPaused {
1155         tokenStorage_CD.removeStablecoin(_stablecoin);
1156     }
1157 
1158     /**
1159      * @notice Change fees associated with going from CarbonUSD to a particular stablecoin.
1160      * @param stablecoin Address of the stablecoin contract.
1161      * @param _newFee The new fee rate to set, in tenths of a percent. 
1162      */
1163     function setFee(address stablecoin, uint256 _newFee) public onlyOwner whenNotPaused {
1164         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1165         tokenStorage_CD.setFee(stablecoin, _newFee);
1166     }
1167 
1168     /**
1169      * @notice Remove fees associated with going from CarbonUSD to a particular stablecoin.
1170      * The default fee still may apply.
1171      * @param stablecoin Address of the stablecoin contract.
1172      */
1173     function removeFee(address stablecoin) public onlyOwner whenNotPaused {
1174         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1175        tokenStorage_CD.removeFee(stablecoin);
1176     }
1177 
1178     /**
1179      * @notice Change the default fee associated with going from CarbonUSD to a WhitelistedToken.
1180      * This fee amount is used if the fee for a WhitelistedToken is not specified.
1181      * @param _newFee The new fee rate to set, in tenths of a percent.
1182      */
1183     function setDefaultFee(uint256 _newFee) public onlyOwner whenNotPaused {
1184         tokenStorage_CD.setDefaultFee(_newFee);
1185     }
1186 
1187     /**
1188      * @notice Mints CUSD on behalf of a user. Note the use of the "requiresWhitelistedToken"
1189      * modifier; this means that minting authority does not belong to any personal account; 
1190      * only whitelisted token contracts can call this function. The intended functionality is that the only
1191      * way to mint CUSD is for the user to actually burn a whitelisted token to convert into CUSD
1192      * @param _to User to send CUSD to
1193      * @param _amount Amount of CarbonUSD to mint.
1194      */
1195     function mint(address _to, uint256 _amount) public requiresWhitelistedToken whenNotPaused {
1196         _mint(_to, _amount);
1197     }
1198 
1199     /**
1200      * @notice user can convert CarbonUSD umbrella token into a whitelisted stablecoin. 
1201      * @param stablecoin represents the type of coin the users wishes to receive for burning carbonUSD
1202      * @param _amount Amount of CarbonUSD to convert.
1203      * we credit the user's account at the sender address with the _amount minus the percentage fee we want to charge.
1204      */
1205     function convertCarbonDollar(address stablecoin, uint256 _amount) public userNotBlacklisted(msg.sender) whenNotPaused  {
1206         require(isWhitelisted(stablecoin), "Stablecoin must be whitelisted prior to setting conversion fee");
1207         WhitelistedToken whitelisted = WhitelistedToken(stablecoin);
1208         require(whitelisted.balanceOf(address(this)) >= _amount, "Carbon escrow account in WT0 doesn't have enough tokens for burning");
1209  
1210         // Send back WT0 to calling user, but with a fee reduction.
1211         // Transfer this fee into the whitelisted token's CarbonDollar account (this contract's address)
1212         uint256 chargedFee = tokenStorage_CD.computeFee(_amount, computeFeeRate(stablecoin));
1213         uint256 feedAmount = _amount.sub(chargedFee);
1214         _burn(msg.sender, _amount);
1215         require(whitelisted.transfer(msg.sender, feedAmount));
1216         whitelisted.burn(chargedFee);
1217         _mint(address(this), chargedFee);
1218         emit ConvertedToWT(msg.sender, _amount);
1219     }
1220 
1221      /**
1222      * @notice burns CarbonDollar and an equal amount of whitelisted stablecoin from the CarbonDollar address
1223      * @param stablecoin Represents the stablecoin whose fee will be charged.
1224      * @param _amount Amount of CarbonUSD to burn.
1225      */
1226     function burnCarbonDollar(address stablecoin, uint256 _amount) public userNotBlacklisted(msg.sender) whenNotPaused {
1227         _burnCarbonDollar(msg.sender, stablecoin, _amount);
1228     }
1229 
1230     /** 
1231     * @notice release collected CUSD fees to owner 
1232     * @param _amount Amount of CUSD to release
1233     * @return `true` if successful 
1234     */
1235     function releaseCarbonDollar(uint256 _amount) public onlyOwner returns (bool) {
1236         require(_amount <= balanceOf(address(this)),"not enough balance to transfer");
1237 
1238         tokenStorage.subBalance(address(this), _amount);
1239         tokenStorage.addBalance(msg.sender, _amount);
1240         emit Transfer(address(this), msg.sender, _amount);
1241         return true;
1242     }
1243 
1244     /** Computes fee percentage associated with burning into a particular stablecoin.
1245      * @param stablecoin The stablecoin whose fee will be charged. Precondition: is a whitelisted
1246      * stablecoin.
1247      * @return The fee that will be charged. If the stablecoin's fee is not set, the default
1248      * fee is returned.
1249      */
1250     function computeFeeRate(address stablecoin) public view returns (uint256 feeRate) {
1251         if (getFee(stablecoin) > 0) 
1252             feeRate = getFee(stablecoin);
1253         else
1254             feeRate = getDefaultFee();
1255     }
1256 
1257     /**
1258     * @notice Check if whitelisted token is whitelisted
1259     * @return bool true if whitelisted, false if not
1260     **/
1261     function isWhitelisted(address _stablecoin) public view returns (bool) {
1262         return tokenStorage_CD.whitelist(_stablecoin);
1263     }
1264 
1265     /**
1266      * @notice Get the fee associated with going from CarbonUSD to a specific WhitelistedToken.
1267      * @param stablecoin The stablecoin whose fee is being checked.
1268      * @return The fee associated with the stablecoin.
1269      */
1270     function getFee(address stablecoin) public view returns (uint256) {
1271         return tokenStorage_CD.fees(stablecoin);
1272     }
1273 
1274     /**
1275      * @notice Get the default fee associated with going from CarbonUSD to a specific WhitelistedToken.
1276      * @return The default fee for stablecoin trades.
1277      */
1278     function getDefaultFee() public view returns (uint256) {
1279         return tokenStorage_CD.defaultFee();
1280     }
1281 
1282     function _burnCarbonDollar(address _tokensOf, address _stablecoin, uint256 _amount) internal {
1283         require(isWhitelisted(_stablecoin), "Stablecoin must be whitelisted prior to burning");
1284         WhitelistedToken whitelisted = WhitelistedToken(_stablecoin);
1285         require(whitelisted.balanceOf(address(this)) >= _amount, "Carbon escrow account in WT0 doesn't have enough tokens for burning");
1286 
1287         // Burn user's CUSD, but with a fee reduction.
1288         uint256 chargedFee = tokenStorage_CD.computeFee(_amount, computeFeeRate(_stablecoin));
1289         uint256 feedAmount = _amount.sub(chargedFee);
1290         _burn(_tokensOf, _amount);
1291         whitelisted.burn(_amount);
1292         _mint(address(this), chargedFee);
1293         emit BurnedCUSD(_tokensOf, feedAmount, chargedFee); // Whitelisted trust account should send user feedAmount USD
1294     }
1295 
1296 }
1297 
1298 /**
1299 * @title MetaToken
1300 * @notice Extends the CarbonDollar token by providing functionality for users to interact with
1301 * the permissioned token contract without needing to pay gas fees. MetaToken will perform the 
1302 * exact same actions as a normal CarbonDollar, but first it will validate a signature of the 
1303 * hash of the parameters and ecrecover() a signature to prove the signer so everything is still 
1304 * cryptographically backed. Then, instead of doing actions on behalf of msg.sender, 
1305 * it will move the signer’s tokens. Finally, we can also wrap in a token reward to incentivise the relayer.
1306 * @notice inspiration from @austingriffith and @PhABCD for leading the meta-transaction innovations
1307 */
1308 contract MetaToken is CarbonDollar {
1309 
1310     /**
1311     * @dev create a new CarbonDollar with a brand new data storage
1312     **/
1313     constructor (address _regulator) CarbonDollar(_regulator) public {
1314     }
1315 
1316     /**
1317         Storage
1318     */
1319     mapping (address => uint256) public replayNonce;
1320 
1321     /** 
1322         ERC20 Metadata
1323     */
1324     string public constant name = "CUSD";
1325     string public constant symbol = "CUSD";
1326     uint8 public constant decimals = 18;
1327 
1328 
1329     /** Functions **/
1330 
1331     /**
1332     * @dev Verify and broadcast an increaseApproval() signed metatransaction. The msg.sender or "relayer"
1333     *           will pay for the ETH gas fees since they are sending this transaction, and in exchange
1334     *           the "signer" will pay CUSD to the relayer.
1335     * @notice increaseApproval should be used instead of approve when the user's allowance
1336     * is greater than 0. Using increaseApproval protects against potential double-spend attacks
1337     * by moving the check of whether the user has spent their allowance to the time that the transaction 
1338     * is mined, removing the user's ability to double-spend
1339     * @param _spender The address which will spend the funds.
1340     * @param _addedValue The amount of tokens to increase the allowance by.
1341     * @param _signature the metatransaction signature, which metaTransfer verifies is signed by the original transfer() sender
1342     * @param _nonce to prevent replay attack of metatransactions
1343     * @param _reward amount of CUSD to pay relayer in
1344     * @return `true` if successful 
1345      */
1346     function metaIncreaseApproval(address _spender, uint256 _addedValue, bytes _signature, uint256 _nonce, uint256 _reward) 
1347     public userNotBlacklisted(_spender) whenNotPaused returns (bool) {
1348         bytes32 metaHash = metaApproveHash(_spender, _addedValue, _nonce, _reward);
1349         address signer = _getSigner(metaHash, _signature);
1350         require(!regulator.isBlacklistedUser(signer), "signer is blacklisted");
1351         require(_nonce == replayNonce[signer], "this transaction has already been broadcast");
1352         replayNonce[signer]++;
1353 
1354         require( _reward > 0, "reward to incentivize relayer must be positive");
1355         require( _reward <= balanceOf(signer),"not enough balance to reward relayer");
1356         _increaseApproval(_spender, _addedValue, signer);
1357         _transfer(msg.sender, signer, _reward);
1358         return true;
1359     }
1360 
1361     /**
1362     * @notice Verify and broadcast a transfer() signed metatransaction. The msg.sender or "relayer"
1363     *           will pay for the ETH gas fees since they are sending this transaction, and in exchange
1364     *           the "signer" will pay CUSD to the relayer.
1365     * @param _to The address of the receiver. This user must not be blacklisted, or else the transfer
1366     * will fail.
1367     * @param _amount The number of tokens to transfer
1368     * @param _signature the metatransaction signature, which metaTransfer verifies is signed by the original transfer() sender
1369     * @param _nonce to prevent replay attack of metatransactions
1370     * @param _reward amount of CUSD to pay relayer in
1371     * @return `true` if successful 
1372     */
1373     function metaTransfer(address _to, uint256 _amount, bytes _signature, uint256 _nonce, uint256 _reward) public userNotBlacklisted(_to) whenNotPaused returns (bool) {
1374         bytes32 metaHash = metaTransferHash(_to, _amount, _nonce, _reward);
1375         address signer = _getSigner(metaHash, _signature);
1376         require(!regulator.isBlacklistedUser(signer), "signer is blacklisted");
1377         require(_nonce == replayNonce[signer], "this transaction has already been broadcast");
1378         replayNonce[signer]++;
1379 
1380         require( _reward > 0, "reward to incentivize relayer must be positive");
1381         require( (_amount + _reward) <= balanceOf(signer),"not enough balance to transfer and reward relayer");
1382         _transfer(_to, signer, _amount);
1383         _transfer(msg.sender, signer, _reward);
1384         return true;
1385     }
1386 
1387     /**
1388     * @notice Verify and broadcast a burnCarbonDollar() signed metatransaction. The msg.sender or "relayer"
1389     *           will pay for the ETH gas fees since they are sending this transaction, and in exchange
1390     *           the "signer" will pay CUSD to the relayer.
1391     * @param _stablecoin Represents the stablecoin that is backing the active CUSD.
1392     * @param _amount The number of tokens to transfer
1393     * @param _signature the metatransaction signature, which metaTransfer verifies is signed by the original transfer() sender
1394     * @param _nonce to prevent replay attack of metatransactions
1395     * @param _reward amount of CUSD to pay relayer in
1396     * @return `true` if successful 
1397     */
1398     function metaBurnCarbonDollar(address _stablecoin, uint256 _amount, bytes _signature, uint256 _nonce, uint256 _reward) public whenNotPaused returns (bool) {
1399         bytes32 metaHash = metaBurnHash(_stablecoin, _amount, _nonce, _reward);
1400         address signer = _getSigner(metaHash, _signature);
1401         require(!regulator.isBlacklistedUser(signer), "signer is blacklisted");
1402         require(_nonce == replayNonce[signer], "this transaction has already been broadcast");
1403         replayNonce[signer]++;
1404 
1405         require( _reward > 0, "reward to incentivize relayer must be positive");
1406         require( (_amount + _reward) <= balanceOf(signer),"not enough balance to burn and reward relayer");
1407         _burnCarbonDollar(signer, _stablecoin, _amount);
1408         _transfer(msg.sender, signer, _reward);
1409         return true;
1410     }
1411 
1412     /**
1413     * @notice Return hash containing all of the information about the transfer() metatransaction
1414     * @param _to The address of the transfer receiver
1415     * @param _amount The number of tokens to transfer
1416     * @param _nonce to prevent replay attack of metatransactions
1417     * @param _reward amount of CUSD to pay relayer in
1418     * @return bytes32 hash of metatransaction
1419     */
1420     function metaTransferHash(address _to, uint256 _amount, uint256 _nonce, uint256 _reward) public view returns(bytes32){
1421         return keccak256(abi.encodePacked(address(this),"metaTransfer", _to, _amount, _nonce, _reward));
1422     }
1423 
1424     /**
1425     * @notice Return hash containing all of the information about the increaseApproval() metatransaction
1426     * @param _spender The address which will spend the funds.
1427     * @param _addedValue The amount of tokens to increase the allowance by.
1428     * @param _nonce to prevent replay attack of metatransactions
1429     * @param _reward amount of CUSD to pay relayer in
1430     * @return bytes32 hash of metatransaction
1431     */
1432     function metaApproveHash(address _spender, uint256 _addedValue, uint256 _nonce, uint256 _reward) public view returns(bytes32){
1433         return keccak256(abi.encodePacked(address(this),"metaIncreaseApproval", _spender, _addedValue, _nonce, _reward));
1434     }
1435 
1436     /**
1437     * @notice Return hash containing all of the information about the burnCarbonDollar() metatransaction
1438     * @param _stablecoin Represents the stablecoin that is backing the active CUSD.    
1439     * @param _amount The number of tokens to burn
1440     * @param _nonce to prevent replay attack of metatransactions
1441     * @param _reward amount of CUSD to pay relayer in
1442     * @return bytes32 hash of metatransaction
1443     */
1444     function metaBurnHash(address _stablecoin, uint256 _amount, uint256 _nonce, uint256 _reward) public view returns(bytes32){
1445         return keccak256(abi.encodePacked(address(this),"metaBurnCarbonDollar", _stablecoin, _amount, _nonce, _reward));
1446     }
1447 
1448     /**
1449     * @dev Recover signer of original metatransaction 
1450     * @param _hash derived bytes32 metatransaction signature, which should be the same as the parameter _signature
1451     * @param _signature bytes metatransaction signature, the signature is generated using web3.eth.sign()
1452     * @return address of hash signer
1453     */
1454     function _getSigner(bytes32 _hash, bytes _signature) internal pure returns (address){
1455         bytes32 r;
1456         bytes32 s;
1457         uint8 v;
1458         if (_signature.length != 65) {
1459             return address(0);
1460         }
1461         assembly {
1462             r := mload(add(_signature, 32))
1463             s := mload(add(_signature, 64))
1464             v := byte(0, mload(add(_signature, 96)))
1465         }
1466         if (v < 27) {
1467             v += 27;
1468         }
1469         if (v != 27 && v != 28) {
1470             return address(0);
1471         } else {
1472             return ecrecover(keccak256(
1473                 abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
1474             ), v, r, s);
1475         }
1476     }
1477 
1478 }