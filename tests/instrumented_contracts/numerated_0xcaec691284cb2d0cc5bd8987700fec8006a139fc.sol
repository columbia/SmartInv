1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20 {
46   function totalSupply() public view returns (uint256);
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 contract Ownable {
53   address public owner;
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() public {
63     owner = msg.sender;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) public onlyOwner {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 }
84 
85 contract StandardToken is ERC20, Ownable {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89   
90   address internal tokensHolder = 0x2Ff4be5E03a079D5FC20Dba8d763059FcB78CA9f;
91   address internal burnAndRef = 0x84765e3f2D0379eC7AAb7de8b480762a75f14ef4;
92 
93   uint256 totalSupply_;
94   uint256 tokensDistributed_;
95   uint256 burnedTokens_;
96 
97   /**
98   * @dev total number of tokens in existence
99   */
100   function totalSupply() public view returns (uint256) {
101     return totalSupply_;
102   }
103   function tokensAvailable() public view returns (uint256) {
104     return balances[tokensHolder];
105   }
106   function tokensDistributed() public view returns (uint256) {
107     return tokensDistributed_;
108   }
109   function getTokensHolder() public view returns (address) {
110     return tokensHolder;
111   }
112   function burnedTokens() public view returns (uint256) {
113     return burnedTokens_;
114   }
115   function getRefAddress() public view returns (address) {
116     return burnAndRef;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     emit Transfer(msg.sender, _to, _value);
132     return true;
133   }
134   
135   function deposit(address _to, uint256 _value) onlyOwner public returns (bool) {
136     require(_to != address(0));
137     require(_value <= tokensAvailable());
138 
139     // SafeMath.sub will throw if there is not enough balance.
140     balances[tokensHolder] = balances[tokensHolder].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     tokensDistributed_ = tokensDistributed_.add(_value);
143     emit Transfer(address(0), _to, _value);
144     return true;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public view returns (uint256 balance) {
153     return balances[_owner];
154   }
155 
156 }
157 
158 contract MintableToken is StandardToken {
159   event Mint(address indexed to, uint256 amount);
160   event MintFinished();
161 
162   bool public mintingFinished = false;
163 
164 
165   modifier canMint() {
166     require(!mintingFinished);
167     _;
168   }
169 
170   /**
171    * @dev Function to mint tokens
172    * @param _to The address that will receive the minted tokens.
173    * @param _amount The amount of tokens to mint.
174    * @return A boolean that indicates if the operation was successful.
175    */
176   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
177     totalSupply_ = totalSupply_.add(_amount);
178     balances[_to] = balances[_to].add(_amount);
179     emit Mint(_to, _amount);
180     emit Transfer(address(0), _to, _amount);
181     return true;
182   }
183 
184   /**
185    * @dev Function to stop minting new tokens.
186    * @return True if the operation was successful.
187    */
188   function finishMinting() onlyOwner canMint public returns (bool) {
189     mintingFinished = true;
190     emit MintFinished();
191     return true;
192   }
193 }
194 
195 contract BurnableToken is MintableToken {
196 
197   event Burn(address indexed burner, uint256 value);
198   
199   function transferToRef(address _to, uint256 _value) public onlyOwner {
200     require(_value <= balances[tokensHolder]);
201 
202     balances[tokensHolder] = balances[tokensHolder].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     tokensDistributed_ = tokensDistributed_.add(_value);
205     emit Transfer(tokensHolder, address(0), _value);
206   }
207   
208   function burnTokens(uint256 _value) public onlyOwner {
209     require(_value <= balances[burnAndRef]);
210 
211     balances[burnAndRef] = balances[burnAndRef].sub(_value);
212     totalSupply_ = totalSupply_.sub(_value);
213     burnedTokens_ = burnedTokens_.add(_value);
214     emit Burn(burnAndRef, _value);
215     emit Transfer(burnAndRef, address(0), _value);
216   }
217 }
218 
219 contract WRLToken is BurnableToken {
220     string public name = "Whyral Token";
221     string public symbol = "WRL";
222     uint256 public decimals = 8;
223     
224     uint256 internal rate;
225     
226     uint256 public currentStage;
227   
228     uint256 internal stage0Cap = 42000000 * (10 ** uint256(decimals));
229     uint256 internal stage1Cap = 71165000 * (10 ** uint256(decimals));  //29165000
230     uint256 internal stage2Cap = 91165000 * (10 ** uint256(decimals));  //20000000
231     uint256 internal stage3Cap = 103497402 * (10 ** uint256(decimals)); //12332402
232 
233     uint256 internal stage0Start = 1523782800; //15 April 2018
234     uint256 internal stage0End = 1527764400;   //31 May 2018
235     uint256 internal stage1Start = 1528016400; //3 June 2018
236     uint256 internal stage1End = 1530356400;   //30 June 2018
237     uint256 internal stage2Start = 1530608400; //3 July 2018
238     uint256 internal stage2End = 1532516400;   //25 July 2018
239     uint256 internal stage3Start = 1532768400; //28 July 2018
240     uint256 internal stage3End = 1534330800;   //15 Aug 2018
241     
242     uint256 internal stage0Rate = 700000;  //1 ETH = 7000.00 Decimal is considered while calculation
243     uint256 internal stage1Rate = 583300;  //1 ETH = 5833.00 Decimal is considered while calculation
244     uint256 internal stage2Rate = 500000;  //1 ETH = 5000.00 Decimal is considered while calculation
245     uint256 internal stage3Rate = 466782;  //1 ETH = 4667.82 Decimal is considered while calculation
246     
247     function getStage0Cap() public view returns (uint256) {
248         return stage0Cap;
249     }
250     function getStage1Cap() public view returns (uint256) {
251         return stage1Cap;
252     }
253     function getStage2Cap() public view returns (uint256) {
254         return stage2Cap;
255     }
256     function getStage3Cap() public view returns (uint256) {
257         return stage3Cap;
258     }
259     function getStage0End() public view returns (uint256) {
260         return stage0End;
261     }
262     function getStage1End() public view returns (uint256) {
263         return stage1End;
264     }
265     function getStage2End() public view returns (uint256) {
266         return stage2End;
267     }
268     function getStage3End() public view returns (uint256) {
269         return stage3End;
270     }
271     function getStage0Start() public view returns (uint256) {
272         return stage0Start;
273     }
274     function getStage1Start() public view returns (uint256) {
275         return stage1Start;
276     }
277     function getStage2Start() public view returns (uint256) {
278         return stage2Start;
279     }
280     function getStage3Start() public view returns (uint256) {
281         return stage3Start;
282     }
283     function getDecimals() public view returns (uint256) {
284         return decimals;
285     }
286 
287     
288     function getRateStages(uint256 _tokens) public onlyOwner returns(uint256) {
289       uint256 tokensDistributedValue = tokensDistributed();
290       tokensDistributedValue = tokensDistributedValue.sub(4650259800000000);
291       uint256 burnedTokensValue = burnedTokens();
292       uint256 currentValue = tokensDistributedValue.add(burnedTokensValue);
293       uint256 finalTokenValue = currentValue.add(_tokens);
294       uint256 toBeBurned;
295       
296       if(now >= stage0Start && now < stage0End) {
297           if(finalTokenValue <= stage0Cap) {
298               rate = stage0Rate;
299               currentStage = 0;
300           }
301           else {
302               rate = 0;
303               currentStage = 0;
304           }
305       }
306       else if(now >= stage1Start && now < stage1End) {
307           if(currentValue < stage0Cap) {
308               toBeBurned = stage0Cap.sub(currentValue);
309               transferToRef(burnAndRef, toBeBurned);
310               
311               finalTokenValue = finalTokenValue.add(toBeBurned);
312               
313               if(finalTokenValue <= stage1Cap) {
314                   rate = stage1Rate;
315                   currentStage = 1;
316               }
317               else {
318                   rate = 0;
319                   currentStage = 1;
320               }
321           }
322           else {
323               if(finalTokenValue <= stage1Cap) {
324                   rate = stage1Rate;
325                   currentStage = 1;
326               }
327               else {
328                   rate = 0;
329                   currentStage = 1;
330               }
331           }
332       }
333       else if(now >= stage2Start && now < stage2End) {
334           if(currentValue < stage1Cap) {
335               toBeBurned = stage1Cap.sub(currentValue);
336               transferToRef(burnAndRef, toBeBurned);
337               
338               finalTokenValue = finalTokenValue.add(toBeBurned);
339               
340               if(finalTokenValue <= stage2Cap) {
341                   rate = stage2Rate;
342                   currentStage = 2;
343               }
344               else {
345                   rate = 0;
346                   currentStage = 2;
347               }
348           }
349           else {
350               if(finalTokenValue <= stage2Cap) {
351                   rate = stage2Rate;
352                   currentStage = 2;
353               }
354               else {
355                   rate = 0;
356                   currentStage = 2;
357               }
358           }
359       }
360       else if(now >= stage3Start && now < stage3End) {
361           if(currentValue < stage2Cap) {
362               toBeBurned = stage2Cap.sub(currentValue);
363               transferToRef(burnAndRef, toBeBurned);
364               
365               finalTokenValue = finalTokenValue.add(toBeBurned);
366               
367               if(finalTokenValue <= stage3Cap) {
368                   rate = stage3Rate;
369                   currentStage = 3;
370               }
371               else {
372                   rate = 0;
373                   currentStage = 3;
374               }
375           }
376           else {
377               if(finalTokenValue <= stage3Cap) {
378                   rate = stage3Rate;
379                   currentStage = 3;
380               }
381               else {
382                   rate = 0;
383                   currentStage = 3;
384               }
385           }
386       }
387       else if(now >= stage3End) {
388           if(currentValue < stage3Cap) {
389               toBeBurned = stage3Cap.sub(currentValue);
390               transferToRef(burnAndRef, toBeBurned);
391               
392               rate = 0;
393               currentStage = 4;
394           }
395           else {
396               rate = 0;
397               currentStage = 4;
398           }
399       }
400       else {
401           rate = 0;
402       }
403       
404       return rate;
405   }
406     
407     function WRLToken() public {
408         totalSupply_ = 0;
409         tokensDistributed_ = 0;
410         currentStage = 0;
411         
412         uint256 __initialSupply = 150000000 * (10 ** uint256(decimals));
413         address tokensHolder = getTokensHolder();
414         mint(tokensHolder, __initialSupply);
415         finishMinting();
416     }
417 }
418 
419 contract TimedCrowdsale {
420   using SafeMath for uint256;
421 
422   uint256 public openingTime;
423   uint256 public closingTime;
424 
425   /**
426    * @dev Reverts if not in crowdsale time range. 
427    */
428   modifier onlyWhileOpen {
429     require(now >= openingTime && now <= closingTime);
430     _;
431   }
432 
433   /**
434    * @dev Constructor, takes crowdsale opening and closing times.
435    * @param _openingTime Crowdsale opening time
436    * @param _closingTime Crowdsale closing time
437    */
438   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
439     require(_openingTime >= now);
440     require(_closingTime >= _openingTime);
441 
442     openingTime = _openingTime;
443     closingTime = _closingTime;
444   }
445 
446   /**
447    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
448    * @return Whether crowdsale period has elapsed
449    */
450   function hasClosed() public view returns (bool) {
451     return now > closingTime;
452   }
453   
454   function isOpen() public view returns (bool) {
455     return ((now > openingTime) && (now < closingTime));
456   }
457   
458   /**
459    * @dev Extend parent behavior requiring to be within contributing period
460    * @param _beneficiary Token purchaser
461    * @param _weiAmount Amount of wei contributed
462    */
463   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
464     //super._preValidatePurchase(_beneficiary, _weiAmount);
465   }
466 
467 }
468 
469 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
470   using SafeMath for uint256;
471 
472   bool public isFinalized = false;
473   
474   // The token being sold
475   WRLToken public token;
476 
477   event Finalized();
478 
479   /**
480    * @dev Must be called after crowdsale ends, to do some extra finalization
481    * work. Calls the contract's finalization function.
482    */
483   function finalize() onlyOwner public {
484     require(!isFinalized);
485     require(hasClosed());
486 
487     finalization();
488     emit Finalized();
489 
490     isFinalized = true;
491   }
492 
493   /**
494    * @dev Can be overridden to add finalization logic. The overriding function
495    * should call super.finalization() to ensure the chain of finalization is
496    * executed entirely.
497    */
498   function finalization() internal {
499       token.getRateStages(0);
500   }
501 }
502 
503 contract WhitelistedCrowdsale is FinalizableCrowdsale {
504 
505   mapping(address => bool) public whitelist;
506 
507   /**
508    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
509    */
510   modifier isWhitelisted(address _beneficiary) {
511     require(whitelist[_beneficiary]);
512     _;
513   }
514 
515   /**
516    * @dev Adds single address to whitelist.
517    * @param _beneficiary Address to be added to the whitelist
518    */
519   function addToWhitelist(address _beneficiary) external onlyOwner {
520     whitelist[_beneficiary] = true;
521   }
522 
523   /**
524    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
525    * @param _beneficiaries Addresses to be added to the whitelist
526    */
527   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
528     for (uint256 i = 0; i < _beneficiaries.length; i++) {
529       whitelist[_beneficiaries[i]] = true;
530     }
531   }
532 
533   /**
534    * @dev Removes single address from whitelist.
535    * @param _beneficiary Address to be removed to the whitelist
536    */
537   function removeFromWhitelist(address _beneficiary) external onlyOwner {
538     whitelist[_beneficiary] = false;
539   }
540 
541   /**
542    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
543    * @param _beneficiary Token beneficiary
544    * @param _weiAmount Amount of wei contributed
545    */
546   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
547     super._preValidatePurchase(_beneficiary, _weiAmount);
548   }
549 
550 }
551 
552 contract WRLCrowdsale is WhitelistedCrowdsale {
553   using SafeMath for uint256;
554 
555   // Address where funds are collected
556   address public wallet = 0x4fB0346F51fA853639EC0d0dA211Cb6F3e27a1f5;
557   // Other Addresses
558   address internal foundersAndTeam = 0x2E6f0ebFdee59546f224450Ba0c8F0522cedA2e9;
559   address internal advisors = 0xCa502d4cEaa99Bf1aD554f91FD2A9013511629D4;
560   address internal bounties = 0x45138E31Ab7402b8Cf363F9d4e732fdb020e5Dd8;
561   address internal reserveFund = 0xE9ebcAdB98127e3CDe242EaAdcCb57BF0d9576Cc;
562   
563   uint256 internal foundersAndTeamTokens = 22502598 * (10 ** uint256(8));
564   uint256 internal advisorsTokens = 12000000 * (10 ** uint256(8));
565   uint256 internal bountiesTokens = 6000000 * (10 ** uint256(8));
566   uint256 internal reserveFundTokens = 6000000 * (10 ** uint256(8));
567     
568   // Amount of wei raised
569   uint256 public weiRaised;
570 
571   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
572   
573   //1523782800 : 15 April 2018
574   //1534330800 : 15 Aug 2018
575   function WRLCrowdsale() public 
576      TimedCrowdsale(1523782800, 1534330800)
577   {
578       weiRaised = 0;
579       
580       token = new WRLToken();
581       
582       token.deposit(foundersAndTeam, foundersAndTeamTokens);
583       token.deposit(advisors, advisorsTokens);
584       token.deposit(bounties, bountiesTokens);
585       token.deposit(reserveFund, reserveFundTokens);
586   }
587   
588   /**
589    * @dev fallback function ***DO NOT OVERRIDE***
590    */
591   function () external payable {
592     buyTokens(msg.sender);
593   }
594 
595   /**
596    * @dev low level token purchase ***DO NOT OVERRIDE***
597    * @param _beneficiary Address performing the token purchase
598    */
599   function buyTokens(address _beneficiary) public payable {
600     require(msg.value >= 100000000000000000);
601     uint256 weiAmount = msg.value;
602     _preValidatePurchase(_beneficiary, weiAmount);
603 
604     // calculate token amount to be created
605     uint256 tokens = _getTokenAmount(weiAmount);
606 
607     // update state
608     weiRaised = weiRaised.add(weiAmount);
609     uint256 rate = token.getRateStages(tokens);
610     require(rate != 0);
611 
612     _processPurchase(_beneficiary, tokens);
613     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
614 
615     _updatePurchasingState(_beneficiary, weiAmount);
616 
617     _forwardFunds();
618     _postValidatePurchase(_beneficiary, weiAmount);
619   }
620   
621   function referralTokens(address _beneficiary, uint256 _tokens) onlyOwner public {
622       uint256 decimals = token.getDecimals();
623       _tokens = _tokens * (10 ** uint256(decimals));
624       _preValidatePurchase(_beneficiary, _tokens);
625       
626       uint256 rate = token.getRateStages(_tokens);
627       require(rate != 0);
628       
629       _processPurchase(_beneficiary, _tokens);
630       emit TokenPurchase(msg.sender, _beneficiary, 0, _tokens);
631       
632       _updatePurchasingState(_beneficiary, 0);
633       
634       _postValidatePurchase(_beneficiary, 0);
635   }
636   
637   function callStages() onlyOwner public {
638       token.getRateStages(0);
639   }
640   
641   function callBurnTokens(uint256 _tokens) public {
642       address a = token.getRefAddress();
643       require(msg.sender == a);
644       
645       token.burnTokens(_tokens);
646   }
647 
648   // -----------------------------------------
649   // Internal interface (extensible)
650   // -----------------------------------------
651 
652   /**
653    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
654    * @param _beneficiary Address performing the token purchase
655    * @param _weiAmount Value in wei involved in the purchase
656    */
657   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
658     require(_beneficiary != address(0));
659     require(_weiAmount != 0);
660     super._preValidatePurchase(_beneficiary, _weiAmount);
661   }
662 
663   /**
664    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
665    * @param _beneficiary Address performing the token purchase
666    * @param _weiAmount Value in wei involved in the purchase
667    */
668   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
669   }
670 
671   /**
672    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
673    * @param _beneficiary Address performing the token purchase
674    * @param _tokenAmount Number of tokens to be emitted
675    */
676   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
677     require(_tokenAmount <= token.tokensAvailable());
678 
679     token.deposit(_beneficiary, _tokenAmount);
680   }
681 
682   /**
683    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
684    * @param _beneficiary Address receiving the tokens
685    * @param _tokenAmount Number of tokens to be purchased
686    */
687   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
688     _deliverTokens(_beneficiary, _tokenAmount);
689   }
690 
691   /**
692    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
693    * @param _beneficiary Address receiving the tokens
694    * @param _weiAmount Value in wei involved in the purchase
695    */
696   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
697   }
698 
699   /**
700    * @dev Override to extend the way in which ether is converted to tokens.
701    * @param _weiAmount Value in wei to be converted into tokens
702    * @return Number of tokens that can be purchased with the specified _weiAmount
703    */
704   function _getTokenAmount(uint256 _weiAmount) internal returns (uint256) {
705       uint256 tokenAmount = _weiAmount;
706       uint256 rate = token.getRateStages(0);
707       require(rate != 0);
708       tokenAmount = tokenAmount.mul(rate);
709       tokenAmount = tokenAmount.div(1000000000000);
710       return tokenAmount;
711   }
712 
713   /**
714    * @dev Determines how ETH is stored/forwarded on purchases.
715    */
716   function _forwardFunds() internal {
717     wallet.transfer(msg.value);
718   }
719 }