1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC223 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/223
6  */
7 interface ERC223I {
8 
9   function balanceOf(address _owner) external view returns (uint balance);
10   
11   function name() external view returns (string _name);
12   function symbol() external view returns (string _symbol);
13   function decimals() external view returns (uint8 _decimals);
14   function totalSupply() external view returns (uint256 supply);
15 
16   function transfer(address to, uint value) external returns (bool ok);
17   function transfer(address to, uint value, bytes data) external returns (bool ok);
18   function transfer(address to, uint value, bytes data, string custom_fallback) external returns (bool ok);
19 
20   function releaseTokenTransfer() external;
21   
22   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);  
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 contract SafeMath {
30 
31     /**
32     * @dev Subtracts two numbers, reverts on overflow.
33     */
34     function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
35         assert(y <= x);
36         uint256 z = x - y;
37         return z;
38     }
39 
40     /**
41     * @dev Adds two numbers, reverts on overflow.
42     */
43     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
44         uint256 z = x + y;
45         assert(z >= x);
46         return z;
47     }
48 	
49 	/**
50     * @dev Integer division of two numbers, reverts on division by zero.
51     */
52     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
53         uint256 z = x / y;
54         return z;
55     }
56     
57     /**
58     * @dev Multiplies two numbers, reverts on overflow.
59     */	
60     function safeMul(uint256 x, uint256 y) internal pure returns (uint256) {    
61         if (x == 0) {
62             return 0;
63         }
64     
65         uint256 z = x * y;
66         assert(z / x == y);
67         return z;
68     }
69 
70     /**
71     * @dev Returns the integer percentage of the number.
72     */
73     function safePerc(uint256 x, uint256 y) internal pure returns (uint256) {
74         if (x == 0) {
75             return 0;
76         }
77         
78         uint256 z = x * y;
79         assert(z / x == y);    
80         z = z / 10000; // percent to hundredths
81         return z;
82     }
83 
84     /**
85     * @dev Returns the minimum value of two numbers.
86     */	
87     function min(uint256 x, uint256 y) internal pure returns (uint256) {
88         uint256 z = x <= y ? x : y;
89         return z;
90     }
91 
92     /**
93     * @dev Returns the maximum value of two numbers.
94     */
95     function max(uint256 x, uint256 y) internal pure returns (uint256) {
96         uint256 z = x >= y ? x : y;
97         return z;
98     }
99 }
100 /**
101  * @title Ownable contract - base contract with an owner
102  */
103 contract Ownable {
104   
105   address public owner;
106   address public newOwner;
107 
108   event OwnershipTransferred(address indexed _from, address indexed _to);
109   
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   constructor() public {
115     owner = msg.sender;
116   }
117 
118   /**
119    * @dev Throws if called by any account other than the owner.
120    */
121   modifier onlyOwner() {
122     assert(msg.sender == owner);
123     _;
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param _newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address _newOwner) public onlyOwner {
131     assert(_newOwner != address(0));      
132     newOwner = _newOwner;
133   }
134 
135   /**
136    * @dev Accept transferOwnership.
137    */
138   function acceptOwnership() public {
139     if (msg.sender == newOwner) {
140       emit OwnershipTransferred(owner, newOwner);
141       owner = newOwner;
142     }
143   }
144 }
145 
146 /**
147  * @title RateContract Interface
148  * @dev 
149  */
150 interface RateContractI {
151     // returns the Currency information
152     function getCurrency(bytes32 _code) external view returns (string, uint, uint, uint, uint);
153 
154     // returns Rate of coin to PMC (with the exception of rate["ETH"]) 
155     function getRate(bytes32 _code) external view returns (uint);
156 
157     // returns Price of Object in the specified currency (local user currency)
158     // _code - specified currency
159     // _amount - price of object in PMC
160     function getLocalPrice(bytes32 _code, uint _amount) external view returns (uint);
161 
162     // returns Price of Object in the crypto currency (ETH)    
163     // _amount - price of object in PMC
164     function getCryptoPrice(uint _amount) external view returns (uint);
165 
166     // update rates for a specific coin
167     function updateRate(bytes32 _code, uint _pmc) external;
168 }
169 
170 /**
171  * @title Agent contract - base contract with an agent
172  */
173 contract Agent is Ownable {
174 
175   address public defAgent;
176 
177   mapping(address => bool) public Agents;  
178 
179   event UpdatedAgent(address _agent, bool _status);
180 
181   constructor() public {
182     defAgent = msg.sender;
183     Agents[msg.sender] = true;
184   }
185   
186   modifier onlyAgent() {
187     assert(Agents[msg.sender]);
188     _;
189   }
190   
191   function updateAgent(address _agent, bool _status) public onlyOwner {
192     assert(_agent != address(0));
193     Agents[_agent] = _status;
194 
195     emit UpdatedAgent(_agent, _status);
196   }  
197 }
198 
199 /**
200  * @title Standard ERC223 token
201  * @dev Implementation of the basic standard token.
202  * @dev https://github.com/ethereum/EIPs/issues/223
203  */
204 contract ERC223 is ERC223I, Agent, SafeMath {
205 
206   mapping(address => uint) balances;
207   
208   string public name;
209   string public symbol;
210   uint8 public decimals;
211   uint256 public totalSupply;
212 
213   address public crowdsale = address(0);
214   bool public released = false;
215 
216   /**
217    * @dev Limit token transfer until the crowdsale is over.
218    */
219   modifier canTransfer() {
220     assert(released || msg.sender == crowdsale);
221     _;
222   }
223 
224   modifier onlyCrowdsaleContract() {
225     assert(msg.sender == crowdsale);
226     _;
227   }  
228   
229   function name() public view returns (string _name) {
230     return name;
231   }
232 
233   function symbol() public view returns (string _symbol) {
234     return symbol;
235   }
236 
237   function decimals() public view returns (uint8 _decimals) {
238     return decimals;
239   }
240 
241   function totalSupply() public view returns (uint256 _totalSupply) {
242     return totalSupply;
243   }
244 
245   function balanceOf(address _owner) public view returns (uint balance) {
246     return balances[_owner];
247   }  
248 
249   // if bytecode exists then the _addr is a contract.
250   function isContract(address _addr) private view returns (bool is_contract) {
251     uint length;
252     assembly {
253       //retrieve the size of the code on target address, this needs assembly
254       length := extcodesize(_addr)
255     }
256     return (length>0);
257   }
258   
259   // function that is called when a user or another contract wants to transfer funds .
260   function transfer(address _to, uint _value, bytes _data) external canTransfer() returns (bool success) {      
261     if(isContract(_to)) {
262       return transferToContract(_to, _value, _data);
263     } else {
264       return transferToAddress(_to, _value, _data);
265     }
266   }
267   
268   // standard function transfer similar to ERC20 transfer with no _data.
269   // added due to backwards compatibility reasons.
270   function transfer(address _to, uint _value) external canTransfer() returns (bool success) {      
271     bytes memory empty;
272     if(isContract(_to)) {
273       return transferToContract(_to, _value, empty);
274     } else {
275       return transferToAddress(_to, _value, empty);
276     }
277   }
278 
279   // function that is called when transaction target is an address
280   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
281     if (balanceOf(msg.sender) < _value) revert();
282     balances[msg.sender] = safeSub(balances[msg.sender], _value);
283     balances[_to] = safeAdd(balances[_to], _value);
284     emit Transfer(msg.sender, _to, _value, _data);
285     return true;
286   }
287   
288   // function that is called when transaction target is a contract
289   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
290     if (balanceOf(msg.sender) < _value) revert();
291     balances[msg.sender] = safeSub(balances[msg.sender], _value);
292     balances[_to] = safeAdd(balances[_to], _value);
293     assert(_to.call.value(0)(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", msg.sender, _value, _data)));
294     emit Transfer(msg.sender, _to, _value, _data);
295     return true;
296   }
297 
298   // function that is called when a user or another contract wants to transfer funds .
299   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) external canTransfer() returns (bool success) {      
300     if(isContract(_to)) {
301       if (balanceOf(msg.sender) < _value) revert();
302       balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
303       balances[_to] = safeAdd(balanceOf(_to), _value);      
304       assert(_to.call.value(0)(abi.encodeWithSignature(_custom_fallback), msg.sender, _value, _data));    
305       emit Transfer(msg.sender, _to, _value, _data);
306       return true;
307     } else {
308       return transferToAddress(_to, _value, _data);
309     }
310   }
311 
312   function setCrowdsaleContract(address _contract) external onlyOwner {
313     crowdsale = _contract;
314   }
315 
316   /**
317    * @dev One way function to release the tokens to the wild. Can be called only from the crowdsale contract.
318    */
319   function releaseTokenTransfer() external onlyCrowdsaleContract {
320     released = true;
321   }
322 }
323 
324 
325 /**
326  * @title SABIGlobal CrowdSale management contract
327  */
328 contract CrowdSale is Agent, SafeMath {
329 
330   uint public decimals = 8;
331   uint public multiplier = 10 ** decimals;
332   
333   RateContractI public RateContract;
334   ERC223I public ERC223;
335 
336   uint public totalSupply;
337   
338   uint public SoftCap;
339   uint public HardCap;
340 
341   /* The UNIX timestamp start/end date of the crowdsale */
342   uint public startsAt;
343   uint public endsIn;
344   
345   /* How many unique addresses that have invested */
346   uint public investorCount = 0;
347   
348   /* How many wei of funding we have raised */
349   uint public weiRaised = 0;
350   
351   /* How many usd of funding we have raised */
352   uint public usdRaised = 0;
353   
354   /* The number of tokens already sold through this contract*/
355   uint public tokensSold = 0;
356   
357   /* Has this crowdsale been finalized */
358   bool public finalized;
359 
360   /** State
361    *
362    * - Preparing: All contract initialization calls and variables have not been set yet
363    * - PrivateSale: Private sale
364    * - PreSale: Pre Sale
365    * - Sale: Active crowdsale
366    * - Success: HardCap reached
367    * - Failure: HardCap not reached before ending time
368    * - Finalized: The finalized has been called and succesfully executed
369    */
370   enum State{Unknown, Preparing, PrivateSale, PreSale, Sale, Success, Failure, Finalized}
371 
372   /* How much ETH each address has invested to this crowdsale */
373   mapping (address => uint) public investedAmountOf;
374   
375   /* How much tokens this crowdsale has credited for each investor address */
376   mapping (address => uint) public tokenAmountOf;
377   
378   /* Wei will be transfered on this address */
379   address public multisigWallet;
380   
381   /* How much wei we have given back to investors. */
382   uint public weiRefunded = 0;
383 
384   /* token price in USD */
385   uint public price;
386 
387   struct _Stage {
388     uint startsAt;
389     uint endsIn;
390     uint bonus;    
391     uint min;
392     uint tokenAmount;
393     mapping (address => uint) tokenAmountOfStage; // how much tokens this crowdsale has credited for each investor address in a particular stage
394   }
395 
396   _Stage[5] public Stages;
397 
398   mapping (bytes32 => uint) public cap;
399   uint[5] public duration;
400 
401   /* A new investment was made */
402   event Invested(address investor, uint weiAmount, uint tokenAmount, uint bonusAmount);
403   /* Receive ether on the contract */
404   event ReceiveEtherOnContract(address sender, uint amount);
405   
406   /**
407    * @dev Constructor sets default parameters
408    * @param _startsAt1 = 1539993600 (20.10.2018)
409    * @param _startsAt2 = 1543104000 (25.11.2018)
410    * @param _startsAt3 = 1544313600 (09.12.2018)
411    * @param _startsAt4 = 1545523200 (23.12.2018)
412    * @param _startsAt5 = 1552176000 (10.03.2019)
413    */
414   constructor(address _multisigWallet, uint _priceTokenInUSDCents, uint _startsAt1, uint _startsAt2, uint _startsAt3, uint _startsAt4, uint _startsAt5) public {
415     
416     duration[0] = 36 days;
417     duration[1] = 14 days;
418     duration[2] = 14 days;
419     duration[3] =  9 days;  
420     duration[4] = 32 days;
421 
422     initialization(_multisigWallet, _priceTokenInUSDCents, _startsAt1, _startsAt2, _startsAt3, _startsAt4, _startsAt5);
423   }
424 
425   function hash(State _data) private pure returns (bytes32 _hash) {
426     return keccak256(abi.encodePacked(_data));
427   }
428 
429   function initialization(address _multisigWallet, uint _priceTokenInUSDCents, uint _startsAt1, uint _startsAt2, uint _startsAt3, uint _startsAt4, uint _startsAt5) public onlyOwner {
430 
431     require(_multisigWallet != address(0) && _priceTokenInUSDCents > 0);
432 
433     require(_startsAt1 < _startsAt2 &&
434             _startsAt2 >= _startsAt1 + duration[0] &&
435             _startsAt3 >= _startsAt2 + duration[1] &&
436             _startsAt4 >= _startsAt3 + duration[2] &&
437             _startsAt5 >= _startsAt4 + duration[3]);
438 
439     multisigWallet =_multisigWallet;
440     startsAt = _startsAt1;
441     endsIn = _startsAt5 + duration[4];
442     price = _priceTokenInUSDCents;
443 
444     SoftCap =  200 * (10**6) * multiplier;
445     HardCap = 1085 * (10**6) * multiplier;
446 
447     cap[hash(State.PrivateSale)] = 150 * (10**6) * multiplier +  60 * (10**6) * multiplier;
448     cap[hash(State.PreSale)]     = 500 * (10**6) * multiplier + 125 * (10**6) * multiplier;
449     cap[hash(State.Sale)]        = 250 * (10**6) * multiplier;
450 
451     Stages[0] = _Stage({startsAt: _startsAt1, endsIn:_startsAt1 + duration[0] - 1, bonus: 4000, min: 1250 * 10**3 * multiplier, tokenAmount: 0});
452     Stages[1] = _Stage({startsAt: _startsAt2, endsIn:_startsAt2 + duration[1] - 1, bonus: 2500, min: 2500 * multiplier, tokenAmount: 0});
453     Stages[2] = _Stage({startsAt: _startsAt3, endsIn:_startsAt3 + duration[2] - 1, bonus: 2000, min: 2500 * multiplier, tokenAmount: 0});
454     Stages[3] = _Stage({startsAt: _startsAt4, endsIn:_startsAt4 + duration[3],     bonus: 1500, min: 2500 * multiplier, tokenAmount: 0});
455     Stages[4] = _Stage({startsAt: _startsAt5, endsIn:_startsAt5 + duration[4],     bonus:    0, min: 1000 * multiplier, tokenAmount: 0});
456   }
457   
458   /** 
459    * @dev Crowdfund state
460    * @return State current state
461    */
462   function getState() public constant returns (State) {
463     if (finalized) return State.Finalized;
464     else if (ERC223 == address(0) || RateContract == address(0) || now < startsAt) return State.Preparing;
465     else if (now >= Stages[0].startsAt && now <= Stages[0].endsIn) return State.PrivateSale;
466     else if (now >= Stages[1].startsAt && now <= Stages[3].endsIn) return State.PreSale;
467     else if (now > Stages[3].endsIn && now < Stages[4].startsAt) return State.Preparing;
468     else if (now >= Stages[4].startsAt && now <= Stages[4].endsIn) return State.Sale;    
469     else if (isCrowdsaleFull()) return State.Success;
470     else return State.Failure;
471   }
472 
473   /** 
474    * @dev Gets the current stage.
475    * @return uint current stage
476    */
477   function getStage() public constant returns (uint) {
478     uint i;
479     for (i = 0; i < Stages.length; i++) {
480       if (now >= Stages[i].startsAt && now < Stages[i].endsIn) {
481         return i;
482       }
483     }
484     return Stages.length-1;
485   }
486 
487   /**
488    * Buy tokens from the contract
489    */
490   function() public payable {
491     investInternal(msg.sender, msg.value);
492   }
493 
494   /**
495    * Buy tokens from personal area (ETH or BTC)
496    */
497   function investByAgent(address _receiver, uint _weiAmount) external onlyAgent {
498     investInternal(_receiver, _weiAmount);
499   }
500   
501   /**
502    * Make an investment.
503    *
504    * @param _receiver The Ethereum address who receives the tokens
505    * @param _weiAmount The invested amount
506    *
507    */
508   function investInternal(address _receiver, uint _weiAmount) private {
509 
510     require(_weiAmount > 0);
511 
512     State currentState = getState();
513     require(currentState == State.PrivateSale || currentState == State.PreSale || currentState == State.Sale);
514 
515     uint currentStage = getStage();
516     
517     // Calculating the number of tokens
518     uint tokenAmount = 0;
519     uint bonusAmount = 0;
520     (tokenAmount, bonusAmount) = calculateTokens(_weiAmount, currentStage);
521 
522     tokenAmount = safeAdd(tokenAmount, bonusAmount);
523     
524     // Check cap for every State
525     if (currentState == State.PrivateSale || currentState == State.Sale) {
526       require(safeAdd(Stages[currentStage].tokenAmount, tokenAmount) <= cap[hash(currentState)]);
527     } else {
528       uint TokenSoldOnPreSale = safeAdd(safeAdd(Stages[1].tokenAmount, Stages[2].tokenAmount), Stages[3].tokenAmount);
529       TokenSoldOnPreSale = safeAdd(TokenSoldOnPreSale, tokenAmount);
530       require(TokenSoldOnPreSale <= cap[hash(currentState)]);
531     }      
532 
533     // Check HardCap
534     require(safeAdd(tokensSold, tokenAmount) <= HardCap);
535     
536     // Update stage counts  
537     Stages[currentStage].tokenAmount  = safeAdd(Stages[currentStage].tokenAmount, tokenAmount);
538     Stages[currentStage].tokenAmountOfStage[_receiver] = safeAdd(Stages[currentStage].tokenAmountOfStage[_receiver], tokenAmount);
539 	
540     // Update investor
541     if(investedAmountOf[_receiver] == 0) {       
542        investorCount++; // A new investor
543     }  
544     investedAmountOf[_receiver] = safeAdd(investedAmountOf[_receiver], _weiAmount);
545     tokenAmountOf[_receiver] = safeAdd(tokenAmountOf[_receiver], tokenAmount);
546 
547     // Update totals
548     weiRaised  = safeAdd(weiRaised, _weiAmount);
549     usdRaised  = safeAdd(usdRaised, weiToUsdCents(_weiAmount));
550     tokensSold = safeAdd(tokensSold, tokenAmount);    
551 
552     // Send ETH to multisigWallet
553     multisigWallet.transfer(msg.value);
554 
555     // Send tokens to _receiver
556     ERC223.transfer(_receiver, tokenAmount);
557 
558     // Tell us invest was success
559     emit Invested(_receiver, _weiAmount, tokenAmount, bonusAmount);
560   }  
561   
562   /**
563    * @dev Calculating tokens count
564    * @param _weiAmount invested
565    * @param _stage stage of crowdsale
566    * @return tokens amount
567    */
568   function calculateTokens(uint _weiAmount, uint _stage) internal view returns (uint tokens, uint bonus) {
569     uint usdAmount = weiToUsdCents(_weiAmount);    
570     tokens = safeDiv(safeMul(multiplier, usdAmount), price);
571 
572     // Check minimal amount to buy
573     require(tokens >= Stages[_stage].min);    
574 
575     bonus = safePerc(tokens, Stages[_stage].bonus);
576     return (tokens, bonus);
577   }
578   
579   /**
580    * @dev Converts wei value into USD cents according to current exchange rate
581    * @param weiValue wei value to convert
582    * @return USD cents equivalent of the wei value
583    */
584   function weiToUsdCents(uint weiValue) internal view returns (uint) {
585     return safeDiv(safeMul(weiValue, RateContract.getRate("ETH")), 1 ether);
586   }
587   
588   /**
589    * @dev Check if SoftCap was reached.
590    * @return true if the crowdsale has raised enough money to be a success
591    */
592   function isCrowdsaleFull() public constant returns (bool) {
593     if(tokensSold >= SoftCap){
594       return true;  
595     }
596     return false;
597   }
598 
599   /**
600    * @dev burn unsold tokens and allow transfer of tokens.
601    */
602   function finalize() public onlyOwner {    
603     require(!finalized);
604     require(now > endsIn);
605 
606     if(HardCap > tokensSold){
607       // burn unsold tokens 
608       ERC223.transfer(address(0), safeSub(HardCap, tokensSold));
609     }
610 
611     // allow transfer of tokens
612     ERC223.releaseTokenTransfer();
613 
614     finalized = true;
615   }
616 
617   /**
618    * Receives ether on the contract
619    */
620   function receive() public payable {
621     emit ReceiveEtherOnContract(msg.sender, msg.value);
622   }
623 
624   function setTokenContract(address _contract) external onlyOwner {
625     ERC223 = ERC223I(_contract);
626     totalSupply = ERC223.totalSupply();
627     HardCap = ERC223.balanceOf(address(this));
628   }
629 
630   function setRateContract(address _contract) external onlyOwner {
631     RateContract = RateContractI(_contract);
632   }
633 
634   function setDurations(uint _duration1, uint _duration2, uint _duration3, uint _duration4, uint _duration5) public onlyOwner {
635     duration[0] = _duration1;
636     duration[1] = _duration2;
637     duration[2] = _duration3;
638     duration[3] = _duration4;
639     duration[4] = _duration5;
640   }
641 }