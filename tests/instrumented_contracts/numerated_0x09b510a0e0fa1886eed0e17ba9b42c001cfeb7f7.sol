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
412     uint256 public rateRound2;
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
423     uint256 public weiRaised = 17472 * 10 ** 16; // 174.72 ETH
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
445     bool checkBonus = false;
446 
447     function Crowdsale(
448         address _token,
449         uint256 _startTimeRound1, // 1520121600 - 03/04/2018 @ 12:00am (UTC)
450         uint256 _startTimeRound2, // 1521417600 - 03/19/2018 @ 12:00am (UTC)
451         uint256 _endTimeRound1, // 1521417600 - 03/19/2018 @ 12:00am (UTC)
452         uint256 _endTimeRound2, // 1525305600 - 05/03/2018 @ 12:00am (UTC)
453         address _wallet,
454         address _TeamAndAdvisors,
455         address _Investors) public {
456         require(_token != address(0));
457         require(_endTimeRound1 > _startTimeRound1);
458         require(_endTimeRound2 > _startTimeRound2);
459         require(_wallet != address(0));
460         require(_TeamAndAdvisors != address(0));
461         require(_Investors != address(0));
462         token = AlttexToken(_token);
463         startTimeRound1 = _startTimeRound1;
464         startTimeRound2 = _startTimeRound2;
465         endTimeRound1 = _endTimeRound1;
466         endTimeRound2 = _endTimeRound2;
467         wallet = _wallet;
468         TeamAndAdvisors = _TeamAndAdvisors;
469         Investors = _Investors;
470     }
471 
472     function initialMint() onlyOwner public {
473         require(!initalMinted);
474         uint256 _initialRaised = 17472 * 10 ** 16;
475         uint256 _tokens = _initialRaised.mul(1500).div(10 ** 10);
476         token.mint(Investors, _tokens.add(_tokens.mul(40).div(100)));
477         initalMinted = true;
478     }
479 
480     modifier saleIsOn() {
481         uint tokenSupply = token.totalSupply();
482         require(now > startTimeRound1 && now < endTimeRound2);
483         require(tokenSupply <= tokensToSale);
484         _;
485     }
486 
487     function setPercentTokensToSale(
488         uint256 _newPercentTokensToSale) onlyOwner public {
489         percentTokensToSale = _newPercentTokensToSale;
490     }
491 
492     function setMinTokensToSale(
493         uint256 _newMinTokensToSale) onlyOwner public {
494         minTokensToSale = _newMinTokensToSale;
495     }
496 
497     function setCheckBonus(
498         bool _newCheckBonus) onlyOwner public {
499         checkBonus = _newCheckBonus;
500     }
501 
502     function setAmount(
503         uint256 _newAmount1,
504         uint256 _newAmount2,
505         uint256 _newAmount3,
506         uint256 _newAmount4) onlyOwner public {
507         amount1 = _newAmount1;
508         amount2 = _newAmount2;
509         amount3 = _newAmount3;
510         amount4 = _newAmount4;
511     }
512 
513     function setBonuses(
514         uint256 _newBonus1,
515         uint256 _newBonus2,
516         uint256 _newBonus3,
517         uint256 _newBonus4) onlyOwner public {
518         bonus1 = _newBonus1;
519         bonus2 = _newBonus2;
520         bonus3 = _newBonus3;
521         bonus4 = _newBonus4;
522     }
523 
524     function setRoundTime(
525       uint256 _newStartTimeRound2,
526       uint256 _newEndTimeRound2) onlyOwner public {
527       require(_newEndTimeRound2 > _newStartTimeRound2);
528         startTimeRound2 = _newStartTimeRound2;
529         endTimeRound2 = _newEndTimeRound2;
530     }
531 
532     function setRate(uint256 _newRateRound2) public onlyOwner {
533         rateRound2 = _newRateRound2;
534     }
535 
536     function setTimeBonus(uint256 _newTimeBonus) public onlyOwner {
537         timeBonus2 = _newTimeBonus;
538     }
539  
540     function setTeamAddress(
541         address _newTeamAndAdvisors,
542         address _newInvestors,
543         address _newWallet) onlyOwner public {
544         require(_newTeamAndAdvisors != address(0));
545         require(_newInvestors != address(0));
546         require(_newWallet != address(0));
547         TeamAndAdvisors = _newTeamAndAdvisors;
548         Investors = _newInvestors;
549         wallet = _newWallet;
550     }
551 
552 
553     function getAmount(uint256 _value) internal view returns (uint256) {
554         uint256 amount = 0;
555         uint256 all = 100;
556         uint256 tokenSupply = token.totalSupply();
557         if(now >= startTimeRound1 && now < endTimeRound1) { // Round 1
558             amount = _value.mul(rateRound1);
559             amount = amount.add(amount.mul(timeBonus1).div(all));
560         } else if(now >= startTimeRound2 && now < endTimeRound2) { // Round 2
561             amount = _value.mul(rateRound2);
562             amount = amount.add(amount.mul(timeBonus2).div(all));
563         } 
564         require(amount >= minTokensToSale);
565         require(amount != 0 && amount.add(tokenSupply) < tokensToSale);
566         return amount;
567     }
568 
569     function getBonus(uint256 _value) internal view returns (uint256) {
570         if(_value >= amount1 && _value < amount2) { 
571             return bonus1;
572         } else if(_value >= amount2 && _value < amount3) {
573             return bonus2;
574         } else if(_value >= amount3 && _value < amount4) {
575             return bonus3;
576         } else if(_value >= amount4) {
577             return bonus4;
578         }
579     }
580 
581     /**
582     * events for token purchase logging
583     * @param purchaser who paid for the tokens
584     * @param beneficiary who got the tokens
585     * @param value weis paid for purchase
586     * @param amount amount of tokens purchased
587     */
588     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
589     event TokenPartners(address indexed purchaser, address indexed beneficiary, uint256 amount);
590 
591     function buyTokens(address beneficiary) saleIsOn public payable {
592         require(beneficiary != address(0));
593         uint256 weiAmount = (msg.value).div(10 ** 10);
594 
595         // calculate token amount to be created
596         uint256 tokens = getAmount(weiAmount);
597 
598         if(checkBonus) {
599           uint256 bonusNow = getBonus(tokens);
600           tokens = tokens.add(tokens.mul(bonusNow).div(100));
601         }
602         
603         weiRaised = weiRaised.add(msg.value);
604         token.mint(beneficiary, tokens);
605         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
606 
607         wallet.transfer(msg.value);
608 
609         uint256 taaTokens = tokens.mul(20).div(100);
610         token.mint(TeamAndAdvisors, taaTokens);
611         TokenPartners(msg.sender, TeamAndAdvisors, taaTokens);
612     }
613 
614     // fallback function can be used to buy tokens
615     function () external payable {
616         buyTokens(msg.sender);
617     }
618 
619     // @return true if tokensale event has ended
620     function hasEnded() public view returns (bool) {
621         return now > endTimeRound2;
622     }
623 
624     function kill() onlyOwner public { selfdestruct(owner); }
625     
626 }