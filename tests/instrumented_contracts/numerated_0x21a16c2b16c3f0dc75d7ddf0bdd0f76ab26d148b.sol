1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31     
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55   
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances. 
61  */
62 contract BasicToken is ERC20Basic {
63     
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of. 
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157     
158   address public owner;
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     require(newOwner != address(0));      
182     owner = newOwner;
183   }
184 
185 }
186 
187 /**
188  * @title Mintable token
189  * @dev Simple ERC20 Token example, with mintable token creation
190  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
191  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
192  */
193 
194 contract MintableToken is StandardToken, Ownable {
195     
196   event Mint(address indexed to, uint256 amount);
197   
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201 
202   address public saleAgent;
203 
204   function setSaleAgent(address newSaleAgnet) {
205     require(msg.sender == saleAgent || msg.sender == owner);
206     saleAgent = newSaleAgnet;
207   }
208 
209   function mint(address _to, uint256 _amount) returns (bool) {
210     require(msg.sender == saleAgent && !mintingFinished);
211     totalSupply = totalSupply.add(_amount);
212     balances[_to] = balances[_to].add(_amount);
213     Mint(_to, _amount);
214     return true;
215   }
216 
217   /**
218    * @dev Function to stop minting new tokens.
219    * @return True if the operation was successful.
220    */
221   function finishMinting() returns (bool) {
222     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
223     mintingFinished = true;
224     MintFinished();
225     return true;
226   }
227 
228   
229 }
230 
231 /**
232  * @title Pausable
233  * @dev Base contract which allows children to implement an emergency stop mechanism.
234  */
235 contract Pausable is Ownable {
236     
237   event Pause();
238   
239   event Unpause();
240 
241   bool public paused = false;
242 
243   /**
244    * @dev modifier to allow actions only when the contract IS paused
245    */
246   modifier whenNotPaused() {
247     require(!paused);
248     _;
249   }
250 
251   /**
252    * @dev modifier to allow actions only when the contract IS NOT paused
253    */
254   modifier whenPaused() {
255     require(paused);
256     _;
257   }
258 
259   /**
260    * @dev called by the owner to pause, triggers stopped state
261    */
262   function pause() onlyOwner whenNotPaused {
263     paused = true;
264     Pause();
265   }
266 
267   /**
268    * @dev called by the owner to unpause, returns to normal state
269    */
270   function unpause() onlyOwner whenPaused {
271     paused = false;
272     Unpause();
273   }
274   
275 }
276 
277 contract CovestingToken is MintableToken {	
278     
279   string public constant name = "Covesting";
280    
281   string public constant symbol = "COV";
282     
283   uint32 public constant decimals = 18;
284 
285   mapping (address => uint) public locked;
286 
287   function transfer(address _to, uint256 _value) returns (bool) {
288     require(locked[msg.sender] < now);
289     return super.transfer(_to, _value);
290   }
291 
292   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
293     require(locked[_from] < now);
294     return super.transferFrom(_from, _to, _value);
295   }
296   
297   function lock(address addr, uint periodInDays) {
298     require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
299     locked[addr] = now + periodInDays * 1 days;
300   }
301 
302   function () payable {
303     revert();
304   }
305 
306 }
307 
308 contract StagedCrowdsale is Pausable {
309 
310   using SafeMath for uint;
311 
312   struct Stage {
313     uint hardcap;
314     uint price;
315     uint invested;
316     uint closed;
317   }
318 
319   uint public start;
320 
321   uint public period;
322 
323   uint public totalHardcap;
324  
325   uint public totalInvested;
326 
327   Stage[] public stages;
328 
329   function stagesCount() public constant returns(uint) {
330     return stages.length;
331   }
332 
333   function setStart(uint newStart) public onlyOwner {
334     start = newStart;
335   }
336 
337   function setPeriod(uint newPeriod) public onlyOwner {
338     period = newPeriod;
339   }
340 
341   function addStage(uint hardcap, uint price) public onlyOwner {
342     require(hardcap > 0 && price > 0);
343     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
344     stages.push(stage);
345     totalHardcap = totalHardcap.add(stage.hardcap);
346   }
347 
348   function removeStage(uint8 number) public onlyOwner {
349     require(number >=0 && number < stages.length);
350     Stage storage stage = stages[number];
351     totalHardcap = totalHardcap.sub(stage.hardcap);    
352     delete stages[number];
353     for (uint i = number; i < stages.length - 1; i++) {
354       stages[i] = stages[i+1];
355     }
356     stages.length--;
357   }
358 
359   function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
360     require(number >= 0 &&number < stages.length);
361     Stage storage stage = stages[number];
362     totalHardcap = totalHardcap.sub(stage.hardcap);    
363     stage.hardcap = hardcap.mul(1 ether);
364     stage.price = price;
365     totalHardcap = totalHardcap.add(stage.hardcap);    
366   }
367 
368   function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
369     require(numberAfter < stages.length);
370     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
371     totalHardcap = totalHardcap.add(stage.hardcap);
372     stages.length++;
373     for (uint i = stages.length - 2; i > numberAfter; i--) {
374       stages[i + 1] = stages[i];
375     }
376     stages[numberAfter + 1] = stage;
377   }
378 
379   function clearStages() public onlyOwner {
380     for (uint i = 0; i < stages.length; i++) {
381       delete stages[i];
382     }
383     stages.length -= stages.length;
384     totalHardcap = 0;
385   }
386 
387   function lastSaleDate() public constant returns(uint) {
388     return start + period * 1 days;
389   }
390 
391   modifier saleIsOn() {
392     require(stages.length > 0 && now >= start && now < lastSaleDate());
393     _;
394   }
395   
396   modifier isUnderHardcap() {
397     require(totalInvested <= totalHardcap);
398     _;
399   }
400 
401   function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
402     for(uint i=0; i < stages.length; i++) {
403       if(stages[i].closed == 0) {
404         return i;
405       }
406     }
407     revert();
408   }
409 
410 }
411 
412 contract CommonSale is StagedCrowdsale {
413 
414   address public multisigWallet;
415 
416   uint public minPrice;
417 
418   uint public totalTokensMinted;
419 
420   CovestingToken public token;
421   
422   function setMinPrice(uint newMinPrice) public onlyOwner {
423     minPrice = newMinPrice;
424   }
425 
426   function setMultisigWallet(address newMultisigWallet) public onlyOwner {
427     multisigWallet = newMultisigWallet;
428   }
429   
430   function setToken(address newToken) public onlyOwner {
431     token = CovestingToken(newToken);
432   }
433 
434   function createTokens() public whenNotPaused payable {
435     require(msg.value >= minPrice);
436     uint stageIndex = currentStage();
437     multisigWallet.transfer(msg.value);
438     Stage storage stage = stages[stageIndex];
439     uint tokens = msg.value.mul(stage.price);
440     token.mint(this, tokens);
441     token.transfer(msg.sender, tokens);
442     totalTokensMinted = totalTokensMinted.add(tokens);
443     totalInvested = totalInvested.add(msg.value);
444     stage.invested = stage.invested.add(msg.value);
445     if(stage.invested >= stage.hardcap) {
446       stage.closed = now;
447     }
448   }
449 
450   function() external payable {
451     createTokens();
452   }
453 
454   function retrieveTokens(address anotherToken) public onlyOwner {
455     ERC20 alienToken = ERC20(anotherToken);
456     alienToken.transfer(multisigWallet, token.balanceOf(this));
457   }
458 
459 }
460 
461 contract Presale is CommonSale {
462 
463   Mainsale public mainsale;
464 
465   function setMainsale(address newMainsale) public onlyOwner {
466     mainsale = Mainsale(newMainsale);
467   }
468 
469   function setMultisigWallet(address newMultisigWallet) public onlyOwner {
470     multisigWallet = newMultisigWallet;
471   }
472 
473   function finishMinting() public whenNotPaused onlyOwner {
474     token.setSaleAgent(mainsale);
475   }
476 
477   function() external payable {
478     createTokens();
479   }
480 
481   function retrieveTokens(address anotherToken) public onlyOwner {
482     ERC20 alienToken = ERC20(anotherToken);
483     alienToken.transfer(multisigWallet, token.balanceOf(this));
484   }
485 
486 }
487 
488 
489 contract Mainsale is CommonSale {
490 
491   address public foundersTokensWallet;
492   
493   address public bountyTokensWallet;
494   
495   uint public foundersTokensPercent;
496   
497   uint public bountyTokensPercent;
498   
499   uint public percentRate = 100;
500 
501   uint public lockPeriod;
502 
503   function setLockPeriod(uint newLockPeriod) public onlyOwner {
504     lockPeriod = newLockPeriod;
505   }
506 
507   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
508     foundersTokensPercent = newFoundersTokensPercent;
509   }
510 
511   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
512     bountyTokensPercent = newBountyTokensPercent;
513   }
514 
515   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
516     foundersTokensWallet = newFoundersTokensWallet;
517   }
518 
519   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
520     bountyTokensWallet = newBountyTokensWallet;
521   }
522 
523   function finishMinting() public whenNotPaused onlyOwner {
524     uint summaryTokensPercent = bountyTokensPercent + foundersTokensPercent;
525     uint mintedTokens = token.totalSupply();
526     uint summaryFoundersTokens = mintedTokens.mul(summaryTokensPercent).div(percentRate - summaryTokensPercent);
527     uint totalSupply = summaryFoundersTokens + mintedTokens;
528     uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
529     uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
530     token.mint(this, foundersTokens);
531     token.lock(foundersTokensWallet, lockPeriod * 1 days);
532     token.transfer(foundersTokensWallet, foundersTokens);
533     token.mint(this, bountyTokens);
534     token.transfer(bountyTokensWallet, bountyTokens);
535     totalTokensMinted = totalTokensMinted.add(foundersTokens).add(bountyTokens);
536     token.finishMinting();
537   }
538 
539 }
540 
541 contract TestConfigurator is Ownable {
542 
543   CovestingToken public token; 
544 
545   Presale public presale;
546 
547   Mainsale public mainsale;
548 
549   function deploy() public onlyOwner {
550     token = new CovestingToken();
551 
552     presale = new Presale();
553 
554     presale.setToken(token);
555     presale.addStage(5,300);
556     presale.setMultisigWallet(0x055fa3f2DAc0b9Db661A4745965DDD65490d56A8);
557     presale.setStart(1507208400);
558     presale.setPeriod(2);
559     presale.setMinPrice(100000000000000000);
560     token.setSaleAgent(presale);	
561 
562     mainsale = new Mainsale();
563 
564     mainsale.setToken(token);
565     mainsale.addStage(1,200);
566     mainsale.addStage(2,100);
567     mainsale.setMultisigWallet(0x4d9014eF9C3CE5790A326775Bd9F609969d1BF4f);
568     mainsale.setFoundersTokensWallet(0x59b398bBED1CC6c82b337B3Bd0ad7e4dCB7d4de3);
569     mainsale.setBountyTokensWallet(0x555635F2ea026ab65d7B44526539E0aB3874Ab24);
570     mainsale.setStart(1507467600);
571     mainsale.setPeriod(2);
572     mainsale.setLockPeriod(1);
573     mainsale.setMinPrice(100000000000000000);
574     mainsale.setFoundersTokensPercent(13);
575     mainsale.setBountyTokensPercent(5);
576 
577     presale.setMainsale(mainsale);
578 
579     token.transferOwnership(owner);
580     presale.transferOwnership(owner);
581     mainsale.transferOwnership(owner);
582   }
583 
584 }
585 
586 contract Configurator is Ownable {
587 
588   CovestingToken public token; 
589 
590   Presale public presale;
591 
592   Mainsale public mainsale;
593 
594   function deploy() public onlyOwner {
595     token = new CovestingToken();
596 
597     presale = new Presale();
598 
599     presale.setToken(token);
600     presale.addStage(5000,300);
601     presale.setMultisigWallet(0x6245C05a6fc205d249d0775769cfE73CB596e57D);
602     presale.setStart(1508504400);
603     presale.setPeriod(30);
604     presale.setMinPrice(100000000000000000);
605     token.setSaleAgent(presale);	
606 
607     mainsale = new Mainsale();
608 
609     mainsale.setToken(token);
610     mainsale.addStage(5000,200);
611     mainsale.addStage(5000,180);
612     mainsale.addStage(10000,170);
613     mainsale.addStage(20000,160);
614     mainsale.addStage(20000,150);
615     mainsale.addStage(40000,130);
616     mainsale.setMultisigWallet(0x15A071B83396577cCbd86A979Af7d2aBa9e18970);
617     mainsale.setFoundersTokensWallet(0x25ED4f0D260D5e5218D95390036bc8815Ff38262);
618     mainsale.setBountyTokensWallet(0x717bfD30f039424B049D918F935DEdD069B66810);
619     mainsale.setStart(1511222400);
620     mainsale.setPeriod(30);
621     mainsale.setLockPeriod(90);
622     mainsale.setMinPrice(100000000000000000);
623     mainsale.setFoundersTokensPercent(13);
624     mainsale.setBountyTokensPercent(5);
625 
626     presale.setMainsale(mainsale);
627 
628     token.transferOwnership(owner);
629     presale.transferOwnership(owner);
630     mainsale.transferOwnership(owner);
631   }
632 
633 }