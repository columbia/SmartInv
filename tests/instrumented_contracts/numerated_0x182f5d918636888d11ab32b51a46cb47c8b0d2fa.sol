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
258   modifier notLocked() {
259     require(msg.sender == owner || msg.sender == saleAgent || mintingFinished);
260     _;
261   }
262 
263   function transfer(address _to, uint256 _value) public notLocked returns (bool) {
264     return super.transfer(_to, _value);
265   }
266 
267   function transferFrom(address from, address to, uint256 value) public notLocked returns (bool) {
268     return super.transferFrom(from, to, value);
269   }
270 
271   function setSaleAgent(address newSaleAgent) public {
272     require(saleAgent == msg.sender || owner == msg.sender);
273     saleAgent = newSaleAgent;
274   }
275 
276   function mint(address _to, uint256 _amount) public returns (bool) {
277     require(!mintingFinished);
278     require(msg.sender == saleAgent);
279     totalSupply = totalSupply.add(_amount);
280     balances[_to] = balances[_to].add(_amount);
281     Mint(_to, _amount);
282     Transfer(address(0), _to, _amount);
283     return true;
284   }
285 
286   function finishMinting() public returns (bool) {
287     require(!mintingFinished);
288     require(msg.sender == owner || msg.sender == saleAgent);
289     mintingFinished = true;
290     MintFinished();
291     return true;
292   }
293 
294 }
295 
296 contract CommonCrowdsale is Ownable, LockableChanges {
297 
298   using SafeMath for uint256;
299 
300   uint public constant PERCENT_RATE = 100;
301 
302   uint public price;
303 
304   uint public minInvestedLimit;
305 
306   uint public hardcap;
307 
308   uint public start;
309 
310   uint public end;
311 
312   uint public invested;
313 
314   uint public minted;
315   
316   address public wallet;
317 
318   address public bountyTokensWallet;
319 
320   address public devTokensWallet;
321 
322   address public advisorsTokensWallet;
323 
324   address public foundersTokensWallet;
325 
326   uint public bountyTokensPercent;
327 
328   uint public devTokensPercent;
329 
330   uint public advisorsTokensPercent;
331 
332   uint public foundersTokensPercent;
333 
334   struct Bonus {
335     uint periodInDays;
336     uint bonus;
337   }
338 
339   Bonus[] public bonuses;
340 
341   TWNSharesToken public token;
342 
343   modifier saleIsOn() {
344     require(msg.value >= minInvestedLimit && now >= start && now < end && invested < hardcap);
345     _;
346   }
347 
348   function setHardcap(uint newHardcap) public onlyOwner notLocked { 
349     hardcap = newHardcap;
350   }
351  
352   function setStart(uint newStart) public onlyOwner { 
353     start = newStart;
354   }
355 
356   function setBountyTokensPercent(uint newBountyTokensPercent) public onlyOwner { 
357     bountyTokensPercent = newBountyTokensPercent;
358   }
359 
360   function setFoundersTokensPercent(uint newFoundersTokensPercent) public onlyOwner { 
361     foundersTokensPercent = newFoundersTokensPercent;
362   }
363 
364   function setAdvisorsTokensPercent(uint newAdvisorsTokensPercent) public onlyOwner { 
365     advisorsTokensPercent = newAdvisorsTokensPercent;
366   }
367 
368   function setDevTokensPercent(uint newDevTokensPercent) public onlyOwner { 
369     devTokensPercent = newDevTokensPercent;
370   }
371 
372   function setFoundersTokensWallet(address newFoundersTokensWallet) public onlyOwner { 
373     foundersTokensWallet = newFoundersTokensWallet;
374   }
375 
376   function setBountyTokensWallet(address newBountyTokensWallet) public onlyOwner { 
377     bountyTokensWallet = newBountyTokensWallet;
378   }
379 
380   function setAdvisorsTokensWallet(address newAdvisorsTokensWallet) public onlyOwner { 
381     advisorsTokensWallet = newAdvisorsTokensWallet;
382   }
383 
384   function setDevTokensWallet(address newDevTokensWallet) public onlyOwner { 
385     devTokensWallet = newDevTokensWallet;
386   }
387 
388   function setEnd(uint newEnd) public onlyOwner { 
389     require(start < newEnd);
390     end = newEnd;
391   }
392 
393   function setToken(address newToken) public onlyOwner notLocked { 
394     token = TWNSharesToken(newToken);
395   }
396 
397   function setWallet(address newWallet) public onlyOwner notLocked { 
398     wallet = newWallet;
399   }
400 
401   function setPrice(uint newPrice) public onlyOwner notLocked {
402     price = newPrice;
403   }
404 
405   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner notLocked {
406     minInvestedLimit = newMinInvestedLimit;
407   }
408  
409   function bonusesCount() public constant returns(uint) {
410     return bonuses.length;
411   }
412 
413   function addBonus(uint limit, uint bonus) public onlyOwner notLocked {
414     bonuses.push(Bonus(limit, bonus));
415   }
416 
417   function mintExtendedTokens() internal {
418     uint extendedTokensPercent = bountyTokensPercent.add(devTokensPercent).add(advisorsTokensPercent).add(foundersTokensPercent);      
419     uint extendedTokens = minted.mul(extendedTokensPercent).div(PERCENT_RATE.sub(extendedTokensPercent));
420     uint summaryTokens = extendedTokens + minted;
421 
422     uint bountyTokens = summaryTokens.mul(bountyTokensPercent).div(PERCENT_RATE);
423     mintAndSendTokens(bountyTokensWallet, bountyTokens);
424 
425     uint advisorsTokens = summaryTokens.mul(advisorsTokensPercent).div(PERCENT_RATE);
426     mintAndSendTokens(advisorsTokensWallet, advisorsTokens);
427 
428     uint foundersTokens = summaryTokens.mul(foundersTokensPercent).div(PERCENT_RATE);
429     mintAndSendTokens(foundersTokensWallet, foundersTokens);
430 
431     uint devTokens = summaryTokens.mul(devTokensPercent).div(PERCENT_RATE);
432     mintAndSendTokens(devTokensWallet, devTokens);
433   }
434 
435   function mintAndSendTokens(address to, uint amount) internal {
436     token.mint(to, amount);
437     minted = minted.add(amount);
438   }
439 
440   function calculateAndTransferTokens() internal {
441     // update invested value
442     invested = invested.add(msg.value);
443 
444     // calculate tokens
445     uint tokens = msg.value.mul(price).div(1 ether);
446     uint bonus = getBonus();
447     if(bonus > 0) {
448       tokens = tokens.add(tokens.mul(bonus).div(100));      
449     }
450     
451     // transfer tokens
452     mintAndSendTokens(msg.sender, tokens);
453   }
454 
455   function getBonus() public constant returns(uint) {
456     uint prevTimeLimit = start;
457     for (uint i = 0; i < bonuses.length; i++) {
458       Bonus storage bonus = bonuses[i];
459       prevTimeLimit += bonus.periodInDays * 1 days;
460       if (now < prevTimeLimit)
461         return bonus.bonus;
462     }
463     return 0;
464   }
465 
466   function createTokens() public payable;
467 
468   function() external payable {
469     createTokens();
470   }
471 
472   function retrieveTokens(address anotherToken) public onlyOwner {
473     ERC20 alienToken = ERC20(anotherToken);
474     alienToken.transfer(wallet, alienToken.balanceOf(this));
475   }
476 
477 }
478 contract Presale is CommonCrowdsale {
479   
480   uint public devLimit;
481 
482   uint public softcap;
483   
484   bool public refundOn;
485 
486   bool public softcapAchieved;
487 
488   bool public devWithdrawn;
489 
490   address public devWallet;
491 
492   address public nextSaleAgent;
493 
494   mapping (address => uint) public balances;
495 
496   function setNextSaleAgent(address newNextSaleAgent) public onlyOwner {
497     nextSaleAgent = newNextSaleAgent;
498   }
499 
500   function setSoftcap(uint newSoftcap) public onlyOwner {
501     softcap = newSoftcap;
502   }
503 
504   function setDevWallet(address newDevWallet) public onlyOwner notLocked {
505     devWallet = newDevWallet;
506   }
507 
508   function setDevLimit(uint newDevLimit) public onlyOwner notLocked {
509     devLimit = newDevLimit;
510   }
511 
512   function refund() public {
513     require(now > start && refundOn && balances[msg.sender] > 0);
514     uint value = balances[msg.sender];
515     balances[msg.sender] = 0;
516     msg.sender.transfer(value);
517   } 
518 
519   function createTokens() public payable saleIsOn {
520     balances[msg.sender] = balances[msg.sender].add(msg.value);
521     calculateAndTransferTokens();
522     if(!softcapAchieved && invested >= softcap) {
523       softcapAchieved = true;      
524     }
525   } 
526 
527   function widthrawDev() public {
528     require(softcapAchieved);
529     require(devWallet == msg.sender || owner == msg.sender);
530     if(!devWithdrawn) {
531       devWithdrawn = true;
532       devWallet.transfer(devLimit);
533     }
534   } 
535 
536   function widthraw() public {
537     require(softcapAchieved);
538     require(owner == msg.sender);
539     widthrawDev();
540     wallet.transfer(this.balance);
541   } 
542 
543   function finishMinting() public onlyOwner {
544     if(!softcapAchieved) {
545       refundOn = true;      
546       token.finishMinting();
547     } else {
548       mintExtendedTokens();
549       token.setSaleAgent(nextSaleAgent);
550     }    
551   }
552 
553 }
554 
555 contract ICO is CommonCrowdsale {
556   
557   function finishMinting() public onlyOwner {
558     mintExtendedTokens();
559     token.finishMinting();
560   }
561 
562   function createTokens() public payable saleIsOn {
563     calculateAndTransferTokens();
564     wallet.transfer(msg.value);
565   } 
566 
567 }
568 
569 contract Deployer is Ownable {
570 
571   Presale public presale;  
572  
573   ICO public ico;
574 
575   TWNSharesToken public token;
576 
577   function deploy() public onlyOwner {
578     owner = 0x1c7315bc528F322909beDDA8F65b053546d98246;  
579       
580     token = new TWNSharesToken();
581     
582     presale = new Presale();
583     presale.setToken(token);
584     token.setSaleAgent(presale);
585     presale.setMinInvestedLimit(1000000000000000000);  
586     presale.setPrice(290000000000000000000);
587     presale.setBountyTokensPercent(2);
588     presale.setAdvisorsTokensPercent(1);
589     presale.setDevTokensPercent(10);
590     presale.setFoundersTokensPercent(10);
591     
592     // fix in prod
593     presale.setSoftcap(1000000000000000000000);
594     presale.setHardcap(20000000000000000000000);
595     presale.addBonus(1,40);
596     presale.addBonus(100,30);
597 //    presale.setStart( );
598 //    presale.setEnd( );    
599     presale.setDevLimit(6000000000000000000);
600     presale.setWallet(0xb710d808Ca41c030D14721363FF5608Eabc5bA91);
601     presale.setBountyTokensWallet(0x565d8E01c63EDF9A5D9F17278b3c2118940e81EF);
602     presale.setDevTokensWallet(0x2d509f95f7a5F400Ae79b22F40AfB7aCc60dE6ba);
603     presale.setAdvisorsTokensWallet(0xc422bd1dAc78b1610ab9bEC43EEfb1b81785667D);
604     presale.setFoundersTokensWallet(0xC8C959B4ae981CBCF032Ad05Bd5e60c326cbe35d);
605     presale.setDevWallet(0xEA15Adb66DC92a4BbCcC8Bf32fd25E2e86a2A770);
606 
607     ico = new ICO();
608     ico.setToken(token); 
609     presale.setNextSaleAgent(ico);
610     ico.setMinInvestedLimit(100000000000000000);
611     ico.setPrice(250000000000000000000);
612     ico.setBountyTokensPercent(2);
613     ico.setAdvisorsTokensPercent(1);
614     ico.setDevTokensPercent(10);
615     ico.setFoundersTokensPercent(10);
616 
617     // fix in prod
618     ico.setHardcap(50000000000000000000000);
619     ico.addBonus(7,25);
620     ico.addBonus(7,15);
621     ico.addBonus(100,10);
622 //    ico.setStart( );
623 //    ico.setEnd( );
624     ico.setWallet(0x87AF29276bA384b1Df9008Fd573155F7fC47E4D8);
625     ico.setBountyTokensWallet(0xeF0a993cC6067AD57a1A55A6B885aEF662334641);
626     ico.setDevTokensWallet(0xFa6229F284387F6ccDb61879c3C12D9896310DB3);
627     ico.setAdvisorsTokensWallet(0xb1f9C6653210D7551Ad24C7978B10Fb0bfE5C177);
628     ico.setFoundersTokensWallet(0x5CBB99ab4aa3EFf834217262db11D7486af7Cbfd);
629 
630     presale.lockChanges();
631     ico.lockChanges();
632     
633     presale.transferOwnership(owner);
634     ico.transferOwnership(owner);
635     token.transferOwnership(owner);
636   }
637 
638 }