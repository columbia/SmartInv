1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Interface for the polymath module registry contract
5  */
6 contract IModuleRegistry {
7 
8     /**
9      * @notice Called by a security token to notify the registry it is using a module
10      * @param _moduleFactory is the address of the relevant module factory
11      */
12     function useModule(address _moduleFactory) external;
13 
14     /**
15      * @notice Called by moduleFactory owner to register new modules for SecurityToken to use
16      * @param _moduleFactory is the address of the module factory to be registered
17      */
18     function registerModule(address _moduleFactory) external returns(bool);
19 
20     /**
21      * @notice Use to get all the tags releated to the functionality of the Module Factory.
22      * @param _moduleType Type of module
23      */
24     function getTagByModuleType(uint8 _moduleType) public view returns(bytes32[]);
25 
26 }
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipRenounced(address indexed previousOwner);
38   event OwnershipTransferred(
39     address indexed previousOwner,
40     address indexed newOwner
41   );
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   constructor() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to relinquish control of the contract.
62    */
63   function renounceOwnership() public onlyOwner {
64     emit OwnershipRenounced(owner);
65     owner = address(0);
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param _newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address _newOwner) public onlyOwner {
73     _transferOwnership(_newOwner);
74   }
75 
76   /**
77    * @dev Transfers control of the contract to a newOwner.
78    * @param _newOwner The address to transfer ownership to.
79    */
80   function _transferOwnership(address _newOwner) internal {
81     require(_newOwner != address(0));
82     emit OwnershipTransferred(owner, _newOwner);
83     owner = _newOwner;
84   }
85 }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address who) public view returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 /**
100  * @title ERC20 interface
101  * @dev see https://github.com/ethereum/EIPs/issues/20
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender)
105     public view returns (uint256);
106 
107   function transferFrom(address from, address to, uint256 value)
108     public returns (bool);
109 
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(
112     address indexed owner,
113     address indexed spender,
114     uint256 value
115   );
116 }
117 
118 /**
119  * @title Interface that any module factory contract should implement
120  */
121 contract IModuleFactory is Ownable {
122 
123     ERC20 public polyToken;
124     uint256 public setupCost;
125     uint256 public usageCost;
126     uint256 public monthlySubscriptionCost;
127 
128     event LogChangeFactorySetupFee(uint256 _oldSetupcost, uint256 _newSetupCost, address _moduleFactory);
129     event LogChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
130     event LogChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
131     event LogGenerateModuleFromFactory(address _module, bytes32 indexed _moduleName, address indexed _moduleFactory, address _creator, uint256 _timestamp);
132 
133     /**
134      * @notice Constructor
135      * @param _polyAddress Address of the polytoken
136      */
137     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
138       polyToken = ERC20(_polyAddress);
139       setupCost = _setupCost;
140       usageCost = _usageCost;
141       monthlySubscriptionCost = _subscriptionCost;
142     }
143 
144     //Should create an instance of the Module, or throw
145     function deploy(bytes _data) external returns(address);
146 
147     /**
148      * @notice Type of the Module factory
149      */
150     function getType() public view returns(uint8);
151 
152     /**
153      * @notice Get the name of the Module
154      */
155     function getName() public view returns(bytes32);
156 
157     /**
158      * @notice Get the description of the Module
159      */
160     function getDescription() public view returns(string);
161 
162     /**
163      * @notice Get the title of the Module
164      */
165     function getTitle() public view returns(string);
166 
167     /**
168      * @notice Get the Instructions that helped to used the module
169      */
170     function getInstructions() public view returns (string);
171 
172     /**
173      * @notice Get the tags related to the module factory
174      */
175     function getTags() public view returns (bytes32[]);
176 
177     //Pull function sig from _data
178     function getSig(bytes _data) internal pure returns (bytes4 sig) {
179         uint len = _data.length < 4 ? _data.length : 4;
180         for (uint i = 0; i < len; i++) {
181             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
182         }
183     }
184 
185     /**
186      * @notice used to change the fee of the setup cost
187      * @param _newSetupCost new setup cost
188      */
189     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
190         emit LogChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
191         setupCost = _newSetupCost;
192     }
193 
194     /**
195      * @notice used to change the fee of the usage cost
196      * @param _newUsageCost new usage cost
197      */
198     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
199         emit LogChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
200         usageCost = _newUsageCost;
201     }
202 
203     /**
204      * @notice used to change the fee of the subscription cost
205      * @param _newSubscriptionCost new subscription cost
206      */
207     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
208         emit LogChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
209         monthlySubscriptionCost = _newSubscriptionCost;
210         
211     }
212 
213 }
214 
215 /**
216  * @title SafeMath
217  * @dev Math operations with safety checks that throw on error
218  */
219 library SafeMath {
220 
221   /**
222   * @dev Multiplies two numbers, throws on overflow.
223   */
224   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
225     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
226     // benefit is lost if 'b' is also tested.
227     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
228     if (a == 0) {
229       return 0;
230     }
231 
232     c = a * b;
233     assert(c / a == b);
234     return c;
235   }
236 
237   /**
238   * @dev Integer division of two numbers, truncating the quotient.
239   */
240   function div(uint256 a, uint256 b) internal pure returns (uint256) {
241     // assert(b > 0); // Solidity automatically throws when dividing by 0
242     // uint256 c = a / b;
243     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244     return a / b;
245   }
246 
247   /**
248   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
249   */
250   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
251     assert(b <= a);
252     return a - b;
253   }
254 
255   /**
256   * @dev Adds two numbers, throws on overflow.
257   */
258   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
259     c = a + b;
260     assert(c >= a);
261     return c;
262   }
263 }
264 
265 /**
266  * @title Basic token
267  * @dev Basic version of StandardToken, with no allowances.
268  */
269 contract BasicToken is ERC20Basic {
270   using SafeMath for uint256;
271 
272   mapping(address => uint256) balances;
273 
274   uint256 totalSupply_;
275 
276   /**
277   * @dev total number of tokens in existence
278   */
279   function totalSupply() public view returns (uint256) {
280     return totalSupply_;
281   }
282 
283   /**
284   * @dev transfer token for a specified address
285   * @param _to The address to transfer to.
286   * @param _value The amount to be transferred.
287   */
288   function transfer(address _to, uint256 _value) public returns (bool) {
289     require(_to != address(0));
290     require(_value <= balances[msg.sender]);
291 
292     balances[msg.sender] = balances[msg.sender].sub(_value);
293     balances[_to] = balances[_to].add(_value);
294     emit Transfer(msg.sender, _to, _value);
295     return true;
296   }
297 
298   /**
299   * @dev Gets the balance of the specified address.
300   * @param _owner The address to query the the balance of.
301   * @return An uint256 representing the amount owned by the passed address.
302   */
303   function balanceOf(address _owner) public view returns (uint256) {
304     return balances[_owner];
305   }
306 
307 }
308 
309 /**
310  * @title Standard ERC20 token
311  *
312  * @dev Implementation of the basic standard token.
313  * @dev https://github.com/ethereum/EIPs/issues/20
314  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
315  */
316 contract StandardToken is ERC20, BasicToken {
317 
318   mapping (address => mapping (address => uint256)) internal allowed;
319 
320 
321   /**
322    * @dev Transfer tokens from one address to another
323    * @param _from address The address which you want to send tokens from
324    * @param _to address The address which you want to transfer to
325    * @param _value uint256 the amount of tokens to be transferred
326    */
327   function transferFrom(
328     address _from,
329     address _to,
330     uint256 _value
331   )
332     public
333     returns (bool)
334   {
335     require(_to != address(0));
336     require(_value <= balances[_from]);
337     require(_value <= allowed[_from][msg.sender]);
338 
339     balances[_from] = balances[_from].sub(_value);
340     balances[_to] = balances[_to].add(_value);
341     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
342     emit Transfer(_from, _to, _value);
343     return true;
344   }
345 
346   /**
347    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
348    *
349    * Beware that changing an allowance with this method brings the risk that someone may use both the old
350    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
351    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
352    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353    * @param _spender The address which will spend the funds.
354    * @param _value The amount of tokens to be spent.
355    */
356   function approve(address _spender, uint256 _value) public returns (bool) {
357     allowed[msg.sender][_spender] = _value;
358     emit Approval(msg.sender, _spender, _value);
359     return true;
360   }
361 
362   /**
363    * @dev Function to check the amount of tokens that an owner allowed to a spender.
364    * @param _owner address The address which owns the funds.
365    * @param _spender address The address which will spend the funds.
366    * @return A uint256 specifying the amount of tokens still available for the spender.
367    */
368   function allowance(
369     address _owner,
370     address _spender
371    )
372     public
373     view
374     returns (uint256)
375   {
376     return allowed[_owner][_spender];
377   }
378 
379   /**
380    * @dev Increase the amount of tokens that an owner allowed to a spender.
381    *
382    * approve should be called when allowed[_spender] == 0. To increment
383    * allowed value is better to use this function to avoid 2 calls (and wait until
384    * the first transaction is mined)
385    * From MonolithDAO Token.sol
386    * @param _spender The address which will spend the funds.
387    * @param _addedValue The amount of tokens to increase the allowance by.
388    */
389   function increaseApproval(
390     address _spender,
391     uint _addedValue
392   )
393     public
394     returns (bool)
395   {
396     allowed[msg.sender][_spender] = (
397       allowed[msg.sender][_spender].add(_addedValue));
398     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
399     return true;
400   }
401 
402   /**
403    * @dev Decrease the amount of tokens that an owner allowed to a spender.
404    *
405    * approve should be called when allowed[_spender] == 0. To decrement
406    * allowed value is better to use this function to avoid 2 calls (and wait until
407    * the first transaction is mined)
408    * From MonolithDAO Token.sol
409    * @param _spender The address which will spend the funds.
410    * @param _subtractedValue The amount of tokens to decrease the allowance by.
411    */
412   function decreaseApproval(
413     address _spender,
414     uint _subtractedValue
415   )
416     public
417     returns (bool)
418   {
419     uint oldValue = allowed[msg.sender][_spender];
420     if (_subtractedValue > oldValue) {
421       allowed[msg.sender][_spender] = 0;
422     } else {
423       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
424     }
425     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
426     return true;
427   }
428 
429 }
430 
431 /**
432  * @title DetailedERC20 token
433  * @dev The decimals are only for visualization purposes.
434  * All the operations are done using the smallest and indivisible token unit,
435  * just as on Ethereum all the operations are done in wei.
436  */
437 contract DetailedERC20 is ERC20 {
438   string public name;
439   string public symbol;
440   uint8 public decimals;
441 
442   constructor(string _name, string _symbol, uint8 _decimals) public {
443     name = _name;
444     symbol = _symbol;
445     decimals = _decimals;
446   }
447 }
448 
449 /**
450  * @title Interface for the ST20 token standard
451  */
452 contract IST20 is StandardToken, DetailedERC20 {
453 
454     // off-chain hash
455     string public tokenDetails;
456 
457     //transfer, transferFrom must respect use respect the result of verifyTransfer
458     function verifyTransfer(address _from, address _to, uint256 _amount) public returns (bool success);
459 
460     /**
461      * @notice mints new tokens and assigns them to the target _investor.
462      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
463      */
464     function mint(address _investor, uint256 _amount) public returns (bool success);
465 
466     /**
467      * @notice Burn function used to burn the securityToken
468      * @param _value No. of token that get burned
469      */
470     function burn(uint256 _value) public;
471 
472     event Minted(address indexed to, uint256 amount);
473     event Burnt(address indexed _burner, uint256 _value);
474 
475 }
476 
477 /**
478  * @title Interface for all security tokens
479  */
480 contract ISecurityToken is IST20, Ownable {
481 
482     uint8 public constant PERMISSIONMANAGER_KEY = 1;
483     uint8 public constant TRANSFERMANAGER_KEY = 2;
484     uint8 public constant STO_KEY = 3;
485     uint8 public constant CHECKPOINT_KEY = 4;
486     uint256 public granularity;
487 
488     // Value of current checkpoint
489     uint256 public currentCheckpointId;
490 
491     // Total number of non-zero token holders
492     uint256 public investorCount;
493 
494     // List of token holders
495     address[] public investors;
496 
497     // Permissions this to a Permission module, which has a key of 1
498     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
499     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
500     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);
501 
502     /**
503      * @notice returns module list for a module type
504      * @param _moduleType is which type of module we are trying to remove
505      * @param _moduleIndex is the index of the module within the chosen type
506      */
507     function getModule(uint8 _moduleType, uint _moduleIndex) public view returns (bytes32, address);
508 
509     /**
510      * @notice returns module list for a module name - will return first match
511      * @param _moduleType is which type of module we are trying to remove
512      * @param _name is the name of the module within the chosen type
513      */
514     function getModuleByName(uint8 _moduleType, bytes32 _name) public view returns (bytes32, address);
515 
516     /**
517      * @notice Queries totalSupply as of a defined checkpoint
518      * @param _checkpointId Checkpoint ID to query as of
519      */
520     function totalSupplyAt(uint256 _checkpointId) public view returns(uint256);
521 
522     /**
523      * @notice Queries balances as of a defined checkpoint
524      * @param _investor Investor to query balance for
525      * @param _checkpointId Checkpoint ID to query as of
526      */
527     function balanceOfAt(address _investor, uint256 _checkpointId) public view returns(uint256);
528 
529     /**
530      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
531      */
532     function createCheckpoint() public returns(uint256);
533 
534     /**
535      * @notice gets length of investors array
536      * NB - this length may differ from investorCount if list has not been pruned of zero balance investors
537      * @return length
538      */
539     function getInvestorsLength() public view returns(uint256);
540 
541 }
542 
543 /**
544  * @title Interface for the polymath security token registry contract
545  */
546 contract ISecurityTokenRegistry {
547 
548     bytes32 public protocolVersion = "0.0.1";
549     mapping (bytes32 => address) public protocolVersionST;
550 
551     struct SecurityTokenData {
552         string symbol;
553         string tokenDetails;
554     }
555 
556     mapping(address => SecurityTokenData) securityTokens;
557     mapping(string => address) symbols;
558 
559     /**
560      * @notice Creates a new Security Token and saves it to the registry
561      * @param _name Name of the token
562      * @param _symbol Ticker symbol of the security token
563      * @param _tokenDetails off-chain details of the token
564      */
565     function generateSecurityToken(string _name, string _symbol, string _tokenDetails, bool _divisible) public;
566 
567     function setProtocolVersion(address _stVersionProxyAddress, bytes32 _version) public;
568 
569     /**
570      * @notice Get security token address by ticker name
571      * @param _symbol Symbol of the Scurity token
572      * @return address _symbol
573      */
574     function getSecurityTokenAddress(string _symbol) public view returns (address);
575 
576      /**
577      * @notice Get security token data by its address
578      * @param _securityToken Address of the Scurity token
579      * @return string, address, bytes32
580      */
581     function getSecurityTokenData(address _securityToken) public view returns (string, address, string);
582 
583     /**
584     * @notice Check that Security Token is registered
585     * @param _securityToken Address of the Scurity token
586     * @return bool
587     */
588     function isSecurityToken(address _securityToken) public view returns (bool);
589 }
590 
591 /**
592  * @title Utility contract to allow pausing and unpausing of certain functions
593  */
594 contract Pausable {
595 
596     event Pause(uint256 _timestammp);
597     event Unpause(uint256 _timestamp);
598 
599     bool public paused = false;
600 
601     /**
602     * @notice Modifier to make a function callable only when the contract is not paused.
603     */
604     modifier whenNotPaused() {
605         require(!paused);
606         _;
607     }
608 
609     /**
610     * @notice Modifier to make a function callable only when the contract is paused.
611     */
612     modifier whenPaused() {
613         require(paused);
614         _;
615     }
616 
617    /**
618     * @notice called by the owner to pause, triggers stopped state
619     */
620     function _pause() internal {
621         require(!paused);
622         paused = true;
623         emit Pause(now);
624     }
625 
626     /**
627     * @notice called by the owner to unpause, returns to normal state
628     */
629     function _unpause() internal {
630         require(paused);
631         paused = false;
632         emit Unpause(now);
633     }
634 
635 }
636 
637 /**
638  * @title Utility contract to allow owner to retreive any ERC20 sent to the contract
639  */
640 contract ReclaimTokens is Ownable {
641 
642     /**
643     * @notice Reclaim all ERC20Basic compatible tokens
644     * @param _tokenContract The address of the token contract
645     */
646     function reclaimERC20(address _tokenContract) external onlyOwner {
647         require(_tokenContract != address(0));
648         ERC20Basic token = ERC20Basic(_tokenContract);
649         uint256 balance = token.balanceOf(address(this));
650         require(token.transfer(owner, balance));
651     }
652 }
653 
654 /**
655  * @title Core functionality for registry upgradability
656  */
657 contract PolymathRegistry is ReclaimTokens {
658 
659     mapping (bytes32 => address) public storedAddresses;
660 
661     event LogChangeAddress(string _nameKey, address indexed _oldAddress, address indexed _newAddress);
662 
663     /**
664      * @notice Get the contract address
665      * @param _nameKey is the key for the contract address mapping
666      * @return address
667      */
668     function getAddress(string _nameKey) view public returns(address) {
669         bytes32 key = keccak256(bytes(_nameKey));
670         require(storedAddresses[key] != address(0), "Invalid address key");
671         return storedAddresses[key];
672     }
673 
674     /**
675      * @notice change the contract address
676      * @param _nameKey is the key for the contract address mapping
677      * @param _newAddress is the new contract address
678      */
679     function changeAddress(string _nameKey, address _newAddress) public onlyOwner {
680         bytes32 key = keccak256(bytes(_nameKey));
681         emit LogChangeAddress(_nameKey, storedAddresses[key], _newAddress);
682         storedAddresses[key] = _newAddress;
683     }
684 
685 
686 }
687 
688 contract RegistryUpdater is Ownable {
689 
690     address public polymathRegistry;
691     address public moduleRegistry;
692     address public securityTokenRegistry;
693     address public tickerRegistry;
694     address public polyToken;
695 
696     constructor (address _polymathRegistry) public {
697         require(_polymathRegistry != address(0));
698         polymathRegistry = _polymathRegistry;
699     }
700 
701     function updateFromRegistry() onlyOwner public {
702         moduleRegistry = PolymathRegistry(polymathRegistry).getAddress("ModuleRegistry");
703         securityTokenRegistry = PolymathRegistry(polymathRegistry).getAddress("SecurityTokenRegistry");
704         tickerRegistry = PolymathRegistry(polymathRegistry).getAddress("TickerRegistry");
705         polyToken = PolymathRegistry(polymathRegistry).getAddress("PolyToken");
706     }
707 
708 }
709 
710 /**
711 * @title Registry contract to store registered modules
712 * @notice Anyone can register modules, but only those "approved" by Polymath will be available for issuers to add
713 */
714 contract ModuleRegistry is IModuleRegistry, Pausable, RegistryUpdater, ReclaimTokens {
715 
716     // Mapping used to hold the type of module factory corresponds to the address of the Module factory contract
717     mapping (address => uint8) public registry;
718     // Mapping used to hold the reputation of the factory
719     mapping (address => address[]) public reputation;
720     // Mapping contain the list of addresses of Module factory for a particular type
721     mapping (uint8 => address[]) public moduleList;
722     // contains the list of verified modules
723     mapping (address => bool) public verified;
724     // Contains the list of the available tags corresponds to the module type
725     mapping (uint8 => bytes32[]) public availableTags;
726 
727     // Emit when Module been used by the securityToken
728     event LogModuleUsed(address indexed _moduleFactory, address indexed _securityToken);
729     // Emit when the Module Factory get registered with the ModuleRegistry contract
730     event LogModuleRegistered(address indexed _moduleFactory, address indexed _owner);
731     // Emit when the module get verified by the Polymath team
732     event LogModuleVerified(address indexed _moduleFactory, bool _verified);
733 
734     constructor (address _polymathRegistry) public
735         RegistryUpdater(_polymathRegistry)
736     {
737     }
738 
739    /**
740     * @notice Called by a security token to notify the registry it is using a module
741     * @param _moduleFactory is the address of the relevant module factory
742     */
743     function useModule(address _moduleFactory) external {
744         //If caller is a registered security token, then register module usage
745         if (ISecurityTokenRegistry(securityTokenRegistry).isSecurityToken(msg.sender)) {
746             require(registry[_moduleFactory] != 0, "ModuleFactory type should not be 0");
747             //To use a module, either it must be verified, or owned by the ST owner
748             require(verified[_moduleFactory]||(IModuleFactory(_moduleFactory).owner() == ISecurityToken(msg.sender).owner()),
749               "Module factory is not verified as well as not called by the owner");
750             reputation[_moduleFactory].push(msg.sender);
751             emit LogModuleUsed (_moduleFactory, msg.sender);
752         }
753     }
754 
755     /**
756     * @notice Called by moduleFactory owner to register new modules for SecurityToken to use
757     * @param _moduleFactory is the address of the module factory to be registered
758     * @return bool
759     */
760     function registerModule(address _moduleFactory) external whenNotPaused returns(bool) {
761         require(registry[_moduleFactory] == 0, "Module factory should not be pre-registered");
762         IModuleFactory moduleFactory = IModuleFactory(_moduleFactory);
763         require(moduleFactory.getType() != 0, "Factory type should not equal to 0");
764         registry[_moduleFactory] = moduleFactory.getType();
765         moduleList[moduleFactory.getType()].push(_moduleFactory);
766         reputation[_moduleFactory] = new address[](0);
767         emit LogModuleRegistered (_moduleFactory, moduleFactory.owner());
768         return true;
769     }
770 
771     /**
772     * @notice Called by Polymath to verify modules for SecurityToken to use.
773     * @notice A module can not be used by an ST unless first approved/verified by Polymath
774     * @notice (The only exception to this is that the author of the module is the owner of the ST)
775     * @param _moduleFactory is the address of the module factory to be registered
776     * @return bool
777     */
778     function verifyModule(address _moduleFactory, bool _verified) external onlyOwner returns(bool) {
779         //Must already have been registered
780         require(registry[_moduleFactory] != 0, "Module factory should have been already registered");
781         verified[_moduleFactory] = _verified;
782         emit LogModuleVerified(_moduleFactory, _verified);
783         return true;
784     }
785 
786     /**
787      * @notice Use to get all the tags releated to the functionality of the Module Factory.
788      * @param _moduleType Type of module
789      * @return bytes32 array
790      */
791     function getTagByModuleType(uint8 _moduleType) public view returns(bytes32[]) {
792         return availableTags[_moduleType];
793     }
794 
795     /**
796      * @notice Add the tag for specified Module Factory
797      * @param _moduleType Type of module.
798      * @param _tag List of tags
799      */
800      function addTagByModuleType(uint8 _moduleType, bytes32[] _tag) public onlyOwner {
801          for (uint8 i = 0; i < _tag.length; i++) {
802              availableTags[_moduleType].push(_tag[i]);
803          }
804      }
805 
806     /**
807      * @notice remove the tag for specified Module Factory
808      * @param _moduleType Type of module.
809      * @param _removedTags List of tags
810      */
811      function removeTagByModuleType(uint8 _moduleType, bytes32[] _removedTags) public onlyOwner {
812          for (uint8 i = 0; i < availableTags[_moduleType].length; i++) {
813             for (uint8 j = 0; j < _removedTags.length; j++) {
814                 if (availableTags[_moduleType][i] == _removedTags[j]) {
815                     delete availableTags[_moduleType][i];
816                 }
817             }
818         }
819      }
820 
821      /**
822      * @notice pause registration function
823      */
824     function unpause() public onlyOwner  {
825         _unpause();
826     }
827 
828     /**
829      * @notice unpause registration function
830      */
831     function pause() public onlyOwner {
832         _pause();
833     }
834 
835 
836 }