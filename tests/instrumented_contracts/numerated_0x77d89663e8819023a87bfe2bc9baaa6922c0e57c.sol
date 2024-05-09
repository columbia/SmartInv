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
646 /**
647  * @title Helps contracts guard agains reentrancy attacks.
648  * @author Remco Bloemen <remco@2π.com>
649  * @notice If you mark a function `nonReentrant`, you should also
650  * mark it `external`.
651  */
652 contract ReentrancyGuard {
653 
654   /**
655    * @dev We use a single lock for the whole contract.
656    */
657   bool private reentrancyLock = false;
658 
659   /**
660    * @dev Prevents a contract from calling itself, directly or indirectly.
661    * @notice If you mark a function `nonReentrant`, you should also
662    * mark it `external`. Calling one nonReentrant function from
663    * another is not supported. Instead, you can implement a
664    * `private` function doing the actual work, and a `external`
665    * wrapper marked as `nonReentrant`.
666    */
667   modifier nonReentrant() {
668     require(!reentrancyLock);
669     reentrancyLock = true;
670     _;
671     reentrancyLock = false;
672   }
673 
674 }
675 
676 /**
677  * @title STO module for standard capped crowdsale
678  */
679 contract CappedSTO is ISTO, ReentrancyGuard {
680     using SafeMath for uint256;
681 
682     // Determine whether users can invest on behalf of a beneficiary
683     bool public allowBeneficialInvestments = false;
684     // How many token units a buyer gets per wei / base unit of POLY
685     uint256 public rate;
686     //How many tokens this STO will be allowed to sell to investors
687     uint256 public cap;
688 
689     mapping (address => uint256) public investors;
690 
691     /**
692     * Event for token purchase logging
693     * @param purchaser who paid for the tokens
694     * @param beneficiary who got the tokens
695     * @param value weis paid for purchase
696     * @param amount amount of tokens purchased
697     */
698     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
699 
700     event SetAllowBeneficialInvestments(bool _allowed);
701 
702     constructor (address _securityToken, address _polyAddress) public
703     Module(_securityToken, _polyAddress)
704     {
705     }
706 
707     //////////////////////////////////
708     /**
709     * @notice fallback function ***DO NOT OVERRIDE***
710     */
711     function () external payable {
712         buyTokens(msg.sender);
713     }
714 
715     /**
716      * @notice Function used to intialize the contract variables
717      * @param _startTime Unix timestamp at which offering get started
718      * @param _endTime Unix timestamp at which offering get ended
719      * @param _cap Maximum No. of tokens for sale
720      * @param _rate Token units a buyer gets per wei / base unit of POLY
721      * @param _fundRaiseTypes Type of currency used to collect the funds
722      * @param _fundsReceiver Ethereum account address to hold the funds
723      */
724     function configure(
725         uint256 _startTime,
726         uint256 _endTime,
727         uint256 _cap,
728         uint256 _rate,
729         FundRaiseType[] _fundRaiseTypes,
730         address _fundsReceiver
731     )
732     public
733     onlyFactory
734     {
735         require(_rate > 0, "Rate of token should be greater than 0");
736         require(_fundsReceiver != address(0), "Zero address is not permitted");
737         /*solium-disable-next-line security/no-block-members*/
738         require(_startTime >= now && _endTime > _startTime, "Date parameters are not valid");
739         require(_cap > 0, "Cap should be greater than 0");
740         require(_fundRaiseTypes.length == 1, "It only selects single fund raise type");
741         startTime = _startTime;
742         endTime = _endTime;
743         cap = _cap;
744         rate = _rate;
745         wallet = _fundsReceiver;
746         _setFundRaiseType(_fundRaiseTypes);
747     }
748 
749     /**
750      * @notice This function returns the signature of configure function
751      */
752     function getInitFunction() public pure returns (bytes4) {
753         return bytes4(keccak256("configure(uint256,uint256,uint256,uint256,uint8[],address)"));
754     }
755 
756     /**
757      * @notice Function to set allowBeneficialInvestments (allow beneficiary to be different to funder)
758      * @param _allowBeneficialInvestments Boolean to allow or disallow beneficial investments
759      */
760     function changeAllowBeneficialInvestments(bool _allowBeneficialInvestments) public onlyOwner {
761         require(_allowBeneficialInvestments != allowBeneficialInvestments, "Does not change value");
762         allowBeneficialInvestments = _allowBeneficialInvestments;
763         emit SetAllowBeneficialInvestments(allowBeneficialInvestments);
764     }
765 
766     /**
767       * @notice Low level token purchase ***DO NOT OVERRIDE***
768       * @param _beneficiary Address performing the token purchase
769       */
770     function buyTokens(address _beneficiary) public payable nonReentrant {
771         if (!allowBeneficialInvestments) {
772             require(_beneficiary == msg.sender, "Beneficiary address does not match msg.sender");
773         }
774 
775         require(!paused, "Should not be paused");
776         require(fundRaiseTypes[uint8(FundRaiseType.ETH)], "Mode of investment is not ETH");
777 
778         uint256 weiAmount = msg.value;
779         _processTx(_beneficiary, weiAmount);
780 
781         _forwardFunds();
782         _postValidatePurchase(_beneficiary, weiAmount);
783     }
784 
785     /**
786       * @notice low level token purchase
787       * @param _investedPOLY Amount of POLY invested
788       */
789     function buyTokensWithPoly(uint256 _investedPOLY) public nonReentrant{
790         require(!paused, "Should not be paused");
791         require(fundRaiseTypes[uint8(FundRaiseType.POLY)], "Mode of investment is not POLY");
792         _processTx(msg.sender, _investedPOLY);
793         _forwardPoly(msg.sender, wallet, _investedPOLY);
794         _postValidatePurchase(msg.sender, _investedPOLY);
795     }
796 
797     /**
798     * @notice Checks whether the cap has been reached.
799     * @return bool Whether the cap was reached
800     */
801     function capReached() public view returns (bool) {
802         return totalTokensSold >= cap;
803     }
804 
805     /**
806      * @notice Return the total no. of tokens sold
807      */
808     function getTokensSold() public view returns (uint256) {
809         return totalTokensSold;
810     }
811 
812     /**
813      * @notice Return the permissions flag that are associated with STO
814      */
815     function getPermissions() public view returns(bytes32[]) {
816         bytes32[] memory allPermissions = new bytes32[](0);
817         return allPermissions;
818     }
819 
820     /**
821      * @notice Return the STO details
822      * @return Unixtimestamp at which offering gets start.
823      * @return Unixtimestamp at which offering ends.
824      * @return Number of tokens this STO will be allowed to sell to investors.
825      * @return Amount of funds raised
826      * @return Number of individual investors this STO have.
827      * @return Amount of tokens get sold. 
828      * @return Boolean value to justify whether the fund raise type is POLY or not, i.e true for POLY.
829      */
830     function getSTODetails() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool) {
831         return (
832             startTime,
833             endTime,
834             cap,
835             rate,
836             (fundRaiseTypes[uint8(FundRaiseType.POLY)]) ? fundsRaised[uint8(FundRaiseType.POLY)]: fundsRaised[uint8(FundRaiseType.ETH)],
837             investorCount,
838             totalTokensSold,
839             (fundRaiseTypes[uint8(FundRaiseType.POLY)])
840         );
841     }
842 
843     // -----------------------------------------
844     // Internal interface (extensible)
845     // -----------------------------------------
846     /**
847       * Processing the purchase as well as verify the required validations
848       * @param _beneficiary Address performing the token purchase
849       * @param _investedAmount Value in wei involved in the purchase
850     */
851     function _processTx(address _beneficiary, uint256 _investedAmount) internal {
852 
853         _preValidatePurchase(_beneficiary, _investedAmount);
854         // calculate token amount to be created
855         uint256 tokens = _getTokenAmount(_investedAmount);
856 
857         // update state
858         if (fundRaiseTypes[uint8(FundRaiseType.POLY)]) {
859             fundsRaised[uint8(FundRaiseType.POLY)] = fundsRaised[uint8(FundRaiseType.POLY)].add(_investedAmount);
860         } else {
861             fundsRaised[uint8(FundRaiseType.ETH)] = fundsRaised[uint8(FundRaiseType.ETH)].add(_investedAmount);
862         }
863         totalTokensSold = totalTokensSold.add(tokens);
864 
865         _processPurchase(_beneficiary, tokens);
866         emit TokenPurchase(msg.sender, _beneficiary, _investedAmount, tokens);
867 
868         _updatePurchasingState(_beneficiary, _investedAmount);
869     }
870 
871     /**
872     * @notice Validation of an incoming purchase.
873       Use require statements to revert state when conditions are not met. Use super to concatenate validations.
874     * @param _beneficiary Address performing the token purchase
875     * @param _investedAmount Value in wei involved in the purchase
876     */
877     function _preValidatePurchase(address _beneficiary, uint256 _investedAmount) internal view {
878         require(_beneficiary != address(0), "Beneficiary address should not be 0x");
879         require(_investedAmount != 0, "Amount invested should not be equal to 0");
880         require(totalTokensSold.add(_getTokenAmount(_investedAmount)) <= cap, "Investment more than cap is not allowed");
881         /*solium-disable-next-line security/no-block-members*/
882         require(now >= startTime && now <= endTime, "Offering is closed/Not yet started");
883     }
884 
885     /**
886     * @notice Validation of an executed purchase.
887       Observe state and use revert statements to undo rollback when valid conditions are not met.
888     */
889     function _postValidatePurchase(address /*_beneficiary*/, uint256 /*_investedAmount*/) internal pure {
890       // optional override
891     }
892 
893     /**
894     * @notice Source of tokens.
895       Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
896     * @param _beneficiary Address performing the token purchase
897     * @param _tokenAmount Number of tokens to be emitted
898     */
899     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
900         require(ISecurityToken(securityToken).mint(_beneficiary, _tokenAmount), "Error in minting the tokens");
901     }
902 
903     /**
904     * @notice Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
905     * @param _beneficiary Address receiving the tokens
906     * @param _tokenAmount Number of tokens to be purchased
907     */
908     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
909         if (investors[_beneficiary] == 0) {
910             investorCount = investorCount + 1;
911         }
912         investors[_beneficiary] = investors[_beneficiary].add(_tokenAmount);
913 
914         _deliverTokens(_beneficiary, _tokenAmount);
915     }
916 
917     /**
918     * @notice Overrides for extensions that require an internal state to check for validity
919       (current user contributions, etc.)
920     */
921     function _updatePurchasingState(address /*_beneficiary*/, uint256 /*_investedAmount*/) internal pure {
922       // optional override
923     }
924 
925     /**
926     * @notice Overrides to extend the way in which ether is converted to tokens.
927     * @param _investedAmount Value in wei to be converted into tokens
928     * @return Number of tokens that can be purchased with the specified _investedAmount
929     */
930     function _getTokenAmount(uint256 _investedAmount) internal view returns (uint256) {
931         return _investedAmount.mul(rate);
932     }
933 
934     /**
935     * @notice Determines how ETH is stored/forwarded on purchases.
936     */
937     function _forwardFunds() internal {
938         wallet.transfer(msg.value);
939     }
940 
941     /**
942      * @notice Internal function used to forward the POLY raised to beneficiary address
943      * @param _beneficiary Address of the funds reciever
944      * @param _to Address who wants to ST-20 tokens
945      * @param _fundsAmount Amount invested by _to
946      */
947     function _forwardPoly(address _beneficiary, address _to, uint256 _fundsAmount) internal {
948         polyToken.transferFrom(_beneficiary, _to, _fundsAmount);
949     }
950 
951 }
952 
953 /**
954  * @title Interface that every module factory contract should implement
955  */
956 interface IModuleFactory {
957 
958     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
959     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
960     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
961     event GenerateModuleFromFactory(
962         address _module,
963         bytes32 indexed _moduleName,
964         address indexed _moduleFactory,
965         address _creator,
966         uint256 _setupCost,
967         uint256 _timestamp
968     );
969     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
970 
971     //Should create an instance of the Module, or throw
972     function deploy(bytes _data) external returns(address);
973 
974     /**
975      * @notice Type of the Module factory
976      */
977     function getTypes() external view returns(uint8[]);
978 
979     /**
980      * @notice Get the name of the Module
981      */
982     function getName() external view returns(bytes32);
983 
984     /**
985      * @notice Returns the instructions associated with the module
986      */
987     function getInstructions() external view returns (string);
988 
989     /**
990      * @notice Get the tags related to the module factory
991      */
992     function getTags() external view returns (bytes32[]);
993 
994     /**
995      * @notice Used to change the setup fee
996      * @param _newSetupCost New setup fee
997      */
998     function changeFactorySetupFee(uint256 _newSetupCost) external;
999 
1000     /**
1001      * @notice Used to change the usage fee
1002      * @param _newUsageCost New usage fee
1003      */
1004     function changeFactoryUsageFee(uint256 _newUsageCost) external;
1005 
1006     /**
1007      * @notice Used to change the subscription fee
1008      * @param _newSubscriptionCost New subscription fee
1009      */
1010     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
1011 
1012     /**
1013      * @notice Function use to change the lower and upper bound of the compatible version st
1014      * @param _boundType Type of bound
1015      * @param _newVersion New version array
1016      */
1017     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
1018 
1019    /**
1020      * @notice Get the setup cost of the module
1021      */
1022     function getSetupCost() external view returns (uint256);
1023 
1024     /**
1025      * @notice Used to get the lower bound
1026      * @return Lower bound
1027      */
1028     function getLowerSTVersionBounds() external view returns(uint8[]);
1029 
1030      /**
1031      * @notice Used to get the upper bound
1032      * @return Upper bound
1033      */
1034     function getUpperSTVersionBounds() external view returns(uint8[]);
1035 
1036 }
1037 
1038 /**
1039  * @title Helper library use to compare or validate the semantic versions
1040  */
1041 
1042 library VersionUtils {
1043 
1044     /**
1045      * @notice This function is used to validate the version submitted
1046      * @param _current Array holds the present version of ST
1047      * @param _new Array holds the latest version of the ST
1048      * @return bool
1049      */
1050     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
1051         bool[] memory _temp = new bool[](_current.length);
1052         uint8 counter = 0;
1053         for (uint8 i = 0; i < _current.length; i++) {
1054             if (_current[i] < _new[i])
1055                 _temp[i] = true;
1056             else
1057                 _temp[i] = false;
1058         }
1059 
1060         for (i = 0; i < _current.length; i++) {
1061             if (i == 0) {
1062                 if (_current[i] <= _new[i])
1063                     if(_temp[0]) {
1064                         counter = counter + 3;
1065                         break;
1066                     } else
1067                         counter++;
1068                 else
1069                     return false;
1070             } else {
1071                 if (_temp[i-1])
1072                     counter++;
1073                 else if (_current[i] <= _new[i])
1074                     counter++;
1075                 else
1076                     return false;
1077             }
1078         }
1079         if (counter == _current.length)
1080             return true;
1081     }
1082 
1083     /**
1084      * @notice Used to compare the lower bound with the latest version
1085      * @param _version1 Array holds the lower bound of the version
1086      * @param _version2 Array holds the latest version of the ST
1087      * @return bool
1088      */
1089     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1090         require(_version1.length == _version2.length, "Input length mismatch");
1091         uint counter = 0;
1092         for (uint8 j = 0; j < _version1.length; j++) {
1093             if (_version1[j] == 0)
1094                 counter ++;
1095         }
1096         if (counter != _version1.length) {
1097             counter = 0;
1098             for (uint8 i = 0; i < _version1.length; i++) {
1099                 if (_version2[i] > _version1[i])
1100                     return true;
1101                 else if (_version2[i] < _version1[i])
1102                     return false;
1103                 else
1104                     counter++;
1105             }
1106             if (counter == _version1.length - 1)
1107                 return true;
1108             else
1109                 return false;
1110         } else
1111             return true;
1112     }
1113 
1114     /**
1115      * @notice Used to compare the upper bound with the latest version
1116      * @param _version1 Array holds the upper bound of the version
1117      * @param _version2 Array holds the latest version of the ST
1118      * @return bool
1119      */
1120     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1121         require(_version1.length == _version2.length, "Input length mismatch");
1122         uint counter = 0;
1123         for (uint8 j = 0; j < _version1.length; j++) {
1124             if (_version1[j] == 0)
1125                 counter ++;
1126         }
1127         if (counter != _version1.length) {
1128             counter = 0;
1129             for (uint8 i = 0; i < _version1.length; i++) {
1130                 if (_version1[i] > _version2[i])
1131                     return true;
1132                 else if (_version1[i] < _version2[i])
1133                     return false;
1134                 else
1135                     counter++;
1136             }
1137             if (counter == _version1.length - 1)
1138                 return true;
1139             else
1140                 return false;
1141         } else
1142             return true;
1143     }
1144 
1145 
1146     /**
1147      * @notice Used to pack the uint8[] array data into uint24 value
1148      * @param _major Major version
1149      * @param _minor Minor version
1150      * @param _patch Patch version
1151      */
1152     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
1153         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
1154     }
1155 
1156     /**
1157      * @notice Used to convert packed data into uint8 array
1158      * @param _packedVersion Packed data
1159      */
1160     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
1161         uint8[] memory _unpackVersion = new uint8[](3);
1162         _unpackVersion[0] = uint8(_packedVersion >> 16);
1163         _unpackVersion[1] = uint8(_packedVersion >> 8);
1164         _unpackVersion[2] = uint8(_packedVersion);
1165         return _unpackVersion;
1166     }
1167 
1168 
1169 }
1170 
1171 /**
1172  * @title Interface that any module factory contract should implement
1173  * @notice Contract is abstract
1174  */
1175 contract ModuleFactory is IModuleFactory, Ownable {
1176 
1177     IERC20 public polyToken;
1178     uint256 public usageCost;
1179     uint256 public monthlySubscriptionCost;
1180 
1181     uint256 public setupCost;
1182     string public description;
1183     string public version;
1184     bytes32 public name;
1185     string public title;
1186 
1187     // @notice Allow only two variables to be stored
1188     // 1. lowerBound 
1189     // 2. upperBound
1190     // @dev (0.0.0 will act as the wildcard) 
1191     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
1192     mapping(string => uint24) compatibleSTVersionRange;
1193 
1194     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
1195     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
1196     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
1197     event GenerateModuleFromFactory(
1198         address _module,
1199         bytes32 indexed _moduleName,
1200         address indexed _moduleFactory,
1201         address _creator,
1202         uint256 _timestamp
1203     );
1204     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1205 
1206     /**
1207      * @notice Constructor
1208      * @param _polyAddress Address of the polytoken
1209      */
1210     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
1211         polyToken = IERC20(_polyAddress);
1212         setupCost = _setupCost;
1213         usageCost = _usageCost;
1214         monthlySubscriptionCost = _subscriptionCost;
1215     }
1216 
1217     /**
1218      * @notice Used to change the fee of the setup cost
1219      * @param _newSetupCost new setup cost
1220      */
1221     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
1222         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
1223         setupCost = _newSetupCost;
1224     }
1225 
1226     /**
1227      * @notice Used to change the fee of the usage cost
1228      * @param _newUsageCost new usage cost
1229      */
1230     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
1231         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
1232         usageCost = _newUsageCost;
1233     }
1234 
1235     /**
1236      * @notice Used to change the fee of the subscription cost
1237      * @param _newSubscriptionCost new subscription cost
1238      */
1239     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
1240         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
1241         monthlySubscriptionCost = _newSubscriptionCost;
1242 
1243     }
1244 
1245     /**
1246      * @notice Updates the title of the ModuleFactory
1247      * @param _newTitle New Title that will replace the old one.
1248      */
1249     function changeTitle(string _newTitle) public onlyOwner {
1250         require(bytes(_newTitle).length > 0, "Invalid title");
1251         title = _newTitle;
1252     }
1253 
1254     /**
1255      * @notice Updates the description of the ModuleFactory
1256      * @param _newDesc New description that will replace the old one.
1257      */
1258     function changeDescription(string _newDesc) public onlyOwner {
1259         require(bytes(_newDesc).length > 0, "Invalid description");
1260         description = _newDesc;
1261     }
1262 
1263     /**
1264      * @notice Updates the name of the ModuleFactory
1265      * @param _newName New name that will replace the old one.
1266      */
1267     function changeName(bytes32 _newName) public onlyOwner {
1268         require(_newName != bytes32(0),"Invalid name");
1269         name = _newName;
1270     }
1271 
1272     /**
1273      * @notice Updates the version of the ModuleFactory
1274      * @param _newVersion New name that will replace the old one.
1275      */
1276     function changeVersion(string _newVersion) public onlyOwner {
1277         require(bytes(_newVersion).length > 0, "Invalid version");
1278         version = _newVersion;
1279     }
1280 
1281     /**
1282      * @notice Function use to change the lower and upper bound of the compatible version st
1283      * @param _boundType Type of bound
1284      * @param _newVersion new version array
1285      */
1286     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
1287         require(
1288             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
1289             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
1290             "Must be a valid bound type"
1291         );
1292         require(_newVersion.length == 3);
1293         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
1294             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
1295             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
1296         }
1297         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
1298         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
1299     }
1300 
1301     /**
1302      * @notice Used to get the lower bound
1303      * @return lower bound
1304      */
1305     function getLowerSTVersionBounds() external view returns(uint8[]) {
1306         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
1307     }
1308 
1309     /**
1310      * @notice Used to get the upper bound
1311      * @return upper bound
1312      */
1313     function getUpperSTVersionBounds() external view returns(uint8[]) {
1314         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
1315     }
1316 
1317     /**
1318      * @notice Get the setup cost of the module
1319      */
1320     function getSetupCost() external view returns (uint256) {
1321         return setupCost;
1322     }
1323 
1324    /**
1325     * @notice Get the name of the Module
1326     */
1327     function getName() public view returns(bytes32) {
1328         return name;
1329     }
1330 
1331 }
1332 
1333 /**
1334  * @title Utility contract for reusable code
1335  */
1336 library Util {
1337 
1338    /**
1339     * @notice Changes a string to upper case
1340     * @param _base String to change
1341     */
1342     function upper(string _base) internal pure returns (string) {
1343         bytes memory _baseBytes = bytes(_base);
1344         for (uint i = 0; i < _baseBytes.length; i++) {
1345             bytes1 b1 = _baseBytes[i];
1346             if (b1 >= 0x61 && b1 <= 0x7A) {
1347                 b1 = bytes1(uint8(b1)-32);
1348             }
1349             _baseBytes[i] = b1;
1350         }
1351         return string(_baseBytes);
1352     }
1353 
1354     /**
1355      * @notice Changes the string into bytes32
1356      * @param _source String that need to convert into bytes32
1357      */
1358     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1359     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
1360         return bytesToBytes32(bytes(_source), 0);
1361     }
1362 
1363     /**
1364      * @notice Changes bytes into bytes32
1365      * @param _b Bytes that need to convert into bytes32
1366      * @param _offset Offset from which to begin conversion
1367      */
1368     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1369     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
1370         bytes32 result;
1371 
1372         for (uint i = 0; i < _b.length; i++) {
1373             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
1374         }
1375         return result;
1376     }
1377 
1378     /**
1379      * @notice Changes the bytes32 into string
1380      * @param _source that need to convert into string
1381      */
1382     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
1383         bytes memory bytesString = new bytes(32);
1384         uint charCount = 0;
1385         for (uint j = 0; j < 32; j++) {
1386             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
1387             if (char != 0) {
1388                 bytesString[charCount] = char;
1389                 charCount++;
1390             }
1391         }
1392         bytes memory bytesStringTrimmed = new bytes(charCount);
1393         for (j = 0; j < charCount; j++) {
1394             bytesStringTrimmed[j] = bytesString[j];
1395         }
1396         return string(bytesStringTrimmed);
1397     }
1398 
1399     /**
1400      * @notice Gets function signature from _data
1401      * @param _data Passed data
1402      * @return bytes4 sig
1403      */
1404     function getSig(bytes _data) internal pure returns (bytes4 sig) {
1405         uint len = _data.length < 4 ? _data.length : 4;
1406         for (uint i = 0; i < len; i++) {
1407             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
1408         }
1409     }
1410 
1411 
1412 }
1413 
1414 /**
1415  * @title Factory for deploying CappedSTO module
1416  */
1417 contract CappedSTOFactory is ModuleFactory {
1418 
1419     /**
1420      * @notice Constructor
1421      * @param _polyAddress Address of the polytoken
1422      */
1423     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1424     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1425     {
1426         version = "1.0.0";
1427         name = "CappedSTO";
1428         title = "Capped STO";
1429         description = "Use to collects the funds and once the cap is reached then investment will be no longer entertained";
1430         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1431         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1432     }
1433 
1434      /**
1435      * @notice Used to launch the Module with the help of factory
1436      * @return address Contract address of the Module
1437      */
1438     function deploy(bytes _data) external returns(address) {
1439         if(setupCost > 0)
1440             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Sufficent Allowance is not provided");
1441         //Check valid bytes - can only call module init function
1442         CappedSTO cappedSTO = new CappedSTO(msg.sender, address(polyToken));
1443         //Checks that _data is valid (not calling anything it shouldn't)
1444         require(Util.getSig(_data) == cappedSTO.getInitFunction(), "Invalid data");
1445         /*solium-disable-next-line security/no-low-level-calls*/
1446         require(address(cappedSTO).call(_data), "Unsuccessfull call");
1447         /*solium-disable-next-line security/no-block-members*/
1448         emit GenerateModuleFromFactory(address(cappedSTO), getName(), address(this), msg.sender, setupCost, now);
1449         return address(cappedSTO);
1450     }
1451 
1452     /**
1453      * @notice Type of the Module factory
1454      */
1455     function getTypes() external view returns(uint8[]) {
1456         uint8[] memory res = new uint8[](1);
1457         res[0] = 3;
1458         return res;
1459     }
1460 
1461     /**
1462      * @notice Returns the instructions associated with the module
1463      */
1464     function getInstructions() external view returns(string) {
1465         /*solium-disable-next-line max-len*/
1466         return "Initialises a capped STO. Init parameters are _startTime (time STO starts), _endTime (time STO ends), _cap (cap in tokens for STO), _rate (POLY/ETH to token rate), _fundRaiseType (whether you are raising in POLY or ETH), _polyToken (address of POLY token), _fundsReceiver (address which will receive funds)";
1467     }
1468 
1469     /**
1470      * @notice Get the tags related to the module factory
1471      */
1472     function getTags() external view returns(bytes32[]) {
1473         bytes32[] memory availableTags = new bytes32[](4);
1474         availableTags[0] = "Capped";
1475         availableTags[1] = "Non-refundable";
1476         availableTags[2] = "POLY";
1477         availableTags[3] = "ETH";
1478         return availableTags;
1479     }
1480 
1481 }