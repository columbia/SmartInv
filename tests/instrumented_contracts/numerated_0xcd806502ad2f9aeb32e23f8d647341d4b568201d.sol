1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   uint256 totalSupply_;
16 
17   /**
18   * @dev total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31     require(_value <= balances[msg.sender]);
32 
33     // SafeMath.sub will throw if there is not enough balance.
34     balances[msg.sender] = balances[msg.sender].sub(_value);
35     balances[_to] = balances[_to].add(_value);
36     Transfer(msg.sender, _to, _value);
37     return true;
38   }
39 
40   /**
41   * @dev Gets the balance of the specified address.
42   * @param _owner The address to query the the balance of.
43   * @return An uint256 representing the amount owned by the passed address.
44   */
45   function balanceOf(address _owner) public view returns (uint256 balance) {
46     return balances[_owner];
47   }
48 
49 }
50 
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public view returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * @dev Increase the amount of tokens that an owner allowed to a spender.
151    *
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    * @param _spender The address which will spend the funds.
157    * @param _addedValue The amount of tokens to increase the allowance by.
158    */
159   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   /**
166    * @dev Decrease the amount of tokens that an owner allowed to a spender.
167    *
168    * approve should be called when allowed[_spender] == 0. To decrement
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _subtractedValue The amount of tokens to decrease the allowance by.
174    */
175   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract Ownable {
189   address public owner;
190 
191 
192   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   function Ownable() public {
200     owner = msg.sender;
201   }
202 
203   /**
204    * @dev Throws if called by any account other than the owner.
205    */
206   modifier onlyOwner() {
207     require(msg.sender == owner);
208     _;
209   }
210 
211   /**
212    * @dev Allows the current owner to transfer control of the contract to a newOwner.
213    * @param newOwner The address to transfer ownership to.
214    */
215   function transferOwnership(address newOwner) public onlyOwner {
216     require(newOwner != address(0));
217     OwnershipTransferred(owner, newOwner);
218     owner = newOwner;
219   }
220 
221 }
222 
223 contract Pausable is Ownable {
224   event Pause();
225   event Unpause();
226 
227   bool public paused = false;
228 
229 
230   /**
231    * @dev Modifier to make a function callable only when the contract is not paused.
232    */
233   modifier whenNotPaused() {
234     require(!paused);
235     _;
236   }
237 
238   /**
239    * @dev Modifier to make a function callable only when the contract is paused.
240    */
241   modifier whenPaused() {
242     require(paused);
243     _;
244   }
245 
246   /**
247    * @dev called by the owner to pause, triggers stopped state
248    */
249   function pause() onlyOwner whenNotPaused public {
250     paused = true;
251     Pause();
252   }
253 
254   /**
255    * @dev called by the owner to unpause, returns to normal state
256    */
257   function unpause() onlyOwner whenPaused public {
258     paused = false;
259     Unpause();
260   }
261 }
262 
263 contract THTokenSale is Pausable {
264     using SafeMath for uint256;
265 
266     // Sale Token
267     THToken public token;
268 
269     // Total wei raised
270     uint256 public fundsRaised = 0;
271 
272     // Minimal possible cap in ethers
273     // @dev NEEDS to be the same as Stage 1 cap now.
274     uint256 public constant SOFT_CAP = 3000 ether;
275 
276     // Maximum possible cap in ethers
277     uint256 public constant HARD_CAP = 12000 ether;
278 
279     bool public softCapReached = false;
280     bool public hardCapReached = false;
281     bool public saleSuccessfullyFinished = false;
282 
283     /**
284      * Stage 1: 3000 ether worth of THT available at 40% bonus
285      * Stage 2: 1800 ether worth of THT available at 20% bonus
286      * Stage 3: 2250 ether worth of THT available at 10% bonus
287      * Stage 4: 2250 ether worth of THT available at 5% bonus
288      * Stage 5: 2700 ether worth of THT available with no bonus
289      */
290     uint256[5] public stageCaps = [
291         3000 ether,
292         4800 ether,
293         7050 ether,
294         9300 ether,
295         12000 ether
296     ];
297     uint256[5] public stageTokenMul = [
298         5040,
299         4320,
300         3960,
301         3780,
302         3600
303     ];
304     uint256 public activeStage = 0;
305 
306     // Minimum investment during first 48 hours
307     uint256 public constant MIN_INVESTMENT_PHASE1 = 5 ether;
308     // Minimum investment
309     uint256 public constant MIN_INVESTMENT = 0.1 ether;
310 
311     // refundAllowed can be set to true if SOFT_CAP is not reached
312     bool public refundAllowed = false;
313     // Token Allocation for Bounty(5%), Advisors (5%), Platform (10%)
314     uint256[3] public varTokenAllocation = [5, 5, 10];
315     // 20% vested over 4 segments for Core Team
316     uint256[4] public teamTokenAllocation = [5, 5, 5, 5];
317     // 60% crowdsale
318     uint256 public constant CROWDSALE_ALLOCATION = 60;
319 
320     // Vested amounts of tokens, filled with proper values when finalizing
321     uint256[4] public vestedTeam = [0, 0, 0, 0];
322     uint256 public vestedAdvisors = 0;
323 
324     // Withdraw
325     address public wallet;
326     // CoreTeam Vested
327     address public walletCoreTeam;
328     // Platform THT
329     address public walletPlatform;
330     // Bounty and Advisors THT
331     address public walletBountyAndAdvisors;
332 
333     // start and end timestamp when investments are allowed (both inclusive)
334     uint256 public startTime;
335     uint256 public endTime;
336 
337     // Whitelisted addresses and their allocations of wei available to invest
338     mapping(address => uint256) public whitelist;
339 
340     // Wei received from token buyers
341     mapping(address => uint256) public weiBalances;
342 
343     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
344     event Whitelisted(address indexed beneficiary, uint256 value);
345     event SoftCapReached();
346     event HardCapReached();
347     event Finalized(bool successfullyFinished);
348     event StageOpened(uint stage);
349     event StageClosed(uint stage);
350 
351     /**
352     * @dev Modifier to make a function callable only during the sale
353     */
354     modifier beforeSaleEnds() {
355         // Not calling hasEnded due to lower gas usage
356         require(now < endTime && fundsRaised < HARD_CAP);
357         _;
358     }
359 
360     function THTokenSale(
361         uint256 _startTime,
362         address _wallet,
363         address _walletCoreTeam,
364         address _walletPlatform,
365         address _walletBountyAndAdvisors
366     ) public {
367         require(_startTime >= now);
368         require(_wallet != 0x0);
369         require(_walletCoreTeam != 0x0);
370         require(_walletPlatform != 0x0);
371         require(_walletBountyAndAdvisors != 0x0);
372         require(vestedTeam.length == teamTokenAllocation.length);   // sanity checks
373         require(stageCaps.length == stageTokenMul.length);   // sanity checks
374 
375         token = new THToken();
376         wallet = _wallet;
377         walletCoreTeam = _walletCoreTeam;
378         walletPlatform = _walletPlatform;
379         walletBountyAndAdvisors = _walletBountyAndAdvisors;
380         startTime = _startTime;
381         // Sale lasts up to 4 weeks and 4 days
382         endTime = _startTime + 32 * 86400;
383     }
384 
385     /*
386      * @dev fallback for processing ether
387      */
388     function() public payable {
389         buyTokens(msg.sender);
390     }
391 
392     /*
393      * @dev Sale is executed in stages/tranches. Each stage except the first is activated manually by the owner.
394      * Only allow next stage when current stage/tranche is filled to cap.
395      */
396     function activateNextStage() onlyOwner public {
397         uint256 stageIndex = activeStage;
398         require(fundsRaised >= stageCaps[stageIndex]);
399         require(stageIndex + 1 < stageCaps.length);
400 
401         activeStage = stageIndex + 1;
402         StageOpened(activeStage + 1);
403     }
404 
405     /*
406      * @dev sell token and send to contributor address
407      * @param contributor address
408      */
409     function buyTokens(address contributor) whenNotPaused beforeSaleEnds public payable {
410         uint256 _stageIndex = activeStage;
411         uint256 refund = 0;
412         uint256 weiAmount = msg.value;
413         uint256 _activeStageCap = stageCaps[_stageIndex];
414 
415         require(fundsRaised < _activeStageCap);
416         require(validPurchase());
417         require(canContribute(contributor, weiAmount));
418 
419         uint256 capDelta = _activeStageCap.sub(fundsRaised);
420 
421         if (capDelta < weiAmount) {
422             // Not enough tokens available for full contribution, we will do a partial.
423             weiAmount = capDelta;
424             // Calculate refund for contributor.
425             refund = msg.value.sub(weiAmount);
426         }
427 
428         uint256 tokensToMint = weiAmount.mul(stageTokenMul[_stageIndex]);
429 
430         whitelist[contributor] = whitelist[contributor].sub(weiAmount);
431         weiBalances[contributor] = weiBalances[contributor].add(weiAmount);
432 
433         fundsRaised = fundsRaised.add(weiAmount);
434         token.mint(contributor, tokensToMint);
435 
436         // Refund after state changes for re-entrancy safety
437         if (refund > 0) {
438             msg.sender.transfer(refund);
439         }
440         TokenPurchase(0x0, contributor, weiAmount, tokensToMint);
441 
442         if (fundsRaised >= _activeStageCap) {
443             finalizeCurrentStage();
444         }
445     }
446 
447     function canContribute(address contributor, uint256 weiAmount) public view returns (bool) {
448         require(contributor != 0x0);
449         require(weiAmount > 0);
450         return (whitelist[contributor] >= weiAmount);
451     }
452 
453     function addWhitelist(address contributor, uint256 weiAmount) onlyOwner public returns (bool) {
454         require(contributor != 0x0);
455         require(weiAmount > 0);
456         // Only ever set the new amount, even if user is already whitelisted with a previous value set
457         whitelist[contributor] = weiAmount;
458         Whitelisted(contributor, weiAmount);
459         return true;
460     }
461 
462     /*
463      * @dev Add participants to whitelist in bulk
464      */
465     function addWhitelistBulk(address[] contributors, uint256[] amounts) onlyOwner beforeSaleEnds public returns (bool) {
466         address contributor;
467         uint256 amount;
468         require(contributors.length == amounts.length);
469 
470         for (uint i = 0; i < contributors.length; i++) {
471             contributor = contributors[i];
472             amount = amounts[i];
473             require(addWhitelist(contributor, amount));
474         }
475         return true;
476     }
477 
478     function withdraw() onlyOwner public {
479         require(softCapReached);
480         require(this.balance > 0);
481 
482         wallet.transfer(this.balance);
483     }
484 
485     function withdrawCoreTeamTokens() onlyOwner public {
486         require(saleSuccessfullyFinished);
487 
488         if (now > startTime + 720 days && vestedTeam[3] > 0) {
489             token.transfer(walletCoreTeam, vestedTeam[3]);
490             vestedTeam[3] = 0;
491         }
492         if (now > startTime + 600 days && vestedTeam[2] > 0) {
493             token.transfer(walletCoreTeam, vestedTeam[2]);
494             vestedTeam[2] = 0;
495         }
496         if (now > startTime + 480 days && vestedTeam[1] > 0) {
497             token.transfer(walletCoreTeam, vestedTeam[1]);
498             vestedTeam[1] = 0;
499         }
500         if (now > startTime + 360 days && vestedTeam[0] > 0) {
501             token.transfer(walletCoreTeam, vestedTeam[0]);
502             vestedTeam[0] = 0;
503         }
504     }
505 
506     function withdrawAdvisorTokens() onlyOwner public {
507         require(saleSuccessfullyFinished);
508 
509         if (now > startTime + 180 days && vestedAdvisors > 0) {
510             token.transfer(walletBountyAndAdvisors, vestedAdvisors);
511             vestedAdvisors = 0;
512         }
513     }
514 
515     /*
516      * @dev Leave token balance as is.
517      * The tokens are unusable if a refund call could be successful due to transferAllowed = false upon failing to reach SOFT_CAP.
518      */
519     function refund() public {
520         require(refundAllowed);
521         require(!softCapReached);
522         require(weiBalances[msg.sender] > 0);
523 
524         uint256 currentBalance = weiBalances[msg.sender];
525         weiBalances[msg.sender] = 0;
526         msg.sender.transfer(currentBalance);
527     }
528 
529     /*
530      * @dev When finishing the crowdsale we mint non-crowdsale tokens based on total tokens minted during crowdsale
531      */
532     function finishCrowdsale() onlyOwner public returns (bool) {
533         require(now >= endTime || fundsRaised >= HARD_CAP);
534         require(!saleSuccessfullyFinished && !refundAllowed);
535 
536         // Crowdsale successful
537         if (softCapReached) {
538             uint256 _crowdsaleAllocation = CROWDSALE_ALLOCATION; // 60% crowdsale
539             uint256 crowdsaleTokens = token.totalSupply();
540 
541             uint256 tokensBounty = crowdsaleTokens.mul(varTokenAllocation[0]).div(_crowdsaleAllocation); // 5% Bounty
542             uint256 tokensAdvisors = crowdsaleTokens.mul(varTokenAllocation[1]).div(_crowdsaleAllocation); // 5% Advisors
543             uint256 tokensPlatform = crowdsaleTokens.mul(varTokenAllocation[2]).div(_crowdsaleAllocation); // 10% Platform
544 
545             vestedAdvisors = tokensAdvisors;
546 
547             // 20% Team
548             uint256 tokensTeam = 0;
549             uint len = teamTokenAllocation.length;
550             uint amount = 0;
551             for (uint i = 0; i < len; i++) {
552                 amount = crowdsaleTokens.mul(teamTokenAllocation[i]).div(_crowdsaleAllocation);
553                 vestedTeam[i] = amount;
554                 tokensTeam = tokensTeam.add(amount);
555             }
556 
557             token.mint(walletBountyAndAdvisors, tokensBounty);
558             token.mint(walletPlatform, tokensPlatform);
559 
560             token.mint(this, tokensAdvisors);
561             token.mint(this, tokensTeam);
562 
563             token.endMinting(true);
564             saleSuccessfullyFinished = true;
565             Finalized(true);
566             return true;
567         } else {
568             refundAllowed = true;
569             // Token contract gets destroyed
570             token.endMinting(false);
571             Finalized(false);
572             return false;
573         }
574     }
575 
576     // @return user balance
577     function balanceOf(address _owner) public view returns (uint256 balance) {
578         return token.balanceOf(_owner);
579     }
580 
581     function hasStarted() public view returns (bool) {
582         return now >= startTime;
583     }
584 
585     function hasEnded() public view returns (bool) {
586         return now >= endTime || fundsRaised >= HARD_CAP;
587     }
588 
589     function validPurchase() internal view returns (bool) {
590         // Extended from 2 * 86400 to 200.000 seconds, since there's a 48 hour pause scheduled after phase 1
591         if(now <= (startTime + 200000) && msg.value < MIN_INVESTMENT_PHASE1) {
592             return false;
593         }
594         bool withinPeriod = now >= startTime && now <= endTime;
595         bool withinPurchaseLimits = msg.value >= MIN_INVESTMENT;
596         return withinPeriod && withinPurchaseLimits;
597     }
598 
599     function finalizeCurrentStage() internal {
600         uint256 _stageIndex = activeStage;
601 
602         if (_stageIndex == 0) {
603             softCapReached = true;
604             SoftCapReached();
605         } else if (_stageIndex == stageCaps.length - 1) {
606             hardCapReached = true;
607             HardCapReached();
608         }
609 
610         StageClosed(_stageIndex + 1);
611     }
612 }
613 
614 contract MintableToken is StandardToken, Ownable {
615   event Mint(address indexed to, uint256 amount);
616   event MintFinished();
617 
618   bool public mintingFinished = false;
619 
620 
621   modifier canMint() {
622     require(!mintingFinished);
623     _;
624   }
625 
626   /**
627    * @dev Function to mint tokens
628    * @param _to The address that will receive the minted tokens.
629    * @param _amount The amount of tokens to mint.
630    * @return A boolean that indicates if the operation was successful.
631    */
632   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
633     totalSupply_ = totalSupply_.add(_amount);
634     balances[_to] = balances[_to].add(_amount);
635     Mint(_to, _amount);
636     Transfer(address(0), _to, _amount);
637     return true;
638   }
639 
640   /**
641    * @dev Function to stop minting new tokens.
642    * @return True if the operation was successful.
643    */
644   function finishMinting() onlyOwner canMint public returns (bool) {
645     mintingFinished = true;
646     MintFinished();
647     return true;
648   }
649 }
650 
651 contract THToken is MintableToken {
652 
653     string public constant name = "Tradershub Token";
654     string public constant symbol = "THT";
655     uint8 public constant decimals = 18;
656 
657     bool public transferAllowed = false;
658 
659     event TransferAllowed(bool transferIsAllowed);
660 
661     modifier canTransfer() {
662         require(mintingFinished && transferAllowed);
663         _;
664     }
665 
666     function transferFrom(address from, address to, uint256 value) canTransfer public returns (bool) {
667         return super.transferFrom(from, to, value);
668     }
669 
670     function transfer(address to, uint256 value) canTransfer public returns (bool) {
671         return super.transfer(to, value);
672     }
673 
674     function endMinting(bool _transferAllowed) onlyOwner canMint public returns (bool) {
675         if (!_transferAllowed) {
676             // Only ever called if the sale failed to reach soft cap
677             selfdestruct(msg.sender);
678             return true;
679         }
680         transferAllowed = _transferAllowed;
681         TransferAllowed(_transferAllowed);
682         return super.finishMinting();
683     }
684 }