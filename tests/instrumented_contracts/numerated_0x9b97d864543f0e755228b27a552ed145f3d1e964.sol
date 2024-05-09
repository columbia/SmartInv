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
152     uint256 _totalSupply // token total supply
153   )
154     external
155     returns (bool);
156 
157   function issuer()
158     external
159     view
160     returns (address);
161 
162   function startPreFunding()
163     external
164     returns (bool);
165 
166   function pause()
167     external;
168 
169   function unpause()
170     external;
171 
172   function terminate()
173     external
174     returns (bool);
175 
176   function proofOfCustody()
177     external
178     view
179     returns (string);
180 }
181 
182 // File: contracts/interfaces/IPoaCrowdsale.sol
183 
184 interface IPoaCrowdsale {
185   function initializeCrowdsale(
186     bytes32 _fiatCurrency32,                // fiat currency string, e.g. 'EUR'
187     uint256 _startTimeForFundingPeriod,     // future UNIX timestamp
188     uint256 _durationForFiatFundingPeriod,  // duration of fiat funding period in seconds
189     uint256 _durationForEthFundingPeriod,   // duration of ETH funding period in seconds
190     uint256 _durationForActivationPeriod,   // duration of activation period in seconds
191     uint256 _fundingGoalInCents             // funding goal in fiat cents
192   )
193     external
194     returns (bool);
195 }
196 
197 // File: contracts/PoaProxyCommon.sol
198 
199 /**
200   @title PoaProxyCommon acts as a convention between:
201   - PoaCommon (and its inheritants: PoaToken & PoaCrowdsale)
202   - PoaProxy
203 
204   It dictates where to read and write storage
205 */
206 contract PoaProxyCommon {
207   /*****************************
208   * Start Proxy Common Storage *
209   *****************************/
210 
211   // PoaTokenMaster logic contract used by proxies
212   address public poaTokenMaster;
213 
214   // PoaCrowdsaleMaster logic contract used by proxies
215   address public poaCrowdsaleMaster;
216 
217   // Registry used for getting other contract addresses
218   address public registry;
219 
220   /***************************
221   * End Proxy Common Storage *
222   ***************************/
223 
224 
225   /*********************************
226   * Start Common Utility Functions *
227   *********************************/
228 
229   /// @notice Gets a given contract address by bytes32 in order to save gas
230   function getContractAddress(string _name)
231     public
232     view
233     returns (address _contractAddress)
234   {
235     bytes4 _signature = bytes4(keccak256("getContractAddress32(bytes32)"));
236     bytes32 _name32 = keccak256(abi.encodePacked(_name));
237 
238     assembly {
239       let _registry := sload(registry_slot) // load registry address from storage
240       let _pointer := mload(0x40)          // Set _pointer to free memory pointer
241       mstore(_pointer, _signature)         // Store _signature at _pointer
242       mstore(add(_pointer, 0x04), _name32) // Store _name32 at _pointer offset by 4 bytes for pre-existing _signature
243 
244       // staticcall(g, a, in, insize, out, outsize) => returns 0 on error, 1 on success
245       let result := staticcall(
246         gas,       // g = gas: whatever was passed already
247         _registry, // a = address: address in storage
248         _pointer,  // in = mem in  mem[in..(in+insize): set to free memory pointer
249         0x24,      // insize = mem insize  mem[in..(in+insize): size of signature (bytes4) + bytes32 = 0x24
250         _pointer,  // out = mem out  mem[out..(out+outsize): output assigned to this storage address
251         0x20       // outsize = mem outsize  mem[out..(out+outsize): output should be 32byte slot (address size = 0x14 <  slot size 0x20)
252       )
253 
254       // revert if not successful
255       if iszero(result) {
256         revert(0, 0)
257       }
258 
259       _contractAddress := mload(_pointer) // Assign result to return value
260       mstore(0x40, add(_pointer, 0x24))   // Advance free memory pointer by largest _pointer size
261     }
262   }
263 
264   /*******************************
265   * End Common Utility Functions *
266   *******************************/
267 }
268 
269 // File: contracts/PoaProxy.sol
270 
271 /**
272   @title This contract manages the storage of:
273   - PoaProxy
274   - PoaToken
275   - PoaCrowdsale
276 
277   @notice PoaProxy uses chained "delegatecall()"s to call functions on
278   PoaToken and PoaCrowdsale and sets the resulting storage
279   here on PoaProxy.
280 
281   @dev `getContractAddress("PoaLogger").call()` does not use the return value
282   because we would rather contract functions to continue even if the event
283   did not successfully trigger on the logger contract.
284 */
285 contract PoaProxy is PoaProxyCommon {
286   uint8 public constant version = 1;
287 
288   event ProxyUpgraded(address upgradedFrom, address upgradedTo);
289 
290   /**
291     @notice Stores addresses of our contract registry
292     as well as the PoaToken and PoaCrowdsale master
293     contracts to forward calls to.
294   */
295   constructor(
296     address _poaTokenMaster,
297     address _poaCrowdsaleMaster,
298     address _registry
299   )
300     public
301   {
302     // Ensure that none of the given addresses are empty
303     require(_poaTokenMaster != address(0));
304     require(_poaCrowdsaleMaster != address(0));
305     require(_registry != address(0));
306 
307     // Set addresses in common storage using deterministic storage slots
308     poaTokenMaster = _poaTokenMaster;
309     poaCrowdsaleMaster = _poaCrowdsaleMaster;
310     registry = _registry;
311   }
312 
313   /*****************************
314    * Start Proxy State Helpers *
315    *****************************/
316 
317   /**
318     @notice Ensures that a given address is a contract by
319     making sure it has code. Used during upgrading to make
320     sure the new addresses to upgrade to are smart contracts.
321    */
322   function isContract(address _address)
323     private
324     view
325     returns (bool)
326   {
327     uint256 _size;
328     assembly { _size := extcodesize(_address) }
329 
330     return _size > 0;
331   }
332 
333   /***************************
334    * End Proxy State Helpers *
335    ***************************/
336 
337 
338   /*****************************
339    * Start Proxy State Setters *
340    *****************************/
341 
342   /// @notice Update the stored "poaTokenMaster" address to upgrade the PoaToken master contract
343   function proxyChangeTokenMaster(address _newMaster)
344     public
345     returns (bool)
346   {
347     require(msg.sender == getContractAddress("PoaManager"));
348     require(_newMaster != address(0));
349     require(poaTokenMaster != _newMaster);
350     require(isContract(_newMaster));
351     address _oldMaster = poaTokenMaster;
352     poaTokenMaster = _newMaster;
353 
354     emit ProxyUpgraded(_oldMaster, _newMaster);
355     getContractAddress("PoaLogger").call(
356       abi.encodeWithSignature(
357         "logProxyUpgraded(address,address)",
358         _oldMaster,
359         _newMaster
360       )
361     );
362 
363     return true;
364   }
365 
366   /// @notice Update the stored `poaCrowdsaleMaster` address to upgrade the PoaCrowdsale master contract
367   function proxyChangeCrowdsaleMaster(address _newMaster)
368     public
369     returns (bool)
370   {
371     require(msg.sender == getContractAddress("PoaManager"));
372     require(_newMaster != address(0));
373     require(poaCrowdsaleMaster != _newMaster);
374     require(isContract(_newMaster));
375     address _oldMaster = poaCrowdsaleMaster;
376     poaCrowdsaleMaster = _newMaster;
377 
378     emit ProxyUpgraded(_oldMaster, _newMaster);
379     getContractAddress("PoaLogger").call(
380       abi.encodeWithSignature(
381         "logProxyUpgraded(address,address)",
382         _oldMaster,
383         _newMaster
384       )
385     );
386 
387     return true;
388   }
389 
390   /***************************
391    * End Proxy State Setters *
392    ***************************/
393 
394   /**
395     @notice Fallback function for all proxied functions using "delegatecall()".
396     It will first forward all functions to the "poaTokenMaster" address. If the
397     called function isn't found there, then "poaTokenMaster"'s fallback function
398     will forward the call to "poaCrowdsale". If the called function also isn't
399     found there, it will fail at last.
400   */
401   function()
402     external
403     payable
404   {
405     assembly {
406       // Load PoaToken master address from first storage pointer
407       let _poaTokenMaster := sload(poaTokenMaster_slot)
408 
409       // calldatacopy(t, f, s)
410       calldatacopy(
411         0x0, // t = mem position to
412         0x0, // f = mem position from
413         calldatasize // s = size bytes
414       )
415 
416       // delegatecall(g, a, in, insize, out, outsize) => returns "0" on error, or "1" on success
417       let result := delegatecall(
418         gas, // g = gas
419         _poaTokenMaster, // a = address
420         0x0, // in = mem in  mem[in..(in+insize)
421         calldatasize, // insize = mem insize  mem[in..(in+insize)
422         0x0, // out = mem out  mem[out..(out+outsize)
423         0 // outsize = mem outsize  mem[out..(out+outsize)
424       )
425 
426       // Check if the call was successful
427       if iszero(result) {
428         // Revert if call failed
429         revert(0, 0)
430       }
431 
432       // returndatacopy(t, f, s)
433       returndatacopy(
434         0x0, // t = mem position to
435         0x0,  // f = mem position from
436         returndatasize // s = size bytes
437       )
438       // Return if call succeeded
439       return(
440         0x0,
441         returndatasize
442       )
443     }
444   }
445 }
446 
447 // File: contracts/PoaManager.sol
448 
449 contract PoaManager is Ownable {
450   using SafeMath for uint256;
451 
452   uint256 constant version = 1;
453 
454   IRegistry public registry;
455 
456   struct EntityState {
457     uint256 index;
458     bool active;
459   }
460 
461   // Keeping a list for addresses we track for easy access
462   address[] private issuerAddressList;
463   address[] private tokenAddressList;
464 
465   // A mapping for each address we track
466   mapping (address => EntityState) private tokenMap;
467   mapping (address => EntityState) private issuerMap;
468 
469   event IssuerAdded(address indexed issuer);
470   event IssuerRemoved(address indexed issuer);
471   event IssuerStatusChanged(address indexed issuer, bool active);
472 
473   event TokenAdded(address indexed token);
474   event TokenRemoved(address indexed token);
475   event TokenStatusChanged(address indexed token, bool active);
476 
477   modifier isNewIssuer(address _issuerAddress) {
478     require(_issuerAddress != address(0));
479     require(issuerMap[_issuerAddress].index == 0);
480     _;
481   }
482 
483   modifier onlyActiveIssuer() {
484     EntityState memory entity = issuerMap[msg.sender];
485     require(entity.active);
486     _;
487   }
488 
489   constructor(address _registryAddress)
490     public
491   {
492     require(_registryAddress != address(0));
493     registry = IRegistry(_registryAddress);
494   }
495 
496   //
497   // Entity functions
498   //
499 
500   function doesEntityExist(
501     address _entityAddress,
502     EntityState entity
503   )
504     private
505     pure
506     returns (bool)
507   {
508     return (_entityAddress != address(0) && entity.index != 0);
509   }
510 
511   function addEntity(
512     address _entityAddress,
513     address[] storage entityList,
514     bool _active
515   )
516     private
517     returns (EntityState)
518   {
519     entityList.push(_entityAddress);
520     // we do not offset by `-1` so that we never have `entity.index = 0` as this is what is
521     // used to check for existence in modifier [doesEntityExist]
522     uint256 index = entityList.length;
523     EntityState memory entity = EntityState(index, _active);
524 
525     return entity;
526   }
527 
528   function removeEntity(
529     EntityState _entityToRemove,
530     address[] storage _entityList
531   )
532     private
533     returns (address, uint256)
534   {
535     // we offset by -1 here to account for how `addEntity` marks the `entity.index` value
536     uint256 index = _entityToRemove.index.sub(1);
537 
538     // swap the entity to be removed with the last element in the list
539     _entityList[index] = _entityList[_entityList.length - 1];
540 
541     // because we wanted seperate mappings for token and issuer, and we cannot pass a storage mapping
542     // as a function argument, this abstraction is leaky; we return the address and index so the
543     // caller can update the mapping
544     address entityToSwapAddress = _entityList[index];
545 
546     // we do not need to delete the element, the compiler should clean up for us
547     _entityList.length--;
548 
549     return (entityToSwapAddress, _entityToRemove.index);
550   }
551 
552   function setEntityActiveValue(
553     EntityState storage entity,
554     bool _active
555   )
556     private
557   {
558     require(entity.active != _active);
559     entity.active = _active;
560   }
561 
562   //
563   // Issuer functions
564   //
565 
566   // Return all tracked issuer addresses
567   function getIssuerAddressList()
568     public
569     view
570     returns (address[])
571   {
572     return issuerAddressList;
573   }
574 
575   // Add an issuer and set active value to true
576   function addIssuer(address _issuerAddress)
577     public
578     onlyOwner
579     isNewIssuer(_issuerAddress)
580   {
581     issuerMap[_issuerAddress] = addEntity(
582       _issuerAddress,
583       issuerAddressList,
584       true
585     );
586 
587     emit IssuerAdded(_issuerAddress);
588   }
589 
590   // Remove an issuer
591   function removeIssuer(address _issuerAddress)
592     public
593     onlyOwner
594   {
595     require(doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]));
596 
597     address addressToUpdate;
598     uint256 indexUpdate;
599     (addressToUpdate, indexUpdate) = removeEntity(issuerMap[_issuerAddress], issuerAddressList);
600     issuerMap[addressToUpdate].index = indexUpdate;
601     delete issuerMap[_issuerAddress];
602 
603     emit IssuerRemoved(_issuerAddress);
604   }
605 
606   // Set previously delisted issuer to listed
607   function listIssuer(address _issuerAddress)
608     public
609     onlyOwner
610   {
611     require(doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]));
612 
613     setEntityActiveValue(issuerMap[_issuerAddress], true);
614     emit IssuerStatusChanged(_issuerAddress, true);
615   }
616 
617   // Set previously listed issuer to delisted
618   function delistIssuer(address _issuerAddress)
619     public
620     onlyOwner
621   {
622     require(doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]));
623 
624     setEntityActiveValue(issuerMap[_issuerAddress], false);
625     emit IssuerStatusChanged(_issuerAddress, false);
626   }
627 
628   function isActiveIssuer(address _issuerAddress)
629     public
630     view
631     returns (bool)
632   {
633     require(doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]));
634 
635     return issuerMap[_issuerAddress].active;
636   }
637 
638   function isRegisteredIssuer(address _issuerAddress)
639     external
640     view
641     returns (bool)
642   {
643     return doesEntityExist(_issuerAddress, issuerMap[_issuerAddress]);
644   }
645 
646   //
647   // Token functions
648   //
649 
650   // Return all tracked token addresses
651   function getTokenAddressList()
652     public
653     view
654     returns (address[])
655   {
656     return tokenAddressList;
657   }
658 
659   function createPoaTokenProxy()
660     private
661     returns (address _proxyContract)
662   {
663     address _poaTokenMaster = registry.getContractAddress("PoaTokenMaster");
664     address _poaCrowdsaleMaster = registry.getContractAddress("PoaCrowdsaleMaster");
665     _proxyContract = new PoaProxy(_poaTokenMaster, _poaCrowdsaleMaster, address(registry));
666   }
667 
668   /**
669     @notice Creates a PoaToken contract with given parameters, and set active value to false
670     @param _fiatCurrency32 Fiat symbol used in ExchangeRates
671     @param _startTimeForFundingPeriod Given as unix time in seconds since 01.01.1970
672     @param _durationForFiatFundingPeriod How long fiat funding can last, given in seconds
673     @param _durationForEthFundingPeriod How long eth funding can last, given in seconds
674     @param _durationForActivationPeriod How long a custodian has to activate token, given in seconds
675     @param _fundingGoalInCents Given as fiat cents
676    */
677   function addNewToken(
678     bytes32 _name32,
679     bytes32 _symbol32,
680     bytes32 _fiatCurrency32,
681     address _custodian,
682     uint256 _totalSupply,
683     uint256 _startTimeForFundingPeriod,
684     uint256 _durationForFiatFundingPeriod,
685     uint256 _durationForEthFundingPeriod,
686     uint256 _durationForActivationPeriod,
687     uint256 _fundingGoalInCents
688   )
689     public
690     onlyActiveIssuer
691     returns (address)
692   {
693     address _tokenAddress = createPoaTokenProxy();
694 
695     IPoaToken(_tokenAddress).initializeToken(
696       _name32,
697       _symbol32,
698       msg.sender,
699       _custodian,
700       registry,
701       _totalSupply
702     );
703 
704     IPoaCrowdsale(_tokenAddress).initializeCrowdsale(
705       _fiatCurrency32,
706       _startTimeForFundingPeriod,
707       _durationForFiatFundingPeriod,
708       _durationForEthFundingPeriod,
709       _durationForActivationPeriod,
710       _fundingGoalInCents
711     );
712 
713     tokenMap[_tokenAddress] = addEntity(
714       _tokenAddress,
715       tokenAddressList,
716       false
717     );
718 
719     emit TokenAdded(_tokenAddress);
720 
721     return _tokenAddress;
722   }
723 
724   /**
725     @notice Add existing `PoaProxy` contracts when `PoaManager` has been upgraded
726     @param _tokenAddress the `PoaProxy` address to address
727     @param _isListed if `PoaProxy` should be added as active or inactive
728     @dev `PoaProxy` contracts can only be added when the POA's issuer is already listed.
729          Furthermore, we use `issuer()` as check if `_tokenAddress` represents a `PoaProxy`.
730    */
731   function addExistingToken(address _tokenAddress, bool _isListed)
732     external
733     onlyOwner
734   {
735     require(!doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
736     // Issuer address of `_tokenAddress` must be an active Issuer.
737     // If `_tokenAddress` is not an instance of PoaProxy, this will fail as desired.
738     require(isActiveIssuer(IPoaToken(_tokenAddress).issuer()));
739 
740     tokenMap[_tokenAddress] = addEntity(
741       _tokenAddress,
742       tokenAddressList,
743       _isListed
744     );
745   }
746 
747   // Remove a token
748   function removeToken(address _tokenAddress)
749     public
750     onlyOwner
751   {
752     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
753 
754     address addressToUpdate;
755     uint256 indexUpdate;
756     (addressToUpdate, indexUpdate) = removeEntity(tokenMap[_tokenAddress], tokenAddressList);
757     tokenMap[addressToUpdate].index = indexUpdate;
758     delete tokenMap[_tokenAddress];
759 
760     emit TokenRemoved(_tokenAddress);
761   }
762 
763   // Set previously delisted token to listed
764   function listToken(address _tokenAddress)
765     public
766     onlyOwner
767   {
768     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
769 
770     setEntityActiveValue(tokenMap[_tokenAddress], true);
771     emit TokenStatusChanged(_tokenAddress, true);
772   }
773 
774   // Set previously listed token to delisted
775   function delistToken(address _tokenAddress)
776     public
777     onlyOwner
778   {
779     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
780 
781     setEntityActiveValue(tokenMap[_tokenAddress], false);
782     emit TokenStatusChanged(_tokenAddress, false);
783   }
784 
785   function isActiveToken(address _tokenAddress)
786     public
787     view
788     returns (bool)
789   {
790     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
791 
792     return tokenMap[_tokenAddress].active;
793   }
794 
795   function isRegisteredToken(address _tokenAddress)
796     external
797     view
798     returns (bool)
799   {
800     return doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]);
801   }
802 
803   //
804   // Token onlyOwner functions as PoaManger is `owner` of all PoaToken
805   //
806 
807   // Allow unpausing a listed PoaToken
808   function pauseToken(address _tokenAddress)
809     public
810     onlyOwner
811   {
812     IPoaToken(_tokenAddress).pause();
813   }
814 
815   // Allow unpausing a listed PoaToken
816   function unpauseToken(IPoaToken _tokenAddress)
817     public
818     onlyOwner
819   {
820     _tokenAddress.unpause();
821   }
822 
823   // Allow terminating a listed PoaToken
824   function terminateToken(IPoaToken _tokenAddress)
825     public
826     onlyOwner
827   {
828     _tokenAddress.terminate();
829   }
830 
831   // upgrade an existing PoaToken proxy to what is stored in ContractRegistry
832   function upgradeToken(PoaProxy _proxyToken)
833     external
834     onlyOwner
835     returns (bool)
836   {
837     _proxyToken.proxyChangeTokenMaster(
838       registry.getContractAddress("PoaTokenMaster")
839     );
840 
841     return true;
842   }
843 
844   // upgrade an existing PoaCrowdsale proxy to what is stored in ContractRegistry
845   function upgradeCrowdsale(PoaProxy _proxyToken)
846     external
847     onlyOwner
848     returns (bool)
849   {
850     _proxyToken.proxyChangeCrowdsaleMaster(
851       registry.getContractAddress("PoaCrowdsaleMaster")
852     );
853 
854     return true;
855   }
856 }