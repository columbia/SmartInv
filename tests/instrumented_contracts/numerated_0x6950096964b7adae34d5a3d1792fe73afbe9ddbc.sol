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
585  * @title Interface to be implemented by all checkpoint modules
586  */
587 contract ICheckpoint is IModule {
588 
589 }
590 
591 /**
592  * @title Math
593  * @dev Assorted math operations
594  */
595 library Math {
596   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
597     return a >= b ? a : b;
598   }
599 
600   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
601     return a < b ? a : b;
602   }
603 
604   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
605     return a >= b ? a : b;
606   }
607 
608   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
609     return a < b ? a : b;
610   }
611 }
612 
613 /////////////////////
614 // Module permissions
615 /////////////////////
616 //                                        Owner       DISTRIBUTE
617 // pushDividendPaymentToAddresses           X               X
618 // pushDividendPayment                      X               X
619 // createDividend                           X
620 // createDividendWithCheckpoint             X
621 // reclaimDividend                          X
622 
623 /**
624  * @title Checkpoint module for issuing ERC20 dividends
625  */
626 contract ERC20DividendCheckpoint is ICheckpoint {
627     using SafeMath for uint256;
628 
629     bytes32 public constant DISTRIBUTE = "DISTRIBUTE";
630 
631     struct Dividend {
632       uint256 checkpointId;
633       uint256 created; // Time at which the dividend was created
634       uint256 maturity; // Time after which dividend can be claimed - set to 0 to bypass
635       uint256 expiry;  // Time until which dividend can be claimed - after this time any remaining amount can be withdrawn by issuer - set to very high value to bypass
636       address token; // Address of ERC20 token that dividend is denominated in
637       uint256 amount; // Dividend amount in base token amounts
638       uint256 claimedAmount; // Amount of dividend claimed so far
639       uint256 totalSupply; // Total supply at the associated checkpoint (avoids recalculating this)
640       bool reclaimed;
641       mapping (address => bool) claimed; // List of addresses which have claimed dividend
642     }
643 
644     // List of all dividends
645     Dividend[] public dividends;
646 
647     event ERC20DividendDeposited(address indexed _depositor, uint256 _checkpointId, uint256 _created, uint256 _maturity, uint256 _expiry, address _token, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
648     event ERC20DividendClaimed(address indexed _payee, uint256 _dividendIndex, address _token, uint256 _amount);
649     event ERC20DividendReclaimed(address indexed _claimer, uint256 _dividendIndex, address _token, uint256 _claimedAmount);
650 
651     modifier validDividendIndex(uint256 _dividendIndex) {
652         require(_dividendIndex < dividends.length, "Incorrect dividend index");
653         require(now >= dividends[_dividendIndex].maturity, "Dividend maturity is in the future");
654         require(now < dividends[_dividendIndex].expiry, "Dividend expiry is in the past");
655         require(!dividends[_dividendIndex].reclaimed, "Dividend has been reclaimed by issuer");
656         _;
657     }
658 
659     /**
660      * @notice Constructor
661      * @param _securityToken Address of the security token
662      * @param _polyAddress Address of the polytoken
663      */
664     constructor (address _securityToken, address _polyAddress) public
665     IModule(_securityToken, _polyAddress)
666     {
667     }
668 
669     /**
670     * @notice Init function i.e generalise function to maintain the structure of the module contract
671     * @return bytes4
672     */
673     function getInitFunction() public pure returns (bytes4) {
674         return bytes4(0);
675     }
676 
677     /**
678      * @notice Creates a dividend and checkpoint for the dividend
679      * @param _maturity Time from which dividend can be paid
680      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
681      * @param _token Address of ERC20 token in which dividend is to be denominated
682      * @param _amount Amount of specified token for dividend
683      */
684     function createDividend(uint256 _maturity, uint256 _expiry, address _token, uint256 _amount) public onlyOwner {
685         require(_expiry > _maturity);
686         require(_expiry > now);
687         require(_token != address(0));
688         require(_amount > 0);
689         require(ERC20(_token).transferFrom(msg.sender, address(this), _amount), "Unable to transfer tokens for dividend");
690         uint256 dividendIndex = dividends.length;
691         uint256 checkpointId = ISecurityToken(securityToken).createCheckpoint();
692         uint256 currentSupply = ISecurityToken(securityToken).totalSupply();
693         dividends.push(
694           Dividend(
695             checkpointId,
696             now,
697             _maturity,
698             _expiry,
699             _token,
700             _amount,
701             0,
702             currentSupply,
703             false
704           )
705         );
706         emit ERC20DividendDeposited(msg.sender, checkpointId, now, _maturity, _expiry, _token, _amount, currentSupply, dividendIndex);
707     }
708 
709     /**
710      * @notice Creates a dividend with a provided checkpoint
711      * @param _maturity Time from which dividend can be paid
712      * @param _expiry Time until dividend can no longer be paid, and can be reclaimed by issuer
713      * @param _token Address of ERC20 token in which dividend is to be denominated
714      * @param _amount Amount of specified token for dividend
715      * @param _checkpointId Checkpoint id from which to create dividends
716      */
717     function createDividendWithCheckpoint(uint256 _maturity, uint256 _expiry, address _token, uint256 _amount, uint256 _checkpointId) payable public onlyOwner {
718         require(_expiry > _maturity);
719         require(_expiry > now);
720         require(_checkpointId <= ISecurityToken(securityToken).currentCheckpointId());
721         uint256 dividendIndex = dividends.length;
722         uint256 currentSupply = ISecurityToken(securityToken).totalSupplyAt(_checkpointId);
723         require(ERC20(_token).transferFrom(msg.sender, address(this), _amount), "Unable to transfer tokens for dividend");
724         dividends.push(
725           Dividend(
726             _checkpointId,
727             now,
728             _maturity,
729             _expiry,
730             _token,
731             _amount,
732             0,
733             currentSupply,
734             false
735           )
736         );
737         emit ERC20DividendDeposited(msg.sender, _checkpointId, now, _maturity, _expiry, _token, _amount, currentSupply, dividendIndex);
738     }
739 
740     /**
741      * @notice Issuer can push dividends to provided addresses
742      * @param _dividendIndex Dividend to push
743      * @param _payees Addresses to which to push the dividend
744      */
745     function pushDividendPaymentToAddresses(uint256 _dividendIndex, address[] _payees) public withPerm(DISTRIBUTE) validDividendIndex(_dividendIndex) {
746         Dividend storage dividend = dividends[_dividendIndex];
747         for (uint256 i = 0; i < _payees.length; i++) {
748             if (!dividend.claimed[_payees[i]]) {
749                 _payDividend(_payees[i], dividend, _dividendIndex);
750             }
751         }
752     }
753 
754     /**
755      * @notice Issuer can push dividends using the investor list from the security token
756      * @param _dividendIndex Dividend to push
757      * @param _start Index in investor list at which to start pushing dividends
758      * @param _iterations Number of addresses to push dividends for
759      */
760     function pushDividendPayment(uint256 _dividendIndex, uint256 _start, uint256 _iterations) public withPerm(DISTRIBUTE) validDividendIndex(_dividendIndex) {
761         Dividend storage dividend = dividends[_dividendIndex];
762         uint256 numberInvestors = ISecurityToken(securityToken).getInvestorsLength();
763         for (uint256 i = _start; i < Math.min256(numberInvestors, _start.add(_iterations)); i++) {
764             address payee = ISecurityToken(securityToken).investors(i);
765             if (!dividend.claimed[payee]) {
766                 _payDividend(payee, dividend, _dividendIndex);
767             }
768         }
769     }
770 
771     /**
772      * @notice Investors can pull their own dividends
773      * @param _dividendIndex Dividend to pull
774      */
775     function pullDividendPayment(uint256 _dividendIndex) public validDividendIndex(_dividendIndex)
776     {
777         Dividend storage dividend = dividends[_dividendIndex];
778         require(!dividend.claimed[msg.sender], "Dividend already reclaimed");
779         _payDividend(msg.sender, dividend, _dividendIndex);
780     }
781 
782     /**
783      * @notice Internal function for paying dividends
784      * @param _payee address of investor
785      * @param _dividend storage with previously issued dividends
786      * @param _dividendIndex Dividend to pay
787      */
788     function _payDividend(address _payee, Dividend storage _dividend, uint256 _dividendIndex) internal {
789         uint256 claim = calculateDividend(_dividendIndex, _payee);
790         _dividend.claimed[_payee] = true;
791         _dividend.claimedAmount = claim.add(_dividend.claimedAmount);
792         if (claim > 0) {
793             require(ERC20(_dividend.token).transfer(_payee, claim), "Unable to transfer tokens");
794             emit ERC20DividendClaimed(_payee, _dividendIndex, _dividend.token, claim);
795         }
796     }
797 
798     /**
799      * @notice Issuer can reclaim remaining unclaimed dividend amounts, for expired dividends
800      * @param _dividendIndex Dividend to reclaim
801      */
802     function reclaimDividend(uint256 _dividendIndex) public onlyOwner {
803         require(_dividendIndex < dividends.length, "Incorrect dividend index");
804         require(now >= dividends[_dividendIndex].expiry, "Dividend expiry is in the future");
805         require(!dividends[_dividendIndex].reclaimed, "Dividend already claimed");
806         dividends[_dividendIndex].reclaimed = true;
807         Dividend storage dividend = dividends[_dividendIndex];
808         uint256 remainingAmount = dividend.amount.sub(dividend.claimedAmount);
809         require(ERC20(dividend.token).transfer(msg.sender, remainingAmount), "Unable to transfer tokens");
810         emit ERC20DividendReclaimed(msg.sender, _dividendIndex, dividend.token, remainingAmount);
811     }
812 
813     /**
814      * @notice Calculate amount of dividends claimable
815      * @param _dividendIndex Dividend to calculate
816      * @param _payee Affected investor address
817      * @return unit256
818      */
819     function calculateDividend(uint256 _dividendIndex, address _payee) public view returns(uint256) {
820         Dividend storage dividend = dividends[_dividendIndex];
821         if (dividend.claimed[_payee]) {
822             return 0;
823         }
824         uint256 balance = ISecurityToken(securityToken).balanceOfAt(_payee, dividends[_dividendIndex].checkpointId);
825         return balance.mul(dividends[_dividendIndex].amount).div(dividends[_dividendIndex].totalSupply);
826     }
827 
828     /**
829      * @notice Get the index according to the checkpoint id
830      * @param _checkpointId Checkpoint id to query
831      * @return uint256
832      */
833     function getDividendIndex(uint256 _checkpointId) public view returns(uint256[]) {
834         uint256 counter = 0;
835         for(uint256 i = 0; i < dividends.length; i++) {
836             if (dividends[i].checkpointId == _checkpointId) {
837                 counter++;
838             }
839         }
840 
841        uint256[] memory index = new uint256[](counter);
842        counter = 0;
843        for(uint256 j = 0; j < dividends.length; j++) {
844            if (dividends[j].checkpointId == _checkpointId) {
845                index[counter] = j;
846                counter++;
847            }
848        }
849        return index;
850     }
851 
852     /**
853      * @notice Return the permissions flag that are associated with STO
854      * @return bytes32 array
855      */
856     function getPermissions() public view returns(bytes32[]) {
857         bytes32[] memory allPermissions = new bytes32[](1);
858         allPermissions[0] = DISTRIBUTE;
859         return allPermissions;
860     }
861 
862 }
863 
864 /**
865  * @title Factory for deploying ERC20DividendCheckpoint module
866  */
867 contract ERC20DividendCheckpointFactory is IModuleFactory {
868 
869     /**
870      * @notice Constructor
871      * @param _polyAddress Address of the polytoken
872      * @param _setupCost Setup cost of the module
873      * @param _usageCost Usage cost of the module
874      * @param _subscriptionCost Subscription cost of the module
875      */
876     constructor (address _polyAddress, uint256 _setupCost, uint256 _usageCost, uint256 _subscriptionCost) public
877     IModuleFactory(_polyAddress, _setupCost, _usageCost, _subscriptionCost)
878     {
879 
880     }
881 
882     /**
883      * @notice used to launch the Module with the help of factory
884      * @return address Contract address of the Module
885      */
886     function deploy(bytes /* _data */) external returns(address) {
887         if (setupCost > 0)
888             require(polyToken.transferFrom(msg.sender, owner, setupCost), "Failed transferFrom because of sufficent Allowance is not provided");
889         return address(new ERC20DividendCheckpoint(msg.sender, address(polyToken)));
890     }
891 
892     /**
893      * @notice Type of the Module factory
894      */
895     function getType() public view returns(uint8) {
896         return 4;
897     }
898 
899     /**
900      * @notice Get the name of the Module
901      */
902     function getName() public view returns(bytes32) {
903         return "ERC20DividendCheckpoint";
904     }
905 
906     /**
907      * @notice Get the description of the Module
908      */
909     function getDescription() public view returns(string) {
910         return "Create ERC20 dividends for token holders at a specific checkpoint";
911     }
912 
913     /**
914      * @notice Get the title of the Module
915      */
916     function getTitle() public  view returns(string) {
917         return "ERC20 Dividend Checkpoint";
918     }
919 
920     /**
921      * @notice Get the Instructions that helped to used the module
922      */
923     function getInstructions() public view returns(string) {
924         return "Create a ERC20 dividend which will be paid out to token holders proportional to their balances at the point the dividend is created";
925     }
926 
927     /**
928      * @notice Get the tags related to the module factory
929      */
930     function getTags() public view returns(bytes32[]) {
931         bytes32[] memory availableTags = new bytes32[](3);
932         availableTags[0] = "ERC20";
933         availableTags[1] = "Dividend";
934         availableTags[2] = "Checkpoint";
935         return availableTags;
936     }
937 }