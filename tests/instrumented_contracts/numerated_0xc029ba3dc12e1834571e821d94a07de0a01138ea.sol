1 pragma solidity ^0.4.15;
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
277 contract QBEToken is MintableToken {	
278     
279   string public constant name = "Qubicle";
280    
281   string public constant symbol = "QBE";
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
349     require(number >= 0 && number < stages.length);
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
360     require(number >= 0 && number < stages.length);
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
402     for (uint i = 0; i < stages.length; i++) {
403       if (stages[i].closed == 0) {
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
420   QBEToken public token;
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
431     token = QBEToken(newToken);
432   }
433 
434   function createTokens() public whenNotPaused payable {
435     require(msg.value >= minPrice);
436     uint stageIndex = currentStage(); // should check if current stage returned a valid stage
437     multisigWallet.transfer(msg.value);
438     Stage storage stage = stages[stageIndex];
439     uint tokens = msg.value.mul(stage.price);
440     token.mint(this, tokens);
441     token.transfer(msg.sender, tokens);
442     totalTokensMinted = totalTokensMinted.add(tokens);
443     totalInvested = totalInvested.add(msg.value);
444     stage.invested = stage.invested.add(msg.value);
445     if (stage.invested >= stage.hardcap) {
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
495   address public unsoldTokensWallet;
496   
497   uint public foundersTokensReserve;
498   
499   uint public bountyTokensReserve;
500 
501   uint public maxTokenSupply;
502   
503   uint public lockPeriod;
504 
505   function setLockPeriod(uint newLockPeriod) public onlyOwner {
506     lockPeriod = newLockPeriod;
507   }
508 
509   function setFoundersTokensReserve(uint newFoundersTokensReserve) public onlyOwner {
510     foundersTokensReserve = newFoundersTokensReserve;
511   }
512 
513   function setBountyTokensReserve(uint newBountyTokensReserve) public onlyOwner {
514     bountyTokensReserve = newBountyTokensReserve;
515   }
516 
517   function setMaxTokenSupply(uint newMaxTokenSupply) public onlyOwner {
518     maxTokenSupply = newMaxTokenSupply;
519   }
520 
521   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
522     foundersTokensWallet = newFoundersTokensWallet;
523   }
524 
525   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
526     bountyTokensWallet = newBountyTokensWallet;
527   }
528 
529   function setUnsoldTokensWallet(address newUnsoldTokensWallet) public onlyOwner {
530     unsoldTokensWallet = newUnsoldTokensWallet;
531   }
532   
533   function finishMinting() public whenNotPaused onlyOwner {
534     token.mint(this, foundersTokensReserve);
535     token.lock(foundersTokensWallet, lockPeriod * 1 days);
536     token.transfer(foundersTokensWallet, foundersTokensReserve);
537     token.mint(this, bountyTokensReserve);
538     token.transfer(bountyTokensWallet, bountyTokensReserve);
539     totalTokensMinted = totalTokensMinted.add(foundersTokensReserve).add(bountyTokensReserve);
540 
541     uint totalUnsoldTokens = maxTokenSupply.sub(totalTokensMinted);
542     if (totalUnsoldTokens > 0){
543       token.mint(this, totalUnsoldTokens);
544       token.transfer(unsoldTokensWallet, totalUnsoldTokens);
545     }
546     
547     token.finishMinting();
548   }
549 
550 }
551 
552 contract TestConfigurator is Ownable {
553 
554   QBEToken public token; 
555 
556   Presale public presale;
557 
558   Mainsale public mainsale;
559 
560   function deploy() public onlyOwner {
561     token = new QBEToken();
562 
563     presale = new Presale();
564 
565     presale.setToken(token);
566     presale.addStage(10,3000);
567     presale.setMultisigWallet(0x4c076e99d9E8cFC647E1807D89506189d4256Ee1);
568     presale.setStart(1509393730);
569     presale.setPeriod(1);
570     presale.setMinPrice(100000000000000000);
571     token.setSaleAgent(presale);	
572 
573     mainsale = new Mainsale();
574 
575     mainsale.setToken(token);
576     mainsale.addStage(100,1500);
577     mainsale.setMultisigWallet(0xf32737F7779cA2D20c017Da8F51b2DF99F86A221);
578     mainsale.setFoundersTokensWallet(0x5b819179C8Ba84FB4a517Dd566cb09Ff4b8a277f);
579     mainsale.setBountyTokensWallet(0x7D2b00C23aDab97152aaB6588A50FcEdCEbD58e4);
580     mainsale.setUnsoldTokensWallet(0xAE5e64280eD777c6D2bb8EddfeF2394A21f147DD);
581     mainsale.setStart(1509393800);
582     mainsale.setPeriod(1);
583     mainsale.setLockPeriod(1);
584     mainsale.setMinPrice(100000000000000000);
585     mainsale.setFoundersTokensReserve(20 * (10**6) * 10**18);
586     mainsale.setBountyTokensReserve(10 * (10**6) * 10**18);
587     mainsale.setMaxTokenSupply(100 * (10**6) * 10**18);
588 
589     presale.setMainsale(mainsale);
590 
591     token.transferOwnership(owner);
592     presale.transferOwnership(owner);
593     mainsale.transferOwnership(owner);
594   }
595 
596 }
597 
598 contract Configurator is Ownable {
599 
600   QBEToken public token; 
601 
602   Presale public presale;
603 
604   Mainsale public mainsale;
605 
606   function deploy() public onlyOwner {
607     token = new QBEToken();
608 
609     presale = new Presale();
610 
611     presale.setToken(token);
612     presale.addStage(6000,3000);
613     presale.setMultisigWallet(0x17FB4A3ff095F445287AA6F3Ab699a3DCaE3DC56);
614     presale.setStart(1510128000);
615     presale.setPeriod(31);
616     presale.setMinPrice(100000000000000000);
617     token.setSaleAgent(presale);	
618 
619     mainsale = new Mainsale();
620 
621     mainsale.setToken(token);
622     mainsale.addStage(45000,1500);
623     mainsale.setMultisigWallet(0xdfF07F415E00a338205A8E21C39eC007eb37F746);
624     mainsale.setFoundersTokensWallet(0x7bfC9AdaF3D07adC4a1d3D03cde6581100845540);
625     mainsale.setBountyTokensWallet(0xce8d83BA3cDD4E7447339936643861478F8037AD);
626     mainsale.setUnsoldTokensWallet(0xd88a0920Dc4A044A95874f4Bd4858Fb013511290);
627     mainsale.setStart(1514764800);
628     mainsale.setPeriod(60);
629     mainsale.setLockPeriod(90);
630     mainsale.setMinPrice(100000000000000000);
631     mainsale.setFoundersTokensReserve(20 * (10**6) * 10**18);
632     mainsale.setBountyTokensReserve(10 * (10**6) * 10**18);
633     mainsale.setMaxTokenSupply(100 * (10**6) * 10**18);
634 
635     presale.setMainsale(mainsale);
636 
637     token.transferOwnership(owner);
638     presale.transferOwnership(owner);
639     mainsale.transferOwnership(owner);
640   }
641 }