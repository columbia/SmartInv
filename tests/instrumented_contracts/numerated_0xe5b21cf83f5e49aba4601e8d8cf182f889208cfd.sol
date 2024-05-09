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
536  * @title Interface to be implemented by all Transfer Manager modules
537  * @dev abstract contract
538  */
539 contract ITransferManager is Module, Pausable {
540 
541     //If verifyTransfer returns:
542     //  FORCE_VALID, the transaction will always be valid, regardless of other TM results
543     //  INVALID, then the transfer should not be allowed regardless of other TM results
544     //  VALID, then the transfer is valid for this TM
545     //  NA, then the result from this TM is ignored
546     enum Result {INVALID, NA, VALID, FORCE_VALID}
547 
548     function verifyTransfer(address _from, address _to, uint256 _amount, bytes _data, bool _isTransfer) public returns(Result);
549 
550     function unpause() public onlyOwner {
551         super._unpause();
552     }
553 
554     function pause() public onlyOwner {
555         super._pause();
556     }
557 }
558 
559 /**
560  * @title SafeMath
561  * @dev Math operations with safety checks that throw on error
562  */
563 library SafeMath {
564 
565   /**
566   * @dev Multiplies two numbers, throws on overflow.
567   */
568   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
569     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
570     // benefit is lost if 'b' is also tested.
571     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
572     if (a == 0) {
573       return 0;
574     }
575 
576     c = a * b;
577     assert(c / a == b);
578     return c;
579   }
580 
581   /**
582   * @dev Integer division of two numbers, truncating the quotient.
583   */
584   function div(uint256 a, uint256 b) internal pure returns (uint256) {
585     // assert(b > 0); // Solidity automatically throws when dividing by 0
586     // uint256 c = a / b;
587     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
588     return a / b;
589   }
590 
591   /**
592   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
593   */
594   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
595     assert(b <= a);
596     return a - b;
597   }
598 
599   /**
600   * @dev Adds two numbers, throws on overflow.
601   */
602   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
603     c = a + b;
604     assert(c >= a);
605     return c;
606   }
607 }
608 
609 /**
610  * @title Transfer Manager module for manually approving transactions between accounts
611  */
612 contract ManualApprovalTransferManager is ITransferManager {
613     using SafeMath for uint256;
614 
615     bytes32 public constant TRANSFER_APPROVAL = "TRANSFER_APPROVAL";
616 
617     //Manual approval is an allowance (that has been approved) with an expiry time
618     struct ManualApproval {
619         address from;
620         address to;
621         uint256 allowance;
622         uint256 expiryTime;
623         bytes32 description;
624     }
625 
626     mapping (address => mapping (address => uint256)) public approvalIndex;
627 
628     // An array to track all approvals. It is an unbounded array but it's not a problem as
629     // it is never looped through in an onchain call. It is defined as an Array instead of mapping
630     // just to make it easier for users to fetch list of all approvals through constant functions.
631     ManualApproval[] public approvals;
632 
633     event AddManualApproval(
634         address indexed _from,
635         address indexed _to,
636         uint256 _allowance,
637         uint256 _expiryTime,
638         bytes32 _description,
639         address indexed _addedBy
640     );
641 
642     event ModifyManualApproval(
643         address indexed _from,
644         address indexed _to,
645         uint256 _expiryTime,
646         uint256 _allowance,
647         bytes32 _description,
648         address indexed _edittedBy
649     );
650 
651     event RevokeManualApproval(
652         address indexed _from,
653         address indexed _to,
654         address indexed _addedBy
655     );
656 
657     /**
658      * @notice Constructor
659      * @param _securityToken Address of the security token
660      * @param _polyAddress Address of the polytoken
661      */
662     constructor (address _securityToken, address _polyAddress)
663     public
664     Module(_securityToken, _polyAddress)
665     {
666     }
667 
668     /**
669      * @notice This function returns the signature of configure function
670      */
671     function getInitFunction() public pure returns (bytes4) {
672         return bytes4(0);
673     }
674 
675     /**
676      * @notice Used to verify the transfer transaction and allow a manually approved transqaction to bypass other restrictions
677      * @param _from Address of the sender
678      * @param _to Address of the receiver
679      * @param _amount The amount of tokens to transfer
680      * @param _isTransfer Whether or not this is an actual transfer or just a test to see if the tokens would be transferrable
681      */
682     function verifyTransfer(address _from, address _to, uint256 _amount, bytes /* _data */, bool _isTransfer) public returns(Result) {
683         // function must only be called by the associated security token if _isTransfer == true
684         require(_isTransfer == false || msg.sender == securityToken, "Sender is not the owner");
685         uint256 index = approvalIndex[_from][_to];
686         if (!paused && index != 0) {
687             index--; //Actual index is stored index - 1.
688             ManualApproval storage approval = approvals[index];
689             uint256 allowance = approval.allowance;
690             if ((approval.expiryTime >= now) && (allowance >= _amount)) {
691                 if (_isTransfer) {
692                     approval.allowance = allowance - _amount;
693                 }
694                 return Result.VALID;
695             }
696         }
697         return Result.NA;
698     }
699 
700     /**
701     * @notice Adds a pair of addresses to manual approvals
702     * @param _from is the address from which transfers are approved
703     * @param _to is the address to which transfers are approved
704     * @param _allowance is the approved amount of tokens
705     * @param _expiryTime is the time until which the transfer is allowed
706     * @param _description Description about the manual approval
707     */
708     function addManualApproval(
709         address _from,
710         address _to,
711         uint256 _allowance,
712         uint256 _expiryTime,
713         bytes32 _description
714     )
715         external
716         withPerm(TRANSFER_APPROVAL)
717     {
718         _addManualApproval(_from, _to, _allowance, _expiryTime, _description);
719     }
720 
721     function _addManualApproval(address _from, address _to, uint256 _allowance, uint256 _expiryTime, bytes32 _description) internal {
722         require(_to != address(0), "Invalid to address");
723         require(_expiryTime > now, "Invalid expiry time");
724         require(_allowance > 0, "Invalid allowance");
725         uint256 index = approvalIndex[_from][_to];
726         if (index != 0) {
727             index--; //Actual index is stored index - 1.
728             require(approvals[index].expiryTime < now || approvals[index].allowance == 0, "Approval already exists");
729             _revokeManualApproval(_from, _to);
730         }
731         approvals.push(ManualApproval(_from, _to, _allowance, _expiryTime, _description));
732         approvalIndex[_from][_to] = approvals.length;
733         emit AddManualApproval(_from, _to, _allowance, _expiryTime, _description, msg.sender);
734     }
735 
736     /**
737     * @notice Adds mutiple manual approvals in batch
738     * @param _from is the address array from which transfers are approved
739     * @param _to is the address array to which transfers are approved
740     * @param _allowances is the array of approved amounts
741     * @param _expiryTimes is the array of the times until which eath transfer is allowed
742     * @param _descriptions is the description array for these manual approvals
743     */
744     function addManualApprovalMulti(
745         address[] _from,
746         address[] _to,
747         uint256[] _allowances,
748         uint256[] _expiryTimes,
749         bytes32[] _descriptions
750     )
751         external
752         withPerm(TRANSFER_APPROVAL)
753     {
754         _checkInputLengthArray(_from, _to, _allowances, _expiryTimes, _descriptions);
755         for (uint256 i = 0; i < _from.length; i++){
756             _addManualApproval(_from[i], _to[i], _allowances[i], _expiryTimes[i], _descriptions[i]);
757         }
758     }
759 
760     /**
761     * @notice Modify the existing manual approvals
762     * @param _from is the address from which transfers are approved
763     * @param _to is the address to which transfers are approved
764     * @param _expiryTime is the time until which the transfer is allowed
765     * @param _changeInAllowance is the change in allowance
766     * @param _description Description about the manual approval
767     * @param _increase tells whether the allowances will be increased (true) or decreased (false).
768     * or any value when there is no change in allowances
769     */
770     function modifyManualApproval(
771         address _from,
772         address _to,
773         uint256 _expiryTime,
774         uint256 _changeInAllowance,
775         bytes32 _description,
776         bool _increase
777     )
778         external
779         withPerm(TRANSFER_APPROVAL)
780     {
781         _modifyManualApproval(_from, _to, _expiryTime, _changeInAllowance, _description, _increase);
782     }
783 
784     function _modifyManualApproval(
785         address _from,
786         address _to,
787         uint256 _expiryTime,
788         uint256 _changeInAllowance,
789         bytes32 _description,
790         bool _increase
791     )
792         internal
793     {
794         require(_to != address(0), "Invalid to address");
795         /*solium-disable-next-line security/no-block-members*/
796         require(_expiryTime > now, "Invalid expiry time");
797         uint256 index = approvalIndex[_from][_to];
798         require(index != 0, "Approval not present");
799         index--; //Index is stored in an incremented form. 0 represnts non existant.
800         ManualApproval storage approval = approvals[index];
801         uint256 allowance = approval.allowance;
802         uint256 expiryTime = approval.expiryTime;
803         require(allowance != 0 && expiryTime > now, "Not allowed");
804 
805         if (_changeInAllowance > 0) {
806             if (_increase) {
807                 // Allowance get increased
808                 allowance = allowance.add(_changeInAllowance);
809             } else {
810                 // Allowance get decreased
811                 if (_changeInAllowance >= allowance) {
812                     allowance = 0;
813                 } else {
814                     allowance = allowance - _changeInAllowance;
815                 }
816             }
817             approval.allowance = allowance;
818         }
819 
820         // Greedy storage technique
821         if (expiryTime != _expiryTime) {
822             approval.expiryTime = _expiryTime;
823         }
824         if (approval.description != _description) {
825             approval.description = _description;
826         }
827 
828         emit ModifyManualApproval(_from, _to, _expiryTime, allowance, _description, msg.sender);
829     }
830 
831     /**
832      * @notice Adds mutiple manual approvals in batch
833      * @param _from is the address array from which transfers are approved
834      * @param _to is the address array to which transfers are approved
835      * @param _expiryTimes is the array of the times until which eath transfer is allowed
836      * @param _changedAllowances is the array of approved amounts
837      * @param _descriptions is the description array for these manual approvals
838      * @param _increase Array of bool values which tells whether the allowances will be increased (true) or decreased (false)
839      * or any value when there is no change in allowances
840      */
841     function modifyManualApprovalMulti(
842         address[] _from,
843         address[] _to,
844         uint256[] _expiryTimes,
845         uint256[] _changedAllowances,
846         bytes32[] _descriptions,
847         bool[] _increase
848     )
849         public
850         withPerm(TRANSFER_APPROVAL)
851     {
852         _checkInputLengthArray(_from, _to, _changedAllowances, _expiryTimes, _descriptions);
853         require(_increase.length == _changedAllowances.length, "Input length array mismatch");
854         for (uint256 i = 0; i < _from.length; i++) {
855             _modifyManualApproval(_from[i], _to[i], _expiryTimes[i], _changedAllowances[i], _descriptions[i], _increase[i]);
856         }
857     }
858 
859     /**
860     * @notice Removes a pairs of addresses from manual approvals
861     * @param _from is the address from which transfers are approved
862     * @param _to is the address to which transfers are approved
863     */
864     function revokeManualApproval(address _from, address _to) external withPerm(TRANSFER_APPROVAL) {
865         _revokeManualApproval(_from, _to);
866     }
867 
868     function _revokeManualApproval(address _from, address _to) internal {
869         uint256 index = approvalIndex[_from][_to];
870         require(index != 0, "Approval does not exist");
871         index--; //Actual index is stored index - 1.
872         uint256 lastApprovalIndex = approvals.length - 1;
873         // find the record in active approvals array & delete it
874         if (index != lastApprovalIndex) {
875             approvals[index] = approvals[lastApprovalIndex];
876             approvalIndex[approvals[index].from][approvals[index].to] = index + 1;
877         }
878         delete approvalIndex[_from][_to];
879         approvals.length--;
880         emit RevokeManualApproval(_from, _to, msg.sender);
881     }
882 
883     /**
884     * @notice Removes mutiple pairs of addresses from manual approvals
885     * @param _from is the address array from which transfers are approved
886     * @param _to is the address array to which transfers are approved
887     */
888     function revokeManualApprovalMulti(address[] _from, address[] _to) external withPerm(TRANSFER_APPROVAL) {
889         require(_from.length == _to.length, "Input array length mismatch");
890         for(uint256 i = 0; i < _from.length; i++){
891             _revokeManualApproval(_from[i], _to[i]);
892         }
893     }
894 
895     function _checkInputLengthArray(
896         address[] _from,
897         address[] _to,
898         uint256[] _expiryTimes,
899         uint256[] _allowances,
900         bytes32[] _descriptions
901     )
902         internal
903         pure
904     {
905         require(_from.length == _to.length &&
906         _to.length == _allowances.length &&
907         _allowances.length == _expiryTimes.length &&
908         _expiryTimes.length == _descriptions.length,
909         "Input array length mismatch"
910         );
911     }
912 
913     /**
914      * @notice Returns the all active approvals corresponds to an address
915      * @param _user Address of the holder corresponds to whom list of manual approvals
916      * need to return
917      * @return address[] addresses from
918      * @return address[] addresses to
919      * @return uint256[] allowances provided to the approvals
920      * @return uint256[] expiry times provided to the approvals
921      * @return bytes32[] descriptions provided to the approvals
922      */
923     function getActiveApprovalsToUser(address _user) external view returns(address[], address[], uint256[], uint256[], bytes32[]) {
924         uint256 counter = 0;
925         uint256 approvalsLength = approvals.length;
926         for (uint256 i = 0; i < approvalsLength; i++) {
927             if ((approvals[i].from == _user || approvals[i].to == _user)
928                 && approvals[i].expiryTime >= now)
929                 counter ++;
930         }
931 
932         address[] memory from = new address[](counter);
933         address[] memory to = new address[](counter);
934         uint256[] memory allowance = new uint256[](counter);
935         uint256[] memory expiryTime = new uint256[](counter);
936         bytes32[] memory description = new bytes32[](counter);
937 
938         counter = 0;
939         for (i = 0; i < approvalsLength; i++) {
940             if ((approvals[i].from == _user || approvals[i].to == _user)
941                 && approvals[i].expiryTime >= now) {
942 
943                 from[counter]=approvals[i].from;
944                 to[counter]=approvals[i].to;
945                 allowance[counter]=approvals[i].allowance;
946                 expiryTime[counter]=approvals[i].expiryTime;
947                 description[counter]=approvals[i].description;
948                 counter ++;
949             }
950         }
951         return (from, to, allowance, expiryTime, description);
952     }
953 
954     /**
955      * @notice Get the details of the approval corresponds to _from & _to addresses
956      * @param _from Address of the sender
957      * @param _to Address of the receiver
958      * @return uint256 expiryTime of the approval
959      * @return uint256 allowance provided to the approval
960      * @return uint256 Description provided to the approval
961      */
962     function getApprovalDetails(address _from, address _to) external view returns(uint256, uint256, bytes32) {
963         uint256 index = approvalIndex[_from][_to];
964         if (index != 0) {
965             index--;
966             if (index < approvals.length) {
967                 ManualApproval storage approval = approvals[index];
968                 return(
969                     approval.expiryTime,
970                     approval.allowance,
971                     approval.description
972                 );
973             }
974         }
975     }
976 
977     /**
978     * @notice Returns the current number of active approvals
979     */
980     function getTotalApprovalsLength() external view returns(uint256) {
981         return approvals.length;
982     }
983 
984     /**
985      * @notice Get the details of all approvals
986      * @return address[] addresses from
987      * @return address[] addresses to
988      * @return uint256[] allowances provided to the approvals
989      * @return uint256[] expiry times provided to the approvals
990      * @return bytes32[] descriptions provided to the approvals
991      */
992     function getAllApprovals() external view returns(address[], address[], uint256[], uint256[], bytes32[]) {
993         address[] memory from = new address[](approvals.length);
994         address[] memory to = new address[](approvals.length);
995         uint256[] memory allowance = new uint256[](approvals.length);
996         uint256[] memory expiryTime = new uint256[](approvals.length);
997         bytes32[] memory description = new bytes32[](approvals.length);
998         uint256 approvalsLength = approvals.length;
999 
1000         for (uint256 i = 0; i < approvalsLength; i++) {
1001 
1002             from[i]=approvals[i].from;
1003             to[i]=approvals[i].to;
1004             allowance[i]=approvals[i].allowance;
1005             expiryTime[i]=approvals[i].expiryTime;
1006             description[i]=approvals[i].description;
1007 
1008         }
1009 
1010         return (from, to, allowance, expiryTime, description);
1011 
1012     }
1013 
1014     /**
1015      * @notice Returns the permissions flag that are associated with ManualApproval transfer manager
1016      */
1017     function getPermissions() public view returns(bytes32[]) {
1018         bytes32[] memory allPermissions = new bytes32[](1);
1019         allPermissions[0] = TRANSFER_APPROVAL;
1020         return allPermissions;
1021     }
1022 }
1023 
1024 /**
1025  * @title Interface that every module factory contract should implement
1026  */
1027 interface IModuleFactory {
1028 
1029     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
1030     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
1031     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
1032     event GenerateModuleFromFactory(
1033         address _module,
1034         bytes32 indexed _moduleName,
1035         address indexed _moduleFactory,
1036         address _creator,
1037         uint256 _setupCost,
1038         uint256 _timestamp
1039     );
1040     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1041 
1042     //Should create an instance of the Module, or throw
1043     function deploy(bytes _data) external returns(address);
1044 
1045     /**
1046      * @notice Type of the Module factory
1047      */
1048     function getTypes() external view returns(uint8[]);
1049 
1050     /**
1051      * @notice Get the name of the Module
1052      */
1053     function getName() external view returns(bytes32);
1054 
1055     /**
1056      * @notice Returns the instructions associated with the module
1057      */
1058     function getInstructions() external view returns (string);
1059 
1060     /**
1061      * @notice Get the tags related to the module factory
1062      */
1063     function getTags() external view returns (bytes32[]);
1064 
1065     /**
1066      * @notice Used to change the setup fee
1067      * @param _newSetupCost New setup fee
1068      */
1069     function changeFactorySetupFee(uint256 _newSetupCost) external;
1070 
1071     /**
1072      * @notice Used to change the usage fee
1073      * @param _newUsageCost New usage fee
1074      */
1075     function changeFactoryUsageFee(uint256 _newUsageCost) external;
1076 
1077     /**
1078      * @notice Used to change the subscription fee
1079      * @param _newSubscriptionCost New subscription fee
1080      */
1081     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
1082 
1083     /**
1084      * @notice Function use to change the lower and upper bound of the compatible version st
1085      * @param _boundType Type of bound
1086      * @param _newVersion New version array
1087      */
1088     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
1089 
1090    /**
1091      * @notice Get the setup cost of the module
1092      */
1093     function getSetupCost() external view returns (uint256);
1094 
1095     /**
1096      * @notice Used to get the lower bound
1097      * @return Lower bound
1098      */
1099     function getLowerSTVersionBounds() external view returns(uint8[]);
1100 
1101      /**
1102      * @notice Used to get the upper bound
1103      * @return Upper bound
1104      */
1105     function getUpperSTVersionBounds() external view returns(uint8[]);
1106 
1107 }
1108 
1109 /**
1110  * @title Helper library use to compare or validate the semantic versions
1111  */
1112 
1113 library VersionUtils {
1114 
1115     /**
1116      * @notice This function is used to validate the version submitted
1117      * @param _current Array holds the present version of ST
1118      * @param _new Array holds the latest version of the ST
1119      * @return bool
1120      */
1121     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
1122         bool[] memory _temp = new bool[](_current.length);
1123         uint8 counter = 0;
1124         for (uint8 i = 0; i < _current.length; i++) {
1125             if (_current[i] < _new[i])
1126                 _temp[i] = true;
1127             else
1128                 _temp[i] = false;
1129         }
1130 
1131         for (i = 0; i < _current.length; i++) {
1132             if (i == 0) {
1133                 if (_current[i] <= _new[i])
1134                     if(_temp[0]) {
1135                         counter = counter + 3;
1136                         break;
1137                     } else
1138                         counter++;
1139                 else
1140                     return false;
1141             } else {
1142                 if (_temp[i-1])
1143                     counter++;
1144                 else if (_current[i] <= _new[i])
1145                     counter++;
1146                 else
1147                     return false;
1148             }
1149         }
1150         if (counter == _current.length)
1151             return true;
1152     }
1153 
1154     /**
1155      * @notice Used to compare the lower bound with the latest version
1156      * @param _version1 Array holds the lower bound of the version
1157      * @param _version2 Array holds the latest version of the ST
1158      * @return bool
1159      */
1160     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1161         require(_version1.length == _version2.length, "Input length mismatch");
1162         uint counter = 0;
1163         for (uint8 j = 0; j < _version1.length; j++) {
1164             if (_version1[j] == 0)
1165                 counter ++;
1166         }
1167         if (counter != _version1.length) {
1168             counter = 0;
1169             for (uint8 i = 0; i < _version1.length; i++) {
1170                 if (_version2[i] > _version1[i])
1171                     return true;
1172                 else if (_version2[i] < _version1[i])
1173                     return false;
1174                 else
1175                     counter++;
1176             }
1177             if (counter == _version1.length - 1)
1178                 return true;
1179             else
1180                 return false;
1181         } else
1182             return true;
1183     }
1184 
1185     /**
1186      * @notice Used to compare the upper bound with the latest version
1187      * @param _version1 Array holds the upper bound of the version
1188      * @param _version2 Array holds the latest version of the ST
1189      * @return bool
1190      */
1191     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
1192         require(_version1.length == _version2.length, "Input length mismatch");
1193         uint counter = 0;
1194         for (uint8 j = 0; j < _version1.length; j++) {
1195             if (_version1[j] == 0)
1196                 counter ++;
1197         }
1198         if (counter != _version1.length) {
1199             counter = 0;
1200             for (uint8 i = 0; i < _version1.length; i++) {
1201                 if (_version1[i] > _version2[i])
1202                     return true;
1203                 else if (_version1[i] < _version2[i])
1204                     return false;
1205                 else
1206                     counter++;
1207             }
1208             if (counter == _version1.length - 1)
1209                 return true;
1210             else
1211                 return false;
1212         } else
1213             return true;
1214     }
1215 
1216 
1217     /**
1218      * @notice Used to pack the uint8[] array data into uint24 value
1219      * @param _major Major version
1220      * @param _minor Minor version
1221      * @param _patch Patch version
1222      */
1223     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
1224         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
1225     }
1226 
1227     /**
1228      * @notice Used to convert packed data into uint8 array
1229      * @param _packedVersion Packed data
1230      */
1231     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
1232         uint8[] memory _unpackVersion = new uint8[](3);
1233         _unpackVersion[0] = uint8(_packedVersion >> 16);
1234         _unpackVersion[1] = uint8(_packedVersion >> 8);
1235         _unpackVersion[2] = uint8(_packedVersion);
1236         return _unpackVersion;
1237     }
1238 
1239 
1240 }
1241 
1242 /**
1243  * @title Interface that any module factory contract should implement
1244  * @notice Contract is abstract
1245  */
1246 contract ModuleFactory is IModuleFactory, Ownable {
1247 
1248     IERC20 public polyToken;
1249     uint256 public usageCost;
1250     uint256 public monthlySubscriptionCost;
1251 
1252     uint256 public setupCost;
1253     string public description;
1254     string public version;
1255     bytes32 public name;
1256     string public title;
1257 
1258     // @notice Allow only two variables to be stored
1259     // 1. lowerBound 
1260     // 2. upperBound
1261     // @dev (0.0.0 will act as the wildcard) 
1262     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
1263     mapping(string => uint24) compatibleSTVersionRange;
1264 
1265     /**
1266      * @notice Constructor
1267      * @param _polyAddress Address of the polytoken
1268      */
1269     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
1270         polyToken = IERC20(_polyAddress);
1271         setupCost = _setupCost;
1272         usageCost = _usageCost;
1273         monthlySubscriptionCost = _subscriptionCost;
1274     }
1275 
1276     /**
1277      * @notice Used to change the fee of the setup cost
1278      * @param _newSetupCost new setup cost
1279      */
1280     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
1281         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
1282         setupCost = _newSetupCost;
1283     }
1284 
1285     /**
1286      * @notice Used to change the fee of the usage cost
1287      * @param _newUsageCost new usage cost
1288      */
1289     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
1290         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
1291         usageCost = _newUsageCost;
1292     }
1293 
1294     /**
1295      * @notice Used to change the fee of the subscription cost
1296      * @param _newSubscriptionCost new subscription cost
1297      */
1298     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
1299         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
1300         monthlySubscriptionCost = _newSubscriptionCost;
1301 
1302     }
1303 
1304     /**
1305      * @notice Updates the title of the ModuleFactory
1306      * @param _newTitle New Title that will replace the old one.
1307      */
1308     function changeTitle(string _newTitle) public onlyOwner {
1309         require(bytes(_newTitle).length > 0, "Invalid title");
1310         title = _newTitle;
1311     }
1312 
1313     /**
1314      * @notice Updates the description of the ModuleFactory
1315      * @param _newDesc New description that will replace the old one.
1316      */
1317     function changeDescription(string _newDesc) public onlyOwner {
1318         require(bytes(_newDesc).length > 0, "Invalid description");
1319         description = _newDesc;
1320     }
1321 
1322     /**
1323      * @notice Updates the name of the ModuleFactory
1324      * @param _newName New name that will replace the old one.
1325      */
1326     function changeName(bytes32 _newName) public onlyOwner {
1327         require(_newName != bytes32(0),"Invalid name");
1328         name = _newName;
1329     }
1330 
1331     /**
1332      * @notice Updates the version of the ModuleFactory
1333      * @param _newVersion New name that will replace the old one.
1334      */
1335     function changeVersion(string _newVersion) public onlyOwner {
1336         require(bytes(_newVersion).length > 0, "Invalid version");
1337         version = _newVersion;
1338     }
1339 
1340     /**
1341      * @notice Function use to change the lower and upper bound of the compatible version st
1342      * @param _boundType Type of bound
1343      * @param _newVersion new version array
1344      */
1345     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
1346         require(
1347             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
1348             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
1349             "Must be a valid bound type"
1350         );
1351         require(_newVersion.length == 3);
1352         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
1353             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
1354             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
1355         }
1356         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
1357         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
1358     }
1359 
1360     /**
1361      * @notice Used to get the lower bound
1362      * @return lower bound
1363      */
1364     function getLowerSTVersionBounds() external view returns(uint8[]) {
1365         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
1366     }
1367 
1368     /**
1369      * @notice Used to get the upper bound
1370      * @return upper bound
1371      */
1372     function getUpperSTVersionBounds() external view returns(uint8[]) {
1373         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
1374     }
1375 
1376     /**
1377      * @notice Get the setup cost of the module
1378      */
1379     function getSetupCost() external view returns (uint256) {
1380         return setupCost;
1381     }
1382 
1383    /**
1384     * @notice Get the name of the Module
1385     */
1386     function getName() public view returns(bytes32) {
1387         return name;
1388     }
1389 
1390 }
1391 
1392 /**
1393  * @title Factory for deploying ManualApprovalTransferManager module
1394  */
1395 contract ManualApprovalTransferManagerFactory is ModuleFactory {
1396 
1397     /**
1398      * @notice Constructor
1399      * @param _polyAddress Address of the polytoken
1400      * @param _setupCost Setup cost of the module
1401      * @param _usageCost Usage cost of the module
1402      * @param _subscriptionCost Subscription cost of the module
1403      */
1404     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1405     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1406     {
1407         version = "2.1.0";
1408         name = "ManualApprovalTransferManager";
1409         title = "Manual Approval Transfer Manager";
1410         description = "Manage transfers using single approvals";
1411         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1412         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1413     }
1414 
1415      /**
1416      * @notice used to launch the Module with the help of factory
1417      * @return address Contract address of the Module
1418      */
1419     function deploy(bytes /* _data */) external returns(address) {
1420         if (setupCost > 0)
1421             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
1422         address manualTransferManager = new ManualApprovalTransferManager(msg.sender, address(polyToken));
1423         /*solium-disable-next-line security/no-block-members*/
1424         emit GenerateModuleFromFactory(address(manualTransferManager), getName(), address(this), msg.sender, setupCost, now);
1425         return address(manualTransferManager);
1426     }
1427 
1428     /**
1429      * @notice Type of the Module factory
1430      */
1431     function getTypes() external view returns(uint8[]) {
1432         uint8[] memory res = new uint8[](1);
1433         res[0] = 2;
1434         return res;
1435     }
1436 
1437     /**
1438      * @notice Returns the instructions associated with the module
1439      */
1440     function getInstructions() external view returns(string) {
1441         /*solium-disable-next-line max-len*/
1442         return "Allows an issuer to set manual approvals for specific pairs of addresses and amounts. Init function takes no parameters.";
1443     }
1444 
1445     /**
1446      * @notice Get the tags related to the module factory
1447      */
1448     function getTags() external view returns(bytes32[]) {
1449         bytes32[] memory availableTags = new bytes32[](2);
1450         availableTags[0] = "ManualApproval";
1451         availableTags[1] = "Transfer Restriction";
1452         return availableTags;
1453     }
1454 
1455 
1456 }