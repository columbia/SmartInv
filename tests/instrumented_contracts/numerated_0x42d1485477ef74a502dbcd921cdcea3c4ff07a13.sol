1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 contract ComponentContainerInterface {
66     mapping (bytes32 => address) components;
67 
68     event ComponentUpdated (bytes32 _name, address _componentAddress);
69 
70     function setComponent(bytes32 _name, address _providerAddress) internal returns (bool success);
71     function setComponents(bytes32[] _names, address[] _providerAddresses) internal returns (bool success);
72     function getComponentByName(bytes32 name) public view returns (address);
73     function getComponents(bytes32[] _names) internal view returns (address[]);
74 
75 }
76 
77 contract DerivativeInterface is  Ownable, ComponentContainerInterface {
78 
79     enum DerivativeStatus { New, Active, Paused, Closed }
80     enum DerivativeType { Index, Fund, Future }
81 
82     string public description;
83     bytes32 public category;
84     
85     bytes32 public version;
86     DerivativeType public fundType;
87     DerivativeStatus public status;
88 
89 
90     function _initialize (address _componentList) internal;
91     function updateComponent(bytes32 _name) public returns (address);
92     function approveComponent(bytes32 _name) internal;
93 
94 
95 }
96 
97 contract ComponentContainer is ComponentContainerInterface {
98 
99     function setComponent(bytes32 _name, address _componentAddress) internal returns (bool success) {
100         require(_componentAddress != address(0));
101         components[_name] = _componentAddress;
102         return true;
103     }
104 
105     function getComponentByName(bytes32 _name) public view returns (address) {
106         return components[_name];
107     }
108 
109     function getComponents(bytes32[] _names) internal view returns (address[]) {
110         address[] memory addresses = new address[](_names.length);
111         for (uint i = 0; i < _names.length; i++) {
112             addresses[i] = getComponentByName(_names[i]);
113         }
114 
115         return addresses;
116     }
117 
118     function setComponents(bytes32[] _names, address[] _providerAddresses) internal returns (bool success) {
119         require(_names.length == _providerAddresses.length);
120         require(_names.length > 0);
121 
122         for (uint i = 0; i < _names.length; i++ ) {
123             setComponent(_names[i], _providerAddresses[i]);
124         }
125 
126         return true;
127     }
128 }
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * See https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   function totalSupply() public view returns (uint256);
137   function balanceOf(address _who) public view returns (uint256);
138   function transfer(address _to, uint256 _value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 /**
143  * @title SafeMath
144  * @dev Math operations with safety checks that throw on error
145  */
146 library SafeMath {
147 
148   /**
149   * @dev Multiplies two numbers, throws on overflow.
150   */
151   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
152     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
153     // benefit is lost if 'b' is also tested.
154     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
155     if (_a == 0) {
156       return 0;
157     }
158 
159     c = _a * _b;
160     assert(c / _a == _b);
161     return c;
162   }
163 
164   /**
165   * @dev Integer division of two numbers, truncating the quotient.
166   */
167   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
168     // assert(_b > 0); // Solidity automatically throws when dividing by 0
169     // uint256 c = _a / _b;
170     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
171     return _a / _b;
172   }
173 
174   /**
175   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
176   */
177   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
178     assert(_b <= _a);
179     return _a - _b;
180   }
181 
182   /**
183   * @dev Adds two numbers, throws on overflow.
184   */
185   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
186     c = _a + _b;
187     assert(c >= _a);
188     return c;
189   }
190 }
191 
192 /**
193  * @title Basic token
194  * @dev Basic version of StandardToken, with no allowances.
195  */
196 contract BasicToken is ERC20Basic {
197   using SafeMath for uint256;
198 
199   mapping(address => uint256) internal balances;
200 
201   uint256 internal totalSupply_;
202 
203   /**
204   * @dev Total number of tokens in existence
205   */
206   function totalSupply() public view returns (uint256) {
207     return totalSupply_;
208   }
209 
210   /**
211   * @dev Transfer token for a specified address
212   * @param _to The address to transfer to.
213   * @param _value The amount to be transferred.
214   */
215   function transfer(address _to, uint256 _value) public returns (bool) {
216     require(_value <= balances[msg.sender]);
217     require(_to != address(0));
218 
219     balances[msg.sender] = balances[msg.sender].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     emit Transfer(msg.sender, _to, _value);
222     return true;
223   }
224 
225   /**
226   * @dev Gets the balance of the specified address.
227   * @param _owner The address to query the the balance of.
228   * @return An uint256 representing the amount owned by the passed address.
229   */
230   function balanceOf(address _owner) public view returns (uint256) {
231     return balances[_owner];
232   }
233 
234 }
235 
236 /**
237  * @title ERC20 interface
238  * @dev see https://github.com/ethereum/EIPs/issues/20
239  */
240 contract ERC20 is ERC20Basic {
241   function allowance(address _owner, address _spender)
242     public view returns (uint256);
243 
244   function transferFrom(address _from, address _to, uint256 _value)
245     public returns (bool);
246 
247   function approve(address _spender, uint256 _value) public returns (bool);
248   event Approval(
249     address indexed owner,
250     address indexed spender,
251     uint256 value
252   );
253 }
254 
255 /**
256  * @title Standard ERC20 token
257  *
258  * @dev Implementation of the basic standard token.
259  * https://github.com/ethereum/EIPs/issues/20
260  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
261  */
262 contract StandardToken is ERC20, BasicToken {
263 
264   mapping (address => mapping (address => uint256)) internal allowed;
265 
266 
267   /**
268    * @dev Transfer tokens from one address to another
269    * @param _from address The address which you want to send tokens from
270    * @param _to address The address which you want to transfer to
271    * @param _value uint256 the amount of tokens to be transferred
272    */
273   function transferFrom(
274     address _from,
275     address _to,
276     uint256 _value
277   )
278     public
279     returns (bool)
280   {
281     require(_value <= balances[_from]);
282     require(_value <= allowed[_from][msg.sender]);
283     require(_to != address(0));
284 
285     balances[_from] = balances[_from].sub(_value);
286     balances[_to] = balances[_to].add(_value);
287     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
288     emit Transfer(_from, _to, _value);
289     return true;
290   }
291 
292   /**
293    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
294    * Beware that changing an allowance with this method brings the risk that someone may use both the old
295    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
296    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
297    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
298    * @param _spender The address which will spend the funds.
299    * @param _value The amount of tokens to be spent.
300    */
301   function approve(address _spender, uint256 _value) public returns (bool) {
302     allowed[msg.sender][_spender] = _value;
303     emit Approval(msg.sender, _spender, _value);
304     return true;
305   }
306 
307   /**
308    * @dev Function to check the amount of tokens that an owner allowed to a spender.
309    * @param _owner address The address which owns the funds.
310    * @param _spender address The address which will spend the funds.
311    * @return A uint256 specifying the amount of tokens still available for the spender.
312    */
313   function allowance(
314     address _owner,
315     address _spender
316    )
317     public
318     view
319     returns (uint256)
320   {
321     return allowed[_owner][_spender];
322   }
323 
324   /**
325    * @dev Increase the amount of tokens that an owner allowed to a spender.
326    * approve should be called when allowed[_spender] == 0. To increment
327    * allowed value is better to use this function to avoid 2 calls (and wait until
328    * the first transaction is mined)
329    * From MonolithDAO Token.sol
330    * @param _spender The address which will spend the funds.
331    * @param _addedValue The amount of tokens to increase the allowance by.
332    */
333   function increaseApproval(
334     address _spender,
335     uint256 _addedValue
336   )
337     public
338     returns (bool)
339   {
340     allowed[msg.sender][_spender] = (
341       allowed[msg.sender][_spender].add(_addedValue));
342     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343     return true;
344   }
345 
346   /**
347    * @dev Decrease the amount of tokens that an owner allowed to a spender.
348    * approve should be called when allowed[_spender] == 0. To decrement
349    * allowed value is better to use this function to avoid 2 calls (and wait until
350    * the first transaction is mined)
351    * From MonolithDAO Token.sol
352    * @param _spender The address which will spend the funds.
353    * @param _subtractedValue The amount of tokens to decrease the allowance by.
354    */
355   function decreaseApproval(
356     address _spender,
357     uint256 _subtractedValue
358   )
359     public
360     returns (bool)
361   {
362     uint256 oldValue = allowed[msg.sender][_spender];
363     if (_subtractedValue >= oldValue) {
364       allowed[msg.sender][_spender] = 0;
365     } else {
366       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
367     }
368     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
369     return true;
370   }
371 
372 }
373 
374 /**
375  * @title Pausable
376  * @dev Base contract which allows children to implement an emergency stop mechanism.
377  */
378 contract Pausable is Ownable {
379   event Pause();
380   event Unpause();
381 
382   bool public paused = false;
383 
384 
385   /**
386    * @dev Modifier to make a function callable only when the contract is not paused.
387    */
388   modifier whenNotPaused() {
389     require(!paused);
390     _;
391   }
392 
393   /**
394    * @dev Modifier to make a function callable only when the contract is paused.
395    */
396   modifier whenPaused() {
397     require(paused);
398     _;
399   }
400 
401   /**
402    * @dev called by the owner to pause, triggers stopped state
403    */
404   function pause() public onlyOwner whenNotPaused {
405     paused = true;
406     emit Pause();
407   }
408 
409   /**
410    * @dev called by the owner to unpause, returns to normal state
411    */
412   function unpause() public onlyOwner whenPaused {
413     paused = false;
414     emit Unpause();
415   }
416 }
417 
418 /**
419  * @title Pausable token
420  * @dev StandardToken modified with pausable transfers.
421  **/
422 contract PausableToken is StandardToken, Pausable {
423 
424   function transfer(
425     address _to,
426     uint256 _value
427   )
428     public
429     whenNotPaused
430     returns (bool)
431   {
432     return super.transfer(_to, _value);
433   }
434 
435   function transferFrom(
436     address _from,
437     address _to,
438     uint256 _value
439   )
440     public
441     whenNotPaused
442     returns (bool)
443   {
444     return super.transferFrom(_from, _to, _value);
445   }
446 
447   function approve(
448     address _spender,
449     uint256 _value
450   )
451     public
452     whenNotPaused
453     returns (bool)
454   {
455     return super.approve(_spender, _value);
456   }
457 
458   function increaseApproval(
459     address _spender,
460     uint _addedValue
461   )
462     public
463     whenNotPaused
464     returns (bool success)
465   {
466     return super.increaseApproval(_spender, _addedValue);
467   }
468 
469   function decreaseApproval(
470     address _spender,
471     uint _subtractedValue
472   )
473     public
474     whenNotPaused
475     returns (bool success)
476   {
477     return super.decreaseApproval(_spender, _subtractedValue);
478   }
479 }
480 
481 contract ERC20Extended is ERC20 {
482     uint256 public decimals;
483     string public name;
484     string public symbol;
485 
486 }
487 
488 contract ComponentListInterface {
489     event ComponentUpdated (bytes32 _name, string _version, address _componentAddress);
490     function setComponent(bytes32 _name, address _componentAddress) public returns (bool);
491     function getComponent(bytes32 _name, string _version) public view returns (address);
492     function getLatestComponent(bytes32 _name) public view returns(address);
493     function getLatestComponents(bytes32[] _names) public view returns(address[]);
494 }
495 
496 contract ERC20NoReturn {
497     uint256 public decimals;
498     string public name;
499     string public symbol;
500     function totalSupply() public view returns (uint);
501     function balanceOf(address tokenOwner) public view returns (uint balance);
502     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
503     function transfer(address to, uint tokens) public;
504     function approve(address spender, uint tokens) public;
505     function transferFrom(address from, address to, uint tokens) public;
506 
507     event Transfer(address indexed from, address indexed to, uint tokens);
508     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
509 }
510 
511 contract FeeChargerInterface {
512     // TODO: change this to mainnet MOT address before deployment.
513     // solhint-disable-next-line
514     ERC20Extended public MOT = ERC20Extended(0x263c618480DBe35C300D8d5EcDA19bbB986AcaeD);
515     // kovan MOT: 0x41Dee9F481a1d2AA74a3f1d0958C1dB6107c686A
516     function setMotAddress(address _motAddress) external returns (bool success);
517 }
518 
519 contract ComponentInterface {
520     string public name;
521     string public description;
522     string public category;
523     string public version;
524 }
525 
526 contract WhitelistInterface is ComponentInterface {
527 
528     // sender -> category -> user -> allowed
529     mapping (address => mapping(uint => mapping(address => bool))) public whitelist;
530     // sender -> category -> enabled
531     mapping (address => mapping(uint => bool)) public enabled;
532 
533     function setStatus(uint _key, bool enable) external;
534     function isAllowed(uint _key, address _account) external view returns(bool);
535     function setAllowed(address[] accounts, uint _key, bool allowed) external returns(bool);
536 }
537 
538 contract RiskControlInterface is ComponentInterface {
539     function hasRisk(address _sender, address _receiver, address _tokenAddress, uint _amount, uint _rate)
540         external returns(bool isRisky);
541 }
542 
543 contract LockerInterface {
544     // Inside a require shall be performed
545     function checkLockByBlockNumber(bytes32 _lockerName) external;
546 
547     function setBlockInterval(bytes32 _lockerName, uint _blocks) external;
548     function setMultipleBlockIntervals(bytes32[] _lockerNames, uint[] _blocks) external;
549 
550     // Inside a require shall be performed
551     function checkLockerByTime(bytes32 _timerName) external;
552 
553     function setTimeInterval(bytes32 _timerName, uint _seconds) external;
554     function setMultipleTimeIntervals(bytes32[] _timerNames, uint[] _hours) external;
555 
556 }
557 
558 interface StepInterface {
559     // Get number of max calls
560     function getMaxCalls(bytes32 _category) external view returns(uint _maxCall);
561     // Set the number of calls that one category can perform in a single transaction
562     function setMaxCalls(bytes32 _category, uint _maxCallsList) external;
563     // Set several max calls in a single transaction, saving trasnaction cost gas
564     function setMultipleMaxCalls(bytes32[] _categories, uint[] _maxCalls) external;
565     // This function initializes the piecemeal function. If it is already initialized, it will continue and return the currentFunctionStep of the status.
566     function initializeOrContinue(bytes32 _category) external returns (uint _currentFunctionStep);
567     // Return the current status of the piecemeal function. This status can be used to decide what can be done
568     function getStatus(bytes32 _category) external view returns (uint _status);
569     // Update the status to the following phase
570     function updateStatus(bytes32 _category) external returns (uint _newStatus);
571     // This function should always be called for each operation which is deemed to cost the gas.
572     function goNextStep(bytes32 _category) external returns (bool _shouldCallAgain);
573     // This function should always be called at the end of the function, when everything is done. This resets the variables to default state.
574     function finalize(bytes32 _category) external returns (bool _success);
575 }
576 
577 // Abstract class that implements the common functions to all our derivatives
578 contract Derivative is DerivativeInterface, ERC20Extended, ComponentContainer, PausableToken {
579 
580     ERC20Extended internal constant ETH = ERC20Extended(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
581     ComponentListInterface public componentList;
582     bytes32 public constant MARKET = "MarketProvider";
583     bytes32 public constant PRICE = "PriceProvider";
584     bytes32 public constant EXCHANGE = "ExchangeProvider";
585     bytes32 public constant WITHDRAW = "WithdrawProvider";
586     bytes32 public constant RISK = "RiskProvider";
587     bytes32 public constant WHITELIST = "WhitelistProvider";
588     bytes32 public constant FEE = "FeeProvider";
589     bytes32 public constant REIMBURSABLE = "Reimbursable";
590     bytes32 public constant REBALANCE = "RebalanceProvider";
591     bytes32 public constant STEP = "StepProvider";
592     bytes32 public constant LOCKER = "LockerProvider";
593 
594     bytes32 public constant GETETH = "GetEth";
595 
596     uint public pausedTime;
597     uint public pausedCycle;
598 
599     function pause() onlyOwner whenNotPaused public {
600         paused = true;
601         pausedTime = now;
602     }
603 
604     enum WhitelistKeys { Investment, Maintenance, Admin }
605 
606     mapping(bytes32 => bool) internal excludedComponents;
607 
608     modifier OnlyOwnerOrPausedTimeout() {
609         require( (msg.sender == owner) || ( paused == true && (pausedTime+pausedCycle) <= now ) );
610         _;
611     }
612 
613     // If whitelist is disabled, that will become onlyOwner
614     modifier onlyOwnerOrWhitelisted(WhitelistKeys _key) {
615         WhitelistInterface whitelist = WhitelistInterface(getComponentByName(WHITELIST));
616         require(
617             msg.sender == owner ||
618             (whitelist.enabled(address(this), uint(_key)) && whitelist.isAllowed(uint(_key), msg.sender) )
619         );
620         _;
621     }
622 
623     // If whitelist is disabled, anyone can do this
624     modifier whitelisted(WhitelistKeys _key) {
625         require(WhitelistInterface(getComponentByName(WHITELIST)).isAllowed(uint(_key), msg.sender));
626         _;
627     }
628 
629     modifier withoutRisk(address _sender, address _receiver, address _tokenAddress, uint _amount, uint _rate) {
630         require(!hasRisk(_sender, _receiver, _tokenAddress, _amount, _rate));
631         _;
632     }
633 
634     function _initialize (address _componentList) internal {
635         require(_componentList != 0x0);
636         componentList = ComponentListInterface(_componentList);
637         excludedComponents[MARKET] = true;
638         excludedComponents[STEP] = true;
639         excludedComponents[LOCKER] = true;
640     }
641 
642     function updateComponent(bytes32 _name) public onlyOwner returns (address) {
643         // still latest.
644         if (super.getComponentByName(_name) == componentList.getLatestComponent(_name)) {
645             return super.getComponentByName(_name);
646         }
647         // Changed.
648         require(super.setComponent(_name, componentList.getLatestComponent(_name)));
649         // Check if approval is required
650         if(!excludedComponents[_name]) {
651             approveComponent(_name);
652         }
653         return super.getComponentByName(_name);
654     }
655 
656     function approveComponent(bytes32 _name) internal {
657         address componentAddress = getComponentByName(_name);
658         ERC20NoReturn mot = ERC20NoReturn(FeeChargerInterface(componentAddress).MOT());
659         mot.approve(componentAddress, 0);
660         mot.approve(componentAddress, 2 ** 256 - 1);
661     }
662 
663     function () public payable {
664 
665     }
666 
667     function hasRisk(address _sender, address _receiver, address _tokenAddress, uint _amount, uint _rate) public returns(bool) {
668         RiskControlInterface riskControl = RiskControlInterface(getComponentByName(RISK));
669         bool risk = riskControl.hasRisk(_sender, _receiver, _tokenAddress, _amount, _rate);
670         return risk;
671     }
672 
673     function setMultipleTimeIntervals(bytes32[] _timerNames, uint[] _secondsList) external onlyOwner{
674         LockerInterface(getComponentByName(LOCKER)).setMultipleTimeIntervals(_timerNames,  _secondsList);
675     }
676 
677     function setMaxSteps( bytes32 _category,uint _maxSteps) external onlyOwner {
678         StepInterface(getComponentByName(STEP)).setMaxCalls(_category,  _maxSteps);
679     }
680 }
681 
682 contract ERC20PriceInterface {
683     function getPrice() public view returns(uint);
684     function getETHBalance() public view returns(uint);
685 }
686 
687 contract IndexInterface is DerivativeInterface,  ERC20PriceInterface {
688 
689     address[] public tokens;
690     uint[] public weights;
691     bool public supportRebalance;
692 
693 
694     function invest() public payable returns(bool success);
695 
696     // this should be called until it returns true.
697     function rebalance() public returns (bool success);
698     function getTokens() public view returns (address[] _tokens, uint[] _weights);
699     function buyTokens() external returns(bool);
700 }
701 
702 contract ExchangeInterface is ComponentInterface {
703     /*
704      * @dev Checks if a trading pair is available
705      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
706      * @param address _sourceAddress The token to sell for the destAddress.
707      * @param address _destAddress The token to buy with the source token.
708      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
709      * @return boolean whether or not the trading pair is supported by this exchange provider
710      */
711     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId)
712         external view returns(bool supported);
713 
714     /*
715      * @dev Buy a single token with ETH.
716      * @param ERC20Extended _token The token to buy, should be an ERC20Extended address.
717      * @param uint _amount Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the _amount.
718      * @param uint _minimumRate The minimum amount of tokens to receive for 1 ETH.
719      * @param address _depositAddress The address to send the bought tokens to.
720      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
721      * @return boolean whether or not the trade succeeded.
722      */
723     function buyToken
724         (
725         ERC20Extended _token, uint _amount, uint _minimumRate,
726         address _depositAddress, bytes32 _exchangeId
727         ) external payable returns(bool success);
728 
729     /*
730      * @dev Sell a single token for ETH. Make sure the token is approved beforehand.
731      * @param ERC20Extended _token The token to sell, should be an ERC20Extended address.
732      * @param uint _amount Amount of tokens to sell.
733      * @param uint _minimumRate The minimum amount of ETH to receive for 1 ERC20Extended token.
734      * @param address _depositAddress The address to send the bought tokens to.
735      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
736      * @return boolean boolean whether or not the trade succeeded.
737      */
738     function sellToken
739         (
740         ERC20Extended _token, uint _amount, uint _minimumRate,
741         address _depositAddress, bytes32 _exchangeId
742         ) external returns(bool success);
743 }
744 
745 contract PriceProviderInterface is ComponentInterface {
746     /*
747      * @dev Returns the expected price for 1 of sourceAddress.
748      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
749      * @param address _sourceAddress The token to sell for the destAddress.
750      * @param address _destAddress The token to buy with the source token.
751      * @param uint _amount The amount of tokens which is wanted to buy.
752      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
753      * @return returns the expected and slippage rate for the specified conversion
754      */
755     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId)
756         external view returns(uint expectedRate, uint slippageRate);
757 
758     /*
759      * @dev Returns the expected price for 1 of sourceAddress. If it's currently not available, the last known price will be returned from cache.
760      * Note: when the price comes from cache, this should only be used as a backup, when there are no alternatives
761      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
762      * @param address _sourceAddress The token to sell for the destAddress.
763      * @param address _destAddress The token to buy with the source token.
764      * @param uint _amount The amount of tokens which is wanted to buy.
765      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
766      * @param uint _maxPriceAgeIfCache If the price is not available at the moment, choose the maximum age in seconds of the cached price to return.
767      * @return returns the expected and slippage rate for the specified conversion and whether or not the price comes from cache
768      */
769     function getPriceOrCacheFallback(
770         ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId, uint _maxPriceAgeIfCache)
771         external returns(uint expectedRate, uint slippageRate, bool isCached);
772 
773     /*
774      * @dev Returns the prices for multiple tokens in the form of ETH to token rates. If their prices are currently not available, the last known prices will be returned from cache.
775      * Note: when the price comes from cache, this should only be used as a backup, when there are no alternatives
776      * @param address _destAddress The token for which to get the ETH to token rate.
777      * @param uint _maxPriceAgeIfCache If any price is not available at the moment, choose the maximum age in seconds of the cached price to return.
778      * @return returns an array of the expected and slippage rates for the specified tokens and whether or not the price comes from cache
779      */
780     function getMultiplePricesOrCacheFallback(ERC20Extended[] _destAddresses, uint _maxPriceAgeIfCache)
781         external returns(uint[] expectedRates, uint[] slippageRates, bool[] isCached);
782 }
783 
784 contract OlympusExchangeInterface is ExchangeInterface, PriceProviderInterface, Ownable {
785     /*
786      * @dev Buy multiple tokens at once with ETH.
787      * @param ERC20Extended[] _tokens The tokens to buy, should be an array of ERC20Extended addresses.
788      * @param uint[] _amounts Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the sum of this array.
789      * @param uint[] _minimumRates The minimum amount of tokens to receive for 1 ETH.
790      * @param address _depositAddress The address to send the bought tokens to.
791      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
792      * @return boolean boolean whether or not the trade succeeded.
793      */
794     function buyTokens
795         (
796         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
797         address _depositAddress, bytes32 _exchangeId
798         ) external payable returns(bool success);
799 
800     /*
801      * @dev Sell multiple tokens at once with ETH, make sure all of the tokens are approved to be transferred beforehand with the Olympus Exchange address.
802      * @param ERC20Extended[] _tokens The tokens to sell, should be an array of ERC20Extended addresses.
803      * @param uint[] _amounts Amount of tokens to sell this token. Make sure the value sent to this function is the same as the sum of this array.
804      * @param uint[] _minimumRates The minimum amount of ETH to receive for 1 specified ERC20Extended token.
805      * @param address _depositAddress The address to send the bought tokens to.
806      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
807      * @return boolean boolean whether or not the trade succeeded.
808      */
809     function sellTokens
810         (
811         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
812         address _depositAddress, bytes32 _exchangeId
813         ) external returns(bool success);
814     function tokenExchange
815         (
816         ERC20Extended _src, ERC20Extended _dest, uint _amount, uint _minimumRate,
817         address _depositAddress, bytes32 _exchangeId
818         ) external returns(bool success);
819     function getFailedTrade(address _token) public view returns (uint failedTimes);
820     function getFailedTradesArray(ERC20Extended[] _tokens) public view returns (uint[] memory failedTimes);
821 }
822 
823 contract RebalanceInterface is ComponentInterface {
824     function recalculateTokensToBuyAfterSale(uint _receivedETHFromSale) external
825         returns(uint[] _recalculatedAmountsToBuy);
826     function rebalanceGetTokensToSellAndBuy(uint _rebalanceDeltaPercentage) external returns
827         (address[] _tokensToSell, uint[] _amountsToSell, address[] _tokensToBuy, uint[] _amountsToBuy, address[] _tokensWithPriceIssues);
828     function finalize() public returns(bool success);
829     function getRebalanceInProgress() external returns (bool inProgress);
830     function needsRebalance(uint _rebalanceDeltaPercentage, address _targetAddress) external view returns (bool _needsRebalance);
831     function getTotalIndexValueWithoutCache(address _indexAddress) public view returns (uint totalValue);
832 }
833 
834 contract WithdrawInterface is ComponentInterface {
835 
836     function request(address _requester, uint amount) external returns(bool);
837     function withdraw(address _requester) external returns(uint eth, uint tokens);
838     function freeze() external;
839     // TODO remove in progress
840     function isInProgress() external view returns(bool);
841     function finalize() external;
842     function getUserRequests() external view returns(address[]);
843     function getTotalWithdrawAmount() external view returns(uint);
844 
845     event WithdrawRequest(address _requester, uint amountOfToken);
846     event Withdrawed(address _requester,  uint amountOfToken , uint amountOfEther);
847 }
848 
849 contract MarketplaceInterface is Ownable {
850 
851     address[] public products;
852     mapping(address => address[]) public productMappings;
853 
854     function getAllProducts() external view returns (address[] allProducts);
855     function registerProduct() external returns(bool success);
856     function getOwnProducts() external view returns (address[] addresses);
857 
858     event Registered(address product, address owner);
859 }
860 
861 contract ChargeableInterface is ComponentInterface {
862 
863     uint public DENOMINATOR;
864     function calculateFee(address _caller, uint _amount) external returns(uint totalFeeAmount);
865     function setFeePercentage(uint _fee) external returns (bool succes);
866     function getFeePercentage() external view returns (uint feePercentage);
867 
868  }
869 
870 contract ReimbursableInterface is ComponentInterface {
871 
872     // this should be called at the beginning of a function.
873     // such as rebalance and withdraw.
874     function startGasCalculation() external;
875     // this should be called at the last moment of the function.
876     function reimburse() external returns (uint);
877 
878 }
879 
880 library Converter {
881     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
882         assembly {
883             result := mload(add(source, 32))
884         }
885     }
886 
887     function bytes32ToString(bytes32 x) internal pure returns (string) {
888         bytes memory bytesString = new bytes(32);
889         uint charCount = 0;
890         for (uint j = 0; j < 32; j++) {
891             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
892             if (char != 0) {
893                 bytesString[charCount] = char;
894                 charCount++;
895             }
896         }
897         bytes memory bytesStringTrimmed = new bytes(charCount);
898         for (j = 0; j < charCount; j++) {
899             bytesStringTrimmed[j] = bytesString[j];
900         }
901         return string(bytesStringTrimmed);
902     }
903 }
904 
905 contract OlympusIndex is IndexInterface, Derivative {
906     using SafeMath for uint256;
907 
908     bytes32 public constant BUYTOKENS = "BuyTokens";
909     enum Status { AVAILABLE, WITHDRAWING, REBALANCING, BUYING, SELLINGTOKENS }
910     Status public productStatus = Status.AVAILABLE;
911     // event ChangeStatus(DerivativeStatus status);
912 
913     uint public constant INITIAL_VALUE =  10**18;
914     uint public constant INITIAL_FEE = 10**17;
915     uint public constant TOKEN_DENOMINATOR = 10**18; // Apply % to a denominator, 18 is the minimum highetst precision required
916     uint[] public weights;
917     uint public accumulatedFee = 0;
918     uint public rebalanceDeltaPercentage = 0; // by default, can be 30, means 0.3%.
919     uint public rebalanceReceivedETHAmountFromSale;
920     uint public freezeBalance; // For operations (Buy tokens and sellTokens)
921     ERC20Extended[]  freezeTokens;
922     enum RebalancePhases { Initial, SellTokens, BuyTokens }
923 
924     constructor (
925       string _name,
926       string _symbol,
927       string _description,
928       bytes32 _category,
929       uint _decimals,
930       address[] _tokens,
931       uint[] _weights)
932       public {
933         require(0<=_decimals&&_decimals<=18);
934         require(_tokens.length == _weights.length);
935         uint _totalWeight;
936         uint i;
937 
938         for (i = 0; i < _weights.length; i++) {
939             _totalWeight = _totalWeight.add(_weights[i]);
940             // Check all tokens are ERC20Extended
941             ERC20Extended(_tokens[i]).balanceOf(address(this));
942             require( ERC20Extended(_tokens[i]).decimals() <= 18);
943         }
944         require(_totalWeight == 100);
945 
946         name = _name;
947         symbol = _symbol;
948         totalSupply_ = 0;
949         decimals = _decimals;
950         description = _description;
951         category = _category;
952         version = "1.1-20181002";
953         fundType = DerivativeType.Index;
954         tokens = _tokens;
955         weights = _weights;
956         status = DerivativeStatus.New;
957 
958 
959     }
960 
961     // ----------------------------- CONFIG -----------------------------
962     // solhint-disable-next-line
963     function initialize(
964         address _componentList,
965         uint _initialFundFee,
966         uint _rebalanceDeltaPercentage
967    )
968    external onlyOwner payable {
969         require(status == DerivativeStatus.New);
970         require(msg.value >= INITIAL_FEE); // Require some balance for internal opeations as reimbursable. 0.1ETH
971         require(_componentList != 0x0);
972         require(_rebalanceDeltaPercentage <= (10 ** decimals));
973 
974         pausedCycle = 365 days;
975 
976         rebalanceDeltaPercentage = _rebalanceDeltaPercentage;
977         super._initialize(_componentList);
978         bytes32[10] memory names = [
979             MARKET, EXCHANGE, REBALANCE, RISK, WHITELIST, FEE, REIMBURSABLE, WITHDRAW, LOCKER, STEP
980         ];
981 
982         for (uint i = 0; i < names.length; i++) {
983             updateComponent(names[i]);
984         }
985 
986         MarketplaceInterface(getComponentByName(MARKET)).registerProduct();
987         setManagementFee(_initialFundFee);
988 
989         uint[] memory _maxSteps = new uint[](4);
990         bytes32[] memory _categories = new bytes32[](4);
991         _maxSteps[0] = 3;
992         _maxSteps[1] = 10;
993         _maxSteps[2] = 5;
994         _maxSteps[3] = 5;
995 
996         _categories[0] = REBALANCE;
997         _categories[1] = WITHDRAW;
998         _categories[2] = BUYTOKENS;
999         _categories[3] = GETETH;
1000 
1001         StepInterface(getComponentByName(STEP)).setMultipleMaxCalls(_categories, _maxSteps);
1002         status = DerivativeStatus.Active;
1003 
1004         // emit ChangeStatus(status);
1005 
1006         accumulatedFee = accumulatedFee.add(msg.value);
1007     }
1008 
1009 
1010     // Return tokens and weights
1011     // solhint-disable-next-line
1012     function getTokens() public view returns (address[] _tokens, uint[] _weights) {
1013         return (tokens, weights);
1014     }
1015 
1016     // solhint-disable-next-line
1017     function close() OnlyOwnerOrPausedTimeout public returns(bool success) {
1018         require(status != DerivativeStatus.New);
1019         require(productStatus == Status.AVAILABLE);
1020 
1021         status = DerivativeStatus.Closed;
1022         return true;
1023     }
1024 
1025     function sellAllTokensOnClosedFund() onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) public returns (bool) {
1026         require(status == DerivativeStatus.Closed );
1027         require(productStatus == Status.AVAILABLE || productStatus == Status.SELLINGTOKENS);
1028         startGasCalculation();
1029         productStatus = Status.SELLINGTOKENS;
1030         bool result = getETHFromTokens(TOKEN_DENOMINATOR);
1031         if(result) {
1032             productStatus = Status.AVAILABLE;
1033         }
1034         reimburse();
1035         return result;
1036     }
1037     // ----------------------------- DERIVATIVE -----------------------------
1038     // solhint-disable-next-line
1039     function invest() public payable
1040      whenNotPaused
1041      whitelisted(WhitelistKeys.Investment)
1042      withoutRisk(msg.sender, address(this), ETH, msg.value, 1)
1043      returns(bool) {
1044         require(status == DerivativeStatus.Active, "The Fund is not active");
1045         require(msg.value >= 10**15, "Minimum value to invest is 0.001 ETH");
1046          // Current value is already added in the balance, reduce it
1047         uint _sharePrice  = INITIAL_VALUE;
1048 
1049         if (totalSupply_ > 0) {
1050             _sharePrice = getPrice().sub((msg.value.mul(10 ** decimals)).div(totalSupply_));
1051         }
1052 
1053         uint fee =  ChargeableInterface(getComponentByName(FEE)).calculateFee(msg.sender, msg.value);
1054         uint _investorShare = (msg.value.sub(fee)).mul(10 ** decimals).div(_sharePrice);
1055 
1056         accumulatedFee = accumulatedFee.add(fee);
1057         balances[msg.sender] = balances[msg.sender].add(_investorShare);
1058         totalSupply_ = totalSupply_.add(_investorShare);
1059 
1060         // emit Invested(msg.sender, _investorShare);
1061         emit Transfer(0x0, msg.sender, _investorShare); // ERC20 Required event
1062         return true;
1063     }
1064 
1065     function getPrice() public view returns(uint) {
1066         if (totalSupply_ == 0) {
1067             return INITIAL_VALUE;
1068         }
1069         uint valueETH = getAssetsValue().add(getETHBalance()).mul(10 ** decimals);
1070         // Total Value in ETH among its tokens + ETH new added value
1071         return valueETH.div(totalSupply_);
1072 
1073     }
1074 
1075     function getETHBalance() public view returns(uint) {
1076         return address(this).balance.sub(accumulatedFee);
1077     }
1078 
1079     function getAssetsValue() public view returns (uint) {
1080         // TODO cast to OlympusExchangeInterface
1081         OlympusExchangeInterface exchangeProvider = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1082         uint _totalTokensValue = 0;
1083         // Iterator
1084         uint _expectedRate;
1085         uint _balance;
1086         uint _decimals;
1087         ERC20Extended token;
1088 
1089         for (uint i = 0; i < tokens.length; i++) {
1090             token = ERC20Extended(tokens[i]);
1091             _decimals = token.decimals();
1092             _balance = token.balanceOf(address(this));
1093 
1094             if (_balance == 0) {continue;}
1095             (_expectedRate, ) = exchangeProvider.getPrice(token, ETH, 10**_decimals, 0x0);
1096             if (_expectedRate == 0) {continue;}
1097             _totalTokensValue = _totalTokensValue.add(_balance.mul(_expectedRate).div(10**_decimals));
1098         }
1099         return _totalTokensValue;
1100     }
1101 
1102     // ----------------------------- FEES  -----------------------------
1103     // Owner can send ETH to the Index, to perform some task, this eth belongs to him
1104     // solhint-disable-next-line
1105     function addOwnerBalance() external payable {
1106         accumulatedFee = accumulatedFee.add(msg.value);
1107     }
1108 
1109   // solhint-disable-next-line
1110     function withdrawFee(uint _amount) external onlyOwner whenNotPaused returns(bool) {
1111         require(_amount > 0 );
1112         require((
1113             status == DerivativeStatus.Closed && getAssetsValue() == 0 && getWithdrawAmount() == 0 ) ? // everything is done, take all.
1114             (_amount <= accumulatedFee)
1115             :
1116             (_amount.add(INITIAL_FEE) <= accumulatedFee) // else, the initial fee stays.
1117         );
1118         accumulatedFee = accumulatedFee.sub(_amount);
1119         // Exchange to MOT
1120         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1121         ERC20Extended MOT = ERC20Extended(FeeChargerInterface(address(exchange)).MOT());
1122         uint _rate;
1123         (, _rate ) = exchange.getPrice(ETH, MOT, _amount, 0x0);
1124         exchange.buyToken.value(_amount)(MOT, _amount, _rate, owner, 0x0);
1125         return true;
1126     }
1127 
1128     // solhint-disable-next-line
1129     function setManagementFee(uint _fee) public onlyOwner {
1130         ChargeableInterface(getComponentByName(FEE)).setFeePercentage(_fee);
1131     }
1132 
1133     // ----------------------------- WITHDRAW -----------------------------
1134     // solhint-disable-next-line
1135     function requestWithdraw(uint amount) external
1136       whenNotPaused
1137       withoutRisk(msg.sender, address(this), address(this), amount, getPrice())
1138     {
1139         WithdrawInterface withdrawProvider = WithdrawInterface(getComponentByName(WITHDRAW));
1140         withdrawProvider.request(msg.sender, amount);
1141         if(status == DerivativeStatus.Closed && getAssetsValue() == 0 && getWithdrawAmount() == amount) {
1142             withdrawProvider.freeze();
1143             handleWithdraw(withdrawProvider, msg.sender);
1144             withdrawProvider.finalize();
1145             return;
1146         }
1147      }
1148 
1149     function guaranteeLiquidity(uint tokenBalance) internal returns(bool success){
1150 
1151         if(getStatusStep(GETETH) == 0) {
1152             uint _totalETHToReturn = tokenBalance.mul(getPrice()).div(10**decimals);
1153             if (_totalETHToReturn <= getETHBalance()) {
1154                 return true;
1155             }
1156 
1157             // tokenPercentToSell must be freeze as class variable.
1158             // 10**18 is the highest preccision for all possible tokens
1159             freezeBalance = _totalETHToReturn.sub(getETHBalance()).mul(TOKEN_DENOMINATOR).div(getAssetsValue());
1160         }
1161         return getETHFromTokens(freezeBalance);
1162     }
1163 
1164     // solhint-disable-next-line
1165     function withdraw() external onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns(bool) {
1166         startGasCalculation();
1167 
1168         require(productStatus == Status.AVAILABLE || productStatus == Status.WITHDRAWING);
1169         productStatus = Status.WITHDRAWING;
1170 
1171         WithdrawInterface withdrawProvider = WithdrawInterface(getComponentByName(WITHDRAW));
1172 
1173         // Check if there is request
1174         address[] memory _requests = withdrawProvider.getUserRequests();
1175         uint _withdrawStatus = getStatusStep(WITHDRAW);
1176 
1177 
1178 
1179         if (_withdrawStatus == 0 && getStatusStep(GETETH) == 0) {
1180             checkLocker(WITHDRAW);
1181             if (_requests.length == 0) {
1182                 productStatus = Status.AVAILABLE;
1183                 reimburse();
1184                 return true;
1185             }
1186         }
1187 
1188         if (_withdrawStatus == 0) {
1189             if(!guaranteeLiquidity(getWithdrawAmount())) {
1190                 reimburse();
1191                 return false;
1192             }
1193             withdrawProvider.freeze();
1194         }
1195 
1196         uint _transfers = initializeOrContinueStep(WITHDRAW);
1197         uint i;
1198 
1199         for (i = _transfers; i < _requests.length && goNextStep(WITHDRAW); i++) {
1200             if(!handleWithdraw(withdrawProvider, _requests[i])){ continue; }
1201         }
1202 
1203         if (i == _requests.length) {
1204             withdrawProvider.finalize();
1205             finalizeStep(WITHDRAW);
1206             productStatus = Status.AVAILABLE;
1207         }
1208         reimburse();
1209         return i == _requests.length; // True if completed
1210     }
1211 
1212     function handleWithdraw(WithdrawInterface _withdrawProvider, address _investor) private returns (bool) {
1213         uint _eth;
1214         uint _tokenAmount;
1215 
1216         (_eth, _tokenAmount) = _withdrawProvider.withdraw(_investor);
1217         if (_tokenAmount == 0) {return false;}
1218 
1219         balances[_investor] =  balances[_investor].sub(_tokenAmount);
1220         emit Transfer(_investor, 0x0, _tokenAmount); // ERC20 Required event
1221 
1222         totalSupply_ = totalSupply_.sub(_tokenAmount);
1223         address(_investor).transfer(_eth);
1224 
1225         return true;
1226     }
1227 
1228     function checkLocker(bytes32 category) internal {
1229         LockerInterface(getComponentByName(LOCKER)).checkLockerByTime(category);
1230     }
1231 
1232     function startGasCalculation() internal {
1233         ReimbursableInterface(getComponentByName(REIMBURSABLE)).startGasCalculation();
1234     }
1235 
1236     // solhint-disable-next-line
1237     function reimburse() private {
1238         uint reimbursedAmount = ReimbursableInterface(getComponentByName(REIMBURSABLE)).reimburse();
1239         accumulatedFee = accumulatedFee.sub(reimbursedAmount);
1240         // emit Reimbursed(reimbursedAmount);
1241         msg.sender.transfer(reimbursedAmount);
1242     }
1243 
1244     // solhint-disable-next-line
1245     function tokensWithAmount() public view returns( ERC20Extended[] memory) {
1246         // First check the length
1247         uint length = 0;
1248         uint[] memory _amounts = new uint[](tokens.length);
1249         for (uint i = 0; i < tokens.length; i++) {
1250             _amounts[i] = ERC20Extended(tokens[i]).balanceOf(address(this));
1251             if (_amounts[i] > 0) {length++;}
1252         }
1253 
1254         ERC20Extended[] memory _tokensWithAmount = new ERC20Extended[](length);
1255         // Then create they array
1256         uint index = 0;
1257         for (uint j = 0; j < tokens.length; j++) {
1258             if (_amounts[j] > 0) {
1259                 _tokensWithAmount[index] = ERC20Extended(tokens[j]);
1260                 index++;
1261             }
1262         }
1263         return _tokensWithAmount;
1264     }
1265 
1266     // _tokenPercentage must come in TOKEN_DENOMIANTOR
1267     function getETHFromTokens(uint _tokenPercentage) internal returns(bool success) {
1268         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1269 
1270         uint currentStep = initializeOrContinueStep(GETETH);
1271         uint i; // Current step to tokens.length
1272         uint arrayLength = getNextArrayLength(GETETH, currentStep);
1273         if(currentStep == 0) {
1274             freezeTokens = tokensWithAmount();
1275         }
1276 
1277         ERC20Extended[] memory _tokensThisStep = new ERC20Extended[](arrayLength);
1278         uint[] memory _amounts = new uint[](arrayLength);
1279         uint[] memory _sellRates = new uint[](arrayLength);
1280 
1281         for(i = currentStep;i < freezeTokens.length && goNextStep(GETETH); i++){
1282             uint sellIndex = i.sub(currentStep);
1283             _tokensThisStep[sellIndex] = freezeTokens[i];
1284             _amounts[sellIndex] = _tokenPercentage.mul(freezeTokens[i].balanceOf(address(this))).div(TOKEN_DENOMINATOR);
1285             (, _sellRates[sellIndex] ) = exchange.getPrice(freezeTokens[i], ETH, _amounts[sellIndex], 0x0);
1286             // require(!hasRisk(address(this), exchange, address(_tokensThisStep[sellIndex]), _amounts[sellIndex], 0));
1287             approveExchange(address(_tokensThisStep[sellIndex]), _amounts[sellIndex]);
1288         }
1289         require(exchange.sellTokens(_tokensThisStep, _amounts, _sellRates, address(this), 0x0));
1290 
1291         if(i == freezeTokens.length) {
1292             finalizeStep(GETETH);
1293             return true;
1294         }
1295         return false;
1296     }
1297 
1298     // ----------------------------- REBALANCE -----------------------------
1299     // solhint-disable-next-line
1300     function buyTokens() external onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns(bool) {
1301         startGasCalculation();
1302 
1303         require(productStatus == Status.AVAILABLE || productStatus == Status.BUYING);
1304         productStatus = Status.BUYING;
1305 
1306         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1307 
1308         // Start?
1309         if (getStatusStep(BUYTOKENS) == 0) {
1310             checkLocker(BUYTOKENS);
1311             if (tokens.length == 0 || getETHBalance() == 0) {
1312                 productStatus = Status.AVAILABLE;
1313                 reimburse();
1314                 return true;
1315             }
1316             freezeBalance = getETHBalance();
1317         }
1318         uint currentStep = initializeOrContinueStep(BUYTOKENS);
1319 
1320         // Check the length of the array
1321         uint arrayLength = getNextArrayLength(BUYTOKENS, currentStep);
1322 
1323         uint[] memory _amounts = new uint[](arrayLength);
1324         // Initialize to 0, making sure any rate is fine
1325         uint[] memory _rates = new uint[](arrayLength);
1326         // Initialize to 0, making sure any rate is fine
1327         ERC20Extended[] memory _tokensErc20 = new ERC20Extended[](arrayLength);
1328         uint _totalAmount = 0;
1329         uint i; // Current step to tokens.length
1330         uint _buyIndex; // 0 to currentStepLength
1331         for (i = currentStep; i < tokens.length && goNextStep(BUYTOKENS); i++) {
1332             _buyIndex = i - currentStep;
1333             _amounts[_buyIndex] = freezeBalance.mul(weights[i]).div(100);
1334             _tokensErc20[_buyIndex] = ERC20Extended(tokens[i]);
1335             (, _rates[_buyIndex] ) = exchange.getPrice(ETH, _tokensErc20[_buyIndex], _amounts[_buyIndex], 0x0);
1336             _totalAmount = _totalAmount.add(_amounts[_buyIndex]);
1337         }
1338 
1339         require(exchange.buyTokens.value(_totalAmount)(_tokensErc20, _amounts, _rates, address(this), 0x0));
1340 
1341         if(i == tokens.length) {
1342             finalizeStep(BUYTOKENS);
1343             freezeBalance = 0;
1344             productStatus = Status.AVAILABLE;
1345             reimburse();
1346             return true;
1347         }
1348         reimburse();
1349         return false;
1350     }
1351 
1352     // solhint-disable-next-line
1353     function rebalance() public onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns (bool success) {
1354         startGasCalculation();
1355 
1356         require(productStatus == Status.AVAILABLE || productStatus == Status.REBALANCING);
1357 
1358         RebalanceInterface rebalanceProvider = RebalanceInterface(getComponentByName(REBALANCE));
1359         OlympusExchangeInterface exchangeProvider = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1360         if (!rebalanceProvider.getRebalanceInProgress()) {
1361             checkLocker(REBALANCE);
1362         }
1363 
1364         address[] memory _tokensToSell;
1365         uint[] memory _amounts;
1366         address[] memory _tokensToBuy;
1367         uint i;
1368 
1369         (_tokensToSell, _amounts, _tokensToBuy,,) = rebalanceProvider.rebalanceGetTokensToSellAndBuy(rebalanceDeltaPercentage);
1370         if(_tokensToSell.length == 0) {
1371             reimburse(); // Completed case
1372             return true;
1373         }
1374         // solhint-disable-next-line
1375         uint ETHBalanceBefore = getETHBalance();
1376 
1377         uint currentStep = initializeOrContinueStep(REBALANCE);
1378         uint stepStatus = getStatusStep(REBALANCE);
1379         // solhint-disable-next-line
1380 
1381         productStatus = Status.REBALANCING;
1382 
1383         // Sell Tokens
1384         if ( stepStatus == uint(RebalancePhases.SellTokens)) {
1385             for (i = currentStep; i < _tokensToSell.length && goNextStep(REBALANCE) ; i++) {
1386                 approveExchange(_tokensToSell[i], _amounts[i]);
1387                 // solhint-disable-next-line
1388 
1389                 require(exchangeProvider.sellToken(ERC20Extended(_tokensToSell[i]), _amounts[i], 0, address(this), 0x0));
1390             }
1391 
1392             rebalanceReceivedETHAmountFromSale = rebalanceReceivedETHAmountFromSale.add(getETHBalance()).sub(ETHBalanceBefore) ;
1393             if (i ==  _tokensToSell.length) {
1394                 updateStatusStep(REBALANCE);
1395                 currentStep = 0;
1396             }
1397         }
1398         // Buy Tokens
1399         if (stepStatus == uint(RebalancePhases.BuyTokens)) {
1400             _amounts = rebalanceProvider.recalculateTokensToBuyAfterSale(rebalanceReceivedETHAmountFromSale);
1401             for (i = currentStep; i < _tokensToBuy.length && goNextStep(REBALANCE); i++) {
1402                 require(
1403                     // solhint-disable-next-line
1404                     exchangeProvider.buyToken.value(_amounts[i])(ERC20Extended(_tokensToBuy[i]), _amounts[i], 0, address(this), 0x0)
1405                 );
1406             }
1407 
1408             if(i == _tokensToBuy.length) {
1409                 finalizeStep(REBALANCE);
1410                 rebalanceProvider.finalize();
1411                 rebalanceReceivedETHAmountFromSale = 0;
1412                 productStatus = Status.AVAILABLE;
1413                 reimburse();   // Completed case
1414                 return true;
1415             }
1416         }
1417         reimburse(); // Not complete case
1418         return false;
1419     }
1420     // ----------------------------- STEP PROVIDER -----------------------------
1421     function initializeOrContinueStep(bytes32 category) internal returns(uint) {
1422         return  StepInterface(getComponentByName(STEP)).initializeOrContinue(category);
1423     }
1424 
1425     function getStatusStep(bytes32 category) internal view returns(uint) {
1426         return  StepInterface(getComponentByName(STEP)).getStatus(category);
1427     }
1428 
1429     function finalizeStep(bytes32 category) internal returns(bool) {
1430         return  StepInterface(getComponentByName(STEP)).finalize(category);
1431     }
1432 
1433     function goNextStep(bytes32 category) internal returns(bool) {
1434         return StepInterface(getComponentByName(STEP)).goNextStep(category);
1435     }
1436 
1437     function updateStatusStep(bytes32 category) internal returns(uint) {
1438         return StepInterface(getComponentByName(STEP)).updateStatus(category);
1439     }
1440 
1441     function getWithdrawAmount() internal view returns(uint) {
1442         return WithdrawInterface(getComponentByName(WITHDRAW)).getTotalWithdrawAmount();
1443     }
1444 
1445     function getNextArrayLength(bytes32 stepCategory, uint currentStep) internal view returns(uint) {
1446         uint arrayLength = StepInterface(getComponentByName(STEP)).getMaxCalls(stepCategory);
1447         if(arrayLength.add(currentStep) >= tokens.length ) {
1448             arrayLength = tokens.length.sub(currentStep);
1449         }
1450         return arrayLength;
1451     }
1452 
1453     function approveExchange(address _token, uint amount) internal {
1454         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1455         ERC20NoReturn(_token).approve(exchange, 0);
1456         ERC20NoReturn(_token).approve(exchange, amount);
1457     }
1458 
1459     // ----------------------------- WHITELIST -----------------------------
1460     // solhint-disable-next-line
1461     function enableWhitelist(WhitelistKeys _key, bool enable) external onlyOwner returns(bool) {
1462         WhitelistInterface(getComponentByName(WHITELIST)).setStatus(uint(_key), enable);
1463         return true;
1464     }
1465 
1466     // solhint-disable-next-line
1467     function setAllowed(address[] accounts, WhitelistKeys _key, bool allowed) public onlyOwner returns(bool) {
1468         WhitelistInterface(getComponentByName(WHITELIST)).setAllowed(accounts, uint(_key), allowed);
1469         return true;
1470     }
1471 }