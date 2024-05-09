1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, throws on overflow.
77   */
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (a == 0) {
83       return 0;
84     }
85 
86     c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   /**
92   * @dev Integer division of two numbers, truncating the quotient.
93   */
94   function div(uint256 a, uint256 b) internal pure returns (uint256) {
95     // assert(b > 0); // Solidity automatically throws when dividing by 0
96     // uint256 c = a / b;
97     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
98     return a / b;
99   }
100 
101   /**
102   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
103   */
104   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   /**
110   * @dev Adds two numbers, throws on overflow.
111   */
112   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
113     c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 // File: contracts/interfaces/IRegistry.sol
120 
121 // limited ContractRegistry definition
122 interface IRegistry {
123   function owner()
124     external
125     returns (address);
126 
127   function updateContractAddress(
128     string _name,
129     address _address
130   )
131     external
132     returns (address);
133 
134   function getContractAddress(
135     string _name
136   )
137     external
138     view
139     returns (address);
140 }
141 
142 // File: contracts/interfaces/IPoaToken.sol
143 
144 interface IPoaToken {
145   function initializeToken
146   (
147     bytes32 _name32, // bytes32 of name string
148     bytes32 _symbol32, // bytes32 of symbol string
149     address _issuer,
150     address _custodian,
151     address _registry,
152     address _whitelist,
153     uint256 _totalSupply // token total supply
154   )
155     external
156     returns (bool);
157 
158   function issuer()
159     external
160     view
161     returns (address);
162 
163   function startPreFunding()
164     external
165     returns (bool);
166 
167   function pause()
168     external;
169 
170   function unpause()
171     external;
172 
173   function terminate()
174     external
175     returns (bool);
176 
177   function proofOfCustody()
178     external
179     view
180     returns (string);
181 }
182 
183 // File: contracts/interfaces/IPoaCrowdsale.sol
184 
185 interface IPoaCrowdsale {
186   function initializeCrowdsale(
187     bytes32 _fiatCurrency32,                // fiat currency string, e.g. 'EUR'
188     uint256 _startTimeForFundingPeriod,     // future UNIX timestamp
189     uint256 _durationForFiatFundingPeriod,  // duration of fiat funding period in seconds
190     uint256 _durationForEthFundingPeriod,   // duration of ETH funding period in seconds
191     uint256 _durationForActivationPeriod,   // duration of activation period in seconds
192     uint256 _fundingGoalInCents             // funding goal in fiat cents
193   )
194     external
195     returns (bool);
196 }
197 
198 // File: contracts/PoaProxyCommon.sol
199 
200 /**
201   @title PoaProxyCommon acts as a convention between:
202   - PoaCommon (and its inheritants: PoaToken & PoaCrowdsale)
203   - PoaProxy
204 
205   It dictates where to read and write storage
206 */
207 contract PoaProxyCommon {
208   /*****************************
209   * Start Proxy Common Storage *
210   *****************************/
211 
212   // PoaTokenMaster logic contract used by proxies
213   address public poaTokenMaster;
214 
215   // PoaCrowdsaleMaster logic contract used by proxies
216   address public poaCrowdsaleMaster;
217 
218   // Registry used for getting other contract addresses
219   address public registry;
220 
221   /***************************
222   * End Proxy Common Storage *
223   ***************************/
224 
225 
226   /*********************************
227   * Start Common Utility Functions *
228   *********************************/
229 
230   /// @notice Gets a given contract address by bytes32 in order to save gas
231   function getContractAddress(string _name)
232     public
233     view
234     returns (address _contractAddress)
235   {
236     bytes4 _signature = bytes4(keccak256("getContractAddress32(bytes32)"));
237     bytes32 _name32 = keccak256(abi.encodePacked(_name));
238 
239     assembly {
240       let _registry := sload(registry_slot) // load registry address from storage
241       let _pointer := mload(0x40)          // Set _pointer to free memory pointer
242       mstore(_pointer, _signature)         // Store _signature at _pointer
243       mstore(add(_pointer, 0x04), _name32) // Store _name32 at _pointer offset by 4 bytes for pre-existing _signature
244 
245       // staticcall(g, a, in, insize, out, outsize) => returns 0 on error, 1 on success
246       let result := staticcall(
247         gas,       // g = gas: whatever was passed already
248         _registry, // a = address: address in storage
249         _pointer,  // in = mem in  mem[in..(in+insize): set to free memory pointer
250         0x24,      // insize = mem insize  mem[in..(in+insize): size of signature (bytes4) + bytes32 = 0x24
251         _pointer,  // out = mem out  mem[out..(out+outsize): output assigned to this storage address
252         0x20       // outsize = mem outsize  mem[out..(out+outsize): output should be 32byte slot (address size = 0x14 <  slot size 0x20)
253       )
254 
255       // revert if not successful
256       if iszero(result) {
257         revert(0, 0)
258       }
259 
260       _contractAddress := mload(_pointer) // Assign result to return value
261       mstore(0x40, add(_pointer, 0x24))   // Advance free memory pointer by largest _pointer size
262     }
263   }
264 
265   /*******************************
266   * End Common Utility Functions *
267   *******************************/
268 }
269 
270 // File: contracts/PoaProxy.sol
271 
272 /**
273   @title This contract manages the storage of:
274   - PoaProxy
275   - PoaToken
276   - PoaCrowdsale
277 
278   @notice PoaProxy uses chained "delegatecall()"s to call functions on
279   PoaToken and PoaCrowdsale and sets the resulting storage
280   here on PoaProxy.
281 
282   @dev `getContractAddress("PoaLogger").call()` does not use the return value
283   because we would rather contract functions to continue even if the event
284   did not successfully trigger on the logger contract.
285 */
286 contract PoaProxy is PoaProxyCommon {
287   uint8 public constant version = 1;
288 
289   event ProxyUpgraded(address upgradedFrom, address upgradedTo);
290 
291   /**
292     @notice Stores addresses of our contract registry
293     as well as the PoaToken and PoaCrowdsale master
294     contracts to forward calls to.
295   */
296   constructor(
297     address _poaTokenMaster,
298     address _poaCrowdsaleMaster,
299     address _registry
300   )
301     public
302   {
303     // Ensure that none of the given addresses are empty
304     require(_poaTokenMaster != address(0));
305     require(_poaCrowdsaleMaster != address(0));
306     require(_registry != address(0));
307 
308     // Set addresses in common storage using deterministic storage slots
309     poaTokenMaster = _poaTokenMaster;
310     poaCrowdsaleMaster = _poaCrowdsaleMaster;
311     registry = _registry;
312   }
313 
314   /*****************************
315    * Start Proxy State Helpers *
316    *****************************/
317 
318   /**
319     @notice Ensures that a given address is a contract by
320     making sure it has code. Used during upgrading to make
321     sure the new addresses to upgrade to are smart contracts.
322    */
323   function isContract(address _address)
324     private
325     view
326     returns (bool)
327   {
328     uint256 _size;
329     assembly { _size := extcodesize(_address) }
330 
331     return _size > 0;
332   }
333 
334   /***************************
335    * End Proxy State Helpers *
336    ***************************/
337 
338 
339   /*****************************
340    * Start Proxy State Setters *
341    *****************************/
342 
343   /// @notice Update the stored "poaTokenMaster" address to upgrade the PoaToken master contract
344   function proxyChangeTokenMaster(address _newMaster)
345     public
346     returns (bool)
347   {
348     require(msg.sender == getContractAddress("PoaManager"));
349     require(_newMaster != address(0));
350     require(poaTokenMaster != _newMaster);
351     require(isContract(_newMaster));
352     address _oldMaster = poaTokenMaster;
353     poaTokenMaster = _newMaster;
354 
355     emit ProxyUpgraded(_oldMaster, _newMaster);
356     getContractAddress("PoaLogger").call(
357       abi.encodeWithSignature(
358         "logProxyUpgraded(address,address)",
359         _oldMaster,
360         _newMaster
361       )
362     );
363 
364     return true;
365   }
366 
367   /// @notice Update the stored `poaCrowdsaleMaster` address to upgrade the PoaCrowdsale master contract
368   function proxyChangeCrowdsaleMaster(address _newMaster)
369     public
370     returns (bool)
371   {
372     require(msg.sender == getContractAddress("PoaManager"));
373     require(_newMaster != address(0));
374     require(poaCrowdsaleMaster != _newMaster);
375     require(isContract(_newMaster));
376     address _oldMaster = poaCrowdsaleMaster;
377     poaCrowdsaleMaster = _newMaster;
378 
379     emit ProxyUpgraded(_oldMaster, _newMaster);
380     getContractAddress("PoaLogger").call(
381       abi.encodeWithSignature(
382         "logProxyUpgraded(address,address)",
383         _oldMaster,
384         _newMaster
385       )
386     );
387 
388     return true;
389   }
390 
391   /***************************
392    * End Proxy State Setters *
393    ***************************/
394 
395   /**
396     @notice Fallback function for all proxied functions using "delegatecall()".
397     It will first forward all functions to the "poaTokenMaster" address. If the
398     called function isn't found there, then "poaTokenMaster"'s fallback function
399     will forward the call to "poaCrowdsale". If the called function also isn't
400     found there, it will fail at last.
401   */
402   function()
403     external
404     payable
405   {
406     assembly {
407       // Load PoaToken master address from first storage pointer
408       let _poaTokenMaster := sload(poaTokenMaster_slot)
409 
410       // calldatacopy(t, f, s)
411       calldatacopy(
412         0x0, // t = mem position to
413         0x0, // f = mem position from
414         calldatasize // s = size bytes
415       )
416 
417       // delegatecall(g, a, in, insize, out, outsize) => returns "0" on error, or "1" on success
418       let result := delegatecall(
419         gas, // g = gas
420         _poaTokenMaster, // a = address
421         0x0, // in = mem in  mem[in..(in+insize)
422         calldatasize, // insize = mem insize  mem[in..(in+insize)
423         0x0, // out = mem out  mem[out..(out+outsize)
424         0 // outsize = mem outsize  mem[out..(out+outsize)
425       )
426 
427       // Check if the call was successful
428       if iszero(result) {
429         // Revert if call failed
430         revert(0, 0)
431       }
432 
433       // returndatacopy(t, f, s)
434       returndatacopy(
435         0x0, // t = mem position to
436         0x0,  // f = mem position from
437         returndatasize // s = size bytes
438       )
439       // Return if call succeeded
440       return(
441         0x0,
442         returndatasize
443       )
444     }
445   }
446 }
447 
448 // File: contracts/PoaManager.sol
449 
450 contract PoaManager is Ownable {
451   using SafeMath for uint256;
452 
453   uint256 constant version = 1;
454 
455   IRegistry public registry;
456 
457   struct EntityState {
458     uint256 index;
459     bool active;
460   }
461 
462   // Keeping a list for addresses we track for easy access
463   address[] private issuerAddressList;
464   address[] private tokenAddressList;
465 
466   // A mapping for each address we track
467   mapping (address => EntityState) private tokenMap;
468   mapping (address => EntityState) private issuerMap;
469 
470   event IssuerAdded(address indexed issuer);
471   event IssuerRemoved(address indexed issuer);
472   event IssuerStatusChanged(address indexed issuer, bool active);
473 
474   event TokenAdded(address indexed token);
475   event TokenRemoved(address indexed token);
476   event TokenStatusChanged(address indexed token, bool active);
477 
478   modifier isNewIssuer(address _issuerAddress) {
479     require(_issuerAddress != address(0));
480     require(issuerMap[_issuerAddress].index == 0);
481     _;
482   }
483 
484   modifier onlyActiveIssuer() {
485     EntityState memory entity = issuerMap[msg.sender];
486     require(entity.active);
487     _;
488   }
489 
490   constructor(address _registryAddress)
491     public
492   {
493     require(_registryAddress != address(0));
494     registry = IRegistry(_registryAddress);
495   }
496 
497   //
498   // Entity functions
499   //
500 
501   function doesEntityExist(
502     address _entityAddress,
503     EntityState entity
504   )
505     private
506     pure
507     returns (bool)
508   {
509     return (_entityAddress != address(0) && entity.index != 0);
510   }
511 
512   function addEntity(
513     address _entityAddress,
514     address[] storage entityList,
515     bool _active
516   )
517     private
518     returns (EntityState)
519   {
520     entityList.push(_entityAddress);
521     // we do not offset by `-1` so that we never have `entity.index = 0` as this is what is
522     // used to check for existence in modifier [doesEntityExist]
523     uint256 index = entityList.length;
524     EntityState memory entity = EntityState(index, _active);
525 
526     return entity;
527   }
528 
529   function removeEntity(
530     EntityState _entityToRemove,
531     address[] storage _entityList
532   )
533     private
534     returns (address, uint256)
535   {
536     // we offset by -1 here to account for how `addEntity` marks the `entity.index` value
537     uint256 index = _entityToRemove.index.sub(1);
538 
539     // swap the entity to be removed with the last element in the list
540     _entityList[index] = _entityList[_entityList.length - 1];
541 
542     // because we wanted seperate mappings for token and issuer, and we cannot pass a storage mapping
543     // as a function argument, this abstraction is leaky; we return the address and index so the
544     // caller can update the mapping
545     address entityToSwapAddress = _entityList[index];
546 
547     // we do not need to delete the element, the compiler should clean up for us
548     _entityList.length--;
549 
550     return (entityToSwapAddress, _entityToRemove.index);
551   }
552 
553   function setEntityActiveValue(
554     EntityState storage entity,
555     bool _active
556   )
557     private
558   {
559     require(entity.active != _active);
560     entity.active = _active;
561   }
562 
563   //
564   // Issuer functions
565   //
566 
567   // Return all tracked issuer addresses
568   function getIssuerAddressList()
569     public
570     view
571     returns (address[])
572   {
573     return issuerAddressList;
574   }
575 
576   // Add an issuer and set active value to true
577   function addIssuer(address _issuerAddress)
578     public
579     onlyOwner
580     isNewIssuer(_issuerAddress)
581   {
582     issuerMap[_issuerAddress] = addEntity(
583       _issuerAddress,
584       issuerAddressList,
585       true
586     );
587 
588     emit IssuerAdded(_issuerAddress);
589   }
590 
591   // Remove an issuer
592   function removeIssuer(address _issuerAddress)
593     public
594     onlyOwner
595   {
596     require(doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]));
597 
598     address addressToUpdate;
599     uint256 indexUpdate;
600     (addressToUpdate, indexUpdate) = removeEntity(issuerMap[_issuerAddress], issuerAddressList);
601     issuerMap[addressToUpdate].index = indexUpdate;
602     delete issuerMap[_issuerAddress];
603 
604     emit IssuerRemoved(_issuerAddress);
605   }
606 
607   // Set previously delisted issuer to listed
608   function listIssuer(address _issuerAddress)
609     public
610     onlyOwner
611   {
612     require(doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]));
613 
614     setEntityActiveValue(issuerMap[_issuerAddress], true);
615     emit IssuerStatusChanged(_issuerAddress, true);
616   }
617 
618   // Set previously listed issuer to delisted
619   function delistIssuer(address _issuerAddress)
620     public
621     onlyOwner
622   {
623     require(doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]));
624 
625     setEntityActiveValue(issuerMap[_issuerAddress], false);
626     emit IssuerStatusChanged(_issuerAddress, false);
627   }
628 
629   function isActiveIssuer(address _issuerAddress)
630     public
631     view
632     returns (bool)
633   {
634     require(doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]));
635 
636     return issuerMap[_issuerAddress].active;
637   }
638 
639   function isRegisteredIssuer(address _issuerAddress)
640     external
641     view
642     returns (bool)
643   {
644     return doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]);
645   }
646 
647   //
648   // Token functions
649   //
650 
651   // Return all tracked token addresses
652   function getTokenAddressList()
653     public
654     view
655     returns (address[])
656   {
657     return tokenAddressList;
658   }
659 
660   function createPoaTokenProxy()
661     private
662     returns (address _proxyContract)
663   {
664     address _poaTokenMaster = registry.getContractAddress("PoaTokenMaster");
665     address _poaCrowdsaleMaster = registry.getContractAddress("PoaCrowdsaleMaster");
666     _proxyContract = new PoaProxy(_poaTokenMaster, _poaCrowdsaleMaster, address(registry));
667   }
668 
669   /**
670     @notice Creates a PoaToken contract with given parameters, and set active value to false
671     @param _fiatCurrency32 Fiat symbol used in ExchangeRates
672     @param _startTimeForFundingPeriod Given as unix time in seconds since 01.01.1970
673     @param _durationForFiatFundingPeriod How long fiat funding can last, given in seconds
674     @param _durationForEthFundingPeriod How long eth funding can last, given in seconds
675     @param _durationForActivationPeriod How long a custodian has to activate token, given in seconds
676     @param _fundingGoalInCents Given as fiat cents
677    */
678   function addNewToken(
679     bytes32 _name32,
680     bytes32 _symbol32,
681     bytes32 _fiatCurrency32,
682     address _custodian,
683     uint256 _totalSupply,
684     uint256 _startTimeForFundingPeriod,
685     uint256 _durationForFiatFundingPeriod,
686     uint256 _durationForEthFundingPeriod,
687     uint256 _durationForActivationPeriod,
688     uint256 _fundingGoalInCents,
689     address _whitelist
690   )
691     public
692     onlyActiveIssuer
693     returns (address)
694   {
695     address _tokenAddress = createPoaTokenProxy();
696 
697     // We use this initialization pattern to avoid the `StackTooDeep` problem
698     // StackTooDeep: https://ethereum.stackexchange.com/questions/6061/error-while-compiling-stack-too-deep
699     initializePoaToken(
700       _tokenAddress,
701       _name32,
702       _symbol32,
703       _custodian,
704       _whitelist,
705       _totalSupply
706     );
707 
708     initializePoaCrowdsale(
709       _tokenAddress,
710       _fiatCurrency32,
711       _startTimeForFundingPeriod,
712       _durationForFiatFundingPeriod,
713       _durationForEthFundingPeriod,
714       _durationForActivationPeriod,
715       _fundingGoalInCents
716     );
717 
718     tokenMap[_tokenAddress] = addEntity(
719       _tokenAddress,
720       tokenAddressList,
721       false
722     );
723 
724     emit TokenAdded(_tokenAddress);
725 
726     return _tokenAddress;
727   }
728 
729   // Initializes a PoaToken contract with given parameters
730   function initializePoaToken(
731     address _tokenAddress,
732     bytes32 _name32,
733     bytes32 _symbol32,
734     address _custodian,
735     address _whitelist,
736     uint256 _totalSupply
737   )
738     private
739   {
740     IPoaToken(_tokenAddress).initializeToken(
741       _name32,
742       _symbol32,
743       msg.sender,
744       _custodian,
745       registry,
746       _whitelist,
747       _totalSupply
748     );
749   }
750 
751   // Initializes a PoaCrowdsale contract with given parameters
752   function initializePoaCrowdsale(
753     address _tokenAddress,
754     bytes32 _fiatCurrency32,
755     uint256 _startTimeForFundingPeriod,
756     uint256 _durationForFiatFundingPeriod,
757     uint256 _durationForEthFundingPeriod,
758     uint256 _durationForActivationPeriod,
759     uint256 _fundingGoalInCents
760   )
761     private
762   {
763     IPoaCrowdsale(_tokenAddress).initializeCrowdsale(
764       _fiatCurrency32,
765       _startTimeForFundingPeriod,
766       _durationForFiatFundingPeriod,
767       _durationForEthFundingPeriod,
768       _durationForActivationPeriod,
769       _fundingGoalInCents
770     );
771   }
772 
773   /**
774     @notice Add existing `PoaProxy` contracts when `PoaManager` has been upgraded
775     @param _tokenAddress the `PoaProxy` address to address
776     @param _isListed if `PoaProxy` should be added as active or inactive
777     @dev `PoaProxy` contracts can only be added when the POA's issuer is already listed.
778          Furthermore, we use `issuer()` as check if `_tokenAddress` represents a `PoaProxy`.
779    */
780   function addExistingToken(address _tokenAddress, bool _isListed)
781     external
782     onlyOwner
783   {
784     require(!doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
785     // Issuer address of `_tokenAddress` must be an active Issuer.
786     // If `_tokenAddress` is not an instance of PoaProxy, this will fail as desired.
787     require(isActiveIssuer(IPoaToken(_tokenAddress).issuer()));
788 
789     tokenMap[_tokenAddress] = addEntity(
790       _tokenAddress,
791       tokenAddressList,
792       _isListed
793     );
794   }
795 
796   // Remove a token
797   function removeToken(address _tokenAddress)
798     public
799     onlyOwner
800   {
801     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
802 
803     address addressToUpdate;
804     uint256 indexUpdate;
805     (addressToUpdate, indexUpdate) = removeEntity(tokenMap[_tokenAddress], tokenAddressList);
806     tokenMap[addressToUpdate].index = indexUpdate;
807     delete tokenMap[_tokenAddress];
808 
809     emit TokenRemoved(_tokenAddress);
810   }
811 
812   // Set previously delisted token to listed
813   function listToken(address _tokenAddress)
814     public
815     onlyOwner
816   {
817     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
818 
819     setEntityActiveValue(tokenMap[_tokenAddress], true);
820     emit TokenStatusChanged(_tokenAddress, true);
821   }
822 
823   // Set previously listed token to delisted
824   function delistToken(address _tokenAddress)
825     public
826     onlyOwner
827   {
828     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
829 
830     setEntityActiveValue(tokenMap[_tokenAddress], false);
831     emit TokenStatusChanged(_tokenAddress, false);
832   }
833 
834   function isActiveToken(address _tokenAddress)
835     public
836     view
837     returns (bool)
838   {
839     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
840 
841     return tokenMap[_tokenAddress].active;
842   }
843 
844   function isRegisteredToken(address _tokenAddress)
845     external
846     view
847     returns (bool)
848   {
849     return doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]);
850   }
851 
852   //
853   // Token onlyOwner functions as PoaManger is `owner` of all PoaToken
854   //
855 
856   // Allow unpausing a listed PoaToken
857   function pauseToken(address _tokenAddress)
858     public
859     onlyOwner
860   {
861     IPoaToken(_tokenAddress).pause();
862   }
863 
864   // Allow unpausing a listed PoaToken
865   function unpauseToken(IPoaToken _tokenAddress)
866     public
867     onlyOwner
868   {
869     _tokenAddress.unpause();
870   }
871 
872   // Allow terminating a listed PoaToken
873   function terminateToken(IPoaToken _tokenAddress)
874     public
875     onlyOwner
876   {
877     _tokenAddress.terminate();
878   }
879 
880   // upgrade an existing PoaToken proxy to what is stored in ContractRegistry
881   function upgradeToken(PoaProxy _proxyToken)
882     external
883     onlyOwner
884     returns (bool)
885   {
886     _proxyToken.proxyChangeTokenMaster(
887       registry.getContractAddress("PoaTokenMaster")
888     );
889 
890     return true;
891   }
892 
893   // upgrade an existing PoaCrowdsale proxy to what is stored in ContractRegistry
894   function upgradeCrowdsale(PoaProxy _proxyToken)
895     external
896     onlyOwner
897     returns (bool)
898   {
899     _proxyToken.proxyChangeCrowdsaleMaster(
900       registry.getContractAddress("PoaCrowdsaleMaster")
901     );
902 
903     return true;
904   }
905 }