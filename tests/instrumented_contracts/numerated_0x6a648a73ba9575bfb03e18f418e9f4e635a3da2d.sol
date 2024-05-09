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
517  * @title Interface to be implemented by all Transfer Manager modules
518  * @dev abstract contract
519  */
520 contract ITransferManager is Module, Pausable {
521 
522     //If verifyTransfer returns:
523     //  FORCE_VALID, the transaction will always be valid, regardless of other TM results
524     //  INVALID, then the transfer should not be allowed regardless of other TM results
525     //  VALID, then the transfer is valid for this TM
526     //  NA, then the result from this TM is ignored
527     enum Result {INVALID, NA, VALID, FORCE_VALID}
528 
529     function verifyTransfer(address _from, address _to, uint256 _amount, bytes _data, bool _isTransfer) public returns(Result);
530 
531     function unpause() public onlyOwner {
532         super._unpause();
533     }
534 
535     function pause() public onlyOwner {
536         super._pause();
537     }
538 }
539 
540 /**
541  * @title SafeMath
542  * @dev Math operations with safety checks that throw on error
543  */
544 library SafeMath {
545 
546   /**
547   * @dev Multiplies two numbers, throws on overflow.
548   */
549   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
550     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
551     // benefit is lost if 'b' is also tested.
552     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
553     if (a == 0) {
554       return 0;
555     }
556 
557     c = a * b;
558     assert(c / a == b);
559     return c;
560   }
561 
562   /**
563   * @dev Integer division of two numbers, truncating the quotient.
564   */
565   function div(uint256 a, uint256 b) internal pure returns (uint256) {
566     // assert(b > 0); // Solidity automatically throws when dividing by 0
567     // uint256 c = a / b;
568     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
569     return a / b;
570   }
571 
572   /**
573   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
574   */
575   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
576     assert(b <= a);
577     return a - b;
578   }
579 
580   /**
581   * @dev Adds two numbers, throws on overflow.
582   */
583   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
584     c = a + b;
585     assert(c >= a);
586     return c;
587   }
588 }
589 
590 /**
591  * @title Transfer Manager module for core transfer validation functionality
592  */
593 contract GeneralTransferManager is ITransferManager {
594 
595     using SafeMath for uint256;
596 
597     //Address from which issuances come
598     address public issuanceAddress = address(0);
599 
600     //Address which can sign whitelist changes
601     address public signingAddress = address(0);
602 
603     bytes32 public constant WHITELIST = "WHITELIST";
604     bytes32 public constant FLAGS = "FLAGS";
605 
606     //from and to timestamps that an investor can send / receive tokens respectively
607     struct TimeRestriction {
608         uint256 fromTime;
609         uint256 toTime;
610         uint256 expiryTime;
611         bool canBuyFromSTO;
612     }
613 
614     // An address can only send / receive tokens once their corresponding uint256 > block.number
615     // (unless allowAllTransfers == true or allowAllWhitelistTransfers == true)
616     mapping (address => TimeRestriction) public whitelist;
617     // Map of used nonces by customer
618     mapping(address => mapping(uint256 => bool)) public nonceMap;  
619 
620     //If true, there are no transfer restrictions, for any addresses
621     bool public allowAllTransfers = false;
622     //If true, time lock is ignored for transfers (address must still be on whitelist)
623     bool public allowAllWhitelistTransfers = false;
624     //If true, time lock is ignored for issuances (address must still be on whitelist)
625     bool public allowAllWhitelistIssuances = true;
626     //If true, time lock is ignored for burn transactions
627     bool public allowAllBurnTransfers = false;
628 
629     // Emit when Issuance address get changed
630     event ChangeIssuanceAddress(address _issuanceAddress);
631     // Emit when there is change in the flag variable called allowAllTransfers
632     event AllowAllTransfers(bool _allowAllTransfers);
633     // Emit when there is change in the flag variable called allowAllWhitelistTransfers
634     event AllowAllWhitelistTransfers(bool _allowAllWhitelistTransfers);
635     // Emit when there is change in the flag variable called allowAllWhitelistIssuances
636     event AllowAllWhitelistIssuances(bool _allowAllWhitelistIssuances);
637     // Emit when there is change in the flag variable called allowAllBurnTransfers
638     event AllowAllBurnTransfers(bool _allowAllBurnTransfers);
639     // Emit when there is change in the flag variable called signingAddress
640     event ChangeSigningAddress(address _signingAddress);
641     // Emit when investor details get modified related to their whitelisting
642     event ModifyWhitelist(
643         address _investor,
644         uint256 _dateAdded,
645         address _addedBy,
646         uint256 _fromTime,
647         uint256 _toTime,
648         uint256 _expiryTime,
649         bool _canBuyFromSTO
650     );
651 
652     /**
653      * @notice Constructor
654      * @param _securityToken Address of the security token
655      * @param _polyAddress Address of the polytoken
656      */
657     constructor (address _securityToken, address _polyAddress)
658     public
659     Module(_securityToken, _polyAddress)
660     {
661     }
662 
663     /**
664      * @notice This function returns the signature of configure function
665      */
666     function getInitFunction() public pure returns (bytes4) {
667         return bytes4(0);
668     }
669 
670     /**
671      * @notice Used to change the Issuance Address
672      * @param _issuanceAddress new address for the issuance
673      */
674     function changeIssuanceAddress(address _issuanceAddress) public withPerm(FLAGS) {
675         issuanceAddress = _issuanceAddress;
676         emit ChangeIssuanceAddress(_issuanceAddress);
677     }
678 
679     /**
680      * @notice Used to change the Sigining Address
681      * @param _signingAddress new address for the signing
682      */
683     function changeSigningAddress(address _signingAddress) public withPerm(FLAGS) {
684         signingAddress = _signingAddress;
685         emit ChangeSigningAddress(_signingAddress);
686     }
687 
688     /**
689      * @notice Used to change the flag
690             true - It refers there are no transfer restrictions, for any addresses
691             false - It refers transfers are restricted for all addresses.
692      * @param _allowAllTransfers flag value
693      */
694     function changeAllowAllTransfers(bool _allowAllTransfers) public withPerm(FLAGS) {
695         allowAllTransfers = _allowAllTransfers;
696         emit AllowAllTransfers(_allowAllTransfers);
697     }
698 
699     /**
700      * @notice Used to change the flag
701             true - It refers that time lock is ignored for transfers (address must still be on whitelist)
702             false - It refers transfers are restricted for all addresses.
703      * @param _allowAllWhitelistTransfers flag value
704      */
705     function changeAllowAllWhitelistTransfers(bool _allowAllWhitelistTransfers) public withPerm(FLAGS) {
706         allowAllWhitelistTransfers = _allowAllWhitelistTransfers;
707         emit AllowAllWhitelistTransfers(_allowAllWhitelistTransfers);
708     }
709 
710     /**
711      * @notice Used to change the flag
712             true - It refers that time lock is ignored for issuances (address must still be on whitelist)
713             false - It refers transfers are restricted for all addresses.
714      * @param _allowAllWhitelistIssuances flag value
715      */
716     function changeAllowAllWhitelistIssuances(bool _allowAllWhitelistIssuances) public withPerm(FLAGS) {
717         allowAllWhitelistIssuances = _allowAllWhitelistIssuances;
718         emit AllowAllWhitelistIssuances(_allowAllWhitelistIssuances);
719     }
720 
721     /**
722      * @notice Used to change the flag
723             true - It allow to burn the tokens
724             false - It deactivate the burning mechanism.
725      * @param _allowAllBurnTransfers flag value
726      */
727     function changeAllowAllBurnTransfers(bool _allowAllBurnTransfers) public withPerm(FLAGS) {
728         allowAllBurnTransfers = _allowAllBurnTransfers;
729         emit AllowAllBurnTransfers(_allowAllBurnTransfers);
730     }
731 
732     /**
733      * @notice Default implementation of verifyTransfer used by SecurityToken
734      * If the transfer request comes from the STO, it only checks that the investor is in the whitelist
735      * If the transfer request comes from a token holder, it checks that:
736      * a) Both are on the whitelist
737      * b) Seller's sale lockup period is over
738      * c) Buyer's purchase lockup is over
739      * @param _from Address of the sender
740      * @param _to Address of the receiver
741     */
742     function verifyTransfer(address _from, address _to, uint256 /*_amount*/, bytes /* _data */, bool /* _isTransfer */) public returns(Result) {
743         if (!paused) {
744             if (allowAllTransfers) {
745                 //All transfers allowed, regardless of whitelist
746                 return Result.VALID;
747             }
748             if (allowAllBurnTransfers && (_to == address(0))) {
749                 return Result.VALID;
750             }
751             if (allowAllWhitelistTransfers) {
752                 //Anyone on the whitelist can transfer, regardless of time
753                 return (_onWhitelist(_to) && _onWhitelist(_from)) ? Result.VALID : Result.NA;
754             }
755             if (allowAllWhitelistIssuances && _from == issuanceAddress) {
756                 if (!whitelist[_to].canBuyFromSTO && _isSTOAttached()) {
757                     return Result.NA;
758                 }
759                 return _onWhitelist(_to) ? Result.VALID : Result.NA;
760             }
761             //Anyone on the whitelist can transfer provided the blocknumber is large enough
762             /*solium-disable-next-line security/no-block-members*/
763             return ((_onWhitelist(_from) && whitelist[_from].fromTime <= now) &&
764                 (_onWhitelist(_to) && whitelist[_to].toTime <= now)) ? Result.VALID : Result.NA; /*solium-disable-line security/no-block-members*/
765         }
766         return Result.NA;
767     }
768 
769     /**
770     * @notice Adds or removes addresses from the whitelist.
771     * @param _investor is the address to whitelist
772     * @param _fromTime is the moment when the sale lockup period ends and the investor can freely sell his tokens
773     * @param _toTime is the moment when the purchase lockup period ends and the investor can freely purchase tokens from others
774     * @param _expiryTime is the moment till investors KYC will be validated. After that investor need to do re-KYC
775     * @param _canBuyFromSTO is used to know whether the investor is restricted investor or not.
776     */
777     function modifyWhitelist(
778         address _investor,
779         uint256 _fromTime,
780         uint256 _toTime,
781         uint256 _expiryTime,
782         bool _canBuyFromSTO
783     )
784         public
785         withPerm(WHITELIST)
786     {
787         //Passing a _time == 0 into this function, is equivalent to removing the _investor from the whitelist
788         whitelist[_investor] = TimeRestriction(_fromTime, _toTime, _expiryTime, _canBuyFromSTO);
789         /*solium-disable-next-line security/no-block-members*/
790         emit ModifyWhitelist(_investor, now, msg.sender, _fromTime, _toTime, _expiryTime, _canBuyFromSTO);
791     }
792 
793     /**
794     * @notice Adds or removes addresses from the whitelist.
795     * @param _investors List of the addresses to whitelist
796     * @param _fromTimes An array of the moment when the sale lockup period ends and the investor can freely sell his tokens
797     * @param _toTimes An array of the moment when the purchase lockup period ends and the investor can freely purchase tokens from others
798     * @param _expiryTimes An array of the moment till investors KYC will be validated. After that investor need to do re-KYC
799     * @param _canBuyFromSTO An array of boolean values
800     */
801     function modifyWhitelistMulti(
802         address[] _investors,
803         uint256[] _fromTimes,
804         uint256[] _toTimes,
805         uint256[] _expiryTimes,
806         bool[] _canBuyFromSTO
807     ) public withPerm(WHITELIST) {
808         require(_investors.length == _fromTimes.length, "Mismatched input lengths");
809         require(_fromTimes.length == _toTimes.length, "Mismatched input lengths");
810         require(_toTimes.length == _expiryTimes.length, "Mismatched input lengths");
811         require(_canBuyFromSTO.length == _toTimes.length, "Mismatched input length");
812         for (uint256 i = 0; i < _investors.length; i++) {
813             modifyWhitelist(_investors[i], _fromTimes[i], _toTimes[i], _expiryTimes[i], _canBuyFromSTO[i]);
814         }
815     }
816 
817     /**
818     * @notice Adds or removes addresses from the whitelist - can be called by anyone with a valid signature
819     * @param _investor is the address to whitelist
820     * @param _fromTime is the moment when the sale lockup period ends and the investor can freely sell his tokens
821     * @param _toTime is the moment when the purchase lockup period ends and the investor can freely purchase tokens from others
822     * @param _expiryTime is the moment till investors KYC will be validated. After that investor need to do re-KYC
823     * @param _canBuyFromSTO is used to know whether the investor is restricted investor or not.
824     * @param _validFrom is the time that this signature is valid from
825     * @param _validTo is the time that this signature is valid until
826     * @param _nonce nonce of signature (avoid replay attack)
827     * @param _v issuer signature
828     * @param _r issuer signature
829     * @param _s issuer signature
830     */
831     function modifyWhitelistSigned(
832         address _investor,
833         uint256 _fromTime,
834         uint256 _toTime,
835         uint256 _expiryTime,
836         bool _canBuyFromSTO,
837         uint256 _validFrom,
838         uint256 _validTo,
839         uint256 _nonce,
840         uint8 _v,
841         bytes32 _r,
842         bytes32 _s
843     ) public {
844         /*solium-disable-next-line security/no-block-members*/
845         require(_validFrom <= now, "ValidFrom is too early");
846         /*solium-disable-next-line security/no-block-members*/
847         require(_validTo >= now, "ValidTo is too late");
848         require(!nonceMap[_investor][_nonce], "Already used signature");
849         nonceMap[_investor][_nonce] = true;
850         bytes32 hash = keccak256(
851             abi.encodePacked(this, _investor, _fromTime, _toTime, _expiryTime, _canBuyFromSTO, _validFrom, _validTo, _nonce)
852         );
853         _checkSig(hash, _v, _r, _s);
854         //Passing a _time == 0 into this function, is equivalent to removing the _investor from the whitelist
855         whitelist[_investor] = TimeRestriction(_fromTime, _toTime, _expiryTime, _canBuyFromSTO);
856         /*solium-disable-next-line security/no-block-members*/
857         emit ModifyWhitelist(_investor, now, msg.sender, _fromTime, _toTime, _expiryTime, _canBuyFromSTO);
858     }
859 
860     /**
861      * @notice Used to verify the signature
862      */
863     function _checkSig(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal view {
864         //Check that the signature is valid
865         //sig should be signing - _investor, _fromTime, _toTime & _expiryTime and be signed by the issuer address
866         address signer = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)), _v, _r, _s);
867         require(signer == Ownable(securityToken).owner() || signer == signingAddress, "Incorrect signer");
868     }
869 
870     /**
871      * @notice Internal function used to check whether the investor is in the whitelist or not
872             & also checks whether the KYC of investor get expired or not
873      * @param _investor Address of the investor
874      */
875     function _onWhitelist(address _investor) internal view returns(bool) {
876         return (((whitelist[_investor].fromTime != 0) || (whitelist[_investor].toTime != 0)) &&
877             (whitelist[_investor].expiryTime >= now)); /*solium-disable-line security/no-block-members*/
878     }
879 
880     /**
881      * @notice Internal function use to know whether the STO is attached or not
882      */
883     function _isSTOAttached() internal view returns(bool) {
884         bool attached = ISecurityToken(securityToken).getModulesByType(3).length > 0;
885         return attached;
886     }
887 
888     /**
889      * @notice Return the permissions flag that are associated with general trnasfer manager
890      */
891     function getPermissions() public view returns(bytes32[]) {
892         bytes32[] memory allPermissions = new bytes32[](2);
893         allPermissions[0] = WHITELIST;
894         allPermissions[1] = FLAGS;
895         return allPermissions;
896     }
897 
898 }