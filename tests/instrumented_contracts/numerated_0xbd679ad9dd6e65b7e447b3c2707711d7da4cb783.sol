1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: openzeppelin-solidity/contracts/access/rbac/Roles.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 /**
74  * @title Roles
75  * @author Francisco Giordano (@frangio)
76  * @dev Library for managing addresses assigned to a Role.
77  * See RBAC.sol for example usage.
78  */
79 library Roles {
80   struct Role {
81     mapping (address => bool) bearer;
82   }
83 
84   /**
85    * @dev give an address access to this role
86    */
87   function add(Role storage _role, address _addr)
88     internal
89   {
90     _role.bearer[_addr] = true;
91   }
92 
93   /**
94    * @dev remove an address' access to this role
95    */
96   function remove(Role storage _role, address _addr)
97     internal
98   {
99     _role.bearer[_addr] = false;
100   }
101 
102   /**
103    * @dev check if an address has this role
104    * // reverts
105    */
106   function check(Role storage _role, address _addr)
107     internal
108     view
109   {
110     require(has(_role, _addr));
111   }
112 
113   /**
114    * @dev check if an address has this role
115    * @return bool
116    */
117   function has(Role storage _role, address _addr)
118     internal
119     view
120     returns (bool)
121   {
122     return _role.bearer[_addr];
123   }
124 }
125 
126 // File: openzeppelin-solidity/contracts/access/rbac/RBAC.sol
127 
128 pragma solidity ^0.4.24;
129 
130 
131 
132 /**
133  * @title RBAC (Role-Based Access Control)
134  * @author Matt Condon (@Shrugs)
135  * @dev Stores and provides setters and getters for roles and addresses.
136  * Supports unlimited numbers of roles and addresses.
137  * See //contracts/mocks/RBACMock.sol for an example of usage.
138  * This RBAC method uses strings to key roles. It may be beneficial
139  * for you to write your own implementation of this interface using Enums or similar.
140  */
141 contract RBAC {
142   using Roles for Roles.Role;
143 
144   mapping (string => Roles.Role) private roles;
145 
146   event RoleAdded(address indexed operator, string role);
147   event RoleRemoved(address indexed operator, string role);
148 
149   /**
150    * @dev reverts if addr does not have role
151    * @param _operator address
152    * @param _role the name of the role
153    * // reverts
154    */
155   function checkRole(address _operator, string _role)
156     public
157     view
158   {
159     roles[_role].check(_operator);
160   }
161 
162   /**
163    * @dev determine if addr has role
164    * @param _operator address
165    * @param _role the name of the role
166    * @return bool
167    */
168   function hasRole(address _operator, string _role)
169     public
170     view
171     returns (bool)
172   {
173     return roles[_role].has(_operator);
174   }
175 
176   /**
177    * @dev add a role to an address
178    * @param _operator address
179    * @param _role the name of the role
180    */
181   function addRole(address _operator, string _role)
182     internal
183   {
184     roles[_role].add(_operator);
185     emit RoleAdded(_operator, _role);
186   }
187 
188   /**
189    * @dev remove a role from an address
190    * @param _operator address
191    * @param _role the name of the role
192    */
193   function removeRole(address _operator, string _role)
194     internal
195   {
196     roles[_role].remove(_operator);
197     emit RoleRemoved(_operator, _role);
198   }
199 
200   /**
201    * @dev modifier to scope access to a single role (uses msg.sender as addr)
202    * @param _role the name of the role
203    * // reverts
204    */
205   modifier onlyRole(string _role)
206   {
207     checkRole(msg.sender, _role);
208     _;
209   }
210 
211   /**
212    * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
213    * @param _roles the names of the roles to scope access to
214    * // reverts
215    *
216    * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
217    *  see: https://github.com/ethereum/solidity/issues/2467
218    */
219   // modifier onlyRoles(string[] _roles) {
220   //     bool hasAnyRole = false;
221   //     for (uint8 i = 0; i < _roles.length; i++) {
222   //         if (hasRole(msg.sender, _roles[i])) {
223   //             hasAnyRole = true;
224   //             break;
225   //         }
226   //     }
227 
228   //     require(hasAnyRole);
229 
230   //     _;
231   // }
232 }
233 
234 // File: openzeppelin-solidity/contracts/access/Whitelist.sol
235 
236 pragma solidity ^0.4.24;
237 
238 
239 
240 
241 /**
242  * @title Whitelist
243  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
244  * This simplifies the implementation of "user permissions".
245  */
246 contract Whitelist is Ownable, RBAC {
247   string public constant ROLE_WHITELISTED = "whitelist";
248 
249   /**
250    * @dev Throws if operator is not whitelisted.
251    * @param _operator address
252    */
253   modifier onlyIfWhitelisted(address _operator) {
254     checkRole(_operator, ROLE_WHITELISTED);
255     _;
256   }
257 
258   /**
259    * @dev add an address to the whitelist
260    * @param _operator address
261    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
262    */
263   function addAddressToWhitelist(address _operator)
264     public
265     onlyOwner
266   {
267     addRole(_operator, ROLE_WHITELISTED);
268   }
269 
270   /**
271    * @dev getter to determine if address is in whitelist
272    */
273   function whitelist(address _operator)
274     public
275     view
276     returns (bool)
277   {
278     return hasRole(_operator, ROLE_WHITELISTED);
279   }
280 
281   /**
282    * @dev add addresses to the whitelist
283    * @param _operators addresses
284    * @return true if at least one address was added to the whitelist,
285    * false if all addresses were already in the whitelist
286    */
287   function addAddressesToWhitelist(address[] _operators)
288     public
289     onlyOwner
290   {
291     for (uint256 i = 0; i < _operators.length; i++) {
292       addAddressToWhitelist(_operators[i]);
293     }
294   }
295 
296   /**
297    * @dev remove an address from the whitelist
298    * @param _operator address
299    * @return true if the address was removed from the whitelist,
300    * false if the address wasn't in the whitelist in the first place
301    */
302   function removeAddressFromWhitelist(address _operator)
303     public
304     onlyOwner
305   {
306     removeRole(_operator, ROLE_WHITELISTED);
307   }
308 
309   /**
310    * @dev remove addresses from the whitelist
311    * @param _operators addresses
312    * @return true if at least one address was removed from the whitelist,
313    * false if all addresses weren't in the whitelist in the first place
314    */
315   function removeAddressesFromWhitelist(address[] _operators)
316     public
317     onlyOwner
318   {
319     for (uint256 i = 0; i < _operators.length; i++) {
320       removeAddressFromWhitelist(_operators[i]);
321     }
322   }
323 
324 }
325 
326 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
327 
328 pragma solidity ^0.4.24;
329 
330 
331 
332 /**
333  * @title Pausable
334  * @dev Base contract which allows children to implement an emergency stop mechanism.
335  */
336 contract Pausable is Ownable {
337   event Pause();
338   event Unpause();
339 
340   bool public paused = false;
341 
342 
343   /**
344    * @dev Modifier to make a function callable only when the contract is not paused.
345    */
346   modifier whenNotPaused() {
347     require(!paused);
348     _;
349   }
350 
351   /**
352    * @dev Modifier to make a function callable only when the contract is paused.
353    */
354   modifier whenPaused() {
355     require(paused);
356     _;
357   }
358 
359   /**
360    * @dev called by the owner to pause, triggers stopped state
361    */
362   function pause() public onlyOwner whenNotPaused {
363     paused = true;
364     emit Pause();
365   }
366 
367   /**
368    * @dev called by the owner to unpause, returns to normal state
369    */
370   function unpause() public onlyOwner whenPaused {
371     paused = false;
372     emit Unpause();
373   }
374 }
375 
376 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
377 
378 pragma solidity ^0.4.24;
379 
380 
381 /**
382  * @title SafeMath
383  * @dev Math operations with safety checks that throw on error
384  */
385 library SafeMath {
386 
387   /**
388   * @dev Multiplies two numbers, throws on overflow.
389   */
390   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
391     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
392     // benefit is lost if 'b' is also tested.
393     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
394     if (_a == 0) {
395       return 0;
396     }
397 
398     c = _a * _b;
399     assert(c / _a == _b);
400     return c;
401   }
402 
403   /**
404   * @dev Integer division of two numbers, truncating the quotient.
405   */
406   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
407     // assert(_b > 0); // Solidity automatically throws when dividing by 0
408     // uint256 c = _a / _b;
409     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
410     return _a / _b;
411   }
412 
413   /**
414   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
415   */
416   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
417     assert(_b <= _a);
418     return _a - _b;
419   }
420 
421   /**
422   * @dev Adds two numbers, throws on overflow.
423   */
424   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
425     c = _a + _b;
426     assert(c >= _a);
427     return c;
428   }
429 }
430 
431 // File: contracts/v2/interfaces/IKODAV2SelfServiceEditionCuration.sol
432 
433 pragma solidity 0.4.24;
434 
435 interface IKODAV2SelfServiceEditionCuration {
436 
437   function createActiveEdition(
438     uint256 _editionNumber,
439     bytes32 _editionData,
440     uint256 _editionType,
441     uint256 _startDate,
442     uint256 _endDate,
443     address _artistAccount,
444     uint256 _artistCommission,
445     uint256 _priceInWei,
446     string _tokenUri,
447     uint256 _totalAvailable
448   ) external returns (bool);
449 
450   function artistsEditions(address _artistsAccount) external returns (uint256[1] _editionNumbers);
451 
452   function totalAvailableEdition(uint256 _editionNumber) external returns (uint256);
453 
454   function highestEditionNumber() external returns (uint256);
455 
456   function updateOptionalCommission(uint256 _editionNumber, uint256 _rate, address _recipient) external;
457 
458   function updateStartDate(uint256 _editionNumber, uint256 _startDate) external;
459 
460   function updateEndDate(uint256 _editionNumber, uint256 _endDate) external;
461 
462   function updateEditionType(uint256 _editionNumber, uint256 _editionType) external;
463 }
464 
465 // File: contracts/v2/interfaces/IKODAAuction.sol
466 
467 pragma solidity 0.4.24;
468 
469 interface IKODAAuction {
470   function setArtistsControlAddressAndEnabledEdition(uint256 _editionNumber, address _address) external;
471 }
472 
473 // File: contracts/v2/interfaces/ISelfServiceAccessControls.sol
474 
475 pragma solidity 0.4.24;
476 
477 interface ISelfServiceAccessControls {
478 
479   function isEnabledForAccount(address account) public view returns (bool);
480 
481 }
482 
483 // File: contracts/v2/interfaces/ISelfServiceFrequencyControls.sol
484 
485 pragma solidity 0.4.24;
486 
487 interface ISelfServiceFrequencyControls {
488 
489   /*
490    * Checks is the given artist can create another edition
491    * @param artist - the edition artist
492    * @param totalAvailable - the edition size
493    * @param priceInWei - the edition price in wei
494    */
495   function canCreateNewEdition(address artist) external view returns (bool);
496 
497   /*
498    * Records that an edition has been created
499    * @param artist - the edition artist
500    * @param totalAvailable - the edition size
501    * @param priceInWei - the edition price in wei
502    */
503   function recordSuccessfulMint(address artist, uint256 totalAvailable, uint256 priceInWei) external returns (bool);
504 }
505 
506 // File: contracts/v2/self-service/SelfServiceEditionCurationV4.sol
507 
508 pragma solidity 0.4.24;
509 
510 
511 
512 
513 
514 
515 
516 
517 // One invocation per time-period
518 contract SelfServiceEditionCurationV4 is Whitelist, Pausable {
519   using SafeMath for uint256;
520 
521   event SelfServiceEditionCreated(
522     uint256 indexed _editionNumber,
523     address indexed _creator,
524     uint256 _priceInWei,
525     uint256 _totalAvailable,
526     bool _enableAuction
527   );
528 
529   // Calling address
530   IKODAV2SelfServiceEditionCuration public kodaV2;
531   IKODAAuction public auction;
532   ISelfServiceAccessControls public accessControls;
533   ISelfServiceFrequencyControls public frequencyControls;
534 
535   // Default KO commission
536   uint256 public koCommission = 15;
537 
538   // Config which enforces editions to not be over this size
539   uint256 public maxEditionSize = 100;
540 
541   // Config the minimum price per edition
542   uint256 public minPricePerEdition = 0.01 ether;
543 
544   /**
545    * @dev Construct a new instance of the contract
546    */
547   constructor(
548     IKODAV2SelfServiceEditionCuration _kodaV2,
549     IKODAAuction _auction,
550     ISelfServiceAccessControls _accessControls,
551     ISelfServiceFrequencyControls _frequencyControls
552   ) public {
553     super.addAddressToWhitelist(msg.sender);
554     kodaV2 = _kodaV2;
555     auction = _auction;
556     accessControls = _accessControls;
557     frequencyControls = _frequencyControls;
558   }
559 
560   /**
561    * @dev Called by artists, create new edition on the KODA platform
562    */
563   function createEdition(
564     bool _enableAuction,
565     address _optionalSplitAddress,
566     uint256 _optionalSplitRate,
567     uint256 _totalAvailable,
568     uint256 _priceInWei,
569     uint256 _startDate,
570     uint256 _endDate,
571     uint256 _artistCommission,
572     uint256 _editionType,
573     string _tokenUri
574   )
575   public
576   whenNotPaused
577   returns (uint256 _editionNumber)
578   {
579     require(frequencyControls.canCreateNewEdition(msg.sender), 'Sender currently frozen out of creation');
580     require(_artistCommission.add(_optionalSplitRate).add(koCommission) <= 100, "Total commission exceeds 100");
581 
582     uint256 editionNumber = _createEdition(
583       msg.sender,
584       _enableAuction,
585       [_totalAvailable, _priceInWei, _startDate, _endDate, _artistCommission, _editionType],
586       _tokenUri
587     );
588 
589     if (_optionalSplitRate > 0 && _optionalSplitAddress != address(0)) {
590       kodaV2.updateOptionalCommission(editionNumber, _optionalSplitRate, _optionalSplitAddress);
591     }
592 
593     frequencyControls.recordSuccessfulMint(msg.sender, _totalAvailable, _priceInWei);
594 
595     return editionNumber;
596   }
597 
598   /**
599    * @dev Called by artists, create new edition on the KODA platform, single commission split between artists and KO only
600    */
601   function createEditionSimple(
602     bool _enableAuction,
603     uint256 _totalAvailable,
604     uint256 _priceInWei,
605     uint256 _startDate,
606     uint256 _endDate,
607     uint256 _artistCommission,
608     uint256 _editionType,
609     string _tokenUri
610   )
611   public
612   whenNotPaused
613   returns (uint256 _editionNumber)
614   {
615     require(frequencyControls.canCreateNewEdition(msg.sender), 'Sender currently frozen out of creation');
616     require(_artistCommission.add(koCommission) <= 100, "Total commission exceeds 100");
617 
618     uint256 editionNumber = _createEdition(
619       msg.sender,
620       _enableAuction,
621       [_totalAvailable, _priceInWei, _startDate, _endDate, _artistCommission, _editionType],
622       _tokenUri
623     );
624 
625     frequencyControls.recordSuccessfulMint(msg.sender, _totalAvailable, _priceInWei);
626 
627     return editionNumber;
628   }
629 
630   /**
631    * @dev Caller by owner, can create editions for other artists
632    * @dev Only callable from owner regardless of pause state
633    */
634   function createEditionFor(
635     address _artist,
636     bool _enableAuction,
637     address _optionalSplitAddress,
638     uint256 _optionalSplitRate,
639     uint256 _totalAvailable,
640     uint256 _priceInWei,
641     uint256 _startDate,
642     uint256 _endDate,
643     uint256 _artistCommission,
644     uint256 _editionType,
645     string _tokenUri
646   )
647   public
648   onlyIfWhitelisted(msg.sender)
649   returns (uint256 _editionNumber)
650   {
651     require(_artistCommission.add(_optionalSplitRate).add(koCommission) <= 100, "Total commission exceeds 100");
652 
653     uint256 editionNumber = _createEdition(
654       _artist,
655       _enableAuction,
656       [_totalAvailable, _priceInWei, _startDate, _endDate, _artistCommission, _editionType],
657       _tokenUri
658     );
659 
660     if (_optionalSplitRate > 0 && _optionalSplitAddress != address(0)) {
661       kodaV2.updateOptionalCommission(editionNumber, _optionalSplitRate, _optionalSplitAddress);
662     }
663 
664     frequencyControls.recordSuccessfulMint(_artist, _totalAvailable, _priceInWei);
665 
666     return editionNumber;
667   }
668 
669   /**
670    * @dev Internal function for edition creation
671    */
672   function _createEdition(
673     address _artist,
674     bool _enableAuction,
675     uint256[6] memory _params,
676     string _tokenUri
677   )
678   internal
679   returns (uint256 _editionNumber) {
680 
681     uint256 _totalAvailable = _params[0];
682     uint256 _priceInWei = _params[1];
683 
684     // Enforce edition size
685     require(msg.sender == owner || (_totalAvailable > 0 && _totalAvailable <= maxEditionSize), "Invalid edition size");
686 
687     // Enforce min price
688     require(msg.sender == owner || _priceInWei >= minPricePerEdition, "Invalid price");
689 
690     // If we are the owner, skip this artists check
691     require(msg.sender == owner || accessControls.isEnabledForAccount(_artist), "Not allowed to create edition");
692 
693     // Find the next edition number we can use
694     uint256 editionNumber = getNextAvailableEditionNumber();
695 
696     require(
697       kodaV2.createActiveEdition(
698         editionNumber,
699         0x0, // _editionData - no edition data
700         _params[5], //_editionType,
701         _params[2], // _startDate,
702         _params[3], //_endDate,
703         _artist,
704         _params[4], // _artistCommission - defaults to artistCommission if optional commission split missing
705         _priceInWei,
706         _tokenUri,
707         _totalAvailable
708       ),
709       "Failed to create new edition"
710     );
711 
712     // Enable the auction if desired
713     if (_enableAuction) {
714       auction.setArtistsControlAddressAndEnabledEdition(editionNumber, _artist);
715     }
716 
717     // Trigger event
718     emit SelfServiceEditionCreated(editionNumber, _artist, _priceInWei, _totalAvailable, _enableAuction);
719 
720     return editionNumber;
721   }
722 
723   /**
724    * @dev Internal function for dynamically generating the next KODA edition number
725    */
726   function getNextAvailableEditionNumber() internal returns (uint256 editionNumber) {
727 
728     // Get current highest edition and total in the edition
729     uint256 highestEditionNumber = kodaV2.highestEditionNumber();
730     uint256 totalAvailableEdition = kodaV2.totalAvailableEdition(highestEditionNumber);
731 
732     // Add the current highest plus its total, plus 1 as tokens start at 1 not zero
733     uint256 nextAvailableEditionNumber = highestEditionNumber.add(totalAvailableEdition).add(1);
734 
735     // Round up to next 100, 1000 etc based on max allowed size
736     return ((nextAvailableEditionNumber + maxEditionSize - 1) / maxEditionSize) * maxEditionSize;
737   }
738 
739   /**
740    * @dev Sets the KODA address
741    * @dev Only callable from owner
742    */
743   function setKodavV2(IKODAV2SelfServiceEditionCuration _kodaV2) onlyIfWhitelisted(msg.sender) public {
744     kodaV2 = _kodaV2;
745   }
746 
747   /**
748    * @dev Sets the KODA auction
749    * @dev Only callable from owner
750    */
751   function setAuction(IKODAAuction _auction) onlyIfWhitelisted(msg.sender) public {
752     auction = _auction;
753   }
754 
755   /**
756    * @dev Sets the default KO commission for each edition
757    * @dev Only callable from owner
758    */
759   function setKoCommission(uint256 _koCommission) onlyIfWhitelisted(msg.sender) public {
760     koCommission = _koCommission;
761   }
762 
763   /**
764    * @dev Sets the max edition size
765    * @dev Only callable from owner
766    */
767   function setMaxEditionSize(uint256 _maxEditionSize) onlyIfWhitelisted(msg.sender) public {
768     maxEditionSize = _maxEditionSize;
769   }
770 
771   /**
772    * @dev Sets minimum price per edition
773    * @dev Only callable from owner
774    */
775   function setMinPricePerEdition(uint256 _minPricePerEdition) onlyIfWhitelisted(msg.sender) public {
776     minPricePerEdition = _minPricePerEdition;
777   }
778 
779   /**
780    * @dev Checks to see if the account is currently frozen out
781    */
782   function isFrozen(address account) public view returns (bool) {
783     return frequencyControls.canCreateNewEdition(account);
784   }
785 
786   /**
787    * @dev Checks to see if the account can create editions
788    */
789   function isEnabledForAccount(address account) public view returns (bool) {
790     return accessControls.isEnabledForAccount(account);
791   }
792 
793   /**
794    * @dev Checks to see if the account can create editions
795    */
796   function canCreateAnotherEdition(address account) public view returns (bool) {
797     if (!accessControls.isEnabledForAccount(account)) {
798       return false;
799     }
800     return frequencyControls.canCreateNewEdition(account);
801   }
802 
803   /**
804    * @dev Allows for the ability to extract stuck ether
805    * @dev Only callable from owner
806    */
807   function withdrawStuckEther(address _withdrawalAccount) onlyIfWhitelisted(msg.sender) public {
808     require(_withdrawalAccount != address(0), "Invalid address provided");
809     _withdrawalAccount.transfer(address(this).balance);
810   }
811 }