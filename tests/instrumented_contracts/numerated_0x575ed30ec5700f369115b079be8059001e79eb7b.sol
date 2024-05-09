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
560  * @title Transfer Manager for limiting maximum number of token holders
561  */
562 contract CountTransferManager is ITransferManager {
563 
564     // The maximum number of concurrent token holders
565     uint256 public maxHolderCount;
566 
567     bytes32 public constant ADMIN = "ADMIN";
568 
569     event ModifyHolderCount(uint256 _oldHolderCount, uint256 _newHolderCount);
570 
571     /**
572      * @notice Constructor
573      * @param _securityToken Address of the security token
574      * @param _polyAddress Address of the polytoken
575      */
576     constructor (address _securityToken, address _polyAddress)
577     public
578     Module(_securityToken, _polyAddress)
579     {
580     }
581 
582     /** @notice Used to verify the transfer transaction and prevent a transfer if it passes the allowed amount of token holders
583      * @param _from Address of the sender
584      * @param _to Address of the receiver
585      * @param _amount Amount to send
586      */
587     function verifyTransfer(
588         address _from,
589         address _to,
590         uint256 _amount,
591         bytes /* _data */,
592         bool /* _isTransfer */
593     )
594         public
595         returns(Result)
596     {
597         if (!paused) {
598             if (maxHolderCount < ISecurityToken(securityToken).getInvestorCount()) {
599                 // Allow transfers to existing maxHolders
600                 if (ISecurityToken(securityToken).balanceOf(_to) != 0 || ISecurityToken(securityToken).balanceOf(_from) == _amount) {
601                     return Result.NA;
602                 }
603                 return Result.INVALID;
604             }
605             return Result.NA;
606         }
607         return Result.NA;
608     }
609 
610     /**
611      * @notice Used to initialize the variables of the contract
612      * @param _maxHolderCount Maximum no. of holders this module allows the SecurityToken to have
613      */
614     function configure(uint256 _maxHolderCount) public onlyFactory {
615         maxHolderCount = _maxHolderCount;
616     }
617 
618     /**
619     * @notice Sets the cap for the amount of token holders there can be
620     * @param _maxHolderCount is the new maximum amount of token holders
621     */
622     function changeHolderCount(uint256 _maxHolderCount) public withPerm(ADMIN) {
623         emit ModifyHolderCount(maxHolderCount, _maxHolderCount);
624         maxHolderCount = _maxHolderCount;
625     }
626 
627     /**
628      * @notice This function returns the signature of configure function
629      */
630     function getInitFunction() public pure returns (bytes4) {
631         return bytes4(keccak256("configure(uint256)"));
632     }
633 
634     /**
635      * @notice Returns the permissions flag that are associated with CountTransferManager
636      */
637     function getPermissions() public view returns(bytes32[]) {
638         bytes32[] memory allPermissions = new bytes32[](1);
639         allPermissions[0] = ADMIN;
640         return allPermissions;
641     }
642 
643 }
644 
645 /**
646  * @title Interface that every module factory contract should implement
647  */
648 interface IModuleFactory {
649 
650     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
651     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
652     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
653     event GenerateModuleFromFactory(
654         address _module,
655         bytes32 indexed _moduleName,
656         address indexed _moduleFactory,
657         address _creator,
658         uint256 _setupCost,
659         uint256 _timestamp
660     );
661     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
662 
663     //Should create an instance of the Module, or throw
664     function deploy(bytes _data) external returns(address);
665 
666     /**
667      * @notice Type of the Module factory
668      */
669     function getTypes() external view returns(uint8[]);
670 
671     /**
672      * @notice Get the name of the Module
673      */
674     function getName() external view returns(bytes32);
675 
676     /**
677      * @notice Returns the instructions associated with the module
678      */
679     function getInstructions() external view returns (string);
680 
681     /**
682      * @notice Get the tags related to the module factory
683      */
684     function getTags() external view returns (bytes32[]);
685 
686     /**
687      * @notice Used to change the setup fee
688      * @param _newSetupCost New setup fee
689      */
690     function changeFactorySetupFee(uint256 _newSetupCost) external;
691 
692     /**
693      * @notice Used to change the usage fee
694      * @param _newUsageCost New usage fee
695      */
696     function changeFactoryUsageFee(uint256 _newUsageCost) external;
697 
698     /**
699      * @notice Used to change the subscription fee
700      * @param _newSubscriptionCost New subscription fee
701      */
702     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
703 
704     /**
705      * @notice Function use to change the lower and upper bound of the compatible version st
706      * @param _boundType Type of bound
707      * @param _newVersion New version array
708      */
709     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
710 
711    /**
712      * @notice Get the setup cost of the module
713      */
714     function getSetupCost() external view returns (uint256);
715 
716     /**
717      * @notice Used to get the lower bound
718      * @return Lower bound
719      */
720     function getLowerSTVersionBounds() external view returns(uint8[]);
721 
722      /**
723      * @notice Used to get the upper bound
724      * @return Upper bound
725      */
726     function getUpperSTVersionBounds() external view returns(uint8[]);
727 
728 }
729 
730 /**
731  * @title Helper library use to compare or validate the semantic versions
732  */
733 
734 library VersionUtils {
735 
736     /**
737      * @notice This function is used to validate the version submitted
738      * @param _current Array holds the present version of ST
739      * @param _new Array holds the latest version of the ST
740      * @return bool
741      */
742     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
743         bool[] memory _temp = new bool[](_current.length);
744         uint8 counter = 0;
745         for (uint8 i = 0; i < _current.length; i++) {
746             if (_current[i] < _new[i])
747                 _temp[i] = true;
748             else
749                 _temp[i] = false;
750         }
751 
752         for (i = 0; i < _current.length; i++) {
753             if (i == 0) {
754                 if (_current[i] <= _new[i])
755                     if(_temp[0]) {
756                         counter = counter + 3;
757                         break;
758                     } else
759                         counter++;
760                 else
761                     return false;
762             } else {
763                 if (_temp[i-1])
764                     counter++;
765                 else if (_current[i] <= _new[i])
766                     counter++;
767                 else
768                     return false;
769             }
770         }
771         if (counter == _current.length)
772             return true;
773     }
774 
775     /**
776      * @notice Used to compare the lower bound with the latest version
777      * @param _version1 Array holds the lower bound of the version
778      * @param _version2 Array holds the latest version of the ST
779      * @return bool
780      */
781     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
782         require(_version1.length == _version2.length, "Input length mismatch");
783         uint counter = 0;
784         for (uint8 j = 0; j < _version1.length; j++) {
785             if (_version1[j] == 0)
786                 counter ++;
787         }
788         if (counter != _version1.length) {
789             counter = 0;
790             for (uint8 i = 0; i < _version1.length; i++) {
791                 if (_version2[i] > _version1[i])
792                     return true;
793                 else if (_version2[i] < _version1[i])
794                     return false;
795                 else
796                     counter++;
797             }
798             if (counter == _version1.length - 1)
799                 return true;
800             else
801                 return false;
802         } else
803             return true;
804     }
805 
806     /**
807      * @notice Used to compare the upper bound with the latest version
808      * @param _version1 Array holds the upper bound of the version
809      * @param _version2 Array holds the latest version of the ST
810      * @return bool
811      */
812     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
813         require(_version1.length == _version2.length, "Input length mismatch");
814         uint counter = 0;
815         for (uint8 j = 0; j < _version1.length; j++) {
816             if (_version1[j] == 0)
817                 counter ++;
818         }
819         if (counter != _version1.length) {
820             counter = 0;
821             for (uint8 i = 0; i < _version1.length; i++) {
822                 if (_version1[i] > _version2[i])
823                     return true;
824                 else if (_version1[i] < _version2[i])
825                     return false;
826                 else
827                     counter++;
828             }
829             if (counter == _version1.length - 1)
830                 return true;
831             else
832                 return false;
833         } else
834             return true;
835     }
836 
837 
838     /**
839      * @notice Used to pack the uint8[] array data into uint24 value
840      * @param _major Major version
841      * @param _minor Minor version
842      * @param _patch Patch version
843      */
844     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
845         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
846     }
847 
848     /**
849      * @notice Used to convert packed data into uint8 array
850      * @param _packedVersion Packed data
851      */
852     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
853         uint8[] memory _unpackVersion = new uint8[](3);
854         _unpackVersion[0] = uint8(_packedVersion >> 16);
855         _unpackVersion[1] = uint8(_packedVersion >> 8);
856         _unpackVersion[2] = uint8(_packedVersion);
857         return _unpackVersion;
858     }
859 
860 
861 }
862 
863 /**
864  * @title Interface that any module factory contract should implement
865  * @notice Contract is abstract
866  */
867 contract ModuleFactory is IModuleFactory, Ownable {
868 
869     IERC20 public polyToken;
870     uint256 public usageCost;
871     uint256 public monthlySubscriptionCost;
872 
873     uint256 public setupCost;
874     string public description;
875     string public version;
876     bytes32 public name;
877     string public title;
878 
879     // @notice Allow only two variables to be stored
880     // 1. lowerBound 
881     // 2. upperBound
882     // @dev (0.0.0 will act as the wildcard) 
883     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
884     mapping(string => uint24) compatibleSTVersionRange;
885 
886     /**
887      * @notice Constructor
888      * @param _polyAddress Address of the polytoken
889      */
890     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
891         polyToken = IERC20(_polyAddress);
892         setupCost = _setupCost;
893         usageCost = _usageCost;
894         monthlySubscriptionCost = _subscriptionCost;
895     }
896 
897     /**
898      * @notice Used to change the fee of the setup cost
899      * @param _newSetupCost new setup cost
900      */
901     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
902         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
903         setupCost = _newSetupCost;
904     }
905 
906     /**
907      * @notice Used to change the fee of the usage cost
908      * @param _newUsageCost new usage cost
909      */
910     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
911         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
912         usageCost = _newUsageCost;
913     }
914 
915     /**
916      * @notice Used to change the fee of the subscription cost
917      * @param _newSubscriptionCost new subscription cost
918      */
919     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
920         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
921         monthlySubscriptionCost = _newSubscriptionCost;
922 
923     }
924 
925     /**
926      * @notice Updates the title of the ModuleFactory
927      * @param _newTitle New Title that will replace the old one.
928      */
929     function changeTitle(string _newTitle) public onlyOwner {
930         require(bytes(_newTitle).length > 0, "Invalid title");
931         title = _newTitle;
932     }
933 
934     /**
935      * @notice Updates the description of the ModuleFactory
936      * @param _newDesc New description that will replace the old one.
937      */
938     function changeDescription(string _newDesc) public onlyOwner {
939         require(bytes(_newDesc).length > 0, "Invalid description");
940         description = _newDesc;
941     }
942 
943     /**
944      * @notice Updates the name of the ModuleFactory
945      * @param _newName New name that will replace the old one.
946      */
947     function changeName(bytes32 _newName) public onlyOwner {
948         require(_newName != bytes32(0),"Invalid name");
949         name = _newName;
950     }
951 
952     /**
953      * @notice Updates the version of the ModuleFactory
954      * @param _newVersion New name that will replace the old one.
955      */
956     function changeVersion(string _newVersion) public onlyOwner {
957         require(bytes(_newVersion).length > 0, "Invalid version");
958         version = _newVersion;
959     }
960 
961     /**
962      * @notice Function use to change the lower and upper bound of the compatible version st
963      * @param _boundType Type of bound
964      * @param _newVersion new version array
965      */
966     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
967         require(
968             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
969             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
970             "Must be a valid bound type"
971         );
972         require(_newVersion.length == 3);
973         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
974             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
975             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
976         }
977         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
978         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
979     }
980 
981     /**
982      * @notice Used to get the lower bound
983      * @return lower bound
984      */
985     function getLowerSTVersionBounds() external view returns(uint8[]) {
986         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
987     }
988 
989     /**
990      * @notice Used to get the upper bound
991      * @return upper bound
992      */
993     function getUpperSTVersionBounds() external view returns(uint8[]) {
994         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
995     }
996 
997     /**
998      * @notice Get the setup cost of the module
999      */
1000     function getSetupCost() external view returns (uint256) {
1001         return setupCost;
1002     }
1003 
1004    /**
1005     * @notice Get the name of the Module
1006     */
1007     function getName() public view returns(bytes32) {
1008         return name;
1009     }
1010 
1011 }
1012 
1013 /**
1014  * @title Utility contract for reusable code
1015  */
1016 library Util {
1017 
1018    /**
1019     * @notice Changes a string to upper case
1020     * @param _base String to change
1021     */
1022     function upper(string _base) internal pure returns (string) {
1023         bytes memory _baseBytes = bytes(_base);
1024         for (uint i = 0; i < _baseBytes.length; i++) {
1025             bytes1 b1 = _baseBytes[i];
1026             if (b1 >= 0x61 && b1 <= 0x7A) {
1027                 b1 = bytes1(uint8(b1)-32);
1028             }
1029             _baseBytes[i] = b1;
1030         }
1031         return string(_baseBytes);
1032     }
1033 
1034     /**
1035      * @notice Changes the string into bytes32
1036      * @param _source String that need to convert into bytes32
1037      */
1038     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1039     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
1040         return bytesToBytes32(bytes(_source), 0);
1041     }
1042 
1043     /**
1044      * @notice Changes bytes into bytes32
1045      * @param _b Bytes that need to convert into bytes32
1046      * @param _offset Offset from which to begin conversion
1047      */
1048     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
1049     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
1050         bytes32 result;
1051 
1052         for (uint i = 0; i < _b.length; i++) {
1053             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
1054         }
1055         return result;
1056     }
1057 
1058     /**
1059      * @notice Changes the bytes32 into string
1060      * @param _source that need to convert into string
1061      */
1062     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
1063         bytes memory bytesString = new bytes(32);
1064         uint charCount = 0;
1065         for (uint j = 0; j < 32; j++) {
1066             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
1067             if (char != 0) {
1068                 bytesString[charCount] = char;
1069                 charCount++;
1070             }
1071         }
1072         bytes memory bytesStringTrimmed = new bytes(charCount);
1073         for (j = 0; j < charCount; j++) {
1074             bytesStringTrimmed[j] = bytesString[j];
1075         }
1076         return string(bytesStringTrimmed);
1077     }
1078 
1079     /**
1080      * @notice Gets function signature from _data
1081      * @param _data Passed data
1082      * @return bytes4 sig
1083      */
1084     function getSig(bytes _data) internal pure returns (bytes4 sig) {
1085         uint len = _data.length < 4 ? _data.length : 4;
1086         for (uint i = 0; i < len; i++) {
1087             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
1088         }
1089     }
1090 
1091 
1092 }
1093 
1094 /**
1095  * @title Factory for deploying CountTransferManager module
1096  */
1097 contract CountTransferManagerFactory is ModuleFactory {
1098 
1099     /**
1100      * @notice Constructor
1101      * @param _polyAddress Address of the polytoken
1102      */
1103     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1104     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1105     {
1106         version = "2.1.0";
1107         name = "CountTransferManager";
1108         title = "Count Transfer Manager";
1109         description = "Restrict the number of investors";
1110         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1111         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1112     }
1113 
1114     /**
1115      * @notice Used to launch the Module with the help of factory
1116      * @param _data Data used for the intialization of the module factory variables
1117      * @return address Contract address of the Module
1118      */
1119     function deploy(bytes _data) external returns(address) {
1120         if(setupCost > 0)
1121             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom due to insufficent Allowance provided");
1122         CountTransferManager countTransferManager = new CountTransferManager(msg.sender, address(polyToken));
1123         require(Util.getSig(_data) == countTransferManager.getInitFunction(), "Provided data is not valid");
1124         /*solium-disable-next-line security/no-low-level-calls*/
1125         require(address(countTransferManager).call(_data), "Unsuccessful call");
1126         /*solium-disable-next-line security/no-block-members*/
1127         emit GenerateModuleFromFactory(address(countTransferManager), getName(), address(this), msg.sender, setupCost, now);
1128         return address(countTransferManager);
1129 
1130     }
1131 
1132     /**
1133      * @notice Type of the Module factory
1134      */
1135     function getTypes() external view returns(uint8[]) {
1136         uint8[] memory res = new uint8[](1);
1137         res[0] = 2;
1138         return res;
1139     }
1140 
1141     /**
1142      * @notice Returns the instructions associated with the module
1143      */
1144     function getInstructions() external view returns(string) {
1145         return "Allows an issuer to restrict the total number of non-zero token holders";
1146     }
1147 
1148     /**
1149      * @notice Get the tags related to the module factory
1150      */
1151     function getTags() external view returns(bytes32[]) {
1152         bytes32[] memory availableTags = new bytes32[](2);
1153         availableTags[0] = "Count";
1154         availableTags[1] = "Transfer Restriction";
1155         return availableTags;
1156     }
1157 }