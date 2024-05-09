1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Interface to be implemented by all permission manager modules
5  */
6 interface IPermissionManager {
7 
8     /**
9     * @notice Used to check the permission on delegate corresponds to module contract address
10     * @param _delegate Ethereum address of the delegate
11     * @param _module Ethereum contract address of the module
12     * @param _perm Permission flag
13     * @return bool
14     */
15     function checkPermission(address _delegate, address _module, bytes32 _perm) external view returns(bool);
16 
17     /**
18     * @notice Used to add a delegate
19     * @param _delegate Ethereum address of the delegate
20     * @param _details Details about the delegate i.e `Belongs to financial firm`
21     */
22     function addDelegate(address _delegate, bytes32 _details) external;
23 
24     /**
25     * @notice Used to delete a delegate
26     * @param _delegate Ethereum address of the delegate
27     */
28     function deleteDelegate(address _delegate) external;
29 
30     /**
31     * @notice Used to check if an address is a delegate or not
32     * @param _potentialDelegate the address of potential delegate
33     * @return bool
34     */
35     function checkDelegate(address _potentialDelegate) external view returns(bool);
36 
37     /**
38     * @notice Used to provide/change the permission to the delegate corresponds to the module contract
39     * @param _delegate Ethereum address of the delegate
40     * @param _module Ethereum contract address of the module
41     * @param _perm Permission flag
42     * @param _valid Bool flag use to switch on/off the permission
43     * @return bool
44     */
45     function changePermission(
46         address _delegate,
47         address _module,
48         bytes32 _perm,
49         bool _valid
50     )
51     external;
52 
53     /**
54     * @notice Used to change one or more permissions for a single delegate at once
55     * @param _delegate Ethereum address of the delegate
56     * @param _modules Multiple module matching the multiperms, needs to be same length
57     * @param _perms Multiple permission flag needs to be changed
58     * @param _valids Bool array consist the flag to switch on/off the permission
59     * @return nothing
60     */
61     function changePermissionMulti(
62         address _delegate,
63         address[] _modules,
64         bytes32[] _perms,
65         bool[] _valids
66     )
67     external;
68 
69     /**
70     * @notice Used to return all delegates with a given permission and module
71     * @param _module Ethereum contract address of the module
72     * @param _perm Permission flag
73     * @return address[]
74     */
75     function getAllDelegatesWithPerm(address _module, bytes32 _perm) external view returns(address[]);
76 
77      /**
78     * @notice Used to return all permission of a single or multiple module
79     * @dev possible that function get out of gas is there are lot of modules and perm related to them
80     * @param _delegate Ethereum address of the delegate
81     * @param _types uint8[] of types
82     * @return address[] the address array of Modules this delegate has permission
83     * @return bytes32[] the permission array of the corresponding Modules
84     */
85     function getAllModulesAndPermsFromTypes(address _delegate, uint8[] _types) external view returns(address[], bytes32[]);
86 
87     /**
88     * @notice Used to get the Permission flag related the `this` contract
89     * @return Array of permission flags
90     */
91     function getPermissions() external view returns(bytes32[]);
92 
93     /**
94     * @notice Used to get all delegates
95     * @return address[]
96     */
97     function getAllDelegates() external view returns(address[]);
98 
99 }
100 
101 /**
102  * @title Interface that every module contract should implement
103  */
104 interface IModule {
105 
106     /**
107      * @notice This function returns the signature of configure function
108      */
109     function getInitFunction() external pure returns (bytes4);
110 
111     /**
112      * @notice Return the permission flags that are associated with a module
113      */
114     function getPermissions() external view returns(bytes32[]);
115 
116     /**
117      * @notice Used to withdraw the fee by the factory owner
118      */
119     function takeFee(uint256 _amount) external returns(bool);
120 
121 }
122 
123 /**
124  * @title Interface for all security tokens
125  */
126 interface ISecurityToken {
127 
128     // Standard ERC20 interface
129     function decimals() external view returns (uint8);
130     function totalSupply() external view returns (uint256);
131     function balanceOf(address _owner) external view returns (uint256);
132     function allowance(address _owner, address _spender) external view returns (uint256);
133     function transfer(address _to, uint256 _value) external returns (bool);
134     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
135     function approve(address _spender, uint256 _value) external returns (bool);
136     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
137     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
138     event Transfer(address indexed from, address indexed to, uint256 value);
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 
141     //transfer, transferFrom must respect the result of verifyTransfer
142     function verifyTransfer(address _from, address _to, uint256 _value) external returns (bool success);
143 
144     /**
145      * @notice Mints new tokens and assigns them to the target _investor.
146      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
147      * @param _investor Address the tokens will be minted to
148      * @param _value is the amount of tokens that will be minted to the investor
149      */
150     function mint(address _investor, uint256 _value) external returns (bool success);
151 
152     /**
153      * @notice Mints new tokens and assigns them to the target _investor.
154      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
155      * @param _investor Address the tokens will be minted to
156      * @param _value is The amount of tokens that will be minted to the investor
157      * @param _data Data to indicate validation
158      */
159     function mintWithData(address _investor, uint256 _value, bytes _data) external returns (bool success);
160 
161     /**
162      * @notice Used to burn the securityToken on behalf of someone else
163      * @param _from Address for whom to burn tokens
164      * @param _value No. of tokens to be burned
165      * @param _data Data to indicate validation
166      */
167     function burnFromWithData(address _from, uint256 _value, bytes _data) external;
168 
169     /**
170      * @notice Used to burn the securityToken
171      * @param _value No. of tokens to be burned
172      * @param _data Data to indicate validation
173      */
174     function burnWithData(uint256 _value, bytes _data) external;
175 
176     event Minted(address indexed _to, uint256 _value);
177     event Burnt(address indexed _burner, uint256 _value);
178 
179     // Permissions this to a Permission module, which has a key of 1
180     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
181     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
182     function checkPermission(address _delegate, address _module, bytes32 _perm) external view returns (bool);
183 
184     /**
185      * @notice Returns module list for a module type
186      * @param _module Address of the module
187      * @return bytes32 Name
188      * @return address Module address
189      * @return address Module factory address
190      * @return bool Module archived
191      * @return uint8 Module type
192      * @return uint256 Module index
193      * @return uint256 Name index
194 
195      */
196     function getModule(address _module) external view returns(bytes32, address, address, bool, uint8, uint256, uint256);
197 
198     /**
199      * @notice Returns module list for a module name
200      * @param _name Name of the module
201      * @return address[] List of modules with this name
202      */
203     function getModulesByName(bytes32 _name) external view returns (address[]);
204 
205     /**
206      * @notice Returns module list for a module type
207      * @param _type Type of the module
208      * @return address[] List of modules with this type
209      */
210     function getModulesByType(uint8 _type) external view returns (address[]);
211 
212     /**
213      * @notice Queries totalSupply at a specified checkpoint
214      * @param _checkpointId Checkpoint ID to query as of
215      */
216     function totalSupplyAt(uint256 _checkpointId) external view returns (uint256);
217 
218     /**
219      * @notice Queries balance at a specified checkpoint
220      * @param _investor Investor to query balance for
221      * @param _checkpointId Checkpoint ID to query as of
222      */
223     function balanceOfAt(address _investor, uint256 _checkpointId) external view returns (uint256);
224 
225     /**
226      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
227      */
228     function createCheckpoint() external returns (uint256);
229 
230     /**
231      * @notice Gets length of investors array
232      * NB - this length may differ from investorCount if the list has not been pruned of zero-balance investors
233      * @return Length
234      */
235     function getInvestors() external view returns (address[]);
236 
237     /**
238      * @notice returns an array of investors at a given checkpoint
239      * NB - this length may differ from investorCount as it contains all investors that ever held tokens
240      * @param _checkpointId Checkpoint id at which investor list is to be populated
241      * @return list of investors
242      */
243     function getInvestorsAt(uint256 _checkpointId) external view returns(address[]);
244 
245     /**
246      * @notice generates subset of investors
247      * NB - can be used in batches if investor list is large
248      * @param _start Position of investor to start iteration from
249      * @param _end Position of investor to stop iteration at
250      * @return list of investors
251      */
252     function iterateInvestors(uint256 _start, uint256 _end) external view returns(address[]);
253     
254     /**
255      * @notice Gets current checkpoint ID
256      * @return Id
257      */
258     function currentCheckpointId() external view returns (uint256);
259 
260     /**
261     * @notice Gets an investor at a particular index
262     * @param _index Index to return address from
263     * @return Investor address
264     */
265     function investors(uint256 _index) external view returns (address);
266 
267    /**
268     * @notice Allows the owner to withdraw unspent POLY stored by them on the ST or any ERC20 token.
269     * @dev Owner can transfer POLY to the ST which will be used to pay for modules that require a POLY fee.
270     * @param _tokenContract Address of the ERC20Basic compliance token
271     * @param _value Amount of POLY to withdraw
272     */
273     function withdrawERC20(address _tokenContract, uint256 _value) external;
274 
275     /**
276     * @notice Allows owner to approve more POLY to one of the modules
277     * @param _module Module address
278     * @param _budget New budget
279     */
280     function changeModuleBudget(address _module, uint256 _budget) external;
281 
282     /**
283      * @notice Changes the tokenDetails
284      * @param _newTokenDetails New token details
285      */
286     function updateTokenDetails(string _newTokenDetails) external;
287 
288     /**
289     * @notice Allows the owner to change token granularity
290     * @param _granularity Granularity level of the token
291     */
292     function changeGranularity(uint256 _granularity) external;
293 
294     /**
295     * @notice Removes addresses with zero balances from the investors list
296     * @param _start Index in investors list at which to start removing zero balances
297     * @param _iters Max number of iterations of the for loop
298     * NB - pruning this list will mean you may not be able to iterate over investors on-chain as of a historical checkpoint
299     */
300     function pruneInvestors(uint256 _start, uint256 _iters) external;
301 
302     /**
303      * @notice Freezes all the transfers
304      */
305     function freezeTransfers() external;
306 
307     /**
308      * @notice Un-freezes all the transfers
309      */
310     function unfreezeTransfers() external;
311 
312     /**
313      * @notice Ends token minting period permanently
314      */
315     function freezeMinting() external;
316 
317     /**
318      * @notice Mints new tokens and assigns them to the target investors.
319      * Can only be called by the STO attached to the token or by the Issuer (Security Token contract owner)
320      * @param _investors A list of addresses to whom the minted tokens will be delivered
321      * @param _values A list of the amount of tokens to mint to corresponding addresses from _investor[] list
322      * @return Success
323      */
324     function mintMulti(address[] _investors, uint256[] _values) external returns (bool success);
325 
326     /**
327      * @notice Function used to attach a module to the security token
328      * @dev  E.G.: On deployment (through the STR) ST gets a TransferManager module attached to it
329      * @dev to control restrictions on transfers.
330      * @dev You are allowed to add a new moduleType if:
331      * @dev - there is no existing module of that type yet added
332      * @dev - the last member of the module list is replacable
333      * @param _moduleFactory is the address of the module factory to be added
334      * @param _data is data packed into bytes used to further configure the module (See STO usage)
335      * @param _maxCost max amount of POLY willing to pay to module. (WIP)
336      */
337     function addModule(
338         address _moduleFactory,
339         bytes _data,
340         uint256 _maxCost,
341         uint256 _budget
342     ) external;
343 
344     /**
345     * @notice Archives a module attached to the SecurityToken
346     * @param _module address of module to archive
347     */
348     function archiveModule(address _module) external;
349 
350     /**
351     * @notice Unarchives a module attached to the SecurityToken
352     * @param _module address of module to unarchive
353     */
354     function unarchiveModule(address _module) external;
355 
356     /**
357     * @notice Removes a module attached to the SecurityToken
358     * @param _module address of module to archive
359     */
360     function removeModule(address _module) external;
361 
362     /**
363      * @notice Used by the issuer to set the controller addresses
364      * @param _controller address of the controller
365      */
366     function setController(address _controller) external;
367 
368     /**
369      * @notice Used by a controller to execute a forced transfer
370      * @param _from address from which to take tokens
371      * @param _to address where to send tokens
372      * @param _value amount of tokens to transfer
373      * @param _data data to indicate validation
374      * @param _log data attached to the transfer by controller to emit in event
375      */
376     function forceTransfer(address _from, address _to, uint256 _value, bytes _data, bytes _log) external;
377 
378     /**
379      * @notice Used by a controller to execute a foced burn
380      * @param _from address from which to take tokens
381      * @param _value amount of tokens to transfer
382      * @param _data data to indicate validation
383      * @param _log data attached to the transfer by controller to emit in event
384      */
385     function forceBurn(address _from, uint256 _value, bytes _data, bytes _log) external;
386 
387     /**
388      * @notice Used by the issuer to permanently disable controller functionality
389      * @dev enabled via feature switch "disableControllerAllowed"
390      */
391      function disableController() external;
392 
393      /**
394      * @notice Used to get the version of the securityToken
395      */
396      function getVersion() external view returns(uint8[]);
397 
398      /**
399      * @notice Gets the investor count
400      */
401      function getInvestorCount() external view returns(uint256);
402 
403      /**
404       * @notice Overloaded version of the transfer function
405       * @param _to receiver of transfer
406       * @param _value value of transfer
407       * @param _data data to indicate validation
408       * @return bool success
409       */
410      function transferWithData(address _to, uint256 _value, bytes _data) external returns (bool success);
411 
412      /**
413       * @notice Overloaded version of the transferFrom function
414       * @param _from sender of transfer
415       * @param _to receiver of transfer
416       * @param _value value of transfer
417       * @param _data data to indicate validation
418       * @return bool success
419       */
420      function transferFromWithData(address _from, address _to, uint256 _value, bytes _data) external returns(bool);
421 
422      /**
423       * @notice Provides the granularity of the token
424       * @return uint256
425       */
426      function granularity() external view returns(uint256);
427 }
428 
429 /**
430  * @title ERC20 interface
431  * @dev see https://github.com/ethereum/EIPs/issues/20
432  */
433 interface IERC20 {
434     function decimals() external view returns (uint8);
435     function totalSupply() external view returns (uint256);
436     function balanceOf(address _owner) external view returns (uint256);
437     function allowance(address _owner, address _spender) external view returns (uint256);
438     function transfer(address _to, uint256 _value) external returns (bool);
439     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
440     function approve(address _spender, uint256 _value) external returns (bool);
441     function decreaseApproval(address _spender, uint _subtractedValue) external returns (bool);
442     function increaseApproval(address _spender, uint _addedValue) external returns (bool);
443     event Transfer(address indexed from, address indexed to, uint256 value);
444     event Approval(address indexed owner, address indexed spender, uint256 value);
445 }
446 
447 /**
448  * @title Ownable
449  * @dev The Ownable contract has an owner address, and provides basic authorization control
450  * functions, this simplifies the implementation of "user permissions".
451  */
452 contract Ownable {
453   address public owner;
454 
455 
456   event OwnershipRenounced(address indexed previousOwner);
457   event OwnershipTransferred(
458     address indexed previousOwner,
459     address indexed newOwner
460   );
461 
462 
463   /**
464    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
465    * account.
466    */
467   constructor() public {
468     owner = msg.sender;
469   }
470 
471   /**
472    * @dev Throws if called by any account other than the owner.
473    */
474   modifier onlyOwner() {
475     require(msg.sender == owner);
476     _;
477   }
478 
479   /**
480    * @dev Allows the current owner to relinquish control of the contract.
481    */
482   function renounceOwnership() public onlyOwner {
483     emit OwnershipRenounced(owner);
484     owner = address(0);
485   }
486 
487   /**
488    * @dev Allows the current owner to transfer control of the contract to a newOwner.
489    * @param _newOwner The address to transfer ownership to.
490    */
491   function transferOwnership(address _newOwner) public onlyOwner {
492     _transferOwnership(_newOwner);
493   }
494 
495   /**
496    * @dev Transfers control of the contract to a newOwner.
497    * @param _newOwner The address to transfer ownership to.
498    */
499   function _transferOwnership(address _newOwner) internal {
500     require(_newOwner != address(0));
501     emit OwnershipTransferred(owner, _newOwner);
502     owner = _newOwner;
503   }
504 }
505 
506 /**
507  * @title Interface that any module contract should implement
508  * @notice Contract is abstract
509  */
510 contract Module is IModule {
511 
512     address public factory;
513 
514     address public securityToken;
515 
516     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
517 
518     IERC20 public polyToken;
519 
520     /**
521      * @notice Constructor
522      * @param _securityToken Address of the security token
523      * @param _polyAddress Address of the polytoken
524      */
525     constructor (address _securityToken, address _polyAddress) public {
526         securityToken = _securityToken;
527         factory = msg.sender;
528         polyToken = IERC20(_polyAddress);
529     }
530 
531     //Allows owner, factory or permissioned delegate
532     modifier withPerm(bytes32 _perm) {
533         bool isOwner = msg.sender == Ownable(securityToken).owner();
534         bool isFactory = msg.sender == factory;
535         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
536         _;
537     }
538 
539     modifier onlyOwner {
540         require(msg.sender == Ownable(securityToken).owner(), "Sender is not owner");
541         _;
542     }
543 
544     modifier onlyFactory {
545         require(msg.sender == factory, "Sender is not factory");
546         _;
547     }
548 
549     modifier onlyFactoryOwner {
550         require(msg.sender == Ownable(factory).owner(), "Sender is not factory owner");
551         _;
552     }
553 
554     modifier onlyFactoryOrOwner {
555         require((msg.sender == Ownable(securityToken).owner()) || (msg.sender == factory), "Sender is not factory or owner");
556         _;
557     }
558 
559     /**
560      * @notice used to withdraw the fee by the factory owner
561      */
562     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
563         require(polyToken.transferFrom(securityToken, Ownable(factory).owner(), _amount), "Unable to take fee");
564         return true;
565     }
566 }
567 
568 /**
569  * @title Permission Manager module for core permissioning functionality
570  */
571 contract GeneralPermissionManager is IPermissionManager, Module {
572 
573     // Mapping used to hold the permissions on the modules provided to delegate, module add => delegate add => permission bytes32 => bool 
574     mapping (address => mapping (address => mapping (bytes32 => bool))) public perms;
575     // Mapping hold the delagate details
576     mapping (address => bytes32) public delegateDetails;
577     // Array to track all delegates
578     address[] public allDelegates;
579 
580 
581     // Permission flag
582     bytes32 public constant CHANGE_PERMISSION = "CHANGE_PERMISSION";
583 
584     /// Event emitted after any permission get changed for the delegate
585     event ChangePermission(address indexed _delegate, address _module, bytes32 _perm, bool _valid, uint256 _timestamp);
586     /// Used to notify when delegate is added in permission manager contract
587     event AddDelegate(address indexed _delegate, bytes32 _details, uint256 _timestamp);
588 
589 
590     /// @notice constructor
591     constructor (address _securityToken, address _polyAddress) public
592     Module(_securityToken, _polyAddress)
593     {
594     }
595 
596     /**
597      * @notice Init function i.e generalise function to maintain the structure of the module contract
598      * @return bytes4
599      */
600     function getInitFunction() public pure returns (bytes4) {
601         return bytes4(0);
602     }
603 
604     /**
605      * @notice Used to check the permission on delegate corresponds to module contract address
606      * @param _delegate Ethereum address of the delegate
607      * @param _module Ethereum contract address of the module
608      * @param _perm Permission flag
609      * @return bool
610      */
611     function checkPermission(address _delegate, address _module, bytes32 _perm) external view returns(bool) {
612         if (delegateDetails[_delegate] != bytes32(0)) {
613             return perms[_module][_delegate][_perm];
614         } else
615             return false;
616     }
617 
618     /**
619      * @notice Used to add a delegate
620      * @param _delegate Ethereum address of the delegate
621      * @param _details Details about the delegate i.e `Belongs to financial firm`
622      */
623     function addDelegate(address _delegate, bytes32 _details) external withPerm(CHANGE_PERMISSION) {
624         require(_delegate != address(0), "Invalid address");
625         require(_details != bytes32(0), "0 value not allowed");
626         require(delegateDetails[_delegate] == bytes32(0), "Already present");
627         delegateDetails[_delegate] = _details;
628         allDelegates.push(_delegate);
629         /*solium-disable-next-line security/no-block-members*/
630         emit AddDelegate(_delegate, _details, now);
631     }
632 
633     /**
634      * @notice Used to delete a delegate
635      * @param _delegate Ethereum address of the delegate
636      */
637     function deleteDelegate(address _delegate) external withPerm(CHANGE_PERMISSION) {
638         require(delegateDetails[_delegate] != bytes32(0), "delegate does not exist");
639         for (uint256 i = 0; i < allDelegates.length; i++) {
640             if (allDelegates[i] == _delegate) {
641                 allDelegates[i] = allDelegates[allDelegates.length - 1];
642                 allDelegates.length = allDelegates.length - 1;
643             }
644         }
645         delete delegateDetails[_delegate];
646     }
647 
648     /**
649      * @notice Used to check if an address is a delegate or not
650      * @param _potentialDelegate the address of potential delegate
651      * @return bool
652      */
653     function checkDelegate(address _potentialDelegate) external view returns(bool) {
654         require(_potentialDelegate != address(0), "Invalid address");
655 
656         if (delegateDetails[_potentialDelegate] != bytes32(0)) {
657             return true;
658         } else
659             return false;
660     }
661 
662     /**
663      * @notice Used to provide/change the permission to the delegate corresponds to the module contract
664      * @param _delegate Ethereum address of the delegate
665      * @param _module Ethereum contract address of the module
666      * @param _perm Permission flag
667      * @param _valid Bool flag use to switch on/off the permission
668      * @return bool
669      */
670     function changePermission(
671         address _delegate,
672         address _module,
673         bytes32 _perm,
674         bool _valid
675     )
676     public
677     withPerm(CHANGE_PERMISSION)
678     {
679         require(_delegate != address(0), "invalid address");
680         _changePermission(_delegate, _module, _perm, _valid);
681     }
682 
683     /**
684      * @notice Used to change one or more permissions for a single delegate at once
685      * @param _delegate Ethereum address of the delegate
686      * @param _modules Multiple module matching the multiperms, needs to be same length
687      * @param _perms Multiple permission flag needs to be changed
688      * @param _valids Bool array consist the flag to switch on/off the permission
689      * @return nothing
690      */
691     function changePermissionMulti(
692         address _delegate,
693         address[] _modules,
694         bytes32[] _perms,
695         bool[] _valids
696     )
697     external
698     withPerm(CHANGE_PERMISSION)
699     {
700         require(_delegate != address(0), "invalid address");
701         require(_modules.length > 0, "0 length is not allowed");
702         require(_modules.length == _perms.length, "Array length mismatch");
703         require(_valids.length == _perms.length, "Array length mismatch");
704         for(uint256 i = 0; i < _perms.length; i++) {
705             _changePermission(_delegate, _modules[i], _perms[i], _valids[i]);
706         }
707     }
708 
709     /**
710      * @notice Used to return all delegates with a given permission and module
711      * @param _module Ethereum contract address of the module
712      * @param _perm Permission flag
713      * @return address[]
714      */
715     function getAllDelegatesWithPerm(address _module, bytes32 _perm) external view returns(address[]) {
716         uint256 counter = 0;
717         uint256 i = 0;
718         for (i = 0; i < allDelegates.length; i++) {
719             if (perms[_module][allDelegates[i]][_perm]) {
720                 counter++;
721             }
722         }
723         address[] memory allDelegatesWithPerm = new address[](counter);
724         counter = 0;
725         for (i = 0; i < allDelegates.length; i++) {
726             if (perms[_module][allDelegates[i]][_perm]){
727                 allDelegatesWithPerm[counter] = allDelegates[i];
728                 counter++;
729             }
730         }
731         return allDelegatesWithPerm;
732     }
733 
734     /**
735      * @notice Used to return all permission of a single or multiple module
736      * @dev possible that function get out of gas is there are lot of modules and perm related to them
737      * @param _delegate Ethereum address of the delegate
738      * @param _types uint8[] of types
739      * @return address[] the address array of Modules this delegate has permission
740      * @return bytes32[] the permission array of the corresponding Modules
741      */
742     function getAllModulesAndPermsFromTypes(address _delegate, uint8[] _types) external view returns(address[], bytes32[]) {
743         uint256 counter = 0;
744         // loop through _types and get their modules from securityToken->getModulesByType
745         for (uint256 i = 0; i < _types.length; i++) {
746             address[] memory _currentTypeModules = ISecurityToken(securityToken).getModulesByType(_types[i]);
747             // loop through each modules to get their perms from IModule->getPermissions
748             for (uint256 j = 0; j < _currentTypeModules.length; j++){
749                 bytes32[] memory _allModulePerms = IModule(_currentTypeModules[j]).getPermissions();
750                 // loop through each perm, if it is true, push results into arrays
751                 for (uint256 k = 0; k < _allModulePerms.length; k++) {
752                     if (perms[_currentTypeModules[j]][_delegate][_allModulePerms[k]]) {
753                         counter ++;
754                     }
755                 }
756             }
757         }
758 
759         address[] memory _allModules = new address[](counter);
760         bytes32[] memory _allPerms = new bytes32[](counter);
761         counter = 0;
762 
763         for (i = 0; i < _types.length; i++){
764             _currentTypeModules = ISecurityToken(securityToken).getModulesByType(_types[i]);
765             for (j = 0; j < _currentTypeModules.length; j++) {
766                 _allModulePerms = IModule(_currentTypeModules[j]).getPermissions();
767                 for (k = 0; k < _allModulePerms.length; k++) {
768                     if (perms[_currentTypeModules[j]][_delegate][_allModulePerms[k]]) {
769                         _allModules[counter] = _currentTypeModules[j];
770                         _allPerms[counter] = _allModulePerms[k];
771                         counter++;
772                     }
773                 }
774             }
775         }
776 
777         return(_allModules, _allPerms);
778     }
779 
780     /**
781      * @notice Used to provide/change the permission to the delegate corresponds to the module contract
782      * @param _delegate Ethereum address of the delegate
783      * @param _module Ethereum contract address of the module
784      * @param _perm Permission flag
785      * @param _valid Bool flag use to switch on/off the permission
786      * @return bool
787      */
788     function _changePermission(
789         address _delegate,
790         address _module,
791         bytes32 _perm,
792         bool _valid
793     )
794      internal
795     {
796         perms[_module][_delegate][_perm] = _valid;
797         /*solium-disable-next-line security/no-block-members*/
798         emit ChangePermission(_delegate, _module, _perm, _valid, now);
799     }
800 
801     /**
802      * @notice Used to get all delegates
803      * @return address[]
804      */
805     function getAllDelegates() external view returns(address[]) {
806         return allDelegates;
807     }
808     
809     /**
810     * @notice Returns the Permission flag related the `this` contract
811     * @return Array of permission flags
812     */
813     function getPermissions() public view returns(bytes32[]) {
814         bytes32[] memory allPermissions = new bytes32[](1);
815         allPermissions[0] = CHANGE_PERMISSION;
816         return allPermissions;
817     }
818 
819 }
820 
821 /**
822  * @title Interface that every module factory contract should implement
823  */
824 interface IModuleFactory {
825 
826     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
827     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
828     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
829     event GenerateModuleFromFactory(
830         address _module,
831         bytes32 indexed _moduleName,
832         address indexed _moduleFactory,
833         address _creator,
834         uint256 _setupCost,
835         uint256 _timestamp
836     );
837     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
838 
839     //Should create an instance of the Module, or throw
840     function deploy(bytes _data) external returns(address);
841 
842     /**
843      * @notice Type of the Module factory
844      */
845     function getTypes() external view returns(uint8[]);
846 
847     /**
848      * @notice Get the name of the Module
849      */
850     function getName() external view returns(bytes32);
851 
852     /**
853      * @notice Returns the instructions associated with the module
854      */
855     function getInstructions() external view returns (string);
856 
857     /**
858      * @notice Get the tags related to the module factory
859      */
860     function getTags() external view returns (bytes32[]);
861 
862     /**
863      * @notice Used to change the setup fee
864      * @param _newSetupCost New setup fee
865      */
866     function changeFactorySetupFee(uint256 _newSetupCost) external;
867 
868     /**
869      * @notice Used to change the usage fee
870      * @param _newUsageCost New usage fee
871      */
872     function changeFactoryUsageFee(uint256 _newUsageCost) external;
873 
874     /**
875      * @notice Used to change the subscription fee
876      * @param _newSubscriptionCost New subscription fee
877      */
878     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) external;
879 
880     /**
881      * @notice Function use to change the lower and upper bound of the compatible version st
882      * @param _boundType Type of bound
883      * @param _newVersion New version array
884      */
885     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external;
886 
887    /**
888      * @notice Get the setup cost of the module
889      */
890     function getSetupCost() external view returns (uint256);
891 
892     /**
893      * @notice Used to get the lower bound
894      * @return Lower bound
895      */
896     function getLowerSTVersionBounds() external view returns(uint8[]);
897 
898      /**
899      * @notice Used to get the upper bound
900      * @return Upper bound
901      */
902     function getUpperSTVersionBounds() external view returns(uint8[]);
903 
904 }
905 
906 /**
907  * @title Helper library use to compare or validate the semantic versions
908  */
909 
910 library VersionUtils {
911 
912     /**
913      * @notice This function is used to validate the version submitted
914      * @param _current Array holds the present version of ST
915      * @param _new Array holds the latest version of the ST
916      * @return bool
917      */
918     function isValidVersion(uint8[] _current, uint8[] _new) internal pure returns(bool) {
919         bool[] memory _temp = new bool[](_current.length);
920         uint8 counter = 0;
921         for (uint8 i = 0; i < _current.length; i++) {
922             if (_current[i] < _new[i])
923                 _temp[i] = true;
924             else
925                 _temp[i] = false;
926         }
927 
928         for (i = 0; i < _current.length; i++) {
929             if (i == 0) {
930                 if (_current[i] <= _new[i])
931                     if(_temp[0]) {
932                         counter = counter + 3;
933                         break;
934                     } else
935                         counter++;
936                 else
937                     return false;
938             } else {
939                 if (_temp[i-1])
940                     counter++;
941                 else if (_current[i] <= _new[i])
942                     counter++;
943                 else
944                     return false;
945             }
946         }
947         if (counter == _current.length)
948             return true;
949     }
950 
951     /**
952      * @notice Used to compare the lower bound with the latest version
953      * @param _version1 Array holds the lower bound of the version
954      * @param _version2 Array holds the latest version of the ST
955      * @return bool
956      */
957     function compareLowerBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
958         require(_version1.length == _version2.length, "Input length mismatch");
959         uint counter = 0;
960         for (uint8 j = 0; j < _version1.length; j++) {
961             if (_version1[j] == 0)
962                 counter ++;
963         }
964         if (counter != _version1.length) {
965             counter = 0;
966             for (uint8 i = 0; i < _version1.length; i++) {
967                 if (_version2[i] > _version1[i])
968                     return true;
969                 else if (_version2[i] < _version1[i])
970                     return false;
971                 else
972                     counter++;
973             }
974             if (counter == _version1.length - 1)
975                 return true;
976             else
977                 return false;
978         } else
979             return true;
980     }
981 
982     /**
983      * @notice Used to compare the upper bound with the latest version
984      * @param _version1 Array holds the upper bound of the version
985      * @param _version2 Array holds the latest version of the ST
986      * @return bool
987      */
988     function compareUpperBound(uint8[] _version1, uint8[] _version2) internal pure returns(bool) {
989         require(_version1.length == _version2.length, "Input length mismatch");
990         uint counter = 0;
991         for (uint8 j = 0; j < _version1.length; j++) {
992             if (_version1[j] == 0)
993                 counter ++;
994         }
995         if (counter != _version1.length) {
996             counter = 0;
997             for (uint8 i = 0; i < _version1.length; i++) {
998                 if (_version1[i] > _version2[i])
999                     return true;
1000                 else if (_version1[i] < _version2[i])
1001                     return false;
1002                 else
1003                     counter++;
1004             }
1005             if (counter == _version1.length - 1)
1006                 return true;
1007             else
1008                 return false;
1009         } else
1010             return true;
1011     }
1012 
1013 
1014     /**
1015      * @notice Used to pack the uint8[] array data into uint24 value
1016      * @param _major Major version
1017      * @param _minor Minor version
1018      * @param _patch Patch version
1019      */
1020     function pack(uint8 _major, uint8 _minor, uint8 _patch) internal pure returns(uint24) {
1021         return (uint24(_major) << 16) | (uint24(_minor) << 8) | uint24(_patch);
1022     }
1023 
1024     /**
1025      * @notice Used to convert packed data into uint8 array
1026      * @param _packedVersion Packed data
1027      */
1028     function unpack(uint24 _packedVersion) internal pure returns (uint8[]) {
1029         uint8[] memory _unpackVersion = new uint8[](3);
1030         _unpackVersion[0] = uint8(_packedVersion >> 16);
1031         _unpackVersion[1] = uint8(_packedVersion >> 8);
1032         _unpackVersion[2] = uint8(_packedVersion);
1033         return _unpackVersion;
1034     }
1035 
1036 
1037 }
1038 
1039 /**
1040  * @title Interface that any module factory contract should implement
1041  * @notice Contract is abstract
1042  */
1043 contract ModuleFactory is IModuleFactory, Ownable {
1044 
1045     IERC20 public polyToken;
1046     uint256 public usageCost;
1047     uint256 public monthlySubscriptionCost;
1048 
1049     uint256 public setupCost;
1050     string public description;
1051     string public version;
1052     bytes32 public name;
1053     string public title;
1054 
1055     // @notice Allow only two variables to be stored
1056     // 1. lowerBound 
1057     // 2. upperBound
1058     // @dev (0.0.0 will act as the wildcard) 
1059     // @dev uint24 consists packed value of uint8 _major, uint8 _minor, uint8 _patch
1060     mapping(string => uint24) compatibleSTVersionRange;
1061 
1062     event ChangeFactorySetupFee(uint256 _oldSetupCost, uint256 _newSetupCost, address _moduleFactory);
1063     event ChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
1064     event ChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
1065     event GenerateModuleFromFactory(
1066         address _module,
1067         bytes32 indexed _moduleName,
1068         address indexed _moduleFactory,
1069         address _creator,
1070         uint256 _timestamp
1071     );
1072     event ChangeSTVersionBound(string _boundType, uint8 _major, uint8 _minor, uint8 _patch);
1073 
1074     /**
1075      * @notice Constructor
1076      * @param _polyAddress Address of the polytoken
1077      */
1078     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
1079         polyToken = IERC20(_polyAddress);
1080         setupCost = _setupCost;
1081         usageCost = _usageCost;
1082         monthlySubscriptionCost = _subscriptionCost;
1083     }
1084 
1085     /**
1086      * @notice Used to change the fee of the setup cost
1087      * @param _newSetupCost new setup cost
1088      */
1089     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
1090         emit ChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
1091         setupCost = _newSetupCost;
1092     }
1093 
1094     /**
1095      * @notice Used to change the fee of the usage cost
1096      * @param _newUsageCost new usage cost
1097      */
1098     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
1099         emit ChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
1100         usageCost = _newUsageCost;
1101     }
1102 
1103     /**
1104      * @notice Used to change the fee of the subscription cost
1105      * @param _newSubscriptionCost new subscription cost
1106      */
1107     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
1108         emit ChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
1109         monthlySubscriptionCost = _newSubscriptionCost;
1110 
1111     }
1112 
1113     /**
1114      * @notice Updates the title of the ModuleFactory
1115      * @param _newTitle New Title that will replace the old one.
1116      */
1117     function changeTitle(string _newTitle) public onlyOwner {
1118         require(bytes(_newTitle).length > 0, "Invalid title");
1119         title = _newTitle;
1120     }
1121 
1122     /**
1123      * @notice Updates the description of the ModuleFactory
1124      * @param _newDesc New description that will replace the old one.
1125      */
1126     function changeDescription(string _newDesc) public onlyOwner {
1127         require(bytes(_newDesc).length > 0, "Invalid description");
1128         description = _newDesc;
1129     }
1130 
1131     /**
1132      * @notice Updates the name of the ModuleFactory
1133      * @param _newName New name that will replace the old one.
1134      */
1135     function changeName(bytes32 _newName) public onlyOwner {
1136         require(_newName != bytes32(0),"Invalid name");
1137         name = _newName;
1138     }
1139 
1140     /**
1141      * @notice Updates the version of the ModuleFactory
1142      * @param _newVersion New name that will replace the old one.
1143      */
1144     function changeVersion(string _newVersion) public onlyOwner {
1145         require(bytes(_newVersion).length > 0, "Invalid version");
1146         version = _newVersion;
1147     }
1148 
1149     /**
1150      * @notice Function use to change the lower and upper bound of the compatible version st
1151      * @param _boundType Type of bound
1152      * @param _newVersion new version array
1153      */
1154     function changeSTVersionBounds(string _boundType, uint8[] _newVersion) external onlyOwner {
1155         require(
1156             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("lowerBound")) ||
1157             keccak256(abi.encodePacked(_boundType)) == keccak256(abi.encodePacked("upperBound")),
1158             "Must be a valid bound type"
1159         );
1160         require(_newVersion.length == 3);
1161         if (compatibleSTVersionRange[_boundType] != uint24(0)) { 
1162             uint8[] memory _currentVersion = VersionUtils.unpack(compatibleSTVersionRange[_boundType]);
1163             require(VersionUtils.isValidVersion(_currentVersion, _newVersion), "Failed because of in-valid version");
1164         }
1165         compatibleSTVersionRange[_boundType] = VersionUtils.pack(_newVersion[0], _newVersion[1], _newVersion[2]);
1166         emit ChangeSTVersionBound(_boundType, _newVersion[0], _newVersion[1], _newVersion[2]);
1167     }
1168 
1169     /**
1170      * @notice Used to get the lower bound
1171      * @return lower bound
1172      */
1173     function getLowerSTVersionBounds() external view returns(uint8[]) {
1174         return VersionUtils.unpack(compatibleSTVersionRange["lowerBound"]);
1175     }
1176 
1177     /**
1178      * @notice Used to get the upper bound
1179      * @return upper bound
1180      */
1181     function getUpperSTVersionBounds() external view returns(uint8[]) {
1182         return VersionUtils.unpack(compatibleSTVersionRange["upperBound"]);
1183     }
1184 
1185     /**
1186      * @notice Get the setup cost of the module
1187      */
1188     function getSetupCost() external view returns (uint256) {
1189         return setupCost;
1190     }
1191 
1192    /**
1193     * @notice Get the name of the Module
1194     */
1195     function getName() public view returns(bytes32) {
1196         return name;
1197     }
1198 
1199 }
1200 
1201 /**
1202  * @title Factory for deploying GeneralPermissionManager module
1203  */
1204 contract GeneralPermissionManagerFactory is ModuleFactory {
1205 
1206     /**
1207      * @notice Constructor
1208      * @param _polyAddress Address of the polytoken
1209      */
1210     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1211     ModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1212     {
1213         version = "1.0.0";
1214         name = "GeneralPermissionManager";
1215         title = "General Permission Manager";
1216         description = "Manage permissions within the Security Token and attached modules";
1217         compatibleSTVersionRange["lowerBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1218         compatibleSTVersionRange["upperBound"] = VersionUtils.pack(uint8(0), uint8(0), uint8(0));
1219     }
1220 
1221     /**
1222      * @notice Used to launch the Module with the help of factory
1223      * @return address Contract address of the Module
1224      */
1225     function deploy(bytes /* _data */) external returns(address) {
1226         if(setupCost > 0)
1227             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom due to insufficent Allowance provided");
1228         address permissionManager = new GeneralPermissionManager(msg.sender, address(polyToken));
1229         /*solium-disable-next-line security/no-block-members*/
1230         emit GenerateModuleFromFactory(address(permissionManager), getName(), address(this), msg.sender, setupCost, now);
1231         return permissionManager;
1232     }
1233 
1234     /**
1235      * @notice Type of the Module factory
1236      */
1237     function getTypes() external view returns(uint8[]) {
1238         uint8[] memory res = new uint8[](1);
1239         res[0] = 1;
1240         return res;
1241     }
1242 
1243     /**
1244      * @notice Returns the instructions associated with the module
1245      */
1246     function getInstructions() external view returns(string) {
1247         /*solium-disable-next-line max-len*/
1248         return "Add and remove permissions for the SecurityToken and associated modules. Permission types should be encoded as bytes32 values and attached using withPerm modifier to relevant functions. No initFunction required.";
1249     }
1250 
1251     /**
1252      * @notice Get the tags related to the module factory
1253      */
1254     function getTags() external view returns(bytes32[]) {
1255         bytes32[] memory availableTags = new bytes32[](0);
1256         return availableTags;
1257     }
1258 }