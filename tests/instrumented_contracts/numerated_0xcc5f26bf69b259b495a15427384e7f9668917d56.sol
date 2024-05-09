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
225 
226 contract MintableToken is StandardToken, Ownable {
227     
228   event Mint(address indexed to, uint256 amount);
229   
230   event MintFinished();
231 
232   bool public mintingFinished = false;
233 
234   address public saleAgent;
235 
236   function setSaleAgent(address newSaleAgnet) public {
237     require(msg.sender == saleAgent || msg.sender == owner);
238     saleAgent = newSaleAgnet;
239   }
240 
241   function mint(address _to, uint256 _amount) public returns (bool) {
242     require(msg.sender == saleAgent && !mintingFinished);
243     totalSupply = totalSupply.add(_amount);
244     balances[_to] = balances[_to].add(_amount);
245     Mint(_to, _amount);
246     return true;
247   }
248 
249   /**
250    * @dev Function to stop minting new tokens.
251    * @return True if the operation was successful.
252    */
253   function finishMinting() public returns (bool) {
254     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
255     mintingFinished = true;
256     MintFinished();
257     return true;
258   }
259 
260   
261 }
262 
263 /**
264  * @title Pausable
265  * @dev Base contract which allows children to implement an emergency stop mechanism.
266  */
267 contract Pausable is Ownable {
268   event Pause();
269   event Unpause();
270 
271   bool public paused = false;
272 
273 
274   /**
275    * @dev Modifier to make a function callable only when the contract is not paused.
276    */
277   modifier whenNotPaused() {
278     require(!paused);
279     _;
280   }
281 
282   /**
283    * @dev Modifier to make a function callable only when the contract is paused.
284    */
285   modifier whenPaused() {
286     require(paused);
287     _;
288   }
289 
290   /**
291    * @dev called by the owner to pause, triggers stopped state
292    */
293   function pause() onlyOwner whenNotPaused public {
294     paused = true;
295     Pause();
296   }
297 
298   /**
299    * @dev called by the owner to unpause, returns to normal state
300    */
301   function unpause() onlyOwner whenPaused public {
302     paused = false;
303     Unpause();
304   }
305 }
306 
307 contract VestarinToken is MintableToken {	
308     
309   string public constant name = "Vestarin";
310    
311   string public constant symbol = "VST";
312     
313   uint32 public constant decimals = 18;
314 
315   mapping (address => uint) public locked;
316 
317   function transfer(address _to, uint256 _value) public returns (bool) {
318     require(locked[msg.sender] < now);
319     return super.transfer(_to, _value);
320   }
321 
322   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
323     require(locked[_from] < now);
324     return super.transferFrom(_from, _to, _value);
325   }
326   
327   function lock(address addr, uint periodInDays) public {
328     require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
329     locked[addr] = now + periodInDays * 1 days;
330   }
331 
332 }
333 
334 contract StagedCrowdsale is Pausable {
335 
336   using SafeMath for uint;
337 
338   struct Stage {
339     uint hardcap;
340     uint price;
341     uint invested;
342     uint closed;
343   }
344 
345   uint public start;
346 
347   uint public period;
348 
349   uint public totalHardcap;
350  
351   uint public totalInvested;
352 
353   Stage[] public stages;
354 
355   function stagesCount() public constant returns(uint) {
356     return stages.length;
357   }
358 
359   function setStart(uint newStart) public onlyOwner {
360     start = newStart;
361   }
362 
363   function setPeriod(uint newPeriod) public onlyOwner {
364     period = newPeriod;
365   }
366 
367   function addStage(uint hardcap, uint price) public onlyOwner {
368     require(hardcap > 0 && price > 0);
369     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
370     stages.push(stage);
371     totalHardcap = totalHardcap.add(stage.hardcap);
372   }
373 
374   function removeStage(uint8 number) public onlyOwner {
375     require(number >=0 && number < stages.length);
376     Stage storage stage = stages[number];
377     totalHardcap = totalHardcap.sub(stage.hardcap);    
378     delete stages[number];
379     for (uint i = number; i < stages.length - 1; i++) {
380       stages[i] = stages[i+1];
381     }
382     stages.length--;
383   }
384 
385   function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
386     require(number >= 0 &&number < stages.length);
387     Stage storage stage = stages[number];
388     totalHardcap = totalHardcap.sub(stage.hardcap);    
389     stage.hardcap = hardcap.mul(1 ether);
390     stage.price = price;
391     totalHardcap = totalHardcap.add(stage.hardcap);    
392   }
393 
394   function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
395     require(numberAfter < stages.length);
396     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
397     totalHardcap = totalHardcap.add(stage.hardcap);
398     stages.length++;
399     for (uint i = stages.length - 2; i > numberAfter; i--) {
400       stages[i + 1] = stages[i];
401     }
402     stages[numberAfter + 1] = stage;
403   }
404 
405   function clearStages() public onlyOwner {
406     for (uint i = 0; i < stages.length; i++) {
407       delete stages[i];
408     }
409     stages.length -= stages.length;
410     totalHardcap = 0;
411   }
412 
413   function lastSaleDate() public constant returns(uint) {
414     return start + period * 1 days;
415   }
416 
417   modifier saleIsOn() {
418     require(stages.length > 0 && now >= start && now < lastSaleDate());
419     _;
420   }
421   
422   modifier isUnderHardcap() {
423     require(totalInvested <= totalHardcap);
424     _;
425   }
426 
427   function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
428     for(uint i=0; i < stages.length; i++) {
429       if(stages[i].closed == 0) {
430         return i;
431       }
432     }
433     revert();
434   }
435 
436 }
437 
438 contract CommonSale is StagedCrowdsale {
439 
440   address public masterWallet;
441 
442   address public slaveWallet;
443   
444   address public directMintAgent;
445 
446   uint public slaveWalletPercent = 30;
447 
448   uint public percentRate = 100;
449 
450   uint public minPrice;
451 
452   uint public totalTokensMinted;
453   
454   bool public slaveWalletInitialized;
455   
456   bool public slaveWalletPercentInitialized;
457 
458   VestarinToken public token;
459   
460   modifier onlyDirectMintAgentOrOwner() {
461     require(directMintAgent == msg.sender || owner == msg.sender);
462     _;
463   }
464   
465   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
466     directMintAgent = newDirectMintAgent;
467   }
468   
469   function setMinPrice(uint newMinPrice) public onlyOwner {
470     minPrice = newMinPrice;
471   }
472 
473   function setSlaveWalletPercent(uint newSlaveWalletPercent) public onlyOwner {
474     require(!slaveWalletPercentInitialized);
475     slaveWalletPercent = newSlaveWalletPercent;
476     slaveWalletPercentInitialized = true;
477   }
478 
479   function setMasterWallet(address newMasterWallet) public onlyOwner {
480     masterWallet = newMasterWallet;
481   }
482 
483   function setSlaveWallet(address newSlaveWallet) public onlyOwner {
484     require(!slaveWalletInitialized);
485     slaveWallet = newSlaveWallet;
486     slaveWalletInitialized = true;
487   }
488   
489   function setToken(address newToken) public onlyOwner {
490     token = VestarinToken(newToken);
491   }
492 
493   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
494     mintTokens(to, investedWei);
495   }
496 
497   function createTokens() public whenNotPaused payable {
498     require(msg.value >= minPrice);
499     uint masterValue = msg.value.mul(percentRate.sub(slaveWalletPercent)).div(percentRate);
500     uint slaveValue = msg.value.sub(masterValue);
501     masterWallet.transfer(masterValue);
502     slaveWallet.transfer(slaveValue);
503     mintTokens(msg.sender, msg.value);
504   }
505 
506   function mintTokens(address to, uint weiInvested) internal {
507     uint stageIndex = currentStage();
508     Stage storage stage = stages[stageIndex];
509     uint tokens = weiInvested.mul(stage.price);
510     token.mint(this, tokens);
511     token.transfer(to, tokens);
512     totalTokensMinted = totalTokensMinted.add(tokens);
513     totalInvested = totalInvested.add(weiInvested);
514     stage.invested = stage.invested.add(weiInvested);
515     if(stage.invested >= stage.hardcap) {
516       stage.closed = now;
517     }
518   }
519 
520   function() external payable {
521     createTokens();
522   }
523   
524   function retrieveTokens(address anotherToken, address to) public onlyOwner {
525     ERC20 alienToken = ERC20(anotherToken);
526     alienToken.transfer(to, alienToken.balanceOf(this));
527   }
528 
529 
530 }
531 
532 contract Presale is CommonSale {
533 
534   Mainsale public mainsale;
535 
536   function setMainsale(address newMainsale) public onlyOwner {
537     mainsale = Mainsale(newMainsale);
538   }
539 
540   function finishMinting() public whenNotPaused onlyOwner {
541     token.setSaleAgent(mainsale);
542   }
543 
544   function() external payable {
545     createTokens();
546   }
547 
548 }
549 
550 
551 contract Mainsale is CommonSale {
552 
553   address public foundersTokensWallet;
554   
555   address public bountyTokensWallet;
556   
557   uint public foundersTokensPercent;
558   
559   uint public bountyTokensPercent;
560   
561   uint public lockPeriod;
562 
563   function setLockPeriod(uint newLockPeriod) public onlyOwner {
564     lockPeriod = newLockPeriod;
565   }
566 
567   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
568     foundersTokensPercent = newFoundersTokensPercent;
569   }
570 
571   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
572     bountyTokensPercent = newBountyTokensPercent;
573   }
574 
575   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
576     foundersTokensWallet = newFoundersTokensWallet;
577   }
578 
579   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
580     bountyTokensWallet = newBountyTokensWallet;
581   }
582 
583   function finishMinting() public whenNotPaused onlyOwner {
584     uint summaryTokensPercent = bountyTokensPercent + foundersTokensPercent;
585     uint mintedTokens = token.totalSupply();
586     uint summaryFoundersTokens = mintedTokens.mul(summaryTokensPercent).div(percentRate.sub(summaryTokensPercent));
587     uint totalSupply = summaryFoundersTokens + mintedTokens;
588     uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
589     uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
590     token.mint(this, foundersTokens);
591     token.lock(foundersTokensWallet, lockPeriod * 1 days);
592     token.transfer(foundersTokensWallet, foundersTokens);
593     token.mint(this, bountyTokens);
594     token.transfer(bountyTokensWallet, bountyTokens);
595     totalTokensMinted = totalTokensMinted.add(foundersTokens).add(bountyTokens);
596     token.finishMinting();
597   }
598 
599 }
600 
601 contract TestConfigurator is Ownable {
602 
603   VestarinToken public token; 
604 
605   Presale public presale;
606 
607   Mainsale public mainsale;
608 
609   function deploy() public onlyOwner {
610     owner = 0x445c94f566abF8E28739c474c572D356d03Ad999;
611 
612     token = new VestarinToken();
613 
614     presale = new Presale();
615 
616     presale.setToken(token);
617     presale.addStage(5,300);
618     presale.setMasterWallet(0x055fa3f2DAc0b9Db661A4745965DDD65490d56A8);
619     presale.setSlaveWallet(0x055fa3f2DAc0b9Db661A4745965DDD65490d56A8);
620     presale.setSlaveWalletPercent(30);
621     presale.setStart(1510704000);
622     presale.setPeriod(1);
623     presale.setMinPrice(100000000000000000);
624     token.setSaleAgent(presale);	
625 
626     mainsale = new Mainsale();
627 
628     mainsale.setToken(token);
629     mainsale.addStage(1,200);
630     mainsale.addStage(2,100);
631     mainsale.setMasterWallet(0x4d9014eF9C3CE5790A326775Bd9F609969d1BF4f);
632     mainsale.setSlaveWallet(0x4d9014eF9C3CE5790A326775Bd9F609969d1BF4f);
633     mainsale.setSlaveWalletPercent(30);
634     mainsale.setFoundersTokensWallet(0x59b398bBED1CC6c82b337B3Bd0ad7e4dCB7d4de3);
635     mainsale.setBountyTokensWallet(0x555635F2ea026ab65d7B44526539E0aB3874Ab24);
636     mainsale.setStart(1510790400);
637     mainsale.setPeriod(2);
638     mainsale.setLockPeriod(1);
639     mainsale.setMinPrice(100000000000000000);
640     mainsale.setFoundersTokensPercent(13);
641     mainsale.setBountyTokensPercent(5);
642 
643     presale.setMainsale(mainsale);
644 
645     token.transferOwnership(owner);
646     presale.transferOwnership(owner);
647     mainsale.transferOwnership(owner);
648   }
649 
650 }
651 
652 contract Configurator is Ownable {
653 
654   VestarinToken public token; 
655 
656   Presale public presale;
657 
658   Mainsale public mainsale;
659 
660   function deploy() public onlyOwner {
661     owner = 0x95EA6A4ec9F80436854702e5F05d238f27166A03;
662 
663     token = new VestarinToken();
664 
665     presale = new Presale();
666 
667     presale.setToken(token);
668     presale.addStage(5000,300);
669     presale.setMasterWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
670     presale.setSlaveWallet(0x070EcC35a3212D76ad443d529216a452eAA35E3D);
671     presale.setSlaveWalletPercent(30);
672     presale.setStart(1517317200);
673     presale.setPeriod(30);
674     presale.setMinPrice(100000000000000000);
675     token.setSaleAgent(presale);	
676 
677     mainsale = new Mainsale();
678 
679     mainsale.setToken(token);
680     mainsale.addStage(5000,200);
681     mainsale.addStage(5000,180);
682     mainsale.addStage(10000,170);
683     mainsale.addStage(20000,160);
684     mainsale.addStage(20000,150);
685     mainsale.addStage(40000,130);
686     mainsale.setMasterWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
687     mainsale.setSlaveWallet(0x070EcC35a3212D76ad443d529216a452eAA35E3D);
688     mainsale.setSlaveWalletPercent(30);
689     mainsale.setFoundersTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
690     mainsale.setBountyTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
691     mainsale.setStart(1525352400);
692     mainsale.setPeriod(30);
693     mainsale.setLockPeriod(90);
694     mainsale.setMinPrice(100000000000000000);
695     mainsale.setFoundersTokensPercent(13);
696     mainsale.setBountyTokensPercent(5);
697 
698     presale.setMainsale(mainsale);
699 
700     token.transferOwnership(owner);
701     presale.transferOwnership(owner);
702     mainsale.transferOwnership(owner);
703   }
704 
705 }