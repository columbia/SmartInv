1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Interface for the polymath ticker registry contract
5  */
6 contract ITickerRegistry {
7     /**
8     * @notice Check the validity of the symbol
9     * @param _symbol token symbol
10     * @param _owner address of the owner
11     * @param _tokenName Name of the token
12     * @return bool
13     */
14     function checkValidity(string _symbol, address _owner, string _tokenName) public returns(bool);
15 
16     /**
17     * @notice Returns the owner and timestamp for a given symbol
18     * @param _symbol symbol
19     */
20     function getDetails(string _symbol) public view returns (address, uint256, string, bytes32, bool);
21 
22     /**
23      * @notice Check the symbol is reserved or not
24      * @param _symbol Symbol of the token
25      * @return bool
26      */
27      function isReserved(string _symbol, address _owner, string _tokenName, bytes32 _swarmHash) public returns(bool);
28 
29 }
30 
31 /**
32  * @title Math
33  * @dev Assorted math operations
34  */
35 library Math {
36   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
37     return a >= b ? a : b;
38   }
39 
40   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
41     return a < b ? a : b;
42   }
43 
44   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
45     return a >= b ? a : b;
46   }
47 
48   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
49     return a < b ? a : b;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73   function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 contract IERC20 is ERC20 {
85 
86     function decreaseApproval(
87     address _spender,
88     uint _subtractedValue
89   )
90     public
91     returns (bool);
92 
93     function increaseApproval(
94     address _spender,
95     uint _addedValue
96   )
97     public
98     returns (bool);
99 }
100 
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that throw on error
104  */
105 library SafeMath {
106 
107   /**
108   * @dev Multiplies two numbers, throws on overflow.
109   */
110   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
111     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
112     // benefit is lost if 'b' is also tested.
113     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
114     if (a == 0) {
115       return 0;
116     }
117 
118     c = a * b;
119     assert(c / a == b);
120     return c;
121   }
122 
123   /**
124   * @dev Integer division of two numbers, truncating the quotient.
125   */
126   function div(uint256 a, uint256 b) internal pure returns (uint256) {
127     // assert(b > 0); // Solidity automatically throws when dividing by 0
128     // uint256 c = a / b;
129     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130     return a / b;
131   }
132 
133   /**
134   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
135   */
136   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137     assert(b <= a);
138     return a - b;
139   }
140 
141   /**
142   * @dev Adds two numbers, throws on overflow.
143   */
144   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
145     c = a + b;
146     assert(c >= a);
147     return c;
148   }
149 }
150 
151 /**
152  * @title Basic token
153  * @dev Basic version of StandardToken, with no allowances.
154  */
155 contract BasicToken is ERC20Basic {
156   using SafeMath for uint256;
157 
158   mapping(address => uint256) balances;
159 
160   uint256 totalSupply_;
161 
162   /**
163   * @dev total number of tokens in existence
164   */
165   function totalSupply() public view returns (uint256) {
166     return totalSupply_;
167   }
168 
169   /**
170   * @dev transfer token for a specified address
171   * @param _to The address to transfer to.
172   * @param _value The amount to be transferred.
173   */
174   function transfer(address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[msg.sender]);
177 
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(
214     address _from,
215     address _to,
216     uint256 _value
217   )
218     public
219     returns (bool)
220   {
221     require(_to != address(0));
222     require(_value <= balances[_from]);
223     require(_value <= allowed[_from][msg.sender]);
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     emit Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     emit Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(
255     address _owner,
256     address _spender
257    )
258     public
259     view
260     returns (uint256)
261   {
262     return allowed[_owner][_spender];
263   }
264 
265   /**
266    * @dev Increase the amount of tokens that an owner allowed to a spender.
267    *
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param _spender The address which will spend the funds.
273    * @param _addedValue The amount of tokens to increase the allowance by.
274    */
275   function increaseApproval(
276     address _spender,
277     uint _addedValue
278   )
279     public
280     returns (bool)
281   {
282     allowed[msg.sender][_spender] = (
283       allowed[msg.sender][_spender].add(_addedValue));
284     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   /**
289    * @dev Decrease the amount of tokens that an owner allowed to a spender.
290    *
291    * approve should be called when allowed[_spender] == 0. To decrement
292    * allowed value is better to use this function to avoid 2 calls (and wait until
293    * the first transaction is mined)
294    * From MonolithDAO Token.sol
295    * @param _spender The address which will spend the funds.
296    * @param _subtractedValue The amount of tokens to decrease the allowance by.
297    */
298   function decreaseApproval(
299     address _spender,
300     uint _subtractedValue
301   )
302     public
303     returns (bool)
304   {
305     uint oldValue = allowed[msg.sender][_spender];
306     if (_subtractedValue > oldValue) {
307       allowed[msg.sender][_spender] = 0;
308     } else {
309       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310     }
311     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 
315 }
316 
317 /**
318  * @title DetailedERC20 token
319  * @dev The decimals are only for visualization purposes.
320  * All the operations are done using the smallest and indivisible token unit,
321  * just as on Ethereum all the operations are done in wei.
322  */
323 contract DetailedERC20 is ERC20 {
324   string public name;
325   string public symbol;
326   uint8 public decimals;
327 
328   constructor(string _name, string _symbol, uint8 _decimals) public {
329     name = _name;
330     symbol = _symbol;
331     decimals = _decimals;
332   }
333 }
334 
335 /**
336  * @title Interface for the ST20 token standard
337  */
338 contract IST20 is StandardToken, DetailedERC20 {
339 
340     // off-chain hash
341     string public tokenDetails;
342 
343     //transfer, transferFrom must respect use respect the result of verifyTransfer
344     function verifyTransfer(address _from, address _to, uint256 _amount) public returns (bool success);
345 
346     /**
347      * @notice mints new tokens and assigns them to the target _investor.
348      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
349      */
350     function mint(address _investor, uint256 _amount) public returns (bool success);
351 
352     /**
353      * @notice Burn function used to burn the securityToken
354      * @param _value No. of token that get burned
355      */
356     function burn(uint256 _value) public;
357 
358     event Minted(address indexed to, uint256 amount);
359     event Burnt(address indexed _burner, uint256 _value);
360 
361 }
362 
363 /**
364  * @title Ownable
365  * @dev The Ownable contract has an owner address, and provides basic authorization control
366  * functions, this simplifies the implementation of "user permissions".
367  */
368 contract Ownable {
369   address public owner;
370 
371 
372   event OwnershipRenounced(address indexed previousOwner);
373   event OwnershipTransferred(
374     address indexed previousOwner,
375     address indexed newOwner
376   );
377 
378 
379   /**
380    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
381    * account.
382    */
383   constructor() public {
384     owner = msg.sender;
385   }
386 
387   /**
388    * @dev Throws if called by any account other than the owner.
389    */
390   modifier onlyOwner() {
391     require(msg.sender == owner);
392     _;
393   }
394 
395   /**
396    * @dev Allows the current owner to relinquish control of the contract.
397    */
398   function renounceOwnership() public onlyOwner {
399     emit OwnershipRenounced(owner);
400     owner = address(0);
401   }
402 
403   /**
404    * @dev Allows the current owner to transfer control of the contract to a newOwner.
405    * @param _newOwner The address to transfer ownership to.
406    */
407   function transferOwnership(address _newOwner) public onlyOwner {
408     _transferOwnership(_newOwner);
409   }
410 
411   /**
412    * @dev Transfers control of the contract to a newOwner.
413    * @param _newOwner The address to transfer ownership to.
414    */
415   function _transferOwnership(address _newOwner) internal {
416     require(_newOwner != address(0));
417     emit OwnershipTransferred(owner, _newOwner);
418     owner = _newOwner;
419   }
420 }
421 
422 /**
423  * @title Interface for all security tokens
424  */
425 contract ISecurityToken is IST20, Ownable {
426 
427     uint8 public constant PERMISSIONMANAGER_KEY = 1;
428     uint8 public constant TRANSFERMANAGER_KEY = 2;
429     uint8 public constant STO_KEY = 3;
430     uint8 public constant CHECKPOINT_KEY = 4;
431     uint256 public granularity;
432 
433     // Value of current checkpoint
434     uint256 public currentCheckpointId;
435 
436     // Total number of non-zero token holders
437     uint256 public investorCount;
438 
439     // List of token holders
440     address[] public investors;
441 
442     // Permissions this to a Permission module, which has a key of 1
443     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
444     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
445     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);
446 
447     /**
448      * @notice returns module list for a module type
449      * @param _moduleType is which type of module we are trying to remove
450      * @param _moduleIndex is the index of the module within the chosen type
451      */
452     function getModule(uint8 _moduleType, uint _moduleIndex) public view returns (bytes32, address);
453 
454     /**
455      * @notice returns module list for a module name - will return first match
456      * @param _moduleType is which type of module we are trying to remove
457      * @param _name is the name of the module within the chosen type
458      */
459     function getModuleByName(uint8 _moduleType, bytes32 _name) public view returns (bytes32, address);
460 
461     /**
462      * @notice Queries totalSupply as of a defined checkpoint
463      * @param _checkpointId Checkpoint ID to query as of
464      */
465     function totalSupplyAt(uint256 _checkpointId) public view returns(uint256);
466 
467     /**
468      * @notice Queries balances as of a defined checkpoint
469      * @param _investor Investor to query balance for
470      * @param _checkpointId Checkpoint ID to query as of
471      */
472     function balanceOfAt(address _investor, uint256 _checkpointId) public view returns(uint256);
473 
474     /**
475      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
476      */
477     function createCheckpoint() public returns(uint256);
478 
479     /**
480      * @notice gets length of investors array
481      * NB - this length may differ from investorCount if list has not been pruned of zero balance investors
482      * @return length
483      */
484     function getInvestorsLength() public view returns(uint256);
485 
486 }
487 
488 /**
489  * @title Interface that any module factory contract should implement
490  */
491 contract IModuleFactory is Ownable {
492 
493     ERC20 public polyToken;
494     uint256 public setupCost;
495     uint256 public usageCost;
496     uint256 public monthlySubscriptionCost;
497 
498     event LogChangeFactorySetupFee(uint256 _oldSetupcost, uint256 _newSetupCost, address _moduleFactory);
499     event LogChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
500     event LogChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
501     event LogGenerateModuleFromFactory(address _module, bytes32 indexed _moduleName, address indexed _moduleFactory, address _creator, uint256 _timestamp);
502 
503     /**
504      * @notice Constructor
505      * @param _polyAddress Address of the polytoken
506      */
507     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
508       polyToken = ERC20(_polyAddress);
509       setupCost = _setupCost;
510       usageCost = _usageCost;
511       monthlySubscriptionCost = _subscriptionCost;
512     }
513 
514     //Should create an instance of the Module, or throw
515     function deploy(bytes _data) external returns(address);
516 
517     /**
518      * @notice Type of the Module factory
519      */
520     function getType() public view returns(uint8);
521 
522     /**
523      * @notice Get the name of the Module
524      */
525     function getName() public view returns(bytes32);
526 
527     /**
528      * @notice Get the description of the Module
529      */
530     function getDescription() public view returns(string);
531 
532     /**
533      * @notice Get the title of the Module
534      */
535     function getTitle() public view returns(string);
536 
537     /**
538      * @notice Get the Instructions that helped to used the module
539      */
540     function getInstructions() public view returns (string);
541 
542     /**
543      * @notice Get the tags related to the module factory
544      */
545     function getTags() public view returns (bytes32[]);
546 
547     //Pull function sig from _data
548     function getSig(bytes _data) internal pure returns (bytes4 sig) {
549         uint len = _data.length < 4 ? _data.length : 4;
550         for (uint i = 0; i < len; i++) {
551             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
552         }
553     }
554 
555     /**
556      * @notice used to change the fee of the setup cost
557      * @param _newSetupCost new setup cost
558      */
559     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
560         emit LogChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
561         setupCost = _newSetupCost;
562     }
563 
564     /**
565      * @notice used to change the fee of the usage cost
566      * @param _newUsageCost new usage cost
567      */
568     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
569         emit LogChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
570         usageCost = _newUsageCost;
571     }
572 
573     /**
574      * @notice used to change the fee of the subscription cost
575      * @param _newSubscriptionCost new subscription cost
576      */
577     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
578         emit LogChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
579         monthlySubscriptionCost = _newSubscriptionCost;
580         
581     }
582 
583 }
584 
585 /**
586  * @title Interface that any module contract should implement
587  */
588 contract IModule {
589 
590     address public factory;
591 
592     address public securityToken;
593 
594     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
595 
596     ERC20 public polyToken;
597 
598     /**
599      * @notice Constructor
600      * @param _securityToken Address of the security token
601      * @param _polyAddress Address of the polytoken
602      */
603     constructor (address _securityToken, address _polyAddress) public {
604         securityToken = _securityToken;
605         factory = msg.sender;
606         polyToken = ERC20(_polyAddress);
607     }
608 
609     /**
610      * @notice This function returns the signature of configure function
611      */
612     function getInitFunction() public pure returns (bytes4);
613 
614     //Allows owner, factory or permissioned delegate
615     modifier withPerm(bytes32 _perm) {
616         bool isOwner = msg.sender == ISecurityToken(securityToken).owner();
617         bool isFactory = msg.sender == factory;
618         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
619         _;
620     }
621 
622     modifier onlyOwner {
623         require(msg.sender == ISecurityToken(securityToken).owner(), "Sender is not owner");
624         _;
625     }
626 
627     modifier onlyFactory {
628         require(msg.sender == factory, "Sender is not factory");
629         _;
630     }
631 
632     modifier onlyFactoryOwner {
633         require(msg.sender == IModuleFactory(factory).owner(), "Sender is not factory owner");
634         _;
635     }
636 
637     /**
638      * @notice Return the permissions flag that are associated with Module
639      */
640     function getPermissions() public view returns(bytes32[]);
641 
642     /**
643      * @notice used to withdraw the fee by the factory owner
644      */
645     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
646         require(polyToken.transferFrom(address(this), IModuleFactory(factory).owner(), _amount), "Unable to take fee");
647         return true;
648     }
649 }
650 
651 /**
652  * @title Interface for the polymath module registry contract
653  */
654 contract IModuleRegistry {
655 
656     /**
657      * @notice Called by a security token to notify the registry it is using a module
658      * @param _moduleFactory is the address of the relevant module factory
659      */
660     function useModule(address _moduleFactory) external;
661 
662     /**
663      * @notice Called by moduleFactory owner to register new modules for SecurityToken to use
664      * @param _moduleFactory is the address of the module factory to be registered
665      */
666     function registerModule(address _moduleFactory) external returns(bool);
667 
668     /**
669      * @notice Use to get all the tags releated to the functionality of the Module Factory.
670      * @param _moduleType Type of module
671      */
672     function getTagByModuleType(uint8 _moduleType) public view returns(bytes32[]);
673 
674 }
675 
676 /**
677  * @title Utility contract to allow pausing and unpausing of certain functions
678  */
679 contract Pausable {
680 
681     event Pause(uint256 _timestammp);
682     event Unpause(uint256 _timestamp);
683 
684     bool public paused = false;
685 
686     /**
687     * @notice Modifier to make a function callable only when the contract is not paused.
688     */
689     modifier whenNotPaused() {
690         require(!paused);
691         _;
692     }
693 
694     /**
695     * @notice Modifier to make a function callable only when the contract is paused.
696     */
697     modifier whenPaused() {
698         require(paused);
699         _;
700     }
701 
702    /**
703     * @notice called by the owner to pause, triggers stopped state
704     */
705     function _pause() internal {
706         require(!paused);
707         paused = true;
708         emit Pause(now);
709     }
710 
711     /**
712     * @notice called by the owner to unpause, returns to normal state
713     */
714     function _unpause() internal {
715         require(paused);
716         paused = false;
717         emit Unpause(now);
718     }
719 
720 }
721 
722 /**
723  * @title Interface to be implemented by all Transfer Manager modules
724  */
725 contract ITransferManager is IModule, Pausable {
726 
727     //If verifyTransfer returns:
728     //  FORCE_VALID, the transaction will always be valid, regardless of other TM results
729     //  INVALID, then the transfer should not be allowed regardless of other TM results
730     //  VALID, then the transfer is valid for this TM
731     //  NA, then the result from this TM is ignored
732     enum Result {INVALID, NA, VALID, FORCE_VALID}
733 
734     function verifyTransfer(address _from, address _to, uint256 _amount, bool _isTransfer) public returns(Result);
735 
736     function unpause() onlyOwner public {
737         super._unpause();
738     }
739 
740     function pause() onlyOwner public {
741         super._pause();
742     }
743 }
744 
745 /**
746  * @title Interface to be implemented by all permission manager modules
747  */
748 contract IPermissionManager is IModule {
749 
750     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);
751 
752     function changePermission(address _delegate, address _module, bytes32 _perm, bool _valid) public returns(bool);
753 
754     function getDelegateDetails(address _delegate) public view returns(bytes32);
755 
756 }
757 
758 /**
759  * @title Interface for the token burner contract
760  */
761 interface ITokenBurner {
762 
763     function burn(address _burner, uint256  _value ) external returns(bool);
764 
765 }
766 
767 /**
768  * @title Utility contract to allow owner to retreive any ERC20 sent to the contract
769  */
770 contract ReclaimTokens is Ownable {
771 
772     /**
773     * @notice Reclaim all ERC20Basic compatible tokens
774     * @param _tokenContract The address of the token contract
775     */
776     function reclaimERC20(address _tokenContract) external onlyOwner {
777         require(_tokenContract != address(0));
778         ERC20Basic token = ERC20Basic(_tokenContract);
779         uint256 balance = token.balanceOf(address(this));
780         require(token.transfer(owner, balance));
781     }
782 }
783 
784 /**
785  * @title Core functionality for registry upgradability
786  */
787 contract PolymathRegistry is ReclaimTokens {
788 
789     mapping (bytes32 => address) public storedAddresses;
790 
791     event LogChangeAddress(string _nameKey, address indexed _oldAddress, address indexed _newAddress);
792 
793     /**
794      * @notice Get the contract address
795      * @param _nameKey is the key for the contract address mapping
796      * @return address
797      */
798     function getAddress(string _nameKey) view public returns(address) {
799         bytes32 key = keccak256(bytes(_nameKey));
800         require(storedAddresses[key] != address(0), "Invalid address key");
801         return storedAddresses[key];
802     }
803 
804     /**
805      * @notice change the contract address
806      * @param _nameKey is the key for the contract address mapping
807      * @param _newAddress is the new contract address
808      */
809     function changeAddress(string _nameKey, address _newAddress) public onlyOwner {
810         bytes32 key = keccak256(bytes(_nameKey));
811         emit LogChangeAddress(_nameKey, storedAddresses[key], _newAddress);
812         storedAddresses[key] = _newAddress;
813     }
814 
815 
816 }
817 
818 contract RegistryUpdater is Ownable {
819 
820     address public polymathRegistry;
821     address public moduleRegistry;
822     address public securityTokenRegistry;
823     address public tickerRegistry;
824     address public polyToken;
825 
826     constructor (address _polymathRegistry) public {
827         require(_polymathRegistry != address(0));
828         polymathRegistry = _polymathRegistry;
829     }
830 
831     function updateFromRegistry() onlyOwner public {
832         moduleRegistry = PolymathRegistry(polymathRegistry).getAddress("ModuleRegistry");
833         securityTokenRegistry = PolymathRegistry(polymathRegistry).getAddress("SecurityTokenRegistry");
834         tickerRegistry = PolymathRegistry(polymathRegistry).getAddress("TickerRegistry");
835         polyToken = PolymathRegistry(polymathRegistry).getAddress("PolyToken");
836     }
837 
838 }
839 
840 /**
841  * @title Helps contracts guard agains reentrancy attacks.
842  * @author Remco Bloemen <remco@2π.com>
843  * @notice If you mark a function `nonReentrant`, you should also
844  * mark it `external`.
845  */
846 contract ReentrancyGuard {
847 
848   /**
849    * @dev We use a single lock for the whole contract.
850    */
851   bool private reentrancyLock = false;
852 
853   /**
854    * @dev Prevents a contract from calling itself, directly or indirectly.
855    * @notice If you mark a function `nonReentrant`, you should also
856    * mark it `external`. Calling one nonReentrant function from
857    * another is not supported. Instead, you can implement a
858    * `private` function doing the actual work, and a `external`
859    * wrapper marked as `nonReentrant`.
860    */
861   modifier nonReentrant() {
862     require(!reentrancyLock);
863     reentrancyLock = true;
864     _;
865     reentrancyLock = false;
866   }
867 
868 }
869 
870 /**
871 * @title Security Token contract
872 * @notice SecurityToken is an ERC20 token with added capabilities:
873 * @notice - Implements the ST-20 Interface
874 * @notice - Transfers are restricted
875 * @notice - Modules can be attached to it to control its behaviour
876 * @notice - ST should not be deployed directly, but rather the SecurityTokenRegistry should be used
877 */
878 contract SecurityToken is ISecurityToken, ReentrancyGuard, RegistryUpdater {
879     using SafeMath for uint256;
880 
881     bytes32 public constant securityTokenVersion = "0.0.1";
882 
883     // Reference to token burner contract
884     ITokenBurner public tokenBurner;
885 
886     // Use to halt all the transactions
887     bool public freeze = false;
888 
889     struct ModuleData {
890         bytes32 name;
891         address moduleAddress;
892     }
893 
894     // Structures to maintain checkpoints of balances for governance / dividends
895     struct Checkpoint {
896         uint256 checkpointId;
897         uint256 value;
898     }
899 
900     mapping (address => Checkpoint[]) public checkpointBalances;
901     Checkpoint[] public checkpointTotalSupply;
902 
903     bool public finishedIssuerMinting = false;
904     bool public finishedSTOMinting = false;
905 
906     mapping (bytes4 => bool) transferFunctions;
907 
908     // Module list should be order agnostic!
909     mapping (uint8 => ModuleData[]) public modules;
910 
911     uint8 public constant MAX_MODULES = 20;
912 
913     mapping (address => bool) public investorListed;
914 
915     // Emit at the time when module get added
916     event LogModuleAdded(
917         uint8 indexed _type,
918         bytes32 _name,
919         address _moduleFactory,
920         address _module,
921         uint256 _moduleCost,
922         uint256 _budget,
923         uint256 _timestamp
924     );
925 
926     // Emit when the token details get updated
927     event LogUpdateTokenDetails(string _oldDetails, string _newDetails);
928     // Emit when the granularity get changed
929     event LogGranularityChanged(uint256 _oldGranularity, uint256 _newGranularity);
930     // Emit when Module get removed from the securityToken
931     event LogModuleRemoved(uint8 indexed _type, address _module, uint256 _timestamp);
932     // Emit when the budget allocated to a module is changed
933     event LogModuleBudgetChanged(uint8 indexed _moduleType, address _module, uint256 _budget);
934     // Emit when all the transfers get freeze
935     event LogFreezeTransfers(bool _freeze, uint256 _timestamp);
936     // Emit when new checkpoint created
937     event LogCheckpointCreated(uint256 indexed _checkpointId, uint256 _timestamp);
938     // Emit when the minting get finished for the Issuer
939     event LogFinishMintingIssuer(uint256 _timestamp);
940     // Emit when the minting get finished for the STOs
941     event LogFinishMintingSTO(uint256 _timestamp);
942     // Change the STR address in the event of a upgrade
943     event LogChangeSTRAddress(address indexed _oldAddress, address indexed _newAddress);
944 
945     // If _fallback is true, then for STO module type we only allow the module if it is set, if it is not set we only allow the owner
946     // for other _moduleType we allow both issuer and module.
947     modifier onlyModule(uint8 _moduleType, bool _fallback) {
948       //Loop over all modules of type _moduleType
949         bool isModuleType = false;
950         for (uint8 i = 0; i < modules[_moduleType].length; i++) {
951             isModuleType = isModuleType || (modules[_moduleType][i].moduleAddress == msg.sender);
952         }
953         if (_fallback && !isModuleType) {
954             if (_moduleType == STO_KEY)
955                 require(modules[_moduleType].length == 0 && msg.sender == owner, "Sender is not owner or STO module is attached");
956             else
957                 require(msg.sender == owner, "Sender is not owner");
958         } else {
959             require(isModuleType, "Sender is not correct module type");
960         }
961         _;
962     }
963 
964     modifier checkGranularity(uint256 _amount) {
965         require(_amount % granularity == 0, "Unable to modify token balances at this granularity");
966         _;
967     }
968 
969     // Checks whether the minting is allowed or not, check for the owner if owner is no the msg.sender then check
970     // for the finishedSTOMinting flag because only STOs and owner are allowed for minting
971     modifier isMintingAllowed() {
972         if (msg.sender == owner) {
973             require(!finishedIssuerMinting, "Minting is finished for Issuer");
974         } else {
975             require(!finishedSTOMinting, "Minting is finished for STOs");
976         }
977         _;
978     }
979 
980     /**
981      * @notice Constructor
982      * @param _name Name of the SecurityToken
983      * @param _symbol Symbol of the Token
984      * @param _decimals Decimals for the securityToken
985      * @param _granularity granular level of the token
986      * @param _tokenDetails Details of the token that are stored off-chain (IPFS hash)
987      * @param _polymathRegistry Contract address of the polymath registry
988      */
989     constructor (
990         string _name,
991         string _symbol,
992         uint8 _decimals,
993         uint256 _granularity,
994         string _tokenDetails,
995         address _polymathRegistry
996     )
997     public
998     DetailedERC20(_name, _symbol, _decimals)
999     RegistryUpdater(_polymathRegistry)
1000     {
1001         //When it is created, the owner is the STR
1002         updateFromRegistry();
1003         tokenDetails = _tokenDetails;
1004         granularity = _granularity;
1005         transferFunctions[bytes4(keccak256("transfer(address,uint256)"))] = true;
1006         transferFunctions[bytes4(keccak256("transferFrom(address,address,uint256)"))] = true;
1007         transferFunctions[bytes4(keccak256("mint(address,uint256)"))] = true;
1008         transferFunctions[bytes4(keccak256("burn(uint256)"))] = true;
1009     }
1010 
1011     /**
1012      * @notice Function used to attach the module in security token
1013      * @param _moduleFactory Contract address of the module factory that needs to be attached
1014      * @param _data Data used for the intialization of the module factory variables
1015      * @param _maxCost Maximum cost of the Module factory
1016      * @param _budget Budget of the Module factory
1017      */
1018     function addModule(
1019         address _moduleFactory,
1020         bytes _data,
1021         uint256 _maxCost,
1022         uint256 _budget
1023     ) external onlyOwner nonReentrant {
1024         _addModule(_moduleFactory, _data, _maxCost, _budget);
1025     }
1026 
1027     /**
1028     * @notice _addModule handles the attachment (or replacement) of modules for the ST
1029     * @dev  E.G.: On deployment (through the STR) ST gets a TransferManager module attached to it
1030     * @dev to control restrictions on transfers.
1031     * @dev You are allowed to add a new moduleType if:
1032     * @dev - there is no existing module of that type yet added
1033     * @dev - the last member of the module list is replacable
1034     * @param _moduleFactory is the address of the module factory to be added
1035     * @param _data is data packed into bytes used to further configure the module (See STO usage)
1036     * @param _maxCost max amount of POLY willing to pay to module. (WIP)
1037     */
1038     function _addModule(address _moduleFactory, bytes _data, uint256 _maxCost, uint256 _budget) internal {
1039         //Check that module exists in registry - will throw otherwise
1040         IModuleRegistry(moduleRegistry).useModule(_moduleFactory);
1041         IModuleFactory moduleFactory = IModuleFactory(_moduleFactory);
1042         uint8 moduleType = moduleFactory.getType();
1043         require(modules[moduleType].length < MAX_MODULES, "Limit of MAX MODULES is reached");
1044         uint256 moduleCost = moduleFactory.setupCost();
1045         require(moduleCost <= _maxCost, "Max Cost is always be greater than module cost");
1046         //Approve fee for module
1047         require(ERC20(polyToken).approve(_moduleFactory, moduleCost), "Not able to approve the module cost");
1048         //Creates instance of module from factory
1049         address module = moduleFactory.deploy(_data);
1050         //Approve ongoing budget
1051         require(ERC20(polyToken).approve(module, _budget), "Not able to approve the budget");
1052         //Add to SecurityToken module map
1053         bytes32 moduleName = moduleFactory.getName();
1054         modules[moduleType].push(ModuleData(moduleName, module));
1055         //Emit log event
1056         emit LogModuleAdded(moduleType, moduleName, _moduleFactory, module, moduleCost, _budget, now);
1057     }
1058 
1059     /**
1060     * @notice Removes a module attached to the SecurityToken
1061     * @param _moduleType is which type of module we are trying to remove
1062     * @param _moduleIndex is the index of the module within the chosen type
1063     */
1064     function removeModule(uint8 _moduleType, uint8 _moduleIndex) external onlyOwner {
1065         require(_moduleIndex < modules[_moduleType].length,
1066         "Module index doesn't exist as per the choosen module type");
1067         require(modules[_moduleType][_moduleIndex].moduleAddress != address(0),
1068         "Module contract address should not be 0x");
1069         //Take the last member of the list, and replace _moduleIndex with this, then shorten the list by one
1070         emit LogModuleRemoved(_moduleType, modules[_moduleType][_moduleIndex].moduleAddress, now);
1071         modules[_moduleType][_moduleIndex] = modules[_moduleType][modules[_moduleType].length - 1];
1072         modules[_moduleType].length = modules[_moduleType].length - 1;
1073     }
1074 
1075     /**
1076      * @notice Returns module list for a module type
1077      * @param _moduleType is which type of module we are trying to get
1078      * @param _moduleIndex is the index of the module within the chosen type
1079      * @return bytes32
1080      * @return address
1081      */
1082     function getModule(uint8 _moduleType, uint _moduleIndex) public view returns (bytes32, address) {
1083         if (modules[_moduleType].length > 0) {
1084             return (
1085                 modules[_moduleType][_moduleIndex].name,
1086                 modules[_moduleType][_moduleIndex].moduleAddress
1087             );
1088         } else {
1089             return ("", address(0));
1090         }
1091 
1092     }
1093 
1094     /**
1095      * @notice returns module list for a module name - will return first match
1096      * @param _moduleType is which type of module we are trying to get
1097      * @param _name is the name of the module within the chosen type
1098      * @return bytes32
1099      * @return address
1100      */
1101     function getModuleByName(uint8 _moduleType, bytes32 _name) public view returns (bytes32, address) {
1102         if (modules[_moduleType].length > 0) {
1103             for (uint256 i = 0; i < modules[_moduleType].length; i++) {
1104                 if (modules[_moduleType][i].name == _name) {
1105                   return (
1106                       modules[_moduleType][i].name,
1107                       modules[_moduleType][i].moduleAddress
1108                   );
1109                 }
1110             }
1111             return ("", address(0));
1112         } else {
1113             return ("", address(0));
1114         }
1115     }
1116 
1117     /**
1118     * @notice allows the owner to withdraw unspent POLY stored by them on the ST.
1119     * @dev Owner can transfer POLY to the ST which will be used to pay for modules that require a POLY fee.
1120     * @param _amount amount of POLY to withdraw
1121     */
1122     function withdrawPoly(uint256 _amount) public onlyOwner {
1123         require(ERC20(polyToken).transfer(owner, _amount), "In-sufficient balance");
1124     }
1125 
1126     /**
1127     * @notice allows owner to approve more POLY to one of the modules
1128     * @param _moduleType module type
1129     * @param _moduleIndex module index
1130     * @param _budget new budget
1131     */
1132     function changeModuleBudget(uint8 _moduleType, uint8 _moduleIndex, uint256 _budget) public onlyOwner {
1133         require(_moduleType != 0, "Module type cannot be zero");
1134         require(_moduleIndex < modules[_moduleType].length, "Incorrrect module index");
1135         uint256 _currentAllowance = IERC20(polyToken).allowance(address(this), modules[_moduleType][_moduleIndex].moduleAddress);
1136         if (_budget < _currentAllowance) {
1137             require(IERC20(polyToken).decreaseApproval(modules[_moduleType][_moduleIndex].moduleAddress, _currentAllowance.sub(_budget)), "Insufficient balance to decreaseApproval");
1138         } else {
1139             require(IERC20(polyToken).increaseApproval(modules[_moduleType][_moduleIndex].moduleAddress, _budget.sub(_currentAllowance)), "Insufficient balance to increaseApproval");
1140         }
1141         emit LogModuleBudgetChanged(_moduleType, modules[_moduleType][_moduleIndex].moduleAddress, _budget);
1142     }
1143 
1144     /**
1145      * @notice change the tokenDetails
1146      * @param _newTokenDetails New token details
1147      */
1148     function updateTokenDetails(string _newTokenDetails) public onlyOwner {
1149         emit LogUpdateTokenDetails(tokenDetails, _newTokenDetails);
1150         tokenDetails = _newTokenDetails;
1151     }
1152 
1153     /**
1154     * @notice allows owner to change token granularity
1155     * @param _granularity granularity level of the token
1156     */
1157     function changeGranularity(uint256 _granularity) public onlyOwner {
1158         require(_granularity != 0, "Granularity can not be 0");
1159         emit LogGranularityChanged(granularity, _granularity);
1160         granularity = _granularity;
1161     }
1162 
1163     /**
1164     * @notice keeps track of the number of non-zero token holders
1165     * @param _from sender of transfer
1166     * @param _to receiver of transfer
1167     * @param _value value of transfer
1168     */
1169     function adjustInvestorCount(address _from, address _to, uint256 _value) internal {
1170         if ((_value == 0) || (_from == _to)) {
1171             return;
1172         }
1173         // Check whether receiver is a new token holder
1174         if ((balanceOf(_to) == 0) && (_to != address(0))) {
1175             investorCount = investorCount.add(1);
1176         }
1177         // Check whether sender is moving all of their tokens
1178         if (_value == balanceOf(_from)) {
1179             investorCount = investorCount.sub(1);
1180         }
1181         //Also adjust investor list
1182         if (!investorListed[_to] && (_to != address(0))) {
1183             investors.push(_to);
1184             investorListed[_to] = true;
1185         }
1186 
1187     }
1188 
1189     /**
1190     * @notice removes addresses with zero balances from the investors list
1191     * @param _start Index in investor list at which to start removing zero balances
1192     * @param _iters Max number of iterations of the for loop
1193     * NB - pruning this list will mean you may not be able to iterate over investors on-chain as of a historical checkpoint
1194     */
1195     function pruneInvestors(uint256 _start, uint256 _iters) public onlyOwner {
1196         for (uint256 i = _start; i < Math.min256(_start.add(_iters), investors.length); i++) {
1197             if ((i < investors.length) && (balanceOf(investors[i]) == 0)) {
1198                 investorListed[investors[i]] = false;
1199                 investors[i] = investors[investors.length - 1];
1200                 investors.length--;
1201             }
1202         }
1203     }
1204 
1205     /**
1206      * @notice gets length of investors array
1207      * NB - this length may differ from investorCount if list has not been pruned of zero balance investors
1208      * @return length
1209      */
1210     function getInvestorsLength() public view returns(uint256) {
1211         return investors.length;
1212     }
1213 
1214     /**
1215      * @notice freeze all the transfers
1216      */
1217     function freezeTransfers() public onlyOwner {
1218         require(!freeze);
1219         freeze = true;
1220         emit LogFreezeTransfers(freeze, now);
1221     }
1222 
1223     /**
1224      * @notice un-freeze all the transfers
1225      */
1226     function unfreezeTransfers() public onlyOwner {
1227         require(freeze);
1228         freeze = false;
1229         emit LogFreezeTransfers(freeze, now);
1230     }
1231 
1232     /**
1233      * @notice adjust totalsupply at checkpoint after minting or burning tokens
1234      */
1235     function adjustTotalSupplyCheckpoints() internal {
1236         adjustCheckpoints(checkpointTotalSupply, totalSupply());
1237     }
1238 
1239     /**
1240      * @notice adjust token holder balance at checkpoint after a token transfer
1241      * @param _investor address of the token holder affected
1242      */
1243     function adjustBalanceCheckpoints(address _investor) internal {
1244         adjustCheckpoints(checkpointBalances[_investor], balanceOf(_investor));
1245     }
1246 
1247     /**
1248      * @notice store the changes to the checkpoint objects
1249      * @param _checkpoints the affected checkpoint object array
1250      * @param _newValue the new value that needs to be stored
1251      */
1252     function adjustCheckpoints(Checkpoint[] storage _checkpoints, uint256 _newValue) internal {
1253         //No checkpoints set yet
1254         if (currentCheckpointId == 0) {
1255             return;
1256         }
1257         //No previous checkpoint data - add current balance against checkpoint
1258         if (_checkpoints.length == 0) {
1259             _checkpoints.push(
1260                 Checkpoint({
1261                     checkpointId: currentCheckpointId,
1262                     value: _newValue
1263                 })
1264             );
1265             return;
1266         }
1267         //No new checkpoints since last update
1268         if (_checkpoints[_checkpoints.length - 1].checkpointId == currentCheckpointId) {
1269             return;
1270         }
1271         //New checkpoint, so record balance
1272         _checkpoints.push(
1273             Checkpoint({
1274                 checkpointId: currentCheckpointId,
1275                 value: _newValue
1276             })
1277         );
1278     }
1279 
1280     /**
1281      * @notice Overloaded version of the transfer function
1282      * @param _to receiver of transfer
1283      * @param _value value of transfer
1284      * @return bool success
1285      */
1286     function transfer(address _to, uint256 _value) public returns (bool success) {
1287         adjustInvestorCount(msg.sender, _to, _value);
1288         require(verifyTransfer(msg.sender, _to, _value), "Transfer is not valid");
1289         adjustBalanceCheckpoints(msg.sender);
1290         adjustBalanceCheckpoints(_to);
1291         require(super.transfer(_to, _value));
1292         return true;
1293     }
1294 
1295     /**
1296      * @notice Overloaded version of the transferFrom function
1297      * @param _from sender of transfer
1298      * @param _to receiver of transfer
1299      * @param _value value of transfer
1300      * @return bool success
1301      */
1302     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
1303         adjustInvestorCount(_from, _to, _value);
1304         require(verifyTransfer(_from, _to, _value), "Transfer is not valid");
1305         adjustBalanceCheckpoints(_from);
1306         adjustBalanceCheckpoints(_to);
1307         require(super.transferFrom(_from, _to, _value));
1308         return true;
1309     }
1310 
1311     /**
1312      * @notice validate transfer with TransferManager module if it exists
1313      * @dev TransferManager module has a key of 2
1314      * @param _from sender of transfer
1315      * @param _to receiver of transfer
1316      * @param _amount value of transfer
1317      * @return bool
1318      */
1319     function verifyTransfer(address _from, address _to, uint256 _amount) public checkGranularity(_amount) returns (bool) {
1320         if (!freeze) {
1321             bool isTransfer = false;
1322             if (transferFunctions[getSig(msg.data)]) {
1323               isTransfer = true;
1324             }
1325             if (modules[TRANSFERMANAGER_KEY].length == 0) {
1326                 return true;
1327             }
1328             bool isInvalid = false;
1329             bool isValid = false;
1330             bool isForceValid = false;
1331             for (uint8 i = 0; i < modules[TRANSFERMANAGER_KEY].length; i++) {
1332                 ITransferManager.Result valid = ITransferManager(modules[TRANSFERMANAGER_KEY][i].moduleAddress).verifyTransfer(_from, _to, _amount, isTransfer);
1333                 if (valid == ITransferManager.Result.INVALID) {
1334                     isInvalid = true;
1335                 }
1336                 if (valid == ITransferManager.Result.VALID) {
1337                     isValid = true;
1338                 }
1339                 if (valid == ITransferManager.Result.FORCE_VALID) {
1340                     isForceValid = true;
1341                 }
1342             }
1343             return isForceValid ? true : (isInvalid ? false : isValid);
1344       }
1345       return false;
1346     }
1347 
1348     /**
1349      * @notice End token minting period permanently for Issuer
1350      */
1351     function finishMintingIssuer() public onlyOwner {
1352         finishedIssuerMinting = true;
1353         emit LogFinishMintingIssuer(now);
1354     }
1355 
1356     /**
1357      * @notice End token minting period permanently for STOs
1358      */
1359     function finishMintingSTO() public onlyOwner {
1360         finishedSTOMinting = true;
1361         emit LogFinishMintingSTO(now);
1362     }
1363 
1364     /**
1365      * @notice mints new tokens and assigns them to the target _investor.
1366      * @dev Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
1367      * @param _investor Address to whom the minted tokens will be dilivered
1368      * @param _amount Number of tokens get minted
1369      * @return success
1370      */
1371     function mint(address _investor, uint256 _amount) public onlyModule(STO_KEY, true) checkGranularity(_amount) isMintingAllowed() returns (bool success) {
1372         require(_investor != address(0), "Investor address should not be 0x");
1373         adjustInvestorCount(address(0), _investor, _amount);
1374         require(verifyTransfer(address(0), _investor, _amount), "Transfer is not valid");
1375         adjustBalanceCheckpoints(_investor);
1376         adjustTotalSupplyCheckpoints();
1377         totalSupply_ = totalSupply_.add(_amount);
1378         balances[_investor] = balances[_investor].add(_amount);
1379         emit Minted(_investor, _amount);
1380         emit Transfer(address(0), _investor, _amount);
1381         return true;
1382     }
1383 
1384     /**
1385      * @notice mints new tokens and assigns them to the target _investor.
1386      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
1387      * @param _investors A list of addresses to whom the minted tokens will be dilivered
1388      * @param _amounts A list of number of tokens get minted and transfer to corresponding address of the investor from _investor[] list
1389      * @return success
1390      */
1391     function mintMulti(address[] _investors, uint256[] _amounts) public onlyModule(STO_KEY, true) returns (bool success) {
1392         require(_investors.length == _amounts.length, "Mis-match in the length of the arrays");
1393         for (uint256 i = 0; i < _investors.length; i++) {
1394             mint(_investors[i], _amounts[i]);
1395         }
1396         return true;
1397     }
1398 
1399     /**
1400      * @notice Validate permissions with PermissionManager if it exists, If no Permission return false
1401      * @dev Note that IModule withPerm will allow ST owner all permissions anyway
1402      * @dev this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
1403      * @param _delegate address of delegate
1404      * @param _module address of PermissionManager module
1405      * @param _perm the permissions
1406      * @return success
1407      */
1408     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool) {
1409         if (modules[PERMISSIONMANAGER_KEY].length == 0) {
1410             return false;
1411         }
1412 
1413         for (uint8 i = 0; i < modules[PERMISSIONMANAGER_KEY].length; i++) {
1414             if (IPermissionManager(modules[PERMISSIONMANAGER_KEY][i].moduleAddress).checkPermission(_delegate, _module, _perm)) {
1415                 return true;
1416             }
1417         }
1418     }
1419 
1420     /**
1421      * @notice used to set the token Burner address. It only be called by the owner
1422      * @param _tokenBurner Address of the token burner contract
1423      */
1424     function setTokenBurner(address _tokenBurner) public onlyOwner {
1425         tokenBurner = ITokenBurner(_tokenBurner);
1426     }
1427 
1428     /**
1429      * @notice Burn function used to burn the securityToken
1430      * @param _value No. of token that get burned
1431      */
1432     function burn(uint256 _value) checkGranularity(_value) public {
1433         adjustInvestorCount(msg.sender, address(0), _value);
1434         require(tokenBurner != address(0), "Token Burner contract address is not set yet");
1435         require(verifyTransfer(msg.sender, address(0), _value), "Transfer is not valid");
1436         require(_value <= balances[msg.sender], "Value should no be greater than the balance of msg.sender");
1437         adjustBalanceCheckpoints(msg.sender);
1438         adjustTotalSupplyCheckpoints();
1439         // no need to require value <= totalSupply, since that would imply the
1440         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1441 
1442         balances[msg.sender] = balances[msg.sender].sub(_value);
1443         require(tokenBurner.burn(msg.sender, _value), "Token burner process is not validated");
1444         totalSupply_ = totalSupply_.sub(_value);
1445         emit Burnt(msg.sender, _value);
1446         emit Transfer(msg.sender, address(0), _value);
1447     }
1448 
1449     /**
1450      * @notice Get function signature from _data
1451      * @param _data passed data
1452      * @return bytes4 sig
1453      */
1454     function getSig(bytes _data) internal pure returns (bytes4 sig) {
1455         uint len = _data.length < 4 ? _data.length : 4;
1456         for (uint i = 0; i < len; i++) {
1457             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
1458         }
1459     }
1460 
1461     /**
1462      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
1463      * @return uint256
1464      */
1465     function createCheckpoint() public onlyModule(CHECKPOINT_KEY, true) returns(uint256) {
1466         require(currentCheckpointId < 2**256 - 1);
1467         currentCheckpointId = currentCheckpointId + 1;
1468         emit LogCheckpointCreated(currentCheckpointId, now);
1469         return currentCheckpointId;
1470     }
1471 
1472     /**
1473      * @notice Queries totalSupply as of a defined checkpoint
1474      * @param _checkpointId Checkpoint ID to query
1475      * @return uint256
1476      */
1477     function totalSupplyAt(uint256 _checkpointId) public view returns(uint256) {
1478         return getValueAt(checkpointTotalSupply, _checkpointId, totalSupply());
1479     }
1480 
1481     /**
1482      * @notice Queries value at a defined checkpoint
1483      * @param checkpoints is array of Checkpoint objects
1484      * @param _checkpointId Checkpoint ID to query
1485      * @param _currentValue Current value of checkpoint
1486      * @return uint256
1487      */
1488     function getValueAt(Checkpoint[] storage checkpoints, uint256 _checkpointId, uint256 _currentValue) internal view returns(uint256) {
1489         require(_checkpointId <= currentCheckpointId);
1490         //Checkpoint id 0 is when the token is first created - everyone has a zero balance
1491         if (_checkpointId == 0) {
1492           return 0;
1493         }
1494         if (checkpoints.length == 0) {
1495             return _currentValue;
1496         }
1497         if (checkpoints[0].checkpointId >= _checkpointId) {
1498             return checkpoints[0].value;
1499         }
1500         if (checkpoints[checkpoints.length - 1].checkpointId < _checkpointId) {
1501             return _currentValue;
1502         }
1503         if (checkpoints[checkpoints.length - 1].checkpointId == _checkpointId) {
1504             return checkpoints[checkpoints.length - 1].value;
1505         }
1506         uint256 min = 0;
1507         uint256 max = checkpoints.length - 1;
1508         while (max > min) {
1509             uint256 mid = (max + min) / 2;
1510             if (checkpoints[mid].checkpointId == _checkpointId) {
1511                 max = mid;
1512                 break;
1513             }
1514             if (checkpoints[mid].checkpointId < _checkpointId) {
1515                 min = mid + 1;
1516             } else {
1517                 max = mid;
1518             }
1519         }
1520         return checkpoints[max].value;
1521     }
1522 
1523     /**
1524      * @notice Queries balances as of a defined checkpoint
1525      * @param _investor Investor to query balance for
1526      * @param _checkpointId Checkpoint ID to query as of
1527      */
1528     function balanceOfAt(address _investor, uint256 _checkpointId) public view returns(uint256) {
1529         return getValueAt(checkpointBalances[_investor], _checkpointId, balanceOf(_investor));
1530     }
1531 
1532 }
1533 
1534 /**
1535  * @title Interface for security token proxy deployment
1536  */
1537 contract ISTProxy {
1538 
1539     /**
1540      * @notice deploys the token and adds default modules like permission manager and transfer manager.
1541      * Future versions of the proxy can attach different modules or pass some other paramters.
1542      */
1543     function deployToken(string _name, string _symbol, uint8 _decimals, string _tokenDetails, address _issuer, bool _divisible, address _polymathRegistry)
1544         public returns (address);
1545 }
1546 
1547 /**
1548  * @title Interface for the polymath security token registry contract
1549  */
1550 contract ISecurityTokenRegistry {
1551 
1552     bytes32 public protocolVersion = "0.0.1";
1553     mapping (bytes32 => address) public protocolVersionST;
1554 
1555     struct SecurityTokenData {
1556         string symbol;
1557         string tokenDetails;
1558     }
1559 
1560     mapping(address => SecurityTokenData) securityTokens;
1561     mapping(string => address) symbols;
1562 
1563     /**
1564      * @notice Creates a new Security Token and saves it to the registry
1565      * @param _name Name of the token
1566      * @param _symbol Ticker symbol of the security token
1567      * @param _tokenDetails off-chain details of the token
1568      */
1569     function generateSecurityToken(string _name, string _symbol, string _tokenDetails, bool _divisible) public;
1570 
1571     function setProtocolVersion(address _stVersionProxyAddress, bytes32 _version) public;
1572 
1573     /**
1574      * @notice Get security token address by ticker name
1575      * @param _symbol Symbol of the Scurity token
1576      * @return address _symbol
1577      */
1578     function getSecurityTokenAddress(string _symbol) public view returns (address);
1579 
1580      /**
1581      * @notice Get security token data by its address
1582      * @param _securityToken Address of the Scurity token
1583      * @return string, address, bytes32
1584      */
1585     function getSecurityTokenData(address _securityToken) public view returns (string, address, string);
1586 
1587     /**
1588     * @notice Check that Security Token is registered
1589     * @param _securityToken Address of the Scurity token
1590     * @return bool
1591     */
1592     function isSecurityToken(address _securityToken) public view returns (bool);
1593 }
1594 
1595 /**
1596  * @title Utility contract for reusable code
1597  */
1598 contract Util {
1599 
1600    /**
1601     * @notice changes a string to upper case
1602     * @param _base string to change
1603     */
1604     function upper(string _base) internal pure returns (string) {
1605         bytes memory _baseBytes = bytes(_base);
1606         for (uint i = 0; i < _baseBytes.length; i++) {
1607             bytes1 b1 = _baseBytes[i];
1608             if (b1 >= 0x61 && b1 <= 0x7A) {
1609                 b1 = bytes1(uint8(b1)-32);
1610             }
1611             _baseBytes[i] = b1;
1612         }
1613         return string(_baseBytes);
1614     }
1615 
1616 }
1617 
1618 /**
1619  * @title Registry contract for issuers to register their security tokens
1620  */
1621 contract SecurityTokenRegistry is ISecurityTokenRegistry, Util, Pausable, RegistryUpdater, ReclaimTokens {
1622 
1623     // Registration fee in POLY base 18 decimals
1624     uint256 public registrationFee;
1625     // Emit when changePolyRegisterationFee is called
1626     event LogChangePolyRegisterationFee(uint256 _oldFee, uint256 _newFee);
1627 
1628     // Emit at the time of launching of new security token
1629     event LogNewSecurityToken(string _ticker, address indexed _securityTokenAddress, address indexed _owner);
1630     event LogAddCustomSecurityToken(string _name, string _symbol, address _securityToken, uint256 _addedAt);
1631 
1632     constructor (
1633         address _polymathRegistry,
1634         address _stVersionProxy,
1635         uint256 _registrationFee
1636     )
1637     public
1638     RegistryUpdater(_polymathRegistry)
1639     {
1640         registrationFee = _registrationFee;
1641         // By default, the STR version is set to 0.0.1
1642         setProtocolVersion(_stVersionProxy, "0.0.1");
1643     }
1644 
1645     /**
1646      * @notice Creates a new Security Token and saves it to the registry
1647      * @param _name Name of the token
1648      * @param _symbol Ticker symbol of the security token
1649      * @param _tokenDetails off-chain details of the token
1650      * @param _divisible Set to true if token is divisible
1651      */
1652     function generateSecurityToken(string _name, string _symbol, string _tokenDetails, bool _divisible) public whenNotPaused {
1653         require(bytes(_name).length > 0 && bytes(_symbol).length > 0, "Name and Symbol string length should be greater than 0");
1654         require(ITickerRegistry(tickerRegistry).checkValidity(_symbol, msg.sender, _name), "Trying to use non-valid symbol");
1655         if(registrationFee > 0)
1656             require(ERC20(polyToken).transferFrom(msg.sender, this, registrationFee), "Failed transferFrom because of sufficent Allowance is not provided");
1657         string memory symbol = upper(_symbol);
1658         address newSecurityTokenAddress = ISTProxy(protocolVersionST[protocolVersion]).deployToken(
1659             _name,
1660             symbol,
1661             18,
1662             _tokenDetails,
1663             msg.sender,
1664             _divisible,
1665             polymathRegistry
1666         );
1667 
1668         securityTokens[newSecurityTokenAddress] = SecurityTokenData(symbol, _tokenDetails);
1669         symbols[symbol] = newSecurityTokenAddress;
1670         emit LogNewSecurityToken(symbol, newSecurityTokenAddress, msg.sender);
1671     }
1672 
1673     /**
1674      * @notice Add a new custom (Token should follow the ISecurityToken interface) Security Token and saves it to the registry
1675      * @param _name Name of the token
1676      * @param _symbol Ticker symbol of the security token
1677      * @param _owner Owner of the token
1678      * @param _securityToken Address of the securityToken
1679      * @param _tokenDetails off-chain details of the token
1680      * @param _swarmHash off-chain details about the issuer company
1681      */
1682     function addCustomSecurityToken(string _name, string _symbol, address _owner, address _securityToken, string _tokenDetails, bytes32 _swarmHash) public onlyOwner whenNotPaused {
1683         require(bytes(_name).length > 0 && bytes(_symbol).length > 0, "Name and Symbol string length should be greater than 0");
1684         string memory symbol = upper(_symbol);
1685         require(_securityToken != address(0) && symbols[symbol] == address(0), "Symbol is already at the polymath network or entered security token address is 0x");
1686         require(_owner != address(0));
1687         require(!(ITickerRegistry(tickerRegistry).isReserved(symbol, _owner, _name, _swarmHash)), "Trying to use non-valid symbol");
1688         symbols[symbol] = _securityToken;
1689         securityTokens[_securityToken] = SecurityTokenData(symbol, _tokenDetails);
1690         emit LogAddCustomSecurityToken(_name, symbol, _securityToken, now);
1691     }
1692 
1693     /**
1694     * @notice Changes the protocol version and the SecurityToken contract
1695     * @notice Used only by Polymath to upgrade the SecurityToken contract and add more functionalities to future versions
1696     * @notice Changing versions does not affect existing tokens.
1697     */
1698     function setProtocolVersion(address _stVersionProxyAddress, bytes32 _version) public onlyOwner {
1699         protocolVersion = _version;
1700         protocolVersionST[_version] = _stVersionProxyAddress;
1701     }
1702 
1703     //////////////////////////////
1704     ///////// Get Functions
1705     //////////////////////////////
1706     /**
1707      * @notice Get security token address by ticker name
1708      * @param _symbol Symbol of the Scurity token
1709      * @return address
1710      */
1711     function getSecurityTokenAddress(string _symbol) public view returns (address) {
1712         string memory __symbol = upper(_symbol);
1713         return symbols[__symbol];
1714     }
1715 
1716      /**
1717      * @notice Get security token data by its address
1718      * @param _securityToken Address of the Scurity token
1719      * @return string
1720      * @return address
1721      * @return string
1722      */
1723     function getSecurityTokenData(address _securityToken) public view returns (string, address, string) {
1724         return (
1725             securityTokens[_securityToken].symbol,
1726             ISecurityToken(_securityToken).owner(),
1727             securityTokens[_securityToken].tokenDetails
1728         );
1729     }
1730 
1731     /**
1732     * @notice Check that Security Token is registered
1733     * @param _securityToken Address of the Scurity token
1734     * @return bool
1735     */
1736     function isSecurityToken(address _securityToken) public view returns (bool) {
1737         return (keccak256(bytes(securityTokens[_securityToken].symbol)) != keccak256(""));
1738     }
1739 
1740     /**
1741      * @notice set the ticker registration fee in POLY tokens
1742      * @param _registrationFee registration fee in POLY tokens (base 18 decimals)
1743      */
1744     function changePolyRegisterationFee(uint256 _registrationFee) public onlyOwner {
1745         require(registrationFee != _registrationFee);
1746         emit LogChangePolyRegisterationFee(registrationFee, _registrationFee);
1747         registrationFee = _registrationFee;
1748     }
1749 
1750      /**
1751      * @notice pause registration function
1752      */
1753     function unpause() public onlyOwner  {
1754         _unpause();
1755     }
1756 
1757     /**
1758      * @notice unpause registration function
1759      */
1760     function pause() public onlyOwner {
1761         _pause();
1762     }
1763 
1764 }