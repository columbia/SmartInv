1 pragma solidity ^0.4.20;
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
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65     
66   address public owner;
67   
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   function Ownable() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) onlyOwner public {
90     require(newOwner != address(0));      
91     owner = newOwner;
92   }
93 }
94 
95 /**
96  * @title Pausable
97  * @dev Base contract which allows children to implement an emergency stop mechanism.
98  */
99 contract Pausable is Ownable {
100   address public saleAgent;
101   address public partner;
102 
103   modifier onlyAdmin() {
104     require(msg.sender == owner || msg.sender == saleAgent || msg.sender == partner);
105     _;
106   }
107 
108   function setSaleAgent(address newSaleAgent) onlyOwner public {
109     require(newSaleAgent != address(0)); 
110     saleAgent = newSaleAgent;
111   }
112 
113   function setPartner(address newPartner) onlyOwner public {
114     require(newPartner != address(0)); 
115     partner = newPartner;
116   }
117 
118   event Pause();
119   event Unpause();
120 
121   bool public paused = false;
122 
123 
124   /**
125    * @dev Modifier to make a function callable only when the contract is not paused.
126    */
127   modifier whenNotPaused() {
128     require(!paused);
129     _;
130   }
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is paused.
134    */
135   modifier whenPaused() {
136     require(paused);
137     _;
138   }
139 
140   /**
141    * @dev called by the owner to pause, triggers stopped state
142    */
143   function pause() onlyOwner whenNotPaused public {
144     paused = true;
145     Pause();
146   }
147 
148   /**
149    * @dev called by the owner to unpause, returns to normal state
150    */
151   function unpause() onlyOwner whenPaused public {
152     paused = false;
153     Unpause();
154   }
155 }
156 
157 /**
158  * @title Basic token
159  * @dev Basic version of StandardToken, with no allowances. 
160  */
161 contract BasicToken is ERC20Basic, Pausable {
162     
163   using SafeMath for uint256;
164 
165   mapping(address => uint256) balances;
166 
167   uint256 public storageTime = 1522749600; // 04/03/2018 @ 10:00am (UTC)
168 
169   modifier checkStorageTime() {
170     require(now >= storageTime);
171     _;
172   }
173 
174   modifier onlyPayloadSize(uint256 numwords) {
175     assert(msg.data.length >= numwords * 32 + 4);
176     _;
177   }
178 
179   function setStorageTime(uint256 _time) public onlyOwner {
180     storageTime = _time;
181   }
182 
183   /**
184   * @dev transfer token for a specified address
185   * @param _to The address to transfer to.
186   * @param _value The amount to be transferred.
187   */
188   function transfer(address _to, uint256 _value) public
189   onlyPayloadSize(2) whenNotPaused checkStorageTime returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[msg.sender]);
192 
193     // SafeMath.sub will throw if there is not enough balance.
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of. 
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public constant returns (uint256 balance) {
206     return balances[_owner];
207   }
208 
209 }
210 
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * @dev https://github.com/ethereum/EIPs/issues/20
216  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract StandardToken is ERC20, BasicToken {
219 
220   mapping (address => mapping (address => uint256)) allowed;
221 
222   /**
223    * @dev Transfer tokens from one address to another
224    * @param _from address The address which you want to send tokens from
225    * @param _to address The address which you want to transfer to
226    * @param _value uint256 the amout of tokens to be transfered
227    */
228 
229   function transferFrom(address _from, address _to, uint256 _value) public 
230   onlyPayloadSize(3) whenNotPaused checkStorageTime returns (bool) {
231     require(_to != address(0));
232     require(_value <= balances[_from]);
233     require(_value <= allowed[_from][msg.sender]);
234 
235     balances[_from] = balances[_from].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
238     Transfer(_from, _to, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public 
248   onlyPayloadSize(2) whenNotPaused returns (bool) {
249 
250     // To change the approve amount you first have to reduce the addresses`
251     //  allowance to zero by calling `approve(_spender, 0)` if it is not
252     //  already 0 to mitigate the race condition described here:
253     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
255 
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifing the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
268     return allowed[_owner][_spender];
269   }
270 
271    /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(address _spender, uint _addedValue) public 
282   onlyPayloadSize(2)
283   returns (bool) {
284     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
285     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289   /**
290    * @dev Decrease the amount of tokens that an owner allowed to a spender.
291    *
292    * approve should be called when allowed[_spender] == 0. To decrement
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param _spender The address which will spend the funds.
297    * @param _subtractedValue The amount of tokens to decrease the allowance by.
298    */
299   function decreaseApproval(address _spender, uint _subtractedValue) public 
300   onlyPayloadSize(2)
301   returns (bool) {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 }
312 
313 /**
314  * @title Mintable token
315  * @dev Simple ERC20 Token example, with mintable token creation
316  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
317  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
318  */
319 
320 contract MintableToken is StandardToken{
321     
322   event Mint(address indexed to, uint256 amount);
323   
324   event MintFinished();
325 
326   bool public mintingFinished = false;
327 
328   modifier canMint() {
329     require(!mintingFinished);
330     _;
331   }
332 
333   /**
334    * @dev Function to mint tokens
335    * @param _to The address that will recieve the minted tokens.
336    * @param _amount The amount of tokens to mint.
337    * @return A boolean that indicates if the operation was successful.
338    */
339   function mint(address _to, uint256 _amount) public onlyAdmin whenNotPaused canMint returns  (bool) {
340     totalSupply = totalSupply.add(_amount);
341     balances[_to] = balances[_to].add(_amount);
342     Mint(_to, _amount);
343     Transfer(address(this), _to, _amount);
344     return true;
345   }
346 
347   /**
348    * @dev Function to stop minting new tokens.
349    * @return True if the operation was successful.
350    */
351   function finishMinting() public onlyOwner returns (bool) {
352     mintingFinished = true;
353     MintFinished();
354     return true;
355   }
356   
357 }
358 
359 /**
360  * @title Burnable Token
361  * @dev Token that can be irreversibly burned (destroyed).
362  */
363 contract BurnableToken is MintableToken {
364 
365   event Burn(address indexed burner, uint256 value);
366 
367   /**
368    * @dev Burns a specific amount of tokens.
369    * @param _value The amount of token to be burned.
370    */
371   function burn(uint256 _value) public onlyPayloadSize(1) {
372     require(_value <= balances[msg.sender]);
373     // no need to require value <= totalSupply, since that would imply the
374     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
375     address burner = msg.sender;
376     balances[burner] = balances[burner].sub(_value);
377     totalSupply = totalSupply.sub(_value);
378     Burn(burner, _value);
379     Transfer(burner, address(0), _value);
380   }
381 
382   function burnFrom(address _from, uint256 _value) public 
383   onlyPayloadSize(2)
384   returns (bool success) {
385     require(balances[_from] >= _value);// Check if the targeted balance is enough
386     require(_value <= allowed[_from][msg.sender]);// Check allowance
387     balances[_from] = balances[_from].sub(_value); // Subtract from the targeted balance
388     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
389     totalSupply = totalSupply.sub(_value);
390     Burn(_from, _value);
391     return true;
392     }
393 }
394 
395 contract AlttexToken is BurnableToken {
396     string public constant name = "Alttex";
397     string public constant symbol = "ALTX";
398     uint8 public constant decimals = 8;
399 }
400 
401 contract Crowdsale is Ownable {
402     
403     using SafeMath for uint;
404     uint256 public startTimeRound1;
405     uint256 public endTimeRound1;
406 
407     uint256 public startTimeRound2;
408     uint256 public endTimeRound2;
409 
410     // one token per one rate
411     uint256 public rateRound1 = 1200;
412     uint256 public rateRound2 = 900;
413 
414     uint256 constant dec = 10 ** 8;
415     uint256 public supply = 50000000 * 10 ** 8;
416     uint256 public percentTokensToSale = 60;
417     uint256 public tokensToSale = supply.mul(percentTokensToSale).div(100);
418     // address where funds are collected
419     address public wallet;
420 
421     AlttexToken public token;
422     // Amount of raised money in wei
423     uint256 public weiRaised = 21678 * 10 ** 16; // 216.78 ETH
424     uint256 public minTokensToSale = 45 * dec;
425     // Company addresses
426     address public TeamAndAdvisors;
427     address public Investors;
428 
429     uint256 timeBonus1 = 20;
430     uint256 timeBonus2 = 10;
431 
432     // Round bonuses
433     uint256 bonus1 = 10;
434     uint256 bonus2 = 15;
435     uint256 bonus3 = 20;
436     uint256 bonus4 = 30;
437 
438     // Amount bonuses
439     uint256 amount1 = 500 * dec;
440     uint256 amount2 = 1000 * dec;
441     uint256 amount3 = 5000 * dec;
442     uint256 amount4 = 10000 * dec;
443 
444     bool initalMinted = false;
445     bool initialWeiRaised = false;
446     bool checkBonus = false;
447 
448     function Crowdsale(
449         address _token,
450         uint256 _startTimeRound1, // 1520121600 - 03/04/2018 @ 12:00am (UTC)
451         uint256 _startTimeRound2, // 1521417600 - 03/19/2018 @ 12:00am (UTC)
452         uint256 _endTimeRound1, // 1521417600 - 03/19/2018 @ 12:00am (UTC)
453         uint256 _endTimeRound2, // 1525305600 - 05/03/2018 @ 12:00am (UTC)
454         address _wallet,
455         address _TeamAndAdvisors,
456         address _Investors) public {
457         require(_token != address(0));
458         require(_endTimeRound1 > _startTimeRound1);
459         require(_endTimeRound2 > _startTimeRound2);
460         require(_wallet != address(0));
461         require(_TeamAndAdvisors != address(0));
462         require(_Investors != address(0));
463         token = AlttexToken(_token);
464         startTimeRound1 = _startTimeRound1;
465         startTimeRound2 = _startTimeRound2;
466         endTimeRound1 = _endTimeRound1;
467         endTimeRound2 = _endTimeRound2;
468         wallet = _wallet;
469         TeamAndAdvisors = _TeamAndAdvisors;
470         Investors = _Investors;
471     }
472 
473     function initialMint() onlyOwner public {
474         require(!initalMinted);
475         uint256 _initialRaised = 17472 * 10 ** 16;
476         uint256 _tokens = _initialRaised.mul(1500).div(10 ** 10);
477         token.mint(Investors, _tokens.add(_tokens.mul(40).div(100)));
478         initalMinted = true;
479     }
480 
481     function initialWeiRais(uint256 _newInitialWeiRais) onlyOwner public {
482         require(!initialWeiRaised);
483         weiRaised = _newInitialWeiRais;
484         initialWeiRaised = true;
485     }
486 
487     modifier saleIsOn() {
488         uint tokenSupply = token.totalSupply();
489         require(now > startTimeRound1 && now < endTimeRound2);
490         require(tokenSupply <= supply);
491         _;
492     }
493 
494     function setPercentTokensToSale(
495         uint256 _newPercentTokensToSale) onlyOwner public {
496         percentTokensToSale = _newPercentTokensToSale;
497     }
498 
499     function setMinTokensToSale(
500         uint256 _newMinTokensToSale) onlyOwner public {
501         minTokensToSale = _newMinTokensToSale;
502     }
503 
504     function setCheckBonus(
505         bool _newCheckBonus) onlyOwner public {
506         checkBonus = _newCheckBonus;
507     }
508 
509     function setAmount(
510         uint256 _newAmount1,
511         uint256 _newAmount2,
512         uint256 _newAmount3,
513         uint256 _newAmount4) onlyOwner public {
514         amount1 = _newAmount1;
515         amount2 = _newAmount2;
516         amount3 = _newAmount3;
517         amount4 = _newAmount4;
518     }
519 
520     function setBonuses(
521         uint256 _newBonus1,
522         uint256 _newBonus2,
523         uint256 _newBonus3,
524         uint256 _newBonus4) onlyOwner public {
525         bonus1 = _newBonus1;
526         bonus2 = _newBonus2;
527         bonus3 = _newBonus3;
528         bonus4 = _newBonus4;
529     }
530 
531     function setRoundTime(
532       uint256 _newStartTimeRound2,
533       uint256 _newEndTimeRound2) onlyOwner public {
534       require(_newEndTimeRound2 > _newStartTimeRound2);
535         startTimeRound2 = _newStartTimeRound2;
536         endTimeRound2 = _newEndTimeRound2;
537     }
538 
539     function setRate(uint256 _newRateRound2) public onlyOwner {
540         rateRound2 = _newRateRound2;
541     }
542 
543     function setTimeBonus(uint256 _newTimeBonus) public onlyOwner {
544         timeBonus2 = _newTimeBonus;
545     }
546  
547     function setTeamAddress(
548         address _newTeamAndAdvisors,
549         address _newInvestors,
550         address _newWallet) onlyOwner public {
551         require(_newTeamAndAdvisors != address(0));
552         require(_newInvestors != address(0));
553         require(_newWallet != address(0));
554         TeamAndAdvisors = _newTeamAndAdvisors;
555         Investors = _newInvestors;
556         wallet = _newWallet;
557     }
558 
559 
560     function getAmount(uint256 _value) internal view returns (uint256) {
561         uint256 amount = 0;
562         uint256 all = 100;
563         uint256 tokenSupply = token.totalSupply();
564         if(now >= startTimeRound1 && now < endTimeRound1) { // Round 1
565             amount = _value.mul(rateRound1);
566             amount = amount.add(amount.mul(timeBonus1).div(all));
567         } else if(now >= startTimeRound2 && now < endTimeRound2) { // Round 2
568             amount = _value.mul(rateRound2);
569             amount = amount.add(amount.mul(timeBonus2).div(all));
570         } 
571         require(amount >= minTokensToSale);
572         require(amount != 0 && amount.add(tokenSupply) < tokensToSale);
573         return amount;
574     }
575 
576     function getBonus(uint256 _value) internal view returns (uint256) {
577         if(_value >= amount1 && _value < amount2) { 
578             return bonus1;
579         } else if(_value >= amount2 && _value < amount3) {
580             return bonus2;
581         } else if(_value >= amount3 && _value < amount4) {
582             return bonus3;
583         } else if(_value >= amount4) {
584             return bonus4;
585         }
586     }
587 
588     /**
589     * events for token purchase logging
590     * @param purchaser who paid for the tokens
591     * @param beneficiary who got the tokens
592     * @param value weis paid for purchase
593     * @param amount amount of tokens purchased
594     */
595     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
596     event TokenPartners(address indexed purchaser, address indexed beneficiary, uint256 amount);
597 
598     function buyTokens(address beneficiary) saleIsOn public payable {
599         require(beneficiary != address(0));
600         uint256 weiAmount = (msg.value).div(10 ** 10);
601 
602         // calculate token amount to be created
603         uint256 tokens = getAmount(weiAmount);
604 
605         if(checkBonus) {
606           uint256 bonusNow = getBonus(tokens);
607           tokens = tokens.add(tokens.mul(bonusNow).div(100));
608         }
609         
610         weiRaised = weiRaised.add(msg.value);
611         uint256 taaTokens = tokens.mul(20).div(100);
612 
613         require(tokens.add(taaTokens).add(token.totalSupply()) <= tokensToSale);
614 
615         token.mint(beneficiary, tokens);
616         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
617         token.mint(TeamAndAdvisors, taaTokens);
618         TokenPartners(msg.sender, TeamAndAdvisors, taaTokens);
619         wallet.transfer(msg.value);
620         
621     }
622 
623     // fallback function can be used to buy tokens
624     function () external payable {
625         buyTokens(msg.sender);
626     }
627 
628     // @return true if tokensale event has ended
629     function hasEnded() public view returns (bool) {
630         return now > endTimeRound2;
631     }
632 
633     function kill() onlyOwner public { selfdestruct(owner); }
634     
635 }