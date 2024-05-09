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
225 contract MintableToken is StandardToken, Ownable {
226 
227   event Mint(address indexed to, uint256 amount);
228 
229   event MintFinished();
230 
231   bool public mintingFinished = false;
232 
233   address public saleAgent;
234 
235   function setSaleAgent(address newSaleAgnet) public {
236     require(msg.sender == saleAgent || msg.sender == owner);
237     saleAgent = newSaleAgnet;
238   }
239 
240   function mint(address _to, uint256 _amount) public returns (bool) {
241     require(msg.sender == saleAgent && !mintingFinished);
242     totalSupply = totalSupply.add(_amount);
243     balances[_to] = balances[_to].add(_amount);
244     Mint(_to, _amount);
245     return true;
246   }
247 
248   /**
249    * @dev Function to stop minting new tokens.
250    * @return True if the operation was successful.
251    */
252   function finishMinting() public returns (bool) {
253     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
254     mintingFinished = true;
255     MintFinished();
256     return true;
257   }
258 
259 
260 }
261 
262 /**
263  * @title Pausable
264  * @dev Base contract which allows children to implement an emergency stop mechanism.
265  */
266 contract Pausable is Ownable {
267   event Pause();
268   event Unpause();
269 
270   bool public paused = false;
271 
272 
273   /**
274    * @dev Modifier to make a function callable only when the contract is not paused.
275    */
276   modifier whenNotPaused() {
277     require(!paused);
278     _;
279   }
280 
281   /**
282    * @dev Modifier to make a function callable only when the contract is paused.
283    */
284   modifier whenPaused() {
285     require(paused);
286     _;
287   }
288 
289   /**
290    * @dev called by the owner to pause, triggers stopped state
291    */
292   function pause() onlyOwner whenNotPaused public {
293     paused = true;
294     Pause();
295   }
296 
297   /**
298    * @dev called by the owner to unpause, returns to normal state
299    */
300   function unpause() onlyOwner whenPaused public {
301     paused = false;
302     Unpause();
303   }
304 }
305 
306 contract VestarinToken is MintableToken {	
307     
308   string public constant name = "Vestarin";
309    
310   string public constant symbol = "VST";
311     
312   uint32 public constant decimals = 18;
313 
314   mapping (address => uint) public locked;
315 
316   function transfer(address _to, uint256 _value) public returns (bool) {
317     require(locked[msg.sender] < now);
318     return super.transfer(_to, _value);
319   }
320 
321   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
322     require(locked[_from] < now);
323     return super.transferFrom(_from, _to, _value);
324   }
325   
326   function lock(address addr, uint periodInDays) public {
327     require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
328     locked[addr] = now + periodInDays * 1 days;
329   }
330 
331 }
332 
333 contract StagedCrowdsale is Pausable {
334 
335   using SafeMath for uint;
336 
337   struct Stage {
338     uint hardcap;
339     uint price;
340     uint invested;
341     uint closed;
342   }
343 
344   uint public start;
345 
346   uint public period;
347 
348   uint public totalHardcap;
349  
350   uint public totalInvested;
351 
352   Stage[] public stages;
353 
354   function stagesCount() public constant returns(uint) {
355     return stages.length;
356   }
357 
358   function setStart(uint newStart) public onlyOwner {
359     start = newStart;
360   }
361 
362   function setPeriod(uint newPeriod) public onlyOwner {
363     period = newPeriod;
364   }
365 
366   function addStage(uint hardcap, uint price) public onlyOwner {
367     require(hardcap > 0 && price > 0);
368     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
369     stages.push(stage);
370     totalHardcap = totalHardcap.add(stage.hardcap);
371   }
372 
373   function removeStage(uint8 number) public onlyOwner {
374     require(number >=0 && number < stages.length);
375     Stage storage stage = stages[number];
376     totalHardcap = totalHardcap.sub(stage.hardcap);    
377     delete stages[number];
378     for (uint i = number; i < stages.length - 1; i++) {
379       stages[i] = stages[i+1];
380     }
381     stages.length--;
382   }
383 
384   function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
385     require(number >= 0 &&number < stages.length);
386     Stage storage stage = stages[number];
387     totalHardcap = totalHardcap.sub(stage.hardcap);    
388     stage.hardcap = hardcap.mul(1 ether);
389     stage.price = price;
390     totalHardcap = totalHardcap.add(stage.hardcap);    
391   }
392 
393   function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
394     require(numberAfter < stages.length);
395     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
396     totalHardcap = totalHardcap.add(stage.hardcap);
397     stages.length++;
398     for (uint i = stages.length - 2; i > numberAfter; i--) {
399       stages[i + 1] = stages[i];
400     }
401     stages[numberAfter + 1] = stage;
402   }
403 
404   function clearStages() public onlyOwner {
405     for (uint i = 0; i < stages.length; i++) {
406       delete stages[i];
407     }
408     stages.length -= stages.length;
409     totalHardcap = 0;
410   }
411 
412   function lastSaleDate() public constant returns(uint) {
413     return start + period * 1 days;
414   }
415 
416   modifier saleIsOn() {
417     require(stages.length > 0 && now >= start && now < lastSaleDate());
418     _;
419   }
420   
421   modifier isUnderHardcap() {
422     require(totalInvested <= totalHardcap);
423     _;
424   }
425 
426   function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
427     for(uint i=0; i < stages.length; i++) {
428       if(stages[i].closed == 0) {
429         return i;
430       }
431     }
432     revert();
433   }
434 
435 }
436 
437 contract CommonSale is StagedCrowdsale {
438 
439   address public masterWallet;
440 
441   address public slaveWallet;
442   
443   address public directMintAgent;
444 
445   uint public slaveWalletPercent = 30;
446 
447   uint public percentRate = 100;
448 
449   uint public minPrice;
450 
451   uint public totalTokensMinted;
452   
453   bool public slaveWalletInitialized;
454   
455   bool public slaveWalletPercentInitialized;
456 
457   VestarinToken public token;
458   
459   modifier onlyDirectMintAgentOrOwner() {
460     require(directMintAgent == msg.sender || owner == msg.sender);
461     _;
462   }
463   
464   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
465     directMintAgent = newDirectMintAgent;
466   }
467   
468   function setMinPrice(uint newMinPrice) public onlyOwner {
469     minPrice = newMinPrice;
470   }
471 
472   function setSlaveWalletPercent(uint newSlaveWalletPercent) public onlyOwner {
473     require(!slaveWalletPercentInitialized);
474     slaveWalletPercent = newSlaveWalletPercent;
475     slaveWalletPercentInitialized = true;
476   }
477 
478   function setMasterWallet(address newMasterWallet) public onlyOwner {
479     masterWallet = newMasterWallet;
480   }
481 
482   function setSlaveWallet(address newSlaveWallet) public onlyOwner {
483     require(!slaveWalletInitialized);
484     slaveWallet = newSlaveWallet;
485     slaveWalletInitialized = true;
486   }
487   
488   function setToken(address newToken) public onlyOwner {
489     token = VestarinToken(newToken);
490   }
491 
492   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
493     mintTokens(to, investedWei);
494   }
495 
496   function createTokens() public whenNotPaused payable {
497     require(msg.value >= minPrice);
498     uint masterValue = msg.value.mul(percentRate.sub(slaveWalletPercent)).div(percentRate);
499     uint slaveValue = msg.value.sub(masterValue);
500     masterWallet.transfer(masterValue);
501     slaveWallet.transfer(slaveValue);
502     mintTokens(msg.sender, msg.value);
503   }
504 
505   function mintTokens(address to, uint weiInvested) internal {
506     uint stageIndex = currentStage();
507     Stage storage stage = stages[stageIndex];
508     uint tokens = weiInvested.mul(stage.price);
509     token.mint(this, tokens);
510     token.transfer(to, tokens);
511     totalTokensMinted = totalTokensMinted.add(tokens);
512     totalInvested = totalInvested.add(weiInvested);
513     stage.invested = stage.invested.add(weiInvested);
514     if(stage.invested >= stage.hardcap) {
515       stage.closed = now;
516     }
517   }
518 
519   function() external payable {
520     createTokens();
521   }
522   
523   function retrieveTokens(address anotherToken, address to) public onlyOwner {
524     ERC20 alienToken = ERC20(anotherToken);
525     alienToken.transfer(to, alienToken.balanceOf(this));
526   }
527 
528 }
529 
530 contract Presale is CommonSale {
531 
532   Mainsale public mainsale;
533 
534   function setMainsale(address newMainsale) public onlyOwner {
535     mainsale = Mainsale(newMainsale);
536   }
537 
538   function finishMinting() public whenNotPaused onlyOwner {
539     token.setSaleAgent(mainsale);
540   }
541 
542   function() external payable {
543     createTokens();
544   }
545 
546 }
547 
548 
549 contract Mainsale is CommonSale {
550 
551   address public foundersTokensWallet;
552   
553   address public bountyTokensWallet;
554   
555   uint public foundersTokensPercent;
556   
557   uint public bountyTokensPercent;
558   
559   uint public lockPeriod;
560 
561   function setLockPeriod(uint newLockPeriod) public onlyOwner {
562     lockPeriod = newLockPeriod;
563   }
564 
565   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
566     foundersTokensPercent = newFoundersTokensPercent;
567   }
568 
569   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
570     bountyTokensPercent = newBountyTokensPercent;
571   }
572 
573   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
574     foundersTokensWallet = newFoundersTokensWallet;
575   }
576 
577   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
578     bountyTokensWallet = newBountyTokensWallet;
579   }
580 
581   function finishMinting() public whenNotPaused onlyOwner {
582     uint summaryTokensPercent = bountyTokensPercent + foundersTokensPercent;
583     uint mintedTokens = token.totalSupply();
584     uint summaryFoundersTokens = mintedTokens.mul(summaryTokensPercent).div(percentRate.sub(summaryTokensPercent));
585     uint totalSupply = summaryFoundersTokens + mintedTokens;
586     uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
587     uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
588     token.mint(this, foundersTokens);
589     token.lock(foundersTokensWallet, lockPeriod * 1 days);
590     token.transfer(foundersTokensWallet, foundersTokens);
591     token.mint(this, bountyTokens);
592     token.transfer(bountyTokensWallet, bountyTokens);
593     totalTokensMinted = totalTokensMinted.add(foundersTokens).add(bountyTokens);
594     token.finishMinting();
595   }
596 
597 }
598 
599 contract TestConfigurator is Ownable {
600 
601   VestarinToken public token; 
602 
603   Presale public presale;
604 
605   Mainsale public mainsale;
606 
607   function deploy() public onlyOwner {
608     owner = 0x445c94f566abF8E28739c474c572D356d03Ad999;
609 
610     token = new VestarinToken();
611 
612     presale = new Presale();
613 
614     presale.setToken(token);
615     presale.addStage(5,300);
616     presale.setMasterWallet(0x055fa3f2DAc0b9Db661A4745965DDD65490d56A8);
617     presale.setSlaveWallet(0x055fa3f2DAc0b9Db661A4745965DDD65490d56A8);
618     presale.setSlaveWalletPercent(30);
619     presale.setStart(1510704000);
620     presale.setPeriod(1);
621     presale.setMinPrice(100000000000000000);
622     token.setSaleAgent(presale);	
623 
624     mainsale = new Mainsale();
625 
626     mainsale.setToken(token);
627     mainsale.addStage(1,200);
628     mainsale.addStage(2,100);
629     mainsale.setMasterWallet(0x4d9014eF9C3CE5790A326775Bd9F609969d1BF4f);
630     mainsale.setSlaveWallet(0x4d9014eF9C3CE5790A326775Bd9F609969d1BF4f);
631     mainsale.setSlaveWalletPercent(30);
632     mainsale.setFoundersTokensWallet(0x59b398bBED1CC6c82b337B3Bd0ad7e4dCB7d4de3);
633     mainsale.setBountyTokensWallet(0x555635F2ea026ab65d7B44526539E0aB3874Ab24);
634     mainsale.setStart(1510790400);
635     mainsale.setPeriod(2);
636     mainsale.setLockPeriod(1);
637     mainsale.setMinPrice(100000000000000000);
638     mainsale.setFoundersTokensPercent(13);
639     mainsale.setBountyTokensPercent(5);
640 
641     presale.setMainsale(mainsale);
642 
643     token.transferOwnership(owner);
644     presale.transferOwnership(owner);
645     mainsale.transferOwnership(owner);
646   }
647 
648 }
649 
650 contract Configurator is Ownable {
651 
652   VestarinToken public token; 
653 
654   Presale public presale;
655 
656   Mainsale public mainsale;
657 
658   function deploy() public onlyOwner {
659     owner = 0x95EA6A4ec9F80436854702e5F05d238f27166A03;
660 
661     token = new VestarinToken();
662 
663     presale = new Presale();
664 
665     presale.setToken(token);
666     presale.addStage(5000,300);
667     presale.setMasterWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
668     presale.setSlaveWallet(0x070EcC35a3212D76ad443d529216a452eAA35E3D);
669     presale.setSlaveWalletPercent(30);
670     presale.setStart(1517317200);
671     presale.setPeriod(30);
672     presale.setMinPrice(100000000000000000);
673     token.setSaleAgent(presale);	
674 
675     mainsale = new Mainsale();
676 
677     mainsale.setToken(token);
678     mainsale.addStage(5000,200);
679     mainsale.addStage(5000,180);
680     mainsale.addStage(10000,170);
681     mainsale.addStage(20000,160);
682     mainsale.addStage(20000,150);
683     mainsale.addStage(40000,130);
684     mainsale.setMasterWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
685     mainsale.setSlaveWallet(0x070EcC35a3212D76ad443d529216a452eAA35E3D);
686     mainsale.setSlaveWalletPercent(30);
687     mainsale.setFoundersTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
688     mainsale.setBountyTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
689     mainsale.setStart(1525352400);
690     mainsale.setPeriod(30);
691     mainsale.setLockPeriod(90);
692     mainsale.setMinPrice(100000000000000000);
693     mainsale.setFoundersTokensPercent(13);
694     mainsale.setBountyTokensPercent(5);
695 
696     presale.setMainsale(mainsale);
697 
698     token.transferOwnership(owner);
699     presale.transferOwnership(owner);
700     mainsale.transferOwnership(owner);
701   }
702 
703 }