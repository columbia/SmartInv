1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Transfer Manager module for core transfer validation functionality
5  */
6 contract GeneralTransferManagerStorage {
7 
8     //Address from which issuances come
9     address public issuanceAddress = address(0);
10 
11     //Address which can sign whitelist changes
12     address public signingAddress = address(0);
13 
14     bytes32 public constant WHITELIST = "WHITELIST";
15     bytes32 public constant FLAGS = "FLAGS";
16 
17     //from and to timestamps that an investor can send / receive tokens respectively
18     struct TimeRestriction {
19         //the moment when the sale lockup period ends and the investor can freely sell or transfer away their tokens
20         uint64 canSendAfter;
21         //the moment when the purchase lockup period ends and the investor can freely purchase or receive from others
22         uint64 canReceiveAfter;
23         uint64 expiryTime;
24         uint8 canBuyFromSTO;
25         uint8 added;
26     }
27 
28     // Allows all TimeRestrictions to be offset
29     struct Defaults {
30         uint64 canSendAfter;
31         uint64 canReceiveAfter;
32     }
33 
34     // Offset to be applied to all timings (except KYC expiry)
35     Defaults public defaults;
36 
37     // List of all addresses that have been added to the GTM at some point
38     address[] public investors;
39 
40     // An address can only send / receive tokens once their corresponding uint256 > block.number
41     // (unless allowAllTransfers == true or allowAllWhitelistTransfers == true)
42     mapping (address => TimeRestriction) public whitelist;
43     // Map of used nonces by customer
44     mapping(address => mapping(uint256 => bool)) public nonceMap;
45 
46     //If true, there are no transfer restrictions, for any addresses
47     bool public allowAllTransfers = false;
48     //If true, time lock is ignored for transfers (address must still be on whitelist)
49     bool public allowAllWhitelistTransfers = false;
50     //If true, time lock is ignored for issuances (address must still be on whitelist)
51     bool public allowAllWhitelistIssuances = true;
52     //If true, time lock is ignored for burn transactions
53     bool public allowAllBurnTransfers = false;
54 
55 }
56 
57 /**
58  * @title Proxy
59  * @dev Gives the possibility to delegate any call to a foreign implementation.
60  */
61 contract Proxy {
62 
63     /**
64     * @dev Tells the address of the implementation where every call will be delegated.
65     * @return address of the implementation to which it will be delegated
66     */
67     function _implementation() internal view returns (address);
68 
69     /**
70     * @dev Fallback function.
71     * Implemented entirely in `_fallback`.
72     */
73     function _fallback() internal {
74         _delegate(_implementation());
75     }
76 
77     /**
78     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
79     * This function will return whatever the implementation call returns
80     */
81     function _delegate(address implementation) internal {
82         /*solium-disable-next-line security/no-inline-assembly*/
83         assembly {
84             // Copy msg.data. We take full control of memory in this inline assembly
85             // block because it will not return to Solidity code. We overwrite the
86             // Solidity scratch pad at memory position 0.
87             calldatacopy(0, 0, calldatasize)
88 
89             // Call the implementation.
90             // out and outsize are 0 because we don't know the size yet.
91             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
92 
93             // Copy the returned data.
94             returndatacopy(0, 0, returndatasize)
95 
96             switch result
97             // delegatecall returns 0 on error.
98             case 0 { revert(0, returndatasize) }
99             default { return(0, returndatasize) }
100         }
101     }
102 
103     function () public payable {
104         _fallback();
105     }
106 }
107 
108 /**
109  * @title OwnedProxy
110  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
111  */
112 contract OwnedProxy is Proxy {
113 
114     // Owner of the contract
115     address private __owner;
116 
117     // Address of the current implementation
118     address internal __implementation;
119 
120     /**
121     * @dev Event to show ownership has been transferred
122     * @param _previousOwner representing the address of the previous owner
123     * @param _newOwner representing the address of the new owner
124     */
125     event ProxyOwnershipTransferred(address _previousOwner, address _newOwner);
126 
127     /**
128     * @dev Throws if called by any account other than the owner.
129     */
130     modifier ifOwner() {
131         if (msg.sender == _owner()) {
132             _;
133         } else {
134             _fallback();
135         }
136     }
137 
138     /**
139     * @dev the constructor sets the original owner of the contract to the sender account.
140     */
141     constructor() public {
142         _setOwner(msg.sender);
143     }
144 
145     /**
146     * @dev Tells the address of the owner
147     * @return the address of the owner
148     */
149     function _owner() internal view returns (address) {
150         return __owner;
151     }
152 
153     /**
154     * @dev Sets the address of the owner
155     */
156     function _setOwner(address _newOwner) internal {
157         require(_newOwner != address(0), "Address should not be 0x");
158         __owner = _newOwner;
159     }
160 
161     /**
162     * @notice Internal function to provide the address of the implementation contract
163     */
164     function _implementation() internal view returns (address) {
165         return __implementation;
166     }
167 
168     /**
169     * @dev Tells the address of the proxy owner
170     * @return the address of the proxy owner
171     */
172     function proxyOwner() external ifOwner returns (address) {
173         return _owner();
174     }
175 
176     /**
177     * @dev Tells the address of the current implementation
178     * @return address of the current implementation
179     */
180     function implementation() external ifOwner returns (address) {
181         return _implementation();
182     }
183 
184     /**
185     * @dev Allows the current owner to transfer control of the contract to a newOwner.
186     * @param _newOwner The address to transfer ownership to.
187     */
188     function transferProxyOwnership(address _newOwner) external ifOwner {
189         require(_newOwner != address(0), "Address should not be 0x");
190         emit ProxyOwnershipTransferred(_owner(), _newOwner);
191         _setOwner(_newOwner);
192     }
193 
194 }
195 
196 /**
197  * @title Utility contract to allow pausing and unpausing of certain functions
198  */
199 contract Pausable {
200 
201     event Pause(uint256 _timestammp);
202     event Unpause(uint256 _timestamp);
203 
204     bool public paused = false;
205 
206     /**
207     * @notice Modifier to make a function callable only when the contract is not paused.
208     */
209     modifier whenNotPaused() {
210         require(!paused, "Contract is paused");
211         _;
212     }
213 
214     /**
215     * @notice Modifier to make a function callable only when the contract is paused.
216     */
217     modifier whenPaused() {
218         require(paused, "Contract is not paused");
219         _;
220     }
221 
222    /**
223     * @notice Called by the owner to pause, triggers stopped state
224     */
225     function _pause() internal whenNotPaused {
226         paused = true;
227         /*solium-disable-next-line security/no-block-members*/
228         emit Pause(now);
229     }
230 
231     /**
232     * @notice Called by the owner to unpause, returns to normal state
233     */
234     function _unpause() internal whenPaused {
235         paused = false;
236         /*solium-disable-next-line security/no-block-members*/
237         emit Unpause(now);
238     }
239 
240 }
241 
242 /**
243  * @title ERC20 interface
244  * @dev see https://github.com/ethereum/EIPs/issues/20
245  */
246 interface IERC20 {
247     function decimals() external view returns (uint8);
248     function totalSupply() external view returns (uint256);
249     function balanceOf(address _owner) external view returns (uint256);
250     function allowance(address _owner, address _spender) external view returns (uint256);
251     function transfer(address _to, uint256 _value) external returns (bool);
252     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
253     function approve(address _spender, uint256 _value) external returns (bool);
254     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
255     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
256     event Transfer(address indexed from, address indexed to, uint256 value);
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 /**
261  * @title Storage for Module contract
262  * @notice Contract is abstract
263  */
264 contract ModuleStorage {
265 
266     /**
267      * @notice Constructor
268      * @param _securityToken Address of the security token
269      * @param _polyAddress Address of the polytoken
270      */
271     constructor (address _securityToken, address _polyAddress) public {
272         securityToken = _securityToken;
273         factory = msg.sender;
274         polyToken = IERC20(_polyAddress);
275     }
276     
277     address public factory;
278 
279     address public securityToken;
280 
281     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
282 
283     IERC20 public polyToken;
284 
285 }
286 
287 /**
288  * @title Transfer Manager module for core transfer validation functionality
289  */
290 contract GeneralTransferManagerProxy is GeneralTransferManagerStorage, ModuleStorage, Pausable, OwnedProxy {
291 
292     /**
293     * @notice Constructor
294     * @param _securityToken Address of the security token
295     * @param _polyAddress Address of the polytoken
296     * @param _implementation representing the address of the new implementation to be set
297     */
298     constructor (address _securityToken, address _polyAddress, address _implementation)
299     public
300     ModuleStorage(_securityToken, _polyAddress)
301     {
302         require(
303             _implementation != address(0),
304             "Implementation address should not be 0x"
305         );
306         __implementation = _implementation;
307     }
308 
309 }
310 
311 /**
312  * @title Interface that every module factory contract should implement
313  */
314 interface IModuleFactory {
315 
316     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
317     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
318     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
319     event GenerateModuleFromFactory(
320         address _module,
321         bytes32 indexed _moduleName,
322         address indexed _moduleFactory,
323         address _creator,
324         uint256 _setupCost,
325         uint256 _timestamp
326     );
327     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
328 
329     //Should create an instance of the Module, or throw
330     function deploy(bytes _data) external returns(address);
331 
332     /**
333      * @notice Type of the Module factory
334      */
335     function getTypes() external view returns(uint8[]);
336 
337     /**
338      * @notice Get the name of the Module
339      */
340     function getName() external view returns(bytes32);
341 
342     /**
343      * @notice Returns the instructions associated with the module
344      */
345     function getInstructions() external view returns (string);
346 
347     /**
348      * @notice Get the tags related to the module factory
349      */
350     function getTags() external view returns (bytes32[]);
351 
352     /**
353      * @notice Used to change the setup fee
354      * @param _newSetupCost New setup fee
355      */
356     function changeFactorySetupFee(uint256 _newSetupCost) external;
357 
358     /**
359      * @notice Used to change the usage fee
360      * @param _newUsageCost New usage fee
361      */
362     function changeFactoryUsageFee(uint256 _newUsageCost) external;
363 
364     /**
365      * @notice Used to change the subscription fee
366      * @param _newSubscriptionCost New subscription fee
367      */
368     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
369 
370     /**
371      * @notice Function use to change the lower and upper bound of the compatible version st
372      * @param _boundType Type of bound
373      * @param _newVersion New version array
374      */
375     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
376 
377    /**
378      * @notice Get the setup cost of the module
379      */
380     function getSetupCost() external view returns (uint256);
381 
382     /**
383      * @notice Used to get the lower bound
384      * @return Lower bound
385      */
386     function getLowerSTVersionBounds() external view returns(uint8[]);
387 
388      /**
389      * @notice Used to get the upper bound
390      * @return Upper bound
391      */
392     function getUpperSTVersionBounds() external view returns(uint8[]);
393 
394 }
395 
396 /**
397  * @title Ownable
398  * @dev The Ownable contract has an owner address, and provides basic authorization control
399  * functions, this simplifies the implementation of "user permissions".
400  */
401 contract Ownable {
402   address public owner;
403 
404 
405   event OwnershipRenounced(address indexed previousOwner);
406   event OwnershipTransferred(
407     address indexed previousOwner,
408     address indexed newOwner
409   );
410 
411 
412   /**
413    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
414    * account.
415    */
416   constructor() public {
417     owner = msg.sender;
418   }
419 
420   /**
421    * @dev Throws if called by any account other than the owner.
422    */
423   modifier onlyOwner() {
424     require(msg.sender == owner);
425     _;
426   }
427 
428   /**
429    * @dev Allows the current owner to relinquish control of the contract.
430    */
431   function renounceOwnership() public onlyOwner {
432     emit OwnershipRenounced(owner);
433     owner = address(0);
434   }
435 
436   /**
437    * @dev Allows the current owner to transfer control of the contract to a newOwner.
438    * @param _newOwner The address to transfer ownership to.
439    */
440   function transferOwnership(address _newOwner) public onlyOwner {
441     _transferOwnership(_newOwner);
442   }
443 
444   /**
445    * @dev Transfers control of the contract to a newOwner.
446    * @param _newOwner The address to transfer ownership to.
447    */
448   function _transferOwnership(address _newOwner) internal {
449     require(_newOwner != address(0));
450     emit OwnershipTransferred(owner, _newOwner);
451     owner = _newOwner;
452   }
453 }
454 
455 /**
456  * @title Helper library use to compare or validate the semantic versions
457  */
458 
459 library VersionUtils {
460 
461     /**
462      * @notice This function is used to validate the version submitted
463      * @param _current Array holds the present version of ST
464      * @param _new Array holds the latest version of the ST
465      * @return bool
466      */
467     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
468         bool[] memory _temp = new bool[](_current.length);
469         uint8 counter = 0;
470         for (uint8 i = 0; i < _current.length; i++) {
471             if (_current[i] < _new[i])
472                 _temp[i] = true;
473             else
474                 _temp[i] = false;
475         }
476 
477         for (i = 0; i < _current.length; i++) {
478             if (i == 0) {
479                 if (_current[i] <= _new[i])
480                     if(_temp[0]) {
481                         counter = counter + 3;
482                         break;
483                     } else
484                         counter++;
485                 else
486                     return false;
487             } else {
488                 if (_temp[i-1])
489                     counter++;
490                 else if (_current[i] <= _new[i])
491                     counter++;
492                 else
493                     return false;
494             }
495         }
496         if (counter == _current.length)
497             return true;
498     }
499 
500     /**
501      * @notice Used to compare the lower bound with the latest version
502      * @param _version1 Array holds the lower bound of the version
503      * @param _version2 Array holds the latest version of the ST
504      * @return bool
505      */
506     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
507         require(_version1.length == _version2.length, "Input length mismatch");
508         uint counter = 0;
509         for (uint8 j = 0; j < _version1.length; j++) {
510             if (_version1[j] == 0)
511                 counter ++;
512         }
513         if (counter != _version1.length) {
514             counter = 0;
515             for (uint8 i = 0; i < _version1.length; i++) {
516                 if (_version2[i] > _version1[i])
517                     return true;
518                 else if (_version2[i] < _version1[i])
519                     return false;
520                 else
521                     counter++;
522             }
523             if (counter == _version1.length - 1)
524                 return true;
525             else
526                 return false;
527         } else
528             return true;
529     }
530 
531     /**
532      * @notice Used to compare the upper bound with the latest version
533      * @param _version1 Array holds the upper bound of the version
534      * @param _version2 Array holds the latest version of the ST
535      * @return bool
536      */
537     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
538         require(_version1.length == _version2.length, "Input length mismatch");
539         uint counter = 0;
540         for (uint8 j = 0; j < _version1.length; j++) {
541             if (_version1[j] == 0)
542                 counter ++;
543         }
544         if (counter != _version1.length) {
545             counter = 0;
546             for (uint8 i = 0; i < _version1.length; i++) {
547                 if (_version1[i] > _version2[i])
548                     return true;
549                 else if (_version1[i] < _version2[i])
550                     return false;
551                 else
552                     counter++;
553             }
554             if (counter == _version1.length - 1)
555                 return true;
556             else
557                 return false;
558         } else
559             return true;
560     }
561 
562 
563     /**
564      * @notice Used to pack the uint8[] array data into uint24 value
565      * @param _major Major version
566      * @param _minor Minor version
567      * @param _patch Patch version
568      */
569     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
570         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
571     }
572 
573     /**
574      * @notice Used to convert packed data into uint8 array
575      * @param _packedVersion Packed data
576      */
577     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
578         uint8[] memory _unpackVersion = new uint8[](3);
579         _unpackVersion[0] = uint8(_packedVersion >> 16);
580         _unpackVersion[1] = uint8(_packedVersion >> 8);
581         _unpackVersion[2] = uint8(_packedVersion);
582         return _unpackVersion;
583     }
584 
585 
586 }
587 
588 /**
589  * @title Interface that any module factory contract should implement
590  * @notice Contract is abstract
591  */
592 contract ModuleFactory is IModuleFactory, Ownable {
593 
594     IERC20 public polyToken;
595     uint256 public usageCost;
596     uint256 public monthlySubscriptionCost;
597 
598     uint256 public setupCost;
599     string public description;
600     string public version;
601     bytes32 public name;
602     string public title;
603 
604     // @notice Allow only two variables to be stored
605     // 1. lowerBound 
606     // 2. upperBound
607     // @dev (0.0.0 will act as the wildcard) 
608     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
609     mapping(string => uint24) compatibleSTVersionRange;
610 
611     /**
612      * @notice Constructor
613      * @param _polyAddress Address of the polytoken
614      */
615     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
616         polyToken = IERC20(_polyAddress);
617         setupCost = _setupCost;
618         usageCost = _usageCost;
619         monthlySubscriptionCost = _subscriptionCost;
620     }
621 
622     /**
623      * @notice Used to change the fee of the setup cost
624      * @param _newSetupCost new setup cost
625      */
626     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
627         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
628         setupCost = _newSetupCost;
629     }
630 
631     /**
632      * @notice Used to change the fee of the usage cost
633      * @param _newUsageCost new usage cost
634      */
635     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
636         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
637         usageCost = _newUsageCost;
638     }
639 
640     /**
641      * @notice Used to change the fee of the subscription cost
642      * @param _newSubscriptionCost new subscription cost
643      */
644     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
645         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
646         monthlySubscriptionCost = _newSubscriptionCost;
647 
648     }
649 
650     /**
651      * @notice Updates the title of the ModuleFactory
652      * @param _newTitle New Title that will replace the old one.
653      */
654     function changeTitle(string _newTitle) public onlyOwner {
655         require(bytes(_newTitle).length > 0, "Invalid title");
656         title = _newTitle;
657     }
658 
659     /**
660      * @notice Updates the description of the ModuleFactory
661      * @param _newDesc New description that will replace the old one.
662      */
663     function changeDescription(string _newDesc) public onlyOwner {
664         require(bytes(_newDesc).length > 0, "Invalid description");
665         description = _newDesc;
666     }
667 
668     /**
669      * @notice Updates the name of the ModuleFactory
670      * @param _newName New name that will replace the old one.
671      */
672     function changeName(bytes32 _newName) public onlyOwner {
673         require(_newName != bytes32(0),"Invalid name");
674         name = _newName;
675     }
676 
677     /**
678      * @notice Updates the version of the ModuleFactory
679      * @param _newVersion New name that will replace the old one.
680      */
681     function changeVersion(string _newVersion) public onlyOwner {
682         require(bytes(_newVersion).length > 0, "Invalid version");
683         version = _newVersion;
684     }
685 
686     /**
687      * @notice Function use to change the lower and upper bound of the compatible version st
688      * @param _boundType Type of bound
689      * @param _newVersion new version array
690      */
691     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
692         require(
693             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
694             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
695             "Must be a valid bound type"
696         );
697         require(_newVersion.length == 3);
698         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
699             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
700             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
701         }
702         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
703         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
704     }
705 
706     /**
707      * @notice Used to get the lower bound
708      * @return lower bound
709      */
710     function getLowerSTVersionBounds() external view returns(uint8[]) {
711         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
712     }
713 
714     /**
715      * @notice Used to get the upper bound
716      * @return upper bound
717      */
718     function getUpperSTVersionBounds() external view returns(uint8[]) {
719         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
720     }
721 
722     /**
723      * @notice Get the setup cost of the module
724      */
725     function getSetupCost() external view returns (uint256) {
726         return setupCost;
727     }
728 
729    /**
730     * @notice Get the name of the Module
731     */
732     function getName() public view returns(bytes32) {
733         return name;
734     }
735 
736 }
737 
738 /**
739  * @title Factory for deploying GeneralTransferManager module
740  */
741 contract GeneralTransferManagerFactory is ModuleFactory {
742 
743     address public logicContract;
744 
745     /**
746      * @notice Constructor
747      * @param _polyAddress Address of the polytoken
748      * @param _setupCost Setup cost of the module
749      * @param _usageCost Usage cost of the module
750      * @param _subscriptionCost Subscription cost of the module
751      * @param _logicContract Contract address that contains the logic related to `description`
752      */
753     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost, address _logicContract) public
754     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
755     {
756         require(_logicContract != address(0), "Invalid logic contract");
757         version = "2.1.0";
758         name = "GeneralTransferManager";
759         title = "General Transfer Manager";
760         description = "Manage transfers using a time based whitelist";
761         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
762         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
763         logicContract = _logicContract;
764     }
765 
766 
767      /**
768      * @notice Used to launch the Module with the help of factory
769      * @return address Contract address of the Module
770      */
771     function deploy(bytes /* _data */) external returns(address) {
772         if (setupCost > 0)
773             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
774         address generalTransferManager = new GeneralTransferManagerProxy(msg.sender, address(polyToken), logicContract);
775         /*solium-disable-next-line security/no-block-members*/
776         emit GenerateModuleFromFactory(address(generalTransferManager), getName(), address(this), msg.sender, setupCost, now);
777         return address(generalTransferManager);
778     }
779 
780 
781     /**
782      * @notice Type of the Module factory
783      */
784     function getTypes() external view returns(uint8[]) {
785         uint8[] memory res = new uint8[](1);
786         res[0] = 2;
787         return res;
788     }
789 
790     /**
791      * @notice Returns the instructions associated with the module
792      */
793     function getInstructions() external view returns(string) {
794         /*solium-disable-next-line max-len*/
795         return "Allows an issuer to maintain a time based whitelist of authorised token holders.Addresses are added via modifyWhitelist and take a fromTime (the time from which they can send tokens) and a toTime (the time from which they can receive tokens). There are additional flags, allowAllWhitelistIssuances, allowAllWhitelistTransfers & allowAllTransfers which allow you to set corresponding contract level behaviour. Init function takes no parameters.";
796     }
797 
798     /**
799      * @notice Get the tags related to the module factory
800      */
801     function getTags() public view returns(bytes32[]) {
802         bytes32[] memory availableTags = new bytes32[](2);
803         availableTags[0] = "General";
804         availableTags[1] = "Transfer Restriction";
805         return availableTags;
806     }
807 
808 
809 }