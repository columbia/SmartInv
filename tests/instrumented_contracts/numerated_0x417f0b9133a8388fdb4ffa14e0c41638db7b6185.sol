1 pragma solidity ^0.4.13;
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
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208    * @dev Function to mint tokens
209    * @param _to The address that will recieve the minted tokens.
210    * @param _amount The amount of tokens to mint.
211    * @return A boolean that indicates if the operation was successful.
212    */
213   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     Mint(_to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229   
230 }
231 
232 /**
233  * @title Pausable
234  * @dev Base contract which allows children to implement an emergency stop mechanism.
235  */
236 contract Pausable is Ownable {
237     
238   event Pause();
239   
240   event Unpause();
241 
242   bool public paused = false;
243 
244   /**
245    * @dev modifier to allow actions only when the contract IS paused
246    */
247   modifier whenNotPaused() {
248     require(!paused);
249     _;
250   }
251 
252   /**
253    * @dev modifier to allow actions only when the contract IS NOT paused
254    */
255   modifier whenPaused() {
256     require(paused);
257     _;
258   }
259 
260   /**
261    * @dev called by the owner to pause, triggers stopped state
262    */
263   function pause() onlyOwner whenNotPaused {
264     paused = true;
265     Pause();
266   }
267 
268   /**
269    * @dev called by the owner to unpause, returns to normal state
270    */
271   function unpause() onlyOwner whenPaused {
272     paused = false;
273     Unpause();
274   }
275   
276 }
277 
278 contract INCToken is MintableToken {	
279     
280   string public constant name = "Instacoin";
281    
282   string public constant symbol = "INC";
283     
284   uint32 public constant decimals = 18;
285 
286   bool public transferAllowed = false;
287 
288   modifier whenTransferAllowed() {
289     require(transferAllowed || msg.sender == owner);
290     _;
291   }
292 
293   function allowTransfer() onlyOwner {
294     transferAllowed = true;
295   }
296 
297   function transfer(address _to, uint256 _value) whenTransferAllowed returns (bool) {
298     return super.transfer(_to, _value);
299   }
300 
301   function transferFrom(address _from, address _to, uint256 _value) whenTransferAllowed returns (bool) {
302     return super.transferFrom(_from, _to, _value);
303   }
304     
305 }
306 
307 
308 contract StagedCrowdsale is Pausable {
309 
310   using SafeMath for uint;
311 
312   struct Milestone {
313     uint period;
314     uint bonus;
315   }
316 
317   uint public start;
318 
319   uint public totalPeriod;
320 
321   uint public invested;
322 
323   uint public hardCap;
324  
325   Milestone[] public milestones;
326 
327   function milestonesCount() constant returns(uint) {
328     return milestones.length;
329   }
330 
331   function setStart(uint newStart) onlyOwner {
332     start = newStart;
333   }
334 
335   function setHardcap(uint newHardcap) onlyOwner {
336     hardCap = newHardcap;
337   }
338 
339   function addMilestone(uint period, uint bonus) onlyOwner {
340     require(period > 0);
341     milestones.push(Milestone(period, bonus));
342     totalPeriod = totalPeriod.add(period);
343   }
344 
345   function removeMilestone(uint8 number) onlyOwner {
346     require(number < milestones.length);
347     Milestone storage milestone = milestones[number];
348     totalPeriod = totalPeriod.sub(milestone.period);
349 
350     delete milestones[number];
351 
352     for (uint i = number; i < milestones.length - 1; i++) {
353       milestones[i] = milestones[i+1];
354     }
355 
356     milestones.length--;
357   }
358 
359   function changeMilestone(uint8 number, uint period, uint bonus) onlyOwner {
360     require(number < milestones.length);
361     Milestone storage milestone = milestones[number];
362 
363     totalPeriod = totalPeriod.sub(milestone.period);    
364 
365     milestone.period = period;
366     milestone.bonus = bonus;
367 
368     totalPeriod = totalPeriod.add(period);    
369   }
370 
371   function insertMilestone(uint8 numberAfter, uint period, uint bonus) onlyOwner {
372     require(numberAfter < milestones.length);
373 
374     totalPeriod = totalPeriod.add(period);
375 
376     milestones.length++;
377 
378     for (uint i = milestones.length - 2; i > numberAfter; i--) {
379       milestones[i + 1] = milestones[i];
380     }
381 
382     milestones[numberAfter + 1] = Milestone(period, bonus);
383   }
384 
385   function clearMilestones() onlyOwner {
386     require(milestones.length > 0);
387     for (uint i = 0; i < milestones.length; i++) {
388       delete milestones[i];
389     }
390     milestones.length -= milestones.length;
391     totalPeriod = 0;
392   }
393 
394   modifier saleIsOn() {
395     require(milestones.length > 0 && now >= start && now < lastSaleDate());
396     _;
397   }
398   
399   modifier isUnderHardCap() {
400     require(invested <= hardCap);
401     _;
402   }
403   
404   function lastSaleDate() constant returns(uint) {
405     require(milestones.length > 0);
406     return start + totalPeriod * 1 days;
407   }
408 
409   function currentMilestone() saleIsOn constant returns(uint) {
410     uint previousDate = start;
411     for(uint i=0; i < milestones.length; i++) {
412       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
413         return i;
414       }
415       previousDate = previousDate.add(milestones[i].period * 1 days);
416     }
417     revert();
418   }
419 
420 }
421 
422 /**
423  * @title PreSale
424  * @dev The PreSale contract stores balances investors of pre sale stage.
425  */
426 contract PreSale is Pausable {
427     
428   event Invest(address, uint);
429 
430   using SafeMath for uint;
431     
432   address public wallet;
433 
434   uint public start;
435   
436   uint public total;
437   
438   uint16 public period;
439 
440   mapping (address => uint) balances;
441 
442   mapping (address => bool) invested;
443   
444   address[] public investors;
445   
446   modifier saleIsOn() {
447     require(now > start && now < start + period * 1 days);
448     _;
449   }
450   
451   function totalInvestors() constant returns (uint) {
452     return investors.length;
453   }
454   
455   function balanceOf(address investor) constant returns (uint) {
456     return balances[investor];
457   }
458   
459   function setStart(uint newStart) onlyOwner {
460     start = newStart;
461   }
462   
463   function setPeriod(uint16 newPeriod) onlyOwner {
464     period = newPeriod;
465   }
466   
467   function setWallet(address newWallet) onlyOwner {
468     require(newWallet != address(0));
469     wallet = newWallet;
470   }
471 
472   function invest() saleIsOn whenNotPaused payable {
473     wallet.transfer(msg.value);
474     balances[msg.sender] = balances[msg.sender].add(msg.value);
475     bool isInvested = invested[msg.sender];
476     if(!isInvested) {
477         investors.push(msg.sender);    
478         invested[msg.sender] = true;
479     }
480     total = total.add(msg.value);
481     Invest(msg.sender, msg.value);
482   }
483 
484   function() external payable {
485     invest();
486   }
487 
488 }
489 
490 contract Crowdsale is StagedCrowdsale {
491 
492   address public multisigWallet;
493   
494   address public foundersTokensWallet;
495   
496   address public bountyTokensWallet;
497 
498   uint public foundersTokensPercent;
499   
500   uint public bountyTokensPercent;
501  
502   uint public price;
503 
504   uint public percentRate = 100;
505 
506   uint public earlyInvestorsBonus;
507 
508   PreSale public presale;
509 
510   bool public earlyInvestorsMintedTokens = false;
511 
512   INCToken public token = new INCToken();
513 
514   function setPrice(uint newPrice) onlyOwner {
515     price = newPrice;
516   }
517 
518   function setPresaleAddress(address newPresaleAddress) onlyOwner {
519     presale = PreSale(newPresaleAddress);
520   }
521 
522   function setFoundersTokensPercent(uint newFoundersTokensPercent) onlyOwner {
523     foundersTokensPercent = newFoundersTokensPercent;
524   }
525   
526   function setEarlyInvestorsBonus(uint newEarlyInvestorsBonus) onlyOwner {
527     earlyInvestorsBonus = newEarlyInvestorsBonus;
528   }
529 
530   function setBountyTokensPercent(uint newBountyTokensPercent) onlyOwner {
531     bountyTokensPercent = newBountyTokensPercent;
532   }
533   
534   function setMultisigWallet(address newMultisigWallet) onlyOwner {
535     multisigWallet = newMultisigWallet;
536   }
537 
538   function setFoundersTokensWallet(address newFoundersTokensWallet) onlyOwner {
539     foundersTokensWallet = newFoundersTokensWallet;
540   }
541 
542   function setBountyTokensWallet(address newBountyTokensWallet) onlyOwner {
543     bountyTokensWallet = newBountyTokensWallet;
544   }
545 
546   function createTokens() whenNotPaused isUnderHardCap saleIsOn payable {
547     require(msg.value > 0);
548     uint milestoneIndex = currentMilestone();
549     Milestone storage milestone = milestones[milestoneIndex];
550     multisigWallet.transfer(msg.value);
551     invested = invested.add(msg.value);
552     uint tokens = msg.value.mul(1 ether).div(price);
553     uint bonusTokens = tokens.mul(milestone.bonus).div(percentRate);
554     uint tokensWithBonus = tokens.add(bonusTokens);
555     token.mint(this, tokensWithBonus);
556     token.transfer(msg.sender, tokensWithBonus);
557   }
558 
559   function mintTokensToEralyInvestors() onlyOwner {
560     require(!earlyInvestorsMintedTokens);
561     for(uint i  = 0; i < presale.totalInvestors(); i++) {
562       address investorAddress = presale.investors(i);
563       uint invested = presale.balanceOf(investorAddress);
564       uint tokens = invested.mul(1 ether).div(price);
565       uint bonusTokens = tokens.mul(earlyInvestorsBonus).div(percentRate);
566       uint tokensWithBonus = tokens.add(bonusTokens);
567       token.mint(this, tokensWithBonus);
568       token.transfer(investorAddress, tokensWithBonus);
569     }
570     earlyInvestorsMintedTokens = true;
571   }
572 
573   function finishMinting() public whenNotPaused onlyOwner {
574     uint issuedTokenSupply = token.totalSupply();
575     uint summaryTokensPercent = bountyTokensPercent + foundersTokensPercent;
576     uint summaryFoundersTokens = issuedTokenSupply.mul(summaryTokensPercent).div(percentRate - summaryTokensPercent);
577     uint totalSupply = summaryFoundersTokens + issuedTokenSupply;
578     uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
579     uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
580     token.mint(this, foundersTokens);
581     token.transfer(foundersTokensWallet, foundersTokens);
582     token.mint(this, bountyTokens);
583     token.transfer(bountyTokensWallet, bountyTokens);
584     token.finishMinting();
585     token.allowTransfer();
586     token.transferOwnership(owner);
587   }
588 
589   function() external payable {
590     createTokens();
591   }
592 
593   function retrieveTokens(address anotherToken) public onlyOwner {
594     ERC20 alienToken = ERC20(anotherToken);
595     alienToken.transfer(multisigWallet, token.balanceOf(this));
596   }
597 
598 }