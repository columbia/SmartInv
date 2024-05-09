1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117   function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(
147     address _from,
148     address _to,
149     uint256 _value
150   )
151     public
152     returns (bool)
153   {
154     require(_to != address(0));
155     require(_value <= balances[_from]);
156     require(_value <= allowed[_from][msg.sender]);
157 
158     balances[_from] = balances[_from].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161     emit Transfer(_from, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    *
168    * Beware that changing an allowance with this method brings the risk that someone may use both the old
169    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) public returns (bool) {
176     allowed[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197 
198   /**
199    * @dev Increase the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseApproval(
209     address _spender,
210     uint _addedValue
211   )
212     public
213     returns (bool)
214   {
215     allowed[msg.sender][_spender] = (
216       allowed[msg.sender][_spender].add(_addedValue));
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(
232     address _spender,
233     uint _subtractedValue
234   )
235     public
236     returns (bool)
237   {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 /**
251  * @title DetailedERC20 token
252  * @dev The decimals are only for visualization purposes.
253  * All the operations are done using the smallest and indivisible token unit,
254  * just as on Ethereum all the operations are done in wei.
255  */
256 contract DetailedERC20 is ERC20 {
257   string public name;
258   string public symbol;
259   uint8 public decimals;
260 
261   constructor(string _name, string _symbol, uint8 _decimals) public {
262     name = _name;
263     symbol = _symbol;
264     decimals = _decimals;
265   }
266 }
267 
268 /**
269  * @title Interface for the ST20 token standard
270  */
271 contract IST20 is StandardToken, DetailedERC20 {
272 
273     // off-chain hash
274     string public tokenDetails;
275 
276     //transfer, transferFrom must respect use respect the result of verifyTransfer
277     function verifyTransfer(address _from, address _to, uint256 _amount) public returns (bool success);
278 
279     /**
280      * @notice mints new tokens and assigns them to the target _investor.
281      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
282      */
283     function mint(address _investor, uint256 _amount) public returns (bool success);
284 
285     /**
286      * @notice Burn function used to burn the securityToken
287      * @param _value No. of token that get burned
288      */
289     function burn(uint256 _value) public;
290 
291     event Minted(address indexed to, uint256 amount);
292     event Burnt(address indexed _burner, uint256 _value);
293 
294 }
295 
296 /**
297  * @title Ownable
298  * @dev The Ownable contract has an owner address, and provides basic authorization control
299  * functions, this simplifies the implementation of "user permissions".
300  */
301 contract Ownable {
302   address public owner;
303 
304 
305   event OwnershipRenounced(address indexed previousOwner);
306   event OwnershipTransferred(
307     address indexed previousOwner,
308     address indexed newOwner
309   );
310 
311 
312   /**
313    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
314    * account.
315    */
316   constructor() public {
317     owner = msg.sender;
318   }
319 
320   /**
321    * @dev Throws if called by any account other than the owner.
322    */
323   modifier onlyOwner() {
324     require(msg.sender == owner);
325     _;
326   }
327 
328   /**
329    * @dev Allows the current owner to relinquish control of the contract.
330    */
331   function renounceOwnership() public onlyOwner {
332     emit OwnershipRenounced(owner);
333     owner = address(0);
334   }
335 
336   /**
337    * @dev Allows the current owner to transfer control of the contract to a newOwner.
338    * @param _newOwner The address to transfer ownership to.
339    */
340   function transferOwnership(address _newOwner) public onlyOwner {
341     _transferOwnership(_newOwner);
342   }
343 
344   /**
345    * @dev Transfers control of the contract to a newOwner.
346    * @param _newOwner The address to transfer ownership to.
347    */
348   function _transferOwnership(address _newOwner) internal {
349     require(_newOwner != address(0));
350     emit OwnershipTransferred(owner, _newOwner);
351     owner = _newOwner;
352   }
353 }
354 
355 /**
356  * @title Interface for all security tokens
357  */
358 contract ISecurityToken is IST20, Ownable {
359 
360     uint8 public constant PERMISSIONMANAGER_KEY = 1;
361     uint8 public constant TRANSFERMANAGER_KEY = 2;
362     uint8 public constant STO_KEY = 3;
363     uint8 public constant CHECKPOINT_KEY = 4;
364     uint256 public granularity;
365 
366     // Value of current checkpoint
367     uint256 public currentCheckpointId;
368 
369     // Total number of non-zero token holders
370     uint256 public investorCount;
371 
372     // List of token holders
373     address[] public investors;
374 
375     // Permissions this to a Permission module, which has a key of 1
376     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
377     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
378     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);
379 
380     /**
381      * @notice returns module list for a module type
382      * @param _moduleType is which type of module we are trying to remove
383      * @param _moduleIndex is the index of the module within the chosen type
384      */
385     function getModule(uint8 _moduleType, uint _moduleIndex) public view returns (bytes32, address);
386 
387     /**
388      * @notice returns module list for a module name - will return first match
389      * @param _moduleType is which type of module we are trying to remove
390      * @param _name is the name of the module within the chosen type
391      */
392     function getModuleByName(uint8 _moduleType, bytes32 _name) public view returns (bytes32, address);
393 
394     /**
395      * @notice Queries totalSupply as of a defined checkpoint
396      * @param _checkpointId Checkpoint ID to query as of
397      */
398     function totalSupplyAt(uint256 _checkpointId) public view returns(uint256);
399 
400     /**
401      * @notice Queries balances as of a defined checkpoint
402      * @param _investor Investor to query balance for
403      * @param _checkpointId Checkpoint ID to query as of
404      */
405     function balanceOfAt(address _investor, uint256 _checkpointId) public view returns(uint256);
406 
407     /**
408      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
409      */
410     function createCheckpoint() public returns(uint256);
411 
412     /**
413      * @notice gets length of investors array
414      * NB - this length may differ from investorCount if list has not been pruned of zero balance investors
415      * @return length
416      */
417     function getInvestorsLength() public view returns(uint256);
418 
419 }
420 
421 /**
422  * @title Interface that any module factory contract should implement
423  */
424 contract IModuleFactory is Ownable {
425 
426     ERC20 public polyToken;
427     uint256 public setupCost;
428     uint256 public usageCost;
429     uint256 public monthlySubscriptionCost;
430 
431     event LogChangeFactorySetupFee(uint256 _oldSetupcost, uint256 _newSetupCost, address _moduleFactory);
432     event LogChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
433     event LogChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
434     event LogGenerateModuleFromFactory(address _module, bytes32 indexed _moduleName, address indexed _moduleFactory, address _creator, uint256 _timestamp);
435 
436     /**
437      * @notice Constructor
438      * @param _polyAddress Address of the polytoken
439      */
440     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
441       polyToken = ERC20(_polyAddress);
442       setupCost = _setupCost;
443       usageCost = _usageCost;
444       monthlySubscriptionCost = _subscriptionCost;
445     }
446 
447     //Should create an instance of the Module, or throw
448     function deploy(bytes _data) external returns(address);
449 
450     /**
451      * @notice Type of the Module factory
452      */
453     function getType() public view returns(uint8);
454 
455     /**
456      * @notice Get the name of the Module
457      */
458     function getName() public view returns(bytes32);
459 
460     /**
461      * @notice Get the description of the Module
462      */
463     function getDescription() public view returns(string);
464 
465     /**
466      * @notice Get the title of the Module
467      */
468     function getTitle() public view returns(string);
469 
470     /**
471      * @notice Get the Instructions that helped to used the module
472      */
473     function getInstructions() public view returns (string);
474 
475     /**
476      * @notice Get the tags related to the module factory
477      */
478     function getTags() public view returns (bytes32[]);
479 
480     //Pull function sig from _data
481     function getSig(bytes _data) internal pure returns (bytes4 sig) {
482         uint len = _data.length < 4 ? _data.length : 4;
483         for (uint i = 0; i < len; i++) {
484             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
485         }
486     }
487 
488     /**
489      * @notice used to change the fee of the setup cost
490      * @param _newSetupCost new setup cost
491      */
492     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
493         emit LogChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
494         setupCost = _newSetupCost;
495     }
496 
497     /**
498      * @notice used to change the fee of the usage cost
499      * @param _newUsageCost new usage cost
500      */
501     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
502         emit LogChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
503         usageCost = _newUsageCost;
504     }
505 
506     /**
507      * @notice used to change the fee of the subscription cost
508      * @param _newSubscriptionCost new subscription cost
509      */
510     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
511         emit LogChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
512         monthlySubscriptionCost = _newSubscriptionCost;
513         
514     }
515 
516 }
517 
518 /**
519  * @title Interface that any module contract should implement
520  */
521 contract IModule {
522 
523     address public factory;
524 
525     address public securityToken;
526 
527     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
528 
529     ERC20 public polyToken;
530 
531     /**
532      * @notice Constructor
533      * @param _securityToken Address of the security token
534      * @param _polyAddress Address of the polytoken
535      */
536     constructor (address _securityToken, address _polyAddress) public {
537         securityToken = _securityToken;
538         factory = msg.sender;
539         polyToken = ERC20(_polyAddress);
540     }
541 
542     /**
543      * @notice This function returns the signature of configure function
544      */
545     function getInitFunction() public pure returns (bytes4);
546 
547     //Allows owner, factory or permissioned delegate
548     modifier withPerm(bytes32 _perm) {
549         bool isOwner = msg.sender == ISecurityToken(securityToken).owner();
550         bool isFactory = msg.sender == factory;
551         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
552         _;
553     }
554 
555     modifier onlyOwner {
556         require(msg.sender == ISecurityToken(securityToken).owner(), "Sender is not owner");
557         _;
558     }
559 
560     modifier onlyFactory {
561         require(msg.sender == factory, "Sender is not factory");
562         _;
563     }
564 
565     modifier onlyFactoryOwner {
566         require(msg.sender == IModuleFactory(factory).owner(), "Sender is not factory owner");
567         _;
568     }
569 
570     /**
571      * @notice Return the permissions flag that are associated with Module
572      */
573     function getPermissions() public view returns(bytes32[]);
574 
575     /**
576      * @notice used to withdraw the fee by the factory owner
577      */
578     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
579         require(polyToken.transferFrom(address(this), IModuleFactory(factory).owner(), _amount), "Unable to take fee");
580         return true;
581     }
582 }
583 
584 /**
585  * @title Interface to be implemented by all permission manager modules
586  */
587 contract IPermissionManager is IModule {
588 
589     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);
590 
591     function changePermission(address _delegate, address _module, bytes32 _perm, bool _valid) public returns(bool);
592 
593     function getDelegateDetails(address _delegate) public view returns(bytes32);
594 
595 }
596 
597 /////////////////////
598 // Module permissions
599 /////////////////////
600 //                          Owner       CHANGE_PERMISSION
601 // addPermission              X               X
602 // changePermission           X               X
603 //
604 
605 /**
606  * @title Permission Manager module for core permissioning functionality
607  */
608 contract GeneralPermissionManager is IPermissionManager {
609 
610     // Mapping used to hold the permissions on the modules provided to delegate
611     mapping (address => mapping (address => mapping (bytes32 => bool))) public perms;
612     // Mapping hold the delagate details
613     mapping (address => bytes32) public delegateDetails;
614     // Permission flag
615     bytes32 public constant CHANGE_PERMISSION = "CHANGE_PERMISSION";
616 
617     /// Event emitted after any permission get changed for the delegate
618     event LogChangePermission(address _delegate, address _module, bytes32 _perm, bool _valid, uint256 _timestamp);
619     /// Use to notify when delegate is added in permission manager contract
620     event LogAddPermission(address _delegate, bytes32 _details, uint256 _timestamp);
621 
622     /// @notice constructor
623     constructor (address _securityToken, address _polyAddress) public
624     IModule(_securityToken, _polyAddress)
625     {
626     }
627 
628     /**
629     * @notice Init function i.e generalise function to maintain the structure of the module contract
630     * @return bytes4
631     */
632     function getInitFunction() public pure returns (bytes4) {
633         return bytes4(0);
634     }
635 
636     /**
637     * @notice use to check the permission on delegate corresponds to module contract address
638     * @param _delegate Ethereum address of the delegate
639     * @param _module Ethereum contract address of the module
640     * @param _perm Permission flag
641     * @return bool
642     */
643     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool) {
644         if (delegateDetails[_delegate] != bytes32(0)) {
645             return perms[_module][_delegate][_perm];
646         }else
647             return false;
648     }
649 
650     /**
651     * @notice use to add the details of the delegate
652     * @param _delegate Ethereum address of the delegate
653     * @param _details Details about the delegate i.e `Belongs to financial firm`
654     */
655     function addPermission(address _delegate, bytes32 _details) public withPerm(CHANGE_PERMISSION) {
656         delegateDetails[_delegate] = _details;
657         emit LogAddPermission(_delegate, _details, now);
658     }
659 
660   /**
661     * @notice Use to provide/change the permission to the delegate corresponds to the module contract
662     * @param _delegate Ethereum address of the delegate
663     * @param _module Ethereum contract address of the module
664     * @param _perm Permission flag
665     * @param _valid Bool flag use to switch on/off the permission
666     * @return bool
667     */
668     function changePermission(
669         address _delegate,
670         address _module,
671         bytes32 _perm,
672         bool _valid
673     )
674     public
675     withPerm(CHANGE_PERMISSION)
676     returns(bool)
677     {
678         require(delegateDetails[_delegate] != bytes32(0), "Delegate details not set");
679         perms[_module][_delegate][_perm] = _valid;
680         emit LogChangePermission(_delegate, _module, _perm, _valid, now);
681         return true;
682     }
683 
684     /**
685     * @notice Use to get the details of the delegate
686     * @param _delegate Ethereum address of the delegate
687     * @return Details of the delegate
688     */
689     function getDelegateDetails(address _delegate) public view returns(bytes32) {
690         return delegateDetails[_delegate];
691     }
692 
693     /**
694     * @notice Use to get the Permission flag related the `this` contract
695     * @return Array of permission flags
696     */
697     function getPermissions() public view returns(bytes32[]) {
698         bytes32[] memory allPermissions = new bytes32[](1);
699         allPermissions[0] = CHANGE_PERMISSION;
700         return allPermissions;
701     }
702 
703 }
704 
705 /**
706  * @title Factory for deploying GeneralPermissionManager module
707  */
708 contract GeneralPermissionManagerFactory is IModuleFactory {
709 
710     /**
711      * @notice Constructor
712      * @param _polyAddress Address of the polytoken
713      */
714     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
715       IModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
716     {
717 
718     }
719 
720     /**
721      * @notice used to launch the Module with the help of factory
722      * @return address Contract address of the Module
723      */
724     function deploy(bytes /* _data */) external returns(address) {
725         if(setupCost > 0)
726             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
727         address permissionManager = new GeneralPermissionManager(msg.sender, address(polyToken));
728         emit LogGenerateModuleFromFactory(address(permissionManager), getName(), address(this), msg.sender, now);
729         return address(permissionManager);
730     }
731 
732     /**
733      * @notice Type of the Module factory
734      */
735     function getType() public view returns(uint8) {
736         return 1;
737     }
738 
739     /**
740      * @notice Get the name of the Module
741      */
742     function getName() public view returns(bytes32) {
743         return "GeneralPermissionManager";
744     }
745 
746     /**
747      * @notice Get the description of the Module
748      */
749     function getDescription() public view returns(string) {
750         return "Manage permissions within the Security Token and attached modules";
751     }
752 
753     /**
754      * @notice Get the title of the Module
755      */
756     function getTitle() public  view returns(string) {
757         return "General Permission Manager";
758     }
759 
760     /**
761      * @notice Get the Instructions that helped to used the module
762      */
763     function getInstructions() public view returns(string) {
764         return "Add and remove permissions for the SecurityToken and associated modules. Permission types should be encoded as bytes32 values, and attached using the withPerm modifier to relevant functions.No initFunction required.";
765     }
766 
767     /**
768      * @notice Get the tags related to the module factory
769      */
770     function getTags() public view returns(bytes32[]) {
771         bytes32[] memory availableTags = new bytes32[](0);
772         return availableTags;
773     }
774 }