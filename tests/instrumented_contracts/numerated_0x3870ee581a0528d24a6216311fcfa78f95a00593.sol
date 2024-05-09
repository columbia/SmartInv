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
17         require(!paused);
18         _;
19     }
20 
21     /**
22     * @notice Modifier to make a function callable only when the contract is paused.
23     */
24     modifier whenPaused() {
25         require(paused);
26         _;
27     }
28 
29    /**
30     * @notice called by the owner to pause, triggers stopped state
31     */
32     function _pause() internal {
33         require(!paused);
34         paused = true;
35         emit Pause(now);
36     }
37 
38     /**
39     * @notice called by the owner to unpause, returns to normal state
40     */
41     function _unpause() internal {
42         require(paused);
43         paused = false;
44         emit Unpause(now);
45     }
46 
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
72     // benefit is lost if 'b' is also tested.
73     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74     if (a == 0) {
75       return 0;
76     }
77 
78     c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers, truncating the quotient.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     // uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return a / b;
91   }
92 
93   /**
94   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95   */
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   /**
102   * @dev Adds two numbers, throws on overflow.
103   */
104   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105     c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances.
114  */
115 contract BasicToken is ERC20Basic {
116   using SafeMath for uint256;
117 
118   mapping(address => uint256) balances;
119 
120   uint256 totalSupply_;
121 
122   /**
123   * @dev total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return totalSupply_;
127   }
128 
129   /**
130   * @dev transfer token for a specified address
131   * @param _to The address to transfer to.
132   * @param _value The amount to be transferred.
133   */
134   function transfer(address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[msg.sender]);
137 
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     emit Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public view returns (uint256) {
150     return balances[_owner];
151   }
152 
153 }
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender)
161     public view returns (uint256);
162 
163   function transferFrom(address from, address to, uint256 value)
164     public returns (bool);
165 
166   function approve(address spender, uint256 value) public returns (bool);
167   event Approval(
168     address indexed owner,
169     address indexed spender,
170     uint256 value
171   );
172 }
173 
174 /**
175  * @title Standard ERC20 token
176  *
177  * @dev Implementation of the basic standard token.
178  * @dev https://github.com/ethereum/EIPs/issues/20
179  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
180  */
181 contract StandardToken is ERC20, BasicToken {
182 
183   mapping (address => mapping (address => uint256)) internal allowed;
184 
185 
186   /**
187    * @dev Transfer tokens from one address to another
188    * @param _from address The address which you want to send tokens from
189    * @param _to address The address which you want to transfer to
190    * @param _value uint256 the amount of tokens to be transferred
191    */
192   function transferFrom(
193     address _from,
194     address _to,
195     uint256 _value
196   )
197     public
198     returns (bool)
199   {
200     require(_to != address(0));
201     require(_value <= balances[_from]);
202     require(_value <= allowed[_from][msg.sender]);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     emit Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     emit Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(
234     address _owner,
235     address _spender
236    )
237     public
238     view
239     returns (uint256)
240   {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _addedValue The amount of tokens to increase the allowance by.
253    */
254   function increaseApproval(
255     address _spender,
256     uint _addedValue
257   )
258     public
259     returns (bool)
260   {
261     allowed[msg.sender][_spender] = (
262       allowed[msg.sender][_spender].add(_addedValue));
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(
278     address _spender,
279     uint _subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 /**
297  * @title DetailedERC20 token
298  * @dev The decimals are only for visualization purposes.
299  * All the operations are done using the smallest and indivisible token unit,
300  * just as on Ethereum all the operations are done in wei.
301  */
302 contract DetailedERC20 is ERC20 {
303   string public name;
304   string public symbol;
305   uint8 public decimals;
306 
307   constructor(string _name, string _symbol, uint8 _decimals) public {
308     name = _name;
309     symbol = _symbol;
310     decimals = _decimals;
311   }
312 }
313 
314 /**
315  * @title Interface for the ST20 token standard
316  */
317 contract IST20 is StandardToken, DetailedERC20 {
318 
319     // off-chain hash
320     string public tokenDetails;
321 
322     //transfer, transferFrom must respect use respect the result of verifyTransfer
323     function verifyTransfer(address _from, address _to, uint256 _amount) public returns (bool success);
324 
325     /**
326      * @notice mints new tokens and assigns them to the target _investor.
327      * Can only be called by the STO attached to the token (Or by the ST owner if there's no STO attached yet)
328      */
329     function mint(address _investor, uint256 _amount) public returns (bool success);
330 
331     /**
332      * @notice Burn function used to burn the securityToken
333      * @param _value No. of token that get burned
334      */
335     function burn(uint256 _value) public;
336 
337     event Minted(address indexed to, uint256 amount);
338     event Burnt(address indexed _burner, uint256 _value);
339 
340 }
341 
342 /**
343  * @title Ownable
344  * @dev The Ownable contract has an owner address, and provides basic authorization control
345  * functions, this simplifies the implementation of "user permissions".
346  */
347 contract Ownable {
348   address public owner;
349 
350 
351   event OwnershipRenounced(address indexed previousOwner);
352   event OwnershipTransferred(
353     address indexed previousOwner,
354     address indexed newOwner
355   );
356 
357 
358   /**
359    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
360    * account.
361    */
362   constructor() public {
363     owner = msg.sender;
364   }
365 
366   /**
367    * @dev Throws if called by any account other than the owner.
368    */
369   modifier onlyOwner() {
370     require(msg.sender == owner);
371     _;
372   }
373 
374   /**
375    * @dev Allows the current owner to relinquish control of the contract.
376    */
377   function renounceOwnership() public onlyOwner {
378     emit OwnershipRenounced(owner);
379     owner = address(0);
380   }
381 
382   /**
383    * @dev Allows the current owner to transfer control of the contract to a newOwner.
384    * @param _newOwner The address to transfer ownership to.
385    */
386   function transferOwnership(address _newOwner) public onlyOwner {
387     _transferOwnership(_newOwner);
388   }
389 
390   /**
391    * @dev Transfers control of the contract to a newOwner.
392    * @param _newOwner The address to transfer ownership to.
393    */
394   function _transferOwnership(address _newOwner) internal {
395     require(_newOwner != address(0));
396     emit OwnershipTransferred(owner, _newOwner);
397     owner = _newOwner;
398   }
399 }
400 
401 /**
402  * @title Interface for all security tokens
403  */
404 contract ISecurityToken is IST20, Ownable {
405 
406     uint8 public constant PERMISSIONMANAGER_KEY = 1;
407     uint8 public constant TRANSFERMANAGER_KEY = 2;
408     uint8 public constant STO_KEY = 3;
409     uint8 public constant CHECKPOINT_KEY = 4;
410     uint256 public granularity;
411 
412     // Value of current checkpoint
413     uint256 public currentCheckpointId;
414 
415     // Total number of non-zero token holders
416     uint256 public investorCount;
417 
418     // List of token holders
419     address[] public investors;
420 
421     // Permissions this to a Permission module, which has a key of 1
422     // If no Permission return false - note that IModule withPerm will allow ST owner all permissions anyway
423     // this allows individual modules to override this logic if needed (to not allow ST owner all permissions)
424     function checkPermission(address _delegate, address _module, bytes32 _perm) public view returns(bool);
425 
426     /**
427      * @notice returns module list for a module type
428      * @param _moduleType is which type of module we are trying to remove
429      * @param _moduleIndex is the index of the module within the chosen type
430      */
431     function getModule(uint8 _moduleType, uint _moduleIndex) public view returns (bytes32, address);
432 
433     /**
434      * @notice returns module list for a module name - will return first match
435      * @param _moduleType is which type of module we are trying to remove
436      * @param _name is the name of the module within the chosen type
437      */
438     function getModuleByName(uint8 _moduleType, bytes32 _name) public view returns (bytes32, address);
439 
440     /**
441      * @notice Queries totalSupply as of a defined checkpoint
442      * @param _checkpointId Checkpoint ID to query as of
443      */
444     function totalSupplyAt(uint256 _checkpointId) public view returns(uint256);
445 
446     /**
447      * @notice Queries balances as of a defined checkpoint
448      * @param _investor Investor to query balance for
449      * @param _checkpointId Checkpoint ID to query as of
450      */
451     function balanceOfAt(address _investor, uint256 _checkpointId) public view returns(uint256);
452 
453     /**
454      * @notice Creates a checkpoint that can be used to query historical balances / totalSuppy
455      */
456     function createCheckpoint() public returns(uint256);
457 
458     /**
459      * @notice gets length of investors array
460      * NB - this length may differ from investorCount if list has not been pruned of zero balance investors
461      * @return length
462      */
463     function getInvestorsLength() public view returns(uint256);
464 
465 }
466 
467 /**
468  * @title Interface that any module factory contract should implement
469  */
470 contract IModuleFactory is Ownable {
471 
472     ERC20 public polyToken;
473     uint256 public setupCost;
474     uint256 public usageCost;
475     uint256 public monthlySubscriptionCost;
476 
477     event LogChangeFactorySetupFee(uint256 _oldSetupcost, uint256 _newSetupCost, address _moduleFactory);
478     event LogChangeFactoryUsageFee(uint256 _oldUsageCost, uint256 _newUsageCost, address _moduleFactory);
479     event LogChangeFactorySubscriptionFee(uint256 _oldSubscriptionCost, uint256 _newMonthlySubscriptionCost, address _moduleFactory);
480     event LogGenerateModuleFromFactory(address _module, bytes32 indexed _moduleName, address indexed _moduleFactory, address _creator, uint256 _timestamp);
481 
482     /**
483      * @notice Constructor
484      * @param _polyAddress Address of the polytoken
485      */
486     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public {
487       polyToken = ERC20(_polyAddress);
488       setupCost = _setupCost;
489       usageCost = _usageCost;
490       monthlySubscriptionCost = _subscriptionCost;
491     }
492 
493     //Should create an instance of the Module, or throw
494     function deploy(bytes _data) external returns(address);
495 
496     /**
497      * @notice Type of the Module factory
498      */
499     function getType() public view returns(uint8);
500 
501     /**
502      * @notice Get the name of the Module
503      */
504     function getName() public view returns(bytes32);
505 
506     /**
507      * @notice Get the description of the Module
508      */
509     function getDescription() public view returns(string);
510 
511     /**
512      * @notice Get the title of the Module
513      */
514     function getTitle() public view returns(string);
515 
516     /**
517      * @notice Get the Instructions that helped to used the module
518      */
519     function getInstructions() public view returns (string);
520 
521     /**
522      * @notice Get the tags related to the module factory
523      */
524     function getTags() public view returns (bytes32[]);
525 
526     //Pull function sig from _data
527     function getSig(bytes _data) internal pure returns (bytes4 sig) {
528         uint len = _data.length < 4 ? _data.length : 4;
529         for (uint i = 0; i < len; i++) {
530             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (len - 1 - i))));
531         }
532     }
533 
534     /**
535      * @notice used to change the fee of the setup cost
536      * @param _newSetupCost new setup cost
537      */
538     function changeFactorySetupFee(uint256 _newSetupCost) public onlyOwner {
539         emit LogChangeFactorySetupFee(setupCost, _newSetupCost, address(this));
540         setupCost = _newSetupCost;
541     }
542 
543     /**
544      * @notice used to change the fee of the usage cost
545      * @param _newUsageCost new usage cost
546      */
547     function changeFactoryUsageFee(uint256 _newUsageCost) public onlyOwner {
548         emit LogChangeFactoryUsageFee(usageCost, _newUsageCost, address(this));
549         usageCost = _newUsageCost;
550     }
551 
552     /**
553      * @notice used to change the fee of the subscription cost
554      * @param _newSubscriptionCost new subscription cost
555      */
556     function changeFactorySubscriptionFee(uint256 _newSubscriptionCost) public onlyOwner {
557         emit LogChangeFactorySubscriptionFee(monthlySubscriptionCost, _newSubscriptionCost, address(this));
558         monthlySubscriptionCost = _newSubscriptionCost;
559         
560     }
561 
562 }
563 
564 /**
565  * @title Interface that any module contract should implement
566  */
567 contract IModule {
568 
569     address public factory;
570 
571     address public securityToken;
572 
573     bytes32 public constant FEE_ADMIN = "FEE_ADMIN";
574 
575     ERC20 public polyToken;
576 
577     /**
578      * @notice Constructor
579      * @param _securityToken Address of the security token
580      * @param _polyAddress Address of the polytoken
581      */
582     constructor (address _securityToken, address _polyAddress) public {
583         securityToken = _securityToken;
584         factory = msg.sender;
585         polyToken = ERC20(_polyAddress);
586     }
587 
588     /**
589      * @notice This function returns the signature of configure function
590      */
591     function getInitFunction() public pure returns (bytes4);
592 
593     //Allows owner, factory or permissioned delegate
594     modifier withPerm(bytes32 _perm) {
595         bool isOwner = msg.sender == ISecurityToken(securityToken).owner();
596         bool isFactory = msg.sender == factory;
597         require(isOwner||isFactory||ISecurityToken(securityToken).checkPermission(msg.sender, address(this), _perm), "Permission check failed");
598         _;
599     }
600 
601     modifier onlyOwner {
602         require(msg.sender == ISecurityToken(securityToken).owner(), "Sender is not owner");
603         _;
604     }
605 
606     modifier onlyFactory {
607         require(msg.sender == factory, "Sender is not factory");
608         _;
609     }
610 
611     modifier onlyFactoryOwner {
612         require(msg.sender == IModuleFactory(factory).owner(), "Sender is not factory owner");
613         _;
614     }
615 
616     /**
617      * @notice Return the permissions flag that are associated with Module
618      */
619     function getPermissions() public view returns(bytes32[]);
620 
621     /**
622      * @notice used to withdraw the fee by the factory owner
623      */
624     function takeFee(uint256 _amount) public withPerm(FEE_ADMIN) returns(bool) {
625         require(polyToken.transferFrom(address(this), IModuleFactory(factory).owner(), _amount), "Unable to take fee");
626         return true;
627     }
628 }
629 
630 /**
631  * @title Interface to be implemented by all Transfer Manager modules
632  */
633 contract ITransferManager is IModule, Pausable {
634 
635     //If verifyTransfer returns:
636     //  FORCE_VALID, the transaction will always be valid, regardless of other TM results
637     //  INVALID, then the transfer should not be allowed regardless of other TM results
638     //  VALID, then the transfer is valid for this TM
639     //  NA, then the result from this TM is ignored
640     enum Result {INVALID, NA, VALID, FORCE_VALID}
641 
642     function verifyTransfer(address _from, address _to, uint256 _amount, bool _isTransfer) public returns(Result);
643 
644     function unpause() onlyOwner public {
645         super._unpause();
646     }
647 
648     function pause() onlyOwner public {
649         super._pause();
650     }
651 }
652 
653 /////////////////////
654 // Module permissions
655 /////////////////////
656 //                                        Owner       WHITELIST      FLAGS
657 // modifyWhitelist                          X             X
658 // modifyWhitelistMulti                     X             X
659 
660 /**
661  * @title Transfer Manager module for limiting percentage of token supply a single address can hold
662  */
663 contract PercentageTransferManager is ITransferManager {
664     using SafeMath for uint256;
665 
666     // Permission key for modifying the whitelist
667     bytes32 public constant WHITELIST = "WHITELIST";
668 
669     // Maximum percentage that any holder can have, multiplied by 10**16 - e.g. 20% is 20 * 10**16
670     uint256 public maxHolderPercentage;
671 
672     // Addresses on this list are always able to send / receive tokens
673     mapping (address => bool) public whitelist;
674 
675     event LogModifyHolderPercentage(uint256 _oldHolderPercentage, uint256 _newHolderPercentage);
676     event LogModifyWhitelist(
677         address _investor,
678         uint256 _dateAdded,
679         address _addedBy,
680         bool    _valid
681     );
682 
683     /**
684      * @notice Constructor
685      * @param _securityToken Address of the security token
686      * @param _polyAddress Address of the polytoken
687      */
688     constructor (address _securityToken, address _polyAddress)
689     public
690     IModule(_securityToken, _polyAddress)
691     {
692     }
693 
694     /// @notice Used to verify the transfer transaction according to the rule implemented in the trnasfer managers
695     function verifyTransfer(address /* _from */, address _to, uint256 _amount, bool /* _isTransfer */) public returns(Result) {
696         if (!paused) {
697             // If an address is on the whitelist, it is allowed to hold more than maxHolderPercentage of the tokens.
698             if (whitelist[_to]) {
699                 return Result.NA;
700             }
701             uint256 newBalance = ISecurityToken(securityToken).balanceOf(_to).add(_amount);
702             if (newBalance.mul(10**uint256(ISecurityToken(securityToken).decimals())).div(ISecurityToken(securityToken).totalSupply()) > maxHolderPercentage) {
703                 return Result.INVALID;
704             }
705             return Result.NA;
706         }
707         return Result.NA;
708     }
709 
710     /**
711      * @notice Used to intialize the variables of the contract
712      * @param _maxHolderPercentage Maximum amount of ST20 tokens(in %) can hold by the investor
713      */
714     function configure(uint256 _maxHolderPercentage) public onlyFactory {
715         maxHolderPercentage = _maxHolderPercentage;
716     }
717 
718     /**
719      * @notice This function returns the signature of configure function
720      */
721     function getInitFunction() public pure returns (bytes4) {
722         return bytes4(keccak256("configure(uint256)"));
723     }
724 
725     /**
726     * @notice sets the maximum percentage that an individual token holder can hold
727     * @param _maxHolderPercentage is the new maximum percentage (multiplied by 10**16)
728     */
729     function changeHolderPercentage(uint256 _maxHolderPercentage) public onlyOwner {
730         emit LogModifyHolderPercentage(maxHolderPercentage, _maxHolderPercentage);
731         maxHolderPercentage = _maxHolderPercentage;
732     }
733 
734     /**
735     * @notice adds or removes addresses from the whitelist.
736     * @param _investor is the address to whitelist
737     * @param _valid whether or not the address it to be added or removed from the whitelist
738     */
739     function modifyWhitelist(address _investor, bool _valid) public withPerm(WHITELIST) {
740         whitelist[_investor] = _valid;
741         emit LogModifyWhitelist(_investor, now, msg.sender, _valid);
742     }
743 
744     /**
745     * @notice adds or removes addresses from the whitelist.
746     * @param _investors Array of the addresses to whitelist
747     * @param _valids Array of boolean value to decide whether or not the address it to be added or removed from the whitelist
748     */
749     function modifyWhitelistMulti(address[] _investors, bool[] _valids) public withPerm(WHITELIST) {
750         require(_investors.length == _valids.length, "Input array length mis-match");
751         for (uint i = 0; i < _investors.length; i++) {
752             modifyWhitelist(_investors[i], _valids[i]);
753         }
754     }
755 
756     /**
757      * @notice Return the permissions flag that are associated with Percentage transfer Manager
758      */
759     function getPermissions() public view returns(bytes32[]) {
760         bytes32[] memory allPermissions = new bytes32[](1);
761         allPermissions[0] = WHITELIST;
762         return allPermissions;
763     }
764 
765 }
766 
767 /**
768  * @title Factory for deploying PercentageTransferManager module
769  */
770 contract PercentageTransferManagerFactory is IModuleFactory {
771 
772     /**
773      * @notice Constructor
774      * @param _polyAddress Address of the polytoken
775      */
776     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
777       IModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
778     {
779 
780     }
781 
782     /**
783      * @notice used to launch the Module with the help of factory
784      * @param _data Data used for the intialization of the module factory variables
785      * @return address Contract address of the Module
786      */
787     function deploy(bytes _data) external returns(address) {
788         if(setupCost > 0)
789             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
790         PercentageTransferManager percentageTransferManager = new PercentageTransferManager(msg.sender, address(polyToken));
791         require(getSig(_data) == percentageTransferManager.getInitFunction(), "Provided data is not valid");
792         require(address(percentageTransferManager).call(_data), "Un-successfull call");
793         emit LogGenerateModuleFromFactory(address(percentageTransferManager), getName(), address(this), msg.sender, now);
794         return address(percentageTransferManager);
795 
796     }
797 
798     /**
799      * @notice Type of the Module factory
800      * @return uint8
801      */
802     function getType() public view returns(uint8) {
803         return 2;
804     }
805 
806     /**
807      * @notice Get the name of the Module
808      */
809     function getName() public view returns(bytes32) {
810         return "PercentageTransferManager";
811     }
812 
813     /**
814      * @notice Get the description of the Module
815      */
816     function getDescription() public view returns(string) {
817         return "Restrict the number of investors";
818     }
819 
820     /**
821      * @notice Get the title of the Module
822      */
823     function getTitle() public view returns(string) {
824         return "Percentage Transfer Manager";
825     }
826 
827     /**
828      * @notice Get the Instructions that helped to used the module
829      */
830     function getInstructions() public view returns(string) {
831         return "Allows an issuer to restrict the total number of non-zero token holders";
832     }
833 
834     /**
835      * @notice Get the tags related to the module factory
836      */
837     function getTags() public view returns(bytes32[]) {
838          bytes32[] memory availableTags = new bytes32[](2);
839         availableTags[0] = "Percentage";
840         availableTags[1] = "Transfer Restriction";
841         return availableTags;
842     }
843 }