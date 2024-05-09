1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
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
20   function allowance(address owner, address spender) public view returns (uint256);
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
86   function balanceOf(address _owner) public view returns (uint256 balance) {
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
144   function allowance(address _owner, address _spender) public view returns (uint256) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    */
154   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
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
171 }
172 
173 /**
174  * @title Ownable
175  * @dev The Ownable contract has an owner address, and provides basic authorization control
176  * functions, this simplifies the implementation of "user permissions".
177  */
178 contract Ownable {
179   address public owner;
180 
181 
182   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183 
184 
185   /**
186    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
187    * account.
188    */
189   function Ownable() public {
190     owner = msg.sender;
191   }
192 
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner public {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 contract TaskFairToken is StandardToken, Ownable {	
216 
217   event Mint(address indexed to, uint256 amount);
218 
219   event MintFinished();
220     
221   string public constant name = "Task Fair Token";
222    
223   string public constant symbol = "TFT";
224     
225   uint32 public constant decimals = 18;
226 
227   bool public mintingFinished = false;
228  
229   address public saleAgent;
230 
231   modifier notLocked() {
232     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
233     _;
234   }
235 
236   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
237     return super.transfer(_to, _value);
238   }
239 
240   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
241     return super.transferFrom(from, to, value);
242   }
243 
244   function setSaleAgent(address newSaleAgent) public {
245     require(saleAgent == msg.sender || owner == msg.sender);
246     saleAgent = newSaleAgent;
247   }
248 
249   function mint(address _to, uint256 _amount) public returns (bool) {
250     require(!mintingFinished);
251     require(msg.sender == saleAgent);
252     totalSupply = totalSupply.add(_amount);
253     balances[_to] = balances[_to].add(_amount);
254     Mint(_to, _amount);
255     Transfer(address(0), _to, _amount);
256     return true;
257   }
258 
259   function finishMinting() public returns (bool) {
260     require(!mintingFinished);
261     require(msg.sender == owner || msg.sender == saleAgent);
262     mintingFinished = true;
263     MintFinished();
264     return true;
265   }
266 
267 }
268 
269 contract StagedCrowdsale is Ownable {
270 
271   using SafeMath for uint;
272 
273   uint public price;
274 
275   struct Stage {
276     uint period;
277     uint hardCap;
278     uint discount;
279     uint invested;
280     uint closed;
281   }
282 
283   uint public constant STAGES_PERCENT_RATE = 100;
284 
285   uint public start;
286 
287   uint public totalPeriod;
288 
289   uint public totalHardCap;
290  
291   uint public invested;
292 
293   Stage[] public stages;
294 
295   function stagesCount() public constant returns(uint) {
296     return stages.length;
297   }
298 
299   function setStart(uint newStart) public onlyOwner {
300     start = newStart;
301   }
302 
303   function setPrice(uint newPrice) public onlyOwner {
304     price = newPrice;
305   }
306 
307   function addStage(uint period, uint hardCap, uint discount) public onlyOwner {
308     require(period > 0 && hardCap > 0);
309     stages.push(Stage(period, hardCap, discount, 0, 0));
310     totalPeriod = totalPeriod.add(period);
311     totalHardCap = totalHardCap.add(hardCap);
312   }
313 
314   function removeStage(uint8 number) public onlyOwner {
315     require(number >=0 && number < stages.length);
316 
317     Stage storage stage = stages[number];
318     totalHardCap = totalHardCap.sub(stage.hardCap);    
319     totalPeriod = totalPeriod.sub(stage.period);
320 
321     delete stages[number];
322 
323     for (uint i = number; i < stages.length - 1; i++) {
324       stages[i] = stages[i+1];
325     }
326 
327     stages.length--;
328   }
329 
330   function changeStage(uint8 number, uint period, uint hardCap, uint discount) public onlyOwner {
331     require(number >= 0 && number < stages.length);
332 
333     Stage storage stage = stages[number];
334 
335     totalHardCap = totalHardCap.sub(stage.hardCap);    
336     totalPeriod = totalPeriod.sub(stage.period);    
337 
338     stage.hardCap = hardCap;
339     stage.period = period;
340     stage.discount = discount;
341 
342     totalHardCap = totalHardCap.add(hardCap);    
343     totalPeriod = totalPeriod.add(period);    
344   }
345 
346   function insertStage(uint8 numberAfter, uint period, uint hardCap, uint discount) public onlyOwner {
347     require(numberAfter < stages.length);
348 
349 
350     totalPeriod = totalPeriod.add(period);
351     totalHardCap = totalHardCap.add(hardCap);
352 
353     stages.length++;
354 
355     for (uint i = stages.length - 2; i > numberAfter; i--) {
356       stages[i + 1] = stages[i];
357     }
358 
359     stages[numberAfter + 1] = Stage(period, hardCap, discount, 0, 0);
360   }
361 
362   function clearStages() public onlyOwner {
363     for (uint i = 0; i < stages.length; i++) {
364       delete stages[i];
365     }
366     stages.length -= stages.length;
367     totalPeriod = 0;
368     totalHardCap = 0;
369   }
370 
371   function lastSaleDate() public constant returns(uint) {
372     require(stages.length > 0);
373     uint lastDate = start;
374     for(uint i=0; i < stages.length; i++) {
375       if(stages[i].invested >= stages[i].hardCap) {
376         lastDate = stages[i].closed;
377       } else {
378         lastDate = lastDate.add(stages[i].period * 1 days);
379       }
380     }
381     return lastDate;
382   }
383 
384   function currentStage() public constant returns(uint) {
385     require(now >= start);
386     uint previousDate = start;
387     for(uint i=0; i < stages.length; i++) {
388       if(stages[i].invested < stages[i].hardCap) {
389         if(now >= previousDate && now < previousDate + stages[i].period * 1 days) {
390           return i;
391         }
392         previousDate = previousDate.add(stages[i].period * 1 days);
393       } else {
394         previousDate = stages[i].closed;
395       }
396     }
397     revert();
398   }
399 
400   function updateStageWithInvested(uint stageIndex, uint investedInWei) internal {
401     invested = invested.add(investedInWei);
402     Stage storage stage = stages[stageIndex];
403     stage.invested = stage.invested.add(investedInWei);
404     if(stage.invested >= stage.hardCap) {
405       stage.closed = now;
406     }
407   }
408 
409 
410 }
411 
412 
413 contract CommonCrowdsale is StagedCrowdsale {
414 
415   uint public constant PERCENT_RATE = 1000;
416 
417   uint public minInvestedLimit;
418 
419   uint public minted;
420 
421   address public directMintAgent;
422   
423   address public wallet;
424 
425   address public devWallet;
426 
427   address public devTokensWallet;
428 
429   address public securityWallet;
430 
431   address public foundersTokensWallet;
432 
433   address public bountyTokensWallet;
434 
435   address public growthTokensWallet;
436 
437   address public advisorsTokensWallet;
438 
439   address public securityTokensWallet;
440 
441   uint public devPercent;
442 
443   uint public securityPercent;
444 
445   uint public bountyTokensPercent;
446 
447   uint public devTokensPercent;
448 
449   uint public advisorsTokensPercent;
450 
451   uint public foundersTokensPercent;
452 
453   uint public growthTokensPercent;
454 
455   uint public securityTokensPercent;
456 
457   TaskFairToken public token;
458 
459   modifier canMint(uint value) {
460     require(now >= start && value >= minInvestedLimit);
461     _;
462   }
463 
464   modifier onlyDirectMintAgentOrOwner() {
465     require(directMintAgent == msg.sender || owner == msg.sender);
466     _;
467   }
468 
469   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
470     minInvestedLimit = newMinInvestedLimit;
471   }
472 
473   function setDevPercent(uint newDevPercent) public onlyOwner { 
474     devPercent = newDevPercent;
475   }
476 
477   function setSecurityPercent(uint newSecurityPercent) public onlyOwner { 
478     securityPercent = newSecurityPercent;
479   }
480 
481   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner { 
482     bountyTokensPercent = newBountyTokensPercent;
483   }
484 
485   function setGrowthTokensPercent(uint newGrowthTokensPercent) public onlyOwner { 
486     growthTokensPercent = newGrowthTokensPercent;
487   }
488 
489   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner { 
490     foundersTokensPercent = newFoundersTokensPercent;
491   }
492 
493   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner { 
494     advisorsTokensPercent = newAdvisorsTokensPercent;
495   }
496 
497   function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner { 
498     devTokensPercent = newDevTokensPercent;
499   }
500 
501   function setSecurityTokensPercent(uint newSecurityTokensPercent) public onlyOwner { 
502     securityTokensPercent = newSecurityTokensPercent;
503   }
504 
505   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner { 
506     foundersTokensWallet = newFoundersTokensWallet;
507   }
508 
509   function setGrowthTokensWallet(address newGrowthTokensWallet) public onlyOwner { 
510     growthTokensWallet = newGrowthTokensWallet;
511   }
512 
513   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner { 
514     bountyTokensWallet = newBountyTokensWallet;
515   }
516 
517   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner { 
518     advisorsTokensWallet = newAdvisorsTokensWallet;
519   }
520 
521   function setDevTokensWallet(address newDevTokensWallet) public onlyOwner { 
522     devTokensWallet = newDevTokensWallet;
523   }
524 
525   function setSecurityTokensWallet(address newSecurityTokensWallet) public onlyOwner { 
526     securityTokensWallet = newSecurityTokensWallet;
527   }
528 
529   function setWallet(address newWallet) public onlyOwner { 
530     wallet = newWallet;
531   }
532 
533   function setDevWallet(address newDevWallet) public onlyOwner { 
534     devWallet = newDevWallet;
535   }
536 
537   function setSecurityWallet(address newSecurityWallet) public onlyOwner { 
538     securityWallet = newSecurityWallet;
539   }
540 
541   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
542     directMintAgent = newDirectMintAgent;
543   }
544 
545   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner canMint(investedWei) {
546     calculateAndTransferTokens(to, investedWei);
547   }
548 
549   function setStart(uint newStart) public onlyOwner { 
550     start = newStart;
551   }
552 
553   function setToken(address newToken) public onlyOwner { 
554     token = TaskFairToken(newToken);
555   }
556 
557   function mintExtendedTokens() internal {
558     uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent).add(foundersTokensPercent).add(growthTokensPercent).add(securityTokensPercent);
559     uint allTokens = minted.mul(PERCENT_RATE).div(PERCENT_RATE.sub(extendedTokensPercent));
560 
561     uint bountyTokens = allTokens.mul(bountyTokensPercent).div(PERCENT_RATE);
562     mintAndSendTokens(bountyTokensWallet, bountyTokens);
563 
564     uint advisorsTokens = allTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);
565     mintAndSendTokens(advisorsTokensWallet, advisorsTokens);
566 
567     uint foundersTokens = allTokens.mul(foundersTokensPercent).div(PERCENT_RATE);
568     mintAndSendTokens(foundersTokensWallet, foundersTokens);
569 
570     uint growthTokens = allTokens.mul(growthTokensPercent).div(PERCENT_RATE);
571     mintAndSendTokens(growthTokensWallet, growthTokens);
572 
573     uint devTokens = allTokens.mul(devTokensPercent).div(PERCENT_RATE);
574     mintAndSendTokens(devTokensWallet, devTokens);
575 
576     uint secuirtyTokens = allTokens.mul(securityTokensPercent).div(PERCENT_RATE);
577     mintAndSendTokens(securityTokensWallet, secuirtyTokens);
578   }
579 
580   function mintAndSendTokens(address to, uint amount) internal {
581     token.mint(to, amount);
582     minted = minted.add(amount);
583   }
584 
585   function calculateAndTransferTokens(address to, uint investedInWei) internal {
586     uint stageIndex = currentStage();
587     Stage storage stage = stages[stageIndex];
588 
589     // calculate tokens
590     uint tokens = investedInWei.mul(price).mul(STAGES_PERCENT_RATE).div(STAGES_PERCENT_RATE.sub(stage.discount)).div(1 ether);
591     
592     // transfer tokens
593     mintAndSendTokens(to, tokens);
594 
595     updateStageWithInvested(stageIndex, investedInWei);
596   }
597 
598   function createTokens() public payable;
599 
600   function() external payable {
601     createTokens();
602   }
603 
604   function retrieveTokens(address anotherToken) public onlyOwner {
605     ERC20 alienToken = ERC20(anotherToken);
606     alienToken.transfer(wallet, alienToken.balanceOf(this));
607   }
608 
609 }
610 
611 contract TGE is CommonCrowdsale {
612   
613   function TGE() public {
614     setMinInvestedLimit(100000000000000000);
615     setPrice(4000000000000000000000);
616     setBountyTokensPercent(50);
617     setAdvisorsTokensPercent(20);
618     setDevTokensPercent(30);
619     setFoundersTokensPercent(50);
620     setGrowthTokensPercent(300);
621     setSecurityTokensPercent(5);
622     setDevPercent(20);
623     setSecurityPercent(10);
624 
625     // fix in prod
626     addStage(7, 2850000000000000000000, 20);
627     addStage(7, 5700000000000000000000, 10);
628     addStage(7, 18280000000000000000000, 0);
629     
630     setStart(1514941200);
631     setWallet(0x570241a4953c71f92B794F77dd4e7cA295E79bb1);
632 
633     setBountyTokensWallet(0xb2C6f32c444C105F168a9Dc9F5cfCCC616041c8a);
634     setDevTokensWallet(0xad3Df84A21d508Ad1E782956badeBE8725a9A447);
635     setAdvisorsTokensWallet(0x7C737C97004F1C9156faaf2A4D04911e970aC554);
636     setFoundersTokensWallet(0xFEED17c1db96B62C18642A675a6561F3A395Bc10);
637     setGrowthTokensWallet(0xEc3E7D403E9fD34E83F00182421092d44f9543b2);
638     setSecurityTokensWallet(0xa820b6D6434c703B1b406b12d5b82d41F72069b4);
639 
640     setDevWallet(0xad3Df84A21d508Ad1E782956badeBE8725a9A447);
641     setSecurityWallet(0xA6A9f8b8D063538C84714f91390b48aE58047E31);
642   }
643 
644   function finishMinting() public onlyOwner {
645     mintExtendedTokens();
646     token.finishMinting();
647   }
648 
649   function createTokens() public payable canMint(msg.value) {
650     uint devWei = msg.value.mul(devPercent).div(PERCENT_RATE);
651     uint securityWei = this.balance.mul(securityPercent).div(PERCENT_RATE);
652     devWallet.transfer(devWei);
653     securityWallet.transfer(securityWei);
654     wallet.transfer(msg.value.sub(devWei).sub(securityWei));
655     calculateAndTransferTokens(msg.sender, msg.value);
656   } 
657 
658 }