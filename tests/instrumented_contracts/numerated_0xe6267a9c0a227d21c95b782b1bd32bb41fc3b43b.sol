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
591  * DISCLAIMER: Under certain conditions, the limit could be bypassed if a large token holder 
592  * redeems a huge portion of their tokens. It will cause the total supply to drop 
593  * which can result in some other token holders having a percentage of tokens 
594  * higher than the intended limit.
595  */
596 
597 
598 
599 
600 
601 
602 /**
603  * @title Transfer Manager module for limiting percentage of token supply a single address can hold
604  */
605 contract PercentageTransferManager is ITransferManager {
606     using SafeMath for uint256;
607 
608     // Permission key for modifying the whitelist
609     bytes32 public constant WHITELIST = "WHITELIST";
610     bytes32 public constant ADMIN = "ADMIN";
611 
612     // Maximum percentage that any holder can have, multiplied by 10**16 - e.g. 20% is 20 * 10**16
613     uint256 public maxHolderPercentage;
614 
615     // Ignore transactions which are part of the primary issuance
616     bool public allowPrimaryIssuance = true;
617 
618     // Addresses on this list are always able to send / receive tokens
619     mapping (address => bool) public whitelist;
620 
621     event ModifyHolderPercentage(uint256 _oldHolderPercentage, uint256 _newHolderPercentage);
622     event ModifyWhitelist(
623         address _investor,
624         uint256 _dateAdded,
625         address _addedBy,
626         bool    _valid
627     );
628     event SetAllowPrimaryIssuance(bool _allowPrimaryIssuance, uint256 _timestamp);
629 
630     /**
631      * @notice Constructor
632      * @param _securityToken Address of the security token
633      * @param _polyAddress Address of the polytoken
634      */
635     constructor (address _securityToken, address _polyAddress)
636     public
637     Module(_securityToken, _polyAddress)
638     {
639     }
640 
641     /** @notice Used to verify the transfer transaction and prevent a given account to end up with more tokens than allowed
642      * @param _from Address of the sender
643      * @param _to Address of the receiver
644      * @param _amount The amount of tokens to transfer
645      */
646     function verifyTransfer(address _from, address _to, uint256 _amount, bytes /* _data */, bool /* _isTransfer */) public returns(Result) {
647         if (!paused) {
648             if (_from == address(0) && allowPrimaryIssuance) {
649                 return Result.NA;
650             }
651             // If an address is on the whitelist, it is allowed to hold more than maxHolderPercentage of the tokens.
652             if (whitelist[_to]) {
653                 return Result.NA;
654             }
655             uint256 newBalance = ISecurityToken(securityToken).balanceOf(_to).add(_amount);
656             if (newBalance.mul(uint256(10)**18).div(ISecurityToken(securityToken).totalSupply()) > maxHolderPercentage) {
657                 return Result.INVALID;
658             }
659             return Result.NA;
660         }
661         return Result.NA;
662     }
663 
664     /**
665      * @notice Used to intialize the variables of the contract
666      * @param _maxHolderPercentage Maximum amount of ST20 tokens(in %) can hold by the investor
667      */
668     function configure(uint256 _maxHolderPercentage, bool _allowPrimaryIssuance) public onlyFactory {
669         maxHolderPercentage = _maxHolderPercentage;
670         allowPrimaryIssuance = _allowPrimaryIssuance;
671     }
672 
673     /**
674      * @notice This function returns the signature of configure function
675      */
676     function getInitFunction() public pure returns (bytes4) {
677         return bytes4(keccak256("configure(uint256,bool)"));
678     }
679 
680     /**
681     * @notice sets the maximum percentage that an individual token holder can hold
682     * @param _maxHolderPercentage is the new maximum percentage (multiplied by 10**16)
683     */
684     function changeHolderPercentage(uint256 _maxHolderPercentage) public withPerm(ADMIN) {
685         emit ModifyHolderPercentage(maxHolderPercentage, _maxHolderPercentage);
686         maxHolderPercentage = _maxHolderPercentage;
687     }
688 
689     /**
690     * @notice adds or removes addresses from the whitelist.
691     * @param _investor is the address to whitelist
692     * @param _valid whether or not the address it to be added or removed from the whitelist
693     */
694     function modifyWhitelist(address _investor, bool _valid) public withPerm(WHITELIST) {
695         whitelist[_investor] = _valid;
696         /*solium-disable-next-line security/no-block-members*/
697         emit ModifyWhitelist(_investor, now, msg.sender, _valid);
698     }
699 
700     /**
701     * @notice adds or removes addresses from the whitelist.
702     * @param _investors Array of the addresses to whitelist
703     * @param _valids Array of boolean value to decide whether or not the address it to be added or removed from the whitelist
704     */
705     function modifyWhitelistMulti(address[] _investors, bool[] _valids) public withPerm(WHITELIST) {
706         require(_investors.length == _valids.length, "Input array length mis-match");
707         for (uint i = 0; i < _investors.length; i++) {
708             modifyWhitelist(_investors[i], _valids[i]);
709         }
710     }
711 
712     /**
713     * @notice sets whether or not to consider primary issuance transfers
714     * @param _allowPrimaryIssuance whether to allow all primary issuance transfers
715     */
716     function setAllowPrimaryIssuance(bool _allowPrimaryIssuance) public withPerm(ADMIN) {
717         require(_allowPrimaryIssuance != allowPrimaryIssuance, "Must change setting");
718         allowPrimaryIssuance = _allowPrimaryIssuance;
719         /*solium-disable-next-line security/no-block-members*/
720         emit SetAllowPrimaryIssuance(_allowPrimaryIssuance, now);
721     }
722 
723     /**
724      * @notice Return the permissions flag that are associated with Percentage transfer Manager
725      */
726     function getPermissions() public view returns(bytes32[]) {
727         bytes32[] memory allPermissions = new bytes32[](2);
728         allPermissions[0] = WHITELIST;
729         allPermissions[1] = ADMIN;
730         return allPermissions;
731     }
732 
733 }
734 
735 /**
736  * @title Interface that every module factory contract should implement
737  */
738 interface IModuleFactory {
739 
740     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
741     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
742     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
743     event GenerateModuleFromFactory(
744         address _module,
745         bytes32 indexed _moduleName,
746         address indexed _moduleFactory,
747         address _creator,
748         uint256 _setupCost,
749         uint256 _timestamp
750     );
751     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
752 
753     //Should create an instance of the Module, or throw
754     function deploy(bytes _data) external returns(address);
755 
756     /**
757      * @notice Type of the Module factory
758      */
759     function getTypes() external view returns(uint8[]);
760 
761     /**
762      * @notice Get the name of the Module
763      */
764     function getName() external view returns(bytes32);
765 
766     /**
767      * @notice Returns the instructions associated with the module
768      */
769     function getInstructions() external view returns (string);
770 
771     /**
772      * @notice Get the tags related to the module factory
773      */
774     function getTags() external view returns (bytes32[]);
775 
776     /**
777      * @notice Used to change the setup fee
778      * @param _newSetupCost New setup fee
779      */
780     function changeFactorySetupFee(uint256 _newSetupCost) external;
781 
782     /**
783      * @notice Used to change the usage fee
784      * @param _newUsageCost New usage fee
785      */
786     function changeFactoryUsageFee(uint256 _newUsageCost) external;
787 
788     /**
789      * @notice Used to change the subscription fee
790      * @param _newSubscriptionCost New subscription fee
791      */
792     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
793 
794     /**
795      * @notice Function use to change the lower and upper bound of the compatible version st
796      * @param _boundType Type of bound
797      * @param _newVersion New version array
798      */
799     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
800 
801    /**
802      * @notice Get the setup cost of the module
803      */
804     function getSetupCost() external view returns (uint256);
805 
806     /**
807      * @notice Used to get the lower bound
808      * @return Lower bound
809      */
810     function getLowerSTVersionBounds() external view returns(uint8[]);
811 
812      /**
813      * @notice Used to get the upper bound
814      * @return Upper bound
815      */
816     function getUpperSTVersionBounds() external view returns(uint8[]);
817 
818 }
819 
820 /**
821  * @title Helper library use to compare or validate the semantic versions
822  */
823 
824 library VersionUtils {
825 
826     /**
827      * @notice This function is used to validate the version submitted
828      * @param _current Array holds the present version of ST
829      * @param _new Array holds the latest version of the ST
830      * @return bool
831      */
832     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
833         bool[] memory _temp = new bool[](_current.length);
834         uint8 counter = 0;
835         for (uint8 i = 0; i < _current.length; i++) {
836             if (_current[i] < _new[i])
837                 _temp[i] = true;
838             else
839                 _temp[i] = false;
840         }
841 
842         for (i = 0; i < _current.length; i++) {
843             if (i == 0) {
844                 if (_current[i] <= _new[i])
845                     if(_temp[0]) {
846                         counter = counter + 3;
847                         break;
848                     } else
849                         counter++;
850                 else
851                     return false;
852             } else {
853                 if (_temp[i-1])
854                     counter++;
855                 else if (_current[i] <= _new[i])
856                     counter++;
857                 else
858                     return false;
859             }
860         }
861         if (counter == _current.length)
862             return true;
863     }
864 
865     /**
866      * @notice Used to compare the lower bound with the latest version
867      * @param _version1 Array holds the lower bound of the version
868      * @param _version2 Array holds the latest version of the ST
869      * @return bool
870      */
871     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
872         require(_version1.length == _version2.length, "Input length mismatch");
873         uint counter = 0;
874         for (uint8 j = 0; j < _version1.length; j++) {
875             if (_version1[j] == 0)
876                 counter ++;
877         }
878         if (counter != _version1.length) {
879             counter = 0;
880             for (uint8 i = 0; i < _version1.length; i++) {
881                 if (_version2[i] > _version1[i])
882                     return true;
883                 else if (_version2[i] < _version1[i])
884                     return false;
885                 else
886                     counter++;
887             }
888             if (counter == _version1.length - 1)
889                 return true;
890             else
891                 return false;
892         } else
893             return true;
894     }
895 
896     /**
897      * @notice Used to compare the upper bound with the latest version
898      * @param _version1 Array holds the upper bound of the version
899      * @param _version2 Array holds the latest version of the ST
900      * @return bool
901      */
902     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
903         require(_version1.length == _version2.length, "Input length mismatch");
904         uint counter = 0;
905         for (uint8 j = 0; j < _version1.length; j++) {
906             if (_version1[j] == 0)
907                 counter ++;
908         }
909         if (counter != _version1.length) {
910             counter = 0;
911             for (uint8 i = 0; i < _version1.length; i++) {
912                 if (_version1[i] > _version2[i])
913                     return true;
914                 else if (_version1[i] < _version2[i])
915                     return false;
916                 else
917                     counter++;
918             }
919             if (counter == _version1.length - 1)
920                 return true;
921             else
922                 return false;
923         } else
924             return true;
925     }
926 
927 
928     /**
929      * @notice Used to pack the uint8[] array data into uint24 value
930      * @param _major Major version
931      * @param _minor Minor version
932      * @param _patch Patch version
933      */
934     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
935         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
936     }
937 
938     /**
939      * @notice Used to convert packed data into uint8 array
940      * @param _packedVersion Packed data
941      */
942     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
943         uint8[] memory _unpackVersion = new uint8[](3);
944         _unpackVersion[0] = uint8(_packedVersion >> 16);
945         _unpackVersion[1] = uint8(_packedVersion >> 8);
946         _unpackVersion[2] = uint8(_packedVersion);
947         return _unpackVersion;
948     }
949 
950 
951 }
952 
953 /**
954  * @title Interface that any module factory contract should implement
955  * @notice Contract is abstract
956  */
957 contract ModuleFactory is IModuleFactory, Ownable {
958 
959     IERC20 public polyToken;
960     uint256 public usageCost;
961     uint256 public monthlySubscriptionCost;
962 
963     uint256 public setupCost;
964     string public description;
965     string public version;
966     bytes32 public name;
967     string public title;
968 
969     // @notice Allow only two variables to be stored
970     // 1. lowerBound 
971     // 2. upperBound
972     // @dev (0.0.0 will act as the wildcard) 
973     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
974     mapping(string => uint24) compatibleSTVersionRange;
975 
976     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
977     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
978     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
979     event GenerateModuleFromFactory(
980         address _module,
981         bytes32 indexed _moduleName,
982         address indexed _moduleFactory,
983         address _creator,
984         uint256 _timestamp
985     );
986     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
987 
988     /**
989      * @notice Constructor
990      * @param _polyAddress Address of the polytoken
991      */
992     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
993         polyToken = IERC20(_polyAddress);
994         setupCost = _setupCost;
995         usageCost = _usageCost;
996         monthlySubscriptionCost = _subscriptionCost;
997     }
998 
999     /**
1000      * @notice Used to change the fee of the setup cost
1001      * @param _newSetupCost new setup cost
1002      */
1003     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
1004         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
1005         setupCost = _newSetupCost;
1006     }
1007 
1008     /**
1009      * @notice Used to change the fee of the usage cost
1010      * @param _newUsageCost new usage cost
1011      */
1012     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
1013         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
1014         usageCost = _newUsageCost;
1015     }
1016 
1017     /**
1018      * @notice Used to change the fee of the subscription cost
1019      * @param _newSubscriptionCost new subscription cost
1020      */
1021     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
1022         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
1023         monthlySubscriptionCost = _newSubscriptionCost;
1024 
1025     }
1026 
1027     /**
1028      * @notice Updates the title of the ModuleFactory
1029      * @param _newTitle New Title that will replace the old one.
1030      */
1031     function changeTitle(string _newTitle) public onlyOwner {
1032         require(bytes(_newTitle).length > 0, "Invalid title");
1033         title = _newTitle;
1034     }
1035 
1036     /**
1037      * @notice Updates the description of the ModuleFactory
1038      * @param _newDesc New description that will replace the old one.
1039      */
1040     function changeDescription(string _newDesc) public onlyOwner {
1041         require(bytes(_newDesc).length > 0, "Invalid description");
1042         description = _newDesc;
1043     }
1044 
1045     /**
1046      * @notice Updates the name of the ModuleFactory
1047      * @param _newName New name that will replace the old one.
1048      */
1049     function changeName(bytes32 _newName) public onlyOwner {
1050         require(_newName != bytes32(0),"Invalid name");
1051         name = _newName;
1052     }
1053 
1054     /**
1055      * @notice Updates the version of the ModuleFactory
1056      * @param _newVersion New name that will replace the old one.
1057      */
1058     function changeVersion(string _newVersion) public onlyOwner {
1059         require(bytes(_newVersion).length > 0, "Invalid version");
1060         version = _newVersion;
1061     }
1062 
1063     /**
1064      * @notice Function use to change the lower and upper bound of the compatible version st
1065      * @param _boundType Type of bound
1066      * @param _newVersion new version array
1067      */
1068     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
1069         require(
1070             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
1071             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
1072             "Must be a valid bound type"
1073         );
1074         require(_newVersion.length == 3);
1075         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
1076             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
1077             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
1078         }
1079         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
1080         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
1081     }
1082 
1083     /**
1084      * @notice Used to get the lower bound
1085      * @return lower bound
1086      */
1087     function getLowerSTVersionBounds() external view returns(uint8[]) {
1088         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
1089     }
1090 
1091     /**
1092      * @notice Used to get the upper bound
1093      * @return upper bound
1094      */
1095     function getUpperSTVersionBounds() external view returns(uint8[]) {
1096         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
1097     }
1098 
1099     /**
1100      * @notice Get the setup cost of the module
1101      */
1102     function getSetupCost() external view returns (uint256) {
1103         return setupCost;
1104     }
1105 
1106    /**
1107     * @notice Get the name of the Module
1108     */
1109     function getName() public view returns(bytes32) {
1110         return name;
1111     }
1112 
1113 }
1114 
1115 /**
1116  * @title Utility contract for reusable code
1117  */
1118 library Util {
1119 
1120    /**
1121     * @notice Changes a string to upper case
1122     * @param _base String to change
1123     */
1124     function upper(string _base) internal pure returns (string) {
1125         bytes memory _baseBytes = bytes(_base);
1126         for (uint i = 0; i < _baseBytes.length; i++) {
1127             bytes1 b1 = _baseBytes[i];
1128             if (b1 >= 0x61 && b1 <= 0x7A) {
1129                 b1 = bytes1(uint8(b1)-32);
1130             }
1131             _baseBytes[i] = b1;
1132         }
1133         return string(_baseBytes);
1134     }
1135 
1136     /**
1137      * @notice Changes the string into bytes32
1138      * @param _source String that need to convert into bytes32
1139      */
1140     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1141     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
1142         return bytesToBytes32(bytes(_source), 0);
1143     }
1144 
1145     /**
1146      * @notice Changes bytes into bytes32
1147      * @param _b Bytes that need to convert into bytes32
1148      * @param _offset Offset from which to begin conversion
1149      */
1150     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1151     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
1152         bytes32 result;
1153 
1154         for (uint i = 0; i < _b.length; i++) {
1155             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
1156         }
1157         return result;
1158     }
1159 
1160     /**
1161      * @notice Changes the bytes32 into string
1162      * @param _source that need to convert into string
1163      */
1164     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
1165         bytes memory bytesString = new bytes(32);
1166         uint charCount = 0;
1167         for (uint j = 0; j < 32; j++) {
1168             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
1169             if (char != 0) {
1170                 bytesString[charCount] = char;
1171                 charCount++;
1172             }
1173         }
1174         bytes memory bytesStringTrimmed = new bytes(charCount);
1175         for (j = 0; j < charCount; j++) {
1176             bytesStringTrimmed[j] = bytesString[j];
1177         }
1178         return string(bytesStringTrimmed);
1179     }
1180 
1181     /**
1182      * @notice Gets function signature from _data
1183      * @param _data Passed data
1184      * @return bytes4 sig
1185      */
1186     function getSig(bytes _data) internal pure returns (bytes4 sig) {
1187         uint len = _data.length < 4 ? _data.length : 4;
1188         for (uint i = 0; i < len; i++) {
1189             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
1190         }
1191     }
1192 
1193 
1194 }
1195 
1196 /**
1197  * @title Factory for deploying PercentageTransferManager module
1198  */
1199 contract PercentageTransferManagerFactory is ModuleFactory {
1200 
1201     /**
1202      * @notice Constructor
1203      * @param _polyAddress Address of the polytoken
1204      */
1205     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1206     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1207     {
1208         version = "1.0.0";
1209         name = "PercentageTransferManager";
1210         title = "Percentage Transfer Manager";
1211         description = "Restrict the number of investors";
1212         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1213         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1214     }
1215 
1216     /**
1217      * @notice used to launch the Module with the help of factory
1218      * @param _data Data used for the intialization of the module factory variables
1219      * @return address Contract address of the Module
1220      */
1221     function deploy(bytes _data) external returns(address) {
1222         if(setupCost > 0)
1223             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
1224         PercentageTransferManager percentageTransferManager = new PercentageTransferManager(msg.sender, address(polyToken));
1225         require(Util.getSig(_data) == percentageTransferManager.getInitFunction(), "Provided data is not valid");
1226         /*solium-disable-next-line security/no-low-level-calls*/
1227         require(address(percentageTransferManager).call(_data), "Unsuccessful call");
1228         /*solium-disable-next-line security/no-block-members*/
1229         emit GenerateModuleFromFactory(address(percentageTransferManager), getName(), address(this), msg.sender, setupCost, now);
1230         return address(percentageTransferManager);
1231 
1232     }
1233 
1234     /**
1235      * @notice Type of the Module factory
1236      * @return uint8
1237      */
1238     function getTypes() external view returns(uint8[]) {
1239         uint8[] memory res = new uint8[](1);
1240         res[0] = 2;
1241         return res;
1242     }
1243 
1244     /**
1245      * @notice Returns the instructions associated with the module
1246      */
1247     function getInstructions() external view returns(string) {
1248         return "Allows an issuer to restrict the total number of non-zero token holders";
1249     }
1250 
1251     /**
1252      * @notice Get the tags related to the module factory
1253      */
1254     function getTags() external view returns(bytes32[]) {
1255         bytes32[] memory availableTags = new bytes32[](2);
1256         availableTags[0] = "Percentage";
1257         availableTags[1] = "Transfer Restriction";
1258         return availableTags;
1259     }
1260 }