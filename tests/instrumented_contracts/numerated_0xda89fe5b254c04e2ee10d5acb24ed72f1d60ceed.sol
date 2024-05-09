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
591  * @title Transfer Manager module for manually approving or blocking transactions between accounts
592  */
593 contract ManualApprovalTransferManager is ITransferManager {
594     using SafeMath for uint256;
595 
596     //Address from which issuances come
597     address public issuanceAddress = address(0);
598 
599     //Address which can sign whitelist changes
600     address public signingAddress = address(0);
601 
602     bytes32 public constant TRANSFER_APPROVAL = "TRANSFER_APPROVAL";
603 
604     //Manual approval is an allowance (that has been approved) with an expiry time
605     struct ManualApproval {
606         uint256 allowance;
607         uint256 expiryTime;
608     }
609 
610     //Manual blocking allows you to specify a list of blocked address pairs with an associated expiry time for the block
611     struct ManualBlocking {
612         uint256 expiryTime;
613     }
614 
615     //Store mappings of address => address with ManualApprovals
616     mapping (address => mapping (address => ManualApproval)) public manualApprovals;
617 
618     //Store mappings of address => address with ManualBlockings
619     mapping (address => mapping (address => ManualBlocking)) public manualBlockings;
620 
621     event AddManualApproval(
622         address indexed _from,
623         address indexed _to,
624         uint256 _allowance,
625         uint256 _expiryTime,
626         address indexed _addedBy
627     );
628 
629     event AddManualBlocking(
630         address indexed _from,
631         address indexed _to,
632         uint256 _expiryTime,
633         address indexed _addedBy
634     );
635 
636     event RevokeManualApproval(
637         address indexed _from,
638         address indexed _to,
639         address indexed _addedBy
640     );
641 
642     event RevokeManualBlocking(
643         address indexed _from,
644         address indexed _to,
645         address indexed _addedBy
646     );
647 
648     /**
649      * @notice Constructor
650      * @param _securityToken Address of the security token
651      * @param _polyAddress Address of the polytoken
652      */
653     constructor (address _securityToken, address _polyAddress)
654     public
655     Module(_securityToken, _polyAddress)
656     {
657     }
658 
659     /**
660      * @notice This function returns the signature of configure function
661      */
662     function getInitFunction() public pure returns (bytes4) {
663         return bytes4(0);
664     }
665 
666     /** @notice Used to verify the transfer transaction and allow a manually approved transqaction to bypass other restrictions
667      * @param _from Address of the sender
668      * @param _to Address of the receiver
669      * @param _amount The amount of tokens to transfer
670      * @param _isTransfer Whether or not this is an actual transfer or just a test to see if the tokens would be transferrable
671      */
672     function verifyTransfer(address _from, address _to, uint256 _amount, bytes /* _data */, bool _isTransfer) public returns(Result) {
673         // function must only be called by the associated security token if _isTransfer == true
674         require(_isTransfer == false || msg.sender == securityToken, "Sender is not the owner");
675         // manual blocking takes precidence over manual approval
676         if (!paused) {
677             /*solium-disable-next-line security/no-block-members*/
678             if (manualBlockings[_from][_to].expiryTime >= now) {
679                 return Result.INVALID;
680             }
681             /*solium-disable-next-line security/no-block-members*/
682             if ((manualApprovals[_from][_to].expiryTime >= now) && (manualApprovals[_from][_to].allowance >= _amount)) {
683                 if (_isTransfer) {
684                     manualApprovals[_from][_to].allowance = manualApprovals[_from][_to].allowance.sub(_amount);
685                 }
686                 return Result.VALID;
687             }
688         }
689         return Result.NA;
690     }
691 
692     /**
693     * @notice Adds a pair of addresses to manual approvals
694     * @param _from is the address from which transfers are approved
695     * @param _to is the address to which transfers are approved
696     * @param _allowance is the approved amount of tokens
697     * @param _expiryTime is the time until which the transfer is allowed
698     */
699     function addManualApproval(address _from, address _to, uint256 _allowance, uint256 _expiryTime) public withPerm(TRANSFER_APPROVAL) {
700         require(_from != address(0), "Invalid from address");
701         require(_to != address(0), "Invalid to address");
702         /*solium-disable-next-line security/no-block-members*/
703         require(_expiryTime > now, "Invalid expiry time");
704         require(manualApprovals[_from][_to].allowance == 0, "Approval already exists");
705         manualApprovals[_from][_to] = ManualApproval(_allowance, _expiryTime);
706         emit AddManualApproval(_from, _to, _allowance, _expiryTime, msg.sender);
707     }
708 
709     /**
710     * @notice Adds a pair of addresses to manual blockings
711     * @param _from is the address from which transfers are blocked
712     * @param _to is the address to which transfers are blocked
713     * @param _expiryTime is the time until which the transfer is blocked
714     */
715     function addManualBlocking(address _from, address _to, uint256 _expiryTime) public withPerm(TRANSFER_APPROVAL) {
716         require(_from != address(0), "Invalid from address");
717         require(_to != address(0), "Invalid to address");
718         /*solium-disable-next-line security/no-block-members*/
719         require(_expiryTime > now, "Invalid expiry time");
720         require(manualBlockings[_from][_to].expiryTime == 0, "Blocking already exists");
721         manualBlockings[_from][_to] = ManualBlocking(_expiryTime);
722         emit AddManualBlocking(_from, _to, _expiryTime, msg.sender);
723     }
724 
725     /**
726     * @notice Removes a pairs of addresses from manual approvals
727     * @param _from is the address from which transfers are approved
728     * @param _to is the address to which transfers are approved
729     */
730     function revokeManualApproval(address _from, address _to) public withPerm(TRANSFER_APPROVAL) {
731         require(_from != address(0), "Invalid from address");
732         require(_to != address(0), "Invalid to address");
733         delete manualApprovals[_from][_to];
734         emit RevokeManualApproval(_from, _to, msg.sender);
735     }
736 
737     /**
738     * @notice Removes a pairs of addresses from manual approvals
739     * @param _from is the address from which transfers are approved
740     * @param _to is the address to which transfers are approved
741     */
742     function revokeManualBlocking(address _from, address _to) public withPerm(TRANSFER_APPROVAL) {
743         require(_from != address(0), "Invalid from address");
744         require(_to != address(0), "Invalid to address");
745         delete manualBlockings[_from][_to];
746         emit RevokeManualBlocking(_from, _to, msg.sender);
747     }
748 
749     /**
750      * @notice Returns the permissions flag that are associated with ManualApproval transfer manager
751      */
752     function getPermissions() public view returns(bytes32[]) {
753         bytes32[] memory allPermissions = new bytes32[](1);
754         allPermissions[0] = TRANSFER_APPROVAL;
755         return allPermissions;
756     }
757 }
758 
759 /**
760  * @title Interface that every module factory contract should implement
761  */
762 interface IModuleFactory {
763 
764     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
765     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
766     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
767     event GenerateModuleFromFactory(
768         address _module,
769         bytes32 indexed _moduleName,
770         address indexed _moduleFactory,
771         address _creator,
772         uint256 _setupCost,
773         uint256 _timestamp
774     );
775     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
776 
777     //Should create an instance of the Module, or throw
778     function deploy(bytes _data) external returns(address);
779 
780     /**
781      * @notice Type of the Module factory
782      */
783     function getTypes() external view returns(uint8[]);
784 
785     /**
786      * @notice Get the name of the Module
787      */
788     function getName() external view returns(bytes32);
789 
790     /**
791      * @notice Returns the instructions associated with the module
792      */
793     function getInstructions() external view returns (string);
794 
795     /**
796      * @notice Get the tags related to the module factory
797      */
798     function getTags() external view returns (bytes32[]);
799 
800     /**
801      * @notice Used to change the setup fee
802      * @param _newSetupCost New setup fee
803      */
804     function changeFactorySetupFee(uint256 _newSetupCost) external;
805 
806     /**
807      * @notice Used to change the usage fee
808      * @param _newUsageCost New usage fee
809      */
810     function changeFactoryUsageFee(uint256 _newUsageCost) external;
811 
812     /**
813      * @notice Used to change the subscription fee
814      * @param _newSubscriptionCost New subscription fee
815      */
816     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
817 
818     /**
819      * @notice Function use to change the lower and upper bound of the compatible version st
820      * @param _boundType Type of bound
821      * @param _newVersion New version array
822      */
823     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
824 
825    /**
826      * @notice Get the setup cost of the module
827      */
828     function getSetupCost() external view returns (uint256);
829 
830     /**
831      * @notice Used to get the lower bound
832      * @return Lower bound
833      */
834     function getLowerSTVersionBounds() external view returns(uint8[]);
835 
836      /**
837      * @notice Used to get the upper bound
838      * @return Upper bound
839      */
840     function getUpperSTVersionBounds() external view returns(uint8[]);
841 
842 }
843 
844 /**
845  * @title Helper library use to compare or validate the semantic versions
846  */
847 
848 library VersionUtils {
849 
850     /**
851      * @notice This function is used to validate the version submitted
852      * @param _current Array holds the present version of ST
853      * @param _new Array holds the latest version of the ST
854      * @return bool
855      */
856     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
857         bool[] memory _temp = new bool[](_current.length);
858         uint8 counter = 0;
859         for (uint8 i = 0; i < _current.length; i++) {
860             if (_current[i] < _new[i])
861                 _temp[i] = true;
862             else
863                 _temp[i] = false;
864         }
865 
866         for (i = 0; i < _current.length; i++) {
867             if (i == 0) {
868                 if (_current[i] <= _new[i])
869                     if(_temp[0]) {
870                         counter = counter + 3;
871                         break;
872                     } else
873                         counter++;
874                 else
875                     return false;
876             } else {
877                 if (_temp[i-1])
878                     counter++;
879                 else if (_current[i] <= _new[i])
880                     counter++;
881                 else
882                     return false;
883             }
884         }
885         if (counter == _current.length)
886             return true;
887     }
888 
889     /**
890      * @notice Used to compare the lower bound with the latest version
891      * @param _version1 Array holds the lower bound of the version
892      * @param _version2 Array holds the latest version of the ST
893      * @return bool
894      */
895     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
896         require(_version1.length == _version2.length, "Input length mismatch");
897         uint counter = 0;
898         for (uint8 j = 0; j < _version1.length; j++) {
899             if (_version1[j] == 0)
900                 counter ++;
901         }
902         if (counter != _version1.length) {
903             counter = 0;
904             for (uint8 i = 0; i < _version1.length; i++) {
905                 if (_version2[i] > _version1[i])
906                     return true;
907                 else if (_version2[i] < _version1[i])
908                     return false;
909                 else
910                     counter++;
911             }
912             if (counter == _version1.length - 1)
913                 return true;
914             else
915                 return false;
916         } else
917             return true;
918     }
919 
920     /**
921      * @notice Used to compare the upper bound with the latest version
922      * @param _version1 Array holds the upper bound of the version
923      * @param _version2 Array holds the latest version of the ST
924      * @return bool
925      */
926     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
927         require(_version1.length == _version2.length, "Input length mismatch");
928         uint counter = 0;
929         for (uint8 j = 0; j < _version1.length; j++) {
930             if (_version1[j] == 0)
931                 counter ++;
932         }
933         if (counter != _version1.length) {
934             counter = 0;
935             for (uint8 i = 0; i < _version1.length; i++) {
936                 if (_version1[i] > _version2[i])
937                     return true;
938                 else if (_version1[i] < _version2[i])
939                     return false;
940                 else
941                     counter++;
942             }
943             if (counter == _version1.length - 1)
944                 return true;
945             else
946                 return false;
947         } else
948             return true;
949     }
950 
951 
952     /**
953      * @notice Used to pack the uint8[] array data into uint24 value
954      * @param _major Major version
955      * @param _minor Minor version
956      * @param _patch Patch version
957      */
958     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
959         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
960     }
961 
962     /**
963      * @notice Used to convert packed data into uint8 array
964      * @param _packedVersion Packed data
965      */
966     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
967         uint8[] memory _unpackVersion = new uint8[](3);
968         _unpackVersion[0] = uint8(_packedVersion >> 16);
969         _unpackVersion[1] = uint8(_packedVersion >> 8);
970         _unpackVersion[2] = uint8(_packedVersion);
971         return _unpackVersion;
972     }
973 
974 
975 }
976 
977 /**
978  * @title Interface that any module factory contract should implement
979  * @notice Contract is abstract
980  */
981 contract ModuleFactory is IModuleFactory, Ownable {
982 
983     IERC20 public polyToken;
984     uint256 public usageCost;
985     uint256 public monthlySubscriptionCost;
986 
987     uint256 public setupCost;
988     string public description;
989     string public version;
990     bytes32 public name;
991     string public title;
992 
993     // @notice Allow only two variables to be stored
994     // 1. lowerBound 
995     // 2. upperBound
996     // @dev (0.0.0 will act as the wildcard) 
997     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
998     mapping(string => uint24) compatibleSTVersionRange;
999 
1000     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
1001     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
1002     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
1003     event GenerateModuleFromFactory(
1004         address _module,
1005         bytes32 indexed _moduleName,
1006         address indexed _moduleFactory,
1007         address _creator,
1008         uint256 _timestamp
1009     );
1010     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1011 
1012     /**
1013      * @notice Constructor
1014      * @param _polyAddress Address of the polytoken
1015      */
1016     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
1017         polyToken = IERC20(_polyAddress);
1018         setupCost = _setupCost;
1019         usageCost = _usageCost;
1020         monthlySubscriptionCost = _subscriptionCost;
1021     }
1022 
1023     /**
1024      * @notice Used to change the fee of the setup cost
1025      * @param _newSetupCost new setup cost
1026      */
1027     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
1028         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
1029         setupCost = _newSetupCost;
1030     }
1031 
1032     /**
1033      * @notice Used to change the fee of the usage cost
1034      * @param _newUsageCost new usage cost
1035      */
1036     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
1037         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
1038         usageCost = _newUsageCost;
1039     }
1040 
1041     /**
1042      * @notice Used to change the fee of the subscription cost
1043      * @param _newSubscriptionCost new subscription cost
1044      */
1045     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
1046         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
1047         monthlySubscriptionCost = _newSubscriptionCost;
1048 
1049     }
1050 
1051     /**
1052      * @notice Updates the title of the ModuleFactory
1053      * @param _newTitle New Title that will replace the old one.
1054      */
1055     function changeTitle(string _newTitle) public onlyOwner {
1056         require(bytes(_newTitle).length > 0, "Invalid title");
1057         title = _newTitle;
1058     }
1059 
1060     /**
1061      * @notice Updates the description of the ModuleFactory
1062      * @param _newDesc New description that will replace the old one.
1063      */
1064     function changeDescription(string _newDesc) public onlyOwner {
1065         require(bytes(_newDesc).length > 0, "Invalid description");
1066         description = _newDesc;
1067     }
1068 
1069     /**
1070      * @notice Updates the name of the ModuleFactory
1071      * @param _newName New name that will replace the old one.
1072      */
1073     function changeName(bytes32 _newName) public onlyOwner {
1074         require(_newName != bytes32(0),"Invalid name");
1075         name = _newName;
1076     }
1077 
1078     /**
1079      * @notice Updates the version of the ModuleFactory
1080      * @param _newVersion New name that will replace the old one.
1081      */
1082     function changeVersion(string _newVersion) public onlyOwner {
1083         require(bytes(_newVersion).length > 0, "Invalid version");
1084         version = _newVersion;
1085     }
1086 
1087     /**
1088      * @notice Function use to change the lower and upper bound of the compatible version st
1089      * @param _boundType Type of bound
1090      * @param _newVersion new version array
1091      */
1092     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
1093         require(
1094             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
1095             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
1096             "Must be a valid bound type"
1097         );
1098         require(_newVersion.length == 3);
1099         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
1100             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
1101             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
1102         }
1103         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
1104         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
1105     }
1106 
1107     /**
1108      * @notice Used to get the lower bound
1109      * @return lower bound
1110      */
1111     function getLowerSTVersionBounds() external view returns(uint8[]) {
1112         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
1113     }
1114 
1115     /**
1116      * @notice Used to get the upper bound
1117      * @return upper bound
1118      */
1119     function getUpperSTVersionBounds() external view returns(uint8[]) {
1120         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
1121     }
1122 
1123     /**
1124      * @notice Get the setup cost of the module
1125      */
1126     function getSetupCost() external view returns (uint256) {
1127         return setupCost;
1128     }
1129 
1130    /**
1131     * @notice Get the name of the Module
1132     */
1133     function getName() public view returns(bytes32) {
1134         return name;
1135     }
1136 
1137 }
1138 
1139 /**
1140  * @title Factory for deploying ManualApprovalTransferManager module
1141  */
1142 contract ManualApprovalTransferManagerFactory is ModuleFactory {
1143 
1144     /**
1145      * @notice Constructor
1146      * @param _polyAddress Address of the polytoken
1147      * @param _setupCost Setup cost of the module
1148      * @param _usageCost Usage cost of the module
1149      * @param _subscriptionCost Subscription cost of the module
1150      */
1151     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1152     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1153     {
1154         version = "1.0.0";
1155         name = "ManualApprovalTransferManager";
1156         title = "Manual Approval Transfer Manager";
1157         description = "Manage transfers using single approvals / blocking";
1158         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1159         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1160     }
1161 
1162      /**
1163      * @notice used to launch the Module with the help of factory
1164      * @return address Contract address of the Module
1165      */
1166     function deploy(bytes /* _data */) external returns(address) {
1167         if (setupCost > 0)
1168             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
1169         address manualTransferManager = new ManualApprovalTransferManager(msg.sender, address(polyToken));
1170         /*solium-disable-next-line security/no-block-members*/
1171         emit GenerateModuleFromFactory(address(manualTransferManager), getName(), address(this), msg.sender, setupCost, now);
1172         return address(manualTransferManager);
1173     }
1174 
1175     /**
1176      * @notice Type of the Module factory
1177      */
1178     function getTypes() external view returns(uint8[]) {
1179         uint8[] memory res = new uint8[](1);
1180         res[0] = 2;
1181         return res;
1182     }
1183 
1184     /**
1185      * @notice Returns the instructions associated with the module
1186      */
1187     function getInstructions() external view returns(string) {
1188         /*solium-disable-next-line max-len*/
1189         return "Allows an issuer to set manual approvals or blocks for specific pairs of addresses and amounts. Init function takes no parameters.";
1190     }
1191 
1192     /**
1193      * @notice Get the tags related to the module factory
1194      */
1195     function getTags() external view returns(bytes32[]) {
1196         bytes32[] memory availableTags = new bytes32[](2);
1197         availableTags[0] = "ManualApproval";
1198         availableTags[1] = "Transfer Restriction";
1199         return availableTags;
1200     }
1201 
1202 
1203 }