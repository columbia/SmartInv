1 pragma solidity 0.4.24;
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
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 contract ERC20Extended is ERC20 {
35     uint256 public decimals;
36     string public name;
37     string public symbol;
38 
39 }
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipRenounced(address indexed previousOwner);
51   event OwnershipTransferred(
52     address indexed previousOwner,
53     address indexed newOwner
54   );
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   constructor() public {
62     owner = msg.sender;
63   }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to relinquish control of the contract.
75    */
76   function renounceOwnership() public onlyOwner {
77     emit OwnershipRenounced(owner);
78     owner = address(0);
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param _newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address _newOwner) public onlyOwner {
86     _transferOwnership(_newOwner);
87   }
88 
89   /**
90    * @dev Transfers control of the contract to a newOwner.
91    * @param _newOwner The address to transfer ownership to.
92    */
93   function _transferOwnership(address _newOwner) internal {
94     require(_newOwner != address(0));
95     emit OwnershipTransferred(owner, _newOwner);
96     owner = _newOwner;
97   }
98 }
99 
100 contract ComponentContainerInterface {
101     mapping (string => address) components;
102 
103     event ComponentUpdated (string _name, address _componentAddress);
104 
105     function setComponent(string _name, address _providerAddress) internal returns (bool success);
106     function getComponentByName(string name) public view returns (address);
107 
108 }
109 
110 contract DerivativeInterface is ERC20Extended, Ownable, ComponentContainerInterface {
111 
112     enum DerivativeStatus { New, Active, Paused, Closed }
113     enum DerivativeType { Index, Fund }
114 
115     string public description;
116     string public category;
117     string public version;
118     DerivativeType public fundType;
119 
120     address[] public tokens;
121     DerivativeStatus public status;
122 
123     // invest, withdraw is done in transfer.
124     function invest() public payable returns(bool success);
125     function changeStatus(DerivativeStatus _status) public returns(bool);
126     function getPrice() public view returns(uint);
127 
128     function initialize (address _componentList) internal;
129     function updateComponent(string _name) public returns (address);
130     function approveComponent(string _name) internal;
131 }
132 
133 contract ComponentContainer is ComponentContainerInterface {
134 
135     function setComponent(string _name, address _componentAddress) internal returns (bool success) {
136         require(_componentAddress != address(0));
137         components[_name] = _componentAddress;
138         return true;
139     }
140 
141     function getComponentByName(string _name) public view returns (address) {
142         return components[_name];
143     }
144 }
145 
146 /**
147  * @title SafeMath
148  * @dev Math operations with safety checks that throw on error
149  */
150 library SafeMath {
151 
152   /**
153   * @dev Multiplies two numbers, throws on overflow.
154   */
155   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
156     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
157     // benefit is lost if 'b' is also tested.
158     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
159     if (a == 0) {
160       return 0;
161     }
162 
163     c = a * b;
164     assert(c / a == b);
165     return c;
166   }
167 
168   /**
169   * @dev Integer division of two numbers, truncating the quotient.
170   */
171   function div(uint256 a, uint256 b) internal pure returns (uint256) {
172     // assert(b > 0); // Solidity automatically throws when dividing by 0
173     // uint256 c = a / b;
174     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175     return a / b;
176   }
177 
178   /**
179   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
180   */
181   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
182     assert(b <= a);
183     return a - b;
184   }
185 
186   /**
187   * @dev Adds two numbers, throws on overflow.
188   */
189   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
190     c = a + b;
191     assert(c >= a);
192     return c;
193   }
194 }
195 
196 /**
197  * @title Basic token
198  * @dev Basic version of StandardToken, with no allowances.
199  */
200 contract BasicToken is ERC20Basic {
201   using SafeMath for uint256;
202 
203   mapping(address => uint256) balances;
204 
205   uint256 totalSupply_;
206 
207   /**
208   * @dev total number of tokens in existence
209   */
210   function totalSupply() public view returns (uint256) {
211     return totalSupply_;
212   }
213 
214   /**
215   * @dev transfer token for a specified address
216   * @param _to The address to transfer to.
217   * @param _value The amount to be transferred.
218   */
219   function transfer(address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[msg.sender]);
222 
223     balances[msg.sender] = balances[msg.sender].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     emit Transfer(msg.sender, _to, _value);
226     return true;
227   }
228 
229   /**
230   * @dev Gets the balance of the specified address.
231   * @param _owner The address to query the the balance of.
232   * @return An uint256 representing the amount owned by the passed address.
233   */
234   function balanceOf(address _owner) public view returns (uint256) {
235     return balances[_owner];
236   }
237 
238 }
239 
240 /**
241  * @title Standard ERC20 token
242  *
243  * @dev Implementation of the basic standard token.
244  * @dev https://github.com/ethereum/EIPs/issues/20
245  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
246  */
247 contract StandardToken is ERC20, BasicToken {
248 
249   mapping (address => mapping (address => uint256)) internal allowed;
250 
251 
252   /**
253    * @dev Transfer tokens from one address to another
254    * @param _from address The address which you want to send tokens from
255    * @param _to address The address which you want to transfer to
256    * @param _value uint256 the amount of tokens to be transferred
257    */
258   function transferFrom(
259     address _from,
260     address _to,
261     uint256 _value
262   )
263     public
264     returns (bool)
265   {
266     require(_to != address(0));
267     require(_value <= balances[_from]);
268     require(_value <= allowed[_from][msg.sender]);
269 
270     balances[_from] = balances[_from].sub(_value);
271     balances[_to] = balances[_to].add(_value);
272     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
273     emit Transfer(_from, _to, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
279    *
280    * Beware that changing an allowance with this method brings the risk that someone may use both the old
281    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
282    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
283    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
284    * @param _spender The address which will spend the funds.
285    * @param _value The amount of tokens to be spent.
286    */
287   function approve(address _spender, uint256 _value) public returns (bool) {
288     allowed[msg.sender][_spender] = _value;
289     emit Approval(msg.sender, _spender, _value);
290     return true;
291   }
292 
293   /**
294    * @dev Function to check the amount of tokens that an owner allowed to a spender.
295    * @param _owner address The address which owns the funds.
296    * @param _spender address The address which will spend the funds.
297    * @return A uint256 specifying the amount of tokens still available for the spender.
298    */
299   function allowance(
300     address _owner,
301     address _spender
302    )
303     public
304     view
305     returns (uint256)
306   {
307     return allowed[_owner][_spender];
308   }
309 
310   /**
311    * @dev Increase the amount of tokens that an owner allowed to a spender.
312    *
313    * approve should be called when allowed[_spender] == 0. To increment
314    * allowed value is better to use this function to avoid 2 calls (and wait until
315    * the first transaction is mined)
316    * From MonolithDAO Token.sol
317    * @param _spender The address which will spend the funds.
318    * @param _addedValue The amount of tokens to increase the allowance by.
319    */
320   function increaseApproval(
321     address _spender,
322     uint _addedValue
323   )
324     public
325     returns (bool)
326   {
327     allowed[msg.sender][_spender] = (
328       allowed[msg.sender][_spender].add(_addedValue));
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333   /**
334    * @dev Decrease the amount of tokens that an owner allowed to a spender.
335    *
336    * approve should be called when allowed[_spender] == 0. To decrement
337    * allowed value is better to use this function to avoid 2 calls (and wait until
338    * the first transaction is mined)
339    * From MonolithDAO Token.sol
340    * @param _spender The address which will spend the funds.
341    * @param _subtractedValue The amount of tokens to decrease the allowance by.
342    */
343   function decreaseApproval(
344     address _spender,
345     uint _subtractedValue
346   )
347     public
348     returns (bool)
349   {
350     uint oldValue = allowed[msg.sender][_spender];
351     if (_subtractedValue > oldValue) {
352       allowed[msg.sender][_spender] = 0;
353     } else {
354       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
355     }
356     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
357     return true;
358   }
359 
360 }
361 
362 /**
363  * @title Pausable
364  * @dev Base contract which allows children to implement an emergency stop mechanism.
365  */
366 contract Pausable is Ownable {
367   event Pause();
368   event Unpause();
369 
370   bool public paused = false;
371 
372 
373   /**
374    * @dev Modifier to make a function callable only when the contract is not paused.
375    */
376   modifier whenNotPaused() {
377     require(!paused);
378     _;
379   }
380 
381   /**
382    * @dev Modifier to make a function callable only when the contract is paused.
383    */
384   modifier whenPaused() {
385     require(paused);
386     _;
387   }
388 
389   /**
390    * @dev called by the owner to pause, triggers stopped state
391    */
392   function pause() onlyOwner whenNotPaused public {
393     paused = true;
394     emit Pause();
395   }
396 
397   /**
398    * @dev called by the owner to unpause, returns to normal state
399    */
400   function unpause() onlyOwner whenPaused public {
401     paused = false;
402     emit Unpause();
403   }
404 }
405 
406 /**
407  * @title Pausable token
408  * @dev StandardToken modified with pausable transfers.
409  **/
410 contract PausableToken is StandardToken, Pausable {
411 
412   function transfer(
413     address _to,
414     uint256 _value
415   )
416     public
417     whenNotPaused
418     returns (bool)
419   {
420     return super.transfer(_to, _value);
421   }
422 
423   function transferFrom(
424     address _from,
425     address _to,
426     uint256 _value
427   )
428     public
429     whenNotPaused
430     returns (bool)
431   {
432     return super.transferFrom(_from, _to, _value);
433   }
434 
435   function approve(
436     address _spender,
437     uint256 _value
438   )
439     public
440     whenNotPaused
441     returns (bool)
442   {
443     return super.approve(_spender, _value);
444   }
445 
446   function increaseApproval(
447     address _spender,
448     uint _addedValue
449   )
450     public
451     whenNotPaused
452     returns (bool success)
453   {
454     return super.increaseApproval(_spender, _addedValue);
455   }
456 
457   function decreaseApproval(
458     address _spender,
459     uint _subtractedValue
460   )
461     public
462     whenNotPaused
463     returns (bool success)
464   {
465     return super.decreaseApproval(_spender, _subtractedValue);
466   }
467 }
468 
469 contract ComponentListInterface {
470     event ComponentUpdated (string _name, string _version, address _componentAddress);
471     function setComponent(string _name, address _componentAddress) public returns (bool);
472     function getComponent(string _name, string _version) public view returns (address);
473     function getLatestComponent(string _name) public view returns(address);
474 }
475 
476 contract ERC20NoReturn {
477     uint256 public decimals;
478     string public name;
479     string public symbol;
480     function totalSupply() public view returns (uint);
481     function balanceOf(address tokenOwner) public view returns (uint balance);
482     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
483     function transfer(address to, uint tokens) public;
484     function approve(address spender, uint tokens) public;
485     function transferFrom(address from, address to, uint tokens) public;
486 
487     event Transfer(address indexed from, address indexed to, uint tokens);
488     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
489 }
490 
491 contract FeeChargerInterface {
492     // TODO: change this to mainnet MOT address before deployment.
493     // solhint-disable-next-line
494     ERC20Extended public MOT = ERC20Extended(0x263c618480DBe35C300D8d5EcDA19bbB986AcaeD);
495     // kovan MOT: 0x41Dee9F481a1d2AA74a3f1d0958C1dB6107c686A
496     function setMotAddress(address _motAddress) external returns (bool success);
497 }
498 
499 // Abstract class that implements the common functions to all our derivatives
500 contract Derivative is DerivativeInterface, ComponentContainer, PausableToken {
501 
502     ERC20Extended internal constant ETH = ERC20Extended(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
503     ComponentListInterface internal componentList;
504     string public constant MARKET = "MarketProvider";
505     string public constant EXCHANGE = "ExchangeProvider";
506     string public constant WITHDRAW = "WithdrawProvider";
507     string public constant RISK = "RiskProvider";
508     string public constant WHITELIST = "WhitelistProvider";
509     string public constant FEE = "FeeProvider";
510     string public constant REIMBURSABLE = "Reimbursable";
511     string public constant REBALANCE = "RebalanceProvider";
512 
513     function initialize (address _componentList) internal {
514         require(_componentList != 0x0);
515         componentList = ComponentListInterface(_componentList);
516     }
517 
518     function updateComponent(string _name) public onlyOwner returns (address) {
519         // still latest.
520         if (super.getComponentByName(_name) == componentList.getLatestComponent(_name)) {
521             return super.getComponentByName(_name);
522         }
523 
524         // changed.
525         require(super.setComponent(_name, componentList.getLatestComponent(_name)));
526         // approve if it's not Marketplace.
527         if (keccak256(abi.encodePacked(_name)) != keccak256(abi.encodePacked(MARKET))) {
528             approveComponent(_name);
529         }
530 
531         // return latest address.
532         return componentList.getLatestComponent(_name);
533     }
534 
535 
536 
537     function approveComponent(string _name) internal {
538         address componentAddress = getComponentByName(_name);
539         ERC20NoReturn(FeeChargerInterface(componentAddress).MOT()).approve(componentAddress, 0);
540         ERC20NoReturn(FeeChargerInterface(componentAddress).MOT()).approve(componentAddress, 2 ** 256 - 1);
541     }
542 
543     function () public payable {
544 
545     }
546 }
547 
548 contract IndexInterface is DerivativeInterface {
549     uint[] public weights;
550     bool public supportRebalance;
551 
552     // this should be called until it returns true.
553     function rebalance() public returns (bool success);
554     function getTokens() public view returns (address[] _tokens, uint[] _weights);
555 }
556 
557 contract ComponentInterface {
558     string public name;
559     string public description;
560     string public category;
561     string public version;
562 }
563 
564 contract ExchangeInterface is ComponentInterface {
565     /*
566      * @dev Checks if a trading pair is available
567      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
568      * @param address _sourceAddress The token to sell for the destAddress.
569      * @param address _destAddress The token to buy with the source token.
570      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
571      * @return boolean whether or not the trading pair is supported by this exchange provider
572      */
573     function supportsTradingPair(address _srcAddress, address _destAddress, bytes32 _exchangeId)
574         external view returns(bool supported);
575 
576     /*
577      * @dev Buy a single token with ETH.
578      * @param ERC20Extended _token The token to buy, should be an ERC20Extended address.
579      * @param uint _amount Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the _amount.
580      * @param uint _minimumRate The minimum amount of tokens to receive for 1 ETH.
581      * @param address _depositAddress The address to send the bought tokens to.
582      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
583      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here.
584      * @return boolean whether or not the trade succeeded.
585      */
586     function buyToken
587         (
588         ERC20Extended _token, uint _amount, uint _minimumRate,
589         address _depositAddress, bytes32 _exchangeId, address _partnerId
590         ) external payable returns(bool success);
591 
592     /*
593      * @dev Sell a single token for ETH. Make sure the token is approved beforehand.
594      * @param ERC20Extended _token The token to sell, should be an ERC20Extended address.
595      * @param uint _amount Amount of tokens to sell.
596      * @param uint _minimumRate The minimum amount of ETH to receive for 1 ERC20Extended token.
597      * @param address _depositAddress The address to send the bought tokens to.
598      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
599      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here
600      * @return boolean boolean whether or not the trade succeeded.
601      */
602     function sellToken
603         (
604         ERC20Extended _token, uint _amount, uint _minimumRate,
605         address _depositAddress, bytes32 _exchangeId, address _partnerId
606         ) external returns(bool success);
607 }
608 
609 contract PriceProviderInterface is ComponentInterface {
610     /*
611      * @dev Returns the expected price for 1 of sourceAddress.
612      * For ETH, use 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
613      * @param address _sourceAddress The token to sell for the destAddress.
614      * @param address _destAddress The token to buy with the source token.
615      * @param uint _amount The amount of tokens which is wanted to buy.
616      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
617      * @return returns the expected and slippage rate for the specified conversion
618      */
619     function getPrice(ERC20Extended _sourceAddress, ERC20Extended _destAddress, uint _amount, bytes32 _exchangeId)
620         external view returns(uint expectedRate, uint slippageRate);
621 }
622 
623 contract OlympusExchangeInterface is ExchangeInterface, PriceProviderInterface, Ownable {
624     /*
625      * @dev Buy multiple tokens at once with ETH.
626      * @param ERC20Extended[] _tokens The tokens to buy, should be an array of ERC20Extended addresses.
627      * @param uint[] _amounts Amount of ETH used to buy this token. Make sure the value sent to this function is the same as the sum of this array.
628      * @param uint[] _minimumRates The minimum amount of tokens to receive for 1 ETH.
629      * @param address _depositAddress The address to send the bought tokens to.
630      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
631      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here
632      * @return boolean boolean whether or not the trade succeeded.
633      */
634     function buyTokens
635         (
636         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
637         address _depositAddress, bytes32 _exchangeId, address _partnerId
638         ) external payable returns(bool success);
639 
640     /*
641      * @dev Sell multiple tokens at once with ETH, make sure all of the tokens are approved to be transferred beforehand with the Olympus Exchange address.
642      * @param ERC20Extended[] _tokens The tokens to sell, should be an array of ERC20Extended addresses.
643      * @param uint[] _amounts Amount of tokens to sell this token. Make sure the value sent to this function is the same as the sum of this array.
644      * @param uint[] _minimumRates The minimum amount of ETH to receive for 1 specified ERC20Extended token.
645      * @param address _depositAddress The address to send the bought tokens to.
646      * @param bytes32 _exchangeId The exchangeId to choose. If it's an empty string, then the exchange will be chosen automatically.
647      * @param address _partnerId If the exchange supports a partnerId, you can supply your partnerId here
648      * @return boolean boolean whether or not the trade succeeded.
649      */
650     function sellTokens
651         (
652         ERC20Extended[] _tokens, uint[] _amounts, uint[] _minimumRates,
653         address _depositAddress, bytes32 _exchangeId, address _partnerId
654         ) external returns(bool success);
655 }
656 
657 contract RebalanceInterface is ComponentInterface {
658     // this should be called until it returns true.
659     function recalculateTokensToBuyAfterSale(uint _receivedETHFromSale, uint[] _amountsToBuy) external pure
660         returns(uint[] _recalculatedAmountsToBuy);
661     function rebalanceGetTokensToSellAndBuy() external returns
662         (address[] _tokensToSell, uint[] _amountsToSell, address[] _tokensToBuy, uint[] _amountsToBuy, address[] _tokensWithPriceIssues);
663 }
664 
665 contract WithdrawInterface is ComponentInterface {
666 
667     function request(address _requester, uint amount) external returns(bool);
668     function withdraw(address _requester) external returns(uint eth, uint tokens);
669     function start() external;
670     function isInProgress() external view returns(bool);
671     function unlock() external;
672     function getUserRequests() external view returns(address[]);
673     function getTotalWithdrawAmount() external view returns(uint);
674 
675     event WithdrawRequest(address _requester, uint amountOfToken);
676     event Withdrawed(address _requester,  uint amountOfToken , uint amountOfEther);
677 }
678 
679 contract WhitelistInterface is ComponentInterface {
680 
681     // sender -> category -> user -> allowed
682     mapping (address => mapping(uint8 => mapping(address => bool))) public whitelist;
683     // sender -> category -> enabled
684     mapping (address => mapping(uint8 => bool)) public enabled;
685 
686     function enable(uint8 _key) external;
687     function disable(uint8 _key) external;
688     function isAllowed(uint8 _key, address _account) external view returns(bool);
689     function setAllowed(address[] accounts, uint8 _key, bool allowed) external returns(bool);
690 }
691 
692 contract MarketplaceInterface is Ownable {
693 
694     address[] public products;
695     mapping(address => address[]) public productMappings;
696 
697     function getAllProducts() external view returns (address[] allProducts);
698     function registerProduct() external returns(bool success);
699     function getOwnProducts() external view returns (address[] addresses);
700 
701     event Registered(address product, address owner);
702 }
703 
704 contract ChargeableInterface is ComponentInterface {
705 
706     uint public DENOMINATOR;
707     function calculateFee(address _caller, uint _amount) external returns(uint totalFeeAmount);
708     function setFeePercentage(uint _fee) external returns (bool succes);
709     function getFeePercentage() external view returns (uint feePercentage);
710 
711  }
712 
713 contract ReimbursableInterface is ComponentInterface {
714 
715     // this should be called at the beginning of a function.
716     // such as rebalance and withdraw.
717     function startGasCalculation() external;
718     // this should be called at the last moment of the function.
719     function reimburse() external returns (uint);
720 
721 }
722 
723 contract RiskControlInterface is ComponentInterface {
724     function hasRisk(address _sender, address _receiver, address _tokenAddress, uint _amount, uint _rate)
725         external returns(bool isRisky);
726 }
727 
728 contract OlympusIndex is IndexInterface, Derivative {
729     using SafeMath for uint256;
730 
731     enum WhitelistKeys { Investment, Maintenance }
732 
733     event ChangeStatus(DerivativeStatus status);
734     event Invested(address user, uint amount);
735     event Reimbursed(uint amount);
736     event  RiskEvent(address _sender, address _receiver, address _tokenAddress, uint _amount, uint _rate, bool risky);
737 
738     uint public constant DENOMINATOR = 100000;
739     uint public constant INITIAL_VALUE =  10**18;
740     uint[] public weights;
741     uint public accumulatedFee = 0;
742     uint public maxTransfers = 10;
743 
744     // If whitelist is disabled, that will become onlyOwner
745     modifier onlyOwnerOrWhitelisted(WhitelistKeys _key) {
746         WhitelistInterface whitelist = WhitelistInterface(getComponentByName(WHITELIST));
747         require(
748             msg.sender == owner ||
749             (whitelist.enabled(address(this), uint8(_key)) && whitelist.isAllowed(uint8(_key), msg.sender) )
750         );
751         _;
752     }
753 
754     // If whitelist is disabled, anyone can do this
755     modifier whitelisted(WhitelistKeys _key) {
756         require(WhitelistInterface(getComponentByName(WHITELIST)).isAllowed(uint8(_key), msg.sender));
757         _;
758     }
759 
760     modifier withoutRisk(address _sender, address _receiver, address _tokenAddress, uint _amount, uint _rate) {
761         require(!hasRisk(_sender, _receiver, _tokenAddress, _amount, _rate));
762         _;
763     }
764 
765     modifier checkLength(address[] _tokens, uint[] _weights) {
766         require(_tokens.length == _weights.length);
767         _;
768     }
769 
770     modifier checkWeights(uint[] _weights){
771         uint totalWeight;
772         for(uint i = 0; i < _weights.length; i++){
773             totalWeight += _weights[i];
774         }
775         require(totalWeight == 100);
776         _;
777     }
778 
779     constructor (
780       string _name,
781       string _symbol,
782       string _description,
783       string _category,
784       uint _decimals,
785       address[] _tokens,
786       uint[] _weights)
787       checkLength(_tokens, _weights) checkWeights(_weights) public {
788         name = _name;
789         symbol = _symbol;
790         totalSupply_ = 0;
791         decimals = _decimals;
792         description = _description;
793         category = _category;
794         version = "1.0";
795         fundType = DerivativeType.Index;
796         tokens = _tokens;
797         weights = _weights;
798         status = DerivativeStatus.New;
799     }
800 
801     // ----------------------------- CONFIG -----------------------------
802     function initialize(address _componentList, uint _initialFundFee) onlyOwner external payable {
803         require(status == DerivativeStatus.New);
804         require(msg.value > 0); // Require some balance for internal opeations as reimbursable
805         require(_componentList != 0x0);
806 
807         super.initialize(_componentList);
808 
809         setComponent(MARKET, componentList.getLatestComponent(MARKET));
810         setComponent(EXCHANGE, componentList.getLatestComponent(EXCHANGE));
811         setComponent(REBALANCE, componentList.getLatestComponent(REBALANCE));
812         setComponent(RISK, componentList.getLatestComponent(RISK));
813         setComponent(WHITELIST, componentList.getLatestComponent(WHITELIST));
814         setComponent(FEE, componentList.getLatestComponent(FEE));
815         setComponent(REIMBURSABLE, componentList.getLatestComponent(REIMBURSABLE));
816         setComponent(WITHDRAW, componentList.getLatestComponent(WITHDRAW));
817 
818         // approve component for charging fees.
819         approveComponents();
820 
821         MarketplaceInterface(componentList.getLatestComponent(MARKET)).registerProduct();
822         ChargeableInterface(componentList.getLatestComponent(FEE)).setFeePercentage(_initialFundFee);
823 
824         status = DerivativeStatus.Active;
825 
826         emit ChangeStatus(status);
827 
828         accumulatedFee += msg.value;
829     }
830 
831     // Call after you have updated the MARKET provider, not required after initialize
832     function registerInNewMarketplace() external onlyOwner returns(bool) {
833         require(MarketplaceInterface(getComponentByName(MARKET)).registerProduct());
834         return true;
835     }
836 
837     // Return tokens and weights
838     function getTokens() public view returns (address[] _tokens, uint[] _weights) {
839         return (tokens, weights);
840     }
841     // Return tokens and amounts
842     function getTokensAndAmounts() external view returns(address[], uint[]) {
843         uint[] memory _amounts = new uint[](tokens.length);
844         for (uint i = 0; i < tokens.length; i++) {
845             _amounts[i] = ERC20Extended(tokens[i]).balanceOf(address(this));
846         }
847         return (tokens, _amounts);
848     }
849 
850     function changeStatus(DerivativeStatus _status) public onlyOwner returns(bool) {
851         require(_status != DerivativeStatus.New && status != DerivativeStatus.New && _status != DerivativeStatus.Closed);
852         require(status != DerivativeStatus.Closed && _status != DerivativeStatus.Closed);
853 
854         status = _status;
855         emit ChangeStatus(status);
856         return true;
857     }
858 
859     function close() public onlyOwner returns(bool success){
860         require(status != DerivativeStatus.New);
861         getETHFromTokens(DENOMINATOR); // 100% all the tokens
862         status = DerivativeStatus.Closed;
863         emit ChangeStatus(status);
864         return true;
865     }
866 
867     // ----------------------------- DERIVATIVE -----------------------------
868 
869     function invest() public payable
870      whenNotPaused
871      whitelisted(WhitelistKeys.Investment)
872      withoutRisk(msg.sender, address(this), ETH, msg.value, 1)
873      returns(bool) {
874         require(status == DerivativeStatus.Active, "The Fund is not active");
875         require(msg.value >= 10**15, "Minimum value to invest is 0.001 ETH");
876          // Current value is already added in the balance, reduce it
877         uint _sharePrice;
878 
879         if(totalSupply_ > 0) {
880             _sharePrice = getPrice() - ( (msg.value * 10 ** decimals ) / totalSupply_);
881          } else {
882             _sharePrice = INITIAL_VALUE;
883         }
884 
885         ChargeableInterface feeManager = ChargeableInterface(getComponentByName(FEE));
886         uint fee = feeManager.calculateFee(msg.sender, msg.value);
887 
888         uint _investorShare = ( ( (msg.value-fee) * DENOMINATOR) / _sharePrice) * 10 ** decimals;
889         _investorShare = _investorShare / DENOMINATOR;
890 
891         accumulatedFee += fee;
892         balances[msg.sender] += _investorShare;
893         totalSupply_ += _investorShare;
894 
895         emit Invested(msg.sender, _investorShare);
896         return true;
897     }
898 
899     function getPrice() public view returns(uint)  {
900         if(totalSupply_ == 0) {
901             return INITIAL_VALUE;
902         }
903 
904         // Total Value in ETH among its tokens + ETH new added value
905         return (
906           ((getAssetsValue() + getETHBalance() ) * 10 ** decimals ) / (totalSupply_),
907         );
908     }
909 
910     function getETHBalance() public view returns(uint){
911         return address(this).balance - accumulatedFee;
912     }
913 
914     function getAssetsValue() public view returns (uint) {
915         // TODO cast to OlympusExchangeInterface
916         OlympusExchangeInterface exchangeProvider = OlympusExchangeInterface(getComponentByName(EXCHANGE));
917         uint _totalTokensValue = 0;
918         // Iterator
919         uint _expectedRate;
920         uint _balance;
921 
922         for (uint16 i = 0; i < tokens.length; i++) {
923 
924             _balance = ERC20(tokens[i]).balanceOf(address(this));
925 
926             if(_balance == 0){continue;}
927 
928             (_expectedRate, ) = exchangeProvider.getPrice(ETH, ERC20Extended(tokens[i]), _balance, 0x0);
929 
930             if(_expectedRate == 0){continue;}
931             _totalTokensValue += (_balance * 10**18) / _expectedRate;
932 
933         }
934         return _totalTokensValue;
935     }
936 
937     // ----------------------------- FEES  -----------------------------
938     // Owner can send ETH to the Index, to perform some task, this eth belongs to him
939     function addOwnerBalance() external payable onlyOwner {
940         accumulatedFee += msg.value;
941     }
942 
943     function withdrawFee(uint amount) external onlyOwner whenNotPaused returns(bool) {
944         require(accumulatedFee >= amount);
945         accumulatedFee -= amount;
946         msg.sender.transfer(amount);
947         return true;
948     }
949 
950     function setManagementFee(uint _fee) external onlyOwner {
951         ChargeableInterface(getComponentByName(FEE)).setFeePercentage(_fee);
952     }
953 
954     function getManagementFee() external view returns(uint) {
955         return ChargeableInterface(getComponentByName(FEE)).getFeePercentage();
956     }
957 
958     // ----------------------------- WITHDRAW -----------------------------
959     function requestWithdraw(uint amount) external
960      whitelisted(WhitelistKeys.Investment)
961      withoutRisk(msg.sender, address(this), address(this), amount, getPrice())
962     {
963         WithdrawInterface(getComponentByName(WITHDRAW)).request(msg.sender, amount);
964     }
965 
966     function setMaxTransfers(uint _maxTransfers) external onlyOwner {
967         maxTransfers = _maxTransfers;
968     }
969 
970     function withdraw() external onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns(bool) {
971 
972         ReimbursableInterface(getComponentByName(REIMBURSABLE)).startGasCalculation();
973         WithdrawInterface withdrawProvider = WithdrawInterface(getComponentByName(WITHDRAW));
974         // Check if there is request
975         address[] memory _requests = withdrawProvider.getUserRequests();
976         if(_requests.length == 0) {
977             reimburse();
978             return true;
979         }
980 
981         uint _transfers = 0;
982         uint _eth;
983         uint tokens;
984 
985         if (!withdrawProvider.isInProgress()) {
986             withdrawProvider.start();
987         }
988         uint _totalETHToReturn = ( withdrawProvider.getTotalWithdrawAmount() * getPrice()) / 10 ** decimals;
989 
990         if(_totalETHToReturn > getETHBalance()) {
991             uint _tokenPercentToSell = (( _totalETHToReturn - getETHBalance()) * DENOMINATOR) / getAssetsValue();
992             getETHFromTokens(_tokenPercentToSell);
993         }
994 
995         for(uint8 i = 0; i < _requests.length && _transfers < maxTransfers ; i++) {
996 
997 
998             (_eth, tokens) = withdrawProvider.withdraw(_requests[i]);
999             if(tokens == 0) {continue;}
1000 
1001             balances[_requests[i]] -= tokens;
1002             totalSupply_ -= tokens;
1003             address(_requests[i]).transfer(_eth);
1004             _transfers++;
1005         }
1006 
1007         if(!withdrawProvider.isInProgress()) {
1008             withdrawProvider.unlock();
1009         }
1010         reimburse();
1011         return !withdrawProvider.isInProgress(); // True if completed
1012     }
1013 
1014     function withdrawInProgress() external view returns(bool) {
1015         return  WithdrawInterface(getComponentByName(WITHDRAW)).isInProgress();
1016     }
1017 
1018     function reimburse() internal {
1019         uint reimbursedAmount = ReimbursableInterface(getComponentByName(REIMBURSABLE)).reimburse();
1020         accumulatedFee -= reimbursedAmount;
1021         emit Reimbursed(reimbursedAmount);
1022         msg.sender.transfer(reimbursedAmount);
1023     }
1024 
1025     function tokensWithAmount() public view returns( ERC20Extended[] memory) {
1026         // First check the length
1027         uint8 length = 0;
1028         uint[] memory _amounts = new uint[](tokens.length);
1029         for (uint8 i = 0; i < tokens.length; i++) {
1030             _amounts[i] = ERC20Extended(tokens[i]).balanceOf(address(this));
1031             if(_amounts[i] > 0) {length++;}
1032         }
1033 
1034         ERC20Extended[] memory _tokensWithAmount = new ERC20Extended[](length);
1035         // Then create they array
1036         uint8 index = 0;
1037         for (uint8 j = 0; j < tokens.length; j++) {
1038             if(_amounts[j] > 0) {
1039                 _tokensWithAmount[index] = ERC20Extended(tokens[j]);
1040                 index++;
1041             }
1042         }
1043         return _tokensWithAmount;
1044     }
1045 
1046     function getETHFromTokens(uint _tokenPercentage ) internal {
1047         ERC20Extended[] memory _tokensToSell = tokensWithAmount();
1048         uint[] memory _amounts = new uint[](  _tokensToSell.length);
1049         uint[] memory _sellRates = new uint[]( _tokensToSell.length);
1050         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1051 
1052         for (uint8 i = 0; i < _tokensToSell.length; i++) {
1053 
1054             _amounts[i] = (_tokenPercentage * _tokensToSell[i].balanceOf(address(this)) )/DENOMINATOR;
1055             ( , _sellRates[i] ) = exchange.getPrice(_tokensToSell[i], ETH, _amounts[i], 0x0);
1056             require(!hasRisk(address(this), exchange, address( _tokensToSell[i]), _amounts[i] , 0));
1057             _tokensToSell[i].approve(exchange,  0);
1058             _tokensToSell[i].approve(exchange,  _amounts[i]);
1059         }
1060         require(exchange.sellTokens(_tokensToSell, _amounts, _sellRates, address(this), 0x0, 0x0));
1061 
1062     }
1063 
1064     // ----------------------------- REBALANCE -----------------------------
1065 
1066     function buyTokens() external onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns(bool) {
1067 
1068         ReimbursableInterface(getComponentByName(REIMBURSABLE)).startGasCalculation();
1069         OlympusExchangeInterface exchange = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1070 
1071 
1072         if(getETHBalance() == 0) {
1073             reimburse();
1074             return true;
1075         }
1076         uint[] memory _amounts = new uint[](tokens.length);
1077         uint[] memory _rates = new uint[](tokens.length); // Initialize to 0, making sure any rate is fine
1078         ERC20Extended[] memory _tokensErc20 = new ERC20Extended[](tokens.length); // Initialize to 0, making sure any rate is fine
1079         uint ethBalance = getETHBalance();
1080         uint totalAmount = 0;
1081 
1082         for(uint8 i = 0; i < tokens.length; i++) {
1083             _amounts[i] = ethBalance * weights[i] / 100;
1084             _tokensErc20[i] = ERC20Extended(tokens[i]);
1085             (, _rates[i] ) = exchange.getPrice(ETH,  _tokensErc20[i],  _amounts[i], 0x0);
1086             totalAmount += _amounts[i];
1087         }
1088 
1089         require(exchange.buyTokens.value(totalAmount)(_tokensErc20, _amounts, _rates, address(this), 0x0, 0x0));
1090 
1091         reimburse();
1092         return true;
1093     }
1094 
1095     function rebalance() public onlyOwnerOrWhitelisted(WhitelistKeys.Maintenance) whenNotPaused returns (bool success) {
1096         ReimbursableInterface(getComponentByName(REIMBURSABLE)).startGasCalculation();
1097         RebalanceInterface rebalanceProvider = RebalanceInterface(getComponentByName(REBALANCE));
1098         OlympusExchangeInterface exchangeProvider = OlympusExchangeInterface(getComponentByName(EXCHANGE));
1099         address[] memory tokensToSell;
1100         uint[] memory amountsToSell;
1101         address[] memory tokensToBuy;
1102         uint[] memory amountsToBuy;
1103         uint8 i;
1104         uint ETHBalanceBefore = address(this).balance;
1105 
1106         (tokensToSell, amountsToSell, tokensToBuy, amountsToBuy,) = rebalanceProvider.rebalanceGetTokensToSellAndBuy();
1107         // Sell Tokens
1108         for (i = 0; i < tokensToSell.length; i++) {
1109             ERC20Extended(tokensToSell[i]).approve(address(exchangeProvider), 0);
1110             ERC20Extended(tokensToSell[i]).approve(address(exchangeProvider), amountsToSell[i]);
1111             require(exchangeProvider.sellToken(ERC20Extended(tokensToSell[i]), amountsToSell[i], 0, address(this), 0x0, 0x0));
1112 
1113         }
1114 
1115         // Buy Tokens
1116         amountsToBuy = rebalanceProvider.recalculateTokensToBuyAfterSale(address(this).balance - ETHBalanceBefore, amountsToBuy);
1117         for (i = 0; i < tokensToBuy.length; i++) {
1118             require(
1119                 exchangeProvider.buyToken.value(amountsToBuy[i])(ERC20Extended(tokensToBuy[i]), amountsToBuy[i], 0, address(this), 0x0, 0x0)
1120             );
1121         }
1122 
1123         reimburse();
1124         return true;
1125     }
1126 
1127     // ----------------------------- WHITELIST -----------------------------
1128 
1129     function enableWhitelist(WhitelistKeys _key) external onlyOwner returns(bool) {
1130         WhitelistInterface(getComponentByName(WHITELIST)).enable(uint8(_key));
1131         return true;
1132     }
1133 
1134     function disableWhitelist(WhitelistKeys _key) external onlyOwner returns(bool) {
1135         WhitelistInterface(getComponentByName(WHITELIST)).disable(uint8(_key));
1136         return true;
1137     }
1138 
1139     function setAllowed(address[] accounts, WhitelistKeys _key,  bool allowed) onlyOwner public returns(bool){
1140         WhitelistInterface(getComponentByName(WHITELIST)).setAllowed(accounts,uint8(_key), allowed);
1141         return true;
1142     }
1143 
1144     function approveComponents() private {
1145         approveComponent(EXCHANGE);
1146         approveComponent(WITHDRAW);
1147         approveComponent(RISK);
1148         approveComponent(WHITELIST);
1149         approveComponent(FEE);
1150         approveComponent(REIMBURSABLE);
1151         approveComponent(REBALANCE);
1152     }
1153 
1154     function updateAllComponents() public onlyOwner {
1155         updateComponent(MARKET);
1156         updateComponent(EXCHANGE);
1157         updateComponent(WITHDRAW);
1158         updateComponent(RISK);
1159         updateComponent(WHITELIST);
1160         updateComponent(FEE);
1161         updateComponent(REBALANCE);
1162         updateComponent(REIMBURSABLE);
1163     }
1164 
1165     function hasRisk(address _sender, address _receiver, address _tokenAddress, uint _amount, uint _rate) public returns(bool) {
1166         RiskControlInterface riskControl = RiskControlInterface(getComponentByName(RISK));
1167         bool risk = riskControl.hasRisk(_sender, _receiver, _tokenAddress, _amount, _rate);
1168         emit RiskEvent (_sender, _receiver, _tokenAddress, _amount, _rate, risk);
1169         return risk;
1170     }
1171 }