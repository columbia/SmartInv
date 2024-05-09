1 pragma solidity 0.4.20;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 contract ERC20 is ERC20Basic {
151   function allowance(address owner, address spender) public view returns (uint256);
152   function transferFrom(address from, address to, uint256 value) public returns (bool);
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * @dev https://github.com/ethereum/EIPs/issues/20
162  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169   /**
170    * @dev Transfer tokens from one address to another
171    * @param _from address The address which you want to send tokens from
172    * @param _to address The address which you want to transfer to
173    * @param _value uint256 the amount of tokens to be transferred
174    */
175   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public view returns (uint256) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To increment
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _addedValue The amount of tokens to increase the allowance by.
222    */
223   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
224     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 contract GoldMineCoin is StandardToken, Ownable {	
253     
254   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256   uint public constant INITIAL_SUPPLY = 2500000000000;
257 
258   uint public constant BOUNTY_TOKENS_LIMIT = 125000000000;
259 
260   string public constant name = "GoldMineCoin";
261    
262   string public constant symbol = "GMC";
263     
264   uint32 public constant decimals = 6;
265 
266   uint public bountyTokensTransferred;
267 
268   address public saleAgent;
269   
270   bool public isCrowdsaleFinished;
271 
272   uint public remainingLockDate;
273   
274   mapping(address => uint) public locks;
275 
276   modifier notLocked(address from) {
277     require(isCrowdsaleFinished || (locks[from] !=0 && now >= locks[from]));
278     _;
279   }
280 
281   function GoldMineCoin() public {
282     totalSupply_ = INITIAL_SUPPLY;
283     balances[this] = totalSupply_;
284   }
285   
286   function addRestricedAccount(address restricedAccount, uint unlockedDate) public {
287     require(!isCrowdsaleFinished);    
288     require(msg.sender == saleAgent || msg.sender == owner);
289     locks[restricedAccount] = unlockedDate;
290   }
291 
292   function transferFrom(address _from, address _to, uint256 _value) public notLocked(_from) returns (bool) {
293     super.transferFrom(_from, _to, _value);
294   }
295 
296   function transfer(address _to, uint256 _value) public notLocked(msg.sender) returns (bool) {
297     super.transfer(_to, _value);
298   }
299 
300   function crowdsaleTransfer(address to, uint amount) public {
301     require(msg.sender == saleAgent || msg.sender == owner);
302     require(!isCrowdsaleFinished || now >= remainingLockDate);
303     require(amount <= balances[this]);
304     balances[this] = balances[this].sub(amount);
305     balances[to] = balances[to].add(amount);
306     Transfer(this, to, amount);
307   }
308 
309   function addBountyTransferredTokens(uint amount) public {
310     require(!isCrowdsaleFinished);
311     require(msg.sender == saleAgent);
312     bountyTokensTransferred = bountyTokensTransferred.add(amount);
313   }
314 
315   function setSaleAgent(address newSaleAgent) public {
316     require(!isCrowdsaleFinished);
317     require(msg.sender == owner|| msg.sender == saleAgent);
318     require(newSaleAgent != address(0));
319     saleAgent = newSaleAgent;
320   }
321   
322   function setRemainingLockDate(uint newRemainingLockDate) public {
323     require(!isCrowdsaleFinished && msg.sender == saleAgent); 
324     remainingLockDate = newRemainingLockDate;
325   }
326 
327   function finishCrowdsale() public {
328     require(msg.sender == saleAgent || msg.sender == owner);
329     isCrowdsaleFinished = true;
330   }
331 
332 }
333 
334 contract CommonCrowdsale is Ownable {
335 
336   using SafeMath for uint256;
337 
338   uint public price = 75000000;
339 
340   uint public constant MIN_INVESTED_ETH = 100000000000000000;
341 
342   uint public constant PERCENT_RATE = 100000000;
343                                      
344   uint public constant BOUNTY_PERCENT = 1666667;
345 
346   uint public constant REFERER_PERCENT = 500000;
347 
348   address public bountyWallet;
349 
350   address public wallet;
351 
352   uint public start;
353 
354   uint public period;
355 
356   uint public tokensSold;
357   
358   bool isBountyRestriced;
359 
360   GoldMineCoin public token;
361 
362   modifier saleIsOn() {
363     require(now >= start && now < end() && msg.value >= MIN_INVESTED_ETH);
364     require(tokensSold < tokensSoldLimit());
365     _;
366   }
367   
368   function tokensSoldLimit() public constant returns(uint);
369 
370   function end() public constant returns(uint) {
371     return start + period * 1 days;
372   }
373 
374   function setBountyWallet(address newBountyWallet) public onlyOwner {
375     bountyWallet = newBountyWallet;
376   }
377 
378   function setPrice(uint newPrice) public onlyOwner {
379     price = newPrice;
380   }
381 
382   function setToken(address newToken) public onlyOwner {
383     token = GoldMineCoin(newToken);
384   }
385 
386   function setStart(uint newStart) public onlyOwner {
387     start = newStart;
388   }
389 
390   function setPeriod(uint newPeriod) public onlyOwner {
391     require(bountyWallet != address(0));
392     period = newPeriod;
393     if(isBountyRestriced) {
394       token.addRestricedAccount(bountyWallet, end());
395     }
396   }
397 
398   function setWallet(address newWallet) public onlyOwner {
399     wallet = newWallet;
400   }
401 
402   function priceWithBonus() public constant returns(uint);
403   
404   function buyTokens() public payable saleIsOn {
405 
406     wallet.transfer(msg.value);
407 
408     uint tokens = msg.value.mul(priceWithBonus()).div(1 ether);
409     
410     token.crowdsaleTransfer(msg.sender, tokens);
411     tokensSold = tokensSold.add(tokens);
412 
413     // referer tokens
414     if(msg.data.length == 20) {
415       address referer = bytesToAddres(bytes(msg.data));
416       require(referer != address(token) && referer != msg.sender);
417       uint refererTokens = tokens.mul(REFERER_PERCENT).div(PERCENT_RATE);
418       token.crowdsaleTransfer(referer, refererTokens);
419       tokens.add(refererTokens);
420       tokensSold = tokensSold.add(refererTokens);
421     }
422 
423     // bounty tokens
424     if(token.bountyTokensTransferred() < token.BOUNTY_TOKENS_LIMIT()) {
425       uint bountyTokens = tokens.mul(BOUNTY_PERCENT).div(PERCENT_RATE);
426       uint diff = token.BOUNTY_TOKENS_LIMIT().sub(token.bountyTokensTransferred());
427       if(bountyTokens > diff) {
428         bountyTokens = diff;
429       }      
430       if(!isBountyRestriced) {
431         token.addRestricedAccount(bountyWallet, end());  
432         isBountyRestriced = true;
433       }
434       token.crowdsaleTransfer(bountyWallet, bountyTokens);
435     }
436   }
437 
438   function bytesToAddres(bytes source) internal pure returns(address) {
439     uint result;
440     uint mul = 1;
441     for(uint i = 20; i > 0; i--) {
442       result += uint8(source[i-1])*mul;
443       mul = mul*256;
444     }
445     return address(result);
446   }
447 
448   function retrieveTokens(address anotherToken) public onlyOwner {
449     ERC20 alienToken = ERC20(anotherToken);
450     alienToken.transfer(wallet, token.balanceOf(this));
451   }
452 
453   function() external payable {
454     buyTokens();
455   }
456 
457 }
458 
459 contract StaggedCrowdale is CommonCrowdsale {
460 
461   uint public constant SALE_STEP = 5000000;
462 
463   uint public timeStep = 5 * 1 days;
464 
465   function setTimeStep(uint newTimeStep) public onlyOwner {
466     timeStep = newTimeStep * 1 days;
467   }
468 
469   function priceWithBonus() public constant returns(uint) {
470     uint saleStage = now.sub(start).div(timeStep);
471     uint saleSub = saleStage.mul(SALE_STEP);
472     uint minSale = getMinPriceSale();
473     uint maxSale = getMaxPriceSale();
474     uint priceSale = maxSale;
475     if(saleSub >= maxSale.sub(minSale)) {
476       priceSale = minSale;
477     } else {
478       priceSale = maxSale.sub(saleSub);
479     }
480     return price.mul(PERCENT_RATE).div(PERCENT_RATE.sub(priceSale));
481   }
482   
483   function getMinPriceSale() public constant returns(uint);
484   
485   function getMaxPriceSale() public constant returns(uint);
486 
487 }
488 
489 contract CrowdsaleWithNextSaleAgent is CommonCrowdsale {
490 
491   address public nextSaleAgent;
492 
493   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
494     nextSaleAgent = newNextSaleAgent;
495   }
496 
497   function finishCrowdsale() public onlyOwner { 
498     token.setSaleAgent(nextSaleAgent);
499   }
500 
501 }
502 
503 contract Presale is CrowdsaleWithNextSaleAgent {
504 
505   uint public constant PRICE_SALE = 60000000;
506 
507   uint public constant TOKENS_SOLD_LIMIT = 125000000000;
508 
509   function tokensSoldLimit() public constant returns(uint) {
510     return TOKENS_SOLD_LIMIT;
511   }
512   
513   function priceWithBonus() public constant returns(uint) {
514     return price.mul(PERCENT_RATE).div(PERCENT_RATE.sub(PRICE_SALE));
515   }
516 
517 }
518 
519 contract PreICO is StaggedCrowdale, CrowdsaleWithNextSaleAgent {
520 
521   uint public constant MAX_PRICE_SALE = 55000000;
522 
523   uint public constant MIN_PRICE_SALE = 40000000;
524 
525   uint public constant TOKENS_SOLD_LIMIT = 625000000000;
526 
527   function tokensSoldLimit() public constant returns(uint) {
528     return TOKENS_SOLD_LIMIT;
529   }
530   
531   function getMinPriceSale() public constant returns(uint) {
532     return MIN_PRICE_SALE;
533   }
534   
535   function getMaxPriceSale() public constant returns(uint) {
536     return MAX_PRICE_SALE;
537   }
538 
539 }
540 
541 contract ICO is StaggedCrowdale {
542 
543   uint public constant MAX_PRICE_SALE = 40000000;
544 
545   uint public constant MIN_PRICE_SALE = 20000000;
546 
547   uint public constant ESCROW_TOKENS_PERCENT = 5000000;
548 
549   uint public constant FOUNDERS_TOKENS_PERCENT = 10000000;
550 
551   uint public lockPeriod = 250;
552 
553   address public foundersTokensWallet;
554 
555   address public escrowTokensWallet;
556 
557   uint public constant TOKENS_SOLD_LIMIT = 1250000000000;
558 
559   function tokensSoldLimit() public constant returns(uint) {
560     return TOKENS_SOLD_LIMIT;
561   }
562 
563   function setLockPeriod(uint newLockPeriod) public onlyOwner {
564     lockPeriod = newLockPeriod;
565   }
566 
567   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
568     foundersTokensWallet = newFoundersTokensWallet;
569   }
570 
571   function setEscrowTokensWallet(address newEscrowTokensWallet) public onlyOwner {
572     escrowTokensWallet = newEscrowTokensWallet;
573   }
574 
575   function finishCrowdsale() public onlyOwner { 
576     uint totalSupply = token.totalSupply();
577     uint commonPercent = FOUNDERS_TOKENS_PERCENT + ESCROW_TOKENS_PERCENT;
578     uint commonExtraTokens = totalSupply.mul(commonPercent).div(PERCENT_RATE.sub(commonPercent));
579     if(commonExtraTokens > token.balanceOf(token)) {
580       commonExtraTokens = token.balanceOf(token);
581     }
582     uint escrowTokens = commonExtraTokens.mul(FOUNDERS_TOKENS_PERCENT).div(PERCENT_RATE);
583     token.crowdsaleTransfer(foundersTokensWallet, foundersTokens);
584 
585     uint foundersTokens = commonExtraTokens - escrowTokens;
586     token.crowdsaleTransfer(escrowTokensWallet, escrowTokens);
587 
588     token.setRemainingLockDate(now + lockPeriod * 1 days);
589     token.finishCrowdsale();
590   }
591   
592   function getMinPriceSale() public constant returns(uint) {
593     return MIN_PRICE_SALE;
594   }
595   
596   function getMaxPriceSale() public constant returns(uint) {
597     return MAX_PRICE_SALE;
598   }
599 
600 }
601 
602 contract Configurator is Ownable {
603 
604   GoldMineCoin public token;
605 
606   Presale public presale;
607   
608   PreICO public preICO;
609   
610   ICO public ico;
611 
612   function deploy() public onlyOwner {
613     token = new GoldMineCoin();
614 
615     presale = new Presale();
616     presale.setToken(token);
617     token.setSaleAgent(presale);
618     
619     presale.setBountyWallet(0x6FB77f2878A33ef21aadde868E84Ba66105a3E9c);
620     presale.setWallet(0x2d664D31f3AF6aD256A62fdb72E704ab0De42619);
621     presale.setStart(1519862400);
622     presale.setPeriod(20);
623 
624     preICO = new PreICO();
625     preICO.setToken(token);
626     presale.setNextSaleAgent(preICO);
627     
628     preICO.setTimeStep(5);
629     preICO.setBountyWallet(0x4ca3a7788A61590722A7AAb3b79E8b4DfDDf9559);
630     preICO.setWallet(0x2d664D31f3AF6aD256A62fdb72E704ab0De42619);
631     preICO.setStart(1521504000);
632     preICO.setPeriod(40);
633     
634     ico = new ICO();
635     ico.setToken(token);
636     preICO.setNextSaleAgent(ico);
637     
638     ico.setTimeStep(5);
639     ico.setLockPeriod(250);
640     ico.setBountyWallet(0x7cfe25bdd334cdB46Ae0c4996E7D34F95DFFfdD1);
641     ico.setEscrowTokensWallet(0x24D225818a19c75694FCB35297cA2f23E0bd8F82);
642     ico.setFoundersTokensWallet(0x54540fC0e7cCc29d1c93AD7501761d6b232d5b03);
643     ico.setWallet(0x2d664D31f3AF6aD256A62fdb72E704ab0De42619);
644     ico.setStart(1525132800);
645     ico.setPeriod(60);
646 
647     token.transferOwnership(0xE8910a2C39Ef0405A9960eC4bD8CBA3211e3C796);
648     presale.transferOwnership(0xE8910a2C39Ef0405A9960eC4bD8CBA3211e3C796);
649     preICO.transferOwnership(0xE8910a2C39Ef0405A9960eC4bD8CBA3211e3C796);
650     ico.transferOwnership(0xE8910a2C39Ef0405A9960eC4bD8CBA3211e3C796);
651   }
652 
653 }