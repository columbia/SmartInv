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
209   /**
210    * @dev Function to mint tokens
211    * @param _to The address that will recieve the minted tokens.
212    * @param _amount The amount of tokens to mint.
213    * @return A boolean that indicates if the operation was successful.
214    */
215   function mint(address _to, uint256 _amount) returns (bool) {
216     require(msg.sender == saleAgent && !mintingFinished);
217     totalSupply = totalSupply.add(_amount);
218     balances[_to] = balances[_to].add(_amount);
219     Mint(_to, _amount);
220     return true;
221   }
222 
223   /**
224    * @dev Function to stop minting new tokens.
225    * @return True if the operation was successful.
226    */
227   function finishMinting() returns (bool) {
228     require(msg.sender == saleAgent || msg.sender == owner && !mintingFinished);
229     mintingFinished = true;
230     MintFinished();
231     return true;
232   }
233   
234 }
235 
236 /**
237  * @title Pausable
238  * @dev Base contract which allows children to implement an emergency stop mechanism.
239  */
240 contract Pausable is Ownable {
241     
242   event Pause();
243   
244   event Unpause();
245 
246   bool public paused = false;
247 
248   /**
249    * @dev modifier to allow actions only when the contract IS paused
250    */
251   modifier whenNotPaused() {
252     require(!paused);
253     _;
254   }
255 
256   /**
257    * @dev modifier to allow actions only when the contract IS NOT paused
258    */
259   modifier whenPaused() {
260     require(paused);
261     _;
262   }
263 
264   /**
265    * @dev called by the owner to pause, triggers stopped state
266    */
267   function pause() onlyOwner whenNotPaused {
268     paused = true;
269     Pause();
270   }
271 
272   /**
273    * @dev called by the owner to unpause, returns to normal state
274    */
275   function unpause() onlyOwner whenPaused {
276     paused = false;
277     Unpause();
278   }
279   
280 }
281 
282 contract TlindToken is MintableToken {	
283     
284   string public constant name = "Tlind";
285    
286   string public constant symbol = "TDT";
287     
288   uint32 public constant decimals = 18;
289     
290 }
291 
292 
293 contract StagedCrowdsale is Pausable {
294 
295   using SafeMath for uint;
296 
297   struct Milestone {
298     uint period;
299     uint bonus;
300   }
301 
302   uint public start;
303 
304   uint public totalPeriod;
305 
306   uint public invested;
307 
308   uint public hardCap;
309  
310   Milestone[] public milestones;
311 
312   function milestonesCount() constant returns(uint) {
313     return milestones.length;
314   }
315 
316   function setStart(uint newStart) onlyOwner {
317     start = newStart;
318   }
319 
320   function setHardcap(uint newHardcap) onlyOwner {
321     hardCap = newHardcap;
322   }
323 
324   function addMilestone(uint period, uint bonus) onlyOwner {
325     require(period > 0);
326     milestones.push(Milestone(period, bonus));
327     totalPeriod = totalPeriod.add(period);
328   }
329 
330   function removeMilestones(uint8 number) onlyOwner {
331     require(number < milestones.length);
332     Milestone storage milestone = milestones[number];
333     totalPeriod = totalPeriod.sub(milestone.period);
334 
335     delete milestones[number];
336 
337     for (uint i = number; i < milestones.length - 1; i++) {
338       milestones[i] = milestones[i+1];
339     }
340 
341     milestones.length--;
342   }
343 
344   function changeMilestone(uint8 number, uint period, uint bonus) onlyOwner {
345     require(number < milestones.length);
346     Milestone storage milestone = milestones[number];
347 
348     totalPeriod = totalPeriod.sub(milestone.period);    
349 
350     milestone.period = period;
351     milestone.bonus = bonus;
352 
353     totalPeriod = totalPeriod.add(period);    
354   }
355 
356   function insertMilestone(uint8 numberAfter, uint period, uint bonus) onlyOwner {
357     require(numberAfter < milestones.length);
358 
359     totalPeriod = totalPeriod.add(period);
360 
361     milestones.length++;
362 
363     for (uint i = milestones.length - 2; i > numberAfter; i--) {
364       milestones[i + 1] = milestones[i];
365     }
366 
367     milestones[numberAfter + 1] = Milestone(period, bonus);
368   }
369 
370   function clearMilestones() onlyOwner {
371     require(milestones.length > 0);
372     for (uint i = 0; i < milestones.length; i++) {
373       delete milestones[i];
374     }
375     milestones.length -= milestones.length;
376     totalPeriod = 0;
377   }
378 
379   modifier saleIsOn() {
380     require(milestones.length > 0 && now >= start && now < lastSaleDate());
381     _;
382   }
383   
384   modifier isUnderHardCap() {
385     require(invested <= hardCap);
386     _;
387   }
388   
389   function lastSaleDate() constant returns(uint) {
390     require(milestones.length > 0);
391     return start + totalPeriod * 1 days;
392   }
393 
394   function currentMilestone() saleIsOn constant returns(uint) {
395     uint previousDate = start;
396     for(uint i=0; i < milestones.length; i++) {
397       if(now >= previousDate && now < previousDate + milestones[i].period * 1 days) {
398         return i;
399       }
400       previousDate = previousDate.add(milestones[i].period * 1 days);
401     }
402     revert();
403   }
404 
405 }
406 
407 contract CommonSale is StagedCrowdsale {
408 
409   address public multisigWallet;
410   
411   address public foundersTokensWallet;
412   
413   address public bountyTokensWallet;
414 
415   uint public foundersTokensPercent;
416   
417   uint public bountyTokensPercent;
418  
419   uint public price;
420 
421   uint public percentRate = 100;
422 
423   uint public softcap;
424 
425   bool public refundOn = false;
426 
427   bool public isSoftcapOn = false;
428 
429   mapping (address => uint) balances;
430 
431   CommonSale public nextSale;
432   
433   MintableToken public token;
434 
435   function setSoftcap(uint newSoftcap) onlyOwner {
436     isSoftcapOn = true;
437     softcap = newSoftcap;
438   }
439 
440   function setToken(address newToken) onlyOwner {
441     token = MintableToken(newToken);
442   }
443 
444   function setNextSale(address newNextSale) onlyOwner {
445     nextSale = CommonSale(newNextSale);
446   }
447 
448   function setPrice(uint newPrice) onlyOwner {
449     price = newPrice;
450   }
451 
452   function setPercentRate(uint newPercentRate) onlyOwner {
453     percentRate = newPercentRate;
454   }
455 
456   function setFoundersTokensPercent(uint newFoundersTokensPercent) onlyOwner {
457     foundersTokensPercent = newFoundersTokensPercent;
458   }
459   
460   function setBountyTokensPercent(uint newBountyTokensPercent) onlyOwner {
461     bountyTokensPercent = newBountyTokensPercent;
462   }
463   
464   function setMultisigWallet(address newMultisigWallet) onlyOwner {
465     multisigWallet = newMultisigWallet;
466   }
467 
468   function setFoundersTokensWallet(address newFoundersTokensWallet) onlyOwner {
469     foundersTokensWallet = newFoundersTokensWallet;
470   }
471 
472   function setBountyTokensWallet(address newBountyTokensWallet) onlyOwner {
473     bountyTokensWallet = newBountyTokensWallet;
474   }
475 
476   function createTokens() whenNotPaused isUnderHardCap saleIsOn payable {
477     require(msg.value >= 100000000000000000);
478     uint milestoneIndex = currentMilestone();
479     Milestone storage milestone = milestones[milestoneIndex];
480     if(!isSoftcapOn) {
481       multisigWallet.transfer(msg.value);
482     }
483     invested = invested.add(msg.value);
484     uint tokens = msg.value.mul(1 ether).div(price);
485     uint bonusTokens = tokens.mul(milestone.bonus).div(percentRate);
486     uint tokensWithBonus = tokens.add(bonusTokens);
487     token.mint(this, tokensWithBonus);
488     token.transfer(msg.sender, tokensWithBonus);
489     balances[msg.sender] = balances[msg.sender].add(msg.value);
490   }
491 
492   function refund() whenNotPaused {
493     require(now > start && refundOn && balances[msg.sender] > 0);
494     msg.sender.transfer(balances[msg.sender]);
495   } 
496 
497   function finishMinting() public whenNotPaused onlyOwner {
498     if(isSoftcapOn && invested < softcap) {
499       refundOn = true;
500       token.finishMinting();
501     } else {
502       if(isSoftcapOn) {
503         multisigWallet.transfer(invested);
504       }
505       uint issuedTokenSupply = token.totalSupply();
506       uint summaryTokensPercent = bountyTokensPercent + foundersTokensPercent;
507       uint summaryFoundersTokens = issuedTokenSupply.mul(summaryTokensPercent).div(percentRate - summaryTokensPercent);
508       uint totalSupply = summaryFoundersTokens + issuedTokenSupply;
509       uint foundersTokens = totalSupply.mul(foundersTokensPercent).div(percentRate);
510       uint bountyTokens = totalSupply.mul(bountyTokensPercent).div(percentRate);
511       token.mint(this, foundersTokens);
512       token.transfer(foundersTokensWallet, foundersTokens);
513       token.mint(this, bountyTokens);
514       token.transfer(bountyTokensWallet, bountyTokens);
515       if(nextSale == address(0)) {
516         token.finishMinting();
517       } else {
518         token.setSaleAgent(nextSale);
519       }
520     }
521   }
522 
523   function() external payable {
524     createTokens();
525   }
526 
527   function retrieveTokens(address anotherToken) public onlyOwner {
528     ERC20 alienToken = ERC20(anotherToken);
529     alienToken.transfer(multisigWallet, token.balanceOf(this));
530   }
531 
532 }
533 
534 contract Configurator is Ownable {
535 
536   MintableToken public token; 
537 
538   CommonSale public presale;
539 
540   CommonSale public mainsale;
541 
542   function deploy() {
543     address presaleMultisigWallet = 0x675cf930aefA144dA7e10ddBACC02f902A233eFC;
544     address presaleBountyTokensWallet = 0x06B8fF8476425E45A3D2878e0a27BB79efd4Dde1;
545     address presaleFoundersWallet = 0x27F1Ac3E29CBec9D225d98fF95B6933bD30E3F71;
546     uint presaleSoftcap = 50000000000000000000;
547     uint presaleHardcap = 2000000000000000000000;
548 
549     address mainsaleMultisigWallet = 0xFb72502E9c56497BAC3B1c21DE434b371891CC05;
550     address mainsaleBountyTokensWallet = 0xd08112054C8e01E33fAEE176531dEB087809CbB2;
551     address mainsaleFoundersWallet = 0xDeFAE9a126bA5aA2537AaC481D9335827159D33B;
552     uint mainsaleHardcap = 25000000000000000000000000;
553 
554     token = new TlindToken();
555 
556     presale = new CommonSale();
557 
558     presale.setToken(token);
559     presale.setSoftcap(presaleSoftcap);
560     presale.setHardcap(presaleHardcap);
561     presale.setMultisigWallet(presaleMultisigWallet);
562     presale.setFoundersTokensWallet(presaleFoundersWallet);
563     presale.setBountyTokensWallet(presaleBountyTokensWallet);
564     presale.setStart(1506344400);
565     presale.setFoundersTokensPercent(15);
566     presale.setBountyTokensPercent(5);
567     presale.setPrice(10000000000000000);
568     presale.addMilestone(8,200);
569     presale.addMilestone(8,100);
570     token.setSaleAgent(presale);	
571 
572     mainsale = new CommonSale();
573 
574     mainsale.setToken(token);
575     mainsale.setHardcap(mainsaleHardcap);
576     mainsale.setMultisigWallet(mainsaleMultisigWallet);
577     mainsale.setFoundersTokensWallet(mainsaleFoundersWallet);
578     mainsale.setBountyTokensWallet(mainsaleBountyTokensWallet);
579     mainsale.setStart(1510318800);
580     mainsale.setFoundersTokensPercent(15);
581     mainsale.setBountyTokensPercent(5);
582     mainsale.setPrice(10000000000000000);
583     mainsale.addMilestone(1,50);
584     mainsale.addMilestone(6,30);
585     mainsale.addMilestone(14,15);
586     mainsale.addMilestone(14,10);
587     mainsale.addMilestone(14,5);
588     mainsale.addMilestone(7,0);
589     
590     presale.setNextSale(mainsale);
591 
592     token.transferOwnership(owner);
593     presale.transferOwnership(owner);
594     mainsale.transferOwnership(owner);
595   }
596 
597 }