1 pragma solidity ^0.4.17;
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
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address internal owner;
24 
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   function Ownable() {
34     owner = msg.sender;
35   }
36 
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) onlyOwner public {
52     require(newOwner != address(0));
53     OwnershipTransferred(owner, newOwner);
54     owner = newOwner;
55   }
56 
57 }
58 
59 
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
67     uint256 c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71 
72   function div(uint256 a, uint256 b) internal constant returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   function add(uint256 a, uint256 b) internal constant returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 
90 }
91 
92 /**
93  * @title TradePlaceCrowdsale
94  * @author HamzaYasin1 - Github
95  * @dev TradePlaceCrowdsale is a base contract for managing a token crowdsale.
96  * Crowdsales have a start and end timestamps, where investors can make
97  * token purchases and the crowdsale will assign them EXTP tokens based
98  * on a EXTP token per ETH rate. Funds collected are forwarded to a wallet
99  * as they arrive.
100  */
101 
102 
103 
104 
105 
106 
107 
108 
109 
110 
111 
112 
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances.
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130 
131     // SafeMath.sub will throw if there is not enough balance.
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public constant returns (uint256 balance) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 
150 
151 
152 
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://github.com/ethereum/EIPs/issues/20
157  */
158 contract ERC20 is ERC20Basic {
159   function allowance(address owner, address spender) public constant returns (uint256);
160   function transferFrom(address from, address to, uint256 value) public returns (bool);
161   function approve(address spender, uint256 value) public returns (bool);
162   event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186 
187     uint256 _allowance = allowed[_from][msg.sender];
188 
189     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
190     // require (_value <= _allowance);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = _allowance.sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    */
231   function increaseApproval (address _spender, uint _addedValue)
232     returns (bool success) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   function decreaseApproval (address _spender, uint _subtractedValue)
239     returns (bool success) {
240     uint oldValue = allowed[msg.sender][_spender];
241     if (_subtractedValue > oldValue) {
242       allowed[msg.sender][_spender] = 0;
243     } else {
244       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
245     }
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250 }
251 
252 
253 /**
254  * @title Mintable token
255  * @dev Simple ERC20 Token example, with mintable token creation
256  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
257  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
258  */
259 
260 contract MintableToken is StandardToken, Ownable {
261   event Mint(address indexed to, uint256 amount);
262   event MintFinished();
263 
264   bool public mintingFinished = false;
265 
266 
267   modifier canMint() {
268     require(!mintingFinished);
269     _;
270   }
271 
272   /**
273    * @dev Function to mint tokens
274    * @param _to The address that will receive the minted tokens.
275    * @param _amount The amount of tokens to mint.
276    * @return A boolean that indicates if the operation was successful.
277    */
278 
279   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
280     balances[_to] = balances[_to].add(_amount);
281     Mint(_to, _amount);
282     Transfer(msg.sender, _to, _amount);
283     return true;
284   }
285 
286   /**
287    * @dev Function to stop minting new tokens.
288    * @return True if the operation was successful.
289    */
290   function finishMinting() onlyOwner public returns (bool) {
291     mintingFinished = true;
292     MintFinished();
293     return true;
294   }
295 
296   function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {
297     totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);
298   }
299 
300 }
301 
302 
303 
304 
305 
306 
307 
308 
309 
310 /**
311  * @title Pausable
312  * @dev Base contract which allows children to implement an emergency stop mechanism.
313  */
314 contract Pausable is Ownable {
315   event Pause();
316   event Unpause();
317 
318   bool public paused = false;
319 
320 
321   /**
322    * @dev Modifier to make a function callable only when the contract is not paused.
323    */
324   modifier whenNotPaused() {
325     require(!paused);
326     _;
327   }
328 
329   /**
330    * @dev Modifier to make a function callable only when the contract is paused.
331    */
332   modifier whenPaused() {
333     require(paused);
334     _;
335   }
336 
337   /**
338    * @dev called by the owner to pause, triggers stopped state
339    */
340   function pause() onlyOwner whenNotPaused public {
341     paused = true;
342     Pause();
343   }
344 
345   /**
346    * @dev called by the owner to unpause, returns to normal state
347    */
348   function unpause() onlyOwner whenPaused public {
349     paused = false;
350     Unpause();
351   }
352 }
353 
354 /**
355  * @title Med-h Crowdsale
356  * @dev Crowdsale is a base contract for managing a token crowdsale.
357  * Crowdsales have a start and end timestamps, where investors can make
358  * token purchases and the crowdsale will assign them tokens based
359  * on a token per ETH rate. Funds collected are forwarded to a wallet
360  * as they arrive.
361  */
362 contract Crowdsale is Ownable, Pausable {
363 
364   using SafeMath for uint256;
365 
366   /**
367    *  @MintableToken token - Token Object
368    *  @address wallet - Wallet Address
369    *  @uint256 rate - Tokens per Ether
370    *  @uint256 weiRaised - Total funds raised in Ethers
371   */
372   MintableToken internal token;
373   address internal wallet;
374   uint256 public rate;
375   uint256 internal weiRaised;
376 
377  /**
378     *  @uint256 preICOstartTime - pre ICO Start Time
379     *  @uint256 preICOEndTime - pre ICO End Time
380     *  @uint256 ICOstartTime - ICO Start Time
381     *  @uint256 ICOEndTime - ICO End Time
382     */
383     uint256 public preICOstartTime;
384     uint256 public preICOEndTime;
385   
386     uint256 public ICOstartTime;
387     uint256 public ICOEndTime;
388     
389     // Weeks in UTC
390 
391     uint public StageTwo;
392     uint public StageThree;
393     uint public StageFour;
394 
395     /**
396     *  @uint preIcoBonus 
397     *  @uint StageOneBonus
398     *  @uint StageTwoBonus
399     *  @uint StageThreeBonus 
400     */
401     uint public preIcoBonus;
402     uint public StageOneBonus;
403     uint public StageTwoBonus;
404     uint public StageThreeBonus;
405 
406     /**
407     *  @uint256 totalSupply - Total supply of tokens  ~ 500,000,000 EXTP 
408     *  @uint256 publicSupply - Total public Supply  ~ 20 percent
409     *  @uint256 preIcoSupply - Total PreICO Supply from Public Supply ~ 10 percent
410     *  @uint256 icoSupply - Total ICO Supply from Public Supply ~ 10 percent
411     *  @uint256 bountySupply - Total Bounty Supply ~ 10 percent
412     *  @uint256 reserveSupply - Total Reserve Supply ~ 20 percent
413     *  @uint256 advisorSupply - Total Advisor Supply ~ 10 percent
414     *  @uint256 founderSupply - Total Founder Supply ~ 20 percent
415     *  @uint256 teamSupply - Total team Supply ~ 10 percent
416     *  @uint256 rewardSupply - Total reward Supply ~ 10 percent
417     */
418     uint256 public totalSupply = SafeMath.mul(500000000, 1 ether); // 500000000
419     uint256 public publicSupply = SafeMath.mul(100000000, 1 ether);
420     uint256 public preIcoSupply = SafeMath.mul(50000000, 1 ether);                     
421     uint256 public icoSupply = SafeMath.mul(50000000, 1 ether);
422 
423     uint256 public bountySupply = SafeMath.mul(50000000, 1 ether);
424     uint256 public reserveSupply = SafeMath.mul(100000000, 1 ether);
425     uint256 public advisorSupply = SafeMath.mul(50000000, 1 ether);
426     uint256 public founderSupply = SafeMath.mul(100000000, 1 ether);
427     uint256 public teamSupply = SafeMath.mul(50000000, 1 ether);
428     uint256 public rewardSupply = SafeMath.mul(50000000, 1 ether);
429   
430     /**
431     *  @uint256 advisorTimeLock - Advisor Timelock 
432     *  @uint256 founderfounderTimeLock - Founder and Team Timelock 
433     *  @uint256 reserveTimeLock - Company Reserved Timelock 
434     *  @uint256 reserveTimeLock - Team Timelock 
435     */
436     uint256 public founderTimeLock;
437     uint256 public advisorTimeLock;
438     uint256 public reserveTimeLock;
439     uint256 public teamTimeLock;
440 
441     // count the number of function calls
442     uint public founderCounter = 0; // internal
443     uint public teamCounter = 0;
444     uint public advisorCounter = 0;
445   /**
446     *  @bool checkUnsoldTokens - 
447     *  @bool upgradeICOSupply - Boolean variable updates when the PreICO tokens added to ICO supply
448     *  @bool grantReserveSupply - Boolean variable updates when reserve tokens minted
449     */
450     bool public checkBurnTokens;
451     bool public upgradeICOSupply;
452     bool public grantReserveSupply;
453 
454  /**
455    * event for token purchase logging
456    * @param purchaser who paid for the tokens
457    * @param beneficiary who got the tokens
458    * @param value weis paid for purchase
459    * @param amount amount of tokens purchased
460    */
461   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
462     /**
463    * function Crowdsale - Parameterized Constructor
464    * @param _startTime - StartTime of Crowdsale
465    * @param _endTime - EndTime of Crowdsale
466    * @param _rate - Tokens against Ether
467    * @param _wallet - MultiSignature Wallet Address
468    */
469  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
470     require(_startTime >= now);
471     require(_endTime >= _startTime);
472     require(_rate > 0);
473     require(_wallet != 0x0);
474 
475     token = createTokenContract();
476     preICOstartTime = _startTime; // Dec - 10 - 2018
477     preICOEndTime =  1547769600; //SafeMath.add(preICOstartTime,3 minutes);   Jan - 18 - 2019 
478     ICOstartTime =  1548633600; //SafeMath.add(preICOEndTime, 1 minutes); Jan - 28 - 2019
479     ICOEndTime = _endTime; // March - 19 - 2019
480     rate = _rate; 
481     wallet = _wallet;
482 
483     /** Calculations of Bonuses in private Sale or Pre-ICO */
484     preIcoBonus = SafeMath.div(SafeMath.mul(rate,20),100);
485     StageOneBonus = SafeMath.div(SafeMath.mul(rate,15),100);
486     StageTwoBonus = SafeMath.div(SafeMath.mul(rate,10),100);
487     StageThreeBonus = SafeMath.div(SafeMath.mul(rate,5),100);
488 
489     /** ICO bonuses week calculations */
490     StageTwo = SafeMath.add(ICOstartTime, 12 days); //12 days
491     StageThree = SafeMath.add(StageTwo, 12 days);
492     StageFour = SafeMath.add(StageThree, 12 days);
493 
494     /** Vested Period calculations for team and advisors*/
495     founderTimeLock = SafeMath.add(ICOEndTime, 3 minutes);
496     advisorTimeLock = SafeMath.add(ICOEndTime, 3 minutes);
497     reserveTimeLock = SafeMath.add(ICOEndTime, 3 minutes);
498     teamTimeLock = SafeMath.add(ICOEndTime, 3 minutes);
499     
500     checkBurnTokens = false;
501     upgradeICOSupply = false;
502     grantReserveSupply = false;
503   }
504 
505   // creates the token to be sold.
506   // override this method to have crowdsale of a specific mintable token.
507   function createTokenContract() internal returns (MintableToken) {
508     return new MintableToken();
509   }
510   /**
511    * function preIcoTokens - Calculate Tokens in of PRE-ICO 
512    */
513   function preIcoTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
514   
515     require(preIcoSupply > 0);
516     tokens = SafeMath.add(tokens, weiAmount.mul(preIcoBonus));
517     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
518 
519     require(preIcoSupply >= tokens);
520     
521     preIcoSupply = preIcoSupply.sub(tokens);        
522     publicSupply = publicSupply.sub(tokens);
523 
524     return tokens;     
525   }
526 
527   /**
528    * function icoTokens - Calculate Tokens in Main ICO
529    */
530   function icoTokens(uint256 weiAmount, uint256 tokens, uint256 accessTime) internal returns (uint256) {
531 
532     require(icoSupply > 0);
533       
534       if ( accessTime <= StageTwo ) { 
535         tokens = SafeMath.add(tokens, weiAmount.mul(StageOneBonus));
536       } else if (( accessTime <= StageThree ) && (accessTime > StageTwo)) {  
537         tokens = SafeMath.add(tokens, weiAmount.mul(StageTwoBonus));
538       } else if (( accessTime <= StageFour ) && (accessTime > StageThree)) {  
539         tokens = SafeMath.add(tokens, weiAmount.mul(StageThreeBonus));
540       }
541         tokens = SafeMath.add(tokens, weiAmount.mul(rate)); 
542       require(icoSupply >= tokens);
543       
544       icoSupply = icoSupply.sub(tokens);        
545       publicSupply = publicSupply.sub(tokens);
546 
547       return tokens;
548   }
549   
550 
551   // fallback function can be used to buy tokens
552   function () payable {
553     buyTokens(msg.sender);
554   }
555 
556   // High level token purchase function
557   function buyTokens(address beneficiary) whenNotPaused public payable {
558     require(beneficiary != 0x0);
559     require(validPurchase());
560 
561     uint256 weiAmount = msg.value;
562     // minimum investment should be 0.05 ETH 
563     require((weiAmount >= 50000000000000000));
564     
565     uint256 accessTime = now;
566     uint256 tokens = 0;
567 
568 
569    if ((accessTime >= preICOstartTime) && (accessTime <= preICOEndTime)) {
570            tokens = preIcoTokens(weiAmount, tokens);
571 
572     } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) {
573        if (!upgradeICOSupply) {
574           icoSupply = SafeMath.add(icoSupply,preIcoSupply);
575           upgradeICOSupply = true;
576         }
577        tokens = icoTokens(weiAmount, tokens, accessTime);
578     } else {
579       revert();
580     }
581     
582     weiRaised = weiRaised.add(weiAmount);
583      if(msg.data.length == 20) {
584     address referer = bytesToAddress(bytes(msg.data));
585     // self-referrer check
586     require(referer != msg.sender);
587     uint refererTokens = tokens.mul(6).div(100);
588     // bonus for referrer
589     token.mint(referer, refererTokens);
590   }
591     token.mint(beneficiary, tokens);
592     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
593     forwardFunds();
594   }
595 
596   // send ether to the fund collection wallet
597   function forwardFunds() internal {
598     wallet.transfer(msg.value);
599   }
600 
601 function bytesToAddress(bytes source) internal pure returns(address) {
602   uint result;
603   uint mul = 1;
604   for(uint i = 20; i > 0; i--) {
605     result += uint8(source[i-1])*mul;
606     mul = mul*256;
607   }
608   return address(result);
609 }
610   // @return true if the transaction can buy tokens
611   function validPurchase() internal constant returns (bool) {
612     bool withinPeriod = now >= preICOstartTime && now <= ICOEndTime;
613     bool nonZeroPurchase = msg.value != 0;
614     return withinPeriod && nonZeroPurchase;
615   }
616 
617   // @return true if crowdsale event has ended
618   function hasEnded() public constant returns (bool) {
619       return now > ICOEndTime;
620   }
621 
622   function getTokenAddress() onlyOwner public returns (address) {
623     return token;
624   }
625 
626 }
627 
628 
629 
630 
631 
632 contract Allocations is Crowdsale {
633 
634     function bountyDrop(address[] recipients, uint256[] values) public onlyOwner {
635 
636         for (uint256 i = 0; i < recipients.length; i++) {
637             values[i] = SafeMath.mul(values[i], 1 ether);
638             require(bountySupply >= values[i]);
639             bountySupply = SafeMath.sub(bountySupply,values[i]);
640 
641             token.mint(recipients[i], values[i]);
642         }
643     }
644 
645     function rewardDrop(address[] recipients, uint256[] values) public onlyOwner {
646 
647         for (uint256 i = 0; i < recipients.length; i++) {
648             values[i] = SafeMath.mul(values[i], 1 ether);
649             require(rewardSupply >= values[i]);
650             rewardSupply = SafeMath.sub(rewardSupply,values[i]);
651 
652             token.mint(recipients[i], values[i]);
653         }
654     }
655 
656     function grantAdvisorToken(address beneficiary ) public onlyOwner {
657         require((advisorCounter < 4) && (advisorTimeLock < now));
658         advisorTimeLock = SafeMath.add(advisorTimeLock, 2 minutes);
659         token.mint(beneficiary,SafeMath.div(advisorSupply, 4));
660         advisorCounter = SafeMath.add(advisorCounter, 1);    
661     }
662 
663     function grantFounderToken(address founderAddress) public onlyOwner {
664         require((founderCounter < 4) && (founderTimeLock < now));
665         founderTimeLock = SafeMath.add(founderTimeLock, 2 minutes);
666         token.mint(founderAddress,SafeMath.div(founderSupply, 4));
667         founderCounter = SafeMath.add(founderCounter, 1);        
668     }
669 
670     function grantTeamToken(address teamAddress) public onlyOwner {
671         require((teamCounter < 2) && (teamTimeLock < now));
672         teamTimeLock = SafeMath.add(teamTimeLock, 2 minutes);
673         token.mint(teamAddress,SafeMath.div(teamSupply, 4));
674         teamCounter = SafeMath.add(teamCounter, 1);        
675     }
676 
677     function grantReserveToken(address beneficiary) public onlyOwner {
678         require((!grantReserveSupply) && (now > reserveTimeLock));
679         grantReserveSupply = true;
680         token.mint(beneficiary,reserveSupply);
681         reserveSupply = 0;
682     }
683 
684     function transferFunds(address[] recipients, uint256[] values) public onlyOwner {
685         require(!checkBurnTokens);
686         for (uint256 i = 0; i < recipients.length; i++) {
687             values[i] = SafeMath.mul(values[i], 1 ether);
688             require(publicSupply >= values[i]);
689             publicSupply = SafeMath.sub(publicSupply,values[i]);
690             token.mint(recipients[i], values[i]); 
691             }
692     } 
693 
694     function burnToken() public onlyOwner returns (bool) {
695         require(hasEnded());
696         require(!checkBurnTokens);
697         // token.burnTokens(icoSupply);
698         totalSupply = SafeMath.sub(totalSupply, icoSupply);
699         publicSupply = 0;
700         preIcoSupply = 0;
701         icoSupply = 0;
702         checkBurnTokens = true;
703 
704         return true;
705     }
706 
707 }
708 
709 
710 
711 
712 
713 /**
714  * @title CappedCrowdsale
715  * @dev Extension of Crowdsale with a max amount of funds raised
716  */
717 contract CappedCrowdsale is Crowdsale {
718   using SafeMath for uint256;
719 
720   uint256 internal cap;
721 
722   function CappedCrowdsale(uint256 _cap) {
723     require(_cap > 0);
724     cap = _cap;
725   }
726 
727   // overriding Crowdsale#validPurchase to add extra cap logic
728   // @return true if investors can buy at the moment
729   function validPurchase() internal constant returns (bool) {
730     bool withinCap = weiRaised.add(msg.value) <= cap;
731     return super.validPurchase() && withinCap;
732   }
733 
734   // overriding Crowdsale#hasEnded to add cap logic
735   // @return true if crowdsale event has ended
736   function hasEnded() public constant returns (bool) {
737     bool capReached = weiRaised >= cap;
738     return super.hasEnded() || capReached;
739   }
740 
741 }
742 
743 
744 
745 
746 
747 
748 
749 
750 
751 
752 /**
753  * @title FinalizableCrowdsale
754  * @dev Extension of Crowdsale where an owner can do extra work
755  * after finishing.
756  */
757 contract FinalizableCrowdsale is Crowdsale {
758   using SafeMath for uint256;
759 
760   bool isFinalized = false;
761 
762   event Finalized();
763 
764   /**
765    * @dev Must be called after crowdsale ends, to do some extra finalization
766    * work. Calls the contract's finalization function.
767    */
768   function finalizeCrowdsale() onlyOwner public {
769     require(!isFinalized);
770     require(hasEnded());
771     
772     finalization();
773     Finalized();
774     
775     isFinalized = true;
776     }
777   
778 
779   /**
780    * @dev Can be overridden to add finalization logic. The overriding function
781    * should call super.finalization() to ensure the chain of finalization is
782    * executed entirely.
783    */
784   function finalization() internal {
785   }
786 }
787 
788 
789 
790 
791 
792 
793 /**
794  * @title RefundVault
795  * @dev This contract is used for storing funds while a crowdsale
796  * is in progress. Supports refunding the money if crowdsale fails,
797  * and forwarding it if crowdsale is successful.
798  */
799 contract RefundVault is Ownable {
800   using SafeMath for uint256;
801 
802   enum State { Active, Refunding, Closed }
803 
804   mapping (address => uint256) public deposited;
805   address public wallet;
806   State public state;
807 
808   event Closed();
809   event RefundsEnabled();
810   event Refunded(address indexed beneficiary, uint256 weiAmount);
811 
812   function RefundVault(address _wallet) {
813     require(_wallet != 0x0);
814     wallet = _wallet;
815     state = State.Active;
816   }
817 
818   function deposit(address investor) onlyOwner public payable {
819     require(state == State.Active);
820     deposited[investor] = deposited[investor].add(msg.value);
821   }
822 
823   function close() onlyOwner public {
824     require(state == State.Active);
825     state = State.Closed;
826     Closed();
827     wallet.transfer(this.balance);
828   }
829 
830   function enableRefunds() onlyOwner public {
831     require(state == State.Active);
832     state = State.Refunding;
833     RefundsEnabled();
834   }
835 
836   function refund(address investor) public {
837     require(state == State.Refunding);
838     uint256 depositedValue = deposited[investor];
839     deposited[investor] = 0;
840     investor.transfer(depositedValue);
841     Refunded(investor, depositedValue);
842   }
843 }
844 
845 
846 
847 /**
848  * @title RefundableCrowdsale
849  * @dev Extension of Crowdsale contract that adds a funding goal, and
850  * the possibility of users getting a refund if goal is not met.
851  * Uses a RefundVault as the crowdsale's vault.
852  */
853 contract RefundableCrowdsale is FinalizableCrowdsale {
854   using SafeMath for uint256;
855 
856   // minimum amount of funds to be raised in weis
857   uint256 internal goal;
858   // refund vault used to hold funds while crowdsale is running
859   RefundVault private vault;
860 
861   function RefundableCrowdsale(uint256 _goal) {
862     require(_goal > 0);
863     vault = new RefundVault(wallet);
864     goal = _goal;
865   }
866 
867   // We're overriding the fund forwarding from Crowdsale.
868   // In addition to sending the funds, we want to call
869   // the RefundVault deposit function
870   function forwardFunds() internal {
871     vault.deposit.value(msg.value)(msg.sender);
872   }
873 
874   // if crowdsale is unsuccessful, investors can claim refunds here
875   function claimRefund() public {
876     require(isFinalized);
877     require(!goalReached());
878 
879     vault.refund(msg.sender);
880   }
881 
882   // vault finalization task, called when owner calls finalize()
883   function finalization() internal {
884     if (goalReached()) { 
885       vault.close();
886     } else {
887       vault.enableRefunds();
888     }
889     super.finalization();
890   
891   }
892 
893   /**
894    * @dev Checks whether funding goal was reached. 
895    * @return Whether funding goal was reached
896    */
897   function goalReached() public view returns (bool) {
898     return weiRaised >= (goal - (5000 * 1 ether));
899   }
900 
901   function getVaultAddress() onlyOwner public returns (address) {
902     return vault;
903   }
904 }
905 
906 /**
907  * @title EXTP Token
908  * @author HamzaYasin1 - Github
909  */
910 
911 
912 contract TradePlaceToken is MintableToken {
913 
914   string public constant name = "Trade PLace";
915   string public constant symbol = "EXTP";
916   uint8 public constant decimals = 18;
917   uint256 public totalSupply = SafeMath.mul(500000000 , 1 ether); //500000000
918 }
919 
920 
921 
922 
923 
924 contract TradePlaceCrowdsale is Crowdsale, CappedCrowdsale, RefundableCrowdsale, Allocations {
925     /** Constructor TradePlaceCrowdsale */
926     function TradePlaceCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _goal, address _wallet)
927     CappedCrowdsale(_cap)
928     FinalizableCrowdsale()
929     RefundableCrowdsale(_goal)
930     Crowdsale(_startTime, _endTime, _rate, _wallet)
931     {
932     }
933 
934     /**TradePlaceToken Contract is generating from here */
935     function createTokenContract() internal returns (MintableToken) {
936         return new TradePlaceToken();
937     }
938 }