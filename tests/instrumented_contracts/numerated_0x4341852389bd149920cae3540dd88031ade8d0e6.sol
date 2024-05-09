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
227   event Mint(address indexed to, uint256 amount);
228   event MintFinished();
229 
230   bool public mintingFinished = false;
231 
232 
233   modifier canMint() {
234     require(!mintingFinished);
235     _;
236   }
237 
238   /**
239    * @dev Function to mint tokens
240    * @param _to The address that will receive the minted tokens.
241    * @param _amount The amount of tokens to mint.
242    * @return A boolean that indicates if the operation was successful.
243    */
244   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
245     totalSupply = totalSupply.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     Mint(_to, _amount);
248     Transfer(address(0), _to, _amount);
249     return true;
250   }
251 
252   /**
253    * @dev Function to stop minting new tokens.
254    * @return True if the operation was successful.
255    */
256   function finishMinting() onlyOwner public returns (bool) {
257     mintingFinished = true;
258     MintFinished();
259     return true;
260   }
261 }
262 
263 contract MilkCoinToken is MintableToken {	
264  
265   event Burn(address indexed burner, uint256 value);
266 
267   uint public constant PERCENT_RATE = 100;
268 
269   uint public constant BUY_BACK_BONUS = 20;
270    
271   string public constant name = "Milkcoin";
272    
273   string public constant symbol = "MLCN";
274     
275   uint8 public constant decimals = 2;
276 
277   uint public invested;
278 
279   uint public tokensAfterCrowdsale;
280 
281   uint public startBuyBackDate;
282 
283   uint public endBuyBackDate;
284 
285   uint public toBuyBack;
286 
287   bool public dividendsCalculated;
288 
289   uint public dividendsIndex;
290 
291   uint public dividendsPayedIndex;
292       
293   bool public dividendsPayed;
294 
295   uint public ethToDividendsNeeds;
296 
297   uint public buyBackInvestedValue;
298 
299   address[] public addresses;
300 
301   mapping(address => bool) public savedAddresses;
302 
303   mapping(address => uint) public dividends;
304 
305   mapping(address => bool) public lockAddresses;
306 
307   function addAddress(address addr) internal {
308     if(!savedAddresses[addr]) {
309        savedAddresses[addr] = true;
310        addresses.push(addr); 
311     }
312   }
313 
314   function countOfAddresses() public constant returns(uint) {
315     return addresses.length;
316   }
317 
318   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
319     bool result = super.mint(_to, _amount);
320     if(result) {
321       addAddress(_to);
322     }
323     return result;
324   }
325 
326   function transfer(address _to, uint256 _value) public returns (bool) {
327     return postProcessTransfer(super.transfer(_to, _value), msg.sender, _to, _value);
328   }
329 
330   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
331     return postProcessTransfer(super.transferFrom(_from, _to, _value), _from, _to, _value);
332   }
333 
334   function postProcessTransfer(bool result, address _from, address _to, uint256 _value) internal returns (bool) {
335     if(result) {
336       if(_to == address(this)) {
337         buyBack(_from, _value);
338       } else { 
339         addAddress(_to);
340       }
341     }
342     return result;
343   }
344 
345   function buyBack(address from, uint amount) internal {
346     if(now > endBuyBackDate) {
347       startBuyBackDate = endBuyBackDate;
348       endBuyBackDate = startBuyBackDate + 1 years;      
349       toBuyBack = tokensAfterCrowdsale.div(10);
350     }
351     require(now > startBuyBackDate && now < endBuyBackDate && amount <= toBuyBack); 
352     balances[this] = balances[this].sub(amount);
353     totalSupply = totalSupply.sub(amount);
354     Burn(this, amount);
355     toBuyBack = toBuyBack.sub(amount);
356     uint valueInWei = amount.mul(buyBackInvestedValue).mul(PERCENT_RATE.add(BUY_BACK_BONUS)).div(PERCENT_RATE).div(totalSupply);
357     buyBackInvestedValue = buyBackInvestedValue.sub(amount.mul(buyBackInvestedValue).div(totalSupply));
358     from.transfer(valueInWei);
359   }
360 
361   function retrieveTokens(address anotherToken) public onlyOwner {
362     require(anotherToken != address(this));
363     ERC20 alienToken = ERC20(anotherToken);
364     alienToken.transfer(owner, alienToken.balanceOf(this));
365   }
366 
367   function finishMinting(uint newInvested) onlyOwner public returns (bool) {
368     invested = newInvested;
369     buyBackInvestedValue = newInvested;
370     tokensAfterCrowdsale = totalSupply;    
371     startBuyBackDate = 1609459200;
372     endBuyBackDate = startBuyBackDate + 365 * 1 days;      
373     toBuyBack = tokensAfterCrowdsale.div(10);
374     return super.finishMinting();
375   }
376 
377   function lockAddress(address toLock) public onlyOwner {
378     lockAddresses[toLock] = true;
379   }
380 
381   function unlockAddress(address toLock) public onlyOwner {
382     lockAddresses[toLock] = false;
383   }
384 
385   // should use when payDividends is under re-entrance freeze
386   function payDividendsManually() public {
387     require(dividends[msg.sender] > 0);
388     uint dividendsValue = dividends[msg.sender];
389     dividends[msg.sender] = 0;
390     ethToDividendsNeeds = ethToDividendsNeeds.sub(dividendsValue);
391     msg.sender.transfer(dividendsValue);
392   }
393 
394   // should use when payDividends is under re-entrance freeze
395   function resetDividendsCalculation() public onlyOwner {
396     dividendsCalculated = false;
397     dividendsPayed = false;
398   }
399 
400   // re-entrance attack can freeze all dividends calculation
401   function payDividends(uint count) public onlyOwner {
402     require(!dividendsPayed && dividendsCalculated);
403     for(uint i = 0; dividendsPayedIndex < addresses.length && i < count; i++) {
404       address tokenHolder = addresses[dividendsPayedIndex];
405       if(!lockAddresses[tokenHolder] && dividends[tokenHolder] != 0) {
406         uint value = dividends[tokenHolder];
407         dividends[tokenHolder] = 0;
408         ethToDividendsNeeds = ethToDividendsNeeds.sub(value);
409         tokenHolder.transfer(value);
410       }
411       dividendsPayedIndex++;
412     }
413     if(dividendsPayedIndex == addresses.length) {  
414       dividendsPayedIndex = 0;
415       dividendsPayed = true;
416       dividendsCalculated = false;
417     }
418   }
419   
420 
421   // re-entrance attack can freeze all dividends calculation
422   function calculateDividends(uint percent, uint count) public onlyOwner {
423     require(!dividendsCalculated);
424     for(uint i = 0; dividendsIndex < addresses.length && i < count; i++) {
425       address tokenHolder = addresses[dividendsIndex];
426       if(balances[tokenHolder] != 0) {
427         uint valueInWei = balances[tokenHolder].mul(invested).mul(percent).div(PERCENT_RATE).div(totalSupply);
428         ethToDividendsNeeds = ethToDividendsNeeds.add(valueInWei);
429         dividends[tokenHolder] = dividends[tokenHolder].add(valueInWei);
430       }
431       dividendsIndex++;
432     }
433     if(dividendsIndex == addresses.length) {  
434       dividendsIndex = 0;
435       dividendsCalculated = true;
436       dividendsPayed = false;
437     }
438   }
439 
440   function withdraw() public onlyOwner {
441     owner.transfer(this.balance);
442   }
443 
444   function deposit() public payable {
445   }
446 
447   function () public payable {
448     deposit();
449   }
450 
451 }
452 
453 contract CommonCrowdsale is Ownable {
454 
455   using SafeMath for uint256;
456  
457   uint public constant DIVIDER = 10000000000000000;
458 
459   uint public constant PERCENT_RATE = 100;
460 
461   uint public price = 1500;
462 
463   uint public minInvestedLimit = 100000000000000000;
464 
465   uint public hardcap = 250000000000000000000000;
466 
467   uint public start = 1510758000;
468 
469   uint public invested;
470 
471   address public wallet;
472 
473   struct Milestone {
474     uint periodInDays;
475     uint bonus;
476   }
477 
478   Milestone[] public milestones;
479 
480   MilkCoinToken public token = new MilkCoinToken();
481 
482   function setHardcap(uint newHardcap) public onlyOwner { 
483     hardcap = newHardcap;
484   }
485  
486   function setStart(uint newStart) public onlyOwner { 
487     start = newStart;
488   }
489 
490   function setWallet(address newWallet) public onlyOwner { 
491     wallet = newWallet;
492   }
493 
494   function setPrice(uint newPrice) public onlyOwner {
495     price = newPrice;
496   }
497 
498   function setMinInvestedLimit(uint newMinInvestedLimit) public onlyOwner {
499     minInvestedLimit = newMinInvestedLimit;
500   }
501  
502   function milestonesCount() public constant returns(uint) {
503     return milestones.length;
504   }
505 
506   function addMilestone(uint limit, uint bonus) public onlyOwner {
507     milestones.push(Milestone(limit, bonus));
508   }
509 
510   function end() public constant returns(uint) {
511     uint last = start;
512     for (uint i = 0; i < milestones.length; i++) {
513       Milestone storage milestone = milestones[i];
514       last += milestone.periodInDays * 1 days;
515     }
516     return last;
517   }
518 
519   function getMilestoneBonus() public constant returns(uint) {
520     uint prevTimeLimit = start;
521     for (uint i = 0; i < milestones.length; i++) {
522       Milestone storage milestone = milestones[i];
523       prevTimeLimit += milestone.periodInDays * 1 days;
524       if (now < prevTimeLimit)
525         return milestone.bonus;
526     }
527     revert();
528   }
529 
530   function createTokensManually(address to, uint amount) public onlyOwner {
531     require(now >= start && now < end());
532     token.mint(to, amount);
533   }
534 
535   function createTokens() public payable {
536     require(now >= start && now < end() && invested < hardcap);
537     wallet.transfer(msg.value);
538     invested = invested.add(msg.value);
539     uint tokens = price.mul(msg.value).div(DIVIDER);
540     uint bonusPercent = getMilestoneBonus();    
541     if(bonusPercent > 0) {
542       tokens = tokens.add(tokens.mul(bonusPercent).div(PERCENT_RATE));
543     }
544     token.mint(msg.sender, tokens);
545   }
546 
547   function finishMinting() public onlyOwner {
548     token.finishMinting(invested);
549     token.transferOwnership(owner);
550   }
551 
552   function() external payable {
553     createTokens();
554   }
555 
556   function retrieveTokens(address anotherToken) public onlyOwner {
557     ERC20 alienToken = ERC20(anotherToken);
558     alienToken.transfer(wallet, alienToken.balanceOf(this));
559   }
560 
561 }
562 
563 contract MilkCoinTokenCrowdsale is CommonCrowdsale {
564 
565   function MilkCoinTokenCrowdsale() public {
566     setHardcap(250000000000000000000000);
567     setStart(1510758000);
568     setPrice(1500);
569     setWallet(0x87127Cb2a73eA9ba842b208455fa076cab03E844);
570     addMilestone(3, 100);
571     addMilestone(5, 67);
572     addMilestone(5, 43);
573     addMilestone(5, 25);
574     addMilestone(12, 0);
575     transferOwnership(0xb794B6c611bFC09ABD206184417082d3CA570FB7);
576   }
577 
578 }