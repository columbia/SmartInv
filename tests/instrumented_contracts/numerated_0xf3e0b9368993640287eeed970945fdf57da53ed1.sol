1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 library Math {
8   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
9     return a >= b ? a : b;
10   }
11 
12   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
13     return a < b ? a : b;
14   }
15 
16   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
17     return a >= b ? a : b;
18   }
19 
20   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
21     return a < b ? a : b;
22   }
23 }
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 interface IERC20 {
30     function decimals() external view returns (uint8);
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address _owner) external view returns (uint256);
33     function allowance(address _owner, address _spender) external view returns (uint256);
34     function transfer(address _to, uint256 _value) external returns (bool);
35     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
36     function approve(address _spender, uint256 _value) external returns (bool);
37     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
38     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 /**
44  * @title Interface that every module contract should implement
45  */
46 interface IModule {
47 
48     /**
49      * @notice This function returns the signature of configure function
50      */
51     function getInitFunction() external pure returns (bytes4);
52 
53     /**
54      * @notice Return the permission flags that are associated with a module
55      */
56     function getPermissions() external view returns(bytes32[]);
57 
58     /**
59      * @notice Used to withdraw the fee by the factory owner
60      */
61     function takeFee(uint256 _amount) external returns(bool);
62 
63 }
64 
65 /**
66  * @title Interface that every module factory contract should implement
67  */
68 interface IModuleFactory {
69 
70     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
71     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
72     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
73     event GenerateModuleFromFactory(
74         address _module,
75         bytes32 indexed _moduleName,
76         address indexed _moduleFactory,
77         address _creator,
78         uint256 _setupCost,
79         uint256 _timestamp
80     );
81     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
82 
83     //Should create an instance of the Module, or throw
84     function deploy(bytes _data) external returns(address);
85 
86     /**
87      * @notice Type of the Module factory
88      */
89     function getTypes() external view returns(uint8[]);
90 
91     /**
92      * @notice Get the name of the Module
93      */
94     function getName() external view returns(bytes32);
95 
96     /**
97      * @notice Returns the instructions associated with the module
98      */
99     function getInstructions() external view returns (string);
100 
101     /**
102      * @notice Get the tags related to the module factory
103      */
104     function getTags() external view returns (bytes32[]);
105 
106     /**
107      * @notice Used to change the setup fee
108      * @param _newSetupCost New setup fee
109      */
110     function changeFactorySetupFee(uint256 _newSetupCost) external;
111 
112     /**
113      * @notice Used to change the usage fee
114      * @param _newUsageCost New usage fee
115      */
116     function changeFactoryUsageFee(uint256 _newUsageCost) external;
117 
118     /**
119      * @notice Used to change the subscription fee
120      * @param _newSubscriptionCost New subscription fee
121      */
122     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
123 
124     /**
125      * @notice Function use to change the lower and upper bound of the compatible version st
126      * @param _boundType Type of bound
127      * @param _newVersion New version array
128      */
129     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
130 
131    /**
132      * @notice Get the setup cost of the module
133      */
134     function getSetupCost() external view returns (uint256);
135 
136     /**
137      * @notice Used to get the lower bound
138      * @return Lower bound
139      */
140     function getLowerSTVersionBounds() external view returns(uint8[]);
141 
142      /**
143      * @notice Used to get the upper bound
144      * @return Upper bound
145      */
146     function getUpperSTVersionBounds() external view returns(uint8[]);
147 
148 }
149 
150 /**
151  * @title Interface for the Polymath Module Registry contract
152  */
153 interface IModuleRegistry {
154 
155     /**
156      * @notice Called by a security token to notify the registry it is using a module
157      * @param _moduleFactory is the address of the relevant module factory
158      */
159     function useModule(address _moduleFactory) external;
160 
161     /**
162      * @notice Called by the ModuleFactory owner to register new modules for SecurityToken to use
163      * @param _moduleFactory is the address of the module factory to be registered
164      */
165     function registerModule(address _moduleFactory) external;
166 
167     /**
168      * @notice Called by the ModuleFactory owner or registry curator to delete a ModuleFactory
169      * @param _moduleFactory is the address of the module factory to be deleted
170      */
171     function removeModule(address _moduleFactory) external;
172 
173     /**
174     * @notice Called by Polymath to verify modules for SecurityToken to use.
175     * @notice A module can not be used by an ST unless first approved/verified by Polymath
176     * @notice (The only exception to this is that the author of the module is the owner of the ST - Only if enabled by the FeatureRegistry)
177     * @param _moduleFactory is the address of the module factory to be registered
178     */
179     function verifyModule(address _moduleFactory, bool _verified) external;
180 
181     /**
182      * @notice Used to get the reputation of a Module Factory
183      * @param _factoryAddress address of the Module Factory
184      * @return address array which has the list of securityToken's uses that module factory
185      */
186     function getReputationByFactory(address _factoryAddress) external view returns(address[]);
187 
188     /**
189      * @notice Returns all the tags related to the a module type which are valid for the given token
190      * @param _moduleType is the module type
191      * @param _securityToken is the token
192      * @return list of tags
193      * @return corresponding list of module factories
194      */
195     function getTagsByTypeAndToken(uint8 _moduleType, address _securityToken) external view returns(bytes32[], address[]);
196 
197     /**
198      * @notice Returns all the tags related to the a module type which are valid for the given token
199      * @param _moduleType is the module type
200      * @return list of tags
201      * @return corresponding list of module factories
202      */
203     function getTagsByType(uint8 _moduleType) external view returns(bytes32[], address[]);
204 
205     /**
206      * @notice Returns the list of addresses of Module Factory of a particular type
207      * @param _moduleType Type of Module
208      * @return address array that contains the list of addresses of module factory contracts.
209      */
210     function getModulesByType(uint8 _moduleType) external view returns(address[]);
211 
212     /**
213      * @notice Returns the list of available Module factory addresses of a particular type for a given token.
214      * @param _moduleType is the module type to look for
215      * @param _securityToken is the address of SecurityToken
216      * @return address array that contains the list of available addresses of module factory contracts.
217      */
218     function getModulesByTypeAndToken(uint8 _moduleType, address _securityToken) external view returns (address[]);
219 
220     /**
221      * @notice Use to get the latest contract address of the regstries
222      */
223     function updateFromRegistry() external;
224 
225     /**
226      * @notice Get the owner of the contract
227      * @return address owner
228      */
229     function owner() external view returns(address);
230 
231     /**
232      * @notice Check whether the contract operations is paused or not
233      * @return bool 
234      */
235     function isPaused() external view returns(bool);
236 
237 }
238 
239 /**
240  * @title Interface for managing polymath feature switches
241  */
242 interface IFeatureRegistry {
243 
244     /**
245      * @notice Get the status of a feature
246      * @param _nameKey is the key for the feature status mapping
247      * @return bool
248      */
249     function getFeatureStatus(string _nameKey) external view returns(bool);
250 
251 }
252 
253 /**
254  * @title Utility contract to allow pausing and unpausing of certain functions
255  */
256 contract Pausable {
257 
258     event Pause(uint256 _timestammp);
259     event Unpause(uint256 _timestamp);
260 
261     bool public paused = false;
262 
263     /**
264     * @notice Modifier to make a function callable only when the contract is not paused.
265     */
266     modifier whenNotPaused() {
267         require(!paused, "Contract is paused");
268         _;
269     }
270 
271     /**
272     * @notice Modifier to make a function callable only when the contract is paused.
273     */
274     modifier whenPaused() {
275         require(paused, "Contract is not paused");
276         _;
277     }
278 
279    /**
280     * @notice Called by the owner to pause, triggers stopped state
281     */
282     function _pause() internal whenNotPaused {
283         paused = true;
284         /*solium-disable-next-line security/no-block-members*/
285         emit Pause(now);
286     }
287 
288     /**
289     * @notice Called by the owner to unpause, returns to normal state
290     */
291     function _unpause() internal whenPaused {
292         paused = false;
293         /*solium-disable-next-line security/no-block-members*/
294         emit Unpause(now);
295     }
296 
297 }
298 
299 /**
300  * @title Interface for all security tokens
301  */
302 interface ISecurityToken {
303 
304     // Standard ERC20 interface
305     function decimals() external view returns (uint8);
306     function totalSupply() external view returns (uint256);
307     function balanceOf(address _owner) external view returns (uint256);
308     function allowance(address _owner, address _spender) external view returns (uint256);
309     function transfer(address _to, uint256 _value) external returns (bool);
310     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
311     function approve(address _spender, uint256 _value) external returns (bool);
312     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
313     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
314     event Transfer(address indexed from, address indexed to, uint256 value);
315     event Approval(address indexed owner, address indexed spender, uint256 value);
316 
317     //transfer, transferFrom must respect the result of verifyTransfer
318     function verifyTransfer(address _from, address _to, uint256 _value) external returns (bool success);
319 
320     /**
321      * @notice Mints new tokens and assigns them to the target _investor.
322      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
323      * @param _investor Address the tokens will be minted to
324      * @param _value is the amount of tokens that will be minted to the investor
325      */
326     function mint(address _investor, uint256 _value) external returns (bool success);
327 
328     /**
329      * @notice Mints new tokens and assigns them to the target _investor.
330      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
331      * @param _investor Address the tokens will be minted to
332      * @param _value is The amount of tokens that will be minted to the investor
333      * @param _data Data to indicate validation
334      */
335     function mintWithData(address _investor, uint256 _value, bytes _data) external returns (bool success);
336 
337     /**
338      * @notice Used to burn the securityToken on behalf of someone else
339      * @param _from Address for whom to burn tokens
340      * @param _value No. of tokens to be burned
341      * @param _data Data to indicate validation
342      */
343     function burnFromWithData(address _from, uint256 _value, bytes _data) external;
344 
345     /**
346      * @notice Used to burn the securityToken
347      * @param _value No. of tokens to be burned
348      * @param _data Data to indicate validation
349      */
350     function burnWithData(uint256 _value, bytes _data) external;
351 
352     event Minted(address indexed _to, uint256 _value);
353     event Burnt(address indexed _burner, uint256 _value);
354 
355     // Permissions this to a Permission module, which has a key of 1
356     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
357     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
358     function checkPermission(address _delegate, address _module, bytes32 _perm) external view returns (bool);
359 
360     /**
361      * @notice Returns module list for a module type
362      * @param _module Address of the module
363      * @return bytes32 Name
364      * @return address Module address
365      * @return address Module factory address
366      * @return bool Module archived
367      * @return uint8 Module type
368      * @return uint256 Module index
369      * @return uint256 Name index
370 
371      */
372     function getModule(address _module) external view returns(bytes32, address, address, bool, uint8, uint256, uint256);
373 
374     /**
375      * @notice Returns module list for a module name
376      * @param _name Name of the module
377      * @return address[] List of modules with this name
378      */
379     function getModulesByName(bytes32 _name) external view returns (address[]);
380 
381     /**
382      * @notice Returns module list for a module type
383      * @param _type Type of the module
384      * @return address[] List of modules with this type
385      */
386     function getModulesByType(uint8 _type) external view returns (address[]);
387 
388     /**
389      * @notice Queries totalSupply at a specified checkpoint
390      * @param _checkpointId Checkpoint ID to query as of
391      */
392     function totalSupplyAt(uint256 _checkpointId) external view returns (uint256);
393 
394     /**
395      * @notice Queries balance at a specified checkpoint
396      * @param _investor Investor to query balance for
397      * @param _checkpointId Checkpoint ID to query as of
398      */
399     function balanceOfAt(address _investor, uint256 _checkpointId) external view returns (uint256);
400 
401     /**
402      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
403      */
404     function createCheckpoint() external returns (uint256);
405 
406     /**
407      * @notice Gets length of investors array
408      * NB - this length may differ from investorCount if the list has not been pruned of zero-balance investors
409      * @return Length
410      */
411     function getInvestors() external view returns (address[]);
412 
413     /**
414      * @notice returns an array of investors at a given checkpoint
415      * NB - this length may differ from investorCount as it contains all investors that ever held tokens
416      * @param _checkpointId Checkpoint id at which investor list is to be populated
417      * @return list of investors
418      */
419     function getInvestorsAt(uint256 _checkpointId) external view returns(address[]);
420 
421     /**
422      * @notice generates subset of investors
423      * NB - can be used in batches if investor list is large
424      * @param _start Position of investor to start iteration from
425      * @param _end Position of investor to stop iteration at
426      * @return list of investors
427      */
428     function iterateInvestors(uint256 _start, uint256 _end) external view returns(address[]);
429     
430     /**
431      * @notice Gets current checkpoint ID
432      * @return Id
433      */
434     function currentCheckpointId() external view returns (uint256);
435 
436     /**
437     * @notice Gets an investor at a particular index
438     * @param _index Index to return address from
439     * @return Investor address
440     */
441     function investors(uint256 _index) external view returns (address);
442 
443    /**
444     * @notice Allows the owner to withdraw unspent POLY stored by them on the ST or any ERC20 token.
445     * @dev Owner can transfer POLY to the ST which will be used to pay for modules that require a POLY fee.
446     * @param _tokenContract Address of the ERC20Basic compliance token
447     * @param _value Amount of POLY to withdraw
448     */
449     function withdrawERC20(address _tokenContract, uint256 _value) external;
450 
451     /**
452     * @notice Allows owner to approve more POLY to one of the modules
453     * @param _module Module address
454     * @param _budget New budget
455     */
456     function changeModuleBudget(address _module, uint256 _budget) external;
457 
458     /**
459      * @notice Changes the tokenDetails
460      * @param _newTokenDetails New token details
461      */
462     function updateTokenDetails(string _newTokenDetails) external;
463 
464     /**
465     * @notice Allows the owner to change token granularity
466     * @param _granularity Granularity level of the token
467     */
468     function changeGranularity(uint256 _granularity) external;
469 
470     /**
471     * @notice Removes addresses with zero balances from the investors list
472     * @param _start Index in investors list at which to start removing zero balances
473     * @param _iters Max number of iterations of the for loop
474     * NB - pruning this list will mean you may not be able to iterate over investors on-chain as of a historical checkpoint
475     */
476     function pruneInvestors(uint256 _start, uint256 _iters) external;
477 
478     /**
479      * @notice Freezes all the transfers
480      */
481     function freezeTransfers() external;
482 
483     /**
484      * @notice Un-freezes all the transfers
485      */
486     function unfreezeTransfers() external;
487 
488     /**
489      * @notice Ends token minting period permanently
490      */
491     function freezeMinting() external;
492 
493     /**
494      * @notice Mints new tokens and assigns them to the target investors.
495      * Can only be called by the STO attached to the token or by the Issuer (Security Token contract owner)
496      * @param _investors A list of addresses to whom the minted tokens will be delivered
497      * @param _values A list of the amount of tokens to mint to corresponding addresses from _investor[] list
498      * @return Success
499      */
500     function mintMulti(address[] _investors, uint256[] _values) external returns (bool success);
501 
502     /**
503      * @notice Function used to attach a module to the security token
504      * @dev  E.G.: On deployment (through the STR) ST gets a TransferManager module attached to it
505      * @dev to control restrictions on transfers.
506      * @dev You are allowed to add a new moduleType if:
507      * @dev - there is no existing module of that type yet added
508      * @dev - the last member of the module list is replacable
509      * @param _moduleFactory is the address of the module factory to be added
510      * @param _data is data packed into bytes used to further configure the module (See STO usage)
511      * @param _maxCost max amount of POLY willing to pay to module. (WIP)
512      */
513     function addModule(
514         address _moduleFactory,
515         bytes _data,
516         uint256 _maxCost,
517         uint256 _budget
518     ) external;
519 
520     /**
521     * @notice Archives a module attached to the SecurityToken
522     * @param _module address of module to archive
523     */
524     function archiveModule(address _module) external;
525 
526     /**
527     * @notice Unarchives a module attached to the SecurityToken
528     * @param _module address of module to unarchive
529     */
530     function unarchiveModule(address _module) external;
531 
532     /**
533     * @notice Removes a module attached to the SecurityToken
534     * @param _module address of module to archive
535     */
536     function removeModule(address _module) external;
537 
538     /**
539      * @notice Used by the issuer to set the controller addresses
540      * @param _controller address of the controller
541      */
542     function setController(address _controller) external;
543 
544     /**
545      * @notice Used by a controller to execute a forced transfer
546      * @param _from address from which to take tokens
547      * @param _to address where to send tokens
548      * @param _value amount of tokens to transfer
549      * @param _data data to indicate validation
550      * @param _log data attached to the transfer by controller to emit in event
551      */
552     function forceTransfer(address _from, address _to, uint256 _value, bytes _data, bytes _log) external;
553 
554     /**
555      * @notice Used by a controller to execute a foced burn
556      * @param _from address from which to take tokens
557      * @param _value amount of tokens to transfer
558      * @param _data data to indicate validation
559      * @param _log data attached to the transfer by controller to emit in event
560      */
561     function forceBurn(address _from, uint256 _value, bytes _data, bytes _log) external;
562 
563     /**
564      * @notice Used by the issuer to permanently disable controller functionality
565      * @dev enabled via feature switch "disableControllerAllowed"
566      */
567      function disableController() external;
568 
569      /**
570      * @notice Used to get the version of the securityToken
571      */
572      function getVersion() external view returns(uint8[]);
573 
574      /**
575      * @notice Gets the investor count
576      */
577      function getInvestorCount() external view returns(uint256);
578 
579      /**
580       * @notice Overloaded version of the transfer function
581       * @param _to receiver of transfer
582       * @param _value value of transfer
583       * @param _data data to indicate validation
584       * @return bool success
585       */
586      function transferWithData(address _to, uint256 _value, bytes _data) external returns (bool success);
587 
588      /**
589       * @notice Overloaded version of the transferFrom function
590       * @param _from sender of transfer
591       * @param _to receiver of transfer
592       * @param _value value of transfer
593       * @param _data data to indicate validation
594       * @return bool success
595       */
596      function transferFromWithData(address _from, address _to, uint256 _value, bytes _data) external returns(bool);
597 
598      /**
599       * @notice Provides the granularity of the token
600       * @return uint256
601       */
602      function granularity() external view returns(uint256);
603 }
604 
605 /**
606  * @title Ownable
607  * @dev The Ownable contract has an owner address, and provides basic authorization control
608  * functions, this simplifies the implementation of "user permissions".
609  */
610 contract Ownable {
611   address public owner;
612 
613 
614   event OwnershipRenounced(address indexed previousOwner);
615   event OwnershipTransferred(
616     address indexed previousOwner,
617     address indexed newOwner
618   );
619 
620 
621   /**
622    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
623    * account.
624    */
625   constructor() public {
626     owner = msg.sender;
627   }
628 
629   /**
630    * @dev Throws if called by any account other than the owner.
631    */
632   modifier onlyOwner() {
633     require(msg.sender == owner);
634     _;
635   }
636 
637   /**
638    * @dev Allows the current owner to relinquish control of the contract.
639    */
640   function renounceOwnership() public onlyOwner {
641     emit OwnershipRenounced(owner);
642     owner = address(0);
643   }
644 
645   /**
646    * @dev Allows the current owner to transfer control of the contract to a newOwner.
647    * @param _newOwner The address to transfer ownership to.
648    */
649   function transferOwnership(address _newOwner) public onlyOwner {
650     _transferOwnership(_newOwner);
651   }
652 
653   /**
654    * @dev Transfers control of the contract to a newOwner.
655    * @param _newOwner The address to transfer ownership to.
656    */
657   function _transferOwnership(address _newOwner) internal {
658     require(_newOwner != address(0));
659     emit OwnershipTransferred(owner, _newOwner);
660     owner = _newOwner;
661   }
662 }
663 
664 /**
665  * @title Interface that any module contract should implement
666  * @notice Contract is abstract
667  */
668 contract Module is IModule {
669 
670     address public factory;
671 
672     address public securityToken;
673 
674     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
675 
676     IERC20 public polyToken;
677 
678     /**
679      * @notice Constructor
680      * @param _securityToken Address of the security token
681      * @param _polyAddress Address of the polytoken
682      */
683     constructor (address _securityToken, address _polyAddress) public {
684         securityToken = _securityToken;
685         factory = msg.sender;
686         polyToken = IERC20(_polyAddress);
687     }
688 
689     //Allows owner, factory or permissioned delegate
690     modifier withPerm(bytes32 _perm) {
691         bool isOwner = msg.sender == Ownable(securityToken).owner();
692         bool isFactory = msg.sender == factory;
693         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
694         _;
695     }
696 
697     modifier onlyOwner {
698         require(msg.sender == Ownable(securityToken).owner(), "Sender is not owner");
699         _;
700     }
701 
702     modifier onlyFactory {
703         require(msg.sender == factory, "Sender is not factory");
704         _;
705     }
706 
707     modifier onlyFactoryOwner {
708         require(msg.sender == Ownable(factory).owner(), "Sender is not factory owner");
709         _;
710     }
711 
712     modifier onlyFactoryOrOwner {
713         require((msg.sender == Ownable(securityToken).owner()) || (msg.sender == factory), "Sender is not factory or owner");
714         _;
715     }
716 
717     /**
718      * @notice used to withdraw the fee by the factory owner
719      */
720     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
721         require(polyToken.transferFrom(securityToken, Ownable(factory).owner(), _amount), "Unable to take fee");
722         return true;
723     }
724 }
725 
726 /**
727  * @title Interface to be implemented by all Transfer Manager modules
728  * @dev abstract contract
729  */
730 contract ITransferManager is Module, Pausable {
731 
732     //If verifyTransfer returns:
733     //  FORCE_VALID, the transaction will always be valid, regardless of other TM results
734     //  INVALID, then the transfer should not be allowed regardless of other TM results
735     //  VALID, then the transfer is valid for this TM
736     //  NA, then the result from this TM is ignored
737     enum Result {INVALID, NA, VALID, FORCE_VALID}
738 
739     function verifyTransfer(address _from, address _to, uint256 _amount, bytes _data, bool _isTransfer) public returns(Result);
740 
741     function unpause() public onlyOwner {
742         super._unpause();
743     }
744 
745     function pause() public onlyOwner {
746         super._pause();
747     }
748 }
749 
750 /**
751  * @title Utility contract to allow owner to retreive any ERC20 sent to the contract
752  */
753 contract ReclaimTokens is Ownable {
754 
755     /**
756     * @notice Reclaim all ERC20Basic compatible tokens
757     * @param _tokenContract The address of the token contract
758     */
759     function reclaimERC20(address _tokenContract) external onlyOwner {
760         require(_tokenContract != address(0), "Invalid address");
761         IERC20 token = IERC20(_tokenContract);
762         uint256 balance = token.balanceOf(address(this));
763         require(token.transfer(owner, balance), "Transfer failed");
764     }
765 }
766 
767 /**
768  * @title Core functionality for registry upgradability
769  */
770 contract PolymathRegistry is ReclaimTokens {
771 
772     mapping (bytes32 => address) public storedAddresses;
773 
774     event ChangeAddress(string _nameKey, address indexed _oldAddress, address indexed _newAddress);
775 
776     /**
777      * @notice Gets the contract address
778      * @param _nameKey is the key for the contract address mapping
779      * @return address
780      */
781     function getAddress(string _nameKey) external view returns(address) {
782         bytes32 key = keccak256(bytes(_nameKey));
783         require(storedAddresses[key] != address(0), "Invalid address key");
784         return storedAddresses[key];
785     }
786 
787     /**
788      * @notice Changes the contract address
789      * @param _nameKey is the key for the contract address mapping
790      * @param _newAddress is the new contract address
791      */
792     function changeAddress(string _nameKey, address _newAddress) external onlyOwner {
793         bytes32 key = keccak256(bytes(_nameKey));
794         emit ChangeAddress(_nameKey, storedAddresses[key], _newAddress);
795         storedAddresses[key] = _newAddress;
796     }
797 
798 
799 }
800 
801 contract RegistryUpdater is Ownable {
802 
803     address public polymathRegistry;
804     address public moduleRegistry;
805     address public securityTokenRegistry;
806     address public featureRegistry;
807     address public polyToken;
808 
809     constructor (address _polymathRegistry) public {
810         require(_polymathRegistry != address(0), "Invalid address");
811         polymathRegistry = _polymathRegistry;
812     }
813 
814     function updateFromRegistry() public onlyOwner {
815         moduleRegistry = PolymathRegistry(polymathRegistry).getAddress("ModuleRegistry");
816         securityTokenRegistry = PolymathRegistry(polymathRegistry).getAddress("SecurityTokenRegistry");
817         featureRegistry = PolymathRegistry(polymathRegistry).getAddress("FeatureRegistry");
818         polyToken = PolymathRegistry(polymathRegistry).getAddress("PolyToken");
819     }
820 
821 }
822 
823 /**
824  * @title Utility contract for reusable code
825  */
826 library Util {
827 
828    /**
829     * @notice Changes a string to upper case
830     * @param _base String to change
831     */
832     function upper(string _base) internal pure returns (string) {
833         bytes memory _baseBytes = bytes(_base);
834         for (uint i = 0; i < _baseBytes.length; i++) {
835             bytes1 b1 = _baseBytes[i];
836             if (b1 >= 0x61 && b1 <= 0x7A) {
837                 b1 = bytes1(uint8(b1)-32);
838             }
839             _baseBytes[i] = b1;
840         }
841         return string(_baseBytes);
842     }
843 
844     /**
845      * @notice Changes the string into bytes32
846      * @param _source String that need to convert into bytes32
847      */
848     /// Notice - Maximum Length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
849     function stringToBytes32(string memory _source) internal pure returns (bytes32) {
850         return bytesToBytes32(bytes(_source), 0);
851     }
852 
853     /**
854      * @notice Changes bytes into bytes32
855      * @param _b Bytes that need to convert into bytes32
856      * @param _offset Offset from which to begin conversion
857      */
858     /// Notice - Maximum length for _source will be 32 chars otherwise returned bytes32 value will have lossy value.
859     function bytesToBytes32(bytes _b, uint _offset) internal pure returns (bytes32) {
860         bytes32 result;
861 
862         for (uint i = 0; i < _b.length; i++) {
863             result |= bytes32(_b[_offset + i] & 0xFF) >> (i * 8);
864         }
865         return result;
866     }
867 
868     /**
869      * @notice Changes the bytes32 into string
870      * @param _source that need to convert into string
871      */
872     function bytes32ToString(bytes32 _source) internal pure returns (string result) {
873         bytes memory bytesString = new bytes(32);
874         uint charCount = 0;
875         for (uint j = 0; j < 32; j++) {
876             byte char = byte(bytes32(uint(_source) * 2 ** (8 * j)));
877             if (char != 0) {
878                 bytesString[charCount] = char;
879                 charCount++;
880             }
881         }
882         bytes memory bytesStringTrimmed = new bytes(charCount);
883         for (j = 0; j < charCount; j++) {
884             bytesStringTrimmed[j] = bytesString[j];
885         }
886         return string(bytesStringTrimmed);
887     }
888 
889     /**
890      * @notice Gets function signature from _data
891      * @param _data Passed data
892      * @return bytes4 sig
893      */
894     function getSig(bytes _data) internal pure returns (bytes4 sig) {
895         uint len = _data.length < 4 ? _data.length : 4;
896         for (uint i = 0; i < len; i++) {
897             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
898         }
899     }
900 
901 
902 }
903 
904 /**
905  * @title Helps contracts guard agains reentrancy attacks.
906  * @author Remco Bloemen <remco@2π.com>
907  * @notice If you mark a function `nonReentrant`, you should also
908  * mark it `external`.
909  */
910 contract ReentrancyGuard {
911 
912   /**
913    * @dev We use a single lock for the whole contract.
914    */
915   bool private reentrancyLock = false;
916 
917   /**
918    * @dev Prevents a contract from calling itself, directly or indirectly.
919    * @notice If you mark a function `nonReentrant`, you should also
920    * mark it `external`. Calling one nonReentrant function from
921    * another is not supported. Instead, you can implement a
922    * `private` function doing the actual work, and a `external`
923    * wrapper marked as `nonReentrant`.
924    */
925   modifier nonReentrant() {
926     require(!reentrancyLock);
927     reentrancyLock = true;
928     _;
929     reentrancyLock = false;
930   }
931 
932 }
933 
934 /**
935  * @title ERC20Basic
936  * @dev Simpler version of ERC20 interface
937  * @dev see https://github.com/ethereum/EIPs/issues/179
938  */
939 contract ERC20Basic {
940   function totalSupply() public view returns (uint256);
941   function balanceOf(address who) public view returns (uint256);
942   function transfer(address to, uint256 value) public returns (bool);
943   event Transfer(address indexed from, address indexed to, uint256 value);
944 }
945 
946 /**
947  * @title SafeMath
948  * @dev Math operations with safety checks that throw on error
949  */
950 library SafeMath {
951 
952   /**
953   * @dev Multiplies two numbers, throws on overflow.
954   */
955   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
956     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
957     // benefit is lost if 'b' is also tested.
958     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
959     if (a == 0) {
960       return 0;
961     }
962 
963     c = a * b;
964     assert(c / a == b);
965     return c;
966   }
967 
968   /**
969   * @dev Integer division of two numbers, truncating the quotient.
970   */
971   function div(uint256 a, uint256 b) internal pure returns (uint256) {
972     // assert(b > 0); // Solidity automatically throws when dividing by 0
973     // uint256 c = a / b;
974     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
975     return a / b;
976   }
977 
978   /**
979   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
980   */
981   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
982     assert(b <= a);
983     return a - b;
984   }
985 
986   /**
987   * @dev Adds two numbers, throws on overflow.
988   */
989   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
990     c = a + b;
991     assert(c >= a);
992     return c;
993   }
994 }
995 
996 /**
997  * @title Basic token
998  * @dev Basic version of StandardToken, with no allowances.
999  */
1000 contract BasicToken is ERC20Basic {
1001   using SafeMath for uint256;
1002 
1003   mapping(address => uint256) balances;
1004 
1005   uint256 totalSupply_;
1006 
1007   /**
1008   * @dev total number of tokens in existence
1009   */
1010   function totalSupply() public view returns (uint256) {
1011     return totalSupply_;
1012   }
1013 
1014   /**
1015   * @dev transfer token for a specified address
1016   * @param _to The address to transfer to.
1017   * @param _value The amount to be transferred.
1018   */
1019   function transfer(address _to, uint256 _value) public returns (bool) {
1020     require(_to != address(0));
1021     require(_value <= balances[msg.sender]);
1022 
1023     balances[msg.sender] = balances[msg.sender].sub(_value);
1024     balances[_to] = balances[_to].add(_value);
1025     emit Transfer(msg.sender, _to, _value);
1026     return true;
1027   }
1028 
1029   /**
1030   * @dev Gets the balance of the specified address.
1031   * @param _owner The address to query the the balance of.
1032   * @return An uint256 representing the amount owned by the passed address.
1033   */
1034   function balanceOf(address _owner) public view returns (uint256) {
1035     return balances[_owner];
1036   }
1037 
1038 }
1039 
1040 /**
1041  * @title ERC20 interface
1042  * @dev see https://github.com/ethereum/EIPs/issues/20
1043  */
1044 contract ERC20 is ERC20Basic {
1045   function allowance(address owner, address spender)
1046     public view returns (uint256);
1047 
1048   function transferFrom(address from, address to, uint256 value)
1049     public returns (bool);
1050 
1051   function approve(address spender, uint256 value) public returns (bool);
1052   event Approval(
1053     address indexed owner,
1054     address indexed spender,
1055     uint256 value
1056   );
1057 }
1058 
1059 /**
1060  * @title Standard ERC20 token
1061  *
1062  * @dev Implementation of the basic standard token.
1063  * @dev https://github.com/ethereum/EIPs/issues/20
1064  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1065  */
1066 contract StandardToken is ERC20, BasicToken {
1067 
1068   mapping (address => mapping (address => uint256)) internal allowed;
1069 
1070 
1071   /**
1072    * @dev Transfer tokens from one address to another
1073    * @param _from address The address which you want to send tokens from
1074    * @param _to address The address which you want to transfer to
1075    * @param _value uint256 the amount of tokens to be transferred
1076    */
1077   function transferFrom(
1078     address _from,
1079     address _to,
1080     uint256 _value
1081   )
1082     public
1083     returns (bool)
1084   {
1085     require(_to != address(0));
1086     require(_value <= balances[_from]);
1087     require(_value <= allowed[_from][msg.sender]);
1088 
1089     balances[_from] = balances[_from].sub(_value);
1090     balances[_to] = balances[_to].add(_value);
1091     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1092     emit Transfer(_from, _to, _value);
1093     return true;
1094   }
1095 
1096   /**
1097    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1098    *
1099    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1100    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1101    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1102    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1103    * @param _spender The address which will spend the funds.
1104    * @param _value The amount of tokens to be spent.
1105    */
1106   function approve(address _spender, uint256 _value) public returns (bool) {
1107     allowed[msg.sender][_spender] = _value;
1108     emit Approval(msg.sender, _spender, _value);
1109     return true;
1110   }
1111 
1112   /**
1113    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1114    * @param _owner address The address which owns the funds.
1115    * @param _spender address The address which will spend the funds.
1116    * @return A uint256 specifying the amount of tokens still available for the spender.
1117    */
1118   function allowance(
1119     address _owner,
1120     address _spender
1121    )
1122     public
1123     view
1124     returns (uint256)
1125   {
1126     return allowed[_owner][_spender];
1127   }
1128 
1129   /**
1130    * @dev Increase the amount of tokens that an owner allowed to a spender.
1131    *
1132    * approve should be called when allowed[_spender] == 0. To increment
1133    * allowed value is better to use this function to avoid 2 calls (and wait until
1134    * the first transaction is mined)
1135    * From MonolithDAO Token.sol
1136    * @param _spender The address which will spend the funds.
1137    * @param _addedValue The amount of tokens to increase the allowance by.
1138    */
1139   function increaseApproval(
1140     address _spender,
1141     uint _addedValue
1142   )
1143     public
1144     returns (bool)
1145   {
1146     allowed[msg.sender][_spender] = (
1147       allowed[msg.sender][_spender].add(_addedValue));
1148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1149     return true;
1150   }
1151 
1152   /**
1153    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1154    *
1155    * approve should be called when allowed[_spender] == 0. To decrement
1156    * allowed value is better to use this function to avoid 2 calls (and wait until
1157    * the first transaction is mined)
1158    * From MonolithDAO Token.sol
1159    * @param _spender The address which will spend the funds.
1160    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1161    */
1162   function decreaseApproval(
1163     address _spender,
1164     uint _subtractedValue
1165   )
1166     public
1167     returns (bool)
1168   {
1169     uint oldValue = allowed[msg.sender][_spender];
1170     if (_subtractedValue > oldValue) {
1171       allowed[msg.sender][_spender] = 0;
1172     } else {
1173       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1174     }
1175     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1176     return true;
1177   }
1178 
1179 }
1180 
1181 /**
1182  * @title DetailedERC20 token
1183  * @dev The decimals are only for visualization purposes.
1184  * All the operations are done using the smallest and indivisible token unit,
1185  * just as on Ethereum all the operations are done in wei.
1186  */
1187 contract DetailedERC20 is ERC20 {
1188   string public name;
1189   string public symbol;
1190   uint8 public decimals;
1191 
1192   constructor(string _name, string _symbol, uint8 _decimals) public {
1193     name = _name;
1194     symbol = _symbol;
1195     decimals = _decimals;
1196   }
1197 }
1198 
1199 /**
1200  * @title Interface to be implemented by all permission manager modules
1201  */
1202 interface IPermissionManager {
1203 
1204     /**
1205     * @notice Used to check the permission on delegate corresponds to module contract address
1206     * @param _delegate Ethereum address of the delegate
1207     * @param _module Ethereum contract address of the module
1208     * @param _perm Permission flag
1209     * @return bool
1210     */
1211     function checkPermission(address _delegate, address _module, bytes32 _perm) external view returns(bool);
1212 
1213     /**
1214     * @notice Used to add a delegate
1215     * @param _delegate Ethereum address of the delegate
1216     * @param _details Details about the delegate i.e `Belongs to financial firm`
1217     */
1218     function addDelegate(address _delegate, bytes32 _details) external;
1219 
1220     /**
1221     * @notice Used to delete a delegate
1222     * @param _delegate Ethereum address of the delegate
1223     */
1224     function deleteDelegate(address _delegate) external;
1225 
1226     /**
1227     * @notice Used to check if an address is a delegate or not
1228     * @param _potentialDelegate the address of potential delegate
1229     * @return bool
1230     */
1231     function checkDelegate(address _potentialDelegate) external view returns(bool);
1232 
1233     /**
1234     * @notice Used to provide/change the permission to the delegate corresponds to the module contract
1235     * @param _delegate Ethereum address of the delegate
1236     * @param _module Ethereum contract address of the module
1237     * @param _perm Permission flag
1238     * @param _valid Bool flag use to switch on/off the permission
1239     * @return bool
1240     */
1241     function changePermission(
1242         address _delegate,
1243         address _module,
1244         bytes32 _perm,
1245         bool _valid
1246     )
1247     external;
1248 
1249     /**
1250     * @notice Used to change one or more permissions for a single delegate at once
1251     * @param _delegate Ethereum address of the delegate
1252     * @param _modules Multiple module matching the multiperms, needs to be same length
1253     * @param _perms Multiple permission flag needs to be changed
1254     * @param _valids Bool array consist the flag to switch on/off the permission
1255     * @return nothing
1256     */
1257     function changePermissionMulti(
1258         address _delegate,
1259         address[] _modules,
1260         bytes32[] _perms,
1261         bool[] _valids
1262     )
1263     external;
1264 
1265     /**
1266     * @notice Used to return all delegates with a given permission and module
1267     * @param _module Ethereum contract address of the module
1268     * @param _perm Permission flag
1269     * @return address[]
1270     */
1271     function getAllDelegatesWithPerm(address _module, bytes32 _perm) external view returns(address[]);
1272 
1273      /**
1274     * @notice Used to return all permission of a single or multiple module
1275     * @dev possible that function get out of gas is there are lot of modules and perm related to them
1276     * @param _delegate Ethereum address of the delegate
1277     * @param _types uint8[] of types
1278     * @return address[] the address array of Modules this delegate has permission
1279     * @return bytes32[] the permission array of the corresponding Modules
1280     */
1281     function getAllModulesAndPermsFromTypes(address _delegate, uint8[] _types) external view returns(address[], bytes32[]);
1282 
1283     /**
1284     * @notice Used to get the Permission flag related the `this` contract
1285     * @return Array of permission flags
1286     */
1287     function getPermissions() external view returns(bytes32[]);
1288 
1289     /**
1290     * @notice Used to get all delegates
1291     * @return address[]
1292     */
1293     function getAllDelegates() external view returns(address[]);
1294 
1295 }
1296 
1297 library TokenLib {
1298 
1299     using SafeMath for uint256;
1300 
1301     // Struct for module data
1302     struct ModuleData {
1303         bytes32 name;
1304         address module;
1305         address moduleFactory;
1306         bool isArchived;
1307         uint8[] moduleTypes;
1308         uint256[] moduleIndexes;
1309         uint256 nameIndex;
1310     }
1311 
1312     // Structures to maintain checkpoints of balances for governance / dividends
1313     struct Checkpoint {
1314         uint256 checkpointId;
1315         uint256 value;
1316     }
1317 
1318     struct InvestorDataStorage {
1319         // List of investors who have ever held a non-zero token balance
1320         mapping (address => bool) investorListed;
1321         // List of token holders
1322         address[] investors;
1323         // Total number of non-zero token holders
1324         uint256 investorCount;
1325     }
1326 
1327     // Emit when Module is archived from the SecurityToken
1328     event ModuleArchived(uint8[] _types, address _module, uint256 _timestamp);
1329     // Emit when Module is unarchived from the SecurityToken
1330     event ModuleUnarchived(uint8[] _types, address _module, uint256 _timestamp);
1331 
1332     /**
1333     * @notice Archives a module attached to the SecurityToken
1334     * @param _moduleData Storage data
1335     * @param _module Address of module to archive
1336     */
1337     function archiveModule(ModuleData storage _moduleData, address _module) public {
1338         require(!_moduleData.isArchived, "Module archived");
1339         require(_moduleData.module != address(0), "Module missing");
1340         /*solium-disable-next-line security/no-block-members*/
1341         emit ModuleArchived(_moduleData.moduleTypes, _module, now);
1342         _moduleData.isArchived = true;
1343     }
1344 
1345     /**
1346     * @notice Unarchives a module attached to the SecurityToken
1347     * @param _moduleData Storage data
1348     * @param _module Address of module to unarchive
1349     */
1350     function unarchiveModule(ModuleData storage _moduleData, address _module) public {
1351         require(_moduleData.isArchived, "Module unarchived");
1352         /*solium-disable-next-line security/no-block-members*/
1353         emit ModuleUnarchived(_moduleData.moduleTypes, _module, now);
1354         _moduleData.isArchived = false;
1355     }
1356 
1357     /**
1358      * @notice Validates permissions with PermissionManager if it exists. If there's no permission return false
1359      * @dev Note that IModule withPerm will allow ST owner all permissions by default
1360      * @dev this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
1361      * @param _modules is the modules to check permissions on
1362      * @param _delegate is the address of the delegate
1363      * @param _module is the address of the PermissionManager module
1364      * @param _perm is the permissions data
1365      * @return success
1366      */
1367     function checkPermission(address[] storage _modules, address _delegate, address _module, bytes32 _perm) public view returns(bool) {
1368         if (_modules.length == 0) {
1369             return false;
1370         }
1371 
1372         for (uint8 i = 0; i < _modules.length; i++) {
1373             if (IPermissionManager(_modules[i]).checkPermission(_delegate, _module, _perm)) {
1374                 return true;
1375             }
1376         }
1377 
1378         return false;
1379     }
1380 
1381     /**
1382      * @notice Queries a value at a defined checkpoint
1383      * @param _checkpoints is array of Checkpoint objects
1384      * @param _checkpointId is the Checkpoint ID to query
1385      * @param _currentValue is the Current value of checkpoint
1386      * @return uint256
1387      */
1388     function getValueAt(Checkpoint[] storage _checkpoints, uint256 _checkpointId, uint256 _currentValue) public view returns(uint256) {
1389         //Checkpoint id 0 is when the token is first created - everyone has a zero balance
1390         if (_checkpointId == 0) {
1391             return 0;
1392         }
1393         if (_checkpoints.length == 0) {
1394             return _currentValue;
1395         }
1396         if (_checkpoints[0].checkpointId >= _checkpointId) {
1397             return _checkpoints[0].value;
1398         }
1399         if (_checkpoints[_checkpoints.length - 1].checkpointId < _checkpointId) {
1400             return _currentValue;
1401         }
1402         if (_checkpoints[_checkpoints.length - 1].checkpointId == _checkpointId) {
1403             return _checkpoints[_checkpoints.length - 1].value;
1404         }
1405         uint256 min = 0;
1406         uint256 max = _checkpoints.length - 1;
1407         while (max > min) {
1408             uint256 mid = (max + min) / 2;
1409             if (_checkpoints[mid].checkpointId == _checkpointId) {
1410                 max = mid;
1411                 break;
1412             }
1413             if (_checkpoints[mid].checkpointId < _checkpointId) {
1414                 min = mid + 1;
1415             } else {
1416                 max = mid;
1417             }
1418         }
1419         return _checkpoints[max].value;
1420     }
1421 
1422     /**
1423      * @notice Stores the changes to the checkpoint objects
1424      * @param _checkpoints is the affected checkpoint object array
1425      * @param _newValue is the new value that needs to be stored
1426      */
1427     function adjustCheckpoints(TokenLib.Checkpoint[] storage _checkpoints, uint256 _newValue, uint256 _currentCheckpointId) public {
1428         //No checkpoints set yet
1429         if (_currentCheckpointId == 0) {
1430             return;
1431         }
1432         //No new checkpoints since last update
1433         if ((_checkpoints.length > 0) && (_checkpoints[_checkpoints.length - 1].checkpointId == _currentCheckpointId)) {
1434             return;
1435         }
1436         //New checkpoint, so record balance
1437         _checkpoints.push(
1438             TokenLib.Checkpoint({
1439                 checkpointId: _currentCheckpointId,
1440                 value: _newValue
1441             })
1442         );
1443     }
1444 
1445     /**
1446     * @notice Keeps track of the number of non-zero token holders
1447     * @param _investorData Date releated to investor metrics
1448     * @param _from Sender of transfer
1449     * @param _to Receiver of transfer
1450     * @param _value Value of transfer
1451     * @param _balanceTo Balance of the _to address
1452     * @param _balanceFrom Balance of the _from address
1453     */
1454     function adjustInvestorCount(
1455         InvestorDataStorage storage _investorData,
1456         address _from,
1457         address _to,
1458         uint256 _value,
1459         uint256 _balanceTo,
1460         uint256 _balanceFrom
1461         ) public  {
1462         if ((_value == 0) || (_from == _to)) {
1463             return;
1464         }
1465         // Check whether receiver is a new token holder
1466         if ((_balanceTo == 0) && (_to != address(0))) {
1467             _investorData.investorCount = (_investorData.investorCount).add(1);
1468         }
1469         // Check whether sender is moving all of their tokens
1470         if (_value == _balanceFrom) {
1471             _investorData.investorCount = (_investorData.investorCount).sub(1);
1472         }
1473         //Also adjust investor list
1474         if (!_investorData.investorListed[_to] && (_to != address(0))) {
1475             _investorData.investors.push(_to);
1476             _investorData.investorListed[_to] = true;
1477         }
1478 
1479     }
1480 
1481 }
1482 
1483 /**
1484 * @title Security Token contract
1485 * @notice SecurityToken is an ERC20 token with added capabilities:
1486 * @notice - Implements the ST-20 Interface
1487 * @notice - Transfers are restricted
1488 * @notice - Modules can be attached to it to control its behaviour
1489 * @notice - ST should not be deployed directly, but rather the SecurityTokenRegistry should be used
1490 * @notice - ST does not inherit from ISecurityToken due to:
1491 * @notice - https://github.com/ethereum/solidity/issues/4847
1492 */
1493 contract SecurityToken is StandardToken, DetailedERC20, ReentrancyGuard, RegistryUpdater {
1494     using SafeMath for uint256;
1495 
1496     TokenLib.InvestorDataStorage investorData;
1497 
1498     // Used to hold the semantic version data
1499     struct SemanticVersion {
1500         uint8 major;
1501         uint8 minor;
1502         uint8 patch;
1503     }
1504 
1505     SemanticVersion securityTokenVersion;
1506 
1507     // off-chain data
1508     string public tokenDetails;
1509 
1510     uint8 constant PERMISSION_KEY = 1;
1511     uint8 constant TRANSFER_KEY = 2;
1512     uint8 constant MINT_KEY = 3;
1513     uint8 constant CHECKPOINT_KEY = 4;
1514     uint8 constant BURN_KEY = 5;
1515 
1516     uint256 public granularity;
1517 
1518     // Value of current checkpoint
1519     uint256 public currentCheckpointId;
1520 
1521     // Used to temporarily halt all transactions
1522     bool public transfersFrozen;
1523 
1524     // Used to permanently halt all minting
1525     bool public mintingFrozen;
1526 
1527     // Used to permanently halt controller actions
1528     bool public controllerDisabled;
1529 
1530     // Address whitelisted by issuer as controller
1531     address public controller;
1532 
1533     // Records added modules - module list should be order agnostic!
1534     mapping (uint8 => address[]) modules;
1535 
1536     // Records information about the module
1537     mapping (address => TokenLib.ModuleData) modulesToData;
1538 
1539     // Records added module names - module list should be order agnostic!
1540     mapping (bytes32 => address[]) names;
1541 
1542     // Map each investor to a series of checkpoints
1543     mapping (address => TokenLib.Checkpoint[]) checkpointBalances;
1544 
1545     // List of checkpoints that relate to total supply
1546     TokenLib.Checkpoint[] checkpointTotalSupply;
1547 
1548     // Times at which each checkpoint was created
1549     uint256[] checkpointTimes;
1550 
1551     // Emit at the time when module get added
1552     event ModuleAdded(
1553         uint8[] _types,
1554         bytes32 _name,
1555         address _moduleFactory,
1556         address _module,
1557         uint256 _moduleCost,
1558         uint256 _budget,
1559         uint256 _timestamp
1560     );
1561 
1562     // Emit when the token details get updated
1563     event UpdateTokenDetails(string _oldDetails, string _newDetails);
1564     // Emit when the granularity get changed
1565     event GranularityChanged(uint256 _oldGranularity, uint256 _newGranularity);
1566     // Emit when Module get archived from the securityToken
1567     event ModuleArchived(uint8[] _types, address _module, uint256 _timestamp);
1568     // Emit when Module get unarchived from the securityToken
1569     event ModuleUnarchived(uint8[] _types, address _module, uint256 _timestamp);
1570     // Emit when Module get removed from the securityToken
1571     event ModuleRemoved(uint8[] _types, address _module, uint256 _timestamp);
1572     // Emit when the budget allocated to a module is changed
1573     event ModuleBudgetChanged(uint8[] _moduleTypes, address _module, uint256 _oldBudget, uint256 _budget);
1574     // Emit when transfers are frozen or unfrozen
1575     event FreezeTransfers(bool _status, uint256 _timestamp);
1576     // Emit when new checkpoint created
1577     event CheckpointCreated(uint256 indexed _checkpointId, uint256 _timestamp);
1578     // Emit when is permanently frozen by the issuer
1579     event FreezeMinting(uint256 _timestamp);
1580     // Events to log minting and burning
1581     event Minted(address indexed _to, uint256 _value);
1582     event Burnt(address indexed _from, uint256 _value);
1583 
1584     // Events to log controller actions
1585     event SetController(address indexed _oldController, address indexed _newController);
1586     event ForceTransfer(
1587         address indexed _controller,
1588         address indexed _from,
1589         address indexed _to,
1590         uint256 _value,
1591         bool _verifyTransfer,
1592         bytes _data
1593     );
1594     event ForceBurn(
1595         address indexed _controller,
1596         address indexed _from,
1597         uint256 _value,
1598         bool _verifyTransfer,
1599         bytes _data
1600     );
1601     event DisableController(uint256 _timestamp);
1602 
1603     function _isModule(address _module, uint8 _type) internal view returns (bool) {
1604         require(modulesToData[_module].module == _module, "Wrong address");
1605         require(!modulesToData[_module].isArchived, "Module archived");
1606         for (uint256 i = 0; i < modulesToData[_module].moduleTypes.length; i++) {
1607             if (modulesToData[_module].moduleTypes[i] == _type) {
1608                 return true;
1609             }
1610         }
1611         return false;
1612     }
1613 
1614     // Require msg.sender to be the specified module type
1615     modifier onlyModule(uint8 _type) {
1616         require(_isModule(msg.sender, _type));
1617         _;
1618     }
1619 
1620     // Require msg.sender to be the specified module type or the owner of the token
1621     modifier onlyModuleOrOwner(uint8 _type) {
1622         if (msg.sender == owner) {
1623             _;
1624         } else {
1625             require(_isModule(msg.sender, _type));
1626             _;
1627         }
1628     }
1629 
1630     modifier checkGranularity(uint256 _value) {
1631         require(_value % granularity == 0, "Invalid granularity");
1632         _;
1633     }
1634 
1635     modifier isMintingAllowed() {
1636         require(!mintingFrozen, "Minting frozen");
1637         _;
1638     }
1639 
1640     modifier isEnabled(string _nameKey) {
1641         require(IFeatureRegistry(featureRegistry).getFeatureStatus(_nameKey));
1642         _;
1643     }
1644 
1645     /**
1646      * @notice Revert if called by an account which is not a controller
1647      */
1648     modifier onlyController() {
1649         require(msg.sender == controller, "Not controller");
1650         require(!controllerDisabled, "Controller disabled");
1651         _;
1652     }
1653 
1654     /**
1655      * @notice Constructor
1656      * @param _name Name of the SecurityToken
1657      * @param _symbol Symbol of the Token
1658      * @param _decimals Decimals for the securityToken
1659      * @param _granularity granular level of the token
1660      * @param _tokenDetails Details of the token that are stored off-chain
1661      * @param _polymathRegistry Contract address of the polymath registry
1662      */
1663     constructor (
1664         string _name,
1665         string _symbol,
1666         uint8 _decimals,
1667         uint256 _granularity,
1668         string _tokenDetails,
1669         address _polymathRegistry
1670     )
1671     public
1672     DetailedERC20(_name, _symbol, _decimals)
1673     RegistryUpdater(_polymathRegistry)
1674     {
1675         //When it is created, the owner is the STR
1676         updateFromRegistry();
1677         tokenDetails = _tokenDetails;
1678         granularity = _granularity;
1679         securityTokenVersion = SemanticVersion(2,0,0);
1680     }
1681 
1682     /**
1683      * @notice Attachs a module to the SecurityToken
1684      * @dev  E.G.: On deployment (through the STR) ST gets a TransferManager module attached to it
1685      * @dev to control restrictions on transfers.
1686      * @param _moduleFactory is the address of the module factory to be added
1687      * @param _data is data packed into bytes used to further configure the module (See STO usage)
1688      * @param _maxCost max amount of POLY willing to pay to the module.
1689      * @param _budget max amount of ongoing POLY willing to assign to the module.
1690      */
1691     function addModule(
1692         address _moduleFactory,
1693         bytes _data,
1694         uint256 _maxCost,
1695         uint256 _budget
1696     ) external onlyOwner nonReentrant {
1697         //Check that the module factory exists in the ModuleRegistry - will throw otherwise
1698         IModuleRegistry(moduleRegistry).useModule(_moduleFactory);
1699         IModuleFactory moduleFactory = IModuleFactory(_moduleFactory);
1700         uint8[] memory moduleTypes = moduleFactory.getTypes();
1701         uint256 moduleCost = moduleFactory.getSetupCost();
1702         require(moduleCost <= _maxCost, "Invalid cost");
1703         //Approve fee for module
1704         ERC20(polyToken).approve(_moduleFactory, moduleCost);
1705         //Creates instance of module from factory
1706         address module = moduleFactory.deploy(_data);
1707         require(modulesToData[module].module == address(0), "Module exists");
1708         //Approve ongoing budget
1709         ERC20(polyToken).approve(module, _budget);
1710         //Add to SecurityToken module map
1711         bytes32 moduleName = moduleFactory.getName();
1712         uint256[] memory moduleIndexes = new uint256[](moduleTypes.length);
1713         uint256 i;
1714         for (i = 0; i < moduleTypes.length; i++) {
1715             moduleIndexes[i] = modules[moduleTypes[i]].length;
1716             modules[moduleTypes[i]].push(module);
1717         }
1718         modulesToData[module] = TokenLib.ModuleData(
1719             moduleName, module, _moduleFactory, false, moduleTypes, moduleIndexes, names[moduleName].length
1720         );
1721         names[moduleName].push(module);
1722         //Emit log event
1723         /*solium-disable-next-line security/no-block-members*/
1724         emit ModuleAdded(moduleTypes, moduleName, _moduleFactory, module, moduleCost, _budget, now);
1725     }
1726 
1727     /**
1728     * @notice Archives a module attached to the SecurityToken
1729     * @param _module address of module to archive
1730     */
1731     function archiveModule(address _module) external onlyOwner {
1732         TokenLib.archiveModule(modulesToData[_module], _module);
1733     }
1734 
1735     /**
1736     * @notice Unarchives a module attached to the SecurityToken
1737     * @param _module address of module to unarchive
1738     */
1739     function unarchiveModule(address _module) external onlyOwner {
1740         TokenLib.unarchiveModule(modulesToData[_module], _module);
1741     }
1742 
1743     /**
1744     * @notice Removes a module attached to the SecurityToken
1745     * @param _module address of module to unarchive
1746     */
1747     function removeModule(address _module) external onlyOwner {
1748         require(modulesToData[_module].isArchived, "Not archived");
1749         require(modulesToData[_module].module != address(0), "Module missing");
1750         /*solium-disable-next-line security/no-block-members*/
1751         emit ModuleRemoved(modulesToData[_module].moduleTypes, _module, now);
1752         // Remove from module type list
1753         uint8[] memory moduleTypes = modulesToData[_module].moduleTypes;
1754         for (uint256 i = 0; i < moduleTypes.length; i++) {
1755             _removeModuleWithIndex(moduleTypes[i], modulesToData[_module].moduleIndexes[i]);
1756             /* modulesToData[_module].moduleType[moduleTypes[i]] = false; */
1757         }
1758         // Remove from module names list
1759         uint256 index = modulesToData[_module].nameIndex;
1760         bytes32 name = modulesToData[_module].name;
1761         uint256 length = names[name].length;
1762         names[name][index] = names[name][length - 1];
1763         names[name].length = length - 1;
1764         if ((length - 1) != index) {
1765             modulesToData[names[name][index]].nameIndex = index;
1766         }
1767         // Remove from modulesToData
1768         delete modulesToData[_module];
1769     }
1770 
1771     /**
1772     * @notice Internal - Removes a module attached to the SecurityToken by index
1773     */
1774     function _removeModuleWithIndex(uint8 _type, uint256 _index) internal {
1775         uint256 length = modules[_type].length;
1776         modules[_type][_index] = modules[_type][length - 1];
1777         modules[_type].length = length - 1;
1778 
1779         if ((length - 1) != _index) {
1780             //Need to find index of _type in moduleTypes of module we are moving
1781             uint8[] memory newTypes = modulesToData[modules[_type][_index]].moduleTypes;
1782             for (uint256 i = 0; i < newTypes.length; i++) {
1783                 if (newTypes[i] == _type) {
1784                     modulesToData[modules[_type][_index]].moduleIndexes[i] = _index;
1785                 }
1786             }
1787         }
1788     }
1789 
1790     /**
1791      * @notice Returns the data associated to a module
1792      * @param _module address of the module
1793      * @return bytes32 name
1794      * @return address module address
1795      * @return address module factory address
1796      * @return bool module archived
1797      * @return uint8 module type
1798      */
1799     function getModule(address _module) external view returns (bytes32, address, address, bool, uint8[]) {
1800         return (modulesToData[_module].name,
1801         modulesToData[_module].module,
1802         modulesToData[_module].moduleFactory,
1803         modulesToData[_module].isArchived,
1804         modulesToData[_module].moduleTypes);
1805     }
1806 
1807     /**
1808      * @notice Returns a list of modules that match the provided name
1809      * @param _name name of the module
1810      * @return address[] list of modules with this name
1811      */
1812     function getModulesByName(bytes32 _name) external view returns (address[]) {
1813         return names[_name];
1814     }
1815 
1816     /**
1817      * @notice Returns a list of modules that match the provided module type
1818      * @param _type type of the module
1819      * @return address[] list of modules with this type
1820      */
1821     function getModulesByType(uint8 _type) external view returns (address[]) {
1822         return modules[_type];
1823     }
1824 
1825    /**
1826     * @notice Allows the owner to withdraw unspent POLY stored by them on the ST or any ERC20 token.
1827     * @dev Owner can transfer POLY to the ST which will be used to pay for modules that require a POLY fee.
1828     * @param _tokenContract Address of the ERC20Basic compliance token
1829     * @param _value amount of POLY to withdraw
1830     */
1831     function withdrawERC20(address _tokenContract, uint256 _value) external onlyOwner {
1832         require(_tokenContract != address(0));
1833         IERC20 token = IERC20(_tokenContract);
1834         require(token.transfer(owner, _value));
1835     }
1836 
1837     /**
1838 
1839     * @notice allows owner to increase/decrease POLY approval of one of the modules
1840     * @param _module module address
1841     * @param _change change in allowance
1842     * @param _increase true if budget has to be increased, false if decrease
1843     */
1844     function changeModuleBudget(address _module, uint256 _change, bool _increase) external onlyOwner {
1845         require(modulesToData[_module].module != address(0), "Module missing");
1846         uint256 currentAllowance = IERC20(polyToken).allowance(address(this), _module);
1847         uint256 newAllowance;
1848         if (_increase) {
1849             require(IERC20(polyToken).increaseApproval(_module, _change), "IncreaseApproval fail");
1850             newAllowance = currentAllowance.add(_change);
1851         } else {
1852             require(IERC20(polyToken).decreaseApproval(_module, _change), "Insufficient allowance");
1853             newAllowance = currentAllowance.sub(_change);
1854         }
1855         emit ModuleBudgetChanged(modulesToData[_module].moduleTypes, _module, currentAllowance, newAllowance);
1856     }
1857 
1858     /**
1859      * @notice updates the tokenDetails associated with the token
1860      * @param _newTokenDetails New token details
1861      */
1862     function updateTokenDetails(string _newTokenDetails) external onlyOwner {
1863         emit UpdateTokenDetails(tokenDetails, _newTokenDetails);
1864         tokenDetails = _newTokenDetails;
1865     }
1866 
1867     /**
1868     * @notice Allows owner to change token granularity
1869     * @param _granularity granularity level of the token
1870     */
1871     function changeGranularity(uint256 _granularity) external onlyOwner {
1872         require(_granularity != 0, "Invalid granularity");
1873         emit GranularityChanged(granularity, _granularity);
1874         granularity = _granularity;
1875     }
1876 
1877     /**
1878     * @notice Keeps track of the number of non-zero token holders
1879     * @param _from sender of transfer
1880     * @param _to receiver of transfer
1881     * @param _value value of transfer
1882     */
1883     function _adjustInvestorCount(address _from, address _to, uint256 _value) internal {
1884         TokenLib.adjustInvestorCount(investorData, _from, _to, _value, balanceOf(_to), balanceOf(_from));
1885     }
1886 
1887     /**
1888      * @notice returns an array of investors
1889      * NB - this length may differ from investorCount as it contains all investors that ever held tokens
1890      * @return list of addresses
1891      */
1892     function getInvestors() external view returns(address[]) {
1893         return investorData.investors;
1894     }
1895 
1896     /**
1897      * @notice returns an array of investors at a given checkpoint
1898      * NB - this length may differ from investorCount as it contains all investors that ever held tokens
1899      * @param _checkpointId Checkpoint id at which investor list is to be populated
1900      * @return list of investors
1901      */
1902     function getInvestorsAt(uint256 _checkpointId) external view returns(address[]) {
1903         uint256 count = 0;
1904         uint256 i;
1905         for (i = 0; i < investorData.investors.length; i++) {
1906             if (balanceOfAt(investorData.investors[i], _checkpointId) > 0) {
1907                 count++;
1908             }
1909         }
1910         address[] memory investors = new address[](count);
1911         count = 0;
1912         for (i = 0; i < investorData.investors.length; i++) {
1913             if (balanceOfAt(investorData.investors[i], _checkpointId) > 0) {
1914                 investors[count] = investorData.investors[i];
1915                 count++;
1916             }
1917         }
1918         return investors;
1919     }
1920 
1921     /**
1922      * @notice generates subset of investors
1923      * NB - can be used in batches if investor list is large
1924      * @param _start Position of investor to start iteration from
1925      * @param _end Position of investor to stop iteration at
1926      * @return list of investors
1927      */
1928     function iterateInvestors(uint256 _start, uint256 _end) external view returns(address[]) {
1929         require(_end <= investorData.investors.length, "Invalid end");
1930         address[] memory investors = new address[](_end.sub(_start));
1931         uint256 index = 0;
1932         for (uint256 i = _start; i < _end; i++) {
1933             investors[index] = investorData.investors[i];
1934             index++;
1935         }
1936         return investors;
1937     }
1938 
1939     /**
1940      * @notice Returns the investor count
1941      * @return Investor count
1942      */
1943     function getInvestorCount() external view returns(uint256) {
1944         return investorData.investorCount;
1945     }
1946 
1947     /**
1948      * @notice freezes transfers
1949      */
1950     function freezeTransfers() external onlyOwner {
1951         require(!transfersFrozen, "Already frozen");
1952         transfersFrozen = true;
1953         /*solium-disable-next-line security/no-block-members*/
1954         emit FreezeTransfers(true, now);
1955     }
1956 
1957     /**
1958      * @notice Unfreeze transfers
1959      */
1960     function unfreezeTransfers() external onlyOwner {
1961         require(transfersFrozen, "Not frozen");
1962         transfersFrozen = false;
1963         /*solium-disable-next-line security/no-block-members*/
1964         emit FreezeTransfers(false, now);
1965     }
1966 
1967     /**
1968      * @notice Internal - adjusts totalSupply at checkpoint after minting or burning tokens
1969      */
1970     function _adjustTotalSupplyCheckpoints() internal {
1971         TokenLib.adjustCheckpoints(checkpointTotalSupply, totalSupply(), currentCheckpointId);
1972     }
1973 
1974     /**
1975      * @notice Internal - adjusts token holder balance at checkpoint after a token transfer
1976      * @param _investor address of the token holder affected
1977      */
1978     function _adjustBalanceCheckpoints(address _investor) internal {
1979         TokenLib.adjustCheckpoints(checkpointBalances[_investor], balanceOf(_investor), currentCheckpointId);
1980     }
1981 
1982     /**
1983      * @notice Overloaded version of the transfer function
1984      * @param _to receiver of transfer
1985      * @param _value value of transfer
1986      * @return bool success
1987      */
1988     function transfer(address _to, uint256 _value) public returns (bool success) {
1989         return transferWithData(_to, _value, "");
1990     }
1991 
1992     /**
1993      * @notice Overloaded version of the transfer function
1994      * @param _to receiver of transfer
1995      * @param _value value of transfer
1996      * @param _data data to indicate validation
1997      * @return bool success
1998      */
1999     function transferWithData(address _to, uint256 _value, bytes _data) public returns (bool success) {
2000         require(_updateTransfer(msg.sender, _to, _value, _data), "Transfer invalid");
2001         require(super.transfer(_to, _value));
2002         return true;
2003     }
2004 
2005     /**
2006      * @notice Overloaded version of the transferFrom function
2007      * @param _from sender of transfer
2008      * @param _to receiver of transfer
2009      * @param _value value of transfer
2010      * @return bool success
2011      */
2012     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
2013         return transferFromWithData(_from, _to, _value, "");
2014     }
2015 
2016     /**
2017      * @notice Overloaded version of the transferFrom function
2018      * @param _from sender of transfer
2019      * @param _to receiver of transfer
2020      * @param _value value of transfer
2021      * @param _data data to indicate validation
2022      * @return bool success
2023      */
2024     function transferFromWithData(address _from, address _to, uint256 _value, bytes _data) public returns(bool) {
2025         require(_updateTransfer(_from, _to, _value, _data), "Transfer invalid");
2026         require(super.transferFrom(_from, _to, _value));
2027         return true;
2028     }
2029 
2030     /**
2031      * @notice Updates internal variables when performing a transfer
2032      * @param _from sender of transfer
2033      * @param _to receiver of transfer
2034      * @param _value value of transfer
2035      * @param _data data to indicate validation
2036      * @return bool success
2037      */
2038     function _updateTransfer(address _from, address _to, uint256 _value, bytes _data) internal nonReentrant returns(bool) {
2039         // NB - the ordering in this function implies the following:
2040         //  - investor counts are updated before transfer managers are called - i.e. transfer managers will see
2041         //investor counts including the current transfer.
2042         //  - checkpoints are updated after the transfer managers are called. This allows TMs to create
2043         //checkpoints as though they have been created before the current transactions,
2044         //  - to avoid the situation where a transfer manager transfers tokens, and this function is called recursively,
2045         //the function is marked as nonReentrant. This means that no TM can transfer (or mint / burn) tokens.
2046         _adjustInvestorCount(_from, _to, _value);
2047         bool verified = _verifyTransfer(_from, _to, _value, _data, true);
2048         _adjustBalanceCheckpoints(_from);
2049         _adjustBalanceCheckpoints(_to);
2050         return verified;
2051     }
2052 
2053     /**
2054      * @notice Validate transfer with TransferManager module if it exists
2055      * @dev TransferManager module has a key of 2
2056      * @dev _isTransfer boolean flag is the deciding factor for whether the
2057      * state variables gets modified or not within the different modules. i.e isTransfer = true
2058      * leads to change in the modules environment otherwise _verifyTransfer() works as a read-only
2059      * function (no change in the state).
2060      * @param _from sender of transfer
2061      * @param _to receiver of transfer
2062      * @param _value value of transfer
2063      * @param _data data to indicate validation
2064      * @param _isTransfer whether transfer is being executed
2065      * @return bool
2066      */
2067     function _verifyTransfer(
2068         address _from,
2069         address _to,
2070         uint256 _value,
2071         bytes _data,
2072         bool _isTransfer
2073     ) internal checkGranularity(_value) returns (bool) {
2074         if (!transfersFrozen) {
2075             bool isInvalid = false;
2076             bool isValid = false;
2077             bool isForceValid = false;
2078             bool unarchived = false;
2079             address module;
2080             for (uint256 i = 0; i < modules[TRANSFER_KEY].length; i++) {
2081                 module = modules[TRANSFER_KEY][i];
2082                 if (!modulesToData[module].isArchived) {
2083                     unarchived = true;
2084                     ITransferManager.Result valid = ITransferManager(module).verifyTransfer(_from, _to, _value, _data, _isTransfer);
2085                     if (valid == ITransferManager.Result.INVALID) {
2086                         isInvalid = true;
2087                     } else if (valid == ITransferManager.Result.VALID) {
2088                         isValid = true;
2089                     } else if (valid == ITransferManager.Result.FORCE_VALID) {
2090                         isForceValid = true;
2091                     }
2092                 }
2093             }
2094             // If no unarchived modules, return true by default
2095             return unarchived ? (isForceValid ? true : (isInvalid ? false : isValid)) : true;
2096         }
2097         return false;
2098     }
2099 
2100     /**
2101      * @notice Validates a transfer with a TransferManager module if it exists
2102      * @dev TransferManager module has a key of 2
2103      * @param _from sender of transfer
2104      * @param _to receiver of transfer
2105      * @param _value value of transfer
2106      * @param _data data to indicate validation
2107      * @return bool
2108      */
2109     function verifyTransfer(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
2110         return _verifyTransfer(_from, _to, _value, _data, false);
2111     }
2112 
2113     /**
2114      * @notice Permanently freeze minting of this security token.
2115      * @dev It MUST NOT be possible to increase `totalSuppy` after this function is called.
2116      */
2117     function freezeMinting() external isMintingAllowed() isEnabled("freezeMintingAllowed") onlyOwner {
2118         mintingFrozen = true;
2119         /*solium-disable-next-line security/no-block-members*/
2120         emit FreezeMinting(now);
2121     }
2122 
2123     /**
2124      * @notice Mints new tokens and assigns them to the target _investor.
2125      * @dev Can only be called by the issuer or STO attached to the token
2126      * @param _investor Address where the minted tokens will be delivered
2127      * @param _value Number of tokens be minted
2128      * @return success
2129      */
2130     function mint(address _investor, uint256 _value) public returns (bool success) {
2131         return mintWithData(_investor, _value, "");
2132     }
2133 
2134     /**
2135      * @notice mints new tokens and assigns them to the target _investor.
2136      * @dev Can only be called by the issuer or STO attached to the token
2137      * @param _investor Address where the minted tokens will be delivered
2138      * @param _value Number of tokens be minted
2139      * @param _data data to indicate validation
2140      * @return success
2141      */
2142     function mintWithData(
2143         address _investor,
2144         uint256 _value,
2145         bytes _data
2146         ) public onlyModuleOrOwner(MINT_KEY) isMintingAllowed() returns (bool success) {
2147         require(_investor != address(0), "Investor is 0");
2148         require(_updateTransfer(address(0), _investor, _value, _data), "Transfer invalid");
2149         _adjustTotalSupplyCheckpoints();
2150         totalSupply_ = totalSupply_.add(_value);
2151         balances[_investor] = balances[_investor].add(_value);
2152         emit Minted(_investor, _value);
2153         emit Transfer(address(0), _investor, _value);
2154         return true;
2155     }
2156 
2157     /**
2158      * @notice Mints new tokens and assigns them to the target _investor.
2159      * @dev Can only be called by the issuer or STO attached to the token.
2160      * @param _investors A list of addresses to whom the minted tokens will be dilivered
2161      * @param _values A list of number of tokens get minted and transfer to corresponding address of the investor from _investor[] list
2162      * @return success
2163      */
2164     function mintMulti(address[] _investors, uint256[] _values) external returns (bool success) {
2165         require(_investors.length == _values.length, "Incorrect inputs");
2166         for (uint256 i = 0; i < _investors.length; i++) {
2167             mint(_investors[i], _values[i]);
2168         }
2169         return true;
2170     }
2171 
2172     /**
2173      * @notice Validate permissions with PermissionManager if it exists, If no Permission return false
2174      * @dev Note that IModule withPerm will allow ST owner all permissions anyway
2175      * @dev this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
2176      * @param _delegate address of delegate
2177      * @param _module address of PermissionManager module
2178      * @param _perm the permissions
2179      * @return success
2180      */
2181     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool) {
2182         for (uint256 i = 0; i < modules[PERMISSION_KEY].length; i++) {
2183             if (!modulesToData[modules[PERMISSION_KEY][i]].isArchived)
2184                 return TokenLib.checkPermission(modules[PERMISSION_KEY], _delegate, _module, _perm);
2185         }
2186         return false;
2187     }
2188 
2189     function _burn(address _from, uint256 _value, bytes _data) internal returns(bool) {
2190         require(_value <= balances[_from], "Value too high");
2191         bool verified = _updateTransfer(_from, address(0), _value, _data);
2192         _adjustTotalSupplyCheckpoints();
2193         balances[_from] = balances[_from].sub(_value);
2194         totalSupply_ = totalSupply_.sub(_value);
2195         emit Burnt(_from, _value);
2196         emit Transfer(_from, address(0), _value);
2197         return verified;
2198     }
2199 
2200     /**
2201      * @notice Burn function used to burn the securityToken
2202      * @param _value No. of tokens that get burned
2203      * @param _data data to indicate validation
2204      */
2205     function burnWithData(uint256 _value, bytes _data) public onlyModule(BURN_KEY) {
2206         require(_burn(msg.sender, _value, _data), "Burn invalid");
2207     }
2208 
2209     /**
2210      * @notice Burn function used to burn the securityToken on behalf of someone else
2211      * @param _from Address for whom to burn tokens
2212      * @param _value No. of tokens that get burned
2213      * @param _data data to indicate validation
2214      */
2215     function burnFromWithData(address _from, uint256 _value, bytes _data) public onlyModule(BURN_KEY) {
2216         require(_value <= allowed[_from][msg.sender], "Value too high");
2217         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
2218         require(_burn(_from, _value, _data), "Burn invalid");
2219     }
2220 
2221     /**
2222      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
2223      * @return uint256
2224      */
2225     function createCheckpoint() external onlyModuleOrOwner(CHECKPOINT_KEY) returns(uint256) {
2226         require(currentCheckpointId < 2**256 - 1);
2227         currentCheckpointId = currentCheckpointId + 1;
2228         /*solium-disable-next-line security/no-block-members*/
2229         checkpointTimes.push(now);
2230         /*solium-disable-next-line security/no-block-members*/
2231         emit CheckpointCreated(currentCheckpointId, now);
2232         return currentCheckpointId;
2233     }
2234 
2235     /**
2236      * @notice Gets list of times that checkpoints were created
2237      * @return List of checkpoint times
2238      */
2239     function getCheckpointTimes() external view returns(uint256[]) {
2240         return checkpointTimes;
2241     }
2242 
2243     /**
2244      * @notice Queries totalSupply as of a defined checkpoint
2245      * @param _checkpointId Checkpoint ID to query
2246      * @return uint256
2247      */
2248     function totalSupplyAt(uint256 _checkpointId) external view returns(uint256) {
2249         require(_checkpointId <= currentCheckpointId);
2250         return TokenLib.getValueAt(checkpointTotalSupply, _checkpointId, totalSupply());
2251     }
2252 
2253     /**
2254      * @notice Queries balances as of a defined checkpoint
2255      * @param _investor Investor to query balance for
2256      * @param _checkpointId Checkpoint ID to query as of
2257      */
2258     function balanceOfAt(address _investor, uint256 _checkpointId) public view returns(uint256) {
2259         require(_checkpointId <= currentCheckpointId);
2260         return TokenLib.getValueAt(checkpointBalances[_investor], _checkpointId, balanceOf(_investor));
2261     }
2262 
2263     /**
2264      * @notice Used by the issuer to set the controller addresses
2265      * @param _controller address of the controller
2266      */
2267     function setController(address _controller) public onlyOwner {
2268         require(!controllerDisabled);
2269         emit SetController(controller, _controller);
2270         controller = _controller;
2271     }
2272 
2273     /**
2274      * @notice Used by the issuer to permanently disable controller functionality
2275      * @dev enabled via feature switch "disableControllerAllowed"
2276      */
2277     function disableController() external isEnabled("disableControllerAllowed") onlyOwner {
2278         require(!controllerDisabled);
2279         controllerDisabled = true;
2280         delete controller;
2281         /*solium-disable-next-line security/no-block-members*/
2282         emit DisableController(now);
2283     }
2284 
2285     /**
2286      * @notice Used by a controller to execute a forced transfer
2287      * @param _from address from which to take tokens
2288      * @param _to address where to send tokens
2289      * @param _value amount of tokens to transfer
2290      * @param _data data to indicate validation
2291      * @param _log data attached to the transfer by controller to emit in event
2292      */
2293     function forceTransfer(address _from, address _to, uint256 _value, bytes _data, bytes _log) public onlyController {
2294         require(_to != address(0));
2295         require(_value <= balances[_from]);
2296         bool verified = _updateTransfer(_from, _to, _value, _data);
2297         balances[_from] = balances[_from].sub(_value);
2298         balances[_to] = balances[_to].add(_value);
2299         emit ForceTransfer(msg.sender, _from, _to, _value, verified, _log);
2300         emit Transfer(_from, _to, _value);
2301     }
2302 
2303     /**
2304      * @notice Used by a controller to execute a forced burn
2305      * @param _from address from which to take tokens
2306      * @param _value amount of tokens to transfer
2307      * @param _data data to indicate validation
2308      * @param _log data attached to the transfer by controller to emit in event
2309      */
2310     function forceBurn(address _from, uint256 _value, bytes _data, bytes _log) public onlyController {
2311         bool verified = _burn(_from, _value, _data);
2312         emit ForceBurn(msg.sender, _from, _value, verified, _log);
2313     }
2314 
2315     /**
2316      * @notice Returns the version of the SecurityToken
2317      */
2318     function getVersion() external view returns(uint8[]) {
2319         uint8[] memory _version = new uint8[](3);
2320         _version[0] = securityTokenVersion.major;
2321         _version[1] = securityTokenVersion.minor;
2322         _version[2] = securityTokenVersion.patch;
2323         return _version;
2324     }
2325 
2326 }