1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
161     uint oldValue = allowed[msg.sender][_spender];
162     if (_subtractedValue > oldValue) {
163       allowed[msg.sender][_spender] = 0;
164     } else {
165       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
166     }
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   function () public payable {
172     revert();
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183   address public owner;
184 
185 
186   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() public {
194     owner = msg.sender;
195   }
196 
197 
198   /**
199    * @dev Throws if called by any account other than the owner.
200    */
201   modifier onlyOwner() {
202     require(msg.sender == owner);
203     _;
204   }
205 
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) onlyOwner public {
212     require(newOwner != address(0));
213     OwnershipTransferred(owner, newOwner);
214     owner = newOwner;
215   }
216 
217 }
218 
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225 contract GoldMineCoin is StandardToken, Ownable {	
226     
227   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229   uint public constant INITIAL_SUPPLY = 2500000000000;
230 
231   uint public constant BOUNTY_TOKENS_LIMIT = 125000000000;
232 
233   string public constant name = "GoldMineCoin";
234    
235   string public constant symbol = "GMC";
236     
237   uint32 public constant decimals = 6;
238 
239   uint public bountyTokensTransferred;
240 
241   address public saleAgent;
242   
243   bool public isCrowdsaleFinished;
244 
245   uint public remainingLockDate;
246   
247   mapping(address => uint) public locks;
248 
249   modifier notLocked(address from) {
250     require(isCrowdsaleFinished || (locks[from] !=0 && now >= locks[from]));
251     _;
252   }
253 
254   function GoldMineCoin() public {
255     totalSupply = INITIAL_SUPPLY;
256     balances[this] = totalSupply;
257   }
258   
259   function addRestricedAccount(address restricedAccount, uint unlockedDate) public {
260     require(!isCrowdsaleFinished);    
261     require(msg.sender == saleAgent || msg.sender == owner);
262     locks[restricedAccount] = unlockedDate;
263   }
264 
265   function transferFrom(address _from, address _to, uint256 _value) public notLocked(_from) returns (bool) {
266     super.transferFrom(_from, _to, _value);
267   }
268 
269   function transfer(address _to, uint256 _value) public notLocked(msg.sender) returns (bool) {
270     super.transfer(_to, _value);
271   }
272 
273   function crowdsaleTransfer(address to, uint amount) public {
274     require(msg.sender == saleAgent || msg.sender == owner);
275     require(!isCrowdsaleFinished || now >= remainingLockDate);
276     require(amount <= balances[this]);
277     balances[this] = balances[this].sub(amount);
278     balances[to] = balances[to].add(amount);
279     Transfer(this, to, amount);
280   }
281 
282   function addBountyTransferredTokens(uint amount) public {
283     require(!isCrowdsaleFinished);
284     require(msg.sender == saleAgent);
285     bountyTokensTransferred = bountyTokensTransferred.add(amount);
286   }
287 
288   function setSaleAgent(address newSaleAgent) public {
289     require(!isCrowdsaleFinished);
290     require(msg.sender == owner|| msg.sender == saleAgent);
291     require(newSaleAgent != address(0));
292     saleAgent = newSaleAgent;
293   }
294   
295   function setRemainingLockDate(uint newRemainingLockDate) public {
296     require(!isCrowdsaleFinished && msg.sender == saleAgent); 
297     remainingLockDate = newRemainingLockDate;
298   }
299 
300   function finishCrowdsale() public {
301     require(msg.sender == saleAgent || msg.sender == owner);
302     isCrowdsaleFinished = true;
303   }
304 
305 }
306 
307 contract CommonCrowdsale is Ownable {
308 
309   using SafeMath for uint256;
310 
311   uint public price = 75000000;
312 
313   uint public constant MIN_INVESTED_ETH = 100000000000000000;
314 
315   uint public constant PERCENT_RATE = 100000000;
316                                      
317   uint public constant BOUNTY_PERCENT = 1666667;
318 
319   uint public constant REFERER_PERCENT = 500000;
320 
321   address public bountyWallet;
322 
323   address public wallet;
324 
325   uint public start;
326 
327   uint public period;
328 
329   uint public tokensSold;
330   
331   bool isBountyRestriced;
332 
333   GoldMineCoin public token;
334 
335   modifier saleIsOn() {
336     require(now >= start && now < end() && msg.value >= MIN_INVESTED_ETH);
337     require(tokensSold < tokensSoldLimit());
338     _;
339   }
340   
341   function tokensSoldLimit() public constant returns(uint);
342 
343   function end() public constant returns(uint) {
344     return start + period * 1 days;
345   }
346 
347   function setBountyWallet(address newBountyWallet) public onlyOwner {
348     bountyWallet = newBountyWallet;
349   }
350 
351   function setPrice(uint newPrice) public onlyOwner {
352     price = newPrice;
353   }
354 
355   function setToken(address newToken) public onlyOwner {
356     token = GoldMineCoin(newToken);
357   }
358 
359   function setStart(uint newStart) public onlyOwner {
360     start = newStart;
361   }
362 
363   function setPeriod(uint newPeriod) public onlyOwner {
364     require(bountyWallet != address(0));
365     period = newPeriod;
366     if(isBountyRestriced) {
367       token.addRestricedAccount(bountyWallet, end());
368     }
369   }
370 
371   function setWallet(address newWallet) public onlyOwner {
372     wallet = newWallet;
373   }
374 
375   function priceWithBonus() public constant returns(uint);
376   
377   function buyTokens() public payable saleIsOn {
378 
379     wallet.transfer(msg.value);
380 
381     uint tokens = msg.value.mul(priceWithBonus()).div(1 ether);
382     
383     token.crowdsaleTransfer(msg.sender, tokens);
384     tokensSold = tokensSold.add(tokens);
385 
386     // referer tokens
387     if(msg.data.length == 20) {
388       address referer = bytesToAddres(bytes(msg.data));
389       require(referer != address(token) && referer != msg.sender);
390       uint refererTokens = tokens.mul(REFERER_PERCENT).div(PERCENT_RATE);
391       token.crowdsaleTransfer(referer, refererTokens);
392       tokens.add(refererTokens);
393       tokensSold = tokensSold.add(refererTokens);
394     }
395 
396     // bounty tokens
397     if(token.bountyTokensTransferred() < token.BOUNTY_TOKENS_LIMIT()) {
398       uint bountyTokens = tokens.mul(BOUNTY_PERCENT).div(PERCENT_RATE);
399       uint diff = token.BOUNTY_TOKENS_LIMIT().sub(token.bountyTokensTransferred());
400       if(bountyTokens > diff) {
401         bountyTokens = diff;
402       }      
403       if(!isBountyRestriced) {
404         token.addRestricedAccount(bountyWallet, end());  
405         isBountyRestriced = true;
406       }
407       token.crowdsaleTransfer(bountyWallet, bountyTokens);
408     }
409   }
410 
411   function bytesToAddres(bytes source) internal pure returns(address) {
412     uint result;
413     uint mul = 1;
414     for(uint i = 20; i > 0; i--) {
415       result += uint8(source[i-1])*mul;
416       mul = mul*256;
417     }
418     return address(result);
419   }
420 
421   function retrieveTokens(address anotherToken) public onlyOwner {
422     ERC20 alienToken = ERC20(anotherToken);
423     alienToken.transfer(wallet, token.balanceOf(this));
424   }
425 
426   function() external payable {
427     buyTokens();
428   }
429 
430 }
431 
432 contract CrowdsaleWithNextSaleAgent is CommonCrowdsale {
433 
434   address public nextSaleAgent;
435 
436   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
437     nextSaleAgent = newNextSaleAgent;
438   }
439 
440   function finishCrowdsale() public onlyOwner { 
441     token.setSaleAgent(nextSaleAgent);
442   }
443 
444 }
445 
446 contract StaggedCrowdale is CommonCrowdsale {
447 
448   uint public constant SALE_STEP = 5000000;
449 
450   uint public timeStep = 5 * 1 days;
451 
452   function setTimeStep(uint newTimeStep) public onlyOwner {
453     timeStep = newTimeStep * 1 days;
454   }
455 
456   function priceWithBonus() public constant returns(uint) {
457     uint saleStage = now.sub(start).div(timeStep);
458     uint saleSub = saleStage.mul(SALE_STEP);
459     uint minSale = getMinPriceSale();
460     uint maxSale = getMaxPriceSale();
461     uint priceSale = maxSale;
462     if(saleSub >= maxSale.sub(minSale)) {
463       priceSale = minSale;
464     } else {
465       priceSale = maxSale.sub(saleSub);
466     }
467     return price.mul(PERCENT_RATE).div(PERCENT_RATE.sub(priceSale));
468   }
469   
470   function getMinPriceSale() public constant returns(uint);
471   
472   function getMaxPriceSale() public constant returns(uint);
473 
474 }
475 
476 contract Presale is CrowdsaleWithNextSaleAgent {
477 
478   uint public constant PRICE_SALE = 60000000;
479 
480   uint public constant TOKENS_SOLD_LIMIT = 125000000000;
481 
482   function tokensSoldLimit() public constant returns(uint) {
483     return TOKENS_SOLD_LIMIT;
484   }
485   
486   function priceWithBonus() public constant returns(uint) {
487     return price.mul(PERCENT_RATE).div(PERCENT_RATE.sub(PRICE_SALE));
488   }
489 
490 }
491 
492 contract PreICO is StaggedCrowdale, CrowdsaleWithNextSaleAgent {
493 
494   uint public constant MAX_PRICE_SALE = 55000000;
495 
496   uint public constant MIN_PRICE_SALE = 40000000;
497 
498   uint public constant TOKENS_SOLD_LIMIT = 625000000000;
499 
500   function tokensSoldLimit() public constant returns(uint) {
501     return TOKENS_SOLD_LIMIT;
502   }
503   
504   function getMinPriceSale() public constant returns(uint) {
505     return MIN_PRICE_SALE;
506   }
507   
508   function getMaxPriceSale() public constant returns(uint) {
509     return MAX_PRICE_SALE;
510   }
511 
512 }
513 
514 contract ICO is StaggedCrowdale {
515 
516   uint public constant MAX_PRICE_SALE = 40000000;
517 
518   uint public constant MIN_PRICE_SALE = 20000000;
519 
520   uint public constant ESCROW_TOKENS_PERCENT = 5000000;
521 
522   uint public constant FOUNDERS_TOKENS_PERCENT = 10000000;
523 
524   uint public lockPeriod = 250;
525 
526   address public foundersTokensWallet;
527 
528   address public escrowTokensWallet;
529 
530   uint public constant TOKENS_SOLD_LIMIT = 1250000000000;
531 
532   function tokensSoldLimit() public constant returns(uint) {
533     return TOKENS_SOLD_LIMIT;
534   }
535 
536   function setLockPeriod(uint newLockPeriod) public onlyOwner {
537     lockPeriod = newLockPeriod;
538   }
539 
540   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
541     foundersTokensWallet = newFoundersTokensWallet;
542   }
543 
544   function setEscrowTokensWallet(address newEscrowTokensWallet) public onlyOwner {
545     escrowTokensWallet = newEscrowTokensWallet;
546   }
547 
548   function finishCrowdsale() public onlyOwner { 
549     uint totalSupply = token.totalSupply();
550     uint commonPercent = FOUNDERS_TOKENS_PERCENT + ESCROW_TOKENS_PERCENT;
551     uint commonExtraTokens = totalSupply.mul(commonPercent).div(PERCENT_RATE.sub(commonPercent));
552     if(commonExtraTokens > token.balanceOf(token)) {
553       commonExtraTokens = token.balanceOf(token);
554     }
555     uint escrowTokens = commonExtraTokens.mul(FOUNDERS_TOKENS_PERCENT).div(PERCENT_RATE);
556     token.crowdsaleTransfer(foundersTokensWallet, foundersTokens);
557 
558     uint foundersTokens = commonExtraTokens - escrowTokens;
559     token.crowdsaleTransfer(escrowTokensWallet, escrowTokens);
560 
561     token.setRemainingLockDate(now + lockPeriod * 1 days);
562     token.finishCrowdsale();
563   }
564   
565   function getMinPriceSale() public constant returns(uint) {
566     return MIN_PRICE_SALE;
567   }
568   
569   function getMaxPriceSale() public constant returns(uint) {
570     return MAX_PRICE_SALE;
571   }
572 
573 }
574 
575 contract Configurator is Ownable {
576 
577   GoldMineCoin public token;
578 
579   Presale public presale;
580   
581   PreICO public preICO;
582   
583   ICO public ico;
584 
585   function deploy() public onlyOwner {
586     token = new GoldMineCoin();
587 
588     presale = new Presale();
589     presale.setToken(token);
590     token.setSaleAgent(presale);
591     
592     // fix
593     presale.setBountyWallet(0x6FB77f2878A33ef21aadde868E84Ba66105a3E9c);
594     presale.setWallet(0x2d664D31f3AF6aD256A62fdb72E704ab0De42619);
595     presale.setStart(1508850000);
596     presale.setPeriod(35);
597 
598     preICO = new PreICO();
599     preICO.setToken(token);
600     presale.setNextSaleAgent(preICO);
601     
602     // fix
603     preICO.setTimeStep(5);
604     preICO.setBountyWallet(0x4ca3a7788A61590722A7AAb3b79E8b4DfDDf9559);
605     preICO.setWallet(0x2d664D31f3AF6aD256A62fdb72E704ab0De42619);
606     preICO.setStart(1511182800);
607     preICO.setPeriod(24);
608     
609     ico = new ICO();
610     ico.setToken(token);
611     preICO.setNextSaleAgent(ico);
612     
613     // fix
614     ico.setTimeStep(5);
615     ico.setLockPeriod(250);
616     ico.setBountyWallet(0x7cfe25bdd334cdB46Ae0c4996E7D34F95DFFfdD1);
617     ico.setEscrowTokensWallet(0x24D225818a19c75694FCB35297cA2f23E0bd8F82);
618     ico.setFoundersTokensWallet(0x54540fC0e7cCc29d1c93AD7501761d6b232d5b03);
619     ico.setWallet(0x2d664D31f3AF6aD256A62fdb72E704ab0De42619);
620     ico.setStart(1513515600);
621     ico.setPeriod(32);
622 
623     token.transferOwnership(0xE8910a2C39Ef0405A9960eC4bD8CBA3211e3C796);
624     presale.transferOwnership(0xE8910a2C39Ef0405A9960eC4bD8CBA3211e3C796);
625     preICO.transferOwnership(0xE8910a2C39Ef0405A9960eC4bD8CBA3211e3C796);
626     ico.transferOwnership(0xE8910a2C39Ef0405A9960eC4bD8CBA3211e3C796);
627   }
628 
629 }