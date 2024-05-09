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
631  * @title Interface to be implemented by all STO modules
632  */
633 contract ISTO is IModule, Pausable {
634 
635     using SafeMath for uint256;
636 
637     enum FundraiseType { ETH, POLY }
638     FundraiseType public fundraiseType;
639 
640     // Start time of the STO
641     uint256 public startTime;
642     // End time of the STO
643     uint256 public endTime;
644 
645     /**
646      * @notice use to verify the investment, whether the investor provide the allowance to the STO or not.
647      * @param _beneficiary Ethereum address of the beneficiary, who wants to buy the st-20
648      * @param _fundsAmount Amount invested by the beneficiary
649      */
650     function verifyInvestment(address _beneficiary, uint256 _fundsAmount) public view returns(bool) {
651         return polyToken.allowance(_beneficiary, address(this)) >= _fundsAmount;
652     }
653 
654     /**
655      * @notice Return ETH raised by the STO
656      */
657     function getRaisedEther() public view returns (uint256);
658 
659     /**
660      * @notice Return POLY raised by the STO
661      */
662     function getRaisedPOLY() public view returns (uint256);
663 
664     /**
665      * @notice Return the total no. of investors
666      */
667     function getNumberInvestors() public view returns (uint256);
668 
669     /**
670      * @notice pause (overridden function)
671      */
672     function pause() public onlyOwner {
673         require(now < endTime);
674         super._pause();
675     }
676 
677     /**
678      * @notice unpause (overridden function)
679      */
680     function unpause(uint256 _newEndDate) public onlyOwner {
681         require(_newEndDate >= endTime);
682         super._unpause();
683         endTime = _newEndDate;
684     }
685 
686     /**
687     * @notice Reclaim ERC20Basic compatible tokens
688     * @param _tokenContract The address of the token contract
689     */
690     function reclaimERC20(address _tokenContract) external onlyOwner {
691         require(_tokenContract != address(0));
692         ERC20Basic token = ERC20Basic(_tokenContract);
693         uint256 balance = token.balanceOf(address(this));
694         require(token.transfer(msg.sender, balance));
695     }
696 
697 }
698 
699 /**
700  * @title Helps contracts guard agains reentrancy attacks.
701  * @author Remco Bloemen <remco@2π.com>
702  * @notice If you mark a function `nonReentrant`, you should also
703  * mark it `external`.
704  */
705 contract ReentrancyGuard {
706 
707   /**
708    * @dev We use a single lock for the whole contract.
709    */
710   bool private reentrancyLock = false;
711 
712   /**
713    * @dev Prevents a contract from calling itself, directly or indirectly.
714    * @notice If you mark a function `nonReentrant`, you should also
715    * mark it `external`. Calling one nonReentrant function from
716    * another is not supported. Instead, you can implement a
717    * `private` function doing the actual work, and a `external`
718    * wrapper marked as `nonReentrant`.
719    */
720   modifier nonReentrant() {
721     require(!reentrancyLock);
722     reentrancyLock = true;
723     _;
724     reentrancyLock = false;
725   }
726 
727 }
728 
729 /**
730  * @title STO module for standard capped crowdsale
731  */
732 contract CappedSTO is ISTO, ReentrancyGuard {
733     using SafeMath for uint256;
734 
735     // Address where funds are collected and tokens are issued to
736     address public wallet;
737 
738     // How many token units a buyer gets per wei / base unit of POLY
739     uint256 public rate;
740 
741     // Amount of funds raised
742     uint256 public fundsRaised;
743 
744     uint256 public investorCount;
745 
746     // Amount of tokens sold
747     uint256 public tokensSold;
748 
749     //How many tokens this STO will be allowed to sell to investors
750     uint256 public cap;
751 
752     mapping (address => uint256) public investors;
753 
754     /**
755     * Event for token purchase logging
756     * @param purchaser who paid for the tokens
757     * @param beneficiary who got the tokens
758     * @param value weis paid for purchase
759     * @param amount amount of tokens purchased
760     */
761     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
762 
763     constructor (address _securityToken, address _polyAddress) public
764     IModule(_securityToken, _polyAddress)
765     {
766     }
767 
768     //////////////////////////////////
769     /**
770     * @notice fallback function ***DO NOT OVERRIDE***
771     */
772     function () external payable {
773         buyTokens(msg.sender);
774     }
775 
776     /**
777      * @notice Function used to intialize the contract variables
778      * @param _startTime Unix timestamp at which offering get started
779      * @param _endTime Unix timestamp at which offering get ended
780      * @param _cap Maximum No. of tokens for sale
781      * @param _rate Token units a buyer gets per wei / base unit of POLY
782      * @param _fundRaiseType Type of currency used to collect the funds
783      * @param _fundsReceiver Ethereum account address to hold the funds
784      */
785     function configure(
786         uint256 _startTime,
787         uint256 _endTime,
788         uint256 _cap,
789         uint256 _rate,
790         uint8 _fundRaiseType,
791         address _fundsReceiver
792     )
793     public
794     onlyFactory
795     {
796         require(_rate > 0, "Rate of token should be greater than 0");
797         require(_fundsReceiver != address(0), "Zero address is not permitted");
798         require(_startTime >= now && _endTime > _startTime, "Date parameters are not valid");
799         require(_cap > 0, "Cap should be greater than 0");
800         startTime = _startTime;
801         endTime = _endTime;
802         cap = _cap;
803         rate = _rate;
804         wallet = _fundsReceiver;
805         _check(_fundRaiseType);
806     }
807 
808     /**
809      * @notice This function returns the signature of configure function
810      */
811     function getInitFunction() public pure returns (bytes4) {
812         return bytes4(keccak256("configure(uint256,uint256,uint256,uint256,uint8,address)"));
813     }
814 
815     /**
816       * @notice low level token purchase ***DO NOT OVERRIDE***
817       * @param _beneficiary Address performing the token purchase
818       */
819     function buyTokens(address _beneficiary) public payable nonReentrant {
820         require(!paused);
821         require(fundraiseType == FundraiseType.ETH, "ETH should be the mode of investment");
822 
823         uint256 weiAmount = msg.value;
824         _processTx(_beneficiary, weiAmount);
825 
826         _forwardFunds();
827         _postValidatePurchase(_beneficiary, weiAmount);
828     }
829 
830     /**
831       * @notice low level token purchase
832       * @param _investedPOLY Amount of POLY invested
833       */
834     function buyTokensWithPoly(uint256 _investedPOLY) public nonReentrant{
835         require(!paused);
836         require(fundraiseType == FundraiseType.POLY, "POLY should be the mode of investment");
837         require(verifyInvestment(msg.sender, _investedPOLY), "Not valid Investment");
838         _processTx(msg.sender, _investedPOLY);
839         _forwardPoly(msg.sender, wallet, _investedPOLY);
840         _postValidatePurchase(msg.sender, _investedPOLY);
841     }
842 
843     /**
844     * @notice Checks whether the cap has been reached.
845     * @return bool Whether the cap was reached
846     */
847     function capReached() public view returns (bool) {
848         return tokensSold >= cap;
849     }
850 
851     /**
852      * @notice Return ETH raised by the STO
853      */
854     function getRaisedEther() public view returns (uint256) {
855         if (fundraiseType == FundraiseType.ETH)
856             return fundsRaised;
857         else
858             return 0;
859     }
860 
861     /**
862      * @notice Return POLY raised by the STO
863      */
864     function getRaisedPOLY() public view returns (uint256) {
865         if (fundraiseType == FundraiseType.POLY)
866             return fundsRaised;
867         else
868             return 0;
869     }
870 
871     /**
872      * @notice Return the total no. of investors
873      */
874     function getNumberInvestors() public view returns (uint256) {
875         return investorCount;
876     }
877 
878     /**
879      * @notice Return the permissions flag that are associated with STO
880      */
881     function getPermissions() public view returns(bytes32[]) {
882         bytes32[] memory allPermissions = new bytes32[](0);
883         return allPermissions;
884     }
885 
886     /**
887      * @notice Return the STO details
888      */
889     function getSTODetails() public view returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, bool) {
890         return (
891             startTime,
892             endTime,
893             cap,
894             rate,
895             fundsRaised,
896             investorCount,
897             tokensSold,
898             (fundraiseType == FundraiseType.POLY)
899         );
900     }
901 
902     // -----------------------------------------
903     // Internal interface (extensible)
904     // -----------------------------------------
905     /**
906       * Processing the purchase as well as verify the required validations
907       * @param _beneficiary Address performing the token purchase
908       * @param _investedAmount Value in wei involved in the purchase
909     */
910     function _processTx(address _beneficiary, uint256 _investedAmount) internal {
911 
912         _preValidatePurchase(_beneficiary, _investedAmount);
913         // calculate token amount to be created
914         uint256 tokens = _getTokenAmount(_investedAmount);
915 
916         // update state
917         fundsRaised = fundsRaised.add(_investedAmount);
918         tokensSold = tokensSold.add(tokens);
919 
920         _processPurchase(_beneficiary, tokens);
921         emit TokenPurchase(msg.sender, _beneficiary, _investedAmount, tokens);
922 
923         _updatePurchasingState(_beneficiary, _investedAmount);
924     }
925 
926     /**
927     * @notice Validation of an incoming purchase.
928       Use require statements to revert state when conditions are not met. Use super to concatenate validations.
929     * @param _beneficiary Address performing the token purchase
930     * @param _investedAmount Value in wei involved in the purchase
931     */
932     function _preValidatePurchase(address _beneficiary, uint256 _investedAmount) internal view {
933         require(_beneficiary != address(0), "Beneficiary address should not be 0x");
934         require(_investedAmount != 0, "Amount invested should not be equal to 0");
935         require(tokensSold.add(_getTokenAmount(_investedAmount)) <= cap, "Investment more than cap is not allowed");
936         require(now >= startTime && now <= endTime, "Offering is closed/Not yet started");
937     }
938 
939     /**
940     * @notice Validation of an executed purchase.
941       Observe state and use revert statements to undo rollback when valid conditions are not met.
942     */
943     function _postValidatePurchase(address /*_beneficiary*/, uint256 /*_investedAmount*/) internal pure {
944       // optional override
945     }
946 
947     /**
948     * @notice Source of tokens.
949       Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
950     * @param _beneficiary Address performing the token purchase
951     * @param _tokenAmount Number of tokens to be emitted
952     */
953     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
954         require(IST20(securityToken).mint(_beneficiary, _tokenAmount), "Error in minting the tokens");
955     }
956 
957     /**
958     * @notice Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
959     * @param _beneficiary Address receiving the tokens
960     * @param _tokenAmount Number of tokens to be purchased
961     */
962     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
963         if (investors[_beneficiary] == 0) {
964             investorCount = investorCount + 1;
965         }
966         investors[_beneficiary] = investors[_beneficiary].add(_tokenAmount);
967 
968         _deliverTokens(_beneficiary, _tokenAmount);
969     }
970 
971     /**
972     * @notice Override for extensions that require an internal state to check for validity
973       (current user contributions, etc.)
974     */
975     function _updatePurchasingState(address /*_beneficiary*/, uint256 /*_investedAmount*/) internal pure {
976       // optional override
977     }
978 
979     /**
980     * @notice Override to extend the way in which ether is converted to tokens.
981     * @param _investedAmount Value in wei to be converted into tokens
982     * @return Number of tokens that can be purchased with the specified _investedAmount
983     */
984     function _getTokenAmount(uint256 _investedAmount) internal view returns (uint256) {
985         return _investedAmount.mul(rate);
986     }
987 
988     /**
989     * @notice Determines how ETH is stored/forwarded on purchases.
990     */
991     function _forwardFunds() internal {
992         wallet.transfer(msg.value);
993     }
994 
995     /**
996      * @notice Internal function used to check the type of fund raise currency
997      * @param _fundraiseType Type of currency used to collect the funds
998      */
999     function _check(uint8 _fundraiseType) internal {
1000         require(_fundraiseType == 0 || _fundraiseType == 1, "Not a valid fundraise type");
1001         if (_fundraiseType == 0) {
1002             fundraiseType = FundraiseType.ETH;
1003         }
1004         if (_fundraiseType == 1) {
1005             require(address(polyToken) != address(0), "Address of the polyToken should not be 0x");
1006             fundraiseType = FundraiseType.POLY;
1007         }
1008     }
1009 
1010     /**
1011      * @notice Internal function used to forward the POLY raised to beneficiary address
1012      * @param _beneficiary Address of the funds reciever
1013      * @param _to Address who wants to ST-20 tokens
1014      * @param _fundsAmount Amount invested by _to
1015      */
1016     function _forwardPoly(address _beneficiary, address _to, uint256 _fundsAmount) internal {
1017         polyToken.transferFrom(_beneficiary, _to, _fundsAmount);
1018     }
1019 
1020 }
1021 
1022 /**
1023  * @title Factory for deploying CappedSTO module
1024  */
1025 contract CappedSTOFactory is IModuleFactory {
1026 
1027     /**
1028      * @notice Constructor
1029      * @param _polyAddress Address of the polytoken
1030      */
1031     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
1032       IModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
1033     {
1034 
1035     }
1036 
1037      /**
1038      * @notice used to launch the Module with the help of factory
1039      * @return address Contract address of the Module
1040      */
1041     function deploy(bytes _data) external returns(address) {
1042         if(setupCost > 0)
1043             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
1044         //Check valid bytes - can only call module init function
1045         CappedSTO cappedSTO = new CappedSTO(msg.sender, address(polyToken));
1046         //Checks that _data is valid (not calling anything it shouldn't)
1047         require(getSig(_data) == cappedSTO.getInitFunction(), "Provided data is not valid");
1048         require(address(cappedSTO).call(_data), "Un-successfull call");
1049         emit LogGenerateModuleFromFactory(address(cappedSTO), getName(), address(this), msg.sender, now);
1050         return address(cappedSTO);
1051     }
1052 
1053     /**
1054      * @notice Type of the Module factory
1055      */
1056     function getType() public view returns(uint8) {
1057         return 3;
1058     }
1059 
1060     /**
1061      * @notice Get the name of the Module
1062      */
1063     function getName() public view returns(bytes32) {
1064         return "CappedSTO";
1065     }
1066 
1067     /**
1068      * @notice Get the description of the Module
1069      */
1070     function getDescription() public view returns(string) {
1071         return "Capped STO";
1072     }
1073 
1074     /**
1075      * @notice Get the title of the Module
1076      */
1077     function getTitle() public view returns(string) {
1078         return "Capped STO";
1079     }
1080 
1081     /**
1082      * @notice Get the Instructions that helped to used the module
1083      */
1084     function getInstructions() public view returns(string) {
1085         return "Initialises a capped STO. Init parameters are _startTime (time STO starts), _endTime (time STO ends), _cap (cap in tokens for STO), _rate (POLY/ETH to token rate), _fundRaiseType (whether you are raising in POLY or ETH), _polyToken (address of POLY token), _fundsReceiver (address which will receive funds)";
1086     }
1087 
1088     /**
1089      * @notice Get the tags related to the module factory
1090      */
1091     function getTags() public view returns(bytes32[]) {
1092         bytes32[] memory availableTags = new bytes32[](4);
1093         availableTags[0] = "Capped";
1094         availableTags[1] = "Non-refundable";
1095         availableTags[2] = "POLY";
1096         availableTags[3] = "ETH";
1097         return availableTags;
1098     }
1099 
1100 }