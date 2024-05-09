1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Utility contract to allow pausing and unpausing of certain functions
5  */
6 contract Pausable {
7 
8     event Pause(uint256 _timestammp);
9     event Unpause(uint256 _timestamp);
10 
11     bool public paused = false;
12 
13     /**
14     * @notice Modifier to make a function callable only when the contract is not paused.
15     */
16     modifier whenNotPaused() {
17         require(!paused, "Contract is paused");
18         _;
19     }
20 
21     /**
22     * @notice Modifier to make a function callable only when the contract is paused.
23     */
24     modifier whenPaused() {
25         require(paused, "Contract is not paused");
26         _;
27     }
28 
29    /**
30     * @notice Called by the owner to pause, triggers stopped state
31     */
32     function _pause() internal whenNotPaused {
33         paused = true;
34         /*solium-disable-next-line security/no-block-members*/
35         emit Pause(now);
36     }
37 
38     /**
39     * @notice Called by the owner to unpause, returns to normal state
40     */
41     function _unpause() internal whenPaused {
42         paused = false;
43         /*solium-disable-next-line security/no-block-members*/
44         emit Unpause(now);
45     }
46 
47 }
48 
49 /**
50  * @title Interface that every module contract should implement
51  */
52 interface IModule {
53 
54     /**
55      * @notice This function returns the signature of configure function
56      */
57     function getInitFunction() external pure returns (bytes4);
58 
59     /**
60      * @notice Return the permission flags that are associated with a module
61      */
62     function getPermissions() external view returns(bytes32[]);
63 
64     /**
65      * @notice Used to withdraw the fee by the factory owner
66      */
67     function takeFee(uint256 _amount) external returns(bool);
68 
69 }
70 
71 /**
72  * @title Interface for all security tokens
73  */
74 interface ISecurityToken {
75 
76     // Standard ERC20 interface
77     function decimals() external view returns (uint8);
78     function totalSupply() external view returns (uint256);
79     function balanceOf(address _owner) external view returns (uint256);
80     function allowance(address _owner, address _spender) external view returns (uint256);
81     function transfer(address _to, uint256 _value) external returns (bool);
82     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
83     function approve(address _spender, uint256 _value) external returns (bool);
84     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
85     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 
89     //transfer, transferFrom must respect the result of verifyTransfer
90     function verifyTransfer(address _from, address _to, uint256 _value) external returns (bool success);
91 
92     /**
93      * @notice Mints new tokens and assigns them to the target _investor.
94      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
95      * @param _investor Address the tokens will be minted to
96      * @param _value is the amount of tokens that will be minted to the investor
97      */
98     function mint(address _investor, uint256 _value) external returns (bool success);
99 
100     /**
101      * @notice Mints new tokens and assigns them to the target _investor.
102      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
103      * @param _investor Address the tokens will be minted to
104      * @param _value is The amount of tokens that will be minted to the investor
105      * @param _data Data to indicate validation
106      */
107     function mintWithData(address _investor, uint256 _value, bytes _data) external returns (bool success);
108 
109     /**
110      * @notice Used to burn the securityToken on behalf of someone else
111      * @param _from Address for whom to burn tokens
112      * @param _value No. of tokens to be burned
113      * @param _data Data to indicate validation
114      */
115     function burnFromWithData(address _from, uint256 _value, bytes _data) external;
116 
117     /**
118      * @notice Used to burn the securityToken
119      * @param _value No. of tokens to be burned
120      * @param _data Data to indicate validation
121      */
122     function burnWithData(uint256 _value, bytes _data) external;
123 
124     event Minted(address indexed _to, uint256 _value);
125     event Burnt(address indexed _burner, uint256 _value);
126 
127     // Permissions this to a Permission module, which has a key of 1
128     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
129     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
130     function checkPermission(address _delegate, address _module, bytes32 _perm) external view returns (bool);
131 
132     /**
133      * @notice Returns module list for a module type
134      * @param _module Address of the module
135      * @return bytes32 Name
136      * @return address Module address
137      * @return address Module factory address
138      * @return bool Module archived
139      * @return uint8 Module type
140      * @return uint256 Module index
141      * @return uint256 Name index
142 
143      */
144     function getModule(address _module) external view returns(bytes32, address, address, bool, uint8, uint256, uint256);
145 
146     /**
147      * @notice Returns module list for a module name
148      * @param _name Name of the module
149      * @return address[] List of modules with this name
150      */
151     function getModulesByName(bytes32 _name) external view returns (address[]);
152 
153     /**
154      * @notice Returns module list for a module type
155      * @param _type Type of the module
156      * @return address[] List of modules with this type
157      */
158     function getModulesByType(uint8 _type) external view returns (address[]);
159 
160     /**
161      * @notice Queries totalSupply at a specified checkpoint
162      * @param _checkpointId Checkpoint ID to query as of
163      */
164     function totalSupplyAt(uint256 _checkpointId) external view returns (uint256);
165 
166     /**
167      * @notice Queries balance at a specified checkpoint
168      * @param _investor Investor to query balance for
169      * @param _checkpointId Checkpoint ID to query as of
170      */
171     function balanceOfAt(address _investor, uint256 _checkpointId) external view returns (uint256);
172 
173     /**
174      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
175      */
176     function createCheckpoint() external returns (uint256);
177 
178     /**
179      * @notice Gets length of investors array
180      * NB - this length may differ from investorCount if the list has not been pruned of zero-balance investors
181      * @return Length
182      */
183     function getInvestors() external view returns (address[]);
184 
185     /**
186      * @notice returns an array of investors at a given checkpoint
187      * NB - this length may differ from investorCount as it contains all investors that ever held tokens
188      * @param _checkpointId Checkpoint id at which investor list is to be populated
189      * @return list of investors
190      */
191     function getInvestorsAt(uint256 _checkpointId) external view returns(address[]);
192 
193     /**
194      * @notice generates subset of investors
195      * NB - can be used in batches if investor list is large
196      * @param _start Position of investor to start iteration from
197      * @param _end Position of investor to stop iteration at
198      * @return list of investors
199      */
200     function iterateInvestors(uint256 _start, uint256 _end) external view returns(address[]);
201     
202     /**
203      * @notice Gets current checkpoint ID
204      * @return Id
205      */
206     function currentCheckpointId() external view returns (uint256);
207 
208     /**
209     * @notice Gets an investor at a particular index
210     * @param _index Index to return address from
211     * @return Investor address
212     */
213     function investors(uint256 _index) external view returns (address);
214 
215    /**
216     * @notice Allows the owner to withdraw unspent POLY stored by them on the ST or any ERC20 token.
217     * @dev Owner can transfer POLY to the ST which will be used to pay for modules that require a POLY fee.
218     * @param _tokenContract Address of the ERC20Basic compliance token
219     * @param _value Amount of POLY to withdraw
220     */
221     function withdrawERC20(address _tokenContract, uint256 _value) external;
222 
223     /**
224     * @notice Allows owner to approve more POLY to one of the modules
225     * @param _module Module address
226     * @param _budget New budget
227     */
228     function changeModuleBudget(address _module, uint256 _budget) external;
229 
230     /**
231      * @notice Changes the tokenDetails
232      * @param _newTokenDetails New token details
233      */
234     function updateTokenDetails(string _newTokenDetails) external;
235 
236     /**
237     * @notice Allows the owner to change token granularity
238     * @param _granularity Granularity level of the token
239     */
240     function changeGranularity(uint256 _granularity) external;
241 
242     /**
243     * @notice Removes addresses with zero balances from the investors list
244     * @param _start Index in investors list at which to start removing zero balances
245     * @param _iters Max number of iterations of the for loop
246     * NB - pruning this list will mean you may not be able to iterate over investors on-chain as of a historical checkpoint
247     */
248     function pruneInvestors(uint256 _start, uint256 _iters) external;
249 
250     /**
251      * @notice Freezes all the transfers
252      */
253     function freezeTransfers() external;
254 
255     /**
256      * @notice Un-freezes all the transfers
257      */
258     function unfreezeTransfers() external;
259 
260     /**
261      * @notice Ends token minting period permanently
262      */
263     function freezeMinting() external;
264 
265     /**
266      * @notice Mints new tokens and assigns them to the target investors.
267      * Can only be called by the STO attached to the token or by the Issuer (Security Token contract owner)
268      * @param _investors A list of addresses to whom the minted tokens will be delivered
269      * @param _values A list of the amount of tokens to mint to corresponding addresses from _investor[] list
270      * @return Success
271      */
272     function mintMulti(address[] _investors, uint256[] _values) external returns (bool success);
273 
274     /**
275      * @notice Function used to attach a module to the security token
276      * @dev  E.G.: On deployment (through the STR) ST gets a TransferManager module attached to it
277      * @dev to control restrictions on transfers.
278      * @dev You are allowed to add a new moduleType if:
279      * @dev - there is no existing module of that type yet added
280      * @dev - the last member of the module list is replacable
281      * @param _moduleFactory is the address of the module factory to be added
282      * @param _data is data packed into bytes used to further configure the module (See STO usage)
283      * @param _maxCost max amount of POLY willing to pay to module. (WIP)
284      */
285     function addModule(
286         address _moduleFactory,
287         bytes _data,
288         uint256 _maxCost,
289         uint256 _budget
290     ) external;
291 
292     /**
293     * @notice Archives a module attached to the SecurityToken
294     * @param _module address of module to archive
295     */
296     function archiveModule(address _module) external;
297 
298     /**
299     * @notice Unarchives a module attached to the SecurityToken
300     * @param _module address of module to unarchive
301     */
302     function unarchiveModule(address _module) external;
303 
304     /**
305     * @notice Removes a module attached to the SecurityToken
306     * @param _module address of module to archive
307     */
308     function removeModule(address _module) external;
309 
310     /**
311      * @notice Used by the issuer to set the controller addresses
312      * @param _controller address of the controller
313      */
314     function setController(address _controller) external;
315 
316     /**
317      * @notice Used by a controller to execute a forced transfer
318      * @param _from address from which to take tokens
319      * @param _to address where to send tokens
320      * @param _value amount of tokens to transfer
321      * @param _data data to indicate validation
322      * @param _log data attached to the transfer by controller to emit in event
323      */
324     function forceTransfer(address _from, address _to, uint256 _value, bytes _data, bytes _log) external;
325 
326     /**
327      * @notice Used by a controller to execute a foced burn
328      * @param _from address from which to take tokens
329      * @param _value amount of tokens to transfer
330      * @param _data data to indicate validation
331      * @param _log data attached to the transfer by controller to emit in event
332      */
333     function forceBurn(address _from, uint256 _value, bytes _data, bytes _log) external;
334 
335     /**
336      * @notice Used by the issuer to permanently disable controller functionality
337      * @dev enabled via feature switch "disableControllerAllowed"
338      */
339      function disableController() external;
340 
341      /**
342      * @notice Used to get the version of the securityToken
343      */
344      function getVersion() external view returns(uint8[]);
345 
346      /**
347      * @notice Gets the investor count
348      */
349      function getInvestorCount() external view returns(uint256);
350 
351      /**
352       * @notice Overloaded version of the transfer function
353       * @param _to receiver of transfer
354       * @param _value value of transfer
355       * @param _data data to indicate validation
356       * @return bool success
357       */
358      function transferWithData(address _to, uint256 _value, bytes _data) external returns (bool success);
359 
360      /**
361       * @notice Overloaded version of the transferFrom function
362       * @param _from sender of transfer
363       * @param _to receiver of transfer
364       * @param _value value of transfer
365       * @param _data data to indicate validation
366       * @return bool success
367       */
368      function transferFromWithData(address _from, address _to, uint256 _value, bytes _data) external returns(bool);
369 
370      /**
371       * @notice Provides the granularity of the token
372       * @return uint256
373       */
374      function granularity() external view returns(uint256);
375 }
376 
377 /**
378  * @title ERC20 interface
379  * @dev see https://github.com/ethereum/EIPs/issues/20
380  */
381 interface IERC20 {
382     function decimals() external view returns (uint8);
383     function totalSupply() external view returns (uint256);
384     function balanceOf(address _owner) external view returns (uint256);
385     function allowance(address _owner, address _spender) external view returns (uint256);
386     function transfer(address _to, uint256 _value) external returns (bool);
387     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
388     function approve(address _spender, uint256 _value) external returns (bool);
389     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
390     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
391     event Transfer(address indexed from, address indexed to, uint256 value);
392     event Approval(address indexed owner, address indexed spender, uint256 value);
393 }
394 
395 /**
396  * @title Ownable
397  * @dev The Ownable contract has an owner address, and provides basic authorization control
398  * functions, this simplifies the implementation of "user permissions".
399  */
400 contract Ownable {
401   address public owner;
402 
403 
404   event OwnershipRenounced(address indexed previousOwner);
405   event OwnershipTransferred(
406     address indexed previousOwner,
407     address indexed newOwner
408   );
409 
410 
411   /**
412    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
413    * account.
414    */
415   constructor() public {
416     owner = msg.sender;
417   }
418 
419   /**
420    * @dev Throws if called by any account other than the owner.
421    */
422   modifier onlyOwner() {
423     require(msg.sender == owner);
424     _;
425   }
426 
427   /**
428    * @dev Allows the current owner to relinquish control of the contract.
429    */
430   function renounceOwnership() public onlyOwner {
431     emit OwnershipRenounced(owner);
432     owner = address(0);
433   }
434 
435   /**
436    * @dev Allows the current owner to transfer control of the contract to a newOwner.
437    * @param _newOwner The address to transfer ownership to.
438    */
439   function transferOwnership(address _newOwner) public onlyOwner {
440     _transferOwnership(_newOwner);
441   }
442 
443   /**
444    * @dev Transfers control of the contract to a newOwner.
445    * @param _newOwner The address to transfer ownership to.
446    */
447   function _transferOwnership(address _newOwner) internal {
448     require(_newOwner != address(0));
449     emit OwnershipTransferred(owner, _newOwner);
450     owner = _newOwner;
451   }
452 }
453 
454 /**
455  * @title Interface that any module contract should implement
456  * @notice Contract is abstract
457  */
458 contract Module is IModule {
459 
460     address public factory;
461 
462     address public securityToken;
463 
464     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
465 
466     IERC20 public polyToken;
467 
468     /**
469      * @notice Constructor
470      * @param _securityToken Address of the security token
471      * @param _polyAddress Address of the polytoken
472      */
473     constructor (address _securityToken, address _polyAddress) public {
474         securityToken = _securityToken;
475         factory = msg.sender;
476         polyToken = IERC20(_polyAddress);
477     }
478 
479     //Allows owner, factory or permissioned delegate
480     modifier withPerm(bytes32 _perm) {
481         bool isOwner = msg.sender == Ownable(securityToken).owner();
482         bool isFactory = msg.sender == factory;
483         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
484         _;
485     }
486 
487     modifier onlyOwner {
488         require(msg.sender == Ownable(securityToken).owner(), "Sender is not owner");
489         _;
490     }
491 
492     modifier onlyFactory {
493         require(msg.sender == factory, "Sender is not factory");
494         _;
495     }
496 
497     modifier onlyFactoryOwner {
498         require(msg.sender == Ownable(factory).owner(), "Sender is not factory owner");
499         _;
500     }
501 
502     modifier onlyFactoryOrOwner {
503         require((msg.sender == Ownable(securityToken).owner()) || (msg.sender == factory), "Sender is not factory or owner");
504         _;
505     }
506 
507     /**
508      * @notice used to withdraw the fee by the factory owner
509      */
510     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
511         require(polyToken.transferFrom(securityToken, Ownable(factory).owner(), _amount), "Unable to take fee");
512         return true;
513     }
514 }
515 
516 /**
517  * @title SafeMath
518  * @dev Math operations with safety checks that throw on error
519  */
520 library SafeMath {
521 
522   /**
523   * @dev Multiplies two numbers, throws on overflow.
524   */
525   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
526     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
527     // benefit is lost if 'b' is also tested.
528     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
529     if (a == 0) {
530       return 0;
531     }
532 
533     c = a * b;
534     assert(c / a == b);
535     return c;
536   }
537 
538   /**
539   * @dev Integer division of two numbers, truncating the quotient.
540   */
541   function div(uint256 a, uint256 b) internal pure returns (uint256) {
542     // assert(b > 0); // Solidity automatically throws when dividing by 0
543     // uint256 c = a / b;
544     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
545     return a / b;
546   }
547 
548   /**
549   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
550   */
551   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
552     assert(b <= a);
553     return a - b;
554   }
555 
556   /**
557   * @dev Adds two numbers, throws on overflow.
558   */
559   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
560     c = a + b;
561     assert(c >= a);
562     return c;
563   }
564 }
565 
566 /**
567  * @title Interface to be implemented by all STO modules
568  */
569 contract ISTO is Module, Pausable  {
570     using SafeMath for uint256;
571 
572     enum FundRaiseType { ETH, POLY, DAI }
573     mapping (uint8 => bool) public fundRaiseTypes;
574     mapping (uint8 => uint256) public fundsRaised;
575 
576     // Start time of the STO
577     uint256 public startTime;
578     // End time of the STO
579     uint256 public endTime;
580     // Time STO was paused
581     uint256 public pausedTime;
582     // Number of individual investors
583     uint256 public investorCount;
584     // Address where ETH & POLY funds are delivered
585     address public wallet;
586      // Final amount of tokens sold
587     uint256 public totalTokensSold;
588 
589     // Event
590     event SetFundRaiseTypes(FundRaiseType[] _fundRaiseTypes);
591 
592     /**
593     * @notice Reclaims ERC20Basic compatible tokens
594     * @dev We duplicate here due to the overriden owner & onlyOwner
595     * @param _tokenContract The address of the token contract
596     */
597     function reclaimERC20(address _tokenContract) external onlyOwner {
598         require(_tokenContract != address(0), "Invalid address");
599         IERC20 token = IERC20(_tokenContract);
600         uint256 balance = token.balanceOf(address(this));
601         require(token.transfer(msg.sender, balance), "Transfer failed");
602     }
603 
604     /**
605      * @notice Returns funds raised by the STO
606      */
607     function getRaised(FundRaiseType _fundRaiseType) public view returns (uint256) {
608         return fundsRaised[uint8(_fundRaiseType)];
609     }
610 
611     /**
612      * @notice Returns the total no. of tokens sold
613      */
614     function getTokensSold() public view returns (uint256);
615 
616     /**
617      * @notice Pause (overridden function)
618      */
619     function pause() public onlyOwner {
620         /*solium-disable-next-line security/no-block-members*/
621         require(now < endTime, "STO has been finalized");
622         super._pause();
623     }
624 
625     /**
626      * @notice Unpause (overridden function)
627      */
628     function unpause() public onlyOwner {
629         super._unpause();
630     }
631 
632     function _setFundRaiseType(FundRaiseType[] _fundRaiseTypes) internal {
633         // FundRaiseType[] parameter type ensures only valid values for _fundRaiseTypes
634         require(_fundRaiseTypes.length > 0, "Raise type is not specified");
635         fundRaiseTypes[uint8(FundRaiseType.ETH)] = false;
636         fundRaiseTypes[uint8(FundRaiseType.POLY)] = false;
637         fundRaiseTypes[uint8(FundRaiseType.DAI)] = false;
638         for (uint8 j = 0; j < _fundRaiseTypes.length; j++) {
639             fundRaiseTypes[uint8(_fundRaiseTypes[j])] = true;
640         }
641         emit SetFundRaiseTypes(_fundRaiseTypes);
642     }
643 
644 }
645 
646 interface IOracle {
647 
648     /**
649     * @notice Returns address of oracle currency (0x0 for ETH)
650     */
651     function getCurrencyAddress() external view returns(address);
652 
653     /**
654     * @notice Returns symbol of oracle currency (0x0 for ETH)
655     */
656     function getCurrencySymbol() external view returns(bytes32);
657 
658     /**
659     * @notice Returns denomination of price
660     */
661     function getCurrencyDenominated() external view returns(bytes32);
662 
663     /**
664     * @notice Returns price - should throw if not valid
665     */
666     function getPrice() external view returns(uint256);
667 
668 }
669 
670 /**
671  * @title Utility contract to allow owner to retreive any ERC20 sent to the contract
672  */
673 contract ReclaimTokens is Ownable {
674 
675     /**
676     * @notice Reclaim all ERC20Basic compatible tokens
677     * @param _tokenContract The address of the token contract
678     */
679     function reclaimERC20(address _tokenContract) external onlyOwner {
680         require(_tokenContract != address(0), "Invalid address");
681         IERC20 token = IERC20(_tokenContract);
682         uint256 balance = token.balanceOf(address(this));
683         require(token.transfer(owner, balance), "Transfer failed");
684     }
685 }
686 
687 /**
688  * @title Core functionality for registry upgradability
689  */
690 contract PolymathRegistry is ReclaimTokens {
691 
692     mapping (bytes32 => address) public storedAddresses;
693 
694     event ChangeAddress(string _nameKey, address indexed _oldAddress, address indexed _newAddress);
695 
696     /**
697      * @notice Gets the contract address
698      * @param _nameKey is the key for the contract address mapping
699      * @return address
700      */
701     function getAddress(string _nameKey) external view returns(address) {
702         bytes32 key = keccak256(bytes(_nameKey));
703         require(storedAddresses[key] != address(0), "Invalid address key");
704         return storedAddresses[key];
705     }
706 
707     /**
708      * @notice Changes the contract address
709      * @param _nameKey is the key for the contract address mapping
710      * @param _newAddress is the new contract address
711      */
712     function changeAddress(string _nameKey, address _newAddress) external onlyOwner {
713         bytes32 key = keccak256(bytes(_nameKey));
714         emit ChangeAddress(_nameKey, storedAddresses[key], _newAddress);
715         storedAddresses[key] = _newAddress;
716     }
717 
718 
719 }
720 
721 contract RegistryUpdater is Ownable {
722 
723     address public polymathRegistry;
724     address public moduleRegistry;
725     address public securityTokenRegistry;
726     address public featureRegistry;
727     address public polyToken;
728 
729     constructor (address _polymathRegistry) public {
730         require(_polymathRegistry != address(0), "Invalid address");
731         polymathRegistry = _polymathRegistry;
732     }
733 
734     function updateFromRegistry() public onlyOwner {
735         moduleRegistry = PolymathRegistry(polymathRegistry).getAddress("ModuleRegistry");
736         securityTokenRegistry = PolymathRegistry(polymathRegistry).getAddress("SecurityTokenRegistry");
737         featureRegistry = PolymathRegistry(polymathRegistry).getAddress("FeatureRegistry");
738         polyToken = PolymathRegistry(polymathRegistry).getAddress("PolyToken");
739     }
740 
741 }
742 
743 library DecimalMath {
744 
745     using SafeMath for uint256;
746 
747      /**
748      * @notice This function multiplies two decimals represented as (decimal * 10**DECIMALS)
749      * @return uint256 Result of multiplication represented as (decimal * 10**DECIMALS)
750      */
751     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
752         z = SafeMath.add(SafeMath.mul(x, y), (10 ** 18) / 2) / (10 ** 18);
753     }
754 
755     /**
756      * @notice This function divides two decimals represented as (decimal * 10**DECIMALS)
757      * @return uint256 Result of division represented as (decimal * 10**DECIMALS)
758      */
759     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
760         z = SafeMath.add(SafeMath.mul(x, (10 ** 18)), y / 2) / y;
761     }
762 
763 }
764 
765 /**
766  * @title Helps contracts guard agains reentrancy attacks.
767  * @author Remco Bloemen <remco@2π.com>
768  * @notice If you mark a function `nonReentrant`, you should also
769  * mark it `external`.
770  */
771 contract ReentrancyGuard {
772 
773   /**
774    * @dev We use a single lock for the whole contract.
775    */
776   bool private reentrancyLock = false;
777 
778   /**
779    * @dev Prevents a contract from calling itself, directly or indirectly.
780    * @notice If you mark a function `nonReentrant`, you should also
781    * mark it `external`. Calling one nonReentrant function from
782    * another is not supported. Instead, you can implement a
783    * `private` function doing the actual work, and a `external`
784    * wrapper marked as `nonReentrant`.
785    */
786   modifier nonReentrant() {
787     require(!reentrancyLock);
788     reentrancyLock = true;
789     _;
790     reentrancyLock = false;
791   }
792 
793 }
794 
795 /**
796  * @title STO module for standard capped crowdsale
797  */
798 contract USDTieredSTO is ISTO, ReentrancyGuard {
799     using SafeMath for uint256;
800 
801     /////////////
802     // Storage //
803     /////////////
804 
805     string public POLY_ORACLE = "PolyUsdOracle";
806     string public ETH_ORACLE = "EthUsdOracle";
807     mapping (bytes32 => mapping (bytes32 => string)) oracleKeys;
808 
809     IERC20 public usdToken;
810 
811     // Determine whether users can invest on behalf of a beneficiary
812     bool public allowBeneficialInvestments = false;
813 
814     // Address where ETH, POLY & DAI funds are delivered
815     address public wallet;
816 
817     // Address of issuer reserve wallet for unsold tokens
818     address public reserveWallet;
819 
820     // How many token units a buyer gets per USD per tier (multiplied by 10**18)
821     uint256[] public ratePerTier;
822 
823     // How many token units a buyer gets per USD per tier (multiplied by 10**18) when investing in POLY up to tokensPerTierDiscountPoly
824     uint256[] public ratePerTierDiscountPoly;
825 
826     // How many tokens are available in each tier (relative to totalSupply)
827     uint256[] public tokensPerTierTotal;
828 
829     // How many token units are available in each tier (relative to totalSupply) at the ratePerTierDiscountPoly rate
830     uint256[] public tokensPerTierDiscountPoly;
831 
832     // How many tokens have been minted in each tier (relative to totalSupply)
833     uint256[] public mintedPerTierTotal;
834 
835     // How many tokens have been minted in each tier (relative to totalSupply) for each fund raise type
836     mapping (uint8 => uint256[]) public mintedPerTier;
837 
838     // How many tokens have been minted in each tier (relative to totalSupply) at discounted POLY rate
839     uint256[] public mintedPerTierDiscountPoly;
840 
841     // Current tier
842     uint8 public currentTier;
843 
844     // Amount of USD funds raised
845     uint256 public fundsRaisedUSD;
846 
847     // Amount in USD invested by each address
848     mapping (address => uint256) public investorInvestedUSD;
849 
850     // Amount in fund raise type invested by each investor
851     mapping (address => mapping (uint8 => uint256)) public investorInvested;
852 
853     // List of accredited investors
854     mapping (address => bool) public accredited;
855 
856     // Default limit in USD for non-accredited investors multiplied by 10**18
857     uint256 public nonAccreditedLimitUSD;
858 
859     // Overrides for default limit in USD for non-accredited investors multiplied by 10**18
860     mapping (address => uint256) public nonAccreditedLimitUSDOverride;
861 
862     // Minimum investable amount in USD
863     uint256 public minimumInvestmentUSD;
864 
865     // Whether or not the STO has been finalized
866     bool public isFinalized;
867 
868     // Final amount of tokens returned to issuer
869     uint256 public finalAmountReturned;
870 
871     ////////////
872     // Events //
873     ////////////
874 
875     event SetAllowBeneficialInvestments(bool _allowed);
876     event SetNonAccreditedLimit(address _investor, uint256 _limit);
877     event SetAccredited(address _investor, bool _accredited);
878     event TokenPurchase(
879         address indexed _purchaser,
880         address indexed _beneficiary,
881         uint256 _tokens,
882         uint256 _usdAmount,
883         uint256 _tierPrice,
884         uint8 _tier
885     );
886     event FundsReceived(
887         address indexed _purchaser,
888         address indexed _beneficiary,
889         uint256 _usdAmount,
890         FundRaiseType _fundRaiseType,
891         uint256 _receivedValue,
892         uint256 _spentValue,
893         uint256 _rate
894     );
895     event FundsReceivedPOLY(
896         address indexed _purchaser,
897         address indexed _beneficiary,
898         uint256 _usdAmount,
899         uint256 _receivedValue,
900         uint256 _spentValue,
901         uint256 _rate
902     );
903     event ReserveTokenMint(address indexed _owner, address indexed _wallet, uint256 _tokens, uint8 _latestTier);
904 
905     event SetAddresses(
906         address indexed _wallet,
907         address indexed _reserveWallet,
908         address indexed _usdToken
909     );
910     event SetLimits(
911         uint256 _nonAccreditedLimitUSD,
912         uint256 _minimumInvestmentUSD
913     );
914     event SetTimes(
915         uint256 _startTime,
916         uint256 _endTime
917     );
918     event SetTiers(
919         uint256[] _ratePerTier,
920         uint256[] _ratePerTierDiscountPoly,
921         uint256[] _tokensPerTierTotal,
922         uint256[] _tokensPerTierDiscountPoly
923     );
924 
925     ///////////////
926     // Modifiers //
927     ///////////////
928 
929     modifier validETH {
930         require(_getOracle(bytes32("ETH"), bytes32("USD")) != address(0), "Invalid ETHUSD Oracle");
931         require(fundRaiseTypes[uint8(FundRaiseType.ETH)], "Fund raise in ETH should be allowed");
932         _;
933     }
934 
935     modifier validPOLY {
936         require(_getOracle(bytes32("POLY"), bytes32("USD")) != address(0), "Invalid POLYUSD Oracle");
937         require(fundRaiseTypes[uint8(FundRaiseType.POLY)], "Fund raise in POLY should be allowed");
938         _;
939     }
940 
941     modifier validDAI {
942         require(fundRaiseTypes[uint8(FundRaiseType.DAI)], "Fund raise in DAI should be allowed");
943         _;
944     }
945 
946     ///////////////////////
947     // STO Configuration //
948     ///////////////////////
949 
950     constructor (address _securityToken, address _polyAddress, address _factory) public Module(_securityToken, _polyAddress) {
951         oracleKeys[bytes32("ETH")][bytes32("USD")] = ETH_ORACLE;
952         oracleKeys[bytes32("POLY")][bytes32("USD")] = POLY_ORACLE;
953         require(_factory != address(0), "In-valid address");
954         factory = _factory;
955     }
956 
957     /**
958      * @notice Function used to intialize the contract variables
959      * @param _startTime Unix timestamp at which offering get started
960      * @param _endTime Unix timestamp at which offering get ended
961      * @param _ratePerTier Rate (in USD) per tier (* 10**18)
962      * @param _tokensPerTierTotal Tokens available in each tier
963      * @param _nonAccreditedLimitUSD Limit in USD (* 10**18) for non-accredited investors
964      * @param _minimumInvestmentUSD Minimun investment in USD (* 10**18)
965      * @param _fundRaiseTypes Types of currency used to collect the funds
966      * @param _wallet Ethereum account address to hold the funds
967      * @param _reserveWallet Ethereum account address to receive unsold tokens
968      * @param _usdToken Contract address of the stable coin
969      */
970     function configure(
971         uint256 _startTime,
972         uint256 _endTime,
973         uint256[] _ratePerTier,
974         uint256[] _ratePerTierDiscountPoly,
975         uint256[] _tokensPerTierTotal,
976         uint256[] _tokensPerTierDiscountPoly,
977         uint256 _nonAccreditedLimitUSD,
978         uint256 _minimumInvestmentUSD,
979         FundRaiseType[] _fundRaiseTypes,
980         address _wallet,
981         address _reserveWallet,
982         address _usdToken
983     ) public onlyFactory {
984         modifyTimes(_startTime, _endTime);
985         // NB - modifyTiers must come before modifyFunding
986         modifyTiers(_ratePerTier, _ratePerTierDiscountPoly, _tokensPerTierTotal, _tokensPerTierDiscountPoly);
987         // NB - modifyFunding must come before modifyAddresses
988         modifyFunding(_fundRaiseTypes);
989         modifyAddresses(_wallet, _reserveWallet, _usdToken);
990         modifyLimits(_nonAccreditedLimitUSD, _minimumInvestmentUSD);
991     }
992 
993     function modifyFunding(FundRaiseType[] _fundRaiseTypes) public onlyFactoryOrOwner {
994         /*solium-disable-next-line security/no-block-members*/
995         require(now < startTime, "STO shouldn't be started");
996         _setFundRaiseType(_fundRaiseTypes);
997         uint256 length = getNumberOfTiers();
998         mintedPerTierTotal = new uint256[](length);
999         mintedPerTierDiscountPoly = new uint256[](length);
1000         for (uint8 i = 0; i < _fundRaiseTypes.length; i++) {
1001             mintedPerTier[uint8(_fundRaiseTypes[i])] = new uint256[](length);
1002         }
1003     }
1004 
1005     function modifyLimits(
1006         uint256 _nonAccreditedLimitUSD,
1007         uint256 _minimumInvestmentUSD
1008     ) public onlyFactoryOrOwner {
1009         /*solium-disable-next-line security/no-block-members*/
1010         require(now < startTime, "STO shouldn't be started");
1011         minimumInvestmentUSD = _minimumInvestmentUSD;
1012         nonAccreditedLimitUSD = _nonAccreditedLimitUSD;
1013         emit SetLimits(minimumInvestmentUSD, nonAccreditedLimitUSD);
1014     }
1015 
1016     function modifyTiers(
1017         uint256[] _ratePerTier,
1018         uint256[] _ratePerTierDiscountPoly,
1019         uint256[] _tokensPerTierTotal,
1020         uint256[] _tokensPerTierDiscountPoly
1021     ) public onlyFactoryOrOwner {
1022         /*solium-disable-next-line security/no-block-members*/
1023         require(now < startTime, "STO shouldn't be started");
1024         require(_tokensPerTierTotal.length > 0, "Length should be > 0");
1025         require(_ratePerTier.length == _tokensPerTierTotal.length, "Mismatch b/w rates & tokens / tier");
1026         require(_ratePerTierDiscountPoly.length == _tokensPerTierTotal.length, "Mismatch b/w discount rates & tokens / tier");
1027         require(_tokensPerTierDiscountPoly.length == _tokensPerTierTotal.length, "Mismatch b/w discount tokens / tier & tokens / tier");
1028         for (uint8 i = 0; i < _ratePerTier.length; i++) {
1029             require(_ratePerTier[i] > 0, "Rate > 0");
1030             require(_tokensPerTierTotal[i] > 0, "Tokens per tier > 0");
1031             require(_tokensPerTierDiscountPoly[i] <= _tokensPerTierTotal[i], "Discounted tokens / tier <= tokens / tier");
1032             require(_ratePerTierDiscountPoly[i] <= _ratePerTier[i], "Discounted rate / tier <= rate / tier");
1033         }
1034         ratePerTier = _ratePerTier;
1035         ratePerTierDiscountPoly = _ratePerTierDiscountPoly;
1036         tokensPerTierTotal = _tokensPerTierTotal;
1037         tokensPerTierDiscountPoly = _tokensPerTierDiscountPoly;
1038         emit SetTiers(_ratePerTier, _ratePerTierDiscountPoly, _tokensPerTierTotal, _tokensPerTierDiscountPoly);
1039     }
1040 
1041     function modifyTimes(
1042         uint256 _startTime,
1043         uint256 _endTime
1044     ) public onlyFactoryOrOwner {
1045         /*solium-disable-next-line security/no-block-members*/
1046         require((startTime == 0) || (now < startTime), "Invalid startTime");
1047         /*solium-disable-next-line security/no-block-members*/
1048         require((_endTime > _startTime) && (_startTime > now), "Invalid times");
1049         startTime = _startTime;
1050         endTime = _endTime;
1051         emit SetTimes(_startTime, _endTime);
1052     }
1053 
1054     function modifyAddresses(
1055         address _wallet,
1056         address _reserveWallet,
1057         address _usdToken
1058     ) public onlyFactoryOrOwner {
1059         /*solium-disable-next-line security/no-block-members*/
1060         require(now < startTime, "STO shouldn't be started");
1061         require(_wallet != address(0) && _reserveWallet != address(0), "Invalid address");
1062         if (fundRaiseTypes[uint8(FundRaiseType.DAI)]) {
1063             require(_usdToken != address(0), "Invalid address");
1064         }
1065         wallet = _wallet;
1066         reserveWallet = _reserveWallet;
1067         usdToken = IERC20(_usdToken);
1068         emit SetAddresses(_wallet, _reserveWallet, _usdToken);
1069     }
1070 
1071     ////////////////////
1072     // STO Management //
1073     ////////////////////
1074 
1075     /**
1076      * @notice Finalizes the STO and mint remaining tokens to reserve address
1077      * @notice Reserve address must be whitelisted to successfully finalize
1078      */
1079     function finalize() public onlyOwner {
1080         require(!isFinalized, "STO is already finalized");
1081         isFinalized = true;
1082         uint256 tempReturned;
1083         uint256 tempSold;
1084         uint256 remainingTokens;
1085         for (uint8 i = 0; i < tokensPerTierTotal.length; i++) {
1086             remainingTokens = tokensPerTierTotal[i].sub(mintedPerTierTotal[i]);
1087             tempReturned = tempReturned.add(remainingTokens);
1088             tempSold = tempSold.add(mintedPerTierTotal[i]);
1089             if (remainingTokens > 0) {
1090                 mintedPerTierTotal[i] = tokensPerTierTotal[i];
1091             }
1092         }
1093         require(ISecurityToken(securityToken).mint(reserveWallet, tempReturned), "Error in minting");
1094         emit ReserveTokenMint(msg.sender, reserveWallet, tempReturned, currentTier);
1095         finalAmountReturned = tempReturned;
1096         totalTokensSold = tempSold;
1097     }
1098 
1099     /**
1100      * @notice Modifies the list of accredited addresses
1101      * @param _investors Array of investor addresses to modify
1102      * @param _accredited Array of bools specifying accreditation status
1103      */
1104     function changeAccredited(address[] _investors, bool[] _accredited) public onlyOwner {
1105         require(_investors.length == _accredited.length, "Array length mismatch");
1106         for (uint256 i = 0; i < _investors.length; i++) {
1107             accredited[_investors[i]] = _accredited[i];
1108             emit SetAccredited(_investors[i], _accredited[i]);
1109         }
1110     }
1111 
1112     /**
1113      * @notice Modifies the list of overrides for non-accredited limits in USD
1114      * @param _investors Array of investor addresses to modify
1115      * @param _nonAccreditedLimit Array of uints specifying non-accredited limits
1116      */
1117     function changeNonAccreditedLimit(address[] _investors, uint256[] _nonAccreditedLimit) public onlyOwner {
1118         //nonAccreditedLimitUSDOverride
1119         require(_investors.length == _nonAccreditedLimit.length, "Array length mismatch");
1120         for (uint256 i = 0; i < _investors.length; i++) {
1121             require(_nonAccreditedLimit[i] > 0, "Limit can not be 0");
1122             nonAccreditedLimitUSDOverride[_investors[i]] = _nonAccreditedLimit[i];
1123             emit SetNonAccreditedLimit(_investors[i], _nonAccreditedLimit[i]);
1124         }
1125     }
1126 
1127     /**
1128      * @notice Function to set allowBeneficialInvestments (allow beneficiary to be different to funder)
1129      * @param _allowBeneficialInvestments Boolean to allow or disallow beneficial investments
1130      */
1131     function changeAllowBeneficialInvestments(bool _allowBeneficialInvestments) public onlyOwner {
1132         require(_allowBeneficialInvestments != allowBeneficialInvestments, "Value unchanged");
1133         allowBeneficialInvestments = _allowBeneficialInvestments;
1134         emit SetAllowBeneficialInvestments(allowBeneficialInvestments);
1135     }
1136 
1137     //////////////////////////
1138     // Investment Functions //
1139     //////////////////////////
1140 
1141     /**
1142     * @notice fallback function - assumes ETH being invested
1143     */
1144     function () external payable {
1145         buyWithETH(msg.sender);
1146     }
1147 
1148     /**
1149       * @notice Purchase tokens using ETH
1150       * @param _beneficiary Address where security tokens will be sent
1151       */
1152     function buyWithETH(address _beneficiary) public payable validETH {
1153         uint256 rate = getRate(FundRaiseType.ETH);
1154         (uint256 spentUSD, uint256 spentValue) = _buyTokens(_beneficiary, msg.value, rate, FundRaiseType.ETH);
1155         // Modify storage
1156         investorInvested[_beneficiary][uint8(FundRaiseType.ETH)] = investorInvested[_beneficiary][uint8(FundRaiseType.ETH)].add(spentValue);
1157         fundsRaised[uint8(FundRaiseType.ETH)] = fundsRaised[uint8(FundRaiseType.ETH)].add(spentValue);
1158         // Forward ETH to issuer wallet
1159         wallet.transfer(spentValue);
1160         // Refund excess ETH to investor wallet
1161         msg.sender.transfer(msg.value.sub(spentValue));
1162         emit FundsReceived(msg.sender, _beneficiary, spentUSD, FundRaiseType.ETH, msg.value, spentValue, rate);
1163     }
1164 
1165     /**
1166       * @notice Purchase tokens using POLY
1167       * @param _beneficiary Address where security tokens will be sent
1168       * @param _investedPOLY Amount of POLY invested
1169       */
1170     function buyWithPOLY(address _beneficiary, uint256 _investedPOLY) public validPOLY {
1171         _buyWithTokens(_beneficiary, _investedPOLY, FundRaiseType.POLY);
1172     }
1173 
1174     /**
1175       * @notice Purchase tokens using POLY
1176       * @param _beneficiary Address where security tokens will be sent
1177       * @param _investedDAI Amount of POLY invested
1178       */
1179     function buyWithUSD(address _beneficiary, uint256 _investedDAI) public validDAI {
1180         _buyWithTokens(_beneficiary, _investedDAI, FundRaiseType.DAI);
1181     }
1182 
1183     function _buyWithTokens(address _beneficiary, uint256 _tokenAmount, FundRaiseType _fundRaiseType) internal {
1184         require(_fundRaiseType == FundRaiseType.POLY || _fundRaiseType == FundRaiseType.DAI, "POLY & DAI supported");
1185         uint256 rate = getRate(_fundRaiseType);
1186         (uint256 spentUSD, uint256 spentValue) = _buyTokens(_beneficiary, _tokenAmount, rate, _fundRaiseType);
1187         // Modify storage
1188         investorInvested[_beneficiary][uint8(_fundRaiseType)] = investorInvested[_beneficiary][uint8(_fundRaiseType)].add(spentValue);
1189         fundsRaised[uint8(_fundRaiseType)] = fundsRaised[uint8(_fundRaiseType)].add(spentValue);
1190         // Forward DAI to issuer wallet
1191         IERC20 token = _fundRaiseType == FundRaiseType.POLY ? polyToken : usdToken;
1192         require(token.transferFrom(msg.sender, wallet, spentValue), "Transfer failed");
1193         emit FundsReceived(msg.sender, _beneficiary, spentUSD, _fundRaiseType, _tokenAmount, spentValue, rate);
1194     }
1195 
1196     /**
1197       * @notice Low level token purchase
1198       * @param _beneficiary Address where security tokens will be sent
1199       * @param _investmentValue Amount of POLY, ETH or DAI invested
1200       * @param _fundRaiseType Fund raise type (POLY, ETH, DAI)
1201       */
1202     function _buyTokens(
1203         address _beneficiary,
1204         uint256 _investmentValue,
1205         uint256 _rate,
1206         FundRaiseType _fundRaiseType
1207     )
1208         internal
1209         nonReentrant
1210         whenNotPaused
1211         returns(uint256, uint256)
1212     {
1213         if (!allowBeneficialInvestments) {
1214             require(_beneficiary == msg.sender, "Beneficiary does not match funder");
1215         }
1216 
1217         require(isOpen(), "STO is not open");
1218         require(_investmentValue > 0, "No funds were sent");
1219 
1220         uint256 investedUSD = DecimalMath.mul(_rate, _investmentValue);
1221         uint256 originalUSD = investedUSD;
1222 
1223         // Check for minimum investment
1224         require(investedUSD.add(investorInvestedUSD[_beneficiary]) >= minimumInvestmentUSD, "Total investment < minimumInvestmentUSD");
1225 
1226         // Check for non-accredited cap
1227         if (!accredited[_beneficiary]) {
1228             uint256 investorLimitUSD = (nonAccreditedLimitUSDOverride[_beneficiary] == 0) ? nonAccreditedLimitUSD : nonAccreditedLimitUSDOverride[_beneficiary];
1229             require(investorInvestedUSD[_beneficiary] < investorLimitUSD, "Non-accredited investor has reached limit");
1230             if (investedUSD.add(investorInvestedUSD[_beneficiary]) > investorLimitUSD)
1231                 investedUSD = investorLimitUSD.sub(investorInvestedUSD[_beneficiary]);
1232         }
1233         uint256 spentUSD;
1234         // Iterate over each tier and process payment
1235         for (uint8 i = currentTier; i < ratePerTier.length; i++) {
1236             // Update current tier if needed
1237             if (currentTier != i)
1238                 currentTier = i;
1239             // If there are tokens remaining, process investment
1240             if (mintedPerTierTotal[i] < tokensPerTierTotal[i])
1241                 spentUSD = spentUSD.add(_calculateTier(_beneficiary, i, investedUSD.sub(spentUSD), _fundRaiseType));
1242             // If all funds have been spent, exit the loop
1243             if (investedUSD == spentUSD)
1244                 break;
1245         }
1246 
1247         // Modify storage
1248         if (spentUSD > 0) {
1249             if (investorInvestedUSD[_beneficiary] == 0)
1250                 investorCount = investorCount + 1;
1251             investorInvestedUSD[_beneficiary] = investorInvestedUSD[_beneficiary].add(spentUSD);
1252             fundsRaisedUSD = fundsRaisedUSD.add(spentUSD);
1253         }
1254 
1255         // Calculate spent in base currency (ETH, DAI or POLY)
1256         uint256 spentValue;
1257         if (spentUSD == 0) {
1258             spentValue = 0;
1259         } else {
1260             spentValue = DecimalMath.mul(DecimalMath.div(spentUSD, originalUSD), _investmentValue);
1261         }
1262 
1263         // Return calculated amounts
1264         return (spentUSD, spentValue);
1265     }
1266 
1267     function _calculateTier(
1268         address _beneficiary,
1269         uint8 _tier,
1270         uint256 _investedUSD,
1271         FundRaiseType _fundRaiseType
1272     ) 
1273         internal
1274         returns(uint256)
1275      {
1276         // First purchase any discounted tokens if POLY investment
1277         uint256 spentUSD;
1278         uint256 tierSpentUSD;
1279         uint256 tierPurchasedTokens;
1280         uint256 investedUSD = _investedUSD;
1281         // Check whether there are any remaining discounted tokens
1282         if ((_fundRaiseType == FundRaiseType.POLY) && (tokensPerTierDiscountPoly[_tier] > mintedPerTierDiscountPoly[_tier])) {
1283             uint256 discountRemaining = tokensPerTierDiscountPoly[_tier].sub(mintedPerTierDiscountPoly[_tier]);
1284             uint256 totalRemaining = tokensPerTierTotal[_tier].sub(mintedPerTierTotal[_tier]);
1285             if (totalRemaining < discountRemaining)
1286                 (spentUSD, tierPurchasedTokens) = _purchaseTier(_beneficiary, ratePerTierDiscountPoly[_tier], totalRemaining, investedUSD, _tier);
1287             else
1288                 (spentUSD, tierPurchasedTokens) = _purchaseTier(_beneficiary, ratePerTierDiscountPoly[_tier], discountRemaining, investedUSD, _tier);
1289             investedUSD = investedUSD.sub(spentUSD);
1290             mintedPerTierDiscountPoly[_tier] = mintedPerTierDiscountPoly[_tier].add(tierPurchasedTokens);
1291             mintedPerTier[uint8(FundRaiseType.POLY)][_tier] = mintedPerTier[uint8(FundRaiseType.POLY)][_tier].add(tierPurchasedTokens);
1292             mintedPerTierTotal[_tier] = mintedPerTierTotal[_tier].add(tierPurchasedTokens);
1293         }
1294         // Now, if there is any remaining USD to be invested, purchase at non-discounted rate
1295         if ((investedUSD > 0) && (tokensPerTierTotal[_tier].sub(mintedPerTierTotal[_tier]) > 0)) {
1296             (tierSpentUSD, tierPurchasedTokens) = _purchaseTier(_beneficiary, ratePerTier[_tier], tokensPerTierTotal[_tier].sub(mintedPerTierTotal[_tier]), investedUSD, _tier);
1297             spentUSD = spentUSD.add(tierSpentUSD);
1298             mintedPerTier[uint8(_fundRaiseType)][_tier] = mintedPerTier[uint8(_fundRaiseType)][_tier].add(tierPurchasedTokens);
1299             mintedPerTierTotal[_tier] = mintedPerTierTotal[_tier].add(tierPurchasedTokens);
1300         }
1301         return spentUSD;
1302     }
1303 
1304     function _purchaseTier(
1305         address _beneficiary,
1306         uint256 _tierPrice,
1307         uint256 _tierRemaining,
1308         uint256 _investedUSD,
1309         uint8 _tier
1310     )
1311         internal
1312         returns(uint256, uint256)
1313     {
1314         uint256 maximumTokens = DecimalMath.div(_investedUSD, _tierPrice);
1315         uint256 spentUSD;
1316         uint256 purchasedTokens;
1317         if (maximumTokens > _tierRemaining) {
1318             spentUSD = DecimalMath.mul(_tierRemaining, _tierPrice);
1319             // In case of rounding issues, ensure that spentUSD is never more than investedUSD
1320             if (spentUSD > _investedUSD) {
1321                 spentUSD = _investedUSD;
1322             }
1323             purchasedTokens = _tierRemaining;
1324         } else {
1325             spentUSD = _investedUSD;
1326             purchasedTokens = maximumTokens;
1327         }
1328         require(ISecurityToken(securityToken).mint(_beneficiary, purchasedTokens), "Error in minting");
1329         emit TokenPurchase(msg.sender, _beneficiary, purchasedTokens, spentUSD, _tierPrice, _tier);
1330         return (spentUSD, purchasedTokens);
1331     }
1332 
1333     /////////////
1334     // Getters //
1335     /////////////
1336 
1337     /**
1338      * @notice This function returns whether or not the STO is in fundraising mode (open)
1339      * @return bool Whether the STO is accepting investments
1340      */
1341     function isOpen() public view returns(bool) {
1342         if (isFinalized)
1343             return false;
1344         /*solium-disable-next-line security/no-block-members*/
1345         if (now < startTime)
1346             return false;
1347         /*solium-disable-next-line security/no-block-members*/
1348         if (now >= endTime)
1349             return false;
1350         if (capReached())
1351             return false;
1352         return true;
1353     }
1354 
1355     /**
1356      * @notice Checks whether the cap has been reached.
1357      * @return bool Whether the cap was reached
1358      */
1359     function capReached() public view returns (bool) {
1360         if (isFinalized) {
1361             return (finalAmountReturned == 0);
1362         }
1363         return (mintedPerTierTotal[mintedPerTierTotal.length - 1] == tokensPerTierTotal[tokensPerTierTotal.length - 1]);
1364     }
1365 
1366     function getRate(FundRaiseType _fundRaiseType) public view returns (uint256) {
1367         if (_fundRaiseType == FundRaiseType.ETH) {
1368             return IOracle(_getOracle(bytes32("ETH"), bytes32("USD"))).getPrice();
1369         } else if (_fundRaiseType == FundRaiseType.POLY) {
1370             return IOracle(_getOracle(bytes32("POLY"), bytes32("USD"))).getPrice();
1371         } else if (_fundRaiseType == FundRaiseType.DAI) {
1372             return 1 * 10**18;
1373         } else {
1374             revert("Incorrect funding");
1375         }
1376     }
1377 
1378     /**
1379      * @notice This function converts from ETH or POLY to USD
1380      * @param _fundRaiseType Currency key
1381      * @param _amount Value to convert to USD
1382      * @return uint256 Value in USD
1383      */
1384     function convertToUSD(FundRaiseType _fundRaiseType, uint256 _amount) public view returns(uint256) {
1385         uint256 rate = getRate(_fundRaiseType);
1386         return DecimalMath.mul(_amount, rate);
1387     }
1388 
1389     /**
1390      * @notice This function converts from USD to ETH or POLY
1391      * @param _fundRaiseType Currency key
1392      * @param _amount Value to convert from USD
1393      * @return uint256 Value in ETH or POLY
1394      */
1395     function convertFromUSD(FundRaiseType _fundRaiseType, uint256 _amount) public view returns(uint256) {
1396         uint256 rate = getRate(_fundRaiseType);
1397         return DecimalMath.div(_amount, rate);
1398     }
1399 
1400     /**
1401      * @notice Return the total no. of tokens sold
1402      * @return uint256 Total number of tokens sold
1403      */
1404     function getTokensSold() public view returns (uint256) {
1405         if (isFinalized)
1406             return totalTokensSold;
1407         else
1408             return getTokensMinted();
1409     }
1410 
1411     /**
1412      * @notice Return the total no. of tokens minted
1413      * @return uint256 Total number of tokens minted
1414      */
1415     function getTokensMinted() public view returns (uint256) {
1416         uint256 tokensMinted;
1417         for (uint8 i = 0; i < mintedPerTierTotal.length; i++) {
1418             tokensMinted = tokensMinted.add(mintedPerTierTotal[i]);
1419         }
1420         return tokensMinted;
1421     }
1422 
1423     /**
1424      * @notice Return the total no. of tokens sold for ETH
1425      * @return uint256 Total number of tokens sold for ETH
1426      */
1427     function getTokensSoldFor(FundRaiseType _fundRaiseType) public view returns (uint256) {
1428         uint256 tokensSold;
1429         for (uint8 i = 0; i < mintedPerTier[uint8(_fundRaiseType)].length; i++) {
1430             tokensSold = tokensSold.add(mintedPerTier[uint8(_fundRaiseType)][i]);
1431         }
1432         return tokensSold;
1433     }
1434 
1435     /**
1436      * @notice Return the total no. of tiers
1437      * @return uint256 Total number of tiers
1438      */
1439     function getNumberOfTiers() public view returns (uint256) {
1440         return tokensPerTierTotal.length;
1441     }
1442 
1443     /**
1444      * @notice Return the permissions flag that are associated with STO
1445      */
1446     function getPermissions() public view returns(bytes32[]) {
1447         bytes32[] memory allPermissions = new bytes32[](0);
1448         return allPermissions;
1449     }
1450 
1451     /**
1452      * @notice This function returns the signature of configure function
1453      * @return bytes4 Configure function signature
1454      */
1455     function getInitFunction() public pure returns (bytes4) {
1456         return 0xb0ff041e;
1457     }
1458 
1459     function _getOracle(bytes32 _currency, bytes32 _denominatedCurrency) internal view returns (address) {
1460         return PolymathRegistry(RegistryUpdater(securityToken).polymathRegistry()).getAddress(oracleKeys[_currency][_denominatedCurrency]);
1461     }
1462 
1463 }