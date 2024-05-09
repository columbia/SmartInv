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
219 contract LockableChanges is Ownable {
220     
221   bool public changesLocked;
222   
223   modifier notLocked() {
224     require(!changesLocked);
225     _;
226   }
227   
228   function lockChanges() public onlyOwner {
229     changesLocked = true;
230   }
231     
232 }
233 
234 /**
235  * @title Mintable token
236  * @dev Simple ERC20 Token example, with mintable token creation
237  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
238  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
239  */
240 contract GENSharesToken is StandardToken, Ownable {	
241 
242   using SafeMath for uint256;
243 
244   event Mint(address indexed to, uint256 amount);
245 
246   event MintFinished();
247     
248   string public constant name = "GEN Shares";
249    
250   string public constant symbol = "GEN";
251     
252   uint32 public constant decimals = 18;
253 
254   bool public mintingFinished = false;
255  
256   address public saleAgent;
257 
258   function setSaleAgent(address newSaleAgent) public {
259     require(saleAgent == msg.sender || owner == msg.sender);
260     saleAgent = newSaleAgent;
261   }
262 
263   function mint(address _to, uint256 _amount) public returns (bool) {
264     require(!mintingFinished);
265     require(msg.sender == saleAgent);
266     totalSupply = totalSupply.add(_amount);
267     balances[_to] = balances[_to].add(_amount);
268     Mint(_to, _amount);
269     Transfer(address(0), _to, _amount);
270     return true;
271   }
272 
273   function finishMinting() public returns (bool) {
274     require(!mintingFinished);
275     require(msg.sender == owner || msg.sender == saleAgent);
276     mintingFinished = true;
277     MintFinished();
278     return true;
279   }
280 
281 }
282 
283 contract CommonCrowdsale is Ownable, LockableChanges {
284 
285   using SafeMath for uint256;
286 
287   uint public constant PERCENT_RATE = 100;
288 
289   uint public price;
290 
291   uint public minInvestedLimit;
292 
293   uint public hardcap;
294 
295   uint public start;
296 
297   uint public end;
298 
299   uint public invested;
300 
301   uint public minted;
302   
303   address public wallet;
304 
305   address public bountyTokensWallet;
306 
307   address public devTokensWallet;
308 
309   address public advisorsTokensWallet;
310 
311   uint public bountyTokensPercent;
312 
313   uint public devTokensPercent;
314 
315   uint public advisorsTokensPercent;
316 
317   struct Bonus {
318     uint periodInDays;
319     uint bonus;
320   }
321 
322   Bonus[] public bonuses;
323 
324   GENSharesToken public token;
325 
326   modifier saleIsOn() {
327     require(msg.value >= minInvestedLimit && now >= start && now < end && invested < hardcap);
328     _;
329   }
330 
331   function setHardcap(uint newHardcap) public onlyOwner notLocked { 
332     hardcap = newHardcap;
333   }
334  
335   function setStart(uint newStart) public onlyOwner notLocked { 
336     start = newStart;
337   }
338 
339   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner notLocked { 
340     bountyTokensPercent = newBountyTokensPercent;
341   }
342 
343   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner notLocked { 
344     advisorsTokensPercent = newAdvisorsTokensPercent;
345   }
346 
347   function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner notLocked { 
348     devTokensPercent = newDevTokensPercent;
349   }
350 
351   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner notLocked { 
352     bountyTokensWallet = newBountyTokensWallet;
353   }
354 
355   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner notLocked { 
356     advisorsTokensWallet = newAdvisorsTokensWallet;
357   }
358 
359   function setDevTokensWallet(address newDevTokensWallet) public onlyOwner notLocked { 
360     devTokensWallet = newDevTokensWallet;
361   }
362 
363   function setEnd(uint newEnd) public onlyOwner notLocked { 
364     require(start < newEnd);
365     end = newEnd;
366   }
367 
368   function setToken(address newToken) public onlyOwner notLocked { 
369     token = GENSharesToken(newToken);
370   }
371 
372   function setWallet(address newWallet) public onlyOwner notLocked { 
373     wallet = newWallet;
374   }
375 
376   function setPrice(uint newPrice) public onlyOwner notLocked {
377     price = newPrice;
378   }
379 
380   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner notLocked {
381     minInvestedLimit = newMinInvestedLimit;
382   }
383  
384   function bonusesCount() public constant returns(uint) {
385     return bonuses.length;
386   }
387 
388   function addBonus(uint limit, uint bonus) public onlyOwner notLocked {
389     bonuses.push(Bonus(limit, bonus));
390   }
391 
392   function mintExtendedTokens() internal {
393     uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent);      
394     uint extendedTokens = minted.mul(extendedTokensPercent).div(PERCENT_RATE.sub(extendedTokensPercent));
395     uint summaryTokens = extendedTokens + minted;
396 
397     uint bountyTokens = summaryTokens.mul(bountyTokensPercent).div(PERCENT_RATE);
398     mintAndSendTokens(bountyTokensWallet, bountyTokens);
399 
400     uint advisorsTokens = summaryTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);
401     mintAndSendTokens(advisorsTokensWallet, advisorsTokens);
402 
403     uint devTokens = summaryTokens.sub(advisorsTokens).sub(bountyTokens);
404     mintAndSendTokens(devTokensWallet, devTokens);
405   }
406 
407   function mintAndSendTokens(address to, uint amount) internal {
408     token.mint(to, amount);
409     minted = minted.add(amount);
410   }
411 
412   function calculateAndTransferTokens() internal {
413     // update invested value
414     invested = invested.add(msg.value);
415 
416     // calculate tokens
417     uint tokens = msg.value.mul(price).div(1 ether);
418     uint bonus = getBonus();
419     if(bonus > 0) {
420       tokens = tokens.add(tokens.mul(bonus).div(100));      
421     }
422     
423     // transfer tokens
424     mintAndSendTokens(msg.sender, tokens);
425   }
426 
427   function getBonus() public constant returns(uint) {
428     uint prevTimeLimit = start;
429     for (uint i = 0; i < bonuses.length; i++) {
430       Bonus storage bonus = bonuses[i];
431       prevTimeLimit += bonus.periodInDays * 1 days;
432       if (now < prevTimeLimit)
433         return bonus.bonus;
434     }
435     return 0;
436   }
437 
438   function createTokens() public payable;
439 
440   function() external payable {
441     createTokens();
442   }
443 
444   function retrieveTokens(address anotherToken) public onlyOwner {
445     ERC20 alienToken = ERC20(anotherToken);
446     alienToken.transfer(wallet, token.balanceOf(this));
447   }
448 
449 }
450 
451 contract Presale is CommonCrowdsale {
452   
453   uint public devLimit;
454 
455   uint public softcap;
456   
457   bool public refundOn;
458 
459   bool public softcapAchieved;
460 
461   bool public devWithdrawn;
462 
463   address public devWallet;
464 
465   address public nextSaleAgent;
466 
467   mapping (address => uint) public balances;
468 
469   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner notLocked {
470     nextSaleAgent = newNextSaleAgent;
471   }
472 
473   function setSoftcap(uint newSoftcap) public onlyOwner notLocked {
474     softcap = newSoftcap;
475   }
476 
477   function setDevWallet(address newDevWallet) public onlyOwner notLocked {
478     devWallet = newDevWallet;
479   }
480 
481   function setDevLimit(uint newDevLimit) public onlyOwner notLocked {
482     devLimit = newDevLimit;
483   }
484 
485   function refund() public {
486     require(now > start && refundOn && balances[msg.sender] > 0);
487     uint value = balances[msg.sender];
488     balances[msg.sender] = 0;
489     msg.sender.transfer(value);
490   } 
491 
492   function createTokens() public payable saleIsOn {
493     balances[msg.sender] = balances[msg.sender].add(msg.value);
494     calculateAndTransferTokens();
495     if(!softcapAchieved && invested >= softcap) {
496       softcapAchieved = true;      
497     }
498   } 
499 
500   function widthrawDev() public {
501     require(softcapAchieved);
502     require(devWallet == msg.sender || owner == msg.sender);
503     if(!devWithdrawn) {
504       devWithdrawn = true;
505       devWallet.transfer(devLimit);
506     }
507   } 
508 
509   function widthraw() public {
510     require(softcapAchieved);
511     require(owner == msg.sender);
512     widthrawDev();
513     wallet.transfer(this.balance);
514   } 
515 
516   function finishMinting() public onlyOwner {
517     if(!softcapAchieved) {
518       refundOn = true;      
519       token.finishMinting();
520     } else {
521       mintExtendedTokens();
522       token.setSaleAgent(nextSaleAgent);
523     }    
524   }
525 
526 }
527 
528 contract ICO is CommonCrowdsale {
529   
530   function finishMinting() public onlyOwner {
531     mintExtendedTokens();
532     token.finishMinting();
533   }
534 
535   function createTokens() public payable saleIsOn {
536     calculateAndTransferTokens();
537     wallet.transfer(msg.value);
538   } 
539 
540 }
541 
542 contract Deployer is Ownable {
543 
544   Presale public presale;  
545  
546   ICO public ico;
547 
548   GENSharesToken public token;
549 
550   function deploy() public onlyOwner {
551     owner = 0x379264aF7df7CF8141a23bC989aa44266DDD2c62;  
552       
553     token = new GENSharesToken();
554     
555     presale = new Presale();
556     presale.setToken(token);
557     token.setSaleAgent(presale);
558     presale.setMinInvestedLimit(100000000000000000);  
559     presale.setPrice(250000000000000000000);
560     presale.setBountyTokensPercent(4);
561     presale.setAdvisorsTokensPercent(2);
562     presale.setDevTokensPercent(10);
563     presale.setSoftcap(46000000000000000000);
564     presale.setHardcap(50000000000000000000000);
565     presale.addBonus(7,50);
566     presale.addBonus(7,40);
567     presale.addBonus(100,35);
568     presale.setStart(1511571600);
569     presale.setEnd(1514156400);    
570     presale.setDevLimit(6000000000000000000);
571     presale.setWallet(0x4bB656423f5476FeC4AA729aB7B4EE0fc4d0B314);
572     presale.setBountyTokensWallet(0xcACBE5d8Fb017407907026804Fe8BE64B08511f4);
573     presale.setDevTokensWallet(0xa20C62282bEC52F9dA240dB8cFFc5B2fc8586652);
574     presale.setAdvisorsTokensWallet(0xD3D85a495c7E25eAd39793F959d04ACcDf87e01b);
575     presale.setDevWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
576 
577     ico = new ICO();
578     ico.setToken(token); 
579     presale.setNextSaleAgent(ico);
580     ico.setMinInvestedLimit(100000000000000000);
581     ico.setPrice(250000000000000000000);
582     ico.setBountyTokensPercent(4);
583     ico.setAdvisorsTokensPercent(2);
584     ico.setDevTokensPercent(10);
585 
586     ico.setHardcap(206000000000000000000000);
587     ico.addBonus(7,25);
588     ico.addBonus(14,10);
589     ico.setStart(1514163600);
590     ico.setEnd(1517356800);
591     ico.setWallet(0x65954fb8f45b40c9A60dffF3c8f4F39839Bf3596);
592     ico.setBountyTokensWallet(0x6b9f45A54cDe417640f7D49D13451D7e2e9b8918);
593     ico.setDevTokensWallet(0x55A9E5b55F067078E045c72088C3888Bbcd9a64b);
594     ico.setAdvisorsTokensWallet(0x3e11Ff0BDd160C1D85cdf04e012eA9286ae1A964);
595 
596     presale.lockChanges();
597     ico.lockChanges();
598     
599     presale.transferOwnership(owner);
600     ico.transferOwnership(owner);
601     token.transferOwnership(owner);
602   }
603 
604 }