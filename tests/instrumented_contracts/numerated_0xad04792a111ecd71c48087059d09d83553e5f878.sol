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
219 contract MintableToken is StandardToken, Ownable {
220     
221   event Mint(address indexed to, uint256 amount);
222   
223   event MintFinished();
224 
225   bool public mintingFinished = false;
226 
227   address public saleAgent;
228 
229   modifier notLocked() {
230     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
231     _;
232   }
233 
234   function setSaleAgent(address newSaleAgnet) public {
235     require(msg.sender == saleAgent || msg.sender == owner);
236     saleAgent = newSaleAgnet;
237   }
238 
239   function mint(address _to, uint256 _amount) public returns (bool) {
240     require(msg.sender == saleAgent && !mintingFinished);
241     totalSupply = totalSupply.add(_amount);
242     balances[_to] = balances[_to].add(_amount);
243     Mint(_to, _amount);
244     return true;
245   }
246 
247   /**
248    * @dev Function to stop minting new tokens.
249    * @return True if the operation was successful.
250    */
251   function finishMinting() public returns (bool) {
252     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
253     mintingFinished = true;
254     MintFinished();
255     return true;
256   }
257 
258   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
259     return super.transfer(_to, _value);
260   }
261 
262   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
263     return super.transferFrom(from, to, value);
264   }
265   
266 }
267 
268 /**
269  * @title Pausable
270  * @dev Base contract which allows children to implement an emergency stop mechanism.
271  */
272 contract Pausable is Ownable {
273   event Pause();
274   event Unpause();
275 
276   bool public paused = false;
277 
278 
279   /**
280    * @dev Modifier to make a function callable only when the contract is not paused.
281    */
282   modifier whenNotPaused() {
283     require(!paused);
284     _;
285   }
286 
287   /**
288    * @dev Modifier to make a function callable only when the contract is paused.
289    */
290   modifier whenPaused() {
291     require(paused);
292     _;
293   }
294 
295   /**
296    * @dev called by the owner to pause, triggers stopped state
297    */
298   function pause() onlyOwner whenNotPaused public {
299     paused = true;
300     Pause();
301   }
302 
303   /**
304    * @dev called by the owner to unpause, returns to normal state
305    */
306   function unpause() onlyOwner whenPaused public {
307     paused = false;
308     Unpause();
309   }
310 }
311 
312 contract VestarinToken is MintableToken {	
313     
314   string public constant name = "Vestarin";
315    
316   string public constant symbol = "VST";
317     
318   uint32 public constant decimals = 18;
319 
320   mapping (address => uint) public locked;
321 
322   function transfer(address _to, uint256 _value) public returns (bool) {
323     require(locked[msg.sender] < now);
324     return super.transfer(_to, _value);
325   }
326 
327   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
328     require(locked[_from] < now);
329     return super.transferFrom(_from, _to, _value);
330   }
331   
332   function lock(address addr, uint periodInDays) public {
333     require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
334     locked[addr] = now + periodInDays * 1 days;
335   }
336 
337 }
338 
339 contract StagedCrowdsale is Pausable {
340 
341   using SafeMath for uint;
342 
343   struct Stage {
344     uint hardcap;
345     uint price;
346     uint invested;
347     uint closed;
348   }
349 
350   uint public start;
351 
352   uint public period;
353 
354   uint public totalHardcap;
355  
356   uint public totalInvested;
357 
358   Stage[] public stages;
359 
360   function stagesCount() public constant returns(uint) {
361     return stages.length;
362   }
363 
364   function setStart(uint newStart) public onlyOwner {
365     start = newStart;
366   }
367 
368   function setPeriod(uint newPeriod) public onlyOwner {
369     period = newPeriod;
370   }
371 
372   function addStage(uint hardcap, uint price) public onlyOwner {
373     require(hardcap > 0 && price > 0);
374     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
375     stages.push(stage);
376     totalHardcap = totalHardcap.add(stage.hardcap);
377   }
378 
379   function removeStage(uint8 number) public onlyOwner {
380     require(number >=0 && number < stages.length);
381     Stage storage stage = stages[number];
382     totalHardcap = totalHardcap.sub(stage.hardcap);    
383     delete stages[number];
384     for (uint i = number; i < stages.length - 1; i++) {
385       stages[i] = stages[i+1];
386     }
387     stages.length--;
388   }
389 
390   function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
391     require(number >= 0 &&number < stages.length);
392     Stage storage stage = stages[number];
393     totalHardcap = totalHardcap.sub(stage.hardcap);    
394     stage.hardcap = hardcap.mul(1 ether);
395     stage.price = price;
396     totalHardcap = totalHardcap.add(stage.hardcap);    
397   }
398 
399   function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
400     require(numberAfter < stages.length);
401     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
402     totalHardcap = totalHardcap.add(stage.hardcap);
403     stages.length++;
404     for (uint i = stages.length - 2; i > numberAfter; i--) {
405       stages[i + 1] = stages[i];
406     }
407     stages[numberAfter + 1] = stage;
408   }
409 
410   function clearStages() public onlyOwner {
411     for (uint i = 0; i < stages.length; i++) {
412       delete stages[i];
413     }
414     stages.length -= stages.length;
415     totalHardcap = 0;
416   }
417 
418   function lastSaleDate() public constant returns(uint) {
419     return start + period * 1 days;
420   }
421 
422   modifier saleIsOn() {
423     require(stages.length > 0 && now >= start && now < lastSaleDate());
424     _;
425   }
426   
427   modifier isUnderHardcap() {
428     require(totalInvested <= totalHardcap);
429     _;
430   }
431 
432   function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
433     for(uint i=0; i < stages.length; i++) {
434       if(stages[i].closed == 0) {
435         return i;
436       }
437     }
438     revert();
439   }
440 
441 }
442 
443 contract CommonSale is StagedCrowdsale {
444 
445   address public masterWallet;
446 
447   address public slaveWallet;
448   
449   address public directMintAgent;
450 
451   uint public slaveWalletPercent = 30;
452 
453   uint public percentRate = 100;
454 
455   uint public minPrice;
456 
457   uint public totalTokensMinted;
458   
459   bool public slaveWalletInitialized;
460   
461   bool public slaveWalletPercentInitialized;
462 
463   VestarinToken public token;
464   
465   modifier onlyDirectMintAgentOrOwner() {
466     require(directMintAgent == msg.sender || owner == msg.sender);
467     _;
468   }
469   
470   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
471     directMintAgent = newDirectMintAgent;
472   }
473   
474   function setMinPrice(uint newMinPrice) public onlyOwner {
475     minPrice = newMinPrice;
476   }
477 
478   function setSlaveWalletPercent(uint newSlaveWalletPercent) public onlyOwner {
479     require(!slaveWalletPercentInitialized);
480     slaveWalletPercent = newSlaveWalletPercent;
481     slaveWalletPercentInitialized = true;
482   }
483 
484   function setMasterWallet(address newMasterWallet) public onlyOwner {
485     masterWallet = newMasterWallet;
486   }
487 
488   function setSlaveWallet(address newSlaveWallet) public onlyOwner {
489     require(!slaveWalletInitialized);
490     slaveWallet = newSlaveWallet;
491     slaveWalletInitialized = true;
492   }
493   
494   function setToken(address newToken) public onlyOwner {
495     token = VestarinToken(newToken);
496   }
497 
498   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
499     mintTokens(to, investedWei);
500   }
501 
502   function createTokens() public whenNotPaused payable {
503     require(msg.value >= minPrice);
504     uint masterValue = msg.value.mul(percentRate.sub(slaveWalletPercent)).div(percentRate);
505     uint slaveValue = msg.value.sub(masterValue);
506     masterWallet.transfer(masterValue);
507     slaveWallet.transfer(slaveValue);
508     mintTokens(msg.sender, msg.value);
509   }
510 
511   function mintTokens(address to, uint weiInvested) internal {
512     uint stageIndex = currentStage();
513     Stage storage stage = stages[stageIndex];
514     uint tokens = weiInvested.mul(stage.price);
515     token.mint(this, tokens);
516     token.transfer(to, tokens);
517     totalTokensMinted = totalTokensMinted.add(tokens);
518     totalInvested = totalInvested.add(weiInvested);
519     stage.invested = stage.invested.add(weiInvested);
520     if(stage.invested >= stage.hardcap) {
521       stage.closed = now;
522     }
523   }
524 
525   function() external payable {
526     createTokens();
527   }
528   
529   function retrieveTokens(address anotherToken, address to) public onlyOwner {
530     ERC20 alienToken = ERC20(anotherToken);
531     alienToken.transfer(to, alienToken.balanceOf(this));
532   }
533 
534 }
535 
536 contract Presale is CommonSale {
537 
538   Mainsale public mainsale;
539 
540   function setMainsale(address newMainsale) public onlyOwner {
541     mainsale = Mainsale(newMainsale);
542   }
543 
544   function finishMinting() public whenNotPaused onlyOwner {
545     token.setSaleAgent(mainsale);
546   }
547 
548   function() external payable {
549     createTokens();
550   }
551 
552 }
553 
554 
555 contract Mainsale is CommonSale {
556 
557   address public foundersTokensWallet;
558   
559   address public bountyTokensWallet;
560   
561   uint public foundersTokensPercent;
562   
563   uint public bountyTokensPercent;
564   
565   uint public lockPeriod;
566 
567   function setLockPeriod(uint newLockPeriod) public onlyOwner {
568     lockPeriod = newLockPeriod;
569   }
570 
571   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
572     foundersTokensPercent = newFoundersTokensPercent;
573   }
574 
575   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
576     bountyTokensPercent = newBountyTokensPercent;
577   }
578 
579   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
580     foundersTokensWallet = newFoundersTokensWallet;
581   }
582 
583   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
584     bountyTokensWallet = newBountyTokensWallet;
585   }
586 
587   function finishMinting() public whenNotPaused onlyOwner {
588     uint summaryTokensPercent = bountyTokensPercent + foundersTokensPercent;
589     uint mintedTokens = token.totalSupply();
590     uint summaryFoundersTokens = mintedTokens.mul(summaryTokensPercent).div(percentRate.sub(summaryTokensPercent));
591     uint totalSupply = summaryFoundersTokens + mintedTokens;
592     uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
593     uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
594     token.mint(this, foundersTokens);
595     token.lock(foundersTokensWallet, lockPeriod * 1 days);
596     token.transfer(foundersTokensWallet, foundersTokens);
597     token.mint(this, bountyTokens);
598     token.transfer(bountyTokensWallet, bountyTokens);
599     totalTokensMinted = totalTokensMinted.add(foundersTokens).add(bountyTokens);
600     token.finishMinting();
601   }
602 
603 }
604 
605 contract TestConfigurator is Ownable {
606 
607   VestarinToken public token; 
608 
609   Presale public presale;
610 
611   Mainsale public mainsale;
612 
613   function deploy() public onlyOwner {
614     owner = 0x445c94f566abF8E28739c474c572D356d03Ad999;
615 
616     token = new VestarinToken();
617 
618     presale = new Presale();
619 
620     presale.setToken(token);
621     presale.addStage(5,300);
622     presale.setMasterWallet(0x055fa3f2DAc0b9Db661A4745965DDD65490d56A8);
623     presale.setSlaveWallet(0x055fa3f2DAc0b9Db661A4745965DDD65490d56A8);
624     presale.setSlaveWalletPercent(30);
625     presale.setStart(1510704000);
626     presale.setPeriod(1);
627     presale.setMinPrice(100000000000000000);
628     token.setSaleAgent(presale);	
629 
630     mainsale = new Mainsale();
631 
632     mainsale.setToken(token);
633     mainsale.addStage(1,200);
634     mainsale.addStage(2,100);
635     mainsale.setMasterWallet(0x4d9014eF9C3CE5790A326775Bd9F609969d1BF4f);
636     mainsale.setSlaveWallet(0x4d9014eF9C3CE5790A326775Bd9F609969d1BF4f);
637     mainsale.setSlaveWalletPercent(30);
638     mainsale.setFoundersTokensWallet(0x59b398bBED1CC6c82b337B3Bd0ad7e4dCB7d4de3);
639     mainsale.setBountyTokensWallet(0x555635F2ea026ab65d7B44526539E0aB3874Ab24);
640     mainsale.setStart(1510790400);
641     mainsale.setPeriod(2);
642     mainsale.setLockPeriod(1);
643     mainsale.setMinPrice(100000000000000000);
644     mainsale.setFoundersTokensPercent(13);
645     mainsale.setBountyTokensPercent(5);
646 
647     presale.setMainsale(mainsale);
648 
649     token.transferOwnership(owner);
650     presale.transferOwnership(owner);
651     mainsale.transferOwnership(owner);
652   }
653 
654 }
655 
656 contract Configurator is Ownable {
657 
658   VestarinToken public token; 
659 
660   Presale public presale;
661 
662   Mainsale public mainsale;
663 
664   function deploy() public onlyOwner {
665     owner = 0x95EA6A4ec9F80436854702e5F05d238f27166A03;
666 
667     token = new VestarinToken();
668 
669     presale = new Presale();
670 
671     presale.setToken(token);
672     presale.addStage(5000,300);
673     presale.setMasterWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
674     presale.setSlaveWallet(0x070EcC35a3212D76ad443d529216a452eAA35E3D);
675     presale.setSlaveWalletPercent(30);
676     presale.setStart(1517317200);
677     presale.setPeriod(30);
678     presale.setMinPrice(100000000000000000);
679     token.setSaleAgent(presale);	
680 
681     mainsale = new Mainsale();
682 
683     mainsale.setToken(token);
684     mainsale.addStage(5000,200);
685     mainsale.addStage(5000,180);
686     mainsale.addStage(10000,170);
687     mainsale.addStage(20000,160);
688     mainsale.addStage(20000,150);
689     mainsale.addStage(40000,130);
690     mainsale.setMasterWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
691     mainsale.setSlaveWallet(0x070EcC35a3212D76ad443d529216a452eAA35E3D);
692     mainsale.setSlaveWalletPercent(30);
693     mainsale.setFoundersTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
694     mainsale.setBountyTokensWallet(0x95EA6A4ec9F80436854702e5F05d238f27166A03);
695     mainsale.setStart(1525352400);
696     mainsale.setPeriod(30);
697     mainsale.setLockPeriod(90);
698     mainsale.setMinPrice(100000000000000000);
699     mainsale.setFoundersTokensPercent(13);
700     mainsale.setBountyTokensPercent(5);
701 
702     presale.setMainsale(mainsale);
703 
704     token.transferOwnership(owner);
705     presale.transferOwnership(owner);
706     mainsale.transferOwnership(owner);
707   }
708 
709 }