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
541  * @title Transfer Manager for limiting maximum number of token holders
542  */
543 contract CountTransferManager is ITransferManager {
544 
545     // The maximum number of concurrent token holders
546     uint256 public maxHolderCount;
547 
548     bytes32 public constant ADMIN = "ADMIN";
549 
550     event ModifyHolderCount(uint256 _oldHolderCount, uint256 _newHolderCount);
551 
552     /**
553      * @notice Constructor
554      * @param _securityToken Address of the security token
555      * @param _polyAddress Address of the polytoken
556      */
557     constructor (address _securityToken, address _polyAddress)
558     public
559     Module(_securityToken, _polyAddress)
560     {
561     }
562 
563     /** @notice Used to verify the transfer transaction and prevent a transfer if it passes the allowed amount of token holders
564      * @param _to Address of the receiver
565      */
566     function verifyTransfer(
567         address /* _from */,
568         address _to,
569         uint256 /* _amount */,
570         bytes /* _data */,
571         bool /* _isTransfer */
572     )
573         public
574         returns(Result)
575     {
576         if (!paused) {
577             if (maxHolderCount < ISecurityToken(securityToken).getInvestorCount()) {
578                 // Allow transfers to existing maxHolders
579                 if (ISecurityToken(securityToken).balanceOf(_to) != 0) {
580                     return Result.NA;
581                 }
582                 return Result.INVALID;
583             }
584             return Result.NA;
585         }
586         return Result.NA;
587     }
588 
589     /**
590      * @notice Used to initialize the variables of the contract
591      * @param _maxHolderCount Maximum no. of holders this module allows the SecurityToken to have
592      */
593     function configure(uint256 _maxHolderCount) public onlyFactory {
594         maxHolderCount = _maxHolderCount;
595     }
596 
597     /**
598     * @notice Sets the cap for the amount of token holders there can be
599     * @param _maxHolderCount is the new maximum amount of token holders
600     */
601     function changeHolderCount(uint256 _maxHolderCount) public withPerm(ADMIN) {
602         emit ModifyHolderCount(maxHolderCount, _maxHolderCount);
603         maxHolderCount = _maxHolderCount;
604     }
605 
606     /**
607      * @notice This function returns the signature of configure function
608      */
609     function getInitFunction() public pure returns (bytes4) {
610         return bytes4(keccak256("configure(uint256)"));
611     }
612 
613     /**
614      * @notice Returns the permissions flag that are associated with CountTransferManager
615      */
616     function getPermissions() public view returns(bytes32[]) {
617         bytes32[] memory allPermissions = new bytes32[](1);
618         allPermissions[0] = ADMIN;
619         return allPermissions;
620     }
621 
622 }
623 
624 /**
625  * @title Interface that every module factory contract should implement
626  */
627 interface IModuleFactory {
628 
629     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
630     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
631     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
632     event GenerateModuleFromFactory(
633         address _module,
634         bytes32 indexed _moduleName,
635         address indexed _moduleFactory,
636         address _creator,
637         uint256 _setupCost,
638         uint256 _timestamp
639     );
640     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
641 
642     //Should create an instance of the Module, or throw
643     function deploy(bytes _data) external returns(address);
644 
645     /**
646      * @notice Type of the Module factory
647      */
648     function getTypes() external view returns(uint8[]);
649 
650     /**
651      * @notice Get the name of the Module
652      */
653     function getName() external view returns(bytes32);
654 
655     /**
656      * @notice Returns the instructions associated with the module
657      */
658     function getInstructions() external view returns (string);
659 
660     /**
661      * @notice Get the tags related to the module factory
662      */
663     function getTags() external view returns (bytes32[]);
664 
665     /**
666      * @notice Used to change the setup fee
667      * @param _newSetupCost New setup fee
668      */
669     function changeFactorySetupFee(uint256 _newSetupCost) external;
670 
671     /**
672      * @notice Used to change the usage fee
673      * @param _newUsageCost New usage fee
674      */
675     function changeFactoryUsageFee(uint256 _newUsageCost) external;
676 
677     /**
678      * @notice Used to change the subscription fee
679      * @param _newSubscriptionCost New subscription fee
680      */
681     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
682 
683     /**
684      * @notice Function use to change the lower and upper bound of the compatible version st
685      * @param _boundType Type of bound
686      * @param _newVersion New version array
687      */
688     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
689 
690    /**
691      * @notice Get the setup cost of the module
692      */
693     function getSetupCost() external view returns (uint256);
694 
695     /**
696      * @notice Used to get the lower bound
697      * @return Lower bound
698      */
699     function getLowerSTVersionBounds() external view returns(uint8[]);
700 
701      /**
702      * @notice Used to get the upper bound
703      * @return Upper bound
704      */
705     function getUpperSTVersionBounds() external view returns(uint8[]);
706 
707 }
708 
709 /**
710  * @title Helper library use to compare or validate the semantic versions
711  */
712 
713 library VersionUtils {
714 
715     /**
716      * @notice This function is used to validate the version submitted
717      * @param _current Array holds the present version of ST
718      * @param _new Array holds the latest version of the ST
719      * @return bool
720      */
721     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
722         bool[] memory _temp = new bool[](_current.length);
723         uint8 counter = 0;
724         for (uint8 i = 0; i < _current.length; i++) {
725             if (_current[i] < _new[i])
726                 _temp[i] = true;
727             else
728                 _temp[i] = false;
729         }
730 
731         for (i = 0; i < _current.length; i++) {
732             if (i == 0) {
733                 if (_current[i] <= _new[i])
734                     if(_temp[0]) {
735                         counter = counter + 3;
736                         break;
737                     } else
738                         counter++;
739                 else
740                     return false;
741             } else {
742                 if (_temp[i-1])
743                     counter++;
744                 else if (_current[i] <= _new[i])
745                     counter++;
746                 else
747                     return false;
748             }
749         }
750         if (counter == _current.length)
751             return true;
752     }
753 
754     /**
755      * @notice Used to compare the lower bound with the latest version
756      * @param _version1 Array holds the lower bound of the version
757      * @param _version2 Array holds the latest version of the ST
758      * @return bool
759      */
760     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
761         require(_version1.length == _version2.length, "Input length mismatch");
762         uint counter = 0;
763         for (uint8 j = 0; j < _version1.length; j++) {
764             if (_version1[j] == 0)
765                 counter ++;
766         }
767         if (counter != _version1.length) {
768             counter = 0;
769             for (uint8 i = 0; i < _version1.length; i++) {
770                 if (_version2[i] > _version1[i])
771                     return true;
772                 else if (_version2[i] < _version1[i])
773                     return false;
774                 else
775                     counter++;
776             }
777             if (counter == _version1.length - 1)
778                 return true;
779             else
780                 return false;
781         } else
782             return true;
783     }
784 
785     /**
786      * @notice Used to compare the upper bound with the latest version
787      * @param _version1 Array holds the upper bound of the version
788      * @param _version2 Array holds the latest version of the ST
789      * @return bool
790      */
791     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
792         require(_version1.length == _version2.length, "Input length mismatch");
793         uint counter = 0;
794         for (uint8 j = 0; j < _version1.length; j++) {
795             if (_version1[j] == 0)
796                 counter ++;
797         }
798         if (counter != _version1.length) {
799             counter = 0;
800             for (uint8 i = 0; i < _version1.length; i++) {
801                 if (_version1[i] > _version2[i])
802                     return true;
803                 else if (_version1[i] < _version2[i])
804                     return false;
805                 else
806                     counter++;
807             }
808             if (counter == _version1.length - 1)
809                 return true;
810             else
811                 return false;
812         } else
813             return true;
814     }
815 
816 
817     /**
818      * @notice Used to pack the uint8[] array data into uint24 value
819      * @param _major Major version
820      * @param _minor Minor version
821      * @param _patch Patch version
822      */
823     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
824         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
825     }
826 
827     /**
828      * @notice Used to convert packed data into uint8 array
829      * @param _packedVersion Packed data
830      */
831     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
832         uint8[] memory _unpackVersion = new uint8[](3);
833         _unpackVersion[0] = uint8(_packedVersion >> 16);
834         _unpackVersion[1] = uint8(_packedVersion >> 8);
835         _unpackVersion[2] = uint8(_packedVersion);
836         return _unpackVersion;
837     }
838 
839 
840 }
841 
842 /**
843  * @title Interface that any module factory contract should implement
844  * @notice Contract is abstract
845  */
846 contract ModuleFactory is IModuleFactory, Ownable {
847 
848     IERC20 public polyToken;
849     uint256 public usageCost;
850     uint256 public monthlySubscriptionCost;
851 
852     uint256 public setupCost;
853     string public description;
854     string public version;
855     bytes32 public name;
856     string public title;
857 
858     // @notice Allow only two variables to be stored
859     // 1. lowerBound 
860     // 2. upperBound
861     // @dev (0.0.0 will act as the wildcard) 
862     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
863     mapping(string => uint24) compatibleSTVersionRange;
864 
865     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
866     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
867     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
868     event GenerateModuleFromFactory(
869         address _module,
870         bytes32 indexed _moduleName,
871         address indexed _moduleFactory,
872         address _creator,
873         uint256 _timestamp
874     );
875     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
876 
877     /**
878      * @notice Constructor
879      * @param _polyAddress Address of the polytoken
880      */
881     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
882         polyToken = IERC20(_polyAddress);
883         setupCost = _setupCost;
884         usageCost = _usageCost;
885         monthlySubscriptionCost = _subscriptionCost;
886     }
887 
888     /**
889      * @notice Used to change the fee of the setup cost
890      * @param _newSetupCost new setup cost
891      */
892     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
893         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
894         setupCost = _newSetupCost;
895     }
896 
897     /**
898      * @notice Used to change the fee of the usage cost
899      * @param _newUsageCost new usage cost
900      */
901     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
902         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
903         usageCost = _newUsageCost;
904     }
905 
906     /**
907      * @notice Used to change the fee of the subscription cost
908      * @param _newSubscriptionCost new subscription cost
909      */
910     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
911         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
912         monthlySubscriptionCost = _newSubscriptionCost;
913 
914     }
915 
916     /**
917      * @notice Updates the title of the ModuleFactory
918      * @param _newTitle New Title that will replace the old one.
919      */
920     function changeTitle(string _newTitle) public onlyOwner {
921         require(bytes(_newTitle).length > 0, "Invalid title");
922         title = _newTitle;
923     }
924 
925     /**
926      * @notice Updates the description of the ModuleFactory
927      * @param _newDesc New description that will replace the old one.
928      */
929     function changeDescription(string _newDesc) public onlyOwner {
930         require(bytes(_newDesc).length > 0, "Invalid description");
931         description = _newDesc;
932     }
933 
934     /**
935      * @notice Updates the name of the ModuleFactory
936      * @param _newName New name that will replace the old one.
937      */
938     function changeName(bytes32 _newName) public onlyOwner {
939         require(_newName != bytes32(0),"Invalid name");
940         name = _newName;
941     }
942 
943     /**
944      * @notice Updates the version of the ModuleFactory
945      * @param _newVersion New name that will replace the old one.
946      */
947     function changeVersion(string _newVersion) public onlyOwner {
948         require(bytes(_newVersion).length > 0, "Invalid version");
949         version = _newVersion;
950     }
951 
952     /**
953      * @notice Function use to change the lower and upper bound of the compatible version st
954      * @param _boundType Type of bound
955      * @param _newVersion new version array
956      */
957     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
958         require(
959             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
960             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
961             "Must be a valid bound type"
962         );
963         require(_newVersion.length == 3);
964         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
965             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
966             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
967         }
968         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
969         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
970     }
971 
972     /**
973      * @notice Used to get the lower bound
974      * @return lower bound
975      */
976     function getLowerSTVersionBounds() external view returns(uint8[]) {
977         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
978     }
979 
980     /**
981      * @notice Used to get the upper bound
982      * @return upper bound
983      */
984     function getUpperSTVersionBounds() external view returns(uint8[]) {
985         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
986     }
987 
988     /**
989      * @notice Get the setup cost of the module
990      */
991     function getSetupCost() external view returns (uint256) {
992         return setupCost;
993     }
994 
995    /**
996     * @notice Get the name of the Module
997     */
998     function getName() public view returns(bytes32) {
999         return name;
1000     }
1001 
1002 }
1003 
1004 /**
1005  * @title Utility contract for reusable code
1006  */
1007 library Util {
1008 
1009    /**
1010     * @notice Changes a string to upper case
1011     * @param _base String to change
1012     */
1013     function upper(string _base) internal pure returns (string) {
1014         bytes memory _baseBytes = bytes(_base);
1015         for (uint i = 0; i < _baseBytes.length; i++) {
1016             bytes1 b1 = _baseBytes[i];
1017             if (b1 >= 0x61 && b1 <= 0x7A) {
1018                 b1 = bytes1(uint8(b1)-32);
1019             }
1020             _baseBytes[i] = b1;
1021         }
1022         return string(_baseBytes);
1023     }
1024 
1025     /**
1026      * @notice Changes the string into bytes32
1027      * @param _source String that need to convert into bytes32
1028      */
1029     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1030     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
1031         return bytesToBytes32(bytes(_source), 0);
1032     }
1033 
1034     /**
1035      * @notice Changes bytes into bytes32
1036      * @param _b Bytes that need to convert into bytes32
1037      * @param _offset Offset from which to begin conversion
1038      */
1039     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1040     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
1041         bytes32 result;
1042 
1043         for (uint i = 0; i < _b.length; i++) {
1044             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
1045         }
1046         return result;
1047     }
1048 
1049     /**
1050      * @notice Changes the bytes32 into string
1051      * @param _source that need to convert into string
1052      */
1053     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
1054         bytes memory bytesString = new bytes(32);
1055         uint charCount = 0;
1056         for (uint j = 0; j < 32; j++) {
1057             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
1058             if (char != 0) {
1059                 bytesString[charCount] = char;
1060                 charCount++;
1061             }
1062         }
1063         bytes memory bytesStringTrimmed = new bytes(charCount);
1064         for (j = 0; j < charCount; j++) {
1065             bytesStringTrimmed[j] = bytesString[j];
1066         }
1067         return string(bytesStringTrimmed);
1068     }
1069 
1070     /**
1071      * @notice Gets function signature from _data
1072      * @param _data Passed data
1073      * @return bytes4 sig
1074      */
1075     function getSig(bytes _data) internal pure returns (bytes4 sig) {
1076         uint len = _data.length < 4 ? _data.length : 4;
1077         for (uint i = 0; i < len; i++) {
1078             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
1079         }
1080     }
1081 
1082 
1083 }
1084 
1085 /**
1086  * @title Factory for deploying CountTransferManager module
1087  */
1088 contract CountTransferManagerFactory is ModuleFactory {
1089 
1090     /**
1091      * @notice Constructor
1092      * @param _polyAddress Address of the polytoken
1093      */
1094     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1095     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1096     {
1097         version = "1.0.0";
1098         name = "CountTransferManager";
1099         title = "Count Transfer Manager";
1100         description = "Restrict the number of investors";
1101         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1102         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1103     }
1104 
1105     /**
1106      * @notice Used to launch the Module with the help of factory
1107      * @param _data Data used for the intialization of the module factory variables
1108      * @return address Contract address of the Module
1109      */
1110     function deploy(bytes _data) external returns(address) {
1111         if(setupCost > 0)
1112             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom due to insufficent Allowance provided");
1113         CountTransferManager countTransferManager = new CountTransferManager(msg.sender, address(polyToken));
1114         require(Util.getSig(_data) == countTransferManager.getInitFunction(), "Provided data is not valid");
1115         /*solium-disable-next-line security/no-low-level-calls*/
1116         require(address(countTransferManager).call(_data), "Unsuccessful call");
1117         /*solium-disable-next-line security/no-block-members*/
1118         emit GenerateModuleFromFactory(address(countTransferManager), getName(), address(this), msg.sender, setupCost, now);
1119         return address(countTransferManager);
1120 
1121     }
1122 
1123     /**
1124      * @notice Type of the Module factory
1125      */
1126     function getTypes() external view returns(uint8[]) {
1127         uint8[] memory res = new uint8[](1);
1128         res[0] = 2;
1129         return res;
1130     }
1131 
1132     /**
1133      * @notice Returns the instructions associated with the module
1134      */
1135     function getInstructions() external view returns(string) {
1136         return "Allows an issuer to restrict the total number of non-zero token holders";
1137     }
1138 
1139     /**
1140      * @notice Get the tags related to the module factory
1141      */
1142     function getTags() external view returns(bytes32[]) {
1143         bytes32[] memory availableTags = new bytes32[](2);
1144         availableTags[0] = "Count";
1145         availableTags[1] = "Transfer Restriction";
1146         return availableTags;
1147     }
1148 }