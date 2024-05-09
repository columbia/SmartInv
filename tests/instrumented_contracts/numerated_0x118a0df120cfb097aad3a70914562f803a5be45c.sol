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
26  * @title ERC20Basic
27  * @dev Simpler version of ERC20 interface
28  * @dev see https://github.com/ethereum/EIPs/issues/179
29  */
30 contract ERC20Basic {
31   function totalSupply() public view returns (uint256);
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 /**
38  * @title ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/20
40  */
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender)
43     public view returns (uint256);
44 
45   function transferFrom(address from, address to, uint256 value)
46     public returns (bool);
47 
48   function approve(address spender, uint256 value) public returns (bool);
49   event Approval(
50     address indexed owner,
51     address indexed spender,
52     uint256 value
53   );
54 }
55 
56 contract IERC20 is ERC20 {
57 
58     function decreaseApproval(
59     address _spender,
60     uint _subtractedValue
61   )
62     public
63     returns (bool);
64 
65     function increaseApproval(
66     address _spender,
67     uint _addedValue
68   )
69     public
70     returns (bool);
71 }
72 
73 /**
74  * @title SafeMath
75  * @dev Math operations with safety checks that throw on error
76  */
77 library SafeMath {
78 
79   /**
80   * @dev Multiplies two numbers, throws on overflow.
81   */
82   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
83     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
84     // benefit is lost if 'b' is also tested.
85     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86     if (a == 0) {
87       return 0;
88     }
89 
90     c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     // uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return a / b;
103   }
104 
105   /**
106   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   uint256 totalSupply_;
133 
134   /**
135   * @dev total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * @dev https://github.com/ethereum/EIPs/issues/20
172  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(
186     address _from,
187     address _to,
188     uint256 _value
189   )
190     public
191     returns (bool)
192   {
193     require(_to != address(0));
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196 
197     balances[_from] = balances[_from].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
200     emit Transfer(_from, _to, _value);
201     return true;
202   }
203 
204   /**
205    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206    *
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint256 _value) public returns (bool) {
215     allowed[msg.sender][_spender] = _value;
216     emit Approval(msg.sender, _spender, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Function to check the amount of tokens that an owner allowed to a spender.
222    * @param _owner address The address which owns the funds.
223    * @param _spender address The address which will spend the funds.
224    * @return A uint256 specifying the amount of tokens still available for the spender.
225    */
226   function allowance(
227     address _owner,
228     address _spender
229    )
230     public
231     view
232     returns (uint256)
233   {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _addedValue The amount of tokens to increase the allowance by.
246    */
247   function increaseApproval(
248     address _spender,
249     uint _addedValue
250   )
251     public
252     returns (bool)
253   {
254     allowed[msg.sender][_spender] = (
255       allowed[msg.sender][_spender].add(_addedValue));
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260   /**
261    * @dev Decrease the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To decrement
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _subtractedValue The amount of tokens to decrease the allowance by.
269    */
270   function decreaseApproval(
271     address _spender,
272     uint _subtractedValue
273   )
274     public
275     returns (bool)
276   {
277     uint oldValue = allowed[msg.sender][_spender];
278     if (_subtractedValue > oldValue) {
279       allowed[msg.sender][_spender] = 0;
280     } else {
281       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
282     }
283     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287 }
288 
289 /**
290  * @title DetailedERC20 token
291  * @dev The decimals are only for visualization purposes.
292  * All the operations are done using the smallest and indivisible token unit,
293  * just as on Ethereum all the operations are done in wei.
294  */
295 contract DetailedERC20 is ERC20 {
296   string public name;
297   string public symbol;
298   uint8 public decimals;
299 
300   constructor(string _name, string _symbol, uint8 _decimals) public {
301     name = _name;
302     symbol = _symbol;
303     decimals = _decimals;
304   }
305 }
306 
307 /**
308  * @title Interface for the ST20 token standard
309  */
310 contract IST20 is StandardToken, DetailedERC20 {
311 
312     // off-chain hash
313     string public tokenDetails;
314 
315     //transfer, transferFrom must respect use respect the result of verifyTransfer
316     function verifyTransfer(address _from, address _to, uint256 _amount) public returns (bool success);
317 
318     /**
319      * @notice mints new tokens and assigns them to the target _investor.
320      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
321      */
322     function mint(address _investor, uint256 _amount) public returns (bool success);
323 
324     /**
325      * @notice Burn function used to burn the securityToken
326      * @param _value No. of token that get burned
327      */
328     function burn(uint256 _value) public;
329 
330     event Minted(address indexed to, uint256 amount);
331     event Burnt(address indexed _burner, uint256 _value);
332 
333 }
334 
335 /**
336  * @title Ownable
337  * @dev The Ownable contract has an owner address, and provides basic authorization control
338  * functions, this simplifies the implementation of "user permissions".
339  */
340 contract Ownable {
341   address public owner;
342 
343 
344   event OwnershipRenounced(address indexed previousOwner);
345   event OwnershipTransferred(
346     address indexed previousOwner,
347     address indexed newOwner
348   );
349 
350 
351   /**
352    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
353    * account.
354    */
355   constructor() public {
356     owner = msg.sender;
357   }
358 
359   /**
360    * @dev Throws if called by any account other than the owner.
361    */
362   modifier onlyOwner() {
363     require(msg.sender == owner);
364     _;
365   }
366 
367   /**
368    * @dev Allows the current owner to relinquish control of the contract.
369    */
370   function renounceOwnership() public onlyOwner {
371     emit OwnershipRenounced(owner);
372     owner = address(0);
373   }
374 
375   /**
376    * @dev Allows the current owner to transfer control of the contract to a newOwner.
377    * @param _newOwner The address to transfer ownership to.
378    */
379   function transferOwnership(address _newOwner) public onlyOwner {
380     _transferOwnership(_newOwner);
381   }
382 
383   /**
384    * @dev Transfers control of the contract to a newOwner.
385    * @param _newOwner The address to transfer ownership to.
386    */
387   function _transferOwnership(address _newOwner) internal {
388     require(_newOwner != address(0));
389     emit OwnershipTransferred(owner, _newOwner);
390     owner = _newOwner;
391   }
392 }
393 
394 /**
395  * @title Interface for all security tokens
396  */
397 contract ISecurityToken is IST20, Ownable {
398 
399     uint8 public constant PERMISSIONMANAGER_KEY = 1;
400     uint8 public constant TRANSFERMANAGER_KEY = 2;
401     uint8 public constant STO_KEY = 3;
402     uint8 public constant CHECKPOINT_KEY = 4;
403     uint256 public granularity;
404 
405     // Value of current checkpoint
406     uint256 public currentCheckpointId;
407 
408     // Total number of non-zero token holders
409     uint256 public investorCount;
410 
411     // List of token holders
412     address[] public investors;
413 
414     // Permissions this to a Permission module, which has a key of 1
415     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
416     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
417     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);
418 
419     /**
420      * @notice returns module list for a module type
421      * @param _moduleType is which type of module we are trying to remove
422      * @param _moduleIndex is the index of the module within the chosen type
423      */
424     function getModule(uint8 _moduleType, uint _moduleIndex) public view returns (bytes32, address);
425 
426     /**
427      * @notice returns module list for a module name - will return first match
428      * @param _moduleType is which type of module we are trying to remove
429      * @param _name is the name of the module within the chosen type
430      */
431     function getModuleByName(uint8 _moduleType, bytes32 _name) public view returns (bytes32, address);
432 
433     /**
434      * @notice Queries totalSupply as of a defined checkpoint
435      * @param _checkpointId Checkpoint ID to query as of
436      */
437     function totalSupplyAt(uint256 _checkpointId) public view returns(uint256);
438 
439     /**
440      * @notice Queries balances as of a defined checkpoint
441      * @param _investor Investor to query balance for
442      * @param _checkpointId Checkpoint ID to query as of
443      */
444     function balanceOfAt(address _investor, uint256 _checkpointId) public view returns(uint256);
445 
446     /**
447      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
448      */
449     function createCheckpoint() public returns(uint256);
450 
451     /**
452      * @notice gets length of investors array
453      * NB - this length may differ from investorCount if list has not been pruned of zero balance investors
454      * @return length
455      */
456     function getInvestorsLength() public view returns(uint256);
457 
458 }
459 
460 /**
461  * @title Interface that any module factory contract should implement
462  */
463 contract IModuleFactory is Ownable {
464 
465     ERC20 public polyToken;
466     uint256 public setupCost;
467     uint256 public usageCost;
468     uint256 public monthlySubscriptionCost;
469 
470     event LogChangeFactorySetupFee(uint256 _oldSetupcost, uint256 _newSetupCost, address _moduleFactory);
471     event LogChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
472     event LogChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
473     event LogGenerateModuleFromFactory(address _module, bytes32 indexed _moduleName, address indexed _moduleFactory, address _creator, uint256 _timestamp);
474 
475     /**
476      * @notice Constructor
477      * @param _polyAddress Address of the polytoken
478      */
479     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
480       polyToken = ERC20(_polyAddress);
481       setupCost = _setupCost;
482       usageCost = _usageCost;
483       monthlySubscriptionCost = _subscriptionCost;
484     }
485 
486     //Should create an instance of the Module, or throw
487     function deploy(bytes _data) external returns(address);
488 
489     /**
490      * @notice Type of the Module factory
491      */
492     function getType() public view returns(uint8);
493 
494     /**
495      * @notice Get the name of the Module
496      */
497     function getName() public view returns(bytes32);
498 
499     /**
500      * @notice Get the description of the Module
501      */
502     function getDescription() public view returns(string);
503 
504     /**
505      * @notice Get the title of the Module
506      */
507     function getTitle() public view returns(string);
508 
509     /**
510      * @notice Get the Instructions that helped to used the module
511      */
512     function getInstructions() public view returns (string);
513 
514     /**
515      * @notice Get the tags related to the module factory
516      */
517     function getTags() public view returns (bytes32[]);
518 
519     //Pull function sig from _data
520     function getSig(bytes _data) internal pure returns (bytes4 sig) {
521         uint len = _data.length < 4 ? _data.length : 4;
522         for (uint i = 0; i < len; i++) {
523             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
524         }
525     }
526 
527     /**
528      * @notice used to change the fee of the setup cost
529      * @param _newSetupCost new setup cost
530      */
531     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
532         emit LogChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
533         setupCost = _newSetupCost;
534     }
535 
536     /**
537      * @notice used to change the fee of the usage cost
538      * @param _newUsageCost new usage cost
539      */
540     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
541         emit LogChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
542         usageCost = _newUsageCost;
543     }
544 
545     /**
546      * @notice used to change the fee of the subscription cost
547      * @param _newSubscriptionCost new subscription cost
548      */
549     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
550         emit LogChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
551         monthlySubscriptionCost = _newSubscriptionCost;
552         
553     }
554 
555 }
556 
557 /**
558  * @title Interface that any module contract should implement
559  */
560 contract IModule {
561 
562     address public factory;
563 
564     address public securityToken;
565 
566     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
567 
568     ERC20 public polyToken;
569 
570     /**
571      * @notice Constructor
572      * @param _securityToken Address of the security token
573      * @param _polyAddress Address of the polytoken
574      */
575     constructor (address _securityToken, address _polyAddress) public {
576         securityToken = _securityToken;
577         factory = msg.sender;
578         polyToken = ERC20(_polyAddress);
579     }
580 
581     /**
582      * @notice This function returns the signature of configure function
583      */
584     function getInitFunction() public pure returns (bytes4);
585 
586     //Allows owner, factory or permissioned delegate
587     modifier withPerm(bytes32 _perm) {
588         bool isOwner = msg.sender == ISecurityToken(securityToken).owner();
589         bool isFactory = msg.sender == factory;
590         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
591         _;
592     }
593 
594     modifier onlyOwner {
595         require(msg.sender == ISecurityToken(securityToken).owner(), "Sender is not owner");
596         _;
597     }
598 
599     modifier onlyFactory {
600         require(msg.sender == factory, "Sender is not factory");
601         _;
602     }
603 
604     modifier onlyFactoryOwner {
605         require(msg.sender == IModuleFactory(factory).owner(), "Sender is not factory owner");
606         _;
607     }
608 
609     /**
610      * @notice Return the permissions flag that are associated with Module
611      */
612     function getPermissions() public view returns(bytes32[]);
613 
614     /**
615      * @notice used to withdraw the fee by the factory owner
616      */
617     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
618         require(polyToken.transferFrom(address(this), IModuleFactory(factory).owner(), _amount), "Unable to take fee");
619         return true;
620     }
621 }
622 
623 /**
624  * @title Interface for the polymath module registry contract
625  */
626 contract IModuleRegistry {
627 
628     /**
629      * @notice Called by a security token to notify the registry it is using a module
630      * @param _moduleFactory is the address of the relevant module factory
631      */
632     function useModule(address _moduleFactory) external;
633 
634     /**
635      * @notice Called by moduleFactory owner to register new modules for SecurityToken to use
636      * @param _moduleFactory is the address of the module factory to be registered
637      */
638     function registerModule(address _moduleFactory) external returns(bool);
639 
640     /**
641      * @notice Use to get all the tags releated to the functionality of the Module Factory.
642      * @param _moduleType Type of module
643      */
644     function getTagByModuleType(uint8 _moduleType) public view returns(bytes32[]);
645 
646 }
647 
648 /**
649  * @title Utility contract to allow pausing and unpausing of certain functions
650  */
651 contract Pausable {
652 
653     event Pause(uint256 _timestammp);
654     event Unpause(uint256 _timestamp);
655 
656     bool public paused = false;
657 
658     /**
659     * @notice Modifier to make a function callable only when the contract is not paused.
660     */
661     modifier whenNotPaused() {
662         require(!paused);
663         _;
664     }
665 
666     /**
667     * @notice Modifier to make a function callable only when the contract is paused.
668     */
669     modifier whenPaused() {
670         require(paused);
671         _;
672     }
673 
674    /**
675     * @notice called by the owner to pause, triggers stopped state
676     */
677     function _pause() internal {
678         require(!paused);
679         paused = true;
680         emit Pause(now);
681     }
682 
683     /**
684     * @notice called by the owner to unpause, returns to normal state
685     */
686     function _unpause() internal {
687         require(paused);
688         paused = false;
689         emit Unpause(now);
690     }
691 
692 }
693 
694 /**
695  * @title Interface to be implemented by all Transfer Manager modules
696  */
697 contract ITransferManager is IModule, Pausable {
698 
699     //If verifyTransfer returns:
700     //  FORCE_VALID, the transaction will always be valid, regardless of other TM results
701     //  INVALID, then the transfer should not be allowed regardless of other TM results
702     //  VALID, then the transfer is valid for this TM
703     //  NA, then the result from this TM is ignored
704     enum Result {INVALID, NA, VALID, FORCE_VALID}
705 
706     function verifyTransfer(address _from, address _to, uint256 _amount, bool _isTransfer) public returns(Result);
707 
708     function unpause() onlyOwner public {
709         super._unpause();
710     }
711 
712     function pause() onlyOwner public {
713         super._pause();
714     }
715 }
716 
717 /**
718  * @title Interface to be implemented by all permission manager modules
719  */
720 contract IPermissionManager is IModule {
721 
722     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);
723 
724     function changePermission(address _delegate, address _module, bytes32 _perm, bool _valid) public returns(bool);
725 
726     function getDelegateDetails(address _delegate) public view returns(bytes32);
727 
728 }
729 
730 /**
731  * @title Interface for the token burner contract
732  */
733 interface ITokenBurner {
734 
735     function burn(address _burner, uint256  _value ) external returns(bool);
736 
737 }
738 
739 /**
740  * @title Utility contract to allow owner to retreive any ERC20 sent to the contract
741  */
742 contract ReclaimTokens is Ownable {
743 
744     /**
745     * @notice Reclaim all ERC20Basic compatible tokens
746     * @param _tokenContract The address of the token contract
747     */
748     function reclaimERC20(address _tokenContract) external onlyOwner {
749         require(_tokenContract != address(0));
750         ERC20Basic token = ERC20Basic(_tokenContract);
751         uint256 balance = token.balanceOf(address(this));
752         require(token.transfer(owner, balance));
753     }
754 }
755 
756 /**
757  * @title Core functionality for registry upgradability
758  */
759 contract PolymathRegistry is ReclaimTokens {
760 
761     mapping (bytes32 => address) public storedAddresses;
762 
763     event LogChangeAddress(string _nameKey, address indexed _oldAddress, address indexed _newAddress);
764 
765     /**
766      * @notice Get the contract address
767      * @param _nameKey is the key for the contract address mapping
768      * @return address
769      */
770     function getAddress(string _nameKey) view public returns(address) {
771         bytes32 key = keccak256(bytes(_nameKey));
772         require(storedAddresses[key] != address(0), "Invalid address key");
773         return storedAddresses[key];
774     }
775 
776     /**
777      * @notice change the contract address
778      * @param _nameKey is the key for the contract address mapping
779      * @param _newAddress is the new contract address
780      */
781     function changeAddress(string _nameKey, address _newAddress) public onlyOwner {
782         bytes32 key = keccak256(bytes(_nameKey));
783         emit LogChangeAddress(_nameKey, storedAddresses[key], _newAddress);
784         storedAddresses[key] = _newAddress;
785     }
786 
787 
788 }
789 
790 contract RegistryUpdater is Ownable {
791 
792     address public polymathRegistry;
793     address public moduleRegistry;
794     address public securityTokenRegistry;
795     address public tickerRegistry;
796     address public polyToken;
797 
798     constructor (address _polymathRegistry) public {
799         require(_polymathRegistry != address(0));
800         polymathRegistry = _polymathRegistry;
801     }
802 
803     function updateFromRegistry() onlyOwner public {
804         moduleRegistry = PolymathRegistry(polymathRegistry).getAddress("ModuleRegistry");
805         securityTokenRegistry = PolymathRegistry(polymathRegistry).getAddress("SecurityTokenRegistry");
806         tickerRegistry = PolymathRegistry(polymathRegistry).getAddress("TickerRegistry");
807         polyToken = PolymathRegistry(polymathRegistry).getAddress("PolyToken");
808     }
809 
810 }
811 
812 /**
813  * @title Helps contracts guard agains reentrancy attacks.
814  * @author Remco Bloemen <remco@2π.com>
815  * @notice If you mark a function `nonReentrant`, you should also
816  * mark it `external`.
817  */
818 contract ReentrancyGuard {
819 
820   /**
821    * @dev We use a single lock for the whole contract.
822    */
823   bool private reentrancyLock = false;
824 
825   /**
826    * @dev Prevents a contract from calling itself, directly or indirectly.
827    * @notice If you mark a function `nonReentrant`, you should also
828    * mark it `external`. Calling one nonReentrant function from
829    * another is not supported. Instead, you can implement a
830    * `private` function doing the actual work, and a `external`
831    * wrapper marked as `nonReentrant`.
832    */
833   modifier nonReentrant() {
834     require(!reentrancyLock);
835     reentrancyLock = true;
836     _;
837     reentrancyLock = false;
838   }
839 
840 }
841 
842 /**
843 * @title Security Token contract
844 * @notice SecurityToken is an ERC20 token with added capabilities:
845 * @notice - Implements the ST-20 Interface
846 * @notice - Transfers are restricted
847 * @notice - Modules can be attached to it to control its behaviour
848 * @notice - ST should not be deployed directly, but rather the SecurityTokenRegistry should be used
849 */
850 contract SecurityToken is ISecurityToken, ReentrancyGuard, RegistryUpdater {
851     using SafeMath for uint256;
852 
853     bytes32 public constant securityTokenVersion = "0.0.1";
854 
855     // Reference to token burner contract
856     ITokenBurner public tokenBurner;
857 
858     // Use to halt all the transactions
859     bool public freeze = false;
860 
861     struct ModuleData {
862         bytes32 name;
863         address moduleAddress;
864     }
865 
866     // Structures to maintain checkpoints of balances for governance / dividends
867     struct Checkpoint {
868         uint256 checkpointId;
869         uint256 value;
870     }
871 
872     mapping (address => Checkpoint[]) public checkpointBalances;
873     Checkpoint[] public checkpointTotalSupply;
874 
875     bool public finishedIssuerMinting = false;
876     bool public finishedSTOMinting = false;
877 
878     mapping (bytes4 => bool) transferFunctions;
879 
880     // Module list should be order agnostic!
881     mapping (uint8 => ModuleData[]) public modules;
882 
883     uint8 public constant MAX_MODULES = 20;
884 
885     mapping (address => bool) public investorListed;
886 
887     // Emit at the time when module get added
888     event LogModuleAdded(
889         uint8 indexed _type,
890         bytes32 _name,
891         address _moduleFactory,
892         address _module,
893         uint256 _moduleCost,
894         uint256 _budget,
895         uint256 _timestamp
896     );
897 
898     // Emit when the token details get updated
899     event LogUpdateTokenDetails(string _oldDetails, string _newDetails);
900     // Emit when the granularity get changed
901     event LogGranularityChanged(uint256 _oldGranularity, uint256 _newGranularity);
902     // Emit when Module get removed from the securityToken
903     event LogModuleRemoved(uint8 indexed _type, address _module, uint256 _timestamp);
904     // Emit when the budget allocated to a module is changed
905     event LogModuleBudgetChanged(uint8 indexed _moduleType, address _module, uint256 _budget);
906     // Emit when all the transfers get freeze
907     event LogFreezeTransfers(bool _freeze, uint256 _timestamp);
908     // Emit when new checkpoint created
909     event LogCheckpointCreated(uint256 indexed _checkpointId, uint256 _timestamp);
910     // Emit when the minting get finished for the Issuer
911     event LogFinishMintingIssuer(uint256 _timestamp);
912     // Emit when the minting get finished for the STOs
913     event LogFinishMintingSTO(uint256 _timestamp);
914     // Change the STR address in the event of a upgrade
915     event LogChangeSTRAddress(address indexed _oldAddress, address indexed _newAddress);
916 
917     // If _fallback is true, then for STO module type we only allow the module if it is set, if it is not set we only allow the owner
918     // for other _moduleType we allow both issuer and module.
919     modifier onlyModule(uint8 _moduleType, bool _fallback) {
920       //Loop over all modules of type _moduleType
921         bool isModuleType = false;
922         for (uint8 i = 0; i < modules[_moduleType].length; i++) {
923             isModuleType = isModuleType || (modules[_moduleType][i].moduleAddress == msg.sender);
924         }
925         if (_fallback && !isModuleType) {
926             if (_moduleType == STO_KEY)
927                 require(modules[_moduleType].length == 0 && msg.sender == owner, "Sender is not owner or STO module is attached");
928             else
929                 require(msg.sender == owner, "Sender is not owner");
930         } else {
931             require(isModuleType, "Sender is not correct module type");
932         }
933         _;
934     }
935 
936     modifier checkGranularity(uint256 _amount) {
937         require(_amount % granularity == 0, "Unable to modify token balances at this granularity");
938         _;
939     }
940 
941     // Checks whether the minting is allowed or not, check for the owner if owner is no the msg.sender then check
942     // for the finishedSTOMinting flag because only STOs and owner are allowed for minting
943     modifier isMintingAllowed() {
944         if (msg.sender == owner) {
945             require(!finishedIssuerMinting, "Minting is finished for Issuer");
946         } else {
947             require(!finishedSTOMinting, "Minting is finished for STOs");
948         }
949         _;
950     }
951 
952     /**
953      * @notice Constructor
954      * @param _name Name of the SecurityToken
955      * @param _symbol Symbol of the Token
956      * @param _decimals Decimals for the securityToken
957      * @param _granularity granular level of the token
958      * @param _tokenDetails Details of the token that are stored off-chain (IPFS hash)
959      * @param _polymathRegistry Contract address of the polymath registry
960      */
961     constructor (
962         string _name,
963         string _symbol,
964         uint8 _decimals,
965         uint256 _granularity,
966         string _tokenDetails,
967         address _polymathRegistry
968     )
969     public
970     DetailedERC20(_name, _symbol, _decimals)
971     RegistryUpdater(_polymathRegistry)
972     {
973         //When it is created, the owner is the STR
974         updateFromRegistry();
975         tokenDetails = _tokenDetails;
976         granularity = _granularity;
977         transferFunctions[bytes4(keccak256("transfer(address,uint256)"))] = true;
978         transferFunctions[bytes4(keccak256("transferFrom(address,address,uint256)"))] = true;
979         transferFunctions[bytes4(keccak256("mint(address,uint256)"))] = true;
980         transferFunctions[bytes4(keccak256("burn(uint256)"))] = true;
981     }
982 
983     /**
984      * @notice Function used to attach the module in security token
985      * @param _moduleFactory Contract address of the module factory that needs to be attached
986      * @param _data Data used for the intialization of the module factory variables
987      * @param _maxCost Maximum cost of the Module factory
988      * @param _budget Budget of the Module factory
989      */
990     function addModule(
991         address _moduleFactory,
992         bytes _data,
993         uint256 _maxCost,
994         uint256 _budget
995     ) external onlyOwner nonReentrant {
996         _addModule(_moduleFactory, _data, _maxCost, _budget);
997     }
998 
999     /**
1000     * @notice _addModule handles the attachment (or replacement) of modules for the ST
1001     * @dev  E.G.: On deployment (through the STR) ST gets a TransferManager module attached to it
1002     * @dev to control restrictions on transfers.
1003     * @dev You are allowed to add a new moduleType if:
1004     * @dev - there is no existing module of that type yet added
1005     * @dev - the last member of the module list is replacable
1006     * @param _moduleFactory is the address of the module factory to be added
1007     * @param _data is data packed into bytes used to further configure the module (See STO usage)
1008     * @param _maxCost max amount of POLY willing to pay to module. (WIP)
1009     */
1010     function _addModule(address _moduleFactory, bytes _data, uint256 _maxCost, uint256 _budget) internal {
1011         //Check that module exists in registry - will throw otherwise
1012         IModuleRegistry(moduleRegistry).useModule(_moduleFactory);
1013         IModuleFactory moduleFactory = IModuleFactory(_moduleFactory);
1014         uint8 moduleType = moduleFactory.getType();
1015         require(modules[moduleType].length < MAX_MODULES, "Limit of MAX MODULES is reached");
1016         uint256 moduleCost = moduleFactory.setupCost();
1017         require(moduleCost <= _maxCost, "Max Cost is always be greater than module cost");
1018         //Approve fee for module
1019         require(ERC20(polyToken).approve(_moduleFactory, moduleCost), "Not able to approve the module cost");
1020         //Creates instance of module from factory
1021         address module = moduleFactory.deploy(_data);
1022         //Approve ongoing budget
1023         require(ERC20(polyToken).approve(module, _budget), "Not able to approve the budget");
1024         //Add to SecurityToken module map
1025         bytes32 moduleName = moduleFactory.getName();
1026         modules[moduleType].push(ModuleData(moduleName, module));
1027         //Emit log event
1028         emit LogModuleAdded(moduleType, moduleName, _moduleFactory, module, moduleCost, _budget, now);
1029     }
1030 
1031     /**
1032     * @notice Removes a module attached to the SecurityToken
1033     * @param _moduleType is which type of module we are trying to remove
1034     * @param _moduleIndex is the index of the module within the chosen type
1035     */
1036     function removeModule(uint8 _moduleType, uint8 _moduleIndex) external onlyOwner {
1037         require(_moduleIndex < modules[_moduleType].length,
1038         "Module index doesn't exist as per the choosen module type");
1039         require(modules[_moduleType][_moduleIndex].moduleAddress != address(0),
1040         "Module contract address should not be 0x");
1041         //Take the last member of the list, and replace _moduleIndex with this, then shorten the list by one
1042         emit LogModuleRemoved(_moduleType, modules[_moduleType][_moduleIndex].moduleAddress, now);
1043         modules[_moduleType][_moduleIndex] = modules[_moduleType][modules[_moduleType].length - 1];
1044         modules[_moduleType].length = modules[_moduleType].length - 1;
1045     }
1046 
1047     /**
1048      * @notice Returns module list for a module type
1049      * @param _moduleType is which type of module we are trying to get
1050      * @param _moduleIndex is the index of the module within the chosen type
1051      * @return bytes32
1052      * @return address
1053      */
1054     function getModule(uint8 _moduleType, uint _moduleIndex) public view returns (bytes32, address) {
1055         if (modules[_moduleType].length > 0) {
1056             return (
1057                 modules[_moduleType][_moduleIndex].name,
1058                 modules[_moduleType][_moduleIndex].moduleAddress
1059             );
1060         } else {
1061             return ("", address(0));
1062         }
1063 
1064     }
1065 
1066     /**
1067      * @notice returns module list for a module name - will return first match
1068      * @param _moduleType is which type of module we are trying to get
1069      * @param _name is the name of the module within the chosen type
1070      * @return bytes32
1071      * @return address
1072      */
1073     function getModuleByName(uint8 _moduleType, bytes32 _name) public view returns (bytes32, address) {
1074         if (modules[_moduleType].length > 0) {
1075             for (uint256 i = 0; i < modules[_moduleType].length; i++) {
1076                 if (modules[_moduleType][i].name == _name) {
1077                   return (
1078                       modules[_moduleType][i].name,
1079                       modules[_moduleType][i].moduleAddress
1080                   );
1081                 }
1082             }
1083             return ("", address(0));
1084         } else {
1085             return ("", address(0));
1086         }
1087     }
1088 
1089     /**
1090     * @notice allows the owner to withdraw unspent POLY stored by them on the ST.
1091     * @dev Owner can transfer POLY to the ST which will be used to pay for modules that require a POLY fee.
1092     * @param _amount amount of POLY to withdraw
1093     */
1094     function withdrawPoly(uint256 _amount) public onlyOwner {
1095         require(ERC20(polyToken).transfer(owner, _amount), "In-sufficient balance");
1096     }
1097 
1098     /**
1099     * @notice allows owner to approve more POLY to one of the modules
1100     * @param _moduleType module type
1101     * @param _moduleIndex module index
1102     * @param _budget new budget
1103     */
1104     function changeModuleBudget(uint8 _moduleType, uint8 _moduleIndex, uint256 _budget) public onlyOwner {
1105         require(_moduleType != 0, "Module type cannot be zero");
1106         require(_moduleIndex < modules[_moduleType].length, "Incorrrect module index");
1107         uint256 _currentAllowance = IERC20(polyToken).allowance(address(this), modules[_moduleType][_moduleIndex].moduleAddress);
1108         if (_budget < _currentAllowance) {
1109             require(IERC20(polyToken).decreaseApproval(modules[_moduleType][_moduleIndex].moduleAddress, _currentAllowance.sub(_budget)), "Insufficient balance to decreaseApproval");
1110         } else {
1111             require(IERC20(polyToken).increaseApproval(modules[_moduleType][_moduleIndex].moduleAddress, _budget.sub(_currentAllowance)), "Insufficient balance to increaseApproval");
1112         }
1113         emit LogModuleBudgetChanged(_moduleType, modules[_moduleType][_moduleIndex].moduleAddress, _budget);
1114     }
1115 
1116     /**
1117      * @notice change the tokenDetails
1118      * @param _newTokenDetails New token details
1119      */
1120     function updateTokenDetails(string _newTokenDetails) public onlyOwner {
1121         emit LogUpdateTokenDetails(tokenDetails, _newTokenDetails);
1122         tokenDetails = _newTokenDetails;
1123     }
1124 
1125     /**
1126     * @notice allows owner to change token granularity
1127     * @param _granularity granularity level of the token
1128     */
1129     function changeGranularity(uint256 _granularity) public onlyOwner {
1130         require(_granularity != 0, "Granularity can not be 0");
1131         emit LogGranularityChanged(granularity, _granularity);
1132         granularity = _granularity;
1133     }
1134 
1135     /**
1136     * @notice keeps track of the number of non-zero token holders
1137     * @param _from sender of transfer
1138     * @param _to receiver of transfer
1139     * @param _value value of transfer
1140     */
1141     function adjustInvestorCount(address _from, address _to, uint256 _value) internal {
1142         if ((_value == 0) || (_from == _to)) {
1143             return;
1144         }
1145         // Check whether receiver is a new token holder
1146         if ((balanceOf(_to) == 0) && (_to != address(0))) {
1147             investorCount = investorCount.add(1);
1148         }
1149         // Check whether sender is moving all of their tokens
1150         if (_value == balanceOf(_from)) {
1151             investorCount = investorCount.sub(1);
1152         }
1153         //Also adjust investor list
1154         if (!investorListed[_to] && (_to != address(0))) {
1155             investors.push(_to);
1156             investorListed[_to] = true;
1157         }
1158 
1159     }
1160 
1161     /**
1162     * @notice removes addresses with zero balances from the investors list
1163     * @param _start Index in investor list at which to start removing zero balances
1164     * @param _iters Max number of iterations of the for loop
1165     * NB - pruning this list will mean you may not be able to iterate over investors on-chain as of a historical checkpoint
1166     */
1167     function pruneInvestors(uint256 _start, uint256 _iters) public onlyOwner {
1168         for (uint256 i = _start; i < Math.min256(_start.add(_iters), investors.length); i++) {
1169             if ((i < investors.length) && (balanceOf(investors[i]) == 0)) {
1170                 investorListed[investors[i]] = false;
1171                 investors[i] = investors[investors.length - 1];
1172                 investors.length--;
1173             }
1174         }
1175     }
1176 
1177     /**
1178      * @notice gets length of investors array
1179      * NB - this length may differ from investorCount if list has not been pruned of zero balance investors
1180      * @return length
1181      */
1182     function getInvestorsLength() public view returns(uint256) {
1183         return investors.length;
1184     }
1185 
1186     /**
1187      * @notice freeze all the transfers
1188      */
1189     function freezeTransfers() public onlyOwner {
1190         require(!freeze);
1191         freeze = true;
1192         emit LogFreezeTransfers(freeze, now);
1193     }
1194 
1195     /**
1196      * @notice un-freeze all the transfers
1197      */
1198     function unfreezeTransfers() public onlyOwner {
1199         require(freeze);
1200         freeze = false;
1201         emit LogFreezeTransfers(freeze, now);
1202     }
1203 
1204     /**
1205      * @notice adjust totalsupply at checkpoint after minting or burning tokens
1206      */
1207     function adjustTotalSupplyCheckpoints() internal {
1208         adjustCheckpoints(checkpointTotalSupply, totalSupply());
1209     }
1210 
1211     /**
1212      * @notice adjust token holder balance at checkpoint after a token transfer
1213      * @param _investor address of the token holder affected
1214      */
1215     function adjustBalanceCheckpoints(address _investor) internal {
1216         adjustCheckpoints(checkpointBalances[_investor], balanceOf(_investor));
1217     }
1218 
1219     /**
1220      * @notice store the changes to the checkpoint objects
1221      * @param _checkpoints the affected checkpoint object array
1222      * @param _newValue the new value that needs to be stored
1223      */
1224     function adjustCheckpoints(Checkpoint[] storage _checkpoints, uint256 _newValue) internal {
1225         //No checkpoints set yet
1226         if (currentCheckpointId == 0) {
1227             return;
1228         }
1229         //No previous checkpoint data - add current balance against checkpoint
1230         if (_checkpoints.length == 0) {
1231             _checkpoints.push(
1232                 Checkpoint({
1233                     checkpointId: currentCheckpointId,
1234                     value: _newValue
1235                 })
1236             );
1237             return;
1238         }
1239         //No new checkpoints since last update
1240         if (_checkpoints[_checkpoints.length - 1].checkpointId == currentCheckpointId) {
1241             return;
1242         }
1243         //New checkpoint, so record balance
1244         _checkpoints.push(
1245             Checkpoint({
1246                 checkpointId: currentCheckpointId,
1247                 value: _newValue
1248             })
1249         );
1250     }
1251 
1252     /**
1253      * @notice Overloaded version of the transfer function
1254      * @param _to receiver of transfer
1255      * @param _value value of transfer
1256      * @return bool success
1257      */
1258     function transfer(address _to, uint256 _value) public returns (bool success) {
1259         adjustInvestorCount(msg.sender, _to, _value);
1260         require(verifyTransfer(msg.sender, _to, _value), "Transfer is not valid");
1261         adjustBalanceCheckpoints(msg.sender);
1262         adjustBalanceCheckpoints(_to);
1263         require(super.transfer(_to, _value));
1264         return true;
1265     }
1266 
1267     /**
1268      * @notice Overloaded version of the transferFrom function
1269      * @param _from sender of transfer
1270      * @param _to receiver of transfer
1271      * @param _value value of transfer
1272      * @return bool success
1273      */
1274     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1275         adjustInvestorCount(_from, _to, _value);
1276         require(verifyTransfer(_from, _to, _value), "Transfer is not valid");
1277         adjustBalanceCheckpoints(_from);
1278         adjustBalanceCheckpoints(_to);
1279         require(super.transferFrom(_from, _to, _value));
1280         return true;
1281     }
1282 
1283     /**
1284      * @notice validate transfer with TransferManager module if it exists
1285      * @dev TransferManager module has a key of 2
1286      * @param _from sender of transfer
1287      * @param _to receiver of transfer
1288      * @param _amount value of transfer
1289      * @return bool
1290      */
1291     function verifyTransfer(address _from, address _to, uint256 _amount) public checkGranularity(_amount) returns (bool) {
1292         if (!freeze) {
1293             bool isTransfer = false;
1294             if (transferFunctions[getSig(msg.data)]) {
1295               isTransfer = true;
1296             }
1297             if (modules[TRANSFERMANAGER_KEY].length == 0) {
1298                 return true;
1299             }
1300             bool isInvalid = false;
1301             bool isValid = false;
1302             bool isForceValid = false;
1303             for (uint8 i = 0; i < modules[TRANSFERMANAGER_KEY].length; i++) {
1304                 ITransferManager.Result valid = ITransferManager(modules[TRANSFERMANAGER_KEY][i].moduleAddress).verifyTransfer(_from, _to, _amount, isTransfer);
1305                 if (valid == ITransferManager.Result.INVALID) {
1306                     isInvalid = true;
1307                 }
1308                 if (valid == ITransferManager.Result.VALID) {
1309                     isValid = true;
1310                 }
1311                 if (valid == ITransferManager.Result.FORCE_VALID) {
1312                     isForceValid = true;
1313                 }
1314             }
1315             return isForceValid ? true : (isInvalid ? false : isValid);
1316       }
1317       return false;
1318     }
1319 
1320     /**
1321      * @notice End token minting period permanently for Issuer
1322      */
1323     function finishMintingIssuer() public onlyOwner {
1324         finishedIssuerMinting = true;
1325         emit LogFinishMintingIssuer(now);
1326     }
1327 
1328     /**
1329      * @notice End token minting period permanently for STOs
1330      */
1331     function finishMintingSTO() public onlyOwner {
1332         finishedSTOMinting = true;
1333         emit LogFinishMintingSTO(now);
1334     }
1335 
1336     /**
1337      * @notice mints new tokens and assigns them to the target _investor.
1338      * @dev Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
1339      * @param _investor Address to whom the minted tokens will be dilivered
1340      * @param _amount Number of tokens get minted
1341      * @return success
1342      */
1343     function mint(address _investor, uint256 _amount) public onlyModule(STO_KEY, true) checkGranularity(_amount) isMintingAllowed() returns (bool success) {
1344         require(_investor != address(0), "Investor address should not be 0x");
1345         adjustInvestorCount(address(0), _investor, _amount);
1346         require(verifyTransfer(address(0), _investor, _amount), "Transfer is not valid");
1347         adjustBalanceCheckpoints(_investor);
1348         adjustTotalSupplyCheckpoints();
1349         totalSupply_ = totalSupply_.add(_amount);
1350         balances[_investor] = balances[_investor].add(_amount);
1351         emit Minted(_investor, _amount);
1352         emit Transfer(address(0), _investor, _amount);
1353         return true;
1354     }
1355 
1356     /**
1357      * @notice mints new tokens and assigns them to the target _investor.
1358      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
1359      * @param _investors A list of addresses to whom the minted tokens will be dilivered
1360      * @param _amounts A list of number of tokens get minted and transfer to corresponding address of the investor from _investor[] list
1361      * @return success
1362      */
1363     function mintMulti(address[] _investors, uint256[] _amounts) public onlyModule(STO_KEY, true) returns (bool success) {
1364         require(_investors.length == _amounts.length, "Mis-match in the length of the arrays");
1365         for (uint256 i = 0; i < _investors.length; i++) {
1366             mint(_investors[i], _amounts[i]);
1367         }
1368         return true;
1369     }
1370 
1371     /**
1372      * @notice Validate permissions with PermissionManager if it exists, If no Permission return false
1373      * @dev Note that IModule withPerm will allow ST owner all permissions anyway
1374      * @dev this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
1375      * @param _delegate address of delegate
1376      * @param _module address of PermissionManager module
1377      * @param _perm the permissions
1378      * @return success
1379      */
1380     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool) {
1381         if (modules[PERMISSIONMANAGER_KEY].length == 0) {
1382             return false;
1383         }
1384 
1385         for (uint8 i = 0; i < modules[PERMISSIONMANAGER_KEY].length; i++) {
1386             if (IPermissionManager(modules[PERMISSIONMANAGER_KEY][i].moduleAddress).checkPermission(_delegate, _module, _perm)) {
1387                 return true;
1388             }
1389         }
1390     }
1391 
1392     /**
1393      * @notice used to set the token Burner address. It only be called by the owner
1394      * @param _tokenBurner Address of the token burner contract
1395      */
1396     function setTokenBurner(address _tokenBurner) public onlyOwner {
1397         tokenBurner = ITokenBurner(_tokenBurner);
1398     }
1399 
1400     /**
1401      * @notice Burn function used to burn the securityToken
1402      * @param _value No. of token that get burned
1403      */
1404     function burn(uint256 _value) checkGranularity(_value) public {
1405         adjustInvestorCount(msg.sender, address(0), _value);
1406         require(tokenBurner != address(0), "Token Burner contract address is not set yet");
1407         require(verifyTransfer(msg.sender, address(0), _value), "Transfer is not valid");
1408         require(_value <= balances[msg.sender], "Value should no be greater than the balance of msg.sender");
1409         adjustBalanceCheckpoints(msg.sender);
1410         adjustTotalSupplyCheckpoints();
1411         // no need to require value <= totalSupply, since that would imply the
1412         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1413 
1414         balances[msg.sender] = balances[msg.sender].sub(_value);
1415         require(tokenBurner.burn(msg.sender, _value), "Token burner process is not validated");
1416         totalSupply_ = totalSupply_.sub(_value);
1417         emit Burnt(msg.sender, _value);
1418         emit Transfer(msg.sender, address(0), _value);
1419     }
1420 
1421     /**
1422      * @notice Get function signature from _data
1423      * @param _data passed data
1424      * @return bytes4 sig
1425      */
1426     function getSig(bytes _data) internal pure returns (bytes4 sig) {
1427         uint len = _data.length < 4 ? _data.length : 4;
1428         for (uint i = 0; i < len; i++) {
1429             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
1430         }
1431     }
1432 
1433     /**
1434      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
1435      * @return uint256
1436      */
1437     function createCheckpoint() public onlyModule(CHECKPOINT_KEY, true) returns(uint256) {
1438         require(currentCheckpointId < 2**256 - 1);
1439         currentCheckpointId = currentCheckpointId + 1;
1440         emit LogCheckpointCreated(currentCheckpointId, now);
1441         return currentCheckpointId;
1442     }
1443 
1444     /**
1445      * @notice Queries totalSupply as of a defined checkpoint
1446      * @param _checkpointId Checkpoint ID to query
1447      * @return uint256
1448      */
1449     function totalSupplyAt(uint256 _checkpointId) public view returns(uint256) {
1450         return getValueAt(checkpointTotalSupply, _checkpointId, totalSupply());
1451     }
1452 
1453     /**
1454      * @notice Queries value at a defined checkpoint
1455      * @param checkpoints is array of Checkpoint objects
1456      * @param _checkpointId Checkpoint ID to query
1457      * @param _currentValue Current value of checkpoint
1458      * @return uint256
1459      */
1460     function getValueAt(Checkpoint[] storage checkpoints, uint256 _checkpointId, uint256 _currentValue) internal view returns(uint256) {
1461         require(_checkpointId <= currentCheckpointId);
1462         //Checkpoint id 0 is when the token is first created - everyone has a zero balance
1463         if (_checkpointId == 0) {
1464           return 0;
1465         }
1466         if (checkpoints.length == 0) {
1467             return _currentValue;
1468         }
1469         if (checkpoints[0].checkpointId >= _checkpointId) {
1470             return checkpoints[0].value;
1471         }
1472         if (checkpoints[checkpoints.length - 1].checkpointId < _checkpointId) {
1473             return _currentValue;
1474         }
1475         if (checkpoints[checkpoints.length - 1].checkpointId == _checkpointId) {
1476             return checkpoints[checkpoints.length - 1].value;
1477         }
1478         uint256 min = 0;
1479         uint256 max = checkpoints.length - 1;
1480         while (max > min) {
1481             uint256 mid = (max + min) / 2;
1482             if (checkpoints[mid].checkpointId == _checkpointId) {
1483                 max = mid;
1484                 break;
1485             }
1486             if (checkpoints[mid].checkpointId < _checkpointId) {
1487                 min = mid + 1;
1488             } else {
1489                 max = mid;
1490             }
1491         }
1492         return checkpoints[max].value;
1493     }
1494 
1495     /**
1496      * @notice Queries balances as of a defined checkpoint
1497      * @param _investor Investor to query balance for
1498      * @param _checkpointId Checkpoint ID to query as of
1499      */
1500     function balanceOfAt(address _investor, uint256 _checkpointId) public view returns(uint256) {
1501         return getValueAt(checkpointBalances[_investor], _checkpointId, balanceOf(_investor));
1502     }
1503 
1504 }