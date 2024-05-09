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
125     returns(address);
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
149     address _broker,
150     address _custodian,
151     address _registry,
152     uint256 _totalSupply // token total supply
153   )
154     external
155     returns (bool);
156 
157   function startPreFunding()
158     external
159     returns (bool);
160 
161   function pause()
162     external;
163 
164   function unpause()
165     external;
166 
167   function terminate()
168     external
169     returns (bool);
170 
171   function proofOfCustody()
172     external
173     view
174     returns (string);
175 }
176 
177 // File: contracts/interfaces/IPoaCrowdsale.sol
178 
179 interface IPoaCrowdsale {
180   function initializeCrowdsale(
181     bytes32 _fiatCurrency32,                // fiat currency string, e.g. 'EUR'
182     uint256 _startTimeForFundingPeriod,     // future UNIX timestamp
183     uint256 _durationForFiatFundingPeriod,  // duration of fiat funding period in seconds
184     uint256 _durationForEthFundingPeriod,   // duration of ETH funding period in seconds
185     uint256 _durationForActivationPeriod,   // duration of activation period in seconds
186     uint256 _fundingGoalInCents             // funding goal in fiat cents
187   )
188     external
189     returns (bool);
190 }
191 
192 // File: contracts/PoaProxyCommon.sol
193 
194 /**
195   @title PoaProxyCommon acts as a convention between:
196   - PoaCommon (and its inheritants: PoaToken & PoaCrowdsale)
197   - PoaProxy
198 
199   It dictates where to read and write storage
200 */
201 contract PoaProxyCommon {
202   /*****************************
203   * Start Proxy Common Storage *
204   *****************************/
205 
206   // PoaTokenMaster logic contract used by proxies
207   address public poaTokenMaster;
208 
209   // PoaCrowdsaleMaster logic contract used by proxies
210   address public poaCrowdsaleMaster;
211 
212   // Registry used for getting other contract addresses
213   address public registry;
214 
215   /***************************
216   * End Proxy Common Storage *
217   ***************************/
218 
219 
220   /*********************************
221   * Start Common Utility Functions *
222   *********************************/
223 
224   /// @notice Gets a given contract address by bytes32 in order to save gas
225   function getContractAddress
226   (
227     string _name
228   )
229     public
230     view
231     returns (address _contractAddress)
232   {
233     bytes4 _signature = bytes4(keccak256("getContractAddress32(bytes32)"));
234     bytes32 _name32 = keccak256(abi.encodePacked(_name));
235 
236     assembly {
237       let _registry := sload(registry_slot) // load registry address from storage
238       let _pointer := mload(0x40)          // Set _pointer to free memory pointer
239       mstore(_pointer, _signature)         // Store _signature at _pointer
240       mstore(add(_pointer, 0x04), _name32) // Store _name32 at _pointer offset by 4 bytes for pre-existing _signature
241 
242       // staticcall(g, a, in, insize, out, outsize) => returns 0 on error, 1 on success
243       let result := staticcall(
244         gas,       // g = gas: whatever was passed already
245         _registry, // a = address: address in storage
246         _pointer,  // in = mem in  mem[in..(in+insize): set to free memory pointer
247         0x24,      // insize = mem insize  mem[in..(in+insize): size of signature (bytes4) + bytes32 = 0x24
248         _pointer,  // out = mem out  mem[out..(out+outsize): output assigned to this storage address
249         0x20       // outsize = mem outsize  mem[out..(out+outsize): output should be 32byte slot (address size = 0x14 <  slot size 0x20)
250       )
251 
252       // revert if not successful
253       if iszero(result) {
254         revert(0, 0)
255       }
256 
257       _contractAddress := mload(_pointer) // Assign result to return value
258       mstore(0x40, add(_pointer, 0x24))   // Advance free memory pointer by largest _pointer size
259     }
260   }
261 
262   /*******************************
263   * End Common Utility Functions *
264   *******************************/
265 }
266 
267 // File: contracts/PoaProxy.sol
268 
269 /* solium-disable security/no-low-level-calls */
270 
271 pragma solidity 0.4.24;
272 
273 
274 
275 /**
276   @title This contract manages the storage of:
277   - PoaProxy
278   - PoaToken
279   - PoaCrowdsale
280 
281   @notice PoaProxy uses chained "delegatecall()"s to call functions on
282   PoaToken and PoaCrowdsale and sets the resulting storage
283   here on PoaProxy.
284 
285   @dev `getContractAddress("PoaLogger").call()` does not use the return value
286   because we would rather contract functions to continue even if the event
287   did not successfully trigger on the logger contract.
288 */
289 contract PoaProxy is PoaProxyCommon {
290   uint8 public constant version = 1;
291 
292   event ProxyUpgraded(address upgradedFrom, address upgradedTo);
293 
294   /**
295     @notice Stores addresses of our contract registry
296     as well as the PoaToken and PoaCrowdsale master
297     contracts to forward calls to.
298   */
299   constructor(
300     address _poaTokenMaster,
301     address _poaCrowdsaleMaster,
302     address _registry
303   )
304     public
305   {
306     // Ensure that none of the given addresses are empty
307     require(_poaTokenMaster != address(0));
308     require(_poaCrowdsaleMaster != address(0));
309     require(_registry != address(0));
310 
311     // Set addresses in common storage using deterministic storage slots
312     poaTokenMaster = _poaTokenMaster;
313     poaCrowdsaleMaster = _poaCrowdsaleMaster;
314     registry = _registry;
315   }
316 
317   /*****************************
318    * Start Proxy State Helpers *
319    *****************************/
320 
321   /**
322     @notice Ensures that a given address is a contract by
323     making sure it has code. Used during upgrading to make
324     sure the new addresses to upgrade to are smart contracts.
325    */
326   function isContract(address _address)
327     private
328     view
329     returns (bool)
330   {
331     uint256 _size;
332     assembly { _size := extcodesize(_address) }
333     return _size > 0;
334   }
335 
336   /***************************
337    * End Proxy State Helpers *
338    ***************************/
339 
340 
341   /*****************************
342    * Start Proxy State Setters *
343    *****************************/
344 
345   /// @notice Update the stored "poaTokenMaster" address to upgrade the PoaToken master contract
346   function proxyChangeTokenMaster(address _newMaster)
347     public
348     returns (bool)
349   {
350     require(msg.sender == getContractAddress("PoaManager"));
351     require(_newMaster != address(0));
352     require(poaTokenMaster != _newMaster);
353     require(isContract(_newMaster));
354     address _oldMaster = poaTokenMaster;
355     poaTokenMaster = _newMaster;
356 
357     emit ProxyUpgraded(_oldMaster, _newMaster);
358     getContractAddress("PoaLogger").call(
359       bytes4(keccak256("logProxyUpgraded(address,address)")),
360       _oldMaster, _newMaster
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
380       bytes4(keccak256("logProxyUpgraded(address,address)")),
381       _oldMaster, _newMaster
382     );
383 
384     return true;
385   }
386 
387   /***************************
388    * End Proxy State Setters *
389    ***************************/
390 
391   /**
392     @notice Fallback function for all proxied functions using "delegatecall()".
393     It will first forward all functions to the "poaTokenMaster" address. If the
394     called function isn't found there, then "poaTokenMaster"'s fallback function
395     will forward the call to "poaCrowdsale". If the called function also isn't
396     found there, it will fail at last.
397   */
398   function()
399     external
400     payable
401   {
402     assembly {
403       // Load PoaToken master address from first storage pointer
404       let _poaTokenMaster := sload(poaTokenMaster_slot)
405 
406       // calldatacopy(t, f, s)
407       calldatacopy(
408         0x0, // t = mem position to
409         0x0, // f = mem position from
410         calldatasize // s = size bytes
411       )
412 
413       // delegatecall(g, a, in, insize, out, outsize) => returns "0" on error, or "1" on success
414       let result := delegatecall(
415         gas, // g = gas
416         _poaTokenMaster, // a = address
417         0x0, // in = mem in  mem[in..(in+insize)
418         calldatasize, // insize = mem insize  mem[in..(in+insize)
419         0x0, // out = mem out  mem[out..(out+outsize)
420         0 // outsize = mem outsize  mem[out..(out+outsize)
421       )
422 
423       // Check if the call was successful
424       if iszero(result) {
425         // Revert if call failed
426         revert(0, 0)
427       }
428 
429       // returndatacopy(t, f, s)
430       returndatacopy(
431         0x0, // t = mem position to
432         0x0,  // f = mem position from
433         returndatasize // s = size bytes
434       )
435       // Return if call succeeded
436       return(
437         0x0,
438         returndatasize
439       )
440     }
441   }
442 }
443 
444 // File: contracts/PoaManager.sol
445 
446 contract PoaManager is Ownable {
447   using SafeMath for uint256;
448 
449   uint256 constant version = 1;
450 
451   IRegistry public registry;
452 
453   struct EntityState {
454     uint256 index;
455     bool active;
456   }
457 
458   // Keeping a list for addresses we track for easy access
459   address[] private brokerAddressList;
460   address[] private tokenAddressList;
461 
462   // A mapping for each address we track
463   mapping (address => EntityState) private tokenMap;
464   mapping (address => EntityState) private brokerMap;
465 
466   event BrokerAdded(address indexed broker);
467   event BrokerRemoved(address indexed broker);
468   event BrokerStatusChanged(address indexed broker, bool active);
469 
470   event TokenAdded(address indexed token);
471   event TokenRemoved(address indexed token);
472   event TokenStatusChanged(address indexed token, bool active);
473 
474   modifier isNewBroker(address _brokerAddress) {
475     require(_brokerAddress != address(0));
476     require(brokerMap[_brokerAddress].index == 0);
477     _;
478   }
479 
480   modifier onlyActiveBroker() {
481     EntityState memory entity = brokerMap[msg.sender];
482     require(entity.active);
483     _;
484   }
485 
486   constructor(
487     address _registryAddress
488   )
489     public
490   {
491     require(_registryAddress != address(0));
492     registry = IRegistry(_registryAddress);
493   }
494 
495   //
496   // Entity functions
497   //
498 
499   function doesEntityExist(address _entityAddress, EntityState entity)
500     private
501     pure
502     returns (bool)
503   {
504     return (_entityAddress != address(0) && entity.index != 0);
505   }
506 
507   function addEntity(
508     address _entityAddress,
509     address[] storage entityList,
510     bool _active
511   )
512     private
513     returns (EntityState)
514   {
515     entityList.push(_entityAddress);
516     // we do not offset by `-1` so that we never have `entity.index = 0` as this is what is
517     // used to check for existence in modifier [doesEntityExist]
518     uint256 index = entityList.length;
519     EntityState memory entity = EntityState(index, _active);
520     return entity;
521   }
522 
523   function removeEntity(
524     EntityState _entityToRemove,
525     address[] storage _entityList
526   )
527     private
528     returns (address, uint256)
529   {
530     // we offset by -1 here to account for how `addEntity` marks the `entity.index` value
531     uint256 index = _entityToRemove.index.sub(1);
532 
533     // swap the entity to be removed with the last element in the list
534     _entityList[index] = _entityList[_entityList.length - 1];
535 
536     // because we wanted seperate mappings for token and broker, and we cannot pass a storage mapping
537     // as a function argument, this abstraction is leaky; we return the address and index so the
538     // caller can update the mapping
539     address entityToSwapAddress = _entityList[index];
540 
541     // we do not need to delete the element, the compiler should clean up for us
542     _entityList.length--;
543 
544     return (entityToSwapAddress, _entityToRemove.index);
545   }
546 
547   function setEntityActiveValue(
548     EntityState storage entity,
549     bool _active
550   )
551     private
552   {
553     require(entity.active != _active);
554     entity.active = _active;
555   }
556 
557   //
558   // Broker functions
559   //
560 
561   // Return all tracked broker addresses
562   function getBrokerAddressList()
563     public
564     view
565     returns (address[])
566   {
567     return brokerAddressList;
568   }
569 
570   // Add a broker and set active value to true
571   function addBroker(address _brokerAddress)
572     public
573     onlyOwner
574     isNewBroker(_brokerAddress)
575   {
576     brokerMap[_brokerAddress] = addEntity(
577       _brokerAddress,
578       brokerAddressList,
579       true
580     );
581 
582     emit BrokerAdded(_brokerAddress);
583   }
584 
585   // Remove a broker
586   function removeBroker(address _brokerAddress)
587     public
588     onlyOwner
589   {
590     require(doesEntityExist(_brokerAddress, brokerMap[_brokerAddress]));
591 
592     address addressToUpdate;
593     uint256 indexUpdate;
594     (addressToUpdate, indexUpdate) = removeEntity(brokerMap[_brokerAddress], brokerAddressList);
595     brokerMap[addressToUpdate].index = indexUpdate;
596     delete brokerMap[_brokerAddress];
597 
598     emit BrokerRemoved(_brokerAddress);
599   }
600 
601   // Set previously delisted broker to listed
602   function listBroker(address _brokerAddress)
603     public
604     onlyOwner
605   {
606     require(doesEntityExist(_brokerAddress, brokerMap[_brokerAddress]));
607 
608     setEntityActiveValue(brokerMap[_brokerAddress], true);
609     emit BrokerStatusChanged(_brokerAddress, true);
610   }
611 
612   // Set previously listed broker to delisted
613   function delistBroker(address _brokerAddress)
614     public
615     onlyOwner
616   {
617     require(doesEntityExist(_brokerAddress, brokerMap[_brokerAddress]));
618 
619     setEntityActiveValue(brokerMap[_brokerAddress], false);
620     emit BrokerStatusChanged(_brokerAddress, false);
621   }
622 
623   function getBrokerStatus(address _brokerAddress)
624     public
625     view
626     returns (bool)
627   {
628     require(doesEntityExist(_brokerAddress, brokerMap[_brokerAddress]));
629 
630     return brokerMap[_brokerAddress].active;
631   }
632 
633   function isRegisteredBroker(address _brokerAddress)
634     external
635     view
636     returns (bool)
637   {
638     return doesEntityExist(_brokerAddress, brokerMap[_brokerAddress]);
639   }
640 
641   //
642   // Token functions
643   //
644 
645   // Return all tracked token addresses
646   function getTokenAddressList()
647     public
648     view
649     returns (address[])
650   {
651     return tokenAddressList;
652   }
653 
654   function createPoaTokenProxy()
655     private
656     returns (address _proxyContract)
657   {
658     address _poaTokenMaster = registry.getContractAddress("PoaTokenMaster");
659     address _poaCrowdsaleMaster = registry.getContractAddress("PoaCrowdsaleMaster");
660     _proxyContract = new PoaProxy(_poaTokenMaster, _poaCrowdsaleMaster, address(registry));
661   }
662 
663   /**
664     @notice Creates a PoaToken contract with given parameters, and set active value to false
665     @param _fiatCurrency32 Fiat symbol used in ExchangeRates
666     @param _startTimeForFundingPeriod Given as unix time in seconds since 01.01.1970
667     @param _durationForFiatFundingPeriod How long fiat funding can last, given in seconds
668     @param _durationForEthFundingPeriod How long eth funding can last, given in seconds
669     @param _durationForActivationPeriod How long a custodian has to activate token, given in seconds
670     @param _fundingGoalInCents Given as fiat cents
671    */
672   function addToken
673   (
674     bytes32 _name32,
675     bytes32 _symbol32,
676     bytes32 _fiatCurrency32,
677     address _custodian,
678     uint256 _totalSupply,
679     uint256 _startTimeForFundingPeriod,
680     uint256 _durationForFiatFundingPeriod,
681     uint256 _durationForEthFundingPeriod,
682     uint256 _durationForActivationPeriod,
683     uint256 _fundingGoalInCents
684   )
685     public
686     onlyActiveBroker
687     returns (address)
688   {
689     address _tokenAddress = createPoaTokenProxy();
690 
691     IPoaToken(_tokenAddress).initializeToken(
692       _name32,
693       _symbol32,
694       msg.sender,
695       _custodian,
696       registry,
697       _totalSupply
698     );
699 
700     IPoaCrowdsale(_tokenAddress).initializeCrowdsale(
701       _fiatCurrency32,
702       _startTimeForFundingPeriod,
703       _durationForFiatFundingPeriod,
704       _durationForEthFundingPeriod,
705       _durationForActivationPeriod,
706       _fundingGoalInCents
707     );
708 
709     tokenMap[_tokenAddress] = addEntity(
710       _tokenAddress,
711       tokenAddressList,
712       false
713     );
714 
715     emit TokenAdded(_tokenAddress);
716 
717     return _tokenAddress;
718   }
719 
720   // Remove a token
721   function removeToken(address _tokenAddress)
722     public
723     onlyOwner
724   {
725     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
726 
727     address addressToUpdate;
728     uint256 indexUpdate;
729     (addressToUpdate, indexUpdate) = removeEntity(tokenMap[_tokenAddress], tokenAddressList);
730     tokenMap[addressToUpdate].index = indexUpdate;
731     delete tokenMap[_tokenAddress];
732 
733     emit TokenRemoved(_tokenAddress);
734   }
735 
736   // Set previously delisted token to listed
737   function listToken(address _tokenAddress)
738     public
739     onlyOwner
740   {
741     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
742 
743     setEntityActiveValue(tokenMap[_tokenAddress], true);
744     emit TokenStatusChanged(_tokenAddress, true);
745   }
746 
747   // Set previously listed token to delisted
748   function delistToken(address _tokenAddress)
749     public
750     onlyOwner
751   {
752     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
753 
754     setEntityActiveValue(tokenMap[_tokenAddress], false);
755     emit TokenStatusChanged(_tokenAddress, false);
756   }
757 
758   function getTokenStatus(address _tokenAddress)
759     public
760     view
761     returns (bool)
762   {
763     require(doesEntityExist(_tokenAddress, tokenMap[_tokenAddress]));
764 
765     return tokenMap[_tokenAddress].active;
766   }
767 
768   //
769   // Token onlyOwner functions as PoaManger is `owner` of all PoaToken
770   //
771 
772   // Allow unpausing a listed PoaToken
773   function pauseToken(address _tokenAddress)
774     public
775     onlyOwner
776   {
777     IPoaToken(_tokenAddress).pause();
778   }
779 
780   // Allow unpausing a listed PoaToken
781   function unpauseToken(IPoaToken _tokenAddress)
782     public
783     onlyOwner
784   {
785     _tokenAddress.unpause();
786   }
787 
788   // Allow terminating a listed PoaToken
789   function terminateToken(IPoaToken _tokenAddress)
790     public
791     onlyOwner
792   {
793     _tokenAddress.terminate();
794   }
795 
796   // upgrade an existing PoaToken proxy to what is stored in ContractRegistry
797   function upgradeToken(
798     PoaProxy _proxyToken
799   )
800     external
801     onlyOwner
802     returns (bool)
803   {
804     _proxyToken.proxyChangeTokenMaster(
805       registry.getContractAddress("PoaTokenMaster")
806     );
807   }
808 
809   // upgrade an existing PoaCrowdsale proxy to what is stored in ContractRegistry
810   function upgradeCrowdsale(
811     PoaProxy _proxyToken
812   )
813     external
814     onlyOwner
815     returns (bool)
816   {
817     _proxyToken.proxyChangeCrowdsaleMaster(
818       registry.getContractAddress("PoaCrowdsaleMaster")
819     );
820   }
821 }