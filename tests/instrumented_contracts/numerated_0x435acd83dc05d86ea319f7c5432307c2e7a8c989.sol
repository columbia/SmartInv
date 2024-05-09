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
80     enum DerivativeType { Index, Fund, Future, BinaryFuture }
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
586     bytes32 public constant WHITELIST = "WhitelistProvider";
587     bytes32 public constant FEE = "FeeProvider";
588     bytes32 public constant REIMBURSABLE = "Reimbursable";
589     bytes32 public constant REBALANCE = "RebalanceProvider";
590     bytes32 public constant STEP = "StepProvider";
591     bytes32 public constant LOCKER = "LockerProvider";
592 
593     bytes32 public constant GETETH = "GetEth";
594 
595     uint public pausedTime;
596     uint public pausedCycle;
597 
598     function pause() onlyOwner whenNotPaused public {
599         paused = true;
600         pausedTime = now;
601     }
602 
603     enum WhitelistKeys { Investment, Maintenance, Admin }
604 
605     mapping(bytes32 => bool) internal excludedComponents;
606 
607     modifier OnlyOwnerOrPausedTimeout() {
608         require( (msg.sender == owner) || ( paused == true && (pausedTime+pausedCycle) <= now ) );
609         _;
610     }
611 
612     // If whitelist is disabled, that will become onlyOwner
613     modifier onlyOwnerOrWhitelisted(WhitelistKeys _key) {
614         WhitelistInterface whitelist = WhitelistInterface(getComponentByName(WHITELIST));
615         require(
616             msg.sender == owner ||
617             (whitelist.enabled(address(this), uint(_key)) && whitelist.isAllowed(uint(_key), msg.sender) )
618         );
619         _;
620     }
621 
622     // If whitelist is disabled, anyone can do this
623     modifier whitelisted(WhitelistKeys _key) {
624         require(WhitelistInterface(getComponentByName(WHITELIST)).isAllowed(uint(_key), msg.sender));
625         _;
626     }
627 
628     function _initialize (address _componentList) internal {
629         require(_componentList != 0x0);
630         componentList = ComponentListInterface(_componentList);
631         excludedComponents[MARKET] = true;
632         excludedComponents[STEP] = true;
633         excludedComponents[LOCKER] = true;
634     }
635 
636     function updateComponent(bytes32 _name) public onlyOwner returns (address) {
637         // still latest.
638         if (super.getComponentByName(_name) == componentList.getLatestComponent(_name)) {
639             return super.getComponentByName(_name);
640         }
641         // Changed.
642         require(super.setComponent(_name, componentList.getLatestComponent(_name)));
643         // Check if approval is required
644         if(!excludedComponents[_name]) {
645             approveComponent(_name);
646         }
647         return super.getComponentByName(_name);
648     }
649 
650     function approveComponent(bytes32 _name) internal {
651         address componentAddress = getComponentByName(_name);
652         ERC20NoReturn mot = ERC20NoReturn(FeeChargerInterface(componentAddress).MOT());
653         mot.approve(componentAddress, 0);
654         mot.approve(componentAddress, 2 ** 256 - 1);
655     }
656 
657     function () public payable {
658 
659     }
660 
661     function setMultipleTimeIntervals(bytes32[] _timerNames, uint[] _secondsList) public onlyOwner{
662         LockerInterface(getComponentByName(LOCKER)).setMultipleTimeIntervals(_timerNames, _secondsList);
663     }
664 
665     function setMaxSteps(bytes32 _category, uint _maxSteps) public onlyOwner {
666         StepInterface(getComponentByName(STEP)).setMaxCalls(_category, _maxSteps);
667     }
668 }
669 
670 contract ERC20PriceInterface {
671     function getPrice() public view returns(uint);
672     function getETHBalance() public view returns(uint);
673 }
674 
675 contract IndexInterface is DerivativeInterface,  ERC20PriceInterface {
676 
677     address[] public tokens;
678     uint[] public weights;
679     bool public supportRebalance;
680 
681 
682     function invest() public payable returns(bool success);
683 
684     // this should be called until it returns true.
685     function rebalance() public returns (bool success);
686     function getTokens() public view returns (address[] _tokens, uint[] _weights);
687     function buyTokens() external returns(bool);
688 }
689 
690 contract ExchangeInterface is ComponentInterface {
691     /*
692      * @dev Checks if a trading pair is available
693      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
694      * @param address _sourceAddress The token to sell for the destAddress.
695      * @param address _destAddress The token to buy with the source token.
696      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
697      * @return boolean whether or not the trading pair is supported by this exchange provider
698      */
699     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId)
700         external view returns(bool supported);
701 
702     /*
703      * @dev Buy a single token with ETH.
704      * @param ERC20Extended _token The token to buy, should be an ERC20Extended address.
705      * @param uint _amount Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the _amount.
706      * @param uint _minimumRate The minimum amount of tokens to receive for 1 ETH.
707      * @param address _depositAddress The address to send the bought tokens to.
708      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
709      * @return boolean whether or not the trade succeeded.
710      */
711     function buyToken
712         (
713         ERC20Extended _token, uint _amount, uint _minimumRate,
714         address _depositAddress, bytes32 _exchangeId
715         ) external payable returns(bool success);
716 
717     /*
718      * @dev Sell a single token for ETH. Make sure the token is approved beforehand.
719      * @param ERC20Extended _token The token to sell, should be an ERC20Extended address.
720      * @param uint _amount Amount of tokens to sell.
721      * @param uint _minimumRate The minimum amount of ETH to receive for 1 ERC20Extended token.
722      * @param address _depositAddress The address to send the bought tokens to.
723      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
724      * @return boolean boolean whether or not the trade succeeded.
725      */
726     function sellToken
727         (
728         ERC20Extended _token, uint _amount, uint _minimumRate,
729         address _depositAddress, bytes32 _exchangeId
730         ) external returns(bool success);
731 }
732 
733 contract PriceProviderInterface is ComponentInterface {
734     /*
735      * @dev Returns the expected price for 1 of sourceAddress.
736      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
737      * @param address _sourceAddress The token to sell for the destAddress.
738      * @param address _destAddress The token to buy with the source token.
739      * @param uint _amount The amount of tokens which is wanted to buy.
740      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
741      * @return returns the expected and slippage rate for the specified conversion
742      */
743     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId)
744         external view returns(uint expectedRate, uint slippageRate);
745 
746     /*
747      * @dev Returns the expected price for 1 of sourceAddress. If it's currently not available, the last known price will be returned from cache.
748      * Note: when the price comes from cache, this should only be used as a backup, when there are no alternatives
749      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
750      * @param address _sourceAddress The token to sell for the destAddress.
751      * @param address _destAddress The token to buy with the source token.
752      * @param uint _amount The amount of tokens which is wanted to buy.
753      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
754      * @param uint _maxPriceAgeIfCache If the price is not available at the moment, choose the maximum age in seconds of the cached price to return.
755      * @return returns the expected and slippage rate for the specified conversion and whether or not the price comes from cache
756      */
757     function getPriceOrCacheFallback(
758         ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId, uint _maxPriceAgeIfCache)
759         external returns(uint expectedRate, uint slippageRate, bool isCached);
760 
761     /*
762      * @dev Returns the prices for multiple tokens in the form of ETH to token rates. If their prices are currently not available, the last known prices will be returned from cache.
763      * Note: when the price comes from cache, this should only be used as a backup, when there are no alternatives
764      * @param address _destAddress The token for which to get the ETH to token rate.
765      * @param uint _maxPriceAgeIfCache If any price is not available at the moment, choose the maximum age in seconds of the cached price to return.
766      * @return returns an array of the expected and slippage rates for the specified tokens and whether or not the price comes from cache
767      */
768     function getMultiplePricesOrCacheFallback(ERC20Extended[] _destAddresses, uint _maxPriceAgeIfCache)
769         external returns(uint[] expectedRates, uint[] slippageRates, bool[] isCached);
770 }
771 
772 contract OlympusExchangeInterface is ExchangeInterface, PriceProviderInterface, Ownable {
773     /*
774      * @dev Buy multiple tokens at once with ETH.
775      * @param ERC20Extended[] _tokens The tokens to buy, should be an array of ERC20Extended addresses.
776      * @param uint[] _amounts Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the sum of this array.
777      * @param uint[] _minimumRates The minimum amount of tokens to receive for 1 ETH.
778      * @param address _depositAddress The address to send the bought tokens to.
779      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
780      * @return boolean boolean whether or not the trade succeeded.
781      */
782     function buyTokens
783         (
784         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
785         address _depositAddress, bytes32 _exchangeId
786         ) external payable returns(bool success);
787 
788     /*
789      * @dev Sell multiple tokens at once with ETH, make sure all of the tokens are approved to be transferred beforehand with the Olympus Exchange address.
790      * @param ERC20Extended[] _tokens The tokens to sell, should be an array of ERC20Extended addresses.
791      * @param uint[] _amounts Amount of tokens to sell this token. Make sure the value sent to this function is the same as the sum of this array.
792      * @param uint[] _minimumRates The minimum amount of ETH to receive for 1 specified ERC20Extended token.
793      * @param address _depositAddress The address to send the bought tokens to.
794      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
795      * @return boolean boolean whether or not the trade succeeded.
796      */
797     function sellTokens
798         (
799         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
800         address _depositAddress, bytes32 _exchangeId
801         ) external returns(bool success);
802     function tokenExchange
803         (
804         ERC20Extended _src, ERC20Extended _dest, uint _amount, uint _minimumRate,
805         address _depositAddress, bytes32 _exchangeId
806         ) external returns(bool success);
807     function getFailedTrade(address _token) public view returns (uint failedTimes);
808     function getFailedTradesArray(ERC20Extended[] _tokens) public view returns (uint[] memory failedTimes);
809 }
810 
811 contract RebalanceInterface is ComponentInterface {
812     function recalculateTokensToBuyAfterSale(uint _receivedETHFromSale) external
813         returns(uint[] _recalculatedAmountsToBuy);
814     function rebalanceGetTokensToSellAndBuy(uint _rebalanceDeltaPercentage) external returns
815         (address[] _tokensToSell, uint[] _amountsToSell, address[] _tokensToBuy, uint[] _amountsToBuy, address[] _tokensWithPriceIssues);
816     function finalize() public returns(bool success);
817     function getRebalanceInProgress() external returns (bool inProgress);
818     function needsRebalance(uint _rebalanceDeltaPercentage, address _targetAddress) external view returns (bool _needsRebalance);
819     function getTotalIndexValueWithoutCache(address _indexAddress) public view returns (uint totalValue);
820 }
821 
822 contract WithdrawInterface is ComponentInterface {
823 
824     function request(address _requester, uint amount) external returns(bool);
825     function withdraw(address _requester) external returns(uint eth, uint tokens);
826     function freeze() external;
827     // TODO remove in progress
828     function isInProgress() external view returns(bool);
829     function finalize() external;
830     function getUserRequests() external view returns(address[]);
831     function getTotalWithdrawAmount() external view returns(uint);
832 
833     event WithdrawRequest(address _requester, uint amountOfToken);
834     event Withdrawed(address _requester,  uint amountOfToken , uint amountOfEther);
835 }
836 
837 contract MarketplaceInterface is Ownable {
838 
839     address[] public products;
840     mapping(address => address[]) public productMappings;
841 
842     function getAllProducts() external view returns (address[] allProducts);
843     function registerProduct() external returns(bool success);
844     function getOwnProducts() external view returns (address[] addresses);
845 
846     event Registered(address product, address owner);
847 }
848 
849 contract ChargeableInterface is ComponentInterface {
850 
851     uint public DENOMINATOR;
852     function calculateFee(address _caller, uint _amount) external returns(uint totalFeeAmount);
853     function setFeePercentage(uint _fee) external returns (bool succes);
854     function getFeePercentage() external view returns (uint feePercentage);
855 
856  }
857 
858 contract ReimbursableInterface is ComponentInterface {
859 
860     // this should be called at the beginning of a function.
861     // such as rebalance and withdraw.
862     function startGasCalculation() external;
863     // this should be called at the last moment of the function.
864     function reimburse() external returns (uint);
865 
866 }
867 
868 library Converter {
869     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
870         assembly {
871             result := mload(add(source, 32))
872         }
873     }
874 
875     function bytes32ToString(bytes32 x) internal pure returns (string) {
876         bytes memory bytesString = new bytes(32);
877         uint charCount = 0;
878         for (uint j = 0; j < 32; j++) {
879             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
880             if (char != 0) {
881                 bytesString[charCount] = char;
882                 charCount++;
883             }
884         }
885         bytes memory bytesStringTrimmed = new bytes(charCount);
886         for (j = 0; j < charCount; j++) {
887             bytesStringTrimmed[j] = bytesString[j];
888         }
889         return string(bytesStringTrimmed);
890     }
891 }
892 
893 contract OlympusIndex is IndexInterface, Derivative {
894     using SafeMath for uint256;
895 
896     bytes32 public constant BUYTOKENS = "BuyTokens";
897     enum Status { AVAILABLE, WITHDRAWING, REBALANCING, BUYING, SELLINGTOKENS }
898     Status public productStatus = Status.AVAILABLE;
899     // event ChangeStatus(DerivativeStatus status);
900 
901     uint public constant INITIAL_VALUE =  10**18;
902     uint public constant INITIAL_FEE = 10**17;
903     uint public constant TOKEN_DENOMINATOR = 10**18; // Apply % to a denominator, 18 is the minimum highetst precision required
904     uint[] public weights;
905     uint public accumulatedFee = 0;
906     uint public rebalanceDeltaPercentage = 0; // by default, can be 30, means 0.3%.
907     uint public rebalanceReceivedETHAmountFromSale;
908     uint public freezeBalance; // For operations (Buy tokens and sellTokens)
909     ERC20Extended[]  freezeTokens;
910     enum RebalancePhases { Initial, SellTokens, BuyTokens }
911 
912     constructor (
913       string _name,
914       string _symbol,
915       string _description,
916       bytes32 _category,
917       uint _decimals,
918       address[] _tokens,
919       uint[] _weights)
920       public {
921         require(0<=_decimals&&_decimals<=18);
922         require(_tokens.length == _weights.length);
923         uint _totalWeight;
924         uint i;
925 
926         for (i = 0; i < _weights.length; i++) {
927             _totalWeight = _totalWeight.add(_weights[i]);
928             // Check all tokens are ERC20Extended
929             ERC20Extended(_tokens[i]).balanceOf(address(this));
930             require( ERC20Extended(_tokens[i]).decimals() <= 18);
931         }
932         require(_totalWeight == 100);
933 
934         name = _name;
935         symbol = _symbol;
936         totalSupply_ = 0;
937         decimals = _decimals;
938         description = _description;
939         category = _category;
940         version = "1.1-20181228";
941         fundType = DerivativeType.Index;
942         tokens = _tokens;
943         weights = _weights;
944         status = DerivativeStatus.New;
945 
946 
947     }
948 
949     // ----------------------------- CONFIG -----------------------------
950     // solhint-disable-next-line
951     function initialize(
952         address _componentList,
953         uint _initialFundFee,
954         uint _rebalanceDeltaPercentage
955    )
956    public onlyOwner payable {
957         require(status == DerivativeStatus.New);
958         require(msg.value >= INITIAL_FEE); // Require some balance for internal opeations as reimbursable. 0.1ETH
959         require(_componentList != 0x0);
960         require(_rebalanceDeltaPercentage <= (10 ** decimals));
961 
962         pausedCycle = 365 days;
963 
964         rebalanceDeltaPercentage = _rebalanceDeltaPercentage;
965         super._initialize(_componentList);
966         bytes32[9] memory names = [
967             MARKET, EXCHANGE, REBALANCE, WHITELIST, FEE, REIMBURSABLE, WITHDRAW, LOCKER, STEP
968         ];
969 
970         for (uint i = 0; i < names.length; i++) {
971             updateComponent(names[i]);
972         }
973 
974         MarketplaceInterface(getComponentByName(MARKET)).registerProduct();
975         setManagementFee(_initialFundFee);
976 
977         uint[] memory _maxSteps = new uint[](4);
978         bytes32[] memory _categories = new bytes32[](4);
979         _maxSteps[0] = 3;
980         _maxSteps[1] = 10;
981         _maxSteps[2] = 5;
982         _maxSteps[3] = 3;
983 
984         _categories[0] = REBALANCE;
985         _categories[1] = WITHDRAW;
986         _categories[2] = BUYTOKENS;
987         _categories[3] = GETETH;
988 
989         StepInterface(getComponentByName(STEP)).setMultipleMaxCalls(_categories, _maxSteps);
990         status = DerivativeStatus.Active;
991 
992         // emit ChangeStatus(status);
993 
994         accumulatedFee = accumulatedFee.add(msg.value);
995     }
996 
997 
998     // Return tokens and weights
999     // solhint-disable-next-line
1000     function getTokens() public view returns (address[] _tokens, uint[] _weights) {
1001         return (tokens, weights);
1002     }
1003 
1004     // solhint-disable-next-line
1005     function close() OnlyOwnerOrPausedTimeout public returns(bool success) {
1006         require(status != DerivativeStatus.New);
1007         require(productStatus == Status.AVAILABLE);
1008 
1009         status = DerivativeStatus.Closed;
1010         return true;
1011     }
1012 
1013     function sellAllTokensOnClosedFund() onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) public returns (bool) {
1014         require(status == DerivativeStatus.Closed );
1015         require(productStatus == Status.AVAILABLE || productStatus == Status.SELLINGTOKENS);
1016         startGasCalculation();
1017         productStatus = Status.SELLINGTOKENS;
1018         bool result = getETHFromTokens(TOKEN_DENOMINATOR);
1019         if(result) {
1020             productStatus = Status.AVAILABLE;
1021         }
1022         reimburse();
1023         return result;
1024     }
1025     // ----------------------------- DERIVATIVE -----------------------------
1026     // solhint-disable-next-line
1027     function invest() public payable
1028      whenNotPaused
1029      whitelisted(WhitelistKeys.Investment)
1030       returns(bool) {
1031         require(status == DerivativeStatus.Active, "The Fund is not active");
1032         require(msg.value >= 10**15, "Minimum value to invest is 0.001 ETH");
1033          // Current value is already added in the balance, reduce it
1034         uint _sharePrice  = INITIAL_VALUE;
1035 
1036         if (totalSupply_ > 0) {
1037             _sharePrice = getPrice().sub((msg.value.mul(10 ** decimals)).div(totalSupply_));
1038         }
1039 
1040         uint fee =  ChargeableInterface(getComponentByName(FEE)).calculateFee(msg.sender, msg.value);
1041         uint _investorShare = (msg.value.sub(fee)).mul(10 ** decimals).div(_sharePrice);
1042 
1043         accumulatedFee = accumulatedFee.add(fee);
1044         balances[msg.sender] = balances[msg.sender].add(_investorShare);
1045         totalSupply_ = totalSupply_.add(_investorShare);
1046 
1047         // emit Invested(msg.sender, _investorShare);
1048         emit Transfer(0x0, msg.sender, _investorShare); // ERC20 Required event
1049         return true;
1050     }
1051 
1052     function getPrice() public view returns(uint) {
1053         if (totalSupply_ == 0) {
1054             return INITIAL_VALUE;
1055         }
1056         uint valueETH = getAssetsValue().add(getETHBalance()).mul(10 ** decimals);
1057         // Total Value in ETH among its tokens + ETH new added value
1058         return valueETH.div(totalSupply_);
1059 
1060     }
1061 
1062     function getETHBalance() public view returns(uint) {
1063         return address(this).balance.sub(accumulatedFee);
1064     }
1065 
1066     function getAssetsValue() public view returns (uint) {
1067         // TODO cast to OlympusExchangeInterface
1068         OlympusExchangeInterface exchangeProvider = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1069         uint _totalTokensValue = 0;
1070         // Iterator
1071         uint _expectedRate;
1072         uint _balance;
1073         uint _decimals;
1074         ERC20Extended token;
1075 
1076         for (uint i = 0; i < tokens.length; i++) {
1077             token = ERC20Extended(tokens[i]);
1078             _decimals = token.decimals();
1079             _balance = token.balanceOf(address(this));
1080 
1081             if (_balance == 0) {continue;}
1082             (_expectedRate, ) = exchangeProvider.getPrice(token, ETH, 10**_decimals, 0x0);
1083             if (_expectedRate == 0) {continue;}
1084             _totalTokensValue = _totalTokensValue.add(_balance.mul(_expectedRate).div(10**_decimals));
1085         }
1086         return _totalTokensValue;
1087     }
1088 
1089     // ----------------------------- FEES  -----------------------------
1090     // Owner can send ETH to the Index, to perform some task, this eth belongs to him
1091     // solhint-disable-next-line
1092     function addOwnerBalance() external payable {
1093         accumulatedFee = accumulatedFee.add(msg.value);
1094     }
1095 
1096   // solhint-disable-next-line
1097     function withdrawFee(uint _amount) external onlyOwner whenNotPaused returns(bool) {
1098         require(_amount > 0 );
1099         require((
1100             status == DerivativeStatus.Closed && getAssetsValue() == 0 && getWithdrawAmount() == 0 ) ? // everything is done, take all.
1101             (_amount <= accumulatedFee)
1102             :
1103             (_amount.add(INITIAL_FEE) <= accumulatedFee) // else, the initial fee stays.
1104         );
1105         accumulatedFee = accumulatedFee.sub(_amount);
1106         // Exchange to MOT
1107         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1108         ERC20Extended MOT = ERC20Extended(FeeChargerInterface(address(exchange)).MOT());
1109         uint _rate;
1110         (, _rate ) = exchange.getPrice(ETH, MOT, _amount, 0x0);
1111         exchange.buyToken.value(_amount)(MOT, _amount, _rate, owner, 0x0);
1112         return true;
1113     }
1114 
1115     // solhint-disable-next-line
1116     function setManagementFee(uint _fee) public onlyOwner {
1117         ChargeableInterface(getComponentByName(FEE)).setFeePercentage(_fee);
1118     }
1119 
1120     // ----------------------------- WITHDRAW -----------------------------
1121     // solhint-disable-next-line
1122     function requestWithdraw(uint amount) external
1123       whenNotPaused
1124      {
1125         WithdrawInterface withdrawProvider = WithdrawInterface(getComponentByName(WITHDRAW));
1126         withdrawProvider.request(msg.sender, amount);
1127         if(status == DerivativeStatus.Closed && getAssetsValue() == 0 && getWithdrawAmount() == amount) {
1128             withdrawProvider.freeze();
1129             handleWithdraw(withdrawProvider, msg.sender);
1130             withdrawProvider.finalize();
1131             return;
1132         }
1133      }
1134 
1135     function guaranteeLiquidity(uint tokenBalance) internal returns(bool success){
1136 
1137         if(getStatusStep(GETETH) == 0) {
1138             uint _totalETHToReturn = tokenBalance.mul(getPrice()).div(10**decimals);
1139             if (_totalETHToReturn <= getETHBalance()) {
1140                 return true;
1141             }
1142 
1143             // tokenPercentToSell must be freeze as class variable.
1144             // 10**18 is the highest preccision for all possible tokens
1145             freezeBalance = _totalETHToReturn.sub(getETHBalance()).mul(TOKEN_DENOMINATOR).div(getAssetsValue());
1146         }
1147         return getETHFromTokens(freezeBalance);
1148     }
1149 
1150     // solhint-disable-next-line
1151     function withdraw() external onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns(bool) {
1152         startGasCalculation();
1153 
1154         require(productStatus == Status.AVAILABLE || productStatus == Status.WITHDRAWING);
1155         productStatus = Status.WITHDRAWING;
1156 
1157         WithdrawInterface withdrawProvider = WithdrawInterface(getComponentByName(WITHDRAW));
1158 
1159         // Check if there is request
1160         address[] memory _requests = withdrawProvider.getUserRequests();
1161         uint _withdrawStatus = getStatusStep(WITHDRAW);
1162 
1163 
1164 
1165         if (_withdrawStatus == 0 && getStatusStep(GETETH) == 0) {
1166             checkLocker(WITHDRAW);
1167             if (_requests.length == 0) {
1168                 productStatus = Status.AVAILABLE;
1169                 reimburse();
1170                 return true;
1171             }
1172         }
1173 
1174         if (_withdrawStatus == 0) {
1175             if(!guaranteeLiquidity(getWithdrawAmount())) {
1176                 reimburse();
1177                 return false;
1178             }
1179             withdrawProvider.freeze();
1180         }
1181 
1182         uint _transfers = initializeOrContinueStep(WITHDRAW);
1183         uint i;
1184 
1185         for (i = _transfers; i < _requests.length && goNextStep(WITHDRAW); i++) {
1186             if(!handleWithdraw(withdrawProvider, _requests[i])){ continue; }
1187         }
1188 
1189         if (i == _requests.length) {
1190             withdrawProvider.finalize();
1191             finalizeStep(WITHDRAW);
1192             productStatus = Status.AVAILABLE;
1193         }
1194         reimburse();
1195         return i == _requests.length; // True if completed
1196     }
1197 
1198     function handleWithdraw(WithdrawInterface _withdrawProvider, address _investor) private returns (bool) {
1199         uint _eth;
1200         uint _tokenAmount;
1201 
1202         (_eth, _tokenAmount) = _withdrawProvider.withdraw(_investor);
1203         if (_tokenAmount == 0) {return false;}
1204 
1205         balances[_investor] =  balances[_investor].sub(_tokenAmount);
1206         emit Transfer(_investor, 0x0, _tokenAmount); // ERC20 Required event
1207 
1208         totalSupply_ = totalSupply_.sub(_tokenAmount);
1209         address(_investor).transfer(_eth);
1210 
1211         return true;
1212     }
1213 
1214     function checkLocker(bytes32 category) internal {
1215         LockerInterface(getComponentByName(LOCKER)).checkLockerByTime(category);
1216     }
1217 
1218     function startGasCalculation() internal {
1219         ReimbursableInterface(getComponentByName(REIMBURSABLE)).startGasCalculation();
1220     }
1221 
1222     // solhint-disable-next-line
1223     function reimburse() private {
1224         uint reimbursedAmount = ReimbursableInterface(getComponentByName(REIMBURSABLE)).reimburse();
1225         accumulatedFee = accumulatedFee.sub(reimbursedAmount);
1226         // emit Reimbursed(reimbursedAmount);
1227         msg.sender.transfer(reimbursedAmount);
1228     }
1229 
1230     // solhint-disable-next-line
1231     function tokensWithAmount() public view returns( ERC20Extended[] memory) {
1232         // First check the length
1233         uint length = 0;
1234         uint[] memory _amounts = new uint[](tokens.length);
1235         for (uint i = 0; i < tokens.length; i++) {
1236             _amounts[i] = ERC20Extended(tokens[i]).balanceOf(address(this));
1237             if (_amounts[i] > 0) {length++;}
1238         }
1239 
1240         ERC20Extended[] memory _tokensWithAmount = new ERC20Extended[](length);
1241         // Then create they array
1242         uint index = 0;
1243         for (uint j = 0; j < tokens.length; j++) {
1244             if (_amounts[j] > 0) {
1245                 _tokensWithAmount[index] = ERC20Extended(tokens[j]);
1246                 index++;
1247             }
1248         }
1249         return _tokensWithAmount;
1250     }
1251 
1252     // _tokenPercentage must come in TOKEN_DENOMIANTOR
1253     function getETHFromTokens(uint _tokenPercentage) internal returns(bool success) {
1254         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1255 
1256         uint currentStep = initializeOrContinueStep(GETETH);
1257         uint i; // Current step to tokens.length
1258         uint arrayLength = getNextArrayLength(GETETH, currentStep);
1259         if(currentStep == 0) {
1260             freezeTokens = tokensWithAmount();
1261         }
1262 
1263         ERC20Extended[] memory _tokensThisStep = new ERC20Extended[](arrayLength);
1264         uint[] memory _amounts = new uint[](arrayLength);
1265         uint[] memory _sellRates = new uint[](arrayLength);
1266 
1267         for(i = currentStep;i < freezeTokens.length && goNextStep(GETETH); i++){
1268             uint sellIndex = i.sub(currentStep);
1269             _tokensThisStep[sellIndex] = freezeTokens[i];
1270             _amounts[sellIndex] = _tokenPercentage.mul(freezeTokens[i].balanceOf(address(this))).div(TOKEN_DENOMINATOR);
1271             (, _sellRates[sellIndex] ) = exchange.getPrice(freezeTokens[i], ETH, _amounts[sellIndex], 0x0);
1272             approveExchange(address(_tokensThisStep[sellIndex]), _amounts[sellIndex]);
1273         }
1274         require(exchange.sellTokens(_tokensThisStep, _amounts, _sellRates, address(this), 0x0));
1275 
1276         if(i == freezeTokens.length) {
1277             finalizeStep(GETETH);
1278             return true;
1279         }
1280         return false;
1281     }
1282 
1283     // ----------------------------- REBALANCE -----------------------------
1284     // solhint-disable-next-line
1285     function buyTokens() external onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns(bool) {
1286         startGasCalculation();
1287 
1288         require(productStatus == Status.AVAILABLE || productStatus == Status.BUYING);
1289         productStatus = Status.BUYING;
1290 
1291         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1292 
1293         // Start?
1294         if (getStatusStep(BUYTOKENS) == 0) {
1295             checkLocker(BUYTOKENS);
1296             if (tokens.length == 0 || getETHBalance() == 0) {
1297                 productStatus = Status.AVAILABLE;
1298                 reimburse();
1299                 return true;
1300             }
1301             freezeBalance = getETHBalance();
1302         }
1303         uint currentStep = initializeOrContinueStep(BUYTOKENS);
1304 
1305         // Check the length of the array
1306         uint arrayLength = getNextArrayLength(BUYTOKENS, currentStep);
1307 
1308         uint[] memory _amounts = new uint[](arrayLength);
1309         // Initialize to 0, making sure any rate is fine
1310         uint[] memory _rates = new uint[](arrayLength);
1311         // Initialize to 0, making sure any rate is fine
1312         ERC20Extended[] memory _tokensErc20 = new ERC20Extended[](arrayLength);
1313         uint _totalAmount = 0;
1314         uint i; // Current step to tokens.length
1315         uint _buyIndex; // 0 to currentStepLength
1316         for (i = currentStep; i < tokens.length && goNextStep(BUYTOKENS); i++) {
1317             _buyIndex = i - currentStep;
1318             _amounts[_buyIndex] = freezeBalance.mul(weights[i]).div(100);
1319             _tokensErc20[_buyIndex] = ERC20Extended(tokens[i]);
1320             (, _rates[_buyIndex] ) = exchange.getPrice(ETH, _tokensErc20[_buyIndex], _amounts[_buyIndex], 0x0);
1321             _totalAmount = _totalAmount.add(_amounts[_buyIndex]);
1322         }
1323 
1324         require(exchange.buyTokens.value(_totalAmount)(_tokensErc20, _amounts, _rates, address(this), 0x0));
1325 
1326         if(i == tokens.length) {
1327             finalizeStep(BUYTOKENS);
1328             freezeBalance = 0;
1329             productStatus = Status.AVAILABLE;
1330             reimburse();
1331             return true;
1332         }
1333         reimburse();
1334         return false;
1335     }
1336 
1337     // solhint-disable-next-line
1338     function rebalance() public onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns (bool success) {
1339         startGasCalculation();
1340 
1341         require(productStatus == Status.AVAILABLE || productStatus == Status.REBALANCING);
1342 
1343         RebalanceInterface rebalanceProvider = RebalanceInterface(getComponentByName(REBALANCE));
1344         OlympusExchangeInterface exchangeProvider = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1345         if (!rebalanceProvider.getRebalanceInProgress()) {
1346             checkLocker(REBALANCE);
1347         }
1348 
1349         address[] memory _tokensToSell;
1350         uint[] memory _amounts;
1351         address[] memory _tokensToBuy;
1352         uint i;
1353 
1354         (_tokensToSell, _amounts, _tokensToBuy,,) = rebalanceProvider.rebalanceGetTokensToSellAndBuy(rebalanceDeltaPercentage);
1355         if(_tokensToSell.length == 0) {
1356             reimburse(); // Completed case
1357             return true;
1358         }
1359         // solhint-disable-next-line
1360         uint ETHBalanceBefore = getETHBalance();
1361 
1362         uint currentStep = initializeOrContinueStep(REBALANCE);
1363         uint stepStatus = getStatusStep(REBALANCE);
1364         // solhint-disable-next-line
1365 
1366         productStatus = Status.REBALANCING;
1367 
1368         // Sell Tokens
1369         if ( stepStatus == uint(RebalancePhases.SellTokens)) {
1370             for (i = currentStep; i < _tokensToSell.length && goNextStep(REBALANCE) ; i++) {
1371                 approveExchange(_tokensToSell[i], _amounts[i]);
1372                 // solhint-disable-next-line
1373 
1374                 require(exchangeProvider.sellToken(ERC20Extended(_tokensToSell[i]), _amounts[i], 0, address(this), 0x0));
1375             }
1376 
1377             rebalanceReceivedETHAmountFromSale = rebalanceReceivedETHAmountFromSale.add(getETHBalance()).sub(ETHBalanceBefore) ;
1378             if (i ==  _tokensToSell.length) {
1379                 updateStatusStep(REBALANCE);
1380                 currentStep = 0;
1381             }
1382         }
1383         // Buy Tokens
1384         if (stepStatus == uint(RebalancePhases.BuyTokens)) {
1385             _amounts = rebalanceProvider.recalculateTokensToBuyAfterSale(rebalanceReceivedETHAmountFromSale);
1386             for (i = currentStep; i < _tokensToBuy.length && goNextStep(REBALANCE); i++) {
1387                 require(
1388                     // solhint-disable-next-line
1389                     exchangeProvider.buyToken.value(_amounts[i])(ERC20Extended(_tokensToBuy[i]), _amounts[i], 0, address(this), 0x0)
1390                 );
1391             }
1392 
1393             if(i == _tokensToBuy.length) {
1394                 finalizeStep(REBALANCE);
1395                 rebalanceProvider.finalize();
1396                 rebalanceReceivedETHAmountFromSale = 0;
1397                 productStatus = Status.AVAILABLE;
1398                 reimburse();   // Completed case
1399                 return true;
1400             }
1401         }
1402         reimburse(); // Not complete case
1403         return false;
1404     }
1405     // ----------------------------- STEP PROVIDER -----------------------------
1406     function initializeOrContinueStep(bytes32 category) internal returns(uint) {
1407         return  StepInterface(getComponentByName(STEP)).initializeOrContinue(category);
1408     }
1409 
1410     function getStatusStep(bytes32 category) internal view returns(uint) {
1411         return  StepInterface(getComponentByName(STEP)).getStatus(category);
1412     }
1413 
1414     function finalizeStep(bytes32 category) internal returns(bool) {
1415         return  StepInterface(getComponentByName(STEP)).finalize(category);
1416     }
1417 
1418     function goNextStep(bytes32 category) internal returns(bool) {
1419         return StepInterface(getComponentByName(STEP)).goNextStep(category);
1420     }
1421 
1422     function updateStatusStep(bytes32 category) internal returns(uint) {
1423         return StepInterface(getComponentByName(STEP)).updateStatus(category);
1424     }
1425 
1426     function getWithdrawAmount() internal view returns(uint) {
1427         return WithdrawInterface(getComponentByName(WITHDRAW)).getTotalWithdrawAmount();
1428     }
1429 
1430     function getNextArrayLength(bytes32 stepCategory, uint currentStep) internal view returns(uint) {
1431         uint arrayLength = StepInterface(getComponentByName(STEP)).getMaxCalls(stepCategory);
1432         if(arrayLength.add(currentStep) >= tokens.length ) {
1433             arrayLength = tokens.length.sub(currentStep);
1434         }
1435         return arrayLength;
1436     }
1437 
1438     function approveExchange(address _token, uint amount) internal {
1439         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1440         ERC20NoReturn(_token).approve(exchange, 0);
1441         ERC20NoReturn(_token).approve(exchange, amount);
1442     }
1443 
1444     // ----------------------------- WHITELIST -----------------------------
1445     // solhint-disable-next-line
1446     function enableWhitelist(WhitelistKeys _key, bool enable) public onlyOwner returns(bool) {
1447         WhitelistInterface(getComponentByName(WHITELIST)).setStatus(uint(_key), enable);
1448         return true;
1449     }
1450 
1451     // solhint-disable-next-line
1452     function setAllowed(address[] accounts, WhitelistKeys _key, bool allowed) public onlyOwner returns(bool) {
1453         WhitelistInterface(getComponentByName(WHITELIST)).setAllowed(accounts, uint(_key), allowed);
1454         return true;
1455     }
1456 }