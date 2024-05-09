1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title It holds the storage variables related to ERC20DividendCheckpoint module
5  */
6 contract ERC20DividendCheckpointStorage {
7 
8     // Mapping to token address for each dividend
9     mapping (uint256 => address) public dividendTokens;
10 
11 }
12 
13 /**
14  * @title Holds the storage variable for the DividendCheckpoint modules (i.e ERC20, Ether)
15  * @dev abstract contract
16  */
17 contract DividendCheckpointStorage {
18 
19     // Address to which reclaimed dividends and withholding tax is sent
20     address public wallet;
21     uint256 public EXCLUDED_ADDRESS_LIMIT = 150;
22     bytes32 public constant DISTRIBUTE = "DISTRIBUTE";
23     bytes32 public constant MANAGE = "MANAGE";
24     bytes32 public constant CHECKPOINT = "CHECKPOINT";
25 
26     struct Dividend {
27         uint256 checkpointId;
28         uint256 created; // Time at which the dividend was created
29         uint256 maturity; // Time after which dividend can be claimed - set to 0 to bypass
30         uint256 expiry;  // Time until which dividend can be claimed - after this time any remaining amount can be withdrawn by issuer -
31                          // set to very high value to bypass
32         uint256 amount; // Dividend amount in WEI
33         uint256 claimedAmount; // Amount of dividend claimed so far
34         uint256 totalSupply; // Total supply at the associated checkpoint (avoids recalculating this)
35         bool reclaimed;  // True if expiry has passed and issuer has reclaimed remaining dividend
36         uint256 totalWithheld;
37         uint256 totalWithheldWithdrawn;
38         mapping (address => bool) claimed; // List of addresses which have claimed dividend
39         mapping (address => bool) dividendExcluded; // List of addresses which cannot claim dividends
40         mapping (address => uint256) withheld; // Amount of tax withheld from claim
41         bytes32 name; // Name/title - used for identification
42     }
43 
44     // List of all dividends
45     Dividend[] public dividends;
46 
47     // List of addresses which cannot claim dividends
48     address[] public excluded;
49 
50     // Mapping from address to withholding tax as a percentage * 10**16
51     mapping (address => uint256) public withholdingTax;
52 
53 }
54 
55 /**
56  * @title Proxy
57  * @dev Gives the possibility to delegate any call to a foreign implementation.
58  */
59 contract Proxy {
60 
61     /**
62     * @dev Tells the address of the implementation where every call will be delegated.
63     * @return address of the implementation to which it will be delegated
64     */
65     function _implementation() internal view returns (address);
66 
67     /**
68     * @dev Fallback function.
69     * Implemented entirely in `_fallback`.
70     */
71     function _fallback() internal {
72         _delegate(_implementation());
73     }
74 
75     /**
76     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
77     * This function will return whatever the implementation call returns
78     */
79     function _delegate(address implementation) internal {
80         /*solium-disable-next-line security/no-inline-assembly*/
81         assembly {
82             // Copy msg.data. We take full control of memory in this inline assembly
83             // block because it will not return to Solidity code. We overwrite the
84             // Solidity scratch pad at memory position 0.
85             calldatacopy(0, 0, calldatasize)
86 
87             // Call the implementation.
88             // out and outsize are 0 because we don't know the size yet.
89             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
90 
91             // Copy the returned data.
92             returndatacopy(0, 0, returndatasize)
93 
94             switch result
95             // delegatecall returns 0 on error.
96             case 0 { revert(0, returndatasize) }
97             default { return(0, returndatasize) }
98         }
99     }
100 
101     function () public payable {
102         _fallback();
103     }
104 }
105 
106 /**
107  * @title OwnedProxy
108  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
109  */
110 contract OwnedProxy is Proxy {
111 
112     // Owner of the contract
113     address private __owner;
114 
115     // Address of the current implementation
116     address internal __implementation;
117 
118     /**
119     * @dev Event to show ownership has been transferred
120     * @param _previousOwner representing the address of the previous owner
121     * @param _newOwner representing the address of the new owner
122     */
123     event ProxyOwnershipTransferred(address _previousOwner, address _newOwner);
124 
125     /**
126     * @dev Throws if called by any account other than the owner.
127     */
128     modifier ifOwner() {
129         if (msg.sender == _owner()) {
130             _;
131         } else {
132             _fallback();
133         }
134     }
135 
136     /**
137     * @dev the constructor sets the original owner of the contract to the sender account.
138     */
139     constructor() public {
140         _setOwner(msg.sender);
141     }
142 
143     /**
144     * @dev Tells the address of the owner
145     * @return the address of the owner
146     */
147     function _owner() internal view returns (address) {
148         return __owner;
149     }
150 
151     /**
152     * @dev Sets the address of the owner
153     */
154     function _setOwner(address _newOwner) internal {
155         require(_newOwner != address(0), "Address should not be 0x");
156         __owner = _newOwner;
157     }
158 
159     /**
160     * @notice Internal function to provide the address of the implementation contract
161     */
162     function _implementation() internal view returns (address) {
163         return __implementation;
164     }
165 
166     /**
167     * @dev Tells the address of the proxy owner
168     * @return the address of the proxy owner
169     */
170     function proxyOwner() external ifOwner returns (address) {
171         return _owner();
172     }
173 
174     /**
175     * @dev Tells the address of the current implementation
176     * @return address of the current implementation
177     */
178     function implementation() external ifOwner returns (address) {
179         return _implementation();
180     }
181 
182     /**
183     * @dev Allows the current owner to transfer control of the contract to a newOwner.
184     * @param _newOwner The address to transfer ownership to.
185     */
186     function transferProxyOwnership(address _newOwner) external ifOwner {
187         require(_newOwner != address(0), "Address should not be 0x");
188         emit ProxyOwnershipTransferred(_owner(), _newOwner);
189         _setOwner(_newOwner);
190     }
191 
192 }
193 
194 /**
195  * @title Utility contract to allow pausing and unpausing of certain functions
196  */
197 contract Pausable {
198 
199     event Pause(uint256 _timestammp);
200     event Unpause(uint256 _timestamp);
201 
202     bool public paused = false;
203 
204     /**
205     * @notice Modifier to make a function callable only when the contract is not paused.
206     */
207     modifier whenNotPaused() {
208         require(!paused, "Contract is paused");
209         _;
210     }
211 
212     /**
213     * @notice Modifier to make a function callable only when the contract is paused.
214     */
215     modifier whenPaused() {
216         require(paused, "Contract is not paused");
217         _;
218     }
219 
220    /**
221     * @notice Called by the owner to pause, triggers stopped state
222     */
223     function _pause() internal whenNotPaused {
224         paused = true;
225         /*solium-disable-next-line security/no-block-members*/
226         emit Pause(now);
227     }
228 
229     /**
230     * @notice Called by the owner to unpause, returns to normal state
231     */
232     function _unpause() internal whenPaused {
233         paused = false;
234         /*solium-disable-next-line security/no-block-members*/
235         emit Unpause(now);
236     }
237 
238 }
239 
240 /**
241  * @title ERC20 interface
242  * @dev see https://github.com/ethereum/EIPs/issues/20
243  */
244 interface IERC20 {
245     function decimals() external view returns (uint8);
246     function totalSupply() external view returns (uint256);
247     function balanceOf(address _owner) external view returns (uint256);
248     function allowance(address _owner, address _spender) external view returns (uint256);
249     function transfer(address _to, uint256 _value) external returns (bool);
250     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
251     function approve(address _spender, uint256 _value) external returns (bool);
252     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
253     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
254     event Transfer(address indexed from, address indexed to, uint256 value);
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 /**
259  * @title Storage for Module contract
260  * @notice Contract is abstract
261  */
262 contract ModuleStorage {
263 
264     /**
265      * @notice Constructor
266      * @param _securityToken Address of the security token
267      * @param _polyAddress Address of the polytoken
268      */
269     constructor (address _securityToken, address _polyAddress) public {
270         securityToken = _securityToken;
271         factory = msg.sender;
272         polyToken = IERC20(_polyAddress);
273     }
274     
275     address public factory;
276 
277     address public securityToken;
278 
279     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
280 
281     IERC20 public polyToken;
282 
283 }
284 
285 /**
286  * @title Transfer Manager module for core transfer validation functionality
287  */
288 contract ERC20DividendCheckpointProxy is ERC20DividendCheckpointStorage, DividendCheckpointStorage, ModuleStorage, Pausable, OwnedProxy {
289 
290     /**
291     * @notice Constructor
292     * @param _securityToken Address of the security token
293     * @param _polyAddress Address of the polytoken
294     * @param _implementation representing the address of the new implementation to be set
295     */
296     constructor (address _securityToken, address _polyAddress, address _implementation)
297     public
298     ModuleStorage(_securityToken, _polyAddress)
299     {
300         require(
301             _implementation != address(0),
302             "Implementation address should not be 0x"
303         );
304         __implementation = _implementation;
305     }
306 
307 }
308 
309 /**
310  * @title Utility contract for reusable code
311  */
312 library Util {
313 
314    /**
315     * @notice Changes a string to upper case
316     * @param _base String to change
317     */
318     function upper(string _base) internal pure returns (string) {
319         bytes memory _baseBytes = bytes(_base);
320         for (uint i = 0; i < _baseBytes.length; i++) {
321             bytes1 b1 = _baseBytes[i];
322             if (b1 >= 0x61 && b1 <= 0x7A) {
323                 b1 = bytes1(uint8(b1)-32);
324             }
325             _baseBytes[i] = b1;
326         }
327         return string(_baseBytes);
328     }
329 
330     /**
331      * @notice Changes the string into bytes32
332      * @param _source String that need to convert into bytes32
333      */
334     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
335     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
336         return bytesToBytes32(bytes(_source), 0);
337     }
338 
339     /**
340      * @notice Changes bytes into bytes32
341      * @param _b Bytes that need to convert into bytes32
342      * @param _offset Offset from which to begin conversion
343      */
344     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
345     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
346         bytes32 result;
347 
348         for (uint i = 0; i < _b.length; i++) {
349             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
350         }
351         return result;
352     }
353 
354     /**
355      * @notice Changes the bytes32 into string
356      * @param _source that need to convert into string
357      */
358     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
359         bytes memory bytesString = new bytes(32);
360         uint charCount = 0;
361         for (uint j = 0; j < 32; j++) {
362             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
363             if (char != 0) {
364                 bytesString[charCount] = char;
365                 charCount++;
366             }
367         }
368         bytes memory bytesStringTrimmed = new bytes(charCount);
369         for (j = 0; j < charCount; j++) {
370             bytesStringTrimmed[j] = bytesString[j];
371         }
372         return string(bytesStringTrimmed);
373     }
374 
375     /**
376      * @notice Gets function signature from _data
377      * @param _data Passed data
378      * @return bytes4 sig
379      */
380     function getSig(bytes _data) internal pure returns (bytes4 sig) {
381         uint len = _data.length < 4 ? _data.length : 4;
382         for (uint i = 0; i < len; i++) {
383             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
384         }
385     }
386 
387 
388 }
389 
390 interface IBoot {
391 
392     /**
393      * @notice This function returns the signature of configure function
394      * @return bytes4 Configure function signature
395      */
396     function getInitFunction() external pure returns(bytes4);
397 }
398 
399 /**
400  * @title Interface that every module factory contract should implement
401  */
402 interface IModuleFactory {
403 
404     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
405     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
406     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
407     event GenerateModuleFromFactory(
408         address _module,
409         bytes32 indexed _moduleName,
410         address indexed _moduleFactory,
411         address _creator,
412         uint256 _setupCost,
413         uint256 _timestamp
414     );
415     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
416 
417     //Should create an instance of the Module, or throw
418     function deploy(bytes _data) external returns(address);
419 
420     /**
421      * @notice Type of the Module factory
422      */
423     function getTypes() external view returns(uint8[]);
424 
425     /**
426      * @notice Get the name of the Module
427      */
428     function getName() external view returns(bytes32);
429 
430     /**
431      * @notice Returns the instructions associated with the module
432      */
433     function getInstructions() external view returns (string);
434 
435     /**
436      * @notice Get the tags related to the module factory
437      */
438     function getTags() external view returns (bytes32[]);
439 
440     /**
441      * @notice Used to change the setup fee
442      * @param _newSetupCost New setup fee
443      */
444     function changeFactorySetupFee(uint256 _newSetupCost) external;
445 
446     /**
447      * @notice Used to change the usage fee
448      * @param _newUsageCost New usage fee
449      */
450     function changeFactoryUsageFee(uint256 _newUsageCost) external;
451 
452     /**
453      * @notice Used to change the subscription fee
454      * @param _newSubscriptionCost New subscription fee
455      */
456     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
457 
458     /**
459      * @notice Function use to change the lower and upper bound of the compatible version st
460      * @param _boundType Type of bound
461      * @param _newVersion New version array
462      */
463     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
464 
465    /**
466      * @notice Get the setup cost of the module
467      */
468     function getSetupCost() external view returns (uint256);
469 
470     /**
471      * @notice Used to get the lower bound
472      * @return Lower bound
473      */
474     function getLowerSTVersionBounds() external view returns(uint8[]);
475 
476      /**
477      * @notice Used to get the upper bound
478      * @return Upper bound
479      */
480     function getUpperSTVersionBounds() external view returns(uint8[]);
481 
482 }
483 
484 /**
485  * @title Ownable
486  * @dev The Ownable contract has an owner address, and provides basic authorization control
487  * functions, this simplifies the implementation of "user permissions".
488  */
489 contract Ownable {
490   address public owner;
491 
492 
493   event OwnershipRenounced(address indexed previousOwner);
494   event OwnershipTransferred(
495     address indexed previousOwner,
496     address indexed newOwner
497   );
498 
499 
500   /**
501    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
502    * account.
503    */
504   constructor() public {
505     owner = msg.sender;
506   }
507 
508   /**
509    * @dev Throws if called by any account other than the owner.
510    */
511   modifier onlyOwner() {
512     require(msg.sender == owner);
513     _;
514   }
515 
516   /**
517    * @dev Allows the current owner to relinquish control of the contract.
518    */
519   function renounceOwnership() public onlyOwner {
520     emit OwnershipRenounced(owner);
521     owner = address(0);
522   }
523 
524   /**
525    * @dev Allows the current owner to transfer control of the contract to a newOwner.
526    * @param _newOwner The address to transfer ownership to.
527    */
528   function transferOwnership(address _newOwner) public onlyOwner {
529     _transferOwnership(_newOwner);
530   }
531 
532   /**
533    * @dev Transfers control of the contract to a newOwner.
534    * @param _newOwner The address to transfer ownership to.
535    */
536   function _transferOwnership(address _newOwner) internal {
537     require(_newOwner != address(0));
538     emit OwnershipTransferred(owner, _newOwner);
539     owner = _newOwner;
540   }
541 }
542 
543 /**
544  * @title Helper library use to compare or validate the semantic versions
545  */
546 
547 library VersionUtils {
548 
549     /**
550      * @notice This function is used to validate the version submitted
551      * @param _current Array holds the present version of ST
552      * @param _new Array holds the latest version of the ST
553      * @return bool
554      */
555     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
556         bool[] memory _temp = new bool[](_current.length);
557         uint8 counter = 0;
558         for (uint8 i = 0; i < _current.length; i++) {
559             if (_current[i] < _new[i])
560                 _temp[i] = true;
561             else
562                 _temp[i] = false;
563         }
564 
565         for (i = 0; i < _current.length; i++) {
566             if (i == 0) {
567                 if (_current[i] <= _new[i])
568                     if(_temp[0]) {
569                         counter = counter + 3;
570                         break;
571                     } else
572                         counter++;
573                 else
574                     return false;
575             } else {
576                 if (_temp[i-1])
577                     counter++;
578                 else if (_current[i] <= _new[i])
579                     counter++;
580                 else
581                     return false;
582             }
583         }
584         if (counter == _current.length)
585             return true;
586     }
587 
588     /**
589      * @notice Used to compare the lower bound with the latest version
590      * @param _version1 Array holds the lower bound of the version
591      * @param _version2 Array holds the latest version of the ST
592      * @return bool
593      */
594     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
595         require(_version1.length == _version2.length, "Input length mismatch");
596         uint counter = 0;
597         for (uint8 j = 0; j < _version1.length; j++) {
598             if (_version1[j] == 0)
599                 counter ++;
600         }
601         if (counter != _version1.length) {
602             counter = 0;
603             for (uint8 i = 0; i < _version1.length; i++) {
604                 if (_version2[i] > _version1[i])
605                     return true;
606                 else if (_version2[i] < _version1[i])
607                     return false;
608                 else
609                     counter++;
610             }
611             if (counter == _version1.length - 1)
612                 return true;
613             else
614                 return false;
615         } else
616             return true;
617     }
618 
619     /**
620      * @notice Used to compare the upper bound with the latest version
621      * @param _version1 Array holds the upper bound of the version
622      * @param _version2 Array holds the latest version of the ST
623      * @return bool
624      */
625     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
626         require(_version1.length == _version2.length, "Input length mismatch");
627         uint counter = 0;
628         for (uint8 j = 0; j < _version1.length; j++) {
629             if (_version1[j] == 0)
630                 counter ++;
631         }
632         if (counter != _version1.length) {
633             counter = 0;
634             for (uint8 i = 0; i < _version1.length; i++) {
635                 if (_version1[i] > _version2[i])
636                     return true;
637                 else if (_version1[i] < _version2[i])
638                     return false;
639                 else
640                     counter++;
641             }
642             if (counter == _version1.length - 1)
643                 return true;
644             else
645                 return false;
646         } else
647             return true;
648     }
649 
650 
651     /**
652      * @notice Used to pack the uint8[] array data into uint24 value
653      * @param _major Major version
654      * @param _minor Minor version
655      * @param _patch Patch version
656      */
657     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
658         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
659     }
660 
661     /**
662      * @notice Used to convert packed data into uint8 array
663      * @param _packedVersion Packed data
664      */
665     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
666         uint8[] memory _unpackVersion = new uint8[](3);
667         _unpackVersion[0] = uint8(_packedVersion >> 16);
668         _unpackVersion[1] = uint8(_packedVersion >> 8);
669         _unpackVersion[2] = uint8(_packedVersion);
670         return _unpackVersion;
671     }
672 
673 
674 }
675 
676 /**
677  * @title Interface that any module factory contract should implement
678  * @notice Contract is abstract
679  */
680 contract ModuleFactory is IModuleFactory, Ownable {
681 
682     IERC20 public polyToken;
683     uint256 public usageCost;
684     uint256 public monthlySubscriptionCost;
685 
686     uint256 public setupCost;
687     string public description;
688     string public version;
689     bytes32 public name;
690     string public title;
691 
692     // @notice Allow only two variables to be stored
693     // 1. lowerBound 
694     // 2. upperBound
695     // @dev (0.0.0 will act as the wildcard) 
696     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
697     mapping(string => uint24) compatibleSTVersionRange;
698 
699     /**
700      * @notice Constructor
701      * @param _polyAddress Address of the polytoken
702      */
703     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
704         polyToken = IERC20(_polyAddress);
705         setupCost = _setupCost;
706         usageCost = _usageCost;
707         monthlySubscriptionCost = _subscriptionCost;
708     }
709 
710     /**
711      * @notice Used to change the fee of the setup cost
712      * @param _newSetupCost new setup cost
713      */
714     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
715         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
716         setupCost = _newSetupCost;
717     }
718 
719     /**
720      * @notice Used to change the fee of the usage cost
721      * @param _newUsageCost new usage cost
722      */
723     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
724         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
725         usageCost = _newUsageCost;
726     }
727 
728     /**
729      * @notice Used to change the fee of the subscription cost
730      * @param _newSubscriptionCost new subscription cost
731      */
732     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
733         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
734         monthlySubscriptionCost = _newSubscriptionCost;
735 
736     }
737 
738     /**
739      * @notice Updates the title of the ModuleFactory
740      * @param _newTitle New Title that will replace the old one.
741      */
742     function changeTitle(string _newTitle) public onlyOwner {
743         require(bytes(_newTitle).length > 0, "Invalid title");
744         title = _newTitle;
745     }
746 
747     /**
748      * @notice Updates the description of the ModuleFactory
749      * @param _newDesc New description that will replace the old one.
750      */
751     function changeDescription(string _newDesc) public onlyOwner {
752         require(bytes(_newDesc).length > 0, "Invalid description");
753         description = _newDesc;
754     }
755 
756     /**
757      * @notice Updates the name of the ModuleFactory
758      * @param _newName New name that will replace the old one.
759      */
760     function changeName(bytes32 _newName) public onlyOwner {
761         require(_newName != bytes32(0),"Invalid name");
762         name = _newName;
763     }
764 
765     /**
766      * @notice Updates the version of the ModuleFactory
767      * @param _newVersion New name that will replace the old one.
768      */
769     function changeVersion(string _newVersion) public onlyOwner {
770         require(bytes(_newVersion).length > 0, "Invalid version");
771         version = _newVersion;
772     }
773 
774     /**
775      * @notice Function use to change the lower and upper bound of the compatible version st
776      * @param _boundType Type of bound
777      * @param _newVersion new version array
778      */
779     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
780         require(
781             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
782             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
783             "Must be a valid bound type"
784         );
785         require(_newVersion.length == 3);
786         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
787             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
788             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
789         }
790         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
791         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
792     }
793 
794     /**
795      * @notice Used to get the lower bound
796      * @return lower bound
797      */
798     function getLowerSTVersionBounds() external view returns(uint8[]) {
799         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
800     }
801 
802     /**
803      * @notice Used to get the upper bound
804      * @return upper bound
805      */
806     function getUpperSTVersionBounds() external view returns(uint8[]) {
807         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
808     }
809 
810     /**
811      * @notice Get the setup cost of the module
812      */
813     function getSetupCost() external view returns (uint256) {
814         return setupCost;
815     }
816 
817    /**
818     * @notice Get the name of the Module
819     */
820     function getName() public view returns(bytes32) {
821         return name;
822     }
823 
824 }
825 
826 /**
827  * @title Factory for deploying ERC20DividendCheckpoint module
828  */
829 contract ERC20DividendCheckpointFactory is ModuleFactory {
830 
831     address public logicContract;
832 
833     /**
834      * @notice Constructor
835      * @param _polyAddress Address of the polytoken
836      * @param _setupCost Setup cost of the module
837      * @param _usageCost Usage cost of the module
838      * @param _subscriptionCost Subscription cost of the module
839      * @param _logicContract Contract address that contains the logic related to `description`
840      */
841     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost, address _logicContract) public
842     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
843     {
844         require(_logicContract != address(0), "Invalid logic contract");
845         version = "2.1.1";
846         name = "ERC20DividendCheckpoint";
847         title = "ERC20 Dividend Checkpoint";
848         description = "Create ERC20 dividends for token holders at a specific checkpoint";
849         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
850         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
851         logicContract = _logicContract;
852     }
853 
854     /**
855      * @notice Used to launch the Module with the help of factory
856      * @return Address Contract address of the Module
857      */
858     function deploy(bytes _data) external returns(address) {
859         if (setupCost > 0)
860             require(polyToken.transferFrom(msg.sender, owner, setupCost), "insufficent allowance");
861         address erc20DividendCheckpoint = new ERC20DividendCheckpointProxy(msg.sender, address(polyToken), logicContract);
862         //Checks that _data is valid (not calling anything it shouldn't)
863         require(Util.getSig(_data) == IBoot(erc20DividendCheckpoint).getInitFunction(), "Invalid data");
864         /*solium-disable-next-line security/no-low-level-calls*/
865         require(erc20DividendCheckpoint.call(_data), "Unsuccessfull call");
866         /*solium-disable-next-line security/no-block-members*/
867         emit GenerateModuleFromFactory(erc20DividendCheckpoint, getName(), address(this), msg.sender, setupCost, now);
868         return erc20DividendCheckpoint;
869     }
870 
871     /**
872      * @notice Type of the Module factory
873      */
874     function getTypes() external view returns(uint8[]) {
875         uint8[] memory res = new uint8[](1);
876         res[0] = 4;
877         return res;
878     }
879 
880     /**
881      * @notice Returns the instructions associated with the module
882      */
883     function getInstructions() external view returns(string) {
884         return "Create ERC20 dividend to be paid out to token holders based on their balances at dividend creation time";
885     }
886 
887     /**
888      * @notice Get the tags related to the module factory
889      */
890     function getTags() external view returns(bytes32[]) {
891         bytes32[] memory availableTags = new bytes32[](3);
892         availableTags[0] = "ERC20";
893         availableTags[1] = "Dividend";
894         availableTags[2] = "Checkpoint";
895         return availableTags;
896     }
897 }