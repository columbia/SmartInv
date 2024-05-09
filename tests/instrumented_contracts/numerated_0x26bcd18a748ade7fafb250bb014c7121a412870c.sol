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
396  * @title Storage for Module contract
397  * @notice Contract is abstract
398  */
399 contract ModuleStorage {
400 
401     /**
402      * @notice Constructor
403      * @param _securityToken Address of the security token
404      * @param _polyAddress Address of the polytoken
405      */
406     constructor (address _securityToken, address _polyAddress) public {
407         securityToken = _securityToken;
408         factory = msg.sender;
409         polyToken = IERC20(_polyAddress);
410     }
411     
412     address public factory;
413 
414     address public securityToken;
415 
416     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
417 
418     IERC20 public polyToken;
419 
420 }
421 
422 /**
423  * @title Ownable
424  * @dev The Ownable contract has an owner address, and provides basic authorization control
425  * functions, this simplifies the implementation of "user permissions".
426  */
427 contract Ownable {
428   address public owner;
429 
430 
431   event OwnershipRenounced(address indexed previousOwner);
432   event OwnershipTransferred(
433     address indexed previousOwner,
434     address indexed newOwner
435   );
436 
437 
438   /**
439    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
440    * account.
441    */
442   constructor() public {
443     owner = msg.sender;
444   }
445 
446   /**
447    * @dev Throws if called by any account other than the owner.
448    */
449   modifier onlyOwner() {
450     require(msg.sender == owner);
451     _;
452   }
453 
454   /**
455    * @dev Allows the current owner to relinquish control of the contract.
456    */
457   function renounceOwnership() public onlyOwner {
458     emit OwnershipRenounced(owner);
459     owner = address(0);
460   }
461 
462   /**
463    * @dev Allows the current owner to transfer control of the contract to a newOwner.
464    * @param _newOwner The address to transfer ownership to.
465    */
466   function transferOwnership(address _newOwner) public onlyOwner {
467     _transferOwnership(_newOwner);
468   }
469 
470   /**
471    * @dev Transfers control of the contract to a newOwner.
472    * @param _newOwner The address to transfer ownership to.
473    */
474   function _transferOwnership(address _newOwner) internal {
475     require(_newOwner != address(0));
476     emit OwnershipTransferred(owner, _newOwner);
477     owner = _newOwner;
478   }
479 }
480 
481 /**
482  * @title Interface that any module contract should implement
483  * @notice Contract is abstract
484  */
485 contract Module is IModule, ModuleStorage {
486 
487     /**
488      * @notice Constructor
489      * @param _securityToken Address of the security token
490      * @param _polyAddress Address of the polytoken
491      */
492     constructor (address _securityToken, address _polyAddress) public
493     ModuleStorage(_securityToken, _polyAddress)
494     {
495     }
496 
497     //Allows owner, factory or permissioned delegate
498     modifier withPerm(bytes32 _perm) {
499         bool isOwner = msg.sender == Ownable(securityToken).owner();
500         bool isFactory = msg.sender == factory;
501         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
502         _;
503     }
504 
505     modifier onlyOwner {
506         require(msg.sender == Ownable(securityToken).owner(), "Sender is not owner");
507         _;
508     }
509 
510     modifier onlyFactory {
511         require(msg.sender == factory, "Sender is not factory");
512         _;
513     }
514 
515     modifier onlyFactoryOwner {
516         require(msg.sender == Ownable(factory).owner(), "Sender is not factory owner");
517         _;
518     }
519 
520     modifier onlyFactoryOrOwner {
521         require((msg.sender == Ownable(securityToken).owner()) || (msg.sender == factory), "Sender is not factory or owner");
522         _;
523     }
524 
525     /**
526      * @notice used to withdraw the fee by the factory owner
527      */
528     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
529         require(polyToken.transferFrom(securityToken, Ownable(factory).owner(), _amount), "Unable to take fee");
530         return true;
531     }
532 
533 }
534 
535 /**
536  * @title Interface to be implemented by all STO modules
537  */
538 interface ISTO {
539     /**
540      * @notice Returns the total no. of tokens sold
541      */
542     function getTokensSold() external view returns (uint256);
543 }
544 
545 /**
546  * @title Storage layout for the STO contract
547  */
548 contract STOStorage {
549 
550     mapping (uint8 => bool) public fundRaiseTypes;
551     mapping (uint8 => uint256) public fundsRaised;
552 
553     // Start time of the STO
554     uint256 public startTime;
555     // End time of the STO
556     uint256 public endTime;
557     // Time STO was paused
558     uint256 public pausedTime;
559     // Number of individual investors
560     uint256 public investorCount;
561     // Address where ETH & POLY funds are delivered
562     address public wallet;
563      // Final amount of tokens sold
564     uint256 public totalTokensSold;
565 
566 }
567 
568 /**
569  * @title SafeMath
570  * @dev Math operations with safety checks that throw on error
571  */
572 library SafeMath {
573 
574   /**
575   * @dev Multiplies two numbers, throws on overflow.
576   */
577   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
578     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
579     // benefit is lost if 'b' is also tested.
580     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
581     if (a == 0) {
582       return 0;
583     }
584 
585     c = a * b;
586     assert(c / a == b);
587     return c;
588   }
589 
590   /**
591   * @dev Integer division of two numbers, truncating the quotient.
592   */
593   function div(uint256 a, uint256 b) internal pure returns (uint256) {
594     // assert(b > 0); // Solidity automatically throws when dividing by 0
595     // uint256 c = a / b;
596     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
597     return a / b;
598   }
599 
600   /**
601   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
602   */
603   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
604     assert(b <= a);
605     return a - b;
606   }
607 
608   /**
609   * @dev Adds two numbers, throws on overflow.
610   */
611   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
612     c = a + b;
613     assert(c >= a);
614     return c;
615   }
616 }
617 
618 /**
619  * @title Interface to be implemented by all STO modules
620  */
621 contract STO is ISTO, STOStorage, Module, Pausable  {
622     using SafeMath for uint256;
623 
624     enum FundRaiseType { ETH, POLY, SC }
625 
626     // Event
627     event SetFundRaiseTypes(FundRaiseType[] _fundRaiseTypes);
628 
629     /**
630      * @notice Returns funds raised by the STO
631      */
632     function getRaised(FundRaiseType _fundRaiseType) public view returns (uint256) {
633         return fundsRaised[uint8(_fundRaiseType)];
634     }
635 
636     /**
637      * @notice Pause (overridden function)
638      */
639     function pause() public onlyOwner {
640         /*solium-disable-next-line security/no-block-members*/
641         require(now < endTime, "STO has been finalized");
642         super._pause();
643     }
644 
645     /**
646      * @notice Unpause (overridden function)
647      */
648     function unpause() public onlyOwner {
649         super._unpause();
650     }
651 
652     function _setFundRaiseType(FundRaiseType[] _fundRaiseTypes) internal {
653         // FundRaiseType[] parameter type ensures only valid values for _fundRaiseTypes
654         require(_fundRaiseTypes.length > 0 && _fundRaiseTypes.length <= 3, "Raise type is not specified");
655         fundRaiseTypes[uint8(FundRaiseType.ETH)] = false;
656         fundRaiseTypes[uint8(FundRaiseType.POLY)] = false;
657         fundRaiseTypes[uint8(FundRaiseType.SC)] = false;
658         for (uint8 j = 0; j < _fundRaiseTypes.length; j++) {
659             fundRaiseTypes[uint8(_fundRaiseTypes[j])] = true;
660         }
661         emit SetFundRaiseTypes(_fundRaiseTypes);
662     }
663 
664     /**
665     * @notice Reclaims ERC20Basic compatible tokens
666     * @dev We duplicate here due to the overriden owner & onlyOwner
667     * @param _tokenContract The address of the token contract
668     */
669     function reclaimERC20(address _tokenContract) external onlyOwner {
670         require(_tokenContract != address(0), "Invalid address");
671         IERC20 token = IERC20(_tokenContract);
672         uint256 balance = token.balanceOf(address(this));
673         require(token.transfer(msg.sender, balance), "Transfer failed");
674     }
675 
676     /**
677     * @notice Reclaims ETH
678     * @dev We duplicate here due to the overriden owner & onlyOwner
679     */
680     function reclaimETH() external onlyOwner {
681         msg.sender.transfer(address(this).balance);
682     }
683 
684 }
685 
686 /**
687  * @title Helps contracts guard agains reentrancy attacks.
688  * @author Remco Bloemen <remco@2π.com>
689  * @notice If you mark a function `nonReentrant`, you should also
690  * mark it `external`.
691  */
692 contract ReentrancyGuard {
693 
694   /**
695    * @dev We use a single lock for the whole contract.
696    */
697   bool private reentrancyLock = false;
698 
699   /**
700    * @dev Prevents a contract from calling itself, directly or indirectly.
701    * @notice If you mark a function `nonReentrant`, you should also
702    * mark it `external`. Calling one nonReentrant function from
703    * another is not supported. Instead, you can implement a
704    * `private` function doing the actual work, and a `external`
705    * wrapper marked as `nonReentrant`.
706    */
707   modifier nonReentrant() {
708     require(!reentrancyLock);
709     reentrancyLock = true;
710     _;
711     reentrancyLock = false;
712   }
713 
714 }
715 
716 /**
717  * @title STO module for standard capped crowdsale
718  */
719 contract CappedSTO is STO, ReentrancyGuard {
720     using SafeMath for uint256;
721 
722     // Determine whether users can invest on behalf of a beneficiary
723     bool public allowBeneficialInvestments = false;
724     // How many token units a buyer gets (multiplied by 10^18) per wei / base unit of POLY
725     // If rate is 10^18, buyer will get 1 token unit for every wei / base unit of poly.
726     uint256 public rate;
727     //How many token base units this STO will be allowed to sell to investors
728     // 1 full token = 10^decimals_of_token base units
729     uint256 public cap;
730 
731     mapping (address => uint256) public investors;
732 
733     /**
734     * Event for token purchase logging
735     * @param purchaser who paid for the tokens
736     * @param beneficiary who got the tokens
737     * @param value weis paid for purchase
738     * @param amount amount of tokens purchased
739     */
740     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
741 
742     event SetAllowBeneficialInvestments(bool _allowed);
743 
744     constructor (address _securityToken, address _polyAddress) public
745     Module(_securityToken, _polyAddress)
746     {
747     }
748 
749     //////////////////////////////////
750     /**
751     * @notice fallback function ***DO NOT OVERRIDE***
752     */
753     function () external payable {
754         buyTokens(msg.sender);
755     }
756 
757     /**
758      * @notice Function used to intialize the contract variables
759      * @param _startTime Unix timestamp at which offering get started
760      * @param _endTime Unix timestamp at which offering get ended
761      * @param _cap Maximum No. of token base units for sale
762      * @param _rate Token units a buyer gets multiplied by 10^18 per wei / base unit of POLY
763      * @param _fundRaiseTypes Type of currency used to collect the funds
764      * @param _fundsReceiver Ethereum account address to hold the funds
765      */
766     function configure(
767         uint256 _startTime,
768         uint256 _endTime,
769         uint256 _cap,
770         uint256 _rate,
771         FundRaiseType[] _fundRaiseTypes,
772         address _fundsReceiver
773     )
774     public
775     onlyFactory
776     {
777         require(endTime == 0, "Already configured");
778         require(_rate > 0, "Rate of token should be greater than 0");
779         require(_fundsReceiver != address(0), "Zero address is not permitted");
780         /*solium-disable-next-line security/no-block-members*/
781         require(_startTime >= now && _endTime > _startTime, "Date parameters are not valid");
782         require(_cap > 0, "Cap should be greater than 0");
783         require(_fundRaiseTypes.length == 1, "It only selects single fund raise type");
784         startTime = _startTime;
785         endTime = _endTime;
786         cap = _cap;
787         rate = _rate;
788         wallet = _fundsReceiver;
789         _setFundRaiseType(_fundRaiseTypes);
790     }
791 
792     /**
793      * @notice This function returns the signature of configure function
794      */
795     function getInitFunction() public pure returns (bytes4) {
796         return bytes4(keccak256("configure(uint256,uint256,uint256,uint256,uint8[],address)"));
797     }
798 
799     /**
800      * @notice Function to set allowBeneficialInvestments (allow beneficiary to be different to funder)
801      * @param _allowBeneficialInvestments Boolean to allow or disallow beneficial investments
802      */
803     function changeAllowBeneficialInvestments(bool _allowBeneficialInvestments) public onlyOwner {
804         require(_allowBeneficialInvestments != allowBeneficialInvestments, "Does not change value");
805         allowBeneficialInvestments = _allowBeneficialInvestments;
806         emit SetAllowBeneficialInvestments(allowBeneficialInvestments);
807     }
808 
809     /**
810       * @notice Low level token purchase ***DO NOT OVERRIDE***
811       * @param _beneficiary Address performing the token purchase
812       */
813     function buyTokens(address _beneficiary) public payable nonReentrant {
814         if (!allowBeneficialInvestments) {
815             require(_beneficiary == msg.sender, "Beneficiary address does not match msg.sender");
816         }
817 
818         require(!paused, "Should not be paused");
819         require(fundRaiseTypes[uint8(FundRaiseType.ETH)], "Mode of investment is not ETH");
820 
821         uint256 weiAmount = msg.value;
822         uint256 refund = _processTx(_beneficiary, weiAmount);
823         weiAmount = weiAmount.sub(refund);
824 
825         _forwardFunds(refund);
826     }
827 
828     /**
829       * @notice low level token purchase
830       * @param _investedPOLY Amount of POLY invested
831       */
832     function buyTokensWithPoly(uint256 _investedPOLY) public nonReentrant{
833         require(!paused, "Should not be paused");
834         require(fundRaiseTypes[uint8(FundRaiseType.POLY)], "Mode of investment is not POLY");
835         uint256 refund = _processTx(msg.sender, _investedPOLY);
836         _forwardPoly(msg.sender, wallet, _investedPOLY.sub(refund));
837     }
838 
839     /**
840     * @notice Checks whether the cap has been reached.
841     * @return bool Whether the cap was reached
842     */
843     function capReached() public view returns (bool) {
844         return totalTokensSold >= cap;
845     }
846 
847     /**
848      * @notice Return the total no. of tokens sold
849      */
850     function getTokensSold() public view returns (uint256) {
851         return totalTokensSold;
852     }
853 
854     /**
855      * @notice Return the permissions flag that are associated with STO
856      */
857     function getPermissions() public view returns(bytes32[]) {
858         bytes32[] memory allPermissions = new bytes32[](0);
859         return allPermissions;
860     }
861 
862     /**
863      * @notice Return the STO details
864      * @return Unixtimestamp at which offering gets start.
865      * @return Unixtimestamp at which offering ends.
866      * @return Number of token base units this STO will be allowed to sell to investors.
867      * @return Token units a buyer gets(multiplied by 10^18) per wei / base unit of POLY
868      * @return Amount of funds raised
869      * @return Number of individual investors this STO have.
870      * @return Amount of tokens get sold.
871      * @return Boolean value to justify whether the fund raise type is POLY or not, i.e true for POLY.
872      */
873     function getSTODetails() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool) {
874         return (
875             startTime,
876             endTime,
877             cap,
878             rate,
879             (fundRaiseTypes[uint8(FundRaiseType.POLY)]) ? fundsRaised[uint8(FundRaiseType.POLY)]: fundsRaised[uint8(FundRaiseType.ETH)],
880             investorCount,
881             totalTokensSold,
882             (fundRaiseTypes[uint8(FundRaiseType.POLY)])
883         );
884     }
885 
886     // -----------------------------------------
887     // Internal interface (extensible)
888     // -----------------------------------------
889     /**
890       * Processing the purchase as well as verify the required validations
891       * @param _beneficiary Address performing the token purchase
892       * @param _investedAmount Value in wei involved in the purchase
893     */
894     function _processTx(address _beneficiary, uint256 _investedAmount) internal returns(uint256 refund) {
895 
896         _preValidatePurchase(_beneficiary, _investedAmount);
897         // calculate token amount to be created
898         uint256 tokens;
899         (tokens, refund) = _getTokenAmount(_investedAmount);
900         _investedAmount = _investedAmount.sub(refund);
901 
902         // update state
903         if (fundRaiseTypes[uint8(FundRaiseType.POLY)]) {
904             fundsRaised[uint8(FundRaiseType.POLY)] = fundsRaised[uint8(FundRaiseType.POLY)].add(_investedAmount);
905         } else {
906             fundsRaised[uint8(FundRaiseType.ETH)] = fundsRaised[uint8(FundRaiseType.ETH)].add(_investedAmount);
907         }
908         totalTokensSold = totalTokensSold.add(tokens);
909 
910         _processPurchase(_beneficiary, tokens);
911         emit TokenPurchase(msg.sender, _beneficiary, _investedAmount, tokens);
912     }
913 
914     /**
915     * @notice Validation of an incoming purchase.
916       Use require statements to revert state when conditions are not met. Use super to concatenate validations.
917     * @param _beneficiary Address performing the token purchase
918     * @param _investedAmount Value in wei involved in the purchase
919     */
920     function _preValidatePurchase(address _beneficiary, uint256 _investedAmount) internal view {
921         require(_beneficiary != address(0), "Beneficiary address should not be 0x");
922         require(_investedAmount != 0, "Amount invested should not be equal to 0");
923         /*solium-disable-next-line security/no-block-members*/
924         require(now >= startTime && now <= endTime, "Offering is closed/Not yet started");
925     }
926 
927     /**
928     * @notice Source of tokens.
929       Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
930     * @param _beneficiary Address performing the token purchase
931     * @param _tokenAmount Number of tokens to be emitted
932     */
933     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
934         require(ISecurityToken(securityToken).mint(_beneficiary, _tokenAmount), "Error in minting the tokens");
935     }
936 
937     /**
938     * @notice Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
939     * @param _beneficiary Address receiving the tokens
940     * @param _tokenAmount Number of tokens to be purchased
941     */
942     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
943         if (investors[_beneficiary] == 0) {
944             investorCount = investorCount + 1;
945         }
946         investors[_beneficiary] = investors[_beneficiary].add(_tokenAmount);
947 
948         _deliverTokens(_beneficiary, _tokenAmount);
949     }
950 
951     /**
952     * @notice Overrides to extend the way in which ether is converted to tokens.
953     * @param _investedAmount Value in wei to be converted into tokens
954     * @return Number of tokens that can be purchased with the specified _investedAmount
955     * @return Remaining amount that should be refunded to the investor
956     */
957     function _getTokenAmount(uint256 _investedAmount) internal view returns (uint256 tokens, uint256 refund) {
958         tokens = _investedAmount.mul(rate);
959         tokens = tokens.div(uint256(10) ** 18);
960         if (totalTokensSold.add(tokens) > cap) {
961             tokens = cap.sub(totalTokensSold);
962         }
963         uint256 granularity = ISecurityToken(securityToken).granularity();
964         tokens = tokens.div(granularity);
965         tokens = tokens.mul(granularity);
966         require(tokens > 0, "Cap reached");
967         refund = _investedAmount.sub((tokens.mul(uint256(10) ** 18)).div(rate));
968     }
969 
970     /**
971     * @notice Determines how ETH is stored/forwarded on purchases.
972     */
973     function _forwardFunds(uint256 _refund) internal {
974         wallet.transfer(msg.value.sub(_refund));
975         msg.sender.transfer(_refund);
976     }
977 
978     /**
979      * @notice Internal function used to forward the POLY raised to beneficiary address
980      * @param _beneficiary Address of the funds reciever
981      * @param _to Address who wants to ST-20 tokens
982      * @param _fundsAmount Amount invested by _to
983      */
984     function _forwardPoly(address _beneficiary, address _to, uint256 _fundsAmount) internal {
985         polyToken.transferFrom(_beneficiary, _to, _fundsAmount);
986     }
987 
988 }
989 
990 /**
991  * @title Interface that every module factory contract should implement
992  */
993 interface IModuleFactory {
994 
995     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
996     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
997     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
998     event GenerateModuleFromFactory(
999         address _module,
1000         bytes32 indexed _moduleName,
1001         address indexed _moduleFactory,
1002         address _creator,
1003         uint256 _setupCost,
1004         uint256 _timestamp
1005     );
1006     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1007 
1008     //Should create an instance of the Module, or throw
1009     function deploy(bytes _data) external returns(address);
1010 
1011     /**
1012      * @notice Type of the Module factory
1013      */
1014     function getTypes() external view returns(uint8[]);
1015 
1016     /**
1017      * @notice Get the name of the Module
1018      */
1019     function getName() external view returns(bytes32);
1020 
1021     /**
1022      * @notice Returns the instructions associated with the module
1023      */
1024     function getInstructions() external view returns (string);
1025 
1026     /**
1027      * @notice Get the tags related to the module factory
1028      */
1029     function getTags() external view returns (bytes32[]);
1030 
1031     /**
1032      * @notice Used to change the setup fee
1033      * @param _newSetupCost New setup fee
1034      */
1035     function changeFactorySetupFee(uint256 _newSetupCost) external;
1036 
1037     /**
1038      * @notice Used to change the usage fee
1039      * @param _newUsageCost New usage fee
1040      */
1041     function changeFactoryUsageFee(uint256 _newUsageCost) external;
1042 
1043     /**
1044      * @notice Used to change the subscription fee
1045      * @param _newSubscriptionCost New subscription fee
1046      */
1047     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
1048 
1049     /**
1050      * @notice Function use to change the lower and upper bound of the compatible version st
1051      * @param _boundType Type of bound
1052      * @param _newVersion New version array
1053      */
1054     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
1055 
1056    /**
1057      * @notice Get the setup cost of the module
1058      */
1059     function getSetupCost() external view returns (uint256);
1060 
1061     /**
1062      * @notice Used to get the lower bound
1063      * @return Lower bound
1064      */
1065     function getLowerSTVersionBounds() external view returns(uint8[]);
1066 
1067      /**
1068      * @notice Used to get the upper bound
1069      * @return Upper bound
1070      */
1071     function getUpperSTVersionBounds() external view returns(uint8[]);
1072 
1073 }
1074 
1075 /**
1076  * @title Helper library use to compare or validate the semantic versions
1077  */
1078 
1079 library VersionUtils {
1080 
1081     /**
1082      * @notice This function is used to validate the version submitted
1083      * @param _current Array holds the present version of ST
1084      * @param _new Array holds the latest version of the ST
1085      * @return bool
1086      */
1087     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
1088         bool[] memory _temp = new bool[](_current.length);
1089         uint8 counter = 0;
1090         for (uint8 i = 0; i < _current.length; i++) {
1091             if (_current[i] < _new[i])
1092                 _temp[i] = true;
1093             else
1094                 _temp[i] = false;
1095         }
1096 
1097         for (i = 0; i < _current.length; i++) {
1098             if (i == 0) {
1099                 if (_current[i] <= _new[i])
1100                     if(_temp[0]) {
1101                         counter = counter + 3;
1102                         break;
1103                     } else
1104                         counter++;
1105                 else
1106                     return false;
1107             } else {
1108                 if (_temp[i-1])
1109                     counter++;
1110                 else if (_current[i] <= _new[i])
1111                     counter++;
1112                 else
1113                     return false;
1114             }
1115         }
1116         if (counter == _current.length)
1117             return true;
1118     }
1119 
1120     /**
1121      * @notice Used to compare the lower bound with the latest version
1122      * @param _version1 Array holds the lower bound of the version
1123      * @param _version2 Array holds the latest version of the ST
1124      * @return bool
1125      */
1126     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1127         require(_version1.length == _version2.length, "Input length mismatch");
1128         uint counter = 0;
1129         for (uint8 j = 0; j < _version1.length; j++) {
1130             if (_version1[j] == 0)
1131                 counter ++;
1132         }
1133         if (counter != _version1.length) {
1134             counter = 0;
1135             for (uint8 i = 0; i < _version1.length; i++) {
1136                 if (_version2[i] > _version1[i])
1137                     return true;
1138                 else if (_version2[i] < _version1[i])
1139                     return false;
1140                 else
1141                     counter++;
1142             }
1143             if (counter == _version1.length - 1)
1144                 return true;
1145             else
1146                 return false;
1147         } else
1148             return true;
1149     }
1150 
1151     /**
1152      * @notice Used to compare the upper bound with the latest version
1153      * @param _version1 Array holds the upper bound of the version
1154      * @param _version2 Array holds the latest version of the ST
1155      * @return bool
1156      */
1157     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1158         require(_version1.length == _version2.length, "Input length mismatch");
1159         uint counter = 0;
1160         for (uint8 j = 0; j < _version1.length; j++) {
1161             if (_version1[j] == 0)
1162                 counter ++;
1163         }
1164         if (counter != _version1.length) {
1165             counter = 0;
1166             for (uint8 i = 0; i < _version1.length; i++) {
1167                 if (_version1[i] > _version2[i])
1168                     return true;
1169                 else if (_version1[i] < _version2[i])
1170                     return false;
1171                 else
1172                     counter++;
1173             }
1174             if (counter == _version1.length - 1)
1175                 return true;
1176             else
1177                 return false;
1178         } else
1179             return true;
1180     }
1181 
1182 
1183     /**
1184      * @notice Used to pack the uint8[] array data into uint24 value
1185      * @param _major Major version
1186      * @param _minor Minor version
1187      * @param _patch Patch version
1188      */
1189     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
1190         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
1191     }
1192 
1193     /**
1194      * @notice Used to convert packed data into uint8 array
1195      * @param _packedVersion Packed data
1196      */
1197     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
1198         uint8[] memory _unpackVersion = new uint8[](3);
1199         _unpackVersion[0] = uint8(_packedVersion >> 16);
1200         _unpackVersion[1] = uint8(_packedVersion >> 8);
1201         _unpackVersion[2] = uint8(_packedVersion);
1202         return _unpackVersion;
1203     }
1204 
1205 
1206 }
1207 
1208 /**
1209  * @title Interface that any module factory contract should implement
1210  * @notice Contract is abstract
1211  */
1212 contract ModuleFactory is IModuleFactory, Ownable {
1213 
1214     IERC20 public polyToken;
1215     uint256 public usageCost;
1216     uint256 public monthlySubscriptionCost;
1217 
1218     uint256 public setupCost;
1219     string public description;
1220     string public version;
1221     bytes32 public name;
1222     string public title;
1223 
1224     // @notice Allow only two variables to be stored
1225     // 1. lowerBound 
1226     // 2. upperBound
1227     // @dev (0.0.0 will act as the wildcard) 
1228     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
1229     mapping(string => uint24) compatibleSTVersionRange;
1230 
1231     /**
1232      * @notice Constructor
1233      * @param _polyAddress Address of the polytoken
1234      */
1235     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
1236         polyToken = IERC20(_polyAddress);
1237         setupCost = _setupCost;
1238         usageCost = _usageCost;
1239         monthlySubscriptionCost = _subscriptionCost;
1240     }
1241 
1242     /**
1243      * @notice Used to change the fee of the setup cost
1244      * @param _newSetupCost new setup cost
1245      */
1246     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
1247         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
1248         setupCost = _newSetupCost;
1249     }
1250 
1251     /**
1252      * @notice Used to change the fee of the usage cost
1253      * @param _newUsageCost new usage cost
1254      */
1255     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
1256         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
1257         usageCost = _newUsageCost;
1258     }
1259 
1260     /**
1261      * @notice Used to change the fee of the subscription cost
1262      * @param _newSubscriptionCost new subscription cost
1263      */
1264     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
1265         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
1266         monthlySubscriptionCost = _newSubscriptionCost;
1267 
1268     }
1269 
1270     /**
1271      * @notice Updates the title of the ModuleFactory
1272      * @param _newTitle New Title that will replace the old one.
1273      */
1274     function changeTitle(string _newTitle) public onlyOwner {
1275         require(bytes(_newTitle).length > 0, "Invalid title");
1276         title = _newTitle;
1277     }
1278 
1279     /**
1280      * @notice Updates the description of the ModuleFactory
1281      * @param _newDesc New description that will replace the old one.
1282      */
1283     function changeDescription(string _newDesc) public onlyOwner {
1284         require(bytes(_newDesc).length > 0, "Invalid description");
1285         description = _newDesc;
1286     }
1287 
1288     /**
1289      * @notice Updates the name of the ModuleFactory
1290      * @param _newName New name that will replace the old one.
1291      */
1292     function changeName(bytes32 _newName) public onlyOwner {
1293         require(_newName != bytes32(0),"Invalid name");
1294         name = _newName;
1295     }
1296 
1297     /**
1298      * @notice Updates the version of the ModuleFactory
1299      * @param _newVersion New name that will replace the old one.
1300      */
1301     function changeVersion(string _newVersion) public onlyOwner {
1302         require(bytes(_newVersion).length > 0, "Invalid version");
1303         version = _newVersion;
1304     }
1305 
1306     /**
1307      * @notice Function use to change the lower and upper bound of the compatible version st
1308      * @param _boundType Type of bound
1309      * @param _newVersion new version array
1310      */
1311     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
1312         require(
1313             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
1314             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
1315             "Must be a valid bound type"
1316         );
1317         require(_newVersion.length == 3);
1318         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
1319             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
1320             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
1321         }
1322         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
1323         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
1324     }
1325 
1326     /**
1327      * @notice Used to get the lower bound
1328      * @return lower bound
1329      */
1330     function getLowerSTVersionBounds() external view returns(uint8[]) {
1331         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
1332     }
1333 
1334     /**
1335      * @notice Used to get the upper bound
1336      * @return upper bound
1337      */
1338     function getUpperSTVersionBounds() external view returns(uint8[]) {
1339         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
1340     }
1341 
1342     /**
1343      * @notice Get the setup cost of the module
1344      */
1345     function getSetupCost() external view returns (uint256) {
1346         return setupCost;
1347     }
1348 
1349    /**
1350     * @notice Get the name of the Module
1351     */
1352     function getName() public view returns(bytes32) {
1353         return name;
1354     }
1355 
1356 }
1357 
1358 /**
1359  * @title Utility contract for reusable code
1360  */
1361 library Util {
1362 
1363    /**
1364     * @notice Changes a string to upper case
1365     * @param _base String to change
1366     */
1367     function upper(string _base) internal pure returns (string) {
1368         bytes memory _baseBytes = bytes(_base);
1369         for (uint i = 0; i < _baseBytes.length; i++) {
1370             bytes1 b1 = _baseBytes[i];
1371             if (b1 >= 0x61 && b1 <= 0x7A) {
1372                 b1 = bytes1(uint8(b1)-32);
1373             }
1374             _baseBytes[i] = b1;
1375         }
1376         return string(_baseBytes);
1377     }
1378 
1379     /**
1380      * @notice Changes the string into bytes32
1381      * @param _source String that need to convert into bytes32
1382      */
1383     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1384     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
1385         return bytesToBytes32(bytes(_source), 0);
1386     }
1387 
1388     /**
1389      * @notice Changes bytes into bytes32
1390      * @param _b Bytes that need to convert into bytes32
1391      * @param _offset Offset from which to begin conversion
1392      */
1393     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1394     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
1395         bytes32 result;
1396 
1397         for (uint i = 0; i < _b.length; i++) {
1398             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
1399         }
1400         return result;
1401     }
1402 
1403     /**
1404      * @notice Changes the bytes32 into string
1405      * @param _source that need to convert into string
1406      */
1407     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
1408         bytes memory bytesString = new bytes(32);
1409         uint charCount = 0;
1410         for (uint j = 0; j < 32; j++) {
1411             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
1412             if (char != 0) {
1413                 bytesString[charCount] = char;
1414                 charCount++;
1415             }
1416         }
1417         bytes memory bytesStringTrimmed = new bytes(charCount);
1418         for (j = 0; j < charCount; j++) {
1419             bytesStringTrimmed[j] = bytesString[j];
1420         }
1421         return string(bytesStringTrimmed);
1422     }
1423 
1424     /**
1425      * @notice Gets function signature from _data
1426      * @param _data Passed data
1427      * @return bytes4 sig
1428      */
1429     function getSig(bytes _data) internal pure returns (bytes4 sig) {
1430         uint len = _data.length < 4 ? _data.length : 4;
1431         for (uint i = 0; i < len; i++) {
1432             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
1433         }
1434     }
1435 
1436 
1437 }
1438 
1439 /**
1440  * @title Factory for deploying CappedSTO module
1441  */
1442 contract CappedSTOFactory is ModuleFactory {
1443 
1444     /**
1445      * @notice Constructor
1446      * @param _polyAddress Address of the polytoken
1447      */
1448     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1449     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1450     {
1451         version = "2.1.0";
1452         name = "CappedSTO";
1453         title = "Capped STO";
1454         description = "This smart contract creates a maximum number of tokens (i.e. hard cap) which the total aggregate of tokens acquired by all investors cannot exceed. Security tokens are sent to the investor upon reception of the funds (ETH or POLY), and any security tokens left upon termination of the offering will not be minted.";
1455         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1456         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1457     }
1458 
1459      /**
1460      * @notice Used to launch the Module with the help of factory
1461      * @return address Contract address of the Module
1462      */
1463     function deploy(bytes _data) external returns(address) {
1464         if(setupCost > 0)
1465             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Sufficent Allowance is not provided");
1466         //Check valid bytes - can only call module init function
1467         CappedSTO cappedSTO = new CappedSTO(msg.sender, address(polyToken));
1468         //Checks that _data is valid (not calling anything it shouldn't)
1469         require(Util.getSig(_data) == cappedSTO.getInitFunction(), "Invalid data");
1470         /*solium-disable-next-line security/no-low-level-calls*/
1471         require(address(cappedSTO).call(_data), "Unsuccessfull call");
1472         /*solium-disable-next-line security/no-block-members*/
1473         emit GenerateModuleFromFactory(address(cappedSTO), getName(), address(this), msg.sender, setupCost, now);
1474         return address(cappedSTO);
1475     }
1476 
1477     /**
1478      * @notice Type of the Module factory
1479      */
1480     function getTypes() external view returns(uint8[]) {
1481         uint8[] memory res = new uint8[](1);
1482         res[0] = 3;
1483         return res;
1484     }
1485 
1486     /**
1487      * @notice Returns the instructions associated with the module
1488      */
1489     function getInstructions() external view returns(string) {
1490         /*solium-disable-next-line max-len*/
1491         return "Initialises a capped STO. Init parameters are _startTime (time STO starts), _endTime (time STO ends), _cap (cap in tokens for STO), _rate (POLY/ETH to token rate), _fundRaiseType (whether you are raising in POLY or ETH), _polyToken (address of POLY token), _fundsReceiver (address which will receive funds)";
1492     }
1493 
1494     /**
1495      * @notice Get the tags related to the module factory
1496      */
1497     function getTags() external view returns(bytes32[]) {
1498         bytes32[] memory availableTags = new bytes32[](4);
1499         availableTags[0] = "Capped";
1500         availableTags[1] = "Non-refundable";
1501         availableTags[2] = "POLY";
1502         availableTags[3] = "ETH";
1503         return availableTags;
1504     }
1505 
1506 }