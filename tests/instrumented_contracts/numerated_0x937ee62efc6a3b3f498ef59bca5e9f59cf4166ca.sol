1 pragma solidity ^0.4.21;
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
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113 
114     balances[_from] = balances[_from].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    *
124    * Beware that changing an allowance with this method brings the risk that someone may use both the old
125    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
126    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
127    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128    * @param _spender The address which will spend the funds.
129    * @param _value The amount of tokens to be spent.
130    */
131   function approve(address _spender, uint256 _value) public returns (bool) {
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifying the amount of tokens still available for the spender.
142    */
143   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147   /**
148    * approve should be called when allowed[_spender] == 0. To increment
149    */
150   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
151     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
157     uint oldValue = allowed[msg.sender][_spender];
158     if (_subtractedValue > oldValue) {
159       allowed[msg.sender][_spender] = 0;
160     } else {
161       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
162     }
163     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164     return true;
165   }
166 
167   function () public payable {
168     revert();
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
215 contract MintableToken is StandardToken, Ownable {
216     
217   event Mint(address indexed to, uint256 amount);
218   
219   event MintFinished();
220 
221   bool public mintingFinished = false;
222 
223   address public saleAgent;
224 
225   modifier notLocked() {
226     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
227     _;
228   }
229 
230   function setSaleAgent(address newSaleAgnet) public {
231     require(msg.sender == saleAgent || msg.sender == owner);
232     saleAgent = newSaleAgnet;
233   }
234 
235   function mint(address _to, uint256 _amount) public returns (bool) {
236     require(msg.sender == saleAgent && !mintingFinished);
237     totalSupply = totalSupply.add(_amount);
238     balances[_to] = balances[_to].add(_amount);
239     Mint(_to, _amount);
240     return true;
241   }
242 
243   /**
244    * @dev Function to stop minting new tokens.
245    * @return True if the operation was successful.
246    */
247   function finishMinting() public returns (bool) {
248     require((msg.sender == saleAgent || msg.sender == owner) && !mintingFinished);
249     mintingFinished = true;
250     MintFinished();
251     return true;
252   }
253 
254   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
255     return super.transfer(_to, _value);
256   }
257 
258   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
259     return super.transferFrom(from, to, value);
260   }
261   
262 }
263 
264 /**
265  * @title Pausable
266  * @dev Base contract which allows children to implement an emergency stop mechanism.
267  */
268 contract Pausable is Ownable {
269   event Pause();
270   event Unpause();
271 
272   bool public paused = false;
273 
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is not paused.
277    */
278   modifier whenNotPaused() {
279     require(!paused);
280     _;
281   }
282 
283   /**
284    * @dev Modifier to make a function callable only when the contract is paused.
285    */
286   modifier whenPaused() {
287     require(paused);
288     _;
289   }
290 
291   /**
292    * @dev called by the owner to pause, triggers stopped state
293    */
294   function pause() onlyOwner whenNotPaused public {
295     paused = true;
296     Pause();
297   }
298 
299   /**
300    * @dev called by the owner to unpause, returns to normal state
301    */
302   function unpause() onlyOwner whenPaused public {
303     paused = false;
304     Unpause();
305   }
306 }
307 
308 contract CRYPTORIYA is MintableToken {	
309     
310   string public constant name = "CRYPTORIYA";
311    
312   string public constant symbol = "CIYA";
313     
314   uint32 public constant decimals = 18;
315 
316   mapping (address => uint) public locked;
317 
318   function transfer(address _to, uint256 _value) public returns (bool) {
319     require(locked[msg.sender] < now);
320     return super.transfer(_to, _value);
321   }
322 
323   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
324     require(locked[_from] < now);
325     return super.transferFrom(_from, _to, _value);
326   }
327   
328   function lock(address addr, uint periodInDays) public {
329     require(locked[addr] < now && (msg.sender == saleAgent || msg.sender == addr));
330     locked[addr] = now + periodInDays * 1 days;
331   }
332 
333 }
334 
335 contract StagedCrowdsale is Pausable {
336 
337   using SafeMath for uint;
338 
339   struct Stage {
340     uint hardcap;
341     uint price;
342     uint invested;
343     uint closed;
344   }
345 
346   uint public start;
347 
348   uint public period;
349 
350   uint public totalHardcap;
351  
352   uint public totalInvested;
353 
354   Stage[] public stages;
355 
356   function stagesCount() public constant returns(uint) {
357     return stages.length;
358   }
359 
360   function setStart(uint newStart) public onlyOwner {
361     start = newStart;
362   }
363 
364   function setPeriod(uint newPeriod) public onlyOwner {
365     period = newPeriod;
366   }
367 
368   function addStage(uint hardcap, uint price) public onlyOwner {
369     require(hardcap > 0 && price > 0);
370     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
371     stages.push(stage);
372     totalHardcap = totalHardcap.add(stage.hardcap);
373   }
374 
375   function removeStage(uint8 number) public onlyOwner {
376     require(number >=0 && number < stages.length);
377     Stage storage stage = stages[number];
378     totalHardcap = totalHardcap.sub(stage.hardcap);    
379     delete stages[number];
380     for (uint i = number; i < stages.length - 1; i++) {
381       stages[i] = stages[i+1];
382     }
383     stages.length--;
384   }
385 
386   function changeStage(uint8 number, uint hardcap, uint price) public onlyOwner {
387     require(number >= 0 &&number < stages.length);
388     Stage storage stage = stages[number];
389     totalHardcap = totalHardcap.sub(stage.hardcap);    
390     stage.hardcap = hardcap.mul(1 ether);
391     stage.price = price;
392     totalHardcap = totalHardcap.add(stage.hardcap);    
393   }
394 
395   function insertStage(uint8 numberAfter, uint hardcap, uint price) public onlyOwner {
396     require(numberAfter < stages.length);
397     Stage memory stage = Stage(hardcap.mul(1 ether), price, 0, 0);
398     totalHardcap = totalHardcap.add(stage.hardcap);
399     stages.length++;
400     for (uint i = stages.length - 2; i > numberAfter; i--) {
401       stages[i + 1] = stages[i];
402     }
403     stages[numberAfter + 1] = stage;
404   }
405 
406   function clearStages() public onlyOwner {
407     for (uint i = 0; i < stages.length; i++) {
408       delete stages[i];
409     }
410     stages.length -= stages.length;
411     totalHardcap = 0;
412   }
413 
414   function lastSaleDate() public constant returns(uint) {
415     return start + period * 1 days;
416   }
417 
418   modifier saleIsOn() {
419     require(stages.length > 0 && now >= start && now < lastSaleDate());
420     _;
421   }
422   
423   modifier isUnderHardcap() {
424     require(totalInvested <= totalHardcap);
425     _;
426   }
427 
428   function currentStage() public saleIsOn isUnderHardcap constant returns(uint) {
429     for(uint i=0; i < stages.length; i++) {
430       if(stages[i].closed == 0) {
431         return i;
432       }
433     }
434     revert();
435   }
436 
437 }
438 
439 contract CommonSale is StagedCrowdsale {
440 
441   address public masterWallet;
442 
443   address public slaveWallet;
444   
445   address public directMintAgent;
446 
447   uint public slaveWalletPercent = 30;
448 
449   uint public percentRate = 100;
450 
451   uint public minPrice;
452 
453   uint public totalTokensMinted;
454   
455   bool public slaveWalletInitialized;
456   
457   bool public slaveWalletPercentInitialized;
458 
459   CRYPTORIYA public token;
460   
461   modifier onlyDirectMintAgentOrOwner() {
462     require(directMintAgent == msg.sender || owner == msg.sender);
463     _;
464   }
465   
466   function setDirectMintAgent(address newDirectMintAgent) public onlyOwner {
467     directMintAgent = newDirectMintAgent;
468   }
469   
470   function setMinPrice(uint newMinPrice) public onlyOwner {
471     minPrice = newMinPrice;
472   }
473 
474   function setSlaveWalletPercent(uint newSlaveWalletPercent) public onlyOwner {
475     require(!slaveWalletPercentInitialized);
476     slaveWalletPercent = newSlaveWalletPercent;
477     slaveWalletPercentInitialized = true;
478   }
479 
480   function setMasterWallet(address newMasterWallet) public onlyOwner {
481     masterWallet = newMasterWallet;
482   }
483 
484   function setSlaveWallet(address newSlaveWallet) public onlyOwner {
485     require(!slaveWalletInitialized);
486     slaveWallet = newSlaveWallet;
487     slaveWalletInitialized = true;
488   }
489   
490   function setToken(address newToken) public onlyOwner {
491     token = CRYPTORIYA(newToken);
492   }
493 
494   function directMint(address to, uint investedWei) public onlyDirectMintAgentOrOwner saleIsOn {
495     mintTokens(to, investedWei);
496   }
497 
498   function createTokens() public whenNotPaused payable {
499     require(msg.value >= minPrice);
500     uint masterValue = msg.value.mul(percentRate.sub(slaveWalletPercent)).div(percentRate);
501     uint slaveValue = msg.value.sub(masterValue);
502     masterWallet.transfer(masterValue);
503     slaveWallet.transfer(slaveValue);
504     mintTokens(msg.sender, msg.value);
505   }
506 
507   function mintTokens(address to, uint weiInvested) internal {
508     uint stageIndex = currentStage();
509     Stage storage stage = stages[stageIndex];
510     uint tokens = weiInvested.mul(stage.price);
511     token.mint(this, tokens);
512     token.transfer(to, tokens);
513     totalTokensMinted = totalTokensMinted.add(tokens);
514     totalInvested = totalInvested.add(weiInvested);
515     stage.invested = stage.invested.add(weiInvested);
516     if(stage.invested >= stage.hardcap) {
517       stage.closed = now;
518     }
519   }
520 
521   function() external payable {
522     createTokens();
523   }
524   
525   function retrieveTokens(address anotherToken, address to) public onlyOwner {
526     ERC20 alienToken = ERC20(anotherToken);
527     alienToken.transfer(to, alienToken.balanceOf(this));
528   }
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
550 contract Mainsale is CommonSale {
551 
552   address public foundersTokensWallet;
553   
554   address public bountyTokensWallet;
555   
556   uint public foundersTokensPercent;
557   
558   uint public bountyTokensPercent;
559   
560   uint public lockPeriod;
561 
562   function setLockPeriod(uint newLockPeriod) public onlyOwner {
563     lockPeriod = newLockPeriod;
564   }
565 
566   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner {
567     foundersTokensPercent = newFoundersTokensPercent;
568   }
569 
570   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner {
571     bountyTokensPercent = newBountyTokensPercent;
572   }
573 
574   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner {
575     foundersTokensWallet = newFoundersTokensWallet;
576   }
577 
578   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner {
579     bountyTokensWallet = newBountyTokensWallet;
580   }
581 
582   function finishMinting() public whenNotPaused onlyOwner {
583     uint summaryTokensPercent = bountyTokensPercent + foundersTokensPercent;
584     uint mintedTokens = token.totalSupply();
585     uint totalSupply = mintedTokens.mul(percentRate).div(percentRate.sub(summaryTokensPercent));
586     uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
587     uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
588     token.mint(this, foundersTokens);
589     token.transfer(foundersTokensWallet, foundersTokens);
590     token.mint(this, bountyTokens);
591     token.transfer(bountyTokensWallet, bountyTokens);
592     totalTokensMinted = totalTokensMinted.add(foundersTokens).add(bountyTokens);
593     token.finishMinting();
594   }
595 
596 }