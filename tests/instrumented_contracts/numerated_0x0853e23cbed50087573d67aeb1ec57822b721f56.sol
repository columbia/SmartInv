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
94  * @dev TradePlaceCrowdsale is a base contract for managing a token crowdsale.
95  * Crowdsales have a start and end timestamps, where investors can make
96  * token purchases and the crowdsale will assign them EXTP tokens based
97  * on a EXTP token per ETH rate. Funds collected are forwarded to a wallet
98  * as they arrive.
99  */
100 
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
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   /**
123   * @dev transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129 
130     // SafeMath.sub will throw if there is not enough balance.
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of.
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) public constant returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 
149 
150 
151 
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 is ERC20Basic {
158   function allowance(address owner, address spender) public constant returns (uint256);
159   function transferFrom(address from, address to, uint256 value) public returns (bool);
160   function approve(address spender, uint256 value) public returns (bool);
161   event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * @dev https://github.com/ethereum/EIPs/issues/20
170  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
171  */
172 contract StandardToken is ERC20, BasicToken {
173 
174   mapping (address => mapping (address => uint256)) allowed;
175 
176 
177   /**
178    * @dev Transfer tokens from one address to another
179    * @param _from address The address which you want to send tokens from
180    * @param _to address The address which you want to transfer to
181    * @param _value uint256 the amount of tokens to be transferred
182    */
183   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185 
186     uint256 _allowance = allowed[_from][msg.sender];
187 
188     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
189     // require (_value <= _allowance);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = _allowance.sub(_value);
194     Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    */
230   function increaseApproval (address _spender, uint _addedValue)
231     returns (bool success) {
232     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   function decreaseApproval (address _spender, uint _subtractedValue)
238     returns (bool success) {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 
259 contract MintableToken is StandardToken, Ownable {
260   event Mint(address indexed to, uint256 amount);
261   event MintFinished();
262 
263   bool public mintingFinished = false;
264 
265 
266   modifier canMint() {
267     require(!mintingFinished);
268     _;
269   }
270 
271   /**
272    * @dev Function to mint tokens
273    * @param _to The address that will receive the minted tokens.
274    * @param _amount The amount of tokens to mint.
275    * @return A boolean that indicates if the operation was successful.
276    */
277 
278   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
279     balances[_to] = balances[_to].add(_amount);
280     Mint(_to, _amount);
281     Transfer(msg.sender, _to, _amount);
282     return true;
283   }
284 
285   /**
286    * @dev Function to stop minting new tokens.
287    * @return True if the operation was successful.
288    */
289   function finishMinting() onlyOwner public returns (bool) {
290     mintingFinished = true;
291     MintFinished();
292     return true;
293   }
294 
295   function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {
296     totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);
297   }
298 
299 }
300 
301 
302 
303 
304 
305 
306 
307 
308 
309 /**
310  * @title Pausable
311  * @dev Base contract which allows children to implement an emergency stop mechanism.
312  */
313 contract Pausable is Ownable {
314   event Pause();
315   event Unpause();
316 
317   bool public paused = false;
318 
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is not paused.
322    */
323   modifier whenNotPaused() {
324     require(!paused);
325     _;
326   }
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is paused.
330    */
331   modifier whenPaused() {
332     require(paused);
333     _;
334   }
335 
336   /**
337    * @dev called by the owner to pause, triggers stopped state
338    */
339   function pause() onlyOwner whenNotPaused public {
340     paused = true;
341     Pause();
342   }
343 
344   /**
345    * @dev called by the owner to unpause, returns to normal state
346    */
347   function unpause() onlyOwner whenPaused public {
348     paused = false;
349     Unpause();
350   }
351 }
352 
353 /**
354  * @title Med-h Crowdsale
355  * @dev Crowdsale is a base contract for managing a token crowdsale.
356  * Crowdsales have a start and end timestamps, where investors can make
357  * token purchases and the crowdsale will assign them tokens based
358  * on a token per ETH rate. Funds collected are forwarded to a wallet
359  * as they arrive.
360  */
361 contract Crowdsale is Ownable, Pausable {
362 
363   using SafeMath for uint256;
364 
365   /**
366    *  @MintableToken token - Token Object
367    *  @address wallet - Wallet Address
368    *  @uint256 rate - Tokens per Ether
369    *  @uint256 weiRaised - Total funds raised in Ethers
370   */
371   MintableToken internal token;
372   address internal wallet;
373   uint256 public rate;
374   uint256 internal weiRaised;
375 
376  /**
377     *  @uint256 preICOstartTime - pre ICO Start Time
378     *  @uint256 preICOEndTime - pre ICO End Time
379     *  @uint256 ICOstartTime - ICO Start Time
380     *  @uint256 ICOEndTime - ICO End Time
381     */
382     uint256 public preICOstartTime;
383     uint256 public preICOEndTime;
384   
385     uint256 public ICOstartTime;
386     uint256 public ICOEndTime;
387     
388     // Weeks in UTC
389     uint public StageOne;
390     uint public StageTwo;
391     uint public StageThree;
392     uint public StageFour;
393 
394     /**
395     *  @uint preIcoBonus 
396     *  @uint StageOneBonus 
397     *  @uint StageTwoBonus
398     *  @uint StageThreeBonus
399     *  @uint StageFourBonus 
400     */
401     uint public StageOneBonus;
402     uint public StageTwoBonus;
403     uint public StageThreeBonus;
404     uint public StageFourBonus;
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
477     preICOEndTime = 1547769600;  //SafeMath.add(preICOstartTime,3 minutes);   Jan - 18 - 2019
478     ICOstartTime = 1548633600; //SafeMath.add(preICOEndTime, 1 minutes); Jan - 28 - 2019
479     ICOEndTime = _endTime; // March - 19 - 2019
480     rate = _rate; 
481     wallet = _wallet;
482 
483     /** Calculations of Bonuses in private Sale or Pre-ICO */
484     StageOneBonus = SafeMath.div(SafeMath.mul(rate,20),100);
485     StageTwoBonus = SafeMath.div(SafeMath.mul(rate,15),100);
486     StageThreeBonus = SafeMath.div(SafeMath.mul(rate,10),100);
487     StageFourBonus = SafeMath.div(SafeMath.mul(rate,5),100);
488 
489     /** ICO bonuses week calculations */
490     StageOne = SafeMath.add(ICOstartTime, 12 days);
491     StageTwo = SafeMath.add(StageOne, 12 days);
492     StageThree = SafeMath.add(StageTwo, 12 days);
493     StageFour = SafeMath.add(StageThree, 12 days);
494 
495     /** Vested Period calculations for team and advisors*/
496     founderTimeLock = SafeMath.add(ICOEndTime, 3 minutes);
497     advisorTimeLock = SafeMath.add(ICOEndTime, 3 minutes);
498     reserveTimeLock = SafeMath.add(ICOEndTime, 3 minutes);
499     teamTimeLock = SafeMath.add(ICOEndTime, 3 minutes);
500     
501     checkBurnTokens = false;
502     upgradeICOSupply = false;
503     grantReserveSupply = false;
504   }
505 
506   // creates the token to be sold.
507   // override this method to have crowdsale of a specific mintable token.
508   function createTokenContract() internal returns (MintableToken) {
509     return new MintableToken();
510   }
511   /**
512    * function preIcoTokens - Calculate Tokens in of PRE-ICO 
513    */
514   function preIcoTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
515   
516     require(preIcoSupply > 0);
517 
518     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
519 
520     require(preIcoSupply >= tokens);
521     
522     preIcoSupply = preIcoSupply.sub(tokens);        
523     publicSupply = publicSupply.sub(tokens);
524 
525     return tokens;     
526   }
527 
528   /**
529    * function icoTokens - Calculate Tokens in Main ICO
530    */
531   function icoTokens(uint256 weiAmount, uint256 tokens, uint256 accessTime) internal returns (uint256) {
532 
533     require(icoSupply > 0);
534 
535       if ( accessTime <= StageOne ) { 
536         tokens = SafeMath.add(tokens, weiAmount.mul(StageOneBonus));
537       } else if (( accessTime <= StageTwo ) && (accessTime > StageOne)) { 
538         tokens = SafeMath.add(tokens, weiAmount.mul(StageTwoBonus));
539       } else if (( accessTime <= StageThree ) && (accessTime > StageTwo)) {  
540         tokens = SafeMath.add(tokens, weiAmount.mul(StageThreeBonus));
541       } else if (( accessTime <= StageFour ) && (accessTime > StageThree)) {  
542         tokens = SafeMath.add(tokens, weiAmount.mul(StageFourBonus));
543       }
544         tokens = SafeMath.add(tokens, weiAmount.mul(rate)); 
545       require(icoSupply >= tokens);
546       
547       icoSupply = icoSupply.sub(tokens);        
548       publicSupply = publicSupply.sub(tokens);
549 
550       return tokens;
551   }
552   
553 
554   // fallback function can be used to buy tokens
555   function () payable {
556     buyTokens(msg.sender);
557   }
558 
559   // High level token purchase function
560   function buyTokens(address beneficiary) whenNotPaused public payable {
561     require(beneficiary != 0x0);
562     require(validPurchase());
563 
564     uint256 weiAmount = msg.value;
565     // minimum investment should be 0.05 ETH 
566     require((weiAmount >= 50000000000000000));
567     
568     uint256 accessTime = now;
569     uint256 tokens = 0;
570 
571 
572    if ((accessTime >= preICOstartTime) && (accessTime <= preICOEndTime)) {
573            tokens = preIcoTokens(weiAmount, tokens);
574 
575     } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) {
576        if (!upgradeICOSupply) {
577           icoSupply = SafeMath.add(icoSupply,preIcoSupply);
578           upgradeICOSupply = true;
579         }
580        tokens = icoTokens(weiAmount, tokens, accessTime);
581     } else {
582       revert();
583     }
584     
585     weiRaised = weiRaised.add(weiAmount);
586      if(msg.data.length == 20) {
587     address referer = bytesToAddress(bytes(msg.data));
588     // self-referrer check
589     require(referer != msg.sender);
590     uint refererTokens = tokens.mul(6).div(100);
591     // bonus for referrer
592     token.mint(referer, refererTokens);
593   }
594     token.mint(beneficiary, tokens);
595     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
596     forwardFunds();
597   }
598 
599   // send ether to the fund collection wallet
600   function forwardFunds() internal {
601     wallet.transfer(msg.value);
602   }
603 
604 function bytesToAddress(bytes source) internal pure returns(address) {
605   uint result;
606   uint mul = 1;
607   for(uint i = 20; i > 0; i--) {
608     result += uint8(source[i-1])*mul;
609     mul = mul*256;
610   }
611   return address(result);
612 }
613   // @return true if the transaction can buy tokens
614   function validPurchase() internal constant returns (bool) {
615     bool withinPeriod = now >= preICOstartTime && now <= ICOEndTime;
616     bool nonZeroPurchase = msg.value != 0;
617     return withinPeriod && nonZeroPurchase;
618   }
619 
620   // @return true if crowdsale event has ended
621   function hasEnded() public constant returns (bool) {
622       return now > ICOEndTime;
623   }
624 
625   function getTokenAddress() onlyOwner public returns (address) {
626     return token;
627   }
628 
629 }
630 
631 
632 
633 
634 
635 contract Allocations is Crowdsale {
636 
637     function bountyDrop(address[] recipients, uint256[] values) public onlyOwner {
638 
639         for (uint256 i = 0; i < recipients.length; i++) {
640             values[i] = SafeMath.mul(values[i], 1 ether);
641             require(bountySupply >= values[i]);
642             bountySupply = SafeMath.sub(bountySupply,values[i]);
643 
644             token.mint(recipients[i], values[i]);
645         }
646     }
647 
648     function rewardDrop(address[] recipients, uint256[] values) public onlyOwner {
649 
650         for (uint256 i = 0; i < recipients.length; i++) {
651             values[i] = SafeMath.mul(values[i], 1 ether);
652             require(rewardSupply >= values[i]);
653             rewardSupply = SafeMath.sub(rewardSupply,values[i]);
654 
655             token.mint(recipients[i], values[i]);
656         }
657     }
658 
659     function grantAdvisorToken(address beneficiary ) public onlyOwner {
660         require((advisorCounter < 4) && (advisorTimeLock < now));
661         advisorTimeLock = SafeMath.add(advisorTimeLock, 2 minutes);
662         token.mint(beneficiary,SafeMath.div(advisorSupply, 4));
663         advisorCounter = SafeMath.add(advisorCounter, 1);    
664     }
665 
666     function grantFounderToken(address founderAddress) public onlyOwner {
667         require((founderCounter < 4) && (founderTimeLock < now));
668         founderTimeLock = SafeMath.add(founderTimeLock, 2 minutes);
669         token.mint(founderAddress,SafeMath.div(founderSupply, 4));
670         founderCounter = SafeMath.add(founderCounter, 1);        
671     }
672 
673     function grantTeamToken(address teamAddress) public onlyOwner {
674         require((teamCounter < 2) && (teamTimeLock < now));
675         teamTimeLock = SafeMath.add(teamTimeLock, 2 minutes);
676         token.mint(teamAddress,SafeMath.div(teamSupply, 4));
677         teamCounter = SafeMath.add(teamCounter, 1);        
678     }
679 
680     function grantReserveToken(address beneficiary) public onlyOwner {
681         require((!grantReserveSupply) && (now > reserveTimeLock));
682         grantReserveSupply = true;
683         token.mint(beneficiary,reserveSupply);
684         reserveSupply = 0;
685     }
686 
687     function transferFunds(address[] recipients, uint256[] values) public onlyOwner {
688         require(!checkBurnTokens);
689         for (uint256 i = 0; i < recipients.length; i++) {
690             values[i] = SafeMath.mul(values[i], 1 ether);
691             require(publicSupply >= values[i]);
692             publicSupply = SafeMath.sub(publicSupply,values[i]);
693             token.mint(recipients[i], values[i]); 
694             }
695     } 
696 
697     function burnToken() public onlyOwner returns (bool) {
698         require(hasEnded());
699         require(!checkBurnTokens);
700         // token.burnTokens(icoSupply);
701         totalSupply = SafeMath.sub(totalSupply, icoSupply);
702         publicSupply = 0;
703         preIcoSupply = 0;
704         icoSupply = 0;
705         checkBurnTokens = true;
706 
707         return true;
708     }
709 
710 }
711 
712 
713 
714 
715 
716 /**
717  * @title CappedCrowdsale
718  * @dev Extension of Crowdsale with a max amount of funds raised
719  */
720 contract CappedCrowdsale is Crowdsale {
721   using SafeMath for uint256;
722 
723   uint256 internal cap;
724 
725   function CappedCrowdsale(uint256 _cap) {
726     require(_cap > 0);
727     cap = _cap;
728   }
729 
730   // overriding Crowdsale#validPurchase to add extra cap logic
731   // @return true if investors can buy at the moment
732   function validPurchase() internal constant returns (bool) {
733     bool withinCap = weiRaised.add(msg.value) <= cap;
734     return super.validPurchase() && withinCap;
735   }
736 
737   // overriding Crowdsale#hasEnded to add cap logic
738   // @return true if crowdsale event has ended
739   function hasEnded() public constant returns (bool) {
740     bool capReached = weiRaised >= cap;
741     return super.hasEnded() || capReached;
742   }
743 
744 }
745 
746 
747 
748 
749 
750 
751 
752 
753 
754 
755 /**
756  * @title FinalizableCrowdsale
757  * @dev Extension of Crowdsale where an owner can do extra work
758  * after finishing.
759  */
760 contract FinalizableCrowdsale is Crowdsale {
761   using SafeMath for uint256;
762 
763   bool isFinalized = false;
764 
765   event Finalized();
766 
767   /**
768    * @dev Must be called after crowdsale ends, to do some extra finalization
769    * work. Calls the contract's finalization function.
770    */
771   function finalizeCrowdsale() onlyOwner public {
772     require(!isFinalized);
773     require(hasEnded());
774     
775     finalization();
776     Finalized();
777     
778     isFinalized = true;
779     }
780   
781 
782   /**
783    * @dev Can be overridden to add finalization logic. The overriding function
784    * should call super.finalization() to ensure the chain of finalization is
785    * executed entirely.
786    */
787   function finalization() internal {
788   }
789 }
790 
791 
792 
793 
794 
795 
796 /**
797  * @title RefundVault
798  * @dev This contract is used for storing funds while a crowdsale
799  * is in progress. Supports refunding the money if crowdsale fails,
800  * and forwarding it if crowdsale is successful.
801  */
802 contract RefundVault is Ownable {
803   using SafeMath for uint256;
804 
805   enum State { Active, Refunding, Closed }
806 
807   mapping (address => uint256) public deposited;
808   address public wallet;
809   State public state;
810 
811   event Closed();
812   event RefundsEnabled();
813   event Refunded(address indexed beneficiary, uint256 weiAmount);
814 
815   function RefundVault(address _wallet) {
816     require(_wallet != 0x0);
817     wallet = _wallet;
818     state = State.Active;
819   }
820 
821   function deposit(address investor) onlyOwner public payable {
822     require(state == State.Active);
823     deposited[investor] = deposited[investor].add(msg.value);
824   }
825 
826   function close() onlyOwner public {
827     require(state == State.Active);
828     state = State.Closed;
829     Closed();
830     wallet.transfer(this.balance);
831   }
832 
833   function enableRefunds() onlyOwner public {
834     require(state == State.Active);
835     state = State.Refunding;
836     RefundsEnabled();
837   }
838 
839   function refund(address investor) public {
840     require(state == State.Refunding);
841     uint256 depositedValue = deposited[investor];
842     deposited[investor] = 0;
843     investor.transfer(depositedValue);
844     Refunded(investor, depositedValue);
845   }
846 }
847 
848 
849 
850 /**
851  * @title RefundableCrowdsale
852  * @dev Extension of Crowdsale contract that adds a funding goal, and
853  * the possibility of users getting a refund if goal is not met.
854  * Uses a RefundVault as the crowdsale's vault.
855  */
856 contract RefundableCrowdsale is FinalizableCrowdsale {
857   using SafeMath for uint256;
858 
859   // minimum amount of funds to be raised in weis
860   uint256 internal goal;
861   // refund vault used to hold funds while crowdsale is running
862   RefundVault private vault;
863 
864   function RefundableCrowdsale(uint256 _goal) {
865     require(_goal > 0);
866     vault = new RefundVault(wallet);
867     goal = _goal;
868   }
869 
870   // We're overriding the fund forwarding from Crowdsale.
871   // In addition to sending the funds, we want to call
872   // the RefundVault deposit function
873   function forwardFunds() internal {
874     vault.deposit.value(msg.value)(msg.sender);
875   }
876 
877   // if crowdsale is unsuccessful, investors can claim refunds here
878   function claimRefund() public {
879     require(isFinalized);
880     require(!goalReached());
881 
882     vault.refund(msg.sender);
883   }
884 
885   // vault finalization task, called when owner calls finalize()
886   function finalization() internal {
887     if (goalReached()) { 
888       vault.close();
889     } else {
890       vault.enableRefunds();
891     }
892     super.finalization();
893   
894   }
895 
896   /**
897    * @dev Checks whether funding goal was reached. 
898    * @return Whether funding goal was reached
899    */
900   function goalReached() public view returns (bool) {
901     return weiRaised >= (goal - (5000 * 1 ether));
902   }
903 
904   function getVaultAddress() onlyOwner public returns (address) {
905     return vault;
906   }
907 }
908 
909 /**
910  * @title EXTP Token
911  */
912 
913 
914 contract TradePlaceToken is MintableToken {
915 
916   string public constant name = "Trade PLace";
917   string public constant symbol = "EXTP";
918   uint8 public constant decimals = 18;
919   uint256 public totalSupply = SafeMath.mul(500000000 , 1 ether); //500000000
920 }
921 
922 
923 
924 
925 
926 contract TradePlaceCrowdsale is Crowdsale, CappedCrowdsale, RefundableCrowdsale, Allocations {
927     /** Constructor TradePlaceCrowdsale */
928     function TradePlaceCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _goal, address _wallet)
929     CappedCrowdsale(_cap)
930     FinalizableCrowdsale()
931     RefundableCrowdsale(_goal)
932     Crowdsale(_startTime, _endTime, _rate, _wallet)
933     {
934     }
935 
936     /**TradePlaceToken Contract is generating from here */
937     function createTokenContract() internal returns (MintableToken) {
938         return new TradePlaceToken();
939     }
940 }