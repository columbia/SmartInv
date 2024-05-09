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
240 contract TWNSharesToken is StandardToken, Ownable {	
241 
242   using SafeMath for uint256;
243 
244   event Mint(address indexed to, uint256 amount);
245 
246   event MintFinished();
247     
248   string public constant name = "TWN Shares";
249    
250   string public constant symbol = "TWN";
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
311   address public foundersTokensWallet;
312 
313   uint public bountyTokensPercent;
314 
315   uint public devTokensPercent;
316 
317   uint public advisorsTokensPercent;
318 
319   uint public foundersTokensPercent;
320 
321   struct Bonus {
322     uint periodInDays;
323     uint bonus;
324   }
325 
326   Bonus[] public bonuses;
327 
328   TWNSharesToken public token;
329 
330   modifier saleIsOn() {
331     require(msg.value >= minInvestedLimit && now >= start && now < end && invested < hardcap);
332     _;
333   }
334 
335   function setHardcap(uint newHardcap) public onlyOwner notLocked { 
336     hardcap = newHardcap;
337   }
338  
339   function setStart(uint newStart) public onlyOwner { 
340     start = newStart;
341   }
342 
343   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner { 
344     bountyTokensPercent = newBountyTokensPercent;
345   }
346 
347   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner { 
348     foundersTokensPercent = newFoundersTokensPercent;
349   }
350 
351   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner { 
352     advisorsTokensPercent = newAdvisorsTokensPercent;
353   }
354 
355   function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner { 
356     devTokensPercent = newDevTokensPercent;
357   }
358 
359   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner { 
360     foundersTokensWallet = newFoundersTokensWallet;
361   }
362 
363   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner { 
364     bountyTokensWallet = newBountyTokensWallet;
365   }
366 
367   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner { 
368     advisorsTokensWallet = newAdvisorsTokensWallet;
369   }
370 
371   function setDevTokensWallet(address newDevTokensWallet) public onlyOwner { 
372     devTokensWallet = newDevTokensWallet;
373   }
374 
375   function setEnd(uint newEnd) public onlyOwner { 
376     require(start < newEnd);
377     end = newEnd;
378   }
379 
380   function setToken(address newToken) public onlyOwner notLocked { 
381     token = TWNSharesToken(newToken);
382   }
383 
384   function setWallet(address newWallet) public onlyOwner notLocked { 
385     wallet = newWallet;
386   }
387 
388   function setPrice(uint newPrice) public onlyOwner notLocked {
389     price = newPrice;
390   }
391 
392   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner notLocked {
393     minInvestedLimit = newMinInvestedLimit;
394   }
395  
396   function bonusesCount() public constant returns(uint) {
397     return bonuses.length;
398   }
399 
400   function addBonus(uint limit, uint bonus) public onlyOwner notLocked {
401     bonuses.push(Bonus(limit, bonus));
402   }
403 
404   function mintExtendedTokens() internal {
405     uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent).add(foundersTokensPercent);      
406     uint extendedTokens = minted.mul(extendedTokensPercent).div(PERCENT_RATE.sub(extendedTokensPercent));
407     uint summaryTokens = extendedTokens + minted;
408 
409     uint bountyTokens = summaryTokens.mul(bountyTokensPercent).div(PERCENT_RATE);
410     mintAndSendTokens(bountyTokensWallet, bountyTokens);
411 
412     uint advisorsTokens = summaryTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);
413     mintAndSendTokens(advisorsTokensWallet, advisorsTokens);
414 
415     uint foundersTokens = summaryTokens.mul(foundersTokensPercent).div(PERCENT_RATE);
416     mintAndSendTokens(foundersTokensWallet, foundersTokens);
417 
418     uint devTokens = summaryTokens.sub(advisorsTokens).sub(bountyTokens);
419     mintAndSendTokens(devTokensWallet, devTokens);
420   }
421 
422   function mintAndSendTokens(address to, uint amount) internal {
423     token.mint(to, amount);
424     minted = minted.add(amount);
425   }
426 
427   function calculateAndTransferTokens() internal {
428     // update invested value
429     invested = invested.add(msg.value);
430 
431     // calculate tokens
432     uint tokens = msg.value.mul(price).div(1 ether);
433     uint bonus = getBonus();
434     if(bonus > 0) {
435       tokens = tokens.add(tokens.mul(bonus).div(100));      
436     }
437     
438     // transfer tokens
439     mintAndSendTokens(msg.sender, tokens);
440   }
441 
442   function getBonus() public constant returns(uint) {
443     uint prevTimeLimit = start;
444     for (uint i = 0; i < bonuses.length; i++) {
445       Bonus storage bonus = bonuses[i];
446       prevTimeLimit += bonus.periodInDays * 1 days;
447       if (now < prevTimeLimit)
448         return bonus.bonus;
449     }
450     return 0;
451   }
452 
453   function createTokens() public payable;
454 
455   function() external payable {
456     createTokens();
457   }
458 
459   function retrieveTokens(address anotherToken) public onlyOwner {
460     ERC20 alienToken = ERC20(anotherToken);
461     alienToken.transfer(wallet, alienToken.balanceOf(this));
462   }
463 
464 }
465 contract Presale is CommonCrowdsale {
466   
467   uint public devLimit;
468 
469   uint public softcap;
470   
471   bool public refundOn;
472 
473   bool public softcapAchieved;
474 
475   bool public devWithdrawn;
476 
477   address public devWallet;
478 
479   address public nextSaleAgent;
480 
481   mapping (address => uint) public balances;
482 
483   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
484     nextSaleAgent = newNextSaleAgent;
485   }
486 
487   function setSoftcap(uint newSoftcap) public onlyOwner {
488     softcap = newSoftcap;
489   }
490 
491   function setDevWallet(address newDevWallet) public onlyOwner notLocked {
492     devWallet = newDevWallet;
493   }
494 
495   function setDevLimit(uint newDevLimit) public onlyOwner notLocked {
496     devLimit = newDevLimit;
497   }
498 
499   function refund() public {
500     require(now > start && refundOn && balances[msg.sender] > 0);
501     uint value = balances[msg.sender];
502     balances[msg.sender] = 0;
503     msg.sender.transfer(value);
504   } 
505 
506   function createTokens() public payable saleIsOn {
507     balances[msg.sender] = balances[msg.sender].add(msg.value);
508     calculateAndTransferTokens();
509     if(!softcapAchieved && invested >= softcap) {
510       softcapAchieved = true;      
511     }
512   } 
513 
514   function widthrawDev() public {
515     require(softcapAchieved);
516     require(devWallet == msg.sender || owner == msg.sender);
517     if(!devWithdrawn) {
518       devWithdrawn = true;
519       devWallet.transfer(devLimit);
520     }
521   } 
522 
523   function widthraw() public {
524     require(softcapAchieved);
525     require(owner == msg.sender);
526     widthrawDev();
527     wallet.transfer(this.balance);
528   } 
529 
530   function finishMinting() public onlyOwner {
531     if(!softcapAchieved) {
532       refundOn = true;      
533       token.finishMinting();
534     } else {
535       mintExtendedTokens();
536       token.setSaleAgent(nextSaleAgent);
537     }    
538   }
539 
540 }
541 
542 contract ICO is CommonCrowdsale {
543   
544   function finishMinting() public onlyOwner {
545     mintExtendedTokens();
546     token.finishMinting();
547   }
548 
549   function createTokens() public payable saleIsOn {
550     calculateAndTransferTokens();
551     wallet.transfer(msg.value);
552   } 
553 
554 }
555 
556 contract Deployer is Ownable {
557 
558   Presale public presale;  
559  
560   ICO public ico;
561 
562   TWNSharesToken public token;
563 
564   function deploy() public onlyOwner {
565     owner = 0x1c7315bc528F322909beDDA8F65b053546d98246;  
566       
567     token = new TWNSharesToken();
568     
569     presale = new Presale();
570     presale.setToken(token);
571     token.setSaleAgent(presale);
572     presale.setMinInvestedLimit(1000000000000000000);  
573     presale.setPrice(290000000000000000000);
574     presale.setBountyTokensPercent(2);
575     presale.setAdvisorsTokensPercent(1);
576     presale.setDevTokensPercent(10);
577     presale.setFoundersTokensPercent(10);
578     
579     // fix in prod
580     presale.setSoftcap(1000000000000000000000);
581     presale.setHardcap(20000000000000000000000);
582     presale.addBonus(1,40);
583     presale.addBonus(100,30);
584 //    presale.setStart( );
585 //    presale.setEnd( );    
586     presale.setDevLimit(6000000000000000000);
587     presale.setWallet(0xb710d808Ca41c030D14721363FF5608Eabc5bA91);
588     presale.setBountyTokensWallet(0x565d8E01c63EDF9A5D9F17278b3c2118940e81EF);
589     presale.setDevTokensWallet(0x2d509f95f7a5F400Ae79b22F40AfB7aCc60dE6ba);
590     presale.setAdvisorsTokensWallet(0xc422bd1dAc78b1610ab9bEC43EEfb1b81785667D);
591     presale.setFoundersTokensWallet(0xC8C959B4ae981CBCF032Ad05Bd5e60c326cbe35d);
592     presale.setDevWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
593 
594     ico = new ICO();
595     ico.setToken(token); 
596     presale.setNextSaleAgent(ico);
597     ico.setMinInvestedLimit(100000000000000000);
598     ico.setPrice(250000000000000000000);
599     ico.setBountyTokensPercent(2);
600     ico.setAdvisorsTokensPercent(1);
601     ico.setDevTokensPercent(10);
602     ico.setFoundersTokensPercent(10);
603 
604     // fix in prod
605     ico.setHardcap(50000000000000000000000);
606     ico.addBonus(7,25);
607     ico.addBonus(7,15);
608     ico.addBonus(100,10);
609 //    ico.setStart( );
610 //    ico.setEnd( );
611     ico.setWallet(0x87AF29276bA384b1Df9008Fd573155F7fC47E4D8);
612     ico.setBountyTokensWallet(0xeF0a993cC6067AD57a1A55A6B885aEF662334641);
613     ico.setDevTokensWallet(0xFa6229F284387F6ccDb61879c3C12D9896310DB3);
614     ico.setAdvisorsTokensWallet(0xb1f9C6653210D7551Ad24C7978B10Fb0bfE5C177);
615     ico.setFoundersTokensWallet(0x5CBB99ab4aa3EFf834217262db11D7486af7Cbfd);
616 
617     presale.lockChanges();
618     ico.lockChanges();
619     
620     presale.transferOwnership(owner);
621     ico.transferOwnership(owner);
622     token.transferOwnership(owner);
623   }
624 
625 }