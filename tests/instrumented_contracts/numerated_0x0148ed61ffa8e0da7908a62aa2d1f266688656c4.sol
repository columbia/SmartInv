1 pragma solidity ^0.4.24;
2 
3 interface IBoot {
4 
5     /**
6      * @notice This function returns the signature of configure function
7      * @return bytes4 Configure function signature
8      */
9     function getInitFunction() external pure returns(bytes4);
10 }
11 
12 /**
13  * @title ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/20
15  */
16 interface IERC20 {
17     function decimals() external view returns (uint8);
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address _owner) external view returns (uint256);
20     function allowance(address _owner, address _spender) external view returns (uint256);
21     function transfer(address _to, uint256 _value) external returns (bool);
22     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
23     function approve(address _spender, uint256 _value) external returns (bool);
24     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
25     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title Contract used to store layout for the USDTieredSTO storage
32  */
33 contract USDTieredSTOStorage {
34 
35     /////////////
36     // Storage //
37     /////////////
38     struct Tier {
39         // NB rates mentioned below are actually price and are used like price in the logic.
40         // How many token units a buyer gets per USD in this tier (multiplied by 10**18)
41         uint256 rate;
42 
43         // How many token units a buyer gets per USD in this tier (multiplied by 10**18) when investing in POLY up to tokensDiscountPoly
44         uint256 rateDiscountPoly;
45 
46         // How many tokens are available in this tier (relative to totalSupply)
47         uint256 tokenTotal;
48 
49         // How many token units are available in this tier (relative to totalSupply) at the ratePerTierDiscountPoly rate
50         uint256 tokensDiscountPoly;
51 
52         // How many tokens have been minted in this tier (relative to totalSupply)
53         uint256 mintedTotal;
54 
55         // How many tokens have been minted in this tier (relative to totalSupply) for each fund raise type
56         mapping (uint8 => uint256) minted;
57 
58         // How many tokens have been minted in this tier (relative to totalSupply) at discounted POLY rate
59         uint256 mintedDiscountPoly;
60     }
61 
62     struct Investor {
63         // Whether investor is accredited (0 = non-accredited, 1 = accredited)
64         uint8 accredited;
65         // Whether we have seen the investor before (already added to investors list)
66         uint8 seen;
67         // Overrides for default limit in USD for non-accredited investors multiplied by 10**18 (0 = no override)
68         uint256 nonAccreditedLimitUSDOverride;
69     }
70 
71     mapping (bytes32 => mapping (bytes32 => string)) oracleKeys;
72 
73     // Determine whether users can invest on behalf of a beneficiary
74     bool public allowBeneficialInvestments = false;
75 
76     // Whether or not the STO has been finalized
77     bool public isFinalized;
78 
79     // Address of issuer reserve wallet for unsold tokens
80     address public reserveWallet;
81 
82     // List of stable coin addresses
83     address[] public usdTokens;
84 
85     // Current tier
86     uint256 public currentTier;
87 
88     // Amount of USD funds raised
89     uint256 public fundsRaisedUSD;
90 
91     // Amount of stable coins raised
92     mapping (address => uint256) public stableCoinsRaised;
93 
94     // Amount in USD invested by each address
95     mapping (address => uint256) public investorInvestedUSD;
96 
97     // Amount in fund raise type invested by each investor
98     mapping (address => mapping (uint8 => uint256)) public investorInvested;
99 
100     // Accredited & non-accredited investor data
101     mapping (address => Investor) public investors;
102 
103     // List of active stable coin addresses
104     mapping (address => bool) public usdTokenEnabled;
105 
106     // List of all addresses that have been added as accredited or non-accredited without
107     // the default limit
108     address[] public investorsList;
109 
110     // Default limit in USD for non-accredited investors multiplied by 10**18
111     uint256 public nonAccreditedLimitUSD;
112 
113     // Minimum investable amount in USD
114     uint256 public minimumInvestmentUSD;
115 
116     // Final amount of tokens returned to issuer
117     uint256 public finalAmountReturned;
118 
119     // Array of Tiers
120     Tier[] public tiers;
121 
122 }
123 
124 /**
125  * @title Proxy
126  * @dev Gives the possibility to delegate any call to a foreign implementation.
127  */
128 contract Proxy {
129 
130     /**
131     * @dev Tells the address of the implementation where every call will be delegated.
132     * @return address of the implementation to which it will be delegated
133     */
134     function _implementation() internal view returns (address);
135 
136     /**
137     * @dev Fallback function.
138     * Implemented entirely in `_fallback`.
139     */
140     function _fallback() internal {
141         _delegate(_implementation());
142     }
143 
144     /**
145     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
146     * This function will return whatever the implementation call returns
147     */
148     function _delegate(address implementation) internal {
149         /*solium-disable-next-line security/no-inline-assembly*/
150         assembly {
151             // Copy msg.data. We take full control of memory in this inline assembly
152             // block because it will not return to Solidity code. We overwrite the
153             // Solidity scratch pad at memory position 0.
154             calldatacopy(0, 0, calldatasize)
155 
156             // Call the implementation.
157             // out and outsize are 0 because we don't know the size yet.
158             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
159 
160             // Copy the returned data.
161             returndatacopy(0, 0, returndatasize)
162 
163             switch result
164             // delegatecall returns 0 on error.
165             case 0 { revert(0, returndatasize) }
166             default { return(0, returndatasize) }
167         }
168     }
169 
170     function () public payable {
171         _fallback();
172     }
173 }
174 
175 /**
176  * @title OwnedProxy
177  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
178  */
179 contract OwnedProxy is Proxy {
180 
181     // Owner of the contract
182     address private __owner;
183 
184     // Address of the current implementation
185     address internal __implementation;
186 
187     /**
188     * @dev Event to show ownership has been transferred
189     * @param _previousOwner representing the address of the previous owner
190     * @param _newOwner representing the address of the new owner
191     */
192     event ProxyOwnershipTransferred(address _previousOwner, address _newOwner);
193 
194     /**
195     * @dev Throws if called by any account other than the owner.
196     */
197     modifier ifOwner() {
198         if (msg.sender == _owner()) {
199             _;
200         } else {
201             _fallback();
202         }
203     }
204 
205     /**
206     * @dev the constructor sets the original owner of the contract to the sender account.
207     */
208     constructor() public {
209         _setOwner(msg.sender);
210     }
211 
212     /**
213     * @dev Tells the address of the owner
214     * @return the address of the owner
215     */
216     function _owner() internal view returns (address) {
217         return __owner;
218     }
219 
220     /**
221     * @dev Sets the address of the owner
222     */
223     function _setOwner(address _newOwner) internal {
224         require(_newOwner != address(0), "Address should not be 0x");
225         __owner = _newOwner;
226     }
227 
228     /**
229     * @notice Internal function to provide the address of the implementation contract
230     */
231     function _implementation() internal view returns (address) {
232         return __implementation;
233     }
234 
235     /**
236     * @dev Tells the address of the proxy owner
237     * @return the address of the proxy owner
238     */
239     function proxyOwner() external ifOwner returns (address) {
240         return _owner();
241     }
242 
243     /**
244     * @dev Tells the address of the current implementation
245     * @return address of the current implementation
246     */
247     function implementation() external ifOwner returns (address) {
248         return _implementation();
249     }
250 
251     /**
252     * @dev Allows the current owner to transfer control of the contract to a newOwner.
253     * @param _newOwner The address to transfer ownership to.
254     */
255     function transferProxyOwnership(address _newOwner) external ifOwner {
256         require(_newOwner != address(0), "Address should not be 0x");
257         emit ProxyOwnershipTransferred(_owner(), _newOwner);
258         _setOwner(_newOwner);
259     }
260 
261 }
262 
263 /**
264  * @title Utility contract to allow pausing and unpausing of certain functions
265  */
266 contract Pausable {
267 
268     event Pause(uint256 _timestammp);
269     event Unpause(uint256 _timestamp);
270 
271     bool public paused = false;
272 
273     /**
274     * @notice Modifier to make a function callable only when the contract is not paused.
275     */
276     modifier whenNotPaused() {
277         require(!paused, "Contract is paused");
278         _;
279     }
280 
281     /**
282     * @notice Modifier to make a function callable only when the contract is paused.
283     */
284     modifier whenPaused() {
285         require(paused, "Contract is not paused");
286         _;
287     }
288 
289    /**
290     * @notice Called by the owner to pause, triggers stopped state
291     */
292     function _pause() internal whenNotPaused {
293         paused = true;
294         /*solium-disable-next-line security/no-block-members*/
295         emit Pause(now);
296     }
297 
298     /**
299     * @notice Called by the owner to unpause, returns to normal state
300     */
301     function _unpause() internal whenPaused {
302         paused = false;
303         /*solium-disable-next-line security/no-block-members*/
304         emit Unpause(now);
305     }
306 
307 }
308 
309 /**
310  * @title Helps contracts guard agains reentrancy attacks.
311  * @author Remco Bloemen <remco@2π.com>
312  * @notice If you mark a function `nonReentrant`, you should also
313  * mark it `external`.
314  */
315 contract ReentrancyGuard {
316 
317   /**
318    * @dev We use a single lock for the whole contract.
319    */
320   bool private reentrancyLock = false;
321 
322   /**
323    * @dev Prevents a contract from calling itself, directly or indirectly.
324    * @notice If you mark a function `nonReentrant`, you should also
325    * mark it `external`. Calling one nonReentrant function from
326    * another is not supported. Instead, you can implement a
327    * `private` function doing the actual work, and a `external`
328    * wrapper marked as `nonReentrant`.
329    */
330   modifier nonReentrant() {
331     require(!reentrancyLock);
332     reentrancyLock = true;
333     _;
334     reentrancyLock = false;
335   }
336 
337 }
338 
339 /**
340  * @title Storage layout for the STO contract
341  */
342 contract STOStorage {
343 
344     mapping (uint8 => bool) public fundRaiseTypes;
345     mapping (uint8 => uint256) public fundsRaised;
346 
347     // Start time of the STO
348     uint256 public startTime;
349     // End time of the STO
350     uint256 public endTime;
351     // Time STO was paused
352     uint256 public pausedTime;
353     // Number of individual investors
354     uint256 public investorCount;
355     // Address where ETH & POLY funds are delivered
356     address public wallet;
357      // Final amount of tokens sold
358     uint256 public totalTokensSold;
359 
360 }
361 
362 /**
363  * @title Storage for Module contract
364  * @notice Contract is abstract
365  */
366 contract ModuleStorage {
367 
368     /**
369      * @notice Constructor
370      * @param _securityToken Address of the security token
371      * @param _polyAddress Address of the polytoken
372      */
373     constructor (address _securityToken, address _polyAddress) public {
374         securityToken = _securityToken;
375         factory = msg.sender;
376         polyToken = IERC20(_polyAddress);
377     }
378     
379     address public factory;
380 
381     address public securityToken;
382 
383     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
384 
385     IERC20 public polyToken;
386 
387 }
388 
389 /**
390  * @title USDTiered STO module Proxy
391  */
392 contract USDTieredSTOProxy is USDTieredSTOStorage, STOStorage, ModuleStorage, Pausable, ReentrancyGuard, OwnedProxy {
393 
394     /**
395     * @notice Constructor
396     * @param _securityToken Address of the security token
397     * @param _polyAddress Address of the polytoken
398     * @param _implementation representing the address of the new implementation to be set
399     */
400     constructor (address _securityToken, address _polyAddress, address _implementation)
401     public
402     ModuleStorage(_securityToken, _polyAddress)
403     {
404         require(
405             _implementation != address(0),
406             "Implementation address should not be 0x"
407         );
408         __implementation = _implementation;
409     }
410 
411 }
412 
413 /**
414  * @title Interface that every module factory contract should implement
415  */
416 interface IModuleFactory {
417 
418     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
419     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
420     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
421     event GenerateModuleFromFactory(
422         address _module,
423         bytes32 indexed _moduleName,
424         address indexed _moduleFactory,
425         address _creator,
426         uint256 _setupCost,
427         uint256 _timestamp
428     );
429     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
430 
431     //Should create an instance of the Module, or throw
432     function deploy(bytes _data) external returns(address);
433 
434     /**
435      * @notice Type of the Module factory
436      */
437     function getTypes() external view returns(uint8[]);
438 
439     /**
440      * @notice Get the name of the Module
441      */
442     function getName() external view returns(bytes32);
443 
444     /**
445      * @notice Returns the instructions associated with the module
446      */
447     function getInstructions() external view returns (string);
448 
449     /**
450      * @notice Get the tags related to the module factory
451      */
452     function getTags() external view returns (bytes32[]);
453 
454     /**
455      * @notice Used to change the setup fee
456      * @param _newSetupCost New setup fee
457      */
458     function changeFactorySetupFee(uint256 _newSetupCost) external;
459 
460     /**
461      * @notice Used to change the usage fee
462      * @param _newUsageCost New usage fee
463      */
464     function changeFactoryUsageFee(uint256 _newUsageCost) external;
465 
466     /**
467      * @notice Used to change the subscription fee
468      * @param _newSubscriptionCost New subscription fee
469      */
470     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
471 
472     /**
473      * @notice Function use to change the lower and upper bound of the compatible version st
474      * @param _boundType Type of bound
475      * @param _newVersion New version array
476      */
477     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
478 
479    /**
480      * @notice Get the setup cost of the module
481      */
482     function getSetupCost() external view returns (uint256);
483 
484     /**
485      * @notice Used to get the lower bound
486      * @return Lower bound
487      */
488     function getLowerSTVersionBounds() external view returns(uint8[]);
489 
490      /**
491      * @notice Used to get the upper bound
492      * @return Upper bound
493      */
494     function getUpperSTVersionBounds() external view returns(uint8[]);
495 
496 }
497 
498 /**
499  * @title Ownable
500  * @dev The Ownable contract has an owner address, and provides basic authorization control
501  * functions, this simplifies the implementation of "user permissions".
502  */
503 contract Ownable {
504   address public owner;
505 
506 
507   event OwnershipRenounced(address indexed previousOwner);
508   event OwnershipTransferred(
509     address indexed previousOwner,
510     address indexed newOwner
511   );
512 
513 
514   /**
515    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
516    * account.
517    */
518   constructor() public {
519     owner = msg.sender;
520   }
521 
522   /**
523    * @dev Throws if called by any account other than the owner.
524    */
525   modifier onlyOwner() {
526     require(msg.sender == owner);
527     _;
528   }
529 
530   /**
531    * @dev Allows the current owner to relinquish control of the contract.
532    */
533   function renounceOwnership() public onlyOwner {
534     emit OwnershipRenounced(owner);
535     owner = address(0);
536   }
537 
538   /**
539    * @dev Allows the current owner to transfer control of the contract to a newOwner.
540    * @param _newOwner The address to transfer ownership to.
541    */
542   function transferOwnership(address _newOwner) public onlyOwner {
543     _transferOwnership(_newOwner);
544   }
545 
546   /**
547    * @dev Transfers control of the contract to a newOwner.
548    * @param _newOwner The address to transfer ownership to.
549    */
550   function _transferOwnership(address _newOwner) internal {
551     require(_newOwner != address(0));
552     emit OwnershipTransferred(owner, _newOwner);
553     owner = _newOwner;
554   }
555 }
556 
557 /**
558  * @title Helper library use to compare or validate the semantic versions
559  */
560 
561 library VersionUtils {
562 
563     /**
564      * @notice This function is used to validate the version submitted
565      * @param _current Array holds the present version of ST
566      * @param _new Array holds the latest version of the ST
567      * @return bool
568      */
569     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
570         bool[] memory _temp = new bool[](_current.length);
571         uint8 counter = 0;
572         for (uint8 i = 0; i < _current.length; i++) {
573             if (_current[i] < _new[i])
574                 _temp[i] = true;
575             else
576                 _temp[i] = false;
577         }
578 
579         for (i = 0; i < _current.length; i++) {
580             if (i == 0) {
581                 if (_current[i] <= _new[i])
582                     if(_temp[0]) {
583                         counter = counter + 3;
584                         break;
585                     } else
586                         counter++;
587                 else
588                     return false;
589             } else {
590                 if (_temp[i-1])
591                     counter++;
592                 else if (_current[i] <= _new[i])
593                     counter++;
594                 else
595                     return false;
596             }
597         }
598         if (counter == _current.length)
599             return true;
600     }
601 
602     /**
603      * @notice Used to compare the lower bound with the latest version
604      * @param _version1 Array holds the lower bound of the version
605      * @param _version2 Array holds the latest version of the ST
606      * @return bool
607      */
608     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
609         require(_version1.length == _version2.length, "Input length mismatch");
610         uint counter = 0;
611         for (uint8 j = 0; j < _version1.length; j++) {
612             if (_version1[j] == 0)
613                 counter ++;
614         }
615         if (counter != _version1.length) {
616             counter = 0;
617             for (uint8 i = 0; i < _version1.length; i++) {
618                 if (_version2[i] > _version1[i])
619                     return true;
620                 else if (_version2[i] < _version1[i])
621                     return false;
622                 else
623                     counter++;
624             }
625             if (counter == _version1.length - 1)
626                 return true;
627             else
628                 return false;
629         } else
630             return true;
631     }
632 
633     /**
634      * @notice Used to compare the upper bound with the latest version
635      * @param _version1 Array holds the upper bound of the version
636      * @param _version2 Array holds the latest version of the ST
637      * @return bool
638      */
639     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
640         require(_version1.length == _version2.length, "Input length mismatch");
641         uint counter = 0;
642         for (uint8 j = 0; j < _version1.length; j++) {
643             if (_version1[j] == 0)
644                 counter ++;
645         }
646         if (counter != _version1.length) {
647             counter = 0;
648             for (uint8 i = 0; i < _version1.length; i++) {
649                 if (_version1[i] > _version2[i])
650                     return true;
651                 else if (_version1[i] < _version2[i])
652                     return false;
653                 else
654                     counter++;
655             }
656             if (counter == _version1.length - 1)
657                 return true;
658             else
659                 return false;
660         } else
661             return true;
662     }
663 
664 
665     /**
666      * @notice Used to pack the uint8[] array data into uint24 value
667      * @param _major Major version
668      * @param _minor Minor version
669      * @param _patch Patch version
670      */
671     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
672         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
673     }
674 
675     /**
676      * @notice Used to convert packed data into uint8 array
677      * @param _packedVersion Packed data
678      */
679     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
680         uint8[] memory _unpackVersion = new uint8[](3);
681         _unpackVersion[0] = uint8(_packedVersion >> 16);
682         _unpackVersion[1] = uint8(_packedVersion >> 8);
683         _unpackVersion[2] = uint8(_packedVersion);
684         return _unpackVersion;
685     }
686 
687 
688 }
689 
690 /**
691  * @title Interface that any module factory contract should implement
692  * @notice Contract is abstract
693  */
694 contract ModuleFactory is IModuleFactory, Ownable {
695 
696     IERC20 public polyToken;
697     uint256 public usageCost;
698     uint256 public monthlySubscriptionCost;
699 
700     uint256 public setupCost;
701     string public description;
702     string public version;
703     bytes32 public name;
704     string public title;
705 
706     // @notice Allow only two variables to be stored
707     // 1. lowerBound 
708     // 2. upperBound
709     // @dev (0.0.0 will act as the wildcard) 
710     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
711     mapping(string => uint24) compatibleSTVersionRange;
712 
713     /**
714      * @notice Constructor
715      * @param _polyAddress Address of the polytoken
716      */
717     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
718         polyToken = IERC20(_polyAddress);
719         setupCost = _setupCost;
720         usageCost = _usageCost;
721         monthlySubscriptionCost = _subscriptionCost;
722     }
723 
724     /**
725      * @notice Used to change the fee of the setup cost
726      * @param _newSetupCost new setup cost
727      */
728     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
729         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
730         setupCost = _newSetupCost;
731     }
732 
733     /**
734      * @notice Used to change the fee of the usage cost
735      * @param _newUsageCost new usage cost
736      */
737     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
738         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
739         usageCost = _newUsageCost;
740     }
741 
742     /**
743      * @notice Used to change the fee of the subscription cost
744      * @param _newSubscriptionCost new subscription cost
745      */
746     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
747         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
748         monthlySubscriptionCost = _newSubscriptionCost;
749 
750     }
751 
752     /**
753      * @notice Updates the title of the ModuleFactory
754      * @param _newTitle New Title that will replace the old one.
755      */
756     function changeTitle(string _newTitle) public onlyOwner {
757         require(bytes(_newTitle).length > 0, "Invalid title");
758         title = _newTitle;
759     }
760 
761     /**
762      * @notice Updates the description of the ModuleFactory
763      * @param _newDesc New description that will replace the old one.
764      */
765     function changeDescription(string _newDesc) public onlyOwner {
766         require(bytes(_newDesc).length > 0, "Invalid description");
767         description = _newDesc;
768     }
769 
770     /**
771      * @notice Updates the name of the ModuleFactory
772      * @param _newName New name that will replace the old one.
773      */
774     function changeName(bytes32 _newName) public onlyOwner {
775         require(_newName != bytes32(0),"Invalid name");
776         name = _newName;
777     }
778 
779     /**
780      * @notice Updates the version of the ModuleFactory
781      * @param _newVersion New name that will replace the old one.
782      */
783     function changeVersion(string _newVersion) public onlyOwner {
784         require(bytes(_newVersion).length > 0, "Invalid version");
785         version = _newVersion;
786     }
787 
788     /**
789      * @notice Function use to change the lower and upper bound of the compatible version st
790      * @param _boundType Type of bound
791      * @param _newVersion new version array
792      */
793     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
794         require(
795             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
796             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
797             "Must be a valid bound type"
798         );
799         require(_newVersion.length == 3);
800         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
801             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
802             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
803         }
804         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
805         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
806     }
807 
808     /**
809      * @notice Used to get the lower bound
810      * @return lower bound
811      */
812     function getLowerSTVersionBounds() external view returns(uint8[]) {
813         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
814     }
815 
816     /**
817      * @notice Used to get the upper bound
818      * @return upper bound
819      */
820     function getUpperSTVersionBounds() external view returns(uint8[]) {
821         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
822     }
823 
824     /**
825      * @notice Get the setup cost of the module
826      */
827     function getSetupCost() external view returns (uint256) {
828         return setupCost;
829     }
830 
831    /**
832     * @notice Get the name of the Module
833     */
834     function getName() public view returns(bytes32) {
835         return name;
836     }
837 
838 }
839 
840 /**
841  * @title Utility contract for reusable code
842  */
843 library Util {
844 
845    /**
846     * @notice Changes a string to upper case
847     * @param _base String to change
848     */
849     function upper(string _base) internal pure returns (string) {
850         bytes memory _baseBytes = bytes(_base);
851         for (uint i = 0; i < _baseBytes.length; i++) {
852             bytes1 b1 = _baseBytes[i];
853             if (b1 >= 0x61 && b1 <= 0x7A) {
854                 b1 = bytes1(uint8(b1)-32);
855             }
856             _baseBytes[i] = b1;
857         }
858         return string(_baseBytes);
859     }
860 
861     /**
862      * @notice Changes the string into bytes32
863      * @param _source String that need to convert into bytes32
864      */
865     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
866     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
867         return bytesToBytes32(bytes(_source), 0);
868     }
869 
870     /**
871      * @notice Changes bytes into bytes32
872      * @param _b Bytes that need to convert into bytes32
873      * @param _offset Offset from which to begin conversion
874      */
875     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
876     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
877         bytes32 result;
878 
879         for (uint i = 0; i < _b.length; i++) {
880             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
881         }
882         return result;
883     }
884 
885     /**
886      * @notice Changes the bytes32 into string
887      * @param _source that need to convert into string
888      */
889     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
890         bytes memory bytesString = new bytes(32);
891         uint charCount = 0;
892         for (uint j = 0; j < 32; j++) {
893             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
894             if (char != 0) {
895                 bytesString[charCount] = char;
896                 charCount++;
897             }
898         }
899         bytes memory bytesStringTrimmed = new bytes(charCount);
900         for (j = 0; j < charCount; j++) {
901             bytesStringTrimmed[j] = bytesString[j];
902         }
903         return string(bytesStringTrimmed);
904     }
905 
906     /**
907      * @notice Gets function signature from _data
908      * @param _data Passed data
909      * @return bytes4 sig
910      */
911     function getSig(bytes _data) internal pure returns (bytes4 sig) {
912         uint len = _data.length < 4 ? _data.length : 4;
913         for (uint i = 0; i < len; i++) {
914             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
915         }
916     }
917 
918 
919 }
920 
921 /**
922  * @title Factory for deploying CappedSTO module
923  */
924 contract USDTieredSTOFactory is ModuleFactory {
925 
926     address public logicContract;
927 
928     /**
929      * @notice Constructor
930      * @param _polyAddress Address of the polytoken
931      */
932     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost, address _logicContract) public
933     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
934     {
935         require(_logicContract != address(0), "0x address is not allowed");
936         logicContract = _logicContract;
937         version = "2.1.0";
938         name = "USDTieredSTO";
939         title = "USD Tiered STO";
940         /*solium-disable-next-line max-len*/
941         description = "It allows both accredited and non-accredited investors to contribute into the STO. Non-accredited investors will be capped at a maximum investment limit (as a default or specific to their jurisdiction). Tokens will be sold according to tiers sequentially & each tier has its own price and volume of tokens to sell. Upon receipt of funds (ETH, POLY or DAI), security tokens will automatically transfer to investor’s wallet address";
942         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
943         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
944     }
945 
946      /**
947      * @notice Used to launch the Module with the help of factory
948      * @return address Contract address of the Module
949      */
950     function deploy(bytes _data) external returns(address) {
951         if(setupCost > 0)
952             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Sufficent Allowance is not provided");
953         //Check valid bytes - can only call module init function
954         address usdTieredSTO = new USDTieredSTOProxy(msg.sender, address(polyToken), logicContract);
955         //Checks that _data is valid (not calling anything it shouldn't)
956         require(Util.getSig(_data) == IBoot(usdTieredSTO).getInitFunction(), "Invalid data");
957         /*solium-disable-next-line security/no-low-level-calls*/
958         require(usdTieredSTO.call(_data), "Unsuccessfull call");
959         /*solium-disable-next-line security/no-block-members*/
960         emit GenerateModuleFromFactory(usdTieredSTO, getName(), address(this), msg.sender, setupCost, now);
961         return usdTieredSTO;
962     }
963 
964     /**
965      * @notice Type of the Module factory
966      */
967     function getTypes() external view returns(uint8[]) {
968         uint8[] memory res = new uint8[](1);
969         res[0] = 3;
970         return res;
971     }
972 
973     /**
974      * @notice Returns the instructions associated with the module
975      */
976     function getInstructions() external view returns(string) {
977         return "Initialises a USD tiered STO.";
978     }
979 
980     /**
981      * @notice Get the tags related to the module factory
982      */
983     function getTags() external view returns(bytes32[]) {
984         bytes32[] memory availableTags = new bytes32[](4);
985         availableTags[0] = "USD";
986         availableTags[1] = "Tiered";
987         availableTags[2] = "POLY";
988         availableTags[3] = "ETH";
989         return availableTags;
990     }
991 
992 }