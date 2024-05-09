1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Interface for security token proxy deployment
5  */
6 interface IUSDTieredSTOProxy {
7 
8    /**
9      * @notice Deploys the STO.
10      * @param _securityToken Contract address of the securityToken
11      * @param _polyAddress Contract address of the PolyToken
12      * @param _factoryAddress Contract address of the factory 
13      * @return address Address of the deployed STO
14      */
15     function deploySTO(address _securityToken, address _polyAddress, address _factoryAddress) external returns (address);
16     
17      /**
18      * @notice Used to get the init function signature
19      * @param _contractAddress Address of the STO contract
20      * @return bytes4
21      */
22     function getInitFunction(address _contractAddress) external returns (bytes4);
23 
24 }
25 
26 /**
27  * @title ERC20 interface
28  * @dev see https://github.com/ethereum/EIPs/issues/20
29  */
30 interface IERC20 {
31     function decimals() external view returns (uint8);
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address _owner) external view returns (uint256);
34     function allowance(address _owner, address _spender) external view returns (uint256);
35     function transfer(address _to, uint256 _value) external returns (bool);
36     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
37     function approve(address _spender, uint256 _value) external returns (bool);
38     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
39     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 /**
45  * @title Interface that every module factory contract should implement
46  */
47 interface IModuleFactory {
48 
49     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
50     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
51     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
52     event GenerateModuleFromFactory(
53         address _module,
54         bytes32 indexed _moduleName,
55         address indexed _moduleFactory,
56         address _creator,
57         uint256 _setupCost,
58         uint256 _timestamp
59     );
60     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
61 
62     //Should create an instance of the Module, or throw
63     function deploy(bytes _data) external returns(address);
64 
65     /**
66      * @notice Type of the Module factory
67      */
68     function getTypes() external view returns(uint8[]);
69 
70     /**
71      * @notice Get the name of the Module
72      */
73     function getName() external view returns(bytes32);
74 
75     /**
76      * @notice Returns the instructions associated with the module
77      */
78     function getInstructions() external view returns (string);
79 
80     /**
81      * @notice Get the tags related to the module factory
82      */
83     function getTags() external view returns (bytes32[]);
84 
85     /**
86      * @notice Used to change the setup fee
87      * @param _newSetupCost New setup fee
88      */
89     function changeFactorySetupFee(uint256 _newSetupCost) external;
90 
91     /**
92      * @notice Used to change the usage fee
93      * @param _newUsageCost New usage fee
94      */
95     function changeFactoryUsageFee(uint256 _newUsageCost) external;
96 
97     /**
98      * @notice Used to change the subscription fee
99      * @param _newSubscriptionCost New subscription fee
100      */
101     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
102 
103     /**
104      * @notice Function use to change the lower and upper bound of the compatible version st
105      * @param _boundType Type of bound
106      * @param _newVersion New version array
107      */
108     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
109 
110    /**
111      * @notice Get the setup cost of the module
112      */
113     function getSetupCost() external view returns (uint256);
114 
115     /**
116      * @notice Used to get the lower bound
117      * @return Lower bound
118      */
119     function getLowerSTVersionBounds() external view returns(uint8[]);
120 
121      /**
122      * @notice Used to get the upper bound
123      * @return Upper bound
124      */
125     function getUpperSTVersionBounds() external view returns(uint8[]);
126 
127 }
128 
129 /**
130  * @title Ownable
131  * @dev The Ownable contract has an owner address, and provides basic authorization control
132  * functions, this simplifies the implementation of "user permissions".
133  */
134 contract Ownable {
135   address public owner;
136 
137 
138   event OwnershipRenounced(address indexed previousOwner);
139   event OwnershipTransferred(
140     address indexed previousOwner,
141     address indexed newOwner
142   );
143 
144 
145   /**
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   constructor() public {
150     owner = msg.sender;
151   }
152 
153   /**
154    * @dev Throws if called by any account other than the owner.
155    */
156   modifier onlyOwner() {
157     require(msg.sender == owner);
158     _;
159   }
160 
161   /**
162    * @dev Allows the current owner to relinquish control of the contract.
163    */
164   function renounceOwnership() public onlyOwner {
165     emit OwnershipRenounced(owner);
166     owner = address(0);
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param _newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address _newOwner) public onlyOwner {
174     _transferOwnership(_newOwner);
175   }
176 
177   /**
178    * @dev Transfers control of the contract to a newOwner.
179    * @param _newOwner The address to transfer ownership to.
180    */
181   function _transferOwnership(address _newOwner) internal {
182     require(_newOwner != address(0));
183     emit OwnershipTransferred(owner, _newOwner);
184     owner = _newOwner;
185   }
186 }
187 
188 /**
189  * @title Helper library use to compare or validate the semantic versions
190  */
191 
192 library VersionUtils {
193 
194     /**
195      * @notice This function is used to validate the version submitted
196      * @param _current Array holds the present version of ST
197      * @param _new Array holds the latest version of the ST
198      * @return bool
199      */
200     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
201         bool[] memory _temp = new bool[](_current.length);
202         uint8 counter = 0;
203         for (uint8 i = 0; i < _current.length; i++) {
204             if (_current[i] < _new[i])
205                 _temp[i] = true;
206             else
207                 _temp[i] = false;
208         }
209 
210         for (i = 0; i < _current.length; i++) {
211             if (i == 0) {
212                 if (_current[i] <= _new[i])
213                     if(_temp[0]) {
214                         counter = counter + 3;
215                         break;
216                     } else
217                         counter++;
218                 else
219                     return false;
220             } else {
221                 if (_temp[i-1])
222                     counter++;
223                 else if (_current[i] <= _new[i])
224                     counter++;
225                 else
226                     return false;
227             }
228         }
229         if (counter == _current.length)
230             return true;
231     }
232 
233     /**
234      * @notice Used to compare the lower bound with the latest version
235      * @param _version1 Array holds the lower bound of the version
236      * @param _version2 Array holds the latest version of the ST
237      * @return bool
238      */
239     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
240         require(_version1.length == _version2.length, "Input length mismatch");
241         uint counter = 0;
242         for (uint8 j = 0; j < _version1.length; j++) {
243             if (_version1[j] == 0)
244                 counter ++;
245         }
246         if (counter != _version1.length) {
247             counter = 0;
248             for (uint8 i = 0; i < _version1.length; i++) {
249                 if (_version2[i] > _version1[i])
250                     return true;
251                 else if (_version2[i] < _version1[i])
252                     return false;
253                 else
254                     counter++;
255             }
256             if (counter == _version1.length - 1)
257                 return true;
258             else
259                 return false;
260         } else
261             return true;
262     }
263 
264     /**
265      * @notice Used to compare the upper bound with the latest version
266      * @param _version1 Array holds the upper bound of the version
267      * @param _version2 Array holds the latest version of the ST
268      * @return bool
269      */
270     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
271         require(_version1.length == _version2.length, "Input length mismatch");
272         uint counter = 0;
273         for (uint8 j = 0; j < _version1.length; j++) {
274             if (_version1[j] == 0)
275                 counter ++;
276         }
277         if (counter != _version1.length) {
278             counter = 0;
279             for (uint8 i = 0; i < _version1.length; i++) {
280                 if (_version1[i] > _version2[i])
281                     return true;
282                 else if (_version1[i] < _version2[i])
283                     return false;
284                 else
285                     counter++;
286             }
287             if (counter == _version1.length - 1)
288                 return true;
289             else
290                 return false;
291         } else
292             return true;
293     }
294 
295 
296     /**
297      * @notice Used to pack the uint8[] array data into uint24 value
298      * @param _major Major version
299      * @param _minor Minor version
300      * @param _patch Patch version
301      */
302     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
303         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
304     }
305 
306     /**
307      * @notice Used to convert packed data into uint8 array
308      * @param _packedVersion Packed data
309      */
310     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
311         uint8[] memory _unpackVersion = new uint8[](3);
312         _unpackVersion[0] = uint8(_packedVersion >> 16);
313         _unpackVersion[1] = uint8(_packedVersion >> 8);
314         _unpackVersion[2] = uint8(_packedVersion);
315         return _unpackVersion;
316     }
317 
318 
319 }
320 
321 /**
322  * @title Interface that any module factory contract should implement
323  * @notice Contract is abstract
324  */
325 contract ModuleFactory is IModuleFactory, Ownable {
326 
327     IERC20 public polyToken;
328     uint256 public usageCost;
329     uint256 public monthlySubscriptionCost;
330 
331     uint256 public setupCost;
332     string public description;
333     string public version;
334     bytes32 public name;
335     string public title;
336 
337     // @notice Allow only two variables to be stored
338     // 1. lowerBound 
339     // 2. upperBound
340     // @dev (0.0.0 will act as the wildcard) 
341     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
342     mapping(string => uint24) compatibleSTVersionRange;
343 
344     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
345     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
346     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
347     event GenerateModuleFromFactory(
348         address _module,
349         bytes32 indexed _moduleName,
350         address indexed _moduleFactory,
351         address _creator,
352         uint256 _timestamp
353     );
354     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
355 
356     /**
357      * @notice Constructor
358      * @param _polyAddress Address of the polytoken
359      */
360     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
361         polyToken = IERC20(_polyAddress);
362         setupCost = _setupCost;
363         usageCost = _usageCost;
364         monthlySubscriptionCost = _subscriptionCost;
365     }
366 
367     /**
368      * @notice Used to change the fee of the setup cost
369      * @param _newSetupCost new setup cost
370      */
371     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
372         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
373         setupCost = _newSetupCost;
374     }
375 
376     /**
377      * @notice Used to change the fee of the usage cost
378      * @param _newUsageCost new usage cost
379      */
380     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
381         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
382         usageCost = _newUsageCost;
383     }
384 
385     /**
386      * @notice Used to change the fee of the subscription cost
387      * @param _newSubscriptionCost new subscription cost
388      */
389     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
390         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
391         monthlySubscriptionCost = _newSubscriptionCost;
392 
393     }
394 
395     /**
396      * @notice Updates the title of the ModuleFactory
397      * @param _newTitle New Title that will replace the old one.
398      */
399     function changeTitle(string _newTitle) public onlyOwner {
400         require(bytes(_newTitle).length > 0, "Invalid title");
401         title = _newTitle;
402     }
403 
404     /**
405      * @notice Updates the description of the ModuleFactory
406      * @param _newDesc New description that will replace the old one.
407      */
408     function changeDescription(string _newDesc) public onlyOwner {
409         require(bytes(_newDesc).length > 0, "Invalid description");
410         description = _newDesc;
411     }
412 
413     /**
414      * @notice Updates the name of the ModuleFactory
415      * @param _newName New name that will replace the old one.
416      */
417     function changeName(bytes32 _newName) public onlyOwner {
418         require(_newName != bytes32(0),"Invalid name");
419         name = _newName;
420     }
421 
422     /**
423      * @notice Updates the version of the ModuleFactory
424      * @param _newVersion New name that will replace the old one.
425      */
426     function changeVersion(string _newVersion) public onlyOwner {
427         require(bytes(_newVersion).length > 0, "Invalid version");
428         version = _newVersion;
429     }
430 
431     /**
432      * @notice Function use to change the lower and upper bound of the compatible version st
433      * @param _boundType Type of bound
434      * @param _newVersion new version array
435      */
436     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
437         require(
438             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
439             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
440             "Must be a valid bound type"
441         );
442         require(_newVersion.length == 3);
443         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
444             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
445             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
446         }
447         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
448         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
449     }
450 
451     /**
452      * @notice Used to get the lower bound
453      * @return lower bound
454      */
455     function getLowerSTVersionBounds() external view returns(uint8[]) {
456         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
457     }
458 
459     /**
460      * @notice Used to get the upper bound
461      * @return upper bound
462      */
463     function getUpperSTVersionBounds() external view returns(uint8[]) {
464         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
465     }
466 
467     /**
468      * @notice Get the setup cost of the module
469      */
470     function getSetupCost() external view returns (uint256) {
471         return setupCost;
472     }
473 
474    /**
475     * @notice Get the name of the Module
476     */
477     function getName() public view returns(bytes32) {
478         return name;
479     }
480 
481 }
482 
483 /**
484  * @title Utility contract for reusable code
485  */
486 library Util {
487 
488    /**
489     * @notice Changes a string to upper case
490     * @param _base String to change
491     */
492     function upper(string _base) internal pure returns (string) {
493         bytes memory _baseBytes = bytes(_base);
494         for (uint i = 0; i < _baseBytes.length; i++) {
495             bytes1 b1 = _baseBytes[i];
496             if (b1 >= 0x61 && b1 <= 0x7A) {
497                 b1 = bytes1(uint8(b1)-32);
498             }
499             _baseBytes[i] = b1;
500         }
501         return string(_baseBytes);
502     }
503 
504     /**
505      * @notice Changes the string into bytes32
506      * @param _source String that need to convert into bytes32
507      */
508     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
509     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
510         return bytesToBytes32(bytes(_source), 0);
511     }
512 
513     /**
514      * @notice Changes bytes into bytes32
515      * @param _b Bytes that need to convert into bytes32
516      * @param _offset Offset from which to begin conversion
517      */
518     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
519     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
520         bytes32 result;
521 
522         for (uint i = 0; i < _b.length; i++) {
523             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
524         }
525         return result;
526     }
527 
528     /**
529      * @notice Changes the bytes32 into string
530      * @param _source that need to convert into string
531      */
532     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
533         bytes memory bytesString = new bytes(32);
534         uint charCount = 0;
535         for (uint j = 0; j < 32; j++) {
536             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
537             if (char != 0) {
538                 bytesString[charCount] = char;
539                 charCount++;
540             }
541         }
542         bytes memory bytesStringTrimmed = new bytes(charCount);
543         for (j = 0; j < charCount; j++) {
544             bytesStringTrimmed[j] = bytesString[j];
545         }
546         return string(bytesStringTrimmed);
547     }
548 
549     /**
550      * @notice Gets function signature from _data
551      * @param _data Passed data
552      * @return bytes4 sig
553      */
554     function getSig(bytes _data) internal pure returns (bytes4 sig) {
555         uint len = _data.length < 4 ? _data.length : 4;
556         for (uint i = 0; i < len; i++) {
557             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
558         }
559     }
560 
561 
562 }
563 
564 /**
565  * @title Factory for deploying CappedSTO module
566  */
567 contract USDTieredSTOFactory is ModuleFactory {
568 
569     address public USDTieredSTOProxyAddress;
570 
571     /**
572      * @notice Constructor
573      * @param _polyAddress Address of the polytoken
574      */
575     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost, address _proxyFactoryAddress) public
576     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
577     {
578         require(_proxyFactoryAddress != address(0), "0x address is not allowed");
579         USDTieredSTOProxyAddress = _proxyFactoryAddress;
580         version = "1.0.0";
581         name = "USDTieredSTO";
582         title = "USD Tiered STO";
583         /*solium-disable-next-line max-len*/
584         description = "It allows both accredited and non-accredited investors to contribute into the STO. Non-accredited investors will be capped at a maximum investment limit (as a default or specific to their jurisdiction). Tokens will be sold according to tiers sequentially & each tier has its own price and volume of tokens to sell. Upon receipt of funds (ETH, POLY or DAI), security tokens will automatically transfer to investor’s wallet address";
585         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
586         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
587     }
588 
589      /**
590      * @notice Used to launch the Module with the help of factory
591      * @return address Contract address of the Module
592      */
593     function deploy(bytes _data) external returns(address) {
594         if(setupCost > 0)
595             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Sufficent Allowance is not provided");
596         require(USDTieredSTOProxyAddress != address(0), "Proxy contract should be pre-set");
597         //Check valid bytes - can only call module init function
598         address usdTieredSTO = IUSDTieredSTOProxy(USDTieredSTOProxyAddress).deploySTO(msg.sender, address(polyToken), address(this));
599         //Checks that _data is valid (not calling anything it shouldn't)
600         require(Util.getSig(_data) == IUSDTieredSTOProxy(USDTieredSTOProxyAddress).getInitFunction(usdTieredSTO), "Invalid data");
601         /*solium-disable-next-line security/no-low-level-calls*/
602         require(address(usdTieredSTO).call(_data), "Unsuccessfull call");
603         /*solium-disable-next-line security/no-block-members*/
604         emit GenerateModuleFromFactory(usdTieredSTO, getName(), address(this), msg.sender, setupCost, now);
605         return address(usdTieredSTO);
606     }
607 
608     /**
609      * @notice Type of the Module factory
610      */
611     function getTypes() external view returns(uint8[]) {
612         uint8[] memory res = new uint8[](1);
613         res[0] = 3;
614         return res;
615     }
616 
617     /**
618      * @notice Returns the instructions associated with the module
619      */
620     function getInstructions() external view returns(string) {
621         return "Initialises a USD tiered STO.";
622     }
623 
624     /**
625      * @notice Get the tags related to the module factory
626      */
627     function getTags() external view returns(bytes32[]) {
628         bytes32[] memory availableTags = new bytes32[](4);
629         availableTags[0] = "USD";
630         availableTags[1] = "Tiered";
631         availableTags[2] = "POLY";
632         availableTags[3] = "ETH";
633         return availableTags;
634     }
635 
636 }